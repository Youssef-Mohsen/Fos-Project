
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
  80004b:	e8 b3 17 00 00       	call   801803 <sys_free_user_mem>
  800050:	83 c4 10             	add    $0x10,%esp
	inctst();
  800053:	e8 df 15 00 00       	call   801637 <inctst>
	panic("tst system calls #2 failed: sys_free_user_mem is called with invalid params\nThe env must be killed and shouldn't return here.");
  800058:	83 ec 04             	sub    $0x4,%esp
  80005b:	68 c0 1a 80 00       	push   $0x801ac0
  800060:	6a 0a                	push   $0xa
  800062:	68 3e 1b 80 00       	push   $0x801b3e
  800067:	e8 4d 01 00 00       	call   8001b9 <_panic>

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
  800072:	e8 82 14 00 00       	call   8014f9 <sys_getenvindex>
  800077:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80007a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80007d:	89 d0                	mov    %edx,%eax
  80007f:	c1 e0 06             	shl    $0x6,%eax
  800082:	29 d0                	sub    %edx,%eax
  800084:	c1 e0 02             	shl    $0x2,%eax
  800087:	01 d0                	add    %edx,%eax
  800089:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800090:	01 c8                	add    %ecx,%eax
  800092:	c1 e0 03             	shl    $0x3,%eax
  800095:	01 d0                	add    %edx,%eax
  800097:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80009e:	29 c2                	sub    %eax,%edx
  8000a0:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8000a7:	89 c2                	mov    %eax,%edx
  8000a9:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8000af:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000b4:	a1 04 30 80 00       	mov    0x803004,%eax
  8000b9:	8a 40 20             	mov    0x20(%eax),%al
  8000bc:	84 c0                	test   %al,%al
  8000be:	74 0d                	je     8000cd <libmain+0x61>
		binaryname = myEnv->prog_name;
  8000c0:	a1 04 30 80 00       	mov    0x803004,%eax
  8000c5:	83 c0 20             	add    $0x20,%eax
  8000c8:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000d1:	7e 0a                	jle    8000dd <libmain+0x71>
		binaryname = argv[0];
  8000d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000d6:	8b 00                	mov    (%eax),%eax
  8000d8:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000dd:	83 ec 08             	sub    $0x8,%esp
  8000e0:	ff 75 0c             	pushl  0xc(%ebp)
  8000e3:	ff 75 08             	pushl  0x8(%ebp)
  8000e6:	e8 4d ff ff ff       	call   800038 <_main>
  8000eb:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8000ee:	e8 8a 11 00 00       	call   80127d <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	68 74 1b 80 00       	push   $0x801b74
  8000fb:	e8 76 03 00 00       	call   800476 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800103:	a1 04 30 80 00       	mov    0x803004,%eax
  800108:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80010e:	a1 04 30 80 00       	mov    0x803004,%eax
  800113:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	52                   	push   %edx
  80011d:	50                   	push   %eax
  80011e:	68 9c 1b 80 00       	push   $0x801b9c
  800123:	e8 4e 03 00 00       	call   800476 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80012b:	a1 04 30 80 00       	mov    0x803004,%eax
  800130:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800136:	a1 04 30 80 00       	mov    0x803004,%eax
  80013b:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800141:	a1 04 30 80 00       	mov    0x803004,%eax
  800146:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80014c:	51                   	push   %ecx
  80014d:	52                   	push   %edx
  80014e:	50                   	push   %eax
  80014f:	68 c4 1b 80 00       	push   $0x801bc4
  800154:	e8 1d 03 00 00       	call   800476 <cprintf>
  800159:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80015c:	a1 04 30 80 00       	mov    0x803004,%eax
  800161:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800167:	83 ec 08             	sub    $0x8,%esp
  80016a:	50                   	push   %eax
  80016b:	68 1c 1c 80 00       	push   $0x801c1c
  800170:	e8 01 03 00 00       	call   800476 <cprintf>
  800175:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800178:	83 ec 0c             	sub    $0xc,%esp
  80017b:	68 74 1b 80 00       	push   $0x801b74
  800180:	e8 f1 02 00 00       	call   800476 <cprintf>
  800185:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800188:	e8 0a 11 00 00       	call   801297 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80018d:	e8 19 00 00 00       	call   8001ab <exit>
}
  800192:	90                   	nop
  800193:	c9                   	leave  
  800194:	c3                   	ret    

00800195 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800195:	55                   	push   %ebp
  800196:	89 e5                	mov    %esp,%ebp
  800198:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80019b:	83 ec 0c             	sub    $0xc,%esp
  80019e:	6a 00                	push   $0x0
  8001a0:	e8 20 13 00 00       	call   8014c5 <sys_destroy_env>
  8001a5:	83 c4 10             	add    $0x10,%esp
}
  8001a8:	90                   	nop
  8001a9:	c9                   	leave  
  8001aa:	c3                   	ret    

008001ab <exit>:

void
exit(void)
{
  8001ab:	55                   	push   %ebp
  8001ac:	89 e5                	mov    %esp,%ebp
  8001ae:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001b1:	e8 75 13 00 00       	call   80152b <sys_exit_env>
}
  8001b6:	90                   	nop
  8001b7:	c9                   	leave  
  8001b8:	c3                   	ret    

008001b9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001b9:	55                   	push   %ebp
  8001ba:	89 e5                	mov    %esp,%ebp
  8001bc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001bf:	8d 45 10             	lea    0x10(%ebp),%eax
  8001c2:	83 c0 04             	add    $0x4,%eax
  8001c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001c8:	a1 24 30 80 00       	mov    0x803024,%eax
  8001cd:	85 c0                	test   %eax,%eax
  8001cf:	74 16                	je     8001e7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001d1:	a1 24 30 80 00       	mov    0x803024,%eax
  8001d6:	83 ec 08             	sub    $0x8,%esp
  8001d9:	50                   	push   %eax
  8001da:	68 30 1c 80 00       	push   $0x801c30
  8001df:	e8 92 02 00 00       	call   800476 <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001e7:	a1 00 30 80 00       	mov    0x803000,%eax
  8001ec:	ff 75 0c             	pushl  0xc(%ebp)
  8001ef:	ff 75 08             	pushl  0x8(%ebp)
  8001f2:	50                   	push   %eax
  8001f3:	68 35 1c 80 00       	push   $0x801c35
  8001f8:	e8 79 02 00 00       	call   800476 <cprintf>
  8001fd:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800200:	8b 45 10             	mov    0x10(%ebp),%eax
  800203:	83 ec 08             	sub    $0x8,%esp
  800206:	ff 75 f4             	pushl  -0xc(%ebp)
  800209:	50                   	push   %eax
  80020a:	e8 fc 01 00 00       	call   80040b <vcprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800212:	83 ec 08             	sub    $0x8,%esp
  800215:	6a 00                	push   $0x0
  800217:	68 51 1c 80 00       	push   $0x801c51
  80021c:	e8 ea 01 00 00       	call   80040b <vcprintf>
  800221:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800224:	e8 82 ff ff ff       	call   8001ab <exit>

	// should not return here
	while (1) ;
  800229:	eb fe                	jmp    800229 <_panic+0x70>

0080022b <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80022b:	55                   	push   %ebp
  80022c:	89 e5                	mov    %esp,%ebp
  80022e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800231:	a1 04 30 80 00       	mov    0x803004,%eax
  800236:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80023c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023f:	39 c2                	cmp    %eax,%edx
  800241:	74 14                	je     800257 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800243:	83 ec 04             	sub    $0x4,%esp
  800246:	68 54 1c 80 00       	push   $0x801c54
  80024b:	6a 26                	push   $0x26
  80024d:	68 a0 1c 80 00       	push   $0x801ca0
  800252:	e8 62 ff ff ff       	call   8001b9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800257:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80025e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800265:	e9 c5 00 00 00       	jmp    80032f <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80026a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80026d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800274:	8b 45 08             	mov    0x8(%ebp),%eax
  800277:	01 d0                	add    %edx,%eax
  800279:	8b 00                	mov    (%eax),%eax
  80027b:	85 c0                	test   %eax,%eax
  80027d:	75 08                	jne    800287 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80027f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800282:	e9 a5 00 00 00       	jmp    80032c <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800287:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80028e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800295:	eb 69                	jmp    800300 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800297:	a1 04 30 80 00       	mov    0x803004,%eax
  80029c:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8002a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002a5:	89 d0                	mov    %edx,%eax
  8002a7:	01 c0                	add    %eax,%eax
  8002a9:	01 d0                	add    %edx,%eax
  8002ab:	c1 e0 03             	shl    $0x3,%eax
  8002ae:	01 c8                	add    %ecx,%eax
  8002b0:	8a 40 04             	mov    0x4(%eax),%al
  8002b3:	84 c0                	test   %al,%al
  8002b5:	75 46                	jne    8002fd <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002b7:	a1 04 30 80 00       	mov    0x803004,%eax
  8002bc:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8002c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002c5:	89 d0                	mov    %edx,%eax
  8002c7:	01 c0                	add    %eax,%eax
  8002c9:	01 d0                	add    %edx,%eax
  8002cb:	c1 e0 03             	shl    $0x3,%eax
  8002ce:	01 c8                	add    %ecx,%eax
  8002d0:	8b 00                	mov    (%eax),%eax
  8002d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002dd:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002e2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ec:	01 c8                	add    %ecx,%eax
  8002ee:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002f0:	39 c2                	cmp    %eax,%edx
  8002f2:	75 09                	jne    8002fd <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002f4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002fb:	eb 15                	jmp    800312 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002fd:	ff 45 e8             	incl   -0x18(%ebp)
  800300:	a1 04 30 80 00       	mov    0x803004,%eax
  800305:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80030b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80030e:	39 c2                	cmp    %eax,%edx
  800310:	77 85                	ja     800297 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800312:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800316:	75 14                	jne    80032c <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800318:	83 ec 04             	sub    $0x4,%esp
  80031b:	68 ac 1c 80 00       	push   $0x801cac
  800320:	6a 3a                	push   $0x3a
  800322:	68 a0 1c 80 00       	push   $0x801ca0
  800327:	e8 8d fe ff ff       	call   8001b9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80032c:	ff 45 f0             	incl   -0x10(%ebp)
  80032f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800332:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800335:	0f 8c 2f ff ff ff    	jl     80026a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80033b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800342:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800349:	eb 26                	jmp    800371 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80034b:	a1 04 30 80 00       	mov    0x803004,%eax
  800350:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800356:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800359:	89 d0                	mov    %edx,%eax
  80035b:	01 c0                	add    %eax,%eax
  80035d:	01 d0                	add    %edx,%eax
  80035f:	c1 e0 03             	shl    $0x3,%eax
  800362:	01 c8                	add    %ecx,%eax
  800364:	8a 40 04             	mov    0x4(%eax),%al
  800367:	3c 01                	cmp    $0x1,%al
  800369:	75 03                	jne    80036e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80036b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80036e:	ff 45 e0             	incl   -0x20(%ebp)
  800371:	a1 04 30 80 00       	mov    0x803004,%eax
  800376:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80037c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80037f:	39 c2                	cmp    %eax,%edx
  800381:	77 c8                	ja     80034b <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800386:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800389:	74 14                	je     80039f <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80038b:	83 ec 04             	sub    $0x4,%esp
  80038e:	68 00 1d 80 00       	push   $0x801d00
  800393:	6a 44                	push   $0x44
  800395:	68 a0 1c 80 00       	push   $0x801ca0
  80039a:	e8 1a fe ff ff       	call   8001b9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80039f:	90                   	nop
  8003a0:	c9                   	leave  
  8003a1:	c3                   	ret    

