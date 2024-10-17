
obj/user/tst_free_1:     file format elf32-i386


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
  800031:	e8 1f 00 00 00       	call   800055 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	short b;
	int c;
};

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	}
	//	/*Dummy malloc to enforce the UHEAP initializations*/
	//	malloc(0);
	/*=================================================*/
#else
	panic("not handled!");
  800041:	83 ec 04             	sub    $0x4,%esp
  800044:	68 a0 1a 80 00       	push   $0x801aa0
  800049:	6a 21                	push   $0x21
  80004b:	68 ad 1a 80 00       	push   $0x801aad
  800050:	e8 4d 01 00 00       	call   8001a2 <_panic>

00800055 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800055:	55                   	push   %ebp
  800056:	89 e5                	mov    %esp,%ebp
  800058:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80005b:	e8 82 14 00 00       	call   8014e2 <sys_getenvindex>
  800060:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800063:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800066:	89 d0                	mov    %edx,%eax
  800068:	c1 e0 06             	shl    $0x6,%eax
  80006b:	29 d0                	sub    %edx,%eax
  80006d:	c1 e0 02             	shl    $0x2,%eax
  800070:	01 d0                	add    %edx,%eax
  800072:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800079:	01 c8                	add    %ecx,%eax
  80007b:	c1 e0 03             	shl    $0x3,%eax
  80007e:	01 d0                	add    %edx,%eax
  800080:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800087:	29 c2                	sub    %eax,%edx
  800089:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800090:	89 c2                	mov    %eax,%edx
  800092:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800098:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80009d:	a1 04 30 80 00       	mov    0x803004,%eax
  8000a2:	8a 40 20             	mov    0x20(%eax),%al
  8000a5:	84 c0                	test   %al,%al
  8000a7:	74 0d                	je     8000b6 <libmain+0x61>
		binaryname = myEnv->prog_name;
  8000a9:	a1 04 30 80 00       	mov    0x803004,%eax
  8000ae:	83 c0 20             	add    $0x20,%eax
  8000b1:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000ba:	7e 0a                	jle    8000c6 <libmain+0x71>
		binaryname = argv[0];
  8000bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000bf:	8b 00                	mov    (%eax),%eax
  8000c1:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000c6:	83 ec 08             	sub    $0x8,%esp
  8000c9:	ff 75 0c             	pushl  0xc(%ebp)
  8000cc:	ff 75 08             	pushl  0x8(%ebp)
  8000cf:	e8 64 ff ff ff       	call   800038 <_main>
  8000d4:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8000d7:	e8 8a 11 00 00       	call   801266 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	68 d8 1a 80 00       	push   $0x801ad8
  8000e4:	e8 76 03 00 00       	call   80045f <cprintf>
  8000e9:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000ec:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f1:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8000f7:	a1 04 30 80 00       	mov    0x803004,%eax
  8000fc:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800102:	83 ec 04             	sub    $0x4,%esp
  800105:	52                   	push   %edx
  800106:	50                   	push   %eax
  800107:	68 00 1b 80 00       	push   $0x801b00
  80010c:	e8 4e 03 00 00       	call   80045f <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800114:	a1 04 30 80 00       	mov    0x803004,%eax
  800119:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80011f:	a1 04 30 80 00       	mov    0x803004,%eax
  800124:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80012a:	a1 04 30 80 00       	mov    0x803004,%eax
  80012f:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800135:	51                   	push   %ecx
  800136:	52                   	push   %edx
  800137:	50                   	push   %eax
  800138:	68 28 1b 80 00       	push   $0x801b28
  80013d:	e8 1d 03 00 00       	call   80045f <cprintf>
  800142:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800145:	a1 04 30 80 00       	mov    0x803004,%eax
  80014a:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800150:	83 ec 08             	sub    $0x8,%esp
  800153:	50                   	push   %eax
  800154:	68 80 1b 80 00       	push   $0x801b80
  800159:	e8 01 03 00 00       	call   80045f <cprintf>
  80015e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	68 d8 1a 80 00       	push   $0x801ad8
  800169:	e8 f1 02 00 00       	call   80045f <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800171:	e8 0a 11 00 00       	call   801280 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800176:	e8 19 00 00 00       	call   800194 <exit>
}
  80017b:	90                   	nop
  80017c:	c9                   	leave  
  80017d:	c3                   	ret    

0080017e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80017e:	55                   	push   %ebp
  80017f:	89 e5                	mov    %esp,%ebp
  800181:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800184:	83 ec 0c             	sub    $0xc,%esp
  800187:	6a 00                	push   $0x0
  800189:	e8 20 13 00 00       	call   8014ae <sys_destroy_env>
  80018e:	83 c4 10             	add    $0x10,%esp
}
  800191:	90                   	nop
  800192:	c9                   	leave  
  800193:	c3                   	ret    

00800194 <exit>:

void
exit(void)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80019a:	e8 75 13 00 00       	call   801514 <sys_exit_env>
}
  80019f:	90                   	nop
  8001a0:	c9                   	leave  
  8001a1:	c3                   	ret    

008001a2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001a2:	55                   	push   %ebp
  8001a3:	89 e5                	mov    %esp,%ebp
  8001a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001a8:	8d 45 10             	lea    0x10(%ebp),%eax
  8001ab:	83 c0 04             	add    $0x4,%eax
  8001ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001b1:	a1 24 30 80 00       	mov    0x803024,%eax
  8001b6:	85 c0                	test   %eax,%eax
  8001b8:	74 16                	je     8001d0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001ba:	a1 24 30 80 00       	mov    0x803024,%eax
  8001bf:	83 ec 08             	sub    $0x8,%esp
  8001c2:	50                   	push   %eax
  8001c3:	68 94 1b 80 00       	push   $0x801b94
  8001c8:	e8 92 02 00 00       	call   80045f <cprintf>
  8001cd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001d0:	a1 00 30 80 00       	mov    0x803000,%eax
  8001d5:	ff 75 0c             	pushl  0xc(%ebp)
  8001d8:	ff 75 08             	pushl  0x8(%ebp)
  8001db:	50                   	push   %eax
  8001dc:	68 99 1b 80 00       	push   $0x801b99
  8001e1:	e8 79 02 00 00       	call   80045f <cprintf>
  8001e6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ec:	83 ec 08             	sub    $0x8,%esp
  8001ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8001f2:	50                   	push   %eax
  8001f3:	e8 fc 01 00 00       	call   8003f4 <vcprintf>
  8001f8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8001fb:	83 ec 08             	sub    $0x8,%esp
  8001fe:	6a 00                	push   $0x0
  800200:	68 b5 1b 80 00       	push   $0x801bb5
  800205:	e8 ea 01 00 00       	call   8003f4 <vcprintf>
  80020a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80020d:	e8 82 ff ff ff       	call   800194 <exit>

	// should not return here
	while (1) ;
  800212:	eb fe                	jmp    800212 <_panic+0x70>

00800214 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80021a:	a1 04 30 80 00       	mov    0x803004,%eax
  80021f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800225:	8b 45 0c             	mov    0xc(%ebp),%eax
  800228:	39 c2                	cmp    %eax,%edx
  80022a:	74 14                	je     800240 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80022c:	83 ec 04             	sub    $0x4,%esp
  80022f:	68 b8 1b 80 00       	push   $0x801bb8
  800234:	6a 26                	push   $0x26
  800236:	68 04 1c 80 00       	push   $0x801c04
  80023b:	e8 62 ff ff ff       	call   8001a2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800240:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800247:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80024e:	e9 c5 00 00 00       	jmp    800318 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800256:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80025d:	8b 45 08             	mov    0x8(%ebp),%eax
  800260:	01 d0                	add    %edx,%eax
  800262:	8b 00                	mov    (%eax),%eax
  800264:	85 c0                	test   %eax,%eax
  800266:	75 08                	jne    800270 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800268:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80026b:	e9 a5 00 00 00       	jmp    800315 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800270:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800277:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80027e:	eb 69                	jmp    8002e9 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800280:	a1 04 30 80 00       	mov    0x803004,%eax
  800285:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80028b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80028e:	89 d0                	mov    %edx,%eax
  800290:	01 c0                	add    %eax,%eax
  800292:	01 d0                	add    %edx,%eax
  800294:	c1 e0 03             	shl    $0x3,%eax
  800297:	01 c8                	add    %ecx,%eax
  800299:	8a 40 04             	mov    0x4(%eax),%al
  80029c:	84 c0                	test   %al,%al
  80029e:	75 46                	jne    8002e6 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002a0:	a1 04 30 80 00       	mov    0x803004,%eax
  8002a5:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8002ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002ae:	89 d0                	mov    %edx,%eax
  8002b0:	01 c0                	add    %eax,%eax
  8002b2:	01 d0                	add    %edx,%eax
  8002b4:	c1 e0 03             	shl    $0x3,%eax
  8002b7:	01 c8                	add    %ecx,%eax
  8002b9:	8b 00                	mov    (%eax),%eax
  8002bb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002c6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002cb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d5:	01 c8                	add    %ecx,%eax
  8002d7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002d9:	39 c2                	cmp    %eax,%edx
  8002db:	75 09                	jne    8002e6 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002dd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002e4:	eb 15                	jmp    8002fb <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002e6:	ff 45 e8             	incl   -0x18(%ebp)
  8002e9:	a1 04 30 80 00       	mov    0x803004,%eax
  8002ee:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8002f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002f7:	39 c2                	cmp    %eax,%edx
  8002f9:	77 85                	ja     800280 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8002fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8002ff:	75 14                	jne    800315 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800301:	83 ec 04             	sub    $0x4,%esp
  800304:	68 10 1c 80 00       	push   $0x801c10
  800309:	6a 3a                	push   $0x3a
  80030b:	68 04 1c 80 00       	push   $0x801c04
  800310:	e8 8d fe ff ff       	call   8001a2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800315:	ff 45 f0             	incl   -0x10(%ebp)
  800318:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80031b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80031e:	0f 8c 2f ff ff ff    	jl     800253 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800324:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80032b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800332:	eb 26                	jmp    80035a <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800334:	a1 04 30 80 00       	mov    0x803004,%eax
  800339:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80033f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800342:	89 d0                	mov    %edx,%eax
  800344:	01 c0                	add    %eax,%eax
  800346:	01 d0                	add    %edx,%eax
  800348:	c1 e0 03             	shl    $0x3,%eax
  80034b:	01 c8                	add    %ecx,%eax
  80034d:	8a 40 04             	mov    0x4(%eax),%al
  800350:	3c 01                	cmp    $0x1,%al
  800352:	75 03                	jne    800357 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800354:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800357:	ff 45 e0             	incl   -0x20(%ebp)
  80035a:	a1 04 30 80 00       	mov    0x803004,%eax
  80035f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800365:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800368:	39 c2                	cmp    %eax,%edx
  80036a:	77 c8                	ja     800334 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80036c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800372:	74 14                	je     800388 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800374:	83 ec 04             	sub    $0x4,%esp
  800377:	68 64 1c 80 00       	push   $0x801c64
  80037c:	6a 44                	push   $0x44
  80037e:	68 04 1c 80 00       	push   $0x801c04
  800383:	e8 1a fe ff ff       	call   8001a2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800388:	90                   	nop
  800389:	c9                   	leave  
  80038a:	c3                   	ret    

