
obj/user/tst_semaphore_1master:     file format elf32-i386


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
  800031:	e8 92 01 00 00       	call   8001c8 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int envID = sys_getenvid();
  80003e:	e8 e3 15 00 00       	call   801626 <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct semaphore cs1 = create_semaphore("cs1", 1);
  800046:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	6a 01                	push   $0x1
  80004e:	68 60 1c 80 00       	push   $0x801c60
  800053:	50                   	push   %eax
  800054:	e8 26 19 00 00       	call   80197f <create_semaphore>
  800059:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = create_semaphore("depend1", 0);
  80005c:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 00                	push   $0x0
  800064:	68 64 1c 80 00       	push   $0x801c64
  800069:	50                   	push   %eax
  80006a:	e8 10 19 00 00       	call   80197f <create_semaphore>
  80006f:	83 c4 0c             	add    $0xc,%esp

	int id1, id2, id3;
	id1 = sys_create_env("sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800072:	a1 04 30 80 00       	mov    0x803004,%eax
  800077:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  80007d:	a1 04 30 80 00       	mov    0x803004,%eax
  800082:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  800088:	89 c1                	mov    %eax,%ecx
  80008a:	a1 04 30 80 00       	mov    0x803004,%eax
  80008f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800095:	52                   	push   %edx
  800096:	51                   	push   %ecx
  800097:	50                   	push   %eax
  800098:	68 6c 1c 80 00       	push   $0x801c6c
  80009d:	e8 2f 15 00 00       	call   8015d1 <sys_create_env>
  8000a2:	83 c4 10             	add    $0x10,%esp
  8000a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	id2 = sys_create_env("sem1Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000a8:	a1 04 30 80 00       	mov    0x803004,%eax
  8000ad:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  8000b3:	a1 04 30 80 00       	mov    0x803004,%eax
  8000b8:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  8000be:	89 c1                	mov    %eax,%ecx
  8000c0:	a1 04 30 80 00       	mov    0x803004,%eax
  8000c5:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000cb:	52                   	push   %edx
  8000cc:	51                   	push   %ecx
  8000cd:	50                   	push   %eax
  8000ce:	68 6c 1c 80 00       	push   $0x801c6c
  8000d3:	e8 f9 14 00 00       	call   8015d1 <sys_create_env>
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	89 45 ec             	mov    %eax,-0x14(%ebp)
	id3 = sys_create_env("sem1Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000de:	a1 04 30 80 00       	mov    0x803004,%eax
  8000e3:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  8000e9:	a1 04 30 80 00       	mov    0x803004,%eax
  8000ee:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  8000f4:	89 c1                	mov    %eax,%ecx
  8000f6:	a1 04 30 80 00       	mov    0x803004,%eax
  8000fb:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800101:	52                   	push   %edx
  800102:	51                   	push   %ecx
  800103:	50                   	push   %eax
  800104:	68 6c 1c 80 00       	push   $0x801c6c
  800109:	e8 c3 14 00 00       	call   8015d1 <sys_create_env>
  80010e:	83 c4 10             	add    $0x10,%esp
  800111:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(id1);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	ff 75 f0             	pushl  -0x10(%ebp)
  80011a:	e8 d0 14 00 00       	call   8015ef <sys_run_env>
  80011f:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	ff 75 ec             	pushl  -0x14(%ebp)
  800128:	e8 c2 14 00 00       	call   8015ef <sys_run_env>
  80012d:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	ff 75 e8             	pushl  -0x18(%ebp)
  800136:	e8 b4 14 00 00       	call   8015ef <sys_run_env>
  80013b:	83 c4 10             	add    $0x10,%esp

	wait_semaphore(depend1);
  80013e:	83 ec 0c             	sub    $0xc,%esp
  800141:	ff 75 d8             	pushl  -0x28(%ebp)
  800144:	e8 6a 18 00 00       	call   8019b3 <wait_semaphore>
  800149:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(depend1);
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	ff 75 d8             	pushl  -0x28(%ebp)
  800152:	e8 5c 18 00 00       	call   8019b3 <wait_semaphore>
  800157:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(depend1);
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	ff 75 d8             	pushl  -0x28(%ebp)
  800160:	e8 4e 18 00 00       	call   8019b3 <wait_semaphore>
  800165:	83 c4 10             	add    $0x10,%esp

	int sem1val = semaphore_count(cs1);
  800168:	83 ec 0c             	sub    $0xc,%esp
  80016b:	ff 75 dc             	pushl  -0x24(%ebp)
  80016e:	e8 74 18 00 00       	call   8019e7 <semaphore_count>
  800173:	83 c4 10             	add    $0x10,%esp
  800176:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int sem2val = semaphore_count(depend1);
  800179:	83 ec 0c             	sub    $0xc,%esp
  80017c:	ff 75 d8             	pushl  -0x28(%ebp)
  80017f:	e8 63 18 00 00       	call   8019e7 <semaphore_count>
  800184:	83 c4 10             	add    $0x10,%esp
  800187:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (sem2val == 0 && sem1val == 1)
  80018a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80018e:	75 18                	jne    8001a8 <_main+0x170>
  800190:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  800194:	75 12                	jne    8001a8 <_main+0x170>
		cprintf("Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
  800196:	83 ec 0c             	sub    $0xc,%esp
  800199:	68 78 1c 80 00       	push   $0x801c78
  80019e:	e8 19 04 00 00       	call   8005bc <cprintf>
  8001a3:	83 c4 10             	add    $0x10,%esp
	else
		panic("Error: wrong semaphore value... please review your semaphore code again! Expected = %d, %d, Actual = %d, %d", 1, 0, sem1val, sem2val);

	return;
  8001a6:	eb 1e                	jmp    8001c6 <_main+0x18e>
	int sem1val = semaphore_count(cs1);
	int sem2val = semaphore_count(depend1);
	if (sem2val == 0 && sem1val == 1)
		cprintf("Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
	else
		panic("Error: wrong semaphore value... please review your semaphore code again! Expected = %d, %d, Actual = %d, %d", 1, 0, sem1val, sem2val);
  8001a8:	83 ec 04             	sub    $0x4,%esp
  8001ab:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ae:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001b1:	6a 00                	push   $0x0
  8001b3:	6a 01                	push   $0x1
  8001b5:	68 c0 1c 80 00       	push   $0x801cc0
  8001ba:	6a 1f                	push   $0x1f
  8001bc:	68 2c 1d 80 00       	push   $0x801d2c
  8001c1:	e8 39 01 00 00       	call   8002ff <_panic>

	return;
}
  8001c6:	c9                   	leave  
  8001c7:	c3                   	ret    

008001c8 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8001c8:	55                   	push   %ebp
  8001c9:	89 e5                	mov    %esp,%ebp
  8001cb:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001ce:	e8 6c 14 00 00       	call   80163f <sys_getenvindex>
  8001d3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8001d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001d9:	89 d0                	mov    %edx,%eax
  8001db:	c1 e0 02             	shl    $0x2,%eax
  8001de:	01 d0                	add    %edx,%eax
  8001e0:	01 c0                	add    %eax,%eax
  8001e2:	01 d0                	add    %edx,%eax
  8001e4:	c1 e0 02             	shl    $0x2,%eax
  8001e7:	01 d0                	add    %edx,%eax
  8001e9:	01 c0                	add    %eax,%eax
  8001eb:	01 d0                	add    %edx,%eax
  8001ed:	c1 e0 04             	shl    $0x4,%eax
  8001f0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001f5:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001fa:	a1 04 30 80 00       	mov    0x803004,%eax
  8001ff:	8a 40 20             	mov    0x20(%eax),%al
  800202:	84 c0                	test   %al,%al
  800204:	74 0d                	je     800213 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800206:	a1 04 30 80 00       	mov    0x803004,%eax
  80020b:	83 c0 20             	add    $0x20,%eax
  80020e:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800213:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800217:	7e 0a                	jle    800223 <libmain+0x5b>
		binaryname = argv[0];
  800219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021c:	8b 00                	mov    (%eax),%eax
  80021e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800223:	83 ec 08             	sub    $0x8,%esp
  800226:	ff 75 0c             	pushl  0xc(%ebp)
  800229:	ff 75 08             	pushl  0x8(%ebp)
  80022c:	e8 07 fe ff ff       	call   800038 <_main>
  800231:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800234:	e8 8a 11 00 00       	call   8013c3 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800239:	83 ec 0c             	sub    $0xc,%esp
  80023c:	68 64 1d 80 00       	push   $0x801d64
  800241:	e8 76 03 00 00       	call   8005bc <cprintf>
  800246:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800249:	a1 04 30 80 00       	mov    0x803004,%eax
  80024e:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800254:	a1 04 30 80 00       	mov    0x803004,%eax
  800259:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80025f:	83 ec 04             	sub    $0x4,%esp
  800262:	52                   	push   %edx
  800263:	50                   	push   %eax
  800264:	68 8c 1d 80 00       	push   $0x801d8c
  800269:	e8 4e 03 00 00       	call   8005bc <cprintf>
  80026e:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800271:	a1 04 30 80 00       	mov    0x803004,%eax
  800276:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  80027c:	a1 04 30 80 00       	mov    0x803004,%eax
  800281:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800287:	a1 04 30 80 00       	mov    0x803004,%eax
  80028c:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800292:	51                   	push   %ecx
  800293:	52                   	push   %edx
  800294:	50                   	push   %eax
  800295:	68 b4 1d 80 00       	push   $0x801db4
  80029a:	e8 1d 03 00 00       	call   8005bc <cprintf>
  80029f:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002a2:	a1 04 30 80 00       	mov    0x803004,%eax
  8002a7:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8002ad:	83 ec 08             	sub    $0x8,%esp
  8002b0:	50                   	push   %eax
  8002b1:	68 0c 1e 80 00       	push   $0x801e0c
  8002b6:	e8 01 03 00 00       	call   8005bc <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	68 64 1d 80 00       	push   $0x801d64
  8002c6:	e8 f1 02 00 00       	call   8005bc <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8002ce:	e8 0a 11 00 00       	call   8013dd <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8002d3:	e8 19 00 00 00       	call   8002f1 <exit>
}
  8002d8:	90                   	nop
  8002d9:	c9                   	leave  
  8002da:	c3                   	ret    

008002db <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002e1:	83 ec 0c             	sub    $0xc,%esp
  8002e4:	6a 00                	push   $0x0
  8002e6:	e8 20 13 00 00       	call   80160b <sys_destroy_env>
  8002eb:	83 c4 10             	add    $0x10,%esp
}
  8002ee:	90                   	nop
  8002ef:	c9                   	leave  
  8002f0:	c3                   	ret    

008002f1 <exit>:

void
exit(void)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002f7:	e8 75 13 00 00       	call   801671 <sys_exit_env>
}
  8002fc:	90                   	nop
  8002fd:	c9                   	leave  
  8002fe:	c3                   	ret    

008002ff <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
  800302:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800305:	8d 45 10             	lea    0x10(%ebp),%eax
  800308:	83 c0 04             	add    $0x4,%eax
  80030b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80030e:	a1 24 30 80 00       	mov    0x803024,%eax
  800313:	85 c0                	test   %eax,%eax
  800315:	74 16                	je     80032d <_panic+0x2e>
		cprintf("%s: ", argv0);
  800317:	a1 24 30 80 00       	mov    0x803024,%eax
  80031c:	83 ec 08             	sub    $0x8,%esp
  80031f:	50                   	push   %eax
  800320:	68 20 1e 80 00       	push   $0x801e20
  800325:	e8 92 02 00 00       	call   8005bc <cprintf>
  80032a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80032d:	a1 00 30 80 00       	mov    0x803000,%eax
  800332:	ff 75 0c             	pushl  0xc(%ebp)
  800335:	ff 75 08             	pushl  0x8(%ebp)
  800338:	50                   	push   %eax
  800339:	68 25 1e 80 00       	push   $0x801e25
  80033e:	e8 79 02 00 00       	call   8005bc <cprintf>
  800343:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800346:	8b 45 10             	mov    0x10(%ebp),%eax
  800349:	83 ec 08             	sub    $0x8,%esp
  80034c:	ff 75 f4             	pushl  -0xc(%ebp)
  80034f:	50                   	push   %eax
  800350:	e8 fc 01 00 00       	call   800551 <vcprintf>
  800355:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800358:	83 ec 08             	sub    $0x8,%esp
  80035b:	6a 00                	push   $0x0
  80035d:	68 41 1e 80 00       	push   $0x801e41
  800362:	e8 ea 01 00 00       	call   800551 <vcprintf>
  800367:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80036a:	e8 82 ff ff ff       	call   8002f1 <exit>

	// should not return here
	while (1) ;
  80036f:	eb fe                	jmp    80036f <_panic+0x70>

00800371 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800371:	55                   	push   %ebp
  800372:	89 e5                	mov    %esp,%ebp
  800374:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800377:	a1 04 30 80 00       	mov    0x803004,%eax
  80037c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800382:	8b 45 0c             	mov    0xc(%ebp),%eax
  800385:	39 c2                	cmp    %eax,%edx
  800387:	74 14                	je     80039d <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800389:	83 ec 04             	sub    $0x4,%esp
  80038c:	68 44 1e 80 00       	push   $0x801e44
  800391:	6a 26                	push   $0x26
  800393:	68 90 1e 80 00       	push   $0x801e90
  800398:	e8 62 ff ff ff       	call   8002ff <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80039d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003a4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003ab:	e9 c5 00 00 00       	jmp    800475 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bd:	01 d0                	add    %edx,%eax
  8003bf:	8b 00                	mov    (%eax),%eax
  8003c1:	85 c0                	test   %eax,%eax
  8003c3:	75 08                	jne    8003cd <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003c5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003c8:	e9 a5 00 00 00       	jmp    800472 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003cd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003db:	eb 69                	jmp    800446 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003dd:	a1 04 30 80 00       	mov    0x803004,%eax
  8003e2:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8003e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003eb:	89 d0                	mov    %edx,%eax
  8003ed:	01 c0                	add    %eax,%eax
  8003ef:	01 d0                	add    %edx,%eax
  8003f1:	c1 e0 03             	shl    $0x3,%eax
  8003f4:	01 c8                	add    %ecx,%eax
  8003f6:	8a 40 04             	mov    0x4(%eax),%al
  8003f9:	84 c0                	test   %al,%al
  8003fb:	75 46                	jne    800443 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003fd:	a1 04 30 80 00       	mov    0x803004,%eax
  800402:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800408:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80040b:	89 d0                	mov    %edx,%eax
  80040d:	01 c0                	add    %eax,%eax
  80040f:	01 d0                	add    %edx,%eax
  800411:	c1 e0 03             	shl    $0x3,%eax
  800414:	01 c8                	add    %ecx,%eax
  800416:	8b 00                	mov    (%eax),%eax
  800418:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80041b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80041e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800423:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800425:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800428:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80042f:	8b 45 08             	mov    0x8(%ebp),%eax
  800432:	01 c8                	add    %ecx,%eax
  800434:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800436:	39 c2                	cmp    %eax,%edx
  800438:	75 09                	jne    800443 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80043a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800441:	eb 15                	jmp    800458 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800443:	ff 45 e8             	incl   -0x18(%ebp)
  800446:	a1 04 30 80 00       	mov    0x803004,%eax
  80044b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800451:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800454:	39 c2                	cmp    %eax,%edx
  800456:	77 85                	ja     8003dd <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800458:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80045c:	75 14                	jne    800472 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	68 9c 1e 80 00       	push   $0x801e9c
  800466:	6a 3a                	push   $0x3a
  800468:	68 90 1e 80 00       	push   $0x801e90
  80046d:	e8 8d fe ff ff       	call   8002ff <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800472:	ff 45 f0             	incl   -0x10(%ebp)
  800475:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800478:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80047b:	0f 8c 2f ff ff ff    	jl     8003b0 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800481:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800488:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80048f:	eb 26                	jmp    8004b7 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800491:	a1 04 30 80 00       	mov    0x803004,%eax
  800496:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80049c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80049f:	89 d0                	mov    %edx,%eax
  8004a1:	01 c0                	add    %eax,%eax
  8004a3:	01 d0                	add    %edx,%eax
  8004a5:	c1 e0 03             	shl    $0x3,%eax
  8004a8:	01 c8                	add    %ecx,%eax
  8004aa:	8a 40 04             	mov    0x4(%eax),%al
  8004ad:	3c 01                	cmp    $0x1,%al
  8004af:	75 03                	jne    8004b4 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004b1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004b4:	ff 45 e0             	incl   -0x20(%ebp)
  8004b7:	a1 04 30 80 00       	mov    0x803004,%eax
  8004bc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c5:	39 c2                	cmp    %eax,%edx
  8004c7:	77 c8                	ja     800491 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004cc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004cf:	74 14                	je     8004e5 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004d1:	83 ec 04             	sub    $0x4,%esp
  8004d4:	68 f0 1e 80 00       	push   $0x801ef0
  8004d9:	6a 44                	push   $0x44
  8004db:	68 90 1e 80 00       	push   $0x801e90
  8004e0:	e8 1a fe ff ff       	call   8002ff <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004e5:	90                   	nop
  8004e6:	c9                   	leave  
  8004e7:	c3                   	ret    

008004e8 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004e8:	55                   	push   %ebp
  8004e9:	89 e5                	mov    %esp,%ebp
  8004eb:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f1:	8b 00                	mov    (%eax),%eax
  8004f3:	8d 48 01             	lea    0x1(%eax),%ecx
  8004f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f9:	89 0a                	mov    %ecx,(%edx)
  8004fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8004fe:	88 d1                	mov    %dl,%cl
  800500:	8b 55 0c             	mov    0xc(%ebp),%edx
  800503:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800507:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050a:	8b 00                	mov    (%eax),%eax
  80050c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800511:	75 2c                	jne    80053f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800513:	a0 08 30 80 00       	mov    0x803008,%al
  800518:	0f b6 c0             	movzbl %al,%eax
  80051b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80051e:	8b 12                	mov    (%edx),%edx
  800520:	89 d1                	mov    %edx,%ecx
  800522:	8b 55 0c             	mov    0xc(%ebp),%edx
  800525:	83 c2 08             	add    $0x8,%edx
  800528:	83 ec 04             	sub    $0x4,%esp
  80052b:	50                   	push   %eax
  80052c:	51                   	push   %ecx
  80052d:	52                   	push   %edx
  80052e:	e8 4e 0e 00 00       	call   801381 <sys_cputs>
  800533:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800536:	8b 45 0c             	mov    0xc(%ebp),%eax
  800539:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80053f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800542:	8b 40 04             	mov    0x4(%eax),%eax
  800545:	8d 50 01             	lea    0x1(%eax),%edx
  800548:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80054e:	90                   	nop
  80054f:	c9                   	leave  
  800550:	c3                   	ret    

00800551 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800551:	55                   	push   %ebp
  800552:	89 e5                	mov    %esp,%ebp
  800554:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80055a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800561:	00 00 00 
	b.cnt = 0;
  800564:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80056b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80056e:	ff 75 0c             	pushl  0xc(%ebp)
  800571:	ff 75 08             	pushl  0x8(%ebp)
  800574:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80057a:	50                   	push   %eax
  80057b:	68 e8 04 80 00       	push   $0x8004e8
  800580:	e8 11 02 00 00       	call   800796 <vprintfmt>
  800585:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800588:	a0 08 30 80 00       	mov    0x803008,%al
  80058d:	0f b6 c0             	movzbl %al,%eax
  800590:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800596:	83 ec 04             	sub    $0x4,%esp
  800599:	50                   	push   %eax
  80059a:	52                   	push   %edx
  80059b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a1:	83 c0 08             	add    $0x8,%eax
  8005a4:	50                   	push   %eax
  8005a5:	e8 d7 0d 00 00       	call   801381 <sys_cputs>
  8005aa:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005ad:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8005b4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005ba:	c9                   	leave  
  8005bb:	c3                   	ret    

008005bc <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005bc:	55                   	push   %ebp
  8005bd:	89 e5                	mov    %esp,%ebp
  8005bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005c2:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8005c9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d2:	83 ec 08             	sub    $0x8,%esp
  8005d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d8:	50                   	push   %eax
  8005d9:	e8 73 ff ff ff       	call   800551 <vcprintf>
  8005de:	83 c4 10             	add    $0x10,%esp
  8005e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005e7:	c9                   	leave  
  8005e8:	c3                   	ret    

008005e9 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005e9:	55                   	push   %ebp
  8005ea:	89 e5                	mov    %esp,%ebp
  8005ec:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8005ef:	e8 cf 0d 00 00       	call   8013c3 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005f4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fd:	83 ec 08             	sub    $0x8,%esp
  800600:	ff 75 f4             	pushl  -0xc(%ebp)
  800603:	50                   	push   %eax
  800604:	e8 48 ff ff ff       	call   800551 <vcprintf>
  800609:	83 c4 10             	add    $0x10,%esp
  80060c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80060f:	e8 c9 0d 00 00       	call   8013dd <sys_unlock_cons>
	return cnt;
  800614:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800617:	c9                   	leave  
  800618:	c3                   	ret    

00800619 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800619:	55                   	push   %ebp
  80061a:	89 e5                	mov    %esp,%ebp
  80061c:	53                   	push   %ebx
  80061d:	83 ec 14             	sub    $0x14,%esp
  800620:	8b 45 10             	mov    0x10(%ebp),%eax
  800623:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80062c:	8b 45 18             	mov    0x18(%ebp),%eax
  80062f:	ba 00 00 00 00       	mov    $0x0,%edx
  800634:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800637:	77 55                	ja     80068e <printnum+0x75>
  800639:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80063c:	72 05                	jb     800643 <printnum+0x2a>
  80063e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800641:	77 4b                	ja     80068e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800643:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800646:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800649:	8b 45 18             	mov    0x18(%ebp),%eax
  80064c:	ba 00 00 00 00       	mov    $0x0,%edx
  800651:	52                   	push   %edx
  800652:	50                   	push   %eax
  800653:	ff 75 f4             	pushl  -0xc(%ebp)
  800656:	ff 75 f0             	pushl  -0x10(%ebp)
  800659:	e8 96 13 00 00       	call   8019f4 <__udivdi3>
  80065e:	83 c4 10             	add    $0x10,%esp
  800661:	83 ec 04             	sub    $0x4,%esp
  800664:	ff 75 20             	pushl  0x20(%ebp)
  800667:	53                   	push   %ebx
  800668:	ff 75 18             	pushl  0x18(%ebp)
  80066b:	52                   	push   %edx
  80066c:	50                   	push   %eax
  80066d:	ff 75 0c             	pushl  0xc(%ebp)
  800670:	ff 75 08             	pushl  0x8(%ebp)
  800673:	e8 a1 ff ff ff       	call   800619 <printnum>
  800678:	83 c4 20             	add    $0x20,%esp
  80067b:	eb 1a                	jmp    800697 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	ff 75 0c             	pushl  0xc(%ebp)
  800683:	ff 75 20             	pushl  0x20(%ebp)
  800686:	8b 45 08             	mov    0x8(%ebp),%eax
  800689:	ff d0                	call   *%eax
  80068b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80068e:	ff 4d 1c             	decl   0x1c(%ebp)
  800691:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800695:	7f e6                	jg     80067d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800697:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80069a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80069f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006a5:	53                   	push   %ebx
  8006a6:	51                   	push   %ecx
  8006a7:	52                   	push   %edx
  8006a8:	50                   	push   %eax
  8006a9:	e8 56 14 00 00       	call   801b04 <__umoddi3>
  8006ae:	83 c4 10             	add    $0x10,%esp
  8006b1:	05 54 21 80 00       	add    $0x802154,%eax
  8006b6:	8a 00                	mov    (%eax),%al
  8006b8:	0f be c0             	movsbl %al,%eax
  8006bb:	83 ec 08             	sub    $0x8,%esp
  8006be:	ff 75 0c             	pushl  0xc(%ebp)
  8006c1:	50                   	push   %eax
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	ff d0                	call   *%eax
  8006c7:	83 c4 10             	add    $0x10,%esp
}
  8006ca:	90                   	nop
  8006cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ce:	c9                   	leave  
  8006cf:	c3                   	ret    