008003a2 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8003a2:	55                   	push   %ebp
  8003a3:	89 e5                	mov    %esp,%ebp
  8003a5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8003a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ab:	8b 00                	mov    (%eax),%eax
  8003ad:	8d 48 01             	lea    0x1(%eax),%ecx
  8003b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b3:	89 0a                	mov    %ecx,(%edx)
  8003b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b8:	88 d1                	mov    %dl,%cl
  8003ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bd:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c4:	8b 00                	mov    (%eax),%eax
  8003c6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003cb:	75 2c                	jne    8003f9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003cd:	a0 08 30 80 00       	mov    0x803008,%al
  8003d2:	0f b6 c0             	movzbl %al,%eax
  8003d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003d8:	8b 12                	mov    (%edx),%edx
  8003da:	89 d1                	mov    %edx,%ecx
  8003dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003df:	83 c2 08             	add    $0x8,%edx
  8003e2:	83 ec 04             	sub    $0x4,%esp
  8003e5:	50                   	push   %eax
  8003e6:	51                   	push   %ecx
  8003e7:	52                   	push   %edx
  8003e8:	e8 4e 0e 00 00       	call   80123b <sys_cputs>
  8003ed:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003fc:	8b 40 04             	mov    0x4(%eax),%eax
  8003ff:	8d 50 01             	lea    0x1(%eax),%edx
  800402:	8b 45 0c             	mov    0xc(%ebp),%eax
  800405:	89 50 04             	mov    %edx,0x4(%eax)
}
  800408:	90                   	nop
  800409:	c9                   	leave  
  80040a:	c3                   	ret    

0080040b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80040b:	55                   	push   %ebp
  80040c:	89 e5                	mov    %esp,%ebp
  80040e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800414:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80041b:	00 00 00 
	b.cnt = 0;
  80041e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800425:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800428:	ff 75 0c             	pushl  0xc(%ebp)
  80042b:	ff 75 08             	pushl  0x8(%ebp)
  80042e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800434:	50                   	push   %eax
  800435:	68 a2 03 80 00       	push   $0x8003a2
  80043a:	e8 11 02 00 00       	call   800650 <vprintfmt>
  80043f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800442:	a0 08 30 80 00       	mov    0x803008,%al
  800447:	0f b6 c0             	movzbl %al,%eax
  80044a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800450:	83 ec 04             	sub    $0x4,%esp
  800453:	50                   	push   %eax
  800454:	52                   	push   %edx
  800455:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80045b:	83 c0 08             	add    $0x8,%eax
  80045e:	50                   	push   %eax
  80045f:	e8 d7 0d 00 00       	call   80123b <sys_cputs>
  800464:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800467:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  80046e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800474:	c9                   	leave  
  800475:	c3                   	ret    

00800476 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800476:	55                   	push   %ebp
  800477:	89 e5                	mov    %esp,%ebp
  800479:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80047c:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800483:	8d 45 0c             	lea    0xc(%ebp),%eax
  800486:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800489:	8b 45 08             	mov    0x8(%ebp),%eax
  80048c:	83 ec 08             	sub    $0x8,%esp
  80048f:	ff 75 f4             	pushl  -0xc(%ebp)
  800492:	50                   	push   %eax
  800493:	e8 73 ff ff ff       	call   80040b <vcprintf>
  800498:	83 c4 10             	add    $0x10,%esp
  80049b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80049e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004a1:	c9                   	leave  
  8004a2:	c3                   	ret    

008004a3 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8004a3:	55                   	push   %ebp
  8004a4:	89 e5                	mov    %esp,%ebp
  8004a6:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8004a9:	e8 cf 0d 00 00       	call   80127d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8004ae:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8004b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b7:	83 ec 08             	sub    $0x8,%esp
  8004ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8004bd:	50                   	push   %eax
  8004be:	e8 48 ff ff ff       	call   80040b <vcprintf>
  8004c3:	83 c4 10             	add    $0x10,%esp
  8004c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004c9:	e8 c9 0d 00 00       	call   801297 <sys_unlock_cons>
	return cnt;
  8004ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004d1:	c9                   	leave  
  8004d2:	c3                   	ret    

008004d3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004d3:	55                   	push   %ebp
  8004d4:	89 e5                	mov    %esp,%ebp
  8004d6:	53                   	push   %ebx
  8004d7:	83 ec 14             	sub    $0x14,%esp
  8004da:	8b 45 10             	mov    0x10(%ebp),%eax
  8004dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004e6:	8b 45 18             	mov    0x18(%ebp),%eax
  8004e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ee:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004f1:	77 55                	ja     800548 <printnum+0x75>
  8004f3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004f6:	72 05                	jb     8004fd <printnum+0x2a>
  8004f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004fb:	77 4b                	ja     800548 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004fd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800500:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800503:	8b 45 18             	mov    0x18(%ebp),%eax
  800506:	ba 00 00 00 00       	mov    $0x0,%edx
  80050b:	52                   	push   %edx
  80050c:	50                   	push   %eax
  80050d:	ff 75 f4             	pushl  -0xc(%ebp)
  800510:	ff 75 f0             	pushl  -0x10(%ebp)
  800513:	e8 28 13 00 00       	call   801840 <__udivdi3>
  800518:	83 c4 10             	add    $0x10,%esp
  80051b:	83 ec 04             	sub    $0x4,%esp
  80051e:	ff 75 20             	pushl  0x20(%ebp)
  800521:	53                   	push   %ebx
  800522:	ff 75 18             	pushl  0x18(%ebp)
  800525:	52                   	push   %edx
  800526:	50                   	push   %eax
  800527:	ff 75 0c             	pushl  0xc(%ebp)
  80052a:	ff 75 08             	pushl  0x8(%ebp)
  80052d:	e8 a1 ff ff ff       	call   8004d3 <printnum>
  800532:	83 c4 20             	add    $0x20,%esp
  800535:	eb 1a                	jmp    800551 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800537:	83 ec 08             	sub    $0x8,%esp
  80053a:	ff 75 0c             	pushl  0xc(%ebp)
  80053d:	ff 75 20             	pushl  0x20(%ebp)
  800540:	8b 45 08             	mov    0x8(%ebp),%eax
  800543:	ff d0                	call   *%eax
  800545:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800548:	ff 4d 1c             	decl   0x1c(%ebp)
  80054b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80054f:	7f e6                	jg     800537 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800551:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800554:	bb 00 00 00 00       	mov    $0x0,%ebx
  800559:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80055c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80055f:	53                   	push   %ebx
  800560:	51                   	push   %ecx
  800561:	52                   	push   %edx
  800562:	50                   	push   %eax
  800563:	e8 e8 13 00 00       	call   801950 <__umoddi3>
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	05 74 1f 80 00       	add    $0x801f74,%eax
  800570:	8a 00                	mov    (%eax),%al
  800572:	0f be c0             	movsbl %al,%eax
  800575:	83 ec 08             	sub    $0x8,%esp
  800578:	ff 75 0c             	pushl  0xc(%ebp)
  80057b:	50                   	push   %eax
  80057c:	8b 45 08             	mov    0x8(%ebp),%eax
  80057f:	ff d0                	call   *%eax
  800581:	83 c4 10             	add    $0x10,%esp
}
  800584:	90                   	nop
  800585:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800588:	c9                   	leave  
  800589:	c3                   	ret    

0080058a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80058a:	55                   	push   %ebp
  80058b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80058d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800591:	7e 1c                	jle    8005af <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800593:	8b 45 08             	mov    0x8(%ebp),%eax
  800596:	8b 00                	mov    (%eax),%eax
  800598:	8d 50 08             	lea    0x8(%eax),%edx
  80059b:	8b 45 08             	mov    0x8(%ebp),%eax
  80059e:	89 10                	mov    %edx,(%eax)
  8005a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a3:	8b 00                	mov    (%eax),%eax
  8005a5:	83 e8 08             	sub    $0x8,%eax
  8005a8:	8b 50 04             	mov    0x4(%eax),%edx
  8005ab:	8b 00                	mov    (%eax),%eax
  8005ad:	eb 40                	jmp    8005ef <getuint+0x65>
	else if (lflag)
  8005af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005b3:	74 1e                	je     8005d3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b8:	8b 00                	mov    (%eax),%eax
  8005ba:	8d 50 04             	lea    0x4(%eax),%edx
  8005bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c0:	89 10                	mov    %edx,(%eax)
  8005c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c5:	8b 00                	mov    (%eax),%eax
  8005c7:	83 e8 04             	sub    $0x4,%eax
  8005ca:	8b 00                	mov    (%eax),%eax
  8005cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d1:	eb 1c                	jmp    8005ef <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	8d 50 04             	lea    0x4(%eax),%edx
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	89 10                	mov    %edx,(%eax)
  8005e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e3:	8b 00                	mov    (%eax),%eax
  8005e5:	83 e8 04             	sub    $0x4,%eax
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005ef:	5d                   	pop    %ebp
  8005f0:	c3                   	ret    

008005f1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005f1:	55                   	push   %ebp
  8005f2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005f4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005f8:	7e 1c                	jle    800616 <getint+0x25>
		return va_arg(*ap, long long);
  8005fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	8d 50 08             	lea    0x8(%eax),%edx
  800602:	8b 45 08             	mov    0x8(%ebp),%eax
  800605:	89 10                	mov    %edx,(%eax)
  800607:	8b 45 08             	mov    0x8(%ebp),%eax
  80060a:	8b 00                	mov    (%eax),%eax
  80060c:	83 e8 08             	sub    $0x8,%eax
  80060f:	8b 50 04             	mov    0x4(%eax),%edx
  800612:	8b 00                	mov    (%eax),%eax
  800614:	eb 38                	jmp    80064e <getint+0x5d>
	else if (lflag)
  800616:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80061a:	74 1a                	je     800636 <getint+0x45>
		return va_arg(*ap, long);
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
  800634:	eb 18                	jmp    80064e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800636:	8b 45 08             	mov    0x8(%ebp),%eax
  800639:	8b 00                	mov    (%eax),%eax
  80063b:	8d 50 04             	lea    0x4(%eax),%edx
  80063e:	8b 45 08             	mov    0x8(%ebp),%eax
  800641:	89 10                	mov    %edx,(%eax)
  800643:	8b 45 08             	mov    0x8(%ebp),%eax
  800646:	8b 00                	mov    (%eax),%eax
  800648:	83 e8 04             	sub    $0x4,%eax
  80064b:	8b 00                	mov    (%eax),%eax
  80064d:	99                   	cltd   
}
  80064e:	5d                   	pop    %ebp
  80064f:	c3                   	ret    

