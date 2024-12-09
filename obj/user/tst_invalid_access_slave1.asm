
obj/user/tst_invalid_access_slave1:     file format elf32-i386


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
	//[1] Kernel address
	uint32 *ptr = (uint32*)(KERN_STACK_TOP - 12) ;
  80003e:	c7 45 f4 f4 ff bf ef 	movl   $0xefbffff4,-0xc(%ebp)
	*ptr = 100 ;
  800045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800048:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	inctst();
  80004e:	e8 d1 15 00 00       	call   801624 <inctst>
	panic("tst invalid access failed:Attempt to access kernel location.\nThe env must be killed and shouldn't return here.");
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	68 40 1b 80 00       	push   $0x801b40
  80005b:	6a 0e                	push   $0xe
  80005d:	68 b0 1b 80 00       	push   $0x801bb0
  800062:	e8 3f 01 00 00       	call   8001a6 <_panic>

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
  80006d:	e8 74 14 00 00       	call   8014e6 <sys_getenvindex>
  800072:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800075:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800078:	89 d0                	mov    %edx,%eax
  80007a:	c1 e0 03             	shl    $0x3,%eax
  80007d:	01 d0                	add    %edx,%eax
  80007f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800086:	01 c8                	add    %ecx,%eax
  800088:	01 c0                	add    %eax,%eax
  80008a:	01 d0                	add    %edx,%eax
  80008c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800093:	01 c8                	add    %ecx,%eax
  800095:	01 d0                	add    %edx,%eax
  800097:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80009c:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000a1:	a1 04 30 80 00       	mov    0x803004,%eax
  8000a6:	8a 40 20             	mov    0x20(%eax),%al
  8000a9:	84 c0                	test   %al,%al
  8000ab:	74 0d                	je     8000ba <libmain+0x53>
		binaryname = myEnv->prog_name;
  8000ad:	a1 04 30 80 00       	mov    0x803004,%eax
  8000b2:	83 c0 20             	add    $0x20,%eax
  8000b5:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000be:	7e 0a                	jle    8000ca <libmain+0x63>
		binaryname = argv[0];
  8000c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000c3:	8b 00                	mov    (%eax),%eax
  8000c5:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000ca:	83 ec 08             	sub    $0x8,%esp
  8000cd:	ff 75 0c             	pushl  0xc(%ebp)
  8000d0:	ff 75 08             	pushl  0x8(%ebp)
  8000d3:	e8 60 ff ff ff       	call   800038 <_main>
  8000d8:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8000db:	e8 8a 11 00 00       	call   80126a <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8000e0:	83 ec 0c             	sub    $0xc,%esp
  8000e3:	68 ec 1b 80 00       	push   $0x801bec
  8000e8:	e8 76 03 00 00       	call   800463 <cprintf>
  8000ed:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000f0:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f5:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000fb:	a1 04 30 80 00       	mov    0x803004,%eax
  800100:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800106:	83 ec 04             	sub    $0x4,%esp
  800109:	52                   	push   %edx
  80010a:	50                   	push   %eax
  80010b:	68 14 1c 80 00       	push   $0x801c14
  800110:	e8 4e 03 00 00       	call   800463 <cprintf>
  800115:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800118:	a1 04 30 80 00       	mov    0x803004,%eax
  80011d:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800123:	a1 04 30 80 00       	mov    0x803004,%eax
  800128:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80012e:	a1 04 30 80 00       	mov    0x803004,%eax
  800133:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800139:	51                   	push   %ecx
  80013a:	52                   	push   %edx
  80013b:	50                   	push   %eax
  80013c:	68 3c 1c 80 00       	push   $0x801c3c
  800141:	e8 1d 03 00 00       	call   800463 <cprintf>
  800146:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800149:	a1 04 30 80 00       	mov    0x803004,%eax
  80014e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800154:	83 ec 08             	sub    $0x8,%esp
  800157:	50                   	push   %eax
  800158:	68 94 1c 80 00       	push   $0x801c94
  80015d:	e8 01 03 00 00       	call   800463 <cprintf>
  800162:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	68 ec 1b 80 00       	push   $0x801bec
  80016d:	e8 f1 02 00 00       	call   800463 <cprintf>
  800172:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800175:	e8 0a 11 00 00       	call   801284 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80017a:	e8 19 00 00 00       	call   800198 <exit>
}
  80017f:	90                   	nop
  800180:	c9                   	leave  
  800181:	c3                   	ret    

00800182 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800182:	55                   	push   %ebp
  800183:	89 e5                	mov    %esp,%ebp
  800185:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	6a 00                	push   $0x0
  80018d:	e8 20 13 00 00       	call   8014b2 <sys_destroy_env>
  800192:	83 c4 10             	add    $0x10,%esp
}
  800195:	90                   	nop
  800196:	c9                   	leave  
  800197:	c3                   	ret    

00800198 <exit>:

void
exit(void)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80019e:	e8 75 13 00 00       	call   801518 <sys_exit_env>
}
  8001a3:	90                   	nop
  8001a4:	c9                   	leave  
  8001a5:	c3                   	ret    

008001a6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001ac:	8d 45 10             	lea    0x10(%ebp),%eax
  8001af:	83 c0 04             	add    $0x4,%eax
  8001b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001b5:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8001ba:	85 c0                	test   %eax,%eax
  8001bc:	74 16                	je     8001d4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001be:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8001c3:	83 ec 08             	sub    $0x8,%esp
  8001c6:	50                   	push   %eax
  8001c7:	68 a8 1c 80 00       	push   $0x801ca8
  8001cc:	e8 92 02 00 00       	call   800463 <cprintf>
  8001d1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001d4:	a1 00 30 80 00       	mov    0x803000,%eax
  8001d9:	ff 75 0c             	pushl  0xc(%ebp)
  8001dc:	ff 75 08             	pushl  0x8(%ebp)
  8001df:	50                   	push   %eax
  8001e0:	68 ad 1c 80 00       	push   $0x801cad
  8001e5:	e8 79 02 00 00       	call   800463 <cprintf>
  8001ea:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f0:	83 ec 08             	sub    $0x8,%esp
  8001f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8001f6:	50                   	push   %eax
  8001f7:	e8 fc 01 00 00       	call   8003f8 <vcprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8001ff:	83 ec 08             	sub    $0x8,%esp
  800202:	6a 00                	push   $0x0
  800204:	68 c9 1c 80 00       	push   $0x801cc9
  800209:	e8 ea 01 00 00       	call   8003f8 <vcprintf>
  80020e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800211:	e8 82 ff ff ff       	call   800198 <exit>

	// should not return here
	while (1) ;
  800216:	eb fe                	jmp    800216 <_panic+0x70>

00800218 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80021e:	a1 04 30 80 00       	mov    0x803004,%eax
  800223:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800229:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022c:	39 c2                	cmp    %eax,%edx
  80022e:	74 14                	je     800244 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800230:	83 ec 04             	sub    $0x4,%esp
  800233:	68 cc 1c 80 00       	push   $0x801ccc
  800238:	6a 26                	push   $0x26
  80023a:	68 18 1d 80 00       	push   $0x801d18
  80023f:	e8 62 ff ff ff       	call   8001a6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800244:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80024b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800252:	e9 c5 00 00 00       	jmp    80031c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800257:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80025a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800261:	8b 45 08             	mov    0x8(%ebp),%eax
  800264:	01 d0                	add    %edx,%eax
  800266:	8b 00                	mov    (%eax),%eax
  800268:	85 c0                	test   %eax,%eax
  80026a:	75 08                	jne    800274 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80026c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80026f:	e9 a5 00 00 00       	jmp    800319 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800274:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80027b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800282:	eb 69                	jmp    8002ed <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800284:	a1 04 30 80 00       	mov    0x803004,%eax
  800289:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80028f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800292:	89 d0                	mov    %edx,%eax
  800294:	01 c0                	add    %eax,%eax
  800296:	01 d0                	add    %edx,%eax
  800298:	c1 e0 03             	shl    $0x3,%eax
  80029b:	01 c8                	add    %ecx,%eax
  80029d:	8a 40 04             	mov    0x4(%eax),%al
  8002a0:	84 c0                	test   %al,%al
  8002a2:	75 46                	jne    8002ea <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002a4:	a1 04 30 80 00       	mov    0x803004,%eax
  8002a9:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8002af:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002b2:	89 d0                	mov    %edx,%eax
  8002b4:	01 c0                	add    %eax,%eax
  8002b6:	01 d0                	add    %edx,%eax
  8002b8:	c1 e0 03             	shl    $0x3,%eax
  8002bb:	01 c8                	add    %ecx,%eax
  8002bd:	8b 00                	mov    (%eax),%eax
  8002bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002ca:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002cf:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d9:	01 c8                	add    %ecx,%eax
  8002db:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002dd:	39 c2                	cmp    %eax,%edx
  8002df:	75 09                	jne    8002ea <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002e1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002e8:	eb 15                	jmp    8002ff <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002ea:	ff 45 e8             	incl   -0x18(%ebp)
  8002ed:	a1 04 30 80 00       	mov    0x803004,%eax
  8002f2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8002f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002fb:	39 c2                	cmp    %eax,%edx
  8002fd:	77 85                	ja     800284 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8002ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800303:	75 14                	jne    800319 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800305:	83 ec 04             	sub    $0x4,%esp
  800308:	68 24 1d 80 00       	push   $0x801d24
  80030d:	6a 3a                	push   $0x3a
  80030f:	68 18 1d 80 00       	push   $0x801d18
  800314:	e8 8d fe ff ff       	call   8001a6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800319:	ff 45 f0             	incl   -0x10(%ebp)
  80031c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80031f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800322:	0f 8c 2f ff ff ff    	jl     800257 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800328:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80032f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800336:	eb 26                	jmp    80035e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800338:	a1 04 30 80 00       	mov    0x803004,%eax
  80033d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800343:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800346:	89 d0                	mov    %edx,%eax
  800348:	01 c0                	add    %eax,%eax
  80034a:	01 d0                	add    %edx,%eax
  80034c:	c1 e0 03             	shl    $0x3,%eax
  80034f:	01 c8                	add    %ecx,%eax
  800351:	8a 40 04             	mov    0x4(%eax),%al
  800354:	3c 01                	cmp    $0x1,%al
  800356:	75 03                	jne    80035b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800358:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80035b:	ff 45 e0             	incl   -0x20(%ebp)
  80035e:	a1 04 30 80 00       	mov    0x803004,%eax
  800363:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800369:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80036c:	39 c2                	cmp    %eax,%edx
  80036e:	77 c8                	ja     800338 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800373:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800376:	74 14                	je     80038c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800378:	83 ec 04             	sub    $0x4,%esp
  80037b:	68 78 1d 80 00       	push   $0x801d78
  800380:	6a 44                	push   $0x44
  800382:	68 18 1d 80 00       	push   $0x801d18
  800387:	e8 1a fe ff ff       	call   8001a6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80038c:	90                   	nop
  80038d:	c9                   	leave  
  80038e:	c3                   	ret    

0080038f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80038f:	55                   	push   %ebp
  800390:	89 e5                	mov    %esp,%ebp
  800392:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800395:	8b 45 0c             	mov    0xc(%ebp),%eax
  800398:	8b 00                	mov    (%eax),%eax
  80039a:	8d 48 01             	lea    0x1(%eax),%ecx
  80039d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a0:	89 0a                	mov    %ecx,(%edx)
  8003a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a5:	88 d1                	mov    %dl,%cl
  8003a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003aa:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b1:	8b 00                	mov    (%eax),%eax
  8003b3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b8:	75 2c                	jne    8003e6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003ba:	a0 08 30 80 00       	mov    0x803008,%al
  8003bf:	0f b6 c0             	movzbl %al,%eax
  8003c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c5:	8b 12                	mov    (%edx),%edx
  8003c7:	89 d1                	mov    %edx,%ecx
  8003c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003cc:	83 c2 08             	add    $0x8,%edx
  8003cf:	83 ec 04             	sub    $0x4,%esp
  8003d2:	50                   	push   %eax
  8003d3:	51                   	push   %ecx
  8003d4:	52                   	push   %edx
  8003d5:	e8 4e 0e 00 00       	call   801228 <sys_cputs>
  8003da:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e9:	8b 40 04             	mov    0x4(%eax),%eax
  8003ec:	8d 50 01             	lea    0x1(%eax),%edx
  8003ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003f5:	90                   	nop
  8003f6:	c9                   	leave  
  8003f7:	c3                   	ret    

