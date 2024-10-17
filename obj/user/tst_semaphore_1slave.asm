
obj/user/tst_semaphore_1slave:     file format elf32-i386


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
  800031:	e8 fa 00 00 00       	call   800130 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program: enter critical section, print it's ID, exit and signal the master program
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 93 15 00 00       	call   8015d6 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int id = sys_getenvindex();
  800046:	e8 72 15 00 00       	call   8015bd <sys_getenvindex>
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	struct semaphore cs1 = get_semaphore(parentenvID, "cs1");
  80004e:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	68 a0 1c 80 00       	push   $0x801ca0
  800059:	ff 75 f4             	pushl  -0xc(%ebp)
  80005c:	50                   	push   %eax
  80005d:	e8 b9 18 00 00       	call   80191b <get_semaphore>
  800062:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = get_semaphore(parentenvID, "depend1");
  800065:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	68 a4 1c 80 00       	push   $0x801ca4
  800070:	ff 75 f4             	pushl  -0xc(%ebp)
  800073:	50                   	push   %eax
  800074:	e8 a2 18 00 00       	call   80191b <get_semaphore>
  800079:	83 c4 0c             	add    $0xc,%esp

	cprintf("%d: before the critical section\n", id);
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	ff 75 f0             	pushl  -0x10(%ebp)
  800082:	68 ac 1c 80 00       	push   $0x801cac
  800087:	e8 ae 04 00 00       	call   80053a <cprintf>
  80008c:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(cs1);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	ff 75 e8             	pushl  -0x18(%ebp)
  800095:	e8 9b 18 00 00       	call   801935 <wait_semaphore>
  80009a:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("%d: inside the critical section\n", id) ;
  80009d:	83 ec 08             	sub    $0x8,%esp
  8000a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000a3:	68 d0 1c 80 00       	push   $0x801cd0
  8000a8:	e8 8d 04 00 00       	call   80053a <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp
		cprintf("my ID is %d\n", id);
  8000b0:	83 ec 08             	sub    $0x8,%esp
  8000b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b6:	68 f1 1c 80 00       	push   $0x801cf1
  8000bb:	e8 7a 04 00 00       	call   80053a <cprintf>
  8000c0:	83 c4 10             	add    $0x10,%esp
		int sem1val = semaphore_count(cs1);
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000c9:	e8 9b 18 00 00       	call   801969 <semaphore_count>
  8000ce:	83 c4 10             	add    $0x10,%esp
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (sem1val > 0)
  8000d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8000d8:	7e 14                	jle    8000ee <_main+0xb6>
			panic("Error: more than 1 process inside the CS... please review your semaphore code again...");
  8000da:	83 ec 04             	sub    $0x4,%esp
  8000dd:	68 00 1d 80 00       	push   $0x801d00
  8000e2:	6a 15                	push   $0x15
  8000e4:	68 57 1d 80 00       	push   $0x801d57
  8000e9:	e8 8f 01 00 00       	call   80027d <_panic>
		env_sleep(1000) ;
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	68 e8 03 00 00       	push   $0x3e8
  8000f6:	e8 79 18 00 00       	call   801974 <env_sleep>
  8000fb:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cs1);
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	ff 75 e8             	pushl  -0x18(%ebp)
  800104:	e8 46 18 00 00       	call   80194f <signal_semaphore>
  800109:	83 c4 10             	add    $0x10,%esp
	cprintf("%d: after the critical section\n", id);
  80010c:	83 ec 08             	sub    $0x8,%esp
  80010f:	ff 75 f0             	pushl  -0x10(%ebp)
  800112:	68 74 1d 80 00       	push   $0x801d74
  800117:	e8 1e 04 00 00       	call   80053a <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp

	signal_semaphore(depend1);
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	ff 75 e4             	pushl  -0x1c(%ebp)
  800125:	e8 25 18 00 00       	call   80194f <signal_semaphore>
  80012a:	83 c4 10             	add    $0x10,%esp
	return;
  80012d:	90                   	nop
}
  80012e:	c9                   	leave  
  80012f:	c3                   	ret    

00800130 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800130:	55                   	push   %ebp
  800131:	89 e5                	mov    %esp,%ebp
  800133:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800136:	e8 82 14 00 00       	call   8015bd <sys_getenvindex>
  80013b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80013e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800141:	89 d0                	mov    %edx,%eax
  800143:	c1 e0 06             	shl    $0x6,%eax
  800146:	29 d0                	sub    %edx,%eax
  800148:	c1 e0 02             	shl    $0x2,%eax
  80014b:	01 d0                	add    %edx,%eax
  80014d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800154:	01 c8                	add    %ecx,%eax
  800156:	c1 e0 03             	shl    $0x3,%eax
  800159:	01 d0                	add    %edx,%eax
  80015b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800162:	29 c2                	sub    %eax,%edx
  800164:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80016b:	89 c2                	mov    %eax,%edx
  80016d:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800173:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800178:	a1 04 30 80 00       	mov    0x803004,%eax
  80017d:	8a 40 20             	mov    0x20(%eax),%al
  800180:	84 c0                	test   %al,%al
  800182:	74 0d                	je     800191 <libmain+0x61>
		binaryname = myEnv->prog_name;
  800184:	a1 04 30 80 00       	mov    0x803004,%eax
  800189:	83 c0 20             	add    $0x20,%eax
  80018c:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800191:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800195:	7e 0a                	jle    8001a1 <libmain+0x71>
		binaryname = argv[0];
  800197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019a:	8b 00                	mov    (%eax),%eax
  80019c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 0c             	pushl  0xc(%ebp)
  8001a7:	ff 75 08             	pushl  0x8(%ebp)
  8001aa:	e8 89 fe ff ff       	call   800038 <_main>
  8001af:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8001b2:	e8 8a 11 00 00       	call   801341 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	68 ac 1d 80 00       	push   $0x801dac
  8001bf:	e8 76 03 00 00       	call   80053a <cprintf>
  8001c4:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c7:	a1 04 30 80 00       	mov    0x803004,%eax
  8001cc:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8001d2:	a1 04 30 80 00       	mov    0x803004,%eax
  8001d7:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8001dd:	83 ec 04             	sub    $0x4,%esp
  8001e0:	52                   	push   %edx
  8001e1:	50                   	push   %eax
  8001e2:	68 d4 1d 80 00       	push   $0x801dd4
  8001e7:	e8 4e 03 00 00       	call   80053a <cprintf>
  8001ec:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001ef:	a1 04 30 80 00       	mov    0x803004,%eax
  8001f4:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8001fa:	a1 04 30 80 00       	mov    0x803004,%eax
  8001ff:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800205:	a1 04 30 80 00       	mov    0x803004,%eax
  80020a:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800210:	51                   	push   %ecx
  800211:	52                   	push   %edx
  800212:	50                   	push   %eax
  800213:	68 fc 1d 80 00       	push   $0x801dfc
  800218:	e8 1d 03 00 00       	call   80053a <cprintf>
  80021d:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800220:	a1 04 30 80 00       	mov    0x803004,%eax
  800225:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80022b:	83 ec 08             	sub    $0x8,%esp
  80022e:	50                   	push   %eax
  80022f:	68 54 1e 80 00       	push   $0x801e54
  800234:	e8 01 03 00 00       	call   80053a <cprintf>
  800239:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80023c:	83 ec 0c             	sub    $0xc,%esp
  80023f:	68 ac 1d 80 00       	push   $0x801dac
  800244:	e8 f1 02 00 00       	call   80053a <cprintf>
  800249:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80024c:	e8 0a 11 00 00       	call   80135b <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800251:	e8 19 00 00 00       	call   80026f <exit>
}
  800256:	90                   	nop
  800257:	c9                   	leave  
  800258:	c3                   	ret    

00800259 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80025f:	83 ec 0c             	sub    $0xc,%esp
  800262:	6a 00                	push   $0x0
  800264:	e8 20 13 00 00       	call   801589 <sys_destroy_env>
  800269:	83 c4 10             	add    $0x10,%esp
}
  80026c:	90                   	nop
  80026d:	c9                   	leave  
  80026e:	c3                   	ret    

0080026f <exit>:

void
exit(void)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800275:	e8 75 13 00 00       	call   8015ef <sys_exit_env>
}
  80027a:	90                   	nop
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800283:	8d 45 10             	lea    0x10(%ebp),%eax
  800286:	83 c0 04             	add    $0x4,%eax
  800289:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80028c:	a1 24 30 80 00       	mov    0x803024,%eax
  800291:	85 c0                	test   %eax,%eax
  800293:	74 16                	je     8002ab <_panic+0x2e>
		cprintf("%s: ", argv0);
  800295:	a1 24 30 80 00       	mov    0x803024,%eax
  80029a:	83 ec 08             	sub    $0x8,%esp
  80029d:	50                   	push   %eax
  80029e:	68 68 1e 80 00       	push   $0x801e68
  8002a3:	e8 92 02 00 00       	call   80053a <cprintf>
  8002a8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ab:	a1 00 30 80 00       	mov    0x803000,%eax
  8002b0:	ff 75 0c             	pushl  0xc(%ebp)
  8002b3:	ff 75 08             	pushl  0x8(%ebp)
  8002b6:	50                   	push   %eax
  8002b7:	68 6d 1e 80 00       	push   $0x801e6d
  8002bc:	e8 79 02 00 00       	call   80053a <cprintf>
  8002c1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c7:	83 ec 08             	sub    $0x8,%esp
  8002ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8002cd:	50                   	push   %eax
  8002ce:	e8 fc 01 00 00       	call   8004cf <vcprintf>
  8002d3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002d6:	83 ec 08             	sub    $0x8,%esp
  8002d9:	6a 00                	push   $0x0
  8002db:	68 89 1e 80 00       	push   $0x801e89
  8002e0:	e8 ea 01 00 00       	call   8004cf <vcprintf>
  8002e5:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002e8:	e8 82 ff ff ff       	call   80026f <exit>

	// should not return here
	while (1) ;
  8002ed:	eb fe                	jmp    8002ed <_panic+0x70>

008002ef <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002f5:	a1 04 30 80 00       	mov    0x803004,%eax
  8002fa:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800300:	8b 45 0c             	mov    0xc(%ebp),%eax
  800303:	39 c2                	cmp    %eax,%edx
  800305:	74 14                	je     80031b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800307:	83 ec 04             	sub    $0x4,%esp
  80030a:	68 8c 1e 80 00       	push   $0x801e8c
  80030f:	6a 26                	push   $0x26
  800311:	68 d8 1e 80 00       	push   $0x801ed8
  800316:	e8 62 ff ff ff       	call   80027d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80031b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800322:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800329:	e9 c5 00 00 00       	jmp    8003f3 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80032e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800331:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800338:	8b 45 08             	mov    0x8(%ebp),%eax
  80033b:	01 d0                	add    %edx,%eax
  80033d:	8b 00                	mov    (%eax),%eax
  80033f:	85 c0                	test   %eax,%eax
  800341:	75 08                	jne    80034b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800343:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800346:	e9 a5 00 00 00       	jmp    8003f0 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80034b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800352:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800359:	eb 69                	jmp    8003c4 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80035b:	a1 04 30 80 00       	mov    0x803004,%eax
  800360:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800366:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800369:	89 d0                	mov    %edx,%eax
  80036b:	01 c0                	add    %eax,%eax
  80036d:	01 d0                	add    %edx,%eax
  80036f:	c1 e0 03             	shl    $0x3,%eax
  800372:	01 c8                	add    %ecx,%eax
  800374:	8a 40 04             	mov    0x4(%eax),%al
  800377:	84 c0                	test   %al,%al
  800379:	75 46                	jne    8003c1 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80037b:	a1 04 30 80 00       	mov    0x803004,%eax
  800380:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800386:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800389:	89 d0                	mov    %edx,%eax
  80038b:	01 c0                	add    %eax,%eax
  80038d:	01 d0                	add    %edx,%eax
  80038f:	c1 e0 03             	shl    $0x3,%eax
  800392:	01 c8                	add    %ecx,%eax
  800394:	8b 00                	mov    (%eax),%eax
  800396:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800399:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b0:	01 c8                	add    %ecx,%eax
  8003b2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b4:	39 c2                	cmp    %eax,%edx
  8003b6:	75 09                	jne    8003c1 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003b8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003bf:	eb 15                	jmp    8003d6 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c1:	ff 45 e8             	incl   -0x18(%ebp)
  8003c4:	a1 04 30 80 00       	mov    0x803004,%eax
  8003c9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003d2:	39 c2                	cmp    %eax,%edx
  8003d4:	77 85                	ja     80035b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003da:	75 14                	jne    8003f0 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003dc:	83 ec 04             	sub    $0x4,%esp
  8003df:	68 e4 1e 80 00       	push   $0x801ee4
  8003e4:	6a 3a                	push   $0x3a
  8003e6:	68 d8 1e 80 00       	push   $0x801ed8
  8003eb:	e8 8d fe ff ff       	call   80027d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003f0:	ff 45 f0             	incl   -0x10(%ebp)
  8003f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f9:	0f 8c 2f ff ff ff    	jl     80032e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003ff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800406:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80040d:	eb 26                	jmp    800435 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80040f:	a1 04 30 80 00       	mov    0x803004,%eax
  800414:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80041a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80041d:	89 d0                	mov    %edx,%eax
  80041f:	01 c0                	add    %eax,%eax
  800421:	01 d0                	add    %edx,%eax
  800423:	c1 e0 03             	shl    $0x3,%eax
  800426:	01 c8                	add    %ecx,%eax
  800428:	8a 40 04             	mov    0x4(%eax),%al
  80042b:	3c 01                	cmp    $0x1,%al
  80042d:	75 03                	jne    800432 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80042f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800432:	ff 45 e0             	incl   -0x20(%ebp)
  800435:	a1 04 30 80 00       	mov    0x803004,%eax
  80043a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800440:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800443:	39 c2                	cmp    %eax,%edx
  800445:	77 c8                	ja     80040f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80044a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80044d:	74 14                	je     800463 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80044f:	83 ec 04             	sub    $0x4,%esp
  800452:	68 38 1f 80 00       	push   $0x801f38
  800457:	6a 44                	push   $0x44
  800459:	68 d8 1e 80 00       	push   $0x801ed8
  80045e:	e8 1a fe ff ff       	call   80027d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800463:	90                   	nop
  800464:	c9                   	leave  
  800465:	c3                   	ret    