0080038b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80038b:	55                   	push   %ebp
  80038c:	89 e5                	mov    %esp,%ebp
  80038e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800391:	8b 45 0c             	mov    0xc(%ebp),%eax
  800394:	8b 00                	mov    (%eax),%eax
  800396:	8d 48 01             	lea    0x1(%eax),%ecx
  800399:	8b 55 0c             	mov    0xc(%ebp),%edx
  80039c:	89 0a                	mov    %ecx,(%edx)
  80039e:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a1:	88 d1                	mov    %dl,%cl
  8003a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ad:	8b 00                	mov    (%eax),%eax
  8003af:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b4:	75 2c                	jne    8003e2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003b6:	a0 08 30 80 00       	mov    0x803008,%al
  8003bb:	0f b6 c0             	movzbl %al,%eax
  8003be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c1:	8b 12                	mov    (%edx),%edx
  8003c3:	89 d1                	mov    %edx,%ecx
  8003c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c8:	83 c2 08             	add    $0x8,%edx
  8003cb:	83 ec 04             	sub    $0x4,%esp
  8003ce:	50                   	push   %eax
  8003cf:	51                   	push   %ecx
  8003d0:	52                   	push   %edx
  8003d1:	e8 4e 0e 00 00       	call   801224 <sys_cputs>
  8003d6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e5:	8b 40 04             	mov    0x4(%eax),%eax
  8003e8:	8d 50 01             	lea    0x1(%eax),%edx
  8003eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ee:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003f1:	90                   	nop
  8003f2:	c9                   	leave  
  8003f3:	c3                   	ret    

008003f4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
  8003f7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003fd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800404:	00 00 00 
	b.cnt = 0;
  800407:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80040e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800411:	ff 75 0c             	pushl  0xc(%ebp)
  800414:	ff 75 08             	pushl  0x8(%ebp)
  800417:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80041d:	50                   	push   %eax
  80041e:	68 8b 03 80 00       	push   $0x80038b
  800423:	e8 11 02 00 00       	call   800639 <vprintfmt>
  800428:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80042b:	a0 08 30 80 00       	mov    0x803008,%al
  800430:	0f b6 c0             	movzbl %al,%eax
  800433:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800439:	83 ec 04             	sub    $0x4,%esp
  80043c:	50                   	push   %eax
  80043d:	52                   	push   %edx
  80043e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800444:	83 c0 08             	add    $0x8,%eax
  800447:	50                   	push   %eax
  800448:	e8 d7 0d 00 00       	call   801224 <sys_cputs>
  80044d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800450:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800457:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80045d:	c9                   	leave  
  80045e:	c3                   	ret    

0080045f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80045f:	55                   	push   %ebp
  800460:	89 e5                	mov    %esp,%ebp
  800462:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800465:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  80046c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80046f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800472:	8b 45 08             	mov    0x8(%ebp),%eax
  800475:	83 ec 08             	sub    $0x8,%esp
  800478:	ff 75 f4             	pushl  -0xc(%ebp)
  80047b:	50                   	push   %eax
  80047c:	e8 73 ff ff ff       	call   8003f4 <vcprintf>
  800481:	83 c4 10             	add    $0x10,%esp
  800484:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800487:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80048a:	c9                   	leave  
  80048b:	c3                   	ret    

0080048c <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80048c:	55                   	push   %ebp
  80048d:	89 e5                	mov    %esp,%ebp
  80048f:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800492:	e8 cf 0d 00 00       	call   801266 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800497:	8d 45 0c             	lea    0xc(%ebp),%eax
  80049a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80049d:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a6:	50                   	push   %eax
  8004a7:	e8 48 ff ff ff       	call   8003f4 <vcprintf>
  8004ac:	83 c4 10             	add    $0x10,%esp
  8004af:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004b2:	e8 c9 0d 00 00       	call   801280 <sys_unlock_cons>
	return cnt;
  8004b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004ba:	c9                   	leave  
  8004bb:	c3                   	ret    

008004bc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004bc:	55                   	push   %ebp
  8004bd:	89 e5                	mov    %esp,%ebp
  8004bf:	53                   	push   %ebx
  8004c0:	83 ec 14             	sub    $0x14,%esp
  8004c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004cf:	8b 45 18             	mov    0x18(%ebp),%eax
  8004d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004da:	77 55                	ja     800531 <printnum+0x75>
  8004dc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004df:	72 05                	jb     8004e6 <printnum+0x2a>
  8004e1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004e4:	77 4b                	ja     800531 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004e6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004e9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004ec:	8b 45 18             	mov    0x18(%ebp),%eax
  8004ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f4:	52                   	push   %edx
  8004f5:	50                   	push   %eax
  8004f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f9:	ff 75 f0             	pushl  -0x10(%ebp)
  8004fc:	e8 27 13 00 00       	call   801828 <__udivdi3>
  800501:	83 c4 10             	add    $0x10,%esp
  800504:	83 ec 04             	sub    $0x4,%esp
  800507:	ff 75 20             	pushl  0x20(%ebp)
  80050a:	53                   	push   %ebx
  80050b:	ff 75 18             	pushl  0x18(%ebp)
  80050e:	52                   	push   %edx
  80050f:	50                   	push   %eax
  800510:	ff 75 0c             	pushl  0xc(%ebp)
  800513:	ff 75 08             	pushl  0x8(%ebp)
  800516:	e8 a1 ff ff ff       	call   8004bc <printnum>
  80051b:	83 c4 20             	add    $0x20,%esp
  80051e:	eb 1a                	jmp    80053a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	ff 75 0c             	pushl  0xc(%ebp)
  800526:	ff 75 20             	pushl  0x20(%ebp)
  800529:	8b 45 08             	mov    0x8(%ebp),%eax
  80052c:	ff d0                	call   *%eax
  80052e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800531:	ff 4d 1c             	decl   0x1c(%ebp)
  800534:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800538:	7f e6                	jg     800520 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80053a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80053d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800542:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800545:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800548:	53                   	push   %ebx
  800549:	51                   	push   %ecx
  80054a:	52                   	push   %edx
  80054b:	50                   	push   %eax
  80054c:	e8 e7 13 00 00       	call   801938 <__umoddi3>
  800551:	83 c4 10             	add    $0x10,%esp
  800554:	05 d4 1e 80 00       	add    $0x801ed4,%eax
  800559:	8a 00                	mov    (%eax),%al
  80055b:	0f be c0             	movsbl %al,%eax
  80055e:	83 ec 08             	sub    $0x8,%esp
  800561:	ff 75 0c             	pushl  0xc(%ebp)
  800564:	50                   	push   %eax
  800565:	8b 45 08             	mov    0x8(%ebp),%eax
  800568:	ff d0                	call   *%eax
  80056a:	83 c4 10             	add    $0x10,%esp
}
  80056d:	90                   	nop
  80056e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800571:	c9                   	leave  
  800572:	c3                   	ret    

00800573 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800573:	55                   	push   %ebp
  800574:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800576:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80057a:	7e 1c                	jle    800598 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80057c:	8b 45 08             	mov    0x8(%ebp),%eax
  80057f:	8b 00                	mov    (%eax),%eax
  800581:	8d 50 08             	lea    0x8(%eax),%edx
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	89 10                	mov    %edx,(%eax)
  800589:	8b 45 08             	mov    0x8(%ebp),%eax
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	83 e8 08             	sub    $0x8,%eax
  800591:	8b 50 04             	mov    0x4(%eax),%edx
  800594:	8b 00                	mov    (%eax),%eax
  800596:	eb 40                	jmp    8005d8 <getuint+0x65>
	else if (lflag)
  800598:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80059c:	74 1e                	je     8005bc <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80059e:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a1:	8b 00                	mov    (%eax),%eax
  8005a3:	8d 50 04             	lea    0x4(%eax),%edx
  8005a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a9:	89 10                	mov    %edx,(%eax)
  8005ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	83 e8 04             	sub    $0x4,%eax
  8005b3:	8b 00                	mov    (%eax),%eax
  8005b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ba:	eb 1c                	jmp    8005d8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bf:	8b 00                	mov    (%eax),%eax
  8005c1:	8d 50 04             	lea    0x4(%eax),%edx
  8005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c7:	89 10                	mov    %edx,(%eax)
  8005c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	83 e8 04             	sub    $0x4,%eax
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005d8:	5d                   	pop    %ebp
  8005d9:	c3                   	ret    

008005da <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005da:	55                   	push   %ebp
  8005db:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005dd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005e1:	7e 1c                	jle    8005ff <getint+0x25>
		return va_arg(*ap, long long);
  8005e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	8d 50 08             	lea    0x8(%eax),%edx
  8005eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ee:	89 10                	mov    %edx,(%eax)
  8005f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f3:	8b 00                	mov    (%eax),%eax
  8005f5:	83 e8 08             	sub    $0x8,%eax
  8005f8:	8b 50 04             	mov    0x4(%eax),%edx
  8005fb:	8b 00                	mov    (%eax),%eax
  8005fd:	eb 38                	jmp    800637 <getint+0x5d>
	else if (lflag)
  8005ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800603:	74 1a                	je     80061f <getint+0x45>
		return va_arg(*ap, long);
  800605:	8b 45 08             	mov    0x8(%ebp),%eax
  800608:	8b 00                	mov    (%eax),%eax
  80060a:	8d 50 04             	lea    0x4(%eax),%edx
  80060d:	8b 45 08             	mov    0x8(%ebp),%eax
  800610:	89 10                	mov    %edx,(%eax)
  800612:	8b 45 08             	mov    0x8(%ebp),%eax
  800615:	8b 00                	mov    (%eax),%eax
  800617:	83 e8 04             	sub    $0x4,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	99                   	cltd   
  80061d:	eb 18                	jmp    800637 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80061f:	8b 45 08             	mov    0x8(%ebp),%eax
  800622:	8b 00                	mov    (%eax),%eax
  800624:	8d 50 04             	lea    0x4(%eax),%edx
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	89 10                	mov    %edx,(%eax)
  80062c:	8b 45 08             	mov    0x8(%ebp),%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	83 e8 04             	sub    $0x4,%eax
  800634:	8b 00                	mov    (%eax),%eax
  800636:	99                   	cltd   
}
  800637:	5d                   	pop    %ebp
  800638:	c3                   	ret    