008006d0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006d0:	55                   	push   %ebp
  8006d1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006d3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006d7:	7e 1c                	jle    8006f5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	8d 50 08             	lea    0x8(%eax),%edx
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	89 10                	mov    %edx,(%eax)
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	83 e8 08             	sub    $0x8,%eax
  8006ee:	8b 50 04             	mov    0x4(%eax),%edx
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	eb 40                	jmp    800735 <getuint+0x65>
	else if (lflag)
  8006f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006f9:	74 1e                	je     800719 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	8d 50 04             	lea    0x4(%eax),%edx
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	89 10                	mov    %edx,(%eax)
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	83 e8 04             	sub    $0x4,%eax
  800710:	8b 00                	mov    (%eax),%eax
  800712:	ba 00 00 00 00       	mov    $0x0,%edx
  800717:	eb 1c                	jmp    800735 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	8d 50 04             	lea    0x4(%eax),%edx
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	89 10                	mov    %edx,(%eax)
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	83 e8 04             	sub    $0x4,%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800735:	5d                   	pop    %ebp
  800736:	c3                   	ret    

00800737 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800737:	55                   	push   %ebp
  800738:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80073a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80073e:	7e 1c                	jle    80075c <getint+0x25>
		return va_arg(*ap, long long);
  800740:	8b 45 08             	mov    0x8(%ebp),%eax
  800743:	8b 00                	mov    (%eax),%eax
  800745:	8d 50 08             	lea    0x8(%eax),%edx
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	89 10                	mov    %edx,(%eax)
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	8b 00                	mov    (%eax),%eax
  800752:	83 e8 08             	sub    $0x8,%eax
  800755:	8b 50 04             	mov    0x4(%eax),%edx
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	eb 38                	jmp    800794 <getint+0x5d>
	else if (lflag)
  80075c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800760:	74 1a                	je     80077c <getint+0x45>
		return va_arg(*ap, long);
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	8b 00                	mov    (%eax),%eax
  800767:	8d 50 04             	lea    0x4(%eax),%edx
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	89 10                	mov    %edx,(%eax)
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	83 e8 04             	sub    $0x4,%eax
  800777:	8b 00                	mov    (%eax),%eax
  800779:	99                   	cltd   
  80077a:	eb 18                	jmp    800794 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	8d 50 04             	lea    0x4(%eax),%edx
  800784:	8b 45 08             	mov    0x8(%ebp),%eax
  800787:	89 10                	mov    %edx,(%eax)
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	83 e8 04             	sub    $0x4,%eax
  800791:	8b 00                	mov    (%eax),%eax
  800793:	99                   	cltd   
}
  800794:	5d                   	pop    %ebp
  800795:	c3                   	ret    

