
obj/user/tst_invalid_access_slave3:     file format elf32-i386


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
  800031:	e8 31 00 00 00       	call   800067 <libmain>
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
	//[1] Non=reserved User Heap
	uint32 *ptr = (uint32*)(USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE);
  80003e:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	*ptr = 100 ;
  800045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800048:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	inctst();
  80004e:	e8 df 15 00 00       	call   801632 <inctst>
	panic("tst invalid access failed: Attempt to access a non-reserved (unmarked) user heap page.\nThe env must be killed and shouldn't return here.");
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	68 a0 1a 80 00       	push   $0x801aa0
  80005b:	6a 0e                	push   $0xe
  80005d:	68 2c 1b 80 00       	push   $0x801b2c
  800062:	e8 4d 01 00 00       	call   8001b4 <_panic>

00800067 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800067:	55                   	push   %ebp
  800068:	89 e5                	mov    %esp,%ebp
  80006a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80006d:	e8 82 14 00 00       	call   8014f4 <sys_getenvindex>
  800072:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800075:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800078:	89 d0                	mov    %edx,%eax
  80007a:	c1 e0 06             	shl    $0x6,%eax
  80007d:	29 d0                	sub    %edx,%eax
  80007f:	c1 e0 02             	shl    $0x2,%eax
  800082:	01 d0                	add    %edx,%eax
  800084:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80008b:	01 c8                	add    %ecx,%eax
  80008d:	c1 e0 03             	shl    $0x3,%eax
  800090:	01 d0                	add    %edx,%eax
  800092:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800099:	29 c2                	sub    %eax,%edx
  80009b:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8000a2:	89 c2                	mov    %eax,%edx
  8000a4:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8000aa:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000af:	a1 04 30 80 00       	mov    0x803004,%eax
  8000b4:	8a 40 20             	mov    0x20(%eax),%al
  8000b7:	84 c0                	test   %al,%al
  8000b9:	74 0d                	je     8000c8 <libmain+0x61>
		binaryname = myEnv->prog_name;
  8000bb:	a1 04 30 80 00       	mov    0x803004,%eax
  8000c0:	83 c0 20             	add    $0x20,%eax
  8000c3:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000cc:	7e 0a                	jle    8000d8 <libmain+0x71>
		binaryname = argv[0];
  8000ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000d1:	8b 00                	mov    (%eax),%eax
  8000d3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000d8:	83 ec 08             	sub    $0x8,%esp
  8000db:	ff 75 0c             	pushl  0xc(%ebp)
  8000de:	ff 75 08             	pushl  0x8(%ebp)
  8000e1:	e8 52 ff ff ff       	call   800038 <_main>
  8000e6:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8000e9:	e8 8a 11 00 00       	call   801278 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	68 68 1b 80 00       	push   $0x801b68
  8000f6:	e8 76 03 00 00       	call   800471 <cprintf>
  8000fb:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000fe:	a1 04 30 80 00       	mov    0x803004,%eax
  800103:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800109:	a1 04 30 80 00       	mov    0x803004,%eax
  80010e:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800114:	83 ec 04             	sub    $0x4,%esp
  800117:	52                   	push   %edx
  800118:	50                   	push   %eax
  800119:	68 90 1b 80 00       	push   $0x801b90
  80011e:	e8 4e 03 00 00       	call   800471 <cprintf>
  800123:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800126:	a1 04 30 80 00       	mov    0x803004,%eax
  80012b:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800131:	a1 04 30 80 00       	mov    0x803004,%eax
  800136:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80013c:	a1 04 30 80 00       	mov    0x803004,%eax
  800141:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800147:	51                   	push   %ecx
  800148:	52                   	push   %edx
  800149:	50                   	push   %eax
  80014a:	68 b8 1b 80 00       	push   $0x801bb8
  80014f:	e8 1d 03 00 00       	call   800471 <cprintf>
  800154:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800157:	a1 04 30 80 00       	mov    0x803004,%eax
  80015c:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	50                   	push   %eax
  800166:	68 10 1c 80 00       	push   $0x801c10
  80016b:	e8 01 03 00 00       	call   800471 <cprintf>
  800170:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	68 68 1b 80 00       	push   $0x801b68
  80017b:	e8 f1 02 00 00       	call   800471 <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800183:	e8 0a 11 00 00       	call   801292 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800188:	e8 19 00 00 00       	call   8001a6 <exit>
}
  80018d:	90                   	nop
  80018e:	c9                   	leave  
  80018f:	c3                   	ret    

00800190 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800190:	55                   	push   %ebp
  800191:	89 e5                	mov    %esp,%ebp
  800193:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800196:	83 ec 0c             	sub    $0xc,%esp
  800199:	6a 00                	push   $0x0
  80019b:	e8 20 13 00 00       	call   8014c0 <sys_destroy_env>
  8001a0:	83 c4 10             	add    $0x10,%esp
}
  8001a3:	90                   	nop
  8001a4:	c9                   	leave  
  8001a5:	c3                   	ret    

008001a6 <exit>:

void
exit(void)
{
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001ac:	e8 75 13 00 00       	call   801526 <sys_exit_env>
}
  8001b1:	90                   	nop
  8001b2:	c9                   	leave  
  8001b3:	c3                   	ret    

008001b4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001ba:	8d 45 10             	lea    0x10(%ebp),%eax
  8001bd:	83 c0 04             	add    $0x4,%eax
  8001c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001c3:	a1 24 30 80 00       	mov    0x803024,%eax
  8001c8:	85 c0                	test   %eax,%eax
  8001ca:	74 16                	je     8001e2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001cc:	a1 24 30 80 00       	mov    0x803024,%eax
  8001d1:	83 ec 08             	sub    $0x8,%esp
  8001d4:	50                   	push   %eax
  8001d5:	68 24 1c 80 00       	push   $0x801c24
  8001da:	e8 92 02 00 00       	call   800471 <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001e2:	a1 00 30 80 00       	mov    0x803000,%eax
  8001e7:	ff 75 0c             	pushl  0xc(%ebp)
  8001ea:	ff 75 08             	pushl  0x8(%ebp)
  8001ed:	50                   	push   %eax
  8001ee:	68 29 1c 80 00       	push   $0x801c29
  8001f3:	e8 79 02 00 00       	call   800471 <cprintf>
  8001f8:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8001fe:	83 ec 08             	sub    $0x8,%esp
  800201:	ff 75 f4             	pushl  -0xc(%ebp)
  800204:	50                   	push   %eax
  800205:	e8 fc 01 00 00       	call   800406 <vcprintf>
  80020a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80020d:	83 ec 08             	sub    $0x8,%esp
  800210:	6a 00                	push   $0x0
  800212:	68 45 1c 80 00       	push   $0x801c45
  800217:	e8 ea 01 00 00       	call   800406 <vcprintf>
  80021c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80021f:	e8 82 ff ff ff       	call   8001a6 <exit>

	// should not return here
	while (1) ;
  800224:	eb fe                	jmp    800224 <_panic+0x70>

00800226 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800226:	55                   	push   %ebp
  800227:	89 e5                	mov    %esp,%ebp
  800229:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80022c:	a1 04 30 80 00       	mov    0x803004,%eax
  800231:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023a:	39 c2                	cmp    %eax,%edx
  80023c:	74 14                	je     800252 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80023e:	83 ec 04             	sub    $0x4,%esp
  800241:	68 48 1c 80 00       	push   $0x801c48
  800246:	6a 26                	push   $0x26
  800248:	68 94 1c 80 00       	push   $0x801c94
  80024d:	e8 62 ff ff ff       	call   8001b4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800259:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800260:	e9 c5 00 00 00       	jmp    80032a <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800265:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800268:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80026f:	8b 45 08             	mov    0x8(%ebp),%eax
  800272:	01 d0                	add    %edx,%eax
  800274:	8b 00                	mov    (%eax),%eax
  800276:	85 c0                	test   %eax,%eax
  800278:	75 08                	jne    800282 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80027a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80027d:	e9 a5 00 00 00       	jmp    800327 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800282:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800289:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800290:	eb 69                	jmp    8002fb <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800292:	a1 04 30 80 00       	mov    0x803004,%eax
  800297:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80029d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002a0:	89 d0                	mov    %edx,%eax
  8002a2:	01 c0                	add    %eax,%eax
  8002a4:	01 d0                	add    %edx,%eax
  8002a6:	c1 e0 03             	shl    $0x3,%eax
  8002a9:	01 c8                	add    %ecx,%eax
  8002ab:	8a 40 04             	mov    0x4(%eax),%al
  8002ae:	84 c0                	test   %al,%al
  8002b0:	75 46                	jne    8002f8 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002b2:	a1 04 30 80 00       	mov    0x803004,%eax
  8002b7:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8002bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002c0:	89 d0                	mov    %edx,%eax
  8002c2:	01 c0                	add    %eax,%eax
  8002c4:	01 d0                	add    %edx,%eax
  8002c6:	c1 e0 03             	shl    $0x3,%eax
  8002c9:	01 c8                	add    %ecx,%eax
  8002cb:	8b 00                	mov    (%eax),%eax
  8002cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002d8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002dd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 c8                	add    %ecx,%eax
  8002e9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002eb:	39 c2                	cmp    %eax,%edx
  8002ed:	75 09                	jne    8002f8 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002ef:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002f6:	eb 15                	jmp    80030d <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002f8:	ff 45 e8             	incl   -0x18(%ebp)
  8002fb:	a1 04 30 80 00       	mov    0x803004,%eax
  800300:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800306:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800309:	39 c2                	cmp    %eax,%edx
  80030b:	77 85                	ja     800292 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80030d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800311:	75 14                	jne    800327 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800313:	83 ec 04             	sub    $0x4,%esp
  800316:	68 a0 1c 80 00       	push   $0x801ca0
  80031b:	6a 3a                	push   $0x3a
  80031d:	68 94 1c 80 00       	push   $0x801c94
  800322:	e8 8d fe ff ff       	call   8001b4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800327:	ff 45 f0             	incl   -0x10(%ebp)
  80032a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80032d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800330:	0f 8c 2f ff ff ff    	jl     800265 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800336:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80033d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800344:	eb 26                	jmp    80036c <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800346:	a1 04 30 80 00       	mov    0x803004,%eax
  80034b:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800351:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800354:	89 d0                	mov    %edx,%eax
  800356:	01 c0                	add    %eax,%eax
  800358:	01 d0                	add    %edx,%eax
  80035a:	c1 e0 03             	shl    $0x3,%eax
  80035d:	01 c8                	add    %ecx,%eax
  80035f:	8a 40 04             	mov    0x4(%eax),%al
  800362:	3c 01                	cmp    $0x1,%al
  800364:	75 03                	jne    800369 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800366:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800369:	ff 45 e0             	incl   -0x20(%ebp)
  80036c:	a1 04 30 80 00       	mov    0x803004,%eax
  800371:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800377:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80037a:	39 c2                	cmp    %eax,%edx
  80037c:	77 c8                	ja     800346 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80037e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800381:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800384:	74 14                	je     80039a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800386:	83 ec 04             	sub    $0x4,%esp
  800389:	68 f4 1c 80 00       	push   $0x801cf4
  80038e:	6a 44                	push   $0x44
  800390:	68 94 1c 80 00       	push   $0x801c94
  800395:	e8 1a fe ff ff       	call   8001b4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80039a:	90                   	nop
  80039b:	c9                   	leave  
  80039c:	c3                   	ret    

