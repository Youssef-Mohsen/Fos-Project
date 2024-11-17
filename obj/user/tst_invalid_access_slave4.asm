
obj/user/tst_invalid_access_slave4:     file format elf32-i386


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
  800031:	e8 5c 00 00 00       	call   800092 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//[4] Not in Page File, Not Stack & Not Heap
	uint32 kilo = 1024;
  80003e:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)
	{
		uint32 size = 4*kilo;
  800045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800048:	c1 e0 02             	shl    $0x2,%eax
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

		unsigned char *x = (unsigned char *)(0x00200000-PAGE_SIZE);
  80004e:	c7 45 e8 00 f0 1f 00 	movl   $0x1ff000,-0x18(%ebp)

		int i=0;
  800055:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for(;i< size+20;i++)
  80005c:	eb 0e                	jmp    80006c <_main+0x34>
		{
			x[i]=-1;
  80005e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800061:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800064:	01 d0                	add    %edx,%eax
  800066:	c6 00 ff             	movb   $0xff,(%eax)
		uint32 size = 4*kilo;

		unsigned char *x = (unsigned char *)(0x00200000-PAGE_SIZE);

		int i=0;
		for(;i< size+20;i++)
  800069:	ff 45 f4             	incl   -0xc(%ebp)
  80006c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80006f:	8d 50 14             	lea    0x14(%eax),%edx
  800072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800075:	39 c2                	cmp    %eax,%edx
  800077:	77 e5                	ja     80005e <_main+0x26>
		{
			x[i]=-1;
		}
	}

	inctst();
  800079:	e8 c9 15 00 00       	call   801647 <inctst>
	panic("tst invalid access failed: Attempt to access page that's not exist in page file, neither stack or heap.\nThe env must be killed and shouldn't return here.");
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	68 c0 1a 80 00       	push   $0x801ac0
  800086:	6a 18                	push   $0x18
  800088:	68 5c 1b 80 00       	push   $0x801b5c
  80008d:	e8 37 01 00 00       	call   8001c9 <_panic>

00800092 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800092:	55                   	push   %ebp
  800093:	89 e5                	mov    %esp,%ebp
  800095:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800098:	e8 6c 14 00 00       	call   801509 <sys_getenvindex>
  80009d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a3:	89 d0                	mov    %edx,%eax
  8000a5:	c1 e0 02             	shl    $0x2,%eax
  8000a8:	01 d0                	add    %edx,%eax
  8000aa:	01 c0                	add    %eax,%eax
  8000ac:	01 d0                	add    %edx,%eax
  8000ae:	c1 e0 02             	shl    $0x2,%eax
  8000b1:	01 d0                	add    %edx,%eax
  8000b3:	01 c0                	add    %eax,%eax
  8000b5:	01 d0                	add    %edx,%eax
  8000b7:	c1 e0 04             	shl    $0x4,%eax
  8000ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000bf:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000c4:	a1 04 30 80 00       	mov    0x803004,%eax
  8000c9:	8a 40 20             	mov    0x20(%eax),%al
  8000cc:	84 c0                	test   %al,%al
  8000ce:	74 0d                	je     8000dd <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8000d0:	a1 04 30 80 00       	mov    0x803004,%eax
  8000d5:	83 c0 20             	add    $0x20,%eax
  8000d8:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000e1:	7e 0a                	jle    8000ed <libmain+0x5b>
		binaryname = argv[0];
  8000e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000e6:	8b 00                	mov    (%eax),%eax
  8000e8:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000ed:	83 ec 08             	sub    $0x8,%esp
  8000f0:	ff 75 0c             	pushl  0xc(%ebp)
  8000f3:	ff 75 08             	pushl  0x8(%ebp)
  8000f6:	e8 3d ff ff ff       	call   800038 <_main>
  8000fb:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8000fe:	e8 8a 11 00 00       	call   80128d <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	68 98 1b 80 00       	push   $0x801b98
  80010b:	e8 76 03 00 00       	call   800486 <cprintf>
  800110:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800113:	a1 04 30 80 00       	mov    0x803004,%eax
  800118:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80011e:	a1 04 30 80 00       	mov    0x803004,%eax
  800123:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800129:	83 ec 04             	sub    $0x4,%esp
  80012c:	52                   	push   %edx
  80012d:	50                   	push   %eax
  80012e:	68 c0 1b 80 00       	push   $0x801bc0
  800133:	e8 4e 03 00 00       	call   800486 <cprintf>
  800138:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80013b:	a1 04 30 80 00       	mov    0x803004,%eax
  800140:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  800146:	a1 04 30 80 00       	mov    0x803004,%eax
  80014b:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800151:	a1 04 30 80 00       	mov    0x803004,%eax
  800156:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  80015c:	51                   	push   %ecx
  80015d:	52                   	push   %edx
  80015e:	50                   	push   %eax
  80015f:	68 e8 1b 80 00       	push   $0x801be8
  800164:	e8 1d 03 00 00       	call   800486 <cprintf>
  800169:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80016c:	a1 04 30 80 00       	mov    0x803004,%eax
  800171:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800177:	83 ec 08             	sub    $0x8,%esp
  80017a:	50                   	push   %eax
  80017b:	68 40 1c 80 00       	push   $0x801c40
  800180:	e8 01 03 00 00       	call   800486 <cprintf>
  800185:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	68 98 1b 80 00       	push   $0x801b98
  800190:	e8 f1 02 00 00       	call   800486 <cprintf>
  800195:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800198:	e8 0a 11 00 00       	call   8012a7 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80019d:	e8 19 00 00 00       	call   8001bb <exit>
}
  8001a2:	90                   	nop
  8001a3:	c9                   	leave  
  8001a4:	c3                   	ret    

008001a5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001a5:	55                   	push   %ebp
  8001a6:	89 e5                	mov    %esp,%ebp
  8001a8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	6a 00                	push   $0x0
  8001b0:	e8 20 13 00 00       	call   8014d5 <sys_destroy_env>
  8001b5:	83 c4 10             	add    $0x10,%esp
}
  8001b8:	90                   	nop
  8001b9:	c9                   	leave  
  8001ba:	c3                   	ret    

008001bb <exit>:

void
exit(void)
{
  8001bb:	55                   	push   %ebp
  8001bc:	89 e5                	mov    %esp,%ebp
  8001be:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001c1:	e8 75 13 00 00       	call   80153b <sys_exit_env>
}
  8001c6:	90                   	nop
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    

008001c9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001cf:	8d 45 10             	lea    0x10(%ebp),%eax
  8001d2:	83 c0 04             	add    $0x4,%eax
  8001d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001d8:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8001dd:	85 c0                	test   %eax,%eax
  8001df:	74 16                	je     8001f7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001e1:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8001e6:	83 ec 08             	sub    $0x8,%esp
  8001e9:	50                   	push   %eax
  8001ea:	68 54 1c 80 00       	push   $0x801c54
  8001ef:	e8 92 02 00 00       	call   800486 <cprintf>
  8001f4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001f7:	a1 00 30 80 00       	mov    0x803000,%eax
  8001fc:	ff 75 0c             	pushl  0xc(%ebp)
  8001ff:	ff 75 08             	pushl  0x8(%ebp)
  800202:	50                   	push   %eax
  800203:	68 59 1c 80 00       	push   $0x801c59
  800208:	e8 79 02 00 00       	call   800486 <cprintf>
  80020d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800210:	8b 45 10             	mov    0x10(%ebp),%eax
  800213:	83 ec 08             	sub    $0x8,%esp
  800216:	ff 75 f4             	pushl  -0xc(%ebp)
  800219:	50                   	push   %eax
  80021a:	e8 fc 01 00 00       	call   80041b <vcprintf>
  80021f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	6a 00                	push   $0x0
  800227:	68 75 1c 80 00       	push   $0x801c75
  80022c:	e8 ea 01 00 00       	call   80041b <vcprintf>
  800231:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800234:	e8 82 ff ff ff       	call   8001bb <exit>

	// should not return here
	while (1) ;
  800239:	eb fe                	jmp    800239 <_panic+0x70>

0080023b <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80023b:	55                   	push   %ebp
  80023c:	89 e5                	mov    %esp,%ebp
  80023e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800241:	a1 04 30 80 00       	mov    0x803004,%eax
  800246:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80024c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024f:	39 c2                	cmp    %eax,%edx
  800251:	74 14                	je     800267 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800253:	83 ec 04             	sub    $0x4,%esp
  800256:	68 78 1c 80 00       	push   $0x801c78
  80025b:	6a 26                	push   $0x26
  80025d:	68 c4 1c 80 00       	push   $0x801cc4
  800262:	e8 62 ff ff ff       	call   8001c9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800267:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80026e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800275:	e9 c5 00 00 00       	jmp    80033f <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80027a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80027d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800284:	8b 45 08             	mov    0x8(%ebp),%eax
  800287:	01 d0                	add    %edx,%eax
  800289:	8b 00                	mov    (%eax),%eax
  80028b:	85 c0                	test   %eax,%eax
  80028d:	75 08                	jne    800297 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80028f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800292:	e9 a5 00 00 00       	jmp    80033c <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800297:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80029e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002a5:	eb 69                	jmp    800310 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8002a7:	a1 04 30 80 00       	mov    0x803004,%eax
  8002ac:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8002b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002b5:	89 d0                	mov    %edx,%eax
  8002b7:	01 c0                	add    %eax,%eax
  8002b9:	01 d0                	add    %edx,%eax
  8002bb:	c1 e0 03             	shl    $0x3,%eax
  8002be:	01 c8                	add    %ecx,%eax
  8002c0:	8a 40 04             	mov    0x4(%eax),%al
  8002c3:	84 c0                	test   %al,%al
  8002c5:	75 46                	jne    80030d <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002c7:	a1 04 30 80 00       	mov    0x803004,%eax
  8002cc:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8002d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002d5:	89 d0                	mov    %edx,%eax
  8002d7:	01 c0                	add    %eax,%eax
  8002d9:	01 d0                	add    %edx,%eax
  8002db:	c1 e0 03             	shl    $0x3,%eax
  8002de:	01 c8                	add    %ecx,%eax
  8002e0:	8b 00                	mov    (%eax),%eax
  8002e2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002ed:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002f2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fc:	01 c8                	add    %ecx,%eax
  8002fe:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800300:	39 c2                	cmp    %eax,%edx
  800302:	75 09                	jne    80030d <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800304:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80030b:	eb 15                	jmp    800322 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80030d:	ff 45 e8             	incl   -0x18(%ebp)
  800310:	a1 04 30 80 00       	mov    0x803004,%eax
  800315:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80031b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80031e:	39 c2                	cmp    %eax,%edx
  800320:	77 85                	ja     8002a7 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800322:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800326:	75 14                	jne    80033c <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800328:	83 ec 04             	sub    $0x4,%esp
  80032b:	68 d0 1c 80 00       	push   $0x801cd0
  800330:	6a 3a                	push   $0x3a
  800332:	68 c4 1c 80 00       	push   $0x801cc4
  800337:	e8 8d fe ff ff       	call   8001c9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80033c:	ff 45 f0             	incl   -0x10(%ebp)
  80033f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800342:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800345:	0f 8c 2f ff ff ff    	jl     80027a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80034b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800352:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800359:	eb 26                	jmp    800381 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80035b:	a1 04 30 80 00       	mov    0x803004,%eax
  800360:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800366:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800369:	89 d0                	mov    %edx,%eax
  80036b:	01 c0                	add    %eax,%eax
  80036d:	01 d0                	add    %edx,%eax
  80036f:	c1 e0 03             	shl    $0x3,%eax
  800372:	01 c8                	add    %ecx,%eax
  800374:	8a 40 04             	mov    0x4(%eax),%al
  800377:	3c 01                	cmp    $0x1,%al
  800379:	75 03                	jne    80037e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80037b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80037e:	ff 45 e0             	incl   -0x20(%ebp)
  800381:	a1 04 30 80 00       	mov    0x803004,%eax
  800386:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80038c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80038f:	39 c2                	cmp    %eax,%edx
  800391:	77 c8                	ja     80035b <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800396:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800399:	74 14                	je     8003af <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80039b:	83 ec 04             	sub    $0x4,%esp
  80039e:	68 24 1d 80 00       	push   $0x801d24
  8003a3:	6a 44                	push   $0x44
  8003a5:	68 c4 1c 80 00       	push   $0x801cc4
  8003aa:	e8 1a fe ff ff       	call   8001c9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8003af:	90                   	nop
  8003b0:	c9                   	leave  
  8003b1:	c3                   	ret    

