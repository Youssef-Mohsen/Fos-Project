
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
  800045:	e8 bf 17 00 00       	call   801809 <sys_allocate_user_mem>
  80004a:	83 c4 10             	add    $0x10,%esp
	inctst();
  80004d:	e8 d1 15 00 00       	call   801623 <inctst>
	panic("tst system calls #2 failed: sys_allocate_user_mem is called with invalid params\nThe env must be killed and shouldn't return here.");
  800052:	83 ec 04             	sub    $0x4,%esp
  800055:	68 40 1b 80 00       	push   $0x801b40
  80005a:	6a 0a                	push   $0xa
  80005c:	68 c2 1b 80 00       	push   $0x801bc2
  800061:	e8 3f 01 00 00       	call   8001a5 <_panic>

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
  80006c:	e8 74 14 00 00       	call   8014e5 <sys_getenvindex>
  800071:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800074:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800077:	89 d0                	mov    %edx,%eax
  800079:	c1 e0 03             	shl    $0x3,%eax
  80007c:	01 d0                	add    %edx,%eax
  80007e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800085:	01 c8                	add    %ecx,%eax
  800087:	01 c0                	add    %eax,%eax
  800089:	01 d0                	add    %edx,%eax
  80008b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800092:	01 c8                	add    %ecx,%eax
  800094:	01 d0                	add    %edx,%eax
  800096:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80009b:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000a0:	a1 04 30 80 00       	mov    0x803004,%eax
  8000a5:	8a 40 20             	mov    0x20(%eax),%al
  8000a8:	84 c0                	test   %al,%al
  8000aa:	74 0d                	je     8000b9 <libmain+0x53>
		binaryname = myEnv->prog_name;
  8000ac:	a1 04 30 80 00       	mov    0x803004,%eax
  8000b1:	83 c0 20             	add    $0x20,%eax
  8000b4:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000bd:	7e 0a                	jle    8000c9 <libmain+0x63>
		binaryname = argv[0];
  8000bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000c2:	8b 00                	mov    (%eax),%eax
  8000c4:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000c9:	83 ec 08             	sub    $0x8,%esp
  8000cc:	ff 75 0c             	pushl  0xc(%ebp)
  8000cf:	ff 75 08             	pushl  0x8(%ebp)
  8000d2:	e8 61 ff ff ff       	call   800038 <_main>
  8000d7:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8000da:	e8 8a 11 00 00       	call   801269 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 f8 1b 80 00       	push   $0x801bf8
  8000e7:	e8 76 03 00 00       	call   800462 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000ef:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f4:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000fa:	a1 04 30 80 00       	mov    0x803004,%eax
  8000ff:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800105:	83 ec 04             	sub    $0x4,%esp
  800108:	52                   	push   %edx
  800109:	50                   	push   %eax
  80010a:	68 20 1c 80 00       	push   $0x801c20
  80010f:	e8 4e 03 00 00       	call   800462 <cprintf>
  800114:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800117:	a1 04 30 80 00       	mov    0x803004,%eax
  80011c:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800122:	a1 04 30 80 00       	mov    0x803004,%eax
  800127:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80012d:	a1 04 30 80 00       	mov    0x803004,%eax
  800132:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800138:	51                   	push   %ecx
  800139:	52                   	push   %edx
  80013a:	50                   	push   %eax
  80013b:	68 48 1c 80 00       	push   $0x801c48
  800140:	e8 1d 03 00 00       	call   800462 <cprintf>
  800145:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800148:	a1 04 30 80 00       	mov    0x803004,%eax
  80014d:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800153:	83 ec 08             	sub    $0x8,%esp
  800156:	50                   	push   %eax
  800157:	68 a0 1c 80 00       	push   $0x801ca0
  80015c:	e8 01 03 00 00       	call   800462 <cprintf>
  800161:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800164:	83 ec 0c             	sub    $0xc,%esp
  800167:	68 f8 1b 80 00       	push   $0x801bf8
  80016c:	e8 f1 02 00 00       	call   800462 <cprintf>
  800171:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800174:	e8 0a 11 00 00       	call   801283 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800179:	e8 19 00 00 00       	call   800197 <exit>
}
  80017e:	90                   	nop
  80017f:	c9                   	leave  
  800180:	c3                   	ret    

00800181 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	6a 00                	push   $0x0
  80018c:	e8 20 13 00 00       	call   8014b1 <sys_destroy_env>
  800191:	83 c4 10             	add    $0x10,%esp
}
  800194:	90                   	nop
  800195:	c9                   	leave  
  800196:	c3                   	ret    

00800197 <exit>:

void
exit(void)
{
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80019d:	e8 75 13 00 00       	call   801517 <sys_exit_env>
}
  8001a2:	90                   	nop
  8001a3:	c9                   	leave  
  8001a4:	c3                   	ret    

008001a5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001a5:	55                   	push   %ebp
  8001a6:	89 e5                	mov    %esp,%ebp
  8001a8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001ab:	8d 45 10             	lea    0x10(%ebp),%eax
  8001ae:	83 c0 04             	add    $0x4,%eax
  8001b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001b4:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8001b9:	85 c0                	test   %eax,%eax
  8001bb:	74 16                	je     8001d3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001bd:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8001c2:	83 ec 08             	sub    $0x8,%esp
  8001c5:	50                   	push   %eax
  8001c6:	68 b4 1c 80 00       	push   $0x801cb4
  8001cb:	e8 92 02 00 00       	call   800462 <cprintf>
  8001d0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001d3:	a1 00 30 80 00       	mov    0x803000,%eax
  8001d8:	ff 75 0c             	pushl  0xc(%ebp)
  8001db:	ff 75 08             	pushl  0x8(%ebp)
  8001de:	50                   	push   %eax
  8001df:	68 b9 1c 80 00       	push   $0x801cb9
  8001e4:	e8 79 02 00 00       	call   800462 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8001f5:	50                   	push   %eax
  8001f6:	e8 fc 01 00 00       	call   8003f7 <vcprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8001fe:	83 ec 08             	sub    $0x8,%esp
  800201:	6a 00                	push   $0x0
  800203:	68 d5 1c 80 00       	push   $0x801cd5
  800208:	e8 ea 01 00 00       	call   8003f7 <vcprintf>
  80020d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800210:	e8 82 ff ff ff       	call   800197 <exit>

	// should not return here
	while (1) ;
  800215:	eb fe                	jmp    800215 <_panic+0x70>

00800217 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800217:	55                   	push   %ebp
  800218:	89 e5                	mov    %esp,%ebp
  80021a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80021d:	a1 04 30 80 00       	mov    0x803004,%eax
  800222:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022b:	39 c2                	cmp    %eax,%edx
  80022d:	74 14                	je     800243 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	68 d8 1c 80 00       	push   $0x801cd8
  800237:	6a 26                	push   $0x26
  800239:	68 24 1d 80 00       	push   $0x801d24
  80023e:	e8 62 ff ff ff       	call   8001a5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800243:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80024a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800251:	e9 c5 00 00 00       	jmp    80031b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800256:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800259:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800260:	8b 45 08             	mov    0x8(%ebp),%eax
  800263:	01 d0                	add    %edx,%eax
  800265:	8b 00                	mov    (%eax),%eax
  800267:	85 c0                	test   %eax,%eax
  800269:	75 08                	jne    800273 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80026b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80026e:	e9 a5 00 00 00       	jmp    800318 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800273:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80027a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800281:	eb 69                	jmp    8002ec <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800283:	a1 04 30 80 00       	mov    0x803004,%eax
  800288:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80028e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800291:	89 d0                	mov    %edx,%eax
  800293:	01 c0                	add    %eax,%eax
  800295:	01 d0                	add    %edx,%eax
  800297:	c1 e0 03             	shl    $0x3,%eax
  80029a:	01 c8                	add    %ecx,%eax
  80029c:	8a 40 04             	mov    0x4(%eax),%al
  80029f:	84 c0                	test   %al,%al
  8002a1:	75 46                	jne    8002e9 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002a3:	a1 04 30 80 00       	mov    0x803004,%eax
  8002a8:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8002ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002b1:	89 d0                	mov    %edx,%eax
  8002b3:	01 c0                	add    %eax,%eax
  8002b5:	01 d0                	add    %edx,%eax
  8002b7:	c1 e0 03             	shl    $0x3,%eax
  8002ba:	01 c8                	add    %ecx,%eax
  8002bc:	8b 00                	mov    (%eax),%eax
  8002be:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002c9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002ce:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d8:	01 c8                	add    %ecx,%eax
  8002da:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002dc:	39 c2                	cmp    %eax,%edx
  8002de:	75 09                	jne    8002e9 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002e0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002e7:	eb 15                	jmp    8002fe <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002e9:	ff 45 e8             	incl   -0x18(%ebp)
  8002ec:	a1 04 30 80 00       	mov    0x803004,%eax
  8002f1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8002f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002fa:	39 c2                	cmp    %eax,%edx
  8002fc:	77 85                	ja     800283 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8002fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800302:	75 14                	jne    800318 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	68 30 1d 80 00       	push   $0x801d30
  80030c:	6a 3a                	push   $0x3a
  80030e:	68 24 1d 80 00       	push   $0x801d24
  800313:	e8 8d fe ff ff       	call   8001a5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800318:	ff 45 f0             	incl   -0x10(%ebp)
  80031b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80031e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800321:	0f 8c 2f ff ff ff    	jl     800256 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800327:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80032e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800335:	eb 26                	jmp    80035d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800337:	a1 04 30 80 00       	mov    0x803004,%eax
  80033c:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800342:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800345:	89 d0                	mov    %edx,%eax
  800347:	01 c0                	add    %eax,%eax
  800349:	01 d0                	add    %edx,%eax
  80034b:	c1 e0 03             	shl    $0x3,%eax
  80034e:	01 c8                	add    %ecx,%eax
  800350:	8a 40 04             	mov    0x4(%eax),%al
  800353:	3c 01                	cmp    $0x1,%al
  800355:	75 03                	jne    80035a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800357:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80035a:	ff 45 e0             	incl   -0x20(%ebp)
  80035d:	a1 04 30 80 00       	mov    0x803004,%eax
  800362:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800368:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80036b:	39 c2                	cmp    %eax,%edx
  80036d:	77 c8                	ja     800337 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80036f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800372:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800375:	74 14                	je     80038b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800377:	83 ec 04             	sub    $0x4,%esp
  80037a:	68 84 1d 80 00       	push   $0x801d84
  80037f:	6a 44                	push   $0x44
  800381:	68 24 1d 80 00       	push   $0x801d24
  800386:	e8 1a fe ff ff       	call   8001a5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80038b:	90                   	nop
  80038c:	c9                   	leave  
  80038d:	c3                   	ret    

0080038e <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80038e:	55                   	push   %ebp
  80038f:	89 e5                	mov    %esp,%ebp
  800391:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800394:	8b 45 0c             	mov    0xc(%ebp),%eax
  800397:	8b 00                	mov    (%eax),%eax
  800399:	8d 48 01             	lea    0x1(%eax),%ecx
  80039c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80039f:	89 0a                	mov    %ecx,(%edx)
  8003a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a4:	88 d1                	mov    %dl,%cl
  8003a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b0:	8b 00                	mov    (%eax),%eax
  8003b2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b7:	75 2c                	jne    8003e5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003b9:	a0 08 30 80 00       	mov    0x803008,%al
  8003be:	0f b6 c0             	movzbl %al,%eax
  8003c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c4:	8b 12                	mov    (%edx),%edx
  8003c6:	89 d1                	mov    %edx,%ecx
  8003c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003cb:	83 c2 08             	add    $0x8,%edx
  8003ce:	83 ec 04             	sub    $0x4,%esp
  8003d1:	50                   	push   %eax
  8003d2:	51                   	push   %ecx
  8003d3:	52                   	push   %edx
  8003d4:	e8 4e 0e 00 00       	call   801227 <sys_cputs>
  8003d9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e8:	8b 40 04             	mov    0x4(%eax),%eax
  8003eb:	8d 50 01             	lea    0x1(%eax),%edx
  8003ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003f4:	90                   	nop
  8003f5:	c9                   	leave  
  8003f6:	c3                   	ret    