00800466 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800466:	55                   	push   %ebp
  800467:	89 e5                	mov    %esp,%ebp
  800469:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80046c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046f:	8b 00                	mov    (%eax),%eax
  800471:	8d 48 01             	lea    0x1(%eax),%ecx
  800474:	8b 55 0c             	mov    0xc(%ebp),%edx
  800477:	89 0a                	mov    %ecx,(%edx)
  800479:	8b 55 08             	mov    0x8(%ebp),%edx
  80047c:	88 d1                	mov    %dl,%cl
  80047e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800481:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800485:	8b 45 0c             	mov    0xc(%ebp),%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80048f:	75 2c                	jne    8004bd <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800491:	a0 08 30 80 00       	mov    0x803008,%al
  800496:	0f b6 c0             	movzbl %al,%eax
  800499:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049c:	8b 12                	mov    (%edx),%edx
  80049e:	89 d1                	mov    %edx,%ecx
  8004a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a3:	83 c2 08             	add    $0x8,%edx
  8004a6:	83 ec 04             	sub    $0x4,%esp
  8004a9:	50                   	push   %eax
  8004aa:	51                   	push   %ecx
  8004ab:	52                   	push   %edx
  8004ac:	e8 4e 0e 00 00       	call   8012ff <sys_cputs>
  8004b1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c0:	8b 40 04             	mov    0x4(%eax),%eax
  8004c3:	8d 50 01             	lea    0x1(%eax),%edx
  8004c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004cc:	90                   	nop
  8004cd:	c9                   	leave  
  8004ce:	c3                   	ret    

008004cf <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004cf:	55                   	push   %ebp
  8004d0:	89 e5                	mov    %esp,%ebp
  8004d2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004df:	00 00 00 
	b.cnt = 0;
  8004e2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e9:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004ec:	ff 75 0c             	pushl  0xc(%ebp)
  8004ef:	ff 75 08             	pushl  0x8(%ebp)
  8004f2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f8:	50                   	push   %eax
  8004f9:	68 66 04 80 00       	push   $0x800466
  8004fe:	e8 11 02 00 00       	call   800714 <vprintfmt>
  800503:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800506:	a0 08 30 80 00       	mov    0x803008,%al
  80050b:	0f b6 c0             	movzbl %al,%eax
  80050e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800514:	83 ec 04             	sub    $0x4,%esp
  800517:	50                   	push   %eax
  800518:	52                   	push   %edx
  800519:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80051f:	83 c0 08             	add    $0x8,%eax
  800522:	50                   	push   %eax
  800523:	e8 d7 0d 00 00       	call   8012ff <sys_cputs>
  800528:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80052b:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800532:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800538:	c9                   	leave  
  800539:	c3                   	ret    

0080053a <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80053a:	55                   	push   %ebp
  80053b:	89 e5                	mov    %esp,%ebp
  80053d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800540:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800547:	8d 45 0c             	lea    0xc(%ebp),%eax
  80054a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80054d:	8b 45 08             	mov    0x8(%ebp),%eax
  800550:	83 ec 08             	sub    $0x8,%esp
  800553:	ff 75 f4             	pushl  -0xc(%ebp)
  800556:	50                   	push   %eax
  800557:	e8 73 ff ff ff       	call   8004cf <vcprintf>
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800562:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800565:	c9                   	leave  
  800566:	c3                   	ret    

00800567 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800567:	55                   	push   %ebp
  800568:	89 e5                	mov    %esp,%ebp
  80056a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80056d:	e8 cf 0d 00 00       	call   801341 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800572:	8d 45 0c             	lea    0xc(%ebp),%eax
  800575:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800578:	8b 45 08             	mov    0x8(%ebp),%eax
  80057b:	83 ec 08             	sub    $0x8,%esp
  80057e:	ff 75 f4             	pushl  -0xc(%ebp)
  800581:	50                   	push   %eax
  800582:	e8 48 ff ff ff       	call   8004cf <vcprintf>
  800587:	83 c4 10             	add    $0x10,%esp
  80058a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80058d:	e8 c9 0d 00 00       	call   80135b <sys_unlock_cons>
	return cnt;
  800592:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800595:	c9                   	leave  
  800596:	c3                   	ret    

00800597 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800597:	55                   	push   %ebp
  800598:	89 e5                	mov    %esp,%ebp
  80059a:	53                   	push   %ebx
  80059b:	83 ec 14             	sub    $0x14,%esp
  80059e:	8b 45 10             	mov    0x10(%ebp),%eax
  8005a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005aa:	8b 45 18             	mov    0x18(%ebp),%eax
  8005ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b5:	77 55                	ja     80060c <printnum+0x75>
  8005b7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ba:	72 05                	jb     8005c1 <printnum+0x2a>
  8005bc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005bf:	77 4b                	ja     80060c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005c1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005c4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005c7:	8b 45 18             	mov    0x18(%ebp),%eax
  8005ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cf:	52                   	push   %edx
  8005d0:	50                   	push   %eax
  8005d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d4:	ff 75 f0             	pushl  -0x10(%ebp)
  8005d7:	e8 4c 14 00 00       	call   801a28 <__udivdi3>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	83 ec 04             	sub    $0x4,%esp
  8005e2:	ff 75 20             	pushl  0x20(%ebp)
  8005e5:	53                   	push   %ebx
  8005e6:	ff 75 18             	pushl  0x18(%ebp)
  8005e9:	52                   	push   %edx
  8005ea:	50                   	push   %eax
  8005eb:	ff 75 0c             	pushl  0xc(%ebp)
  8005ee:	ff 75 08             	pushl  0x8(%ebp)
  8005f1:	e8 a1 ff ff ff       	call   800597 <printnum>
  8005f6:	83 c4 20             	add    $0x20,%esp
  8005f9:	eb 1a                	jmp    800615 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005fb:	83 ec 08             	sub    $0x8,%esp
  8005fe:	ff 75 0c             	pushl  0xc(%ebp)
  800601:	ff 75 20             	pushl  0x20(%ebp)
  800604:	8b 45 08             	mov    0x8(%ebp),%eax
  800607:	ff d0                	call   *%eax
  800609:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80060c:	ff 4d 1c             	decl   0x1c(%ebp)
  80060f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800613:	7f e6                	jg     8005fb <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800615:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800618:	bb 00 00 00 00       	mov    $0x0,%ebx
  80061d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800620:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800623:	53                   	push   %ebx
  800624:	51                   	push   %ecx
  800625:	52                   	push   %edx
  800626:	50                   	push   %eax
  800627:	e8 0c 15 00 00       	call   801b38 <__umoddi3>
  80062c:	83 c4 10             	add    $0x10,%esp
  80062f:	05 b4 21 80 00       	add    $0x8021b4,%eax
  800634:	8a 00                	mov    (%eax),%al
  800636:	0f be c0             	movsbl %al,%eax
  800639:	83 ec 08             	sub    $0x8,%esp
  80063c:	ff 75 0c             	pushl  0xc(%ebp)
  80063f:	50                   	push   %eax
  800640:	8b 45 08             	mov    0x8(%ebp),%eax
  800643:	ff d0                	call   *%eax
  800645:	83 c4 10             	add    $0x10,%esp
}
  800648:	90                   	nop
  800649:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80064c:	c9                   	leave  
  80064d:	c3                   	ret    

0080064e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80064e:	55                   	push   %ebp
  80064f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800651:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800655:	7e 1c                	jle    800673 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	8d 50 08             	lea    0x8(%eax),%edx
  80065f:	8b 45 08             	mov    0x8(%ebp),%eax
  800662:	89 10                	mov    %edx,(%eax)
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	8b 00                	mov    (%eax),%eax
  800669:	83 e8 08             	sub    $0x8,%eax
  80066c:	8b 50 04             	mov    0x4(%eax),%edx
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	eb 40                	jmp    8006b3 <getuint+0x65>
	else if (lflag)
  800673:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800677:	74 1e                	je     800697 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	8d 50 04             	lea    0x4(%eax),%edx
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	89 10                	mov    %edx,(%eax)
  800686:	8b 45 08             	mov    0x8(%ebp),%eax
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	83 e8 04             	sub    $0x4,%eax
  80068e:	8b 00                	mov    (%eax),%eax
  800690:	ba 00 00 00 00       	mov    $0x0,%edx
  800695:	eb 1c                	jmp    8006b3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	8d 50 04             	lea    0x4(%eax),%edx
  80069f:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a2:	89 10                	mov    %edx,(%eax)
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	8b 00                	mov    (%eax),%eax
  8006a9:	83 e8 04             	sub    $0x4,%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006b3:	5d                   	pop    %ebp
  8006b4:	c3                   	ret    

008006b5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006b5:	55                   	push   %ebp
  8006b6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006bc:	7e 1c                	jle    8006da <getint+0x25>
		return va_arg(*ap, long long);
  8006be:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	8d 50 08             	lea    0x8(%eax),%edx
  8006c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c9:	89 10                	mov    %edx,(%eax)
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	83 e8 08             	sub    $0x8,%eax
  8006d3:	8b 50 04             	mov    0x4(%eax),%edx
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	eb 38                	jmp    800712 <getint+0x5d>
	else if (lflag)
  8006da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006de:	74 1a                	je     8006fa <getint+0x45>
		return va_arg(*ap, long);
  8006e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	8d 50 04             	lea    0x4(%eax),%edx
  8006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006eb:	89 10                	mov    %edx,(%eax)
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	83 e8 04             	sub    $0x4,%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	99                   	cltd   
  8006f8:	eb 18                	jmp    800712 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	8d 50 04             	lea    0x4(%eax),%edx
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	89 10                	mov    %edx,(%eax)
  800707:	8b 45 08             	mov    0x8(%ebp),%eax
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	83 e8 04             	sub    $0x4,%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	99                   	cltd   
}
  800712:	5d                   	pop    %ebp
  800713:	c3                   	ret    

