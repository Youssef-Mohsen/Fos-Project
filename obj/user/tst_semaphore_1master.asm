
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
  80004e:	68 e0 3d 80 00       	push   $0x803de0
  800053:	50                   	push   %eax
  800054:	e8 ca 19 00 00       	call   801a23 <create_semaphore>
  800059:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = create_semaphore("depend1", 0);
  80005c:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 00                	push   $0x0
  800064:	68 e4 3d 80 00       	push   $0x803de4
  800069:	50                   	push   %eax
  80006a:	e8 b4 19 00 00       	call   801a23 <create_semaphore>
  80006f:	83 c4 0c             	add    $0xc,%esp

	int id1, id2, id3;
	id1 = sys_create_env("sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800072:	a1 20 50 80 00       	mov    0x805020,%eax
  800077:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  80007d:	a1 20 50 80 00       	mov    0x805020,%eax
  800082:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800088:	89 c1                	mov    %eax,%ecx
  80008a:	a1 20 50 80 00       	mov    0x805020,%eax
  80008f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800095:	52                   	push   %edx
  800096:	51                   	push   %ecx
  800097:	50                   	push   %eax
  800098:	68 ec 3d 80 00       	push   $0x803dec
  80009d:	e8 37 15 00 00       	call   8015d9 <sys_create_env>
  8000a2:	83 c4 10             	add    $0x10,%esp
  8000a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	id2 = sys_create_env("sem1Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000a8:	a1 20 50 80 00       	mov    0x805020,%eax
  8000ad:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  8000b3:	a1 20 50 80 00       	mov    0x805020,%eax
  8000b8:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8000be:	89 c1                	mov    %eax,%ecx
  8000c0:	a1 20 50 80 00       	mov    0x805020,%eax
  8000c5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000cb:	52                   	push   %edx
  8000cc:	51                   	push   %ecx
  8000cd:	50                   	push   %eax
  8000ce:	68 ec 3d 80 00       	push   $0x803dec
  8000d3:	e8 01 15 00 00       	call   8015d9 <sys_create_env>
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	89 45 ec             	mov    %eax,-0x14(%ebp)
	id3 = sys_create_env("sem1Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000de:	a1 20 50 80 00       	mov    0x805020,%eax
  8000e3:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  8000e9:	a1 20 50 80 00       	mov    0x805020,%eax
  8000ee:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8000f4:	89 c1                	mov    %eax,%ecx
  8000f6:	a1 20 50 80 00       	mov    0x805020,%eax
  8000fb:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800101:	52                   	push   %edx
  800102:	51                   	push   %ecx
  800103:	50                   	push   %eax
  800104:	68 ec 3d 80 00       	push   $0x803dec
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
  800144:	e8 99 19 00 00       	call   801ae2 <wait_semaphore>
  800149:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(depend1);
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	ff 75 d8             	pushl  -0x28(%ebp)
  800152:	e8 8b 19 00 00       	call   801ae2 <wait_semaphore>
  800157:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(depend1);
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	ff 75 d8             	pushl  -0x28(%ebp)
  800160:	e8 7d 19 00 00       	call   801ae2 <wait_semaphore>
  800165:	83 c4 10             	add    $0x10,%esp

	int sem1val = semaphore_count(cs1);
  800168:	83 ec 0c             	sub    $0xc,%esp
  80016b:	ff 75 dc             	pushl  -0x24(%ebp)
  80016e:	e8 63 1a 00 00       	call   801bd6 <semaphore_count>
  800173:	83 c4 10             	add    $0x10,%esp
  800176:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int sem2val = semaphore_count(depend1);
  800179:	83 ec 0c             	sub    $0xc,%esp
  80017c:	ff 75 d8             	pushl  -0x28(%ebp)
  80017f:	e8 52 1a 00 00       	call   801bd6 <semaphore_count>
  800184:	83 c4 10             	add    $0x10,%esp
  800187:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (sem2val == 0 && sem1val == 1)
  80018a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80018e:	75 18                	jne    8001a8 <_main+0x170>
  800190:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  800194:	75 12                	jne    8001a8 <_main+0x170>
		cprintf("Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
  800196:	83 ec 0c             	sub    $0xc,%esp
  800199:	68 f8 3d 80 00       	push   $0x803df8
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
  8001b5:	68 40 3e 80 00       	push   $0x803e40
  8001ba:	6a 1f                	push   $0x1f
  8001bc:	68 ac 3e 80 00       	push   $0x803eac
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
  8001fd:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800202:	a1 20 50 80 00       	mov    0x805020,%eax
  800207:	8a 40 20             	mov    0x20(%eax),%al
  80020a:	84 c0                	test   %al,%al
  80020c:	74 0d                	je     80021b <libmain+0x53>
		binaryname = myEnv->prog_name;
  80020e:	a1 20 50 80 00       	mov    0x805020,%eax
  800213:	83 c0 20             	add    $0x20,%eax
  800216:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80021b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80021f:	7e 0a                	jle    80022b <libmain+0x63>
		binaryname = argv[0];
  800221:	8b 45 0c             	mov    0xc(%ebp),%eax
  800224:	8b 00                	mov    (%eax),%eax
  800226:	a3 00 50 80 00       	mov    %eax,0x805000

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
  800244:	68 e4 3e 80 00       	push   $0x803ee4
  800249:	e8 76 03 00 00       	call   8005c4 <cprintf>
  80024e:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800251:	a1 20 50 80 00       	mov    0x805020,%eax
  800256:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80025c:	a1 20 50 80 00       	mov    0x805020,%eax
  800261:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	52                   	push   %edx
  80026b:	50                   	push   %eax
  80026c:	68 0c 3f 80 00       	push   $0x803f0c
  800271:	e8 4e 03 00 00       	call   8005c4 <cprintf>
  800276:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800279:	a1 20 50 80 00       	mov    0x805020,%eax
  80027e:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800284:	a1 20 50 80 00       	mov    0x805020,%eax
  800289:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80028f:	a1 20 50 80 00       	mov    0x805020,%eax
  800294:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80029a:	51                   	push   %ecx
  80029b:	52                   	push   %edx
  80029c:	50                   	push   %eax
  80029d:	68 34 3f 80 00       	push   $0x803f34
  8002a2:	e8 1d 03 00 00       	call   8005c4 <cprintf>
  8002a7:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8002af:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8002b5:	83 ec 08             	sub    $0x8,%esp
  8002b8:	50                   	push   %eax
  8002b9:	68 8c 3f 80 00       	push   $0x803f8c
  8002be:	e8 01 03 00 00       	call   8005c4 <cprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002c6:	83 ec 0c             	sub    $0xc,%esp
  8002c9:	68 e4 3e 80 00       	push   $0x803ee4
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
  800316:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80031b:	85 c0                	test   %eax,%eax
  80031d:	74 16                	je     800335 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80031f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800324:	83 ec 08             	sub    $0x8,%esp
  800327:	50                   	push   %eax
  800328:	68 a0 3f 80 00       	push   $0x803fa0
  80032d:	e8 92 02 00 00       	call   8005c4 <cprintf>
  800332:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800335:	a1 00 50 80 00       	mov    0x805000,%eax
  80033a:	ff 75 0c             	pushl  0xc(%ebp)
  80033d:	ff 75 08             	pushl  0x8(%ebp)
  800340:	50                   	push   %eax
  800341:	68 a5 3f 80 00       	push   $0x803fa5
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
  800365:	68 c1 3f 80 00       	push   $0x803fc1
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
  80037f:	a1 20 50 80 00       	mov    0x805020,%eax
  800384:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80038a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038d:	39 c2                	cmp    %eax,%edx
  80038f:	74 14                	je     8003a5 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800391:	83 ec 04             	sub    $0x4,%esp
  800394:	68 c4 3f 80 00       	push   $0x803fc4
  800399:	6a 26                	push   $0x26
  80039b:	68 10 40 80 00       	push   $0x804010
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
  8003e5:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800405:	a1 20 50 80 00       	mov    0x805020,%eax
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
  80044e:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800469:	68 1c 40 80 00       	push   $0x80401c
  80046e:	6a 3a                	push   $0x3a
  800470:	68 10 40 80 00       	push   $0x804010
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
  800499:	a1 20 50 80 00       	mov    0x805020,%eax
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
  8004bf:	a1 20 50 80 00       	mov    0x805020,%eax
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
  8004dc:	68 70 40 80 00       	push   $0x804070
  8004e1:	6a 44                	push   $0x44
  8004e3:	68 10 40 80 00       	push   $0x804010
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
  80051b:	a0 28 50 80 00       	mov    0x805028,%al
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
  800590:	a0 28 50 80 00       	mov    0x805028,%al
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
  8005b5:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
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
  8005ca:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
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
  800661:	e8 16 35 00 00       	call   803b7c <__udivdi3>
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
  8006b1:	e8 d6 35 00 00       	call   803c8c <__umoddi3>
  8006b6:	83 c4 10             	add    $0x10,%esp
  8006b9:	05 d4 42 80 00       	add    $0x8042d4,%eax
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
  80080c:	8b 04 85 f8 42 80 00 	mov    0x8042f8(,%eax,4),%eax
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
  8008ed:	8b 34 9d 40 41 80 00 	mov    0x804140(,%ebx,4),%esi
  8008f4:	85 f6                	test   %esi,%esi
  8008f6:	75 19                	jne    800911 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008f8:	53                   	push   %ebx
  8008f9:	68 e5 42 80 00       	push   $0x8042e5
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
  800912:	68 ee 42 80 00       	push   $0x8042ee
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
  80093f:	be f1 42 80 00       	mov    $0x8042f1,%esi
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
  800b37:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800b3e:	eb 2c                	jmp    800b6c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b40:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
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
  80134a:	68 68 44 80 00       	push   $0x804468
  80134f:	68 3f 01 00 00       	push   $0x13f
  801354:	68 8a 44 80 00       	push   $0x80448a
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

00801987 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 2e                	push   $0x2e
  801999:	e8 c0 f9 ff ff       	call   80135e <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
  8019a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  8019a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  8019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	50                   	push   %eax
  8019b8:	6a 2f                	push   $0x2f
  8019ba:	e8 9f f9 ff ff       	call   80135e <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp
	return;
  8019c2:	90                   	nop
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  8019c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	52                   	push   %edx
  8019d5:	50                   	push   %eax
  8019d6:	6a 30                	push   $0x30
  8019d8:	e8 81 f9 ff ff       	call   80135e <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
	return;
  8019e0:	90                   	nop
}
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	50                   	push   %eax
  8019f5:	6a 31                	push   $0x31
  8019f7:	e8 62 f9 ff ff       	call   80135e <syscall>
  8019fc:	83 c4 18             	add    $0x18,%esp
  8019ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801a02:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	50                   	push   %eax
  801a16:	6a 32                	push   $0x32
  801a18:	e8 41 f9 ff ff       	call   80135e <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
	return;
  801a20:	90                   	nop
}
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("create_semaphore is not implemented yet");
	//Your Code is Here...

		void* ret = smalloc(semaphoreName, sizeof(struct semaphore), 1);
  801a29:	83 ec 04             	sub    $0x4,%esp
  801a2c:	6a 01                	push   $0x1
  801a2e:	6a 04                	push   $0x4
  801a30:	ff 75 0c             	pushl  0xc(%ebp)
  801a33:	e8 dd 04 00 00       	call   801f15 <smalloc>
  801a38:	83 c4 10             	add    $0x10,%esp
  801a3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if (ret == NULL ) panic("no memory in creat_semaphore");
  801a3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a42:	75 14                	jne    801a58 <create_semaphore+0x35>
  801a44:	83 ec 04             	sub    $0x4,%esp
  801a47:	68 97 44 80 00       	push   $0x804497
  801a4c:	6a 0d                	push   $0xd
  801a4e:	68 b4 44 80 00       	push   $0x8044b4
  801a53:	e8 af e8 ff ff       	call   800307 <_panic>

	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  801a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	    sem_ptr->semdata->count = value;
  801a5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a61:	8b 00                	mov    (%eax),%eax
  801a63:	8b 55 10             	mov    0x10(%ebp),%edx
  801a66:	89 50 10             	mov    %edx,0x10(%eax)
	    sys_init_queue(&(sem_ptr->semdata->queue));
  801a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a6c:	8b 00                	mov    (%eax),%eax
  801a6e:	83 ec 0c             	sub    $0xc,%esp
  801a71:	50                   	push   %eax
  801a72:	e8 32 ff ff ff       	call   8019a9 <sys_init_queue>
  801a77:	83 c4 10             	add    $0x10,%esp

	    sem_ptr->semdata->lock = 0;
  801a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7d:	8b 00                	mov    (%eax),%eax
  801a7f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

	    return *sem_ptr;
  801a86:	8b 45 08             	mov    0x8(%ebp),%eax
  801a89:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a8c:	8b 12                	mov    (%edx),%edx
  801a8e:	89 10                	mov    %edx,(%eax)
}
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	c9                   	leave  
  801a94:	c2 04 00             	ret    $0x4

00801a97 <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
  801a9a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("get_semaphore is not implemented yet");
	//Your Code is Here...
		void* ret = sget(ownerEnvID, semaphoreName);
  801a9d:	83 ec 08             	sub    $0x8,%esp
  801aa0:	ff 75 10             	pushl  0x10(%ebp)
  801aa3:	ff 75 0c             	pushl  0xc(%ebp)
  801aa6:	e8 0f 05 00 00       	call   801fba <sget>
  801aab:	83 c4 10             	add    $0x10,%esp
  801aae:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (ret == NULL ) panic("no semaphore in get_semaphore");
  801ab1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ab5:	75 14                	jne    801acb <get_semaphore+0x34>
  801ab7:	83 ec 04             	sub    $0x4,%esp
  801aba:	68 c4 44 80 00       	push   $0x8044c4
  801abf:	6a 1f                	push   $0x1f
  801ac1:	68 b4 44 80 00       	push   $0x8044b4
  801ac6:	e8 3c e8 ff ff       	call   800307 <_panic>
	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  801acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ace:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    return *sem_ptr;
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ad7:	8b 12                	mov    (%edx),%edx
  801ad9:	89 10                	mov    %edx,(%eax)
}
  801adb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ade:	c9                   	leave  
  801adf:	c2 04 00             	ret    $0x4

00801ae2 <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("wait_semaphore is not implemented yet");
	//Your Code is Here...
			uint32 key = 1;
  801ae8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
		    do { xchg(&sem.semdata->lock,key); } while (key != 0);
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	83 c0 14             	add    $0x14,%eax
  801af5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afb:	89 45 e8             	mov    %eax,-0x18(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  801afe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b04:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  801b07:	f0 87 02             	lock xchg %eax,(%edx)
  801b0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b11:	75 dc                	jne    801aef <wait_semaphore+0xd>

		    sem.semdata->count--;
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	8b 50 10             	mov    0x10(%eax),%edx
  801b19:	4a                   	dec    %edx
  801b1a:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count < 0) {
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	8b 40 10             	mov    0x10(%eax),%eax
  801b23:	85 c0                	test   %eax,%eax
  801b25:	79 30                	jns    801b57 <wait_semaphore+0x75>

	    	struct Env* cur_env = sys_get_cpu_process();
  801b27:	e8 5b fe ff ff       	call   801987 <sys_get_cpu_process>
  801b2c:	89 45 f0             	mov    %eax,-0x10(%ebp)

//	    	acquire_spinlock(&ProcessQueues.qlock); //acquire procque
	        sys_enqueue(&(sem.semdata->queue),cur_env);  // Add process to waiting queue
  801b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b32:	83 ec 08             	sub    $0x8,%esp
  801b35:	ff 75 f0             	pushl  -0x10(%ebp)
  801b38:	50                   	push   %eax
  801b39:	e8 87 fe ff ff       	call   8019c5 <sys_enqueue>
  801b3e:	83 c4 10             	add    $0x10,%esp
	        cur_env->env_status= ENV_BLOCKED;
  801b41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b44:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%eax)
	        sem.semdata->lock = 0;
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;

}
  801b55:	eb 0a                	jmp    801b61 <wait_semaphore+0x7f>
	        cur_env->env_status= ENV_BLOCKED;
	        sem.semdata->lock = 0;
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

}
  801b61:	90                   	nop
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
  801b67:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("signal_semaphore is not implemented yet");
	//Your Code is Here...
		uint32 key = 1;
  801b6a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	    do { xchg(&sem.semdata->lock,key ); } while (key != 0);
  801b71:	8b 45 08             	mov    0x8(%ebp),%eax
  801b74:	83 c0 14             	add    $0x14,%eax
  801b77:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b7d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b80:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b86:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  801b89:	f0 87 02             	lock xchg %eax,(%edx)
  801b8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b93:	75 dc                	jne    801b71 <signal_semaphore+0xd>
	    sem.semdata->count++;
  801b95:	8b 45 08             	mov    0x8(%ebp),%eax
  801b98:	8b 50 10             	mov    0x10(%eax),%edx
  801b9b:	42                   	inc    %edx
  801b9c:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count <= 0) {
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	8b 40 10             	mov    0x10(%eax),%eax
  801ba5:	85 c0                	test   %eax,%eax
  801ba7:	7f 20                	jg     801bc9 <signal_semaphore+0x65>
	        struct Env* env = sys_dequeue(&(sem.semdata->queue)) ;
  801ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bac:	83 ec 0c             	sub    $0xc,%esp
  801baf:	50                   	push   %eax
  801bb0:	e8 2e fe ff ff       	call   8019e3 <sys_dequeue>
  801bb5:	83 c4 10             	add    $0x10,%esp
  801bb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	        sys_sched_insert_ready(env);
  801bbb:	83 ec 0c             	sub    $0xc,%esp
  801bbe:	ff 75 f0             	pushl  -0x10(%ebp)
  801bc1:	e8 41 fe ff ff       	call   801a07 <sys_sched_insert_ready>
  801bc6:	83 c4 10             	add    $0x10,%esp
	    }
	    sem.semdata->lock = 0;
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  801bd3:	90                   	nop
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	8b 40 10             	mov    0x10(%eax),%eax
}
  801bdf:	5d                   	pop    %ebp
  801be0:	c3                   	ret    

