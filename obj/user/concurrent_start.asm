
obj/user/concurrent_start:     file format elf32-i386


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
  800031:	e8 f9 00 00 00       	call   80012f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// hello, world
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	char *str ;
	sys_createSharedObject("cnc1", 512, 1, (void*) &str);
  80003e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800041:	50                   	push   %eax
  800042:	6a 01                	push   $0x1
  800044:	68 00 02 00 00       	push   $0x200
  800049:	68 e0 1b 80 00       	push   $0x801be0
  80004e:	e8 78 14 00 00       	call   8014cb <sys_createSharedObject>
  800053:	83 c4 10             	add    $0x10,%esp

	struct semaphore cnc1 = create_semaphore("cnc1", 1);
  800056:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	6a 01                	push   $0x1
  80005e:	68 e0 1b 80 00       	push   $0x801be0
  800063:	50                   	push   %eax
  800064:	e8 97 18 00 00       	call   801900 <create_semaphore>
  800069:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = create_semaphore("depend1", 0);
  80006c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80006f:	83 ec 04             	sub    $0x4,%esp
  800072:	6a 00                	push   $0x0
  800074:	68 e5 1b 80 00       	push   $0x801be5
  800079:	50                   	push   %eax
  80007a:	e8 81 18 00 00       	call   801900 <create_semaphore>
  80007f:	83 c4 0c             	add    $0xc,%esp

	uint32 id1, id2;
	id2 = sys_create_env("qs2", (myEnv->page_WS_max_size), (myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800082:	a1 04 30 80 00       	mov    0x803004,%eax
  800087:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  80008d:	a1 04 30 80 00       	mov    0x803004,%eax
  800092:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800098:	89 c1                	mov    %eax,%ecx
  80009a:	a1 04 30 80 00       	mov    0x803004,%eax
  80009f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000a5:	52                   	push   %edx
  8000a6:	51                   	push   %ecx
  8000a7:	50                   	push   %eax
  8000a8:	68 ed 1b 80 00       	push   $0x801bed
  8000ad:	e8 9c 14 00 00       	call   80154e <sys_create_env>
  8000b2:	83 c4 10             	add    $0x10,%esp
  8000b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	id1 = sys_create_env("qs1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000b8:	a1 04 30 80 00       	mov    0x803004,%eax
  8000bd:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  8000c3:	a1 04 30 80 00       	mov    0x803004,%eax
  8000c8:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8000ce:	89 c1                	mov    %eax,%ecx
  8000d0:	a1 04 30 80 00       	mov    0x803004,%eax
  8000d5:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000db:	52                   	push   %edx
  8000dc:	51                   	push   %ecx
  8000dd:	50                   	push   %eax
  8000de:	68 f1 1b 80 00       	push   $0x801bf1
  8000e3:	e8 66 14 00 00       	call   80154e <sys_create_env>
  8000e8:	83 c4 10             	add    $0x10,%esp
  8000eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (id1 == E_ENV_CREATION_ERROR || id2 == E_ENV_CREATION_ERROR)
  8000ee:	83 7d f0 ef          	cmpl   $0xffffffef,-0x10(%ebp)
  8000f2:	74 06                	je     8000fa <_main+0xc2>
  8000f4:	83 7d f4 ef          	cmpl   $0xffffffef,-0xc(%ebp)
  8000f8:	75 14                	jne    80010e <_main+0xd6>
		panic("NO AVAILABLE ENVs...");
  8000fa:	83 ec 04             	sub    $0x4,%esp
  8000fd:	68 f5 1b 80 00       	push   $0x801bf5
  800102:	6a 11                	push   $0x11
  800104:	68 0a 1c 80 00       	push   $0x801c0a
  800109:	e8 6e 01 00 00       	call   80027c <_panic>

	sys_run_env(id2);
  80010e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	50                   	push   %eax
  800115:	e8 52 14 00 00       	call   80156c <sys_run_env>
  80011a:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id1);
  80011d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	50                   	push   %eax
  800124:	e8 43 14 00 00       	call   80156c <sys_run_env>
  800129:	83 c4 10             	add    $0x10,%esp

	return;
  80012c:	90                   	nop
}
  80012d:	c9                   	leave  
  80012e:	c3                   	ret    

0080012f <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800135:	e8 82 14 00 00       	call   8015bc <sys_getenvindex>
  80013a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80013d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800140:	89 d0                	mov    %edx,%eax
  800142:	c1 e0 06             	shl    $0x6,%eax
  800145:	29 d0                	sub    %edx,%eax
  800147:	c1 e0 02             	shl    $0x2,%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800153:	01 c8                	add    %ecx,%eax
  800155:	c1 e0 03             	shl    $0x3,%eax
  800158:	01 d0                	add    %edx,%eax
  80015a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800161:	29 c2                	sub    %eax,%edx
  800163:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80016a:	89 c2                	mov    %eax,%edx
  80016c:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800172:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800177:	a1 04 30 80 00       	mov    0x803004,%eax
  80017c:	8a 40 20             	mov    0x20(%eax),%al
  80017f:	84 c0                	test   %al,%al
  800181:	74 0d                	je     800190 <libmain+0x61>
		binaryname = myEnv->prog_name;
  800183:	a1 04 30 80 00       	mov    0x803004,%eax
  800188:	83 c0 20             	add    $0x20,%eax
  80018b:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800190:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800194:	7e 0a                	jle    8001a0 <libmain+0x71>
		binaryname = argv[0];
  800196:	8b 45 0c             	mov    0xc(%ebp),%eax
  800199:	8b 00                	mov    (%eax),%eax
  80019b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 0c             	pushl  0xc(%ebp)
  8001a6:	ff 75 08             	pushl  0x8(%ebp)
  8001a9:	e8 8a fe ff ff       	call   800038 <_main>
  8001ae:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8001b1:	e8 8a 11 00 00       	call   801340 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	68 3c 1c 80 00       	push   $0x801c3c
  8001be:	e8 76 03 00 00       	call   800539 <cprintf>
  8001c3:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c6:	a1 04 30 80 00       	mov    0x803004,%eax
  8001cb:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8001d1:	a1 04 30 80 00       	mov    0x803004,%eax
  8001d6:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8001dc:	83 ec 04             	sub    $0x4,%esp
  8001df:	52                   	push   %edx
  8001e0:	50                   	push   %eax
  8001e1:	68 64 1c 80 00       	push   $0x801c64
  8001e6:	e8 4e 03 00 00       	call   800539 <cprintf>
  8001eb:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001ee:	a1 04 30 80 00       	mov    0x803004,%eax
  8001f3:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8001f9:	a1 04 30 80 00       	mov    0x803004,%eax
  8001fe:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800204:	a1 04 30 80 00       	mov    0x803004,%eax
  800209:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80020f:	51                   	push   %ecx
  800210:	52                   	push   %edx
  800211:	50                   	push   %eax
  800212:	68 8c 1c 80 00       	push   $0x801c8c
  800217:	e8 1d 03 00 00       	call   800539 <cprintf>
  80021c:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021f:	a1 04 30 80 00       	mov    0x803004,%eax
  800224:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80022a:	83 ec 08             	sub    $0x8,%esp
  80022d:	50                   	push   %eax
  80022e:	68 e4 1c 80 00       	push   $0x801ce4
  800233:	e8 01 03 00 00       	call   800539 <cprintf>
  800238:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	68 3c 1c 80 00       	push   $0x801c3c
  800243:	e8 f1 02 00 00       	call   800539 <cprintf>
  800248:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80024b:	e8 0a 11 00 00       	call   80135a <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800250:	e8 19 00 00 00       	call   80026e <exit>
}
  800255:	90                   	nop
  800256:	c9                   	leave  
  800257:	c3                   	ret    

00800258 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800258:	55                   	push   %ebp
  800259:	89 e5                	mov    %esp,%ebp
  80025b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80025e:	83 ec 0c             	sub    $0xc,%esp
  800261:	6a 00                	push   $0x0
  800263:	e8 20 13 00 00       	call   801588 <sys_destroy_env>
  800268:	83 c4 10             	add    $0x10,%esp
}
  80026b:	90                   	nop
  80026c:	c9                   	leave  
  80026d:	c3                   	ret    

0080026e <exit>:

void
exit(void)
{
  80026e:	55                   	push   %ebp
  80026f:	89 e5                	mov    %esp,%ebp
  800271:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800274:	e8 75 13 00 00       	call   8015ee <sys_exit_env>
}
  800279:	90                   	nop
  80027a:	c9                   	leave  
  80027b:	c3                   	ret    

0080027c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80027c:	55                   	push   %ebp
  80027d:	89 e5                	mov    %esp,%ebp
  80027f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800282:	8d 45 10             	lea    0x10(%ebp),%eax
  800285:	83 c0 04             	add    $0x4,%eax
  800288:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80028b:	a1 24 30 80 00       	mov    0x803024,%eax
  800290:	85 c0                	test   %eax,%eax
  800292:	74 16                	je     8002aa <_panic+0x2e>
		cprintf("%s: ", argv0);
  800294:	a1 24 30 80 00       	mov    0x803024,%eax
  800299:	83 ec 08             	sub    $0x8,%esp
  80029c:	50                   	push   %eax
  80029d:	68 f8 1c 80 00       	push   $0x801cf8
  8002a2:	e8 92 02 00 00       	call   800539 <cprintf>
  8002a7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002aa:	a1 00 30 80 00       	mov    0x803000,%eax
  8002af:	ff 75 0c             	pushl  0xc(%ebp)
  8002b2:	ff 75 08             	pushl  0x8(%ebp)
  8002b5:	50                   	push   %eax
  8002b6:	68 fd 1c 80 00       	push   $0x801cfd
  8002bb:	e8 79 02 00 00       	call   800539 <cprintf>
  8002c0:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c6:	83 ec 08             	sub    $0x8,%esp
  8002c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8002cc:	50                   	push   %eax
  8002cd:	e8 fc 01 00 00       	call   8004ce <vcprintf>
  8002d2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002d5:	83 ec 08             	sub    $0x8,%esp
  8002d8:	6a 00                	push   $0x0
  8002da:	68 19 1d 80 00       	push   $0x801d19
  8002df:	e8 ea 01 00 00       	call   8004ce <vcprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002e7:	e8 82 ff ff ff       	call   80026e <exit>

	// should not return here
	while (1) ;
  8002ec:	eb fe                	jmp    8002ec <_panic+0x70>

008002ee <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002f4:	a1 04 30 80 00       	mov    0x803004,%eax
  8002f9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8002ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800302:	39 c2                	cmp    %eax,%edx
  800304:	74 14                	je     80031a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	68 1c 1d 80 00       	push   $0x801d1c
  80030e:	6a 26                	push   $0x26
  800310:	68 68 1d 80 00       	push   $0x801d68
  800315:	e8 62 ff ff ff       	call   80027c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80031a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800321:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800328:	e9 c5 00 00 00       	jmp    8003f2 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80032d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800330:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800337:	8b 45 08             	mov    0x8(%ebp),%eax
  80033a:	01 d0                	add    %edx,%eax
  80033c:	8b 00                	mov    (%eax),%eax
  80033e:	85 c0                	test   %eax,%eax
  800340:	75 08                	jne    80034a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800342:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800345:	e9 a5 00 00 00       	jmp    8003ef <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80034a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800351:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800358:	eb 69                	jmp    8003c3 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80035a:	a1 04 30 80 00       	mov    0x803004,%eax
  80035f:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800365:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800368:	89 d0                	mov    %edx,%eax
  80036a:	01 c0                	add    %eax,%eax
  80036c:	01 d0                	add    %edx,%eax
  80036e:	c1 e0 03             	shl    $0x3,%eax
  800371:	01 c8                	add    %ecx,%eax
  800373:	8a 40 04             	mov    0x4(%eax),%al
  800376:	84 c0                	test   %al,%al
  800378:	75 46                	jne    8003c0 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80037a:	a1 04 30 80 00       	mov    0x803004,%eax
  80037f:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800385:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800388:	89 d0                	mov    %edx,%eax
  80038a:	01 c0                	add    %eax,%eax
  80038c:	01 d0                	add    %edx,%eax
  80038e:	c1 e0 03             	shl    $0x3,%eax
  800391:	01 c8                	add    %ecx,%eax
  800393:	8b 00                	mov    (%eax),%eax
  800395:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800398:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8003af:	01 c8                	add    %ecx,%eax
  8003b1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b3:	39 c2                	cmp    %eax,%edx
  8003b5:	75 09                	jne    8003c0 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003b7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003be:	eb 15                	jmp    8003d5 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c0:	ff 45 e8             	incl   -0x18(%ebp)
  8003c3:	a1 04 30 80 00       	mov    0x803004,%eax
  8003c8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003d1:	39 c2                	cmp    %eax,%edx
  8003d3:	77 85                	ja     80035a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003d9:	75 14                	jne    8003ef <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003db:	83 ec 04             	sub    $0x4,%esp
  8003de:	68 74 1d 80 00       	push   $0x801d74
  8003e3:	6a 3a                	push   $0x3a
  8003e5:	68 68 1d 80 00       	push   $0x801d68
  8003ea:	e8 8d fe ff ff       	call   80027c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003ef:	ff 45 f0             	incl   -0x10(%ebp)
  8003f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f8:	0f 8c 2f ff ff ff    	jl     80032d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003fe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800405:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80040c:	eb 26                	jmp    800434 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80040e:	a1 04 30 80 00       	mov    0x803004,%eax
  800413:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800419:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	01 c0                	add    %eax,%eax
  800420:	01 d0                	add    %edx,%eax
  800422:	c1 e0 03             	shl    $0x3,%eax
  800425:	01 c8                	add    %ecx,%eax
  800427:	8a 40 04             	mov    0x4(%eax),%al
  80042a:	3c 01                	cmp    $0x1,%al
  80042c:	75 03                	jne    800431 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80042e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800431:	ff 45 e0             	incl   -0x20(%ebp)
  800434:	a1 04 30 80 00       	mov    0x803004,%eax
  800439:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80043f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800442:	39 c2                	cmp    %eax,%edx
  800444:	77 c8                	ja     80040e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800449:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80044c:	74 14                	je     800462 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80044e:	83 ec 04             	sub    $0x4,%esp
  800451:	68 c8 1d 80 00       	push   $0x801dc8
  800456:	6a 44                	push   $0x44
  800458:	68 68 1d 80 00       	push   $0x801d68
  80045d:	e8 1a fe ff ff       	call   80027c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800462:	90                   	nop
  800463:	c9                   	leave  
  800464:	c3                   	ret    

