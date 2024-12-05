
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
  80003e:	e8 eb 15 00 00       	call   80162e <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct semaphore cs1 = create_semaphore("cs1", 1);
  800046:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	6a 01                	push   $0x1
  80004e:	68 60 1c 80 00       	push   $0x801c60
  800053:	50                   	push   %eax
  800054:	e8 2e 19 00 00       	call   801987 <create_semaphore>
  800059:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = create_semaphore("depend1", 0);
  80005c:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 00                	push   $0x0
  800064:	68 64 1c 80 00       	push   $0x801c64
  800069:	50                   	push   %eax
  80006a:	e8 18 19 00 00       	call   801987 <create_semaphore>
  80006f:	83 c4 0c             	add    $0xc,%esp

	int id1, id2, id3;
	id1 = sys_create_env("sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800072:	a1 04 30 80 00       	mov    0x803004,%eax
  800077:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  80007d:	a1 04 30 80 00       	mov    0x803004,%eax
  800082:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800088:	89 c1                	mov    %eax,%ecx
  80008a:	a1 04 30 80 00       	mov    0x803004,%eax
  80008f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800095:	52                   	push   %edx
  800096:	51                   	push   %ecx
  800097:	50                   	push   %eax
  800098:	68 6c 1c 80 00       	push   $0x801c6c
  80009d:	e8 37 15 00 00       	call   8015d9 <sys_create_env>
  8000a2:	83 c4 10             	add    $0x10,%esp
  8000a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	id2 = sys_create_env("sem1Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000a8:	a1 04 30 80 00       	mov    0x803004,%eax
  8000ad:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  8000b3:	a1 04 30 80 00       	mov    0x803004,%eax
  8000b8:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8000be:	89 c1                	mov    %eax,%ecx
  8000c0:	a1 04 30 80 00       	mov    0x803004,%eax
  8000c5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000cb:	52                   	push   %edx
  8000cc:	51                   	push   %ecx
  8000cd:	50                   	push   %eax
  8000ce:	68 6c 1c 80 00       	push   $0x801c6c
  8000d3:	e8 01 15 00 00       	call   8015d9 <sys_create_env>
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	89 45 ec             	mov    %eax,-0x14(%ebp)
	id3 = sys_create_env("sem1Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000de:	a1 04 30 80 00       	mov    0x803004,%eax
  8000e3:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  8000e9:	a1 04 30 80 00       	mov    0x803004,%eax
  8000ee:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8000f4:	89 c1                	mov    %eax,%ecx
  8000f6:	a1 04 30 80 00       	mov    0x803004,%eax
  8000fb:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800101:	52                   	push   %edx
  800102:	51                   	push   %ecx
  800103:	50                   	push   %eax
  800104:	68 6c 1c 80 00       	push   $0x801c6c
  800109:	e8 cb 14 00 00       	call   8015d9 <sys_create_env>
  80010e:	83 c4 10             	add    $0x10,%esp
  800111:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(id1);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	ff 75 f0             	pushl  -0x10(%ebp)
  80011a:	e8 d8 14 00 00       	call   8015f7 <sys_run_env>
  80011f:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	ff 75 ec             	pushl  -0x14(%ebp)
  800128:	e8 ca 14 00 00       	call   8015f7 <sys_run_env>
  80012d:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	ff 75 e8             	pushl  -0x18(%ebp)
  800136:	e8 bc 14 00 00       	call   8015f7 <sys_run_env>
  80013b:	83 c4 10             	add    $0x10,%esp

	wait_semaphore(depend1);
  80013e:	83 ec 0c             	sub    $0xc,%esp
  800141:	ff 75 d8             	pushl  -0x28(%ebp)
  800144:	e8 72 18 00 00       	call   8019bb <wait_semaphore>
  800149:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(depend1);
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	ff 75 d8             	pushl  -0x28(%ebp)
  800152:	e8 64 18 00 00       	call   8019bb <wait_semaphore>
  800157:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(depend1);
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	ff 75 d8             	pushl  -0x28(%ebp)
  800160:	e8 56 18 00 00       	call   8019bb <wait_semaphore>
  800165:	83 c4 10             	add    $0x10,%esp

	int sem1val = semaphore_count(cs1);
  800168:	83 ec 0c             	sub    $0xc,%esp
  80016b:	ff 75 dc             	pushl  -0x24(%ebp)
  80016e:	e8 7c 18 00 00       	call   8019ef <semaphore_count>
  800173:	83 c4 10             	add    $0x10,%esp
  800176:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int sem2val = semaphore_count(depend1);
  800179:	83 ec 0c             	sub    $0xc,%esp
  80017c:	ff 75 d8             	pushl  -0x28(%ebp)
  80017f:	e8 6b 18 00 00       	call   8019ef <semaphore_count>
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
  80019e:	e8 21 04 00 00       	call   8005c4 <cprintf>
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
  8001c1:	e8 41 01 00 00       	call   800307 <_panic>

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
  8001ce:	e8 74 14 00 00       	call   801647 <sys_getenvindex>
  8001d3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8001d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001d9:	89 d0                	mov    %edx,%eax
  8001db:	c1 e0 03             	shl    $0x3,%eax
  8001de:	01 d0                	add    %edx,%eax
  8001e0:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001e7:	01 c8                	add    %ecx,%eax
  8001e9:	01 c0                	add    %eax,%eax
  8001eb:	01 d0                	add    %edx,%eax
  8001ed:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001f4:	01 c8                	add    %ecx,%eax
  8001f6:	01 d0                	add    %edx,%eax
  8001f8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001fd:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800202:	a1 04 30 80 00       	mov    0x803004,%eax
  800207:	8a 40 20             	mov    0x20(%eax),%al
  80020a:	84 c0                	test   %al,%al
  80020c:	74 0d                	je     80021b <libmain+0x53>
		binaryname = myEnv->prog_name;
  80020e:	a1 04 30 80 00       	mov    0x803004,%eax
  800213:	83 c0 20             	add    $0x20,%eax
  800216:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80021b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80021f:	7e 0a                	jle    80022b <libmain+0x63>
		binaryname = argv[0];
  800221:	8b 45 0c             	mov    0xc(%ebp),%eax
  800224:	8b 00                	mov    (%eax),%eax
  800226:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80022b:	83 ec 08             	sub    $0x8,%esp
  80022e:	ff 75 0c             	pushl  0xc(%ebp)
  800231:	ff 75 08             	pushl  0x8(%ebp)
  800234:	e8 ff fd ff ff       	call   800038 <_main>
  800239:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80023c:	e8 8a 11 00 00       	call   8013cb <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	68 64 1d 80 00       	push   $0x801d64
  800249:	e8 76 03 00 00       	call   8005c4 <cprintf>
  80024e:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800251:	a1 04 30 80 00       	mov    0x803004,%eax
  800256:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80025c:	a1 04 30 80 00       	mov    0x803004,%eax
  800261:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	52                   	push   %edx
  80026b:	50                   	push   %eax
  80026c:	68 8c 1d 80 00       	push   $0x801d8c
  800271:	e8 4e 03 00 00       	call   8005c4 <cprintf>
  800276:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800279:	a1 04 30 80 00       	mov    0x803004,%eax
  80027e:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800284:	a1 04 30 80 00       	mov    0x803004,%eax
  800289:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80028f:	a1 04 30 80 00       	mov    0x803004,%eax
  800294:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80029a:	51                   	push   %ecx
  80029b:	52                   	push   %edx
  80029c:	50                   	push   %eax
  80029d:	68 b4 1d 80 00       	push   $0x801db4
  8002a2:	e8 1d 03 00 00       	call   8005c4 <cprintf>
  8002a7:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002aa:	a1 04 30 80 00       	mov    0x803004,%eax
  8002af:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8002b5:	83 ec 08             	sub    $0x8,%esp
  8002b8:	50                   	push   %eax
  8002b9:	68 0c 1e 80 00       	push   $0x801e0c
  8002be:	e8 01 03 00 00       	call   8005c4 <cprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002c6:	83 ec 0c             	sub    $0xc,%esp
  8002c9:	68 64 1d 80 00       	push   $0x801d64
  8002ce:	e8 f1 02 00 00       	call   8005c4 <cprintf>
  8002d3:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8002d6:	e8 0a 11 00 00       	call   8013e5 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8002db:	e8 19 00 00 00       	call   8002f9 <exit>
}
  8002e0:	90                   	nop
  8002e1:	c9                   	leave  
  8002e2:	c3                   	ret    

008002e3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002e9:	83 ec 0c             	sub    $0xc,%esp
  8002ec:	6a 00                	push   $0x0
  8002ee:	e8 20 13 00 00       	call   801613 <sys_destroy_env>
  8002f3:	83 c4 10             	add    $0x10,%esp
}
  8002f6:	90                   	nop
  8002f7:	c9                   	leave  
  8002f8:	c3                   	ret    

008002f9 <exit>:

void
exit(void)
{
  8002f9:	55                   	push   %ebp
  8002fa:	89 e5                	mov    %esp,%ebp
  8002fc:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002ff:	e8 75 13 00 00       	call   801679 <sys_exit_env>
}
  800304:	90                   	nop
  800305:	c9                   	leave  
  800306:	c3                   	ret    

00800307 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80030d:	8d 45 10             	lea    0x10(%ebp),%eax
  800310:	83 c0 04             	add    $0x4,%eax
  800313:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800316:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80031b:	85 c0                	test   %eax,%eax
  80031d:	74 16                	je     800335 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80031f:	a1 2c 30 80 00       	mov    0x80302c,%eax
  800324:	83 ec 08             	sub    $0x8,%esp
  800327:	50                   	push   %eax
  800328:	68 20 1e 80 00       	push   $0x801e20
  80032d:	e8 92 02 00 00       	call   8005c4 <cprintf>
  800332:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800335:	a1 00 30 80 00       	mov    0x803000,%eax
  80033a:	ff 75 0c             	pushl  0xc(%ebp)
  80033d:	ff 75 08             	pushl  0x8(%ebp)
  800340:	50                   	push   %eax
  800341:	68 25 1e 80 00       	push   $0x801e25
  800346:	e8 79 02 00 00       	call   8005c4 <cprintf>
  80034b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80034e:	8b 45 10             	mov    0x10(%ebp),%eax
  800351:	83 ec 08             	sub    $0x8,%esp
  800354:	ff 75 f4             	pushl  -0xc(%ebp)
  800357:	50                   	push   %eax
  800358:	e8 fc 01 00 00       	call   800559 <vcprintf>
  80035d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800360:	83 ec 08             	sub    $0x8,%esp
  800363:	6a 00                	push   $0x0
  800365:	68 41 1e 80 00       	push   $0x801e41
  80036a:	e8 ea 01 00 00       	call   800559 <vcprintf>
  80036f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800372:	e8 82 ff ff ff       	call   8002f9 <exit>

	// should not return here
	while (1) ;
  800377:	eb fe                	jmp    800377 <_panic+0x70>

00800379 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800379:	55                   	push   %ebp
  80037a:	89 e5                	mov    %esp,%ebp
  80037c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80037f:	a1 04 30 80 00       	mov    0x803004,%eax
  800384:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80038a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038d:	39 c2                	cmp    %eax,%edx
  80038f:	74 14                	je     8003a5 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800391:	83 ec 04             	sub    $0x4,%esp
  800394:	68 44 1e 80 00       	push   $0x801e44
  800399:	6a 26                	push   $0x26
  80039b:	68 90 1e 80 00       	push   $0x801e90
  8003a0:	e8 62 ff ff ff       	call   800307 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003b3:	e9 c5 00 00 00       	jmp    80047d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c5:	01 d0                	add    %edx,%eax
  8003c7:	8b 00                	mov    (%eax),%eax
  8003c9:	85 c0                	test   %eax,%eax
  8003cb:	75 08                	jne    8003d5 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003cd:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003d0:	e9 a5 00 00 00       	jmp    80047a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003d5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003dc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003e3:	eb 69                	jmp    80044e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003e5:	a1 04 30 80 00       	mov    0x803004,%eax
  8003ea:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8003f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003f3:	89 d0                	mov    %edx,%eax
  8003f5:	01 c0                	add    %eax,%eax
  8003f7:	01 d0                	add    %edx,%eax
  8003f9:	c1 e0 03             	shl    $0x3,%eax
  8003fc:	01 c8                	add    %ecx,%eax
  8003fe:	8a 40 04             	mov    0x4(%eax),%al
  800401:	84 c0                	test   %al,%al
  800403:	75 46                	jne    80044b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800405:	a1 04 30 80 00       	mov    0x803004,%eax
  80040a:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800410:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800413:	89 d0                	mov    %edx,%eax
  800415:	01 c0                	add    %eax,%eax
  800417:	01 d0                	add    %edx,%eax
  800419:	c1 e0 03             	shl    $0x3,%eax
  80041c:	01 c8                	add    %ecx,%eax
  80041e:	8b 00                	mov    (%eax),%eax
  800420:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800423:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800426:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80042b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80042d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800430:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800437:	8b 45 08             	mov    0x8(%ebp),%eax
  80043a:	01 c8                	add    %ecx,%eax
  80043c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80043e:	39 c2                	cmp    %eax,%edx
  800440:	75 09                	jne    80044b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800442:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800449:	eb 15                	jmp    800460 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80044b:	ff 45 e8             	incl   -0x18(%ebp)
  80044e:	a1 04 30 80 00       	mov    0x803004,%eax
  800453:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800459:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80045c:	39 c2                	cmp    %eax,%edx
  80045e:	77 85                	ja     8003e5 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800460:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800464:	75 14                	jne    80047a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800466:	83 ec 04             	sub    $0x4,%esp
  800469:	68 9c 1e 80 00       	push   $0x801e9c
  80046e:	6a 3a                	push   $0x3a
  800470:	68 90 1e 80 00       	push   $0x801e90
  800475:	e8 8d fe ff ff       	call   800307 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80047a:	ff 45 f0             	incl   -0x10(%ebp)
  80047d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800480:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800483:	0f 8c 2f ff ff ff    	jl     8003b8 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800489:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800490:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800497:	eb 26                	jmp    8004bf <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800499:	a1 04 30 80 00       	mov    0x803004,%eax
  80049e:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8004a4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004a7:	89 d0                	mov    %edx,%eax
  8004a9:	01 c0                	add    %eax,%eax
  8004ab:	01 d0                	add    %edx,%eax
  8004ad:	c1 e0 03             	shl    $0x3,%eax
  8004b0:	01 c8                	add    %ecx,%eax
  8004b2:	8a 40 04             	mov    0x4(%eax),%al
  8004b5:	3c 01                	cmp    $0x1,%al
  8004b7:	75 03                	jne    8004bc <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004b9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004bc:	ff 45 e0             	incl   -0x20(%ebp)
  8004bf:	a1 04 30 80 00       	mov    0x803004,%eax
  8004c4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8004ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004cd:	39 c2                	cmp    %eax,%edx
  8004cf:	77 c8                	ja     800499 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004d4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004d7:	74 14                	je     8004ed <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004d9:	83 ec 04             	sub    $0x4,%esp
  8004dc:	68 f0 1e 80 00       	push   $0x801ef0
  8004e1:	6a 44                	push   $0x44
  8004e3:	68 90 1e 80 00       	push   $0x801e90
  8004e8:	e8 1a fe ff ff       	call   800307 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004ed:	90                   	nop
  8004ee:	c9                   	leave  
  8004ef:	c3                   	ret    

008004f0 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f9:	8b 00                	mov    (%eax),%eax
  8004fb:	8d 48 01             	lea    0x1(%eax),%ecx
  8004fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800501:	89 0a                	mov    %ecx,(%edx)
  800503:	8b 55 08             	mov    0x8(%ebp),%edx
  800506:	88 d1                	mov    %dl,%cl
  800508:	8b 55 0c             	mov    0xc(%ebp),%edx
  80050b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80050f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800512:	8b 00                	mov    (%eax),%eax
  800514:	3d ff 00 00 00       	cmp    $0xff,%eax
  800519:	75 2c                	jne    800547 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80051b:	a0 08 30 80 00       	mov    0x803008,%al
  800520:	0f b6 c0             	movzbl %al,%eax
  800523:	8b 55 0c             	mov    0xc(%ebp),%edx
  800526:	8b 12                	mov    (%edx),%edx
  800528:	89 d1                	mov    %edx,%ecx
  80052a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80052d:	83 c2 08             	add    $0x8,%edx
  800530:	83 ec 04             	sub    $0x4,%esp
  800533:	50                   	push   %eax
  800534:	51                   	push   %ecx
  800535:	52                   	push   %edx
  800536:	e8 4e 0e 00 00       	call   801389 <sys_cputs>
  80053b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80053e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800541:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800547:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054a:	8b 40 04             	mov    0x4(%eax),%eax
  80054d:	8d 50 01             	lea    0x1(%eax),%edx
  800550:	8b 45 0c             	mov    0xc(%ebp),%eax
  800553:	89 50 04             	mov    %edx,0x4(%eax)
}
  800556:	90                   	nop
  800557:	c9                   	leave  
  800558:	c3                   	ret    

