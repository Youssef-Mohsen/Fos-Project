
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
  800049:	68 c0 1b 80 00       	push   $0x801bc0
  80004e:	e8 62 14 00 00       	call   8014b5 <sys_createSharedObject>
  800053:	83 c4 10             	add    $0x10,%esp

	struct semaphore cnc1 = create_semaphore("cnc1", 1);
  800056:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	6a 01                	push   $0x1
  80005e:	68 c0 1b 80 00       	push   $0x801bc0
  800063:	50                   	push   %eax
  800064:	e8 7d 18 00 00       	call   8018e6 <create_semaphore>
  800069:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = create_semaphore("depend1", 0);
  80006c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80006f:	83 ec 04             	sub    $0x4,%esp
  800072:	6a 00                	push   $0x0
  800074:	68 c5 1b 80 00       	push   $0x801bc5
  800079:	50                   	push   %eax
  80007a:	e8 67 18 00 00       	call   8018e6 <create_semaphore>
  80007f:	83 c4 0c             	add    $0xc,%esp

	uint32 id1, id2;
	id2 = sys_create_env("qs2", (myEnv->page_WS_max_size), (myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800082:	a1 04 30 80 00       	mov    0x803004,%eax
  800087:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  80008d:	a1 04 30 80 00       	mov    0x803004,%eax
  800092:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  800098:	89 c1                	mov    %eax,%ecx
  80009a:	a1 04 30 80 00       	mov    0x803004,%eax
  80009f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000a5:	52                   	push   %edx
  8000a6:	51                   	push   %ecx
  8000a7:	50                   	push   %eax
  8000a8:	68 cd 1b 80 00       	push   $0x801bcd
  8000ad:	e8 86 14 00 00       	call   801538 <sys_create_env>
  8000b2:	83 c4 10             	add    $0x10,%esp
  8000b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	id1 = sys_create_env("qs1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000b8:	a1 04 30 80 00       	mov    0x803004,%eax
  8000bd:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  8000c3:	a1 04 30 80 00       	mov    0x803004,%eax
  8000c8:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  8000ce:	89 c1                	mov    %eax,%ecx
  8000d0:	a1 04 30 80 00       	mov    0x803004,%eax
  8000d5:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000db:	52                   	push   %edx
  8000dc:	51                   	push   %ecx
  8000dd:	50                   	push   %eax
  8000de:	68 d1 1b 80 00       	push   $0x801bd1
  8000e3:	e8 50 14 00 00       	call   801538 <sys_create_env>
  8000e8:	83 c4 10             	add    $0x10,%esp
  8000eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (id1 == E_ENV_CREATION_ERROR || id2 == E_ENV_CREATION_ERROR)
  8000ee:	83 7d f0 ef          	cmpl   $0xffffffef,-0x10(%ebp)
  8000f2:	74 06                	je     8000fa <_main+0xc2>
  8000f4:	83 7d f4 ef          	cmpl   $0xffffffef,-0xc(%ebp)
  8000f8:	75 14                	jne    80010e <_main+0xd6>
		panic("NO AVAILABLE ENVs...");
  8000fa:	83 ec 04             	sub    $0x4,%esp
  8000fd:	68 d5 1b 80 00       	push   $0x801bd5
  800102:	6a 11                	push   $0x11
  800104:	68 ea 1b 80 00       	push   $0x801bea
  800109:	e8 58 01 00 00       	call   800266 <_panic>

	sys_run_env(id2);
  80010e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	50                   	push   %eax
  800115:	e8 3c 14 00 00       	call   801556 <sys_run_env>
  80011a:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id1);
  80011d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	50                   	push   %eax
  800124:	e8 2d 14 00 00       	call   801556 <sys_run_env>
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
  800135:	e8 6c 14 00 00       	call   8015a6 <sys_getenvindex>
  80013a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80013d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800140:	89 d0                	mov    %edx,%eax
  800142:	c1 e0 02             	shl    $0x2,%eax
  800145:	01 d0                	add    %edx,%eax
  800147:	01 c0                	add    %eax,%eax
  800149:	01 d0                	add    %edx,%eax
  80014b:	c1 e0 02             	shl    $0x2,%eax
  80014e:	01 d0                	add    %edx,%eax
  800150:	01 c0                	add    %eax,%eax
  800152:	01 d0                	add    %edx,%eax
  800154:	c1 e0 04             	shl    $0x4,%eax
  800157:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80015c:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800161:	a1 04 30 80 00       	mov    0x803004,%eax
  800166:	8a 40 20             	mov    0x20(%eax),%al
  800169:	84 c0                	test   %al,%al
  80016b:	74 0d                	je     80017a <libmain+0x4b>
		binaryname = myEnv->prog_name;
  80016d:	a1 04 30 80 00       	mov    0x803004,%eax
  800172:	83 c0 20             	add    $0x20,%eax
  800175:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80017a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80017e:	7e 0a                	jle    80018a <libmain+0x5b>
		binaryname = argv[0];
  800180:	8b 45 0c             	mov    0xc(%ebp),%eax
  800183:	8b 00                	mov    (%eax),%eax
  800185:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80018a:	83 ec 08             	sub    $0x8,%esp
  80018d:	ff 75 0c             	pushl  0xc(%ebp)
  800190:	ff 75 08             	pushl  0x8(%ebp)
  800193:	e8 a0 fe ff ff       	call   800038 <_main>
  800198:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80019b:	e8 8a 11 00 00       	call   80132a <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001a0:	83 ec 0c             	sub    $0xc,%esp
  8001a3:	68 1c 1c 80 00       	push   $0x801c1c
  8001a8:	e8 76 03 00 00       	call   800523 <cprintf>
  8001ad:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001b0:	a1 04 30 80 00       	mov    0x803004,%eax
  8001b5:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8001bb:	a1 04 30 80 00       	mov    0x803004,%eax
  8001c0:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	52                   	push   %edx
  8001ca:	50                   	push   %eax
  8001cb:	68 44 1c 80 00       	push   $0x801c44
  8001d0:	e8 4e 03 00 00       	call   800523 <cprintf>
  8001d5:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001d8:	a1 04 30 80 00       	mov    0x803004,%eax
  8001dd:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  8001e3:	a1 04 30 80 00       	mov    0x803004,%eax
  8001e8:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  8001ee:	a1 04 30 80 00       	mov    0x803004,%eax
  8001f3:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8001f9:	51                   	push   %ecx
  8001fa:	52                   	push   %edx
  8001fb:	50                   	push   %eax
  8001fc:	68 6c 1c 80 00       	push   $0x801c6c
  800201:	e8 1d 03 00 00       	call   800523 <cprintf>
  800206:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800209:	a1 04 30 80 00       	mov    0x803004,%eax
  80020e:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800214:	83 ec 08             	sub    $0x8,%esp
  800217:	50                   	push   %eax
  800218:	68 c4 1c 80 00       	push   $0x801cc4
  80021d:	e8 01 03 00 00       	call   800523 <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800225:	83 ec 0c             	sub    $0xc,%esp
  800228:	68 1c 1c 80 00       	push   $0x801c1c
  80022d:	e8 f1 02 00 00       	call   800523 <cprintf>
  800232:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800235:	e8 0a 11 00 00       	call   801344 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80023a:	e8 19 00 00 00       	call   800258 <exit>
}
  80023f:	90                   	nop
  800240:	c9                   	leave  
  800241:	c3                   	ret    

00800242 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800242:	55                   	push   %ebp
  800243:	89 e5                	mov    %esp,%ebp
  800245:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	6a 00                	push   $0x0
  80024d:	e8 20 13 00 00       	call   801572 <sys_destroy_env>
  800252:	83 c4 10             	add    $0x10,%esp
}
  800255:	90                   	nop
  800256:	c9                   	leave  
  800257:	c3                   	ret    

00800258 <exit>:

void
exit(void)
{
  800258:	55                   	push   %ebp
  800259:	89 e5                	mov    %esp,%ebp
  80025b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80025e:	e8 75 13 00 00       	call   8015d8 <sys_exit_env>
}
  800263:	90                   	nop
  800264:	c9                   	leave  
  800265:	c3                   	ret    

00800266 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80026c:	8d 45 10             	lea    0x10(%ebp),%eax
  80026f:	83 c0 04             	add    $0x4,%eax
  800272:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800275:	a1 24 30 80 00       	mov    0x803024,%eax
  80027a:	85 c0                	test   %eax,%eax
  80027c:	74 16                	je     800294 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80027e:	a1 24 30 80 00       	mov    0x803024,%eax
  800283:	83 ec 08             	sub    $0x8,%esp
  800286:	50                   	push   %eax
  800287:	68 d8 1c 80 00       	push   $0x801cd8
  80028c:	e8 92 02 00 00       	call   800523 <cprintf>
  800291:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800294:	a1 00 30 80 00       	mov    0x803000,%eax
  800299:	ff 75 0c             	pushl  0xc(%ebp)
  80029c:	ff 75 08             	pushl  0x8(%ebp)
  80029f:	50                   	push   %eax
  8002a0:	68 dd 1c 80 00       	push   $0x801cdd
  8002a5:	e8 79 02 00 00       	call   800523 <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b0:	83 ec 08             	sub    $0x8,%esp
  8002b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8002b6:	50                   	push   %eax
  8002b7:	e8 fc 01 00 00       	call   8004b8 <vcprintf>
  8002bc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002bf:	83 ec 08             	sub    $0x8,%esp
  8002c2:	6a 00                	push   $0x0
  8002c4:	68 f9 1c 80 00       	push   $0x801cf9
  8002c9:	e8 ea 01 00 00       	call   8004b8 <vcprintf>
  8002ce:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002d1:	e8 82 ff ff ff       	call   800258 <exit>

	// should not return here
	while (1) ;
  8002d6:	eb fe                	jmp    8002d6 <_panic+0x70>

008002d8 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002d8:	55                   	push   %ebp
  8002d9:	89 e5                	mov    %esp,%ebp
  8002db:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002de:	a1 04 30 80 00       	mov    0x803004,%eax
  8002e3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8002e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ec:	39 c2                	cmp    %eax,%edx
  8002ee:	74 14                	je     800304 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	68 fc 1c 80 00       	push   $0x801cfc
  8002f8:	6a 26                	push   $0x26
  8002fa:	68 48 1d 80 00       	push   $0x801d48
  8002ff:	e8 62 ff ff ff       	call   800266 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800304:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80030b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800312:	e9 c5 00 00 00       	jmp    8003dc <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800317:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80031a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800321:	8b 45 08             	mov    0x8(%ebp),%eax
  800324:	01 d0                	add    %edx,%eax
  800326:	8b 00                	mov    (%eax),%eax
  800328:	85 c0                	test   %eax,%eax
  80032a:	75 08                	jne    800334 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80032c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80032f:	e9 a5 00 00 00       	jmp    8003d9 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800334:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80033b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800342:	eb 69                	jmp    8003ad <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800344:	a1 04 30 80 00       	mov    0x803004,%eax
  800349:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80034f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800352:	89 d0                	mov    %edx,%eax
  800354:	01 c0                	add    %eax,%eax
  800356:	01 d0                	add    %edx,%eax
  800358:	c1 e0 03             	shl    $0x3,%eax
  80035b:	01 c8                	add    %ecx,%eax
  80035d:	8a 40 04             	mov    0x4(%eax),%al
  800360:	84 c0                	test   %al,%al
  800362:	75 46                	jne    8003aa <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800364:	a1 04 30 80 00       	mov    0x803004,%eax
  800369:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80036f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800372:	89 d0                	mov    %edx,%eax
  800374:	01 c0                	add    %eax,%eax
  800376:	01 d0                	add    %edx,%eax
  800378:	c1 e0 03             	shl    $0x3,%eax
  80037b:	01 c8                	add    %ecx,%eax
  80037d:	8b 00                	mov    (%eax),%eax
  80037f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800382:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800385:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80038a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80038c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80038f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800396:	8b 45 08             	mov    0x8(%ebp),%eax
  800399:	01 c8                	add    %ecx,%eax
  80039b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80039d:	39 c2                	cmp    %eax,%edx
  80039f:	75 09                	jne    8003aa <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003a1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003a8:	eb 15                	jmp    8003bf <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003aa:	ff 45 e8             	incl   -0x18(%ebp)
  8003ad:	a1 04 30 80 00       	mov    0x803004,%eax
  8003b2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003bb:	39 c2                	cmp    %eax,%edx
  8003bd:	77 85                	ja     800344 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003c3:	75 14                	jne    8003d9 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003c5:	83 ec 04             	sub    $0x4,%esp
  8003c8:	68 54 1d 80 00       	push   $0x801d54
  8003cd:	6a 3a                	push   $0x3a
  8003cf:	68 48 1d 80 00       	push   $0x801d48
  8003d4:	e8 8d fe ff ff       	call   800266 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003d9:	ff 45 f0             	incl   -0x10(%ebp)
  8003dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003df:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003e2:	0f 8c 2f ff ff ff    	jl     800317 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ef:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003f6:	eb 26                	jmp    80041e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003f8:	a1 04 30 80 00       	mov    0x803004,%eax
  8003fd:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800403:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800406:	89 d0                	mov    %edx,%eax
  800408:	01 c0                	add    %eax,%eax
  80040a:	01 d0                	add    %edx,%eax
  80040c:	c1 e0 03             	shl    $0x3,%eax
  80040f:	01 c8                	add    %ecx,%eax
  800411:	8a 40 04             	mov    0x4(%eax),%al
  800414:	3c 01                	cmp    $0x1,%al
  800416:	75 03                	jne    80041b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800418:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80041b:	ff 45 e0             	incl   -0x20(%ebp)
  80041e:	a1 04 30 80 00       	mov    0x803004,%eax
  800423:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800429:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042c:	39 c2                	cmp    %eax,%edx
  80042e:	77 c8                	ja     8003f8 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800433:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800436:	74 14                	je     80044c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800438:	83 ec 04             	sub    $0x4,%esp
  80043b:	68 a8 1d 80 00       	push   $0x801da8
  800440:	6a 44                	push   $0x44
  800442:	68 48 1d 80 00       	push   $0x801d48
  800447:	e8 1a fe ff ff       	call   800266 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80044c:	90                   	nop
  80044d:	c9                   	leave  
  80044e:	c3                   	ret    

