
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
  800049:	68 60 3d 80 00       	push   $0x803d60
  80004e:	e8 6a 14 00 00       	call   8014bd <sys_createSharedObject>
  800053:	83 c4 10             	add    $0x10,%esp

	struct semaphore cnc1 = create_semaphore("cnc1", 1);
  800056:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	6a 01                	push   $0x1
  80005e:	68 60 3d 80 00       	push   $0x803d60
  800063:	50                   	push   %eax
  800064:	e8 21 19 00 00       	call   80198a <create_semaphore>
  800069:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = create_semaphore("depend1", 0);
  80006c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80006f:	83 ec 04             	sub    $0x4,%esp
  800072:	6a 00                	push   $0x0
  800074:	68 65 3d 80 00       	push   $0x803d65
  800079:	50                   	push   %eax
  80007a:	e8 0b 19 00 00       	call   80198a <create_semaphore>
  80007f:	83 c4 0c             	add    $0xc,%esp

	uint32 id1, id2;
	id2 = sys_create_env("qs2", (myEnv->page_WS_max_size), (myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800082:	a1 20 50 80 00       	mov    0x805020,%eax
  800087:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  80008d:	a1 20 50 80 00       	mov    0x805020,%eax
  800092:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800098:	89 c1                	mov    %eax,%ecx
  80009a:	a1 20 50 80 00       	mov    0x805020,%eax
  80009f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000a5:	52                   	push   %edx
  8000a6:	51                   	push   %ecx
  8000a7:	50                   	push   %eax
  8000a8:	68 6d 3d 80 00       	push   $0x803d6d
  8000ad:	e8 8e 14 00 00       	call   801540 <sys_create_env>
  8000b2:	83 c4 10             	add    $0x10,%esp
  8000b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	id1 = sys_create_env("qs1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8000bd:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  8000c3:	a1 20 50 80 00       	mov    0x805020,%eax
  8000c8:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8000ce:	89 c1                	mov    %eax,%ecx
  8000d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8000d5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000db:	52                   	push   %edx
  8000dc:	51                   	push   %ecx
  8000dd:	50                   	push   %eax
  8000de:	68 71 3d 80 00       	push   $0x803d71
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
  8000fd:	68 75 3d 80 00       	push   $0x803d75
  800102:	6a 11                	push   $0x11
  800104:	68 8a 3d 80 00       	push   $0x803d8a
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
  800164:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800169:	a1 20 50 80 00       	mov    0x805020,%eax
  80016e:	8a 40 20             	mov    0x20(%eax),%al
  800171:	84 c0                	test   %al,%al
  800173:	74 0d                	je     800182 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800175:	a1 20 50 80 00       	mov    0x805020,%eax
  80017a:	83 c0 20             	add    $0x20,%eax
  80017d:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800182:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800186:	7e 0a                	jle    800192 <libmain+0x63>
		binaryname = argv[0];
  800188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018b:	8b 00                	mov    (%eax),%eax
  80018d:	a3 00 50 80 00       	mov    %eax,0x805000

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
  8001ab:	68 bc 3d 80 00       	push   $0x803dbc
  8001b0:	e8 76 03 00 00       	call   80052b <cprintf>
  8001b5:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8001bd:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8001c3:	a1 20 50 80 00       	mov    0x805020,%eax
  8001c8:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	52                   	push   %edx
  8001d2:	50                   	push   %eax
  8001d3:	68 e4 3d 80 00       	push   $0x803de4
  8001d8:	e8 4e 03 00 00       	call   80052b <cprintf>
  8001dd:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e0:	a1 20 50 80 00       	mov    0x805020,%eax
  8001e5:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8001eb:	a1 20 50 80 00       	mov    0x805020,%eax
  8001f0:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8001f6:	a1 20 50 80 00       	mov    0x805020,%eax
  8001fb:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800201:	51                   	push   %ecx
  800202:	52                   	push   %edx
  800203:	50                   	push   %eax
  800204:	68 0c 3e 80 00       	push   $0x803e0c
  800209:	e8 1d 03 00 00       	call   80052b <cprintf>
  80020e:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800211:	a1 20 50 80 00       	mov    0x805020,%eax
  800216:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80021c:	83 ec 08             	sub    $0x8,%esp
  80021f:	50                   	push   %eax
  800220:	68 64 3e 80 00       	push   $0x803e64
  800225:	e8 01 03 00 00       	call   80052b <cprintf>
  80022a:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	68 bc 3d 80 00       	push   $0x803dbc
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
  80027d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800282:	85 c0                	test   %eax,%eax
  800284:	74 16                	je     80029c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800286:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80028b:	83 ec 08             	sub    $0x8,%esp
  80028e:	50                   	push   %eax
  80028f:	68 78 3e 80 00       	push   $0x803e78
  800294:	e8 92 02 00 00       	call   80052b <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80029c:	a1 00 50 80 00       	mov    0x805000,%eax
  8002a1:	ff 75 0c             	pushl  0xc(%ebp)
  8002a4:	ff 75 08             	pushl  0x8(%ebp)
  8002a7:	50                   	push   %eax
  8002a8:	68 7d 3e 80 00       	push   $0x803e7d
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
  8002cc:	68 99 3e 80 00       	push   $0x803e99
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
  8002e6:	a1 20 50 80 00       	mov    0x805020,%eax
  8002eb:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8002f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f4:	39 c2                	cmp    %eax,%edx
  8002f6:	74 14                	je     80030c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002f8:	83 ec 04             	sub    $0x4,%esp
  8002fb:	68 9c 3e 80 00       	push   $0x803e9c
  800300:	6a 26                	push   $0x26
  800302:	68 e8 3e 80 00       	push   $0x803ee8
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
  80034c:	a1 20 50 80 00       	mov    0x805020,%eax
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
  80036c:	a1 20 50 80 00       	mov    0x805020,%eax
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
  8003b5:	a1 20 50 80 00       	mov    0x805020,%eax
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
  8003d0:	68 f4 3e 80 00       	push   $0x803ef4
  8003d5:	6a 3a                	push   $0x3a
  8003d7:	68 e8 3e 80 00       	push   $0x803ee8
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
  800400:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800426:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800443:	68 48 3f 80 00       	push   $0x803f48
  800448:	6a 44                	push   $0x44
  80044a:	68 e8 3e 80 00       	push   $0x803ee8
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
  800482:	a0 28 50 80 00       	mov    0x805028,%al
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
  8004f7:	a0 28 50 80 00       	mov    0x805028,%al
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
  80051c:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
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
  800531:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
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
  8005c8:	e8 17 35 00 00       	call   803ae4 <__udivdi3>
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
  800618:	e8 d7 35 00 00       	call   803bf4 <__umoddi3>
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	05 b4 41 80 00       	add    $0x8041b4,%eax
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
  800773:	8b 04 85 d8 41 80 00 	mov    0x8041d8(,%eax,4),%eax
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
  800854:	8b 34 9d 20 40 80 00 	mov    0x804020(,%ebx,4),%esi
  80085b:	85 f6                	test   %esi,%esi
  80085d:	75 19                	jne    800878 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80085f:	53                   	push   %ebx
  800860:	68 c5 41 80 00       	push   $0x8041c5
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
  800879:	68 ce 41 80 00       	push   $0x8041ce
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
  8008a6:	be d1 41 80 00       	mov    $0x8041d1,%esi
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
  800a9e:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800aa5:	eb 2c                	jmp    800ad3 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800aa7:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
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
  8012b1:	68 48 43 80 00       	push   $0x804348
  8012b6:	68 3f 01 00 00       	push   $0x13f
  8012bb:	68 6a 43 80 00       	push   $0x80436a
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

008018ee <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 2e                	push   $0x2e
  801900:	e8 c0 f9 ff ff       	call   8012c5 <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
  801908:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  80190b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	50                   	push   %eax
  80191f:	6a 2f                	push   $0x2f
  801921:	e8 9f f9 ff ff       	call   8012c5 <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
	return;
  801929:	90                   	nop
}
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  80192f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	52                   	push   %edx
  80193c:	50                   	push   %eax
  80193d:	6a 30                	push   $0x30
  80193f:	e8 81 f9 ff ff       	call   8012c5 <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
	return;
  801947:	90                   	nop
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	50                   	push   %eax
  80195c:	6a 31                	push   $0x31
  80195e:	e8 62 f9 ff ff       	call   8012c5 <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
  801966:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801969:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  801971:	8b 45 08             	mov    0x8(%ebp),%eax
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	50                   	push   %eax
  80197d:	6a 32                	push   $0x32
  80197f:	e8 41 f9 ff ff       	call   8012c5 <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
	return;
  801987:	90                   	nop
}
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
  80198d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("create_semaphore is not implemented yet");
	//Your Code is Here...

		void* ret = smalloc(semaphoreName, sizeof(struct semaphore), 1);
  801990:	83 ec 04             	sub    $0x4,%esp
  801993:	6a 01                	push   $0x1
  801995:	6a 04                	push   $0x4
  801997:	ff 75 0c             	pushl  0xc(%ebp)
  80199a:	e8 dd 04 00 00       	call   801e7c <smalloc>
  80199f:	83 c4 10             	add    $0x10,%esp
  8019a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if (ret == NULL ) panic("no memory in creat_semaphore");
  8019a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019a9:	75 14                	jne    8019bf <create_semaphore+0x35>
  8019ab:	83 ec 04             	sub    $0x4,%esp
  8019ae:	68 77 43 80 00       	push   $0x804377
  8019b3:	6a 0d                	push   $0xd
  8019b5:	68 94 43 80 00       	push   $0x804394
  8019ba:	e8 af e8 ff ff       	call   80026e <_panic>

	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  8019bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c2:	89 45 f0             	mov    %eax,-0x10(%ebp)

	    sem_ptr->semdata->count = value;
  8019c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c8:	8b 00                	mov    (%eax),%eax
  8019ca:	8b 55 10             	mov    0x10(%ebp),%edx
  8019cd:	89 50 10             	mov    %edx,0x10(%eax)
	    sys_init_queue(&(sem_ptr->semdata->queue));
  8019d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d3:	8b 00                	mov    (%eax),%eax
  8019d5:	83 ec 0c             	sub    $0xc,%esp
  8019d8:	50                   	push   %eax
  8019d9:	e8 32 ff ff ff       	call   801910 <sys_init_queue>
  8019de:	83 c4 10             	add    $0x10,%esp

	    sem_ptr->semdata->lock = 0;
  8019e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e4:	8b 00                	mov    (%eax),%eax
  8019e6:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

	    return *sem_ptr;
  8019ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019f3:	8b 12                	mov    (%edx),%edx
  8019f5:	89 10                	mov    %edx,(%eax)
}
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	c9                   	leave  
  8019fb:	c2 04 00             	ret    $0x4

008019fe <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("get_semaphore is not implemented yet");
	//Your Code is Here...
		void* ret = sget(ownerEnvID, semaphoreName);
  801a04:	83 ec 08             	sub    $0x8,%esp
  801a07:	ff 75 10             	pushl  0x10(%ebp)
  801a0a:	ff 75 0c             	pushl  0xc(%ebp)
  801a0d:	e8 0f 05 00 00       	call   801f21 <sget>
  801a12:	83 c4 10             	add    $0x10,%esp
  801a15:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (ret == NULL ) panic("no semaphore in get_semaphore");
  801a18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a1c:	75 14                	jne    801a32 <get_semaphore+0x34>
  801a1e:	83 ec 04             	sub    $0x4,%esp
  801a21:	68 a4 43 80 00       	push   $0x8043a4
  801a26:	6a 1f                	push   $0x1f
  801a28:	68 94 43 80 00       	push   $0x804394
  801a2d:	e8 3c e8 ff ff       	call   80026e <_panic>
	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  801a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a35:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    return *sem_ptr;
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a3e:	8b 12                	mov    (%edx),%edx
  801a40:	89 10                	mov    %edx,(%eax)
}
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	c9                   	leave  
  801a46:	c2 04 00             	ret    $0x4

00801a49 <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
  801a4c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("wait_semaphore is not implemented yet");
	//Your Code is Here...
			uint32 key = 1;
  801a4f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
		    do { xchg(&sem.semdata->lock,key); } while (key != 0);
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	83 c0 14             	add    $0x14,%eax
  801a5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a62:	89 45 e8             	mov    %eax,-0x18(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  801a65:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a6b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  801a6e:	f0 87 02             	lock xchg %eax,(%edx)
  801a71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a78:	75 dc                	jne    801a56 <wait_semaphore+0xd>

		    sem.semdata->count--;
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	8b 50 10             	mov    0x10(%eax),%edx
  801a80:	4a                   	dec    %edx
  801a81:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count < 0) {
  801a84:	8b 45 08             	mov    0x8(%ebp),%eax
  801a87:	8b 40 10             	mov    0x10(%eax),%eax
  801a8a:	85 c0                	test   %eax,%eax
  801a8c:	79 30                	jns    801abe <wait_semaphore+0x75>

	    	struct Env* cur_env = sys_get_cpu_process();
  801a8e:	e8 5b fe ff ff       	call   8018ee <sys_get_cpu_process>
  801a93:	89 45 f0             	mov    %eax,-0x10(%ebp)

//	    	acquire_spinlock(&ProcessQueues.qlock); //acquire procque
	        sys_enqueue(&(sem.semdata->queue),cur_env);  // Add process to waiting queue
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	83 ec 08             	sub    $0x8,%esp
  801a9c:	ff 75 f0             	pushl  -0x10(%ebp)
  801a9f:	50                   	push   %eax
  801aa0:	e8 87 fe ff ff       	call   80192c <sys_enqueue>
  801aa5:	83 c4 10             	add    $0x10,%esp
	        cur_env->env_status= ENV_BLOCKED;
  801aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aab:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%eax)
	        sem.semdata->lock = 0;
  801ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab5:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;

}
  801abc:	eb 0a                	jmp    801ac8 <wait_semaphore+0x7f>
	        cur_env->env_status= ENV_BLOCKED;
	        sem.semdata->lock = 0;
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

}
  801ac8:	90                   	nop
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("signal_semaphore is not implemented yet");
	//Your Code is Here...
		uint32 key = 1;
  801ad1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	    do { xchg(&sem.semdata->lock,key ); } while (key != 0);
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	83 c0 14             	add    $0x14,%eax
  801ade:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801ae7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801aea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801aed:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  801af0:	f0 87 02             	lock xchg %eax,(%edx)
  801af3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801af6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801afa:	75 dc                	jne    801ad8 <signal_semaphore+0xd>
	    sem.semdata->count++;
  801afc:	8b 45 08             	mov    0x8(%ebp),%eax
  801aff:	8b 50 10             	mov    0x10(%eax),%edx
  801b02:	42                   	inc    %edx
  801b03:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count <= 0) {
  801b06:	8b 45 08             	mov    0x8(%ebp),%eax
  801b09:	8b 40 10             	mov    0x10(%eax),%eax
  801b0c:	85 c0                	test   %eax,%eax
  801b0e:	7f 20                	jg     801b30 <signal_semaphore+0x65>
	        struct Env* env = sys_dequeue(&(sem.semdata->queue)) ;
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	83 ec 0c             	sub    $0xc,%esp
  801b16:	50                   	push   %eax
  801b17:	e8 2e fe ff ff       	call   80194a <sys_dequeue>
  801b1c:	83 c4 10             	add    $0x10,%esp
  801b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	        sys_sched_insert_ready(env);
  801b22:	83 ec 0c             	sub    $0xc,%esp
  801b25:	ff 75 f0             	pushl  -0x10(%ebp)
  801b28:	e8 41 fe ff ff       	call   80196e <sys_sched_insert_ready>
  801b2d:	83 c4 10             	add    $0x10,%esp
	    }
	    sem.semdata->lock = 0;
  801b30:	8b 45 08             	mov    0x8(%ebp),%eax
  801b33:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  801b3a:	90                   	nop
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801b40:	8b 45 08             	mov    0x8(%ebp),%eax
  801b43:	8b 40 10             	mov    0x10(%eax),%eax
}
  801b46:	5d                   	pop    %ebp
  801b47:	c3                   	ret    