008003f8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003f8:	55                   	push   %ebp
  8003f9:	89 e5                	mov    %esp,%ebp
  8003fb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800401:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800408:	00 00 00 
	b.cnt = 0;
  80040b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800412:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800415:	ff 75 0c             	pushl  0xc(%ebp)
  800418:	ff 75 08             	pushl  0x8(%ebp)
  80041b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800421:	50                   	push   %eax
  800422:	68 8f 03 80 00       	push   $0x80038f
  800427:	e8 11 02 00 00       	call   80063d <vprintfmt>
  80042c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80042f:	a0 08 30 80 00       	mov    0x803008,%al
  800434:	0f b6 c0             	movzbl %al,%eax
  800437:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80043d:	83 ec 04             	sub    $0x4,%esp
  800440:	50                   	push   %eax
  800441:	52                   	push   %edx
  800442:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800448:	83 c0 08             	add    $0x8,%eax
  80044b:	50                   	push   %eax
  80044c:	e8 d7 0d 00 00       	call   801228 <sys_cputs>
  800451:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800454:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  80045b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800461:	c9                   	leave  
  800462:	c3                   	ret    

00800463 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800463:	55                   	push   %ebp
  800464:	89 e5                	mov    %esp,%ebp
  800466:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800469:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800470:	8d 45 0c             	lea    0xc(%ebp),%eax
  800473:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800476:	8b 45 08             	mov    0x8(%ebp),%eax
  800479:	83 ec 08             	sub    $0x8,%esp
  80047c:	ff 75 f4             	pushl  -0xc(%ebp)
  80047f:	50                   	push   %eax
  800480:	e8 73 ff ff ff       	call   8003f8 <vcprintf>
  800485:	83 c4 10             	add    $0x10,%esp
  800488:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80048b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80048e:	c9                   	leave  
  80048f:	c3                   	ret    

00800490 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
  800493:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800496:	e8 cf 0d 00 00       	call   80126a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80049b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80049e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	83 ec 08             	sub    $0x8,%esp
  8004a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8004aa:	50                   	push   %eax
  8004ab:	e8 48 ff ff ff       	call   8003f8 <vcprintf>
  8004b0:	83 c4 10             	add    $0x10,%esp
  8004b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004b6:	e8 c9 0d 00 00       	call   801284 <sys_unlock_cons>
	return cnt;
  8004bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004be:	c9                   	leave  
  8004bf:	c3                   	ret    

008004c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	53                   	push   %ebx
  8004c4:	83 ec 14             	sub    $0x14,%esp
  8004c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004d3:	8b 45 18             	mov    0x18(%ebp),%eax
  8004d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8004db:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004de:	77 55                	ja     800535 <printnum+0x75>
  8004e0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004e3:	72 05                	jb     8004ea <printnum+0x2a>
  8004e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004e8:	77 4b                	ja     800535 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004ea:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004ed:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004f0:	8b 45 18             	mov    0x18(%ebp),%eax
  8004f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f8:	52                   	push   %edx
  8004f9:	50                   	push   %eax
  8004fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8004fd:	ff 75 f0             	pushl  -0x10(%ebp)
  800500:	e8 bf 13 00 00       	call   8018c4 <__udivdi3>
  800505:	83 c4 10             	add    $0x10,%esp
  800508:	83 ec 04             	sub    $0x4,%esp
  80050b:	ff 75 20             	pushl  0x20(%ebp)
  80050e:	53                   	push   %ebx
  80050f:	ff 75 18             	pushl  0x18(%ebp)
  800512:	52                   	push   %edx
  800513:	50                   	push   %eax
  800514:	ff 75 0c             	pushl  0xc(%ebp)
  800517:	ff 75 08             	pushl  0x8(%ebp)
  80051a:	e8 a1 ff ff ff       	call   8004c0 <printnum>
  80051f:	83 c4 20             	add    $0x20,%esp
  800522:	eb 1a                	jmp    80053e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800524:	83 ec 08             	sub    $0x8,%esp
  800527:	ff 75 0c             	pushl  0xc(%ebp)
  80052a:	ff 75 20             	pushl  0x20(%ebp)
  80052d:	8b 45 08             	mov    0x8(%ebp),%eax
  800530:	ff d0                	call   *%eax
  800532:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800535:	ff 4d 1c             	decl   0x1c(%ebp)
  800538:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80053c:	7f e6                	jg     800524 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80053e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800541:	bb 00 00 00 00       	mov    $0x0,%ebx
  800546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800549:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80054c:	53                   	push   %ebx
  80054d:	51                   	push   %ecx
  80054e:	52                   	push   %edx
  80054f:	50                   	push   %eax
  800550:	e8 7f 14 00 00       	call   8019d4 <__umoddi3>
  800555:	83 c4 10             	add    $0x10,%esp
  800558:	05 f4 1f 80 00       	add    $0x801ff4,%eax
  80055d:	8a 00                	mov    (%eax),%al
  80055f:	0f be c0             	movsbl %al,%eax
  800562:	83 ec 08             	sub    $0x8,%esp
  800565:	ff 75 0c             	pushl  0xc(%ebp)
  800568:	50                   	push   %eax
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	ff d0                	call   *%eax
  80056e:	83 c4 10             	add    $0x10,%esp
}
  800571:	90                   	nop
  800572:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800575:	c9                   	leave  
  800576:	c3                   	ret    

00800577 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800577:	55                   	push   %ebp
  800578:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80057a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80057e:	7e 1c                	jle    80059c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800580:	8b 45 08             	mov    0x8(%ebp),%eax
  800583:	8b 00                	mov    (%eax),%eax
  800585:	8d 50 08             	lea    0x8(%eax),%edx
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	89 10                	mov    %edx,(%eax)
  80058d:	8b 45 08             	mov    0x8(%ebp),%eax
  800590:	8b 00                	mov    (%eax),%eax
  800592:	83 e8 08             	sub    $0x8,%eax
  800595:	8b 50 04             	mov    0x4(%eax),%edx
  800598:	8b 00                	mov    (%eax),%eax
  80059a:	eb 40                	jmp    8005dc <getuint+0x65>
	else if (lflag)
  80059c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005a0:	74 1e                	je     8005c0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a5:	8b 00                	mov    (%eax),%eax
  8005a7:	8d 50 04             	lea    0x4(%eax),%edx
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	89 10                	mov    %edx,(%eax)
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	8b 00                	mov    (%eax),%eax
  8005b4:	83 e8 04             	sub    $0x4,%eax
  8005b7:	8b 00                	mov    (%eax),%eax
  8005b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005be:	eb 1c                	jmp    8005dc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c3:	8b 00                	mov    (%eax),%eax
  8005c5:	8d 50 04             	lea    0x4(%eax),%edx
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	89 10                	mov    %edx,(%eax)
  8005cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	83 e8 04             	sub    $0x4,%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005dc:	5d                   	pop    %ebp
  8005dd:	c3                   	ret    

008005de <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005de:	55                   	push   %ebp
  8005df:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005e1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005e5:	7e 1c                	jle    800603 <getint+0x25>
		return va_arg(*ap, long long);
  8005e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ea:	8b 00                	mov    (%eax),%eax
  8005ec:	8d 50 08             	lea    0x8(%eax),%edx
  8005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f2:	89 10                	mov    %edx,(%eax)
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	83 e8 08             	sub    $0x8,%eax
  8005fc:	8b 50 04             	mov    0x4(%eax),%edx
  8005ff:	8b 00                	mov    (%eax),%eax
  800601:	eb 38                	jmp    80063b <getint+0x5d>
	else if (lflag)
  800603:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800607:	74 1a                	je     800623 <getint+0x45>
		return va_arg(*ap, long);
  800609:	8b 45 08             	mov    0x8(%ebp),%eax
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	8d 50 04             	lea    0x4(%eax),%edx
  800611:	8b 45 08             	mov    0x8(%ebp),%eax
  800614:	89 10                	mov    %edx,(%eax)
  800616:	8b 45 08             	mov    0x8(%ebp),%eax
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	83 e8 04             	sub    $0x4,%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	99                   	cltd   
  800621:	eb 18                	jmp    80063b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800623:	8b 45 08             	mov    0x8(%ebp),%eax
  800626:	8b 00                	mov    (%eax),%eax
  800628:	8d 50 04             	lea    0x4(%eax),%edx
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	89 10                	mov    %edx,(%eax)
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	8b 00                	mov    (%eax),%eax
  800635:	83 e8 04             	sub    $0x4,%eax
  800638:	8b 00                	mov    (%eax),%eax
  80063a:	99                   	cltd   
}
  80063b:	5d                   	pop    %ebp
  80063c:	c3                   	ret    