00800650 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800650:	55                   	push   %ebp
  800651:	89 e5                	mov    %esp,%ebp
  800653:	56                   	push   %esi
  800654:	53                   	push   %ebx
  800655:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800658:	eb 17                	jmp    800671 <vprintfmt+0x21>
			if (ch == '\0')
  80065a:	85 db                	test   %ebx,%ebx
  80065c:	0f 84 c1 03 00 00    	je     800a23 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800662:	83 ec 08             	sub    $0x8,%esp
  800665:	ff 75 0c             	pushl  0xc(%ebp)
  800668:	53                   	push   %ebx
  800669:	8b 45 08             	mov    0x8(%ebp),%eax
  80066c:	ff d0                	call   *%eax
  80066e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800671:	8b 45 10             	mov    0x10(%ebp),%eax
  800674:	8d 50 01             	lea    0x1(%eax),%edx
  800677:	89 55 10             	mov    %edx,0x10(%ebp)
  80067a:	8a 00                	mov    (%eax),%al
  80067c:	0f b6 d8             	movzbl %al,%ebx
  80067f:	83 fb 25             	cmp    $0x25,%ebx
  800682:	75 d6                	jne    80065a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800684:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800688:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80068f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800696:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80069d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8006a7:	8d 50 01             	lea    0x1(%eax),%edx
  8006aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8006ad:	8a 00                	mov    (%eax),%al
  8006af:	0f b6 d8             	movzbl %al,%ebx
  8006b2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006b5:	83 f8 5b             	cmp    $0x5b,%eax
  8006b8:	0f 87 3d 03 00 00    	ja     8009fb <vprintfmt+0x3ab>
  8006be:	8b 04 85 98 1f 80 00 	mov    0x801f98(,%eax,4),%eax
  8006c5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006c7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006cb:	eb d7                	jmp    8006a4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006cd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006d1:	eb d1                	jmp    8006a4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006d3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006dd:	89 d0                	mov    %edx,%eax
  8006df:	c1 e0 02             	shl    $0x2,%eax
  8006e2:	01 d0                	add    %edx,%eax
  8006e4:	01 c0                	add    %eax,%eax
  8006e6:	01 d8                	add    %ebx,%eax
  8006e8:	83 e8 30             	sub    $0x30,%eax
  8006eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8006f1:	8a 00                	mov    (%eax),%al
  8006f3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006f6:	83 fb 2f             	cmp    $0x2f,%ebx
  8006f9:	7e 3e                	jle    800739 <vprintfmt+0xe9>
  8006fb:	83 fb 39             	cmp    $0x39,%ebx
  8006fe:	7f 39                	jg     800739 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800700:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800703:	eb d5                	jmp    8006da <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800705:	8b 45 14             	mov    0x14(%ebp),%eax
  800708:	83 c0 04             	add    $0x4,%eax
  80070b:	89 45 14             	mov    %eax,0x14(%ebp)
  80070e:	8b 45 14             	mov    0x14(%ebp),%eax
  800711:	83 e8 04             	sub    $0x4,%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800719:	eb 1f                	jmp    80073a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80071b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80071f:	79 83                	jns    8006a4 <vprintfmt+0x54>
				width = 0;
  800721:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800728:	e9 77 ff ff ff       	jmp    8006a4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80072d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800734:	e9 6b ff ff ff       	jmp    8006a4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800739:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80073a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80073e:	0f 89 60 ff ff ff    	jns    8006a4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800744:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800747:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80074a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800751:	e9 4e ff ff ff       	jmp    8006a4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800756:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800759:	e9 46 ff ff ff       	jmp    8006a4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	83 c0 04             	add    $0x4,%eax
  800764:	89 45 14             	mov    %eax,0x14(%ebp)
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	83 e8 04             	sub    $0x4,%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	83 ec 08             	sub    $0x8,%esp
  800772:	ff 75 0c             	pushl  0xc(%ebp)
  800775:	50                   	push   %eax
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	ff d0                	call   *%eax
  80077b:	83 c4 10             	add    $0x10,%esp
			break;
  80077e:	e9 9b 02 00 00       	jmp    800a1e <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800783:	8b 45 14             	mov    0x14(%ebp),%eax
  800786:	83 c0 04             	add    $0x4,%eax
  800789:	89 45 14             	mov    %eax,0x14(%ebp)
  80078c:	8b 45 14             	mov    0x14(%ebp),%eax
  80078f:	83 e8 04             	sub    $0x4,%eax
  800792:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800794:	85 db                	test   %ebx,%ebx
  800796:	79 02                	jns    80079a <vprintfmt+0x14a>
				err = -err;
  800798:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80079a:	83 fb 64             	cmp    $0x64,%ebx
  80079d:	7f 0b                	jg     8007aa <vprintfmt+0x15a>
  80079f:	8b 34 9d e0 1d 80 00 	mov    0x801de0(,%ebx,4),%esi
  8007a6:	85 f6                	test   %esi,%esi
  8007a8:	75 19                	jne    8007c3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007aa:	53                   	push   %ebx
  8007ab:	68 85 1f 80 00       	push   $0x801f85
  8007b0:	ff 75 0c             	pushl  0xc(%ebp)
  8007b3:	ff 75 08             	pushl  0x8(%ebp)
  8007b6:	e8 70 02 00 00       	call   800a2b <printfmt>
  8007bb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007be:	e9 5b 02 00 00       	jmp    800a1e <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007c3:	56                   	push   %esi
  8007c4:	68 8e 1f 80 00       	push   $0x801f8e
  8007c9:	ff 75 0c             	pushl  0xc(%ebp)
  8007cc:	ff 75 08             	pushl  0x8(%ebp)
  8007cf:	e8 57 02 00 00       	call   800a2b <printfmt>
  8007d4:	83 c4 10             	add    $0x10,%esp
			break;
  8007d7:	e9 42 02 00 00       	jmp    800a1e <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007df:	83 c0 04             	add    $0x4,%eax
  8007e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e8:	83 e8 04             	sub    $0x4,%eax
  8007eb:	8b 30                	mov    (%eax),%esi
  8007ed:	85 f6                	test   %esi,%esi
  8007ef:	75 05                	jne    8007f6 <vprintfmt+0x1a6>
				p = "(null)";
  8007f1:	be 91 1f 80 00       	mov    $0x801f91,%esi
			if (width > 0 && padc != '-')
  8007f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fa:	7e 6d                	jle    800869 <vprintfmt+0x219>
  8007fc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800800:	74 67                	je     800869 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800802:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800805:	83 ec 08             	sub    $0x8,%esp
  800808:	50                   	push   %eax
  800809:	56                   	push   %esi
  80080a:	e8 1e 03 00 00       	call   800b2d <strnlen>
  80080f:	83 c4 10             	add    $0x10,%esp
  800812:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800815:	eb 16                	jmp    80082d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800817:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	ff 75 0c             	pushl  0xc(%ebp)
  800821:	50                   	push   %eax
  800822:	8b 45 08             	mov    0x8(%ebp),%eax
  800825:	ff d0                	call   *%eax
  800827:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80082a:	ff 4d e4             	decl   -0x1c(%ebp)
  80082d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800831:	7f e4                	jg     800817 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800833:	eb 34                	jmp    800869 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800835:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800839:	74 1c                	je     800857 <vprintfmt+0x207>
  80083b:	83 fb 1f             	cmp    $0x1f,%ebx
  80083e:	7e 05                	jle    800845 <vprintfmt+0x1f5>
  800840:	83 fb 7e             	cmp    $0x7e,%ebx
  800843:	7e 12                	jle    800857 <vprintfmt+0x207>
					putch('?', putdat);
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	ff 75 0c             	pushl  0xc(%ebp)
  80084b:	6a 3f                	push   $0x3f
  80084d:	8b 45 08             	mov    0x8(%ebp),%eax
  800850:	ff d0                	call   *%eax
  800852:	83 c4 10             	add    $0x10,%esp
  800855:	eb 0f                	jmp    800866 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800857:	83 ec 08             	sub    $0x8,%esp
  80085a:	ff 75 0c             	pushl  0xc(%ebp)
  80085d:	53                   	push   %ebx
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	ff d0                	call   *%eax
  800863:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800866:	ff 4d e4             	decl   -0x1c(%ebp)
  800869:	89 f0                	mov    %esi,%eax
  80086b:	8d 70 01             	lea    0x1(%eax),%esi
  80086e:	8a 00                	mov    (%eax),%al
  800870:	0f be d8             	movsbl %al,%ebx
  800873:	85 db                	test   %ebx,%ebx
  800875:	74 24                	je     80089b <vprintfmt+0x24b>
  800877:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80087b:	78 b8                	js     800835 <vprintfmt+0x1e5>
  80087d:	ff 4d e0             	decl   -0x20(%ebp)
  800880:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800884:	79 af                	jns    800835 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800886:	eb 13                	jmp    80089b <vprintfmt+0x24b>
				putch(' ', putdat);
  800888:	83 ec 08             	sub    $0x8,%esp
  80088b:	ff 75 0c             	pushl  0xc(%ebp)
  80088e:	6a 20                	push   $0x20
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	ff d0                	call   *%eax
  800895:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800898:	ff 4d e4             	decl   -0x1c(%ebp)
  80089b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80089f:	7f e7                	jg     800888 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8008a1:	e9 78 01 00 00       	jmp    800a1e <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008a6:	83 ec 08             	sub    $0x8,%esp
  8008a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8008ac:	8d 45 14             	lea    0x14(%ebp),%eax
  8008af:	50                   	push   %eax
  8008b0:	e8 3c fd ff ff       	call   8005f1 <getint>
  8008b5:	83 c4 10             	add    $0x10,%esp
  8008b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c4:	85 d2                	test   %edx,%edx
  8008c6:	79 23                	jns    8008eb <vprintfmt+0x29b>
				putch('-', putdat);
  8008c8:	83 ec 08             	sub    $0x8,%esp
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	6a 2d                	push   $0x2d
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	ff d0                	call   *%eax
  8008d5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008de:	f7 d8                	neg    %eax
  8008e0:	83 d2 00             	adc    $0x0,%edx
  8008e3:	f7 da                	neg    %edx
  8008e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008eb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008f2:	e9 bc 00 00 00       	jmp    8009b3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008f7:	83 ec 08             	sub    $0x8,%esp
  8008fa:	ff 75 e8             	pushl  -0x18(%ebp)
  8008fd:	8d 45 14             	lea    0x14(%ebp),%eax
  800900:	50                   	push   %eax
  800901:	e8 84 fc ff ff       	call   80058a <getuint>
  800906:	83 c4 10             	add    $0x10,%esp
  800909:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80090c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80090f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800916:	e9 98 00 00 00       	jmp    8009b3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80091b:	83 ec 08             	sub    $0x8,%esp
  80091e:	ff 75 0c             	pushl  0xc(%ebp)
  800921:	6a 58                	push   $0x58
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	ff d0                	call   *%eax
  800928:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	ff 75 0c             	pushl  0xc(%ebp)
  800931:	6a 58                	push   $0x58
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	ff d0                	call   *%eax
  800938:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80093b:	83 ec 08             	sub    $0x8,%esp
  80093e:	ff 75 0c             	pushl  0xc(%ebp)
  800941:	6a 58                	push   $0x58
  800943:	8b 45 08             	mov    0x8(%ebp),%eax
  800946:	ff d0                	call   *%eax
  800948:	83 c4 10             	add    $0x10,%esp
			break;
  80094b:	e9 ce 00 00 00       	jmp    800a1e <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800950:	83 ec 08             	sub    $0x8,%esp
  800953:	ff 75 0c             	pushl  0xc(%ebp)
  800956:	6a 30                	push   $0x30
  800958:	8b 45 08             	mov    0x8(%ebp),%eax
  80095b:	ff d0                	call   *%eax
  80095d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800960:	83 ec 08             	sub    $0x8,%esp
  800963:	ff 75 0c             	pushl  0xc(%ebp)
  800966:	6a 78                	push   $0x78
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	ff d0                	call   *%eax
  80096d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800970:	8b 45 14             	mov    0x14(%ebp),%eax
  800973:	83 c0 04             	add    $0x4,%eax
  800976:	89 45 14             	mov    %eax,0x14(%ebp)
  800979:	8b 45 14             	mov    0x14(%ebp),%eax
  80097c:	83 e8 04             	sub    $0x4,%eax
  80097f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800981:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800984:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80098b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800992:	eb 1f                	jmp    8009b3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800994:	83 ec 08             	sub    $0x8,%esp
  800997:	ff 75 e8             	pushl  -0x18(%ebp)
  80099a:	8d 45 14             	lea    0x14(%ebp),%eax
  80099d:	50                   	push   %eax
  80099e:	e8 e7 fb ff ff       	call   80058a <getuint>
  8009a3:	83 c4 10             	add    $0x10,%esp
  8009a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009ac:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009b3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ba:	83 ec 04             	sub    $0x4,%esp
  8009bd:	52                   	push   %edx
  8009be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009c1:	50                   	push   %eax
  8009c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8009c5:	ff 75 f0             	pushl  -0x10(%ebp)
  8009c8:	ff 75 0c             	pushl  0xc(%ebp)
  8009cb:	ff 75 08             	pushl  0x8(%ebp)
  8009ce:	e8 00 fb ff ff       	call   8004d3 <printnum>
  8009d3:	83 c4 20             	add    $0x20,%esp
			break;
  8009d6:	eb 46                	jmp    800a1e <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009d8:	83 ec 08             	sub    $0x8,%esp
  8009db:	ff 75 0c             	pushl  0xc(%ebp)
  8009de:	53                   	push   %ebx
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	ff d0                	call   *%eax
  8009e4:	83 c4 10             	add    $0x10,%esp
			break;
  8009e7:	eb 35                	jmp    800a1e <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009e9:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8009f0:	eb 2c                	jmp    800a1e <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009f2:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8009f9:	eb 23                	jmp    800a1e <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 0c             	pushl  0xc(%ebp)
  800a01:	6a 25                	push   $0x25
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
  800a08:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a0b:	ff 4d 10             	decl   0x10(%ebp)
  800a0e:	eb 03                	jmp    800a13 <vprintfmt+0x3c3>
  800a10:	ff 4d 10             	decl   0x10(%ebp)
  800a13:	8b 45 10             	mov    0x10(%ebp),%eax
  800a16:	48                   	dec    %eax
  800a17:	8a 00                	mov    (%eax),%al
  800a19:	3c 25                	cmp    $0x25,%al
  800a1b:	75 f3                	jne    800a10 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a1d:	90                   	nop
		}
	}
  800a1e:	e9 35 fc ff ff       	jmp    800658 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a23:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a24:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a27:	5b                   	pop    %ebx
  800a28:	5e                   	pop    %esi
  800a29:	5d                   	pop    %ebp
  800a2a:	c3                   	ret    

