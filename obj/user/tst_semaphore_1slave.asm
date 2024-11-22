
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
  800054:	68 80 1c 80 00       	push   $0x801c80
  800059:	ff 75 f4             	pushl  -0xc(%ebp)
  80005c:	50                   	push   %eax
  80005d:	e8 a7 18 00 00       	call   801909 <get_semaphore>
  800062:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = get_semaphore(parentenvID, "depend1");
  800065:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	68 84 1c 80 00       	push   $0x801c84
  800070:	ff 75 f4             	pushl  -0xc(%ebp)
  800073:	50                   	push   %eax
  800074:	e8 90 18 00 00       	call   801909 <get_semaphore>
  800079:	83 c4 0c             	add    $0xc,%esp

	cprintf("%d: before the critical section\n", id);
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	ff 75 f0             	pushl  -0x10(%ebp)
  800082:	68 8c 1c 80 00       	push   $0x801c8c
  800087:	e8 a0 04 00 00       	call   80052c <cprintf>
  80008c:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(cs1);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	ff 75 e8             	pushl  -0x18(%ebp)
  800095:	e8 89 18 00 00       	call   801923 <wait_semaphore>
  80009a:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("%d: inside the critical section\n", id) ;
  80009d:	83 ec 08             	sub    $0x8,%esp
  8000a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000a3:	68 b0 1c 80 00       	push   $0x801cb0
  8000a8:	e8 7f 04 00 00       	call   80052c <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp
		cprintf("my ID is %d\n", id);
  8000b0:	83 ec 08             	sub    $0x8,%esp
  8000b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b6:	68 d1 1c 80 00       	push   $0x801cd1
  8000bb:	e8 6c 04 00 00       	call   80052c <cprintf>
  8000c0:	83 c4 10             	add    $0x10,%esp
		int sem1val = semaphore_count(cs1);
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000c9:	e8 89 18 00 00       	call   801957 <semaphore_count>
  8000ce:	83 c4 10             	add    $0x10,%esp
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (sem1val > 0)
  8000d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8000d8:	7e 14                	jle    8000ee <_main+0xb6>
			panic("Error: more than 1 process inside the CS... please review your semaphore code again...");
  8000da:	83 ec 04             	sub    $0x4,%esp
  8000dd:	68 e0 1c 80 00       	push   $0x801ce0
  8000e2:	6a 15                	push   $0x15
  8000e4:	68 37 1d 80 00       	push   $0x801d37
  8000e9:	e8 81 01 00 00       	call   80026f <_panic>
		env_sleep(1000) ;
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	68 e8 03 00 00       	push   $0x3e8
  8000f6:	e8 67 18 00 00       	call   801962 <env_sleep>
  8000fb:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cs1);
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	ff 75 e8             	pushl  -0x18(%ebp)
  800104:	e8 34 18 00 00       	call   80193d <signal_semaphore>
  800109:	83 c4 10             	add    $0x10,%esp
	cprintf("%d: after the critical section\n", id);
  80010c:	83 ec 08             	sub    $0x8,%esp
  80010f:	ff 75 f0             	pushl  -0x10(%ebp)
  800112:	68 54 1d 80 00       	push   $0x801d54
  800117:	e8 10 04 00 00       	call   80052c <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp

	signal_semaphore(depend1);
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	ff 75 e4             	pushl  -0x1c(%ebp)
  800125:	e8 13 18 00 00       	call   80193d <signal_semaphore>
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
  800165:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016a:	a1 04 30 80 00       	mov    0x803004,%eax
  80016f:	8a 40 20             	mov    0x20(%eax),%al
  800172:	84 c0                	test   %al,%al
  800174:	74 0d                	je     800183 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800176:	a1 04 30 80 00       	mov    0x803004,%eax
  80017b:	83 c0 20             	add    $0x20,%eax
  80017e:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800183:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800187:	7e 0a                	jle    800193 <libmain+0x63>
		binaryname = argv[0];
  800189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018c:	8b 00                	mov    (%eax),%eax
  80018e:	a3 00 30 80 00       	mov    %eax,0x803000

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
  8001ac:	68 8c 1d 80 00       	push   $0x801d8c
  8001b1:	e8 76 03 00 00       	call   80052c <cprintf>
  8001b6:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001b9:	a1 04 30 80 00       	mov    0x803004,%eax
  8001be:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8001c4:	a1 04 30 80 00       	mov    0x803004,%eax
  8001c9:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8001cf:	83 ec 04             	sub    $0x4,%esp
  8001d2:	52                   	push   %edx
  8001d3:	50                   	push   %eax
  8001d4:	68 b4 1d 80 00       	push   $0x801db4
  8001d9:	e8 4e 03 00 00       	call   80052c <cprintf>
  8001de:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e1:	a1 04 30 80 00       	mov    0x803004,%eax
  8001e6:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8001ec:	a1 04 30 80 00       	mov    0x803004,%eax
  8001f1:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8001f7:	a1 04 30 80 00       	mov    0x803004,%eax
  8001fc:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800202:	51                   	push   %ecx
  800203:	52                   	push   %edx
  800204:	50                   	push   %eax
  800205:	68 dc 1d 80 00       	push   $0x801ddc
  80020a:	e8 1d 03 00 00       	call   80052c <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800212:	a1 04 30 80 00       	mov    0x803004,%eax
  800217:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	50                   	push   %eax
  800221:	68 34 1e 80 00       	push   $0x801e34
  800226:	e8 01 03 00 00       	call   80052c <cprintf>
  80022b:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80022e:	83 ec 0c             	sub    $0xc,%esp
  800231:	68 8c 1d 80 00       	push   $0x801d8c
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
  80027e:	a1 2c 30 80 00       	mov    0x80302c,%eax
  800283:	85 c0                	test   %eax,%eax
  800285:	74 16                	je     80029d <_panic+0x2e>
		cprintf("%s: ", argv0);
  800287:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80028c:	83 ec 08             	sub    $0x8,%esp
  80028f:	50                   	push   %eax
  800290:	68 48 1e 80 00       	push   $0x801e48
  800295:	e8 92 02 00 00       	call   80052c <cprintf>
  80029a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80029d:	a1 00 30 80 00       	mov    0x803000,%eax
  8002a2:	ff 75 0c             	pushl  0xc(%ebp)
  8002a5:	ff 75 08             	pushl  0x8(%ebp)
  8002a8:	50                   	push   %eax
  8002a9:	68 4d 1e 80 00       	push   $0x801e4d
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
  8002cd:	68 69 1e 80 00       	push   $0x801e69
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
  8002e7:	a1 04 30 80 00       	mov    0x803004,%eax
  8002ec:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8002f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f5:	39 c2                	cmp    %eax,%edx
  8002f7:	74 14                	je     80030d <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002f9:	83 ec 04             	sub    $0x4,%esp
  8002fc:	68 6c 1e 80 00       	push   $0x801e6c
  800301:	6a 26                	push   $0x26
  800303:	68 b8 1e 80 00       	push   $0x801eb8
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
  80034d:	a1 04 30 80 00       	mov    0x803004,%eax
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
  80036d:	a1 04 30 80 00       	mov    0x803004,%eax
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
  8003b6:	a1 04 30 80 00       	mov    0x803004,%eax
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
  8003d1:	68 c4 1e 80 00       	push   $0x801ec4
  8003d6:	6a 3a                	push   $0x3a
  8003d8:	68 b8 1e 80 00       	push   $0x801eb8
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
  800401:	a1 04 30 80 00       	mov    0x803004,%eax
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
  800427:	a1 04 30 80 00       	mov    0x803004,%eax
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
  800444:	68 18 1f 80 00       	push   $0x801f18
  800449:	6a 44                	push   $0x44
  80044b:	68 b8 1e 80 00       	push   $0x801eb8
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
  800483:	a0 08 30 80 00       	mov    0x803008,%al
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
  8004f8:	a0 08 30 80 00       	mov    0x803008,%al
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
  80051d:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
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
  800532:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
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
  8005c9:	e8 4a 14 00 00       	call   801a18 <__udivdi3>
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
  800619:	e8 0a 15 00 00       	call   801b28 <__umoddi3>
  80061e:	83 c4 10             	add    $0x10,%esp
  800621:	05 94 21 80 00       	add    $0x802194,%eax
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
  800774:	8b 04 85 b8 21 80 00 	mov    0x8021b8(,%eax,4),%eax
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
  800855:	8b 34 9d 00 20 80 00 	mov    0x802000(,%ebx,4),%esi
  80085c:	85 f6                	test   %esi,%esi
  80085e:	75 19                	jne    800879 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800860:	53                   	push   %ebx
  800861:	68 a5 21 80 00       	push   $0x8021a5
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
  80087a:	68 ae 21 80 00       	push   $0x8021ae
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
  8008a7:	be b1 21 80 00       	mov    $0x8021b1,%esi
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
  800a9f:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800aa6:	eb 2c                	jmp    800ad4 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800aa8:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
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
  8012b2:	68 28 23 80 00       	push   $0x802328
  8012b7:	68 3f 01 00 00       	push   $0x13f
  8012bc:	68 4a 23 80 00       	push   $0x80234a
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