008003b2 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8003b2:	55                   	push   %ebp
  8003b3:	89 e5                	mov    %esp,%ebp
  8003b5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8003b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bb:	8b 00                	mov    (%eax),%eax
  8003bd:	8d 48 01             	lea    0x1(%eax),%ecx
  8003c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c3:	89 0a                	mov    %ecx,(%edx)
  8003c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8003c8:	88 d1                	mov    %dl,%cl
  8003ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003cd:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003db:	75 2c                	jne    800409 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003dd:	a0 08 30 80 00       	mov    0x803008,%al
  8003e2:	0f b6 c0             	movzbl %al,%eax
  8003e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003e8:	8b 12                	mov    (%edx),%edx
  8003ea:	89 d1                	mov    %edx,%ecx
  8003ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ef:	83 c2 08             	add    $0x8,%edx
  8003f2:	83 ec 04             	sub    $0x4,%esp
  8003f5:	50                   	push   %eax
  8003f6:	51                   	push   %ecx
  8003f7:	52                   	push   %edx
  8003f8:	e8 4e 0e 00 00       	call   80124b <sys_cputs>
  8003fd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800400:	8b 45 0c             	mov    0xc(%ebp),%eax
  800403:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800409:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040c:	8b 40 04             	mov    0x4(%eax),%eax
  80040f:	8d 50 01             	lea    0x1(%eax),%edx
  800412:	8b 45 0c             	mov    0xc(%ebp),%eax
  800415:	89 50 04             	mov    %edx,0x4(%eax)
}
  800418:	90                   	nop
  800419:	c9                   	leave  
  80041a:	c3                   	ret    

0080041b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80041b:	55                   	push   %ebp
  80041c:	89 e5                	mov    %esp,%ebp
  80041e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800424:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80042b:	00 00 00 
	b.cnt = 0;
  80042e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800435:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800438:	ff 75 0c             	pushl  0xc(%ebp)
  80043b:	ff 75 08             	pushl  0x8(%ebp)
  80043e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800444:	50                   	push   %eax
  800445:	68 b2 03 80 00       	push   $0x8003b2
  80044a:	e8 11 02 00 00       	call   800660 <vprintfmt>
  80044f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800452:	a0 08 30 80 00       	mov    0x803008,%al
  800457:	0f b6 c0             	movzbl %al,%eax
  80045a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800460:	83 ec 04             	sub    $0x4,%esp
  800463:	50                   	push   %eax
  800464:	52                   	push   %edx
  800465:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80046b:	83 c0 08             	add    $0x8,%eax
  80046e:	50                   	push   %eax
  80046f:	e8 d7 0d 00 00       	call   80124b <sys_cputs>
  800474:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800477:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  80047e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800484:	c9                   	leave  
  800485:	c3                   	ret    

00800486 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800486:	55                   	push   %ebp
  800487:	89 e5                	mov    %esp,%ebp
  800489:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80048c:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800493:	8d 45 0c             	lea    0xc(%ebp),%eax
  800496:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	83 ec 08             	sub    $0x8,%esp
  80049f:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a2:	50                   	push   %eax
  8004a3:	e8 73 ff ff ff       	call   80041b <vcprintf>
  8004a8:	83 c4 10             	add    $0x10,%esp
  8004ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8004ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004b1:	c9                   	leave  
  8004b2:	c3                   	ret    

008004b3 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8004b3:	55                   	push   %ebp
  8004b4:	89 e5                	mov    %esp,%ebp
  8004b6:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8004b9:	e8 cf 0d 00 00       	call   80128d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8004be:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8004c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c7:	83 ec 08             	sub    $0x8,%esp
  8004ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8004cd:	50                   	push   %eax
  8004ce:	e8 48 ff ff ff       	call   80041b <vcprintf>
  8004d3:	83 c4 10             	add    $0x10,%esp
  8004d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004d9:	e8 c9 0d 00 00       	call   8012a7 <sys_unlock_cons>
	return cnt;
  8004de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004e1:	c9                   	leave  
  8004e2:	c3                   	ret    

008004e3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	53                   	push   %ebx
  8004e7:	83 ec 14             	sub    $0x14,%esp
  8004ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004f6:	8b 45 18             	mov    0x18(%ebp),%eax
  8004f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8004fe:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800501:	77 55                	ja     800558 <printnum+0x75>
  800503:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800506:	72 05                	jb     80050d <printnum+0x2a>
  800508:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80050b:	77 4b                	ja     800558 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80050d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800510:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800513:	8b 45 18             	mov    0x18(%ebp),%eax
  800516:	ba 00 00 00 00       	mov    $0x0,%edx
  80051b:	52                   	push   %edx
  80051c:	50                   	push   %eax
  80051d:	ff 75 f4             	pushl  -0xc(%ebp)
  800520:	ff 75 f0             	pushl  -0x10(%ebp)
  800523:	e8 24 13 00 00       	call   80184c <__udivdi3>
  800528:	83 c4 10             	add    $0x10,%esp
  80052b:	83 ec 04             	sub    $0x4,%esp
  80052e:	ff 75 20             	pushl  0x20(%ebp)
  800531:	53                   	push   %ebx
  800532:	ff 75 18             	pushl  0x18(%ebp)
  800535:	52                   	push   %edx
  800536:	50                   	push   %eax
  800537:	ff 75 0c             	pushl  0xc(%ebp)
  80053a:	ff 75 08             	pushl  0x8(%ebp)
  80053d:	e8 a1 ff ff ff       	call   8004e3 <printnum>
  800542:	83 c4 20             	add    $0x20,%esp
  800545:	eb 1a                	jmp    800561 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800547:	83 ec 08             	sub    $0x8,%esp
  80054a:	ff 75 0c             	pushl  0xc(%ebp)
  80054d:	ff 75 20             	pushl  0x20(%ebp)
  800550:	8b 45 08             	mov    0x8(%ebp),%eax
  800553:	ff d0                	call   *%eax
  800555:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800558:	ff 4d 1c             	decl   0x1c(%ebp)
  80055b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80055f:	7f e6                	jg     800547 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800561:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800564:	bb 00 00 00 00       	mov    $0x0,%ebx
  800569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80056f:	53                   	push   %ebx
  800570:	51                   	push   %ecx
  800571:	52                   	push   %edx
  800572:	50                   	push   %eax
  800573:	e8 e4 13 00 00       	call   80195c <__umoddi3>
  800578:	83 c4 10             	add    $0x10,%esp
  80057b:	05 94 1f 80 00       	add    $0x801f94,%eax
  800580:	8a 00                	mov    (%eax),%al
  800582:	0f be c0             	movsbl %al,%eax
  800585:	83 ec 08             	sub    $0x8,%esp
  800588:	ff 75 0c             	pushl  0xc(%ebp)
  80058b:	50                   	push   %eax
  80058c:	8b 45 08             	mov    0x8(%ebp),%eax
  80058f:	ff d0                	call   *%eax
  800591:	83 c4 10             	add    $0x10,%esp
}
  800594:	90                   	nop
  800595:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800598:	c9                   	leave  
  800599:	c3                   	ret    

0080059a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80059a:	55                   	push   %ebp
  80059b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80059d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005a1:	7e 1c                	jle    8005bf <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8005a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a6:	8b 00                	mov    (%eax),%eax
  8005a8:	8d 50 08             	lea    0x8(%eax),%edx
  8005ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ae:	89 10                	mov    %edx,(%eax)
  8005b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b3:	8b 00                	mov    (%eax),%eax
  8005b5:	83 e8 08             	sub    $0x8,%eax
  8005b8:	8b 50 04             	mov    0x4(%eax),%edx
  8005bb:	8b 00                	mov    (%eax),%eax
  8005bd:	eb 40                	jmp    8005ff <getuint+0x65>
	else if (lflag)
  8005bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005c3:	74 1e                	je     8005e3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	8d 50 04             	lea    0x4(%eax),%edx
  8005cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d0:	89 10                	mov    %edx,(%eax)
  8005d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	83 e8 04             	sub    $0x4,%eax
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e1:	eb 1c                	jmp    8005ff <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	8d 50 04             	lea    0x4(%eax),%edx
  8005eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ee:	89 10                	mov    %edx,(%eax)
  8005f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f3:	8b 00                	mov    (%eax),%eax
  8005f5:	83 e8 04             	sub    $0x4,%eax
  8005f8:	8b 00                	mov    (%eax),%eax
  8005fa:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005ff:	5d                   	pop    %ebp
  800600:	c3                   	ret    

00800601 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800601:	55                   	push   %ebp
  800602:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800604:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800608:	7e 1c                	jle    800626 <getint+0x25>
		return va_arg(*ap, long long);
  80060a:	8b 45 08             	mov    0x8(%ebp),%eax
  80060d:	8b 00                	mov    (%eax),%eax
  80060f:	8d 50 08             	lea    0x8(%eax),%edx
  800612:	8b 45 08             	mov    0x8(%ebp),%eax
  800615:	89 10                	mov    %edx,(%eax)
  800617:	8b 45 08             	mov    0x8(%ebp),%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	83 e8 08             	sub    $0x8,%eax
  80061f:	8b 50 04             	mov    0x4(%eax),%edx
  800622:	8b 00                	mov    (%eax),%eax
  800624:	eb 38                	jmp    80065e <getint+0x5d>
	else if (lflag)
  800626:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80062a:	74 1a                	je     800646 <getint+0x45>
		return va_arg(*ap, long);
  80062c:	8b 45 08             	mov    0x8(%ebp),%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	8d 50 04             	lea    0x4(%eax),%edx
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	89 10                	mov    %edx,(%eax)
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	83 e8 04             	sub    $0x4,%eax
  800641:	8b 00                	mov    (%eax),%eax
  800643:	99                   	cltd   
  800644:	eb 18                	jmp    80065e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800646:	8b 45 08             	mov    0x8(%ebp),%eax
  800649:	8b 00                	mov    (%eax),%eax
  80064b:	8d 50 04             	lea    0x4(%eax),%edx
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	89 10                	mov    %edx,(%eax)
  800653:	8b 45 08             	mov    0x8(%ebp),%eax
  800656:	8b 00                	mov    (%eax),%eax
  800658:	83 e8 04             	sub    $0x4,%eax
  80065b:	8b 00                	mov    (%eax),%eax
  80065d:	99                   	cltd   
}
  80065e:	5d                   	pop    %ebp
  80065f:	c3                   	ret    