00800a2b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a31:	8d 45 10             	lea    0x10(%ebp),%eax
  800a34:	83 c0 04             	add    $0x4,%eax
  800a37:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3d:	ff 75 f4             	pushl  -0xc(%ebp)
  800a40:	50                   	push   %eax
  800a41:	ff 75 0c             	pushl  0xc(%ebp)
  800a44:	ff 75 08             	pushl  0x8(%ebp)
  800a47:	e8 04 fc ff ff       	call   800650 <vprintfmt>
  800a4c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a4f:	90                   	nop
  800a50:	c9                   	leave  
  800a51:	c3                   	ret    

00800a52 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a52:	55                   	push   %ebp
  800a53:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a58:	8b 40 08             	mov    0x8(%eax),%eax
  800a5b:	8d 50 01             	lea    0x1(%eax),%edx
  800a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a61:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a67:	8b 10                	mov    (%eax),%edx
  800a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6c:	8b 40 04             	mov    0x4(%eax),%eax
  800a6f:	39 c2                	cmp    %eax,%edx
  800a71:	73 12                	jae    800a85 <sprintputch+0x33>
		*b->buf++ = ch;
  800a73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a76:	8b 00                	mov    (%eax),%eax
  800a78:	8d 48 01             	lea    0x1(%eax),%ecx
  800a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7e:	89 0a                	mov    %ecx,(%edx)
  800a80:	8b 55 08             	mov    0x8(%ebp),%edx
  800a83:	88 10                	mov    %dl,(%eax)
}
  800a85:	90                   	nop
  800a86:	5d                   	pop    %ebp
  800a87:	c3                   	ret    

00800a88 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a97:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9d:	01 d0                	add    %edx,%eax
  800a9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800aa9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800aad:	74 06                	je     800ab5 <vsnprintf+0x2d>
  800aaf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ab3:	7f 07                	jg     800abc <vsnprintf+0x34>
		return -E_INVAL;
  800ab5:	b8 03 00 00 00       	mov    $0x3,%eax
  800aba:	eb 20                	jmp    800adc <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800abc:	ff 75 14             	pushl  0x14(%ebp)
  800abf:	ff 75 10             	pushl  0x10(%ebp)
  800ac2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ac5:	50                   	push   %eax
  800ac6:	68 52 0a 80 00       	push   $0x800a52
  800acb:	e8 80 fb ff ff       	call   800650 <vprintfmt>
  800ad0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ad3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ad6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800adc:	c9                   	leave  
  800add:	c3                   	ret    

00800ade <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ade:	55                   	push   %ebp
  800adf:	89 e5                	mov    %esp,%ebp
  800ae1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ae4:	8d 45 10             	lea    0x10(%ebp),%eax
  800ae7:	83 c0 04             	add    $0x4,%eax
  800aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800aed:	8b 45 10             	mov    0x10(%ebp),%eax
  800af0:	ff 75 f4             	pushl  -0xc(%ebp)
  800af3:	50                   	push   %eax
  800af4:	ff 75 0c             	pushl  0xc(%ebp)
  800af7:	ff 75 08             	pushl  0x8(%ebp)
  800afa:	e8 89 ff ff ff       	call   800a88 <vsnprintf>
  800aff:	83 c4 10             	add    $0x10,%esp
  800b02:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b08:	c9                   	leave  
  800b09:	c3                   	ret    

00800b0a <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b10:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b17:	eb 06                	jmp    800b1f <strlen+0x15>
		n++;
  800b19:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b1c:	ff 45 08             	incl   0x8(%ebp)
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	8a 00                	mov    (%eax),%al
  800b24:	84 c0                	test   %al,%al
  800b26:	75 f1                	jne    800b19 <strlen+0xf>
		n++;
	return n;
  800b28:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b2b:	c9                   	leave  
  800b2c:	c3                   	ret    

00800b2d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b2d:	55                   	push   %ebp
  800b2e:	89 e5                	mov    %esp,%ebp
  800b30:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b3a:	eb 09                	jmp    800b45 <strnlen+0x18>
		n++;
  800b3c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b3f:	ff 45 08             	incl   0x8(%ebp)
  800b42:	ff 4d 0c             	decl   0xc(%ebp)
  800b45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b49:	74 09                	je     800b54 <strnlen+0x27>
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	8a 00                	mov    (%eax),%al
  800b50:	84 c0                	test   %al,%al
  800b52:	75 e8                	jne    800b3c <strnlen+0xf>
		n++;
	return n;
  800b54:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b57:	c9                   	leave  
  800b58:	c3                   	ret    

00800b59 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b65:	90                   	nop
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	8d 50 01             	lea    0x1(%eax),%edx
  800b6c:	89 55 08             	mov    %edx,0x8(%ebp)
  800b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b72:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b75:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b78:	8a 12                	mov    (%edx),%dl
  800b7a:	88 10                	mov    %dl,(%eax)
  800b7c:	8a 00                	mov    (%eax),%al
  800b7e:	84 c0                	test   %al,%al
  800b80:	75 e4                	jne    800b66 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b82:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b85:	c9                   	leave  
  800b86:	c3                   	ret    

00800b87 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b93:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b9a:	eb 1f                	jmp    800bbb <strncpy+0x34>
		*dst++ = *src;
  800b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9f:	8d 50 01             	lea    0x1(%eax),%edx
  800ba2:	89 55 08             	mov    %edx,0x8(%ebp)
  800ba5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba8:	8a 12                	mov    (%edx),%dl
  800baa:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800bac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baf:	8a 00                	mov    (%eax),%al
  800bb1:	84 c0                	test   %al,%al
  800bb3:	74 03                	je     800bb8 <strncpy+0x31>
			src++;
  800bb5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bb8:	ff 45 fc             	incl   -0x4(%ebp)
  800bbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bbe:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bc1:	72 d9                	jb     800b9c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800bc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bc6:	c9                   	leave  
  800bc7:	c3                   	ret    

00800bc8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bd8:	74 30                	je     800c0a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bda:	eb 16                	jmp    800bf2 <strlcpy+0x2a>
			*dst++ = *src++;
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	8d 50 01             	lea    0x1(%eax),%edx
  800be2:	89 55 08             	mov    %edx,0x8(%ebp)
  800be5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800beb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bee:	8a 12                	mov    (%edx),%dl
  800bf0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bf2:	ff 4d 10             	decl   0x10(%ebp)
  800bf5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bf9:	74 09                	je     800c04 <strlcpy+0x3c>
  800bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfe:	8a 00                	mov    (%eax),%al
  800c00:	84 c0                	test   %al,%al
  800c02:	75 d8                	jne    800bdc <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
  800c07:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c10:	29 c2                	sub    %eax,%edx
  800c12:	89 d0                	mov    %edx,%eax
}
  800c14:	c9                   	leave  
  800c15:	c3                   	ret    

00800c16 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c19:	eb 06                	jmp    800c21 <strcmp+0xb>
		p++, q++;
  800c1b:	ff 45 08             	incl   0x8(%ebp)
  800c1e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	8a 00                	mov    (%eax),%al
  800c26:	84 c0                	test   %al,%al
  800c28:	74 0e                	je     800c38 <strcmp+0x22>
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	8a 10                	mov    (%eax),%dl
  800c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c32:	8a 00                	mov    (%eax),%al
  800c34:	38 c2                	cmp    %al,%dl
  800c36:	74 e3                	je     800c1b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	8a 00                	mov    (%eax),%al
  800c3d:	0f b6 d0             	movzbl %al,%edx
  800c40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c43:	8a 00                	mov    (%eax),%al
  800c45:	0f b6 c0             	movzbl %al,%eax
  800c48:	29 c2                	sub    %eax,%edx
  800c4a:	89 d0                	mov    %edx,%eax
}
  800c4c:	5d                   	pop    %ebp
  800c4d:	c3                   	ret    

00800c4e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c51:	eb 09                	jmp    800c5c <strncmp+0xe>
		n--, p++, q++;
  800c53:	ff 4d 10             	decl   0x10(%ebp)
  800c56:	ff 45 08             	incl   0x8(%ebp)
  800c59:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c5c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c60:	74 17                	je     800c79 <strncmp+0x2b>
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	8a 00                	mov    (%eax),%al
  800c67:	84 c0                	test   %al,%al
  800c69:	74 0e                	je     800c79 <strncmp+0x2b>
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	8a 10                	mov    (%eax),%dl
  800c70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c73:	8a 00                	mov    (%eax),%al
  800c75:	38 c2                	cmp    %al,%dl
  800c77:	74 da                	je     800c53 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c7d:	75 07                	jne    800c86 <strncmp+0x38>
		return 0;
  800c7f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c84:	eb 14                	jmp    800c9a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	8a 00                	mov    (%eax),%al
  800c8b:	0f b6 d0             	movzbl %al,%edx
  800c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	0f b6 c0             	movzbl %al,%eax
  800c96:	29 c2                	sub    %eax,%edx
  800c98:	89 d0                	mov    %edx,%eax
}
  800c9a:	5d                   	pop    %ebp
  800c9b:	c3                   	ret    

00800c9c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 04             	sub    $0x4,%esp
  800ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ca8:	eb 12                	jmp    800cbc <strchr+0x20>
		if (*s == c)
  800caa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cad:	8a 00                	mov    (%eax),%al
  800caf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cb2:	75 05                	jne    800cb9 <strchr+0x1d>
			return (char *) s;
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	eb 11                	jmp    800cca <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cb9:	ff 45 08             	incl   0x8(%ebp)
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	8a 00                	mov    (%eax),%al
  800cc1:	84 c0                	test   %al,%al
  800cc3:	75 e5                	jne    800caa <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cca:	c9                   	leave  
  800ccb:	c3                   	ret    

00800ccc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	83 ec 04             	sub    $0x4,%esp
  800cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cd8:	eb 0d                	jmp    800ce7 <strfind+0x1b>
		if (*s == c)
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ce2:	74 0e                	je     800cf2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ce4:	ff 45 08             	incl   0x8(%ebp)
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	8a 00                	mov    (%eax),%al
  800cec:	84 c0                	test   %al,%al
  800cee:	75 ea                	jne    800cda <strfind+0xe>
  800cf0:	eb 01                	jmp    800cf3 <strfind+0x27>
		if (*s == c)
			break;
  800cf2:	90                   	nop
	return (char *) s;
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf6:	c9                   	leave  
  800cf7:	c3                   	ret    

00800cf8 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d04:	8b 45 10             	mov    0x10(%ebp),%eax
  800d07:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d0a:	eb 0e                	jmp    800d1a <memset+0x22>
		*p++ = c;
  800d0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0f:	8d 50 01             	lea    0x1(%eax),%edx
  800d12:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d18:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d1a:	ff 4d f8             	decl   -0x8(%ebp)
  800d1d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d21:	79 e9                	jns    800d0c <memset+0x14>
		*p++ = c;

	return v;
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d26:	c9                   	leave  
  800d27:	c3                   	ret    

00800d28 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d3a:	eb 16                	jmp    800d52 <memcpy+0x2a>
		*d++ = *s++;
  800d3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d3f:	8d 50 01             	lea    0x1(%eax),%edx
  800d42:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d45:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d48:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d4b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d4e:	8a 12                	mov    (%edx),%dl
  800d50:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d52:	8b 45 10             	mov    0x10(%ebp),%eax
  800d55:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d58:	89 55 10             	mov    %edx,0x10(%ebp)
  800d5b:	85 c0                	test   %eax,%eax
  800d5d:	75 dd                	jne    800d3c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d62:	c9                   	leave  
  800d63:	c3                   	ret    

00800d64 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d79:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d7c:	73 50                	jae    800dce <memmove+0x6a>
  800d7e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d81:	8b 45 10             	mov    0x10(%ebp),%eax
  800d84:	01 d0                	add    %edx,%eax
  800d86:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d89:	76 43                	jbe    800dce <memmove+0x6a>
		s += n;
  800d8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d91:	8b 45 10             	mov    0x10(%ebp),%eax
  800d94:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d97:	eb 10                	jmp    800da9 <memmove+0x45>
			*--d = *--s;
  800d99:	ff 4d f8             	decl   -0x8(%ebp)
  800d9c:	ff 4d fc             	decl   -0x4(%ebp)
  800d9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da2:	8a 10                	mov    (%eax),%dl
  800da4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800da9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dac:	8d 50 ff             	lea    -0x1(%eax),%edx
  800daf:	89 55 10             	mov    %edx,0x10(%ebp)
  800db2:	85 c0                	test   %eax,%eax
  800db4:	75 e3                	jne    800d99 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800db6:	eb 23                	jmp    800ddb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800db8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dbb:	8d 50 01             	lea    0x1(%eax),%edx
  800dbe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dc1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dc4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dc7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dca:	8a 12                	mov    (%edx),%dl
  800dcc:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dce:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd4:	89 55 10             	mov    %edx,0x10(%ebp)
  800dd7:	85 c0                	test   %eax,%eax
  800dd9:	75 dd                	jne    800db8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dde:	c9                   	leave  
  800ddf:	c3                   	ret    

