
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
  800045:	e8 d0 17 00 00       	call   80181a <sys_allocate_user_mem>
  80004a:	83 c4 10             	add    $0x10,%esp
	inctst();
  80004d:	e8 df 15 00 00       	call   801631 <inctst>
	panic("tst system calls #2 failed: sys_allocate_user_mem is called with invalid params\nThe env must be killed and shouldn't return here.");
  800052:	83 ec 04             	sub    $0x4,%esp
  800055:	68 a0 1a 80 00       	push   $0x801aa0
  80005a:	6a 0a                	push   $0xa
  80005c:	68 22 1b 80 00       	push   $0x801b22
  800061:	e8 4d 01 00 00       	call   8001b3 <_panic>

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
  80006c:	e8 82 14 00 00       	call   8014f3 <sys_getenvindex>
  800071:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800074:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800077:	89 d0                	mov    %edx,%eax
  800079:	c1 e0 06             	shl    $0x6,%eax
  80007c:	29 d0                	sub    %edx,%eax
  80007e:	c1 e0 02             	shl    $0x2,%eax
  800081:	01 d0                	add    %edx,%eax
  800083:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80008a:	01 c8                	add    %ecx,%eax
  80008c:	c1 e0 03             	shl    $0x3,%eax
  80008f:	01 d0                	add    %edx,%eax
  800091:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800098:	29 c2                	sub    %eax,%edx
  80009a:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8000a1:	89 c2                	mov    %eax,%edx
  8000a3:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8000a9:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000ae:	a1 04 30 80 00       	mov    0x803004,%eax
  8000b3:	8a 40 20             	mov    0x20(%eax),%al
  8000b6:	84 c0                	test   %al,%al
  8000b8:	74 0d                	je     8000c7 <libmain+0x61>
		binaryname = myEnv->prog_name;
  8000ba:	a1 04 30 80 00       	mov    0x803004,%eax
  8000bf:	83 c0 20             	add    $0x20,%eax
  8000c2:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000cb:	7e 0a                	jle    8000d7 <libmain+0x71>
		binaryname = argv[0];
  8000cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000d0:	8b 00                	mov    (%eax),%eax
  8000d2:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000d7:	83 ec 08             	sub    $0x8,%esp
  8000da:	ff 75 0c             	pushl  0xc(%ebp)
  8000dd:	ff 75 08             	pushl  0x8(%ebp)
  8000e0:	e8 53 ff ff ff       	call   800038 <_main>
  8000e5:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8000e8:	e8 8a 11 00 00       	call   801277 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 58 1b 80 00       	push   $0x801b58
  8000f5:	e8 76 03 00 00       	call   800470 <cprintf>
  8000fa:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000fd:	a1 04 30 80 00       	mov    0x803004,%eax
  800102:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800108:	a1 04 30 80 00       	mov    0x803004,%eax
  80010d:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800113:	83 ec 04             	sub    $0x4,%esp
  800116:	52                   	push   %edx
  800117:	50                   	push   %eax
  800118:	68 80 1b 80 00       	push   $0x801b80
  80011d:	e8 4e 03 00 00       	call   800470 <cprintf>
  800122:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800125:	a1 04 30 80 00       	mov    0x803004,%eax
  80012a:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800130:	a1 04 30 80 00       	mov    0x803004,%eax
  800135:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80013b:	a1 04 30 80 00       	mov    0x803004,%eax
  800140:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800146:	51                   	push   %ecx
  800147:	52                   	push   %edx
  800148:	50                   	push   %eax
  800149:	68 a8 1b 80 00       	push   $0x801ba8
  80014e:	e8 1d 03 00 00       	call   800470 <cprintf>
  800153:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800156:	a1 04 30 80 00       	mov    0x803004,%eax
  80015b:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800161:	83 ec 08             	sub    $0x8,%esp
  800164:	50                   	push   %eax
  800165:	68 00 1c 80 00       	push   $0x801c00
  80016a:	e8 01 03 00 00       	call   800470 <cprintf>
  80016f:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800172:	83 ec 0c             	sub    $0xc,%esp
  800175:	68 58 1b 80 00       	push   $0x801b58
  80017a:	e8 f1 02 00 00       	call   800470 <cprintf>
  80017f:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800182:	e8 0a 11 00 00       	call   801291 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800187:	e8 19 00 00 00       	call   8001a5 <exit>
}
  80018c:	90                   	nop
  80018d:	c9                   	leave  
  80018e:	c3                   	ret    

0080018f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	6a 00                	push   $0x0
  80019a:	e8 20 13 00 00       	call   8014bf <sys_destroy_env>
  80019f:	83 c4 10             	add    $0x10,%esp
}
  8001a2:	90                   	nop
  8001a3:	c9                   	leave  
  8001a4:	c3                   	ret    

008001a5 <exit>:

void
exit(void)
{
  8001a5:	55                   	push   %ebp
  8001a6:	89 e5                	mov    %esp,%ebp
  8001a8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001ab:	e8 75 13 00 00       	call   801525 <sys_exit_env>
}
  8001b0:	90                   	nop
  8001b1:	c9                   	leave  
  8001b2:	c3                   	ret    

008001b3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001b3:	55                   	push   %ebp
  8001b4:	89 e5                	mov    %esp,%ebp
  8001b6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001b9:	8d 45 10             	lea    0x10(%ebp),%eax
  8001bc:	83 c0 04             	add    $0x4,%eax
  8001bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001c2:	a1 24 30 80 00       	mov    0x803024,%eax
  8001c7:	85 c0                	test   %eax,%eax
  8001c9:	74 16                	je     8001e1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001cb:	a1 24 30 80 00       	mov    0x803024,%eax
  8001d0:	83 ec 08             	sub    $0x8,%esp
  8001d3:	50                   	push   %eax
  8001d4:	68 14 1c 80 00       	push   $0x801c14
  8001d9:	e8 92 02 00 00       	call   800470 <cprintf>
  8001de:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001e1:	a1 00 30 80 00       	mov    0x803000,%eax
  8001e6:	ff 75 0c             	pushl  0xc(%ebp)
  8001e9:	ff 75 08             	pushl  0x8(%ebp)
  8001ec:	50                   	push   %eax
  8001ed:	68 19 1c 80 00       	push   $0x801c19
  8001f2:	e8 79 02 00 00       	call   800470 <cprintf>
  8001f7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8001fd:	83 ec 08             	sub    $0x8,%esp
  800200:	ff 75 f4             	pushl  -0xc(%ebp)
  800203:	50                   	push   %eax
  800204:	e8 fc 01 00 00       	call   800405 <vcprintf>
  800209:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80020c:	83 ec 08             	sub    $0x8,%esp
  80020f:	6a 00                	push   $0x0
  800211:	68 35 1c 80 00       	push   $0x801c35
  800216:	e8 ea 01 00 00       	call   800405 <vcprintf>
  80021b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80021e:	e8 82 ff ff ff       	call   8001a5 <exit>

	// should not return here
	while (1) ;
  800223:	eb fe                	jmp    800223 <_panic+0x70>

00800225 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80022b:	a1 04 30 80 00       	mov    0x803004,%eax
  800230:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800236:	8b 45 0c             	mov    0xc(%ebp),%eax
  800239:	39 c2                	cmp    %eax,%edx
  80023b:	74 14                	je     800251 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80023d:	83 ec 04             	sub    $0x4,%esp
  800240:	68 38 1c 80 00       	push   $0x801c38
  800245:	6a 26                	push   $0x26
  800247:	68 84 1c 80 00       	push   $0x801c84
  80024c:	e8 62 ff ff ff       	call   8001b3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800251:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800258:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80025f:	e9 c5 00 00 00       	jmp    800329 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800264:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800267:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80026e:	8b 45 08             	mov    0x8(%ebp),%eax
  800271:	01 d0                	add    %edx,%eax
  800273:	8b 00                	mov    (%eax),%eax
  800275:	85 c0                	test   %eax,%eax
  800277:	75 08                	jne    800281 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800279:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80027c:	e9 a5 00 00 00       	jmp    800326 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800281:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800288:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80028f:	eb 69                	jmp    8002fa <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800291:	a1 04 30 80 00       	mov    0x803004,%eax
  800296:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80029c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80029f:	89 d0                	mov    %edx,%eax
  8002a1:	01 c0                	add    %eax,%eax
  8002a3:	01 d0                	add    %edx,%eax
  8002a5:	c1 e0 03             	shl    $0x3,%eax
  8002a8:	01 c8                	add    %ecx,%eax
  8002aa:	8a 40 04             	mov    0x4(%eax),%al
  8002ad:	84 c0                	test   %al,%al
  8002af:	75 46                	jne    8002f7 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002b1:	a1 04 30 80 00       	mov    0x803004,%eax
  8002b6:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8002bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002bf:	89 d0                	mov    %edx,%eax
  8002c1:	01 c0                	add    %eax,%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	c1 e0 03             	shl    $0x3,%eax
  8002c8:	01 c8                	add    %ecx,%eax
  8002ca:	8b 00                	mov    (%eax),%eax
  8002cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002d7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002dc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e6:	01 c8                	add    %ecx,%eax
  8002e8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002ea:	39 c2                	cmp    %eax,%edx
  8002ec:	75 09                	jne    8002f7 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002ee:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002f5:	eb 15                	jmp    80030c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002f7:	ff 45 e8             	incl   -0x18(%ebp)
  8002fa:	a1 04 30 80 00       	mov    0x803004,%eax
  8002ff:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800305:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800308:	39 c2                	cmp    %eax,%edx
  80030a:	77 85                	ja     800291 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80030c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800310:	75 14                	jne    800326 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800312:	83 ec 04             	sub    $0x4,%esp
  800315:	68 90 1c 80 00       	push   $0x801c90
  80031a:	6a 3a                	push   $0x3a
  80031c:	68 84 1c 80 00       	push   $0x801c84
  800321:	e8 8d fe ff ff       	call   8001b3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800326:	ff 45 f0             	incl   -0x10(%ebp)
  800329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80032c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80032f:	0f 8c 2f ff ff ff    	jl     800264 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800335:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80033c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800343:	eb 26                	jmp    80036b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800345:	a1 04 30 80 00       	mov    0x803004,%eax
  80034a:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800350:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800353:	89 d0                	mov    %edx,%eax
  800355:	01 c0                	add    %eax,%eax
  800357:	01 d0                	add    %edx,%eax
  800359:	c1 e0 03             	shl    $0x3,%eax
  80035c:	01 c8                	add    %ecx,%eax
  80035e:	8a 40 04             	mov    0x4(%eax),%al
  800361:	3c 01                	cmp    $0x1,%al
  800363:	75 03                	jne    800368 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800365:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800368:	ff 45 e0             	incl   -0x20(%ebp)
  80036b:	a1 04 30 80 00       	mov    0x803004,%eax
  800370:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800376:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800379:	39 c2                	cmp    %eax,%edx
  80037b:	77 c8                	ja     800345 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80037d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800380:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800383:	74 14                	je     800399 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800385:	83 ec 04             	sub    $0x4,%esp
  800388:	68 e4 1c 80 00       	push   $0x801ce4
  80038d:	6a 44                	push   $0x44
  80038f:	68 84 1c 80 00       	push   $0x801c84
  800394:	e8 1a fe ff ff       	call   8001b3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800399:	90                   	nop
  80039a:	c9                   	leave  
  80039b:	c3                   	ret    

0080039c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80039c:	55                   	push   %ebp
  80039d:	89 e5                	mov    %esp,%ebp
  80039f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8003a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a5:	8b 00                	mov    (%eax),%eax
  8003a7:	8d 48 01             	lea    0x1(%eax),%ecx
  8003aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ad:	89 0a                	mov    %ecx,(%edx)
  8003af:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b2:	88 d1                	mov    %dl,%cl
  8003b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003be:	8b 00                	mov    (%eax),%eax
  8003c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003c5:	75 2c                	jne    8003f3 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003c7:	a0 08 30 80 00       	mov    0x803008,%al
  8003cc:	0f b6 c0             	movzbl %al,%eax
  8003cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003d2:	8b 12                	mov    (%edx),%edx
  8003d4:	89 d1                	mov    %edx,%ecx
  8003d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003d9:	83 c2 08             	add    $0x8,%edx
  8003dc:	83 ec 04             	sub    $0x4,%esp
  8003df:	50                   	push   %eax
  8003e0:	51                   	push   %ecx
  8003e1:	52                   	push   %edx
  8003e2:	e8 4e 0e 00 00       	call   801235 <sys_cputs>
  8003e7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f6:	8b 40 04             	mov    0x4(%eax),%eax
  8003f9:	8d 50 01             	lea    0x1(%eax),%edx
  8003fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ff:	89 50 04             	mov    %edx,0x4(%eax)
}
  800402:	90                   	nop
  800403:	c9                   	leave  
  800404:	c3                   	ret    

