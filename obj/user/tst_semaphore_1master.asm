
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
  80003e:	e8 f9 15 00 00       	call   80163c <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct semaphore cs1 = create_semaphore("cs1", 1);
  800046:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	6a 01                	push   $0x1
  80004e:	68 80 1c 80 00       	push   $0x801c80
  800053:	50                   	push   %eax
  800054:	e8 40 19 00 00       	call   801999 <create_semaphore>
  800059:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = create_semaphore("depend1", 0);
  80005c:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 00                	push   $0x0
  800064:	68 84 1c 80 00       	push   $0x801c84
  800069:	50                   	push   %eax
  80006a:	e8 2a 19 00 00       	call   801999 <create_semaphore>
  80006f:	83 c4 0c             	add    $0xc,%esp

	int id1, id2, id3;
	id1 = sys_create_env("sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800072:	a1 04 30 80 00       	mov    0x803004,%eax
  800077:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  80007d:	a1 04 30 80 00       	mov    0x803004,%eax
  800082:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800088:	89 c1                	mov    %eax,%ecx
  80008a:	a1 04 30 80 00       	mov    0x803004,%eax
  80008f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800095:	52                   	push   %edx
  800096:	51                   	push   %ecx
  800097:	50                   	push   %eax
  800098:	68 8c 1c 80 00       	push   $0x801c8c
  80009d:	e8 45 15 00 00       	call   8015e7 <sys_create_env>
  8000a2:	83 c4 10             	add    $0x10,%esp
  8000a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	id2 = sys_create_env("sem1Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000a8:	a1 04 30 80 00       	mov    0x803004,%eax
  8000ad:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  8000b3:	a1 04 30 80 00       	mov    0x803004,%eax
  8000b8:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8000be:	89 c1                	mov    %eax,%ecx
  8000c0:	a1 04 30 80 00       	mov    0x803004,%eax
  8000c5:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000cb:	52                   	push   %edx
  8000cc:	51                   	push   %ecx
  8000cd:	50                   	push   %eax
  8000ce:	68 8c 1c 80 00       	push   $0x801c8c
  8000d3:	e8 0f 15 00 00       	call   8015e7 <sys_create_env>
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	89 45 ec             	mov    %eax,-0x14(%ebp)
	id3 = sys_create_env("sem1Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000de:	a1 04 30 80 00       	mov    0x803004,%eax
  8000e3:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  8000e9:	a1 04 30 80 00       	mov    0x803004,%eax
  8000ee:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8000f4:	89 c1                	mov    %eax,%ecx
  8000f6:	a1 04 30 80 00       	mov    0x803004,%eax
  8000fb:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800101:	52                   	push   %edx
  800102:	51                   	push   %ecx
  800103:	50                   	push   %eax
  800104:	68 8c 1c 80 00       	push   $0x801c8c
  800109:	e8 d9 14 00 00       	call   8015e7 <sys_create_env>
  80010e:	83 c4 10             	add    $0x10,%esp
  800111:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(id1);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	ff 75 f0             	pushl  -0x10(%ebp)
  80011a:	e8 e6 14 00 00       	call   801605 <sys_run_env>
  80011f:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	ff 75 ec             	pushl  -0x14(%ebp)
  800128:	e8 d8 14 00 00       	call   801605 <sys_run_env>
  80012d:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	ff 75 e8             	pushl  -0x18(%ebp)
  800136:	e8 ca 14 00 00       	call   801605 <sys_run_env>
  80013b:	83 c4 10             	add    $0x10,%esp

	wait_semaphore(depend1);
  80013e:	83 ec 0c             	sub    $0xc,%esp
  800141:	ff 75 d8             	pushl  -0x28(%ebp)
  800144:	e8 84 18 00 00       	call   8019cd <wait_semaphore>
  800149:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(depend1);
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	ff 75 d8             	pushl  -0x28(%ebp)
  800152:	e8 76 18 00 00       	call   8019cd <wait_semaphore>
  800157:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(depend1);
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	ff 75 d8             	pushl  -0x28(%ebp)
  800160:	e8 68 18 00 00       	call   8019cd <wait_semaphore>
  800165:	83 c4 10             	add    $0x10,%esp

	int sem1val = semaphore_count(cs1);
  800168:	83 ec 0c             	sub    $0xc,%esp
  80016b:	ff 75 dc             	pushl  -0x24(%ebp)
  80016e:	e8 8e 18 00 00       	call   801a01 <semaphore_count>
  800173:	83 c4 10             	add    $0x10,%esp
  800176:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int sem2val = semaphore_count(depend1);
  800179:	83 ec 0c             	sub    $0xc,%esp
  80017c:	ff 75 d8             	pushl  -0x28(%ebp)
  80017f:	e8 7d 18 00 00       	call   801a01 <semaphore_count>
  800184:	83 c4 10             	add    $0x10,%esp
  800187:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (sem2val == 0 && sem1val == 1)
  80018a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80018e:	75 18                	jne    8001a8 <_main+0x170>
  800190:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  800194:	75 12                	jne    8001a8 <_main+0x170>
		cprintf("Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
  800196:	83 ec 0c             	sub    $0xc,%esp
  800199:	68 98 1c 80 00       	push   $0x801c98
  80019e:	e8 2f 04 00 00       	call   8005d2 <cprintf>
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
  8001b5:	68 e0 1c 80 00       	push   $0x801ce0
  8001ba:	6a 1f                	push   $0x1f
  8001bc:	68 4c 1d 80 00       	push   $0x801d4c
  8001c1:	e8 4f 01 00 00       	call   800315 <_panic>

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
  8001ce:	e8 82 14 00 00       	call   801655 <sys_getenvindex>
  8001d3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8001d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001d9:	89 d0                	mov    %edx,%eax
  8001db:	c1 e0 06             	shl    $0x6,%eax
  8001de:	29 d0                	sub    %edx,%eax
  8001e0:	c1 e0 02             	shl    $0x2,%eax
  8001e3:	01 d0                	add    %edx,%eax
  8001e5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001ec:	01 c8                	add    %ecx,%eax
  8001ee:	c1 e0 03             	shl    $0x3,%eax
  8001f1:	01 d0                	add    %edx,%eax
  8001f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001fa:	29 c2                	sub    %eax,%edx
  8001fc:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800203:	89 c2                	mov    %eax,%edx
  800205:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80020b:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800210:	a1 04 30 80 00       	mov    0x803004,%eax
  800215:	8a 40 20             	mov    0x20(%eax),%al
  800218:	84 c0                	test   %al,%al
  80021a:	74 0d                	je     800229 <libmain+0x61>
		binaryname = myEnv->prog_name;
  80021c:	a1 04 30 80 00       	mov    0x803004,%eax
  800221:	83 c0 20             	add    $0x20,%eax
  800224:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800229:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80022d:	7e 0a                	jle    800239 <libmain+0x71>
		binaryname = argv[0];
  80022f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800232:	8b 00                	mov    (%eax),%eax
  800234:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800239:	83 ec 08             	sub    $0x8,%esp
  80023c:	ff 75 0c             	pushl  0xc(%ebp)
  80023f:	ff 75 08             	pushl  0x8(%ebp)
  800242:	e8 f1 fd ff ff       	call   800038 <_main>
  800247:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80024a:	e8 8a 11 00 00       	call   8013d9 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 84 1d 80 00       	push   $0x801d84
  800257:	e8 76 03 00 00       	call   8005d2 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80025f:	a1 04 30 80 00       	mov    0x803004,%eax
  800264:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80026a:	a1 04 30 80 00       	mov    0x803004,%eax
  80026f:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800275:	83 ec 04             	sub    $0x4,%esp
  800278:	52                   	push   %edx
  800279:	50                   	push   %eax
  80027a:	68 ac 1d 80 00       	push   $0x801dac
  80027f:	e8 4e 03 00 00       	call   8005d2 <cprintf>
  800284:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800287:	a1 04 30 80 00       	mov    0x803004,%eax
  80028c:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800292:	a1 04 30 80 00       	mov    0x803004,%eax
  800297:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80029d:	a1 04 30 80 00       	mov    0x803004,%eax
  8002a2:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8002a8:	51                   	push   %ecx
  8002a9:	52                   	push   %edx
  8002aa:	50                   	push   %eax
  8002ab:	68 d4 1d 80 00       	push   $0x801dd4
  8002b0:	e8 1d 03 00 00       	call   8005d2 <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002b8:	a1 04 30 80 00       	mov    0x803004,%eax
  8002bd:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	50                   	push   %eax
  8002c7:	68 2c 1e 80 00       	push   $0x801e2c
  8002cc:	e8 01 03 00 00       	call   8005d2 <cprintf>
  8002d1:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	68 84 1d 80 00       	push   $0x801d84
  8002dc:	e8 f1 02 00 00       	call   8005d2 <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8002e4:	e8 0a 11 00 00       	call   8013f3 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8002e9:	e8 19 00 00 00       	call   800307 <exit>
}
  8002ee:	90                   	nop
  8002ef:	c9                   	leave  
  8002f0:	c3                   	ret    

008002f1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	6a 00                	push   $0x0
  8002fc:	e8 20 13 00 00       	call   801621 <sys_destroy_env>
  800301:	83 c4 10             	add    $0x10,%esp
}
  800304:	90                   	nop
  800305:	c9                   	leave  
  800306:	c3                   	ret    

00800307 <exit>:

void
exit(void)
{
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80030d:	e8 75 13 00 00       	call   801687 <sys_exit_env>
}
  800312:	90                   	nop
  800313:	c9                   	leave  
  800314:	c3                   	ret    

00800315 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80031b:	8d 45 10             	lea    0x10(%ebp),%eax
  80031e:	83 c0 04             	add    $0x4,%eax
  800321:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800324:	a1 24 30 80 00       	mov    0x803024,%eax
  800329:	85 c0                	test   %eax,%eax
  80032b:	74 16                	je     800343 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80032d:	a1 24 30 80 00       	mov    0x803024,%eax
  800332:	83 ec 08             	sub    $0x8,%esp
  800335:	50                   	push   %eax
  800336:	68 40 1e 80 00       	push   $0x801e40
  80033b:	e8 92 02 00 00       	call   8005d2 <cprintf>
  800340:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800343:	a1 00 30 80 00       	mov    0x803000,%eax
  800348:	ff 75 0c             	pushl  0xc(%ebp)
  80034b:	ff 75 08             	pushl  0x8(%ebp)
  80034e:	50                   	push   %eax
  80034f:	68 45 1e 80 00       	push   $0x801e45
  800354:	e8 79 02 00 00       	call   8005d2 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80035c:	8b 45 10             	mov    0x10(%ebp),%eax
  80035f:	83 ec 08             	sub    $0x8,%esp
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	50                   	push   %eax
  800366:	e8 fc 01 00 00       	call   800567 <vcprintf>
  80036b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80036e:	83 ec 08             	sub    $0x8,%esp
  800371:	6a 00                	push   $0x0
  800373:	68 61 1e 80 00       	push   $0x801e61
  800378:	e8 ea 01 00 00       	call   800567 <vcprintf>
  80037d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800380:	e8 82 ff ff ff       	call   800307 <exit>

	// should not return here
	while (1) ;
  800385:	eb fe                	jmp    800385 <_panic+0x70>

00800387 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800387:	55                   	push   %ebp
  800388:	89 e5                	mov    %esp,%ebp
  80038a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80038d:	a1 04 30 80 00       	mov    0x803004,%eax
  800392:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80039b:	39 c2                	cmp    %eax,%edx
  80039d:	74 14                	je     8003b3 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80039f:	83 ec 04             	sub    $0x4,%esp
  8003a2:	68 64 1e 80 00       	push   $0x801e64
  8003a7:	6a 26                	push   $0x26
  8003a9:	68 b0 1e 80 00       	push   $0x801eb0
  8003ae:	e8 62 ff ff ff       	call   800315 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003c1:	e9 c5 00 00 00       	jmp    80048b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d3:	01 d0                	add    %edx,%eax
  8003d5:	8b 00                	mov    (%eax),%eax
  8003d7:	85 c0                	test   %eax,%eax
  8003d9:	75 08                	jne    8003e3 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003db:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003de:	e9 a5 00 00 00       	jmp    800488 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003f1:	eb 69                	jmp    80045c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003f3:	a1 04 30 80 00       	mov    0x803004,%eax
  8003f8:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8003fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800401:	89 d0                	mov    %edx,%eax
  800403:	01 c0                	add    %eax,%eax
  800405:	01 d0                	add    %edx,%eax
  800407:	c1 e0 03             	shl    $0x3,%eax
  80040a:	01 c8                	add    %ecx,%eax
  80040c:	8a 40 04             	mov    0x4(%eax),%al
  80040f:	84 c0                	test   %al,%al
  800411:	75 46                	jne    800459 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800413:	a1 04 30 80 00       	mov    0x803004,%eax
  800418:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80041e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800421:	89 d0                	mov    %edx,%eax
  800423:	01 c0                	add    %eax,%eax
  800425:	01 d0                	add    %edx,%eax
  800427:	c1 e0 03             	shl    $0x3,%eax
  80042a:	01 c8                	add    %ecx,%eax
  80042c:	8b 00                	mov    (%eax),%eax
  80042e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800431:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800434:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800439:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80043b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80043e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800445:	8b 45 08             	mov    0x8(%ebp),%eax
  800448:	01 c8                	add    %ecx,%eax
  80044a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80044c:	39 c2                	cmp    %eax,%edx
  80044e:	75 09                	jne    800459 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800450:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800457:	eb 15                	jmp    80046e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800459:	ff 45 e8             	incl   -0x18(%ebp)
  80045c:	a1 04 30 80 00       	mov    0x803004,%eax
  800461:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800467:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80046a:	39 c2                	cmp    %eax,%edx
  80046c:	77 85                	ja     8003f3 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80046e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800472:	75 14                	jne    800488 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800474:	83 ec 04             	sub    $0x4,%esp
  800477:	68 bc 1e 80 00       	push   $0x801ebc
  80047c:	6a 3a                	push   $0x3a
  80047e:	68 b0 1e 80 00       	push   $0x801eb0
  800483:	e8 8d fe ff ff       	call   800315 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800488:	ff 45 f0             	incl   -0x10(%ebp)
  80048b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80048e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800491:	0f 8c 2f ff ff ff    	jl     8003c6 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800497:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80049e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004a5:	eb 26                	jmp    8004cd <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004a7:	a1 04 30 80 00       	mov    0x803004,%eax
  8004ac:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8004b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004b5:	89 d0                	mov    %edx,%eax
  8004b7:	01 c0                	add    %eax,%eax
  8004b9:	01 d0                	add    %edx,%eax
  8004bb:	c1 e0 03             	shl    $0x3,%eax
  8004be:	01 c8                	add    %ecx,%eax
  8004c0:	8a 40 04             	mov    0x4(%eax),%al
  8004c3:	3c 01                	cmp    $0x1,%al
  8004c5:	75 03                	jne    8004ca <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004c7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ca:	ff 45 e0             	incl   -0x20(%ebp)
  8004cd:	a1 04 30 80 00       	mov    0x803004,%eax
  8004d2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004db:	39 c2                	cmp    %eax,%edx
  8004dd:	77 c8                	ja     8004a7 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004e2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004e5:	74 14                	je     8004fb <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004e7:	83 ec 04             	sub    $0x4,%esp
  8004ea:	68 10 1f 80 00       	push   $0x801f10
  8004ef:	6a 44                	push   $0x44
  8004f1:	68 b0 1e 80 00       	push   $0x801eb0
  8004f6:	e8 1a fe ff ff       	call   800315 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004fb:	90                   	nop
  8004fc:	c9                   	leave  
  8004fd:	c3                   	ret    

008004fe <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004fe:	55                   	push   %ebp
  8004ff:	89 e5                	mov    %esp,%ebp
  800501:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800504:	8b 45 0c             	mov    0xc(%ebp),%eax
  800507:	8b 00                	mov    (%eax),%eax
  800509:	8d 48 01             	lea    0x1(%eax),%ecx
  80050c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80050f:	89 0a                	mov    %ecx,(%edx)
  800511:	8b 55 08             	mov    0x8(%ebp),%edx
  800514:	88 d1                	mov    %dl,%cl
  800516:	8b 55 0c             	mov    0xc(%ebp),%edx
  800519:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80051d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800520:	8b 00                	mov    (%eax),%eax
  800522:	3d ff 00 00 00       	cmp    $0xff,%eax
  800527:	75 2c                	jne    800555 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800529:	a0 08 30 80 00       	mov    0x803008,%al
  80052e:	0f b6 c0             	movzbl %al,%eax
  800531:	8b 55 0c             	mov    0xc(%ebp),%edx
  800534:	8b 12                	mov    (%edx),%edx
  800536:	89 d1                	mov    %edx,%ecx
  800538:	8b 55 0c             	mov    0xc(%ebp),%edx
  80053b:	83 c2 08             	add    $0x8,%edx
  80053e:	83 ec 04             	sub    $0x4,%esp
  800541:	50                   	push   %eax
  800542:	51                   	push   %ecx
  800543:	52                   	push   %edx
  800544:	e8 4e 0e 00 00       	call   801397 <sys_cputs>
  800549:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800555:	8b 45 0c             	mov    0xc(%ebp),%eax
  800558:	8b 40 04             	mov    0x4(%eax),%eax
  80055b:	8d 50 01             	lea    0x1(%eax),%edx
  80055e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800561:	89 50 04             	mov    %edx,0x4(%eax)
}
  800564:	90                   	nop
  800565:	c9                   	leave  
  800566:	c3                   	ret    

00800567 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800567:	55                   	push   %ebp
  800568:	89 e5                	mov    %esp,%ebp
  80056a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800570:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800577:	00 00 00 
	b.cnt = 0;
  80057a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800581:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800584:	ff 75 0c             	pushl  0xc(%ebp)
  800587:	ff 75 08             	pushl  0x8(%ebp)
  80058a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800590:	50                   	push   %eax
  800591:	68 fe 04 80 00       	push   $0x8004fe
  800596:	e8 11 02 00 00       	call   8007ac <vprintfmt>
  80059b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80059e:	a0 08 30 80 00       	mov    0x803008,%al
  8005a3:	0f b6 c0             	movzbl %al,%eax
  8005a6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005ac:	83 ec 04             	sub    $0x4,%esp
  8005af:	50                   	push   %eax
  8005b0:	52                   	push   %edx
  8005b1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005b7:	83 c0 08             	add    $0x8,%eax
  8005ba:	50                   	push   %eax
  8005bb:	e8 d7 0d 00 00       	call   801397 <sys_cputs>
  8005c0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005c3:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8005ca:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005d0:	c9                   	leave  
  8005d1:	c3                   	ret    

008005d2 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005d2:	55                   	push   %ebp
  8005d3:	89 e5                	mov    %esp,%ebp
  8005d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005d8:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8005df:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e8:	83 ec 08             	sub    $0x8,%esp
  8005eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ee:	50                   	push   %eax
  8005ef:	e8 73 ff ff ff       	call   800567 <vcprintf>
  8005f4:	83 c4 10             	add    $0x10,%esp
  8005f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005fd:	c9                   	leave  
  8005fe:	c3                   	ret    

008005ff <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005ff:	55                   	push   %ebp
  800600:	89 e5                	mov    %esp,%ebp
  800602:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800605:	e8 cf 0d 00 00       	call   8013d9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80060a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80060d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800610:	8b 45 08             	mov    0x8(%ebp),%eax
  800613:	83 ec 08             	sub    $0x8,%esp
  800616:	ff 75 f4             	pushl  -0xc(%ebp)
  800619:	50                   	push   %eax
  80061a:	e8 48 ff ff ff       	call   800567 <vcprintf>
  80061f:	83 c4 10             	add    $0x10,%esp
  800622:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800625:	e8 c9 0d 00 00       	call   8013f3 <sys_unlock_cons>
	return cnt;
  80062a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80062d:	c9                   	leave  
  80062e:	c3                   	ret    

0080062f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80062f:	55                   	push   %ebp
  800630:	89 e5                	mov    %esp,%ebp
  800632:	53                   	push   %ebx
  800633:	83 ec 14             	sub    $0x14,%esp
  800636:	8b 45 10             	mov    0x10(%ebp),%eax
  800639:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80063c:	8b 45 14             	mov    0x14(%ebp),%eax
  80063f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800642:	8b 45 18             	mov    0x18(%ebp),%eax
  800645:	ba 00 00 00 00       	mov    $0x0,%edx
  80064a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80064d:	77 55                	ja     8006a4 <printnum+0x75>
  80064f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800652:	72 05                	jb     800659 <printnum+0x2a>
  800654:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800657:	77 4b                	ja     8006a4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800659:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80065c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80065f:	8b 45 18             	mov    0x18(%ebp),%eax
  800662:	ba 00 00 00 00       	mov    $0x0,%edx
  800667:	52                   	push   %edx
  800668:	50                   	push   %eax
  800669:	ff 75 f4             	pushl  -0xc(%ebp)
  80066c:	ff 75 f0             	pushl  -0x10(%ebp)
  80066f:	e8 98 13 00 00       	call   801a0c <__udivdi3>
  800674:	83 c4 10             	add    $0x10,%esp
  800677:	83 ec 04             	sub    $0x4,%esp
  80067a:	ff 75 20             	pushl  0x20(%ebp)
  80067d:	53                   	push   %ebx
  80067e:	ff 75 18             	pushl  0x18(%ebp)
  800681:	52                   	push   %edx
  800682:	50                   	push   %eax
  800683:	ff 75 0c             	pushl  0xc(%ebp)
  800686:	ff 75 08             	pushl  0x8(%ebp)
  800689:	e8 a1 ff ff ff       	call   80062f <printnum>
  80068e:	83 c4 20             	add    $0x20,%esp
  800691:	eb 1a                	jmp    8006ad <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800693:	83 ec 08             	sub    $0x8,%esp
  800696:	ff 75 0c             	pushl  0xc(%ebp)
  800699:	ff 75 20             	pushl  0x20(%ebp)
  80069c:	8b 45 08             	mov    0x8(%ebp),%eax
  80069f:	ff d0                	call   *%eax
  8006a1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006a4:	ff 4d 1c             	decl   0x1c(%ebp)
  8006a7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006ab:	7f e6                	jg     800693 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006ad:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006bb:	53                   	push   %ebx
  8006bc:	51                   	push   %ecx
  8006bd:	52                   	push   %edx
  8006be:	50                   	push   %eax
  8006bf:	e8 58 14 00 00       	call   801b1c <__umoddi3>
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	05 74 21 80 00       	add    $0x802174,%eax
  8006cc:	8a 00                	mov    (%eax),%al
  8006ce:	0f be c0             	movsbl %al,%eax
  8006d1:	83 ec 08             	sub    $0x8,%esp
  8006d4:	ff 75 0c             	pushl  0xc(%ebp)
  8006d7:	50                   	push   %eax
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	ff d0                	call   *%eax
  8006dd:	83 c4 10             	add    $0x10,%esp
}
  8006e0:	90                   	nop
  8006e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006e4:	c9                   	leave  
  8006e5:	c3                   	ret    

