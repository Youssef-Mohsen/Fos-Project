
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
  80004e:	e8 6a 14 00 00       	call   8014bd <sys_createSharedObject>
  800053:	83 c4 10             	add    $0x10,%esp

	struct semaphore cnc1 = create_semaphore("cnc1", 1);
  800056:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	6a 01                	push   $0x1
  80005e:	68 e0 1b 80 00       	push   $0x801be0
  800063:	50                   	push   %eax
  800064:	e8 85 18 00 00       	call   8018ee <create_semaphore>
  800069:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = create_semaphore("depend1", 0);
  80006c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80006f:	83 ec 04             	sub    $0x4,%esp
  800072:	6a 00                	push   $0x0
  800074:	68 e5 1b 80 00       	push   $0x801be5
  800079:	50                   	push   %eax
  80007a:	e8 6f 18 00 00       	call   8018ee <create_semaphore>
  80007f:	83 c4 0c             	add    $0xc,%esp

	uint32 id1, id2;
	id2 = sys_create_env("qs2", (myEnv->page_WS_max_size), (myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800082:	a1 04 30 80 00       	mov    0x803004,%eax
  800087:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  80008d:	a1 04 30 80 00       	mov    0x803004,%eax
  800092:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800098:	89 c1                	mov    %eax,%ecx
  80009a:	a1 04 30 80 00       	mov    0x803004,%eax
  80009f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000a5:	52                   	push   %edx
  8000a6:	51                   	push   %ecx
  8000a7:	50                   	push   %eax
  8000a8:	68 ed 1b 80 00       	push   $0x801bed
  8000ad:	e8 8e 14 00 00       	call   801540 <sys_create_env>
  8000b2:	83 c4 10             	add    $0x10,%esp
  8000b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	id1 = sys_create_env("qs1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000b8:	a1 04 30 80 00       	mov    0x803004,%eax
  8000bd:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  8000c3:	a1 04 30 80 00       	mov    0x803004,%eax
  8000c8:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8000ce:	89 c1                	mov    %eax,%ecx
  8000d0:	a1 04 30 80 00       	mov    0x803004,%eax
  8000d5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000db:	52                   	push   %edx
  8000dc:	51                   	push   %ecx
  8000dd:	50                   	push   %eax
  8000de:	68 f1 1b 80 00       	push   $0x801bf1
  8000e3:	e8 58 14 00 00       	call   801540 <sys_create_env>
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
  800109:	e8 60 01 00 00       	call   80026e <_panic>

	sys_run_env(id2);
  80010e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	50                   	push   %eax
  800115:	e8 44 14 00 00       	call   80155e <sys_run_env>
  80011a:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id1);
  80011d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	50                   	push   %eax
  800124:	e8 35 14 00 00       	call   80155e <sys_run_env>
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
  800135:	e8 74 14 00 00       	call   8015ae <sys_getenvindex>
  80013a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80013d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800140:	89 d0                	mov    %edx,%eax
  800142:	c1 e0 03             	shl    $0x3,%eax
  800145:	01 d0                	add    %edx,%eax
  800147:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80014e:	01 c8                	add    %ecx,%eax
  800150:	01 c0                	add    %eax,%eax
  800152:	01 d0                	add    %edx,%eax
  800154:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80015b:	01 c8                	add    %ecx,%eax
  80015d:	01 d0                	add    %edx,%eax
  80015f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800164:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800169:	a1 04 30 80 00       	mov    0x803004,%eax
  80016e:	8a 40 20             	mov    0x20(%eax),%al
  800171:	84 c0                	test   %al,%al
  800173:	74 0d                	je     800182 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800175:	a1 04 30 80 00       	mov    0x803004,%eax
  80017a:	83 c0 20             	add    $0x20,%eax
  80017d:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800182:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800186:	7e 0a                	jle    800192 <libmain+0x63>
		binaryname = argv[0];
  800188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018b:	8b 00                	mov    (%eax),%eax
  80018d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800192:	83 ec 08             	sub    $0x8,%esp
  800195:	ff 75 0c             	pushl  0xc(%ebp)
  800198:	ff 75 08             	pushl  0x8(%ebp)
  80019b:	e8 98 fe ff ff       	call   800038 <_main>
  8001a0:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8001a3:	e8 8a 11 00 00       	call   801332 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001a8:	83 ec 0c             	sub    $0xc,%esp
  8001ab:	68 3c 1c 80 00       	push   $0x801c3c
  8001b0:	e8 76 03 00 00       	call   80052b <cprintf>
  8001b5:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001b8:	a1 04 30 80 00       	mov    0x803004,%eax
  8001bd:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8001c3:	a1 04 30 80 00       	mov    0x803004,%eax
  8001c8:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	52                   	push   %edx
  8001d2:	50                   	push   %eax
  8001d3:	68 64 1c 80 00       	push   $0x801c64
  8001d8:	e8 4e 03 00 00       	call   80052b <cprintf>
  8001dd:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e0:	a1 04 30 80 00       	mov    0x803004,%eax
  8001e5:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8001eb:	a1 04 30 80 00       	mov    0x803004,%eax
  8001f0:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8001f6:	a1 04 30 80 00       	mov    0x803004,%eax
  8001fb:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800201:	51                   	push   %ecx
  800202:	52                   	push   %edx
  800203:	50                   	push   %eax
  800204:	68 8c 1c 80 00       	push   $0x801c8c
  800209:	e8 1d 03 00 00       	call   80052b <cprintf>
  80020e:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800211:	a1 04 30 80 00       	mov    0x803004,%eax
  800216:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80021c:	83 ec 08             	sub    $0x8,%esp
  80021f:	50                   	push   %eax
  800220:	68 e4 1c 80 00       	push   $0x801ce4
  800225:	e8 01 03 00 00       	call   80052b <cprintf>
  80022a:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	68 3c 1c 80 00       	push   $0x801c3c
  800235:	e8 f1 02 00 00       	call   80052b <cprintf>
  80023a:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80023d:	e8 0a 11 00 00       	call   80134c <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800242:	e8 19 00 00 00       	call   800260 <exit>
}
  800247:	90                   	nop
  800248:	c9                   	leave  
  800249:	c3                   	ret    

0080024a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800250:	83 ec 0c             	sub    $0xc,%esp
  800253:	6a 00                	push   $0x0
  800255:	e8 20 13 00 00       	call   80157a <sys_destroy_env>
  80025a:	83 c4 10             	add    $0x10,%esp
}
  80025d:	90                   	nop
  80025e:	c9                   	leave  
  80025f:	c3                   	ret    

00800260 <exit>:

void
exit(void)
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
  800263:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800266:	e8 75 13 00 00       	call   8015e0 <sys_exit_env>
}
  80026b:	90                   	nop
  80026c:	c9                   	leave  
  80026d:	c3                   	ret    

0080026e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80026e:	55                   	push   %ebp
  80026f:	89 e5                	mov    %esp,%ebp
  800271:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800274:	8d 45 10             	lea    0x10(%ebp),%eax
  800277:	83 c0 04             	add    $0x4,%eax
  80027a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80027d:	a1 2c 30 80 00       	mov    0x80302c,%eax
  800282:	85 c0                	test   %eax,%eax
  800284:	74 16                	je     80029c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800286:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80028b:	83 ec 08             	sub    $0x8,%esp
  80028e:	50                   	push   %eax
  80028f:	68 f8 1c 80 00       	push   $0x801cf8
  800294:	e8 92 02 00 00       	call   80052b <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80029c:	a1 00 30 80 00       	mov    0x803000,%eax
  8002a1:	ff 75 0c             	pushl  0xc(%ebp)
  8002a4:	ff 75 08             	pushl  0x8(%ebp)
  8002a7:	50                   	push   %eax
  8002a8:	68 fd 1c 80 00       	push   $0x801cfd
  8002ad:	e8 79 02 00 00       	call   80052b <cprintf>
  8002b2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b8:	83 ec 08             	sub    $0x8,%esp
  8002bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8002be:	50                   	push   %eax
  8002bf:	e8 fc 01 00 00       	call   8004c0 <vcprintf>
  8002c4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002c7:	83 ec 08             	sub    $0x8,%esp
  8002ca:	6a 00                	push   $0x0
  8002cc:	68 19 1d 80 00       	push   $0x801d19
  8002d1:	e8 ea 01 00 00       	call   8004c0 <vcprintf>
  8002d6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002d9:	e8 82 ff ff ff       	call   800260 <exit>

	// should not return here
	while (1) ;
  8002de:	eb fe                	jmp    8002de <_panic+0x70>

008002e0 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002e6:	a1 04 30 80 00       	mov    0x803004,%eax
  8002eb:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8002f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f4:	39 c2                	cmp    %eax,%edx
  8002f6:	74 14                	je     80030c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002f8:	83 ec 04             	sub    $0x4,%esp
  8002fb:	68 1c 1d 80 00       	push   $0x801d1c
  800300:	6a 26                	push   $0x26
  800302:	68 68 1d 80 00       	push   $0x801d68
  800307:	e8 62 ff ff ff       	call   80026e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80030c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800313:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80031a:	e9 c5 00 00 00       	jmp    8003e4 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80031f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800322:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800329:	8b 45 08             	mov    0x8(%ebp),%eax
  80032c:	01 d0                	add    %edx,%eax
  80032e:	8b 00                	mov    (%eax),%eax
  800330:	85 c0                	test   %eax,%eax
  800332:	75 08                	jne    80033c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800334:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800337:	e9 a5 00 00 00       	jmp    8003e1 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80033c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800343:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80034a:	eb 69                	jmp    8003b5 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80034c:	a1 04 30 80 00       	mov    0x803004,%eax
  800351:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800357:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80035a:	89 d0                	mov    %edx,%eax
  80035c:	01 c0                	add    %eax,%eax
  80035e:	01 d0                	add    %edx,%eax
  800360:	c1 e0 03             	shl    $0x3,%eax
  800363:	01 c8                	add    %ecx,%eax
  800365:	8a 40 04             	mov    0x4(%eax),%al
  800368:	84 c0                	test   %al,%al
  80036a:	75 46                	jne    8003b2 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80036c:	a1 04 30 80 00       	mov    0x803004,%eax
  800371:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800377:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80037a:	89 d0                	mov    %edx,%eax
  80037c:	01 c0                	add    %eax,%eax
  80037e:	01 d0                	add    %edx,%eax
  800380:	c1 e0 03             	shl    $0x3,%eax
  800383:	01 c8                	add    %ecx,%eax
  800385:	8b 00                	mov    (%eax),%eax
  800387:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80038a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80038d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800392:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800397:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80039e:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a1:	01 c8                	add    %ecx,%eax
  8003a3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003a5:	39 c2                	cmp    %eax,%edx
  8003a7:	75 09                	jne    8003b2 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003a9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003b0:	eb 15                	jmp    8003c7 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b2:	ff 45 e8             	incl   -0x18(%ebp)
  8003b5:	a1 04 30 80 00       	mov    0x803004,%eax
  8003ba:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8003c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003c3:	39 c2                	cmp    %eax,%edx
  8003c5:	77 85                	ja     80034c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003cb:	75 14                	jne    8003e1 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003cd:	83 ec 04             	sub    $0x4,%esp
  8003d0:	68 74 1d 80 00       	push   $0x801d74
  8003d5:	6a 3a                	push   $0x3a
  8003d7:	68 68 1d 80 00       	push   $0x801d68
  8003dc:	e8 8d fe ff ff       	call   80026e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003e1:	ff 45 f0             	incl   -0x10(%ebp)
  8003e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003ea:	0f 8c 2f ff ff ff    	jl     80031f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003f0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003fe:	eb 26                	jmp    800426 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800400:	a1 04 30 80 00       	mov    0x803004,%eax
  800405:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80040b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80040e:	89 d0                	mov    %edx,%eax
  800410:	01 c0                	add    %eax,%eax
  800412:	01 d0                	add    %edx,%eax
  800414:	c1 e0 03             	shl    $0x3,%eax
  800417:	01 c8                	add    %ecx,%eax
  800419:	8a 40 04             	mov    0x4(%eax),%al
  80041c:	3c 01                	cmp    $0x1,%al
  80041e:	75 03                	jne    800423 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800420:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800423:	ff 45 e0             	incl   -0x20(%ebp)
  800426:	a1 04 30 80 00       	mov    0x803004,%eax
  80042b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800434:	39 c2                	cmp    %eax,%edx
  800436:	77 c8                	ja     800400 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80043b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80043e:	74 14                	je     800454 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800440:	83 ec 04             	sub    $0x4,%esp
  800443:	68 c8 1d 80 00       	push   $0x801dc8
  800448:	6a 44                	push   $0x44
  80044a:	68 68 1d 80 00       	push   $0x801d68
  80044f:	e8 1a fe ff ff       	call   80026e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800454:	90                   	nop
  800455:	c9                   	leave  
  800456:	c3                   	ret    