008018ef <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  8018f5:	83 ec 04             	sub    $0x4,%esp
  8018f8:	68 58 23 80 00       	push   $0x802358
  8018fd:	6a 09                	push   $0x9
  8018ff:	68 80 23 80 00       	push   $0x802380
  801904:	e8 66 e9 ff ff       	call   80026f <_panic>

00801909 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
  80190c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  80190f:	83 ec 04             	sub    $0x4,%esp
  801912:	68 90 23 80 00       	push   $0x802390
  801917:	6a 10                	push   $0x10
  801919:	68 80 23 80 00       	push   $0x802380
  80191e:	e8 4c e9 ff ff       	call   80026f <_panic>

00801923 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  801929:	83 ec 04             	sub    $0x4,%esp
  80192c:	68 b8 23 80 00       	push   $0x8023b8
  801931:	6a 18                	push   $0x18
  801933:	68 80 23 80 00       	push   $0x802380
  801938:	e8 32 e9 ff ff       	call   80026f <_panic>

0080193d <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
  801940:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  801943:	83 ec 04             	sub    $0x4,%esp
  801946:	68 e0 23 80 00       	push   $0x8023e0
  80194b:	6a 20                	push   $0x20
  80194d:	68 80 23 80 00       	push   $0x802380
  801952:	e8 18 e9 ff ff       	call   80026f <_panic>