00800639 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800639:	55                   	push   %ebp
  80063a:	89 e5                	mov    %esp,%ebp
  80063c:	56                   	push   %esi
  80063d:	53                   	push   %ebx
  80063e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800641:	eb 17                	jmp    80065a <vprintfmt+0x21>
			if (ch == '\0')
  800643:	85 db                	test   %ebx,%ebx
  800645:	0f 84 c1 03 00 00    	je     800a0c <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80064b:	83 ec 08             	sub    $0x8,%esp
  80064e:	ff 75 0c             	pushl  0xc(%ebp)
  800651:	53                   	push   %ebx
  800652:	8b 45 08             	mov    0x8(%ebp),%eax
  800655:	ff d0                	call   *%eax
  800657:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80065a:	8b 45 10             	mov    0x10(%ebp),%eax
  80065d:	8d 50 01             	lea    0x1(%eax),%edx
  800660:	89 55 10             	mov    %edx,0x10(%ebp)
  800663:	8a 00                	mov    (%eax),%al
  800665:	0f b6 d8             	movzbl %al,%ebx
  800668:	83 fb 25             	cmp    $0x25,%ebx
  80066b:	75 d6                	jne    800643 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80066d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800671:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800678:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80067f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800686:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80068d:	8b 45 10             	mov    0x10(%ebp),%eax
  800690:	8d 50 01             	lea    0x1(%eax),%edx
  800693:	89 55 10             	mov    %edx,0x10(%ebp)
  800696:	8a 00                	mov    (%eax),%al
  800698:	0f b6 d8             	movzbl %al,%ebx
  80069b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80069e:	83 f8 5b             	cmp    $0x5b,%eax
  8006a1:	0f 87 3d 03 00 00    	ja     8009e4 <vprintfmt+0x3ab>
  8006a7:	8b 04 85 f8 1e 80 00 	mov    0x801ef8(,%eax,4),%eax
  8006ae:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006b0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006b4:	eb d7                	jmp    80068d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006b6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006ba:	eb d1                	jmp    80068d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006bc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c6:	89 d0                	mov    %edx,%eax
  8006c8:	c1 e0 02             	shl    $0x2,%eax
  8006cb:	01 d0                	add    %edx,%eax
  8006cd:	01 c0                	add    %eax,%eax
  8006cf:	01 d8                	add    %ebx,%eax
  8006d1:	83 e8 30             	sub    $0x30,%eax
  8006d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8006da:	8a 00                	mov    (%eax),%al
  8006dc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006df:	83 fb 2f             	cmp    $0x2f,%ebx
  8006e2:	7e 3e                	jle    800722 <vprintfmt+0xe9>
  8006e4:	83 fb 39             	cmp    $0x39,%ebx
  8006e7:	7f 39                	jg     800722 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006ec:	eb d5                	jmp    8006c3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f1:	83 c0 04             	add    $0x4,%eax
  8006f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fa:	83 e8 04             	sub    $0x4,%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800702:	eb 1f                	jmp    800723 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800704:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800708:	79 83                	jns    80068d <vprintfmt+0x54>
				width = 0;
  80070a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800711:	e9 77 ff ff ff       	jmp    80068d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800716:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80071d:	e9 6b ff ff ff       	jmp    80068d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800722:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800723:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800727:	0f 89 60 ff ff ff    	jns    80068d <vprintfmt+0x54>
				width = precision, precision = -1;
  80072d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800730:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800733:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80073a:	e9 4e ff ff ff       	jmp    80068d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80073f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800742:	e9 46 ff ff ff       	jmp    80068d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	83 c0 04             	add    $0x4,%eax
  80074d:	89 45 14             	mov    %eax,0x14(%ebp)
  800750:	8b 45 14             	mov    0x14(%ebp),%eax
  800753:	83 e8 04             	sub    $0x4,%eax
  800756:	8b 00                	mov    (%eax),%eax
  800758:	83 ec 08             	sub    $0x8,%esp
  80075b:	ff 75 0c             	pushl  0xc(%ebp)
  80075e:	50                   	push   %eax
  80075f:	8b 45 08             	mov    0x8(%ebp),%eax
  800762:	ff d0                	call   *%eax
  800764:	83 c4 10             	add    $0x10,%esp
			break;
  800767:	e9 9b 02 00 00       	jmp    800a07 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	83 c0 04             	add    $0x4,%eax
  800772:	89 45 14             	mov    %eax,0x14(%ebp)
  800775:	8b 45 14             	mov    0x14(%ebp),%eax
  800778:	83 e8 04             	sub    $0x4,%eax
  80077b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80077d:	85 db                	test   %ebx,%ebx
  80077f:	79 02                	jns    800783 <vprintfmt+0x14a>
				err = -err;
  800781:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800783:	83 fb 64             	cmp    $0x64,%ebx
  800786:	7f 0b                	jg     800793 <vprintfmt+0x15a>
  800788:	8b 34 9d 40 1d 80 00 	mov    0x801d40(,%ebx,4),%esi
  80078f:	85 f6                	test   %esi,%esi
  800791:	75 19                	jne    8007ac <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800793:	53                   	push   %ebx
  800794:	68 e5 1e 80 00       	push   $0x801ee5
  800799:	ff 75 0c             	pushl  0xc(%ebp)
  80079c:	ff 75 08             	pushl  0x8(%ebp)
  80079f:	e8 70 02 00 00       	call   800a14 <printfmt>
  8007a4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007a7:	e9 5b 02 00 00       	jmp    800a07 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007ac:	56                   	push   %esi
  8007ad:	68 ee 1e 80 00       	push   $0x801eee
  8007b2:	ff 75 0c             	pushl  0xc(%ebp)
  8007b5:	ff 75 08             	pushl  0x8(%ebp)
  8007b8:	e8 57 02 00 00       	call   800a14 <printfmt>
  8007bd:	83 c4 10             	add    $0x10,%esp
			break;
  8007c0:	e9 42 02 00 00       	jmp    800a07 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	83 c0 04             	add    $0x4,%eax
  8007cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	83 e8 04             	sub    $0x4,%eax
  8007d4:	8b 30                	mov    (%eax),%esi
  8007d6:	85 f6                	test   %esi,%esi
  8007d8:	75 05                	jne    8007df <vprintfmt+0x1a6>
				p = "(null)";
  8007da:	be f1 1e 80 00       	mov    $0x801ef1,%esi
			if (width > 0 && padc != '-')
  8007df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e3:	7e 6d                	jle    800852 <vprintfmt+0x219>
  8007e5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007e9:	74 67                	je     800852 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	50                   	push   %eax
  8007f2:	56                   	push   %esi
  8007f3:	e8 1e 03 00 00       	call   800b16 <strnlen>
  8007f8:	83 c4 10             	add    $0x10,%esp
  8007fb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007fe:	eb 16                	jmp    800816 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800800:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800804:	83 ec 08             	sub    $0x8,%esp
  800807:	ff 75 0c             	pushl  0xc(%ebp)
  80080a:	50                   	push   %eax
  80080b:	8b 45 08             	mov    0x8(%ebp),%eax
  80080e:	ff d0                	call   *%eax
  800810:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800813:	ff 4d e4             	decl   -0x1c(%ebp)
  800816:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80081a:	7f e4                	jg     800800 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80081c:	eb 34                	jmp    800852 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80081e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800822:	74 1c                	je     800840 <vprintfmt+0x207>
  800824:	83 fb 1f             	cmp    $0x1f,%ebx
  800827:	7e 05                	jle    80082e <vprintfmt+0x1f5>
  800829:	83 fb 7e             	cmp    $0x7e,%ebx
  80082c:	7e 12                	jle    800840 <vprintfmt+0x207>
					putch('?', putdat);
  80082e:	83 ec 08             	sub    $0x8,%esp
  800831:	ff 75 0c             	pushl  0xc(%ebp)
  800834:	6a 3f                	push   $0x3f
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	ff d0                	call   *%eax
  80083b:	83 c4 10             	add    $0x10,%esp
  80083e:	eb 0f                	jmp    80084f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800840:	83 ec 08             	sub    $0x8,%esp
  800843:	ff 75 0c             	pushl  0xc(%ebp)
  800846:	53                   	push   %ebx
  800847:	8b 45 08             	mov    0x8(%ebp),%eax
  80084a:	ff d0                	call   *%eax
  80084c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80084f:	ff 4d e4             	decl   -0x1c(%ebp)
  800852:	89 f0                	mov    %esi,%eax
  800854:	8d 70 01             	lea    0x1(%eax),%esi
  800857:	8a 00                	mov    (%eax),%al
  800859:	0f be d8             	movsbl %al,%ebx
  80085c:	85 db                	test   %ebx,%ebx
  80085e:	74 24                	je     800884 <vprintfmt+0x24b>
  800860:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800864:	78 b8                	js     80081e <vprintfmt+0x1e5>
  800866:	ff 4d e0             	decl   -0x20(%ebp)
  800869:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80086d:	79 af                	jns    80081e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80086f:	eb 13                	jmp    800884 <vprintfmt+0x24b>
				putch(' ', putdat);
  800871:	83 ec 08             	sub    $0x8,%esp
  800874:	ff 75 0c             	pushl  0xc(%ebp)
  800877:	6a 20                	push   $0x20
  800879:	8b 45 08             	mov    0x8(%ebp),%eax
  80087c:	ff d0                	call   *%eax
  80087e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800881:	ff 4d e4             	decl   -0x1c(%ebp)
  800884:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800888:	7f e7                	jg     800871 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80088a:	e9 78 01 00 00       	jmp    800a07 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80088f:	83 ec 08             	sub    $0x8,%esp
  800892:	ff 75 e8             	pushl  -0x18(%ebp)
  800895:	8d 45 14             	lea    0x14(%ebp),%eax
  800898:	50                   	push   %eax
  800899:	e8 3c fd ff ff       	call   8005da <getint>
  80089e:	83 c4 10             	add    $0x10,%esp
  8008a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008ad:	85 d2                	test   %edx,%edx
  8008af:	79 23                	jns    8008d4 <vprintfmt+0x29b>
				putch('-', putdat);
  8008b1:	83 ec 08             	sub    $0x8,%esp
  8008b4:	ff 75 0c             	pushl  0xc(%ebp)
  8008b7:	6a 2d                	push   $0x2d
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	ff d0                	call   *%eax
  8008be:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c7:	f7 d8                	neg    %eax
  8008c9:	83 d2 00             	adc    $0x0,%edx
  8008cc:	f7 da                	neg    %edx
  8008ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008d4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008db:	e9 bc 00 00 00       	jmp    80099c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008e0:	83 ec 08             	sub    $0x8,%esp
  8008e3:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e6:	8d 45 14             	lea    0x14(%ebp),%eax
  8008e9:	50                   	push   %eax
  8008ea:	e8 84 fc ff ff       	call   800573 <getuint>
  8008ef:	83 c4 10             	add    $0x10,%esp
  8008f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008f8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008ff:	e9 98 00 00 00       	jmp    80099c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800904:	83 ec 08             	sub    $0x8,%esp
  800907:	ff 75 0c             	pushl  0xc(%ebp)
  80090a:	6a 58                	push   $0x58
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	ff d0                	call   *%eax
  800911:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	ff 75 0c             	pushl  0xc(%ebp)
  80091a:	6a 58                	push   $0x58
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	ff d0                	call   *%eax
  800921:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	ff 75 0c             	pushl  0xc(%ebp)
  80092a:	6a 58                	push   $0x58
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	ff d0                	call   *%eax
  800931:	83 c4 10             	add    $0x10,%esp
			break;
  800934:	e9 ce 00 00 00       	jmp    800a07 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800939:	83 ec 08             	sub    $0x8,%esp
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	6a 30                	push   $0x30
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	ff d0                	call   *%eax
  800946:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800949:	83 ec 08             	sub    $0x8,%esp
  80094c:	ff 75 0c             	pushl  0xc(%ebp)
  80094f:	6a 78                	push   $0x78
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	ff d0                	call   *%eax
  800956:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800959:	8b 45 14             	mov    0x14(%ebp),%eax
  80095c:	83 c0 04             	add    $0x4,%eax
  80095f:	89 45 14             	mov    %eax,0x14(%ebp)
  800962:	8b 45 14             	mov    0x14(%ebp),%eax
  800965:	83 e8 04             	sub    $0x4,%eax
  800968:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80096a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80096d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800974:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80097b:	eb 1f                	jmp    80099c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	ff 75 e8             	pushl  -0x18(%ebp)
  800983:	8d 45 14             	lea    0x14(%ebp),%eax
  800986:	50                   	push   %eax
  800987:	e8 e7 fb ff ff       	call   800573 <getuint>
  80098c:	83 c4 10             	add    $0x10,%esp
  80098f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800992:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800995:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80099c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009a3:	83 ec 04             	sub    $0x4,%esp
  8009a6:	52                   	push   %edx
  8009a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009aa:	50                   	push   %eax
  8009ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8009b1:	ff 75 0c             	pushl  0xc(%ebp)
  8009b4:	ff 75 08             	pushl  0x8(%ebp)
  8009b7:	e8 00 fb ff ff       	call   8004bc <printnum>
  8009bc:	83 c4 20             	add    $0x20,%esp
			break;
  8009bf:	eb 46                	jmp    800a07 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009c1:	83 ec 08             	sub    $0x8,%esp
  8009c4:	ff 75 0c             	pushl  0xc(%ebp)
  8009c7:	53                   	push   %ebx
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	ff d0                	call   *%eax
  8009cd:	83 c4 10             	add    $0x10,%esp
			break;
  8009d0:	eb 35                	jmp    800a07 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009d2:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8009d9:	eb 2c                	jmp    800a07 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009db:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8009e2:	eb 23                	jmp    800a07 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009e4:	83 ec 08             	sub    $0x8,%esp
  8009e7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ea:	6a 25                	push   $0x25
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	ff d0                	call   *%eax
  8009f1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009f4:	ff 4d 10             	decl   0x10(%ebp)
  8009f7:	eb 03                	jmp    8009fc <vprintfmt+0x3c3>
  8009f9:	ff 4d 10             	decl   0x10(%ebp)
  8009fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ff:	48                   	dec    %eax
  800a00:	8a 00                	mov    (%eax),%al
  800a02:	3c 25                	cmp    $0x25,%al
  800a04:	75 f3                	jne    8009f9 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a06:	90                   	nop
		}
	}
  800a07:	e9 35 fc ff ff       	jmp    800641 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a0c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a10:	5b                   	pop    %ebx
  800a11:	5e                   	pop    %esi
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a1a:	8d 45 10             	lea    0x10(%ebp),%eax
  800a1d:	83 c0 04             	add    $0x4,%eax
  800a20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a23:	8b 45 10             	mov    0x10(%ebp),%eax
  800a26:	ff 75 f4             	pushl  -0xc(%ebp)
  800a29:	50                   	push   %eax
  800a2a:	ff 75 0c             	pushl  0xc(%ebp)
  800a2d:	ff 75 08             	pushl  0x8(%ebp)
  800a30:	e8 04 fc ff ff       	call   800639 <vprintfmt>
  800a35:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a38:	90                   	nop
  800a39:	c9                   	leave  
  800a3a:	c3                   	ret    

