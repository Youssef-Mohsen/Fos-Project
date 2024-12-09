
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
  800079:	e8 d1 15 00 00       	call   80164f <inctst>
	panic("tst invalid access failed: Attempt to access page that's not exist in page file, neither stack or heap.\nThe env must be killed and shouldn't return here.");
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	68 60 1b 80 00       	push   $0x801b60
  800086:	6a 18                	push   $0x18
  800088:	68 fc 1b 80 00       	push   $0x801bfc
  80008d:	e8 3f 01 00 00       	call   8001d1 <_panic>

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
  800098:	e8 74 14 00 00       	call   801511 <sys_getenvindex>
  80009d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a3:	89 d0                	mov    %edx,%eax
  8000a5:	c1 e0 03             	shl    $0x3,%eax
  8000a8:	01 d0                	add    %edx,%eax
  8000aa:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000b1:	01 c8                	add    %ecx,%eax
  8000b3:	01 c0                	add    %eax,%eax
  8000b5:	01 d0                	add    %edx,%eax
  8000b7:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000be:	01 c8                	add    %ecx,%eax
  8000c0:	01 d0                	add    %edx,%eax
  8000c2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000c7:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000cc:	a1 04 30 80 00       	mov    0x803004,%eax
  8000d1:	8a 40 20             	mov    0x20(%eax),%al
  8000d4:	84 c0                	test   %al,%al
  8000d6:	74 0d                	je     8000e5 <libmain+0x53>
		binaryname = myEnv->prog_name;
  8000d8:	a1 04 30 80 00       	mov    0x803004,%eax
  8000dd:	83 c0 20             	add    $0x20,%eax
  8000e0:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000e9:	7e 0a                	jle    8000f5 <libmain+0x63>
		binaryname = argv[0];
  8000eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ee:	8b 00                	mov    (%eax),%eax
  8000f0:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000f5:	83 ec 08             	sub    $0x8,%esp
  8000f8:	ff 75 0c             	pushl  0xc(%ebp)
  8000fb:	ff 75 08             	pushl  0x8(%ebp)
  8000fe:	e8 35 ff ff ff       	call   800038 <_main>
  800103:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800106:	e8 8a 11 00 00       	call   801295 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 38 1c 80 00       	push   $0x801c38
  800113:	e8 76 03 00 00       	call   80048e <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80011b:	a1 04 30 80 00       	mov    0x803004,%eax
  800120:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800126:	a1 04 30 80 00       	mov    0x803004,%eax
  80012b:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800131:	83 ec 04             	sub    $0x4,%esp
  800134:	52                   	push   %edx
  800135:	50                   	push   %eax
  800136:	68 60 1c 80 00       	push   $0x801c60
  80013b:	e8 4e 03 00 00       	call   80048e <cprintf>
  800140:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800143:	a1 04 30 80 00       	mov    0x803004,%eax
  800148:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  80014e:	a1 04 30 80 00       	mov    0x803004,%eax
  800153:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  800159:	a1 04 30 80 00       	mov    0x803004,%eax
  80015e:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800164:	51                   	push   %ecx
  800165:	52                   	push   %edx
  800166:	50                   	push   %eax
  800167:	68 88 1c 80 00       	push   $0x801c88
  80016c:	e8 1d 03 00 00       	call   80048e <cprintf>
  800171:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800174:	a1 04 30 80 00       	mov    0x803004,%eax
  800179:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80017f:	83 ec 08             	sub    $0x8,%esp
  800182:	50                   	push   %eax
  800183:	68 e0 1c 80 00       	push   $0x801ce0
  800188:	e8 01 03 00 00       	call   80048e <cprintf>
  80018d:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 38 1c 80 00       	push   $0x801c38
  800198:	e8 f1 02 00 00       	call   80048e <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8001a0:	e8 0a 11 00 00       	call   8012af <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8001a5:	e8 19 00 00 00       	call   8001c3 <exit>
}
  8001aa:	90                   	nop
  8001ab:	c9                   	leave  
  8001ac:	c3                   	ret    

008001ad <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	6a 00                	push   $0x0
  8001b8:	e8 20 13 00 00       	call   8014dd <sys_destroy_env>
  8001bd:	83 c4 10             	add    $0x10,%esp
}
  8001c0:	90                   	nop
  8001c1:	c9                   	leave  
  8001c2:	c3                   	ret    

008001c3 <exit>:

void
exit(void)
{
  8001c3:	55                   	push   %ebp
  8001c4:	89 e5                	mov    %esp,%ebp
  8001c6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001c9:	e8 75 13 00 00       	call   801543 <sys_exit_env>
}
  8001ce:	90                   	nop
  8001cf:	c9                   	leave  
  8001d0:	c3                   	ret    

008001d1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001d1:	55                   	push   %ebp
  8001d2:	89 e5                	mov    %esp,%ebp
  8001d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001d7:	8d 45 10             	lea    0x10(%ebp),%eax
  8001da:	83 c0 04             	add    $0x4,%eax
  8001dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001e0:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8001e5:	85 c0                	test   %eax,%eax
  8001e7:	74 16                	je     8001ff <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001e9:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8001ee:	83 ec 08             	sub    $0x8,%esp
  8001f1:	50                   	push   %eax
  8001f2:	68 f4 1c 80 00       	push   $0x801cf4
  8001f7:	e8 92 02 00 00       	call   80048e <cprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001ff:	a1 00 30 80 00       	mov    0x803000,%eax
  800204:	ff 75 0c             	pushl  0xc(%ebp)
  800207:	ff 75 08             	pushl  0x8(%ebp)
  80020a:	50                   	push   %eax
  80020b:	68 f9 1c 80 00       	push   $0x801cf9
  800210:	e8 79 02 00 00       	call   80048e <cprintf>
  800215:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800218:	8b 45 10             	mov    0x10(%ebp),%eax
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	ff 75 f4             	pushl  -0xc(%ebp)
  800221:	50                   	push   %eax
  800222:	e8 fc 01 00 00       	call   800423 <vcprintf>
  800227:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80022a:	83 ec 08             	sub    $0x8,%esp
  80022d:	6a 00                	push   $0x0
  80022f:	68 15 1d 80 00       	push   $0x801d15
  800234:	e8 ea 01 00 00       	call   800423 <vcprintf>
  800239:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80023c:	e8 82 ff ff ff       	call   8001c3 <exit>

	// should not return here
	while (1) ;
  800241:	eb fe                	jmp    800241 <_panic+0x70>

00800243 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800249:	a1 04 30 80 00       	mov    0x803004,%eax
  80024e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800254:	8b 45 0c             	mov    0xc(%ebp),%eax
  800257:	39 c2                	cmp    %eax,%edx
  800259:	74 14                	je     80026f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80025b:	83 ec 04             	sub    $0x4,%esp
  80025e:	68 18 1d 80 00       	push   $0x801d18
  800263:	6a 26                	push   $0x26
  800265:	68 64 1d 80 00       	push   $0x801d64
  80026a:	e8 62 ff ff ff       	call   8001d1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80026f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800276:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80027d:	e9 c5 00 00 00       	jmp    800347 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800282:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800285:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80028c:	8b 45 08             	mov    0x8(%ebp),%eax
  80028f:	01 d0                	add    %edx,%eax
  800291:	8b 00                	mov    (%eax),%eax
  800293:	85 c0                	test   %eax,%eax
  800295:	75 08                	jne    80029f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800297:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80029a:	e9 a5 00 00 00       	jmp    800344 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80029f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002a6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002ad:	eb 69                	jmp    800318 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8002af:	a1 04 30 80 00       	mov    0x803004,%eax
  8002b4:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8002ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002bd:	89 d0                	mov    %edx,%eax
  8002bf:	01 c0                	add    %eax,%eax
  8002c1:	01 d0                	add    %edx,%eax
  8002c3:	c1 e0 03             	shl    $0x3,%eax
  8002c6:	01 c8                	add    %ecx,%eax
  8002c8:	8a 40 04             	mov    0x4(%eax),%al
  8002cb:	84 c0                	test   %al,%al
  8002cd:	75 46                	jne    800315 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002cf:	a1 04 30 80 00       	mov    0x803004,%eax
  8002d4:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8002da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002dd:	89 d0                	mov    %edx,%eax
  8002df:	01 c0                	add    %eax,%eax
  8002e1:	01 d0                	add    %edx,%eax
  8002e3:	c1 e0 03             	shl    $0x3,%eax
  8002e6:	01 c8                	add    %ecx,%eax
  8002e8:	8b 00                	mov    (%eax),%eax
  8002ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002f5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002fa:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800301:	8b 45 08             	mov    0x8(%ebp),%eax
  800304:	01 c8                	add    %ecx,%eax
  800306:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800308:	39 c2                	cmp    %eax,%edx
  80030a:	75 09                	jne    800315 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80030c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800313:	eb 15                	jmp    80032a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800315:	ff 45 e8             	incl   -0x18(%ebp)
  800318:	a1 04 30 80 00       	mov    0x803004,%eax
  80031d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800323:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800326:	39 c2                	cmp    %eax,%edx
  800328:	77 85                	ja     8002af <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80032a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80032e:	75 14                	jne    800344 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800330:	83 ec 04             	sub    $0x4,%esp
  800333:	68 70 1d 80 00       	push   $0x801d70
  800338:	6a 3a                	push   $0x3a
  80033a:	68 64 1d 80 00       	push   $0x801d64
  80033f:	e8 8d fe ff ff       	call   8001d1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800344:	ff 45 f0             	incl   -0x10(%ebp)
  800347:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80034d:	0f 8c 2f ff ff ff    	jl     800282 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800353:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80035a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800361:	eb 26                	jmp    800389 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800363:	a1 04 30 80 00       	mov    0x803004,%eax
  800368:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80036e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800371:	89 d0                	mov    %edx,%eax
  800373:	01 c0                	add    %eax,%eax
  800375:	01 d0                	add    %edx,%eax
  800377:	c1 e0 03             	shl    $0x3,%eax
  80037a:	01 c8                	add    %ecx,%eax
  80037c:	8a 40 04             	mov    0x4(%eax),%al
  80037f:	3c 01                	cmp    $0x1,%al
  800381:	75 03                	jne    800386 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800383:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800386:	ff 45 e0             	incl   -0x20(%ebp)
  800389:	a1 04 30 80 00       	mov    0x803004,%eax
  80038e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800394:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800397:	39 c2                	cmp    %eax,%edx
  800399:	77 c8                	ja     800363 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80039b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80039e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003a1:	74 14                	je     8003b7 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8003a3:	83 ec 04             	sub    $0x4,%esp
  8003a6:	68 c4 1d 80 00       	push   $0x801dc4
  8003ab:	6a 44                	push   $0x44
  8003ad:	68 64 1d 80 00       	push   $0x801d64
  8003b2:	e8 1a fe ff ff       	call   8001d1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8003b7:	90                   	nop
  8003b8:	c9                   	leave  
  8003b9:	c3                   	ret    

008003ba <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8003ba:	55                   	push   %ebp
  8003bb:	89 e5                	mov    %esp,%ebp
  8003bd:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8003c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c3:	8b 00                	mov    (%eax),%eax
  8003c5:	8d 48 01             	lea    0x1(%eax),%ecx
  8003c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003cb:	89 0a                	mov    %ecx,(%edx)
  8003cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8003d0:	88 d1                	mov    %dl,%cl
  8003d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003d5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dc:	8b 00                	mov    (%eax),%eax
  8003de:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003e3:	75 2c                	jne    800411 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003e5:	a0 08 30 80 00       	mov    0x803008,%al
  8003ea:	0f b6 c0             	movzbl %al,%eax
  8003ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003f0:	8b 12                	mov    (%edx),%edx
  8003f2:	89 d1                	mov    %edx,%ecx
  8003f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003f7:	83 c2 08             	add    $0x8,%edx
  8003fa:	83 ec 04             	sub    $0x4,%esp
  8003fd:	50                   	push   %eax
  8003fe:	51                   	push   %ecx
  8003ff:	52                   	push   %edx
  800400:	e8 4e 0e 00 00       	call   801253 <sys_cputs>
  800405:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800408:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800411:	8b 45 0c             	mov    0xc(%ebp),%eax
  800414:	8b 40 04             	mov    0x4(%eax),%eax
  800417:	8d 50 01             	lea    0x1(%eax),%edx
  80041a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800420:	90                   	nop
  800421:	c9                   	leave  
  800422:	c3                   	ret    