00801957 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	8b 40 10             	mov    0x10(%eax),%eax
}
  801960:	5d                   	pop    %ebp
  801961:	c3                   	ret    

00801962 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
  801965:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801968:	8b 55 08             	mov    0x8(%ebp),%edx
  80196b:	89 d0                	mov    %edx,%eax
  80196d:	c1 e0 02             	shl    $0x2,%eax
  801970:	01 d0                	add    %edx,%eax
  801972:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801979:	01 d0                	add    %edx,%eax
  80197b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801982:	01 d0                	add    %edx,%eax
  801984:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80198b:	01 d0                	add    %edx,%eax
  80198d:	c1 e0 04             	shl    $0x4,%eax
  801990:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801993:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80199a:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80199d:	83 ec 0c             	sub    $0xc,%esp
  8019a0:	50                   	push   %eax
  8019a1:	e8 55 fc ff ff       	call   8015fb <sys_get_virtual_time>
  8019a6:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8019a9:	eb 41                	jmp    8019ec <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8019ab:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019ae:	83 ec 0c             	sub    $0xc,%esp
  8019b1:	50                   	push   %eax
  8019b2:	e8 44 fc ff ff       	call   8015fb <sys_get_virtual_time>
  8019b7:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8019ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019c0:	29 c2                	sub    %eax,%edx
  8019c2:	89 d0                	mov    %edx,%eax
  8019c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8019c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019cd:	89 d1                	mov    %edx,%ecx
  8019cf:	29 c1                	sub    %eax,%ecx
  8019d1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019d7:	39 c2                	cmp    %eax,%edx
  8019d9:	0f 97 c0             	seta   %al
  8019dc:	0f b6 c0             	movzbl %al,%eax
  8019df:	29 c1                	sub    %eax,%ecx
  8019e1:	89 c8                	mov    %ecx,%eax
  8019e3:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8019e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8019ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019f2:	72 b7                	jb     8019ab <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8019f4:	90                   	nop
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
  8019fa:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8019fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801a04:	eb 03                	jmp    801a09 <busy_wait+0x12>
  801a06:	ff 45 fc             	incl   -0x4(%ebp)
  801a09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a0c:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a0f:	72 f5                	jb     801a06 <busy_wait+0xf>
	return i;
  801a11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    
  801a16:	66 90                	xchg   %ax,%ax