00800a3b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a3b:	55                   	push   %ebp
  800a3c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a41:	8b 40 08             	mov    0x8(%eax),%eax
  800a44:	8d 50 01             	lea    0x1(%eax),%edx
  800a47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a50:	8b 10                	mov    (%eax),%edx
  800a52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a55:	8b 40 04             	mov    0x4(%eax),%eax
  800a58:	39 c2                	cmp    %eax,%edx
  800a5a:	73 12                	jae    800a6e <sprintputch+0x33>
		*b->buf++ = ch;
  800a5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5f:	8b 00                	mov    (%eax),%eax
  800a61:	8d 48 01             	lea    0x1(%eax),%ecx
  800a64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a67:	89 0a                	mov    %ecx,(%edx)
  800a69:	8b 55 08             	mov    0x8(%ebp),%edx
  800a6c:	88 10                	mov    %dl,(%eax)
}
  800a6e:	90                   	nop
  800a6f:	5d                   	pop    %ebp
  800a70:	c3                   	ret    

00800a71 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a71:	55                   	push   %ebp
  800a72:	89 e5                	mov    %esp,%ebp
  800a74:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a80:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	01 d0                	add    %edx,%eax
  800a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a96:	74 06                	je     800a9e <vsnprintf+0x2d>
  800a98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a9c:	7f 07                	jg     800aa5 <vsnprintf+0x34>
		return -E_INVAL;
  800a9e:	b8 03 00 00 00       	mov    $0x3,%eax
  800aa3:	eb 20                	jmp    800ac5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800aa5:	ff 75 14             	pushl  0x14(%ebp)
  800aa8:	ff 75 10             	pushl  0x10(%ebp)
  800aab:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aae:	50                   	push   %eax
  800aaf:	68 3b 0a 80 00       	push   $0x800a3b
  800ab4:	e8 80 fb ff ff       	call   800639 <vprintfmt>
  800ab9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800abc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800abf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ac5:	c9                   	leave  
  800ac6:	c3                   	ret    

00800ac7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ac7:	55                   	push   %ebp
  800ac8:	89 e5                	mov    %esp,%ebp
  800aca:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800acd:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad0:	83 c0 04             	add    $0x4,%eax
  800ad3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ad6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad9:	ff 75 f4             	pushl  -0xc(%ebp)
  800adc:	50                   	push   %eax
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	ff 75 08             	pushl  0x8(%ebp)
  800ae3:	e8 89 ff ff ff       	call   800a71 <vsnprintf>
  800ae8:	83 c4 10             	add    $0x10,%esp
  800aeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800af1:	c9                   	leave  
  800af2:	c3                   	ret    

00800af3 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800af3:	55                   	push   %ebp
  800af4:	89 e5                	mov    %esp,%ebp
  800af6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800af9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b00:	eb 06                	jmp    800b08 <strlen+0x15>
		n++;
  800b02:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b05:	ff 45 08             	incl   0x8(%ebp)
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	8a 00                	mov    (%eax),%al
  800b0d:	84 c0                	test   %al,%al
  800b0f:	75 f1                	jne    800b02 <strlen+0xf>
		n++;
	return n;
  800b11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b14:	c9                   	leave  
  800b15:	c3                   	ret    

00800b16 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b23:	eb 09                	jmp    800b2e <strnlen+0x18>
		n++;
  800b25:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b28:	ff 45 08             	incl   0x8(%ebp)
  800b2b:	ff 4d 0c             	decl   0xc(%ebp)
  800b2e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b32:	74 09                	je     800b3d <strnlen+0x27>
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8a 00                	mov    (%eax),%al
  800b39:	84 c0                	test   %al,%al
  800b3b:	75 e8                	jne    800b25 <strnlen+0xf>
		n++;
	return n;
  800b3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b40:	c9                   	leave  
  800b41:	c3                   	ret    

00800b42 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
  800b45:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b4e:	90                   	nop
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	8d 50 01             	lea    0x1(%eax),%edx
  800b55:	89 55 08             	mov    %edx,0x8(%ebp)
  800b58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b5e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b61:	8a 12                	mov    (%edx),%dl
  800b63:	88 10                	mov    %dl,(%eax)
  800b65:	8a 00                	mov    (%eax),%al
  800b67:	84 c0                	test   %al,%al
  800b69:	75 e4                	jne    800b4f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b6e:	c9                   	leave  
  800b6f:	c3                   	ret    

00800b70 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b83:	eb 1f                	jmp    800ba4 <strncpy+0x34>
		*dst++ = *src;
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	8d 50 01             	lea    0x1(%eax),%edx
  800b8b:	89 55 08             	mov    %edx,0x8(%ebp)
  800b8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b91:	8a 12                	mov    (%edx),%dl
  800b93:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b98:	8a 00                	mov    (%eax),%al
  800b9a:	84 c0                	test   %al,%al
  800b9c:	74 03                	je     800ba1 <strncpy+0x31>
			src++;
  800b9e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ba1:	ff 45 fc             	incl   -0x4(%ebp)
  800ba4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ba7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800baa:	72 d9                	jb     800b85 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800bac:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800baf:	c9                   	leave  
  800bb0:	c3                   	ret    