008003f7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003f7:	55                   	push   %ebp
  8003f8:	89 e5                	mov    %esp,%ebp
  8003fa:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800400:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800407:	00 00 00 
	b.cnt = 0;
  80040a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800411:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800414:	ff 75 0c             	pushl  0xc(%ebp)
  800417:	ff 75 08             	pushl  0x8(%ebp)
  80041a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800420:	50                   	push   %eax
  800421:	68 8e 03 80 00       	push   $0x80038e
  800426:	e8 11 02 00 00       	call   80063c <vprintfmt>
  80042b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80042e:	a0 08 30 80 00       	mov    0x803008,%al
  800433:	0f b6 c0             	movzbl %al,%eax
  800436:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80043c:	83 ec 04             	sub    $0x4,%esp
  80043f:	50                   	push   %eax
  800440:	52                   	push   %edx
  800441:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800447:	83 c0 08             	add    $0x8,%eax
  80044a:	50                   	push   %eax
  80044b:	e8 d7 0d 00 00       	call   801227 <sys_cputs>
  800450:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800453:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  80045a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800460:	c9                   	leave  
  800461:	c3                   	ret    

00800462 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800468:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  80046f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800472:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800475:	8b 45 08             	mov    0x8(%ebp),%eax
  800478:	83 ec 08             	sub    $0x8,%esp
  80047b:	ff 75 f4             	pushl  -0xc(%ebp)
  80047e:	50                   	push   %eax
  80047f:	e8 73 ff ff ff       	call   8003f7 <vcprintf>
  800484:	83 c4 10             	add    $0x10,%esp
  800487:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80048d:	c9                   	leave  
  80048e:	c3                   	ret    

0080048f <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
  800492:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800495:	e8 cf 0d 00 00       	call   801269 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80049a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80049d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8004a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a3:	83 ec 08             	sub    $0x8,%esp
  8004a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a9:	50                   	push   %eax
  8004aa:	e8 48 ff ff ff       	call   8003f7 <vcprintf>
  8004af:	83 c4 10             	add    $0x10,%esp
  8004b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004b5:	e8 c9 0d 00 00       	call   801283 <sys_unlock_cons>
	return cnt;
  8004ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004bd:	c9                   	leave  
  8004be:	c3                   	ret    

008004bf <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004bf:	55                   	push   %ebp
  8004c0:	89 e5                	mov    %esp,%ebp
  8004c2:	53                   	push   %ebx
  8004c3:	83 ec 14             	sub    $0x14,%esp
  8004c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004d2:	8b 45 18             	mov    0x18(%ebp),%eax
  8004d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8004da:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004dd:	77 55                	ja     800534 <printnum+0x75>
  8004df:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004e2:	72 05                	jb     8004e9 <printnum+0x2a>
  8004e4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004e7:	77 4b                	ja     800534 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004e9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004ec:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004ef:	8b 45 18             	mov    0x18(%ebp),%eax
  8004f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f7:	52                   	push   %edx
  8004f8:	50                   	push   %eax
  8004f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004fc:	ff 75 f0             	pushl  -0x10(%ebp)
  8004ff:	e8 c0 13 00 00       	call   8018c4 <__udivdi3>
  800504:	83 c4 10             	add    $0x10,%esp
  800507:	83 ec 04             	sub    $0x4,%esp
  80050a:	ff 75 20             	pushl  0x20(%ebp)
  80050d:	53                   	push   %ebx
  80050e:	ff 75 18             	pushl  0x18(%ebp)
  800511:	52                   	push   %edx
  800512:	50                   	push   %eax
  800513:	ff 75 0c             	pushl  0xc(%ebp)
  800516:	ff 75 08             	pushl  0x8(%ebp)
  800519:	e8 a1 ff ff ff       	call   8004bf <printnum>
  80051e:	83 c4 20             	add    $0x20,%esp
  800521:	eb 1a                	jmp    80053d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800523:	83 ec 08             	sub    $0x8,%esp
  800526:	ff 75 0c             	pushl  0xc(%ebp)
  800529:	ff 75 20             	pushl  0x20(%ebp)
  80052c:	8b 45 08             	mov    0x8(%ebp),%eax
  80052f:	ff d0                	call   *%eax
  800531:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800534:	ff 4d 1c             	decl   0x1c(%ebp)
  800537:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80053b:	7f e6                	jg     800523 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80053d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800540:	bb 00 00 00 00       	mov    $0x0,%ebx
  800545:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800548:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80054b:	53                   	push   %ebx
  80054c:	51                   	push   %ecx
  80054d:	52                   	push   %edx
  80054e:	50                   	push   %eax
  80054f:	e8 80 14 00 00       	call   8019d4 <__umoddi3>
  800554:	83 c4 10             	add    $0x10,%esp
  800557:	05 f4 1f 80 00       	add    $0x801ff4,%eax
  80055c:	8a 00                	mov    (%eax),%al
  80055e:	0f be c0             	movsbl %al,%eax
  800561:	83 ec 08             	sub    $0x8,%esp
  800564:	ff 75 0c             	pushl  0xc(%ebp)
  800567:	50                   	push   %eax
  800568:	8b 45 08             	mov    0x8(%ebp),%eax
  80056b:	ff d0                	call   *%eax
  80056d:	83 c4 10             	add    $0x10,%esp
}
  800570:	90                   	nop
  800571:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800574:	c9                   	leave  
  800575:	c3                   	ret    

00800576 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800576:	55                   	push   %ebp
  800577:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800579:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80057d:	7e 1c                	jle    80059b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80057f:	8b 45 08             	mov    0x8(%ebp),%eax
  800582:	8b 00                	mov    (%eax),%eax
  800584:	8d 50 08             	lea    0x8(%eax),%edx
  800587:	8b 45 08             	mov    0x8(%ebp),%eax
  80058a:	89 10                	mov    %edx,(%eax)
  80058c:	8b 45 08             	mov    0x8(%ebp),%eax
  80058f:	8b 00                	mov    (%eax),%eax
  800591:	83 e8 08             	sub    $0x8,%eax
  800594:	8b 50 04             	mov    0x4(%eax),%edx
  800597:	8b 00                	mov    (%eax),%eax
  800599:	eb 40                	jmp    8005db <getuint+0x65>
	else if (lflag)
  80059b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80059f:	74 1e                	je     8005bf <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a4:	8b 00                	mov    (%eax),%eax
  8005a6:	8d 50 04             	lea    0x4(%eax),%edx
  8005a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ac:	89 10                	mov    %edx,(%eax)
  8005ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b1:	8b 00                	mov    (%eax),%eax
  8005b3:	83 e8 04             	sub    $0x4,%eax
  8005b6:	8b 00                	mov    (%eax),%eax
  8005b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bd:	eb 1c                	jmp    8005db <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c2:	8b 00                	mov    (%eax),%eax
  8005c4:	8d 50 04             	lea    0x4(%eax),%edx
  8005c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ca:	89 10                	mov    %edx,(%eax)
  8005cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cf:	8b 00                	mov    (%eax),%eax
  8005d1:	83 e8 04             	sub    $0x4,%eax
  8005d4:	8b 00                	mov    (%eax),%eax
  8005d6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005db:	5d                   	pop    %ebp
  8005dc:	c3                   	ret    

008005dd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005dd:	55                   	push   %ebp
  8005de:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005e0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005e4:	7e 1c                	jle    800602 <getint+0x25>
		return va_arg(*ap, long long);
  8005e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e9:	8b 00                	mov    (%eax),%eax
  8005eb:	8d 50 08             	lea    0x8(%eax),%edx
  8005ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f1:	89 10                	mov    %edx,(%eax)
  8005f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	83 e8 08             	sub    $0x8,%eax
  8005fb:	8b 50 04             	mov    0x4(%eax),%edx
  8005fe:	8b 00                	mov    (%eax),%eax
  800600:	eb 38                	jmp    80063a <getint+0x5d>
	else if (lflag)
  800602:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800606:	74 1a                	je     800622 <getint+0x45>
		return va_arg(*ap, long);
  800608:	8b 45 08             	mov    0x8(%ebp),%eax
  80060b:	8b 00                	mov    (%eax),%eax
  80060d:	8d 50 04             	lea    0x4(%eax),%edx
  800610:	8b 45 08             	mov    0x8(%ebp),%eax
  800613:	89 10                	mov    %edx,(%eax)
  800615:	8b 45 08             	mov    0x8(%ebp),%eax
  800618:	8b 00                	mov    (%eax),%eax
  80061a:	83 e8 04             	sub    $0x4,%eax
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	99                   	cltd   
  800620:	eb 18                	jmp    80063a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800622:	8b 45 08             	mov    0x8(%ebp),%eax
  800625:	8b 00                	mov    (%eax),%eax
  800627:	8d 50 04             	lea    0x4(%eax),%edx
  80062a:	8b 45 08             	mov    0x8(%ebp),%eax
  80062d:	89 10                	mov    %edx,(%eax)
  80062f:	8b 45 08             	mov    0x8(%ebp),%eax
  800632:	8b 00                	mov    (%eax),%eax
  800634:	83 e8 04             	sub    $0x4,%eax
  800637:	8b 00                	mov    (%eax),%eax
  800639:	99                   	cltd   
}
  80063a:	5d                   	pop    %ebp
  80063b:	c3                   	ret    