00800559 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800559:	55                   	push   %ebp
  80055a:	89 e5                	mov    %esp,%ebp
  80055c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800562:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800569:	00 00 00 
	b.cnt = 0;
  80056c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800573:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800576:	ff 75 0c             	pushl  0xc(%ebp)
  800579:	ff 75 08             	pushl  0x8(%ebp)
  80057c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800582:	50                   	push   %eax
  800583:	68 f0 04 80 00       	push   $0x8004f0
  800588:	e8 11 02 00 00       	call   80079e <vprintfmt>
  80058d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800590:	a0 08 30 80 00       	mov    0x803008,%al
  800595:	0f b6 c0             	movzbl %al,%eax
  800598:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80059e:	83 ec 04             	sub    $0x4,%esp
  8005a1:	50                   	push   %eax
  8005a2:	52                   	push   %edx
  8005a3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a9:	83 c0 08             	add    $0x8,%eax
  8005ac:	50                   	push   %eax
  8005ad:	e8 d7 0d 00 00       	call   801389 <sys_cputs>
  8005b2:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005b5:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8005bc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005c2:	c9                   	leave  
  8005c3:	c3                   	ret    

008005c4 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005c4:	55                   	push   %ebp
  8005c5:	89 e5                	mov    %esp,%ebp
  8005c7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005ca:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8005d1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005da:	83 ec 08             	sub    $0x8,%esp
  8005dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e0:	50                   	push   %eax
  8005e1:	e8 73 ff ff ff       	call   800559 <vcprintf>
  8005e6:	83 c4 10             	add    $0x10,%esp
  8005e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005ef:	c9                   	leave  
  8005f0:	c3                   	ret    

008005f1 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005f1:	55                   	push   %ebp
  8005f2:	89 e5                	mov    %esp,%ebp
  8005f4:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8005f7:	e8 cf 0d 00 00       	call   8013cb <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005fc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800602:	8b 45 08             	mov    0x8(%ebp),%eax
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	ff 75 f4             	pushl  -0xc(%ebp)
  80060b:	50                   	push   %eax
  80060c:	e8 48 ff ff ff       	call   800559 <vcprintf>
  800611:	83 c4 10             	add    $0x10,%esp
  800614:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800617:	e8 c9 0d 00 00       	call   8013e5 <sys_unlock_cons>
	return cnt;
  80061c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80061f:	c9                   	leave  
  800620:	c3                   	ret    

00800621 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800621:	55                   	push   %ebp
  800622:	89 e5                	mov    %esp,%ebp
  800624:	53                   	push   %ebx
  800625:	83 ec 14             	sub    $0x14,%esp
  800628:	8b 45 10             	mov    0x10(%ebp),%eax
  80062b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800634:	8b 45 18             	mov    0x18(%ebp),%eax
  800637:	ba 00 00 00 00       	mov    $0x0,%edx
  80063c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80063f:	77 55                	ja     800696 <printnum+0x75>
  800641:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800644:	72 05                	jb     80064b <printnum+0x2a>
  800646:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800649:	77 4b                	ja     800696 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80064b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80064e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800651:	8b 45 18             	mov    0x18(%ebp),%eax
  800654:	ba 00 00 00 00       	mov    $0x0,%edx
  800659:	52                   	push   %edx
  80065a:	50                   	push   %eax
  80065b:	ff 75 f4             	pushl  -0xc(%ebp)
  80065e:	ff 75 f0             	pushl  -0x10(%ebp)
  800661:	e8 96 13 00 00       	call   8019fc <__udivdi3>
  800666:	83 c4 10             	add    $0x10,%esp
  800669:	83 ec 04             	sub    $0x4,%esp
  80066c:	ff 75 20             	pushl  0x20(%ebp)
  80066f:	53                   	push   %ebx
  800670:	ff 75 18             	pushl  0x18(%ebp)
  800673:	52                   	push   %edx
  800674:	50                   	push   %eax
  800675:	ff 75 0c             	pushl  0xc(%ebp)
  800678:	ff 75 08             	pushl  0x8(%ebp)
  80067b:	e8 a1 ff ff ff       	call   800621 <printnum>
  800680:	83 c4 20             	add    $0x20,%esp
  800683:	eb 1a                	jmp    80069f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800685:	83 ec 08             	sub    $0x8,%esp
  800688:	ff 75 0c             	pushl  0xc(%ebp)
  80068b:	ff 75 20             	pushl  0x20(%ebp)
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	ff d0                	call   *%eax
  800693:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800696:	ff 4d 1c             	decl   0x1c(%ebp)
  800699:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80069d:	7f e6                	jg     800685 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80069f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006ad:	53                   	push   %ebx
  8006ae:	51                   	push   %ecx
  8006af:	52                   	push   %edx
  8006b0:	50                   	push   %eax
  8006b1:	e8 56 14 00 00       	call   801b0c <__umoddi3>
  8006b6:	83 c4 10             	add    $0x10,%esp
  8006b9:	05 54 21 80 00       	add    $0x802154,%eax
  8006be:	8a 00                	mov    (%eax),%al
  8006c0:	0f be c0             	movsbl %al,%eax
  8006c3:	83 ec 08             	sub    $0x8,%esp
  8006c6:	ff 75 0c             	pushl  0xc(%ebp)
  8006c9:	50                   	push   %eax
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	ff d0                	call   *%eax
  8006cf:	83 c4 10             	add    $0x10,%esp
}
  8006d2:	90                   	nop
  8006d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006d6:	c9                   	leave  
  8006d7:	c3                   	ret    

008006d8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006d8:	55                   	push   %ebp
  8006d9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006db:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006df:	7e 1c                	jle    8006fd <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	8d 50 08             	lea    0x8(%eax),%edx
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	89 10                	mov    %edx,(%eax)
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	83 e8 08             	sub    $0x8,%eax
  8006f6:	8b 50 04             	mov    0x4(%eax),%edx
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	eb 40                	jmp    80073d <getuint+0x65>
	else if (lflag)
  8006fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800701:	74 1e                	je     800721 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	8b 00                	mov    (%eax),%eax
  800708:	8d 50 04             	lea    0x4(%eax),%edx
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	89 10                	mov    %edx,(%eax)
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	8b 00                	mov    (%eax),%eax
  800715:	83 e8 04             	sub    $0x4,%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	ba 00 00 00 00       	mov    $0x0,%edx
  80071f:	eb 1c                	jmp    80073d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	8d 50 04             	lea    0x4(%eax),%edx
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	89 10                	mov    %edx,(%eax)
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	8b 00                	mov    (%eax),%eax
  800733:	83 e8 04             	sub    $0x4,%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80073d:	5d                   	pop    %ebp
  80073e:	c3                   	ret    

0080073f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80073f:	55                   	push   %ebp
  800740:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800742:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800746:	7e 1c                	jle    800764 <getint+0x25>
		return va_arg(*ap, long long);
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	8b 00                	mov    (%eax),%eax
  80074d:	8d 50 08             	lea    0x8(%eax),%edx
  800750:	8b 45 08             	mov    0x8(%ebp),%eax
  800753:	89 10                	mov    %edx,(%eax)
  800755:	8b 45 08             	mov    0x8(%ebp),%eax
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	83 e8 08             	sub    $0x8,%eax
  80075d:	8b 50 04             	mov    0x4(%eax),%edx
  800760:	8b 00                	mov    (%eax),%eax
  800762:	eb 38                	jmp    80079c <getint+0x5d>
	else if (lflag)
  800764:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800768:	74 1a                	je     800784 <getint+0x45>
		return va_arg(*ap, long);
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	8d 50 04             	lea    0x4(%eax),%edx
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	89 10                	mov    %edx,(%eax)
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	8b 00                	mov    (%eax),%eax
  80077c:	83 e8 04             	sub    $0x4,%eax
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	99                   	cltd   
  800782:	eb 18                	jmp    80079c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800784:	8b 45 08             	mov    0x8(%ebp),%eax
  800787:	8b 00                	mov    (%eax),%eax
  800789:	8d 50 04             	lea    0x4(%eax),%edx
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	89 10                	mov    %edx,(%eax)
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	8b 00                	mov    (%eax),%eax
  800796:	83 e8 04             	sub    $0x4,%eax
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	99                   	cltd   
}
  80079c:	5d                   	pop    %ebp
  80079d:	c3                   	ret    

