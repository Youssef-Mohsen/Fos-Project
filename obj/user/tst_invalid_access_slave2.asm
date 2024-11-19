
obj/user/tst_invalid_access_slave2:     file format elf32-i386


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
  800031:	e8 31 00 00 00       	call   800067 <libmain>
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
	//[1] User address but READ-ONLY
	uint32 *ptr = (uint32*)USER_TOP;
  80003e:	c7 45 f4 00 00 c0 ee 	movl   $0xeec00000,-0xc(%ebp)
	*ptr = 100 ;
  800045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800048:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	inctst();
  80004e:	e8 c9 15 00 00       	call   80161c <inctst>
	panic("tst invalid access failed: Attempt to write on a READ-ONLY user page.\nThe env must be killed and shouldn't return here.");
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	68 a0 1a 80 00       	push   $0x801aa0
  80005b:	6a 0e                	push   $0xe
  80005d:	68 18 1b 80 00       	push   $0x801b18
  800062:	e8 37 01 00 00       	call   80019e <_panic>

00800067 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800067:	55                   	push   %ebp
  800068:	89 e5                	mov    %esp,%ebp
  80006a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80006d:	e8 6c 14 00 00       	call   8014de <sys_getenvindex>
  800072:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800075:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800078:	89 d0                	mov    %edx,%eax
  80007a:	c1 e0 02             	shl    $0x2,%eax
  80007d:	01 d0                	add    %edx,%eax
  80007f:	01 c0                	add    %eax,%eax
  800081:	01 d0                	add    %edx,%eax
  800083:	c1 e0 02             	shl    $0x2,%eax
  800086:	01 d0                	add    %edx,%eax
  800088:	01 c0                	add    %eax,%eax
  80008a:	01 d0                	add    %edx,%eax
  80008c:	c1 e0 04             	shl    $0x4,%eax
  80008f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800094:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800099:	a1 04 30 80 00       	mov    0x803004,%eax
  80009e:	8a 40 20             	mov    0x20(%eax),%al
  8000a1:	84 c0                	test   %al,%al
  8000a3:	74 0d                	je     8000b2 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8000a5:	a1 04 30 80 00       	mov    0x803004,%eax
  8000aa:	83 c0 20             	add    $0x20,%eax
  8000ad:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b6:	7e 0a                	jle    8000c2 <libmain+0x5b>
		binaryname = argv[0];
  8000b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000bb:	8b 00                	mov    (%eax),%eax
  8000bd:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000c2:	83 ec 08             	sub    $0x8,%esp
  8000c5:	ff 75 0c             	pushl  0xc(%ebp)
  8000c8:	ff 75 08             	pushl  0x8(%ebp)
  8000cb:	e8 68 ff ff ff       	call   800038 <_main>
  8000d0:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8000d3:	e8 8a 11 00 00       	call   801262 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 54 1b 80 00       	push   $0x801b54
  8000e0:	e8 76 03 00 00       	call   80045b <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000e8:	a1 04 30 80 00       	mov    0x803004,%eax
  8000ed:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8000f3:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f8:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8000fe:	83 ec 04             	sub    $0x4,%esp
  800101:	52                   	push   %edx
  800102:	50                   	push   %eax
  800103:	68 7c 1b 80 00       	push   $0x801b7c
  800108:	e8 4e 03 00 00       	call   80045b <cprintf>
  80010d:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800110:	a1 04 30 80 00       	mov    0x803004,%eax
  800115:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  80011b:	a1 04 30 80 00       	mov    0x803004,%eax
  800120:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800126:	a1 04 30 80 00       	mov    0x803004,%eax
  80012b:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800131:	51                   	push   %ecx
  800132:	52                   	push   %edx
  800133:	50                   	push   %eax
  800134:	68 a4 1b 80 00       	push   $0x801ba4
  800139:	e8 1d 03 00 00       	call   80045b <cprintf>
  80013e:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800141:	a1 04 30 80 00       	mov    0x803004,%eax
  800146:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80014c:	83 ec 08             	sub    $0x8,%esp
  80014f:	50                   	push   %eax
  800150:	68 fc 1b 80 00       	push   $0x801bfc
  800155:	e8 01 03 00 00       	call   80045b <cprintf>
  80015a:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80015d:	83 ec 0c             	sub    $0xc,%esp
  800160:	68 54 1b 80 00       	push   $0x801b54
  800165:	e8 f1 02 00 00       	call   80045b <cprintf>
  80016a:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80016d:	e8 0a 11 00 00       	call   80127c <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800172:	e8 19 00 00 00       	call   800190 <exit>
}
  800177:	90                   	nop
  800178:	c9                   	leave  
  800179:	c3                   	ret    

0080017a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800180:	83 ec 0c             	sub    $0xc,%esp
  800183:	6a 00                	push   $0x0
  800185:	e8 20 13 00 00       	call   8014aa <sys_destroy_env>
  80018a:	83 c4 10             	add    $0x10,%esp
}
  80018d:	90                   	nop
  80018e:	c9                   	leave  
  80018f:	c3                   	ret    

00800190 <exit>:

void
exit(void)
{
  800190:	55                   	push   %ebp
  800191:	89 e5                	mov    %esp,%ebp
  800193:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800196:	e8 75 13 00 00       	call   801510 <sys_exit_env>
}
  80019b:	90                   	nop
  80019c:	c9                   	leave  
  80019d:	c3                   	ret    

0080019e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80019e:	55                   	push   %ebp
  80019f:	89 e5                	mov    %esp,%ebp
  8001a1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001a4:	8d 45 10             	lea    0x10(%ebp),%eax
  8001a7:	83 c0 04             	add    $0x4,%eax
  8001aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001ad:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8001b2:	85 c0                	test   %eax,%eax
  8001b4:	74 16                	je     8001cc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001b6:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8001bb:	83 ec 08             	sub    $0x8,%esp
  8001be:	50                   	push   %eax
  8001bf:	68 10 1c 80 00       	push   $0x801c10
  8001c4:	e8 92 02 00 00       	call   80045b <cprintf>
  8001c9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001cc:	a1 00 30 80 00       	mov    0x803000,%eax
  8001d1:	ff 75 0c             	pushl  0xc(%ebp)
  8001d4:	ff 75 08             	pushl  0x8(%ebp)
  8001d7:	50                   	push   %eax
  8001d8:	68 15 1c 80 00       	push   $0x801c15
  8001dd:	e8 79 02 00 00       	call   80045b <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e8:	83 ec 08             	sub    $0x8,%esp
  8001eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8001ee:	50                   	push   %eax
  8001ef:	e8 fc 01 00 00       	call   8003f0 <vcprintf>
  8001f4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8001f7:	83 ec 08             	sub    $0x8,%esp
  8001fa:	6a 00                	push   $0x0
  8001fc:	68 31 1c 80 00       	push   $0x801c31
  800201:	e8 ea 01 00 00       	call   8003f0 <vcprintf>
  800206:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800209:	e8 82 ff ff ff       	call   800190 <exit>

	// should not return here
	while (1) ;
  80020e:	eb fe                	jmp    80020e <_panic+0x70>

00800210 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800216:	a1 04 30 80 00       	mov    0x803004,%eax
  80021b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800221:	8b 45 0c             	mov    0xc(%ebp),%eax
  800224:	39 c2                	cmp    %eax,%edx
  800226:	74 14                	je     80023c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800228:	83 ec 04             	sub    $0x4,%esp
  80022b:	68 34 1c 80 00       	push   $0x801c34
  800230:	6a 26                	push   $0x26
  800232:	68 80 1c 80 00       	push   $0x801c80
  800237:	e8 62 ff ff ff       	call   80019e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80023c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800243:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80024a:	e9 c5 00 00 00       	jmp    800314 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80024f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800252:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800259:	8b 45 08             	mov    0x8(%ebp),%eax
  80025c:	01 d0                	add    %edx,%eax
  80025e:	8b 00                	mov    (%eax),%eax
  800260:	85 c0                	test   %eax,%eax
  800262:	75 08                	jne    80026c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800264:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800267:	e9 a5 00 00 00       	jmp    800311 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80026c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800273:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80027a:	eb 69                	jmp    8002e5 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80027c:	a1 04 30 80 00       	mov    0x803004,%eax
  800281:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800287:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80028a:	89 d0                	mov    %edx,%eax
  80028c:	01 c0                	add    %eax,%eax
  80028e:	01 d0                	add    %edx,%eax
  800290:	c1 e0 03             	shl    $0x3,%eax
  800293:	01 c8                	add    %ecx,%eax
  800295:	8a 40 04             	mov    0x4(%eax),%al
  800298:	84 c0                	test   %al,%al
  80029a:	75 46                	jne    8002e2 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80029c:	a1 04 30 80 00       	mov    0x803004,%eax
  8002a1:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8002a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002aa:	89 d0                	mov    %edx,%eax
  8002ac:	01 c0                	add    %eax,%eax
  8002ae:	01 d0                	add    %edx,%eax
  8002b0:	c1 e0 03             	shl    $0x3,%eax
  8002b3:	01 c8                	add    %ecx,%eax
  8002b5:	8b 00                	mov    (%eax),%eax
  8002b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002c2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d1:	01 c8                	add    %ecx,%eax
  8002d3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002d5:	39 c2                	cmp    %eax,%edx
  8002d7:	75 09                	jne    8002e2 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002d9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002e0:	eb 15                	jmp    8002f7 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002e2:	ff 45 e8             	incl   -0x18(%ebp)
  8002e5:	a1 04 30 80 00       	mov    0x803004,%eax
  8002ea:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8002f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002f3:	39 c2                	cmp    %eax,%edx
  8002f5:	77 85                	ja     80027c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8002f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8002fb:	75 14                	jne    800311 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8002fd:	83 ec 04             	sub    $0x4,%esp
  800300:	68 8c 1c 80 00       	push   $0x801c8c
  800305:	6a 3a                	push   $0x3a
  800307:	68 80 1c 80 00       	push   $0x801c80
  80030c:	e8 8d fe ff ff       	call   80019e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800311:	ff 45 f0             	incl   -0x10(%ebp)
  800314:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800317:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80031a:	0f 8c 2f ff ff ff    	jl     80024f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800320:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800327:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80032e:	eb 26                	jmp    800356 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800330:	a1 04 30 80 00       	mov    0x803004,%eax
  800335:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80033b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80033e:	89 d0                	mov    %edx,%eax
  800340:	01 c0                	add    %eax,%eax
  800342:	01 d0                	add    %edx,%eax
  800344:	c1 e0 03             	shl    $0x3,%eax
  800347:	01 c8                	add    %ecx,%eax
  800349:	8a 40 04             	mov    0x4(%eax),%al
  80034c:	3c 01                	cmp    $0x1,%al
  80034e:	75 03                	jne    800353 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800350:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800353:	ff 45 e0             	incl   -0x20(%ebp)
  800356:	a1 04 30 80 00       	mov    0x803004,%eax
  80035b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800361:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800364:	39 c2                	cmp    %eax,%edx
  800366:	77 c8                	ja     800330 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80036e:	74 14                	je     800384 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	68 e0 1c 80 00       	push   $0x801ce0
  800378:	6a 44                	push   $0x44
  80037a:	68 80 1c 80 00       	push   $0x801c80
  80037f:	e8 1a fe ff ff       	call   80019e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800384:	90                   	nop
  800385:	c9                   	leave  
  800386:	c3                   	ret    

00800387 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800387:	55                   	push   %ebp
  800388:	89 e5                	mov    %esp,%ebp
  80038a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80038d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800390:	8b 00                	mov    (%eax),%eax
  800392:	8d 48 01             	lea    0x1(%eax),%ecx
  800395:	8b 55 0c             	mov    0xc(%ebp),%edx
  800398:	89 0a                	mov    %ecx,(%edx)
  80039a:	8b 55 08             	mov    0x8(%ebp),%edx
  80039d:	88 d1                	mov    %dl,%cl
  80039f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a9:	8b 00                	mov    (%eax),%eax
  8003ab:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b0:	75 2c                	jne    8003de <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003b2:	a0 08 30 80 00       	mov    0x803008,%al
  8003b7:	0f b6 c0             	movzbl %al,%eax
  8003ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bd:	8b 12                	mov    (%edx),%edx
  8003bf:	89 d1                	mov    %edx,%ecx
  8003c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c4:	83 c2 08             	add    $0x8,%edx
  8003c7:	83 ec 04             	sub    $0x4,%esp
  8003ca:	50                   	push   %eax
  8003cb:	51                   	push   %ecx
  8003cc:	52                   	push   %edx
  8003cd:	e8 4e 0e 00 00       	call   801220 <sys_cputs>
  8003d2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e1:	8b 40 04             	mov    0x4(%eax),%eax
  8003e4:	8d 50 01             	lea    0x1(%eax),%edx
  8003e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ea:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003ed:	90                   	nop
  8003ee:	c9                   	leave  
  8003ef:	c3                   	ret    