00800714 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800714:	55                   	push   %ebp
  800715:	89 e5                	mov    %esp,%ebp
  800717:	56                   	push   %esi
  800718:	53                   	push   %ebx
  800719:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80071c:	eb 17                	jmp    800735 <vprintfmt+0x21>
			if (ch == '\0')
  80071e:	85 db                	test   %ebx,%ebx
  800720:	0f 84 c1 03 00 00    	je     800ae7 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800726:	83 ec 08             	sub    $0x8,%esp
  800729:	ff 75 0c             	pushl  0xc(%ebp)
  80072c:	53                   	push   %ebx
  80072d:	8b 45 08             	mov    0x8(%ebp),%eax
  800730:	ff d0                	call   *%eax
  800732:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800735:	8b 45 10             	mov    0x10(%ebp),%eax
  800738:	8d 50 01             	lea    0x1(%eax),%edx
  80073b:	89 55 10             	mov    %edx,0x10(%ebp)
  80073e:	8a 00                	mov    (%eax),%al
  800740:	0f b6 d8             	movzbl %al,%ebx
  800743:	83 fb 25             	cmp    $0x25,%ebx
  800746:	75 d6                	jne    80071e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800748:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80074c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800753:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80075a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800761:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800768:	8b 45 10             	mov    0x10(%ebp),%eax
  80076b:	8d 50 01             	lea    0x1(%eax),%edx
  80076e:	89 55 10             	mov    %edx,0x10(%ebp)
  800771:	8a 00                	mov    (%eax),%al
  800773:	0f b6 d8             	movzbl %al,%ebx
  800776:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800779:	83 f8 5b             	cmp    $0x5b,%eax
  80077c:	0f 87 3d 03 00 00    	ja     800abf <vprintfmt+0x3ab>
  800782:	8b 04 85 d8 21 80 00 	mov    0x8021d8(,%eax,4),%eax
  800789:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80078b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80078f:	eb d7                	jmp    800768 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800791:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800795:	eb d1                	jmp    800768 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800797:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80079e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007a1:	89 d0                	mov    %edx,%eax
  8007a3:	c1 e0 02             	shl    $0x2,%eax
  8007a6:	01 d0                	add    %edx,%eax
  8007a8:	01 c0                	add    %eax,%eax
  8007aa:	01 d8                	add    %ebx,%eax
  8007ac:	83 e8 30             	sub    $0x30,%eax
  8007af:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b5:	8a 00                	mov    (%eax),%al
  8007b7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ba:	83 fb 2f             	cmp    $0x2f,%ebx
  8007bd:	7e 3e                	jle    8007fd <vprintfmt+0xe9>
  8007bf:	83 fb 39             	cmp    $0x39,%ebx
  8007c2:	7f 39                	jg     8007fd <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007c7:	eb d5                	jmp    80079e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	83 c0 04             	add    $0x4,%eax
  8007cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d5:	83 e8 04             	sub    $0x4,%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007dd:	eb 1f                	jmp    8007fe <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e3:	79 83                	jns    800768 <vprintfmt+0x54>
				width = 0;
  8007e5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007ec:	e9 77 ff ff ff       	jmp    800768 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007f1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f8:	e9 6b ff ff ff       	jmp    800768 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007fd:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800802:	0f 89 60 ff ff ff    	jns    800768 <vprintfmt+0x54>
				width = precision, precision = -1;
  800808:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80080b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80080e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800815:	e9 4e ff ff ff       	jmp    800768 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80081a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80081d:	e9 46 ff ff ff       	jmp    800768 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	83 c0 04             	add    $0x4,%eax
  800828:	89 45 14             	mov    %eax,0x14(%ebp)
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	83 e8 04             	sub    $0x4,%eax
  800831:	8b 00                	mov    (%eax),%eax
  800833:	83 ec 08             	sub    $0x8,%esp
  800836:	ff 75 0c             	pushl  0xc(%ebp)
  800839:	50                   	push   %eax
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	ff d0                	call   *%eax
  80083f:	83 c4 10             	add    $0x10,%esp
			break;
  800842:	e9 9b 02 00 00       	jmp    800ae2 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800847:	8b 45 14             	mov    0x14(%ebp),%eax
  80084a:	83 c0 04             	add    $0x4,%eax
  80084d:	89 45 14             	mov    %eax,0x14(%ebp)
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	83 e8 04             	sub    $0x4,%eax
  800856:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800858:	85 db                	test   %ebx,%ebx
  80085a:	79 02                	jns    80085e <vprintfmt+0x14a>
				err = -err;
  80085c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80085e:	83 fb 64             	cmp    $0x64,%ebx
  800861:	7f 0b                	jg     80086e <vprintfmt+0x15a>
  800863:	8b 34 9d 20 20 80 00 	mov    0x802020(,%ebx,4),%esi
  80086a:	85 f6                	test   %esi,%esi
  80086c:	75 19                	jne    800887 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80086e:	53                   	push   %ebx
  80086f:	68 c5 21 80 00       	push   $0x8021c5
  800874:	ff 75 0c             	pushl  0xc(%ebp)
  800877:	ff 75 08             	pushl  0x8(%ebp)
  80087a:	e8 70 02 00 00       	call   800aef <printfmt>
  80087f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800882:	e9 5b 02 00 00       	jmp    800ae2 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800887:	56                   	push   %esi
  800888:	68 ce 21 80 00       	push   $0x8021ce
  80088d:	ff 75 0c             	pushl  0xc(%ebp)
  800890:	ff 75 08             	pushl  0x8(%ebp)
  800893:	e8 57 02 00 00       	call   800aef <printfmt>
  800898:	83 c4 10             	add    $0x10,%esp
			break;
  80089b:	e9 42 02 00 00       	jmp    800ae2 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a3:	83 c0 04             	add    $0x4,%eax
  8008a6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ac:	83 e8 04             	sub    $0x4,%eax
  8008af:	8b 30                	mov    (%eax),%esi
  8008b1:	85 f6                	test   %esi,%esi
  8008b3:	75 05                	jne    8008ba <vprintfmt+0x1a6>
				p = "(null)";
  8008b5:	be d1 21 80 00       	mov    $0x8021d1,%esi
			if (width > 0 && padc != '-')
  8008ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008be:	7e 6d                	jle    80092d <vprintfmt+0x219>
  8008c0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008c4:	74 67                	je     80092d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c9:	83 ec 08             	sub    $0x8,%esp
  8008cc:	50                   	push   %eax
  8008cd:	56                   	push   %esi
  8008ce:	e8 1e 03 00 00       	call   800bf1 <strnlen>
  8008d3:	83 c4 10             	add    $0x10,%esp
  8008d6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d9:	eb 16                	jmp    8008f1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008db:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008df:	83 ec 08             	sub    $0x8,%esp
  8008e2:	ff 75 0c             	pushl  0xc(%ebp)
  8008e5:	50                   	push   %eax
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	ff d0                	call   *%eax
  8008eb:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ee:	ff 4d e4             	decl   -0x1c(%ebp)
  8008f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f5:	7f e4                	jg     8008db <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f7:	eb 34                	jmp    80092d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008fd:	74 1c                	je     80091b <vprintfmt+0x207>
  8008ff:	83 fb 1f             	cmp    $0x1f,%ebx
  800902:	7e 05                	jle    800909 <vprintfmt+0x1f5>
  800904:	83 fb 7e             	cmp    $0x7e,%ebx
  800907:	7e 12                	jle    80091b <vprintfmt+0x207>
					putch('?', putdat);
  800909:	83 ec 08             	sub    $0x8,%esp
  80090c:	ff 75 0c             	pushl  0xc(%ebp)
  80090f:	6a 3f                	push   $0x3f
  800911:	8b 45 08             	mov    0x8(%ebp),%eax
  800914:	ff d0                	call   *%eax
  800916:	83 c4 10             	add    $0x10,%esp
  800919:	eb 0f                	jmp    80092a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80091b:	83 ec 08             	sub    $0x8,%esp
  80091e:	ff 75 0c             	pushl  0xc(%ebp)
  800921:	53                   	push   %ebx
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	ff d0                	call   *%eax
  800927:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80092a:	ff 4d e4             	decl   -0x1c(%ebp)
  80092d:	89 f0                	mov    %esi,%eax
  80092f:	8d 70 01             	lea    0x1(%eax),%esi
  800932:	8a 00                	mov    (%eax),%al
  800934:	0f be d8             	movsbl %al,%ebx
  800937:	85 db                	test   %ebx,%ebx
  800939:	74 24                	je     80095f <vprintfmt+0x24b>
  80093b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80093f:	78 b8                	js     8008f9 <vprintfmt+0x1e5>
  800941:	ff 4d e0             	decl   -0x20(%ebp)
  800944:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800948:	79 af                	jns    8008f9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80094a:	eb 13                	jmp    80095f <vprintfmt+0x24b>
				putch(' ', putdat);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	ff 75 0c             	pushl  0xc(%ebp)
  800952:	6a 20                	push   $0x20
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	ff d0                	call   *%eax
  800959:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80095c:	ff 4d e4             	decl   -0x1c(%ebp)
  80095f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800963:	7f e7                	jg     80094c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800965:	e9 78 01 00 00       	jmp    800ae2 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80096a:	83 ec 08             	sub    $0x8,%esp
  80096d:	ff 75 e8             	pushl  -0x18(%ebp)
  800970:	8d 45 14             	lea    0x14(%ebp),%eax
  800973:	50                   	push   %eax
  800974:	e8 3c fd ff ff       	call   8006b5 <getint>
  800979:	83 c4 10             	add    $0x10,%esp
  80097c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800982:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800985:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800988:	85 d2                	test   %edx,%edx
  80098a:	79 23                	jns    8009af <vprintfmt+0x29b>
				putch('-', putdat);
  80098c:	83 ec 08             	sub    $0x8,%esp
  80098f:	ff 75 0c             	pushl  0xc(%ebp)
  800992:	6a 2d                	push   $0x2d
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	ff d0                	call   *%eax
  800999:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80099c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80099f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009a2:	f7 d8                	neg    %eax
  8009a4:	83 d2 00             	adc    $0x0,%edx
  8009a7:	f7 da                	neg    %edx
  8009a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009af:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009b6:	e9 bc 00 00 00       	jmp    800a77 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	ff 75 e8             	pushl  -0x18(%ebp)
  8009c1:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c4:	50                   	push   %eax
  8009c5:	e8 84 fc ff ff       	call   80064e <getuint>
  8009ca:	83 c4 10             	add    $0x10,%esp
  8009cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009d3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009da:	e9 98 00 00 00       	jmp    800a77 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009df:	83 ec 08             	sub    $0x8,%esp
  8009e2:	ff 75 0c             	pushl  0xc(%ebp)
  8009e5:	6a 58                	push   $0x58
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	ff d0                	call   *%eax
  8009ec:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	ff 75 0c             	pushl  0xc(%ebp)
  8009f5:	6a 58                	push   $0x58
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	ff d0                	call   *%eax
  8009fc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	6a 58                	push   $0x58
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	ff d0                	call   *%eax
  800a0c:	83 c4 10             	add    $0x10,%esp
			break;
  800a0f:	e9 ce 00 00 00       	jmp    800ae2 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a14:	83 ec 08             	sub    $0x8,%esp
  800a17:	ff 75 0c             	pushl  0xc(%ebp)
  800a1a:	6a 30                	push   $0x30
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	ff d0                	call   *%eax
  800a21:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a24:	83 ec 08             	sub    $0x8,%esp
  800a27:	ff 75 0c             	pushl  0xc(%ebp)
  800a2a:	6a 78                	push   $0x78
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	ff d0                	call   *%eax
  800a31:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a34:	8b 45 14             	mov    0x14(%ebp),%eax
  800a37:	83 c0 04             	add    $0x4,%eax
  800a3a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a40:	83 e8 04             	sub    $0x4,%eax
  800a43:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a4f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a56:	eb 1f                	jmp    800a77 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a58:	83 ec 08             	sub    $0x8,%esp
  800a5b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a5e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a61:	50                   	push   %eax
  800a62:	e8 e7 fb ff ff       	call   80064e <getuint>
  800a67:	83 c4 10             	add    $0x10,%esp
  800a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a70:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a77:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a7e:	83 ec 04             	sub    $0x4,%esp
  800a81:	52                   	push   %edx
  800a82:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a85:	50                   	push   %eax
  800a86:	ff 75 f4             	pushl  -0xc(%ebp)
  800a89:	ff 75 f0             	pushl  -0x10(%ebp)
  800a8c:	ff 75 0c             	pushl  0xc(%ebp)
  800a8f:	ff 75 08             	pushl  0x8(%ebp)
  800a92:	e8 00 fb ff ff       	call   800597 <printnum>
  800a97:	83 c4 20             	add    $0x20,%esp
			break;
  800a9a:	eb 46                	jmp    800ae2 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a9c:	83 ec 08             	sub    $0x8,%esp
  800a9f:	ff 75 0c             	pushl  0xc(%ebp)
  800aa2:	53                   	push   %ebx
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	ff d0                	call   *%eax
  800aa8:	83 c4 10             	add    $0x10,%esp
			break;
  800aab:	eb 35                	jmp    800ae2 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800aad:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800ab4:	eb 2c                	jmp    800ae2 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ab6:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800abd:	eb 23                	jmp    800ae2 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800abf:	83 ec 08             	sub    $0x8,%esp
  800ac2:	ff 75 0c             	pushl  0xc(%ebp)
  800ac5:	6a 25                	push   $0x25
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aca:	ff d0                	call   *%eax
  800acc:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800acf:	ff 4d 10             	decl   0x10(%ebp)
  800ad2:	eb 03                	jmp    800ad7 <vprintfmt+0x3c3>
  800ad4:	ff 4d 10             	decl   0x10(%ebp)
  800ad7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ada:	48                   	dec    %eax
  800adb:	8a 00                	mov    (%eax),%al
  800add:	3c 25                	cmp    $0x25,%al
  800adf:	75 f3                	jne    800ad4 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ae1:	90                   	nop
		}
	}
  800ae2:	e9 35 fc ff ff       	jmp    80071c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ae7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ae8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aeb:	5b                   	pop    %ebx
  800aec:	5e                   	pop    %esi
  800aed:	5d                   	pop    %ebp
  800aee:	c3                   	ret    