00800de0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800def:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800df2:	eb 2a                	jmp    800e1e <memcmp+0x3e>
		if (*s1 != *s2)
  800df4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df7:	8a 10                	mov    (%eax),%dl
  800df9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dfc:	8a 00                	mov    (%eax),%al
  800dfe:	38 c2                	cmp    %al,%dl
  800e00:	74 16                	je     800e18 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e05:	8a 00                	mov    (%eax),%al
  800e07:	0f b6 d0             	movzbl %al,%edx
  800e0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e0d:	8a 00                	mov    (%eax),%al
  800e0f:	0f b6 c0             	movzbl %al,%eax
  800e12:	29 c2                	sub    %eax,%edx
  800e14:	89 d0                	mov    %edx,%eax
  800e16:	eb 18                	jmp    800e30 <memcmp+0x50>
		s1++, s2++;
  800e18:	ff 45 fc             	incl   -0x4(%ebp)
  800e1b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e21:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e24:	89 55 10             	mov    %edx,0x10(%ebp)
  800e27:	85 c0                	test   %eax,%eax
  800e29:	75 c9                	jne    800df4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e30:	c9                   	leave  
  800e31:	c3                   	ret    

00800e32 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
  800e35:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e38:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3e:	01 d0                	add    %edx,%eax
  800e40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e43:	eb 15                	jmp    800e5a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	8a 00                	mov    (%eax),%al
  800e4a:	0f b6 d0             	movzbl %al,%edx
  800e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e50:	0f b6 c0             	movzbl %al,%eax
  800e53:	39 c2                	cmp    %eax,%edx
  800e55:	74 0d                	je     800e64 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e57:	ff 45 08             	incl   0x8(%ebp)
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e60:	72 e3                	jb     800e45 <memfind+0x13>
  800e62:	eb 01                	jmp    800e65 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e64:	90                   	nop
	return (void *) s;
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e68:	c9                   	leave  
  800e69:	c3                   	ret    

00800e6a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e70:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e77:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e7e:	eb 03                	jmp    800e83 <strtol+0x19>
		s++;
  800e80:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	8a 00                	mov    (%eax),%al
  800e88:	3c 20                	cmp    $0x20,%al
  800e8a:	74 f4                	je     800e80 <strtol+0x16>
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	8a 00                	mov    (%eax),%al
  800e91:	3c 09                	cmp    $0x9,%al
  800e93:	74 eb                	je     800e80 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	8a 00                	mov    (%eax),%al
  800e9a:	3c 2b                	cmp    $0x2b,%al
  800e9c:	75 05                	jne    800ea3 <strtol+0x39>
		s++;
  800e9e:	ff 45 08             	incl   0x8(%ebp)
  800ea1:	eb 13                	jmp    800eb6 <strtol+0x4c>
	else if (*s == '-')
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	3c 2d                	cmp    $0x2d,%al
  800eaa:	75 0a                	jne    800eb6 <strtol+0x4c>
		s++, neg = 1;
  800eac:	ff 45 08             	incl   0x8(%ebp)
  800eaf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eba:	74 06                	je     800ec2 <strtol+0x58>
  800ebc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ec0:	75 20                	jne    800ee2 <strtol+0x78>
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	8a 00                	mov    (%eax),%al
  800ec7:	3c 30                	cmp    $0x30,%al
  800ec9:	75 17                	jne    800ee2 <strtol+0x78>
  800ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ece:	40                   	inc    %eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	3c 78                	cmp    $0x78,%al
  800ed3:	75 0d                	jne    800ee2 <strtol+0x78>
		s += 2, base = 16;
  800ed5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ed9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ee0:	eb 28                	jmp    800f0a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ee2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee6:	75 15                	jne    800efd <strtol+0x93>
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	3c 30                	cmp    $0x30,%al
  800eef:	75 0c                	jne    800efd <strtol+0x93>
		s++, base = 8;
  800ef1:	ff 45 08             	incl   0x8(%ebp)
  800ef4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800efb:	eb 0d                	jmp    800f0a <strtol+0xa0>
	else if (base == 0)
  800efd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f01:	75 07                	jne    800f0a <strtol+0xa0>
		base = 10;
  800f03:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	3c 2f                	cmp    $0x2f,%al
  800f11:	7e 19                	jle    800f2c <strtol+0xc2>
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	3c 39                	cmp    $0x39,%al
  800f1a:	7f 10                	jg     800f2c <strtol+0xc2>
			dig = *s - '0';
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8a 00                	mov    (%eax),%al
  800f21:	0f be c0             	movsbl %al,%eax
  800f24:	83 e8 30             	sub    $0x30,%eax
  800f27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f2a:	eb 42                	jmp    800f6e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	3c 60                	cmp    $0x60,%al
  800f33:	7e 19                	jle    800f4e <strtol+0xe4>
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	3c 7a                	cmp    $0x7a,%al
  800f3c:	7f 10                	jg     800f4e <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	8a 00                	mov    (%eax),%al
  800f43:	0f be c0             	movsbl %al,%eax
  800f46:	83 e8 57             	sub    $0x57,%eax
  800f49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f4c:	eb 20                	jmp    800f6e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	3c 40                	cmp    $0x40,%al
  800f55:	7e 39                	jle    800f90 <strtol+0x126>
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	3c 5a                	cmp    $0x5a,%al
  800f5e:	7f 30                	jg     800f90 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	8a 00                	mov    (%eax),%al
  800f65:	0f be c0             	movsbl %al,%eax
  800f68:	83 e8 37             	sub    $0x37,%eax
  800f6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f71:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f74:	7d 19                	jge    800f8f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f76:	ff 45 08             	incl   0x8(%ebp)
  800f79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f80:	89 c2                	mov    %eax,%edx
  800f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f85:	01 d0                	add    %edx,%eax
  800f87:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f8a:	e9 7b ff ff ff       	jmp    800f0a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f8f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f90:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f94:	74 08                	je     800f9e <strtol+0x134>
		*endptr = (char *) s;
  800f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f99:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fa2:	74 07                	je     800fab <strtol+0x141>
  800fa4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa7:	f7 d8                	neg    %eax
  800fa9:	eb 03                	jmp    800fae <strtol+0x144>
  800fab:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fae:	c9                   	leave  
  800faf:	c3                   	ret    

00800fb0 <ltostr>:

void
ltostr(long value, char *str)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fbd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fc4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fc8:	79 13                	jns    800fdd <ltostr+0x2d>
	{
		neg = 1;
  800fca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fd7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fda:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fe5:	99                   	cltd   
  800fe6:	f7 f9                	idiv   %ecx
  800fe8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800feb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fee:	8d 50 01             	lea    0x1(%eax),%edx
  800ff1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ff4:	89 c2                	mov    %eax,%edx
  800ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff9:	01 d0                	add    %edx,%eax
  800ffb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ffe:	83 c2 30             	add    $0x30,%edx
  801001:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801003:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801006:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80100b:	f7 e9                	imul   %ecx
  80100d:	c1 fa 02             	sar    $0x2,%edx
  801010:	89 c8                	mov    %ecx,%eax
  801012:	c1 f8 1f             	sar    $0x1f,%eax
  801015:	29 c2                	sub    %eax,%edx
  801017:	89 d0                	mov    %edx,%eax
  801019:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80101c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801020:	75 bb                	jne    800fdd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801022:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801029:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102c:	48                   	dec    %eax
  80102d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801030:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801034:	74 3d                	je     801073 <ltostr+0xc3>
		start = 1 ;
  801036:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80103d:	eb 34                	jmp    801073 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80103f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801042:	8b 45 0c             	mov    0xc(%ebp),%eax
  801045:	01 d0                	add    %edx,%eax
  801047:	8a 00                	mov    (%eax),%al
  801049:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80104c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80104f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801052:	01 c2                	add    %eax,%edx
  801054:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801057:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105a:	01 c8                	add    %ecx,%eax
  80105c:	8a 00                	mov    (%eax),%al
  80105e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801060:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801063:	8b 45 0c             	mov    0xc(%ebp),%eax
  801066:	01 c2                	add    %eax,%edx
  801068:	8a 45 eb             	mov    -0x15(%ebp),%al
  80106b:	88 02                	mov    %al,(%edx)
		start++ ;
  80106d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801070:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801076:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801079:	7c c4                	jl     80103f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80107b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80107e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801081:	01 d0                	add    %edx,%eax
  801083:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801086:	90                   	nop
  801087:	c9                   	leave  
  801088:	c3                   	ret    

00801089 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801089:	55                   	push   %ebp
  80108a:	89 e5                	mov    %esp,%ebp
  80108c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80108f:	ff 75 08             	pushl  0x8(%ebp)
  801092:	e8 73 fa ff ff       	call   800b0a <strlen>
  801097:	83 c4 04             	add    $0x4,%esp
  80109a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80109d:	ff 75 0c             	pushl  0xc(%ebp)
  8010a0:	e8 65 fa ff ff       	call   800b0a <strlen>
  8010a5:	83 c4 04             	add    $0x4,%esp
  8010a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010b9:	eb 17                	jmp    8010d2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010be:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c1:	01 c2                	add    %eax,%edx
  8010c3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	01 c8                	add    %ecx,%eax
  8010cb:	8a 00                	mov    (%eax),%al
  8010cd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010cf:	ff 45 fc             	incl   -0x4(%ebp)
  8010d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010d8:	7c e1                	jl     8010bb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010e8:	eb 1f                	jmp    801109 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ed:	8d 50 01             	lea    0x1(%eax),%edx
  8010f0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010f3:	89 c2                	mov    %eax,%edx
  8010f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f8:	01 c2                	add    %eax,%edx
  8010fa:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801100:	01 c8                	add    %ecx,%eax
  801102:	8a 00                	mov    (%eax),%al
  801104:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801106:	ff 45 f8             	incl   -0x8(%ebp)
  801109:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80110f:	7c d9                	jl     8010ea <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801111:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801114:	8b 45 10             	mov    0x10(%ebp),%eax
  801117:	01 d0                	add    %edx,%eax
  801119:	c6 00 00             	movb   $0x0,(%eax)
}
  80111c:	90                   	nop
  80111d:	c9                   	leave  
  80111e:	c3                   	ret    

0080111f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801122:	8b 45 14             	mov    0x14(%ebp),%eax
  801125:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80112b:	8b 45 14             	mov    0x14(%ebp),%eax
  80112e:	8b 00                	mov    (%eax),%eax
  801130:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801137:	8b 45 10             	mov    0x10(%ebp),%eax
  80113a:	01 d0                	add    %edx,%eax
  80113c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801142:	eb 0c                	jmp    801150 <strsplit+0x31>
			*string++ = 0;
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	8d 50 01             	lea    0x1(%eax),%edx
  80114a:	89 55 08             	mov    %edx,0x8(%ebp)
  80114d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801150:	8b 45 08             	mov    0x8(%ebp),%eax
  801153:	8a 00                	mov    (%eax),%al
  801155:	84 c0                	test   %al,%al
  801157:	74 18                	je     801171 <strsplit+0x52>
  801159:	8b 45 08             	mov    0x8(%ebp),%eax
  80115c:	8a 00                	mov    (%eax),%al
  80115e:	0f be c0             	movsbl %al,%eax
  801161:	50                   	push   %eax
  801162:	ff 75 0c             	pushl  0xc(%ebp)
  801165:	e8 32 fb ff ff       	call   800c9c <strchr>
  80116a:	83 c4 08             	add    $0x8,%esp
  80116d:	85 c0                	test   %eax,%eax
  80116f:	75 d3                	jne    801144 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	8a 00                	mov    (%eax),%al
  801176:	84 c0                	test   %al,%al
  801178:	74 5a                	je     8011d4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80117a:	8b 45 14             	mov    0x14(%ebp),%eax
  80117d:	8b 00                	mov    (%eax),%eax
  80117f:	83 f8 0f             	cmp    $0xf,%eax
  801182:	75 07                	jne    80118b <strsplit+0x6c>
		{
			return 0;
  801184:	b8 00 00 00 00       	mov    $0x0,%eax
  801189:	eb 66                	jmp    8011f1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80118b:	8b 45 14             	mov    0x14(%ebp),%eax
  80118e:	8b 00                	mov    (%eax),%eax
  801190:	8d 48 01             	lea    0x1(%eax),%ecx
  801193:	8b 55 14             	mov    0x14(%ebp),%edx
  801196:	89 0a                	mov    %ecx,(%edx)
  801198:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80119f:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a2:	01 c2                	add    %eax,%edx
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011a9:	eb 03                	jmp    8011ae <strsplit+0x8f>
			string++;
  8011ab:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b1:	8a 00                	mov    (%eax),%al
  8011b3:	84 c0                	test   %al,%al
  8011b5:	74 8b                	je     801142 <strsplit+0x23>
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	0f be c0             	movsbl %al,%eax
  8011bf:	50                   	push   %eax
  8011c0:	ff 75 0c             	pushl  0xc(%ebp)
  8011c3:	e8 d4 fa ff ff       	call   800c9c <strchr>
  8011c8:	83 c4 08             	add    $0x8,%esp
  8011cb:	85 c0                	test   %eax,%eax
  8011cd:	74 dc                	je     8011ab <strsplit+0x8c>
			string++;
	}
  8011cf:	e9 6e ff ff ff       	jmp    801142 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011d4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d8:	8b 00                	mov    (%eax),%eax
  8011da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	01 d0                	add    %edx,%eax
  8011e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011ec:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011f1:	c9                   	leave  
  8011f2:	c3                   	ret    