0080044f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80044f:	55                   	push   %ebp
  800450:	89 e5                	mov    %esp,%ebp
  800452:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800455:	8b 45 0c             	mov    0xc(%ebp),%eax
  800458:	8b 00                	mov    (%eax),%eax
  80045a:	8d 48 01             	lea    0x1(%eax),%ecx
  80045d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800460:	89 0a                	mov    %ecx,(%edx)
  800462:	8b 55 08             	mov    0x8(%ebp),%edx
  800465:	88 d1                	mov    %dl,%cl
  800467:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80046e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800471:	8b 00                	mov    (%eax),%eax
  800473:	3d ff 00 00 00       	cmp    $0xff,%eax
  800478:	75 2c                	jne    8004a6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80047a:	a0 08 30 80 00       	mov    0x803008,%al
  80047f:	0f b6 c0             	movzbl %al,%eax
  800482:	8b 55 0c             	mov    0xc(%ebp),%edx
  800485:	8b 12                	mov    (%edx),%edx
  800487:	89 d1                	mov    %edx,%ecx
  800489:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048c:	83 c2 08             	add    $0x8,%edx
  80048f:	83 ec 04             	sub    $0x4,%esp
  800492:	50                   	push   %eax
  800493:	51                   	push   %ecx
  800494:	52                   	push   %edx
  800495:	e8 4e 0e 00 00       	call   8012e8 <sys_cputs>
  80049a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80049d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a9:	8b 40 04             	mov    0x4(%eax),%eax
  8004ac:	8d 50 01             	lea    0x1(%eax),%edx
  8004af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004b5:	90                   	nop
  8004b6:	c9                   	leave  
  8004b7:	c3                   	ret    

008004b8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004b8:	55                   	push   %ebp
  8004b9:	89 e5                	mov    %esp,%ebp
  8004bb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004c8:	00 00 00 
	b.cnt = 0;
  8004cb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004d2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004d5:	ff 75 0c             	pushl  0xc(%ebp)
  8004d8:	ff 75 08             	pushl  0x8(%ebp)
  8004db:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e1:	50                   	push   %eax
  8004e2:	68 4f 04 80 00       	push   $0x80044f
  8004e7:	e8 11 02 00 00       	call   8006fd <vprintfmt>
  8004ec:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004ef:	a0 08 30 80 00       	mov    0x803008,%al
  8004f4:	0f b6 c0             	movzbl %al,%eax
  8004f7:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004fd:	83 ec 04             	sub    $0x4,%esp
  800500:	50                   	push   %eax
  800501:	52                   	push   %edx
  800502:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800508:	83 c0 08             	add    $0x8,%eax
  80050b:	50                   	push   %eax
  80050c:	e8 d7 0d 00 00       	call   8012e8 <sys_cputs>
  800511:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800514:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  80051b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800521:	c9                   	leave  
  800522:	c3                   	ret    

00800523 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800523:	55                   	push   %ebp
  800524:	89 e5                	mov    %esp,%ebp
  800526:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800529:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800530:	8d 45 0c             	lea    0xc(%ebp),%eax
  800533:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800536:	8b 45 08             	mov    0x8(%ebp),%eax
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	ff 75 f4             	pushl  -0xc(%ebp)
  80053f:	50                   	push   %eax
  800540:	e8 73 ff ff ff       	call   8004b8 <vcprintf>
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80054b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80054e:	c9                   	leave  
  80054f:	c3                   	ret    

00800550 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800550:	55                   	push   %ebp
  800551:	89 e5                	mov    %esp,%ebp
  800553:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800556:	e8 cf 0d 00 00       	call   80132a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80055b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80055e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800561:	8b 45 08             	mov    0x8(%ebp),%eax
  800564:	83 ec 08             	sub    $0x8,%esp
  800567:	ff 75 f4             	pushl  -0xc(%ebp)
  80056a:	50                   	push   %eax
  80056b:	e8 48 ff ff ff       	call   8004b8 <vcprintf>
  800570:	83 c4 10             	add    $0x10,%esp
  800573:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800576:	e8 c9 0d 00 00       	call   801344 <sys_unlock_cons>
	return cnt;
  80057b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80057e:	c9                   	leave  
  80057f:	c3                   	ret    

00800580 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800580:	55                   	push   %ebp
  800581:	89 e5                	mov    %esp,%ebp
  800583:	53                   	push   %ebx
  800584:	83 ec 14             	sub    $0x14,%esp
  800587:	8b 45 10             	mov    0x10(%ebp),%eax
  80058a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800593:	8b 45 18             	mov    0x18(%ebp),%eax
  800596:	ba 00 00 00 00       	mov    $0x0,%edx
  80059b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80059e:	77 55                	ja     8005f5 <printnum+0x75>
  8005a0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a3:	72 05                	jb     8005aa <printnum+0x2a>
  8005a5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005a8:	77 4b                	ja     8005f5 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005aa:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005ad:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005b0:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b8:	52                   	push   %edx
  8005b9:	50                   	push   %eax
  8005ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8005bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8005c0:	e8 97 13 00 00       	call   80195c <__udivdi3>
  8005c5:	83 c4 10             	add    $0x10,%esp
  8005c8:	83 ec 04             	sub    $0x4,%esp
  8005cb:	ff 75 20             	pushl  0x20(%ebp)
  8005ce:	53                   	push   %ebx
  8005cf:	ff 75 18             	pushl  0x18(%ebp)
  8005d2:	52                   	push   %edx
  8005d3:	50                   	push   %eax
  8005d4:	ff 75 0c             	pushl  0xc(%ebp)
  8005d7:	ff 75 08             	pushl  0x8(%ebp)
  8005da:	e8 a1 ff ff ff       	call   800580 <printnum>
  8005df:	83 c4 20             	add    $0x20,%esp
  8005e2:	eb 1a                	jmp    8005fe <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005e4:	83 ec 08             	sub    $0x8,%esp
  8005e7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ea:	ff 75 20             	pushl  0x20(%ebp)
  8005ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f0:	ff d0                	call   *%eax
  8005f2:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f5:	ff 4d 1c             	decl   0x1c(%ebp)
  8005f8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005fc:	7f e6                	jg     8005e4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005fe:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800601:	bb 00 00 00 00       	mov    $0x0,%ebx
  800606:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800609:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80060c:	53                   	push   %ebx
  80060d:	51                   	push   %ecx
  80060e:	52                   	push   %edx
  80060f:	50                   	push   %eax
  800610:	e8 57 14 00 00       	call   801a6c <__umoddi3>
  800615:	83 c4 10             	add    $0x10,%esp
  800618:	05 14 20 80 00       	add    $0x802014,%eax
  80061d:	8a 00                	mov    (%eax),%al
  80061f:	0f be c0             	movsbl %al,%eax
  800622:	83 ec 08             	sub    $0x8,%esp
  800625:	ff 75 0c             	pushl  0xc(%ebp)
  800628:	50                   	push   %eax
  800629:	8b 45 08             	mov    0x8(%ebp),%eax
  80062c:	ff d0                	call   *%eax
  80062e:	83 c4 10             	add    $0x10,%esp
}
  800631:	90                   	nop
  800632:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800635:	c9                   	leave  
  800636:	c3                   	ret    

00800637 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800637:	55                   	push   %ebp
  800638:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80063a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80063e:	7e 1c                	jle    80065c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800640:	8b 45 08             	mov    0x8(%ebp),%eax
  800643:	8b 00                	mov    (%eax),%eax
  800645:	8d 50 08             	lea    0x8(%eax),%edx
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	89 10                	mov    %edx,(%eax)
  80064d:	8b 45 08             	mov    0x8(%ebp),%eax
  800650:	8b 00                	mov    (%eax),%eax
  800652:	83 e8 08             	sub    $0x8,%eax
  800655:	8b 50 04             	mov    0x4(%eax),%edx
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	eb 40                	jmp    80069c <getuint+0x65>
	else if (lflag)
  80065c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800660:	74 1e                	je     800680 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	8b 00                	mov    (%eax),%eax
  800667:	8d 50 04             	lea    0x4(%eax),%edx
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	89 10                	mov    %edx,(%eax)
  80066f:	8b 45 08             	mov    0x8(%ebp),%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	83 e8 04             	sub    $0x4,%eax
  800677:	8b 00                	mov    (%eax),%eax
  800679:	ba 00 00 00 00       	mov    $0x0,%edx
  80067e:	eb 1c                	jmp    80069c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800680:	8b 45 08             	mov    0x8(%ebp),%eax
  800683:	8b 00                	mov    (%eax),%eax
  800685:	8d 50 04             	lea    0x4(%eax),%edx
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	89 10                	mov    %edx,(%eax)
  80068d:	8b 45 08             	mov    0x8(%ebp),%eax
  800690:	8b 00                	mov    (%eax),%eax
  800692:	83 e8 04             	sub    $0x4,%eax
  800695:	8b 00                	mov    (%eax),%eax
  800697:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80069c:	5d                   	pop    %ebp
  80069d:	c3                   	ret    

0080069e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80069e:	55                   	push   %ebp
  80069f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a5:	7e 1c                	jle    8006c3 <getint+0x25>
		return va_arg(*ap, long long);
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	8b 00                	mov    (%eax),%eax
  8006ac:	8d 50 08             	lea    0x8(%eax),%edx
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	89 10                	mov    %edx,(%eax)
  8006b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	83 e8 08             	sub    $0x8,%eax
  8006bc:	8b 50 04             	mov    0x4(%eax),%edx
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	eb 38                	jmp    8006fb <getint+0x5d>
	else if (lflag)
  8006c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c7:	74 1a                	je     8006e3 <getint+0x45>
		return va_arg(*ap, long);
  8006c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cc:	8b 00                	mov    (%eax),%eax
  8006ce:	8d 50 04             	lea    0x4(%eax),%edx
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	89 10                	mov    %edx,(%eax)
  8006d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	83 e8 04             	sub    $0x4,%eax
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	99                   	cltd   
  8006e1:	eb 18                	jmp    8006fb <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e6:	8b 00                	mov    (%eax),%eax
  8006e8:	8d 50 04             	lea    0x4(%eax),%edx
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	89 10                	mov    %edx,(%eax)
  8006f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	83 e8 04             	sub    $0x4,%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	99                   	cltd   
}
  8006fb:	5d                   	pop    %ebp
  8006fc:	c3                   	ret    