0080063c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80063c:	55                   	push   %ebp
  80063d:	89 e5                	mov    %esp,%ebp
  80063f:	56                   	push   %esi
  800640:	53                   	push   %ebx
  800641:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800644:	eb 17                	jmp    80065d <vprintfmt+0x21>
			if (ch == '\0')
  800646:	85 db                	test   %ebx,%ebx
  800648:	0f 84 c1 03 00 00    	je     800a0f <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80064e:	83 ec 08             	sub    $0x8,%esp
  800651:	ff 75 0c             	pushl  0xc(%ebp)
  800654:	53                   	push   %ebx
  800655:	8b 45 08             	mov    0x8(%ebp),%eax
  800658:	ff d0                	call   *%eax
  80065a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80065d:	8b 45 10             	mov    0x10(%ebp),%eax
  800660:	8d 50 01             	lea    0x1(%eax),%edx
  800663:	89 55 10             	mov    %edx,0x10(%ebp)
  800666:	8a 00                	mov    (%eax),%al
  800668:	0f b6 d8             	movzbl %al,%ebx
  80066b:	83 fb 25             	cmp    $0x25,%ebx
  80066e:	75 d6                	jne    800646 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800670:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800674:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80067b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800682:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800689:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800690:	8b 45 10             	mov    0x10(%ebp),%eax
  800693:	8d 50 01             	lea    0x1(%eax),%edx
  800696:	89 55 10             	mov    %edx,0x10(%ebp)
  800699:	8a 00                	mov    (%eax),%al
  80069b:	0f b6 d8             	movzbl %al,%ebx
  80069e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006a1:	83 f8 5b             	cmp    $0x5b,%eax
  8006a4:	0f 87 3d 03 00 00    	ja     8009e7 <vprintfmt+0x3ab>
  8006aa:	8b 04 85 18 20 80 00 	mov    0x802018(,%eax,4),%eax
  8006b1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006b3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006b7:	eb d7                	jmp    800690 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006b9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006bd:	eb d1                	jmp    800690 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c9:	89 d0                	mov    %edx,%eax
  8006cb:	c1 e0 02             	shl    $0x2,%eax
  8006ce:	01 d0                	add    %edx,%eax
  8006d0:	01 c0                	add    %eax,%eax
  8006d2:	01 d8                	add    %ebx,%eax
  8006d4:	83 e8 30             	sub    $0x30,%eax
  8006d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006da:	8b 45 10             	mov    0x10(%ebp),%eax
  8006dd:	8a 00                	mov    (%eax),%al
  8006df:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006e2:	83 fb 2f             	cmp    $0x2f,%ebx
  8006e5:	7e 3e                	jle    800725 <vprintfmt+0xe9>
  8006e7:	83 fb 39             	cmp    $0x39,%ebx
  8006ea:	7f 39                	jg     800725 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006ec:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006ef:	eb d5                	jmp    8006c6 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f4:	83 c0 04             	add    $0x4,%eax
  8006f7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fd:	83 e8 04             	sub    $0x4,%eax
  800700:	8b 00                	mov    (%eax),%eax
  800702:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800705:	eb 1f                	jmp    800726 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800707:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80070b:	79 83                	jns    800690 <vprintfmt+0x54>
				width = 0;
  80070d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800714:	e9 77 ff ff ff       	jmp    800690 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800719:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800720:	e9 6b ff ff ff       	jmp    800690 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800725:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800726:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80072a:	0f 89 60 ff ff ff    	jns    800690 <vprintfmt+0x54>
				width = precision, precision = -1;
  800730:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800733:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800736:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80073d:	e9 4e ff ff ff       	jmp    800690 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800742:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800745:	e9 46 ff ff ff       	jmp    800690 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80074a:	8b 45 14             	mov    0x14(%ebp),%eax
  80074d:	83 c0 04             	add    $0x4,%eax
  800750:	89 45 14             	mov    %eax,0x14(%ebp)
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	83 e8 04             	sub    $0x4,%eax
  800759:	8b 00                	mov    (%eax),%eax
  80075b:	83 ec 08             	sub    $0x8,%esp
  80075e:	ff 75 0c             	pushl  0xc(%ebp)
  800761:	50                   	push   %eax
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	ff d0                	call   *%eax
  800767:	83 c4 10             	add    $0x10,%esp
			break;
  80076a:	e9 9b 02 00 00       	jmp    800a0a <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80076f:	8b 45 14             	mov    0x14(%ebp),%eax
  800772:	83 c0 04             	add    $0x4,%eax
  800775:	89 45 14             	mov    %eax,0x14(%ebp)
  800778:	8b 45 14             	mov    0x14(%ebp),%eax
  80077b:	83 e8 04             	sub    $0x4,%eax
  80077e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800780:	85 db                	test   %ebx,%ebx
  800782:	79 02                	jns    800786 <vprintfmt+0x14a>
				err = -err;
  800784:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800786:	83 fb 64             	cmp    $0x64,%ebx
  800789:	7f 0b                	jg     800796 <vprintfmt+0x15a>
  80078b:	8b 34 9d 60 1e 80 00 	mov    0x801e60(,%ebx,4),%esi
  800792:	85 f6                	test   %esi,%esi
  800794:	75 19                	jne    8007af <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800796:	53                   	push   %ebx
  800797:	68 05 20 80 00       	push   $0x802005
  80079c:	ff 75 0c             	pushl  0xc(%ebp)
  80079f:	ff 75 08             	pushl  0x8(%ebp)
  8007a2:	e8 70 02 00 00       	call   800a17 <printfmt>
  8007a7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007aa:	e9 5b 02 00 00       	jmp    800a0a <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007af:	56                   	push   %esi
  8007b0:	68 0e 20 80 00       	push   $0x80200e
  8007b5:	ff 75 0c             	pushl  0xc(%ebp)
  8007b8:	ff 75 08             	pushl  0x8(%ebp)
  8007bb:	e8 57 02 00 00       	call   800a17 <printfmt>
  8007c0:	83 c4 10             	add    $0x10,%esp
			break;
  8007c3:	e9 42 02 00 00       	jmp    800a0a <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cb:	83 c0 04             	add    $0x4,%eax
  8007ce:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d4:	83 e8 04             	sub    $0x4,%eax
  8007d7:	8b 30                	mov    (%eax),%esi
  8007d9:	85 f6                	test   %esi,%esi
  8007db:	75 05                	jne    8007e2 <vprintfmt+0x1a6>
				p = "(null)";
  8007dd:	be 11 20 80 00       	mov    $0x802011,%esi
			if (width > 0 && padc != '-')
  8007e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e6:	7e 6d                	jle    800855 <vprintfmt+0x219>
  8007e8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007ec:	74 67                	je     800855 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	50                   	push   %eax
  8007f5:	56                   	push   %esi
  8007f6:	e8 1e 03 00 00       	call   800b19 <strnlen>
  8007fb:	83 c4 10             	add    $0x10,%esp
  8007fe:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800801:	eb 16                	jmp    800819 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800803:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800807:	83 ec 08             	sub    $0x8,%esp
  80080a:	ff 75 0c             	pushl  0xc(%ebp)
  80080d:	50                   	push   %eax
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	ff d0                	call   *%eax
  800813:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800816:	ff 4d e4             	decl   -0x1c(%ebp)
  800819:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80081d:	7f e4                	jg     800803 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80081f:	eb 34                	jmp    800855 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800821:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800825:	74 1c                	je     800843 <vprintfmt+0x207>
  800827:	83 fb 1f             	cmp    $0x1f,%ebx
  80082a:	7e 05                	jle    800831 <vprintfmt+0x1f5>
  80082c:	83 fb 7e             	cmp    $0x7e,%ebx
  80082f:	7e 12                	jle    800843 <vprintfmt+0x207>
					putch('?', putdat);
  800831:	83 ec 08             	sub    $0x8,%esp
  800834:	ff 75 0c             	pushl  0xc(%ebp)
  800837:	6a 3f                	push   $0x3f
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	ff d0                	call   *%eax
  80083e:	83 c4 10             	add    $0x10,%esp
  800841:	eb 0f                	jmp    800852 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800843:	83 ec 08             	sub    $0x8,%esp
  800846:	ff 75 0c             	pushl  0xc(%ebp)
  800849:	53                   	push   %ebx
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	ff d0                	call   *%eax
  80084f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800852:	ff 4d e4             	decl   -0x1c(%ebp)
  800855:	89 f0                	mov    %esi,%eax
  800857:	8d 70 01             	lea    0x1(%eax),%esi
  80085a:	8a 00                	mov    (%eax),%al
  80085c:	0f be d8             	movsbl %al,%ebx
  80085f:	85 db                	test   %ebx,%ebx
  800861:	74 24                	je     800887 <vprintfmt+0x24b>
  800863:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800867:	78 b8                	js     800821 <vprintfmt+0x1e5>
  800869:	ff 4d e0             	decl   -0x20(%ebp)
  80086c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800870:	79 af                	jns    800821 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800872:	eb 13                	jmp    800887 <vprintfmt+0x24b>
				putch(' ', putdat);
  800874:	83 ec 08             	sub    $0x8,%esp
  800877:	ff 75 0c             	pushl  0xc(%ebp)
  80087a:	6a 20                	push   $0x20
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	ff d0                	call   *%eax
  800881:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800884:	ff 4d e4             	decl   -0x1c(%ebp)
  800887:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80088b:	7f e7                	jg     800874 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80088d:	e9 78 01 00 00       	jmp    800a0a <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800892:	83 ec 08             	sub    $0x8,%esp
  800895:	ff 75 e8             	pushl  -0x18(%ebp)
  800898:	8d 45 14             	lea    0x14(%ebp),%eax
  80089b:	50                   	push   %eax
  80089c:	e8 3c fd ff ff       	call   8005dd <getint>
  8008a1:	83 c4 10             	add    $0x10,%esp
  8008a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b0:	85 d2                	test   %edx,%edx
  8008b2:	79 23                	jns    8008d7 <vprintfmt+0x29b>
				putch('-', putdat);
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ba:	6a 2d                	push   $0x2d
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	ff d0                	call   *%eax
  8008c1:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008ca:	f7 d8                	neg    %eax
  8008cc:	83 d2 00             	adc    $0x0,%edx
  8008cf:	f7 da                	neg    %edx
  8008d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008d7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008de:	e9 bc 00 00 00       	jmp    80099f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008e3:	83 ec 08             	sub    $0x8,%esp
  8008e6:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e9:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ec:	50                   	push   %eax
  8008ed:	e8 84 fc ff ff       	call   800576 <getuint>
  8008f2:	83 c4 10             	add    $0x10,%esp
  8008f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008fb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800902:	e9 98 00 00 00       	jmp    80099f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	ff 75 0c             	pushl  0xc(%ebp)
  80090d:	6a 58                	push   $0x58
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	ff d0                	call   *%eax
  800914:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	ff 75 0c             	pushl  0xc(%ebp)
  80091d:	6a 58                	push   $0x58
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax
  800922:	ff d0                	call   *%eax
  800924:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800927:	83 ec 08             	sub    $0x8,%esp
  80092a:	ff 75 0c             	pushl  0xc(%ebp)
  80092d:	6a 58                	push   $0x58
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	ff d0                	call   *%eax
  800934:	83 c4 10             	add    $0x10,%esp
			break;
  800937:	e9 ce 00 00 00       	jmp    800a0a <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80093c:	83 ec 08             	sub    $0x8,%esp
  80093f:	ff 75 0c             	pushl  0xc(%ebp)
  800942:	6a 30                	push   $0x30
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	ff d0                	call   *%eax
  800949:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	ff 75 0c             	pushl  0xc(%ebp)
  800952:	6a 78                	push   $0x78
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	ff d0                	call   *%eax
  800959:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80095c:	8b 45 14             	mov    0x14(%ebp),%eax
  80095f:	83 c0 04             	add    $0x4,%eax
  800962:	89 45 14             	mov    %eax,0x14(%ebp)
  800965:	8b 45 14             	mov    0x14(%ebp),%eax
  800968:	83 e8 04             	sub    $0x4,%eax
  80096b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80096d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800970:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800977:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80097e:	eb 1f                	jmp    80099f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800980:	83 ec 08             	sub    $0x8,%esp
  800983:	ff 75 e8             	pushl  -0x18(%ebp)
  800986:	8d 45 14             	lea    0x14(%ebp),%eax
  800989:	50                   	push   %eax
  80098a:	e8 e7 fb ff ff       	call   800576 <getuint>
  80098f:	83 c4 10             	add    $0x10,%esp
  800992:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800995:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800998:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80099f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009a6:	83 ec 04             	sub    $0x4,%esp
  8009a9:	52                   	push   %edx
  8009aa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009ad:	50                   	push   %eax
  8009ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b1:	ff 75 f0             	pushl  -0x10(%ebp)
  8009b4:	ff 75 0c             	pushl  0xc(%ebp)
  8009b7:	ff 75 08             	pushl  0x8(%ebp)
  8009ba:	e8 00 fb ff ff       	call   8004bf <printnum>
  8009bf:	83 c4 20             	add    $0x20,%esp
			break;
  8009c2:	eb 46                	jmp    800a0a <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ca:	53                   	push   %ebx
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	ff d0                	call   *%eax
  8009d0:	83 c4 10             	add    $0x10,%esp
			break;
  8009d3:	eb 35                	jmp    800a0a <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009d5:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8009dc:	eb 2c                	jmp    800a0a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009de:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8009e5:	eb 23                	jmp    800a0a <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009e7:	83 ec 08             	sub    $0x8,%esp
  8009ea:	ff 75 0c             	pushl  0xc(%ebp)
  8009ed:	6a 25                	push   $0x25
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	ff d0                	call   *%eax
  8009f4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009f7:	ff 4d 10             	decl   0x10(%ebp)
  8009fa:	eb 03                	jmp    8009ff <vprintfmt+0x3c3>
  8009fc:	ff 4d 10             	decl   0x10(%ebp)
  8009ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800a02:	48                   	dec    %eax
  800a03:	8a 00                	mov    (%eax),%al
  800a05:	3c 25                	cmp    $0x25,%al
  800a07:	75 f3                	jne    8009fc <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a09:	90                   	nop
		}
	}
  800a0a:	e9 35 fc ff ff       	jmp    800644 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a0f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a10:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a13:	5b                   	pop    %ebx
  800a14:	5e                   	pop    %esi
  800a15:	5d                   	pop    %ebp
  800a16:	c3                   	ret    

00800a17 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
  800a1a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a1d:	8d 45 10             	lea    0x10(%ebp),%eax
  800a20:	83 c0 04             	add    $0x4,%eax
  800a23:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a26:	8b 45 10             	mov    0x10(%ebp),%eax
  800a29:	ff 75 f4             	pushl  -0xc(%ebp)
  800a2c:	50                   	push   %eax
  800a2d:	ff 75 0c             	pushl  0xc(%ebp)
  800a30:	ff 75 08             	pushl  0x8(%ebp)
  800a33:	e8 04 fc ff ff       	call   80063c <vprintfmt>
  800a38:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a3b:	90                   	nop
  800a3c:	c9                   	leave  
  800a3d:	c3                   	ret    

00800a3e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a3e:	55                   	push   %ebp
  800a3f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a44:	8b 40 08             	mov    0x8(%eax),%eax
  800a47:	8d 50 01             	lea    0x1(%eax),%edx
  800a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a53:	8b 10                	mov    (%eax),%edx
  800a55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a58:	8b 40 04             	mov    0x4(%eax),%eax
  800a5b:	39 c2                	cmp    %eax,%edx
  800a5d:	73 12                	jae    800a71 <sprintputch+0x33>
		*b->buf++ = ch;
  800a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a62:	8b 00                	mov    (%eax),%eax
  800a64:	8d 48 01             	lea    0x1(%eax),%ecx
  800a67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6a:	89 0a                	mov    %ecx,(%edx)
  800a6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a6f:	88 10                	mov    %dl,(%eax)
}
  800a71:	90                   	nop
  800a72:	5d                   	pop    %ebp
  800a73:	c3                   	ret    