00800465 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800465:	55                   	push   %ebp
  800466:	89 e5                	mov    %esp,%ebp
  800468:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80046b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046e:	8b 00                	mov    (%eax),%eax
  800470:	8d 48 01             	lea    0x1(%eax),%ecx
  800473:	8b 55 0c             	mov    0xc(%ebp),%edx
  800476:	89 0a                	mov    %ecx,(%edx)
  800478:	8b 55 08             	mov    0x8(%ebp),%edx
  80047b:	88 d1                	mov    %dl,%cl
  80047d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800480:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800484:	8b 45 0c             	mov    0xc(%ebp),%eax
  800487:	8b 00                	mov    (%eax),%eax
  800489:	3d ff 00 00 00       	cmp    $0xff,%eax
  80048e:	75 2c                	jne    8004bc <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800490:	a0 08 30 80 00       	mov    0x803008,%al
  800495:	0f b6 c0             	movzbl %al,%eax
  800498:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049b:	8b 12                	mov    (%edx),%edx
  80049d:	89 d1                	mov    %edx,%ecx
  80049f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a2:	83 c2 08             	add    $0x8,%edx
  8004a5:	83 ec 04             	sub    $0x4,%esp
  8004a8:	50                   	push   %eax
  8004a9:	51                   	push   %ecx
  8004aa:	52                   	push   %edx
  8004ab:	e8 4e 0e 00 00       	call   8012fe <sys_cputs>
  8004b0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bf:	8b 40 04             	mov    0x4(%eax),%eax
  8004c2:	8d 50 01             	lea    0x1(%eax),%edx
  8004c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004cb:	90                   	nop
  8004cc:	c9                   	leave  
  8004cd:	c3                   	ret    

008004ce <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004ce:	55                   	push   %ebp
  8004cf:	89 e5                	mov    %esp,%ebp
  8004d1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004de:	00 00 00 
	b.cnt = 0;
  8004e1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e8:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004eb:	ff 75 0c             	pushl  0xc(%ebp)
  8004ee:	ff 75 08             	pushl  0x8(%ebp)
  8004f1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f7:	50                   	push   %eax
  8004f8:	68 65 04 80 00       	push   $0x800465
  8004fd:	e8 11 02 00 00       	call   800713 <vprintfmt>
  800502:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800505:	a0 08 30 80 00       	mov    0x803008,%al
  80050a:	0f b6 c0             	movzbl %al,%eax
  80050d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800513:	83 ec 04             	sub    $0x4,%esp
  800516:	50                   	push   %eax
  800517:	52                   	push   %edx
  800518:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80051e:	83 c0 08             	add    $0x8,%eax
  800521:	50                   	push   %eax
  800522:	e8 d7 0d 00 00       	call   8012fe <sys_cputs>
  800527:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80052a:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800531:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800537:	c9                   	leave  
  800538:	c3                   	ret    

00800539 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800539:	55                   	push   %ebp
  80053a:	89 e5                	mov    %esp,%ebp
  80053c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80053f:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800546:	8d 45 0c             	lea    0xc(%ebp),%eax
  800549:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80054c:	8b 45 08             	mov    0x8(%ebp),%eax
  80054f:	83 ec 08             	sub    $0x8,%esp
  800552:	ff 75 f4             	pushl  -0xc(%ebp)
  800555:	50                   	push   %eax
  800556:	e8 73 ff ff ff       	call   8004ce <vcprintf>
  80055b:	83 c4 10             	add    $0x10,%esp
  80055e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800561:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800564:	c9                   	leave  
  800565:	c3                   	ret    

00800566 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800566:	55                   	push   %ebp
  800567:	89 e5                	mov    %esp,%ebp
  800569:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80056c:	e8 cf 0d 00 00       	call   801340 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800571:	8d 45 0c             	lea    0xc(%ebp),%eax
  800574:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	83 ec 08             	sub    $0x8,%esp
  80057d:	ff 75 f4             	pushl  -0xc(%ebp)
  800580:	50                   	push   %eax
  800581:	e8 48 ff ff ff       	call   8004ce <vcprintf>
  800586:	83 c4 10             	add    $0x10,%esp
  800589:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80058c:	e8 c9 0d 00 00       	call   80135a <sys_unlock_cons>
	return cnt;
  800591:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800594:	c9                   	leave  
  800595:	c3                   	ret    

00800596 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800596:	55                   	push   %ebp
  800597:	89 e5                	mov    %esp,%ebp
  800599:	53                   	push   %ebx
  80059a:	83 ec 14             	sub    $0x14,%esp
  80059d:	8b 45 10             	mov    0x10(%ebp),%eax
  8005a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a9:	8b 45 18             	mov    0x18(%ebp),%eax
  8005ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b4:	77 55                	ja     80060b <printnum+0x75>
  8005b6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b9:	72 05                	jb     8005c0 <printnum+0x2a>
  8005bb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005be:	77 4b                	ja     80060b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005c0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005c3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005c6:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ce:	52                   	push   %edx
  8005cf:	50                   	push   %eax
  8005d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d3:	ff 75 f0             	pushl  -0x10(%ebp)
  8005d6:	e8 99 13 00 00       	call   801974 <__udivdi3>
  8005db:	83 c4 10             	add    $0x10,%esp
  8005de:	83 ec 04             	sub    $0x4,%esp
  8005e1:	ff 75 20             	pushl  0x20(%ebp)
  8005e4:	53                   	push   %ebx
  8005e5:	ff 75 18             	pushl  0x18(%ebp)
  8005e8:	52                   	push   %edx
  8005e9:	50                   	push   %eax
  8005ea:	ff 75 0c             	pushl  0xc(%ebp)
  8005ed:	ff 75 08             	pushl  0x8(%ebp)
  8005f0:	e8 a1 ff ff ff       	call   800596 <printnum>
  8005f5:	83 c4 20             	add    $0x20,%esp
  8005f8:	eb 1a                	jmp    800614 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005fa:	83 ec 08             	sub    $0x8,%esp
  8005fd:	ff 75 0c             	pushl  0xc(%ebp)
  800600:	ff 75 20             	pushl  0x20(%ebp)
  800603:	8b 45 08             	mov    0x8(%ebp),%eax
  800606:	ff d0                	call   *%eax
  800608:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80060b:	ff 4d 1c             	decl   0x1c(%ebp)
  80060e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800612:	7f e6                	jg     8005fa <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800614:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800617:	bb 00 00 00 00       	mov    $0x0,%ebx
  80061c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800622:	53                   	push   %ebx
  800623:	51                   	push   %ecx
  800624:	52                   	push   %edx
  800625:	50                   	push   %eax
  800626:	e8 59 14 00 00       	call   801a84 <__umoddi3>
  80062b:	83 c4 10             	add    $0x10,%esp
  80062e:	05 34 20 80 00       	add    $0x802034,%eax
  800633:	8a 00                	mov    (%eax),%al
  800635:	0f be c0             	movsbl %al,%eax
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	ff 75 0c             	pushl  0xc(%ebp)
  80063e:	50                   	push   %eax
  80063f:	8b 45 08             	mov    0x8(%ebp),%eax
  800642:	ff d0                	call   *%eax
  800644:	83 c4 10             	add    $0x10,%esp
}
  800647:	90                   	nop
  800648:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80064b:	c9                   	leave  
  80064c:	c3                   	ret    

0080064d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80064d:	55                   	push   %ebp
  80064e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800650:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800654:	7e 1c                	jle    800672 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800656:	8b 45 08             	mov    0x8(%ebp),%eax
  800659:	8b 00                	mov    (%eax),%eax
  80065b:	8d 50 08             	lea    0x8(%eax),%edx
  80065e:	8b 45 08             	mov    0x8(%ebp),%eax
  800661:	89 10                	mov    %edx,(%eax)
  800663:	8b 45 08             	mov    0x8(%ebp),%eax
  800666:	8b 00                	mov    (%eax),%eax
  800668:	83 e8 08             	sub    $0x8,%eax
  80066b:	8b 50 04             	mov    0x4(%eax),%edx
  80066e:	8b 00                	mov    (%eax),%eax
  800670:	eb 40                	jmp    8006b2 <getuint+0x65>
	else if (lflag)
  800672:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800676:	74 1e                	je     800696 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800678:	8b 45 08             	mov    0x8(%ebp),%eax
  80067b:	8b 00                	mov    (%eax),%eax
  80067d:	8d 50 04             	lea    0x4(%eax),%edx
  800680:	8b 45 08             	mov    0x8(%ebp),%eax
  800683:	89 10                	mov    %edx,(%eax)
  800685:	8b 45 08             	mov    0x8(%ebp),%eax
  800688:	8b 00                	mov    (%eax),%eax
  80068a:	83 e8 04             	sub    $0x4,%eax
  80068d:	8b 00                	mov    (%eax),%eax
  80068f:	ba 00 00 00 00       	mov    $0x0,%edx
  800694:	eb 1c                	jmp    8006b2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	8b 00                	mov    (%eax),%eax
  80069b:	8d 50 04             	lea    0x4(%eax),%edx
  80069e:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a1:	89 10                	mov    %edx,(%eax)
  8006a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a6:	8b 00                	mov    (%eax),%eax
  8006a8:	83 e8 04             	sub    $0x4,%eax
  8006ab:	8b 00                	mov    (%eax),%eax
  8006ad:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006b2:	5d                   	pop    %ebp
  8006b3:	c3                   	ret    

008006b4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006b4:	55                   	push   %ebp
  8006b5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006bb:	7e 1c                	jle    8006d9 <getint+0x25>
		return va_arg(*ap, long long);
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	8d 50 08             	lea    0x8(%eax),%edx
  8006c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c8:	89 10                	mov    %edx,(%eax)
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8b 00                	mov    (%eax),%eax
  8006cf:	83 e8 08             	sub    $0x8,%eax
  8006d2:	8b 50 04             	mov    0x4(%eax),%edx
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	eb 38                	jmp    800711 <getint+0x5d>
	else if (lflag)
  8006d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006dd:	74 1a                	je     8006f9 <getint+0x45>
		return va_arg(*ap, long);
  8006df:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	8d 50 04             	lea    0x4(%eax),%edx
  8006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ea:	89 10                	mov    %edx,(%eax)
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	83 e8 04             	sub    $0x4,%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	99                   	cltd   
  8006f7:	eb 18                	jmp    800711 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fc:	8b 00                	mov    (%eax),%eax
  8006fe:	8d 50 04             	lea    0x4(%eax),%edx
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	89 10                	mov    %edx,(%eax)
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	83 e8 04             	sub    $0x4,%eax
  80070e:	8b 00                	mov    (%eax),%eax
  800710:	99                   	cltd   
}
  800711:	5d                   	pop    %ebp
  800712:	c3                   	ret    