00800405 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800405:	55                   	push   %ebp
  800406:	89 e5                	mov    %esp,%ebp
  800408:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80040e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800415:	00 00 00 
	b.cnt = 0;
  800418:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80041f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800422:	ff 75 0c             	pushl  0xc(%ebp)
  800425:	ff 75 08             	pushl  0x8(%ebp)
  800428:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80042e:	50                   	push   %eax
  80042f:	68 9c 03 80 00       	push   $0x80039c
  800434:	e8 11 02 00 00       	call   80064a <vprintfmt>
  800439:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80043c:	a0 08 30 80 00       	mov    0x803008,%al
  800441:	0f b6 c0             	movzbl %al,%eax
  800444:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80044a:	83 ec 04             	sub    $0x4,%esp
  80044d:	50                   	push   %eax
  80044e:	52                   	push   %edx
  80044f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800455:	83 c0 08             	add    $0x8,%eax
  800458:	50                   	push   %eax
  800459:	e8 d7 0d 00 00       	call   801235 <sys_cputs>
  80045e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800461:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800468:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80046e:	c9                   	leave  
  80046f:	c3                   	ret    

00800470 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800470:	55                   	push   %ebp
  800471:	89 e5                	mov    %esp,%ebp
  800473:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800476:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  80047d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800480:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	83 ec 08             	sub    $0x8,%esp
  800489:	ff 75 f4             	pushl  -0xc(%ebp)
  80048c:	50                   	push   %eax
  80048d:	e8 73 ff ff ff       	call   800405 <vcprintf>
  800492:	83 c4 10             	add    $0x10,%esp
  800495:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800498:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8004a3:	e8 cf 0d 00 00       	call   801277 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8004a8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8004ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b1:	83 ec 08             	sub    $0x8,%esp
  8004b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004b7:	50                   	push   %eax
  8004b8:	e8 48 ff ff ff       	call   800405 <vcprintf>
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004c3:	e8 c9 0d 00 00       	call   801291 <sys_unlock_cons>
	return cnt;
  8004c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004cb:	c9                   	leave  
  8004cc:	c3                   	ret    

008004cd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004cd:	55                   	push   %ebp
  8004ce:	89 e5                	mov    %esp,%ebp
  8004d0:	53                   	push   %ebx
  8004d1:	83 ec 14             	sub    $0x14,%esp
  8004d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004da:	8b 45 14             	mov    0x14(%ebp),%eax
  8004dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004e0:	8b 45 18             	mov    0x18(%ebp),%eax
  8004e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004eb:	77 55                	ja     800542 <printnum+0x75>
  8004ed:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004f0:	72 05                	jb     8004f7 <printnum+0x2a>
  8004f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004f5:	77 4b                	ja     800542 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004f7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004fa:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004fd:	8b 45 18             	mov    0x18(%ebp),%eax
  800500:	ba 00 00 00 00       	mov    $0x0,%edx
  800505:	52                   	push   %edx
  800506:	50                   	push   %eax
  800507:	ff 75 f4             	pushl  -0xc(%ebp)
  80050a:	ff 75 f0             	pushl  -0x10(%ebp)
  80050d:	e8 26 13 00 00       	call   801838 <__udivdi3>
  800512:	83 c4 10             	add    $0x10,%esp
  800515:	83 ec 04             	sub    $0x4,%esp
  800518:	ff 75 20             	pushl  0x20(%ebp)
  80051b:	53                   	push   %ebx
  80051c:	ff 75 18             	pushl  0x18(%ebp)
  80051f:	52                   	push   %edx
  800520:	50                   	push   %eax
  800521:	ff 75 0c             	pushl  0xc(%ebp)
  800524:	ff 75 08             	pushl  0x8(%ebp)
  800527:	e8 a1 ff ff ff       	call   8004cd <printnum>
  80052c:	83 c4 20             	add    $0x20,%esp
  80052f:	eb 1a                	jmp    80054b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800531:	83 ec 08             	sub    $0x8,%esp
  800534:	ff 75 0c             	pushl  0xc(%ebp)
  800537:	ff 75 20             	pushl  0x20(%ebp)
  80053a:	8b 45 08             	mov    0x8(%ebp),%eax
  80053d:	ff d0                	call   *%eax
  80053f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800542:	ff 4d 1c             	decl   0x1c(%ebp)
  800545:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800549:	7f e6                	jg     800531 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80054b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80054e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800556:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800559:	53                   	push   %ebx
  80055a:	51                   	push   %ecx
  80055b:	52                   	push   %edx
  80055c:	50                   	push   %eax
  80055d:	e8 e6 13 00 00       	call   801948 <__umoddi3>
  800562:	83 c4 10             	add    $0x10,%esp
  800565:	05 54 1f 80 00       	add    $0x801f54,%eax
  80056a:	8a 00                	mov    (%eax),%al
  80056c:	0f be c0             	movsbl %al,%eax
  80056f:	83 ec 08             	sub    $0x8,%esp
  800572:	ff 75 0c             	pushl  0xc(%ebp)
  800575:	50                   	push   %eax
  800576:	8b 45 08             	mov    0x8(%ebp),%eax
  800579:	ff d0                	call   *%eax
  80057b:	83 c4 10             	add    $0x10,%esp
}
  80057e:	90                   	nop
  80057f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800582:	c9                   	leave  
  800583:	c3                   	ret    

00800584 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800584:	55                   	push   %ebp
  800585:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800587:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80058b:	7e 1c                	jle    8005a9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80058d:	8b 45 08             	mov    0x8(%ebp),%eax
  800590:	8b 00                	mov    (%eax),%eax
  800592:	8d 50 08             	lea    0x8(%eax),%edx
  800595:	8b 45 08             	mov    0x8(%ebp),%eax
  800598:	89 10                	mov    %edx,(%eax)
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	83 e8 08             	sub    $0x8,%eax
  8005a2:	8b 50 04             	mov    0x4(%eax),%edx
  8005a5:	8b 00                	mov    (%eax),%eax
  8005a7:	eb 40                	jmp    8005e9 <getuint+0x65>
	else if (lflag)
  8005a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005ad:	74 1e                	je     8005cd <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	8b 00                	mov    (%eax),%eax
  8005b4:	8d 50 04             	lea    0x4(%eax),%edx
  8005b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ba:	89 10                	mov    %edx,(%eax)
  8005bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bf:	8b 00                	mov    (%eax),%eax
  8005c1:	83 e8 04             	sub    $0x4,%eax
  8005c4:	8b 00                	mov    (%eax),%eax
  8005c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cb:	eb 1c                	jmp    8005e9 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	8d 50 04             	lea    0x4(%eax),%edx
  8005d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d8:	89 10                	mov    %edx,(%eax)
  8005da:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	83 e8 04             	sub    $0x4,%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005e9:	5d                   	pop    %ebp
  8005ea:	c3                   	ret    

008005eb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005eb:	55                   	push   %ebp
  8005ec:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005ee:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005f2:	7e 1c                	jle    800610 <getint+0x25>
		return va_arg(*ap, long long);
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	8d 50 08             	lea    0x8(%eax),%edx
  8005fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ff:	89 10                	mov    %edx,(%eax)
  800601:	8b 45 08             	mov    0x8(%ebp),%eax
  800604:	8b 00                	mov    (%eax),%eax
  800606:	83 e8 08             	sub    $0x8,%eax
  800609:	8b 50 04             	mov    0x4(%eax),%edx
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	eb 38                	jmp    800648 <getint+0x5d>
	else if (lflag)
  800610:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800614:	74 1a                	je     800630 <getint+0x45>
		return va_arg(*ap, long);
  800616:	8b 45 08             	mov    0x8(%ebp),%eax
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	8d 50 04             	lea    0x4(%eax),%edx
  80061e:	8b 45 08             	mov    0x8(%ebp),%eax
  800621:	89 10                	mov    %edx,(%eax)
  800623:	8b 45 08             	mov    0x8(%ebp),%eax
  800626:	8b 00                	mov    (%eax),%eax
  800628:	83 e8 04             	sub    $0x4,%eax
  80062b:	8b 00                	mov    (%eax),%eax
  80062d:	99                   	cltd   
  80062e:	eb 18                	jmp    800648 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	8b 00                	mov    (%eax),%eax
  800635:	8d 50 04             	lea    0x4(%eax),%edx
  800638:	8b 45 08             	mov    0x8(%ebp),%eax
  80063b:	89 10                	mov    %edx,(%eax)
  80063d:	8b 45 08             	mov    0x8(%ebp),%eax
  800640:	8b 00                	mov    (%eax),%eax
  800642:	83 e8 04             	sub    $0x4,%eax
  800645:	8b 00                	mov    (%eax),%eax
  800647:	99                   	cltd   
}
  800648:	5d                   	pop    %ebp
  800649:	c3                   	ret    

