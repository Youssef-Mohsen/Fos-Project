
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
  80003e:	e8 85 15 00 00       	call   8015c8 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int id = sys_getenvindex();
  800046:	e8 64 15 00 00       	call   8015af <sys_getenvindex>
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	struct semaphore cs1 = get_semaphore(parentenvID, "cs1");
  80004e:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	68 00 3e 80 00       	push   $0x803e00
  800059:	ff 75 f4             	pushl  -0xc(%ebp)
  80005c:	50                   	push   %eax
  80005d:	e8 9d 19 00 00       	call   8019ff <get_semaphore>
  800062:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = get_semaphore(parentenvID, "depend1");
  800065:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	68 04 3e 80 00       	push   $0x803e04
  800070:	ff 75 f4             	pushl  -0xc(%ebp)
  800073:	50                   	push   %eax
  800074:	e8 86 19 00 00       	call   8019ff <get_semaphore>
  800079:	83 c4 0c             	add    $0xc,%esp

	cprintf("%d: before the critical section\n", id);
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	ff 75 f0             	pushl  -0x10(%ebp)
  800082:	68 0c 3e 80 00       	push   $0x803e0c
  800087:	e8 a0 04 00 00       	call   80052c <cprintf>
  80008c:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(cs1);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	ff 75 e8             	pushl  -0x18(%ebp)
  800095:	e8 b0 19 00 00       	call   801a4a <wait_semaphore>
  80009a:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("%d: inside the critical section\n", id) ;
  80009d:	83 ec 08             	sub    $0x8,%esp
  8000a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000a3:	68 30 3e 80 00       	push   $0x803e30
  8000a8:	e8 7f 04 00 00       	call   80052c <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp
		cprintf("my ID is %d\n", id);
  8000b0:	83 ec 08             	sub    $0x8,%esp
  8000b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b6:	68 51 3e 80 00       	push   $0x803e51
  8000bb:	e8 6c 04 00 00       	call   80052c <cprintf>
  8000c0:	83 c4 10             	add    $0x10,%esp
		int sem1val = semaphore_count(cs1);
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000c9:	e8 70 1a 00 00       	call   801b3e <semaphore_count>
  8000ce:	83 c4 10             	add    $0x10,%esp
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (sem1val > 0)
  8000d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8000d8:	7e 14                	jle    8000ee <_main+0xb6>
			panic("Error: more than 1 process inside the CS... please review your semaphore code again...");
  8000da:	83 ec 04             	sub    $0x4,%esp
  8000dd:	68 60 3e 80 00       	push   $0x803e60
  8000e2:	6a 15                	push   $0x15
  8000e4:	68 b7 3e 80 00       	push   $0x803eb7
  8000e9:	e8 81 01 00 00       	call   80026f <_panic>
		env_sleep(1000) ;
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	68 e8 03 00 00       	push   $0x3e8
  8000f6:	e8 4e 1a 00 00       	call   801b49 <env_sleep>
  8000fb:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cs1);
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	ff 75 e8             	pushl  -0x18(%ebp)
  800104:	e8 c3 19 00 00       	call   801acc <signal_semaphore>
  800109:	83 c4 10             	add    $0x10,%esp
	cprintf("%d: after the critical section\n", id);
  80010c:	83 ec 08             	sub    $0x8,%esp
  80010f:	ff 75 f0             	pushl  -0x10(%ebp)
  800112:	68 d4 3e 80 00       	push   $0x803ed4
  800117:	e8 10 04 00 00       	call   80052c <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp

	signal_semaphore(depend1);
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	ff 75 e4             	pushl  -0x1c(%ebp)
  800125:	e8 a2 19 00 00       	call   801acc <signal_semaphore>
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
  800136:	e8 74 14 00 00       	call   8015af <sys_getenvindex>
  80013b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80013e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800141:	89 d0                	mov    %edx,%eax
  800143:	c1 e0 03             	shl    $0x3,%eax
  800146:	01 d0                	add    %edx,%eax
  800148:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80014f:	01 c8                	add    %ecx,%eax
  800151:	01 c0                	add    %eax,%eax
  800153:	01 d0                	add    %edx,%eax
  800155:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80015c:	01 c8                	add    %ecx,%eax
  80015e:	01 d0                	add    %edx,%eax
  800160:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800165:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016a:	a1 20 50 80 00       	mov    0x805020,%eax
  80016f:	8a 40 20             	mov    0x20(%eax),%al
  800172:	84 c0                	test   %al,%al
  800174:	74 0d                	je     800183 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800176:	a1 20 50 80 00       	mov    0x805020,%eax
  80017b:	83 c0 20             	add    $0x20,%eax
  80017e:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800183:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800187:	7e 0a                	jle    800193 <libmain+0x63>
		binaryname = argv[0];
  800189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018c:	8b 00                	mov    (%eax),%eax
  80018e:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800193:	83 ec 08             	sub    $0x8,%esp
  800196:	ff 75 0c             	pushl  0xc(%ebp)
  800199:	ff 75 08             	pushl  0x8(%ebp)
  80019c:	e8 97 fe ff ff       	call   800038 <_main>
  8001a1:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8001a4:	e8 8a 11 00 00       	call   801333 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001a9:	83 ec 0c             	sub    $0xc,%esp
  8001ac:	68 0c 3f 80 00       	push   $0x803f0c
  8001b1:	e8 76 03 00 00       	call   80052c <cprintf>
  8001b6:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001b9:	a1 20 50 80 00       	mov    0x805020,%eax
  8001be:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8001c4:	a1 20 50 80 00       	mov    0x805020,%eax
  8001c9:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8001cf:	83 ec 04             	sub    $0x4,%esp
  8001d2:	52                   	push   %edx
  8001d3:	50                   	push   %eax
  8001d4:	68 34 3f 80 00       	push   $0x803f34
  8001d9:	e8 4e 03 00 00       	call   80052c <cprintf>
  8001de:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8001e6:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8001ec:	a1 20 50 80 00       	mov    0x805020,%eax
  8001f1:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8001f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8001fc:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800202:	51                   	push   %ecx
  800203:	52                   	push   %edx
  800204:	50                   	push   %eax
  800205:	68 5c 3f 80 00       	push   $0x803f5c
  80020a:	e8 1d 03 00 00       	call   80052c <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800212:	a1 20 50 80 00       	mov    0x805020,%eax
  800217:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	50                   	push   %eax
  800221:	68 b4 3f 80 00       	push   $0x803fb4
  800226:	e8 01 03 00 00       	call   80052c <cprintf>
  80022b:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80022e:	83 ec 0c             	sub    $0xc,%esp
  800231:	68 0c 3f 80 00       	push   $0x803f0c
  800236:	e8 f1 02 00 00       	call   80052c <cprintf>
  80023b:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80023e:	e8 0a 11 00 00       	call   80134d <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800243:	e8 19 00 00 00       	call   800261 <exit>
}
  800248:	90                   	nop
  800249:	c9                   	leave  
  80024a:	c3                   	ret    

0080024b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80024b:	55                   	push   %ebp
  80024c:	89 e5                	mov    %esp,%ebp
  80024e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800251:	83 ec 0c             	sub    $0xc,%esp
  800254:	6a 00                	push   $0x0
  800256:	e8 20 13 00 00       	call   80157b <sys_destroy_env>
  80025b:	83 c4 10             	add    $0x10,%esp
}
  80025e:	90                   	nop
  80025f:	c9                   	leave  
  800260:	c3                   	ret    

00800261 <exit>:

void
exit(void)
{
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800267:	e8 75 13 00 00       	call   8015e1 <sys_exit_env>
}
  80026c:	90                   	nop
  80026d:	c9                   	leave  
  80026e:	c3                   	ret    

0080026f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800275:	8d 45 10             	lea    0x10(%ebp),%eax
  800278:	83 c0 04             	add    $0x4,%eax
  80027b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80027e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800283:	85 c0                	test   %eax,%eax
  800285:	74 16                	je     80029d <_panic+0x2e>
		cprintf("%s: ", argv0);
  800287:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80028c:	83 ec 08             	sub    $0x8,%esp
  80028f:	50                   	push   %eax
  800290:	68 c8 3f 80 00       	push   $0x803fc8
  800295:	e8 92 02 00 00       	call   80052c <cprintf>
  80029a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80029d:	a1 00 50 80 00       	mov    0x805000,%eax
  8002a2:	ff 75 0c             	pushl  0xc(%ebp)
  8002a5:	ff 75 08             	pushl  0x8(%ebp)
  8002a8:	50                   	push   %eax
  8002a9:	68 cd 3f 80 00       	push   $0x803fcd
  8002ae:	e8 79 02 00 00       	call   80052c <cprintf>
  8002b3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b9:	83 ec 08             	sub    $0x8,%esp
  8002bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8002bf:	50                   	push   %eax
  8002c0:	e8 fc 01 00 00       	call   8004c1 <vcprintf>
  8002c5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002c8:	83 ec 08             	sub    $0x8,%esp
  8002cb:	6a 00                	push   $0x0
  8002cd:	68 e9 3f 80 00       	push   $0x803fe9
  8002d2:	e8 ea 01 00 00       	call   8004c1 <vcprintf>
  8002d7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002da:	e8 82 ff ff ff       	call   800261 <exit>

	// should not return here
	while (1) ;
  8002df:	eb fe                	jmp    8002df <_panic+0x70>

008002e1 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002e1:	55                   	push   %ebp
  8002e2:	89 e5                	mov    %esp,%ebp
  8002e4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ec:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8002f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f5:	39 c2                	cmp    %eax,%edx
  8002f7:	74 14                	je     80030d <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002f9:	83 ec 04             	sub    $0x4,%esp
  8002fc:	68 ec 3f 80 00       	push   $0x803fec
  800301:	6a 26                	push   $0x26
  800303:	68 38 40 80 00       	push   $0x804038
  800308:	e8 62 ff ff ff       	call   80026f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80030d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800314:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80031b:	e9 c5 00 00 00       	jmp    8003e5 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800320:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800323:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	85 c0                	test   %eax,%eax
  800333:	75 08                	jne    80033d <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800335:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800338:	e9 a5 00 00 00       	jmp    8003e2 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80033d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800344:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80034b:	eb 69                	jmp    8003b6 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80034d:	a1 20 50 80 00       	mov    0x805020,%eax
  800352:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800358:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80035b:	89 d0                	mov    %edx,%eax
  80035d:	01 c0                	add    %eax,%eax
  80035f:	01 d0                	add    %edx,%eax
  800361:	c1 e0 03             	shl    $0x3,%eax
  800364:	01 c8                	add    %ecx,%eax
  800366:	8a 40 04             	mov    0x4(%eax),%al
  800369:	84 c0                	test   %al,%al
  80036b:	75 46                	jne    8003b3 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80036d:	a1 20 50 80 00       	mov    0x805020,%eax
  800372:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800378:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80037b:	89 d0                	mov    %edx,%eax
  80037d:	01 c0                	add    %eax,%eax
  80037f:	01 d0                	add    %edx,%eax
  800381:	c1 e0 03             	shl    $0x3,%eax
  800384:	01 c8                	add    %ecx,%eax
  800386:	8b 00                	mov    (%eax),%eax
  800388:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80038b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80038e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800393:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800398:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80039f:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a2:	01 c8                	add    %ecx,%eax
  8003a4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003a6:	39 c2                	cmp    %eax,%edx
  8003a8:	75 09                	jne    8003b3 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003aa:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003b1:	eb 15                	jmp    8003c8 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b3:	ff 45 e8             	incl   -0x18(%ebp)
  8003b6:	a1 20 50 80 00       	mov    0x805020,%eax
  8003bb:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8003c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003c4:	39 c2                	cmp    %eax,%edx
  8003c6:	77 85                	ja     80034d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003cc:	75 14                	jne    8003e2 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003ce:	83 ec 04             	sub    $0x4,%esp
  8003d1:	68 44 40 80 00       	push   $0x804044
  8003d6:	6a 3a                	push   $0x3a
  8003d8:	68 38 40 80 00       	push   $0x804038
  8003dd:	e8 8d fe ff ff       	call   80026f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003e2:	ff 45 f0             	incl   -0x10(%ebp)
  8003e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003eb:	0f 8c 2f ff ff ff    	jl     800320 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003f1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003ff:	eb 26                	jmp    800427 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800401:	a1 20 50 80 00       	mov    0x805020,%eax
  800406:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80040c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80040f:	89 d0                	mov    %edx,%eax
  800411:	01 c0                	add    %eax,%eax
  800413:	01 d0                	add    %edx,%eax
  800415:	c1 e0 03             	shl    $0x3,%eax
  800418:	01 c8                	add    %ecx,%eax
  80041a:	8a 40 04             	mov    0x4(%eax),%al
  80041d:	3c 01                	cmp    $0x1,%al
  80041f:	75 03                	jne    800424 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800421:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800424:	ff 45 e0             	incl   -0x20(%ebp)
  800427:	a1 20 50 80 00       	mov    0x805020,%eax
  80042c:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800432:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800435:	39 c2                	cmp    %eax,%edx
  800437:	77 c8                	ja     800401 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80043c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80043f:	74 14                	je     800455 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800441:	83 ec 04             	sub    $0x4,%esp
  800444:	68 98 40 80 00       	push   $0x804098
  800449:	6a 44                	push   $0x44
  80044b:	68 38 40 80 00       	push   $0x804038
  800450:	e8 1a fe ff ff       	call   80026f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800455:	90                   	nop
  800456:	c9                   	leave  
  800457:	c3                   	ret    

00800458 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800458:	55                   	push   %ebp
  800459:	89 e5                	mov    %esp,%ebp
  80045b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80045e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800461:	8b 00                	mov    (%eax),%eax
  800463:	8d 48 01             	lea    0x1(%eax),%ecx
  800466:	8b 55 0c             	mov    0xc(%ebp),%edx
  800469:	89 0a                	mov    %ecx,(%edx)
  80046b:	8b 55 08             	mov    0x8(%ebp),%edx
  80046e:	88 d1                	mov    %dl,%cl
  800470:	8b 55 0c             	mov    0xc(%ebp),%edx
  800473:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800477:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047a:	8b 00                	mov    (%eax),%eax
  80047c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800481:	75 2c                	jne    8004af <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800483:	a0 28 50 80 00       	mov    0x805028,%al
  800488:	0f b6 c0             	movzbl %al,%eax
  80048b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048e:	8b 12                	mov    (%edx),%edx
  800490:	89 d1                	mov    %edx,%ecx
  800492:	8b 55 0c             	mov    0xc(%ebp),%edx
  800495:	83 c2 08             	add    $0x8,%edx
  800498:	83 ec 04             	sub    $0x4,%esp
  80049b:	50                   	push   %eax
  80049c:	51                   	push   %ecx
  80049d:	52                   	push   %edx
  80049e:	e8 4e 0e 00 00       	call   8012f1 <sys_cputs>
  8004a3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b2:	8b 40 04             	mov    0x4(%eax),%eax
  8004b5:	8d 50 01             	lea    0x1(%eax),%edx
  8004b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bb:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004be:	90                   	nop
  8004bf:	c9                   	leave  
  8004c0:	c3                   	ret    

008004c1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004c1:	55                   	push   %ebp
  8004c2:	89 e5                	mov    %esp,%ebp
  8004c4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004ca:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d1:	00 00 00 
	b.cnt = 0;
  8004d4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004db:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004de:	ff 75 0c             	pushl  0xc(%ebp)
  8004e1:	ff 75 08             	pushl  0x8(%ebp)
  8004e4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004ea:	50                   	push   %eax
  8004eb:	68 58 04 80 00       	push   $0x800458
  8004f0:	e8 11 02 00 00       	call   800706 <vprintfmt>
  8004f5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004f8:	a0 28 50 80 00       	mov    0x805028,%al
  8004fd:	0f b6 c0             	movzbl %al,%eax
  800500:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800506:	83 ec 04             	sub    $0x4,%esp
  800509:	50                   	push   %eax
  80050a:	52                   	push   %edx
  80050b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800511:	83 c0 08             	add    $0x8,%eax
  800514:	50                   	push   %eax
  800515:	e8 d7 0d 00 00       	call   8012f1 <sys_cputs>
  80051a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80051d:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800524:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80052a:	c9                   	leave  
  80052b:	c3                   	ret    

0080052c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80052c:	55                   	push   %ebp
  80052d:	89 e5                	mov    %esp,%ebp
  80052f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800532:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800539:	8d 45 0c             	lea    0xc(%ebp),%eax
  80053c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80053f:	8b 45 08             	mov    0x8(%ebp),%eax
  800542:	83 ec 08             	sub    $0x8,%esp
  800545:	ff 75 f4             	pushl  -0xc(%ebp)
  800548:	50                   	push   %eax
  800549:	e8 73 ff ff ff       	call   8004c1 <vcprintf>
  80054e:	83 c4 10             	add    $0x10,%esp
  800551:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800554:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800557:	c9                   	leave  
  800558:	c3                   	ret    

00800559 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800559:	55                   	push   %ebp
  80055a:	89 e5                	mov    %esp,%ebp
  80055c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80055f:	e8 cf 0d 00 00       	call   801333 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800564:	8d 45 0c             	lea    0xc(%ebp),%eax
  800567:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80056a:	8b 45 08             	mov    0x8(%ebp),%eax
  80056d:	83 ec 08             	sub    $0x8,%esp
  800570:	ff 75 f4             	pushl  -0xc(%ebp)
  800573:	50                   	push   %eax
  800574:	e8 48 ff ff ff       	call   8004c1 <vcprintf>
  800579:	83 c4 10             	add    $0x10,%esp
  80057c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80057f:	e8 c9 0d 00 00       	call   80134d <sys_unlock_cons>
	return cnt;
  800584:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800587:	c9                   	leave  
  800588:	c3                   	ret    

00800589 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800589:	55                   	push   %ebp
  80058a:	89 e5                	mov    %esp,%ebp
  80058c:	53                   	push   %ebx
  80058d:	83 ec 14             	sub    $0x14,%esp
  800590:	8b 45 10             	mov    0x10(%ebp),%eax
  800593:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800596:	8b 45 14             	mov    0x14(%ebp),%eax
  800599:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80059c:	8b 45 18             	mov    0x18(%ebp),%eax
  80059f:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a7:	77 55                	ja     8005fe <printnum+0x75>
  8005a9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ac:	72 05                	jb     8005b3 <printnum+0x2a>
  8005ae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b1:	77 4b                	ja     8005fe <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005b6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005b9:	8b 45 18             	mov    0x18(%ebp),%eax
  8005bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c1:	52                   	push   %edx
  8005c2:	50                   	push   %eax
  8005c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8005c9:	e8 ca 35 00 00       	call   803b98 <__udivdi3>
  8005ce:	83 c4 10             	add    $0x10,%esp
  8005d1:	83 ec 04             	sub    $0x4,%esp
  8005d4:	ff 75 20             	pushl  0x20(%ebp)
  8005d7:	53                   	push   %ebx
  8005d8:	ff 75 18             	pushl  0x18(%ebp)
  8005db:	52                   	push   %edx
  8005dc:	50                   	push   %eax
  8005dd:	ff 75 0c             	pushl  0xc(%ebp)
  8005e0:	ff 75 08             	pushl  0x8(%ebp)
  8005e3:	e8 a1 ff ff ff       	call   800589 <printnum>
  8005e8:	83 c4 20             	add    $0x20,%esp
  8005eb:	eb 1a                	jmp    800607 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005ed:	83 ec 08             	sub    $0x8,%esp
  8005f0:	ff 75 0c             	pushl  0xc(%ebp)
  8005f3:	ff 75 20             	pushl  0x20(%ebp)
  8005f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f9:	ff d0                	call   *%eax
  8005fb:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005fe:	ff 4d 1c             	decl   0x1c(%ebp)
  800601:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800605:	7f e6                	jg     8005ed <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800607:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80060a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80060f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800612:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800615:	53                   	push   %ebx
  800616:	51                   	push   %ecx
  800617:	52                   	push   %edx
  800618:	50                   	push   %eax
  800619:	e8 8a 36 00 00       	call   803ca8 <__umoddi3>
  80061e:	83 c4 10             	add    $0x10,%esp
  800621:	05 14 43 80 00       	add    $0x804314,%eax
  800626:	8a 00                	mov    (%eax),%al
  800628:	0f be c0             	movsbl %al,%eax
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	ff 75 0c             	pushl  0xc(%ebp)
  800631:	50                   	push   %eax
  800632:	8b 45 08             	mov    0x8(%ebp),%eax
  800635:	ff d0                	call   *%eax
  800637:	83 c4 10             	add    $0x10,%esp
}
  80063a:	90                   	nop
  80063b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80063e:	c9                   	leave  
  80063f:	c3                   	ret    

00800640 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800640:	55                   	push   %ebp
  800641:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800643:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800647:	7e 1c                	jle    800665 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800649:	8b 45 08             	mov    0x8(%ebp),%eax
  80064c:	8b 00                	mov    (%eax),%eax
  80064e:	8d 50 08             	lea    0x8(%eax),%edx
  800651:	8b 45 08             	mov    0x8(%ebp),%eax
  800654:	89 10                	mov    %edx,(%eax)
  800656:	8b 45 08             	mov    0x8(%ebp),%eax
  800659:	8b 00                	mov    (%eax),%eax
  80065b:	83 e8 08             	sub    $0x8,%eax
  80065e:	8b 50 04             	mov    0x4(%eax),%edx
  800661:	8b 00                	mov    (%eax),%eax
  800663:	eb 40                	jmp    8006a5 <getuint+0x65>
	else if (lflag)
  800665:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800669:	74 1e                	je     800689 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80066b:	8b 45 08             	mov    0x8(%ebp),%eax
  80066e:	8b 00                	mov    (%eax),%eax
  800670:	8d 50 04             	lea    0x4(%eax),%edx
  800673:	8b 45 08             	mov    0x8(%ebp),%eax
  800676:	89 10                	mov    %edx,(%eax)
  800678:	8b 45 08             	mov    0x8(%ebp),%eax
  80067b:	8b 00                	mov    (%eax),%eax
  80067d:	83 e8 04             	sub    $0x4,%eax
  800680:	8b 00                	mov    (%eax),%eax
  800682:	ba 00 00 00 00       	mov    $0x0,%edx
  800687:	eb 1c                	jmp    8006a5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800689:	8b 45 08             	mov    0x8(%ebp),%eax
  80068c:	8b 00                	mov    (%eax),%eax
  80068e:	8d 50 04             	lea    0x4(%eax),%edx
  800691:	8b 45 08             	mov    0x8(%ebp),%eax
  800694:	89 10                	mov    %edx,(%eax)
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	8b 00                	mov    (%eax),%eax
  80069b:	83 e8 04             	sub    $0x4,%eax
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006a5:	5d                   	pop    %ebp
  8006a6:	c3                   	ret    

008006a7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006a7:	55                   	push   %ebp
  8006a8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006aa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ae:	7e 1c                	jle    8006cc <getint+0x25>
		return va_arg(*ap, long long);
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	8b 00                	mov    (%eax),%eax
  8006b5:	8d 50 08             	lea    0x8(%eax),%edx
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	89 10                	mov    %edx,(%eax)
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	83 e8 08             	sub    $0x8,%eax
  8006c5:	8b 50 04             	mov    0x4(%eax),%edx
  8006c8:	8b 00                	mov    (%eax),%eax
  8006ca:	eb 38                	jmp    800704 <getint+0x5d>
	else if (lflag)
  8006cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006d0:	74 1a                	je     8006ec <getint+0x45>
		return va_arg(*ap, long);
  8006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	8d 50 04             	lea    0x4(%eax),%edx
  8006da:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dd:	89 10                	mov    %edx,(%eax)
  8006df:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	83 e8 04             	sub    $0x4,%eax
  8006e7:	8b 00                	mov    (%eax),%eax
  8006e9:	99                   	cltd   
  8006ea:	eb 18                	jmp    800704 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	8d 50 04             	lea    0x4(%eax),%edx
  8006f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f7:	89 10                	mov    %edx,(%eax)
  8006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fc:	8b 00                	mov    (%eax),%eax
  8006fe:	83 e8 04             	sub    $0x4,%eax
  800701:	8b 00                	mov    (%eax),%eax
  800703:	99                   	cltd   
}
  800704:	5d                   	pop    %ebp
  800705:	c3                   	ret    