0080039d <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80039d:	55                   	push   %ebp
  80039e:	89 e5                	mov    %esp,%ebp
  8003a0:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8003a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	8d 48 01             	lea    0x1(%eax),%ecx
  8003ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ae:	89 0a                	mov    %ecx,(%edx)
  8003b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b3:	88 d1                	mov    %dl,%cl
  8003b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bf:	8b 00                	mov    (%eax),%eax
  8003c1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003c6:	75 2c                	jne    8003f4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003c8:	a0 08 30 80 00       	mov    0x803008,%al
  8003cd:	0f b6 c0             	movzbl %al,%eax
  8003d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003d3:	8b 12                	mov    (%edx),%edx
  8003d5:	89 d1                	mov    %edx,%ecx
  8003d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003da:	83 c2 08             	add    $0x8,%edx
  8003dd:	83 ec 04             	sub    $0x4,%esp
  8003e0:	50                   	push   %eax
  8003e1:	51                   	push   %ecx
  8003e2:	52                   	push   %edx
  8003e3:	e8 4e 0e 00 00       	call   801236 <sys_cputs>
  8003e8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f7:	8b 40 04             	mov    0x4(%eax),%eax
  8003fa:	8d 50 01             	lea    0x1(%eax),%edx
  8003fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800400:	89 50 04             	mov    %edx,0x4(%eax)
}
  800403:	90                   	nop
  800404:	c9                   	leave  
  800405:	c3                   	ret    

00800406 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800406:	55                   	push   %ebp
  800407:	89 e5                	mov    %esp,%ebp
  800409:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80040f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800416:	00 00 00 
	b.cnt = 0;
  800419:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800420:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800423:	ff 75 0c             	pushl  0xc(%ebp)
  800426:	ff 75 08             	pushl  0x8(%ebp)
  800429:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80042f:	50                   	push   %eax
  800430:	68 9d 03 80 00       	push   $0x80039d
  800435:	e8 11 02 00 00       	call   80064b <vprintfmt>
  80043a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80043d:	a0 08 30 80 00       	mov    0x803008,%al
  800442:	0f b6 c0             	movzbl %al,%eax
  800445:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80044b:	83 ec 04             	sub    $0x4,%esp
  80044e:	50                   	push   %eax
  80044f:	52                   	push   %edx
  800450:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800456:	83 c0 08             	add    $0x8,%eax
  800459:	50                   	push   %eax
  80045a:	e8 d7 0d 00 00       	call   801236 <sys_cputs>
  80045f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800462:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800469:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80046f:	c9                   	leave  
  800470:	c3                   	ret    

00800471 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800471:	55                   	push   %ebp
  800472:	89 e5                	mov    %esp,%ebp
  800474:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800477:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  80047e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800481:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800484:	8b 45 08             	mov    0x8(%ebp),%eax
  800487:	83 ec 08             	sub    $0x8,%esp
  80048a:	ff 75 f4             	pushl  -0xc(%ebp)
  80048d:	50                   	push   %eax
  80048e:	e8 73 ff ff ff       	call   800406 <vcprintf>
  800493:	83 c4 10             	add    $0x10,%esp
  800496:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800499:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80049c:	c9                   	leave  
  80049d:	c3                   	ret    

0080049e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80049e:	55                   	push   %ebp
  80049f:	89 e5                	mov    %esp,%ebp
  8004a1:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8004a4:	e8 cf 0d 00 00       	call   801278 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8004a9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8004af:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b2:	83 ec 08             	sub    $0x8,%esp
  8004b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004b8:	50                   	push   %eax
  8004b9:	e8 48 ff ff ff       	call   800406 <vcprintf>
  8004be:	83 c4 10             	add    $0x10,%esp
  8004c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004c4:	e8 c9 0d 00 00       	call   801292 <sys_unlock_cons>
	return cnt;
  8004c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004cc:	c9                   	leave  
  8004cd:	c3                   	ret    

008004ce <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004ce:	55                   	push   %ebp
  8004cf:	89 e5                	mov    %esp,%ebp
  8004d1:	53                   	push   %ebx
  8004d2:	83 ec 14             	sub    $0x14,%esp
  8004d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004db:	8b 45 14             	mov    0x14(%ebp),%eax
  8004de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004e1:	8b 45 18             	mov    0x18(%ebp),%eax
  8004e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004ec:	77 55                	ja     800543 <printnum+0x75>
  8004ee:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004f1:	72 05                	jb     8004f8 <printnum+0x2a>
  8004f3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004f6:	77 4b                	ja     800543 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004f8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004fb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004fe:	8b 45 18             	mov    0x18(%ebp),%eax
  800501:	ba 00 00 00 00       	mov    $0x0,%edx
  800506:	52                   	push   %edx
  800507:	50                   	push   %eax
  800508:	ff 75 f4             	pushl  -0xc(%ebp)
  80050b:	ff 75 f0             	pushl  -0x10(%ebp)
  80050e:	e8 25 13 00 00       	call   801838 <__udivdi3>
  800513:	83 c4 10             	add    $0x10,%esp
  800516:	83 ec 04             	sub    $0x4,%esp
  800519:	ff 75 20             	pushl  0x20(%ebp)
  80051c:	53                   	push   %ebx
  80051d:	ff 75 18             	pushl  0x18(%ebp)
  800520:	52                   	push   %edx
  800521:	50                   	push   %eax
  800522:	ff 75 0c             	pushl  0xc(%ebp)
  800525:	ff 75 08             	pushl  0x8(%ebp)
  800528:	e8 a1 ff ff ff       	call   8004ce <printnum>
  80052d:	83 c4 20             	add    $0x20,%esp
  800530:	eb 1a                	jmp    80054c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800532:	83 ec 08             	sub    $0x8,%esp
  800535:	ff 75 0c             	pushl  0xc(%ebp)
  800538:	ff 75 20             	pushl  0x20(%ebp)
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	ff d0                	call   *%eax
  800540:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800543:	ff 4d 1c             	decl   0x1c(%ebp)
  800546:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80054a:	7f e6                	jg     800532 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80054c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80054f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800557:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80055a:	53                   	push   %ebx
  80055b:	51                   	push   %ecx
  80055c:	52                   	push   %edx
  80055d:	50                   	push   %eax
  80055e:	e8 e5 13 00 00       	call   801948 <__umoddi3>
  800563:	83 c4 10             	add    $0x10,%esp
  800566:	05 54 1f 80 00       	add    $0x801f54,%eax
  80056b:	8a 00                	mov    (%eax),%al
  80056d:	0f be c0             	movsbl %al,%eax
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	ff 75 0c             	pushl  0xc(%ebp)
  800576:	50                   	push   %eax
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	ff d0                	call   *%eax
  80057c:	83 c4 10             	add    $0x10,%esp
}
  80057f:	90                   	nop
  800580:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800583:	c9                   	leave  
  800584:	c3                   	ret    

00800585 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800585:	55                   	push   %ebp
  800586:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800588:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80058c:	7e 1c                	jle    8005aa <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80058e:	8b 45 08             	mov    0x8(%ebp),%eax
  800591:	8b 00                	mov    (%eax),%eax
  800593:	8d 50 08             	lea    0x8(%eax),%edx
  800596:	8b 45 08             	mov    0x8(%ebp),%eax
  800599:	89 10                	mov    %edx,(%eax)
  80059b:	8b 45 08             	mov    0x8(%ebp),%eax
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	83 e8 08             	sub    $0x8,%eax
  8005a3:	8b 50 04             	mov    0x4(%eax),%edx
  8005a6:	8b 00                	mov    (%eax),%eax
  8005a8:	eb 40                	jmp    8005ea <getuint+0x65>
	else if (lflag)
  8005aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005ae:	74 1e                	je     8005ce <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b3:	8b 00                	mov    (%eax),%eax
  8005b5:	8d 50 04             	lea    0x4(%eax),%edx
  8005b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bb:	89 10                	mov    %edx,(%eax)
  8005bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c0:	8b 00                	mov    (%eax),%eax
  8005c2:	83 e8 04             	sub    $0x4,%eax
  8005c5:	8b 00                	mov    (%eax),%eax
  8005c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cc:	eb 1c                	jmp    8005ea <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	8d 50 04             	lea    0x4(%eax),%edx
  8005d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d9:	89 10                	mov    %edx,(%eax)
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	8b 00                	mov    (%eax),%eax
  8005e0:	83 e8 04             	sub    $0x4,%eax
  8005e3:	8b 00                	mov    (%eax),%eax
  8005e5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005ea:	5d                   	pop    %ebp
  8005eb:	c3                   	ret    