0080064a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80064a:	55                   	push   %ebp
  80064b:	89 e5                	mov    %esp,%ebp
  80064d:	56                   	push   %esi
  80064e:	53                   	push   %ebx
  80064f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800652:	eb 17                	jmp    80066b <vprintfmt+0x21>
			if (ch == '\0')
  800654:	85 db                	test   %ebx,%ebx
  800656:	0f 84 c1 03 00 00    	je     800a1d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80065c:	83 ec 08             	sub    $0x8,%esp
  80065f:	ff 75 0c             	pushl  0xc(%ebp)
  800662:	53                   	push   %ebx
  800663:	8b 45 08             	mov    0x8(%ebp),%eax
  800666:	ff d0                	call   *%eax
  800668:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80066b:	8b 45 10             	mov    0x10(%ebp),%eax
  80066e:	8d 50 01             	lea    0x1(%eax),%edx
  800671:	89 55 10             	mov    %edx,0x10(%ebp)
  800674:	8a 00                	mov    (%eax),%al
  800676:	0f b6 d8             	movzbl %al,%ebx
  800679:	83 fb 25             	cmp    $0x25,%ebx
  80067c:	75 d6                	jne    800654 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80067e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800682:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800689:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800690:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800697:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80069e:	8b 45 10             	mov    0x10(%ebp),%eax
  8006a1:	8d 50 01             	lea    0x1(%eax),%edx
  8006a4:	89 55 10             	mov    %edx,0x10(%ebp)
  8006a7:	8a 00                	mov    (%eax),%al
  8006a9:	0f b6 d8             	movzbl %al,%ebx
  8006ac:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006af:	83 f8 5b             	cmp    $0x5b,%eax
  8006b2:	0f 87 3d 03 00 00    	ja     8009f5 <vprintfmt+0x3ab>
  8006b8:	8b 04 85 78 1f 80 00 	mov    0x801f78(,%eax,4),%eax
  8006bf:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006c1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006c5:	eb d7                	jmp    80069e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006c7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006cb:	eb d1                	jmp    80069e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006cd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006d7:	89 d0                	mov    %edx,%eax
  8006d9:	c1 e0 02             	shl    $0x2,%eax
  8006dc:	01 d0                	add    %edx,%eax
  8006de:	01 c0                	add    %eax,%eax
  8006e0:	01 d8                	add    %ebx,%eax
  8006e2:	83 e8 30             	sub    $0x30,%eax
  8006e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8006eb:	8a 00                	mov    (%eax),%al
  8006ed:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006f0:	83 fb 2f             	cmp    $0x2f,%ebx
  8006f3:	7e 3e                	jle    800733 <vprintfmt+0xe9>
  8006f5:	83 fb 39             	cmp    $0x39,%ebx
  8006f8:	7f 39                	jg     800733 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006fa:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006fd:	eb d5                	jmp    8006d4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	83 c0 04             	add    $0x4,%eax
  800705:	89 45 14             	mov    %eax,0x14(%ebp)
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	83 e8 04             	sub    $0x4,%eax
  80070e:	8b 00                	mov    (%eax),%eax
  800710:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800713:	eb 1f                	jmp    800734 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800715:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800719:	79 83                	jns    80069e <vprintfmt+0x54>
				width = 0;
  80071b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800722:	e9 77 ff ff ff       	jmp    80069e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800727:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80072e:	e9 6b ff ff ff       	jmp    80069e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800733:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800734:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800738:	0f 89 60 ff ff ff    	jns    80069e <vprintfmt+0x54>
				width = precision, precision = -1;
  80073e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800741:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800744:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80074b:	e9 4e ff ff ff       	jmp    80069e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800750:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800753:	e9 46 ff ff ff       	jmp    80069e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800758:	8b 45 14             	mov    0x14(%ebp),%eax
  80075b:	83 c0 04             	add    $0x4,%eax
  80075e:	89 45 14             	mov    %eax,0x14(%ebp)
  800761:	8b 45 14             	mov    0x14(%ebp),%eax
  800764:	83 e8 04             	sub    $0x4,%eax
  800767:	8b 00                	mov    (%eax),%eax
  800769:	83 ec 08             	sub    $0x8,%esp
  80076c:	ff 75 0c             	pushl  0xc(%ebp)
  80076f:	50                   	push   %eax
  800770:	8b 45 08             	mov    0x8(%ebp),%eax
  800773:	ff d0                	call   *%eax
  800775:	83 c4 10             	add    $0x10,%esp
			break;
  800778:	e9 9b 02 00 00       	jmp    800a18 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	83 c0 04             	add    $0x4,%eax
  800783:	89 45 14             	mov    %eax,0x14(%ebp)
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	83 e8 04             	sub    $0x4,%eax
  80078c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80078e:	85 db                	test   %ebx,%ebx
  800790:	79 02                	jns    800794 <vprintfmt+0x14a>
				err = -err;
  800792:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800794:	83 fb 64             	cmp    $0x64,%ebx
  800797:	7f 0b                	jg     8007a4 <vprintfmt+0x15a>
  800799:	8b 34 9d c0 1d 80 00 	mov    0x801dc0(,%ebx,4),%esi
  8007a0:	85 f6                	test   %esi,%esi
  8007a2:	75 19                	jne    8007bd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007a4:	53                   	push   %ebx
  8007a5:	68 65 1f 80 00       	push   $0x801f65
  8007aa:	ff 75 0c             	pushl  0xc(%ebp)
  8007ad:	ff 75 08             	pushl  0x8(%ebp)
  8007b0:	e8 70 02 00 00       	call   800a25 <printfmt>
  8007b5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007b8:	e9 5b 02 00 00       	jmp    800a18 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007bd:	56                   	push   %esi
  8007be:	68 6e 1f 80 00       	push   $0x801f6e
  8007c3:	ff 75 0c             	pushl  0xc(%ebp)
  8007c6:	ff 75 08             	pushl  0x8(%ebp)
  8007c9:	e8 57 02 00 00       	call   800a25 <printfmt>
  8007ce:	83 c4 10             	add    $0x10,%esp
			break;
  8007d1:	e9 42 02 00 00       	jmp    800a18 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d9:	83 c0 04             	add    $0x4,%eax
  8007dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8007df:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e2:	83 e8 04             	sub    $0x4,%eax
  8007e5:	8b 30                	mov    (%eax),%esi
  8007e7:	85 f6                	test   %esi,%esi
  8007e9:	75 05                	jne    8007f0 <vprintfmt+0x1a6>
				p = "(null)";
  8007eb:	be 71 1f 80 00       	mov    $0x801f71,%esi
			if (width > 0 && padc != '-')
  8007f0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f4:	7e 6d                	jle    800863 <vprintfmt+0x219>
  8007f6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007fa:	74 67                	je     800863 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ff:	83 ec 08             	sub    $0x8,%esp
  800802:	50                   	push   %eax
  800803:	56                   	push   %esi
  800804:	e8 1e 03 00 00       	call   800b27 <strnlen>
  800809:	83 c4 10             	add    $0x10,%esp
  80080c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80080f:	eb 16                	jmp    800827 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800811:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	ff 75 0c             	pushl  0xc(%ebp)
  80081b:	50                   	push   %eax
  80081c:	8b 45 08             	mov    0x8(%ebp),%eax
  80081f:	ff d0                	call   *%eax
  800821:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800824:	ff 4d e4             	decl   -0x1c(%ebp)
  800827:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082b:	7f e4                	jg     800811 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80082d:	eb 34                	jmp    800863 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80082f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800833:	74 1c                	je     800851 <vprintfmt+0x207>
  800835:	83 fb 1f             	cmp    $0x1f,%ebx
  800838:	7e 05                	jle    80083f <vprintfmt+0x1f5>
  80083a:	83 fb 7e             	cmp    $0x7e,%ebx
  80083d:	7e 12                	jle    800851 <vprintfmt+0x207>
					putch('?', putdat);
  80083f:	83 ec 08             	sub    $0x8,%esp
  800842:	ff 75 0c             	pushl  0xc(%ebp)
  800845:	6a 3f                	push   $0x3f
  800847:	8b 45 08             	mov    0x8(%ebp),%eax
  80084a:	ff d0                	call   *%eax
  80084c:	83 c4 10             	add    $0x10,%esp
  80084f:	eb 0f                	jmp    800860 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800851:	83 ec 08             	sub    $0x8,%esp
  800854:	ff 75 0c             	pushl  0xc(%ebp)
  800857:	53                   	push   %ebx
  800858:	8b 45 08             	mov    0x8(%ebp),%eax
  80085b:	ff d0                	call   *%eax
  80085d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800860:	ff 4d e4             	decl   -0x1c(%ebp)
  800863:	89 f0                	mov    %esi,%eax
  800865:	8d 70 01             	lea    0x1(%eax),%esi
  800868:	8a 00                	mov    (%eax),%al
  80086a:	0f be d8             	movsbl %al,%ebx
  80086d:	85 db                	test   %ebx,%ebx
  80086f:	74 24                	je     800895 <vprintfmt+0x24b>
  800871:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800875:	78 b8                	js     80082f <vprintfmt+0x1e5>
  800877:	ff 4d e0             	decl   -0x20(%ebp)
  80087a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80087e:	79 af                	jns    80082f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800880:	eb 13                	jmp    800895 <vprintfmt+0x24b>
				putch(' ', putdat);
  800882:	83 ec 08             	sub    $0x8,%esp
  800885:	ff 75 0c             	pushl  0xc(%ebp)
  800888:	6a 20                	push   $0x20
  80088a:	8b 45 08             	mov    0x8(%ebp),%eax
  80088d:	ff d0                	call   *%eax
  80088f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800892:	ff 4d e4             	decl   -0x1c(%ebp)
  800895:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800899:	7f e7                	jg     800882 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80089b:	e9 78 01 00 00       	jmp    800a18 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008a0:	83 ec 08             	sub    $0x8,%esp
  8008a3:	ff 75 e8             	pushl  -0x18(%ebp)
  8008a6:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a9:	50                   	push   %eax
  8008aa:	e8 3c fd ff ff       	call   8005eb <getint>
  8008af:	83 c4 10             	add    $0x10,%esp
  8008b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008be:	85 d2                	test   %edx,%edx
  8008c0:	79 23                	jns    8008e5 <vprintfmt+0x29b>
				putch('-', putdat);
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	ff 75 0c             	pushl  0xc(%ebp)
  8008c8:	6a 2d                	push   $0x2d
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	ff d0                	call   *%eax
  8008cf:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008d8:	f7 d8                	neg    %eax
  8008da:	83 d2 00             	adc    $0x0,%edx
  8008dd:	f7 da                	neg    %edx
  8008df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008e5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008ec:	e9 bc 00 00 00       	jmp    8009ad <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008f1:	83 ec 08             	sub    $0x8,%esp
  8008f4:	ff 75 e8             	pushl  -0x18(%ebp)
  8008f7:	8d 45 14             	lea    0x14(%ebp),%eax
  8008fa:	50                   	push   %eax
  8008fb:	e8 84 fc ff ff       	call   800584 <getuint>
  800900:	83 c4 10             	add    $0x10,%esp
  800903:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800906:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800909:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800910:	e9 98 00 00 00       	jmp    8009ad <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
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
			putch('X', putdat);
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	ff 75 0c             	pushl  0xc(%ebp)
  80093b:	6a 58                	push   $0x58
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	ff d0                	call   *%eax
  800942:	83 c4 10             	add    $0x10,%esp
			break;
  800945:	e9 ce 00 00 00       	jmp    800a18 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80094a:	83 ec 08             	sub    $0x8,%esp
  80094d:	ff 75 0c             	pushl  0xc(%ebp)
  800950:	6a 30                	push   $0x30
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	ff d0                	call   *%eax
  800957:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80095a:	83 ec 08             	sub    $0x8,%esp
  80095d:	ff 75 0c             	pushl  0xc(%ebp)
  800960:	6a 78                	push   $0x78
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	ff d0                	call   *%eax
  800967:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80096a:	8b 45 14             	mov    0x14(%ebp),%eax
  80096d:	83 c0 04             	add    $0x4,%eax
  800970:	89 45 14             	mov    %eax,0x14(%ebp)
  800973:	8b 45 14             	mov    0x14(%ebp),%eax
  800976:	83 e8 04             	sub    $0x4,%eax
  800979:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80097b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800985:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80098c:	eb 1f                	jmp    8009ad <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80098e:	83 ec 08             	sub    $0x8,%esp
  800991:	ff 75 e8             	pushl  -0x18(%ebp)
  800994:	8d 45 14             	lea    0x14(%ebp),%eax
  800997:	50                   	push   %eax
  800998:	e8 e7 fb ff ff       	call   800584 <getuint>
  80099d:	83 c4 10             	add    $0x10,%esp
  8009a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009a6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009ad:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009b4:	83 ec 04             	sub    $0x4,%esp
  8009b7:	52                   	push   %edx
  8009b8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009bb:	50                   	push   %eax
  8009bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8009bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8009c2:	ff 75 0c             	pushl  0xc(%ebp)
  8009c5:	ff 75 08             	pushl  0x8(%ebp)
  8009c8:	e8 00 fb ff ff       	call   8004cd <printnum>
  8009cd:	83 c4 20             	add    $0x20,%esp
			break;
  8009d0:	eb 46                	jmp    800a18 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009d2:	83 ec 08             	sub    $0x8,%esp
  8009d5:	ff 75 0c             	pushl  0xc(%ebp)
  8009d8:	53                   	push   %ebx
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	ff d0                	call   *%eax
  8009de:	83 c4 10             	add    $0x10,%esp
			break;
  8009e1:	eb 35                	jmp    800a18 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009e3:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8009ea:	eb 2c                	jmp    800a18 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009ec:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8009f3:	eb 23                	jmp    800a18 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009f5:	83 ec 08             	sub    $0x8,%esp
  8009f8:	ff 75 0c             	pushl  0xc(%ebp)
  8009fb:	6a 25                	push   $0x25
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	ff d0                	call   *%eax
  800a02:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a05:	ff 4d 10             	decl   0x10(%ebp)
  800a08:	eb 03                	jmp    800a0d <vprintfmt+0x3c3>
  800a0a:	ff 4d 10             	decl   0x10(%ebp)
  800a0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a10:	48                   	dec    %eax
  800a11:	8a 00                	mov    (%eax),%al
  800a13:	3c 25                	cmp    $0x25,%al
  800a15:	75 f3                	jne    800a0a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a17:	90                   	nop
		}
	}
  800a18:	e9 35 fc ff ff       	jmp    800652 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a1d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a21:	5b                   	pop    %ebx
  800a22:	5e                   	pop    %esi
  800a23:	5d                   	pop    %ebp
  800a24:	c3                   	ret    

00800a25 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a25:	55                   	push   %ebp
  800a26:	89 e5                	mov    %esp,%ebp
  800a28:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a2b:	8d 45 10             	lea    0x10(%ebp),%eax
  800a2e:	83 c0 04             	add    $0x4,%eax
  800a31:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a34:	8b 45 10             	mov    0x10(%ebp),%eax
  800a37:	ff 75 f4             	pushl  -0xc(%ebp)
  800a3a:	50                   	push   %eax
  800a3b:	ff 75 0c             	pushl  0xc(%ebp)
  800a3e:	ff 75 08             	pushl  0x8(%ebp)
  800a41:	e8 04 fc ff ff       	call   80064a <vprintfmt>
  800a46:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a49:	90                   	nop
  800a4a:	c9                   	leave  
  800a4b:	c3                   	ret    

