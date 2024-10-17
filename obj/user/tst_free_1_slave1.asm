
obj/user/tst_free_1_slave1:     file format elf32-i386


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
  800031:	e8 1c 00 00 00       	call   800052 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */
#include <inc/lib.h>


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 68             	sub    $0x68,%esp
	}
	//	/*Dummy malloc to enforce the UHEAP initializations*/
	//	malloc(0);
	/*=================================================*/
#else
	panic("not handled!");
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	68 a0 1a 80 00       	push   $0x801aa0
  800046:	6a 1a                	push   $0x1a
  800048:	68 ad 1a 80 00       	push   $0x801aad
  80004d:	e8 4d 01 00 00       	call   80019f <_panic>

00800052 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800052:	55                   	push   %ebp
  800053:	89 e5                	mov    %esp,%ebp
  800055:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800058:	e8 82 14 00 00       	call   8014df <sys_getenvindex>
  80005d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800060:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800063:	89 d0                	mov    %edx,%eax
  800065:	c1 e0 06             	shl    $0x6,%eax
  800068:	29 d0                	sub    %edx,%eax
  80006a:	c1 e0 02             	shl    $0x2,%eax
  80006d:	01 d0                	add    %edx,%eax
  80006f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800076:	01 c8                	add    %ecx,%eax
  800078:	c1 e0 03             	shl    $0x3,%eax
  80007b:	01 d0                	add    %edx,%eax
  80007d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800084:	29 c2                	sub    %eax,%edx
  800086:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80008d:	89 c2                	mov    %eax,%edx
  80008f:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800095:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80009a:	a1 04 30 80 00       	mov    0x803004,%eax
  80009f:	8a 40 20             	mov    0x20(%eax),%al
  8000a2:	84 c0                	test   %al,%al
  8000a4:	74 0d                	je     8000b3 <libmain+0x61>
		binaryname = myEnv->prog_name;
  8000a6:	a1 04 30 80 00       	mov    0x803004,%eax
  8000ab:	83 c0 20             	add    $0x20,%eax
  8000ae:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b7:	7e 0a                	jle    8000c3 <libmain+0x71>
		binaryname = argv[0];
  8000b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000bc:	8b 00                	mov    (%eax),%eax
  8000be:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000c3:	83 ec 08             	sub    $0x8,%esp
  8000c6:	ff 75 0c             	pushl  0xc(%ebp)
  8000c9:	ff 75 08             	pushl  0x8(%ebp)
  8000cc:	e8 67 ff ff ff       	call   800038 <_main>
  8000d1:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8000d4:	e8 8a 11 00 00       	call   801263 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8000d9:	83 ec 0c             	sub    $0xc,%esp
  8000dc:	68 e0 1a 80 00       	push   $0x801ae0
  8000e1:	e8 76 03 00 00       	call   80045c <cprintf>
  8000e6:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000e9:	a1 04 30 80 00       	mov    0x803004,%eax
  8000ee:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8000f4:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f9:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8000ff:	83 ec 04             	sub    $0x4,%esp
  800102:	52                   	push   %edx
  800103:	50                   	push   %eax
  800104:	68 08 1b 80 00       	push   $0x801b08
  800109:	e8 4e 03 00 00       	call   80045c <cprintf>
  80010e:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800111:	a1 04 30 80 00       	mov    0x803004,%eax
  800116:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80011c:	a1 04 30 80 00       	mov    0x803004,%eax
  800121:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800127:	a1 04 30 80 00       	mov    0x803004,%eax
  80012c:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800132:	51                   	push   %ecx
  800133:	52                   	push   %edx
  800134:	50                   	push   %eax
  800135:	68 30 1b 80 00       	push   $0x801b30
  80013a:	e8 1d 03 00 00       	call   80045c <cprintf>
  80013f:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800142:	a1 04 30 80 00       	mov    0x803004,%eax
  800147:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80014d:	83 ec 08             	sub    $0x8,%esp
  800150:	50                   	push   %eax
  800151:	68 88 1b 80 00       	push   $0x801b88
  800156:	e8 01 03 00 00       	call   80045c <cprintf>
  80015b:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80015e:	83 ec 0c             	sub    $0xc,%esp
  800161:	68 e0 1a 80 00       	push   $0x801ae0
  800166:	e8 f1 02 00 00       	call   80045c <cprintf>
  80016b:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80016e:	e8 0a 11 00 00       	call   80127d <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800173:	e8 19 00 00 00       	call   800191 <exit>
}
  800178:	90                   	nop
  800179:	c9                   	leave  
  80017a:	c3                   	ret    

0080017b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80017b:	55                   	push   %ebp
  80017c:	89 e5                	mov    %esp,%ebp
  80017e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	6a 00                	push   $0x0
  800186:	e8 20 13 00 00       	call   8014ab <sys_destroy_env>
  80018b:	83 c4 10             	add    $0x10,%esp
}
  80018e:	90                   	nop
  80018f:	c9                   	leave  
  800190:	c3                   	ret    

00800191 <exit>:

void
exit(void)
{
  800191:	55                   	push   %ebp
  800192:	89 e5                	mov    %esp,%ebp
  800194:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800197:	e8 75 13 00 00       	call   801511 <sys_exit_env>
}
  80019c:	90                   	nop
  80019d:	c9                   	leave  
  80019e:	c3                   	ret    

0080019f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001a5:	8d 45 10             	lea    0x10(%ebp),%eax
  8001a8:	83 c0 04             	add    $0x4,%eax
  8001ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001ae:	a1 24 30 80 00       	mov    0x803024,%eax
  8001b3:	85 c0                	test   %eax,%eax
  8001b5:	74 16                	je     8001cd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001b7:	a1 24 30 80 00       	mov    0x803024,%eax
  8001bc:	83 ec 08             	sub    $0x8,%esp
  8001bf:	50                   	push   %eax
  8001c0:	68 9c 1b 80 00       	push   $0x801b9c
  8001c5:	e8 92 02 00 00       	call   80045c <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001cd:	a1 00 30 80 00       	mov    0x803000,%eax
  8001d2:	ff 75 0c             	pushl  0xc(%ebp)
  8001d5:	ff 75 08             	pushl  0x8(%ebp)
  8001d8:	50                   	push   %eax
  8001d9:	68 a1 1b 80 00       	push   $0x801ba1
  8001de:	e8 79 02 00 00       	call   80045c <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e9:	83 ec 08             	sub    $0x8,%esp
  8001ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8001ef:	50                   	push   %eax
  8001f0:	e8 fc 01 00 00       	call   8003f1 <vcprintf>
  8001f5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8001f8:	83 ec 08             	sub    $0x8,%esp
  8001fb:	6a 00                	push   $0x0
  8001fd:	68 bd 1b 80 00       	push   $0x801bbd
  800202:	e8 ea 01 00 00       	call   8003f1 <vcprintf>
  800207:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80020a:	e8 82 ff ff ff       	call   800191 <exit>

	// should not return here
	while (1) ;
  80020f:	eb fe                	jmp    80020f <_panic+0x70>

00800211 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800211:	55                   	push   %ebp
  800212:	89 e5                	mov    %esp,%ebp
  800214:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800217:	a1 04 30 80 00       	mov    0x803004,%eax
  80021c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800222:	8b 45 0c             	mov    0xc(%ebp),%eax
  800225:	39 c2                	cmp    %eax,%edx
  800227:	74 14                	je     80023d <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800229:	83 ec 04             	sub    $0x4,%esp
  80022c:	68 c0 1b 80 00       	push   $0x801bc0
  800231:	6a 26                	push   $0x26
  800233:	68 0c 1c 80 00       	push   $0x801c0c
  800238:	e8 62 ff ff ff       	call   80019f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80023d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800244:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80024b:	e9 c5 00 00 00       	jmp    800315 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800250:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800253:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80025a:	8b 45 08             	mov    0x8(%ebp),%eax
  80025d:	01 d0                	add    %edx,%eax
  80025f:	8b 00                	mov    (%eax),%eax
  800261:	85 c0                	test   %eax,%eax
  800263:	75 08                	jne    80026d <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800265:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800268:	e9 a5 00 00 00       	jmp    800312 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80026d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800274:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80027b:	eb 69                	jmp    8002e6 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80027d:	a1 04 30 80 00       	mov    0x803004,%eax
  800282:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800288:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80028b:	89 d0                	mov    %edx,%eax
  80028d:	01 c0                	add    %eax,%eax
  80028f:	01 d0                	add    %edx,%eax
  800291:	c1 e0 03             	shl    $0x3,%eax
  800294:	01 c8                	add    %ecx,%eax
  800296:	8a 40 04             	mov    0x4(%eax),%al
  800299:	84 c0                	test   %al,%al
  80029b:	75 46                	jne    8002e3 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80029d:	a1 04 30 80 00       	mov    0x803004,%eax
  8002a2:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8002a8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002ab:	89 d0                	mov    %edx,%eax
  8002ad:	01 c0                	add    %eax,%eax
  8002af:	01 d0                	add    %edx,%eax
  8002b1:	c1 e0 03             	shl    $0x3,%eax
  8002b4:	01 c8                	add    %ecx,%eax
  8002b6:	8b 00                	mov    (%eax),%eax
  8002b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002c3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d2:	01 c8                	add    %ecx,%eax
  8002d4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002d6:	39 c2                	cmp    %eax,%edx
  8002d8:	75 09                	jne    8002e3 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002da:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002e1:	eb 15                	jmp    8002f8 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002e3:	ff 45 e8             	incl   -0x18(%ebp)
  8002e6:	a1 04 30 80 00       	mov    0x803004,%eax
  8002eb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8002f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002f4:	39 c2                	cmp    %eax,%edx
  8002f6:	77 85                	ja     80027d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8002f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8002fc:	75 14                	jne    800312 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 18 1c 80 00       	push   $0x801c18
  800306:	6a 3a                	push   $0x3a
  800308:	68 0c 1c 80 00       	push   $0x801c0c
  80030d:	e8 8d fe ff ff       	call   80019f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800312:	ff 45 f0             	incl   -0x10(%ebp)
  800315:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800318:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80031b:	0f 8c 2f ff ff ff    	jl     800250 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800321:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800328:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80032f:	eb 26                	jmp    800357 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800331:	a1 04 30 80 00       	mov    0x803004,%eax
  800336:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80033c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80033f:	89 d0                	mov    %edx,%eax
  800341:	01 c0                	add    %eax,%eax
  800343:	01 d0                	add    %edx,%eax
  800345:	c1 e0 03             	shl    $0x3,%eax
  800348:	01 c8                	add    %ecx,%eax
  80034a:	8a 40 04             	mov    0x4(%eax),%al
  80034d:	3c 01                	cmp    $0x1,%al
  80034f:	75 03                	jne    800354 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800351:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800354:	ff 45 e0             	incl   -0x20(%ebp)
  800357:	a1 04 30 80 00       	mov    0x803004,%eax
  80035c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800362:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800365:	39 c2                	cmp    %eax,%edx
  800367:	77 c8                	ja     800331 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80036f:	74 14                	je     800385 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800371:	83 ec 04             	sub    $0x4,%esp
  800374:	68 6c 1c 80 00       	push   $0x801c6c
  800379:	6a 44                	push   $0x44
  80037b:	68 0c 1c 80 00       	push   $0x801c0c
  800380:	e8 1a fe ff ff       	call   80019f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800385:	90                   	nop
  800386:	c9                   	leave  
  800387:	c3                   	ret    