00801be1 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801be7:	83 ec 0c             	sub    $0xc,%esp
  801bea:	ff 75 08             	pushl  0x8(%ebp)
  801bed:	e8 42 fd ff ff       	call   801934 <sys_sbrk>
  801bf2:	83 c4 10             	add    $0x10,%esp
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801bfd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c01:	75 0a                	jne    801c0d <malloc+0x16>
  801c03:	b8 00 00 00 00       	mov    $0x0,%eax
  801c08:	e9 07 02 00 00       	jmp    801e14 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801c0d:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801c14:	8b 55 08             	mov    0x8(%ebp),%edx
  801c17:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c1a:	01 d0                	add    %edx,%eax
  801c1c:	48                   	dec    %eax
  801c1d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801c20:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c23:	ba 00 00 00 00       	mov    $0x0,%edx
  801c28:	f7 75 dc             	divl   -0x24(%ebp)
  801c2b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c2e:	29 d0                	sub    %edx,%eax
  801c30:	c1 e8 0c             	shr    $0xc,%eax
  801c33:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801c36:	a1 20 50 80 00       	mov    0x805020,%eax
  801c3b:	8b 40 78             	mov    0x78(%eax),%eax
  801c3e:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801c43:	29 c2                	sub    %eax,%edx
  801c45:	89 d0                	mov    %edx,%eax
  801c47:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801c4a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801c4d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c52:	c1 e8 0c             	shr    $0xc,%eax
  801c55:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801c58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801c5f:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801c66:	77 42                	ja     801caa <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801c68:	e8 4b fb ff ff       	call   8017b8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c6d:	85 c0                	test   %eax,%eax
  801c6f:	74 16                	je     801c87 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  801c71:	83 ec 0c             	sub    $0xc,%esp
  801c74:	ff 75 08             	pushl  0x8(%ebp)
  801c77:	e8 18 08 00 00       	call   802494 <alloc_block_FF>
  801c7c:	83 c4 10             	add    $0x10,%esp
  801c7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c82:	e9 8a 01 00 00       	jmp    801e11 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801c87:	e8 5d fb ff ff       	call   8017e9 <sys_isUHeapPlacementStrategyBESTFIT>
  801c8c:	85 c0                	test   %eax,%eax
  801c8e:	0f 84 7d 01 00 00    	je     801e11 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801c94:	83 ec 0c             	sub    $0xc,%esp
  801c97:	ff 75 08             	pushl  0x8(%ebp)
  801c9a:	e8 b1 0c 00 00       	call   802950 <alloc_block_BF>
  801c9f:	83 c4 10             	add    $0x10,%esp
  801ca2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ca5:	e9 67 01 00 00       	jmp    801e11 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801caa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801cad:	48                   	dec    %eax
  801cae:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801cb1:	0f 86 53 01 00 00    	jbe    801e0a <malloc+0x213>
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801cb7:	a1 20 50 80 00       	mov    0x805020,%eax
  801cbc:	8b 40 78             	mov    0x78(%eax),%eax
  801cbf:	05 00 10 00 00       	add    $0x1000,%eax
  801cc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801cc7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801cce:	e9 de 00 00 00       	jmp    801db1 <malloc+0x1ba>
		{
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801cd3:	a1 20 50 80 00       	mov    0x805020,%eax
  801cd8:	8b 40 78             	mov    0x78(%eax),%eax
  801cdb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cde:	29 c2                	sub    %eax,%edx
  801ce0:	89 d0                	mov    %edx,%eax
  801ce2:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ce7:	c1 e8 0c             	shr    $0xc,%eax
  801cea:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801cf1:	85 c0                	test   %eax,%eax
  801cf3:	0f 85 ab 00 00 00    	jne    801da4 <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cfc:	05 00 10 00 00       	add    $0x1000,%eax
  801d01:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801d04:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
				while(cnt < num_pages - 1)
  801d0b:	eb 47                	jmp    801d54 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801d0d:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801d14:	76 0a                	jbe    801d20 <malloc+0x129>
  801d16:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1b:	e9 f4 00 00 00       	jmp    801e14 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801d20:	a1 20 50 80 00       	mov    0x805020,%eax
  801d25:	8b 40 78             	mov    0x78(%eax),%eax
  801d28:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d2b:	29 c2                	sub    %eax,%edx
  801d2d:	89 d0                	mov    %edx,%eax
  801d2f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d34:	c1 e8 0c             	shr    $0xc,%eax
  801d37:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801d3e:	85 c0                	test   %eax,%eax
  801d40:	74 08                	je     801d4a <malloc+0x153>
					{
						
						i = j;
  801d42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d45:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801d48:	eb 5a                	jmp    801da4 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801d4a:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801d51:	ff 45 e4             	incl   -0x1c(%ebp)
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
				while(cnt < num_pages - 1)
  801d54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d57:	48                   	dec    %eax
  801d58:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801d5b:	77 b0                	ja     801d0d <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801d5d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801d64:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801d6b:	eb 2f                	jmp    801d9c <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801d6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d70:	c1 e0 0c             	shl    $0xc,%eax
  801d73:	89 c2                	mov    %eax,%edx
  801d75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d78:	01 c2                	add    %eax,%edx
  801d7a:	a1 20 50 80 00       	mov    0x805020,%eax
  801d7f:	8b 40 78             	mov    0x78(%eax),%eax
  801d82:	29 c2                	sub    %eax,%edx
  801d84:	89 d0                	mov    %edx,%eax
  801d86:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d8b:	c1 e8 0c             	shr    $0xc,%eax
  801d8e:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
  801d95:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801d99:	ff 45 e0             	incl   -0x20(%ebp)
  801d9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d9f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801da2:	72 c9                	jb     801d6d <malloc+0x176>
				}
				

			}
			sayed:
			if(ok) break;
  801da4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801da8:	75 16                	jne    801dc0 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801daa:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801db1:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801db8:	0f 86 15 ff ff ff    	jbe    801cd3 <malloc+0xdc>
  801dbe:	eb 01                	jmp    801dc1 <malloc+0x1ca>
				}
				

			}
			sayed:
			if(ok) break;
  801dc0:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801dc1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801dc5:	75 07                	jne    801dce <malloc+0x1d7>
  801dc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcc:	eb 46                	jmp    801e14 <malloc+0x21d>
		ptr = (void*)i;
  801dce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801dd4:	a1 20 50 80 00       	mov    0x805020,%eax
  801dd9:	8b 40 78             	mov    0x78(%eax),%eax
  801ddc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ddf:	29 c2                	sub    %eax,%edx
  801de1:	89 d0                	mov    %edx,%eax
  801de3:	2d 00 10 00 00       	sub    $0x1000,%eax
  801de8:	c1 e8 0c             	shr    $0xc,%eax
  801deb:	89 c2                	mov    %eax,%edx
  801ded:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801df0:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801df7:	83 ec 08             	sub    $0x8,%esp
  801dfa:	ff 75 08             	pushl  0x8(%ebp)
  801dfd:	ff 75 f0             	pushl  -0x10(%ebp)
  801e00:	e8 66 fb ff ff       	call   80196b <sys_allocate_user_mem>
  801e05:	83 c4 10             	add    $0x10,%esp
  801e08:	eb 07                	jmp    801e11 <malloc+0x21a>
		
	}
	else
	{
		return NULL;
  801e0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0f:	eb 03                	jmp    801e14 <malloc+0x21d>
	}
	return ptr;
  801e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    

00801e16 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
  801e19:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801e1c:	a1 20 50 80 00       	mov    0x805020,%eax
  801e21:	8b 40 78             	mov    0x78(%eax),%eax
  801e24:	05 00 10 00 00       	add    $0x1000,%eax
  801e29:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801e2c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801e33:	a1 20 50 80 00       	mov    0x805020,%eax
  801e38:	8b 50 78             	mov    0x78(%eax),%edx
  801e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3e:	39 c2                	cmp    %eax,%edx
  801e40:	76 24                	jbe    801e66 <free+0x50>
		size = get_block_size(va);
  801e42:	83 ec 0c             	sub    $0xc,%esp
  801e45:	ff 75 08             	pushl  0x8(%ebp)
  801e48:	e8 c7 02 00 00       	call   802114 <get_block_size>
  801e4d:	83 c4 10             	add    $0x10,%esp
  801e50:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801e53:	83 ec 0c             	sub    $0xc,%esp
  801e56:	ff 75 08             	pushl  0x8(%ebp)
  801e59:	e8 d7 14 00 00       	call   803335 <free_block>
  801e5e:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801e61:	e9 ac 00 00 00       	jmp    801f12 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801e66:	8b 45 08             	mov    0x8(%ebp),%eax
  801e69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e6c:	0f 82 89 00 00 00    	jb     801efb <free+0xe5>
  801e72:	8b 45 08             	mov    0x8(%ebp),%eax
  801e75:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801e7a:	77 7f                	ja     801efb <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801e7c:	8b 55 08             	mov    0x8(%ebp),%edx
  801e7f:	a1 20 50 80 00       	mov    0x805020,%eax
  801e84:	8b 40 78             	mov    0x78(%eax),%eax
  801e87:	29 c2                	sub    %eax,%edx
  801e89:	89 d0                	mov    %edx,%eax
  801e8b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e90:	c1 e8 0c             	shr    $0xc,%eax
  801e93:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  801e9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801e9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ea0:	c1 e0 0c             	shl    $0xc,%eax
  801ea3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801ea6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ead:	eb 42                	jmp    801ef1 <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb2:	c1 e0 0c             	shl    $0xc,%eax
  801eb5:	89 c2                	mov    %eax,%edx
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	01 c2                	add    %eax,%edx
  801ebc:	a1 20 50 80 00       	mov    0x805020,%eax
  801ec1:	8b 40 78             	mov    0x78(%eax),%eax
  801ec4:	29 c2                	sub    %eax,%edx
  801ec6:	89 d0                	mov    %edx,%eax
  801ec8:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ecd:	c1 e8 0c             	shr    $0xc,%eax
  801ed0:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801ed7:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801edb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ede:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee1:	83 ec 08             	sub    $0x8,%esp
  801ee4:	52                   	push   %edx
  801ee5:	50                   	push   %eax
  801ee6:	e8 64 fa ff ff       	call   80194f <sys_free_user_mem>
  801eeb:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801eee:	ff 45 f4             	incl   -0xc(%ebp)
  801ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801ef7:	72 b6                	jb     801eaf <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801ef9:	eb 17                	jmp    801f12 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801efb:	83 ec 04             	sub    $0x4,%esp
  801efe:	68 e4 44 80 00       	push   $0x8044e4
  801f03:	68 87 00 00 00       	push   $0x87
  801f08:	68 0e 45 80 00       	push   $0x80450e
  801f0d:	e8 f5 e3 ff ff       	call   800307 <_panic>
	}
}
  801f12:	90                   	nop
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	83 ec 28             	sub    $0x28,%esp
  801f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1e:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801f21:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f25:	75 0a                	jne    801f31 <smalloc+0x1c>
  801f27:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2c:	e9 87 00 00 00       	jmp    801fb8 <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f37:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f44:	39 d0                	cmp    %edx,%eax
  801f46:	73 02                	jae    801f4a <smalloc+0x35>
  801f48:	89 d0                	mov    %edx,%eax
  801f4a:	83 ec 0c             	sub    $0xc,%esp
  801f4d:	50                   	push   %eax
  801f4e:	e8 a4 fc ff ff       	call   801bf7 <malloc>
  801f53:	83 c4 10             	add    $0x10,%esp
  801f56:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801f59:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f5d:	75 07                	jne    801f66 <smalloc+0x51>
  801f5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f64:	eb 52                	jmp    801fb8 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801f66:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801f6a:	ff 75 ec             	pushl  -0x14(%ebp)
  801f6d:	50                   	push   %eax
  801f6e:	ff 75 0c             	pushl  0xc(%ebp)
  801f71:	ff 75 08             	pushl  0x8(%ebp)
  801f74:	e8 dd f5 ff ff       	call   801556 <sys_createSharedObject>
  801f79:	83 c4 10             	add    $0x10,%esp
  801f7c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801f7f:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801f83:	74 06                	je     801f8b <smalloc+0x76>
  801f85:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801f89:	75 07                	jne    801f92 <smalloc+0x7d>
  801f8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f90:	eb 26                	jmp    801fb8 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801f92:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f95:	a1 20 50 80 00       	mov    0x805020,%eax
  801f9a:	8b 40 78             	mov    0x78(%eax),%eax
  801f9d:	29 c2                	sub    %eax,%edx
  801f9f:	89 d0                	mov    %edx,%eax
  801fa1:	2d 00 10 00 00       	sub    $0x1000,%eax
  801fa6:	c1 e8 0c             	shr    $0xc,%eax
  801fa9:	89 c2                	mov    %eax,%edx
  801fab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fae:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801fb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    

00801fba <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
  801fbd:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801fc0:	83 ec 08             	sub    $0x8,%esp
  801fc3:	ff 75 0c             	pushl  0xc(%ebp)
  801fc6:	ff 75 08             	pushl  0x8(%ebp)
  801fc9:	e8 b2 f5 ff ff       	call   801580 <sys_getSizeOfSharedObject>
  801fce:	83 c4 10             	add    $0x10,%esp
  801fd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801fd4:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801fd8:	75 07                	jne    801fe1 <sget+0x27>
  801fda:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdf:	eb 7f                	jmp    802060 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fe7:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801fee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff4:	39 d0                	cmp    %edx,%eax
  801ff6:	73 02                	jae    801ffa <sget+0x40>
  801ff8:	89 d0                	mov    %edx,%eax
  801ffa:	83 ec 0c             	sub    $0xc,%esp
  801ffd:	50                   	push   %eax
  801ffe:	e8 f4 fb ff ff       	call   801bf7 <malloc>
  802003:	83 c4 10             	add    $0x10,%esp
  802006:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  802009:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80200d:	75 07                	jne    802016 <sget+0x5c>
  80200f:	b8 00 00 00 00       	mov    $0x0,%eax
  802014:	eb 4a                	jmp    802060 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  802016:	83 ec 04             	sub    $0x4,%esp
  802019:	ff 75 e8             	pushl  -0x18(%ebp)
  80201c:	ff 75 0c             	pushl  0xc(%ebp)
  80201f:	ff 75 08             	pushl  0x8(%ebp)
  802022:	e8 76 f5 ff ff       	call   80159d <sys_getSharedObject>
  802027:	83 c4 10             	add    $0x10,%esp
  80202a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  80202d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802030:	a1 20 50 80 00       	mov    0x805020,%eax
  802035:	8b 40 78             	mov    0x78(%eax),%eax
  802038:	29 c2                	sub    %eax,%edx
  80203a:	89 d0                	mov    %edx,%eax
  80203c:	2d 00 10 00 00       	sub    $0x1000,%eax
  802041:	c1 e8 0c             	shr    $0xc,%eax
  802044:	89 c2                	mov    %eax,%edx
  802046:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802049:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802050:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802054:	75 07                	jne    80205d <sget+0xa3>
  802056:	b8 00 00 00 00       	mov    $0x0,%eax
  80205b:	eb 03                	jmp    802060 <sget+0xa6>
	return ptr;
  80205d:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802060:	c9                   	leave  
  802061:	c3                   	ret    

00802062 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
  802065:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  802068:	8b 55 08             	mov    0x8(%ebp),%edx
  80206b:	a1 20 50 80 00       	mov    0x805020,%eax
  802070:	8b 40 78             	mov    0x78(%eax),%eax
  802073:	29 c2                	sub    %eax,%edx
  802075:	89 d0                	mov    %edx,%eax
  802077:	2d 00 10 00 00       	sub    $0x1000,%eax
  80207c:	c1 e8 0c             	shr    $0xc,%eax
  80207f:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  802086:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  802089:	83 ec 08             	sub    $0x8,%esp
  80208c:	ff 75 08             	pushl  0x8(%ebp)
  80208f:	ff 75 f4             	pushl  -0xc(%ebp)
  802092:	e8 25 f5 ff ff       	call   8015bc <sys_freeSharedObject>
  802097:	83 c4 10             	add    $0x10,%esp
  80209a:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  80209d:	90                   	nop
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
  8020a3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8020a6:	83 ec 04             	sub    $0x4,%esp
  8020a9:	68 1c 45 80 00       	push   $0x80451c
  8020ae:	68 e4 00 00 00       	push   $0xe4
  8020b3:	68 0e 45 80 00       	push   $0x80450e
  8020b8:	e8 4a e2 ff ff       	call   800307 <_panic>

008020bd <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
  8020c0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020c3:	83 ec 04             	sub    $0x4,%esp
  8020c6:	68 42 45 80 00       	push   $0x804542
  8020cb:	68 f0 00 00 00       	push   $0xf0
  8020d0:	68 0e 45 80 00       	push   $0x80450e
  8020d5:	e8 2d e2 ff ff       	call   800307 <_panic>

008020da <shrink>:

}
void shrink(uint32 newSize)
{
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
  8020dd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020e0:	83 ec 04             	sub    $0x4,%esp
  8020e3:	68 42 45 80 00       	push   $0x804542
  8020e8:	68 f5 00 00 00       	push   $0xf5
  8020ed:	68 0e 45 80 00       	push   $0x80450e
  8020f2:	e8 10 e2 ff ff       	call   800307 <_panic>

008020f7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
  8020fa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020fd:	83 ec 04             	sub    $0x4,%esp
  802100:	68 42 45 80 00       	push   $0x804542
  802105:	68 fa 00 00 00       	push   $0xfa
  80210a:	68 0e 45 80 00       	push   $0x80450e
  80210f:	e8 f3 e1 ff ff       	call   800307 <_panic>

00802114 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
  802117:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
  80211d:	83 e8 04             	sub    $0x4,%eax
  802120:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802123:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802126:	8b 00                	mov    (%eax),%eax
  802128:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80212b:	c9                   	leave  
  80212c:	c3                   	ret    

0080212d <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
  802130:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802133:	8b 45 08             	mov    0x8(%ebp),%eax
  802136:	83 e8 04             	sub    $0x4,%eax
  802139:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80213c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80213f:	8b 00                	mov    (%eax),%eax
  802141:	83 e0 01             	and    $0x1,%eax
  802144:	85 c0                	test   %eax,%eax
  802146:	0f 94 c0             	sete   %al
}
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