00800423 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800423:	55                   	push   %ebp
  800424:	89 e5                	mov    %esp,%ebp
  800426:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80042c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800433:	00 00 00 
	b.cnt = 0;
  800436:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80043d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800440:	ff 75 0c             	pushl  0xc(%ebp)
  800443:	ff 75 08             	pushl  0x8(%ebp)
  800446:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80044c:	50                   	push   %eax
  80044d:	68 ba 03 80 00       	push   $0x8003ba
  800452:	e8 11 02 00 00       	call   800668 <vprintfmt>
  800457:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80045a:	a0 08 30 80 00       	mov    0x803008,%al
  80045f:	0f b6 c0             	movzbl %al,%eax
  800462:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800468:	83 ec 04             	sub    $0x4,%esp
  80046b:	50                   	push   %eax
  80046c:	52                   	push   %edx
  80046d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800473:	83 c0 08             	add    $0x8,%eax
  800476:	50                   	push   %eax
  800477:	e8 d7 0d 00 00       	call   801253 <sys_cputs>
  80047c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80047f:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800486:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80048c:	c9                   	leave  
  80048d:	c3                   	ret    

0080048e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80048e:	55                   	push   %ebp
  80048f:	89 e5                	mov    %esp,%ebp
  800491:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800494:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  80049b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80049e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	83 ec 08             	sub    $0x8,%esp
  8004a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8004aa:	50                   	push   %eax
  8004ab:	e8 73 ff ff ff       	call   800423 <vcprintf>
  8004b0:	83 c4 10             	add    $0x10,%esp
  8004b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8004b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004b9:	c9                   	leave  
  8004ba:	c3                   	ret    

008004bb <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8004bb:	55                   	push   %ebp
  8004bc:	89 e5                	mov    %esp,%ebp
  8004be:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8004c1:	e8 cf 0d 00 00       	call   801295 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8004c6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8004cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cf:	83 ec 08             	sub    $0x8,%esp
  8004d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8004d5:	50                   	push   %eax
  8004d6:	e8 48 ff ff ff       	call   800423 <vcprintf>
  8004db:	83 c4 10             	add    $0x10,%esp
  8004de:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004e1:	e8 c9 0d 00 00       	call   8012af <sys_unlock_cons>
	return cnt;
  8004e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004e9:	c9                   	leave  
  8004ea:	c3                   	ret    

008004eb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004eb:	55                   	push   %ebp
  8004ec:	89 e5                	mov    %esp,%ebp
  8004ee:	53                   	push   %ebx
  8004ef:	83 ec 14             	sub    $0x14,%esp
  8004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004fe:	8b 45 18             	mov    0x18(%ebp),%eax
  800501:	ba 00 00 00 00       	mov    $0x0,%edx
  800506:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800509:	77 55                	ja     800560 <printnum+0x75>
  80050b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80050e:	72 05                	jb     800515 <printnum+0x2a>
  800510:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800513:	77 4b                	ja     800560 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800515:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800518:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80051b:	8b 45 18             	mov    0x18(%ebp),%eax
  80051e:	ba 00 00 00 00       	mov    $0x0,%edx
  800523:	52                   	push   %edx
  800524:	50                   	push   %eax
  800525:	ff 75 f4             	pushl  -0xc(%ebp)
  800528:	ff 75 f0             	pushl  -0x10(%ebp)
  80052b:	e8 c0 13 00 00       	call   8018f0 <__udivdi3>
  800530:	83 c4 10             	add    $0x10,%esp
  800533:	83 ec 04             	sub    $0x4,%esp
  800536:	ff 75 20             	pushl  0x20(%ebp)
  800539:	53                   	push   %ebx
  80053a:	ff 75 18             	pushl  0x18(%ebp)
  80053d:	52                   	push   %edx
  80053e:	50                   	push   %eax
  80053f:	ff 75 0c             	pushl  0xc(%ebp)
  800542:	ff 75 08             	pushl  0x8(%ebp)
  800545:	e8 a1 ff ff ff       	call   8004eb <printnum>
  80054a:	83 c4 20             	add    $0x20,%esp
  80054d:	eb 1a                	jmp    800569 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80054f:	83 ec 08             	sub    $0x8,%esp
  800552:	ff 75 0c             	pushl  0xc(%ebp)
  800555:	ff 75 20             	pushl  0x20(%ebp)
  800558:	8b 45 08             	mov    0x8(%ebp),%eax
  80055b:	ff d0                	call   *%eax
  80055d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800560:	ff 4d 1c             	decl   0x1c(%ebp)
  800563:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800567:	7f e6                	jg     80054f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800569:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80056c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800571:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800574:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800577:	53                   	push   %ebx
  800578:	51                   	push   %ecx
  800579:	52                   	push   %edx
  80057a:	50                   	push   %eax
  80057b:	e8 80 14 00 00       	call   801a00 <__umoddi3>
  800580:	83 c4 10             	add    $0x10,%esp
  800583:	05 34 20 80 00       	add    $0x802034,%eax
  800588:	8a 00                	mov    (%eax),%al
  80058a:	0f be c0             	movsbl %al,%eax
  80058d:	83 ec 08             	sub    $0x8,%esp
  800590:	ff 75 0c             	pushl  0xc(%ebp)
  800593:	50                   	push   %eax
  800594:	8b 45 08             	mov    0x8(%ebp),%eax
  800597:	ff d0                	call   *%eax
  800599:	83 c4 10             	add    $0x10,%esp
}
  80059c:	90                   	nop
  80059d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005a0:	c9                   	leave  
  8005a1:	c3                   	ret    

008005a2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005a2:	55                   	push   %ebp
  8005a3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005a5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005a9:	7e 1c                	jle    8005c7 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8005ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	8d 50 08             	lea    0x8(%eax),%edx
  8005b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b6:	89 10                	mov    %edx,(%eax)
  8005b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bb:	8b 00                	mov    (%eax),%eax
  8005bd:	83 e8 08             	sub    $0x8,%eax
  8005c0:	8b 50 04             	mov    0x4(%eax),%edx
  8005c3:	8b 00                	mov    (%eax),%eax
  8005c5:	eb 40                	jmp    800607 <getuint+0x65>
	else if (lflag)
  8005c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005cb:	74 1e                	je     8005eb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	8d 50 04             	lea    0x4(%eax),%edx
  8005d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d8:	89 10                	mov    %edx,(%eax)
  8005da:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	83 e8 04             	sub    $0x4,%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e9:	eb 1c                	jmp    800607 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ee:	8b 00                	mov    (%eax),%eax
  8005f0:	8d 50 04             	lea    0x4(%eax),%edx
  8005f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f6:	89 10                	mov    %edx,(%eax)
  8005f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fb:	8b 00                	mov    (%eax),%eax
  8005fd:	83 e8 04             	sub    $0x4,%eax
  800600:	8b 00                	mov    (%eax),%eax
  800602:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800607:	5d                   	pop    %ebp
  800608:	c3                   	ret    

00800609 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800609:	55                   	push   %ebp
  80060a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80060c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800610:	7e 1c                	jle    80062e <getint+0x25>
		return va_arg(*ap, long long);
  800612:	8b 45 08             	mov    0x8(%ebp),%eax
  800615:	8b 00                	mov    (%eax),%eax
  800617:	8d 50 08             	lea    0x8(%eax),%edx
  80061a:	8b 45 08             	mov    0x8(%ebp),%eax
  80061d:	89 10                	mov    %edx,(%eax)
  80061f:	8b 45 08             	mov    0x8(%ebp),%eax
  800622:	8b 00                	mov    (%eax),%eax
  800624:	83 e8 08             	sub    $0x8,%eax
  800627:	8b 50 04             	mov    0x4(%eax),%edx
  80062a:	8b 00                	mov    (%eax),%eax
  80062c:	eb 38                	jmp    800666 <getint+0x5d>
	else if (lflag)
  80062e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800632:	74 1a                	je     80064e <getint+0x45>
		return va_arg(*ap, long);
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	8b 00                	mov    (%eax),%eax
  800639:	8d 50 04             	lea    0x4(%eax),%edx
  80063c:	8b 45 08             	mov    0x8(%ebp),%eax
  80063f:	89 10                	mov    %edx,(%eax)
  800641:	8b 45 08             	mov    0x8(%ebp),%eax
  800644:	8b 00                	mov    (%eax),%eax
  800646:	83 e8 04             	sub    $0x4,%eax
  800649:	8b 00                	mov    (%eax),%eax
  80064b:	99                   	cltd   
  80064c:	eb 18                	jmp    800666 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	8b 00                	mov    (%eax),%eax
  800653:	8d 50 04             	lea    0x4(%eax),%edx
  800656:	8b 45 08             	mov    0x8(%ebp),%eax
  800659:	89 10                	mov    %edx,(%eax)
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	83 e8 04             	sub    $0x4,%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	99                   	cltd   
}
  800666:	5d                   	pop    %ebp
  800667:	c3                   	ret    