008006fd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
  800700:	56                   	push   %esi
  800701:	53                   	push   %ebx
  800702:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800705:	eb 17                	jmp    80071e <vprintfmt+0x21>
			if (ch == '\0')
  800707:	85 db                	test   %ebx,%ebx
  800709:	0f 84 c1 03 00 00    	je     800ad0 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80070f:	83 ec 08             	sub    $0x8,%esp
  800712:	ff 75 0c             	pushl  0xc(%ebp)
  800715:	53                   	push   %ebx
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	ff d0                	call   *%eax
  80071b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80071e:	8b 45 10             	mov    0x10(%ebp),%eax
  800721:	8d 50 01             	lea    0x1(%eax),%edx
  800724:	89 55 10             	mov    %edx,0x10(%ebp)
  800727:	8a 00                	mov    (%eax),%al
  800729:	0f b6 d8             	movzbl %al,%ebx
  80072c:	83 fb 25             	cmp    $0x25,%ebx
  80072f:	75 d6                	jne    800707 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800731:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800735:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80073c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800743:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80074a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800751:	8b 45 10             	mov    0x10(%ebp),%eax
  800754:	8d 50 01             	lea    0x1(%eax),%edx
  800757:	89 55 10             	mov    %edx,0x10(%ebp)
  80075a:	8a 00                	mov    (%eax),%al
  80075c:	0f b6 d8             	movzbl %al,%ebx
  80075f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800762:	83 f8 5b             	cmp    $0x5b,%eax
  800765:	0f 87 3d 03 00 00    	ja     800aa8 <vprintfmt+0x3ab>
  80076b:	8b 04 85 38 20 80 00 	mov    0x802038(,%eax,4),%eax
  800772:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800774:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800778:	eb d7                	jmp    800751 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80077a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80077e:	eb d1                	jmp    800751 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800780:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800787:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80078a:	89 d0                	mov    %edx,%eax
  80078c:	c1 e0 02             	shl    $0x2,%eax
  80078f:	01 d0                	add    %edx,%eax
  800791:	01 c0                	add    %eax,%eax
  800793:	01 d8                	add    %ebx,%eax
  800795:	83 e8 30             	sub    $0x30,%eax
  800798:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80079b:	8b 45 10             	mov    0x10(%ebp),%eax
  80079e:	8a 00                	mov    (%eax),%al
  8007a0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007a3:	83 fb 2f             	cmp    $0x2f,%ebx
  8007a6:	7e 3e                	jle    8007e6 <vprintfmt+0xe9>
  8007a8:	83 fb 39             	cmp    $0x39,%ebx
  8007ab:	7f 39                	jg     8007e6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ad:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b0:	eb d5                	jmp    800787 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	83 c0 04             	add    $0x4,%eax
  8007b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007be:	83 e8 04             	sub    $0x4,%eax
  8007c1:	8b 00                	mov    (%eax),%eax
  8007c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007c6:	eb 1f                	jmp    8007e7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007cc:	79 83                	jns    800751 <vprintfmt+0x54>
				width = 0;
  8007ce:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007d5:	e9 77 ff ff ff       	jmp    800751 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007da:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007e1:	e9 6b ff ff ff       	jmp    800751 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007e6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007eb:	0f 89 60 ff ff ff    	jns    800751 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007fe:	e9 4e ff ff ff       	jmp    800751 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800803:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800806:	e9 46 ff ff ff       	jmp    800751 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80080b:	8b 45 14             	mov    0x14(%ebp),%eax
  80080e:	83 c0 04             	add    $0x4,%eax
  800811:	89 45 14             	mov    %eax,0x14(%ebp)
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	83 e8 04             	sub    $0x4,%eax
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	ff 75 0c             	pushl  0xc(%ebp)
  800822:	50                   	push   %eax
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	ff d0                	call   *%eax
  800828:	83 c4 10             	add    $0x10,%esp
			break;
  80082b:	e9 9b 02 00 00       	jmp    800acb <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800830:	8b 45 14             	mov    0x14(%ebp),%eax
  800833:	83 c0 04             	add    $0x4,%eax
  800836:	89 45 14             	mov    %eax,0x14(%ebp)
  800839:	8b 45 14             	mov    0x14(%ebp),%eax
  80083c:	83 e8 04             	sub    $0x4,%eax
  80083f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800841:	85 db                	test   %ebx,%ebx
  800843:	79 02                	jns    800847 <vprintfmt+0x14a>
				err = -err;
  800845:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800847:	83 fb 64             	cmp    $0x64,%ebx
  80084a:	7f 0b                	jg     800857 <vprintfmt+0x15a>
  80084c:	8b 34 9d 80 1e 80 00 	mov    0x801e80(,%ebx,4),%esi
  800853:	85 f6                	test   %esi,%esi
  800855:	75 19                	jne    800870 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800857:	53                   	push   %ebx
  800858:	68 25 20 80 00       	push   $0x802025
  80085d:	ff 75 0c             	pushl  0xc(%ebp)
  800860:	ff 75 08             	pushl  0x8(%ebp)
  800863:	e8 70 02 00 00       	call   800ad8 <printfmt>
  800868:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80086b:	e9 5b 02 00 00       	jmp    800acb <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800870:	56                   	push   %esi
  800871:	68 2e 20 80 00       	push   $0x80202e
  800876:	ff 75 0c             	pushl  0xc(%ebp)
  800879:	ff 75 08             	pushl  0x8(%ebp)
  80087c:	e8 57 02 00 00       	call   800ad8 <printfmt>
  800881:	83 c4 10             	add    $0x10,%esp
			break;
  800884:	e9 42 02 00 00       	jmp    800acb <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800889:	8b 45 14             	mov    0x14(%ebp),%eax
  80088c:	83 c0 04             	add    $0x4,%eax
  80088f:	89 45 14             	mov    %eax,0x14(%ebp)
  800892:	8b 45 14             	mov    0x14(%ebp),%eax
  800895:	83 e8 04             	sub    $0x4,%eax
  800898:	8b 30                	mov    (%eax),%esi
  80089a:	85 f6                	test   %esi,%esi
  80089c:	75 05                	jne    8008a3 <vprintfmt+0x1a6>
				p = "(null)";
  80089e:	be 31 20 80 00       	mov    $0x802031,%esi
			if (width > 0 && padc != '-')
  8008a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a7:	7e 6d                	jle    800916 <vprintfmt+0x219>
  8008a9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008ad:	74 67                	je     800916 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	50                   	push   %eax
  8008b6:	56                   	push   %esi
  8008b7:	e8 1e 03 00 00       	call   800bda <strnlen>
  8008bc:	83 c4 10             	add    $0x10,%esp
  8008bf:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008c2:	eb 16                	jmp    8008da <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008c4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008c8:	83 ec 08             	sub    $0x8,%esp
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	50                   	push   %eax
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	ff d0                	call   *%eax
  8008d4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d7:	ff 4d e4             	decl   -0x1c(%ebp)
  8008da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008de:	7f e4                	jg     8008c4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e0:	eb 34                	jmp    800916 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008e2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008e6:	74 1c                	je     800904 <vprintfmt+0x207>
  8008e8:	83 fb 1f             	cmp    $0x1f,%ebx
  8008eb:	7e 05                	jle    8008f2 <vprintfmt+0x1f5>
  8008ed:	83 fb 7e             	cmp    $0x7e,%ebx
  8008f0:	7e 12                	jle    800904 <vprintfmt+0x207>
					putch('?', putdat);
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	ff 75 0c             	pushl  0xc(%ebp)
  8008f8:	6a 3f                	push   $0x3f
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	ff d0                	call   *%eax
  8008ff:	83 c4 10             	add    $0x10,%esp
  800902:	eb 0f                	jmp    800913 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800904:	83 ec 08             	sub    $0x8,%esp
  800907:	ff 75 0c             	pushl  0xc(%ebp)
  80090a:	53                   	push   %ebx
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	ff d0                	call   *%eax
  800910:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800913:	ff 4d e4             	decl   -0x1c(%ebp)
  800916:	89 f0                	mov    %esi,%eax
  800918:	8d 70 01             	lea    0x1(%eax),%esi
  80091b:	8a 00                	mov    (%eax),%al
  80091d:	0f be d8             	movsbl %al,%ebx
  800920:	85 db                	test   %ebx,%ebx
  800922:	74 24                	je     800948 <vprintfmt+0x24b>
  800924:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800928:	78 b8                	js     8008e2 <vprintfmt+0x1e5>
  80092a:	ff 4d e0             	decl   -0x20(%ebp)
  80092d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800931:	79 af                	jns    8008e2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800933:	eb 13                	jmp    800948 <vprintfmt+0x24b>
				putch(' ', putdat);
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	ff 75 0c             	pushl  0xc(%ebp)
  80093b:	6a 20                	push   $0x20
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	ff d0                	call   *%eax
  800942:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800945:	ff 4d e4             	decl   -0x1c(%ebp)
  800948:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094c:	7f e7                	jg     800935 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80094e:	e9 78 01 00 00       	jmp    800acb <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800953:	83 ec 08             	sub    $0x8,%esp
  800956:	ff 75 e8             	pushl  -0x18(%ebp)
  800959:	8d 45 14             	lea    0x14(%ebp),%eax
  80095c:	50                   	push   %eax
  80095d:	e8 3c fd ff ff       	call   80069e <getint>
  800962:	83 c4 10             	add    $0x10,%esp
  800965:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800968:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80096b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80096e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800971:	85 d2                	test   %edx,%edx
  800973:	79 23                	jns    800998 <vprintfmt+0x29b>
				putch('-', putdat);
  800975:	83 ec 08             	sub    $0x8,%esp
  800978:	ff 75 0c             	pushl  0xc(%ebp)
  80097b:	6a 2d                	push   $0x2d
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	ff d0                	call   *%eax
  800982:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800985:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800988:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80098b:	f7 d8                	neg    %eax
  80098d:	83 d2 00             	adc    $0x0,%edx
  800990:	f7 da                	neg    %edx
  800992:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800995:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800998:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80099f:	e9 bc 00 00 00       	jmp    800a60 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009a4:	83 ec 08             	sub    $0x8,%esp
  8009a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8009aa:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ad:	50                   	push   %eax
  8009ae:	e8 84 fc ff ff       	call   800637 <getuint>
  8009b3:	83 c4 10             	add    $0x10,%esp
  8009b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009bc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c3:	e9 98 00 00 00       	jmp    800a60 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009c8:	83 ec 08             	sub    $0x8,%esp
  8009cb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ce:	6a 58                	push   $0x58
  8009d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d3:	ff d0                	call   *%eax
  8009d5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009d8:	83 ec 08             	sub    $0x8,%esp
  8009db:	ff 75 0c             	pushl  0xc(%ebp)
  8009de:	6a 58                	push   $0x58
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	ff d0                	call   *%eax
  8009e5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	6a 58                	push   $0x58
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
			break;
  8009f8:	e9 ce 00 00 00       	jmp    800acb <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8009fd:	83 ec 08             	sub    $0x8,%esp
  800a00:	ff 75 0c             	pushl  0xc(%ebp)
  800a03:	6a 30                	push   $0x30
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	ff d0                	call   *%eax
  800a0a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	6a 78                	push   $0x78
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	ff d0                	call   *%eax
  800a1a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a20:	83 c0 04             	add    $0x4,%eax
  800a23:	89 45 14             	mov    %eax,0x14(%ebp)
  800a26:	8b 45 14             	mov    0x14(%ebp),%eax
  800a29:	83 e8 04             	sub    $0x4,%eax
  800a2c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a38:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a3f:	eb 1f                	jmp    800a60 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a41:	83 ec 08             	sub    $0x8,%esp
  800a44:	ff 75 e8             	pushl  -0x18(%ebp)
  800a47:	8d 45 14             	lea    0x14(%ebp),%eax
  800a4a:	50                   	push   %eax
  800a4b:	e8 e7 fb ff ff       	call   800637 <getuint>
  800a50:	83 c4 10             	add    $0x10,%esp
  800a53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a56:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a59:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a60:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a67:	83 ec 04             	sub    $0x4,%esp
  800a6a:	52                   	push   %edx
  800a6b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a6e:	50                   	push   %eax
  800a6f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a72:	ff 75 f0             	pushl  -0x10(%ebp)
  800a75:	ff 75 0c             	pushl  0xc(%ebp)
  800a78:	ff 75 08             	pushl  0x8(%ebp)
  800a7b:	e8 00 fb ff ff       	call   800580 <printnum>
  800a80:	83 c4 20             	add    $0x20,%esp
			break;
  800a83:	eb 46                	jmp    800acb <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a85:	83 ec 08             	sub    $0x8,%esp
  800a88:	ff 75 0c             	pushl  0xc(%ebp)
  800a8b:	53                   	push   %ebx
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	ff d0                	call   *%eax
  800a91:	83 c4 10             	add    $0x10,%esp
			break;
  800a94:	eb 35                	jmp    800acb <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a96:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800a9d:	eb 2c                	jmp    800acb <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a9f:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800aa6:	eb 23                	jmp    800acb <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aa8:	83 ec 08             	sub    $0x8,%esp
  800aab:	ff 75 0c             	pushl  0xc(%ebp)
  800aae:	6a 25                	push   $0x25
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	ff d0                	call   *%eax
  800ab5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab8:	ff 4d 10             	decl   0x10(%ebp)
  800abb:	eb 03                	jmp    800ac0 <vprintfmt+0x3c3>
  800abd:	ff 4d 10             	decl   0x10(%ebp)
  800ac0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac3:	48                   	dec    %eax
  800ac4:	8a 00                	mov    (%eax),%al
  800ac6:	3c 25                	cmp    $0x25,%al
  800ac8:	75 f3                	jne    800abd <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800aca:	90                   	nop
		}
	}
  800acb:	e9 35 fc ff ff       	jmp    800705 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ad0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ad1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ad4:	5b                   	pop    %ebx
  800ad5:	5e                   	pop    %esi
  800ad6:	5d                   	pop    %ebp
  800ad7:	c3                   	ret    