008011f3 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8011f9:	83 ec 04             	sub    $0x4,%esp
  8011fc:	68 08 21 80 00       	push   $0x802108
  801201:	68 3f 01 00 00       	push   $0x13f
  801206:	68 2a 21 80 00       	push   $0x80212a
  80120b:	e8 a9 ef ff ff       	call   8001b9 <_panic>

00801210 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
  801213:	57                   	push   %edi
  801214:	56                   	push   %esi
  801215:	53                   	push   %ebx
  801216:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80121f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801222:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801225:	8b 7d 18             	mov    0x18(%ebp),%edi
  801228:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80122b:	cd 30                	int    $0x30
  80122d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801230:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801233:	83 c4 10             	add    $0x10,%esp
  801236:	5b                   	pop    %ebx
  801237:	5e                   	pop    %esi
  801238:	5f                   	pop    %edi
  801239:	5d                   	pop    %ebp
  80123a:	c3                   	ret    

0080123b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	83 ec 04             	sub    $0x4,%esp
  801241:	8b 45 10             	mov    0x10(%ebp),%eax
  801244:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801247:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	6a 00                	push   $0x0
  801250:	6a 00                	push   $0x0
  801252:	52                   	push   %edx
  801253:	ff 75 0c             	pushl  0xc(%ebp)
  801256:	50                   	push   %eax
  801257:	6a 00                	push   $0x0
  801259:	e8 b2 ff ff ff       	call   801210 <syscall>
  80125e:	83 c4 18             	add    $0x18,%esp
}
  801261:	90                   	nop
  801262:	c9                   	leave  
  801263:	c3                   	ret    

00801264 <sys_cgetc>:

int
sys_cgetc(void)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801267:	6a 00                	push   $0x0
  801269:	6a 00                	push   $0x0
  80126b:	6a 00                	push   $0x0
  80126d:	6a 00                	push   $0x0
  80126f:	6a 00                	push   $0x0
  801271:	6a 02                	push   $0x2
  801273:	e8 98 ff ff ff       	call   801210 <syscall>
  801278:	83 c4 18             	add    $0x18,%esp
}
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    

0080127d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801280:	6a 00                	push   $0x0
  801282:	6a 00                	push   $0x0
  801284:	6a 00                	push   $0x0
  801286:	6a 00                	push   $0x0
  801288:	6a 00                	push   $0x0
  80128a:	6a 03                	push   $0x3
  80128c:	e8 7f ff ff ff       	call   801210 <syscall>
  801291:	83 c4 18             	add    $0x18,%esp
}
  801294:	90                   	nop
  801295:	c9                   	leave  
  801296:	c3                   	ret    

00801297 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80129a:	6a 00                	push   $0x0
  80129c:	6a 00                	push   $0x0
  80129e:	6a 00                	push   $0x0
  8012a0:	6a 00                	push   $0x0
  8012a2:	6a 00                	push   $0x0
  8012a4:	6a 04                	push   $0x4
  8012a6:	e8 65 ff ff ff       	call   801210 <syscall>
  8012ab:	83 c4 18             	add    $0x18,%esp
}
  8012ae:	90                   	nop
  8012af:	c9                   	leave  
  8012b0:	c3                   	ret    

008012b1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012b1:	55                   	push   %ebp
  8012b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	6a 00                	push   $0x0
  8012bc:	6a 00                	push   $0x0
  8012be:	6a 00                	push   $0x0
  8012c0:	52                   	push   %edx
  8012c1:	50                   	push   %eax
  8012c2:	6a 08                	push   $0x8
  8012c4:	e8 47 ff ff ff       	call   801210 <syscall>
  8012c9:	83 c4 18             	add    $0x18,%esp
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	56                   	push   %esi
  8012d2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012d3:	8b 75 18             	mov    0x18(%ebp),%esi
  8012d6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	56                   	push   %esi
  8012e3:	53                   	push   %ebx
  8012e4:	51                   	push   %ecx
  8012e5:	52                   	push   %edx
  8012e6:	50                   	push   %eax
  8012e7:	6a 09                	push   $0x9
  8012e9:	e8 22 ff ff ff       	call   801210 <syscall>
  8012ee:	83 c4 18             	add    $0x18,%esp
}
  8012f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012f4:	5b                   	pop    %ebx
  8012f5:	5e                   	pop    %esi
  8012f6:	5d                   	pop    %ebp
  8012f7:	c3                   	ret    

008012f8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801301:	6a 00                	push   $0x0
  801303:	6a 00                	push   $0x0
  801305:	6a 00                	push   $0x0
  801307:	52                   	push   %edx
  801308:	50                   	push   %eax
  801309:	6a 0a                	push   $0xa
  80130b:	e8 00 ff ff ff       	call   801210 <syscall>
  801310:	83 c4 18             	add    $0x18,%esp
}
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801318:	6a 00                	push   $0x0
  80131a:	6a 00                	push   $0x0
  80131c:	6a 00                	push   $0x0
  80131e:	ff 75 0c             	pushl  0xc(%ebp)
  801321:	ff 75 08             	pushl  0x8(%ebp)
  801324:	6a 0b                	push   $0xb
  801326:	e8 e5 fe ff ff       	call   801210 <syscall>
  80132b:	83 c4 18             	add    $0x18,%esp
}
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    

00801330 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801333:	6a 00                	push   $0x0
  801335:	6a 00                	push   $0x0
  801337:	6a 00                	push   $0x0
  801339:	6a 00                	push   $0x0
  80133b:	6a 00                	push   $0x0
  80133d:	6a 0c                	push   $0xc
  80133f:	e8 cc fe ff ff       	call   801210 <syscall>
  801344:	83 c4 18             	add    $0x18,%esp
}
  801347:	c9                   	leave  
  801348:	c3                   	ret    

00801349 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80134c:	6a 00                	push   $0x0
  80134e:	6a 00                	push   $0x0
  801350:	6a 00                	push   $0x0
  801352:	6a 00                	push   $0x0
  801354:	6a 00                	push   $0x0
  801356:	6a 0d                	push   $0xd
  801358:	e8 b3 fe ff ff       	call   801210 <syscall>
  80135d:	83 c4 18             	add    $0x18,%esp
}
  801360:	c9                   	leave  
  801361:	c3                   	ret    

00801362 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801365:	6a 00                	push   $0x0
  801367:	6a 00                	push   $0x0
  801369:	6a 00                	push   $0x0
  80136b:	6a 00                	push   $0x0
  80136d:	6a 00                	push   $0x0
  80136f:	6a 0e                	push   $0xe
  801371:	e8 9a fe ff ff       	call   801210 <syscall>
  801376:	83 c4 18             	add    $0x18,%esp
}
  801379:	c9                   	leave  
  80137a:	c3                   	ret    

0080137b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80137e:	6a 00                	push   $0x0
  801380:	6a 00                	push   $0x0
  801382:	6a 00                	push   $0x0
  801384:	6a 00                	push   $0x0
  801386:	6a 00                	push   $0x0
  801388:	6a 0f                	push   $0xf
  80138a:	e8 81 fe ff ff       	call   801210 <syscall>
  80138f:	83 c4 18             	add    $0x18,%esp
}
  801392:	c9                   	leave  
  801393:	c3                   	ret    

00801394 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801397:	6a 00                	push   $0x0
  801399:	6a 00                	push   $0x0
  80139b:	6a 00                	push   $0x0
  80139d:	6a 00                	push   $0x0
  80139f:	ff 75 08             	pushl  0x8(%ebp)
  8013a2:	6a 10                	push   $0x10
  8013a4:	e8 67 fe ff ff       	call   801210 <syscall>
  8013a9:	83 c4 18             	add    $0x18,%esp
}
  8013ac:	c9                   	leave  
  8013ad:	c3                   	ret    

008013ae <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 11                	push   $0x11
  8013bd:	e8 4e fe ff ff       	call   801210 <syscall>
  8013c2:	83 c4 18             	add    $0x18,%esp
}
  8013c5:	90                   	nop
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <sys_cputc>:

void
sys_cputc(const char c)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
  8013cb:	83 ec 04             	sub    $0x4,%esp
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013d4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	50                   	push   %eax
  8013e1:	6a 01                	push   $0x1
  8013e3:	e8 28 fe ff ff       	call   801210 <syscall>
  8013e8:	83 c4 18             	add    $0x18,%esp
}
  8013eb:	90                   	nop
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    

008013ee <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 14                	push   $0x14
  8013fd:	e8 0e fe ff ff       	call   801210 <syscall>
  801402:	83 c4 18             	add    $0x18,%esp
}
  801405:	90                   	nop
  801406:	c9                   	leave  
  801407:	c3                   	ret    

00801408 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	83 ec 04             	sub    $0x4,%esp
  80140e:	8b 45 10             	mov    0x10(%ebp),%eax
  801411:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801414:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801417:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	6a 00                	push   $0x0
  801420:	51                   	push   %ecx
  801421:	52                   	push   %edx
  801422:	ff 75 0c             	pushl  0xc(%ebp)
  801425:	50                   	push   %eax
  801426:	6a 15                	push   $0x15
  801428:	e8 e3 fd ff ff       	call   801210 <syscall>
  80142d:	83 c4 18             	add    $0x18,%esp
}
  801430:	c9                   	leave  
  801431:	c3                   	ret    

00801432 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801435:	8b 55 0c             	mov    0xc(%ebp),%edx
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	52                   	push   %edx
  801442:	50                   	push   %eax
  801443:	6a 16                	push   $0x16
  801445:	e8 c6 fd ff ff       	call   801210 <syscall>
  80144a:	83 c4 18             	add    $0x18,%esp
}
  80144d:	c9                   	leave  
  80144e:	c3                   	ret    

0080144f <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801452:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801455:	8b 55 0c             	mov    0xc(%ebp),%edx
  801458:	8b 45 08             	mov    0x8(%ebp),%eax
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	51                   	push   %ecx
  801460:	52                   	push   %edx
  801461:	50                   	push   %eax
  801462:	6a 17                	push   $0x17
  801464:	e8 a7 fd ff ff       	call   801210 <syscall>
  801469:	83 c4 18             	add    $0x18,%esp
}
  80146c:	c9                   	leave  
  80146d:	c3                   	ret    

0080146e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801471:	8b 55 0c             	mov    0xc(%ebp),%edx
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	52                   	push   %edx
  80147e:	50                   	push   %eax
  80147f:	6a 18                	push   $0x18
  801481:	e8 8a fd ff ff       	call   801210 <syscall>
  801486:	83 c4 18             	add    $0x18,%esp
}
  801489:	c9                   	leave  
  80148a:	c3                   	ret    