00800668 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800668:	55                   	push   %ebp
  800669:	89 e5                	mov    %esp,%ebp
  80066b:	56                   	push   %esi
  80066c:	53                   	push   %ebx
  80066d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800670:	eb 17                	jmp    800689 <vprintfmt+0x21>
			if (ch == '\0')
  800672:	85 db                	test   %ebx,%ebx
  800674:	0f 84 c1 03 00 00    	je     800a3b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80067a:	83 ec 08             	sub    $0x8,%esp
  80067d:	ff 75 0c             	pushl  0xc(%ebp)
  800680:	53                   	push   %ebx
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	ff d0                	call   *%eax
  800686:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800689:	8b 45 10             	mov    0x10(%ebp),%eax
  80068c:	8d 50 01             	lea    0x1(%eax),%edx
  80068f:	89 55 10             	mov    %edx,0x10(%ebp)
  800692:	8a 00                	mov    (%eax),%al
  800694:	0f b6 d8             	movzbl %al,%ebx
  800697:	83 fb 25             	cmp    $0x25,%ebx
  80069a:	75 d6                	jne    800672 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80069c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8006a0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8006a7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006ae:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8006b5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8006bf:	8d 50 01             	lea    0x1(%eax),%edx
  8006c2:	89 55 10             	mov    %edx,0x10(%ebp)
  8006c5:	8a 00                	mov    (%eax),%al
  8006c7:	0f b6 d8             	movzbl %al,%ebx
  8006ca:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006cd:	83 f8 5b             	cmp    $0x5b,%eax
  8006d0:	0f 87 3d 03 00 00    	ja     800a13 <vprintfmt+0x3ab>
  8006d6:	8b 04 85 58 20 80 00 	mov    0x802058(,%eax,4),%eax
  8006dd:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006df:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006e3:	eb d7                	jmp    8006bc <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006e5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006e9:	eb d1                	jmp    8006bc <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006eb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006f5:	89 d0                	mov    %edx,%eax
  8006f7:	c1 e0 02             	shl    $0x2,%eax
  8006fa:	01 d0                	add    %edx,%eax
  8006fc:	01 c0                	add    %eax,%eax
  8006fe:	01 d8                	add    %ebx,%eax
  800700:	83 e8 30             	sub    $0x30,%eax
  800703:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800706:	8b 45 10             	mov    0x10(%ebp),%eax
  800709:	8a 00                	mov    (%eax),%al
  80070b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80070e:	83 fb 2f             	cmp    $0x2f,%ebx
  800711:	7e 3e                	jle    800751 <vprintfmt+0xe9>
  800713:	83 fb 39             	cmp    $0x39,%ebx
  800716:	7f 39                	jg     800751 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800718:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80071b:	eb d5                	jmp    8006f2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	83 c0 04             	add    $0x4,%eax
  800723:	89 45 14             	mov    %eax,0x14(%ebp)
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	83 e8 04             	sub    $0x4,%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800731:	eb 1f                	jmp    800752 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800733:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800737:	79 83                	jns    8006bc <vprintfmt+0x54>
				width = 0;
  800739:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800740:	e9 77 ff ff ff       	jmp    8006bc <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800745:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80074c:	e9 6b ff ff ff       	jmp    8006bc <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800751:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800752:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800756:	0f 89 60 ff ff ff    	jns    8006bc <vprintfmt+0x54>
				width = precision, precision = -1;
  80075c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80075f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800762:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800769:	e9 4e ff ff ff       	jmp    8006bc <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80076e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800771:	e9 46 ff ff ff       	jmp    8006bc <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800776:	8b 45 14             	mov    0x14(%ebp),%eax
  800779:	83 c0 04             	add    $0x4,%eax
  80077c:	89 45 14             	mov    %eax,0x14(%ebp)
  80077f:	8b 45 14             	mov    0x14(%ebp),%eax
  800782:	83 e8 04             	sub    $0x4,%eax
  800785:	8b 00                	mov    (%eax),%eax
  800787:	83 ec 08             	sub    $0x8,%esp
  80078a:	ff 75 0c             	pushl  0xc(%ebp)
  80078d:	50                   	push   %eax
  80078e:	8b 45 08             	mov    0x8(%ebp),%eax
  800791:	ff d0                	call   *%eax
  800793:	83 c4 10             	add    $0x10,%esp
			break;
  800796:	e9 9b 02 00 00       	jmp    800a36 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80079b:	8b 45 14             	mov    0x14(%ebp),%eax
  80079e:	83 c0 04             	add    $0x4,%eax
  8007a1:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	83 e8 04             	sub    $0x4,%eax
  8007aa:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8007ac:	85 db                	test   %ebx,%ebx
  8007ae:	79 02                	jns    8007b2 <vprintfmt+0x14a>
				err = -err;
  8007b0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007b2:	83 fb 64             	cmp    $0x64,%ebx
  8007b5:	7f 0b                	jg     8007c2 <vprintfmt+0x15a>
  8007b7:	8b 34 9d a0 1e 80 00 	mov    0x801ea0(,%ebx,4),%esi
  8007be:	85 f6                	test   %esi,%esi
  8007c0:	75 19                	jne    8007db <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007c2:	53                   	push   %ebx
  8007c3:	68 45 20 80 00       	push   $0x802045
  8007c8:	ff 75 0c             	pushl  0xc(%ebp)
  8007cb:	ff 75 08             	pushl  0x8(%ebp)
  8007ce:	e8 70 02 00 00       	call   800a43 <printfmt>
  8007d3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007d6:	e9 5b 02 00 00       	jmp    800a36 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007db:	56                   	push   %esi
  8007dc:	68 4e 20 80 00       	push   $0x80204e
  8007e1:	ff 75 0c             	pushl  0xc(%ebp)
  8007e4:	ff 75 08             	pushl  0x8(%ebp)
  8007e7:	e8 57 02 00 00       	call   800a43 <printfmt>
  8007ec:	83 c4 10             	add    $0x10,%esp
			break;
  8007ef:	e9 42 02 00 00       	jmp    800a36 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	83 c0 04             	add    $0x4,%eax
  8007fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8007fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800800:	83 e8 04             	sub    $0x4,%eax
  800803:	8b 30                	mov    (%eax),%esi
  800805:	85 f6                	test   %esi,%esi
  800807:	75 05                	jne    80080e <vprintfmt+0x1a6>
				p = "(null)";
  800809:	be 51 20 80 00       	mov    $0x802051,%esi
			if (width > 0 && padc != '-')
  80080e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800812:	7e 6d                	jle    800881 <vprintfmt+0x219>
  800814:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800818:	74 67                	je     800881 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80081a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80081d:	83 ec 08             	sub    $0x8,%esp
  800820:	50                   	push   %eax
  800821:	56                   	push   %esi
  800822:	e8 1e 03 00 00       	call   800b45 <strnlen>
  800827:	83 c4 10             	add    $0x10,%esp
  80082a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80082d:	eb 16                	jmp    800845 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80082f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800833:	83 ec 08             	sub    $0x8,%esp
  800836:	ff 75 0c             	pushl  0xc(%ebp)
  800839:	50                   	push   %eax
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	ff d0                	call   *%eax
  80083f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800842:	ff 4d e4             	decl   -0x1c(%ebp)
  800845:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800849:	7f e4                	jg     80082f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80084b:	eb 34                	jmp    800881 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80084d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800851:	74 1c                	je     80086f <vprintfmt+0x207>
  800853:	83 fb 1f             	cmp    $0x1f,%ebx
  800856:	7e 05                	jle    80085d <vprintfmt+0x1f5>
  800858:	83 fb 7e             	cmp    $0x7e,%ebx
  80085b:	7e 12                	jle    80086f <vprintfmt+0x207>
					putch('?', putdat);
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	ff 75 0c             	pushl  0xc(%ebp)
  800863:	6a 3f                	push   $0x3f
  800865:	8b 45 08             	mov    0x8(%ebp),%eax
  800868:	ff d0                	call   *%eax
  80086a:	83 c4 10             	add    $0x10,%esp
  80086d:	eb 0f                	jmp    80087e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	ff 75 0c             	pushl  0xc(%ebp)
  800875:	53                   	push   %ebx
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	ff d0                	call   *%eax
  80087b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80087e:	ff 4d e4             	decl   -0x1c(%ebp)
  800881:	89 f0                	mov    %esi,%eax
  800883:	8d 70 01             	lea    0x1(%eax),%esi
  800886:	8a 00                	mov    (%eax),%al
  800888:	0f be d8             	movsbl %al,%ebx
  80088b:	85 db                	test   %ebx,%ebx
  80088d:	74 24                	je     8008b3 <vprintfmt+0x24b>
  80088f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800893:	78 b8                	js     80084d <vprintfmt+0x1e5>
  800895:	ff 4d e0             	decl   -0x20(%ebp)
  800898:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80089c:	79 af                	jns    80084d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80089e:	eb 13                	jmp    8008b3 <vprintfmt+0x24b>
				putch(' ', putdat);
  8008a0:	83 ec 08             	sub    $0x8,%esp
  8008a3:	ff 75 0c             	pushl  0xc(%ebp)
  8008a6:	6a 20                	push   $0x20
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	ff d0                	call   *%eax
  8008ad:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008b0:	ff 4d e4             	decl   -0x1c(%ebp)
  8008b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b7:	7f e7                	jg     8008a0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8008b9:	e9 78 01 00 00       	jmp    800a36 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008be:	83 ec 08             	sub    $0x8,%esp
  8008c1:	ff 75 e8             	pushl  -0x18(%ebp)
  8008c4:	8d 45 14             	lea    0x14(%ebp),%eax
  8008c7:	50                   	push   %eax
  8008c8:	e8 3c fd ff ff       	call   800609 <getint>
  8008cd:	83 c4 10             	add    $0x10,%esp
  8008d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008dc:	85 d2                	test   %edx,%edx
  8008de:	79 23                	jns    800903 <vprintfmt+0x29b>
				putch('-', putdat);
  8008e0:	83 ec 08             	sub    $0x8,%esp
  8008e3:	ff 75 0c             	pushl  0xc(%ebp)
  8008e6:	6a 2d                	push   $0x2d
  8008e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008eb:	ff d0                	call   *%eax
  8008ed:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008f6:	f7 d8                	neg    %eax
  8008f8:	83 d2 00             	adc    $0x0,%edx
  8008fb:	f7 da                	neg    %edx
  8008fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800900:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800903:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80090a:	e9 bc 00 00 00       	jmp    8009cb <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	ff 75 e8             	pushl  -0x18(%ebp)
  800915:	8d 45 14             	lea    0x14(%ebp),%eax
  800918:	50                   	push   %eax
  800919:	e8 84 fc ff ff       	call   8005a2 <getuint>
  80091e:	83 c4 10             	add    $0x10,%esp
  800921:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800924:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800927:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80092e:	e9 98 00 00 00       	jmp    8009cb <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800933:	83 ec 08             	sub    $0x8,%esp
  800936:	ff 75 0c             	pushl  0xc(%ebp)
  800939:	6a 58                	push   $0x58
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	ff d0                	call   *%eax
  800940:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800943:	83 ec 08             	sub    $0x8,%esp
  800946:	ff 75 0c             	pushl  0xc(%ebp)
  800949:	6a 58                	push   $0x58
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	ff d0                	call   *%eax
  800950:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800953:	83 ec 08             	sub    $0x8,%esp
  800956:	ff 75 0c             	pushl  0xc(%ebp)
  800959:	6a 58                	push   $0x58
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	ff d0                	call   *%eax
  800960:	83 c4 10             	add    $0x10,%esp
			break;
  800963:	e9 ce 00 00 00       	jmp    800a36 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800968:	83 ec 08             	sub    $0x8,%esp
  80096b:	ff 75 0c             	pushl  0xc(%ebp)
  80096e:	6a 30                	push   $0x30
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	ff d0                	call   *%eax
  800975:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	ff 75 0c             	pushl  0xc(%ebp)
  80097e:	6a 78                	push   $0x78
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	ff d0                	call   *%eax
  800985:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800988:	8b 45 14             	mov    0x14(%ebp),%eax
  80098b:	83 c0 04             	add    $0x4,%eax
  80098e:	89 45 14             	mov    %eax,0x14(%ebp)
  800991:	8b 45 14             	mov    0x14(%ebp),%eax
  800994:	83 e8 04             	sub    $0x4,%eax
  800997:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800999:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8009a3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8009aa:	eb 1f                	jmp    8009cb <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8009ac:	83 ec 08             	sub    $0x8,%esp
  8009af:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b2:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b5:	50                   	push   %eax
  8009b6:	e8 e7 fb ff ff       	call   8005a2 <getuint>
  8009bb:	83 c4 10             	add    $0x10,%esp
  8009be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009c4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009cb:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009d2:	83 ec 04             	sub    $0x4,%esp
  8009d5:	52                   	push   %edx
  8009d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009d9:	50                   	push   %eax
  8009da:	ff 75 f4             	pushl  -0xc(%ebp)
  8009dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8009e0:	ff 75 0c             	pushl  0xc(%ebp)
  8009e3:	ff 75 08             	pushl  0x8(%ebp)
  8009e6:	e8 00 fb ff ff       	call   8004eb <printnum>
  8009eb:	83 c4 20             	add    $0x20,%esp
			break;
  8009ee:	eb 46                	jmp    800a36 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 0c             	pushl  0xc(%ebp)
  8009f6:	53                   	push   %ebx
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	ff d0                	call   *%eax
  8009fc:	83 c4 10             	add    $0x10,%esp
			break;
  8009ff:	eb 35                	jmp    800a36 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a01:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800a08:	eb 2c                	jmp    800a36 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a0a:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800a11:	eb 23                	jmp    800a36 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 0c             	pushl  0xc(%ebp)
  800a19:	6a 25                	push   $0x25
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	ff d0                	call   *%eax
  800a20:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a23:	ff 4d 10             	decl   0x10(%ebp)
  800a26:	eb 03                	jmp    800a2b <vprintfmt+0x3c3>
  800a28:	ff 4d 10             	decl   0x10(%ebp)
  800a2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2e:	48                   	dec    %eax
  800a2f:	8a 00                	mov    (%eax),%al
  800a31:	3c 25                	cmp    $0x25,%al
  800a33:	75 f3                	jne    800a28 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a35:	90                   	nop
		}
	}
  800a36:	e9 35 fc ff ff       	jmp    800670 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a3b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a3f:	5b                   	pop    %ebx
  800a40:	5e                   	pop    %esi
  800a41:	5d                   	pop    %ebp
  800a42:	c3                   	ret    

00800a43 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a49:	8d 45 10             	lea    0x10(%ebp),%eax
  800a4c:	83 c0 04             	add    $0x4,%eax
  800a4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a52:	8b 45 10             	mov    0x10(%ebp),%eax
  800a55:	ff 75 f4             	pushl  -0xc(%ebp)
  800a58:	50                   	push   %eax
  800a59:	ff 75 0c             	pushl  0xc(%ebp)
  800a5c:	ff 75 08             	pushl  0x8(%ebp)
  800a5f:	e8 04 fc ff ff       	call   800668 <vprintfmt>
  800a64:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a67:	90                   	nop
  800a68:	c9                   	leave  
  800a69:	c3                   	ret    