0080214b <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802151:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215b:	83 f8 02             	cmp    $0x2,%eax
  80215e:	74 2b                	je     80218b <alloc_block+0x40>
  802160:	83 f8 02             	cmp    $0x2,%eax
  802163:	7f 07                	jg     80216c <alloc_block+0x21>
  802165:	83 f8 01             	cmp    $0x1,%eax
  802168:	74 0e                	je     802178 <alloc_block+0x2d>
  80216a:	eb 58                	jmp    8021c4 <alloc_block+0x79>
  80216c:	83 f8 03             	cmp    $0x3,%eax
  80216f:	74 2d                	je     80219e <alloc_block+0x53>
  802171:	83 f8 04             	cmp    $0x4,%eax
  802174:	74 3b                	je     8021b1 <alloc_block+0x66>
  802176:	eb 4c                	jmp    8021c4 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802178:	83 ec 0c             	sub    $0xc,%esp
  80217b:	ff 75 08             	pushl  0x8(%ebp)
  80217e:	e8 11 03 00 00       	call   802494 <alloc_block_FF>
  802183:	83 c4 10             	add    $0x10,%esp
  802186:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802189:	eb 4a                	jmp    8021d5 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80218b:	83 ec 0c             	sub    $0xc,%esp
  80218e:	ff 75 08             	pushl  0x8(%ebp)
  802191:	e8 c7 19 00 00       	call   803b5d <alloc_block_NF>
  802196:	83 c4 10             	add    $0x10,%esp
  802199:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80219c:	eb 37                	jmp    8021d5 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80219e:	83 ec 0c             	sub    $0xc,%esp
  8021a1:	ff 75 08             	pushl  0x8(%ebp)
  8021a4:	e8 a7 07 00 00       	call   802950 <alloc_block_BF>
  8021a9:	83 c4 10             	add    $0x10,%esp
  8021ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021af:	eb 24                	jmp    8021d5 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8021b1:	83 ec 0c             	sub    $0xc,%esp
  8021b4:	ff 75 08             	pushl  0x8(%ebp)
  8021b7:	e8 84 19 00 00       	call   803b40 <alloc_block_WF>
  8021bc:	83 c4 10             	add    $0x10,%esp
  8021bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021c2:	eb 11                	jmp    8021d5 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8021c4:	83 ec 0c             	sub    $0xc,%esp
  8021c7:	68 54 45 80 00       	push   $0x804554
  8021cc:	e8 f3 e3 ff ff       	call   8005c4 <cprintf>
  8021d1:	83 c4 10             	add    $0x10,%esp
		break;
  8021d4:	90                   	nop
	}
	return va;
  8021d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8021d8:	c9                   	leave  
  8021d9:	c3                   	ret    

008021da <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
  8021dd:	53                   	push   %ebx
  8021de:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8021e1:	83 ec 0c             	sub    $0xc,%esp
  8021e4:	68 74 45 80 00       	push   $0x804574
  8021e9:	e8 d6 e3 ff ff       	call   8005c4 <cprintf>
  8021ee:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8021f1:	83 ec 0c             	sub    $0xc,%esp
  8021f4:	68 9f 45 80 00       	push   $0x80459f
  8021f9:	e8 c6 e3 ff ff       	call   8005c4 <cprintf>
  8021fe:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802207:	eb 37                	jmp    802240 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802209:	83 ec 0c             	sub    $0xc,%esp
  80220c:	ff 75 f4             	pushl  -0xc(%ebp)
  80220f:	e8 19 ff ff ff       	call   80212d <is_free_block>
  802214:	83 c4 10             	add    $0x10,%esp
  802217:	0f be d8             	movsbl %al,%ebx
  80221a:	83 ec 0c             	sub    $0xc,%esp
  80221d:	ff 75 f4             	pushl  -0xc(%ebp)
  802220:	e8 ef fe ff ff       	call   802114 <get_block_size>
  802225:	83 c4 10             	add    $0x10,%esp
  802228:	83 ec 04             	sub    $0x4,%esp
  80222b:	53                   	push   %ebx
  80222c:	50                   	push   %eax
  80222d:	68 b7 45 80 00       	push   $0x8045b7
  802232:	e8 8d e3 ff ff       	call   8005c4 <cprintf>
  802237:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80223a:	8b 45 10             	mov    0x10(%ebp),%eax
  80223d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802240:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802244:	74 07                	je     80224d <print_blocks_list+0x73>
  802246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802249:	8b 00                	mov    (%eax),%eax
  80224b:	eb 05                	jmp    802252 <print_blocks_list+0x78>
  80224d:	b8 00 00 00 00       	mov    $0x0,%eax
  802252:	89 45 10             	mov    %eax,0x10(%ebp)
  802255:	8b 45 10             	mov    0x10(%ebp),%eax
  802258:	85 c0                	test   %eax,%eax
  80225a:	75 ad                	jne    802209 <print_blocks_list+0x2f>
  80225c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802260:	75 a7                	jne    802209 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802262:	83 ec 0c             	sub    $0xc,%esp
  802265:	68 74 45 80 00       	push   $0x804574
  80226a:	e8 55 e3 ff ff       	call   8005c4 <cprintf>
  80226f:	83 c4 10             	add    $0x10,%esp

}
  802272:	90                   	nop
  802273:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802276:	c9                   	leave  
  802277:	c3                   	ret    

00802278 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802278:	55                   	push   %ebp
  802279:	89 e5                	mov    %esp,%ebp
  80227b:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80227e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802281:	83 e0 01             	and    $0x1,%eax
  802284:	85 c0                	test   %eax,%eax
  802286:	74 03                	je     80228b <initialize_dynamic_allocator+0x13>
  802288:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80228b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80228f:	0f 84 c7 01 00 00    	je     80245c <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802295:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80229c:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80229f:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a5:	01 d0                	add    %edx,%eax
  8022a7:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8022ac:	0f 87 ad 01 00 00    	ja     80245f <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8022b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b5:	85 c0                	test   %eax,%eax
  8022b7:	0f 89 a5 01 00 00    	jns    802462 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8022bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c3:	01 d0                	add    %edx,%eax
  8022c5:	83 e8 04             	sub    $0x4,%eax
  8022c8:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8022cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8022d4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022dc:	e9 87 00 00 00       	jmp    802368 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8022e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e5:	75 14                	jne    8022fb <initialize_dynamic_allocator+0x83>
  8022e7:	83 ec 04             	sub    $0x4,%esp
  8022ea:	68 cf 45 80 00       	push   $0x8045cf
  8022ef:	6a 79                	push   $0x79
  8022f1:	68 ed 45 80 00       	push   $0x8045ed
  8022f6:	e8 0c e0 ff ff       	call   800307 <_panic>
  8022fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fe:	8b 00                	mov    (%eax),%eax
  802300:	85 c0                	test   %eax,%eax
  802302:	74 10                	je     802314 <initialize_dynamic_allocator+0x9c>
  802304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802307:	8b 00                	mov    (%eax),%eax
  802309:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80230c:	8b 52 04             	mov    0x4(%edx),%edx
  80230f:	89 50 04             	mov    %edx,0x4(%eax)
  802312:	eb 0b                	jmp    80231f <initialize_dynamic_allocator+0xa7>
  802314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802317:	8b 40 04             	mov    0x4(%eax),%eax
  80231a:	a3 30 50 80 00       	mov    %eax,0x805030
  80231f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802322:	8b 40 04             	mov    0x4(%eax),%eax
  802325:	85 c0                	test   %eax,%eax
  802327:	74 0f                	je     802338 <initialize_dynamic_allocator+0xc0>
  802329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232c:	8b 40 04             	mov    0x4(%eax),%eax
  80232f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802332:	8b 12                	mov    (%edx),%edx
  802334:	89 10                	mov    %edx,(%eax)
  802336:	eb 0a                	jmp    802342 <initialize_dynamic_allocator+0xca>
  802338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233b:	8b 00                	mov    (%eax),%eax
  80233d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802345:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80234b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802355:	a1 38 50 80 00       	mov    0x805038,%eax
  80235a:	48                   	dec    %eax
  80235b:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802360:	a1 34 50 80 00       	mov    0x805034,%eax
  802365:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802368:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80236c:	74 07                	je     802375 <initialize_dynamic_allocator+0xfd>
  80236e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802371:	8b 00                	mov    (%eax),%eax
  802373:	eb 05                	jmp    80237a <initialize_dynamic_allocator+0x102>
  802375:	b8 00 00 00 00       	mov    $0x0,%eax
  80237a:	a3 34 50 80 00       	mov    %eax,0x805034
  80237f:	a1 34 50 80 00       	mov    0x805034,%eax
  802384:	85 c0                	test   %eax,%eax
  802386:	0f 85 55 ff ff ff    	jne    8022e1 <initialize_dynamic_allocator+0x69>
  80238c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802390:	0f 85 4b ff ff ff    	jne    8022e1 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802396:	8b 45 08             	mov    0x8(%ebp),%eax
  802399:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80239c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8023a5:	a1 44 50 80 00       	mov    0x805044,%eax
  8023aa:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8023af:	a1 40 50 80 00       	mov    0x805040,%eax
  8023b4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bd:	83 c0 08             	add    $0x8,%eax
  8023c0:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8023c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c6:	83 c0 04             	add    $0x4,%eax
  8023c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023cc:	83 ea 08             	sub    $0x8,%edx
  8023cf:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8023d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d7:	01 d0                	add    %edx,%eax
  8023d9:	83 e8 08             	sub    $0x8,%eax
  8023dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023df:	83 ea 08             	sub    $0x8,%edx
  8023e2:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8023e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8023ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8023f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023fb:	75 17                	jne    802414 <initialize_dynamic_allocator+0x19c>
  8023fd:	83 ec 04             	sub    $0x4,%esp
  802400:	68 08 46 80 00       	push   $0x804608
  802405:	68 90 00 00 00       	push   $0x90
  80240a:	68 ed 45 80 00       	push   $0x8045ed
  80240f:	e8 f3 de ff ff       	call   800307 <_panic>
  802414:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80241a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241d:	89 10                	mov    %edx,(%eax)
  80241f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802422:	8b 00                	mov    (%eax),%eax
  802424:	85 c0                	test   %eax,%eax
  802426:	74 0d                	je     802435 <initialize_dynamic_allocator+0x1bd>
  802428:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80242d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802430:	89 50 04             	mov    %edx,0x4(%eax)
  802433:	eb 08                	jmp    80243d <initialize_dynamic_allocator+0x1c5>
  802435:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802438:	a3 30 50 80 00       	mov    %eax,0x805030
  80243d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802440:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802445:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802448:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80244f:	a1 38 50 80 00       	mov    0x805038,%eax
  802454:	40                   	inc    %eax
  802455:	a3 38 50 80 00       	mov    %eax,0x805038
  80245a:	eb 07                	jmp    802463 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80245c:	90                   	nop
  80245d:	eb 04                	jmp    802463 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80245f:	90                   	nop
  802460:	eb 01                	jmp    802463 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802462:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802463:	c9                   	leave  
  802464:	c3                   	ret    

00802465 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802468:	8b 45 10             	mov    0x10(%ebp),%eax
  80246b:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80246e:	8b 45 08             	mov    0x8(%ebp),%eax
  802471:	8d 50 fc             	lea    -0x4(%eax),%edx
  802474:	8b 45 0c             	mov    0xc(%ebp),%eax
  802477:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802479:	8b 45 08             	mov    0x8(%ebp),%eax
  80247c:	83 e8 04             	sub    $0x4,%eax
  80247f:	8b 00                	mov    (%eax),%eax
  802481:	83 e0 fe             	and    $0xfffffffe,%eax
  802484:	8d 50 f8             	lea    -0x8(%eax),%edx
  802487:	8b 45 08             	mov    0x8(%ebp),%eax
  80248a:	01 c2                	add    %eax,%edx
  80248c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80248f:	89 02                	mov    %eax,(%edx)
}
  802491:	90                   	nop
  802492:	5d                   	pop    %ebp
  802493:	c3                   	ret    