0080079e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80079e:	55                   	push   %ebp
  80079f:	89 e5                	mov    %esp,%ebp
  8007a1:	56                   	push   %esi
  8007a2:	53                   	push   %ebx
  8007a3:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007a6:	eb 17                	jmp    8007bf <vprintfmt+0x21>
			if (ch == '\0')
  8007a8:	85 db                	test   %ebx,%ebx
  8007aa:	0f 84 c1 03 00 00    	je     800b71 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007b0:	83 ec 08             	sub    $0x8,%esp
  8007b3:	ff 75 0c             	pushl  0xc(%ebp)
  8007b6:	53                   	push   %ebx
  8007b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ba:	ff d0                	call   *%eax
  8007bc:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c2:	8d 50 01             	lea    0x1(%eax),%edx
  8007c5:	89 55 10             	mov    %edx,0x10(%ebp)
  8007c8:	8a 00                	mov    (%eax),%al
  8007ca:	0f b6 d8             	movzbl %al,%ebx
  8007cd:	83 fb 25             	cmp    $0x25,%ebx
  8007d0:	75 d6                	jne    8007a8 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007d2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007d6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007dd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007e4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007eb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f5:	8d 50 01             	lea    0x1(%eax),%edx
  8007f8:	89 55 10             	mov    %edx,0x10(%ebp)
  8007fb:	8a 00                	mov    (%eax),%al
  8007fd:	0f b6 d8             	movzbl %al,%ebx
  800800:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800803:	83 f8 5b             	cmp    $0x5b,%eax
  800806:	0f 87 3d 03 00 00    	ja     800b49 <vprintfmt+0x3ab>
  80080c:	8b 04 85 78 21 80 00 	mov    0x802178(,%eax,4),%eax
  800813:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800815:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800819:	eb d7                	jmp    8007f2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80081b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80081f:	eb d1                	jmp    8007f2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800821:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800828:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80082b:	89 d0                	mov    %edx,%eax
  80082d:	c1 e0 02             	shl    $0x2,%eax
  800830:	01 d0                	add    %edx,%eax
  800832:	01 c0                	add    %eax,%eax
  800834:	01 d8                	add    %ebx,%eax
  800836:	83 e8 30             	sub    $0x30,%eax
  800839:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80083c:	8b 45 10             	mov    0x10(%ebp),%eax
  80083f:	8a 00                	mov    (%eax),%al
  800841:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800844:	83 fb 2f             	cmp    $0x2f,%ebx
  800847:	7e 3e                	jle    800887 <vprintfmt+0xe9>
  800849:	83 fb 39             	cmp    $0x39,%ebx
  80084c:	7f 39                	jg     800887 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80084e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800851:	eb d5                	jmp    800828 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800853:	8b 45 14             	mov    0x14(%ebp),%eax
  800856:	83 c0 04             	add    $0x4,%eax
  800859:	89 45 14             	mov    %eax,0x14(%ebp)
  80085c:	8b 45 14             	mov    0x14(%ebp),%eax
  80085f:	83 e8 04             	sub    $0x4,%eax
  800862:	8b 00                	mov    (%eax),%eax
  800864:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800867:	eb 1f                	jmp    800888 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800869:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80086d:	79 83                	jns    8007f2 <vprintfmt+0x54>
				width = 0;
  80086f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800876:	e9 77 ff ff ff       	jmp    8007f2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80087b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800882:	e9 6b ff ff ff       	jmp    8007f2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800887:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800888:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80088c:	0f 89 60 ff ff ff    	jns    8007f2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800892:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800895:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800898:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80089f:	e9 4e ff ff ff       	jmp    8007f2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008a4:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008a7:	e9 46 ff ff ff       	jmp    8007f2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8008af:	83 c0 04             	add    $0x4,%eax
  8008b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b8:	83 e8 04             	sub    $0x4,%eax
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	83 ec 08             	sub    $0x8,%esp
  8008c0:	ff 75 0c             	pushl  0xc(%ebp)
  8008c3:	50                   	push   %eax
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	ff d0                	call   *%eax
  8008c9:	83 c4 10             	add    $0x10,%esp
			break;
  8008cc:	e9 9b 02 00 00       	jmp    800b6c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d4:	83 c0 04             	add    $0x4,%eax
  8008d7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008da:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dd:	83 e8 04             	sub    $0x4,%eax
  8008e0:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008e2:	85 db                	test   %ebx,%ebx
  8008e4:	79 02                	jns    8008e8 <vprintfmt+0x14a>
				err = -err;
  8008e6:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008e8:	83 fb 64             	cmp    $0x64,%ebx
  8008eb:	7f 0b                	jg     8008f8 <vprintfmt+0x15a>
  8008ed:	8b 34 9d c0 1f 80 00 	mov    0x801fc0(,%ebx,4),%esi
  8008f4:	85 f6                	test   %esi,%esi
  8008f6:	75 19                	jne    800911 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008f8:	53                   	push   %ebx
  8008f9:	68 65 21 80 00       	push   $0x802165
  8008fe:	ff 75 0c             	pushl  0xc(%ebp)
  800901:	ff 75 08             	pushl  0x8(%ebp)
  800904:	e8 70 02 00 00       	call   800b79 <printfmt>
  800909:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80090c:	e9 5b 02 00 00       	jmp    800b6c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800911:	56                   	push   %esi
  800912:	68 6e 21 80 00       	push   $0x80216e
  800917:	ff 75 0c             	pushl  0xc(%ebp)
  80091a:	ff 75 08             	pushl  0x8(%ebp)
  80091d:	e8 57 02 00 00       	call   800b79 <printfmt>
  800922:	83 c4 10             	add    $0x10,%esp
			break;
  800925:	e9 42 02 00 00       	jmp    800b6c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80092a:	8b 45 14             	mov    0x14(%ebp),%eax
  80092d:	83 c0 04             	add    $0x4,%eax
  800930:	89 45 14             	mov    %eax,0x14(%ebp)
  800933:	8b 45 14             	mov    0x14(%ebp),%eax
  800936:	83 e8 04             	sub    $0x4,%eax
  800939:	8b 30                	mov    (%eax),%esi
  80093b:	85 f6                	test   %esi,%esi
  80093d:	75 05                	jne    800944 <vprintfmt+0x1a6>
				p = "(null)";
  80093f:	be 71 21 80 00       	mov    $0x802171,%esi
			if (width > 0 && padc != '-')
  800944:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800948:	7e 6d                	jle    8009b7 <vprintfmt+0x219>
  80094a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80094e:	74 67                	je     8009b7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800950:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800953:	83 ec 08             	sub    $0x8,%esp
  800956:	50                   	push   %eax
  800957:	56                   	push   %esi
  800958:	e8 1e 03 00 00       	call   800c7b <strnlen>
  80095d:	83 c4 10             	add    $0x10,%esp
  800960:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800963:	eb 16                	jmp    80097b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800965:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800969:	83 ec 08             	sub    $0x8,%esp
  80096c:	ff 75 0c             	pushl  0xc(%ebp)
  80096f:	50                   	push   %eax
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	ff d0                	call   *%eax
  800975:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800978:	ff 4d e4             	decl   -0x1c(%ebp)
  80097b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80097f:	7f e4                	jg     800965 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800981:	eb 34                	jmp    8009b7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800983:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800987:	74 1c                	je     8009a5 <vprintfmt+0x207>
  800989:	83 fb 1f             	cmp    $0x1f,%ebx
  80098c:	7e 05                	jle    800993 <vprintfmt+0x1f5>
  80098e:	83 fb 7e             	cmp    $0x7e,%ebx
  800991:	7e 12                	jle    8009a5 <vprintfmt+0x207>
					putch('?', putdat);
  800993:	83 ec 08             	sub    $0x8,%esp
  800996:	ff 75 0c             	pushl  0xc(%ebp)
  800999:	6a 3f                	push   $0x3f
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	ff d0                	call   *%eax
  8009a0:	83 c4 10             	add    $0x10,%esp
  8009a3:	eb 0f                	jmp    8009b4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009a5:	83 ec 08             	sub    $0x8,%esp
  8009a8:	ff 75 0c             	pushl  0xc(%ebp)
  8009ab:	53                   	push   %ebx
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	ff d0                	call   *%eax
  8009b1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b4:	ff 4d e4             	decl   -0x1c(%ebp)
  8009b7:	89 f0                	mov    %esi,%eax
  8009b9:	8d 70 01             	lea    0x1(%eax),%esi
  8009bc:	8a 00                	mov    (%eax),%al
  8009be:	0f be d8             	movsbl %al,%ebx
  8009c1:	85 db                	test   %ebx,%ebx
  8009c3:	74 24                	je     8009e9 <vprintfmt+0x24b>
  8009c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009c9:	78 b8                	js     800983 <vprintfmt+0x1e5>
  8009cb:	ff 4d e0             	decl   -0x20(%ebp)
  8009ce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009d2:	79 af                	jns    800983 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009d4:	eb 13                	jmp    8009e9 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 0c             	pushl  0xc(%ebp)
  8009dc:	6a 20                	push   $0x20
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	ff d0                	call   *%eax
  8009e3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009e6:	ff 4d e4             	decl   -0x1c(%ebp)
  8009e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ed:	7f e7                	jg     8009d6 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009ef:	e9 78 01 00 00       	jmp    800b6c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009f4:	83 ec 08             	sub    $0x8,%esp
  8009f7:	ff 75 e8             	pushl  -0x18(%ebp)
  8009fa:	8d 45 14             	lea    0x14(%ebp),%eax
  8009fd:	50                   	push   %eax
  8009fe:	e8 3c fd ff ff       	call   80073f <getint>
  800a03:	83 c4 10             	add    $0x10,%esp
  800a06:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a09:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a12:	85 d2                	test   %edx,%edx
  800a14:	79 23                	jns    800a39 <vprintfmt+0x29b>
				putch('-', putdat);
  800a16:	83 ec 08             	sub    $0x8,%esp
  800a19:	ff 75 0c             	pushl  0xc(%ebp)
  800a1c:	6a 2d                	push   $0x2d
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	ff d0                	call   *%eax
  800a23:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a2c:	f7 d8                	neg    %eax
  800a2e:	83 d2 00             	adc    $0x0,%edx
  800a31:	f7 da                	neg    %edx
  800a33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a36:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a39:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a40:	e9 bc 00 00 00       	jmp    800b01 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a45:	83 ec 08             	sub    $0x8,%esp
  800a48:	ff 75 e8             	pushl  -0x18(%ebp)
  800a4b:	8d 45 14             	lea    0x14(%ebp),%eax
  800a4e:	50                   	push   %eax
  800a4f:	e8 84 fc ff ff       	call   8006d8 <getuint>
  800a54:	83 c4 10             	add    $0x10,%esp
  800a57:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a5d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a64:	e9 98 00 00 00       	jmp    800b01 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a69:	83 ec 08             	sub    $0x8,%esp
  800a6c:	ff 75 0c             	pushl  0xc(%ebp)
  800a6f:	6a 58                	push   $0x58
  800a71:	8b 45 08             	mov    0x8(%ebp),%eax
  800a74:	ff d0                	call   *%eax
  800a76:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a79:	83 ec 08             	sub    $0x8,%esp
  800a7c:	ff 75 0c             	pushl  0xc(%ebp)
  800a7f:	6a 58                	push   $0x58
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	ff d0                	call   *%eax
  800a86:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a89:	83 ec 08             	sub    $0x8,%esp
  800a8c:	ff 75 0c             	pushl  0xc(%ebp)
  800a8f:	6a 58                	push   $0x58
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	ff d0                	call   *%eax
  800a96:	83 c4 10             	add    $0x10,%esp
			break;
  800a99:	e9 ce 00 00 00       	jmp    800b6c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	6a 30                	push   $0x30
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800aae:	83 ec 08             	sub    $0x8,%esp
  800ab1:	ff 75 0c             	pushl  0xc(%ebp)
  800ab4:	6a 78                	push   $0x78
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	ff d0                	call   *%eax
  800abb:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800abe:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac1:	83 c0 04             	add    $0x4,%eax
  800ac4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aca:	83 e8 04             	sub    $0x4,%eax
  800acd:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800acf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ad9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ae0:	eb 1f                	jmp    800b01 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ae2:	83 ec 08             	sub    $0x8,%esp
  800ae5:	ff 75 e8             	pushl  -0x18(%ebp)
  800ae8:	8d 45 14             	lea    0x14(%ebp),%eax
  800aeb:	50                   	push   %eax
  800aec:	e8 e7 fb ff ff       	call   8006d8 <getuint>
  800af1:	83 c4 10             	add    $0x10,%esp
  800af4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800afa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b01:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b08:	83 ec 04             	sub    $0x4,%esp
  800b0b:	52                   	push   %edx
  800b0c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b0f:	50                   	push   %eax
  800b10:	ff 75 f4             	pushl  -0xc(%ebp)
  800b13:	ff 75 f0             	pushl  -0x10(%ebp)
  800b16:	ff 75 0c             	pushl  0xc(%ebp)
  800b19:	ff 75 08             	pushl  0x8(%ebp)
  800b1c:	e8 00 fb ff ff       	call   800621 <printnum>
  800b21:	83 c4 20             	add    $0x20,%esp
			break;
  800b24:	eb 46                	jmp    800b6c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b26:	83 ec 08             	sub    $0x8,%esp
  800b29:	ff 75 0c             	pushl  0xc(%ebp)
  800b2c:	53                   	push   %ebx
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	ff d0                	call   *%eax
  800b32:	83 c4 10             	add    $0x10,%esp
			break;
  800b35:	eb 35                	jmp    800b6c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b37:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800b3e:	eb 2c                	jmp    800b6c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b40:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800b47:	eb 23                	jmp    800b6c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b49:	83 ec 08             	sub    $0x8,%esp
  800b4c:	ff 75 0c             	pushl  0xc(%ebp)
  800b4f:	6a 25                	push   $0x25
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	ff d0                	call   *%eax
  800b56:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b59:	ff 4d 10             	decl   0x10(%ebp)
  800b5c:	eb 03                	jmp    800b61 <vprintfmt+0x3c3>
  800b5e:	ff 4d 10             	decl   0x10(%ebp)
  800b61:	8b 45 10             	mov    0x10(%ebp),%eax
  800b64:	48                   	dec    %eax
  800b65:	8a 00                	mov    (%eax),%al
  800b67:	3c 25                	cmp    $0x25,%al
  800b69:	75 f3                	jne    800b5e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b6b:	90                   	nop
		}
	}
  800b6c:	e9 35 fc ff ff       	jmp    8007a6 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b71:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b72:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b75:	5b                   	pop    %ebx
  800b76:	5e                   	pop    %esi
  800b77:	5d                   	pop    %ebp
  800b78:	c3                   	ret    