00800a74 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a83:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	01 d0                	add    %edx,%eax
  800a8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a99:	74 06                	je     800aa1 <vsnprintf+0x2d>
  800a9b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a9f:	7f 07                	jg     800aa8 <vsnprintf+0x34>
		return -E_INVAL;
  800aa1:	b8 03 00 00 00       	mov    $0x3,%eax
  800aa6:	eb 20                	jmp    800ac8 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800aa8:	ff 75 14             	pushl  0x14(%ebp)
  800aab:	ff 75 10             	pushl  0x10(%ebp)
  800aae:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ab1:	50                   	push   %eax
  800ab2:	68 3e 0a 80 00       	push   $0x800a3e
  800ab7:	e8 80 fb ff ff       	call   80063c <vprintfmt>
  800abc:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800abf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ac8:	c9                   	leave  
  800ac9:	c3                   	ret    

00800aca <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
  800acd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ad0:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad3:	83 c0 04             	add    $0x4,%eax
  800ad6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ad9:	8b 45 10             	mov    0x10(%ebp),%eax
  800adc:	ff 75 f4             	pushl  -0xc(%ebp)
  800adf:	50                   	push   %eax
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	ff 75 08             	pushl  0x8(%ebp)
  800ae6:	e8 89 ff ff ff       	call   800a74 <vsnprintf>
  800aeb:	83 c4 10             	add    $0x10,%esp
  800aee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800af1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800af4:	c9                   	leave  
  800af5:	c3                   	ret    

00800af6 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800afc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b03:	eb 06                	jmp    800b0b <strlen+0x15>
		n++;
  800b05:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b08:	ff 45 08             	incl   0x8(%ebp)
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	8a 00                	mov    (%eax),%al
  800b10:	84 c0                	test   %al,%al
  800b12:	75 f1                	jne    800b05 <strlen+0xf>
		n++;
	return n;
  800b14:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b17:	c9                   	leave  
  800b18:	c3                   	ret    

00800b19 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b19:	55                   	push   %ebp
  800b1a:	89 e5                	mov    %esp,%ebp
  800b1c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b1f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b26:	eb 09                	jmp    800b31 <strnlen+0x18>
		n++;
  800b28:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b2b:	ff 45 08             	incl   0x8(%ebp)
  800b2e:	ff 4d 0c             	decl   0xc(%ebp)
  800b31:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b35:	74 09                	je     800b40 <strnlen+0x27>
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	8a 00                	mov    (%eax),%al
  800b3c:	84 c0                	test   %al,%al
  800b3e:	75 e8                	jne    800b28 <strnlen+0xf>
		n++;
	return n;
  800b40:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b43:	c9                   	leave  
  800b44:	c3                   	ret    

00800b45 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b51:	90                   	nop
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	8d 50 01             	lea    0x1(%eax),%edx
  800b58:	89 55 08             	mov    %edx,0x8(%ebp)
  800b5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b61:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b64:	8a 12                	mov    (%edx),%dl
  800b66:	88 10                	mov    %dl,(%eax)
  800b68:	8a 00                	mov    (%eax),%al
  800b6a:	84 c0                	test   %al,%al
  800b6c:	75 e4                	jne    800b52 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b71:	c9                   	leave  
  800b72:	c3                   	ret    

00800b73 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b73:	55                   	push   %ebp
  800b74:	89 e5                	mov    %esp,%ebp
  800b76:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b86:	eb 1f                	jmp    800ba7 <strncpy+0x34>
		*dst++ = *src;
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	8d 50 01             	lea    0x1(%eax),%edx
  800b8e:	89 55 08             	mov    %edx,0x8(%ebp)
  800b91:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b94:	8a 12                	mov    (%edx),%dl
  800b96:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9b:	8a 00                	mov    (%eax),%al
  800b9d:	84 c0                	test   %al,%al
  800b9f:	74 03                	je     800ba4 <strncpy+0x31>
			src++;
  800ba1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ba4:	ff 45 fc             	incl   -0x4(%ebp)
  800ba7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800baa:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bad:	72 d9                	jb     800b88 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800baf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bb2:	c9                   	leave  
  800bb3:	c3                   	ret    

00800bb4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bc0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bc4:	74 30                	je     800bf6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bc6:	eb 16                	jmp    800bde <strlcpy+0x2a>
			*dst++ = *src++;
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	8d 50 01             	lea    0x1(%eax),%edx
  800bce:	89 55 08             	mov    %edx,0x8(%ebp)
  800bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bd7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bda:	8a 12                	mov    (%edx),%dl
  800bdc:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bde:	ff 4d 10             	decl   0x10(%ebp)
  800be1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800be5:	74 09                	je     800bf0 <strlcpy+0x3c>
  800be7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bea:	8a 00                	mov    (%eax),%al
  800bec:	84 c0                	test   %al,%al
  800bee:	75 d8                	jne    800bc8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bf6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bfc:	29 c2                	sub    %eax,%edx
  800bfe:	89 d0                	mov    %edx,%eax
}
  800c00:	c9                   	leave  
  800c01:	c3                   	ret    

00800c02 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c02:	55                   	push   %ebp
  800c03:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c05:	eb 06                	jmp    800c0d <strcmp+0xb>
		p++, q++;
  800c07:	ff 45 08             	incl   0x8(%ebp)
  800c0a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	8a 00                	mov    (%eax),%al
  800c12:	84 c0                	test   %al,%al
  800c14:	74 0e                	je     800c24 <strcmp+0x22>
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	8a 10                	mov    (%eax),%dl
  800c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1e:	8a 00                	mov    (%eax),%al
  800c20:	38 c2                	cmp    %al,%dl
  800c22:	74 e3                	je     800c07 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	8a 00                	mov    (%eax),%al
  800c29:	0f b6 d0             	movzbl %al,%edx
  800c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2f:	8a 00                	mov    (%eax),%al
  800c31:	0f b6 c0             	movzbl %al,%eax
  800c34:	29 c2                	sub    %eax,%edx
  800c36:	89 d0                	mov    %edx,%eax
}
  800c38:	5d                   	pop    %ebp
  800c39:	c3                   	ret    

00800c3a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c3d:	eb 09                	jmp    800c48 <strncmp+0xe>
		n--, p++, q++;
  800c3f:	ff 4d 10             	decl   0x10(%ebp)
  800c42:	ff 45 08             	incl   0x8(%ebp)
  800c45:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c4c:	74 17                	je     800c65 <strncmp+0x2b>
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	8a 00                	mov    (%eax),%al
  800c53:	84 c0                	test   %al,%al
  800c55:	74 0e                	je     800c65 <strncmp+0x2b>
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	8a 10                	mov    (%eax),%dl
  800c5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5f:	8a 00                	mov    (%eax),%al
  800c61:	38 c2                	cmp    %al,%dl
  800c63:	74 da                	je     800c3f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c65:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c69:	75 07                	jne    800c72 <strncmp+0x38>
		return 0;
  800c6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c70:	eb 14                	jmp    800c86 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	8a 00                	mov    (%eax),%al
  800c77:	0f b6 d0             	movzbl %al,%edx
  800c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7d:	8a 00                	mov    (%eax),%al
  800c7f:	0f b6 c0             	movzbl %al,%eax
  800c82:	29 c2                	sub    %eax,%edx
  800c84:	89 d0                	mov    %edx,%eax
}
  800c86:	5d                   	pop    %ebp
  800c87:	c3                   	ret    

00800c88 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	83 ec 04             	sub    $0x4,%esp
  800c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c91:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c94:	eb 12                	jmp    800ca8 <strchr+0x20>
		if (*s == c)
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8a 00                	mov    (%eax),%al
  800c9b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c9e:	75 05                	jne    800ca5 <strchr+0x1d>
			return (char *) s;
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	eb 11                	jmp    800cb6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ca5:	ff 45 08             	incl   0x8(%ebp)
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8a 00                	mov    (%eax),%al
  800cad:	84 c0                	test   %al,%al
  800caf:	75 e5                	jne    800c96 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb6:	c9                   	leave  
  800cb7:	c3                   	ret    

00800cb8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	83 ec 04             	sub    $0x4,%esp
  800cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cc4:	eb 0d                	jmp    800cd3 <strfind+0x1b>
		if (*s == c)
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	8a 00                	mov    (%eax),%al
  800ccb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cce:	74 0e                	je     800cde <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cd0:	ff 45 08             	incl   0x8(%ebp)
  800cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd6:	8a 00                	mov    (%eax),%al
  800cd8:	84 c0                	test   %al,%al
  800cda:	75 ea                	jne    800cc6 <strfind+0xe>
  800cdc:	eb 01                	jmp    800cdf <strfind+0x27>
		if (*s == c)
			break;
  800cde:	90                   	nop
	return (char *) s;
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ce2:	c9                   	leave  
  800ce3:	c3                   	ret    

00800ce4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cf0:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cf6:	eb 0e                	jmp    800d06 <memset+0x22>
		*p++ = c;
  800cf8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cfb:	8d 50 01             	lea    0x1(%eax),%edx
  800cfe:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d04:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d06:	ff 4d f8             	decl   -0x8(%ebp)
  800d09:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d0d:	79 e9                	jns    800cf8 <memset+0x14>
		*p++ = c;

	return v;
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d12:	c9                   	leave  
  800d13:	c3                   	ret    

00800d14 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d26:	eb 16                	jmp    800d3e <memcpy+0x2a>
		*d++ = *s++;
  800d28:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d2b:	8d 50 01             	lea    0x1(%eax),%edx
  800d2e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d31:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d34:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d37:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d3a:	8a 12                	mov    (%edx),%dl
  800d3c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d41:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d44:	89 55 10             	mov    %edx,0x10(%ebp)
  800d47:	85 c0                	test   %eax,%eax
  800d49:	75 dd                	jne    800d28 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d4e:	c9                   	leave  
  800d4f:	c3                   	ret    

00800d50 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d65:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d68:	73 50                	jae    800dba <memmove+0x6a>
  800d6a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d70:	01 d0                	add    %edx,%eax
  800d72:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d75:	76 43                	jbe    800dba <memmove+0x6a>
		s += n;
  800d77:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d80:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d83:	eb 10                	jmp    800d95 <memmove+0x45>
			*--d = *--s;
  800d85:	ff 4d f8             	decl   -0x8(%ebp)
  800d88:	ff 4d fc             	decl   -0x4(%ebp)
  800d8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d8e:	8a 10                	mov    (%eax),%dl
  800d90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d93:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d95:	8b 45 10             	mov    0x10(%ebp),%eax
  800d98:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9b:	89 55 10             	mov    %edx,0x10(%ebp)
  800d9e:	85 c0                	test   %eax,%eax
  800da0:	75 e3                	jne    800d85 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800da2:	eb 23                	jmp    800dc7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800da4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da7:	8d 50 01             	lea    0x1(%eax),%edx
  800daa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800db0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800db6:	8a 12                	mov    (%edx),%dl
  800db8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dba:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc0:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc3:	85 c0                	test   %eax,%eax
  800dc5:	75 dd                	jne    800da4 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dca:	c9                   	leave  
  800dcb:	c3                   	ret    

00800dcc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddb:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dde:	eb 2a                	jmp    800e0a <memcmp+0x3e>
		if (*s1 != *s2)
  800de0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de3:	8a 10                	mov    (%eax),%dl
  800de5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de8:	8a 00                	mov    (%eax),%al
  800dea:	38 c2                	cmp    %al,%dl
  800dec:	74 16                	je     800e04 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df1:	8a 00                	mov    (%eax),%al
  800df3:	0f b6 d0             	movzbl %al,%edx
  800df6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df9:	8a 00                	mov    (%eax),%al
  800dfb:	0f b6 c0             	movzbl %al,%eax
  800dfe:	29 c2                	sub    %eax,%edx
  800e00:	89 d0                	mov    %edx,%eax
  800e02:	eb 18                	jmp    800e1c <memcmp+0x50>
		s1++, s2++;
  800e04:	ff 45 fc             	incl   -0x4(%ebp)
  800e07:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e10:	89 55 10             	mov    %edx,0x10(%ebp)
  800e13:	85 c0                	test   %eax,%eax
  800e15:	75 c9                	jne    800de0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e1c:	c9                   	leave  
  800e1d:	c3                   	ret    