00800713 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800713:	55                   	push   %ebp
  800714:	89 e5                	mov    %esp,%ebp
  800716:	56                   	push   %esi
  800717:	53                   	push   %ebx
  800718:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80071b:	eb 17                	jmp    800734 <vprintfmt+0x21>
			if (ch == '\0')
  80071d:	85 db                	test   %ebx,%ebx
  80071f:	0f 84 c1 03 00 00    	je     800ae6 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800725:	83 ec 08             	sub    $0x8,%esp
  800728:	ff 75 0c             	pushl  0xc(%ebp)
  80072b:	53                   	push   %ebx
  80072c:	8b 45 08             	mov    0x8(%ebp),%eax
  80072f:	ff d0                	call   *%eax
  800731:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800734:	8b 45 10             	mov    0x10(%ebp),%eax
  800737:	8d 50 01             	lea    0x1(%eax),%edx
  80073a:	89 55 10             	mov    %edx,0x10(%ebp)
  80073d:	8a 00                	mov    (%eax),%al
  80073f:	0f b6 d8             	movzbl %al,%ebx
  800742:	83 fb 25             	cmp    $0x25,%ebx
  800745:	75 d6                	jne    80071d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800747:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80074b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800752:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800759:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800760:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800767:	8b 45 10             	mov    0x10(%ebp),%eax
  80076a:	8d 50 01             	lea    0x1(%eax),%edx
  80076d:	89 55 10             	mov    %edx,0x10(%ebp)
  800770:	8a 00                	mov    (%eax),%al
  800772:	0f b6 d8             	movzbl %al,%ebx
  800775:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800778:	83 f8 5b             	cmp    $0x5b,%eax
  80077b:	0f 87 3d 03 00 00    	ja     800abe <vprintfmt+0x3ab>
  800781:	8b 04 85 58 20 80 00 	mov    0x802058(,%eax,4),%eax
  800788:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80078a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80078e:	eb d7                	jmp    800767 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800790:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800794:	eb d1                	jmp    800767 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800796:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80079d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007a0:	89 d0                	mov    %edx,%eax
  8007a2:	c1 e0 02             	shl    $0x2,%eax
  8007a5:	01 d0                	add    %edx,%eax
  8007a7:	01 c0                	add    %eax,%eax
  8007a9:	01 d8                	add    %ebx,%eax
  8007ab:	83 e8 30             	sub    $0x30,%eax
  8007ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b4:	8a 00                	mov    (%eax),%al
  8007b6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007b9:	83 fb 2f             	cmp    $0x2f,%ebx
  8007bc:	7e 3e                	jle    8007fc <vprintfmt+0xe9>
  8007be:	83 fb 39             	cmp    $0x39,%ebx
  8007c1:	7f 39                	jg     8007fc <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007c6:	eb d5                	jmp    80079d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cb:	83 c0 04             	add    $0x4,%eax
  8007ce:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d4:	83 e8 04             	sub    $0x4,%eax
  8007d7:	8b 00                	mov    (%eax),%eax
  8007d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007dc:	eb 1f                	jmp    8007fd <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e2:	79 83                	jns    800767 <vprintfmt+0x54>
				width = 0;
  8007e4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007eb:	e9 77 ff ff ff       	jmp    800767 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007f0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f7:	e9 6b ff ff ff       	jmp    800767 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007fc:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800801:	0f 89 60 ff ff ff    	jns    800767 <vprintfmt+0x54>
				width = precision, precision = -1;
  800807:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80080a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80080d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800814:	e9 4e ff ff ff       	jmp    800767 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800819:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80081c:	e9 46 ff ff ff       	jmp    800767 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800821:	8b 45 14             	mov    0x14(%ebp),%eax
  800824:	83 c0 04             	add    $0x4,%eax
  800827:	89 45 14             	mov    %eax,0x14(%ebp)
  80082a:	8b 45 14             	mov    0x14(%ebp),%eax
  80082d:	83 e8 04             	sub    $0x4,%eax
  800830:	8b 00                	mov    (%eax),%eax
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	50                   	push   %eax
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	ff d0                	call   *%eax
  80083e:	83 c4 10             	add    $0x10,%esp
			break;
  800841:	e9 9b 02 00 00       	jmp    800ae1 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	83 c0 04             	add    $0x4,%eax
  80084c:	89 45 14             	mov    %eax,0x14(%ebp)
  80084f:	8b 45 14             	mov    0x14(%ebp),%eax
  800852:	83 e8 04             	sub    $0x4,%eax
  800855:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800857:	85 db                	test   %ebx,%ebx
  800859:	79 02                	jns    80085d <vprintfmt+0x14a>
				err = -err;
  80085b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80085d:	83 fb 64             	cmp    $0x64,%ebx
  800860:	7f 0b                	jg     80086d <vprintfmt+0x15a>
  800862:	8b 34 9d a0 1e 80 00 	mov    0x801ea0(,%ebx,4),%esi
  800869:	85 f6                	test   %esi,%esi
  80086b:	75 19                	jne    800886 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80086d:	53                   	push   %ebx
  80086e:	68 45 20 80 00       	push   $0x802045
  800873:	ff 75 0c             	pushl  0xc(%ebp)
  800876:	ff 75 08             	pushl  0x8(%ebp)
  800879:	e8 70 02 00 00       	call   800aee <printfmt>
  80087e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800881:	e9 5b 02 00 00       	jmp    800ae1 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800886:	56                   	push   %esi
  800887:	68 4e 20 80 00       	push   $0x80204e
  80088c:	ff 75 0c             	pushl  0xc(%ebp)
  80088f:	ff 75 08             	pushl  0x8(%ebp)
  800892:	e8 57 02 00 00       	call   800aee <printfmt>
  800897:	83 c4 10             	add    $0x10,%esp
			break;
  80089a:	e9 42 02 00 00       	jmp    800ae1 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80089f:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a2:	83 c0 04             	add    $0x4,%eax
  8008a5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ab:	83 e8 04             	sub    $0x4,%eax
  8008ae:	8b 30                	mov    (%eax),%esi
  8008b0:	85 f6                	test   %esi,%esi
  8008b2:	75 05                	jne    8008b9 <vprintfmt+0x1a6>
				p = "(null)";
  8008b4:	be 51 20 80 00       	mov    $0x802051,%esi
			if (width > 0 && padc != '-')
  8008b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008bd:	7e 6d                	jle    80092c <vprintfmt+0x219>
  8008bf:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008c3:	74 67                	je     80092c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c8:	83 ec 08             	sub    $0x8,%esp
  8008cb:	50                   	push   %eax
  8008cc:	56                   	push   %esi
  8008cd:	e8 1e 03 00 00       	call   800bf0 <strnlen>
  8008d2:	83 c4 10             	add    $0x10,%esp
  8008d5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d8:	eb 16                	jmp    8008f0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008da:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008de:	83 ec 08             	sub    $0x8,%esp
  8008e1:	ff 75 0c             	pushl  0xc(%ebp)
  8008e4:	50                   	push   %eax
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	ff d0                	call   *%eax
  8008ea:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ed:	ff 4d e4             	decl   -0x1c(%ebp)
  8008f0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f4:	7f e4                	jg     8008da <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f6:	eb 34                	jmp    80092c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008fc:	74 1c                	je     80091a <vprintfmt+0x207>
  8008fe:	83 fb 1f             	cmp    $0x1f,%ebx
  800901:	7e 05                	jle    800908 <vprintfmt+0x1f5>
  800903:	83 fb 7e             	cmp    $0x7e,%ebx
  800906:	7e 12                	jle    80091a <vprintfmt+0x207>
					putch('?', putdat);
  800908:	83 ec 08             	sub    $0x8,%esp
  80090b:	ff 75 0c             	pushl  0xc(%ebp)
  80090e:	6a 3f                	push   $0x3f
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	ff d0                	call   *%eax
  800915:	83 c4 10             	add    $0x10,%esp
  800918:	eb 0f                	jmp    800929 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80091a:	83 ec 08             	sub    $0x8,%esp
  80091d:	ff 75 0c             	pushl  0xc(%ebp)
  800920:	53                   	push   %ebx
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	ff d0                	call   *%eax
  800926:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800929:	ff 4d e4             	decl   -0x1c(%ebp)
  80092c:	89 f0                	mov    %esi,%eax
  80092e:	8d 70 01             	lea    0x1(%eax),%esi
  800931:	8a 00                	mov    (%eax),%al
  800933:	0f be d8             	movsbl %al,%ebx
  800936:	85 db                	test   %ebx,%ebx
  800938:	74 24                	je     80095e <vprintfmt+0x24b>
  80093a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80093e:	78 b8                	js     8008f8 <vprintfmt+0x1e5>
  800940:	ff 4d e0             	decl   -0x20(%ebp)
  800943:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800947:	79 af                	jns    8008f8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800949:	eb 13                	jmp    80095e <vprintfmt+0x24b>
				putch(' ', putdat);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	6a 20                	push   $0x20
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	ff d0                	call   *%eax
  800958:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80095b:	ff 4d e4             	decl   -0x1c(%ebp)
  80095e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800962:	7f e7                	jg     80094b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800964:	e9 78 01 00 00       	jmp    800ae1 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800969:	83 ec 08             	sub    $0x8,%esp
  80096c:	ff 75 e8             	pushl  -0x18(%ebp)
  80096f:	8d 45 14             	lea    0x14(%ebp),%eax
  800972:	50                   	push   %eax
  800973:	e8 3c fd ff ff       	call   8006b4 <getint>
  800978:	83 c4 10             	add    $0x10,%esp
  80097b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800981:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800984:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800987:	85 d2                	test   %edx,%edx
  800989:	79 23                	jns    8009ae <vprintfmt+0x29b>
				putch('-', putdat);
  80098b:	83 ec 08             	sub    $0x8,%esp
  80098e:	ff 75 0c             	pushl  0xc(%ebp)
  800991:	6a 2d                	push   $0x2d
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	ff d0                	call   *%eax
  800998:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80099b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80099e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009a1:	f7 d8                	neg    %eax
  8009a3:	83 d2 00             	adc    $0x0,%edx
  8009a6:	f7 da                	neg    %edx
  8009a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009ae:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009b5:	e9 bc 00 00 00       	jmp    800a76 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009ba:	83 ec 08             	sub    $0x8,%esp
  8009bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8009c0:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c3:	50                   	push   %eax
  8009c4:	e8 84 fc ff ff       	call   80064d <getuint>
  8009c9:	83 c4 10             	add    $0x10,%esp
  8009cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009d2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d9:	e9 98 00 00 00       	jmp    800a76 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009de:	83 ec 08             	sub    $0x8,%esp
  8009e1:	ff 75 0c             	pushl  0xc(%ebp)
  8009e4:	6a 58                	push   $0x58
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	ff d0                	call   *%eax
  8009eb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009ee:	83 ec 08             	sub    $0x8,%esp
  8009f1:	ff 75 0c             	pushl  0xc(%ebp)
  8009f4:	6a 58                	push   $0x58
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	ff d0                	call   *%eax
  8009fb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009fe:	83 ec 08             	sub    $0x8,%esp
  800a01:	ff 75 0c             	pushl  0xc(%ebp)
  800a04:	6a 58                	push   $0x58
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	ff d0                	call   *%eax
  800a0b:	83 c4 10             	add    $0x10,%esp
			break;
  800a0e:	e9 ce 00 00 00       	jmp    800ae1 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 0c             	pushl  0xc(%ebp)
  800a19:	6a 30                	push   $0x30
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	ff d0                	call   *%eax
  800a20:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	ff 75 0c             	pushl  0xc(%ebp)
  800a29:	6a 78                	push   $0x78
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	ff d0                	call   *%eax
  800a30:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a33:	8b 45 14             	mov    0x14(%ebp),%eax
  800a36:	83 c0 04             	add    $0x4,%eax
  800a39:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3f:	83 e8 04             	sub    $0x4,%eax
  800a42:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a4e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a55:	eb 1f                	jmp    800a76 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a57:	83 ec 08             	sub    $0x8,%esp
  800a5a:	ff 75 e8             	pushl  -0x18(%ebp)
  800a5d:	8d 45 14             	lea    0x14(%ebp),%eax
  800a60:	50                   	push   %eax
  800a61:	e8 e7 fb ff ff       	call   80064d <getuint>
  800a66:	83 c4 10             	add    $0x10,%esp
  800a69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a6f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a76:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a7d:	83 ec 04             	sub    $0x4,%esp
  800a80:	52                   	push   %edx
  800a81:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a84:	50                   	push   %eax
  800a85:	ff 75 f4             	pushl  -0xc(%ebp)
  800a88:	ff 75 f0             	pushl  -0x10(%ebp)
  800a8b:	ff 75 0c             	pushl  0xc(%ebp)
  800a8e:	ff 75 08             	pushl  0x8(%ebp)
  800a91:	e8 00 fb ff ff       	call   800596 <printnum>
  800a96:	83 c4 20             	add    $0x20,%esp
			break;
  800a99:	eb 46                	jmp    800ae1 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a9b:	83 ec 08             	sub    $0x8,%esp
  800a9e:	ff 75 0c             	pushl  0xc(%ebp)
  800aa1:	53                   	push   %ebx
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	ff d0                	call   *%eax
  800aa7:	83 c4 10             	add    $0x10,%esp
			break;
  800aaa:	eb 35                	jmp    800ae1 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800aac:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800ab3:	eb 2c                	jmp    800ae1 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ab5:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800abc:	eb 23                	jmp    800ae1 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800abe:	83 ec 08             	sub    $0x8,%esp
  800ac1:	ff 75 0c             	pushl  0xc(%ebp)
  800ac4:	6a 25                	push   $0x25
  800ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac9:	ff d0                	call   *%eax
  800acb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ace:	ff 4d 10             	decl   0x10(%ebp)
  800ad1:	eb 03                	jmp    800ad6 <vprintfmt+0x3c3>
  800ad3:	ff 4d 10             	decl   0x10(%ebp)
  800ad6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad9:	48                   	dec    %eax
  800ada:	8a 00                	mov    (%eax),%al
  800adc:	3c 25                	cmp    $0x25,%al
  800ade:	75 f3                	jne    800ad3 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ae0:	90                   	nop
		}
	}
  800ae1:	e9 35 fc ff ff       	jmp    80071b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ae6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ae7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aea:	5b                   	pop    %ebx
  800aeb:	5e                   	pop    %esi
  800aec:	5d                   	pop    %ebp
  800aed:	c3                   	ret    