00800ad8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
  800adb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ade:	8d 45 10             	lea    0x10(%ebp),%eax
  800ae1:	83 c0 04             	add    $0x4,%eax
  800ae4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ae7:	8b 45 10             	mov    0x10(%ebp),%eax
  800aea:	ff 75 f4             	pushl  -0xc(%ebp)
  800aed:	50                   	push   %eax
  800aee:	ff 75 0c             	pushl  0xc(%ebp)
  800af1:	ff 75 08             	pushl  0x8(%ebp)
  800af4:	e8 04 fc ff ff       	call   8006fd <vprintfmt>
  800af9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800afc:	90                   	nop
  800afd:	c9                   	leave  
  800afe:	c3                   	ret    

00800aff <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b05:	8b 40 08             	mov    0x8(%eax),%eax
  800b08:	8d 50 01             	lea    0x1(%eax),%edx
  800b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b14:	8b 10                	mov    (%eax),%edx
  800b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b19:	8b 40 04             	mov    0x4(%eax),%eax
  800b1c:	39 c2                	cmp    %eax,%edx
  800b1e:	73 12                	jae    800b32 <sprintputch+0x33>
		*b->buf++ = ch;
  800b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b23:	8b 00                	mov    (%eax),%eax
  800b25:	8d 48 01             	lea    0x1(%eax),%ecx
  800b28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2b:	89 0a                	mov    %ecx,(%edx)
  800b2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b30:	88 10                	mov    %dl,(%eax)
}
  800b32:	90                   	nop
  800b33:	5d                   	pop    %ebp
  800b34:	c3                   	ret    

00800b35 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b35:	55                   	push   %ebp
  800b36:	89 e5                	mov    %esp,%ebp
  800b38:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b44:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	01 d0                	add    %edx,%eax
  800b4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b5a:	74 06                	je     800b62 <vsnprintf+0x2d>
  800b5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b60:	7f 07                	jg     800b69 <vsnprintf+0x34>
		return -E_INVAL;
  800b62:	b8 03 00 00 00       	mov    $0x3,%eax
  800b67:	eb 20                	jmp    800b89 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b69:	ff 75 14             	pushl  0x14(%ebp)
  800b6c:	ff 75 10             	pushl  0x10(%ebp)
  800b6f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b72:	50                   	push   %eax
  800b73:	68 ff 0a 80 00       	push   $0x800aff
  800b78:	e8 80 fb ff ff       	call   8006fd <vprintfmt>
  800b7d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b83:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b89:	c9                   	leave  
  800b8a:	c3                   	ret    

00800b8b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b91:	8d 45 10             	lea    0x10(%ebp),%eax
  800b94:	83 c0 04             	add    $0x4,%eax
  800b97:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9d:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba0:	50                   	push   %eax
  800ba1:	ff 75 0c             	pushl  0xc(%ebp)
  800ba4:	ff 75 08             	pushl  0x8(%ebp)
  800ba7:	e8 89 ff ff ff       	call   800b35 <vsnprintf>
  800bac:	83 c4 10             	add    $0x10,%esp
  800baf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb5:	c9                   	leave  
  800bb6:	c3                   	ret    

00800bb7 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc4:	eb 06                	jmp    800bcc <strlen+0x15>
		n++;
  800bc6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc9:	ff 45 08             	incl   0x8(%ebp)
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	8a 00                	mov    (%eax),%al
  800bd1:	84 c0                	test   %al,%al
  800bd3:	75 f1                	jne    800bc6 <strlen+0xf>
		n++;
	return n;
  800bd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd8:	c9                   	leave  
  800bd9:	c3                   	ret    

00800bda <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be7:	eb 09                	jmp    800bf2 <strnlen+0x18>
		n++;
  800be9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bec:	ff 45 08             	incl   0x8(%ebp)
  800bef:	ff 4d 0c             	decl   0xc(%ebp)
  800bf2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf6:	74 09                	je     800c01 <strnlen+0x27>
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	8a 00                	mov    (%eax),%al
  800bfd:	84 c0                	test   %al,%al
  800bff:	75 e8                	jne    800be9 <strnlen+0xf>
		n++;
	return n;
  800c01:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c04:	c9                   	leave  
  800c05:	c3                   	ret    

00800c06 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c12:	90                   	nop
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	8d 50 01             	lea    0x1(%eax),%edx
  800c19:	89 55 08             	mov    %edx,0x8(%ebp)
  800c1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c1f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c22:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c25:	8a 12                	mov    (%edx),%dl
  800c27:	88 10                	mov    %dl,(%eax)
  800c29:	8a 00                	mov    (%eax),%al
  800c2b:	84 c0                	test   %al,%al
  800c2d:	75 e4                	jne    800c13 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c32:	c9                   	leave  
  800c33:	c3                   	ret    

00800c34 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c47:	eb 1f                	jmp    800c68 <strncpy+0x34>
		*dst++ = *src;
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	8d 50 01             	lea    0x1(%eax),%edx
  800c4f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c55:	8a 12                	mov    (%edx),%dl
  800c57:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5c:	8a 00                	mov    (%eax),%al
  800c5e:	84 c0                	test   %al,%al
  800c60:	74 03                	je     800c65 <strncpy+0x31>
			src++;
  800c62:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c65:	ff 45 fc             	incl   -0x4(%ebp)
  800c68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c6e:	72 d9                	jb     800c49 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c70:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c73:	c9                   	leave  
  800c74:	c3                   	ret    

00800c75 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c85:	74 30                	je     800cb7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c87:	eb 16                	jmp    800c9f <strlcpy+0x2a>
			*dst++ = *src++;
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	8d 50 01             	lea    0x1(%eax),%edx
  800c8f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c95:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c98:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c9b:	8a 12                	mov    (%edx),%dl
  800c9d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c9f:	ff 4d 10             	decl   0x10(%ebp)
  800ca2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca6:	74 09                	je     800cb1 <strlcpy+0x3c>
  800ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cab:	8a 00                	mov    (%eax),%al
  800cad:	84 c0                	test   %al,%al
  800caf:	75 d8                	jne    800c89 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbd:	29 c2                	sub    %eax,%edx
  800cbf:	89 d0                	mov    %edx,%eax
}
  800cc1:	c9                   	leave  
  800cc2:	c3                   	ret    

00800cc3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cc6:	eb 06                	jmp    800cce <strcmp+0xb>
		p++, q++;
  800cc8:	ff 45 08             	incl   0x8(%ebp)
  800ccb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	8a 00                	mov    (%eax),%al
  800cd3:	84 c0                	test   %al,%al
  800cd5:	74 0e                	je     800ce5 <strcmp+0x22>
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8a 10                	mov    (%eax),%dl
  800cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdf:	8a 00                	mov    (%eax),%al
  800ce1:	38 c2                	cmp    %al,%dl
  800ce3:	74 e3                	je     800cc8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	0f b6 d0             	movzbl %al,%edx
  800ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	0f b6 c0             	movzbl %al,%eax
  800cf5:	29 c2                	sub    %eax,%edx
  800cf7:	89 d0                	mov    %edx,%eax
}
  800cf9:	5d                   	pop    %ebp
  800cfa:	c3                   	ret    

00800cfb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cfe:	eb 09                	jmp    800d09 <strncmp+0xe>
		n--, p++, q++;
  800d00:	ff 4d 10             	decl   0x10(%ebp)
  800d03:	ff 45 08             	incl   0x8(%ebp)
  800d06:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0d:	74 17                	je     800d26 <strncmp+0x2b>
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	8a 00                	mov    (%eax),%al
  800d14:	84 c0                	test   %al,%al
  800d16:	74 0e                	je     800d26 <strncmp+0x2b>
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	8a 10                	mov    (%eax),%dl
  800d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d20:	8a 00                	mov    (%eax),%al
  800d22:	38 c2                	cmp    %al,%dl
  800d24:	74 da                	je     800d00 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2a:	75 07                	jne    800d33 <strncmp+0x38>
		return 0;
  800d2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d31:	eb 14                	jmp    800d47 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	8a 00                	mov    (%eax),%al
  800d38:	0f b6 d0             	movzbl %al,%edx
  800d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3e:	8a 00                	mov    (%eax),%al
  800d40:	0f b6 c0             	movzbl %al,%eax
  800d43:	29 c2                	sub    %eax,%edx
  800d45:	89 d0                	mov    %edx,%eax
}
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 04             	sub    $0x4,%esp
  800d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d52:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d55:	eb 12                	jmp    800d69 <strchr+0x20>
		if (*s == c)
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	8a 00                	mov    (%eax),%al
  800d5c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d5f:	75 05                	jne    800d66 <strchr+0x1d>
			return (char *) s;
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	eb 11                	jmp    800d77 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d66:	ff 45 08             	incl   0x8(%ebp)
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	8a 00                	mov    (%eax),%al
  800d6e:	84 c0                	test   %al,%al
  800d70:	75 e5                	jne    800d57 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d77:	c9                   	leave  
  800d78:	c3                   	ret    

00800d79 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d79:	55                   	push   %ebp
  800d7a:	89 e5                	mov    %esp,%ebp
  800d7c:	83 ec 04             	sub    $0x4,%esp
  800d7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d82:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d85:	eb 0d                	jmp    800d94 <strfind+0x1b>
		if (*s == c)
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	8a 00                	mov    (%eax),%al
  800d8c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d8f:	74 0e                	je     800d9f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d91:	ff 45 08             	incl   0x8(%ebp)
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	8a 00                	mov    (%eax),%al
  800d99:	84 c0                	test   %al,%al
  800d9b:	75 ea                	jne    800d87 <strfind+0xe>
  800d9d:	eb 01                	jmp    800da0 <strfind+0x27>
		if (*s == c)
			break;
  800d9f:	90                   	nop
	return (char *) s;
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da3:	c9                   	leave  
  800da4:	c3                   	ret    

00800da5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
  800da8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800db1:	8b 45 10             	mov    0x10(%ebp),%eax
  800db4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800db7:	eb 0e                	jmp    800dc7 <memset+0x22>
		*p++ = c;
  800db9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbc:	8d 50 01             	lea    0x1(%eax),%edx
  800dbf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dc7:	ff 4d f8             	decl   -0x8(%ebp)
  800dca:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dce:	79 e9                	jns    800db9 <memset+0x14>
		*p++ = c;

	return v;
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd3:	c9                   	leave  
  800dd4:	c3                   	ret    

00800dd5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
  800dd8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dde:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800de7:	eb 16                	jmp    800dff <memcpy+0x2a>
		*d++ = *s++;
  800de9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dec:	8d 50 01             	lea    0x1(%eax),%edx
  800def:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dfb:	8a 12                	mov    (%edx),%dl
  800dfd:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dff:	8b 45 10             	mov    0x10(%ebp),%eax
  800e02:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e05:	89 55 10             	mov    %edx,0x10(%ebp)
  800e08:	85 c0                	test   %eax,%eax
  800e0a:	75 dd                	jne    800de9 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    