0080063d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80063d:	55                   	push   %ebp
  80063e:	89 e5                	mov    %esp,%ebp
  800640:	56                   	push   %esi
  800641:	53                   	push   %ebx
  800642:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800645:	eb 17                	jmp    80065e <vprintfmt+0x21>
			if (ch == '\0')
  800647:	85 db                	test   %ebx,%ebx
  800649:	0f 84 c1 03 00 00    	je     800a10 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80064f:	83 ec 08             	sub    $0x8,%esp
  800652:	ff 75 0c             	pushl  0xc(%ebp)
  800655:	53                   	push   %ebx
  800656:	8b 45 08             	mov    0x8(%ebp),%eax
  800659:	ff d0                	call   *%eax
  80065b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80065e:	8b 45 10             	mov    0x10(%ebp),%eax
  800661:	8d 50 01             	lea    0x1(%eax),%edx
  800664:	89 55 10             	mov    %edx,0x10(%ebp)
  800667:	8a 00                	mov    (%eax),%al
  800669:	0f b6 d8             	movzbl %al,%ebx
  80066c:	83 fb 25             	cmp    $0x25,%ebx
  80066f:	75 d6                	jne    800647 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800671:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800675:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80067c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800683:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80068a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800691:	8b 45 10             	mov    0x10(%ebp),%eax
  800694:	8d 50 01             	lea    0x1(%eax),%edx
  800697:	89 55 10             	mov    %edx,0x10(%ebp)
  80069a:	8a 00                	mov    (%eax),%al
  80069c:	0f b6 d8             	movzbl %al,%ebx
  80069f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006a2:	83 f8 5b             	cmp    $0x5b,%eax
  8006a5:	0f 87 3d 03 00 00    	ja     8009e8 <vprintfmt+0x3ab>
  8006ab:	8b 04 85 18 20 80 00 	mov    0x802018(,%eax,4),%eax
  8006b2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006b4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006b8:	eb d7                	jmp    800691 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006ba:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006be:	eb d1                	jmp    800691 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006c0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006ca:	89 d0                	mov    %edx,%eax
  8006cc:	c1 e0 02             	shl    $0x2,%eax
  8006cf:	01 d0                	add    %edx,%eax
  8006d1:	01 c0                	add    %eax,%eax
  8006d3:	01 d8                	add    %ebx,%eax
  8006d5:	83 e8 30             	sub    $0x30,%eax
  8006d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006db:	8b 45 10             	mov    0x10(%ebp),%eax
  8006de:	8a 00                	mov    (%eax),%al
  8006e0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006e3:	83 fb 2f             	cmp    $0x2f,%ebx
  8006e6:	7e 3e                	jle    800726 <vprintfmt+0xe9>
  8006e8:	83 fb 39             	cmp    $0x39,%ebx
  8006eb:	7f 39                	jg     800726 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006ed:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006f0:	eb d5                	jmp    8006c7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	83 c0 04             	add    $0x4,%eax
  8006f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	83 e8 04             	sub    $0x4,%eax
  800701:	8b 00                	mov    (%eax),%eax
  800703:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800706:	eb 1f                	jmp    800727 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800708:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80070c:	79 83                	jns    800691 <vprintfmt+0x54>
				width = 0;
  80070e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800715:	e9 77 ff ff ff       	jmp    800691 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80071a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800721:	e9 6b ff ff ff       	jmp    800691 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800726:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800727:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80072b:	0f 89 60 ff ff ff    	jns    800691 <vprintfmt+0x54>
				width = precision, precision = -1;
  800731:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800737:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80073e:	e9 4e ff ff ff       	jmp    800691 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800743:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800746:	e9 46 ff ff ff       	jmp    800691 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	83 c0 04             	add    $0x4,%eax
  800751:	89 45 14             	mov    %eax,0x14(%ebp)
  800754:	8b 45 14             	mov    0x14(%ebp),%eax
  800757:	83 e8 04             	sub    $0x4,%eax
  80075a:	8b 00                	mov    (%eax),%eax
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	ff 75 0c             	pushl  0xc(%ebp)
  800762:	50                   	push   %eax
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	ff d0                	call   *%eax
  800768:	83 c4 10             	add    $0x10,%esp
			break;
  80076b:	e9 9b 02 00 00       	jmp    800a0b <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	83 c0 04             	add    $0x4,%eax
  800776:	89 45 14             	mov    %eax,0x14(%ebp)
  800779:	8b 45 14             	mov    0x14(%ebp),%eax
  80077c:	83 e8 04             	sub    $0x4,%eax
  80077f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800781:	85 db                	test   %ebx,%ebx
  800783:	79 02                	jns    800787 <vprintfmt+0x14a>
				err = -err;
  800785:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800787:	83 fb 64             	cmp    $0x64,%ebx
  80078a:	7f 0b                	jg     800797 <vprintfmt+0x15a>
  80078c:	8b 34 9d 60 1e 80 00 	mov    0x801e60(,%ebx,4),%esi
  800793:	85 f6                	test   %esi,%esi
  800795:	75 19                	jne    8007b0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800797:	53                   	push   %ebx
  800798:	68 05 20 80 00       	push   $0x802005
  80079d:	ff 75 0c             	pushl  0xc(%ebp)
  8007a0:	ff 75 08             	pushl  0x8(%ebp)
  8007a3:	e8 70 02 00 00       	call   800a18 <printfmt>
  8007a8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007ab:	e9 5b 02 00 00       	jmp    800a0b <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007b0:	56                   	push   %esi
  8007b1:	68 0e 20 80 00       	push   $0x80200e
  8007b6:	ff 75 0c             	pushl  0xc(%ebp)
  8007b9:	ff 75 08             	pushl  0x8(%ebp)
  8007bc:	e8 57 02 00 00       	call   800a18 <printfmt>
  8007c1:	83 c4 10             	add    $0x10,%esp
			break;
  8007c4:	e9 42 02 00 00       	jmp    800a0b <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	83 c0 04             	add    $0x4,%eax
  8007cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d5:	83 e8 04             	sub    $0x4,%eax
  8007d8:	8b 30                	mov    (%eax),%esi
  8007da:	85 f6                	test   %esi,%esi
  8007dc:	75 05                	jne    8007e3 <vprintfmt+0x1a6>
				p = "(null)";
  8007de:	be 11 20 80 00       	mov    $0x802011,%esi
			if (width > 0 && padc != '-')
  8007e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e7:	7e 6d                	jle    800856 <vprintfmt+0x219>
  8007e9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007ed:	74 67                	je     800856 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f2:	83 ec 08             	sub    $0x8,%esp
  8007f5:	50                   	push   %eax
  8007f6:	56                   	push   %esi
  8007f7:	e8 1e 03 00 00       	call   800b1a <strnlen>
  8007fc:	83 c4 10             	add    $0x10,%esp
  8007ff:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800802:	eb 16                	jmp    80081a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800804:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800808:	83 ec 08             	sub    $0x8,%esp
  80080b:	ff 75 0c             	pushl  0xc(%ebp)
  80080e:	50                   	push   %eax
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	ff d0                	call   *%eax
  800814:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800817:	ff 4d e4             	decl   -0x1c(%ebp)
  80081a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80081e:	7f e4                	jg     800804 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800820:	eb 34                	jmp    800856 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800822:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800826:	74 1c                	je     800844 <vprintfmt+0x207>
  800828:	83 fb 1f             	cmp    $0x1f,%ebx
  80082b:	7e 05                	jle    800832 <vprintfmt+0x1f5>
  80082d:	83 fb 7e             	cmp    $0x7e,%ebx
  800830:	7e 12                	jle    800844 <vprintfmt+0x207>
					putch('?', putdat);
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	6a 3f                	push   $0x3f
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	ff d0                	call   *%eax
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	eb 0f                	jmp    800853 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800844:	83 ec 08             	sub    $0x8,%esp
  800847:	ff 75 0c             	pushl  0xc(%ebp)
  80084a:	53                   	push   %ebx
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	ff d0                	call   *%eax
  800850:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800853:	ff 4d e4             	decl   -0x1c(%ebp)
  800856:	89 f0                	mov    %esi,%eax
  800858:	8d 70 01             	lea    0x1(%eax),%esi
  80085b:	8a 00                	mov    (%eax),%al
  80085d:	0f be d8             	movsbl %al,%ebx
  800860:	85 db                	test   %ebx,%ebx
  800862:	74 24                	je     800888 <vprintfmt+0x24b>
  800864:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800868:	78 b8                	js     800822 <vprintfmt+0x1e5>
  80086a:	ff 4d e0             	decl   -0x20(%ebp)
  80086d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800871:	79 af                	jns    800822 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800873:	eb 13                	jmp    800888 <vprintfmt+0x24b>
				putch(' ', putdat);
  800875:	83 ec 08             	sub    $0x8,%esp
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	6a 20                	push   $0x20
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	ff d0                	call   *%eax
  800882:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800885:	ff 4d e4             	decl   -0x1c(%ebp)
  800888:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80088c:	7f e7                	jg     800875 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80088e:	e9 78 01 00 00       	jmp    800a0b <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800893:	83 ec 08             	sub    $0x8,%esp
  800896:	ff 75 e8             	pushl  -0x18(%ebp)
  800899:	8d 45 14             	lea    0x14(%ebp),%eax
  80089c:	50                   	push   %eax
  80089d:	e8 3c fd ff ff       	call   8005de <getint>
  8008a2:	83 c4 10             	add    $0x10,%esp
  8008a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b1:	85 d2                	test   %edx,%edx
  8008b3:	79 23                	jns    8008d8 <vprintfmt+0x29b>
				putch('-', putdat);
  8008b5:	83 ec 08             	sub    $0x8,%esp
  8008b8:	ff 75 0c             	pushl  0xc(%ebp)
  8008bb:	6a 2d                	push   $0x2d
  8008bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c0:	ff d0                	call   *%eax
  8008c2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008cb:	f7 d8                	neg    %eax
  8008cd:	83 d2 00             	adc    $0x0,%edx
  8008d0:	f7 da                	neg    %edx
  8008d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008d8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008df:	e9 bc 00 00 00       	jmp    8009a0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008e4:	83 ec 08             	sub    $0x8,%esp
  8008e7:	ff 75 e8             	pushl  -0x18(%ebp)
  8008ea:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ed:	50                   	push   %eax
  8008ee:	e8 84 fc ff ff       	call   800577 <getuint>
  8008f3:	83 c4 10             	add    $0x10,%esp
  8008f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008fc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800903:	e9 98 00 00 00       	jmp    8009a0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800908:	83 ec 08             	sub    $0x8,%esp
  80090b:	ff 75 0c             	pushl  0xc(%ebp)
  80090e:	6a 58                	push   $0x58
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	ff d0                	call   *%eax
  800915:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800918:	83 ec 08             	sub    $0x8,%esp
  80091b:	ff 75 0c             	pushl  0xc(%ebp)
  80091e:	6a 58                	push   $0x58
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	ff d0                	call   *%eax
  800925:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800928:	83 ec 08             	sub    $0x8,%esp
  80092b:	ff 75 0c             	pushl  0xc(%ebp)
  80092e:	6a 58                	push   $0x58
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	ff d0                	call   *%eax
  800935:	83 c4 10             	add    $0x10,%esp
			break;
  800938:	e9 ce 00 00 00       	jmp    800a0b <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	6a 30                	push   $0x30
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	ff d0                	call   *%eax
  80094a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80094d:	83 ec 08             	sub    $0x8,%esp
  800950:	ff 75 0c             	pushl  0xc(%ebp)
  800953:	6a 78                	push   $0x78
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	ff d0                	call   *%eax
  80095a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80095d:	8b 45 14             	mov    0x14(%ebp),%eax
  800960:	83 c0 04             	add    $0x4,%eax
  800963:	89 45 14             	mov    %eax,0x14(%ebp)
  800966:	8b 45 14             	mov    0x14(%ebp),%eax
  800969:	83 e8 04             	sub    $0x4,%eax
  80096c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80096e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800971:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800978:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80097f:	eb 1f                	jmp    8009a0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800981:	83 ec 08             	sub    $0x8,%esp
  800984:	ff 75 e8             	pushl  -0x18(%ebp)
  800987:	8d 45 14             	lea    0x14(%ebp),%eax
  80098a:	50                   	push   %eax
  80098b:	e8 e7 fb ff ff       	call   800577 <getuint>
  800990:	83 c4 10             	add    $0x10,%esp
  800993:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800996:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800999:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009a0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009a7:	83 ec 04             	sub    $0x4,%esp
  8009aa:	52                   	push   %edx
  8009ab:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009ae:	50                   	push   %eax
  8009af:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8009b5:	ff 75 0c             	pushl  0xc(%ebp)
  8009b8:	ff 75 08             	pushl  0x8(%ebp)
  8009bb:	e8 00 fb ff ff       	call   8004c0 <printnum>
  8009c0:	83 c4 20             	add    $0x20,%esp
			break;
  8009c3:	eb 46                	jmp    800a0b <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009c5:	83 ec 08             	sub    $0x8,%esp
  8009c8:	ff 75 0c             	pushl  0xc(%ebp)
  8009cb:	53                   	push   %ebx
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	ff d0                	call   *%eax
  8009d1:	83 c4 10             	add    $0x10,%esp
			break;
  8009d4:	eb 35                	jmp    800a0b <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009d6:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8009dd:	eb 2c                	jmp    800a0b <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009df:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8009e6:	eb 23                	jmp    800a0b <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	6a 25                	push   $0x25
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009f8:	ff 4d 10             	decl   0x10(%ebp)
  8009fb:	eb 03                	jmp    800a00 <vprintfmt+0x3c3>
  8009fd:	ff 4d 10             	decl   0x10(%ebp)
  800a00:	8b 45 10             	mov    0x10(%ebp),%eax
  800a03:	48                   	dec    %eax
  800a04:	8a 00                	mov    (%eax),%al
  800a06:	3c 25                	cmp    $0x25,%al
  800a08:	75 f3                	jne    8009fd <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a0a:	90                   	nop
		}
	}
  800a0b:	e9 35 fc ff ff       	jmp    800645 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a10:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a11:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a14:	5b                   	pop    %ebx
  800a15:	5e                   	pop    %esi
  800a16:	5d                   	pop    %ebp
  800a17:	c3                   	ret    

00800a18 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a18:	55                   	push   %ebp
  800a19:	89 e5                	mov    %esp,%ebp
  800a1b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a1e:	8d 45 10             	lea    0x10(%ebp),%eax
  800a21:	83 c0 04             	add    $0x4,%eax
  800a24:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a27:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a2d:	50                   	push   %eax
  800a2e:	ff 75 0c             	pushl  0xc(%ebp)
  800a31:	ff 75 08             	pushl  0x8(%ebp)
  800a34:	e8 04 fc ff ff       	call   80063d <vprintfmt>
  800a39:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a3c:	90                   	nop
  800a3d:	c9                   	leave  
  800a3e:	c3                   	ret    

00800a3f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a45:	8b 40 08             	mov    0x8(%eax),%eax
  800a48:	8d 50 01             	lea    0x1(%eax),%edx
  800a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a54:	8b 10                	mov    (%eax),%edx
  800a56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a59:	8b 40 04             	mov    0x4(%eax),%eax
  800a5c:	39 c2                	cmp    %eax,%edx
  800a5e:	73 12                	jae    800a72 <sprintputch+0x33>
		*b->buf++ = ch;
  800a60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a63:	8b 00                	mov    (%eax),%eax
  800a65:	8d 48 01             	lea    0x1(%eax),%ecx
  800a68:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6b:	89 0a                	mov    %ecx,(%edx)
  800a6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800a70:	88 10                	mov    %dl,(%eax)
}
  800a72:	90                   	nop
  800a73:	5d                   	pop    %ebp
  800a74:	c3                   	ret    