00800b79 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
  800b7c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b7f:	8d 45 10             	lea    0x10(%ebp),%eax
  800b82:	83 c0 04             	add    $0x4,%eax
  800b85:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b88:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b8e:	50                   	push   %eax
  800b8f:	ff 75 0c             	pushl  0xc(%ebp)
  800b92:	ff 75 08             	pushl  0x8(%ebp)
  800b95:	e8 04 fc ff ff       	call   80079e <vprintfmt>
  800b9a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b9d:	90                   	nop
  800b9e:	c9                   	leave  
  800b9f:	c3                   	ret    

00800ba0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ba3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba6:	8b 40 08             	mov    0x8(%eax),%eax
  800ba9:	8d 50 01             	lea    0x1(%eax),%edx
  800bac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baf:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb5:	8b 10                	mov    (%eax),%edx
  800bb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bba:	8b 40 04             	mov    0x4(%eax),%eax
  800bbd:	39 c2                	cmp    %eax,%edx
  800bbf:	73 12                	jae    800bd3 <sprintputch+0x33>
		*b->buf++ = ch;
  800bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc4:	8b 00                	mov    (%eax),%eax
  800bc6:	8d 48 01             	lea    0x1(%eax),%ecx
  800bc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bcc:	89 0a                	mov    %ecx,(%edx)
  800bce:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd1:	88 10                	mov    %dl,(%eax)
}
  800bd3:	90                   	nop
  800bd4:	5d                   	pop    %ebp
  800bd5:	c3                   	ret    

00800bd6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bd6:	55                   	push   %ebp
  800bd7:	89 e5                	mov    %esp,%ebp
  800bd9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800be2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	01 d0                	add    %edx,%eax
  800bed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bf7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bfb:	74 06                	je     800c03 <vsnprintf+0x2d>
  800bfd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c01:	7f 07                	jg     800c0a <vsnprintf+0x34>
		return -E_INVAL;
  800c03:	b8 03 00 00 00       	mov    $0x3,%eax
  800c08:	eb 20                	jmp    800c2a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c0a:	ff 75 14             	pushl  0x14(%ebp)
  800c0d:	ff 75 10             	pushl  0x10(%ebp)
  800c10:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c13:	50                   	push   %eax
  800c14:	68 a0 0b 80 00       	push   $0x800ba0
  800c19:	e8 80 fb ff ff       	call   80079e <vprintfmt>
  800c1e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c24:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c2a:	c9                   	leave  
  800c2b:	c3                   	ret    

00800c2c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c32:	8d 45 10             	lea    0x10(%ebp),%eax
  800c35:	83 c0 04             	add    $0x4,%eax
  800c38:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c41:	50                   	push   %eax
  800c42:	ff 75 0c             	pushl  0xc(%ebp)
  800c45:	ff 75 08             	pushl  0x8(%ebp)
  800c48:	e8 89 ff ff ff       	call   800bd6 <vsnprintf>
  800c4d:	83 c4 10             	add    $0x10,%esp
  800c50:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c56:	c9                   	leave  
  800c57:	c3                   	ret    

00800c58 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c65:	eb 06                	jmp    800c6d <strlen+0x15>
		n++;
  800c67:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c6a:	ff 45 08             	incl   0x8(%ebp)
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	8a 00                	mov    (%eax),%al
  800c72:	84 c0                	test   %al,%al
  800c74:	75 f1                	jne    800c67 <strlen+0xf>
		n++;
	return n;
  800c76:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c79:	c9                   	leave  
  800c7a:	c3                   	ret    

00800c7b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c81:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c88:	eb 09                	jmp    800c93 <strnlen+0x18>
		n++;
  800c8a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c8d:	ff 45 08             	incl   0x8(%ebp)
  800c90:	ff 4d 0c             	decl   0xc(%ebp)
  800c93:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c97:	74 09                	je     800ca2 <strnlen+0x27>
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8a 00                	mov    (%eax),%al
  800c9e:	84 c0                	test   %al,%al
  800ca0:	75 e8                	jne    800c8a <strnlen+0xf>
		n++;
	return n;
  800ca2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ca5:	c9                   	leave  
  800ca6:	c3                   	ret    

00800ca7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cb3:	90                   	nop
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	8d 50 01             	lea    0x1(%eax),%edx
  800cba:	89 55 08             	mov    %edx,0x8(%ebp)
  800cbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cc6:	8a 12                	mov    (%edx),%dl
  800cc8:	88 10                	mov    %dl,(%eax)
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	84 c0                	test   %al,%al
  800cce:	75 e4                	jne    800cb4 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd3:	c9                   	leave  
  800cd4:	c3                   	ret    

00800cd5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
  800cd8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ce1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce8:	eb 1f                	jmp    800d09 <strncpy+0x34>
		*dst++ = *src;
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	8d 50 01             	lea    0x1(%eax),%edx
  800cf0:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf6:	8a 12                	mov    (%edx),%dl
  800cf8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfd:	8a 00                	mov    (%eax),%al
  800cff:	84 c0                	test   %al,%al
  800d01:	74 03                	je     800d06 <strncpy+0x31>
			src++;
  800d03:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d06:	ff 45 fc             	incl   -0x4(%ebp)
  800d09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d0f:	72 d9                	jb     800cea <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d11:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d14:	c9                   	leave  
  800d15:	c3                   	ret    

00800d16 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d26:	74 30                	je     800d58 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d28:	eb 16                	jmp    800d40 <strlcpy+0x2a>
			*dst++ = *src++;
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	8d 50 01             	lea    0x1(%eax),%edx
  800d30:	89 55 08             	mov    %edx,0x8(%ebp)
  800d33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d36:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d39:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d3c:	8a 12                	mov    (%edx),%dl
  800d3e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d40:	ff 4d 10             	decl   0x10(%ebp)
  800d43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d47:	74 09                	je     800d52 <strlcpy+0x3c>
  800d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4c:	8a 00                	mov    (%eax),%al
  800d4e:	84 c0                	test   %al,%al
  800d50:	75 d8                	jne    800d2a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d58:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d5e:	29 c2                	sub    %eax,%edx
  800d60:	89 d0                	mov    %edx,%eax
}
  800d62:	c9                   	leave  
  800d63:	c3                   	ret    

00800d64 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d67:	eb 06                	jmp    800d6f <strcmp+0xb>
		p++, q++;
  800d69:	ff 45 08             	incl   0x8(%ebp)
  800d6c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	8a 00                	mov    (%eax),%al
  800d74:	84 c0                	test   %al,%al
  800d76:	74 0e                	je     800d86 <strcmp+0x22>
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 10                	mov    (%eax),%dl
  800d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d80:	8a 00                	mov    (%eax),%al
  800d82:	38 c2                	cmp    %al,%dl
  800d84:	74 e3                	je     800d69 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8a 00                	mov    (%eax),%al
  800d8b:	0f b6 d0             	movzbl %al,%edx
  800d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d91:	8a 00                	mov    (%eax),%al
  800d93:	0f b6 c0             	movzbl %al,%eax
  800d96:	29 c2                	sub    %eax,%edx
  800d98:	89 d0                	mov    %edx,%eax
}
  800d9a:	5d                   	pop    %ebp
  800d9b:	c3                   	ret    

00800d9c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d9f:	eb 09                	jmp    800daa <strncmp+0xe>
		n--, p++, q++;
  800da1:	ff 4d 10             	decl   0x10(%ebp)
  800da4:	ff 45 08             	incl   0x8(%ebp)
  800da7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800daa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dae:	74 17                	je     800dc7 <strncmp+0x2b>
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	8a 00                	mov    (%eax),%al
  800db5:	84 c0                	test   %al,%al
  800db7:	74 0e                	je     800dc7 <strncmp+0x2b>
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	8a 10                	mov    (%eax),%dl
  800dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc1:	8a 00                	mov    (%eax),%al
  800dc3:	38 c2                	cmp    %al,%dl
  800dc5:	74 da                	je     800da1 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dcb:	75 07                	jne    800dd4 <strncmp+0x38>
		return 0;
  800dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd2:	eb 14                	jmp    800de8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	0f b6 d0             	movzbl %al,%edx
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	0f b6 c0             	movzbl %al,%eax
  800de4:	29 c2                	sub    %eax,%edx
  800de6:	89 d0                	mov    %edx,%eax
}
  800de8:	5d                   	pop    %ebp
  800de9:	c3                   	ret    

00800dea <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	83 ec 04             	sub    $0x4,%esp
  800df0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800df6:	eb 12                	jmp    800e0a <strchr+0x20>
		if (*s == c)
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e00:	75 05                	jne    800e07 <strchr+0x1d>
			return (char *) s;
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	eb 11                	jmp    800e18 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e07:	ff 45 08             	incl   0x8(%ebp)
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0d:	8a 00                	mov    (%eax),%al
  800e0f:	84 c0                	test   %al,%al
  800e11:	75 e5                	jne    800df8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e18:	c9                   	leave  
  800e19:	c3                   	ret    

00800e1a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	83 ec 04             	sub    $0x4,%esp
  800e20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e23:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e26:	eb 0d                	jmp    800e35 <strfind+0x1b>
		if (*s == c)
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e30:	74 0e                	je     800e40 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e32:	ff 45 08             	incl   0x8(%ebp)
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	8a 00                	mov    (%eax),%al
  800e3a:	84 c0                	test   %al,%al
  800e3c:	75 ea                	jne    800e28 <strfind+0xe>
  800e3e:	eb 01                	jmp    800e41 <strfind+0x27>
		if (*s == c)
			break;
  800e40:	90                   	nop
	return (char *) s;
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e52:	8b 45 10             	mov    0x10(%ebp),%eax
  800e55:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e58:	eb 0e                	jmp    800e68 <memset+0x22>
		*p++ = c;
  800e5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5d:	8d 50 01             	lea    0x1(%eax),%edx
  800e60:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e66:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e68:	ff 4d f8             	decl   -0x8(%ebp)
  800e6b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e6f:	79 e9                	jns    800e5a <memset+0x14>
		*p++ = c;

	return v;
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e74:	c9                   	leave  
  800e75:	c3                   	ret    