00800e1e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e24:	8b 55 08             	mov    0x8(%ebp),%edx
  800e27:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2a:	01 d0                	add    %edx,%eax
  800e2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e2f:	eb 15                	jmp    800e46 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	0f b6 d0             	movzbl %al,%edx
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	0f b6 c0             	movzbl %al,%eax
  800e3f:	39 c2                	cmp    %eax,%edx
  800e41:	74 0d                	je     800e50 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e43:	ff 45 08             	incl   0x8(%ebp)
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e4c:	72 e3                	jb     800e31 <memfind+0x13>
  800e4e:	eb 01                	jmp    800e51 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e50:	90                   	nop
	return (void *) s;
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e54:	c9                   	leave  
  800e55:	c3                   	ret    

00800e56 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e63:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e6a:	eb 03                	jmp    800e6f <strtol+0x19>
		s++;
  800e6c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	8a 00                	mov    (%eax),%al
  800e74:	3c 20                	cmp    $0x20,%al
  800e76:	74 f4                	je     800e6c <strtol+0x16>
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	3c 09                	cmp    $0x9,%al
  800e7f:	74 eb                	je     800e6c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	3c 2b                	cmp    $0x2b,%al
  800e88:	75 05                	jne    800e8f <strtol+0x39>
		s++;
  800e8a:	ff 45 08             	incl   0x8(%ebp)
  800e8d:	eb 13                	jmp    800ea2 <strtol+0x4c>
	else if (*s == '-')
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	8a 00                	mov    (%eax),%al
  800e94:	3c 2d                	cmp    $0x2d,%al
  800e96:	75 0a                	jne    800ea2 <strtol+0x4c>
		s++, neg = 1;
  800e98:	ff 45 08             	incl   0x8(%ebp)
  800e9b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ea2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea6:	74 06                	je     800eae <strtol+0x58>
  800ea8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800eac:	75 20                	jne    800ece <strtol+0x78>
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	3c 30                	cmp    $0x30,%al
  800eb5:	75 17                	jne    800ece <strtol+0x78>
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	40                   	inc    %eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	3c 78                	cmp    $0x78,%al
  800ebf:	75 0d                	jne    800ece <strtol+0x78>
		s += 2, base = 16;
  800ec1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ec5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ecc:	eb 28                	jmp    800ef6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ece:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed2:	75 15                	jne    800ee9 <strtol+0x93>
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed7:	8a 00                	mov    (%eax),%al
  800ed9:	3c 30                	cmp    $0x30,%al
  800edb:	75 0c                	jne    800ee9 <strtol+0x93>
		s++, base = 8;
  800edd:	ff 45 08             	incl   0x8(%ebp)
  800ee0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ee7:	eb 0d                	jmp    800ef6 <strtol+0xa0>
	else if (base == 0)
  800ee9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eed:	75 07                	jne    800ef6 <strtol+0xa0>
		base = 10;
  800eef:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	3c 2f                	cmp    $0x2f,%al
  800efd:	7e 19                	jle    800f18 <strtol+0xc2>
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	3c 39                	cmp    $0x39,%al
  800f06:	7f 10                	jg     800f18 <strtol+0xc2>
			dig = *s - '0';
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	0f be c0             	movsbl %al,%eax
  800f10:	83 e8 30             	sub    $0x30,%eax
  800f13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f16:	eb 42                	jmp    800f5a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	8a 00                	mov    (%eax),%al
  800f1d:	3c 60                	cmp    $0x60,%al
  800f1f:	7e 19                	jle    800f3a <strtol+0xe4>
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	3c 7a                	cmp    $0x7a,%al
  800f28:	7f 10                	jg     800f3a <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	0f be c0             	movsbl %al,%eax
  800f32:	83 e8 57             	sub    $0x57,%eax
  800f35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f38:	eb 20                	jmp    800f5a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	3c 40                	cmp    $0x40,%al
  800f41:	7e 39                	jle    800f7c <strtol+0x126>
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	3c 5a                	cmp    $0x5a,%al
  800f4a:	7f 30                	jg     800f7c <strtol+0x126>
			dig = *s - 'A' + 10;
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	8a 00                	mov    (%eax),%al
  800f51:	0f be c0             	movsbl %al,%eax
  800f54:	83 e8 37             	sub    $0x37,%eax
  800f57:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f5d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f60:	7d 19                	jge    800f7b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f62:	ff 45 08             	incl   0x8(%ebp)
  800f65:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f68:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f6c:	89 c2                	mov    %eax,%edx
  800f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f71:	01 d0                	add    %edx,%eax
  800f73:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f76:	e9 7b ff ff ff       	jmp    800ef6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f7b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f80:	74 08                	je     800f8a <strtol+0x134>
		*endptr = (char *) s;
  800f82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f85:	8b 55 08             	mov    0x8(%ebp),%edx
  800f88:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f8e:	74 07                	je     800f97 <strtol+0x141>
  800f90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f93:	f7 d8                	neg    %eax
  800f95:	eb 03                	jmp    800f9a <strtol+0x144>
  800f97:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <ltostr>:

void
ltostr(long value, char *str)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fa2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fa9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fb0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fb4:	79 13                	jns    800fc9 <ltostr+0x2d>
	{
		neg = 1;
  800fb6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fc3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fc6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fd1:	99                   	cltd   
  800fd2:	f7 f9                	idiv   %ecx
  800fd4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fda:	8d 50 01             	lea    0x1(%eax),%edx
  800fdd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe0:	89 c2                	mov    %eax,%edx
  800fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe5:	01 d0                	add    %edx,%eax
  800fe7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fea:	83 c2 30             	add    $0x30,%edx
  800fed:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ff7:	f7 e9                	imul   %ecx
  800ff9:	c1 fa 02             	sar    $0x2,%edx
  800ffc:	89 c8                	mov    %ecx,%eax
  800ffe:	c1 f8 1f             	sar    $0x1f,%eax
  801001:	29 c2                	sub    %eax,%edx
  801003:	89 d0                	mov    %edx,%eax
  801005:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801008:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80100c:	75 bb                	jne    800fc9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80100e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801015:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801018:	48                   	dec    %eax
  801019:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80101c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801020:	74 3d                	je     80105f <ltostr+0xc3>
		start = 1 ;
  801022:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801029:	eb 34                	jmp    80105f <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80102b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80102e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801031:	01 d0                	add    %edx,%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801038:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103e:	01 c2                	add    %eax,%edx
  801040:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801043:	8b 45 0c             	mov    0xc(%ebp),%eax
  801046:	01 c8                	add    %ecx,%eax
  801048:	8a 00                	mov    (%eax),%al
  80104a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80104c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80104f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801052:	01 c2                	add    %eax,%edx
  801054:	8a 45 eb             	mov    -0x15(%ebp),%al
  801057:	88 02                	mov    %al,(%edx)
		start++ ;
  801059:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80105c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80105f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801062:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801065:	7c c4                	jl     80102b <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801067:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80106a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106d:	01 d0                	add    %edx,%eax
  80106f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801072:	90                   	nop
  801073:	c9                   	leave  
  801074:	c3                   	ret    

00801075 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801075:	55                   	push   %ebp
  801076:	89 e5                	mov    %esp,%ebp
  801078:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80107b:	ff 75 08             	pushl  0x8(%ebp)
  80107e:	e8 73 fa ff ff       	call   800af6 <strlen>
  801083:	83 c4 04             	add    $0x4,%esp
  801086:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801089:	ff 75 0c             	pushl  0xc(%ebp)
  80108c:	e8 65 fa ff ff       	call   800af6 <strlen>
  801091:	83 c4 04             	add    $0x4,%esp
  801094:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801097:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80109e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010a5:	eb 17                	jmp    8010be <strcconcat+0x49>
		final[s] = str1[s] ;
  8010a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ad:	01 c2                	add    %eax,%edx
  8010af:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	01 c8                	add    %ecx,%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010bb:	ff 45 fc             	incl   -0x4(%ebp)
  8010be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010c4:	7c e1                	jl     8010a7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010d4:	eb 1f                	jmp    8010f5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d9:	8d 50 01             	lea    0x1(%eax),%edx
  8010dc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010df:	89 c2                	mov    %eax,%edx
  8010e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e4:	01 c2                	add    %eax,%edx
  8010e6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ec:	01 c8                	add    %ecx,%eax
  8010ee:	8a 00                	mov    (%eax),%al
  8010f0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010f2:	ff 45 f8             	incl   -0x8(%ebp)
  8010f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010fb:	7c d9                	jl     8010d6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801100:	8b 45 10             	mov    0x10(%ebp),%eax
  801103:	01 d0                	add    %edx,%eax
  801105:	c6 00 00             	movb   $0x0,(%eax)
}
  801108:	90                   	nop
  801109:	c9                   	leave  
  80110a:	c3                   	ret    

0080110b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80110e:	8b 45 14             	mov    0x14(%ebp),%eax
  801111:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801117:	8b 45 14             	mov    0x14(%ebp),%eax
  80111a:	8b 00                	mov    (%eax),%eax
  80111c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801123:	8b 45 10             	mov    0x10(%ebp),%eax
  801126:	01 d0                	add    %edx,%eax
  801128:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80112e:	eb 0c                	jmp    80113c <strsplit+0x31>
			*string++ = 0;
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	8d 50 01             	lea    0x1(%eax),%edx
  801136:	89 55 08             	mov    %edx,0x8(%ebp)
  801139:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	84 c0                	test   %al,%al
  801143:	74 18                	je     80115d <strsplit+0x52>
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	0f be c0             	movsbl %al,%eax
  80114d:	50                   	push   %eax
  80114e:	ff 75 0c             	pushl  0xc(%ebp)
  801151:	e8 32 fb ff ff       	call   800c88 <strchr>
  801156:	83 c4 08             	add    $0x8,%esp
  801159:	85 c0                	test   %eax,%eax
  80115b:	75 d3                	jne    801130 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	84 c0                	test   %al,%al
  801164:	74 5a                	je     8011c0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801166:	8b 45 14             	mov    0x14(%ebp),%eax
  801169:	8b 00                	mov    (%eax),%eax
  80116b:	83 f8 0f             	cmp    $0xf,%eax
  80116e:	75 07                	jne    801177 <strsplit+0x6c>
		{
			return 0;
  801170:	b8 00 00 00 00       	mov    $0x0,%eax
  801175:	eb 66                	jmp    8011dd <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801177:	8b 45 14             	mov    0x14(%ebp),%eax
  80117a:	8b 00                	mov    (%eax),%eax
  80117c:	8d 48 01             	lea    0x1(%eax),%ecx
  80117f:	8b 55 14             	mov    0x14(%ebp),%edx
  801182:	89 0a                	mov    %ecx,(%edx)
  801184:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80118b:	8b 45 10             	mov    0x10(%ebp),%eax
  80118e:	01 c2                	add    %eax,%edx
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801195:	eb 03                	jmp    80119a <strsplit+0x8f>
			string++;
  801197:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	8a 00                	mov    (%eax),%al
  80119f:	84 c0                	test   %al,%al
  8011a1:	74 8b                	je     80112e <strsplit+0x23>
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	8a 00                	mov    (%eax),%al
  8011a8:	0f be c0             	movsbl %al,%eax
  8011ab:	50                   	push   %eax
  8011ac:	ff 75 0c             	pushl  0xc(%ebp)
  8011af:	e8 d4 fa ff ff       	call   800c88 <strchr>
  8011b4:	83 c4 08             	add    $0x8,%esp
  8011b7:	85 c0                	test   %eax,%eax
  8011b9:	74 dc                	je     801197 <strsplit+0x8c>
			string++;
	}
  8011bb:	e9 6e ff ff ff       	jmp    80112e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011c0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c4:	8b 00                	mov    (%eax),%eax
  8011c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d0:	01 d0                	add    %edx,%eax
  8011d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011d8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011dd:	c9                   	leave  
  8011de:	c3                   	ret    

008011df <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011df:	55                   	push   %ebp
  8011e0:	89 e5                	mov    %esp,%ebp
  8011e2:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8011e5:	83 ec 04             	sub    $0x4,%esp
  8011e8:	68 88 21 80 00       	push   $0x802188
  8011ed:	68 3f 01 00 00       	push   $0x13f
  8011f2:	68 aa 21 80 00       	push   $0x8021aa
  8011f7:	e8 a9 ef ff ff       	call   8001a5 <_panic>