008006e6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006e6:	55                   	push   %ebp
  8006e7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ed:	7e 1c                	jle    80070b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	8d 50 08             	lea    0x8(%eax),%edx
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	89 10                	mov    %edx,(%eax)
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	8b 00                	mov    (%eax),%eax
  800701:	83 e8 08             	sub    $0x8,%eax
  800704:	8b 50 04             	mov    0x4(%eax),%edx
  800707:	8b 00                	mov    (%eax),%eax
  800709:	eb 40                	jmp    80074b <getuint+0x65>
	else if (lflag)
  80070b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070f:	74 1e                	je     80072f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	8d 50 04             	lea    0x4(%eax),%edx
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	89 10                	mov    %edx,(%eax)
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	8b 00                	mov    (%eax),%eax
  800723:	83 e8 04             	sub    $0x4,%eax
  800726:	8b 00                	mov    (%eax),%eax
  800728:	ba 00 00 00 00       	mov    $0x0,%edx
  80072d:	eb 1c                	jmp    80074b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	8b 00                	mov    (%eax),%eax
  800734:	8d 50 04             	lea    0x4(%eax),%edx
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	89 10                	mov    %edx,(%eax)
  80073c:	8b 45 08             	mov    0x8(%ebp),%eax
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	83 e8 04             	sub    $0x4,%eax
  800744:	8b 00                	mov    (%eax),%eax
  800746:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80074b:	5d                   	pop    %ebp
  80074c:	c3                   	ret    