00800457 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800457:	55                   	push   %ebp
  800458:	89 e5                	mov    %esp,%ebp
  80045a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80045d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800460:	8b 00                	mov    (%eax),%eax
  800462:	8d 48 01             	lea    0x1(%eax),%ecx
  800465:	8b 55 0c             	mov    0xc(%ebp),%edx
  800468:	89 0a                	mov    %ecx,(%edx)
  80046a:	8b 55 08             	mov    0x8(%ebp),%edx
  80046d:	88 d1                	mov    %dl,%cl
  80046f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800472:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800476:	8b 45 0c             	mov    0xc(%ebp),%eax
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800480:	75 2c                	jne    8004ae <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800482:	a0 08 30 80 00       	mov    0x803008,%al
  800487:	0f b6 c0             	movzbl %al,%eax
  80048a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048d:	8b 12                	mov    (%edx),%edx
  80048f:	89 d1                	mov    %edx,%ecx
  800491:	8b 55 0c             	mov    0xc(%ebp),%edx
  800494:	83 c2 08             	add    $0x8,%edx
  800497:	83 ec 04             	sub    $0x4,%esp
  80049a:	50                   	push   %eax
  80049b:	51                   	push   %ecx
  80049c:	52                   	push   %edx
  80049d:	e8 4e 0e 00 00       	call   8012f0 <sys_cputs>
  8004a2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b1:	8b 40 04             	mov    0x4(%eax),%eax
  8004b4:	8d 50 01             	lea    0x1(%eax),%edx
  8004b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ba:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004bd:	90                   	nop
  8004be:	c9                   	leave  
  8004bf:	c3                   	ret    

008004c0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d0:	00 00 00 
	b.cnt = 0;
  8004d3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004da:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004dd:	ff 75 0c             	pushl  0xc(%ebp)
  8004e0:	ff 75 08             	pushl  0x8(%ebp)
  8004e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e9:	50                   	push   %eax
  8004ea:	68 57 04 80 00       	push   $0x800457
  8004ef:	e8 11 02 00 00       	call   800705 <vprintfmt>
  8004f4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004f7:	a0 08 30 80 00       	mov    0x803008,%al
  8004fc:	0f b6 c0             	movzbl %al,%eax
  8004ff:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800505:	83 ec 04             	sub    $0x4,%esp
  800508:	50                   	push   %eax
  800509:	52                   	push   %edx
  80050a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800510:	83 c0 08             	add    $0x8,%eax
  800513:	50                   	push   %eax
  800514:	e8 d7 0d 00 00       	call   8012f0 <sys_cputs>
  800519:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80051c:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800523:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800529:	c9                   	leave  
  80052a:	c3                   	ret    

0080052b <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80052b:	55                   	push   %ebp
  80052c:	89 e5                	mov    %esp,%ebp
  80052e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800531:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800538:	8d 45 0c             	lea    0xc(%ebp),%eax
  80053b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	ff 75 f4             	pushl  -0xc(%ebp)
  800547:	50                   	push   %eax
  800548:	e8 73 ff ff ff       	call   8004c0 <vcprintf>
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800553:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800556:	c9                   	leave  
  800557:	c3                   	ret    

00800558 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800558:	55                   	push   %ebp
  800559:	89 e5                	mov    %esp,%ebp
  80055b:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80055e:	e8 cf 0d 00 00       	call   801332 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800563:	8d 45 0c             	lea    0xc(%ebp),%eax
  800566:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	83 ec 08             	sub    $0x8,%esp
  80056f:	ff 75 f4             	pushl  -0xc(%ebp)
  800572:	50                   	push   %eax
  800573:	e8 48 ff ff ff       	call   8004c0 <vcprintf>
  800578:	83 c4 10             	add    $0x10,%esp
  80057b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80057e:	e8 c9 0d 00 00       	call   80134c <sys_unlock_cons>
	return cnt;
  800583:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800586:	c9                   	leave  
  800587:	c3                   	ret    

00800588 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800588:	55                   	push   %ebp
  800589:	89 e5                	mov    %esp,%ebp
  80058b:	53                   	push   %ebx
  80058c:	83 ec 14             	sub    $0x14,%esp
  80058f:	8b 45 10             	mov    0x10(%ebp),%eax
  800592:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80059b:	8b 45 18             	mov    0x18(%ebp),%eax
  80059e:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a6:	77 55                	ja     8005fd <printnum+0x75>
  8005a8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ab:	72 05                	jb     8005b2 <printnum+0x2a>
  8005ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b0:	77 4b                	ja     8005fd <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005b5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005b8:	8b 45 18             	mov    0x18(%ebp),%eax
  8005bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c0:	52                   	push   %edx
  8005c1:	50                   	push   %eax
  8005c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c5:	ff 75 f0             	pushl  -0x10(%ebp)
  8005c8:	e8 97 13 00 00       	call   801964 <__udivdi3>
  8005cd:	83 c4 10             	add    $0x10,%esp
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	ff 75 20             	pushl  0x20(%ebp)
  8005d6:	53                   	push   %ebx
  8005d7:	ff 75 18             	pushl  0x18(%ebp)
  8005da:	52                   	push   %edx
  8005db:	50                   	push   %eax
  8005dc:	ff 75 0c             	pushl  0xc(%ebp)
  8005df:	ff 75 08             	pushl  0x8(%ebp)
  8005e2:	e8 a1 ff ff ff       	call   800588 <printnum>
  8005e7:	83 c4 20             	add    $0x20,%esp
  8005ea:	eb 1a                	jmp    800606 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005ec:	83 ec 08             	sub    $0x8,%esp
  8005ef:	ff 75 0c             	pushl  0xc(%ebp)
  8005f2:	ff 75 20             	pushl  0x20(%ebp)
  8005f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f8:	ff d0                	call   *%eax
  8005fa:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005fd:	ff 4d 1c             	decl   0x1c(%ebp)
  800600:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800604:	7f e6                	jg     8005ec <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800606:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800609:	bb 00 00 00 00       	mov    $0x0,%ebx
  80060e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800611:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800614:	53                   	push   %ebx
  800615:	51                   	push   %ecx
  800616:	52                   	push   %edx
  800617:	50                   	push   %eax
  800618:	e8 57 14 00 00       	call   801a74 <__umoddi3>
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	05 34 20 80 00       	add    $0x802034,%eax
  800625:	8a 00                	mov    (%eax),%al
  800627:	0f be c0             	movsbl %al,%eax
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 0c             	pushl  0xc(%ebp)
  800630:	50                   	push   %eax
  800631:	8b 45 08             	mov    0x8(%ebp),%eax
  800634:	ff d0                	call   *%eax
  800636:	83 c4 10             	add    $0x10,%esp
}
  800639:	90                   	nop
  80063a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80063d:	c9                   	leave  
  80063e:	c3                   	ret    

0080063f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80063f:	55                   	push   %ebp
  800640:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800642:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800646:	7e 1c                	jle    800664 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	8b 00                	mov    (%eax),%eax
  80064d:	8d 50 08             	lea    0x8(%eax),%edx
  800650:	8b 45 08             	mov    0x8(%ebp),%eax
  800653:	89 10                	mov    %edx,(%eax)
  800655:	8b 45 08             	mov    0x8(%ebp),%eax
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	83 e8 08             	sub    $0x8,%eax
  80065d:	8b 50 04             	mov    0x4(%eax),%edx
  800660:	8b 00                	mov    (%eax),%eax
  800662:	eb 40                	jmp    8006a4 <getuint+0x65>
	else if (lflag)
  800664:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800668:	74 1e                	je     800688 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	8b 00                	mov    (%eax),%eax
  80066f:	8d 50 04             	lea    0x4(%eax),%edx
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	89 10                	mov    %edx,(%eax)
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	83 e8 04             	sub    $0x4,%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	ba 00 00 00 00       	mov    $0x0,%edx
  800686:	eb 1c                	jmp    8006a4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	8d 50 04             	lea    0x4(%eax),%edx
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	89 10                	mov    %edx,(%eax)
  800695:	8b 45 08             	mov    0x8(%ebp),%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	83 e8 04             	sub    $0x4,%eax
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006a4:	5d                   	pop    %ebp
  8006a5:	c3                   	ret    

008006a6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006a6:	55                   	push   %ebp
  8006a7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ad:	7e 1c                	jle    8006cb <getint+0x25>
		return va_arg(*ap, long long);
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	8d 50 08             	lea    0x8(%eax),%edx
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	89 10                	mov    %edx,(%eax)
  8006bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	83 e8 08             	sub    $0x8,%eax
  8006c4:	8b 50 04             	mov    0x4(%eax),%edx
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	eb 38                	jmp    800703 <getint+0x5d>
	else if (lflag)
  8006cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006cf:	74 1a                	je     8006eb <getint+0x45>
		return va_arg(*ap, long);
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	8d 50 04             	lea    0x4(%eax),%edx
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	89 10                	mov    %edx,(%eax)
  8006de:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	83 e8 04             	sub    $0x4,%eax
  8006e6:	8b 00                	mov    (%eax),%eax
  8006e8:	99                   	cltd   
  8006e9:	eb 18                	jmp    800703 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	8d 50 04             	lea    0x4(%eax),%edx
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	89 10                	mov    %edx,(%eax)
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	83 e8 04             	sub    $0x4,%eax
  800700:	8b 00                	mov    (%eax),%eax
  800702:	99                   	cltd   
}
  800703:	5d                   	pop    %ebp
  800704:	c3                   	ret    