00800660 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800660:	55                   	push   %ebp
  800661:	89 e5                	mov    %esp,%ebp
  800663:	56                   	push   %esi
  800664:	53                   	push   %ebx
  800665:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800668:	eb 17                	jmp    800681 <vprintfmt+0x21>
			if (ch == '\0')
  80066a:	85 db                	test   %ebx,%ebx
  80066c:	0f 84 c1 03 00 00    	je     800a33 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800672:	83 ec 08             	sub    $0x8,%esp
  800675:	ff 75 0c             	pushl  0xc(%ebp)
  800678:	53                   	push   %ebx
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	ff d0                	call   *%eax
  80067e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800681:	8b 45 10             	mov    0x10(%ebp),%eax
  800684:	8d 50 01             	lea    0x1(%eax),%edx
  800687:	89 55 10             	mov    %edx,0x10(%ebp)
  80068a:	8a 00                	mov    (%eax),%al
  80068c:	0f b6 d8             	movzbl %al,%ebx
  80068f:	83 fb 25             	cmp    $0x25,%ebx
  800692:	75 d6                	jne    80066a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800694:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800698:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80069f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006a6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8006ad:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8006b7:	8d 50 01             	lea    0x1(%eax),%edx
  8006ba:	89 55 10             	mov    %edx,0x10(%ebp)
  8006bd:	8a 00                	mov    (%eax),%al
  8006bf:	0f b6 d8             	movzbl %al,%ebx
  8006c2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006c5:	83 f8 5b             	cmp    $0x5b,%eax
  8006c8:	0f 87 3d 03 00 00    	ja     800a0b <vprintfmt+0x3ab>
  8006ce:	8b 04 85 b8 1f 80 00 	mov    0x801fb8(,%eax,4),%eax
  8006d5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006d7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006db:	eb d7                	jmp    8006b4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006dd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006e1:	eb d1                	jmp    8006b4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006ed:	89 d0                	mov    %edx,%eax
  8006ef:	c1 e0 02             	shl    $0x2,%eax
  8006f2:	01 d0                	add    %edx,%eax
  8006f4:	01 c0                	add    %eax,%eax
  8006f6:	01 d8                	add    %ebx,%eax
  8006f8:	83 e8 30             	sub    $0x30,%eax
  8006fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800701:	8a 00                	mov    (%eax),%al
  800703:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800706:	83 fb 2f             	cmp    $0x2f,%ebx
  800709:	7e 3e                	jle    800749 <vprintfmt+0xe9>
  80070b:	83 fb 39             	cmp    $0x39,%ebx
  80070e:	7f 39                	jg     800749 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800710:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800713:	eb d5                	jmp    8006ea <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	83 c0 04             	add    $0x4,%eax
  80071b:	89 45 14             	mov    %eax,0x14(%ebp)
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	83 e8 04             	sub    $0x4,%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800729:	eb 1f                	jmp    80074a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80072b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80072f:	79 83                	jns    8006b4 <vprintfmt+0x54>
				width = 0;
  800731:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800738:	e9 77 ff ff ff       	jmp    8006b4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80073d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800744:	e9 6b ff ff ff       	jmp    8006b4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800749:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80074a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80074e:	0f 89 60 ff ff ff    	jns    8006b4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800754:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800757:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80075a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800761:	e9 4e ff ff ff       	jmp    8006b4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800766:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800769:	e9 46 ff ff ff       	jmp    8006b4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80076e:	8b 45 14             	mov    0x14(%ebp),%eax
  800771:	83 c0 04             	add    $0x4,%eax
  800774:	89 45 14             	mov    %eax,0x14(%ebp)
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	83 e8 04             	sub    $0x4,%eax
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	ff 75 0c             	pushl  0xc(%ebp)
  800785:	50                   	push   %eax
  800786:	8b 45 08             	mov    0x8(%ebp),%eax
  800789:	ff d0                	call   *%eax
  80078b:	83 c4 10             	add    $0x10,%esp
			break;
  80078e:	e9 9b 02 00 00       	jmp    800a2e <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800793:	8b 45 14             	mov    0x14(%ebp),%eax
  800796:	83 c0 04             	add    $0x4,%eax
  800799:	89 45 14             	mov    %eax,0x14(%ebp)
  80079c:	8b 45 14             	mov    0x14(%ebp),%eax
  80079f:	83 e8 04             	sub    $0x4,%eax
  8007a2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8007a4:	85 db                	test   %ebx,%ebx
  8007a6:	79 02                	jns    8007aa <vprintfmt+0x14a>
				err = -err;
  8007a8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007aa:	83 fb 64             	cmp    $0x64,%ebx
  8007ad:	7f 0b                	jg     8007ba <vprintfmt+0x15a>
  8007af:	8b 34 9d 00 1e 80 00 	mov    0x801e00(,%ebx,4),%esi
  8007b6:	85 f6                	test   %esi,%esi
  8007b8:	75 19                	jne    8007d3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007ba:	53                   	push   %ebx
  8007bb:	68 a5 1f 80 00       	push   $0x801fa5
  8007c0:	ff 75 0c             	pushl  0xc(%ebp)
  8007c3:	ff 75 08             	pushl  0x8(%ebp)
  8007c6:	e8 70 02 00 00       	call   800a3b <printfmt>
  8007cb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007ce:	e9 5b 02 00 00       	jmp    800a2e <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007d3:	56                   	push   %esi
  8007d4:	68 ae 1f 80 00       	push   $0x801fae
  8007d9:	ff 75 0c             	pushl  0xc(%ebp)
  8007dc:	ff 75 08             	pushl  0x8(%ebp)
  8007df:	e8 57 02 00 00       	call   800a3b <printfmt>
  8007e4:	83 c4 10             	add    $0x10,%esp
			break;
  8007e7:	e9 42 02 00 00       	jmp    800a2e <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ef:	83 c0 04             	add    $0x4,%eax
  8007f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	83 e8 04             	sub    $0x4,%eax
  8007fb:	8b 30                	mov    (%eax),%esi
  8007fd:	85 f6                	test   %esi,%esi
  8007ff:	75 05                	jne    800806 <vprintfmt+0x1a6>
				p = "(null)";
  800801:	be b1 1f 80 00       	mov    $0x801fb1,%esi
			if (width > 0 && padc != '-')
  800806:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080a:	7e 6d                	jle    800879 <vprintfmt+0x219>
  80080c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800810:	74 67                	je     800879 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800812:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	50                   	push   %eax
  800819:	56                   	push   %esi
  80081a:	e8 1e 03 00 00       	call   800b3d <strnlen>
  80081f:	83 c4 10             	add    $0x10,%esp
  800822:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800825:	eb 16                	jmp    80083d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800827:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	ff 75 0c             	pushl  0xc(%ebp)
  800831:	50                   	push   %eax
  800832:	8b 45 08             	mov    0x8(%ebp),%eax
  800835:	ff d0                	call   *%eax
  800837:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80083a:	ff 4d e4             	decl   -0x1c(%ebp)
  80083d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800841:	7f e4                	jg     800827 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800843:	eb 34                	jmp    800879 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800845:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800849:	74 1c                	je     800867 <vprintfmt+0x207>
  80084b:	83 fb 1f             	cmp    $0x1f,%ebx
  80084e:	7e 05                	jle    800855 <vprintfmt+0x1f5>
  800850:	83 fb 7e             	cmp    $0x7e,%ebx
  800853:	7e 12                	jle    800867 <vprintfmt+0x207>
					putch('?', putdat);
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	ff 75 0c             	pushl  0xc(%ebp)
  80085b:	6a 3f                	push   $0x3f
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	ff d0                	call   *%eax
  800862:	83 c4 10             	add    $0x10,%esp
  800865:	eb 0f                	jmp    800876 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800867:	83 ec 08             	sub    $0x8,%esp
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	53                   	push   %ebx
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	ff d0                	call   *%eax
  800873:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800876:	ff 4d e4             	decl   -0x1c(%ebp)
  800879:	89 f0                	mov    %esi,%eax
  80087b:	8d 70 01             	lea    0x1(%eax),%esi
  80087e:	8a 00                	mov    (%eax),%al
  800880:	0f be d8             	movsbl %al,%ebx
  800883:	85 db                	test   %ebx,%ebx
  800885:	74 24                	je     8008ab <vprintfmt+0x24b>
  800887:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80088b:	78 b8                	js     800845 <vprintfmt+0x1e5>
  80088d:	ff 4d e0             	decl   -0x20(%ebp)
  800890:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800894:	79 af                	jns    800845 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800896:	eb 13                	jmp    8008ab <vprintfmt+0x24b>
				putch(' ', putdat);
  800898:	83 ec 08             	sub    $0x8,%esp
  80089b:	ff 75 0c             	pushl  0xc(%ebp)
  80089e:	6a 20                	push   $0x20
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	ff d0                	call   *%eax
  8008a5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008a8:	ff 4d e4             	decl   -0x1c(%ebp)
  8008ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008af:	7f e7                	jg     800898 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8008b1:	e9 78 01 00 00       	jmp    800a2e <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008b6:	83 ec 08             	sub    $0x8,%esp
  8008b9:	ff 75 e8             	pushl  -0x18(%ebp)
  8008bc:	8d 45 14             	lea    0x14(%ebp),%eax
  8008bf:	50                   	push   %eax
  8008c0:	e8 3c fd ff ff       	call   800601 <getint>
  8008c5:	83 c4 10             	add    $0x10,%esp
  8008c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008d4:	85 d2                	test   %edx,%edx
  8008d6:	79 23                	jns    8008fb <vprintfmt+0x29b>
				putch('-', putdat);
  8008d8:	83 ec 08             	sub    $0x8,%esp
  8008db:	ff 75 0c             	pushl  0xc(%ebp)
  8008de:	6a 2d                	push   $0x2d
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	ff d0                	call   *%eax
  8008e5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008ee:	f7 d8                	neg    %eax
  8008f0:	83 d2 00             	adc    $0x0,%edx
  8008f3:	f7 da                	neg    %edx
  8008f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008fb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800902:	e9 bc 00 00 00       	jmp    8009c3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	ff 75 e8             	pushl  -0x18(%ebp)
  80090d:	8d 45 14             	lea    0x14(%ebp),%eax
  800910:	50                   	push   %eax
  800911:	e8 84 fc ff ff       	call   80059a <getuint>
  800916:	83 c4 10             	add    $0x10,%esp
  800919:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80091c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80091f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800926:	e9 98 00 00 00       	jmp    8009c3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	ff 75 0c             	pushl  0xc(%ebp)
  800931:	6a 58                	push   $0x58
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	ff d0                	call   *%eax
  800938:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80093b:	83 ec 08             	sub    $0x8,%esp
  80093e:	ff 75 0c             	pushl  0xc(%ebp)
  800941:	6a 58                	push   $0x58
  800943:	8b 45 08             	mov    0x8(%ebp),%eax
  800946:	ff d0                	call   *%eax
  800948:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	6a 58                	push   $0x58
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	ff d0                	call   *%eax
  800958:	83 c4 10             	add    $0x10,%esp
			break;
  80095b:	e9 ce 00 00 00       	jmp    800a2e <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800960:	83 ec 08             	sub    $0x8,%esp
  800963:	ff 75 0c             	pushl  0xc(%ebp)
  800966:	6a 30                	push   $0x30
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	ff d0                	call   *%eax
  80096d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800970:	83 ec 08             	sub    $0x8,%esp
  800973:	ff 75 0c             	pushl  0xc(%ebp)
  800976:	6a 78                	push   $0x78
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	ff d0                	call   *%eax
  80097d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800980:	8b 45 14             	mov    0x14(%ebp),%eax
  800983:	83 c0 04             	add    $0x4,%eax
  800986:	89 45 14             	mov    %eax,0x14(%ebp)
  800989:	8b 45 14             	mov    0x14(%ebp),%eax
  80098c:	83 e8 04             	sub    $0x4,%eax
  80098f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800991:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800994:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80099b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8009a2:	eb 1f                	jmp    8009c3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8009a4:	83 ec 08             	sub    $0x8,%esp
  8009a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8009aa:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ad:	50                   	push   %eax
  8009ae:	e8 e7 fb ff ff       	call   80059a <getuint>
  8009b3:	83 c4 10             	add    $0x10,%esp
  8009b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009bc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009c3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ca:	83 ec 04             	sub    $0x4,%esp
  8009cd:	52                   	push   %edx
  8009ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009d1:	50                   	push   %eax
  8009d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8009d5:	ff 75 f0             	pushl  -0x10(%ebp)
  8009d8:	ff 75 0c             	pushl  0xc(%ebp)
  8009db:	ff 75 08             	pushl  0x8(%ebp)
  8009de:	e8 00 fb ff ff       	call   8004e3 <printnum>
  8009e3:	83 c4 20             	add    $0x20,%esp
			break;
  8009e6:	eb 46                	jmp    800a2e <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	53                   	push   %ebx
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	ff d0                	call   *%eax
  8009f4:	83 c4 10             	add    $0x10,%esp
			break;
  8009f7:	eb 35                	jmp    800a2e <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009f9:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800a00:	eb 2c                	jmp    800a2e <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a02:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800a09:	eb 23                	jmp    800a2e <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a0b:	83 ec 08             	sub    $0x8,%esp
  800a0e:	ff 75 0c             	pushl  0xc(%ebp)
  800a11:	6a 25                	push   $0x25
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	ff d0                	call   *%eax
  800a18:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a1b:	ff 4d 10             	decl   0x10(%ebp)
  800a1e:	eb 03                	jmp    800a23 <vprintfmt+0x3c3>
  800a20:	ff 4d 10             	decl   0x10(%ebp)
  800a23:	8b 45 10             	mov    0x10(%ebp),%eax
  800a26:	48                   	dec    %eax
  800a27:	8a 00                	mov    (%eax),%al
  800a29:	3c 25                	cmp    $0x25,%al
  800a2b:	75 f3                	jne    800a20 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a2d:	90                   	nop
		}
	}
  800a2e:	e9 35 fc ff ff       	jmp    800668 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a33:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a34:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a37:	5b                   	pop    %ebx
  800a38:	5e                   	pop    %esi
  800a39:	5d                   	pop    %ebp
  800a3a:	c3                   	ret    