0080074d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80074d:	55                   	push   %ebp
  80074e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800750:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800754:	7e 1c                	jle    800772 <getint+0x25>
		return va_arg(*ap, long long);
  800756:	8b 45 08             	mov    0x8(%ebp),%eax
  800759:	8b 00                	mov    (%eax),%eax
  80075b:	8d 50 08             	lea    0x8(%eax),%edx
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	89 10                	mov    %edx,(%eax)
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	8b 00                	mov    (%eax),%eax
  800768:	83 e8 08             	sub    $0x8,%eax
  80076b:	8b 50 04             	mov    0x4(%eax),%edx
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	eb 38                	jmp    8007aa <getint+0x5d>
	else if (lflag)
  800772:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800776:	74 1a                	je     800792 <getint+0x45>
		return va_arg(*ap, long);
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	8b 00                	mov    (%eax),%eax
  80077d:	8d 50 04             	lea    0x4(%eax),%edx
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	89 10                	mov    %edx,(%eax)
  800785:	8b 45 08             	mov    0x8(%ebp),%eax
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	83 e8 04             	sub    $0x4,%eax
  80078d:	8b 00                	mov    (%eax),%eax
  80078f:	99                   	cltd   
  800790:	eb 18                	jmp    8007aa <getint+0x5d>
	else
		return va_arg(*ap, int);
  800792:	8b 45 08             	mov    0x8(%ebp),%eax
  800795:	8b 00                	mov    (%eax),%eax
  800797:	8d 50 04             	lea    0x4(%eax),%edx
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	89 10                	mov    %edx,(%eax)
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	83 e8 04             	sub    $0x4,%eax
  8007a7:	8b 00                	mov    (%eax),%eax
  8007a9:	99                   	cltd   
}
  8007aa:	5d                   	pop    %ebp
  8007ab:	c3                   	ret    

008007ac <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007ac:	55                   	push   %ebp
  8007ad:	89 e5                	mov    %esp,%ebp
  8007af:	56                   	push   %esi
  8007b0:	53                   	push   %ebx
  8007b1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b4:	eb 17                	jmp    8007cd <vprintfmt+0x21>
			if (ch == '\0')
  8007b6:	85 db                	test   %ebx,%ebx
  8007b8:	0f 84 c1 03 00 00    	je     800b7f <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007be:	83 ec 08             	sub    $0x8,%esp
  8007c1:	ff 75 0c             	pushl  0xc(%ebp)
  8007c4:	53                   	push   %ebx
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	ff d0                	call   *%eax
  8007ca:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d0:	8d 50 01             	lea    0x1(%eax),%edx
  8007d3:	89 55 10             	mov    %edx,0x10(%ebp)
  8007d6:	8a 00                	mov    (%eax),%al
  8007d8:	0f b6 d8             	movzbl %al,%ebx
  8007db:	83 fb 25             	cmp    $0x25,%ebx
  8007de:	75 d6                	jne    8007b6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007e0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007e4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007eb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007f2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007f9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800800:	8b 45 10             	mov    0x10(%ebp),%eax
  800803:	8d 50 01             	lea    0x1(%eax),%edx
  800806:	89 55 10             	mov    %edx,0x10(%ebp)
  800809:	8a 00                	mov    (%eax),%al
  80080b:	0f b6 d8             	movzbl %al,%ebx
  80080e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800811:	83 f8 5b             	cmp    $0x5b,%eax
  800814:	0f 87 3d 03 00 00    	ja     800b57 <vprintfmt+0x3ab>
  80081a:	8b 04 85 98 21 80 00 	mov    0x802198(,%eax,4),%eax
  800821:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800823:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800827:	eb d7                	jmp    800800 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800829:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80082d:	eb d1                	jmp    800800 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80082f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800836:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800839:	89 d0                	mov    %edx,%eax
  80083b:	c1 e0 02             	shl    $0x2,%eax
  80083e:	01 d0                	add    %edx,%eax
  800840:	01 c0                	add    %eax,%eax
  800842:	01 d8                	add    %ebx,%eax
  800844:	83 e8 30             	sub    $0x30,%eax
  800847:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80084a:	8b 45 10             	mov    0x10(%ebp),%eax
  80084d:	8a 00                	mov    (%eax),%al
  80084f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800852:	83 fb 2f             	cmp    $0x2f,%ebx
  800855:	7e 3e                	jle    800895 <vprintfmt+0xe9>
  800857:	83 fb 39             	cmp    $0x39,%ebx
  80085a:	7f 39                	jg     800895 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80085c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80085f:	eb d5                	jmp    800836 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	83 c0 04             	add    $0x4,%eax
  800867:	89 45 14             	mov    %eax,0x14(%ebp)
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	83 e8 04             	sub    $0x4,%eax
  800870:	8b 00                	mov    (%eax),%eax
  800872:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800875:	eb 1f                	jmp    800896 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800877:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80087b:	79 83                	jns    800800 <vprintfmt+0x54>
				width = 0;
  80087d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800884:	e9 77 ff ff ff       	jmp    800800 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800889:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800890:	e9 6b ff ff ff       	jmp    800800 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800895:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800896:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80089a:	0f 89 60 ff ff ff    	jns    800800 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008a6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008ad:	e9 4e ff ff ff       	jmp    800800 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008b2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008b5:	e9 46 ff ff ff       	jmp    800800 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	83 c0 04             	add    $0x4,%eax
  8008c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c6:	83 e8 04             	sub    $0x4,%eax
  8008c9:	8b 00                	mov    (%eax),%eax
  8008cb:	83 ec 08             	sub    $0x8,%esp
  8008ce:	ff 75 0c             	pushl  0xc(%ebp)
  8008d1:	50                   	push   %eax
  8008d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d5:	ff d0                	call   *%eax
  8008d7:	83 c4 10             	add    $0x10,%esp
			break;
  8008da:	e9 9b 02 00 00       	jmp    800b7a <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008df:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e2:	83 c0 04             	add    $0x4,%eax
  8008e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008eb:	83 e8 04             	sub    $0x4,%eax
  8008ee:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008f0:	85 db                	test   %ebx,%ebx
  8008f2:	79 02                	jns    8008f6 <vprintfmt+0x14a>
				err = -err;
  8008f4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008f6:	83 fb 64             	cmp    $0x64,%ebx
  8008f9:	7f 0b                	jg     800906 <vprintfmt+0x15a>
  8008fb:	8b 34 9d e0 1f 80 00 	mov    0x801fe0(,%ebx,4),%esi
  800902:	85 f6                	test   %esi,%esi
  800904:	75 19                	jne    80091f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800906:	53                   	push   %ebx
  800907:	68 85 21 80 00       	push   $0x802185
  80090c:	ff 75 0c             	pushl  0xc(%ebp)
  80090f:	ff 75 08             	pushl  0x8(%ebp)
  800912:	e8 70 02 00 00       	call   800b87 <printfmt>
  800917:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80091a:	e9 5b 02 00 00       	jmp    800b7a <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80091f:	56                   	push   %esi
  800920:	68 8e 21 80 00       	push   $0x80218e
  800925:	ff 75 0c             	pushl  0xc(%ebp)
  800928:	ff 75 08             	pushl  0x8(%ebp)
  80092b:	e8 57 02 00 00       	call   800b87 <printfmt>
  800930:	83 c4 10             	add    $0x10,%esp
			break;
  800933:	e9 42 02 00 00       	jmp    800b7a <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	83 c0 04             	add    $0x4,%eax
  80093e:	89 45 14             	mov    %eax,0x14(%ebp)
  800941:	8b 45 14             	mov    0x14(%ebp),%eax
  800944:	83 e8 04             	sub    $0x4,%eax
  800947:	8b 30                	mov    (%eax),%esi
  800949:	85 f6                	test   %esi,%esi
  80094b:	75 05                	jne    800952 <vprintfmt+0x1a6>
				p = "(null)";
  80094d:	be 91 21 80 00       	mov    $0x802191,%esi
			if (width > 0 && padc != '-')
  800952:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800956:	7e 6d                	jle    8009c5 <vprintfmt+0x219>
  800958:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80095c:	74 67                	je     8009c5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80095e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800961:	83 ec 08             	sub    $0x8,%esp
  800964:	50                   	push   %eax
  800965:	56                   	push   %esi
  800966:	e8 1e 03 00 00       	call   800c89 <strnlen>
  80096b:	83 c4 10             	add    $0x10,%esp
  80096e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800971:	eb 16                	jmp    800989 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800973:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800977:	83 ec 08             	sub    $0x8,%esp
  80097a:	ff 75 0c             	pushl  0xc(%ebp)
  80097d:	50                   	push   %eax
  80097e:	8b 45 08             	mov    0x8(%ebp),%eax
  800981:	ff d0                	call   *%eax
  800983:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800986:	ff 4d e4             	decl   -0x1c(%ebp)
  800989:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80098d:	7f e4                	jg     800973 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80098f:	eb 34                	jmp    8009c5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800991:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800995:	74 1c                	je     8009b3 <vprintfmt+0x207>
  800997:	83 fb 1f             	cmp    $0x1f,%ebx
  80099a:	7e 05                	jle    8009a1 <vprintfmt+0x1f5>
  80099c:	83 fb 7e             	cmp    $0x7e,%ebx
  80099f:	7e 12                	jle    8009b3 <vprintfmt+0x207>
					putch('?', putdat);
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	6a 3f                	push   $0x3f
  8009a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ac:	ff d0                	call   *%eax
  8009ae:	83 c4 10             	add    $0x10,%esp
  8009b1:	eb 0f                	jmp    8009c2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009b3:	83 ec 08             	sub    $0x8,%esp
  8009b6:	ff 75 0c             	pushl  0xc(%ebp)
  8009b9:	53                   	push   %ebx
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	ff d0                	call   *%eax
  8009bf:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c2:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c5:	89 f0                	mov    %esi,%eax
  8009c7:	8d 70 01             	lea    0x1(%eax),%esi
  8009ca:	8a 00                	mov    (%eax),%al
  8009cc:	0f be d8             	movsbl %al,%ebx
  8009cf:	85 db                	test   %ebx,%ebx
  8009d1:	74 24                	je     8009f7 <vprintfmt+0x24b>
  8009d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009d7:	78 b8                	js     800991 <vprintfmt+0x1e5>
  8009d9:	ff 4d e0             	decl   -0x20(%ebp)
  8009dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009e0:	79 af                	jns    800991 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009e2:	eb 13                	jmp    8009f7 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009e4:	83 ec 08             	sub    $0x8,%esp
  8009e7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ea:	6a 20                	push   $0x20
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	ff d0                	call   *%eax
  8009f1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f4:	ff 4d e4             	decl   -0x1c(%ebp)
  8009f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009fb:	7f e7                	jg     8009e4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009fd:	e9 78 01 00 00       	jmp    800b7a <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a02:	83 ec 08             	sub    $0x8,%esp
  800a05:	ff 75 e8             	pushl  -0x18(%ebp)
  800a08:	8d 45 14             	lea    0x14(%ebp),%eax
  800a0b:	50                   	push   %eax
  800a0c:	e8 3c fd ff ff       	call   80074d <getint>
  800a11:	83 c4 10             	add    $0x10,%esp
  800a14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a17:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a20:	85 d2                	test   %edx,%edx
  800a22:	79 23                	jns    800a47 <vprintfmt+0x29b>
				putch('-', putdat);
  800a24:	83 ec 08             	sub    $0x8,%esp
  800a27:	ff 75 0c             	pushl  0xc(%ebp)
  800a2a:	6a 2d                	push   $0x2d
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	ff d0                	call   *%eax
  800a31:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a3a:	f7 d8                	neg    %eax
  800a3c:	83 d2 00             	adc    $0x0,%edx
  800a3f:	f7 da                	neg    %edx
  800a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a44:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a47:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a4e:	e9 bc 00 00 00       	jmp    800b0f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a53:	83 ec 08             	sub    $0x8,%esp
  800a56:	ff 75 e8             	pushl  -0x18(%ebp)
  800a59:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5c:	50                   	push   %eax
  800a5d:	e8 84 fc ff ff       	call   8006e6 <getuint>
  800a62:	83 c4 10             	add    $0x10,%esp
  800a65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a68:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a6b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a72:	e9 98 00 00 00       	jmp    800b0f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	6a 58                	push   $0x58
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	6a 58                	push   $0x58
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	ff d0                	call   *%eax
  800a94:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a97:	83 ec 08             	sub    $0x8,%esp
  800a9a:	ff 75 0c             	pushl  0xc(%ebp)
  800a9d:	6a 58                	push   $0x58
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	ff d0                	call   *%eax
  800aa4:	83 c4 10             	add    $0x10,%esp
			break;
  800aa7:	e9 ce 00 00 00       	jmp    800b7a <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	ff 75 0c             	pushl  0xc(%ebp)
  800ab2:	6a 30                	push   $0x30
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	ff d0                	call   *%eax
  800ab9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800abc:	83 ec 08             	sub    $0x8,%esp
  800abf:	ff 75 0c             	pushl  0xc(%ebp)
  800ac2:	6a 78                	push   $0x78
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	ff d0                	call   *%eax
  800ac9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800acc:	8b 45 14             	mov    0x14(%ebp),%eax
  800acf:	83 c0 04             	add    $0x4,%eax
  800ad2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad8:	83 e8 04             	sub    $0x4,%eax
  800adb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800add:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ae7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800aee:	eb 1f                	jmp    800b0f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800af0:	83 ec 08             	sub    $0x8,%esp
  800af3:	ff 75 e8             	pushl  -0x18(%ebp)
  800af6:	8d 45 14             	lea    0x14(%ebp),%eax
  800af9:	50                   	push   %eax
  800afa:	e8 e7 fb ff ff       	call   8006e6 <getuint>
  800aff:	83 c4 10             	add    $0x10,%esp
  800b02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b08:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b0f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b16:	83 ec 04             	sub    $0x4,%esp
  800b19:	52                   	push   %edx
  800b1a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b1d:	50                   	push   %eax
  800b1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b21:	ff 75 f0             	pushl  -0x10(%ebp)
  800b24:	ff 75 0c             	pushl  0xc(%ebp)
  800b27:	ff 75 08             	pushl  0x8(%ebp)
  800b2a:	e8 00 fb ff ff       	call   80062f <printnum>
  800b2f:	83 c4 20             	add    $0x20,%esp
			break;
  800b32:	eb 46                	jmp    800b7a <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b34:	83 ec 08             	sub    $0x8,%esp
  800b37:	ff 75 0c             	pushl  0xc(%ebp)
  800b3a:	53                   	push   %ebx
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	ff d0                	call   *%eax
  800b40:	83 c4 10             	add    $0x10,%esp
			break;
  800b43:	eb 35                	jmp    800b7a <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b45:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800b4c:	eb 2c                	jmp    800b7a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b4e:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800b55:	eb 23                	jmp    800b7a <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b57:	83 ec 08             	sub    $0x8,%esp
  800b5a:	ff 75 0c             	pushl  0xc(%ebp)
  800b5d:	6a 25                	push   $0x25
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	ff d0                	call   *%eax
  800b64:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b67:	ff 4d 10             	decl   0x10(%ebp)
  800b6a:	eb 03                	jmp    800b6f <vprintfmt+0x3c3>
  800b6c:	ff 4d 10             	decl   0x10(%ebp)
  800b6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b72:	48                   	dec    %eax
  800b73:	8a 00                	mov    (%eax),%al
  800b75:	3c 25                	cmp    $0x25,%al
  800b77:	75 f3                	jne    800b6c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b79:	90                   	nop
		}
	}
  800b7a:	e9 35 fc ff ff       	jmp    8007b4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b7f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b80:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b83:	5b                   	pop    %ebx
  800b84:	5e                   	pop    %esi
  800b85:	5d                   	pop    %ebp
  800b86:	c3                   	ret    