00800a6a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a70:	8b 40 08             	mov    0x8(%eax),%eax
  800a73:	8d 50 01             	lea    0x1(%eax),%edx
  800a76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a79:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7f:	8b 10                	mov    (%eax),%edx
  800a81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a84:	8b 40 04             	mov    0x4(%eax),%eax
  800a87:	39 c2                	cmp    %eax,%edx
  800a89:	73 12                	jae    800a9d <sprintputch+0x33>
		*b->buf++ = ch;
  800a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8e:	8b 00                	mov    (%eax),%eax
  800a90:	8d 48 01             	lea    0x1(%eax),%ecx
  800a93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a96:	89 0a                	mov    %ecx,(%edx)
  800a98:	8b 55 08             	mov    0x8(%ebp),%edx
  800a9b:	88 10                	mov    %dl,(%eax)
}
  800a9d:	90                   	nop
  800a9e:	5d                   	pop    %ebp
  800a9f:	c3                   	ret    

00800aa0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
  800aa3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800aac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aaf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	01 d0                	add    %edx,%eax
  800ab7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ac1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ac5:	74 06                	je     800acd <vsnprintf+0x2d>
  800ac7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800acb:	7f 07                	jg     800ad4 <vsnprintf+0x34>
		return -E_INVAL;
  800acd:	b8 03 00 00 00       	mov    $0x3,%eax
  800ad2:	eb 20                	jmp    800af4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ad4:	ff 75 14             	pushl  0x14(%ebp)
  800ad7:	ff 75 10             	pushl  0x10(%ebp)
  800ada:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800add:	50                   	push   %eax
  800ade:	68 6a 0a 80 00       	push   $0x800a6a
  800ae3:	e8 80 fb ff ff       	call   800668 <vprintfmt>
  800ae8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800aeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aee:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800af4:	c9                   	leave  
  800af5:	c3                   	ret    

00800af6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800afc:	8d 45 10             	lea    0x10(%ebp),%eax
  800aff:	83 c0 04             	add    $0x4,%eax
  800b02:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b05:	8b 45 10             	mov    0x10(%ebp),%eax
  800b08:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0b:	50                   	push   %eax
  800b0c:	ff 75 0c             	pushl  0xc(%ebp)
  800b0f:	ff 75 08             	pushl  0x8(%ebp)
  800b12:	e8 89 ff ff ff       	call   800aa0 <vsnprintf>
  800b17:	83 c4 10             	add    $0x10,%esp
  800b1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b20:	c9                   	leave  
  800b21:	c3                   	ret    

00800b22 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b2f:	eb 06                	jmp    800b37 <strlen+0x15>
		n++;
  800b31:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b34:	ff 45 08             	incl   0x8(%ebp)
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	8a 00                	mov    (%eax),%al
  800b3c:	84 c0                	test   %al,%al
  800b3e:	75 f1                	jne    800b31 <strlen+0xf>
		n++;
	return n;
  800b40:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b43:	c9                   	leave  
  800b44:	c3                   	ret    

00800b45 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b4b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b52:	eb 09                	jmp    800b5d <strnlen+0x18>
		n++;
  800b54:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b57:	ff 45 08             	incl   0x8(%ebp)
  800b5a:	ff 4d 0c             	decl   0xc(%ebp)
  800b5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b61:	74 09                	je     800b6c <strnlen+0x27>
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8a 00                	mov    (%eax),%al
  800b68:	84 c0                	test   %al,%al
  800b6a:	75 e8                	jne    800b54 <strnlen+0xf>
		n++;
	return n;
  800b6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b6f:	c9                   	leave  
  800b70:	c3                   	ret    

00800b71 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b7d:	90                   	nop
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	8d 50 01             	lea    0x1(%eax),%edx
  800b84:	89 55 08             	mov    %edx,0x8(%ebp)
  800b87:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b8a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b8d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b90:	8a 12                	mov    (%edx),%dl
  800b92:	88 10                	mov    %dl,(%eax)
  800b94:	8a 00                	mov    (%eax),%al
  800b96:	84 c0                	test   %al,%al
  800b98:	75 e4                	jne    800b7e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b9d:	c9                   	leave  
  800b9e:	c3                   	ret    

00800b9f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800bab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb2:	eb 1f                	jmp    800bd3 <strncpy+0x34>
		*dst++ = *src;
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	8d 50 01             	lea    0x1(%eax),%edx
  800bba:	89 55 08             	mov    %edx,0x8(%ebp)
  800bbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc0:	8a 12                	mov    (%edx),%dl
  800bc2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc7:	8a 00                	mov    (%eax),%al
  800bc9:	84 c0                	test   %al,%al
  800bcb:	74 03                	je     800bd0 <strncpy+0x31>
			src++;
  800bcd:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bd0:	ff 45 fc             	incl   -0x4(%ebp)
  800bd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bd6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bd9:	72 d9                	jb     800bb4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800bdb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bde:	c9                   	leave  
  800bdf:	c3                   	ret    

00800be0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bf0:	74 30                	je     800c22 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bf2:	eb 16                	jmp    800c0a <strlcpy+0x2a>
			*dst++ = *src++;
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8d 50 01             	lea    0x1(%eax),%edx
  800bfa:	89 55 08             	mov    %edx,0x8(%ebp)
  800bfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c00:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c03:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c06:	8a 12                	mov    (%edx),%dl
  800c08:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c0a:	ff 4d 10             	decl   0x10(%ebp)
  800c0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c11:	74 09                	je     800c1c <strlcpy+0x3c>
  800c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c16:	8a 00                	mov    (%eax),%al
  800c18:	84 c0                	test   %al,%al
  800c1a:	75 d8                	jne    800bf4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c22:	8b 55 08             	mov    0x8(%ebp),%edx
  800c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c28:	29 c2                	sub    %eax,%edx
  800c2a:	89 d0                	mov    %edx,%eax
}
  800c2c:	c9                   	leave  
  800c2d:	c3                   	ret    

00800c2e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c31:	eb 06                	jmp    800c39 <strcmp+0xb>
		p++, q++;
  800c33:	ff 45 08             	incl   0x8(%ebp)
  800c36:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	8a 00                	mov    (%eax),%al
  800c3e:	84 c0                	test   %al,%al
  800c40:	74 0e                	je     800c50 <strcmp+0x22>
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	8a 10                	mov    (%eax),%dl
  800c47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4a:	8a 00                	mov    (%eax),%al
  800c4c:	38 c2                	cmp    %al,%dl
  800c4e:	74 e3                	je     800c33 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	8a 00                	mov    (%eax),%al
  800c55:	0f b6 d0             	movzbl %al,%edx
  800c58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5b:	8a 00                	mov    (%eax),%al
  800c5d:	0f b6 c0             	movzbl %al,%eax
  800c60:	29 c2                	sub    %eax,%edx
  800c62:	89 d0                	mov    %edx,%eax
}
  800c64:	5d                   	pop    %ebp
  800c65:	c3                   	ret    

00800c66 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c69:	eb 09                	jmp    800c74 <strncmp+0xe>
		n--, p++, q++;
  800c6b:	ff 4d 10             	decl   0x10(%ebp)
  800c6e:	ff 45 08             	incl   0x8(%ebp)
  800c71:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c78:	74 17                	je     800c91 <strncmp+0x2b>
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	8a 00                	mov    (%eax),%al
  800c7f:	84 c0                	test   %al,%al
  800c81:	74 0e                	je     800c91 <strncmp+0x2b>
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	8a 10                	mov    (%eax),%dl
  800c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8b:	8a 00                	mov    (%eax),%al
  800c8d:	38 c2                	cmp    %al,%dl
  800c8f:	74 da                	je     800c6b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c95:	75 07                	jne    800c9e <strncmp+0x38>
		return 0;
  800c97:	b8 00 00 00 00       	mov    $0x0,%eax
  800c9c:	eb 14                	jmp    800cb2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	0f b6 d0             	movzbl %al,%edx
  800ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca9:	8a 00                	mov    (%eax),%al
  800cab:	0f b6 c0             	movzbl %al,%eax
  800cae:	29 c2                	sub    %eax,%edx
  800cb0:	89 d0                	mov    %edx,%eax
}
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    

00800cb4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	83 ec 04             	sub    $0x4,%esp
  800cba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cc0:	eb 12                	jmp    800cd4 <strchr+0x20>
		if (*s == c)
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	8a 00                	mov    (%eax),%al
  800cc7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cca:	75 05                	jne    800cd1 <strchr+0x1d>
			return (char *) s;
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	eb 11                	jmp    800ce2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cd1:	ff 45 08             	incl   0x8(%ebp)
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	8a 00                	mov    (%eax),%al
  800cd9:	84 c0                	test   %al,%al
  800cdb:	75 e5                	jne    800cc2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ce2:	c9                   	leave  
  800ce3:	c3                   	ret    

00800ce4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	83 ec 04             	sub    $0x4,%esp
  800cea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ced:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cf0:	eb 0d                	jmp    800cff <strfind+0x1b>
		if (*s == c)
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	8a 00                	mov    (%eax),%al
  800cf7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cfa:	74 0e                	je     800d0a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cfc:	ff 45 08             	incl   0x8(%ebp)
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8a 00                	mov    (%eax),%al
  800d04:	84 c0                	test   %al,%al
  800d06:	75 ea                	jne    800cf2 <strfind+0xe>
  800d08:	eb 01                	jmp    800d0b <strfind+0x27>
		if (*s == c)
			break;
  800d0a:	90                   	nop
	return (char *) s;
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d0e:	c9                   	leave  
  800d0f:	c3                   	ret    

00800d10 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
  800d13:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d22:	eb 0e                	jmp    800d32 <memset+0x22>
		*p++ = c;
  800d24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d27:	8d 50 01             	lea    0x1(%eax),%edx
  800d2a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d30:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d32:	ff 4d f8             	decl   -0x8(%ebp)
  800d35:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d39:	79 e9                	jns    800d24 <memset+0x14>
		*p++ = c;

	return v;
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d3e:	c9                   	leave  
  800d3f:	c3                   	ret    

00800d40 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d52:	eb 16                	jmp    800d6a <memcpy+0x2a>
		*d++ = *s++;
  800d54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d57:	8d 50 01             	lea    0x1(%eax),%edx
  800d5a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d5d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d60:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d63:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d66:	8a 12                	mov    (%edx),%dl
  800d68:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d70:	89 55 10             	mov    %edx,0x10(%ebp)
  800d73:	85 c0                	test   %eax,%eax
  800d75:	75 dd                	jne    800d54 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d7a:	c9                   	leave  
  800d7b:	c3                   	ret    

00800d7c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d7c:	55                   	push   %ebp
  800d7d:	89 e5                	mov    %esp,%ebp
  800d7f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d91:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d94:	73 50                	jae    800de6 <memmove+0x6a>
  800d96:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d99:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9c:	01 d0                	add    %edx,%eax
  800d9e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800da1:	76 43                	jbe    800de6 <memmove+0x6a>
		s += n;
  800da3:	8b 45 10             	mov    0x10(%ebp),%eax
  800da6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800da9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dac:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800daf:	eb 10                	jmp    800dc1 <memmove+0x45>
			*--d = *--s;
  800db1:	ff 4d f8             	decl   -0x8(%ebp)
  800db4:	ff 4d fc             	decl   -0x4(%ebp)
  800db7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dba:	8a 10                	mov    (%eax),%dl
  800dbc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dbf:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800dc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc7:	89 55 10             	mov    %edx,0x10(%ebp)
  800dca:	85 c0                	test   %eax,%eax
  800dcc:	75 e3                	jne    800db1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dce:	eb 23                	jmp    800df3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800dd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd3:	8d 50 01             	lea    0x1(%eax),%edx
  800dd6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dd9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ddc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ddf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800de2:	8a 12                	mov    (%edx),%dl
  800de4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800de6:	8b 45 10             	mov    0x10(%ebp),%eax
  800de9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dec:	89 55 10             	mov    %edx,0x10(%ebp)
  800def:	85 c0                	test   %eax,%eax
  800df1:	75 dd                	jne    800dd0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df6:	c9                   	leave  
  800df7:	c3                   	ret    