00800e11 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
  800e14:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e26:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e29:	73 50                	jae    800e7b <memmove+0x6a>
  800e2b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e31:	01 d0                	add    %edx,%eax
  800e33:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e36:	76 43                	jbe    800e7b <memmove+0x6a>
		s += n;
  800e38:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e41:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e44:	eb 10                	jmp    800e56 <memmove+0x45>
			*--d = *--s;
  800e46:	ff 4d f8             	decl   -0x8(%ebp)
  800e49:	ff 4d fc             	decl   -0x4(%ebp)
  800e4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4f:	8a 10                	mov    (%eax),%dl
  800e51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e54:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e56:	8b 45 10             	mov    0x10(%ebp),%eax
  800e59:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5f:	85 c0                	test   %eax,%eax
  800e61:	75 e3                	jne    800e46 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e63:	eb 23                	jmp    800e88 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e65:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e68:	8d 50 01             	lea    0x1(%eax),%edx
  800e6b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e71:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e74:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e77:	8a 12                	mov    (%edx),%dl
  800e79:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e81:	89 55 10             	mov    %edx,0x10(%ebp)
  800e84:	85 c0                	test   %eax,%eax
  800e86:	75 dd                	jne    800e65 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e9f:	eb 2a                	jmp    800ecb <memcmp+0x3e>
		if (*s1 != *s2)
  800ea1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea4:	8a 10                	mov    (%eax),%dl
  800ea6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	38 c2                	cmp    %al,%dl
  800ead:	74 16                	je     800ec5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb2:	8a 00                	mov    (%eax),%al
  800eb4:	0f b6 d0             	movzbl %al,%edx
  800eb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eba:	8a 00                	mov    (%eax),%al
  800ebc:	0f b6 c0             	movzbl %al,%eax
  800ebf:	29 c2                	sub    %eax,%edx
  800ec1:	89 d0                	mov    %edx,%eax
  800ec3:	eb 18                	jmp    800edd <memcmp+0x50>
		s1++, s2++;
  800ec5:	ff 45 fc             	incl   -0x4(%ebp)
  800ec8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ecb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ece:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed4:	85 c0                	test   %eax,%eax
  800ed6:	75 c9                	jne    800ea1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ed8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800edd:	c9                   	leave  
  800ede:	c3                   	ret    

00800edf <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800edf:	55                   	push   %ebp
  800ee0:	89 e5                	mov    %esp,%ebp
  800ee2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ee5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee8:	8b 45 10             	mov    0x10(%ebp),%eax
  800eeb:	01 d0                	add    %edx,%eax
  800eed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ef0:	eb 15                	jmp    800f07 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	8a 00                	mov    (%eax),%al
  800ef7:	0f b6 d0             	movzbl %al,%edx
  800efa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efd:	0f b6 c0             	movzbl %al,%eax
  800f00:	39 c2                	cmp    %eax,%edx
  800f02:	74 0d                	je     800f11 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f04:	ff 45 08             	incl   0x8(%ebp)
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f0d:	72 e3                	jb     800ef2 <memfind+0x13>
  800f0f:	eb 01                	jmp    800f12 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f11:	90                   	nop
	return (void *) s;
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f15:	c9                   	leave  
  800f16:	c3                   	ret    

00800f17 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f17:	55                   	push   %ebp
  800f18:	89 e5                	mov    %esp,%ebp
  800f1a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f1d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f24:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f2b:	eb 03                	jmp    800f30 <strtol+0x19>
		s++;
  800f2d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	8a 00                	mov    (%eax),%al
  800f35:	3c 20                	cmp    $0x20,%al
  800f37:	74 f4                	je     800f2d <strtol+0x16>
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	8a 00                	mov    (%eax),%al
  800f3e:	3c 09                	cmp    $0x9,%al
  800f40:	74 eb                	je     800f2d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	3c 2b                	cmp    $0x2b,%al
  800f49:	75 05                	jne    800f50 <strtol+0x39>
		s++;
  800f4b:	ff 45 08             	incl   0x8(%ebp)
  800f4e:	eb 13                	jmp    800f63 <strtol+0x4c>
	else if (*s == '-')
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	3c 2d                	cmp    $0x2d,%al
  800f57:	75 0a                	jne    800f63 <strtol+0x4c>
		s++, neg = 1;
  800f59:	ff 45 08             	incl   0x8(%ebp)
  800f5c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f67:	74 06                	je     800f6f <strtol+0x58>
  800f69:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f6d:	75 20                	jne    800f8f <strtol+0x78>
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3c 30                	cmp    $0x30,%al
  800f76:	75 17                	jne    800f8f <strtol+0x78>
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7b:	40                   	inc    %eax
  800f7c:	8a 00                	mov    (%eax),%al
  800f7e:	3c 78                	cmp    $0x78,%al
  800f80:	75 0d                	jne    800f8f <strtol+0x78>
		s += 2, base = 16;
  800f82:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f86:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f8d:	eb 28                	jmp    800fb7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f93:	75 15                	jne    800faa <strtol+0x93>
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	8a 00                	mov    (%eax),%al
  800f9a:	3c 30                	cmp    $0x30,%al
  800f9c:	75 0c                	jne    800faa <strtol+0x93>
		s++, base = 8;
  800f9e:	ff 45 08             	incl   0x8(%ebp)
  800fa1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fa8:	eb 0d                	jmp    800fb7 <strtol+0xa0>
	else if (base == 0)
  800faa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fae:	75 07                	jne    800fb7 <strtol+0xa0>
		base = 10;
  800fb0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	3c 2f                	cmp    $0x2f,%al
  800fbe:	7e 19                	jle    800fd9 <strtol+0xc2>
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	3c 39                	cmp    $0x39,%al
  800fc7:	7f 10                	jg     800fd9 <strtol+0xc2>
			dig = *s - '0';
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	0f be c0             	movsbl %al,%eax
  800fd1:	83 e8 30             	sub    $0x30,%eax
  800fd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd7:	eb 42                	jmp    80101b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	8a 00                	mov    (%eax),%al
  800fde:	3c 60                	cmp    $0x60,%al
  800fe0:	7e 19                	jle    800ffb <strtol+0xe4>
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	8a 00                	mov    (%eax),%al
  800fe7:	3c 7a                	cmp    $0x7a,%al
  800fe9:	7f 10                	jg     800ffb <strtol+0xe4>
			dig = *s - 'a' + 10;
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	0f be c0             	movsbl %al,%eax
  800ff3:	83 e8 57             	sub    $0x57,%eax
  800ff6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ff9:	eb 20                	jmp    80101b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	8a 00                	mov    (%eax),%al
  801000:	3c 40                	cmp    $0x40,%al
  801002:	7e 39                	jle    80103d <strtol+0x126>
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	3c 5a                	cmp    $0x5a,%al
  80100b:	7f 30                	jg     80103d <strtol+0x126>
			dig = *s - 'A' + 10;
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	0f be c0             	movsbl %al,%eax
  801015:	83 e8 37             	sub    $0x37,%eax
  801018:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80101b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801021:	7d 19                	jge    80103c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801023:	ff 45 08             	incl   0x8(%ebp)
  801026:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801029:	0f af 45 10          	imul   0x10(%ebp),%eax
  80102d:	89 c2                	mov    %eax,%edx
  80102f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801032:	01 d0                	add    %edx,%eax
  801034:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801037:	e9 7b ff ff ff       	jmp    800fb7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80103c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80103d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801041:	74 08                	je     80104b <strtol+0x134>
		*endptr = (char *) s;
  801043:	8b 45 0c             	mov    0xc(%ebp),%eax
  801046:	8b 55 08             	mov    0x8(%ebp),%edx
  801049:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80104b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80104f:	74 07                	je     801058 <strtol+0x141>
  801051:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801054:	f7 d8                	neg    %eax
  801056:	eb 03                	jmp    80105b <strtol+0x144>
  801058:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80105b:	c9                   	leave  
  80105c:	c3                   	ret    

0080105d <ltostr>:

void
ltostr(long value, char *str)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801063:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80106a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801071:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801075:	79 13                	jns    80108a <ltostr+0x2d>
	{
		neg = 1;
  801077:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80107e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801081:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801084:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801087:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801092:	99                   	cltd   
  801093:	f7 f9                	idiv   %ecx
  801095:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801098:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109b:	8d 50 01             	lea    0x1(%eax),%edx
  80109e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a1:	89 c2                	mov    %eax,%edx
  8010a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a6:	01 d0                	add    %edx,%eax
  8010a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010ab:	83 c2 30             	add    $0x30,%edx
  8010ae:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010b8:	f7 e9                	imul   %ecx
  8010ba:	c1 fa 02             	sar    $0x2,%edx
  8010bd:	89 c8                	mov    %ecx,%eax
  8010bf:	c1 f8 1f             	sar    $0x1f,%eax
  8010c2:	29 c2                	sub    %eax,%edx
  8010c4:	89 d0                	mov    %edx,%eax
  8010c6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010cd:	75 bb                	jne    80108a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d9:	48                   	dec    %eax
  8010da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010e1:	74 3d                	je     801120 <ltostr+0xc3>
		start = 1 ;
  8010e3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010ea:	eb 34                	jmp    801120 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f2:	01 d0                	add    %edx,%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ff:	01 c2                	add    %eax,%edx
  801101:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801104:	8b 45 0c             	mov    0xc(%ebp),%eax
  801107:	01 c8                	add    %ecx,%eax
  801109:	8a 00                	mov    (%eax),%al
  80110b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80110d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801110:	8b 45 0c             	mov    0xc(%ebp),%eax
  801113:	01 c2                	add    %eax,%edx
  801115:	8a 45 eb             	mov    -0x15(%ebp),%al
  801118:	88 02                	mov    %al,(%edx)
		start++ ;
  80111a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80111d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801123:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801126:	7c c4                	jl     8010ec <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801128:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80112b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112e:	01 d0                	add    %edx,%eax
  801130:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801133:	90                   	nop
  801134:	c9                   	leave  
  801135:	c3                   	ret    

00801136 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80113c:	ff 75 08             	pushl  0x8(%ebp)
  80113f:	e8 73 fa ff ff       	call   800bb7 <strlen>
  801144:	83 c4 04             	add    $0x4,%esp
  801147:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80114a:	ff 75 0c             	pushl  0xc(%ebp)
  80114d:	e8 65 fa ff ff       	call   800bb7 <strlen>
  801152:	83 c4 04             	add    $0x4,%esp
  801155:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801158:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80115f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801166:	eb 17                	jmp    80117f <strcconcat+0x49>
		final[s] = str1[s] ;
  801168:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80116b:	8b 45 10             	mov    0x10(%ebp),%eax
  80116e:	01 c2                	add    %eax,%edx
  801170:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	01 c8                	add    %ecx,%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80117c:	ff 45 fc             	incl   -0x4(%ebp)
  80117f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801182:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801185:	7c e1                	jl     801168 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801187:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80118e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801195:	eb 1f                	jmp    8011b6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801197:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80119a:	8d 50 01             	lea    0x1(%eax),%edx
  80119d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011a0:	89 c2                	mov    %eax,%edx
  8011a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a5:	01 c2                	add    %eax,%edx
  8011a7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ad:	01 c8                	add    %ecx,%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011b3:	ff 45 f8             	incl   -0x8(%ebp)
  8011b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011bc:	7c d9                	jl     801197 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c4:	01 d0                	add    %edx,%eax
  8011c6:	c6 00 00             	movb   $0x0,(%eax)
}
  8011c9:	90                   	nop
  8011ca:	c9                   	leave  
  8011cb:	c3                   	ret    