00801b48 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
  801b4b:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801b4e:	83 ec 0c             	sub    $0xc,%esp
  801b51:	ff 75 08             	pushl  0x8(%ebp)
  801b54:	e8 42 fd ff ff       	call   80189b <sys_sbrk>
  801b59:	83 c4 10             	add    $0x10,%esp
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801b64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b68:	75 0a                	jne    801b74 <malloc+0x16>
  801b6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b6f:	e9 07 02 00 00       	jmp    801d7b <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801b74:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801b7b:	8b 55 08             	mov    0x8(%ebp),%edx
  801b7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b81:	01 d0                	add    %edx,%eax
  801b83:	48                   	dec    %eax
  801b84:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b87:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8f:	f7 75 dc             	divl   -0x24(%ebp)
  801b92:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b95:	29 d0                	sub    %edx,%eax
  801b97:	c1 e8 0c             	shr    $0xc,%eax
  801b9a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801b9d:	a1 20 50 80 00       	mov    0x805020,%eax
  801ba2:	8b 40 78             	mov    0x78(%eax),%eax
  801ba5:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801baa:	29 c2                	sub    %eax,%edx
  801bac:	89 d0                	mov    %edx,%eax
  801bae:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801bb1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801bb4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bb9:	c1 e8 0c             	shr    $0xc,%eax
  801bbc:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801bbf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801bc6:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801bcd:	77 42                	ja     801c11 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801bcf:	e8 4b fb ff ff       	call   80171f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bd4:	85 c0                	test   %eax,%eax
  801bd6:	74 16                	je     801bee <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  801bd8:	83 ec 0c             	sub    $0xc,%esp
  801bdb:	ff 75 08             	pushl  0x8(%ebp)
  801bde:	e8 18 08 00 00       	call   8023fb <alloc_block_FF>
  801be3:	83 c4 10             	add    $0x10,%esp
  801be6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801be9:	e9 8a 01 00 00       	jmp    801d78 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801bee:	e8 5d fb ff ff       	call   801750 <sys_isUHeapPlacementStrategyBESTFIT>
  801bf3:	85 c0                	test   %eax,%eax
  801bf5:	0f 84 7d 01 00 00    	je     801d78 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801bfb:	83 ec 0c             	sub    $0xc,%esp
  801bfe:	ff 75 08             	pushl  0x8(%ebp)
  801c01:	e8 b1 0c 00 00       	call   8028b7 <alloc_block_BF>
  801c06:	83 c4 10             	add    $0x10,%esp
  801c09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c0c:	e9 67 01 00 00       	jmp    801d78 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801c11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801c14:	48                   	dec    %eax
  801c15:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801c18:	0f 86 53 01 00 00    	jbe    801d71 <malloc+0x213>
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801c1e:	a1 20 50 80 00       	mov    0x805020,%eax
  801c23:	8b 40 78             	mov    0x78(%eax),%eax
  801c26:	05 00 10 00 00       	add    $0x1000,%eax
  801c2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801c2e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801c35:	e9 de 00 00 00       	jmp    801d18 <malloc+0x1ba>
		{
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801c3a:	a1 20 50 80 00       	mov    0x805020,%eax
  801c3f:	8b 40 78             	mov    0x78(%eax),%eax
  801c42:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c45:	29 c2                	sub    %eax,%edx
  801c47:	89 d0                	mov    %edx,%eax
  801c49:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c4e:	c1 e8 0c             	shr    $0xc,%eax
  801c51:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801c58:	85 c0                	test   %eax,%eax
  801c5a:	0f 85 ab 00 00 00    	jne    801d0b <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c63:	05 00 10 00 00       	add    $0x1000,%eax
  801c68:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801c6b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
				while(cnt < num_pages - 1)
  801c72:	eb 47                	jmp    801cbb <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801c74:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801c7b:	76 0a                	jbe    801c87 <malloc+0x129>
  801c7d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c82:	e9 f4 00 00 00       	jmp    801d7b <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801c87:	a1 20 50 80 00       	mov    0x805020,%eax
  801c8c:	8b 40 78             	mov    0x78(%eax),%eax
  801c8f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c92:	29 c2                	sub    %eax,%edx
  801c94:	89 d0                	mov    %edx,%eax
  801c96:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c9b:	c1 e8 0c             	shr    $0xc,%eax
  801c9e:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801ca5:	85 c0                	test   %eax,%eax
  801ca7:	74 08                	je     801cb1 <malloc+0x153>
					{
						
						i = j;
  801ca9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cac:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801caf:	eb 5a                	jmp    801d0b <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801cb1:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801cb8:	ff 45 e4             	incl   -0x1c(%ebp)
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
				while(cnt < num_pages - 1)
  801cbb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cbe:	48                   	dec    %eax
  801cbf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801cc2:	77 b0                	ja     801c74 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801cc4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801ccb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801cd2:	eb 2f                	jmp    801d03 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801cd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cd7:	c1 e0 0c             	shl    $0xc,%eax
  801cda:	89 c2                	mov    %eax,%edx
  801cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cdf:	01 c2                	add    %eax,%edx
  801ce1:	a1 20 50 80 00       	mov    0x805020,%eax
  801ce6:	8b 40 78             	mov    0x78(%eax),%eax
  801ce9:	29 c2                	sub    %eax,%edx
  801ceb:	89 d0                	mov    %edx,%eax
  801ced:	2d 00 10 00 00       	sub    $0x1000,%eax
  801cf2:	c1 e8 0c             	shr    $0xc,%eax
  801cf5:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
  801cfc:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801d00:	ff 45 e0             	incl   -0x20(%ebp)
  801d03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d06:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801d09:	72 c9                	jb     801cd4 <malloc+0x176>
				}
				

			}
			sayed:
			if(ok) break;
  801d0b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d0f:	75 16                	jne    801d27 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801d11:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801d18:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801d1f:	0f 86 15 ff ff ff    	jbe    801c3a <malloc+0xdc>
  801d25:	eb 01                	jmp    801d28 <malloc+0x1ca>
				}
				

			}
			sayed:
			if(ok) break;
  801d27:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801d28:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d2c:	75 07                	jne    801d35 <malloc+0x1d7>
  801d2e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d33:	eb 46                	jmp    801d7b <malloc+0x21d>
		ptr = (void*)i;
  801d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d38:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801d3b:	a1 20 50 80 00       	mov    0x805020,%eax
  801d40:	8b 40 78             	mov    0x78(%eax),%eax
  801d43:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d46:	29 c2                	sub    %eax,%edx
  801d48:	89 d0                	mov    %edx,%eax
  801d4a:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d4f:	c1 e8 0c             	shr    $0xc,%eax
  801d52:	89 c2                	mov    %eax,%edx
  801d54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d57:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801d5e:	83 ec 08             	sub    $0x8,%esp
  801d61:	ff 75 08             	pushl  0x8(%ebp)
  801d64:	ff 75 f0             	pushl  -0x10(%ebp)
  801d67:	e8 66 fb ff ff       	call   8018d2 <sys_allocate_user_mem>
  801d6c:	83 c4 10             	add    $0x10,%esp
  801d6f:	eb 07                	jmp    801d78 <malloc+0x21a>
		
	}
	else
	{
		return NULL;
  801d71:	b8 00 00 00 00       	mov    $0x0,%eax
  801d76:	eb 03                	jmp    801d7b <malloc+0x21d>
	}
	return ptr;
  801d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
  801d80:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801d83:	a1 20 50 80 00       	mov    0x805020,%eax
  801d88:	8b 40 78             	mov    0x78(%eax),%eax
  801d8b:	05 00 10 00 00       	add    $0x1000,%eax
  801d90:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801d93:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801d9a:	a1 20 50 80 00       	mov    0x805020,%eax
  801d9f:	8b 50 78             	mov    0x78(%eax),%edx
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	39 c2                	cmp    %eax,%edx
  801da7:	76 24                	jbe    801dcd <free+0x50>
		size = get_block_size(va);
  801da9:	83 ec 0c             	sub    $0xc,%esp
  801dac:	ff 75 08             	pushl  0x8(%ebp)
  801daf:	e8 c7 02 00 00       	call   80207b <get_block_size>
  801db4:	83 c4 10             	add    $0x10,%esp
  801db7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801dba:	83 ec 0c             	sub    $0xc,%esp
  801dbd:	ff 75 08             	pushl  0x8(%ebp)
  801dc0:	e8 d7 14 00 00       	call   80329c <free_block>
  801dc5:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801dc8:	e9 ac 00 00 00       	jmp    801e79 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801dd3:	0f 82 89 00 00 00    	jb     801e62 <free+0xe5>
  801dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddc:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801de1:	77 7f                	ja     801e62 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801de3:	8b 55 08             	mov    0x8(%ebp),%edx
  801de6:	a1 20 50 80 00       	mov    0x805020,%eax
  801deb:	8b 40 78             	mov    0x78(%eax),%eax
  801dee:	29 c2                	sub    %eax,%edx
  801df0:	89 d0                	mov    %edx,%eax
  801df2:	2d 00 10 00 00       	sub    $0x1000,%eax
  801df7:	c1 e8 0c             	shr    $0xc,%eax
  801dfa:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  801e01:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801e04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e07:	c1 e0 0c             	shl    $0xc,%eax
  801e0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801e0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e14:	eb 42                	jmp    801e58 <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e19:	c1 e0 0c             	shl    $0xc,%eax
  801e1c:	89 c2                	mov    %eax,%edx
  801e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e21:	01 c2                	add    %eax,%edx
  801e23:	a1 20 50 80 00       	mov    0x805020,%eax
  801e28:	8b 40 78             	mov    0x78(%eax),%eax
  801e2b:	29 c2                	sub    %eax,%edx
  801e2d:	89 d0                	mov    %edx,%eax
  801e2f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e34:	c1 e8 0c             	shr    $0xc,%eax
  801e37:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801e3e:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801e42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e45:	8b 45 08             	mov    0x8(%ebp),%eax
  801e48:	83 ec 08             	sub    $0x8,%esp
  801e4b:	52                   	push   %edx
  801e4c:	50                   	push   %eax
  801e4d:	e8 64 fa ff ff       	call   8018b6 <sys_free_user_mem>
  801e52:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801e55:	ff 45 f4             	incl   -0xc(%ebp)
  801e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801e5e:	72 b6                	jb     801e16 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801e60:	eb 17                	jmp    801e79 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801e62:	83 ec 04             	sub    $0x4,%esp
  801e65:	68 c4 43 80 00       	push   $0x8043c4
  801e6a:	68 87 00 00 00       	push   $0x87
  801e6f:	68 ee 43 80 00       	push   $0x8043ee
  801e74:	e8 f5 e3 ff ff       	call   80026e <_panic>
	}
}
  801e79:	90                   	nop
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
  801e7f:	83 ec 28             	sub    $0x28,%esp
  801e82:	8b 45 10             	mov    0x10(%ebp),%eax
  801e85:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801e88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e8c:	75 0a                	jne    801e98 <smalloc+0x1c>
  801e8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e93:	e9 87 00 00 00       	jmp    801f1f <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e9e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801ea5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eab:	39 d0                	cmp    %edx,%eax
  801ead:	73 02                	jae    801eb1 <smalloc+0x35>
  801eaf:	89 d0                	mov    %edx,%eax
  801eb1:	83 ec 0c             	sub    $0xc,%esp
  801eb4:	50                   	push   %eax
  801eb5:	e8 a4 fc ff ff       	call   801b5e <malloc>
  801eba:	83 c4 10             	add    $0x10,%esp
  801ebd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801ec0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ec4:	75 07                	jne    801ecd <smalloc+0x51>
  801ec6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecb:	eb 52                	jmp    801f1f <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801ecd:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801ed1:	ff 75 ec             	pushl  -0x14(%ebp)
  801ed4:	50                   	push   %eax
  801ed5:	ff 75 0c             	pushl  0xc(%ebp)
  801ed8:	ff 75 08             	pushl  0x8(%ebp)
  801edb:	e8 dd f5 ff ff       	call   8014bd <sys_createSharedObject>
  801ee0:	83 c4 10             	add    $0x10,%esp
  801ee3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801ee6:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801eea:	74 06                	je     801ef2 <smalloc+0x76>
  801eec:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801ef0:	75 07                	jne    801ef9 <smalloc+0x7d>
  801ef2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef7:	eb 26                	jmp    801f1f <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801ef9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801efc:	a1 20 50 80 00       	mov    0x805020,%eax
  801f01:	8b 40 78             	mov    0x78(%eax),%eax
  801f04:	29 c2                	sub    %eax,%edx
  801f06:	89 d0                	mov    %edx,%eax
  801f08:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f0d:	c1 e8 0c             	shr    $0xc,%eax
  801f10:	89 c2                	mov    %eax,%edx
  801f12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f15:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801f1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801f27:	83 ec 08             	sub    $0x8,%esp
  801f2a:	ff 75 0c             	pushl  0xc(%ebp)
  801f2d:	ff 75 08             	pushl  0x8(%ebp)
  801f30:	e8 b2 f5 ff ff       	call   8014e7 <sys_getSizeOfSharedObject>
  801f35:	83 c4 10             	add    $0x10,%esp
  801f38:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801f3b:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801f3f:	75 07                	jne    801f48 <sget+0x27>
  801f41:	b8 00 00 00 00       	mov    $0x0,%eax
  801f46:	eb 7f                	jmp    801fc7 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f4e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801f55:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5b:	39 d0                	cmp    %edx,%eax
  801f5d:	73 02                	jae    801f61 <sget+0x40>
  801f5f:	89 d0                	mov    %edx,%eax
  801f61:	83 ec 0c             	sub    $0xc,%esp
  801f64:	50                   	push   %eax
  801f65:	e8 f4 fb ff ff       	call   801b5e <malloc>
  801f6a:	83 c4 10             	add    $0x10,%esp
  801f6d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801f70:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f74:	75 07                	jne    801f7d <sget+0x5c>
  801f76:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7b:	eb 4a                	jmp    801fc7 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801f7d:	83 ec 04             	sub    $0x4,%esp
  801f80:	ff 75 e8             	pushl  -0x18(%ebp)
  801f83:	ff 75 0c             	pushl  0xc(%ebp)
  801f86:	ff 75 08             	pushl  0x8(%ebp)
  801f89:	e8 76 f5 ff ff       	call   801504 <sys_getSharedObject>
  801f8e:	83 c4 10             	add    $0x10,%esp
  801f91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801f94:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f97:	a1 20 50 80 00       	mov    0x805020,%eax
  801f9c:	8b 40 78             	mov    0x78(%eax),%eax
  801f9f:	29 c2                	sub    %eax,%edx
  801fa1:	89 d0                	mov    %edx,%eax
  801fa3:	2d 00 10 00 00       	sub    $0x1000,%eax
  801fa8:	c1 e8 0c             	shr    $0xc,%eax
  801fab:	89 c2                	mov    %eax,%edx
  801fad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fb0:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801fb7:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801fbb:	75 07                	jne    801fc4 <sget+0xa3>
  801fbd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc2:	eb 03                	jmp    801fc7 <sget+0xa6>
	return ptr;
  801fc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801fcf:	8b 55 08             	mov    0x8(%ebp),%edx
  801fd2:	a1 20 50 80 00       	mov    0x805020,%eax
  801fd7:	8b 40 78             	mov    0x78(%eax),%eax
  801fda:	29 c2                	sub    %eax,%edx
  801fdc:	89 d0                	mov    %edx,%eax
  801fde:	2d 00 10 00 00       	sub    $0x1000,%eax
  801fe3:	c1 e8 0c             	shr    $0xc,%eax
  801fe6:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801fed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801ff0:	83 ec 08             	sub    $0x8,%esp
  801ff3:	ff 75 08             	pushl  0x8(%ebp)
  801ff6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff9:	e8 25 f5 ff ff       	call   801523 <sys_freeSharedObject>
  801ffe:	83 c4 10             	add    $0x10,%esp
  802001:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  802004:	90                   	nop
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80200d:	83 ec 04             	sub    $0x4,%esp
  802010:	68 fc 43 80 00       	push   $0x8043fc
  802015:	68 e4 00 00 00       	push   $0xe4
  80201a:	68 ee 43 80 00       	push   $0x8043ee
  80201f:	e8 4a e2 ff ff       	call   80026e <_panic>

00802024 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
  802027:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80202a:	83 ec 04             	sub    $0x4,%esp
  80202d:	68 22 44 80 00       	push   $0x804422
  802032:	68 f0 00 00 00       	push   $0xf0
  802037:	68 ee 43 80 00       	push   $0x8043ee
  80203c:	e8 2d e2 ff ff       	call   80026e <_panic>

00802041 <shrink>:

}
void shrink(uint32 newSize)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802047:	83 ec 04             	sub    $0x4,%esp
  80204a:	68 22 44 80 00       	push   $0x804422
  80204f:	68 f5 00 00 00       	push   $0xf5
  802054:	68 ee 43 80 00       	push   $0x8043ee
  802059:	e8 10 e2 ff ff       	call   80026e <_panic>

0080205e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
  802061:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802064:	83 ec 04             	sub    $0x4,%esp
  802067:	68 22 44 80 00       	push   $0x804422
  80206c:	68 fa 00 00 00       	push   $0xfa
  802071:	68 ee 43 80 00       	push   $0x8043ee
  802076:	e8 f3 e1 ff ff       	call   80026e <_panic>