008005ec <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005ec:	55                   	push   %ebp
  8005ed:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005ef:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005f3:	7e 1c                	jle    800611 <getint+0x25>
		return va_arg(*ap, long long);
  8005f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f8:	8b 00                	mov    (%eax),%eax
  8005fa:	8d 50 08             	lea    0x8(%eax),%edx
  8005fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800600:	89 10                	mov    %edx,(%eax)
  800602:	8b 45 08             	mov    0x8(%ebp),%eax
  800605:	8b 00                	mov    (%eax),%eax
  800607:	83 e8 08             	sub    $0x8,%eax
  80060a:	8b 50 04             	mov    0x4(%eax),%edx
  80060d:	8b 00                	mov    (%eax),%eax
  80060f:	eb 38                	jmp    800649 <getint+0x5d>
	else if (lflag)
  800611:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800615:	74 1a                	je     800631 <getint+0x45>
		return va_arg(*ap, long);
  800617:	8b 45 08             	mov    0x8(%ebp),%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	8d 50 04             	lea    0x4(%eax),%edx
  80061f:	8b 45 08             	mov    0x8(%ebp),%eax
  800622:	89 10                	mov    %edx,(%eax)
  800624:	8b 45 08             	mov    0x8(%ebp),%eax
  800627:	8b 00                	mov    (%eax),%eax
  800629:	83 e8 04             	sub    $0x4,%eax
  80062c:	8b 00                	mov    (%eax),%eax
  80062e:	99                   	cltd   
  80062f:	eb 18                	jmp    800649 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800631:	8b 45 08             	mov    0x8(%ebp),%eax
  800634:	8b 00                	mov    (%eax),%eax
  800636:	8d 50 04             	lea    0x4(%eax),%edx
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	89 10                	mov    %edx,(%eax)
  80063e:	8b 45 08             	mov    0x8(%ebp),%eax
  800641:	8b 00                	mov    (%eax),%eax
  800643:	83 e8 04             	sub    $0x4,%eax
  800646:	8b 00                	mov    (%eax),%eax
  800648:	99                   	cltd   
}
  800649:	5d                   	pop    %ebp
  80064a:	c3                   	ret    

0080064b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80064b:	55                   	push   %ebp
  80064c:	89 e5                	mov    %esp,%ebp
  80064e:	56                   	push   %esi
  80064f:	53                   	push   %ebx
  800650:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800653:	eb 17                	jmp    80066c <vprintfmt+0x21>
			if (ch == '\0')
  800655:	85 db                	test   %ebx,%ebx
  800657:	0f 84 c1 03 00 00    	je     800a1e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	ff 75 0c             	pushl  0xc(%ebp)
  800663:	53                   	push   %ebx
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	ff d0                	call   *%eax
  800669:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80066c:	8b 45 10             	mov    0x10(%ebp),%eax
  80066f:	8d 50 01             	lea    0x1(%eax),%edx
  800672:	89 55 10             	mov    %edx,0x10(%ebp)
  800675:	8a 00                	mov    (%eax),%al
  800677:	0f b6 d8             	movzbl %al,%ebx
  80067a:	83 fb 25             	cmp    $0x25,%ebx
  80067d:	75 d6                	jne    800655 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80067f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800683:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80068a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800691:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800698:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80069f:	8b 45 10             	mov    0x10(%ebp),%eax
  8006a2:	8d 50 01             	lea    0x1(%eax),%edx
  8006a5:	89 55 10             	mov    %edx,0x10(%ebp)
  8006a8:	8a 00                	mov    (%eax),%al
  8006aa:	0f b6 d8             	movzbl %al,%ebx
  8006ad:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006b0:	83 f8 5b             	cmp    $0x5b,%eax
  8006b3:	0f 87 3d 03 00 00    	ja     8009f6 <vprintfmt+0x3ab>
  8006b9:	8b 04 85 78 1f 80 00 	mov    0x801f78(,%eax,4),%eax
  8006c0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006c2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006c6:	eb d7                	jmp    80069f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006c8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006cc:	eb d1                	jmp    80069f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006ce:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006d8:	89 d0                	mov    %edx,%eax
  8006da:	c1 e0 02             	shl    $0x2,%eax
  8006dd:	01 d0                	add    %edx,%eax
  8006df:	01 c0                	add    %eax,%eax
  8006e1:	01 d8                	add    %ebx,%eax
  8006e3:	83 e8 30             	sub    $0x30,%eax
  8006e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ec:	8a 00                	mov    (%eax),%al
  8006ee:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006f1:	83 fb 2f             	cmp    $0x2f,%ebx
  8006f4:	7e 3e                	jle    800734 <vprintfmt+0xe9>
  8006f6:	83 fb 39             	cmp    $0x39,%ebx
  8006f9:	7f 39                	jg     800734 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006fb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006fe:	eb d5                	jmp    8006d5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	83 c0 04             	add    $0x4,%eax
  800706:	89 45 14             	mov    %eax,0x14(%ebp)
  800709:	8b 45 14             	mov    0x14(%ebp),%eax
  80070c:	83 e8 04             	sub    $0x4,%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800714:	eb 1f                	jmp    800735 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800716:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80071a:	79 83                	jns    80069f <vprintfmt+0x54>
				width = 0;
  80071c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800723:	e9 77 ff ff ff       	jmp    80069f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800728:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80072f:	e9 6b ff ff ff       	jmp    80069f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800734:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800735:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800739:	0f 89 60 ff ff ff    	jns    80069f <vprintfmt+0x54>
				width = precision, precision = -1;
  80073f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800742:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800745:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80074c:	e9 4e ff ff ff       	jmp    80069f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800751:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800754:	e9 46 ff ff ff       	jmp    80069f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	83 c0 04             	add    $0x4,%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	83 e8 04             	sub    $0x4,%eax
  800768:	8b 00                	mov    (%eax),%eax
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	ff 75 0c             	pushl  0xc(%ebp)
  800770:	50                   	push   %eax
  800771:	8b 45 08             	mov    0x8(%ebp),%eax
  800774:	ff d0                	call   *%eax
  800776:	83 c4 10             	add    $0x10,%esp
			break;
  800779:	e9 9b 02 00 00       	jmp    800a19 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80077e:	8b 45 14             	mov    0x14(%ebp),%eax
  800781:	83 c0 04             	add    $0x4,%eax
  800784:	89 45 14             	mov    %eax,0x14(%ebp)
  800787:	8b 45 14             	mov    0x14(%ebp),%eax
  80078a:	83 e8 04             	sub    $0x4,%eax
  80078d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80078f:	85 db                	test   %ebx,%ebx
  800791:	79 02                	jns    800795 <vprintfmt+0x14a>
				err = -err;
  800793:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800795:	83 fb 64             	cmp    $0x64,%ebx
  800798:	7f 0b                	jg     8007a5 <vprintfmt+0x15a>
  80079a:	8b 34 9d c0 1d 80 00 	mov    0x801dc0(,%ebx,4),%esi
  8007a1:	85 f6                	test   %esi,%esi
  8007a3:	75 19                	jne    8007be <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007a5:	53                   	push   %ebx
  8007a6:	68 65 1f 80 00       	push   $0x801f65
  8007ab:	ff 75 0c             	pushl  0xc(%ebp)
  8007ae:	ff 75 08             	pushl  0x8(%ebp)
  8007b1:	e8 70 02 00 00       	call   800a26 <printfmt>
  8007b6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007b9:	e9 5b 02 00 00       	jmp    800a19 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007be:	56                   	push   %esi
  8007bf:	68 6e 1f 80 00       	push   $0x801f6e
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	e8 57 02 00 00       	call   800a26 <printfmt>
  8007cf:	83 c4 10             	add    $0x10,%esp
			break;
  8007d2:	e9 42 02 00 00       	jmp    800a19 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	83 c0 04             	add    $0x4,%eax
  8007dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e3:	83 e8 04             	sub    $0x4,%eax
  8007e6:	8b 30                	mov    (%eax),%esi
  8007e8:	85 f6                	test   %esi,%esi
  8007ea:	75 05                	jne    8007f1 <vprintfmt+0x1a6>
				p = "(null)";
  8007ec:	be 71 1f 80 00       	mov    $0x801f71,%esi
			if (width > 0 && padc != '-')
  8007f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f5:	7e 6d                	jle    800864 <vprintfmt+0x219>
  8007f7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007fb:	74 67                	je     800864 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800800:	83 ec 08             	sub    $0x8,%esp
  800803:	50                   	push   %eax
  800804:	56                   	push   %esi
  800805:	e8 1e 03 00 00       	call   800b28 <strnlen>
  80080a:	83 c4 10             	add    $0x10,%esp
  80080d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800810:	eb 16                	jmp    800828 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800812:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800816:	83 ec 08             	sub    $0x8,%esp
  800819:	ff 75 0c             	pushl  0xc(%ebp)
  80081c:	50                   	push   %eax
  80081d:	8b 45 08             	mov    0x8(%ebp),%eax
  800820:	ff d0                	call   *%eax
  800822:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800825:	ff 4d e4             	decl   -0x1c(%ebp)
  800828:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082c:	7f e4                	jg     800812 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80082e:	eb 34                	jmp    800864 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800830:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800834:	74 1c                	je     800852 <vprintfmt+0x207>
  800836:	83 fb 1f             	cmp    $0x1f,%ebx
  800839:	7e 05                	jle    800840 <vprintfmt+0x1f5>
  80083b:	83 fb 7e             	cmp    $0x7e,%ebx
  80083e:	7e 12                	jle    800852 <vprintfmt+0x207>
					putch('?', putdat);
  800840:	83 ec 08             	sub    $0x8,%esp
  800843:	ff 75 0c             	pushl  0xc(%ebp)
  800846:	6a 3f                	push   $0x3f
  800848:	8b 45 08             	mov    0x8(%ebp),%eax
  80084b:	ff d0                	call   *%eax
  80084d:	83 c4 10             	add    $0x10,%esp
  800850:	eb 0f                	jmp    800861 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800852:	83 ec 08             	sub    $0x8,%esp
  800855:	ff 75 0c             	pushl  0xc(%ebp)
  800858:	53                   	push   %ebx
  800859:	8b 45 08             	mov    0x8(%ebp),%eax
  80085c:	ff d0                	call   *%eax
  80085e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800861:	ff 4d e4             	decl   -0x1c(%ebp)
  800864:	89 f0                	mov    %esi,%eax
  800866:	8d 70 01             	lea    0x1(%eax),%esi
  800869:	8a 00                	mov    (%eax),%al
  80086b:	0f be d8             	movsbl %al,%ebx
  80086e:	85 db                	test   %ebx,%ebx
  800870:	74 24                	je     800896 <vprintfmt+0x24b>
  800872:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800876:	78 b8                	js     800830 <vprintfmt+0x1e5>
  800878:	ff 4d e0             	decl   -0x20(%ebp)
  80087b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80087f:	79 af                	jns    800830 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800881:	eb 13                	jmp    800896 <vprintfmt+0x24b>
				putch(' ', putdat);
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	ff 75 0c             	pushl  0xc(%ebp)
  800889:	6a 20                	push   $0x20
  80088b:	8b 45 08             	mov    0x8(%ebp),%eax
  80088e:	ff d0                	call   *%eax
  800890:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800893:	ff 4d e4             	decl   -0x1c(%ebp)
  800896:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80089a:	7f e7                	jg     800883 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80089c:	e9 78 01 00 00       	jmp    800a19 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8008a7:	8d 45 14             	lea    0x14(%ebp),%eax
  8008aa:	50                   	push   %eax
  8008ab:	e8 3c fd ff ff       	call   8005ec <getint>
  8008b0:	83 c4 10             	add    $0x10,%esp
  8008b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008bf:	85 d2                	test   %edx,%edx
  8008c1:	79 23                	jns    8008e6 <vprintfmt+0x29b>
				putch('-', putdat);
  8008c3:	83 ec 08             	sub    $0x8,%esp
  8008c6:	ff 75 0c             	pushl  0xc(%ebp)
  8008c9:	6a 2d                	push   $0x2d
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	ff d0                	call   *%eax
  8008d0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008d9:	f7 d8                	neg    %eax
  8008db:	83 d2 00             	adc    $0x0,%edx
  8008de:	f7 da                	neg    %edx
  8008e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008e6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008ed:	e9 bc 00 00 00       	jmp    8009ae <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	ff 75 e8             	pushl  -0x18(%ebp)
  8008f8:	8d 45 14             	lea    0x14(%ebp),%eax
  8008fb:	50                   	push   %eax
  8008fc:	e8 84 fc ff ff       	call   800585 <getuint>
  800901:	83 c4 10             	add    $0x10,%esp
  800904:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800907:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80090a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800911:	e9 98 00 00 00       	jmp    8009ae <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800916:	83 ec 08             	sub    $0x8,%esp
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	6a 58                	push   $0x58
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	ff d0                	call   *%eax
  800923:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800926:	83 ec 08             	sub    $0x8,%esp
  800929:	ff 75 0c             	pushl  0xc(%ebp)
  80092c:	6a 58                	push   $0x58
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	ff d0                	call   *%eax
  800933:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	ff 75 0c             	pushl  0xc(%ebp)
  80093c:	6a 58                	push   $0x58
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	ff d0                	call   *%eax
  800943:	83 c4 10             	add    $0x10,%esp
			break;
  800946:	e9 ce 00 00 00       	jmp    800a19 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	6a 30                	push   $0x30
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	ff d0                	call   *%eax
  800958:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	ff 75 0c             	pushl  0xc(%ebp)
  800961:	6a 78                	push   $0x78
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	ff d0                	call   *%eax
  800968:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	83 c0 04             	add    $0x4,%eax
  800971:	89 45 14             	mov    %eax,0x14(%ebp)
  800974:	8b 45 14             	mov    0x14(%ebp),%eax
  800977:	83 e8 04             	sub    $0x4,%eax
  80097a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80097c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800986:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80098d:	eb 1f                	jmp    8009ae <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80098f:	83 ec 08             	sub    $0x8,%esp
  800992:	ff 75 e8             	pushl  -0x18(%ebp)
  800995:	8d 45 14             	lea    0x14(%ebp),%eax
  800998:	50                   	push   %eax
  800999:	e8 e7 fb ff ff       	call   800585 <getuint>
  80099e:	83 c4 10             	add    $0x10,%esp
  8009a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009a7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009ae:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009b5:	83 ec 04             	sub    $0x4,%esp
  8009b8:	52                   	push   %edx
  8009b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009bc:	50                   	push   %eax
  8009bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8009c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8009c3:	ff 75 0c             	pushl  0xc(%ebp)
  8009c6:	ff 75 08             	pushl  0x8(%ebp)
  8009c9:	e8 00 fb ff ff       	call   8004ce <printnum>
  8009ce:	83 c4 20             	add    $0x20,%esp
			break;
  8009d1:	eb 46                	jmp    800a19 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	ff 75 0c             	pushl  0xc(%ebp)
  8009d9:	53                   	push   %ebx
  8009da:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dd:	ff d0                	call   *%eax
  8009df:	83 c4 10             	add    $0x10,%esp
			break;
  8009e2:	eb 35                	jmp    800a19 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009e4:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8009eb:	eb 2c                	jmp    800a19 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009ed:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8009f4:	eb 23                	jmp    800a19 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009f6:	83 ec 08             	sub    $0x8,%esp
  8009f9:	ff 75 0c             	pushl  0xc(%ebp)
  8009fc:	6a 25                	push   $0x25
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	ff d0                	call   *%eax
  800a03:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a06:	ff 4d 10             	decl   0x10(%ebp)
  800a09:	eb 03                	jmp    800a0e <vprintfmt+0x3c3>
  800a0b:	ff 4d 10             	decl   0x10(%ebp)
  800a0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a11:	48                   	dec    %eax
  800a12:	8a 00                	mov    (%eax),%al
  800a14:	3c 25                	cmp    $0x25,%al
  800a16:	75 f3                	jne    800a0b <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a18:	90                   	nop
		}
	}
  800a19:	e9 35 fc ff ff       	jmp    800653 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a1e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a22:	5b                   	pop    %ebx
  800a23:	5e                   	pop    %esi
  800a24:	5d                   	pop    %ebp
  800a25:	c3                   	ret    