00800aef <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800af5:	8d 45 10             	lea    0x10(%ebp),%eax
  800af8:	83 c0 04             	add    $0x4,%eax
  800afb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800afe:	8b 45 10             	mov    0x10(%ebp),%eax
  800b01:	ff 75 f4             	pushl  -0xc(%ebp)
  800b04:	50                   	push   %eax
  800b05:	ff 75 0c             	pushl  0xc(%ebp)
  800b08:	ff 75 08             	pushl  0x8(%ebp)
  800b0b:	e8 04 fc ff ff       	call   800714 <vprintfmt>
  800b10:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b13:	90                   	nop
  800b14:	c9                   	leave  
  800b15:	c3                   	ret    

00800b16 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1c:	8b 40 08             	mov    0x8(%eax),%eax
  800b1f:	8d 50 01             	lea    0x1(%eax),%edx
  800b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b25:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2b:	8b 10                	mov    (%eax),%edx
  800b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b30:	8b 40 04             	mov    0x4(%eax),%eax
  800b33:	39 c2                	cmp    %eax,%edx
  800b35:	73 12                	jae    800b49 <sprintputch+0x33>
		*b->buf++ = ch;
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	8b 00                	mov    (%eax),%eax
  800b3c:	8d 48 01             	lea    0x1(%eax),%ecx
  800b3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b42:	89 0a                	mov    %ecx,(%edx)
  800b44:	8b 55 08             	mov    0x8(%ebp),%edx
  800b47:	88 10                	mov    %dl,(%eax)
}
  800b49:	90                   	nop
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    

00800b4c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	01 d0                	add    %edx,%eax
  800b63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b71:	74 06                	je     800b79 <vsnprintf+0x2d>
  800b73:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b77:	7f 07                	jg     800b80 <vsnprintf+0x34>
		return -E_INVAL;
  800b79:	b8 03 00 00 00       	mov    $0x3,%eax
  800b7e:	eb 20                	jmp    800ba0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b80:	ff 75 14             	pushl  0x14(%ebp)
  800b83:	ff 75 10             	pushl  0x10(%ebp)
  800b86:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b89:	50                   	push   %eax
  800b8a:	68 16 0b 80 00       	push   $0x800b16
  800b8f:	e8 80 fb ff ff       	call   800714 <vprintfmt>
  800b94:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b9a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ba0:	c9                   	leave  
  800ba1:	c3                   	ret    

00800ba2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ba2:	55                   	push   %ebp
  800ba3:	89 e5                	mov    %esp,%ebp
  800ba5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ba8:	8d 45 10             	lea    0x10(%ebp),%eax
  800bab:	83 c0 04             	add    $0x4,%eax
  800bae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb4:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb7:	50                   	push   %eax
  800bb8:	ff 75 0c             	pushl  0xc(%ebp)
  800bbb:	ff 75 08             	pushl  0x8(%ebp)
  800bbe:	e8 89 ff ff ff       	call   800b4c <vsnprintf>
  800bc3:	83 c4 10             	add    $0x10,%esp
  800bc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bcc:	c9                   	leave  
  800bcd:	c3                   	ret    

00800bce <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bdb:	eb 06                	jmp    800be3 <strlen+0x15>
		n++;
  800bdd:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800be0:	ff 45 08             	incl   0x8(%ebp)
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	8a 00                	mov    (%eax),%al
  800be8:	84 c0                	test   %al,%al
  800bea:	75 f1                	jne    800bdd <strlen+0xf>
		n++;
	return n;
  800bec:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bef:	c9                   	leave  
  800bf0:	c3                   	ret    

00800bf1 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bf7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bfe:	eb 09                	jmp    800c09 <strnlen+0x18>
		n++;
  800c00:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c03:	ff 45 08             	incl   0x8(%ebp)
  800c06:	ff 4d 0c             	decl   0xc(%ebp)
  800c09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c0d:	74 09                	je     800c18 <strnlen+0x27>
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	8a 00                	mov    (%eax),%al
  800c14:	84 c0                	test   %al,%al
  800c16:	75 e8                	jne    800c00 <strnlen+0xf>
		n++;
	return n;
  800c18:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c1b:	c9                   	leave  
  800c1c:	c3                   	ret    

00800c1d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c29:	90                   	nop
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	8d 50 01             	lea    0x1(%eax),%edx
  800c30:	89 55 08             	mov    %edx,0x8(%ebp)
  800c33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c36:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c39:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c3c:	8a 12                	mov    (%edx),%dl
  800c3e:	88 10                	mov    %dl,(%eax)
  800c40:	8a 00                	mov    (%eax),%al
  800c42:	84 c0                	test   %al,%al
  800c44:	75 e4                	jne    800c2a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c49:	c9                   	leave  
  800c4a:	c3                   	ret    

00800c4b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c57:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c5e:	eb 1f                	jmp    800c7f <strncpy+0x34>
		*dst++ = *src;
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8d 50 01             	lea    0x1(%eax),%edx
  800c66:	89 55 08             	mov    %edx,0x8(%ebp)
  800c69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6c:	8a 12                	mov    (%edx),%dl
  800c6e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c73:	8a 00                	mov    (%eax),%al
  800c75:	84 c0                	test   %al,%al
  800c77:	74 03                	je     800c7c <strncpy+0x31>
			src++;
  800c79:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c7c:	ff 45 fc             	incl   -0x4(%ebp)
  800c7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c82:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c85:	72 d9                	jb     800c60 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c87:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c8a:	c9                   	leave  
  800c8b:	c3                   	ret    

00800c8c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c9c:	74 30                	je     800cce <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c9e:	eb 16                	jmp    800cb6 <strlcpy+0x2a>
			*dst++ = *src++;
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	8d 50 01             	lea    0x1(%eax),%edx
  800ca6:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cac:	8d 4a 01             	lea    0x1(%edx),%ecx
  800caf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cb2:	8a 12                	mov    (%edx),%dl
  800cb4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cb6:	ff 4d 10             	decl   0x10(%ebp)
  800cb9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cbd:	74 09                	je     800cc8 <strlcpy+0x3c>
  800cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc2:	8a 00                	mov    (%eax),%al
  800cc4:	84 c0                	test   %al,%al
  800cc6:	75 d8                	jne    800ca0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cce:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd4:	29 c2                	sub    %eax,%edx
  800cd6:	89 d0                	mov    %edx,%eax
}
  800cd8:	c9                   	leave  
  800cd9:	c3                   	ret    

00800cda <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cda:	55                   	push   %ebp
  800cdb:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cdd:	eb 06                	jmp    800ce5 <strcmp+0xb>
		p++, q++;
  800cdf:	ff 45 08             	incl   0x8(%ebp)
  800ce2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	84 c0                	test   %al,%al
  800cec:	74 0e                	je     800cfc <strcmp+0x22>
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8a 10                	mov    (%eax),%dl
  800cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf6:	8a 00                	mov    (%eax),%al
  800cf8:	38 c2                	cmp    %al,%dl
  800cfa:	74 e3                	je     800cdf <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	8a 00                	mov    (%eax),%al
  800d01:	0f b6 d0             	movzbl %al,%edx
  800d04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d07:	8a 00                	mov    (%eax),%al
  800d09:	0f b6 c0             	movzbl %al,%eax
  800d0c:	29 c2                	sub    %eax,%edx
  800d0e:	89 d0                	mov    %edx,%eax
}
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    

00800d12 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d15:	eb 09                	jmp    800d20 <strncmp+0xe>
		n--, p++, q++;
  800d17:	ff 4d 10             	decl   0x10(%ebp)
  800d1a:	ff 45 08             	incl   0x8(%ebp)
  800d1d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d20:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d24:	74 17                	je     800d3d <strncmp+0x2b>
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	8a 00                	mov    (%eax),%al
  800d2b:	84 c0                	test   %al,%al
  800d2d:	74 0e                	je     800d3d <strncmp+0x2b>
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	8a 10                	mov    (%eax),%dl
  800d34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	38 c2                	cmp    %al,%dl
  800d3b:	74 da                	je     800d17 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d41:	75 07                	jne    800d4a <strncmp+0x38>
		return 0;
  800d43:	b8 00 00 00 00       	mov    $0x0,%eax
  800d48:	eb 14                	jmp    800d5e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4d:	8a 00                	mov    (%eax),%al
  800d4f:	0f b6 d0             	movzbl %al,%edx
  800d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	0f b6 c0             	movzbl %al,%eax
  800d5a:	29 c2                	sub    %eax,%edx
  800d5c:	89 d0                	mov    %edx,%eax
}
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    

00800d60 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	83 ec 04             	sub    $0x4,%esp
  800d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d69:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d6c:	eb 12                	jmp    800d80 <strchr+0x20>
		if (*s == c)
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	8a 00                	mov    (%eax),%al
  800d73:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d76:	75 05                	jne    800d7d <strchr+0x1d>
			return (char *) s;
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	eb 11                	jmp    800d8e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d7d:	ff 45 08             	incl   0x8(%ebp)
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	84 c0                	test   %al,%al
  800d87:	75 e5                	jne    800d6e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d8e:	c9                   	leave  
  800d8f:	c3                   	ret    

00800d90 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	83 ec 04             	sub    $0x4,%esp
  800d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d99:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d9c:	eb 0d                	jmp    800dab <strfind+0x1b>
		if (*s == c)
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8a 00                	mov    (%eax),%al
  800da3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800da6:	74 0e                	je     800db6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800da8:	ff 45 08             	incl   0x8(%ebp)
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	8a 00                	mov    (%eax),%al
  800db0:	84 c0                	test   %al,%al
  800db2:	75 ea                	jne    800d9e <strfind+0xe>
  800db4:	eb 01                	jmp    800db7 <strfind+0x27>
		if (*s == c)
			break;
  800db6:	90                   	nop
	return (char *) s;
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dba:	c9                   	leave  
  800dbb:	c3                   	ret    

00800dbc <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dce:	eb 0e                	jmp    800dde <memset+0x22>
		*p++ = c;
  800dd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd3:	8d 50 01             	lea    0x1(%eax),%edx
  800dd6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ddc:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dde:	ff 4d f8             	decl   -0x8(%ebp)
  800de1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800de5:	79 e9                	jns    800dd0 <memset+0x14>
		*p++ = c;

	return v;
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dea:	c9                   	leave  
  800deb:	c3                   	ret    

00800dec <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800df2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dfe:	eb 16                	jmp    800e16 <memcpy+0x2a>
		*d++ = *s++;
  800e00:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e03:	8d 50 01             	lea    0x1(%eax),%edx
  800e06:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e09:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e0c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e12:	8a 12                	mov    (%edx),%dl
  800e14:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e16:	8b 45 10             	mov    0x10(%ebp),%eax
  800e19:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e1c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1f:	85 c0                	test   %eax,%eax
  800e21:	75 dd                	jne    800e00 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e26:	c9                   	leave  
  800e27:	c3                   	ret    

00800e28 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e40:	73 50                	jae    800e92 <memmove+0x6a>
  800e42:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e45:	8b 45 10             	mov    0x10(%ebp),%eax
  800e48:	01 d0                	add    %edx,%eax
  800e4a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e4d:	76 43                	jbe    800e92 <memmove+0x6a>
		s += n;
  800e4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e52:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e55:	8b 45 10             	mov    0x10(%ebp),%eax
  800e58:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e5b:	eb 10                	jmp    800e6d <memmove+0x45>
			*--d = *--s;
  800e5d:	ff 4d f8             	decl   -0x8(%ebp)
  800e60:	ff 4d fc             	decl   -0x4(%ebp)
  800e63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e66:	8a 10                	mov    (%eax),%dl
  800e68:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e6b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e70:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e73:	89 55 10             	mov    %edx,0x10(%ebp)
  800e76:	85 c0                	test   %eax,%eax
  800e78:	75 e3                	jne    800e5d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e7a:	eb 23                	jmp    800e9f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7f:	8d 50 01             	lea    0x1(%eax),%edx
  800e82:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e85:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e88:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e8b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e8e:	8a 12                	mov    (%edx),%dl
  800e90:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e92:	8b 45 10             	mov    0x10(%ebp),%eax
  800e95:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e98:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9b:	85 c0                	test   %eax,%eax
  800e9d:	75 dd                	jne    800e7c <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea2:	c9                   	leave  
  800ea3:	c3                   	ret    