008003f0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003f9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800400:	00 00 00 
	b.cnt = 0;
  800403:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80040a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80040d:	ff 75 0c             	pushl  0xc(%ebp)
  800410:	ff 75 08             	pushl  0x8(%ebp)
  800413:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800419:	50                   	push   %eax
  80041a:	68 87 03 80 00       	push   $0x800387
  80041f:	e8 11 02 00 00       	call   800635 <vprintfmt>
  800424:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800427:	a0 08 30 80 00       	mov    0x803008,%al
  80042c:	0f b6 c0             	movzbl %al,%eax
  80042f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800435:	83 ec 04             	sub    $0x4,%esp
  800438:	50                   	push   %eax
  800439:	52                   	push   %edx
  80043a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800440:	83 c0 08             	add    $0x8,%eax
  800443:	50                   	push   %eax
  800444:	e8 d7 0d 00 00       	call   801220 <sys_cputs>
  800449:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80044c:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800453:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800459:	c9                   	leave  
  80045a:	c3                   	ret    

0080045b <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80045b:	55                   	push   %ebp
  80045c:	89 e5                	mov    %esp,%ebp
  80045e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800461:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800468:	8d 45 0c             	lea    0xc(%ebp),%eax
  80046b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80046e:	8b 45 08             	mov    0x8(%ebp),%eax
  800471:	83 ec 08             	sub    $0x8,%esp
  800474:	ff 75 f4             	pushl  -0xc(%ebp)
  800477:	50                   	push   %eax
  800478:	e8 73 ff ff ff       	call   8003f0 <vcprintf>
  80047d:	83 c4 10             	add    $0x10,%esp
  800480:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800483:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800486:	c9                   	leave  
  800487:	c3                   	ret    

00800488 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800488:	55                   	push   %ebp
  800489:	89 e5                	mov    %esp,%ebp
  80048b:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80048e:	e8 cf 0d 00 00       	call   801262 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800493:	8d 45 0c             	lea    0xc(%ebp),%eax
  800496:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	83 ec 08             	sub    $0x8,%esp
  80049f:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a2:	50                   	push   %eax
  8004a3:	e8 48 ff ff ff       	call   8003f0 <vcprintf>
  8004a8:	83 c4 10             	add    $0x10,%esp
  8004ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004ae:	e8 c9 0d 00 00       	call   80127c <sys_unlock_cons>
	return cnt;
  8004b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004b6:	c9                   	leave  
  8004b7:	c3                   	ret    

008004b8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004b8:	55                   	push   %ebp
  8004b9:	89 e5                	mov    %esp,%ebp
  8004bb:	53                   	push   %ebx
  8004bc:	83 ec 14             	sub    $0x14,%esp
  8004bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004cb:	8b 45 18             	mov    0x18(%ebp),%eax
  8004ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004d6:	77 55                	ja     80052d <printnum+0x75>
  8004d8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004db:	72 05                	jb     8004e2 <printnum+0x2a>
  8004dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004e0:	77 4b                	ja     80052d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004e2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004e5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004e8:	8b 45 18             	mov    0x18(%ebp),%eax
  8004eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f0:	52                   	push   %edx
  8004f1:	50                   	push   %eax
  8004f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8004f8:	e8 23 13 00 00       	call   801820 <__udivdi3>
  8004fd:	83 c4 10             	add    $0x10,%esp
  800500:	83 ec 04             	sub    $0x4,%esp
  800503:	ff 75 20             	pushl  0x20(%ebp)
  800506:	53                   	push   %ebx
  800507:	ff 75 18             	pushl  0x18(%ebp)
  80050a:	52                   	push   %edx
  80050b:	50                   	push   %eax
  80050c:	ff 75 0c             	pushl  0xc(%ebp)
  80050f:	ff 75 08             	pushl  0x8(%ebp)
  800512:	e8 a1 ff ff ff       	call   8004b8 <printnum>
  800517:	83 c4 20             	add    $0x20,%esp
  80051a:	eb 1a                	jmp    800536 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80051c:	83 ec 08             	sub    $0x8,%esp
  80051f:	ff 75 0c             	pushl  0xc(%ebp)
  800522:	ff 75 20             	pushl  0x20(%ebp)
  800525:	8b 45 08             	mov    0x8(%ebp),%eax
  800528:	ff d0                	call   *%eax
  80052a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80052d:	ff 4d 1c             	decl   0x1c(%ebp)
  800530:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800534:	7f e6                	jg     80051c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800536:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800539:	bb 00 00 00 00       	mov    $0x0,%ebx
  80053e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800541:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800544:	53                   	push   %ebx
  800545:	51                   	push   %ecx
  800546:	52                   	push   %edx
  800547:	50                   	push   %eax
  800548:	e8 e3 13 00 00       	call   801930 <__umoddi3>
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	05 54 1f 80 00       	add    $0x801f54,%eax
  800555:	8a 00                	mov    (%eax),%al
  800557:	0f be c0             	movsbl %al,%eax
  80055a:	83 ec 08             	sub    $0x8,%esp
  80055d:	ff 75 0c             	pushl  0xc(%ebp)
  800560:	50                   	push   %eax
  800561:	8b 45 08             	mov    0x8(%ebp),%eax
  800564:	ff d0                	call   *%eax
  800566:	83 c4 10             	add    $0x10,%esp
}
  800569:	90                   	nop
  80056a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80056d:	c9                   	leave  
  80056e:	c3                   	ret    

0080056f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80056f:	55                   	push   %ebp
  800570:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800572:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800576:	7e 1c                	jle    800594 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800578:	8b 45 08             	mov    0x8(%ebp),%eax
  80057b:	8b 00                	mov    (%eax),%eax
  80057d:	8d 50 08             	lea    0x8(%eax),%edx
  800580:	8b 45 08             	mov    0x8(%ebp),%eax
  800583:	89 10                	mov    %edx,(%eax)
  800585:	8b 45 08             	mov    0x8(%ebp),%eax
  800588:	8b 00                	mov    (%eax),%eax
  80058a:	83 e8 08             	sub    $0x8,%eax
  80058d:	8b 50 04             	mov    0x4(%eax),%edx
  800590:	8b 00                	mov    (%eax),%eax
  800592:	eb 40                	jmp    8005d4 <getuint+0x65>
	else if (lflag)
  800594:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800598:	74 1e                	je     8005b8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	8d 50 04             	lea    0x4(%eax),%edx
  8005a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a5:	89 10                	mov    %edx,(%eax)
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	8b 00                	mov    (%eax),%eax
  8005ac:	83 e8 04             	sub    $0x4,%eax
  8005af:	8b 00                	mov    (%eax),%eax
  8005b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b6:	eb 1c                	jmp    8005d4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bb:	8b 00                	mov    (%eax),%eax
  8005bd:	8d 50 04             	lea    0x4(%eax),%edx
  8005c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c3:	89 10                	mov    %edx,(%eax)
  8005c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	83 e8 04             	sub    $0x4,%eax
  8005cd:	8b 00                	mov    (%eax),%eax
  8005cf:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005d4:	5d                   	pop    %ebp
  8005d5:	c3                   	ret    

008005d6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005d6:	55                   	push   %ebp
  8005d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005d9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005dd:	7e 1c                	jle    8005fb <getint+0x25>
		return va_arg(*ap, long long);
  8005df:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	8d 50 08             	lea    0x8(%eax),%edx
  8005e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ea:	89 10                	mov    %edx,(%eax)
  8005ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ef:	8b 00                	mov    (%eax),%eax
  8005f1:	83 e8 08             	sub    $0x8,%eax
  8005f4:	8b 50 04             	mov    0x4(%eax),%edx
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	eb 38                	jmp    800633 <getint+0x5d>
	else if (lflag)
  8005fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005ff:	74 1a                	je     80061b <getint+0x45>
		return va_arg(*ap, long);
  800601:	8b 45 08             	mov    0x8(%ebp),%eax
  800604:	8b 00                	mov    (%eax),%eax
  800606:	8d 50 04             	lea    0x4(%eax),%edx
  800609:	8b 45 08             	mov    0x8(%ebp),%eax
  80060c:	89 10                	mov    %edx,(%eax)
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	8b 00                	mov    (%eax),%eax
  800613:	83 e8 04             	sub    $0x4,%eax
  800616:	8b 00                	mov    (%eax),%eax
  800618:	99                   	cltd   
  800619:	eb 18                	jmp    800633 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80061b:	8b 45 08             	mov    0x8(%ebp),%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	8d 50 04             	lea    0x4(%eax),%edx
  800623:	8b 45 08             	mov    0x8(%ebp),%eax
  800626:	89 10                	mov    %edx,(%eax)
  800628:	8b 45 08             	mov    0x8(%ebp),%eax
  80062b:	8b 00                	mov    (%eax),%eax
  80062d:	83 e8 04             	sub    $0x4,%eax
  800630:	8b 00                	mov    (%eax),%eax
  800632:	99                   	cltd   
}
  800633:	5d                   	pop    %ebp
  800634:	c3                   	ret    