00800a26 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a2c:	8d 45 10             	lea    0x10(%ebp),%eax
  800a2f:	83 c0 04             	add    $0x4,%eax
  800a32:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a35:	8b 45 10             	mov    0x10(%ebp),%eax
  800a38:	ff 75 f4             	pushl  -0xc(%ebp)
  800a3b:	50                   	push   %eax
  800a3c:	ff 75 0c             	pushl  0xc(%ebp)
  800a3f:	ff 75 08             	pushl  0x8(%ebp)
  800a42:	e8 04 fc ff ff       	call   80064b <vprintfmt>
  800a47:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a4a:	90                   	nop
  800a4b:	c9                   	leave  
  800a4c:	c3                   	ret    

00800a4d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a53:	8b 40 08             	mov    0x8(%eax),%eax
  800a56:	8d 50 01             	lea    0x1(%eax),%edx
  800a59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a62:	8b 10                	mov    (%eax),%edx
  800a64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a67:	8b 40 04             	mov    0x4(%eax),%eax
  800a6a:	39 c2                	cmp    %eax,%edx
  800a6c:	73 12                	jae    800a80 <sprintputch+0x33>
		*b->buf++ = ch;
  800a6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a71:	8b 00                	mov    (%eax),%eax
  800a73:	8d 48 01             	lea    0x1(%eax),%ecx
  800a76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a79:	89 0a                	mov    %ecx,(%edx)
  800a7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800a7e:	88 10                	mov    %dl,(%eax)
}
  800a80:	90                   	nop
  800a81:	5d                   	pop    %ebp
  800a82:	c3                   	ret    

00800a83 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a83:	55                   	push   %ebp
  800a84:	89 e5                	mov    %esp,%ebp
  800a86:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a92:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	01 d0                	add    %edx,%eax
  800a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800aa4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800aa8:	74 06                	je     800ab0 <vsnprintf+0x2d>
  800aaa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aae:	7f 07                	jg     800ab7 <vsnprintf+0x34>
		return -E_INVAL;
  800ab0:	b8 03 00 00 00       	mov    $0x3,%eax
  800ab5:	eb 20                	jmp    800ad7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ab7:	ff 75 14             	pushl  0x14(%ebp)
  800aba:	ff 75 10             	pushl  0x10(%ebp)
  800abd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ac0:	50                   	push   %eax
  800ac1:	68 4d 0a 80 00       	push   $0x800a4d
  800ac6:	e8 80 fb ff ff       	call   80064b <vprintfmt>
  800acb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ace:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ad1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ad7:	c9                   	leave  
  800ad8:	c3                   	ret    

00800ad9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800adf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ae2:	83 c0 04             	add    $0x4,%eax
  800ae5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ae8:	8b 45 10             	mov    0x10(%ebp),%eax
  800aeb:	ff 75 f4             	pushl  -0xc(%ebp)
  800aee:	50                   	push   %eax
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 08             	pushl  0x8(%ebp)
  800af5:	e8 89 ff ff ff       	call   800a83 <vsnprintf>
  800afa:	83 c4 10             	add    $0x10,%esp
  800afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b03:	c9                   	leave  
  800b04:	c3                   	ret    

00800b05 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b12:	eb 06                	jmp    800b1a <strlen+0x15>
		n++;
  800b14:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b17:	ff 45 08             	incl   0x8(%ebp)
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8a 00                	mov    (%eax),%al
  800b1f:	84 c0                	test   %al,%al
  800b21:	75 f1                	jne    800b14 <strlen+0xf>
		n++;
	return n;
  800b23:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b26:	c9                   	leave  
  800b27:	c3                   	ret    

00800b28 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b35:	eb 09                	jmp    800b40 <strnlen+0x18>
		n++;
  800b37:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b3a:	ff 45 08             	incl   0x8(%ebp)
  800b3d:	ff 4d 0c             	decl   0xc(%ebp)
  800b40:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b44:	74 09                	je     800b4f <strnlen+0x27>
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	8a 00                	mov    (%eax),%al
  800b4b:	84 c0                	test   %al,%al
  800b4d:	75 e8                	jne    800b37 <strnlen+0xf>
		n++;
	return n;
  800b4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b52:	c9                   	leave  
  800b53:	c3                   	ret    

00800b54 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b60:	90                   	nop
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	8d 50 01             	lea    0x1(%eax),%edx
  800b67:	89 55 08             	mov    %edx,0x8(%ebp)
  800b6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b70:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b73:	8a 12                	mov    (%edx),%dl
  800b75:	88 10                	mov    %dl,(%eax)
  800b77:	8a 00                	mov    (%eax),%al
  800b79:	84 c0                	test   %al,%al
  800b7b:	75 e4                	jne    800b61 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b80:	c9                   	leave  
  800b81:	c3                   	ret    

00800b82 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b95:	eb 1f                	jmp    800bb6 <strncpy+0x34>
		*dst++ = *src;
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	8d 50 01             	lea    0x1(%eax),%edx
  800b9d:	89 55 08             	mov    %edx,0x8(%ebp)
  800ba0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba3:	8a 12                	mov    (%edx),%dl
  800ba5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baa:	8a 00                	mov    (%eax),%al
  800bac:	84 c0                	test   %al,%al
  800bae:	74 03                	je     800bb3 <strncpy+0x31>
			src++;
  800bb0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bb3:	ff 45 fc             	incl   -0x4(%ebp)
  800bb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bb9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bbc:	72 d9                	jb     800b97 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800bbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bc1:	c9                   	leave  
  800bc2:	c3                   	ret    