00800b87 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b8d:	8d 45 10             	lea    0x10(%ebp),%eax
  800b90:	83 c0 04             	add    $0x4,%eax
  800b93:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b96:	8b 45 10             	mov    0x10(%ebp),%eax
  800b99:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9c:	50                   	push   %eax
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	ff 75 08             	pushl  0x8(%ebp)
  800ba3:	e8 04 fc ff ff       	call   8007ac <vprintfmt>
  800ba8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bab:	90                   	nop
  800bac:	c9                   	leave  
  800bad:	c3                   	ret    

00800bae <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb4:	8b 40 08             	mov    0x8(%eax),%eax
  800bb7:	8d 50 01             	lea    0x1(%eax),%edx
  800bba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbd:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc3:	8b 10                	mov    (%eax),%edx
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	8b 40 04             	mov    0x4(%eax),%eax
  800bcb:	39 c2                	cmp    %eax,%edx
  800bcd:	73 12                	jae    800be1 <sprintputch+0x33>
		*b->buf++ = ch;
  800bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd2:	8b 00                	mov    (%eax),%eax
  800bd4:	8d 48 01             	lea    0x1(%eax),%ecx
  800bd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bda:	89 0a                	mov    %ecx,(%edx)
  800bdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdf:	88 10                	mov    %dl,(%eax)
}
  800be1:	90                   	nop
  800be2:	5d                   	pop    %ebp
  800be3:	c3                   	ret    

00800be4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	01 d0                	add    %edx,%eax
  800bfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c09:	74 06                	je     800c11 <vsnprintf+0x2d>
  800c0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c0f:	7f 07                	jg     800c18 <vsnprintf+0x34>
		return -E_INVAL;
  800c11:	b8 03 00 00 00       	mov    $0x3,%eax
  800c16:	eb 20                	jmp    800c38 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c18:	ff 75 14             	pushl  0x14(%ebp)
  800c1b:	ff 75 10             	pushl  0x10(%ebp)
  800c1e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c21:	50                   	push   %eax
  800c22:	68 ae 0b 80 00       	push   $0x800bae
  800c27:	e8 80 fb ff ff       	call   8007ac <vprintfmt>
  800c2c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c32:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c38:	c9                   	leave  
  800c39:	c3                   	ret    

00800c3a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
  800c3d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c40:	8d 45 10             	lea    0x10(%ebp),%eax
  800c43:	83 c0 04             	add    $0x4,%eax
  800c46:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c49:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c4f:	50                   	push   %eax
  800c50:	ff 75 0c             	pushl  0xc(%ebp)
  800c53:	ff 75 08             	pushl  0x8(%ebp)
  800c56:	e8 89 ff ff ff       	call   800be4 <vsnprintf>
  800c5b:	83 c4 10             	add    $0x10,%esp
  800c5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c64:	c9                   	leave  
  800c65:	c3                   	ret    

00800c66 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
  800c69:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c6c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c73:	eb 06                	jmp    800c7b <strlen+0x15>
		n++;
  800c75:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c78:	ff 45 08             	incl   0x8(%ebp)
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8a 00                	mov    (%eax),%al
  800c80:	84 c0                	test   %al,%al
  800c82:	75 f1                	jne    800c75 <strlen+0xf>
		n++;
	return n;
  800c84:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c87:	c9                   	leave  
  800c88:	c3                   	ret    

00800c89 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c96:	eb 09                	jmp    800ca1 <strnlen+0x18>
		n++;
  800c98:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c9b:	ff 45 08             	incl   0x8(%ebp)
  800c9e:	ff 4d 0c             	decl   0xc(%ebp)
  800ca1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca5:	74 09                	je     800cb0 <strnlen+0x27>
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	8a 00                	mov    (%eax),%al
  800cac:	84 c0                	test   %al,%al
  800cae:	75 e8                	jne    800c98 <strnlen+0xf>
		n++;
	return n;
  800cb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb3:	c9                   	leave  
  800cb4:	c3                   	ret    

00800cb5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cc1:	90                   	nop
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	8d 50 01             	lea    0x1(%eax),%edx
  800cc8:	89 55 08             	mov    %edx,0x8(%ebp)
  800ccb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cce:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd4:	8a 12                	mov    (%edx),%dl
  800cd6:	88 10                	mov    %dl,(%eax)
  800cd8:	8a 00                	mov    (%eax),%al
  800cda:	84 c0                	test   %al,%al
  800cdc:	75 e4                	jne    800cc2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cde:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce1:	c9                   	leave  
  800ce2:	c3                   	ret    

00800ce3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf6:	eb 1f                	jmp    800d17 <strncpy+0x34>
		*dst++ = *src;
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	8d 50 01             	lea    0x1(%eax),%edx
  800cfe:	89 55 08             	mov    %edx,0x8(%ebp)
  800d01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d04:	8a 12                	mov    (%edx),%dl
  800d06:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0b:	8a 00                	mov    (%eax),%al
  800d0d:	84 c0                	test   %al,%al
  800d0f:	74 03                	je     800d14 <strncpy+0x31>
			src++;
  800d11:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d14:	ff 45 fc             	incl   -0x4(%ebp)
  800d17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d1a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d1d:	72 d9                	jb     800cf8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d22:	c9                   	leave  
  800d23:	c3                   	ret    

00800d24 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d34:	74 30                	je     800d66 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d36:	eb 16                	jmp    800d4e <strlcpy+0x2a>
			*dst++ = *src++;
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8d 50 01             	lea    0x1(%eax),%edx
  800d3e:	89 55 08             	mov    %edx,0x8(%ebp)
  800d41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d44:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d47:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d4a:	8a 12                	mov    (%edx),%dl
  800d4c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d4e:	ff 4d 10             	decl   0x10(%ebp)
  800d51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d55:	74 09                	je     800d60 <strlcpy+0x3c>
  800d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5a:	8a 00                	mov    (%eax),%al
  800d5c:	84 c0                	test   %al,%al
  800d5e:	75 d8                	jne    800d38 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d66:	8b 55 08             	mov    0x8(%ebp),%edx
  800d69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6c:	29 c2                	sub    %eax,%edx
  800d6e:	89 d0                	mov    %edx,%eax
}
  800d70:	c9                   	leave  
  800d71:	c3                   	ret    

00800d72 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d75:	eb 06                	jmp    800d7d <strcmp+0xb>
		p++, q++;
  800d77:	ff 45 08             	incl   0x8(%ebp)
  800d7a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	8a 00                	mov    (%eax),%al
  800d82:	84 c0                	test   %al,%al
  800d84:	74 0e                	je     800d94 <strcmp+0x22>
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8a 10                	mov    (%eax),%dl
  800d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8e:	8a 00                	mov    (%eax),%al
  800d90:	38 c2                	cmp    %al,%dl
  800d92:	74 e3                	je     800d77 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	8a 00                	mov    (%eax),%al
  800d99:	0f b6 d0             	movzbl %al,%edx
  800d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9f:	8a 00                	mov    (%eax),%al
  800da1:	0f b6 c0             	movzbl %al,%eax
  800da4:	29 c2                	sub    %eax,%edx
  800da6:	89 d0                	mov    %edx,%eax
}
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dad:	eb 09                	jmp    800db8 <strncmp+0xe>
		n--, p++, q++;
  800daf:	ff 4d 10             	decl   0x10(%ebp)
  800db2:	ff 45 08             	incl   0x8(%ebp)
  800db5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800db8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbc:	74 17                	je     800dd5 <strncmp+0x2b>
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	8a 00                	mov    (%eax),%al
  800dc3:	84 c0                	test   %al,%al
  800dc5:	74 0e                	je     800dd5 <strncmp+0x2b>
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	8a 10                	mov    (%eax),%dl
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	38 c2                	cmp    %al,%dl
  800dd3:	74 da                	je     800daf <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd9:	75 07                	jne    800de2 <strncmp+0x38>
		return 0;
  800ddb:	b8 00 00 00 00       	mov    $0x0,%eax
  800de0:	eb 14                	jmp    800df6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	0f b6 d0             	movzbl %al,%edx
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	0f b6 c0             	movzbl %al,%eax
  800df2:	29 c2                	sub    %eax,%edx
  800df4:	89 d0                	mov    %edx,%eax
}
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    

00800df8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	83 ec 04             	sub    $0x4,%esp
  800dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e01:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e04:	eb 12                	jmp    800e18 <strchr+0x20>
		if (*s == c)
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e0e:	75 05                	jne    800e15 <strchr+0x1d>
			return (char *) s;
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	eb 11                	jmp    800e26 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e15:	ff 45 08             	incl   0x8(%ebp)
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	8a 00                	mov    (%eax),%al
  800e1d:	84 c0                	test   %al,%al
  800e1f:	75 e5                	jne    800e06 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e26:	c9                   	leave  
  800e27:	c3                   	ret    

00800e28 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	83 ec 04             	sub    $0x4,%esp
  800e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e31:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e34:	eb 0d                	jmp    800e43 <strfind+0x1b>
		if (*s == c)
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
  800e39:	8a 00                	mov    (%eax),%al
  800e3b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e3e:	74 0e                	je     800e4e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e40:	ff 45 08             	incl   0x8(%ebp)
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	8a 00                	mov    (%eax),%al
  800e48:	84 c0                	test   %al,%al
  800e4a:	75 ea                	jne    800e36 <strfind+0xe>
  800e4c:	eb 01                	jmp    800e4f <strfind+0x27>
		if (*s == c)
			break;
  800e4e:	90                   	nop
	return (char *) s;
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e52:	c9                   	leave  
  800e53:	c3                   	ret    