00800a75 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a84:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	01 d0                	add    %edx,%eax
  800a8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a9a:	74 06                	je     800aa2 <vsnprintf+0x2d>
  800a9c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aa0:	7f 07                	jg     800aa9 <vsnprintf+0x34>
		return -E_INVAL;
  800aa2:	b8 03 00 00 00       	mov    $0x3,%eax
  800aa7:	eb 20                	jmp    800ac9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800aa9:	ff 75 14             	pushl  0x14(%ebp)
  800aac:	ff 75 10             	pushl  0x10(%ebp)
  800aaf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ab2:	50                   	push   %eax
  800ab3:	68 3f 0a 80 00       	push   $0x800a3f
  800ab8:	e8 80 fb ff ff       	call   80063d <vprintfmt>
  800abd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ac0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ac9:	c9                   	leave  
  800aca:	c3                   	ret    

00800acb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
  800ace:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ad1:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad4:	83 c0 04             	add    $0x4,%eax
  800ad7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ada:	8b 45 10             	mov    0x10(%ebp),%eax
  800add:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae0:	50                   	push   %eax
  800ae1:	ff 75 0c             	pushl  0xc(%ebp)
  800ae4:	ff 75 08             	pushl  0x8(%ebp)
  800ae7:	e8 89 ff ff ff       	call   800a75 <vsnprintf>
  800aec:	83 c4 10             	add    $0x10,%esp
  800aef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800af2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800af5:	c9                   	leave  
  800af6:	c3                   	ret    

00800af7 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
  800afa:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800afd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b04:	eb 06                	jmp    800b0c <strlen+0x15>
		n++;
  800b06:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b09:	ff 45 08             	incl   0x8(%ebp)
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	8a 00                	mov    (%eax),%al
  800b11:	84 c0                	test   %al,%al
  800b13:	75 f1                	jne    800b06 <strlen+0xf>
		n++;
	return n;
  800b15:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b18:	c9                   	leave  
  800b19:	c3                   	ret    

00800b1a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b27:	eb 09                	jmp    800b32 <strnlen+0x18>
		n++;
  800b29:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b2c:	ff 45 08             	incl   0x8(%ebp)
  800b2f:	ff 4d 0c             	decl   0xc(%ebp)
  800b32:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b36:	74 09                	je     800b41 <strnlen+0x27>
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	8a 00                	mov    (%eax),%al
  800b3d:	84 c0                	test   %al,%al
  800b3f:	75 e8                	jne    800b29 <strnlen+0xf>
		n++;
	return n;
  800b41:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b44:	c9                   	leave  
  800b45:	c3                   	ret    

00800b46 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b52:	90                   	nop
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	8d 50 01             	lea    0x1(%eax),%edx
  800b59:	89 55 08             	mov    %edx,0x8(%ebp)
  800b5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b62:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b65:	8a 12                	mov    (%edx),%dl
  800b67:	88 10                	mov    %dl,(%eax)
  800b69:	8a 00                	mov    (%eax),%al
  800b6b:	84 c0                	test   %al,%al
  800b6d:	75 e4                	jne    800b53 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b72:	c9                   	leave  
  800b73:	c3                   	ret    

00800b74 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b87:	eb 1f                	jmp    800ba8 <strncpy+0x34>
		*dst++ = *src;
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	8d 50 01             	lea    0x1(%eax),%edx
  800b8f:	89 55 08             	mov    %edx,0x8(%ebp)
  800b92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b95:	8a 12                	mov    (%edx),%dl
  800b97:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9c:	8a 00                	mov    (%eax),%al
  800b9e:	84 c0                	test   %al,%al
  800ba0:	74 03                	je     800ba5 <strncpy+0x31>
			src++;
  800ba2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ba5:	ff 45 fc             	incl   -0x4(%ebp)
  800ba8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bab:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bae:	72 d9                	jb     800b89 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800bb0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bc1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bc5:	74 30                	je     800bf7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bc7:	eb 16                	jmp    800bdf <strlcpy+0x2a>
			*dst++ = *src++;
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	8d 50 01             	lea    0x1(%eax),%edx
  800bcf:	89 55 08             	mov    %edx,0x8(%ebp)
  800bd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bd8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bdb:	8a 12                	mov    (%edx),%dl
  800bdd:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bdf:	ff 4d 10             	decl   0x10(%ebp)
  800be2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800be6:	74 09                	je     800bf1 <strlcpy+0x3c>
  800be8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800beb:	8a 00                	mov    (%eax),%al
  800bed:	84 c0                	test   %al,%al
  800bef:	75 d8                	jne    800bc9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bf7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bfd:	29 c2                	sub    %eax,%edx
  800bff:	89 d0                	mov    %edx,%eax
}
  800c01:	c9                   	leave  
  800c02:	c3                   	ret    

00800c03 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c06:	eb 06                	jmp    800c0e <strcmp+0xb>
		p++, q++;
  800c08:	ff 45 08             	incl   0x8(%ebp)
  800c0b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	84 c0                	test   %al,%al
  800c15:	74 0e                	je     800c25 <strcmp+0x22>
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	8a 10                	mov    (%eax),%dl
  800c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1f:	8a 00                	mov    (%eax),%al
  800c21:	38 c2                	cmp    %al,%dl
  800c23:	74 e3                	je     800c08 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	8a 00                	mov    (%eax),%al
  800c2a:	0f b6 d0             	movzbl %al,%edx
  800c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c30:	8a 00                	mov    (%eax),%al
  800c32:	0f b6 c0             	movzbl %al,%eax
  800c35:	29 c2                	sub    %eax,%edx
  800c37:	89 d0                	mov    %edx,%eax
}
  800c39:	5d                   	pop    %ebp
  800c3a:	c3                   	ret    

00800c3b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c3e:	eb 09                	jmp    800c49 <strncmp+0xe>
		n--, p++, q++;
  800c40:	ff 4d 10             	decl   0x10(%ebp)
  800c43:	ff 45 08             	incl   0x8(%ebp)
  800c46:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c4d:	74 17                	je     800c66 <strncmp+0x2b>
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	8a 00                	mov    (%eax),%al
  800c54:	84 c0                	test   %al,%al
  800c56:	74 0e                	je     800c66 <strncmp+0x2b>
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8a 10                	mov    (%eax),%dl
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	8a 00                	mov    (%eax),%al
  800c62:	38 c2                	cmp    %al,%dl
  800c64:	74 da                	je     800c40 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c6a:	75 07                	jne    800c73 <strncmp+0x38>
		return 0;
  800c6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c71:	eb 14                	jmp    800c87 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	8a 00                	mov    (%eax),%al
  800c78:	0f b6 d0             	movzbl %al,%edx
  800c7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7e:	8a 00                	mov    (%eax),%al
  800c80:	0f b6 c0             	movzbl %al,%eax
  800c83:	29 c2                	sub    %eax,%edx
  800c85:	89 d0                	mov    %edx,%eax
}
  800c87:	5d                   	pop    %ebp
  800c88:	c3                   	ret    

00800c89 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	83 ec 04             	sub    $0x4,%esp
  800c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c92:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c95:	eb 12                	jmp    800ca9 <strchr+0x20>
		if (*s == c)
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	8a 00                	mov    (%eax),%al
  800c9c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c9f:	75 05                	jne    800ca6 <strchr+0x1d>
			return (char *) s;
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	eb 11                	jmp    800cb7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ca6:	ff 45 08             	incl   0x8(%ebp)
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	84 c0                	test   %al,%al
  800cb0:	75 e5                	jne    800c97 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb7:	c9                   	leave  
  800cb8:	c3                   	ret    

00800cb9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
  800cbc:	83 ec 04             	sub    $0x4,%esp
  800cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cc5:	eb 0d                	jmp    800cd4 <strfind+0x1b>
		if (*s == c)
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ccf:	74 0e                	je     800cdf <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cd1:	ff 45 08             	incl   0x8(%ebp)
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	8a 00                	mov    (%eax),%al
  800cd9:	84 c0                	test   %al,%al
  800cdb:	75 ea                	jne    800cc7 <strfind+0xe>
  800cdd:	eb 01                	jmp    800ce0 <strfind+0x27>
		if (*s == c)
			break;
  800cdf:	90                   	nop
	return (char *) s;
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ce3:	c9                   	leave  
  800ce4:	c3                   	ret    

00800ce5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
  800ce8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cf7:	eb 0e                	jmp    800d07 <memset+0x22>
		*p++ = c;
  800cf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cfc:	8d 50 01             	lea    0x1(%eax),%edx
  800cff:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d05:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d07:	ff 4d f8             	decl   -0x8(%ebp)
  800d0a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d0e:	79 e9                	jns    800cf9 <memset+0x14>
		*p++ = c;

	return v;
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d13:	c9                   	leave  
  800d14:	c3                   	ret    

00800d15 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d27:	eb 16                	jmp    800d3f <memcpy+0x2a>
		*d++ = *s++;
  800d29:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d2c:	8d 50 01             	lea    0x1(%eax),%edx
  800d2f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d32:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d35:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d38:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d3b:	8a 12                	mov    (%edx),%dl
  800d3d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d42:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d45:	89 55 10             	mov    %edx,0x10(%ebp)
  800d48:	85 c0                	test   %eax,%eax
  800d4a:	75 dd                	jne    800d29 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d4f:	c9                   	leave  
  800d50:	c3                   	ret    

00800d51 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d60:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d66:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d69:	73 50                	jae    800dbb <memmove+0x6a>
  800d6b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d71:	01 d0                	add    %edx,%eax
  800d73:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d76:	76 43                	jbe    800dbb <memmove+0x6a>
		s += n;
  800d78:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d81:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d84:	eb 10                	jmp    800d96 <memmove+0x45>
			*--d = *--s;
  800d86:	ff 4d f8             	decl   -0x8(%ebp)
  800d89:	ff 4d fc             	decl   -0x4(%ebp)
  800d8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d8f:	8a 10                	mov    (%eax),%dl
  800d91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d94:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d96:	8b 45 10             	mov    0x10(%ebp),%eax
  800d99:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d9f:	85 c0                	test   %eax,%eax
  800da1:	75 e3                	jne    800d86 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800da3:	eb 23                	jmp    800dc8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800da5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da8:	8d 50 01             	lea    0x1(%eax),%edx
  800dab:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800db1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800db7:	8a 12                	mov    (%edx),%dl
  800db9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc1:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc4:	85 c0                	test   %eax,%eax
  800dc6:	75 dd                	jne    800da5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dcb:	c9                   	leave  
  800dcc:	c3                   	ret    

00800dcd <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ddf:	eb 2a                	jmp    800e0b <memcmp+0x3e>
		if (*s1 != *s2)
  800de1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de4:	8a 10                	mov    (%eax),%dl
  800de6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de9:	8a 00                	mov    (%eax),%al
  800deb:	38 c2                	cmp    %al,%dl
  800ded:	74 16                	je     800e05 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800def:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	0f b6 d0             	movzbl %al,%edx
  800df7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dfa:	8a 00                	mov    (%eax),%al
  800dfc:	0f b6 c0             	movzbl %al,%eax
  800dff:	29 c2                	sub    %eax,%edx
  800e01:	89 d0                	mov    %edx,%eax
  800e03:	eb 18                	jmp    800e1d <memcmp+0x50>
		s1++, s2++;
  800e05:	ff 45 fc             	incl   -0x4(%ebp)
  800e08:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e11:	89 55 10             	mov    %edx,0x10(%ebp)
  800e14:	85 c0                	test   %eax,%eax
  800e16:	75 c9                	jne    800de1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e1d:	c9                   	leave  
  800e1e:	c3                   	ret    

00800e1f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e25:	8b 55 08             	mov    0x8(%ebp),%edx
  800e28:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2b:	01 d0                	add    %edx,%eax
  800e2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e30:	eb 15                	jmp    800e47 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	0f b6 d0             	movzbl %al,%edx
  800e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3d:	0f b6 c0             	movzbl %al,%eax
  800e40:	39 c2                	cmp    %eax,%edx
  800e42:	74 0d                	je     800e51 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e44:	ff 45 08             	incl   0x8(%ebp)
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e4d:	72 e3                	jb     800e32 <memfind+0x13>
  800e4f:	eb 01                	jmp    800e52 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e51:	90                   	nop
	return (void *) s;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e55:	c9                   	leave  
  800e56:	c3                   	ret    