00800635 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800635:	55                   	push   %ebp
  800636:	89 e5                	mov    %esp,%ebp
  800638:	56                   	push   %esi
  800639:	53                   	push   %ebx
  80063a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80063d:	eb 17                	jmp    800656 <vprintfmt+0x21>
			if (ch == '\0')
  80063f:	85 db                	test   %ebx,%ebx
  800641:	0f 84 c1 03 00 00    	je     800a08 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800647:	83 ec 08             	sub    $0x8,%esp
  80064a:	ff 75 0c             	pushl  0xc(%ebp)
  80064d:	53                   	push   %ebx
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	ff d0                	call   *%eax
  800653:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800656:	8b 45 10             	mov    0x10(%ebp),%eax
  800659:	8d 50 01             	lea    0x1(%eax),%edx
  80065c:	89 55 10             	mov    %edx,0x10(%ebp)
  80065f:	8a 00                	mov    (%eax),%al
  800661:	0f b6 d8             	movzbl %al,%ebx
  800664:	83 fb 25             	cmp    $0x25,%ebx
  800667:	75 d6                	jne    80063f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800669:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80066d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800674:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80067b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800682:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800689:	8b 45 10             	mov    0x10(%ebp),%eax
  80068c:	8d 50 01             	lea    0x1(%eax),%edx
  80068f:	89 55 10             	mov    %edx,0x10(%ebp)
  800692:	8a 00                	mov    (%eax),%al
  800694:	0f b6 d8             	movzbl %al,%ebx
  800697:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80069a:	83 f8 5b             	cmp    $0x5b,%eax
  80069d:	0f 87 3d 03 00 00    	ja     8009e0 <vprintfmt+0x3ab>
  8006a3:	8b 04 85 78 1f 80 00 	mov    0x801f78(,%eax,4),%eax
  8006aa:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006ac:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006b0:	eb d7                	jmp    800689 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006b2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006b6:	eb d1                	jmp    800689 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c2:	89 d0                	mov    %edx,%eax
  8006c4:	c1 e0 02             	shl    $0x2,%eax
  8006c7:	01 d0                	add    %edx,%eax
  8006c9:	01 c0                	add    %eax,%eax
  8006cb:	01 d8                	add    %ebx,%eax
  8006cd:	83 e8 30             	sub    $0x30,%eax
  8006d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d6:	8a 00                	mov    (%eax),%al
  8006d8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006db:	83 fb 2f             	cmp    $0x2f,%ebx
  8006de:	7e 3e                	jle    80071e <vprintfmt+0xe9>
  8006e0:	83 fb 39             	cmp    $0x39,%ebx
  8006e3:	7f 39                	jg     80071e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006e8:	eb d5                	jmp    8006bf <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	83 c0 04             	add    $0x4,%eax
  8006f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f6:	83 e8 04             	sub    $0x4,%eax
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006fe:	eb 1f                	jmp    80071f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800700:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800704:	79 83                	jns    800689 <vprintfmt+0x54>
				width = 0;
  800706:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80070d:	e9 77 ff ff ff       	jmp    800689 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800712:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800719:	e9 6b ff ff ff       	jmp    800689 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80071e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80071f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800723:	0f 89 60 ff ff ff    	jns    800689 <vprintfmt+0x54>
				width = precision, precision = -1;
  800729:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80072c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80072f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800736:	e9 4e ff ff ff       	jmp    800689 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80073b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80073e:	e9 46 ff ff ff       	jmp    800689 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	83 c0 04             	add    $0x4,%eax
  800749:	89 45 14             	mov    %eax,0x14(%ebp)
  80074c:	8b 45 14             	mov    0x14(%ebp),%eax
  80074f:	83 e8 04             	sub    $0x4,%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	83 ec 08             	sub    $0x8,%esp
  800757:	ff 75 0c             	pushl  0xc(%ebp)
  80075a:	50                   	push   %eax
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	ff d0                	call   *%eax
  800760:	83 c4 10             	add    $0x10,%esp
			break;
  800763:	e9 9b 02 00 00       	jmp    800a03 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	83 c0 04             	add    $0x4,%eax
  80076e:	89 45 14             	mov    %eax,0x14(%ebp)
  800771:	8b 45 14             	mov    0x14(%ebp),%eax
  800774:	83 e8 04             	sub    $0x4,%eax
  800777:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800779:	85 db                	test   %ebx,%ebx
  80077b:	79 02                	jns    80077f <vprintfmt+0x14a>
				err = -err;
  80077d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80077f:	83 fb 64             	cmp    $0x64,%ebx
  800782:	7f 0b                	jg     80078f <vprintfmt+0x15a>
  800784:	8b 34 9d c0 1d 80 00 	mov    0x801dc0(,%ebx,4),%esi
  80078b:	85 f6                	test   %esi,%esi
  80078d:	75 19                	jne    8007a8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80078f:	53                   	push   %ebx
  800790:	68 65 1f 80 00       	push   $0x801f65
  800795:	ff 75 0c             	pushl  0xc(%ebp)
  800798:	ff 75 08             	pushl  0x8(%ebp)
  80079b:	e8 70 02 00 00       	call   800a10 <printfmt>
  8007a0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007a3:	e9 5b 02 00 00       	jmp    800a03 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007a8:	56                   	push   %esi
  8007a9:	68 6e 1f 80 00       	push   $0x801f6e
  8007ae:	ff 75 0c             	pushl  0xc(%ebp)
  8007b1:	ff 75 08             	pushl  0x8(%ebp)
  8007b4:	e8 57 02 00 00       	call   800a10 <printfmt>
  8007b9:	83 c4 10             	add    $0x10,%esp
			break;
  8007bc:	e9 42 02 00 00       	jmp    800a03 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c4:	83 c0 04             	add    $0x4,%eax
  8007c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	83 e8 04             	sub    $0x4,%eax
  8007d0:	8b 30                	mov    (%eax),%esi
  8007d2:	85 f6                	test   %esi,%esi
  8007d4:	75 05                	jne    8007db <vprintfmt+0x1a6>
				p = "(null)";
  8007d6:	be 71 1f 80 00       	mov    $0x801f71,%esi
			if (width > 0 && padc != '-')
  8007db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007df:	7e 6d                	jle    80084e <vprintfmt+0x219>
  8007e1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007e5:	74 67                	je     80084e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	50                   	push   %eax
  8007ee:	56                   	push   %esi
  8007ef:	e8 1e 03 00 00       	call   800b12 <strnlen>
  8007f4:	83 c4 10             	add    $0x10,%esp
  8007f7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007fa:	eb 16                	jmp    800812 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007fc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800800:	83 ec 08             	sub    $0x8,%esp
  800803:	ff 75 0c             	pushl  0xc(%ebp)
  800806:	50                   	push   %eax
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	ff d0                	call   *%eax
  80080c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80080f:	ff 4d e4             	decl   -0x1c(%ebp)
  800812:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800816:	7f e4                	jg     8007fc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800818:	eb 34                	jmp    80084e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80081a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80081e:	74 1c                	je     80083c <vprintfmt+0x207>
  800820:	83 fb 1f             	cmp    $0x1f,%ebx
  800823:	7e 05                	jle    80082a <vprintfmt+0x1f5>
  800825:	83 fb 7e             	cmp    $0x7e,%ebx
  800828:	7e 12                	jle    80083c <vprintfmt+0x207>
					putch('?', putdat);
  80082a:	83 ec 08             	sub    $0x8,%esp
  80082d:	ff 75 0c             	pushl  0xc(%ebp)
  800830:	6a 3f                	push   $0x3f
  800832:	8b 45 08             	mov    0x8(%ebp),%eax
  800835:	ff d0                	call   *%eax
  800837:	83 c4 10             	add    $0x10,%esp
  80083a:	eb 0f                	jmp    80084b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 0c             	pushl  0xc(%ebp)
  800842:	53                   	push   %ebx
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	ff d0                	call   *%eax
  800848:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80084b:	ff 4d e4             	decl   -0x1c(%ebp)
  80084e:	89 f0                	mov    %esi,%eax
  800850:	8d 70 01             	lea    0x1(%eax),%esi
  800853:	8a 00                	mov    (%eax),%al
  800855:	0f be d8             	movsbl %al,%ebx
  800858:	85 db                	test   %ebx,%ebx
  80085a:	74 24                	je     800880 <vprintfmt+0x24b>
  80085c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800860:	78 b8                	js     80081a <vprintfmt+0x1e5>
  800862:	ff 4d e0             	decl   -0x20(%ebp)
  800865:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800869:	79 af                	jns    80081a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80086b:	eb 13                	jmp    800880 <vprintfmt+0x24b>
				putch(' ', putdat);
  80086d:	83 ec 08             	sub    $0x8,%esp
  800870:	ff 75 0c             	pushl  0xc(%ebp)
  800873:	6a 20                	push   $0x20
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	ff d0                	call   *%eax
  80087a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80087d:	ff 4d e4             	decl   -0x1c(%ebp)
  800880:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800884:	7f e7                	jg     80086d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800886:	e9 78 01 00 00       	jmp    800a03 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80088b:	83 ec 08             	sub    $0x8,%esp
  80088e:	ff 75 e8             	pushl  -0x18(%ebp)
  800891:	8d 45 14             	lea    0x14(%ebp),%eax
  800894:	50                   	push   %eax
  800895:	e8 3c fd ff ff       	call   8005d6 <getint>
  80089a:	83 c4 10             	add    $0x10,%esp
  80089d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a9:	85 d2                	test   %edx,%edx
  8008ab:	79 23                	jns    8008d0 <vprintfmt+0x29b>
				putch('-', putdat);
  8008ad:	83 ec 08             	sub    $0x8,%esp
  8008b0:	ff 75 0c             	pushl  0xc(%ebp)
  8008b3:	6a 2d                	push   $0x2d
  8008b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b8:	ff d0                	call   *%eax
  8008ba:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c3:	f7 d8                	neg    %eax
  8008c5:	83 d2 00             	adc    $0x0,%edx
  8008c8:	f7 da                	neg    %edx
  8008ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008d0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008d7:	e9 bc 00 00 00       	jmp    800998 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008dc:	83 ec 08             	sub    $0x8,%esp
  8008df:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e2:	8d 45 14             	lea    0x14(%ebp),%eax
  8008e5:	50                   	push   %eax
  8008e6:	e8 84 fc ff ff       	call   80056f <getuint>
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008f4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008fb:	e9 98 00 00 00       	jmp    800998 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800900:	83 ec 08             	sub    $0x8,%esp
  800903:	ff 75 0c             	pushl  0xc(%ebp)
  800906:	6a 58                	push   $0x58
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	ff d0                	call   *%eax
  80090d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800910:	83 ec 08             	sub    $0x8,%esp
  800913:	ff 75 0c             	pushl  0xc(%ebp)
  800916:	6a 58                	push   $0x58
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	ff d0                	call   *%eax
  80091d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800920:	83 ec 08             	sub    $0x8,%esp
  800923:	ff 75 0c             	pushl  0xc(%ebp)
  800926:	6a 58                	push   $0x58
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	ff d0                	call   *%eax
  80092d:	83 c4 10             	add    $0x10,%esp
			break;
  800930:	e9 ce 00 00 00       	jmp    800a03 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	ff 75 0c             	pushl  0xc(%ebp)
  80093b:	6a 30                	push   $0x30
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	ff d0                	call   *%eax
  800942:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	ff 75 0c             	pushl  0xc(%ebp)
  80094b:	6a 78                	push   $0x78
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	ff d0                	call   *%eax
  800952:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800955:	8b 45 14             	mov    0x14(%ebp),%eax
  800958:	83 c0 04             	add    $0x4,%eax
  80095b:	89 45 14             	mov    %eax,0x14(%ebp)
  80095e:	8b 45 14             	mov    0x14(%ebp),%eax
  800961:	83 e8 04             	sub    $0x4,%eax
  800964:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800966:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800969:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800970:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800977:	eb 1f                	jmp    800998 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800979:	83 ec 08             	sub    $0x8,%esp
  80097c:	ff 75 e8             	pushl  -0x18(%ebp)
  80097f:	8d 45 14             	lea    0x14(%ebp),%eax
  800982:	50                   	push   %eax
  800983:	e8 e7 fb ff ff       	call   80056f <getuint>
  800988:	83 c4 10             	add    $0x10,%esp
  80098b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80098e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800991:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800998:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80099c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80099f:	83 ec 04             	sub    $0x4,%esp
  8009a2:	52                   	push   %edx
  8009a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009a6:	50                   	push   %eax
  8009a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8009aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8009ad:	ff 75 0c             	pushl  0xc(%ebp)
  8009b0:	ff 75 08             	pushl  0x8(%ebp)
  8009b3:	e8 00 fb ff ff       	call   8004b8 <printnum>
  8009b8:	83 c4 20             	add    $0x20,%esp
			break;
  8009bb:	eb 46                	jmp    800a03 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009bd:	83 ec 08             	sub    $0x8,%esp
  8009c0:	ff 75 0c             	pushl  0xc(%ebp)
  8009c3:	53                   	push   %ebx
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	ff d0                	call   *%eax
  8009c9:	83 c4 10             	add    $0x10,%esp
			break;
  8009cc:	eb 35                	jmp    800a03 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009ce:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8009d5:	eb 2c                	jmp    800a03 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009d7:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8009de:	eb 23                	jmp    800a03 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	ff 75 0c             	pushl  0xc(%ebp)
  8009e6:	6a 25                	push   $0x25
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	ff d0                	call   *%eax
  8009ed:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009f0:	ff 4d 10             	decl   0x10(%ebp)
  8009f3:	eb 03                	jmp    8009f8 <vprintfmt+0x3c3>
  8009f5:	ff 4d 10             	decl   0x10(%ebp)
  8009f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fb:	48                   	dec    %eax
  8009fc:	8a 00                	mov    (%eax),%al
  8009fe:	3c 25                	cmp    $0x25,%al
  800a00:	75 f3                	jne    8009f5 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a02:	90                   	nop
		}
	}
  800a03:	e9 35 fc ff ff       	jmp    80063d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a08:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a0c:	5b                   	pop    %ebx
  800a0d:	5e                   	pop    %esi
  800a0e:	5d                   	pop    %ebp
  800a0f:	c3                   	ret    

00800a10 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a16:	8d 45 10             	lea    0x10(%ebp),%eax
  800a19:	83 c0 04             	add    $0x4,%eax
  800a1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800a22:	ff 75 f4             	pushl  -0xc(%ebp)
  800a25:	50                   	push   %eax
  800a26:	ff 75 0c             	pushl  0xc(%ebp)
  800a29:	ff 75 08             	pushl  0x8(%ebp)
  800a2c:	e8 04 fc ff ff       	call   800635 <vprintfmt>
  800a31:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a34:	90                   	nop
  800a35:	c9                   	leave  
  800a36:	c3                   	ret    