00800a3b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a3b:	55                   	push   %ebp
  800a3c:	89 e5                	mov    %esp,%ebp
  800a3e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a41:	8d 45 10             	lea    0x10(%ebp),%eax
  800a44:	83 c0 04             	add    $0x4,%eax
  800a47:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a4d:	ff 75 f4             	pushl  -0xc(%ebp)
  800a50:	50                   	push   %eax
  800a51:	ff 75 0c             	pushl  0xc(%ebp)
  800a54:	ff 75 08             	pushl  0x8(%ebp)
  800a57:	e8 04 fc ff ff       	call   800660 <vprintfmt>
  800a5c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a5f:	90                   	nop
  800a60:	c9                   	leave  
  800a61:	c3                   	ret    

00800a62 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a62:	55                   	push   %ebp
  800a63:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a68:	8b 40 08             	mov    0x8(%eax),%eax
  800a6b:	8d 50 01             	lea    0x1(%eax),%edx
  800a6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a71:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a77:	8b 10                	mov    (%eax),%edx
  800a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7c:	8b 40 04             	mov    0x4(%eax),%eax
  800a7f:	39 c2                	cmp    %eax,%edx
  800a81:	73 12                	jae    800a95 <sprintputch+0x33>
		*b->buf++ = ch;
  800a83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a86:	8b 00                	mov    (%eax),%eax
  800a88:	8d 48 01             	lea    0x1(%eax),%ecx
  800a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8e:	89 0a                	mov    %ecx,(%edx)
  800a90:	8b 55 08             	mov    0x8(%ebp),%edx
  800a93:	88 10                	mov    %dl,(%eax)
}
  800a95:	90                   	nop
  800a96:	5d                   	pop    %ebp
  800a97:	c3                   	ret    

00800a98 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800aa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800aad:	01 d0                	add    %edx,%eax
  800aaf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ab9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800abd:	74 06                	je     800ac5 <vsnprintf+0x2d>
  800abf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ac3:	7f 07                	jg     800acc <vsnprintf+0x34>
		return -E_INVAL;
  800ac5:	b8 03 00 00 00       	mov    $0x3,%eax
  800aca:	eb 20                	jmp    800aec <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800acc:	ff 75 14             	pushl  0x14(%ebp)
  800acf:	ff 75 10             	pushl  0x10(%ebp)
  800ad2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ad5:	50                   	push   %eax
  800ad6:	68 62 0a 80 00       	push   $0x800a62
  800adb:	e8 80 fb ff ff       	call   800660 <vprintfmt>
  800ae0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ae3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ae6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800aec:	c9                   	leave  
  800aed:	c3                   	ret    

00800aee <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800af4:	8d 45 10             	lea    0x10(%ebp),%eax
  800af7:	83 c0 04             	add    $0x4,%eax
  800afa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800afd:	8b 45 10             	mov    0x10(%ebp),%eax
  800b00:	ff 75 f4             	pushl  -0xc(%ebp)
  800b03:	50                   	push   %eax
  800b04:	ff 75 0c             	pushl  0xc(%ebp)
  800b07:	ff 75 08             	pushl  0x8(%ebp)
  800b0a:	e8 89 ff ff ff       	call   800a98 <vsnprintf>
  800b0f:	83 c4 10             	add    $0x10,%esp
  800b12:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b18:	c9                   	leave  
  800b19:	c3                   	ret    

00800b1a <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b27:	eb 06                	jmp    800b2f <strlen+0x15>
		n++;
  800b29:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b2c:	ff 45 08             	incl   0x8(%ebp)
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8a 00                	mov    (%eax),%al
  800b34:	84 c0                	test   %al,%al
  800b36:	75 f1                	jne    800b29 <strlen+0xf>
		n++;
	return n;
  800b38:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b3b:	c9                   	leave  
  800b3c:	c3                   	ret    

00800b3d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b43:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b4a:	eb 09                	jmp    800b55 <strnlen+0x18>
		n++;
  800b4c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b4f:	ff 45 08             	incl   0x8(%ebp)
  800b52:	ff 4d 0c             	decl   0xc(%ebp)
  800b55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b59:	74 09                	je     800b64 <strnlen+0x27>
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	8a 00                	mov    (%eax),%al
  800b60:	84 c0                	test   %al,%al
  800b62:	75 e8                	jne    800b4c <strnlen+0xf>
		n++;
	return n;
  800b64:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b67:	c9                   	leave  
  800b68:	c3                   	ret    

00800b69 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b69:	55                   	push   %ebp
  800b6a:	89 e5                	mov    %esp,%ebp
  800b6c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b75:	90                   	nop
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	8d 50 01             	lea    0x1(%eax),%edx
  800b7c:	89 55 08             	mov    %edx,0x8(%ebp)
  800b7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b82:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b85:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b88:	8a 12                	mov    (%edx),%dl
  800b8a:	88 10                	mov    %dl,(%eax)
  800b8c:	8a 00                	mov    (%eax),%al
  800b8e:	84 c0                	test   %al,%al
  800b90:	75 e4                	jne    800b76 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b92:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b95:	c9                   	leave  
  800b96:	c3                   	ret    

00800b97 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
  800b9a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ba3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800baa:	eb 1f                	jmp    800bcb <strncpy+0x34>
		*dst++ = *src;
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	8d 50 01             	lea    0x1(%eax),%edx
  800bb2:	89 55 08             	mov    %edx,0x8(%ebp)
  800bb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb8:	8a 12                	mov    (%edx),%dl
  800bba:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbf:	8a 00                	mov    (%eax),%al
  800bc1:	84 c0                	test   %al,%al
  800bc3:	74 03                	je     800bc8 <strncpy+0x31>
			src++;
  800bc5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bc8:	ff 45 fc             	incl   -0x4(%ebp)
  800bcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bce:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bd1:	72 d9                	jb     800bac <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800bd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bd6:	c9                   	leave  
  800bd7:	c3                   	ret    

00800bd8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800be4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800be8:	74 30                	je     800c1a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bea:	eb 16                	jmp    800c02 <strlcpy+0x2a>
			*dst++ = *src++;
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	8d 50 01             	lea    0x1(%eax),%edx
  800bf2:	89 55 08             	mov    %edx,0x8(%ebp)
  800bf5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bfb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bfe:	8a 12                	mov    (%edx),%dl
  800c00:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c02:	ff 4d 10             	decl   0x10(%ebp)
  800c05:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c09:	74 09                	je     800c14 <strlcpy+0x3c>
  800c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0e:	8a 00                	mov    (%eax),%al
  800c10:	84 c0                	test   %al,%al
  800c12:	75 d8                	jne    800bec <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c20:	29 c2                	sub    %eax,%edx
  800c22:	89 d0                	mov    %edx,%eax
}
  800c24:	c9                   	leave  
  800c25:	c3                   	ret    

00800c26 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c29:	eb 06                	jmp    800c31 <strcmp+0xb>
		p++, q++;
  800c2b:	ff 45 08             	incl   0x8(%ebp)
  800c2e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	8a 00                	mov    (%eax),%al
  800c36:	84 c0                	test   %al,%al
  800c38:	74 0e                	je     800c48 <strcmp+0x22>
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	8a 10                	mov    (%eax),%dl
  800c3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c42:	8a 00                	mov    (%eax),%al
  800c44:	38 c2                	cmp    %al,%dl
  800c46:	74 e3                	je     800c2b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	0f b6 d0             	movzbl %al,%edx
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	8a 00                	mov    (%eax),%al
  800c55:	0f b6 c0             	movzbl %al,%eax
  800c58:	29 c2                	sub    %eax,%edx
  800c5a:	89 d0                	mov    %edx,%eax
}
  800c5c:	5d                   	pop    %ebp
  800c5d:	c3                   	ret    

00800c5e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c61:	eb 09                	jmp    800c6c <strncmp+0xe>
		n--, p++, q++;
  800c63:	ff 4d 10             	decl   0x10(%ebp)
  800c66:	ff 45 08             	incl   0x8(%ebp)
  800c69:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c70:	74 17                	je     800c89 <strncmp+0x2b>
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	8a 00                	mov    (%eax),%al
  800c77:	84 c0                	test   %al,%al
  800c79:	74 0e                	je     800c89 <strncmp+0x2b>
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8a 10                	mov    (%eax),%dl
  800c80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c83:	8a 00                	mov    (%eax),%al
  800c85:	38 c2                	cmp    %al,%dl
  800c87:	74 da                	je     800c63 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c8d:	75 07                	jne    800c96 <strncmp+0x38>
		return 0;
  800c8f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c94:	eb 14                	jmp    800caa <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8a 00                	mov    (%eax),%al
  800c9b:	0f b6 d0             	movzbl %al,%edx
  800c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	0f b6 c0             	movzbl %al,%eax
  800ca6:	29 c2                	sub    %eax,%edx
  800ca8:	89 d0                	mov    %edx,%eax
}
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    

00800cac <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	83 ec 04             	sub    $0x4,%esp
  800cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cb8:	eb 12                	jmp    800ccc <strchr+0x20>
		if (*s == c)
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	8a 00                	mov    (%eax),%al
  800cbf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cc2:	75 05                	jne    800cc9 <strchr+0x1d>
			return (char *) s;
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	eb 11                	jmp    800cda <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cc9:	ff 45 08             	incl   0x8(%ebp)
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	84 c0                	test   %al,%al
  800cd3:	75 e5                	jne    800cba <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cda:	c9                   	leave  
  800cdb:	c3                   	ret    

00800cdc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	83 ec 04             	sub    $0x4,%esp
  800ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ce8:	eb 0d                	jmp    800cf7 <strfind+0x1b>
		if (*s == c)
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	8a 00                	mov    (%eax),%al
  800cef:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cf2:	74 0e                	je     800d02 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cf4:	ff 45 08             	incl   0x8(%ebp)
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8a 00                	mov    (%eax),%al
  800cfc:	84 c0                	test   %al,%al
  800cfe:	75 ea                	jne    800cea <strfind+0xe>
  800d00:	eb 01                	jmp    800d03 <strfind+0x27>
		if (*s == c)
			break;
  800d02:	90                   	nop
	return (char *) s;
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d06:	c9                   	leave  
  800d07:	c3                   	ret    

00800d08 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d14:	8b 45 10             	mov    0x10(%ebp),%eax
  800d17:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d1a:	eb 0e                	jmp    800d2a <memset+0x22>
		*p++ = c;
  800d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d1f:	8d 50 01             	lea    0x1(%eax),%edx
  800d22:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d28:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d2a:	ff 4d f8             	decl   -0x8(%ebp)
  800d2d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d31:	79 e9                	jns    800d1c <memset+0x14>
		*p++ = c;

	return v;
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d36:	c9                   	leave  
  800d37:	c3                   	ret    

00800d38 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d4a:	eb 16                	jmp    800d62 <memcpy+0x2a>
		*d++ = *s++;
  800d4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d4f:	8d 50 01             	lea    0x1(%eax),%edx
  800d52:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d55:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d58:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d5b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d5e:	8a 12                	mov    (%edx),%dl
  800d60:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d62:	8b 45 10             	mov    0x10(%ebp),%eax
  800d65:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d68:	89 55 10             	mov    %edx,0x10(%ebp)
  800d6b:	85 c0                	test   %eax,%eax
  800d6d:	75 dd                	jne    800d4c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d72:	c9                   	leave  
  800d73:	c3                   	ret    