00800a4c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a52:	8b 40 08             	mov    0x8(%eax),%eax
  800a55:	8d 50 01             	lea    0x1(%eax),%edx
  800a58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a61:	8b 10                	mov    (%eax),%edx
  800a63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a66:	8b 40 04             	mov    0x4(%eax),%eax
  800a69:	39 c2                	cmp    %eax,%edx
  800a6b:	73 12                	jae    800a7f <sprintputch+0x33>
		*b->buf++ = ch;
  800a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a70:	8b 00                	mov    (%eax),%eax
  800a72:	8d 48 01             	lea    0x1(%eax),%ecx
  800a75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a78:	89 0a                	mov    %ecx,(%edx)
  800a7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800a7d:	88 10                	mov    %dl,(%eax)
}
  800a7f:	90                   	nop
  800a80:	5d                   	pop    %ebp
  800a81:	c3                   	ret    

00800a82 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a88:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a91:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	01 d0                	add    %edx,%eax
  800a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800aa3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800aa7:	74 06                	je     800aaf <vsnprintf+0x2d>
  800aa9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aad:	7f 07                	jg     800ab6 <vsnprintf+0x34>
		return -E_INVAL;
  800aaf:	b8 03 00 00 00       	mov    $0x3,%eax
  800ab4:	eb 20                	jmp    800ad6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ab6:	ff 75 14             	pushl  0x14(%ebp)
  800ab9:	ff 75 10             	pushl  0x10(%ebp)
  800abc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800abf:	50                   	push   %eax
  800ac0:	68 4c 0a 80 00       	push   $0x800a4c
  800ac5:	e8 80 fb ff ff       	call   80064a <vprintfmt>
  800aca:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800acd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ad0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ad6:	c9                   	leave  
  800ad7:	c3                   	ret    

00800ad8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
  800adb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ade:	8d 45 10             	lea    0x10(%ebp),%eax
  800ae1:	83 c0 04             	add    $0x4,%eax
  800ae4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ae7:	8b 45 10             	mov    0x10(%ebp),%eax
  800aea:	ff 75 f4             	pushl  -0xc(%ebp)
  800aed:	50                   	push   %eax
  800aee:	ff 75 0c             	pushl  0xc(%ebp)
  800af1:	ff 75 08             	pushl  0x8(%ebp)
  800af4:	e8 89 ff ff ff       	call   800a82 <vsnprintf>
  800af9:	83 c4 10             	add    $0x10,%esp
  800afc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b02:	c9                   	leave  
  800b03:	c3                   	ret    

00800b04 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
  800b07:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b11:	eb 06                	jmp    800b19 <strlen+0x15>
		n++;
  800b13:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b16:	ff 45 08             	incl   0x8(%ebp)
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8a 00                	mov    (%eax),%al
  800b1e:	84 c0                	test   %al,%al
  800b20:	75 f1                	jne    800b13 <strlen+0xf>
		n++;
	return n;
  800b22:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b25:	c9                   	leave  
  800b26:	c3                   	ret    

00800b27 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b34:	eb 09                	jmp    800b3f <strnlen+0x18>
		n++;
  800b36:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b39:	ff 45 08             	incl   0x8(%ebp)
  800b3c:	ff 4d 0c             	decl   0xc(%ebp)
  800b3f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b43:	74 09                	je     800b4e <strnlen+0x27>
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	8a 00                	mov    (%eax),%al
  800b4a:	84 c0                	test   %al,%al
  800b4c:	75 e8                	jne    800b36 <strnlen+0xf>
		n++;
	return n;
  800b4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b51:	c9                   	leave  
  800b52:	c3                   	ret    

00800b53 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b5f:	90                   	nop
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	8d 50 01             	lea    0x1(%eax),%edx
  800b66:	89 55 08             	mov    %edx,0x8(%ebp)
  800b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b6f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b72:	8a 12                	mov    (%edx),%dl
  800b74:	88 10                	mov    %dl,(%eax)
  800b76:	8a 00                	mov    (%eax),%al
  800b78:	84 c0                	test   %al,%al
  800b7a:	75 e4                	jne    800b60 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b7f:	c9                   	leave  
  800b80:	c3                   	ret    

00800b81 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b81:	55                   	push   %ebp
  800b82:	89 e5                	mov    %esp,%ebp
  800b84:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b94:	eb 1f                	jmp    800bb5 <strncpy+0x34>
		*dst++ = *src;
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	8d 50 01             	lea    0x1(%eax),%edx
  800b9c:	89 55 08             	mov    %edx,0x8(%ebp)
  800b9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba2:	8a 12                	mov    (%edx),%dl
  800ba4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba9:	8a 00                	mov    (%eax),%al
  800bab:	84 c0                	test   %al,%al
  800bad:	74 03                	je     800bb2 <strncpy+0x31>
			src++;
  800baf:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bb2:	ff 45 fc             	incl   -0x4(%ebp)
  800bb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bb8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bbb:	72 d9                	jb     800b96 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800bbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bc0:	c9                   	leave  
  800bc1:	c3                   	ret    

00800bc2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bc2:	55                   	push   %ebp
  800bc3:	89 e5                	mov    %esp,%ebp
  800bc5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bd2:	74 30                	je     800c04 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bd4:	eb 16                	jmp    800bec <strlcpy+0x2a>
			*dst++ = *src++;
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8d 50 01             	lea    0x1(%eax),%edx
  800bdc:	89 55 08             	mov    %edx,0x8(%ebp)
  800bdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800be5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800be8:	8a 12                	mov    (%edx),%dl
  800bea:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bec:	ff 4d 10             	decl   0x10(%ebp)
  800bef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bf3:	74 09                	je     800bfe <strlcpy+0x3c>
  800bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf8:	8a 00                	mov    (%eax),%al
  800bfa:	84 c0                	test   %al,%al
  800bfc:	75 d8                	jne    800bd6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c04:	8b 55 08             	mov    0x8(%ebp),%edx
  800c07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c0a:	29 c2                	sub    %eax,%edx
  800c0c:	89 d0                	mov    %edx,%eax
}
  800c0e:	c9                   	leave  
  800c0f:	c3                   	ret    

00800c10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c13:	eb 06                	jmp    800c1b <strcmp+0xb>
		p++, q++;
  800c15:	ff 45 08             	incl   0x8(%ebp)
  800c18:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	8a 00                	mov    (%eax),%al
  800c20:	84 c0                	test   %al,%al
  800c22:	74 0e                	je     800c32 <strcmp+0x22>
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	8a 10                	mov    (%eax),%dl
  800c29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2c:	8a 00                	mov    (%eax),%al
  800c2e:	38 c2                	cmp    %al,%dl
  800c30:	74 e3                	je     800c15 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	8a 00                	mov    (%eax),%al
  800c37:	0f b6 d0             	movzbl %al,%edx
  800c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3d:	8a 00                	mov    (%eax),%al
  800c3f:	0f b6 c0             	movzbl %al,%eax
  800c42:	29 c2                	sub    %eax,%edx
  800c44:	89 d0                	mov    %edx,%eax
}
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    

00800c48 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c4b:	eb 09                	jmp    800c56 <strncmp+0xe>
		n--, p++, q++;
  800c4d:	ff 4d 10             	decl   0x10(%ebp)
  800c50:	ff 45 08             	incl   0x8(%ebp)
  800c53:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c5a:	74 17                	je     800c73 <strncmp+0x2b>
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	8a 00                	mov    (%eax),%al
  800c61:	84 c0                	test   %al,%al
  800c63:	74 0e                	je     800c73 <strncmp+0x2b>
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	8a 10                	mov    (%eax),%dl
  800c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6d:	8a 00                	mov    (%eax),%al
  800c6f:	38 c2                	cmp    %al,%dl
  800c71:	74 da                	je     800c4d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c73:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c77:	75 07                	jne    800c80 <strncmp+0x38>
		return 0;
  800c79:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7e:	eb 14                	jmp    800c94 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	8a 00                	mov    (%eax),%al
  800c85:	0f b6 d0             	movzbl %al,%edx
  800c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8b:	8a 00                	mov    (%eax),%al
  800c8d:	0f b6 c0             	movzbl %al,%eax
  800c90:	29 c2                	sub    %eax,%edx
  800c92:	89 d0                	mov    %edx,%eax
}
  800c94:	5d                   	pop    %ebp
  800c95:	c3                   	ret    

00800c96 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c96:	55                   	push   %ebp
  800c97:	89 e5                	mov    %esp,%ebp
  800c99:	83 ec 04             	sub    $0x4,%esp
  800c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ca2:	eb 12                	jmp    800cb6 <strchr+0x20>
		if (*s == c)
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	8a 00                	mov    (%eax),%al
  800ca9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cac:	75 05                	jne    800cb3 <strchr+0x1d>
			return (char *) s;
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	eb 11                	jmp    800cc4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cb3:	ff 45 08             	incl   0x8(%ebp)
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	8a 00                	mov    (%eax),%al
  800cbb:	84 c0                	test   %al,%al
  800cbd:	75 e5                	jne    800ca4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cc4:	c9                   	leave  
  800cc5:	c3                   	ret    

00800cc6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	83 ec 04             	sub    $0x4,%esp
  800ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cd2:	eb 0d                	jmp    800ce1 <strfind+0x1b>
		if (*s == c)
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	8a 00                	mov    (%eax),%al
  800cd9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cdc:	74 0e                	je     800cec <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cde:	ff 45 08             	incl   0x8(%ebp)
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	8a 00                	mov    (%eax),%al
  800ce6:	84 c0                	test   %al,%al
  800ce8:	75 ea                	jne    800cd4 <strfind+0xe>
  800cea:	eb 01                	jmp    800ced <strfind+0x27>
		if (*s == c)
			break;
  800cec:	90                   	nop
	return (char *) s;
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf0:	c9                   	leave  
  800cf1:	c3                   	ret    

00800cf2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cfe:	8b 45 10             	mov    0x10(%ebp),%eax
  800d01:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d04:	eb 0e                	jmp    800d14 <memset+0x22>
		*p++ = c;
  800d06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d09:	8d 50 01             	lea    0x1(%eax),%edx
  800d0c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d12:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d14:	ff 4d f8             	decl   -0x8(%ebp)
  800d17:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d1b:	79 e9                	jns    800d06 <memset+0x14>
		*p++ = c;

	return v;
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d20:	c9                   	leave  
  800d21:	c3                   	ret    

00800d22 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d34:	eb 16                	jmp    800d4c <memcpy+0x2a>
		*d++ = *s++;
  800d36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d39:	8d 50 01             	lea    0x1(%eax),%edx
  800d3c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d42:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d45:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d48:	8a 12                	mov    (%edx),%dl
  800d4a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d52:	89 55 10             	mov    %edx,0x10(%ebp)
  800d55:	85 c0                	test   %eax,%eax
  800d57:	75 dd                	jne    800d36 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d73:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d76:	73 50                	jae    800dc8 <memmove+0x6a>
  800d78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7e:	01 d0                	add    %edx,%eax
  800d80:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d83:	76 43                	jbe    800dc8 <memmove+0x6a>
		s += n;
  800d85:	8b 45 10             	mov    0x10(%ebp),%eax
  800d88:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d91:	eb 10                	jmp    800da3 <memmove+0x45>
			*--d = *--s;
  800d93:	ff 4d f8             	decl   -0x8(%ebp)
  800d96:	ff 4d fc             	decl   -0x4(%ebp)
  800d99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d9c:	8a 10                	mov    (%eax),%dl
  800d9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800da3:	8b 45 10             	mov    0x10(%ebp),%eax
  800da6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da9:	89 55 10             	mov    %edx,0x10(%ebp)
  800dac:	85 c0                	test   %eax,%eax
  800dae:	75 e3                	jne    800d93 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800db0:	eb 23                	jmp    800dd5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800db2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db5:	8d 50 01             	lea    0x1(%eax),%edx
  800db8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dbb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dbe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dc1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dc4:	8a 12                	mov    (%edx),%dl
  800dc6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dce:	89 55 10             	mov    %edx,0x10(%ebp)
  800dd1:	85 c0                	test   %eax,%eax
  800dd3:	75 dd                	jne    800db2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd8:	c9                   	leave  
  800dd9:	c3                   	ret    