00800a37 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3d:	8b 40 08             	mov    0x8(%eax),%eax
  800a40:	8d 50 01             	lea    0x1(%eax),%edx
  800a43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a46:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4c:	8b 10                	mov    (%eax),%edx
  800a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a51:	8b 40 04             	mov    0x4(%eax),%eax
  800a54:	39 c2                	cmp    %eax,%edx
  800a56:	73 12                	jae    800a6a <sprintputch+0x33>
		*b->buf++ = ch;
  800a58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5b:	8b 00                	mov    (%eax),%eax
  800a5d:	8d 48 01             	lea    0x1(%eax),%ecx
  800a60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a63:	89 0a                	mov    %ecx,(%edx)
  800a65:	8b 55 08             	mov    0x8(%ebp),%edx
  800a68:	88 10                	mov    %dl,(%eax)
}
  800a6a:	90                   	nop
  800a6b:	5d                   	pop    %ebp
  800a6c:	c3                   	ret    

00800a6d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a6d:	55                   	push   %ebp
  800a6e:	89 e5                	mov    %esp,%ebp
  800a70:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a73:	8b 45 08             	mov    0x8(%ebp),%eax
  800a76:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	01 d0                	add    %edx,%eax
  800a84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a8e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a92:	74 06                	je     800a9a <vsnprintf+0x2d>
  800a94:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a98:	7f 07                	jg     800aa1 <vsnprintf+0x34>
		return -E_INVAL;
  800a9a:	b8 03 00 00 00       	mov    $0x3,%eax
  800a9f:	eb 20                	jmp    800ac1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800aa1:	ff 75 14             	pushl  0x14(%ebp)
  800aa4:	ff 75 10             	pushl  0x10(%ebp)
  800aa7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aaa:	50                   	push   %eax
  800aab:	68 37 0a 80 00       	push   $0x800a37
  800ab0:	e8 80 fb ff ff       	call   800635 <vprintfmt>
  800ab5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ab8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800abb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ac1:	c9                   	leave  
  800ac2:	c3                   	ret    

00800ac3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ac3:	55                   	push   %ebp
  800ac4:	89 e5                	mov    %esp,%ebp
  800ac6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ac9:	8d 45 10             	lea    0x10(%ebp),%eax
  800acc:	83 c0 04             	add    $0x4,%eax
  800acf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ad2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad8:	50                   	push   %eax
  800ad9:	ff 75 0c             	pushl  0xc(%ebp)
  800adc:	ff 75 08             	pushl  0x8(%ebp)
  800adf:	e8 89 ff ff ff       	call   800a6d <vsnprintf>
  800ae4:	83 c4 10             	add    $0x10,%esp
  800ae7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800aea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aed:	c9                   	leave  
  800aee:	c3                   	ret    

00800aef <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800af5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800afc:	eb 06                	jmp    800b04 <strlen+0x15>
		n++;
  800afe:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b01:	ff 45 08             	incl   0x8(%ebp)
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	8a 00                	mov    (%eax),%al
  800b09:	84 c0                	test   %al,%al
  800b0b:	75 f1                	jne    800afe <strlen+0xf>
		n++;
	return n;
  800b0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b10:	c9                   	leave  
  800b11:	c3                   	ret    

00800b12 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b1f:	eb 09                	jmp    800b2a <strnlen+0x18>
		n++;
  800b21:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b24:	ff 45 08             	incl   0x8(%ebp)
  800b27:	ff 4d 0c             	decl   0xc(%ebp)
  800b2a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b2e:	74 09                	je     800b39 <strnlen+0x27>
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	8a 00                	mov    (%eax),%al
  800b35:	84 c0                	test   %al,%al
  800b37:	75 e8                	jne    800b21 <strnlen+0xf>
		n++;
	return n;
  800b39:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b3c:	c9                   	leave  
  800b3d:	c3                   	ret    

00800b3e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b4a:	90                   	nop
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	8d 50 01             	lea    0x1(%eax),%edx
  800b51:	89 55 08             	mov    %edx,0x8(%ebp)
  800b54:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b57:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b5a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b5d:	8a 12                	mov    (%edx),%dl
  800b5f:	88 10                	mov    %dl,(%eax)
  800b61:	8a 00                	mov    (%eax),%al
  800b63:	84 c0                	test   %al,%al
  800b65:	75 e4                	jne    800b4b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b67:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b6a:	c9                   	leave  
  800b6b:	c3                   	ret    

00800b6c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b7f:	eb 1f                	jmp    800ba0 <strncpy+0x34>
		*dst++ = *src;
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	8d 50 01             	lea    0x1(%eax),%edx
  800b87:	89 55 08             	mov    %edx,0x8(%ebp)
  800b8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b8d:	8a 12                	mov    (%edx),%dl
  800b8f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b94:	8a 00                	mov    (%eax),%al
  800b96:	84 c0                	test   %al,%al
  800b98:	74 03                	je     800b9d <strncpy+0x31>
			src++;
  800b9a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b9d:	ff 45 fc             	incl   -0x4(%ebp)
  800ba0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ba3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ba6:	72 d9                	jb     800b81 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ba8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bab:	c9                   	leave  
  800bac:	c3                   	ret    

00800bad <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bb9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bbd:	74 30                	je     800bef <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bbf:	eb 16                	jmp    800bd7 <strlcpy+0x2a>
			*dst++ = *src++;
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	8d 50 01             	lea    0x1(%eax),%edx
  800bc7:	89 55 08             	mov    %edx,0x8(%ebp)
  800bca:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bcd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bd0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bd3:	8a 12                	mov    (%edx),%dl
  800bd5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bd7:	ff 4d 10             	decl   0x10(%ebp)
  800bda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bde:	74 09                	je     800be9 <strlcpy+0x3c>
  800be0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be3:	8a 00                	mov    (%eax),%al
  800be5:	84 c0                	test   %al,%al
  800be7:	75 d8                	jne    800bc1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bef:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf5:	29 c2                	sub    %eax,%edx
  800bf7:	89 d0                	mov    %edx,%eax
}
  800bf9:	c9                   	leave  
  800bfa:	c3                   	ret    

00800bfb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bfe:	eb 06                	jmp    800c06 <strcmp+0xb>
		p++, q++;
  800c00:	ff 45 08             	incl   0x8(%ebp)
  800c03:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	8a 00                	mov    (%eax),%al
  800c0b:	84 c0                	test   %al,%al
  800c0d:	74 0e                	je     800c1d <strcmp+0x22>
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	8a 10                	mov    (%eax),%dl
  800c14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c17:	8a 00                	mov    (%eax),%al
  800c19:	38 c2                	cmp    %al,%dl
  800c1b:	74 e3                	je     800c00 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	8a 00                	mov    (%eax),%al
  800c22:	0f b6 d0             	movzbl %al,%edx
  800c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c28:	8a 00                	mov    (%eax),%al
  800c2a:	0f b6 c0             	movzbl %al,%eax
  800c2d:	29 c2                	sub    %eax,%edx
  800c2f:	89 d0                	mov    %edx,%eax
}
  800c31:	5d                   	pop    %ebp
  800c32:	c3                   	ret    

00800c33 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c36:	eb 09                	jmp    800c41 <strncmp+0xe>
		n--, p++, q++;
  800c38:	ff 4d 10             	decl   0x10(%ebp)
  800c3b:	ff 45 08             	incl   0x8(%ebp)
  800c3e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c45:	74 17                	je     800c5e <strncmp+0x2b>
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	8a 00                	mov    (%eax),%al
  800c4c:	84 c0                	test   %al,%al
  800c4e:	74 0e                	je     800c5e <strncmp+0x2b>
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	8a 10                	mov    (%eax),%dl
  800c55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c58:	8a 00                	mov    (%eax),%al
  800c5a:	38 c2                	cmp    %al,%dl
  800c5c:	74 da                	je     800c38 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c62:	75 07                	jne    800c6b <strncmp+0x38>
		return 0;
  800c64:	b8 00 00 00 00       	mov    $0x0,%eax
  800c69:	eb 14                	jmp    800c7f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	8a 00                	mov    (%eax),%al
  800c70:	0f b6 d0             	movzbl %al,%edx
  800c73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c76:	8a 00                	mov    (%eax),%al
  800c78:	0f b6 c0             	movzbl %al,%eax
  800c7b:	29 c2                	sub    %eax,%edx
  800c7d:	89 d0                	mov    %edx,%eax
}
  800c7f:	5d                   	pop    %ebp
  800c80:	c3                   	ret    

00800c81 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	83 ec 04             	sub    $0x4,%esp
  800c87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c8d:	eb 12                	jmp    800ca1 <strchr+0x20>
		if (*s == c)
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	8a 00                	mov    (%eax),%al
  800c94:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c97:	75 05                	jne    800c9e <strchr+0x1d>
			return (char *) s;
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	eb 11                	jmp    800caf <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c9e:	ff 45 08             	incl   0x8(%ebp)
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	8a 00                	mov    (%eax),%al
  800ca6:	84 c0                	test   %al,%al
  800ca8:	75 e5                	jne    800c8f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800caa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800caf:	c9                   	leave  
  800cb0:	c3                   	ret    

00800cb1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	83 ec 04             	sub    $0x4,%esp
  800cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cba:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cbd:	eb 0d                	jmp    800ccc <strfind+0x1b>
		if (*s == c)
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	8a 00                	mov    (%eax),%al
  800cc4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cc7:	74 0e                	je     800cd7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cc9:	ff 45 08             	incl   0x8(%ebp)
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	84 c0                	test   %al,%al
  800cd3:	75 ea                	jne    800cbf <strfind+0xe>
  800cd5:	eb 01                	jmp    800cd8 <strfind+0x27>
		if (*s == c)
			break;
  800cd7:	90                   	nop
	return (char *) s;
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cdb:	c9                   	leave  
  800cdc:	c3                   	ret    

00800cdd <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ce9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cef:	eb 0e                	jmp    800cff <memset+0x22>
		*p++ = c;
  800cf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf4:	8d 50 01             	lea    0x1(%eax),%edx
  800cf7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800cfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfd:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800cff:	ff 4d f8             	decl   -0x8(%ebp)
  800d02:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d06:	79 e9                	jns    800cf1 <memset+0x14>
		*p++ = c;

	return v;
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d0b:	c9                   	leave  
  800d0c:	c3                   	ret    

00800d0d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d1f:	eb 16                	jmp    800d37 <memcpy+0x2a>
		*d++ = *s++;
  800d21:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d24:	8d 50 01             	lea    0x1(%eax),%edx
  800d27:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d2a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d2d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d30:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d33:	8a 12                	mov    (%edx),%dl
  800d35:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d37:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d3d:	89 55 10             	mov    %edx,0x10(%ebp)
  800d40:	85 c0                	test   %eax,%eax
  800d42:	75 dd                	jne    800d21 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d47:	c9                   	leave  
  800d48:	c3                   	ret    

00800d49 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d5e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d61:	73 50                	jae    800db3 <memmove+0x6a>
  800d63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d66:	8b 45 10             	mov    0x10(%ebp),%eax
  800d69:	01 d0                	add    %edx,%eax
  800d6b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d6e:	76 43                	jbe    800db3 <memmove+0x6a>
		s += n;
  800d70:	8b 45 10             	mov    0x10(%ebp),%eax
  800d73:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d76:	8b 45 10             	mov    0x10(%ebp),%eax
  800d79:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d7c:	eb 10                	jmp    800d8e <memmove+0x45>
			*--d = *--s;
  800d7e:	ff 4d f8             	decl   -0x8(%ebp)
  800d81:	ff 4d fc             	decl   -0x4(%ebp)
  800d84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d87:	8a 10                	mov    (%eax),%dl
  800d89:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d91:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d94:	89 55 10             	mov    %edx,0x10(%ebp)
  800d97:	85 c0                	test   %eax,%eax
  800d99:	75 e3                	jne    800d7e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d9b:	eb 23                	jmp    800dc0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da0:	8d 50 01             	lea    0x1(%eax),%edx
  800da3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800da6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800da9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dac:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800daf:	8a 12                	mov    (%edx),%dl
  800db1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800db3:	8b 45 10             	mov    0x10(%ebp),%eax
  800db6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db9:	89 55 10             	mov    %edx,0x10(%ebp)
  800dbc:	85 c0                	test   %eax,%eax
  800dbe:	75 dd                	jne    800d9d <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dd7:	eb 2a                	jmp    800e03 <memcmp+0x3e>
		if (*s1 != *s2)
  800dd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ddc:	8a 10                	mov    (%eax),%dl
  800dde:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de1:	8a 00                	mov    (%eax),%al
  800de3:	38 c2                	cmp    %al,%dl
  800de5:	74 16                	je     800dfd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800de7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	0f b6 d0             	movzbl %al,%edx
  800def:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	0f b6 c0             	movzbl %al,%eax
  800df7:	29 c2                	sub    %eax,%edx
  800df9:	89 d0                	mov    %edx,%eax
  800dfb:	eb 18                	jmp    800e15 <memcmp+0x50>
		s1++, s2++;
  800dfd:	ff 45 fc             	incl   -0x4(%ebp)
  800e00:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e03:	8b 45 10             	mov    0x10(%ebp),%eax
  800e06:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e09:	89 55 10             	mov    %edx,0x10(%ebp)
  800e0c:	85 c0                	test   %eax,%eax
  800e0e:	75 c9                	jne    800dd9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e15:	c9                   	leave  
  800e16:	c3                   	ret    