00802494 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
  802497:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80249a:	8b 45 08             	mov    0x8(%ebp),%eax
  80249d:	83 e0 01             	and    $0x1,%eax
  8024a0:	85 c0                	test   %eax,%eax
  8024a2:	74 03                	je     8024a7 <alloc_block_FF+0x13>
  8024a4:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8024a7:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8024ab:	77 07                	ja     8024b4 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8024ad:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8024b4:	a1 24 50 80 00       	mov    0x805024,%eax
  8024b9:	85 c0                	test   %eax,%eax
  8024bb:	75 73                	jne    802530 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8024bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c0:	83 c0 10             	add    $0x10,%eax
  8024c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8024c6:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8024cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d3:	01 d0                	add    %edx,%eax
  8024d5:	48                   	dec    %eax
  8024d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8024d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8024e1:	f7 75 ec             	divl   -0x14(%ebp)
  8024e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024e7:	29 d0                	sub    %edx,%eax
  8024e9:	c1 e8 0c             	shr    $0xc,%eax
  8024ec:	83 ec 0c             	sub    $0xc,%esp
  8024ef:	50                   	push   %eax
  8024f0:	e8 ec f6 ff ff       	call   801be1 <sbrk>
  8024f5:	83 c4 10             	add    $0x10,%esp
  8024f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8024fb:	83 ec 0c             	sub    $0xc,%esp
  8024fe:	6a 00                	push   $0x0
  802500:	e8 dc f6 ff ff       	call   801be1 <sbrk>
  802505:	83 c4 10             	add    $0x10,%esp
  802508:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80250b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80250e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802511:	83 ec 08             	sub    $0x8,%esp
  802514:	50                   	push   %eax
  802515:	ff 75 e4             	pushl  -0x1c(%ebp)
  802518:	e8 5b fd ff ff       	call   802278 <initialize_dynamic_allocator>
  80251d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802520:	83 ec 0c             	sub    $0xc,%esp
  802523:	68 2b 46 80 00       	push   $0x80462b
  802528:	e8 97 e0 ff ff       	call   8005c4 <cprintf>
  80252d:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802530:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802534:	75 0a                	jne    802540 <alloc_block_FF+0xac>
	        return NULL;
  802536:	b8 00 00 00 00       	mov    $0x0,%eax
  80253b:	e9 0e 04 00 00       	jmp    80294e <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802540:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802547:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80254c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80254f:	e9 f3 02 00 00       	jmp    802847 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802557:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80255a:	83 ec 0c             	sub    $0xc,%esp
  80255d:	ff 75 bc             	pushl  -0x44(%ebp)
  802560:	e8 af fb ff ff       	call   802114 <get_block_size>
  802565:	83 c4 10             	add    $0x10,%esp
  802568:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80256b:	8b 45 08             	mov    0x8(%ebp),%eax
  80256e:	83 c0 08             	add    $0x8,%eax
  802571:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802574:	0f 87 c5 02 00 00    	ja     80283f <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80257a:	8b 45 08             	mov    0x8(%ebp),%eax
  80257d:	83 c0 18             	add    $0x18,%eax
  802580:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802583:	0f 87 19 02 00 00    	ja     8027a2 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802589:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80258c:	2b 45 08             	sub    0x8(%ebp),%eax
  80258f:	83 e8 08             	sub    $0x8,%eax
  802592:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802595:	8b 45 08             	mov    0x8(%ebp),%eax
  802598:	8d 50 08             	lea    0x8(%eax),%edx
  80259b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80259e:	01 d0                	add    %edx,%eax
  8025a0:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8025a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a6:	83 c0 08             	add    $0x8,%eax
  8025a9:	83 ec 04             	sub    $0x4,%esp
  8025ac:	6a 01                	push   $0x1
  8025ae:	50                   	push   %eax
  8025af:	ff 75 bc             	pushl  -0x44(%ebp)
  8025b2:	e8 ae fe ff ff       	call   802465 <set_block_data>
  8025b7:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	8b 40 04             	mov    0x4(%eax),%eax
  8025c0:	85 c0                	test   %eax,%eax
  8025c2:	75 68                	jne    80262c <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8025c4:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025c8:	75 17                	jne    8025e1 <alloc_block_FF+0x14d>
  8025ca:	83 ec 04             	sub    $0x4,%esp
  8025cd:	68 08 46 80 00       	push   $0x804608
  8025d2:	68 d7 00 00 00       	push   $0xd7
  8025d7:	68 ed 45 80 00       	push   $0x8045ed
  8025dc:	e8 26 dd ff ff       	call   800307 <_panic>
  8025e1:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8025e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025ea:	89 10                	mov    %edx,(%eax)
  8025ec:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025ef:	8b 00                	mov    (%eax),%eax
  8025f1:	85 c0                	test   %eax,%eax
  8025f3:	74 0d                	je     802602 <alloc_block_FF+0x16e>
  8025f5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8025fa:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025fd:	89 50 04             	mov    %edx,0x4(%eax)
  802600:	eb 08                	jmp    80260a <alloc_block_FF+0x176>
  802602:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802605:	a3 30 50 80 00       	mov    %eax,0x805030
  80260a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80260d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802612:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802615:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80261c:	a1 38 50 80 00       	mov    0x805038,%eax
  802621:	40                   	inc    %eax
  802622:	a3 38 50 80 00       	mov    %eax,0x805038
  802627:	e9 dc 00 00 00       	jmp    802708 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80262c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262f:	8b 00                	mov    (%eax),%eax
  802631:	85 c0                	test   %eax,%eax
  802633:	75 65                	jne    80269a <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802635:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802639:	75 17                	jne    802652 <alloc_block_FF+0x1be>
  80263b:	83 ec 04             	sub    $0x4,%esp
  80263e:	68 3c 46 80 00       	push   $0x80463c
  802643:	68 db 00 00 00       	push   $0xdb
  802648:	68 ed 45 80 00       	push   $0x8045ed
  80264d:	e8 b5 dc ff ff       	call   800307 <_panic>
  802652:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802658:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80265b:	89 50 04             	mov    %edx,0x4(%eax)
  80265e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802661:	8b 40 04             	mov    0x4(%eax),%eax
  802664:	85 c0                	test   %eax,%eax
  802666:	74 0c                	je     802674 <alloc_block_FF+0x1e0>
  802668:	a1 30 50 80 00       	mov    0x805030,%eax
  80266d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802670:	89 10                	mov    %edx,(%eax)
  802672:	eb 08                	jmp    80267c <alloc_block_FF+0x1e8>
  802674:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802677:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80267c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80267f:	a3 30 50 80 00       	mov    %eax,0x805030
  802684:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802687:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80268d:	a1 38 50 80 00       	mov    0x805038,%eax
  802692:	40                   	inc    %eax
  802693:	a3 38 50 80 00       	mov    %eax,0x805038
  802698:	eb 6e                	jmp    802708 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80269a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269e:	74 06                	je     8026a6 <alloc_block_FF+0x212>
  8026a0:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8026a4:	75 17                	jne    8026bd <alloc_block_FF+0x229>
  8026a6:	83 ec 04             	sub    $0x4,%esp
  8026a9:	68 60 46 80 00       	push   $0x804660
  8026ae:	68 df 00 00 00       	push   $0xdf
  8026b3:	68 ed 45 80 00       	push   $0x8045ed
  8026b8:	e8 4a dc ff ff       	call   800307 <_panic>
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	8b 10                	mov    (%eax),%edx
  8026c2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026c5:	89 10                	mov    %edx,(%eax)
  8026c7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026ca:	8b 00                	mov    (%eax),%eax
  8026cc:	85 c0                	test   %eax,%eax
  8026ce:	74 0b                	je     8026db <alloc_block_FF+0x247>
  8026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d3:	8b 00                	mov    (%eax),%eax
  8026d5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026d8:	89 50 04             	mov    %edx,0x4(%eax)
  8026db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026de:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026e1:	89 10                	mov    %edx,(%eax)
  8026e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e9:	89 50 04             	mov    %edx,0x4(%eax)
  8026ec:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026ef:	8b 00                	mov    (%eax),%eax
  8026f1:	85 c0                	test   %eax,%eax
  8026f3:	75 08                	jne    8026fd <alloc_block_FF+0x269>
  8026f5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026f8:	a3 30 50 80 00       	mov    %eax,0x805030
  8026fd:	a1 38 50 80 00       	mov    0x805038,%eax
  802702:	40                   	inc    %eax
  802703:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802708:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270c:	75 17                	jne    802725 <alloc_block_FF+0x291>
  80270e:	83 ec 04             	sub    $0x4,%esp
  802711:	68 cf 45 80 00       	push   $0x8045cf
  802716:	68 e1 00 00 00       	push   $0xe1
  80271b:	68 ed 45 80 00       	push   $0x8045ed
  802720:	e8 e2 db ff ff       	call   800307 <_panic>
  802725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802728:	8b 00                	mov    (%eax),%eax
  80272a:	85 c0                	test   %eax,%eax
  80272c:	74 10                	je     80273e <alloc_block_FF+0x2aa>
  80272e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802731:	8b 00                	mov    (%eax),%eax
  802733:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802736:	8b 52 04             	mov    0x4(%edx),%edx
  802739:	89 50 04             	mov    %edx,0x4(%eax)
  80273c:	eb 0b                	jmp    802749 <alloc_block_FF+0x2b5>
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802741:	8b 40 04             	mov    0x4(%eax),%eax
  802744:	a3 30 50 80 00       	mov    %eax,0x805030
  802749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274c:	8b 40 04             	mov    0x4(%eax),%eax
  80274f:	85 c0                	test   %eax,%eax
  802751:	74 0f                	je     802762 <alloc_block_FF+0x2ce>
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	8b 40 04             	mov    0x4(%eax),%eax
  802759:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80275c:	8b 12                	mov    (%edx),%edx
  80275e:	89 10                	mov    %edx,(%eax)
  802760:	eb 0a                	jmp    80276c <alloc_block_FF+0x2d8>
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	8b 00                	mov    (%eax),%eax
  802767:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80276c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802778:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80277f:	a1 38 50 80 00       	mov    0x805038,%eax
  802784:	48                   	dec    %eax
  802785:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80278a:	83 ec 04             	sub    $0x4,%esp
  80278d:	6a 00                	push   $0x0
  80278f:	ff 75 b4             	pushl  -0x4c(%ebp)
  802792:	ff 75 b0             	pushl  -0x50(%ebp)
  802795:	e8 cb fc ff ff       	call   802465 <set_block_data>
  80279a:	83 c4 10             	add    $0x10,%esp
  80279d:	e9 95 00 00 00       	jmp    802837 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8027a2:	83 ec 04             	sub    $0x4,%esp
  8027a5:	6a 01                	push   $0x1
  8027a7:	ff 75 b8             	pushl  -0x48(%ebp)
  8027aa:	ff 75 bc             	pushl  -0x44(%ebp)
  8027ad:	e8 b3 fc ff ff       	call   802465 <set_block_data>
  8027b2:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8027b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b9:	75 17                	jne    8027d2 <alloc_block_FF+0x33e>
  8027bb:	83 ec 04             	sub    $0x4,%esp
  8027be:	68 cf 45 80 00       	push   $0x8045cf
  8027c3:	68 e8 00 00 00       	push   $0xe8
  8027c8:	68 ed 45 80 00       	push   $0x8045ed
  8027cd:	e8 35 db ff ff       	call   800307 <_panic>
  8027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d5:	8b 00                	mov    (%eax),%eax
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	74 10                	je     8027eb <alloc_block_FF+0x357>
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	8b 00                	mov    (%eax),%eax
  8027e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e3:	8b 52 04             	mov    0x4(%edx),%edx
  8027e6:	89 50 04             	mov    %edx,0x4(%eax)
  8027e9:	eb 0b                	jmp    8027f6 <alloc_block_FF+0x362>
  8027eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ee:	8b 40 04             	mov    0x4(%eax),%eax
  8027f1:	a3 30 50 80 00       	mov    %eax,0x805030
  8027f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f9:	8b 40 04             	mov    0x4(%eax),%eax
  8027fc:	85 c0                	test   %eax,%eax
  8027fe:	74 0f                	je     80280f <alloc_block_FF+0x37b>
  802800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802803:	8b 40 04             	mov    0x4(%eax),%eax
  802806:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802809:	8b 12                	mov    (%edx),%edx
  80280b:	89 10                	mov    %edx,(%eax)
  80280d:	eb 0a                	jmp    802819 <alloc_block_FF+0x385>
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	8b 00                	mov    (%eax),%eax
  802814:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802825:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80282c:	a1 38 50 80 00       	mov    0x805038,%eax
  802831:	48                   	dec    %eax
  802832:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802837:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80283a:	e9 0f 01 00 00       	jmp    80294e <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80283f:	a1 34 50 80 00       	mov    0x805034,%eax
  802844:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802847:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284b:	74 07                	je     802854 <alloc_block_FF+0x3c0>
  80284d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802850:	8b 00                	mov    (%eax),%eax
  802852:	eb 05                	jmp    802859 <alloc_block_FF+0x3c5>
  802854:	b8 00 00 00 00       	mov    $0x0,%eax
  802859:	a3 34 50 80 00       	mov    %eax,0x805034
  80285e:	a1 34 50 80 00       	mov    0x805034,%eax
  802863:	85 c0                	test   %eax,%eax
  802865:	0f 85 e9 fc ff ff    	jne    802554 <alloc_block_FF+0xc0>
  80286b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286f:	0f 85 df fc ff ff    	jne    802554 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802875:	8b 45 08             	mov    0x8(%ebp),%eax
  802878:	83 c0 08             	add    $0x8,%eax
  80287b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80287e:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802885:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802888:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80288b:	01 d0                	add    %edx,%eax
  80288d:	48                   	dec    %eax
  80288e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802891:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802894:	ba 00 00 00 00       	mov    $0x0,%edx
  802899:	f7 75 d8             	divl   -0x28(%ebp)
  80289c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80289f:	29 d0                	sub    %edx,%eax
  8028a1:	c1 e8 0c             	shr    $0xc,%eax
  8028a4:	83 ec 0c             	sub    $0xc,%esp
  8028a7:	50                   	push   %eax
  8028a8:	e8 34 f3 ff ff       	call   801be1 <sbrk>
  8028ad:	83 c4 10             	add    $0x10,%esp
  8028b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8028b3:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8028b7:	75 0a                	jne    8028c3 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8028b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028be:	e9 8b 00 00 00       	jmp    80294e <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8028c3:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8028ca:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028d0:	01 d0                	add    %edx,%eax
  8028d2:	48                   	dec    %eax
  8028d3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8028d6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8028de:	f7 75 cc             	divl   -0x34(%ebp)
  8028e1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028e4:	29 d0                	sub    %edx,%eax
  8028e6:	8d 50 fc             	lea    -0x4(%eax),%edx
  8028e9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028ec:	01 d0                	add    %edx,%eax
  8028ee:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8028f3:	a1 40 50 80 00       	mov    0x805040,%eax
  8028f8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8028fe:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802905:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802908:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80290b:	01 d0                	add    %edx,%eax
  80290d:	48                   	dec    %eax
  80290e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802911:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802914:	ba 00 00 00 00       	mov    $0x0,%edx
  802919:	f7 75 c4             	divl   -0x3c(%ebp)
  80291c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80291f:	29 d0                	sub    %edx,%eax
  802921:	83 ec 04             	sub    $0x4,%esp
  802924:	6a 01                	push   $0x1
  802926:	50                   	push   %eax
  802927:	ff 75 d0             	pushl  -0x30(%ebp)
  80292a:	e8 36 fb ff ff       	call   802465 <set_block_data>
  80292f:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802932:	83 ec 0c             	sub    $0xc,%esp
  802935:	ff 75 d0             	pushl  -0x30(%ebp)
  802938:	e8 f8 09 00 00       	call   803335 <free_block>
  80293d:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802940:	83 ec 0c             	sub    $0xc,%esp
  802943:	ff 75 08             	pushl  0x8(%ebp)
  802946:	e8 49 fb ff ff       	call   802494 <alloc_block_FF>
  80294b:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80294e:	c9                   	leave  
  80294f:	c3                   	ret    