00800bc3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bcf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bd3:	74 30                	je     800c05 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bd5:	eb 16                	jmp    800bed <strlcpy+0x2a>
			*dst++ = *src++;
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	8d 50 01             	lea    0x1(%eax),%edx
  800bdd:	89 55 08             	mov    %edx,0x8(%ebp)
  800be0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800be6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800be9:	8a 12                	mov    (%edx),%dl
  800beb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bed:	ff 4d 10             	decl   0x10(%ebp)
  800bf0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bf4:	74 09                	je     800bff <strlcpy+0x3c>
  800bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf9:	8a 00                	mov    (%eax),%al
  800bfb:	84 c0                	test   %al,%al
  800bfd:	75 d8                	jne    800bd7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c05:	8b 55 08             	mov    0x8(%ebp),%edx
  800c08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c0b:	29 c2                	sub    %eax,%edx
  800c0d:	89 d0                	mov    %edx,%eax
}
  800c0f:	c9                   	leave  
  800c10:	c3                   	ret    

00800c11 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c11:	55                   	push   %ebp
  800c12:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c14:	eb 06                	jmp    800c1c <strcmp+0xb>
		p++, q++;
  800c16:	ff 45 08             	incl   0x8(%ebp)
  800c19:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8a 00                	mov    (%eax),%al
  800c21:	84 c0                	test   %al,%al
  800c23:	74 0e                	je     800c33 <strcmp+0x22>
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	8a 10                	mov    (%eax),%dl
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	8a 00                	mov    (%eax),%al
  800c2f:	38 c2                	cmp    %al,%dl
  800c31:	74 e3                	je     800c16 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	8a 00                	mov    (%eax),%al
  800c38:	0f b6 d0             	movzbl %al,%edx
  800c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3e:	8a 00                	mov    (%eax),%al
  800c40:	0f b6 c0             	movzbl %al,%eax
  800c43:	29 c2                	sub    %eax,%edx
  800c45:	89 d0                	mov    %edx,%eax
}
  800c47:	5d                   	pop    %ebp
  800c48:	c3                   	ret    

00800c49 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c4c:	eb 09                	jmp    800c57 <strncmp+0xe>
		n--, p++, q++;
  800c4e:	ff 4d 10             	decl   0x10(%ebp)
  800c51:	ff 45 08             	incl   0x8(%ebp)
  800c54:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c5b:	74 17                	je     800c74 <strncmp+0x2b>
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	8a 00                	mov    (%eax),%al
  800c62:	84 c0                	test   %al,%al
  800c64:	74 0e                	je     800c74 <strncmp+0x2b>
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	8a 10                	mov    (%eax),%dl
  800c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6e:	8a 00                	mov    (%eax),%al
  800c70:	38 c2                	cmp    %al,%dl
  800c72:	74 da                	je     800c4e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c78:	75 07                	jne    800c81 <strncmp+0x38>
		return 0;
  800c7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7f:	eb 14                	jmp    800c95 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c81:	8b 45 08             	mov    0x8(%ebp),%eax
  800c84:	8a 00                	mov    (%eax),%al
  800c86:	0f b6 d0             	movzbl %al,%edx
  800c89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8c:	8a 00                	mov    (%eax),%al
  800c8e:	0f b6 c0             	movzbl %al,%eax
  800c91:	29 c2                	sub    %eax,%edx
  800c93:	89 d0                	mov    %edx,%eax
}
  800c95:	5d                   	pop    %ebp
  800c96:	c3                   	ret    

00800c97 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	83 ec 04             	sub    $0x4,%esp
  800c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ca3:	eb 12                	jmp    800cb7 <strchr+0x20>
		if (*s == c)
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	8a 00                	mov    (%eax),%al
  800caa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cad:	75 05                	jne    800cb4 <strchr+0x1d>
			return (char *) s;
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	eb 11                	jmp    800cc5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cb4:	ff 45 08             	incl   0x8(%ebp)
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	8a 00                	mov    (%eax),%al
  800cbc:	84 c0                	test   %al,%al
  800cbe:	75 e5                	jne    800ca5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cc5:	c9                   	leave  
  800cc6:	c3                   	ret    

00800cc7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	83 ec 04             	sub    $0x4,%esp
  800ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cd3:	eb 0d                	jmp    800ce2 <strfind+0x1b>
		if (*s == c)
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8a 00                	mov    (%eax),%al
  800cda:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cdd:	74 0e                	je     800ced <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cdf:	ff 45 08             	incl   0x8(%ebp)
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	8a 00                	mov    (%eax),%al
  800ce7:	84 c0                	test   %al,%al
  800ce9:	75 ea                	jne    800cd5 <strfind+0xe>
  800ceb:	eb 01                	jmp    800cee <strfind+0x27>
		if (*s == c)
			break;
  800ced:	90                   	nop
	return (char *) s;
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf1:	c9                   	leave  
  800cf2:	c3                   	ret    

00800cf3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cff:	8b 45 10             	mov    0x10(%ebp),%eax
  800d02:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d05:	eb 0e                	jmp    800d15 <memset+0x22>
		*p++ = c;
  800d07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0a:	8d 50 01             	lea    0x1(%eax),%edx
  800d0d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d10:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d13:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d15:	ff 4d f8             	decl   -0x8(%ebp)
  800d18:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d1c:	79 e9                	jns    800d07 <memset+0x14>
		*p++ = c;

	return v;
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d21:	c9                   	leave  
  800d22:	c3                   	ret    

00800d23 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d35:	eb 16                	jmp    800d4d <memcpy+0x2a>
		*d++ = *s++;
  800d37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d3a:	8d 50 01             	lea    0x1(%eax),%edx
  800d3d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d40:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d43:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d46:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d49:	8a 12                	mov    (%edx),%dl
  800d4b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d50:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d53:	89 55 10             	mov    %edx,0x10(%ebp)
  800d56:	85 c0                	test   %eax,%eax
  800d58:	75 dd                	jne    800d37 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d5d:	c9                   	leave  
  800d5e:	c3                   	ret    

00800d5f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
  800d62:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d74:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d77:	73 50                	jae    800dc9 <memmove+0x6a>
  800d79:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7f:	01 d0                	add    %edx,%eax
  800d81:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d84:	76 43                	jbe    800dc9 <memmove+0x6a>
		s += n;
  800d86:	8b 45 10             	mov    0x10(%ebp),%eax
  800d89:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d92:	eb 10                	jmp    800da4 <memmove+0x45>
			*--d = *--s;
  800d94:	ff 4d f8             	decl   -0x8(%ebp)
  800d97:	ff 4d fc             	decl   -0x4(%ebp)
  800d9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d9d:	8a 10                	mov    (%eax),%dl
  800d9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800da4:	8b 45 10             	mov    0x10(%ebp),%eax
  800da7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800daa:	89 55 10             	mov    %edx,0x10(%ebp)
  800dad:	85 c0                	test   %eax,%eax
  800daf:	75 e3                	jne    800d94 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800db1:	eb 23                	jmp    800dd6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800db3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db6:	8d 50 01             	lea    0x1(%eax),%edx
  800db9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dbc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dbf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dc2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dc5:	8a 12                	mov    (%edx),%dl
  800dc7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dcf:	89 55 10             	mov    %edx,0x10(%ebp)
  800dd2:	85 c0                	test   %eax,%eax
  800dd4:	75 dd                	jne    800db3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd9:	c9                   	leave  
  800dda:	c3                   	ret    

00800ddb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ddb:	55                   	push   %ebp
  800ddc:	89 e5                	mov    %esp,%ebp
  800dde:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dea:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ded:	eb 2a                	jmp    800e19 <memcmp+0x3e>
		if (*s1 != *s2)
  800def:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df2:	8a 10                	mov    (%eax),%dl
  800df4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	38 c2                	cmp    %al,%dl
  800dfb:	74 16                	je     800e13 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e00:	8a 00                	mov    (%eax),%al
  800e02:	0f b6 d0             	movzbl %al,%edx
  800e05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e08:	8a 00                	mov    (%eax),%al
  800e0a:	0f b6 c0             	movzbl %al,%eax
  800e0d:	29 c2                	sub    %eax,%edx
  800e0f:	89 d0                	mov    %edx,%eax
  800e11:	eb 18                	jmp    800e2b <memcmp+0x50>
		s1++, s2++;
  800e13:	ff 45 fc             	incl   -0x4(%ebp)
  800e16:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e19:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e1f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e22:	85 c0                	test   %eax,%eax
  800e24:	75 c9                	jne    800def <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e33:	8b 55 08             	mov    0x8(%ebp),%edx
  800e36:	8b 45 10             	mov    0x10(%ebp),%eax
  800e39:	01 d0                	add    %edx,%eax
  800e3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e3e:	eb 15                	jmp    800e55 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	8a 00                	mov    (%eax),%al
  800e45:	0f b6 d0             	movzbl %al,%edx
  800e48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4b:	0f b6 c0             	movzbl %al,%eax
  800e4e:	39 c2                	cmp    %eax,%edx
  800e50:	74 0d                	je     800e5f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e52:	ff 45 08             	incl   0x8(%ebp)
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e5b:	72 e3                	jb     800e40 <memfind+0x13>
  800e5d:	eb 01                	jmp    800e60 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e5f:	90                   	nop
	return (void *) s;
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e63:	c9                   	leave  
  800e64:	c3                   	ret    