00800e76 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e88:	eb 16                	jmp    800ea0 <memcpy+0x2a>
		*d++ = *s++;
  800e8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e8d:	8d 50 01             	lea    0x1(%eax),%edx
  800e90:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e96:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e99:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e9c:	8a 12                	mov    (%edx),%dl
  800e9e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ea0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea6:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea9:	85 c0                	test   %eax,%eax
  800eab:	75 dd                	jne    800e8a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb0:	c9                   	leave  
  800eb1:	c3                   	ret    

00800eb2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800eb2:	55                   	push   %ebp
  800eb3:	89 e5                	mov    %esp,%ebp
  800eb5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ec4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eca:	73 50                	jae    800f1c <memmove+0x6a>
  800ecc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ecf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed2:	01 d0                	add    %edx,%eax
  800ed4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ed7:	76 43                	jbe    800f1c <memmove+0x6a>
		s += n;
  800ed9:	8b 45 10             	mov    0x10(%ebp),%eax
  800edc:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800edf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ee5:	eb 10                	jmp    800ef7 <memmove+0x45>
			*--d = *--s;
  800ee7:	ff 4d f8             	decl   -0x8(%ebp)
  800eea:	ff 4d fc             	decl   -0x4(%ebp)
  800eed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef0:	8a 10                	mov    (%eax),%dl
  800ef2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ef7:	8b 45 10             	mov    0x10(%ebp),%eax
  800efa:	8d 50 ff             	lea    -0x1(%eax),%edx
  800efd:	89 55 10             	mov    %edx,0x10(%ebp)
  800f00:	85 c0                	test   %eax,%eax
  800f02:	75 e3                	jne    800ee7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f04:	eb 23                	jmp    800f29 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f06:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f09:	8d 50 01             	lea    0x1(%eax),%edx
  800f0c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f0f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f12:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f15:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f18:	8a 12                	mov    (%edx),%dl
  800f1a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f22:	89 55 10             	mov    %edx,0x10(%ebp)
  800f25:	85 c0                	test   %eax,%eax
  800f27:	75 dd                	jne    800f06 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f2c:	c9                   	leave  
  800f2d:	c3                   	ret    

00800f2e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f40:	eb 2a                	jmp    800f6c <memcmp+0x3e>
		if (*s1 != *s2)
  800f42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f45:	8a 10                	mov    (%eax),%dl
  800f47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4a:	8a 00                	mov    (%eax),%al
  800f4c:	38 c2                	cmp    %al,%dl
  800f4e:	74 16                	je     800f66 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	0f b6 d0             	movzbl %al,%edx
  800f58:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5b:	8a 00                	mov    (%eax),%al
  800f5d:	0f b6 c0             	movzbl %al,%eax
  800f60:	29 c2                	sub    %eax,%edx
  800f62:	89 d0                	mov    %edx,%eax
  800f64:	eb 18                	jmp    800f7e <memcmp+0x50>
		s1++, s2++;
  800f66:	ff 45 fc             	incl   -0x4(%ebp)
  800f69:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f72:	89 55 10             	mov    %edx,0x10(%ebp)
  800f75:	85 c0                	test   %eax,%eax
  800f77:	75 c9                	jne    800f42 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f7e:	c9                   	leave  
  800f7f:	c3                   	ret    

00800f80 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f86:	8b 55 08             	mov    0x8(%ebp),%edx
  800f89:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8c:	01 d0                	add    %edx,%eax
  800f8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f91:	eb 15                	jmp    800fa8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	0f b6 d0             	movzbl %al,%edx
  800f9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9e:	0f b6 c0             	movzbl %al,%eax
  800fa1:	39 c2                	cmp    %eax,%edx
  800fa3:	74 0d                	je     800fb2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fa5:	ff 45 08             	incl   0x8(%ebp)
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fae:	72 e3                	jb     800f93 <memfind+0x13>
  800fb0:	eb 01                	jmp    800fb3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fb2:	90                   	nop
	return (void *) s;
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb6:	c9                   	leave  
  800fb7:	c3                   	ret    

00800fb8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fb8:	55                   	push   %ebp
  800fb9:	89 e5                	mov    %esp,%ebp
  800fbb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fc5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fcc:	eb 03                	jmp    800fd1 <strtol+0x19>
		s++;
  800fce:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	3c 20                	cmp    $0x20,%al
  800fd8:	74 f4                	je     800fce <strtol+0x16>
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	3c 09                	cmp    $0x9,%al
  800fe1:	74 eb                	je     800fce <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	3c 2b                	cmp    $0x2b,%al
  800fea:	75 05                	jne    800ff1 <strtol+0x39>
		s++;
  800fec:	ff 45 08             	incl   0x8(%ebp)
  800fef:	eb 13                	jmp    801004 <strtol+0x4c>
	else if (*s == '-')
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 2d                	cmp    $0x2d,%al
  800ff8:	75 0a                	jne    801004 <strtol+0x4c>
		s++, neg = 1;
  800ffa:	ff 45 08             	incl   0x8(%ebp)
  800ffd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801004:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801008:	74 06                	je     801010 <strtol+0x58>
  80100a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80100e:	75 20                	jne    801030 <strtol+0x78>
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	3c 30                	cmp    $0x30,%al
  801017:	75 17                	jne    801030 <strtol+0x78>
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	40                   	inc    %eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	3c 78                	cmp    $0x78,%al
  801021:	75 0d                	jne    801030 <strtol+0x78>
		s += 2, base = 16;
  801023:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801027:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80102e:	eb 28                	jmp    801058 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801030:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801034:	75 15                	jne    80104b <strtol+0x93>
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	3c 30                	cmp    $0x30,%al
  80103d:	75 0c                	jne    80104b <strtol+0x93>
		s++, base = 8;
  80103f:	ff 45 08             	incl   0x8(%ebp)
  801042:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801049:	eb 0d                	jmp    801058 <strtol+0xa0>
	else if (base == 0)
  80104b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80104f:	75 07                	jne    801058 <strtol+0xa0>
		base = 10;
  801051:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	3c 2f                	cmp    $0x2f,%al
  80105f:	7e 19                	jle    80107a <strtol+0xc2>
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8a 00                	mov    (%eax),%al
  801066:	3c 39                	cmp    $0x39,%al
  801068:	7f 10                	jg     80107a <strtol+0xc2>
			dig = *s - '0';
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	8a 00                	mov    (%eax),%al
  80106f:	0f be c0             	movsbl %al,%eax
  801072:	83 e8 30             	sub    $0x30,%eax
  801075:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801078:	eb 42                	jmp    8010bc <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	8a 00                	mov    (%eax),%al
  80107f:	3c 60                	cmp    $0x60,%al
  801081:	7e 19                	jle    80109c <strtol+0xe4>
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	3c 7a                	cmp    $0x7a,%al
  80108a:	7f 10                	jg     80109c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80108c:	8b 45 08             	mov    0x8(%ebp),%eax
  80108f:	8a 00                	mov    (%eax),%al
  801091:	0f be c0             	movsbl %al,%eax
  801094:	83 e8 57             	sub    $0x57,%eax
  801097:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80109a:	eb 20                	jmp    8010bc <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
  80109f:	8a 00                	mov    (%eax),%al
  8010a1:	3c 40                	cmp    $0x40,%al
  8010a3:	7e 39                	jle    8010de <strtol+0x126>
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	8a 00                	mov    (%eax),%al
  8010aa:	3c 5a                	cmp    $0x5a,%al
  8010ac:	7f 30                	jg     8010de <strtol+0x126>
			dig = *s - 'A' + 10;
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	0f be c0             	movsbl %al,%eax
  8010b6:	83 e8 37             	sub    $0x37,%eax
  8010b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010bf:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010c2:	7d 19                	jge    8010dd <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010c4:	ff 45 08             	incl   0x8(%ebp)
  8010c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ca:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010ce:	89 c2                	mov    %eax,%edx
  8010d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d3:	01 d0                	add    %edx,%eax
  8010d5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010d8:	e9 7b ff ff ff       	jmp    801058 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010dd:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010e2:	74 08                	je     8010ec <strtol+0x134>
		*endptr = (char *) s;
  8010e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ea:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f0:	74 07                	je     8010f9 <strtol+0x141>
  8010f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f5:	f7 d8                	neg    %eax
  8010f7:	eb 03                	jmp    8010fc <strtol+0x144>
  8010f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010fc:	c9                   	leave  
  8010fd:	c3                   	ret    

008010fe <ltostr>:

void
ltostr(long value, char *str)
{
  8010fe:	55                   	push   %ebp
  8010ff:	89 e5                	mov    %esp,%ebp
  801101:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801104:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80110b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801112:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801116:	79 13                	jns    80112b <ltostr+0x2d>
	{
		neg = 1;
  801118:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80111f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801122:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801125:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801128:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801133:	99                   	cltd   
  801134:	f7 f9                	idiv   %ecx
  801136:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801139:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113c:	8d 50 01             	lea    0x1(%eax),%edx
  80113f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801142:	89 c2                	mov    %eax,%edx
  801144:	8b 45 0c             	mov    0xc(%ebp),%eax
  801147:	01 d0                	add    %edx,%eax
  801149:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80114c:	83 c2 30             	add    $0x30,%edx
  80114f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801151:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801154:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801159:	f7 e9                	imul   %ecx
  80115b:	c1 fa 02             	sar    $0x2,%edx
  80115e:	89 c8                	mov    %ecx,%eax
  801160:	c1 f8 1f             	sar    $0x1f,%eax
  801163:	29 c2                	sub    %eax,%edx
  801165:	89 d0                	mov    %edx,%eax
  801167:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80116a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80116e:	75 bb                	jne    80112b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801170:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801177:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117a:	48                   	dec    %eax
  80117b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80117e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801182:	74 3d                	je     8011c1 <ltostr+0xc3>
		start = 1 ;
  801184:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80118b:	eb 34                	jmp    8011c1 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80118d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801190:	8b 45 0c             	mov    0xc(%ebp),%eax
  801193:	01 d0                	add    %edx,%eax
  801195:	8a 00                	mov    (%eax),%al
  801197:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80119a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80119d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a0:	01 c2                	add    %eax,%edx
  8011a2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a8:	01 c8                	add    %ecx,%eax
  8011aa:	8a 00                	mov    (%eax),%al
  8011ac:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b4:	01 c2                	add    %eax,%edx
  8011b6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011b9:	88 02                	mov    %al,(%edx)
		start++ ;
  8011bb:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011be:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011c7:	7c c4                	jl     80118d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011c9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cf:	01 d0                	add    %edx,%eax
  8011d1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011d4:	90                   	nop
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    

008011d7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
  8011da:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011dd:	ff 75 08             	pushl  0x8(%ebp)
  8011e0:	e8 73 fa ff ff       	call   800c58 <strlen>
  8011e5:	83 c4 04             	add    $0x4,%esp
  8011e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011eb:	ff 75 0c             	pushl  0xc(%ebp)
  8011ee:	e8 65 fa ff ff       	call   800c58 <strlen>
  8011f3:	83 c4 04             	add    $0x4,%esp
  8011f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801200:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801207:	eb 17                	jmp    801220 <strcconcat+0x49>
		final[s] = str1[s] ;
  801209:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80120c:	8b 45 10             	mov    0x10(%ebp),%eax
  80120f:	01 c2                	add    %eax,%edx
  801211:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	01 c8                	add    %ecx,%eax
  801219:	8a 00                	mov    (%eax),%al
  80121b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80121d:	ff 45 fc             	incl   -0x4(%ebp)
  801220:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801223:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801226:	7c e1                	jl     801209 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801228:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80122f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801236:	eb 1f                	jmp    801257 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801238:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80123b:	8d 50 01             	lea    0x1(%eax),%edx
  80123e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801241:	89 c2                	mov    %eax,%edx
  801243:	8b 45 10             	mov    0x10(%ebp),%eax
  801246:	01 c2                	add    %eax,%edx
  801248:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80124b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124e:	01 c8                	add    %ecx,%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801254:	ff 45 f8             	incl   -0x8(%ebp)
  801257:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80125d:	7c d9                	jl     801238 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80125f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801262:	8b 45 10             	mov    0x10(%ebp),%eax
  801265:	01 d0                	add    %edx,%eax
  801267:	c6 00 00             	movb   $0x0,(%eax)
}
  80126a:	90                   	nop
  80126b:	c9                   	leave  
  80126c:	c3                   	ret    

0080126d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80126d:	55                   	push   %ebp
  80126e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801270:	8b 45 14             	mov    0x14(%ebp),%eax
  801273:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801279:	8b 45 14             	mov    0x14(%ebp),%eax
  80127c:	8b 00                	mov    (%eax),%eax
  80127e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801285:	8b 45 10             	mov    0x10(%ebp),%eax
  801288:	01 d0                	add    %edx,%eax
  80128a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801290:	eb 0c                	jmp    80129e <strsplit+0x31>
			*string++ = 0;
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8d 50 01             	lea    0x1(%eax),%edx
  801298:	89 55 08             	mov    %edx,0x8(%ebp)
  80129b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	8a 00                	mov    (%eax),%al
  8012a3:	84 c0                	test   %al,%al
  8012a5:	74 18                	je     8012bf <strsplit+0x52>
  8012a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012aa:	8a 00                	mov    (%eax),%al
  8012ac:	0f be c0             	movsbl %al,%eax
  8012af:	50                   	push   %eax
  8012b0:	ff 75 0c             	pushl  0xc(%ebp)
  8012b3:	e8 32 fb ff ff       	call   800dea <strchr>
  8012b8:	83 c4 08             	add    $0x8,%esp
  8012bb:	85 c0                	test   %eax,%eax
  8012bd:	75 d3                	jne    801292 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	8a 00                	mov    (%eax),%al
  8012c4:	84 c0                	test   %al,%al
  8012c6:	74 5a                	je     801322 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8012cb:	8b 00                	mov    (%eax),%eax
  8012cd:	83 f8 0f             	cmp    $0xf,%eax
  8012d0:	75 07                	jne    8012d9 <strsplit+0x6c>
		{
			return 0;
  8012d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d7:	eb 66                	jmp    80133f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8012dc:	8b 00                	mov    (%eax),%eax
  8012de:	8d 48 01             	lea    0x1(%eax),%ecx
  8012e1:	8b 55 14             	mov    0x14(%ebp),%edx
  8012e4:	89 0a                	mov    %ecx,(%edx)
  8012e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f0:	01 c2                	add    %eax,%edx
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012f7:	eb 03                	jmp    8012fc <strsplit+0x8f>
			string++;
  8012f9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	8a 00                	mov    (%eax),%al
  801301:	84 c0                	test   %al,%al
  801303:	74 8b                	je     801290 <strsplit+0x23>
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	0f be c0             	movsbl %al,%eax
  80130d:	50                   	push   %eax
  80130e:	ff 75 0c             	pushl  0xc(%ebp)
  801311:	e8 d4 fa ff ff       	call   800dea <strchr>
  801316:	83 c4 08             	add    $0x8,%esp
  801319:	85 c0                	test   %eax,%eax
  80131b:	74 dc                	je     8012f9 <strsplit+0x8c>
			string++;
	}
  80131d:	e9 6e ff ff ff       	jmp    801290 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801322:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801323:	8b 45 14             	mov    0x14(%ebp),%eax
  801326:	8b 00                	mov    (%eax),%eax
  801328:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80132f:	8b 45 10             	mov    0x10(%ebp),%eax
  801332:	01 d0                	add    %edx,%eax
  801334:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80133a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80133f:	c9                   	leave  
  801340:	c3                   	ret    

00801341 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
  801344:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801347:	83 ec 04             	sub    $0x4,%esp
  80134a:	68 e8 22 80 00       	push   $0x8022e8
  80134f:	68 3f 01 00 00       	push   $0x13f
  801354:	68 0a 23 80 00       	push   $0x80230a
  801359:	e8 a9 ef ff ff       	call   800307 <_panic>

0080135e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
  801361:	57                   	push   %edi
  801362:	56                   	push   %esi
  801363:	53                   	push   %ebx
  801364:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801370:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801373:	8b 7d 18             	mov    0x18(%ebp),%edi
  801376:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801379:	cd 30                	int    $0x30
  80137b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80137e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801381:	83 c4 10             	add    $0x10,%esp
  801384:	5b                   	pop    %ebx
  801385:	5e                   	pop    %esi
  801386:	5f                   	pop    %edi
  801387:	5d                   	pop    %ebp
  801388:	c3                   	ret    

00801389 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	83 ec 04             	sub    $0x4,%esp
  80138f:	8b 45 10             	mov    0x10(%ebp),%eax
  801392:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801395:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	52                   	push   %edx
  8013a1:	ff 75 0c             	pushl  0xc(%ebp)
  8013a4:	50                   	push   %eax
  8013a5:	6a 00                	push   $0x0
  8013a7:	e8 b2 ff ff ff       	call   80135e <syscall>
  8013ac:	83 c4 18             	add    $0x18,%esp
}
  8013af:	90                   	nop
  8013b0:	c9                   	leave  
  8013b1:	c3                   	ret    

008013b2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8013b2:	55                   	push   %ebp
  8013b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 02                	push   $0x2
  8013c1:	e8 98 ff ff ff       	call   80135e <syscall>
  8013c6:	83 c4 18             	add    $0x18,%esp
}
  8013c9:	c9                   	leave  
  8013ca:	c3                   	ret    

008013cb <sys_lock_cons>:

void sys_lock_cons(void)
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8013ce:	6a 00                	push   $0x0
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 03                	push   $0x3
  8013da:	e8 7f ff ff ff       	call   80135e <syscall>
  8013df:	83 c4 18             	add    $0x18,%esp
}
  8013e2:	90                   	nop
  8013e3:	c9                   	leave  
  8013e4:	c3                   	ret    

008013e5 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 00                	push   $0x0
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 04                	push   $0x4
  8013f4:	e8 65 ff ff ff       	call   80135e <syscall>
  8013f9:	83 c4 18             	add    $0x18,%esp
}
  8013fc:	90                   	nop
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801402:	8b 55 0c             	mov    0xc(%ebp),%edx
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	6a 00                	push   $0x0
  80140a:	6a 00                	push   $0x0
  80140c:	6a 00                	push   $0x0
  80140e:	52                   	push   %edx
  80140f:	50                   	push   %eax
  801410:	6a 08                	push   $0x8
  801412:	e8 47 ff ff ff       	call   80135e <syscall>
  801417:	83 c4 18             	add    $0x18,%esp
}
  80141a:	c9                   	leave  
  80141b:	c3                   	ret    

0080141c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	56                   	push   %esi
  801420:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801421:	8b 75 18             	mov    0x18(%ebp),%esi
  801424:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801427:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80142a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	56                   	push   %esi
  801431:	53                   	push   %ebx
  801432:	51                   	push   %ecx
  801433:	52                   	push   %edx
  801434:	50                   	push   %eax
  801435:	6a 09                	push   $0x9
  801437:	e8 22 ff ff ff       	call   80135e <syscall>
  80143c:	83 c4 18             	add    $0x18,%esp
}
  80143f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801442:	5b                   	pop    %ebx
  801443:	5e                   	pop    %esi
  801444:	5d                   	pop    %ebp
  801445:	c3                   	ret    

00801446 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801449:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144c:	8b 45 08             	mov    0x8(%ebp),%eax
  80144f:	6a 00                	push   $0x0
  801451:	6a 00                	push   $0x0
  801453:	6a 00                	push   $0x0
  801455:	52                   	push   %edx
  801456:	50                   	push   %eax
  801457:	6a 0a                	push   $0xa
  801459:	e8 00 ff ff ff       	call   80135e <syscall>
  80145e:	83 c4 18             	add    $0x18,%esp
}
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	ff 75 0c             	pushl  0xc(%ebp)
  80146f:	ff 75 08             	pushl  0x8(%ebp)
  801472:	6a 0b                	push   $0xb
  801474:	e8 e5 fe ff ff       	call   80135e <syscall>
  801479:	83 c4 18             	add    $0x18,%esp
}
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801481:	6a 00                	push   $0x0
  801483:	6a 00                	push   $0x0
  801485:	6a 00                	push   $0x0
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	6a 0c                	push   $0xc
  80148d:	e8 cc fe ff ff       	call   80135e <syscall>
  801492:	83 c4 18             	add    $0x18,%esp
}
  801495:	c9                   	leave  
  801496:	c3                   	ret    

00801497 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 0d                	push   $0xd
  8014a6:	e8 b3 fe ff ff       	call   80135e <syscall>
  8014ab:	83 c4 18             	add    $0x18,%esp
}
  8014ae:	c9                   	leave  
  8014af:	c3                   	ret    

008014b0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 0e                	push   $0xe
  8014bf:	e8 9a fe ff ff       	call   80135e <syscall>
  8014c4:	83 c4 18             	add    $0x18,%esp
}
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    

008014c9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 0f                	push   $0xf
  8014d8:	e8 81 fe ff ff       	call   80135e <syscall>
  8014dd:	83 c4 18             	add    $0x18,%esp
}
  8014e0:	c9                   	leave  
  8014e1:	c3                   	ret    

008014e2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8014e2:	55                   	push   %ebp
  8014e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	ff 75 08             	pushl  0x8(%ebp)
  8014f0:	6a 10                	push   $0x10
  8014f2:	e8 67 fe ff ff       	call   80135e <syscall>
  8014f7:	83 c4 18             	add    $0x18,%esp
}
  8014fa:	c9                   	leave  
  8014fb:	c3                   	ret    

008014fc <sys_scarce_memory>:

void sys_scarce_memory()
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 11                	push   $0x11
  80150b:	e8 4e fe ff ff       	call   80135e <syscall>
  801510:	83 c4 18             	add    $0x18,%esp
}
  801513:	90                   	nop
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <sys_cputc>:

void
sys_cputc(const char c)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	83 ec 04             	sub    $0x4,%esp
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801522:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	50                   	push   %eax
  80152f:	6a 01                	push   $0x1
  801531:	e8 28 fe ff ff       	call   80135e <syscall>
  801536:	83 c4 18             	add    $0x18,%esp
}
  801539:	90                   	nop
  80153a:	c9                   	leave  
  80153b:	c3                   	ret    

0080153c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 14                	push   $0x14
  80154b:	e8 0e fe ff ff       	call   80135e <syscall>
  801550:	83 c4 18             	add    $0x18,%esp
}
  801553:	90                   	nop
  801554:	c9                   	leave  
  801555:	c3                   	ret    

00801556 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
  801559:	83 ec 04             	sub    $0x4,%esp
  80155c:	8b 45 10             	mov    0x10(%ebp),%eax
  80155f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801562:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801565:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801569:	8b 45 08             	mov    0x8(%ebp),%eax
  80156c:	6a 00                	push   $0x0
  80156e:	51                   	push   %ecx
  80156f:	52                   	push   %edx
  801570:	ff 75 0c             	pushl  0xc(%ebp)
  801573:	50                   	push   %eax
  801574:	6a 15                	push   $0x15
  801576:	e8 e3 fd ff ff       	call   80135e <syscall>
  80157b:	83 c4 18             	add    $0x18,%esp
}
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    

00801580 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801583:	8b 55 0c             	mov    0xc(%ebp),%edx
  801586:	8b 45 08             	mov    0x8(%ebp),%eax
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	52                   	push   %edx
  801590:	50                   	push   %eax
  801591:	6a 16                	push   $0x16
  801593:	e8 c6 fd ff ff       	call   80135e <syscall>
  801598:	83 c4 18             	add    $0x18,%esp
}
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8015a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	51                   	push   %ecx
  8015ae:	52                   	push   %edx
  8015af:	50                   	push   %eax
  8015b0:	6a 17                	push   $0x17
  8015b2:	e8 a7 fd ff ff       	call   80135e <syscall>
  8015b7:	83 c4 18             	add    $0x18,%esp
}
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	52                   	push   %edx
  8015cc:	50                   	push   %eax
  8015cd:	6a 18                	push   $0x18
  8015cf:	e8 8a fd ff ff       	call   80135e <syscall>
  8015d4:	83 c4 18             	add    $0x18,%esp
}
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8015dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015df:	6a 00                	push   $0x0
  8015e1:	ff 75 14             	pushl  0x14(%ebp)
  8015e4:	ff 75 10             	pushl  0x10(%ebp)
  8015e7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ea:	50                   	push   %eax
  8015eb:	6a 19                	push   $0x19
  8015ed:	e8 6c fd ff ff       	call   80135e <syscall>
  8015f2:	83 c4 18             	add    $0x18,%esp
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	50                   	push   %eax
  801606:	6a 1a                	push   $0x1a
  801608:	e8 51 fd ff ff       	call   80135e <syscall>
  80160d:	83 c4 18             	add    $0x18,%esp
}
  801610:	90                   	nop
  801611:	c9                   	leave  
  801612:	c3                   	ret    