0080148b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	6a 00                	push   $0x0
  801493:	ff 75 14             	pushl  0x14(%ebp)
  801496:	ff 75 10             	pushl  0x10(%ebp)
  801499:	ff 75 0c             	pushl  0xc(%ebp)
  80149c:	50                   	push   %eax
  80149d:	6a 19                	push   $0x19
  80149f:	e8 6c fd ff ff       	call   801210 <syscall>
  8014a4:	83 c4 18             	add    $0x18,%esp
}
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    

008014a9 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	50                   	push   %eax
  8014b8:	6a 1a                	push   $0x1a
  8014ba:	e8 51 fd ff ff       	call   801210 <syscall>
  8014bf:	83 c4 18             	add    $0x18,%esp
}
  8014c2:	90                   	nop
  8014c3:	c9                   	leave  
  8014c4:	c3                   	ret    

008014c5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 00                	push   $0x0
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 00                	push   $0x0
  8014d3:	50                   	push   %eax
  8014d4:	6a 1b                	push   $0x1b
  8014d6:	e8 35 fd ff ff       	call   801210 <syscall>
  8014db:	83 c4 18             	add    $0x18,%esp
}
  8014de:	c9                   	leave  
  8014df:	c3                   	ret    

008014e0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 05                	push   $0x5
  8014ef:	e8 1c fd ff ff       	call   801210 <syscall>
  8014f4:	83 c4 18             	add    $0x18,%esp
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	6a 06                	push   $0x6
  801508:	e8 03 fd ff ff       	call   801210 <syscall>
  80150d:	83 c4 18             	add    $0x18,%esp
}
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	6a 00                	push   $0x0
  80151f:	6a 07                	push   $0x7
  801521:	e8 ea fc ff ff       	call   801210 <syscall>
  801526:	83 c4 18             	add    $0x18,%esp
}
  801529:	c9                   	leave  
  80152a:	c3                   	ret    

0080152b <sys_exit_env>:


void sys_exit_env(void)
{
  80152b:	55                   	push   %ebp
  80152c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	6a 00                	push   $0x0
  801534:	6a 00                	push   $0x0
  801536:	6a 00                	push   $0x0
  801538:	6a 1c                	push   $0x1c
  80153a:	e8 d1 fc ff ff       	call   801210 <syscall>
  80153f:	83 c4 18             	add    $0x18,%esp
}
  801542:	90                   	nop
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80154b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80154e:	8d 50 04             	lea    0x4(%eax),%edx
  801551:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	52                   	push   %edx
  80155b:	50                   	push   %eax
  80155c:	6a 1d                	push   $0x1d
  80155e:	e8 ad fc ff ff       	call   801210 <syscall>
  801563:	83 c4 18             	add    $0x18,%esp
	return result;
  801566:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801569:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80156f:	89 01                	mov    %eax,(%ecx)
  801571:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	c9                   	leave  
  801578:	c2 04 00             	ret    $0x4

0080157b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	ff 75 10             	pushl  0x10(%ebp)
  801585:	ff 75 0c             	pushl  0xc(%ebp)
  801588:	ff 75 08             	pushl  0x8(%ebp)
  80158b:	6a 13                	push   $0x13
  80158d:	e8 7e fc ff ff       	call   801210 <syscall>
  801592:	83 c4 18             	add    $0x18,%esp
	return ;
  801595:	90                   	nop
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <sys_rcr2>:
uint32 sys_rcr2()
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 1e                	push   $0x1e
  8015a7:	e8 64 fc ff ff       	call   801210 <syscall>
  8015ac:	83 c4 18             	add    $0x18,%esp
}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	83 ec 04             	sub    $0x4,%esp
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015bd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	50                   	push   %eax
  8015ca:	6a 1f                	push   $0x1f
  8015cc:	e8 3f fc ff ff       	call   801210 <syscall>
  8015d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8015d4:	90                   	nop
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <rsttst>:
void rsttst()
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 21                	push   $0x21
  8015e6:	e8 25 fc ff ff       	call   801210 <syscall>
  8015eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8015ee:	90                   	nop
}
  8015ef:	c9                   	leave  
  8015f0:	c3                   	ret    

008015f1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
  8015f4:	83 ec 04             	sub    $0x4,%esp
  8015f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015fd:	8b 55 18             	mov    0x18(%ebp),%edx
  801600:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801604:	52                   	push   %edx
  801605:	50                   	push   %eax
  801606:	ff 75 10             	pushl  0x10(%ebp)
  801609:	ff 75 0c             	pushl  0xc(%ebp)
  80160c:	ff 75 08             	pushl  0x8(%ebp)
  80160f:	6a 20                	push   $0x20
  801611:	e8 fa fb ff ff       	call   801210 <syscall>
  801616:	83 c4 18             	add    $0x18,%esp
	return ;
  801619:	90                   	nop
}
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <chktst>:
void chktst(uint32 n)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	ff 75 08             	pushl  0x8(%ebp)
  80162a:	6a 22                	push   $0x22
  80162c:	e8 df fb ff ff       	call   801210 <syscall>
  801631:	83 c4 18             	add    $0x18,%esp
	return ;
  801634:	90                   	nop
}
  801635:	c9                   	leave  
  801636:	c3                   	ret    

00801637 <inctst>:

void inctst()
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 23                	push   $0x23
  801646:	e8 c5 fb ff ff       	call   801210 <syscall>
  80164b:	83 c4 18             	add    $0x18,%esp
	return ;
  80164e:	90                   	nop
}
  80164f:	c9                   	leave  
  801650:	c3                   	ret    

00801651 <gettst>:
uint32 gettst()
{
  801651:	55                   	push   %ebp
  801652:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 24                	push   $0x24
  801660:	e8 ab fb ff ff       	call   801210 <syscall>
  801665:	83 c4 18             	add    $0x18,%esp
}
  801668:	c9                   	leave  
  801669:	c3                   	ret    

0080166a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
  80166d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	6a 25                	push   $0x25
  80167c:	e8 8f fb ff ff       	call   801210 <syscall>
  801681:	83 c4 18             	add    $0x18,%esp
  801684:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801687:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80168b:	75 07                	jne    801694 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80168d:	b8 01 00 00 00       	mov    $0x1,%eax
  801692:	eb 05                	jmp    801699 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801694:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
  80169e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 25                	push   $0x25
  8016ad:	e8 5e fb ff ff       	call   801210 <syscall>
  8016b2:	83 c4 18             	add    $0x18,%esp
  8016b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016b8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016bc:	75 07                	jne    8016c5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016be:	b8 01 00 00 00       	mov    $0x1,%eax
  8016c3:	eb 05                	jmp    8016ca <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    

008016cc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 25                	push   $0x25
  8016de:	e8 2d fb ff ff       	call   801210 <syscall>
  8016e3:	83 c4 18             	add    $0x18,%esp
  8016e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016e9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016ed:	75 07                	jne    8016f6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016ef:	b8 01 00 00 00       	mov    $0x1,%eax
  8016f4:	eb 05                	jmp    8016fb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 25                	push   $0x25
  80170f:	e8 fc fa ff ff       	call   801210 <syscall>
  801714:	83 c4 18             	add    $0x18,%esp
  801717:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80171a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80171e:	75 07                	jne    801727 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801720:	b8 01 00 00 00       	mov    $0x1,%eax
  801725:	eb 05                	jmp    80172c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801727:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	ff 75 08             	pushl  0x8(%ebp)
  80173c:	6a 26                	push   $0x26
  80173e:	e8 cd fa ff ff       	call   801210 <syscall>
  801743:	83 c4 18             	add    $0x18,%esp
	return ;
  801746:	90                   	nop
}
  801747:	c9                   	leave  
  801748:	c3                   	ret    

00801749 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
  80174c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80174d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801750:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801753:	8b 55 0c             	mov    0xc(%ebp),%edx
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
  801759:	6a 00                	push   $0x0
  80175b:	53                   	push   %ebx
  80175c:	51                   	push   %ecx
  80175d:	52                   	push   %edx
  80175e:	50                   	push   %eax
  80175f:	6a 27                	push   $0x27
  801761:	e8 aa fa ff ff       	call   801210 <syscall>
  801766:	83 c4 18             	add    $0x18,%esp
}
  801769:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801771:	8b 55 0c             	mov    0xc(%ebp),%edx
  801774:	8b 45 08             	mov    0x8(%ebp),%eax
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	52                   	push   %edx
  80177e:	50                   	push   %eax
  80177f:	6a 28                	push   $0x28
  801781:	e8 8a fa ff ff       	call   801210 <syscall>
  801786:	83 c4 18             	add    $0x18,%esp
}
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80178e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801791:	8b 55 0c             	mov    0xc(%ebp),%edx
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	6a 00                	push   $0x0
  801799:	51                   	push   %ecx
  80179a:	ff 75 10             	pushl  0x10(%ebp)
  80179d:	52                   	push   %edx
  80179e:	50                   	push   %eax
  80179f:	6a 29                	push   $0x29
  8017a1:	e8 6a fa ff ff       	call   801210 <syscall>
  8017a6:	83 c4 18             	add    $0x18,%esp
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	ff 75 10             	pushl  0x10(%ebp)
  8017b5:	ff 75 0c             	pushl  0xc(%ebp)
  8017b8:	ff 75 08             	pushl  0x8(%ebp)
  8017bb:	6a 12                	push   $0x12
  8017bd:	e8 4e fa ff ff       	call   801210 <syscall>
  8017c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c5:	90                   	nop
}
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8017cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	52                   	push   %edx
  8017d8:	50                   	push   %eax
  8017d9:	6a 2a                	push   $0x2a
  8017db:	e8 30 fa ff ff       	call   801210 <syscall>
  8017e0:	83 c4 18             	add    $0x18,%esp
	return;
  8017e3:	90                   	nop
}
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8017ec:	83 ec 04             	sub    $0x4,%esp
  8017ef:	68 37 21 80 00       	push   $0x802137
  8017f4:	68 2e 01 00 00       	push   $0x12e
  8017f9:	68 4b 21 80 00       	push   $0x80214b
  8017fe:	e8 b6 e9 ff ff       	call   8001b9 <_panic>

00801803 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801809:	83 ec 04             	sub    $0x4,%esp
  80180c:	68 37 21 80 00       	push   $0x802137
  801811:	68 35 01 00 00       	push   $0x135
  801816:	68 4b 21 80 00       	push   $0x80214b
  80181b:	e8 99 e9 ff ff       	call   8001b9 <_panic>

00801820 <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801826:	83 ec 04             	sub    $0x4,%esp
  801829:	68 37 21 80 00       	push   $0x802137
  80182e:	68 3b 01 00 00       	push   $0x13b
  801833:	68 4b 21 80 00       	push   $0x80214b
  801838:	e8 7c e9 ff ff       	call   8001b9 <_panic>
  80183d:	66 90                	xchg   %ax,%ax
  80183f:	90                   	nop