00800aee <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800af4:	8d 45 10             	lea    0x10(%ebp),%eax
  800af7:	83 c0 04             	add    $0x4,%eax
  800afa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800afd:	8b 45 10             	mov    0x10(%ebp),%eax
  800b00:	ff 75 f4             	pushl  -0xc(%ebp)
  800b03:	50                   	push   %eax
  800b04:	ff 75 0c             	pushl  0xc(%ebp)
  800b07:	ff 75 08             	pushl  0x8(%ebp)
  800b0a:	e8 04 fc ff ff       	call   800713 <vprintfmt>
  800b0f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b12:	90                   	nop
  800b13:	c9                   	leave  
  800b14:	c3                   	ret    

00800b15 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1b:	8b 40 08             	mov    0x8(%eax),%eax
  800b1e:	8d 50 01             	lea    0x1(%eax),%edx
  800b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b24:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2a:	8b 10                	mov    (%eax),%edx
  800b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2f:	8b 40 04             	mov    0x4(%eax),%eax
  800b32:	39 c2                	cmp    %eax,%edx
  800b34:	73 12                	jae    800b48 <sprintputch+0x33>
		*b->buf++ = ch;
  800b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b39:	8b 00                	mov    (%eax),%eax
  800b3b:	8d 48 01             	lea    0x1(%eax),%ecx
  800b3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b41:	89 0a                	mov    %ecx,(%edx)
  800b43:	8b 55 08             	mov    0x8(%ebp),%edx
  800b46:	88 10                	mov    %dl,(%eax)
}
  800b48:	90                   	nop
  800b49:	5d                   	pop    %ebp
  800b4a:	c3                   	ret    

00800b4b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	01 d0                	add    %edx,%eax
  800b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b70:	74 06                	je     800b78 <vsnprintf+0x2d>
  800b72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b76:	7f 07                	jg     800b7f <vsnprintf+0x34>
		return -E_INVAL;
  800b78:	b8 03 00 00 00       	mov    $0x3,%eax
  800b7d:	eb 20                	jmp    800b9f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b7f:	ff 75 14             	pushl  0x14(%ebp)
  800b82:	ff 75 10             	pushl  0x10(%ebp)
  800b85:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b88:	50                   	push   %eax
  800b89:	68 15 0b 80 00       	push   $0x800b15
  800b8e:	e8 80 fb ff ff       	call   800713 <vprintfmt>
  800b93:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b99:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b9f:	c9                   	leave  
  800ba0:	c3                   	ret    

00800ba1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ba1:	55                   	push   %ebp
  800ba2:	89 e5                	mov    %esp,%ebp
  800ba4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ba7:	8d 45 10             	lea    0x10(%ebp),%eax
  800baa:	83 c0 04             	add    $0x4,%eax
  800bad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb3:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb6:	50                   	push   %eax
  800bb7:	ff 75 0c             	pushl  0xc(%ebp)
  800bba:	ff 75 08             	pushl  0x8(%ebp)
  800bbd:	e8 89 ff ff ff       	call   800b4b <vsnprintf>
  800bc2:	83 c4 10             	add    $0x10,%esp
  800bc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bcb:	c9                   	leave  
  800bcc:	c3                   	ret    

00800bcd <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bda:	eb 06                	jmp    800be2 <strlen+0x15>
		n++;
  800bdc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bdf:	ff 45 08             	incl   0x8(%ebp)
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	8a 00                	mov    (%eax),%al
  800be7:	84 c0                	test   %al,%al
  800be9:	75 f1                	jne    800bdc <strlen+0xf>
		n++;
	return n;
  800beb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bee:	c9                   	leave  
  800bef:	c3                   	ret    

00800bf0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bf6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bfd:	eb 09                	jmp    800c08 <strnlen+0x18>
		n++;
  800bff:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c02:	ff 45 08             	incl   0x8(%ebp)
  800c05:	ff 4d 0c             	decl   0xc(%ebp)
  800c08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c0c:	74 09                	je     800c17 <strnlen+0x27>
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	84 c0                	test   %al,%al
  800c15:	75 e8                	jne    800bff <strnlen+0xf>
		n++;
	return n;
  800c17:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c1a:	c9                   	leave  
  800c1b:	c3                   	ret    

00800c1c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c28:	90                   	nop
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	8d 50 01             	lea    0x1(%eax),%edx
  800c2f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c35:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c38:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c3b:	8a 12                	mov    (%edx),%dl
  800c3d:	88 10                	mov    %dl,(%eax)
  800c3f:	8a 00                	mov    (%eax),%al
  800c41:	84 c0                	test   %al,%al
  800c43:	75 e4                	jne    800c29 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c45:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c48:	c9                   	leave  
  800c49:	c3                   	ret    

00800c4a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c5d:	eb 1f                	jmp    800c7e <strncpy+0x34>
		*dst++ = *src;
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	8d 50 01             	lea    0x1(%eax),%edx
  800c65:	89 55 08             	mov    %edx,0x8(%ebp)
  800c68:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6b:	8a 12                	mov    (%edx),%dl
  800c6d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c72:	8a 00                	mov    (%eax),%al
  800c74:	84 c0                	test   %al,%al
  800c76:	74 03                	je     800c7b <strncpy+0x31>
			src++;
  800c78:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c7b:	ff 45 fc             	incl   -0x4(%ebp)
  800c7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c81:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c84:	72 d9                	jb     800c5f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c86:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c89:	c9                   	leave  
  800c8a:	c3                   	ret    

00800c8b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c9b:	74 30                	je     800ccd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c9d:	eb 16                	jmp    800cb5 <strlcpy+0x2a>
			*dst++ = *src++;
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	8d 50 01             	lea    0x1(%eax),%edx
  800ca5:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cab:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cae:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cb1:	8a 12                	mov    (%edx),%dl
  800cb3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cb5:	ff 4d 10             	decl   0x10(%ebp)
  800cb8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cbc:	74 09                	je     800cc7 <strlcpy+0x3c>
  800cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc1:	8a 00                	mov    (%eax),%al
  800cc3:	84 c0                	test   %al,%al
  800cc5:	75 d8                	jne    800c9f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ccd:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd3:	29 c2                	sub    %eax,%edx
  800cd5:	89 d0                	mov    %edx,%eax
}
  800cd7:	c9                   	leave  
  800cd8:	c3                   	ret    

00800cd9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cdc:	eb 06                	jmp    800ce4 <strcmp+0xb>
		p++, q++;
  800cde:	ff 45 08             	incl   0x8(%ebp)
  800ce1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	8a 00                	mov    (%eax),%al
  800ce9:	84 c0                	test   %al,%al
  800ceb:	74 0e                	je     800cfb <strcmp+0x22>
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	8a 10                	mov    (%eax),%dl
  800cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf5:	8a 00                	mov    (%eax),%al
  800cf7:	38 c2                	cmp    %al,%dl
  800cf9:	74 e3                	je     800cde <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	8a 00                	mov    (%eax),%al
  800d00:	0f b6 d0             	movzbl %al,%edx
  800d03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	0f b6 c0             	movzbl %al,%eax
  800d0b:	29 c2                	sub    %eax,%edx
  800d0d:	89 d0                	mov    %edx,%eax
}
  800d0f:	5d                   	pop    %ebp
  800d10:	c3                   	ret    

00800d11 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d11:	55                   	push   %ebp
  800d12:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d14:	eb 09                	jmp    800d1f <strncmp+0xe>
		n--, p++, q++;
  800d16:	ff 4d 10             	decl   0x10(%ebp)
  800d19:	ff 45 08             	incl   0x8(%ebp)
  800d1c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d23:	74 17                	je     800d3c <strncmp+0x2b>
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	8a 00                	mov    (%eax),%al
  800d2a:	84 c0                	test   %al,%al
  800d2c:	74 0e                	je     800d3c <strncmp+0x2b>
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8a 10                	mov    (%eax),%dl
  800d33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d36:	8a 00                	mov    (%eax),%al
  800d38:	38 c2                	cmp    %al,%dl
  800d3a:	74 da                	je     800d16 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d3c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d40:	75 07                	jne    800d49 <strncmp+0x38>
		return 0;
  800d42:	b8 00 00 00 00       	mov    $0x0,%eax
  800d47:	eb 14                	jmp    800d5d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	8a 00                	mov    (%eax),%al
  800d4e:	0f b6 d0             	movzbl %al,%edx
  800d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d54:	8a 00                	mov    (%eax),%al
  800d56:	0f b6 c0             	movzbl %al,%eax
  800d59:	29 c2                	sub    %eax,%edx
  800d5b:	89 d0                	mov    %edx,%eax
}
  800d5d:	5d                   	pop    %ebp
  800d5e:	c3                   	ret    

00800d5f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
  800d62:	83 ec 04             	sub    $0x4,%esp
  800d65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d68:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d6b:	eb 12                	jmp    800d7f <strchr+0x20>
		if (*s == c)
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	8a 00                	mov    (%eax),%al
  800d72:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d75:	75 05                	jne    800d7c <strchr+0x1d>
			return (char *) s;
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	eb 11                	jmp    800d8d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d7c:	ff 45 08             	incl   0x8(%ebp)
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8a 00                	mov    (%eax),%al
  800d84:	84 c0                	test   %al,%al
  800d86:	75 e5                	jne    800d6d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d8d:	c9                   	leave  
  800d8e:	c3                   	ret    

00800d8f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	83 ec 04             	sub    $0x4,%esp
  800d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d98:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d9b:	eb 0d                	jmp    800daa <strfind+0x1b>
		if (*s == c)
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	8a 00                	mov    (%eax),%al
  800da2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800da5:	74 0e                	je     800db5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800da7:	ff 45 08             	incl   0x8(%ebp)
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dad:	8a 00                	mov    (%eax),%al
  800daf:	84 c0                	test   %al,%al
  800db1:	75 ea                	jne    800d9d <strfind+0xe>
  800db3:	eb 01                	jmp    800db6 <strfind+0x27>
		if (*s == c)
			break;
  800db5:	90                   	nop
	return (char *) s;
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db9:	c9                   	leave  
  800dba:	c3                   	ret    

00800dbb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dcd:	eb 0e                	jmp    800ddd <memset+0x22>
		*p++ = c;
  800dcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd2:	8d 50 01             	lea    0x1(%eax),%edx
  800dd5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ddb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ddd:	ff 4d f8             	decl   -0x8(%ebp)
  800de0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800de4:	79 e9                	jns    800dcf <memset+0x14>
		*p++ = c;

	return v;
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de9:	c9                   	leave  
  800dea:	c3                   	ret    

00800deb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dfd:	eb 16                	jmp    800e15 <memcpy+0x2a>
		*d++ = *s++;
  800dff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e02:	8d 50 01             	lea    0x1(%eax),%edx
  800e05:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e08:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e0b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e11:	8a 12                	mov    (%edx),%dl
  800e13:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e15:	8b 45 10             	mov    0x10(%ebp),%eax
  800e18:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e1b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1e:	85 c0                	test   %eax,%eax
  800e20:	75 dd                	jne    800dff <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e25:	c9                   	leave  
  800e26:	c3                   	ret    