00800df8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e07:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e0a:	eb 2a                	jmp    800e36 <memcmp+0x3e>
		if (*s1 != *s2)
  800e0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0f:	8a 10                	mov    (%eax),%dl
  800e11:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e14:	8a 00                	mov    (%eax),%al
  800e16:	38 c2                	cmp    %al,%dl
  800e18:	74 16                	je     800e30 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1d:	8a 00                	mov    (%eax),%al
  800e1f:	0f b6 d0             	movzbl %al,%edx
  800e22:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e25:	8a 00                	mov    (%eax),%al
  800e27:	0f b6 c0             	movzbl %al,%eax
  800e2a:	29 c2                	sub    %eax,%edx
  800e2c:	89 d0                	mov    %edx,%eax
  800e2e:	eb 18                	jmp    800e48 <memcmp+0x50>
		s1++, s2++;
  800e30:	ff 45 fc             	incl   -0x4(%ebp)
  800e33:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e36:	8b 45 10             	mov    0x10(%ebp),%eax
  800e39:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e3c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e3f:	85 c0                	test   %eax,%eax
  800e41:	75 c9                	jne    800e0c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e48:	c9                   	leave  
  800e49:	c3                   	ret    

00800e4a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e50:	8b 55 08             	mov    0x8(%ebp),%edx
  800e53:	8b 45 10             	mov    0x10(%ebp),%eax
  800e56:	01 d0                	add    %edx,%eax
  800e58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e5b:	eb 15                	jmp    800e72 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	8a 00                	mov    (%eax),%al
  800e62:	0f b6 d0             	movzbl %al,%edx
  800e65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e68:	0f b6 c0             	movzbl %al,%eax
  800e6b:	39 c2                	cmp    %eax,%edx
  800e6d:	74 0d                	je     800e7c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e6f:	ff 45 08             	incl   0x8(%ebp)
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
  800e75:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e78:	72 e3                	jb     800e5d <memfind+0x13>
  800e7a:	eb 01                	jmp    800e7d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e7c:	90                   	nop
	return (void *) s;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e80:	c9                   	leave  
  800e81:	c3                   	ret    

00800e82 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e8f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e96:	eb 03                	jmp    800e9b <strtol+0x19>
		s++;
  800e98:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	8a 00                	mov    (%eax),%al
  800ea0:	3c 20                	cmp    $0x20,%al
  800ea2:	74 f4                	je     800e98 <strtol+0x16>
  800ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea7:	8a 00                	mov    (%eax),%al
  800ea9:	3c 09                	cmp    $0x9,%al
  800eab:	74 eb                	je     800e98 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	3c 2b                	cmp    $0x2b,%al
  800eb4:	75 05                	jne    800ebb <strtol+0x39>
		s++;
  800eb6:	ff 45 08             	incl   0x8(%ebp)
  800eb9:	eb 13                	jmp    800ece <strtol+0x4c>
	else if (*s == '-')
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	8a 00                	mov    (%eax),%al
  800ec0:	3c 2d                	cmp    $0x2d,%al
  800ec2:	75 0a                	jne    800ece <strtol+0x4c>
		s++, neg = 1;
  800ec4:	ff 45 08             	incl   0x8(%ebp)
  800ec7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ece:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed2:	74 06                	je     800eda <strtol+0x58>
  800ed4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ed8:	75 20                	jne    800efa <strtol+0x78>
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	8a 00                	mov    (%eax),%al
  800edf:	3c 30                	cmp    $0x30,%al
  800ee1:	75 17                	jne    800efa <strtol+0x78>
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	40                   	inc    %eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	3c 78                	cmp    $0x78,%al
  800eeb:	75 0d                	jne    800efa <strtol+0x78>
		s += 2, base = 16;
  800eed:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ef1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ef8:	eb 28                	jmp    800f22 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800efa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800efe:	75 15                	jne    800f15 <strtol+0x93>
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	8a 00                	mov    (%eax),%al
  800f05:	3c 30                	cmp    $0x30,%al
  800f07:	75 0c                	jne    800f15 <strtol+0x93>
		s++, base = 8;
  800f09:	ff 45 08             	incl   0x8(%ebp)
  800f0c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f13:	eb 0d                	jmp    800f22 <strtol+0xa0>
	else if (base == 0)
  800f15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f19:	75 07                	jne    800f22 <strtol+0xa0>
		base = 10;
  800f1b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	8a 00                	mov    (%eax),%al
  800f27:	3c 2f                	cmp    $0x2f,%al
  800f29:	7e 19                	jle    800f44 <strtol+0xc2>
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	8a 00                	mov    (%eax),%al
  800f30:	3c 39                	cmp    $0x39,%al
  800f32:	7f 10                	jg     800f44 <strtol+0xc2>
			dig = *s - '0';
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	8a 00                	mov    (%eax),%al
  800f39:	0f be c0             	movsbl %al,%eax
  800f3c:	83 e8 30             	sub    $0x30,%eax
  800f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f42:	eb 42                	jmp    800f86 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	8a 00                	mov    (%eax),%al
  800f49:	3c 60                	cmp    $0x60,%al
  800f4b:	7e 19                	jle    800f66 <strtol+0xe4>
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	8a 00                	mov    (%eax),%al
  800f52:	3c 7a                	cmp    $0x7a,%al
  800f54:	7f 10                	jg     800f66 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	0f be c0             	movsbl %al,%eax
  800f5e:	83 e8 57             	sub    $0x57,%eax
  800f61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f64:	eb 20                	jmp    800f86 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	3c 40                	cmp    $0x40,%al
  800f6d:	7e 39                	jle    800fa8 <strtol+0x126>
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3c 5a                	cmp    $0x5a,%al
  800f76:	7f 30                	jg     800fa8 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7b:	8a 00                	mov    (%eax),%al
  800f7d:	0f be c0             	movsbl %al,%eax
  800f80:	83 e8 37             	sub    $0x37,%eax
  800f83:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f89:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f8c:	7d 19                	jge    800fa7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f8e:	ff 45 08             	incl   0x8(%ebp)
  800f91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f94:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f98:	89 c2                	mov    %eax,%edx
  800f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f9d:	01 d0                	add    %edx,%eax
  800f9f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800fa2:	e9 7b ff ff ff       	jmp    800f22 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800fa7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800fa8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fac:	74 08                	je     800fb6 <strtol+0x134>
		*endptr = (char *) s;
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800fb6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fba:	74 07                	je     800fc3 <strtol+0x141>
  800fbc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fbf:	f7 d8                	neg    %eax
  800fc1:	eb 03                	jmp    800fc6 <strtol+0x144>
  800fc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fc6:	c9                   	leave  
  800fc7:	c3                   	ret    

00800fc8 <ltostr>:

void
ltostr(long value, char *str)
{
  800fc8:	55                   	push   %ebp
  800fc9:	89 e5                	mov    %esp,%ebp
  800fcb:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fd5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fe0:	79 13                	jns    800ff5 <ltostr+0x2d>
	{
		neg = 1;
  800fe2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fec:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fef:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ff2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ffd:	99                   	cltd   
  800ffe:	f7 f9                	idiv   %ecx
  801000:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801003:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801006:	8d 50 01             	lea    0x1(%eax),%edx
  801009:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80100c:	89 c2                	mov    %eax,%edx
  80100e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801011:	01 d0                	add    %edx,%eax
  801013:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801016:	83 c2 30             	add    $0x30,%edx
  801019:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80101b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80101e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801023:	f7 e9                	imul   %ecx
  801025:	c1 fa 02             	sar    $0x2,%edx
  801028:	89 c8                	mov    %ecx,%eax
  80102a:	c1 f8 1f             	sar    $0x1f,%eax
  80102d:	29 c2                	sub    %eax,%edx
  80102f:	89 d0                	mov    %edx,%eax
  801031:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801034:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801038:	75 bb                	jne    800ff5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80103a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801041:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801044:	48                   	dec    %eax
  801045:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801048:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80104c:	74 3d                	je     80108b <ltostr+0xc3>
		start = 1 ;
  80104e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801055:	eb 34                	jmp    80108b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801057:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80105a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105d:	01 d0                	add    %edx,%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801064:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801067:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106a:	01 c2                	add    %eax,%edx
  80106c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80106f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801072:	01 c8                	add    %ecx,%eax
  801074:	8a 00                	mov    (%eax),%al
  801076:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801078:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80107b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107e:	01 c2                	add    %eax,%edx
  801080:	8a 45 eb             	mov    -0x15(%ebp),%al
  801083:	88 02                	mov    %al,(%edx)
		start++ ;
  801085:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801088:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80108b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80108e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801091:	7c c4                	jl     801057 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801093:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801096:	8b 45 0c             	mov    0xc(%ebp),%eax
  801099:	01 d0                	add    %edx,%eax
  80109b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80109e:	90                   	nop
  80109f:	c9                   	leave  
  8010a0:	c3                   	ret    

008010a1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8010a7:	ff 75 08             	pushl  0x8(%ebp)
  8010aa:	e8 73 fa ff ff       	call   800b22 <strlen>
  8010af:	83 c4 04             	add    $0x4,%esp
  8010b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8010b5:	ff 75 0c             	pushl  0xc(%ebp)
  8010b8:	e8 65 fa ff ff       	call   800b22 <strlen>
  8010bd:	83 c4 04             	add    $0x4,%esp
  8010c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010d1:	eb 17                	jmp    8010ea <strcconcat+0x49>
		final[s] = str1[s] ;
  8010d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d9:	01 c2                	add    %eax,%edx
  8010db:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	01 c8                	add    %ecx,%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010e7:	ff 45 fc             	incl   -0x4(%ebp)
  8010ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ed:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010f0:	7c e1                	jl     8010d3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010f2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010f9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801100:	eb 1f                	jmp    801121 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801102:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801105:	8d 50 01             	lea    0x1(%eax),%edx
  801108:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80110b:	89 c2                	mov    %eax,%edx
  80110d:	8b 45 10             	mov    0x10(%ebp),%eax
  801110:	01 c2                	add    %eax,%edx
  801112:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801115:	8b 45 0c             	mov    0xc(%ebp),%eax
  801118:	01 c8                	add    %ecx,%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80111e:	ff 45 f8             	incl   -0x8(%ebp)
  801121:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801124:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801127:	7c d9                	jl     801102 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801129:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80112c:	8b 45 10             	mov    0x10(%ebp),%eax
  80112f:	01 d0                	add    %edx,%eax
  801131:	c6 00 00             	movb   $0x0,(%eax)
}
  801134:	90                   	nop
  801135:	c9                   	leave  
  801136:	c3                   	ret    

00801137 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80113a:	8b 45 14             	mov    0x14(%ebp),%eax
  80113d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801143:	8b 45 14             	mov    0x14(%ebp),%eax
  801146:	8b 00                	mov    (%eax),%eax
  801148:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80114f:	8b 45 10             	mov    0x10(%ebp),%eax
  801152:	01 d0                	add    %edx,%eax
  801154:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80115a:	eb 0c                	jmp    801168 <strsplit+0x31>
			*string++ = 0;
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	8d 50 01             	lea    0x1(%eax),%edx
  801162:	89 55 08             	mov    %edx,0x8(%ebp)
  801165:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	84 c0                	test   %al,%al
  80116f:	74 18                	je     801189 <strsplit+0x52>
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	8a 00                	mov    (%eax),%al
  801176:	0f be c0             	movsbl %al,%eax
  801179:	50                   	push   %eax
  80117a:	ff 75 0c             	pushl  0xc(%ebp)
  80117d:	e8 32 fb ff ff       	call   800cb4 <strchr>
  801182:	83 c4 08             	add    $0x8,%esp
  801185:	85 c0                	test   %eax,%eax
  801187:	75 d3                	jne    80115c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	84 c0                	test   %al,%al
  801190:	74 5a                	je     8011ec <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801192:	8b 45 14             	mov    0x14(%ebp),%eax
  801195:	8b 00                	mov    (%eax),%eax
  801197:	83 f8 0f             	cmp    $0xf,%eax
  80119a:	75 07                	jne    8011a3 <strsplit+0x6c>
		{
			return 0;
  80119c:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a1:	eb 66                	jmp    801209 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8011a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011a6:	8b 00                	mov    (%eax),%eax
  8011a8:	8d 48 01             	lea    0x1(%eax),%ecx
  8011ab:	8b 55 14             	mov    0x14(%ebp),%edx
  8011ae:	89 0a                	mov    %ecx,(%edx)
  8011b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ba:	01 c2                	add    %eax,%edx
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bf:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011c1:	eb 03                	jmp    8011c6 <strsplit+0x8f>
			string++;
  8011c3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	84 c0                	test   %al,%al
  8011cd:	74 8b                	je     80115a <strsplit+0x23>
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	0f be c0             	movsbl %al,%eax
  8011d7:	50                   	push   %eax
  8011d8:	ff 75 0c             	pushl  0xc(%ebp)
  8011db:	e8 d4 fa ff ff       	call   800cb4 <strchr>
  8011e0:	83 c4 08             	add    $0x8,%esp
  8011e3:	85 c0                	test   %eax,%eax
  8011e5:	74 dc                	je     8011c3 <strsplit+0x8c>
			string++;
	}
  8011e7:	e9 6e ff ff ff       	jmp    80115a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011ec:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f0:	8b 00                	mov    (%eax),%eax
  8011f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fc:	01 d0                	add    %edx,%eax
  8011fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801204:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801209:	c9                   	leave  
  80120a:	c3                   	ret    

0080120b <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801211:	83 ec 04             	sub    $0x4,%esp
  801214:	68 c8 21 80 00       	push   $0x8021c8
  801219:	68 3f 01 00 00       	push   $0x13f
  80121e:	68 ea 21 80 00       	push   $0x8021ea
  801223:	e8 a9 ef ff ff       	call   8001d1 <_panic>

00801228 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
  80122b:	57                   	push   %edi
  80122c:	56                   	push   %esi
  80122d:	53                   	push   %ebx
  80122e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8b 55 0c             	mov    0xc(%ebp),%edx
  801237:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80123a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80123d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801240:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801243:	cd 30                	int    $0x30
  801245:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801248:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80124b:	83 c4 10             	add    $0x10,%esp
  80124e:	5b                   	pop    %ebx
  80124f:	5e                   	pop    %esi
  801250:	5f                   	pop    %edi
  801251:	5d                   	pop    %ebp
  801252:	c3                   	ret    

00801253 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
  801256:	83 ec 04             	sub    $0x4,%esp
  801259:	8b 45 10             	mov    0x10(%ebp),%eax
  80125c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80125f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	6a 00                	push   $0x0
  801268:	6a 00                	push   $0x0
  80126a:	52                   	push   %edx
  80126b:	ff 75 0c             	pushl  0xc(%ebp)
  80126e:	50                   	push   %eax
  80126f:	6a 00                	push   $0x0
  801271:	e8 b2 ff ff ff       	call   801228 <syscall>
  801276:	83 c4 18             	add    $0x18,%esp
}
  801279:	90                   	nop
  80127a:	c9                   	leave  
  80127b:	c3                   	ret    