00800e65 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e6b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e72:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e79:	eb 03                	jmp    800e7e <strtol+0x19>
		s++;
  800e7b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	8a 00                	mov    (%eax),%al
  800e83:	3c 20                	cmp    $0x20,%al
  800e85:	74 f4                	je     800e7b <strtol+0x16>
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	8a 00                	mov    (%eax),%al
  800e8c:	3c 09                	cmp    $0x9,%al
  800e8e:	74 eb                	je     800e7b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	3c 2b                	cmp    $0x2b,%al
  800e97:	75 05                	jne    800e9e <strtol+0x39>
		s++;
  800e99:	ff 45 08             	incl   0x8(%ebp)
  800e9c:	eb 13                	jmp    800eb1 <strtol+0x4c>
	else if (*s == '-')
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	8a 00                	mov    (%eax),%al
  800ea3:	3c 2d                	cmp    $0x2d,%al
  800ea5:	75 0a                	jne    800eb1 <strtol+0x4c>
		s++, neg = 1;
  800ea7:	ff 45 08             	incl   0x8(%ebp)
  800eaa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb5:	74 06                	je     800ebd <strtol+0x58>
  800eb7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ebb:	75 20                	jne    800edd <strtol+0x78>
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	3c 30                	cmp    $0x30,%al
  800ec4:	75 17                	jne    800edd <strtol+0x78>
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	40                   	inc    %eax
  800eca:	8a 00                	mov    (%eax),%al
  800ecc:	3c 78                	cmp    $0x78,%al
  800ece:	75 0d                	jne    800edd <strtol+0x78>
		s += 2, base = 16;
  800ed0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ed4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800edb:	eb 28                	jmp    800f05 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800edd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee1:	75 15                	jne    800ef8 <strtol+0x93>
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	8a 00                	mov    (%eax),%al
  800ee8:	3c 30                	cmp    $0x30,%al
  800eea:	75 0c                	jne    800ef8 <strtol+0x93>
		s++, base = 8;
  800eec:	ff 45 08             	incl   0x8(%ebp)
  800eef:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ef6:	eb 0d                	jmp    800f05 <strtol+0xa0>
	else if (base == 0)
  800ef8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800efc:	75 07                	jne    800f05 <strtol+0xa0>
		base = 10;
  800efe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	3c 2f                	cmp    $0x2f,%al
  800f0c:	7e 19                	jle    800f27 <strtol+0xc2>
  800f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f11:	8a 00                	mov    (%eax),%al
  800f13:	3c 39                	cmp    $0x39,%al
  800f15:	7f 10                	jg     800f27 <strtol+0xc2>
			dig = *s - '0';
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	0f be c0             	movsbl %al,%eax
  800f1f:	83 e8 30             	sub    $0x30,%eax
  800f22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f25:	eb 42                	jmp    800f69 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	3c 60                	cmp    $0x60,%al
  800f2e:	7e 19                	jle    800f49 <strtol+0xe4>
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	8a 00                	mov    (%eax),%al
  800f35:	3c 7a                	cmp    $0x7a,%al
  800f37:	7f 10                	jg     800f49 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	8a 00                	mov    (%eax),%al
  800f3e:	0f be c0             	movsbl %al,%eax
  800f41:	83 e8 57             	sub    $0x57,%eax
  800f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f47:	eb 20                	jmp    800f69 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	3c 40                	cmp    $0x40,%al
  800f50:	7e 39                	jle    800f8b <strtol+0x126>
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8a 00                	mov    (%eax),%al
  800f57:	3c 5a                	cmp    $0x5a,%al
  800f59:	7f 30                	jg     800f8b <strtol+0x126>
			dig = *s - 'A' + 10;
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	8a 00                	mov    (%eax),%al
  800f60:	0f be c0             	movsbl %al,%eax
  800f63:	83 e8 37             	sub    $0x37,%eax
  800f66:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f6c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f6f:	7d 19                	jge    800f8a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f71:	ff 45 08             	incl   0x8(%ebp)
  800f74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f77:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f7b:	89 c2                	mov    %eax,%edx
  800f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f80:	01 d0                	add    %edx,%eax
  800f82:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f85:	e9 7b ff ff ff       	jmp    800f05 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f8a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f8b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f8f:	74 08                	je     800f99 <strtol+0x134>
		*endptr = (char *) s;
  800f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f94:	8b 55 08             	mov    0x8(%ebp),%edx
  800f97:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f99:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f9d:	74 07                	je     800fa6 <strtol+0x141>
  800f9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa2:	f7 d8                	neg    %eax
  800fa4:	eb 03                	jmp    800fa9 <strtol+0x144>
  800fa6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fa9:	c9                   	leave  
  800faa:	c3                   	ret    

00800fab <ltostr>:

void
ltostr(long value, char *str)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fb8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fbf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fc3:	79 13                	jns    800fd8 <ltostr+0x2d>
	{
		neg = 1;
  800fc5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fd2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fd5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fe0:	99                   	cltd   
  800fe1:	f7 f9                	idiv   %ecx
  800fe3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fe6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe9:	8d 50 01             	lea    0x1(%eax),%edx
  800fec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fef:	89 c2                	mov    %eax,%edx
  800ff1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff4:	01 d0                	add    %edx,%eax
  800ff6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ff9:	83 c2 30             	add    $0x30,%edx
  800ffc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ffe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801001:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801006:	f7 e9                	imul   %ecx
  801008:	c1 fa 02             	sar    $0x2,%edx
  80100b:	89 c8                	mov    %ecx,%eax
  80100d:	c1 f8 1f             	sar    $0x1f,%eax
  801010:	29 c2                	sub    %eax,%edx
  801012:	89 d0                	mov    %edx,%eax
  801014:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801017:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80101b:	75 bb                	jne    800fd8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80101d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801024:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801027:	48                   	dec    %eax
  801028:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80102b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80102f:	74 3d                	je     80106e <ltostr+0xc3>
		start = 1 ;
  801031:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801038:	eb 34                	jmp    80106e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80103a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801040:	01 d0                	add    %edx,%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801047:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80104a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104d:	01 c2                	add    %eax,%edx
  80104f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801052:	8b 45 0c             	mov    0xc(%ebp),%eax
  801055:	01 c8                	add    %ecx,%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80105b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80105e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801061:	01 c2                	add    %eax,%edx
  801063:	8a 45 eb             	mov    -0x15(%ebp),%al
  801066:	88 02                	mov    %al,(%edx)
		start++ ;
  801068:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80106b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80106e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801071:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801074:	7c c4                	jl     80103a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801076:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801079:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107c:	01 d0                	add    %edx,%eax
  80107e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801081:	90                   	nop
  801082:	c9                   	leave  
  801083:	c3                   	ret    

00801084 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
  801087:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80108a:	ff 75 08             	pushl  0x8(%ebp)
  80108d:	e8 73 fa ff ff       	call   800b05 <strlen>
  801092:	83 c4 04             	add    $0x4,%esp
  801095:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801098:	ff 75 0c             	pushl  0xc(%ebp)
  80109b:	e8 65 fa ff ff       	call   800b05 <strlen>
  8010a0:	83 c4 04             	add    $0x4,%esp
  8010a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010b4:	eb 17                	jmp    8010cd <strcconcat+0x49>
		final[s] = str1[s] ;
  8010b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010bc:	01 c2                	add    %eax,%edx
  8010be:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	01 c8                	add    %ecx,%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010ca:	ff 45 fc             	incl   -0x4(%ebp)
  8010cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010d3:	7c e1                	jl     8010b6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010d5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010dc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010e3:	eb 1f                	jmp    801104 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e8:	8d 50 01             	lea    0x1(%eax),%edx
  8010eb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010ee:	89 c2                	mov    %eax,%edx
  8010f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f3:	01 c2                	add    %eax,%edx
  8010f5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fb:	01 c8                	add    %ecx,%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801101:	ff 45 f8             	incl   -0x8(%ebp)
  801104:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801107:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80110a:	7c d9                	jl     8010e5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80110c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80110f:	8b 45 10             	mov    0x10(%ebp),%eax
  801112:	01 d0                	add    %edx,%eax
  801114:	c6 00 00             	movb   $0x0,(%eax)
}
  801117:	90                   	nop
  801118:	c9                   	leave  
  801119:	c3                   	ret    

0080111a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80111d:	8b 45 14             	mov    0x14(%ebp),%eax
  801120:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801126:	8b 45 14             	mov    0x14(%ebp),%eax
  801129:	8b 00                	mov    (%eax),%eax
  80112b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801132:	8b 45 10             	mov    0x10(%ebp),%eax
  801135:	01 d0                	add    %edx,%eax
  801137:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80113d:	eb 0c                	jmp    80114b <strsplit+0x31>
			*string++ = 0;
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	8d 50 01             	lea    0x1(%eax),%edx
  801145:	89 55 08             	mov    %edx,0x8(%ebp)
  801148:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	8a 00                	mov    (%eax),%al
  801150:	84 c0                	test   %al,%al
  801152:	74 18                	je     80116c <strsplit+0x52>
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	0f be c0             	movsbl %al,%eax
  80115c:	50                   	push   %eax
  80115d:	ff 75 0c             	pushl  0xc(%ebp)
  801160:	e8 32 fb ff ff       	call   800c97 <strchr>
  801165:	83 c4 08             	add    $0x8,%esp
  801168:	85 c0                	test   %eax,%eax
  80116a:	75 d3                	jne    80113f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	8a 00                	mov    (%eax),%al
  801171:	84 c0                	test   %al,%al
  801173:	74 5a                	je     8011cf <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801175:	8b 45 14             	mov    0x14(%ebp),%eax
  801178:	8b 00                	mov    (%eax),%eax
  80117a:	83 f8 0f             	cmp    $0xf,%eax
  80117d:	75 07                	jne    801186 <strsplit+0x6c>
		{
			return 0;
  80117f:	b8 00 00 00 00       	mov    $0x0,%eax
  801184:	eb 66                	jmp    8011ec <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801186:	8b 45 14             	mov    0x14(%ebp),%eax
  801189:	8b 00                	mov    (%eax),%eax
  80118b:	8d 48 01             	lea    0x1(%eax),%ecx
  80118e:	8b 55 14             	mov    0x14(%ebp),%edx
  801191:	89 0a                	mov    %ecx,(%edx)
  801193:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80119a:	8b 45 10             	mov    0x10(%ebp),%eax
  80119d:	01 c2                	add    %eax,%edx
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011a4:	eb 03                	jmp    8011a9 <strsplit+0x8f>
			string++;
  8011a6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	84 c0                	test   %al,%al
  8011b0:	74 8b                	je     80113d <strsplit+0x23>
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	8a 00                	mov    (%eax),%al
  8011b7:	0f be c0             	movsbl %al,%eax
  8011ba:	50                   	push   %eax
  8011bb:	ff 75 0c             	pushl  0xc(%ebp)
  8011be:	e8 d4 fa ff ff       	call   800c97 <strchr>
  8011c3:	83 c4 08             	add    $0x8,%esp
  8011c6:	85 c0                	test   %eax,%eax
  8011c8:	74 dc                	je     8011a6 <strsplit+0x8c>
			string++;
	}
  8011ca:	e9 6e ff ff ff       	jmp    80113d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011cf:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d3:	8b 00                	mov    (%eax),%eax
  8011d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011df:	01 d0                	add    %edx,%eax
  8011e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011e7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011ec:	c9                   	leave  
  8011ed:	c3                   	ret    

008011ee <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8011f4:	83 ec 04             	sub    $0x4,%esp
  8011f7:	68 e8 20 80 00       	push   $0x8020e8
  8011fc:	68 3f 01 00 00       	push   $0x13f
  801201:	68 0a 21 80 00       	push   $0x80210a
  801206:	e8 a9 ef ff ff       	call   8001b4 <_panic>