00800e27 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e3f:	73 50                	jae    800e91 <memmove+0x6a>
  800e41:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e44:	8b 45 10             	mov    0x10(%ebp),%eax
  800e47:	01 d0                	add    %edx,%eax
  800e49:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e4c:	76 43                	jbe    800e91 <memmove+0x6a>
		s += n;
  800e4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e51:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e54:	8b 45 10             	mov    0x10(%ebp),%eax
  800e57:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e5a:	eb 10                	jmp    800e6c <memmove+0x45>
			*--d = *--s;
  800e5c:	ff 4d f8             	decl   -0x8(%ebp)
  800e5f:	ff 4d fc             	decl   -0x4(%ebp)
  800e62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e65:	8a 10                	mov    (%eax),%dl
  800e67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e6a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e72:	89 55 10             	mov    %edx,0x10(%ebp)
  800e75:	85 c0                	test   %eax,%eax
  800e77:	75 e3                	jne    800e5c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e79:	eb 23                	jmp    800e9e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7e:	8d 50 01             	lea    0x1(%eax),%edx
  800e81:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e84:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e87:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e8a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e8d:	8a 12                	mov    (%edx),%dl
  800e8f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e91:	8b 45 10             	mov    0x10(%ebp),%eax
  800e94:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e97:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9a:	85 c0                	test   %eax,%eax
  800e9c:	75 dd                	jne    800e7b <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea1:	c9                   	leave  
  800ea2:	c3                   	ret    

00800ea3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eb5:	eb 2a                	jmp    800ee1 <memcmp+0x3e>
		if (*s1 != *s2)
  800eb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eba:	8a 10                	mov    (%eax),%dl
  800ebc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebf:	8a 00                	mov    (%eax),%al
  800ec1:	38 c2                	cmp    %al,%dl
  800ec3:	74 16                	je     800edb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ec5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec8:	8a 00                	mov    (%eax),%al
  800eca:	0f b6 d0             	movzbl %al,%edx
  800ecd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed0:	8a 00                	mov    (%eax),%al
  800ed2:	0f b6 c0             	movzbl %al,%eax
  800ed5:	29 c2                	sub    %eax,%edx
  800ed7:	89 d0                	mov    %edx,%eax
  800ed9:	eb 18                	jmp    800ef3 <memcmp+0x50>
		s1++, s2++;
  800edb:	ff 45 fc             	incl   -0x4(%ebp)
  800ede:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ee1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee7:	89 55 10             	mov    %edx,0x10(%ebp)
  800eea:	85 c0                	test   %eax,%eax
  800eec:	75 c9                	jne    800eb7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800eee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef3:	c9                   	leave  
  800ef4:	c3                   	ret    

00800ef5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800efb:	8b 55 08             	mov    0x8(%ebp),%edx
  800efe:	8b 45 10             	mov    0x10(%ebp),%eax
  800f01:	01 d0                	add    %edx,%eax
  800f03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f06:	eb 15                	jmp    800f1d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	0f b6 d0             	movzbl %al,%edx
  800f10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f13:	0f b6 c0             	movzbl %al,%eax
  800f16:	39 c2                	cmp    %eax,%edx
  800f18:	74 0d                	je     800f27 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f1a:	ff 45 08             	incl   0x8(%ebp)
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f23:	72 e3                	jb     800f08 <memfind+0x13>
  800f25:	eb 01                	jmp    800f28 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f27:	90                   	nop
	return (void *) s;
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f2b:	c9                   	leave  
  800f2c:	c3                   	ret    

00800f2d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f3a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f41:	eb 03                	jmp    800f46 <strtol+0x19>
		s++;
  800f43:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	3c 20                	cmp    $0x20,%al
  800f4d:	74 f4                	je     800f43 <strtol+0x16>
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	8a 00                	mov    (%eax),%al
  800f54:	3c 09                	cmp    $0x9,%al
  800f56:	74 eb                	je     800f43 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f58:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5b:	8a 00                	mov    (%eax),%al
  800f5d:	3c 2b                	cmp    $0x2b,%al
  800f5f:	75 05                	jne    800f66 <strtol+0x39>
		s++;
  800f61:	ff 45 08             	incl   0x8(%ebp)
  800f64:	eb 13                	jmp    800f79 <strtol+0x4c>
	else if (*s == '-')
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	3c 2d                	cmp    $0x2d,%al
  800f6d:	75 0a                	jne    800f79 <strtol+0x4c>
		s++, neg = 1;
  800f6f:	ff 45 08             	incl   0x8(%ebp)
  800f72:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7d:	74 06                	je     800f85 <strtol+0x58>
  800f7f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f83:	75 20                	jne    800fa5 <strtol+0x78>
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	3c 30                	cmp    $0x30,%al
  800f8c:	75 17                	jne    800fa5 <strtol+0x78>
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	40                   	inc    %eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3c 78                	cmp    $0x78,%al
  800f96:	75 0d                	jne    800fa5 <strtol+0x78>
		s += 2, base = 16;
  800f98:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f9c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fa3:	eb 28                	jmp    800fcd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fa5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa9:	75 15                	jne    800fc0 <strtol+0x93>
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	3c 30                	cmp    $0x30,%al
  800fb2:	75 0c                	jne    800fc0 <strtol+0x93>
		s++, base = 8;
  800fb4:	ff 45 08             	incl   0x8(%ebp)
  800fb7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fbe:	eb 0d                	jmp    800fcd <strtol+0xa0>
	else if (base == 0)
  800fc0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc4:	75 07                	jne    800fcd <strtol+0xa0>
		base = 10;
  800fc6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	8a 00                	mov    (%eax),%al
  800fd2:	3c 2f                	cmp    $0x2f,%al
  800fd4:	7e 19                	jle    800fef <strtol+0xc2>
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	3c 39                	cmp    $0x39,%al
  800fdd:	7f 10                	jg     800fef <strtol+0xc2>
			dig = *s - '0';
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	8a 00                	mov    (%eax),%al
  800fe4:	0f be c0             	movsbl %al,%eax
  800fe7:	83 e8 30             	sub    $0x30,%eax
  800fea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fed:	eb 42                	jmp    801031 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	3c 60                	cmp    $0x60,%al
  800ff6:	7e 19                	jle    801011 <strtol+0xe4>
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	3c 7a                	cmp    $0x7a,%al
  800fff:	7f 10                	jg     801011 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	8a 00                	mov    (%eax),%al
  801006:	0f be c0             	movsbl %al,%eax
  801009:	83 e8 57             	sub    $0x57,%eax
  80100c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80100f:	eb 20                	jmp    801031 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	3c 40                	cmp    $0x40,%al
  801018:	7e 39                	jle    801053 <strtol+0x126>
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	3c 5a                	cmp    $0x5a,%al
  801021:	7f 30                	jg     801053 <strtol+0x126>
			dig = *s - 'A' + 10;
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	8a 00                	mov    (%eax),%al
  801028:	0f be c0             	movsbl %al,%eax
  80102b:	83 e8 37             	sub    $0x37,%eax
  80102e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801034:	3b 45 10             	cmp    0x10(%ebp),%eax
  801037:	7d 19                	jge    801052 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801039:	ff 45 08             	incl   0x8(%ebp)
  80103c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801043:	89 c2                	mov    %eax,%edx
  801045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801048:	01 d0                	add    %edx,%eax
  80104a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80104d:	e9 7b ff ff ff       	jmp    800fcd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801052:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801053:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801057:	74 08                	je     801061 <strtol+0x134>
		*endptr = (char *) s;
  801059:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105c:	8b 55 08             	mov    0x8(%ebp),%edx
  80105f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801061:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801065:	74 07                	je     80106e <strtol+0x141>
  801067:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106a:	f7 d8                	neg    %eax
  80106c:	eb 03                	jmp    801071 <strtol+0x144>
  80106e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801071:	c9                   	leave  
  801072:	c3                   	ret    

00801073 <ltostr>:

void
ltostr(long value, char *str)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801079:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801080:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801087:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80108b:	79 13                	jns    8010a0 <ltostr+0x2d>
	{
		neg = 1;
  80108d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801094:	8b 45 0c             	mov    0xc(%ebp),%eax
  801097:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80109a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80109d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010a8:	99                   	cltd   
  8010a9:	f7 f9                	idiv   %ecx
  8010ab:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b1:	8d 50 01             	lea    0x1(%eax),%edx
  8010b4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b7:	89 c2                	mov    %eax,%edx
  8010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bc:	01 d0                	add    %edx,%eax
  8010be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010c1:	83 c2 30             	add    $0x30,%edx
  8010c4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ce:	f7 e9                	imul   %ecx
  8010d0:	c1 fa 02             	sar    $0x2,%edx
  8010d3:	89 c8                	mov    %ecx,%eax
  8010d5:	c1 f8 1f             	sar    $0x1f,%eax
  8010d8:	29 c2                	sub    %eax,%edx
  8010da:	89 d0                	mov    %edx,%eax
  8010dc:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010e3:	75 bb                	jne    8010a0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ef:	48                   	dec    %eax
  8010f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f7:	74 3d                	je     801136 <ltostr+0xc3>
		start = 1 ;
  8010f9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801100:	eb 34                	jmp    801136 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801102:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801105:	8b 45 0c             	mov    0xc(%ebp),%eax
  801108:	01 d0                	add    %edx,%eax
  80110a:	8a 00                	mov    (%eax),%al
  80110c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80110f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	01 c2                	add    %eax,%edx
  801117:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80111a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111d:	01 c8                	add    %ecx,%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801123:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801126:	8b 45 0c             	mov    0xc(%ebp),%eax
  801129:	01 c2                	add    %eax,%edx
  80112b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80112e:	88 02                	mov    %al,(%edx)
		start++ ;
  801130:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801133:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801136:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801139:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80113c:	7c c4                	jl     801102 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80113e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801141:	8b 45 0c             	mov    0xc(%ebp),%eax
  801144:	01 d0                	add    %edx,%eax
  801146:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801149:	90                   	nop
  80114a:	c9                   	leave  
  80114b:	c3                   	ret    

0080114c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801152:	ff 75 08             	pushl  0x8(%ebp)
  801155:	e8 73 fa ff ff       	call   800bcd <strlen>
  80115a:	83 c4 04             	add    $0x4,%esp
  80115d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801160:	ff 75 0c             	pushl  0xc(%ebp)
  801163:	e8 65 fa ff ff       	call   800bcd <strlen>
  801168:	83 c4 04             	add    $0x4,%esp
  80116b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80116e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801175:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80117c:	eb 17                	jmp    801195 <strcconcat+0x49>
		final[s] = str1[s] ;
  80117e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801181:	8b 45 10             	mov    0x10(%ebp),%eax
  801184:	01 c2                	add    %eax,%edx
  801186:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	01 c8                	add    %ecx,%eax
  80118e:	8a 00                	mov    (%eax),%al
  801190:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801192:	ff 45 fc             	incl   -0x4(%ebp)
  801195:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801198:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80119b:	7c e1                	jl     80117e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80119d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011a4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011ab:	eb 1f                	jmp    8011cc <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b0:	8d 50 01             	lea    0x1(%eax),%edx
  8011b3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011b6:	89 c2                	mov    %eax,%edx
  8011b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bb:	01 c2                	add    %eax,%edx
  8011bd:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c3:	01 c8                	add    %ecx,%eax
  8011c5:	8a 00                	mov    (%eax),%al
  8011c7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011c9:	ff 45 f8             	incl   -0x8(%ebp)
  8011cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d2:	7c d9                	jl     8011ad <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011da:	01 d0                	add    %edx,%eax
  8011dc:	c6 00 00             	movb   $0x0,(%eax)
}
  8011df:	90                   	nop
  8011e0:	c9                   	leave  
  8011e1:	c3                   	ret    