00800ea4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eb6:	eb 2a                	jmp    800ee2 <memcmp+0x3e>
		if (*s1 != *s2)
  800eb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebb:	8a 10                	mov    (%eax),%dl
  800ebd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	38 c2                	cmp    %al,%dl
  800ec4:	74 16                	je     800edc <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ec6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	0f b6 d0             	movzbl %al,%edx
  800ece:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	0f b6 c0             	movzbl %al,%eax
  800ed6:	29 c2                	sub    %eax,%edx
  800ed8:	89 d0                	mov    %edx,%eax
  800eda:	eb 18                	jmp    800ef4 <memcmp+0x50>
		s1++, s2++;
  800edc:	ff 45 fc             	incl   -0x4(%ebp)
  800edf:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee8:	89 55 10             	mov    %edx,0x10(%ebp)
  800eeb:	85 c0                	test   %eax,%eax
  800eed:	75 c9                	jne    800eb8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800eef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef4:	c9                   	leave  
  800ef5:	c3                   	ret    

00800ef6 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ef6:	55                   	push   %ebp
  800ef7:	89 e5                	mov    %esp,%ebp
  800ef9:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800efc:	8b 55 08             	mov    0x8(%ebp),%edx
  800eff:	8b 45 10             	mov    0x10(%ebp),%eax
  800f02:	01 d0                	add    %edx,%eax
  800f04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f07:	eb 15                	jmp    800f1e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0c:	8a 00                	mov    (%eax),%al
  800f0e:	0f b6 d0             	movzbl %al,%edx
  800f11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f14:	0f b6 c0             	movzbl %al,%eax
  800f17:	39 c2                	cmp    %eax,%edx
  800f19:	74 0d                	je     800f28 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f1b:	ff 45 08             	incl   0x8(%ebp)
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f24:	72 e3                	jb     800f09 <memfind+0x13>
  800f26:	eb 01                	jmp    800f29 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f28:	90                   	nop
	return (void *) s;
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f2c:	c9                   	leave  
  800f2d:	c3                   	ret    

00800f2e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f3b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f42:	eb 03                	jmp    800f47 <strtol+0x19>
		s++;
  800f44:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	8a 00                	mov    (%eax),%al
  800f4c:	3c 20                	cmp    $0x20,%al
  800f4e:	74 f4                	je     800f44 <strtol+0x16>
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	3c 09                	cmp    $0x9,%al
  800f57:	74 eb                	je     800f44 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	3c 2b                	cmp    $0x2b,%al
  800f60:	75 05                	jne    800f67 <strtol+0x39>
		s++;
  800f62:	ff 45 08             	incl   0x8(%ebp)
  800f65:	eb 13                	jmp    800f7a <strtol+0x4c>
	else if (*s == '-')
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	8a 00                	mov    (%eax),%al
  800f6c:	3c 2d                	cmp    $0x2d,%al
  800f6e:	75 0a                	jne    800f7a <strtol+0x4c>
		s++, neg = 1;
  800f70:	ff 45 08             	incl   0x8(%ebp)
  800f73:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7e:	74 06                	je     800f86 <strtol+0x58>
  800f80:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f84:	75 20                	jne    800fa6 <strtol+0x78>
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	3c 30                	cmp    $0x30,%al
  800f8d:	75 17                	jne    800fa6 <strtol+0x78>
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	40                   	inc    %eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	3c 78                	cmp    $0x78,%al
  800f97:	75 0d                	jne    800fa6 <strtol+0x78>
		s += 2, base = 16;
  800f99:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f9d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fa4:	eb 28                	jmp    800fce <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fa6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800faa:	75 15                	jne    800fc1 <strtol+0x93>
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	3c 30                	cmp    $0x30,%al
  800fb3:	75 0c                	jne    800fc1 <strtol+0x93>
		s++, base = 8;
  800fb5:	ff 45 08             	incl   0x8(%ebp)
  800fb8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fbf:	eb 0d                	jmp    800fce <strtol+0xa0>
	else if (base == 0)
  800fc1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc5:	75 07                	jne    800fce <strtol+0xa0>
		base = 10;
  800fc7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	3c 2f                	cmp    $0x2f,%al
  800fd5:	7e 19                	jle    800ff0 <strtol+0xc2>
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 39                	cmp    $0x39,%al
  800fde:	7f 10                	jg     800ff0 <strtol+0xc2>
			dig = *s - '0';
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	0f be c0             	movsbl %al,%eax
  800fe8:	83 e8 30             	sub    $0x30,%eax
  800feb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fee:	eb 42                	jmp    801032 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	8a 00                	mov    (%eax),%al
  800ff5:	3c 60                	cmp    $0x60,%al
  800ff7:	7e 19                	jle    801012 <strtol+0xe4>
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	3c 7a                	cmp    $0x7a,%al
  801000:	7f 10                	jg     801012 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	0f be c0             	movsbl %al,%eax
  80100a:	83 e8 57             	sub    $0x57,%eax
  80100d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801010:	eb 20                	jmp    801032 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	8a 00                	mov    (%eax),%al
  801017:	3c 40                	cmp    $0x40,%al
  801019:	7e 39                	jle    801054 <strtol+0x126>
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	8a 00                	mov    (%eax),%al
  801020:	3c 5a                	cmp    $0x5a,%al
  801022:	7f 30                	jg     801054 <strtol+0x126>
			dig = *s - 'A' + 10;
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	8a 00                	mov    (%eax),%al
  801029:	0f be c0             	movsbl %al,%eax
  80102c:	83 e8 37             	sub    $0x37,%eax
  80102f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801032:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801035:	3b 45 10             	cmp    0x10(%ebp),%eax
  801038:	7d 19                	jge    801053 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80103a:	ff 45 08             	incl   0x8(%ebp)
  80103d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801040:	0f af 45 10          	imul   0x10(%ebp),%eax
  801044:	89 c2                	mov    %eax,%edx
  801046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801049:	01 d0                	add    %edx,%eax
  80104b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80104e:	e9 7b ff ff ff       	jmp    800fce <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801053:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801054:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801058:	74 08                	je     801062 <strtol+0x134>
		*endptr = (char *) s;
  80105a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105d:	8b 55 08             	mov    0x8(%ebp),%edx
  801060:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801062:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801066:	74 07                	je     80106f <strtol+0x141>
  801068:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106b:	f7 d8                	neg    %eax
  80106d:	eb 03                	jmp    801072 <strtol+0x144>
  80106f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801072:	c9                   	leave  
  801073:	c3                   	ret    

00801074 <ltostr>:

void
ltostr(long value, char *str)
{
  801074:	55                   	push   %ebp
  801075:	89 e5                	mov    %esp,%ebp
  801077:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80107a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801081:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801088:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80108c:	79 13                	jns    8010a1 <ltostr+0x2d>
	{
		neg = 1;
  80108e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801095:	8b 45 0c             	mov    0xc(%ebp),%eax
  801098:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80109b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80109e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010a9:	99                   	cltd   
  8010aa:	f7 f9                	idiv   %ecx
  8010ac:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b2:	8d 50 01             	lea    0x1(%eax),%edx
  8010b5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b8:	89 c2                	mov    %eax,%edx
  8010ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bd:	01 d0                	add    %edx,%eax
  8010bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010c2:	83 c2 30             	add    $0x30,%edx
  8010c5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ca:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010cf:	f7 e9                	imul   %ecx
  8010d1:	c1 fa 02             	sar    $0x2,%edx
  8010d4:	89 c8                	mov    %ecx,%eax
  8010d6:	c1 f8 1f             	sar    $0x1f,%eax
  8010d9:	29 c2                	sub    %eax,%edx
  8010db:	89 d0                	mov    %edx,%eax
  8010dd:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010e4:	75 bb                	jne    8010a1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f0:	48                   	dec    %eax
  8010f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f8:	74 3d                	je     801137 <ltostr+0xc3>
		start = 1 ;
  8010fa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801101:	eb 34                	jmp    801137 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801103:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801106:	8b 45 0c             	mov    0xc(%ebp),%eax
  801109:	01 d0                	add    %edx,%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801110:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801113:	8b 45 0c             	mov    0xc(%ebp),%eax
  801116:	01 c2                	add    %eax,%edx
  801118:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80111b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111e:	01 c8                	add    %ecx,%eax
  801120:	8a 00                	mov    (%eax),%al
  801122:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801124:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112a:	01 c2                	add    %eax,%edx
  80112c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80112f:	88 02                	mov    %al,(%edx)
		start++ ;
  801131:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801134:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80113a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80113d:	7c c4                	jl     801103 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80113f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801142:	8b 45 0c             	mov    0xc(%ebp),%eax
  801145:	01 d0                	add    %edx,%eax
  801147:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80114a:	90                   	nop
  80114b:	c9                   	leave  
  80114c:	c3                   	ret    

0080114d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801153:	ff 75 08             	pushl  0x8(%ebp)
  801156:	e8 73 fa ff ff       	call   800bce <strlen>
  80115b:	83 c4 04             	add    $0x4,%esp
  80115e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801161:	ff 75 0c             	pushl  0xc(%ebp)
  801164:	e8 65 fa ff ff       	call   800bce <strlen>
  801169:	83 c4 04             	add    $0x4,%esp
  80116c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80116f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801176:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80117d:	eb 17                	jmp    801196 <strcconcat+0x49>
		final[s] = str1[s] ;
  80117f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801182:	8b 45 10             	mov    0x10(%ebp),%eax
  801185:	01 c2                	add    %eax,%edx
  801187:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	01 c8                	add    %ecx,%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801193:	ff 45 fc             	incl   -0x4(%ebp)
  801196:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801199:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80119c:	7c e1                	jl     80117f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80119e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011ac:	eb 1f                	jmp    8011cd <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b1:	8d 50 01             	lea    0x1(%eax),%edx
  8011b4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011b7:	89 c2                	mov    %eax,%edx
  8011b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bc:	01 c2                	add    %eax,%edx
  8011be:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c4:	01 c8                	add    %ecx,%eax
  8011c6:	8a 00                	mov    (%eax),%al
  8011c8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011ca:	ff 45 f8             	incl   -0x8(%ebp)
  8011cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d3:	7c d9                	jl     8011ae <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011db:	01 d0                	add    %edx,%eax
  8011dd:	c6 00 00             	movb   $0x0,(%eax)
}
  8011e0:	90                   	nop
  8011e1:	c9                   	leave  
  8011e2:	c3                   	ret    

008011e3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011e3:	55                   	push   %ebp
  8011e4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f2:	8b 00                	mov    (%eax),%eax
  8011f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fe:	01 d0                	add    %edx,%eax
  801200:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801206:	eb 0c                	jmp    801214 <strsplit+0x31>
			*string++ = 0;
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8d 50 01             	lea    0x1(%eax),%edx
  80120e:	89 55 08             	mov    %edx,0x8(%ebp)
  801211:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	8a 00                	mov    (%eax),%al
  801219:	84 c0                	test   %al,%al
  80121b:	74 18                	je     801235 <strsplit+0x52>
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	8a 00                	mov    (%eax),%al
  801222:	0f be c0             	movsbl %al,%eax
  801225:	50                   	push   %eax
  801226:	ff 75 0c             	pushl  0xc(%ebp)
  801229:	e8 32 fb ff ff       	call   800d60 <strchr>
  80122e:	83 c4 08             	add    $0x8,%esp
  801231:	85 c0                	test   %eax,%eax
  801233:	75 d3                	jne    801208 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	8a 00                	mov    (%eax),%al
  80123a:	84 c0                	test   %al,%al
  80123c:	74 5a                	je     801298 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80123e:	8b 45 14             	mov    0x14(%ebp),%eax
  801241:	8b 00                	mov    (%eax),%eax
  801243:	83 f8 0f             	cmp    $0xf,%eax
  801246:	75 07                	jne    80124f <strsplit+0x6c>
		{
			return 0;
  801248:	b8 00 00 00 00       	mov    $0x0,%eax
  80124d:	eb 66                	jmp    8012b5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80124f:	8b 45 14             	mov    0x14(%ebp),%eax
  801252:	8b 00                	mov    (%eax),%eax
  801254:	8d 48 01             	lea    0x1(%eax),%ecx
  801257:	8b 55 14             	mov    0x14(%ebp),%edx
  80125a:	89 0a                	mov    %ecx,(%edx)
  80125c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801263:	8b 45 10             	mov    0x10(%ebp),%eax
  801266:	01 c2                	add    %eax,%edx
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80126d:	eb 03                	jmp    801272 <strsplit+0x8f>
			string++;
  80126f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	84 c0                	test   %al,%al
  801279:	74 8b                	je     801206 <strsplit+0x23>
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	8a 00                	mov    (%eax),%al
  801280:	0f be c0             	movsbl %al,%eax
  801283:	50                   	push   %eax
  801284:	ff 75 0c             	pushl  0xc(%ebp)
  801287:	e8 d4 fa ff ff       	call   800d60 <strchr>
  80128c:	83 c4 08             	add    $0x8,%esp
  80128f:	85 c0                	test   %eax,%eax
  801291:	74 dc                	je     80126f <strsplit+0x8c>
			string++;
	}
  801293:	e9 6e ff ff ff       	jmp    801206 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801298:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801299:	8b 45 14             	mov    0x14(%ebp),%eax
  80129c:	8b 00                	mov    (%eax),%eax
  80129e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a8:	01 d0                	add    %edx,%eax
  8012aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012b0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012b5:	c9                   	leave  
  8012b6:	c3                   	ret    

008012b7 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
  8012ba:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8012bd:	83 ec 04             	sub    $0x4,%esp
  8012c0:	68 48 23 80 00       	push   $0x802348
  8012c5:	68 3f 01 00 00       	push   $0x13f
  8012ca:	68 6a 23 80 00       	push   $0x80236a
  8012cf:	e8 a9 ef ff ff       	call   80027d <_panic>

008012d4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
  8012d7:	57                   	push   %edi
  8012d8:	56                   	push   %esi
  8012d9:	53                   	push   %ebx
  8012da:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012e9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012ec:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012ef:	cd 30                	int    $0x30
  8012f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	5b                   	pop    %ebx
  8012fb:	5e                   	pop    %esi
  8012fc:	5f                   	pop    %edi
  8012fd:	5d                   	pop    %ebp
  8012fe:	c3                   	ret    

008012ff <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
  801302:	83 ec 04             	sub    $0x4,%esp
  801305:	8b 45 10             	mov    0x10(%ebp),%eax
  801308:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80130b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80130f:	8b 45 08             	mov    0x8(%ebp),%eax
  801312:	6a 00                	push   $0x0
  801314:	6a 00                	push   $0x0
  801316:	52                   	push   %edx
  801317:	ff 75 0c             	pushl  0xc(%ebp)
  80131a:	50                   	push   %eax
  80131b:	6a 00                	push   $0x0
  80131d:	e8 b2 ff ff ff       	call   8012d4 <syscall>
  801322:	83 c4 18             	add    $0x18,%esp
}
  801325:	90                   	nop
  801326:	c9                   	leave  
  801327:	c3                   	ret    