00802950 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802950:	55                   	push   %ebp
  802951:	89 e5                	mov    %esp,%ebp
  802953:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802956:	8b 45 08             	mov    0x8(%ebp),%eax
  802959:	83 e0 01             	and    $0x1,%eax
  80295c:	85 c0                	test   %eax,%eax
  80295e:	74 03                	je     802963 <alloc_block_BF+0x13>
  802960:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802963:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802967:	77 07                	ja     802970 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802969:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802970:	a1 24 50 80 00       	mov    0x805024,%eax
  802975:	85 c0                	test   %eax,%eax
  802977:	75 73                	jne    8029ec <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802979:	8b 45 08             	mov    0x8(%ebp),%eax
  80297c:	83 c0 10             	add    $0x10,%eax
  80297f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802982:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802989:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80298c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80298f:	01 d0                	add    %edx,%eax
  802991:	48                   	dec    %eax
  802992:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802995:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802998:	ba 00 00 00 00       	mov    $0x0,%edx
  80299d:	f7 75 e0             	divl   -0x20(%ebp)
  8029a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029a3:	29 d0                	sub    %edx,%eax
  8029a5:	c1 e8 0c             	shr    $0xc,%eax
  8029a8:	83 ec 0c             	sub    $0xc,%esp
  8029ab:	50                   	push   %eax
  8029ac:	e8 30 f2 ff ff       	call   801be1 <sbrk>
  8029b1:	83 c4 10             	add    $0x10,%esp
  8029b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8029b7:	83 ec 0c             	sub    $0xc,%esp
  8029ba:	6a 00                	push   $0x0
  8029bc:	e8 20 f2 ff ff       	call   801be1 <sbrk>
  8029c1:	83 c4 10             	add    $0x10,%esp
  8029c4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8029c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029ca:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8029cd:	83 ec 08             	sub    $0x8,%esp
  8029d0:	50                   	push   %eax
  8029d1:	ff 75 d8             	pushl  -0x28(%ebp)
  8029d4:	e8 9f f8 ff ff       	call   802278 <initialize_dynamic_allocator>
  8029d9:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8029dc:	83 ec 0c             	sub    $0xc,%esp
  8029df:	68 2b 46 80 00       	push   $0x80462b
  8029e4:	e8 db db ff ff       	call   8005c4 <cprintf>
  8029e9:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8029ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8029f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8029fa:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802a01:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802a08:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a10:	e9 1d 01 00 00       	jmp    802b32 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a18:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802a1b:	83 ec 0c             	sub    $0xc,%esp
  802a1e:	ff 75 a8             	pushl  -0x58(%ebp)
  802a21:	e8 ee f6 ff ff       	call   802114 <get_block_size>
  802a26:	83 c4 10             	add    $0x10,%esp
  802a29:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2f:	83 c0 08             	add    $0x8,%eax
  802a32:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a35:	0f 87 ef 00 00 00    	ja     802b2a <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	83 c0 18             	add    $0x18,%eax
  802a41:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a44:	77 1d                	ja     802a63 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802a46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a49:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a4c:	0f 86 d8 00 00 00    	jbe    802b2a <alloc_block_BF+0x1da>
				{
					best_va = va;
  802a52:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a55:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802a58:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a5b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a5e:	e9 c7 00 00 00       	jmp    802b2a <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802a63:	8b 45 08             	mov    0x8(%ebp),%eax
  802a66:	83 c0 08             	add    $0x8,%eax
  802a69:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a6c:	0f 85 9d 00 00 00    	jne    802b0f <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802a72:	83 ec 04             	sub    $0x4,%esp
  802a75:	6a 01                	push   $0x1
  802a77:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a7a:	ff 75 a8             	pushl  -0x58(%ebp)
  802a7d:	e8 e3 f9 ff ff       	call   802465 <set_block_data>
  802a82:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802a85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a89:	75 17                	jne    802aa2 <alloc_block_BF+0x152>
  802a8b:	83 ec 04             	sub    $0x4,%esp
  802a8e:	68 cf 45 80 00       	push   $0x8045cf
  802a93:	68 2c 01 00 00       	push   $0x12c
  802a98:	68 ed 45 80 00       	push   $0x8045ed
  802a9d:	e8 65 d8 ff ff       	call   800307 <_panic>
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	8b 00                	mov    (%eax),%eax
  802aa7:	85 c0                	test   %eax,%eax
  802aa9:	74 10                	je     802abb <alloc_block_BF+0x16b>
  802aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aae:	8b 00                	mov    (%eax),%eax
  802ab0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab3:	8b 52 04             	mov    0x4(%edx),%edx
  802ab6:	89 50 04             	mov    %edx,0x4(%eax)
  802ab9:	eb 0b                	jmp    802ac6 <alloc_block_BF+0x176>
  802abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abe:	8b 40 04             	mov    0x4(%eax),%eax
  802ac1:	a3 30 50 80 00       	mov    %eax,0x805030
  802ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac9:	8b 40 04             	mov    0x4(%eax),%eax
  802acc:	85 c0                	test   %eax,%eax
  802ace:	74 0f                	je     802adf <alloc_block_BF+0x18f>
  802ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad3:	8b 40 04             	mov    0x4(%eax),%eax
  802ad6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad9:	8b 12                	mov    (%edx),%edx
  802adb:	89 10                	mov    %edx,(%eax)
  802add:	eb 0a                	jmp    802ae9 <alloc_block_BF+0x199>
  802adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae2:	8b 00                	mov    (%eax),%eax
  802ae4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802afc:	a1 38 50 80 00       	mov    0x805038,%eax
  802b01:	48                   	dec    %eax
  802b02:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802b07:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b0a:	e9 01 04 00 00       	jmp    802f10 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802b0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b12:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b15:	76 13                	jbe    802b2a <alloc_block_BF+0x1da>
					{
						internal = 1;
  802b17:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802b1e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b21:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802b24:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802b27:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802b2a:	a1 34 50 80 00       	mov    0x805034,%eax
  802b2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b36:	74 07                	je     802b3f <alloc_block_BF+0x1ef>
  802b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3b:	8b 00                	mov    (%eax),%eax
  802b3d:	eb 05                	jmp    802b44 <alloc_block_BF+0x1f4>
  802b3f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b44:	a3 34 50 80 00       	mov    %eax,0x805034
  802b49:	a1 34 50 80 00       	mov    0x805034,%eax
  802b4e:	85 c0                	test   %eax,%eax
  802b50:	0f 85 bf fe ff ff    	jne    802a15 <alloc_block_BF+0xc5>
  802b56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b5a:	0f 85 b5 fe ff ff    	jne    802a15 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802b60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b64:	0f 84 26 02 00 00    	je     802d90 <alloc_block_BF+0x440>
  802b6a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b6e:	0f 85 1c 02 00 00    	jne    802d90 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802b74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b77:	2b 45 08             	sub    0x8(%ebp),%eax
  802b7a:	83 e8 08             	sub    $0x8,%eax
  802b7d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802b80:	8b 45 08             	mov    0x8(%ebp),%eax
  802b83:	8d 50 08             	lea    0x8(%eax),%edx
  802b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b89:	01 d0                	add    %edx,%eax
  802b8b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b91:	83 c0 08             	add    $0x8,%eax
  802b94:	83 ec 04             	sub    $0x4,%esp
  802b97:	6a 01                	push   $0x1
  802b99:	50                   	push   %eax
  802b9a:	ff 75 f0             	pushl  -0x10(%ebp)
  802b9d:	e8 c3 f8 ff ff       	call   802465 <set_block_data>
  802ba2:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802ba5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba8:	8b 40 04             	mov    0x4(%eax),%eax
  802bab:	85 c0                	test   %eax,%eax
  802bad:	75 68                	jne    802c17 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802baf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bb3:	75 17                	jne    802bcc <alloc_block_BF+0x27c>
  802bb5:	83 ec 04             	sub    $0x4,%esp
  802bb8:	68 08 46 80 00       	push   $0x804608
  802bbd:	68 45 01 00 00       	push   $0x145
  802bc2:	68 ed 45 80 00       	push   $0x8045ed
  802bc7:	e8 3b d7 ff ff       	call   800307 <_panic>
  802bcc:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802bd2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bd5:	89 10                	mov    %edx,(%eax)
  802bd7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bda:	8b 00                	mov    (%eax),%eax
  802bdc:	85 c0                	test   %eax,%eax
  802bde:	74 0d                	je     802bed <alloc_block_BF+0x29d>
  802be0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802be5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802be8:	89 50 04             	mov    %edx,0x4(%eax)
  802beb:	eb 08                	jmp    802bf5 <alloc_block_BF+0x2a5>
  802bed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bf0:	a3 30 50 80 00       	mov    %eax,0x805030
  802bf5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bf8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bfd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c07:	a1 38 50 80 00       	mov    0x805038,%eax
  802c0c:	40                   	inc    %eax
  802c0d:	a3 38 50 80 00       	mov    %eax,0x805038
  802c12:	e9 dc 00 00 00       	jmp    802cf3 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1a:	8b 00                	mov    (%eax),%eax
  802c1c:	85 c0                	test   %eax,%eax
  802c1e:	75 65                	jne    802c85 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c20:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c24:	75 17                	jne    802c3d <alloc_block_BF+0x2ed>
  802c26:	83 ec 04             	sub    $0x4,%esp
  802c29:	68 3c 46 80 00       	push   $0x80463c
  802c2e:	68 4a 01 00 00       	push   $0x14a
  802c33:	68 ed 45 80 00       	push   $0x8045ed
  802c38:	e8 ca d6 ff ff       	call   800307 <_panic>
  802c3d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802c43:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c46:	89 50 04             	mov    %edx,0x4(%eax)
  802c49:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c4c:	8b 40 04             	mov    0x4(%eax),%eax
  802c4f:	85 c0                	test   %eax,%eax
  802c51:	74 0c                	je     802c5f <alloc_block_BF+0x30f>
  802c53:	a1 30 50 80 00       	mov    0x805030,%eax
  802c58:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c5b:	89 10                	mov    %edx,(%eax)
  802c5d:	eb 08                	jmp    802c67 <alloc_block_BF+0x317>
  802c5f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c62:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c67:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c6a:	a3 30 50 80 00       	mov    %eax,0x805030
  802c6f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c78:	a1 38 50 80 00       	mov    0x805038,%eax
  802c7d:	40                   	inc    %eax
  802c7e:	a3 38 50 80 00       	mov    %eax,0x805038
  802c83:	eb 6e                	jmp    802cf3 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802c85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c89:	74 06                	je     802c91 <alloc_block_BF+0x341>
  802c8b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c8f:	75 17                	jne    802ca8 <alloc_block_BF+0x358>
  802c91:	83 ec 04             	sub    $0x4,%esp
  802c94:	68 60 46 80 00       	push   $0x804660
  802c99:	68 4f 01 00 00       	push   $0x14f
  802c9e:	68 ed 45 80 00       	push   $0x8045ed
  802ca3:	e8 5f d6 ff ff       	call   800307 <_panic>
  802ca8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cab:	8b 10                	mov    (%eax),%edx
  802cad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cb0:	89 10                	mov    %edx,(%eax)
  802cb2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cb5:	8b 00                	mov    (%eax),%eax
  802cb7:	85 c0                	test   %eax,%eax
  802cb9:	74 0b                	je     802cc6 <alloc_block_BF+0x376>
  802cbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbe:	8b 00                	mov    (%eax),%eax
  802cc0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802cc3:	89 50 04             	mov    %edx,0x4(%eax)
  802cc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ccc:	89 10                	mov    %edx,(%eax)
  802cce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cd1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cd4:	89 50 04             	mov    %edx,0x4(%eax)
  802cd7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cda:	8b 00                	mov    (%eax),%eax
  802cdc:	85 c0                	test   %eax,%eax
  802cde:	75 08                	jne    802ce8 <alloc_block_BF+0x398>
  802ce0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ce3:	a3 30 50 80 00       	mov    %eax,0x805030
  802ce8:	a1 38 50 80 00       	mov    0x805038,%eax
  802ced:	40                   	inc    %eax
  802cee:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802cf3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cf7:	75 17                	jne    802d10 <alloc_block_BF+0x3c0>
  802cf9:	83 ec 04             	sub    $0x4,%esp
  802cfc:	68 cf 45 80 00       	push   $0x8045cf
  802d01:	68 51 01 00 00       	push   $0x151
  802d06:	68 ed 45 80 00       	push   $0x8045ed
  802d0b:	e8 f7 d5 ff ff       	call   800307 <_panic>
  802d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d13:	8b 00                	mov    (%eax),%eax
  802d15:	85 c0                	test   %eax,%eax
  802d17:	74 10                	je     802d29 <alloc_block_BF+0x3d9>
  802d19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1c:	8b 00                	mov    (%eax),%eax
  802d1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d21:	8b 52 04             	mov    0x4(%edx),%edx
  802d24:	89 50 04             	mov    %edx,0x4(%eax)
  802d27:	eb 0b                	jmp    802d34 <alloc_block_BF+0x3e4>
  802d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2c:	8b 40 04             	mov    0x4(%eax),%eax
  802d2f:	a3 30 50 80 00       	mov    %eax,0x805030
  802d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d37:	8b 40 04             	mov    0x4(%eax),%eax
  802d3a:	85 c0                	test   %eax,%eax
  802d3c:	74 0f                	je     802d4d <alloc_block_BF+0x3fd>
  802d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d41:	8b 40 04             	mov    0x4(%eax),%eax
  802d44:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d47:	8b 12                	mov    (%edx),%edx
  802d49:	89 10                	mov    %edx,(%eax)
  802d4b:	eb 0a                	jmp    802d57 <alloc_block_BF+0x407>
  802d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d50:	8b 00                	mov    (%eax),%eax
  802d52:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d6a:	a1 38 50 80 00       	mov    0x805038,%eax
  802d6f:	48                   	dec    %eax
  802d70:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802d75:	83 ec 04             	sub    $0x4,%esp
  802d78:	6a 00                	push   $0x0
  802d7a:	ff 75 d0             	pushl  -0x30(%ebp)
  802d7d:	ff 75 cc             	pushl  -0x34(%ebp)
  802d80:	e8 e0 f6 ff ff       	call   802465 <set_block_data>
  802d85:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8b:	e9 80 01 00 00       	jmp    802f10 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802d90:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802d94:	0f 85 9d 00 00 00    	jne    802e37 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802d9a:	83 ec 04             	sub    $0x4,%esp
  802d9d:	6a 01                	push   $0x1
  802d9f:	ff 75 ec             	pushl  -0x14(%ebp)
  802da2:	ff 75 f0             	pushl  -0x10(%ebp)
  802da5:	e8 bb f6 ff ff       	call   802465 <set_block_data>
  802daa:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802dad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802db1:	75 17                	jne    802dca <alloc_block_BF+0x47a>
  802db3:	83 ec 04             	sub    $0x4,%esp
  802db6:	68 cf 45 80 00       	push   $0x8045cf
  802dbb:	68 58 01 00 00       	push   $0x158
  802dc0:	68 ed 45 80 00       	push   $0x8045ed
  802dc5:	e8 3d d5 ff ff       	call   800307 <_panic>
  802dca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcd:	8b 00                	mov    (%eax),%eax
  802dcf:	85 c0                	test   %eax,%eax
  802dd1:	74 10                	je     802de3 <alloc_block_BF+0x493>
  802dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd6:	8b 00                	mov    (%eax),%eax
  802dd8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ddb:	8b 52 04             	mov    0x4(%edx),%edx
  802dde:	89 50 04             	mov    %edx,0x4(%eax)
  802de1:	eb 0b                	jmp    802dee <alloc_block_BF+0x49e>
  802de3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de6:	8b 40 04             	mov    0x4(%eax),%eax
  802de9:	a3 30 50 80 00       	mov    %eax,0x805030
  802dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df1:	8b 40 04             	mov    0x4(%eax),%eax
  802df4:	85 c0                	test   %eax,%eax
  802df6:	74 0f                	je     802e07 <alloc_block_BF+0x4b7>
  802df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfb:	8b 40 04             	mov    0x4(%eax),%eax
  802dfe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e01:	8b 12                	mov    (%edx),%edx
  802e03:	89 10                	mov    %edx,(%eax)
  802e05:	eb 0a                	jmp    802e11 <alloc_block_BF+0x4c1>
  802e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0a:	8b 00                	mov    (%eax),%eax
  802e0c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e24:	a1 38 50 80 00       	mov    0x805038,%eax
  802e29:	48                   	dec    %eax
  802e2a:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802e2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e32:	e9 d9 00 00 00       	jmp    802f10 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802e37:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3a:	83 c0 08             	add    $0x8,%eax
  802e3d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e40:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802e47:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e4a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e4d:	01 d0                	add    %edx,%eax
  802e4f:	48                   	dec    %eax
  802e50:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e53:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e56:	ba 00 00 00 00       	mov    $0x0,%edx
  802e5b:	f7 75 c4             	divl   -0x3c(%ebp)
  802e5e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e61:	29 d0                	sub    %edx,%eax
  802e63:	c1 e8 0c             	shr    $0xc,%eax
  802e66:	83 ec 0c             	sub    $0xc,%esp
  802e69:	50                   	push   %eax
  802e6a:	e8 72 ed ff ff       	call   801be1 <sbrk>
  802e6f:	83 c4 10             	add    $0x10,%esp
  802e72:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802e75:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802e79:	75 0a                	jne    802e85 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802e7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802e80:	e9 8b 00 00 00       	jmp    802f10 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e85:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802e8c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e8f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802e92:	01 d0                	add    %edx,%eax
  802e94:	48                   	dec    %eax
  802e95:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802e98:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e9b:	ba 00 00 00 00       	mov    $0x0,%edx
  802ea0:	f7 75 b8             	divl   -0x48(%ebp)
  802ea3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ea6:	29 d0                	sub    %edx,%eax
  802ea8:	8d 50 fc             	lea    -0x4(%eax),%edx
  802eab:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802eae:	01 d0                	add    %edx,%eax
  802eb0:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802eb5:	a1 40 50 80 00       	mov    0x805040,%eax
  802eba:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802ec0:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802ec7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802eca:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ecd:	01 d0                	add    %edx,%eax
  802ecf:	48                   	dec    %eax
  802ed0:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802ed3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ed6:	ba 00 00 00 00       	mov    $0x0,%edx
  802edb:	f7 75 b0             	divl   -0x50(%ebp)
  802ede:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ee1:	29 d0                	sub    %edx,%eax
  802ee3:	83 ec 04             	sub    $0x4,%esp
  802ee6:	6a 01                	push   $0x1
  802ee8:	50                   	push   %eax
  802ee9:	ff 75 bc             	pushl  -0x44(%ebp)
  802eec:	e8 74 f5 ff ff       	call   802465 <set_block_data>
  802ef1:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802ef4:	83 ec 0c             	sub    $0xc,%esp
  802ef7:	ff 75 bc             	pushl  -0x44(%ebp)
  802efa:	e8 36 04 00 00       	call   803335 <free_block>
  802eff:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802f02:	83 ec 0c             	sub    $0xc,%esp
  802f05:	ff 75 08             	pushl  0x8(%ebp)
  802f08:	e8 43 fa ff ff       	call   802950 <alloc_block_BF>
  802f0d:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802f10:	c9                   	leave  
  802f11:	c3                   	ret    

00802f12 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802f12:	55                   	push   %ebp
  802f13:	89 e5                	mov    %esp,%ebp
  802f15:	53                   	push   %ebx
  802f16:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802f19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802f20:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802f27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f2b:	74 1e                	je     802f4b <merging+0x39>
  802f2d:	ff 75 08             	pushl  0x8(%ebp)
  802f30:	e8 df f1 ff ff       	call   802114 <get_block_size>
  802f35:	83 c4 04             	add    $0x4,%esp
  802f38:	89 c2                	mov    %eax,%edx
  802f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3d:	01 d0                	add    %edx,%eax
  802f3f:	3b 45 10             	cmp    0x10(%ebp),%eax
  802f42:	75 07                	jne    802f4b <merging+0x39>
		prev_is_free = 1;
  802f44:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802f4b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f4f:	74 1e                	je     802f6f <merging+0x5d>
  802f51:	ff 75 10             	pushl  0x10(%ebp)
  802f54:	e8 bb f1 ff ff       	call   802114 <get_block_size>
  802f59:	83 c4 04             	add    $0x4,%esp
  802f5c:	89 c2                	mov    %eax,%edx
  802f5e:	8b 45 10             	mov    0x10(%ebp),%eax
  802f61:	01 d0                	add    %edx,%eax
  802f63:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f66:	75 07                	jne    802f6f <merging+0x5d>
		next_is_free = 1;
  802f68:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802f6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f73:	0f 84 cc 00 00 00    	je     803045 <merging+0x133>
  802f79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f7d:	0f 84 c2 00 00 00    	je     803045 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802f83:	ff 75 08             	pushl  0x8(%ebp)
  802f86:	e8 89 f1 ff ff       	call   802114 <get_block_size>
  802f8b:	83 c4 04             	add    $0x4,%esp
  802f8e:	89 c3                	mov    %eax,%ebx
  802f90:	ff 75 10             	pushl  0x10(%ebp)
  802f93:	e8 7c f1 ff ff       	call   802114 <get_block_size>
  802f98:	83 c4 04             	add    $0x4,%esp
  802f9b:	01 c3                	add    %eax,%ebx
  802f9d:	ff 75 0c             	pushl  0xc(%ebp)
  802fa0:	e8 6f f1 ff ff       	call   802114 <get_block_size>
  802fa5:	83 c4 04             	add    $0x4,%esp
  802fa8:	01 d8                	add    %ebx,%eax
  802faa:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802fad:	6a 00                	push   $0x0
  802faf:	ff 75 ec             	pushl  -0x14(%ebp)
  802fb2:	ff 75 08             	pushl  0x8(%ebp)
  802fb5:	e8 ab f4 ff ff       	call   802465 <set_block_data>
  802fba:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802fbd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fc1:	75 17                	jne    802fda <merging+0xc8>
  802fc3:	83 ec 04             	sub    $0x4,%esp
  802fc6:	68 cf 45 80 00       	push   $0x8045cf
  802fcb:	68 7d 01 00 00       	push   $0x17d
  802fd0:	68 ed 45 80 00       	push   $0x8045ed
  802fd5:	e8 2d d3 ff ff       	call   800307 <_panic>
  802fda:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fdd:	8b 00                	mov    (%eax),%eax
  802fdf:	85 c0                	test   %eax,%eax
  802fe1:	74 10                	je     802ff3 <merging+0xe1>
  802fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe6:	8b 00                	mov    (%eax),%eax
  802fe8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802feb:	8b 52 04             	mov    0x4(%edx),%edx
  802fee:	89 50 04             	mov    %edx,0x4(%eax)
  802ff1:	eb 0b                	jmp    802ffe <merging+0xec>
  802ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff6:	8b 40 04             	mov    0x4(%eax),%eax
  802ff9:	a3 30 50 80 00       	mov    %eax,0x805030
  802ffe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803001:	8b 40 04             	mov    0x4(%eax),%eax
  803004:	85 c0                	test   %eax,%eax
  803006:	74 0f                	je     803017 <merging+0x105>
  803008:	8b 45 0c             	mov    0xc(%ebp),%eax
  80300b:	8b 40 04             	mov    0x4(%eax),%eax
  80300e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803011:	8b 12                	mov    (%edx),%edx
  803013:	89 10                	mov    %edx,(%eax)
  803015:	eb 0a                	jmp    803021 <merging+0x10f>
  803017:	8b 45 0c             	mov    0xc(%ebp),%eax
  80301a:	8b 00                	mov    (%eax),%eax
  80301c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803021:	8b 45 0c             	mov    0xc(%ebp),%eax
  803024:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80302a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80302d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803034:	a1 38 50 80 00       	mov    0x805038,%eax
  803039:	48                   	dec    %eax
  80303a:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80303f:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803040:	e9 ea 02 00 00       	jmp    80332f <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803045:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803049:	74 3b                	je     803086 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80304b:	83 ec 0c             	sub    $0xc,%esp
  80304e:	ff 75 08             	pushl  0x8(%ebp)
  803051:	e8 be f0 ff ff       	call   802114 <get_block_size>
  803056:	83 c4 10             	add    $0x10,%esp
  803059:	89 c3                	mov    %eax,%ebx
  80305b:	83 ec 0c             	sub    $0xc,%esp
  80305e:	ff 75 10             	pushl  0x10(%ebp)
  803061:	e8 ae f0 ff ff       	call   802114 <get_block_size>
  803066:	83 c4 10             	add    $0x10,%esp
  803069:	01 d8                	add    %ebx,%eax
  80306b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80306e:	83 ec 04             	sub    $0x4,%esp
  803071:	6a 00                	push   $0x0
  803073:	ff 75 e8             	pushl  -0x18(%ebp)
  803076:	ff 75 08             	pushl  0x8(%ebp)
  803079:	e8 e7 f3 ff ff       	call   802465 <set_block_data>
  80307e:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803081:	e9 a9 02 00 00       	jmp    80332f <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803086:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80308a:	0f 84 2d 01 00 00    	je     8031bd <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803090:	83 ec 0c             	sub    $0xc,%esp
  803093:	ff 75 10             	pushl  0x10(%ebp)
  803096:	e8 79 f0 ff ff       	call   802114 <get_block_size>
  80309b:	83 c4 10             	add    $0x10,%esp
  80309e:	89 c3                	mov    %eax,%ebx
  8030a0:	83 ec 0c             	sub    $0xc,%esp
  8030a3:	ff 75 0c             	pushl  0xc(%ebp)
  8030a6:	e8 69 f0 ff ff       	call   802114 <get_block_size>
  8030ab:	83 c4 10             	add    $0x10,%esp
  8030ae:	01 d8                	add    %ebx,%eax
  8030b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8030b3:	83 ec 04             	sub    $0x4,%esp
  8030b6:	6a 00                	push   $0x0
  8030b8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8030bb:	ff 75 10             	pushl  0x10(%ebp)
  8030be:	e8 a2 f3 ff ff       	call   802465 <set_block_data>
  8030c3:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8030c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8030c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8030cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030d0:	74 06                	je     8030d8 <merging+0x1c6>
  8030d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030d6:	75 17                	jne    8030ef <merging+0x1dd>
  8030d8:	83 ec 04             	sub    $0x4,%esp
  8030db:	68 94 46 80 00       	push   $0x804694
  8030e0:	68 8d 01 00 00       	push   $0x18d
  8030e5:	68 ed 45 80 00       	push   $0x8045ed
  8030ea:	e8 18 d2 ff ff       	call   800307 <_panic>
  8030ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f2:	8b 50 04             	mov    0x4(%eax),%edx
  8030f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030f8:	89 50 04             	mov    %edx,0x4(%eax)
  8030fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  803101:	89 10                	mov    %edx,(%eax)
  803103:	8b 45 0c             	mov    0xc(%ebp),%eax
  803106:	8b 40 04             	mov    0x4(%eax),%eax
  803109:	85 c0                	test   %eax,%eax
  80310b:	74 0d                	je     80311a <merging+0x208>
  80310d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803110:	8b 40 04             	mov    0x4(%eax),%eax
  803113:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803116:	89 10                	mov    %edx,(%eax)
  803118:	eb 08                	jmp    803122 <merging+0x210>
  80311a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80311d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803122:	8b 45 0c             	mov    0xc(%ebp),%eax
  803125:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803128:	89 50 04             	mov    %edx,0x4(%eax)
  80312b:	a1 38 50 80 00       	mov    0x805038,%eax
  803130:	40                   	inc    %eax
  803131:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803136:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80313a:	75 17                	jne    803153 <merging+0x241>
  80313c:	83 ec 04             	sub    $0x4,%esp
  80313f:	68 cf 45 80 00       	push   $0x8045cf
  803144:	68 8e 01 00 00       	push   $0x18e
  803149:	68 ed 45 80 00       	push   $0x8045ed
  80314e:	e8 b4 d1 ff ff       	call   800307 <_panic>
  803153:	8b 45 0c             	mov    0xc(%ebp),%eax
  803156:	8b 00                	mov    (%eax),%eax
  803158:	85 c0                	test   %eax,%eax
  80315a:	74 10                	je     80316c <merging+0x25a>
  80315c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80315f:	8b 00                	mov    (%eax),%eax
  803161:	8b 55 0c             	mov    0xc(%ebp),%edx
  803164:	8b 52 04             	mov    0x4(%edx),%edx
  803167:	89 50 04             	mov    %edx,0x4(%eax)
  80316a:	eb 0b                	jmp    803177 <merging+0x265>
  80316c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80316f:	8b 40 04             	mov    0x4(%eax),%eax
  803172:	a3 30 50 80 00       	mov    %eax,0x805030
  803177:	8b 45 0c             	mov    0xc(%ebp),%eax
  80317a:	8b 40 04             	mov    0x4(%eax),%eax
  80317d:	85 c0                	test   %eax,%eax
  80317f:	74 0f                	je     803190 <merging+0x27e>
  803181:	8b 45 0c             	mov    0xc(%ebp),%eax
  803184:	8b 40 04             	mov    0x4(%eax),%eax
  803187:	8b 55 0c             	mov    0xc(%ebp),%edx
  80318a:	8b 12                	mov    (%edx),%edx
  80318c:	89 10                	mov    %edx,(%eax)
  80318e:	eb 0a                	jmp    80319a <merging+0x288>
  803190:	8b 45 0c             	mov    0xc(%ebp),%eax
  803193:	8b 00                	mov    (%eax),%eax
  803195:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80319a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80319d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ad:	a1 38 50 80 00       	mov    0x805038,%eax
  8031b2:	48                   	dec    %eax
  8031b3:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8031b8:	e9 72 01 00 00       	jmp    80332f <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8031bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8031c0:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8031c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031c7:	74 79                	je     803242 <merging+0x330>
  8031c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031cd:	74 73                	je     803242 <merging+0x330>
  8031cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031d3:	74 06                	je     8031db <merging+0x2c9>
  8031d5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031d9:	75 17                	jne    8031f2 <merging+0x2e0>
  8031db:	83 ec 04             	sub    $0x4,%esp
  8031de:	68 60 46 80 00       	push   $0x804660
  8031e3:	68 94 01 00 00       	push   $0x194
  8031e8:	68 ed 45 80 00       	push   $0x8045ed
  8031ed:	e8 15 d1 ff ff       	call   800307 <_panic>
  8031f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f5:	8b 10                	mov    (%eax),%edx
  8031f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031fa:	89 10                	mov    %edx,(%eax)
  8031fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031ff:	8b 00                	mov    (%eax),%eax
  803201:	85 c0                	test   %eax,%eax
  803203:	74 0b                	je     803210 <merging+0x2fe>
  803205:	8b 45 08             	mov    0x8(%ebp),%eax
  803208:	8b 00                	mov    (%eax),%eax
  80320a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80320d:	89 50 04             	mov    %edx,0x4(%eax)
  803210:	8b 45 08             	mov    0x8(%ebp),%eax
  803213:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803216:	89 10                	mov    %edx,(%eax)
  803218:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80321b:	8b 55 08             	mov    0x8(%ebp),%edx
  80321e:	89 50 04             	mov    %edx,0x4(%eax)
  803221:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803224:	8b 00                	mov    (%eax),%eax
  803226:	85 c0                	test   %eax,%eax
  803228:	75 08                	jne    803232 <merging+0x320>
  80322a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80322d:	a3 30 50 80 00       	mov    %eax,0x805030
  803232:	a1 38 50 80 00       	mov    0x805038,%eax
  803237:	40                   	inc    %eax
  803238:	a3 38 50 80 00       	mov    %eax,0x805038
  80323d:	e9 ce 00 00 00       	jmp    803310 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803242:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803246:	74 65                	je     8032ad <merging+0x39b>
  803248:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80324c:	75 17                	jne    803265 <merging+0x353>
  80324e:	83 ec 04             	sub    $0x4,%esp
  803251:	68 3c 46 80 00       	push   $0x80463c
  803256:	68 95 01 00 00       	push   $0x195
  80325b:	68 ed 45 80 00       	push   $0x8045ed
  803260:	e8 a2 d0 ff ff       	call   800307 <_panic>
  803265:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80326b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80326e:	89 50 04             	mov    %edx,0x4(%eax)
  803271:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803274:	8b 40 04             	mov    0x4(%eax),%eax
  803277:	85 c0                	test   %eax,%eax
  803279:	74 0c                	je     803287 <merging+0x375>
  80327b:	a1 30 50 80 00       	mov    0x805030,%eax
  803280:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803283:	89 10                	mov    %edx,(%eax)
  803285:	eb 08                	jmp    80328f <merging+0x37d>
  803287:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80328a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80328f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803292:	a3 30 50 80 00       	mov    %eax,0x805030
  803297:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80329a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032a0:	a1 38 50 80 00       	mov    0x805038,%eax
  8032a5:	40                   	inc    %eax
  8032a6:	a3 38 50 80 00       	mov    %eax,0x805038
  8032ab:	eb 63                	jmp    803310 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8032ad:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8032b1:	75 17                	jne    8032ca <merging+0x3b8>
  8032b3:	83 ec 04             	sub    $0x4,%esp
  8032b6:	68 08 46 80 00       	push   $0x804608
  8032bb:	68 98 01 00 00       	push   $0x198
  8032c0:	68 ed 45 80 00       	push   $0x8045ed
  8032c5:	e8 3d d0 ff ff       	call   800307 <_panic>
  8032ca:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8032d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032d3:	89 10                	mov    %edx,(%eax)
  8032d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032d8:	8b 00                	mov    (%eax),%eax
  8032da:	85 c0                	test   %eax,%eax
  8032dc:	74 0d                	je     8032eb <merging+0x3d9>
  8032de:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032e6:	89 50 04             	mov    %edx,0x4(%eax)
  8032e9:	eb 08                	jmp    8032f3 <merging+0x3e1>
  8032eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032ee:	a3 30 50 80 00       	mov    %eax,0x805030
  8032f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032f6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803305:	a1 38 50 80 00       	mov    0x805038,%eax
  80330a:	40                   	inc    %eax
  80330b:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803310:	83 ec 0c             	sub    $0xc,%esp
  803313:	ff 75 10             	pushl  0x10(%ebp)
  803316:	e8 f9 ed ff ff       	call   802114 <get_block_size>
  80331b:	83 c4 10             	add    $0x10,%esp
  80331e:	83 ec 04             	sub    $0x4,%esp
  803321:	6a 00                	push   $0x0
  803323:	50                   	push   %eax
  803324:	ff 75 10             	pushl  0x10(%ebp)
  803327:	e8 39 f1 ff ff       	call   802465 <set_block_data>
  80332c:	83 c4 10             	add    $0x10,%esp
	}
}
  80332f:	90                   	nop
  803330:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803333:	c9                   	leave  
  803334:	c3                   	ret    