008011cc <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011cc:	55                   	push   %ebp
  8011cd:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011db:	8b 00                	mov    (%eax),%eax
  8011dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e7:	01 d0                	add    %edx,%eax
  8011e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011ef:	eb 0c                	jmp    8011fd <strsplit+0x31>
			*string++ = 0;
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8d 50 01             	lea    0x1(%eax),%edx
  8011f7:	89 55 08             	mov    %edx,0x8(%ebp)
  8011fa:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	84 c0                	test   %al,%al
  801204:	74 18                	je     80121e <strsplit+0x52>
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	0f be c0             	movsbl %al,%eax
  80120e:	50                   	push   %eax
  80120f:	ff 75 0c             	pushl  0xc(%ebp)
  801212:	e8 32 fb ff ff       	call   800d49 <strchr>
  801217:	83 c4 08             	add    $0x8,%esp
  80121a:	85 c0                	test   %eax,%eax
  80121c:	75 d3                	jne    8011f1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	84 c0                	test   %al,%al
  801225:	74 5a                	je     801281 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801227:	8b 45 14             	mov    0x14(%ebp),%eax
  80122a:	8b 00                	mov    (%eax),%eax
  80122c:	83 f8 0f             	cmp    $0xf,%eax
  80122f:	75 07                	jne    801238 <strsplit+0x6c>
		{
			return 0;
  801231:	b8 00 00 00 00       	mov    $0x0,%eax
  801236:	eb 66                	jmp    80129e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801238:	8b 45 14             	mov    0x14(%ebp),%eax
  80123b:	8b 00                	mov    (%eax),%eax
  80123d:	8d 48 01             	lea    0x1(%eax),%ecx
  801240:	8b 55 14             	mov    0x14(%ebp),%edx
  801243:	89 0a                	mov    %ecx,(%edx)
  801245:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80124c:	8b 45 10             	mov    0x10(%ebp),%eax
  80124f:	01 c2                	add    %eax,%edx
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801256:	eb 03                	jmp    80125b <strsplit+0x8f>
			string++;
  801258:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
  80125e:	8a 00                	mov    (%eax),%al
  801260:	84 c0                	test   %al,%al
  801262:	74 8b                	je     8011ef <strsplit+0x23>
  801264:	8b 45 08             	mov    0x8(%ebp),%eax
  801267:	8a 00                	mov    (%eax),%al
  801269:	0f be c0             	movsbl %al,%eax
  80126c:	50                   	push   %eax
  80126d:	ff 75 0c             	pushl  0xc(%ebp)
  801270:	e8 d4 fa ff ff       	call   800d49 <strchr>
  801275:	83 c4 08             	add    $0x8,%esp
  801278:	85 c0                	test   %eax,%eax
  80127a:	74 dc                	je     801258 <strsplit+0x8c>
			string++;
	}
  80127c:	e9 6e ff ff ff       	jmp    8011ef <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801281:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801282:	8b 45 14             	mov    0x14(%ebp),%eax
  801285:	8b 00                	mov    (%eax),%eax
  801287:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80128e:	8b 45 10             	mov    0x10(%ebp),%eax
  801291:	01 d0                	add    %edx,%eax
  801293:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801299:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80129e:	c9                   	leave  
  80129f:	c3                   	ret    

008012a0 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
  8012a3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8012a6:	83 ec 04             	sub    $0x4,%esp
  8012a9:	68 a8 21 80 00       	push   $0x8021a8
  8012ae:	68 3f 01 00 00       	push   $0x13f
  8012b3:	68 ca 21 80 00       	push   $0x8021ca
  8012b8:	e8 a9 ef ff ff       	call   800266 <_panic>

008012bd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	57                   	push   %edi
  8012c1:	56                   	push   %esi
  8012c2:	53                   	push   %ebx
  8012c3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012cf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012d2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012d5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012d8:	cd 30                	int    $0x30
  8012da:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012e0:	83 c4 10             	add    $0x10,%esp
  8012e3:	5b                   	pop    %ebx
  8012e4:	5e                   	pop    %esi
  8012e5:	5f                   	pop    %edi
  8012e6:	5d                   	pop    %ebp
  8012e7:	c3                   	ret    

008012e8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
  8012eb:	83 ec 04             	sub    $0x4,%esp
  8012ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012f4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	6a 00                	push   $0x0
  8012fd:	6a 00                	push   $0x0
  8012ff:	52                   	push   %edx
  801300:	ff 75 0c             	pushl  0xc(%ebp)
  801303:	50                   	push   %eax
  801304:	6a 00                	push   $0x0
  801306:	e8 b2 ff ff ff       	call   8012bd <syscall>
  80130b:	83 c4 18             	add    $0x18,%esp
}
  80130e:	90                   	nop
  80130f:	c9                   	leave  
  801310:	c3                   	ret    

00801311 <sys_cgetc>:

int
sys_cgetc(void)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801314:	6a 00                	push   $0x0
  801316:	6a 00                	push   $0x0
  801318:	6a 00                	push   $0x0
  80131a:	6a 00                	push   $0x0
  80131c:	6a 00                	push   $0x0
  80131e:	6a 02                	push   $0x2
  801320:	e8 98 ff ff ff       	call   8012bd <syscall>
  801325:	83 c4 18             	add    $0x18,%esp
}
  801328:	c9                   	leave  
  801329:	c3                   	ret    

0080132a <sys_lock_cons>:

void sys_lock_cons(void)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80132d:	6a 00                	push   $0x0
  80132f:	6a 00                	push   $0x0
  801331:	6a 00                	push   $0x0
  801333:	6a 00                	push   $0x0
  801335:	6a 00                	push   $0x0
  801337:	6a 03                	push   $0x3
  801339:	e8 7f ff ff ff       	call   8012bd <syscall>
  80133e:	83 c4 18             	add    $0x18,%esp
}
  801341:	90                   	nop
  801342:	c9                   	leave  
  801343:	c3                   	ret    

00801344 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	6a 00                	push   $0x0
  801351:	6a 04                	push   $0x4
  801353:	e8 65 ff ff ff       	call   8012bd <syscall>
  801358:	83 c4 18             	add    $0x18,%esp
}
  80135b:	90                   	nop
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    

0080135e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801361:	8b 55 0c             	mov    0xc(%ebp),%edx
  801364:	8b 45 08             	mov    0x8(%ebp),%eax
  801367:	6a 00                	push   $0x0
  801369:	6a 00                	push   $0x0
  80136b:	6a 00                	push   $0x0
  80136d:	52                   	push   %edx
  80136e:	50                   	push   %eax
  80136f:	6a 08                	push   $0x8
  801371:	e8 47 ff ff ff       	call   8012bd <syscall>
  801376:	83 c4 18             	add    $0x18,%esp
}
  801379:	c9                   	leave  
  80137a:	c3                   	ret    

0080137b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	56                   	push   %esi
  80137f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801380:	8b 75 18             	mov    0x18(%ebp),%esi
  801383:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801386:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801389:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	56                   	push   %esi
  801390:	53                   	push   %ebx
  801391:	51                   	push   %ecx
  801392:	52                   	push   %edx
  801393:	50                   	push   %eax
  801394:	6a 09                	push   $0x9
  801396:	e8 22 ff ff ff       	call   8012bd <syscall>
  80139b:	83 c4 18             	add    $0x18,%esp
}
  80139e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013a1:	5b                   	pop    %ebx
  8013a2:	5e                   	pop    %esi
  8013a3:	5d                   	pop    %ebp
  8013a4:	c3                   	ret    

008013a5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8013a5:	55                   	push   %ebp
  8013a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 00                	push   $0x0
  8013b4:	52                   	push   %edx
  8013b5:	50                   	push   %eax
  8013b6:	6a 0a                	push   $0xa
  8013b8:	e8 00 ff ff ff       	call   8012bd <syscall>
  8013bd:	83 c4 18             	add    $0x18,%esp
}
  8013c0:	c9                   	leave  
  8013c1:	c3                   	ret    

008013c2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	ff 75 0c             	pushl  0xc(%ebp)
  8013ce:	ff 75 08             	pushl  0x8(%ebp)
  8013d1:	6a 0b                	push   $0xb
  8013d3:	e8 e5 fe ff ff       	call   8012bd <syscall>
  8013d8:	83 c4 18             	add    $0x18,%esp
}
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    

008013dd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 0c                	push   $0xc
  8013ec:	e8 cc fe ff ff       	call   8012bd <syscall>
  8013f1:	83 c4 18             	add    $0x18,%esp
}
  8013f4:	c9                   	leave  
  8013f5:	c3                   	ret    

008013f6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	6a 00                	push   $0x0
  801403:	6a 0d                	push   $0xd
  801405:	e8 b3 fe ff ff       	call   8012bd <syscall>
  80140a:	83 c4 18             	add    $0x18,%esp
}
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    

0080140f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 00                	push   $0x0
  80141c:	6a 0e                	push   $0xe
  80141e:	e8 9a fe ff ff       	call   8012bd <syscall>
  801423:	83 c4 18             	add    $0x18,%esp
}
  801426:	c9                   	leave  
  801427:	c3                   	ret    

00801428 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	6a 00                	push   $0x0
  801435:	6a 0f                	push   $0xf
  801437:	e8 81 fe ff ff       	call   8012bd <syscall>
  80143c:	83 c4 18             	add    $0x18,%esp
}
  80143f:	c9                   	leave  
  801440:	c3                   	ret    

00801441 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801441:	55                   	push   %ebp
  801442:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	ff 75 08             	pushl  0x8(%ebp)
  80144f:	6a 10                	push   $0x10
  801451:	e8 67 fe ff ff       	call   8012bd <syscall>
  801456:	83 c4 18             	add    $0x18,%esp
}
  801459:	c9                   	leave  
  80145a:	c3                   	ret    

0080145b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	6a 00                	push   $0x0
  801466:	6a 00                	push   $0x0
  801468:	6a 11                	push   $0x11
  80146a:	e8 4e fe ff ff       	call   8012bd <syscall>
  80146f:	83 c4 18             	add    $0x18,%esp
}
  801472:	90                   	nop
  801473:	c9                   	leave  
  801474:	c3                   	ret    

00801475 <sys_cputc>:

void
sys_cputc(const char c)
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
  801478:	83 ec 04             	sub    $0x4,%esp
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
  80147e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801481:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801485:	6a 00                	push   $0x0
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	50                   	push   %eax
  80148e:	6a 01                	push   $0x1
  801490:	e8 28 fe ff ff       	call   8012bd <syscall>
  801495:	83 c4 18             	add    $0x18,%esp
}
  801498:	90                   	nop
  801499:	c9                   	leave  
  80149a:	c3                   	ret    

0080149b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 14                	push   $0x14
  8014aa:	e8 0e fe ff ff       	call   8012bd <syscall>
  8014af:	83 c4 18             	add    $0x18,%esp
}
  8014b2:	90                   	nop
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    

008014b5 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	83 ec 04             	sub    $0x4,%esp
  8014bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8014be:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014c1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014c4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	6a 00                	push   $0x0
  8014cd:	51                   	push   %ecx
  8014ce:	52                   	push   %edx
  8014cf:	ff 75 0c             	pushl  0xc(%ebp)
  8014d2:	50                   	push   %eax
  8014d3:	6a 15                	push   $0x15
  8014d5:	e8 e3 fd ff ff       	call   8012bd <syscall>
  8014da:	83 c4 18             	add    $0x18,%esp
}
  8014dd:	c9                   	leave  
  8014de:	c3                   	ret    

008014df <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 00                	push   $0x0
  8014ee:	52                   	push   %edx
  8014ef:	50                   	push   %eax
  8014f0:	6a 16                	push   $0x16
  8014f2:	e8 c6 fd ff ff       	call   8012bd <syscall>
  8014f7:	83 c4 18             	add    $0x18,%esp
}
  8014fa:	c9                   	leave  
  8014fb:	c3                   	ret    

008014fc <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8014ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801502:	8b 55 0c             	mov    0xc(%ebp),%edx
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	51                   	push   %ecx
  80150d:	52                   	push   %edx
  80150e:	50                   	push   %eax
  80150f:	6a 17                	push   $0x17
  801511:	e8 a7 fd ff ff       	call   8012bd <syscall>
  801516:	83 c4 18             	add    $0x18,%esp
}
  801519:	c9                   	leave  
  80151a:	c3                   	ret    

0080151b <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80151b:	55                   	push   %ebp
  80151c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80151e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801521:	8b 45 08             	mov    0x8(%ebp),%eax
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	52                   	push   %edx
  80152b:	50                   	push   %eax
  80152c:	6a 18                	push   $0x18
  80152e:	e8 8a fd ff ff       	call   8012bd <syscall>
  801533:	83 c4 18             	add    $0x18,%esp
}
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	6a 00                	push   $0x0
  801540:	ff 75 14             	pushl  0x14(%ebp)
  801543:	ff 75 10             	pushl  0x10(%ebp)
  801546:	ff 75 0c             	pushl  0xc(%ebp)
  801549:	50                   	push   %eax
  80154a:	6a 19                	push   $0x19
  80154c:	e8 6c fd ff ff       	call   8012bd <syscall>
  801551:	83 c4 18             	add    $0x18,%esp
}
  801554:	c9                   	leave  
  801555:	c3                   	ret    