00800705 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800705:	55                   	push   %ebp
  800706:	89 e5                	mov    %esp,%ebp
  800708:	56                   	push   %esi
  800709:	53                   	push   %ebx
  80070a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070d:	eb 17                	jmp    800726 <vprintfmt+0x21>
			if (ch == '\0')
  80070f:	85 db                	test   %ebx,%ebx
  800711:	0f 84 c1 03 00 00    	je     800ad8 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	ff 75 0c             	pushl  0xc(%ebp)
  80071d:	53                   	push   %ebx
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	ff d0                	call   *%eax
  800723:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800726:	8b 45 10             	mov    0x10(%ebp),%eax
  800729:	8d 50 01             	lea    0x1(%eax),%edx
  80072c:	89 55 10             	mov    %edx,0x10(%ebp)
  80072f:	8a 00                	mov    (%eax),%al
  800731:	0f b6 d8             	movzbl %al,%ebx
  800734:	83 fb 25             	cmp    $0x25,%ebx
  800737:	75 d6                	jne    80070f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800739:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80073d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800744:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80074b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800752:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800759:	8b 45 10             	mov    0x10(%ebp),%eax
  80075c:	8d 50 01             	lea    0x1(%eax),%edx
  80075f:	89 55 10             	mov    %edx,0x10(%ebp)
  800762:	8a 00                	mov    (%eax),%al
  800764:	0f b6 d8             	movzbl %al,%ebx
  800767:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80076a:	83 f8 5b             	cmp    $0x5b,%eax
  80076d:	0f 87 3d 03 00 00    	ja     800ab0 <vprintfmt+0x3ab>
  800773:	8b 04 85 58 20 80 00 	mov    0x802058(,%eax,4),%eax
  80077a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80077c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800780:	eb d7                	jmp    800759 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800782:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800786:	eb d1                	jmp    800759 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800788:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80078f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800792:	89 d0                	mov    %edx,%eax
  800794:	c1 e0 02             	shl    $0x2,%eax
  800797:	01 d0                	add    %edx,%eax
  800799:	01 c0                	add    %eax,%eax
  80079b:	01 d8                	add    %ebx,%eax
  80079d:	83 e8 30             	sub    $0x30,%eax
  8007a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a6:	8a 00                	mov    (%eax),%al
  8007a8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ab:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ae:	7e 3e                	jle    8007ee <vprintfmt+0xe9>
  8007b0:	83 fb 39             	cmp    $0x39,%ebx
  8007b3:	7f 39                	jg     8007ee <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007b5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b8:	eb d5                	jmp    80078f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bd:	83 c0 04             	add    $0x4,%eax
  8007c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	83 e8 04             	sub    $0x4,%eax
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007ce:	eb 1f                	jmp    8007ef <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d4:	79 83                	jns    800759 <vprintfmt+0x54>
				width = 0;
  8007d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007dd:	e9 77 ff ff ff       	jmp    800759 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007e2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007e9:	e9 6b ff ff ff       	jmp    800759 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007ee:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f3:	0f 89 60 ff ff ff    	jns    800759 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ff:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800806:	e9 4e ff ff ff       	jmp    800759 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80080b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80080e:	e9 46 ff ff ff       	jmp    800759 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	83 c0 04             	add    $0x4,%eax
  800819:	89 45 14             	mov    %eax,0x14(%ebp)
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	83 e8 04             	sub    $0x4,%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	83 ec 08             	sub    $0x8,%esp
  800827:	ff 75 0c             	pushl  0xc(%ebp)
  80082a:	50                   	push   %eax
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	ff d0                	call   *%eax
  800830:	83 c4 10             	add    $0x10,%esp
			break;
  800833:	e9 9b 02 00 00       	jmp    800ad3 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	83 c0 04             	add    $0x4,%eax
  80083e:	89 45 14             	mov    %eax,0x14(%ebp)
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	83 e8 04             	sub    $0x4,%eax
  800847:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800849:	85 db                	test   %ebx,%ebx
  80084b:	79 02                	jns    80084f <vprintfmt+0x14a>
				err = -err;
  80084d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80084f:	83 fb 64             	cmp    $0x64,%ebx
  800852:	7f 0b                	jg     80085f <vprintfmt+0x15a>
  800854:	8b 34 9d a0 1e 80 00 	mov    0x801ea0(,%ebx,4),%esi
  80085b:	85 f6                	test   %esi,%esi
  80085d:	75 19                	jne    800878 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80085f:	53                   	push   %ebx
  800860:	68 45 20 80 00       	push   $0x802045
  800865:	ff 75 0c             	pushl  0xc(%ebp)
  800868:	ff 75 08             	pushl  0x8(%ebp)
  80086b:	e8 70 02 00 00       	call   800ae0 <printfmt>
  800870:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800873:	e9 5b 02 00 00       	jmp    800ad3 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800878:	56                   	push   %esi
  800879:	68 4e 20 80 00       	push   $0x80204e
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	ff 75 08             	pushl  0x8(%ebp)
  800884:	e8 57 02 00 00       	call   800ae0 <printfmt>
  800889:	83 c4 10             	add    $0x10,%esp
			break;
  80088c:	e9 42 02 00 00       	jmp    800ad3 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	83 c0 04             	add    $0x4,%eax
  800897:	89 45 14             	mov    %eax,0x14(%ebp)
  80089a:	8b 45 14             	mov    0x14(%ebp),%eax
  80089d:	83 e8 04             	sub    $0x4,%eax
  8008a0:	8b 30                	mov    (%eax),%esi
  8008a2:	85 f6                	test   %esi,%esi
  8008a4:	75 05                	jne    8008ab <vprintfmt+0x1a6>
				p = "(null)";
  8008a6:	be 51 20 80 00       	mov    $0x802051,%esi
			if (width > 0 && padc != '-')
  8008ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008af:	7e 6d                	jle    80091e <vprintfmt+0x219>
  8008b1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008b5:	74 67                	je     80091e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	56                   	push   %esi
  8008bf:	e8 1e 03 00 00       	call   800be2 <strnlen>
  8008c4:	83 c4 10             	add    $0x10,%esp
  8008c7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008ca:	eb 16                	jmp    8008e2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008cc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d0:	83 ec 08             	sub    $0x8,%esp
  8008d3:	ff 75 0c             	pushl  0xc(%ebp)
  8008d6:	50                   	push   %eax
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	ff d0                	call   *%eax
  8008dc:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008df:	ff 4d e4             	decl   -0x1c(%ebp)
  8008e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e6:	7f e4                	jg     8008cc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e8:	eb 34                	jmp    80091e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ea:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008ee:	74 1c                	je     80090c <vprintfmt+0x207>
  8008f0:	83 fb 1f             	cmp    $0x1f,%ebx
  8008f3:	7e 05                	jle    8008fa <vprintfmt+0x1f5>
  8008f5:	83 fb 7e             	cmp    $0x7e,%ebx
  8008f8:	7e 12                	jle    80090c <vprintfmt+0x207>
					putch('?', putdat);
  8008fa:	83 ec 08             	sub    $0x8,%esp
  8008fd:	ff 75 0c             	pushl  0xc(%ebp)
  800900:	6a 3f                	push   $0x3f
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	ff d0                	call   *%eax
  800907:	83 c4 10             	add    $0x10,%esp
  80090a:	eb 0f                	jmp    80091b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80090c:	83 ec 08             	sub    $0x8,%esp
  80090f:	ff 75 0c             	pushl  0xc(%ebp)
  800912:	53                   	push   %ebx
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	ff d0                	call   *%eax
  800918:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80091b:	ff 4d e4             	decl   -0x1c(%ebp)
  80091e:	89 f0                	mov    %esi,%eax
  800920:	8d 70 01             	lea    0x1(%eax),%esi
  800923:	8a 00                	mov    (%eax),%al
  800925:	0f be d8             	movsbl %al,%ebx
  800928:	85 db                	test   %ebx,%ebx
  80092a:	74 24                	je     800950 <vprintfmt+0x24b>
  80092c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800930:	78 b8                	js     8008ea <vprintfmt+0x1e5>
  800932:	ff 4d e0             	decl   -0x20(%ebp)
  800935:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800939:	79 af                	jns    8008ea <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80093b:	eb 13                	jmp    800950 <vprintfmt+0x24b>
				putch(' ', putdat);
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	6a 20                	push   $0x20
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	ff d0                	call   *%eax
  80094a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80094d:	ff 4d e4             	decl   -0x1c(%ebp)
  800950:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800954:	7f e7                	jg     80093d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800956:	e9 78 01 00 00       	jmp    800ad3 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	ff 75 e8             	pushl  -0x18(%ebp)
  800961:	8d 45 14             	lea    0x14(%ebp),%eax
  800964:	50                   	push   %eax
  800965:	e8 3c fd ff ff       	call   8006a6 <getint>
  80096a:	83 c4 10             	add    $0x10,%esp
  80096d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800970:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800973:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800976:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800979:	85 d2                	test   %edx,%edx
  80097b:	79 23                	jns    8009a0 <vprintfmt+0x29b>
				putch('-', putdat);
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	ff 75 0c             	pushl  0xc(%ebp)
  800983:	6a 2d                	push   $0x2d
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	ff d0                	call   *%eax
  80098a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80098d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800990:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800993:	f7 d8                	neg    %eax
  800995:	83 d2 00             	adc    $0x0,%edx
  800998:	f7 da                	neg    %edx
  80099a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a7:	e9 bc 00 00 00       	jmp    800a68 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009ac:	83 ec 08             	sub    $0x8,%esp
  8009af:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b2:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b5:	50                   	push   %eax
  8009b6:	e8 84 fc ff ff       	call   80063f <getuint>
  8009bb:	83 c4 10             	add    $0x10,%esp
  8009be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009c4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009cb:	e9 98 00 00 00       	jmp    800a68 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d0:	83 ec 08             	sub    $0x8,%esp
  8009d3:	ff 75 0c             	pushl  0xc(%ebp)
  8009d6:	6a 58                	push   $0x58
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	ff d0                	call   *%eax
  8009dd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	ff 75 0c             	pushl  0xc(%ebp)
  8009e6:	6a 58                	push   $0x58
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	ff d0                	call   *%eax
  8009ed:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 0c             	pushl  0xc(%ebp)
  8009f6:	6a 58                	push   $0x58
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	ff d0                	call   *%eax
  8009fd:	83 c4 10             	add    $0x10,%esp
			break;
  800a00:	e9 ce 00 00 00       	jmp    800ad3 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a05:	83 ec 08             	sub    $0x8,%esp
  800a08:	ff 75 0c             	pushl  0xc(%ebp)
  800a0b:	6a 30                	push   $0x30
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	ff d0                	call   *%eax
  800a12:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a15:	83 ec 08             	sub    $0x8,%esp
  800a18:	ff 75 0c             	pushl  0xc(%ebp)
  800a1b:	6a 78                	push   $0x78
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	ff d0                	call   *%eax
  800a22:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	83 c0 04             	add    $0x4,%eax
  800a2b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	83 e8 04             	sub    $0x4,%eax
  800a34:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a40:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a47:	eb 1f                	jmp    800a68 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a49:	83 ec 08             	sub    $0x8,%esp
  800a4c:	ff 75 e8             	pushl  -0x18(%ebp)
  800a4f:	8d 45 14             	lea    0x14(%ebp),%eax
  800a52:	50                   	push   %eax
  800a53:	e8 e7 fb ff ff       	call   80063f <getuint>
  800a58:	83 c4 10             	add    $0x10,%esp
  800a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a61:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a68:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a6f:	83 ec 04             	sub    $0x4,%esp
  800a72:	52                   	push   %edx
  800a73:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a76:	50                   	push   %eax
  800a77:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7a:	ff 75 f0             	pushl  -0x10(%ebp)
  800a7d:	ff 75 0c             	pushl  0xc(%ebp)
  800a80:	ff 75 08             	pushl  0x8(%ebp)
  800a83:	e8 00 fb ff ff       	call   800588 <printnum>
  800a88:	83 c4 20             	add    $0x20,%esp
			break;
  800a8b:	eb 46                	jmp    800ad3 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a8d:	83 ec 08             	sub    $0x8,%esp
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	53                   	push   %ebx
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	ff d0                	call   *%eax
  800a99:	83 c4 10             	add    $0x10,%esp
			break;
  800a9c:	eb 35                	jmp    800ad3 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a9e:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800aa5:	eb 2c                	jmp    800ad3 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800aa7:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800aae:	eb 23                	jmp    800ad3 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ab0:	83 ec 08             	sub    $0x8,%esp
  800ab3:	ff 75 0c             	pushl  0xc(%ebp)
  800ab6:	6a 25                	push   $0x25
  800ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  800abb:	ff d0                	call   *%eax
  800abd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ac0:	ff 4d 10             	decl   0x10(%ebp)
  800ac3:	eb 03                	jmp    800ac8 <vprintfmt+0x3c3>
  800ac5:	ff 4d 10             	decl   0x10(%ebp)
  800ac8:	8b 45 10             	mov    0x10(%ebp),%eax
  800acb:	48                   	dec    %eax
  800acc:	8a 00                	mov    (%eax),%al
  800ace:	3c 25                	cmp    $0x25,%al
  800ad0:	75 f3                	jne    800ac5 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ad2:	90                   	nop
		}
	}
  800ad3:	e9 35 fc ff ff       	jmp    80070d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ad8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ad9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800adc:	5b                   	pop    %ebx
  800add:	5e                   	pop    %esi
  800ade:	5d                   	pop    %ebp
  800adf:	c3                   	ret    

00800ae0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ae6:	8d 45 10             	lea    0x10(%ebp),%eax
  800ae9:	83 c0 04             	add    $0x4,%eax
  800aec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800aef:	8b 45 10             	mov    0x10(%ebp),%eax
  800af2:	ff 75 f4             	pushl  -0xc(%ebp)
  800af5:	50                   	push   %eax
  800af6:	ff 75 0c             	pushl  0xc(%ebp)
  800af9:	ff 75 08             	pushl  0x8(%ebp)
  800afc:	e8 04 fc ff ff       	call   800705 <vprintfmt>
  800b01:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b04:	90                   	nop
  800b05:	c9                   	leave  
  800b06:	c3                   	ret    