00800e17 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e20:	8b 45 10             	mov    0x10(%ebp),%eax
  800e23:	01 d0                	add    %edx,%eax
  800e25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e28:	eb 15                	jmp    800e3f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	0f b6 d0             	movzbl %al,%edx
  800e32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e35:	0f b6 c0             	movzbl %al,%eax
  800e38:	39 c2                	cmp    %eax,%edx
  800e3a:	74 0d                	je     800e49 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e3c:	ff 45 08             	incl   0x8(%ebp)
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e45:	72 e3                	jb     800e2a <memfind+0x13>
  800e47:	eb 01                	jmp    800e4a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e49:	90                   	nop
	return (void *) s;
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4d:	c9                   	leave  
  800e4e:	c3                   	ret    

00800e4f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e5c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e63:	eb 03                	jmp    800e68 <strtol+0x19>
		s++;
  800e65:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8a 00                	mov    (%eax),%al
  800e6d:	3c 20                	cmp    $0x20,%al
  800e6f:	74 f4                	je     800e65 <strtol+0x16>
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	3c 09                	cmp    $0x9,%al
  800e78:	74 eb                	je     800e65 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	8a 00                	mov    (%eax),%al
  800e7f:	3c 2b                	cmp    $0x2b,%al
  800e81:	75 05                	jne    800e88 <strtol+0x39>
		s++;
  800e83:	ff 45 08             	incl   0x8(%ebp)
  800e86:	eb 13                	jmp    800e9b <strtol+0x4c>
	else if (*s == '-')
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	8a 00                	mov    (%eax),%al
  800e8d:	3c 2d                	cmp    $0x2d,%al
  800e8f:	75 0a                	jne    800e9b <strtol+0x4c>
		s++, neg = 1;
  800e91:	ff 45 08             	incl   0x8(%ebp)
  800e94:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e9b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9f:	74 06                	je     800ea7 <strtol+0x58>
  800ea1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ea5:	75 20                	jne    800ec7 <strtol+0x78>
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	3c 30                	cmp    $0x30,%al
  800eae:	75 17                	jne    800ec7 <strtol+0x78>
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	40                   	inc    %eax
  800eb4:	8a 00                	mov    (%eax),%al
  800eb6:	3c 78                	cmp    $0x78,%al
  800eb8:	75 0d                	jne    800ec7 <strtol+0x78>
		s += 2, base = 16;
  800eba:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ebe:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ec5:	eb 28                	jmp    800eef <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ec7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecb:	75 15                	jne    800ee2 <strtol+0x93>
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	8a 00                	mov    (%eax),%al
  800ed2:	3c 30                	cmp    $0x30,%al
  800ed4:	75 0c                	jne    800ee2 <strtol+0x93>
		s++, base = 8;
  800ed6:	ff 45 08             	incl   0x8(%ebp)
  800ed9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ee0:	eb 0d                	jmp    800eef <strtol+0xa0>
	else if (base == 0)
  800ee2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee6:	75 07                	jne    800eef <strtol+0xa0>
		base = 10;
  800ee8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	3c 2f                	cmp    $0x2f,%al
  800ef6:	7e 19                	jle    800f11 <strtol+0xc2>
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	8a 00                	mov    (%eax),%al
  800efd:	3c 39                	cmp    $0x39,%al
  800eff:	7f 10                	jg     800f11 <strtol+0xc2>
			dig = *s - '0';
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	8a 00                	mov    (%eax),%al
  800f06:	0f be c0             	movsbl %al,%eax
  800f09:	83 e8 30             	sub    $0x30,%eax
  800f0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f0f:	eb 42                	jmp    800f53 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	3c 60                	cmp    $0x60,%al
  800f18:	7e 19                	jle    800f33 <strtol+0xe4>
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	8a 00                	mov    (%eax),%al
  800f1f:	3c 7a                	cmp    $0x7a,%al
  800f21:	7f 10                	jg     800f33 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	0f be c0             	movsbl %al,%eax
  800f2b:	83 e8 57             	sub    $0x57,%eax
  800f2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f31:	eb 20                	jmp    800f53 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	8a 00                	mov    (%eax),%al
  800f38:	3c 40                	cmp    $0x40,%al
  800f3a:	7e 39                	jle    800f75 <strtol+0x126>
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	8a 00                	mov    (%eax),%al
  800f41:	3c 5a                	cmp    $0x5a,%al
  800f43:	7f 30                	jg     800f75 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	8a 00                	mov    (%eax),%al
  800f4a:	0f be c0             	movsbl %al,%eax
  800f4d:	83 e8 37             	sub    $0x37,%eax
  800f50:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f56:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f59:	7d 19                	jge    800f74 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f5b:	ff 45 08             	incl   0x8(%ebp)
  800f5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f61:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f65:	89 c2                	mov    %eax,%edx
  800f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f6a:	01 d0                	add    %edx,%eax
  800f6c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f6f:	e9 7b ff ff ff       	jmp    800eef <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f74:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f79:	74 08                	je     800f83 <strtol+0x134>
		*endptr = (char *) s;
  800f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f81:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f83:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f87:	74 07                	je     800f90 <strtol+0x141>
  800f89:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f8c:	f7 d8                	neg    %eax
  800f8e:	eb 03                	jmp    800f93 <strtol+0x144>
  800f90:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f93:	c9                   	leave  
  800f94:	c3                   	ret    

00800f95 <ltostr>:

void
ltostr(long value, char *str)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fa2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fa9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fad:	79 13                	jns    800fc2 <ltostr+0x2d>
	{
		neg = 1;
  800faf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fbc:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fbf:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fca:	99                   	cltd   
  800fcb:	f7 f9                	idiv   %ecx
  800fcd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd3:	8d 50 01             	lea    0x1(%eax),%edx
  800fd6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fd9:	89 c2                	mov    %eax,%edx
  800fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fde:	01 d0                	add    %edx,%eax
  800fe0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fe3:	83 c2 30             	add    $0x30,%edx
  800fe6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fe8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800feb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ff0:	f7 e9                	imul   %ecx
  800ff2:	c1 fa 02             	sar    $0x2,%edx
  800ff5:	89 c8                	mov    %ecx,%eax
  800ff7:	c1 f8 1f             	sar    $0x1f,%eax
  800ffa:	29 c2                	sub    %eax,%edx
  800ffc:	89 d0                	mov    %edx,%eax
  800ffe:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801001:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801005:	75 bb                	jne    800fc2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801007:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80100e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801011:	48                   	dec    %eax
  801012:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801015:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801019:	74 3d                	je     801058 <ltostr+0xc3>
		start = 1 ;
  80101b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801022:	eb 34                	jmp    801058 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801024:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801027:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102a:	01 d0                	add    %edx,%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801031:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801034:	8b 45 0c             	mov    0xc(%ebp),%eax
  801037:	01 c2                	add    %eax,%edx
  801039:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80103c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103f:	01 c8                	add    %ecx,%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801045:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	01 c2                	add    %eax,%edx
  80104d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801050:	88 02                	mov    %al,(%edx)
		start++ ;
  801052:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801055:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80105e:	7c c4                	jl     801024 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801060:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801063:	8b 45 0c             	mov    0xc(%ebp),%eax
  801066:	01 d0                	add    %edx,%eax
  801068:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80106b:	90                   	nop
  80106c:	c9                   	leave  
  80106d:	c3                   	ret    

0080106e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
  801071:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801074:	ff 75 08             	pushl  0x8(%ebp)
  801077:	e8 73 fa ff ff       	call   800aef <strlen>
  80107c:	83 c4 04             	add    $0x4,%esp
  80107f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801082:	ff 75 0c             	pushl  0xc(%ebp)
  801085:	e8 65 fa ff ff       	call   800aef <strlen>
  80108a:	83 c4 04             	add    $0x4,%esp
  80108d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801090:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801097:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80109e:	eb 17                	jmp    8010b7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a6:	01 c2                	add    %eax,%edx
  8010a8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	01 c8                	add    %ecx,%eax
  8010b0:	8a 00                	mov    (%eax),%al
  8010b2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010b4:	ff 45 fc             	incl   -0x4(%ebp)
  8010b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ba:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010bd:	7c e1                	jl     8010a0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010cd:	eb 1f                	jmp    8010ee <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d2:	8d 50 01             	lea    0x1(%eax),%edx
  8010d5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010d8:	89 c2                	mov    %eax,%edx
  8010da:	8b 45 10             	mov    0x10(%ebp),%eax
  8010dd:	01 c2                	add    %eax,%edx
  8010df:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e5:	01 c8                	add    %ecx,%eax
  8010e7:	8a 00                	mov    (%eax),%al
  8010e9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010eb:	ff 45 f8             	incl   -0x8(%ebp)
  8010ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010f4:	7c d9                	jl     8010cf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fc:	01 d0                	add    %edx,%eax
  8010fe:	c6 00 00             	movb   $0x0,(%eax)
}
  801101:	90                   	nop
  801102:	c9                   	leave  
  801103:	c3                   	ret    

00801104 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801107:	8b 45 14             	mov    0x14(%ebp),%eax
  80110a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801110:	8b 45 14             	mov    0x14(%ebp),%eax
  801113:	8b 00                	mov    (%eax),%eax
  801115:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80111c:	8b 45 10             	mov    0x10(%ebp),%eax
  80111f:	01 d0                	add    %edx,%eax
  801121:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801127:	eb 0c                	jmp    801135 <strsplit+0x31>
			*string++ = 0;
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	8d 50 01             	lea    0x1(%eax),%edx
  80112f:	89 55 08             	mov    %edx,0x8(%ebp)
  801132:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8a 00                	mov    (%eax),%al
  80113a:	84 c0                	test   %al,%al
  80113c:	74 18                	je     801156 <strsplit+0x52>
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	8a 00                	mov    (%eax),%al
  801143:	0f be c0             	movsbl %al,%eax
  801146:	50                   	push   %eax
  801147:	ff 75 0c             	pushl  0xc(%ebp)
  80114a:	e8 32 fb ff ff       	call   800c81 <strchr>
  80114f:	83 c4 08             	add    $0x8,%esp
  801152:	85 c0                	test   %eax,%eax
  801154:	75 d3                	jne    801129 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	84 c0                	test   %al,%al
  80115d:	74 5a                	je     8011b9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80115f:	8b 45 14             	mov    0x14(%ebp),%eax
  801162:	8b 00                	mov    (%eax),%eax
  801164:	83 f8 0f             	cmp    $0xf,%eax
  801167:	75 07                	jne    801170 <strsplit+0x6c>
		{
			return 0;
  801169:	b8 00 00 00 00       	mov    $0x0,%eax
  80116e:	eb 66                	jmp    8011d6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801170:	8b 45 14             	mov    0x14(%ebp),%eax
  801173:	8b 00                	mov    (%eax),%eax
  801175:	8d 48 01             	lea    0x1(%eax),%ecx
  801178:	8b 55 14             	mov    0x14(%ebp),%edx
  80117b:	89 0a                	mov    %ecx,(%edx)
  80117d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801184:	8b 45 10             	mov    0x10(%ebp),%eax
  801187:	01 c2                	add    %eax,%edx
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80118e:	eb 03                	jmp    801193 <strsplit+0x8f>
			string++;
  801190:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	8a 00                	mov    (%eax),%al
  801198:	84 c0                	test   %al,%al
  80119a:	74 8b                	je     801127 <strsplit+0x23>
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	8a 00                	mov    (%eax),%al
  8011a1:	0f be c0             	movsbl %al,%eax
  8011a4:	50                   	push   %eax
  8011a5:	ff 75 0c             	pushl  0xc(%ebp)
  8011a8:	e8 d4 fa ff ff       	call   800c81 <strchr>
  8011ad:	83 c4 08             	add    $0x8,%esp
  8011b0:	85 c0                	test   %eax,%eax
  8011b2:	74 dc                	je     801190 <strsplit+0x8c>
			string++;
	}
  8011b4:	e9 6e ff ff ff       	jmp    801127 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011b9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8011bd:	8b 00                	mov    (%eax),%eax
  8011bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c9:	01 d0                	add    %edx,%eax
  8011cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011d1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011d6:	c9                   	leave  
  8011d7:	c3                   	ret    