0080127c <sys_cgetc>:

int
sys_cgetc(void)
{
  80127c:	55                   	push   %ebp
  80127d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80127f:	6a 00                	push   $0x0
  801281:	6a 00                	push   $0x0
  801283:	6a 00                	push   $0x0
  801285:	6a 00                	push   $0x0
  801287:	6a 00                	push   $0x0
  801289:	6a 02                	push   $0x2
  80128b:	e8 98 ff ff ff       	call   801228 <syscall>
  801290:	83 c4 18             	add    $0x18,%esp
}
  801293:	c9                   	leave  
  801294:	c3                   	ret    

00801295 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801298:	6a 00                	push   $0x0
  80129a:	6a 00                	push   $0x0
  80129c:	6a 00                	push   $0x0
  80129e:	6a 00                	push   $0x0
  8012a0:	6a 00                	push   $0x0
  8012a2:	6a 03                	push   $0x3
  8012a4:	e8 7f ff ff ff       	call   801228 <syscall>
  8012a9:	83 c4 18             	add    $0x18,%esp
}
  8012ac:	90                   	nop
  8012ad:	c9                   	leave  
  8012ae:	c3                   	ret    

008012af <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8012b2:	6a 00                	push   $0x0
  8012b4:	6a 00                	push   $0x0
  8012b6:	6a 00                	push   $0x0
  8012b8:	6a 00                	push   $0x0
  8012ba:	6a 00                	push   $0x0
  8012bc:	6a 04                	push   $0x4
  8012be:	e8 65 ff ff ff       	call   801228 <syscall>
  8012c3:	83 c4 18             	add    $0x18,%esp
}
  8012c6:	90                   	nop
  8012c7:	c9                   	leave  
  8012c8:	c3                   	ret    

008012c9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012c9:	55                   	push   %ebp
  8012ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	6a 00                	push   $0x0
  8012d4:	6a 00                	push   $0x0
  8012d6:	6a 00                	push   $0x0
  8012d8:	52                   	push   %edx
  8012d9:	50                   	push   %eax
  8012da:	6a 08                	push   $0x8
  8012dc:	e8 47 ff ff ff       	call   801228 <syscall>
  8012e1:	83 c4 18             	add    $0x18,%esp
}
  8012e4:	c9                   	leave  
  8012e5:	c3                   	ret    

008012e6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	56                   	push   %esi
  8012ea:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012eb:	8b 75 18             	mov    0x18(%ebp),%esi
  8012ee:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	56                   	push   %esi
  8012fb:	53                   	push   %ebx
  8012fc:	51                   	push   %ecx
  8012fd:	52                   	push   %edx
  8012fe:	50                   	push   %eax
  8012ff:	6a 09                	push   $0x9
  801301:	e8 22 ff ff ff       	call   801228 <syscall>
  801306:	83 c4 18             	add    $0x18,%esp
}
  801309:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80130c:	5b                   	pop    %ebx
  80130d:	5e                   	pop    %esi
  80130e:	5d                   	pop    %ebp
  80130f:	c3                   	ret    

00801310 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801313:	8b 55 0c             	mov    0xc(%ebp),%edx
  801316:	8b 45 08             	mov    0x8(%ebp),%eax
  801319:	6a 00                	push   $0x0
  80131b:	6a 00                	push   $0x0
  80131d:	6a 00                	push   $0x0
  80131f:	52                   	push   %edx
  801320:	50                   	push   %eax
  801321:	6a 0a                	push   $0xa
  801323:	e8 00 ff ff ff       	call   801228 <syscall>
  801328:	83 c4 18             	add    $0x18,%esp
}
  80132b:	c9                   	leave  
  80132c:	c3                   	ret    

0080132d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801330:	6a 00                	push   $0x0
  801332:	6a 00                	push   $0x0
  801334:	6a 00                	push   $0x0
  801336:	ff 75 0c             	pushl  0xc(%ebp)
  801339:	ff 75 08             	pushl  0x8(%ebp)
  80133c:	6a 0b                	push   $0xb
  80133e:	e8 e5 fe ff ff       	call   801228 <syscall>
  801343:	83 c4 18             	add    $0x18,%esp
}
  801346:	c9                   	leave  
  801347:	c3                   	ret    

00801348 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	6a 00                	push   $0x0
  801355:	6a 0c                	push   $0xc
  801357:	e8 cc fe ff ff       	call   801228 <syscall>
  80135c:	83 c4 18             	add    $0x18,%esp
}
  80135f:	c9                   	leave  
  801360:	c3                   	ret    

00801361 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801364:	6a 00                	push   $0x0
  801366:	6a 00                	push   $0x0
  801368:	6a 00                	push   $0x0
  80136a:	6a 00                	push   $0x0
  80136c:	6a 00                	push   $0x0
  80136e:	6a 0d                	push   $0xd
  801370:	e8 b3 fe ff ff       	call   801228 <syscall>
  801375:	83 c4 18             	add    $0x18,%esp
}
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80137d:	6a 00                	push   $0x0
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	6a 0e                	push   $0xe
  801389:	e8 9a fe ff ff       	call   801228 <syscall>
  80138e:	83 c4 18             	add    $0x18,%esp
}
  801391:	c9                   	leave  
  801392:	c3                   	ret    

00801393 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801396:	6a 00                	push   $0x0
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 0f                	push   $0xf
  8013a2:	e8 81 fe ff ff       	call   801228 <syscall>
  8013a7:	83 c4 18             	add    $0x18,%esp
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	ff 75 08             	pushl  0x8(%ebp)
  8013ba:	6a 10                	push   $0x10
  8013bc:	e8 67 fe ff ff       	call   801228 <syscall>
  8013c1:	83 c4 18             	add    $0x18,%esp
}
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    

008013c6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 00                	push   $0x0
  8013d1:	6a 00                	push   $0x0
  8013d3:	6a 11                	push   $0x11
  8013d5:	e8 4e fe ff ff       	call   801228 <syscall>
  8013da:	83 c4 18             	add    $0x18,%esp
}
  8013dd:	90                   	nop
  8013de:	c9                   	leave  
  8013df:	c3                   	ret    

008013e0 <sys_cputc>:

void
sys_cputc(const char c)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
  8013e3:	83 ec 04             	sub    $0x4,%esp
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013ec:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	50                   	push   %eax
  8013f9:	6a 01                	push   $0x1
  8013fb:	e8 28 fe ff ff       	call   801228 <syscall>
  801400:	83 c4 18             	add    $0x18,%esp
}
  801403:	90                   	nop
  801404:	c9                   	leave  
  801405:	c3                   	ret    

00801406 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801409:	6a 00                	push   $0x0
  80140b:	6a 00                	push   $0x0
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	6a 00                	push   $0x0
  801413:	6a 14                	push   $0x14
  801415:	e8 0e fe ff ff       	call   801228 <syscall>
  80141a:	83 c4 18             	add    $0x18,%esp
}
  80141d:	90                   	nop
  80141e:	c9                   	leave  
  80141f:	c3                   	ret    

00801420 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
  801423:	83 ec 04             	sub    $0x4,%esp
  801426:	8b 45 10             	mov    0x10(%ebp),%eax
  801429:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80142c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80142f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	6a 00                	push   $0x0
  801438:	51                   	push   %ecx
  801439:	52                   	push   %edx
  80143a:	ff 75 0c             	pushl  0xc(%ebp)
  80143d:	50                   	push   %eax
  80143e:	6a 15                	push   $0x15
  801440:	e8 e3 fd ff ff       	call   801228 <syscall>
  801445:	83 c4 18             	add    $0x18,%esp
}
  801448:	c9                   	leave  
  801449:	c3                   	ret    

0080144a <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80144d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	6a 00                	push   $0x0
  801455:	6a 00                	push   $0x0
  801457:	6a 00                	push   $0x0
  801459:	52                   	push   %edx
  80145a:	50                   	push   %eax
  80145b:	6a 16                	push   $0x16
  80145d:	e8 c6 fd ff ff       	call   801228 <syscall>
  801462:	83 c4 18             	add    $0x18,%esp
}
  801465:	c9                   	leave  
  801466:	c3                   	ret    

00801467 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801467:	55                   	push   %ebp
  801468:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80146a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80146d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	51                   	push   %ecx
  801478:	52                   	push   %edx
  801479:	50                   	push   %eax
  80147a:	6a 17                	push   $0x17
  80147c:	e8 a7 fd ff ff       	call   801228 <syscall>
  801481:	83 c4 18             	add    $0x18,%esp
}
  801484:	c9                   	leave  
  801485:	c3                   	ret    

00801486 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801486:	55                   	push   %ebp
  801487:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801489:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	6a 00                	push   $0x0
  801491:	6a 00                	push   $0x0
  801493:	6a 00                	push   $0x0
  801495:	52                   	push   %edx
  801496:	50                   	push   %eax
  801497:	6a 18                	push   $0x18
  801499:	e8 8a fd ff ff       	call   801228 <syscall>
  80149e:	83 c4 18             	add    $0x18,%esp
}
  8014a1:	c9                   	leave  
  8014a2:	c3                   	ret    

008014a3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	6a 00                	push   $0x0
  8014ab:	ff 75 14             	pushl  0x14(%ebp)
  8014ae:	ff 75 10             	pushl  0x10(%ebp)
  8014b1:	ff 75 0c             	pushl  0xc(%ebp)
  8014b4:	50                   	push   %eax
  8014b5:	6a 19                	push   $0x19
  8014b7:	e8 6c fd ff ff       	call   801228 <syscall>
  8014bc:	83 c4 18             	add    $0x18,%esp
}
  8014bf:	c9                   	leave  
  8014c0:	c3                   	ret    

008014c1 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 00                	push   $0x0
  8014cf:	50                   	push   %eax
  8014d0:	6a 1a                	push   $0x1a
  8014d2:	e8 51 fd ff ff       	call   801228 <syscall>
  8014d7:	83 c4 18             	add    $0x18,%esp
}
  8014da:	90                   	nop
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    