00800e54 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e60:	8b 45 10             	mov    0x10(%ebp),%eax
  800e63:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e66:	eb 0e                	jmp    800e76 <memset+0x22>
		*p++ = c;
  800e68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e6b:	8d 50 01             	lea    0x1(%eax),%edx
  800e6e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e74:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e76:	ff 4d f8             	decl   -0x8(%ebp)
  800e79:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e7d:	79 e9                	jns    800e68 <memset+0x14>
		*p++ = c;

	return v;
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e82:	c9                   	leave  
  800e83:	c3                   	ret    

00800e84 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e84:	55                   	push   %ebp
  800e85:	89 e5                	mov    %esp,%ebp
  800e87:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e96:	eb 16                	jmp    800eae <memcpy+0x2a>
		*d++ = *s++;
  800e98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9b:	8d 50 01             	lea    0x1(%eax),%edx
  800e9e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ea1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eaa:	8a 12                	mov    (%edx),%dl
  800eac:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800eae:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb4:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb7:	85 c0                	test   %eax,%eax
  800eb9:	75 dd                	jne    800e98 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebe:	c9                   	leave  
  800ebf:	c3                   	ret    

00800ec0 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ec6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ed8:	73 50                	jae    800f2a <memmove+0x6a>
  800eda:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800edd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee0:	01 d0                	add    %edx,%eax
  800ee2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ee5:	76 43                	jbe    800f2a <memmove+0x6a>
		s += n;
  800ee7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eea:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800eed:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef0:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ef3:	eb 10                	jmp    800f05 <memmove+0x45>
			*--d = *--s;
  800ef5:	ff 4d f8             	decl   -0x8(%ebp)
  800ef8:	ff 4d fc             	decl   -0x4(%ebp)
  800efb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800efe:	8a 10                	mov    (%eax),%dl
  800f00:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f03:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f05:	8b 45 10             	mov    0x10(%ebp),%eax
  800f08:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f0b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f0e:	85 c0                	test   %eax,%eax
  800f10:	75 e3                	jne    800ef5 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f12:	eb 23                	jmp    800f37 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f17:	8d 50 01             	lea    0x1(%eax),%edx
  800f1a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f1d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f20:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f23:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f26:	8a 12                	mov    (%edx),%dl
  800f28:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f30:	89 55 10             	mov    %edx,0x10(%ebp)
  800f33:	85 c0                	test   %eax,%eax
  800f35:	75 dd                	jne    800f14 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3a:	c9                   	leave  
  800f3b:	c3                   	ret    

00800f3c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
  800f3f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f4e:	eb 2a                	jmp    800f7a <memcmp+0x3e>
		if (*s1 != *s2)
  800f50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f53:	8a 10                	mov    (%eax),%dl
  800f55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	38 c2                	cmp    %al,%dl
  800f5c:	74 16                	je     800f74 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	0f b6 d0             	movzbl %al,%edx
  800f66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	0f b6 c0             	movzbl %al,%eax
  800f6e:	29 c2                	sub    %eax,%edx
  800f70:	89 d0                	mov    %edx,%eax
  800f72:	eb 18                	jmp    800f8c <memcmp+0x50>
		s1++, s2++;
  800f74:	ff 45 fc             	incl   -0x4(%ebp)
  800f77:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f80:	89 55 10             	mov    %edx,0x10(%ebp)
  800f83:	85 c0                	test   %eax,%eax
  800f85:	75 c9                	jne    800f50 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f8c:	c9                   	leave  
  800f8d:	c3                   	ret    

00800f8e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f94:	8b 55 08             	mov    0x8(%ebp),%edx
  800f97:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9a:	01 d0                	add    %edx,%eax
  800f9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f9f:	eb 15                	jmp    800fb6 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	0f b6 d0             	movzbl %al,%edx
  800fa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fac:	0f b6 c0             	movzbl %al,%eax
  800faf:	39 c2                	cmp    %eax,%edx
  800fb1:	74 0d                	je     800fc0 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fb3:	ff 45 08             	incl   0x8(%ebp)
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fbc:	72 e3                	jb     800fa1 <memfind+0x13>
  800fbe:	eb 01                	jmp    800fc1 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fc0:	90                   	nop
	return (void *) s;
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc4:	c9                   	leave  
  800fc5:	c3                   	ret    

00800fc6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fc6:	55                   	push   %ebp
  800fc7:	89 e5                	mov    %esp,%ebp
  800fc9:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fcc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fd3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fda:	eb 03                	jmp    800fdf <strtol+0x19>
		s++;
  800fdc:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	8a 00                	mov    (%eax),%al
  800fe4:	3c 20                	cmp    $0x20,%al
  800fe6:	74 f4                	je     800fdc <strtol+0x16>
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3c 09                	cmp    $0x9,%al
  800fef:	74 eb                	je     800fdc <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 2b                	cmp    $0x2b,%al
  800ff8:	75 05                	jne    800fff <strtol+0x39>
		s++;
  800ffa:	ff 45 08             	incl   0x8(%ebp)
  800ffd:	eb 13                	jmp    801012 <strtol+0x4c>
	else if (*s == '-')
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	8a 00                	mov    (%eax),%al
  801004:	3c 2d                	cmp    $0x2d,%al
  801006:	75 0a                	jne    801012 <strtol+0x4c>
		s++, neg = 1;
  801008:	ff 45 08             	incl   0x8(%ebp)
  80100b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801012:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801016:	74 06                	je     80101e <strtol+0x58>
  801018:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80101c:	75 20                	jne    80103e <strtol+0x78>
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3c 30                	cmp    $0x30,%al
  801025:	75 17                	jne    80103e <strtol+0x78>
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	40                   	inc    %eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	3c 78                	cmp    $0x78,%al
  80102f:	75 0d                	jne    80103e <strtol+0x78>
		s += 2, base = 16;
  801031:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801035:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80103c:	eb 28                	jmp    801066 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80103e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801042:	75 15                	jne    801059 <strtol+0x93>
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	8a 00                	mov    (%eax),%al
  801049:	3c 30                	cmp    $0x30,%al
  80104b:	75 0c                	jne    801059 <strtol+0x93>
		s++, base = 8;
  80104d:	ff 45 08             	incl   0x8(%ebp)
  801050:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801057:	eb 0d                	jmp    801066 <strtol+0xa0>
	else if (base == 0)
  801059:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80105d:	75 07                	jne    801066 <strtol+0xa0>
		base = 10;
  80105f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	3c 2f                	cmp    $0x2f,%al
  80106d:	7e 19                	jle    801088 <strtol+0xc2>
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
  801072:	8a 00                	mov    (%eax),%al
  801074:	3c 39                	cmp    $0x39,%al
  801076:	7f 10                	jg     801088 <strtol+0xc2>
			dig = *s - '0';
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	8a 00                	mov    (%eax),%al
  80107d:	0f be c0             	movsbl %al,%eax
  801080:	83 e8 30             	sub    $0x30,%eax
  801083:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801086:	eb 42                	jmp    8010ca <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	8a 00                	mov    (%eax),%al
  80108d:	3c 60                	cmp    $0x60,%al
  80108f:	7e 19                	jle    8010aa <strtol+0xe4>
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	8a 00                	mov    (%eax),%al
  801096:	3c 7a                	cmp    $0x7a,%al
  801098:	7f 10                	jg     8010aa <strtol+0xe4>
			dig = *s - 'a' + 10;
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	8a 00                	mov    (%eax),%al
  80109f:	0f be c0             	movsbl %al,%eax
  8010a2:	83 e8 57             	sub    $0x57,%eax
  8010a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010a8:	eb 20                	jmp    8010ca <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8a 00                	mov    (%eax),%al
  8010af:	3c 40                	cmp    $0x40,%al
  8010b1:	7e 39                	jle    8010ec <strtol+0x126>
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	8a 00                	mov    (%eax),%al
  8010b8:	3c 5a                	cmp    $0x5a,%al
  8010ba:	7f 30                	jg     8010ec <strtol+0x126>
			dig = *s - 'A' + 10;
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bf:	8a 00                	mov    (%eax),%al
  8010c1:	0f be c0             	movsbl %al,%eax
  8010c4:	83 e8 37             	sub    $0x37,%eax
  8010c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010cd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010d0:	7d 19                	jge    8010eb <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010d2:	ff 45 08             	incl   0x8(%ebp)
  8010d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d8:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010dc:	89 c2                	mov    %eax,%edx
  8010de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e1:	01 d0                	add    %edx,%eax
  8010e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010e6:	e9 7b ff ff ff       	jmp    801066 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010eb:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010f0:	74 08                	je     8010fa <strtol+0x134>
		*endptr = (char *) s;
  8010f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f8:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010fe:	74 07                	je     801107 <strtol+0x141>
  801100:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801103:	f7 d8                	neg    %eax
  801105:	eb 03                	jmp    80110a <strtol+0x144>
  801107:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80110a:	c9                   	leave  
  80110b:	c3                   	ret    

0080110c <ltostr>:

void
ltostr(long value, char *str)
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801112:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801119:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801120:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801124:	79 13                	jns    801139 <ltostr+0x2d>
	{
		neg = 1;
  801126:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80112d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801130:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801133:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801136:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801141:	99                   	cltd   
  801142:	f7 f9                	idiv   %ecx
  801144:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801147:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80114a:	8d 50 01             	lea    0x1(%eax),%edx
  80114d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801150:	89 c2                	mov    %eax,%edx
  801152:	8b 45 0c             	mov    0xc(%ebp),%eax
  801155:	01 d0                	add    %edx,%eax
  801157:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80115a:	83 c2 30             	add    $0x30,%edx
  80115d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80115f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801162:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801167:	f7 e9                	imul   %ecx
  801169:	c1 fa 02             	sar    $0x2,%edx
  80116c:	89 c8                	mov    %ecx,%eax
  80116e:	c1 f8 1f             	sar    $0x1f,%eax
  801171:	29 c2                	sub    %eax,%edx
  801173:	89 d0                	mov    %edx,%eax
  801175:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801178:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80117c:	75 bb                	jne    801139 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80117e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801185:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801188:	48                   	dec    %eax
  801189:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80118c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801190:	74 3d                	je     8011cf <ltostr+0xc3>
		start = 1 ;
  801192:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801199:	eb 34                	jmp    8011cf <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80119b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80119e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a1:	01 d0                	add    %edx,%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ae:	01 c2                	add    %eax,%edx
  8011b0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	01 c8                	add    %ecx,%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	01 c2                	add    %eax,%edx
  8011c4:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011c7:	88 02                	mov    %al,(%edx)
		start++ ;
  8011c9:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011cc:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d5:	7c c4                	jl     80119b <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011d7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011dd:	01 d0                	add    %edx,%eax
  8011df:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011e2:	90                   	nop
  8011e3:	c9                   	leave  
  8011e4:	c3                   	ret    

008011e5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011e5:	55                   	push   %ebp
  8011e6:	89 e5                	mov    %esp,%ebp
  8011e8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011eb:	ff 75 08             	pushl  0x8(%ebp)
  8011ee:	e8 73 fa ff ff       	call   800c66 <strlen>
  8011f3:	83 c4 04             	add    $0x4,%esp
  8011f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011f9:	ff 75 0c             	pushl  0xc(%ebp)
  8011fc:	e8 65 fa ff ff       	call   800c66 <strlen>
  801201:	83 c4 04             	add    $0x4,%esp
  801204:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801207:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80120e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801215:	eb 17                	jmp    80122e <strcconcat+0x49>
		final[s] = str1[s] ;
  801217:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80121a:	8b 45 10             	mov    0x10(%ebp),%eax
  80121d:	01 c2                	add    %eax,%edx
  80121f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
  801225:	01 c8                	add    %ecx,%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80122b:	ff 45 fc             	incl   -0x4(%ebp)
  80122e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801231:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801234:	7c e1                	jl     801217 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801236:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80123d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801244:	eb 1f                	jmp    801265 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801246:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801249:	8d 50 01             	lea    0x1(%eax),%edx
  80124c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80124f:	89 c2                	mov    %eax,%edx
  801251:	8b 45 10             	mov    0x10(%ebp),%eax
  801254:	01 c2                	add    %eax,%edx
  801256:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125c:	01 c8                	add    %ecx,%eax
  80125e:	8a 00                	mov    (%eax),%al
  801260:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801262:	ff 45 f8             	incl   -0x8(%ebp)
  801265:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801268:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80126b:	7c d9                	jl     801246 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80126d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801270:	8b 45 10             	mov    0x10(%ebp),%eax
  801273:	01 d0                	add    %edx,%eax
  801275:	c6 00 00             	movb   $0x0,(%eax)
}
  801278:	90                   	nop
  801279:	c9                   	leave  
  80127a:	c3                   	ret    