00800dda <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800de6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dec:	eb 2a                	jmp    800e18 <memcmp+0x3e>
		if (*s1 != *s2)
  800dee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df1:	8a 10                	mov    (%eax),%dl
  800df3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df6:	8a 00                	mov    (%eax),%al
  800df8:	38 c2                	cmp    %al,%dl
  800dfa:	74 16                	je     800e12 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	0f b6 d0             	movzbl %al,%edx
  800e04:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e07:	8a 00                	mov    (%eax),%al
  800e09:	0f b6 c0             	movzbl %al,%eax
  800e0c:	29 c2                	sub    %eax,%edx
  800e0e:	89 d0                	mov    %edx,%eax
  800e10:	eb 18                	jmp    800e2a <memcmp+0x50>
		s1++, s2++;
  800e12:	ff 45 fc             	incl   -0x4(%ebp)
  800e15:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e18:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e1e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e21:	85 c0                	test   %eax,%eax
  800e23:	75 c9                	jne    800dee <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e2a:	c9                   	leave  
  800e2b:	c3                   	ret    

00800e2c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e32:	8b 55 08             	mov    0x8(%ebp),%edx
  800e35:	8b 45 10             	mov    0x10(%ebp),%eax
  800e38:	01 d0                	add    %edx,%eax
  800e3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e3d:	eb 15                	jmp    800e54 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	8a 00                	mov    (%eax),%al
  800e44:	0f b6 d0             	movzbl %al,%edx
  800e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4a:	0f b6 c0             	movzbl %al,%eax
  800e4d:	39 c2                	cmp    %eax,%edx
  800e4f:	74 0d                	je     800e5e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e51:	ff 45 08             	incl   0x8(%ebp)
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e5a:	72 e3                	jb     800e3f <memfind+0x13>
  800e5c:	eb 01                	jmp    800e5f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e5e:	90                   	nop
	return (void *) s;
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e62:	c9                   	leave  
  800e63:	c3                   	ret    

00800e64 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e71:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e78:	eb 03                	jmp    800e7d <strtol+0x19>
		s++;
  800e7a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	8a 00                	mov    (%eax),%al
  800e82:	3c 20                	cmp    $0x20,%al
  800e84:	74 f4                	je     800e7a <strtol+0x16>
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	8a 00                	mov    (%eax),%al
  800e8b:	3c 09                	cmp    $0x9,%al
  800e8d:	74 eb                	je     800e7a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	8a 00                	mov    (%eax),%al
  800e94:	3c 2b                	cmp    $0x2b,%al
  800e96:	75 05                	jne    800e9d <strtol+0x39>
		s++;
  800e98:	ff 45 08             	incl   0x8(%ebp)
  800e9b:	eb 13                	jmp    800eb0 <strtol+0x4c>
	else if (*s == '-')
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	8a 00                	mov    (%eax),%al
  800ea2:	3c 2d                	cmp    $0x2d,%al
  800ea4:	75 0a                	jne    800eb0 <strtol+0x4c>
		s++, neg = 1;
  800ea6:	ff 45 08             	incl   0x8(%ebp)
  800ea9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb4:	74 06                	je     800ebc <strtol+0x58>
  800eb6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800eba:	75 20                	jne    800edc <strtol+0x78>
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	8a 00                	mov    (%eax),%al
  800ec1:	3c 30                	cmp    $0x30,%al
  800ec3:	75 17                	jne    800edc <strtol+0x78>
  800ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec8:	40                   	inc    %eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	3c 78                	cmp    $0x78,%al
  800ecd:	75 0d                	jne    800edc <strtol+0x78>
		s += 2, base = 16;
  800ecf:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ed3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800eda:	eb 28                	jmp    800f04 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800edc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee0:	75 15                	jne    800ef7 <strtol+0x93>
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	3c 30                	cmp    $0x30,%al
  800ee9:	75 0c                	jne    800ef7 <strtol+0x93>
		s++, base = 8;
  800eeb:	ff 45 08             	incl   0x8(%ebp)
  800eee:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ef5:	eb 0d                	jmp    800f04 <strtol+0xa0>
	else if (base == 0)
  800ef7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800efb:	75 07                	jne    800f04 <strtol+0xa0>
		base = 10;
  800efd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	8a 00                	mov    (%eax),%al
  800f09:	3c 2f                	cmp    $0x2f,%al
  800f0b:	7e 19                	jle    800f26 <strtol+0xc2>
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	8a 00                	mov    (%eax),%al
  800f12:	3c 39                	cmp    $0x39,%al
  800f14:	7f 10                	jg     800f26 <strtol+0xc2>
			dig = *s - '0';
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	8a 00                	mov    (%eax),%al
  800f1b:	0f be c0             	movsbl %al,%eax
  800f1e:	83 e8 30             	sub    $0x30,%eax
  800f21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f24:	eb 42                	jmp    800f68 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	3c 60                	cmp    $0x60,%al
  800f2d:	7e 19                	jle    800f48 <strtol+0xe4>
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	3c 7a                	cmp    $0x7a,%al
  800f36:	7f 10                	jg     800f48 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	0f be c0             	movsbl %al,%eax
  800f40:	83 e8 57             	sub    $0x57,%eax
  800f43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f46:	eb 20                	jmp    800f68 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	3c 40                	cmp    $0x40,%al
  800f4f:	7e 39                	jle    800f8a <strtol+0x126>
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	3c 5a                	cmp    $0x5a,%al
  800f58:	7f 30                	jg     800f8a <strtol+0x126>
			dig = *s - 'A' + 10;
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	0f be c0             	movsbl %al,%eax
  800f62:	83 e8 37             	sub    $0x37,%eax
  800f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f6b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f6e:	7d 19                	jge    800f89 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f70:	ff 45 08             	incl   0x8(%ebp)
  800f73:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f76:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f7a:	89 c2                	mov    %eax,%edx
  800f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f7f:	01 d0                	add    %edx,%eax
  800f81:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f84:	e9 7b ff ff ff       	jmp    800f04 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f89:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f8e:	74 08                	je     800f98 <strtol+0x134>
		*endptr = (char *) s;
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	8b 55 08             	mov    0x8(%ebp),%edx
  800f96:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f98:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f9c:	74 07                	je     800fa5 <strtol+0x141>
  800f9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa1:	f7 d8                	neg    %eax
  800fa3:	eb 03                	jmp    800fa8 <strtol+0x144>
  800fa5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fa8:	c9                   	leave  
  800fa9:	c3                   	ret    

00800faa <ltostr>:

void
ltostr(long value, char *str)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fb0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fb7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fc2:	79 13                	jns    800fd7 <ltostr+0x2d>
	{
		neg = 1;
  800fc4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fce:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fd1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fd4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fdf:	99                   	cltd   
  800fe0:	f7 f9                	idiv   %ecx
  800fe2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fe5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe8:	8d 50 01             	lea    0x1(%eax),%edx
  800feb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fee:	89 c2                	mov    %eax,%edx
  800ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff3:	01 d0                	add    %edx,%eax
  800ff5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ff8:	83 c2 30             	add    $0x30,%edx
  800ffb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ffd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801000:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801005:	f7 e9                	imul   %ecx
  801007:	c1 fa 02             	sar    $0x2,%edx
  80100a:	89 c8                	mov    %ecx,%eax
  80100c:	c1 f8 1f             	sar    $0x1f,%eax
  80100f:	29 c2                	sub    %eax,%edx
  801011:	89 d0                	mov    %edx,%eax
  801013:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801016:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80101a:	75 bb                	jne    800fd7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80101c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801023:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801026:	48                   	dec    %eax
  801027:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80102a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80102e:	74 3d                	je     80106d <ltostr+0xc3>
		start = 1 ;
  801030:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801037:	eb 34                	jmp    80106d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801039:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103f:	01 d0                	add    %edx,%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801046:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104c:	01 c2                	add    %eax,%edx
  80104e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	01 c8                	add    %ecx,%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80105a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80105d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801060:	01 c2                	add    %eax,%edx
  801062:	8a 45 eb             	mov    -0x15(%ebp),%al
  801065:	88 02                	mov    %al,(%edx)
		start++ ;
  801067:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80106a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80106d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801070:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801073:	7c c4                	jl     801039 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801075:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801078:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107b:	01 d0                	add    %edx,%eax
  80107d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801080:	90                   	nop
  801081:	c9                   	leave  
  801082:	c3                   	ret    

00801083 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801089:	ff 75 08             	pushl  0x8(%ebp)
  80108c:	e8 73 fa ff ff       	call   800b04 <strlen>
  801091:	83 c4 04             	add    $0x4,%esp
  801094:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801097:	ff 75 0c             	pushl  0xc(%ebp)
  80109a:	e8 65 fa ff ff       	call   800b04 <strlen>
  80109f:	83 c4 04             	add    $0x4,%esp
  8010a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010b3:	eb 17                	jmp    8010cc <strcconcat+0x49>
		final[s] = str1[s] ;
  8010b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010bb:	01 c2                	add    %eax,%edx
  8010bd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	01 c8                	add    %ecx,%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010c9:	ff 45 fc             	incl   -0x4(%ebp)
  8010cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010d2:	7c e1                	jl     8010b5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010e2:	eb 1f                	jmp    801103 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e7:	8d 50 01             	lea    0x1(%eax),%edx
  8010ea:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010ed:	89 c2                	mov    %eax,%edx
  8010ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f2:	01 c2                	add    %eax,%edx
  8010f4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fa:	01 c8                	add    %ecx,%eax
  8010fc:	8a 00                	mov    (%eax),%al
  8010fe:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801100:	ff 45 f8             	incl   -0x8(%ebp)
  801103:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801106:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801109:	7c d9                	jl     8010e4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80110b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80110e:	8b 45 10             	mov    0x10(%ebp),%eax
  801111:	01 d0                	add    %edx,%eax
  801113:	c6 00 00             	movb   $0x0,(%eax)
}
  801116:	90                   	nop
  801117:	c9                   	leave  
  801118:	c3                   	ret    

00801119 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80111c:	8b 45 14             	mov    0x14(%ebp),%eax
  80111f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801125:	8b 45 14             	mov    0x14(%ebp),%eax
  801128:	8b 00                	mov    (%eax),%eax
  80112a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801131:	8b 45 10             	mov    0x10(%ebp),%eax
  801134:	01 d0                	add    %edx,%eax
  801136:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80113c:	eb 0c                	jmp    80114a <strsplit+0x31>
			*string++ = 0;
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	8d 50 01             	lea    0x1(%eax),%edx
  801144:	89 55 08             	mov    %edx,0x8(%ebp)
  801147:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	84 c0                	test   %al,%al
  801151:	74 18                	je     80116b <strsplit+0x52>
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	8a 00                	mov    (%eax),%al
  801158:	0f be c0             	movsbl %al,%eax
  80115b:	50                   	push   %eax
  80115c:	ff 75 0c             	pushl  0xc(%ebp)
  80115f:	e8 32 fb ff ff       	call   800c96 <strchr>
  801164:	83 c4 08             	add    $0x8,%esp
  801167:	85 c0                	test   %eax,%eax
  801169:	75 d3                	jne    80113e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	84 c0                	test   %al,%al
  801172:	74 5a                	je     8011ce <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801174:	8b 45 14             	mov    0x14(%ebp),%eax
  801177:	8b 00                	mov    (%eax),%eax
  801179:	83 f8 0f             	cmp    $0xf,%eax
  80117c:	75 07                	jne    801185 <strsplit+0x6c>
		{
			return 0;
  80117e:	b8 00 00 00 00       	mov    $0x0,%eax
  801183:	eb 66                	jmp    8011eb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801185:	8b 45 14             	mov    0x14(%ebp),%eax
  801188:	8b 00                	mov    (%eax),%eax
  80118a:	8d 48 01             	lea    0x1(%eax),%ecx
  80118d:	8b 55 14             	mov    0x14(%ebp),%edx
  801190:	89 0a                	mov    %ecx,(%edx)
  801192:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801199:	8b 45 10             	mov    0x10(%ebp),%eax
  80119c:	01 c2                	add    %eax,%edx
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011a3:	eb 03                	jmp    8011a8 <strsplit+0x8f>
			string++;
  8011a5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	84 c0                	test   %al,%al
  8011af:	74 8b                	je     80113c <strsplit+0x23>
  8011b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b4:	8a 00                	mov    (%eax),%al
  8011b6:	0f be c0             	movsbl %al,%eax
  8011b9:	50                   	push   %eax
  8011ba:	ff 75 0c             	pushl  0xc(%ebp)
  8011bd:	e8 d4 fa ff ff       	call   800c96 <strchr>
  8011c2:	83 c4 08             	add    $0x8,%esp
  8011c5:	85 c0                	test   %eax,%eax
  8011c7:	74 dc                	je     8011a5 <strsplit+0x8c>
			string++;
	}
  8011c9:	e9 6e ff ff ff       	jmp    80113c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011ce:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d2:	8b 00                	mov    (%eax),%eax
  8011d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011db:	8b 45 10             	mov    0x10(%ebp),%eax
  8011de:	01 d0                	add    %edx,%eax
  8011e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011e6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011eb:	c9                   	leave  
  8011ec:	c3                   	ret    