00800bb1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
  800bb4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bc1:	74 30                	je     800bf3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bc3:	eb 16                	jmp    800bdb <strlcpy+0x2a>
			*dst++ = *src++;
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	8d 50 01             	lea    0x1(%eax),%edx
  800bcb:	89 55 08             	mov    %edx,0x8(%ebp)
  800bce:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bd4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bd7:	8a 12                	mov    (%edx),%dl
  800bd9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bdb:	ff 4d 10             	decl   0x10(%ebp)
  800bde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800be2:	74 09                	je     800bed <strlcpy+0x3c>
  800be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be7:	8a 00                	mov    (%eax),%al
  800be9:	84 c0                	test   %al,%al
  800beb:	75 d8                	jne    800bc5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf9:	29 c2                	sub    %eax,%edx
  800bfb:	89 d0                	mov    %edx,%eax
}
  800bfd:	c9                   	leave  
  800bfe:	c3                   	ret    

00800bff <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c02:	eb 06                	jmp    800c0a <strcmp+0xb>
		p++, q++;
  800c04:	ff 45 08             	incl   0x8(%ebp)
  800c07:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	8a 00                	mov    (%eax),%al
  800c0f:	84 c0                	test   %al,%al
  800c11:	74 0e                	je     800c21 <strcmp+0x22>
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	8a 10                	mov    (%eax),%dl
  800c18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1b:	8a 00                	mov    (%eax),%al
  800c1d:	38 c2                	cmp    %al,%dl
  800c1f:	74 e3                	je     800c04 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	8a 00                	mov    (%eax),%al
  800c26:	0f b6 d0             	movzbl %al,%edx
  800c29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2c:	8a 00                	mov    (%eax),%al
  800c2e:	0f b6 c0             	movzbl %al,%eax
  800c31:	29 c2                	sub    %eax,%edx
  800c33:	89 d0                	mov    %edx,%eax
}
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    

00800c37 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c3a:	eb 09                	jmp    800c45 <strncmp+0xe>
		n--, p++, q++;
  800c3c:	ff 4d 10             	decl   0x10(%ebp)
  800c3f:	ff 45 08             	incl   0x8(%ebp)
  800c42:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c49:	74 17                	je     800c62 <strncmp+0x2b>
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	8a 00                	mov    (%eax),%al
  800c50:	84 c0                	test   %al,%al
  800c52:	74 0e                	je     800c62 <strncmp+0x2b>
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	8a 10                	mov    (%eax),%dl
  800c59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5c:	8a 00                	mov    (%eax),%al
  800c5e:	38 c2                	cmp    %al,%dl
  800c60:	74 da                	je     800c3c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c66:	75 07                	jne    800c6f <strncmp+0x38>
		return 0;
  800c68:	b8 00 00 00 00       	mov    $0x0,%eax
  800c6d:	eb 14                	jmp    800c83 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	8a 00                	mov    (%eax),%al
  800c74:	0f b6 d0             	movzbl %al,%edx
  800c77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7a:	8a 00                	mov    (%eax),%al
  800c7c:	0f b6 c0             	movzbl %al,%eax
  800c7f:	29 c2                	sub    %eax,%edx
  800c81:	89 d0                	mov    %edx,%eax
}
  800c83:	5d                   	pop    %ebp
  800c84:	c3                   	ret    

00800c85 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	83 ec 04             	sub    $0x4,%esp
  800c8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c91:	eb 12                	jmp    800ca5 <strchr+0x20>
		if (*s == c)
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	8a 00                	mov    (%eax),%al
  800c98:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c9b:	75 05                	jne    800ca2 <strchr+0x1d>
			return (char *) s;
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	eb 11                	jmp    800cb3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ca2:	ff 45 08             	incl   0x8(%ebp)
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	8a 00                	mov    (%eax),%al
  800caa:	84 c0                	test   %al,%al
  800cac:	75 e5                	jne    800c93 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb3:	c9                   	leave  
  800cb4:	c3                   	ret    

00800cb5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	83 ec 04             	sub    $0x4,%esp
  800cbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbe:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cc1:	eb 0d                	jmp    800cd0 <strfind+0x1b>
		if (*s == c)
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	8a 00                	mov    (%eax),%al
  800cc8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ccb:	74 0e                	je     800cdb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ccd:	ff 45 08             	incl   0x8(%ebp)
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	8a 00                	mov    (%eax),%al
  800cd5:	84 c0                	test   %al,%al
  800cd7:	75 ea                	jne    800cc3 <strfind+0xe>
  800cd9:	eb 01                	jmp    800cdc <strfind+0x27>
		if (*s == c)
			break;
  800cdb:	90                   	nop
	return (char *) s;
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cdf:	c9                   	leave  
  800ce0:	c3                   	ret    

00800ce1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ced:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cf3:	eb 0e                	jmp    800d03 <memset+0x22>
		*p++ = c;
  800cf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf8:	8d 50 01             	lea    0x1(%eax),%edx
  800cfb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800cfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d01:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d03:	ff 4d f8             	decl   -0x8(%ebp)
  800d06:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d0a:	79 e9                	jns    800cf5 <memset+0x14>
		*p++ = c;

	return v;
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d0f:	c9                   	leave  
  800d10:	c3                   	ret    

00800d11 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d11:	55                   	push   %ebp
  800d12:	89 e5                	mov    %esp,%ebp
  800d14:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d23:	eb 16                	jmp    800d3b <memcpy+0x2a>
		*d++ = *s++;
  800d25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d28:	8d 50 01             	lea    0x1(%eax),%edx
  800d2b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d31:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d34:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d37:	8a 12                	mov    (%edx),%dl
  800d39:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d41:	89 55 10             	mov    %edx,0x10(%ebp)
  800d44:	85 c0                	test   %eax,%eax
  800d46:	75 dd                	jne    800d25 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d4b:	c9                   	leave  
  800d4c:	c3                   	ret    

00800d4d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d62:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d65:	73 50                	jae    800db7 <memmove+0x6a>
  800d67:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6d:	01 d0                	add    %edx,%eax
  800d6f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d72:	76 43                	jbe    800db7 <memmove+0x6a>
		s += n;
  800d74:	8b 45 10             	mov    0x10(%ebp),%eax
  800d77:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d80:	eb 10                	jmp    800d92 <memmove+0x45>
			*--d = *--s;
  800d82:	ff 4d f8             	decl   -0x8(%ebp)
  800d85:	ff 4d fc             	decl   -0x4(%ebp)
  800d88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d8b:	8a 10                	mov    (%eax),%dl
  800d8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d90:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d92:	8b 45 10             	mov    0x10(%ebp),%eax
  800d95:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d98:	89 55 10             	mov    %edx,0x10(%ebp)
  800d9b:	85 c0                	test   %eax,%eax
  800d9d:	75 e3                	jne    800d82 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d9f:	eb 23                	jmp    800dc4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800da1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da4:	8d 50 01             	lea    0x1(%eax),%edx
  800da7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800daa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dad:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800db3:	8a 12                	mov    (%edx),%dl
  800db5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800db7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dba:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dbd:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc0:	85 c0                	test   %eax,%eax
  800dc2:	75 dd                	jne    800da1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc7:	c9                   	leave  
  800dc8:	c3                   	ret    

00800dc9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ddb:	eb 2a                	jmp    800e07 <memcmp+0x3e>
		if (*s1 != *s2)
  800ddd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de0:	8a 10                	mov    (%eax),%dl
  800de2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	38 c2                	cmp    %al,%dl
  800de9:	74 16                	je     800e01 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800deb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	0f b6 d0             	movzbl %al,%edx
  800df3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df6:	8a 00                	mov    (%eax),%al
  800df8:	0f b6 c0             	movzbl %al,%eax
  800dfb:	29 c2                	sub    %eax,%edx
  800dfd:	89 d0                	mov    %edx,%eax
  800dff:	eb 18                	jmp    800e19 <memcmp+0x50>
		s1++, s2++;
  800e01:	ff 45 fc             	incl   -0x4(%ebp)
  800e04:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e07:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e0d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e10:	85 c0                	test   %eax,%eax
  800e12:	75 c9                	jne    800ddd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e19:	c9                   	leave  
  800e1a:	c3                   	ret    

00800e1b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e21:	8b 55 08             	mov    0x8(%ebp),%edx
  800e24:	8b 45 10             	mov    0x10(%ebp),%eax
  800e27:	01 d0                	add    %edx,%eax
  800e29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e2c:	eb 15                	jmp    800e43 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	8a 00                	mov    (%eax),%al
  800e33:	0f b6 d0             	movzbl %al,%edx
  800e36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e39:	0f b6 c0             	movzbl %al,%eax
  800e3c:	39 c2                	cmp    %eax,%edx
  800e3e:	74 0d                	je     800e4d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e40:	ff 45 08             	incl   0x8(%ebp)
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e49:	72 e3                	jb     800e2e <memfind+0x13>
  800e4b:	eb 01                	jmp    800e4e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e4d:	90                   	nop
	return (void *) s;
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e51:	c9                   	leave  
  800e52:	c3                   	ret    