00800796 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800796:	55                   	push   %ebp
  800797:	89 e5                	mov    %esp,%ebp
  800799:	56                   	push   %esi
  80079a:	53                   	push   %ebx
  80079b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80079e:	eb 17                	jmp    8007b7 <vprintfmt+0x21>
			if (ch == '\0')
  8007a0:	85 db                	test   %ebx,%ebx
  8007a2:	0f 84 c1 03 00 00    	je     800b69 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	ff 75 0c             	pushl  0xc(%ebp)
  8007ae:	53                   	push   %ebx
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	ff d0                	call   *%eax
  8007b4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ba:	8d 50 01             	lea    0x1(%eax),%edx
  8007bd:	89 55 10             	mov    %edx,0x10(%ebp)
  8007c0:	8a 00                	mov    (%eax),%al
  8007c2:	0f b6 d8             	movzbl %al,%ebx
  8007c5:	83 fb 25             	cmp    $0x25,%ebx
  8007c8:	75 d6                	jne    8007a0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007ca:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007ce:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007d5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007dc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007e3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ed:	8d 50 01             	lea    0x1(%eax),%edx
  8007f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8007f3:	8a 00                	mov    (%eax),%al
  8007f5:	0f b6 d8             	movzbl %al,%ebx
  8007f8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007fb:	83 f8 5b             	cmp    $0x5b,%eax
  8007fe:	0f 87 3d 03 00 00    	ja     800b41 <vprintfmt+0x3ab>
  800804:	8b 04 85 78 21 80 00 	mov    0x802178(,%eax,4),%eax
  80080b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80080d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800811:	eb d7                	jmp    8007ea <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800813:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800817:	eb d1                	jmp    8007ea <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800819:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800820:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800823:	89 d0                	mov    %edx,%eax
  800825:	c1 e0 02             	shl    $0x2,%eax
  800828:	01 d0                	add    %edx,%eax
  80082a:	01 c0                	add    %eax,%eax
  80082c:	01 d8                	add    %ebx,%eax
  80082e:	83 e8 30             	sub    $0x30,%eax
  800831:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800834:	8b 45 10             	mov    0x10(%ebp),%eax
  800837:	8a 00                	mov    (%eax),%al
  800839:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80083c:	83 fb 2f             	cmp    $0x2f,%ebx
  80083f:	7e 3e                	jle    80087f <vprintfmt+0xe9>
  800841:	83 fb 39             	cmp    $0x39,%ebx
  800844:	7f 39                	jg     80087f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800846:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800849:	eb d5                	jmp    800820 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80084b:	8b 45 14             	mov    0x14(%ebp),%eax
  80084e:	83 c0 04             	add    $0x4,%eax
  800851:	89 45 14             	mov    %eax,0x14(%ebp)
  800854:	8b 45 14             	mov    0x14(%ebp),%eax
  800857:	83 e8 04             	sub    $0x4,%eax
  80085a:	8b 00                	mov    (%eax),%eax
  80085c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80085f:	eb 1f                	jmp    800880 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800861:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800865:	79 83                	jns    8007ea <vprintfmt+0x54>
				width = 0;
  800867:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80086e:	e9 77 ff ff ff       	jmp    8007ea <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800873:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80087a:	e9 6b ff ff ff       	jmp    8007ea <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80087f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800880:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800884:	0f 89 60 ff ff ff    	jns    8007ea <vprintfmt+0x54>
				width = precision, precision = -1;
  80088a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80088d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800890:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800897:	e9 4e ff ff ff       	jmp    8007ea <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80089c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80089f:	e9 46 ff ff ff       	jmp    8007ea <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a7:	83 c0 04             	add    $0x4,%eax
  8008aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b0:	83 e8 04             	sub    $0x4,%eax
  8008b3:	8b 00                	mov    (%eax),%eax
  8008b5:	83 ec 08             	sub    $0x8,%esp
  8008b8:	ff 75 0c             	pushl  0xc(%ebp)
  8008bb:	50                   	push   %eax
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	ff d0                	call   *%eax
  8008c1:	83 c4 10             	add    $0x10,%esp
			break;
  8008c4:	e9 9b 02 00 00       	jmp    800b64 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cc:	83 c0 04             	add    $0x4,%eax
  8008cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d5:	83 e8 04             	sub    $0x4,%eax
  8008d8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008da:	85 db                	test   %ebx,%ebx
  8008dc:	79 02                	jns    8008e0 <vprintfmt+0x14a>
				err = -err;
  8008de:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008e0:	83 fb 64             	cmp    $0x64,%ebx
  8008e3:	7f 0b                	jg     8008f0 <vprintfmt+0x15a>
  8008e5:	8b 34 9d c0 1f 80 00 	mov    0x801fc0(,%ebx,4),%esi
  8008ec:	85 f6                	test   %esi,%esi
  8008ee:	75 19                	jne    800909 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008f0:	53                   	push   %ebx
  8008f1:	68 65 21 80 00       	push   $0x802165
  8008f6:	ff 75 0c             	pushl  0xc(%ebp)
  8008f9:	ff 75 08             	pushl  0x8(%ebp)
  8008fc:	e8 70 02 00 00       	call   800b71 <printfmt>
  800901:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800904:	e9 5b 02 00 00       	jmp    800b64 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800909:	56                   	push   %esi
  80090a:	68 6e 21 80 00       	push   $0x80216e
  80090f:	ff 75 0c             	pushl  0xc(%ebp)
  800912:	ff 75 08             	pushl  0x8(%ebp)
  800915:	e8 57 02 00 00       	call   800b71 <printfmt>
  80091a:	83 c4 10             	add    $0x10,%esp
			break;
  80091d:	e9 42 02 00 00       	jmp    800b64 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800922:	8b 45 14             	mov    0x14(%ebp),%eax
  800925:	83 c0 04             	add    $0x4,%eax
  800928:	89 45 14             	mov    %eax,0x14(%ebp)
  80092b:	8b 45 14             	mov    0x14(%ebp),%eax
  80092e:	83 e8 04             	sub    $0x4,%eax
  800931:	8b 30                	mov    (%eax),%esi
  800933:	85 f6                	test   %esi,%esi
  800935:	75 05                	jne    80093c <vprintfmt+0x1a6>
				p = "(null)";
  800937:	be 71 21 80 00       	mov    $0x802171,%esi
			if (width > 0 && padc != '-')
  80093c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800940:	7e 6d                	jle    8009af <vprintfmt+0x219>
  800942:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800946:	74 67                	je     8009af <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800948:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	50                   	push   %eax
  80094f:	56                   	push   %esi
  800950:	e8 1e 03 00 00       	call   800c73 <strnlen>
  800955:	83 c4 10             	add    $0x10,%esp
  800958:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80095b:	eb 16                	jmp    800973 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80095d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800961:	83 ec 08             	sub    $0x8,%esp
  800964:	ff 75 0c             	pushl  0xc(%ebp)
  800967:	50                   	push   %eax
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	ff d0                	call   *%eax
  80096d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800970:	ff 4d e4             	decl   -0x1c(%ebp)
  800973:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800977:	7f e4                	jg     80095d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800979:	eb 34                	jmp    8009af <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80097b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80097f:	74 1c                	je     80099d <vprintfmt+0x207>
  800981:	83 fb 1f             	cmp    $0x1f,%ebx
  800984:	7e 05                	jle    80098b <vprintfmt+0x1f5>
  800986:	83 fb 7e             	cmp    $0x7e,%ebx
  800989:	7e 12                	jle    80099d <vprintfmt+0x207>
					putch('?', putdat);
  80098b:	83 ec 08             	sub    $0x8,%esp
  80098e:	ff 75 0c             	pushl  0xc(%ebp)
  800991:	6a 3f                	push   $0x3f
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	ff d0                	call   *%eax
  800998:	83 c4 10             	add    $0x10,%esp
  80099b:	eb 0f                	jmp    8009ac <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80099d:	83 ec 08             	sub    $0x8,%esp
  8009a0:	ff 75 0c             	pushl  0xc(%ebp)
  8009a3:	53                   	push   %ebx
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	ff d0                	call   *%eax
  8009a9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ac:	ff 4d e4             	decl   -0x1c(%ebp)
  8009af:	89 f0                	mov    %esi,%eax
  8009b1:	8d 70 01             	lea    0x1(%eax),%esi
  8009b4:	8a 00                	mov    (%eax),%al
  8009b6:	0f be d8             	movsbl %al,%ebx
  8009b9:	85 db                	test   %ebx,%ebx
  8009bb:	74 24                	je     8009e1 <vprintfmt+0x24b>
  8009bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009c1:	78 b8                	js     80097b <vprintfmt+0x1e5>
  8009c3:	ff 4d e0             	decl   -0x20(%ebp)
  8009c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ca:	79 af                	jns    80097b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009cc:	eb 13                	jmp    8009e1 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009ce:	83 ec 08             	sub    $0x8,%esp
  8009d1:	ff 75 0c             	pushl  0xc(%ebp)
  8009d4:	6a 20                	push   $0x20
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	ff d0                	call   *%eax
  8009db:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009de:	ff 4d e4             	decl   -0x1c(%ebp)
  8009e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e5:	7f e7                	jg     8009ce <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009e7:	e9 78 01 00 00       	jmp    800b64 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009ec:	83 ec 08             	sub    $0x8,%esp
  8009ef:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f2:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f5:	50                   	push   %eax
  8009f6:	e8 3c fd ff ff       	call   800737 <getint>
  8009fb:	83 c4 10             	add    $0x10,%esp
  8009fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a01:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a0a:	85 d2                	test   %edx,%edx
  800a0c:	79 23                	jns    800a31 <vprintfmt+0x29b>
				putch('-', putdat);
  800a0e:	83 ec 08             	sub    $0x8,%esp
  800a11:	ff 75 0c             	pushl  0xc(%ebp)
  800a14:	6a 2d                	push   $0x2d
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	ff d0                	call   *%eax
  800a1b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a24:	f7 d8                	neg    %eax
  800a26:	83 d2 00             	adc    $0x0,%edx
  800a29:	f7 da                	neg    %edx
  800a2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a31:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a38:	e9 bc 00 00 00       	jmp    800af9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a3d:	83 ec 08             	sub    $0x8,%esp
  800a40:	ff 75 e8             	pushl  -0x18(%ebp)
  800a43:	8d 45 14             	lea    0x14(%ebp),%eax
  800a46:	50                   	push   %eax
  800a47:	e8 84 fc ff ff       	call   8006d0 <getuint>
  800a4c:	83 c4 10             	add    $0x10,%esp
  800a4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a52:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a55:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a5c:	e9 98 00 00 00       	jmp    800af9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a61:	83 ec 08             	sub    $0x8,%esp
  800a64:	ff 75 0c             	pushl  0xc(%ebp)
  800a67:	6a 58                	push   $0x58
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	ff d0                	call   *%eax
  800a6e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a71:	83 ec 08             	sub    $0x8,%esp
  800a74:	ff 75 0c             	pushl  0xc(%ebp)
  800a77:	6a 58                	push   $0x58
  800a79:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7c:	ff d0                	call   *%eax
  800a7e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a81:	83 ec 08             	sub    $0x8,%esp
  800a84:	ff 75 0c             	pushl  0xc(%ebp)
  800a87:	6a 58                	push   $0x58
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	ff d0                	call   *%eax
  800a8e:	83 c4 10             	add    $0x10,%esp
			break;
  800a91:	e9 ce 00 00 00       	jmp    800b64 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a96:	83 ec 08             	sub    $0x8,%esp
  800a99:	ff 75 0c             	pushl  0xc(%ebp)
  800a9c:	6a 30                	push   $0x30
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	ff d0                	call   *%eax
  800aa3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	6a 78                	push   $0x78
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	ff d0                	call   *%eax
  800ab3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ab6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab9:	83 c0 04             	add    $0x4,%eax
  800abc:	89 45 14             	mov    %eax,0x14(%ebp)
  800abf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac2:	83 e8 04             	sub    $0x4,%eax
  800ac5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ac7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ad1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ad8:	eb 1f                	jmp    800af9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ada:	83 ec 08             	sub    $0x8,%esp
  800add:	ff 75 e8             	pushl  -0x18(%ebp)
  800ae0:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae3:	50                   	push   %eax
  800ae4:	e8 e7 fb ff ff       	call   8006d0 <getuint>
  800ae9:	83 c4 10             	add    $0x10,%esp
  800aec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800af2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800af9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800afd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b00:	83 ec 04             	sub    $0x4,%esp
  800b03:	52                   	push   %edx
  800b04:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b07:	50                   	push   %eax
  800b08:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0b:	ff 75 f0             	pushl  -0x10(%ebp)
  800b0e:	ff 75 0c             	pushl  0xc(%ebp)
  800b11:	ff 75 08             	pushl  0x8(%ebp)
  800b14:	e8 00 fb ff ff       	call   800619 <printnum>
  800b19:	83 c4 20             	add    $0x20,%esp
			break;
  800b1c:	eb 46                	jmp    800b64 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b1e:	83 ec 08             	sub    $0x8,%esp
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	53                   	push   %ebx
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	ff d0                	call   *%eax
  800b2a:	83 c4 10             	add    $0x10,%esp
			break;
  800b2d:	eb 35                	jmp    800b64 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b2f:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800b36:	eb 2c                	jmp    800b64 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b38:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800b3f:	eb 23                	jmp    800b64 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b41:	83 ec 08             	sub    $0x8,%esp
  800b44:	ff 75 0c             	pushl  0xc(%ebp)
  800b47:	6a 25                	push   $0x25
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	ff d0                	call   *%eax
  800b4e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b51:	ff 4d 10             	decl   0x10(%ebp)
  800b54:	eb 03                	jmp    800b59 <vprintfmt+0x3c3>
  800b56:	ff 4d 10             	decl   0x10(%ebp)
  800b59:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5c:	48                   	dec    %eax
  800b5d:	8a 00                	mov    (%eax),%al
  800b5f:	3c 25                	cmp    $0x25,%al
  800b61:	75 f3                	jne    800b56 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b63:	90                   	nop
		}
	}
  800b64:	e9 35 fc ff ff       	jmp    80079e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b69:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b6d:	5b                   	pop    %ebx
  800b6e:	5e                   	pop    %esi
  800b6f:	5d                   	pop    %ebp
  800b70:	c3                   	ret    