00801840 <__udivdi3>:
  801840:	55                   	push   %ebp
  801841:	57                   	push   %edi
  801842:	56                   	push   %esi
  801843:	53                   	push   %ebx
  801844:	83 ec 1c             	sub    $0x1c,%esp
  801847:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80184b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80184f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801853:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801857:	89 ca                	mov    %ecx,%edx
  801859:	89 f8                	mov    %edi,%eax
  80185b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80185f:	85 f6                	test   %esi,%esi
  801861:	75 2d                	jne    801890 <__udivdi3+0x50>
  801863:	39 cf                	cmp    %ecx,%edi
  801865:	77 65                	ja     8018cc <__udivdi3+0x8c>
  801867:	89 fd                	mov    %edi,%ebp
  801869:	85 ff                	test   %edi,%edi
  80186b:	75 0b                	jne    801878 <__udivdi3+0x38>
  80186d:	b8 01 00 00 00       	mov    $0x1,%eax
  801872:	31 d2                	xor    %edx,%edx
  801874:	f7 f7                	div    %edi
  801876:	89 c5                	mov    %eax,%ebp
  801878:	31 d2                	xor    %edx,%edx
  80187a:	89 c8                	mov    %ecx,%eax
  80187c:	f7 f5                	div    %ebp
  80187e:	89 c1                	mov    %eax,%ecx
  801880:	89 d8                	mov    %ebx,%eax
  801882:	f7 f5                	div    %ebp
  801884:	89 cf                	mov    %ecx,%edi
  801886:	89 fa                	mov    %edi,%edx
  801888:	83 c4 1c             	add    $0x1c,%esp
  80188b:	5b                   	pop    %ebx
  80188c:	5e                   	pop    %esi
  80188d:	5f                   	pop    %edi
  80188e:	5d                   	pop    %ebp
  80188f:	c3                   	ret    
  801890:	39 ce                	cmp    %ecx,%esi
  801892:	77 28                	ja     8018bc <__udivdi3+0x7c>
  801894:	0f bd fe             	bsr    %esi,%edi
  801897:	83 f7 1f             	xor    $0x1f,%edi
  80189a:	75 40                	jne    8018dc <__udivdi3+0x9c>
  80189c:	39 ce                	cmp    %ecx,%esi
  80189e:	72 0a                	jb     8018aa <__udivdi3+0x6a>
  8018a0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8018a4:	0f 87 9e 00 00 00    	ja     801948 <__udivdi3+0x108>
  8018aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8018af:	89 fa                	mov    %edi,%edx
  8018b1:	83 c4 1c             	add    $0x1c,%esp
  8018b4:	5b                   	pop    %ebx
  8018b5:	5e                   	pop    %esi
  8018b6:	5f                   	pop    %edi
  8018b7:	5d                   	pop    %ebp
  8018b8:	c3                   	ret    
  8018b9:	8d 76 00             	lea    0x0(%esi),%esi
  8018bc:	31 ff                	xor    %edi,%edi
  8018be:	31 c0                	xor    %eax,%eax
  8018c0:	89 fa                	mov    %edi,%edx
  8018c2:	83 c4 1c             	add    $0x1c,%esp
  8018c5:	5b                   	pop    %ebx
  8018c6:	5e                   	pop    %esi
  8018c7:	5f                   	pop    %edi
  8018c8:	5d                   	pop    %ebp
  8018c9:	c3                   	ret    
  8018ca:	66 90                	xchg   %ax,%ax
  8018cc:	89 d8                	mov    %ebx,%eax
  8018ce:	f7 f7                	div    %edi
  8018d0:	31 ff                	xor    %edi,%edi
  8018d2:	89 fa                	mov    %edi,%edx
  8018d4:	83 c4 1c             	add    $0x1c,%esp
  8018d7:	5b                   	pop    %ebx
  8018d8:	5e                   	pop    %esi
  8018d9:	5f                   	pop    %edi
  8018da:	5d                   	pop    %ebp
  8018db:	c3                   	ret    
  8018dc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8018e1:	89 eb                	mov    %ebp,%ebx
  8018e3:	29 fb                	sub    %edi,%ebx
  8018e5:	89 f9                	mov    %edi,%ecx
  8018e7:	d3 e6                	shl    %cl,%esi
  8018e9:	89 c5                	mov    %eax,%ebp
  8018eb:	88 d9                	mov    %bl,%cl
  8018ed:	d3 ed                	shr    %cl,%ebp
  8018ef:	89 e9                	mov    %ebp,%ecx
  8018f1:	09 f1                	or     %esi,%ecx
  8018f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8018f7:	89 f9                	mov    %edi,%ecx
  8018f9:	d3 e0                	shl    %cl,%eax
  8018fb:	89 c5                	mov    %eax,%ebp
  8018fd:	89 d6                	mov    %edx,%esi
  8018ff:	88 d9                	mov    %bl,%cl
  801901:	d3 ee                	shr    %cl,%esi
  801903:	89 f9                	mov    %edi,%ecx
  801905:	d3 e2                	shl    %cl,%edx
  801907:	8b 44 24 08          	mov    0x8(%esp),%eax
  80190b:	88 d9                	mov    %bl,%cl
  80190d:	d3 e8                	shr    %cl,%eax
  80190f:	09 c2                	or     %eax,%edx
  801911:	89 d0                	mov    %edx,%eax
  801913:	89 f2                	mov    %esi,%edx
  801915:	f7 74 24 0c          	divl   0xc(%esp)
  801919:	89 d6                	mov    %edx,%esi
  80191b:	89 c3                	mov    %eax,%ebx
  80191d:	f7 e5                	mul    %ebp
  80191f:	39 d6                	cmp    %edx,%esi
  801921:	72 19                	jb     80193c <__udivdi3+0xfc>
  801923:	74 0b                	je     801930 <__udivdi3+0xf0>
  801925:	89 d8                	mov    %ebx,%eax
  801927:	31 ff                	xor    %edi,%edi
  801929:	e9 58 ff ff ff       	jmp    801886 <__udivdi3+0x46>
  80192e:	66 90                	xchg   %ax,%ax
  801930:	8b 54 24 08          	mov    0x8(%esp),%edx
  801934:	89 f9                	mov    %edi,%ecx
  801936:	d3 e2                	shl    %cl,%edx
  801938:	39 c2                	cmp    %eax,%edx
  80193a:	73 e9                	jae    801925 <__udivdi3+0xe5>
  80193c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80193f:	31 ff                	xor    %edi,%edi
  801941:	e9 40 ff ff ff       	jmp    801886 <__udivdi3+0x46>
  801946:	66 90                	xchg   %ax,%ax
  801948:	31 c0                	xor    %eax,%eax
  80194a:	e9 37 ff ff ff       	jmp    801886 <__udivdi3+0x46>
  80194f:	90                   	nop

00801950 <__umoddi3>:
  801950:	55                   	push   %ebp
  801951:	57                   	push   %edi
  801952:	56                   	push   %esi
  801953:	53                   	push   %ebx
  801954:	83 ec 1c             	sub    $0x1c,%esp
  801957:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80195b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80195f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801963:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801967:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80196b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80196f:	89 f3                	mov    %esi,%ebx
  801971:	89 fa                	mov    %edi,%edx
  801973:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801977:	89 34 24             	mov    %esi,(%esp)
  80197a:	85 c0                	test   %eax,%eax
  80197c:	75 1a                	jne    801998 <__umoddi3+0x48>
  80197e:	39 f7                	cmp    %esi,%edi
  801980:	0f 86 a2 00 00 00    	jbe    801a28 <__umoddi3+0xd8>
  801986:	89 c8                	mov    %ecx,%eax
  801988:	89 f2                	mov    %esi,%edx
  80198a:	f7 f7                	div    %edi
  80198c:	89 d0                	mov    %edx,%eax
  80198e:	31 d2                	xor    %edx,%edx
  801990:	83 c4 1c             	add    $0x1c,%esp
  801993:	5b                   	pop    %ebx
  801994:	5e                   	pop    %esi
  801995:	5f                   	pop    %edi
  801996:	5d                   	pop    %ebp
  801997:	c3                   	ret    
  801998:	39 f0                	cmp    %esi,%eax
  80199a:	0f 87 ac 00 00 00    	ja     801a4c <__umoddi3+0xfc>
  8019a0:	0f bd e8             	bsr    %eax,%ebp
  8019a3:	83 f5 1f             	xor    $0x1f,%ebp
  8019a6:	0f 84 ac 00 00 00    	je     801a58 <__umoddi3+0x108>
  8019ac:	bf 20 00 00 00       	mov    $0x20,%edi
  8019b1:	29 ef                	sub    %ebp,%edi
  8019b3:	89 fe                	mov    %edi,%esi
  8019b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8019b9:	89 e9                	mov    %ebp,%ecx
  8019bb:	d3 e0                	shl    %cl,%eax
  8019bd:	89 d7                	mov    %edx,%edi
  8019bf:	89 f1                	mov    %esi,%ecx
  8019c1:	d3 ef                	shr    %cl,%edi
  8019c3:	09 c7                	or     %eax,%edi
  8019c5:	89 e9                	mov    %ebp,%ecx
  8019c7:	d3 e2                	shl    %cl,%edx
  8019c9:	89 14 24             	mov    %edx,(%esp)
  8019cc:	89 d8                	mov    %ebx,%eax
  8019ce:	d3 e0                	shl    %cl,%eax
  8019d0:	89 c2                	mov    %eax,%edx
  8019d2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019d6:	d3 e0                	shl    %cl,%eax
  8019d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019dc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019e0:	89 f1                	mov    %esi,%ecx
  8019e2:	d3 e8                	shr    %cl,%eax
  8019e4:	09 d0                	or     %edx,%eax
  8019e6:	d3 eb                	shr    %cl,%ebx
  8019e8:	89 da                	mov    %ebx,%edx
  8019ea:	f7 f7                	div    %edi
  8019ec:	89 d3                	mov    %edx,%ebx
  8019ee:	f7 24 24             	mull   (%esp)
  8019f1:	89 c6                	mov    %eax,%esi
  8019f3:	89 d1                	mov    %edx,%ecx
  8019f5:	39 d3                	cmp    %edx,%ebx
  8019f7:	0f 82 87 00 00 00    	jb     801a84 <__umoddi3+0x134>
  8019fd:	0f 84 91 00 00 00    	je     801a94 <__umoddi3+0x144>
  801a03:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a07:	29 f2                	sub    %esi,%edx
  801a09:	19 cb                	sbb    %ecx,%ebx
  801a0b:	89 d8                	mov    %ebx,%eax
  801a0d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a11:	d3 e0                	shl    %cl,%eax
  801a13:	89 e9                	mov    %ebp,%ecx
  801a15:	d3 ea                	shr    %cl,%edx
  801a17:	09 d0                	or     %edx,%eax
  801a19:	89 e9                	mov    %ebp,%ecx
  801a1b:	d3 eb                	shr    %cl,%ebx
  801a1d:	89 da                	mov    %ebx,%edx
  801a1f:	83 c4 1c             	add    $0x1c,%esp
  801a22:	5b                   	pop    %ebx
  801a23:	5e                   	pop    %esi
  801a24:	5f                   	pop    %edi
  801a25:	5d                   	pop    %ebp
  801a26:	c3                   	ret    
  801a27:	90                   	nop
  801a28:	89 fd                	mov    %edi,%ebp
  801a2a:	85 ff                	test   %edi,%edi
  801a2c:	75 0b                	jne    801a39 <__umoddi3+0xe9>
  801a2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a33:	31 d2                	xor    %edx,%edx
  801a35:	f7 f7                	div    %edi
  801a37:	89 c5                	mov    %eax,%ebp
  801a39:	89 f0                	mov    %esi,%eax
  801a3b:	31 d2                	xor    %edx,%edx
  801a3d:	f7 f5                	div    %ebp
  801a3f:	89 c8                	mov    %ecx,%eax
  801a41:	f7 f5                	div    %ebp
  801a43:	89 d0                	mov    %edx,%eax
  801a45:	e9 44 ff ff ff       	jmp    80198e <__umoddi3+0x3e>
  801a4a:	66 90                	xchg   %ax,%ax
  801a4c:	89 c8                	mov    %ecx,%eax
  801a4e:	89 f2                	mov    %esi,%edx
  801a50:	83 c4 1c             	add    $0x1c,%esp
  801a53:	5b                   	pop    %ebx
  801a54:	5e                   	pop    %esi
  801a55:	5f                   	pop    %edi
  801a56:	5d                   	pop    %ebp
  801a57:	c3                   	ret    
  801a58:	3b 04 24             	cmp    (%esp),%eax
  801a5b:	72 06                	jb     801a63 <__umoddi3+0x113>
  801a5d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a61:	77 0f                	ja     801a72 <__umoddi3+0x122>
  801a63:	89 f2                	mov    %esi,%edx
  801a65:	29 f9                	sub    %edi,%ecx
  801a67:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801a6b:	89 14 24             	mov    %edx,(%esp)
  801a6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a72:	8b 44 24 04          	mov    0x4(%esp),%eax
  801a76:	8b 14 24             	mov    (%esp),%edx
  801a79:	83 c4 1c             	add    $0x1c,%esp
  801a7c:	5b                   	pop    %ebx
  801a7d:	5e                   	pop    %esi
  801a7e:	5f                   	pop    %edi
  801a7f:	5d                   	pop    %ebp
  801a80:	c3                   	ret    
  801a81:	8d 76 00             	lea    0x0(%esi),%esi
  801a84:	2b 04 24             	sub    (%esp),%eax
  801a87:	19 fa                	sbb    %edi,%edx
  801a89:	89 d1                	mov    %edx,%ecx
  801a8b:	89 c6                	mov    %eax,%esi
  801a8d:	e9 71 ff ff ff       	jmp    801a03 <__umoddi3+0xb3>
  801a92:	66 90                	xchg   %ax,%ax
  801a94:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801a98:	72 ea                	jb     801a84 <__umoddi3+0x134>
  801a9a:	89 d9                	mov    %ebx,%ecx
  801a9c:	e9 62 ff ff ff       	jmp    801a03 <__umoddi3+0xb3>