00800e53 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
  800e56:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e60:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e67:	eb 03                	jmp    800e6c <strtol+0x19>
		s++;
  800e69:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8a 00                	mov    (%eax),%al
  800e71:	3c 20                	cmp    $0x20,%al
  800e73:	74 f4                	je     800e69 <strtol+0x16>
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	3c 09                	cmp    $0x9,%al
  800e7c:	74 eb                	je     800e69 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	8a 00                	mov    (%eax),%al
  800e83:	3c 2b                	cmp    $0x2b,%al
  800e85:	75 05                	jne    800e8c <strtol+0x39>
		s++;
  800e87:	ff 45 08             	incl   0x8(%ebp)
  800e8a:	eb 13                	jmp    800e9f <strtol+0x4c>
	else if (*s == '-')
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	8a 00                	mov    (%eax),%al
  800e91:	3c 2d                	cmp    $0x2d,%al
  800e93:	75 0a                	jne    800e9f <strtol+0x4c>
		s++, neg = 1;
  800e95:	ff 45 08             	incl   0x8(%ebp)
  800e98:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea3:	74 06                	je     800eab <strtol+0x58>
  800ea5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ea9:	75 20                	jne    800ecb <strtol+0x78>
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	8a 00                	mov    (%eax),%al
  800eb0:	3c 30                	cmp    $0x30,%al
  800eb2:	75 17                	jne    800ecb <strtol+0x78>
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	40                   	inc    %eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	3c 78                	cmp    $0x78,%al
  800ebc:	75 0d                	jne    800ecb <strtol+0x78>
		s += 2, base = 16;
  800ebe:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ec2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ec9:	eb 28                	jmp    800ef3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ecb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecf:	75 15                	jne    800ee6 <strtol+0x93>
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	8a 00                	mov    (%eax),%al
  800ed6:	3c 30                	cmp    $0x30,%al
  800ed8:	75 0c                	jne    800ee6 <strtol+0x93>
		s++, base = 8;
  800eda:	ff 45 08             	incl   0x8(%ebp)
  800edd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ee4:	eb 0d                	jmp    800ef3 <strtol+0xa0>
	else if (base == 0)
  800ee6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eea:	75 07                	jne    800ef3 <strtol+0xa0>
		base = 10;
  800eec:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	3c 2f                	cmp    $0x2f,%al
  800efa:	7e 19                	jle    800f15 <strtol+0xc2>
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	8a 00                	mov    (%eax),%al
  800f01:	3c 39                	cmp    $0x39,%al
  800f03:	7f 10                	jg     800f15 <strtol+0xc2>
			dig = *s - '0';
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	0f be c0             	movsbl %al,%eax
  800f0d:	83 e8 30             	sub    $0x30,%eax
  800f10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f13:	eb 42                	jmp    800f57 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	8a 00                	mov    (%eax),%al
  800f1a:	3c 60                	cmp    $0x60,%al
  800f1c:	7e 19                	jle    800f37 <strtol+0xe4>
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	8a 00                	mov    (%eax),%al
  800f23:	3c 7a                	cmp    $0x7a,%al
  800f25:	7f 10                	jg     800f37 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	0f be c0             	movsbl %al,%eax
  800f2f:	83 e8 57             	sub    $0x57,%eax
  800f32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f35:	eb 20                	jmp    800f57 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	8a 00                	mov    (%eax),%al
  800f3c:	3c 40                	cmp    $0x40,%al
  800f3e:	7e 39                	jle    800f79 <strtol+0x126>
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	3c 5a                	cmp    $0x5a,%al
  800f47:	7f 30                	jg     800f79 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	0f be c0             	movsbl %al,%eax
  800f51:	83 e8 37             	sub    $0x37,%eax
  800f54:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f5a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f5d:	7d 19                	jge    800f78 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f5f:	ff 45 08             	incl   0x8(%ebp)
  800f62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f65:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f69:	89 c2                	mov    %eax,%edx
  800f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f6e:	01 d0                	add    %edx,%eax
  800f70:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f73:	e9 7b ff ff ff       	jmp    800ef3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f78:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f79:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f7d:	74 08                	je     800f87 <strtol+0x134>
		*endptr = (char *) s;
  800f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f82:	8b 55 08             	mov    0x8(%ebp),%edx
  800f85:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f87:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f8b:	74 07                	je     800f94 <strtol+0x141>
  800f8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f90:	f7 d8                	neg    %eax
  800f92:	eb 03                	jmp    800f97 <strtol+0x144>
  800f94:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f97:	c9                   	leave  
  800f98:	c3                   	ret    

00800f99 <ltostr>:

void
ltostr(long value, char *str)
{
  800f99:	55                   	push   %ebp
  800f9a:	89 e5                	mov    %esp,%ebp
  800f9c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f9f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fa6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fb1:	79 13                	jns    800fc6 <ltostr+0x2d>
	{
		neg = 1;
  800fb3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fc0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fc3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fce:	99                   	cltd   
  800fcf:	f7 f9                	idiv   %ecx
  800fd1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fd4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd7:	8d 50 01             	lea    0x1(%eax),%edx
  800fda:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fdd:	89 c2                	mov    %eax,%edx
  800fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe2:	01 d0                	add    %edx,%eax
  800fe4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fe7:	83 c2 30             	add    $0x30,%edx
  800fea:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fef:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ff4:	f7 e9                	imul   %ecx
  800ff6:	c1 fa 02             	sar    $0x2,%edx
  800ff9:	89 c8                	mov    %ecx,%eax
  800ffb:	c1 f8 1f             	sar    $0x1f,%eax
  800ffe:	29 c2                	sub    %eax,%edx
  801000:	89 d0                	mov    %edx,%eax
  801002:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801005:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801009:	75 bb                	jne    800fc6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80100b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801012:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801015:	48                   	dec    %eax
  801016:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801019:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80101d:	74 3d                	je     80105c <ltostr+0xc3>
		start = 1 ;
  80101f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801026:	eb 34                	jmp    80105c <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801028:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80102b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102e:	01 d0                	add    %edx,%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801035:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801038:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103b:	01 c2                	add    %eax,%edx
  80103d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801040:	8b 45 0c             	mov    0xc(%ebp),%eax
  801043:	01 c8                	add    %ecx,%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801049:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	01 c2                	add    %eax,%edx
  801051:	8a 45 eb             	mov    -0x15(%ebp),%al
  801054:	88 02                	mov    %al,(%edx)
		start++ ;
  801056:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801059:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80105c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801062:	7c c4                	jl     801028 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801064:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801067:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106a:	01 d0                	add    %edx,%eax
  80106c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80106f:	90                   	nop
  801070:	c9                   	leave  
  801071:	c3                   	ret    

00801072 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
  801075:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801078:	ff 75 08             	pushl  0x8(%ebp)
  80107b:	e8 73 fa ff ff       	call   800af3 <strlen>
  801080:	83 c4 04             	add    $0x4,%esp
  801083:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801086:	ff 75 0c             	pushl  0xc(%ebp)
  801089:	e8 65 fa ff ff       	call   800af3 <strlen>
  80108e:	83 c4 04             	add    $0x4,%esp
  801091:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801094:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80109b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010a2:	eb 17                	jmp    8010bb <strcconcat+0x49>
		final[s] = str1[s] ;
  8010a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010aa:	01 c2                	add    %eax,%edx
  8010ac:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	01 c8                	add    %ecx,%eax
  8010b4:	8a 00                	mov    (%eax),%al
  8010b6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010b8:	ff 45 fc             	incl   -0x4(%ebp)
  8010bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010be:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010c1:	7c e1                	jl     8010a4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010d1:	eb 1f                	jmp    8010f2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d6:	8d 50 01             	lea    0x1(%eax),%edx
  8010d9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010dc:	89 c2                	mov    %eax,%edx
  8010de:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e1:	01 c2                	add    %eax,%edx
  8010e3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	01 c8                	add    %ecx,%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010ef:	ff 45 f8             	incl   -0x8(%ebp)
  8010f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010f8:	7c d9                	jl     8010d3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801100:	01 d0                	add    %edx,%eax
  801102:	c6 00 00             	movb   $0x0,(%eax)
}
  801105:	90                   	nop
  801106:	c9                   	leave  
  801107:	c3                   	ret    

00801108 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801108:	55                   	push   %ebp
  801109:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80110b:	8b 45 14             	mov    0x14(%ebp),%eax
  80110e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801114:	8b 45 14             	mov    0x14(%ebp),%eax
  801117:	8b 00                	mov    (%eax),%eax
  801119:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801120:	8b 45 10             	mov    0x10(%ebp),%eax
  801123:	01 d0                	add    %edx,%eax
  801125:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80112b:	eb 0c                	jmp    801139 <strsplit+0x31>
			*string++ = 0;
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	8d 50 01             	lea    0x1(%eax),%edx
  801133:	89 55 08             	mov    %edx,0x8(%ebp)
  801136:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8a 00                	mov    (%eax),%al
  80113e:	84 c0                	test   %al,%al
  801140:	74 18                	je     80115a <strsplit+0x52>
  801142:	8b 45 08             	mov    0x8(%ebp),%eax
  801145:	8a 00                	mov    (%eax),%al
  801147:	0f be c0             	movsbl %al,%eax
  80114a:	50                   	push   %eax
  80114b:	ff 75 0c             	pushl  0xc(%ebp)
  80114e:	e8 32 fb ff ff       	call   800c85 <strchr>
  801153:	83 c4 08             	add    $0x8,%esp
  801156:	85 c0                	test   %eax,%eax
  801158:	75 d3                	jne    80112d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	84 c0                	test   %al,%al
  801161:	74 5a                	je     8011bd <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801163:	8b 45 14             	mov    0x14(%ebp),%eax
  801166:	8b 00                	mov    (%eax),%eax
  801168:	83 f8 0f             	cmp    $0xf,%eax
  80116b:	75 07                	jne    801174 <strsplit+0x6c>
		{
			return 0;
  80116d:	b8 00 00 00 00       	mov    $0x0,%eax
  801172:	eb 66                	jmp    8011da <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801174:	8b 45 14             	mov    0x14(%ebp),%eax
  801177:	8b 00                	mov    (%eax),%eax
  801179:	8d 48 01             	lea    0x1(%eax),%ecx
  80117c:	8b 55 14             	mov    0x14(%ebp),%edx
  80117f:	89 0a                	mov    %ecx,(%edx)
  801181:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801188:	8b 45 10             	mov    0x10(%ebp),%eax
  80118b:	01 c2                	add    %eax,%edx
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801192:	eb 03                	jmp    801197 <strsplit+0x8f>
			string++;
  801194:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	84 c0                	test   %al,%al
  80119e:	74 8b                	je     80112b <strsplit+0x23>
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	0f be c0             	movsbl %al,%eax
  8011a8:	50                   	push   %eax
  8011a9:	ff 75 0c             	pushl  0xc(%ebp)
  8011ac:	e8 d4 fa ff ff       	call   800c85 <strchr>
  8011b1:	83 c4 08             	add    $0x8,%esp
  8011b4:	85 c0                	test   %eax,%eax
  8011b6:	74 dc                	je     801194 <strsplit+0x8c>
			string++;
	}
  8011b8:	e9 6e ff ff ff       	jmp    80112b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011bd:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011be:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c1:	8b 00                	mov    (%eax),%eax
  8011c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cd:	01 d0                	add    %edx,%eax
  8011cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011d5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011da:	c9                   	leave  
  8011db:	c3                   	ret    

008011dc <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8011e2:	83 ec 04             	sub    $0x4,%esp
  8011e5:	68 68 20 80 00       	push   $0x802068
  8011ea:	68 3f 01 00 00       	push   $0x13f
  8011ef:	68 8a 20 80 00       	push   $0x80208a
  8011f4:	e8 a9 ef ff ff       	call   8001a2 <_panic>

008011f9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	57                   	push   %edi
  8011fd:	56                   	push   %esi
  8011fe:	53                   	push   %ebx
  8011ff:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8b 55 0c             	mov    0xc(%ebp),%edx
  801208:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80120b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80120e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801211:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801214:	cd 30                	int    $0x30
  801216:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801219:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80121c:	83 c4 10             	add    $0x10,%esp
  80121f:	5b                   	pop    %ebx
  801220:	5e                   	pop    %esi
  801221:	5f                   	pop    %edi
  801222:	5d                   	pop    %ebp
  801223:	c3                   	ret    

00801224 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801224:	55                   	push   %ebp
  801225:	89 e5                	mov    %esp,%ebp
  801227:	83 ec 04             	sub    $0x4,%esp
  80122a:	8b 45 10             	mov    0x10(%ebp),%eax
  80122d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801230:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	6a 00                	push   $0x0
  801239:	6a 00                	push   $0x0
  80123b:	52                   	push   %edx
  80123c:	ff 75 0c             	pushl  0xc(%ebp)
  80123f:	50                   	push   %eax
  801240:	6a 00                	push   $0x0
  801242:	e8 b2 ff ff ff       	call   8011f9 <syscall>
  801247:	83 c4 18             	add    $0x18,%esp
}
  80124a:	90                   	nop
  80124b:	c9                   	leave  
  80124c:	c3                   	ret    