0080207b <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802081:	8b 45 08             	mov    0x8(%ebp),%eax
  802084:	83 e8 04             	sub    $0x4,%eax
  802087:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80208a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80208d:	8b 00                	mov    (%eax),%eax
  80208f:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	83 e8 04             	sub    $0x4,%eax
  8020a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8020a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020a6:	8b 00                	mov    (%eax),%eax
  8020a8:	83 e0 01             	and    $0x1,%eax
  8020ab:	85 c0                	test   %eax,%eax
  8020ad:	0f 94 c0             	sete   %al
}
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
  8020b5:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8020b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8020bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c2:	83 f8 02             	cmp    $0x2,%eax
  8020c5:	74 2b                	je     8020f2 <alloc_block+0x40>
  8020c7:	83 f8 02             	cmp    $0x2,%eax
  8020ca:	7f 07                	jg     8020d3 <alloc_block+0x21>
  8020cc:	83 f8 01             	cmp    $0x1,%eax
  8020cf:	74 0e                	je     8020df <alloc_block+0x2d>
  8020d1:	eb 58                	jmp    80212b <alloc_block+0x79>
  8020d3:	83 f8 03             	cmp    $0x3,%eax
  8020d6:	74 2d                	je     802105 <alloc_block+0x53>
  8020d8:	83 f8 04             	cmp    $0x4,%eax
  8020db:	74 3b                	je     802118 <alloc_block+0x66>
  8020dd:	eb 4c                	jmp    80212b <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8020df:	83 ec 0c             	sub    $0xc,%esp
  8020e2:	ff 75 08             	pushl  0x8(%ebp)
  8020e5:	e8 11 03 00 00       	call   8023fb <alloc_block_FF>
  8020ea:	83 c4 10             	add    $0x10,%esp
  8020ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020f0:	eb 4a                	jmp    80213c <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8020f2:	83 ec 0c             	sub    $0xc,%esp
  8020f5:	ff 75 08             	pushl  0x8(%ebp)
  8020f8:	e8 c7 19 00 00       	call   803ac4 <alloc_block_NF>
  8020fd:	83 c4 10             	add    $0x10,%esp
  802100:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802103:	eb 37                	jmp    80213c <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802105:	83 ec 0c             	sub    $0xc,%esp
  802108:	ff 75 08             	pushl  0x8(%ebp)
  80210b:	e8 a7 07 00 00       	call   8028b7 <alloc_block_BF>
  802110:	83 c4 10             	add    $0x10,%esp
  802113:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802116:	eb 24                	jmp    80213c <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802118:	83 ec 0c             	sub    $0xc,%esp
  80211b:	ff 75 08             	pushl  0x8(%ebp)
  80211e:	e8 84 19 00 00       	call   803aa7 <alloc_block_WF>
  802123:	83 c4 10             	add    $0x10,%esp
  802126:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802129:	eb 11                	jmp    80213c <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80212b:	83 ec 0c             	sub    $0xc,%esp
  80212e:	68 34 44 80 00       	push   $0x804434
  802133:	e8 f3 e3 ff ff       	call   80052b <cprintf>
  802138:	83 c4 10             	add    $0x10,%esp
		break;
  80213b:	90                   	nop
	}
	return va;
  80213c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
  802144:	53                   	push   %ebx
  802145:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802148:	83 ec 0c             	sub    $0xc,%esp
  80214b:	68 54 44 80 00       	push   $0x804454
  802150:	e8 d6 e3 ff ff       	call   80052b <cprintf>
  802155:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802158:	83 ec 0c             	sub    $0xc,%esp
  80215b:	68 7f 44 80 00       	push   $0x80447f
  802160:	e8 c6 e3 ff ff       	call   80052b <cprintf>
  802165:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80216e:	eb 37                	jmp    8021a7 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802170:	83 ec 0c             	sub    $0xc,%esp
  802173:	ff 75 f4             	pushl  -0xc(%ebp)
  802176:	e8 19 ff ff ff       	call   802094 <is_free_block>
  80217b:	83 c4 10             	add    $0x10,%esp
  80217e:	0f be d8             	movsbl %al,%ebx
  802181:	83 ec 0c             	sub    $0xc,%esp
  802184:	ff 75 f4             	pushl  -0xc(%ebp)
  802187:	e8 ef fe ff ff       	call   80207b <get_block_size>
  80218c:	83 c4 10             	add    $0x10,%esp
  80218f:	83 ec 04             	sub    $0x4,%esp
  802192:	53                   	push   %ebx
  802193:	50                   	push   %eax
  802194:	68 97 44 80 00       	push   $0x804497
  802199:	e8 8d e3 ff ff       	call   80052b <cprintf>
  80219e:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8021a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8021a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ab:	74 07                	je     8021b4 <print_blocks_list+0x73>
  8021ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b0:	8b 00                	mov    (%eax),%eax
  8021b2:	eb 05                	jmp    8021b9 <print_blocks_list+0x78>
  8021b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b9:	89 45 10             	mov    %eax,0x10(%ebp)
  8021bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8021bf:	85 c0                	test   %eax,%eax
  8021c1:	75 ad                	jne    802170 <print_blocks_list+0x2f>
  8021c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c7:	75 a7                	jne    802170 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8021c9:	83 ec 0c             	sub    $0xc,%esp
  8021cc:	68 54 44 80 00       	push   $0x804454
  8021d1:	e8 55 e3 ff ff       	call   80052b <cprintf>
  8021d6:	83 c4 10             	add    $0x10,%esp

}
  8021d9:	90                   	nop
  8021da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021dd:	c9                   	leave  
  8021de:	c3                   	ret    

008021df <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
  8021e2:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8021e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e8:	83 e0 01             	and    $0x1,%eax
  8021eb:	85 c0                	test   %eax,%eax
  8021ed:	74 03                	je     8021f2 <initialize_dynamic_allocator+0x13>
  8021ef:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8021f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021f6:	0f 84 c7 01 00 00    	je     8023c3 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8021fc:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802203:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802206:	8b 55 08             	mov    0x8(%ebp),%edx
  802209:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220c:	01 d0                	add    %edx,%eax
  80220e:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802213:	0f 87 ad 01 00 00    	ja     8023c6 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	85 c0                	test   %eax,%eax
  80221e:	0f 89 a5 01 00 00    	jns    8023c9 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802224:	8b 55 08             	mov    0x8(%ebp),%edx
  802227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80222a:	01 d0                	add    %edx,%eax
  80222c:	83 e8 04             	sub    $0x4,%eax
  80222f:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802234:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80223b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802240:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802243:	e9 87 00 00 00       	jmp    8022cf <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802248:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80224c:	75 14                	jne    802262 <initialize_dynamic_allocator+0x83>
  80224e:	83 ec 04             	sub    $0x4,%esp
  802251:	68 af 44 80 00       	push   $0x8044af
  802256:	6a 79                	push   $0x79
  802258:	68 cd 44 80 00       	push   $0x8044cd
  80225d:	e8 0c e0 ff ff       	call   80026e <_panic>
  802262:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802265:	8b 00                	mov    (%eax),%eax
  802267:	85 c0                	test   %eax,%eax
  802269:	74 10                	je     80227b <initialize_dynamic_allocator+0x9c>
  80226b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226e:	8b 00                	mov    (%eax),%eax
  802270:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802273:	8b 52 04             	mov    0x4(%edx),%edx
  802276:	89 50 04             	mov    %edx,0x4(%eax)
  802279:	eb 0b                	jmp    802286 <initialize_dynamic_allocator+0xa7>
  80227b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227e:	8b 40 04             	mov    0x4(%eax),%eax
  802281:	a3 30 50 80 00       	mov    %eax,0x805030
  802286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802289:	8b 40 04             	mov    0x4(%eax),%eax
  80228c:	85 c0                	test   %eax,%eax
  80228e:	74 0f                	je     80229f <initialize_dynamic_allocator+0xc0>
  802290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802293:	8b 40 04             	mov    0x4(%eax),%eax
  802296:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802299:	8b 12                	mov    (%edx),%edx
  80229b:	89 10                	mov    %edx,(%eax)
  80229d:	eb 0a                	jmp    8022a9 <initialize_dynamic_allocator+0xca>
  80229f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a2:	8b 00                	mov    (%eax),%eax
  8022a4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022bc:	a1 38 50 80 00       	mov    0x805038,%eax
  8022c1:	48                   	dec    %eax
  8022c2:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8022c7:	a1 34 50 80 00       	mov    0x805034,%eax
  8022cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d3:	74 07                	je     8022dc <initialize_dynamic_allocator+0xfd>
  8022d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d8:	8b 00                	mov    (%eax),%eax
  8022da:	eb 05                	jmp    8022e1 <initialize_dynamic_allocator+0x102>
  8022dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e1:	a3 34 50 80 00       	mov    %eax,0x805034
  8022e6:	a1 34 50 80 00       	mov    0x805034,%eax
  8022eb:	85 c0                	test   %eax,%eax
  8022ed:	0f 85 55 ff ff ff    	jne    802248 <initialize_dynamic_allocator+0x69>
  8022f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f7:	0f 85 4b ff ff ff    	jne    802248 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8022fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802300:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802303:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802306:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80230c:	a1 44 50 80 00       	mov    0x805044,%eax
  802311:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802316:	a1 40 50 80 00       	mov    0x805040,%eax
  80231b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802321:	8b 45 08             	mov    0x8(%ebp),%eax
  802324:	83 c0 08             	add    $0x8,%eax
  802327:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80232a:	8b 45 08             	mov    0x8(%ebp),%eax
  80232d:	83 c0 04             	add    $0x4,%eax
  802330:	8b 55 0c             	mov    0xc(%ebp),%edx
  802333:	83 ea 08             	sub    $0x8,%edx
  802336:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802338:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	01 d0                	add    %edx,%eax
  802340:	83 e8 08             	sub    $0x8,%eax
  802343:	8b 55 0c             	mov    0xc(%ebp),%edx
  802346:	83 ea 08             	sub    $0x8,%edx
  802349:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80234b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80234e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802354:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802357:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80235e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802362:	75 17                	jne    80237b <initialize_dynamic_allocator+0x19c>
  802364:	83 ec 04             	sub    $0x4,%esp
  802367:	68 e8 44 80 00       	push   $0x8044e8
  80236c:	68 90 00 00 00       	push   $0x90
  802371:	68 cd 44 80 00       	push   $0x8044cd
  802376:	e8 f3 de ff ff       	call   80026e <_panic>
  80237b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802381:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802384:	89 10                	mov    %edx,(%eax)
  802386:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802389:	8b 00                	mov    (%eax),%eax
  80238b:	85 c0                	test   %eax,%eax
  80238d:	74 0d                	je     80239c <initialize_dynamic_allocator+0x1bd>
  80238f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802394:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802397:	89 50 04             	mov    %edx,0x4(%eax)
  80239a:	eb 08                	jmp    8023a4 <initialize_dynamic_allocator+0x1c5>
  80239c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239f:	a3 30 50 80 00       	mov    %eax,0x805030
  8023a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023b6:	a1 38 50 80 00       	mov    0x805038,%eax
  8023bb:	40                   	inc    %eax
  8023bc:	a3 38 50 80 00       	mov    %eax,0x805038
  8023c1:	eb 07                	jmp    8023ca <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8023c3:	90                   	nop
  8023c4:	eb 04                	jmp    8023ca <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8023c6:	90                   	nop
  8023c7:	eb 01                	jmp    8023ca <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8023c9:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8023ca:	c9                   	leave  
  8023cb:	c3                   	ret    

008023cc <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8023cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d2:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8023d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d8:	8d 50 fc             	lea    -0x4(%eax),%edx
  8023db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023de:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8023e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e3:	83 e8 04             	sub    $0x4,%eax
  8023e6:	8b 00                	mov    (%eax),%eax
  8023e8:	83 e0 fe             	and    $0xfffffffe,%eax
  8023eb:	8d 50 f8             	lea    -0x8(%eax),%edx
  8023ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f1:	01 c2                	add    %eax,%edx
  8023f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f6:	89 02                	mov    %eax,(%edx)
}
  8023f8:	90                   	nop
  8023f9:	5d                   	pop    %ebp
  8023fa:	c3                   	ret    