00800388 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800388:	55                   	push   %ebp
  800389:	89 e5                	mov    %esp,%ebp
  80038b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80038e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800391:	8b 00                	mov    (%eax),%eax
  800393:	8d 48 01             	lea    0x1(%eax),%ecx
  800396:	8b 55 0c             	mov    0xc(%ebp),%edx
  800399:	89 0a                	mov    %ecx,(%edx)
  80039b:	8b 55 08             	mov    0x8(%ebp),%edx
  80039e:	88 d1                	mov    %dl,%cl
  8003a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003aa:	8b 00                	mov    (%eax),%eax
  8003ac:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b1:	75 2c                	jne    8003df <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003b3:	a0 08 30 80 00       	mov    0x803008,%al
  8003b8:	0f b6 c0             	movzbl %al,%eax
  8003bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003be:	8b 12                	mov    (%edx),%edx
  8003c0:	89 d1                	mov    %edx,%ecx
  8003c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c5:	83 c2 08             	add    $0x8,%edx
  8003c8:	83 ec 04             	sub    $0x4,%esp
  8003cb:	50                   	push   %eax
  8003cc:	51                   	push   %ecx
  8003cd:	52                   	push   %edx
  8003ce:	e8 4e 0e 00 00       	call   801221 <sys_cputs>
  8003d3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e2:	8b 40 04             	mov    0x4(%eax),%eax
  8003e5:	8d 50 01             	lea    0x1(%eax),%edx
  8003e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003eb:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003ee:	90                   	nop
  8003ef:	c9                   	leave  
  8003f0:	c3                   	ret    

008003f1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003f1:	55                   	push   %ebp
  8003f2:	89 e5                	mov    %esp,%ebp
  8003f4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003fa:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800401:	00 00 00 
	b.cnt = 0;
  800404:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80040b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80040e:	ff 75 0c             	pushl  0xc(%ebp)
  800411:	ff 75 08             	pushl  0x8(%ebp)
  800414:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80041a:	50                   	push   %eax
  80041b:	68 88 03 80 00       	push   $0x800388
  800420:	e8 11 02 00 00       	call   800636 <vprintfmt>
  800425:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800428:	a0 08 30 80 00       	mov    0x803008,%al
  80042d:	0f b6 c0             	movzbl %al,%eax
  800430:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	50                   	push   %eax
  80043a:	52                   	push   %edx
  80043b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800441:	83 c0 08             	add    $0x8,%eax
  800444:	50                   	push   %eax
  800445:	e8 d7 0d 00 00       	call   801221 <sys_cputs>
  80044a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80044d:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800454:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80045a:	c9                   	leave  
  80045b:	c3                   	ret    

0080045c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80045c:	55                   	push   %ebp
  80045d:	89 e5                	mov    %esp,%ebp
  80045f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800462:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800469:	8d 45 0c             	lea    0xc(%ebp),%eax
  80046c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80046f:	8b 45 08             	mov    0x8(%ebp),%eax
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	ff 75 f4             	pushl  -0xc(%ebp)
  800478:	50                   	push   %eax
  800479:	e8 73 ff ff ff       	call   8003f1 <vcprintf>
  80047e:	83 c4 10             	add    $0x10,%esp
  800481:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800484:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800487:	c9                   	leave  
  800488:	c3                   	ret    

00800489 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800489:	55                   	push   %ebp
  80048a:	89 e5                	mov    %esp,%ebp
  80048c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80048f:	e8 cf 0d 00 00       	call   801263 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800494:	8d 45 0c             	lea    0xc(%ebp),%eax
  800497:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80049a:	8b 45 08             	mov    0x8(%ebp),%eax
  80049d:	83 ec 08             	sub    $0x8,%esp
  8004a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a3:	50                   	push   %eax
  8004a4:	e8 48 ff ff ff       	call   8003f1 <vcprintf>
  8004a9:	83 c4 10             	add    $0x10,%esp
  8004ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004af:	e8 c9 0d 00 00       	call   80127d <sys_unlock_cons>
	return cnt;
  8004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004b7:	c9                   	leave  
  8004b8:	c3                   	ret    

008004b9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004b9:	55                   	push   %ebp
  8004ba:	89 e5                	mov    %esp,%ebp
  8004bc:	53                   	push   %ebx
  8004bd:	83 ec 14             	sub    $0x14,%esp
  8004c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004cc:	8b 45 18             	mov    0x18(%ebp),%eax
  8004cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004d7:	77 55                	ja     80052e <printnum+0x75>
  8004d9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004dc:	72 05                	jb     8004e3 <printnum+0x2a>
  8004de:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004e1:	77 4b                	ja     80052e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004e3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004e6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004e9:	8b 45 18             	mov    0x18(%ebp),%eax
  8004ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f1:	52                   	push   %edx
  8004f2:	50                   	push   %eax
  8004f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8004f9:	e8 26 13 00 00       	call   801824 <__udivdi3>
  8004fe:	83 c4 10             	add    $0x10,%esp
  800501:	83 ec 04             	sub    $0x4,%esp
  800504:	ff 75 20             	pushl  0x20(%ebp)
  800507:	53                   	push   %ebx
  800508:	ff 75 18             	pushl  0x18(%ebp)
  80050b:	52                   	push   %edx
  80050c:	50                   	push   %eax
  80050d:	ff 75 0c             	pushl  0xc(%ebp)
  800510:	ff 75 08             	pushl  0x8(%ebp)
  800513:	e8 a1 ff ff ff       	call   8004b9 <printnum>
  800518:	83 c4 20             	add    $0x20,%esp
  80051b:	eb 1a                	jmp    800537 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80051d:	83 ec 08             	sub    $0x8,%esp
  800520:	ff 75 0c             	pushl  0xc(%ebp)
  800523:	ff 75 20             	pushl  0x20(%ebp)
  800526:	8b 45 08             	mov    0x8(%ebp),%eax
  800529:	ff d0                	call   *%eax
  80052b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80052e:	ff 4d 1c             	decl   0x1c(%ebp)
  800531:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800535:	7f e6                	jg     80051d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800537:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80053a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80053f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800542:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800545:	53                   	push   %ebx
  800546:	51                   	push   %ecx
  800547:	52                   	push   %edx
  800548:	50                   	push   %eax
  800549:	e8 e6 13 00 00       	call   801934 <__umoddi3>
  80054e:	83 c4 10             	add    $0x10,%esp
  800551:	05 d4 1e 80 00       	add    $0x801ed4,%eax
  800556:	8a 00                	mov    (%eax),%al
  800558:	0f be c0             	movsbl %al,%eax
  80055b:	83 ec 08             	sub    $0x8,%esp
  80055e:	ff 75 0c             	pushl  0xc(%ebp)
  800561:	50                   	push   %eax
  800562:	8b 45 08             	mov    0x8(%ebp),%eax
  800565:	ff d0                	call   *%eax
  800567:	83 c4 10             	add    $0x10,%esp
}
  80056a:	90                   	nop
  80056b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80056e:	c9                   	leave  
  80056f:	c3                   	ret    

00800570 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800570:	55                   	push   %ebp
  800571:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800573:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800577:	7e 1c                	jle    800595 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	8b 00                	mov    (%eax),%eax
  80057e:	8d 50 08             	lea    0x8(%eax),%edx
  800581:	8b 45 08             	mov    0x8(%ebp),%eax
  800584:	89 10                	mov    %edx,(%eax)
  800586:	8b 45 08             	mov    0x8(%ebp),%eax
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	83 e8 08             	sub    $0x8,%eax
  80058e:	8b 50 04             	mov    0x4(%eax),%edx
  800591:	8b 00                	mov    (%eax),%eax
  800593:	eb 40                	jmp    8005d5 <getuint+0x65>
	else if (lflag)
  800595:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800599:	74 1e                	je     8005b9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80059b:	8b 45 08             	mov    0x8(%ebp),%eax
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	8d 50 04             	lea    0x4(%eax),%edx
  8005a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a6:	89 10                	mov    %edx,(%eax)
  8005a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ab:	8b 00                	mov    (%eax),%eax
  8005ad:	83 e8 04             	sub    $0x4,%eax
  8005b0:	8b 00                	mov    (%eax),%eax
  8005b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b7:	eb 1c                	jmp    8005d5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bc:	8b 00                	mov    (%eax),%eax
  8005be:	8d 50 04             	lea    0x4(%eax),%edx
  8005c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c4:	89 10                	mov    %edx,(%eax)
  8005c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c9:	8b 00                	mov    (%eax),%eax
  8005cb:	83 e8 04             	sub    $0x4,%eax
  8005ce:	8b 00                	mov    (%eax),%eax
  8005d0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005d5:	5d                   	pop    %ebp
  8005d6:	c3                   	ret    