008011d8 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8011de:	83 ec 04             	sub    $0x4,%esp
  8011e1:	68 e8 20 80 00       	push   $0x8020e8
  8011e6:	68 3f 01 00 00       	push   $0x13f
  8011eb:	68 0a 21 80 00       	push   $0x80210a
  8011f0:	e8 a9 ef ff ff       	call   80019e <_panic>

008011f5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	57                   	push   %edi
  8011f9:	56                   	push   %esi
  8011fa:	53                   	push   %ebx
  8011fb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	8b 55 0c             	mov    0xc(%ebp),%edx
  801204:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801207:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80120a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80120d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801210:	cd 30                	int    $0x30
  801212:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801215:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801218:	83 c4 10             	add    $0x10,%esp
  80121b:	5b                   	pop    %ebx
  80121c:	5e                   	pop    %esi
  80121d:	5f                   	pop    %edi
  80121e:	5d                   	pop    %ebp
  80121f:	c3                   	ret    

00801220 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	83 ec 04             	sub    $0x4,%esp
  801226:	8b 45 10             	mov    0x10(%ebp),%eax
  801229:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80122c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	6a 00                	push   $0x0
  801235:	6a 00                	push   $0x0
  801237:	52                   	push   %edx
  801238:	ff 75 0c             	pushl  0xc(%ebp)
  80123b:	50                   	push   %eax
  80123c:	6a 00                	push   $0x0
  80123e:	e8 b2 ff ff ff       	call   8011f5 <syscall>
  801243:	83 c4 18             	add    $0x18,%esp
}
  801246:	90                   	nop
  801247:	c9                   	leave  
  801248:	c3                   	ret    

00801249 <sys_cgetc>:

int
sys_cgetc(void)
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80124c:	6a 00                	push   $0x0
  80124e:	6a 00                	push   $0x0
  801250:	6a 00                	push   $0x0
  801252:	6a 00                	push   $0x0
  801254:	6a 00                	push   $0x0
  801256:	6a 02                	push   $0x2
  801258:	e8 98 ff ff ff       	call   8011f5 <syscall>
  80125d:	83 c4 18             	add    $0x18,%esp
}
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801265:	6a 00                	push   $0x0
  801267:	6a 00                	push   $0x0
  801269:	6a 00                	push   $0x0
  80126b:	6a 00                	push   $0x0
  80126d:	6a 00                	push   $0x0
  80126f:	6a 03                	push   $0x3
  801271:	e8 7f ff ff ff       	call   8011f5 <syscall>
  801276:	83 c4 18             	add    $0x18,%esp
}
  801279:	90                   	nop
  80127a:	c9                   	leave  
  80127b:	c3                   	ret    

0080127c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80127c:	55                   	push   %ebp
  80127d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80127f:	6a 00                	push   $0x0
  801281:	6a 00                	push   $0x0
  801283:	6a 00                	push   $0x0
  801285:	6a 00                	push   $0x0
  801287:	6a 00                	push   $0x0
  801289:	6a 04                	push   $0x4
  80128b:	e8 65 ff ff ff       	call   8011f5 <syscall>
  801290:	83 c4 18             	add    $0x18,%esp
}
  801293:	90                   	nop
  801294:	c9                   	leave  
  801295:	c3                   	ret    

00801296 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801299:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129c:	8b 45 08             	mov    0x8(%ebp),%eax
  80129f:	6a 00                	push   $0x0
  8012a1:	6a 00                	push   $0x0
  8012a3:	6a 00                	push   $0x0
  8012a5:	52                   	push   %edx
  8012a6:	50                   	push   %eax
  8012a7:	6a 08                	push   $0x8
  8012a9:	e8 47 ff ff ff       	call   8011f5 <syscall>
  8012ae:	83 c4 18             	add    $0x18,%esp
}
  8012b1:	c9                   	leave  
  8012b2:	c3                   	ret    

008012b3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
  8012b6:	56                   	push   %esi
  8012b7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012b8:	8b 75 18             	mov    0x18(%ebp),%esi
  8012bb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012be:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	56                   	push   %esi
  8012c8:	53                   	push   %ebx
  8012c9:	51                   	push   %ecx
  8012ca:	52                   	push   %edx
  8012cb:	50                   	push   %eax
  8012cc:	6a 09                	push   $0x9
  8012ce:	e8 22 ff ff ff       	call   8011f5 <syscall>
  8012d3:	83 c4 18             	add    $0x18,%esp
}
  8012d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012d9:	5b                   	pop    %ebx
  8012da:	5e                   	pop    %esi
  8012db:	5d                   	pop    %ebp
  8012dc:	c3                   	ret    

008012dd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012dd:	55                   	push   %ebp
  8012de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	6a 00                	push   $0x0
  8012e8:	6a 00                	push   $0x0
  8012ea:	6a 00                	push   $0x0
  8012ec:	52                   	push   %edx
  8012ed:	50                   	push   %eax
  8012ee:	6a 0a                	push   $0xa
  8012f0:	e8 00 ff ff ff       	call   8011f5 <syscall>
  8012f5:	83 c4 18             	add    $0x18,%esp
}
  8012f8:	c9                   	leave  
  8012f9:	c3                   	ret    

008012fa <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012fd:	6a 00                	push   $0x0
  8012ff:	6a 00                	push   $0x0
  801301:	6a 00                	push   $0x0
  801303:	ff 75 0c             	pushl  0xc(%ebp)
  801306:	ff 75 08             	pushl  0x8(%ebp)
  801309:	6a 0b                	push   $0xb
  80130b:	e8 e5 fe ff ff       	call   8011f5 <syscall>
  801310:	83 c4 18             	add    $0x18,%esp
}
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801318:	6a 00                	push   $0x0
  80131a:	6a 00                	push   $0x0
  80131c:	6a 00                	push   $0x0
  80131e:	6a 00                	push   $0x0
  801320:	6a 00                	push   $0x0
  801322:	6a 0c                	push   $0xc
  801324:	e8 cc fe ff ff       	call   8011f5 <syscall>
  801329:	83 c4 18             	add    $0x18,%esp
}
  80132c:	c9                   	leave  
  80132d:	c3                   	ret    

0080132e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80132e:	55                   	push   %ebp
  80132f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801331:	6a 00                	push   $0x0
  801333:	6a 00                	push   $0x0
  801335:	6a 00                	push   $0x0
  801337:	6a 00                	push   $0x0
  801339:	6a 00                	push   $0x0
  80133b:	6a 0d                	push   $0xd
  80133d:	e8 b3 fe ff ff       	call   8011f5 <syscall>
  801342:	83 c4 18             	add    $0x18,%esp
}
  801345:	c9                   	leave  
  801346:	c3                   	ret    

00801347 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801347:	55                   	push   %ebp
  801348:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80134a:	6a 00                	push   $0x0
  80134c:	6a 00                	push   $0x0
  80134e:	6a 00                	push   $0x0
  801350:	6a 00                	push   $0x0
  801352:	6a 00                	push   $0x0
  801354:	6a 0e                	push   $0xe
  801356:	e8 9a fe ff ff       	call   8011f5 <syscall>
  80135b:	83 c4 18             	add    $0x18,%esp
}
  80135e:	c9                   	leave  
  80135f:	c3                   	ret    

00801360 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801363:	6a 00                	push   $0x0
  801365:	6a 00                	push   $0x0
  801367:	6a 00                	push   $0x0
  801369:	6a 00                	push   $0x0
  80136b:	6a 00                	push   $0x0
  80136d:	6a 0f                	push   $0xf
  80136f:	e8 81 fe ff ff       	call   8011f5 <syscall>
  801374:	83 c4 18             	add    $0x18,%esp
}
  801377:	c9                   	leave  
  801378:	c3                   	ret    

00801379 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80137c:	6a 00                	push   $0x0
  80137e:	6a 00                	push   $0x0
  801380:	6a 00                	push   $0x0
  801382:	6a 00                	push   $0x0
  801384:	ff 75 08             	pushl  0x8(%ebp)
  801387:	6a 10                	push   $0x10
  801389:	e8 67 fe ff ff       	call   8011f5 <syscall>
  80138e:	83 c4 18             	add    $0x18,%esp
}
  801391:	c9                   	leave  
  801392:	c3                   	ret    

00801393 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801396:	6a 00                	push   $0x0
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 11                	push   $0x11
  8013a2:	e8 4e fe ff ff       	call   8011f5 <syscall>
  8013a7:	83 c4 18             	add    $0x18,%esp
}
  8013aa:	90                   	nop
  8013ab:	c9                   	leave  
  8013ac:	c3                   	ret    

008013ad <sys_cputc>:

void
sys_cputc(const char c)
{
  8013ad:	55                   	push   %ebp
  8013ae:	89 e5                	mov    %esp,%ebp
  8013b0:	83 ec 04             	sub    $0x4,%esp
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013b9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	50                   	push   %eax
  8013c6:	6a 01                	push   $0x1
  8013c8:	e8 28 fe ff ff       	call   8011f5 <syscall>
  8013cd:	83 c4 18             	add    $0x18,%esp
}
  8013d0:	90                   	nop
  8013d1:	c9                   	leave  
  8013d2:	c3                   	ret    

008013d3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 14                	push   $0x14
  8013e2:	e8 0e fe ff ff       	call   8011f5 <syscall>
  8013e7:	83 c4 18             	add    $0x18,%esp
}
  8013ea:	90                   	nop
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    

008013ed <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	83 ec 04             	sub    $0x4,%esp
  8013f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013f9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013fc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	6a 00                	push   $0x0
  801405:	51                   	push   %ecx
  801406:	52                   	push   %edx
  801407:	ff 75 0c             	pushl  0xc(%ebp)
  80140a:	50                   	push   %eax
  80140b:	6a 15                	push   $0x15
  80140d:	e8 e3 fd ff ff       	call   8011f5 <syscall>
  801412:	83 c4 18             	add    $0x18,%esp
}
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80141a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	52                   	push   %edx
  801427:	50                   	push   %eax
  801428:	6a 16                	push   $0x16
  80142a:	e8 c6 fd ff ff       	call   8011f5 <syscall>
  80142f:	83 c4 18             	add    $0x18,%esp
}
  801432:	c9                   	leave  
  801433:	c3                   	ret    

00801434 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801437:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80143a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	51                   	push   %ecx
  801445:	52                   	push   %edx
  801446:	50                   	push   %eax
  801447:	6a 17                	push   $0x17
  801449:	e8 a7 fd ff ff       	call   8011f5 <syscall>
  80144e:	83 c4 18             	add    $0x18,%esp
}
  801451:	c9                   	leave  
  801452:	c3                   	ret    

00801453 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801456:	8b 55 0c             	mov    0xc(%ebp),%edx
  801459:	8b 45 08             	mov    0x8(%ebp),%eax
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	52                   	push   %edx
  801463:	50                   	push   %eax
  801464:	6a 18                	push   $0x18
  801466:	e8 8a fd ff ff       	call   8011f5 <syscall>
  80146b:	83 c4 18             	add    $0x18,%esp
}
  80146e:	c9                   	leave  
  80146f:	c3                   	ret    