0080120b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	57                   	push   %edi
  80120f:	56                   	push   %esi
  801210:	53                   	push   %ebx
  801211:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	8b 55 0c             	mov    0xc(%ebp),%edx
  80121a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80121d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801220:	8b 7d 18             	mov    0x18(%ebp),%edi
  801223:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801226:	cd 30                	int    $0x30
  801228:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80122b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80122e:	83 c4 10             	add    $0x10,%esp
  801231:	5b                   	pop    %ebx
  801232:	5e                   	pop    %esi
  801233:	5f                   	pop    %edi
  801234:	5d                   	pop    %ebp
  801235:	c3                   	ret    

00801236 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
  801239:	83 ec 04             	sub    $0x4,%esp
  80123c:	8b 45 10             	mov    0x10(%ebp),%eax
  80123f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801242:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	6a 00                	push   $0x0
  80124b:	6a 00                	push   $0x0
  80124d:	52                   	push   %edx
  80124e:	ff 75 0c             	pushl  0xc(%ebp)
  801251:	50                   	push   %eax
  801252:	6a 00                	push   $0x0
  801254:	e8 b2 ff ff ff       	call   80120b <syscall>
  801259:	83 c4 18             	add    $0x18,%esp
}
  80125c:	90                   	nop
  80125d:	c9                   	leave  
  80125e:	c3                   	ret    

0080125f <sys_cgetc>:

int
sys_cgetc(void)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801262:	6a 00                	push   $0x0
  801264:	6a 00                	push   $0x0
  801266:	6a 00                	push   $0x0
  801268:	6a 00                	push   $0x0
  80126a:	6a 00                	push   $0x0
  80126c:	6a 02                	push   $0x2
  80126e:	e8 98 ff ff ff       	call   80120b <syscall>
  801273:	83 c4 18             	add    $0x18,%esp
}
  801276:	c9                   	leave  
  801277:	c3                   	ret    

00801278 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80127b:	6a 00                	push   $0x0
  80127d:	6a 00                	push   $0x0
  80127f:	6a 00                	push   $0x0
  801281:	6a 00                	push   $0x0
  801283:	6a 00                	push   $0x0
  801285:	6a 03                	push   $0x3
  801287:	e8 7f ff ff ff       	call   80120b <syscall>
  80128c:	83 c4 18             	add    $0x18,%esp
}
  80128f:	90                   	nop
  801290:	c9                   	leave  
  801291:	c3                   	ret    

00801292 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801295:	6a 00                	push   $0x0
  801297:	6a 00                	push   $0x0
  801299:	6a 00                	push   $0x0
  80129b:	6a 00                	push   $0x0
  80129d:	6a 00                	push   $0x0
  80129f:	6a 04                	push   $0x4
  8012a1:	e8 65 ff ff ff       	call   80120b <syscall>
  8012a6:	83 c4 18             	add    $0x18,%esp
}
  8012a9:	90                   	nop
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    

008012ac <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b5:	6a 00                	push   $0x0
  8012b7:	6a 00                	push   $0x0
  8012b9:	6a 00                	push   $0x0
  8012bb:	52                   	push   %edx
  8012bc:	50                   	push   %eax
  8012bd:	6a 08                	push   $0x8
  8012bf:	e8 47 ff ff ff       	call   80120b <syscall>
  8012c4:	83 c4 18             	add    $0x18,%esp
}
  8012c7:	c9                   	leave  
  8012c8:	c3                   	ret    

008012c9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012c9:	55                   	push   %ebp
  8012ca:	89 e5                	mov    %esp,%ebp
  8012cc:	56                   	push   %esi
  8012cd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012ce:	8b 75 18             	mov    0x18(%ebp),%esi
  8012d1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	56                   	push   %esi
  8012de:	53                   	push   %ebx
  8012df:	51                   	push   %ecx
  8012e0:	52                   	push   %edx
  8012e1:	50                   	push   %eax
  8012e2:	6a 09                	push   $0x9
  8012e4:	e8 22 ff ff ff       	call   80120b <syscall>
  8012e9:	83 c4 18             	add    $0x18,%esp
}
  8012ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012ef:	5b                   	pop    %ebx
  8012f0:	5e                   	pop    %esi
  8012f1:	5d                   	pop    %ebp
  8012f2:	c3                   	ret    

008012f3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012f3:	55                   	push   %ebp
  8012f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fc:	6a 00                	push   $0x0
  8012fe:	6a 00                	push   $0x0
  801300:	6a 00                	push   $0x0
  801302:	52                   	push   %edx
  801303:	50                   	push   %eax
  801304:	6a 0a                	push   $0xa
  801306:	e8 00 ff ff ff       	call   80120b <syscall>
  80130b:	83 c4 18             	add    $0x18,%esp
}
  80130e:	c9                   	leave  
  80130f:	c3                   	ret    

00801310 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801313:	6a 00                	push   $0x0
  801315:	6a 00                	push   $0x0
  801317:	6a 00                	push   $0x0
  801319:	ff 75 0c             	pushl  0xc(%ebp)
  80131c:	ff 75 08             	pushl  0x8(%ebp)
  80131f:	6a 0b                	push   $0xb
  801321:	e8 e5 fe ff ff       	call   80120b <syscall>
  801326:	83 c4 18             	add    $0x18,%esp
}
  801329:	c9                   	leave  
  80132a:	c3                   	ret    

0080132b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80132e:	6a 00                	push   $0x0
  801330:	6a 00                	push   $0x0
  801332:	6a 00                	push   $0x0
  801334:	6a 00                	push   $0x0
  801336:	6a 00                	push   $0x0
  801338:	6a 0c                	push   $0xc
  80133a:	e8 cc fe ff ff       	call   80120b <syscall>
  80133f:	83 c4 18             	add    $0x18,%esp
}
  801342:	c9                   	leave  
  801343:	c3                   	ret    

00801344 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	6a 00                	push   $0x0
  801351:	6a 0d                	push   $0xd
  801353:	e8 b3 fe ff ff       	call   80120b <syscall>
  801358:	83 c4 18             	add    $0x18,%esp
}
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801360:	6a 00                	push   $0x0
  801362:	6a 00                	push   $0x0
  801364:	6a 00                	push   $0x0
  801366:	6a 00                	push   $0x0
  801368:	6a 00                	push   $0x0
  80136a:	6a 0e                	push   $0xe
  80136c:	e8 9a fe ff ff       	call   80120b <syscall>
  801371:	83 c4 18             	add    $0x18,%esp
}
  801374:	c9                   	leave  
  801375:	c3                   	ret    

00801376 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801379:	6a 00                	push   $0x0
  80137b:	6a 00                	push   $0x0
  80137d:	6a 00                	push   $0x0
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	6a 0f                	push   $0xf
  801385:	e8 81 fe ff ff       	call   80120b <syscall>
  80138a:	83 c4 18             	add    $0x18,%esp
}
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    

0080138f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801392:	6a 00                	push   $0x0
  801394:	6a 00                	push   $0x0
  801396:	6a 00                	push   $0x0
  801398:	6a 00                	push   $0x0
  80139a:	ff 75 08             	pushl  0x8(%ebp)
  80139d:	6a 10                	push   $0x10
  80139f:	e8 67 fe ff ff       	call   80120b <syscall>
  8013a4:	83 c4 18             	add    $0x18,%esp
}
  8013a7:	c9                   	leave  
  8013a8:	c3                   	ret    

008013a9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013a9:	55                   	push   %ebp
  8013aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 00                	push   $0x0
  8013b4:	6a 00                	push   $0x0
  8013b6:	6a 11                	push   $0x11
  8013b8:	e8 4e fe ff ff       	call   80120b <syscall>
  8013bd:	83 c4 18             	add    $0x18,%esp
}
  8013c0:	90                   	nop
  8013c1:	c9                   	leave  
  8013c2:	c3                   	ret    

008013c3 <sys_cputc>:

void
sys_cputc(const char c)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
  8013c6:	83 ec 04             	sub    $0x4,%esp
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013cf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	50                   	push   %eax
  8013dc:	6a 01                	push   $0x1
  8013de:	e8 28 fe ff ff       	call   80120b <syscall>
  8013e3:	83 c4 18             	add    $0x18,%esp
}
  8013e6:	90                   	nop
  8013e7:	c9                   	leave  
  8013e8:	c3                   	ret    

008013e9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 14                	push   $0x14
  8013f8:	e8 0e fe ff ff       	call   80120b <syscall>
  8013fd:	83 c4 18             	add    $0x18,%esp
}
  801400:	90                   	nop
  801401:	c9                   	leave  
  801402:	c3                   	ret    

00801403 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
  801406:	83 ec 04             	sub    $0x4,%esp
  801409:	8b 45 10             	mov    0x10(%ebp),%eax
  80140c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80140f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801412:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801416:	8b 45 08             	mov    0x8(%ebp),%eax
  801419:	6a 00                	push   $0x0
  80141b:	51                   	push   %ecx
  80141c:	52                   	push   %edx
  80141d:	ff 75 0c             	pushl  0xc(%ebp)
  801420:	50                   	push   %eax
  801421:	6a 15                	push   $0x15
  801423:	e8 e3 fd ff ff       	call   80120b <syscall>
  801428:	83 c4 18             	add    $0x18,%esp
}
  80142b:	c9                   	leave  
  80142c:	c3                   	ret    

0080142d <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801430:	8b 55 0c             	mov    0xc(%ebp),%edx
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	6a 00                	push   $0x0
  801438:	6a 00                	push   $0x0
  80143a:	6a 00                	push   $0x0
  80143c:	52                   	push   %edx
  80143d:	50                   	push   %eax
  80143e:	6a 16                	push   $0x16
  801440:	e8 c6 fd ff ff       	call   80120b <syscall>
  801445:	83 c4 18             	add    $0x18,%esp
}
  801448:	c9                   	leave  
  801449:	c3                   	ret    

0080144a <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80144d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801450:	8b 55 0c             	mov    0xc(%ebp),%edx
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	51                   	push   %ecx
  80145b:	52                   	push   %edx
  80145c:	50                   	push   %eax
  80145d:	6a 17                	push   $0x17
  80145f:	e8 a7 fd ff ff       	call   80120b <syscall>
  801464:	83 c4 18             	add    $0x18,%esp
}
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80146c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	6a 00                	push   $0x0
  801478:	52                   	push   %edx
  801479:	50                   	push   %eax
  80147a:	6a 18                	push   $0x18
  80147c:	e8 8a fd ff ff       	call   80120b <syscall>
  801481:	83 c4 18             	add    $0x18,%esp
}
  801484:	c9                   	leave  
  801485:	c3                   	ret    