008005d7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005d7:	55                   	push   %ebp
  8005d8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005da:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005de:	7e 1c                	jle    8005fc <getint+0x25>
		return va_arg(*ap, long long);
  8005e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e3:	8b 00                	mov    (%eax),%eax
  8005e5:	8d 50 08             	lea    0x8(%eax),%edx
  8005e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005eb:	89 10                	mov    %edx,(%eax)
  8005ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f0:	8b 00                	mov    (%eax),%eax
  8005f2:	83 e8 08             	sub    $0x8,%eax
  8005f5:	8b 50 04             	mov    0x4(%eax),%edx
  8005f8:	8b 00                	mov    (%eax),%eax
  8005fa:	eb 38                	jmp    800634 <getint+0x5d>
	else if (lflag)
  8005fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800600:	74 1a                	je     80061c <getint+0x45>
		return va_arg(*ap, long);
  800602:	8b 45 08             	mov    0x8(%ebp),%eax
  800605:	8b 00                	mov    (%eax),%eax
  800607:	8d 50 04             	lea    0x4(%eax),%edx
  80060a:	8b 45 08             	mov    0x8(%ebp),%eax
  80060d:	89 10                	mov    %edx,(%eax)
  80060f:	8b 45 08             	mov    0x8(%ebp),%eax
  800612:	8b 00                	mov    (%eax),%eax
  800614:	83 e8 04             	sub    $0x4,%eax
  800617:	8b 00                	mov    (%eax),%eax
  800619:	99                   	cltd   
  80061a:	eb 18                	jmp    800634 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80061c:	8b 45 08             	mov    0x8(%ebp),%eax
  80061f:	8b 00                	mov    (%eax),%eax
  800621:	8d 50 04             	lea    0x4(%eax),%edx
  800624:	8b 45 08             	mov    0x8(%ebp),%eax
  800627:	89 10                	mov    %edx,(%eax)
  800629:	8b 45 08             	mov    0x8(%ebp),%eax
  80062c:	8b 00                	mov    (%eax),%eax
  80062e:	83 e8 04             	sub    $0x4,%eax
  800631:	8b 00                	mov    (%eax),%eax
  800633:	99                   	cltd   
}
  800634:	5d                   	pop    %ebp
  800635:	c3                   	ret    

00800636 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800636:	55                   	push   %ebp
  800637:	89 e5                	mov    %esp,%ebp
  800639:	56                   	push   %esi
  80063a:	53                   	push   %ebx
  80063b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80063e:	eb 17                	jmp    800657 <vprintfmt+0x21>
			if (ch == '\0')
  800640:	85 db                	test   %ebx,%ebx
  800642:	0f 84 c1 03 00 00    	je     800a09 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	ff 75 0c             	pushl  0xc(%ebp)
  80064e:	53                   	push   %ebx
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	ff d0                	call   *%eax
  800654:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800657:	8b 45 10             	mov    0x10(%ebp),%eax
  80065a:	8d 50 01             	lea    0x1(%eax),%edx
  80065d:	89 55 10             	mov    %edx,0x10(%ebp)
  800660:	8a 00                	mov    (%eax),%al
  800662:	0f b6 d8             	movzbl %al,%ebx
  800665:	83 fb 25             	cmp    $0x25,%ebx
  800668:	75 d6                	jne    800640 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80066a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80066e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800675:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80067c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800683:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80068a:	8b 45 10             	mov    0x10(%ebp),%eax
  80068d:	8d 50 01             	lea    0x1(%eax),%edx
  800690:	89 55 10             	mov    %edx,0x10(%ebp)
  800693:	8a 00                	mov    (%eax),%al
  800695:	0f b6 d8             	movzbl %al,%ebx
  800698:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80069b:	83 f8 5b             	cmp    $0x5b,%eax
  80069e:	0f 87 3d 03 00 00    	ja     8009e1 <vprintfmt+0x3ab>
  8006a4:	8b 04 85 f8 1e 80 00 	mov    0x801ef8(,%eax,4),%eax
  8006ab:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006ad:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006b1:	eb d7                	jmp    80068a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006b3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006b7:	eb d1                	jmp    80068a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006b9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c3:	89 d0                	mov    %edx,%eax
  8006c5:	c1 e0 02             	shl    $0x2,%eax
  8006c8:	01 d0                	add    %edx,%eax
  8006ca:	01 c0                	add    %eax,%eax
  8006cc:	01 d8                	add    %ebx,%eax
  8006ce:	83 e8 30             	sub    $0x30,%eax
  8006d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d7:	8a 00                	mov    (%eax),%al
  8006d9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006dc:	83 fb 2f             	cmp    $0x2f,%ebx
  8006df:	7e 3e                	jle    80071f <vprintfmt+0xe9>
  8006e1:	83 fb 39             	cmp    $0x39,%ebx
  8006e4:	7f 39                	jg     80071f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006e9:	eb d5                	jmp    8006c0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	83 c0 04             	add    $0x4,%eax
  8006f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	83 e8 04             	sub    $0x4,%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006ff:	eb 1f                	jmp    800720 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800701:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800705:	79 83                	jns    80068a <vprintfmt+0x54>
				width = 0;
  800707:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80070e:	e9 77 ff ff ff       	jmp    80068a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800713:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80071a:	e9 6b ff ff ff       	jmp    80068a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80071f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800720:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800724:	0f 89 60 ff ff ff    	jns    80068a <vprintfmt+0x54>
				width = precision, precision = -1;
  80072a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80072d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800730:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800737:	e9 4e ff ff ff       	jmp    80068a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80073c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80073f:	e9 46 ff ff ff       	jmp    80068a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800744:	8b 45 14             	mov    0x14(%ebp),%eax
  800747:	83 c0 04             	add    $0x4,%eax
  80074a:	89 45 14             	mov    %eax,0x14(%ebp)
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	83 e8 04             	sub    $0x4,%eax
  800753:	8b 00                	mov    (%eax),%eax
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	ff 75 0c             	pushl  0xc(%ebp)
  80075b:	50                   	push   %eax
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	ff d0                	call   *%eax
  800761:	83 c4 10             	add    $0x10,%esp
			break;
  800764:	e9 9b 02 00 00       	jmp    800a04 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800769:	8b 45 14             	mov    0x14(%ebp),%eax
  80076c:	83 c0 04             	add    $0x4,%eax
  80076f:	89 45 14             	mov    %eax,0x14(%ebp)
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	83 e8 04             	sub    $0x4,%eax
  800778:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80077a:	85 db                	test   %ebx,%ebx
  80077c:	79 02                	jns    800780 <vprintfmt+0x14a>
				err = -err;
  80077e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800780:	83 fb 64             	cmp    $0x64,%ebx
  800783:	7f 0b                	jg     800790 <vprintfmt+0x15a>
  800785:	8b 34 9d 40 1d 80 00 	mov    0x801d40(,%ebx,4),%esi
  80078c:	85 f6                	test   %esi,%esi
  80078e:	75 19                	jne    8007a9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800790:	53                   	push   %ebx
  800791:	68 e5 1e 80 00       	push   $0x801ee5
  800796:	ff 75 0c             	pushl  0xc(%ebp)
  800799:	ff 75 08             	pushl  0x8(%ebp)
  80079c:	e8 70 02 00 00       	call   800a11 <printfmt>
  8007a1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007a4:	e9 5b 02 00 00       	jmp    800a04 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007a9:	56                   	push   %esi
  8007aa:	68 ee 1e 80 00       	push   $0x801eee
  8007af:	ff 75 0c             	pushl  0xc(%ebp)
  8007b2:	ff 75 08             	pushl  0x8(%ebp)
  8007b5:	e8 57 02 00 00       	call   800a11 <printfmt>
  8007ba:	83 c4 10             	add    $0x10,%esp
			break;
  8007bd:	e9 42 02 00 00       	jmp    800a04 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	83 c0 04             	add    $0x4,%eax
  8007c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	83 e8 04             	sub    $0x4,%eax
  8007d1:	8b 30                	mov    (%eax),%esi
  8007d3:	85 f6                	test   %esi,%esi
  8007d5:	75 05                	jne    8007dc <vprintfmt+0x1a6>
				p = "(null)";
  8007d7:	be f1 1e 80 00       	mov    $0x801ef1,%esi
			if (width > 0 && padc != '-')
  8007dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e0:	7e 6d                	jle    80084f <vprintfmt+0x219>
  8007e2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007e6:	74 67                	je     80084f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007eb:	83 ec 08             	sub    $0x8,%esp
  8007ee:	50                   	push   %eax
  8007ef:	56                   	push   %esi
  8007f0:	e8 1e 03 00 00       	call   800b13 <strnlen>
  8007f5:	83 c4 10             	add    $0x10,%esp
  8007f8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007fb:	eb 16                	jmp    800813 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007fd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800801:	83 ec 08             	sub    $0x8,%esp
  800804:	ff 75 0c             	pushl  0xc(%ebp)
  800807:	50                   	push   %eax
  800808:	8b 45 08             	mov    0x8(%ebp),%eax
  80080b:	ff d0                	call   *%eax
  80080d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800810:	ff 4d e4             	decl   -0x1c(%ebp)
  800813:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800817:	7f e4                	jg     8007fd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800819:	eb 34                	jmp    80084f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80081b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80081f:	74 1c                	je     80083d <vprintfmt+0x207>
  800821:	83 fb 1f             	cmp    $0x1f,%ebx
  800824:	7e 05                	jle    80082b <vprintfmt+0x1f5>
  800826:	83 fb 7e             	cmp    $0x7e,%ebx
  800829:	7e 12                	jle    80083d <vprintfmt+0x207>
					putch('?', putdat);
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	ff 75 0c             	pushl  0xc(%ebp)
  800831:	6a 3f                	push   $0x3f
  800833:	8b 45 08             	mov    0x8(%ebp),%eax
  800836:	ff d0                	call   *%eax
  800838:	83 c4 10             	add    $0x10,%esp
  80083b:	eb 0f                	jmp    80084c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	53                   	push   %ebx
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	ff d0                	call   *%eax
  800849:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80084c:	ff 4d e4             	decl   -0x1c(%ebp)
  80084f:	89 f0                	mov    %esi,%eax
  800851:	8d 70 01             	lea    0x1(%eax),%esi
  800854:	8a 00                	mov    (%eax),%al
  800856:	0f be d8             	movsbl %al,%ebx
  800859:	85 db                	test   %ebx,%ebx
  80085b:	74 24                	je     800881 <vprintfmt+0x24b>
  80085d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800861:	78 b8                	js     80081b <vprintfmt+0x1e5>
  800863:	ff 4d e0             	decl   -0x20(%ebp)
  800866:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80086a:	79 af                	jns    80081b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80086c:	eb 13                	jmp    800881 <vprintfmt+0x24b>
				putch(' ', putdat);
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	ff 75 0c             	pushl  0xc(%ebp)
  800874:	6a 20                	push   $0x20
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	ff d0                	call   *%eax
  80087b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80087e:	ff 4d e4             	decl   -0x1c(%ebp)
  800881:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800885:	7f e7                	jg     80086e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800887:	e9 78 01 00 00       	jmp    800a04 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80088c:	83 ec 08             	sub    $0x8,%esp
  80088f:	ff 75 e8             	pushl  -0x18(%ebp)
  800892:	8d 45 14             	lea    0x14(%ebp),%eax
  800895:	50                   	push   %eax
  800896:	e8 3c fd ff ff       	call   8005d7 <getint>
  80089b:	83 c4 10             	add    $0x10,%esp
  80089e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008aa:	85 d2                	test   %edx,%edx
  8008ac:	79 23                	jns    8008d1 <vprintfmt+0x29b>
				putch('-', putdat);
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	ff 75 0c             	pushl  0xc(%ebp)
  8008b4:	6a 2d                	push   $0x2d
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	ff d0                	call   *%eax
  8008bb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c4:	f7 d8                	neg    %eax
  8008c6:	83 d2 00             	adc    $0x0,%edx
  8008c9:	f7 da                	neg    %edx
  8008cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ce:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008d1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008d8:	e9 bc 00 00 00       	jmp    800999 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008dd:	83 ec 08             	sub    $0x8,%esp
  8008e0:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e3:	8d 45 14             	lea    0x14(%ebp),%eax
  8008e6:	50                   	push   %eax
  8008e7:	e8 84 fc ff ff       	call   800570 <getuint>
  8008ec:	83 c4 10             	add    $0x10,%esp
  8008ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008f5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008fc:	e9 98 00 00 00       	jmp    800999 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800901:	83 ec 08             	sub    $0x8,%esp
  800904:	ff 75 0c             	pushl  0xc(%ebp)
  800907:	6a 58                	push   $0x58
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	ff d0                	call   *%eax
  80090e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800911:	83 ec 08             	sub    $0x8,%esp
  800914:	ff 75 0c             	pushl  0xc(%ebp)
  800917:	6a 58                	push   $0x58
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	ff d0                	call   *%eax
  80091e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800921:	83 ec 08             	sub    $0x8,%esp
  800924:	ff 75 0c             	pushl  0xc(%ebp)
  800927:	6a 58                	push   $0x58
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	ff d0                	call   *%eax
  80092e:	83 c4 10             	add    $0x10,%esp
			break;
  800931:	e9 ce 00 00 00       	jmp    800a04 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	ff 75 0c             	pushl  0xc(%ebp)
  80093c:	6a 30                	push   $0x30
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	ff d0                	call   *%eax
  800943:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800946:	83 ec 08             	sub    $0x8,%esp
  800949:	ff 75 0c             	pushl  0xc(%ebp)
  80094c:	6a 78                	push   $0x78
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	ff d0                	call   *%eax
  800953:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800956:	8b 45 14             	mov    0x14(%ebp),%eax
  800959:	83 c0 04             	add    $0x4,%eax
  80095c:	89 45 14             	mov    %eax,0x14(%ebp)
  80095f:	8b 45 14             	mov    0x14(%ebp),%eax
  800962:	83 e8 04             	sub    $0x4,%eax
  800965:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800967:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80096a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800971:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800978:	eb 1f                	jmp    800999 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80097a:	83 ec 08             	sub    $0x8,%esp
  80097d:	ff 75 e8             	pushl  -0x18(%ebp)
  800980:	8d 45 14             	lea    0x14(%ebp),%eax
  800983:	50                   	push   %eax
  800984:	e8 e7 fb ff ff       	call   800570 <getuint>
  800989:	83 c4 10             	add    $0x10,%esp
  80098c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80098f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800992:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800999:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80099d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009a0:	83 ec 04             	sub    $0x4,%esp
  8009a3:	52                   	push   %edx
  8009a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009a7:	50                   	push   %eax
  8009a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ab:	ff 75 f0             	pushl  -0x10(%ebp)
  8009ae:	ff 75 0c             	pushl  0xc(%ebp)
  8009b1:	ff 75 08             	pushl  0x8(%ebp)
  8009b4:	e8 00 fb ff ff       	call   8004b9 <printnum>
  8009b9:	83 c4 20             	add    $0x20,%esp
			break;
  8009bc:	eb 46                	jmp    800a04 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009be:	83 ec 08             	sub    $0x8,%esp
  8009c1:	ff 75 0c             	pushl  0xc(%ebp)
  8009c4:	53                   	push   %ebx
  8009c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c8:	ff d0                	call   *%eax
  8009ca:	83 c4 10             	add    $0x10,%esp
			break;
  8009cd:	eb 35                	jmp    800a04 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009cf:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8009d6:	eb 2c                	jmp    800a04 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009d8:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8009df:	eb 23                	jmp    800a04 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009e1:	83 ec 08             	sub    $0x8,%esp
  8009e4:	ff 75 0c             	pushl  0xc(%ebp)
  8009e7:	6a 25                	push   $0x25
  8009e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ec:	ff d0                	call   *%eax
  8009ee:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009f1:	ff 4d 10             	decl   0x10(%ebp)
  8009f4:	eb 03                	jmp    8009f9 <vprintfmt+0x3c3>
  8009f6:	ff 4d 10             	decl   0x10(%ebp)
  8009f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fc:	48                   	dec    %eax
  8009fd:	8a 00                	mov    (%eax),%al
  8009ff:	3c 25                	cmp    $0x25,%al
  800a01:	75 f3                	jne    8009f6 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a03:	90                   	nop
		}
	}
  800a04:	e9 35 fc ff ff       	jmp    80063e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a09:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a0d:	5b                   	pop    %ebx
  800a0e:	5e                   	pop    %esi
  800a0f:	5d                   	pop    %ebp
  800a10:	c3                   	ret    