00800e57 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
  800e5a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e64:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e6b:	eb 03                	jmp    800e70 <strtol+0x19>
		s++;
  800e6d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	8a 00                	mov    (%eax),%al
  800e75:	3c 20                	cmp    $0x20,%al
  800e77:	74 f4                	je     800e6d <strtol+0x16>
  800e79:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7c:	8a 00                	mov    (%eax),%al
  800e7e:	3c 09                	cmp    $0x9,%al
  800e80:	74 eb                	je     800e6d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	8a 00                	mov    (%eax),%al
  800e87:	3c 2b                	cmp    $0x2b,%al
  800e89:	75 05                	jne    800e90 <strtol+0x39>
		s++;
  800e8b:	ff 45 08             	incl   0x8(%ebp)
  800e8e:	eb 13                	jmp    800ea3 <strtol+0x4c>
	else if (*s == '-')
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	3c 2d                	cmp    $0x2d,%al
  800e97:	75 0a                	jne    800ea3 <strtol+0x4c>
		s++, neg = 1;
  800e99:	ff 45 08             	incl   0x8(%ebp)
  800e9c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ea3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea7:	74 06                	je     800eaf <strtol+0x58>
  800ea9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ead:	75 20                	jne    800ecf <strtol+0x78>
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	8a 00                	mov    (%eax),%al
  800eb4:	3c 30                	cmp    $0x30,%al
  800eb6:	75 17                	jne    800ecf <strtol+0x78>
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebb:	40                   	inc    %eax
  800ebc:	8a 00                	mov    (%eax),%al
  800ebe:	3c 78                	cmp    $0x78,%al
  800ec0:	75 0d                	jne    800ecf <strtol+0x78>
		s += 2, base = 16;
  800ec2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ec6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ecd:	eb 28                	jmp    800ef7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ecf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed3:	75 15                	jne    800eea <strtol+0x93>
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	8a 00                	mov    (%eax),%al
  800eda:	3c 30                	cmp    $0x30,%al
  800edc:	75 0c                	jne    800eea <strtol+0x93>
		s++, base = 8;
  800ede:	ff 45 08             	incl   0x8(%ebp)
  800ee1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ee8:	eb 0d                	jmp    800ef7 <strtol+0xa0>
	else if (base == 0)
  800eea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eee:	75 07                	jne    800ef7 <strtol+0xa0>
		base = 10;
  800ef0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	8a 00                	mov    (%eax),%al
  800efc:	3c 2f                	cmp    $0x2f,%al
  800efe:	7e 19                	jle    800f19 <strtol+0xc2>
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	8a 00                	mov    (%eax),%al
  800f05:	3c 39                	cmp    $0x39,%al
  800f07:	7f 10                	jg     800f19 <strtol+0xc2>
			dig = *s - '0';
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0c:	8a 00                	mov    (%eax),%al
  800f0e:	0f be c0             	movsbl %al,%eax
  800f11:	83 e8 30             	sub    $0x30,%eax
  800f14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f17:	eb 42                	jmp    800f5b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f19:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	3c 60                	cmp    $0x60,%al
  800f20:	7e 19                	jle    800f3b <strtol+0xe4>
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	8a 00                	mov    (%eax),%al
  800f27:	3c 7a                	cmp    $0x7a,%al
  800f29:	7f 10                	jg     800f3b <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	8a 00                	mov    (%eax),%al
  800f30:	0f be c0             	movsbl %al,%eax
  800f33:	83 e8 57             	sub    $0x57,%eax
  800f36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f39:	eb 20                	jmp    800f5b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	8a 00                	mov    (%eax),%al
  800f40:	3c 40                	cmp    $0x40,%al
  800f42:	7e 39                	jle    800f7d <strtol+0x126>
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	8a 00                	mov    (%eax),%al
  800f49:	3c 5a                	cmp    $0x5a,%al
  800f4b:	7f 30                	jg     800f7d <strtol+0x126>
			dig = *s - 'A' + 10;
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	8a 00                	mov    (%eax),%al
  800f52:	0f be c0             	movsbl %al,%eax
  800f55:	83 e8 37             	sub    $0x37,%eax
  800f58:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f5e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f61:	7d 19                	jge    800f7c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f63:	ff 45 08             	incl   0x8(%ebp)
  800f66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f69:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f6d:	89 c2                	mov    %eax,%edx
  800f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f72:	01 d0                	add    %edx,%eax
  800f74:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f77:	e9 7b ff ff ff       	jmp    800ef7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f7c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f7d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f81:	74 08                	je     800f8b <strtol+0x134>
		*endptr = (char *) s;
  800f83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f86:	8b 55 08             	mov    0x8(%ebp),%edx
  800f89:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f8f:	74 07                	je     800f98 <strtol+0x141>
  800f91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f94:	f7 d8                	neg    %eax
  800f96:	eb 03                	jmp    800f9b <strtol+0x144>
  800f98:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f9b:	c9                   	leave  
  800f9c:	c3                   	ret    

00800f9d <ltostr>:

void
ltostr(long value, char *str)
{
  800f9d:	55                   	push   %ebp
  800f9e:	89 e5                	mov    %esp,%ebp
  800fa0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fa3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800faa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fb1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fb5:	79 13                	jns    800fca <ltostr+0x2d>
	{
		neg = 1;
  800fb7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fc4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fc7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fd2:	99                   	cltd   
  800fd3:	f7 f9                	idiv   %ecx
  800fd5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdb:	8d 50 01             	lea    0x1(%eax),%edx
  800fde:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe1:	89 c2                	mov    %eax,%edx
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	01 d0                	add    %edx,%eax
  800fe8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800feb:	83 c2 30             	add    $0x30,%edx
  800fee:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ff0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ff8:	f7 e9                	imul   %ecx
  800ffa:	c1 fa 02             	sar    $0x2,%edx
  800ffd:	89 c8                	mov    %ecx,%eax
  800fff:	c1 f8 1f             	sar    $0x1f,%eax
  801002:	29 c2                	sub    %eax,%edx
  801004:	89 d0                	mov    %edx,%eax
  801006:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801009:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80100d:	75 bb                	jne    800fca <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80100f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801016:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801019:	48                   	dec    %eax
  80101a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80101d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801021:	74 3d                	je     801060 <ltostr+0xc3>
		start = 1 ;
  801023:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80102a:	eb 34                	jmp    801060 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80102c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80102f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801032:	01 d0                	add    %edx,%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801039:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103f:	01 c2                	add    %eax,%edx
  801041:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801044:	8b 45 0c             	mov    0xc(%ebp),%eax
  801047:	01 c8                	add    %ecx,%eax
  801049:	8a 00                	mov    (%eax),%al
  80104b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80104d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801050:	8b 45 0c             	mov    0xc(%ebp),%eax
  801053:	01 c2                	add    %eax,%edx
  801055:	8a 45 eb             	mov    -0x15(%ebp),%al
  801058:	88 02                	mov    %al,(%edx)
		start++ ;
  80105a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80105d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801063:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801066:	7c c4                	jl     80102c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801068:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80106b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106e:	01 d0                	add    %edx,%eax
  801070:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801073:	90                   	nop
  801074:	c9                   	leave  
  801075:	c3                   	ret    

00801076 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80107c:	ff 75 08             	pushl  0x8(%ebp)
  80107f:	e8 73 fa ff ff       	call   800af7 <strlen>
  801084:	83 c4 04             	add    $0x4,%esp
  801087:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80108a:	ff 75 0c             	pushl  0xc(%ebp)
  80108d:	e8 65 fa ff ff       	call   800af7 <strlen>
  801092:	83 c4 04             	add    $0x4,%esp
  801095:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801098:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80109f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010a6:	eb 17                	jmp    8010bf <strcconcat+0x49>
		final[s] = str1[s] ;
  8010a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ae:	01 c2                	add    %eax,%edx
  8010b0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	01 c8                	add    %ecx,%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010bc:	ff 45 fc             	incl   -0x4(%ebp)
  8010bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010c5:	7c e1                	jl     8010a8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010c7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010ce:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010d5:	eb 1f                	jmp    8010f6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010da:	8d 50 01             	lea    0x1(%eax),%edx
  8010dd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010e0:	89 c2                	mov    %eax,%edx
  8010e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e5:	01 c2                	add    %eax,%edx
  8010e7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ed:	01 c8                	add    %ecx,%eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010f3:	ff 45 f8             	incl   -0x8(%ebp)
  8010f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010fc:	7c d9                	jl     8010d7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801101:	8b 45 10             	mov    0x10(%ebp),%eax
  801104:	01 d0                	add    %edx,%eax
  801106:	c6 00 00             	movb   $0x0,(%eax)
}
  801109:	90                   	nop
  80110a:	c9                   	leave  
  80110b:	c3                   	ret    

0080110c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80110f:	8b 45 14             	mov    0x14(%ebp),%eax
  801112:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801118:	8b 45 14             	mov    0x14(%ebp),%eax
  80111b:	8b 00                	mov    (%eax),%eax
  80111d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801124:	8b 45 10             	mov    0x10(%ebp),%eax
  801127:	01 d0                	add    %edx,%eax
  801129:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80112f:	eb 0c                	jmp    80113d <strsplit+0x31>
			*string++ = 0;
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	8d 50 01             	lea    0x1(%eax),%edx
  801137:	89 55 08             	mov    %edx,0x8(%ebp)
  80113a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
  801140:	8a 00                	mov    (%eax),%al
  801142:	84 c0                	test   %al,%al
  801144:	74 18                	je     80115e <strsplit+0x52>
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	8a 00                	mov    (%eax),%al
  80114b:	0f be c0             	movsbl %al,%eax
  80114e:	50                   	push   %eax
  80114f:	ff 75 0c             	pushl  0xc(%ebp)
  801152:	e8 32 fb ff ff       	call   800c89 <strchr>
  801157:	83 c4 08             	add    $0x8,%esp
  80115a:	85 c0                	test   %eax,%eax
  80115c:	75 d3                	jne    801131 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	84 c0                	test   %al,%al
  801165:	74 5a                	je     8011c1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801167:	8b 45 14             	mov    0x14(%ebp),%eax
  80116a:	8b 00                	mov    (%eax),%eax
  80116c:	83 f8 0f             	cmp    $0xf,%eax
  80116f:	75 07                	jne    801178 <strsplit+0x6c>
		{
			return 0;
  801171:	b8 00 00 00 00       	mov    $0x0,%eax
  801176:	eb 66                	jmp    8011de <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801178:	8b 45 14             	mov    0x14(%ebp),%eax
  80117b:	8b 00                	mov    (%eax),%eax
  80117d:	8d 48 01             	lea    0x1(%eax),%ecx
  801180:	8b 55 14             	mov    0x14(%ebp),%edx
  801183:	89 0a                	mov    %ecx,(%edx)
  801185:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80118c:	8b 45 10             	mov    0x10(%ebp),%eax
  80118f:	01 c2                	add    %eax,%edx
  801191:	8b 45 08             	mov    0x8(%ebp),%eax
  801194:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801196:	eb 03                	jmp    80119b <strsplit+0x8f>
			string++;
  801198:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	84 c0                	test   %al,%al
  8011a2:	74 8b                	je     80112f <strsplit+0x23>
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	8a 00                	mov    (%eax),%al
  8011a9:	0f be c0             	movsbl %al,%eax
  8011ac:	50                   	push   %eax
  8011ad:	ff 75 0c             	pushl  0xc(%ebp)
  8011b0:	e8 d4 fa ff ff       	call   800c89 <strchr>
  8011b5:	83 c4 08             	add    $0x8,%esp
  8011b8:	85 c0                	test   %eax,%eax
  8011ba:	74 dc                	je     801198 <strsplit+0x8c>
			string++;
	}
  8011bc:	e9 6e ff ff ff       	jmp    80112f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011c1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c5:	8b 00                	mov    (%eax),%eax
  8011c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d1:	01 d0                	add    %edx,%eax
  8011d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011d9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8011e6:	83 ec 04             	sub    $0x4,%esp
  8011e9:	68 88 21 80 00       	push   $0x802188
  8011ee:	68 3f 01 00 00       	push   $0x13f
  8011f3:	68 aa 21 80 00       	push   $0x8021aa
  8011f8:	e8 a9 ef ff ff       	call   8001a6 <_panic>

008011fd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	57                   	push   %edi
  801201:	56                   	push   %esi
  801202:	53                   	push   %ebx
  801203:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8b 55 0c             	mov    0xc(%ebp),%edx
  80120c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80120f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801212:	8b 7d 18             	mov    0x18(%ebp),%edi
  801215:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801218:	cd 30                	int    $0x30
  80121a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80121d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801220:	83 c4 10             	add    $0x10,%esp
  801223:	5b                   	pop    %ebx
  801224:	5e                   	pop    %esi
  801225:	5f                   	pop    %edi
  801226:	5d                   	pop    %ebp
  801227:	c3                   	ret    

00801228 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
  80122b:	83 ec 04             	sub    $0x4,%esp
  80122e:	8b 45 10             	mov    0x10(%ebp),%eax
  801231:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801234:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	6a 00                	push   $0x0
  80123d:	6a 00                	push   $0x0
  80123f:	52                   	push   %edx
  801240:	ff 75 0c             	pushl  0xc(%ebp)
  801243:	50                   	push   %eax
  801244:	6a 00                	push   $0x0
  801246:	e8 b2 ff ff ff       	call   8011fd <syscall>
  80124b:	83 c4 18             	add    $0x18,%esp
}
  80124e:	90                   	nop
  80124f:	c9                   	leave  
  801250:	c3                   	ret    