00800706 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800706:	55                   	push   %ebp
  800707:	89 e5                	mov    %esp,%ebp
  800709:	56                   	push   %esi
  80070a:	53                   	push   %ebx
  80070b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070e:	eb 17                	jmp    800727 <vprintfmt+0x21>
			if (ch == '\0')
  800710:	85 db                	test   %ebx,%ebx
  800712:	0f 84 c1 03 00 00    	je     800ad9 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800718:	83 ec 08             	sub    $0x8,%esp
  80071b:	ff 75 0c             	pushl  0xc(%ebp)
  80071e:	53                   	push   %ebx
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	ff d0                	call   *%eax
  800724:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800727:	8b 45 10             	mov    0x10(%ebp),%eax
  80072a:	8d 50 01             	lea    0x1(%eax),%edx
  80072d:	89 55 10             	mov    %edx,0x10(%ebp)
  800730:	8a 00                	mov    (%eax),%al
  800732:	0f b6 d8             	movzbl %al,%ebx
  800735:	83 fb 25             	cmp    $0x25,%ebx
  800738:	75 d6                	jne    800710 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80073a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80073e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800745:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80074c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800753:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80075a:	8b 45 10             	mov    0x10(%ebp),%eax
  80075d:	8d 50 01             	lea    0x1(%eax),%edx
  800760:	89 55 10             	mov    %edx,0x10(%ebp)
  800763:	8a 00                	mov    (%eax),%al
  800765:	0f b6 d8             	movzbl %al,%ebx
  800768:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80076b:	83 f8 5b             	cmp    $0x5b,%eax
  80076e:	0f 87 3d 03 00 00    	ja     800ab1 <vprintfmt+0x3ab>
  800774:	8b 04 85 38 43 80 00 	mov    0x804338(,%eax,4),%eax
  80077b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80077d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800781:	eb d7                	jmp    80075a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800783:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800787:	eb d1                	jmp    80075a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800789:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800790:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800793:	89 d0                	mov    %edx,%eax
  800795:	c1 e0 02             	shl    $0x2,%eax
  800798:	01 d0                	add    %edx,%eax
  80079a:	01 c0                	add    %eax,%eax
  80079c:	01 d8                	add    %ebx,%eax
  80079e:	83 e8 30             	sub    $0x30,%eax
  8007a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a7:	8a 00                	mov    (%eax),%al
  8007a9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ac:	83 fb 2f             	cmp    $0x2f,%ebx
  8007af:	7e 3e                	jle    8007ef <vprintfmt+0xe9>
  8007b1:	83 fb 39             	cmp    $0x39,%ebx
  8007b4:	7f 39                	jg     8007ef <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007b6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b9:	eb d5                	jmp    800790 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007be:	83 c0 04             	add    $0x4,%eax
  8007c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c7:	83 e8 04             	sub    $0x4,%eax
  8007ca:	8b 00                	mov    (%eax),%eax
  8007cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007cf:	eb 1f                	jmp    8007f0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d5:	79 83                	jns    80075a <vprintfmt+0x54>
				width = 0;
  8007d7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007de:	e9 77 ff ff ff       	jmp    80075a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007e3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007ea:	e9 6b ff ff ff       	jmp    80075a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007ef:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007f0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f4:	0f 89 60 ff ff ff    	jns    80075a <vprintfmt+0x54>
				width = precision, precision = -1;
  8007fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800800:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800807:	e9 4e ff ff ff       	jmp    80075a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80080c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80080f:	e9 46 ff ff ff       	jmp    80075a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	83 c0 04             	add    $0x4,%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	83 e8 04             	sub    $0x4,%eax
  800823:	8b 00                	mov    (%eax),%eax
  800825:	83 ec 08             	sub    $0x8,%esp
  800828:	ff 75 0c             	pushl  0xc(%ebp)
  80082b:	50                   	push   %eax
  80082c:	8b 45 08             	mov    0x8(%ebp),%eax
  80082f:	ff d0                	call   *%eax
  800831:	83 c4 10             	add    $0x10,%esp
			break;
  800834:	e9 9b 02 00 00       	jmp    800ad4 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800839:	8b 45 14             	mov    0x14(%ebp),%eax
  80083c:	83 c0 04             	add    $0x4,%eax
  80083f:	89 45 14             	mov    %eax,0x14(%ebp)
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	83 e8 04             	sub    $0x4,%eax
  800848:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80084a:	85 db                	test   %ebx,%ebx
  80084c:	79 02                	jns    800850 <vprintfmt+0x14a>
				err = -err;
  80084e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800850:	83 fb 64             	cmp    $0x64,%ebx
  800853:	7f 0b                	jg     800860 <vprintfmt+0x15a>
  800855:	8b 34 9d 80 41 80 00 	mov    0x804180(,%ebx,4),%esi
  80085c:	85 f6                	test   %esi,%esi
  80085e:	75 19                	jne    800879 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800860:	53                   	push   %ebx
  800861:	68 25 43 80 00       	push   $0x804325
  800866:	ff 75 0c             	pushl  0xc(%ebp)
  800869:	ff 75 08             	pushl  0x8(%ebp)
  80086c:	e8 70 02 00 00       	call   800ae1 <printfmt>
  800871:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800874:	e9 5b 02 00 00       	jmp    800ad4 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800879:	56                   	push   %esi
  80087a:	68 2e 43 80 00       	push   $0x80432e
  80087f:	ff 75 0c             	pushl  0xc(%ebp)
  800882:	ff 75 08             	pushl  0x8(%ebp)
  800885:	e8 57 02 00 00       	call   800ae1 <printfmt>
  80088a:	83 c4 10             	add    $0x10,%esp
			break;
  80088d:	e9 42 02 00 00       	jmp    800ad4 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800892:	8b 45 14             	mov    0x14(%ebp),%eax
  800895:	83 c0 04             	add    $0x4,%eax
  800898:	89 45 14             	mov    %eax,0x14(%ebp)
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	83 e8 04             	sub    $0x4,%eax
  8008a1:	8b 30                	mov    (%eax),%esi
  8008a3:	85 f6                	test   %esi,%esi
  8008a5:	75 05                	jne    8008ac <vprintfmt+0x1a6>
				p = "(null)";
  8008a7:	be 31 43 80 00       	mov    $0x804331,%esi
			if (width > 0 && padc != '-')
  8008ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b0:	7e 6d                	jle    80091f <vprintfmt+0x219>
  8008b2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008b6:	74 67                	je     80091f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	50                   	push   %eax
  8008bf:	56                   	push   %esi
  8008c0:	e8 1e 03 00 00       	call   800be3 <strnlen>
  8008c5:	83 c4 10             	add    $0x10,%esp
  8008c8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008cb:	eb 16                	jmp    8008e3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008cd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d1:	83 ec 08             	sub    $0x8,%esp
  8008d4:	ff 75 0c             	pushl  0xc(%ebp)
  8008d7:	50                   	push   %eax
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	ff d0                	call   *%eax
  8008dd:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e0:	ff 4d e4             	decl   -0x1c(%ebp)
  8008e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e7:	7f e4                	jg     8008cd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e9:	eb 34                	jmp    80091f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008eb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008ef:	74 1c                	je     80090d <vprintfmt+0x207>
  8008f1:	83 fb 1f             	cmp    $0x1f,%ebx
  8008f4:	7e 05                	jle    8008fb <vprintfmt+0x1f5>
  8008f6:	83 fb 7e             	cmp    $0x7e,%ebx
  8008f9:	7e 12                	jle    80090d <vprintfmt+0x207>
					putch('?', putdat);
  8008fb:	83 ec 08             	sub    $0x8,%esp
  8008fe:	ff 75 0c             	pushl  0xc(%ebp)
  800901:	6a 3f                	push   $0x3f
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	ff d0                	call   *%eax
  800908:	83 c4 10             	add    $0x10,%esp
  80090b:	eb 0f                	jmp    80091c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80090d:	83 ec 08             	sub    $0x8,%esp
  800910:	ff 75 0c             	pushl  0xc(%ebp)
  800913:	53                   	push   %ebx
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	ff d0                	call   *%eax
  800919:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80091c:	ff 4d e4             	decl   -0x1c(%ebp)
  80091f:	89 f0                	mov    %esi,%eax
  800921:	8d 70 01             	lea    0x1(%eax),%esi
  800924:	8a 00                	mov    (%eax),%al
  800926:	0f be d8             	movsbl %al,%ebx
  800929:	85 db                	test   %ebx,%ebx
  80092b:	74 24                	je     800951 <vprintfmt+0x24b>
  80092d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800931:	78 b8                	js     8008eb <vprintfmt+0x1e5>
  800933:	ff 4d e0             	decl   -0x20(%ebp)
  800936:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80093a:	79 af                	jns    8008eb <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80093c:	eb 13                	jmp    800951 <vprintfmt+0x24b>
				putch(' ', putdat);
  80093e:	83 ec 08             	sub    $0x8,%esp
  800941:	ff 75 0c             	pushl  0xc(%ebp)
  800944:	6a 20                	push   $0x20
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	ff d0                	call   *%eax
  80094b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80094e:	ff 4d e4             	decl   -0x1c(%ebp)
  800951:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800955:	7f e7                	jg     80093e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800957:	e9 78 01 00 00       	jmp    800ad4 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80095c:	83 ec 08             	sub    $0x8,%esp
  80095f:	ff 75 e8             	pushl  -0x18(%ebp)
  800962:	8d 45 14             	lea    0x14(%ebp),%eax
  800965:	50                   	push   %eax
  800966:	e8 3c fd ff ff       	call   8006a7 <getint>
  80096b:	83 c4 10             	add    $0x10,%esp
  80096e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800971:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800977:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80097a:	85 d2                	test   %edx,%edx
  80097c:	79 23                	jns    8009a1 <vprintfmt+0x29b>
				putch('-', putdat);
  80097e:	83 ec 08             	sub    $0x8,%esp
  800981:	ff 75 0c             	pushl  0xc(%ebp)
  800984:	6a 2d                	push   $0x2d
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	ff d0                	call   *%eax
  80098b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80098e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800991:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800994:	f7 d8                	neg    %eax
  800996:	83 d2 00             	adc    $0x0,%edx
  800999:	f7 da                	neg    %edx
  80099b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a8:	e9 bc 00 00 00       	jmp    800a69 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009ad:	83 ec 08             	sub    $0x8,%esp
  8009b0:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b3:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b6:	50                   	push   %eax
  8009b7:	e8 84 fc ff ff       	call   800640 <getuint>
  8009bc:	83 c4 10             	add    $0x10,%esp
  8009bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009c5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009cc:	e9 98 00 00 00       	jmp    800a69 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d1:	83 ec 08             	sub    $0x8,%esp
  8009d4:	ff 75 0c             	pushl  0xc(%ebp)
  8009d7:	6a 58                	push   $0x58
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	ff d0                	call   *%eax
  8009de:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e1:	83 ec 08             	sub    $0x8,%esp
  8009e4:	ff 75 0c             	pushl  0xc(%ebp)
  8009e7:	6a 58                	push   $0x58
  8009e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ec:	ff d0                	call   *%eax
  8009ee:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f1:	83 ec 08             	sub    $0x8,%esp
  8009f4:	ff 75 0c             	pushl  0xc(%ebp)
  8009f7:	6a 58                	push   $0x58
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	ff d0                	call   *%eax
  8009fe:	83 c4 10             	add    $0x10,%esp
			break;
  800a01:	e9 ce 00 00 00       	jmp    800ad4 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	ff 75 0c             	pushl  0xc(%ebp)
  800a0c:	6a 30                	push   $0x30
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	ff d0                	call   *%eax
  800a13:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a16:	83 ec 08             	sub    $0x8,%esp
  800a19:	ff 75 0c             	pushl  0xc(%ebp)
  800a1c:	6a 78                	push   $0x78
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	ff d0                	call   *%eax
  800a23:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a26:	8b 45 14             	mov    0x14(%ebp),%eax
  800a29:	83 c0 04             	add    $0x4,%eax
  800a2c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a32:	83 e8 04             	sub    $0x4,%eax
  800a35:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a37:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a41:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a48:	eb 1f                	jmp    800a69 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a50:	8d 45 14             	lea    0x14(%ebp),%eax
  800a53:	50                   	push   %eax
  800a54:	e8 e7 fb ff ff       	call   800640 <getuint>
  800a59:	83 c4 10             	add    $0x10,%esp
  800a5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a62:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a69:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a70:	83 ec 04             	sub    $0x4,%esp
  800a73:	52                   	push   %edx
  800a74:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a77:	50                   	push   %eax
  800a78:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7b:	ff 75 f0             	pushl  -0x10(%ebp)
  800a7e:	ff 75 0c             	pushl  0xc(%ebp)
  800a81:	ff 75 08             	pushl  0x8(%ebp)
  800a84:	e8 00 fb ff ff       	call   800589 <printnum>
  800a89:	83 c4 20             	add    $0x20,%esp
			break;
  800a8c:	eb 46                	jmp    800ad4 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	53                   	push   %ebx
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	ff d0                	call   *%eax
  800a9a:	83 c4 10             	add    $0x10,%esp
			break;
  800a9d:	eb 35                	jmp    800ad4 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a9f:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800aa6:	eb 2c                	jmp    800ad4 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800aa8:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  800aaf:	eb 23                	jmp    800ad4 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ab1:	83 ec 08             	sub    $0x8,%esp
  800ab4:	ff 75 0c             	pushl  0xc(%ebp)
  800ab7:	6a 25                	push   $0x25
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	ff d0                	call   *%eax
  800abe:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ac1:	ff 4d 10             	decl   0x10(%ebp)
  800ac4:	eb 03                	jmp    800ac9 <vprintfmt+0x3c3>
  800ac6:	ff 4d 10             	decl   0x10(%ebp)
  800ac9:	8b 45 10             	mov    0x10(%ebp),%eax
  800acc:	48                   	dec    %eax
  800acd:	8a 00                	mov    (%eax),%al
  800acf:	3c 25                	cmp    $0x25,%al
  800ad1:	75 f3                	jne    800ac6 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ad3:	90                   	nop
		}
	}
  800ad4:	e9 35 fc ff ff       	jmp    80070e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ad9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ada:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800add:	5b                   	pop    %ebx
  800ade:	5e                   	pop    %esi
  800adf:	5d                   	pop    %ebp
  800ae0:	c3                   	ret    

00800ae1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ae7:	8d 45 10             	lea    0x10(%ebp),%eax
  800aea:	83 c0 04             	add    $0x4,%eax
  800aed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800af0:	8b 45 10             	mov    0x10(%ebp),%eax
  800af3:	ff 75 f4             	pushl  -0xc(%ebp)
  800af6:	50                   	push   %eax
  800af7:	ff 75 0c             	pushl  0xc(%ebp)
  800afa:	ff 75 08             	pushl  0x8(%ebp)
  800afd:	e8 04 fc ff ff       	call   800706 <vprintfmt>
  800b02:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b05:	90                   	nop
  800b06:	c9                   	leave  
  800b07:	c3                   	ret    

00800b08 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0e:	8b 40 08             	mov    0x8(%eax),%eax
  800b11:	8d 50 01             	lea    0x1(%eax),%edx
  800b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b17:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1d:	8b 10                	mov    (%eax),%edx
  800b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b22:	8b 40 04             	mov    0x4(%eax),%eax
  800b25:	39 c2                	cmp    %eax,%edx
  800b27:	73 12                	jae    800b3b <sprintputch+0x33>
		*b->buf++ = ch;
  800b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2c:	8b 00                	mov    (%eax),%eax
  800b2e:	8d 48 01             	lea    0x1(%eax),%ecx
  800b31:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b34:	89 0a                	mov    %ecx,(%edx)
  800b36:	8b 55 08             	mov    0x8(%ebp),%edx
  800b39:	88 10                	mov    %dl,(%eax)
}
  800b3b:	90                   	nop
  800b3c:	5d                   	pop    %ebp
  800b3d:	c3                   	ret    

00800b3e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	01 d0                	add    %edx,%eax
  800b55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b63:	74 06                	je     800b6b <vsnprintf+0x2d>
  800b65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b69:	7f 07                	jg     800b72 <vsnprintf+0x34>
		return -E_INVAL;
  800b6b:	b8 03 00 00 00       	mov    $0x3,%eax
  800b70:	eb 20                	jmp    800b92 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b72:	ff 75 14             	pushl  0x14(%ebp)
  800b75:	ff 75 10             	pushl  0x10(%ebp)
  800b78:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b7b:	50                   	push   %eax
  800b7c:	68 08 0b 80 00       	push   $0x800b08
  800b81:	e8 80 fb ff ff       	call   800706 <vprintfmt>
  800b86:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b8c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b92:	c9                   	leave  
  800b93:	c3                   	ret    

00800b94 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b9a:	8d 45 10             	lea    0x10(%ebp),%eax
  800b9d:	83 c0 04             	add    $0x4,%eax
  800ba0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ba3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba9:	50                   	push   %eax
  800baa:	ff 75 0c             	pushl  0xc(%ebp)
  800bad:	ff 75 08             	pushl  0x8(%ebp)
  800bb0:	e8 89 ff ff ff       	call   800b3e <vsnprintf>
  800bb5:	83 c4 10             	add    $0x10,%esp
  800bb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bcd:	eb 06                	jmp    800bd5 <strlen+0x15>
		n++;
  800bcf:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd2:	ff 45 08             	incl   0x8(%ebp)
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	8a 00                	mov    (%eax),%al
  800bda:	84 c0                	test   %al,%al
  800bdc:	75 f1                	jne    800bcf <strlen+0xf>
		n++;
	return n;
  800bde:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be1:	c9                   	leave  
  800be2:	c3                   	ret    

00800be3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf0:	eb 09                	jmp    800bfb <strnlen+0x18>
		n++;
  800bf2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bf5:	ff 45 08             	incl   0x8(%ebp)
  800bf8:	ff 4d 0c             	decl   0xc(%ebp)
  800bfb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bff:	74 09                	je     800c0a <strnlen+0x27>
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	84 c0                	test   %al,%al
  800c08:	75 e8                	jne    800bf2 <strnlen+0xf>
		n++;
	return n;
  800c0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0d:	c9                   	leave  
  800c0e:	c3                   	ret    

00800c0f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c15:	8b 45 08             	mov    0x8(%ebp),%eax
  800c18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c1b:	90                   	nop
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8d 50 01             	lea    0x1(%eax),%edx
  800c22:	89 55 08             	mov    %edx,0x8(%ebp)
  800c25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c28:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c2b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c2e:	8a 12                	mov    (%edx),%dl
  800c30:	88 10                	mov    %dl,(%eax)
  800c32:	8a 00                	mov    (%eax),%al
  800c34:	84 c0                	test   %al,%al
  800c36:	75 e4                	jne    800c1c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c38:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c3b:	c9                   	leave  
  800c3c:	c3                   	ret    

00800c3d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
  800c40:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c49:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c50:	eb 1f                	jmp    800c71 <strncpy+0x34>
		*dst++ = *src;
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	8d 50 01             	lea    0x1(%eax),%edx
  800c58:	89 55 08             	mov    %edx,0x8(%ebp)
  800c5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5e:	8a 12                	mov    (%edx),%dl
  800c60:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c65:	8a 00                	mov    (%eax),%al
  800c67:	84 c0                	test   %al,%al
  800c69:	74 03                	je     800c6e <strncpy+0x31>
			src++;
  800c6b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c6e:	ff 45 fc             	incl   -0x4(%ebp)
  800c71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c74:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c77:	72 d9                	jb     800c52 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c79:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c7c:	c9                   	leave  
  800c7d:	c3                   	ret    

00800c7e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c8a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c8e:	74 30                	je     800cc0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c90:	eb 16                	jmp    800ca8 <strlcpy+0x2a>
			*dst++ = *src++;
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	8d 50 01             	lea    0x1(%eax),%edx
  800c98:	89 55 08             	mov    %edx,0x8(%ebp)
  800c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ca1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ca4:	8a 12                	mov    (%edx),%dl
  800ca6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ca8:	ff 4d 10             	decl   0x10(%ebp)
  800cab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800caf:	74 09                	je     800cba <strlcpy+0x3c>
  800cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb4:	8a 00                	mov    (%eax),%al
  800cb6:	84 c0                	test   %al,%al
  800cb8:	75 d8                	jne    800c92 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc6:	29 c2                	sub    %eax,%edx
  800cc8:	89 d0                	mov    %edx,%eax
}
  800cca:	c9                   	leave  
  800ccb:	c3                   	ret    

00800ccc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ccf:	eb 06                	jmp    800cd7 <strcmp+0xb>
		p++, q++;
  800cd1:	ff 45 08             	incl   0x8(%ebp)
  800cd4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8a 00                	mov    (%eax),%al
  800cdc:	84 c0                	test   %al,%al
  800cde:	74 0e                	je     800cee <strcmp+0x22>
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	8a 10                	mov    (%eax),%dl
  800ce5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	38 c2                	cmp    %al,%dl
  800cec:	74 e3                	je     800cd1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	0f b6 d0             	movzbl %al,%edx
  800cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf9:	8a 00                	mov    (%eax),%al
  800cfb:	0f b6 c0             	movzbl %al,%eax
  800cfe:	29 c2                	sub    %eax,%edx
  800d00:	89 d0                	mov    %edx,%eax
}
  800d02:	5d                   	pop    %ebp
  800d03:	c3                   	ret    

00800d04 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d07:	eb 09                	jmp    800d12 <strncmp+0xe>
		n--, p++, q++;
  800d09:	ff 4d 10             	decl   0x10(%ebp)
  800d0c:	ff 45 08             	incl   0x8(%ebp)
  800d0f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d16:	74 17                	je     800d2f <strncmp+0x2b>
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	8a 00                	mov    (%eax),%al
  800d1d:	84 c0                	test   %al,%al
  800d1f:	74 0e                	je     800d2f <strncmp+0x2b>
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8a 10                	mov    (%eax),%dl
  800d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d29:	8a 00                	mov    (%eax),%al
  800d2b:	38 c2                	cmp    %al,%dl
  800d2d:	74 da                	je     800d09 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d33:	75 07                	jne    800d3c <strncmp+0x38>
		return 0;
  800d35:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3a:	eb 14                	jmp    800d50 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	0f b6 d0             	movzbl %al,%edx
  800d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	0f b6 c0             	movzbl %al,%eax
  800d4c:	29 c2                	sub    %eax,%edx
  800d4e:	89 d0                	mov    %edx,%eax
}
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    

00800d52 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	83 ec 04             	sub    $0x4,%esp
  800d58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d5e:	eb 12                	jmp    800d72 <strchr+0x20>
		if (*s == c)
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	8a 00                	mov    (%eax),%al
  800d65:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d68:	75 05                	jne    800d6f <strchr+0x1d>
			return (char *) s;
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	eb 11                	jmp    800d80 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d6f:	ff 45 08             	incl   0x8(%ebp)
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	8a 00                	mov    (%eax),%al
  800d77:	84 c0                	test   %al,%al
  800d79:	75 e5                	jne    800d60 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d80:	c9                   	leave  
  800d81:	c3                   	ret    

00800d82 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	83 ec 04             	sub    $0x4,%esp
  800d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d8e:	eb 0d                	jmp    800d9d <strfind+0x1b>
		if (*s == c)
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	8a 00                	mov    (%eax),%al
  800d95:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d98:	74 0e                	je     800da8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d9a:	ff 45 08             	incl   0x8(%ebp)
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	8a 00                	mov    (%eax),%al
  800da2:	84 c0                	test   %al,%al
  800da4:	75 ea                	jne    800d90 <strfind+0xe>
  800da6:	eb 01                	jmp    800da9 <strfind+0x27>
		if (*s == c)
			break;
  800da8:	90                   	nop
	return (char *) s;
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dac:	c9                   	leave  
  800dad:	c3                   	ret    

00800dae <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dba:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dc0:	eb 0e                	jmp    800dd0 <memset+0x22>
		*p++ = c;
  800dc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc5:	8d 50 01             	lea    0x1(%eax),%edx
  800dc8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dce:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dd0:	ff 4d f8             	decl   -0x8(%ebp)
  800dd3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dd7:	79 e9                	jns    800dc2 <memset+0x14>
		*p++ = c;

	return v;
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ddc:	c9                   	leave  
  800ddd:	c3                   	ret    

00800dde <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dde:	55                   	push   %ebp
  800ddf:	89 e5                	mov    %esp,%ebp
  800de1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800de4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800df0:	eb 16                	jmp    800e08 <memcpy+0x2a>
		*d++ = *s++;
  800df2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df5:	8d 50 01             	lea    0x1(%eax),%edx
  800df8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dfb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dfe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e01:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e04:	8a 12                	mov    (%edx),%dl
  800e06:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e08:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e11:	85 c0                	test   %eax,%eax
  800e13:	75 dd                	jne    800df2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e18:	c9                   	leave  
  800e19:	c3                   	ret    

00800e1a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e2f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e32:	73 50                	jae    800e84 <memmove+0x6a>
  800e34:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e37:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3a:	01 d0                	add    %edx,%eax
  800e3c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e3f:	76 43                	jbe    800e84 <memmove+0x6a>
		s += n;
  800e41:	8b 45 10             	mov    0x10(%ebp),%eax
  800e44:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e47:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e4d:	eb 10                	jmp    800e5f <memmove+0x45>
			*--d = *--s;
  800e4f:	ff 4d f8             	decl   -0x8(%ebp)
  800e52:	ff 4d fc             	decl   -0x4(%ebp)
  800e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e58:	8a 10                	mov    (%eax),%dl
  800e5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e62:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e65:	89 55 10             	mov    %edx,0x10(%ebp)
  800e68:	85 c0                	test   %eax,%eax
  800e6a:	75 e3                	jne    800e4f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e6c:	eb 23                	jmp    800e91 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e71:	8d 50 01             	lea    0x1(%eax),%edx
  800e74:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e77:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e7a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e7d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e80:	8a 12                	mov    (%edx),%dl
  800e82:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e84:	8b 45 10             	mov    0x10(%ebp),%eax
  800e87:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e8a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e8d:	85 c0                	test   %eax,%eax
  800e8f:	75 dd                	jne    800e6e <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e94:	c9                   	leave  
  800e95:	c3                   	ret    

00800e96 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ea8:	eb 2a                	jmp    800ed4 <memcmp+0x3e>
		if (*s1 != *s2)
  800eaa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ead:	8a 10                	mov    (%eax),%dl
  800eaf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb2:	8a 00                	mov    (%eax),%al
  800eb4:	38 c2                	cmp    %al,%dl
  800eb6:	74 16                	je     800ece <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	0f b6 d0             	movzbl %al,%edx
  800ec0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec3:	8a 00                	mov    (%eax),%al
  800ec5:	0f b6 c0             	movzbl %al,%eax
  800ec8:	29 c2                	sub    %eax,%edx
  800eca:	89 d0                	mov    %edx,%eax
  800ecc:	eb 18                	jmp    800ee6 <memcmp+0x50>
		s1++, s2++;
  800ece:	ff 45 fc             	incl   -0x4(%ebp)
  800ed1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ed4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eda:	89 55 10             	mov    %edx,0x10(%ebp)
  800edd:	85 c0                	test   %eax,%eax
  800edf:	75 c9                	jne    800eaa <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ee1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee6:	c9                   	leave  
  800ee7:	c3                   	ret    

00800ee8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800eee:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef4:	01 d0                	add    %edx,%eax
  800ef6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ef9:	eb 15                	jmp    800f10 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	8a 00                	mov    (%eax),%al
  800f00:	0f b6 d0             	movzbl %al,%edx
  800f03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f06:	0f b6 c0             	movzbl %al,%eax
  800f09:	39 c2                	cmp    %eax,%edx
  800f0b:	74 0d                	je     800f1a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f0d:	ff 45 08             	incl   0x8(%ebp)
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f16:	72 e3                	jb     800efb <memfind+0x13>
  800f18:	eb 01                	jmp    800f1b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f1a:	90                   	nop
	return (void *) s;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    

00800f20 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f2d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f34:	eb 03                	jmp    800f39 <strtol+0x19>
		s++;
  800f36:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	8a 00                	mov    (%eax),%al
  800f3e:	3c 20                	cmp    $0x20,%al
  800f40:	74 f4                	je     800f36 <strtol+0x16>
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	3c 09                	cmp    $0x9,%al
  800f49:	74 eb                	je     800f36 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	3c 2b                	cmp    $0x2b,%al
  800f52:	75 05                	jne    800f59 <strtol+0x39>
		s++;
  800f54:	ff 45 08             	incl   0x8(%ebp)
  800f57:	eb 13                	jmp    800f6c <strtol+0x4c>
	else if (*s == '-')
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	3c 2d                	cmp    $0x2d,%al
  800f60:	75 0a                	jne    800f6c <strtol+0x4c>
		s++, neg = 1;
  800f62:	ff 45 08             	incl   0x8(%ebp)
  800f65:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f70:	74 06                	je     800f78 <strtol+0x58>
  800f72:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f76:	75 20                	jne    800f98 <strtol+0x78>
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7b:	8a 00                	mov    (%eax),%al
  800f7d:	3c 30                	cmp    $0x30,%al
  800f7f:	75 17                	jne    800f98 <strtol+0x78>
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	40                   	inc    %eax
  800f85:	8a 00                	mov    (%eax),%al
  800f87:	3c 78                	cmp    $0x78,%al
  800f89:	75 0d                	jne    800f98 <strtol+0x78>
		s += 2, base = 16;
  800f8b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f8f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f96:	eb 28                	jmp    800fc0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9c:	75 15                	jne    800fb3 <strtol+0x93>
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa1:	8a 00                	mov    (%eax),%al
  800fa3:	3c 30                	cmp    $0x30,%al
  800fa5:	75 0c                	jne    800fb3 <strtol+0x93>
		s++, base = 8;
  800fa7:	ff 45 08             	incl   0x8(%ebp)
  800faa:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fb1:	eb 0d                	jmp    800fc0 <strtol+0xa0>
	else if (base == 0)
  800fb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb7:	75 07                	jne    800fc0 <strtol+0xa0>
		base = 10;
  800fb9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	3c 2f                	cmp    $0x2f,%al
  800fc7:	7e 19                	jle    800fe2 <strtol+0xc2>
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	3c 39                	cmp    $0x39,%al
  800fd0:	7f 10                	jg     800fe2 <strtol+0xc2>
			dig = *s - '0';
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	0f be c0             	movsbl %al,%eax
  800fda:	83 e8 30             	sub    $0x30,%eax
  800fdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe0:	eb 42                	jmp    801024 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	8a 00                	mov    (%eax),%al
  800fe7:	3c 60                	cmp    $0x60,%al
  800fe9:	7e 19                	jle    801004 <strtol+0xe4>
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	3c 7a                	cmp    $0x7a,%al
  800ff2:	7f 10                	jg     801004 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	0f be c0             	movsbl %al,%eax
  800ffc:	83 e8 57             	sub    $0x57,%eax
  800fff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801002:	eb 20                	jmp    801024 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	3c 40                	cmp    $0x40,%al
  80100b:	7e 39                	jle    801046 <strtol+0x126>
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	3c 5a                	cmp    $0x5a,%al
  801014:	7f 30                	jg     801046 <strtol+0x126>
			dig = *s - 'A' + 10;
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	8a 00                	mov    (%eax),%al
  80101b:	0f be c0             	movsbl %al,%eax
  80101e:	83 e8 37             	sub    $0x37,%eax
  801021:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801027:	3b 45 10             	cmp    0x10(%ebp),%eax
  80102a:	7d 19                	jge    801045 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80102c:	ff 45 08             	incl   0x8(%ebp)
  80102f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801032:	0f af 45 10          	imul   0x10(%ebp),%eax
  801036:	89 c2                	mov    %eax,%edx
  801038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80103b:	01 d0                	add    %edx,%eax
  80103d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801040:	e9 7b ff ff ff       	jmp    800fc0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801045:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801046:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80104a:	74 08                	je     801054 <strtol+0x134>
		*endptr = (char *) s;
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	8b 55 08             	mov    0x8(%ebp),%edx
  801052:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801054:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801058:	74 07                	je     801061 <strtol+0x141>
  80105a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105d:	f7 d8                	neg    %eax
  80105f:	eb 03                	jmp    801064 <strtol+0x144>
  801061:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <ltostr>:

void
ltostr(long value, char *str)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80106c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801073:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80107a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80107e:	79 13                	jns    801093 <ltostr+0x2d>
	{
		neg = 1;
  801080:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801087:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80108d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801090:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80109b:	99                   	cltd   
  80109c:	f7 f9                	idiv   %ecx
  80109e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a4:	8d 50 01             	lea    0x1(%eax),%edx
  8010a7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010aa:	89 c2                	mov    %eax,%edx
  8010ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010af:	01 d0                	add    %edx,%eax
  8010b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010b4:	83 c2 30             	add    $0x30,%edx
  8010b7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010bc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c1:	f7 e9                	imul   %ecx
  8010c3:	c1 fa 02             	sar    $0x2,%edx
  8010c6:	89 c8                	mov    %ecx,%eax
  8010c8:	c1 f8 1f             	sar    $0x1f,%eax
  8010cb:	29 c2                	sub    %eax,%edx
  8010cd:	89 d0                	mov    %edx,%eax
  8010cf:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010d6:	75 bb                	jne    801093 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e2:	48                   	dec    %eax
  8010e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010ea:	74 3d                	je     801129 <ltostr+0xc3>
		start = 1 ;
  8010ec:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010f3:	eb 34                	jmp    801129 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fb:	01 d0                	add    %edx,%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801102:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801105:	8b 45 0c             	mov    0xc(%ebp),%eax
  801108:	01 c2                	add    %eax,%edx
  80110a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80110d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801110:	01 c8                	add    %ecx,%eax
  801112:	8a 00                	mov    (%eax),%al
  801114:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801116:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	01 c2                	add    %eax,%edx
  80111e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801121:	88 02                	mov    %al,(%edx)
		start++ ;
  801123:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801126:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80112f:	7c c4                	jl     8010f5 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801131:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801134:	8b 45 0c             	mov    0xc(%ebp),%eax
  801137:	01 d0                	add    %edx,%eax
  801139:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80113c:	90                   	nop
  80113d:	c9                   	leave  
  80113e:	c3                   	ret    

0080113f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801145:	ff 75 08             	pushl  0x8(%ebp)
  801148:	e8 73 fa ff ff       	call   800bc0 <strlen>
  80114d:	83 c4 04             	add    $0x4,%esp
  801150:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801153:	ff 75 0c             	pushl  0xc(%ebp)
  801156:	e8 65 fa ff ff       	call   800bc0 <strlen>
  80115b:	83 c4 04             	add    $0x4,%esp
  80115e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801161:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801168:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80116f:	eb 17                	jmp    801188 <strcconcat+0x49>
		final[s] = str1[s] ;
  801171:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801174:	8b 45 10             	mov    0x10(%ebp),%eax
  801177:	01 c2                	add    %eax,%edx
  801179:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	01 c8                	add    %ecx,%eax
  801181:	8a 00                	mov    (%eax),%al
  801183:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801185:	ff 45 fc             	incl   -0x4(%ebp)
  801188:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80118e:	7c e1                	jl     801171 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801190:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801197:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80119e:	eb 1f                	jmp    8011bf <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a3:	8d 50 01             	lea    0x1(%eax),%edx
  8011a6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011a9:	89 c2                	mov    %eax,%edx
  8011ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ae:	01 c2                	add    %eax,%edx
  8011b0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	01 c8                	add    %ecx,%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011bc:	ff 45 f8             	incl   -0x8(%ebp)
  8011bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011c5:	7c d9                	jl     8011a0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cd:	01 d0                	add    %edx,%eax
  8011cf:	c6 00 00             	movb   $0x0,(%eax)
}
  8011d2:	90                   	nop
  8011d3:	c9                   	leave  
  8011d4:	c3                   	ret    

008011d5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011d5:	55                   	push   %ebp
  8011d6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e4:	8b 00                	mov    (%eax),%eax
  8011e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f0:	01 d0                	add    %edx,%eax
  8011f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011f8:	eb 0c                	jmp    801206 <strsplit+0x31>
			*string++ = 0;
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8d 50 01             	lea    0x1(%eax),%edx
  801200:	89 55 08             	mov    %edx,0x8(%ebp)
  801203:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	84 c0                	test   %al,%al
  80120d:	74 18                	je     801227 <strsplit+0x52>
  80120f:	8b 45 08             	mov    0x8(%ebp),%eax
  801212:	8a 00                	mov    (%eax),%al
  801214:	0f be c0             	movsbl %al,%eax
  801217:	50                   	push   %eax
  801218:	ff 75 0c             	pushl  0xc(%ebp)
  80121b:	e8 32 fb ff ff       	call   800d52 <strchr>
  801220:	83 c4 08             	add    $0x8,%esp
  801223:	85 c0                	test   %eax,%eax
  801225:	75 d3                	jne    8011fa <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801227:	8b 45 08             	mov    0x8(%ebp),%eax
  80122a:	8a 00                	mov    (%eax),%al
  80122c:	84 c0                	test   %al,%al
  80122e:	74 5a                	je     80128a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801230:	8b 45 14             	mov    0x14(%ebp),%eax
  801233:	8b 00                	mov    (%eax),%eax
  801235:	83 f8 0f             	cmp    $0xf,%eax
  801238:	75 07                	jne    801241 <strsplit+0x6c>
		{
			return 0;
  80123a:	b8 00 00 00 00       	mov    $0x0,%eax
  80123f:	eb 66                	jmp    8012a7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801241:	8b 45 14             	mov    0x14(%ebp),%eax
  801244:	8b 00                	mov    (%eax),%eax
  801246:	8d 48 01             	lea    0x1(%eax),%ecx
  801249:	8b 55 14             	mov    0x14(%ebp),%edx
  80124c:	89 0a                	mov    %ecx,(%edx)
  80124e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801255:	8b 45 10             	mov    0x10(%ebp),%eax
  801258:	01 c2                	add    %eax,%edx
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80125f:	eb 03                	jmp    801264 <strsplit+0x8f>
			string++;
  801261:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801264:	8b 45 08             	mov    0x8(%ebp),%eax
  801267:	8a 00                	mov    (%eax),%al
  801269:	84 c0                	test   %al,%al
  80126b:	74 8b                	je     8011f8 <strsplit+0x23>
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	8a 00                	mov    (%eax),%al
  801272:	0f be c0             	movsbl %al,%eax
  801275:	50                   	push   %eax
  801276:	ff 75 0c             	pushl  0xc(%ebp)
  801279:	e8 d4 fa ff ff       	call   800d52 <strchr>
  80127e:	83 c4 08             	add    $0x8,%esp
  801281:	85 c0                	test   %eax,%eax
  801283:	74 dc                	je     801261 <strsplit+0x8c>
			string++;
	}
  801285:	e9 6e ff ff ff       	jmp    8011f8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80128a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80128b:	8b 45 14             	mov    0x14(%ebp),%eax
  80128e:	8b 00                	mov    (%eax),%eax
  801290:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801297:	8b 45 10             	mov    0x10(%ebp),%eax
  80129a:	01 d0                	add    %edx,%eax
  80129c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012a2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012a7:	c9                   	leave  
  8012a8:	c3                   	ret    

008012a9 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8012af:	83 ec 04             	sub    $0x4,%esp
  8012b2:	68 a8 44 80 00       	push   $0x8044a8
  8012b7:	68 3f 01 00 00       	push   $0x13f
  8012bc:	68 ca 44 80 00       	push   $0x8044ca
  8012c1:	e8 a9 ef ff ff       	call   80026f <_panic>

008012c6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012c6:	55                   	push   %ebp
  8012c7:	89 e5                	mov    %esp,%ebp
  8012c9:	57                   	push   %edi
  8012ca:	56                   	push   %esi
  8012cb:	53                   	push   %ebx
  8012cc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012d8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012db:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012de:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012e1:	cd 30                	int    $0x30
  8012e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012e9:	83 c4 10             	add    $0x10,%esp
  8012ec:	5b                   	pop    %ebx
  8012ed:	5e                   	pop    %esi
  8012ee:	5f                   	pop    %edi
  8012ef:	5d                   	pop    %ebp
  8012f0:	c3                   	ret    

008012f1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	83 ec 04             	sub    $0x4,%esp
  8012f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012fd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	6a 00                	push   $0x0
  801306:	6a 00                	push   $0x0
  801308:	52                   	push   %edx
  801309:	ff 75 0c             	pushl  0xc(%ebp)
  80130c:	50                   	push   %eax
  80130d:	6a 00                	push   $0x0
  80130f:	e8 b2 ff ff ff       	call   8012c6 <syscall>
  801314:	83 c4 18             	add    $0x18,%esp
}
  801317:	90                   	nop
  801318:	c9                   	leave  
  801319:	c3                   	ret    

0080131a <sys_cgetc>:

int
sys_cgetc(void)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80131d:	6a 00                	push   $0x0
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	6a 00                	push   $0x0
  801325:	6a 00                	push   $0x0
  801327:	6a 02                	push   $0x2
  801329:	e8 98 ff ff ff       	call   8012c6 <syscall>
  80132e:	83 c4 18             	add    $0x18,%esp
}
  801331:	c9                   	leave  
  801332:	c3                   	ret    

00801333 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801336:	6a 00                	push   $0x0
  801338:	6a 00                	push   $0x0
  80133a:	6a 00                	push   $0x0
  80133c:	6a 00                	push   $0x0
  80133e:	6a 00                	push   $0x0
  801340:	6a 03                	push   $0x3
  801342:	e8 7f ff ff ff       	call   8012c6 <syscall>
  801347:	83 c4 18             	add    $0x18,%esp
}
  80134a:	90                   	nop
  80134b:	c9                   	leave  
  80134c:	c3                   	ret    

0080134d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80134d:	55                   	push   %ebp
  80134e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801350:	6a 00                	push   $0x0
  801352:	6a 00                	push   $0x0
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	6a 00                	push   $0x0
  80135a:	6a 04                	push   $0x4
  80135c:	e8 65 ff ff ff       	call   8012c6 <syscall>
  801361:	83 c4 18             	add    $0x18,%esp
}
  801364:	90                   	nop
  801365:	c9                   	leave  
  801366:	c3                   	ret    

00801367 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80136a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136d:	8b 45 08             	mov    0x8(%ebp),%eax
  801370:	6a 00                	push   $0x0
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	52                   	push   %edx
  801377:	50                   	push   %eax
  801378:	6a 08                	push   $0x8
  80137a:	e8 47 ff ff ff       	call   8012c6 <syscall>
  80137f:	83 c4 18             	add    $0x18,%esp
}
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
  801387:	56                   	push   %esi
  801388:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801389:	8b 75 18             	mov    0x18(%ebp),%esi
  80138c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80138f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801392:	8b 55 0c             	mov    0xc(%ebp),%edx
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	56                   	push   %esi
  801399:	53                   	push   %ebx
  80139a:	51                   	push   %ecx
  80139b:	52                   	push   %edx
  80139c:	50                   	push   %eax
  80139d:	6a 09                	push   $0x9
  80139f:	e8 22 ff ff ff       	call   8012c6 <syscall>
  8013a4:	83 c4 18             	add    $0x18,%esp
}
  8013a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013aa:	5b                   	pop    %ebx
  8013ab:	5e                   	pop    %esi
  8013ac:	5d                   	pop    %ebp
  8013ad:	c3                   	ret    

008013ae <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	52                   	push   %edx
  8013be:	50                   	push   %eax
  8013bf:	6a 0a                	push   $0xa
  8013c1:	e8 00 ff ff ff       	call   8012c6 <syscall>
  8013c6:	83 c4 18             	add    $0x18,%esp
}
  8013c9:	c9                   	leave  
  8013ca:	c3                   	ret    

008013cb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013ce:	6a 00                	push   $0x0
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 00                	push   $0x0
  8013d4:	ff 75 0c             	pushl  0xc(%ebp)
  8013d7:	ff 75 08             	pushl  0x8(%ebp)
  8013da:	6a 0b                	push   $0xb
  8013dc:	e8 e5 fe ff ff       	call   8012c6 <syscall>
  8013e1:	83 c4 18             	add    $0x18,%esp
}
  8013e4:	c9                   	leave  
  8013e5:	c3                   	ret    

008013e6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013e6:	55                   	push   %ebp
  8013e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 0c                	push   $0xc
  8013f5:	e8 cc fe ff ff       	call   8012c6 <syscall>
  8013fa:	83 c4 18             	add    $0x18,%esp
}
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801402:	6a 00                	push   $0x0
  801404:	6a 00                	push   $0x0
  801406:	6a 00                	push   $0x0
  801408:	6a 00                	push   $0x0
  80140a:	6a 00                	push   $0x0
  80140c:	6a 0d                	push   $0xd
  80140e:	e8 b3 fe ff ff       	call   8012c6 <syscall>
  801413:	83 c4 18             	add    $0x18,%esp
}
  801416:	c9                   	leave  
  801417:	c3                   	ret    

00801418 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80141b:	6a 00                	push   $0x0
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	6a 00                	push   $0x0
  801423:	6a 00                	push   $0x0
  801425:	6a 0e                	push   $0xe
  801427:	e8 9a fe ff ff       	call   8012c6 <syscall>
  80142c:	83 c4 18             	add    $0x18,%esp
}
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	6a 00                	push   $0x0
  80143a:	6a 00                	push   $0x0
  80143c:	6a 00                	push   $0x0
  80143e:	6a 0f                	push   $0xf
  801440:	e8 81 fe ff ff       	call   8012c6 <syscall>
  801445:	83 c4 18             	add    $0x18,%esp
}
  801448:	c9                   	leave  
  801449:	c3                   	ret    

0080144a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80144d:	6a 00                	push   $0x0
  80144f:	6a 00                	push   $0x0
  801451:	6a 00                	push   $0x0
  801453:	6a 00                	push   $0x0
  801455:	ff 75 08             	pushl  0x8(%ebp)
  801458:	6a 10                	push   $0x10
  80145a:	e8 67 fe ff ff       	call   8012c6 <syscall>
  80145f:	83 c4 18             	add    $0x18,%esp
}
  801462:	c9                   	leave  
  801463:	c3                   	ret    

00801464 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801467:	6a 00                	push   $0x0
  801469:	6a 00                	push   $0x0
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 11                	push   $0x11
  801473:	e8 4e fe ff ff       	call   8012c6 <syscall>
  801478:	83 c4 18             	add    $0x18,%esp
}
  80147b:	90                   	nop
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <sys_cputc>:

void
sys_cputc(const char c)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	83 ec 04             	sub    $0x4,%esp
  801484:	8b 45 08             	mov    0x8(%ebp),%eax
  801487:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80148a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	6a 00                	push   $0x0
  801494:	6a 00                	push   $0x0
  801496:	50                   	push   %eax
  801497:	6a 01                	push   $0x1
  801499:	e8 28 fe ff ff       	call   8012c6 <syscall>
  80149e:	83 c4 18             	add    $0x18,%esp
}
  8014a1:	90                   	nop
  8014a2:	c9                   	leave  
  8014a3:	c3                   	ret    

008014a4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 14                	push   $0x14
  8014b3:	e8 0e fe ff ff       	call   8012c6 <syscall>
  8014b8:	83 c4 18             	add    $0x18,%esp
}
  8014bb:	90                   	nop
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    

008014be <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	83 ec 04             	sub    $0x4,%esp
  8014c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014ca:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014cd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	6a 00                	push   $0x0
  8014d6:	51                   	push   %ecx
  8014d7:	52                   	push   %edx
  8014d8:	ff 75 0c             	pushl  0xc(%ebp)
  8014db:	50                   	push   %eax
  8014dc:	6a 15                	push   $0x15
  8014de:	e8 e3 fd ff ff       	call   8012c6 <syscall>
  8014e3:	83 c4 18             	add    $0x18,%esp
}
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    

008014e8 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	52                   	push   %edx
  8014f8:	50                   	push   %eax
  8014f9:	6a 16                	push   $0x16
  8014fb:	e8 c6 fd ff ff       	call   8012c6 <syscall>
  801500:	83 c4 18             	add    $0x18,%esp
}
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801508:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80150b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150e:	8b 45 08             	mov    0x8(%ebp),%eax
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	51                   	push   %ecx
  801516:	52                   	push   %edx
  801517:	50                   	push   %eax
  801518:	6a 17                	push   $0x17
  80151a:	e8 a7 fd ff ff       	call   8012c6 <syscall>
  80151f:	83 c4 18             	add    $0x18,%esp
}
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801527:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	52                   	push   %edx
  801534:	50                   	push   %eax
  801535:	6a 18                	push   $0x18
  801537:	e8 8a fd ff ff       	call   8012c6 <syscall>
  80153c:	83 c4 18             	add    $0x18,%esp
}
  80153f:	c9                   	leave  
  801540:	c3                   	ret    

00801541 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	6a 00                	push   $0x0
  801549:	ff 75 14             	pushl  0x14(%ebp)
  80154c:	ff 75 10             	pushl  0x10(%ebp)
  80154f:	ff 75 0c             	pushl  0xc(%ebp)
  801552:	50                   	push   %eax
  801553:	6a 19                	push   $0x19
  801555:	e8 6c fd ff ff       	call   8012c6 <syscall>
  80155a:	83 c4 18             	add    $0x18,%esp
}
  80155d:	c9                   	leave  
  80155e:	c3                   	ret    

0080155f <sys_run_env>:

void sys_run_env(int32 envId)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	50                   	push   %eax
  80156e:	6a 1a                	push   $0x1a
  801570:	e8 51 fd ff ff       	call   8012c6 <syscall>
  801575:	83 c4 18             	add    $0x18,%esp
}
  801578:	90                   	nop
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80157e:	8b 45 08             	mov    0x8(%ebp),%eax
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	50                   	push   %eax
  80158a:	6a 1b                	push   $0x1b
  80158c:	e8 35 fd ff ff       	call   8012c6 <syscall>
  801591:	83 c4 18             	add    $0x18,%esp
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 05                	push   $0x5
  8015a5:	e8 1c fd ff ff       	call   8012c6 <syscall>
  8015aa:	83 c4 18             	add    $0x18,%esp
}
  8015ad:	c9                   	leave  
  8015ae:	c3                   	ret    

008015af <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 06                	push   $0x6
  8015be:	e8 03 fd ff ff       	call   8012c6 <syscall>
  8015c3:	83 c4 18             	add    $0x18,%esp
}
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 07                	push   $0x7
  8015d7:	e8 ea fc ff ff       	call   8012c6 <syscall>
  8015dc:	83 c4 18             	add    $0x18,%esp
}
  8015df:	c9                   	leave  
  8015e0:	c3                   	ret    

008015e1 <sys_exit_env>:


void sys_exit_env(void)
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 1c                	push   $0x1c
  8015f0:	e8 d1 fc ff ff       	call   8012c6 <syscall>
  8015f5:	83 c4 18             	add    $0x18,%esp
}
  8015f8:	90                   	nop
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    

008015fb <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801601:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801604:	8d 50 04             	lea    0x4(%eax),%edx
  801607:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	52                   	push   %edx
  801611:	50                   	push   %eax
  801612:	6a 1d                	push   $0x1d
  801614:	e8 ad fc ff ff       	call   8012c6 <syscall>
  801619:	83 c4 18             	add    $0x18,%esp
	return result;
  80161c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80161f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801622:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801625:	89 01                	mov    %eax,(%ecx)
  801627:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80162a:	8b 45 08             	mov    0x8(%ebp),%eax
  80162d:	c9                   	leave  
  80162e:	c2 04 00             	ret    $0x4

00801631 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	ff 75 10             	pushl  0x10(%ebp)
  80163b:	ff 75 0c             	pushl  0xc(%ebp)
  80163e:	ff 75 08             	pushl  0x8(%ebp)
  801641:	6a 13                	push   $0x13
  801643:	e8 7e fc ff ff       	call   8012c6 <syscall>
  801648:	83 c4 18             	add    $0x18,%esp
	return ;
  80164b:	90                   	nop
}
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    

0080164e <sys_rcr2>:
uint32 sys_rcr2()
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 1e                	push   $0x1e
  80165d:	e8 64 fc ff ff       	call   8012c6 <syscall>
  801662:	83 c4 18             	add    $0x18,%esp
}
  801665:	c9                   	leave  
  801666:	c3                   	ret    

00801667 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
  80166a:	83 ec 04             	sub    $0x4,%esp
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801673:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	50                   	push   %eax
  801680:	6a 1f                	push   $0x1f
  801682:	e8 3f fc ff ff       	call   8012c6 <syscall>
  801687:	83 c4 18             	add    $0x18,%esp
	return ;
  80168a:	90                   	nop
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <rsttst>:
void rsttst()
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 21                	push   $0x21
  80169c:	e8 25 fc ff ff       	call   8012c6 <syscall>
  8016a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8016a4:	90                   	nop
}
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	83 ec 04             	sub    $0x4,%esp
  8016ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8016b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016b3:	8b 55 18             	mov    0x18(%ebp),%edx
  8016b6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016ba:	52                   	push   %edx
  8016bb:	50                   	push   %eax
  8016bc:	ff 75 10             	pushl  0x10(%ebp)
  8016bf:	ff 75 0c             	pushl  0xc(%ebp)
  8016c2:	ff 75 08             	pushl  0x8(%ebp)
  8016c5:	6a 20                	push   $0x20
  8016c7:	e8 fa fb ff ff       	call   8012c6 <syscall>
  8016cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8016cf:	90                   	nop
}
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <chktst>:
void chktst(uint32 n)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	ff 75 08             	pushl  0x8(%ebp)
  8016e0:	6a 22                	push   $0x22
  8016e2:	e8 df fb ff ff       	call   8012c6 <syscall>
  8016e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ea:	90                   	nop
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <inctst>:

void inctst()
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 23                	push   $0x23
  8016fc:	e8 c5 fb ff ff       	call   8012c6 <syscall>
  801701:	83 c4 18             	add    $0x18,%esp
	return ;
  801704:	90                   	nop
}
  801705:	c9                   	leave  
  801706:	c3                   	ret    

00801707 <gettst>:
uint32 gettst()
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 24                	push   $0x24
  801716:	e8 ab fb ff ff       	call   8012c6 <syscall>
  80171b:	83 c4 18             	add    $0x18,%esp
}
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 25                	push   $0x25
  801732:	e8 8f fb ff ff       	call   8012c6 <syscall>
  801737:	83 c4 18             	add    $0x18,%esp
  80173a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80173d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801741:	75 07                	jne    80174a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801743:	b8 01 00 00 00       	mov    $0x1,%eax
  801748:	eb 05                	jmp    80174f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80174a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
  801754:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 25                	push   $0x25
  801763:	e8 5e fb ff ff       	call   8012c6 <syscall>
  801768:	83 c4 18             	add    $0x18,%esp
  80176b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80176e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801772:	75 07                	jne    80177b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801774:	b8 01 00 00 00       	mov    $0x1,%eax
  801779:	eb 05                	jmp    801780 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80177b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 25                	push   $0x25
  801794:	e8 2d fb ff ff       	call   8012c6 <syscall>
  801799:	83 c4 18             	add    $0x18,%esp
  80179c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80179f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017a3:	75 07                	jne    8017ac <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8017aa:	eb 05                	jmp    8017b1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 25                	push   $0x25
  8017c5:	e8 fc fa ff ff       	call   8012c6 <syscall>
  8017ca:	83 c4 18             	add    $0x18,%esp
  8017cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017d0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017d4:	75 07                	jne    8017dd <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8017db:	eb 05                	jmp    8017e2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    

008017e4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	ff 75 08             	pushl  0x8(%ebp)
  8017f2:	6a 26                	push   $0x26
  8017f4:	e8 cd fa ff ff       	call   8012c6 <syscall>
  8017f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8017fc:	90                   	nop
}
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801803:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801806:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801809:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180c:	8b 45 08             	mov    0x8(%ebp),%eax
  80180f:	6a 00                	push   $0x0
  801811:	53                   	push   %ebx
  801812:	51                   	push   %ecx
  801813:	52                   	push   %edx
  801814:	50                   	push   %eax
  801815:	6a 27                	push   $0x27
  801817:	e8 aa fa ff ff       	call   8012c6 <syscall>
  80181c:	83 c4 18             	add    $0x18,%esp
}
  80181f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801822:	c9                   	leave  
  801823:	c3                   	ret    

00801824 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801827:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182a:	8b 45 08             	mov    0x8(%ebp),%eax
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	52                   	push   %edx
  801834:	50                   	push   %eax
  801835:	6a 28                	push   $0x28
  801837:	e8 8a fa ff ff       	call   8012c6 <syscall>
  80183c:	83 c4 18             	add    $0x18,%esp
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801844:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801847:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	6a 00                	push   $0x0
  80184f:	51                   	push   %ecx
  801850:	ff 75 10             	pushl  0x10(%ebp)
  801853:	52                   	push   %edx
  801854:	50                   	push   %eax
  801855:	6a 29                	push   $0x29
  801857:	e8 6a fa ff ff       	call   8012c6 <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	ff 75 10             	pushl  0x10(%ebp)
  80186b:	ff 75 0c             	pushl  0xc(%ebp)
  80186e:	ff 75 08             	pushl  0x8(%ebp)
  801871:	6a 12                	push   $0x12
  801873:	e8 4e fa ff ff       	call   8012c6 <syscall>
  801878:	83 c4 18             	add    $0x18,%esp
	return ;
  80187b:	90                   	nop
}
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    