008011ed <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
  8011f0:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8011f3:	83 ec 04             	sub    $0x4,%esp
  8011f6:	68 e8 20 80 00       	push   $0x8020e8
  8011fb:	68 3f 01 00 00       	push   $0x13f
  801200:	68 0a 21 80 00       	push   $0x80210a
  801205:	e8 a9 ef ff ff       	call   8001b3 <_panic>

0080120a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
  80120d:	57                   	push   %edi
  80120e:	56                   	push   %esi
  80120f:	53                   	push   %ebx
  801210:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	8b 55 0c             	mov    0xc(%ebp),%edx
  801219:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80121c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80121f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801222:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801225:	cd 30                	int    $0x30
  801227:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80122a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80122d:	83 c4 10             	add    $0x10,%esp
  801230:	5b                   	pop    %ebx
  801231:	5e                   	pop    %esi
  801232:	5f                   	pop    %edi
  801233:	5d                   	pop    %ebp
  801234:	c3                   	ret    

00801235 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	83 ec 04             	sub    $0x4,%esp
  80123b:	8b 45 10             	mov    0x10(%ebp),%eax
  80123e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801241:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	6a 00                	push   $0x0
  80124a:	6a 00                	push   $0x0
  80124c:	52                   	push   %edx
  80124d:	ff 75 0c             	pushl  0xc(%ebp)
  801250:	50                   	push   %eax
  801251:	6a 00                	push   $0x0
  801253:	e8 b2 ff ff ff       	call   80120a <syscall>
  801258:	83 c4 18             	add    $0x18,%esp
}
  80125b:	90                   	nop
  80125c:	c9                   	leave  
  80125d:	c3                   	ret    

0080125e <sys_cgetc>:

int
sys_cgetc(void)
{
  80125e:	55                   	push   %ebp
  80125f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801261:	6a 00                	push   $0x0
  801263:	6a 00                	push   $0x0
  801265:	6a 00                	push   $0x0
  801267:	6a 00                	push   $0x0
  801269:	6a 00                	push   $0x0
  80126b:	6a 02                	push   $0x2
  80126d:	e8 98 ff ff ff       	call   80120a <syscall>
  801272:	83 c4 18             	add    $0x18,%esp
}
  801275:	c9                   	leave  
  801276:	c3                   	ret    

00801277 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80127a:	6a 00                	push   $0x0
  80127c:	6a 00                	push   $0x0
  80127e:	6a 00                	push   $0x0
  801280:	6a 00                	push   $0x0
  801282:	6a 00                	push   $0x0
  801284:	6a 03                	push   $0x3
  801286:	e8 7f ff ff ff       	call   80120a <syscall>
  80128b:	83 c4 18             	add    $0x18,%esp
}
  80128e:	90                   	nop
  80128f:	c9                   	leave  
  801290:	c3                   	ret    

00801291 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801294:	6a 00                	push   $0x0
  801296:	6a 00                	push   $0x0
  801298:	6a 00                	push   $0x0
  80129a:	6a 00                	push   $0x0
  80129c:	6a 00                	push   $0x0
  80129e:	6a 04                	push   $0x4
  8012a0:	e8 65 ff ff ff       	call   80120a <syscall>
  8012a5:	83 c4 18             	add    $0x18,%esp
}
  8012a8:	90                   	nop
  8012a9:	c9                   	leave  
  8012aa:	c3                   	ret    

008012ab <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012ab:	55                   	push   %ebp
  8012ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b4:	6a 00                	push   $0x0
  8012b6:	6a 00                	push   $0x0
  8012b8:	6a 00                	push   $0x0
  8012ba:	52                   	push   %edx
  8012bb:	50                   	push   %eax
  8012bc:	6a 08                	push   $0x8
  8012be:	e8 47 ff ff ff       	call   80120a <syscall>
  8012c3:	83 c4 18             	add    $0x18,%esp
}
  8012c6:	c9                   	leave  
  8012c7:	c3                   	ret    

008012c8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
  8012cb:	56                   	push   %esi
  8012cc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012cd:	8b 75 18             	mov    0x18(%ebp),%esi
  8012d0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	56                   	push   %esi
  8012dd:	53                   	push   %ebx
  8012de:	51                   	push   %ecx
  8012df:	52                   	push   %edx
  8012e0:	50                   	push   %eax
  8012e1:	6a 09                	push   $0x9
  8012e3:	e8 22 ff ff ff       	call   80120a <syscall>
  8012e8:	83 c4 18             	add    $0x18,%esp
}
  8012eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012ee:	5b                   	pop    %ebx
  8012ef:	5e                   	pop    %esi
  8012f0:	5d                   	pop    %ebp
  8012f1:	c3                   	ret    

008012f2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	6a 00                	push   $0x0
  8012fd:	6a 00                	push   $0x0
  8012ff:	6a 00                	push   $0x0
  801301:	52                   	push   %edx
  801302:	50                   	push   %eax
  801303:	6a 0a                	push   $0xa
  801305:	e8 00 ff ff ff       	call   80120a <syscall>
  80130a:	83 c4 18             	add    $0x18,%esp
}
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    

0080130f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801312:	6a 00                	push   $0x0
  801314:	6a 00                	push   $0x0
  801316:	6a 00                	push   $0x0
  801318:	ff 75 0c             	pushl  0xc(%ebp)
  80131b:	ff 75 08             	pushl  0x8(%ebp)
  80131e:	6a 0b                	push   $0xb
  801320:	e8 e5 fe ff ff       	call   80120a <syscall>
  801325:	83 c4 18             	add    $0x18,%esp
}
  801328:	c9                   	leave  
  801329:	c3                   	ret    

0080132a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80132d:	6a 00                	push   $0x0
  80132f:	6a 00                	push   $0x0
  801331:	6a 00                	push   $0x0
  801333:	6a 00                	push   $0x0
  801335:	6a 00                	push   $0x0
  801337:	6a 0c                	push   $0xc
  801339:	e8 cc fe ff ff       	call   80120a <syscall>
  80133e:	83 c4 18             	add    $0x18,%esp
}
  801341:	c9                   	leave  
  801342:	c3                   	ret    

00801343 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801346:	6a 00                	push   $0x0
  801348:	6a 00                	push   $0x0
  80134a:	6a 00                	push   $0x0
  80134c:	6a 00                	push   $0x0
  80134e:	6a 00                	push   $0x0
  801350:	6a 0d                	push   $0xd
  801352:	e8 b3 fe ff ff       	call   80120a <syscall>
  801357:	83 c4 18             	add    $0x18,%esp
}
  80135a:	c9                   	leave  
  80135b:	c3                   	ret    

0080135c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80135f:	6a 00                	push   $0x0
  801361:	6a 00                	push   $0x0
  801363:	6a 00                	push   $0x0
  801365:	6a 00                	push   $0x0
  801367:	6a 00                	push   $0x0
  801369:	6a 0e                	push   $0xe
  80136b:	e8 9a fe ff ff       	call   80120a <syscall>
  801370:	83 c4 18             	add    $0x18,%esp
}
  801373:	c9                   	leave  
  801374:	c3                   	ret    

00801375 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801378:	6a 00                	push   $0x0
  80137a:	6a 00                	push   $0x0
  80137c:	6a 00                	push   $0x0
  80137e:	6a 00                	push   $0x0
  801380:	6a 00                	push   $0x0
  801382:	6a 0f                	push   $0xf
  801384:	e8 81 fe ff ff       	call   80120a <syscall>
  801389:	83 c4 18             	add    $0x18,%esp
}
  80138c:	c9                   	leave  
  80138d:	c3                   	ret    

0080138e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801391:	6a 00                	push   $0x0
  801393:	6a 00                	push   $0x0
  801395:	6a 00                	push   $0x0
  801397:	6a 00                	push   $0x0
  801399:	ff 75 08             	pushl  0x8(%ebp)
  80139c:	6a 10                	push   $0x10
  80139e:	e8 67 fe ff ff       	call   80120a <syscall>
  8013a3:	83 c4 18             	add    $0x18,%esp
}
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

008013a8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013ab:	6a 00                	push   $0x0
  8013ad:	6a 00                	push   $0x0
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 11                	push   $0x11
  8013b7:	e8 4e fe ff ff       	call   80120a <syscall>
  8013bc:	83 c4 18             	add    $0x18,%esp
}
  8013bf:	90                   	nop
  8013c0:	c9                   	leave  
  8013c1:	c3                   	ret    

008013c2 <sys_cputc>:

void
sys_cputc(const char c)
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
  8013c5:	83 ec 04             	sub    $0x4,%esp
  8013c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013ce:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	50                   	push   %eax
  8013db:	6a 01                	push   $0x1
  8013dd:	e8 28 fe ff ff       	call   80120a <syscall>
  8013e2:	83 c4 18             	add    $0x18,%esp
}
  8013e5:	90                   	nop
  8013e6:	c9                   	leave  
  8013e7:	c3                   	ret    

008013e8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 14                	push   $0x14
  8013f7:	e8 0e fe ff ff       	call   80120a <syscall>
  8013fc:	83 c4 18             	add    $0x18,%esp
}
  8013ff:	90                   	nop
  801400:	c9                   	leave  
  801401:	c3                   	ret    

00801402 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
  801405:	83 ec 04             	sub    $0x4,%esp
  801408:	8b 45 10             	mov    0x10(%ebp),%eax
  80140b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80140e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801411:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	6a 00                	push   $0x0
  80141a:	51                   	push   %ecx
  80141b:	52                   	push   %edx
  80141c:	ff 75 0c             	pushl  0xc(%ebp)
  80141f:	50                   	push   %eax
  801420:	6a 15                	push   $0x15
  801422:	e8 e3 fd ff ff       	call   80120a <syscall>
  801427:	83 c4 18             	add    $0x18,%esp
}
  80142a:	c9                   	leave  
  80142b:	c3                   	ret    

0080142c <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80142f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	6a 00                	push   $0x0
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	52                   	push   %edx
  80143c:	50                   	push   %eax
  80143d:	6a 16                	push   $0x16
  80143f:	e8 c6 fd ff ff       	call   80120a <syscall>
  801444:	83 c4 18             	add    $0x18,%esp
}
  801447:	c9                   	leave  
  801448:	c3                   	ret    

00801449 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80144c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80144f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	6a 00                	push   $0x0
  801457:	6a 00                	push   $0x0
  801459:	51                   	push   %ecx
  80145a:	52                   	push   %edx
  80145b:	50                   	push   %eax
  80145c:	6a 17                	push   $0x17
  80145e:	e8 a7 fd ff ff       	call   80120a <syscall>
  801463:	83 c4 18             	add    $0x18,%esp
}
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80146b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	52                   	push   %edx
  801478:	50                   	push   %eax
  801479:	6a 18                	push   $0x18
  80147b:	e8 8a fd ff ff       	call   80120a <syscall>
  801480:	83 c4 18             	add    $0x18,%esp
}
  801483:	c9                   	leave  
  801484:	c3                   	ret    