00801556 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	50                   	push   %eax
  801565:	6a 1a                	push   $0x1a
  801567:	e8 51 fd ff ff       	call   8012bd <syscall>
  80156c:	83 c4 18             	add    $0x18,%esp
}
  80156f:	90                   	nop
  801570:	c9                   	leave  
  801571:	c3                   	ret    

00801572 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801575:	8b 45 08             	mov    0x8(%ebp),%eax
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	50                   	push   %eax
  801581:	6a 1b                	push   $0x1b
  801583:	e8 35 fd ff ff       	call   8012bd <syscall>
  801588:	83 c4 18             	add    $0x18,%esp
}
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 05                	push   $0x5
  80159c:	e8 1c fd ff ff       	call   8012bd <syscall>
  8015a1:	83 c4 18             	add    $0x18,%esp
}
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 06                	push   $0x6
  8015b5:	e8 03 fd ff ff       	call   8012bd <syscall>
  8015ba:	83 c4 18             	add    $0x18,%esp
}
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    

008015bf <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 07                	push   $0x7
  8015ce:	e8 ea fc ff ff       	call   8012bd <syscall>
  8015d3:	83 c4 18             	add    $0x18,%esp
}
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <sys_exit_env>:


void sys_exit_env(void)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 1c                	push   $0x1c
  8015e7:	e8 d1 fc ff ff       	call   8012bd <syscall>
  8015ec:	83 c4 18             	add    $0x18,%esp
}
  8015ef:	90                   	nop
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8015f8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015fb:	8d 50 04             	lea    0x4(%eax),%edx
  8015fe:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	52                   	push   %edx
  801608:	50                   	push   %eax
  801609:	6a 1d                	push   $0x1d
  80160b:	e8 ad fc ff ff       	call   8012bd <syscall>
  801610:	83 c4 18             	add    $0x18,%esp
	return result;
  801613:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801616:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801619:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80161c:	89 01                	mov    %eax,(%ecx)
  80161e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	c9                   	leave  
  801625:	c2 04 00             	ret    $0x4

00801628 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	ff 75 10             	pushl  0x10(%ebp)
  801632:	ff 75 0c             	pushl  0xc(%ebp)
  801635:	ff 75 08             	pushl  0x8(%ebp)
  801638:	6a 13                	push   $0x13
  80163a:	e8 7e fc ff ff       	call   8012bd <syscall>
  80163f:	83 c4 18             	add    $0x18,%esp
	return ;
  801642:	90                   	nop
}
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <sys_rcr2>:
uint32 sys_rcr2()
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 1e                	push   $0x1e
  801654:	e8 64 fc ff ff       	call   8012bd <syscall>
  801659:	83 c4 18             	add    $0x18,%esp
}
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	83 ec 04             	sub    $0x4,%esp
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80166a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	50                   	push   %eax
  801677:	6a 1f                	push   $0x1f
  801679:	e8 3f fc ff ff       	call   8012bd <syscall>
  80167e:	83 c4 18             	add    $0x18,%esp
	return ;
  801681:	90                   	nop
}
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <rsttst>:
void rsttst()
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 21                	push   $0x21
  801693:	e8 25 fc ff ff       	call   8012bd <syscall>
  801698:	83 c4 18             	add    $0x18,%esp
	return ;
  80169b:	90                   	nop
}
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	83 ec 04             	sub    $0x4,%esp
  8016a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016aa:	8b 55 18             	mov    0x18(%ebp),%edx
  8016ad:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016b1:	52                   	push   %edx
  8016b2:	50                   	push   %eax
  8016b3:	ff 75 10             	pushl  0x10(%ebp)
  8016b6:	ff 75 0c             	pushl  0xc(%ebp)
  8016b9:	ff 75 08             	pushl  0x8(%ebp)
  8016bc:	6a 20                	push   $0x20
  8016be:	e8 fa fb ff ff       	call   8012bd <syscall>
  8016c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8016c6:	90                   	nop
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <chktst>:
void chktst(uint32 n)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	ff 75 08             	pushl  0x8(%ebp)
  8016d7:	6a 22                	push   $0x22
  8016d9:	e8 df fb ff ff       	call   8012bd <syscall>
  8016de:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e1:	90                   	nop
}
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <inctst>:

void inctst()
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 23                	push   $0x23
  8016f3:	e8 c5 fb ff ff       	call   8012bd <syscall>
  8016f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8016fb:	90                   	nop
}
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <gettst>:
uint32 gettst()
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 24                	push   $0x24
  80170d:	e8 ab fb ff ff       	call   8012bd <syscall>
  801712:	83 c4 18             	add    $0x18,%esp
}
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 25                	push   $0x25
  801729:	e8 8f fb ff ff       	call   8012bd <syscall>
  80172e:	83 c4 18             	add    $0x18,%esp
  801731:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801734:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801738:	75 07                	jne    801741 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80173a:	b8 01 00 00 00       	mov    $0x1,%eax
  80173f:	eb 05                	jmp    801746 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801741:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801746:	c9                   	leave  
  801747:	c3                   	ret    

00801748 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
  80174b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 25                	push   $0x25
  80175a:	e8 5e fb ff ff       	call   8012bd <syscall>
  80175f:	83 c4 18             	add    $0x18,%esp
  801762:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801765:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801769:	75 07                	jne    801772 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80176b:	b8 01 00 00 00       	mov    $0x1,%eax
  801770:	eb 05                	jmp    801777 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801772:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801777:	c9                   	leave  
  801778:	c3                   	ret    

00801779 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 25                	push   $0x25
  80178b:	e8 2d fb ff ff       	call   8012bd <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
  801793:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801796:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80179a:	75 07                	jne    8017a3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80179c:	b8 01 00 00 00       	mov    $0x1,%eax
  8017a1:	eb 05                	jmp    8017a8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 25                	push   $0x25
  8017bc:	e8 fc fa ff ff       	call   8012bd <syscall>
  8017c1:	83 c4 18             	add    $0x18,%esp
  8017c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017c7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017cb:	75 07                	jne    8017d4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8017d2:	eb 05                	jmp    8017d9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	ff 75 08             	pushl  0x8(%ebp)
  8017e9:	6a 26                	push   $0x26
  8017eb:	e8 cd fa ff ff       	call   8012bd <syscall>
  8017f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f3:	90                   	nop
}
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8017fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801800:	8b 55 0c             	mov    0xc(%ebp),%edx
  801803:	8b 45 08             	mov    0x8(%ebp),%eax
  801806:	6a 00                	push   $0x0
  801808:	53                   	push   %ebx
  801809:	51                   	push   %ecx
  80180a:	52                   	push   %edx
  80180b:	50                   	push   %eax
  80180c:	6a 27                	push   $0x27
  80180e:	e8 aa fa ff ff       	call   8012bd <syscall>
  801813:	83 c4 18             	add    $0x18,%esp
}
  801816:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80181e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	52                   	push   %edx
  80182b:	50                   	push   %eax
  80182c:	6a 28                	push   $0x28
  80182e:	e8 8a fa ff ff       	call   8012bd <syscall>
  801833:	83 c4 18             	add    $0x18,%esp
}
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80183b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80183e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	6a 00                	push   $0x0
  801846:	51                   	push   %ecx
  801847:	ff 75 10             	pushl  0x10(%ebp)
  80184a:	52                   	push   %edx
  80184b:	50                   	push   %eax
  80184c:	6a 29                	push   $0x29
  80184e:	e8 6a fa ff ff       	call   8012bd <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
}
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	ff 75 10             	pushl  0x10(%ebp)
  801862:	ff 75 0c             	pushl  0xc(%ebp)
  801865:	ff 75 08             	pushl  0x8(%ebp)
  801868:	6a 12                	push   $0x12
  80186a:	e8 4e fa ff ff       	call   8012bd <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
	return ;
  801872:	90                   	nop
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801878:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	52                   	push   %edx
  801885:	50                   	push   %eax
  801886:	6a 2a                	push   $0x2a
  801888:	e8 30 fa ff ff       	call   8012bd <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
	return;
  801890:	90                   	nop
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	50                   	push   %eax
  8018a2:	6a 2b                	push   $0x2b
  8018a4:	e8 14 fa ff ff       	call   8012bd <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ba:	ff 75 08             	pushl  0x8(%ebp)
  8018bd:	6a 2c                	push   $0x2c
  8018bf:	e8 f9 f9 ff ff       	call   8012bd <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
	return;
  8018c7:	90                   	nop
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	ff 75 0c             	pushl  0xc(%ebp)
  8018d6:	ff 75 08             	pushl  0x8(%ebp)
  8018d9:	6a 2d                	push   $0x2d
  8018db:	e8 dd f9 ff ff       	call   8012bd <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
	return;
  8018e3:	90                   	nop
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  8018ec:	83 ec 04             	sub    $0x4,%esp
  8018ef:	68 d8 21 80 00       	push   $0x8021d8
  8018f4:	6a 09                	push   $0x9
  8018f6:	68 00 22 80 00       	push   $0x802200
  8018fb:	e8 66 e9 ff ff       	call   800266 <_panic>

00801900 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  801906:	83 ec 04             	sub    $0x4,%esp
  801909:	68 10 22 80 00       	push   $0x802210
  80190e:	6a 10                	push   $0x10
  801910:	68 00 22 80 00       	push   $0x802200
  801915:	e8 4c e9 ff ff       	call   800266 <_panic>

0080191a <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  801920:	83 ec 04             	sub    $0x4,%esp
  801923:	68 38 22 80 00       	push   $0x802238
  801928:	6a 18                	push   $0x18
  80192a:	68 00 22 80 00       	push   $0x802200
  80192f:	e8 32 e9 ff ff       	call   800266 <_panic>

00801934 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  80193a:	83 ec 04             	sub    $0x4,%esp
  80193d:	68 60 22 80 00       	push   $0x802260
  801942:	6a 20                	push   $0x20
  801944:	68 00 22 80 00       	push   $0x802200
  801949:	e8 18 e9 ff ff       	call   800266 <_panic>

0080194e <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801951:	8b 45 08             	mov    0x8(%ebp),%eax
  801954:	8b 40 10             	mov    0x10(%eax),%eax
}
  801957:	5d                   	pop    %ebp
  801958:	c3                   	ret    
  801959:	66 90                	xchg   %ax,%ax
  80195b:	90                   	nop