008023fb <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
  8023fe:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802401:	8b 45 08             	mov    0x8(%ebp),%eax
  802404:	83 e0 01             	and    $0x1,%eax
  802407:	85 c0                	test   %eax,%eax
  802409:	74 03                	je     80240e <alloc_block_FF+0x13>
  80240b:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80240e:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802412:	77 07                	ja     80241b <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802414:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80241b:	a1 24 50 80 00       	mov    0x805024,%eax
  802420:	85 c0                	test   %eax,%eax
  802422:	75 73                	jne    802497 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802424:	8b 45 08             	mov    0x8(%ebp),%eax
  802427:	83 c0 10             	add    $0x10,%eax
  80242a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80242d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802434:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802437:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80243a:	01 d0                	add    %edx,%eax
  80243c:	48                   	dec    %eax
  80243d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802440:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802443:	ba 00 00 00 00       	mov    $0x0,%edx
  802448:	f7 75 ec             	divl   -0x14(%ebp)
  80244b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80244e:	29 d0                	sub    %edx,%eax
  802450:	c1 e8 0c             	shr    $0xc,%eax
  802453:	83 ec 0c             	sub    $0xc,%esp
  802456:	50                   	push   %eax
  802457:	e8 ec f6 ff ff       	call   801b48 <sbrk>
  80245c:	83 c4 10             	add    $0x10,%esp
  80245f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802462:	83 ec 0c             	sub    $0xc,%esp
  802465:	6a 00                	push   $0x0
  802467:	e8 dc f6 ff ff       	call   801b48 <sbrk>
  80246c:	83 c4 10             	add    $0x10,%esp
  80246f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802472:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802475:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802478:	83 ec 08             	sub    $0x8,%esp
  80247b:	50                   	push   %eax
  80247c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80247f:	e8 5b fd ff ff       	call   8021df <initialize_dynamic_allocator>
  802484:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802487:	83 ec 0c             	sub    $0xc,%esp
  80248a:	68 0b 45 80 00       	push   $0x80450b
  80248f:	e8 97 e0 ff ff       	call   80052b <cprintf>
  802494:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802497:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80249b:	75 0a                	jne    8024a7 <alloc_block_FF+0xac>
	        return NULL;
  80249d:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a2:	e9 0e 04 00 00       	jmp    8028b5 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8024a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8024ae:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8024b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024b6:	e9 f3 02 00 00       	jmp    8027ae <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024be:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8024c1:	83 ec 0c             	sub    $0xc,%esp
  8024c4:	ff 75 bc             	pushl  -0x44(%ebp)
  8024c7:	e8 af fb ff ff       	call   80207b <get_block_size>
  8024cc:	83 c4 10             	add    $0x10,%esp
  8024cf:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8024d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d5:	83 c0 08             	add    $0x8,%eax
  8024d8:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024db:	0f 87 c5 02 00 00    	ja     8027a6 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8024e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e4:	83 c0 18             	add    $0x18,%eax
  8024e7:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024ea:	0f 87 19 02 00 00    	ja     802709 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8024f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024f3:	2b 45 08             	sub    0x8(%ebp),%eax
  8024f6:	83 e8 08             	sub    $0x8,%eax
  8024f9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8024fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ff:	8d 50 08             	lea    0x8(%eax),%edx
  802502:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802505:	01 d0                	add    %edx,%eax
  802507:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80250a:	8b 45 08             	mov    0x8(%ebp),%eax
  80250d:	83 c0 08             	add    $0x8,%eax
  802510:	83 ec 04             	sub    $0x4,%esp
  802513:	6a 01                	push   $0x1
  802515:	50                   	push   %eax
  802516:	ff 75 bc             	pushl  -0x44(%ebp)
  802519:	e8 ae fe ff ff       	call   8023cc <set_block_data>
  80251e:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802524:	8b 40 04             	mov    0x4(%eax),%eax
  802527:	85 c0                	test   %eax,%eax
  802529:	75 68                	jne    802593 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80252b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80252f:	75 17                	jne    802548 <alloc_block_FF+0x14d>
  802531:	83 ec 04             	sub    $0x4,%esp
  802534:	68 e8 44 80 00       	push   $0x8044e8
  802539:	68 d7 00 00 00       	push   $0xd7
  80253e:	68 cd 44 80 00       	push   $0x8044cd
  802543:	e8 26 dd ff ff       	call   80026e <_panic>
  802548:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80254e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802551:	89 10                	mov    %edx,(%eax)
  802553:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802556:	8b 00                	mov    (%eax),%eax
  802558:	85 c0                	test   %eax,%eax
  80255a:	74 0d                	je     802569 <alloc_block_FF+0x16e>
  80255c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802561:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802564:	89 50 04             	mov    %edx,0x4(%eax)
  802567:	eb 08                	jmp    802571 <alloc_block_FF+0x176>
  802569:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80256c:	a3 30 50 80 00       	mov    %eax,0x805030
  802571:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802574:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802579:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80257c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802583:	a1 38 50 80 00       	mov    0x805038,%eax
  802588:	40                   	inc    %eax
  802589:	a3 38 50 80 00       	mov    %eax,0x805038
  80258e:	e9 dc 00 00 00       	jmp    80266f <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	8b 00                	mov    (%eax),%eax
  802598:	85 c0                	test   %eax,%eax
  80259a:	75 65                	jne    802601 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80259c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025a0:	75 17                	jne    8025b9 <alloc_block_FF+0x1be>
  8025a2:	83 ec 04             	sub    $0x4,%esp
  8025a5:	68 1c 45 80 00       	push   $0x80451c
  8025aa:	68 db 00 00 00       	push   $0xdb
  8025af:	68 cd 44 80 00       	push   $0x8044cd
  8025b4:	e8 b5 dc ff ff       	call   80026e <_panic>
  8025b9:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8025bf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025c2:	89 50 04             	mov    %edx,0x4(%eax)
  8025c5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025c8:	8b 40 04             	mov    0x4(%eax),%eax
  8025cb:	85 c0                	test   %eax,%eax
  8025cd:	74 0c                	je     8025db <alloc_block_FF+0x1e0>
  8025cf:	a1 30 50 80 00       	mov    0x805030,%eax
  8025d4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025d7:	89 10                	mov    %edx,(%eax)
  8025d9:	eb 08                	jmp    8025e3 <alloc_block_FF+0x1e8>
  8025db:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025de:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025e6:	a3 30 50 80 00       	mov    %eax,0x805030
  8025eb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025f4:	a1 38 50 80 00       	mov    0x805038,%eax
  8025f9:	40                   	inc    %eax
  8025fa:	a3 38 50 80 00       	mov    %eax,0x805038
  8025ff:	eb 6e                	jmp    80266f <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802601:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802605:	74 06                	je     80260d <alloc_block_FF+0x212>
  802607:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80260b:	75 17                	jne    802624 <alloc_block_FF+0x229>
  80260d:	83 ec 04             	sub    $0x4,%esp
  802610:	68 40 45 80 00       	push   $0x804540
  802615:	68 df 00 00 00       	push   $0xdf
  80261a:	68 cd 44 80 00       	push   $0x8044cd
  80261f:	e8 4a dc ff ff       	call   80026e <_panic>
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	8b 10                	mov    (%eax),%edx
  802629:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80262c:	89 10                	mov    %edx,(%eax)
  80262e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802631:	8b 00                	mov    (%eax),%eax
  802633:	85 c0                	test   %eax,%eax
  802635:	74 0b                	je     802642 <alloc_block_FF+0x247>
  802637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263a:	8b 00                	mov    (%eax),%eax
  80263c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80263f:	89 50 04             	mov    %edx,0x4(%eax)
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802648:	89 10                	mov    %edx,(%eax)
  80264a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80264d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802650:	89 50 04             	mov    %edx,0x4(%eax)
  802653:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802656:	8b 00                	mov    (%eax),%eax
  802658:	85 c0                	test   %eax,%eax
  80265a:	75 08                	jne    802664 <alloc_block_FF+0x269>
  80265c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80265f:	a3 30 50 80 00       	mov    %eax,0x805030
  802664:	a1 38 50 80 00       	mov    0x805038,%eax
  802669:	40                   	inc    %eax
  80266a:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80266f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802673:	75 17                	jne    80268c <alloc_block_FF+0x291>
  802675:	83 ec 04             	sub    $0x4,%esp
  802678:	68 af 44 80 00       	push   $0x8044af
  80267d:	68 e1 00 00 00       	push   $0xe1
  802682:	68 cd 44 80 00       	push   $0x8044cd
  802687:	e8 e2 db ff ff       	call   80026e <_panic>
  80268c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268f:	8b 00                	mov    (%eax),%eax
  802691:	85 c0                	test   %eax,%eax
  802693:	74 10                	je     8026a5 <alloc_block_FF+0x2aa>
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8b 00                	mov    (%eax),%eax
  80269a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80269d:	8b 52 04             	mov    0x4(%edx),%edx
  8026a0:	89 50 04             	mov    %edx,0x4(%eax)
  8026a3:	eb 0b                	jmp    8026b0 <alloc_block_FF+0x2b5>
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	8b 40 04             	mov    0x4(%eax),%eax
  8026ab:	a3 30 50 80 00       	mov    %eax,0x805030
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	8b 40 04             	mov    0x4(%eax),%eax
  8026b6:	85 c0                	test   %eax,%eax
  8026b8:	74 0f                	je     8026c9 <alloc_block_FF+0x2ce>
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 40 04             	mov    0x4(%eax),%eax
  8026c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c3:	8b 12                	mov    (%edx),%edx
  8026c5:	89 10                	mov    %edx,(%eax)
  8026c7:	eb 0a                	jmp    8026d3 <alloc_block_FF+0x2d8>
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	8b 00                	mov    (%eax),%eax
  8026ce:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026e6:	a1 38 50 80 00       	mov    0x805038,%eax
  8026eb:	48                   	dec    %eax
  8026ec:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8026f1:	83 ec 04             	sub    $0x4,%esp
  8026f4:	6a 00                	push   $0x0
  8026f6:	ff 75 b4             	pushl  -0x4c(%ebp)
  8026f9:	ff 75 b0             	pushl  -0x50(%ebp)
  8026fc:	e8 cb fc ff ff       	call   8023cc <set_block_data>
  802701:	83 c4 10             	add    $0x10,%esp
  802704:	e9 95 00 00 00       	jmp    80279e <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802709:	83 ec 04             	sub    $0x4,%esp
  80270c:	6a 01                	push   $0x1
  80270e:	ff 75 b8             	pushl  -0x48(%ebp)
  802711:	ff 75 bc             	pushl  -0x44(%ebp)
  802714:	e8 b3 fc ff ff       	call   8023cc <set_block_data>
  802719:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80271c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802720:	75 17                	jne    802739 <alloc_block_FF+0x33e>
  802722:	83 ec 04             	sub    $0x4,%esp
  802725:	68 af 44 80 00       	push   $0x8044af
  80272a:	68 e8 00 00 00       	push   $0xe8
  80272f:	68 cd 44 80 00       	push   $0x8044cd
  802734:	e8 35 db ff ff       	call   80026e <_panic>
  802739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273c:	8b 00                	mov    (%eax),%eax
  80273e:	85 c0                	test   %eax,%eax
  802740:	74 10                	je     802752 <alloc_block_FF+0x357>
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	8b 00                	mov    (%eax),%eax
  802747:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80274a:	8b 52 04             	mov    0x4(%edx),%edx
  80274d:	89 50 04             	mov    %edx,0x4(%eax)
  802750:	eb 0b                	jmp    80275d <alloc_block_FF+0x362>
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	8b 40 04             	mov    0x4(%eax),%eax
  802758:	a3 30 50 80 00       	mov    %eax,0x805030
  80275d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802760:	8b 40 04             	mov    0x4(%eax),%eax
  802763:	85 c0                	test   %eax,%eax
  802765:	74 0f                	je     802776 <alloc_block_FF+0x37b>
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 40 04             	mov    0x4(%eax),%eax
  80276d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802770:	8b 12                	mov    (%edx),%edx
  802772:	89 10                	mov    %edx,(%eax)
  802774:	eb 0a                	jmp    802780 <alloc_block_FF+0x385>
  802776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802779:	8b 00                	mov    (%eax),%eax
  80277b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802793:	a1 38 50 80 00       	mov    0x805038,%eax
  802798:	48                   	dec    %eax
  802799:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80279e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8027a1:	e9 0f 01 00 00       	jmp    8028b5 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8027a6:	a1 34 50 80 00       	mov    0x805034,%eax
  8027ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b2:	74 07                	je     8027bb <alloc_block_FF+0x3c0>
  8027b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b7:	8b 00                	mov    (%eax),%eax
  8027b9:	eb 05                	jmp    8027c0 <alloc_block_FF+0x3c5>
  8027bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c0:	a3 34 50 80 00       	mov    %eax,0x805034
  8027c5:	a1 34 50 80 00       	mov    0x805034,%eax
  8027ca:	85 c0                	test   %eax,%eax
  8027cc:	0f 85 e9 fc ff ff    	jne    8024bb <alloc_block_FF+0xc0>
  8027d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d6:	0f 85 df fc ff ff    	jne    8024bb <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8027dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027df:	83 c0 08             	add    $0x8,%eax
  8027e2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8027e5:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8027ec:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027ef:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8027f2:	01 d0                	add    %edx,%eax
  8027f4:	48                   	dec    %eax
  8027f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8027f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027fb:	ba 00 00 00 00       	mov    $0x0,%edx
  802800:	f7 75 d8             	divl   -0x28(%ebp)
  802803:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802806:	29 d0                	sub    %edx,%eax
  802808:	c1 e8 0c             	shr    $0xc,%eax
  80280b:	83 ec 0c             	sub    $0xc,%esp
  80280e:	50                   	push   %eax
  80280f:	e8 34 f3 ff ff       	call   801b48 <sbrk>
  802814:	83 c4 10             	add    $0x10,%esp
  802817:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80281a:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80281e:	75 0a                	jne    80282a <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802820:	b8 00 00 00 00       	mov    $0x0,%eax
  802825:	e9 8b 00 00 00       	jmp    8028b5 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80282a:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802831:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802834:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802837:	01 d0                	add    %edx,%eax
  802839:	48                   	dec    %eax
  80283a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80283d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802840:	ba 00 00 00 00       	mov    $0x0,%edx
  802845:	f7 75 cc             	divl   -0x34(%ebp)
  802848:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80284b:	29 d0                	sub    %edx,%eax
  80284d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802850:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802853:	01 d0                	add    %edx,%eax
  802855:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80285a:	a1 40 50 80 00       	mov    0x805040,%eax
  80285f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802865:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80286c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80286f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802872:	01 d0                	add    %edx,%eax
  802874:	48                   	dec    %eax
  802875:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802878:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80287b:	ba 00 00 00 00       	mov    $0x0,%edx
  802880:	f7 75 c4             	divl   -0x3c(%ebp)
  802883:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802886:	29 d0                	sub    %edx,%eax
  802888:	83 ec 04             	sub    $0x4,%esp
  80288b:	6a 01                	push   $0x1
  80288d:	50                   	push   %eax
  80288e:	ff 75 d0             	pushl  -0x30(%ebp)
  802891:	e8 36 fb ff ff       	call   8023cc <set_block_data>
  802896:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802899:	83 ec 0c             	sub    $0xc,%esp
  80289c:	ff 75 d0             	pushl  -0x30(%ebp)
  80289f:	e8 f8 09 00 00       	call   80329c <free_block>
  8028a4:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8028a7:	83 ec 0c             	sub    $0xc,%esp
  8028aa:	ff 75 08             	pushl  0x8(%ebp)
  8028ad:	e8 49 fb ff ff       	call   8023fb <alloc_block_FF>
  8028b2:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8028b5:	c9                   	leave  
  8028b6:	c3                   	ret    