00800a11 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a17:	8d 45 10             	lea    0x10(%ebp),%eax
  800a1a:	83 c0 04             	add    $0x4,%eax
  800a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a20:	8b 45 10             	mov    0x10(%ebp),%eax
  800a23:	ff 75 f4             	pushl  -0xc(%ebp)
  800a26:	50                   	push   %eax
  800a27:	ff 75 0c             	pushl  0xc(%ebp)
  800a2a:	ff 75 08             	pushl  0x8(%ebp)
  800a2d:	e8 04 fc ff ff       	call   800636 <vprintfmt>
  800a32:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a35:	90                   	nop
  800a36:	c9                   	leave  
  800a37:	c3                   	ret    

00800a38 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3e:	8b 40 08             	mov    0x8(%eax),%eax
  800a41:	8d 50 01             	lea    0x1(%eax),%edx
  800a44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a47:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4d:	8b 10                	mov    (%eax),%edx
  800a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a52:	8b 40 04             	mov    0x4(%eax),%eax
  800a55:	39 c2                	cmp    %eax,%edx
  800a57:	73 12                	jae    800a6b <sprintputch+0x33>
		*b->buf++ = ch;
  800a59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5c:	8b 00                	mov    (%eax),%eax
  800a5e:	8d 48 01             	lea    0x1(%eax),%ecx
  800a61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a64:	89 0a                	mov    %ecx,(%edx)
  800a66:	8b 55 08             	mov    0x8(%ebp),%edx
  800a69:	88 10                	mov    %dl,(%eax)
}
  800a6b:	90                   	nop
  800a6c:	5d                   	pop    %ebp
  800a6d:	c3                   	ret    

00800a6e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	01 d0                	add    %edx,%eax
  800a85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a93:	74 06                	je     800a9b <vsnprintf+0x2d>
  800a95:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a99:	7f 07                	jg     800aa2 <vsnprintf+0x34>
		return -E_INVAL;
  800a9b:	b8 03 00 00 00       	mov    $0x3,%eax
  800aa0:	eb 20                	jmp    800ac2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800aa2:	ff 75 14             	pushl  0x14(%ebp)
  800aa5:	ff 75 10             	pushl  0x10(%ebp)
  800aa8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aab:	50                   	push   %eax
  800aac:	68 38 0a 80 00       	push   $0x800a38
  800ab1:	e8 80 fb ff ff       	call   800636 <vprintfmt>
  800ab6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ab9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800abc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ac2:	c9                   	leave  
  800ac3:	c3                   	ret    

00800ac4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800aca:	8d 45 10             	lea    0x10(%ebp),%eax
  800acd:	83 c0 04             	add    $0x4,%eax
  800ad0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ad3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad9:	50                   	push   %eax
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	ff 75 08             	pushl  0x8(%ebp)
  800ae0:	e8 89 ff ff ff       	call   800a6e <vsnprintf>
  800ae5:	83 c4 10             	add    $0x10,%esp
  800ae8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aee:	c9                   	leave  
  800aef:	c3                   	ret    

00800af0 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800af6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800afd:	eb 06                	jmp    800b05 <strlen+0x15>
		n++;
  800aff:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b02:	ff 45 08             	incl   0x8(%ebp)
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	8a 00                	mov    (%eax),%al
  800b0a:	84 c0                	test   %al,%al
  800b0c:	75 f1                	jne    800aff <strlen+0xf>
		n++;
	return n;
  800b0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b11:	c9                   	leave  
  800b12:	c3                   	ret    

00800b13 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
  800b16:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b19:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b20:	eb 09                	jmp    800b2b <strnlen+0x18>
		n++;
  800b22:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b25:	ff 45 08             	incl   0x8(%ebp)
  800b28:	ff 4d 0c             	decl   0xc(%ebp)
  800b2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b2f:	74 09                	je     800b3a <strnlen+0x27>
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	8a 00                	mov    (%eax),%al
  800b36:	84 c0                	test   %al,%al
  800b38:	75 e8                	jne    800b22 <strnlen+0xf>
		n++;
	return n;
  800b3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b3d:	c9                   	leave  
  800b3e:	c3                   	ret    

00800b3f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b3f:	55                   	push   %ebp
  800b40:	89 e5                	mov    %esp,%ebp
  800b42:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b4b:	90                   	nop
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	8d 50 01             	lea    0x1(%eax),%edx
  800b52:	89 55 08             	mov    %edx,0x8(%ebp)
  800b55:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b58:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b5b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b5e:	8a 12                	mov    (%edx),%dl
  800b60:	88 10                	mov    %dl,(%eax)
  800b62:	8a 00                	mov    (%eax),%al
  800b64:	84 c0                	test   %al,%al
  800b66:	75 e4                	jne    800b4c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b68:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b6b:	c9                   	leave  
  800b6c:	c3                   	ret    

00800b6d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b6d:	55                   	push   %ebp
  800b6e:	89 e5                	mov    %esp,%ebp
  800b70:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b80:	eb 1f                	jmp    800ba1 <strncpy+0x34>
		*dst++ = *src;
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	8d 50 01             	lea    0x1(%eax),%edx
  800b88:	89 55 08             	mov    %edx,0x8(%ebp)
  800b8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b8e:	8a 12                	mov    (%edx),%dl
  800b90:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b95:	8a 00                	mov    (%eax),%al
  800b97:	84 c0                	test   %al,%al
  800b99:	74 03                	je     800b9e <strncpy+0x31>
			src++;
  800b9b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b9e:	ff 45 fc             	incl   -0x4(%ebp)
  800ba1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ba4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ba7:	72 d9                	jb     800b82 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ba9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bac:	c9                   	leave  
  800bad:	c3                   	ret    