0080127b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80127e:	8b 45 14             	mov    0x14(%ebp),%eax
  801281:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801287:	8b 45 14             	mov    0x14(%ebp),%eax
  80128a:	8b 00                	mov    (%eax),%eax
  80128c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801293:	8b 45 10             	mov    0x10(%ebp),%eax
  801296:	01 d0                	add    %edx,%eax
  801298:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80129e:	eb 0c                	jmp    8012ac <strsplit+0x31>
			*string++ = 0;
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	8d 50 01             	lea    0x1(%eax),%edx
  8012a6:	89 55 08             	mov    %edx,0x8(%ebp)
  8012a9:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	8a 00                	mov    (%eax),%al
  8012b1:	84 c0                	test   %al,%al
  8012b3:	74 18                	je     8012cd <strsplit+0x52>
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8a 00                	mov    (%eax),%al
  8012ba:	0f be c0             	movsbl %al,%eax
  8012bd:	50                   	push   %eax
  8012be:	ff 75 0c             	pushl  0xc(%ebp)
  8012c1:	e8 32 fb ff ff       	call   800df8 <strchr>
  8012c6:	83 c4 08             	add    $0x8,%esp
  8012c9:	85 c0                	test   %eax,%eax
  8012cb:	75 d3                	jne    8012a0 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	8a 00                	mov    (%eax),%al
  8012d2:	84 c0                	test   %al,%al
  8012d4:	74 5a                	je     801330 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d9:	8b 00                	mov    (%eax),%eax
  8012db:	83 f8 0f             	cmp    $0xf,%eax
  8012de:	75 07                	jne    8012e7 <strsplit+0x6c>
		{
			return 0;
  8012e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e5:	eb 66                	jmp    80134d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ea:	8b 00                	mov    (%eax),%eax
  8012ec:	8d 48 01             	lea    0x1(%eax),%ecx
  8012ef:	8b 55 14             	mov    0x14(%ebp),%edx
  8012f2:	89 0a                	mov    %ecx,(%edx)
  8012f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fe:	01 c2                	add    %eax,%edx
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801305:	eb 03                	jmp    80130a <strsplit+0x8f>
			string++;
  801307:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	8a 00                	mov    (%eax),%al
  80130f:	84 c0                	test   %al,%al
  801311:	74 8b                	je     80129e <strsplit+0x23>
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
  801316:	8a 00                	mov    (%eax),%al
  801318:	0f be c0             	movsbl %al,%eax
  80131b:	50                   	push   %eax
  80131c:	ff 75 0c             	pushl  0xc(%ebp)
  80131f:	e8 d4 fa ff ff       	call   800df8 <strchr>
  801324:	83 c4 08             	add    $0x8,%esp
  801327:	85 c0                	test   %eax,%eax
  801329:	74 dc                	je     801307 <strsplit+0x8c>
			string++;
	}
  80132b:	e9 6e ff ff ff       	jmp    80129e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801330:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801331:	8b 45 14             	mov    0x14(%ebp),%eax
  801334:	8b 00                	mov    (%eax),%eax
  801336:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80133d:	8b 45 10             	mov    0x10(%ebp),%eax
  801340:	01 d0                	add    %edx,%eax
  801342:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801348:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80134d:	c9                   	leave  
  80134e:	c3                   	ret    

0080134f <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
  801352:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801355:	83 ec 04             	sub    $0x4,%esp
  801358:	68 08 23 80 00       	push   $0x802308
  80135d:	68 3f 01 00 00       	push   $0x13f
  801362:	68 2a 23 80 00       	push   $0x80232a
  801367:	e8 a9 ef ff ff       	call   800315 <_panic>

0080136c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	57                   	push   %edi
  801370:	56                   	push   %esi
  801371:	53                   	push   %ebx
  801372:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801375:	8b 45 08             	mov    0x8(%ebp),%eax
  801378:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80137e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801381:	8b 7d 18             	mov    0x18(%ebp),%edi
  801384:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801387:	cd 30                	int    $0x30
  801389:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80138c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80138f:	83 c4 10             	add    $0x10,%esp
  801392:	5b                   	pop    %ebx
  801393:	5e                   	pop    %esi
  801394:	5f                   	pop    %edi
  801395:	5d                   	pop    %ebp
  801396:	c3                   	ret    

00801397 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
  80139a:	83 ec 04             	sub    $0x4,%esp
  80139d:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8013a3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	52                   	push   %edx
  8013af:	ff 75 0c             	pushl  0xc(%ebp)
  8013b2:	50                   	push   %eax
  8013b3:	6a 00                	push   $0x0
  8013b5:	e8 b2 ff ff ff       	call   80136c <syscall>
  8013ba:	83 c4 18             	add    $0x18,%esp
}
  8013bd:	90                   	nop
  8013be:	c9                   	leave  
  8013bf:	c3                   	ret    

008013c0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8013c0:	55                   	push   %ebp
  8013c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 02                	push   $0x2
  8013cf:	e8 98 ff ff ff       	call   80136c <syscall>
  8013d4:	83 c4 18             	add    $0x18,%esp
}
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 03                	push   $0x3
  8013e8:	e8 7f ff ff ff       	call   80136c <syscall>
  8013ed:	83 c4 18             	add    $0x18,%esp
}
  8013f0:	90                   	nop
  8013f1:	c9                   	leave  
  8013f2:	c3                   	ret    

008013f3 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	6a 04                	push   $0x4
  801402:	e8 65 ff ff ff       	call   80136c <syscall>
  801407:	83 c4 18             	add    $0x18,%esp
}
  80140a:	90                   	nop
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801410:	8b 55 0c             	mov    0xc(%ebp),%edx
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 00                	push   $0x0
  80141c:	52                   	push   %edx
  80141d:	50                   	push   %eax
  80141e:	6a 08                	push   $0x8
  801420:	e8 47 ff ff ff       	call   80136c <syscall>
  801425:	83 c4 18             	add    $0x18,%esp
}
  801428:	c9                   	leave  
  801429:	c3                   	ret    

0080142a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
  80142d:	56                   	push   %esi
  80142e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80142f:	8b 75 18             	mov    0x18(%ebp),%esi
  801432:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801435:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801438:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143b:	8b 45 08             	mov    0x8(%ebp),%eax
  80143e:	56                   	push   %esi
  80143f:	53                   	push   %ebx
  801440:	51                   	push   %ecx
  801441:	52                   	push   %edx
  801442:	50                   	push   %eax
  801443:	6a 09                	push   $0x9
  801445:	e8 22 ff ff ff       	call   80136c <syscall>
  80144a:	83 c4 18             	add    $0x18,%esp
}
  80144d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801450:	5b                   	pop    %ebx
  801451:	5e                   	pop    %esi
  801452:	5d                   	pop    %ebp
  801453:	c3                   	ret    

00801454 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801457:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145a:	8b 45 08             	mov    0x8(%ebp),%eax
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	6a 00                	push   $0x0
  801463:	52                   	push   %edx
  801464:	50                   	push   %eax
  801465:	6a 0a                	push   $0xa
  801467:	e8 00 ff ff ff       	call   80136c <syscall>
  80146c:	83 c4 18             	add    $0x18,%esp
}
  80146f:	c9                   	leave  
  801470:	c3                   	ret    

00801471 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801474:	6a 00                	push   $0x0
  801476:	6a 00                	push   $0x0
  801478:	6a 00                	push   $0x0
  80147a:	ff 75 0c             	pushl  0xc(%ebp)
  80147d:	ff 75 08             	pushl  0x8(%ebp)
  801480:	6a 0b                	push   $0xb
  801482:	e8 e5 fe ff ff       	call   80136c <syscall>
  801487:	83 c4 18             	add    $0x18,%esp
}
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80148f:	6a 00                	push   $0x0
  801491:	6a 00                	push   $0x0
  801493:	6a 00                	push   $0x0
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 0c                	push   $0xc
  80149b:	e8 cc fe ff ff       	call   80136c <syscall>
  8014a0:	83 c4 18             	add    $0x18,%esp
}
  8014a3:	c9                   	leave  
  8014a4:	c3                   	ret    

008014a5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 00                	push   $0x0
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 0d                	push   $0xd
  8014b4:	e8 b3 fe ff ff       	call   80136c <syscall>
  8014b9:	83 c4 18             	add    $0x18,%esp
}
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    

008014be <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 0e                	push   $0xe
  8014cd:	e8 9a fe ff ff       	call   80136c <syscall>
  8014d2:	83 c4 18             	add    $0x18,%esp
}
  8014d5:	c9                   	leave  
  8014d6:	c3                   	ret    

008014d7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 0f                	push   $0xf
  8014e6:	e8 81 fe ff ff       	call   80136c <syscall>
  8014eb:	83 c4 18             	add    $0x18,%esp
}
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	ff 75 08             	pushl  0x8(%ebp)
  8014fe:	6a 10                	push   $0x10
  801500:	e8 67 fe ff ff       	call   80136c <syscall>
  801505:	83 c4 18             	add    $0x18,%esp
}
  801508:	c9                   	leave  
  801509:	c3                   	ret    

0080150a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	6a 11                	push   $0x11
  801519:	e8 4e fe ff ff       	call   80136c <syscall>
  80151e:	83 c4 18             	add    $0x18,%esp
}
  801521:	90                   	nop
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <sys_cputc>:

void
sys_cputc(const char c)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	83 ec 04             	sub    $0x4,%esp
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801530:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801534:	6a 00                	push   $0x0
  801536:	6a 00                	push   $0x0
  801538:	6a 00                	push   $0x0
  80153a:	6a 00                	push   $0x0
  80153c:	50                   	push   %eax
  80153d:	6a 01                	push   $0x1
  80153f:	e8 28 fe ff ff       	call   80136c <syscall>
  801544:	83 c4 18             	add    $0x18,%esp
}
  801547:	90                   	nop
  801548:	c9                   	leave  
  801549:	c3                   	ret    

0080154a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80154a:	55                   	push   %ebp
  80154b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 14                	push   $0x14
  801559:	e8 0e fe ff ff       	call   80136c <syscall>
  80155e:	83 c4 18             	add    $0x18,%esp
}
  801561:	90                   	nop
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	83 ec 04             	sub    $0x4,%esp
  80156a:	8b 45 10             	mov    0x10(%ebp),%eax
  80156d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801570:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801573:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	6a 00                	push   $0x0
  80157c:	51                   	push   %ecx
  80157d:	52                   	push   %edx
  80157e:	ff 75 0c             	pushl  0xc(%ebp)
  801581:	50                   	push   %eax
  801582:	6a 15                	push   $0x15
  801584:	e8 e3 fd ff ff       	call   80136c <syscall>
  801589:	83 c4 18             	add    $0x18,%esp
}
  80158c:	c9                   	leave  
  80158d:	c3                   	ret    

0080158e <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801591:	8b 55 0c             	mov    0xc(%ebp),%edx
  801594:	8b 45 08             	mov    0x8(%ebp),%eax
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	52                   	push   %edx
  80159e:	50                   	push   %eax
  80159f:	6a 16                	push   $0x16
  8015a1:	e8 c6 fd ff ff       	call   80136c <syscall>
  8015a6:	83 c4 18             	add    $0x18,%esp
}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8015ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	51                   	push   %ecx
  8015bc:	52                   	push   %edx
  8015bd:	50                   	push   %eax
  8015be:	6a 17                	push   $0x17
  8015c0:	e8 a7 fd ff ff       	call   80136c <syscall>
  8015c5:	83 c4 18             	add    $0x18,%esp
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	52                   	push   %edx
  8015da:	50                   	push   %eax
  8015db:	6a 18                	push   $0x18
  8015dd:	e8 8a fd ff ff       	call   80136c <syscall>
  8015e2:	83 c4 18             	add    $0x18,%esp
}
  8015e5:	c9                   	leave  
  8015e6:	c3                   	ret    

008015e7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	6a 00                	push   $0x0
  8015ef:	ff 75 14             	pushl  0x14(%ebp)
  8015f2:	ff 75 10             	pushl  0x10(%ebp)
  8015f5:	ff 75 0c             	pushl  0xc(%ebp)
  8015f8:	50                   	push   %eax
  8015f9:	6a 19                	push   $0x19
  8015fb:	e8 6c fd ff ff       	call   80136c <syscall>
  801600:	83 c4 18             	add    $0x18,%esp
}
  801603:	c9                   	leave  
  801604:	c3                   	ret    