008028b7 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8028b7:	55                   	push   %ebp
  8028b8:	89 e5                	mov    %esp,%ebp
  8028ba:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8028bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c0:	83 e0 01             	and    $0x1,%eax
  8028c3:	85 c0                	test   %eax,%eax
  8028c5:	74 03                	je     8028ca <alloc_block_BF+0x13>
  8028c7:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8028ca:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8028ce:	77 07                	ja     8028d7 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8028d0:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8028d7:	a1 24 50 80 00       	mov    0x805024,%eax
  8028dc:	85 c0                	test   %eax,%eax
  8028de:	75 73                	jne    802953 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8028e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e3:	83 c0 10             	add    $0x10,%eax
  8028e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8028e9:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8028f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028f6:	01 d0                	add    %edx,%eax
  8028f8:	48                   	dec    %eax
  8028f9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8028fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028ff:	ba 00 00 00 00       	mov    $0x0,%edx
  802904:	f7 75 e0             	divl   -0x20(%ebp)
  802907:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80290a:	29 d0                	sub    %edx,%eax
  80290c:	c1 e8 0c             	shr    $0xc,%eax
  80290f:	83 ec 0c             	sub    $0xc,%esp
  802912:	50                   	push   %eax
  802913:	e8 30 f2 ff ff       	call   801b48 <sbrk>
  802918:	83 c4 10             	add    $0x10,%esp
  80291b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80291e:	83 ec 0c             	sub    $0xc,%esp
  802921:	6a 00                	push   $0x0
  802923:	e8 20 f2 ff ff       	call   801b48 <sbrk>
  802928:	83 c4 10             	add    $0x10,%esp
  80292b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80292e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802931:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802934:	83 ec 08             	sub    $0x8,%esp
  802937:	50                   	push   %eax
  802938:	ff 75 d8             	pushl  -0x28(%ebp)
  80293b:	e8 9f f8 ff ff       	call   8021df <initialize_dynamic_allocator>
  802940:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802943:	83 ec 0c             	sub    $0xc,%esp
  802946:	68 0b 45 80 00       	push   $0x80450b
  80294b:	e8 db db ff ff       	call   80052b <cprintf>
  802950:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802953:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80295a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802961:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802968:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80296f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802974:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802977:	e9 1d 01 00 00       	jmp    802a99 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297f:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802982:	83 ec 0c             	sub    $0xc,%esp
  802985:	ff 75 a8             	pushl  -0x58(%ebp)
  802988:	e8 ee f6 ff ff       	call   80207b <get_block_size>
  80298d:	83 c4 10             	add    $0x10,%esp
  802990:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802993:	8b 45 08             	mov    0x8(%ebp),%eax
  802996:	83 c0 08             	add    $0x8,%eax
  802999:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80299c:	0f 87 ef 00 00 00    	ja     802a91 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8029a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a5:	83 c0 18             	add    $0x18,%eax
  8029a8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029ab:	77 1d                	ja     8029ca <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8029ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029b3:	0f 86 d8 00 00 00    	jbe    802a91 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8029b9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8029bf:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8029c5:	e9 c7 00 00 00       	jmp    802a91 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8029ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cd:	83 c0 08             	add    $0x8,%eax
  8029d0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029d3:	0f 85 9d 00 00 00    	jne    802a76 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8029d9:	83 ec 04             	sub    $0x4,%esp
  8029dc:	6a 01                	push   $0x1
  8029de:	ff 75 a4             	pushl  -0x5c(%ebp)
  8029e1:	ff 75 a8             	pushl  -0x58(%ebp)
  8029e4:	e8 e3 f9 ff ff       	call   8023cc <set_block_data>
  8029e9:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8029ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f0:	75 17                	jne    802a09 <alloc_block_BF+0x152>
  8029f2:	83 ec 04             	sub    $0x4,%esp
  8029f5:	68 af 44 80 00       	push   $0x8044af
  8029fa:	68 2c 01 00 00       	push   $0x12c
  8029ff:	68 cd 44 80 00       	push   $0x8044cd
  802a04:	e8 65 d8 ff ff       	call   80026e <_panic>
  802a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0c:	8b 00                	mov    (%eax),%eax
  802a0e:	85 c0                	test   %eax,%eax
  802a10:	74 10                	je     802a22 <alloc_block_BF+0x16b>
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	8b 00                	mov    (%eax),%eax
  802a17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1a:	8b 52 04             	mov    0x4(%edx),%edx
  802a1d:	89 50 04             	mov    %edx,0x4(%eax)
  802a20:	eb 0b                	jmp    802a2d <alloc_block_BF+0x176>
  802a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a25:	8b 40 04             	mov    0x4(%eax),%eax
  802a28:	a3 30 50 80 00       	mov    %eax,0x805030
  802a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a30:	8b 40 04             	mov    0x4(%eax),%eax
  802a33:	85 c0                	test   %eax,%eax
  802a35:	74 0f                	je     802a46 <alloc_block_BF+0x18f>
  802a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3a:	8b 40 04             	mov    0x4(%eax),%eax
  802a3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a40:	8b 12                	mov    (%edx),%edx
  802a42:	89 10                	mov    %edx,(%eax)
  802a44:	eb 0a                	jmp    802a50 <alloc_block_BF+0x199>
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	8b 00                	mov    (%eax),%eax
  802a4b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a63:	a1 38 50 80 00       	mov    0x805038,%eax
  802a68:	48                   	dec    %eax
  802a69:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802a6e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a71:	e9 01 04 00 00       	jmp    802e77 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802a76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a79:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a7c:	76 13                	jbe    802a91 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802a7e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802a85:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802a8b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a8e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802a91:	a1 34 50 80 00       	mov    0x805034,%eax
  802a96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9d:	74 07                	je     802aa6 <alloc_block_BF+0x1ef>
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	8b 00                	mov    (%eax),%eax
  802aa4:	eb 05                	jmp    802aab <alloc_block_BF+0x1f4>
  802aa6:	b8 00 00 00 00       	mov    $0x0,%eax
  802aab:	a3 34 50 80 00       	mov    %eax,0x805034
  802ab0:	a1 34 50 80 00       	mov    0x805034,%eax
  802ab5:	85 c0                	test   %eax,%eax
  802ab7:	0f 85 bf fe ff ff    	jne    80297c <alloc_block_BF+0xc5>
  802abd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac1:	0f 85 b5 fe ff ff    	jne    80297c <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802ac7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802acb:	0f 84 26 02 00 00    	je     802cf7 <alloc_block_BF+0x440>
  802ad1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ad5:	0f 85 1c 02 00 00    	jne    802cf7 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802adb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ade:	2b 45 08             	sub    0x8(%ebp),%eax
  802ae1:	83 e8 08             	sub    $0x8,%eax
  802ae4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aea:	8d 50 08             	lea    0x8(%eax),%edx
  802aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af0:	01 d0                	add    %edx,%eax
  802af2:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802af5:	8b 45 08             	mov    0x8(%ebp),%eax
  802af8:	83 c0 08             	add    $0x8,%eax
  802afb:	83 ec 04             	sub    $0x4,%esp
  802afe:	6a 01                	push   $0x1
  802b00:	50                   	push   %eax
  802b01:	ff 75 f0             	pushl  -0x10(%ebp)
  802b04:	e8 c3 f8 ff ff       	call   8023cc <set_block_data>
  802b09:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0f:	8b 40 04             	mov    0x4(%eax),%eax
  802b12:	85 c0                	test   %eax,%eax
  802b14:	75 68                	jne    802b7e <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b16:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b1a:	75 17                	jne    802b33 <alloc_block_BF+0x27c>
  802b1c:	83 ec 04             	sub    $0x4,%esp
  802b1f:	68 e8 44 80 00       	push   $0x8044e8
  802b24:	68 45 01 00 00       	push   $0x145
  802b29:	68 cd 44 80 00       	push   $0x8044cd
  802b2e:	e8 3b d7 ff ff       	call   80026e <_panic>
  802b33:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802b39:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b3c:	89 10                	mov    %edx,(%eax)
  802b3e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b41:	8b 00                	mov    (%eax),%eax
  802b43:	85 c0                	test   %eax,%eax
  802b45:	74 0d                	je     802b54 <alloc_block_BF+0x29d>
  802b47:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802b4c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b4f:	89 50 04             	mov    %edx,0x4(%eax)
  802b52:	eb 08                	jmp    802b5c <alloc_block_BF+0x2a5>
  802b54:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b57:	a3 30 50 80 00       	mov    %eax,0x805030
  802b5c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b5f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b64:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6e:	a1 38 50 80 00       	mov    0x805038,%eax
  802b73:	40                   	inc    %eax
  802b74:	a3 38 50 80 00       	mov    %eax,0x805038
  802b79:	e9 dc 00 00 00       	jmp    802c5a <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b81:	8b 00                	mov    (%eax),%eax
  802b83:	85 c0                	test   %eax,%eax
  802b85:	75 65                	jne    802bec <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b87:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b8b:	75 17                	jne    802ba4 <alloc_block_BF+0x2ed>
  802b8d:	83 ec 04             	sub    $0x4,%esp
  802b90:	68 1c 45 80 00       	push   $0x80451c
  802b95:	68 4a 01 00 00       	push   $0x14a
  802b9a:	68 cd 44 80 00       	push   $0x8044cd
  802b9f:	e8 ca d6 ff ff       	call   80026e <_panic>
  802ba4:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802baa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bad:	89 50 04             	mov    %edx,0x4(%eax)
  802bb0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bb3:	8b 40 04             	mov    0x4(%eax),%eax
  802bb6:	85 c0                	test   %eax,%eax
  802bb8:	74 0c                	je     802bc6 <alloc_block_BF+0x30f>
  802bba:	a1 30 50 80 00       	mov    0x805030,%eax
  802bbf:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bc2:	89 10                	mov    %edx,(%eax)
  802bc4:	eb 08                	jmp    802bce <alloc_block_BF+0x317>
  802bc6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bc9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bd1:	a3 30 50 80 00       	mov    %eax,0x805030
  802bd6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bdf:	a1 38 50 80 00       	mov    0x805038,%eax
  802be4:	40                   	inc    %eax
  802be5:	a3 38 50 80 00       	mov    %eax,0x805038
  802bea:	eb 6e                	jmp    802c5a <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802bec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bf0:	74 06                	je     802bf8 <alloc_block_BF+0x341>
  802bf2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bf6:	75 17                	jne    802c0f <alloc_block_BF+0x358>
  802bf8:	83 ec 04             	sub    $0x4,%esp
  802bfb:	68 40 45 80 00       	push   $0x804540
  802c00:	68 4f 01 00 00       	push   $0x14f
  802c05:	68 cd 44 80 00       	push   $0x8044cd
  802c0a:	e8 5f d6 ff ff       	call   80026e <_panic>
  802c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c12:	8b 10                	mov    (%eax),%edx
  802c14:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c17:	89 10                	mov    %edx,(%eax)
  802c19:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c1c:	8b 00                	mov    (%eax),%eax
  802c1e:	85 c0                	test   %eax,%eax
  802c20:	74 0b                	je     802c2d <alloc_block_BF+0x376>
  802c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c25:	8b 00                	mov    (%eax),%eax
  802c27:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c2a:	89 50 04             	mov    %edx,0x4(%eax)
  802c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c30:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c33:	89 10                	mov    %edx,(%eax)
  802c35:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c3b:	89 50 04             	mov    %edx,0x4(%eax)
  802c3e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c41:	8b 00                	mov    (%eax),%eax
  802c43:	85 c0                	test   %eax,%eax
  802c45:	75 08                	jne    802c4f <alloc_block_BF+0x398>
  802c47:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c4a:	a3 30 50 80 00       	mov    %eax,0x805030
  802c4f:	a1 38 50 80 00       	mov    0x805038,%eax
  802c54:	40                   	inc    %eax
  802c55:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802c5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c5e:	75 17                	jne    802c77 <alloc_block_BF+0x3c0>
  802c60:	83 ec 04             	sub    $0x4,%esp
  802c63:	68 af 44 80 00       	push   $0x8044af
  802c68:	68 51 01 00 00       	push   $0x151
  802c6d:	68 cd 44 80 00       	push   $0x8044cd
  802c72:	e8 f7 d5 ff ff       	call   80026e <_panic>
  802c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7a:	8b 00                	mov    (%eax),%eax
  802c7c:	85 c0                	test   %eax,%eax
  802c7e:	74 10                	je     802c90 <alloc_block_BF+0x3d9>
  802c80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c83:	8b 00                	mov    (%eax),%eax
  802c85:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c88:	8b 52 04             	mov    0x4(%edx),%edx
  802c8b:	89 50 04             	mov    %edx,0x4(%eax)
  802c8e:	eb 0b                	jmp    802c9b <alloc_block_BF+0x3e4>
  802c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c93:	8b 40 04             	mov    0x4(%eax),%eax
  802c96:	a3 30 50 80 00       	mov    %eax,0x805030
  802c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ca1:	85 c0                	test   %eax,%eax
  802ca3:	74 0f                	je     802cb4 <alloc_block_BF+0x3fd>
  802ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca8:	8b 40 04             	mov    0x4(%eax),%eax
  802cab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cae:	8b 12                	mov    (%edx),%edx
  802cb0:	89 10                	mov    %edx,(%eax)
  802cb2:	eb 0a                	jmp    802cbe <alloc_block_BF+0x407>
  802cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb7:	8b 00                	mov    (%eax),%eax
  802cb9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd1:	a1 38 50 80 00       	mov    0x805038,%eax
  802cd6:	48                   	dec    %eax
  802cd7:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802cdc:	83 ec 04             	sub    $0x4,%esp
  802cdf:	6a 00                	push   $0x0
  802ce1:	ff 75 d0             	pushl  -0x30(%ebp)
  802ce4:	ff 75 cc             	pushl  -0x34(%ebp)
  802ce7:	e8 e0 f6 ff ff       	call   8023cc <set_block_data>
  802cec:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf2:	e9 80 01 00 00       	jmp    802e77 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802cf7:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802cfb:	0f 85 9d 00 00 00    	jne    802d9e <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802d01:	83 ec 04             	sub    $0x4,%esp
  802d04:	6a 01                	push   $0x1
  802d06:	ff 75 ec             	pushl  -0x14(%ebp)
  802d09:	ff 75 f0             	pushl  -0x10(%ebp)
  802d0c:	e8 bb f6 ff ff       	call   8023cc <set_block_data>
  802d11:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802d14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d18:	75 17                	jne    802d31 <alloc_block_BF+0x47a>
  802d1a:	83 ec 04             	sub    $0x4,%esp
  802d1d:	68 af 44 80 00       	push   $0x8044af
  802d22:	68 58 01 00 00       	push   $0x158
  802d27:	68 cd 44 80 00       	push   $0x8044cd
  802d2c:	e8 3d d5 ff ff       	call   80026e <_panic>
  802d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d34:	8b 00                	mov    (%eax),%eax
  802d36:	85 c0                	test   %eax,%eax
  802d38:	74 10                	je     802d4a <alloc_block_BF+0x493>
  802d3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3d:	8b 00                	mov    (%eax),%eax
  802d3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d42:	8b 52 04             	mov    0x4(%edx),%edx
  802d45:	89 50 04             	mov    %edx,0x4(%eax)
  802d48:	eb 0b                	jmp    802d55 <alloc_block_BF+0x49e>
  802d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4d:	8b 40 04             	mov    0x4(%eax),%eax
  802d50:	a3 30 50 80 00       	mov    %eax,0x805030
  802d55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d58:	8b 40 04             	mov    0x4(%eax),%eax
  802d5b:	85 c0                	test   %eax,%eax
  802d5d:	74 0f                	je     802d6e <alloc_block_BF+0x4b7>
  802d5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d62:	8b 40 04             	mov    0x4(%eax),%eax
  802d65:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d68:	8b 12                	mov    (%edx),%edx
  802d6a:	89 10                	mov    %edx,(%eax)
  802d6c:	eb 0a                	jmp    802d78 <alloc_block_BF+0x4c1>
  802d6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d71:	8b 00                	mov    (%eax),%eax
  802d73:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d8b:	a1 38 50 80 00       	mov    0x805038,%eax
  802d90:	48                   	dec    %eax
  802d91:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d99:	e9 d9 00 00 00       	jmp    802e77 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802da1:	83 c0 08             	add    $0x8,%eax
  802da4:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802da7:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802dae:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802db1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802db4:	01 d0                	add    %edx,%eax
  802db6:	48                   	dec    %eax
  802db7:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802dba:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802dbd:	ba 00 00 00 00       	mov    $0x0,%edx
  802dc2:	f7 75 c4             	divl   -0x3c(%ebp)
  802dc5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802dc8:	29 d0                	sub    %edx,%eax
  802dca:	c1 e8 0c             	shr    $0xc,%eax
  802dcd:	83 ec 0c             	sub    $0xc,%esp
  802dd0:	50                   	push   %eax
  802dd1:	e8 72 ed ff ff       	call   801b48 <sbrk>
  802dd6:	83 c4 10             	add    $0x10,%esp
  802dd9:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802ddc:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802de0:	75 0a                	jne    802dec <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802de2:	b8 00 00 00 00       	mov    $0x0,%eax
  802de7:	e9 8b 00 00 00       	jmp    802e77 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802dec:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802df3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802df6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802df9:	01 d0                	add    %edx,%eax
  802dfb:	48                   	dec    %eax
  802dfc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802dff:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e02:	ba 00 00 00 00       	mov    $0x0,%edx
  802e07:	f7 75 b8             	divl   -0x48(%ebp)
  802e0a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e0d:	29 d0                	sub    %edx,%eax
  802e0f:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e12:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e15:	01 d0                	add    %edx,%eax
  802e17:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802e1c:	a1 40 50 80 00       	mov    0x805040,%eax
  802e21:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e27:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802e2e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e31:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e34:	01 d0                	add    %edx,%eax
  802e36:	48                   	dec    %eax
  802e37:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802e3a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e3d:	ba 00 00 00 00       	mov    $0x0,%edx
  802e42:	f7 75 b0             	divl   -0x50(%ebp)
  802e45:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e48:	29 d0                	sub    %edx,%eax
  802e4a:	83 ec 04             	sub    $0x4,%esp
  802e4d:	6a 01                	push   $0x1
  802e4f:	50                   	push   %eax
  802e50:	ff 75 bc             	pushl  -0x44(%ebp)
  802e53:	e8 74 f5 ff ff       	call   8023cc <set_block_data>
  802e58:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802e5b:	83 ec 0c             	sub    $0xc,%esp
  802e5e:	ff 75 bc             	pushl  -0x44(%ebp)
  802e61:	e8 36 04 00 00       	call   80329c <free_block>
  802e66:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802e69:	83 ec 0c             	sub    $0xc,%esp
  802e6c:	ff 75 08             	pushl  0x8(%ebp)
  802e6f:	e8 43 fa ff ff       	call   8028b7 <alloc_block_BF>
  802e74:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802e77:	c9                   	leave  
  802e78:	c3                   	ret    