008014dd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	50                   	push   %eax
  8014ec:	6a 1b                	push   $0x1b
  8014ee:	e8 35 fd ff ff       	call   801228 <syscall>
  8014f3:	83 c4 18             	add    $0x18,%esp
}
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 05                	push   $0x5
  801507:	e8 1c fd ff ff       	call   801228 <syscall>
  80150c:	83 c4 18             	add    $0x18,%esp
}
  80150f:	c9                   	leave  
  801510:	c3                   	ret    

00801511 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 06                	push   $0x6
  801520:	e8 03 fd ff ff       	call   801228 <syscall>
  801525:	83 c4 18             	add    $0x18,%esp
}
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 07                	push   $0x7
  801539:	e8 ea fc ff ff       	call   801228 <syscall>
  80153e:	83 c4 18             	add    $0x18,%esp
}
  801541:	c9                   	leave  
  801542:	c3                   	ret    

00801543 <sys_exit_env>:


void sys_exit_env(void)
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 1c                	push   $0x1c
  801552:	e8 d1 fc ff ff       	call   801228 <syscall>
  801557:	83 c4 18             	add    $0x18,%esp
}
  80155a:	90                   	nop
  80155b:	c9                   	leave  
  80155c:	c3                   	ret    

0080155d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80155d:	55                   	push   %ebp
  80155e:	89 e5                	mov    %esp,%ebp
  801560:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801563:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801566:	8d 50 04             	lea    0x4(%eax),%edx
  801569:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	52                   	push   %edx
  801573:	50                   	push   %eax
  801574:	6a 1d                	push   $0x1d
  801576:	e8 ad fc ff ff       	call   801228 <syscall>
  80157b:	83 c4 18             	add    $0x18,%esp
	return result;
  80157e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801581:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801584:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801587:	89 01                	mov    %eax,(%ecx)
  801589:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	c9                   	leave  
  801590:	c2 04 00             	ret    $0x4

00801593 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801593:	55                   	push   %ebp
  801594:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	ff 75 10             	pushl  0x10(%ebp)
  80159d:	ff 75 0c             	pushl  0xc(%ebp)
  8015a0:	ff 75 08             	pushl  0x8(%ebp)
  8015a3:	6a 13                	push   $0x13
  8015a5:	e8 7e fc ff ff       	call   801228 <syscall>
  8015aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8015ad:	90                   	nop
}
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <sys_rcr2>:
uint32 sys_rcr2()
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 1e                	push   $0x1e
  8015bf:	e8 64 fc ff ff       	call   801228 <syscall>
  8015c4:	83 c4 18             	add    $0x18,%esp
}
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	83 ec 04             	sub    $0x4,%esp
  8015cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015d5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	50                   	push   %eax
  8015e2:	6a 1f                	push   $0x1f
  8015e4:	e8 3f fc ff ff       	call   801228 <syscall>
  8015e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8015ec:	90                   	nop
}
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    

008015ef <rsttst>:
void rsttst()
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 21                	push   $0x21
  8015fe:	e8 25 fc ff ff       	call   801228 <syscall>
  801603:	83 c4 18             	add    $0x18,%esp
	return ;
  801606:	90                   	nop
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 04             	sub    $0x4,%esp
  80160f:	8b 45 14             	mov    0x14(%ebp),%eax
  801612:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801615:	8b 55 18             	mov    0x18(%ebp),%edx
  801618:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80161c:	52                   	push   %edx
  80161d:	50                   	push   %eax
  80161e:	ff 75 10             	pushl  0x10(%ebp)
  801621:	ff 75 0c             	pushl  0xc(%ebp)
  801624:	ff 75 08             	pushl  0x8(%ebp)
  801627:	6a 20                	push   $0x20
  801629:	e8 fa fb ff ff       	call   801228 <syscall>
  80162e:	83 c4 18             	add    $0x18,%esp
	return ;
  801631:	90                   	nop
}
  801632:	c9                   	leave  
  801633:	c3                   	ret    

00801634 <chktst>:
void chktst(uint32 n)
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	ff 75 08             	pushl  0x8(%ebp)
  801642:	6a 22                	push   $0x22
  801644:	e8 df fb ff ff       	call   801228 <syscall>
  801649:	83 c4 18             	add    $0x18,%esp
	return ;
  80164c:	90                   	nop
}
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <inctst>:

void inctst()
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 23                	push   $0x23
  80165e:	e8 c5 fb ff ff       	call   801228 <syscall>
  801663:	83 c4 18             	add    $0x18,%esp
	return ;
  801666:	90                   	nop
}
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <gettst>:
uint32 gettst()
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 24                	push   $0x24
  801678:	e8 ab fb ff ff       	call   801228 <syscall>
  80167d:	83 c4 18             	add    $0x18,%esp
}
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
  801685:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 25                	push   $0x25
  801694:	e8 8f fb ff ff       	call   801228 <syscall>
  801699:	83 c4 18             	add    $0x18,%esp
  80169c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80169f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8016a3:	75 07                	jne    8016ac <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8016a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8016aa:	eb 05                	jmp    8016b1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8016ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b1:	c9                   	leave  
  8016b2:	c3                   	ret    

008016b3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 25                	push   $0x25
  8016c5:	e8 5e fb ff ff       	call   801228 <syscall>
  8016ca:	83 c4 18             	add    $0x18,%esp
  8016cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016d0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016d4:	75 07                	jne    8016dd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8016db:	eb 05                	jmp    8016e2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
  8016e7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 25                	push   $0x25
  8016f6:	e8 2d fb ff ff       	call   801228 <syscall>
  8016fb:	83 c4 18             	add    $0x18,%esp
  8016fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801701:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801705:	75 07                	jne    80170e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801707:	b8 01 00 00 00       	mov    $0x1,%eax
  80170c:	eb 05                	jmp    801713 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80170e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801713:	c9                   	leave  
  801714:	c3                   	ret    

00801715 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
  801718:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 25                	push   $0x25
  801727:	e8 fc fa ff ff       	call   801228 <syscall>
  80172c:	83 c4 18             	add    $0x18,%esp
  80172f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801732:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801736:	75 07                	jne    80173f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801738:	b8 01 00 00 00       	mov    $0x1,%eax
  80173d:	eb 05                	jmp    801744 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80173f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	ff 75 08             	pushl  0x8(%ebp)
  801754:	6a 26                	push   $0x26
  801756:	e8 cd fa ff ff       	call   801228 <syscall>
  80175b:	83 c4 18             	add    $0x18,%esp
	return ;
  80175e:	90                   	nop
}
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
  801764:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801765:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801768:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80176b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
  801771:	6a 00                	push   $0x0
  801773:	53                   	push   %ebx
  801774:	51                   	push   %ecx
  801775:	52                   	push   %edx
  801776:	50                   	push   %eax
  801777:	6a 27                	push   $0x27
  801779:	e8 aa fa ff ff       	call   801228 <syscall>
  80177e:	83 c4 18             	add    $0x18,%esp
}
  801781:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801789:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	52                   	push   %edx
  801796:	50                   	push   %eax
  801797:	6a 28                	push   $0x28
  801799:	e8 8a fa ff ff       	call   801228 <syscall>
  80179e:	83 c4 18             	add    $0x18,%esp
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8017a6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	6a 00                	push   $0x0
  8017b1:	51                   	push   %ecx
  8017b2:	ff 75 10             	pushl  0x10(%ebp)
  8017b5:	52                   	push   %edx
  8017b6:	50                   	push   %eax
  8017b7:	6a 29                	push   $0x29
  8017b9:	e8 6a fa ff ff       	call   801228 <syscall>
  8017be:	83 c4 18             	add    $0x18,%esp
}
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	ff 75 10             	pushl  0x10(%ebp)
  8017cd:	ff 75 0c             	pushl  0xc(%ebp)
  8017d0:	ff 75 08             	pushl  0x8(%ebp)
  8017d3:	6a 12                	push   $0x12
  8017d5:	e8 4e fa ff ff       	call   801228 <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
	return ;
  8017dd:	90                   	nop
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8017e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	52                   	push   %edx
  8017f0:	50                   	push   %eax
  8017f1:	6a 2a                	push   $0x2a
  8017f3:	e8 30 fa ff ff       	call   801228 <syscall>
  8017f8:	83 c4 18             	add    $0x18,%esp
	return;
  8017fb:	90                   	nop
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801801:	8b 45 08             	mov    0x8(%ebp),%eax
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	50                   	push   %eax
  80180d:	6a 2b                	push   $0x2b
  80180f:	e8 14 fa ff ff       	call   801228 <syscall>
  801814:	83 c4 18             	add    $0x18,%esp
}
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	ff 75 0c             	pushl  0xc(%ebp)
  801825:	ff 75 08             	pushl  0x8(%ebp)
  801828:	6a 2c                	push   $0x2c
  80182a:	e8 f9 f9 ff ff       	call   801228 <syscall>
  80182f:	83 c4 18             	add    $0x18,%esp
	return;
  801832:	90                   	nop
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	ff 75 0c             	pushl  0xc(%ebp)
  801841:	ff 75 08             	pushl  0x8(%ebp)
  801844:	6a 2d                	push   $0x2d
  801846:	e8 dd f9 ff ff       	call   801228 <syscall>
  80184b:	83 c4 18             	add    $0x18,%esp
	return;
  80184e:	90                   	nop
}
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 2e                	push   $0x2e
  801863:	e8 c0 f9 ff ff       	call   801228 <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
  80186b:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  80186e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  801876:	8b 45 08             	mov    0x8(%ebp),%eax
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	50                   	push   %eax
  801882:	6a 2f                	push   $0x2f
  801884:	e8 9f f9 ff ff       	call   801228 <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
	return;
  80188c:	90                   	nop
}
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  801892:	8b 55 0c             	mov    0xc(%ebp),%edx
  801895:	8b 45 08             	mov    0x8(%ebp),%eax
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	52                   	push   %edx
  80189f:	50                   	push   %eax
  8018a0:	6a 30                	push   $0x30
  8018a2:	e8 81 f9 ff ff       	call   801228 <syscall>
  8018a7:	83 c4 18             	add    $0x18,%esp
	return;
  8018aa:	90                   	nop
}
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	50                   	push   %eax
  8018bf:	6a 31                	push   $0x31
  8018c1:	e8 62 f9 ff ff       	call   801228 <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
  8018c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  8018cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	50                   	push   %eax
  8018e0:	6a 32                	push   $0x32
  8018e2:	e8 41 f9 ff ff       	call   801228 <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
	return;
  8018ea:	90                   	nop
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    
  8018ed:	66 90                	xchg   %ax,%ax
  8018ef:	90                   	nop