00800b71 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b77:	8d 45 10             	lea    0x10(%ebp),%eax
  800b7a:	83 c0 04             	add    $0x4,%eax
  800b7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b80:	8b 45 10             	mov    0x10(%ebp),%eax
  800b83:	ff 75 f4             	pushl  -0xc(%ebp)
  800b86:	50                   	push   %eax
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	ff 75 08             	pushl  0x8(%ebp)
  800b8d:	e8 04 fc ff ff       	call   800796 <vprintfmt>
  800b92:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b95:	90                   	nop
  800b96:	c9                   	leave  
  800b97:	c3                   	ret    

00800b98 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9e:	8b 40 08             	mov    0x8(%eax),%eax
  800ba1:	8d 50 01             	lea    0x1(%eax),%edx
  800ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bad:	8b 10                	mov    (%eax),%edx
  800baf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb2:	8b 40 04             	mov    0x4(%eax),%eax
  800bb5:	39 c2                	cmp    %eax,%edx
  800bb7:	73 12                	jae    800bcb <sprintputch+0x33>
		*b->buf++ = ch;
  800bb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbc:	8b 00                	mov    (%eax),%eax
  800bbe:	8d 48 01             	lea    0x1(%eax),%ecx
  800bc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc4:	89 0a                	mov    %ecx,(%edx)
  800bc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc9:	88 10                	mov    %dl,(%eax)
}
  800bcb:	90                   	nop
  800bcc:	5d                   	pop    %ebp
  800bcd:	c3                   	ret    

00800bce <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	01 d0                	add    %edx,%eax
  800be5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bf3:	74 06                	je     800bfb <vsnprintf+0x2d>
  800bf5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf9:	7f 07                	jg     800c02 <vsnprintf+0x34>
		return -E_INVAL;
  800bfb:	b8 03 00 00 00       	mov    $0x3,%eax
  800c00:	eb 20                	jmp    800c22 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c02:	ff 75 14             	pushl  0x14(%ebp)
  800c05:	ff 75 10             	pushl  0x10(%ebp)
  800c08:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c0b:	50                   	push   %eax
  800c0c:	68 98 0b 80 00       	push   $0x800b98
  800c11:	e8 80 fb ff ff       	call   800796 <vprintfmt>
  800c16:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c1c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c2a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c2d:	83 c0 04             	add    $0x4,%eax
  800c30:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c33:	8b 45 10             	mov    0x10(%ebp),%eax
  800c36:	ff 75 f4             	pushl  -0xc(%ebp)
  800c39:	50                   	push   %eax
  800c3a:	ff 75 0c             	pushl  0xc(%ebp)
  800c3d:	ff 75 08             	pushl  0x8(%ebp)
  800c40:	e8 89 ff ff ff       	call   800bce <vsnprintf>
  800c45:	83 c4 10             	add    $0x10,%esp
  800c48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c4e:	c9                   	leave  
  800c4f:	c3                   	ret    

00800c50 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
  800c53:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c5d:	eb 06                	jmp    800c65 <strlen+0x15>
		n++;
  800c5f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c62:	ff 45 08             	incl   0x8(%ebp)
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	8a 00                	mov    (%eax),%al
  800c6a:	84 c0                	test   %al,%al
  800c6c:	75 f1                	jne    800c5f <strlen+0xf>
		n++;
	return n;
  800c6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c71:	c9                   	leave  
  800c72:	c3                   	ret    

00800c73 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c80:	eb 09                	jmp    800c8b <strnlen+0x18>
		n++;
  800c82:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c85:	ff 45 08             	incl   0x8(%ebp)
  800c88:	ff 4d 0c             	decl   0xc(%ebp)
  800c8b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8f:	74 09                	je     800c9a <strnlen+0x27>
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	8a 00                	mov    (%eax),%al
  800c96:	84 c0                	test   %al,%al
  800c98:	75 e8                	jne    800c82 <strnlen+0xf>
		n++;
	return n;
  800c9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c9d:	c9                   	leave  
  800c9e:	c3                   	ret    

00800c9f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c9f:	55                   	push   %ebp
  800ca0:	89 e5                	mov    %esp,%ebp
  800ca2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cab:	90                   	nop
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8d 50 01             	lea    0x1(%eax),%edx
  800cb2:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cbb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cbe:	8a 12                	mov    (%edx),%dl
  800cc0:	88 10                	mov    %dl,(%eax)
  800cc2:	8a 00                	mov    (%eax),%al
  800cc4:	84 c0                	test   %al,%al
  800cc6:	75 e4                	jne    800cac <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ccb:	c9                   	leave  
  800ccc:	c3                   	ret    

00800ccd <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce0:	eb 1f                	jmp    800d01 <strncpy+0x34>
		*dst++ = *src;
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	8d 50 01             	lea    0x1(%eax),%edx
  800ce8:	89 55 08             	mov    %edx,0x8(%ebp)
  800ceb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cee:	8a 12                	mov    (%edx),%dl
  800cf0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf5:	8a 00                	mov    (%eax),%al
  800cf7:	84 c0                	test   %al,%al
  800cf9:	74 03                	je     800cfe <strncpy+0x31>
			src++;
  800cfb:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cfe:	ff 45 fc             	incl   -0x4(%ebp)
  800d01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d04:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d07:	72 d9                	jb     800ce2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d09:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d0c:	c9                   	leave  
  800d0d:	c3                   	ret    

00800d0e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1e:	74 30                	je     800d50 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d20:	eb 16                	jmp    800d38 <strlcpy+0x2a>
			*dst++ = *src++;
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8d 50 01             	lea    0x1(%eax),%edx
  800d28:	89 55 08             	mov    %edx,0x8(%ebp)
  800d2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d31:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d34:	8a 12                	mov    (%edx),%dl
  800d36:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d38:	ff 4d 10             	decl   0x10(%ebp)
  800d3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3f:	74 09                	je     800d4a <strlcpy+0x3c>
  800d41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d44:	8a 00                	mov    (%eax),%al
  800d46:	84 c0                	test   %al,%al
  800d48:	75 d8                	jne    800d22 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d50:	8b 55 08             	mov    0x8(%ebp),%edx
  800d53:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d56:	29 c2                	sub    %eax,%edx
  800d58:	89 d0                	mov    %edx,%eax
}
  800d5a:	c9                   	leave  
  800d5b:	c3                   	ret    

00800d5c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d5f:	eb 06                	jmp    800d67 <strcmp+0xb>
		p++, q++;
  800d61:	ff 45 08             	incl   0x8(%ebp)
  800d64:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	84 c0                	test   %al,%al
  800d6e:	74 0e                	je     800d7e <strcmp+0x22>
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	8a 10                	mov    (%eax),%dl
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	38 c2                	cmp    %al,%dl
  800d7c:	74 e3                	je     800d61 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8a 00                	mov    (%eax),%al
  800d83:	0f b6 d0             	movzbl %al,%edx
  800d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d89:	8a 00                	mov    (%eax),%al
  800d8b:	0f b6 c0             	movzbl %al,%eax
  800d8e:	29 c2                	sub    %eax,%edx
  800d90:	89 d0                	mov    %edx,%eax
}
  800d92:	5d                   	pop    %ebp
  800d93:	c3                   	ret    

00800d94 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d97:	eb 09                	jmp    800da2 <strncmp+0xe>
		n--, p++, q++;
  800d99:	ff 4d 10             	decl   0x10(%ebp)
  800d9c:	ff 45 08             	incl   0x8(%ebp)
  800d9f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800da2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da6:	74 17                	je     800dbf <strncmp+0x2b>
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	84 c0                	test   %al,%al
  800daf:	74 0e                	je     800dbf <strncmp+0x2b>
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	8a 10                	mov    (%eax),%dl
  800db6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	38 c2                	cmp    %al,%dl
  800dbd:	74 da                	je     800d99 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dbf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc3:	75 07                	jne    800dcc <strncmp+0x38>
		return 0;
  800dc5:	b8 00 00 00 00       	mov    $0x0,%eax
  800dca:	eb 14                	jmp    800de0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	0f b6 d0             	movzbl %al,%edx
  800dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	0f b6 c0             	movzbl %al,%eax
  800ddc:	29 c2                	sub    %eax,%edx
  800dde:	89 d0                	mov    %edx,%eax
}
  800de0:	5d                   	pop    %ebp
  800de1:	c3                   	ret    

00800de2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	83 ec 04             	sub    $0x4,%esp
  800de8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800deb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dee:	eb 12                	jmp    800e02 <strchr+0x20>
		if (*s == c)
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	8a 00                	mov    (%eax),%al
  800df5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df8:	75 05                	jne    800dff <strchr+0x1d>
			return (char *) s;
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	eb 11                	jmp    800e10 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dff:	ff 45 08             	incl   0x8(%ebp)
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	8a 00                	mov    (%eax),%al
  800e07:	84 c0                	test   %al,%al
  800e09:	75 e5                	jne    800df0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e10:	c9                   	leave  
  800e11:	c3                   	ret    