008011fc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	57                   	push   %edi
  801200:	56                   	push   %esi
  801201:	53                   	push   %ebx
  801202:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	8b 55 0c             	mov    0xc(%ebp),%edx
  80120b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80120e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801211:	8b 7d 18             	mov    0x18(%ebp),%edi
  801214:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801217:	cd 30                	int    $0x30
  801219:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80121c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80121f:	83 c4 10             	add    $0x10,%esp
  801222:	5b                   	pop    %ebx
  801223:	5e                   	pop    %esi
  801224:	5f                   	pop    %edi
  801225:	5d                   	pop    %ebp
  801226:	c3                   	ret    

00801227 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801227:	55                   	push   %ebp
  801228:	89 e5                	mov    %esp,%ebp
  80122a:	83 ec 04             	sub    $0x4,%esp
  80122d:	8b 45 10             	mov    0x10(%ebp),%eax
  801230:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801233:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	6a 00                	push   $0x0
  80123c:	6a 00                	push   $0x0
  80123e:	52                   	push   %edx
  80123f:	ff 75 0c             	pushl  0xc(%ebp)
  801242:	50                   	push   %eax
  801243:	6a 00                	push   $0x0
  801245:	e8 b2 ff ff ff       	call   8011fc <syscall>
  80124a:	83 c4 18             	add    $0x18,%esp
}
  80124d:	90                   	nop
  80124e:	c9                   	leave  
  80124f:	c3                   	ret    

00801250 <sys_cgetc>:

int
sys_cgetc(void)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801253:	6a 00                	push   $0x0
  801255:	6a 00                	push   $0x0
  801257:	6a 00                	push   $0x0
  801259:	6a 00                	push   $0x0
  80125b:	6a 00                	push   $0x0
  80125d:	6a 02                	push   $0x2
  80125f:	e8 98 ff ff ff       	call   8011fc <syscall>
  801264:	83 c4 18             	add    $0x18,%esp
}
  801267:	c9                   	leave  
  801268:	c3                   	ret    

00801269 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801269:	55                   	push   %ebp
  80126a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80126c:	6a 00                	push   $0x0
  80126e:	6a 00                	push   $0x0
  801270:	6a 00                	push   $0x0
  801272:	6a 00                	push   $0x0
  801274:	6a 00                	push   $0x0
  801276:	6a 03                	push   $0x3
  801278:	e8 7f ff ff ff       	call   8011fc <syscall>
  80127d:	83 c4 18             	add    $0x18,%esp
}
  801280:	90                   	nop
  801281:	c9                   	leave  
  801282:	c3                   	ret    

00801283 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801286:	6a 00                	push   $0x0
  801288:	6a 00                	push   $0x0
  80128a:	6a 00                	push   $0x0
  80128c:	6a 00                	push   $0x0
  80128e:	6a 00                	push   $0x0
  801290:	6a 04                	push   $0x4
  801292:	e8 65 ff ff ff       	call   8011fc <syscall>
  801297:	83 c4 18             	add    $0x18,%esp
}
  80129a:	90                   	nop
  80129b:	c9                   	leave  
  80129c:	c3                   	ret    

0080129d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80129d:	55                   	push   %ebp
  80129e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	6a 00                	push   $0x0
  8012a8:	6a 00                	push   $0x0
  8012aa:	6a 00                	push   $0x0
  8012ac:	52                   	push   %edx
  8012ad:	50                   	push   %eax
  8012ae:	6a 08                	push   $0x8
  8012b0:	e8 47 ff ff ff       	call   8011fc <syscall>
  8012b5:	83 c4 18             	add    $0x18,%esp
}
  8012b8:	c9                   	leave  
  8012b9:	c3                   	ret    

008012ba <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012ba:	55                   	push   %ebp
  8012bb:	89 e5                	mov    %esp,%ebp
  8012bd:	56                   	push   %esi
  8012be:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012bf:	8b 75 18             	mov    0x18(%ebp),%esi
  8012c2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	56                   	push   %esi
  8012cf:	53                   	push   %ebx
  8012d0:	51                   	push   %ecx
  8012d1:	52                   	push   %edx
  8012d2:	50                   	push   %eax
  8012d3:	6a 09                	push   $0x9
  8012d5:	e8 22 ff ff ff       	call   8011fc <syscall>
  8012da:	83 c4 18             	add    $0x18,%esp
}
  8012dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e0:	5b                   	pop    %ebx
  8012e1:	5e                   	pop    %esi
  8012e2:	5d                   	pop    %ebp
  8012e3:	c3                   	ret    

008012e4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	6a 00                	push   $0x0
  8012ef:	6a 00                	push   $0x0
  8012f1:	6a 00                	push   $0x0
  8012f3:	52                   	push   %edx
  8012f4:	50                   	push   %eax
  8012f5:	6a 0a                	push   $0xa
  8012f7:	e8 00 ff ff ff       	call   8011fc <syscall>
  8012fc:	83 c4 18             	add    $0x18,%esp
}
  8012ff:	c9                   	leave  
  801300:	c3                   	ret    

00801301 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801304:	6a 00                	push   $0x0
  801306:	6a 00                	push   $0x0
  801308:	6a 00                	push   $0x0
  80130a:	ff 75 0c             	pushl  0xc(%ebp)
  80130d:	ff 75 08             	pushl  0x8(%ebp)
  801310:	6a 0b                	push   $0xb
  801312:	e8 e5 fe ff ff       	call   8011fc <syscall>
  801317:	83 c4 18             	add    $0x18,%esp
}
  80131a:	c9                   	leave  
  80131b:	c3                   	ret    

0080131c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	6a 00                	push   $0x0
  801325:	6a 00                	push   $0x0
  801327:	6a 00                	push   $0x0
  801329:	6a 0c                	push   $0xc
  80132b:	e8 cc fe ff ff       	call   8011fc <syscall>
  801330:	83 c4 18             	add    $0x18,%esp
}
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801338:	6a 00                	push   $0x0
  80133a:	6a 00                	push   $0x0
  80133c:	6a 00                	push   $0x0
  80133e:	6a 00                	push   $0x0
  801340:	6a 00                	push   $0x0
  801342:	6a 0d                	push   $0xd
  801344:	e8 b3 fe ff ff       	call   8011fc <syscall>
  801349:	83 c4 18             	add    $0x18,%esp
}
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    

0080134e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801351:	6a 00                	push   $0x0
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	6a 00                	push   $0x0
  80135b:	6a 0e                	push   $0xe
  80135d:	e8 9a fe ff ff       	call   8011fc <syscall>
  801362:	83 c4 18             	add    $0x18,%esp
}
  801365:	c9                   	leave  
  801366:	c3                   	ret    

00801367 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80136a:	6a 00                	push   $0x0
  80136c:	6a 00                	push   $0x0
  80136e:	6a 00                	push   $0x0
  801370:	6a 00                	push   $0x0
  801372:	6a 00                	push   $0x0
  801374:	6a 0f                	push   $0xf
  801376:	e8 81 fe ff ff       	call   8011fc <syscall>
  80137b:	83 c4 18             	add    $0x18,%esp
}
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	ff 75 08             	pushl  0x8(%ebp)
  80138e:	6a 10                	push   $0x10
  801390:	e8 67 fe ff ff       	call   8011fc <syscall>
  801395:	83 c4 18             	add    $0x18,%esp
}
  801398:	c9                   	leave  
  801399:	c3                   	ret    

0080139a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80139d:	6a 00                	push   $0x0
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 11                	push   $0x11
  8013a9:	e8 4e fe ff ff       	call   8011fc <syscall>
  8013ae:	83 c4 18             	add    $0x18,%esp
}
  8013b1:	90                   	nop
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <sys_cputc>:

void
sys_cputc(const char c)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	83 ec 04             	sub    $0x4,%esp
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013c0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 00                	push   $0x0
  8013ca:	6a 00                	push   $0x0
  8013cc:	50                   	push   %eax
  8013cd:	6a 01                	push   $0x1
  8013cf:	e8 28 fe ff ff       	call   8011fc <syscall>
  8013d4:	83 c4 18             	add    $0x18,%esp
}
  8013d7:	90                   	nop
  8013d8:	c9                   	leave  
  8013d9:	c3                   	ret    

008013da <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 14                	push   $0x14
  8013e9:	e8 0e fe ff ff       	call   8011fc <syscall>
  8013ee:	83 c4 18             	add    $0x18,%esp
}
  8013f1:	90                   	nop
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    

008013f4 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	83 ec 04             	sub    $0x4,%esp
  8013fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801400:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801403:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801407:	8b 45 08             	mov    0x8(%ebp),%eax
  80140a:	6a 00                	push   $0x0
  80140c:	51                   	push   %ecx
  80140d:	52                   	push   %edx
  80140e:	ff 75 0c             	pushl  0xc(%ebp)
  801411:	50                   	push   %eax
  801412:	6a 15                	push   $0x15
  801414:	e8 e3 fd ff ff       	call   8011fc <syscall>
  801419:	83 c4 18             	add    $0x18,%esp
}
  80141c:	c9                   	leave  
  80141d:	c3                   	ret    

0080141e <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801421:	8b 55 0c             	mov    0xc(%ebp),%edx
  801424:	8b 45 08             	mov    0x8(%ebp),%eax
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	52                   	push   %edx
  80142e:	50                   	push   %eax
  80142f:	6a 16                	push   $0x16
  801431:	e8 c6 fd ff ff       	call   8011fc <syscall>
  801436:	83 c4 18             	add    $0x18,%esp
}
  801439:	c9                   	leave  
  80143a:	c3                   	ret    

0080143b <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80143b:	55                   	push   %ebp
  80143c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80143e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801441:	8b 55 0c             	mov    0xc(%ebp),%edx
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	6a 00                	push   $0x0
  801449:	6a 00                	push   $0x0
  80144b:	51                   	push   %ecx
  80144c:	52                   	push   %edx
  80144d:	50                   	push   %eax
  80144e:	6a 17                	push   $0x17
  801450:	e8 a7 fd ff ff       	call   8011fc <syscall>
  801455:	83 c4 18             	add    $0x18,%esp
}
  801458:	c9                   	leave  
  801459:	c3                   	ret    

0080145a <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80145d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801460:	8b 45 08             	mov    0x8(%ebp),%eax
  801463:	6a 00                	push   $0x0
  801465:	6a 00                	push   $0x0
  801467:	6a 00                	push   $0x0
  801469:	52                   	push   %edx
  80146a:	50                   	push   %eax
  80146b:	6a 18                	push   $0x18
  80146d:	e8 8a fd ff ff       	call   8011fc <syscall>
  801472:	83 c4 18             	add    $0x18,%esp
}
  801475:	c9                   	leave  
  801476:	c3                   	ret    

00801477 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
  80147d:	6a 00                	push   $0x0
  80147f:	ff 75 14             	pushl  0x14(%ebp)
  801482:	ff 75 10             	pushl  0x10(%ebp)
  801485:	ff 75 0c             	pushl  0xc(%ebp)
  801488:	50                   	push   %eax
  801489:	6a 19                	push   $0x19
  80148b:	e8 6c fd ff ff       	call   8011fc <syscall>
  801490:	83 c4 18             	add    $0x18,%esp
}
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	6a 00                	push   $0x0
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	50                   	push   %eax
  8014a4:	6a 1a                	push   $0x1a
  8014a6:	e8 51 fd ff ff       	call   8011fc <syscall>
  8014ab:	83 c4 18             	add    $0x18,%esp
}
  8014ae:	90                   	nop
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    

008014b1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	50                   	push   %eax
  8014c0:	6a 1b                	push   $0x1b
  8014c2:	e8 35 fd ff ff       	call   8011fc <syscall>
  8014c7:	83 c4 18             	add    $0x18,%esp
}
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 05                	push   $0x5
  8014db:	e8 1c fd ff ff       	call   8011fc <syscall>
  8014e0:	83 c4 18             	add    $0x18,%esp
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 06                	push   $0x6
  8014f4:	e8 03 fd ff ff       	call   8011fc <syscall>
  8014f9:	83 c4 18             	add    $0x18,%esp
}
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 07                	push   $0x7
  80150d:	e8 ea fc ff ff       	call   8011fc <syscall>
  801512:	83 c4 18             	add    $0x18,%esp
}
  801515:	c9                   	leave  
  801516:	c3                   	ret    