00800d74 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d74:	55                   	push   %ebp
  800d75:	89 e5                	mov    %esp,%ebp
  800d77:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d86:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d89:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d8c:	73 50                	jae    800dde <memmove+0x6a>
  800d8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d91:	8b 45 10             	mov    0x10(%ebp),%eax
  800d94:	01 d0                	add    %edx,%eax
  800d96:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d99:	76 43                	jbe    800dde <memmove+0x6a>
		s += n;
  800d9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800da1:	8b 45 10             	mov    0x10(%ebp),%eax
  800da4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800da7:	eb 10                	jmp    800db9 <memmove+0x45>
			*--d = *--s;
  800da9:	ff 4d f8             	decl   -0x8(%ebp)
  800dac:	ff 4d fc             	decl   -0x4(%ebp)
  800daf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db2:	8a 10                	mov    (%eax),%dl
  800db4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800db9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dbf:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc2:	85 c0                	test   %eax,%eax
  800dc4:	75 e3                	jne    800da9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dc6:	eb 23                	jmp    800deb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800dc8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dcb:	8d 50 01             	lea    0x1(%eax),%edx
  800dce:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dd1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dd4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dd7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dda:	8a 12                	mov    (%edx),%dl
  800ddc:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dde:	8b 45 10             	mov    0x10(%ebp),%eax
  800de1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800de4:	89 55 10             	mov    %edx,0x10(%ebp)
  800de7:	85 c0                	test   %eax,%eax
  800de9:	75 dd                	jne    800dc8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dee:	c9                   	leave  
  800def:	c3                   	ret    

00800df0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dff:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e02:	eb 2a                	jmp    800e2e <memcmp+0x3e>
		if (*s1 != *s2)
  800e04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e07:	8a 10                	mov    (%eax),%dl
  800e09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	38 c2                	cmp    %al,%dl
  800e10:	74 16                	je     800e28 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e15:	8a 00                	mov    (%eax),%al
  800e17:	0f b6 d0             	movzbl %al,%edx
  800e1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1d:	8a 00                	mov    (%eax),%al
  800e1f:	0f b6 c0             	movzbl %al,%eax
  800e22:	29 c2                	sub    %eax,%edx
  800e24:	89 d0                	mov    %edx,%eax
  800e26:	eb 18                	jmp    800e40 <memcmp+0x50>
		s1++, s2++;
  800e28:	ff 45 fc             	incl   -0x4(%ebp)
  800e2b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e34:	89 55 10             	mov    %edx,0x10(%ebp)
  800e37:	85 c0                	test   %eax,%eax
  800e39:	75 c9                	jne    800e04 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e40:	c9                   	leave  
  800e41:	c3                   	ret    

00800e42 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e48:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4e:	01 d0                	add    %edx,%eax
  800e50:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e53:	eb 15                	jmp    800e6a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	0f b6 d0             	movzbl %al,%edx
  800e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e60:	0f b6 c0             	movzbl %al,%eax
  800e63:	39 c2                	cmp    %eax,%edx
  800e65:	74 0d                	je     800e74 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e67:	ff 45 08             	incl   0x8(%ebp)
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e70:	72 e3                	jb     800e55 <memfind+0x13>
  800e72:	eb 01                	jmp    800e75 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e74:	90                   	nop
	return (void *) s;
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e78:	c9                   	leave  
  800e79:	c3                   	ret    

00800e7a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e87:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e8e:	eb 03                	jmp    800e93 <strtol+0x19>
		s++;
  800e90:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8a 00                	mov    (%eax),%al
  800e98:	3c 20                	cmp    $0x20,%al
  800e9a:	74 f4                	je     800e90 <strtol+0x16>
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	8a 00                	mov    (%eax),%al
  800ea1:	3c 09                	cmp    $0x9,%al
  800ea3:	74 eb                	je     800e90 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	3c 2b                	cmp    $0x2b,%al
  800eac:	75 05                	jne    800eb3 <strtol+0x39>
		s++;
  800eae:	ff 45 08             	incl   0x8(%ebp)
  800eb1:	eb 13                	jmp    800ec6 <strtol+0x4c>
	else if (*s == '-')
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	8a 00                	mov    (%eax),%al
  800eb8:	3c 2d                	cmp    $0x2d,%al
  800eba:	75 0a                	jne    800ec6 <strtol+0x4c>
		s++, neg = 1;
  800ebc:	ff 45 08             	incl   0x8(%ebp)
  800ebf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ec6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eca:	74 06                	je     800ed2 <strtol+0x58>
  800ecc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ed0:	75 20                	jne    800ef2 <strtol+0x78>
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	3c 30                	cmp    $0x30,%al
  800ed9:	75 17                	jne    800ef2 <strtol+0x78>
  800edb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ede:	40                   	inc    %eax
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	3c 78                	cmp    $0x78,%al
  800ee3:	75 0d                	jne    800ef2 <strtol+0x78>
		s += 2, base = 16;
  800ee5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ee9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ef0:	eb 28                	jmp    800f1a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ef2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef6:	75 15                	jne    800f0d <strtol+0x93>
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	8a 00                	mov    (%eax),%al
  800efd:	3c 30                	cmp    $0x30,%al
  800eff:	75 0c                	jne    800f0d <strtol+0x93>
		s++, base = 8;
  800f01:	ff 45 08             	incl   0x8(%ebp)
  800f04:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f0b:	eb 0d                	jmp    800f1a <strtol+0xa0>
	else if (base == 0)
  800f0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f11:	75 07                	jne    800f1a <strtol+0xa0>
		base = 10;
  800f13:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	8a 00                	mov    (%eax),%al
  800f1f:	3c 2f                	cmp    $0x2f,%al
  800f21:	7e 19                	jle    800f3c <strtol+0xc2>
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	3c 39                	cmp    $0x39,%al
  800f2a:	7f 10                	jg     800f3c <strtol+0xc2>
			dig = *s - '0';
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	0f be c0             	movsbl %al,%eax
  800f34:	83 e8 30             	sub    $0x30,%eax
  800f37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f3a:	eb 42                	jmp    800f7e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	8a 00                	mov    (%eax),%al
  800f41:	3c 60                	cmp    $0x60,%al
  800f43:	7e 19                	jle    800f5e <strtol+0xe4>
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	8a 00                	mov    (%eax),%al
  800f4a:	3c 7a                	cmp    $0x7a,%al
  800f4c:	7f 10                	jg     800f5e <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	0f be c0             	movsbl %al,%eax
  800f56:	83 e8 57             	sub    $0x57,%eax
  800f59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f5c:	eb 20                	jmp    800f7e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	3c 40                	cmp    $0x40,%al
  800f65:	7e 39                	jle    800fa0 <strtol+0x126>
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	8a 00                	mov    (%eax),%al
  800f6c:	3c 5a                	cmp    $0x5a,%al
  800f6e:	7f 30                	jg     800fa0 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	0f be c0             	movsbl %al,%eax
  800f78:	83 e8 37             	sub    $0x37,%eax
  800f7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f81:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f84:	7d 19                	jge    800f9f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f86:	ff 45 08             	incl   0x8(%ebp)
  800f89:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f8c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f90:	89 c2                	mov    %eax,%edx
  800f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f95:	01 d0                	add    %edx,%eax
  800f97:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f9a:	e9 7b ff ff ff       	jmp    800f1a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f9f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800fa0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fa4:	74 08                	je     800fae <strtol+0x134>
		*endptr = (char *) s;
  800fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fac:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800fae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fb2:	74 07                	je     800fbb <strtol+0x141>
  800fb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb7:	f7 d8                	neg    %eax
  800fb9:	eb 03                	jmp    800fbe <strtol+0x144>
  800fbb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fbe:	c9                   	leave  
  800fbf:	c3                   	ret    

00800fc0 <ltostr>:

void
ltostr(long value, char *str)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fcd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fd4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fd8:	79 13                	jns    800fed <ltostr+0x2d>
	{
		neg = 1;
  800fda:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fe7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fea:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ff5:	99                   	cltd   
  800ff6:	f7 f9                	idiv   %ecx
  800ff8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ffb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffe:	8d 50 01             	lea    0x1(%eax),%edx
  801001:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801004:	89 c2                	mov    %eax,%edx
  801006:	8b 45 0c             	mov    0xc(%ebp),%eax
  801009:	01 d0                	add    %edx,%eax
  80100b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80100e:	83 c2 30             	add    $0x30,%edx
  801011:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801013:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801016:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80101b:	f7 e9                	imul   %ecx
  80101d:	c1 fa 02             	sar    $0x2,%edx
  801020:	89 c8                	mov    %ecx,%eax
  801022:	c1 f8 1f             	sar    $0x1f,%eax
  801025:	29 c2                	sub    %eax,%edx
  801027:	89 d0                	mov    %edx,%eax
  801029:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80102c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801030:	75 bb                	jne    800fed <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801032:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801039:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103c:	48                   	dec    %eax
  80103d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801040:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801044:	74 3d                	je     801083 <ltostr+0xc3>
		start = 1 ;
  801046:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80104d:	eb 34                	jmp    801083 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80104f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801052:	8b 45 0c             	mov    0xc(%ebp),%eax
  801055:	01 d0                	add    %edx,%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80105c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80105f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801062:	01 c2                	add    %eax,%edx
  801064:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801067:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106a:	01 c8                	add    %ecx,%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801070:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801073:	8b 45 0c             	mov    0xc(%ebp),%eax
  801076:	01 c2                	add    %eax,%edx
  801078:	8a 45 eb             	mov    -0x15(%ebp),%al
  80107b:	88 02                	mov    %al,(%edx)
		start++ ;
  80107d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801080:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801086:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801089:	7c c4                	jl     80104f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80108b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80108e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801091:	01 d0                	add    %edx,%eax
  801093:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801096:	90                   	nop
  801097:	c9                   	leave  
  801098:	c3                   	ret    

00801099 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80109f:	ff 75 08             	pushl  0x8(%ebp)
  8010a2:	e8 73 fa ff ff       	call   800b1a <strlen>
  8010a7:	83 c4 04             	add    $0x4,%esp
  8010aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8010ad:	ff 75 0c             	pushl  0xc(%ebp)
  8010b0:	e8 65 fa ff ff       	call   800b1a <strlen>
  8010b5:	83 c4 04             	add    $0x4,%esp
  8010b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010c9:	eb 17                	jmp    8010e2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d1:	01 c2                	add    %eax,%edx
  8010d3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	01 c8                	add    %ecx,%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010df:	ff 45 fc             	incl   -0x4(%ebp)
  8010e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010e8:	7c e1                	jl     8010cb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010ea:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010f8:	eb 1f                	jmp    801119 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010fd:	8d 50 01             	lea    0x1(%eax),%edx
  801100:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801103:	89 c2                	mov    %eax,%edx
  801105:	8b 45 10             	mov    0x10(%ebp),%eax
  801108:	01 c2                	add    %eax,%edx
  80110a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80110d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801110:	01 c8                	add    %ecx,%eax
  801112:	8a 00                	mov    (%eax),%al
  801114:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801116:	ff 45 f8             	incl   -0x8(%ebp)
  801119:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80111f:	7c d9                	jl     8010fa <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801121:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801124:	8b 45 10             	mov    0x10(%ebp),%eax
  801127:	01 d0                	add    %edx,%eax
  801129:	c6 00 00             	movb   $0x0,(%eax)
}
  80112c:	90                   	nop
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801132:	8b 45 14             	mov    0x14(%ebp),%eax
  801135:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80113b:	8b 45 14             	mov    0x14(%ebp),%eax
  80113e:	8b 00                	mov    (%eax),%eax
  801140:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801147:	8b 45 10             	mov    0x10(%ebp),%eax
  80114a:	01 d0                	add    %edx,%eax
  80114c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801152:	eb 0c                	jmp    801160 <strsplit+0x31>
			*string++ = 0;
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	8d 50 01             	lea    0x1(%eax),%edx
  80115a:	89 55 08             	mov    %edx,0x8(%ebp)
  80115d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	84 c0                	test   %al,%al
  801167:	74 18                	je     801181 <strsplit+0x52>
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	8a 00                	mov    (%eax),%al
  80116e:	0f be c0             	movsbl %al,%eax
  801171:	50                   	push   %eax
  801172:	ff 75 0c             	pushl  0xc(%ebp)
  801175:	e8 32 fb ff ff       	call   800cac <strchr>
  80117a:	83 c4 08             	add    $0x8,%esp
  80117d:	85 c0                	test   %eax,%eax
  80117f:	75 d3                	jne    801154 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	84 c0                	test   %al,%al
  801188:	74 5a                	je     8011e4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80118a:	8b 45 14             	mov    0x14(%ebp),%eax
  80118d:	8b 00                	mov    (%eax),%eax
  80118f:	83 f8 0f             	cmp    $0xf,%eax
  801192:	75 07                	jne    80119b <strsplit+0x6c>
		{
			return 0;
  801194:	b8 00 00 00 00       	mov    $0x0,%eax
  801199:	eb 66                	jmp    801201 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80119b:	8b 45 14             	mov    0x14(%ebp),%eax
  80119e:	8b 00                	mov    (%eax),%eax
  8011a0:	8d 48 01             	lea    0x1(%eax),%ecx
  8011a3:	8b 55 14             	mov    0x14(%ebp),%edx
  8011a6:	89 0a                	mov    %ecx,(%edx)
  8011a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011af:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b2:	01 c2                	add    %eax,%edx
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011b9:	eb 03                	jmp    8011be <strsplit+0x8f>
			string++;
  8011bb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	8a 00                	mov    (%eax),%al
  8011c3:	84 c0                	test   %al,%al
  8011c5:	74 8b                	je     801152 <strsplit+0x23>
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	0f be c0             	movsbl %al,%eax
  8011cf:	50                   	push   %eax
  8011d0:	ff 75 0c             	pushl  0xc(%ebp)
  8011d3:	e8 d4 fa ff ff       	call   800cac <strchr>
  8011d8:	83 c4 08             	add    $0x8,%esp
  8011db:	85 c0                	test   %eax,%eax
  8011dd:	74 dc                	je     8011bb <strsplit+0x8c>
			string++;
	}
  8011df:	e9 6e ff ff ff       	jmp    801152 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011e4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e8:	8b 00                	mov    (%eax),%eax
  8011ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f4:	01 d0                	add    %edx,%eax
  8011f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011fc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801201:	c9                   	leave  
  801202:	c3                   	ret    