00802e79 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802e79:	55                   	push   %ebp
  802e7a:	89 e5                	mov    %esp,%ebp
  802e7c:	53                   	push   %ebx
  802e7d:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802e80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802e87:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802e8e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e92:	74 1e                	je     802eb2 <merging+0x39>
  802e94:	ff 75 08             	pushl  0x8(%ebp)
  802e97:	e8 df f1 ff ff       	call   80207b <get_block_size>
  802e9c:	83 c4 04             	add    $0x4,%esp
  802e9f:	89 c2                	mov    %eax,%edx
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	01 d0                	add    %edx,%eax
  802ea6:	3b 45 10             	cmp    0x10(%ebp),%eax
  802ea9:	75 07                	jne    802eb2 <merging+0x39>
		prev_is_free = 1;
  802eab:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802eb2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802eb6:	74 1e                	je     802ed6 <merging+0x5d>
  802eb8:	ff 75 10             	pushl  0x10(%ebp)
  802ebb:	e8 bb f1 ff ff       	call   80207b <get_block_size>
  802ec0:	83 c4 04             	add    $0x4,%esp
  802ec3:	89 c2                	mov    %eax,%edx
  802ec5:	8b 45 10             	mov    0x10(%ebp),%eax
  802ec8:	01 d0                	add    %edx,%eax
  802eca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ecd:	75 07                	jne    802ed6 <merging+0x5d>
		next_is_free = 1;
  802ecf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802ed6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eda:	0f 84 cc 00 00 00    	je     802fac <merging+0x133>
  802ee0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ee4:	0f 84 c2 00 00 00    	je     802fac <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802eea:	ff 75 08             	pushl  0x8(%ebp)
  802eed:	e8 89 f1 ff ff       	call   80207b <get_block_size>
  802ef2:	83 c4 04             	add    $0x4,%esp
  802ef5:	89 c3                	mov    %eax,%ebx
  802ef7:	ff 75 10             	pushl  0x10(%ebp)
  802efa:	e8 7c f1 ff ff       	call   80207b <get_block_size>
  802eff:	83 c4 04             	add    $0x4,%esp
  802f02:	01 c3                	add    %eax,%ebx
  802f04:	ff 75 0c             	pushl  0xc(%ebp)
  802f07:	e8 6f f1 ff ff       	call   80207b <get_block_size>
  802f0c:	83 c4 04             	add    $0x4,%esp
  802f0f:	01 d8                	add    %ebx,%eax
  802f11:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f14:	6a 00                	push   $0x0
  802f16:	ff 75 ec             	pushl  -0x14(%ebp)
  802f19:	ff 75 08             	pushl  0x8(%ebp)
  802f1c:	e8 ab f4 ff ff       	call   8023cc <set_block_data>
  802f21:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802f24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f28:	75 17                	jne    802f41 <merging+0xc8>
  802f2a:	83 ec 04             	sub    $0x4,%esp
  802f2d:	68 af 44 80 00       	push   $0x8044af
  802f32:	68 7d 01 00 00       	push   $0x17d
  802f37:	68 cd 44 80 00       	push   $0x8044cd
  802f3c:	e8 2d d3 ff ff       	call   80026e <_panic>
  802f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f44:	8b 00                	mov    (%eax),%eax
  802f46:	85 c0                	test   %eax,%eax
  802f48:	74 10                	je     802f5a <merging+0xe1>
  802f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4d:	8b 00                	mov    (%eax),%eax
  802f4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f52:	8b 52 04             	mov    0x4(%edx),%edx
  802f55:	89 50 04             	mov    %edx,0x4(%eax)
  802f58:	eb 0b                	jmp    802f65 <merging+0xec>
  802f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f5d:	8b 40 04             	mov    0x4(%eax),%eax
  802f60:	a3 30 50 80 00       	mov    %eax,0x805030
  802f65:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f68:	8b 40 04             	mov    0x4(%eax),%eax
  802f6b:	85 c0                	test   %eax,%eax
  802f6d:	74 0f                	je     802f7e <merging+0x105>
  802f6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f72:	8b 40 04             	mov    0x4(%eax),%eax
  802f75:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f78:	8b 12                	mov    (%edx),%edx
  802f7a:	89 10                	mov    %edx,(%eax)
  802f7c:	eb 0a                	jmp    802f88 <merging+0x10f>
  802f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f81:	8b 00                	mov    (%eax),%eax
  802f83:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f88:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9b:	a1 38 50 80 00       	mov    0x805038,%eax
  802fa0:	48                   	dec    %eax
  802fa1:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802fa6:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fa7:	e9 ea 02 00 00       	jmp    803296 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802fac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb0:	74 3b                	je     802fed <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802fb2:	83 ec 0c             	sub    $0xc,%esp
  802fb5:	ff 75 08             	pushl  0x8(%ebp)
  802fb8:	e8 be f0 ff ff       	call   80207b <get_block_size>
  802fbd:	83 c4 10             	add    $0x10,%esp
  802fc0:	89 c3                	mov    %eax,%ebx
  802fc2:	83 ec 0c             	sub    $0xc,%esp
  802fc5:	ff 75 10             	pushl  0x10(%ebp)
  802fc8:	e8 ae f0 ff ff       	call   80207b <get_block_size>
  802fcd:	83 c4 10             	add    $0x10,%esp
  802fd0:	01 d8                	add    %ebx,%eax
  802fd2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802fd5:	83 ec 04             	sub    $0x4,%esp
  802fd8:	6a 00                	push   $0x0
  802fda:	ff 75 e8             	pushl  -0x18(%ebp)
  802fdd:	ff 75 08             	pushl  0x8(%ebp)
  802fe0:	e8 e7 f3 ff ff       	call   8023cc <set_block_data>
  802fe5:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fe8:	e9 a9 02 00 00       	jmp    803296 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802fed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ff1:	0f 84 2d 01 00 00    	je     803124 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802ff7:	83 ec 0c             	sub    $0xc,%esp
  802ffa:	ff 75 10             	pushl  0x10(%ebp)
  802ffd:	e8 79 f0 ff ff       	call   80207b <get_block_size>
  803002:	83 c4 10             	add    $0x10,%esp
  803005:	89 c3                	mov    %eax,%ebx
  803007:	83 ec 0c             	sub    $0xc,%esp
  80300a:	ff 75 0c             	pushl  0xc(%ebp)
  80300d:	e8 69 f0 ff ff       	call   80207b <get_block_size>
  803012:	83 c4 10             	add    $0x10,%esp
  803015:	01 d8                	add    %ebx,%eax
  803017:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80301a:	83 ec 04             	sub    $0x4,%esp
  80301d:	6a 00                	push   $0x0
  80301f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803022:	ff 75 10             	pushl  0x10(%ebp)
  803025:	e8 a2 f3 ff ff       	call   8023cc <set_block_data>
  80302a:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80302d:	8b 45 10             	mov    0x10(%ebp),%eax
  803030:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803033:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803037:	74 06                	je     80303f <merging+0x1c6>
  803039:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80303d:	75 17                	jne    803056 <merging+0x1dd>
  80303f:	83 ec 04             	sub    $0x4,%esp
  803042:	68 74 45 80 00       	push   $0x804574
  803047:	68 8d 01 00 00       	push   $0x18d
  80304c:	68 cd 44 80 00       	push   $0x8044cd
  803051:	e8 18 d2 ff ff       	call   80026e <_panic>
  803056:	8b 45 0c             	mov    0xc(%ebp),%eax
  803059:	8b 50 04             	mov    0x4(%eax),%edx
  80305c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80305f:	89 50 04             	mov    %edx,0x4(%eax)
  803062:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803065:	8b 55 0c             	mov    0xc(%ebp),%edx
  803068:	89 10                	mov    %edx,(%eax)
  80306a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80306d:	8b 40 04             	mov    0x4(%eax),%eax
  803070:	85 c0                	test   %eax,%eax
  803072:	74 0d                	je     803081 <merging+0x208>
  803074:	8b 45 0c             	mov    0xc(%ebp),%eax
  803077:	8b 40 04             	mov    0x4(%eax),%eax
  80307a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80307d:	89 10                	mov    %edx,(%eax)
  80307f:	eb 08                	jmp    803089 <merging+0x210>
  803081:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803084:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803089:	8b 45 0c             	mov    0xc(%ebp),%eax
  80308c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80308f:	89 50 04             	mov    %edx,0x4(%eax)
  803092:	a1 38 50 80 00       	mov    0x805038,%eax
  803097:	40                   	inc    %eax
  803098:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  80309d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030a1:	75 17                	jne    8030ba <merging+0x241>
  8030a3:	83 ec 04             	sub    $0x4,%esp
  8030a6:	68 af 44 80 00       	push   $0x8044af
  8030ab:	68 8e 01 00 00       	push   $0x18e
  8030b0:	68 cd 44 80 00       	push   $0x8044cd
  8030b5:	e8 b4 d1 ff ff       	call   80026e <_panic>
  8030ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030bd:	8b 00                	mov    (%eax),%eax
  8030bf:	85 c0                	test   %eax,%eax
  8030c1:	74 10                	je     8030d3 <merging+0x25a>
  8030c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030c6:	8b 00                	mov    (%eax),%eax
  8030c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030cb:	8b 52 04             	mov    0x4(%edx),%edx
  8030ce:	89 50 04             	mov    %edx,0x4(%eax)
  8030d1:	eb 0b                	jmp    8030de <merging+0x265>
  8030d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d6:	8b 40 04             	mov    0x4(%eax),%eax
  8030d9:	a3 30 50 80 00       	mov    %eax,0x805030
  8030de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030e1:	8b 40 04             	mov    0x4(%eax),%eax
  8030e4:	85 c0                	test   %eax,%eax
  8030e6:	74 0f                	je     8030f7 <merging+0x27e>
  8030e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030eb:	8b 40 04             	mov    0x4(%eax),%eax
  8030ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030f1:	8b 12                	mov    (%edx),%edx
  8030f3:	89 10                	mov    %edx,(%eax)
  8030f5:	eb 0a                	jmp    803101 <merging+0x288>
  8030f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030fa:	8b 00                	mov    (%eax),%eax
  8030fc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803101:	8b 45 0c             	mov    0xc(%ebp),%eax
  803104:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80310a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80310d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803114:	a1 38 50 80 00       	mov    0x805038,%eax
  803119:	48                   	dec    %eax
  80311a:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80311f:	e9 72 01 00 00       	jmp    803296 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803124:	8b 45 10             	mov    0x10(%ebp),%eax
  803127:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80312a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80312e:	74 79                	je     8031a9 <merging+0x330>
  803130:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803134:	74 73                	je     8031a9 <merging+0x330>
  803136:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80313a:	74 06                	je     803142 <merging+0x2c9>
  80313c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803140:	75 17                	jne    803159 <merging+0x2e0>
  803142:	83 ec 04             	sub    $0x4,%esp
  803145:	68 40 45 80 00       	push   $0x804540
  80314a:	68 94 01 00 00       	push   $0x194
  80314f:	68 cd 44 80 00       	push   $0x8044cd
  803154:	e8 15 d1 ff ff       	call   80026e <_panic>
  803159:	8b 45 08             	mov    0x8(%ebp),%eax
  80315c:	8b 10                	mov    (%eax),%edx
  80315e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803161:	89 10                	mov    %edx,(%eax)
  803163:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803166:	8b 00                	mov    (%eax),%eax
  803168:	85 c0                	test   %eax,%eax
  80316a:	74 0b                	je     803177 <merging+0x2fe>
  80316c:	8b 45 08             	mov    0x8(%ebp),%eax
  80316f:	8b 00                	mov    (%eax),%eax
  803171:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803174:	89 50 04             	mov    %edx,0x4(%eax)
  803177:	8b 45 08             	mov    0x8(%ebp),%eax
  80317a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80317d:	89 10                	mov    %edx,(%eax)
  80317f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803182:	8b 55 08             	mov    0x8(%ebp),%edx
  803185:	89 50 04             	mov    %edx,0x4(%eax)
  803188:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80318b:	8b 00                	mov    (%eax),%eax
  80318d:	85 c0                	test   %eax,%eax
  80318f:	75 08                	jne    803199 <merging+0x320>
  803191:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803194:	a3 30 50 80 00       	mov    %eax,0x805030
  803199:	a1 38 50 80 00       	mov    0x805038,%eax
  80319e:	40                   	inc    %eax
  80319f:	a3 38 50 80 00       	mov    %eax,0x805038
  8031a4:	e9 ce 00 00 00       	jmp    803277 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8031a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ad:	74 65                	je     803214 <merging+0x39b>
  8031af:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031b3:	75 17                	jne    8031cc <merging+0x353>
  8031b5:	83 ec 04             	sub    $0x4,%esp
  8031b8:	68 1c 45 80 00       	push   $0x80451c
  8031bd:	68 95 01 00 00       	push   $0x195
  8031c2:	68 cd 44 80 00       	push   $0x8044cd
  8031c7:	e8 a2 d0 ff ff       	call   80026e <_panic>
  8031cc:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8031d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031d5:	89 50 04             	mov    %edx,0x4(%eax)
  8031d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031db:	8b 40 04             	mov    0x4(%eax),%eax
  8031de:	85 c0                	test   %eax,%eax
  8031e0:	74 0c                	je     8031ee <merging+0x375>
  8031e2:	a1 30 50 80 00       	mov    0x805030,%eax
  8031e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031ea:	89 10                	mov    %edx,(%eax)
  8031ec:	eb 08                	jmp    8031f6 <merging+0x37d>
  8031ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f9:	a3 30 50 80 00       	mov    %eax,0x805030
  8031fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803201:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803207:	a1 38 50 80 00       	mov    0x805038,%eax
  80320c:	40                   	inc    %eax
  80320d:	a3 38 50 80 00       	mov    %eax,0x805038
  803212:	eb 63                	jmp    803277 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803214:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803218:	75 17                	jne    803231 <merging+0x3b8>
  80321a:	83 ec 04             	sub    $0x4,%esp
  80321d:	68 e8 44 80 00       	push   $0x8044e8
  803222:	68 98 01 00 00       	push   $0x198
  803227:	68 cd 44 80 00       	push   $0x8044cd
  80322c:	e8 3d d0 ff ff       	call   80026e <_panic>
  803231:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803237:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80323a:	89 10                	mov    %edx,(%eax)
  80323c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80323f:	8b 00                	mov    (%eax),%eax
  803241:	85 c0                	test   %eax,%eax
  803243:	74 0d                	je     803252 <merging+0x3d9>
  803245:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80324a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80324d:	89 50 04             	mov    %edx,0x4(%eax)
  803250:	eb 08                	jmp    80325a <merging+0x3e1>
  803252:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803255:	a3 30 50 80 00       	mov    %eax,0x805030
  80325a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80325d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803262:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803265:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80326c:	a1 38 50 80 00       	mov    0x805038,%eax
  803271:	40                   	inc    %eax
  803272:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803277:	83 ec 0c             	sub    $0xc,%esp
  80327a:	ff 75 10             	pushl  0x10(%ebp)
  80327d:	e8 f9 ed ff ff       	call   80207b <get_block_size>
  803282:	83 c4 10             	add    $0x10,%esp
  803285:	83 ec 04             	sub    $0x4,%esp
  803288:	6a 00                	push   $0x0
  80328a:	50                   	push   %eax
  80328b:	ff 75 10             	pushl  0x10(%ebp)
  80328e:	e8 39 f1 ff ff       	call   8023cc <set_block_data>
  803293:	83 c4 10             	add    $0x10,%esp
	}
}
  803296:	90                   	nop
  803297:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80329a:	c9                   	leave  
  80329b:	c3                   	ret    

0080329c <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80329c:	55                   	push   %ebp
  80329d:	89 e5                	mov    %esp,%ebp
  80329f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8032a2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032a7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8032aa:	a1 30 50 80 00       	mov    0x805030,%eax
  8032af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032b2:	73 1b                	jae    8032cf <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8032b4:	a1 30 50 80 00       	mov    0x805030,%eax
  8032b9:	83 ec 04             	sub    $0x4,%esp
  8032bc:	ff 75 08             	pushl  0x8(%ebp)
  8032bf:	6a 00                	push   $0x0
  8032c1:	50                   	push   %eax
  8032c2:	e8 b2 fb ff ff       	call   802e79 <merging>
  8032c7:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032ca:	e9 8b 00 00 00       	jmp    80335a <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8032cf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032d4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032d7:	76 18                	jbe    8032f1 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8032d9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032de:	83 ec 04             	sub    $0x4,%esp
  8032e1:	ff 75 08             	pushl  0x8(%ebp)
  8032e4:	50                   	push   %eax
  8032e5:	6a 00                	push   $0x0
  8032e7:	e8 8d fb ff ff       	call   802e79 <merging>
  8032ec:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032ef:	eb 69                	jmp    80335a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8032f1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032f9:	eb 39                	jmp    803334 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8032fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  803301:	73 29                	jae    80332c <free_block+0x90>
  803303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803306:	8b 00                	mov    (%eax),%eax
  803308:	3b 45 08             	cmp    0x8(%ebp),%eax
  80330b:	76 1f                	jbe    80332c <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80330d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803310:	8b 00                	mov    (%eax),%eax
  803312:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803315:	83 ec 04             	sub    $0x4,%esp
  803318:	ff 75 08             	pushl  0x8(%ebp)
  80331b:	ff 75 f0             	pushl  -0x10(%ebp)
  80331e:	ff 75 f4             	pushl  -0xc(%ebp)
  803321:	e8 53 fb ff ff       	call   802e79 <merging>
  803326:	83 c4 10             	add    $0x10,%esp
			break;
  803329:	90                   	nop
		}
	}
}
  80332a:	eb 2e                	jmp    80335a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80332c:	a1 34 50 80 00       	mov    0x805034,%eax
  803331:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803334:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803338:	74 07                	je     803341 <free_block+0xa5>
  80333a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333d:	8b 00                	mov    (%eax),%eax
  80333f:	eb 05                	jmp    803346 <free_block+0xaa>
  803341:	b8 00 00 00 00       	mov    $0x0,%eax
  803346:	a3 34 50 80 00       	mov    %eax,0x805034
  80334b:	a1 34 50 80 00       	mov    0x805034,%eax
  803350:	85 c0                	test   %eax,%eax
  803352:	75 a7                	jne    8032fb <free_block+0x5f>
  803354:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803358:	75 a1                	jne    8032fb <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80335a:	90                   	nop
  80335b:	c9                   	leave  
  80335c:	c3                   	ret    

0080335d <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80335d:	55                   	push   %ebp
  80335e:	89 e5                	mov    %esp,%ebp
  803360:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803363:	ff 75 08             	pushl  0x8(%ebp)
  803366:	e8 10 ed ff ff       	call   80207b <get_block_size>
  80336b:	83 c4 04             	add    $0x4,%esp
  80336e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803371:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803378:	eb 17                	jmp    803391 <copy_data+0x34>
  80337a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80337d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803380:	01 c2                	add    %eax,%edx
  803382:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803385:	8b 45 08             	mov    0x8(%ebp),%eax
  803388:	01 c8                	add    %ecx,%eax
  80338a:	8a 00                	mov    (%eax),%al
  80338c:	88 02                	mov    %al,(%edx)
  80338e:	ff 45 fc             	incl   -0x4(%ebp)
  803391:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803394:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803397:	72 e1                	jb     80337a <copy_data+0x1d>
}
  803399:	90                   	nop
  80339a:	c9                   	leave  
  80339b:	c3                   	ret    