00803335 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803335:	55                   	push   %ebp
  803336:	89 e5                	mov    %esp,%ebp
  803338:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80333b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803340:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803343:	a1 30 50 80 00       	mov    0x805030,%eax
  803348:	3b 45 08             	cmp    0x8(%ebp),%eax
  80334b:	73 1b                	jae    803368 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80334d:	a1 30 50 80 00       	mov    0x805030,%eax
  803352:	83 ec 04             	sub    $0x4,%esp
  803355:	ff 75 08             	pushl  0x8(%ebp)
  803358:	6a 00                	push   $0x0
  80335a:	50                   	push   %eax
  80335b:	e8 b2 fb ff ff       	call   802f12 <merging>
  803360:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803363:	e9 8b 00 00 00       	jmp    8033f3 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803368:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80336d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803370:	76 18                	jbe    80338a <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803372:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803377:	83 ec 04             	sub    $0x4,%esp
  80337a:	ff 75 08             	pushl  0x8(%ebp)
  80337d:	50                   	push   %eax
  80337e:	6a 00                	push   $0x0
  803380:	e8 8d fb ff ff       	call   802f12 <merging>
  803385:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803388:	eb 69                	jmp    8033f3 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80338a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80338f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803392:	eb 39                	jmp    8033cd <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803397:	3b 45 08             	cmp    0x8(%ebp),%eax
  80339a:	73 29                	jae    8033c5 <free_block+0x90>
  80339c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339f:	8b 00                	mov    (%eax),%eax
  8033a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033a4:	76 1f                	jbe    8033c5 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8033a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a9:	8b 00                	mov    (%eax),%eax
  8033ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8033ae:	83 ec 04             	sub    $0x4,%esp
  8033b1:	ff 75 08             	pushl  0x8(%ebp)
  8033b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8033b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8033ba:	e8 53 fb ff ff       	call   802f12 <merging>
  8033bf:	83 c4 10             	add    $0x10,%esp
			break;
  8033c2:	90                   	nop
		}
	}
}
  8033c3:	eb 2e                	jmp    8033f3 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8033c5:	a1 34 50 80 00       	mov    0x805034,%eax
  8033ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d1:	74 07                	je     8033da <free_block+0xa5>
  8033d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d6:	8b 00                	mov    (%eax),%eax
  8033d8:	eb 05                	jmp    8033df <free_block+0xaa>
  8033da:	b8 00 00 00 00       	mov    $0x0,%eax
  8033df:	a3 34 50 80 00       	mov    %eax,0x805034
  8033e4:	a1 34 50 80 00       	mov    0x805034,%eax
  8033e9:	85 c0                	test   %eax,%eax
  8033eb:	75 a7                	jne    803394 <free_block+0x5f>
  8033ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f1:	75 a1                	jne    803394 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8033f3:	90                   	nop
  8033f4:	c9                   	leave  
  8033f5:	c3                   	ret    

008033f6 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8033f6:	55                   	push   %ebp
  8033f7:	89 e5                	mov    %esp,%ebp
  8033f9:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8033fc:	ff 75 08             	pushl  0x8(%ebp)
  8033ff:	e8 10 ed ff ff       	call   802114 <get_block_size>
  803404:	83 c4 04             	add    $0x4,%esp
  803407:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80340a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803411:	eb 17                	jmp    80342a <copy_data+0x34>
  803413:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803416:	8b 45 0c             	mov    0xc(%ebp),%eax
  803419:	01 c2                	add    %eax,%edx
  80341b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80341e:	8b 45 08             	mov    0x8(%ebp),%eax
  803421:	01 c8                	add    %ecx,%eax
  803423:	8a 00                	mov    (%eax),%al
  803425:	88 02                	mov    %al,(%edx)
  803427:	ff 45 fc             	incl   -0x4(%ebp)
  80342a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80342d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803430:	72 e1                	jb     803413 <copy_data+0x1d>
}
  803432:	90                   	nop
  803433:	c9                   	leave  
  803434:	c3                   	ret    