00800e12 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	83 ec 04             	sub    $0x4,%esp
  800e18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e1e:	eb 0d                	jmp    800e2d <strfind+0x1b>
		if (*s == c)
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e28:	74 0e                	je     800e38 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e2a:	ff 45 08             	incl   0x8(%ebp)
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	84 c0                	test   %al,%al
  800e34:	75 ea                	jne    800e20 <strfind+0xe>
  800e36:	eb 01                	jmp    800e39 <strfind+0x27>
		if (*s == c)
			break;
  800e38:	90                   	nop
	return (char *) s;
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3c:	c9                   	leave  
  800e3d:	c3                   	ret    

00800e3e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
  800e41:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
  800e47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e50:	eb 0e                	jmp    800e60 <memset+0x22>
		*p++ = c;
  800e52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e55:	8d 50 01             	lea    0x1(%eax),%edx
  800e58:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e60:	ff 4d f8             	decl   -0x8(%ebp)
  800e63:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e67:	79 e9                	jns    800e52 <memset+0x14>
		*p++ = c;

	return v;
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e6c:	c9                   	leave  
  800e6d:	c3                   	ret    

00800e6e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
  800e71:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e80:	eb 16                	jmp    800e98 <memcpy+0x2a>
		*d++ = *s++;
  800e82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e85:	8d 50 01             	lea    0x1(%eax),%edx
  800e88:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e8b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e8e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e91:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e94:	8a 12                	mov    (%edx),%dl
  800e96:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e98:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e9e:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea1:	85 c0                	test   %eax,%eax
  800ea3:	75 dd                	jne    800e82 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea8:	c9                   	leave  
  800ea9:	c3                   	ret    

00800eaa <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ebc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ec2:	73 50                	jae    800f14 <memmove+0x6a>
  800ec4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eca:	01 d0                	add    %edx,%eax
  800ecc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ecf:	76 43                	jbe    800f14 <memmove+0x6a>
		s += n;
  800ed1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ed7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eda:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800edd:	eb 10                	jmp    800eef <memmove+0x45>
			*--d = *--s;
  800edf:	ff 4d f8             	decl   -0x8(%ebp)
  800ee2:	ff 4d fc             	decl   -0x4(%ebp)
  800ee5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee8:	8a 10                	mov    (%eax),%dl
  800eea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eed:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800eef:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef5:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef8:	85 c0                	test   %eax,%eax
  800efa:	75 e3                	jne    800edf <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800efc:	eb 23                	jmp    800f21 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800efe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f01:	8d 50 01             	lea    0x1(%eax),%edx
  800f04:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f07:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f0a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f0d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f10:	8a 12                	mov    (%edx),%dl
  800f12:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f14:	8b 45 10             	mov    0x10(%ebp),%eax
  800f17:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f1a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f1d:	85 c0                	test   %eax,%eax
  800f1f:	75 dd                	jne    800efe <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f24:	c9                   	leave  
  800f25:	c3                   	ret    

00800f26 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f35:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f38:	eb 2a                	jmp    800f64 <memcmp+0x3e>
		if (*s1 != *s2)
  800f3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3d:	8a 10                	mov    (%eax),%dl
  800f3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	38 c2                	cmp    %al,%dl
  800f46:	74 16                	je     800f5e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	0f b6 d0             	movzbl %al,%edx
  800f50:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	0f b6 c0             	movzbl %al,%eax
  800f58:	29 c2                	sub    %eax,%edx
  800f5a:	89 d0                	mov    %edx,%eax
  800f5c:	eb 18                	jmp    800f76 <memcmp+0x50>
		s1++, s2++;
  800f5e:	ff 45 fc             	incl   -0x4(%ebp)
  800f61:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f64:	8b 45 10             	mov    0x10(%ebp),%eax
  800f67:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	75 c9                	jne    800f3a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f76:	c9                   	leave  
  800f77:	c3                   	ret    

00800f78 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f78:	55                   	push   %ebp
  800f79:	89 e5                	mov    %esp,%ebp
  800f7b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f81:	8b 45 10             	mov    0x10(%ebp),%eax
  800f84:	01 d0                	add    %edx,%eax
  800f86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f89:	eb 15                	jmp    800fa0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8e:	8a 00                	mov    (%eax),%al
  800f90:	0f b6 d0             	movzbl %al,%edx
  800f93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f96:	0f b6 c0             	movzbl %al,%eax
  800f99:	39 c2                	cmp    %eax,%edx
  800f9b:	74 0d                	je     800faa <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f9d:	ff 45 08             	incl   0x8(%ebp)
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fa6:	72 e3                	jb     800f8b <memfind+0x13>
  800fa8:	eb 01                	jmp    800fab <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800faa:	90                   	nop
	return (void *) s;
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fae:	c9                   	leave  
  800faf:	c3                   	ret    

00800fb0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fbd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fc4:	eb 03                	jmp    800fc9 <strtol+0x19>
		s++;
  800fc6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	3c 20                	cmp    $0x20,%al
  800fd0:	74 f4                	je     800fc6 <strtol+0x16>
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	3c 09                	cmp    $0x9,%al
  800fd9:	74 eb                	je     800fc6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	3c 2b                	cmp    $0x2b,%al
  800fe2:	75 05                	jne    800fe9 <strtol+0x39>
		s++;
  800fe4:	ff 45 08             	incl   0x8(%ebp)
  800fe7:	eb 13                	jmp    800ffc <strtol+0x4c>
	else if (*s == '-')
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	3c 2d                	cmp    $0x2d,%al
  800ff0:	75 0a                	jne    800ffc <strtol+0x4c>
		s++, neg = 1;
  800ff2:	ff 45 08             	incl   0x8(%ebp)
  800ff5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ffc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801000:	74 06                	je     801008 <strtol+0x58>
  801002:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801006:	75 20                	jne    801028 <strtol+0x78>
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
  80100b:	8a 00                	mov    (%eax),%al
  80100d:	3c 30                	cmp    $0x30,%al
  80100f:	75 17                	jne    801028 <strtol+0x78>
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	40                   	inc    %eax
  801015:	8a 00                	mov    (%eax),%al
  801017:	3c 78                	cmp    $0x78,%al
  801019:	75 0d                	jne    801028 <strtol+0x78>
		s += 2, base = 16;
  80101b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80101f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801026:	eb 28                	jmp    801050 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801028:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80102c:	75 15                	jne    801043 <strtol+0x93>
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	8a 00                	mov    (%eax),%al
  801033:	3c 30                	cmp    $0x30,%al
  801035:	75 0c                	jne    801043 <strtol+0x93>
		s++, base = 8;
  801037:	ff 45 08             	incl   0x8(%ebp)
  80103a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801041:	eb 0d                	jmp    801050 <strtol+0xa0>
	else if (base == 0)
  801043:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801047:	75 07                	jne    801050 <strtol+0xa0>
		base = 10;
  801049:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	8a 00                	mov    (%eax),%al
  801055:	3c 2f                	cmp    $0x2f,%al
  801057:	7e 19                	jle    801072 <strtol+0xc2>
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	8a 00                	mov    (%eax),%al
  80105e:	3c 39                	cmp    $0x39,%al
  801060:	7f 10                	jg     801072 <strtol+0xc2>
			dig = *s - '0';
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	0f be c0             	movsbl %al,%eax
  80106a:	83 e8 30             	sub    $0x30,%eax
  80106d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801070:	eb 42                	jmp    8010b4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	8a 00                	mov    (%eax),%al
  801077:	3c 60                	cmp    $0x60,%al
  801079:	7e 19                	jle    801094 <strtol+0xe4>
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8a 00                	mov    (%eax),%al
  801080:	3c 7a                	cmp    $0x7a,%al
  801082:	7f 10                	jg     801094 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	0f be c0             	movsbl %al,%eax
  80108c:	83 e8 57             	sub    $0x57,%eax
  80108f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801092:	eb 20                	jmp    8010b4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	8a 00                	mov    (%eax),%al
  801099:	3c 40                	cmp    $0x40,%al
  80109b:	7e 39                	jle    8010d6 <strtol+0x126>
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	8a 00                	mov    (%eax),%al
  8010a2:	3c 5a                	cmp    $0x5a,%al
  8010a4:	7f 30                	jg     8010d6 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	8a 00                	mov    (%eax),%al
  8010ab:	0f be c0             	movsbl %al,%eax
  8010ae:	83 e8 37             	sub    $0x37,%eax
  8010b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010ba:	7d 19                	jge    8010d5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010bc:	ff 45 08             	incl   0x8(%ebp)
  8010bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010c6:	89 c2                	mov    %eax,%edx
  8010c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010cb:	01 d0                	add    %edx,%eax
  8010cd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010d0:	e9 7b ff ff ff       	jmp    801050 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010d5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010da:	74 08                	je     8010e4 <strtol+0x134>
		*endptr = (char *) s;
  8010dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010df:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010e8:	74 07                	je     8010f1 <strtol+0x141>
  8010ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ed:	f7 d8                	neg    %eax
  8010ef:	eb 03                	jmp    8010f4 <strtol+0x144>
  8010f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010f4:	c9                   	leave  
  8010f5:	c3                   	ret    

008010f6 <ltostr>:

void
ltostr(long value, char *str)
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801103:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80110a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80110e:	79 13                	jns    801123 <ltostr+0x2d>
	{
		neg = 1;
  801110:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801117:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80111d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801120:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80112b:	99                   	cltd   
  80112c:	f7 f9                	idiv   %ecx
  80112e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801131:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801134:	8d 50 01             	lea    0x1(%eax),%edx
  801137:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80113a:	89 c2                	mov    %eax,%edx
  80113c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113f:	01 d0                	add    %edx,%eax
  801141:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801144:	83 c2 30             	add    $0x30,%edx
  801147:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801149:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80114c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801151:	f7 e9                	imul   %ecx
  801153:	c1 fa 02             	sar    $0x2,%edx
  801156:	89 c8                	mov    %ecx,%eax
  801158:	c1 f8 1f             	sar    $0x1f,%eax
  80115b:	29 c2                	sub    %eax,%edx
  80115d:	89 d0                	mov    %edx,%eax
  80115f:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801162:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801166:	75 bb                	jne    801123 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801168:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80116f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801172:	48                   	dec    %eax
  801173:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801176:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80117a:	74 3d                	je     8011b9 <ltostr+0xc3>
		start = 1 ;
  80117c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801183:	eb 34                	jmp    8011b9 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801185:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	01 d0                	add    %edx,%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801192:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801195:	8b 45 0c             	mov    0xc(%ebp),%eax
  801198:	01 c2                	add    %eax,%edx
  80119a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80119d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a0:	01 c8                	add    %ecx,%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ac:	01 c2                	add    %eax,%edx
  8011ae:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011b1:	88 02                	mov    %al,(%edx)
		start++ ;
  8011b3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011b6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011bc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011bf:	7c c4                	jl     801185 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011c1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c7:	01 d0                	add    %edx,%eax
  8011c9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011cc:	90                   	nop
  8011cd:	c9                   	leave  
  8011ce:	c3                   	ret    

008011cf <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011d5:	ff 75 08             	pushl  0x8(%ebp)
  8011d8:	e8 73 fa ff ff       	call   800c50 <strlen>
  8011dd:	83 c4 04             	add    $0x4,%esp
  8011e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011e3:	ff 75 0c             	pushl  0xc(%ebp)
  8011e6:	e8 65 fa ff ff       	call   800c50 <strlen>
  8011eb:	83 c4 04             	add    $0x4,%esp
  8011ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ff:	eb 17                	jmp    801218 <strcconcat+0x49>
		final[s] = str1[s] ;
  801201:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801204:	8b 45 10             	mov    0x10(%ebp),%eax
  801207:	01 c2                	add    %eax,%edx
  801209:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	01 c8                	add    %ecx,%eax
  801211:	8a 00                	mov    (%eax),%al
  801213:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801215:	ff 45 fc             	incl   -0x4(%ebp)
  801218:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80121b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80121e:	7c e1                	jl     801201 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801220:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801227:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80122e:	eb 1f                	jmp    80124f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801230:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801233:	8d 50 01             	lea    0x1(%eax),%edx
  801236:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801239:	89 c2                	mov    %eax,%edx
  80123b:	8b 45 10             	mov    0x10(%ebp),%eax
  80123e:	01 c2                	add    %eax,%edx
  801240:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801243:	8b 45 0c             	mov    0xc(%ebp),%eax
  801246:	01 c8                	add    %ecx,%eax
  801248:	8a 00                	mov    (%eax),%al
  80124a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80124c:	ff 45 f8             	incl   -0x8(%ebp)
  80124f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801252:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801255:	7c d9                	jl     801230 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801257:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80125a:	8b 45 10             	mov    0x10(%ebp),%eax
  80125d:	01 d0                	add    %edx,%eax
  80125f:	c6 00 00             	movb   $0x0,(%eax)
}
  801262:	90                   	nop
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801268:	8b 45 14             	mov    0x14(%ebp),%eax
  80126b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801271:	8b 45 14             	mov    0x14(%ebp),%eax
  801274:	8b 00                	mov    (%eax),%eax
  801276:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80127d:	8b 45 10             	mov    0x10(%ebp),%eax
  801280:	01 d0                	add    %edx,%eax
  801282:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801288:	eb 0c                	jmp    801296 <strsplit+0x31>
			*string++ = 0;
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	8d 50 01             	lea    0x1(%eax),%edx
  801290:	89 55 08             	mov    %edx,0x8(%ebp)
  801293:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	8a 00                	mov    (%eax),%al
  80129b:	84 c0                	test   %al,%al
  80129d:	74 18                	je     8012b7 <strsplit+0x52>
  80129f:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a2:	8a 00                	mov    (%eax),%al
  8012a4:	0f be c0             	movsbl %al,%eax
  8012a7:	50                   	push   %eax
  8012a8:	ff 75 0c             	pushl  0xc(%ebp)
  8012ab:	e8 32 fb ff ff       	call   800de2 <strchr>
  8012b0:	83 c4 08             	add    $0x8,%esp
  8012b3:	85 c0                	test   %eax,%eax
  8012b5:	75 d3                	jne    80128a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	8a 00                	mov    (%eax),%al
  8012bc:	84 c0                	test   %al,%al
  8012be:	74 5a                	je     80131a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c3:	8b 00                	mov    (%eax),%eax
  8012c5:	83 f8 0f             	cmp    $0xf,%eax
  8012c8:	75 07                	jne    8012d1 <strsplit+0x6c>
		{
			return 0;
  8012ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8012cf:	eb 66                	jmp    801337 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d4:	8b 00                	mov    (%eax),%eax
  8012d6:	8d 48 01             	lea    0x1(%eax),%ecx
  8012d9:	8b 55 14             	mov    0x14(%ebp),%edx
  8012dc:	89 0a                	mov    %ecx,(%edx)
  8012de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e8:	01 c2                	add    %eax,%edx
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ef:	eb 03                	jmp    8012f4 <strsplit+0x8f>
			string++;
  8012f1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	8a 00                	mov    (%eax),%al
  8012f9:	84 c0                	test   %al,%al
  8012fb:	74 8b                	je     801288 <strsplit+0x23>
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	0f be c0             	movsbl %al,%eax
  801305:	50                   	push   %eax
  801306:	ff 75 0c             	pushl  0xc(%ebp)
  801309:	e8 d4 fa ff ff       	call   800de2 <strchr>
  80130e:	83 c4 08             	add    $0x8,%esp
  801311:	85 c0                	test   %eax,%eax
  801313:	74 dc                	je     8012f1 <strsplit+0x8c>
			string++;
	}
  801315:	e9 6e ff ff ff       	jmp    801288 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80131a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80131b:	8b 45 14             	mov    0x14(%ebp),%eax
  80131e:	8b 00                	mov    (%eax),%eax
  801320:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801327:	8b 45 10             	mov    0x10(%ebp),%eax
  80132a:	01 d0                	add    %edx,%eax
  80132c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801332:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80133f:	83 ec 04             	sub    $0x4,%esp
  801342:	68 e8 22 80 00       	push   $0x8022e8
  801347:	68 3f 01 00 00       	push   $0x13f
  80134c:	68 0a 23 80 00       	push   $0x80230a
  801351:	e8 a9 ef ff ff       	call   8002ff <_panic>

00801356 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
  801359:	57                   	push   %edi
  80135a:	56                   	push   %esi
  80135b:	53                   	push   %ebx
  80135c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	8b 55 0c             	mov    0xc(%ebp),%edx
  801365:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801368:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80136b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80136e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801371:	cd 30                	int    $0x30
  801373:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801376:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801379:	83 c4 10             	add    $0x10,%esp
  80137c:	5b                   	pop    %ebx
  80137d:	5e                   	pop    %esi
  80137e:	5f                   	pop    %edi
  80137f:	5d                   	pop    %ebp
  801380:	c3                   	ret    

00801381 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
  801384:	83 ec 04             	sub    $0x4,%esp
  801387:	8b 45 10             	mov    0x10(%ebp),%eax
  80138a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80138d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	6a 00                	push   $0x0
  801396:	6a 00                	push   $0x0
  801398:	52                   	push   %edx
  801399:	ff 75 0c             	pushl  0xc(%ebp)
  80139c:	50                   	push   %eax
  80139d:	6a 00                	push   $0x0
  80139f:	e8 b2 ff ff ff       	call   801356 <syscall>
  8013a4:	83 c4 18             	add    $0x18,%esp
}
  8013a7:	90                   	nop
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <sys_cgetc>:

int
sys_cgetc(void)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8013ad:	6a 00                	push   $0x0
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 02                	push   $0x2
  8013b9:	e8 98 ff ff ff       	call   801356 <syscall>
  8013be:	83 c4 18             	add    $0x18,%esp
}
  8013c1:	c9                   	leave  
  8013c2:	c3                   	ret    

008013c3 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 00                	push   $0x0
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 00                	push   $0x0
  8013d0:	6a 03                	push   $0x3
  8013d2:	e8 7f ff ff ff       	call   801356 <syscall>
  8013d7:	83 c4 18             	add    $0x18,%esp
}
  8013da:	90                   	nop
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    

008013dd <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 04                	push   $0x4
  8013ec:	e8 65 ff ff ff       	call   801356 <syscall>
  8013f1:	83 c4 18             	add    $0x18,%esp
}
  8013f4:	90                   	nop
  8013f5:	c9                   	leave  
  8013f6:	c3                   	ret    

008013f7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8013fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801400:	6a 00                	push   $0x0
  801402:	6a 00                	push   $0x0
  801404:	6a 00                	push   $0x0
  801406:	52                   	push   %edx
  801407:	50                   	push   %eax
  801408:	6a 08                	push   $0x8
  80140a:	e8 47 ff ff ff       	call   801356 <syscall>
  80140f:	83 c4 18             	add    $0x18,%esp
}
  801412:	c9                   	leave  
  801413:	c3                   	ret    

00801414 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
  801417:	56                   	push   %esi
  801418:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801419:	8b 75 18             	mov    0x18(%ebp),%esi
  80141c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80141f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801422:	8b 55 0c             	mov    0xc(%ebp),%edx
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	56                   	push   %esi
  801429:	53                   	push   %ebx
  80142a:	51                   	push   %ecx
  80142b:	52                   	push   %edx
  80142c:	50                   	push   %eax
  80142d:	6a 09                	push   $0x9
  80142f:	e8 22 ff ff ff       	call   801356 <syscall>
  801434:	83 c4 18             	add    $0x18,%esp
}
  801437:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80143a:	5b                   	pop    %ebx
  80143b:	5e                   	pop    %esi
  80143c:	5d                   	pop    %ebp
  80143d:	c3                   	ret    

0080143e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801441:	8b 55 0c             	mov    0xc(%ebp),%edx
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	6a 00                	push   $0x0
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	52                   	push   %edx
  80144e:	50                   	push   %eax
  80144f:	6a 0a                	push   $0xa
  801451:	e8 00 ff ff ff       	call   801356 <syscall>
  801456:	83 c4 18             	add    $0x18,%esp
}
  801459:	c9                   	leave  
  80145a:	c3                   	ret    

0080145b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	ff 75 0c             	pushl  0xc(%ebp)
  801467:	ff 75 08             	pushl  0x8(%ebp)
  80146a:	6a 0b                	push   $0xb
  80146c:	e8 e5 fe ff ff       	call   801356 <syscall>
  801471:	83 c4 18             	add    $0x18,%esp
}
  801474:	c9                   	leave  
  801475:	c3                   	ret    

00801476 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	6a 00                	push   $0x0
  80147f:	6a 00                	push   $0x0
  801481:	6a 00                	push   $0x0
  801483:	6a 0c                	push   $0xc
  801485:	e8 cc fe ff ff       	call   801356 <syscall>
  80148a:	83 c4 18             	add    $0x18,%esp
}
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801492:	6a 00                	push   $0x0
  801494:	6a 00                	push   $0x0
  801496:	6a 00                	push   $0x0
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	6a 0d                	push   $0xd
  80149e:	e8 b3 fe ff ff       	call   801356 <syscall>
  8014a3:	83 c4 18             	add    $0x18,%esp
}
  8014a6:	c9                   	leave  
  8014a7:	c3                   	ret    

008014a8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 0e                	push   $0xe
  8014b7:	e8 9a fe ff ff       	call   801356 <syscall>
  8014bc:	83 c4 18             	add    $0x18,%esp
}
  8014bf:	c9                   	leave  
  8014c0:	c3                   	ret    

008014c1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 0f                	push   $0xf
  8014d0:	e8 81 fe ff ff       	call   801356 <syscall>
  8014d5:	83 c4 18             	add    $0x18,%esp
}
  8014d8:	c9                   	leave  
  8014d9:	c3                   	ret    

008014da <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 00                	push   $0x0
  8014e1:	6a 00                	push   $0x0
  8014e3:	6a 00                	push   $0x0
  8014e5:	ff 75 08             	pushl  0x8(%ebp)
  8014e8:	6a 10                	push   $0x10
  8014ea:	e8 67 fe ff ff       	call   801356 <syscall>
  8014ef:	83 c4 18             	add    $0x18,%esp
}
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 11                	push   $0x11
  801503:	e8 4e fe ff ff       	call   801356 <syscall>
  801508:	83 c4 18             	add    $0x18,%esp
}
  80150b:	90                   	nop
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

0080150e <sys_cputc>:

void
sys_cputc(const char c)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
  801511:	83 ec 04             	sub    $0x4,%esp
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80151a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	50                   	push   %eax
  801527:	6a 01                	push   $0x1
  801529:	e8 28 fe ff ff       	call   801356 <syscall>
  80152e:	83 c4 18             	add    $0x18,%esp
}
  801531:	90                   	nop
  801532:	c9                   	leave  
  801533:	c3                   	ret    

00801534 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 14                	push   $0x14
  801543:	e8 0e fe ff ff       	call   801356 <syscall>
  801548:	83 c4 18             	add    $0x18,%esp
}
  80154b:	90                   	nop
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    

0080154e <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	83 ec 04             	sub    $0x4,%esp
  801554:	8b 45 10             	mov    0x10(%ebp),%eax
  801557:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80155a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80155d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	6a 00                	push   $0x0
  801566:	51                   	push   %ecx
  801567:	52                   	push   %edx
  801568:	ff 75 0c             	pushl  0xc(%ebp)
  80156b:	50                   	push   %eax
  80156c:	6a 15                	push   $0x15
  80156e:	e8 e3 fd ff ff       	call   801356 <syscall>
  801573:	83 c4 18             	add    $0x18,%esp
}
  801576:	c9                   	leave  
  801577:	c3                   	ret    

00801578 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80157b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157e:	8b 45 08             	mov    0x8(%ebp),%eax
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	52                   	push   %edx
  801588:	50                   	push   %eax
  801589:	6a 16                	push   $0x16
  80158b:	e8 c6 fd ff ff       	call   801356 <syscall>
  801590:	83 c4 18             	add    $0x18,%esp
}
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801598:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80159b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	51                   	push   %ecx
  8015a6:	52                   	push   %edx
  8015a7:	50                   	push   %eax
  8015a8:	6a 17                	push   $0x17
  8015aa:	e8 a7 fd ff ff       	call   801356 <syscall>
  8015af:	83 c4 18             	add    $0x18,%esp
}
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	52                   	push   %edx
  8015c4:	50                   	push   %eax
  8015c5:	6a 18                	push   $0x18
  8015c7:	e8 8a fd ff ff       	call   801356 <syscall>
  8015cc:	83 c4 18             	add    $0x18,%esp
}
  8015cf:	c9                   	leave  
  8015d0:	c3                   	ret    

008015d1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d7:	6a 00                	push   $0x0
  8015d9:	ff 75 14             	pushl  0x14(%ebp)
  8015dc:	ff 75 10             	pushl  0x10(%ebp)
  8015df:	ff 75 0c             	pushl  0xc(%ebp)
  8015e2:	50                   	push   %eax
  8015e3:	6a 19                	push   $0x19
  8015e5:	e8 6c fd ff ff       	call   801356 <syscall>
  8015ea:	83 c4 18             	add    $0x18,%esp
}
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    