008011e2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011e2:	55                   	push   %ebp
  8011e3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f1:	8b 00                	mov    (%eax),%eax
  8011f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fd:	01 d0                	add    %edx,%eax
  8011ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801205:	eb 0c                	jmp    801213 <strsplit+0x31>
			*string++ = 0;
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
  80120a:	8d 50 01             	lea    0x1(%eax),%edx
  80120d:	89 55 08             	mov    %edx,0x8(%ebp)
  801210:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	84 c0                	test   %al,%al
  80121a:	74 18                	je     801234 <strsplit+0x52>
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	0f be c0             	movsbl %al,%eax
  801224:	50                   	push   %eax
  801225:	ff 75 0c             	pushl  0xc(%ebp)
  801228:	e8 32 fb ff ff       	call   800d5f <strchr>
  80122d:	83 c4 08             	add    $0x8,%esp
  801230:	85 c0                	test   %eax,%eax
  801232:	75 d3                	jne    801207 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	8a 00                	mov    (%eax),%al
  801239:	84 c0                	test   %al,%al
  80123b:	74 5a                	je     801297 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80123d:	8b 45 14             	mov    0x14(%ebp),%eax
  801240:	8b 00                	mov    (%eax),%eax
  801242:	83 f8 0f             	cmp    $0xf,%eax
  801245:	75 07                	jne    80124e <strsplit+0x6c>
		{
			return 0;
  801247:	b8 00 00 00 00       	mov    $0x0,%eax
  80124c:	eb 66                	jmp    8012b4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80124e:	8b 45 14             	mov    0x14(%ebp),%eax
  801251:	8b 00                	mov    (%eax),%eax
  801253:	8d 48 01             	lea    0x1(%eax),%ecx
  801256:	8b 55 14             	mov    0x14(%ebp),%edx
  801259:	89 0a                	mov    %ecx,(%edx)
  80125b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801262:	8b 45 10             	mov    0x10(%ebp),%eax
  801265:	01 c2                	add    %eax,%edx
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80126c:	eb 03                	jmp    801271 <strsplit+0x8f>
			string++;
  80126e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	84 c0                	test   %al,%al
  801278:	74 8b                	je     801205 <strsplit+0x23>
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
  80127d:	8a 00                	mov    (%eax),%al
  80127f:	0f be c0             	movsbl %al,%eax
  801282:	50                   	push   %eax
  801283:	ff 75 0c             	pushl  0xc(%ebp)
  801286:	e8 d4 fa ff ff       	call   800d5f <strchr>
  80128b:	83 c4 08             	add    $0x8,%esp
  80128e:	85 c0                	test   %eax,%eax
  801290:	74 dc                	je     80126e <strsplit+0x8c>
			string++;
	}
  801292:	e9 6e ff ff ff       	jmp    801205 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801297:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801298:	8b 45 14             	mov    0x14(%ebp),%eax
  80129b:	8b 00                	mov    (%eax),%eax
  80129d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a7:	01 d0                	add    %edx,%eax
  8012a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012af:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012b4:	c9                   	leave  
  8012b5:	c3                   	ret    

008012b6 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8012b6:	55                   	push   %ebp
  8012b7:	89 e5                	mov    %esp,%ebp
  8012b9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8012bc:	83 ec 04             	sub    $0x4,%esp
  8012bf:	68 c8 21 80 00       	push   $0x8021c8
  8012c4:	68 3f 01 00 00       	push   $0x13f
  8012c9:	68 ea 21 80 00       	push   $0x8021ea
  8012ce:	e8 a9 ef ff ff       	call   80027c <_panic>

008012d3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012d3:	55                   	push   %ebp
  8012d4:	89 e5                	mov    %esp,%ebp
  8012d6:	57                   	push   %edi
  8012d7:	56                   	push   %esi
  8012d8:	53                   	push   %ebx
  8012d9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012e5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012e8:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012eb:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012ee:	cd 30                	int    $0x30
  8012f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012f6:	83 c4 10             	add    $0x10,%esp
  8012f9:	5b                   	pop    %ebx
  8012fa:	5e                   	pop    %esi
  8012fb:	5f                   	pop    %edi
  8012fc:	5d                   	pop    %ebp
  8012fd:	c3                   	ret    

008012fe <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
  801301:	83 ec 04             	sub    $0x4,%esp
  801304:	8b 45 10             	mov    0x10(%ebp),%eax
  801307:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80130a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	6a 00                	push   $0x0
  801313:	6a 00                	push   $0x0
  801315:	52                   	push   %edx
  801316:	ff 75 0c             	pushl  0xc(%ebp)
  801319:	50                   	push   %eax
  80131a:	6a 00                	push   $0x0
  80131c:	e8 b2 ff ff ff       	call   8012d3 <syscall>
  801321:	83 c4 18             	add    $0x18,%esp
}
  801324:	90                   	nop
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <sys_cgetc>:

int
sys_cgetc(void)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80132a:	6a 00                	push   $0x0
  80132c:	6a 00                	push   $0x0
  80132e:	6a 00                	push   $0x0
  801330:	6a 00                	push   $0x0
  801332:	6a 00                	push   $0x0
  801334:	6a 02                	push   $0x2
  801336:	e8 98 ff ff ff       	call   8012d3 <syscall>
  80133b:	83 c4 18             	add    $0x18,%esp
}
  80133e:	c9                   	leave  
  80133f:	c3                   	ret    

00801340 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801343:	6a 00                	push   $0x0
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 03                	push   $0x3
  80134f:	e8 7f ff ff ff       	call   8012d3 <syscall>
  801354:	83 c4 18             	add    $0x18,%esp
}
  801357:	90                   	nop
  801358:	c9                   	leave  
  801359:	c3                   	ret    

0080135a <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80135d:	6a 00                	push   $0x0
  80135f:	6a 00                	push   $0x0
  801361:	6a 00                	push   $0x0
  801363:	6a 00                	push   $0x0
  801365:	6a 00                	push   $0x0
  801367:	6a 04                	push   $0x4
  801369:	e8 65 ff ff ff       	call   8012d3 <syscall>
  80136e:	83 c4 18             	add    $0x18,%esp
}
  801371:	90                   	nop
  801372:	c9                   	leave  
  801373:	c3                   	ret    

00801374 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801374:	55                   	push   %ebp
  801375:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801377:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137a:	8b 45 08             	mov    0x8(%ebp),%eax
  80137d:	6a 00                	push   $0x0
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	52                   	push   %edx
  801384:	50                   	push   %eax
  801385:	6a 08                	push   $0x8
  801387:	e8 47 ff ff ff       	call   8012d3 <syscall>
  80138c:	83 c4 18             	add    $0x18,%esp
}
  80138f:	c9                   	leave  
  801390:	c3                   	ret    

00801391 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
  801394:	56                   	push   %esi
  801395:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801396:	8b 75 18             	mov    0x18(%ebp),%esi
  801399:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80139c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80139f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	56                   	push   %esi
  8013a6:	53                   	push   %ebx
  8013a7:	51                   	push   %ecx
  8013a8:	52                   	push   %edx
  8013a9:	50                   	push   %eax
  8013aa:	6a 09                	push   $0x9
  8013ac:	e8 22 ff ff ff       	call   8012d3 <syscall>
  8013b1:	83 c4 18             	add    $0x18,%esp
}
  8013b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013b7:	5b                   	pop    %ebx
  8013b8:	5e                   	pop    %esi
  8013b9:	5d                   	pop    %ebp
  8013ba:	c3                   	ret    

008013bb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 00                	push   $0x0
  8013ca:	52                   	push   %edx
  8013cb:	50                   	push   %eax
  8013cc:	6a 0a                	push   $0xa
  8013ce:	e8 00 ff ff ff       	call   8012d3 <syscall>
  8013d3:	83 c4 18             	add    $0x18,%esp
}
  8013d6:	c9                   	leave  
  8013d7:	c3                   	ret    

008013d8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013db:	6a 00                	push   $0x0
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	ff 75 0c             	pushl  0xc(%ebp)
  8013e4:	ff 75 08             	pushl  0x8(%ebp)
  8013e7:	6a 0b                	push   $0xb
  8013e9:	e8 e5 fe ff ff       	call   8012d3 <syscall>
  8013ee:	83 c4 18             	add    $0x18,%esp
}
  8013f1:	c9                   	leave  
  8013f2:	c3                   	ret    

008013f3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	6a 0c                	push   $0xc
  801402:	e8 cc fe ff ff       	call   8012d3 <syscall>
  801407:	83 c4 18             	add    $0x18,%esp
}
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    

0080140c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80140f:	6a 00                	push   $0x0
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	6a 0d                	push   $0xd
  80141b:	e8 b3 fe ff ff       	call   8012d3 <syscall>
  801420:	83 c4 18             	add    $0x18,%esp
}
  801423:	c9                   	leave  
  801424:	c3                   	ret    

00801425 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	6a 0e                	push   $0xe
  801434:	e8 9a fe ff ff       	call   8012d3 <syscall>
  801439:	83 c4 18             	add    $0x18,%esp
}
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 00                	push   $0x0
  801449:	6a 00                	push   $0x0
  80144b:	6a 0f                	push   $0xf
  80144d:	e8 81 fe ff ff       	call   8012d3 <syscall>
  801452:	83 c4 18             	add    $0x18,%esp
}
  801455:	c9                   	leave  
  801456:	c3                   	ret    

00801457 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	ff 75 08             	pushl  0x8(%ebp)
  801465:	6a 10                	push   $0x10
  801467:	e8 67 fe ff ff       	call   8012d3 <syscall>
  80146c:	83 c4 18             	add    $0x18,%esp
}
  80146f:	c9                   	leave  
  801470:	c3                   	ret    

00801471 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801474:	6a 00                	push   $0x0
  801476:	6a 00                	push   $0x0
  801478:	6a 00                	push   $0x0
  80147a:	6a 00                	push   $0x0
  80147c:	6a 00                	push   $0x0
  80147e:	6a 11                	push   $0x11
  801480:	e8 4e fe ff ff       	call   8012d3 <syscall>
  801485:	83 c4 18             	add    $0x18,%esp
}
  801488:	90                   	nop
  801489:	c9                   	leave  
  80148a:	c3                   	ret    

0080148b <sys_cputc>:

void
sys_cputc(const char c)
{
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
  80148e:	83 ec 04             	sub    $0x4,%esp
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801497:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80149b:	6a 00                	push   $0x0
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	50                   	push   %eax
  8014a4:	6a 01                	push   $0x1
  8014a6:	e8 28 fe ff ff       	call   8012d3 <syscall>
  8014ab:	83 c4 18             	add    $0x18,%esp
}
  8014ae:	90                   	nop
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    

008014b1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 14                	push   $0x14
  8014c0:	e8 0e fe ff ff       	call   8012d3 <syscall>
  8014c5:	83 c4 18             	add    $0x18,%esp
}
  8014c8:	90                   	nop
  8014c9:	c9                   	leave  
  8014ca:	c3                   	ret    

008014cb <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
  8014ce:	83 ec 04             	sub    $0x4,%esp
  8014d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014d7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014da:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	6a 00                	push   $0x0
  8014e3:	51                   	push   %ecx
  8014e4:	52                   	push   %edx
  8014e5:	ff 75 0c             	pushl  0xc(%ebp)
  8014e8:	50                   	push   %eax
  8014e9:	6a 15                	push   $0x15
  8014eb:	e8 e3 fd ff ff       	call   8012d3 <syscall>
  8014f0:	83 c4 18             	add    $0x18,%esp
}
  8014f3:	c9                   	leave  
  8014f4:	c3                   	ret    

008014f5 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	52                   	push   %edx
  801505:	50                   	push   %eax
  801506:	6a 16                	push   $0x16
  801508:	e8 c6 fd ff ff       	call   8012d3 <syscall>
  80150d:	83 c4 18             	add    $0x18,%esp
}
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801515:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801518:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	51                   	push   %ecx
  801523:	52                   	push   %edx
  801524:	50                   	push   %eax
  801525:	6a 17                	push   $0x17
  801527:	e8 a7 fd ff ff       	call   8012d3 <syscall>
  80152c:	83 c4 18             	add    $0x18,%esp
}
  80152f:	c9                   	leave  
  801530:	c3                   	ret    

00801531 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801531:	55                   	push   %ebp
  801532:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801534:	8b 55 0c             	mov    0xc(%ebp),%edx
  801537:	8b 45 08             	mov    0x8(%ebp),%eax
  80153a:	6a 00                	push   $0x0
  80153c:	6a 00                	push   $0x0
  80153e:	6a 00                	push   $0x0
  801540:	52                   	push   %edx
  801541:	50                   	push   %eax
  801542:	6a 18                	push   $0x18
  801544:	e8 8a fd ff ff       	call   8012d3 <syscall>
  801549:	83 c4 18             	add    $0x18,%esp
}
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    

0080154e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	6a 00                	push   $0x0
  801556:	ff 75 14             	pushl  0x14(%ebp)
  801559:	ff 75 10             	pushl  0x10(%ebp)
  80155c:	ff 75 0c             	pushl  0xc(%ebp)
  80155f:	50                   	push   %eax
  801560:	6a 19                	push   $0x19
  801562:	e8 6c fd ff ff       	call   8012d3 <syscall>
  801567:	83 c4 18             	add    $0x18,%esp
}
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <sys_run_env>:

void sys_run_env(int32 envId)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80156f:	8b 45 08             	mov    0x8(%ebp),%eax
  801572:	6a 00                	push   $0x0
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	50                   	push   %eax
  80157b:	6a 1a                	push   $0x1a
  80157d:	e8 51 fd ff ff       	call   8012d3 <syscall>
  801582:	83 c4 18             	add    $0x18,%esp
}
  801585:	90                   	nop
  801586:	c9                   	leave  
  801587:	c3                   	ret    

00801588 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	50                   	push   %eax
  801597:	6a 1b                	push   $0x1b
  801599:	e8 35 fd ff ff       	call   8012d3 <syscall>
  80159e:	83 c4 18             	add    $0x18,%esp
}
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 05                	push   $0x5
  8015b2:	e8 1c fd ff ff       	call   8012d3 <syscall>
  8015b7:	83 c4 18             	add    $0x18,%esp
}
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 06                	push   $0x6
  8015cb:	e8 03 fd ff ff       	call   8012d3 <syscall>
  8015d0:	83 c4 18             	add    $0x18,%esp
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 07                	push   $0x7
  8015e4:	e8 ea fc ff ff       	call   8012d3 <syscall>
  8015e9:	83 c4 18             	add    $0x18,%esp
}
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <sys_exit_env>:


void sys_exit_env(void)
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 1c                	push   $0x1c
  8015fd:	e8 d1 fc ff ff       	call   8012d3 <syscall>
  801602:	83 c4 18             	add    $0x18,%esp
}
  801605:	90                   	nop
  801606:	c9                   	leave  
  801607:	c3                   	ret    

00801608 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
  80160b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80160e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801611:	8d 50 04             	lea    0x4(%eax),%edx
  801614:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	52                   	push   %edx
  80161e:	50                   	push   %eax
  80161f:	6a 1d                	push   $0x1d
  801621:	e8 ad fc ff ff       	call   8012d3 <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
	return result;
  801629:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80162c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80162f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801632:	89 01                	mov    %eax,(%ecx)
  801634:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801637:	8b 45 08             	mov    0x8(%ebp),%eax
  80163a:	c9                   	leave  
  80163b:	c2 04 00             	ret    $0x4

0080163e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	ff 75 10             	pushl  0x10(%ebp)
  801648:	ff 75 0c             	pushl  0xc(%ebp)
  80164b:	ff 75 08             	pushl  0x8(%ebp)
  80164e:	6a 13                	push   $0x13
  801650:	e8 7e fc ff ff       	call   8012d3 <syscall>
  801655:	83 c4 18             	add    $0x18,%esp
	return ;
  801658:	90                   	nop
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <sys_rcr2>:
uint32 sys_rcr2()
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 1e                	push   $0x1e
  80166a:	e8 64 fc ff ff       	call   8012d3 <syscall>
  80166f:	83 c4 18             	add    $0x18,%esp
}
  801672:	c9                   	leave  
  801673:	c3                   	ret    

00801674 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
  801677:	83 ec 04             	sub    $0x4,%esp
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801680:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	50                   	push   %eax
  80168d:	6a 1f                	push   $0x1f
  80168f:	e8 3f fc ff ff       	call   8012d3 <syscall>
  801694:	83 c4 18             	add    $0x18,%esp
	return ;
  801697:	90                   	nop
}
  801698:	c9                   	leave  
  801699:	c3                   	ret    

0080169a <rsttst>:
void rsttst()
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 21                	push   $0x21
  8016a9:	e8 25 fc ff ff       	call   8012d3 <syscall>
  8016ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8016b1:	90                   	nop
}
  8016b2:	c9                   	leave  
  8016b3:	c3                   	ret    

008016b4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
  8016b7:	83 ec 04             	sub    $0x4,%esp
  8016ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8016bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016c0:	8b 55 18             	mov    0x18(%ebp),%edx
  8016c3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016c7:	52                   	push   %edx
  8016c8:	50                   	push   %eax
  8016c9:	ff 75 10             	pushl  0x10(%ebp)
  8016cc:	ff 75 0c             	pushl  0xc(%ebp)
  8016cf:	ff 75 08             	pushl  0x8(%ebp)
  8016d2:	6a 20                	push   $0x20
  8016d4:	e8 fa fb ff ff       	call   8012d3 <syscall>
  8016d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8016dc:	90                   	nop
}
  8016dd:	c9                   	leave  
  8016de:	c3                   	ret    

008016df <chktst>:
void chktst(uint32 n)
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	ff 75 08             	pushl  0x8(%ebp)
  8016ed:	6a 22                	push   $0x22
  8016ef:	e8 df fb ff ff       	call   8012d3 <syscall>
  8016f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f7:	90                   	nop
}
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <inctst>:

void inctst()
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 23                	push   $0x23
  801709:	e8 c5 fb ff ff       	call   8012d3 <syscall>
  80170e:	83 c4 18             	add    $0x18,%esp
	return ;
  801711:	90                   	nop
}
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <gettst>:
uint32 gettst()
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 24                	push   $0x24
  801723:	e8 ab fb ff ff       	call   8012d3 <syscall>
  801728:	83 c4 18             	add    $0x18,%esp
}
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 25                	push   $0x25
  80173f:	e8 8f fb ff ff       	call   8012d3 <syscall>
  801744:	83 c4 18             	add    $0x18,%esp
  801747:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80174a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80174e:	75 07                	jne    801757 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801750:	b8 01 00 00 00       	mov    $0x1,%eax
  801755:	eb 05                	jmp    80175c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801757:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    

0080175e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 25                	push   $0x25
  801770:	e8 5e fb ff ff       	call   8012d3 <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
  801778:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80177b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80177f:	75 07                	jne    801788 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801781:	b8 01 00 00 00       	mov    $0x1,%eax
  801786:	eb 05                	jmp    80178d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801788:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
  801792:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 25                	push   $0x25
  8017a1:	e8 2d fb ff ff       	call   8012d3 <syscall>
  8017a6:	83 c4 18             	add    $0x18,%esp
  8017a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017ac:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017b0:	75 07                	jne    8017b9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8017b7:	eb 05                	jmp    8017be <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 25                	push   $0x25
  8017d2:	e8 fc fa ff ff       	call   8012d3 <syscall>
  8017d7:	83 c4 18             	add    $0x18,%esp
  8017da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017dd:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017e1:	75 07                	jne    8017ea <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8017e8:	eb 05                	jmp    8017ef <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ef:	c9                   	leave  
  8017f0:	c3                   	ret    

008017f1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	ff 75 08             	pushl  0x8(%ebp)
  8017ff:	6a 26                	push   $0x26
  801801:	e8 cd fa ff ff       	call   8012d3 <syscall>
  801806:	83 c4 18             	add    $0x18,%esp
	return ;
  801809:	90                   	nop
}
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801810:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801813:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801816:	8b 55 0c             	mov    0xc(%ebp),%edx
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	6a 00                	push   $0x0
  80181e:	53                   	push   %ebx
  80181f:	51                   	push   %ecx
  801820:	52                   	push   %edx
  801821:	50                   	push   %eax
  801822:	6a 27                	push   $0x27
  801824:	e8 aa fa ff ff       	call   8012d3 <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
}
  80182c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801834:	8b 55 0c             	mov    0xc(%ebp),%edx
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	52                   	push   %edx
  801841:	50                   	push   %eax
  801842:	6a 28                	push   $0x28
  801844:	e8 8a fa ff ff       	call   8012d3 <syscall>
  801849:	83 c4 18             	add    $0x18,%esp
}
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801851:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801854:	8b 55 0c             	mov    0xc(%ebp),%edx
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	6a 00                	push   $0x0
  80185c:	51                   	push   %ecx
  80185d:	ff 75 10             	pushl  0x10(%ebp)
  801860:	52                   	push   %edx
  801861:	50                   	push   %eax
  801862:	6a 29                	push   $0x29
  801864:	e8 6a fa ff ff       	call   8012d3 <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	ff 75 10             	pushl  0x10(%ebp)
  801878:	ff 75 0c             	pushl  0xc(%ebp)
  80187b:	ff 75 08             	pushl  0x8(%ebp)
  80187e:	6a 12                	push   $0x12
  801880:	e8 4e fa ff ff       	call   8012d3 <syscall>
  801885:	83 c4 18             	add    $0x18,%esp
	return ;
  801888:	90                   	nop
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80188e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801891:	8b 45 08             	mov    0x8(%ebp),%eax
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	52                   	push   %edx
  80189b:	50                   	push   %eax
  80189c:	6a 2a                	push   $0x2a
  80189e:	e8 30 fa ff ff       	call   8012d3 <syscall>
  8018a3:	83 c4 18             	add    $0x18,%esp
	return;
  8018a6:	90                   	nop
}
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
  8018ac:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8018af:	83 ec 04             	sub    $0x4,%esp
  8018b2:	68 f7 21 80 00       	push   $0x8021f7
  8018b7:	68 2e 01 00 00       	push   $0x12e
  8018bc:	68 0b 22 80 00       	push   $0x80220b
  8018c1:	e8 b6 e9 ff ff       	call   80027c <_panic>

008018c6 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
  8018c9:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8018cc:	83 ec 04             	sub    $0x4,%esp
  8018cf:	68 f7 21 80 00       	push   $0x8021f7
  8018d4:	68 35 01 00 00       	push   $0x135
  8018d9:	68 0b 22 80 00       	push   $0x80220b
  8018de:	e8 99 e9 ff ff       	call   80027c <_panic>

008018e3 <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8018e9:	83 ec 04             	sub    $0x4,%esp
  8018ec:	68 f7 21 80 00       	push   $0x8021f7
  8018f1:	68 3b 01 00 00       	push   $0x13b
  8018f6:	68 0b 22 80 00       	push   $0x80220b
  8018fb:	e8 7c e9 ff ff       	call   80027c <_panic>

00801900 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  801906:	83 ec 04             	sub    $0x4,%esp
  801909:	68 1c 22 80 00       	push   $0x80221c
  80190e:	6a 09                	push   $0x9
  801910:	68 44 22 80 00       	push   $0x802244
  801915:	e8 62 e9 ff ff       	call   80027c <_panic>

0080191a <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  801920:	83 ec 04             	sub    $0x4,%esp
  801923:	68 54 22 80 00       	push   $0x802254
  801928:	6a 10                	push   $0x10
  80192a:	68 44 22 80 00       	push   $0x802244
  80192f:	e8 48 e9 ff ff       	call   80027c <_panic>

00801934 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  80193a:	83 ec 04             	sub    $0x4,%esp
  80193d:	68 7c 22 80 00       	push   $0x80227c
  801942:	6a 18                	push   $0x18
  801944:	68 44 22 80 00       	push   $0x802244
  801949:	e8 2e e9 ff ff       	call   80027c <_panic>

0080194e <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  801954:	83 ec 04             	sub    $0x4,%esp
  801957:	68 a4 22 80 00       	push   $0x8022a4
  80195c:	6a 20                	push   $0x20
  80195e:	68 44 22 80 00       	push   $0x802244
  801963:	e8 14 e9 ff ff       	call   80027c <_panic>

00801968 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	8b 40 10             	mov    0x10(%eax),%eax
}
  801971:	5d                   	pop    %ebp
  801972:	c3                   	ret    
  801973:	90                   	nop