00800bae <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bbe:	74 30                	je     800bf0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bc0:	eb 16                	jmp    800bd8 <strlcpy+0x2a>
			*dst++ = *src++;
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	8d 50 01             	lea    0x1(%eax),%edx
  800bc8:	89 55 08             	mov    %edx,0x8(%ebp)
  800bcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bce:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bd1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bd4:	8a 12                	mov    (%edx),%dl
  800bd6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bd8:	ff 4d 10             	decl   0x10(%ebp)
  800bdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bdf:	74 09                	je     800bea <strlcpy+0x3c>
  800be1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be4:	8a 00                	mov    (%eax),%al
  800be6:	84 c0                	test   %al,%al
  800be8:	75 d8                	jne    800bc2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bf0:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf6:	29 c2                	sub    %eax,%edx
  800bf8:	89 d0                	mov    %edx,%eax
}
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bff:	eb 06                	jmp    800c07 <strcmp+0xb>
		p++, q++;
  800c01:	ff 45 08             	incl   0x8(%ebp)
  800c04:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	8a 00                	mov    (%eax),%al
  800c0c:	84 c0                	test   %al,%al
  800c0e:	74 0e                	je     800c1e <strcmp+0x22>
  800c10:	8b 45 08             	mov    0x8(%ebp),%eax
  800c13:	8a 10                	mov    (%eax),%dl
  800c15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c18:	8a 00                	mov    (%eax),%al
  800c1a:	38 c2                	cmp    %al,%dl
  800c1c:	74 e3                	je     800c01 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	8a 00                	mov    (%eax),%al
  800c23:	0f b6 d0             	movzbl %al,%edx
  800c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c29:	8a 00                	mov    (%eax),%al
  800c2b:	0f b6 c0             	movzbl %al,%eax
  800c2e:	29 c2                	sub    %eax,%edx
  800c30:	89 d0                	mov    %edx,%eax
}
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    

00800c34 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c37:	eb 09                	jmp    800c42 <strncmp+0xe>
		n--, p++, q++;
  800c39:	ff 4d 10             	decl   0x10(%ebp)
  800c3c:	ff 45 08             	incl   0x8(%ebp)
  800c3f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c46:	74 17                	je     800c5f <strncmp+0x2b>
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	84 c0                	test   %al,%al
  800c4f:	74 0e                	je     800c5f <strncmp+0x2b>
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	8a 10                	mov    (%eax),%dl
  800c56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c59:	8a 00                	mov    (%eax),%al
  800c5b:	38 c2                	cmp    %al,%dl
  800c5d:	74 da                	je     800c39 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c63:	75 07                	jne    800c6c <strncmp+0x38>
		return 0;
  800c65:	b8 00 00 00 00       	mov    $0x0,%eax
  800c6a:	eb 14                	jmp    800c80 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	8a 00                	mov    (%eax),%al
  800c71:	0f b6 d0             	movzbl %al,%edx
  800c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c77:	8a 00                	mov    (%eax),%al
  800c79:	0f b6 c0             	movzbl %al,%eax
  800c7c:	29 c2                	sub    %eax,%edx
  800c7e:	89 d0                	mov    %edx,%eax
}
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    

00800c82 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	83 ec 04             	sub    $0x4,%esp
  800c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c8e:	eb 12                	jmp    800ca2 <strchr+0x20>
		if (*s == c)
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8a 00                	mov    (%eax),%al
  800c95:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c98:	75 05                	jne    800c9f <strchr+0x1d>
			return (char *) s;
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	eb 11                	jmp    800cb0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c9f:	ff 45 08             	incl   0x8(%ebp)
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	8a 00                	mov    (%eax),%al
  800ca7:	84 c0                	test   %al,%al
  800ca9:	75 e5                	jne    800c90 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb0:	c9                   	leave  
  800cb1:	c3                   	ret    

00800cb2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cb2:	55                   	push   %ebp
  800cb3:	89 e5                	mov    %esp,%ebp
  800cb5:	83 ec 04             	sub    $0x4,%esp
  800cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cbe:	eb 0d                	jmp    800ccd <strfind+0x1b>
		if (*s == c)
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	8a 00                	mov    (%eax),%al
  800cc5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cc8:	74 0e                	je     800cd8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cca:	ff 45 08             	incl   0x8(%ebp)
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	8a 00                	mov    (%eax),%al
  800cd2:	84 c0                	test   %al,%al
  800cd4:	75 ea                	jne    800cc0 <strfind+0xe>
  800cd6:	eb 01                	jmp    800cd9 <strfind+0x27>
		if (*s == c)
			break;
  800cd8:	90                   	nop
	return (char *) s;
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cdc:	c9                   	leave  
  800cdd:	c3                   	ret    

00800cde <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cea:	8b 45 10             	mov    0x10(%ebp),%eax
  800ced:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cf0:	eb 0e                	jmp    800d00 <memset+0x22>
		*p++ = c;
  800cf2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf5:	8d 50 01             	lea    0x1(%eax),%edx
  800cf8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800cfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfe:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d00:	ff 4d f8             	decl   -0x8(%ebp)
  800d03:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d07:	79 e9                	jns    800cf2 <memset+0x14>
		*p++ = c;

	return v;
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d0c:	c9                   	leave  
  800d0d:	c3                   	ret    

00800d0e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d20:	eb 16                	jmp    800d38 <memcpy+0x2a>
		*d++ = *s++;
  800d22:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d25:	8d 50 01             	lea    0x1(%eax),%edx
  800d28:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d2b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d31:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d34:	8a 12                	mov    (%edx),%dl
  800d36:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d38:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d3e:	89 55 10             	mov    %edx,0x10(%ebp)
  800d41:	85 c0                	test   %eax,%eax
  800d43:	75 dd                	jne    800d22 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d48:	c9                   	leave  
  800d49:	c3                   	ret    

00800d4a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d5f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d62:	73 50                	jae    800db4 <memmove+0x6a>
  800d64:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d67:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6a:	01 d0                	add    %edx,%eax
  800d6c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d6f:	76 43                	jbe    800db4 <memmove+0x6a>
		s += n;
  800d71:	8b 45 10             	mov    0x10(%ebp),%eax
  800d74:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d77:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d7d:	eb 10                	jmp    800d8f <memmove+0x45>
			*--d = *--s;
  800d7f:	ff 4d f8             	decl   -0x8(%ebp)
  800d82:	ff 4d fc             	decl   -0x4(%ebp)
  800d85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d88:	8a 10                	mov    (%eax),%dl
  800d8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d92:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d95:	89 55 10             	mov    %edx,0x10(%ebp)
  800d98:	85 c0                	test   %eax,%eax
  800d9a:	75 e3                	jne    800d7f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d9c:	eb 23                	jmp    800dc1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da1:	8d 50 01             	lea    0x1(%eax),%edx
  800da4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800da7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800daa:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dad:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800db0:	8a 12                	mov    (%edx),%dl
  800db2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800db4:	8b 45 10             	mov    0x10(%ebp),%eax
  800db7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dba:	89 55 10             	mov    %edx,0x10(%ebp)
  800dbd:	85 c0                	test   %eax,%eax
  800dbf:	75 dd                	jne    800d9e <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc4:	c9                   	leave  
  800dc5:	c3                   	ret    

00800dc6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dd8:	eb 2a                	jmp    800e04 <memcmp+0x3e>
		if (*s1 != *s2)
  800dda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ddd:	8a 10                	mov    (%eax),%dl
  800ddf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de2:	8a 00                	mov    (%eax),%al
  800de4:	38 c2                	cmp    %al,%dl
  800de6:	74 16                	je     800dfe <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800de8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800deb:	8a 00                	mov    (%eax),%al
  800ded:	0f b6 d0             	movzbl %al,%edx
  800df0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df3:	8a 00                	mov    (%eax),%al
  800df5:	0f b6 c0             	movzbl %al,%eax
  800df8:	29 c2                	sub    %eax,%edx
  800dfa:	89 d0                	mov    %edx,%eax
  800dfc:	eb 18                	jmp    800e16 <memcmp+0x50>
		s1++, s2++;
  800dfe:	ff 45 fc             	incl   -0x4(%ebp)
  800e01:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e04:	8b 45 10             	mov    0x10(%ebp),%eax
  800e07:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e0a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e0d:	85 c0                	test   %eax,%eax
  800e0f:	75 c9                	jne    800dda <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e16:	c9                   	leave  
  800e17:	c3                   	ret    

00800e18 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e18:	55                   	push   %ebp
  800e19:	89 e5                	mov    %esp,%ebp
  800e1b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e21:	8b 45 10             	mov    0x10(%ebp),%eax
  800e24:	01 d0                	add    %edx,%eax
  800e26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e29:	eb 15                	jmp    800e40 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	8a 00                	mov    (%eax),%al
  800e30:	0f b6 d0             	movzbl %al,%edx
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	0f b6 c0             	movzbl %al,%eax
  800e39:	39 c2                	cmp    %eax,%edx
  800e3b:	74 0d                	je     800e4a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e3d:	ff 45 08             	incl   0x8(%ebp)
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e46:	72 e3                	jb     800e2b <memfind+0x13>
  800e48:	eb 01                	jmp    800e4b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e4a:	90                   	nop
	return (void *) s;
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4e:	c9                   	leave  
  800e4f:	c3                   	ret    