00801517 <sys_exit_env>:


void sys_exit_env(void)
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	6a 1c                	push   $0x1c
  801526:	e8 d1 fc ff ff       	call   8011fc <syscall>
  80152b:	83 c4 18             	add    $0x18,%esp
}
  80152e:	90                   	nop
  80152f:	c9                   	leave  
  801530:	c3                   	ret    

00801531 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801531:	55                   	push   %ebp
  801532:	89 e5                	mov    %esp,%ebp
  801534:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801537:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80153a:	8d 50 04             	lea    0x4(%eax),%edx
  80153d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	52                   	push   %edx
  801547:	50                   	push   %eax
  801548:	6a 1d                	push   $0x1d
  80154a:	e8 ad fc ff ff       	call   8011fc <syscall>
  80154f:	83 c4 18             	add    $0x18,%esp
	return result;
  801552:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801555:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801558:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80155b:	89 01                	mov    %eax,(%ecx)
  80155d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801560:	8b 45 08             	mov    0x8(%ebp),%eax
  801563:	c9                   	leave  
  801564:	c2 04 00             	ret    $0x4

00801567 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	ff 75 10             	pushl  0x10(%ebp)
  801571:	ff 75 0c             	pushl  0xc(%ebp)
  801574:	ff 75 08             	pushl  0x8(%ebp)
  801577:	6a 13                	push   $0x13
  801579:	e8 7e fc ff ff       	call   8011fc <syscall>
  80157e:	83 c4 18             	add    $0x18,%esp
	return ;
  801581:	90                   	nop
}
  801582:	c9                   	leave  
  801583:	c3                   	ret    

00801584 <sys_rcr2>:
uint32 sys_rcr2()
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 1e                	push   $0x1e
  801593:	e8 64 fc ff ff       	call   8011fc <syscall>
  801598:	83 c4 18             	add    $0x18,%esp
}
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
  8015a0:	83 ec 04             	sub    $0x4,%esp
  8015a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015a9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	50                   	push   %eax
  8015b6:	6a 1f                	push   $0x1f
  8015b8:	e8 3f fc ff ff       	call   8011fc <syscall>
  8015bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8015c0:	90                   	nop
}
  8015c1:	c9                   	leave  
  8015c2:	c3                   	ret    

008015c3 <rsttst>:
void rsttst()
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 21                	push   $0x21
  8015d2:	e8 25 fc ff ff       	call   8011fc <syscall>
  8015d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8015da:	90                   	nop
}
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	83 ec 04             	sub    $0x4,%esp
  8015e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015e9:	8b 55 18             	mov    0x18(%ebp),%edx
  8015ec:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015f0:	52                   	push   %edx
  8015f1:	50                   	push   %eax
  8015f2:	ff 75 10             	pushl  0x10(%ebp)
  8015f5:	ff 75 0c             	pushl  0xc(%ebp)
  8015f8:	ff 75 08             	pushl  0x8(%ebp)
  8015fb:	6a 20                	push   $0x20
  8015fd:	e8 fa fb ff ff       	call   8011fc <syscall>
  801602:	83 c4 18             	add    $0x18,%esp
	return ;
  801605:	90                   	nop
}
  801606:	c9                   	leave  
  801607:	c3                   	ret    

00801608 <chktst>:
void chktst(uint32 n)
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	ff 75 08             	pushl  0x8(%ebp)
  801616:	6a 22                	push   $0x22
  801618:	e8 df fb ff ff       	call   8011fc <syscall>
  80161d:	83 c4 18             	add    $0x18,%esp
	return ;
  801620:	90                   	nop
}
  801621:	c9                   	leave  
  801622:	c3                   	ret    

00801623 <inctst>:

void inctst()
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 23                	push   $0x23
  801632:	e8 c5 fb ff ff       	call   8011fc <syscall>
  801637:	83 c4 18             	add    $0x18,%esp
	return ;
  80163a:	90                   	nop
}
  80163b:	c9                   	leave  
  80163c:	c3                   	ret    

0080163d <gettst>:
uint32 gettst()
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 24                	push   $0x24
  80164c:	e8 ab fb ff ff       	call   8011fc <syscall>
  801651:	83 c4 18             	add    $0x18,%esp
}
  801654:	c9                   	leave  
  801655:	c3                   	ret    

00801656 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 25                	push   $0x25
  801668:	e8 8f fb ff ff       	call   8011fc <syscall>
  80166d:	83 c4 18             	add    $0x18,%esp
  801670:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801673:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801677:	75 07                	jne    801680 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801679:	b8 01 00 00 00       	mov    $0x1,%eax
  80167e:	eb 05                	jmp    801685 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801680:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801685:	c9                   	leave  
  801686:	c3                   	ret    

00801687 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 25                	push   $0x25
  801699:	e8 5e fb ff ff       	call   8011fc <syscall>
  80169e:	83 c4 18             	add    $0x18,%esp
  8016a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016a4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016a8:	75 07                	jne    8016b1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8016af:	eb 05                	jmp    8016b6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
  8016bb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 25                	push   $0x25
  8016ca:	e8 2d fb ff ff       	call   8011fc <syscall>
  8016cf:	83 c4 18             	add    $0x18,%esp
  8016d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016d5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016d9:	75 07                	jne    8016e2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016db:	b8 01 00 00 00       	mov    $0x1,%eax
  8016e0:	eb 05                	jmp    8016e7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 25                	push   $0x25
  8016fb:	e8 fc fa ff ff       	call   8011fc <syscall>
  801700:	83 c4 18             	add    $0x18,%esp
  801703:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801706:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80170a:	75 07                	jne    801713 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80170c:	b8 01 00 00 00       	mov    $0x1,%eax
  801711:	eb 05                	jmp    801718 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801713:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801718:	c9                   	leave  
  801719:	c3                   	ret    

0080171a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80171a:	55                   	push   %ebp
  80171b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	ff 75 08             	pushl  0x8(%ebp)
  801728:	6a 26                	push   $0x26
  80172a:	e8 cd fa ff ff       	call   8011fc <syscall>
  80172f:	83 c4 18             	add    $0x18,%esp
	return ;
  801732:	90                   	nop
}
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801739:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80173c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80173f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
  801745:	6a 00                	push   $0x0
  801747:	53                   	push   %ebx
  801748:	51                   	push   %ecx
  801749:	52                   	push   %edx
  80174a:	50                   	push   %eax
  80174b:	6a 27                	push   $0x27
  80174d:	e8 aa fa ff ff       	call   8011fc <syscall>
  801752:	83 c4 18             	add    $0x18,%esp
}
  801755:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801758:	c9                   	leave  
  801759:	c3                   	ret    

0080175a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80175d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	52                   	push   %edx
  80176a:	50                   	push   %eax
  80176b:	6a 28                	push   $0x28
  80176d:	e8 8a fa ff ff       	call   8011fc <syscall>
  801772:	83 c4 18             	add    $0x18,%esp
}
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80177a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80177d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	6a 00                	push   $0x0
  801785:	51                   	push   %ecx
  801786:	ff 75 10             	pushl  0x10(%ebp)
  801789:	52                   	push   %edx
  80178a:	50                   	push   %eax
  80178b:	6a 29                	push   $0x29
  80178d:	e8 6a fa ff ff       	call   8011fc <syscall>
  801792:	83 c4 18             	add    $0x18,%esp
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	ff 75 10             	pushl  0x10(%ebp)
  8017a1:	ff 75 0c             	pushl  0xc(%ebp)
  8017a4:	ff 75 08             	pushl  0x8(%ebp)
  8017a7:	6a 12                	push   $0x12
  8017a9:	e8 4e fa ff ff       	call   8011fc <syscall>
  8017ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b1:	90                   	nop
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8017b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	52                   	push   %edx
  8017c4:	50                   	push   %eax
  8017c5:	6a 2a                	push   $0x2a
  8017c7:	e8 30 fa ff ff       	call   8011fc <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
	return;
  8017cf:	90                   	nop
}
  8017d0:	c9                   	leave  
  8017d1:	c3                   	ret    

008017d2 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8017d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	50                   	push   %eax
  8017e1:	6a 2b                	push   $0x2b
  8017e3:	e8 14 fa ff ff       	call   8011fc <syscall>
  8017e8:	83 c4 18             	add    $0x18,%esp
}
  8017eb:	c9                   	leave  
  8017ec:	c3                   	ret    

008017ed <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	ff 75 0c             	pushl  0xc(%ebp)
  8017f9:	ff 75 08             	pushl  0x8(%ebp)
  8017fc:	6a 2c                	push   $0x2c
  8017fe:	e8 f9 f9 ff ff       	call   8011fc <syscall>
  801803:	83 c4 18             	add    $0x18,%esp
	return;
  801806:	90                   	nop
}
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	ff 75 0c             	pushl  0xc(%ebp)
  801815:	ff 75 08             	pushl  0x8(%ebp)
  801818:	6a 2d                	push   $0x2d
  80181a:	e8 dd f9 ff ff       	call   8011fc <syscall>
  80181f:	83 c4 18             	add    $0x18,%esp
	return;
  801822:	90                   	nop
}
  801823:	c9                   	leave  
  801824:	c3                   	ret    

00801825 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 2e                	push   $0x2e
  801837:	e8 c0 f9 ff ff       	call   8011fc <syscall>
  80183c:	83 c4 18             	add    $0x18,%esp
  80183f:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801842:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	50                   	push   %eax
  801856:	6a 2f                	push   $0x2f
  801858:	e8 9f f9 ff ff       	call   8011fc <syscall>
  80185d:	83 c4 18             	add    $0x18,%esp
	return;
  801860:	90                   	nop
}
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  801866:	8b 55 0c             	mov    0xc(%ebp),%edx
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	52                   	push   %edx
  801873:	50                   	push   %eax
  801874:	6a 30                	push   $0x30
  801876:	e8 81 f9 ff ff       	call   8011fc <syscall>
  80187b:	83 c4 18             	add    $0x18,%esp
	return;
  80187e:	90                   	nop
}
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  801887:	8b 45 08             	mov    0x8(%ebp),%eax
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	50                   	push   %eax
  801893:	6a 31                	push   $0x31
  801895:	e8 62 f9 ff ff       	call   8011fc <syscall>
  80189a:	83 c4 18             	add    $0x18,%esp
  80189d:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  8018a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  8018a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	50                   	push   %eax
  8018b4:	6a 32                	push   $0x32
  8018b6:	e8 41 f9 ff ff       	call   8011fc <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
	return;
  8018be:	90                   	nop
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    
  8018c1:	66 90                	xchg   %ax,%ax
  8018c3:	90                   	nop