00800b07 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0d:	8b 40 08             	mov    0x8(%eax),%eax
  800b10:	8d 50 01             	lea    0x1(%eax),%edx
  800b13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b16:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1c:	8b 10                	mov    (%eax),%edx
  800b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b21:	8b 40 04             	mov    0x4(%eax),%eax
  800b24:	39 c2                	cmp    %eax,%edx
  800b26:	73 12                	jae    800b3a <sprintputch+0x33>
		*b->buf++ = ch;
  800b28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2b:	8b 00                	mov    (%eax),%eax
  800b2d:	8d 48 01             	lea    0x1(%eax),%ecx
  800b30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b33:	89 0a                	mov    %ecx,(%edx)
  800b35:	8b 55 08             	mov    0x8(%ebp),%edx
  800b38:	88 10                	mov    %dl,(%eax)
}
  800b3a:	90                   	nop
  800b3b:	5d                   	pop    %ebp
  800b3c:	c3                   	ret    

00800b3d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	01 d0                	add    %edx,%eax
  800b54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b5e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b62:	74 06                	je     800b6a <vsnprintf+0x2d>
  800b64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b68:	7f 07                	jg     800b71 <vsnprintf+0x34>
		return -E_INVAL;
  800b6a:	b8 03 00 00 00       	mov    $0x3,%eax
  800b6f:	eb 20                	jmp    800b91 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b71:	ff 75 14             	pushl  0x14(%ebp)
  800b74:	ff 75 10             	pushl  0x10(%ebp)
  800b77:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b7a:	50                   	push   %eax
  800b7b:	68 07 0b 80 00       	push   $0x800b07
  800b80:	e8 80 fb ff ff       	call   800705 <vprintfmt>
  800b85:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b8b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b91:	c9                   	leave  
  800b92:	c3                   	ret    

00800b93 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b99:	8d 45 10             	lea    0x10(%ebp),%eax
  800b9c:	83 c0 04             	add    $0x4,%eax
  800b9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ba2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba8:	50                   	push   %eax
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	ff 75 08             	pushl  0x8(%ebp)
  800baf:	e8 89 ff ff ff       	call   800b3d <vsnprintf>
  800bb4:	83 c4 10             	add    $0x10,%esp
  800bb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bbd:	c9                   	leave  
  800bbe:	c3                   	ret    

00800bbf <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bcc:	eb 06                	jmp    800bd4 <strlen+0x15>
		n++;
  800bce:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd1:	ff 45 08             	incl   0x8(%ebp)
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	8a 00                	mov    (%eax),%al
  800bd9:	84 c0                	test   %al,%al
  800bdb:	75 f1                	jne    800bce <strlen+0xf>
		n++;
	return n;
  800bdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be0:	c9                   	leave  
  800be1:	c3                   	ret    

00800be2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bef:	eb 09                	jmp    800bfa <strnlen+0x18>
		n++;
  800bf1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bf4:	ff 45 08             	incl   0x8(%ebp)
  800bf7:	ff 4d 0c             	decl   0xc(%ebp)
  800bfa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bfe:	74 09                	je     800c09 <strnlen+0x27>
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	8a 00                	mov    (%eax),%al
  800c05:	84 c0                	test   %al,%al
  800c07:	75 e8                	jne    800bf1 <strnlen+0xf>
		n++;
	return n;
  800c09:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c1a:	90                   	nop
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	8d 50 01             	lea    0x1(%eax),%edx
  800c21:	89 55 08             	mov    %edx,0x8(%ebp)
  800c24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c27:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c2a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c2d:	8a 12                	mov    (%edx),%dl
  800c2f:	88 10                	mov    %dl,(%eax)
  800c31:	8a 00                	mov    (%eax),%al
  800c33:	84 c0                	test   %al,%al
  800c35:	75 e4                	jne    800c1b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c37:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c3a:	c9                   	leave  
  800c3b:	c3                   	ret    

00800c3c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c4f:	eb 1f                	jmp    800c70 <strncpy+0x34>
		*dst++ = *src;
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	8d 50 01             	lea    0x1(%eax),%edx
  800c57:	89 55 08             	mov    %edx,0x8(%ebp)
  800c5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5d:	8a 12                	mov    (%edx),%dl
  800c5f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c64:	8a 00                	mov    (%eax),%al
  800c66:	84 c0                	test   %al,%al
  800c68:	74 03                	je     800c6d <strncpy+0x31>
			src++;
  800c6a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c6d:	ff 45 fc             	incl   -0x4(%ebp)
  800c70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c73:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c76:	72 d9                	jb     800c51 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c78:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c7b:	c9                   	leave  
  800c7c:	c3                   	ret    

00800c7d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c7d:	55                   	push   %ebp
  800c7e:	89 e5                	mov    %esp,%ebp
  800c80:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c8d:	74 30                	je     800cbf <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c8f:	eb 16                	jmp    800ca7 <strlcpy+0x2a>
			*dst++ = *src++;
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	8d 50 01             	lea    0x1(%eax),%edx
  800c97:	89 55 08             	mov    %edx,0x8(%ebp)
  800c9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ca0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ca3:	8a 12                	mov    (%edx),%dl
  800ca5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ca7:	ff 4d 10             	decl   0x10(%ebp)
  800caa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cae:	74 09                	je     800cb9 <strlcpy+0x3c>
  800cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb3:	8a 00                	mov    (%eax),%al
  800cb5:	84 c0                	test   %al,%al
  800cb7:	75 d8                	jne    800c91 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc5:	29 c2                	sub    %eax,%edx
  800cc7:	89 d0                	mov    %edx,%eax
}
  800cc9:	c9                   	leave  
  800cca:	c3                   	ret    

00800ccb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ccb:	55                   	push   %ebp
  800ccc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cce:	eb 06                	jmp    800cd6 <strcmp+0xb>
		p++, q++;
  800cd0:	ff 45 08             	incl   0x8(%ebp)
  800cd3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	8a 00                	mov    (%eax),%al
  800cdb:	84 c0                	test   %al,%al
  800cdd:	74 0e                	je     800ced <strcmp+0x22>
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	8a 10                	mov    (%eax),%dl
  800ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce7:	8a 00                	mov    (%eax),%al
  800ce9:	38 c2                	cmp    %al,%dl
  800ceb:	74 e3                	je     800cd0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	0f b6 d0             	movzbl %al,%edx
  800cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	0f b6 c0             	movzbl %al,%eax
  800cfd:	29 c2                	sub    %eax,%edx
  800cff:	89 d0                	mov    %edx,%eax
}
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    

00800d03 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d06:	eb 09                	jmp    800d11 <strncmp+0xe>
		n--, p++, q++;
  800d08:	ff 4d 10             	decl   0x10(%ebp)
  800d0b:	ff 45 08             	incl   0x8(%ebp)
  800d0e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d15:	74 17                	je     800d2e <strncmp+0x2b>
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	8a 00                	mov    (%eax),%al
  800d1c:	84 c0                	test   %al,%al
  800d1e:	74 0e                	je     800d2e <strncmp+0x2b>
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	8a 10                	mov    (%eax),%dl
  800d25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d28:	8a 00                	mov    (%eax),%al
  800d2a:	38 c2                	cmp    %al,%dl
  800d2c:	74 da                	je     800d08 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d32:	75 07                	jne    800d3b <strncmp+0x38>
		return 0;
  800d34:	b8 00 00 00 00       	mov    $0x0,%eax
  800d39:	eb 14                	jmp    800d4f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	8a 00                	mov    (%eax),%al
  800d40:	0f b6 d0             	movzbl %al,%edx
  800d43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	0f b6 c0             	movzbl %al,%eax
  800d4b:	29 c2                	sub    %eax,%edx
  800d4d:	89 d0                	mov    %edx,%eax
}
  800d4f:	5d                   	pop    %ebp
  800d50:	c3                   	ret    

00800d51 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	83 ec 04             	sub    $0x4,%esp
  800d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d5d:	eb 12                	jmp    800d71 <strchr+0x20>
		if (*s == c)
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d67:	75 05                	jne    800d6e <strchr+0x1d>
			return (char *) s;
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	eb 11                	jmp    800d7f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d6e:	ff 45 08             	incl   0x8(%ebp)
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	8a 00                	mov    (%eax),%al
  800d76:	84 c0                	test   %al,%al
  800d78:	75 e5                	jne    800d5f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d7f:	c9                   	leave  
  800d80:	c3                   	ret    

00800d81 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	83 ec 04             	sub    $0x4,%esp
  800d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d8d:	eb 0d                	jmp    800d9c <strfind+0x1b>
		if (*s == c)
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	8a 00                	mov    (%eax),%al
  800d94:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d97:	74 0e                	je     800da7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d99:	ff 45 08             	incl   0x8(%ebp)
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	8a 00                	mov    (%eax),%al
  800da1:	84 c0                	test   %al,%al
  800da3:	75 ea                	jne    800d8f <strfind+0xe>
  800da5:	eb 01                	jmp    800da8 <strfind+0x27>
		if (*s == c)
			break;
  800da7:	90                   	nop
	return (char *) s;
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dab:	c9                   	leave  
  800dac:	c3                   	ret    

00800dad <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800db9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dbf:	eb 0e                	jmp    800dcf <memset+0x22>
		*p++ = c;
  800dc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc4:	8d 50 01             	lea    0x1(%eax),%edx
  800dc7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dca:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dcd:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dcf:	ff 4d f8             	decl   -0x8(%ebp)
  800dd2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dd6:	79 e9                	jns    800dc1 <memset+0x14>
		*p++ = c;

	return v;
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ddb:	c9                   	leave  
  800ddc:	c3                   	ret    

00800ddd <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800de3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800def:	eb 16                	jmp    800e07 <memcpy+0x2a>
		*d++ = *s++;
  800df1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df4:	8d 50 01             	lea    0x1(%eax),%edx
  800df7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dfa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dfd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e00:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e03:	8a 12                	mov    (%edx),%dl
  800e05:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e07:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e0d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e10:	85 c0                	test   %eax,%eax
  800e12:	75 dd                	jne    800df1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e17:	c9                   	leave  
  800e18:	c3                   	ret    

00800e19 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e2e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e31:	73 50                	jae    800e83 <memmove+0x6a>
  800e33:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e36:	8b 45 10             	mov    0x10(%ebp),%eax
  800e39:	01 d0                	add    %edx,%eax
  800e3b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e3e:	76 43                	jbe    800e83 <memmove+0x6a>
		s += n;
  800e40:	8b 45 10             	mov    0x10(%ebp),%eax
  800e43:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e46:	8b 45 10             	mov    0x10(%ebp),%eax
  800e49:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e4c:	eb 10                	jmp    800e5e <memmove+0x45>
			*--d = *--s;
  800e4e:	ff 4d f8             	decl   -0x8(%ebp)
  800e51:	ff 4d fc             	decl   -0x4(%ebp)
  800e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e57:	8a 10                	mov    (%eax),%dl
  800e59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e61:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e64:	89 55 10             	mov    %edx,0x10(%ebp)
  800e67:	85 c0                	test   %eax,%eax
  800e69:	75 e3                	jne    800e4e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e6b:	eb 23                	jmp    800e90 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e70:	8d 50 01             	lea    0x1(%eax),%edx
  800e73:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e76:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e79:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e7c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e7f:	8a 12                	mov    (%edx),%dl
  800e81:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e83:	8b 45 10             	mov    0x10(%ebp),%eax
  800e86:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e89:	89 55 10             	mov    %edx,0x10(%ebp)
  800e8c:	85 c0                	test   %eax,%eax
  800e8e:	75 dd                	jne    800e6d <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e93:	c9                   	leave  
  800e94:	c3                   	ret    