00800e50 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e5d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e64:	eb 03                	jmp    800e69 <strtol+0x19>
		s++;
  800e66:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	3c 20                	cmp    $0x20,%al
  800e70:	74 f4                	je     800e66 <strtol+0x16>
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
  800e75:	8a 00                	mov    (%eax),%al
  800e77:	3c 09                	cmp    $0x9,%al
  800e79:	74 eb                	je     800e66 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	8a 00                	mov    (%eax),%al
  800e80:	3c 2b                	cmp    $0x2b,%al
  800e82:	75 05                	jne    800e89 <strtol+0x39>
		s++;
  800e84:	ff 45 08             	incl   0x8(%ebp)
  800e87:	eb 13                	jmp    800e9c <strtol+0x4c>
	else if (*s == '-')
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	3c 2d                	cmp    $0x2d,%al
  800e90:	75 0a                	jne    800e9c <strtol+0x4c>
		s++, neg = 1;
  800e92:	ff 45 08             	incl   0x8(%ebp)
  800e95:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e9c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea0:	74 06                	je     800ea8 <strtol+0x58>
  800ea2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ea6:	75 20                	jne    800ec8 <strtol+0x78>
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	8a 00                	mov    (%eax),%al
  800ead:	3c 30                	cmp    $0x30,%al
  800eaf:	75 17                	jne    800ec8 <strtol+0x78>
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	40                   	inc    %eax
  800eb5:	8a 00                	mov    (%eax),%al
  800eb7:	3c 78                	cmp    $0x78,%al
  800eb9:	75 0d                	jne    800ec8 <strtol+0x78>
		s += 2, base = 16;
  800ebb:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ebf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ec6:	eb 28                	jmp    800ef0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ec8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecc:	75 15                	jne    800ee3 <strtol+0x93>
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	3c 30                	cmp    $0x30,%al
  800ed5:	75 0c                	jne    800ee3 <strtol+0x93>
		s++, base = 8;
  800ed7:	ff 45 08             	incl   0x8(%ebp)
  800eda:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ee1:	eb 0d                	jmp    800ef0 <strtol+0xa0>
	else if (base == 0)
  800ee3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee7:	75 07                	jne    800ef0 <strtol+0xa0>
		base = 10;
  800ee9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	3c 2f                	cmp    $0x2f,%al
  800ef7:	7e 19                	jle    800f12 <strtol+0xc2>
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	8a 00                	mov    (%eax),%al
  800efe:	3c 39                	cmp    $0x39,%al
  800f00:	7f 10                	jg     800f12 <strtol+0xc2>
			dig = *s - '0';
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	0f be c0             	movsbl %al,%eax
  800f0a:	83 e8 30             	sub    $0x30,%eax
  800f0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f10:	eb 42                	jmp    800f54 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	8a 00                	mov    (%eax),%al
  800f17:	3c 60                	cmp    $0x60,%al
  800f19:	7e 19                	jle    800f34 <strtol+0xe4>
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	8a 00                	mov    (%eax),%al
  800f20:	3c 7a                	cmp    $0x7a,%al
  800f22:	7f 10                	jg     800f34 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
  800f27:	8a 00                	mov    (%eax),%al
  800f29:	0f be c0             	movsbl %al,%eax
  800f2c:	83 e8 57             	sub    $0x57,%eax
  800f2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f32:	eb 20                	jmp    800f54 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	8a 00                	mov    (%eax),%al
  800f39:	3c 40                	cmp    $0x40,%al
  800f3b:	7e 39                	jle    800f76 <strtol+0x126>
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	8a 00                	mov    (%eax),%al
  800f42:	3c 5a                	cmp    $0x5a,%al
  800f44:	7f 30                	jg     800f76 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	0f be c0             	movsbl %al,%eax
  800f4e:	83 e8 37             	sub    $0x37,%eax
  800f51:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f57:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f5a:	7d 19                	jge    800f75 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f5c:	ff 45 08             	incl   0x8(%ebp)
  800f5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f62:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f66:	89 c2                	mov    %eax,%edx
  800f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f6b:	01 d0                	add    %edx,%eax
  800f6d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f70:	e9 7b ff ff ff       	jmp    800ef0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f75:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f7a:	74 08                	je     800f84 <strtol+0x134>
		*endptr = (char *) s;
  800f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f82:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f84:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f88:	74 07                	je     800f91 <strtol+0x141>
  800f8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f8d:	f7 d8                	neg    %eax
  800f8f:	eb 03                	jmp    800f94 <strtol+0x144>
  800f91:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f94:	c9                   	leave  
  800f95:	c3                   	ret    

00800f96 <ltostr>:

void
ltostr(long value, char *str)
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
  800f99:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fa3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800faa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fae:	79 13                	jns    800fc3 <ltostr+0x2d>
	{
		neg = 1;
  800fb0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fba:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fbd:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fc0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fcb:	99                   	cltd   
  800fcc:	f7 f9                	idiv   %ecx
  800fce:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd4:	8d 50 01             	lea    0x1(%eax),%edx
  800fd7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fda:	89 c2                	mov    %eax,%edx
  800fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdf:	01 d0                	add    %edx,%eax
  800fe1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fe4:	83 c2 30             	add    $0x30,%edx
  800fe7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fe9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fec:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ff1:	f7 e9                	imul   %ecx
  800ff3:	c1 fa 02             	sar    $0x2,%edx
  800ff6:	89 c8                	mov    %ecx,%eax
  800ff8:	c1 f8 1f             	sar    $0x1f,%eax
  800ffb:	29 c2                	sub    %eax,%edx
  800ffd:	89 d0                	mov    %edx,%eax
  800fff:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801002:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801006:	75 bb                	jne    800fc3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801008:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80100f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801012:	48                   	dec    %eax
  801013:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801016:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80101a:	74 3d                	je     801059 <ltostr+0xc3>
		start = 1 ;
  80101c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801023:	eb 34                	jmp    801059 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801025:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801028:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102b:	01 d0                	add    %edx,%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801032:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801035:	8b 45 0c             	mov    0xc(%ebp),%eax
  801038:	01 c2                	add    %eax,%edx
  80103a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80103d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801040:	01 c8                	add    %ecx,%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801046:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104c:	01 c2                	add    %eax,%edx
  80104e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801051:	88 02                	mov    %al,(%edx)
		start++ ;
  801053:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801056:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80105f:	7c c4                	jl     801025 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801061:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801064:	8b 45 0c             	mov    0xc(%ebp),%eax
  801067:	01 d0                	add    %edx,%eax
  801069:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80106c:	90                   	nop
  80106d:	c9                   	leave  
  80106e:	c3                   	ret    

0080106f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80106f:	55                   	push   %ebp
  801070:	89 e5                	mov    %esp,%ebp
  801072:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801075:	ff 75 08             	pushl  0x8(%ebp)
  801078:	e8 73 fa ff ff       	call   800af0 <strlen>
  80107d:	83 c4 04             	add    $0x4,%esp
  801080:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801083:	ff 75 0c             	pushl  0xc(%ebp)
  801086:	e8 65 fa ff ff       	call   800af0 <strlen>
  80108b:	83 c4 04             	add    $0x4,%esp
  80108e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801091:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801098:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80109f:	eb 17                	jmp    8010b8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a7:	01 c2                	add    %eax,%edx
  8010a9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	01 c8                	add    %ecx,%eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010b5:	ff 45 fc             	incl   -0x4(%ebp)
  8010b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010bb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010be:	7c e1                	jl     8010a1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010c7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010ce:	eb 1f                	jmp    8010ef <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d3:	8d 50 01             	lea    0x1(%eax),%edx
  8010d6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010d9:	89 c2                	mov    %eax,%edx
  8010db:	8b 45 10             	mov    0x10(%ebp),%eax
  8010de:	01 c2                	add    %eax,%edx
  8010e0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e6:	01 c8                	add    %ecx,%eax
  8010e8:	8a 00                	mov    (%eax),%al
  8010ea:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010ec:	ff 45 f8             	incl   -0x8(%ebp)
  8010ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010f5:	7c d9                	jl     8010d0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fd:	01 d0                	add    %edx,%eax
  8010ff:	c6 00 00             	movb   $0x0,(%eax)
}
  801102:	90                   	nop
  801103:	c9                   	leave  
  801104:	c3                   	ret    

00801105 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801108:	8b 45 14             	mov    0x14(%ebp),%eax
  80110b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801111:	8b 45 14             	mov    0x14(%ebp),%eax
  801114:	8b 00                	mov    (%eax),%eax
  801116:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80111d:	8b 45 10             	mov    0x10(%ebp),%eax
  801120:	01 d0                	add    %edx,%eax
  801122:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801128:	eb 0c                	jmp    801136 <strsplit+0x31>
			*string++ = 0;
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	8d 50 01             	lea    0x1(%eax),%edx
  801130:	89 55 08             	mov    %edx,0x8(%ebp)
  801133:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	8a 00                	mov    (%eax),%al
  80113b:	84 c0                	test   %al,%al
  80113d:	74 18                	je     801157 <strsplit+0x52>
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	0f be c0             	movsbl %al,%eax
  801147:	50                   	push   %eax
  801148:	ff 75 0c             	pushl  0xc(%ebp)
  80114b:	e8 32 fb ff ff       	call   800c82 <strchr>
  801150:	83 c4 08             	add    $0x8,%esp
  801153:	85 c0                	test   %eax,%eax
  801155:	75 d3                	jne    80112a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	8a 00                	mov    (%eax),%al
  80115c:	84 c0                	test   %al,%al
  80115e:	74 5a                	je     8011ba <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801160:	8b 45 14             	mov    0x14(%ebp),%eax
  801163:	8b 00                	mov    (%eax),%eax
  801165:	83 f8 0f             	cmp    $0xf,%eax
  801168:	75 07                	jne    801171 <strsplit+0x6c>
		{
			return 0;
  80116a:	b8 00 00 00 00       	mov    $0x0,%eax
  80116f:	eb 66                	jmp    8011d7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801171:	8b 45 14             	mov    0x14(%ebp),%eax
  801174:	8b 00                	mov    (%eax),%eax
  801176:	8d 48 01             	lea    0x1(%eax),%ecx
  801179:	8b 55 14             	mov    0x14(%ebp),%edx
  80117c:	89 0a                	mov    %ecx,(%edx)
  80117e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801185:	8b 45 10             	mov    0x10(%ebp),%eax
  801188:	01 c2                	add    %eax,%edx
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80118f:	eb 03                	jmp    801194 <strsplit+0x8f>
			string++;
  801191:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	8a 00                	mov    (%eax),%al
  801199:	84 c0                	test   %al,%al
  80119b:	74 8b                	je     801128 <strsplit+0x23>
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	0f be c0             	movsbl %al,%eax
  8011a5:	50                   	push   %eax
  8011a6:	ff 75 0c             	pushl  0xc(%ebp)
  8011a9:	e8 d4 fa ff ff       	call   800c82 <strchr>
  8011ae:	83 c4 08             	add    $0x8,%esp
  8011b1:	85 c0                	test   %eax,%eax
  8011b3:	74 dc                	je     801191 <strsplit+0x8c>
			string++;
	}
  8011b5:	e9 6e ff ff ff       	jmp    801128 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011ba:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8011be:	8b 00                	mov    (%eax),%eax
  8011c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ca:	01 d0                	add    %edx,%eax
  8011cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011d2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011d7:	c9                   	leave  
  8011d8:	c3                   	ret    

008011d9 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8011df:	83 ec 04             	sub    $0x4,%esp
  8011e2:	68 68 20 80 00       	push   $0x802068
  8011e7:	68 3f 01 00 00       	push   $0x13f
  8011ec:	68 8a 20 80 00       	push   $0x80208a
  8011f1:	e8 a9 ef ff ff       	call   80019f <_panic>