00803435 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803435:	55                   	push   %ebp
  803436:	89 e5                	mov    %esp,%ebp
  803438:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80343b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80343f:	75 23                	jne    803464 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803441:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803445:	74 13                	je     80345a <realloc_block_FF+0x25>
  803447:	83 ec 0c             	sub    $0xc,%esp
  80344a:	ff 75 0c             	pushl  0xc(%ebp)
  80344d:	e8 42 f0 ff ff       	call   802494 <alloc_block_FF>
  803452:	83 c4 10             	add    $0x10,%esp
  803455:	e9 e4 06 00 00       	jmp    803b3e <realloc_block_FF+0x709>
		return NULL;
  80345a:	b8 00 00 00 00       	mov    $0x0,%eax
  80345f:	e9 da 06 00 00       	jmp    803b3e <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803464:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803468:	75 18                	jne    803482 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80346a:	83 ec 0c             	sub    $0xc,%esp
  80346d:	ff 75 08             	pushl  0x8(%ebp)
  803470:	e8 c0 fe ff ff       	call   803335 <free_block>
  803475:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803478:	b8 00 00 00 00       	mov    $0x0,%eax
  80347d:	e9 bc 06 00 00       	jmp    803b3e <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803482:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803486:	77 07                	ja     80348f <realloc_block_FF+0x5a>
  803488:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80348f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803492:	83 e0 01             	and    $0x1,%eax
  803495:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803498:	8b 45 0c             	mov    0xc(%ebp),%eax
  80349b:	83 c0 08             	add    $0x8,%eax
  80349e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8034a1:	83 ec 0c             	sub    $0xc,%esp
  8034a4:	ff 75 08             	pushl  0x8(%ebp)
  8034a7:	e8 68 ec ff ff       	call   802114 <get_block_size>
  8034ac:	83 c4 10             	add    $0x10,%esp
  8034af:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8034b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034b5:	83 e8 08             	sub    $0x8,%eax
  8034b8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8034bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034be:	83 e8 04             	sub    $0x4,%eax
  8034c1:	8b 00                	mov    (%eax),%eax
  8034c3:	83 e0 fe             	and    $0xfffffffe,%eax
  8034c6:	89 c2                	mov    %eax,%edx
  8034c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cb:	01 d0                	add    %edx,%eax
  8034cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8034d0:	83 ec 0c             	sub    $0xc,%esp
  8034d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034d6:	e8 39 ec ff ff       	call   802114 <get_block_size>
  8034db:	83 c4 10             	add    $0x10,%esp
  8034de:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8034e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034e4:	83 e8 08             	sub    $0x8,%eax
  8034e7:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8034ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ed:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034f0:	75 08                	jne    8034fa <realloc_block_FF+0xc5>
	{
		 return va;
  8034f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f5:	e9 44 06 00 00       	jmp    803b3e <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  8034fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034fd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803500:	0f 83 d5 03 00 00    	jae    8038db <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803506:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803509:	2b 45 0c             	sub    0xc(%ebp),%eax
  80350c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80350f:	83 ec 0c             	sub    $0xc,%esp
  803512:	ff 75 e4             	pushl  -0x1c(%ebp)
  803515:	e8 13 ec ff ff       	call   80212d <is_free_block>
  80351a:	83 c4 10             	add    $0x10,%esp
  80351d:	84 c0                	test   %al,%al
  80351f:	0f 84 3b 01 00 00    	je     803660 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803525:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803528:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80352b:	01 d0                	add    %edx,%eax
  80352d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803530:	83 ec 04             	sub    $0x4,%esp
  803533:	6a 01                	push   $0x1
  803535:	ff 75 f0             	pushl  -0x10(%ebp)
  803538:	ff 75 08             	pushl  0x8(%ebp)
  80353b:	e8 25 ef ff ff       	call   802465 <set_block_data>
  803540:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803543:	8b 45 08             	mov    0x8(%ebp),%eax
  803546:	83 e8 04             	sub    $0x4,%eax
  803549:	8b 00                	mov    (%eax),%eax
  80354b:	83 e0 fe             	and    $0xfffffffe,%eax
  80354e:	89 c2                	mov    %eax,%edx
  803550:	8b 45 08             	mov    0x8(%ebp),%eax
  803553:	01 d0                	add    %edx,%eax
  803555:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803558:	83 ec 04             	sub    $0x4,%esp
  80355b:	6a 00                	push   $0x0
  80355d:	ff 75 cc             	pushl  -0x34(%ebp)
  803560:	ff 75 c8             	pushl  -0x38(%ebp)
  803563:	e8 fd ee ff ff       	call   802465 <set_block_data>
  803568:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80356b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80356f:	74 06                	je     803577 <realloc_block_FF+0x142>
  803571:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803575:	75 17                	jne    80358e <realloc_block_FF+0x159>
  803577:	83 ec 04             	sub    $0x4,%esp
  80357a:	68 60 46 80 00       	push   $0x804660
  80357f:	68 f6 01 00 00       	push   $0x1f6
  803584:	68 ed 45 80 00       	push   $0x8045ed
  803589:	e8 79 cd ff ff       	call   800307 <_panic>
  80358e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803591:	8b 10                	mov    (%eax),%edx
  803593:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803596:	89 10                	mov    %edx,(%eax)
  803598:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80359b:	8b 00                	mov    (%eax),%eax
  80359d:	85 c0                	test   %eax,%eax
  80359f:	74 0b                	je     8035ac <realloc_block_FF+0x177>
  8035a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a4:	8b 00                	mov    (%eax),%eax
  8035a6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035a9:	89 50 04             	mov    %edx,0x4(%eax)
  8035ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035af:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035b2:	89 10                	mov    %edx,(%eax)
  8035b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035ba:	89 50 04             	mov    %edx,0x4(%eax)
  8035bd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035c0:	8b 00                	mov    (%eax),%eax
  8035c2:	85 c0                	test   %eax,%eax
  8035c4:	75 08                	jne    8035ce <realloc_block_FF+0x199>
  8035c6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035c9:	a3 30 50 80 00       	mov    %eax,0x805030
  8035ce:	a1 38 50 80 00       	mov    0x805038,%eax
  8035d3:	40                   	inc    %eax
  8035d4:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8035d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035dd:	75 17                	jne    8035f6 <realloc_block_FF+0x1c1>
  8035df:	83 ec 04             	sub    $0x4,%esp
  8035e2:	68 cf 45 80 00       	push   $0x8045cf
  8035e7:	68 f7 01 00 00       	push   $0x1f7
  8035ec:	68 ed 45 80 00       	push   $0x8045ed
  8035f1:	e8 11 cd ff ff       	call   800307 <_panic>
  8035f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f9:	8b 00                	mov    (%eax),%eax
  8035fb:	85 c0                	test   %eax,%eax
  8035fd:	74 10                	je     80360f <realloc_block_FF+0x1da>
  8035ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803602:	8b 00                	mov    (%eax),%eax
  803604:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803607:	8b 52 04             	mov    0x4(%edx),%edx
  80360a:	89 50 04             	mov    %edx,0x4(%eax)
  80360d:	eb 0b                	jmp    80361a <realloc_block_FF+0x1e5>
  80360f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803612:	8b 40 04             	mov    0x4(%eax),%eax
  803615:	a3 30 50 80 00       	mov    %eax,0x805030
  80361a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361d:	8b 40 04             	mov    0x4(%eax),%eax
  803620:	85 c0                	test   %eax,%eax
  803622:	74 0f                	je     803633 <realloc_block_FF+0x1fe>
  803624:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803627:	8b 40 04             	mov    0x4(%eax),%eax
  80362a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80362d:	8b 12                	mov    (%edx),%edx
  80362f:	89 10                	mov    %edx,(%eax)
  803631:	eb 0a                	jmp    80363d <realloc_block_FF+0x208>
  803633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803636:	8b 00                	mov    (%eax),%eax
  803638:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80363d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803640:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803646:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803649:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803650:	a1 38 50 80 00       	mov    0x805038,%eax
  803655:	48                   	dec    %eax
  803656:	a3 38 50 80 00       	mov    %eax,0x805038
  80365b:	e9 73 02 00 00       	jmp    8038d3 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803660:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803664:	0f 86 69 02 00 00    	jbe    8038d3 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80366a:	83 ec 04             	sub    $0x4,%esp
  80366d:	6a 01                	push   $0x1
  80366f:	ff 75 f0             	pushl  -0x10(%ebp)
  803672:	ff 75 08             	pushl  0x8(%ebp)
  803675:	e8 eb ed ff ff       	call   802465 <set_block_data>
  80367a:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80367d:	8b 45 08             	mov    0x8(%ebp),%eax
  803680:	83 e8 04             	sub    $0x4,%eax
  803683:	8b 00                	mov    (%eax),%eax
  803685:	83 e0 fe             	and    $0xfffffffe,%eax
  803688:	89 c2                	mov    %eax,%edx
  80368a:	8b 45 08             	mov    0x8(%ebp),%eax
  80368d:	01 d0                	add    %edx,%eax
  80368f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803692:	a1 38 50 80 00       	mov    0x805038,%eax
  803697:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80369a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80369e:	75 68                	jne    803708 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036a0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036a4:	75 17                	jne    8036bd <realloc_block_FF+0x288>
  8036a6:	83 ec 04             	sub    $0x4,%esp
  8036a9:	68 08 46 80 00       	push   $0x804608
  8036ae:	68 06 02 00 00       	push   $0x206
  8036b3:	68 ed 45 80 00       	push   $0x8045ed
  8036b8:	e8 4a cc ff ff       	call   800307 <_panic>
  8036bd:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8036c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c6:	89 10                	mov    %edx,(%eax)
  8036c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036cb:	8b 00                	mov    (%eax),%eax
  8036cd:	85 c0                	test   %eax,%eax
  8036cf:	74 0d                	je     8036de <realloc_block_FF+0x2a9>
  8036d1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036d6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036d9:	89 50 04             	mov    %edx,0x4(%eax)
  8036dc:	eb 08                	jmp    8036e6 <realloc_block_FF+0x2b1>
  8036de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e1:	a3 30 50 80 00       	mov    %eax,0x805030
  8036e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036f8:	a1 38 50 80 00       	mov    0x805038,%eax
  8036fd:	40                   	inc    %eax
  8036fe:	a3 38 50 80 00       	mov    %eax,0x805038
  803703:	e9 b0 01 00 00       	jmp    8038b8 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803708:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80370d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803710:	76 68                	jbe    80377a <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803712:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803716:	75 17                	jne    80372f <realloc_block_FF+0x2fa>
  803718:	83 ec 04             	sub    $0x4,%esp
  80371b:	68 08 46 80 00       	push   $0x804608
  803720:	68 0b 02 00 00       	push   $0x20b
  803725:	68 ed 45 80 00       	push   $0x8045ed
  80372a:	e8 d8 cb ff ff       	call   800307 <_panic>
  80372f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803735:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803738:	89 10                	mov    %edx,(%eax)
  80373a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80373d:	8b 00                	mov    (%eax),%eax
  80373f:	85 c0                	test   %eax,%eax
  803741:	74 0d                	je     803750 <realloc_block_FF+0x31b>
  803743:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803748:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80374b:	89 50 04             	mov    %edx,0x4(%eax)
  80374e:	eb 08                	jmp    803758 <realloc_block_FF+0x323>
  803750:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803753:	a3 30 50 80 00       	mov    %eax,0x805030
  803758:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80375b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803760:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803763:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80376a:	a1 38 50 80 00       	mov    0x805038,%eax
  80376f:	40                   	inc    %eax
  803770:	a3 38 50 80 00       	mov    %eax,0x805038
  803775:	e9 3e 01 00 00       	jmp    8038b8 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80377a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80377f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803782:	73 68                	jae    8037ec <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803784:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803788:	75 17                	jne    8037a1 <realloc_block_FF+0x36c>
  80378a:	83 ec 04             	sub    $0x4,%esp
  80378d:	68 3c 46 80 00       	push   $0x80463c
  803792:	68 10 02 00 00       	push   $0x210
  803797:	68 ed 45 80 00       	push   $0x8045ed
  80379c:	e8 66 cb ff ff       	call   800307 <_panic>
  8037a1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8037a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037aa:	89 50 04             	mov    %edx,0x4(%eax)
  8037ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037b0:	8b 40 04             	mov    0x4(%eax),%eax
  8037b3:	85 c0                	test   %eax,%eax
  8037b5:	74 0c                	je     8037c3 <realloc_block_FF+0x38e>
  8037b7:	a1 30 50 80 00       	mov    0x805030,%eax
  8037bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037bf:	89 10                	mov    %edx,(%eax)
  8037c1:	eb 08                	jmp    8037cb <realloc_block_FF+0x396>
  8037c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037c6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037ce:	a3 30 50 80 00       	mov    %eax,0x805030
  8037d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037dc:	a1 38 50 80 00       	mov    0x805038,%eax
  8037e1:	40                   	inc    %eax
  8037e2:	a3 38 50 80 00       	mov    %eax,0x805038
  8037e7:	e9 cc 00 00 00       	jmp    8038b8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8037ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8037f3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8037f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037fb:	e9 8a 00 00 00       	jmp    80388a <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803803:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803806:	73 7a                	jae    803882 <realloc_block_FF+0x44d>
  803808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380b:	8b 00                	mov    (%eax),%eax
  80380d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803810:	73 70                	jae    803882 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803812:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803816:	74 06                	je     80381e <realloc_block_FF+0x3e9>
  803818:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80381c:	75 17                	jne    803835 <realloc_block_FF+0x400>
  80381e:	83 ec 04             	sub    $0x4,%esp
  803821:	68 60 46 80 00       	push   $0x804660
  803826:	68 1a 02 00 00       	push   $0x21a
  80382b:	68 ed 45 80 00       	push   $0x8045ed
  803830:	e8 d2 ca ff ff       	call   800307 <_panic>
  803835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803838:	8b 10                	mov    (%eax),%edx
  80383a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80383d:	89 10                	mov    %edx,(%eax)
  80383f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803842:	8b 00                	mov    (%eax),%eax
  803844:	85 c0                	test   %eax,%eax
  803846:	74 0b                	je     803853 <realloc_block_FF+0x41e>
  803848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384b:	8b 00                	mov    (%eax),%eax
  80384d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803850:	89 50 04             	mov    %edx,0x4(%eax)
  803853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803856:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803859:	89 10                	mov    %edx,(%eax)
  80385b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80385e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803861:	89 50 04             	mov    %edx,0x4(%eax)
  803864:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803867:	8b 00                	mov    (%eax),%eax
  803869:	85 c0                	test   %eax,%eax
  80386b:	75 08                	jne    803875 <realloc_block_FF+0x440>
  80386d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803870:	a3 30 50 80 00       	mov    %eax,0x805030
  803875:	a1 38 50 80 00       	mov    0x805038,%eax
  80387a:	40                   	inc    %eax
  80387b:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803880:	eb 36                	jmp    8038b8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803882:	a1 34 50 80 00       	mov    0x805034,%eax
  803887:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80388a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80388e:	74 07                	je     803897 <realloc_block_FF+0x462>
  803890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803893:	8b 00                	mov    (%eax),%eax
  803895:	eb 05                	jmp    80389c <realloc_block_FF+0x467>
  803897:	b8 00 00 00 00       	mov    $0x0,%eax
  80389c:	a3 34 50 80 00       	mov    %eax,0x805034
  8038a1:	a1 34 50 80 00       	mov    0x805034,%eax
  8038a6:	85 c0                	test   %eax,%eax
  8038a8:	0f 85 52 ff ff ff    	jne    803800 <realloc_block_FF+0x3cb>
  8038ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038b2:	0f 85 48 ff ff ff    	jne    803800 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8038b8:	83 ec 04             	sub    $0x4,%esp
  8038bb:	6a 00                	push   $0x0
  8038bd:	ff 75 d8             	pushl  -0x28(%ebp)
  8038c0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8038c3:	e8 9d eb ff ff       	call   802465 <set_block_data>
  8038c8:	83 c4 10             	add    $0x10,%esp
				return va;
  8038cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ce:	e9 6b 02 00 00       	jmp    803b3e <realloc_block_FF+0x709>
			}
			
		}
		return va;
  8038d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d6:	e9 63 02 00 00       	jmp    803b3e <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  8038db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038de:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038e1:	0f 86 4d 02 00 00    	jbe    803b34 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  8038e7:	83 ec 0c             	sub    $0xc,%esp
  8038ea:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038ed:	e8 3b e8 ff ff       	call   80212d <is_free_block>
  8038f2:	83 c4 10             	add    $0x10,%esp
  8038f5:	84 c0                	test   %al,%al
  8038f7:	0f 84 37 02 00 00    	je     803b34 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8038fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803900:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803903:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803906:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803909:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80390c:	76 38                	jbe    803946 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  80390e:	83 ec 0c             	sub    $0xc,%esp
  803911:	ff 75 0c             	pushl  0xc(%ebp)
  803914:	e8 7b eb ff ff       	call   802494 <alloc_block_FF>
  803919:	83 c4 10             	add    $0x10,%esp
  80391c:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80391f:	83 ec 08             	sub    $0x8,%esp
  803922:	ff 75 c0             	pushl  -0x40(%ebp)
  803925:	ff 75 08             	pushl  0x8(%ebp)
  803928:	e8 c9 fa ff ff       	call   8033f6 <copy_data>
  80392d:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803930:	83 ec 0c             	sub    $0xc,%esp
  803933:	ff 75 08             	pushl  0x8(%ebp)
  803936:	e8 fa f9 ff ff       	call   803335 <free_block>
  80393b:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80393e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803941:	e9 f8 01 00 00       	jmp    803b3e <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803946:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803949:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80394c:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80394f:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803953:	0f 87 a0 00 00 00    	ja     8039f9 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803959:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80395d:	75 17                	jne    803976 <realloc_block_FF+0x541>
  80395f:	83 ec 04             	sub    $0x4,%esp
  803962:	68 cf 45 80 00       	push   $0x8045cf
  803967:	68 38 02 00 00       	push   $0x238
  80396c:	68 ed 45 80 00       	push   $0x8045ed
  803971:	e8 91 c9 ff ff       	call   800307 <_panic>
  803976:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803979:	8b 00                	mov    (%eax),%eax
  80397b:	85 c0                	test   %eax,%eax
  80397d:	74 10                	je     80398f <realloc_block_FF+0x55a>
  80397f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803982:	8b 00                	mov    (%eax),%eax
  803984:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803987:	8b 52 04             	mov    0x4(%edx),%edx
  80398a:	89 50 04             	mov    %edx,0x4(%eax)
  80398d:	eb 0b                	jmp    80399a <realloc_block_FF+0x565>
  80398f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803992:	8b 40 04             	mov    0x4(%eax),%eax
  803995:	a3 30 50 80 00       	mov    %eax,0x805030
  80399a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399d:	8b 40 04             	mov    0x4(%eax),%eax
  8039a0:	85 c0                	test   %eax,%eax
  8039a2:	74 0f                	je     8039b3 <realloc_block_FF+0x57e>
  8039a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a7:	8b 40 04             	mov    0x4(%eax),%eax
  8039aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039ad:	8b 12                	mov    (%edx),%edx
  8039af:	89 10                	mov    %edx,(%eax)
  8039b1:	eb 0a                	jmp    8039bd <realloc_block_FF+0x588>
  8039b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b6:	8b 00                	mov    (%eax),%eax
  8039b8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039d0:	a1 38 50 80 00       	mov    0x805038,%eax
  8039d5:	48                   	dec    %eax
  8039d6:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8039db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039e1:	01 d0                	add    %edx,%eax
  8039e3:	83 ec 04             	sub    $0x4,%esp
  8039e6:	6a 01                	push   $0x1
  8039e8:	50                   	push   %eax
  8039e9:	ff 75 08             	pushl  0x8(%ebp)
  8039ec:	e8 74 ea ff ff       	call   802465 <set_block_data>
  8039f1:	83 c4 10             	add    $0x10,%esp
  8039f4:	e9 36 01 00 00       	jmp    803b2f <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8039f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039fc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8039ff:	01 d0                	add    %edx,%eax
  803a01:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803a04:	83 ec 04             	sub    $0x4,%esp
  803a07:	6a 01                	push   $0x1
  803a09:	ff 75 f0             	pushl  -0x10(%ebp)
  803a0c:	ff 75 08             	pushl  0x8(%ebp)
  803a0f:	e8 51 ea ff ff       	call   802465 <set_block_data>
  803a14:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a17:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1a:	83 e8 04             	sub    $0x4,%eax
  803a1d:	8b 00                	mov    (%eax),%eax
  803a1f:	83 e0 fe             	and    $0xfffffffe,%eax
  803a22:	89 c2                	mov    %eax,%edx
  803a24:	8b 45 08             	mov    0x8(%ebp),%eax
  803a27:	01 d0                	add    %edx,%eax
  803a29:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a2c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a30:	74 06                	je     803a38 <realloc_block_FF+0x603>
  803a32:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803a36:	75 17                	jne    803a4f <realloc_block_FF+0x61a>
  803a38:	83 ec 04             	sub    $0x4,%esp
  803a3b:	68 60 46 80 00       	push   $0x804660
  803a40:	68 44 02 00 00       	push   $0x244
  803a45:	68 ed 45 80 00       	push   $0x8045ed
  803a4a:	e8 b8 c8 ff ff       	call   800307 <_panic>
  803a4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a52:	8b 10                	mov    (%eax),%edx
  803a54:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a57:	89 10                	mov    %edx,(%eax)
  803a59:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a5c:	8b 00                	mov    (%eax),%eax
  803a5e:	85 c0                	test   %eax,%eax
  803a60:	74 0b                	je     803a6d <realloc_block_FF+0x638>
  803a62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a65:	8b 00                	mov    (%eax),%eax
  803a67:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a6a:	89 50 04             	mov    %edx,0x4(%eax)
  803a6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a70:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a73:	89 10                	mov    %edx,(%eax)
  803a75:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a78:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a7b:	89 50 04             	mov    %edx,0x4(%eax)
  803a7e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a81:	8b 00                	mov    (%eax),%eax
  803a83:	85 c0                	test   %eax,%eax
  803a85:	75 08                	jne    803a8f <realloc_block_FF+0x65a>
  803a87:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a8a:	a3 30 50 80 00       	mov    %eax,0x805030
  803a8f:	a1 38 50 80 00       	mov    0x805038,%eax
  803a94:	40                   	inc    %eax
  803a95:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a9e:	75 17                	jne    803ab7 <realloc_block_FF+0x682>
  803aa0:	83 ec 04             	sub    $0x4,%esp
  803aa3:	68 cf 45 80 00       	push   $0x8045cf
  803aa8:	68 45 02 00 00       	push   $0x245
  803aad:	68 ed 45 80 00       	push   $0x8045ed
  803ab2:	e8 50 c8 ff ff       	call   800307 <_panic>
  803ab7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aba:	8b 00                	mov    (%eax),%eax
  803abc:	85 c0                	test   %eax,%eax
  803abe:	74 10                	je     803ad0 <realloc_block_FF+0x69b>
  803ac0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac3:	8b 00                	mov    (%eax),%eax
  803ac5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ac8:	8b 52 04             	mov    0x4(%edx),%edx
  803acb:	89 50 04             	mov    %edx,0x4(%eax)
  803ace:	eb 0b                	jmp    803adb <realloc_block_FF+0x6a6>
  803ad0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad3:	8b 40 04             	mov    0x4(%eax),%eax
  803ad6:	a3 30 50 80 00       	mov    %eax,0x805030
  803adb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ade:	8b 40 04             	mov    0x4(%eax),%eax
  803ae1:	85 c0                	test   %eax,%eax
  803ae3:	74 0f                	je     803af4 <realloc_block_FF+0x6bf>
  803ae5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae8:	8b 40 04             	mov    0x4(%eax),%eax
  803aeb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803aee:	8b 12                	mov    (%edx),%edx
  803af0:	89 10                	mov    %edx,(%eax)
  803af2:	eb 0a                	jmp    803afe <realloc_block_FF+0x6c9>
  803af4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af7:	8b 00                	mov    (%eax),%eax
  803af9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803afe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b11:	a1 38 50 80 00       	mov    0x805038,%eax
  803b16:	48                   	dec    %eax
  803b17:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803b1c:	83 ec 04             	sub    $0x4,%esp
  803b1f:	6a 00                	push   $0x0
  803b21:	ff 75 bc             	pushl  -0x44(%ebp)
  803b24:	ff 75 b8             	pushl  -0x48(%ebp)
  803b27:	e8 39 e9 ff ff       	call   802465 <set_block_data>
  803b2c:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b32:	eb 0a                	jmp    803b3e <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803b34:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803b3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803b3e:	c9                   	leave  
  803b3f:	c3                   	ret    