00801328 <sys_cgetc>:

int
sys_cgetc(void)
{
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80132b:	6a 00                	push   $0x0
  80132d:	6a 00                	push   $0x0
  80132f:	6a 00                	push   $0x0
  801331:	6a 00                	push   $0x0
  801333:	6a 00                	push   $0x0
  801335:	6a 02                	push   $0x2
  801337:	e8 98 ff ff ff       	call   8012d4 <syscall>
  80133c:	83 c4 18             	add    $0x18,%esp
}
  80133f:	c9                   	leave  
  801340:	c3                   	ret    

00801341 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801344:	6a 00                	push   $0x0
  801346:	6a 00                	push   $0x0
  801348:	6a 00                	push   $0x0
  80134a:	6a 00                	push   $0x0
  80134c:	6a 00                	push   $0x0
  80134e:	6a 03                	push   $0x3
  801350:	e8 7f ff ff ff       	call   8012d4 <syscall>
  801355:	83 c4 18             	add    $0x18,%esp
}
  801358:	90                   	nop
  801359:	c9                   	leave  
  80135a:	c3                   	ret    

0080135b <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	6a 00                	push   $0x0
  801364:	6a 00                	push   $0x0
  801366:	6a 00                	push   $0x0
  801368:	6a 04                	push   $0x4
  80136a:	e8 65 ff ff ff       	call   8012d4 <syscall>
  80136f:	83 c4 18             	add    $0x18,%esp
}
  801372:	90                   	nop
  801373:	c9                   	leave  
  801374:	c3                   	ret    

00801375 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801378:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	6a 00                	push   $0x0
  801380:	6a 00                	push   $0x0
  801382:	6a 00                	push   $0x0
  801384:	52                   	push   %edx
  801385:	50                   	push   %eax
  801386:	6a 08                	push   $0x8
  801388:	e8 47 ff ff ff       	call   8012d4 <syscall>
  80138d:	83 c4 18             	add    $0x18,%esp
}
  801390:	c9                   	leave  
  801391:	c3                   	ret    

00801392 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801392:	55                   	push   %ebp
  801393:	89 e5                	mov    %esp,%ebp
  801395:	56                   	push   %esi
  801396:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801397:	8b 75 18             	mov    0x18(%ebp),%esi
  80139a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80139d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	56                   	push   %esi
  8013a7:	53                   	push   %ebx
  8013a8:	51                   	push   %ecx
  8013a9:	52                   	push   %edx
  8013aa:	50                   	push   %eax
  8013ab:	6a 09                	push   $0x9
  8013ad:	e8 22 ff ff ff       	call   8012d4 <syscall>
  8013b2:	83 c4 18             	add    $0x18,%esp
}
  8013b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013b8:	5b                   	pop    %ebx
  8013b9:	5e                   	pop    %esi
  8013ba:	5d                   	pop    %ebp
  8013bb:	c3                   	ret    

008013bc <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	52                   	push   %edx
  8013cc:	50                   	push   %eax
  8013cd:	6a 0a                	push   $0xa
  8013cf:	e8 00 ff ff ff       	call   8012d4 <syscall>
  8013d4:	83 c4 18             	add    $0x18,%esp
}
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	ff 75 0c             	pushl  0xc(%ebp)
  8013e5:	ff 75 08             	pushl  0x8(%ebp)
  8013e8:	6a 0b                	push   $0xb
  8013ea:	e8 e5 fe ff ff       	call   8012d4 <syscall>
  8013ef:	83 c4 18             	add    $0x18,%esp
}
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    

008013f4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	6a 0c                	push   $0xc
  801403:	e8 cc fe ff ff       	call   8012d4 <syscall>
  801408:	83 c4 18             	add    $0x18,%esp
}
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 0d                	push   $0xd
  80141c:	e8 b3 fe ff ff       	call   8012d4 <syscall>
  801421:	83 c4 18             	add    $0x18,%esp
}
  801424:	c9                   	leave  
  801425:	c3                   	ret    

00801426 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	6a 0e                	push   $0xe
  801435:	e8 9a fe ff ff       	call   8012d4 <syscall>
  80143a:	83 c4 18             	add    $0x18,%esp
}
  80143d:	c9                   	leave  
  80143e:	c3                   	ret    

0080143f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	6a 0f                	push   $0xf
  80144e:	e8 81 fe ff ff       	call   8012d4 <syscall>
  801453:	83 c4 18             	add    $0x18,%esp
}
  801456:	c9                   	leave  
  801457:	c3                   	ret    

00801458 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	6a 00                	push   $0x0
  801463:	ff 75 08             	pushl  0x8(%ebp)
  801466:	6a 10                	push   $0x10
  801468:	e8 67 fe ff ff       	call   8012d4 <syscall>
  80146d:	83 c4 18             	add    $0x18,%esp
}
  801470:	c9                   	leave  
  801471:	c3                   	ret    

00801472 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801475:	6a 00                	push   $0x0
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	6a 00                	push   $0x0
  80147f:	6a 11                	push   $0x11
  801481:	e8 4e fe ff ff       	call   8012d4 <syscall>
  801486:	83 c4 18             	add    $0x18,%esp
}
  801489:	90                   	nop
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <sys_cputc>:

void
sys_cputc(const char c)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	83 ec 04             	sub    $0x4,%esp
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801498:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	50                   	push   %eax
  8014a5:	6a 01                	push   $0x1
  8014a7:	e8 28 fe ff ff       	call   8012d4 <syscall>
  8014ac:	83 c4 18             	add    $0x18,%esp
}
  8014af:	90                   	nop
  8014b0:	c9                   	leave  
  8014b1:	c3                   	ret    

008014b2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014b2:	55                   	push   %ebp
  8014b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 14                	push   $0x14
  8014c1:	e8 0e fe ff ff       	call   8012d4 <syscall>
  8014c6:	83 c4 18             	add    $0x18,%esp
}
  8014c9:	90                   	nop
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	83 ec 04             	sub    $0x4,%esp
  8014d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014d8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014db:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014df:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e2:	6a 00                	push   $0x0
  8014e4:	51                   	push   %ecx
  8014e5:	52                   	push   %edx
  8014e6:	ff 75 0c             	pushl  0xc(%ebp)
  8014e9:	50                   	push   %eax
  8014ea:	6a 15                	push   $0x15
  8014ec:	e8 e3 fd ff ff       	call   8012d4 <syscall>
  8014f1:	83 c4 18             	add    $0x18,%esp
}
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	52                   	push   %edx
  801506:	50                   	push   %eax
  801507:	6a 16                	push   $0x16
  801509:	e8 c6 fd ff ff       	call   8012d4 <syscall>
  80150e:	83 c4 18             	add    $0x18,%esp
}
  801511:	c9                   	leave  
  801512:	c3                   	ret    

00801513 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801516:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801519:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	51                   	push   %ecx
  801524:	52                   	push   %edx
  801525:	50                   	push   %eax
  801526:	6a 17                	push   $0x17
  801528:	e8 a7 fd ff ff       	call   8012d4 <syscall>
  80152d:	83 c4 18             	add    $0x18,%esp
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801535:	8b 55 0c             	mov    0xc(%ebp),%edx
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	52                   	push   %edx
  801542:	50                   	push   %eax
  801543:	6a 18                	push   $0x18
  801545:	e8 8a fd ff ff       	call   8012d4 <syscall>
  80154a:	83 c4 18             	add    $0x18,%esp
}
  80154d:	c9                   	leave  
  80154e:	c3                   	ret    

0080154f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801552:	8b 45 08             	mov    0x8(%ebp),%eax
  801555:	6a 00                	push   $0x0
  801557:	ff 75 14             	pushl  0x14(%ebp)
  80155a:	ff 75 10             	pushl  0x10(%ebp)
  80155d:	ff 75 0c             	pushl  0xc(%ebp)
  801560:	50                   	push   %eax
  801561:	6a 19                	push   $0x19
  801563:	e8 6c fd ff ff       	call   8012d4 <syscall>
  801568:	83 c4 18             	add    $0x18,%esp
}
  80156b:	c9                   	leave  
  80156c:	c3                   	ret    

0080156d <sys_run_env>:

void sys_run_env(int32 envId)
{
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	50                   	push   %eax
  80157c:	6a 1a                	push   $0x1a
  80157e:	e8 51 fd ff ff       	call   8012d4 <syscall>
  801583:	83 c4 18             	add    $0x18,%esp
}
  801586:	90                   	nop
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	50                   	push   %eax
  801598:	6a 1b                	push   $0x1b
  80159a:	e8 35 fd ff ff       	call   8012d4 <syscall>
  80159f:	83 c4 18             	add    $0x18,%esp
}
  8015a2:	c9                   	leave  
  8015a3:	c3                   	ret    

008015a4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 05                	push   $0x5
  8015b3:	e8 1c fd ff ff       	call   8012d4 <syscall>
  8015b8:	83 c4 18             	add    $0x18,%esp
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 06                	push   $0x6
  8015cc:	e8 03 fd ff ff       	call   8012d4 <syscall>
  8015d1:	83 c4 18             	add    $0x18,%esp
}
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 07                	push   $0x7
  8015e5:	e8 ea fc ff ff       	call   8012d4 <syscall>
  8015ea:	83 c4 18             	add    $0x18,%esp
}
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    

008015ef <sys_exit_env>:


void sys_exit_env(void)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 1c                	push   $0x1c
  8015fe:	e8 d1 fc ff ff       	call   8012d4 <syscall>
  801603:	83 c4 18             	add    $0x18,%esp
}
  801606:	90                   	nop
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80160f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801612:	8d 50 04             	lea    0x4(%eax),%edx
  801615:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	52                   	push   %edx
  80161f:	50                   	push   %eax
  801620:	6a 1d                	push   $0x1d
  801622:	e8 ad fc ff ff       	call   8012d4 <syscall>
  801627:	83 c4 18             	add    $0x18,%esp
	return result;
  80162a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80162d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801630:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801633:	89 01                	mov    %eax,(%ecx)
  801635:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801638:	8b 45 08             	mov    0x8(%ebp),%eax
  80163b:	c9                   	leave  
  80163c:	c2 04 00             	ret    $0x4

0080163f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	ff 75 10             	pushl  0x10(%ebp)
  801649:	ff 75 0c             	pushl  0xc(%ebp)
  80164c:	ff 75 08             	pushl  0x8(%ebp)
  80164f:	6a 13                	push   $0x13
  801651:	e8 7e fc ff ff       	call   8012d4 <syscall>
  801656:	83 c4 18             	add    $0x18,%esp
	return ;
  801659:	90                   	nop
}
  80165a:	c9                   	leave  
  80165b:	c3                   	ret    