00801974 <__udivdi3>:
  801974:	55                   	push   %ebp
  801975:	57                   	push   %edi
  801976:	56                   	push   %esi
  801977:	53                   	push   %ebx
  801978:	83 ec 1c             	sub    $0x1c,%esp
  80197b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80197f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801983:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801987:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80198b:	89 ca                	mov    %ecx,%edx
  80198d:	89 f8                	mov    %edi,%eax
  80198f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801993:	85 f6                	test   %esi,%esi
  801995:	75 2d                	jne    8019c4 <__udivdi3+0x50>
  801997:	39 cf                	cmp    %ecx,%edi
  801999:	77 65                	ja     801a00 <__udivdi3+0x8c>
  80199b:	89 fd                	mov    %edi,%ebp
  80199d:	85 ff                	test   %edi,%edi
  80199f:	75 0b                	jne    8019ac <__udivdi3+0x38>
  8019a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8019a6:	31 d2                	xor    %edx,%edx
  8019a8:	f7 f7                	div    %edi
  8019aa:	89 c5                	mov    %eax,%ebp
  8019ac:	31 d2                	xor    %edx,%edx
  8019ae:	89 c8                	mov    %ecx,%eax
  8019b0:	f7 f5                	div    %ebp
  8019b2:	89 c1                	mov    %eax,%ecx
  8019b4:	89 d8                	mov    %ebx,%eax
  8019b6:	f7 f5                	div    %ebp
  8019b8:	89 cf                	mov    %ecx,%edi
  8019ba:	89 fa                	mov    %edi,%edx
  8019bc:	83 c4 1c             	add    $0x1c,%esp
  8019bf:	5b                   	pop    %ebx
  8019c0:	5e                   	pop    %esi
  8019c1:	5f                   	pop    %edi
  8019c2:	5d                   	pop    %ebp
  8019c3:	c3                   	ret    
  8019c4:	39 ce                	cmp    %ecx,%esi
  8019c6:	77 28                	ja     8019f0 <__udivdi3+0x7c>
  8019c8:	0f bd fe             	bsr    %esi,%edi
  8019cb:	83 f7 1f             	xor    $0x1f,%edi
  8019ce:	75 40                	jne    801a10 <__udivdi3+0x9c>
  8019d0:	39 ce                	cmp    %ecx,%esi
  8019d2:	72 0a                	jb     8019de <__udivdi3+0x6a>
  8019d4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019d8:	0f 87 9e 00 00 00    	ja     801a7c <__udivdi3+0x108>
  8019de:	b8 01 00 00 00       	mov    $0x1,%eax
  8019e3:	89 fa                	mov    %edi,%edx
  8019e5:	83 c4 1c             	add    $0x1c,%esp
  8019e8:	5b                   	pop    %ebx
  8019e9:	5e                   	pop    %esi
  8019ea:	5f                   	pop    %edi
  8019eb:	5d                   	pop    %ebp
  8019ec:	c3                   	ret    
  8019ed:	8d 76 00             	lea    0x0(%esi),%esi
  8019f0:	31 ff                	xor    %edi,%edi
  8019f2:	31 c0                	xor    %eax,%eax
  8019f4:	89 fa                	mov    %edi,%edx
  8019f6:	83 c4 1c             	add    $0x1c,%esp
  8019f9:	5b                   	pop    %ebx
  8019fa:	5e                   	pop    %esi
  8019fb:	5f                   	pop    %edi
  8019fc:	5d                   	pop    %ebp
  8019fd:	c3                   	ret    
  8019fe:	66 90                	xchg   %ax,%ax
  801a00:	89 d8                	mov    %ebx,%eax
  801a02:	f7 f7                	div    %edi
  801a04:	31 ff                	xor    %edi,%edi
  801a06:	89 fa                	mov    %edi,%edx
  801a08:	83 c4 1c             	add    $0x1c,%esp
  801a0b:	5b                   	pop    %ebx
  801a0c:	5e                   	pop    %esi
  801a0d:	5f                   	pop    %edi
  801a0e:	5d                   	pop    %ebp
  801a0f:	c3                   	ret    
  801a10:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a15:	89 eb                	mov    %ebp,%ebx
  801a17:	29 fb                	sub    %edi,%ebx
  801a19:	89 f9                	mov    %edi,%ecx
  801a1b:	d3 e6                	shl    %cl,%esi
  801a1d:	89 c5                	mov    %eax,%ebp
  801a1f:	88 d9                	mov    %bl,%cl
  801a21:	d3 ed                	shr    %cl,%ebp
  801a23:	89 e9                	mov    %ebp,%ecx
  801a25:	09 f1                	or     %esi,%ecx
  801a27:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a2b:	89 f9                	mov    %edi,%ecx
  801a2d:	d3 e0                	shl    %cl,%eax
  801a2f:	89 c5                	mov    %eax,%ebp
  801a31:	89 d6                	mov    %edx,%esi
  801a33:	88 d9                	mov    %bl,%cl
  801a35:	d3 ee                	shr    %cl,%esi
  801a37:	89 f9                	mov    %edi,%ecx
  801a39:	d3 e2                	shl    %cl,%edx
  801a3b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a3f:	88 d9                	mov    %bl,%cl
  801a41:	d3 e8                	shr    %cl,%eax
  801a43:	09 c2                	or     %eax,%edx
  801a45:	89 d0                	mov    %edx,%eax
  801a47:	89 f2                	mov    %esi,%edx
  801a49:	f7 74 24 0c          	divl   0xc(%esp)
  801a4d:	89 d6                	mov    %edx,%esi
  801a4f:	89 c3                	mov    %eax,%ebx
  801a51:	f7 e5                	mul    %ebp
  801a53:	39 d6                	cmp    %edx,%esi
  801a55:	72 19                	jb     801a70 <__udivdi3+0xfc>
  801a57:	74 0b                	je     801a64 <__udivdi3+0xf0>
  801a59:	89 d8                	mov    %ebx,%eax
  801a5b:	31 ff                	xor    %edi,%edi
  801a5d:	e9 58 ff ff ff       	jmp    8019ba <__udivdi3+0x46>
  801a62:	66 90                	xchg   %ax,%ax
  801a64:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a68:	89 f9                	mov    %edi,%ecx
  801a6a:	d3 e2                	shl    %cl,%edx
  801a6c:	39 c2                	cmp    %eax,%edx
  801a6e:	73 e9                	jae    801a59 <__udivdi3+0xe5>
  801a70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a73:	31 ff                	xor    %edi,%edi
  801a75:	e9 40 ff ff ff       	jmp    8019ba <__udivdi3+0x46>
  801a7a:	66 90                	xchg   %ax,%ax
  801a7c:	31 c0                	xor    %eax,%eax
  801a7e:	e9 37 ff ff ff       	jmp    8019ba <__udivdi3+0x46>
  801a83:	90                   	nop

00801a84 <__umoddi3>:
  801a84:	55                   	push   %ebp
  801a85:	57                   	push   %edi
  801a86:	56                   	push   %esi
  801a87:	53                   	push   %ebx
  801a88:	83 ec 1c             	sub    $0x1c,%esp
  801a8b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a97:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a9f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801aa3:	89 f3                	mov    %esi,%ebx
  801aa5:	89 fa                	mov    %edi,%edx
  801aa7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801aab:	89 34 24             	mov    %esi,(%esp)
  801aae:	85 c0                	test   %eax,%eax
  801ab0:	75 1a                	jne    801acc <__umoddi3+0x48>
  801ab2:	39 f7                	cmp    %esi,%edi
  801ab4:	0f 86 a2 00 00 00    	jbe    801b5c <__umoddi3+0xd8>
  801aba:	89 c8                	mov    %ecx,%eax
  801abc:	89 f2                	mov    %esi,%edx
  801abe:	f7 f7                	div    %edi
  801ac0:	89 d0                	mov    %edx,%eax
  801ac2:	31 d2                	xor    %edx,%edx
  801ac4:	83 c4 1c             	add    $0x1c,%esp
  801ac7:	5b                   	pop    %ebx
  801ac8:	5e                   	pop    %esi
  801ac9:	5f                   	pop    %edi
  801aca:	5d                   	pop    %ebp
  801acb:	c3                   	ret    
  801acc:	39 f0                	cmp    %esi,%eax
  801ace:	0f 87 ac 00 00 00    	ja     801b80 <__umoddi3+0xfc>
  801ad4:	0f bd e8             	bsr    %eax,%ebp
  801ad7:	83 f5 1f             	xor    $0x1f,%ebp
  801ada:	0f 84 ac 00 00 00    	je     801b8c <__umoddi3+0x108>
  801ae0:	bf 20 00 00 00       	mov    $0x20,%edi
  801ae5:	29 ef                	sub    %ebp,%edi
  801ae7:	89 fe                	mov    %edi,%esi
  801ae9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801aed:	89 e9                	mov    %ebp,%ecx
  801aef:	d3 e0                	shl    %cl,%eax
  801af1:	89 d7                	mov    %edx,%edi
  801af3:	89 f1                	mov    %esi,%ecx
  801af5:	d3 ef                	shr    %cl,%edi
  801af7:	09 c7                	or     %eax,%edi
  801af9:	89 e9                	mov    %ebp,%ecx
  801afb:	d3 e2                	shl    %cl,%edx
  801afd:	89 14 24             	mov    %edx,(%esp)
  801b00:	89 d8                	mov    %ebx,%eax
  801b02:	d3 e0                	shl    %cl,%eax
  801b04:	89 c2                	mov    %eax,%edx
  801b06:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b0a:	d3 e0                	shl    %cl,%eax
  801b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b10:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b14:	89 f1                	mov    %esi,%ecx
  801b16:	d3 e8                	shr    %cl,%eax
  801b18:	09 d0                	or     %edx,%eax
  801b1a:	d3 eb                	shr    %cl,%ebx
  801b1c:	89 da                	mov    %ebx,%edx
  801b1e:	f7 f7                	div    %edi
  801b20:	89 d3                	mov    %edx,%ebx
  801b22:	f7 24 24             	mull   (%esp)
  801b25:	89 c6                	mov    %eax,%esi
  801b27:	89 d1                	mov    %edx,%ecx
  801b29:	39 d3                	cmp    %edx,%ebx
  801b2b:	0f 82 87 00 00 00    	jb     801bb8 <__umoddi3+0x134>
  801b31:	0f 84 91 00 00 00    	je     801bc8 <__umoddi3+0x144>
  801b37:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b3b:	29 f2                	sub    %esi,%edx
  801b3d:	19 cb                	sbb    %ecx,%ebx
  801b3f:	89 d8                	mov    %ebx,%eax
  801b41:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b45:	d3 e0                	shl    %cl,%eax
  801b47:	89 e9                	mov    %ebp,%ecx
  801b49:	d3 ea                	shr    %cl,%edx
  801b4b:	09 d0                	or     %edx,%eax
  801b4d:	89 e9                	mov    %ebp,%ecx
  801b4f:	d3 eb                	shr    %cl,%ebx
  801b51:	89 da                	mov    %ebx,%edx
  801b53:	83 c4 1c             	add    $0x1c,%esp
  801b56:	5b                   	pop    %ebx
  801b57:	5e                   	pop    %esi
  801b58:	5f                   	pop    %edi
  801b59:	5d                   	pop    %ebp
  801b5a:	c3                   	ret    
  801b5b:	90                   	nop
  801b5c:	89 fd                	mov    %edi,%ebp
  801b5e:	85 ff                	test   %edi,%edi
  801b60:	75 0b                	jne    801b6d <__umoddi3+0xe9>
  801b62:	b8 01 00 00 00       	mov    $0x1,%eax
  801b67:	31 d2                	xor    %edx,%edx
  801b69:	f7 f7                	div    %edi
  801b6b:	89 c5                	mov    %eax,%ebp
  801b6d:	89 f0                	mov    %esi,%eax
  801b6f:	31 d2                	xor    %edx,%edx
  801b71:	f7 f5                	div    %ebp
  801b73:	89 c8                	mov    %ecx,%eax
  801b75:	f7 f5                	div    %ebp
  801b77:	89 d0                	mov    %edx,%eax
  801b79:	e9 44 ff ff ff       	jmp    801ac2 <__umoddi3+0x3e>
  801b7e:	66 90                	xchg   %ax,%ax
  801b80:	89 c8                	mov    %ecx,%eax
  801b82:	89 f2                	mov    %esi,%edx
  801b84:	83 c4 1c             	add    $0x1c,%esp
  801b87:	5b                   	pop    %ebx
  801b88:	5e                   	pop    %esi
  801b89:	5f                   	pop    %edi
  801b8a:	5d                   	pop    %ebp
  801b8b:	c3                   	ret    
  801b8c:	3b 04 24             	cmp    (%esp),%eax
  801b8f:	72 06                	jb     801b97 <__umoddi3+0x113>
  801b91:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b95:	77 0f                	ja     801ba6 <__umoddi3+0x122>
  801b97:	89 f2                	mov    %esi,%edx
  801b99:	29 f9                	sub    %edi,%ecx
  801b9b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b9f:	89 14 24             	mov    %edx,(%esp)
  801ba2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ba6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801baa:	8b 14 24             	mov    (%esp),%edx
  801bad:	83 c4 1c             	add    $0x1c,%esp
  801bb0:	5b                   	pop    %ebx
  801bb1:	5e                   	pop    %esi
  801bb2:	5f                   	pop    %edi
  801bb3:	5d                   	pop    %ebp
  801bb4:	c3                   	ret    
  801bb5:	8d 76 00             	lea    0x0(%esi),%esi
  801bb8:	2b 04 24             	sub    (%esp),%eax
  801bbb:	19 fa                	sbb    %edi,%edx
  801bbd:	89 d1                	mov    %edx,%ecx
  801bbf:	89 c6                	mov    %eax,%esi
  801bc1:	e9 71 ff ff ff       	jmp    801b37 <__umoddi3+0xb3>
  801bc6:	66 90                	xchg   %ax,%ax
  801bc8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bcc:	72 ea                	jb     801bb8 <__umoddi3+0x134>
  801bce:	89 d9                	mov    %ebx,%ecx
  801bd0:	e9 62 ff ff ff       	jmp    801b37 <__umoddi3+0xb3>