00801251 <sys_cgetc>:

int
sys_cgetc(void)
{
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801254:	6a 00                	push   $0x0
  801256:	6a 00                	push   $0x0
  801258:	6a 00                	push   $0x0
  80125a:	6a 00                	push   $0x0
  80125c:	6a 00                	push   $0x0
  80125e:	6a 02                	push   $0x2
  801260:	e8 98 ff ff ff       	call   8011fd <syscall>
  801265:	83 c4 18             	add    $0x18,%esp
}
  801268:	c9                   	leave  
  801269:	c3                   	ret    

0080126a <sys_lock_cons>:

void sys_lock_cons(void)
{
  80126a:	55                   	push   %ebp
  80126b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80126d:	6a 00                	push   $0x0
  80126f:	6a 00                	push   $0x0
  801271:	6a 00                	push   $0x0
  801273:	6a 00                	push   $0x0
  801275:	6a 00                	push   $0x0
  801277:	6a 03                	push   $0x3
  801279:	e8 7f ff ff ff       	call   8011fd <syscall>
  80127e:	83 c4 18             	add    $0x18,%esp
}
  801281:	90                   	nop
  801282:	c9                   	leave  
  801283:	c3                   	ret    

00801284 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801287:	6a 00                	push   $0x0
  801289:	6a 00                	push   $0x0
  80128b:	6a 00                	push   $0x0
  80128d:	6a 00                	push   $0x0
  80128f:	6a 00                	push   $0x0
  801291:	6a 04                	push   $0x4
  801293:	e8 65 ff ff ff       	call   8011fd <syscall>
  801298:	83 c4 18             	add    $0x18,%esp
}
  80129b:	90                   	nop
  80129c:	c9                   	leave  
  80129d:	c3                   	ret    

0080129e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	6a 00                	push   $0x0
  8012a9:	6a 00                	push   $0x0
  8012ab:	6a 00                	push   $0x0
  8012ad:	52                   	push   %edx
  8012ae:	50                   	push   %eax
  8012af:	6a 08                	push   $0x8
  8012b1:	e8 47 ff ff ff       	call   8011fd <syscall>
  8012b6:	83 c4 18             	add    $0x18,%esp
}
  8012b9:	c9                   	leave  
  8012ba:	c3                   	ret    

008012bb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	56                   	push   %esi
  8012bf:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012c0:	8b 75 18             	mov    0x18(%ebp),%esi
  8012c3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	56                   	push   %esi
  8012d0:	53                   	push   %ebx
  8012d1:	51                   	push   %ecx
  8012d2:	52                   	push   %edx
  8012d3:	50                   	push   %eax
  8012d4:	6a 09                	push   $0x9
  8012d6:	e8 22 ff ff ff       	call   8011fd <syscall>
  8012db:	83 c4 18             	add    $0x18,%esp
}
  8012de:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e1:	5b                   	pop    %ebx
  8012e2:	5e                   	pop    %esi
  8012e3:	5d                   	pop    %ebp
  8012e4:	c3                   	ret    

008012e5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	6a 00                	push   $0x0
  8012f0:	6a 00                	push   $0x0
  8012f2:	6a 00                	push   $0x0
  8012f4:	52                   	push   %edx
  8012f5:	50                   	push   %eax
  8012f6:	6a 0a                	push   $0xa
  8012f8:	e8 00 ff ff ff       	call   8011fd <syscall>
  8012fd:	83 c4 18             	add    $0x18,%esp
}
  801300:	c9                   	leave  
  801301:	c3                   	ret    

00801302 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801302:	55                   	push   %ebp
  801303:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801305:	6a 00                	push   $0x0
  801307:	6a 00                	push   $0x0
  801309:	6a 00                	push   $0x0
  80130b:	ff 75 0c             	pushl  0xc(%ebp)
  80130e:	ff 75 08             	pushl  0x8(%ebp)
  801311:	6a 0b                	push   $0xb
  801313:	e8 e5 fe ff ff       	call   8011fd <syscall>
  801318:	83 c4 18             	add    $0x18,%esp
}
  80131b:	c9                   	leave  
  80131c:	c3                   	ret    

0080131d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801320:	6a 00                	push   $0x0
  801322:	6a 00                	push   $0x0
  801324:	6a 00                	push   $0x0
  801326:	6a 00                	push   $0x0
  801328:	6a 00                	push   $0x0
  80132a:	6a 0c                	push   $0xc
  80132c:	e8 cc fe ff ff       	call   8011fd <syscall>
  801331:	83 c4 18             	add    $0x18,%esp
}
  801334:	c9                   	leave  
  801335:	c3                   	ret    

00801336 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801336:	55                   	push   %ebp
  801337:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801339:	6a 00                	push   $0x0
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	6a 0d                	push   $0xd
  801345:	e8 b3 fe ff ff       	call   8011fd <syscall>
  80134a:	83 c4 18             	add    $0x18,%esp
}
  80134d:	c9                   	leave  
  80134e:	c3                   	ret    

0080134f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801352:	6a 00                	push   $0x0
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	6a 00                	push   $0x0
  80135a:	6a 00                	push   $0x0
  80135c:	6a 0e                	push   $0xe
  80135e:	e8 9a fe ff ff       	call   8011fd <syscall>
  801363:	83 c4 18             	add    $0x18,%esp
}
  801366:	c9                   	leave  
  801367:	c3                   	ret    

00801368 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801368:	55                   	push   %ebp
  801369:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80136b:	6a 00                	push   $0x0
  80136d:	6a 00                	push   $0x0
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	6a 00                	push   $0x0
  801375:	6a 0f                	push   $0xf
  801377:	e8 81 fe ff ff       	call   8011fd <syscall>
  80137c:	83 c4 18             	add    $0x18,%esp
}
  80137f:	c9                   	leave  
  801380:	c3                   	ret    

00801381 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801384:	6a 00                	push   $0x0
  801386:	6a 00                	push   $0x0
  801388:	6a 00                	push   $0x0
  80138a:	6a 00                	push   $0x0
  80138c:	ff 75 08             	pushl  0x8(%ebp)
  80138f:	6a 10                	push   $0x10
  801391:	e8 67 fe ff ff       	call   8011fd <syscall>
  801396:	83 c4 18             	add    $0x18,%esp
}
  801399:	c9                   	leave  
  80139a:	c3                   	ret    

0080139b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 11                	push   $0x11
  8013aa:	e8 4e fe ff ff       	call   8011fd <syscall>
  8013af:	83 c4 18             	add    $0x18,%esp
}
  8013b2:	90                   	nop
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    

008013b5 <sys_cputc>:

void
sys_cputc(const char c)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
  8013b8:	83 ec 04             	sub    $0x4,%esp
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013c1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 00                	push   $0x0
  8013cd:	50                   	push   %eax
  8013ce:	6a 01                	push   $0x1
  8013d0:	e8 28 fe ff ff       	call   8011fd <syscall>
  8013d5:	83 c4 18             	add    $0x18,%esp
}
  8013d8:	90                   	nop
  8013d9:	c9                   	leave  
  8013da:	c3                   	ret    

008013db <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 14                	push   $0x14
  8013ea:	e8 0e fe ff ff       	call   8011fd <syscall>
  8013ef:	83 c4 18             	add    $0x18,%esp
}
  8013f2:	90                   	nop
  8013f3:	c9                   	leave  
  8013f4:	c3                   	ret    

008013f5 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
  8013f8:	83 ec 04             	sub    $0x4,%esp
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801401:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801404:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	6a 00                	push   $0x0
  80140d:	51                   	push   %ecx
  80140e:	52                   	push   %edx
  80140f:	ff 75 0c             	pushl  0xc(%ebp)
  801412:	50                   	push   %eax
  801413:	6a 15                	push   $0x15
  801415:	e8 e3 fd ff ff       	call   8011fd <syscall>
  80141a:	83 c4 18             	add    $0x18,%esp
}
  80141d:	c9                   	leave  
  80141e:	c3                   	ret    

0080141f <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801422:	8b 55 0c             	mov    0xc(%ebp),%edx
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	52                   	push   %edx
  80142f:	50                   	push   %eax
  801430:	6a 16                	push   $0x16
  801432:	e8 c6 fd ff ff       	call   8011fd <syscall>
  801437:	83 c4 18             	add    $0x18,%esp
}
  80143a:	c9                   	leave  
  80143b:	c3                   	ret    

0080143c <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80143f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801442:	8b 55 0c             	mov    0xc(%ebp),%edx
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	51                   	push   %ecx
  80144d:	52                   	push   %edx
  80144e:	50                   	push   %eax
  80144f:	6a 17                	push   $0x17
  801451:	e8 a7 fd ff ff       	call   8011fd <syscall>
  801456:	83 c4 18             	add    $0x18,%esp
}
  801459:	c9                   	leave  
  80145a:	c3                   	ret    

0080145b <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80145e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	6a 00                	push   $0x0
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	52                   	push   %edx
  80146b:	50                   	push   %eax
  80146c:	6a 18                	push   $0x18
  80146e:	e8 8a fd ff ff       	call   8011fd <syscall>
  801473:	83 c4 18             	add    $0x18,%esp
}
  801476:	c9                   	leave  
  801477:	c3                   	ret    

00801478 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801478:	55                   	push   %ebp
  801479:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
  80147e:	6a 00                	push   $0x0
  801480:	ff 75 14             	pushl  0x14(%ebp)
  801483:	ff 75 10             	pushl  0x10(%ebp)
  801486:	ff 75 0c             	pushl  0xc(%ebp)
  801489:	50                   	push   %eax
  80148a:	6a 19                	push   $0x19
  80148c:	e8 6c fd ff ff       	call   8011fd <syscall>
  801491:	83 c4 18             	add    $0x18,%esp
}
  801494:	c9                   	leave  
  801495:	c3                   	ret    

00801496 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	50                   	push   %eax
  8014a5:	6a 1a                	push   $0x1a
  8014a7:	e8 51 fd ff ff       	call   8011fd <syscall>
  8014ac:	83 c4 18             	add    $0x18,%esp
}
  8014af:	90                   	nop
  8014b0:	c9                   	leave  
  8014b1:	c3                   	ret    

008014b2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014b2:	55                   	push   %ebp
  8014b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	50                   	push   %eax
  8014c1:	6a 1b                	push   $0x1b
  8014c3:	e8 35 fd ff ff       	call   8011fd <syscall>
  8014c8:	83 c4 18             	add    $0x18,%esp
}
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    

008014cd <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 05                	push   $0x5
  8014dc:	e8 1c fd ff ff       	call   8011fd <syscall>
  8014e1:	83 c4 18             	add    $0x18,%esp
}
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 06                	push   $0x6
  8014f5:	e8 03 fd ff ff       	call   8011fd <syscall>
  8014fa:	83 c4 18             	add    $0x18,%esp
}
  8014fd:	c9                   	leave  
  8014fe:	c3                   	ret    