00800e95 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ea1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ea7:	eb 2a                	jmp    800ed3 <memcmp+0x3e>
		if (*s1 != *s2)
  800ea9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eac:	8a 10                	mov    (%eax),%dl
  800eae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	38 c2                	cmp    %al,%dl
  800eb5:	74 16                	je     800ecd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eba:	8a 00                	mov    (%eax),%al
  800ebc:	0f b6 d0             	movzbl %al,%edx
  800ebf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec2:	8a 00                	mov    (%eax),%al
  800ec4:	0f b6 c0             	movzbl %al,%eax
  800ec7:	29 c2                	sub    %eax,%edx
  800ec9:	89 d0                	mov    %edx,%eax
  800ecb:	eb 18                	jmp    800ee5 <memcmp+0x50>
		s1++, s2++;
  800ecd:	ff 45 fc             	incl   -0x4(%ebp)
  800ed0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ed3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed9:	89 55 10             	mov    %edx,0x10(%ebp)
  800edc:	85 c0                	test   %eax,%eax
  800ede:	75 c9                	jne    800ea9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ee0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee5:	c9                   	leave  
  800ee6:	c3                   	ret    

00800ee7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ee7:	55                   	push   %ebp
  800ee8:	89 e5                	mov    %esp,%ebp
  800eea:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800eed:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef3:	01 d0                	add    %edx,%eax
  800ef5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ef8:	eb 15                	jmp    800f0f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	0f b6 d0             	movzbl %al,%edx
  800f02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f05:	0f b6 c0             	movzbl %al,%eax
  800f08:	39 c2                	cmp    %eax,%edx
  800f0a:	74 0d                	je     800f19 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f0c:	ff 45 08             	incl   0x8(%ebp)
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f15:	72 e3                	jb     800efa <memfind+0x13>
  800f17:	eb 01                	jmp    800f1a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f19:	90                   	nop
	return (void *) s;
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1d:	c9                   	leave  
  800f1e:	c3                   	ret    

00800f1f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f1f:	55                   	push   %ebp
  800f20:	89 e5                	mov    %esp,%ebp
  800f22:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f2c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f33:	eb 03                	jmp    800f38 <strtol+0x19>
		s++;
  800f35:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	3c 20                	cmp    $0x20,%al
  800f3f:	74 f4                	je     800f35 <strtol+0x16>
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8a 00                	mov    (%eax),%al
  800f46:	3c 09                	cmp    $0x9,%al
  800f48:	74 eb                	je     800f35 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	8a 00                	mov    (%eax),%al
  800f4f:	3c 2b                	cmp    $0x2b,%al
  800f51:	75 05                	jne    800f58 <strtol+0x39>
		s++;
  800f53:	ff 45 08             	incl   0x8(%ebp)
  800f56:	eb 13                	jmp    800f6b <strtol+0x4c>
	else if (*s == '-')
  800f58:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5b:	8a 00                	mov    (%eax),%al
  800f5d:	3c 2d                	cmp    $0x2d,%al
  800f5f:	75 0a                	jne    800f6b <strtol+0x4c>
		s++, neg = 1;
  800f61:	ff 45 08             	incl   0x8(%ebp)
  800f64:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6f:	74 06                	je     800f77 <strtol+0x58>
  800f71:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f75:	75 20                	jne    800f97 <strtol+0x78>
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	3c 30                	cmp    $0x30,%al
  800f7e:	75 17                	jne    800f97 <strtol+0x78>
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	40                   	inc    %eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	3c 78                	cmp    $0x78,%al
  800f88:	75 0d                	jne    800f97 <strtol+0x78>
		s += 2, base = 16;
  800f8a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f8e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f95:	eb 28                	jmp    800fbf <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9b:	75 15                	jne    800fb2 <strtol+0x93>
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	3c 30                	cmp    $0x30,%al
  800fa4:	75 0c                	jne    800fb2 <strtol+0x93>
		s++, base = 8;
  800fa6:	ff 45 08             	incl   0x8(%ebp)
  800fa9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fb0:	eb 0d                	jmp    800fbf <strtol+0xa0>
	else if (base == 0)
  800fb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb6:	75 07                	jne    800fbf <strtol+0xa0>
		base = 10;
  800fb8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	3c 2f                	cmp    $0x2f,%al
  800fc6:	7e 19                	jle    800fe1 <strtol+0xc2>
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	3c 39                	cmp    $0x39,%al
  800fcf:	7f 10                	jg     800fe1 <strtol+0xc2>
			dig = *s - '0';
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	0f be c0             	movsbl %al,%eax
  800fd9:	83 e8 30             	sub    $0x30,%eax
  800fdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fdf:	eb 42                	jmp    801023 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	3c 60                	cmp    $0x60,%al
  800fe8:	7e 19                	jle    801003 <strtol+0xe4>
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	8a 00                	mov    (%eax),%al
  800fef:	3c 7a                	cmp    $0x7a,%al
  800ff1:	7f 10                	jg     801003 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	0f be c0             	movsbl %al,%eax
  800ffb:	83 e8 57             	sub    $0x57,%eax
  800ffe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801001:	eb 20                	jmp    801023 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	3c 40                	cmp    $0x40,%al
  80100a:	7e 39                	jle    801045 <strtol+0x126>
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	8a 00                	mov    (%eax),%al
  801011:	3c 5a                	cmp    $0x5a,%al
  801013:	7f 30                	jg     801045 <strtol+0x126>
			dig = *s - 'A' + 10;
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8a 00                	mov    (%eax),%al
  80101a:	0f be c0             	movsbl %al,%eax
  80101d:	83 e8 37             	sub    $0x37,%eax
  801020:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801023:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801026:	3b 45 10             	cmp    0x10(%ebp),%eax
  801029:	7d 19                	jge    801044 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80102b:	ff 45 08             	incl   0x8(%ebp)
  80102e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801031:	0f af 45 10          	imul   0x10(%ebp),%eax
  801035:	89 c2                	mov    %eax,%edx
  801037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80103a:	01 d0                	add    %edx,%eax
  80103c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80103f:	e9 7b ff ff ff       	jmp    800fbf <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801044:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801045:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801049:	74 08                	je     801053 <strtol+0x134>
		*endptr = (char *) s;
  80104b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104e:	8b 55 08             	mov    0x8(%ebp),%edx
  801051:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801053:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801057:	74 07                	je     801060 <strtol+0x141>
  801059:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105c:	f7 d8                	neg    %eax
  80105e:	eb 03                	jmp    801063 <strtol+0x144>
  801060:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801063:	c9                   	leave  
  801064:	c3                   	ret    

00801065 <ltostr>:

void
ltostr(long value, char *str)
{
  801065:	55                   	push   %ebp
  801066:	89 e5                	mov    %esp,%ebp
  801068:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80106b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801072:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801079:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80107d:	79 13                	jns    801092 <ltostr+0x2d>
	{
		neg = 1;
  80107f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801086:	8b 45 0c             	mov    0xc(%ebp),%eax
  801089:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80108c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80108f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80109a:	99                   	cltd   
  80109b:	f7 f9                	idiv   %ecx
  80109d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a3:	8d 50 01             	lea    0x1(%eax),%edx
  8010a6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a9:	89 c2                	mov    %eax,%edx
  8010ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ae:	01 d0                	add    %edx,%eax
  8010b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010b3:	83 c2 30             	add    $0x30,%edx
  8010b6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010bb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c0:	f7 e9                	imul   %ecx
  8010c2:	c1 fa 02             	sar    $0x2,%edx
  8010c5:	89 c8                	mov    %ecx,%eax
  8010c7:	c1 f8 1f             	sar    $0x1f,%eax
  8010ca:	29 c2                	sub    %eax,%edx
  8010cc:	89 d0                	mov    %edx,%eax
  8010ce:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010d5:	75 bb                	jne    801092 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e1:	48                   	dec    %eax
  8010e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010e9:	74 3d                	je     801128 <ltostr+0xc3>
		start = 1 ;
  8010eb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010f2:	eb 34                	jmp    801128 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fa:	01 d0                	add    %edx,%eax
  8010fc:	8a 00                	mov    (%eax),%al
  8010fe:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801101:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801104:	8b 45 0c             	mov    0xc(%ebp),%eax
  801107:	01 c2                	add    %eax,%edx
  801109:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80110c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110f:	01 c8                	add    %ecx,%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801115:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111b:	01 c2                	add    %eax,%edx
  80111d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801120:	88 02                	mov    %al,(%edx)
		start++ ;
  801122:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801125:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80112e:	7c c4                	jl     8010f4 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801130:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801133:	8b 45 0c             	mov    0xc(%ebp),%eax
  801136:	01 d0                	add    %edx,%eax
  801138:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80113b:	90                   	nop
  80113c:	c9                   	leave  
  80113d:	c3                   	ret    

0080113e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80113e:	55                   	push   %ebp
  80113f:	89 e5                	mov    %esp,%ebp
  801141:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801144:	ff 75 08             	pushl  0x8(%ebp)
  801147:	e8 73 fa ff ff       	call   800bbf <strlen>
  80114c:	83 c4 04             	add    $0x4,%esp
  80114f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801152:	ff 75 0c             	pushl  0xc(%ebp)
  801155:	e8 65 fa ff ff       	call   800bbf <strlen>
  80115a:	83 c4 04             	add    $0x4,%esp
  80115d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801160:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801167:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80116e:	eb 17                	jmp    801187 <strcconcat+0x49>
		final[s] = str1[s] ;
  801170:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801173:	8b 45 10             	mov    0x10(%ebp),%eax
  801176:	01 c2                	add    %eax,%edx
  801178:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80117b:	8b 45 08             	mov    0x8(%ebp),%eax
  80117e:	01 c8                	add    %ecx,%eax
  801180:	8a 00                	mov    (%eax),%al
  801182:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801184:	ff 45 fc             	incl   -0x4(%ebp)
  801187:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80118d:	7c e1                	jl     801170 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80118f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801196:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80119d:	eb 1f                	jmp    8011be <strcconcat+0x80>
		final[s++] = str2[i] ;
  80119f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a2:	8d 50 01             	lea    0x1(%eax),%edx
  8011a5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011a8:	89 c2                	mov    %eax,%edx
  8011aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ad:	01 c2                	add    %eax,%edx
  8011af:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b5:	01 c8                	add    %ecx,%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011bb:	ff 45 f8             	incl   -0x8(%ebp)
  8011be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011c4:	7c d9                	jl     80119f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cc:	01 d0                	add    %edx,%eax
  8011ce:	c6 00 00             	movb   $0x0,(%eax)
}
  8011d1:	90                   	nop
  8011d2:	c9                   	leave  
  8011d3:	c3                   	ret    

008011d4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011d4:	55                   	push   %ebp
  8011d5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8011da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e3:	8b 00                	mov    (%eax),%eax
  8011e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ef:	01 d0                	add    %edx,%eax
  8011f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011f7:	eb 0c                	jmp    801205 <strsplit+0x31>
			*string++ = 0;
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	8d 50 01             	lea    0x1(%eax),%edx
  8011ff:	89 55 08             	mov    %edx,0x8(%ebp)
  801202:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	8a 00                	mov    (%eax),%al
  80120a:	84 c0                	test   %al,%al
  80120c:	74 18                	je     801226 <strsplit+0x52>
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	8a 00                	mov    (%eax),%al
  801213:	0f be c0             	movsbl %al,%eax
  801216:	50                   	push   %eax
  801217:	ff 75 0c             	pushl  0xc(%ebp)
  80121a:	e8 32 fb ff ff       	call   800d51 <strchr>
  80121f:	83 c4 08             	add    $0x8,%esp
  801222:	85 c0                	test   %eax,%eax
  801224:	75 d3                	jne    8011f9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	8a 00                	mov    (%eax),%al
  80122b:	84 c0                	test   %al,%al
  80122d:	74 5a                	je     801289 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80122f:	8b 45 14             	mov    0x14(%ebp),%eax
  801232:	8b 00                	mov    (%eax),%eax
  801234:	83 f8 0f             	cmp    $0xf,%eax
  801237:	75 07                	jne    801240 <strsplit+0x6c>
		{
			return 0;
  801239:	b8 00 00 00 00       	mov    $0x0,%eax
  80123e:	eb 66                	jmp    8012a6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801240:	8b 45 14             	mov    0x14(%ebp),%eax
  801243:	8b 00                	mov    (%eax),%eax
  801245:	8d 48 01             	lea    0x1(%eax),%ecx
  801248:	8b 55 14             	mov    0x14(%ebp),%edx
  80124b:	89 0a                	mov    %ecx,(%edx)
  80124d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801254:	8b 45 10             	mov    0x10(%ebp),%eax
  801257:	01 c2                	add    %eax,%edx
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80125e:	eb 03                	jmp    801263 <strsplit+0x8f>
			string++;
  801260:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	8a 00                	mov    (%eax),%al
  801268:	84 c0                	test   %al,%al
  80126a:	74 8b                	je     8011f7 <strsplit+0x23>
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	0f be c0             	movsbl %al,%eax
  801274:	50                   	push   %eax
  801275:	ff 75 0c             	pushl  0xc(%ebp)
  801278:	e8 d4 fa ff ff       	call   800d51 <strchr>
  80127d:	83 c4 08             	add    $0x8,%esp
  801280:	85 c0                	test   %eax,%eax
  801282:	74 dc                	je     801260 <strsplit+0x8c>
			string++;
	}
  801284:	e9 6e ff ff ff       	jmp    8011f7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801289:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80128a:	8b 45 14             	mov    0x14(%ebp),%eax
  80128d:	8b 00                	mov    (%eax),%eax
  80128f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801296:	8b 45 10             	mov    0x10(%ebp),%eax
  801299:	01 d0                	add    %edx,%eax
  80129b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012a1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012a6:	c9                   	leave  
  8012a7:	c3                   	ret    

008012a8 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
  8012ab:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8012ae:	83 ec 04             	sub    $0x4,%esp
  8012b1:	68 c8 21 80 00       	push   $0x8021c8
  8012b6:	68 3f 01 00 00       	push   $0x13f
  8012bb:	68 ea 21 80 00       	push   $0x8021ea
  8012c0:	e8 a9 ef ff ff       	call   80026e <_panic>

008012c5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	57                   	push   %edi
  8012c9:	56                   	push   %esi
  8012ca:	53                   	push   %ebx
  8012cb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012d7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012da:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012dd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012e0:	cd 30                	int    $0x30
  8012e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012e8:	83 c4 10             	add    $0x10,%esp
  8012eb:	5b                   	pop    %ebx
  8012ec:	5e                   	pop    %esi
  8012ed:	5f                   	pop    %edi
  8012ee:	5d                   	pop    %ebp
  8012ef:	c3                   	ret    

008012f0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	83 ec 04             	sub    $0x4,%esp
  8012f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012fc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	6a 00                	push   $0x0
  801305:	6a 00                	push   $0x0
  801307:	52                   	push   %edx
  801308:	ff 75 0c             	pushl  0xc(%ebp)
  80130b:	50                   	push   %eax
  80130c:	6a 00                	push   $0x0
  80130e:	e8 b2 ff ff ff       	call   8012c5 <syscall>
  801313:	83 c4 18             	add    $0x18,%esp
}
  801316:	90                   	nop
  801317:	c9                   	leave  
  801318:	c3                   	ret    