008015ef <sys_run_env>:

void sys_run_env(int32 envId)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	50                   	push   %eax
  8015fe:	6a 1a                	push   $0x1a
  801600:	e8 51 fd ff ff       	call   801356 <syscall>
  801605:	83 c4 18             	add    $0x18,%esp
}
  801608:	90                   	nop
  801609:	c9                   	leave  
  80160a:	c3                   	ret    

0080160b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80160e:	8b 45 08             	mov    0x8(%ebp),%eax
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	50                   	push   %eax
  80161a:	6a 1b                	push   $0x1b
  80161c:	e8 35 fd ff ff       	call   801356 <syscall>
  801621:	83 c4 18             	add    $0x18,%esp
}
  801624:	c9                   	leave  
  801625:	c3                   	ret    

00801626 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 05                	push   $0x5
  801635:	e8 1c fd ff ff       	call   801356 <syscall>
  80163a:	83 c4 18             	add    $0x18,%esp
}
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    

0080163f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 06                	push   $0x6
  80164e:	e8 03 fd ff ff       	call   801356 <syscall>
  801653:	83 c4 18             	add    $0x18,%esp
}
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 07                	push   $0x7
  801667:	e8 ea fc ff ff       	call   801356 <syscall>
  80166c:	83 c4 18             	add    $0x18,%esp
}
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <sys_exit_env>:


void sys_exit_env(void)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 1c                	push   $0x1c
  801680:	e8 d1 fc ff ff       	call   801356 <syscall>
  801685:	83 c4 18             	add    $0x18,%esp
}
  801688:	90                   	nop
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801691:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801694:	8d 50 04             	lea    0x4(%eax),%edx
  801697:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	52                   	push   %edx
  8016a1:	50                   	push   %eax
  8016a2:	6a 1d                	push   $0x1d
  8016a4:	e8 ad fc ff ff       	call   801356 <syscall>
  8016a9:	83 c4 18             	add    $0x18,%esp
	return result;
  8016ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b5:	89 01                	mov    %eax,(%ecx)
  8016b7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	c9                   	leave  
  8016be:	c2 04 00             	ret    $0x4

008016c1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	ff 75 10             	pushl  0x10(%ebp)
  8016cb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ce:	ff 75 08             	pushl  0x8(%ebp)
  8016d1:	6a 13                	push   $0x13
  8016d3:	e8 7e fc ff ff       	call   801356 <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8016db:	90                   	nop
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <sys_rcr2>:
uint32 sys_rcr2()
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 1e                	push   $0x1e
  8016ed:	e8 64 fc ff ff       	call   801356 <syscall>
  8016f2:	83 c4 18             	add    $0x18,%esp
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	83 ec 04             	sub    $0x4,%esp
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801703:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	50                   	push   %eax
  801710:	6a 1f                	push   $0x1f
  801712:	e8 3f fc ff ff       	call   801356 <syscall>
  801717:	83 c4 18             	add    $0x18,%esp
	return ;
  80171a:	90                   	nop
}
  80171b:	c9                   	leave  
  80171c:	c3                   	ret    

0080171d <rsttst>:
void rsttst()
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 21                	push   $0x21
  80172c:	e8 25 fc ff ff       	call   801356 <syscall>
  801731:	83 c4 18             	add    $0x18,%esp
	return ;
  801734:	90                   	nop
}
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
  80173a:	83 ec 04             	sub    $0x4,%esp
  80173d:	8b 45 14             	mov    0x14(%ebp),%eax
  801740:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801743:	8b 55 18             	mov    0x18(%ebp),%edx
  801746:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80174a:	52                   	push   %edx
  80174b:	50                   	push   %eax
  80174c:	ff 75 10             	pushl  0x10(%ebp)
  80174f:	ff 75 0c             	pushl  0xc(%ebp)
  801752:	ff 75 08             	pushl  0x8(%ebp)
  801755:	6a 20                	push   $0x20
  801757:	e8 fa fb ff ff       	call   801356 <syscall>
  80175c:	83 c4 18             	add    $0x18,%esp
	return ;
  80175f:	90                   	nop
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <chktst>:
void chktst(uint32 n)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	ff 75 08             	pushl  0x8(%ebp)
  801770:	6a 22                	push   $0x22
  801772:	e8 df fb ff ff       	call   801356 <syscall>
  801777:	83 c4 18             	add    $0x18,%esp
	return ;
  80177a:	90                   	nop
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <inctst>:

void inctst()
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 23                	push   $0x23
  80178c:	e8 c5 fb ff ff       	call   801356 <syscall>
  801791:	83 c4 18             	add    $0x18,%esp
	return ;
  801794:	90                   	nop
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <gettst>:
uint32 gettst()
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 24                	push   $0x24
  8017a6:	e8 ab fb ff ff       	call   801356 <syscall>
  8017ab:	83 c4 18             	add    $0x18,%esp
}
  8017ae:	c9                   	leave  
  8017af:	c3                   	ret    

008017b0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 25                	push   $0x25
  8017c2:	e8 8f fb ff ff       	call   801356 <syscall>
  8017c7:	83 c4 18             	add    $0x18,%esp
  8017ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017cd:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017d1:	75 07                	jne    8017da <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8017d8:	eb 05                	jmp    8017df <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 25                	push   $0x25
  8017f3:	e8 5e fb ff ff       	call   801356 <syscall>
  8017f8:	83 c4 18             	add    $0x18,%esp
  8017fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8017fe:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801802:	75 07                	jne    80180b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801804:	b8 01 00 00 00       	mov    $0x1,%eax
  801809:	eb 05                	jmp    801810 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80180b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801810:	c9                   	leave  
  801811:	c3                   	ret    

00801812 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
  801815:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 25                	push   $0x25
  801824:	e8 2d fb ff ff       	call   801356 <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
  80182c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80182f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801833:	75 07                	jne    80183c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801835:	b8 01 00 00 00       	mov    $0x1,%eax
  80183a:	eb 05                	jmp    801841 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80183c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 25                	push   $0x25
  801855:	e8 fc fa ff ff       	call   801356 <syscall>
  80185a:	83 c4 18             	add    $0x18,%esp
  80185d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801860:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801864:	75 07                	jne    80186d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801866:	b8 01 00 00 00       	mov    $0x1,%eax
  80186b:	eb 05                	jmp    801872 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80186d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	ff 75 08             	pushl  0x8(%ebp)
  801882:	6a 26                	push   $0x26
  801884:	e8 cd fa ff ff       	call   801356 <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
	return ;
  80188c:	90                   	nop
}
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
  801892:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801893:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801896:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801899:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189c:	8b 45 08             	mov    0x8(%ebp),%eax
  80189f:	6a 00                	push   $0x0
  8018a1:	53                   	push   %ebx
  8018a2:	51                   	push   %ecx
  8018a3:	52                   	push   %edx
  8018a4:	50                   	push   %eax
  8018a5:	6a 27                	push   $0x27
  8018a7:	e8 aa fa ff ff       	call   801356 <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
}
  8018af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	52                   	push   %edx
  8018c4:	50                   	push   %eax
  8018c5:	6a 28                	push   $0x28
  8018c7:	e8 8a fa ff ff       	call   801356 <syscall>
  8018cc:	83 c4 18             	add    $0x18,%esp
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018d4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018da:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dd:	6a 00                	push   $0x0
  8018df:	51                   	push   %ecx
  8018e0:	ff 75 10             	pushl  0x10(%ebp)
  8018e3:	52                   	push   %edx
  8018e4:	50                   	push   %eax
  8018e5:	6a 29                	push   $0x29
  8018e7:	e8 6a fa ff ff       	call   801356 <syscall>
  8018ec:	83 c4 18             	add    $0x18,%esp
}
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	ff 75 10             	pushl  0x10(%ebp)
  8018fb:	ff 75 0c             	pushl  0xc(%ebp)
  8018fe:	ff 75 08             	pushl  0x8(%ebp)
  801901:	6a 12                	push   $0x12
  801903:	e8 4e fa ff ff       	call   801356 <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
	return ;
  80190b:	90                   	nop
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801911:	8b 55 0c             	mov    0xc(%ebp),%edx
  801914:	8b 45 08             	mov    0x8(%ebp),%eax
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	52                   	push   %edx
  80191e:	50                   	push   %eax
  80191f:	6a 2a                	push   $0x2a
  801921:	e8 30 fa ff ff       	call   801356 <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
	return;
  801929:	90                   	nop
}
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	50                   	push   %eax
  80193b:	6a 2b                	push   $0x2b
  80193d:	e8 14 fa ff ff       	call   801356 <syscall>
  801942:	83 c4 18             	add    $0x18,%esp
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	ff 75 0c             	pushl  0xc(%ebp)
  801953:	ff 75 08             	pushl  0x8(%ebp)
  801956:	6a 2c                	push   $0x2c
  801958:	e8 f9 f9 ff ff       	call   801356 <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
	return;
  801960:	90                   	nop
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	ff 75 0c             	pushl  0xc(%ebp)
  80196f:	ff 75 08             	pushl  0x8(%ebp)
  801972:	6a 2d                	push   $0x2d
  801974:	e8 dd f9 ff ff       	call   801356 <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
	return;
  80197c:	90                   	nop
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  801985:	83 ec 04             	sub    $0x4,%esp
  801988:	68 18 23 80 00       	push   $0x802318
  80198d:	6a 09                	push   $0x9
  80198f:	68 40 23 80 00       	push   $0x802340
  801994:	e8 66 e9 ff ff       	call   8002ff <_panic>

00801999 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  80199f:	83 ec 04             	sub    $0x4,%esp
  8019a2:	68 50 23 80 00       	push   $0x802350
  8019a7:	6a 10                	push   $0x10
  8019a9:	68 40 23 80 00       	push   $0x802340
  8019ae:	e8 4c e9 ff ff       	call   8002ff <_panic>

008019b3 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
  8019b6:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  8019b9:	83 ec 04             	sub    $0x4,%esp
  8019bc:	68 78 23 80 00       	push   $0x802378
  8019c1:	6a 18                	push   $0x18
  8019c3:	68 40 23 80 00       	push   $0x802340
  8019c8:	e8 32 e9 ff ff       	call   8002ff <_panic>

008019cd <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
  8019d0:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  8019d3:	83 ec 04             	sub    $0x4,%esp
  8019d6:	68 a0 23 80 00       	push   $0x8023a0
  8019db:	6a 20                	push   $0x20
  8019dd:	68 40 23 80 00       	push   $0x802340
  8019e2:	e8 18 e9 ff ff       	call   8002ff <_panic>

008019e7 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	8b 40 10             	mov    0x10(%eax),%eax
}
  8019f0:	5d                   	pop    %ebp
  8019f1:	c3                   	ret    
  8019f2:	66 90                	xchg   %ax,%ax