0080187e <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801881:	8b 55 0c             	mov    0xc(%ebp),%edx
  801884:	8b 45 08             	mov    0x8(%ebp),%eax
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	52                   	push   %edx
  80188e:	50                   	push   %eax
  80188f:	6a 2a                	push   $0x2a
  801891:	e8 30 fa ff ff       	call   8012c6 <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
	return;
  801899:	90                   	nop
}
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	50                   	push   %eax
  8018ab:	6a 2b                	push   $0x2b
  8018ad:	e8 14 fa ff ff       	call   8012c6 <syscall>
  8018b2:	83 c4 18             	add    $0x18,%esp
}
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	ff 75 0c             	pushl  0xc(%ebp)
  8018c3:	ff 75 08             	pushl  0x8(%ebp)
  8018c6:	6a 2c                	push   $0x2c
  8018c8:	e8 f9 f9 ff ff       	call   8012c6 <syscall>
  8018cd:	83 c4 18             	add    $0x18,%esp
	return;
  8018d0:	90                   	nop
}
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	ff 75 0c             	pushl  0xc(%ebp)
  8018df:	ff 75 08             	pushl  0x8(%ebp)
  8018e2:	6a 2d                	push   $0x2d
  8018e4:	e8 dd f9 ff ff       	call   8012c6 <syscall>
  8018e9:	83 c4 18             	add    $0x18,%esp
	return;
  8018ec:	90                   	nop
}
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 2e                	push   $0x2e
  801901:	e8 c0 f9 ff ff       	call   8012c6 <syscall>
  801906:	83 c4 18             	add    $0x18,%esp
  801909:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  80190c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  801914:	8b 45 08             	mov    0x8(%ebp),%eax
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	50                   	push   %eax
  801920:	6a 2f                	push   $0x2f
  801922:	e8 9f f9 ff ff       	call   8012c6 <syscall>
  801927:	83 c4 18             	add    $0x18,%esp
	return;
  80192a:	90                   	nop
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  801930:	8b 55 0c             	mov    0xc(%ebp),%edx
  801933:	8b 45 08             	mov    0x8(%ebp),%eax
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	52                   	push   %edx
  80193d:	50                   	push   %eax
  80193e:	6a 30                	push   $0x30
  801940:	e8 81 f9 ff ff       	call   8012c6 <syscall>
  801945:	83 c4 18             	add    $0x18,%esp
	return;
  801948:	90                   	nop
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  801951:	8b 45 08             	mov    0x8(%ebp),%eax
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	50                   	push   %eax
  80195d:	6a 31                	push   $0x31
  80195f:	e8 62 f9 ff ff       	call   8012c6 <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
  801967:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  80196a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	50                   	push   %eax
  80197e:	6a 32                	push   $0x32
  801980:	e8 41 f9 ff ff       	call   8012c6 <syscall>
  801985:	83 c4 18             	add    $0x18,%esp
	return;
  801988:	90                   	nop
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("create_semaphore is not implemented yet");
	//Your Code is Here...

		void* ret = smalloc(semaphoreName, sizeof(struct semaphore), 1);
  801991:	83 ec 04             	sub    $0x4,%esp
  801994:	6a 01                	push   $0x1
  801996:	6a 04                	push   $0x4
  801998:	ff 75 0c             	pushl  0xc(%ebp)
  80199b:	e8 91 05 00 00       	call   801f31 <smalloc>
  8019a0:	83 c4 10             	add    $0x10,%esp
  8019a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if (ret == NULL ) panic("no memory in creat_semaphore");
  8019a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019aa:	75 14                	jne    8019c0 <create_semaphore+0x35>
  8019ac:	83 ec 04             	sub    $0x4,%esp
  8019af:	68 d7 44 80 00       	push   $0x8044d7
  8019b4:	6a 0d                	push   $0xd
  8019b6:	68 f4 44 80 00       	push   $0x8044f4
  8019bb:	e8 af e8 ff ff       	call   80026f <_panic>

	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  8019c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c3:	89 45 f0             	mov    %eax,-0x10(%ebp)

	    sem_ptr->semdata->count = value;
  8019c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c9:	8b 00                	mov    (%eax),%eax
  8019cb:	8b 55 10             	mov    0x10(%ebp),%edx
  8019ce:	89 50 10             	mov    %edx,0x10(%eax)
	    sys_init_queue(&(sem_ptr->semdata->queue));
  8019d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d4:	8b 00                	mov    (%eax),%eax
  8019d6:	83 ec 0c             	sub    $0xc,%esp
  8019d9:	50                   	push   %eax
  8019da:	e8 32 ff ff ff       	call   801911 <sys_init_queue>
  8019df:	83 c4 10             	add    $0x10,%esp

	    sem_ptr->semdata->lock = 0;
  8019e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e5:	8b 00                	mov    (%eax),%eax
  8019e7:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

	    return *sem_ptr;
  8019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019f4:	8b 12                	mov    (%edx),%edx
  8019f6:	89 10                	mov    %edx,(%eax)
}
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	c9                   	leave  
  8019fc:	c2 04 00             	ret    $0x4

008019ff <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("get_semaphore is not implemented yet");
	//Your Code is Here...
		void* ret = sget(ownerEnvID, semaphoreName);
  801a05:	83 ec 08             	sub    $0x8,%esp
  801a08:	ff 75 10             	pushl  0x10(%ebp)
  801a0b:	ff 75 0c             	pushl  0xc(%ebp)
  801a0e:	e8 c3 05 00 00       	call   801fd6 <sget>
  801a13:	83 c4 10             	add    $0x10,%esp
  801a16:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (ret == NULL ) panic("no semaphore in get_semaphore");
  801a19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a1d:	75 14                	jne    801a33 <get_semaphore+0x34>
  801a1f:	83 ec 04             	sub    $0x4,%esp
  801a22:	68 04 45 80 00       	push   $0x804504
  801a27:	6a 1f                	push   $0x1f
  801a29:	68 f4 44 80 00       	push   $0x8044f4
  801a2e:	e8 3c e8 ff ff       	call   80026f <_panic>
	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  801a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    return *sem_ptr;
  801a39:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a3f:	8b 12                	mov    (%edx),%edx
  801a41:	89 10                	mov    %edx,(%eax)
}
  801a43:	8b 45 08             	mov    0x8(%ebp),%eax
  801a46:	c9                   	leave  
  801a47:	c2 04 00             	ret    $0x4

00801a4a <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
  801a4d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("wait_semaphore is not implemented yet");
	//Your Code is Here...
			uint32 key = 1;
  801a50:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
		    do { xchg(&sem.semdata->lock,key); } while (key != 0);
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	83 c0 14             	add    $0x14,%eax
  801a5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a63:	89 45 e8             	mov    %eax,-0x18(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  801a66:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a6c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  801a6f:	f0 87 02             	lock xchg %eax,(%edx)
  801a72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a79:	75 dc                	jne    801a57 <wait_semaphore+0xd>

		    sem.semdata->count--;
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	8b 50 10             	mov    0x10(%eax),%edx
  801a81:	4a                   	dec    %edx
  801a82:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count < 0) {
  801a85:	8b 45 08             	mov    0x8(%ebp),%eax
  801a88:	8b 40 10             	mov    0x10(%eax),%eax
  801a8b:	85 c0                	test   %eax,%eax
  801a8d:	79 30                	jns    801abf <wait_semaphore+0x75>

	    	struct Env* cur_env = sys_get_cpu_process();
  801a8f:	e8 5b fe ff ff       	call   8018ef <sys_get_cpu_process>
  801a94:	89 45 f0             	mov    %eax,-0x10(%ebp)

//	    	acquire_spinlock(&ProcessQueues.qlock); //acquire procque
	        sys_enqueue(&(sem.semdata->queue),cur_env);  // Add process to waiting queue
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	83 ec 08             	sub    $0x8,%esp
  801a9d:	ff 75 f0             	pushl  -0x10(%ebp)
  801aa0:	50                   	push   %eax
  801aa1:	e8 87 fe ff ff       	call   80192d <sys_enqueue>
  801aa6:	83 c4 10             	add    $0x10,%esp
	        cur_env->env_status= ENV_BLOCKED;
  801aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aac:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%eax)
	        sem.semdata->lock = 0;
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;

}
  801abd:	eb 0a                	jmp    801ac9 <wait_semaphore+0x7f>
	        cur_env->env_status= ENV_BLOCKED;
	        sem.semdata->lock = 0;
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;
  801abf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac2:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

}
  801ac9:	90                   	nop
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("signal_semaphore is not implemented yet");
	//Your Code is Here...
		uint32 key = 1;
  801ad2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	    do { xchg(&sem.semdata->lock,key ); } while (key != 0);
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	83 c0 14             	add    $0x14,%eax
  801adf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801ae8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801aeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801aee:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  801af1:	f0 87 02             	lock xchg %eax,(%edx)
  801af4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801af7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801afb:	75 dc                	jne    801ad9 <signal_semaphore+0xd>
	    sem.semdata->count++;
  801afd:	8b 45 08             	mov    0x8(%ebp),%eax
  801b00:	8b 50 10             	mov    0x10(%eax),%edx
  801b03:	42                   	inc    %edx
  801b04:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count <= 0) {
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	8b 40 10             	mov    0x10(%eax),%eax
  801b0d:	85 c0                	test   %eax,%eax
  801b0f:	7f 20                	jg     801b31 <signal_semaphore+0x65>
	        struct Env* env = sys_dequeue(&(sem.semdata->queue)) ;
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	83 ec 0c             	sub    $0xc,%esp
  801b17:	50                   	push   %eax
  801b18:	e8 2e fe ff ff       	call   80194b <sys_dequeue>
  801b1d:	83 c4 10             	add    $0x10,%esp
  801b20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	        sys_sched_insert_ready(env);
  801b23:	83 ec 0c             	sub    $0xc,%esp
  801b26:	ff 75 f0             	pushl  -0x10(%ebp)
  801b29:	e8 41 fe ff ff       	call   80196f <sys_sched_insert_ready>
  801b2e:	83 c4 10             	add    $0x10,%esp
	    }
	    sem.semdata->lock = 0;
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  801b3b:	90                   	nop
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801b41:	8b 45 08             	mov    0x8(%ebp),%eax
  801b44:	8b 40 10             	mov    0x10(%eax),%eax
}
  801b47:	5d                   	pop    %ebp
  801b48:	c3                   	ret    

00801b49 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801b4f:	8b 55 08             	mov    0x8(%ebp),%edx
  801b52:	89 d0                	mov    %edx,%eax
  801b54:	c1 e0 02             	shl    $0x2,%eax
  801b57:	01 d0                	add    %edx,%eax
  801b59:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b60:	01 d0                	add    %edx,%eax
  801b62:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b69:	01 d0                	add    %edx,%eax
  801b6b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b72:	01 d0                	add    %edx,%eax
  801b74:	c1 e0 04             	shl    $0x4,%eax
  801b77:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801b7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801b81:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801b84:	83 ec 0c             	sub    $0xc,%esp
  801b87:	50                   	push   %eax
  801b88:	e8 6e fa ff ff       	call   8015fb <sys_get_virtual_time>
  801b8d:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801b90:	eb 41                	jmp    801bd3 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801b92:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801b95:	83 ec 0c             	sub    $0xc,%esp
  801b98:	50                   	push   %eax
  801b99:	e8 5d fa ff ff       	call   8015fb <sys_get_virtual_time>
  801b9e:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801ba1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ba4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ba7:	29 c2                	sub    %eax,%edx
  801ba9:	89 d0                	mov    %edx,%eax
  801bab:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801bae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bb4:	89 d1                	mov    %edx,%ecx
  801bb6:	29 c1                	sub    %eax,%ecx
  801bb8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801bbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bbe:	39 c2                	cmp    %eax,%edx
  801bc0:	0f 97 c0             	seta   %al
  801bc3:	0f b6 c0             	movzbl %al,%eax
  801bc6:	29 c1                	sub    %eax,%ecx
  801bc8:	89 c8                	mov    %ecx,%eax
  801bca:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801bcd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801bd9:	72 b7                	jb     801b92 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801bdb:	90                   	nop
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801be4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801beb:	eb 03                	jmp    801bf0 <busy_wait+0x12>
  801bed:	ff 45 fc             	incl   -0x4(%ebp)
  801bf0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bf3:	3b 45 08             	cmp    0x8(%ebp),%eax
  801bf6:	72 f5                	jb     801bed <busy_wait+0xf>
	return i;
  801bf8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
  801c00:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801c03:	83 ec 0c             	sub    $0xc,%esp
  801c06:	ff 75 08             	pushl  0x8(%ebp)
  801c09:	e8 8e fc ff ff       	call   80189c <sys_sbrk>
  801c0e:	83 c4 10             	add    $0x10,%esp
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801c19:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c1d:	75 0a                	jne    801c29 <malloc+0x16>
  801c1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c24:	e9 07 02 00 00       	jmp    801e30 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801c29:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801c30:	8b 55 08             	mov    0x8(%ebp),%edx
  801c33:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c36:	01 d0                	add    %edx,%eax
  801c38:	48                   	dec    %eax
  801c39:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801c3c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c3f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c44:	f7 75 dc             	divl   -0x24(%ebp)
  801c47:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c4a:	29 d0                	sub    %edx,%eax
  801c4c:	c1 e8 0c             	shr    $0xc,%eax
  801c4f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801c52:	a1 20 50 80 00       	mov    0x805020,%eax
  801c57:	8b 40 78             	mov    0x78(%eax),%eax
  801c5a:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801c5f:	29 c2                	sub    %eax,%edx
  801c61:	89 d0                	mov    %edx,%eax
  801c63:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801c66:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801c69:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c6e:	c1 e8 0c             	shr    $0xc,%eax
  801c71:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801c74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801c7b:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801c82:	77 42                	ja     801cc6 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801c84:	e8 97 fa ff ff       	call   801720 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c89:	85 c0                	test   %eax,%eax
  801c8b:	74 16                	je     801ca3 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  801c8d:	83 ec 0c             	sub    $0xc,%esp
  801c90:	ff 75 08             	pushl  0x8(%ebp)
  801c93:	e8 18 08 00 00       	call   8024b0 <alloc_block_FF>
  801c98:	83 c4 10             	add    $0x10,%esp
  801c9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c9e:	e9 8a 01 00 00       	jmp    801e2d <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801ca3:	e8 a9 fa ff ff       	call   801751 <sys_isUHeapPlacementStrategyBESTFIT>
  801ca8:	85 c0                	test   %eax,%eax
  801caa:	0f 84 7d 01 00 00    	je     801e2d <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801cb0:	83 ec 0c             	sub    $0xc,%esp
  801cb3:	ff 75 08             	pushl  0x8(%ebp)
  801cb6:	e8 b1 0c 00 00       	call   80296c <alloc_block_BF>
  801cbb:	83 c4 10             	add    $0x10,%esp
  801cbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cc1:	e9 67 01 00 00       	jmp    801e2d <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801cc6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801cc9:	48                   	dec    %eax
  801cca:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ccd:	0f 86 53 01 00 00    	jbe    801e26 <malloc+0x213>
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801cd3:	a1 20 50 80 00       	mov    0x805020,%eax
  801cd8:	8b 40 78             	mov    0x78(%eax),%eax
  801cdb:	05 00 10 00 00       	add    $0x1000,%eax
  801ce0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801ce3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801cea:	e9 de 00 00 00       	jmp    801dcd <malloc+0x1ba>
		{
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801cef:	a1 20 50 80 00       	mov    0x805020,%eax
  801cf4:	8b 40 78             	mov    0x78(%eax),%eax
  801cf7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cfa:	29 c2                	sub    %eax,%edx
  801cfc:	89 d0                	mov    %edx,%eax
  801cfe:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d03:	c1 e8 0c             	shr    $0xc,%eax
  801d06:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801d0d:	85 c0                	test   %eax,%eax
  801d0f:	0f 85 ab 00 00 00    	jne    801dc0 <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d18:	05 00 10 00 00       	add    $0x1000,%eax
  801d1d:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801d20:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
				while(cnt < num_pages - 1)
  801d27:	eb 47                	jmp    801d70 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801d29:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801d30:	76 0a                	jbe    801d3c <malloc+0x129>
  801d32:	b8 00 00 00 00       	mov    $0x0,%eax
  801d37:	e9 f4 00 00 00       	jmp    801e30 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801d3c:	a1 20 50 80 00       	mov    0x805020,%eax
  801d41:	8b 40 78             	mov    0x78(%eax),%eax
  801d44:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d47:	29 c2                	sub    %eax,%edx
  801d49:	89 d0                	mov    %edx,%eax
  801d4b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d50:	c1 e8 0c             	shr    $0xc,%eax
  801d53:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801d5a:	85 c0                	test   %eax,%eax
  801d5c:	74 08                	je     801d66 <malloc+0x153>
					{
						
						i = j;
  801d5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d61:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801d64:	eb 5a                	jmp    801dc0 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801d66:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801d6d:	ff 45 e4             	incl   -0x1c(%ebp)
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
				while(cnt < num_pages - 1)
  801d70:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d73:	48                   	dec    %eax
  801d74:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801d77:	77 b0                	ja     801d29 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801d79:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801d80:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801d87:	eb 2f                	jmp    801db8 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801d89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d8c:	c1 e0 0c             	shl    $0xc,%eax
  801d8f:	89 c2                	mov    %eax,%edx
  801d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d94:	01 c2                	add    %eax,%edx
  801d96:	a1 20 50 80 00       	mov    0x805020,%eax
  801d9b:	8b 40 78             	mov    0x78(%eax),%eax
  801d9e:	29 c2                	sub    %eax,%edx
  801da0:	89 d0                	mov    %edx,%eax
  801da2:	2d 00 10 00 00       	sub    $0x1000,%eax
  801da7:	c1 e8 0c             	shr    $0xc,%eax
  801daa:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
  801db1:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801db5:	ff 45 e0             	incl   -0x20(%ebp)
  801db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dbb:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801dbe:	72 c9                	jb     801d89 <malloc+0x176>
				}
				

			}
			sayed:
			if(ok) break;
  801dc0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801dc4:	75 16                	jne    801ddc <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801dc6:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801dcd:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801dd4:	0f 86 15 ff ff ff    	jbe    801cef <malloc+0xdc>
  801dda:	eb 01                	jmp    801ddd <malloc+0x1ca>
				}
				

			}
			sayed:
			if(ok) break;
  801ddc:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801ddd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801de1:	75 07                	jne    801dea <malloc+0x1d7>
  801de3:	b8 00 00 00 00       	mov    $0x0,%eax
  801de8:	eb 46                	jmp    801e30 <malloc+0x21d>
		ptr = (void*)i;
  801dea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801df0:	a1 20 50 80 00       	mov    0x805020,%eax
  801df5:	8b 40 78             	mov    0x78(%eax),%eax
  801df8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dfb:	29 c2                	sub    %eax,%edx
  801dfd:	89 d0                	mov    %edx,%eax
  801dff:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e04:	c1 e8 0c             	shr    $0xc,%eax
  801e07:	89 c2                	mov    %eax,%edx
  801e09:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e0c:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801e13:	83 ec 08             	sub    $0x8,%esp
  801e16:	ff 75 08             	pushl  0x8(%ebp)
  801e19:	ff 75 f0             	pushl  -0x10(%ebp)
  801e1c:	e8 b2 fa ff ff       	call   8018d3 <sys_allocate_user_mem>
  801e21:	83 c4 10             	add    $0x10,%esp
  801e24:	eb 07                	jmp    801e2d <malloc+0x21a>
		
	}
	else
	{
		return NULL;
  801e26:	b8 00 00 00 00       	mov    $0x0,%eax
  801e2b:	eb 03                	jmp    801e30 <malloc+0x21d>
	}
	return ptr;
  801e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801e38:	a1 20 50 80 00       	mov    0x805020,%eax
  801e3d:	8b 40 78             	mov    0x78(%eax),%eax
  801e40:	05 00 10 00 00       	add    $0x1000,%eax
  801e45:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801e48:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801e4f:	a1 20 50 80 00       	mov    0x805020,%eax
  801e54:	8b 50 78             	mov    0x78(%eax),%edx
  801e57:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5a:	39 c2                	cmp    %eax,%edx
  801e5c:	76 24                	jbe    801e82 <free+0x50>
		size = get_block_size(va);
  801e5e:	83 ec 0c             	sub    $0xc,%esp
  801e61:	ff 75 08             	pushl  0x8(%ebp)
  801e64:	e8 c7 02 00 00       	call   802130 <get_block_size>
  801e69:	83 c4 10             	add    $0x10,%esp
  801e6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801e6f:	83 ec 0c             	sub    $0xc,%esp
  801e72:	ff 75 08             	pushl  0x8(%ebp)
  801e75:	e8 d7 14 00 00       	call   803351 <free_block>
  801e7a:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801e7d:	e9 ac 00 00 00       	jmp    801f2e <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e88:	0f 82 89 00 00 00    	jb     801f17 <free+0xe5>
  801e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e91:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801e96:	77 7f                	ja     801f17 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801e98:	8b 55 08             	mov    0x8(%ebp),%edx
  801e9b:	a1 20 50 80 00       	mov    0x805020,%eax
  801ea0:	8b 40 78             	mov    0x78(%eax),%eax
  801ea3:	29 c2                	sub    %eax,%edx
  801ea5:	89 d0                	mov    %edx,%eax
  801ea7:	2d 00 10 00 00       	sub    $0x1000,%eax
  801eac:	c1 e8 0c             	shr    $0xc,%eax
  801eaf:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  801eb6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801eb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ebc:	c1 e0 0c             	shl    $0xc,%eax
  801ebf:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801ec2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ec9:	eb 42                	jmp    801f0d <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ece:	c1 e0 0c             	shl    $0xc,%eax
  801ed1:	89 c2                	mov    %eax,%edx
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	01 c2                	add    %eax,%edx
  801ed8:	a1 20 50 80 00       	mov    0x805020,%eax
  801edd:	8b 40 78             	mov    0x78(%eax),%eax
  801ee0:	29 c2                	sub    %eax,%edx
  801ee2:	89 d0                	mov    %edx,%eax
  801ee4:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ee9:	c1 e8 0c             	shr    $0xc,%eax
  801eec:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801ef3:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801ef7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801efa:	8b 45 08             	mov    0x8(%ebp),%eax
  801efd:	83 ec 08             	sub    $0x8,%esp
  801f00:	52                   	push   %edx
  801f01:	50                   	push   %eax
  801f02:	e8 b0 f9 ff ff       	call   8018b7 <sys_free_user_mem>
  801f07:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801f0a:	ff 45 f4             	incl   -0xc(%ebp)
  801f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f10:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801f13:	72 b6                	jb     801ecb <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801f15:	eb 17                	jmp    801f2e <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801f17:	83 ec 04             	sub    $0x4,%esp
  801f1a:	68 24 45 80 00       	push   $0x804524
  801f1f:	68 87 00 00 00       	push   $0x87
  801f24:	68 4e 45 80 00       	push   $0x80454e
  801f29:	e8 41 e3 ff ff       	call   80026f <_panic>
	}
}
  801f2e:	90                   	nop
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	83 ec 28             	sub    $0x28,%esp
  801f37:	8b 45 10             	mov    0x10(%ebp),%eax
  801f3a:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801f3d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f41:	75 0a                	jne    801f4d <smalloc+0x1c>
  801f43:	b8 00 00 00 00       	mov    $0x0,%eax
  801f48:	e9 87 00 00 00       	jmp    801fd4 <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f53:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f60:	39 d0                	cmp    %edx,%eax
  801f62:	73 02                	jae    801f66 <smalloc+0x35>
  801f64:	89 d0                	mov    %edx,%eax
  801f66:	83 ec 0c             	sub    $0xc,%esp
  801f69:	50                   	push   %eax
  801f6a:	e8 a4 fc ff ff       	call   801c13 <malloc>
  801f6f:	83 c4 10             	add    $0x10,%esp
  801f72:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801f75:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f79:	75 07                	jne    801f82 <smalloc+0x51>
  801f7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f80:	eb 52                	jmp    801fd4 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801f82:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801f86:	ff 75 ec             	pushl  -0x14(%ebp)
  801f89:	50                   	push   %eax
  801f8a:	ff 75 0c             	pushl  0xc(%ebp)
  801f8d:	ff 75 08             	pushl  0x8(%ebp)
  801f90:	e8 29 f5 ff ff       	call   8014be <sys_createSharedObject>
  801f95:	83 c4 10             	add    $0x10,%esp
  801f98:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801f9b:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801f9f:	74 06                	je     801fa7 <smalloc+0x76>
  801fa1:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801fa5:	75 07                	jne    801fae <smalloc+0x7d>
  801fa7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fac:	eb 26                	jmp    801fd4 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801fae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fb1:	a1 20 50 80 00       	mov    0x805020,%eax
  801fb6:	8b 40 78             	mov    0x78(%eax),%eax
  801fb9:	29 c2                	sub    %eax,%edx
  801fbb:	89 d0                	mov    %edx,%eax
  801fbd:	2d 00 10 00 00       	sub    $0x1000,%eax
  801fc2:	c1 e8 0c             	shr    $0xc,%eax
  801fc5:	89 c2                	mov    %eax,%edx
  801fc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fca:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801fd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801fd4:	c9                   	leave  
  801fd5:	c3                   	ret    

00801fd6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
  801fd9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801fdc:	83 ec 08             	sub    $0x8,%esp
  801fdf:	ff 75 0c             	pushl  0xc(%ebp)
  801fe2:	ff 75 08             	pushl  0x8(%ebp)
  801fe5:	e8 fe f4 ff ff       	call   8014e8 <sys_getSizeOfSharedObject>
  801fea:	83 c4 10             	add    $0x10,%esp
  801fed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801ff0:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801ff4:	75 07                	jne    801ffd <sget+0x27>
  801ff6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffb:	eb 7f                	jmp    80207c <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802000:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802003:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80200a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80200d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802010:	39 d0                	cmp    %edx,%eax
  802012:	73 02                	jae    802016 <sget+0x40>
  802014:	89 d0                	mov    %edx,%eax
  802016:	83 ec 0c             	sub    $0xc,%esp
  802019:	50                   	push   %eax
  80201a:	e8 f4 fb ff ff       	call   801c13 <malloc>
  80201f:	83 c4 10             	add    $0x10,%esp
  802022:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  802025:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802029:	75 07                	jne    802032 <sget+0x5c>
  80202b:	b8 00 00 00 00       	mov    $0x0,%eax
  802030:	eb 4a                	jmp    80207c <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  802032:	83 ec 04             	sub    $0x4,%esp
  802035:	ff 75 e8             	pushl  -0x18(%ebp)
  802038:	ff 75 0c             	pushl  0xc(%ebp)
  80203b:	ff 75 08             	pushl  0x8(%ebp)
  80203e:	e8 c2 f4 ff ff       	call   801505 <sys_getSharedObject>
  802043:	83 c4 10             	add    $0x10,%esp
  802046:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  802049:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80204c:	a1 20 50 80 00       	mov    0x805020,%eax
  802051:	8b 40 78             	mov    0x78(%eax),%eax
  802054:	29 c2                	sub    %eax,%edx
  802056:	89 d0                	mov    %edx,%eax
  802058:	2d 00 10 00 00       	sub    $0x1000,%eax
  80205d:	c1 e8 0c             	shr    $0xc,%eax
  802060:	89 c2                	mov    %eax,%edx
  802062:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802065:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80206c:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802070:	75 07                	jne    802079 <sget+0xa3>
  802072:	b8 00 00 00 00       	mov    $0x0,%eax
  802077:	eb 03                	jmp    80207c <sget+0xa6>
	return ptr;
  802079:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    