00801319 <sys_cgetc>:

int
sys_cgetc(void)
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80131c:	6a 00                	push   $0x0
  80131e:	6a 00                	push   $0x0
  801320:	6a 00                	push   $0x0
  801322:	6a 00                	push   $0x0
  801324:	6a 00                	push   $0x0
  801326:	6a 02                	push   $0x2
  801328:	e8 98 ff ff ff       	call   8012c5 <syscall>
  80132d:	83 c4 18             	add    $0x18,%esp
}
  801330:	c9                   	leave  
  801331:	c3                   	ret    

00801332 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801335:	6a 00                	push   $0x0
  801337:	6a 00                	push   $0x0
  801339:	6a 00                	push   $0x0
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 03                	push   $0x3
  801341:	e8 7f ff ff ff       	call   8012c5 <syscall>
  801346:	83 c4 18             	add    $0x18,%esp
}
  801349:	90                   	nop
  80134a:	c9                   	leave  
  80134b:	c3                   	ret    

0080134c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	6a 04                	push   $0x4
  80135b:	e8 65 ff ff ff       	call   8012c5 <syscall>
  801360:	83 c4 18             	add    $0x18,%esp
}
  801363:	90                   	nop
  801364:	c9                   	leave  
  801365:	c3                   	ret    

00801366 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801369:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	6a 00                	push   $0x0
  801375:	52                   	push   %edx
  801376:	50                   	push   %eax
  801377:	6a 08                	push   $0x8
  801379:	e8 47 ff ff ff       	call   8012c5 <syscall>
  80137e:	83 c4 18             	add    $0x18,%esp
}
  801381:	c9                   	leave  
  801382:	c3                   	ret    

00801383 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
  801386:	56                   	push   %esi
  801387:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801388:	8b 75 18             	mov    0x18(%ebp),%esi
  80138b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80138e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801391:	8b 55 0c             	mov    0xc(%ebp),%edx
  801394:	8b 45 08             	mov    0x8(%ebp),%eax
  801397:	56                   	push   %esi
  801398:	53                   	push   %ebx
  801399:	51                   	push   %ecx
  80139a:	52                   	push   %edx
  80139b:	50                   	push   %eax
  80139c:	6a 09                	push   $0x9
  80139e:	e8 22 ff ff ff       	call   8012c5 <syscall>
  8013a3:	83 c4 18             	add    $0x18,%esp
}
  8013a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013a9:	5b                   	pop    %ebx
  8013aa:	5e                   	pop    %esi
  8013ab:	5d                   	pop    %ebp
  8013ac:	c3                   	ret    

008013ad <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8013ad:	55                   	push   %ebp
  8013ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	6a 00                	push   $0x0
  8013b8:	6a 00                	push   $0x0
  8013ba:	6a 00                	push   $0x0
  8013bc:	52                   	push   %edx
  8013bd:	50                   	push   %eax
  8013be:	6a 0a                	push   $0xa
  8013c0:	e8 00 ff ff ff       	call   8012c5 <syscall>
  8013c5:	83 c4 18             	add    $0x18,%esp
}
  8013c8:	c9                   	leave  
  8013c9:	c3                   	ret    

008013ca <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 00                	push   $0x0
  8013d1:	6a 00                	push   $0x0
  8013d3:	ff 75 0c             	pushl  0xc(%ebp)
  8013d6:	ff 75 08             	pushl  0x8(%ebp)
  8013d9:	6a 0b                	push   $0xb
  8013db:	e8 e5 fe ff ff       	call   8012c5 <syscall>
  8013e0:	83 c4 18             	add    $0x18,%esp
}
  8013e3:	c9                   	leave  
  8013e4:	c3                   	ret    

008013e5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 00                	push   $0x0
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 0c                	push   $0xc
  8013f4:	e8 cc fe ff ff       	call   8012c5 <syscall>
  8013f9:	83 c4 18             	add    $0x18,%esp
}
  8013fc:	c9                   	leave  
  8013fd:	c3                   	ret    

008013fe <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801401:	6a 00                	push   $0x0
  801403:	6a 00                	push   $0x0
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	6a 0d                	push   $0xd
  80140d:	e8 b3 fe ff ff       	call   8012c5 <syscall>
  801412:	83 c4 18             	add    $0x18,%esp
}
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80141a:	6a 00                	push   $0x0
  80141c:	6a 00                	push   $0x0
  80141e:	6a 00                	push   $0x0
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	6a 0e                	push   $0xe
  801426:	e8 9a fe ff ff       	call   8012c5 <syscall>
  80142b:	83 c4 18             	add    $0x18,%esp
}
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    

00801430 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801433:	6a 00                	push   $0x0
  801435:	6a 00                	push   $0x0
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 0f                	push   $0xf
  80143f:	e8 81 fe ff ff       	call   8012c5 <syscall>
  801444:	83 c4 18             	add    $0x18,%esp
}
  801447:	c9                   	leave  
  801448:	c3                   	ret    

00801449 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80144c:	6a 00                	push   $0x0
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	ff 75 08             	pushl  0x8(%ebp)
  801457:	6a 10                	push   $0x10
  801459:	e8 67 fe ff ff       	call   8012c5 <syscall>
  80145e:	83 c4 18             	add    $0x18,%esp
}
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	6a 11                	push   $0x11
  801472:	e8 4e fe ff ff       	call   8012c5 <syscall>
  801477:	83 c4 18             	add    $0x18,%esp
}
  80147a:	90                   	nop
  80147b:	c9                   	leave  
  80147c:	c3                   	ret    

0080147d <sys_cputc>:

void
sys_cputc(const char c)
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
  801480:	83 ec 04             	sub    $0x4,%esp
  801483:	8b 45 08             	mov    0x8(%ebp),%eax
  801486:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801489:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80148d:	6a 00                	push   $0x0
  80148f:	6a 00                	push   $0x0
  801491:	6a 00                	push   $0x0
  801493:	6a 00                	push   $0x0
  801495:	50                   	push   %eax
  801496:	6a 01                	push   $0x1
  801498:	e8 28 fe ff ff       	call   8012c5 <syscall>
  80149d:	83 c4 18             	add    $0x18,%esp
}
  8014a0:	90                   	nop
  8014a1:	c9                   	leave  
  8014a2:	c3                   	ret    

008014a3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 00                	push   $0x0
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 14                	push   $0x14
  8014b2:	e8 0e fe ff ff       	call   8012c5 <syscall>
  8014b7:	83 c4 18             	add    $0x18,%esp
}
  8014ba:	90                   	nop
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    

008014bd <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	83 ec 04             	sub    $0x4,%esp
  8014c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014c9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014cc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	6a 00                	push   $0x0
  8014d5:	51                   	push   %ecx
  8014d6:	52                   	push   %edx
  8014d7:	ff 75 0c             	pushl  0xc(%ebp)
  8014da:	50                   	push   %eax
  8014db:	6a 15                	push   $0x15
  8014dd:	e8 e3 fd ff ff       	call   8012c5 <syscall>
  8014e2:	83 c4 18             	add    $0x18,%esp
}
  8014e5:	c9                   	leave  
  8014e6:	c3                   	ret    

008014e7 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	52                   	push   %edx
  8014f7:	50                   	push   %eax
  8014f8:	6a 16                	push   $0x16
  8014fa:	e8 c6 fd ff ff       	call   8012c5 <syscall>
  8014ff:	83 c4 18             	add    $0x18,%esp
}
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801507:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80150a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	51                   	push   %ecx
  801515:	52                   	push   %edx
  801516:	50                   	push   %eax
  801517:	6a 17                	push   $0x17
  801519:	e8 a7 fd ff ff       	call   8012c5 <syscall>
  80151e:	83 c4 18             	add    $0x18,%esp
}
  801521:	c9                   	leave  
  801522:	c3                   	ret    

00801523 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801526:	8b 55 0c             	mov    0xc(%ebp),%edx
  801529:	8b 45 08             	mov    0x8(%ebp),%eax
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	52                   	push   %edx
  801533:	50                   	push   %eax
  801534:	6a 18                	push   $0x18
  801536:	e8 8a fd ff ff       	call   8012c5 <syscall>
  80153b:	83 c4 18             	add    $0x18,%esp
}
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	6a 00                	push   $0x0
  801548:	ff 75 14             	pushl  0x14(%ebp)
  80154b:	ff 75 10             	pushl  0x10(%ebp)
  80154e:	ff 75 0c             	pushl  0xc(%ebp)
  801551:	50                   	push   %eax
  801552:	6a 19                	push   $0x19
  801554:	e8 6c fd ff ff       	call   8012c5 <syscall>
  801559:	83 c4 18             	add    $0x18,%esp
}
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    

0080155e <sys_run_env>:

void sys_run_env(int32 envId)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	50                   	push   %eax
  80156d:	6a 1a                	push   $0x1a
  80156f:	e8 51 fd ff ff       	call   8012c5 <syscall>
  801574:	83 c4 18             	add    $0x18,%esp
}
  801577:	90                   	nop
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	50                   	push   %eax
  801589:	6a 1b                	push   $0x1b
  80158b:	e8 35 fd ff ff       	call   8012c5 <syscall>
  801590:	83 c4 18             	add    $0x18,%esp
}
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 05                	push   $0x5
  8015a4:	e8 1c fd ff ff       	call   8012c5 <syscall>
  8015a9:	83 c4 18             	add    $0x18,%esp
}
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    