008011f6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	57                   	push   %edi
  8011fa:	56                   	push   %esi
  8011fb:	53                   	push   %ebx
  8011fc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8b 55 0c             	mov    0xc(%ebp),%edx
  801205:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801208:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80120b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80120e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801211:	cd 30                	int    $0x30
  801213:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801216:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801219:	83 c4 10             	add    $0x10,%esp
  80121c:	5b                   	pop    %ebx
  80121d:	5e                   	pop    %esi
  80121e:	5f                   	pop    %edi
  80121f:	5d                   	pop    %ebp
  801220:	c3                   	ret    

00801221 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	83 ec 04             	sub    $0x4,%esp
  801227:	8b 45 10             	mov    0x10(%ebp),%eax
  80122a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80122d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	6a 00                	push   $0x0
  801236:	6a 00                	push   $0x0
  801238:	52                   	push   %edx
  801239:	ff 75 0c             	pushl  0xc(%ebp)
  80123c:	50                   	push   %eax
  80123d:	6a 00                	push   $0x0
  80123f:	e8 b2 ff ff ff       	call   8011f6 <syscall>
  801244:	83 c4 18             	add    $0x18,%esp
}
  801247:	90                   	nop
  801248:	c9                   	leave  
  801249:	c3                   	ret    

0080124a <sys_cgetc>:

int
sys_cgetc(void)
{
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80124d:	6a 00                	push   $0x0
  80124f:	6a 00                	push   $0x0
  801251:	6a 00                	push   $0x0
  801253:	6a 00                	push   $0x0
  801255:	6a 00                	push   $0x0
  801257:	6a 02                	push   $0x2
  801259:	e8 98 ff ff ff       	call   8011f6 <syscall>
  80125e:	83 c4 18             	add    $0x18,%esp
}
  801261:	c9                   	leave  
  801262:	c3                   	ret    

00801263 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801263:	55                   	push   %ebp
  801264:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801266:	6a 00                	push   $0x0
  801268:	6a 00                	push   $0x0
  80126a:	6a 00                	push   $0x0
  80126c:	6a 00                	push   $0x0
  80126e:	6a 00                	push   $0x0
  801270:	6a 03                	push   $0x3
  801272:	e8 7f ff ff ff       	call   8011f6 <syscall>
  801277:	83 c4 18             	add    $0x18,%esp
}
  80127a:	90                   	nop
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    

0080127d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801280:	6a 00                	push   $0x0
  801282:	6a 00                	push   $0x0
  801284:	6a 00                	push   $0x0
  801286:	6a 00                	push   $0x0
  801288:	6a 00                	push   $0x0
  80128a:	6a 04                	push   $0x4
  80128c:	e8 65 ff ff ff       	call   8011f6 <syscall>
  801291:	83 c4 18             	add    $0x18,%esp
}
  801294:	90                   	nop
  801295:	c9                   	leave  
  801296:	c3                   	ret    

00801297 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80129a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	6a 00                	push   $0x0
  8012a2:	6a 00                	push   $0x0
  8012a4:	6a 00                	push   $0x0
  8012a6:	52                   	push   %edx
  8012a7:	50                   	push   %eax
  8012a8:	6a 08                	push   $0x8
  8012aa:	e8 47 ff ff ff       	call   8011f6 <syscall>
  8012af:	83 c4 18             	add    $0x18,%esp
}
  8012b2:	c9                   	leave  
  8012b3:	c3                   	ret    

008012b4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	56                   	push   %esi
  8012b8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012b9:	8b 75 18             	mov    0x18(%ebp),%esi
  8012bc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	56                   	push   %esi
  8012c9:	53                   	push   %ebx
  8012ca:	51                   	push   %ecx
  8012cb:	52                   	push   %edx
  8012cc:	50                   	push   %eax
  8012cd:	6a 09                	push   $0x9
  8012cf:	e8 22 ff ff ff       	call   8011f6 <syscall>
  8012d4:	83 c4 18             	add    $0x18,%esp
}
  8012d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012da:	5b                   	pop    %ebx
  8012db:	5e                   	pop    %esi
  8012dc:	5d                   	pop    %ebp
  8012dd:	c3                   	ret    

008012de <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	6a 00                	push   $0x0
  8012e9:	6a 00                	push   $0x0
  8012eb:	6a 00                	push   $0x0
  8012ed:	52                   	push   %edx
  8012ee:	50                   	push   %eax
  8012ef:	6a 0a                	push   $0xa
  8012f1:	e8 00 ff ff ff       	call   8011f6 <syscall>
  8012f6:	83 c4 18             	add    $0x18,%esp
}
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012fe:	6a 00                	push   $0x0
  801300:	6a 00                	push   $0x0
  801302:	6a 00                	push   $0x0
  801304:	ff 75 0c             	pushl  0xc(%ebp)
  801307:	ff 75 08             	pushl  0x8(%ebp)
  80130a:	6a 0b                	push   $0xb
  80130c:	e8 e5 fe ff ff       	call   8011f6 <syscall>
  801311:	83 c4 18             	add    $0x18,%esp
}
  801314:	c9                   	leave  
  801315:	c3                   	ret    

00801316 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801319:	6a 00                	push   $0x0
  80131b:	6a 00                	push   $0x0
  80131d:	6a 00                	push   $0x0
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	6a 0c                	push   $0xc
  801325:	e8 cc fe ff ff       	call   8011f6 <syscall>
  80132a:	83 c4 18             	add    $0x18,%esp
}
  80132d:	c9                   	leave  
  80132e:	c3                   	ret    

0080132f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801332:	6a 00                	push   $0x0
  801334:	6a 00                	push   $0x0
  801336:	6a 00                	push   $0x0
  801338:	6a 00                	push   $0x0
  80133a:	6a 00                	push   $0x0
  80133c:	6a 0d                	push   $0xd
  80133e:	e8 b3 fe ff ff       	call   8011f6 <syscall>
  801343:	83 c4 18             	add    $0x18,%esp
}
  801346:	c9                   	leave  
  801347:	c3                   	ret    

00801348 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	6a 00                	push   $0x0
  801355:	6a 0e                	push   $0xe
  801357:	e8 9a fe ff ff       	call   8011f6 <syscall>
  80135c:	83 c4 18             	add    $0x18,%esp
}
  80135f:	c9                   	leave  
  801360:	c3                   	ret    

00801361 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801364:	6a 00                	push   $0x0
  801366:	6a 00                	push   $0x0
  801368:	6a 00                	push   $0x0
  80136a:	6a 00                	push   $0x0
  80136c:	6a 00                	push   $0x0
  80136e:	6a 0f                	push   $0xf
  801370:	e8 81 fe ff ff       	call   8011f6 <syscall>
  801375:	83 c4 18             	add    $0x18,%esp
}
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80137d:	6a 00                	push   $0x0
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	ff 75 08             	pushl  0x8(%ebp)
  801388:	6a 10                	push   $0x10
  80138a:	e8 67 fe ff ff       	call   8011f6 <syscall>
  80138f:	83 c4 18             	add    $0x18,%esp
}
  801392:	c9                   	leave  
  801393:	c3                   	ret    

00801394 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801397:	6a 00                	push   $0x0
  801399:	6a 00                	push   $0x0
  80139b:	6a 00                	push   $0x0
  80139d:	6a 00                	push   $0x0
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 11                	push   $0x11
  8013a3:	e8 4e fe ff ff       	call   8011f6 <syscall>
  8013a8:	83 c4 18             	add    $0x18,%esp
}
  8013ab:	90                   	nop
  8013ac:	c9                   	leave  
  8013ad:	c3                   	ret    

008013ae <sys_cputc>:

void
sys_cputc(const char c)
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
  8013b1:	83 ec 04             	sub    $0x4,%esp
  8013b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013ba:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 00                	push   $0x0
  8013c6:	50                   	push   %eax
  8013c7:	6a 01                	push   $0x1
  8013c9:	e8 28 fe ff ff       	call   8011f6 <syscall>
  8013ce:	83 c4 18             	add    $0x18,%esp
}
  8013d1:	90                   	nop
  8013d2:	c9                   	leave  
  8013d3:	c3                   	ret    

008013d4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	6a 00                	push   $0x0
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 14                	push   $0x14
  8013e3:	e8 0e fe ff ff       	call   8011f6 <syscall>
  8013e8:	83 c4 18             	add    $0x18,%esp
}
  8013eb:	90                   	nop
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    

008013ee <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	83 ec 04             	sub    $0x4,%esp
  8013f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013fa:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013fd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	6a 00                	push   $0x0
  801406:	51                   	push   %ecx
  801407:	52                   	push   %edx
  801408:	ff 75 0c             	pushl  0xc(%ebp)
  80140b:	50                   	push   %eax
  80140c:	6a 15                	push   $0x15
  80140e:	e8 e3 fd ff ff       	call   8011f6 <syscall>
  801413:	83 c4 18             	add    $0x18,%esp
}
  801416:	c9                   	leave  
  801417:	c3                   	ret    

00801418 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80141b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141e:	8b 45 08             	mov    0x8(%ebp),%eax
  801421:	6a 00                	push   $0x0
  801423:	6a 00                	push   $0x0
  801425:	6a 00                	push   $0x0
  801427:	52                   	push   %edx
  801428:	50                   	push   %eax
  801429:	6a 16                	push   $0x16
  80142b:	e8 c6 fd ff ff       	call   8011f6 <syscall>
  801430:	83 c4 18             	add    $0x18,%esp
}
  801433:	c9                   	leave  
  801434:	c3                   	ret    

00801435 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801438:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80143b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143e:	8b 45 08             	mov    0x8(%ebp),%eax
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	51                   	push   %ecx
  801446:	52                   	push   %edx
  801447:	50                   	push   %eax
  801448:	6a 17                	push   $0x17
  80144a:	e8 a7 fd ff ff       	call   8011f6 <syscall>
  80144f:	83 c4 18             	add    $0x18,%esp
}
  801452:	c9                   	leave  
  801453:	c3                   	ret    

00801454 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801457:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145a:	8b 45 08             	mov    0x8(%ebp),%eax
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	6a 00                	push   $0x0
  801463:	52                   	push   %edx
  801464:	50                   	push   %eax
  801465:	6a 18                	push   $0x18
  801467:	e8 8a fd ff ff       	call   8011f6 <syscall>
  80146c:	83 c4 18             	add    $0x18,%esp
}
  80146f:	c9                   	leave  
  801470:	c3                   	ret    