0080207e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
  802081:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  802084:	8b 55 08             	mov    0x8(%ebp),%edx
  802087:	a1 20 50 80 00       	mov    0x805020,%eax
  80208c:	8b 40 78             	mov    0x78(%eax),%eax
  80208f:	29 c2                	sub    %eax,%edx
  802091:	89 d0                	mov    %edx,%eax
  802093:	2d 00 10 00 00       	sub    $0x1000,%eax
  802098:	c1 e8 0c             	shr    $0xc,%eax
  80209b:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8020a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8020a5:	83 ec 08             	sub    $0x8,%esp
  8020a8:	ff 75 08             	pushl  0x8(%ebp)
  8020ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8020ae:	e8 71 f4 ff ff       	call   801524 <sys_freeSharedObject>
  8020b3:	83 c4 10             	add    $0x10,%esp
  8020b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8020b9:	90                   	nop
  8020ba:	c9                   	leave  
  8020bb:	c3                   	ret    

008020bc <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
  8020bf:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8020c2:	83 ec 04             	sub    $0x4,%esp
  8020c5:	68 5c 45 80 00       	push   $0x80455c
  8020ca:	68 e4 00 00 00       	push   $0xe4
  8020cf:	68 4e 45 80 00       	push   $0x80454e
  8020d4:	e8 96 e1 ff ff       	call   80026f <_panic>

008020d9 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
  8020dc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020df:	83 ec 04             	sub    $0x4,%esp
  8020e2:	68 82 45 80 00       	push   $0x804582
  8020e7:	68 f0 00 00 00       	push   $0xf0
  8020ec:	68 4e 45 80 00       	push   $0x80454e
  8020f1:	e8 79 e1 ff ff       	call   80026f <_panic>

008020f6 <shrink>:

}
void shrink(uint32 newSize)
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020fc:	83 ec 04             	sub    $0x4,%esp
  8020ff:	68 82 45 80 00       	push   $0x804582
  802104:	68 f5 00 00 00       	push   $0xf5
  802109:	68 4e 45 80 00       	push   $0x80454e
  80210e:	e8 5c e1 ff ff       	call   80026f <_panic>

00802113 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
  802116:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802119:	83 ec 04             	sub    $0x4,%esp
  80211c:	68 82 45 80 00       	push   $0x804582
  802121:	68 fa 00 00 00       	push   $0xfa
  802126:	68 4e 45 80 00       	push   $0x80454e
  80212b:	e8 3f e1 ff ff       	call   80026f <_panic>

00802130 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
  802133:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802136:	8b 45 08             	mov    0x8(%ebp),%eax
  802139:	83 e8 04             	sub    $0x4,%eax
  80213c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80213f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802142:	8b 00                	mov    (%eax),%eax
  802144:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802147:	c9                   	leave  
  802148:	c3                   	ret    

00802149 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80214f:	8b 45 08             	mov    0x8(%ebp),%eax
  802152:	83 e8 04             	sub    $0x4,%eax
  802155:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802158:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80215b:	8b 00                	mov    (%eax),%eax
  80215d:	83 e0 01             	and    $0x1,%eax
  802160:	85 c0                	test   %eax,%eax
  802162:	0f 94 c0             	sete   %al
}
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
  80216a:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80216d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802174:	8b 45 0c             	mov    0xc(%ebp),%eax
  802177:	83 f8 02             	cmp    $0x2,%eax
  80217a:	74 2b                	je     8021a7 <alloc_block+0x40>
  80217c:	83 f8 02             	cmp    $0x2,%eax
  80217f:	7f 07                	jg     802188 <alloc_block+0x21>
  802181:	83 f8 01             	cmp    $0x1,%eax
  802184:	74 0e                	je     802194 <alloc_block+0x2d>
  802186:	eb 58                	jmp    8021e0 <alloc_block+0x79>
  802188:	83 f8 03             	cmp    $0x3,%eax
  80218b:	74 2d                	je     8021ba <alloc_block+0x53>
  80218d:	83 f8 04             	cmp    $0x4,%eax
  802190:	74 3b                	je     8021cd <alloc_block+0x66>
  802192:	eb 4c                	jmp    8021e0 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802194:	83 ec 0c             	sub    $0xc,%esp
  802197:	ff 75 08             	pushl  0x8(%ebp)
  80219a:	e8 11 03 00 00       	call   8024b0 <alloc_block_FF>
  80219f:	83 c4 10             	add    $0x10,%esp
  8021a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021a5:	eb 4a                	jmp    8021f1 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8021a7:	83 ec 0c             	sub    $0xc,%esp
  8021aa:	ff 75 08             	pushl  0x8(%ebp)
  8021ad:	e8 c7 19 00 00       	call   803b79 <alloc_block_NF>
  8021b2:	83 c4 10             	add    $0x10,%esp
  8021b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021b8:	eb 37                	jmp    8021f1 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8021ba:	83 ec 0c             	sub    $0xc,%esp
  8021bd:	ff 75 08             	pushl  0x8(%ebp)
  8021c0:	e8 a7 07 00 00       	call   80296c <alloc_block_BF>
  8021c5:	83 c4 10             	add    $0x10,%esp
  8021c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021cb:	eb 24                	jmp    8021f1 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8021cd:	83 ec 0c             	sub    $0xc,%esp
  8021d0:	ff 75 08             	pushl  0x8(%ebp)
  8021d3:	e8 84 19 00 00       	call   803b5c <alloc_block_WF>
  8021d8:	83 c4 10             	add    $0x10,%esp
  8021db:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021de:	eb 11                	jmp    8021f1 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8021e0:	83 ec 0c             	sub    $0xc,%esp
  8021e3:	68 94 45 80 00       	push   $0x804594
  8021e8:	e8 3f e3 ff ff       	call   80052c <cprintf>
  8021ed:	83 c4 10             	add    $0x10,%esp
		break;
  8021f0:	90                   	nop
	}
	return va;
  8021f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
  8021f9:	53                   	push   %ebx
  8021fa:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8021fd:	83 ec 0c             	sub    $0xc,%esp
  802200:	68 b4 45 80 00       	push   $0x8045b4
  802205:	e8 22 e3 ff ff       	call   80052c <cprintf>
  80220a:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80220d:	83 ec 0c             	sub    $0xc,%esp
  802210:	68 df 45 80 00       	push   $0x8045df
  802215:	e8 12 e3 ff ff       	call   80052c <cprintf>
  80221a:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80221d:	8b 45 08             	mov    0x8(%ebp),%eax
  802220:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802223:	eb 37                	jmp    80225c <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802225:	83 ec 0c             	sub    $0xc,%esp
  802228:	ff 75 f4             	pushl  -0xc(%ebp)
  80222b:	e8 19 ff ff ff       	call   802149 <is_free_block>
  802230:	83 c4 10             	add    $0x10,%esp
  802233:	0f be d8             	movsbl %al,%ebx
  802236:	83 ec 0c             	sub    $0xc,%esp
  802239:	ff 75 f4             	pushl  -0xc(%ebp)
  80223c:	e8 ef fe ff ff       	call   802130 <get_block_size>
  802241:	83 c4 10             	add    $0x10,%esp
  802244:	83 ec 04             	sub    $0x4,%esp
  802247:	53                   	push   %ebx
  802248:	50                   	push   %eax
  802249:	68 f7 45 80 00       	push   $0x8045f7
  80224e:	e8 d9 e2 ff ff       	call   80052c <cprintf>
  802253:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802256:	8b 45 10             	mov    0x10(%ebp),%eax
  802259:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80225c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802260:	74 07                	je     802269 <print_blocks_list+0x73>
  802262:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802265:	8b 00                	mov    (%eax),%eax
  802267:	eb 05                	jmp    80226e <print_blocks_list+0x78>
  802269:	b8 00 00 00 00       	mov    $0x0,%eax
  80226e:	89 45 10             	mov    %eax,0x10(%ebp)
  802271:	8b 45 10             	mov    0x10(%ebp),%eax
  802274:	85 c0                	test   %eax,%eax
  802276:	75 ad                	jne    802225 <print_blocks_list+0x2f>
  802278:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227c:	75 a7                	jne    802225 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80227e:	83 ec 0c             	sub    $0xc,%esp
  802281:	68 b4 45 80 00       	push   $0x8045b4
  802286:	e8 a1 e2 ff ff       	call   80052c <cprintf>
  80228b:	83 c4 10             	add    $0x10,%esp

}
  80228e:	90                   	nop
  80228f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802292:	c9                   	leave  
  802293:	c3                   	ret    

00802294 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802294:	55                   	push   %ebp
  802295:	89 e5                	mov    %esp,%ebp
  802297:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80229a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229d:	83 e0 01             	and    $0x1,%eax
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	74 03                	je     8022a7 <initialize_dynamic_allocator+0x13>
  8022a4:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8022a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022ab:	0f 84 c7 01 00 00    	je     802478 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8022b1:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8022b8:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8022bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8022be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c1:	01 d0                	add    %edx,%eax
  8022c3:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8022c8:	0f 87 ad 01 00 00    	ja     80247b <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	85 c0                	test   %eax,%eax
  8022d3:	0f 89 a5 01 00 00    	jns    80247e <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8022d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8022dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022df:	01 d0                	add    %edx,%eax
  8022e1:	83 e8 04             	sub    $0x4,%eax
  8022e4:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8022e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8022f0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022f8:	e9 87 00 00 00       	jmp    802384 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8022fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802301:	75 14                	jne    802317 <initialize_dynamic_allocator+0x83>
  802303:	83 ec 04             	sub    $0x4,%esp
  802306:	68 0f 46 80 00       	push   $0x80460f
  80230b:	6a 79                	push   $0x79
  80230d:	68 2d 46 80 00       	push   $0x80462d
  802312:	e8 58 df ff ff       	call   80026f <_panic>
  802317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231a:	8b 00                	mov    (%eax),%eax
  80231c:	85 c0                	test   %eax,%eax
  80231e:	74 10                	je     802330 <initialize_dynamic_allocator+0x9c>
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	8b 00                	mov    (%eax),%eax
  802325:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802328:	8b 52 04             	mov    0x4(%edx),%edx
  80232b:	89 50 04             	mov    %edx,0x4(%eax)
  80232e:	eb 0b                	jmp    80233b <initialize_dynamic_allocator+0xa7>
  802330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802333:	8b 40 04             	mov    0x4(%eax),%eax
  802336:	a3 30 50 80 00       	mov    %eax,0x805030
  80233b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233e:	8b 40 04             	mov    0x4(%eax),%eax
  802341:	85 c0                	test   %eax,%eax
  802343:	74 0f                	je     802354 <initialize_dynamic_allocator+0xc0>
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	8b 40 04             	mov    0x4(%eax),%eax
  80234b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80234e:	8b 12                	mov    (%edx),%edx
  802350:	89 10                	mov    %edx,(%eax)
  802352:	eb 0a                	jmp    80235e <initialize_dynamic_allocator+0xca>
  802354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802357:	8b 00                	mov    (%eax),%eax
  802359:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802361:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802371:	a1 38 50 80 00       	mov    0x805038,%eax
  802376:	48                   	dec    %eax
  802377:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80237c:	a1 34 50 80 00       	mov    0x805034,%eax
  802381:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802384:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802388:	74 07                	je     802391 <initialize_dynamic_allocator+0xfd>
  80238a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238d:	8b 00                	mov    (%eax),%eax
  80238f:	eb 05                	jmp    802396 <initialize_dynamic_allocator+0x102>
  802391:	b8 00 00 00 00       	mov    $0x0,%eax
  802396:	a3 34 50 80 00       	mov    %eax,0x805034
  80239b:	a1 34 50 80 00       	mov    0x805034,%eax
  8023a0:	85 c0                	test   %eax,%eax
  8023a2:	0f 85 55 ff ff ff    	jne    8022fd <initialize_dynamic_allocator+0x69>
  8023a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ac:	0f 85 4b ff ff ff    	jne    8022fd <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8023b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8023b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023bb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8023c1:	a1 44 50 80 00       	mov    0x805044,%eax
  8023c6:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8023cb:	a1 40 50 80 00       	mov    0x805040,%eax
  8023d0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8023d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d9:	83 c0 08             	add    $0x8,%eax
  8023dc:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8023df:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e2:	83 c0 04             	add    $0x4,%eax
  8023e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e8:	83 ea 08             	sub    $0x8,%edx
  8023eb:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8023ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f3:	01 d0                	add    %edx,%eax
  8023f5:	83 e8 08             	sub    $0x8,%eax
  8023f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023fb:	83 ea 08             	sub    $0x8,%edx
  8023fe:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802400:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802403:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802409:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80240c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802413:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802417:	75 17                	jne    802430 <initialize_dynamic_allocator+0x19c>
  802419:	83 ec 04             	sub    $0x4,%esp
  80241c:	68 48 46 80 00       	push   $0x804648
  802421:	68 90 00 00 00       	push   $0x90
  802426:	68 2d 46 80 00       	push   $0x80462d
  80242b:	e8 3f de ff ff       	call   80026f <_panic>
  802430:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802436:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802439:	89 10                	mov    %edx,(%eax)
  80243b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80243e:	8b 00                	mov    (%eax),%eax
  802440:	85 c0                	test   %eax,%eax
  802442:	74 0d                	je     802451 <initialize_dynamic_allocator+0x1bd>
  802444:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802449:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80244c:	89 50 04             	mov    %edx,0x4(%eax)
  80244f:	eb 08                	jmp    802459 <initialize_dynamic_allocator+0x1c5>
  802451:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802454:	a3 30 50 80 00       	mov    %eax,0x805030
  802459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80245c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802461:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802464:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80246b:	a1 38 50 80 00       	mov    0x805038,%eax
  802470:	40                   	inc    %eax
  802471:	a3 38 50 80 00       	mov    %eax,0x805038
  802476:	eb 07                	jmp    80247f <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802478:	90                   	nop
  802479:	eb 04                	jmp    80247f <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80247b:	90                   	nop
  80247c:	eb 01                	jmp    80247f <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80247e:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80247f:	c9                   	leave  
  802480:	c3                   	ret    

00802481 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802484:	8b 45 10             	mov    0x10(%ebp),%eax
  802487:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80248a:	8b 45 08             	mov    0x8(%ebp),%eax
  80248d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802490:	8b 45 0c             	mov    0xc(%ebp),%eax
  802493:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802495:	8b 45 08             	mov    0x8(%ebp),%eax
  802498:	83 e8 04             	sub    $0x4,%eax
  80249b:	8b 00                	mov    (%eax),%eax
  80249d:	83 e0 fe             	and    $0xfffffffe,%eax
  8024a0:	8d 50 f8             	lea    -0x8(%eax),%edx
  8024a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a6:	01 c2                	add    %eax,%edx
  8024a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ab:	89 02                	mov    %eax,(%edx)
}
  8024ad:	90                   	nop
  8024ae:	5d                   	pop    %ebp
  8024af:	c3                   	ret    

008024b0 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
  8024b3:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8024b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b9:	83 e0 01             	and    $0x1,%eax
  8024bc:	85 c0                	test   %eax,%eax
  8024be:	74 03                	je     8024c3 <alloc_block_FF+0x13>
  8024c0:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8024c3:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8024c7:	77 07                	ja     8024d0 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8024c9:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8024d0:	a1 24 50 80 00       	mov    0x805024,%eax
  8024d5:	85 c0                	test   %eax,%eax
  8024d7:	75 73                	jne    80254c <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8024d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dc:	83 c0 10             	add    $0x10,%eax
  8024df:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8024e2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8024e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ef:	01 d0                	add    %edx,%eax
  8024f1:	48                   	dec    %eax
  8024f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8024f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8024fd:	f7 75 ec             	divl   -0x14(%ebp)
  802500:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802503:	29 d0                	sub    %edx,%eax
  802505:	c1 e8 0c             	shr    $0xc,%eax
  802508:	83 ec 0c             	sub    $0xc,%esp
  80250b:	50                   	push   %eax
  80250c:	e8 ec f6 ff ff       	call   801bfd <sbrk>
  802511:	83 c4 10             	add    $0x10,%esp
  802514:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802517:	83 ec 0c             	sub    $0xc,%esp
  80251a:	6a 00                	push   $0x0
  80251c:	e8 dc f6 ff ff       	call   801bfd <sbrk>
  802521:	83 c4 10             	add    $0x10,%esp
  802524:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802527:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80252a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80252d:	83 ec 08             	sub    $0x8,%esp
  802530:	50                   	push   %eax
  802531:	ff 75 e4             	pushl  -0x1c(%ebp)
  802534:	e8 5b fd ff ff       	call   802294 <initialize_dynamic_allocator>
  802539:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80253c:	83 ec 0c             	sub    $0xc,%esp
  80253f:	68 6b 46 80 00       	push   $0x80466b
  802544:	e8 e3 df ff ff       	call   80052c <cprintf>
  802549:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80254c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802550:	75 0a                	jne    80255c <alloc_block_FF+0xac>
	        return NULL;
  802552:	b8 00 00 00 00       	mov    $0x0,%eax
  802557:	e9 0e 04 00 00       	jmp    80296a <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80255c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802563:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802568:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80256b:	e9 f3 02 00 00       	jmp    802863 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802576:	83 ec 0c             	sub    $0xc,%esp
  802579:	ff 75 bc             	pushl  -0x44(%ebp)
  80257c:	e8 af fb ff ff       	call   802130 <get_block_size>
  802581:	83 c4 10             	add    $0x10,%esp
  802584:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802587:	8b 45 08             	mov    0x8(%ebp),%eax
  80258a:	83 c0 08             	add    $0x8,%eax
  80258d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802590:	0f 87 c5 02 00 00    	ja     80285b <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802596:	8b 45 08             	mov    0x8(%ebp),%eax
  802599:	83 c0 18             	add    $0x18,%eax
  80259c:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80259f:	0f 87 19 02 00 00    	ja     8027be <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8025a5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8025a8:	2b 45 08             	sub    0x8(%ebp),%eax
  8025ab:	83 e8 08             	sub    $0x8,%eax
  8025ae:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8025b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b4:	8d 50 08             	lea    0x8(%eax),%edx
  8025b7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8025ba:	01 d0                	add    %edx,%eax
  8025bc:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8025bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c2:	83 c0 08             	add    $0x8,%eax
  8025c5:	83 ec 04             	sub    $0x4,%esp
  8025c8:	6a 01                	push   $0x1
  8025ca:	50                   	push   %eax
  8025cb:	ff 75 bc             	pushl  -0x44(%ebp)
  8025ce:	e8 ae fe ff ff       	call   802481 <set_block_data>
  8025d3:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8025d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d9:	8b 40 04             	mov    0x4(%eax),%eax
  8025dc:	85 c0                	test   %eax,%eax
  8025de:	75 68                	jne    802648 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8025e0:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025e4:	75 17                	jne    8025fd <alloc_block_FF+0x14d>
  8025e6:	83 ec 04             	sub    $0x4,%esp
  8025e9:	68 48 46 80 00       	push   $0x804648
  8025ee:	68 d7 00 00 00       	push   $0xd7
  8025f3:	68 2d 46 80 00       	push   $0x80462d
  8025f8:	e8 72 dc ff ff       	call   80026f <_panic>
  8025fd:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802603:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802606:	89 10                	mov    %edx,(%eax)
  802608:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80260b:	8b 00                	mov    (%eax),%eax
  80260d:	85 c0                	test   %eax,%eax
  80260f:	74 0d                	je     80261e <alloc_block_FF+0x16e>
  802611:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802616:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802619:	89 50 04             	mov    %edx,0x4(%eax)
  80261c:	eb 08                	jmp    802626 <alloc_block_FF+0x176>
  80261e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802621:	a3 30 50 80 00       	mov    %eax,0x805030
  802626:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802629:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80262e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802631:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802638:	a1 38 50 80 00       	mov    0x805038,%eax
  80263d:	40                   	inc    %eax
  80263e:	a3 38 50 80 00       	mov    %eax,0x805038
  802643:	e9 dc 00 00 00       	jmp    802724 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	8b 00                	mov    (%eax),%eax
  80264d:	85 c0                	test   %eax,%eax
  80264f:	75 65                	jne    8026b6 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802651:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802655:	75 17                	jne    80266e <alloc_block_FF+0x1be>
  802657:	83 ec 04             	sub    $0x4,%esp
  80265a:	68 7c 46 80 00       	push   $0x80467c
  80265f:	68 db 00 00 00       	push   $0xdb
  802664:	68 2d 46 80 00       	push   $0x80462d
  802669:	e8 01 dc ff ff       	call   80026f <_panic>
  80266e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802674:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802677:	89 50 04             	mov    %edx,0x4(%eax)
  80267a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80267d:	8b 40 04             	mov    0x4(%eax),%eax
  802680:	85 c0                	test   %eax,%eax
  802682:	74 0c                	je     802690 <alloc_block_FF+0x1e0>
  802684:	a1 30 50 80 00       	mov    0x805030,%eax
  802689:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80268c:	89 10                	mov    %edx,(%eax)
  80268e:	eb 08                	jmp    802698 <alloc_block_FF+0x1e8>
  802690:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802693:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802698:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80269b:	a3 30 50 80 00       	mov    %eax,0x805030
  8026a0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a9:	a1 38 50 80 00       	mov    0x805038,%eax
  8026ae:	40                   	inc    %eax
  8026af:	a3 38 50 80 00       	mov    %eax,0x805038
  8026b4:	eb 6e                	jmp    802724 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8026b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ba:	74 06                	je     8026c2 <alloc_block_FF+0x212>
  8026bc:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8026c0:	75 17                	jne    8026d9 <alloc_block_FF+0x229>
  8026c2:	83 ec 04             	sub    $0x4,%esp
  8026c5:	68 a0 46 80 00       	push   $0x8046a0
  8026ca:	68 df 00 00 00       	push   $0xdf
  8026cf:	68 2d 46 80 00       	push   $0x80462d
  8026d4:	e8 96 db ff ff       	call   80026f <_panic>
  8026d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dc:	8b 10                	mov    (%eax),%edx
  8026de:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026e1:	89 10                	mov    %edx,(%eax)
  8026e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026e6:	8b 00                	mov    (%eax),%eax
  8026e8:	85 c0                	test   %eax,%eax
  8026ea:	74 0b                	je     8026f7 <alloc_block_FF+0x247>
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	8b 00                	mov    (%eax),%eax
  8026f1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026f4:	89 50 04             	mov    %edx,0x4(%eax)
  8026f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fa:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026fd:	89 10                	mov    %edx,(%eax)
  8026ff:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802702:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802705:	89 50 04             	mov    %edx,0x4(%eax)
  802708:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80270b:	8b 00                	mov    (%eax),%eax
  80270d:	85 c0                	test   %eax,%eax
  80270f:	75 08                	jne    802719 <alloc_block_FF+0x269>
  802711:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802714:	a3 30 50 80 00       	mov    %eax,0x805030
  802719:	a1 38 50 80 00       	mov    0x805038,%eax
  80271e:	40                   	inc    %eax
  80271f:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802724:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802728:	75 17                	jne    802741 <alloc_block_FF+0x291>
  80272a:	83 ec 04             	sub    $0x4,%esp
  80272d:	68 0f 46 80 00       	push   $0x80460f
  802732:	68 e1 00 00 00       	push   $0xe1
  802737:	68 2d 46 80 00       	push   $0x80462d
  80273c:	e8 2e db ff ff       	call   80026f <_panic>
  802741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802744:	8b 00                	mov    (%eax),%eax
  802746:	85 c0                	test   %eax,%eax
  802748:	74 10                	je     80275a <alloc_block_FF+0x2aa>
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	8b 00                	mov    (%eax),%eax
  80274f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802752:	8b 52 04             	mov    0x4(%edx),%edx
  802755:	89 50 04             	mov    %edx,0x4(%eax)
  802758:	eb 0b                	jmp    802765 <alloc_block_FF+0x2b5>
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	8b 40 04             	mov    0x4(%eax),%eax
  802760:	a3 30 50 80 00       	mov    %eax,0x805030
  802765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802768:	8b 40 04             	mov    0x4(%eax),%eax
  80276b:	85 c0                	test   %eax,%eax
  80276d:	74 0f                	je     80277e <alloc_block_FF+0x2ce>
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	8b 40 04             	mov    0x4(%eax),%eax
  802775:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802778:	8b 12                	mov    (%edx),%edx
  80277a:	89 10                	mov    %edx,(%eax)
  80277c:	eb 0a                	jmp    802788 <alloc_block_FF+0x2d8>
  80277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802781:	8b 00                	mov    (%eax),%eax
  802783:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80279b:	a1 38 50 80 00       	mov    0x805038,%eax
  8027a0:	48                   	dec    %eax
  8027a1:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8027a6:	83 ec 04             	sub    $0x4,%esp
  8027a9:	6a 00                	push   $0x0
  8027ab:	ff 75 b4             	pushl  -0x4c(%ebp)
  8027ae:	ff 75 b0             	pushl  -0x50(%ebp)
  8027b1:	e8 cb fc ff ff       	call   802481 <set_block_data>
  8027b6:	83 c4 10             	add    $0x10,%esp
  8027b9:	e9 95 00 00 00       	jmp    802853 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8027be:	83 ec 04             	sub    $0x4,%esp
  8027c1:	6a 01                	push   $0x1
  8027c3:	ff 75 b8             	pushl  -0x48(%ebp)
  8027c6:	ff 75 bc             	pushl  -0x44(%ebp)
  8027c9:	e8 b3 fc ff ff       	call   802481 <set_block_data>
  8027ce:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8027d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d5:	75 17                	jne    8027ee <alloc_block_FF+0x33e>
  8027d7:	83 ec 04             	sub    $0x4,%esp
  8027da:	68 0f 46 80 00       	push   $0x80460f
  8027df:	68 e8 00 00 00       	push   $0xe8
  8027e4:	68 2d 46 80 00       	push   $0x80462d
  8027e9:	e8 81 da ff ff       	call   80026f <_panic>
  8027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f1:	8b 00                	mov    (%eax),%eax
  8027f3:	85 c0                	test   %eax,%eax
  8027f5:	74 10                	je     802807 <alloc_block_FF+0x357>
  8027f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fa:	8b 00                	mov    (%eax),%eax
  8027fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ff:	8b 52 04             	mov    0x4(%edx),%edx
  802802:	89 50 04             	mov    %edx,0x4(%eax)
  802805:	eb 0b                	jmp    802812 <alloc_block_FF+0x362>
  802807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280a:	8b 40 04             	mov    0x4(%eax),%eax
  80280d:	a3 30 50 80 00       	mov    %eax,0x805030
  802812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802815:	8b 40 04             	mov    0x4(%eax),%eax
  802818:	85 c0                	test   %eax,%eax
  80281a:	74 0f                	je     80282b <alloc_block_FF+0x37b>
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	8b 40 04             	mov    0x4(%eax),%eax
  802822:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802825:	8b 12                	mov    (%edx),%edx
  802827:	89 10                	mov    %edx,(%eax)
  802829:	eb 0a                	jmp    802835 <alloc_block_FF+0x385>
  80282b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282e:	8b 00                	mov    (%eax),%eax
  802830:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802838:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802841:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802848:	a1 38 50 80 00       	mov    0x805038,%eax
  80284d:	48                   	dec    %eax
  80284e:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802853:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802856:	e9 0f 01 00 00       	jmp    80296a <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80285b:	a1 34 50 80 00       	mov    0x805034,%eax
  802860:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802863:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802867:	74 07                	je     802870 <alloc_block_FF+0x3c0>
  802869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286c:	8b 00                	mov    (%eax),%eax
  80286e:	eb 05                	jmp    802875 <alloc_block_FF+0x3c5>
  802870:	b8 00 00 00 00       	mov    $0x0,%eax
  802875:	a3 34 50 80 00       	mov    %eax,0x805034
  80287a:	a1 34 50 80 00       	mov    0x805034,%eax
  80287f:	85 c0                	test   %eax,%eax
  802881:	0f 85 e9 fc ff ff    	jne    802570 <alloc_block_FF+0xc0>
  802887:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80288b:	0f 85 df fc ff ff    	jne    802570 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802891:	8b 45 08             	mov    0x8(%ebp),%eax
  802894:	83 c0 08             	add    $0x8,%eax
  802897:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80289a:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8028a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8028a7:	01 d0                	add    %edx,%eax
  8028a9:	48                   	dec    %eax
  8028aa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8028ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8028b5:	f7 75 d8             	divl   -0x28(%ebp)
  8028b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028bb:	29 d0                	sub    %edx,%eax
  8028bd:	c1 e8 0c             	shr    $0xc,%eax
  8028c0:	83 ec 0c             	sub    $0xc,%esp
  8028c3:	50                   	push   %eax
  8028c4:	e8 34 f3 ff ff       	call   801bfd <sbrk>
  8028c9:	83 c4 10             	add    $0x10,%esp
  8028cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8028cf:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8028d3:	75 0a                	jne    8028df <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8028d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8028da:	e9 8b 00 00 00       	jmp    80296a <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8028df:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8028e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ec:	01 d0                	add    %edx,%eax
  8028ee:	48                   	dec    %eax
  8028ef:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8028f2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8028fa:	f7 75 cc             	divl   -0x34(%ebp)
  8028fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802900:	29 d0                	sub    %edx,%eax
  802902:	8d 50 fc             	lea    -0x4(%eax),%edx
  802905:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802908:	01 d0                	add    %edx,%eax
  80290a:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80290f:	a1 40 50 80 00       	mov    0x805040,%eax
  802914:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80291a:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802921:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802924:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802927:	01 d0                	add    %edx,%eax
  802929:	48                   	dec    %eax
  80292a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80292d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802930:	ba 00 00 00 00       	mov    $0x0,%edx
  802935:	f7 75 c4             	divl   -0x3c(%ebp)
  802938:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80293b:	29 d0                	sub    %edx,%eax
  80293d:	83 ec 04             	sub    $0x4,%esp
  802940:	6a 01                	push   $0x1
  802942:	50                   	push   %eax
  802943:	ff 75 d0             	pushl  -0x30(%ebp)
  802946:	e8 36 fb ff ff       	call   802481 <set_block_data>
  80294b:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80294e:	83 ec 0c             	sub    $0xc,%esp
  802951:	ff 75 d0             	pushl  -0x30(%ebp)
  802954:	e8 f8 09 00 00       	call   803351 <free_block>
  802959:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80295c:	83 ec 0c             	sub    $0xc,%esp
  80295f:	ff 75 08             	pushl  0x8(%ebp)
  802962:	e8 49 fb ff ff       	call   8024b0 <alloc_block_FF>
  802967:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80296a:	c9                   	leave  
  80296b:	c3                   	ret    