008015ae <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 06                	push   $0x6
  8015bd:	e8 03 fd ff ff       	call   8012c5 <syscall>
  8015c2:	83 c4 18             	add    $0x18,%esp
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 07                	push   $0x7
  8015d6:	e8 ea fc ff ff       	call   8012c5 <syscall>
  8015db:	83 c4 18             	add    $0x18,%esp
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <sys_exit_env>:


void sys_exit_env(void)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 1c                	push   $0x1c
  8015ef:	e8 d1 fc ff ff       	call   8012c5 <syscall>
  8015f4:	83 c4 18             	add    $0x18,%esp
}
  8015f7:	90                   	nop
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801600:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801603:	8d 50 04             	lea    0x4(%eax),%edx
  801606:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	52                   	push   %edx
  801610:	50                   	push   %eax
  801611:	6a 1d                	push   $0x1d
  801613:	e8 ad fc ff ff       	call   8012c5 <syscall>
  801618:	83 c4 18             	add    $0x18,%esp
	return result;
  80161b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80161e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801621:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801624:	89 01                	mov    %eax,(%ecx)
  801626:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801629:	8b 45 08             	mov    0x8(%ebp),%eax
  80162c:	c9                   	leave  
  80162d:	c2 04 00             	ret    $0x4

00801630 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	ff 75 10             	pushl  0x10(%ebp)
  80163a:	ff 75 0c             	pushl  0xc(%ebp)
  80163d:	ff 75 08             	pushl  0x8(%ebp)
  801640:	6a 13                	push   $0x13
  801642:	e8 7e fc ff ff       	call   8012c5 <syscall>
  801647:	83 c4 18             	add    $0x18,%esp
	return ;
  80164a:	90                   	nop
}
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    

0080164d <sys_rcr2>:
uint32 sys_rcr2()
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 1e                	push   $0x1e
  80165c:	e8 64 fc ff ff       	call   8012c5 <syscall>
  801661:	83 c4 18             	add    $0x18,%esp
}
  801664:	c9                   	leave  
  801665:	c3                   	ret    

00801666 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	83 ec 04             	sub    $0x4,%esp
  80166c:	8b 45 08             	mov    0x8(%ebp),%eax
  80166f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801672:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	50                   	push   %eax
  80167f:	6a 1f                	push   $0x1f
  801681:	e8 3f fc ff ff       	call   8012c5 <syscall>
  801686:	83 c4 18             	add    $0x18,%esp
	return ;
  801689:	90                   	nop
}
  80168a:	c9                   	leave  
  80168b:	c3                   	ret    

0080168c <rsttst>:
void rsttst()
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 21                	push   $0x21
  80169b:	e8 25 fc ff ff       	call   8012c5 <syscall>
  8016a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8016a3:	90                   	nop
}
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	83 ec 04             	sub    $0x4,%esp
  8016ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8016af:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016b2:	8b 55 18             	mov    0x18(%ebp),%edx
  8016b5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016b9:	52                   	push   %edx
  8016ba:	50                   	push   %eax
  8016bb:	ff 75 10             	pushl  0x10(%ebp)
  8016be:	ff 75 0c             	pushl  0xc(%ebp)
  8016c1:	ff 75 08             	pushl  0x8(%ebp)
  8016c4:	6a 20                	push   $0x20
  8016c6:	e8 fa fb ff ff       	call   8012c5 <syscall>
  8016cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ce:	90                   	nop
}
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <chktst>:
void chktst(uint32 n)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	ff 75 08             	pushl  0x8(%ebp)
  8016df:	6a 22                	push   $0x22
  8016e1:	e8 df fb ff ff       	call   8012c5 <syscall>
  8016e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e9:	90                   	nop
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <inctst>:

void inctst()
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 23                	push   $0x23
  8016fb:	e8 c5 fb ff ff       	call   8012c5 <syscall>
  801700:	83 c4 18             	add    $0x18,%esp
	return ;
  801703:	90                   	nop
}
  801704:	c9                   	leave  
  801705:	c3                   	ret    

00801706 <gettst>:
uint32 gettst()
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 24                	push   $0x24
  801715:	e8 ab fb ff ff       	call   8012c5 <syscall>
  80171a:	83 c4 18             	add    $0x18,%esp
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 25                	push   $0x25
  801731:	e8 8f fb ff ff       	call   8012c5 <syscall>
  801736:	83 c4 18             	add    $0x18,%esp
  801739:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80173c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801740:	75 07                	jne    801749 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801742:	b8 01 00 00 00       	mov    $0x1,%eax
  801747:	eb 05                	jmp    80174e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801749:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 25                	push   $0x25
  801762:	e8 5e fb ff ff       	call   8012c5 <syscall>
  801767:	83 c4 18             	add    $0x18,%esp
  80176a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80176d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801771:	75 07                	jne    80177a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801773:	b8 01 00 00 00       	mov    $0x1,%eax
  801778:	eb 05                	jmp    80177f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80177a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 25                	push   $0x25
  801793:	e8 2d fb ff ff       	call   8012c5 <syscall>
  801798:	83 c4 18             	add    $0x18,%esp
  80179b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80179e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017a2:	75 07                	jne    8017ab <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017a4:	b8 01 00 00 00       	mov    $0x1,%eax
  8017a9:	eb 05                	jmp    8017b0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 25                	push   $0x25
  8017c4:	e8 fc fa ff ff       	call   8012c5 <syscall>
  8017c9:	83 c4 18             	add    $0x18,%esp
  8017cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017cf:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017d3:	75 07                	jne    8017dc <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8017da:	eb 05                	jmp    8017e1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	ff 75 08             	pushl  0x8(%ebp)
  8017f1:	6a 26                	push   $0x26
  8017f3:	e8 cd fa ff ff       	call   8012c5 <syscall>
  8017f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8017fb:	90                   	nop
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801802:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801805:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801808:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	6a 00                	push   $0x0
  801810:	53                   	push   %ebx
  801811:	51                   	push   %ecx
  801812:	52                   	push   %edx
  801813:	50                   	push   %eax
  801814:	6a 27                	push   $0x27
  801816:	e8 aa fa ff ff       	call   8012c5 <syscall>
  80181b:	83 c4 18             	add    $0x18,%esp
}
  80181e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801826:	8b 55 0c             	mov    0xc(%ebp),%edx
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	52                   	push   %edx
  801833:	50                   	push   %eax
  801834:	6a 28                	push   $0x28
  801836:	e8 8a fa ff ff       	call   8012c5 <syscall>
  80183b:	83 c4 18             	add    $0x18,%esp
}
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801843:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801846:	8b 55 0c             	mov    0xc(%ebp),%edx
  801849:	8b 45 08             	mov    0x8(%ebp),%eax
  80184c:	6a 00                	push   $0x0
  80184e:	51                   	push   %ecx
  80184f:	ff 75 10             	pushl  0x10(%ebp)
  801852:	52                   	push   %edx
  801853:	50                   	push   %eax
  801854:	6a 29                	push   $0x29
  801856:	e8 6a fa ff ff       	call   8012c5 <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	ff 75 10             	pushl  0x10(%ebp)
  80186a:	ff 75 0c             	pushl  0xc(%ebp)
  80186d:	ff 75 08             	pushl  0x8(%ebp)
  801870:	6a 12                	push   $0x12
  801872:	e8 4e fa ff ff       	call   8012c5 <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
	return ;
  80187a:	90                   	nop
}
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801880:	8b 55 0c             	mov    0xc(%ebp),%edx
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	52                   	push   %edx
  80188d:	50                   	push   %eax
  80188e:	6a 2a                	push   $0x2a
  801890:	e8 30 fa ff ff       	call   8012c5 <syscall>
  801895:	83 c4 18             	add    $0x18,%esp
	return;
  801898:	90                   	nop
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	50                   	push   %eax
  8018aa:	6a 2b                	push   $0x2b
  8018ac:	e8 14 fa ff ff       	call   8012c5 <syscall>
  8018b1:	83 c4 18             	add    $0x18,%esp
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	ff 75 0c             	pushl  0xc(%ebp)
  8018c2:	ff 75 08             	pushl  0x8(%ebp)
  8018c5:	6a 2c                	push   $0x2c
  8018c7:	e8 f9 f9 ff ff       	call   8012c5 <syscall>
  8018cc:	83 c4 18             	add    $0x18,%esp
	return;
  8018cf:	90                   	nop
}
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	ff 75 0c             	pushl  0xc(%ebp)
  8018de:	ff 75 08             	pushl  0x8(%ebp)
  8018e1:	6a 2d                	push   $0x2d
  8018e3:	e8 dd f9 ff ff       	call   8012c5 <syscall>
  8018e8:	83 c4 18             	add    $0x18,%esp
	return;
  8018eb:	90                   	nop
}
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    

008018ee <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  8018f4:	83 ec 04             	sub    $0x4,%esp
  8018f7:	68 f8 21 80 00       	push   $0x8021f8
  8018fc:	6a 09                	push   $0x9
  8018fe:	68 20 22 80 00       	push   $0x802220
  801903:	e8 66 e9 ff ff       	call   80026e <_panic>

00801908 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
  80190b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  80190e:	83 ec 04             	sub    $0x4,%esp
  801911:	68 30 22 80 00       	push   $0x802230
  801916:	6a 10                	push   $0x10
  801918:	68 20 22 80 00       	push   $0x802220
  80191d:	e8 4c e9 ff ff       	call   80026e <_panic>

00801922 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
  801925:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  801928:	83 ec 04             	sub    $0x4,%esp
  80192b:	68 58 22 80 00       	push   $0x802258
  801930:	6a 18                	push   $0x18
  801932:	68 20 22 80 00       	push   $0x802220
  801937:	e8 32 e9 ff ff       	call   80026e <_panic>

0080193c <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  801942:	83 ec 04             	sub    $0x4,%esp
  801945:	68 80 22 80 00       	push   $0x802280
  80194a:	6a 20                	push   $0x20
  80194c:	68 20 22 80 00       	push   $0x802220
  801951:	e8 18 e9 ff ff       	call   80026e <_panic>

00801956 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	8b 40 10             	mov    0x10(%eax),%eax
}
  80195f:	5d                   	pop    %ebp
  801960:	c3                   	ret    
  801961:	66 90                	xchg   %ax,%ax
  801963:	90                   	nop