008018f0 <__udivdi3>:
  8018f0:	55                   	push   %ebp
  8018f1:	57                   	push   %edi
  8018f2:	56                   	push   %esi
  8018f3:	53                   	push   %ebx
  8018f4:	83 ec 1c             	sub    $0x1c,%esp
  8018f7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8018fb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8018ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801903:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801907:	89 ca                	mov    %ecx,%edx
  801909:	89 f8                	mov    %edi,%eax
  80190b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80190f:	85 f6                	test   %esi,%esi
  801911:	75 2d                	jne    801940 <__udivdi3+0x50>
  801913:	39 cf                	cmp    %ecx,%edi
  801915:	77 65                	ja     80197c <__udivdi3+0x8c>
  801917:	89 fd                	mov    %edi,%ebp
  801919:	85 ff                	test   %edi,%edi
  80191b:	75 0b                	jne    801928 <__udivdi3+0x38>
  80191d:	b8 01 00 00 00       	mov    $0x1,%eax
  801922:	31 d2                	xor    %edx,%edx
  801924:	f7 f7                	div    %edi
  801926:	89 c5                	mov    %eax,%ebp
  801928:	31 d2                	xor    %edx,%edx
  80192a:	89 c8                	mov    %ecx,%eax
  80192c:	f7 f5                	div    %ebp
  80192e:	89 c1                	mov    %eax,%ecx
  801930:	89 d8                	mov    %ebx,%eax
  801932:	f7 f5                	div    %ebp
  801934:	89 cf                	mov    %ecx,%edi
  801936:	89 fa                	mov    %edi,%edx
  801938:	83 c4 1c             	add    $0x1c,%esp
  80193b:	5b                   	pop    %ebx
  80193c:	5e                   	pop    %esi
  80193d:	5f                   	pop    %edi
  80193e:	5d                   	pop    %ebp
  80193f:	c3                   	ret    
  801940:	39 ce                	cmp    %ecx,%esi
  801942:	77 28                	ja     80196c <__udivdi3+0x7c>
  801944:	0f bd fe             	bsr    %esi,%edi
  801947:	83 f7 1f             	xor    $0x1f,%edi
  80194a:	75 40                	jne    80198c <__udivdi3+0x9c>
  80194c:	39 ce                	cmp    %ecx,%esi
  80194e:	72 0a                	jb     80195a <__udivdi3+0x6a>
  801950:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801954:	0f 87 9e 00 00 00    	ja     8019f8 <__udivdi3+0x108>
  80195a:	b8 01 00 00 00       	mov    $0x1,%eax
  80195f:	89 fa                	mov    %edi,%edx
  801961:	83 c4 1c             	add    $0x1c,%esp
  801964:	5b                   	pop    %ebx
  801965:	5e                   	pop    %esi
  801966:	5f                   	pop    %edi
  801967:	5d                   	pop    %ebp
  801968:	c3                   	ret    
  801969:	8d 76 00             	lea    0x0(%esi),%esi
  80196c:	31 ff                	xor    %edi,%edi
  80196e:	31 c0                	xor    %eax,%eax
  801970:	89 fa                	mov    %edi,%edx
  801972:	83 c4 1c             	add    $0x1c,%esp
  801975:	5b                   	pop    %ebx
  801976:	5e                   	pop    %esi
  801977:	5f                   	pop    %edi
  801978:	5d                   	pop    %ebp
  801979:	c3                   	ret    
  80197a:	66 90                	xchg   %ax,%ax
  80197c:	89 d8                	mov    %ebx,%eax
  80197e:	f7 f7                	div    %edi
  801980:	31 ff                	xor    %edi,%edi
  801982:	89 fa                	mov    %edi,%edx
  801984:	83 c4 1c             	add    $0x1c,%esp
  801987:	5b                   	pop    %ebx
  801988:	5e                   	pop    %esi
  801989:	5f                   	pop    %edi
  80198a:	5d                   	pop    %ebp
  80198b:	c3                   	ret    
  80198c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801991:	89 eb                	mov    %ebp,%ebx
  801993:	29 fb                	sub    %edi,%ebx
  801995:	89 f9                	mov    %edi,%ecx
  801997:	d3 e6                	shl    %cl,%esi
  801999:	89 c5                	mov    %eax,%ebp
  80199b:	88 d9                	mov    %bl,%cl
  80199d:	d3 ed                	shr    %cl,%ebp
  80199f:	89 e9                	mov    %ebp,%ecx
  8019a1:	09 f1                	or     %esi,%ecx
  8019a3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8019a7:	89 f9                	mov    %edi,%ecx
  8019a9:	d3 e0                	shl    %cl,%eax
  8019ab:	89 c5                	mov    %eax,%ebp
  8019ad:	89 d6                	mov    %edx,%esi
  8019af:	88 d9                	mov    %bl,%cl
  8019b1:	d3 ee                	shr    %cl,%esi
  8019b3:	89 f9                	mov    %edi,%ecx
  8019b5:	d3 e2                	shl    %cl,%edx
  8019b7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019bb:	88 d9                	mov    %bl,%cl
  8019bd:	d3 e8                	shr    %cl,%eax
  8019bf:	09 c2                	or     %eax,%edx
  8019c1:	89 d0                	mov    %edx,%eax
  8019c3:	89 f2                	mov    %esi,%edx
  8019c5:	f7 74 24 0c          	divl   0xc(%esp)
  8019c9:	89 d6                	mov    %edx,%esi
  8019cb:	89 c3                	mov    %eax,%ebx
  8019cd:	f7 e5                	mul    %ebp
  8019cf:	39 d6                	cmp    %edx,%esi
  8019d1:	72 19                	jb     8019ec <__udivdi3+0xfc>
  8019d3:	74 0b                	je     8019e0 <__udivdi3+0xf0>
  8019d5:	89 d8                	mov    %ebx,%eax
  8019d7:	31 ff                	xor    %edi,%edi
  8019d9:	e9 58 ff ff ff       	jmp    801936 <__udivdi3+0x46>
  8019de:	66 90                	xchg   %ax,%ax
  8019e0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8019e4:	89 f9                	mov    %edi,%ecx
  8019e6:	d3 e2                	shl    %cl,%edx
  8019e8:	39 c2                	cmp    %eax,%edx
  8019ea:	73 e9                	jae    8019d5 <__udivdi3+0xe5>
  8019ec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8019ef:	31 ff                	xor    %edi,%edi
  8019f1:	e9 40 ff ff ff       	jmp    801936 <__udivdi3+0x46>
  8019f6:	66 90                	xchg   %ax,%ax
  8019f8:	31 c0                	xor    %eax,%eax
  8019fa:	e9 37 ff ff ff       	jmp    801936 <__udivdi3+0x46>
  8019ff:	90                   	nop

00801a00 <__umoddi3>:
  801a00:	55                   	push   %ebp
  801a01:	57                   	push   %edi
  801a02:	56                   	push   %esi
  801a03:	53                   	push   %ebx
  801a04:	83 ec 1c             	sub    $0x1c,%esp
  801a07:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a0b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a13:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a1b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a1f:	89 f3                	mov    %esi,%ebx
  801a21:	89 fa                	mov    %edi,%edx
  801a23:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a27:	89 34 24             	mov    %esi,(%esp)
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	75 1a                	jne    801a48 <__umoddi3+0x48>
  801a2e:	39 f7                	cmp    %esi,%edi
  801a30:	0f 86 a2 00 00 00    	jbe    801ad8 <__umoddi3+0xd8>
  801a36:	89 c8                	mov    %ecx,%eax
  801a38:	89 f2                	mov    %esi,%edx
  801a3a:	f7 f7                	div    %edi
  801a3c:	89 d0                	mov    %edx,%eax
  801a3e:	31 d2                	xor    %edx,%edx
  801a40:	83 c4 1c             	add    $0x1c,%esp
  801a43:	5b                   	pop    %ebx
  801a44:	5e                   	pop    %esi
  801a45:	5f                   	pop    %edi
  801a46:	5d                   	pop    %ebp
  801a47:	c3                   	ret    
  801a48:	39 f0                	cmp    %esi,%eax
  801a4a:	0f 87 ac 00 00 00    	ja     801afc <__umoddi3+0xfc>
  801a50:	0f bd e8             	bsr    %eax,%ebp
  801a53:	83 f5 1f             	xor    $0x1f,%ebp
  801a56:	0f 84 ac 00 00 00    	je     801b08 <__umoddi3+0x108>
  801a5c:	bf 20 00 00 00       	mov    $0x20,%edi
  801a61:	29 ef                	sub    %ebp,%edi
  801a63:	89 fe                	mov    %edi,%esi
  801a65:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a69:	89 e9                	mov    %ebp,%ecx
  801a6b:	d3 e0                	shl    %cl,%eax
  801a6d:	89 d7                	mov    %edx,%edi
  801a6f:	89 f1                	mov    %esi,%ecx
  801a71:	d3 ef                	shr    %cl,%edi
  801a73:	09 c7                	or     %eax,%edi
  801a75:	89 e9                	mov    %ebp,%ecx
  801a77:	d3 e2                	shl    %cl,%edx
  801a79:	89 14 24             	mov    %edx,(%esp)
  801a7c:	89 d8                	mov    %ebx,%eax
  801a7e:	d3 e0                	shl    %cl,%eax
  801a80:	89 c2                	mov    %eax,%edx
  801a82:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a86:	d3 e0                	shl    %cl,%eax
  801a88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a8c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a90:	89 f1                	mov    %esi,%ecx
  801a92:	d3 e8                	shr    %cl,%eax
  801a94:	09 d0                	or     %edx,%eax
  801a96:	d3 eb                	shr    %cl,%ebx
  801a98:	89 da                	mov    %ebx,%edx
  801a9a:	f7 f7                	div    %edi
  801a9c:	89 d3                	mov    %edx,%ebx
  801a9e:	f7 24 24             	mull   (%esp)
  801aa1:	89 c6                	mov    %eax,%esi
  801aa3:	89 d1                	mov    %edx,%ecx
  801aa5:	39 d3                	cmp    %edx,%ebx
  801aa7:	0f 82 87 00 00 00    	jb     801b34 <__umoddi3+0x134>
  801aad:	0f 84 91 00 00 00    	je     801b44 <__umoddi3+0x144>
  801ab3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ab7:	29 f2                	sub    %esi,%edx
  801ab9:	19 cb                	sbb    %ecx,%ebx
  801abb:	89 d8                	mov    %ebx,%eax
  801abd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ac1:	d3 e0                	shl    %cl,%eax
  801ac3:	89 e9                	mov    %ebp,%ecx
  801ac5:	d3 ea                	shr    %cl,%edx
  801ac7:	09 d0                	or     %edx,%eax
  801ac9:	89 e9                	mov    %ebp,%ecx
  801acb:	d3 eb                	shr    %cl,%ebx
  801acd:	89 da                	mov    %ebx,%edx
  801acf:	83 c4 1c             	add    $0x1c,%esp
  801ad2:	5b                   	pop    %ebx
  801ad3:	5e                   	pop    %esi
  801ad4:	5f                   	pop    %edi
  801ad5:	5d                   	pop    %ebp
  801ad6:	c3                   	ret    
  801ad7:	90                   	nop
  801ad8:	89 fd                	mov    %edi,%ebp
  801ada:	85 ff                	test   %edi,%edi
  801adc:	75 0b                	jne    801ae9 <__umoddi3+0xe9>
  801ade:	b8 01 00 00 00       	mov    $0x1,%eax
  801ae3:	31 d2                	xor    %edx,%edx
  801ae5:	f7 f7                	div    %edi
  801ae7:	89 c5                	mov    %eax,%ebp
  801ae9:	89 f0                	mov    %esi,%eax
  801aeb:	31 d2                	xor    %edx,%edx
  801aed:	f7 f5                	div    %ebp
  801aef:	89 c8                	mov    %ecx,%eax
  801af1:	f7 f5                	div    %ebp
  801af3:	89 d0                	mov    %edx,%eax
  801af5:	e9 44 ff ff ff       	jmp    801a3e <__umoddi3+0x3e>
  801afa:	66 90                	xchg   %ax,%ax
  801afc:	89 c8                	mov    %ecx,%eax
  801afe:	89 f2                	mov    %esi,%edx
  801b00:	83 c4 1c             	add    $0x1c,%esp
  801b03:	5b                   	pop    %ebx
  801b04:	5e                   	pop    %esi
  801b05:	5f                   	pop    %edi
  801b06:	5d                   	pop    %ebp
  801b07:	c3                   	ret    
  801b08:	3b 04 24             	cmp    (%esp),%eax
  801b0b:	72 06                	jb     801b13 <__umoddi3+0x113>
  801b0d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b11:	77 0f                	ja     801b22 <__umoddi3+0x122>
  801b13:	89 f2                	mov    %esi,%edx
  801b15:	29 f9                	sub    %edi,%ecx
  801b17:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b1b:	89 14 24             	mov    %edx,(%esp)
  801b1e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b22:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b26:	8b 14 24             	mov    (%esp),%edx
  801b29:	83 c4 1c             	add    $0x1c,%esp
  801b2c:	5b                   	pop    %ebx
  801b2d:	5e                   	pop    %esi
  801b2e:	5f                   	pop    %edi
  801b2f:	5d                   	pop    %ebp
  801b30:	c3                   	ret    
  801b31:	8d 76 00             	lea    0x0(%esi),%esi
  801b34:	2b 04 24             	sub    (%esp),%eax
  801b37:	19 fa                	sbb    %edi,%edx
  801b39:	89 d1                	mov    %edx,%ecx
  801b3b:	89 c6                	mov    %eax,%esi
  801b3d:	e9 71 ff ff ff       	jmp    801ab3 <__umoddi3+0xb3>
  801b42:	66 90                	xchg   %ax,%ax
  801b44:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b48:	72 ea                	jb     801b34 <__umoddi3+0x134>
  801b4a:	89 d9                	mov    %ebx,%ecx
  801b4c:	e9 62 ff ff ff       	jmp    801ab3 <__umoddi3+0xb3>