00801485 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	6a 00                	push   $0x0
  80148d:	ff 75 14             	pushl  0x14(%ebp)
  801490:	ff 75 10             	pushl  0x10(%ebp)
  801493:	ff 75 0c             	pushl  0xc(%ebp)
  801496:	50                   	push   %eax
  801497:	6a 19                	push   $0x19
  801499:	e8 6c fd ff ff       	call   80120a <syscall>
  80149e:	83 c4 18             	add    $0x18,%esp
}
  8014a1:	c9                   	leave  
  8014a2:	c3                   	ret    

008014a3 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	50                   	push   %eax
  8014b2:	6a 1a                	push   $0x1a
  8014b4:	e8 51 fd ff ff       	call   80120a <syscall>
  8014b9:	83 c4 18             	add    $0x18,%esp
}
  8014bc:	90                   	nop
  8014bd:	c9                   	leave  
  8014be:	c3                   	ret    

008014bf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014bf:	55                   	push   %ebp
  8014c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	50                   	push   %eax
  8014ce:	6a 1b                	push   $0x1b
  8014d0:	e8 35 fd ff ff       	call   80120a <syscall>
  8014d5:	83 c4 18             	add    $0x18,%esp
}
  8014d8:	c9                   	leave  
  8014d9:	c3                   	ret    

008014da <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 00                	push   $0x0
  8014e1:	6a 00                	push   $0x0
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 05                	push   $0x5
  8014e9:	e8 1c fd ff ff       	call   80120a <syscall>
  8014ee:	83 c4 18             	add    $0x18,%esp
}
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    

008014f3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 06                	push   $0x6
  801502:	e8 03 fd ff ff       	call   80120a <syscall>
  801507:	83 c4 18             	add    $0x18,%esp
}
  80150a:	c9                   	leave  
  80150b:	c3                   	ret    

0080150c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80150c:	55                   	push   %ebp
  80150d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 07                	push   $0x7
  80151b:	e8 ea fc ff ff       	call   80120a <syscall>
  801520:	83 c4 18             	add    $0x18,%esp
}
  801523:	c9                   	leave  
  801524:	c3                   	ret    

00801525 <sys_exit_env>:


void sys_exit_env(void)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	6a 1c                	push   $0x1c
  801534:	e8 d1 fc ff ff       	call   80120a <syscall>
  801539:	83 c4 18             	add    $0x18,%esp
}
  80153c:	90                   	nop
  80153d:	c9                   	leave  
  80153e:	c3                   	ret    

0080153f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
  801542:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801545:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801548:	8d 50 04             	lea    0x4(%eax),%edx
  80154b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	52                   	push   %edx
  801555:	50                   	push   %eax
  801556:	6a 1d                	push   $0x1d
  801558:	e8 ad fc ff ff       	call   80120a <syscall>
  80155d:	83 c4 18             	add    $0x18,%esp
	return result;
  801560:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801563:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801566:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801569:	89 01                	mov    %eax,(%ecx)
  80156b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80156e:	8b 45 08             	mov    0x8(%ebp),%eax
  801571:	c9                   	leave  
  801572:	c2 04 00             	ret    $0x4

00801575 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	ff 75 10             	pushl  0x10(%ebp)
  80157f:	ff 75 0c             	pushl  0xc(%ebp)
  801582:	ff 75 08             	pushl  0x8(%ebp)
  801585:	6a 13                	push   $0x13
  801587:	e8 7e fc ff ff       	call   80120a <syscall>
  80158c:	83 c4 18             	add    $0x18,%esp
	return ;
  80158f:	90                   	nop
}
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <sys_rcr2>:
uint32 sys_rcr2()
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 1e                	push   $0x1e
  8015a1:	e8 64 fc ff ff       	call   80120a <syscall>
  8015a6:	83 c4 18             	add    $0x18,%esp
}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	83 ec 04             	sub    $0x4,%esp
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015b7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	50                   	push   %eax
  8015c4:	6a 1f                	push   $0x1f
  8015c6:	e8 3f fc ff ff       	call   80120a <syscall>
  8015cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8015ce:	90                   	nop
}
  8015cf:	c9                   	leave  
  8015d0:	c3                   	ret    

008015d1 <rsttst>:
void rsttst()
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 21                	push   $0x21
  8015e0:	e8 25 fc ff ff       	call   80120a <syscall>
  8015e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8015e8:	90                   	nop
}
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    

008015eb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
  8015ee:	83 ec 04             	sub    $0x4,%esp
  8015f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8015f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015f7:	8b 55 18             	mov    0x18(%ebp),%edx
  8015fa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015fe:	52                   	push   %edx
  8015ff:	50                   	push   %eax
  801600:	ff 75 10             	pushl  0x10(%ebp)
  801603:	ff 75 0c             	pushl  0xc(%ebp)
  801606:	ff 75 08             	pushl  0x8(%ebp)
  801609:	6a 20                	push   $0x20
  80160b:	e8 fa fb ff ff       	call   80120a <syscall>
  801610:	83 c4 18             	add    $0x18,%esp
	return ;
  801613:	90                   	nop
}
  801614:	c9                   	leave  
  801615:	c3                   	ret    

00801616 <chktst>:
void chktst(uint32 n)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	ff 75 08             	pushl  0x8(%ebp)
  801624:	6a 22                	push   $0x22
  801626:	e8 df fb ff ff       	call   80120a <syscall>
  80162b:	83 c4 18             	add    $0x18,%esp
	return ;
  80162e:	90                   	nop
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <inctst>:

void inctst()
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 23                	push   $0x23
  801640:	e8 c5 fb ff ff       	call   80120a <syscall>
  801645:	83 c4 18             	add    $0x18,%esp
	return ;
  801648:	90                   	nop
}
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <gettst>:
uint32 gettst()
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 24                	push   $0x24
  80165a:	e8 ab fb ff ff       	call   80120a <syscall>
  80165f:	83 c4 18             	add    $0x18,%esp
}
  801662:	c9                   	leave  
  801663:	c3                   	ret    

00801664 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
  801667:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 25                	push   $0x25
  801676:	e8 8f fb ff ff       	call   80120a <syscall>
  80167b:	83 c4 18             	add    $0x18,%esp
  80167e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801681:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801685:	75 07                	jne    80168e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801687:	b8 01 00 00 00       	mov    $0x1,%eax
  80168c:	eb 05                	jmp    801693 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80168e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 25                	push   $0x25
  8016a7:	e8 5e fb ff ff       	call   80120a <syscall>
  8016ac:	83 c4 18             	add    $0x18,%esp
  8016af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016b2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016b6:	75 07                	jne    8016bf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016b8:	b8 01 00 00 00       	mov    $0x1,%eax
  8016bd:	eb 05                	jmp    8016c4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 25                	push   $0x25
  8016d8:	e8 2d fb ff ff       	call   80120a <syscall>
  8016dd:	83 c4 18             	add    $0x18,%esp
  8016e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016e3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016e7:	75 07                	jne    8016f0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8016ee:	eb 05                	jmp    8016f5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 25                	push   $0x25
  801709:	e8 fc fa ff ff       	call   80120a <syscall>
  80170e:	83 c4 18             	add    $0x18,%esp
  801711:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801714:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801718:	75 07                	jne    801721 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80171a:	b8 01 00 00 00       	mov    $0x1,%eax
  80171f:	eb 05                	jmp    801726 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801721:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801726:	c9                   	leave  
  801727:	c3                   	ret    

00801728 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	ff 75 08             	pushl  0x8(%ebp)
  801736:	6a 26                	push   $0x26
  801738:	e8 cd fa ff ff       	call   80120a <syscall>
  80173d:	83 c4 18             	add    $0x18,%esp
	return ;
  801740:	90                   	nop
}
  801741:	c9                   	leave  
  801742:	c3                   	ret    

00801743 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
  801746:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801747:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80174a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80174d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
  801753:	6a 00                	push   $0x0
  801755:	53                   	push   %ebx
  801756:	51                   	push   %ecx
  801757:	52                   	push   %edx
  801758:	50                   	push   %eax
  801759:	6a 27                	push   $0x27
  80175b:	e8 aa fa ff ff       	call   80120a <syscall>
  801760:	83 c4 18             	add    $0x18,%esp
}
  801763:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80176b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	52                   	push   %edx
  801778:	50                   	push   %eax
  801779:	6a 28                	push   $0x28
  80177b:	e8 8a fa ff ff       	call   80120a <syscall>
  801780:	83 c4 18             	add    $0x18,%esp
}
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801788:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80178b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
  801791:	6a 00                	push   $0x0
  801793:	51                   	push   %ecx
  801794:	ff 75 10             	pushl  0x10(%ebp)
  801797:	52                   	push   %edx
  801798:	50                   	push   %eax
  801799:	6a 29                	push   $0x29
  80179b:	e8 6a fa ff ff       	call   80120a <syscall>
  8017a0:	83 c4 18             	add    $0x18,%esp
}
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	ff 75 10             	pushl  0x10(%ebp)
  8017af:	ff 75 0c             	pushl  0xc(%ebp)
  8017b2:	ff 75 08             	pushl  0x8(%ebp)
  8017b5:	6a 12                	push   $0x12
  8017b7:	e8 4e fa ff ff       	call   80120a <syscall>
  8017bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8017bf:	90                   	nop
}
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8017c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	52                   	push   %edx
  8017d2:	50                   	push   %eax
  8017d3:	6a 2a                	push   $0x2a
  8017d5:	e8 30 fa ff ff       	call   80120a <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
	return;
  8017dd:	90                   	nop
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8017e6:	83 ec 04             	sub    $0x4,%esp
  8017e9:	68 17 21 80 00       	push   $0x802117
  8017ee:	68 2e 01 00 00       	push   $0x12e
  8017f3:	68 2b 21 80 00       	push   $0x80212b
  8017f8:	e8 b6 e9 ff ff       	call   8001b3 <_panic>

008017fd <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801803:	83 ec 04             	sub    $0x4,%esp
  801806:	68 17 21 80 00       	push   $0x802117
  80180b:	68 35 01 00 00       	push   $0x135
  801810:	68 2b 21 80 00       	push   $0x80212b
  801815:	e8 99 e9 ff ff       	call   8001b3 <_panic>

0080181a <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801820:	83 ec 04             	sub    $0x4,%esp
  801823:	68 17 21 80 00       	push   $0x802117
  801828:	68 3b 01 00 00       	push   $0x13b
  80182d:	68 2b 21 80 00       	push   $0x80212b
  801832:	e8 7c e9 ff ff       	call   8001b3 <_panic>
  801837:	90                   	nop