0080296c <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80296c:	55                   	push   %ebp
  80296d:	89 e5                	mov    %esp,%ebp
  80296f:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802972:	8b 45 08             	mov    0x8(%ebp),%eax
  802975:	83 e0 01             	and    $0x1,%eax
  802978:	85 c0                	test   %eax,%eax
  80297a:	74 03                	je     80297f <alloc_block_BF+0x13>
  80297c:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80297f:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802983:	77 07                	ja     80298c <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802985:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80298c:	a1 24 50 80 00       	mov    0x805024,%eax
  802991:	85 c0                	test   %eax,%eax
  802993:	75 73                	jne    802a08 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802995:	8b 45 08             	mov    0x8(%ebp),%eax
  802998:	83 c0 10             	add    $0x10,%eax
  80299b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80299e:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8029a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029ab:	01 d0                	add    %edx,%eax
  8029ad:	48                   	dec    %eax
  8029ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8029b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8029b9:	f7 75 e0             	divl   -0x20(%ebp)
  8029bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029bf:	29 d0                	sub    %edx,%eax
  8029c1:	c1 e8 0c             	shr    $0xc,%eax
  8029c4:	83 ec 0c             	sub    $0xc,%esp
  8029c7:	50                   	push   %eax
  8029c8:	e8 30 f2 ff ff       	call   801bfd <sbrk>
  8029cd:	83 c4 10             	add    $0x10,%esp
  8029d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8029d3:	83 ec 0c             	sub    $0xc,%esp
  8029d6:	6a 00                	push   $0x0
  8029d8:	e8 20 f2 ff ff       	call   801bfd <sbrk>
  8029dd:	83 c4 10             	add    $0x10,%esp
  8029e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8029e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029e6:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8029e9:	83 ec 08             	sub    $0x8,%esp
  8029ec:	50                   	push   %eax
  8029ed:	ff 75 d8             	pushl  -0x28(%ebp)
  8029f0:	e8 9f f8 ff ff       	call   802294 <initialize_dynamic_allocator>
  8029f5:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8029f8:	83 ec 0c             	sub    $0xc,%esp
  8029fb:	68 6b 46 80 00       	push   $0x80466b
  802a00:	e8 27 db ff ff       	call   80052c <cprintf>
  802a05:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802a08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802a0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802a16:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802a1d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802a24:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a2c:	e9 1d 01 00 00       	jmp    802b4e <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a34:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802a37:	83 ec 0c             	sub    $0xc,%esp
  802a3a:	ff 75 a8             	pushl  -0x58(%ebp)
  802a3d:	e8 ee f6 ff ff       	call   802130 <get_block_size>
  802a42:	83 c4 10             	add    $0x10,%esp
  802a45:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802a48:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4b:	83 c0 08             	add    $0x8,%eax
  802a4e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a51:	0f 87 ef 00 00 00    	ja     802b46 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a57:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5a:	83 c0 18             	add    $0x18,%eax
  802a5d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a60:	77 1d                	ja     802a7f <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802a62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a65:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a68:	0f 86 d8 00 00 00    	jbe    802b46 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802a6e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802a74:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a77:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a7a:	e9 c7 00 00 00       	jmp    802b46 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a82:	83 c0 08             	add    $0x8,%eax
  802a85:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a88:	0f 85 9d 00 00 00    	jne    802b2b <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802a8e:	83 ec 04             	sub    $0x4,%esp
  802a91:	6a 01                	push   $0x1
  802a93:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a96:	ff 75 a8             	pushl  -0x58(%ebp)
  802a99:	e8 e3 f9 ff ff       	call   802481 <set_block_data>
  802a9e:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802aa1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa5:	75 17                	jne    802abe <alloc_block_BF+0x152>
  802aa7:	83 ec 04             	sub    $0x4,%esp
  802aaa:	68 0f 46 80 00       	push   $0x80460f
  802aaf:	68 2c 01 00 00       	push   $0x12c
  802ab4:	68 2d 46 80 00       	push   $0x80462d
  802ab9:	e8 b1 d7 ff ff       	call   80026f <_panic>
  802abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac1:	8b 00                	mov    (%eax),%eax
  802ac3:	85 c0                	test   %eax,%eax
  802ac5:	74 10                	je     802ad7 <alloc_block_BF+0x16b>
  802ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aca:	8b 00                	mov    (%eax),%eax
  802acc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802acf:	8b 52 04             	mov    0x4(%edx),%edx
  802ad2:	89 50 04             	mov    %edx,0x4(%eax)
  802ad5:	eb 0b                	jmp    802ae2 <alloc_block_BF+0x176>
  802ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ada:	8b 40 04             	mov    0x4(%eax),%eax
  802add:	a3 30 50 80 00       	mov    %eax,0x805030
  802ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae5:	8b 40 04             	mov    0x4(%eax),%eax
  802ae8:	85 c0                	test   %eax,%eax
  802aea:	74 0f                	je     802afb <alloc_block_BF+0x18f>
  802aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aef:	8b 40 04             	mov    0x4(%eax),%eax
  802af2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af5:	8b 12                	mov    (%edx),%edx
  802af7:	89 10                	mov    %edx,(%eax)
  802af9:	eb 0a                	jmp    802b05 <alloc_block_BF+0x199>
  802afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afe:	8b 00                	mov    (%eax),%eax
  802b00:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b18:	a1 38 50 80 00       	mov    0x805038,%eax
  802b1d:	48                   	dec    %eax
  802b1e:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802b23:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b26:	e9 01 04 00 00       	jmp    802f2c <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802b2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b31:	76 13                	jbe    802b46 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802b33:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802b3a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802b40:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802b43:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802b46:	a1 34 50 80 00       	mov    0x805034,%eax
  802b4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b52:	74 07                	je     802b5b <alloc_block_BF+0x1ef>
  802b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b57:	8b 00                	mov    (%eax),%eax
  802b59:	eb 05                	jmp    802b60 <alloc_block_BF+0x1f4>
  802b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b60:	a3 34 50 80 00       	mov    %eax,0x805034
  802b65:	a1 34 50 80 00       	mov    0x805034,%eax
  802b6a:	85 c0                	test   %eax,%eax
  802b6c:	0f 85 bf fe ff ff    	jne    802a31 <alloc_block_BF+0xc5>
  802b72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b76:	0f 85 b5 fe ff ff    	jne    802a31 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802b7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b80:	0f 84 26 02 00 00    	je     802dac <alloc_block_BF+0x440>
  802b86:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b8a:	0f 85 1c 02 00 00    	jne    802dac <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802b90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b93:	2b 45 08             	sub    0x8(%ebp),%eax
  802b96:	83 e8 08             	sub    $0x8,%eax
  802b99:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9f:	8d 50 08             	lea    0x8(%eax),%edx
  802ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba5:	01 d0                	add    %edx,%eax
  802ba7:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802baa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bad:	83 c0 08             	add    $0x8,%eax
  802bb0:	83 ec 04             	sub    $0x4,%esp
  802bb3:	6a 01                	push   $0x1
  802bb5:	50                   	push   %eax
  802bb6:	ff 75 f0             	pushl  -0x10(%ebp)
  802bb9:	e8 c3 f8 ff ff       	call   802481 <set_block_data>
  802bbe:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc4:	8b 40 04             	mov    0x4(%eax),%eax
  802bc7:	85 c0                	test   %eax,%eax
  802bc9:	75 68                	jne    802c33 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802bcb:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bcf:	75 17                	jne    802be8 <alloc_block_BF+0x27c>
  802bd1:	83 ec 04             	sub    $0x4,%esp
  802bd4:	68 48 46 80 00       	push   $0x804648
  802bd9:	68 45 01 00 00       	push   $0x145
  802bde:	68 2d 46 80 00       	push   $0x80462d
  802be3:	e8 87 d6 ff ff       	call   80026f <_panic>
  802be8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802bee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bf1:	89 10                	mov    %edx,(%eax)
  802bf3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bf6:	8b 00                	mov    (%eax),%eax
  802bf8:	85 c0                	test   %eax,%eax
  802bfa:	74 0d                	je     802c09 <alloc_block_BF+0x29d>
  802bfc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802c01:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c04:	89 50 04             	mov    %edx,0x4(%eax)
  802c07:	eb 08                	jmp    802c11 <alloc_block_BF+0x2a5>
  802c09:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c0c:	a3 30 50 80 00       	mov    %eax,0x805030
  802c11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c14:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c19:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c23:	a1 38 50 80 00       	mov    0x805038,%eax
  802c28:	40                   	inc    %eax
  802c29:	a3 38 50 80 00       	mov    %eax,0x805038
  802c2e:	e9 dc 00 00 00       	jmp    802d0f <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c36:	8b 00                	mov    (%eax),%eax
  802c38:	85 c0                	test   %eax,%eax
  802c3a:	75 65                	jne    802ca1 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c3c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c40:	75 17                	jne    802c59 <alloc_block_BF+0x2ed>
  802c42:	83 ec 04             	sub    $0x4,%esp
  802c45:	68 7c 46 80 00       	push   $0x80467c
  802c4a:	68 4a 01 00 00       	push   $0x14a
  802c4f:	68 2d 46 80 00       	push   $0x80462d
  802c54:	e8 16 d6 ff ff       	call   80026f <_panic>
  802c59:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802c5f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c62:	89 50 04             	mov    %edx,0x4(%eax)
  802c65:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c68:	8b 40 04             	mov    0x4(%eax),%eax
  802c6b:	85 c0                	test   %eax,%eax
  802c6d:	74 0c                	je     802c7b <alloc_block_BF+0x30f>
  802c6f:	a1 30 50 80 00       	mov    0x805030,%eax
  802c74:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c77:	89 10                	mov    %edx,(%eax)
  802c79:	eb 08                	jmp    802c83 <alloc_block_BF+0x317>
  802c7b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c7e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c83:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c86:	a3 30 50 80 00       	mov    %eax,0x805030
  802c8b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c94:	a1 38 50 80 00       	mov    0x805038,%eax
  802c99:	40                   	inc    %eax
  802c9a:	a3 38 50 80 00       	mov    %eax,0x805038
  802c9f:	eb 6e                	jmp    802d0f <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802ca1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ca5:	74 06                	je     802cad <alloc_block_BF+0x341>
  802ca7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802cab:	75 17                	jne    802cc4 <alloc_block_BF+0x358>
  802cad:	83 ec 04             	sub    $0x4,%esp
  802cb0:	68 a0 46 80 00       	push   $0x8046a0
  802cb5:	68 4f 01 00 00       	push   $0x14f
  802cba:	68 2d 46 80 00       	push   $0x80462d
  802cbf:	e8 ab d5 ff ff       	call   80026f <_panic>
  802cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc7:	8b 10                	mov    (%eax),%edx
  802cc9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ccc:	89 10                	mov    %edx,(%eax)
  802cce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cd1:	8b 00                	mov    (%eax),%eax
  802cd3:	85 c0                	test   %eax,%eax
  802cd5:	74 0b                	je     802ce2 <alloc_block_BF+0x376>
  802cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cda:	8b 00                	mov    (%eax),%eax
  802cdc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802cdf:	89 50 04             	mov    %edx,0x4(%eax)
  802ce2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ce8:	89 10                	mov    %edx,(%eax)
  802cea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ced:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cf0:	89 50 04             	mov    %edx,0x4(%eax)
  802cf3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cf6:	8b 00                	mov    (%eax),%eax
  802cf8:	85 c0                	test   %eax,%eax
  802cfa:	75 08                	jne    802d04 <alloc_block_BF+0x398>
  802cfc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cff:	a3 30 50 80 00       	mov    %eax,0x805030
  802d04:	a1 38 50 80 00       	mov    0x805038,%eax
  802d09:	40                   	inc    %eax
  802d0a:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802d0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d13:	75 17                	jne    802d2c <alloc_block_BF+0x3c0>
  802d15:	83 ec 04             	sub    $0x4,%esp
  802d18:	68 0f 46 80 00       	push   $0x80460f
  802d1d:	68 51 01 00 00       	push   $0x151
  802d22:	68 2d 46 80 00       	push   $0x80462d
  802d27:	e8 43 d5 ff ff       	call   80026f <_panic>
  802d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2f:	8b 00                	mov    (%eax),%eax
  802d31:	85 c0                	test   %eax,%eax
  802d33:	74 10                	je     802d45 <alloc_block_BF+0x3d9>
  802d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d38:	8b 00                	mov    (%eax),%eax
  802d3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d3d:	8b 52 04             	mov    0x4(%edx),%edx
  802d40:	89 50 04             	mov    %edx,0x4(%eax)
  802d43:	eb 0b                	jmp    802d50 <alloc_block_BF+0x3e4>
  802d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d48:	8b 40 04             	mov    0x4(%eax),%eax
  802d4b:	a3 30 50 80 00       	mov    %eax,0x805030
  802d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d53:	8b 40 04             	mov    0x4(%eax),%eax
  802d56:	85 c0                	test   %eax,%eax
  802d58:	74 0f                	je     802d69 <alloc_block_BF+0x3fd>
  802d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5d:	8b 40 04             	mov    0x4(%eax),%eax
  802d60:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d63:	8b 12                	mov    (%edx),%edx
  802d65:	89 10                	mov    %edx,(%eax)
  802d67:	eb 0a                	jmp    802d73 <alloc_block_BF+0x407>
  802d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6c:	8b 00                	mov    (%eax),%eax
  802d6e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d86:	a1 38 50 80 00       	mov    0x805038,%eax
  802d8b:	48                   	dec    %eax
  802d8c:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802d91:	83 ec 04             	sub    $0x4,%esp
  802d94:	6a 00                	push   $0x0
  802d96:	ff 75 d0             	pushl  -0x30(%ebp)
  802d99:	ff 75 cc             	pushl  -0x34(%ebp)
  802d9c:	e8 e0 f6 ff ff       	call   802481 <set_block_data>
  802da1:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da7:	e9 80 01 00 00       	jmp    802f2c <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802dac:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802db0:	0f 85 9d 00 00 00    	jne    802e53 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802db6:	83 ec 04             	sub    $0x4,%esp
  802db9:	6a 01                	push   $0x1
  802dbb:	ff 75 ec             	pushl  -0x14(%ebp)
  802dbe:	ff 75 f0             	pushl  -0x10(%ebp)
  802dc1:	e8 bb f6 ff ff       	call   802481 <set_block_data>
  802dc6:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802dc9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dcd:	75 17                	jne    802de6 <alloc_block_BF+0x47a>
  802dcf:	83 ec 04             	sub    $0x4,%esp
  802dd2:	68 0f 46 80 00       	push   $0x80460f
  802dd7:	68 58 01 00 00       	push   $0x158
  802ddc:	68 2d 46 80 00       	push   $0x80462d
  802de1:	e8 89 d4 ff ff       	call   80026f <_panic>
  802de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de9:	8b 00                	mov    (%eax),%eax
  802deb:	85 c0                	test   %eax,%eax
  802ded:	74 10                	je     802dff <alloc_block_BF+0x493>
  802def:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df2:	8b 00                	mov    (%eax),%eax
  802df4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802df7:	8b 52 04             	mov    0x4(%edx),%edx
  802dfa:	89 50 04             	mov    %edx,0x4(%eax)
  802dfd:	eb 0b                	jmp    802e0a <alloc_block_BF+0x49e>
  802dff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e02:	8b 40 04             	mov    0x4(%eax),%eax
  802e05:	a3 30 50 80 00       	mov    %eax,0x805030
  802e0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0d:	8b 40 04             	mov    0x4(%eax),%eax
  802e10:	85 c0                	test   %eax,%eax
  802e12:	74 0f                	je     802e23 <alloc_block_BF+0x4b7>
  802e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e17:	8b 40 04             	mov    0x4(%eax),%eax
  802e1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e1d:	8b 12                	mov    (%edx),%edx
  802e1f:	89 10                	mov    %edx,(%eax)
  802e21:	eb 0a                	jmp    802e2d <alloc_block_BF+0x4c1>
  802e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e26:	8b 00                	mov    (%eax),%eax
  802e28:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e40:	a1 38 50 80 00       	mov    0x805038,%eax
  802e45:	48                   	dec    %eax
  802e46:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4e:	e9 d9 00 00 00       	jmp    802f2c <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802e53:	8b 45 08             	mov    0x8(%ebp),%eax
  802e56:	83 c0 08             	add    $0x8,%eax
  802e59:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e5c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802e63:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e66:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e69:	01 d0                	add    %edx,%eax
  802e6b:	48                   	dec    %eax
  802e6c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e6f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e72:	ba 00 00 00 00       	mov    $0x0,%edx
  802e77:	f7 75 c4             	divl   -0x3c(%ebp)
  802e7a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e7d:	29 d0                	sub    %edx,%eax
  802e7f:	c1 e8 0c             	shr    $0xc,%eax
  802e82:	83 ec 0c             	sub    $0xc,%esp
  802e85:	50                   	push   %eax
  802e86:	e8 72 ed ff ff       	call   801bfd <sbrk>
  802e8b:	83 c4 10             	add    $0x10,%esp
  802e8e:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802e91:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802e95:	75 0a                	jne    802ea1 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802e97:	b8 00 00 00 00       	mov    $0x0,%eax
  802e9c:	e9 8b 00 00 00       	jmp    802f2c <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802ea1:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802ea8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802eab:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802eae:	01 d0                	add    %edx,%eax
  802eb0:	48                   	dec    %eax
  802eb1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802eb4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802eb7:	ba 00 00 00 00       	mov    $0x0,%edx
  802ebc:	f7 75 b8             	divl   -0x48(%ebp)
  802ebf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ec2:	29 d0                	sub    %edx,%eax
  802ec4:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ec7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802eca:	01 d0                	add    %edx,%eax
  802ecc:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802ed1:	a1 40 50 80 00       	mov    0x805040,%eax
  802ed6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802edc:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802ee3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ee6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ee9:	01 d0                	add    %edx,%eax
  802eeb:	48                   	dec    %eax
  802eec:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802eef:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ef2:	ba 00 00 00 00       	mov    $0x0,%edx
  802ef7:	f7 75 b0             	divl   -0x50(%ebp)
  802efa:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802efd:	29 d0                	sub    %edx,%eax
  802eff:	83 ec 04             	sub    $0x4,%esp
  802f02:	6a 01                	push   $0x1
  802f04:	50                   	push   %eax
  802f05:	ff 75 bc             	pushl  -0x44(%ebp)
  802f08:	e8 74 f5 ff ff       	call   802481 <set_block_data>
  802f0d:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802f10:	83 ec 0c             	sub    $0xc,%esp
  802f13:	ff 75 bc             	pushl  -0x44(%ebp)
  802f16:	e8 36 04 00 00       	call   803351 <free_block>
  802f1b:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802f1e:	83 ec 0c             	sub    $0xc,%esp
  802f21:	ff 75 08             	pushl  0x8(%ebp)
  802f24:	e8 43 fa ff ff       	call   80296c <alloc_block_BF>
  802f29:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802f2c:	c9                   	leave  
  802f2d:	c3                   	ret    