0080165c <sys_rcr2>:
uint32 sys_rcr2()
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 1e                	push   $0x1e
  80166b:	e8 64 fc ff ff       	call   8012d4 <syscall>
  801670:	83 c4 18             	add    $0x18,%esp
}
  801673:	c9                   	leave  
  801674:	c3                   	ret    

00801675 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	83 ec 04             	sub    $0x4,%esp
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801681:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	50                   	push   %eax
  80168e:	6a 1f                	push   $0x1f
  801690:	e8 3f fc ff ff       	call   8012d4 <syscall>
  801695:	83 c4 18             	add    $0x18,%esp
	return ;
  801698:	90                   	nop
}
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <rsttst>:
void rsttst()
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 21                	push   $0x21
  8016aa:	e8 25 fc ff ff       	call   8012d4 <syscall>
  8016af:	83 c4 18             	add    $0x18,%esp
	return ;
  8016b2:	90                   	nop
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	83 ec 04             	sub    $0x4,%esp
  8016bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8016be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016c1:	8b 55 18             	mov    0x18(%ebp),%edx
  8016c4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016c8:	52                   	push   %edx
  8016c9:	50                   	push   %eax
  8016ca:	ff 75 10             	pushl  0x10(%ebp)
  8016cd:	ff 75 0c             	pushl  0xc(%ebp)
  8016d0:	ff 75 08             	pushl  0x8(%ebp)
  8016d3:	6a 20                	push   $0x20
  8016d5:	e8 fa fb ff ff       	call   8012d4 <syscall>
  8016da:	83 c4 18             	add    $0x18,%esp
	return ;
  8016dd:	90                   	nop
}
  8016de:	c9                   	leave  
  8016df:	c3                   	ret    

008016e0 <chktst>:
void chktst(uint32 n)
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	ff 75 08             	pushl  0x8(%ebp)
  8016ee:	6a 22                	push   $0x22
  8016f0:	e8 df fb ff ff       	call   8012d4 <syscall>
  8016f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f8:	90                   	nop
}
  8016f9:	c9                   	leave  
  8016fa:	c3                   	ret    

008016fb <inctst>:

void inctst()
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 23                	push   $0x23
  80170a:	e8 c5 fb ff ff       	call   8012d4 <syscall>
  80170f:	83 c4 18             	add    $0x18,%esp
	return ;
  801712:	90                   	nop
}
  801713:	c9                   	leave  
  801714:	c3                   	ret    

00801715 <gettst>:
uint32 gettst()
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 24                	push   $0x24
  801724:	e8 ab fb ff ff       	call   8012d4 <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 25                	push   $0x25
  801740:	e8 8f fb ff ff       	call   8012d4 <syscall>
  801745:	83 c4 18             	add    $0x18,%esp
  801748:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80174b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80174f:	75 07                	jne    801758 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801751:	b8 01 00 00 00       	mov    $0x1,%eax
  801756:	eb 05                	jmp    80175d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801758:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 25                	push   $0x25
  801771:	e8 5e fb ff ff       	call   8012d4 <syscall>
  801776:	83 c4 18             	add    $0x18,%esp
  801779:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80177c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801780:	75 07                	jne    801789 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801782:	b8 01 00 00 00       	mov    $0x1,%eax
  801787:	eb 05                	jmp    80178e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801789:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 25                	push   $0x25
  8017a2:	e8 2d fb ff ff       	call   8012d4 <syscall>
  8017a7:	83 c4 18             	add    $0x18,%esp
  8017aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017ad:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017b1:	75 07                	jne    8017ba <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8017b8:	eb 05                	jmp    8017bf <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 25                	push   $0x25
  8017d3:	e8 fc fa ff ff       	call   8012d4 <syscall>
  8017d8:	83 c4 18             	add    $0x18,%esp
  8017db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017de:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017e2:	75 07                	jne    8017eb <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8017e9:	eb 05                	jmp    8017f0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    

008017f2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	ff 75 08             	pushl  0x8(%ebp)
  801800:	6a 26                	push   $0x26
  801802:	e8 cd fa ff ff       	call   8012d4 <syscall>
  801807:	83 c4 18             	add    $0x18,%esp
	return ;
  80180a:	90                   	nop
}
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801811:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801814:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801817:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181a:	8b 45 08             	mov    0x8(%ebp),%eax
  80181d:	6a 00                	push   $0x0
  80181f:	53                   	push   %ebx
  801820:	51                   	push   %ecx
  801821:	52                   	push   %edx
  801822:	50                   	push   %eax
  801823:	6a 27                	push   $0x27
  801825:	e8 aa fa ff ff       	call   8012d4 <syscall>
  80182a:	83 c4 18             	add    $0x18,%esp
}
  80182d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801835:	8b 55 0c             	mov    0xc(%ebp),%edx
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	52                   	push   %edx
  801842:	50                   	push   %eax
  801843:	6a 28                	push   $0x28
  801845:	e8 8a fa ff ff       	call   8012d4 <syscall>
  80184a:	83 c4 18             	add    $0x18,%esp
}
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801852:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801855:	8b 55 0c             	mov    0xc(%ebp),%edx
  801858:	8b 45 08             	mov    0x8(%ebp),%eax
  80185b:	6a 00                	push   $0x0
  80185d:	51                   	push   %ecx
  80185e:	ff 75 10             	pushl  0x10(%ebp)
  801861:	52                   	push   %edx
  801862:	50                   	push   %eax
  801863:	6a 29                	push   $0x29
  801865:	e8 6a fa ff ff       	call   8012d4 <syscall>
  80186a:	83 c4 18             	add    $0x18,%esp
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	ff 75 10             	pushl  0x10(%ebp)
  801879:	ff 75 0c             	pushl  0xc(%ebp)
  80187c:	ff 75 08             	pushl  0x8(%ebp)
  80187f:	6a 12                	push   $0x12
  801881:	e8 4e fa ff ff       	call   8012d4 <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
	return ;
  801889:	90                   	nop
}
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80188f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801892:	8b 45 08             	mov    0x8(%ebp),%eax
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	52                   	push   %edx
  80189c:	50                   	push   %eax
  80189d:	6a 2a                	push   $0x2a
  80189f:	e8 30 fa ff ff       	call   8012d4 <syscall>
  8018a4:	83 c4 18             	add    $0x18,%esp
	return;
  8018a7:	90                   	nop
}
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8018b0:	83 ec 04             	sub    $0x4,%esp
  8018b3:	68 77 23 80 00       	push   $0x802377
  8018b8:	68 2e 01 00 00       	push   $0x12e
  8018bd:	68 8b 23 80 00       	push   $0x80238b
  8018c2:	e8 b6 e9 ff ff       	call   80027d <_panic>

008018c7 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
  8018ca:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8018cd:	83 ec 04             	sub    $0x4,%esp
  8018d0:	68 77 23 80 00       	push   $0x802377
  8018d5:	68 35 01 00 00       	push   $0x135
  8018da:	68 8b 23 80 00       	push   $0x80238b
  8018df:	e8 99 e9 ff ff       	call   80027d <_panic>

008018e4 <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
  8018e7:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8018ea:	83 ec 04             	sub    $0x4,%esp
  8018ed:	68 77 23 80 00       	push   $0x802377
  8018f2:	68 3b 01 00 00       	push   $0x13b
  8018f7:	68 8b 23 80 00       	push   $0x80238b
  8018fc:	e8 7c e9 ff ff       	call   80027d <_panic>

00801901 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
  801904:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  801907:	83 ec 04             	sub    $0x4,%esp
  80190a:	68 9c 23 80 00       	push   $0x80239c
  80190f:	6a 09                	push   $0x9
  801911:	68 c4 23 80 00       	push   $0x8023c4
  801916:	e8 62 e9 ff ff       	call   80027d <_panic>

0080191b <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  801921:	83 ec 04             	sub    $0x4,%esp
  801924:	68 d4 23 80 00       	push   $0x8023d4
  801929:	6a 10                	push   $0x10
  80192b:	68 c4 23 80 00       	push   $0x8023c4
  801930:	e8 48 e9 ff ff       	call   80027d <_panic>

00801935 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  80193b:	83 ec 04             	sub    $0x4,%esp
  80193e:	68 fc 23 80 00       	push   $0x8023fc
  801943:	6a 18                	push   $0x18
  801945:	68 c4 23 80 00       	push   $0x8023c4
  80194a:	e8 2e e9 ff ff       	call   80027d <_panic>

0080194f <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
  801952:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  801955:	83 ec 04             	sub    $0x4,%esp
  801958:	68 24 24 80 00       	push   $0x802424
  80195d:	6a 20                	push   $0x20
  80195f:	68 c4 23 80 00       	push   $0x8023c4
  801964:	e8 14 e9 ff ff       	call   80027d <_panic>

00801969 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	8b 40 10             	mov    0x10(%eax),%eax
}
  801972:	5d                   	pop    %ebp
  801973:	c3                   	ret    