0080195c <__udivdi3>:
  80195c:	55                   	push   %ebp
  80195d:	57                   	push   %edi
  80195e:	56                   	push   %esi
  80195f:	53                   	push   %ebx
  801960:	83 ec 1c             	sub    $0x1c,%esp
  801963:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801967:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80196b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80196f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801973:	89 ca                	mov    %ecx,%edx
  801975:	89 f8                	mov    %edi,%eax
  801977:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80197b:	85 f6                	test   %esi,%esi
  80197d:	75 2d                	jne    8019ac <__udivdi3+0x50>
  80197f:	39 cf                	cmp    %ecx,%edi
  801981:	77 65                	ja     8019e8 <__udivdi3+0x8c>
  801983:	89 fd                	mov    %edi,%ebp
  801985:	85 ff                	test   %edi,%edi
  801987:	75 0b                	jne    801994 <__udivdi3+0x38>
  801989:	b8 01 00 00 00       	mov    $0x1,%eax
  80198e:	31 d2                	xor    %edx,%edx
  801990:	f7 f7                	div    %edi
  801992:	89 c5                	mov    %eax,%ebp
  801994:	31 d2                	xor    %edx,%edx
  801996:	89 c8                	mov    %ecx,%eax
  801998:	f7 f5                	div    %ebp
  80199a:	89 c1                	mov    %eax,%ecx
  80199c:	89 d8                	mov    %ebx,%eax
  80199e:	f7 f5                	div    %ebp
  8019a0:	89 cf                	mov    %ecx,%edi
  8019a2:	89 fa                	mov    %edi,%edx
  8019a4:	83 c4 1c             	add    $0x1c,%esp
  8019a7:	5b                   	pop    %ebx
  8019a8:	5e                   	pop    %esi
  8019a9:	5f                   	pop    %edi
  8019aa:	5d                   	pop    %ebp
  8019ab:	c3                   	ret    
  8019ac:	39 ce                	cmp    %ecx,%esi
  8019ae:	77 28                	ja     8019d8 <__udivdi3+0x7c>
  8019b0:	0f bd fe             	bsr    %esi,%edi
  8019b3:	83 f7 1f             	xor    $0x1f,%edi
  8019b6:	75 40                	jne    8019f8 <__udivdi3+0x9c>
  8019b8:	39 ce                	cmp    %ecx,%esi
  8019ba:	72 0a                	jb     8019c6 <__udivdi3+0x6a>
  8019bc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019c0:	0f 87 9e 00 00 00    	ja     801a64 <__udivdi3+0x108>
  8019c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8019cb:	89 fa                	mov    %edi,%edx
  8019cd:	83 c4 1c             	add    $0x1c,%esp
  8019d0:	5b                   	pop    %ebx
  8019d1:	5e                   	pop    %esi
  8019d2:	5f                   	pop    %edi
  8019d3:	5d                   	pop    %ebp
  8019d4:	c3                   	ret    
  8019d5:	8d 76 00             	lea    0x0(%esi),%esi
  8019d8:	31 ff                	xor    %edi,%edi
  8019da:	31 c0                	xor    %eax,%eax
  8019dc:	89 fa                	mov    %edi,%edx
  8019de:	83 c4 1c             	add    $0x1c,%esp
  8019e1:	5b                   	pop    %ebx
  8019e2:	5e                   	pop    %esi
  8019e3:	5f                   	pop    %edi
  8019e4:	5d                   	pop    %ebp
  8019e5:	c3                   	ret    
  8019e6:	66 90                	xchg   %ax,%ax
  8019e8:	89 d8                	mov    %ebx,%eax
  8019ea:	f7 f7                	div    %edi
  8019ec:	31 ff                	xor    %edi,%edi
  8019ee:	89 fa                	mov    %edi,%edx
  8019f0:	83 c4 1c             	add    $0x1c,%esp
  8019f3:	5b                   	pop    %ebx
  8019f4:	5e                   	pop    %esi
  8019f5:	5f                   	pop    %edi
  8019f6:	5d                   	pop    %ebp
  8019f7:	c3                   	ret    
  8019f8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8019fd:	89 eb                	mov    %ebp,%ebx
  8019ff:	29 fb                	sub    %edi,%ebx
  801a01:	89 f9                	mov    %edi,%ecx
  801a03:	d3 e6                	shl    %cl,%esi
  801a05:	89 c5                	mov    %eax,%ebp
  801a07:	88 d9                	mov    %bl,%cl
  801a09:	d3 ed                	shr    %cl,%ebp
  801a0b:	89 e9                	mov    %ebp,%ecx
  801a0d:	09 f1                	or     %esi,%ecx
  801a0f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a13:	89 f9                	mov    %edi,%ecx
  801a15:	d3 e0                	shl    %cl,%eax
  801a17:	89 c5                	mov    %eax,%ebp
  801a19:	89 d6                	mov    %edx,%esi
  801a1b:	88 d9                	mov    %bl,%cl
  801a1d:	d3 ee                	shr    %cl,%esi
  801a1f:	89 f9                	mov    %edi,%ecx
  801a21:	d3 e2                	shl    %cl,%edx
  801a23:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a27:	88 d9                	mov    %bl,%cl
  801a29:	d3 e8                	shr    %cl,%eax
  801a2b:	09 c2                	or     %eax,%edx
  801a2d:	89 d0                	mov    %edx,%eax
  801a2f:	89 f2                	mov    %esi,%edx
  801a31:	f7 74 24 0c          	divl   0xc(%esp)
  801a35:	89 d6                	mov    %edx,%esi
  801a37:	89 c3                	mov    %eax,%ebx
  801a39:	f7 e5                	mul    %ebp
  801a3b:	39 d6                	cmp    %edx,%esi
  801a3d:	72 19                	jb     801a58 <__udivdi3+0xfc>
  801a3f:	74 0b                	je     801a4c <__udivdi3+0xf0>
  801a41:	89 d8                	mov    %ebx,%eax
  801a43:	31 ff                	xor    %edi,%edi
  801a45:	e9 58 ff ff ff       	jmp    8019a2 <__udivdi3+0x46>
  801a4a:	66 90                	xchg   %ax,%ax
  801a4c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a50:	89 f9                	mov    %edi,%ecx
  801a52:	d3 e2                	shl    %cl,%edx
  801a54:	39 c2                	cmp    %eax,%edx
  801a56:	73 e9                	jae    801a41 <__udivdi3+0xe5>
  801a58:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a5b:	31 ff                	xor    %edi,%edi
  801a5d:	e9 40 ff ff ff       	jmp    8019a2 <__udivdi3+0x46>
  801a62:	66 90                	xchg   %ax,%ax
  801a64:	31 c0                	xor    %eax,%eax
  801a66:	e9 37 ff ff ff       	jmp    8019a2 <__udivdi3+0x46>
  801a6b:	90                   	nop

00801a6c <__umoddi3>:
  801a6c:	55                   	push   %ebp
  801a6d:	57                   	push   %edi
  801a6e:	56                   	push   %esi
  801a6f:	53                   	push   %ebx
  801a70:	83 ec 1c             	sub    $0x1c,%esp
  801a73:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a77:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a7f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a8b:	89 f3                	mov    %esi,%ebx
  801a8d:	89 fa                	mov    %edi,%edx
  801a8f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a93:	89 34 24             	mov    %esi,(%esp)
  801a96:	85 c0                	test   %eax,%eax
  801a98:	75 1a                	jne    801ab4 <__umoddi3+0x48>
  801a9a:	39 f7                	cmp    %esi,%edi
  801a9c:	0f 86 a2 00 00 00    	jbe    801b44 <__umoddi3+0xd8>
  801aa2:	89 c8                	mov    %ecx,%eax
  801aa4:	89 f2                	mov    %esi,%edx
  801aa6:	f7 f7                	div    %edi
  801aa8:	89 d0                	mov    %edx,%eax
  801aaa:	31 d2                	xor    %edx,%edx
  801aac:	83 c4 1c             	add    $0x1c,%esp
  801aaf:	5b                   	pop    %ebx
  801ab0:	5e                   	pop    %esi
  801ab1:	5f                   	pop    %edi
  801ab2:	5d                   	pop    %ebp
  801ab3:	c3                   	ret    
  801ab4:	39 f0                	cmp    %esi,%eax
  801ab6:	0f 87 ac 00 00 00    	ja     801b68 <__umoddi3+0xfc>
  801abc:	0f bd e8             	bsr    %eax,%ebp
  801abf:	83 f5 1f             	xor    $0x1f,%ebp
  801ac2:	0f 84 ac 00 00 00    	je     801b74 <__umoddi3+0x108>
  801ac8:	bf 20 00 00 00       	mov    $0x20,%edi
  801acd:	29 ef                	sub    %ebp,%edi
  801acf:	89 fe                	mov    %edi,%esi
  801ad1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ad5:	89 e9                	mov    %ebp,%ecx
  801ad7:	d3 e0                	shl    %cl,%eax
  801ad9:	89 d7                	mov    %edx,%edi
  801adb:	89 f1                	mov    %esi,%ecx
  801add:	d3 ef                	shr    %cl,%edi
  801adf:	09 c7                	or     %eax,%edi
  801ae1:	89 e9                	mov    %ebp,%ecx
  801ae3:	d3 e2                	shl    %cl,%edx
  801ae5:	89 14 24             	mov    %edx,(%esp)
  801ae8:	89 d8                	mov    %ebx,%eax
  801aea:	d3 e0                	shl    %cl,%eax
  801aec:	89 c2                	mov    %eax,%edx
  801aee:	8b 44 24 08          	mov    0x8(%esp),%eax
  801af2:	d3 e0                	shl    %cl,%eax
  801af4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801af8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801afc:	89 f1                	mov    %esi,%ecx
  801afe:	d3 e8                	shr    %cl,%eax
  801b00:	09 d0                	or     %edx,%eax
  801b02:	d3 eb                	shr    %cl,%ebx
  801b04:	89 da                	mov    %ebx,%edx
  801b06:	f7 f7                	div    %edi
  801b08:	89 d3                	mov    %edx,%ebx
  801b0a:	f7 24 24             	mull   (%esp)
  801b0d:	89 c6                	mov    %eax,%esi
  801b0f:	89 d1                	mov    %edx,%ecx
  801b11:	39 d3                	cmp    %edx,%ebx
  801b13:	0f 82 87 00 00 00    	jb     801ba0 <__umoddi3+0x134>
  801b19:	0f 84 91 00 00 00    	je     801bb0 <__umoddi3+0x144>
  801b1f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b23:	29 f2                	sub    %esi,%edx
  801b25:	19 cb                	sbb    %ecx,%ebx
  801b27:	89 d8                	mov    %ebx,%eax
  801b29:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b2d:	d3 e0                	shl    %cl,%eax
  801b2f:	89 e9                	mov    %ebp,%ecx
  801b31:	d3 ea                	shr    %cl,%edx
  801b33:	09 d0                	or     %edx,%eax
  801b35:	89 e9                	mov    %ebp,%ecx
  801b37:	d3 eb                	shr    %cl,%ebx
  801b39:	89 da                	mov    %ebx,%edx
  801b3b:	83 c4 1c             	add    $0x1c,%esp
  801b3e:	5b                   	pop    %ebx
  801b3f:	5e                   	pop    %esi
  801b40:	5f                   	pop    %edi
  801b41:	5d                   	pop    %ebp
  801b42:	c3                   	ret    
  801b43:	90                   	nop
  801b44:	89 fd                	mov    %edi,%ebp
  801b46:	85 ff                	test   %edi,%edi
  801b48:	75 0b                	jne    801b55 <__umoddi3+0xe9>
  801b4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b4f:	31 d2                	xor    %edx,%edx
  801b51:	f7 f7                	div    %edi
  801b53:	89 c5                	mov    %eax,%ebp
  801b55:	89 f0                	mov    %esi,%eax
  801b57:	31 d2                	xor    %edx,%edx
  801b59:	f7 f5                	div    %ebp
  801b5b:	89 c8                	mov    %ecx,%eax
  801b5d:	f7 f5                	div    %ebp
  801b5f:	89 d0                	mov    %edx,%eax
  801b61:	e9 44 ff ff ff       	jmp    801aaa <__umoddi3+0x3e>
  801b66:	66 90                	xchg   %ax,%ax
  801b68:	89 c8                	mov    %ecx,%eax
  801b6a:	89 f2                	mov    %esi,%edx
  801b6c:	83 c4 1c             	add    $0x1c,%esp
  801b6f:	5b                   	pop    %ebx
  801b70:	5e                   	pop    %esi
  801b71:	5f                   	pop    %edi
  801b72:	5d                   	pop    %ebp
  801b73:	c3                   	ret    
  801b74:	3b 04 24             	cmp    (%esp),%eax
  801b77:	72 06                	jb     801b7f <__umoddi3+0x113>
  801b79:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b7d:	77 0f                	ja     801b8e <__umoddi3+0x122>
  801b7f:	89 f2                	mov    %esi,%edx
  801b81:	29 f9                	sub    %edi,%ecx
  801b83:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b87:	89 14 24             	mov    %edx,(%esp)
  801b8a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b8e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b92:	8b 14 24             	mov    (%esp),%edx
  801b95:	83 c4 1c             	add    $0x1c,%esp
  801b98:	5b                   	pop    %ebx
  801b99:	5e                   	pop    %esi
  801b9a:	5f                   	pop    %edi
  801b9b:	5d                   	pop    %ebp
  801b9c:	c3                   	ret    
  801b9d:	8d 76 00             	lea    0x0(%esi),%esi
  801ba0:	2b 04 24             	sub    (%esp),%eax
  801ba3:	19 fa                	sbb    %edi,%edx
  801ba5:	89 d1                	mov    %edx,%ecx
  801ba7:	89 c6                	mov    %eax,%esi
  801ba9:	e9 71 ff ff ff       	jmp    801b1f <__umoddi3+0xb3>
  801bae:	66 90                	xchg   %ax,%ax
  801bb0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bb4:	72 ea                	jb     801ba0 <__umoddi3+0x134>
  801bb6:	89 d9                	mov    %ebx,%ecx
  801bb8:	e9 62 ff ff ff       	jmp    801b1f <__umoddi3+0xb3>