00801613 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	50                   	push   %eax
  801622:	6a 1b                	push   $0x1b
  801624:	e8 35 fd ff ff       	call   80135e <syscall>
  801629:	83 c4 18             	add    $0x18,%esp
}
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    

0080162e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 05                	push   $0x5
  80163d:	e8 1c fd ff ff       	call   80135e <syscall>
  801642:	83 c4 18             	add    $0x18,%esp
}
  801645:	c9                   	leave  
  801646:	c3                   	ret    

00801647 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 06                	push   $0x6
  801656:	e8 03 fd ff ff       	call   80135e <syscall>
  80165b:	83 c4 18             	add    $0x18,%esp
}
  80165e:	c9                   	leave  
  80165f:	c3                   	ret    

00801660 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 07                	push   $0x7
  80166f:	e8 ea fc ff ff       	call   80135e <syscall>
  801674:	83 c4 18             	add    $0x18,%esp
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <sys_exit_env>:


void sys_exit_env(void)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 1c                	push   $0x1c
  801688:	e8 d1 fc ff ff       	call   80135e <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
}
  801690:	90                   	nop
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801699:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80169c:	8d 50 04             	lea    0x4(%eax),%edx
  80169f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	52                   	push   %edx
  8016a9:	50                   	push   %eax
  8016aa:	6a 1d                	push   $0x1d
  8016ac:	e8 ad fc ff ff       	call   80135e <syscall>
  8016b1:	83 c4 18             	add    $0x18,%esp
	return result;
  8016b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016bd:	89 01                	mov    %eax,(%ecx)
  8016bf:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	c9                   	leave  
  8016c6:	c2 04 00             	ret    $0x4

008016c9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	ff 75 10             	pushl  0x10(%ebp)
  8016d3:	ff 75 0c             	pushl  0xc(%ebp)
  8016d6:	ff 75 08             	pushl  0x8(%ebp)
  8016d9:	6a 13                	push   $0x13
  8016db:	e8 7e fc ff ff       	call   80135e <syscall>
  8016e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e3:	90                   	nop
}
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    

008016e6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 1e                	push   $0x1e
  8016f5:	e8 64 fc ff ff       	call   80135e <syscall>
  8016fa:	83 c4 18             	add    $0x18,%esp
}
  8016fd:	c9                   	leave  
  8016fe:	c3                   	ret    

008016ff <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
  801702:	83 ec 04             	sub    $0x4,%esp
  801705:	8b 45 08             	mov    0x8(%ebp),%eax
  801708:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80170b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	50                   	push   %eax
  801718:	6a 1f                	push   $0x1f
  80171a:	e8 3f fc ff ff       	call   80135e <syscall>
  80171f:	83 c4 18             	add    $0x18,%esp
	return ;
  801722:	90                   	nop
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <rsttst>:
void rsttst()
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 21                	push   $0x21
  801734:	e8 25 fc ff ff       	call   80135e <syscall>
  801739:	83 c4 18             	add    $0x18,%esp
	return ;
  80173c:	90                   	nop
}
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    

0080173f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
  801742:	83 ec 04             	sub    $0x4,%esp
  801745:	8b 45 14             	mov    0x14(%ebp),%eax
  801748:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80174b:	8b 55 18             	mov    0x18(%ebp),%edx
  80174e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801752:	52                   	push   %edx
  801753:	50                   	push   %eax
  801754:	ff 75 10             	pushl  0x10(%ebp)
  801757:	ff 75 0c             	pushl  0xc(%ebp)
  80175a:	ff 75 08             	pushl  0x8(%ebp)
  80175d:	6a 20                	push   $0x20
  80175f:	e8 fa fb ff ff       	call   80135e <syscall>
  801764:	83 c4 18             	add    $0x18,%esp
	return ;
  801767:	90                   	nop
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <chktst>:
void chktst(uint32 n)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	ff 75 08             	pushl  0x8(%ebp)
  801778:	6a 22                	push   $0x22
  80177a:	e8 df fb ff ff       	call   80135e <syscall>
  80177f:	83 c4 18             	add    $0x18,%esp
	return ;
  801782:	90                   	nop
}
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <inctst>:

void inctst()
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 23                	push   $0x23
  801794:	e8 c5 fb ff ff       	call   80135e <syscall>
  801799:	83 c4 18             	add    $0x18,%esp
	return ;
  80179c:	90                   	nop
}
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <gettst>:
uint32 gettst()
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 24                	push   $0x24
  8017ae:	e8 ab fb ff ff       	call   80135e <syscall>
  8017b3:	83 c4 18             	add    $0x18,%esp
}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
  8017bb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 25                	push   $0x25
  8017ca:	e8 8f fb ff ff       	call   80135e <syscall>
  8017cf:	83 c4 18             	add    $0x18,%esp
  8017d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017d5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017d9:	75 07                	jne    8017e2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017db:	b8 01 00 00 00       	mov    $0x1,%eax
  8017e0:	eb 05                	jmp    8017e7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 25                	push   $0x25
  8017fb:	e8 5e fb ff ff       	call   80135e <syscall>
  801800:	83 c4 18             	add    $0x18,%esp
  801803:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801806:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80180a:	75 07                	jne    801813 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80180c:	b8 01 00 00 00       	mov    $0x1,%eax
  801811:	eb 05                	jmp    801818 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801813:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801818:	c9                   	leave  
  801819:	c3                   	ret    

0080181a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 25                	push   $0x25
  80182c:	e8 2d fb ff ff       	call   80135e <syscall>
  801831:	83 c4 18             	add    $0x18,%esp
  801834:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801837:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80183b:	75 07                	jne    801844 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80183d:	b8 01 00 00 00       	mov    $0x1,%eax
  801842:	eb 05                	jmp    801849 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801844:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 25                	push   $0x25
  80185d:	e8 fc fa ff ff       	call   80135e <syscall>
  801862:	83 c4 18             	add    $0x18,%esp
  801865:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801868:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80186c:	75 07                	jne    801875 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80186e:	b8 01 00 00 00       	mov    $0x1,%eax
  801873:	eb 05                	jmp    80187a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801875:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	ff 75 08             	pushl  0x8(%ebp)
  80188a:	6a 26                	push   $0x26
  80188c:	e8 cd fa ff ff       	call   80135e <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
	return ;
  801894:	90                   	nop
}
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80189b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80189e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a7:	6a 00                	push   $0x0
  8018a9:	53                   	push   %ebx
  8018aa:	51                   	push   %ecx
  8018ab:	52                   	push   %edx
  8018ac:	50                   	push   %eax
  8018ad:	6a 27                	push   $0x27
  8018af:	e8 aa fa ff ff       	call   80135e <syscall>
  8018b4:	83 c4 18             	add    $0x18,%esp
}
  8018b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	52                   	push   %edx
  8018cc:	50                   	push   %eax
  8018cd:	6a 28                	push   $0x28
  8018cf:	e8 8a fa ff ff       	call   80135e <syscall>
  8018d4:	83 c4 18             	add    $0x18,%esp
}
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018dc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	6a 00                	push   $0x0
  8018e7:	51                   	push   %ecx
  8018e8:	ff 75 10             	pushl  0x10(%ebp)
  8018eb:	52                   	push   %edx
  8018ec:	50                   	push   %eax
  8018ed:	6a 29                	push   $0x29
  8018ef:	e8 6a fa ff ff       	call   80135e <syscall>
  8018f4:	83 c4 18             	add    $0x18,%esp
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	ff 75 10             	pushl  0x10(%ebp)
  801903:	ff 75 0c             	pushl  0xc(%ebp)
  801906:	ff 75 08             	pushl  0x8(%ebp)
  801909:	6a 12                	push   $0x12
  80190b:	e8 4e fa ff ff       	call   80135e <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
	return ;
  801913:	90                   	nop
}
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801919:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191c:	8b 45 08             	mov    0x8(%ebp),%eax
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	52                   	push   %edx
  801926:	50                   	push   %eax
  801927:	6a 2a                	push   $0x2a
  801929:	e8 30 fa ff ff       	call   80135e <syscall>
  80192e:	83 c4 18             	add    $0x18,%esp
	return;
  801931:	90                   	nop
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801937:	8b 45 08             	mov    0x8(%ebp),%eax
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	50                   	push   %eax
  801943:	6a 2b                	push   $0x2b
  801945:	e8 14 fa ff ff       	call   80135e <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
}
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	ff 75 0c             	pushl  0xc(%ebp)
  80195b:	ff 75 08             	pushl  0x8(%ebp)
  80195e:	6a 2c                	push   $0x2c
  801960:	e8 f9 f9 ff ff       	call   80135e <syscall>
  801965:	83 c4 18             	add    $0x18,%esp
	return;
  801968:	90                   	nop
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	ff 75 0c             	pushl  0xc(%ebp)
  801977:	ff 75 08             	pushl  0x8(%ebp)
  80197a:	6a 2d                	push   $0x2d
  80197c:	e8 dd f9 ff ff       	call   80135e <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
	return;
  801984:	90                   	nop
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  80198d:	83 ec 04             	sub    $0x4,%esp
  801990:	68 18 23 80 00       	push   $0x802318
  801995:	6a 09                	push   $0x9
  801997:	68 40 23 80 00       	push   $0x802340
  80199c:	e8 66 e9 ff ff       	call   800307 <_panic>

008019a1 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  8019a7:	83 ec 04             	sub    $0x4,%esp
  8019aa:	68 50 23 80 00       	push   $0x802350
  8019af:	6a 10                	push   $0x10
  8019b1:	68 40 23 80 00       	push   $0x802340
  8019b6:	e8 4c e9 ff ff       	call   800307 <_panic>

008019bb <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  8019c1:	83 ec 04             	sub    $0x4,%esp
  8019c4:	68 78 23 80 00       	push   $0x802378
  8019c9:	6a 18                	push   $0x18
  8019cb:	68 40 23 80 00       	push   $0x802340
  8019d0:	e8 32 e9 ff ff       	call   800307 <_panic>

008019d5 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  8019db:	83 ec 04             	sub    $0x4,%esp
  8019de:	68 a0 23 80 00       	push   $0x8023a0
  8019e3:	6a 20                	push   $0x20
  8019e5:	68 40 23 80 00       	push   $0x802340
  8019ea:	e8 18 e9 ff ff       	call   800307 <_panic>

008019ef <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f5:	8b 40 10             	mov    0x10(%eax),%eax
}
  8019f8:	5d                   	pop    %ebp
  8019f9:	c3                   	ret    
  8019fa:	66 90                	xchg   %ax,%ax