00801a18 <__udivdi3>:
  801a18:	55                   	push   %ebp
  801a19:	57                   	push   %edi
  801a1a:	56                   	push   %esi
  801a1b:	53                   	push   %ebx
  801a1c:	83 ec 1c             	sub    $0x1c,%esp
  801a1f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a23:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a2b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a2f:	89 ca                	mov    %ecx,%edx
  801a31:	89 f8                	mov    %edi,%eax
  801a33:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a37:	85 f6                	test   %esi,%esi
  801a39:	75 2d                	jne    801a68 <__udivdi3+0x50>
  801a3b:	39 cf                	cmp    %ecx,%edi
  801a3d:	77 65                	ja     801aa4 <__udivdi3+0x8c>
  801a3f:	89 fd                	mov    %edi,%ebp
  801a41:	85 ff                	test   %edi,%edi
  801a43:	75 0b                	jne    801a50 <__udivdi3+0x38>
  801a45:	b8 01 00 00 00       	mov    $0x1,%eax
  801a4a:	31 d2                	xor    %edx,%edx
  801a4c:	f7 f7                	div    %edi
  801a4e:	89 c5                	mov    %eax,%ebp
  801a50:	31 d2                	xor    %edx,%edx
  801a52:	89 c8                	mov    %ecx,%eax
  801a54:	f7 f5                	div    %ebp
  801a56:	89 c1                	mov    %eax,%ecx
  801a58:	89 d8                	mov    %ebx,%eax
  801a5a:	f7 f5                	div    %ebp
  801a5c:	89 cf                	mov    %ecx,%edi
  801a5e:	89 fa                	mov    %edi,%edx
  801a60:	83 c4 1c             	add    $0x1c,%esp
  801a63:	5b                   	pop    %ebx
  801a64:	5e                   	pop    %esi
  801a65:	5f                   	pop    %edi
  801a66:	5d                   	pop    %ebp
  801a67:	c3                   	ret    
  801a68:	39 ce                	cmp    %ecx,%esi
  801a6a:	77 28                	ja     801a94 <__udivdi3+0x7c>
  801a6c:	0f bd fe             	bsr    %esi,%edi
  801a6f:	83 f7 1f             	xor    $0x1f,%edi
  801a72:	75 40                	jne    801ab4 <__udivdi3+0x9c>
  801a74:	39 ce                	cmp    %ecx,%esi
  801a76:	72 0a                	jb     801a82 <__udivdi3+0x6a>
  801a78:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a7c:	0f 87 9e 00 00 00    	ja     801b20 <__udivdi3+0x108>
  801a82:	b8 01 00 00 00       	mov    $0x1,%eax
  801a87:	89 fa                	mov    %edi,%edx
  801a89:	83 c4 1c             	add    $0x1c,%esp
  801a8c:	5b                   	pop    %ebx
  801a8d:	5e                   	pop    %esi
  801a8e:	5f                   	pop    %edi
  801a8f:	5d                   	pop    %ebp
  801a90:	c3                   	ret    
  801a91:	8d 76 00             	lea    0x0(%esi),%esi
  801a94:	31 ff                	xor    %edi,%edi
  801a96:	31 c0                	xor    %eax,%eax
  801a98:	89 fa                	mov    %edi,%edx
  801a9a:	83 c4 1c             	add    $0x1c,%esp
  801a9d:	5b                   	pop    %ebx
  801a9e:	5e                   	pop    %esi
  801a9f:	5f                   	pop    %edi
  801aa0:	5d                   	pop    %ebp
  801aa1:	c3                   	ret    
  801aa2:	66 90                	xchg   %ax,%ax
  801aa4:	89 d8                	mov    %ebx,%eax
  801aa6:	f7 f7                	div    %edi
  801aa8:	31 ff                	xor    %edi,%edi
  801aaa:	89 fa                	mov    %edi,%edx
  801aac:	83 c4 1c             	add    $0x1c,%esp
  801aaf:	5b                   	pop    %ebx
  801ab0:	5e                   	pop    %esi
  801ab1:	5f                   	pop    %edi
  801ab2:	5d                   	pop    %ebp
  801ab3:	c3                   	ret    
  801ab4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ab9:	89 eb                	mov    %ebp,%ebx
  801abb:	29 fb                	sub    %edi,%ebx
  801abd:	89 f9                	mov    %edi,%ecx
  801abf:	d3 e6                	shl    %cl,%esi
  801ac1:	89 c5                	mov    %eax,%ebp
  801ac3:	88 d9                	mov    %bl,%cl
  801ac5:	d3 ed                	shr    %cl,%ebp
  801ac7:	89 e9                	mov    %ebp,%ecx
  801ac9:	09 f1                	or     %esi,%ecx
  801acb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801acf:	89 f9                	mov    %edi,%ecx
  801ad1:	d3 e0                	shl    %cl,%eax
  801ad3:	89 c5                	mov    %eax,%ebp
  801ad5:	89 d6                	mov    %edx,%esi
  801ad7:	88 d9                	mov    %bl,%cl
  801ad9:	d3 ee                	shr    %cl,%esi
  801adb:	89 f9                	mov    %edi,%ecx
  801add:	d3 e2                	shl    %cl,%edx
  801adf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ae3:	88 d9                	mov    %bl,%cl
  801ae5:	d3 e8                	shr    %cl,%eax
  801ae7:	09 c2                	or     %eax,%edx
  801ae9:	89 d0                	mov    %edx,%eax
  801aeb:	89 f2                	mov    %esi,%edx
  801aed:	f7 74 24 0c          	divl   0xc(%esp)
  801af1:	89 d6                	mov    %edx,%esi
  801af3:	89 c3                	mov    %eax,%ebx
  801af5:	f7 e5                	mul    %ebp
  801af7:	39 d6                	cmp    %edx,%esi
  801af9:	72 19                	jb     801b14 <__udivdi3+0xfc>
  801afb:	74 0b                	je     801b08 <__udivdi3+0xf0>
  801afd:	89 d8                	mov    %ebx,%eax
  801aff:	31 ff                	xor    %edi,%edi
  801b01:	e9 58 ff ff ff       	jmp    801a5e <__udivdi3+0x46>
  801b06:	66 90                	xchg   %ax,%ax
  801b08:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b0c:	89 f9                	mov    %edi,%ecx
  801b0e:	d3 e2                	shl    %cl,%edx
  801b10:	39 c2                	cmp    %eax,%edx
  801b12:	73 e9                	jae    801afd <__udivdi3+0xe5>
  801b14:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b17:	31 ff                	xor    %edi,%edi
  801b19:	e9 40 ff ff ff       	jmp    801a5e <__udivdi3+0x46>
  801b1e:	66 90                	xchg   %ax,%ax
  801b20:	31 c0                	xor    %eax,%eax
  801b22:	e9 37 ff ff ff       	jmp    801a5e <__udivdi3+0x46>
  801b27:	90                   	nop