0080124d <sys_cgetc>:

int
sys_cgetc(void)
{
  80124d:	55                   	push   %ebp
  80124e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801250:	6a 00                	push   $0x0
  801252:	6a 00                	push   $0x0
  801254:	6a 00                	push   $0x0
  801256:	6a 00                	push   $0x0
  801258:	6a 00                	push   $0x0
  80125a:	6a 02                	push   $0x2
  80125c:	e8 98 ff ff ff       	call   8011f9 <syscall>
  801261:	83 c4 18             	add    $0x18,%esp
}
  801264:	c9                   	leave  
  801265:	c3                   	ret    

00801266 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801266:	55                   	push   %ebp
  801267:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801269:	6a 00                	push   $0x0
  80126b:	6a 00                	push   $0x0
  80126d:	6a 00                	push   $0x0
  80126f:	6a 00                	push   $0x0
  801271:	6a 00                	push   $0x0
  801273:	6a 03                	push   $0x3
  801275:	e8 7f ff ff ff       	call   8011f9 <syscall>
  80127a:	83 c4 18             	add    $0x18,%esp
}
  80127d:	90                   	nop
  80127e:	c9                   	leave  
  80127f:	c3                   	ret    

00801280 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801283:	6a 00                	push   $0x0
  801285:	6a 00                	push   $0x0
  801287:	6a 00                	push   $0x0
  801289:	6a 00                	push   $0x0
  80128b:	6a 00                	push   $0x0
  80128d:	6a 04                	push   $0x4
  80128f:	e8 65 ff ff ff       	call   8011f9 <syscall>
  801294:	83 c4 18             	add    $0x18,%esp
}
  801297:	90                   	nop
  801298:	c9                   	leave  
  801299:	c3                   	ret    

0080129a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80129a:	55                   	push   %ebp
  80129b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80129d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	6a 00                	push   $0x0
  8012a5:	6a 00                	push   $0x0
  8012a7:	6a 00                	push   $0x0
  8012a9:	52                   	push   %edx
  8012aa:	50                   	push   %eax
  8012ab:	6a 08                	push   $0x8
  8012ad:	e8 47 ff ff ff       	call   8011f9 <syscall>
  8012b2:	83 c4 18             	add    $0x18,%esp
}
  8012b5:	c9                   	leave  
  8012b6:	c3                   	ret    

008012b7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
  8012ba:	56                   	push   %esi
  8012bb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012bc:	8b 75 18             	mov    0x18(%ebp),%esi
  8012bf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cb:	56                   	push   %esi
  8012cc:	53                   	push   %ebx
  8012cd:	51                   	push   %ecx
  8012ce:	52                   	push   %edx
  8012cf:	50                   	push   %eax
  8012d0:	6a 09                	push   $0x9
  8012d2:	e8 22 ff ff ff       	call   8011f9 <syscall>
  8012d7:	83 c4 18             	add    $0x18,%esp
}
  8012da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012dd:	5b                   	pop    %ebx
  8012de:	5e                   	pop    %esi
  8012df:	5d                   	pop    %ebp
  8012e0:	c3                   	ret    

008012e1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012e1:	55                   	push   %ebp
  8012e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	6a 00                	push   $0x0
  8012ec:	6a 00                	push   $0x0
  8012ee:	6a 00                	push   $0x0
  8012f0:	52                   	push   %edx
  8012f1:	50                   	push   %eax
  8012f2:	6a 0a                	push   $0xa
  8012f4:	e8 00 ff ff ff       	call   8011f9 <syscall>
  8012f9:	83 c4 18             	add    $0x18,%esp
}
  8012fc:	c9                   	leave  
  8012fd:	c3                   	ret    

008012fe <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801301:	6a 00                	push   $0x0
  801303:	6a 00                	push   $0x0
  801305:	6a 00                	push   $0x0
  801307:	ff 75 0c             	pushl  0xc(%ebp)
  80130a:	ff 75 08             	pushl  0x8(%ebp)
  80130d:	6a 0b                	push   $0xb
  80130f:	e8 e5 fe ff ff       	call   8011f9 <syscall>
  801314:	83 c4 18             	add    $0x18,%esp
}
  801317:	c9                   	leave  
  801318:	c3                   	ret    

00801319 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80131c:	6a 00                	push   $0x0
  80131e:	6a 00                	push   $0x0
  801320:	6a 00                	push   $0x0
  801322:	6a 00                	push   $0x0
  801324:	6a 00                	push   $0x0
  801326:	6a 0c                	push   $0xc
  801328:	e8 cc fe ff ff       	call   8011f9 <syscall>
  80132d:	83 c4 18             	add    $0x18,%esp
}
  801330:	c9                   	leave  
  801331:	c3                   	ret    

00801332 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801335:	6a 00                	push   $0x0
  801337:	6a 00                	push   $0x0
  801339:	6a 00                	push   $0x0
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 0d                	push   $0xd
  801341:	e8 b3 fe ff ff       	call   8011f9 <syscall>
  801346:	83 c4 18             	add    $0x18,%esp
}
  801349:	c9                   	leave  
  80134a:	c3                   	ret    

0080134b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80134e:	6a 00                	push   $0x0
  801350:	6a 00                	push   $0x0
  801352:	6a 00                	push   $0x0
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	6a 0e                	push   $0xe
  80135a:	e8 9a fe ff ff       	call   8011f9 <syscall>
  80135f:	83 c4 18             	add    $0x18,%esp
}
  801362:	c9                   	leave  
  801363:	c3                   	ret    

00801364 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801367:	6a 00                	push   $0x0
  801369:	6a 00                	push   $0x0
  80136b:	6a 00                	push   $0x0
  80136d:	6a 00                	push   $0x0
  80136f:	6a 00                	push   $0x0
  801371:	6a 0f                	push   $0xf
  801373:	e8 81 fe ff ff       	call   8011f9 <syscall>
  801378:	83 c4 18             	add    $0x18,%esp
}
  80137b:	c9                   	leave  
  80137c:	c3                   	ret    

0080137d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801380:	6a 00                	push   $0x0
  801382:	6a 00                	push   $0x0
  801384:	6a 00                	push   $0x0
  801386:	6a 00                	push   $0x0
  801388:	ff 75 08             	pushl  0x8(%ebp)
  80138b:	6a 10                	push   $0x10
  80138d:	e8 67 fe ff ff       	call   8011f9 <syscall>
  801392:	83 c4 18             	add    $0x18,%esp
}
  801395:	c9                   	leave  
  801396:	c3                   	ret    

00801397 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 11                	push   $0x11
  8013a6:	e8 4e fe ff ff       	call   8011f9 <syscall>
  8013ab:	83 c4 18             	add    $0x18,%esp
}
  8013ae:	90                   	nop
  8013af:	c9                   	leave  
  8013b0:	c3                   	ret    

008013b1 <sys_cputc>:

void
sys_cputc(const char c)
{
  8013b1:	55                   	push   %ebp
  8013b2:	89 e5                	mov    %esp,%ebp
  8013b4:	83 ec 04             	sub    $0x4,%esp
  8013b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013bd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	50                   	push   %eax
  8013ca:	6a 01                	push   $0x1
  8013cc:	e8 28 fe ff ff       	call   8011f9 <syscall>
  8013d1:	83 c4 18             	add    $0x18,%esp
}
  8013d4:	90                   	nop
  8013d5:	c9                   	leave  
  8013d6:	c3                   	ret    

008013d7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 14                	push   $0x14
  8013e6:	e8 0e fe ff ff       	call   8011f9 <syscall>
  8013eb:	83 c4 18             	add    $0x18,%esp
}
  8013ee:	90                   	nop
  8013ef:	c9                   	leave  
  8013f0:	c3                   	ret    

008013f1 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	83 ec 04             	sub    $0x4,%esp
  8013f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013fd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801400:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801404:	8b 45 08             	mov    0x8(%ebp),%eax
  801407:	6a 00                	push   $0x0
  801409:	51                   	push   %ecx
  80140a:	52                   	push   %edx
  80140b:	ff 75 0c             	pushl  0xc(%ebp)
  80140e:	50                   	push   %eax
  80140f:	6a 15                	push   $0x15
  801411:	e8 e3 fd ff ff       	call   8011f9 <syscall>
  801416:	83 c4 18             	add    $0x18,%esp
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80141e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	52                   	push   %edx
  80142b:	50                   	push   %eax
  80142c:	6a 16                	push   $0x16
  80142e:	e8 c6 fd ff ff       	call   8011f9 <syscall>
  801433:	83 c4 18             	add    $0x18,%esp
}
  801436:	c9                   	leave  
  801437:	c3                   	ret    

00801438 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801438:	55                   	push   %ebp
  801439:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80143b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80143e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	51                   	push   %ecx
  801449:	52                   	push   %edx
  80144a:	50                   	push   %eax
  80144b:	6a 17                	push   $0x17
  80144d:	e8 a7 fd ff ff       	call   8011f9 <syscall>
  801452:	83 c4 18             	add    $0x18,%esp
}
  801455:	c9                   	leave  
  801456:	c3                   	ret    

00801457 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80145a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	6a 00                	push   $0x0
  801466:	52                   	push   %edx
  801467:	50                   	push   %eax
  801468:	6a 18                	push   $0x18
  80146a:	e8 8a fd ff ff       	call   8011f9 <syscall>
  80146f:	83 c4 18             	add    $0x18,%esp
}
  801472:	c9                   	leave  
  801473:	c3                   	ret    