00801838 <__udivdi3>:
  801838:	55                   	push   %ebp
  801839:	57                   	push   %edi
  80183a:	56                   	push   %esi
  80183b:	53                   	push   %ebx
  80183c:	83 ec 1c             	sub    $0x1c,%esp
  80183f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801843:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801847:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80184b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80184f:	89 ca                	mov    %ecx,%edx
  801851:	89 f8                	mov    %edi,%eax
  801853:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801857:	85 f6                	test   %esi,%esi
  801859:	75 2d                	jne    801888 <__udivdi3+0x50>
  80185b:	39 cf                	cmp    %ecx,%edi
  80185d:	77 65                	ja     8018c4 <__udivdi3+0x8c>
  80185f:	89 fd                	mov    %edi,%ebp
  801861:	85 ff                	test   %edi,%edi
  801863:	75 0b                	jne    801870 <__udivdi3+0x38>
  801865:	b8 01 00 00 00       	mov    $0x1,%eax
  80186a:	31 d2                	xor    %edx,%edx
  80186c:	f7 f7                	div    %edi
  80186e:	89 c5                	mov    %eax,%ebp
  801870:	31 d2                	xor    %edx,%edx
  801872:	89 c8                	mov    %ecx,%eax
  801874:	f7 f5                	div    %ebp
  801876:	89 c1                	mov    %eax,%ecx
  801878:	89 d8                	mov    %ebx,%eax
  80187a:	f7 f5                	div    %ebp
  80187c:	89 cf                	mov    %ecx,%edi
  80187e:	89 fa                	mov    %edi,%edx
  801880:	83 c4 1c             	add    $0x1c,%esp
  801883:	5b                   	pop    %ebx
  801884:	5e                   	pop    %esi
  801885:	5f                   	pop    %edi
  801886:	5d                   	pop    %ebp
  801887:	c3                   	ret    
  801888:	39 ce                	cmp    %ecx,%esi
  80188a:	77 28                	ja     8018b4 <__udivdi3+0x7c>
  80188c:	0f bd fe             	bsr    %esi,%edi
  80188f:	83 f7 1f             	xor    $0x1f,%edi
  801892:	75 40                	jne    8018d4 <__udivdi3+0x9c>
  801894:	39 ce                	cmp    %ecx,%esi
  801896:	72 0a                	jb     8018a2 <__udivdi3+0x6a>
  801898:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80189c:	0f 87 9e 00 00 00    	ja     801940 <__udivdi3+0x108>
  8018a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8018a7:	89 fa                	mov    %edi,%edx
  8018a9:	83 c4 1c             	add    $0x1c,%esp
  8018ac:	5b                   	pop    %ebx
  8018ad:	5e                   	pop    %esi
  8018ae:	5f                   	pop    %edi
  8018af:	5d                   	pop    %ebp
  8018b0:	c3                   	ret    
  8018b1:	8d 76 00             	lea    0x0(%esi),%esi
  8018b4:	31 ff                	xor    %edi,%edi
  8018b6:	31 c0                	xor    %eax,%eax
  8018b8:	89 fa                	mov    %edi,%edx
  8018ba:	83 c4 1c             	add    $0x1c,%esp
  8018bd:	5b                   	pop    %ebx
  8018be:	5e                   	pop    %esi
  8018bf:	5f                   	pop    %edi
  8018c0:	5d                   	pop    %ebp
  8018c1:	c3                   	ret    
  8018c2:	66 90                	xchg   %ax,%ax
  8018c4:	89 d8                	mov    %ebx,%eax
  8018c6:	f7 f7                	div    %edi
  8018c8:	31 ff                	xor    %edi,%edi
  8018ca:	89 fa                	mov    %edi,%edx
  8018cc:	83 c4 1c             	add    $0x1c,%esp
  8018cf:	5b                   	pop    %ebx
  8018d0:	5e                   	pop    %esi
  8018d1:	5f                   	pop    %edi
  8018d2:	5d                   	pop    %ebp
  8018d3:	c3                   	ret    
  8018d4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8018d9:	89 eb                	mov    %ebp,%ebx
  8018db:	29 fb                	sub    %edi,%ebx
  8018dd:	89 f9                	mov    %edi,%ecx
  8018df:	d3 e6                	shl    %cl,%esi
  8018e1:	89 c5                	mov    %eax,%ebp
  8018e3:	88 d9                	mov    %bl,%cl
  8018e5:	d3 ed                	shr    %cl,%ebp
  8018e7:	89 e9                	mov    %ebp,%ecx
  8018e9:	09 f1                	or     %esi,%ecx
  8018eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8018ef:	89 f9                	mov    %edi,%ecx
  8018f1:	d3 e0                	shl    %cl,%eax
  8018f3:	89 c5                	mov    %eax,%ebp
  8018f5:	89 d6                	mov    %edx,%esi
  8018f7:	88 d9                	mov    %bl,%cl
  8018f9:	d3 ee                	shr    %cl,%esi
  8018fb:	89 f9                	mov    %edi,%ecx
  8018fd:	d3 e2                	shl    %cl,%edx
  8018ff:	8b 44 24 08          	mov    0x8(%esp),%eax
  801903:	88 d9                	mov    %bl,%cl
  801905:	d3 e8                	shr    %cl,%eax
  801907:	09 c2                	or     %eax,%edx
  801909:	89 d0                	mov    %edx,%eax
  80190b:	89 f2                	mov    %esi,%edx
  80190d:	f7 74 24 0c          	divl   0xc(%esp)
  801911:	89 d6                	mov    %edx,%esi
  801913:	89 c3                	mov    %eax,%ebx
  801915:	f7 e5                	mul    %ebp
  801917:	39 d6                	cmp    %edx,%esi
  801919:	72 19                	jb     801934 <__udivdi3+0xfc>
  80191b:	74 0b                	je     801928 <__udivdi3+0xf0>
  80191d:	89 d8                	mov    %ebx,%eax
  80191f:	31 ff                	xor    %edi,%edi
  801921:	e9 58 ff ff ff       	jmp    80187e <__udivdi3+0x46>
  801926:	66 90                	xchg   %ax,%ax
  801928:	8b 54 24 08          	mov    0x8(%esp),%edx
  80192c:	89 f9                	mov    %edi,%ecx
  80192e:	d3 e2                	shl    %cl,%edx
  801930:	39 c2                	cmp    %eax,%edx
  801932:	73 e9                	jae    80191d <__udivdi3+0xe5>
  801934:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801937:	31 ff                	xor    %edi,%edi
  801939:	e9 40 ff ff ff       	jmp    80187e <__udivdi3+0x46>
  80193e:	66 90                	xchg   %ax,%ax
  801940:	31 c0                	xor    %eax,%eax
  801942:	e9 37 ff ff ff       	jmp    80187e <__udivdi3+0x46>
  801947:	90                   	nop

00801948 <__umoddi3>:
  801948:	55                   	push   %ebp
  801949:	57                   	push   %edi
  80194a:	56                   	push   %esi
  80194b:	53                   	push   %ebx
  80194c:	83 ec 1c             	sub    $0x1c,%esp
  80194f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801953:	8b 74 24 34          	mov    0x34(%esp),%esi
  801957:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80195b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80195f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801963:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801967:	89 f3                	mov    %esi,%ebx
  801969:	89 fa                	mov    %edi,%edx
  80196b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80196f:	89 34 24             	mov    %esi,(%esp)
  801972:	85 c0                	test   %eax,%eax
  801974:	75 1a                	jne    801990 <__umoddi3+0x48>
  801976:	39 f7                	cmp    %esi,%edi
  801978:	0f 86 a2 00 00 00    	jbe    801a20 <__umoddi3+0xd8>
  80197e:	89 c8                	mov    %ecx,%eax
  801980:	89 f2                	mov    %esi,%edx
  801982:	f7 f7                	div    %edi
  801984:	89 d0                	mov    %edx,%eax
  801986:	31 d2                	xor    %edx,%edx
  801988:	83 c4 1c             	add    $0x1c,%esp
  80198b:	5b                   	pop    %ebx
  80198c:	5e                   	pop    %esi
  80198d:	5f                   	pop    %edi
  80198e:	5d                   	pop    %ebp
  80198f:	c3                   	ret    
  801990:	39 f0                	cmp    %esi,%eax
  801992:	0f 87 ac 00 00 00    	ja     801a44 <__umoddi3+0xfc>
  801998:	0f bd e8             	bsr    %eax,%ebp
  80199b:	83 f5 1f             	xor    $0x1f,%ebp
  80199e:	0f 84 ac 00 00 00    	je     801a50 <__umoddi3+0x108>
  8019a4:	bf 20 00 00 00       	mov    $0x20,%edi
  8019a9:	29 ef                	sub    %ebp,%edi
  8019ab:	89 fe                	mov    %edi,%esi
  8019ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8019b1:	89 e9                	mov    %ebp,%ecx
  8019b3:	d3 e0                	shl    %cl,%eax
  8019b5:	89 d7                	mov    %edx,%edi
  8019b7:	89 f1                	mov    %esi,%ecx
  8019b9:	d3 ef                	shr    %cl,%edi
  8019bb:	09 c7                	or     %eax,%edi
  8019bd:	89 e9                	mov    %ebp,%ecx
  8019bf:	d3 e2                	shl    %cl,%edx
  8019c1:	89 14 24             	mov    %edx,(%esp)
  8019c4:	89 d8                	mov    %ebx,%eax
  8019c6:	d3 e0                	shl    %cl,%eax
  8019c8:	89 c2                	mov    %eax,%edx
  8019ca:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019ce:	d3 e0                	shl    %cl,%eax
  8019d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019d8:	89 f1                	mov    %esi,%ecx
  8019da:	d3 e8                	shr    %cl,%eax
  8019dc:	09 d0                	or     %edx,%eax
  8019de:	d3 eb                	shr    %cl,%ebx
  8019e0:	89 da                	mov    %ebx,%edx
  8019e2:	f7 f7                	div    %edi
  8019e4:	89 d3                	mov    %edx,%ebx
  8019e6:	f7 24 24             	mull   (%esp)
  8019e9:	89 c6                	mov    %eax,%esi
  8019eb:	89 d1                	mov    %edx,%ecx
  8019ed:	39 d3                	cmp    %edx,%ebx
  8019ef:	0f 82 87 00 00 00    	jb     801a7c <__umoddi3+0x134>
  8019f5:	0f 84 91 00 00 00    	je     801a8c <__umoddi3+0x144>
  8019fb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8019ff:	29 f2                	sub    %esi,%edx
  801a01:	19 cb                	sbb    %ecx,%ebx
  801a03:	89 d8                	mov    %ebx,%eax
  801a05:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a09:	d3 e0                	shl    %cl,%eax
  801a0b:	89 e9                	mov    %ebp,%ecx
  801a0d:	d3 ea                	shr    %cl,%edx
  801a0f:	09 d0                	or     %edx,%eax
  801a11:	89 e9                	mov    %ebp,%ecx
  801a13:	d3 eb                	shr    %cl,%ebx
  801a15:	89 da                	mov    %ebx,%edx
  801a17:	83 c4 1c             	add    $0x1c,%esp
  801a1a:	5b                   	pop    %ebx
  801a1b:	5e                   	pop    %esi
  801a1c:	5f                   	pop    %edi
  801a1d:	5d                   	pop    %ebp
  801a1e:	c3                   	ret    
  801a1f:	90                   	nop
  801a20:	89 fd                	mov    %edi,%ebp
  801a22:	85 ff                	test   %edi,%edi
  801a24:	75 0b                	jne    801a31 <__umoddi3+0xe9>
  801a26:	b8 01 00 00 00       	mov    $0x1,%eax
  801a2b:	31 d2                	xor    %edx,%edx
  801a2d:	f7 f7                	div    %edi
  801a2f:	89 c5                	mov    %eax,%ebp
  801a31:	89 f0                	mov    %esi,%eax
  801a33:	31 d2                	xor    %edx,%edx
  801a35:	f7 f5                	div    %ebp
  801a37:	89 c8                	mov    %ecx,%eax
  801a39:	f7 f5                	div    %ebp
  801a3b:	89 d0                	mov    %edx,%eax
  801a3d:	e9 44 ff ff ff       	jmp    801986 <__umoddi3+0x3e>
  801a42:	66 90                	xchg   %ax,%ax
  801a44:	89 c8                	mov    %ecx,%eax
  801a46:	89 f2                	mov    %esi,%edx
  801a48:	83 c4 1c             	add    $0x1c,%esp
  801a4b:	5b                   	pop    %ebx
  801a4c:	5e                   	pop    %esi
  801a4d:	5f                   	pop    %edi
  801a4e:	5d                   	pop    %ebp
  801a4f:	c3                   	ret    
  801a50:	3b 04 24             	cmp    (%esp),%eax
  801a53:	72 06                	jb     801a5b <__umoddi3+0x113>
  801a55:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a59:	77 0f                	ja     801a6a <__umoddi3+0x122>
  801a5b:	89 f2                	mov    %esi,%edx
  801a5d:	29 f9                	sub    %edi,%ecx
  801a5f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801a63:	89 14 24             	mov    %edx,(%esp)
  801a66:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a6a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801a6e:	8b 14 24             	mov    (%esp),%edx
  801a71:	83 c4 1c             	add    $0x1c,%esp
  801a74:	5b                   	pop    %ebx
  801a75:	5e                   	pop    %esi
  801a76:	5f                   	pop    %edi
  801a77:	5d                   	pop    %ebp
  801a78:	c3                   	ret    
  801a79:	8d 76 00             	lea    0x0(%esi),%esi
  801a7c:	2b 04 24             	sub    (%esp),%eax
  801a7f:	19 fa                	sbb    %edi,%edx
  801a81:	89 d1                	mov    %edx,%ecx
  801a83:	89 c6                	mov    %eax,%esi
  801a85:	e9 71 ff ff ff       	jmp    8019fb <__umoddi3+0xb3>
  801a8a:	66 90                	xchg   %ax,%ax
  801a8c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801a90:	72 ea                	jb     801a7c <__umoddi3+0x134>
  801a92:	89 d9                	mov    %ebx,%ecx
  801a94:	e9 62 ff ff ff       	jmp    8019fb <__umoddi3+0xb3>