008014ff <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 07                	push   $0x7
  80150e:	e8 ea fc ff ff       	call   8011fd <syscall>
  801513:	83 c4 18             	add    $0x18,%esp
}
  801516:	c9                   	leave  
  801517:	c3                   	ret    

00801518 <sys_exit_env>:


void sys_exit_env(void)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80151b:	6a 00                	push   $0x0
  80151d:	6a 00                	push   $0x0
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	6a 1c                	push   $0x1c
  801527:	e8 d1 fc ff ff       	call   8011fd <syscall>
  80152c:	83 c4 18             	add    $0x18,%esp
}
  80152f:	90                   	nop
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801538:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80153b:	8d 50 04             	lea    0x4(%eax),%edx
  80153e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	52                   	push   %edx
  801548:	50                   	push   %eax
  801549:	6a 1d                	push   $0x1d
  80154b:	e8 ad fc ff ff       	call   8011fd <syscall>
  801550:	83 c4 18             	add    $0x18,%esp
	return result;
  801553:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801556:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801559:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80155c:	89 01                	mov    %eax,(%ecx)
  80155e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	c9                   	leave  
  801565:	c2 04 00             	ret    $0x4

00801568 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	ff 75 10             	pushl  0x10(%ebp)
  801572:	ff 75 0c             	pushl  0xc(%ebp)
  801575:	ff 75 08             	pushl  0x8(%ebp)
  801578:	6a 13                	push   $0x13
  80157a:	e8 7e fc ff ff       	call   8011fd <syscall>
  80157f:	83 c4 18             	add    $0x18,%esp
	return ;
  801582:	90                   	nop
}
  801583:	c9                   	leave  
  801584:	c3                   	ret    

00801585 <sys_rcr2>:
uint32 sys_rcr2()
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 1e                	push   $0x1e
  801594:	e8 64 fc ff ff       	call   8011fd <syscall>
  801599:	83 c4 18             	add    $0x18,%esp
}
  80159c:	c9                   	leave  
  80159d:	c3                   	ret    

0080159e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
  8015a1:	83 ec 04             	sub    $0x4,%esp
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015aa:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	50                   	push   %eax
  8015b7:	6a 1f                	push   $0x1f
  8015b9:	e8 3f fc ff ff       	call   8011fd <syscall>
  8015be:	83 c4 18             	add    $0x18,%esp
	return ;
  8015c1:	90                   	nop
}
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <rsttst>:
void rsttst()
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 21                	push   $0x21
  8015d3:	e8 25 fc ff ff       	call   8011fd <syscall>
  8015d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8015db:	90                   	nop
}
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	83 ec 04             	sub    $0x4,%esp
  8015e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015ea:	8b 55 18             	mov    0x18(%ebp),%edx
  8015ed:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015f1:	52                   	push   %edx
  8015f2:	50                   	push   %eax
  8015f3:	ff 75 10             	pushl  0x10(%ebp)
  8015f6:	ff 75 0c             	pushl  0xc(%ebp)
  8015f9:	ff 75 08             	pushl  0x8(%ebp)
  8015fc:	6a 20                	push   $0x20
  8015fe:	e8 fa fb ff ff       	call   8011fd <syscall>
  801603:	83 c4 18             	add    $0x18,%esp
	return ;
  801606:	90                   	nop
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <chktst>:
void chktst(uint32 n)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	ff 75 08             	pushl  0x8(%ebp)
  801617:	6a 22                	push   $0x22
  801619:	e8 df fb ff ff       	call   8011fd <syscall>
  80161e:	83 c4 18             	add    $0x18,%esp
	return ;
  801621:	90                   	nop
}
  801622:	c9                   	leave  
  801623:	c3                   	ret    

00801624 <inctst>:

void inctst()
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 23                	push   $0x23
  801633:	e8 c5 fb ff ff       	call   8011fd <syscall>
  801638:	83 c4 18             	add    $0x18,%esp
	return ;
  80163b:	90                   	nop
}
  80163c:	c9                   	leave  
  80163d:	c3                   	ret    

0080163e <gettst>:
uint32 gettst()
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 24                	push   $0x24
  80164d:	e8 ab fb ff ff       	call   8011fd <syscall>
  801652:	83 c4 18             	add    $0x18,%esp
}
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 25                	push   $0x25
  801669:	e8 8f fb ff ff       	call   8011fd <syscall>
  80166e:	83 c4 18             	add    $0x18,%esp
  801671:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801674:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801678:	75 07                	jne    801681 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80167a:	b8 01 00 00 00       	mov    $0x1,%eax
  80167f:	eb 05                	jmp    801686 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801681:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 25                	push   $0x25
  80169a:	e8 5e fb ff ff       	call   8011fd <syscall>
  80169f:	83 c4 18             	add    $0x18,%esp
  8016a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016a5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016a9:	75 07                	jne    8016b2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8016b0:	eb 05                	jmp    8016b7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
  8016bc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 25                	push   $0x25
  8016cb:	e8 2d fb ff ff       	call   8011fd <syscall>
  8016d0:	83 c4 18             	add    $0x18,%esp
  8016d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016d6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016da:	75 07                	jne    8016e3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016dc:	b8 01 00 00 00       	mov    $0x1,%eax
  8016e1:	eb 05                	jmp    8016e8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    

008016ea <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
  8016ed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 25                	push   $0x25
  8016fc:	e8 fc fa ff ff       	call   8011fd <syscall>
  801701:	83 c4 18             	add    $0x18,%esp
  801704:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801707:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80170b:	75 07                	jne    801714 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80170d:	b8 01 00 00 00       	mov    $0x1,%eax
  801712:	eb 05                	jmp    801719 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801714:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801719:	c9                   	leave  
  80171a:	c3                   	ret    

0080171b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	ff 75 08             	pushl  0x8(%ebp)
  801729:	6a 26                	push   $0x26
  80172b:	e8 cd fa ff ff       	call   8011fd <syscall>
  801730:	83 c4 18             	add    $0x18,%esp
	return ;
  801733:	90                   	nop
}
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80173a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80173d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801740:	8b 55 0c             	mov    0xc(%ebp),%edx
  801743:	8b 45 08             	mov    0x8(%ebp),%eax
  801746:	6a 00                	push   $0x0
  801748:	53                   	push   %ebx
  801749:	51                   	push   %ecx
  80174a:	52                   	push   %edx
  80174b:	50                   	push   %eax
  80174c:	6a 27                	push   $0x27
  80174e:	e8 aa fa ff ff       	call   8011fd <syscall>
  801753:	83 c4 18             	add    $0x18,%esp
}
  801756:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801759:	c9                   	leave  
  80175a:	c3                   	ret    

0080175b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80175e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801761:	8b 45 08             	mov    0x8(%ebp),%eax
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	52                   	push   %edx
  80176b:	50                   	push   %eax
  80176c:	6a 28                	push   $0x28
  80176e:	e8 8a fa ff ff       	call   8011fd <syscall>
  801773:	83 c4 18             	add    $0x18,%esp
}
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80177b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80177e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	6a 00                	push   $0x0
  801786:	51                   	push   %ecx
  801787:	ff 75 10             	pushl  0x10(%ebp)
  80178a:	52                   	push   %edx
  80178b:	50                   	push   %eax
  80178c:	6a 29                	push   $0x29
  80178e:	e8 6a fa ff ff       	call   8011fd <syscall>
  801793:	83 c4 18             	add    $0x18,%esp
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	ff 75 10             	pushl  0x10(%ebp)
  8017a2:	ff 75 0c             	pushl  0xc(%ebp)
  8017a5:	ff 75 08             	pushl  0x8(%ebp)
  8017a8:	6a 12                	push   $0x12
  8017aa:	e8 4e fa ff ff       	call   8011fd <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b2:	90                   	nop
}
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8017b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	52                   	push   %edx
  8017c5:	50                   	push   %eax
  8017c6:	6a 2a                	push   $0x2a
  8017c8:	e8 30 fa ff ff       	call   8011fd <syscall>
  8017cd:	83 c4 18             	add    $0x18,%esp
	return;
  8017d0:	90                   	nop
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	50                   	push   %eax
  8017e2:	6a 2b                	push   $0x2b
  8017e4:	e8 14 fa ff ff       	call   8011fd <syscall>
  8017e9:	83 c4 18             	add    $0x18,%esp
}
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    

008017ee <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	ff 75 0c             	pushl  0xc(%ebp)
  8017fa:	ff 75 08             	pushl  0x8(%ebp)
  8017fd:	6a 2c                	push   $0x2c
  8017ff:	e8 f9 f9 ff ff       	call   8011fd <syscall>
  801804:	83 c4 18             	add    $0x18,%esp
	return;
  801807:	90                   	nop
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	ff 75 0c             	pushl  0xc(%ebp)
  801816:	ff 75 08             	pushl  0x8(%ebp)
  801819:	6a 2d                	push   $0x2d
  80181b:	e8 dd f9 ff ff       	call   8011fd <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
	return;
  801823:	90                   	nop
}
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 2e                	push   $0x2e
  801838:	e8 c0 f9 ff ff       	call   8011fd <syscall>
  80183d:	83 c4 18             	add    $0x18,%esp
  801840:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801843:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	50                   	push   %eax
  801857:	6a 2f                	push   $0x2f
  801859:	e8 9f f9 ff ff       	call   8011fd <syscall>
  80185e:	83 c4 18             	add    $0x18,%esp
	return;
  801861:	90                   	nop
}
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  801867:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186a:	8b 45 08             	mov    0x8(%ebp),%eax
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	52                   	push   %edx
  801874:	50                   	push   %eax
  801875:	6a 30                	push   $0x30
  801877:	e8 81 f9 ff ff       	call   8011fd <syscall>
  80187c:	83 c4 18             	add    $0x18,%esp
	return;
  80187f:	90                   	nop
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	50                   	push   %eax
  801894:	6a 31                	push   $0x31
  801896:	e8 62 f9 ff ff       	call   8011fd <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
  80189e:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  8018a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	50                   	push   %eax
  8018b5:	6a 32                	push   $0x32
  8018b7:	e8 41 f9 ff ff       	call   8011fd <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
	return;
  8018bf:	90                   	nop
}
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    
  8018c2:	66 90                	xchg   %ax,%ax