008019fc <__udivdi3>:
  8019fc:	55                   	push   %ebp
  8019fd:	57                   	push   %edi
  8019fe:	56                   	push   %esi
  8019ff:	53                   	push   %ebx
  801a00:	83 ec 1c             	sub    $0x1c,%esp
  801a03:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a07:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a0b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a0f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a13:	89 ca                	mov    %ecx,%edx
  801a15:	89 f8                	mov    %edi,%eax
  801a17:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a1b:	85 f6                	test   %esi,%esi
  801a1d:	75 2d                	jne    801a4c <__udivdi3+0x50>
  801a1f:	39 cf                	cmp    %ecx,%edi
  801a21:	77 65                	ja     801a88 <__udivdi3+0x8c>
  801a23:	89 fd                	mov    %edi,%ebp
  801a25:	85 ff                	test   %edi,%edi
  801a27:	75 0b                	jne    801a34 <__udivdi3+0x38>
  801a29:	b8 01 00 00 00       	mov    $0x1,%eax
  801a2e:	31 d2                	xor    %edx,%edx
  801a30:	f7 f7                	div    %edi
  801a32:	89 c5                	mov    %eax,%ebp
  801a34:	31 d2                	xor    %edx,%edx
  801a36:	89 c8                	mov    %ecx,%eax
  801a38:	f7 f5                	div    %ebp
  801a3a:	89 c1                	mov    %eax,%ecx
  801a3c:	89 d8                	mov    %ebx,%eax
  801a3e:	f7 f5                	div    %ebp
  801a40:	89 cf                	mov    %ecx,%edi
  801a42:	89 fa                	mov    %edi,%edx
  801a44:	83 c4 1c             	add    $0x1c,%esp
  801a47:	5b                   	pop    %ebx
  801a48:	5e                   	pop    %esi
  801a49:	5f                   	pop    %edi
  801a4a:	5d                   	pop    %ebp
  801a4b:	c3                   	ret    
  801a4c:	39 ce                	cmp    %ecx,%esi
  801a4e:	77 28                	ja     801a78 <__udivdi3+0x7c>
  801a50:	0f bd fe             	bsr    %esi,%edi
  801a53:	83 f7 1f             	xor    $0x1f,%edi
  801a56:	75 40                	jne    801a98 <__udivdi3+0x9c>
  801a58:	39 ce                	cmp    %ecx,%esi
  801a5a:	72 0a                	jb     801a66 <__udivdi3+0x6a>
  801a5c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a60:	0f 87 9e 00 00 00    	ja     801b04 <__udivdi3+0x108>
  801a66:	b8 01 00 00 00       	mov    $0x1,%eax
  801a6b:	89 fa                	mov    %edi,%edx
  801a6d:	83 c4 1c             	add    $0x1c,%esp
  801a70:	5b                   	pop    %ebx
  801a71:	5e                   	pop    %esi
  801a72:	5f                   	pop    %edi
  801a73:	5d                   	pop    %ebp
  801a74:	c3                   	ret    
  801a75:	8d 76 00             	lea    0x0(%esi),%esi
  801a78:	31 ff                	xor    %edi,%edi
  801a7a:	31 c0                	xor    %eax,%eax
  801a7c:	89 fa                	mov    %edi,%edx
  801a7e:	83 c4 1c             	add    $0x1c,%esp
  801a81:	5b                   	pop    %ebx
  801a82:	5e                   	pop    %esi
  801a83:	5f                   	pop    %edi
  801a84:	5d                   	pop    %ebp
  801a85:	c3                   	ret    
  801a86:	66 90                	xchg   %ax,%ax
  801a88:	89 d8                	mov    %ebx,%eax
  801a8a:	f7 f7                	div    %edi
  801a8c:	31 ff                	xor    %edi,%edi
  801a8e:	89 fa                	mov    %edi,%edx
  801a90:	83 c4 1c             	add    $0x1c,%esp
  801a93:	5b                   	pop    %ebx
  801a94:	5e                   	pop    %esi
  801a95:	5f                   	pop    %edi
  801a96:	5d                   	pop    %ebp
  801a97:	c3                   	ret    
  801a98:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a9d:	89 eb                	mov    %ebp,%ebx
  801a9f:	29 fb                	sub    %edi,%ebx
  801aa1:	89 f9                	mov    %edi,%ecx
  801aa3:	d3 e6                	shl    %cl,%esi
  801aa5:	89 c5                	mov    %eax,%ebp
  801aa7:	88 d9                	mov    %bl,%cl
  801aa9:	d3 ed                	shr    %cl,%ebp
  801aab:	89 e9                	mov    %ebp,%ecx
  801aad:	09 f1                	or     %esi,%ecx
  801aaf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ab3:	89 f9                	mov    %edi,%ecx
  801ab5:	d3 e0                	shl    %cl,%eax
  801ab7:	89 c5                	mov    %eax,%ebp
  801ab9:	89 d6                	mov    %edx,%esi
  801abb:	88 d9                	mov    %bl,%cl
  801abd:	d3 ee                	shr    %cl,%esi
  801abf:	89 f9                	mov    %edi,%ecx
  801ac1:	d3 e2                	shl    %cl,%edx
  801ac3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ac7:	88 d9                	mov    %bl,%cl
  801ac9:	d3 e8                	shr    %cl,%eax
  801acb:	09 c2                	or     %eax,%edx
  801acd:	89 d0                	mov    %edx,%eax
  801acf:	89 f2                	mov    %esi,%edx
  801ad1:	f7 74 24 0c          	divl   0xc(%esp)
  801ad5:	89 d6                	mov    %edx,%esi
  801ad7:	89 c3                	mov    %eax,%ebx
  801ad9:	f7 e5                	mul    %ebp
  801adb:	39 d6                	cmp    %edx,%esi
  801add:	72 19                	jb     801af8 <__udivdi3+0xfc>
  801adf:	74 0b                	je     801aec <__udivdi3+0xf0>
  801ae1:	89 d8                	mov    %ebx,%eax
  801ae3:	31 ff                	xor    %edi,%edi
  801ae5:	e9 58 ff ff ff       	jmp    801a42 <__udivdi3+0x46>
  801aea:	66 90                	xchg   %ax,%ax
  801aec:	8b 54 24 08          	mov    0x8(%esp),%edx
  801af0:	89 f9                	mov    %edi,%ecx
  801af2:	d3 e2                	shl    %cl,%edx
  801af4:	39 c2                	cmp    %eax,%edx
  801af6:	73 e9                	jae    801ae1 <__udivdi3+0xe5>
  801af8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801afb:	31 ff                	xor    %edi,%edi
  801afd:	e9 40 ff ff ff       	jmp    801a42 <__udivdi3+0x46>
  801b02:	66 90                	xchg   %ax,%ax
  801b04:	31 c0                	xor    %eax,%eax
  801b06:	e9 37 ff ff ff       	jmp    801a42 <__udivdi3+0x46>
  801b0b:	90                   	nop

00801b0c <__umoddi3>:
  801b0c:	55                   	push   %ebp
  801b0d:	57                   	push   %edi
  801b0e:	56                   	push   %esi
  801b0f:	53                   	push   %ebx
  801b10:	83 ec 1c             	sub    $0x1c,%esp
  801b13:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b17:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b1f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b23:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b27:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b2b:	89 f3                	mov    %esi,%ebx
  801b2d:	89 fa                	mov    %edi,%edx
  801b2f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b33:	89 34 24             	mov    %esi,(%esp)
  801b36:	85 c0                	test   %eax,%eax
  801b38:	75 1a                	jne    801b54 <__umoddi3+0x48>
  801b3a:	39 f7                	cmp    %esi,%edi
  801b3c:	0f 86 a2 00 00 00    	jbe    801be4 <__umoddi3+0xd8>
  801b42:	89 c8                	mov    %ecx,%eax
  801b44:	89 f2                	mov    %esi,%edx
  801b46:	f7 f7                	div    %edi
  801b48:	89 d0                	mov    %edx,%eax
  801b4a:	31 d2                	xor    %edx,%edx
  801b4c:	83 c4 1c             	add    $0x1c,%esp
  801b4f:	5b                   	pop    %ebx
  801b50:	5e                   	pop    %esi
  801b51:	5f                   	pop    %edi
  801b52:	5d                   	pop    %ebp
  801b53:	c3                   	ret    
  801b54:	39 f0                	cmp    %esi,%eax
  801b56:	0f 87 ac 00 00 00    	ja     801c08 <__umoddi3+0xfc>
  801b5c:	0f bd e8             	bsr    %eax,%ebp
  801b5f:	83 f5 1f             	xor    $0x1f,%ebp
  801b62:	0f 84 ac 00 00 00    	je     801c14 <__umoddi3+0x108>
  801b68:	bf 20 00 00 00       	mov    $0x20,%edi
  801b6d:	29 ef                	sub    %ebp,%edi
  801b6f:	89 fe                	mov    %edi,%esi
  801b71:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b75:	89 e9                	mov    %ebp,%ecx
  801b77:	d3 e0                	shl    %cl,%eax
  801b79:	89 d7                	mov    %edx,%edi
  801b7b:	89 f1                	mov    %esi,%ecx
  801b7d:	d3 ef                	shr    %cl,%edi
  801b7f:	09 c7                	or     %eax,%edi
  801b81:	89 e9                	mov    %ebp,%ecx
  801b83:	d3 e2                	shl    %cl,%edx
  801b85:	89 14 24             	mov    %edx,(%esp)
  801b88:	89 d8                	mov    %ebx,%eax
  801b8a:	d3 e0                	shl    %cl,%eax
  801b8c:	89 c2                	mov    %eax,%edx
  801b8e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b92:	d3 e0                	shl    %cl,%eax
  801b94:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b98:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b9c:	89 f1                	mov    %esi,%ecx
  801b9e:	d3 e8                	shr    %cl,%eax
  801ba0:	09 d0                	or     %edx,%eax
  801ba2:	d3 eb                	shr    %cl,%ebx
  801ba4:	89 da                	mov    %ebx,%edx
  801ba6:	f7 f7                	div    %edi
  801ba8:	89 d3                	mov    %edx,%ebx
  801baa:	f7 24 24             	mull   (%esp)
  801bad:	89 c6                	mov    %eax,%esi
  801baf:	89 d1                	mov    %edx,%ecx
  801bb1:	39 d3                	cmp    %edx,%ebx
  801bb3:	0f 82 87 00 00 00    	jb     801c40 <__umoddi3+0x134>
  801bb9:	0f 84 91 00 00 00    	je     801c50 <__umoddi3+0x144>
  801bbf:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bc3:	29 f2                	sub    %esi,%edx
  801bc5:	19 cb                	sbb    %ecx,%ebx
  801bc7:	89 d8                	mov    %ebx,%eax
  801bc9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bcd:	d3 e0                	shl    %cl,%eax
  801bcf:	89 e9                	mov    %ebp,%ecx
  801bd1:	d3 ea                	shr    %cl,%edx
  801bd3:	09 d0                	or     %edx,%eax
  801bd5:	89 e9                	mov    %ebp,%ecx
  801bd7:	d3 eb                	shr    %cl,%ebx
  801bd9:	89 da                	mov    %ebx,%edx
  801bdb:	83 c4 1c             	add    $0x1c,%esp
  801bde:	5b                   	pop    %ebx
  801bdf:	5e                   	pop    %esi
  801be0:	5f                   	pop    %edi
  801be1:	5d                   	pop    %ebp
  801be2:	c3                   	ret    
  801be3:	90                   	nop
  801be4:	89 fd                	mov    %edi,%ebp
  801be6:	85 ff                	test   %edi,%edi
  801be8:	75 0b                	jne    801bf5 <__umoddi3+0xe9>
  801bea:	b8 01 00 00 00       	mov    $0x1,%eax
  801bef:	31 d2                	xor    %edx,%edx
  801bf1:	f7 f7                	div    %edi
  801bf3:	89 c5                	mov    %eax,%ebp
  801bf5:	89 f0                	mov    %esi,%eax
  801bf7:	31 d2                	xor    %edx,%edx
  801bf9:	f7 f5                	div    %ebp
  801bfb:	89 c8                	mov    %ecx,%eax
  801bfd:	f7 f5                	div    %ebp
  801bff:	89 d0                	mov    %edx,%eax
  801c01:	e9 44 ff ff ff       	jmp    801b4a <__umoddi3+0x3e>
  801c06:	66 90                	xchg   %ax,%ax
  801c08:	89 c8                	mov    %ecx,%eax
  801c0a:	89 f2                	mov    %esi,%edx
  801c0c:	83 c4 1c             	add    $0x1c,%esp
  801c0f:	5b                   	pop    %ebx
  801c10:	5e                   	pop    %esi
  801c11:	5f                   	pop    %edi
  801c12:	5d                   	pop    %ebp
  801c13:	c3                   	ret    
  801c14:	3b 04 24             	cmp    (%esp),%eax
  801c17:	72 06                	jb     801c1f <__umoddi3+0x113>
  801c19:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c1d:	77 0f                	ja     801c2e <__umoddi3+0x122>
  801c1f:	89 f2                	mov    %esi,%edx
  801c21:	29 f9                	sub    %edi,%ecx
  801c23:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c27:	89 14 24             	mov    %edx,(%esp)
  801c2a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c2e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c32:	8b 14 24             	mov    (%esp),%edx
  801c35:	83 c4 1c             	add    $0x1c,%esp
  801c38:	5b                   	pop    %ebx
  801c39:	5e                   	pop    %esi
  801c3a:	5f                   	pop    %edi
  801c3b:	5d                   	pop    %ebp
  801c3c:	c3                   	ret    
  801c3d:	8d 76 00             	lea    0x0(%esi),%esi
  801c40:	2b 04 24             	sub    (%esp),%eax
  801c43:	19 fa                	sbb    %edi,%edx
  801c45:	89 d1                	mov    %edx,%ecx
  801c47:	89 c6                	mov    %eax,%esi
  801c49:	e9 71 ff ff ff       	jmp    801bbf <__umoddi3+0xb3>
  801c4e:	66 90                	xchg   %ax,%ax
  801c50:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c54:	72 ea                	jb     801c40 <__umoddi3+0x134>
  801c56:	89 d9                	mov    %ebx,%ecx
  801c58:	e9 62 ff ff ff       	jmp    801bbf <__umoddi3+0xb3>