00803b40 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803b40:	55                   	push   %ebp
  803b41:	89 e5                	mov    %esp,%ebp
  803b43:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803b46:	83 ec 04             	sub    $0x4,%esp
  803b49:	68 cc 46 80 00       	push   $0x8046cc
  803b4e:	68 58 02 00 00       	push   $0x258
  803b53:	68 ed 45 80 00       	push   $0x8045ed
  803b58:	e8 aa c7 ff ff       	call   800307 <_panic>

00803b5d <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803b5d:	55                   	push   %ebp
  803b5e:	89 e5                	mov    %esp,%ebp
  803b60:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803b63:	83 ec 04             	sub    $0x4,%esp
  803b66:	68 f4 46 80 00       	push   $0x8046f4
  803b6b:	68 61 02 00 00       	push   $0x261
  803b70:	68 ed 45 80 00       	push   $0x8045ed
  803b75:	e8 8d c7 ff ff       	call   800307 <_panic>
  803b7a:	66 90                	xchg   %ax,%ax

00803b7c <__udivdi3>:
  803b7c:	55                   	push   %ebp
  803b7d:	57                   	push   %edi
  803b7e:	56                   	push   %esi
  803b7f:	53                   	push   %ebx
  803b80:	83 ec 1c             	sub    $0x1c,%esp
  803b83:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b87:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b8f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b93:	89 ca                	mov    %ecx,%edx
  803b95:	89 f8                	mov    %edi,%eax
  803b97:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b9b:	85 f6                	test   %esi,%esi
  803b9d:	75 2d                	jne    803bcc <__udivdi3+0x50>
  803b9f:	39 cf                	cmp    %ecx,%edi
  803ba1:	77 65                	ja     803c08 <__udivdi3+0x8c>
  803ba3:	89 fd                	mov    %edi,%ebp
  803ba5:	85 ff                	test   %edi,%edi
  803ba7:	75 0b                	jne    803bb4 <__udivdi3+0x38>
  803ba9:	b8 01 00 00 00       	mov    $0x1,%eax
  803bae:	31 d2                	xor    %edx,%edx
  803bb0:	f7 f7                	div    %edi
  803bb2:	89 c5                	mov    %eax,%ebp
  803bb4:	31 d2                	xor    %edx,%edx
  803bb6:	89 c8                	mov    %ecx,%eax
  803bb8:	f7 f5                	div    %ebp
  803bba:	89 c1                	mov    %eax,%ecx
  803bbc:	89 d8                	mov    %ebx,%eax
  803bbe:	f7 f5                	div    %ebp
  803bc0:	89 cf                	mov    %ecx,%edi
  803bc2:	89 fa                	mov    %edi,%edx
  803bc4:	83 c4 1c             	add    $0x1c,%esp
  803bc7:	5b                   	pop    %ebx
  803bc8:	5e                   	pop    %esi
  803bc9:	5f                   	pop    %edi
  803bca:	5d                   	pop    %ebp
  803bcb:	c3                   	ret    
  803bcc:	39 ce                	cmp    %ecx,%esi
  803bce:	77 28                	ja     803bf8 <__udivdi3+0x7c>
  803bd0:	0f bd fe             	bsr    %esi,%edi
  803bd3:	83 f7 1f             	xor    $0x1f,%edi
  803bd6:	75 40                	jne    803c18 <__udivdi3+0x9c>
  803bd8:	39 ce                	cmp    %ecx,%esi
  803bda:	72 0a                	jb     803be6 <__udivdi3+0x6a>
  803bdc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803be0:	0f 87 9e 00 00 00    	ja     803c84 <__udivdi3+0x108>
  803be6:	b8 01 00 00 00       	mov    $0x1,%eax
  803beb:	89 fa                	mov    %edi,%edx
  803bed:	83 c4 1c             	add    $0x1c,%esp
  803bf0:	5b                   	pop    %ebx
  803bf1:	5e                   	pop    %esi
  803bf2:	5f                   	pop    %edi
  803bf3:	5d                   	pop    %ebp
  803bf4:	c3                   	ret    
  803bf5:	8d 76 00             	lea    0x0(%esi),%esi
  803bf8:	31 ff                	xor    %edi,%edi
  803bfa:	31 c0                	xor    %eax,%eax
  803bfc:	89 fa                	mov    %edi,%edx
  803bfe:	83 c4 1c             	add    $0x1c,%esp
  803c01:	5b                   	pop    %ebx
  803c02:	5e                   	pop    %esi
  803c03:	5f                   	pop    %edi
  803c04:	5d                   	pop    %ebp
  803c05:	c3                   	ret    
  803c06:	66 90                	xchg   %ax,%ax
  803c08:	89 d8                	mov    %ebx,%eax
  803c0a:	f7 f7                	div    %edi
  803c0c:	31 ff                	xor    %edi,%edi
  803c0e:	89 fa                	mov    %edi,%edx
  803c10:	83 c4 1c             	add    $0x1c,%esp
  803c13:	5b                   	pop    %ebx
  803c14:	5e                   	pop    %esi
  803c15:	5f                   	pop    %edi
  803c16:	5d                   	pop    %ebp
  803c17:	c3                   	ret    
  803c18:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c1d:	89 eb                	mov    %ebp,%ebx
  803c1f:	29 fb                	sub    %edi,%ebx
  803c21:	89 f9                	mov    %edi,%ecx
  803c23:	d3 e6                	shl    %cl,%esi
  803c25:	89 c5                	mov    %eax,%ebp
  803c27:	88 d9                	mov    %bl,%cl
  803c29:	d3 ed                	shr    %cl,%ebp
  803c2b:	89 e9                	mov    %ebp,%ecx
  803c2d:	09 f1                	or     %esi,%ecx
  803c2f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c33:	89 f9                	mov    %edi,%ecx
  803c35:	d3 e0                	shl    %cl,%eax
  803c37:	89 c5                	mov    %eax,%ebp
  803c39:	89 d6                	mov    %edx,%esi
  803c3b:	88 d9                	mov    %bl,%cl
  803c3d:	d3 ee                	shr    %cl,%esi
  803c3f:	89 f9                	mov    %edi,%ecx
  803c41:	d3 e2                	shl    %cl,%edx
  803c43:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c47:	88 d9                	mov    %bl,%cl
  803c49:	d3 e8                	shr    %cl,%eax
  803c4b:	09 c2                	or     %eax,%edx
  803c4d:	89 d0                	mov    %edx,%eax
  803c4f:	89 f2                	mov    %esi,%edx
  803c51:	f7 74 24 0c          	divl   0xc(%esp)
  803c55:	89 d6                	mov    %edx,%esi
  803c57:	89 c3                	mov    %eax,%ebx
  803c59:	f7 e5                	mul    %ebp
  803c5b:	39 d6                	cmp    %edx,%esi
  803c5d:	72 19                	jb     803c78 <__udivdi3+0xfc>
  803c5f:	74 0b                	je     803c6c <__udivdi3+0xf0>
  803c61:	89 d8                	mov    %ebx,%eax
  803c63:	31 ff                	xor    %edi,%edi
  803c65:	e9 58 ff ff ff       	jmp    803bc2 <__udivdi3+0x46>
  803c6a:	66 90                	xchg   %ax,%ax
  803c6c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c70:	89 f9                	mov    %edi,%ecx
  803c72:	d3 e2                	shl    %cl,%edx
  803c74:	39 c2                	cmp    %eax,%edx
  803c76:	73 e9                	jae    803c61 <__udivdi3+0xe5>
  803c78:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c7b:	31 ff                	xor    %edi,%edi
  803c7d:	e9 40 ff ff ff       	jmp    803bc2 <__udivdi3+0x46>
  803c82:	66 90                	xchg   %ax,%ax
  803c84:	31 c0                	xor    %eax,%eax
  803c86:	e9 37 ff ff ff       	jmp    803bc2 <__udivdi3+0x46>
  803c8b:	90                   	nop

00803c8c <__umoddi3>:
  803c8c:	55                   	push   %ebp
  803c8d:	57                   	push   %edi
  803c8e:	56                   	push   %esi
  803c8f:	53                   	push   %ebx
  803c90:	83 ec 1c             	sub    $0x1c,%esp
  803c93:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c97:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c9f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803ca3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ca7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803cab:	89 f3                	mov    %esi,%ebx
  803cad:	89 fa                	mov    %edi,%edx
  803caf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803cb3:	89 34 24             	mov    %esi,(%esp)
  803cb6:	85 c0                	test   %eax,%eax
  803cb8:	75 1a                	jne    803cd4 <__umoddi3+0x48>
  803cba:	39 f7                	cmp    %esi,%edi
  803cbc:	0f 86 a2 00 00 00    	jbe    803d64 <__umoddi3+0xd8>
  803cc2:	89 c8                	mov    %ecx,%eax
  803cc4:	89 f2                	mov    %esi,%edx
  803cc6:	f7 f7                	div    %edi
  803cc8:	89 d0                	mov    %edx,%eax
  803cca:	31 d2                	xor    %edx,%edx
  803ccc:	83 c4 1c             	add    $0x1c,%esp
  803ccf:	5b                   	pop    %ebx
  803cd0:	5e                   	pop    %esi
  803cd1:	5f                   	pop    %edi
  803cd2:	5d                   	pop    %ebp
  803cd3:	c3                   	ret    
  803cd4:	39 f0                	cmp    %esi,%eax
  803cd6:	0f 87 ac 00 00 00    	ja     803d88 <__umoddi3+0xfc>
  803cdc:	0f bd e8             	bsr    %eax,%ebp
  803cdf:	83 f5 1f             	xor    $0x1f,%ebp
  803ce2:	0f 84 ac 00 00 00    	je     803d94 <__umoddi3+0x108>
  803ce8:	bf 20 00 00 00       	mov    $0x20,%edi
  803ced:	29 ef                	sub    %ebp,%edi
  803cef:	89 fe                	mov    %edi,%esi
  803cf1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803cf5:	89 e9                	mov    %ebp,%ecx
  803cf7:	d3 e0                	shl    %cl,%eax
  803cf9:	89 d7                	mov    %edx,%edi
  803cfb:	89 f1                	mov    %esi,%ecx
  803cfd:	d3 ef                	shr    %cl,%edi
  803cff:	09 c7                	or     %eax,%edi
  803d01:	89 e9                	mov    %ebp,%ecx
  803d03:	d3 e2                	shl    %cl,%edx
  803d05:	89 14 24             	mov    %edx,(%esp)
  803d08:	89 d8                	mov    %ebx,%eax
  803d0a:	d3 e0                	shl    %cl,%eax
  803d0c:	89 c2                	mov    %eax,%edx
  803d0e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d12:	d3 e0                	shl    %cl,%eax
  803d14:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d18:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d1c:	89 f1                	mov    %esi,%ecx
  803d1e:	d3 e8                	shr    %cl,%eax
  803d20:	09 d0                	or     %edx,%eax
  803d22:	d3 eb                	shr    %cl,%ebx
  803d24:	89 da                	mov    %ebx,%edx
  803d26:	f7 f7                	div    %edi
  803d28:	89 d3                	mov    %edx,%ebx
  803d2a:	f7 24 24             	mull   (%esp)
  803d2d:	89 c6                	mov    %eax,%esi
  803d2f:	89 d1                	mov    %edx,%ecx
  803d31:	39 d3                	cmp    %edx,%ebx
  803d33:	0f 82 87 00 00 00    	jb     803dc0 <__umoddi3+0x134>
  803d39:	0f 84 91 00 00 00    	je     803dd0 <__umoddi3+0x144>
  803d3f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d43:	29 f2                	sub    %esi,%edx
  803d45:	19 cb                	sbb    %ecx,%ebx
  803d47:	89 d8                	mov    %ebx,%eax
  803d49:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d4d:	d3 e0                	shl    %cl,%eax
  803d4f:	89 e9                	mov    %ebp,%ecx
  803d51:	d3 ea                	shr    %cl,%edx
  803d53:	09 d0                	or     %edx,%eax
  803d55:	89 e9                	mov    %ebp,%ecx
  803d57:	d3 eb                	shr    %cl,%ebx
  803d59:	89 da                	mov    %ebx,%edx
  803d5b:	83 c4 1c             	add    $0x1c,%esp
  803d5e:	5b                   	pop    %ebx
  803d5f:	5e                   	pop    %esi
  803d60:	5f                   	pop    %edi
  803d61:	5d                   	pop    %ebp
  803d62:	c3                   	ret    
  803d63:	90                   	nop
  803d64:	89 fd                	mov    %edi,%ebp
  803d66:	85 ff                	test   %edi,%edi
  803d68:	75 0b                	jne    803d75 <__umoddi3+0xe9>
  803d6a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d6f:	31 d2                	xor    %edx,%edx
  803d71:	f7 f7                	div    %edi
  803d73:	89 c5                	mov    %eax,%ebp
  803d75:	89 f0                	mov    %esi,%eax
  803d77:	31 d2                	xor    %edx,%edx
  803d79:	f7 f5                	div    %ebp
  803d7b:	89 c8                	mov    %ecx,%eax
  803d7d:	f7 f5                	div    %ebp
  803d7f:	89 d0                	mov    %edx,%eax
  803d81:	e9 44 ff ff ff       	jmp    803cca <__umoddi3+0x3e>
  803d86:	66 90                	xchg   %ax,%ax
  803d88:	89 c8                	mov    %ecx,%eax
  803d8a:	89 f2                	mov    %esi,%edx
  803d8c:	83 c4 1c             	add    $0x1c,%esp
  803d8f:	5b                   	pop    %ebx
  803d90:	5e                   	pop    %esi
  803d91:	5f                   	pop    %edi
  803d92:	5d                   	pop    %ebp
  803d93:	c3                   	ret    
  803d94:	3b 04 24             	cmp    (%esp),%eax
  803d97:	72 06                	jb     803d9f <__umoddi3+0x113>
  803d99:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d9d:	77 0f                	ja     803dae <__umoddi3+0x122>
  803d9f:	89 f2                	mov    %esi,%edx
  803da1:	29 f9                	sub    %edi,%ecx
  803da3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803da7:	89 14 24             	mov    %edx,(%esp)
  803daa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dae:	8b 44 24 04          	mov    0x4(%esp),%eax
  803db2:	8b 14 24             	mov    (%esp),%edx
  803db5:	83 c4 1c             	add    $0x1c,%esp
  803db8:	5b                   	pop    %ebx
  803db9:	5e                   	pop    %esi
  803dba:	5f                   	pop    %edi
  803dbb:	5d                   	pop    %ebp
  803dbc:	c3                   	ret    
  803dbd:	8d 76 00             	lea    0x0(%esi),%esi
  803dc0:	2b 04 24             	sub    (%esp),%eax
  803dc3:	19 fa                	sbb    %edi,%edx
  803dc5:	89 d1                	mov    %edx,%ecx
  803dc7:	89 c6                	mov    %eax,%esi
  803dc9:	e9 71 ff ff ff       	jmp    803d3f <__umoddi3+0xb3>
  803dce:	66 90                	xchg   %ax,%ax
  803dd0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803dd4:	72 ea                	jb     803dc0 <__umoddi3+0x134>
  803dd6:	89 d9                	mov    %ebx,%ecx
  803dd8:	e9 62 ff ff ff       	jmp    803d3f <__umoddi3+0xb3>