00802f2e <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802f2e:	55                   	push   %ebp
  802f2f:	89 e5                	mov    %esp,%ebp
  802f31:	53                   	push   %ebx
  802f32:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802f35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802f3c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802f43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f47:	74 1e                	je     802f67 <merging+0x39>
  802f49:	ff 75 08             	pushl  0x8(%ebp)
  802f4c:	e8 df f1 ff ff       	call   802130 <get_block_size>
  802f51:	83 c4 04             	add    $0x4,%esp
  802f54:	89 c2                	mov    %eax,%edx
  802f56:	8b 45 08             	mov    0x8(%ebp),%eax
  802f59:	01 d0                	add    %edx,%eax
  802f5b:	3b 45 10             	cmp    0x10(%ebp),%eax
  802f5e:	75 07                	jne    802f67 <merging+0x39>
		prev_is_free = 1;
  802f60:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802f67:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f6b:	74 1e                	je     802f8b <merging+0x5d>
  802f6d:	ff 75 10             	pushl  0x10(%ebp)
  802f70:	e8 bb f1 ff ff       	call   802130 <get_block_size>
  802f75:	83 c4 04             	add    $0x4,%esp
  802f78:	89 c2                	mov    %eax,%edx
  802f7a:	8b 45 10             	mov    0x10(%ebp),%eax
  802f7d:	01 d0                	add    %edx,%eax
  802f7f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f82:	75 07                	jne    802f8b <merging+0x5d>
		next_is_free = 1;
  802f84:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802f8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f8f:	0f 84 cc 00 00 00    	je     803061 <merging+0x133>
  802f95:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f99:	0f 84 c2 00 00 00    	je     803061 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802f9f:	ff 75 08             	pushl  0x8(%ebp)
  802fa2:	e8 89 f1 ff ff       	call   802130 <get_block_size>
  802fa7:	83 c4 04             	add    $0x4,%esp
  802faa:	89 c3                	mov    %eax,%ebx
  802fac:	ff 75 10             	pushl  0x10(%ebp)
  802faf:	e8 7c f1 ff ff       	call   802130 <get_block_size>
  802fb4:	83 c4 04             	add    $0x4,%esp
  802fb7:	01 c3                	add    %eax,%ebx
  802fb9:	ff 75 0c             	pushl  0xc(%ebp)
  802fbc:	e8 6f f1 ff ff       	call   802130 <get_block_size>
  802fc1:	83 c4 04             	add    $0x4,%esp
  802fc4:	01 d8                	add    %ebx,%eax
  802fc6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802fc9:	6a 00                	push   $0x0
  802fcb:	ff 75 ec             	pushl  -0x14(%ebp)
  802fce:	ff 75 08             	pushl  0x8(%ebp)
  802fd1:	e8 ab f4 ff ff       	call   802481 <set_block_data>
  802fd6:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802fd9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fdd:	75 17                	jne    802ff6 <merging+0xc8>
  802fdf:	83 ec 04             	sub    $0x4,%esp
  802fe2:	68 0f 46 80 00       	push   $0x80460f
  802fe7:	68 7d 01 00 00       	push   $0x17d
  802fec:	68 2d 46 80 00       	push   $0x80462d
  802ff1:	e8 79 d2 ff ff       	call   80026f <_panic>
  802ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff9:	8b 00                	mov    (%eax),%eax
  802ffb:	85 c0                	test   %eax,%eax
  802ffd:	74 10                	je     80300f <merging+0xe1>
  802fff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803002:	8b 00                	mov    (%eax),%eax
  803004:	8b 55 0c             	mov    0xc(%ebp),%edx
  803007:	8b 52 04             	mov    0x4(%edx),%edx
  80300a:	89 50 04             	mov    %edx,0x4(%eax)
  80300d:	eb 0b                	jmp    80301a <merging+0xec>
  80300f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803012:	8b 40 04             	mov    0x4(%eax),%eax
  803015:	a3 30 50 80 00       	mov    %eax,0x805030
  80301a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80301d:	8b 40 04             	mov    0x4(%eax),%eax
  803020:	85 c0                	test   %eax,%eax
  803022:	74 0f                	je     803033 <merging+0x105>
  803024:	8b 45 0c             	mov    0xc(%ebp),%eax
  803027:	8b 40 04             	mov    0x4(%eax),%eax
  80302a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80302d:	8b 12                	mov    (%edx),%edx
  80302f:	89 10                	mov    %edx,(%eax)
  803031:	eb 0a                	jmp    80303d <merging+0x10f>
  803033:	8b 45 0c             	mov    0xc(%ebp),%eax
  803036:	8b 00                	mov    (%eax),%eax
  803038:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80303d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803040:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803046:	8b 45 0c             	mov    0xc(%ebp),%eax
  803049:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803050:	a1 38 50 80 00       	mov    0x805038,%eax
  803055:	48                   	dec    %eax
  803056:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80305b:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80305c:	e9 ea 02 00 00       	jmp    80334b <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803061:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803065:	74 3b                	je     8030a2 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803067:	83 ec 0c             	sub    $0xc,%esp
  80306a:	ff 75 08             	pushl  0x8(%ebp)
  80306d:	e8 be f0 ff ff       	call   802130 <get_block_size>
  803072:	83 c4 10             	add    $0x10,%esp
  803075:	89 c3                	mov    %eax,%ebx
  803077:	83 ec 0c             	sub    $0xc,%esp
  80307a:	ff 75 10             	pushl  0x10(%ebp)
  80307d:	e8 ae f0 ff ff       	call   802130 <get_block_size>
  803082:	83 c4 10             	add    $0x10,%esp
  803085:	01 d8                	add    %ebx,%eax
  803087:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80308a:	83 ec 04             	sub    $0x4,%esp
  80308d:	6a 00                	push   $0x0
  80308f:	ff 75 e8             	pushl  -0x18(%ebp)
  803092:	ff 75 08             	pushl  0x8(%ebp)
  803095:	e8 e7 f3 ff ff       	call   802481 <set_block_data>
  80309a:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80309d:	e9 a9 02 00 00       	jmp    80334b <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8030a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030a6:	0f 84 2d 01 00 00    	je     8031d9 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8030ac:	83 ec 0c             	sub    $0xc,%esp
  8030af:	ff 75 10             	pushl  0x10(%ebp)
  8030b2:	e8 79 f0 ff ff       	call   802130 <get_block_size>
  8030b7:	83 c4 10             	add    $0x10,%esp
  8030ba:	89 c3                	mov    %eax,%ebx
  8030bc:	83 ec 0c             	sub    $0xc,%esp
  8030bf:	ff 75 0c             	pushl  0xc(%ebp)
  8030c2:	e8 69 f0 ff ff       	call   802130 <get_block_size>
  8030c7:	83 c4 10             	add    $0x10,%esp
  8030ca:	01 d8                	add    %ebx,%eax
  8030cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8030cf:	83 ec 04             	sub    $0x4,%esp
  8030d2:	6a 00                	push   $0x0
  8030d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8030d7:	ff 75 10             	pushl  0x10(%ebp)
  8030da:	e8 a2 f3 ff ff       	call   802481 <set_block_data>
  8030df:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8030e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8030e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8030e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030ec:	74 06                	je     8030f4 <merging+0x1c6>
  8030ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030f2:	75 17                	jne    80310b <merging+0x1dd>
  8030f4:	83 ec 04             	sub    $0x4,%esp
  8030f7:	68 d4 46 80 00       	push   $0x8046d4
  8030fc:	68 8d 01 00 00       	push   $0x18d
  803101:	68 2d 46 80 00       	push   $0x80462d
  803106:	e8 64 d1 ff ff       	call   80026f <_panic>
  80310b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80310e:	8b 50 04             	mov    0x4(%eax),%edx
  803111:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803114:	89 50 04             	mov    %edx,0x4(%eax)
  803117:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80311a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80311d:	89 10                	mov    %edx,(%eax)
  80311f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803122:	8b 40 04             	mov    0x4(%eax),%eax
  803125:	85 c0                	test   %eax,%eax
  803127:	74 0d                	je     803136 <merging+0x208>
  803129:	8b 45 0c             	mov    0xc(%ebp),%eax
  80312c:	8b 40 04             	mov    0x4(%eax),%eax
  80312f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803132:	89 10                	mov    %edx,(%eax)
  803134:	eb 08                	jmp    80313e <merging+0x210>
  803136:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803139:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80313e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803141:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803144:	89 50 04             	mov    %edx,0x4(%eax)
  803147:	a1 38 50 80 00       	mov    0x805038,%eax
  80314c:	40                   	inc    %eax
  80314d:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803152:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803156:	75 17                	jne    80316f <merging+0x241>
  803158:	83 ec 04             	sub    $0x4,%esp
  80315b:	68 0f 46 80 00       	push   $0x80460f
  803160:	68 8e 01 00 00       	push   $0x18e
  803165:	68 2d 46 80 00       	push   $0x80462d
  80316a:	e8 00 d1 ff ff       	call   80026f <_panic>
  80316f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803172:	8b 00                	mov    (%eax),%eax
  803174:	85 c0                	test   %eax,%eax
  803176:	74 10                	je     803188 <merging+0x25a>
  803178:	8b 45 0c             	mov    0xc(%ebp),%eax
  80317b:	8b 00                	mov    (%eax),%eax
  80317d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803180:	8b 52 04             	mov    0x4(%edx),%edx
  803183:	89 50 04             	mov    %edx,0x4(%eax)
  803186:	eb 0b                	jmp    803193 <merging+0x265>
  803188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80318b:	8b 40 04             	mov    0x4(%eax),%eax
  80318e:	a3 30 50 80 00       	mov    %eax,0x805030
  803193:	8b 45 0c             	mov    0xc(%ebp),%eax
  803196:	8b 40 04             	mov    0x4(%eax),%eax
  803199:	85 c0                	test   %eax,%eax
  80319b:	74 0f                	je     8031ac <merging+0x27e>
  80319d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031a0:	8b 40 04             	mov    0x4(%eax),%eax
  8031a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031a6:	8b 12                	mov    (%edx),%edx
  8031a8:	89 10                	mov    %edx,(%eax)
  8031aa:	eb 0a                	jmp    8031b6 <merging+0x288>
  8031ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031af:	8b 00                	mov    (%eax),%eax
  8031b1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c9:	a1 38 50 80 00       	mov    0x805038,%eax
  8031ce:	48                   	dec    %eax
  8031cf:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8031d4:	e9 72 01 00 00       	jmp    80334b <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8031d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8031dc:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8031df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031e3:	74 79                	je     80325e <merging+0x330>
  8031e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031e9:	74 73                	je     80325e <merging+0x330>
  8031eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ef:	74 06                	je     8031f7 <merging+0x2c9>
  8031f1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031f5:	75 17                	jne    80320e <merging+0x2e0>
  8031f7:	83 ec 04             	sub    $0x4,%esp
  8031fa:	68 a0 46 80 00       	push   $0x8046a0
  8031ff:	68 94 01 00 00       	push   $0x194
  803204:	68 2d 46 80 00       	push   $0x80462d
  803209:	e8 61 d0 ff ff       	call   80026f <_panic>
  80320e:	8b 45 08             	mov    0x8(%ebp),%eax
  803211:	8b 10                	mov    (%eax),%edx
  803213:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803216:	89 10                	mov    %edx,(%eax)
  803218:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80321b:	8b 00                	mov    (%eax),%eax
  80321d:	85 c0                	test   %eax,%eax
  80321f:	74 0b                	je     80322c <merging+0x2fe>
  803221:	8b 45 08             	mov    0x8(%ebp),%eax
  803224:	8b 00                	mov    (%eax),%eax
  803226:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803229:	89 50 04             	mov    %edx,0x4(%eax)
  80322c:	8b 45 08             	mov    0x8(%ebp),%eax
  80322f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803232:	89 10                	mov    %edx,(%eax)
  803234:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803237:	8b 55 08             	mov    0x8(%ebp),%edx
  80323a:	89 50 04             	mov    %edx,0x4(%eax)
  80323d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803240:	8b 00                	mov    (%eax),%eax
  803242:	85 c0                	test   %eax,%eax
  803244:	75 08                	jne    80324e <merging+0x320>
  803246:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803249:	a3 30 50 80 00       	mov    %eax,0x805030
  80324e:	a1 38 50 80 00       	mov    0x805038,%eax
  803253:	40                   	inc    %eax
  803254:	a3 38 50 80 00       	mov    %eax,0x805038
  803259:	e9 ce 00 00 00       	jmp    80332c <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80325e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803262:	74 65                	je     8032c9 <merging+0x39b>
  803264:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803268:	75 17                	jne    803281 <merging+0x353>
  80326a:	83 ec 04             	sub    $0x4,%esp
  80326d:	68 7c 46 80 00       	push   $0x80467c
  803272:	68 95 01 00 00       	push   $0x195
  803277:	68 2d 46 80 00       	push   $0x80462d
  80327c:	e8 ee cf ff ff       	call   80026f <_panic>
  803281:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803287:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80328a:	89 50 04             	mov    %edx,0x4(%eax)
  80328d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803290:	8b 40 04             	mov    0x4(%eax),%eax
  803293:	85 c0                	test   %eax,%eax
  803295:	74 0c                	je     8032a3 <merging+0x375>
  803297:	a1 30 50 80 00       	mov    0x805030,%eax
  80329c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80329f:	89 10                	mov    %edx,(%eax)
  8032a1:	eb 08                	jmp    8032ab <merging+0x37d>
  8032a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032a6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032ae:	a3 30 50 80 00       	mov    %eax,0x805030
  8032b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032bc:	a1 38 50 80 00       	mov    0x805038,%eax
  8032c1:	40                   	inc    %eax
  8032c2:	a3 38 50 80 00       	mov    %eax,0x805038
  8032c7:	eb 63                	jmp    80332c <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8032c9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8032cd:	75 17                	jne    8032e6 <merging+0x3b8>
  8032cf:	83 ec 04             	sub    $0x4,%esp
  8032d2:	68 48 46 80 00       	push   $0x804648
  8032d7:	68 98 01 00 00       	push   $0x198
  8032dc:	68 2d 46 80 00       	push   $0x80462d
  8032e1:	e8 89 cf ff ff       	call   80026f <_panic>
  8032e6:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8032ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032ef:	89 10                	mov    %edx,(%eax)
  8032f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032f4:	8b 00                	mov    (%eax),%eax
  8032f6:	85 c0                	test   %eax,%eax
  8032f8:	74 0d                	je     803307 <merging+0x3d9>
  8032fa:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032ff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803302:	89 50 04             	mov    %edx,0x4(%eax)
  803305:	eb 08                	jmp    80330f <merging+0x3e1>
  803307:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80330a:	a3 30 50 80 00       	mov    %eax,0x805030
  80330f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803312:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803317:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80331a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803321:	a1 38 50 80 00       	mov    0x805038,%eax
  803326:	40                   	inc    %eax
  803327:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80332c:	83 ec 0c             	sub    $0xc,%esp
  80332f:	ff 75 10             	pushl  0x10(%ebp)
  803332:	e8 f9 ed ff ff       	call   802130 <get_block_size>
  803337:	83 c4 10             	add    $0x10,%esp
  80333a:	83 ec 04             	sub    $0x4,%esp
  80333d:	6a 00                	push   $0x0
  80333f:	50                   	push   %eax
  803340:	ff 75 10             	pushl  0x10(%ebp)
  803343:	e8 39 f1 ff ff       	call   802481 <set_block_data>
  803348:	83 c4 10             	add    $0x10,%esp
	}
}
  80334b:	90                   	nop
  80334c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80334f:	c9                   	leave  
  803350:	c3                   	ret    

00803351 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803351:	55                   	push   %ebp
  803352:	89 e5                	mov    %esp,%ebp
  803354:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803357:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80335c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80335f:	a1 30 50 80 00       	mov    0x805030,%eax
  803364:	3b 45 08             	cmp    0x8(%ebp),%eax
  803367:	73 1b                	jae    803384 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803369:	a1 30 50 80 00       	mov    0x805030,%eax
  80336e:	83 ec 04             	sub    $0x4,%esp
  803371:	ff 75 08             	pushl  0x8(%ebp)
  803374:	6a 00                	push   $0x0
  803376:	50                   	push   %eax
  803377:	e8 b2 fb ff ff       	call   802f2e <merging>
  80337c:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80337f:	e9 8b 00 00 00       	jmp    80340f <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803384:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803389:	3b 45 08             	cmp    0x8(%ebp),%eax
  80338c:	76 18                	jbe    8033a6 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80338e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803393:	83 ec 04             	sub    $0x4,%esp
  803396:	ff 75 08             	pushl  0x8(%ebp)
  803399:	50                   	push   %eax
  80339a:	6a 00                	push   $0x0
  80339c:	e8 8d fb ff ff       	call   802f2e <merging>
  8033a1:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8033a4:	eb 69                	jmp    80340f <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8033a6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033ae:	eb 39                	jmp    8033e9 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8033b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033b6:	73 29                	jae    8033e1 <free_block+0x90>
  8033b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bb:	8b 00                	mov    (%eax),%eax
  8033bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033c0:	76 1f                	jbe    8033e1 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8033c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c5:	8b 00                	mov    (%eax),%eax
  8033c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8033ca:	83 ec 04             	sub    $0x4,%esp
  8033cd:	ff 75 08             	pushl  0x8(%ebp)
  8033d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8033d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8033d6:	e8 53 fb ff ff       	call   802f2e <merging>
  8033db:	83 c4 10             	add    $0x10,%esp
			break;
  8033de:	90                   	nop
		}
	}
}
  8033df:	eb 2e                	jmp    80340f <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8033e1:	a1 34 50 80 00       	mov    0x805034,%eax
  8033e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ed:	74 07                	je     8033f6 <free_block+0xa5>
  8033ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f2:	8b 00                	mov    (%eax),%eax
  8033f4:	eb 05                	jmp    8033fb <free_block+0xaa>
  8033f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8033fb:	a3 34 50 80 00       	mov    %eax,0x805034
  803400:	a1 34 50 80 00       	mov    0x805034,%eax
  803405:	85 c0                	test   %eax,%eax
  803407:	75 a7                	jne    8033b0 <free_block+0x5f>
  803409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80340d:	75 a1                	jne    8033b0 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80340f:	90                   	nop
  803410:	c9                   	leave  
  803411:	c3                   	ret    

00803412 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803412:	55                   	push   %ebp
  803413:	89 e5                	mov    %esp,%ebp
  803415:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803418:	ff 75 08             	pushl  0x8(%ebp)
  80341b:	e8 10 ed ff ff       	call   802130 <get_block_size>
  803420:	83 c4 04             	add    $0x4,%esp
  803423:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803426:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80342d:	eb 17                	jmp    803446 <copy_data+0x34>
  80342f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803432:	8b 45 0c             	mov    0xc(%ebp),%eax
  803435:	01 c2                	add    %eax,%edx
  803437:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80343a:	8b 45 08             	mov    0x8(%ebp),%eax
  80343d:	01 c8                	add    %ecx,%eax
  80343f:	8a 00                	mov    (%eax),%al
  803441:	88 02                	mov    %al,(%edx)
  803443:	ff 45 fc             	incl   -0x4(%ebp)
  803446:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803449:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80344c:	72 e1                	jb     80342f <copy_data+0x1d>
}
  80344e:	90                   	nop
  80344f:	c9                   	leave  
  803450:	c3                   	ret    

00803451 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803451:	55                   	push   %ebp
  803452:	89 e5                	mov    %esp,%ebp
  803454:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803457:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80345b:	75 23                	jne    803480 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80345d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803461:	74 13                	je     803476 <realloc_block_FF+0x25>
  803463:	83 ec 0c             	sub    $0xc,%esp
  803466:	ff 75 0c             	pushl  0xc(%ebp)
  803469:	e8 42 f0 ff ff       	call   8024b0 <alloc_block_FF>
  80346e:	83 c4 10             	add    $0x10,%esp
  803471:	e9 e4 06 00 00       	jmp    803b5a <realloc_block_FF+0x709>
		return NULL;
  803476:	b8 00 00 00 00       	mov    $0x0,%eax
  80347b:	e9 da 06 00 00       	jmp    803b5a <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803480:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803484:	75 18                	jne    80349e <realloc_block_FF+0x4d>
	{
		free_block(va);
  803486:	83 ec 0c             	sub    $0xc,%esp
  803489:	ff 75 08             	pushl  0x8(%ebp)
  80348c:	e8 c0 fe ff ff       	call   803351 <free_block>
  803491:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803494:	b8 00 00 00 00       	mov    $0x0,%eax
  803499:	e9 bc 06 00 00       	jmp    803b5a <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  80349e:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8034a2:	77 07                	ja     8034ab <realloc_block_FF+0x5a>
  8034a4:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8034ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ae:	83 e0 01             	and    $0x1,%eax
  8034b1:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8034b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b7:	83 c0 08             	add    $0x8,%eax
  8034ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8034bd:	83 ec 0c             	sub    $0xc,%esp
  8034c0:	ff 75 08             	pushl  0x8(%ebp)
  8034c3:	e8 68 ec ff ff       	call   802130 <get_block_size>
  8034c8:	83 c4 10             	add    $0x10,%esp
  8034cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8034ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d1:	83 e8 08             	sub    $0x8,%eax
  8034d4:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8034d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034da:	83 e8 04             	sub    $0x4,%eax
  8034dd:	8b 00                	mov    (%eax),%eax
  8034df:	83 e0 fe             	and    $0xfffffffe,%eax
  8034e2:	89 c2                	mov    %eax,%edx
  8034e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e7:	01 d0                	add    %edx,%eax
  8034e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8034ec:	83 ec 0c             	sub    $0xc,%esp
  8034ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034f2:	e8 39 ec ff ff       	call   802130 <get_block_size>
  8034f7:	83 c4 10             	add    $0x10,%esp
  8034fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8034fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803500:	83 e8 08             	sub    $0x8,%eax
  803503:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803506:	8b 45 0c             	mov    0xc(%ebp),%eax
  803509:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80350c:	75 08                	jne    803516 <realloc_block_FF+0xc5>
	{
		 return va;
  80350e:	8b 45 08             	mov    0x8(%ebp),%eax
  803511:	e9 44 06 00 00       	jmp    803b5a <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803516:	8b 45 0c             	mov    0xc(%ebp),%eax
  803519:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80351c:	0f 83 d5 03 00 00    	jae    8038f7 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803522:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803525:	2b 45 0c             	sub    0xc(%ebp),%eax
  803528:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80352b:	83 ec 0c             	sub    $0xc,%esp
  80352e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803531:	e8 13 ec ff ff       	call   802149 <is_free_block>
  803536:	83 c4 10             	add    $0x10,%esp
  803539:	84 c0                	test   %al,%al
  80353b:	0f 84 3b 01 00 00    	je     80367c <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803541:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803544:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803547:	01 d0                	add    %edx,%eax
  803549:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80354c:	83 ec 04             	sub    $0x4,%esp
  80354f:	6a 01                	push   $0x1
  803551:	ff 75 f0             	pushl  -0x10(%ebp)
  803554:	ff 75 08             	pushl  0x8(%ebp)
  803557:	e8 25 ef ff ff       	call   802481 <set_block_data>
  80355c:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80355f:	8b 45 08             	mov    0x8(%ebp),%eax
  803562:	83 e8 04             	sub    $0x4,%eax
  803565:	8b 00                	mov    (%eax),%eax
  803567:	83 e0 fe             	and    $0xfffffffe,%eax
  80356a:	89 c2                	mov    %eax,%edx
  80356c:	8b 45 08             	mov    0x8(%ebp),%eax
  80356f:	01 d0                	add    %edx,%eax
  803571:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803574:	83 ec 04             	sub    $0x4,%esp
  803577:	6a 00                	push   $0x0
  803579:	ff 75 cc             	pushl  -0x34(%ebp)
  80357c:	ff 75 c8             	pushl  -0x38(%ebp)
  80357f:	e8 fd ee ff ff       	call   802481 <set_block_data>
  803584:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803587:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80358b:	74 06                	je     803593 <realloc_block_FF+0x142>
  80358d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803591:	75 17                	jne    8035aa <realloc_block_FF+0x159>
  803593:	83 ec 04             	sub    $0x4,%esp
  803596:	68 a0 46 80 00       	push   $0x8046a0
  80359b:	68 f6 01 00 00       	push   $0x1f6
  8035a0:	68 2d 46 80 00       	push   $0x80462d
  8035a5:	e8 c5 cc ff ff       	call   80026f <_panic>
  8035aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ad:	8b 10                	mov    (%eax),%edx
  8035af:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035b2:	89 10                	mov    %edx,(%eax)
  8035b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035b7:	8b 00                	mov    (%eax),%eax
  8035b9:	85 c0                	test   %eax,%eax
  8035bb:	74 0b                	je     8035c8 <realloc_block_FF+0x177>
  8035bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c0:	8b 00                	mov    (%eax),%eax
  8035c2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035c5:	89 50 04             	mov    %edx,0x4(%eax)
  8035c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035cb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035ce:	89 10                	mov    %edx,(%eax)
  8035d0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035d6:	89 50 04             	mov    %edx,0x4(%eax)
  8035d9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035dc:	8b 00                	mov    (%eax),%eax
  8035de:	85 c0                	test   %eax,%eax
  8035e0:	75 08                	jne    8035ea <realloc_block_FF+0x199>
  8035e2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035e5:	a3 30 50 80 00       	mov    %eax,0x805030
  8035ea:	a1 38 50 80 00       	mov    0x805038,%eax
  8035ef:	40                   	inc    %eax
  8035f0:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8035f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035f9:	75 17                	jne    803612 <realloc_block_FF+0x1c1>
  8035fb:	83 ec 04             	sub    $0x4,%esp
  8035fe:	68 0f 46 80 00       	push   $0x80460f
  803603:	68 f7 01 00 00       	push   $0x1f7
  803608:	68 2d 46 80 00       	push   $0x80462d
  80360d:	e8 5d cc ff ff       	call   80026f <_panic>
  803612:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803615:	8b 00                	mov    (%eax),%eax
  803617:	85 c0                	test   %eax,%eax
  803619:	74 10                	je     80362b <realloc_block_FF+0x1da>
  80361b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361e:	8b 00                	mov    (%eax),%eax
  803620:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803623:	8b 52 04             	mov    0x4(%edx),%edx
  803626:	89 50 04             	mov    %edx,0x4(%eax)
  803629:	eb 0b                	jmp    803636 <realloc_block_FF+0x1e5>
  80362b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80362e:	8b 40 04             	mov    0x4(%eax),%eax
  803631:	a3 30 50 80 00       	mov    %eax,0x805030
  803636:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803639:	8b 40 04             	mov    0x4(%eax),%eax
  80363c:	85 c0                	test   %eax,%eax
  80363e:	74 0f                	je     80364f <realloc_block_FF+0x1fe>
  803640:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803643:	8b 40 04             	mov    0x4(%eax),%eax
  803646:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803649:	8b 12                	mov    (%edx),%edx
  80364b:	89 10                	mov    %edx,(%eax)
  80364d:	eb 0a                	jmp    803659 <realloc_block_FF+0x208>
  80364f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803652:	8b 00                	mov    (%eax),%eax
  803654:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803659:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80365c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803662:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803665:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80366c:	a1 38 50 80 00       	mov    0x805038,%eax
  803671:	48                   	dec    %eax
  803672:	a3 38 50 80 00       	mov    %eax,0x805038
  803677:	e9 73 02 00 00       	jmp    8038ef <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  80367c:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803680:	0f 86 69 02 00 00    	jbe    8038ef <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803686:	83 ec 04             	sub    $0x4,%esp
  803689:	6a 01                	push   $0x1
  80368b:	ff 75 f0             	pushl  -0x10(%ebp)
  80368e:	ff 75 08             	pushl  0x8(%ebp)
  803691:	e8 eb ed ff ff       	call   802481 <set_block_data>
  803696:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803699:	8b 45 08             	mov    0x8(%ebp),%eax
  80369c:	83 e8 04             	sub    $0x4,%eax
  80369f:	8b 00                	mov    (%eax),%eax
  8036a1:	83 e0 fe             	and    $0xfffffffe,%eax
  8036a4:	89 c2                	mov    %eax,%edx
  8036a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a9:	01 d0                	add    %edx,%eax
  8036ab:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8036ae:	a1 38 50 80 00       	mov    0x805038,%eax
  8036b3:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8036b6:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8036ba:	75 68                	jne    803724 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036bc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036c0:	75 17                	jne    8036d9 <realloc_block_FF+0x288>
  8036c2:	83 ec 04             	sub    $0x4,%esp
  8036c5:	68 48 46 80 00       	push   $0x804648
  8036ca:	68 06 02 00 00       	push   $0x206
  8036cf:	68 2d 46 80 00       	push   $0x80462d
  8036d4:	e8 96 cb ff ff       	call   80026f <_panic>
  8036d9:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8036df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e2:	89 10                	mov    %edx,(%eax)
  8036e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e7:	8b 00                	mov    (%eax),%eax
  8036e9:	85 c0                	test   %eax,%eax
  8036eb:	74 0d                	je     8036fa <realloc_block_FF+0x2a9>
  8036ed:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036f2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036f5:	89 50 04             	mov    %edx,0x4(%eax)
  8036f8:	eb 08                	jmp    803702 <realloc_block_FF+0x2b1>
  8036fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036fd:	a3 30 50 80 00       	mov    %eax,0x805030
  803702:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803705:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80370a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80370d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803714:	a1 38 50 80 00       	mov    0x805038,%eax
  803719:	40                   	inc    %eax
  80371a:	a3 38 50 80 00       	mov    %eax,0x805038
  80371f:	e9 b0 01 00 00       	jmp    8038d4 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803724:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803729:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80372c:	76 68                	jbe    803796 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80372e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803732:	75 17                	jne    80374b <realloc_block_FF+0x2fa>
  803734:	83 ec 04             	sub    $0x4,%esp
  803737:	68 48 46 80 00       	push   $0x804648
  80373c:	68 0b 02 00 00       	push   $0x20b
  803741:	68 2d 46 80 00       	push   $0x80462d
  803746:	e8 24 cb ff ff       	call   80026f <_panic>
  80374b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803751:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803754:	89 10                	mov    %edx,(%eax)
  803756:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803759:	8b 00                	mov    (%eax),%eax
  80375b:	85 c0                	test   %eax,%eax
  80375d:	74 0d                	je     80376c <realloc_block_FF+0x31b>
  80375f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803764:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803767:	89 50 04             	mov    %edx,0x4(%eax)
  80376a:	eb 08                	jmp    803774 <realloc_block_FF+0x323>
  80376c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80376f:	a3 30 50 80 00       	mov    %eax,0x805030
  803774:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803777:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80377c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80377f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803786:	a1 38 50 80 00       	mov    0x805038,%eax
  80378b:	40                   	inc    %eax
  80378c:	a3 38 50 80 00       	mov    %eax,0x805038
  803791:	e9 3e 01 00 00       	jmp    8038d4 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803796:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80379b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80379e:	73 68                	jae    803808 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8037a0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037a4:	75 17                	jne    8037bd <realloc_block_FF+0x36c>
  8037a6:	83 ec 04             	sub    $0x4,%esp
  8037a9:	68 7c 46 80 00       	push   $0x80467c
  8037ae:	68 10 02 00 00       	push   $0x210
  8037b3:	68 2d 46 80 00       	push   $0x80462d
  8037b8:	e8 b2 ca ff ff       	call   80026f <_panic>
  8037bd:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8037c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037c6:	89 50 04             	mov    %edx,0x4(%eax)
  8037c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037cc:	8b 40 04             	mov    0x4(%eax),%eax
  8037cf:	85 c0                	test   %eax,%eax
  8037d1:	74 0c                	je     8037df <realloc_block_FF+0x38e>
  8037d3:	a1 30 50 80 00       	mov    0x805030,%eax
  8037d8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037db:	89 10                	mov    %edx,(%eax)
  8037dd:	eb 08                	jmp    8037e7 <realloc_block_FF+0x396>
  8037df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037e2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037ea:	a3 30 50 80 00       	mov    %eax,0x805030
  8037ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037f8:	a1 38 50 80 00       	mov    0x805038,%eax
  8037fd:	40                   	inc    %eax
  8037fe:	a3 38 50 80 00       	mov    %eax,0x805038
  803803:	e9 cc 00 00 00       	jmp    8038d4 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803808:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80380f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803814:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803817:	e9 8a 00 00 00       	jmp    8038a6 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80381c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80381f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803822:	73 7a                	jae    80389e <realloc_block_FF+0x44d>
  803824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803827:	8b 00                	mov    (%eax),%eax
  803829:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80382c:	73 70                	jae    80389e <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80382e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803832:	74 06                	je     80383a <realloc_block_FF+0x3e9>
  803834:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803838:	75 17                	jne    803851 <realloc_block_FF+0x400>
  80383a:	83 ec 04             	sub    $0x4,%esp
  80383d:	68 a0 46 80 00       	push   $0x8046a0
  803842:	68 1a 02 00 00       	push   $0x21a
  803847:	68 2d 46 80 00       	push   $0x80462d
  80384c:	e8 1e ca ff ff       	call   80026f <_panic>
  803851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803854:	8b 10                	mov    (%eax),%edx
  803856:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803859:	89 10                	mov    %edx,(%eax)
  80385b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80385e:	8b 00                	mov    (%eax),%eax
  803860:	85 c0                	test   %eax,%eax
  803862:	74 0b                	je     80386f <realloc_block_FF+0x41e>
  803864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803867:	8b 00                	mov    (%eax),%eax
  803869:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80386c:	89 50 04             	mov    %edx,0x4(%eax)
  80386f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803872:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803875:	89 10                	mov    %edx,(%eax)
  803877:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80387a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80387d:	89 50 04             	mov    %edx,0x4(%eax)
  803880:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803883:	8b 00                	mov    (%eax),%eax
  803885:	85 c0                	test   %eax,%eax
  803887:	75 08                	jne    803891 <realloc_block_FF+0x440>
  803889:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80388c:	a3 30 50 80 00       	mov    %eax,0x805030
  803891:	a1 38 50 80 00       	mov    0x805038,%eax
  803896:	40                   	inc    %eax
  803897:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80389c:	eb 36                	jmp    8038d4 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80389e:	a1 34 50 80 00       	mov    0x805034,%eax
  8038a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038aa:	74 07                	je     8038b3 <realloc_block_FF+0x462>
  8038ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038af:	8b 00                	mov    (%eax),%eax
  8038b1:	eb 05                	jmp    8038b8 <realloc_block_FF+0x467>
  8038b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8038b8:	a3 34 50 80 00       	mov    %eax,0x805034
  8038bd:	a1 34 50 80 00       	mov    0x805034,%eax
  8038c2:	85 c0                	test   %eax,%eax
  8038c4:	0f 85 52 ff ff ff    	jne    80381c <realloc_block_FF+0x3cb>
  8038ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038ce:	0f 85 48 ff ff ff    	jne    80381c <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8038d4:	83 ec 04             	sub    $0x4,%esp
  8038d7:	6a 00                	push   $0x0
  8038d9:	ff 75 d8             	pushl  -0x28(%ebp)
  8038dc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8038df:	e8 9d eb ff ff       	call   802481 <set_block_data>
  8038e4:	83 c4 10             	add    $0x10,%esp
				return va;
  8038e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ea:	e9 6b 02 00 00       	jmp    803b5a <realloc_block_FF+0x709>
			}
			
		}
		return va;
  8038ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f2:	e9 63 02 00 00       	jmp    803b5a <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  8038f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038fa:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038fd:	0f 86 4d 02 00 00    	jbe    803b50 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803903:	83 ec 0c             	sub    $0xc,%esp
  803906:	ff 75 e4             	pushl  -0x1c(%ebp)
  803909:	e8 3b e8 ff ff       	call   802149 <is_free_block>
  80390e:	83 c4 10             	add    $0x10,%esp
  803911:	84 c0                	test   %al,%al
  803913:	0f 84 37 02 00 00    	je     803b50 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803919:	8b 45 0c             	mov    0xc(%ebp),%eax
  80391c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80391f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803922:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803925:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803928:	76 38                	jbe    803962 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  80392a:	83 ec 0c             	sub    $0xc,%esp
  80392d:	ff 75 0c             	pushl  0xc(%ebp)
  803930:	e8 7b eb ff ff       	call   8024b0 <alloc_block_FF>
  803935:	83 c4 10             	add    $0x10,%esp
  803938:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80393b:	83 ec 08             	sub    $0x8,%esp
  80393e:	ff 75 c0             	pushl  -0x40(%ebp)
  803941:	ff 75 08             	pushl  0x8(%ebp)
  803944:	e8 c9 fa ff ff       	call   803412 <copy_data>
  803949:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  80394c:	83 ec 0c             	sub    $0xc,%esp
  80394f:	ff 75 08             	pushl  0x8(%ebp)
  803952:	e8 fa f9 ff ff       	call   803351 <free_block>
  803957:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80395a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80395d:	e9 f8 01 00 00       	jmp    803b5a <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803962:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803965:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803968:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80396b:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80396f:	0f 87 a0 00 00 00    	ja     803a15 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803975:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803979:	75 17                	jne    803992 <realloc_block_FF+0x541>
  80397b:	83 ec 04             	sub    $0x4,%esp
  80397e:	68 0f 46 80 00       	push   $0x80460f
  803983:	68 38 02 00 00       	push   $0x238
  803988:	68 2d 46 80 00       	push   $0x80462d
  80398d:	e8 dd c8 ff ff       	call   80026f <_panic>
  803992:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803995:	8b 00                	mov    (%eax),%eax
  803997:	85 c0                	test   %eax,%eax
  803999:	74 10                	je     8039ab <realloc_block_FF+0x55a>
  80399b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399e:	8b 00                	mov    (%eax),%eax
  8039a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039a3:	8b 52 04             	mov    0x4(%edx),%edx
  8039a6:	89 50 04             	mov    %edx,0x4(%eax)
  8039a9:	eb 0b                	jmp    8039b6 <realloc_block_FF+0x565>
  8039ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ae:	8b 40 04             	mov    0x4(%eax),%eax
  8039b1:	a3 30 50 80 00       	mov    %eax,0x805030
  8039b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b9:	8b 40 04             	mov    0x4(%eax),%eax
  8039bc:	85 c0                	test   %eax,%eax
  8039be:	74 0f                	je     8039cf <realloc_block_FF+0x57e>
  8039c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c3:	8b 40 04             	mov    0x4(%eax),%eax
  8039c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039c9:	8b 12                	mov    (%edx),%edx
  8039cb:	89 10                	mov    %edx,(%eax)
  8039cd:	eb 0a                	jmp    8039d9 <realloc_block_FF+0x588>
  8039cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d2:	8b 00                	mov    (%eax),%eax
  8039d4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039ec:	a1 38 50 80 00       	mov    0x805038,%eax
  8039f1:	48                   	dec    %eax
  8039f2:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8039f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039fd:	01 d0                	add    %edx,%eax
  8039ff:	83 ec 04             	sub    $0x4,%esp
  803a02:	6a 01                	push   $0x1
  803a04:	50                   	push   %eax
  803a05:	ff 75 08             	pushl  0x8(%ebp)
  803a08:	e8 74 ea ff ff       	call   802481 <set_block_data>
  803a0d:	83 c4 10             	add    $0x10,%esp
  803a10:	e9 36 01 00 00       	jmp    803b4b <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803a15:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a18:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803a1b:	01 d0                	add    %edx,%eax
  803a1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803a20:	83 ec 04             	sub    $0x4,%esp
  803a23:	6a 01                	push   $0x1
  803a25:	ff 75 f0             	pushl  -0x10(%ebp)
  803a28:	ff 75 08             	pushl  0x8(%ebp)
  803a2b:	e8 51 ea ff ff       	call   802481 <set_block_data>
  803a30:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a33:	8b 45 08             	mov    0x8(%ebp),%eax
  803a36:	83 e8 04             	sub    $0x4,%eax
  803a39:	8b 00                	mov    (%eax),%eax
  803a3b:	83 e0 fe             	and    $0xfffffffe,%eax
  803a3e:	89 c2                	mov    %eax,%edx
  803a40:	8b 45 08             	mov    0x8(%ebp),%eax
  803a43:	01 d0                	add    %edx,%eax
  803a45:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a48:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a4c:	74 06                	je     803a54 <realloc_block_FF+0x603>
  803a4e:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803a52:	75 17                	jne    803a6b <realloc_block_FF+0x61a>
  803a54:	83 ec 04             	sub    $0x4,%esp
  803a57:	68 a0 46 80 00       	push   $0x8046a0
  803a5c:	68 44 02 00 00       	push   $0x244
  803a61:	68 2d 46 80 00       	push   $0x80462d
  803a66:	e8 04 c8 ff ff       	call   80026f <_panic>
  803a6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a6e:	8b 10                	mov    (%eax),%edx
  803a70:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a73:	89 10                	mov    %edx,(%eax)
  803a75:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a78:	8b 00                	mov    (%eax),%eax
  803a7a:	85 c0                	test   %eax,%eax
  803a7c:	74 0b                	je     803a89 <realloc_block_FF+0x638>
  803a7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a81:	8b 00                	mov    (%eax),%eax
  803a83:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a86:	89 50 04             	mov    %edx,0x4(%eax)
  803a89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a8c:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a8f:	89 10                	mov    %edx,(%eax)
  803a91:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a94:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a97:	89 50 04             	mov    %edx,0x4(%eax)
  803a9a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a9d:	8b 00                	mov    (%eax),%eax
  803a9f:	85 c0                	test   %eax,%eax
  803aa1:	75 08                	jne    803aab <realloc_block_FF+0x65a>
  803aa3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803aa6:	a3 30 50 80 00       	mov    %eax,0x805030
  803aab:	a1 38 50 80 00       	mov    0x805038,%eax
  803ab0:	40                   	inc    %eax
  803ab1:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803ab6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803aba:	75 17                	jne    803ad3 <realloc_block_FF+0x682>
  803abc:	83 ec 04             	sub    $0x4,%esp
  803abf:	68 0f 46 80 00       	push   $0x80460f
  803ac4:	68 45 02 00 00       	push   $0x245
  803ac9:	68 2d 46 80 00       	push   $0x80462d
  803ace:	e8 9c c7 ff ff       	call   80026f <_panic>
  803ad3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad6:	8b 00                	mov    (%eax),%eax
  803ad8:	85 c0                	test   %eax,%eax
  803ada:	74 10                	je     803aec <realloc_block_FF+0x69b>
  803adc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803adf:	8b 00                	mov    (%eax),%eax
  803ae1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ae4:	8b 52 04             	mov    0x4(%edx),%edx
  803ae7:	89 50 04             	mov    %edx,0x4(%eax)
  803aea:	eb 0b                	jmp    803af7 <realloc_block_FF+0x6a6>
  803aec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aef:	8b 40 04             	mov    0x4(%eax),%eax
  803af2:	a3 30 50 80 00       	mov    %eax,0x805030
  803af7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803afa:	8b 40 04             	mov    0x4(%eax),%eax
  803afd:	85 c0                	test   %eax,%eax
  803aff:	74 0f                	je     803b10 <realloc_block_FF+0x6bf>
  803b01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b04:	8b 40 04             	mov    0x4(%eax),%eax
  803b07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b0a:	8b 12                	mov    (%edx),%edx
  803b0c:	89 10                	mov    %edx,(%eax)
  803b0e:	eb 0a                	jmp    803b1a <realloc_block_FF+0x6c9>
  803b10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b13:	8b 00                	mov    (%eax),%eax
  803b15:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803b1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b2d:	a1 38 50 80 00       	mov    0x805038,%eax
  803b32:	48                   	dec    %eax
  803b33:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803b38:	83 ec 04             	sub    $0x4,%esp
  803b3b:	6a 00                	push   $0x0
  803b3d:	ff 75 bc             	pushl  -0x44(%ebp)
  803b40:	ff 75 b8             	pushl  -0x48(%ebp)
  803b43:	e8 39 e9 ff ff       	call   802481 <set_block_data>
  803b48:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b4e:	eb 0a                	jmp    803b5a <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803b50:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803b57:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803b5a:	c9                   	leave  
  803b5b:	c3                   	ret    