00801474 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	6a 00                	push   $0x0
  80147c:	ff 75 14             	pushl  0x14(%ebp)
  80147f:	ff 75 10             	pushl  0x10(%ebp)
  801482:	ff 75 0c             	pushl  0xc(%ebp)
  801485:	50                   	push   %eax
  801486:	6a 19                	push   $0x19
  801488:	e8 6c fd ff ff       	call   8011f9 <syscall>
  80148d:	83 c4 18             	add    $0x18,%esp
}
  801490:	c9                   	leave  
  801491:	c3                   	ret    

00801492 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801495:	8b 45 08             	mov    0x8(%ebp),%eax
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	50                   	push   %eax
  8014a1:	6a 1a                	push   $0x1a
  8014a3:	e8 51 fd ff ff       	call   8011f9 <syscall>
  8014a8:	83 c4 18             	add    $0x18,%esp
}
  8014ab:	90                   	nop
  8014ac:	c9                   	leave  
  8014ad:	c3                   	ret    

008014ae <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	50                   	push   %eax
  8014bd:	6a 1b                	push   $0x1b
  8014bf:	e8 35 fd ff ff       	call   8011f9 <syscall>
  8014c4:	83 c4 18             	add    $0x18,%esp
}
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    

008014c9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 05                	push   $0x5
  8014d8:	e8 1c fd ff ff       	call   8011f9 <syscall>
  8014dd:	83 c4 18             	add    $0x18,%esp
}
  8014e0:	c9                   	leave  
  8014e1:	c3                   	ret    

008014e2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014e2:	55                   	push   %ebp
  8014e3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 06                	push   $0x6
  8014f1:	e8 03 fd ff ff       	call   8011f9 <syscall>
  8014f6:	83 c4 18             	add    $0x18,%esp
}
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	6a 07                	push   $0x7
  80150a:	e8 ea fc ff ff       	call   8011f9 <syscall>
  80150f:	83 c4 18             	add    $0x18,%esp
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <sys_exit_env>:


void sys_exit_env(void)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	6a 00                	push   $0x0
  80151f:	6a 00                	push   $0x0
  801521:	6a 1c                	push   $0x1c
  801523:	e8 d1 fc ff ff       	call   8011f9 <syscall>
  801528:	83 c4 18             	add    $0x18,%esp
}
  80152b:	90                   	nop
  80152c:	c9                   	leave  
  80152d:	c3                   	ret    

0080152e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801534:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801537:	8d 50 04             	lea    0x4(%eax),%edx
  80153a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	52                   	push   %edx
  801544:	50                   	push   %eax
  801545:	6a 1d                	push   $0x1d
  801547:	e8 ad fc ff ff       	call   8011f9 <syscall>
  80154c:	83 c4 18             	add    $0x18,%esp
	return result;
  80154f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801552:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801555:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801558:	89 01                	mov    %eax,(%ecx)
  80155a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	c9                   	leave  
  801561:	c2 04 00             	ret    $0x4

00801564 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	ff 75 10             	pushl  0x10(%ebp)
  80156e:	ff 75 0c             	pushl  0xc(%ebp)
  801571:	ff 75 08             	pushl  0x8(%ebp)
  801574:	6a 13                	push   $0x13
  801576:	e8 7e fc ff ff       	call   8011f9 <syscall>
  80157b:	83 c4 18             	add    $0x18,%esp
	return ;
  80157e:	90                   	nop
}
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <sys_rcr2>:
uint32 sys_rcr2()
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 1e                	push   $0x1e
  801590:	e8 64 fc ff ff       	call   8011f9 <syscall>
  801595:	83 c4 18             	add    $0x18,%esp
}
  801598:	c9                   	leave  
  801599:	c3                   	ret    

0080159a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
  80159d:	83 ec 04             	sub    $0x4,%esp
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015a6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	50                   	push   %eax
  8015b3:	6a 1f                	push   $0x1f
  8015b5:	e8 3f fc ff ff       	call   8011f9 <syscall>
  8015ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8015bd:	90                   	nop
}
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    

008015c0 <rsttst>:
void rsttst()
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 21                	push   $0x21
  8015cf:	e8 25 fc ff ff       	call   8011f9 <syscall>
  8015d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8015d7:	90                   	nop
}
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	83 ec 04             	sub    $0x4,%esp
  8015e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015e6:	8b 55 18             	mov    0x18(%ebp),%edx
  8015e9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015ed:	52                   	push   %edx
  8015ee:	50                   	push   %eax
  8015ef:	ff 75 10             	pushl  0x10(%ebp)
  8015f2:	ff 75 0c             	pushl  0xc(%ebp)
  8015f5:	ff 75 08             	pushl  0x8(%ebp)
  8015f8:	6a 20                	push   $0x20
  8015fa:	e8 fa fb ff ff       	call   8011f9 <syscall>
  8015ff:	83 c4 18             	add    $0x18,%esp
	return ;
  801602:	90                   	nop
}
  801603:	c9                   	leave  
  801604:	c3                   	ret    

00801605 <chktst>:
void chktst(uint32 n)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	ff 75 08             	pushl  0x8(%ebp)
  801613:	6a 22                	push   $0x22
  801615:	e8 df fb ff ff       	call   8011f9 <syscall>
  80161a:	83 c4 18             	add    $0x18,%esp
	return ;
  80161d:	90                   	nop
}
  80161e:	c9                   	leave  
  80161f:	c3                   	ret    

00801620 <inctst>:

void inctst()
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 23                	push   $0x23
  80162f:	e8 c5 fb ff ff       	call   8011f9 <syscall>
  801634:	83 c4 18             	add    $0x18,%esp
	return ;
  801637:	90                   	nop
}
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <gettst>:
uint32 gettst()
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 24                	push   $0x24
  801649:	e8 ab fb ff ff       	call   8011f9 <syscall>
  80164e:	83 c4 18             	add    $0x18,%esp
}
  801651:	c9                   	leave  
  801652:	c3                   	ret    

00801653 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 25                	push   $0x25
  801665:	e8 8f fb ff ff       	call   8011f9 <syscall>
  80166a:	83 c4 18             	add    $0x18,%esp
  80166d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801670:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801674:	75 07                	jne    80167d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801676:	b8 01 00 00 00       	mov    $0x1,%eax
  80167b:	eb 05                	jmp    801682 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80167d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 25                	push   $0x25
  801696:	e8 5e fb ff ff       	call   8011f9 <syscall>
  80169b:	83 c4 18             	add    $0x18,%esp
  80169e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016a1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016a5:	75 07                	jne    8016ae <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8016ac:	eb 05                	jmp    8016b3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 25                	push   $0x25
  8016c7:	e8 2d fb ff ff       	call   8011f9 <syscall>
  8016cc:	83 c4 18             	add    $0x18,%esp
  8016cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016d2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016d6:	75 07                	jne    8016df <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016d8:	b8 01 00 00 00       	mov    $0x1,%eax
  8016dd:	eb 05                	jmp    8016e4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    

008016e6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
  8016e9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 25                	push   $0x25
  8016f8:	e8 fc fa ff ff       	call   8011f9 <syscall>
  8016fd:	83 c4 18             	add    $0x18,%esp
  801700:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801703:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801707:	75 07                	jne    801710 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801709:	b8 01 00 00 00       	mov    $0x1,%eax
  80170e:	eb 05                	jmp    801715 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801710:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	ff 75 08             	pushl  0x8(%ebp)
  801725:	6a 26                	push   $0x26
  801727:	e8 cd fa ff ff       	call   8011f9 <syscall>
  80172c:	83 c4 18             	add    $0x18,%esp
	return ;
  80172f:	90                   	nop
}
  801730:	c9                   	leave  
  801731:	c3                   	ret    

00801732 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
  801735:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801736:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801739:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80173c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	6a 00                	push   $0x0
  801744:	53                   	push   %ebx
  801745:	51                   	push   %ecx
  801746:	52                   	push   %edx
  801747:	50                   	push   %eax
  801748:	6a 27                	push   $0x27
  80174a:	e8 aa fa ff ff       	call   8011f9 <syscall>
  80174f:	83 c4 18             	add    $0x18,%esp
}
  801752:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801755:	c9                   	leave  
  801756:	c3                   	ret    

00801757 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80175a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	52                   	push   %edx
  801767:	50                   	push   %eax
  801768:	6a 28                	push   $0x28
  80176a:	e8 8a fa ff ff       	call   8011f9 <syscall>
  80176f:	83 c4 18             	add    $0x18,%esp
}
  801772:	c9                   	leave  
  801773:	c3                   	ret    

00801774 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801777:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80177a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	6a 00                	push   $0x0
  801782:	51                   	push   %ecx
  801783:	ff 75 10             	pushl  0x10(%ebp)
  801786:	52                   	push   %edx
  801787:	50                   	push   %eax
  801788:	6a 29                	push   $0x29
  80178a:	e8 6a fa ff ff       	call   8011f9 <syscall>
  80178f:	83 c4 18             	add    $0x18,%esp
}
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	ff 75 10             	pushl  0x10(%ebp)
  80179e:	ff 75 0c             	pushl  0xc(%ebp)
  8017a1:	ff 75 08             	pushl  0x8(%ebp)
  8017a4:	6a 12                	push   $0x12
  8017a6:	e8 4e fa ff ff       	call   8011f9 <syscall>
  8017ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8017ae:	90                   	nop
}
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    

008017b1 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8017b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	52                   	push   %edx
  8017c1:	50                   	push   %eax
  8017c2:	6a 2a                	push   $0x2a
  8017c4:	e8 30 fa ff ff       	call   8011f9 <syscall>
  8017c9:	83 c4 18             	add    $0x18,%esp
	return;
  8017cc:	90                   	nop
}
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8017d5:	83 ec 04             	sub    $0x4,%esp
  8017d8:	68 97 20 80 00       	push   $0x802097
  8017dd:	68 2e 01 00 00       	push   $0x12e
  8017e2:	68 ab 20 80 00       	push   $0x8020ab
  8017e7:	e8 b6 e9 ff ff       	call   8001a2 <_panic>

008017ec <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8017f2:	83 ec 04             	sub    $0x4,%esp
  8017f5:	68 97 20 80 00       	push   $0x802097
  8017fa:	68 35 01 00 00       	push   $0x135
  8017ff:	68 ab 20 80 00       	push   $0x8020ab
  801804:	e8 99 e9 ff ff       	call   8001a2 <_panic>

00801809 <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
  80180c:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  80180f:	83 ec 04             	sub    $0x4,%esp
  801812:	68 97 20 80 00       	push   $0x802097
  801817:	68 3b 01 00 00       	push   $0x13b
  80181c:	68 ab 20 80 00       	push   $0x8020ab
  801821:	e8 7c e9 ff ff       	call   8001a2 <_panic>
  801826:	66 90                	xchg   %ax,%ax

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