00801605 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	50                   	push   %eax
  801614:	6a 1a                	push   $0x1a
  801616:	e8 51 fd ff ff       	call   80136c <syscall>
  80161b:	83 c4 18             	add    $0x18,%esp
}
  80161e:	90                   	nop
  80161f:	c9                   	leave  
  801620:	c3                   	ret    

00801621 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801624:	8b 45 08             	mov    0x8(%ebp),%eax
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	50                   	push   %eax
  801630:	6a 1b                	push   $0x1b
  801632:	e8 35 fd ff ff       	call   80136c <syscall>
  801637:	83 c4 18             	add    $0x18,%esp
}
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

0080163c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 05                	push   $0x5
  80164b:	e8 1c fd ff ff       	call   80136c <syscall>
  801650:	83 c4 18             	add    $0x18,%esp
}
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 06                	push   $0x6
  801664:	e8 03 fd ff ff       	call   80136c <syscall>
  801669:	83 c4 18             	add    $0x18,%esp
}
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    

0080166e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 07                	push   $0x7
  80167d:	e8 ea fc ff ff       	call   80136c <syscall>
  801682:	83 c4 18             	add    $0x18,%esp
}
  801685:	c9                   	leave  
  801686:	c3                   	ret    

00801687 <sys_exit_env>:


void sys_exit_env(void)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 1c                	push   $0x1c
  801696:	e8 d1 fc ff ff       	call   80136c <syscall>
  80169b:	83 c4 18             	add    $0x18,%esp
}
  80169e:	90                   	nop
  80169f:	c9                   	leave  
  8016a0:	c3                   	ret    

008016a1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
  8016a4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016a7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016aa:	8d 50 04             	lea    0x4(%eax),%edx
  8016ad:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	52                   	push   %edx
  8016b7:	50                   	push   %eax
  8016b8:	6a 1d                	push   $0x1d
  8016ba:	e8 ad fc ff ff       	call   80136c <syscall>
  8016bf:	83 c4 18             	add    $0x18,%esp
	return result;
  8016c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016cb:	89 01                	mov    %eax,(%ecx)
  8016cd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	c9                   	leave  
  8016d4:	c2 04 00             	ret    $0x4

008016d7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	ff 75 10             	pushl  0x10(%ebp)
  8016e1:	ff 75 0c             	pushl  0xc(%ebp)
  8016e4:	ff 75 08             	pushl  0x8(%ebp)
  8016e7:	6a 13                	push   $0x13
  8016e9:	e8 7e fc ff ff       	call   80136c <syscall>
  8016ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f1:	90                   	nop
}
  8016f2:	c9                   	leave  
  8016f3:	c3                   	ret    

008016f4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 1e                	push   $0x1e
  801703:	e8 64 fc ff ff       	call   80136c <syscall>
  801708:	83 c4 18             	add    $0x18,%esp
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	83 ec 04             	sub    $0x4,%esp
  801713:	8b 45 08             	mov    0x8(%ebp),%eax
  801716:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801719:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	50                   	push   %eax
  801726:	6a 1f                	push   $0x1f
  801728:	e8 3f fc ff ff       	call   80136c <syscall>
  80172d:	83 c4 18             	add    $0x18,%esp
	return ;
  801730:	90                   	nop
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <rsttst>:
void rsttst()
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 21                	push   $0x21
  801742:	e8 25 fc ff ff       	call   80136c <syscall>
  801747:	83 c4 18             	add    $0x18,%esp
	return ;
  80174a:	90                   	nop
}
  80174b:	c9                   	leave  
  80174c:	c3                   	ret    

0080174d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
  801750:	83 ec 04             	sub    $0x4,%esp
  801753:	8b 45 14             	mov    0x14(%ebp),%eax
  801756:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801759:	8b 55 18             	mov    0x18(%ebp),%edx
  80175c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801760:	52                   	push   %edx
  801761:	50                   	push   %eax
  801762:	ff 75 10             	pushl  0x10(%ebp)
  801765:	ff 75 0c             	pushl  0xc(%ebp)
  801768:	ff 75 08             	pushl  0x8(%ebp)
  80176b:	6a 20                	push   $0x20
  80176d:	e8 fa fb ff ff       	call   80136c <syscall>
  801772:	83 c4 18             	add    $0x18,%esp
	return ;
  801775:	90                   	nop
}
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <chktst>:
void chktst(uint32 n)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	ff 75 08             	pushl  0x8(%ebp)
  801786:	6a 22                	push   $0x22
  801788:	e8 df fb ff ff       	call   80136c <syscall>
  80178d:	83 c4 18             	add    $0x18,%esp
	return ;
  801790:	90                   	nop
}
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <inctst>:

void inctst()
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 23                	push   $0x23
  8017a2:	e8 c5 fb ff ff       	call   80136c <syscall>
  8017a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8017aa:	90                   	nop
}
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    

008017ad <gettst>:
uint32 gettst()
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 24                	push   $0x24
  8017bc:	e8 ab fb ff ff       	call   80136c <syscall>
  8017c1:	83 c4 18             	add    $0x18,%esp
}
  8017c4:	c9                   	leave  
  8017c5:	c3                   	ret    

008017c6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
  8017c9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 25                	push   $0x25
  8017d8:	e8 8f fb ff ff       	call   80136c <syscall>
  8017dd:	83 c4 18             	add    $0x18,%esp
  8017e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017e3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017e7:	75 07                	jne    8017f0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8017ee:	eb 05                	jmp    8017f5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 25                	push   $0x25
  801809:	e8 5e fb ff ff       	call   80136c <syscall>
  80180e:	83 c4 18             	add    $0x18,%esp
  801811:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801814:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801818:	75 07                	jne    801821 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80181a:	b8 01 00 00 00       	mov    $0x1,%eax
  80181f:	eb 05                	jmp    801826 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801821:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
  80182b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 25                	push   $0x25
  80183a:	e8 2d fb ff ff       	call   80136c <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
  801842:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801845:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801849:	75 07                	jne    801852 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80184b:	b8 01 00 00 00       	mov    $0x1,%eax
  801850:	eb 05                	jmp    801857 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801852:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 25                	push   $0x25
  80186b:	e8 fc fa ff ff       	call   80136c <syscall>
  801870:	83 c4 18             	add    $0x18,%esp
  801873:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801876:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80187a:	75 07                	jne    801883 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80187c:	b8 01 00 00 00       	mov    $0x1,%eax
  801881:	eb 05                	jmp    801888 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801883:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	ff 75 08             	pushl  0x8(%ebp)
  801898:	6a 26                	push   $0x26
  80189a:	e8 cd fa ff ff       	call   80136c <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a2:	90                   	nop
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
  8018a8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018a9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b5:	6a 00                	push   $0x0
  8018b7:	53                   	push   %ebx
  8018b8:	51                   	push   %ecx
  8018b9:	52                   	push   %edx
  8018ba:	50                   	push   %eax
  8018bb:	6a 27                	push   $0x27
  8018bd:	e8 aa fa ff ff       	call   80136c <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
}
  8018c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	52                   	push   %edx
  8018da:	50                   	push   %eax
  8018db:	6a 28                	push   $0x28
  8018dd:	e8 8a fa ff ff       	call   80136c <syscall>
  8018e2:	83 c4 18             	add    $0x18,%esp
}
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018ea:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	6a 00                	push   $0x0
  8018f5:	51                   	push   %ecx
  8018f6:	ff 75 10             	pushl  0x10(%ebp)
  8018f9:	52                   	push   %edx
  8018fa:	50                   	push   %eax
  8018fb:	6a 29                	push   $0x29
  8018fd:	e8 6a fa ff ff       	call   80136c <syscall>
  801902:	83 c4 18             	add    $0x18,%esp
}
  801905:	c9                   	leave  
  801906:	c3                   	ret    

00801907 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	ff 75 10             	pushl  0x10(%ebp)
  801911:	ff 75 0c             	pushl  0xc(%ebp)
  801914:	ff 75 08             	pushl  0x8(%ebp)
  801917:	6a 12                	push   $0x12
  801919:	e8 4e fa ff ff       	call   80136c <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
	return ;
  801921:	90                   	nop
}
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801927:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	52                   	push   %edx
  801934:	50                   	push   %eax
  801935:	6a 2a                	push   $0x2a
  801937:	e8 30 fa ff ff       	call   80136c <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
	return;
  80193f:	90                   	nop
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801948:	83 ec 04             	sub    $0x4,%esp
  80194b:	68 37 23 80 00       	push   $0x802337
  801950:	68 2e 01 00 00       	push   $0x12e
  801955:	68 4b 23 80 00       	push   $0x80234b
  80195a:	e8 b6 e9 ff ff       	call   800315 <_panic>

0080195f <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801965:	83 ec 04             	sub    $0x4,%esp
  801968:	68 37 23 80 00       	push   $0x802337
  80196d:	68 35 01 00 00       	push   $0x135
  801972:	68 4b 23 80 00       	push   $0x80234b
  801977:	e8 99 e9 ff ff       	call   800315 <_panic>

0080197c <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
  80197f:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801982:	83 ec 04             	sub    $0x4,%esp
  801985:	68 37 23 80 00       	push   $0x802337
  80198a:	68 3b 01 00 00       	push   $0x13b
  80198f:	68 4b 23 80 00       	push   $0x80234b
  801994:	e8 7c e9 ff ff       	call   800315 <_panic>

00801999 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  80199f:	83 ec 04             	sub    $0x4,%esp
  8019a2:	68 5c 23 80 00       	push   $0x80235c
  8019a7:	6a 09                	push   $0x9
  8019a9:	68 84 23 80 00       	push   $0x802384
  8019ae:	e8 62 e9 ff ff       	call   800315 <_panic>

008019b3 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
  8019b6:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  8019b9:	83 ec 04             	sub    $0x4,%esp
  8019bc:	68 94 23 80 00       	push   $0x802394
  8019c1:	6a 10                	push   $0x10
  8019c3:	68 84 23 80 00       	push   $0x802384
  8019c8:	e8 48 e9 ff ff       	call   800315 <_panic>

008019cd <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
  8019d0:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  8019d3:	83 ec 04             	sub    $0x4,%esp
  8019d6:	68 bc 23 80 00       	push   $0x8023bc
  8019db:	6a 18                	push   $0x18
  8019dd:	68 84 23 80 00       	push   $0x802384
  8019e2:	e8 2e e9 ff ff       	call   800315 <_panic>

008019e7 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
  8019ea:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  8019ed:	83 ec 04             	sub    $0x4,%esp
  8019f0:	68 e4 23 80 00       	push   $0x8023e4
  8019f5:	6a 20                	push   $0x20
  8019f7:	68 84 23 80 00       	push   $0x802384
  8019fc:	e8 14 e9 ff ff       	call   800315 <_panic>

00801a01 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801a04:	8b 45 08             	mov    0x8(%ebp),%eax
  801a07:	8b 40 10             	mov    0x10(%eax),%eax
}
  801a0a:	5d                   	pop    %ebp
  801a0b:	c3                   	ret    