00801203 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
  801206:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801209:	83 ec 04             	sub    $0x4,%esp
  80120c:	68 28 21 80 00       	push   $0x802128
  801211:	68 3f 01 00 00       	push   $0x13f
  801216:	68 4a 21 80 00       	push   $0x80214a
  80121b:	e8 a9 ef ff ff       	call   8001c9 <_panic>

00801220 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	57                   	push   %edi
  801224:	56                   	push   %esi
  801225:	53                   	push   %ebx
  801226:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80122f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801232:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801235:	8b 7d 18             	mov    0x18(%ebp),%edi
  801238:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80123b:	cd 30                	int    $0x30
  80123d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801240:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801243:	83 c4 10             	add    $0x10,%esp
  801246:	5b                   	pop    %ebx
  801247:	5e                   	pop    %esi
  801248:	5f                   	pop    %edi
  801249:	5d                   	pop    %ebp
  80124a:	c3                   	ret    

0080124b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
  80124e:	83 ec 04             	sub    $0x4,%esp
  801251:	8b 45 10             	mov    0x10(%ebp),%eax
  801254:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801257:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
  80125e:	6a 00                	push   $0x0
  801260:	6a 00                	push   $0x0
  801262:	52                   	push   %edx
  801263:	ff 75 0c             	pushl  0xc(%ebp)
  801266:	50                   	push   %eax
  801267:	6a 00                	push   $0x0
  801269:	e8 b2 ff ff ff       	call   801220 <syscall>
  80126e:	83 c4 18             	add    $0x18,%esp
}
  801271:	90                   	nop
  801272:	c9                   	leave  
  801273:	c3                   	ret    

00801274 <sys_cgetc>:

int
sys_cgetc(void)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801277:	6a 00                	push   $0x0
  801279:	6a 00                	push   $0x0
  80127b:	6a 00                	push   $0x0
  80127d:	6a 00                	push   $0x0
  80127f:	6a 00                	push   $0x0
  801281:	6a 02                	push   $0x2
  801283:	e8 98 ff ff ff       	call   801220 <syscall>
  801288:	83 c4 18             	add    $0x18,%esp
}
  80128b:	c9                   	leave  
  80128c:	c3                   	ret    

0080128d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80128d:	55                   	push   %ebp
  80128e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801290:	6a 00                	push   $0x0
  801292:	6a 00                	push   $0x0
  801294:	6a 00                	push   $0x0
  801296:	6a 00                	push   $0x0
  801298:	6a 00                	push   $0x0
  80129a:	6a 03                	push   $0x3
  80129c:	e8 7f ff ff ff       	call   801220 <syscall>
  8012a1:	83 c4 18             	add    $0x18,%esp
}
  8012a4:	90                   	nop
  8012a5:	c9                   	leave  
  8012a6:	c3                   	ret    

008012a7 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8012a7:	55                   	push   %ebp
  8012a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8012aa:	6a 00                	push   $0x0
  8012ac:	6a 00                	push   $0x0
  8012ae:	6a 00                	push   $0x0
  8012b0:	6a 00                	push   $0x0
  8012b2:	6a 00                	push   $0x0
  8012b4:	6a 04                	push   $0x4
  8012b6:	e8 65 ff ff ff       	call   801220 <syscall>
  8012bb:	83 c4 18             	add    $0x18,%esp
}
  8012be:	90                   	nop
  8012bf:	c9                   	leave  
  8012c0:	c3                   	ret    

008012c1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	6a 00                	push   $0x0
  8012cc:	6a 00                	push   $0x0
  8012ce:	6a 00                	push   $0x0
  8012d0:	52                   	push   %edx
  8012d1:	50                   	push   %eax
  8012d2:	6a 08                	push   $0x8
  8012d4:	e8 47 ff ff ff       	call   801220 <syscall>
  8012d9:	83 c4 18             	add    $0x18,%esp
}
  8012dc:	c9                   	leave  
  8012dd:	c3                   	ret    

008012de <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	56                   	push   %esi
  8012e2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012e3:	8b 75 18             	mov    0x18(%ebp),%esi
  8012e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f2:	56                   	push   %esi
  8012f3:	53                   	push   %ebx
  8012f4:	51                   	push   %ecx
  8012f5:	52                   	push   %edx
  8012f6:	50                   	push   %eax
  8012f7:	6a 09                	push   $0x9
  8012f9:	e8 22 ff ff ff       	call   801220 <syscall>
  8012fe:	83 c4 18             	add    $0x18,%esp
}
  801301:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801304:	5b                   	pop    %ebx
  801305:	5e                   	pop    %esi
  801306:	5d                   	pop    %ebp
  801307:	c3                   	ret    

00801308 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80130b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	6a 00                	push   $0x0
  801313:	6a 00                	push   $0x0
  801315:	6a 00                	push   $0x0
  801317:	52                   	push   %edx
  801318:	50                   	push   %eax
  801319:	6a 0a                	push   $0xa
  80131b:	e8 00 ff ff ff       	call   801220 <syscall>
  801320:	83 c4 18             	add    $0x18,%esp
}
  801323:	c9                   	leave  
  801324:	c3                   	ret    

00801325 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801328:	6a 00                	push   $0x0
  80132a:	6a 00                	push   $0x0
  80132c:	6a 00                	push   $0x0
  80132e:	ff 75 0c             	pushl  0xc(%ebp)
  801331:	ff 75 08             	pushl  0x8(%ebp)
  801334:	6a 0b                	push   $0xb
  801336:	e8 e5 fe ff ff       	call   801220 <syscall>
  80133b:	83 c4 18             	add    $0x18,%esp
}
  80133e:	c9                   	leave  
  80133f:	c3                   	ret    

00801340 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801343:	6a 00                	push   $0x0
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 0c                	push   $0xc
  80134f:	e8 cc fe ff ff       	call   801220 <syscall>
  801354:	83 c4 18             	add    $0x18,%esp
}
  801357:	c9                   	leave  
  801358:	c3                   	ret    

00801359 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	6a 00                	push   $0x0
  801364:	6a 00                	push   $0x0
  801366:	6a 0d                	push   $0xd
  801368:	e8 b3 fe ff ff       	call   801220 <syscall>
  80136d:	83 c4 18             	add    $0x18,%esp
}
  801370:	c9                   	leave  
  801371:	c3                   	ret    

00801372 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801372:	55                   	push   %ebp
  801373:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801375:	6a 00                	push   $0x0
  801377:	6a 00                	push   $0x0
  801379:	6a 00                	push   $0x0
  80137b:	6a 00                	push   $0x0
  80137d:	6a 00                	push   $0x0
  80137f:	6a 0e                	push   $0xe
  801381:	e8 9a fe ff ff       	call   801220 <syscall>
  801386:	83 c4 18             	add    $0x18,%esp
}
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80138e:	6a 00                	push   $0x0
  801390:	6a 00                	push   $0x0
  801392:	6a 00                	push   $0x0
  801394:	6a 00                	push   $0x0
  801396:	6a 00                	push   $0x0
  801398:	6a 0f                	push   $0xf
  80139a:	e8 81 fe ff ff       	call   801220 <syscall>
  80139f:	83 c4 18             	add    $0x18,%esp
}
  8013a2:	c9                   	leave  
  8013a3:	c3                   	ret    

008013a4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 00                	push   $0x0
  8013ab:	6a 00                	push   $0x0
  8013ad:	6a 00                	push   $0x0
  8013af:	ff 75 08             	pushl  0x8(%ebp)
  8013b2:	6a 10                	push   $0x10
  8013b4:	e8 67 fe ff ff       	call   801220 <syscall>
  8013b9:	83 c4 18             	add    $0x18,%esp
}
  8013bc:	c9                   	leave  
  8013bd:	c3                   	ret    

008013be <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 11                	push   $0x11
  8013cd:	e8 4e fe ff ff       	call   801220 <syscall>
  8013d2:	83 c4 18             	add    $0x18,%esp
}
  8013d5:	90                   	nop
  8013d6:	c9                   	leave  
  8013d7:	c3                   	ret    

008013d8 <sys_cputc>:

void
sys_cputc(const char c)
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
  8013db:	83 ec 04             	sub    $0x4,%esp
  8013de:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013e4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 00                	push   $0x0
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	50                   	push   %eax
  8013f1:	6a 01                	push   $0x1
  8013f3:	e8 28 fe ff ff       	call   801220 <syscall>
  8013f8:	83 c4 18             	add    $0x18,%esp
}
  8013fb:	90                   	nop
  8013fc:	c9                   	leave  
  8013fd:	c3                   	ret    

008013fe <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801401:	6a 00                	push   $0x0
  801403:	6a 00                	push   $0x0
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	6a 14                	push   $0x14
  80140d:	e8 0e fe ff ff       	call   801220 <syscall>
  801412:	83 c4 18             	add    $0x18,%esp
}
  801415:	90                   	nop
  801416:	c9                   	leave  
  801417:	c3                   	ret    

00801418 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
  80141b:	83 ec 04             	sub    $0x4,%esp
  80141e:	8b 45 10             	mov    0x10(%ebp),%eax
  801421:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801424:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801427:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	6a 00                	push   $0x0
  801430:	51                   	push   %ecx
  801431:	52                   	push   %edx
  801432:	ff 75 0c             	pushl  0xc(%ebp)
  801435:	50                   	push   %eax
  801436:	6a 15                	push   $0x15
  801438:	e8 e3 fd ff ff       	call   801220 <syscall>
  80143d:	83 c4 18             	add    $0x18,%esp
}
  801440:	c9                   	leave  
  801441:	c3                   	ret    

00801442 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801442:	55                   	push   %ebp
  801443:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801445:	8b 55 0c             	mov    0xc(%ebp),%edx
  801448:	8b 45 08             	mov    0x8(%ebp),%eax
  80144b:	6a 00                	push   $0x0
  80144d:	6a 00                	push   $0x0
  80144f:	6a 00                	push   $0x0
  801451:	52                   	push   %edx
  801452:	50                   	push   %eax
  801453:	6a 16                	push   $0x16
  801455:	e8 c6 fd ff ff       	call   801220 <syscall>
  80145a:	83 c4 18             	add    $0x18,%esp
}
  80145d:	c9                   	leave  
  80145e:	c3                   	ret    

0080145f <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801462:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801465:	8b 55 0c             	mov    0xc(%ebp),%edx
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	51                   	push   %ecx
  801470:	52                   	push   %edx
  801471:	50                   	push   %eax
  801472:	6a 17                	push   $0x17
  801474:	e8 a7 fd ff ff       	call   801220 <syscall>
  801479:	83 c4 18             	add    $0x18,%esp
}
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801481:	8b 55 0c             	mov    0xc(%ebp),%edx
  801484:	8b 45 08             	mov    0x8(%ebp),%eax
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	52                   	push   %edx
  80148e:	50                   	push   %eax
  80148f:	6a 18                	push   $0x18
  801491:	e8 8a fd ff ff       	call   801220 <syscall>
  801496:	83 c4 18             	add    $0x18,%esp
}
  801499:	c9                   	leave  
  80149a:	c3                   	ret    