00801470 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	6a 00                	push   $0x0
  801478:	ff 75 14             	pushl  0x14(%ebp)
  80147b:	ff 75 10             	pushl  0x10(%ebp)
  80147e:	ff 75 0c             	pushl  0xc(%ebp)
  801481:	50                   	push   %eax
  801482:	6a 19                	push   $0x19
  801484:	e8 6c fd ff ff       	call   8011f5 <syscall>
  801489:	83 c4 18             	add    $0x18,%esp
}
  80148c:	c9                   	leave  
  80148d:	c3                   	ret    

0080148e <sys_run_env>:

void sys_run_env(int32 envId)
{
  80148e:	55                   	push   %ebp
  80148f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	6a 00                	push   $0x0
  801496:	6a 00                	push   $0x0
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	50                   	push   %eax
  80149d:	6a 1a                	push   $0x1a
  80149f:	e8 51 fd ff ff       	call   8011f5 <syscall>
  8014a4:	83 c4 18             	add    $0x18,%esp
}
  8014a7:	90                   	nop
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	50                   	push   %eax
  8014b9:	6a 1b                	push   $0x1b
  8014bb:	e8 35 fd ff ff       	call   8011f5 <syscall>
  8014c0:	83 c4 18             	add    $0x18,%esp
}
  8014c3:	c9                   	leave  
  8014c4:	c3                   	ret    

008014c5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 05                	push   $0x5
  8014d4:	e8 1c fd ff ff       	call   8011f5 <syscall>
  8014d9:	83 c4 18             	add    $0x18,%esp
}
  8014dc:	c9                   	leave  
  8014dd:	c3                   	ret    

008014de <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014e1:	6a 00                	push   $0x0
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 06                	push   $0x6
  8014ed:	e8 03 fd ff ff       	call   8011f5 <syscall>
  8014f2:	83 c4 18             	add    $0x18,%esp
}
  8014f5:	c9                   	leave  
  8014f6:	c3                   	ret    

008014f7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 07                	push   $0x7
  801506:	e8 ea fc ff ff       	call   8011f5 <syscall>
  80150b:	83 c4 18             	add    $0x18,%esp
}
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    

00801510 <sys_exit_env>:


void sys_exit_env(void)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	6a 1c                	push   $0x1c
  80151f:	e8 d1 fc ff ff       	call   8011f5 <syscall>
  801524:	83 c4 18             	add    $0x18,%esp
}
  801527:	90                   	nop
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801530:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801533:	8d 50 04             	lea    0x4(%eax),%edx
  801536:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	52                   	push   %edx
  801540:	50                   	push   %eax
  801541:	6a 1d                	push   $0x1d
  801543:	e8 ad fc ff ff       	call   8011f5 <syscall>
  801548:	83 c4 18             	add    $0x18,%esp
	return result;
  80154b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80154e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801551:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801554:	89 01                	mov    %eax,(%ecx)
  801556:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	c9                   	leave  
  80155d:	c2 04 00             	ret    $0x4

00801560 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801563:	6a 00                	push   $0x0
  801565:	6a 00                	push   $0x0
  801567:	ff 75 10             	pushl  0x10(%ebp)
  80156a:	ff 75 0c             	pushl  0xc(%ebp)
  80156d:	ff 75 08             	pushl  0x8(%ebp)
  801570:	6a 13                	push   $0x13
  801572:	e8 7e fc ff ff       	call   8011f5 <syscall>
  801577:	83 c4 18             	add    $0x18,%esp
	return ;
  80157a:	90                   	nop
}
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <sys_rcr2>:
uint32 sys_rcr2()
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 1e                	push   $0x1e
  80158c:	e8 64 fc ff ff       	call   8011f5 <syscall>
  801591:	83 c4 18             	add    $0x18,%esp
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	83 ec 04             	sub    $0x4,%esp
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015a2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	50                   	push   %eax
  8015af:	6a 1f                	push   $0x1f
  8015b1:	e8 3f fc ff ff       	call   8011f5 <syscall>
  8015b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8015b9:	90                   	nop
}
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <rsttst>:
void rsttst()
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 21                	push   $0x21
  8015cb:	e8 25 fc ff ff       	call   8011f5 <syscall>
  8015d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8015d3:	90                   	nop
}
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	83 ec 04             	sub    $0x4,%esp
  8015dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8015df:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015e2:	8b 55 18             	mov    0x18(%ebp),%edx
  8015e5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015e9:	52                   	push   %edx
  8015ea:	50                   	push   %eax
  8015eb:	ff 75 10             	pushl  0x10(%ebp)
  8015ee:	ff 75 0c             	pushl  0xc(%ebp)
  8015f1:	ff 75 08             	pushl  0x8(%ebp)
  8015f4:	6a 20                	push   $0x20
  8015f6:	e8 fa fb ff ff       	call   8011f5 <syscall>
  8015fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8015fe:	90                   	nop
}
  8015ff:	c9                   	leave  
  801600:	c3                   	ret    

00801601 <chktst>:
void chktst(uint32 n)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	ff 75 08             	pushl  0x8(%ebp)
  80160f:	6a 22                	push   $0x22
  801611:	e8 df fb ff ff       	call   8011f5 <syscall>
  801616:	83 c4 18             	add    $0x18,%esp
	return ;
  801619:	90                   	nop
}
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <inctst>:

void inctst()
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 23                	push   $0x23
  80162b:	e8 c5 fb ff ff       	call   8011f5 <syscall>
  801630:	83 c4 18             	add    $0x18,%esp
	return ;
  801633:	90                   	nop
}
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <gettst>:
uint32 gettst()
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 24                	push   $0x24
  801645:	e8 ab fb ff ff       	call   8011f5 <syscall>
  80164a:	83 c4 18             	add    $0x18,%esp
}
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 25                	push   $0x25
  801661:	e8 8f fb ff ff       	call   8011f5 <syscall>
  801666:	83 c4 18             	add    $0x18,%esp
  801669:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80166c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801670:	75 07                	jne    801679 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801672:	b8 01 00 00 00       	mov    $0x1,%eax
  801677:	eb 05                	jmp    80167e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801679:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80167e:	c9                   	leave  
  80167f:	c3                   	ret    

00801680 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 25                	push   $0x25
  801692:	e8 5e fb ff ff       	call   8011f5 <syscall>
  801697:	83 c4 18             	add    $0x18,%esp
  80169a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80169d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016a1:	75 07                	jne    8016aa <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8016a8:	eb 05                	jmp    8016af <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 25                	push   $0x25
  8016c3:	e8 2d fb ff ff       	call   8011f5 <syscall>
  8016c8:	83 c4 18             	add    $0x18,%esp
  8016cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016ce:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016d2:	75 07                	jne    8016db <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8016d9:	eb 05                	jmp    8016e0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e0:	c9                   	leave  
  8016e1:	c3                   	ret    

008016e2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 25                	push   $0x25
  8016f4:	e8 fc fa ff ff       	call   8011f5 <syscall>
  8016f9:	83 c4 18             	add    $0x18,%esp
  8016fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8016ff:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801703:	75 07                	jne    80170c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801705:	b8 01 00 00 00       	mov    $0x1,%eax
  80170a:	eb 05                	jmp    801711 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80170c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	ff 75 08             	pushl  0x8(%ebp)
  801721:	6a 26                	push   $0x26
  801723:	e8 cd fa ff ff       	call   8011f5 <syscall>
  801728:	83 c4 18             	add    $0x18,%esp
	return ;
  80172b:	90                   	nop
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801732:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801735:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801738:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	6a 00                	push   $0x0
  801740:	53                   	push   %ebx
  801741:	51                   	push   %ecx
  801742:	52                   	push   %edx
  801743:	50                   	push   %eax
  801744:	6a 27                	push   $0x27
  801746:	e8 aa fa ff ff       	call   8011f5 <syscall>
  80174b:	83 c4 18             	add    $0x18,%esp
}
  80174e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801756:	8b 55 0c             	mov    0xc(%ebp),%edx
  801759:	8b 45 08             	mov    0x8(%ebp),%eax
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	52                   	push   %edx
  801763:	50                   	push   %eax
  801764:	6a 28                	push   $0x28
  801766:	e8 8a fa ff ff       	call   8011f5 <syscall>
  80176b:	83 c4 18             	add    $0x18,%esp
}
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801773:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801776:	8b 55 0c             	mov    0xc(%ebp),%edx
  801779:	8b 45 08             	mov    0x8(%ebp),%eax
  80177c:	6a 00                	push   $0x0
  80177e:	51                   	push   %ecx
  80177f:	ff 75 10             	pushl  0x10(%ebp)
  801782:	52                   	push   %edx
  801783:	50                   	push   %eax
  801784:	6a 29                	push   $0x29
  801786:	e8 6a fa ff ff       	call   8011f5 <syscall>
  80178b:	83 c4 18             	add    $0x18,%esp
}
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	ff 75 10             	pushl  0x10(%ebp)
  80179a:	ff 75 0c             	pushl  0xc(%ebp)
  80179d:	ff 75 08             	pushl  0x8(%ebp)
  8017a0:	6a 12                	push   $0x12
  8017a2:	e8 4e fa ff ff       	call   8011f5 <syscall>
  8017a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8017aa:	90                   	nop
}
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    

008017ad <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8017b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	52                   	push   %edx
  8017bd:	50                   	push   %eax
  8017be:	6a 2a                	push   $0x2a
  8017c0:	e8 30 fa ff ff       	call   8011f5 <syscall>
  8017c5:	83 c4 18             	add    $0x18,%esp
	return;
  8017c8:	90                   	nop
}
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8017ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	50                   	push   %eax
  8017da:	6a 2b                	push   $0x2b
  8017dc:	e8 14 fa ff ff       	call   8011f5 <syscall>
  8017e1:	83 c4 18             	add    $0x18,%esp
}
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	ff 75 0c             	pushl  0xc(%ebp)
  8017f2:	ff 75 08             	pushl  0x8(%ebp)
  8017f5:	6a 2c                	push   $0x2c
  8017f7:	e8 f9 f9 ff ff       	call   8011f5 <syscall>
  8017fc:	83 c4 18             	add    $0x18,%esp
	return;
  8017ff:	90                   	nop
}
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	ff 75 0c             	pushl  0xc(%ebp)
  80180e:	ff 75 08             	pushl  0x8(%ebp)
  801811:	6a 2d                	push   $0x2d
  801813:	e8 dd f9 ff ff       	call   8011f5 <syscall>
  801818:	83 c4 18             	add    $0x18,%esp
	return;
  80181b:	90                   	nop
}
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    
  80181e:	66 90                	xchg   %ax,%ax