00801a0c <__udivdi3>:
  801a0c:	55                   	push   %ebp
  801a0d:	57                   	push   %edi
  801a0e:	56                   	push   %esi
  801a0f:	53                   	push   %ebx
  801a10:	83 ec 1c             	sub    $0x1c,%esp
  801a13:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a17:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a1f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a23:	89 ca                	mov    %ecx,%edx
  801a25:	89 f8                	mov    %edi,%eax
  801a27:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a2b:	85 f6                	test   %esi,%esi
  801a2d:	75 2d                	jne    801a5c <__udivdi3+0x50>
  801a2f:	39 cf                	cmp    %ecx,%edi
  801a31:	77 65                	ja     801a98 <__udivdi3+0x8c>
  801a33:	89 fd                	mov    %edi,%ebp
  801a35:	85 ff                	test   %edi,%edi
  801a37:	75 0b                	jne    801a44 <__udivdi3+0x38>
  801a39:	b8 01 00 00 00       	mov    $0x1,%eax
  801a3e:	31 d2                	xor    %edx,%edx
  801a40:	f7 f7                	div    %edi
  801a42:	89 c5                	mov    %eax,%ebp
  801a44:	31 d2                	xor    %edx,%edx
  801a46:	89 c8                	mov    %ecx,%eax
  801a48:	f7 f5                	div    %ebp
  801a4a:	89 c1                	mov    %eax,%ecx
  801a4c:	89 d8                	mov    %ebx,%eax
  801a4e:	f7 f5                	div    %ebp
  801a50:	89 cf                	mov    %ecx,%edi
  801a52:	89 fa                	mov    %edi,%edx
  801a54:	83 c4 1c             	add    $0x1c,%esp
  801a57:	5b                   	pop    %ebx
  801a58:	5e                   	pop    %esi
  801a59:	5f                   	pop    %edi
  801a5a:	5d                   	pop    %ebp
  801a5b:	c3                   	ret    
  801a5c:	39 ce                	cmp    %ecx,%esi
  801a5e:	77 28                	ja     801a88 <__udivdi3+0x7c>
  801a60:	0f bd fe             	bsr    %esi,%edi
  801a63:	83 f7 1f             	xor    $0x1f,%edi
  801a66:	75 40                	jne    801aa8 <__udivdi3+0x9c>
  801a68:	39 ce                	cmp    %ecx,%esi
  801a6a:	72 0a                	jb     801a76 <__udivdi3+0x6a>
  801a6c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a70:	0f 87 9e 00 00 00    	ja     801b14 <__udivdi3+0x108>
  801a76:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7b:	89 fa                	mov    %edi,%edx
  801a7d:	83 c4 1c             	add    $0x1c,%esp
  801a80:	5b                   	pop    %ebx
  801a81:	5e                   	pop    %esi
  801a82:	5f                   	pop    %edi
  801a83:	5d                   	pop    %ebp
  801a84:	c3                   	ret    
  801a85:	8d 76 00             	lea    0x0(%esi),%esi
  801a88:	31 ff                	xor    %edi,%edi
  801a8a:	31 c0                	xor    %eax,%eax
  801a8c:	89 fa                	mov    %edi,%edx
  801a8e:	83 c4 1c             	add    $0x1c,%esp
  801a91:	5b                   	pop    %ebx
  801a92:	5e                   	pop    %esi
  801a93:	5f                   	pop    %edi
  801a94:	5d                   	pop    %ebp
  801a95:	c3                   	ret    
  801a96:	66 90                	xchg   %ax,%ax
  801a98:	89 d8                	mov    %ebx,%eax
  801a9a:	f7 f7                	div    %edi
  801a9c:	31 ff                	xor    %edi,%edi
  801a9e:	89 fa                	mov    %edi,%edx
  801aa0:	83 c4 1c             	add    $0x1c,%esp
  801aa3:	5b                   	pop    %ebx
  801aa4:	5e                   	pop    %esi
  801aa5:	5f                   	pop    %edi
  801aa6:	5d                   	pop    %ebp
  801aa7:	c3                   	ret    
  801aa8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801aad:	89 eb                	mov    %ebp,%ebx
  801aaf:	29 fb                	sub    %edi,%ebx
  801ab1:	89 f9                	mov    %edi,%ecx
  801ab3:	d3 e6                	shl    %cl,%esi
  801ab5:	89 c5                	mov    %eax,%ebp
  801ab7:	88 d9                	mov    %bl,%cl
  801ab9:	d3 ed                	shr    %cl,%ebp
  801abb:	89 e9                	mov    %ebp,%ecx
  801abd:	09 f1                	or     %esi,%ecx
  801abf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ac3:	89 f9                	mov    %edi,%ecx
  801ac5:	d3 e0                	shl    %cl,%eax
  801ac7:	89 c5                	mov    %eax,%ebp
  801ac9:	89 d6                	mov    %edx,%esi
  801acb:	88 d9                	mov    %bl,%cl
  801acd:	d3 ee                	shr    %cl,%esi
  801acf:	89 f9                	mov    %edi,%ecx
  801ad1:	d3 e2                	shl    %cl,%edx
  801ad3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ad7:	88 d9                	mov    %bl,%cl
  801ad9:	d3 e8                	shr    %cl,%eax
  801adb:	09 c2                	or     %eax,%edx
  801add:	89 d0                	mov    %edx,%eax
  801adf:	89 f2                	mov    %esi,%edx
  801ae1:	f7 74 24 0c          	divl   0xc(%esp)
  801ae5:	89 d6                	mov    %edx,%esi
  801ae7:	89 c3                	mov    %eax,%ebx
  801ae9:	f7 e5                	mul    %ebp
  801aeb:	39 d6                	cmp    %edx,%esi
  801aed:	72 19                	jb     801b08 <__udivdi3+0xfc>
  801aef:	74 0b                	je     801afc <__udivdi3+0xf0>
  801af1:	89 d8                	mov    %ebx,%eax
  801af3:	31 ff                	xor    %edi,%edi
  801af5:	e9 58 ff ff ff       	jmp    801a52 <__udivdi3+0x46>
  801afa:	66 90                	xchg   %ax,%ax
  801afc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b00:	89 f9                	mov    %edi,%ecx
  801b02:	d3 e2                	shl    %cl,%edx
  801b04:	39 c2                	cmp    %eax,%edx
  801b06:	73 e9                	jae    801af1 <__udivdi3+0xe5>
  801b08:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b0b:	31 ff                	xor    %edi,%edi
  801b0d:	e9 40 ff ff ff       	jmp    801a52 <__udivdi3+0x46>
  801b12:	66 90                	xchg   %ax,%ax
  801b14:	31 c0                	xor    %eax,%eax
  801b16:	e9 37 ff ff ff       	jmp    801a52 <__udivdi3+0x46>
  801b1b:	90                   	nop

00801b1c <__umoddi3>:
  801b1c:	55                   	push   %ebp
  801b1d:	57                   	push   %edi
  801b1e:	56                   	push   %esi
  801b1f:	53                   	push   %ebx
  801b20:	83 ec 1c             	sub    $0x1c,%esp
  801b23:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b27:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b2f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b37:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b3b:	89 f3                	mov    %esi,%ebx
  801b3d:	89 fa                	mov    %edi,%edx
  801b3f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b43:	89 34 24             	mov    %esi,(%esp)
  801b46:	85 c0                	test   %eax,%eax
  801b48:	75 1a                	jne    801b64 <__umoddi3+0x48>
  801b4a:	39 f7                	cmp    %esi,%edi
  801b4c:	0f 86 a2 00 00 00    	jbe    801bf4 <__umoddi3+0xd8>
  801b52:	89 c8                	mov    %ecx,%eax
  801b54:	89 f2                	mov    %esi,%edx
  801b56:	f7 f7                	div    %edi
  801b58:	89 d0                	mov    %edx,%eax
  801b5a:	31 d2                	xor    %edx,%edx
  801b5c:	83 c4 1c             	add    $0x1c,%esp
  801b5f:	5b                   	pop    %ebx
  801b60:	5e                   	pop    %esi
  801b61:	5f                   	pop    %edi
  801b62:	5d                   	pop    %ebp
  801b63:	c3                   	ret    
  801b64:	39 f0                	cmp    %esi,%eax
  801b66:	0f 87 ac 00 00 00    	ja     801c18 <__umoddi3+0xfc>
  801b6c:	0f bd e8             	bsr    %eax,%ebp
  801b6f:	83 f5 1f             	xor    $0x1f,%ebp
  801b72:	0f 84 ac 00 00 00    	je     801c24 <__umoddi3+0x108>
  801b78:	bf 20 00 00 00       	mov    $0x20,%edi
  801b7d:	29 ef                	sub    %ebp,%edi
  801b7f:	89 fe                	mov    %edi,%esi
  801b81:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b85:	89 e9                	mov    %ebp,%ecx
  801b87:	d3 e0                	shl    %cl,%eax
  801b89:	89 d7                	mov    %edx,%edi
  801b8b:	89 f1                	mov    %esi,%ecx
  801b8d:	d3 ef                	shr    %cl,%edi
  801b8f:	09 c7                	or     %eax,%edi
  801b91:	89 e9                	mov    %ebp,%ecx
  801b93:	d3 e2                	shl    %cl,%edx
  801b95:	89 14 24             	mov    %edx,(%esp)
  801b98:	89 d8                	mov    %ebx,%eax
  801b9a:	d3 e0                	shl    %cl,%eax
  801b9c:	89 c2                	mov    %eax,%edx
  801b9e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ba2:	d3 e0                	shl    %cl,%eax
  801ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bac:	89 f1                	mov    %esi,%ecx
  801bae:	d3 e8                	shr    %cl,%eax
  801bb0:	09 d0                	or     %edx,%eax
  801bb2:	d3 eb                	shr    %cl,%ebx
  801bb4:	89 da                	mov    %ebx,%edx
  801bb6:	f7 f7                	div    %edi
  801bb8:	89 d3                	mov    %edx,%ebx
  801bba:	f7 24 24             	mull   (%esp)
  801bbd:	89 c6                	mov    %eax,%esi
  801bbf:	89 d1                	mov    %edx,%ecx
  801bc1:	39 d3                	cmp    %edx,%ebx
  801bc3:	0f 82 87 00 00 00    	jb     801c50 <__umoddi3+0x134>
  801bc9:	0f 84 91 00 00 00    	je     801c60 <__umoddi3+0x144>
  801bcf:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bd3:	29 f2                	sub    %esi,%edx
  801bd5:	19 cb                	sbb    %ecx,%ebx
  801bd7:	89 d8                	mov    %ebx,%eax
  801bd9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bdd:	d3 e0                	shl    %cl,%eax
  801bdf:	89 e9                	mov    %ebp,%ecx
  801be1:	d3 ea                	shr    %cl,%edx
  801be3:	09 d0                	or     %edx,%eax
  801be5:	89 e9                	mov    %ebp,%ecx
  801be7:	d3 eb                	shr    %cl,%ebx
  801be9:	89 da                	mov    %ebx,%edx
  801beb:	83 c4 1c             	add    $0x1c,%esp
  801bee:	5b                   	pop    %ebx
  801bef:	5e                   	pop    %esi
  801bf0:	5f                   	pop    %edi
  801bf1:	5d                   	pop    %ebp
  801bf2:	c3                   	ret    
  801bf3:	90                   	nop
  801bf4:	89 fd                	mov    %edi,%ebp
  801bf6:	85 ff                	test   %edi,%edi
  801bf8:	75 0b                	jne    801c05 <__umoddi3+0xe9>
  801bfa:	b8 01 00 00 00       	mov    $0x1,%eax
  801bff:	31 d2                	xor    %edx,%edx
  801c01:	f7 f7                	div    %edi
  801c03:	89 c5                	mov    %eax,%ebp
  801c05:	89 f0                	mov    %esi,%eax
  801c07:	31 d2                	xor    %edx,%edx
  801c09:	f7 f5                	div    %ebp
  801c0b:	89 c8                	mov    %ecx,%eax
  801c0d:	f7 f5                	div    %ebp
  801c0f:	89 d0                	mov    %edx,%eax
  801c11:	e9 44 ff ff ff       	jmp    801b5a <__umoddi3+0x3e>
  801c16:	66 90                	xchg   %ax,%ax
  801c18:	89 c8                	mov    %ecx,%eax
  801c1a:	89 f2                	mov    %esi,%edx
  801c1c:	83 c4 1c             	add    $0x1c,%esp
  801c1f:	5b                   	pop    %ebx
  801c20:	5e                   	pop    %esi
  801c21:	5f                   	pop    %edi
  801c22:	5d                   	pop    %ebp
  801c23:	c3                   	ret    
  801c24:	3b 04 24             	cmp    (%esp),%eax
  801c27:	72 06                	jb     801c2f <__umoddi3+0x113>
  801c29:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c2d:	77 0f                	ja     801c3e <__umoddi3+0x122>
  801c2f:	89 f2                	mov    %esi,%edx
  801c31:	29 f9                	sub    %edi,%ecx
  801c33:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c37:	89 14 24             	mov    %edx,(%esp)
  801c3a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c3e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c42:	8b 14 24             	mov    (%esp),%edx
  801c45:	83 c4 1c             	add    $0x1c,%esp
  801c48:	5b                   	pop    %ebx
  801c49:	5e                   	pop    %esi
  801c4a:	5f                   	pop    %edi
  801c4b:	5d                   	pop    %ebp
  801c4c:	c3                   	ret    
  801c4d:	8d 76 00             	lea    0x0(%esi),%esi
  801c50:	2b 04 24             	sub    (%esp),%eax
  801c53:	19 fa                	sbb    %edi,%edx
  801c55:	89 d1                	mov    %edx,%ecx
  801c57:	89 c6                	mov    %eax,%esi
  801c59:	e9 71 ff ff ff       	jmp    801bcf <__umoddi3+0xb3>
  801c5e:	66 90                	xchg   %ax,%ax
  801c60:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c64:	72 ea                	jb     801c50 <__umoddi3+0x134>
  801c66:	89 d9                	mov    %ebx,%ecx
  801c68:	e9 62 ff ff ff       	jmp    801bcf <__umoddi3+0xb3>