008018c4 <__udivdi3>:
  8018c4:	55                   	push   %ebp
  8018c5:	57                   	push   %edi
  8018c6:	56                   	push   %esi
  8018c7:	53                   	push   %ebx
  8018c8:	83 ec 1c             	sub    $0x1c,%esp
  8018cb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8018cf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8018d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018d7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018db:	89 ca                	mov    %ecx,%edx
  8018dd:	89 f8                	mov    %edi,%eax
  8018df:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8018e3:	85 f6                	test   %esi,%esi
  8018e5:	75 2d                	jne    801914 <__udivdi3+0x50>
  8018e7:	39 cf                	cmp    %ecx,%edi
  8018e9:	77 65                	ja     801950 <__udivdi3+0x8c>
  8018eb:	89 fd                	mov    %edi,%ebp
  8018ed:	85 ff                	test   %edi,%edi
  8018ef:	75 0b                	jne    8018fc <__udivdi3+0x38>
  8018f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8018f6:	31 d2                	xor    %edx,%edx
  8018f8:	f7 f7                	div    %edi
  8018fa:	89 c5                	mov    %eax,%ebp
  8018fc:	31 d2                	xor    %edx,%edx
  8018fe:	89 c8                	mov    %ecx,%eax
  801900:	f7 f5                	div    %ebp
  801902:	89 c1                	mov    %eax,%ecx
  801904:	89 d8                	mov    %ebx,%eax
  801906:	f7 f5                	div    %ebp
  801908:	89 cf                	mov    %ecx,%edi
  80190a:	89 fa                	mov    %edi,%edx
  80190c:	83 c4 1c             	add    $0x1c,%esp
  80190f:	5b                   	pop    %ebx
  801910:	5e                   	pop    %esi
  801911:	5f                   	pop    %edi
  801912:	5d                   	pop    %ebp
  801913:	c3                   	ret    
  801914:	39 ce                	cmp    %ecx,%esi
  801916:	77 28                	ja     801940 <__udivdi3+0x7c>
  801918:	0f bd fe             	bsr    %esi,%edi
  80191b:	83 f7 1f             	xor    $0x1f,%edi
  80191e:	75 40                	jne    801960 <__udivdi3+0x9c>
  801920:	39 ce                	cmp    %ecx,%esi
  801922:	72 0a                	jb     80192e <__udivdi3+0x6a>
  801924:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801928:	0f 87 9e 00 00 00    	ja     8019cc <__udivdi3+0x108>
  80192e:	b8 01 00 00 00       	mov    $0x1,%eax
  801933:	89 fa                	mov    %edi,%edx
  801935:	83 c4 1c             	add    $0x1c,%esp
  801938:	5b                   	pop    %ebx
  801939:	5e                   	pop    %esi
  80193a:	5f                   	pop    %edi
  80193b:	5d                   	pop    %ebp
  80193c:	c3                   	ret    
  80193d:	8d 76 00             	lea    0x0(%esi),%esi
  801940:	31 ff                	xor    %edi,%edi
  801942:	31 c0                	xor    %eax,%eax
  801944:	89 fa                	mov    %edi,%edx
  801946:	83 c4 1c             	add    $0x1c,%esp
  801949:	5b                   	pop    %ebx
  80194a:	5e                   	pop    %esi
  80194b:	5f                   	pop    %edi
  80194c:	5d                   	pop    %ebp
  80194d:	c3                   	ret    
  80194e:	66 90                	xchg   %ax,%ax
  801950:	89 d8                	mov    %ebx,%eax
  801952:	f7 f7                	div    %edi
  801954:	31 ff                	xor    %edi,%edi
  801956:	89 fa                	mov    %edi,%edx
  801958:	83 c4 1c             	add    $0x1c,%esp
  80195b:	5b                   	pop    %ebx
  80195c:	5e                   	pop    %esi
  80195d:	5f                   	pop    %edi
  80195e:	5d                   	pop    %ebp
  80195f:	c3                   	ret    
  801960:	bd 20 00 00 00       	mov    $0x20,%ebp
  801965:	89 eb                	mov    %ebp,%ebx
  801967:	29 fb                	sub    %edi,%ebx
  801969:	89 f9                	mov    %edi,%ecx
  80196b:	d3 e6                	shl    %cl,%esi
  80196d:	89 c5                	mov    %eax,%ebp
  80196f:	88 d9                	mov    %bl,%cl
  801971:	d3 ed                	shr    %cl,%ebp
  801973:	89 e9                	mov    %ebp,%ecx
  801975:	09 f1                	or     %esi,%ecx
  801977:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80197b:	89 f9                	mov    %edi,%ecx
  80197d:	d3 e0                	shl    %cl,%eax
  80197f:	89 c5                	mov    %eax,%ebp
  801981:	89 d6                	mov    %edx,%esi
  801983:	88 d9                	mov    %bl,%cl
  801985:	d3 ee                	shr    %cl,%esi
  801987:	89 f9                	mov    %edi,%ecx
  801989:	d3 e2                	shl    %cl,%edx
  80198b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80198f:	88 d9                	mov    %bl,%cl
  801991:	d3 e8                	shr    %cl,%eax
  801993:	09 c2                	or     %eax,%edx
  801995:	89 d0                	mov    %edx,%eax
  801997:	89 f2                	mov    %esi,%edx
  801999:	f7 74 24 0c          	divl   0xc(%esp)
  80199d:	89 d6                	mov    %edx,%esi
  80199f:	89 c3                	mov    %eax,%ebx
  8019a1:	f7 e5                	mul    %ebp
  8019a3:	39 d6                	cmp    %edx,%esi
  8019a5:	72 19                	jb     8019c0 <__udivdi3+0xfc>
  8019a7:	74 0b                	je     8019b4 <__udivdi3+0xf0>
  8019a9:	89 d8                	mov    %ebx,%eax
  8019ab:	31 ff                	xor    %edi,%edi
  8019ad:	e9 58 ff ff ff       	jmp    80190a <__udivdi3+0x46>
  8019b2:	66 90                	xchg   %ax,%ax
  8019b4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8019b8:	89 f9                	mov    %edi,%ecx
  8019ba:	d3 e2                	shl    %cl,%edx
  8019bc:	39 c2                	cmp    %eax,%edx
  8019be:	73 e9                	jae    8019a9 <__udivdi3+0xe5>
  8019c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8019c3:	31 ff                	xor    %edi,%edi
  8019c5:	e9 40 ff ff ff       	jmp    80190a <__udivdi3+0x46>
  8019ca:	66 90                	xchg   %ax,%ax
  8019cc:	31 c0                	xor    %eax,%eax
  8019ce:	e9 37 ff ff ff       	jmp    80190a <__udivdi3+0x46>
  8019d3:	90                   	nop

008019d4 <__umoddi3>:
  8019d4:	55                   	push   %ebp
  8019d5:	57                   	push   %edi
  8019d6:	56                   	push   %esi
  8019d7:	53                   	push   %ebx
  8019d8:	83 ec 1c             	sub    $0x1c,%esp
  8019db:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8019df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8019e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019e7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8019eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019ef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019f3:	89 f3                	mov    %esi,%ebx
  8019f5:	89 fa                	mov    %edi,%edx
  8019f7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019fb:	89 34 24             	mov    %esi,(%esp)
  8019fe:	85 c0                	test   %eax,%eax
  801a00:	75 1a                	jne    801a1c <__umoddi3+0x48>
  801a02:	39 f7                	cmp    %esi,%edi
  801a04:	0f 86 a2 00 00 00    	jbe    801aac <__umoddi3+0xd8>
  801a0a:	89 c8                	mov    %ecx,%eax
  801a0c:	89 f2                	mov    %esi,%edx
  801a0e:	f7 f7                	div    %edi
  801a10:	89 d0                	mov    %edx,%eax
  801a12:	31 d2                	xor    %edx,%edx
  801a14:	83 c4 1c             	add    $0x1c,%esp
  801a17:	5b                   	pop    %ebx
  801a18:	5e                   	pop    %esi
  801a19:	5f                   	pop    %edi
  801a1a:	5d                   	pop    %ebp
  801a1b:	c3                   	ret    
  801a1c:	39 f0                	cmp    %esi,%eax
  801a1e:	0f 87 ac 00 00 00    	ja     801ad0 <__umoddi3+0xfc>
  801a24:	0f bd e8             	bsr    %eax,%ebp
  801a27:	83 f5 1f             	xor    $0x1f,%ebp
  801a2a:	0f 84 ac 00 00 00    	je     801adc <__umoddi3+0x108>
  801a30:	bf 20 00 00 00       	mov    $0x20,%edi
  801a35:	29 ef                	sub    %ebp,%edi
  801a37:	89 fe                	mov    %edi,%esi
  801a39:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a3d:	89 e9                	mov    %ebp,%ecx
  801a3f:	d3 e0                	shl    %cl,%eax
  801a41:	89 d7                	mov    %edx,%edi
  801a43:	89 f1                	mov    %esi,%ecx
  801a45:	d3 ef                	shr    %cl,%edi
  801a47:	09 c7                	or     %eax,%edi
  801a49:	89 e9                	mov    %ebp,%ecx
  801a4b:	d3 e2                	shl    %cl,%edx
  801a4d:	89 14 24             	mov    %edx,(%esp)
  801a50:	89 d8                	mov    %ebx,%eax
  801a52:	d3 e0                	shl    %cl,%eax
  801a54:	89 c2                	mov    %eax,%edx
  801a56:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a5a:	d3 e0                	shl    %cl,%eax
  801a5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a60:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a64:	89 f1                	mov    %esi,%ecx
  801a66:	d3 e8                	shr    %cl,%eax
  801a68:	09 d0                	or     %edx,%eax
  801a6a:	d3 eb                	shr    %cl,%ebx
  801a6c:	89 da                	mov    %ebx,%edx
  801a6e:	f7 f7                	div    %edi
  801a70:	89 d3                	mov    %edx,%ebx
  801a72:	f7 24 24             	mull   (%esp)
  801a75:	89 c6                	mov    %eax,%esi
  801a77:	89 d1                	mov    %edx,%ecx
  801a79:	39 d3                	cmp    %edx,%ebx
  801a7b:	0f 82 87 00 00 00    	jb     801b08 <__umoddi3+0x134>
  801a81:	0f 84 91 00 00 00    	je     801b18 <__umoddi3+0x144>
  801a87:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a8b:	29 f2                	sub    %esi,%edx
  801a8d:	19 cb                	sbb    %ecx,%ebx
  801a8f:	89 d8                	mov    %ebx,%eax
  801a91:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a95:	d3 e0                	shl    %cl,%eax
  801a97:	89 e9                	mov    %ebp,%ecx
  801a99:	d3 ea                	shr    %cl,%edx
  801a9b:	09 d0                	or     %edx,%eax
  801a9d:	89 e9                	mov    %ebp,%ecx
  801a9f:	d3 eb                	shr    %cl,%ebx
  801aa1:	89 da                	mov    %ebx,%edx
  801aa3:	83 c4 1c             	add    $0x1c,%esp
  801aa6:	5b                   	pop    %ebx
  801aa7:	5e                   	pop    %esi
  801aa8:	5f                   	pop    %edi
  801aa9:	5d                   	pop    %ebp
  801aaa:	c3                   	ret    
  801aab:	90                   	nop
  801aac:	89 fd                	mov    %edi,%ebp
  801aae:	85 ff                	test   %edi,%edi
  801ab0:	75 0b                	jne    801abd <__umoddi3+0xe9>
  801ab2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab7:	31 d2                	xor    %edx,%edx
  801ab9:	f7 f7                	div    %edi
  801abb:	89 c5                	mov    %eax,%ebp
  801abd:	89 f0                	mov    %esi,%eax
  801abf:	31 d2                	xor    %edx,%edx
  801ac1:	f7 f5                	div    %ebp
  801ac3:	89 c8                	mov    %ecx,%eax
  801ac5:	f7 f5                	div    %ebp
  801ac7:	89 d0                	mov    %edx,%eax
  801ac9:	e9 44 ff ff ff       	jmp    801a12 <__umoddi3+0x3e>
  801ace:	66 90                	xchg   %ax,%ax
  801ad0:	89 c8                	mov    %ecx,%eax
  801ad2:	89 f2                	mov    %esi,%edx
  801ad4:	83 c4 1c             	add    $0x1c,%esp
  801ad7:	5b                   	pop    %ebx
  801ad8:	5e                   	pop    %esi
  801ad9:	5f                   	pop    %edi
  801ada:	5d                   	pop    %ebp
  801adb:	c3                   	ret    
  801adc:	3b 04 24             	cmp    (%esp),%eax
  801adf:	72 06                	jb     801ae7 <__umoddi3+0x113>
  801ae1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ae5:	77 0f                	ja     801af6 <__umoddi3+0x122>
  801ae7:	89 f2                	mov    %esi,%edx
  801ae9:	29 f9                	sub    %edi,%ecx
  801aeb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801aef:	89 14 24             	mov    %edx,(%esp)
  801af2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801af6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801afa:	8b 14 24             	mov    (%esp),%edx
  801afd:	83 c4 1c             	add    $0x1c,%esp
  801b00:	5b                   	pop    %ebx
  801b01:	5e                   	pop    %esi
  801b02:	5f                   	pop    %edi
  801b03:	5d                   	pop    %ebp
  801b04:	c3                   	ret    
  801b05:	8d 76 00             	lea    0x0(%esi),%esi
  801b08:	2b 04 24             	sub    (%esp),%eax
  801b0b:	19 fa                	sbb    %edi,%edx
  801b0d:	89 d1                	mov    %edx,%ecx
  801b0f:	89 c6                	mov    %eax,%esi
  801b11:	e9 71 ff ff ff       	jmp    801a87 <__umoddi3+0xb3>
  801b16:	66 90                	xchg   %ax,%ax
  801b18:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b1c:	72 ea                	jb     801b08 <__umoddi3+0x134>
  801b1e:	89 d9                	mov    %ebx,%ecx
  801b20:	e9 62 ff ff ff       	jmp    801a87 <__umoddi3+0xb3>