0080149b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80149e:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a1:	6a 00                	push   $0x0
  8014a3:	ff 75 14             	pushl  0x14(%ebp)
  8014a6:	ff 75 10             	pushl  0x10(%ebp)
  8014a9:	ff 75 0c             	pushl  0xc(%ebp)
  8014ac:	50                   	push   %eax
  8014ad:	6a 19                	push   $0x19
  8014af:	e8 6c fd ff ff       	call   801220 <syscall>
  8014b4:	83 c4 18             	add    $0x18,%esp
}
  8014b7:	c9                   	leave  
  8014b8:	c3                   	ret    

008014b9 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	50                   	push   %eax
  8014c8:	6a 1a                	push   $0x1a
  8014ca:	e8 51 fd ff ff       	call   801220 <syscall>
  8014cf:	83 c4 18             	add    $0x18,%esp
}
  8014d2:	90                   	nop
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 00                	push   $0x0
  8014e1:	6a 00                	push   $0x0
  8014e3:	50                   	push   %eax
  8014e4:	6a 1b                	push   $0x1b
  8014e6:	e8 35 fd ff ff       	call   801220 <syscall>
  8014eb:	83 c4 18             	add    $0x18,%esp
}
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 05                	push   $0x5
  8014ff:	e8 1c fd ff ff       	call   801220 <syscall>
  801504:	83 c4 18             	add    $0x18,%esp
}
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 06                	push   $0x6
  801518:	e8 03 fd ff ff       	call   801220 <syscall>
  80151d:	83 c4 18             	add    $0x18,%esp
}
  801520:	c9                   	leave  
  801521:	c3                   	ret    

00801522 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 07                	push   $0x7
  801531:	e8 ea fc ff ff       	call   801220 <syscall>
  801536:	83 c4 18             	add    $0x18,%esp
}
  801539:	c9                   	leave  
  80153a:	c3                   	ret    

0080153b <sys_exit_env>:


void sys_exit_env(void)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 1c                	push   $0x1c
  80154a:	e8 d1 fc ff ff       	call   801220 <syscall>
  80154f:	83 c4 18             	add    $0x18,%esp
}
  801552:	90                   	nop
  801553:	c9                   	leave  
  801554:	c3                   	ret    

00801555 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
  801558:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80155b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80155e:	8d 50 04             	lea    0x4(%eax),%edx
  801561:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	52                   	push   %edx
  80156b:	50                   	push   %eax
  80156c:	6a 1d                	push   $0x1d
  80156e:	e8 ad fc ff ff       	call   801220 <syscall>
  801573:	83 c4 18             	add    $0x18,%esp
	return result;
  801576:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801579:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80157c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80157f:	89 01                	mov    %eax,(%ecx)
  801581:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
  801587:	c9                   	leave  
  801588:	c2 04 00             	ret    $0x4

0080158b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	ff 75 10             	pushl  0x10(%ebp)
  801595:	ff 75 0c             	pushl  0xc(%ebp)
  801598:	ff 75 08             	pushl  0x8(%ebp)
  80159b:	6a 13                	push   $0x13
  80159d:	e8 7e fc ff ff       	call   801220 <syscall>
  8015a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8015a5:	90                   	nop
}
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 1e                	push   $0x1e
  8015b7:	e8 64 fc ff ff       	call   801220 <syscall>
  8015bc:	83 c4 18             	add    $0x18,%esp
}
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    

008015c1 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	83 ec 04             	sub    $0x4,%esp
  8015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015cd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	50                   	push   %eax
  8015da:	6a 1f                	push   $0x1f
  8015dc:	e8 3f fc ff ff       	call   801220 <syscall>
  8015e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8015e4:	90                   	nop
}
  8015e5:	c9                   	leave  
  8015e6:	c3                   	ret    

008015e7 <rsttst>:
void rsttst()
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 21                	push   $0x21
  8015f6:	e8 25 fc ff ff       	call   801220 <syscall>
  8015fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8015fe:	90                   	nop
}
  8015ff:	c9                   	leave  
  801600:	c3                   	ret    

00801601 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	83 ec 04             	sub    $0x4,%esp
  801607:	8b 45 14             	mov    0x14(%ebp),%eax
  80160a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80160d:	8b 55 18             	mov    0x18(%ebp),%edx
  801610:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801614:	52                   	push   %edx
  801615:	50                   	push   %eax
  801616:	ff 75 10             	pushl  0x10(%ebp)
  801619:	ff 75 0c             	pushl  0xc(%ebp)
  80161c:	ff 75 08             	pushl  0x8(%ebp)
  80161f:	6a 20                	push   $0x20
  801621:	e8 fa fb ff ff       	call   801220 <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
	return ;
  801629:	90                   	nop
}
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <chktst>:
void chktst(uint32 n)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	ff 75 08             	pushl  0x8(%ebp)
  80163a:	6a 22                	push   $0x22
  80163c:	e8 df fb ff ff       	call   801220 <syscall>
  801641:	83 c4 18             	add    $0x18,%esp
	return ;
  801644:	90                   	nop
}
  801645:	c9                   	leave  
  801646:	c3                   	ret    

00801647 <inctst>:

void inctst()
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 23                	push   $0x23
  801656:	e8 c5 fb ff ff       	call   801220 <syscall>
  80165b:	83 c4 18             	add    $0x18,%esp
	return ;
  80165e:	90                   	nop
}
  80165f:	c9                   	leave  
  801660:	c3                   	ret    

00801661 <gettst>:
uint32 gettst()
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 24                	push   $0x24
  801670:	e8 ab fb ff ff       	call   801220 <syscall>
  801675:	83 c4 18             	add    $0x18,%esp
}
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 25                	push   $0x25
  80168c:	e8 8f fb ff ff       	call   801220 <syscall>
  801691:	83 c4 18             	add    $0x18,%esp
  801694:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801697:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80169b:	75 07                	jne    8016a4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80169d:	b8 01 00 00 00       	mov    $0x1,%eax
  8016a2:	eb 05                	jmp    8016a9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8016a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    

008016ab <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 25                	push   $0x25
  8016bd:	e8 5e fb ff ff       	call   801220 <syscall>
  8016c2:	83 c4 18             	add    $0x18,%esp
  8016c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016c8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016cc:	75 07                	jne    8016d5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8016d3:	eb 05                	jmp    8016da <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016da:	c9                   	leave  
  8016db:	c3                   	ret    

008016dc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
  8016df:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 25                	push   $0x25
  8016ee:	e8 2d fb ff ff       	call   801220 <syscall>
  8016f3:	83 c4 18             	add    $0x18,%esp
  8016f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016f9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016fd:	75 07                	jne    801706 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016ff:	b8 01 00 00 00       	mov    $0x1,%eax
  801704:	eb 05                	jmp    80170b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801706:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 25                	push   $0x25
  80171f:	e8 fc fa ff ff       	call   801220 <syscall>
  801724:	83 c4 18             	add    $0x18,%esp
  801727:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80172a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80172e:	75 07                	jne    801737 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801730:	b8 01 00 00 00       	mov    $0x1,%eax
  801735:	eb 05                	jmp    80173c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801737:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	ff 75 08             	pushl  0x8(%ebp)
  80174c:	6a 26                	push   $0x26
  80174e:	e8 cd fa ff ff       	call   801220 <syscall>
  801753:	83 c4 18             	add    $0x18,%esp
	return ;
  801756:	90                   	nop
}
  801757:	c9                   	leave  
  801758:	c3                   	ret    

00801759 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80175d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801760:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801763:	8b 55 0c             	mov    0xc(%ebp),%edx
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	6a 00                	push   $0x0
  80176b:	53                   	push   %ebx
  80176c:	51                   	push   %ecx
  80176d:	52                   	push   %edx
  80176e:	50                   	push   %eax
  80176f:	6a 27                	push   $0x27
  801771:	e8 aa fa ff ff       	call   801220 <syscall>
  801776:	83 c4 18             	add    $0x18,%esp
}
  801779:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    

0080177e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801781:	8b 55 0c             	mov    0xc(%ebp),%edx
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	52                   	push   %edx
  80178e:	50                   	push   %eax
  80178f:	6a 28                	push   $0x28
  801791:	e8 8a fa ff ff       	call   801220 <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
}
  801799:	c9                   	leave  
  80179a:	c3                   	ret    

0080179b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80179e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	6a 00                	push   $0x0
  8017a9:	51                   	push   %ecx
  8017aa:	ff 75 10             	pushl  0x10(%ebp)
  8017ad:	52                   	push   %edx
  8017ae:	50                   	push   %eax
  8017af:	6a 29                	push   $0x29
  8017b1:	e8 6a fa ff ff       	call   801220 <syscall>
  8017b6:	83 c4 18             	add    $0x18,%esp
}
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    

008017bb <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	ff 75 10             	pushl  0x10(%ebp)
  8017c5:	ff 75 0c             	pushl  0xc(%ebp)
  8017c8:	ff 75 08             	pushl  0x8(%ebp)
  8017cb:	6a 12                	push   $0x12
  8017cd:	e8 4e fa ff ff       	call   801220 <syscall>
  8017d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d5:	90                   	nop
}
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8017db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	52                   	push   %edx
  8017e8:	50                   	push   %eax
  8017e9:	6a 2a                	push   $0x2a
  8017eb:	e8 30 fa ff ff       	call   801220 <syscall>
  8017f0:	83 c4 18             	add    $0x18,%esp
	return;
  8017f3:	90                   	nop
}
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	50                   	push   %eax
  801805:	6a 2b                	push   $0x2b
  801807:	e8 14 fa ff ff       	call   801220 <syscall>
  80180c:	83 c4 18             	add    $0x18,%esp
}
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	ff 75 0c             	pushl  0xc(%ebp)
  80181d:	ff 75 08             	pushl  0x8(%ebp)
  801820:	6a 2c                	push   $0x2c
  801822:	e8 f9 f9 ff ff       	call   801220 <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
	return;
  80182a:	90                   	nop
}
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	ff 75 0c             	pushl  0xc(%ebp)
  801839:	ff 75 08             	pushl  0x8(%ebp)
  80183c:	6a 2d                	push   $0x2d
  80183e:	e8 dd f9 ff ff       	call   801220 <syscall>
  801843:	83 c4 18             	add    $0x18,%esp
	return;
  801846:	90                   	nop
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    
  801849:	66 90                	xchg   %ax,%ax
  80184b:	90                   	nop