00801b28 <__umoddi3>:
  801b28:	55                   	push   %ebp
  801b29:	57                   	push   %edi
  801b2a:	56                   	push   %esi
  801b2b:	53                   	push   %ebx
  801b2c:	83 ec 1c             	sub    $0x1c,%esp
  801b2f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b33:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b3f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b43:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b47:	89 f3                	mov    %esi,%ebx
  801b49:	89 fa                	mov    %edi,%edx
  801b4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b4f:	89 34 24             	mov    %esi,(%esp)
  801b52:	85 c0                	test   %eax,%eax
  801b54:	75 1a                	jne    801b70 <__umoddi3+0x48>
  801b56:	39 f7                	cmp    %esi,%edi
  801b58:	0f 86 a2 00 00 00    	jbe    801c00 <__umoddi3+0xd8>
  801b5e:	89 c8                	mov    %ecx,%eax
  801b60:	89 f2                	mov    %esi,%edx
  801b62:	f7 f7                	div    %edi
  801b64:	89 d0                	mov    %edx,%eax
  801b66:	31 d2                	xor    %edx,%edx
  801b68:	83 c4 1c             	add    $0x1c,%esp
  801b6b:	5b                   	pop    %ebx
  801b6c:	5e                   	pop    %esi
  801b6d:	5f                   	pop    %edi
  801b6e:	5d                   	pop    %ebp
  801b6f:	c3                   	ret    
  801b70:	39 f0                	cmp    %esi,%eax
  801b72:	0f 87 ac 00 00 00    	ja     801c24 <__umoddi3+0xfc>
  801b78:	0f bd e8             	bsr    %eax,%ebp
  801b7b:	83 f5 1f             	xor    $0x1f,%ebp
  801b7e:	0f 84 ac 00 00 00    	je     801c30 <__umoddi3+0x108>
  801b84:	bf 20 00 00 00       	mov    $0x20,%edi
  801b89:	29 ef                	sub    %ebp,%edi
  801b8b:	89 fe                	mov    %edi,%esi
  801b8d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b91:	89 e9                	mov    %ebp,%ecx
  801b93:	d3 e0                	shl    %cl,%eax
  801b95:	89 d7                	mov    %edx,%edi
  801b97:	89 f1                	mov    %esi,%ecx
  801b99:	d3 ef                	shr    %cl,%edi
  801b9b:	09 c7                	or     %eax,%edi
  801b9d:	89 e9                	mov    %ebp,%ecx
  801b9f:	d3 e2                	shl    %cl,%edx
  801ba1:	89 14 24             	mov    %edx,(%esp)
  801ba4:	89 d8                	mov    %ebx,%eax
  801ba6:	d3 e0                	shl    %cl,%eax
  801ba8:	89 c2                	mov    %eax,%edx
  801baa:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bae:	d3 e0                	shl    %cl,%eax
  801bb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bb8:	89 f1                	mov    %esi,%ecx
  801bba:	d3 e8                	shr    %cl,%eax
  801bbc:	09 d0                	or     %edx,%eax
  801bbe:	d3 eb                	shr    %cl,%ebx
  801bc0:	89 da                	mov    %ebx,%edx
  801bc2:	f7 f7                	div    %edi
  801bc4:	89 d3                	mov    %edx,%ebx
  801bc6:	f7 24 24             	mull   (%esp)
  801bc9:	89 c6                	mov    %eax,%esi
  801bcb:	89 d1                	mov    %edx,%ecx
  801bcd:	39 d3                	cmp    %edx,%ebx
  801bcf:	0f 82 87 00 00 00    	jb     801c5c <__umoddi3+0x134>
  801bd5:	0f 84 91 00 00 00    	je     801c6c <__umoddi3+0x144>
  801bdb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bdf:	29 f2                	sub    %esi,%edx
  801be1:	19 cb                	sbb    %ecx,%ebx
  801be3:	89 d8                	mov    %ebx,%eax
  801be5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801be9:	d3 e0                	shl    %cl,%eax
  801beb:	89 e9                	mov    %ebp,%ecx
  801bed:	d3 ea                	shr    %cl,%edx
  801bef:	09 d0                	or     %edx,%eax
  801bf1:	89 e9                	mov    %ebp,%ecx
  801bf3:	d3 eb                	shr    %cl,%ebx
  801bf5:	89 da                	mov    %ebx,%edx
  801bf7:	83 c4 1c             	add    $0x1c,%esp
  801bfa:	5b                   	pop    %ebx
  801bfb:	5e                   	pop    %esi
  801bfc:	5f                   	pop    %edi
  801bfd:	5d                   	pop    %ebp
  801bfe:	c3                   	ret    
  801bff:	90                   	nop
  801c00:	89 fd                	mov    %edi,%ebp
  801c02:	85 ff                	test   %edi,%edi
  801c04:	75 0b                	jne    801c11 <__umoddi3+0xe9>
  801c06:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0b:	31 d2                	xor    %edx,%edx
  801c0d:	f7 f7                	div    %edi
  801c0f:	89 c5                	mov    %eax,%ebp
  801c11:	89 f0                	mov    %esi,%eax
  801c13:	31 d2                	xor    %edx,%edx
  801c15:	f7 f5                	div    %ebp
  801c17:	89 c8                	mov    %ecx,%eax
  801c19:	f7 f5                	div    %ebp
  801c1b:	89 d0                	mov    %edx,%eax
  801c1d:	e9 44 ff ff ff       	jmp    801b66 <__umoddi3+0x3e>
  801c22:	66 90                	xchg   %ax,%ax
  801c24:	89 c8                	mov    %ecx,%eax
  801c26:	89 f2                	mov    %esi,%edx
  801c28:	83 c4 1c             	add    $0x1c,%esp
  801c2b:	5b                   	pop    %ebx
  801c2c:	5e                   	pop    %esi
  801c2d:	5f                   	pop    %edi
  801c2e:	5d                   	pop    %ebp
  801c2f:	c3                   	ret    
  801c30:	3b 04 24             	cmp    (%esp),%eax
  801c33:	72 06                	jb     801c3b <__umoddi3+0x113>
  801c35:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c39:	77 0f                	ja     801c4a <__umoddi3+0x122>
  801c3b:	89 f2                	mov    %esi,%edx
  801c3d:	29 f9                	sub    %edi,%ecx
  801c3f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c43:	89 14 24             	mov    %edx,(%esp)
  801c46:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c4a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c4e:	8b 14 24             	mov    (%esp),%edx
  801c51:	83 c4 1c             	add    $0x1c,%esp
  801c54:	5b                   	pop    %ebx
  801c55:	5e                   	pop    %esi
  801c56:	5f                   	pop    %edi
  801c57:	5d                   	pop    %ebp
  801c58:	c3                   	ret    
  801c59:	8d 76 00             	lea    0x0(%esi),%esi
  801c5c:	2b 04 24             	sub    (%esp),%eax
  801c5f:	19 fa                	sbb    %edi,%edx
  801c61:	89 d1                	mov    %edx,%ecx
  801c63:	89 c6                	mov    %eax,%esi
  801c65:	e9 71 ff ff ff       	jmp    801bdb <__umoddi3+0xb3>
  801c6a:	66 90                	xchg   %ax,%ax
  801c6c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c70:	72 ea                	jb     801c5c <__umoddi3+0x134>
  801c72:	89 d9                	mov    %ebx,%ecx
  801c74:	e9 62 ff ff ff       	jmp    801bdb <__umoddi3+0xb3>