00801486 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801486:	55                   	push   %ebp
  801487:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	6a 00                	push   $0x0
  80148e:	ff 75 14             	pushl  0x14(%ebp)
  801491:	ff 75 10             	pushl  0x10(%ebp)
  801494:	ff 75 0c             	pushl  0xc(%ebp)
  801497:	50                   	push   %eax
  801498:	6a 19                	push   $0x19
  80149a:	e8 6c fd ff ff       	call   80120b <syscall>
  80149f:	83 c4 18             	add    $0x18,%esp
}
  8014a2:	c9                   	leave  
  8014a3:	c3                   	ret    

008014a4 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 00                	push   $0x0
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 00                	push   $0x0
  8014b2:	50                   	push   %eax
  8014b3:	6a 1a                	push   $0x1a
  8014b5:	e8 51 fd ff ff       	call   80120b <syscall>
  8014ba:	83 c4 18             	add    $0x18,%esp
}
  8014bd:	90                   	nop
  8014be:	c9                   	leave  
  8014bf:	c3                   	ret    

008014c0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	50                   	push   %eax
  8014cf:	6a 1b                	push   $0x1b
  8014d1:	e8 35 fd ff ff       	call   80120b <syscall>
  8014d6:	83 c4 18             	add    $0x18,%esp
}
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    

008014db <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 05                	push   $0x5
  8014ea:	e8 1c fd ff ff       	call   80120b <syscall>
  8014ef:	83 c4 18             	add    $0x18,%esp
}
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 06                	push   $0x6
  801503:	e8 03 fd ff ff       	call   80120b <syscall>
  801508:	83 c4 18             	add    $0x18,%esp
}
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    

0080150d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 07                	push   $0x7
  80151c:	e8 ea fc ff ff       	call   80120b <syscall>
  801521:	83 c4 18             	add    $0x18,%esp
}
  801524:	c9                   	leave  
  801525:	c3                   	ret    

00801526 <sys_exit_env>:


void sys_exit_env(void)
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 1c                	push   $0x1c
  801535:	e8 d1 fc ff ff       	call   80120b <syscall>
  80153a:	83 c4 18             	add    $0x18,%esp
}
  80153d:	90                   	nop
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
  801543:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801546:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801549:	8d 50 04             	lea    0x4(%eax),%edx
  80154c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	52                   	push   %edx
  801556:	50                   	push   %eax
  801557:	6a 1d                	push   $0x1d
  801559:	e8 ad fc ff ff       	call   80120b <syscall>
  80155e:	83 c4 18             	add    $0x18,%esp
	return result;
  801561:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801564:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801567:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80156a:	89 01                	mov    %eax,(%ecx)
  80156c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80156f:	8b 45 08             	mov    0x8(%ebp),%eax
  801572:	c9                   	leave  
  801573:	c2 04 00             	ret    $0x4

00801576 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	ff 75 10             	pushl  0x10(%ebp)
  801580:	ff 75 0c             	pushl  0xc(%ebp)
  801583:	ff 75 08             	pushl  0x8(%ebp)
  801586:	6a 13                	push   $0x13
  801588:	e8 7e fc ff ff       	call   80120b <syscall>
  80158d:	83 c4 18             	add    $0x18,%esp
	return ;
  801590:	90                   	nop
}
  801591:	c9                   	leave  
  801592:	c3                   	ret    

00801593 <sys_rcr2>:
uint32 sys_rcr2()
{
  801593:	55                   	push   %ebp
  801594:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 1e                	push   $0x1e
  8015a2:	e8 64 fc ff ff       	call   80120b <syscall>
  8015a7:	83 c4 18             	add    $0x18,%esp
}
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    

008015ac <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
  8015af:	83 ec 04             	sub    $0x4,%esp
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015b8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	50                   	push   %eax
  8015c5:	6a 1f                	push   $0x1f
  8015c7:	e8 3f fc ff ff       	call   80120b <syscall>
  8015cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8015cf:	90                   	nop
}
  8015d0:	c9                   	leave  
  8015d1:	c3                   	ret    

008015d2 <rsttst>:
void rsttst()
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 21                	push   $0x21
  8015e1:	e8 25 fc ff ff       	call   80120b <syscall>
  8015e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8015e9:	90                   	nop
}
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	83 ec 04             	sub    $0x4,%esp
  8015f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8015f5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015f8:	8b 55 18             	mov    0x18(%ebp),%edx
  8015fb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015ff:	52                   	push   %edx
  801600:	50                   	push   %eax
  801601:	ff 75 10             	pushl  0x10(%ebp)
  801604:	ff 75 0c             	pushl  0xc(%ebp)
  801607:	ff 75 08             	pushl  0x8(%ebp)
  80160a:	6a 20                	push   $0x20
  80160c:	e8 fa fb ff ff       	call   80120b <syscall>
  801611:	83 c4 18             	add    $0x18,%esp
	return ;
  801614:	90                   	nop
}
  801615:	c9                   	leave  
  801616:	c3                   	ret    

00801617 <chktst>:
void chktst(uint32 n)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	ff 75 08             	pushl  0x8(%ebp)
  801625:	6a 22                	push   $0x22
  801627:	e8 df fb ff ff       	call   80120b <syscall>
  80162c:	83 c4 18             	add    $0x18,%esp
	return ;
  80162f:	90                   	nop
}
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <inctst>:

void inctst()
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 23                	push   $0x23
  801641:	e8 c5 fb ff ff       	call   80120b <syscall>
  801646:	83 c4 18             	add    $0x18,%esp
	return ;
  801649:	90                   	nop
}
  80164a:	c9                   	leave  
  80164b:	c3                   	ret    

0080164c <gettst>:
uint32 gettst()
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 24                	push   $0x24
  80165b:	e8 ab fb ff ff       	call   80120b <syscall>
  801660:	83 c4 18             	add    $0x18,%esp
}
  801663:	c9                   	leave  
  801664:	c3                   	ret    

00801665 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
  801668:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 25                	push   $0x25
  801677:	e8 8f fb ff ff       	call   80120b <syscall>
  80167c:	83 c4 18             	add    $0x18,%esp
  80167f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801682:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801686:	75 07                	jne    80168f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801688:	b8 01 00 00 00       	mov    $0x1,%eax
  80168d:	eb 05                	jmp    801694 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80168f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801694:	c9                   	leave  
  801695:	c3                   	ret    

00801696 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 25                	push   $0x25
  8016a8:	e8 5e fb ff ff       	call   80120b <syscall>
  8016ad:	83 c4 18             	add    $0x18,%esp
  8016b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016b3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016b7:	75 07                	jne    8016c0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8016be:	eb 05                	jmp    8016c5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    

008016c7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
  8016ca:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 25                	push   $0x25
  8016d9:	e8 2d fb ff ff       	call   80120b <syscall>
  8016de:	83 c4 18             	add    $0x18,%esp
  8016e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016e4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016e8:	75 07                	jne    8016f1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8016ef:	eb 05                	jmp    8016f6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    

008016f8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
  8016fb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 25                	push   $0x25
  80170a:	e8 fc fa ff ff       	call   80120b <syscall>
  80170f:	83 c4 18             	add    $0x18,%esp
  801712:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801715:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801719:	75 07                	jne    801722 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80171b:	b8 01 00 00 00       	mov    $0x1,%eax
  801720:	eb 05                	jmp    801727 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801722:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	ff 75 08             	pushl  0x8(%ebp)
  801737:	6a 26                	push   $0x26
  801739:	e8 cd fa ff ff       	call   80120b <syscall>
  80173e:	83 c4 18             	add    $0x18,%esp
	return ;
  801741:	90                   	nop
}
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
  801747:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801748:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80174b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80174e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	6a 00                	push   $0x0
  801756:	53                   	push   %ebx
  801757:	51                   	push   %ecx
  801758:	52                   	push   %edx
  801759:	50                   	push   %eax
  80175a:	6a 27                	push   $0x27
  80175c:	e8 aa fa ff ff       	call   80120b <syscall>
  801761:	83 c4 18             	add    $0x18,%esp
}
  801764:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80176c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	52                   	push   %edx
  801779:	50                   	push   %eax
  80177a:	6a 28                	push   $0x28
  80177c:	e8 8a fa ff ff       	call   80120b <syscall>
  801781:	83 c4 18             	add    $0x18,%esp
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801789:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80178c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	6a 00                	push   $0x0
  801794:	51                   	push   %ecx
  801795:	ff 75 10             	pushl  0x10(%ebp)
  801798:	52                   	push   %edx
  801799:	50                   	push   %eax
  80179a:	6a 29                	push   $0x29
  80179c:	e8 6a fa ff ff       	call   80120b <syscall>
  8017a1:	83 c4 18             	add    $0x18,%esp
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	ff 75 10             	pushl  0x10(%ebp)
  8017b0:	ff 75 0c             	pushl  0xc(%ebp)
  8017b3:	ff 75 08             	pushl  0x8(%ebp)
  8017b6:	6a 12                	push   $0x12
  8017b8:	e8 4e fa ff ff       	call   80120b <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c0:	90                   	nop
}
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8017c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	52                   	push   %edx
  8017d3:	50                   	push   %eax
  8017d4:	6a 2a                	push   $0x2a
  8017d6:	e8 30 fa ff ff       	call   80120b <syscall>
  8017db:	83 c4 18             	add    $0x18,%esp
	return;
  8017de:	90                   	nop
}
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8017e7:	83 ec 04             	sub    $0x4,%esp
  8017ea:	68 17 21 80 00       	push   $0x802117
  8017ef:	68 2e 01 00 00       	push   $0x12e
  8017f4:	68 2b 21 80 00       	push   $0x80212b
  8017f9:	e8 b6 e9 ff ff       	call   8001b4 <_panic>

008017fe <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801804:	83 ec 04             	sub    $0x4,%esp
  801807:	68 17 21 80 00       	push   $0x802117
  80180c:	68 35 01 00 00       	push   $0x135
  801811:	68 2b 21 80 00       	push   $0x80212b
  801816:	e8 99 e9 ff ff       	call   8001b4 <_panic>

0080181b <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801821:	83 ec 04             	sub    $0x4,%esp
  801824:	68 17 21 80 00       	push   $0x802117
  801829:	68 3b 01 00 00       	push   $0x13b
  80182e:	68 2b 21 80 00       	push   $0x80212b
  801833:	e8 7c e9 ff ff       	call   8001b4 <_panic>

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