0080184c <__udivdi3>:
  80184c:	55                   	push   %ebp
  80184d:	57                   	push   %edi
  80184e:	56                   	push   %esi
  80184f:	53                   	push   %ebx
  801850:	83 ec 1c             	sub    $0x1c,%esp
  801853:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801857:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80185b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80185f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801863:	89 ca                	mov    %ecx,%edx
  801865:	89 f8                	mov    %edi,%eax
  801867:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80186b:	85 f6                	test   %esi,%esi
  80186d:	75 2d                	jne    80189c <__udivdi3+0x50>
  80186f:	39 cf                	cmp    %ecx,%edi
  801871:	77 65                	ja     8018d8 <__udivdi3+0x8c>
  801873:	89 fd                	mov    %edi,%ebp
  801875:	85 ff                	test   %edi,%edi
  801877:	75 0b                	jne    801884 <__udivdi3+0x38>
  801879:	b8 01 00 00 00       	mov    $0x1,%eax
  80187e:	31 d2                	xor    %edx,%edx
  801880:	f7 f7                	div    %edi
  801882:	89 c5                	mov    %eax,%ebp
  801884:	31 d2                	xor    %edx,%edx
  801886:	89 c8                	mov    %ecx,%eax
  801888:	f7 f5                	div    %ebp
  80188a:	89 c1                	mov    %eax,%ecx
  80188c:	89 d8                	mov    %ebx,%eax
  80188e:	f7 f5                	div    %ebp
  801890:	89 cf                	mov    %ecx,%edi
  801892:	89 fa                	mov    %edi,%edx
  801894:	83 c4 1c             	add    $0x1c,%esp
  801897:	5b                   	pop    %ebx
  801898:	5e                   	pop    %esi
  801899:	5f                   	pop    %edi
  80189a:	5d                   	pop    %ebp
  80189b:	c3                   	ret    
  80189c:	39 ce                	cmp    %ecx,%esi
  80189e:	77 28                	ja     8018c8 <__udivdi3+0x7c>
  8018a0:	0f bd fe             	bsr    %esi,%edi
  8018a3:	83 f7 1f             	xor    $0x1f,%edi
  8018a6:	75 40                	jne    8018e8 <__udivdi3+0x9c>
  8018a8:	39 ce                	cmp    %ecx,%esi
  8018aa:	72 0a                	jb     8018b6 <__udivdi3+0x6a>
  8018ac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8018b0:	0f 87 9e 00 00 00    	ja     801954 <__udivdi3+0x108>
  8018b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8018bb:	89 fa                	mov    %edi,%edx
  8018bd:	83 c4 1c             	add    $0x1c,%esp
  8018c0:	5b                   	pop    %ebx
  8018c1:	5e                   	pop    %esi
  8018c2:	5f                   	pop    %edi
  8018c3:	5d                   	pop    %ebp
  8018c4:	c3                   	ret    
  8018c5:	8d 76 00             	lea    0x0(%esi),%esi
  8018c8:	31 ff                	xor    %edi,%edi
  8018ca:	31 c0                	xor    %eax,%eax
  8018cc:	89 fa                	mov    %edi,%edx
  8018ce:	83 c4 1c             	add    $0x1c,%esp
  8018d1:	5b                   	pop    %ebx
  8018d2:	5e                   	pop    %esi
  8018d3:	5f                   	pop    %edi
  8018d4:	5d                   	pop    %ebp
  8018d5:	c3                   	ret    
  8018d6:	66 90                	xchg   %ax,%ax
  8018d8:	89 d8                	mov    %ebx,%eax
  8018da:	f7 f7                	div    %edi
  8018dc:	31 ff                	xor    %edi,%edi
  8018de:	89 fa                	mov    %edi,%edx
  8018e0:	83 c4 1c             	add    $0x1c,%esp
  8018e3:	5b                   	pop    %ebx
  8018e4:	5e                   	pop    %esi
  8018e5:	5f                   	pop    %edi
  8018e6:	5d                   	pop    %ebp
  8018e7:	c3                   	ret    
  8018e8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8018ed:	89 eb                	mov    %ebp,%ebx
  8018ef:	29 fb                	sub    %edi,%ebx
  8018f1:	89 f9                	mov    %edi,%ecx
  8018f3:	d3 e6                	shl    %cl,%esi
  8018f5:	89 c5                	mov    %eax,%ebp
  8018f7:	88 d9                	mov    %bl,%cl
  8018f9:	d3 ed                	shr    %cl,%ebp
  8018fb:	89 e9                	mov    %ebp,%ecx
  8018fd:	09 f1                	or     %esi,%ecx
  8018ff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801903:	89 f9                	mov    %edi,%ecx
  801905:	d3 e0                	shl    %cl,%eax
  801907:	89 c5                	mov    %eax,%ebp
  801909:	89 d6                	mov    %edx,%esi
  80190b:	88 d9                	mov    %bl,%cl
  80190d:	d3 ee                	shr    %cl,%esi
  80190f:	89 f9                	mov    %edi,%ecx
  801911:	d3 e2                	shl    %cl,%edx
  801913:	8b 44 24 08          	mov    0x8(%esp),%eax
  801917:	88 d9                	mov    %bl,%cl
  801919:	d3 e8                	shr    %cl,%eax
  80191b:	09 c2                	or     %eax,%edx
  80191d:	89 d0                	mov    %edx,%eax
  80191f:	89 f2                	mov    %esi,%edx
  801921:	f7 74 24 0c          	divl   0xc(%esp)
  801925:	89 d6                	mov    %edx,%esi
  801927:	89 c3                	mov    %eax,%ebx
  801929:	f7 e5                	mul    %ebp
  80192b:	39 d6                	cmp    %edx,%esi
  80192d:	72 19                	jb     801948 <__udivdi3+0xfc>
  80192f:	74 0b                	je     80193c <__udivdi3+0xf0>
  801931:	89 d8                	mov    %ebx,%eax
  801933:	31 ff                	xor    %edi,%edi
  801935:	e9 58 ff ff ff       	jmp    801892 <__udivdi3+0x46>
  80193a:	66 90                	xchg   %ax,%ax
  80193c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801940:	89 f9                	mov    %edi,%ecx
  801942:	d3 e2                	shl    %cl,%edx
  801944:	39 c2                	cmp    %eax,%edx
  801946:	73 e9                	jae    801931 <__udivdi3+0xe5>
  801948:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80194b:	31 ff                	xor    %edi,%edi
  80194d:	e9 40 ff ff ff       	jmp    801892 <__udivdi3+0x46>
  801952:	66 90                	xchg   %ax,%ax
  801954:	31 c0                	xor    %eax,%eax
  801956:	e9 37 ff ff ff       	jmp    801892 <__udivdi3+0x46>
  80195b:	90                   	nop

0080195c <__umoddi3>:
  80195c:	55                   	push   %ebp
  80195d:	57                   	push   %edi
  80195e:	56                   	push   %esi
  80195f:	53                   	push   %ebx
  801960:	83 ec 1c             	sub    $0x1c,%esp
  801963:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801967:	8b 74 24 34          	mov    0x34(%esp),%esi
  80196b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80196f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801973:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801977:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80197b:	89 f3                	mov    %esi,%ebx
  80197d:	89 fa                	mov    %edi,%edx
  80197f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801983:	89 34 24             	mov    %esi,(%esp)
  801986:	85 c0                	test   %eax,%eax
  801988:	75 1a                	jne    8019a4 <__umoddi3+0x48>
  80198a:	39 f7                	cmp    %esi,%edi
  80198c:	0f 86 a2 00 00 00    	jbe    801a34 <__umoddi3+0xd8>
  801992:	89 c8                	mov    %ecx,%eax
  801994:	89 f2                	mov    %esi,%edx
  801996:	f7 f7                	div    %edi
  801998:	89 d0                	mov    %edx,%eax
  80199a:	31 d2                	xor    %edx,%edx
  80199c:	83 c4 1c             	add    $0x1c,%esp
  80199f:	5b                   	pop    %ebx
  8019a0:	5e                   	pop    %esi
  8019a1:	5f                   	pop    %edi
  8019a2:	5d                   	pop    %ebp
  8019a3:	c3                   	ret    
  8019a4:	39 f0                	cmp    %esi,%eax
  8019a6:	0f 87 ac 00 00 00    	ja     801a58 <__umoddi3+0xfc>
  8019ac:	0f bd e8             	bsr    %eax,%ebp
  8019af:	83 f5 1f             	xor    $0x1f,%ebp
  8019b2:	0f 84 ac 00 00 00    	je     801a64 <__umoddi3+0x108>
  8019b8:	bf 20 00 00 00       	mov    $0x20,%edi
  8019bd:	29 ef                	sub    %ebp,%edi
  8019bf:	89 fe                	mov    %edi,%esi
  8019c1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8019c5:	89 e9                	mov    %ebp,%ecx
  8019c7:	d3 e0                	shl    %cl,%eax
  8019c9:	89 d7                	mov    %edx,%edi
  8019cb:	89 f1                	mov    %esi,%ecx
  8019cd:	d3 ef                	shr    %cl,%edi
  8019cf:	09 c7                	or     %eax,%edi
  8019d1:	89 e9                	mov    %ebp,%ecx
  8019d3:	d3 e2                	shl    %cl,%edx
  8019d5:	89 14 24             	mov    %edx,(%esp)
  8019d8:	89 d8                	mov    %ebx,%eax
  8019da:	d3 e0                	shl    %cl,%eax
  8019dc:	89 c2                	mov    %eax,%edx
  8019de:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019e2:	d3 e0                	shl    %cl,%eax
  8019e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019ec:	89 f1                	mov    %esi,%ecx
  8019ee:	d3 e8                	shr    %cl,%eax
  8019f0:	09 d0                	or     %edx,%eax
  8019f2:	d3 eb                	shr    %cl,%ebx
  8019f4:	89 da                	mov    %ebx,%edx
  8019f6:	f7 f7                	div    %edi
  8019f8:	89 d3                	mov    %edx,%ebx
  8019fa:	f7 24 24             	mull   (%esp)
  8019fd:	89 c6                	mov    %eax,%esi
  8019ff:	89 d1                	mov    %edx,%ecx
  801a01:	39 d3                	cmp    %edx,%ebx
  801a03:	0f 82 87 00 00 00    	jb     801a90 <__umoddi3+0x134>
  801a09:	0f 84 91 00 00 00    	je     801aa0 <__umoddi3+0x144>
  801a0f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a13:	29 f2                	sub    %esi,%edx
  801a15:	19 cb                	sbb    %ecx,%ebx
  801a17:	89 d8                	mov    %ebx,%eax
  801a19:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a1d:	d3 e0                	shl    %cl,%eax
  801a1f:	89 e9                	mov    %ebp,%ecx
  801a21:	d3 ea                	shr    %cl,%edx
  801a23:	09 d0                	or     %edx,%eax
  801a25:	89 e9                	mov    %ebp,%ecx
  801a27:	d3 eb                	shr    %cl,%ebx
  801a29:	89 da                	mov    %ebx,%edx
  801a2b:	83 c4 1c             	add    $0x1c,%esp
  801a2e:	5b                   	pop    %ebx
  801a2f:	5e                   	pop    %esi
  801a30:	5f                   	pop    %edi
  801a31:	5d                   	pop    %ebp
  801a32:	c3                   	ret    
  801a33:	90                   	nop
  801a34:	89 fd                	mov    %edi,%ebp
  801a36:	85 ff                	test   %edi,%edi
  801a38:	75 0b                	jne    801a45 <__umoddi3+0xe9>
  801a3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a3f:	31 d2                	xor    %edx,%edx
  801a41:	f7 f7                	div    %edi
  801a43:	89 c5                	mov    %eax,%ebp
  801a45:	89 f0                	mov    %esi,%eax
  801a47:	31 d2                	xor    %edx,%edx
  801a49:	f7 f5                	div    %ebp
  801a4b:	89 c8                	mov    %ecx,%eax
  801a4d:	f7 f5                	div    %ebp
  801a4f:	89 d0                	mov    %edx,%eax
  801a51:	e9 44 ff ff ff       	jmp    80199a <__umoddi3+0x3e>
  801a56:	66 90                	xchg   %ax,%ax
  801a58:	89 c8                	mov    %ecx,%eax
  801a5a:	89 f2                	mov    %esi,%edx
  801a5c:	83 c4 1c             	add    $0x1c,%esp
  801a5f:	5b                   	pop    %ebx
  801a60:	5e                   	pop    %esi
  801a61:	5f                   	pop    %edi
  801a62:	5d                   	pop    %ebp
  801a63:	c3                   	ret    
  801a64:	3b 04 24             	cmp    (%esp),%eax
  801a67:	72 06                	jb     801a6f <__umoddi3+0x113>
  801a69:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a6d:	77 0f                	ja     801a7e <__umoddi3+0x122>
  801a6f:	89 f2                	mov    %esi,%edx
  801a71:	29 f9                	sub    %edi,%ecx
  801a73:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801a77:	89 14 24             	mov    %edx,(%esp)
  801a7a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a7e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801a82:	8b 14 24             	mov    (%esp),%edx
  801a85:	83 c4 1c             	add    $0x1c,%esp
  801a88:	5b                   	pop    %ebx
  801a89:	5e                   	pop    %esi
  801a8a:	5f                   	pop    %edi
  801a8b:	5d                   	pop    %ebp
  801a8c:	c3                   	ret    
  801a8d:	8d 76 00             	lea    0x0(%esi),%esi
  801a90:	2b 04 24             	sub    (%esp),%eax
  801a93:	19 fa                	sbb    %edi,%edx
  801a95:	89 d1                	mov    %edx,%ecx
  801a97:	89 c6                	mov    %eax,%esi
  801a99:	e9 71 ff ff ff       	jmp    801a0f <__umoddi3+0xb3>
  801a9e:	66 90                	xchg   %ax,%ax
  801aa0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801aa4:	72 ea                	jb     801a90 <__umoddi3+0x134>
  801aa6:	89 d9                	mov    %ebx,%ecx
  801aa8:	e9 62 ff ff ff       	jmp    801a0f <__umoddi3+0xb3>