00801974 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
  801977:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80197a:	8b 55 08             	mov    0x8(%ebp),%edx
  80197d:	89 d0                	mov    %edx,%eax
  80197f:	c1 e0 02             	shl    $0x2,%eax
  801982:	01 d0                	add    %edx,%eax
  801984:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80198b:	01 d0                	add    %edx,%eax
  80198d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801994:	01 d0                	add    %edx,%eax
  801996:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80199d:	01 d0                	add    %edx,%eax
  80199f:	c1 e0 04             	shl    $0x4,%eax
  8019a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8019a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8019ac:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8019af:	83 ec 0c             	sub    $0xc,%esp
  8019b2:	50                   	push   %eax
  8019b3:	e8 51 fc ff ff       	call   801609 <sys_get_virtual_time>
  8019b8:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8019bb:	eb 41                	jmp    8019fe <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8019bd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019c0:	83 ec 0c             	sub    $0xc,%esp
  8019c3:	50                   	push   %eax
  8019c4:	e8 40 fc ff ff       	call   801609 <sys_get_virtual_time>
  8019c9:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8019cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019d2:	29 c2                	sub    %eax,%edx
  8019d4:	89 d0                	mov    %edx,%eax
  8019d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8019d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019df:	89 d1                	mov    %edx,%ecx
  8019e1:	29 c1                	sub    %eax,%ecx
  8019e3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019e9:	39 c2                	cmp    %eax,%edx
  8019eb:	0f 97 c0             	seta   %al
  8019ee:	0f b6 c0             	movzbl %al,%eax
  8019f1:	29 c1                	sub    %eax,%ecx
  8019f3:	89 c8                	mov    %ecx,%eax
  8019f5:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8019f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8019fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a01:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a04:	72 b7                	jb     8019bd <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801a06:	90                   	nop
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801a0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801a16:	eb 03                	jmp    801a1b <busy_wait+0x12>
  801a18:	ff 45 fc             	incl   -0x4(%ebp)
  801a1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a1e:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a21:	72 f5                	jb     801a18 <busy_wait+0xf>
	return i;
  801a23:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <__udivdi3>:
  801a28:	55                   	push   %ebp
  801a29:	57                   	push   %edi
  801a2a:	56                   	push   %esi
  801a2b:	53                   	push   %ebx
  801a2c:	83 ec 1c             	sub    $0x1c,%esp
  801a2f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a33:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a3b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a3f:	89 ca                	mov    %ecx,%edx
  801a41:	89 f8                	mov    %edi,%eax
  801a43:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a47:	85 f6                	test   %esi,%esi
  801a49:	75 2d                	jne    801a78 <__udivdi3+0x50>
  801a4b:	39 cf                	cmp    %ecx,%edi
  801a4d:	77 65                	ja     801ab4 <__udivdi3+0x8c>
  801a4f:	89 fd                	mov    %edi,%ebp
  801a51:	85 ff                	test   %edi,%edi
  801a53:	75 0b                	jne    801a60 <__udivdi3+0x38>
  801a55:	b8 01 00 00 00       	mov    $0x1,%eax
  801a5a:	31 d2                	xor    %edx,%edx
  801a5c:	f7 f7                	div    %edi
  801a5e:	89 c5                	mov    %eax,%ebp
  801a60:	31 d2                	xor    %edx,%edx
  801a62:	89 c8                	mov    %ecx,%eax
  801a64:	f7 f5                	div    %ebp
  801a66:	89 c1                	mov    %eax,%ecx
  801a68:	89 d8                	mov    %ebx,%eax
  801a6a:	f7 f5                	div    %ebp
  801a6c:	89 cf                	mov    %ecx,%edi
  801a6e:	89 fa                	mov    %edi,%edx
  801a70:	83 c4 1c             	add    $0x1c,%esp
  801a73:	5b                   	pop    %ebx
  801a74:	5e                   	pop    %esi
  801a75:	5f                   	pop    %edi
  801a76:	5d                   	pop    %ebp
  801a77:	c3                   	ret    
  801a78:	39 ce                	cmp    %ecx,%esi
  801a7a:	77 28                	ja     801aa4 <__udivdi3+0x7c>
  801a7c:	0f bd fe             	bsr    %esi,%edi
  801a7f:	83 f7 1f             	xor    $0x1f,%edi
  801a82:	75 40                	jne    801ac4 <__udivdi3+0x9c>
  801a84:	39 ce                	cmp    %ecx,%esi
  801a86:	72 0a                	jb     801a92 <__udivdi3+0x6a>
  801a88:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a8c:	0f 87 9e 00 00 00    	ja     801b30 <__udivdi3+0x108>
  801a92:	b8 01 00 00 00       	mov    $0x1,%eax
  801a97:	89 fa                	mov    %edi,%edx
  801a99:	83 c4 1c             	add    $0x1c,%esp
  801a9c:	5b                   	pop    %ebx
  801a9d:	5e                   	pop    %esi
  801a9e:	5f                   	pop    %edi
  801a9f:	5d                   	pop    %ebp
  801aa0:	c3                   	ret    
  801aa1:	8d 76 00             	lea    0x0(%esi),%esi
  801aa4:	31 ff                	xor    %edi,%edi
  801aa6:	31 c0                	xor    %eax,%eax
  801aa8:	89 fa                	mov    %edi,%edx
  801aaa:	83 c4 1c             	add    $0x1c,%esp
  801aad:	5b                   	pop    %ebx
  801aae:	5e                   	pop    %esi
  801aaf:	5f                   	pop    %edi
  801ab0:	5d                   	pop    %ebp
  801ab1:	c3                   	ret    
  801ab2:	66 90                	xchg   %ax,%ax
  801ab4:	89 d8                	mov    %ebx,%eax
  801ab6:	f7 f7                	div    %edi
  801ab8:	31 ff                	xor    %edi,%edi
  801aba:	89 fa                	mov    %edi,%edx
  801abc:	83 c4 1c             	add    $0x1c,%esp
  801abf:	5b                   	pop    %ebx
  801ac0:	5e                   	pop    %esi
  801ac1:	5f                   	pop    %edi
  801ac2:	5d                   	pop    %ebp
  801ac3:	c3                   	ret    
  801ac4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ac9:	89 eb                	mov    %ebp,%ebx
  801acb:	29 fb                	sub    %edi,%ebx
  801acd:	89 f9                	mov    %edi,%ecx
  801acf:	d3 e6                	shl    %cl,%esi
  801ad1:	89 c5                	mov    %eax,%ebp
  801ad3:	88 d9                	mov    %bl,%cl
  801ad5:	d3 ed                	shr    %cl,%ebp
  801ad7:	89 e9                	mov    %ebp,%ecx
  801ad9:	09 f1                	or     %esi,%ecx
  801adb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801adf:	89 f9                	mov    %edi,%ecx
  801ae1:	d3 e0                	shl    %cl,%eax
  801ae3:	89 c5                	mov    %eax,%ebp
  801ae5:	89 d6                	mov    %edx,%esi
  801ae7:	88 d9                	mov    %bl,%cl
  801ae9:	d3 ee                	shr    %cl,%esi
  801aeb:	89 f9                	mov    %edi,%ecx
  801aed:	d3 e2                	shl    %cl,%edx
  801aef:	8b 44 24 08          	mov    0x8(%esp),%eax
  801af3:	88 d9                	mov    %bl,%cl
  801af5:	d3 e8                	shr    %cl,%eax
  801af7:	09 c2                	or     %eax,%edx
  801af9:	89 d0                	mov    %edx,%eax
  801afb:	89 f2                	mov    %esi,%edx
  801afd:	f7 74 24 0c          	divl   0xc(%esp)
  801b01:	89 d6                	mov    %edx,%esi
  801b03:	89 c3                	mov    %eax,%ebx
  801b05:	f7 e5                	mul    %ebp
  801b07:	39 d6                	cmp    %edx,%esi
  801b09:	72 19                	jb     801b24 <__udivdi3+0xfc>
  801b0b:	74 0b                	je     801b18 <__udivdi3+0xf0>
  801b0d:	89 d8                	mov    %ebx,%eax
  801b0f:	31 ff                	xor    %edi,%edi
  801b11:	e9 58 ff ff ff       	jmp    801a6e <__udivdi3+0x46>
  801b16:	66 90                	xchg   %ax,%ax
  801b18:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b1c:	89 f9                	mov    %edi,%ecx
  801b1e:	d3 e2                	shl    %cl,%edx
  801b20:	39 c2                	cmp    %eax,%edx
  801b22:	73 e9                	jae    801b0d <__udivdi3+0xe5>
  801b24:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b27:	31 ff                	xor    %edi,%edi
  801b29:	e9 40 ff ff ff       	jmp    801a6e <__udivdi3+0x46>
  801b2e:	66 90                	xchg   %ax,%ax
  801b30:	31 c0                	xor    %eax,%eax
  801b32:	e9 37 ff ff ff       	jmp    801a6e <__udivdi3+0x46>
  801b37:	90                   	nop

00801b38 <__umoddi3>:
  801b38:	55                   	push   %ebp
  801b39:	57                   	push   %edi
  801b3a:	56                   	push   %esi
  801b3b:	53                   	push   %ebx
  801b3c:	83 ec 1c             	sub    $0x1c,%esp
  801b3f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b43:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b47:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b4b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b53:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b57:	89 f3                	mov    %esi,%ebx
  801b59:	89 fa                	mov    %edi,%edx
  801b5b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b5f:	89 34 24             	mov    %esi,(%esp)
  801b62:	85 c0                	test   %eax,%eax
  801b64:	75 1a                	jne    801b80 <__umoddi3+0x48>
  801b66:	39 f7                	cmp    %esi,%edi
  801b68:	0f 86 a2 00 00 00    	jbe    801c10 <__umoddi3+0xd8>
  801b6e:	89 c8                	mov    %ecx,%eax
  801b70:	89 f2                	mov    %esi,%edx
  801b72:	f7 f7                	div    %edi
  801b74:	89 d0                	mov    %edx,%eax
  801b76:	31 d2                	xor    %edx,%edx
  801b78:	83 c4 1c             	add    $0x1c,%esp
  801b7b:	5b                   	pop    %ebx
  801b7c:	5e                   	pop    %esi
  801b7d:	5f                   	pop    %edi
  801b7e:	5d                   	pop    %ebp
  801b7f:	c3                   	ret    
  801b80:	39 f0                	cmp    %esi,%eax
  801b82:	0f 87 ac 00 00 00    	ja     801c34 <__umoddi3+0xfc>
  801b88:	0f bd e8             	bsr    %eax,%ebp
  801b8b:	83 f5 1f             	xor    $0x1f,%ebp
  801b8e:	0f 84 ac 00 00 00    	je     801c40 <__umoddi3+0x108>
  801b94:	bf 20 00 00 00       	mov    $0x20,%edi
  801b99:	29 ef                	sub    %ebp,%edi
  801b9b:	89 fe                	mov    %edi,%esi
  801b9d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ba1:	89 e9                	mov    %ebp,%ecx
  801ba3:	d3 e0                	shl    %cl,%eax
  801ba5:	89 d7                	mov    %edx,%edi
  801ba7:	89 f1                	mov    %esi,%ecx
  801ba9:	d3 ef                	shr    %cl,%edi
  801bab:	09 c7                	or     %eax,%edi
  801bad:	89 e9                	mov    %ebp,%ecx
  801baf:	d3 e2                	shl    %cl,%edx
  801bb1:	89 14 24             	mov    %edx,(%esp)
  801bb4:	89 d8                	mov    %ebx,%eax
  801bb6:	d3 e0                	shl    %cl,%eax
  801bb8:	89 c2                	mov    %eax,%edx
  801bba:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bbe:	d3 e0                	shl    %cl,%eax
  801bc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bc8:	89 f1                	mov    %esi,%ecx
  801bca:	d3 e8                	shr    %cl,%eax
  801bcc:	09 d0                	or     %edx,%eax
  801bce:	d3 eb                	shr    %cl,%ebx
  801bd0:	89 da                	mov    %ebx,%edx
  801bd2:	f7 f7                	div    %edi
  801bd4:	89 d3                	mov    %edx,%ebx
  801bd6:	f7 24 24             	mull   (%esp)
  801bd9:	89 c6                	mov    %eax,%esi
  801bdb:	89 d1                	mov    %edx,%ecx
  801bdd:	39 d3                	cmp    %edx,%ebx
  801bdf:	0f 82 87 00 00 00    	jb     801c6c <__umoddi3+0x134>
  801be5:	0f 84 91 00 00 00    	je     801c7c <__umoddi3+0x144>
  801beb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bef:	29 f2                	sub    %esi,%edx
  801bf1:	19 cb                	sbb    %ecx,%ebx
  801bf3:	89 d8                	mov    %ebx,%eax
  801bf5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bf9:	d3 e0                	shl    %cl,%eax
  801bfb:	89 e9                	mov    %ebp,%ecx
  801bfd:	d3 ea                	shr    %cl,%edx
  801bff:	09 d0                	or     %edx,%eax
  801c01:	89 e9                	mov    %ebp,%ecx
  801c03:	d3 eb                	shr    %cl,%ebx
  801c05:	89 da                	mov    %ebx,%edx
  801c07:	83 c4 1c             	add    $0x1c,%esp
  801c0a:	5b                   	pop    %ebx
  801c0b:	5e                   	pop    %esi
  801c0c:	5f                   	pop    %edi
  801c0d:	5d                   	pop    %ebp
  801c0e:	c3                   	ret    
  801c0f:	90                   	nop
  801c10:	89 fd                	mov    %edi,%ebp
  801c12:	85 ff                	test   %edi,%edi
  801c14:	75 0b                	jne    801c21 <__umoddi3+0xe9>
  801c16:	b8 01 00 00 00       	mov    $0x1,%eax
  801c1b:	31 d2                	xor    %edx,%edx
  801c1d:	f7 f7                	div    %edi
  801c1f:	89 c5                	mov    %eax,%ebp
  801c21:	89 f0                	mov    %esi,%eax
  801c23:	31 d2                	xor    %edx,%edx
  801c25:	f7 f5                	div    %ebp
  801c27:	89 c8                	mov    %ecx,%eax
  801c29:	f7 f5                	div    %ebp
  801c2b:	89 d0                	mov    %edx,%eax
  801c2d:	e9 44 ff ff ff       	jmp    801b76 <__umoddi3+0x3e>
  801c32:	66 90                	xchg   %ax,%ax
  801c34:	89 c8                	mov    %ecx,%eax
  801c36:	89 f2                	mov    %esi,%edx
  801c38:	83 c4 1c             	add    $0x1c,%esp
  801c3b:	5b                   	pop    %ebx
  801c3c:	5e                   	pop    %esi
  801c3d:	5f                   	pop    %edi
  801c3e:	5d                   	pop    %ebp
  801c3f:	c3                   	ret    
  801c40:	3b 04 24             	cmp    (%esp),%eax
  801c43:	72 06                	jb     801c4b <__umoddi3+0x113>
  801c45:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c49:	77 0f                	ja     801c5a <__umoddi3+0x122>
  801c4b:	89 f2                	mov    %esi,%edx
  801c4d:	29 f9                	sub    %edi,%ecx
  801c4f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c53:	89 14 24             	mov    %edx,(%esp)
  801c56:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c5a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c5e:	8b 14 24             	mov    (%esp),%edx
  801c61:	83 c4 1c             	add    $0x1c,%esp
  801c64:	5b                   	pop    %ebx
  801c65:	5e                   	pop    %esi
  801c66:	5f                   	pop    %edi
  801c67:	5d                   	pop    %ebp
  801c68:	c3                   	ret    
  801c69:	8d 76 00             	lea    0x0(%esi),%esi
  801c6c:	2b 04 24             	sub    (%esp),%eax
  801c6f:	19 fa                	sbb    %edi,%edx
  801c71:	89 d1                	mov    %edx,%ecx
  801c73:	89 c6                	mov    %eax,%esi
  801c75:	e9 71 ff ff ff       	jmp    801beb <__umoddi3+0xb3>
  801c7a:	66 90                	xchg   %ax,%ax
  801c7c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c80:	72 ea                	jb     801c6c <__umoddi3+0x134>
  801c82:	89 d9                	mov    %ebx,%ecx
  801c84:	e9 62 ff ff ff       	jmp    801beb <__umoddi3+0xb3>