008019f4 <__udivdi3>:
  8019f4:	55                   	push   %ebp
  8019f5:	57                   	push   %edi
  8019f6:	56                   	push   %esi
  8019f7:	53                   	push   %ebx
  8019f8:	83 ec 1c             	sub    $0x1c,%esp
  8019fb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019ff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a07:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a0b:	89 ca                	mov    %ecx,%edx
  801a0d:	89 f8                	mov    %edi,%eax
  801a0f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a13:	85 f6                	test   %esi,%esi
  801a15:	75 2d                	jne    801a44 <__udivdi3+0x50>
  801a17:	39 cf                	cmp    %ecx,%edi
  801a19:	77 65                	ja     801a80 <__udivdi3+0x8c>
  801a1b:	89 fd                	mov    %edi,%ebp
  801a1d:	85 ff                	test   %edi,%edi
  801a1f:	75 0b                	jne    801a2c <__udivdi3+0x38>
  801a21:	b8 01 00 00 00       	mov    $0x1,%eax
  801a26:	31 d2                	xor    %edx,%edx
  801a28:	f7 f7                	div    %edi
  801a2a:	89 c5                	mov    %eax,%ebp
  801a2c:	31 d2                	xor    %edx,%edx
  801a2e:	89 c8                	mov    %ecx,%eax
  801a30:	f7 f5                	div    %ebp
  801a32:	89 c1                	mov    %eax,%ecx
  801a34:	89 d8                	mov    %ebx,%eax
  801a36:	f7 f5                	div    %ebp
  801a38:	89 cf                	mov    %ecx,%edi
  801a3a:	89 fa                	mov    %edi,%edx
  801a3c:	83 c4 1c             	add    $0x1c,%esp
  801a3f:	5b                   	pop    %ebx
  801a40:	5e                   	pop    %esi
  801a41:	5f                   	pop    %edi
  801a42:	5d                   	pop    %ebp
  801a43:	c3                   	ret    
  801a44:	39 ce                	cmp    %ecx,%esi
  801a46:	77 28                	ja     801a70 <__udivdi3+0x7c>
  801a48:	0f bd fe             	bsr    %esi,%edi
  801a4b:	83 f7 1f             	xor    $0x1f,%edi
  801a4e:	75 40                	jne    801a90 <__udivdi3+0x9c>
  801a50:	39 ce                	cmp    %ecx,%esi
  801a52:	72 0a                	jb     801a5e <__udivdi3+0x6a>
  801a54:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a58:	0f 87 9e 00 00 00    	ja     801afc <__udivdi3+0x108>
  801a5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a63:	89 fa                	mov    %edi,%edx
  801a65:	83 c4 1c             	add    $0x1c,%esp
  801a68:	5b                   	pop    %ebx
  801a69:	5e                   	pop    %esi
  801a6a:	5f                   	pop    %edi
  801a6b:	5d                   	pop    %ebp
  801a6c:	c3                   	ret    
  801a6d:	8d 76 00             	lea    0x0(%esi),%esi
  801a70:	31 ff                	xor    %edi,%edi
  801a72:	31 c0                	xor    %eax,%eax
  801a74:	89 fa                	mov    %edi,%edx
  801a76:	83 c4 1c             	add    $0x1c,%esp
  801a79:	5b                   	pop    %ebx
  801a7a:	5e                   	pop    %esi
  801a7b:	5f                   	pop    %edi
  801a7c:	5d                   	pop    %ebp
  801a7d:	c3                   	ret    
  801a7e:	66 90                	xchg   %ax,%ax
  801a80:	89 d8                	mov    %ebx,%eax
  801a82:	f7 f7                	div    %edi
  801a84:	31 ff                	xor    %edi,%edi
  801a86:	89 fa                	mov    %edi,%edx
  801a88:	83 c4 1c             	add    $0x1c,%esp
  801a8b:	5b                   	pop    %ebx
  801a8c:	5e                   	pop    %esi
  801a8d:	5f                   	pop    %edi
  801a8e:	5d                   	pop    %ebp
  801a8f:	c3                   	ret    
  801a90:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a95:	89 eb                	mov    %ebp,%ebx
  801a97:	29 fb                	sub    %edi,%ebx
  801a99:	89 f9                	mov    %edi,%ecx
  801a9b:	d3 e6                	shl    %cl,%esi
  801a9d:	89 c5                	mov    %eax,%ebp
  801a9f:	88 d9                	mov    %bl,%cl
  801aa1:	d3 ed                	shr    %cl,%ebp
  801aa3:	89 e9                	mov    %ebp,%ecx
  801aa5:	09 f1                	or     %esi,%ecx
  801aa7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801aab:	89 f9                	mov    %edi,%ecx
  801aad:	d3 e0                	shl    %cl,%eax
  801aaf:	89 c5                	mov    %eax,%ebp
  801ab1:	89 d6                	mov    %edx,%esi
  801ab3:	88 d9                	mov    %bl,%cl
  801ab5:	d3 ee                	shr    %cl,%esi
  801ab7:	89 f9                	mov    %edi,%ecx
  801ab9:	d3 e2                	shl    %cl,%edx
  801abb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801abf:	88 d9                	mov    %bl,%cl
  801ac1:	d3 e8                	shr    %cl,%eax
  801ac3:	09 c2                	or     %eax,%edx
  801ac5:	89 d0                	mov    %edx,%eax
  801ac7:	89 f2                	mov    %esi,%edx
  801ac9:	f7 74 24 0c          	divl   0xc(%esp)
  801acd:	89 d6                	mov    %edx,%esi
  801acf:	89 c3                	mov    %eax,%ebx
  801ad1:	f7 e5                	mul    %ebp
  801ad3:	39 d6                	cmp    %edx,%esi
  801ad5:	72 19                	jb     801af0 <__udivdi3+0xfc>
  801ad7:	74 0b                	je     801ae4 <__udivdi3+0xf0>
  801ad9:	89 d8                	mov    %ebx,%eax
  801adb:	31 ff                	xor    %edi,%edi
  801add:	e9 58 ff ff ff       	jmp    801a3a <__udivdi3+0x46>
  801ae2:	66 90                	xchg   %ax,%ax
  801ae4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ae8:	89 f9                	mov    %edi,%ecx
  801aea:	d3 e2                	shl    %cl,%edx
  801aec:	39 c2                	cmp    %eax,%edx
  801aee:	73 e9                	jae    801ad9 <__udivdi3+0xe5>
  801af0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801af3:	31 ff                	xor    %edi,%edi
  801af5:	e9 40 ff ff ff       	jmp    801a3a <__udivdi3+0x46>
  801afa:	66 90                	xchg   %ax,%ax
  801afc:	31 c0                	xor    %eax,%eax
  801afe:	e9 37 ff ff ff       	jmp    801a3a <__udivdi3+0x46>
  801b03:	90                   	nop

00801b04 <__umoddi3>:
  801b04:	55                   	push   %ebp
  801b05:	57                   	push   %edi
  801b06:	56                   	push   %esi
  801b07:	53                   	push   %ebx
  801b08:	83 ec 1c             	sub    $0x1c,%esp
  801b0b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b0f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b17:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b1b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b1f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b23:	89 f3                	mov    %esi,%ebx
  801b25:	89 fa                	mov    %edi,%edx
  801b27:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b2b:	89 34 24             	mov    %esi,(%esp)
  801b2e:	85 c0                	test   %eax,%eax
  801b30:	75 1a                	jne    801b4c <__umoddi3+0x48>
  801b32:	39 f7                	cmp    %esi,%edi
  801b34:	0f 86 a2 00 00 00    	jbe    801bdc <__umoddi3+0xd8>
  801b3a:	89 c8                	mov    %ecx,%eax
  801b3c:	89 f2                	mov    %esi,%edx
  801b3e:	f7 f7                	div    %edi
  801b40:	89 d0                	mov    %edx,%eax
  801b42:	31 d2                	xor    %edx,%edx
  801b44:	83 c4 1c             	add    $0x1c,%esp
  801b47:	5b                   	pop    %ebx
  801b48:	5e                   	pop    %esi
  801b49:	5f                   	pop    %edi
  801b4a:	5d                   	pop    %ebp
  801b4b:	c3                   	ret    
  801b4c:	39 f0                	cmp    %esi,%eax
  801b4e:	0f 87 ac 00 00 00    	ja     801c00 <__umoddi3+0xfc>
  801b54:	0f bd e8             	bsr    %eax,%ebp
  801b57:	83 f5 1f             	xor    $0x1f,%ebp
  801b5a:	0f 84 ac 00 00 00    	je     801c0c <__umoddi3+0x108>
  801b60:	bf 20 00 00 00       	mov    $0x20,%edi
  801b65:	29 ef                	sub    %ebp,%edi
  801b67:	89 fe                	mov    %edi,%esi
  801b69:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b6d:	89 e9                	mov    %ebp,%ecx
  801b6f:	d3 e0                	shl    %cl,%eax
  801b71:	89 d7                	mov    %edx,%edi
  801b73:	89 f1                	mov    %esi,%ecx
  801b75:	d3 ef                	shr    %cl,%edi
  801b77:	09 c7                	or     %eax,%edi
  801b79:	89 e9                	mov    %ebp,%ecx
  801b7b:	d3 e2                	shl    %cl,%edx
  801b7d:	89 14 24             	mov    %edx,(%esp)
  801b80:	89 d8                	mov    %ebx,%eax
  801b82:	d3 e0                	shl    %cl,%eax
  801b84:	89 c2                	mov    %eax,%edx
  801b86:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b8a:	d3 e0                	shl    %cl,%eax
  801b8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b90:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b94:	89 f1                	mov    %esi,%ecx
  801b96:	d3 e8                	shr    %cl,%eax
  801b98:	09 d0                	or     %edx,%eax
  801b9a:	d3 eb                	shr    %cl,%ebx
  801b9c:	89 da                	mov    %ebx,%edx
  801b9e:	f7 f7                	div    %edi
  801ba0:	89 d3                	mov    %edx,%ebx
  801ba2:	f7 24 24             	mull   (%esp)
  801ba5:	89 c6                	mov    %eax,%esi
  801ba7:	89 d1                	mov    %edx,%ecx
  801ba9:	39 d3                	cmp    %edx,%ebx
  801bab:	0f 82 87 00 00 00    	jb     801c38 <__umoddi3+0x134>
  801bb1:	0f 84 91 00 00 00    	je     801c48 <__umoddi3+0x144>
  801bb7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bbb:	29 f2                	sub    %esi,%edx
  801bbd:	19 cb                	sbb    %ecx,%ebx
  801bbf:	89 d8                	mov    %ebx,%eax
  801bc1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bc5:	d3 e0                	shl    %cl,%eax
  801bc7:	89 e9                	mov    %ebp,%ecx
  801bc9:	d3 ea                	shr    %cl,%edx
  801bcb:	09 d0                	or     %edx,%eax
  801bcd:	89 e9                	mov    %ebp,%ecx
  801bcf:	d3 eb                	shr    %cl,%ebx
  801bd1:	89 da                	mov    %ebx,%edx
  801bd3:	83 c4 1c             	add    $0x1c,%esp
  801bd6:	5b                   	pop    %ebx
  801bd7:	5e                   	pop    %esi
  801bd8:	5f                   	pop    %edi
  801bd9:	5d                   	pop    %ebp
  801bda:	c3                   	ret    
  801bdb:	90                   	nop
  801bdc:	89 fd                	mov    %edi,%ebp
  801bde:	85 ff                	test   %edi,%edi
  801be0:	75 0b                	jne    801bed <__umoddi3+0xe9>
  801be2:	b8 01 00 00 00       	mov    $0x1,%eax
  801be7:	31 d2                	xor    %edx,%edx
  801be9:	f7 f7                	div    %edi
  801beb:	89 c5                	mov    %eax,%ebp
  801bed:	89 f0                	mov    %esi,%eax
  801bef:	31 d2                	xor    %edx,%edx
  801bf1:	f7 f5                	div    %ebp
  801bf3:	89 c8                	mov    %ecx,%eax
  801bf5:	f7 f5                	div    %ebp
  801bf7:	89 d0                	mov    %edx,%eax
  801bf9:	e9 44 ff ff ff       	jmp    801b42 <__umoddi3+0x3e>
  801bfe:	66 90                	xchg   %ax,%ax
  801c00:	89 c8                	mov    %ecx,%eax
  801c02:	89 f2                	mov    %esi,%edx
  801c04:	83 c4 1c             	add    $0x1c,%esp
  801c07:	5b                   	pop    %ebx
  801c08:	5e                   	pop    %esi
  801c09:	5f                   	pop    %edi
  801c0a:	5d                   	pop    %ebp
  801c0b:	c3                   	ret    
  801c0c:	3b 04 24             	cmp    (%esp),%eax
  801c0f:	72 06                	jb     801c17 <__umoddi3+0x113>
  801c11:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c15:	77 0f                	ja     801c26 <__umoddi3+0x122>
  801c17:	89 f2                	mov    %esi,%edx
  801c19:	29 f9                	sub    %edi,%ecx
  801c1b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c1f:	89 14 24             	mov    %edx,(%esp)
  801c22:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c26:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c2a:	8b 14 24             	mov    (%esp),%edx
  801c2d:	83 c4 1c             	add    $0x1c,%esp
  801c30:	5b                   	pop    %ebx
  801c31:	5e                   	pop    %esi
  801c32:	5f                   	pop    %edi
  801c33:	5d                   	pop    %ebp
  801c34:	c3                   	ret    
  801c35:	8d 76 00             	lea    0x0(%esi),%esi
  801c38:	2b 04 24             	sub    (%esp),%eax
  801c3b:	19 fa                	sbb    %edi,%edx
  801c3d:	89 d1                	mov    %edx,%ecx
  801c3f:	89 c6                	mov    %eax,%esi
  801c41:	e9 71 ff ff ff       	jmp    801bb7 <__umoddi3+0xb3>
  801c46:	66 90                	xchg   %ax,%ax
  801c48:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c4c:	72 ea                	jb     801c38 <__umoddi3+0x134>
  801c4e:	89 d9                	mov    %ebx,%ecx
  801c50:	e9 62 ff ff ff       	jmp    801bb7 <__umoddi3+0xb3>