00803b5c <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803b5c:	55                   	push   %ebp
  803b5d:	89 e5                	mov    %esp,%ebp
  803b5f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803b62:	83 ec 04             	sub    $0x4,%esp
  803b65:	68 0c 47 80 00       	push   $0x80470c
  803b6a:	68 58 02 00 00       	push   $0x258
  803b6f:	68 2d 46 80 00       	push   $0x80462d
  803b74:	e8 f6 c6 ff ff       	call   80026f <_panic>

00803b79 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803b79:	55                   	push   %ebp
  803b7a:	89 e5                	mov    %esp,%ebp
  803b7c:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803b7f:	83 ec 04             	sub    $0x4,%esp
  803b82:	68 34 47 80 00       	push   $0x804734
  803b87:	68 61 02 00 00       	push   $0x261
  803b8c:	68 2d 46 80 00       	push   $0x80462d
  803b91:	e8 d9 c6 ff ff       	call   80026f <_panic>
  803b96:	66 90                	xchg   %ax,%ax

00803b98 <__udivdi3>:
  803b98:	55                   	push   %ebp
  803b99:	57                   	push   %edi
  803b9a:	56                   	push   %esi
  803b9b:	53                   	push   %ebx
  803b9c:	83 ec 1c             	sub    $0x1c,%esp
  803b9f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803ba3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803ba7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803baf:	89 ca                	mov    %ecx,%edx
  803bb1:	89 f8                	mov    %edi,%eax
  803bb3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803bb7:	85 f6                	test   %esi,%esi
  803bb9:	75 2d                	jne    803be8 <__udivdi3+0x50>
  803bbb:	39 cf                	cmp    %ecx,%edi
  803bbd:	77 65                	ja     803c24 <__udivdi3+0x8c>
  803bbf:	89 fd                	mov    %edi,%ebp
  803bc1:	85 ff                	test   %edi,%edi
  803bc3:	75 0b                	jne    803bd0 <__udivdi3+0x38>
  803bc5:	b8 01 00 00 00       	mov    $0x1,%eax
  803bca:	31 d2                	xor    %edx,%edx
  803bcc:	f7 f7                	div    %edi
  803bce:	89 c5                	mov    %eax,%ebp
  803bd0:	31 d2                	xor    %edx,%edx
  803bd2:	89 c8                	mov    %ecx,%eax
  803bd4:	f7 f5                	div    %ebp
  803bd6:	89 c1                	mov    %eax,%ecx
  803bd8:	89 d8                	mov    %ebx,%eax
  803bda:	f7 f5                	div    %ebp
  803bdc:	89 cf                	mov    %ecx,%edi
  803bde:	89 fa                	mov    %edi,%edx
  803be0:	83 c4 1c             	add    $0x1c,%esp
  803be3:	5b                   	pop    %ebx
  803be4:	5e                   	pop    %esi
  803be5:	5f                   	pop    %edi
  803be6:	5d                   	pop    %ebp
  803be7:	c3                   	ret    
  803be8:	39 ce                	cmp    %ecx,%esi
  803bea:	77 28                	ja     803c14 <__udivdi3+0x7c>
  803bec:	0f bd fe             	bsr    %esi,%edi
  803bef:	83 f7 1f             	xor    $0x1f,%edi
  803bf2:	75 40                	jne    803c34 <__udivdi3+0x9c>
  803bf4:	39 ce                	cmp    %ecx,%esi
  803bf6:	72 0a                	jb     803c02 <__udivdi3+0x6a>
  803bf8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bfc:	0f 87 9e 00 00 00    	ja     803ca0 <__udivdi3+0x108>
  803c02:	b8 01 00 00 00       	mov    $0x1,%eax
  803c07:	89 fa                	mov    %edi,%edx
  803c09:	83 c4 1c             	add    $0x1c,%esp
  803c0c:	5b                   	pop    %ebx
  803c0d:	5e                   	pop    %esi
  803c0e:	5f                   	pop    %edi
  803c0f:	5d                   	pop    %ebp
  803c10:	c3                   	ret    
  803c11:	8d 76 00             	lea    0x0(%esi),%esi
  803c14:	31 ff                	xor    %edi,%edi
  803c16:	31 c0                	xor    %eax,%eax
  803c18:	89 fa                	mov    %edi,%edx
  803c1a:	83 c4 1c             	add    $0x1c,%esp
  803c1d:	5b                   	pop    %ebx
  803c1e:	5e                   	pop    %esi
  803c1f:	5f                   	pop    %edi
  803c20:	5d                   	pop    %ebp
  803c21:	c3                   	ret    
  803c22:	66 90                	xchg   %ax,%ax
  803c24:	89 d8                	mov    %ebx,%eax
  803c26:	f7 f7                	div    %edi
  803c28:	31 ff                	xor    %edi,%edi
  803c2a:	89 fa                	mov    %edi,%edx
  803c2c:	83 c4 1c             	add    $0x1c,%esp
  803c2f:	5b                   	pop    %ebx
  803c30:	5e                   	pop    %esi
  803c31:	5f                   	pop    %edi
  803c32:	5d                   	pop    %ebp
  803c33:	c3                   	ret    
  803c34:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c39:	89 eb                	mov    %ebp,%ebx
  803c3b:	29 fb                	sub    %edi,%ebx
  803c3d:	89 f9                	mov    %edi,%ecx
  803c3f:	d3 e6                	shl    %cl,%esi
  803c41:	89 c5                	mov    %eax,%ebp
  803c43:	88 d9                	mov    %bl,%cl
  803c45:	d3 ed                	shr    %cl,%ebp
  803c47:	89 e9                	mov    %ebp,%ecx
  803c49:	09 f1                	or     %esi,%ecx
  803c4b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c4f:	89 f9                	mov    %edi,%ecx
  803c51:	d3 e0                	shl    %cl,%eax
  803c53:	89 c5                	mov    %eax,%ebp
  803c55:	89 d6                	mov    %edx,%esi
  803c57:	88 d9                	mov    %bl,%cl
  803c59:	d3 ee                	shr    %cl,%esi
  803c5b:	89 f9                	mov    %edi,%ecx
  803c5d:	d3 e2                	shl    %cl,%edx
  803c5f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c63:	88 d9                	mov    %bl,%cl
  803c65:	d3 e8                	shr    %cl,%eax
  803c67:	09 c2                	or     %eax,%edx
  803c69:	89 d0                	mov    %edx,%eax
  803c6b:	89 f2                	mov    %esi,%edx
  803c6d:	f7 74 24 0c          	divl   0xc(%esp)
  803c71:	89 d6                	mov    %edx,%esi
  803c73:	89 c3                	mov    %eax,%ebx
  803c75:	f7 e5                	mul    %ebp
  803c77:	39 d6                	cmp    %edx,%esi
  803c79:	72 19                	jb     803c94 <__udivdi3+0xfc>
  803c7b:	74 0b                	je     803c88 <__udivdi3+0xf0>
  803c7d:	89 d8                	mov    %ebx,%eax
  803c7f:	31 ff                	xor    %edi,%edi
  803c81:	e9 58 ff ff ff       	jmp    803bde <__udivdi3+0x46>
  803c86:	66 90                	xchg   %ax,%ax
  803c88:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c8c:	89 f9                	mov    %edi,%ecx
  803c8e:	d3 e2                	shl    %cl,%edx
  803c90:	39 c2                	cmp    %eax,%edx
  803c92:	73 e9                	jae    803c7d <__udivdi3+0xe5>
  803c94:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c97:	31 ff                	xor    %edi,%edi
  803c99:	e9 40 ff ff ff       	jmp    803bde <__udivdi3+0x46>
  803c9e:	66 90                	xchg   %ax,%ax
  803ca0:	31 c0                	xor    %eax,%eax
  803ca2:	e9 37 ff ff ff       	jmp    803bde <__udivdi3+0x46>
  803ca7:	90                   	nop

00803ca8 <__umoddi3>:
  803ca8:	55                   	push   %ebp
  803ca9:	57                   	push   %edi
  803caa:	56                   	push   %esi
  803cab:	53                   	push   %ebx
  803cac:	83 ec 1c             	sub    $0x1c,%esp
  803caf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803cb3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803cb7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cbb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803cbf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803cc3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803cc7:	89 f3                	mov    %esi,%ebx
  803cc9:	89 fa                	mov    %edi,%edx
  803ccb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ccf:	89 34 24             	mov    %esi,(%esp)
  803cd2:	85 c0                	test   %eax,%eax
  803cd4:	75 1a                	jne    803cf0 <__umoddi3+0x48>
  803cd6:	39 f7                	cmp    %esi,%edi
  803cd8:	0f 86 a2 00 00 00    	jbe    803d80 <__umoddi3+0xd8>
  803cde:	89 c8                	mov    %ecx,%eax
  803ce0:	89 f2                	mov    %esi,%edx
  803ce2:	f7 f7                	div    %edi
  803ce4:	89 d0                	mov    %edx,%eax
  803ce6:	31 d2                	xor    %edx,%edx
  803ce8:	83 c4 1c             	add    $0x1c,%esp
  803ceb:	5b                   	pop    %ebx
  803cec:	5e                   	pop    %esi
  803ced:	5f                   	pop    %edi
  803cee:	5d                   	pop    %ebp
  803cef:	c3                   	ret    
  803cf0:	39 f0                	cmp    %esi,%eax
  803cf2:	0f 87 ac 00 00 00    	ja     803da4 <__umoddi3+0xfc>
  803cf8:	0f bd e8             	bsr    %eax,%ebp
  803cfb:	83 f5 1f             	xor    $0x1f,%ebp
  803cfe:	0f 84 ac 00 00 00    	je     803db0 <__umoddi3+0x108>
  803d04:	bf 20 00 00 00       	mov    $0x20,%edi
  803d09:	29 ef                	sub    %ebp,%edi
  803d0b:	89 fe                	mov    %edi,%esi
  803d0d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d11:	89 e9                	mov    %ebp,%ecx
  803d13:	d3 e0                	shl    %cl,%eax
  803d15:	89 d7                	mov    %edx,%edi
  803d17:	89 f1                	mov    %esi,%ecx
  803d19:	d3 ef                	shr    %cl,%edi
  803d1b:	09 c7                	or     %eax,%edi
  803d1d:	89 e9                	mov    %ebp,%ecx
  803d1f:	d3 e2                	shl    %cl,%edx
  803d21:	89 14 24             	mov    %edx,(%esp)
  803d24:	89 d8                	mov    %ebx,%eax
  803d26:	d3 e0                	shl    %cl,%eax
  803d28:	89 c2                	mov    %eax,%edx
  803d2a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d2e:	d3 e0                	shl    %cl,%eax
  803d30:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d34:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d38:	89 f1                	mov    %esi,%ecx
  803d3a:	d3 e8                	shr    %cl,%eax
  803d3c:	09 d0                	or     %edx,%eax
  803d3e:	d3 eb                	shr    %cl,%ebx
  803d40:	89 da                	mov    %ebx,%edx
  803d42:	f7 f7                	div    %edi
  803d44:	89 d3                	mov    %edx,%ebx
  803d46:	f7 24 24             	mull   (%esp)
  803d49:	89 c6                	mov    %eax,%esi
  803d4b:	89 d1                	mov    %edx,%ecx
  803d4d:	39 d3                	cmp    %edx,%ebx
  803d4f:	0f 82 87 00 00 00    	jb     803ddc <__umoddi3+0x134>
  803d55:	0f 84 91 00 00 00    	je     803dec <__umoddi3+0x144>
  803d5b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d5f:	29 f2                	sub    %esi,%edx
  803d61:	19 cb                	sbb    %ecx,%ebx
  803d63:	89 d8                	mov    %ebx,%eax
  803d65:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d69:	d3 e0                	shl    %cl,%eax
  803d6b:	89 e9                	mov    %ebp,%ecx
  803d6d:	d3 ea                	shr    %cl,%edx
  803d6f:	09 d0                	or     %edx,%eax
  803d71:	89 e9                	mov    %ebp,%ecx
  803d73:	d3 eb                	shr    %cl,%ebx
  803d75:	89 da                	mov    %ebx,%edx
  803d77:	83 c4 1c             	add    $0x1c,%esp
  803d7a:	5b                   	pop    %ebx
  803d7b:	5e                   	pop    %esi
  803d7c:	5f                   	pop    %edi
  803d7d:	5d                   	pop    %ebp
  803d7e:	c3                   	ret    
  803d7f:	90                   	nop
  803d80:	89 fd                	mov    %edi,%ebp
  803d82:	85 ff                	test   %edi,%edi
  803d84:	75 0b                	jne    803d91 <__umoddi3+0xe9>
  803d86:	b8 01 00 00 00       	mov    $0x1,%eax
  803d8b:	31 d2                	xor    %edx,%edx
  803d8d:	f7 f7                	div    %edi
  803d8f:	89 c5                	mov    %eax,%ebp
  803d91:	89 f0                	mov    %esi,%eax
  803d93:	31 d2                	xor    %edx,%edx
  803d95:	f7 f5                	div    %ebp
  803d97:	89 c8                	mov    %ecx,%eax
  803d99:	f7 f5                	div    %ebp
  803d9b:	89 d0                	mov    %edx,%eax
  803d9d:	e9 44 ff ff ff       	jmp    803ce6 <__umoddi3+0x3e>
  803da2:	66 90                	xchg   %ax,%ax
  803da4:	89 c8                	mov    %ecx,%eax
  803da6:	89 f2                	mov    %esi,%edx
  803da8:	83 c4 1c             	add    $0x1c,%esp
  803dab:	5b                   	pop    %ebx
  803dac:	5e                   	pop    %esi
  803dad:	5f                   	pop    %edi
  803dae:	5d                   	pop    %ebp
  803daf:	c3                   	ret    
  803db0:	3b 04 24             	cmp    (%esp),%eax
  803db3:	72 06                	jb     803dbb <__umoddi3+0x113>
  803db5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803db9:	77 0f                	ja     803dca <__umoddi3+0x122>
  803dbb:	89 f2                	mov    %esi,%edx
  803dbd:	29 f9                	sub    %edi,%ecx
  803dbf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803dc3:	89 14 24             	mov    %edx,(%esp)
  803dc6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dca:	8b 44 24 04          	mov    0x4(%esp),%eax
  803dce:	8b 14 24             	mov    (%esp),%edx
  803dd1:	83 c4 1c             	add    $0x1c,%esp
  803dd4:	5b                   	pop    %ebx
  803dd5:	5e                   	pop    %esi
  803dd6:	5f                   	pop    %edi
  803dd7:	5d                   	pop    %ebp
  803dd8:	c3                   	ret    
  803dd9:	8d 76 00             	lea    0x0(%esi),%esi
  803ddc:	2b 04 24             	sub    (%esp),%eax
  803ddf:	19 fa                	sbb    %edi,%edx
  803de1:	89 d1                	mov    %edx,%ecx
  803de3:	89 c6                	mov    %eax,%esi
  803de5:	e9 71 ff ff ff       	jmp    803d5b <__umoddi3+0xb3>
  803dea:	66 90                	xchg   %ax,%ax
  803dec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803df0:	72 ea                	jb     803ddc <__umoddi3+0x134>
  803df2:	89 d9                	mov    %ebx,%ecx
  803df4:	e9 62 ff ff ff       	jmp    803d5b <__umoddi3+0xb3>