00801964 <__udivdi3>:
  801964:	55                   	push   %ebp
  801965:	57                   	push   %edi
  801966:	56                   	push   %esi
  801967:	53                   	push   %ebx
  801968:	83 ec 1c             	sub    $0x1c,%esp
  80196b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80196f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801973:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801977:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80197b:	89 ca                	mov    %ecx,%edx
  80197d:	89 f8                	mov    %edi,%eax
  80197f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801983:	85 f6                	test   %esi,%esi
  801985:	75 2d                	jne    8019b4 <__udivdi3+0x50>
  801987:	39 cf                	cmp    %ecx,%edi
  801989:	77 65                	ja     8019f0 <__udivdi3+0x8c>
  80198b:	89 fd                	mov    %edi,%ebp
  80198d:	85 ff                	test   %edi,%edi
  80198f:	75 0b                	jne    80199c <__udivdi3+0x38>
  801991:	b8 01 00 00 00       	mov    $0x1,%eax
  801996:	31 d2                	xor    %edx,%edx
  801998:	f7 f7                	div    %edi
  80199a:	89 c5                	mov    %eax,%ebp
  80199c:	31 d2                	xor    %edx,%edx
  80199e:	89 c8                	mov    %ecx,%eax
  8019a0:	f7 f5                	div    %ebp
  8019a2:	89 c1                	mov    %eax,%ecx
  8019a4:	89 d8                	mov    %ebx,%eax
  8019a6:	f7 f5                	div    %ebp
  8019a8:	89 cf                	mov    %ecx,%edi
  8019aa:	89 fa                	mov    %edi,%edx
  8019ac:	83 c4 1c             	add    $0x1c,%esp
  8019af:	5b                   	pop    %ebx
  8019b0:	5e                   	pop    %esi
  8019b1:	5f                   	pop    %edi
  8019b2:	5d                   	pop    %ebp
  8019b3:	c3                   	ret    
  8019b4:	39 ce                	cmp    %ecx,%esi
  8019b6:	77 28                	ja     8019e0 <__udivdi3+0x7c>
  8019b8:	0f bd fe             	bsr    %esi,%edi
  8019bb:	83 f7 1f             	xor    $0x1f,%edi
  8019be:	75 40                	jne    801a00 <__udivdi3+0x9c>
  8019c0:	39 ce                	cmp    %ecx,%esi
  8019c2:	72 0a                	jb     8019ce <__udivdi3+0x6a>
  8019c4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019c8:	0f 87 9e 00 00 00    	ja     801a6c <__udivdi3+0x108>
  8019ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8019d3:	89 fa                	mov    %edi,%edx
  8019d5:	83 c4 1c             	add    $0x1c,%esp
  8019d8:	5b                   	pop    %ebx
  8019d9:	5e                   	pop    %esi
  8019da:	5f                   	pop    %edi
  8019db:	5d                   	pop    %ebp
  8019dc:	c3                   	ret    
  8019dd:	8d 76 00             	lea    0x0(%esi),%esi
  8019e0:	31 ff                	xor    %edi,%edi
  8019e2:	31 c0                	xor    %eax,%eax
  8019e4:	89 fa                	mov    %edi,%edx
  8019e6:	83 c4 1c             	add    $0x1c,%esp
  8019e9:	5b                   	pop    %ebx
  8019ea:	5e                   	pop    %esi
  8019eb:	5f                   	pop    %edi
  8019ec:	5d                   	pop    %ebp
  8019ed:	c3                   	ret    
  8019ee:	66 90                	xchg   %ax,%ax
  8019f0:	89 d8                	mov    %ebx,%eax
  8019f2:	f7 f7                	div    %edi
  8019f4:	31 ff                	xor    %edi,%edi
  8019f6:	89 fa                	mov    %edi,%edx
  8019f8:	83 c4 1c             	add    $0x1c,%esp
  8019fb:	5b                   	pop    %ebx
  8019fc:	5e                   	pop    %esi
  8019fd:	5f                   	pop    %edi
  8019fe:	5d                   	pop    %ebp
  8019ff:	c3                   	ret    
  801a00:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a05:	89 eb                	mov    %ebp,%ebx
  801a07:	29 fb                	sub    %edi,%ebx
  801a09:	89 f9                	mov    %edi,%ecx
  801a0b:	d3 e6                	shl    %cl,%esi
  801a0d:	89 c5                	mov    %eax,%ebp
  801a0f:	88 d9                	mov    %bl,%cl
  801a11:	d3 ed                	shr    %cl,%ebp
  801a13:	89 e9                	mov    %ebp,%ecx
  801a15:	09 f1                	or     %esi,%ecx
  801a17:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a1b:	89 f9                	mov    %edi,%ecx
  801a1d:	d3 e0                	shl    %cl,%eax
  801a1f:	89 c5                	mov    %eax,%ebp
  801a21:	89 d6                	mov    %edx,%esi
  801a23:	88 d9                	mov    %bl,%cl
  801a25:	d3 ee                	shr    %cl,%esi
  801a27:	89 f9                	mov    %edi,%ecx
  801a29:	d3 e2                	shl    %cl,%edx
  801a2b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a2f:	88 d9                	mov    %bl,%cl
  801a31:	d3 e8                	shr    %cl,%eax
  801a33:	09 c2                	or     %eax,%edx
  801a35:	89 d0                	mov    %edx,%eax
  801a37:	89 f2                	mov    %esi,%edx
  801a39:	f7 74 24 0c          	divl   0xc(%esp)
  801a3d:	89 d6                	mov    %edx,%esi
  801a3f:	89 c3                	mov    %eax,%ebx
  801a41:	f7 e5                	mul    %ebp
  801a43:	39 d6                	cmp    %edx,%esi
  801a45:	72 19                	jb     801a60 <__udivdi3+0xfc>
  801a47:	74 0b                	je     801a54 <__udivdi3+0xf0>
  801a49:	89 d8                	mov    %ebx,%eax
  801a4b:	31 ff                	xor    %edi,%edi
  801a4d:	e9 58 ff ff ff       	jmp    8019aa <__udivdi3+0x46>
  801a52:	66 90                	xchg   %ax,%ax
  801a54:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a58:	89 f9                	mov    %edi,%ecx
  801a5a:	d3 e2                	shl    %cl,%edx
  801a5c:	39 c2                	cmp    %eax,%edx
  801a5e:	73 e9                	jae    801a49 <__udivdi3+0xe5>
  801a60:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a63:	31 ff                	xor    %edi,%edi
  801a65:	e9 40 ff ff ff       	jmp    8019aa <__udivdi3+0x46>
  801a6a:	66 90                	xchg   %ax,%ax
  801a6c:	31 c0                	xor    %eax,%eax
  801a6e:	e9 37 ff ff ff       	jmp    8019aa <__udivdi3+0x46>
  801a73:	90                   	nop

00801a74 <__umoddi3>:
  801a74:	55                   	push   %ebp
  801a75:	57                   	push   %edi
  801a76:	56                   	push   %esi
  801a77:	53                   	push   %ebx
  801a78:	83 ec 1c             	sub    $0x1c,%esp
  801a7b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a87:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a8b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a93:	89 f3                	mov    %esi,%ebx
  801a95:	89 fa                	mov    %edi,%edx
  801a97:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a9b:	89 34 24             	mov    %esi,(%esp)
  801a9e:	85 c0                	test   %eax,%eax
  801aa0:	75 1a                	jne    801abc <__umoddi3+0x48>
  801aa2:	39 f7                	cmp    %esi,%edi
  801aa4:	0f 86 a2 00 00 00    	jbe    801b4c <__umoddi3+0xd8>
  801aaa:	89 c8                	mov    %ecx,%eax
  801aac:	89 f2                	mov    %esi,%edx
  801aae:	f7 f7                	div    %edi
  801ab0:	89 d0                	mov    %edx,%eax
  801ab2:	31 d2                	xor    %edx,%edx
  801ab4:	83 c4 1c             	add    $0x1c,%esp
  801ab7:	5b                   	pop    %ebx
  801ab8:	5e                   	pop    %esi
  801ab9:	5f                   	pop    %edi
  801aba:	5d                   	pop    %ebp
  801abb:	c3                   	ret    
  801abc:	39 f0                	cmp    %esi,%eax
  801abe:	0f 87 ac 00 00 00    	ja     801b70 <__umoddi3+0xfc>
  801ac4:	0f bd e8             	bsr    %eax,%ebp
  801ac7:	83 f5 1f             	xor    $0x1f,%ebp
  801aca:	0f 84 ac 00 00 00    	je     801b7c <__umoddi3+0x108>
  801ad0:	bf 20 00 00 00       	mov    $0x20,%edi
  801ad5:	29 ef                	sub    %ebp,%edi
  801ad7:	89 fe                	mov    %edi,%esi
  801ad9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801add:	89 e9                	mov    %ebp,%ecx
  801adf:	d3 e0                	shl    %cl,%eax
  801ae1:	89 d7                	mov    %edx,%edi
  801ae3:	89 f1                	mov    %esi,%ecx
  801ae5:	d3 ef                	shr    %cl,%edi
  801ae7:	09 c7                	or     %eax,%edi
  801ae9:	89 e9                	mov    %ebp,%ecx
  801aeb:	d3 e2                	shl    %cl,%edx
  801aed:	89 14 24             	mov    %edx,(%esp)
  801af0:	89 d8                	mov    %ebx,%eax
  801af2:	d3 e0                	shl    %cl,%eax
  801af4:	89 c2                	mov    %eax,%edx
  801af6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801afa:	d3 e0                	shl    %cl,%eax
  801afc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b00:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b04:	89 f1                	mov    %esi,%ecx
  801b06:	d3 e8                	shr    %cl,%eax
  801b08:	09 d0                	or     %edx,%eax
  801b0a:	d3 eb                	shr    %cl,%ebx
  801b0c:	89 da                	mov    %ebx,%edx
  801b0e:	f7 f7                	div    %edi
  801b10:	89 d3                	mov    %edx,%ebx
  801b12:	f7 24 24             	mull   (%esp)
  801b15:	89 c6                	mov    %eax,%esi
  801b17:	89 d1                	mov    %edx,%ecx
  801b19:	39 d3                	cmp    %edx,%ebx
  801b1b:	0f 82 87 00 00 00    	jb     801ba8 <__umoddi3+0x134>
  801b21:	0f 84 91 00 00 00    	je     801bb8 <__umoddi3+0x144>
  801b27:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b2b:	29 f2                	sub    %esi,%edx
  801b2d:	19 cb                	sbb    %ecx,%ebx
  801b2f:	89 d8                	mov    %ebx,%eax
  801b31:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b35:	d3 e0                	shl    %cl,%eax
  801b37:	89 e9                	mov    %ebp,%ecx
  801b39:	d3 ea                	shr    %cl,%edx
  801b3b:	09 d0                	or     %edx,%eax
  801b3d:	89 e9                	mov    %ebp,%ecx
  801b3f:	d3 eb                	shr    %cl,%ebx
  801b41:	89 da                	mov    %ebx,%edx
  801b43:	83 c4 1c             	add    $0x1c,%esp
  801b46:	5b                   	pop    %ebx
  801b47:	5e                   	pop    %esi
  801b48:	5f                   	pop    %edi
  801b49:	5d                   	pop    %ebp
  801b4a:	c3                   	ret    
  801b4b:	90                   	nop
  801b4c:	89 fd                	mov    %edi,%ebp
  801b4e:	85 ff                	test   %edi,%edi
  801b50:	75 0b                	jne    801b5d <__umoddi3+0xe9>
  801b52:	b8 01 00 00 00       	mov    $0x1,%eax
  801b57:	31 d2                	xor    %edx,%edx
  801b59:	f7 f7                	div    %edi
  801b5b:	89 c5                	mov    %eax,%ebp
  801b5d:	89 f0                	mov    %esi,%eax
  801b5f:	31 d2                	xor    %edx,%edx
  801b61:	f7 f5                	div    %ebp
  801b63:	89 c8                	mov    %ecx,%eax
  801b65:	f7 f5                	div    %ebp
  801b67:	89 d0                	mov    %edx,%eax
  801b69:	e9 44 ff ff ff       	jmp    801ab2 <__umoddi3+0x3e>
  801b6e:	66 90                	xchg   %ax,%ax
  801b70:	89 c8                	mov    %ecx,%eax
  801b72:	89 f2                	mov    %esi,%edx
  801b74:	83 c4 1c             	add    $0x1c,%esp
  801b77:	5b                   	pop    %ebx
  801b78:	5e                   	pop    %esi
  801b79:	5f                   	pop    %edi
  801b7a:	5d                   	pop    %ebp
  801b7b:	c3                   	ret    
  801b7c:	3b 04 24             	cmp    (%esp),%eax
  801b7f:	72 06                	jb     801b87 <__umoddi3+0x113>
  801b81:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b85:	77 0f                	ja     801b96 <__umoddi3+0x122>
  801b87:	89 f2                	mov    %esi,%edx
  801b89:	29 f9                	sub    %edi,%ecx
  801b8b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b8f:	89 14 24             	mov    %edx,(%esp)
  801b92:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b96:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b9a:	8b 14 24             	mov    (%esp),%edx
  801b9d:	83 c4 1c             	add    $0x1c,%esp
  801ba0:	5b                   	pop    %ebx
  801ba1:	5e                   	pop    %esi
  801ba2:	5f                   	pop    %edi
  801ba3:	5d                   	pop    %ebp
  801ba4:	c3                   	ret    
  801ba5:	8d 76 00             	lea    0x0(%esi),%esi
  801ba8:	2b 04 24             	sub    (%esp),%eax
  801bab:	19 fa                	sbb    %edi,%edx
  801bad:	89 d1                	mov    %edx,%ecx
  801baf:	89 c6                	mov    %eax,%esi
  801bb1:	e9 71 ff ff ff       	jmp    801b27 <__umoddi3+0xb3>
  801bb6:	66 90                	xchg   %ax,%ax
  801bb8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bbc:	72 ea                	jb     801ba8 <__umoddi3+0x134>
  801bbe:	89 d9                	mov    %ebx,%ecx
  801bc0:	e9 62 ff ff ff       	jmp    801b27 <__umoddi3+0xb3>