00801820 <__udivdi3>:
  801820:	55                   	push   %ebp
  801821:	57                   	push   %edi
  801822:	56                   	push   %esi
  801823:	53                   	push   %ebx
  801824:	83 ec 1c             	sub    $0x1c,%esp
  801827:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80182b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80182f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801833:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801837:	89 ca                	mov    %ecx,%edx
  801839:	89 f8                	mov    %edi,%eax
  80183b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80183f:	85 f6                	test   %esi,%esi
  801841:	75 2d                	jne    801870 <__udivdi3+0x50>
  801843:	39 cf                	cmp    %ecx,%edi
  801845:	77 65                	ja     8018ac <__udivdi3+0x8c>
  801847:	89 fd                	mov    %edi,%ebp
  801849:	85 ff                	test   %edi,%edi
  80184b:	75 0b                	jne    801858 <__udivdi3+0x38>
  80184d:	b8 01 00 00 00       	mov    $0x1,%eax
  801852:	31 d2                	xor    %edx,%edx
  801854:	f7 f7                	div    %edi
  801856:	89 c5                	mov    %eax,%ebp
  801858:	31 d2                	xor    %edx,%edx
  80185a:	89 c8                	mov    %ecx,%eax
  80185c:	f7 f5                	div    %ebp
  80185e:	89 c1                	mov    %eax,%ecx
  801860:	89 d8                	mov    %ebx,%eax
  801862:	f7 f5                	div    %ebp
  801864:	89 cf                	mov    %ecx,%edi
  801866:	89 fa                	mov    %edi,%edx
  801868:	83 c4 1c             	add    $0x1c,%esp
  80186b:	5b                   	pop    %ebx
  80186c:	5e                   	pop    %esi
  80186d:	5f                   	pop    %edi
  80186e:	5d                   	pop    %ebp
  80186f:	c3                   	ret    
  801870:	39 ce                	cmp    %ecx,%esi
  801872:	77 28                	ja     80189c <__udivdi3+0x7c>
  801874:	0f bd fe             	bsr    %esi,%edi
  801877:	83 f7 1f             	xor    $0x1f,%edi
  80187a:	75 40                	jne    8018bc <__udivdi3+0x9c>
  80187c:	39 ce                	cmp    %ecx,%esi
  80187e:	72 0a                	jb     80188a <__udivdi3+0x6a>
  801880:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801884:	0f 87 9e 00 00 00    	ja     801928 <__udivdi3+0x108>
  80188a:	b8 01 00 00 00       	mov    $0x1,%eax
  80188f:	89 fa                	mov    %edi,%edx
  801891:	83 c4 1c             	add    $0x1c,%esp
  801894:	5b                   	pop    %ebx
  801895:	5e                   	pop    %esi
  801896:	5f                   	pop    %edi
  801897:	5d                   	pop    %ebp
  801898:	c3                   	ret    
  801899:	8d 76 00             	lea    0x0(%esi),%esi
  80189c:	31 ff                	xor    %edi,%edi
  80189e:	31 c0                	xor    %eax,%eax
  8018a0:	89 fa                	mov    %edi,%edx
  8018a2:	83 c4 1c             	add    $0x1c,%esp
  8018a5:	5b                   	pop    %ebx
  8018a6:	5e                   	pop    %esi
  8018a7:	5f                   	pop    %edi
  8018a8:	5d                   	pop    %ebp
  8018a9:	c3                   	ret    
  8018aa:	66 90                	xchg   %ax,%ax
  8018ac:	89 d8                	mov    %ebx,%eax
  8018ae:	f7 f7                	div    %edi
  8018b0:	31 ff                	xor    %edi,%edi
  8018b2:	89 fa                	mov    %edi,%edx
  8018b4:	83 c4 1c             	add    $0x1c,%esp
  8018b7:	5b                   	pop    %ebx
  8018b8:	5e                   	pop    %esi
  8018b9:	5f                   	pop    %edi
  8018ba:	5d                   	pop    %ebp
  8018bb:	c3                   	ret    
  8018bc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8018c1:	89 eb                	mov    %ebp,%ebx
  8018c3:	29 fb                	sub    %edi,%ebx
  8018c5:	89 f9                	mov    %edi,%ecx
  8018c7:	d3 e6                	shl    %cl,%esi
  8018c9:	89 c5                	mov    %eax,%ebp
  8018cb:	88 d9                	mov    %bl,%cl
  8018cd:	d3 ed                	shr    %cl,%ebp
  8018cf:	89 e9                	mov    %ebp,%ecx
  8018d1:	09 f1                	or     %esi,%ecx
  8018d3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8018d7:	89 f9                	mov    %edi,%ecx
  8018d9:	d3 e0                	shl    %cl,%eax
  8018db:	89 c5                	mov    %eax,%ebp
  8018dd:	89 d6                	mov    %edx,%esi
  8018df:	88 d9                	mov    %bl,%cl
  8018e1:	d3 ee                	shr    %cl,%esi
  8018e3:	89 f9                	mov    %edi,%ecx
  8018e5:	d3 e2                	shl    %cl,%edx
  8018e7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018eb:	88 d9                	mov    %bl,%cl
  8018ed:	d3 e8                	shr    %cl,%eax
  8018ef:	09 c2                	or     %eax,%edx
  8018f1:	89 d0                	mov    %edx,%eax
  8018f3:	89 f2                	mov    %esi,%edx
  8018f5:	f7 74 24 0c          	divl   0xc(%esp)
  8018f9:	89 d6                	mov    %edx,%esi
  8018fb:	89 c3                	mov    %eax,%ebx
  8018fd:	f7 e5                	mul    %ebp
  8018ff:	39 d6                	cmp    %edx,%esi
  801901:	72 19                	jb     80191c <__udivdi3+0xfc>
  801903:	74 0b                	je     801910 <__udivdi3+0xf0>
  801905:	89 d8                	mov    %ebx,%eax
  801907:	31 ff                	xor    %edi,%edi
  801909:	e9 58 ff ff ff       	jmp    801866 <__udivdi3+0x46>
  80190e:	66 90                	xchg   %ax,%ax
  801910:	8b 54 24 08          	mov    0x8(%esp),%edx
  801914:	89 f9                	mov    %edi,%ecx
  801916:	d3 e2                	shl    %cl,%edx
  801918:	39 c2                	cmp    %eax,%edx
  80191a:	73 e9                	jae    801905 <__udivdi3+0xe5>
  80191c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80191f:	31 ff                	xor    %edi,%edi
  801921:	e9 40 ff ff ff       	jmp    801866 <__udivdi3+0x46>
  801926:	66 90                	xchg   %ax,%ax
  801928:	31 c0                	xor    %eax,%eax
  80192a:	e9 37 ff ff ff       	jmp    801866 <__udivdi3+0x46>
  80192f:	90                   	nop

00801930 <__umoddi3>:
  801930:	55                   	push   %ebp
  801931:	57                   	push   %edi
  801932:	56                   	push   %esi
  801933:	53                   	push   %ebx
  801934:	83 ec 1c             	sub    $0x1c,%esp
  801937:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80193b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80193f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801943:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801947:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80194b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80194f:	89 f3                	mov    %esi,%ebx
  801951:	89 fa                	mov    %edi,%edx
  801953:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801957:	89 34 24             	mov    %esi,(%esp)
  80195a:	85 c0                	test   %eax,%eax
  80195c:	75 1a                	jne    801978 <__umoddi3+0x48>
  80195e:	39 f7                	cmp    %esi,%edi
  801960:	0f 86 a2 00 00 00    	jbe    801a08 <__umoddi3+0xd8>
  801966:	89 c8                	mov    %ecx,%eax
  801968:	89 f2                	mov    %esi,%edx
  80196a:	f7 f7                	div    %edi
  80196c:	89 d0                	mov    %edx,%eax
  80196e:	31 d2                	xor    %edx,%edx
  801970:	83 c4 1c             	add    $0x1c,%esp
  801973:	5b                   	pop    %ebx
  801974:	5e                   	pop    %esi
  801975:	5f                   	pop    %edi
  801976:	5d                   	pop    %ebp
  801977:	c3                   	ret    
  801978:	39 f0                	cmp    %esi,%eax
  80197a:	0f 87 ac 00 00 00    	ja     801a2c <__umoddi3+0xfc>
  801980:	0f bd e8             	bsr    %eax,%ebp
  801983:	83 f5 1f             	xor    $0x1f,%ebp
  801986:	0f 84 ac 00 00 00    	je     801a38 <__umoddi3+0x108>
  80198c:	bf 20 00 00 00       	mov    $0x20,%edi
  801991:	29 ef                	sub    %ebp,%edi
  801993:	89 fe                	mov    %edi,%esi
  801995:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801999:	89 e9                	mov    %ebp,%ecx
  80199b:	d3 e0                	shl    %cl,%eax
  80199d:	89 d7                	mov    %edx,%edi
  80199f:	89 f1                	mov    %esi,%ecx
  8019a1:	d3 ef                	shr    %cl,%edi
  8019a3:	09 c7                	or     %eax,%edi
  8019a5:	89 e9                	mov    %ebp,%ecx
  8019a7:	d3 e2                	shl    %cl,%edx
  8019a9:	89 14 24             	mov    %edx,(%esp)
  8019ac:	89 d8                	mov    %ebx,%eax
  8019ae:	d3 e0                	shl    %cl,%eax
  8019b0:	89 c2                	mov    %eax,%edx
  8019b2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019b6:	d3 e0                	shl    %cl,%eax
  8019b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019bc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019c0:	89 f1                	mov    %esi,%ecx
  8019c2:	d3 e8                	shr    %cl,%eax
  8019c4:	09 d0                	or     %edx,%eax
  8019c6:	d3 eb                	shr    %cl,%ebx
  8019c8:	89 da                	mov    %ebx,%edx
  8019ca:	f7 f7                	div    %edi
  8019cc:	89 d3                	mov    %edx,%ebx
  8019ce:	f7 24 24             	mull   (%esp)
  8019d1:	89 c6                	mov    %eax,%esi
  8019d3:	89 d1                	mov    %edx,%ecx
  8019d5:	39 d3                	cmp    %edx,%ebx
  8019d7:	0f 82 87 00 00 00    	jb     801a64 <__umoddi3+0x134>
  8019dd:	0f 84 91 00 00 00    	je     801a74 <__umoddi3+0x144>
  8019e3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8019e7:	29 f2                	sub    %esi,%edx
  8019e9:	19 cb                	sbb    %ecx,%ebx
  8019eb:	89 d8                	mov    %ebx,%eax
  8019ed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8019f1:	d3 e0                	shl    %cl,%eax
  8019f3:	89 e9                	mov    %ebp,%ecx
  8019f5:	d3 ea                	shr    %cl,%edx
  8019f7:	09 d0                	or     %edx,%eax
  8019f9:	89 e9                	mov    %ebp,%ecx
  8019fb:	d3 eb                	shr    %cl,%ebx
  8019fd:	89 da                	mov    %ebx,%edx
  8019ff:	83 c4 1c             	add    $0x1c,%esp
  801a02:	5b                   	pop    %ebx
  801a03:	5e                   	pop    %esi
  801a04:	5f                   	pop    %edi
  801a05:	5d                   	pop    %ebp
  801a06:	c3                   	ret    
  801a07:	90                   	nop
  801a08:	89 fd                	mov    %edi,%ebp
  801a0a:	85 ff                	test   %edi,%edi
  801a0c:	75 0b                	jne    801a19 <__umoddi3+0xe9>
  801a0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a13:	31 d2                	xor    %edx,%edx
  801a15:	f7 f7                	div    %edi
  801a17:	89 c5                	mov    %eax,%ebp
  801a19:	89 f0                	mov    %esi,%eax
  801a1b:	31 d2                	xor    %edx,%edx
  801a1d:	f7 f5                	div    %ebp
  801a1f:	89 c8                	mov    %ecx,%eax
  801a21:	f7 f5                	div    %ebp
  801a23:	89 d0                	mov    %edx,%eax
  801a25:	e9 44 ff ff ff       	jmp    80196e <__umoddi3+0x3e>
  801a2a:	66 90                	xchg   %ax,%ax
  801a2c:	89 c8                	mov    %ecx,%eax
  801a2e:	89 f2                	mov    %esi,%edx
  801a30:	83 c4 1c             	add    $0x1c,%esp
  801a33:	5b                   	pop    %ebx
  801a34:	5e                   	pop    %esi
  801a35:	5f                   	pop    %edi
  801a36:	5d                   	pop    %ebp
  801a37:	c3                   	ret    
  801a38:	3b 04 24             	cmp    (%esp),%eax
  801a3b:	72 06                	jb     801a43 <__umoddi3+0x113>
  801a3d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a41:	77 0f                	ja     801a52 <__umoddi3+0x122>
  801a43:	89 f2                	mov    %esi,%edx
  801a45:	29 f9                	sub    %edi,%ecx
  801a47:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801a4b:	89 14 24             	mov    %edx,(%esp)
  801a4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a52:	8b 44 24 04          	mov    0x4(%esp),%eax
  801a56:	8b 14 24             	mov    (%esp),%edx
  801a59:	83 c4 1c             	add    $0x1c,%esp
  801a5c:	5b                   	pop    %ebx
  801a5d:	5e                   	pop    %esi
  801a5e:	5f                   	pop    %edi
  801a5f:	5d                   	pop    %ebp
  801a60:	c3                   	ret    
  801a61:	8d 76 00             	lea    0x0(%esi),%esi
  801a64:	2b 04 24             	sub    (%esp),%eax
  801a67:	19 fa                	sbb    %edi,%edx
  801a69:	89 d1                	mov    %edx,%ecx
  801a6b:	89 c6                	mov    %eax,%esi
  801a6d:	e9 71 ff ff ff       	jmp    8019e3 <__umoddi3+0xb3>
  801a72:	66 90                	xchg   %ax,%ax
  801a74:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801a78:	72 ea                	jb     801a64 <__umoddi3+0x134>
  801a7a:	89 d9                	mov    %ebx,%ecx
  801a7c:	e9 62 ff ff ff       	jmp    8019e3 <__umoddi3+0xb3>