0080339c <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80339c:	55                   	push   %ebp
  80339d:	89 e5                	mov    %esp,%ebp
  80339f:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8033a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033a6:	75 23                	jne    8033cb <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8033a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033ac:	74 13                	je     8033c1 <realloc_block_FF+0x25>
  8033ae:	83 ec 0c             	sub    $0xc,%esp
  8033b1:	ff 75 0c             	pushl  0xc(%ebp)
  8033b4:	e8 42 f0 ff ff       	call   8023fb <alloc_block_FF>
  8033b9:	83 c4 10             	add    $0x10,%esp
  8033bc:	e9 e4 06 00 00       	jmp    803aa5 <realloc_block_FF+0x709>
		return NULL;
  8033c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c6:	e9 da 06 00 00       	jmp    803aa5 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  8033cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033cf:	75 18                	jne    8033e9 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8033d1:	83 ec 0c             	sub    $0xc,%esp
  8033d4:	ff 75 08             	pushl  0x8(%ebp)
  8033d7:	e8 c0 fe ff ff       	call   80329c <free_block>
  8033dc:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8033df:	b8 00 00 00 00       	mov    $0x0,%eax
  8033e4:	e9 bc 06 00 00       	jmp    803aa5 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  8033e9:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8033ed:	77 07                	ja     8033f6 <realloc_block_FF+0x5a>
  8033ef:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8033f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f9:	83 e0 01             	and    $0x1,%eax
  8033fc:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8033ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803402:	83 c0 08             	add    $0x8,%eax
  803405:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803408:	83 ec 0c             	sub    $0xc,%esp
  80340b:	ff 75 08             	pushl  0x8(%ebp)
  80340e:	e8 68 ec ff ff       	call   80207b <get_block_size>
  803413:	83 c4 10             	add    $0x10,%esp
  803416:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803419:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80341c:	83 e8 08             	sub    $0x8,%eax
  80341f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803422:	8b 45 08             	mov    0x8(%ebp),%eax
  803425:	83 e8 04             	sub    $0x4,%eax
  803428:	8b 00                	mov    (%eax),%eax
  80342a:	83 e0 fe             	and    $0xfffffffe,%eax
  80342d:	89 c2                	mov    %eax,%edx
  80342f:	8b 45 08             	mov    0x8(%ebp),%eax
  803432:	01 d0                	add    %edx,%eax
  803434:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803437:	83 ec 0c             	sub    $0xc,%esp
  80343a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80343d:	e8 39 ec ff ff       	call   80207b <get_block_size>
  803442:	83 c4 10             	add    $0x10,%esp
  803445:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803448:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80344b:	83 e8 08             	sub    $0x8,%eax
  80344e:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803451:	8b 45 0c             	mov    0xc(%ebp),%eax
  803454:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803457:	75 08                	jne    803461 <realloc_block_FF+0xc5>
	{
		 return va;
  803459:	8b 45 08             	mov    0x8(%ebp),%eax
  80345c:	e9 44 06 00 00       	jmp    803aa5 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803461:	8b 45 0c             	mov    0xc(%ebp),%eax
  803464:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803467:	0f 83 d5 03 00 00    	jae    803842 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80346d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803470:	2b 45 0c             	sub    0xc(%ebp),%eax
  803473:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803476:	83 ec 0c             	sub    $0xc,%esp
  803479:	ff 75 e4             	pushl  -0x1c(%ebp)
  80347c:	e8 13 ec ff ff       	call   802094 <is_free_block>
  803481:	83 c4 10             	add    $0x10,%esp
  803484:	84 c0                	test   %al,%al
  803486:	0f 84 3b 01 00 00    	je     8035c7 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80348c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80348f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803492:	01 d0                	add    %edx,%eax
  803494:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803497:	83 ec 04             	sub    $0x4,%esp
  80349a:	6a 01                	push   $0x1
  80349c:	ff 75 f0             	pushl  -0x10(%ebp)
  80349f:	ff 75 08             	pushl  0x8(%ebp)
  8034a2:	e8 25 ef ff ff       	call   8023cc <set_block_data>
  8034a7:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8034aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ad:	83 e8 04             	sub    $0x4,%eax
  8034b0:	8b 00                	mov    (%eax),%eax
  8034b2:	83 e0 fe             	and    $0xfffffffe,%eax
  8034b5:	89 c2                	mov    %eax,%edx
  8034b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ba:	01 d0                	add    %edx,%eax
  8034bc:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8034bf:	83 ec 04             	sub    $0x4,%esp
  8034c2:	6a 00                	push   $0x0
  8034c4:	ff 75 cc             	pushl  -0x34(%ebp)
  8034c7:	ff 75 c8             	pushl  -0x38(%ebp)
  8034ca:	e8 fd ee ff ff       	call   8023cc <set_block_data>
  8034cf:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8034d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034d6:	74 06                	je     8034de <realloc_block_FF+0x142>
  8034d8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8034dc:	75 17                	jne    8034f5 <realloc_block_FF+0x159>
  8034de:	83 ec 04             	sub    $0x4,%esp
  8034e1:	68 40 45 80 00       	push   $0x804540
  8034e6:	68 f6 01 00 00       	push   $0x1f6
  8034eb:	68 cd 44 80 00       	push   $0x8044cd
  8034f0:	e8 79 cd ff ff       	call   80026e <_panic>
  8034f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f8:	8b 10                	mov    (%eax),%edx
  8034fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034fd:	89 10                	mov    %edx,(%eax)
  8034ff:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803502:	8b 00                	mov    (%eax),%eax
  803504:	85 c0                	test   %eax,%eax
  803506:	74 0b                	je     803513 <realloc_block_FF+0x177>
  803508:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80350b:	8b 00                	mov    (%eax),%eax
  80350d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803510:	89 50 04             	mov    %edx,0x4(%eax)
  803513:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803516:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803519:	89 10                	mov    %edx,(%eax)
  80351b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80351e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803521:	89 50 04             	mov    %edx,0x4(%eax)
  803524:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803527:	8b 00                	mov    (%eax),%eax
  803529:	85 c0                	test   %eax,%eax
  80352b:	75 08                	jne    803535 <realloc_block_FF+0x199>
  80352d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803530:	a3 30 50 80 00       	mov    %eax,0x805030
  803535:	a1 38 50 80 00       	mov    0x805038,%eax
  80353a:	40                   	inc    %eax
  80353b:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803540:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803544:	75 17                	jne    80355d <realloc_block_FF+0x1c1>
  803546:	83 ec 04             	sub    $0x4,%esp
  803549:	68 af 44 80 00       	push   $0x8044af
  80354e:	68 f7 01 00 00       	push   $0x1f7
  803553:	68 cd 44 80 00       	push   $0x8044cd
  803558:	e8 11 cd ff ff       	call   80026e <_panic>
  80355d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803560:	8b 00                	mov    (%eax),%eax
  803562:	85 c0                	test   %eax,%eax
  803564:	74 10                	je     803576 <realloc_block_FF+0x1da>
  803566:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803569:	8b 00                	mov    (%eax),%eax
  80356b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80356e:	8b 52 04             	mov    0x4(%edx),%edx
  803571:	89 50 04             	mov    %edx,0x4(%eax)
  803574:	eb 0b                	jmp    803581 <realloc_block_FF+0x1e5>
  803576:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803579:	8b 40 04             	mov    0x4(%eax),%eax
  80357c:	a3 30 50 80 00       	mov    %eax,0x805030
  803581:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803584:	8b 40 04             	mov    0x4(%eax),%eax
  803587:	85 c0                	test   %eax,%eax
  803589:	74 0f                	je     80359a <realloc_block_FF+0x1fe>
  80358b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80358e:	8b 40 04             	mov    0x4(%eax),%eax
  803591:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803594:	8b 12                	mov    (%edx),%edx
  803596:	89 10                	mov    %edx,(%eax)
  803598:	eb 0a                	jmp    8035a4 <realloc_block_FF+0x208>
  80359a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80359d:	8b 00                	mov    (%eax),%eax
  80359f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035b7:	a1 38 50 80 00       	mov    0x805038,%eax
  8035bc:	48                   	dec    %eax
  8035bd:	a3 38 50 80 00       	mov    %eax,0x805038
  8035c2:	e9 73 02 00 00       	jmp    80383a <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  8035c7:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8035cb:	0f 86 69 02 00 00    	jbe    80383a <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8035d1:	83 ec 04             	sub    $0x4,%esp
  8035d4:	6a 01                	push   $0x1
  8035d6:	ff 75 f0             	pushl  -0x10(%ebp)
  8035d9:	ff 75 08             	pushl  0x8(%ebp)
  8035dc:	e8 eb ed ff ff       	call   8023cc <set_block_data>
  8035e1:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8035e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e7:	83 e8 04             	sub    $0x4,%eax
  8035ea:	8b 00                	mov    (%eax),%eax
  8035ec:	83 e0 fe             	and    $0xfffffffe,%eax
  8035ef:	89 c2                	mov    %eax,%edx
  8035f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f4:	01 d0                	add    %edx,%eax
  8035f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8035f9:	a1 38 50 80 00       	mov    0x805038,%eax
  8035fe:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803601:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803605:	75 68                	jne    80366f <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803607:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80360b:	75 17                	jne    803624 <realloc_block_FF+0x288>
  80360d:	83 ec 04             	sub    $0x4,%esp
  803610:	68 e8 44 80 00       	push   $0x8044e8
  803615:	68 06 02 00 00       	push   $0x206
  80361a:	68 cd 44 80 00       	push   $0x8044cd
  80361f:	e8 4a cc ff ff       	call   80026e <_panic>
  803624:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80362a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80362d:	89 10                	mov    %edx,(%eax)
  80362f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803632:	8b 00                	mov    (%eax),%eax
  803634:	85 c0                	test   %eax,%eax
  803636:	74 0d                	je     803645 <realloc_block_FF+0x2a9>
  803638:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80363d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803640:	89 50 04             	mov    %edx,0x4(%eax)
  803643:	eb 08                	jmp    80364d <realloc_block_FF+0x2b1>
  803645:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803648:	a3 30 50 80 00       	mov    %eax,0x805030
  80364d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803650:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803655:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803658:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80365f:	a1 38 50 80 00       	mov    0x805038,%eax
  803664:	40                   	inc    %eax
  803665:	a3 38 50 80 00       	mov    %eax,0x805038
  80366a:	e9 b0 01 00 00       	jmp    80381f <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80366f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803674:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803677:	76 68                	jbe    8036e1 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803679:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80367d:	75 17                	jne    803696 <realloc_block_FF+0x2fa>
  80367f:	83 ec 04             	sub    $0x4,%esp
  803682:	68 e8 44 80 00       	push   $0x8044e8
  803687:	68 0b 02 00 00       	push   $0x20b
  80368c:	68 cd 44 80 00       	push   $0x8044cd
  803691:	e8 d8 cb ff ff       	call   80026e <_panic>
  803696:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80369c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80369f:	89 10                	mov    %edx,(%eax)
  8036a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a4:	8b 00                	mov    (%eax),%eax
  8036a6:	85 c0                	test   %eax,%eax
  8036a8:	74 0d                	je     8036b7 <realloc_block_FF+0x31b>
  8036aa:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036af:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036b2:	89 50 04             	mov    %edx,0x4(%eax)
  8036b5:	eb 08                	jmp    8036bf <realloc_block_FF+0x323>
  8036b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ba:	a3 30 50 80 00       	mov    %eax,0x805030
  8036bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036d1:	a1 38 50 80 00       	mov    0x805038,%eax
  8036d6:	40                   	inc    %eax
  8036d7:	a3 38 50 80 00       	mov    %eax,0x805038
  8036dc:	e9 3e 01 00 00       	jmp    80381f <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8036e1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036e6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036e9:	73 68                	jae    803753 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036eb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036ef:	75 17                	jne    803708 <realloc_block_FF+0x36c>
  8036f1:	83 ec 04             	sub    $0x4,%esp
  8036f4:	68 1c 45 80 00       	push   $0x80451c
  8036f9:	68 10 02 00 00       	push   $0x210
  8036fe:	68 cd 44 80 00       	push   $0x8044cd
  803703:	e8 66 cb ff ff       	call   80026e <_panic>
  803708:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80370e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803711:	89 50 04             	mov    %edx,0x4(%eax)
  803714:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803717:	8b 40 04             	mov    0x4(%eax),%eax
  80371a:	85 c0                	test   %eax,%eax
  80371c:	74 0c                	je     80372a <realloc_block_FF+0x38e>
  80371e:	a1 30 50 80 00       	mov    0x805030,%eax
  803723:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803726:	89 10                	mov    %edx,(%eax)
  803728:	eb 08                	jmp    803732 <realloc_block_FF+0x396>
  80372a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80372d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803735:	a3 30 50 80 00       	mov    %eax,0x805030
  80373a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80373d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803743:	a1 38 50 80 00       	mov    0x805038,%eax
  803748:	40                   	inc    %eax
  803749:	a3 38 50 80 00       	mov    %eax,0x805038
  80374e:	e9 cc 00 00 00       	jmp    80381f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803753:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80375a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80375f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803762:	e9 8a 00 00 00       	jmp    8037f1 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80376d:	73 7a                	jae    8037e9 <realloc_block_FF+0x44d>
  80376f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803772:	8b 00                	mov    (%eax),%eax
  803774:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803777:	73 70                	jae    8037e9 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803779:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80377d:	74 06                	je     803785 <realloc_block_FF+0x3e9>
  80377f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803783:	75 17                	jne    80379c <realloc_block_FF+0x400>
  803785:	83 ec 04             	sub    $0x4,%esp
  803788:	68 40 45 80 00       	push   $0x804540
  80378d:	68 1a 02 00 00       	push   $0x21a
  803792:	68 cd 44 80 00       	push   $0x8044cd
  803797:	e8 d2 ca ff ff       	call   80026e <_panic>
  80379c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379f:	8b 10                	mov    (%eax),%edx
  8037a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a4:	89 10                	mov    %edx,(%eax)
  8037a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a9:	8b 00                	mov    (%eax),%eax
  8037ab:	85 c0                	test   %eax,%eax
  8037ad:	74 0b                	je     8037ba <realloc_block_FF+0x41e>
  8037af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b2:	8b 00                	mov    (%eax),%eax
  8037b4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037b7:	89 50 04             	mov    %edx,0x4(%eax)
  8037ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037bd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037c0:	89 10                	mov    %edx,(%eax)
  8037c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037c8:	89 50 04             	mov    %edx,0x4(%eax)
  8037cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037ce:	8b 00                	mov    (%eax),%eax
  8037d0:	85 c0                	test   %eax,%eax
  8037d2:	75 08                	jne    8037dc <realloc_block_FF+0x440>
  8037d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037d7:	a3 30 50 80 00       	mov    %eax,0x805030
  8037dc:	a1 38 50 80 00       	mov    0x805038,%eax
  8037e1:	40                   	inc    %eax
  8037e2:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8037e7:	eb 36                	jmp    80381f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8037e9:	a1 34 50 80 00       	mov    0x805034,%eax
  8037ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037f5:	74 07                	je     8037fe <realloc_block_FF+0x462>
  8037f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fa:	8b 00                	mov    (%eax),%eax
  8037fc:	eb 05                	jmp    803803 <realloc_block_FF+0x467>
  8037fe:	b8 00 00 00 00       	mov    $0x0,%eax
  803803:	a3 34 50 80 00       	mov    %eax,0x805034
  803808:	a1 34 50 80 00       	mov    0x805034,%eax
  80380d:	85 c0                	test   %eax,%eax
  80380f:	0f 85 52 ff ff ff    	jne    803767 <realloc_block_FF+0x3cb>
  803815:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803819:	0f 85 48 ff ff ff    	jne    803767 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80381f:	83 ec 04             	sub    $0x4,%esp
  803822:	6a 00                	push   $0x0
  803824:	ff 75 d8             	pushl  -0x28(%ebp)
  803827:	ff 75 d4             	pushl  -0x2c(%ebp)
  80382a:	e8 9d eb ff ff       	call   8023cc <set_block_data>
  80382f:	83 c4 10             	add    $0x10,%esp
				return va;
  803832:	8b 45 08             	mov    0x8(%ebp),%eax
  803835:	e9 6b 02 00 00       	jmp    803aa5 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  80383a:	8b 45 08             	mov    0x8(%ebp),%eax
  80383d:	e9 63 02 00 00       	jmp    803aa5 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803842:	8b 45 0c             	mov    0xc(%ebp),%eax
  803845:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803848:	0f 86 4d 02 00 00    	jbe    803a9b <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  80384e:	83 ec 0c             	sub    $0xc,%esp
  803851:	ff 75 e4             	pushl  -0x1c(%ebp)
  803854:	e8 3b e8 ff ff       	call   802094 <is_free_block>
  803859:	83 c4 10             	add    $0x10,%esp
  80385c:	84 c0                	test   %al,%al
  80385e:	0f 84 37 02 00 00    	je     803a9b <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803864:	8b 45 0c             	mov    0xc(%ebp),%eax
  803867:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80386a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80386d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803870:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803873:	76 38                	jbe    8038ad <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803875:	83 ec 0c             	sub    $0xc,%esp
  803878:	ff 75 0c             	pushl  0xc(%ebp)
  80387b:	e8 7b eb ff ff       	call   8023fb <alloc_block_FF>
  803880:	83 c4 10             	add    $0x10,%esp
  803883:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803886:	83 ec 08             	sub    $0x8,%esp
  803889:	ff 75 c0             	pushl  -0x40(%ebp)
  80388c:	ff 75 08             	pushl  0x8(%ebp)
  80388f:	e8 c9 fa ff ff       	call   80335d <copy_data>
  803894:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803897:	83 ec 0c             	sub    $0xc,%esp
  80389a:	ff 75 08             	pushl  0x8(%ebp)
  80389d:	e8 fa f9 ff ff       	call   80329c <free_block>
  8038a2:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8038a5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8038a8:	e9 f8 01 00 00       	jmp    803aa5 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8038ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038b0:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8038b3:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8038b6:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8038ba:	0f 87 a0 00 00 00    	ja     803960 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8038c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038c4:	75 17                	jne    8038dd <realloc_block_FF+0x541>
  8038c6:	83 ec 04             	sub    $0x4,%esp
  8038c9:	68 af 44 80 00       	push   $0x8044af
  8038ce:	68 38 02 00 00       	push   $0x238
  8038d3:	68 cd 44 80 00       	push   $0x8044cd
  8038d8:	e8 91 c9 ff ff       	call   80026e <_panic>
  8038dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e0:	8b 00                	mov    (%eax),%eax
  8038e2:	85 c0                	test   %eax,%eax
  8038e4:	74 10                	je     8038f6 <realloc_block_FF+0x55a>
  8038e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e9:	8b 00                	mov    (%eax),%eax
  8038eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038ee:	8b 52 04             	mov    0x4(%edx),%edx
  8038f1:	89 50 04             	mov    %edx,0x4(%eax)
  8038f4:	eb 0b                	jmp    803901 <realloc_block_FF+0x565>
  8038f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f9:	8b 40 04             	mov    0x4(%eax),%eax
  8038fc:	a3 30 50 80 00       	mov    %eax,0x805030
  803901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803904:	8b 40 04             	mov    0x4(%eax),%eax
  803907:	85 c0                	test   %eax,%eax
  803909:	74 0f                	je     80391a <realloc_block_FF+0x57e>
  80390b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80390e:	8b 40 04             	mov    0x4(%eax),%eax
  803911:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803914:	8b 12                	mov    (%edx),%edx
  803916:	89 10                	mov    %edx,(%eax)
  803918:	eb 0a                	jmp    803924 <realloc_block_FF+0x588>
  80391a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391d:	8b 00                	mov    (%eax),%eax
  80391f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803924:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803927:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80392d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803930:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803937:	a1 38 50 80 00       	mov    0x805038,%eax
  80393c:	48                   	dec    %eax
  80393d:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803942:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803945:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803948:	01 d0                	add    %edx,%eax
  80394a:	83 ec 04             	sub    $0x4,%esp
  80394d:	6a 01                	push   $0x1
  80394f:	50                   	push   %eax
  803950:	ff 75 08             	pushl  0x8(%ebp)
  803953:	e8 74 ea ff ff       	call   8023cc <set_block_data>
  803958:	83 c4 10             	add    $0x10,%esp
  80395b:	e9 36 01 00 00       	jmp    803a96 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803960:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803963:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803966:	01 d0                	add    %edx,%eax
  803968:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80396b:	83 ec 04             	sub    $0x4,%esp
  80396e:	6a 01                	push   $0x1
  803970:	ff 75 f0             	pushl  -0x10(%ebp)
  803973:	ff 75 08             	pushl  0x8(%ebp)
  803976:	e8 51 ea ff ff       	call   8023cc <set_block_data>
  80397b:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80397e:	8b 45 08             	mov    0x8(%ebp),%eax
  803981:	83 e8 04             	sub    $0x4,%eax
  803984:	8b 00                	mov    (%eax),%eax
  803986:	83 e0 fe             	and    $0xfffffffe,%eax
  803989:	89 c2                	mov    %eax,%edx
  80398b:	8b 45 08             	mov    0x8(%ebp),%eax
  80398e:	01 d0                	add    %edx,%eax
  803990:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803993:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803997:	74 06                	je     80399f <realloc_block_FF+0x603>
  803999:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80399d:	75 17                	jne    8039b6 <realloc_block_FF+0x61a>
  80399f:	83 ec 04             	sub    $0x4,%esp
  8039a2:	68 40 45 80 00       	push   $0x804540
  8039a7:	68 44 02 00 00       	push   $0x244
  8039ac:	68 cd 44 80 00       	push   $0x8044cd
  8039b1:	e8 b8 c8 ff ff       	call   80026e <_panic>
  8039b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b9:	8b 10                	mov    (%eax),%edx
  8039bb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039be:	89 10                	mov    %edx,(%eax)
  8039c0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039c3:	8b 00                	mov    (%eax),%eax
  8039c5:	85 c0                	test   %eax,%eax
  8039c7:	74 0b                	je     8039d4 <realloc_block_FF+0x638>
  8039c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039cc:	8b 00                	mov    (%eax),%eax
  8039ce:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8039d1:	89 50 04             	mov    %edx,0x4(%eax)
  8039d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8039da:	89 10                	mov    %edx,(%eax)
  8039dc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039e2:	89 50 04             	mov    %edx,0x4(%eax)
  8039e5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039e8:	8b 00                	mov    (%eax),%eax
  8039ea:	85 c0                	test   %eax,%eax
  8039ec:	75 08                	jne    8039f6 <realloc_block_FF+0x65a>
  8039ee:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039f1:	a3 30 50 80 00       	mov    %eax,0x805030
  8039f6:	a1 38 50 80 00       	mov    0x805038,%eax
  8039fb:	40                   	inc    %eax
  8039fc:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a05:	75 17                	jne    803a1e <realloc_block_FF+0x682>
  803a07:	83 ec 04             	sub    $0x4,%esp
  803a0a:	68 af 44 80 00       	push   $0x8044af
  803a0f:	68 45 02 00 00       	push   $0x245
  803a14:	68 cd 44 80 00       	push   $0x8044cd
  803a19:	e8 50 c8 ff ff       	call   80026e <_panic>
  803a1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a21:	8b 00                	mov    (%eax),%eax
  803a23:	85 c0                	test   %eax,%eax
  803a25:	74 10                	je     803a37 <realloc_block_FF+0x69b>
  803a27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a2a:	8b 00                	mov    (%eax),%eax
  803a2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a2f:	8b 52 04             	mov    0x4(%edx),%edx
  803a32:	89 50 04             	mov    %edx,0x4(%eax)
  803a35:	eb 0b                	jmp    803a42 <realloc_block_FF+0x6a6>
  803a37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a3a:	8b 40 04             	mov    0x4(%eax),%eax
  803a3d:	a3 30 50 80 00       	mov    %eax,0x805030
  803a42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a45:	8b 40 04             	mov    0x4(%eax),%eax
  803a48:	85 c0                	test   %eax,%eax
  803a4a:	74 0f                	je     803a5b <realloc_block_FF+0x6bf>
  803a4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4f:	8b 40 04             	mov    0x4(%eax),%eax
  803a52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a55:	8b 12                	mov    (%edx),%edx
  803a57:	89 10                	mov    %edx,(%eax)
  803a59:	eb 0a                	jmp    803a65 <realloc_block_FF+0x6c9>
  803a5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a5e:	8b 00                	mov    (%eax),%eax
  803a60:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a78:	a1 38 50 80 00       	mov    0x805038,%eax
  803a7d:	48                   	dec    %eax
  803a7e:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803a83:	83 ec 04             	sub    $0x4,%esp
  803a86:	6a 00                	push   $0x0
  803a88:	ff 75 bc             	pushl  -0x44(%ebp)
  803a8b:	ff 75 b8             	pushl  -0x48(%ebp)
  803a8e:	e8 39 e9 ff ff       	call   8023cc <set_block_data>
  803a93:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803a96:	8b 45 08             	mov    0x8(%ebp),%eax
  803a99:	eb 0a                	jmp    803aa5 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803a9b:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803aa2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803aa5:	c9                   	leave  
  803aa6:	c3                   	ret    

00803aa7 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803aa7:	55                   	push   %ebp
  803aa8:	89 e5                	mov    %esp,%ebp
  803aaa:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803aad:	83 ec 04             	sub    $0x4,%esp
  803ab0:	68 ac 45 80 00       	push   $0x8045ac
  803ab5:	68 58 02 00 00       	push   $0x258
  803aba:	68 cd 44 80 00       	push   $0x8044cd
  803abf:	e8 aa c7 ff ff       	call   80026e <_panic>

00803ac4 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803ac4:	55                   	push   %ebp
  803ac5:	89 e5                	mov    %esp,%ebp
  803ac7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803aca:	83 ec 04             	sub    $0x4,%esp
  803acd:	68 d4 45 80 00       	push   $0x8045d4
  803ad2:	68 61 02 00 00       	push   $0x261
  803ad7:	68 cd 44 80 00       	push   $0x8044cd
  803adc:	e8 8d c7 ff ff       	call   80026e <_panic>
  803ae1:	66 90                	xchg   %ax,%ax
  803ae3:	90                   	nop

00803ae4 <__udivdi3>:
  803ae4:	55                   	push   %ebp
  803ae5:	57                   	push   %edi
  803ae6:	56                   	push   %esi
  803ae7:	53                   	push   %ebx
  803ae8:	83 ec 1c             	sub    $0x1c,%esp
  803aeb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803aef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803af3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803af7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803afb:	89 ca                	mov    %ecx,%edx
  803afd:	89 f8                	mov    %edi,%eax
  803aff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b03:	85 f6                	test   %esi,%esi
  803b05:	75 2d                	jne    803b34 <__udivdi3+0x50>
  803b07:	39 cf                	cmp    %ecx,%edi
  803b09:	77 65                	ja     803b70 <__udivdi3+0x8c>
  803b0b:	89 fd                	mov    %edi,%ebp
  803b0d:	85 ff                	test   %edi,%edi
  803b0f:	75 0b                	jne    803b1c <__udivdi3+0x38>
  803b11:	b8 01 00 00 00       	mov    $0x1,%eax
  803b16:	31 d2                	xor    %edx,%edx
  803b18:	f7 f7                	div    %edi
  803b1a:	89 c5                	mov    %eax,%ebp
  803b1c:	31 d2                	xor    %edx,%edx
  803b1e:	89 c8                	mov    %ecx,%eax
  803b20:	f7 f5                	div    %ebp
  803b22:	89 c1                	mov    %eax,%ecx
  803b24:	89 d8                	mov    %ebx,%eax
  803b26:	f7 f5                	div    %ebp
  803b28:	89 cf                	mov    %ecx,%edi
  803b2a:	89 fa                	mov    %edi,%edx
  803b2c:	83 c4 1c             	add    $0x1c,%esp
  803b2f:	5b                   	pop    %ebx
  803b30:	5e                   	pop    %esi
  803b31:	5f                   	pop    %edi
  803b32:	5d                   	pop    %ebp
  803b33:	c3                   	ret    
  803b34:	39 ce                	cmp    %ecx,%esi
  803b36:	77 28                	ja     803b60 <__udivdi3+0x7c>
  803b38:	0f bd fe             	bsr    %esi,%edi
  803b3b:	83 f7 1f             	xor    $0x1f,%edi
  803b3e:	75 40                	jne    803b80 <__udivdi3+0x9c>
  803b40:	39 ce                	cmp    %ecx,%esi
  803b42:	72 0a                	jb     803b4e <__udivdi3+0x6a>
  803b44:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b48:	0f 87 9e 00 00 00    	ja     803bec <__udivdi3+0x108>
  803b4e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b53:	89 fa                	mov    %edi,%edx
  803b55:	83 c4 1c             	add    $0x1c,%esp
  803b58:	5b                   	pop    %ebx
  803b59:	5e                   	pop    %esi
  803b5a:	5f                   	pop    %edi
  803b5b:	5d                   	pop    %ebp
  803b5c:	c3                   	ret    
  803b5d:	8d 76 00             	lea    0x0(%esi),%esi
  803b60:	31 ff                	xor    %edi,%edi
  803b62:	31 c0                	xor    %eax,%eax
  803b64:	89 fa                	mov    %edi,%edx
  803b66:	83 c4 1c             	add    $0x1c,%esp
  803b69:	5b                   	pop    %ebx
  803b6a:	5e                   	pop    %esi
  803b6b:	5f                   	pop    %edi
  803b6c:	5d                   	pop    %ebp
  803b6d:	c3                   	ret    
  803b6e:	66 90                	xchg   %ax,%ax
  803b70:	89 d8                	mov    %ebx,%eax
  803b72:	f7 f7                	div    %edi
  803b74:	31 ff                	xor    %edi,%edi
  803b76:	89 fa                	mov    %edi,%edx
  803b78:	83 c4 1c             	add    $0x1c,%esp
  803b7b:	5b                   	pop    %ebx
  803b7c:	5e                   	pop    %esi
  803b7d:	5f                   	pop    %edi
  803b7e:	5d                   	pop    %ebp
  803b7f:	c3                   	ret    
  803b80:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b85:	89 eb                	mov    %ebp,%ebx
  803b87:	29 fb                	sub    %edi,%ebx
  803b89:	89 f9                	mov    %edi,%ecx
  803b8b:	d3 e6                	shl    %cl,%esi
  803b8d:	89 c5                	mov    %eax,%ebp
  803b8f:	88 d9                	mov    %bl,%cl
  803b91:	d3 ed                	shr    %cl,%ebp
  803b93:	89 e9                	mov    %ebp,%ecx
  803b95:	09 f1                	or     %esi,%ecx
  803b97:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b9b:	89 f9                	mov    %edi,%ecx
  803b9d:	d3 e0                	shl    %cl,%eax
  803b9f:	89 c5                	mov    %eax,%ebp
  803ba1:	89 d6                	mov    %edx,%esi
  803ba3:	88 d9                	mov    %bl,%cl
  803ba5:	d3 ee                	shr    %cl,%esi
  803ba7:	89 f9                	mov    %edi,%ecx
  803ba9:	d3 e2                	shl    %cl,%edx
  803bab:	8b 44 24 08          	mov    0x8(%esp),%eax
  803baf:	88 d9                	mov    %bl,%cl
  803bb1:	d3 e8                	shr    %cl,%eax
  803bb3:	09 c2                	or     %eax,%edx
  803bb5:	89 d0                	mov    %edx,%eax
  803bb7:	89 f2                	mov    %esi,%edx
  803bb9:	f7 74 24 0c          	divl   0xc(%esp)
  803bbd:	89 d6                	mov    %edx,%esi
  803bbf:	89 c3                	mov    %eax,%ebx
  803bc1:	f7 e5                	mul    %ebp
  803bc3:	39 d6                	cmp    %edx,%esi
  803bc5:	72 19                	jb     803be0 <__udivdi3+0xfc>
  803bc7:	74 0b                	je     803bd4 <__udivdi3+0xf0>
  803bc9:	89 d8                	mov    %ebx,%eax
  803bcb:	31 ff                	xor    %edi,%edi
  803bcd:	e9 58 ff ff ff       	jmp    803b2a <__udivdi3+0x46>
  803bd2:	66 90                	xchg   %ax,%ax
  803bd4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bd8:	89 f9                	mov    %edi,%ecx
  803bda:	d3 e2                	shl    %cl,%edx
  803bdc:	39 c2                	cmp    %eax,%edx
  803bde:	73 e9                	jae    803bc9 <__udivdi3+0xe5>
  803be0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803be3:	31 ff                	xor    %edi,%edi
  803be5:	e9 40 ff ff ff       	jmp    803b2a <__udivdi3+0x46>
  803bea:	66 90                	xchg   %ax,%ax
  803bec:	31 c0                	xor    %eax,%eax
  803bee:	e9 37 ff ff ff       	jmp    803b2a <__udivdi3+0x46>
  803bf3:	90                   	nop

00803bf4 <__umoddi3>:
  803bf4:	55                   	push   %ebp
  803bf5:	57                   	push   %edi
  803bf6:	56                   	push   %esi
  803bf7:	53                   	push   %ebx
  803bf8:	83 ec 1c             	sub    $0x1c,%esp
  803bfb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803bff:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c07:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c0b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c0f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c13:	89 f3                	mov    %esi,%ebx
  803c15:	89 fa                	mov    %edi,%edx
  803c17:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c1b:	89 34 24             	mov    %esi,(%esp)
  803c1e:	85 c0                	test   %eax,%eax
  803c20:	75 1a                	jne    803c3c <__umoddi3+0x48>
  803c22:	39 f7                	cmp    %esi,%edi
  803c24:	0f 86 a2 00 00 00    	jbe    803ccc <__umoddi3+0xd8>
  803c2a:	89 c8                	mov    %ecx,%eax
  803c2c:	89 f2                	mov    %esi,%edx
  803c2e:	f7 f7                	div    %edi
  803c30:	89 d0                	mov    %edx,%eax
  803c32:	31 d2                	xor    %edx,%edx
  803c34:	83 c4 1c             	add    $0x1c,%esp
  803c37:	5b                   	pop    %ebx
  803c38:	5e                   	pop    %esi
  803c39:	5f                   	pop    %edi
  803c3a:	5d                   	pop    %ebp
  803c3b:	c3                   	ret    
  803c3c:	39 f0                	cmp    %esi,%eax
  803c3e:	0f 87 ac 00 00 00    	ja     803cf0 <__umoddi3+0xfc>
  803c44:	0f bd e8             	bsr    %eax,%ebp
  803c47:	83 f5 1f             	xor    $0x1f,%ebp
  803c4a:	0f 84 ac 00 00 00    	je     803cfc <__umoddi3+0x108>
  803c50:	bf 20 00 00 00       	mov    $0x20,%edi
  803c55:	29 ef                	sub    %ebp,%edi
  803c57:	89 fe                	mov    %edi,%esi
  803c59:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c5d:	89 e9                	mov    %ebp,%ecx
  803c5f:	d3 e0                	shl    %cl,%eax
  803c61:	89 d7                	mov    %edx,%edi
  803c63:	89 f1                	mov    %esi,%ecx
  803c65:	d3 ef                	shr    %cl,%edi
  803c67:	09 c7                	or     %eax,%edi
  803c69:	89 e9                	mov    %ebp,%ecx
  803c6b:	d3 e2                	shl    %cl,%edx
  803c6d:	89 14 24             	mov    %edx,(%esp)
  803c70:	89 d8                	mov    %ebx,%eax
  803c72:	d3 e0                	shl    %cl,%eax
  803c74:	89 c2                	mov    %eax,%edx
  803c76:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c7a:	d3 e0                	shl    %cl,%eax
  803c7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c80:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c84:	89 f1                	mov    %esi,%ecx
  803c86:	d3 e8                	shr    %cl,%eax
  803c88:	09 d0                	or     %edx,%eax
  803c8a:	d3 eb                	shr    %cl,%ebx
  803c8c:	89 da                	mov    %ebx,%edx
  803c8e:	f7 f7                	div    %edi
  803c90:	89 d3                	mov    %edx,%ebx
  803c92:	f7 24 24             	mull   (%esp)
  803c95:	89 c6                	mov    %eax,%esi
  803c97:	89 d1                	mov    %edx,%ecx
  803c99:	39 d3                	cmp    %edx,%ebx
  803c9b:	0f 82 87 00 00 00    	jb     803d28 <__umoddi3+0x134>
  803ca1:	0f 84 91 00 00 00    	je     803d38 <__umoddi3+0x144>
  803ca7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cab:	29 f2                	sub    %esi,%edx
  803cad:	19 cb                	sbb    %ecx,%ebx
  803caf:	89 d8                	mov    %ebx,%eax
  803cb1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803cb5:	d3 e0                	shl    %cl,%eax
  803cb7:	89 e9                	mov    %ebp,%ecx
  803cb9:	d3 ea                	shr    %cl,%edx
  803cbb:	09 d0                	or     %edx,%eax
  803cbd:	89 e9                	mov    %ebp,%ecx
  803cbf:	d3 eb                	shr    %cl,%ebx
  803cc1:	89 da                	mov    %ebx,%edx
  803cc3:	83 c4 1c             	add    $0x1c,%esp
  803cc6:	5b                   	pop    %ebx
  803cc7:	5e                   	pop    %esi
  803cc8:	5f                   	pop    %edi
  803cc9:	5d                   	pop    %ebp
  803cca:	c3                   	ret    
  803ccb:	90                   	nop
  803ccc:	89 fd                	mov    %edi,%ebp
  803cce:	85 ff                	test   %edi,%edi
  803cd0:	75 0b                	jne    803cdd <__umoddi3+0xe9>
  803cd2:	b8 01 00 00 00       	mov    $0x1,%eax
  803cd7:	31 d2                	xor    %edx,%edx
  803cd9:	f7 f7                	div    %edi
  803cdb:	89 c5                	mov    %eax,%ebp
  803cdd:	89 f0                	mov    %esi,%eax
  803cdf:	31 d2                	xor    %edx,%edx
  803ce1:	f7 f5                	div    %ebp
  803ce3:	89 c8                	mov    %ecx,%eax
  803ce5:	f7 f5                	div    %ebp
  803ce7:	89 d0                	mov    %edx,%eax
  803ce9:	e9 44 ff ff ff       	jmp    803c32 <__umoddi3+0x3e>
  803cee:	66 90                	xchg   %ax,%ax
  803cf0:	89 c8                	mov    %ecx,%eax
  803cf2:	89 f2                	mov    %esi,%edx
  803cf4:	83 c4 1c             	add    $0x1c,%esp
  803cf7:	5b                   	pop    %ebx
  803cf8:	5e                   	pop    %esi
  803cf9:	5f                   	pop    %edi
  803cfa:	5d                   	pop    %ebp
  803cfb:	c3                   	ret    
  803cfc:	3b 04 24             	cmp    (%esp),%eax
  803cff:	72 06                	jb     803d07 <__umoddi3+0x113>
  803d01:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d05:	77 0f                	ja     803d16 <__umoddi3+0x122>
  803d07:	89 f2                	mov    %esi,%edx
  803d09:	29 f9                	sub    %edi,%ecx
  803d0b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d0f:	89 14 24             	mov    %edx,(%esp)
  803d12:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d16:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d1a:	8b 14 24             	mov    (%esp),%edx
  803d1d:	83 c4 1c             	add    $0x1c,%esp
  803d20:	5b                   	pop    %ebx
  803d21:	5e                   	pop    %esi
  803d22:	5f                   	pop    %edi
  803d23:	5d                   	pop    %ebp
  803d24:	c3                   	ret    
  803d25:	8d 76 00             	lea    0x0(%esi),%esi
  803d28:	2b 04 24             	sub    (%esp),%eax
  803d2b:	19 fa                	sbb    %edi,%edx
  803d2d:	89 d1                	mov    %edx,%ecx
  803d2f:	89 c6                	mov    %eax,%esi
  803d31:	e9 71 ff ff ff       	jmp    803ca7 <__umoddi3+0xb3>
  803d36:	66 90                	xchg   %ax,%ax
  803d38:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d3c:	72 ea                	jb     803d28 <__umoddi3+0x134>
  803d3e:	89 d9                	mov    %ebx,%ecx
  803d40:	e9 62 ff ff ff       	jmp    803ca7 <__umoddi3+0xb3>