008018c4 <__udivdi3>:
  8018c4:	55                   	push   %ebp
  8018c5:	57                   	push   %edi
  8018c6:	56                   	push   %esi
  8018c7:	53                   	push   %ebx
  8018c8:	83 ec 1c             	sub    $0x1c,%esp
  8018cb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8018cf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8018d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018d7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018db:	89 ca                	mov    %ecx,%edx
  8018dd:	89 f8                	mov    %edi,%eax
  8018df:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8018e3:	85 f6                	test   %esi,%esi
  8018e5:	75 2d                	jne    801914 <__udivdi3+0x50>
  8018e7:	39 cf                	cmp    %ecx,%edi
  8018e9:	77 65                	ja     801950 <__udivdi3+0x8c>
  8018eb:	89 fd                	mov    %edi,%ebp
  8018ed:	85 ff                	test   %edi,%edi
  8018ef:	75 0b                	jne    8018fc <__udivdi3+0x38>
  8018f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8018f6:	31 d2                	xor    %edx,%edx
  8018f8:	f7 f7                	div    %edi
  8018fa:	89 c5                	mov    %eax,%ebp
  8018fc:	31 d2                	xor    %edx,%edx
  8018fe:	89 c8                	mov    %ecx,%eax
  801900:	f7 f5                	div    %ebp
  801902:	89 c1                	mov    %eax,%ecx
  801904:	89 d8                	mov    %ebx,%eax
  801906:	f7 f5                	div    %ebp
  801908:	89 cf                	mov    %ecx,%edi
  80190a:	89 fa                	mov    %edi,%edx
  80190c:	83 c4 1c             	add    $0x1c,%esp
  80190f:	5b                   	pop    %ebx
  801910:	5e                   	pop    %esi
  801911:	5f                   	pop    %edi
  801912:	5d                   	pop    %ebp
  801913:	c3                   	ret    
  801914:	39 ce                	cmp    %ecx,%esi
  801916:	77 28                	ja     801940 <__udivdi3+0x7c>
  801918:	0f bd fe             	bsr    %esi,%edi
  80191b:	83 f7 1f             	xor    $0x1f,%edi
  80191e:	75 40                	jne    801960 <__udivdi3+0x9c>
  801920:	39 ce                	cmp    %ecx,%esi
  801922:	72 0a                	jb     80192e <__udivdi3+0x6a>
  801924:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801928:	0f 87 9e 00 00 00    	ja     8019cc <__udivdi3+0x108>
  80192e:	b8 01 00 00 00       	mov    $0x1,%eax
  801933:	89 fa                	mov    %edi,%edx
  801935:	83 c4 1c             	add    $0x1c,%esp
  801938:	5b                   	pop    %ebx
  801939:	5e                   	pop    %esi
  80193a:	5f                   	pop    %edi
  80193b:	5d                   	pop    %ebp
  80193c:	c3                   	ret    
  80193d:	8d 76 00             	lea    0x0(%esi),%esi
  801940:	31 ff                	xor    %edi,%edi
  801942:	31 c0                	xor    %eax,%eax
  801944:	89 fa                	mov    %edi,%edx
  801946:	83 c4 1c             	add    $0x1c,%esp
  801949:	5b                   	pop    %ebx
  80194a:	5e                   	pop    %esi
  80194b:	5f                   	pop    %edi
  80194c:	5d                   	pop    %ebp
  80194d:	c3                   	ret    
  80194e:	66 90                	xchg   %ax,%ax
  801950:	89 d8                	mov    %ebx,%eax
  801952:	f7 f7                	div    %edi
  801954:	31 ff                	xor    %edi,%edi
  801956:	89 fa                	mov    %edi,%edx
  801958:	83 c4 1c             	add    $0x1c,%esp
  80195b:	5b                   	pop    %ebx
  80195c:	5e                   	pop    %esi
  80195d:	5f                   	pop    %edi
  80195e:	5d                   	pop    %ebp
  80195f:	c3                   	ret    
  801960:	bd 20 00 00 00       	mov    $0x20,%ebp
  801965:	89 eb                	mov    %ebp,%ebx
  801967:	29 fb                	sub    %edi,%ebx
  801969:	89 f9                	mov    %edi,%ecx
  80196b:	d3 e6                	shl    %cl,%esi
  80196d:	89 c5                	mov    %eax,%ebp
  80196f:	88 d9                	mov    %bl,%cl
  801971:	d3 ed                	shr    %cl,%ebp
  801973:	89 e9                	mov    %ebp,%ecx
  801975:	09 f1                	or     %esi,%ecx
  801977:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80197b:	89 f9                	mov    %edi,%ecx
  80197d:	d3 e0                	shl    %cl,%eax
  80197f:	89 c5                	mov    %eax,%ebp
  801981:	89 d6                	mov    %edx,%esi
  801983:	88 d9                	mov    %bl,%cl
  801985:	d3 ee                	shr    %cl,%esi
  801987:	89 f9                	mov    %edi,%ecx
  801989:	d3 e2                	shl    %cl,%edx
  80198b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80198f:	88 d9                	mov    %bl,%cl
  801991:	d3 e8                	shr    %cl,%eax
  801993:	09 c2                	or     %eax,%edx
  801995:	89 d0                	mov    %edx,%eax
  801997:	89 f2                	mov    %esi,%edx
  801999:	f7 74 24 0c          	divl   0xc(%esp)
  80199d:	89 d6                	mov    %edx,%esi
  80199f:	89 c3                	mov    %eax,%ebx
  8019a1:	f7 e5                	mul    %ebp
  8019a3:	39 d6                	cmp    %edx,%esi
  8019a5:	72 19                	jb     8019c0 <__udivdi3+0xfc>
  8019a7:	74 0b                	je     8019b4 <__udivdi3+0xf0>
  8019a9:	89 d8                	mov    %ebx,%eax
  8019ab:	31 ff                	xor    %edi,%edi
  8019ad:	e9 58 ff ff ff       	jmp    80190a <__udivdi3+0x46>
  8019b2:	66 90                	xchg   %ax,%ax
  8019b4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8019b8:	89 f9                	mov    %edi,%ecx
  8019ba:	d3 e2                	shl    %cl,%edx
  8019bc:	39 c2                	cmp    %eax,%edx
  8019be:	73 e9                	jae    8019a9 <__udivdi3+0xe5>
  8019c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8019c3:	31 ff                	xor    %edi,%edi
  8019c5:	e9 40 ff ff ff       	jmp    80190a <__udivdi3+0x46>
  8019ca:	66 90                	xchg   %ax,%ax
  8019cc:	31 c0                	xor    %eax,%eax
  8019ce:	e9 37 ff ff ff       	jmp    80190a <__udivdi3+0x46>
  8019d3:	90                   	nop

008019d4 <__umoddi3>:
  8019d4:	55                   	push   %ebp
  8019d5:	57                   	push   %edi
  8019d6:	56                   	push   %esi
  8019d7:	53                   	push   %ebx
  8019d8:	83 ec 1c             	sub    $0x1c,%esp
  8019db:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8019df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8019e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019e7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8019eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019ef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019f3:	89 f3                	mov    %esi,%ebx
  8019f5:	89 fa                	mov    %edi,%edx
  8019f7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019fb:	89 34 24             	mov    %esi,(%esp)
  8019fe:	85 c0                	test   %eax,%eax
  801a00:	75 1a                	jne    801a1c <__umoddi3+0x48>
  801a02:	39 f7                	cmp    %esi,%edi
  801a04:	0f 86 a2 00 00 00    	jbe    801aac <__umoddi3+0xd8>
  801a0a:	89 c8                	mov    %ecx,%eax
  801a0c:	89 f2                	mov    %esi,%edx
  801a0e:	f7 f7                	div    %edi
  801a10:	89 d0                	mov    %edx,%eax
  801a12:	31 d2                	xor    %edx,%edx
  801a14:	83 c4 1c             	add    $0x1c,%esp
  801a17:	5b                   	pop    %ebx
  801a18:	5e                   	pop    %esi
  801a19:	5f                   	pop    %edi
  801a1a:	5d                   	pop    %ebp
  801a1b:	c3                   	ret    
  801a1c:	39 f0                	cmp    %esi,%eax
  801a1e:	0f 87 ac 00 00 00    	ja     801ad0 <__umoddi3+0xfc>
  801a24:	0f bd e8             	bsr    %eax,%ebp
  801a27:	83 f5 1f             	xor    $0x1f,%ebp
  801a2a:	0f 84 ac 00 00 00    	je     801adc <__umoddi3+0x108>
  801a30:	bf 20 00 00 00       	mov    $0x20,%edi
  801a35:	29 ef                	sub    %ebp,%edi
  801a37:	89 fe                	mov    %edi,%esi
  801a39:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a3d:	89 e9                	mov    %ebp,%ecx
  801a3f:	d3 e0                	shl    %cl,%eax
  801a41:	89 d7                	mov    %edx,%edi
  801a43:	89 f1                	mov    %esi,%ecx
  801a45:	d3 ef                	shr    %cl,%edi
  801a47:	09 c7                	or     %eax,%edi
  801a49:	89 e9                	mov    %ebp,%ecx
  801a4b:	d3 e2                	shl    %cl,%edx
  801a4d:	89 14 24             	mov    %edx,(%esp)
  801a50:	89 d8                	mov    %ebx,%eax
  801a52:	d3 e0                	shl    %cl,%eax
  801a54:	89 c2                	mov    %eax,%edx
  801a56:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a5a:	d3 e0                	shl    %cl,%eax
  801a5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a60:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a64:	89 f1                	mov    %esi,%ecx
  801a66:	d3 e8                	shr    %cl,%eax
  801a68:	09 d0                	or     %edx,%eax
  801a6a:	d3 eb                	shr    %cl,%ebx
  801a6c:	89 da                	mov    %ebx,%edx
  801a6e:	f7 f7                	div    %edi
  801a70:	89 d3                	mov    %edx,%ebx
  801a72:	f7 24 24             	mull   (%esp)
  801a75:	89 c6                	mov    %eax,%esi
  801a77:	89 d1                	mov    %edx,%ecx
  801a79:	39 d3                	cmp    %edx,%ebx
  801a7b:	0f 82 87 00 00 00    	jb     801b08 <__umoddi3+0x134>
  801a81:	0f 84 91 00 00 00    	je     801b18 <__umoddi3+0x144>
  801a87:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a8b:	29 f2                	sub    %esi,%edx
  801a8d:	19 cb                	sbb    %ecx,%ebx
  801a8f:	89 d8                	mov    %ebx,%eax
  801a91:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a95:	d3 e0                	shl    %cl,%eax
  801a97:	89 e9                	mov    %ebp,%ecx
  801a99:	d3 ea                	shr    %cl,%edx
  801a9b:	09 d0                	or     %edx,%eax
  801a9d:	89 e9                	mov    %ebp,%ecx
  801a9f:	d3 eb                	shr    %cl,%ebx
  801aa1:	89 da                	mov    %ebx,%edx
  801aa3:	83 c4 1c             	add    $0x1c,%esp
  801aa6:	5b                   	pop    %ebx
  801aa7:	5e                   	pop    %esi
  801aa8:	5f                   	pop    %edi
  801aa9:	5d                   	pop    %ebp
  801aaa:	c3                   	ret    
  801aab:	90                   	nop
  801aac:	89 fd                	mov    %edi,%ebp
  801aae:	85 ff                	test   %edi,%edi
  801ab0:	75 0b                	jne    801abd <__umoddi3+0xe9>
  801ab2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab7:	31 d2                	xor    %edx,%edx
  801ab9:	f7 f7                	div    %edi
  801abb:	89 c5                	mov    %eax,%ebp
  801abd:	89 f0                	mov    %esi,%eax
  801abf:	31 d2                	xor    %edx,%edx
  801ac1:	f7 f5                	div    %ebp
  801ac3:	89 c8                	mov    %ecx,%eax
  801ac5:	f7 f5                	div    %ebp
  801ac7:	89 d0                	mov    %edx,%eax
  801ac9:	e9 44 ff ff ff       	jmp    801a12 <__umoddi3+0x3e>
  801ace:	66 90                	xchg   %ax,%ax
  801ad0:	89 c8                	mov    %ecx,%eax
  801ad2:	89 f2                	mov    %esi,%edx
  801ad4:	83 c4 1c             	add    $0x1c,%esp
  801ad7:	5b                   	pop    %ebx
  801ad8:	5e                   	pop    %esi
  801ad9:	5f                   	pop    %edi
  801ada:	5d                   	pop    %ebp
  801adb:	c3                   	ret    
  801adc:	3b 04 24             	cmp    (%esp),%eax
  801adf:	72 06                	jb     801ae7 <__umoddi3+0x113>
  801ae1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ae5:	77 0f                	ja     801af6 <__umoddi3+0x122>
  801ae7:	89 f2                	mov    %esi,%edx
  801ae9:	29 f9                	sub    %edi,%ecx
  801aeb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801aef:	89 14 24             	mov    %edx,(%esp)
  801af2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801af6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801afa:	8b 14 24             	mov    (%esp),%edx
  801afd:	83 c4 1c             	add    $0x1c,%esp
  801b00:	5b                   	pop    %ebx
  801b01:	5e                   	pop    %esi
  801b02:	5f                   	pop    %edi
  801b03:	5d                   	pop    %ebp
  801b04:	c3                   	ret    
  801b05:	8d 76 00             	lea    0x0(%esi),%esi
  801b08:	2b 04 24             	sub    (%esp),%eax
  801b0b:	19 fa                	sbb    %edi,%edx
  801b0d:	89 d1                	mov    %edx,%ecx
  801b0f:	89 c6                	mov    %eax,%esi
  801b11:	e9 71 ff ff ff       	jmp    801a87 <__umoddi3+0xb3>
  801b16:	66 90                	xchg   %ax,%ax
  801b18:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b1c:	72 ea                	jb     801b08 <__umoddi3+0x134>
  801b1e:	89 d9                	mov    %ebx,%ecx
  801b20:	e9 62 ff ff ff       	jmp    801a87 <__umoddi3+0xb3>