00801471 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	6a 00                	push   $0x0
  801479:	ff 75 14             	pushl  0x14(%ebp)
  80147c:	ff 75 10             	pushl  0x10(%ebp)
  80147f:	ff 75 0c             	pushl  0xc(%ebp)
  801482:	50                   	push   %eax
  801483:	6a 19                	push   $0x19
  801485:	e8 6c fd ff ff       	call   8011f6 <syscall>
  80148a:	83 c4 18             	add    $0x18,%esp
}
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <sys_run_env>:

void sys_run_env(int32 envId)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	6a 00                	push   $0x0
  80149d:	50                   	push   %eax
  80149e:	6a 1a                	push   $0x1a
  8014a0:	e8 51 fd ff ff       	call   8011f6 <syscall>
  8014a5:	83 c4 18             	add    $0x18,%esp
}
  8014a8:	90                   	nop
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	50                   	push   %eax
  8014ba:	6a 1b                	push   $0x1b
  8014bc:	e8 35 fd ff ff       	call   8011f6 <syscall>
  8014c1:	83 c4 18             	add    $0x18,%esp
}
  8014c4:	c9                   	leave  
  8014c5:	c3                   	ret    

008014c6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 00                	push   $0x0
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 05                	push   $0x5
  8014d5:	e8 1c fd ff ff       	call   8011f6 <syscall>
  8014da:	83 c4 18             	add    $0x18,%esp
}
  8014dd:	c9                   	leave  
  8014de:	c3                   	ret    

008014df <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 06                	push   $0x6
  8014ee:	e8 03 fd ff ff       	call   8011f6 <syscall>
  8014f3:	83 c4 18             	add    $0x18,%esp
}
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 07                	push   $0x7
  801507:	e8 ea fc ff ff       	call   8011f6 <syscall>
  80150c:	83 c4 18             	add    $0x18,%esp
}
  80150f:	c9                   	leave  
  801510:	c3                   	ret    

00801511 <sys_exit_env>:


void sys_exit_env(void)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 1c                	push   $0x1c
  801520:	e8 d1 fc ff ff       	call   8011f6 <syscall>
  801525:	83 c4 18             	add    $0x18,%esp
}
  801528:	90                   	nop
  801529:	c9                   	leave  
  80152a:	c3                   	ret    

0080152b <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80152b:	55                   	push   %ebp
  80152c:	89 e5                	mov    %esp,%ebp
  80152e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801531:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801534:	8d 50 04             	lea    0x4(%eax),%edx
  801537:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80153a:	6a 00                	push   $0x0
  80153c:	6a 00                	push   $0x0
  80153e:	6a 00                	push   $0x0
  801540:	52                   	push   %edx
  801541:	50                   	push   %eax
  801542:	6a 1d                	push   $0x1d
  801544:	e8 ad fc ff ff       	call   8011f6 <syscall>
  801549:	83 c4 18             	add    $0x18,%esp
	return result;
  80154c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80154f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801552:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801555:	89 01                	mov    %eax,(%ecx)
  801557:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	c9                   	leave  
  80155e:	c2 04 00             	ret    $0x4

00801561 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	ff 75 10             	pushl  0x10(%ebp)
  80156b:	ff 75 0c             	pushl  0xc(%ebp)
  80156e:	ff 75 08             	pushl  0x8(%ebp)
  801571:	6a 13                	push   $0x13
  801573:	e8 7e fc ff ff       	call   8011f6 <syscall>
  801578:	83 c4 18             	add    $0x18,%esp
	return ;
  80157b:	90                   	nop
}
  80157c:	c9                   	leave  
  80157d:	c3                   	ret    

0080157e <sys_rcr2>:
uint32 sys_rcr2()
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 1e                	push   $0x1e
  80158d:	e8 64 fc ff ff       	call   8011f6 <syscall>
  801592:	83 c4 18             	add    $0x18,%esp
}
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	83 ec 04             	sub    $0x4,%esp
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015a3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	50                   	push   %eax
  8015b0:	6a 1f                	push   $0x1f
  8015b2:	e8 3f fc ff ff       	call   8011f6 <syscall>
  8015b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8015ba:	90                   	nop
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <rsttst>:
void rsttst()
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 21                	push   $0x21
  8015cc:	e8 25 fc ff ff       	call   8011f6 <syscall>
  8015d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8015d4:	90                   	nop
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
  8015da:	83 ec 04             	sub    $0x4,%esp
  8015dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015e3:	8b 55 18             	mov    0x18(%ebp),%edx
  8015e6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015ea:	52                   	push   %edx
  8015eb:	50                   	push   %eax
  8015ec:	ff 75 10             	pushl  0x10(%ebp)
  8015ef:	ff 75 0c             	pushl  0xc(%ebp)
  8015f2:	ff 75 08             	pushl  0x8(%ebp)
  8015f5:	6a 20                	push   $0x20
  8015f7:	e8 fa fb ff ff       	call   8011f6 <syscall>
  8015fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8015ff:	90                   	nop
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <chktst>:
void chktst(uint32 n)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	ff 75 08             	pushl  0x8(%ebp)
  801610:	6a 22                	push   $0x22
  801612:	e8 df fb ff ff       	call   8011f6 <syscall>
  801617:	83 c4 18             	add    $0x18,%esp
	return ;
  80161a:	90                   	nop
}
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <inctst>:

void inctst()
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 23                	push   $0x23
  80162c:	e8 c5 fb ff ff       	call   8011f6 <syscall>
  801631:	83 c4 18             	add    $0x18,%esp
	return ;
  801634:	90                   	nop
}
  801635:	c9                   	leave  
  801636:	c3                   	ret    

00801637 <gettst>:
uint32 gettst()
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 24                	push   $0x24
  801646:	e8 ab fb ff ff       	call   8011f6 <syscall>
  80164b:	83 c4 18             	add    $0x18,%esp
}
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 25                	push   $0x25
  801662:	e8 8f fb ff ff       	call   8011f6 <syscall>
  801667:	83 c4 18             	add    $0x18,%esp
  80166a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80166d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801671:	75 07                	jne    80167a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801673:	b8 01 00 00 00       	mov    $0x1,%eax
  801678:	eb 05                	jmp    80167f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80167a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 25                	push   $0x25
  801693:	e8 5e fb ff ff       	call   8011f6 <syscall>
  801698:	83 c4 18             	add    $0x18,%esp
  80169b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80169e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016a2:	75 07                	jne    8016ab <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016a4:	b8 01 00 00 00       	mov    $0x1,%eax
  8016a9:	eb 05                	jmp    8016b0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
  8016b5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 25                	push   $0x25
  8016c4:	e8 2d fb ff ff       	call   8011f6 <syscall>
  8016c9:	83 c4 18             	add    $0x18,%esp
  8016cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016cf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016d3:	75 07                	jne    8016dc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8016da:	eb 05                	jmp    8016e1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    

008016e3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 25                	push   $0x25
  8016f5:	e8 fc fa ff ff       	call   8011f6 <syscall>
  8016fa:	83 c4 18             	add    $0x18,%esp
  8016fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801700:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801704:	75 07                	jne    80170d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801706:	b8 01 00 00 00       	mov    $0x1,%eax
  80170b:	eb 05                	jmp    801712 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80170d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	ff 75 08             	pushl  0x8(%ebp)
  801722:	6a 26                	push   $0x26
  801724:	e8 cd fa ff ff       	call   8011f6 <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
	return ;
  80172c:	90                   	nop
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801733:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801736:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801739:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173c:	8b 45 08             	mov    0x8(%ebp),%eax
  80173f:	6a 00                	push   $0x0
  801741:	53                   	push   %ebx
  801742:	51                   	push   %ecx
  801743:	52                   	push   %edx
  801744:	50                   	push   %eax
  801745:	6a 27                	push   $0x27
  801747:	e8 aa fa ff ff       	call   8011f6 <syscall>
  80174c:	83 c4 18             	add    $0x18,%esp
}
  80174f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801752:	c9                   	leave  
  801753:	c3                   	ret    

00801754 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801757:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175a:	8b 45 08             	mov    0x8(%ebp),%eax
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	52                   	push   %edx
  801764:	50                   	push   %eax
  801765:	6a 28                	push   $0x28
  801767:	e8 8a fa ff ff       	call   8011f6 <syscall>
  80176c:	83 c4 18             	add    $0x18,%esp
}
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801774:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801777:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177a:	8b 45 08             	mov    0x8(%ebp),%eax
  80177d:	6a 00                	push   $0x0
  80177f:	51                   	push   %ecx
  801780:	ff 75 10             	pushl  0x10(%ebp)
  801783:	52                   	push   %edx
  801784:	50                   	push   %eax
  801785:	6a 29                	push   $0x29
  801787:	e8 6a fa ff ff       	call   8011f6 <syscall>
  80178c:	83 c4 18             	add    $0x18,%esp
}
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	ff 75 10             	pushl  0x10(%ebp)
  80179b:	ff 75 0c             	pushl  0xc(%ebp)
  80179e:	ff 75 08             	pushl  0x8(%ebp)
  8017a1:	6a 12                	push   $0x12
  8017a3:	e8 4e fa ff ff       	call   8011f6 <syscall>
  8017a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8017ab:	90                   	nop
}
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8017b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	52                   	push   %edx
  8017be:	50                   	push   %eax
  8017bf:	6a 2a                	push   $0x2a
  8017c1:	e8 30 fa ff ff       	call   8011f6 <syscall>
  8017c6:	83 c4 18             	add    $0x18,%esp
	return;
  8017c9:	90                   	nop
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8017d2:	83 ec 04             	sub    $0x4,%esp
  8017d5:	68 97 20 80 00       	push   $0x802097
  8017da:	68 2e 01 00 00       	push   $0x12e
  8017df:	68 ab 20 80 00       	push   $0x8020ab
  8017e4:	e8 b6 e9 ff ff       	call   80019f <_panic>

008017e9 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8017ef:	83 ec 04             	sub    $0x4,%esp
  8017f2:	68 97 20 80 00       	push   $0x802097
  8017f7:	68 35 01 00 00       	push   $0x135
  8017fc:	68 ab 20 80 00       	push   $0x8020ab
  801801:	e8 99 e9 ff ff       	call   80019f <_panic>

00801806 <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  80180c:	83 ec 04             	sub    $0x4,%esp
  80180f:	68 97 20 80 00       	push   $0x802097
  801814:	68 3b 01 00 00       	push   $0x13b
  801819:	68 ab 20 80 00       	push   $0x8020ab
  80181e:	e8 7c e9 ff ff       	call   80019f <_panic>
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
