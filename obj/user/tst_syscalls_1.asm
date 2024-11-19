
obj/user/tst_syscalls_1:     file format elf32-i386


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
  800031:	e8 90 00 00 00       	call   8000c6 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the correct implementation of system calls
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	rsttst();
  80003e:	e8 d8 15 00 00       	call   80161b <rsttst>
	void * ret = sys_sbrk(10);
  800043:	83 ec 0c             	sub    $0xc,%esp
  800046:	6a 0a                	push   $0xa
  800048:	e8 dd 17 00 00       	call   80182a <sys_sbrk>
  80004d:	83 c4 10             	add    $0x10,%esp
  800050:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (ret != (void*)-1)
  800053:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  800057:	74 14                	je     80006d <_main+0x35>
		panic("tst system calls #1 failed: sys_sbrk is not handled correctly");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 00 1b 80 00       	push   $0x801b00
  800061:	6a 0a                	push   $0xa
  800063:	68 3e 1b 80 00       	push   $0x801b3e
  800068:	e8 90 01 00 00       	call   8001fd <_panic>
	sys_allocate_user_mem(USER_HEAP_START,10);
  80006d:	83 ec 08             	sub    $0x8,%esp
  800070:	6a 0a                	push   $0xa
  800072:	68 00 00 00 80       	push   $0x80000000
  800077:	e8 e5 17 00 00       	call   801861 <sys_allocate_user_mem>
  80007c:	83 c4 10             	add    $0x10,%esp
	sys_free_user_mem(USER_HEAP_START + PAGE_SIZE, 10);
  80007f:	83 ec 08             	sub    $0x8,%esp
  800082:	6a 0a                	push   $0xa
  800084:	68 00 10 00 80       	push   $0x80001000
  800089:	e8 b7 17 00 00       	call   801845 <sys_free_user_mem>
  80008e:	83 c4 10             	add    $0x10,%esp
	int ret2 = gettst();
  800091:	e8 ff 15 00 00       	call   801695 <gettst>
  800096:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret2 != 2)
  800099:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  80009d:	74 14                	je     8000b3 <_main+0x7b>
		panic("tst system calls #1 failed: sys_allocate_user_mem and/or sys_free_user_mem are not handled correctly");
  80009f:	83 ec 04             	sub    $0x4,%esp
  8000a2:	68 54 1b 80 00       	push   $0x801b54
  8000a7:	6a 0f                	push   $0xf
  8000a9:	68 3e 1b 80 00       	push   $0x801b3e
  8000ae:	e8 4a 01 00 00       	call   8001fd <_panic>
	cprintf("Congratulations... tst system calls #1 completed successfully");
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	68 bc 1b 80 00       	push   $0x801bbc
  8000bb:	e8 fa 03 00 00       	call   8004ba <cprintf>
  8000c0:	83 c4 10             	add    $0x10,%esp
}
  8000c3:	90                   	nop
  8000c4:	c9                   	leave  
  8000c5:	c3                   	ret    

008000c6 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000c6:	55                   	push   %ebp
  8000c7:	89 e5                	mov    %esp,%ebp
  8000c9:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000cc:	e8 6c 14 00 00       	call   80153d <sys_getenvindex>
  8000d1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000d7:	89 d0                	mov    %edx,%eax
  8000d9:	c1 e0 02             	shl    $0x2,%eax
  8000dc:	01 d0                	add    %edx,%eax
  8000de:	01 c0                	add    %eax,%eax
  8000e0:	01 d0                	add    %edx,%eax
  8000e2:	c1 e0 02             	shl    $0x2,%eax
  8000e5:	01 d0                	add    %edx,%eax
  8000e7:	01 c0                	add    %eax,%eax
  8000e9:	01 d0                	add    %edx,%eax
  8000eb:	c1 e0 04             	shl    $0x4,%eax
  8000ee:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000f3:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000f8:	a1 04 30 80 00       	mov    0x803004,%eax
  8000fd:	8a 40 20             	mov    0x20(%eax),%al
  800100:	84 c0                	test   %al,%al
  800102:	74 0d                	je     800111 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800104:	a1 04 30 80 00       	mov    0x803004,%eax
  800109:	83 c0 20             	add    $0x20,%eax
  80010c:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800111:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800115:	7e 0a                	jle    800121 <libmain+0x5b>
		binaryname = argv[0];
  800117:	8b 45 0c             	mov    0xc(%ebp),%eax
  80011a:	8b 00                	mov    (%eax),%eax
  80011c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800121:	83 ec 08             	sub    $0x8,%esp
  800124:	ff 75 0c             	pushl  0xc(%ebp)
  800127:	ff 75 08             	pushl  0x8(%ebp)
  80012a:	e8 09 ff ff ff       	call   800038 <_main>
  80012f:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800132:	e8 8a 11 00 00       	call   8012c1 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	68 14 1c 80 00       	push   $0x801c14
  80013f:	e8 76 03 00 00       	call   8004ba <cprintf>
  800144:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800147:	a1 04 30 80 00       	mov    0x803004,%eax
  80014c:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800152:	a1 04 30 80 00       	mov    0x803004,%eax
  800157:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80015d:	83 ec 04             	sub    $0x4,%esp
  800160:	52                   	push   %edx
  800161:	50                   	push   %eax
  800162:	68 3c 1c 80 00       	push   $0x801c3c
  800167:	e8 4e 03 00 00       	call   8004ba <cprintf>
  80016c:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80016f:	a1 04 30 80 00       	mov    0x803004,%eax
  800174:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  80017a:	a1 04 30 80 00       	mov    0x803004,%eax
  80017f:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800185:	a1 04 30 80 00       	mov    0x803004,%eax
  80018a:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800190:	51                   	push   %ecx
  800191:	52                   	push   %edx
  800192:	50                   	push   %eax
  800193:	68 64 1c 80 00       	push   $0x801c64
  800198:	e8 1d 03 00 00       	call   8004ba <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001a0:	a1 04 30 80 00       	mov    0x803004,%eax
  8001a5:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8001ab:	83 ec 08             	sub    $0x8,%esp
  8001ae:	50                   	push   %eax
  8001af:	68 bc 1c 80 00       	push   $0x801cbc
  8001b4:	e8 01 03 00 00       	call   8004ba <cprintf>
  8001b9:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	68 14 1c 80 00       	push   $0x801c14
  8001c4:	e8 f1 02 00 00       	call   8004ba <cprintf>
  8001c9:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8001cc:	e8 0a 11 00 00       	call   8012db <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8001d1:	e8 19 00 00 00       	call   8001ef <exit>
}
  8001d6:	90                   	nop
  8001d7:	c9                   	leave  
  8001d8:	c3                   	ret    

008001d9 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001d9:	55                   	push   %ebp
  8001da:	89 e5                	mov    %esp,%ebp
  8001dc:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001df:	83 ec 0c             	sub    $0xc,%esp
  8001e2:	6a 00                	push   $0x0
  8001e4:	e8 20 13 00 00       	call   801509 <sys_destroy_env>
  8001e9:	83 c4 10             	add    $0x10,%esp
}
  8001ec:	90                   	nop
  8001ed:	c9                   	leave  
  8001ee:	c3                   	ret    

008001ef <exit>:

void
exit(void)
{
  8001ef:	55                   	push   %ebp
  8001f0:	89 e5                	mov    %esp,%ebp
  8001f2:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001f5:	e8 75 13 00 00       	call   80156f <sys_exit_env>
}
  8001fa:	90                   	nop
  8001fb:	c9                   	leave  
  8001fc:	c3                   	ret    

008001fd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001fd:	55                   	push   %ebp
  8001fe:	89 e5                	mov    %esp,%ebp
  800200:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800203:	8d 45 10             	lea    0x10(%ebp),%eax
  800206:	83 c0 04             	add    $0x4,%eax
  800209:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80020c:	a1 2c 30 80 00       	mov    0x80302c,%eax
  800211:	85 c0                	test   %eax,%eax
  800213:	74 16                	je     80022b <_panic+0x2e>
		cprintf("%s: ", argv0);
  800215:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80021a:	83 ec 08             	sub    $0x8,%esp
  80021d:	50                   	push   %eax
  80021e:	68 d0 1c 80 00       	push   $0x801cd0
  800223:	e8 92 02 00 00       	call   8004ba <cprintf>
  800228:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80022b:	a1 00 30 80 00       	mov    0x803000,%eax
  800230:	ff 75 0c             	pushl  0xc(%ebp)
  800233:	ff 75 08             	pushl  0x8(%ebp)
  800236:	50                   	push   %eax
  800237:	68 d5 1c 80 00       	push   $0x801cd5
  80023c:	e8 79 02 00 00       	call   8004ba <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800244:	8b 45 10             	mov    0x10(%ebp),%eax
  800247:	83 ec 08             	sub    $0x8,%esp
  80024a:	ff 75 f4             	pushl  -0xc(%ebp)
  80024d:	50                   	push   %eax
  80024e:	e8 fc 01 00 00       	call   80044f <vcprintf>
  800253:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800256:	83 ec 08             	sub    $0x8,%esp
  800259:	6a 00                	push   $0x0
  80025b:	68 f1 1c 80 00       	push   $0x801cf1
  800260:	e8 ea 01 00 00       	call   80044f <vcprintf>
  800265:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800268:	e8 82 ff ff ff       	call   8001ef <exit>

	// should not return here
	while (1) ;
  80026d:	eb fe                	jmp    80026d <_panic+0x70>

0080026f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800275:	a1 04 30 80 00       	mov    0x803004,%eax
  80027a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800280:	8b 45 0c             	mov    0xc(%ebp),%eax
  800283:	39 c2                	cmp    %eax,%edx
  800285:	74 14                	je     80029b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 f4 1c 80 00       	push   $0x801cf4
  80028f:	6a 26                	push   $0x26
  800291:	68 40 1d 80 00       	push   $0x801d40
  800296:	e8 62 ff ff ff       	call   8001fd <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80029b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002a9:	e9 c5 00 00 00       	jmp    800373 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8002ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002bb:	01 d0                	add    %edx,%eax
  8002bd:	8b 00                	mov    (%eax),%eax
  8002bf:	85 c0                	test   %eax,%eax
  8002c1:	75 08                	jne    8002cb <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8002c3:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8002c6:	e9 a5 00 00 00       	jmp    800370 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8002cb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002d2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002d9:	eb 69                	jmp    800344 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8002db:	a1 04 30 80 00       	mov    0x803004,%eax
  8002e0:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8002e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002e9:	89 d0                	mov    %edx,%eax
  8002eb:	01 c0                	add    %eax,%eax
  8002ed:	01 d0                	add    %edx,%eax
  8002ef:	c1 e0 03             	shl    $0x3,%eax
  8002f2:	01 c8                	add    %ecx,%eax
  8002f4:	8a 40 04             	mov    0x4(%eax),%al
  8002f7:	84 c0                	test   %al,%al
  8002f9:	75 46                	jne    800341 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002fb:	a1 04 30 80 00       	mov    0x803004,%eax
  800300:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800306:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800309:	89 d0                	mov    %edx,%eax
  80030b:	01 c0                	add    %eax,%eax
  80030d:	01 d0                	add    %edx,%eax
  80030f:	c1 e0 03             	shl    $0x3,%eax
  800312:	01 c8                	add    %ecx,%eax
  800314:	8b 00                	mov    (%eax),%eax
  800316:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800319:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80031c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800321:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800323:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800326:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032d:	8b 45 08             	mov    0x8(%ebp),%eax
  800330:	01 c8                	add    %ecx,%eax
  800332:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800334:	39 c2                	cmp    %eax,%edx
  800336:	75 09                	jne    800341 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800338:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80033f:	eb 15                	jmp    800356 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800341:	ff 45 e8             	incl   -0x18(%ebp)
  800344:	a1 04 30 80 00       	mov    0x803004,%eax
  800349:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80034f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800352:	39 c2                	cmp    %eax,%edx
  800354:	77 85                	ja     8002db <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800356:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80035a:	75 14                	jne    800370 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80035c:	83 ec 04             	sub    $0x4,%esp
  80035f:	68 4c 1d 80 00       	push   $0x801d4c
  800364:	6a 3a                	push   $0x3a
  800366:	68 40 1d 80 00       	push   $0x801d40
  80036b:	e8 8d fe ff ff       	call   8001fd <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800370:	ff 45 f0             	incl   -0x10(%ebp)
  800373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800376:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800379:	0f 8c 2f ff ff ff    	jl     8002ae <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80037f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800386:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80038d:	eb 26                	jmp    8003b5 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80038f:	a1 04 30 80 00       	mov    0x803004,%eax
  800394:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80039a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80039d:	89 d0                	mov    %edx,%eax
  80039f:	01 c0                	add    %eax,%eax
  8003a1:	01 d0                	add    %edx,%eax
  8003a3:	c1 e0 03             	shl    $0x3,%eax
  8003a6:	01 c8                	add    %ecx,%eax
  8003a8:	8a 40 04             	mov    0x4(%eax),%al
  8003ab:	3c 01                	cmp    $0x1,%al
  8003ad:	75 03                	jne    8003b2 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8003af:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b2:	ff 45 e0             	incl   -0x20(%ebp)
  8003b5:	a1 04 30 80 00       	mov    0x803004,%eax
  8003ba:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003c3:	39 c2                	cmp    %eax,%edx
  8003c5:	77 c8                	ja     80038f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8003c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ca:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003cd:	74 14                	je     8003e3 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8003cf:	83 ec 04             	sub    $0x4,%esp
  8003d2:	68 a0 1d 80 00       	push   $0x801da0
  8003d7:	6a 44                	push   $0x44
  8003d9:	68 40 1d 80 00       	push   $0x801d40
  8003de:	e8 1a fe ff ff       	call   8001fd <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8003e3:	90                   	nop
  8003e4:	c9                   	leave  
  8003e5:	c3                   	ret    

008003e6 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8003ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ef:	8b 00                	mov    (%eax),%eax
  8003f1:	8d 48 01             	lea    0x1(%eax),%ecx
  8003f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003f7:	89 0a                	mov    %ecx,(%edx)
  8003f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8003fc:	88 d1                	mov    %dl,%cl
  8003fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800401:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800405:	8b 45 0c             	mov    0xc(%ebp),%eax
  800408:	8b 00                	mov    (%eax),%eax
  80040a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80040f:	75 2c                	jne    80043d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800411:	a0 08 30 80 00       	mov    0x803008,%al
  800416:	0f b6 c0             	movzbl %al,%eax
  800419:	8b 55 0c             	mov    0xc(%ebp),%edx
  80041c:	8b 12                	mov    (%edx),%edx
  80041e:	89 d1                	mov    %edx,%ecx
  800420:	8b 55 0c             	mov    0xc(%ebp),%edx
  800423:	83 c2 08             	add    $0x8,%edx
  800426:	83 ec 04             	sub    $0x4,%esp
  800429:	50                   	push   %eax
  80042a:	51                   	push   %ecx
  80042b:	52                   	push   %edx
  80042c:	e8 4e 0e 00 00       	call   80127f <sys_cputs>
  800431:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800434:	8b 45 0c             	mov    0xc(%ebp),%eax
  800437:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80043d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800440:	8b 40 04             	mov    0x4(%eax),%eax
  800443:	8d 50 01             	lea    0x1(%eax),%edx
  800446:	8b 45 0c             	mov    0xc(%ebp),%eax
  800449:	89 50 04             	mov    %edx,0x4(%eax)
}
  80044c:	90                   	nop
  80044d:	c9                   	leave  
  80044e:	c3                   	ret    

0080044f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80044f:	55                   	push   %ebp
  800450:	89 e5                	mov    %esp,%ebp
  800452:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800458:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80045f:	00 00 00 
	b.cnt = 0;
  800462:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800469:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80046c:	ff 75 0c             	pushl  0xc(%ebp)
  80046f:	ff 75 08             	pushl  0x8(%ebp)
  800472:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800478:	50                   	push   %eax
  800479:	68 e6 03 80 00       	push   $0x8003e6
  80047e:	e8 11 02 00 00       	call   800694 <vprintfmt>
  800483:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800486:	a0 08 30 80 00       	mov    0x803008,%al
  80048b:	0f b6 c0             	movzbl %al,%eax
  80048e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800494:	83 ec 04             	sub    $0x4,%esp
  800497:	50                   	push   %eax
  800498:	52                   	push   %edx
  800499:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80049f:	83 c0 08             	add    $0x8,%eax
  8004a2:	50                   	push   %eax
  8004a3:	e8 d7 0d 00 00       	call   80127f <sys_cputs>
  8004a8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004ab:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8004b2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004b8:	c9                   	leave  
  8004b9:	c3                   	ret    

008004ba <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8004ba:	55                   	push   %ebp
  8004bb:	89 e5                	mov    %esp,%ebp
  8004bd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8004c0:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8004c7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d0:	83 ec 08             	sub    $0x8,%esp
  8004d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8004d6:	50                   	push   %eax
  8004d7:	e8 73 ff ff ff       	call   80044f <vcprintf>
  8004dc:	83 c4 10             	add    $0x10,%esp
  8004df:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8004e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004e5:	c9                   	leave  
  8004e6:	c3                   	ret    

008004e7 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8004e7:	55                   	push   %ebp
  8004e8:	89 e5                	mov    %esp,%ebp
  8004ea:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8004ed:	e8 cf 0d 00 00       	call   8012c1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8004f2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8004f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fb:	83 ec 08             	sub    $0x8,%esp
  8004fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800501:	50                   	push   %eax
  800502:	e8 48 ff ff ff       	call   80044f <vcprintf>
  800507:	83 c4 10             	add    $0x10,%esp
  80050a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80050d:	e8 c9 0d 00 00       	call   8012db <sys_unlock_cons>
	return cnt;
  800512:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800515:	c9                   	leave  
  800516:	c3                   	ret    

00800517 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800517:	55                   	push   %ebp
  800518:	89 e5                	mov    %esp,%ebp
  80051a:	53                   	push   %ebx
  80051b:	83 ec 14             	sub    $0x14,%esp
  80051e:	8b 45 10             	mov    0x10(%ebp),%eax
  800521:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800524:	8b 45 14             	mov    0x14(%ebp),%eax
  800527:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80052a:	8b 45 18             	mov    0x18(%ebp),%eax
  80052d:	ba 00 00 00 00       	mov    $0x0,%edx
  800532:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800535:	77 55                	ja     80058c <printnum+0x75>
  800537:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80053a:	72 05                	jb     800541 <printnum+0x2a>
  80053c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80053f:	77 4b                	ja     80058c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800541:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800544:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800547:	8b 45 18             	mov    0x18(%ebp),%eax
  80054a:	ba 00 00 00 00       	mov    $0x0,%edx
  80054f:	52                   	push   %edx
  800550:	50                   	push   %eax
  800551:	ff 75 f4             	pushl  -0xc(%ebp)
  800554:	ff 75 f0             	pushl  -0x10(%ebp)
  800557:	e8 24 13 00 00       	call   801880 <__udivdi3>
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	83 ec 04             	sub    $0x4,%esp
  800562:	ff 75 20             	pushl  0x20(%ebp)
  800565:	53                   	push   %ebx
  800566:	ff 75 18             	pushl  0x18(%ebp)
  800569:	52                   	push   %edx
  80056a:	50                   	push   %eax
  80056b:	ff 75 0c             	pushl  0xc(%ebp)
  80056e:	ff 75 08             	pushl  0x8(%ebp)
  800571:	e8 a1 ff ff ff       	call   800517 <printnum>
  800576:	83 c4 20             	add    $0x20,%esp
  800579:	eb 1a                	jmp    800595 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80057b:	83 ec 08             	sub    $0x8,%esp
  80057e:	ff 75 0c             	pushl  0xc(%ebp)
  800581:	ff 75 20             	pushl  0x20(%ebp)
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	ff d0                	call   *%eax
  800589:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80058c:	ff 4d 1c             	decl   0x1c(%ebp)
  80058f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800593:	7f e6                	jg     80057b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800595:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800598:	bb 00 00 00 00       	mov    $0x0,%ebx
  80059d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005a3:	53                   	push   %ebx
  8005a4:	51                   	push   %ecx
  8005a5:	52                   	push   %edx
  8005a6:	50                   	push   %eax
  8005a7:	e8 e4 13 00 00       	call   801990 <__umoddi3>
  8005ac:	83 c4 10             	add    $0x10,%esp
  8005af:	05 14 20 80 00       	add    $0x802014,%eax
  8005b4:	8a 00                	mov    (%eax),%al
  8005b6:	0f be c0             	movsbl %al,%eax
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	ff 75 0c             	pushl  0xc(%ebp)
  8005bf:	50                   	push   %eax
  8005c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c3:	ff d0                	call   *%eax
  8005c5:	83 c4 10             	add    $0x10,%esp
}
  8005c8:	90                   	nop
  8005c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005cc:	c9                   	leave  
  8005cd:	c3                   	ret    

008005ce <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005ce:	55                   	push   %ebp
  8005cf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005d1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005d5:	7e 1c                	jle    8005f3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8005d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	8d 50 08             	lea    0x8(%eax),%edx
  8005df:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e2:	89 10                	mov    %edx,(%eax)
  8005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e7:	8b 00                	mov    (%eax),%eax
  8005e9:	83 e8 08             	sub    $0x8,%eax
  8005ec:	8b 50 04             	mov    0x4(%eax),%edx
  8005ef:	8b 00                	mov    (%eax),%eax
  8005f1:	eb 40                	jmp    800633 <getuint+0x65>
	else if (lflag)
  8005f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005f7:	74 1e                	je     800617 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fc:	8b 00                	mov    (%eax),%eax
  8005fe:	8d 50 04             	lea    0x4(%eax),%edx
  800601:	8b 45 08             	mov    0x8(%ebp),%eax
  800604:	89 10                	mov    %edx,(%eax)
  800606:	8b 45 08             	mov    0x8(%ebp),%eax
  800609:	8b 00                	mov    (%eax),%eax
  80060b:	83 e8 04             	sub    $0x4,%eax
  80060e:	8b 00                	mov    (%eax),%eax
  800610:	ba 00 00 00 00       	mov    $0x0,%edx
  800615:	eb 1c                	jmp    800633 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800617:	8b 45 08             	mov    0x8(%ebp),%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	8d 50 04             	lea    0x4(%eax),%edx
  80061f:	8b 45 08             	mov    0x8(%ebp),%eax
  800622:	89 10                	mov    %edx,(%eax)
  800624:	8b 45 08             	mov    0x8(%ebp),%eax
  800627:	8b 00                	mov    (%eax),%eax
  800629:	83 e8 04             	sub    $0x4,%eax
  80062c:	8b 00                	mov    (%eax),%eax
  80062e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800633:	5d                   	pop    %ebp
  800634:	c3                   	ret    

00800635 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800635:	55                   	push   %ebp
  800636:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800638:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80063c:	7e 1c                	jle    80065a <getint+0x25>
		return va_arg(*ap, long long);
  80063e:	8b 45 08             	mov    0x8(%ebp),%eax
  800641:	8b 00                	mov    (%eax),%eax
  800643:	8d 50 08             	lea    0x8(%eax),%edx
  800646:	8b 45 08             	mov    0x8(%ebp),%eax
  800649:	89 10                	mov    %edx,(%eax)
  80064b:	8b 45 08             	mov    0x8(%ebp),%eax
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	83 e8 08             	sub    $0x8,%eax
  800653:	8b 50 04             	mov    0x4(%eax),%edx
  800656:	8b 00                	mov    (%eax),%eax
  800658:	eb 38                	jmp    800692 <getint+0x5d>
	else if (lflag)
  80065a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80065e:	74 1a                	je     80067a <getint+0x45>
		return va_arg(*ap, long);
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	8d 50 04             	lea    0x4(%eax),%edx
  800668:	8b 45 08             	mov    0x8(%ebp),%eax
  80066b:	89 10                	mov    %edx,(%eax)
  80066d:	8b 45 08             	mov    0x8(%ebp),%eax
  800670:	8b 00                	mov    (%eax),%eax
  800672:	83 e8 04             	sub    $0x4,%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	99                   	cltd   
  800678:	eb 18                	jmp    800692 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80067a:	8b 45 08             	mov    0x8(%ebp),%eax
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	8d 50 04             	lea    0x4(%eax),%edx
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	89 10                	mov    %edx,(%eax)
  800687:	8b 45 08             	mov    0x8(%ebp),%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	83 e8 04             	sub    $0x4,%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	99                   	cltd   
}
  800692:	5d                   	pop    %ebp
  800693:	c3                   	ret    

00800694 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800694:	55                   	push   %ebp
  800695:	89 e5                	mov    %esp,%ebp
  800697:	56                   	push   %esi
  800698:	53                   	push   %ebx
  800699:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80069c:	eb 17                	jmp    8006b5 <vprintfmt+0x21>
			if (ch == '\0')
  80069e:	85 db                	test   %ebx,%ebx
  8006a0:	0f 84 c1 03 00 00    	je     800a67 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8006a6:	83 ec 08             	sub    $0x8,%esp
  8006a9:	ff 75 0c             	pushl  0xc(%ebp)
  8006ac:	53                   	push   %ebx
  8006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b0:	ff d0                	call   *%eax
  8006b2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8006b8:	8d 50 01             	lea    0x1(%eax),%edx
  8006bb:	89 55 10             	mov    %edx,0x10(%ebp)
  8006be:	8a 00                	mov    (%eax),%al
  8006c0:	0f b6 d8             	movzbl %al,%ebx
  8006c3:	83 fb 25             	cmp    $0x25,%ebx
  8006c6:	75 d6                	jne    80069e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006c8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8006cc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8006d3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006da:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8006e1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8006eb:	8d 50 01             	lea    0x1(%eax),%edx
  8006ee:	89 55 10             	mov    %edx,0x10(%ebp)
  8006f1:	8a 00                	mov    (%eax),%al
  8006f3:	0f b6 d8             	movzbl %al,%ebx
  8006f6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006f9:	83 f8 5b             	cmp    $0x5b,%eax
  8006fc:	0f 87 3d 03 00 00    	ja     800a3f <vprintfmt+0x3ab>
  800702:	8b 04 85 38 20 80 00 	mov    0x802038(,%eax,4),%eax
  800709:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80070b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80070f:	eb d7                	jmp    8006e8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800711:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800715:	eb d1                	jmp    8006e8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800717:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80071e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800721:	89 d0                	mov    %edx,%eax
  800723:	c1 e0 02             	shl    $0x2,%eax
  800726:	01 d0                	add    %edx,%eax
  800728:	01 c0                	add    %eax,%eax
  80072a:	01 d8                	add    %ebx,%eax
  80072c:	83 e8 30             	sub    $0x30,%eax
  80072f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800732:	8b 45 10             	mov    0x10(%ebp),%eax
  800735:	8a 00                	mov    (%eax),%al
  800737:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80073a:	83 fb 2f             	cmp    $0x2f,%ebx
  80073d:	7e 3e                	jle    80077d <vprintfmt+0xe9>
  80073f:	83 fb 39             	cmp    $0x39,%ebx
  800742:	7f 39                	jg     80077d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800744:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800747:	eb d5                	jmp    80071e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800749:	8b 45 14             	mov    0x14(%ebp),%eax
  80074c:	83 c0 04             	add    $0x4,%eax
  80074f:	89 45 14             	mov    %eax,0x14(%ebp)
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	83 e8 04             	sub    $0x4,%eax
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80075d:	eb 1f                	jmp    80077e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80075f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800763:	79 83                	jns    8006e8 <vprintfmt+0x54>
				width = 0;
  800765:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80076c:	e9 77 ff ff ff       	jmp    8006e8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800771:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800778:	e9 6b ff ff ff       	jmp    8006e8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80077d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80077e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800782:	0f 89 60 ff ff ff    	jns    8006e8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800788:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80078b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80078e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800795:	e9 4e ff ff ff       	jmp    8006e8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80079a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80079d:	e9 46 ff ff ff       	jmp    8006e8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a5:	83 c0 04             	add    $0x4,%eax
  8007a8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ae:	83 e8 04             	sub    $0x4,%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	ff 75 0c             	pushl  0xc(%ebp)
  8007b9:	50                   	push   %eax
  8007ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bd:	ff d0                	call   *%eax
  8007bf:	83 c4 10             	add    $0x10,%esp
			break;
  8007c2:	e9 9b 02 00 00       	jmp    800a62 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	83 c0 04             	add    $0x4,%eax
  8007cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d3:	83 e8 04             	sub    $0x4,%eax
  8007d6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8007d8:	85 db                	test   %ebx,%ebx
  8007da:	79 02                	jns    8007de <vprintfmt+0x14a>
				err = -err;
  8007dc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007de:	83 fb 64             	cmp    $0x64,%ebx
  8007e1:	7f 0b                	jg     8007ee <vprintfmt+0x15a>
  8007e3:	8b 34 9d 80 1e 80 00 	mov    0x801e80(,%ebx,4),%esi
  8007ea:	85 f6                	test   %esi,%esi
  8007ec:	75 19                	jne    800807 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007ee:	53                   	push   %ebx
  8007ef:	68 25 20 80 00       	push   $0x802025
  8007f4:	ff 75 0c             	pushl  0xc(%ebp)
  8007f7:	ff 75 08             	pushl  0x8(%ebp)
  8007fa:	e8 70 02 00 00       	call   800a6f <printfmt>
  8007ff:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800802:	e9 5b 02 00 00       	jmp    800a62 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800807:	56                   	push   %esi
  800808:	68 2e 20 80 00       	push   $0x80202e
  80080d:	ff 75 0c             	pushl  0xc(%ebp)
  800810:	ff 75 08             	pushl  0x8(%ebp)
  800813:	e8 57 02 00 00       	call   800a6f <printfmt>
  800818:	83 c4 10             	add    $0x10,%esp
			break;
  80081b:	e9 42 02 00 00       	jmp    800a62 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800820:	8b 45 14             	mov    0x14(%ebp),%eax
  800823:	83 c0 04             	add    $0x4,%eax
  800826:	89 45 14             	mov    %eax,0x14(%ebp)
  800829:	8b 45 14             	mov    0x14(%ebp),%eax
  80082c:	83 e8 04             	sub    $0x4,%eax
  80082f:	8b 30                	mov    (%eax),%esi
  800831:	85 f6                	test   %esi,%esi
  800833:	75 05                	jne    80083a <vprintfmt+0x1a6>
				p = "(null)";
  800835:	be 31 20 80 00       	mov    $0x802031,%esi
			if (width > 0 && padc != '-')
  80083a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80083e:	7e 6d                	jle    8008ad <vprintfmt+0x219>
  800840:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800844:	74 67                	je     8008ad <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800846:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800849:	83 ec 08             	sub    $0x8,%esp
  80084c:	50                   	push   %eax
  80084d:	56                   	push   %esi
  80084e:	e8 1e 03 00 00       	call   800b71 <strnlen>
  800853:	83 c4 10             	add    $0x10,%esp
  800856:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800859:	eb 16                	jmp    800871 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80085b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	50                   	push   %eax
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	ff d0                	call   *%eax
  80086b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80086e:	ff 4d e4             	decl   -0x1c(%ebp)
  800871:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800875:	7f e4                	jg     80085b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800877:	eb 34                	jmp    8008ad <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800879:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80087d:	74 1c                	je     80089b <vprintfmt+0x207>
  80087f:	83 fb 1f             	cmp    $0x1f,%ebx
  800882:	7e 05                	jle    800889 <vprintfmt+0x1f5>
  800884:	83 fb 7e             	cmp    $0x7e,%ebx
  800887:	7e 12                	jle    80089b <vprintfmt+0x207>
					putch('?', putdat);
  800889:	83 ec 08             	sub    $0x8,%esp
  80088c:	ff 75 0c             	pushl  0xc(%ebp)
  80088f:	6a 3f                	push   $0x3f
  800891:	8b 45 08             	mov    0x8(%ebp),%eax
  800894:	ff d0                	call   *%eax
  800896:	83 c4 10             	add    $0x10,%esp
  800899:	eb 0f                	jmp    8008aa <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80089b:	83 ec 08             	sub    $0x8,%esp
  80089e:	ff 75 0c             	pushl  0xc(%ebp)
  8008a1:	53                   	push   %ebx
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	ff d0                	call   *%eax
  8008a7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008aa:	ff 4d e4             	decl   -0x1c(%ebp)
  8008ad:	89 f0                	mov    %esi,%eax
  8008af:	8d 70 01             	lea    0x1(%eax),%esi
  8008b2:	8a 00                	mov    (%eax),%al
  8008b4:	0f be d8             	movsbl %al,%ebx
  8008b7:	85 db                	test   %ebx,%ebx
  8008b9:	74 24                	je     8008df <vprintfmt+0x24b>
  8008bb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008bf:	78 b8                	js     800879 <vprintfmt+0x1e5>
  8008c1:	ff 4d e0             	decl   -0x20(%ebp)
  8008c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008c8:	79 af                	jns    800879 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008ca:	eb 13                	jmp    8008df <vprintfmt+0x24b>
				putch(' ', putdat);
  8008cc:	83 ec 08             	sub    $0x8,%esp
  8008cf:	ff 75 0c             	pushl  0xc(%ebp)
  8008d2:	6a 20                	push   $0x20
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	ff d0                	call   *%eax
  8008d9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008dc:	ff 4d e4             	decl   -0x1c(%ebp)
  8008df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e3:	7f e7                	jg     8008cc <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8008e5:	e9 78 01 00 00       	jmp    800a62 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008ea:	83 ec 08             	sub    $0x8,%esp
  8008ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8008f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8008f3:	50                   	push   %eax
  8008f4:	e8 3c fd ff ff       	call   800635 <getint>
  8008f9:	83 c4 10             	add    $0x10,%esp
  8008fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800905:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800908:	85 d2                	test   %edx,%edx
  80090a:	79 23                	jns    80092f <vprintfmt+0x29b>
				putch('-', putdat);
  80090c:	83 ec 08             	sub    $0x8,%esp
  80090f:	ff 75 0c             	pushl  0xc(%ebp)
  800912:	6a 2d                	push   $0x2d
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	ff d0                	call   *%eax
  800919:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80091c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80091f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800922:	f7 d8                	neg    %eax
  800924:	83 d2 00             	adc    $0x0,%edx
  800927:	f7 da                	neg    %edx
  800929:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80092c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80092f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800936:	e9 bc 00 00 00       	jmp    8009f7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80093b:	83 ec 08             	sub    $0x8,%esp
  80093e:	ff 75 e8             	pushl  -0x18(%ebp)
  800941:	8d 45 14             	lea    0x14(%ebp),%eax
  800944:	50                   	push   %eax
  800945:	e8 84 fc ff ff       	call   8005ce <getuint>
  80094a:	83 c4 10             	add    $0x10,%esp
  80094d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800950:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800953:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80095a:	e9 98 00 00 00       	jmp    8009f7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80095f:	83 ec 08             	sub    $0x8,%esp
  800962:	ff 75 0c             	pushl  0xc(%ebp)
  800965:	6a 58                	push   $0x58
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	ff d0                	call   *%eax
  80096c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80096f:	83 ec 08             	sub    $0x8,%esp
  800972:	ff 75 0c             	pushl  0xc(%ebp)
  800975:	6a 58                	push   $0x58
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	ff d0                	call   *%eax
  80097c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	ff 75 0c             	pushl  0xc(%ebp)
  800985:	6a 58                	push   $0x58
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	ff d0                	call   *%eax
  80098c:	83 c4 10             	add    $0x10,%esp
			break;
  80098f:	e9 ce 00 00 00       	jmp    800a62 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800994:	83 ec 08             	sub    $0x8,%esp
  800997:	ff 75 0c             	pushl  0xc(%ebp)
  80099a:	6a 30                	push   $0x30
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	ff d0                	call   *%eax
  8009a1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8009a4:	83 ec 08             	sub    $0x8,%esp
  8009a7:	ff 75 0c             	pushl  0xc(%ebp)
  8009aa:	6a 78                	push   $0x78
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	ff d0                	call   *%eax
  8009b1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8009b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b7:	83 c0 04             	add    $0x4,%eax
  8009ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8009bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c0:	83 e8 04             	sub    $0x4,%eax
  8009c3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8009c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8009cf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8009d6:	eb 1f                	jmp    8009f7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8009d8:	83 ec 08             	sub    $0x8,%esp
  8009db:	ff 75 e8             	pushl  -0x18(%ebp)
  8009de:	8d 45 14             	lea    0x14(%ebp),%eax
  8009e1:	50                   	push   %eax
  8009e2:	e8 e7 fb ff ff       	call   8005ce <getuint>
  8009e7:	83 c4 10             	add    $0x10,%esp
  8009ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009f0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009f7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009fe:	83 ec 04             	sub    $0x4,%esp
  800a01:	52                   	push   %edx
  800a02:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a05:	50                   	push   %eax
  800a06:	ff 75 f4             	pushl  -0xc(%ebp)
  800a09:	ff 75 f0             	pushl  -0x10(%ebp)
  800a0c:	ff 75 0c             	pushl  0xc(%ebp)
  800a0f:	ff 75 08             	pushl  0x8(%ebp)
  800a12:	e8 00 fb ff ff       	call   800517 <printnum>
  800a17:	83 c4 20             	add    $0x20,%esp
			break;
  800a1a:	eb 46                	jmp    800a62 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a1c:	83 ec 08             	sub    $0x8,%esp
  800a1f:	ff 75 0c             	pushl  0xc(%ebp)
  800a22:	53                   	push   %ebx
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	ff d0                	call   *%eax
  800a28:	83 c4 10             	add    $0x10,%esp
			break;
  800a2b:	eb 35                	jmp    800a62 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a2d:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800a34:	eb 2c                	jmp    800a62 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a36:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800a3d:	eb 23                	jmp    800a62 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a3f:	83 ec 08             	sub    $0x8,%esp
  800a42:	ff 75 0c             	pushl  0xc(%ebp)
  800a45:	6a 25                	push   $0x25
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	ff d0                	call   *%eax
  800a4c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a4f:	ff 4d 10             	decl   0x10(%ebp)
  800a52:	eb 03                	jmp    800a57 <vprintfmt+0x3c3>
  800a54:	ff 4d 10             	decl   0x10(%ebp)
  800a57:	8b 45 10             	mov    0x10(%ebp),%eax
  800a5a:	48                   	dec    %eax
  800a5b:	8a 00                	mov    (%eax),%al
  800a5d:	3c 25                	cmp    $0x25,%al
  800a5f:	75 f3                	jne    800a54 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a61:	90                   	nop
		}
	}
  800a62:	e9 35 fc ff ff       	jmp    80069c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a67:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a6b:	5b                   	pop    %ebx
  800a6c:	5e                   	pop    %esi
  800a6d:	5d                   	pop    %ebp
  800a6e:	c3                   	ret    

00800a6f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a75:	8d 45 10             	lea    0x10(%ebp),%eax
  800a78:	83 c0 04             	add    $0x4,%eax
  800a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a81:	ff 75 f4             	pushl  -0xc(%ebp)
  800a84:	50                   	push   %eax
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	ff 75 08             	pushl  0x8(%ebp)
  800a8b:	e8 04 fc ff ff       	call   800694 <vprintfmt>
  800a90:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a93:	90                   	nop
  800a94:	c9                   	leave  
  800a95:	c3                   	ret    

00800a96 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9c:	8b 40 08             	mov    0x8(%eax),%eax
  800a9f:	8d 50 01             	lea    0x1(%eax),%edx
  800aa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aab:	8b 10                	mov    (%eax),%edx
  800aad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab0:	8b 40 04             	mov    0x4(%eax),%eax
  800ab3:	39 c2                	cmp    %eax,%edx
  800ab5:	73 12                	jae    800ac9 <sprintputch+0x33>
		*b->buf++ = ch;
  800ab7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aba:	8b 00                	mov    (%eax),%eax
  800abc:	8d 48 01             	lea    0x1(%eax),%ecx
  800abf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac2:	89 0a                	mov    %ecx,(%edx)
  800ac4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ac7:	88 10                	mov    %dl,(%eax)
}
  800ac9:	90                   	nop
  800aca:	5d                   	pop    %ebp
  800acb:	c3                   	ret    

00800acc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	01 d0                	add    %edx,%eax
  800ae3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800aed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800af1:	74 06                	je     800af9 <vsnprintf+0x2d>
  800af3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800af7:	7f 07                	jg     800b00 <vsnprintf+0x34>
		return -E_INVAL;
  800af9:	b8 03 00 00 00       	mov    $0x3,%eax
  800afe:	eb 20                	jmp    800b20 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b00:	ff 75 14             	pushl  0x14(%ebp)
  800b03:	ff 75 10             	pushl  0x10(%ebp)
  800b06:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b09:	50                   	push   %eax
  800b0a:	68 96 0a 80 00       	push   $0x800a96
  800b0f:	e8 80 fb ff ff       	call   800694 <vprintfmt>
  800b14:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b1a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b20:	c9                   	leave  
  800b21:	c3                   	ret    

00800b22 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b28:	8d 45 10             	lea    0x10(%ebp),%eax
  800b2b:	83 c0 04             	add    $0x4,%eax
  800b2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b31:	8b 45 10             	mov    0x10(%ebp),%eax
  800b34:	ff 75 f4             	pushl  -0xc(%ebp)
  800b37:	50                   	push   %eax
  800b38:	ff 75 0c             	pushl  0xc(%ebp)
  800b3b:	ff 75 08             	pushl  0x8(%ebp)
  800b3e:	e8 89 ff ff ff       	call   800acc <vsnprintf>
  800b43:	83 c4 10             	add    $0x10,%esp
  800b46:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b49:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b4c:	c9                   	leave  
  800b4d:	c3                   	ret    

00800b4e <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b54:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b5b:	eb 06                	jmp    800b63 <strlen+0x15>
		n++;
  800b5d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b60:	ff 45 08             	incl   0x8(%ebp)
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8a 00                	mov    (%eax),%al
  800b68:	84 c0                	test   %al,%al
  800b6a:	75 f1                	jne    800b5d <strlen+0xf>
		n++;
	return n;
  800b6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b6f:	c9                   	leave  
  800b70:	c3                   	ret    

00800b71 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b77:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b7e:	eb 09                	jmp    800b89 <strnlen+0x18>
		n++;
  800b80:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b83:	ff 45 08             	incl   0x8(%ebp)
  800b86:	ff 4d 0c             	decl   0xc(%ebp)
  800b89:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b8d:	74 09                	je     800b98 <strnlen+0x27>
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	8a 00                	mov    (%eax),%al
  800b94:	84 c0                	test   %al,%al
  800b96:	75 e8                	jne    800b80 <strnlen+0xf>
		n++;
	return n;
  800b98:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b9b:	c9                   	leave  
  800b9c:	c3                   	ret    

00800b9d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ba9:	90                   	nop
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	8d 50 01             	lea    0x1(%eax),%edx
  800bb0:	89 55 08             	mov    %edx,0x8(%ebp)
  800bb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bb9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bbc:	8a 12                	mov    (%edx),%dl
  800bbe:	88 10                	mov    %dl,(%eax)
  800bc0:	8a 00                	mov    (%eax),%al
  800bc2:	84 c0                	test   %al,%al
  800bc4:	75 e4                	jne    800baa <strcpy+0xd>
		/* do nothing */;
	return ret;
  800bc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bc9:	c9                   	leave  
  800bca:	c3                   	ret    

00800bcb <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800bd7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bde:	eb 1f                	jmp    800bff <strncpy+0x34>
		*dst++ = *src;
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	8d 50 01             	lea    0x1(%eax),%edx
  800be6:	89 55 08             	mov    %edx,0x8(%ebp)
  800be9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bec:	8a 12                	mov    (%edx),%dl
  800bee:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf3:	8a 00                	mov    (%eax),%al
  800bf5:	84 c0                	test   %al,%al
  800bf7:	74 03                	je     800bfc <strncpy+0x31>
			src++;
  800bf9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bfc:	ff 45 fc             	incl   -0x4(%ebp)
  800bff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c02:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c05:	72 d9                	jb     800be0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c07:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c0a:	c9                   	leave  
  800c0b:	c3                   	ret    

00800c0c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
  800c0f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c1c:	74 30                	je     800c4e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c1e:	eb 16                	jmp    800c36 <strlcpy+0x2a>
			*dst++ = *src++;
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	8d 50 01             	lea    0x1(%eax),%edx
  800c26:	89 55 08             	mov    %edx,0x8(%ebp)
  800c29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c2f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c32:	8a 12                	mov    (%edx),%dl
  800c34:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c36:	ff 4d 10             	decl   0x10(%ebp)
  800c39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c3d:	74 09                	je     800c48 <strlcpy+0x3c>
  800c3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c42:	8a 00                	mov    (%eax),%al
  800c44:	84 c0                	test   %al,%al
  800c46:	75 d8                	jne    800c20 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c54:	29 c2                	sub    %eax,%edx
  800c56:	89 d0                	mov    %edx,%eax
}
  800c58:	c9                   	leave  
  800c59:	c3                   	ret    

00800c5a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c5d:	eb 06                	jmp    800c65 <strcmp+0xb>
		p++, q++;
  800c5f:	ff 45 08             	incl   0x8(%ebp)
  800c62:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	8a 00                	mov    (%eax),%al
  800c6a:	84 c0                	test   %al,%al
  800c6c:	74 0e                	je     800c7c <strcmp+0x22>
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	8a 10                	mov    (%eax),%dl
  800c73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c76:	8a 00                	mov    (%eax),%al
  800c78:	38 c2                	cmp    %al,%dl
  800c7a:	74 e3                	je     800c5f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	8a 00                	mov    (%eax),%al
  800c81:	0f b6 d0             	movzbl %al,%edx
  800c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c87:	8a 00                	mov    (%eax),%al
  800c89:	0f b6 c0             	movzbl %al,%eax
  800c8c:	29 c2                	sub    %eax,%edx
  800c8e:	89 d0                	mov    %edx,%eax
}
  800c90:	5d                   	pop    %ebp
  800c91:	c3                   	ret    

00800c92 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c92:	55                   	push   %ebp
  800c93:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c95:	eb 09                	jmp    800ca0 <strncmp+0xe>
		n--, p++, q++;
  800c97:	ff 4d 10             	decl   0x10(%ebp)
  800c9a:	ff 45 08             	incl   0x8(%ebp)
  800c9d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ca0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca4:	74 17                	je     800cbd <strncmp+0x2b>
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	8a 00                	mov    (%eax),%al
  800cab:	84 c0                	test   %al,%al
  800cad:	74 0e                	je     800cbd <strncmp+0x2b>
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	8a 10                	mov    (%eax),%dl
  800cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb7:	8a 00                	mov    (%eax),%al
  800cb9:	38 c2                	cmp    %al,%dl
  800cbb:	74 da                	je     800c97 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800cbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc1:	75 07                	jne    800cca <strncmp+0x38>
		return 0;
  800cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc8:	eb 14                	jmp    800cde <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	8a 00                	mov    (%eax),%al
  800ccf:	0f b6 d0             	movzbl %al,%edx
  800cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	0f b6 c0             	movzbl %al,%eax
  800cda:	29 c2                	sub    %eax,%edx
  800cdc:	89 d0                	mov    %edx,%eax
}
  800cde:	5d                   	pop    %ebp
  800cdf:	c3                   	ret    

00800ce0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	83 ec 04             	sub    $0x4,%esp
  800ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cec:	eb 12                	jmp    800d00 <strchr+0x20>
		if (*s == c)
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cf6:	75 05                	jne    800cfd <strchr+0x1d>
			return (char *) s;
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	eb 11                	jmp    800d0e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cfd:	ff 45 08             	incl   0x8(%ebp)
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	8a 00                	mov    (%eax),%al
  800d05:	84 c0                	test   %al,%al
  800d07:	75 e5                	jne    800cee <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d0e:	c9                   	leave  
  800d0f:	c3                   	ret    

00800d10 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
  800d13:	83 ec 04             	sub    $0x4,%esp
  800d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d19:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d1c:	eb 0d                	jmp    800d2b <strfind+0x1b>
		if (*s == c)
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d26:	74 0e                	je     800d36 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d28:	ff 45 08             	incl   0x8(%ebp)
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	84 c0                	test   %al,%al
  800d32:	75 ea                	jne    800d1e <strfind+0xe>
  800d34:	eb 01                	jmp    800d37 <strfind+0x27>
		if (*s == c)
			break;
  800d36:	90                   	nop
	return (char *) s;
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d3a:	c9                   	leave  
  800d3b:	c3                   	ret    

00800d3c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d48:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d4e:	eb 0e                	jmp    800d5e <memset+0x22>
		*p++ = c;
  800d50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d53:	8d 50 01             	lea    0x1(%eax),%edx
  800d56:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d5c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d5e:	ff 4d f8             	decl   -0x8(%ebp)
  800d61:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d65:	79 e9                	jns    800d50 <memset+0x14>
		*p++ = c;

	return v;
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d6a:	c9                   	leave  
  800d6b:	c3                   	ret    

00800d6c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d7e:	eb 16                	jmp    800d96 <memcpy+0x2a>
		*d++ = *s++;
  800d80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d83:	8d 50 01             	lea    0x1(%eax),%edx
  800d86:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d89:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d8c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d8f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d92:	8a 12                	mov    (%edx),%dl
  800d94:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d96:	8b 45 10             	mov    0x10(%ebp),%eax
  800d99:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d9f:	85 c0                	test   %eax,%eax
  800da1:	75 dd                	jne    800d80 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da6:	c9                   	leave  
  800da7:	c3                   	ret    

00800da8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
  800dab:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dc0:	73 50                	jae    800e12 <memmove+0x6a>
  800dc2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dc5:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc8:	01 d0                	add    %edx,%eax
  800dca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dcd:	76 43                	jbe    800e12 <memmove+0x6a>
		s += n;
  800dcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800dd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ddb:	eb 10                	jmp    800ded <memmove+0x45>
			*--d = *--s;
  800ddd:	ff 4d f8             	decl   -0x8(%ebp)
  800de0:	ff 4d fc             	decl   -0x4(%ebp)
  800de3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de6:	8a 10                	mov    (%eax),%dl
  800de8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800deb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ded:	8b 45 10             	mov    0x10(%ebp),%eax
  800df0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df3:	89 55 10             	mov    %edx,0x10(%ebp)
  800df6:	85 c0                	test   %eax,%eax
  800df8:	75 e3                	jne    800ddd <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dfa:	eb 23                	jmp    800e1f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800dfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dff:	8d 50 01             	lea    0x1(%eax),%edx
  800e02:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e05:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e0e:	8a 12                	mov    (%edx),%dl
  800e10:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e12:	8b 45 10             	mov    0x10(%ebp),%eax
  800e15:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e18:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1b:	85 c0                	test   %eax,%eax
  800e1d:	75 dd                	jne    800dfc <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e22:	c9                   	leave  
  800e23:	c3                   	ret    

00800e24 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e33:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e36:	eb 2a                	jmp    800e62 <memcmp+0x3e>
		if (*s1 != *s2)
  800e38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3b:	8a 10                	mov    (%eax),%dl
  800e3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e40:	8a 00                	mov    (%eax),%al
  800e42:	38 c2                	cmp    %al,%dl
  800e44:	74 16                	je     800e5c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e49:	8a 00                	mov    (%eax),%al
  800e4b:	0f b6 d0             	movzbl %al,%edx
  800e4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e51:	8a 00                	mov    (%eax),%al
  800e53:	0f b6 c0             	movzbl %al,%eax
  800e56:	29 c2                	sub    %eax,%edx
  800e58:	89 d0                	mov    %edx,%eax
  800e5a:	eb 18                	jmp    800e74 <memcmp+0x50>
		s1++, s2++;
  800e5c:	ff 45 fc             	incl   -0x4(%ebp)
  800e5f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e62:	8b 45 10             	mov    0x10(%ebp),%eax
  800e65:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e68:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6b:	85 c0                	test   %eax,%eax
  800e6d:	75 c9                	jne    800e38 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e74:	c9                   	leave  
  800e75:	c3                   	ret    

00800e76 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e82:	01 d0                	add    %edx,%eax
  800e84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e87:	eb 15                	jmp    800e9e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	0f b6 d0             	movzbl %al,%edx
  800e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e94:	0f b6 c0             	movzbl %al,%eax
  800e97:	39 c2                	cmp    %eax,%edx
  800e99:	74 0d                	je     800ea8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e9b:	ff 45 08             	incl   0x8(%ebp)
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ea4:	72 e3                	jb     800e89 <memfind+0x13>
  800ea6:	eb 01                	jmp    800ea9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ea8:	90                   	nop
	return (void *) s;
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eac:	c9                   	leave  
  800ead:	c3                   	ret    

00800eae <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800eb4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ebb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ec2:	eb 03                	jmp    800ec7 <strtol+0x19>
		s++;
  800ec4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	8a 00                	mov    (%eax),%al
  800ecc:	3c 20                	cmp    $0x20,%al
  800ece:	74 f4                	je     800ec4 <strtol+0x16>
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	8a 00                	mov    (%eax),%al
  800ed5:	3c 09                	cmp    $0x9,%al
  800ed7:	74 eb                	je     800ec4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	8a 00                	mov    (%eax),%al
  800ede:	3c 2b                	cmp    $0x2b,%al
  800ee0:	75 05                	jne    800ee7 <strtol+0x39>
		s++;
  800ee2:	ff 45 08             	incl   0x8(%ebp)
  800ee5:	eb 13                	jmp    800efa <strtol+0x4c>
	else if (*s == '-')
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	8a 00                	mov    (%eax),%al
  800eec:	3c 2d                	cmp    $0x2d,%al
  800eee:	75 0a                	jne    800efa <strtol+0x4c>
		s++, neg = 1;
  800ef0:	ff 45 08             	incl   0x8(%ebp)
  800ef3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800efa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800efe:	74 06                	je     800f06 <strtol+0x58>
  800f00:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f04:	75 20                	jne    800f26 <strtol+0x78>
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	8a 00                	mov    (%eax),%al
  800f0b:	3c 30                	cmp    $0x30,%al
  800f0d:	75 17                	jne    800f26 <strtol+0x78>
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	40                   	inc    %eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	3c 78                	cmp    $0x78,%al
  800f17:	75 0d                	jne    800f26 <strtol+0x78>
		s += 2, base = 16;
  800f19:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f1d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f24:	eb 28                	jmp    800f4e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f2a:	75 15                	jne    800f41 <strtol+0x93>
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	3c 30                	cmp    $0x30,%al
  800f33:	75 0c                	jne    800f41 <strtol+0x93>
		s++, base = 8;
  800f35:	ff 45 08             	incl   0x8(%ebp)
  800f38:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f3f:	eb 0d                	jmp    800f4e <strtol+0xa0>
	else if (base == 0)
  800f41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f45:	75 07                	jne    800f4e <strtol+0xa0>
		base = 10;
  800f47:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	3c 2f                	cmp    $0x2f,%al
  800f55:	7e 19                	jle    800f70 <strtol+0xc2>
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	3c 39                	cmp    $0x39,%al
  800f5e:	7f 10                	jg     800f70 <strtol+0xc2>
			dig = *s - '0';
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	8a 00                	mov    (%eax),%al
  800f65:	0f be c0             	movsbl %al,%eax
  800f68:	83 e8 30             	sub    $0x30,%eax
  800f6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f6e:	eb 42                	jmp    800fb2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	3c 60                	cmp    $0x60,%al
  800f77:	7e 19                	jle    800f92 <strtol+0xe4>
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	8a 00                	mov    (%eax),%al
  800f7e:	3c 7a                	cmp    $0x7a,%al
  800f80:	7f 10                	jg     800f92 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f82:	8b 45 08             	mov    0x8(%ebp),%eax
  800f85:	8a 00                	mov    (%eax),%al
  800f87:	0f be c0             	movsbl %al,%eax
  800f8a:	83 e8 57             	sub    $0x57,%eax
  800f8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f90:	eb 20                	jmp    800fb2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	8a 00                	mov    (%eax),%al
  800f97:	3c 40                	cmp    $0x40,%al
  800f99:	7e 39                	jle    800fd4 <strtol+0x126>
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	8a 00                	mov    (%eax),%al
  800fa0:	3c 5a                	cmp    $0x5a,%al
  800fa2:	7f 30                	jg     800fd4 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f be c0             	movsbl %al,%eax
  800fac:	83 e8 37             	sub    $0x37,%eax
  800faf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fb8:	7d 19                	jge    800fd3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fba:	ff 45 08             	incl   0x8(%ebp)
  800fbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc0:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fc4:	89 c2                	mov    %eax,%edx
  800fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fc9:	01 d0                	add    %edx,%eax
  800fcb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800fce:	e9 7b ff ff ff       	jmp    800f4e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800fd3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800fd4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fd8:	74 08                	je     800fe2 <strtol+0x134>
		*endptr = (char *) s;
  800fda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800fe2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fe6:	74 07                	je     800fef <strtol+0x141>
  800fe8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800feb:	f7 d8                	neg    %eax
  800fed:	eb 03                	jmp    800ff2 <strtol+0x144>
  800fef:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ff2:	c9                   	leave  
  800ff3:	c3                   	ret    

00800ff4 <ltostr>:

void
ltostr(long value, char *str)
{
  800ff4:	55                   	push   %ebp
  800ff5:	89 e5                	mov    %esp,%ebp
  800ff7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ffa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801001:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801008:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80100c:	79 13                	jns    801021 <ltostr+0x2d>
	{
		neg = 1;
  80100e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801015:	8b 45 0c             	mov    0xc(%ebp),%eax
  801018:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80101b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80101e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
  801024:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801029:	99                   	cltd   
  80102a:	f7 f9                	idiv   %ecx
  80102c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80102f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801032:	8d 50 01             	lea    0x1(%eax),%edx
  801035:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801038:	89 c2                	mov    %eax,%edx
  80103a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103d:	01 d0                	add    %edx,%eax
  80103f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801042:	83 c2 30             	add    $0x30,%edx
  801045:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801047:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80104a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80104f:	f7 e9                	imul   %ecx
  801051:	c1 fa 02             	sar    $0x2,%edx
  801054:	89 c8                	mov    %ecx,%eax
  801056:	c1 f8 1f             	sar    $0x1f,%eax
  801059:	29 c2                	sub    %eax,%edx
  80105b:	89 d0                	mov    %edx,%eax
  80105d:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801060:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801064:	75 bb                	jne    801021 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801066:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80106d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801070:	48                   	dec    %eax
  801071:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801074:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801078:	74 3d                	je     8010b7 <ltostr+0xc3>
		start = 1 ;
  80107a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801081:	eb 34                	jmp    8010b7 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801083:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801086:	8b 45 0c             	mov    0xc(%ebp),%eax
  801089:	01 d0                	add    %edx,%eax
  80108b:	8a 00                	mov    (%eax),%al
  80108d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801090:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801093:	8b 45 0c             	mov    0xc(%ebp),%eax
  801096:	01 c2                	add    %eax,%edx
  801098:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80109b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109e:	01 c8                	add    %ecx,%eax
  8010a0:	8a 00                	mov    (%eax),%al
  8010a2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010aa:	01 c2                	add    %eax,%edx
  8010ac:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010af:	88 02                	mov    %al,(%edx)
		start++ ;
  8010b1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010b4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010bd:	7c c4                	jl     801083 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010bf:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8010c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c5:	01 d0                	add    %edx,%eax
  8010c7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8010ca:	90                   	nop
  8010cb:	c9                   	leave  
  8010cc:	c3                   	ret    

008010cd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8010d3:	ff 75 08             	pushl  0x8(%ebp)
  8010d6:	e8 73 fa ff ff       	call   800b4e <strlen>
  8010db:	83 c4 04             	add    $0x4,%esp
  8010de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8010e1:	ff 75 0c             	pushl  0xc(%ebp)
  8010e4:	e8 65 fa ff ff       	call   800b4e <strlen>
  8010e9:	83 c4 04             	add    $0x4,%esp
  8010ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010fd:	eb 17                	jmp    801116 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801102:	8b 45 10             	mov    0x10(%ebp),%eax
  801105:	01 c2                	add    %eax,%edx
  801107:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	01 c8                	add    %ecx,%eax
  80110f:	8a 00                	mov    (%eax),%al
  801111:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801113:	ff 45 fc             	incl   -0x4(%ebp)
  801116:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801119:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80111c:	7c e1                	jl     8010ff <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80111e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801125:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80112c:	eb 1f                	jmp    80114d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80112e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801131:	8d 50 01             	lea    0x1(%eax),%edx
  801134:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801137:	89 c2                	mov    %eax,%edx
  801139:	8b 45 10             	mov    0x10(%ebp),%eax
  80113c:	01 c2                	add    %eax,%edx
  80113e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801141:	8b 45 0c             	mov    0xc(%ebp),%eax
  801144:	01 c8                	add    %ecx,%eax
  801146:	8a 00                	mov    (%eax),%al
  801148:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80114a:	ff 45 f8             	incl   -0x8(%ebp)
  80114d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801150:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801153:	7c d9                	jl     80112e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801155:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801158:	8b 45 10             	mov    0x10(%ebp),%eax
  80115b:	01 d0                	add    %edx,%eax
  80115d:	c6 00 00             	movb   $0x0,(%eax)
}
  801160:	90                   	nop
  801161:	c9                   	leave  
  801162:	c3                   	ret    

00801163 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801166:	8b 45 14             	mov    0x14(%ebp),%eax
  801169:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80116f:	8b 45 14             	mov    0x14(%ebp),%eax
  801172:	8b 00                	mov    (%eax),%eax
  801174:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80117b:	8b 45 10             	mov    0x10(%ebp),%eax
  80117e:	01 d0                	add    %edx,%eax
  801180:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801186:	eb 0c                	jmp    801194 <strsplit+0x31>
			*string++ = 0;
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	8d 50 01             	lea    0x1(%eax),%edx
  80118e:	89 55 08             	mov    %edx,0x8(%ebp)
  801191:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	8a 00                	mov    (%eax),%al
  801199:	84 c0                	test   %al,%al
  80119b:	74 18                	je     8011b5 <strsplit+0x52>
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	0f be c0             	movsbl %al,%eax
  8011a5:	50                   	push   %eax
  8011a6:	ff 75 0c             	pushl  0xc(%ebp)
  8011a9:	e8 32 fb ff ff       	call   800ce0 <strchr>
  8011ae:	83 c4 08             	add    $0x8,%esp
  8011b1:	85 c0                	test   %eax,%eax
  8011b3:	75 d3                	jne    801188 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	84 c0                	test   %al,%al
  8011bc:	74 5a                	je     801218 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011be:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c1:	8b 00                	mov    (%eax),%eax
  8011c3:	83 f8 0f             	cmp    $0xf,%eax
  8011c6:	75 07                	jne    8011cf <strsplit+0x6c>
		{
			return 0;
  8011c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8011cd:	eb 66                	jmp    801235 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8011cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d2:	8b 00                	mov    (%eax),%eax
  8011d4:	8d 48 01             	lea    0x1(%eax),%ecx
  8011d7:	8b 55 14             	mov    0x14(%ebp),%edx
  8011da:	89 0a                	mov    %ecx,(%edx)
  8011dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e6:	01 c2                	add    %eax,%edx
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011ed:	eb 03                	jmp    8011f2 <strsplit+0x8f>
			string++;
  8011ef:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	84 c0                	test   %al,%al
  8011f9:	74 8b                	je     801186 <strsplit+0x23>
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fe:	8a 00                	mov    (%eax),%al
  801200:	0f be c0             	movsbl %al,%eax
  801203:	50                   	push   %eax
  801204:	ff 75 0c             	pushl  0xc(%ebp)
  801207:	e8 d4 fa ff ff       	call   800ce0 <strchr>
  80120c:	83 c4 08             	add    $0x8,%esp
  80120f:	85 c0                	test   %eax,%eax
  801211:	74 dc                	je     8011ef <strsplit+0x8c>
			string++;
	}
  801213:	e9 6e ff ff ff       	jmp    801186 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801218:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801219:	8b 45 14             	mov    0x14(%ebp),%eax
  80121c:	8b 00                	mov    (%eax),%eax
  80121e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801225:	8b 45 10             	mov    0x10(%ebp),%eax
  801228:	01 d0                	add    %edx,%eax
  80122a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801230:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801235:	c9                   	leave  
  801236:	c3                   	ret    

00801237 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
  80123a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80123d:	83 ec 04             	sub    $0x4,%esp
  801240:	68 a8 21 80 00       	push   $0x8021a8
  801245:	68 3f 01 00 00       	push   $0x13f
  80124a:	68 ca 21 80 00       	push   $0x8021ca
  80124f:	e8 a9 ef ff ff       	call   8001fd <_panic>

00801254 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
  801257:	57                   	push   %edi
  801258:	56                   	push   %esi
  801259:	53                   	push   %ebx
  80125a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8b 55 0c             	mov    0xc(%ebp),%edx
  801263:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801266:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801269:	8b 7d 18             	mov    0x18(%ebp),%edi
  80126c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80126f:	cd 30                	int    $0x30
  801271:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801274:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801277:	83 c4 10             	add    $0x10,%esp
  80127a:	5b                   	pop    %ebx
  80127b:	5e                   	pop    %esi
  80127c:	5f                   	pop    %edi
  80127d:	5d                   	pop    %ebp
  80127e:	c3                   	ret    

0080127f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
  801282:	83 ec 04             	sub    $0x4,%esp
  801285:	8b 45 10             	mov    0x10(%ebp),%eax
  801288:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80128b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80128f:	8b 45 08             	mov    0x8(%ebp),%eax
  801292:	6a 00                	push   $0x0
  801294:	6a 00                	push   $0x0
  801296:	52                   	push   %edx
  801297:	ff 75 0c             	pushl  0xc(%ebp)
  80129a:	50                   	push   %eax
  80129b:	6a 00                	push   $0x0
  80129d:	e8 b2 ff ff ff       	call   801254 <syscall>
  8012a2:	83 c4 18             	add    $0x18,%esp
}
  8012a5:	90                   	nop
  8012a6:	c9                   	leave  
  8012a7:	c3                   	ret    

008012a8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012ab:	6a 00                	push   $0x0
  8012ad:	6a 00                	push   $0x0
  8012af:	6a 00                	push   $0x0
  8012b1:	6a 00                	push   $0x0
  8012b3:	6a 00                	push   $0x0
  8012b5:	6a 02                	push   $0x2
  8012b7:	e8 98 ff ff ff       	call   801254 <syscall>
  8012bc:	83 c4 18             	add    $0x18,%esp
}
  8012bf:	c9                   	leave  
  8012c0:	c3                   	ret    

008012c1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8012c4:	6a 00                	push   $0x0
  8012c6:	6a 00                	push   $0x0
  8012c8:	6a 00                	push   $0x0
  8012ca:	6a 00                	push   $0x0
  8012cc:	6a 00                	push   $0x0
  8012ce:	6a 03                	push   $0x3
  8012d0:	e8 7f ff ff ff       	call   801254 <syscall>
  8012d5:	83 c4 18             	add    $0x18,%esp
}
  8012d8:	90                   	nop
  8012d9:	c9                   	leave  
  8012da:	c3                   	ret    

008012db <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8012de:	6a 00                	push   $0x0
  8012e0:	6a 00                	push   $0x0
  8012e2:	6a 00                	push   $0x0
  8012e4:	6a 00                	push   $0x0
  8012e6:	6a 00                	push   $0x0
  8012e8:	6a 04                	push   $0x4
  8012ea:	e8 65 ff ff ff       	call   801254 <syscall>
  8012ef:	83 c4 18             	add    $0x18,%esp
}
  8012f2:	90                   	nop
  8012f3:	c9                   	leave  
  8012f4:	c3                   	ret    

008012f5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	6a 00                	push   $0x0
  801300:	6a 00                	push   $0x0
  801302:	6a 00                	push   $0x0
  801304:	52                   	push   %edx
  801305:	50                   	push   %eax
  801306:	6a 08                	push   $0x8
  801308:	e8 47 ff ff ff       	call   801254 <syscall>
  80130d:	83 c4 18             	add    $0x18,%esp
}
  801310:	c9                   	leave  
  801311:	c3                   	ret    

00801312 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
  801315:	56                   	push   %esi
  801316:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801317:	8b 75 18             	mov    0x18(%ebp),%esi
  80131a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80131d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801320:	8b 55 0c             	mov    0xc(%ebp),%edx
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	56                   	push   %esi
  801327:	53                   	push   %ebx
  801328:	51                   	push   %ecx
  801329:	52                   	push   %edx
  80132a:	50                   	push   %eax
  80132b:	6a 09                	push   $0x9
  80132d:	e8 22 ff ff ff       	call   801254 <syscall>
  801332:	83 c4 18             	add    $0x18,%esp
}
  801335:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801338:	5b                   	pop    %ebx
  801339:	5e                   	pop    %esi
  80133a:	5d                   	pop    %ebp
  80133b:	c3                   	ret    

0080133c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80133f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801342:	8b 45 08             	mov    0x8(%ebp),%eax
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	52                   	push   %edx
  80134c:	50                   	push   %eax
  80134d:	6a 0a                	push   $0xa
  80134f:	e8 00 ff ff ff       	call   801254 <syscall>
  801354:	83 c4 18             	add    $0x18,%esp
}
  801357:	c9                   	leave  
  801358:	c3                   	ret    

00801359 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	ff 75 0c             	pushl  0xc(%ebp)
  801365:	ff 75 08             	pushl  0x8(%ebp)
  801368:	6a 0b                	push   $0xb
  80136a:	e8 e5 fe ff ff       	call   801254 <syscall>
  80136f:	83 c4 18             	add    $0x18,%esp
}
  801372:	c9                   	leave  
  801373:	c3                   	ret    

00801374 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801374:	55                   	push   %ebp
  801375:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801377:	6a 00                	push   $0x0
  801379:	6a 00                	push   $0x0
  80137b:	6a 00                	push   $0x0
  80137d:	6a 00                	push   $0x0
  80137f:	6a 00                	push   $0x0
  801381:	6a 0c                	push   $0xc
  801383:	e8 cc fe ff ff       	call   801254 <syscall>
  801388:	83 c4 18             	add    $0x18,%esp
}
  80138b:	c9                   	leave  
  80138c:	c3                   	ret    

0080138d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801390:	6a 00                	push   $0x0
  801392:	6a 00                	push   $0x0
  801394:	6a 00                	push   $0x0
  801396:	6a 00                	push   $0x0
  801398:	6a 00                	push   $0x0
  80139a:	6a 0d                	push   $0xd
  80139c:	e8 b3 fe ff ff       	call   801254 <syscall>
  8013a1:	83 c4 18             	add    $0x18,%esp
}
  8013a4:	c9                   	leave  
  8013a5:	c3                   	ret    

008013a6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013a9:	6a 00                	push   $0x0
  8013ab:	6a 00                	push   $0x0
  8013ad:	6a 00                	push   $0x0
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 0e                	push   $0xe
  8013b5:	e8 9a fe ff ff       	call   801254 <syscall>
  8013ba:	83 c4 18             	add    $0x18,%esp
}
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 00                	push   $0x0
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 0f                	push   $0xf
  8013ce:	e8 81 fe ff ff       	call   801254 <syscall>
  8013d3:	83 c4 18             	add    $0x18,%esp
}
  8013d6:	c9                   	leave  
  8013d7:	c3                   	ret    

008013d8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013db:	6a 00                	push   $0x0
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 00                	push   $0x0
  8013e3:	ff 75 08             	pushl  0x8(%ebp)
  8013e6:	6a 10                	push   $0x10
  8013e8:	e8 67 fe ff ff       	call   801254 <syscall>
  8013ed:	83 c4 18             	add    $0x18,%esp
}
  8013f0:	c9                   	leave  
  8013f1:	c3                   	ret    

008013f2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013f2:	55                   	push   %ebp
  8013f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 11                	push   $0x11
  801401:	e8 4e fe ff ff       	call   801254 <syscall>
  801406:	83 c4 18             	add    $0x18,%esp
}
  801409:	90                   	nop
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    

0080140c <sys_cputc>:

void
sys_cputc(const char c)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	83 ec 04             	sub    $0x4,%esp
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
  801415:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801418:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80141c:	6a 00                	push   $0x0
  80141e:	6a 00                	push   $0x0
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	50                   	push   %eax
  801425:	6a 01                	push   $0x1
  801427:	e8 28 fe ff ff       	call   801254 <syscall>
  80142c:	83 c4 18             	add    $0x18,%esp
}
  80142f:	90                   	nop
  801430:	c9                   	leave  
  801431:	c3                   	ret    

00801432 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801435:	6a 00                	push   $0x0
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	6a 14                	push   $0x14
  801441:	e8 0e fe ff ff       	call   801254 <syscall>
  801446:	83 c4 18             	add    $0x18,%esp
}
  801449:	90                   	nop
  80144a:	c9                   	leave  
  80144b:	c3                   	ret    

0080144c <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
  80144f:	83 ec 04             	sub    $0x4,%esp
  801452:	8b 45 10             	mov    0x10(%ebp),%eax
  801455:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801458:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80145b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80145f:	8b 45 08             	mov    0x8(%ebp),%eax
  801462:	6a 00                	push   $0x0
  801464:	51                   	push   %ecx
  801465:	52                   	push   %edx
  801466:	ff 75 0c             	pushl  0xc(%ebp)
  801469:	50                   	push   %eax
  80146a:	6a 15                	push   $0x15
  80146c:	e8 e3 fd ff ff       	call   801254 <syscall>
  801471:	83 c4 18             	add    $0x18,%esp
}
  801474:	c9                   	leave  
  801475:	c3                   	ret    

00801476 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801479:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	6a 00                	push   $0x0
  801481:	6a 00                	push   $0x0
  801483:	6a 00                	push   $0x0
  801485:	52                   	push   %edx
  801486:	50                   	push   %eax
  801487:	6a 16                	push   $0x16
  801489:	e8 c6 fd ff ff       	call   801254 <syscall>
  80148e:	83 c4 18             	add    $0x18,%esp
}
  801491:	c9                   	leave  
  801492:	c3                   	ret    

00801493 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801496:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801499:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	51                   	push   %ecx
  8014a4:	52                   	push   %edx
  8014a5:	50                   	push   %eax
  8014a6:	6a 17                	push   $0x17
  8014a8:	e8 a7 fd ff ff       	call   801254 <syscall>
  8014ad:	83 c4 18             	add    $0x18,%esp
}
  8014b0:	c9                   	leave  
  8014b1:	c3                   	ret    

008014b2 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8014b2:	55                   	push   %ebp
  8014b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8014b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	52                   	push   %edx
  8014c2:	50                   	push   %eax
  8014c3:	6a 18                	push   $0x18
  8014c5:	e8 8a fd ff ff       	call   801254 <syscall>
  8014ca:	83 c4 18             	add    $0x18,%esp
}
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8014d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d5:	6a 00                	push   $0x0
  8014d7:	ff 75 14             	pushl  0x14(%ebp)
  8014da:	ff 75 10             	pushl  0x10(%ebp)
  8014dd:	ff 75 0c             	pushl  0xc(%ebp)
  8014e0:	50                   	push   %eax
  8014e1:	6a 19                	push   $0x19
  8014e3:	e8 6c fd ff ff       	call   801254 <syscall>
  8014e8:	83 c4 18             	add    $0x18,%esp
}
  8014eb:	c9                   	leave  
  8014ec:	c3                   	ret    

008014ed <sys_run_env>:

void sys_run_env(int32 envId)
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	50                   	push   %eax
  8014fc:	6a 1a                	push   $0x1a
  8014fe:	e8 51 fd ff ff       	call   801254 <syscall>
  801503:	83 c4 18             	add    $0x18,%esp
}
  801506:	90                   	nop
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	50                   	push   %eax
  801518:	6a 1b                	push   $0x1b
  80151a:	e8 35 fd ff ff       	call   801254 <syscall>
  80151f:	83 c4 18             	add    $0x18,%esp
}
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 05                	push   $0x5
  801533:	e8 1c fd ff ff       	call   801254 <syscall>
  801538:	83 c4 18             	add    $0x18,%esp
}
  80153b:	c9                   	leave  
  80153c:	c3                   	ret    

0080153d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	6a 06                	push   $0x6
  80154c:	e8 03 fd ff ff       	call   801254 <syscall>
  801551:	83 c4 18             	add    $0x18,%esp
}
  801554:	c9                   	leave  
  801555:	c3                   	ret    

00801556 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	6a 07                	push   $0x7
  801565:	e8 ea fc ff ff       	call   801254 <syscall>
  80156a:	83 c4 18             	add    $0x18,%esp
}
  80156d:	c9                   	leave  
  80156e:	c3                   	ret    

0080156f <sys_exit_env>:


void sys_exit_env(void)
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801572:	6a 00                	push   $0x0
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 1c                	push   $0x1c
  80157e:	e8 d1 fc ff ff       	call   801254 <syscall>
  801583:	83 c4 18             	add    $0x18,%esp
}
  801586:	90                   	nop
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80158f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801592:	8d 50 04             	lea    0x4(%eax),%edx
  801595:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	52                   	push   %edx
  80159f:	50                   	push   %eax
  8015a0:	6a 1d                	push   $0x1d
  8015a2:	e8 ad fc ff ff       	call   801254 <syscall>
  8015a7:	83 c4 18             	add    $0x18,%esp
	return result;
  8015aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015b3:	89 01                	mov    %eax,(%ecx)
  8015b5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8015b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bb:	c9                   	leave  
  8015bc:	c2 04 00             	ret    $0x4

008015bf <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	ff 75 10             	pushl  0x10(%ebp)
  8015c9:	ff 75 0c             	pushl  0xc(%ebp)
  8015cc:	ff 75 08             	pushl  0x8(%ebp)
  8015cf:	6a 13                	push   $0x13
  8015d1:	e8 7e fc ff ff       	call   801254 <syscall>
  8015d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8015d9:	90                   	nop
}
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <sys_rcr2>:
uint32 sys_rcr2()
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 1e                	push   $0x1e
  8015eb:	e8 64 fc ff ff       	call   801254 <syscall>
  8015f0:	83 c4 18             	add    $0x18,%esp
}
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    

008015f5 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	83 ec 04             	sub    $0x4,%esp
  8015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801601:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	50                   	push   %eax
  80160e:	6a 1f                	push   $0x1f
  801610:	e8 3f fc ff ff       	call   801254 <syscall>
  801615:	83 c4 18             	add    $0x18,%esp
	return ;
  801618:	90                   	nop
}
  801619:	c9                   	leave  
  80161a:	c3                   	ret    

0080161b <rsttst>:
void rsttst()
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 21                	push   $0x21
  80162a:	e8 25 fc ff ff       	call   801254 <syscall>
  80162f:	83 c4 18             	add    $0x18,%esp
	return ;
  801632:	90                   	nop
}
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	83 ec 04             	sub    $0x4,%esp
  80163b:	8b 45 14             	mov    0x14(%ebp),%eax
  80163e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801641:	8b 55 18             	mov    0x18(%ebp),%edx
  801644:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801648:	52                   	push   %edx
  801649:	50                   	push   %eax
  80164a:	ff 75 10             	pushl  0x10(%ebp)
  80164d:	ff 75 0c             	pushl  0xc(%ebp)
  801650:	ff 75 08             	pushl  0x8(%ebp)
  801653:	6a 20                	push   $0x20
  801655:	e8 fa fb ff ff       	call   801254 <syscall>
  80165a:	83 c4 18             	add    $0x18,%esp
	return ;
  80165d:	90                   	nop
}
  80165e:	c9                   	leave  
  80165f:	c3                   	ret    

00801660 <chktst>:
void chktst(uint32 n)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	ff 75 08             	pushl  0x8(%ebp)
  80166e:	6a 22                	push   $0x22
  801670:	e8 df fb ff ff       	call   801254 <syscall>
  801675:	83 c4 18             	add    $0x18,%esp
	return ;
  801678:	90                   	nop
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <inctst>:

void inctst()
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 23                	push   $0x23
  80168a:	e8 c5 fb ff ff       	call   801254 <syscall>
  80168f:	83 c4 18             	add    $0x18,%esp
	return ;
  801692:	90                   	nop
}
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <gettst>:
uint32 gettst()
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 24                	push   $0x24
  8016a4:	e8 ab fb ff ff       	call   801254 <syscall>
  8016a9:	83 c4 18             	add    $0x18,%esp
}
  8016ac:	c9                   	leave  
  8016ad:	c3                   	ret    

008016ae <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 25                	push   $0x25
  8016c0:	e8 8f fb ff ff       	call   801254 <syscall>
  8016c5:	83 c4 18             	add    $0x18,%esp
  8016c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8016cb:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8016cf:	75 07                	jne    8016d8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8016d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8016d6:	eb 05                	jmp    8016dd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8016d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016dd:	c9                   	leave  
  8016de:	c3                   	ret    

008016df <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
  8016e2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 25                	push   $0x25
  8016f1:	e8 5e fb ff ff       	call   801254 <syscall>
  8016f6:	83 c4 18             	add    $0x18,%esp
  8016f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016fc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801700:	75 07                	jne    801709 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801702:	b8 01 00 00 00       	mov    $0x1,%eax
  801707:	eb 05                	jmp    80170e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801709:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    

00801710 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
  801713:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 25                	push   $0x25
  801722:	e8 2d fb ff ff       	call   801254 <syscall>
  801727:	83 c4 18             	add    $0x18,%esp
  80172a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80172d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801731:	75 07                	jne    80173a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801733:	b8 01 00 00 00       	mov    $0x1,%eax
  801738:	eb 05                	jmp    80173f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80173a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
  801744:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 25                	push   $0x25
  801753:	e8 fc fa ff ff       	call   801254 <syscall>
  801758:	83 c4 18             	add    $0x18,%esp
  80175b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80175e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801762:	75 07                	jne    80176b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801764:	b8 01 00 00 00       	mov    $0x1,%eax
  801769:	eb 05                	jmp    801770 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80176b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801770:	c9                   	leave  
  801771:	c3                   	ret    

00801772 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	ff 75 08             	pushl  0x8(%ebp)
  801780:	6a 26                	push   $0x26
  801782:	e8 cd fa ff ff       	call   801254 <syscall>
  801787:	83 c4 18             	add    $0x18,%esp
	return ;
  80178a:	90                   	nop
}
  80178b:	c9                   	leave  
  80178c:	c3                   	ret    

0080178d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801791:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801794:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801797:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	6a 00                	push   $0x0
  80179f:	53                   	push   %ebx
  8017a0:	51                   	push   %ecx
  8017a1:	52                   	push   %edx
  8017a2:	50                   	push   %eax
  8017a3:	6a 27                	push   $0x27
  8017a5:	e8 aa fa ff ff       	call   801254 <syscall>
  8017aa:	83 c4 18             	add    $0x18,%esp
}
  8017ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8017b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	52                   	push   %edx
  8017c2:	50                   	push   %eax
  8017c3:	6a 28                	push   $0x28
  8017c5:	e8 8a fa ff ff       	call   801254 <syscall>
  8017ca:	83 c4 18             	add    $0x18,%esp
}
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8017d2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017db:	6a 00                	push   $0x0
  8017dd:	51                   	push   %ecx
  8017de:	ff 75 10             	pushl  0x10(%ebp)
  8017e1:	52                   	push   %edx
  8017e2:	50                   	push   %eax
  8017e3:	6a 29                	push   $0x29
  8017e5:	e8 6a fa ff ff       	call   801254 <syscall>
  8017ea:	83 c4 18             	add    $0x18,%esp
}
  8017ed:	c9                   	leave  
  8017ee:	c3                   	ret    

008017ef <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	ff 75 10             	pushl  0x10(%ebp)
  8017f9:	ff 75 0c             	pushl  0xc(%ebp)
  8017fc:	ff 75 08             	pushl  0x8(%ebp)
  8017ff:	6a 12                	push   $0x12
  801801:	e8 4e fa ff ff       	call   801254 <syscall>
  801806:	83 c4 18             	add    $0x18,%esp
	return ;
  801809:	90                   	nop
}
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80180f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	52                   	push   %edx
  80181c:	50                   	push   %eax
  80181d:	6a 2a                	push   $0x2a
  80181f:	e8 30 fa ff ff       	call   801254 <syscall>
  801824:	83 c4 18             	add    $0x18,%esp
	return;
  801827:	90                   	nop
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80182d:	8b 45 08             	mov    0x8(%ebp),%eax
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	50                   	push   %eax
  801839:	6a 2b                	push   $0x2b
  80183b:	e8 14 fa ff ff       	call   801254 <syscall>
  801840:	83 c4 18             	add    $0x18,%esp
}
  801843:	c9                   	leave  
  801844:	c3                   	ret    

00801845 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	ff 75 0c             	pushl  0xc(%ebp)
  801851:	ff 75 08             	pushl  0x8(%ebp)
  801854:	6a 2c                	push   $0x2c
  801856:	e8 f9 f9 ff ff       	call   801254 <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
	return;
  80185e:	90                   	nop
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	ff 75 0c             	pushl  0xc(%ebp)
  80186d:	ff 75 08             	pushl  0x8(%ebp)
  801870:	6a 2d                	push   $0x2d
  801872:	e8 dd f9 ff ff       	call   801254 <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
	return;
  80187a:	90                   	nop
}
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    
  80187d:	66 90                	xchg   %ax,%ax
  80187f:	90                   	nop

00801880 <__udivdi3>:
  801880:	55                   	push   %ebp
  801881:	57                   	push   %edi
  801882:	56                   	push   %esi
  801883:	53                   	push   %ebx
  801884:	83 ec 1c             	sub    $0x1c,%esp
  801887:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80188b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80188f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801893:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801897:	89 ca                	mov    %ecx,%edx
  801899:	89 f8                	mov    %edi,%eax
  80189b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80189f:	85 f6                	test   %esi,%esi
  8018a1:	75 2d                	jne    8018d0 <__udivdi3+0x50>
  8018a3:	39 cf                	cmp    %ecx,%edi
  8018a5:	77 65                	ja     80190c <__udivdi3+0x8c>
  8018a7:	89 fd                	mov    %edi,%ebp
  8018a9:	85 ff                	test   %edi,%edi
  8018ab:	75 0b                	jne    8018b8 <__udivdi3+0x38>
  8018ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8018b2:	31 d2                	xor    %edx,%edx
  8018b4:	f7 f7                	div    %edi
  8018b6:	89 c5                	mov    %eax,%ebp
  8018b8:	31 d2                	xor    %edx,%edx
  8018ba:	89 c8                	mov    %ecx,%eax
  8018bc:	f7 f5                	div    %ebp
  8018be:	89 c1                	mov    %eax,%ecx
  8018c0:	89 d8                	mov    %ebx,%eax
  8018c2:	f7 f5                	div    %ebp
  8018c4:	89 cf                	mov    %ecx,%edi
  8018c6:	89 fa                	mov    %edi,%edx
  8018c8:	83 c4 1c             	add    $0x1c,%esp
  8018cb:	5b                   	pop    %ebx
  8018cc:	5e                   	pop    %esi
  8018cd:	5f                   	pop    %edi
  8018ce:	5d                   	pop    %ebp
  8018cf:	c3                   	ret    
  8018d0:	39 ce                	cmp    %ecx,%esi
  8018d2:	77 28                	ja     8018fc <__udivdi3+0x7c>
  8018d4:	0f bd fe             	bsr    %esi,%edi
  8018d7:	83 f7 1f             	xor    $0x1f,%edi
  8018da:	75 40                	jne    80191c <__udivdi3+0x9c>
  8018dc:	39 ce                	cmp    %ecx,%esi
  8018de:	72 0a                	jb     8018ea <__udivdi3+0x6a>
  8018e0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8018e4:	0f 87 9e 00 00 00    	ja     801988 <__udivdi3+0x108>
  8018ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ef:	89 fa                	mov    %edi,%edx
  8018f1:	83 c4 1c             	add    $0x1c,%esp
  8018f4:	5b                   	pop    %ebx
  8018f5:	5e                   	pop    %esi
  8018f6:	5f                   	pop    %edi
  8018f7:	5d                   	pop    %ebp
  8018f8:	c3                   	ret    
  8018f9:	8d 76 00             	lea    0x0(%esi),%esi
  8018fc:	31 ff                	xor    %edi,%edi
  8018fe:	31 c0                	xor    %eax,%eax
  801900:	89 fa                	mov    %edi,%edx
  801902:	83 c4 1c             	add    $0x1c,%esp
  801905:	5b                   	pop    %ebx
  801906:	5e                   	pop    %esi
  801907:	5f                   	pop    %edi
  801908:	5d                   	pop    %ebp
  801909:	c3                   	ret    
  80190a:	66 90                	xchg   %ax,%ax
  80190c:	89 d8                	mov    %ebx,%eax
  80190e:	f7 f7                	div    %edi
  801910:	31 ff                	xor    %edi,%edi
  801912:	89 fa                	mov    %edi,%edx
  801914:	83 c4 1c             	add    $0x1c,%esp
  801917:	5b                   	pop    %ebx
  801918:	5e                   	pop    %esi
  801919:	5f                   	pop    %edi
  80191a:	5d                   	pop    %ebp
  80191b:	c3                   	ret    
  80191c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801921:	89 eb                	mov    %ebp,%ebx
  801923:	29 fb                	sub    %edi,%ebx
  801925:	89 f9                	mov    %edi,%ecx
  801927:	d3 e6                	shl    %cl,%esi
  801929:	89 c5                	mov    %eax,%ebp
  80192b:	88 d9                	mov    %bl,%cl
  80192d:	d3 ed                	shr    %cl,%ebp
  80192f:	89 e9                	mov    %ebp,%ecx
  801931:	09 f1                	or     %esi,%ecx
  801933:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801937:	89 f9                	mov    %edi,%ecx
  801939:	d3 e0                	shl    %cl,%eax
  80193b:	89 c5                	mov    %eax,%ebp
  80193d:	89 d6                	mov    %edx,%esi
  80193f:	88 d9                	mov    %bl,%cl
  801941:	d3 ee                	shr    %cl,%esi
  801943:	89 f9                	mov    %edi,%ecx
  801945:	d3 e2                	shl    %cl,%edx
  801947:	8b 44 24 08          	mov    0x8(%esp),%eax
  80194b:	88 d9                	mov    %bl,%cl
  80194d:	d3 e8                	shr    %cl,%eax
  80194f:	09 c2                	or     %eax,%edx
  801951:	89 d0                	mov    %edx,%eax
  801953:	89 f2                	mov    %esi,%edx
  801955:	f7 74 24 0c          	divl   0xc(%esp)
  801959:	89 d6                	mov    %edx,%esi
  80195b:	89 c3                	mov    %eax,%ebx
  80195d:	f7 e5                	mul    %ebp
  80195f:	39 d6                	cmp    %edx,%esi
  801961:	72 19                	jb     80197c <__udivdi3+0xfc>
  801963:	74 0b                	je     801970 <__udivdi3+0xf0>
  801965:	89 d8                	mov    %ebx,%eax
  801967:	31 ff                	xor    %edi,%edi
  801969:	e9 58 ff ff ff       	jmp    8018c6 <__udivdi3+0x46>
  80196e:	66 90                	xchg   %ax,%ax
  801970:	8b 54 24 08          	mov    0x8(%esp),%edx
  801974:	89 f9                	mov    %edi,%ecx
  801976:	d3 e2                	shl    %cl,%edx
  801978:	39 c2                	cmp    %eax,%edx
  80197a:	73 e9                	jae    801965 <__udivdi3+0xe5>
  80197c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80197f:	31 ff                	xor    %edi,%edi
  801981:	e9 40 ff ff ff       	jmp    8018c6 <__udivdi3+0x46>
  801986:	66 90                	xchg   %ax,%ax
  801988:	31 c0                	xor    %eax,%eax
  80198a:	e9 37 ff ff ff       	jmp    8018c6 <__udivdi3+0x46>
  80198f:	90                   	nop

00801990 <__umoddi3>:
  801990:	55                   	push   %ebp
  801991:	57                   	push   %edi
  801992:	56                   	push   %esi
  801993:	53                   	push   %ebx
  801994:	83 ec 1c             	sub    $0x1c,%esp
  801997:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80199b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80199f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019a3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8019a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019af:	89 f3                	mov    %esi,%ebx
  8019b1:	89 fa                	mov    %edi,%edx
  8019b3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019b7:	89 34 24             	mov    %esi,(%esp)
  8019ba:	85 c0                	test   %eax,%eax
  8019bc:	75 1a                	jne    8019d8 <__umoddi3+0x48>
  8019be:	39 f7                	cmp    %esi,%edi
  8019c0:	0f 86 a2 00 00 00    	jbe    801a68 <__umoddi3+0xd8>
  8019c6:	89 c8                	mov    %ecx,%eax
  8019c8:	89 f2                	mov    %esi,%edx
  8019ca:	f7 f7                	div    %edi
  8019cc:	89 d0                	mov    %edx,%eax
  8019ce:	31 d2                	xor    %edx,%edx
  8019d0:	83 c4 1c             	add    $0x1c,%esp
  8019d3:	5b                   	pop    %ebx
  8019d4:	5e                   	pop    %esi
  8019d5:	5f                   	pop    %edi
  8019d6:	5d                   	pop    %ebp
  8019d7:	c3                   	ret    
  8019d8:	39 f0                	cmp    %esi,%eax
  8019da:	0f 87 ac 00 00 00    	ja     801a8c <__umoddi3+0xfc>
  8019e0:	0f bd e8             	bsr    %eax,%ebp
  8019e3:	83 f5 1f             	xor    $0x1f,%ebp
  8019e6:	0f 84 ac 00 00 00    	je     801a98 <__umoddi3+0x108>
  8019ec:	bf 20 00 00 00       	mov    $0x20,%edi
  8019f1:	29 ef                	sub    %ebp,%edi
  8019f3:	89 fe                	mov    %edi,%esi
  8019f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8019f9:	89 e9                	mov    %ebp,%ecx
  8019fb:	d3 e0                	shl    %cl,%eax
  8019fd:	89 d7                	mov    %edx,%edi
  8019ff:	89 f1                	mov    %esi,%ecx
  801a01:	d3 ef                	shr    %cl,%edi
  801a03:	09 c7                	or     %eax,%edi
  801a05:	89 e9                	mov    %ebp,%ecx
  801a07:	d3 e2                	shl    %cl,%edx
  801a09:	89 14 24             	mov    %edx,(%esp)
  801a0c:	89 d8                	mov    %ebx,%eax
  801a0e:	d3 e0                	shl    %cl,%eax
  801a10:	89 c2                	mov    %eax,%edx
  801a12:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a16:	d3 e0                	shl    %cl,%eax
  801a18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a20:	89 f1                	mov    %esi,%ecx
  801a22:	d3 e8                	shr    %cl,%eax
  801a24:	09 d0                	or     %edx,%eax
  801a26:	d3 eb                	shr    %cl,%ebx
  801a28:	89 da                	mov    %ebx,%edx
  801a2a:	f7 f7                	div    %edi
  801a2c:	89 d3                	mov    %edx,%ebx
  801a2e:	f7 24 24             	mull   (%esp)
  801a31:	89 c6                	mov    %eax,%esi
  801a33:	89 d1                	mov    %edx,%ecx
  801a35:	39 d3                	cmp    %edx,%ebx
  801a37:	0f 82 87 00 00 00    	jb     801ac4 <__umoddi3+0x134>
  801a3d:	0f 84 91 00 00 00    	je     801ad4 <__umoddi3+0x144>
  801a43:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a47:	29 f2                	sub    %esi,%edx
  801a49:	19 cb                	sbb    %ecx,%ebx
  801a4b:	89 d8                	mov    %ebx,%eax
  801a4d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a51:	d3 e0                	shl    %cl,%eax
  801a53:	89 e9                	mov    %ebp,%ecx
  801a55:	d3 ea                	shr    %cl,%edx
  801a57:	09 d0                	or     %edx,%eax
  801a59:	89 e9                	mov    %ebp,%ecx
  801a5b:	d3 eb                	shr    %cl,%ebx
  801a5d:	89 da                	mov    %ebx,%edx
  801a5f:	83 c4 1c             	add    $0x1c,%esp
  801a62:	5b                   	pop    %ebx
  801a63:	5e                   	pop    %esi
  801a64:	5f                   	pop    %edi
  801a65:	5d                   	pop    %ebp
  801a66:	c3                   	ret    
  801a67:	90                   	nop
  801a68:	89 fd                	mov    %edi,%ebp
  801a6a:	85 ff                	test   %edi,%edi
  801a6c:	75 0b                	jne    801a79 <__umoddi3+0xe9>
  801a6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a73:	31 d2                	xor    %edx,%edx
  801a75:	f7 f7                	div    %edi
  801a77:	89 c5                	mov    %eax,%ebp
  801a79:	89 f0                	mov    %esi,%eax
  801a7b:	31 d2                	xor    %edx,%edx
  801a7d:	f7 f5                	div    %ebp
  801a7f:	89 c8                	mov    %ecx,%eax
  801a81:	f7 f5                	div    %ebp
  801a83:	89 d0                	mov    %edx,%eax
  801a85:	e9 44 ff ff ff       	jmp    8019ce <__umoddi3+0x3e>
  801a8a:	66 90                	xchg   %ax,%ax
  801a8c:	89 c8                	mov    %ecx,%eax
  801a8e:	89 f2                	mov    %esi,%edx
  801a90:	83 c4 1c             	add    $0x1c,%esp
  801a93:	5b                   	pop    %ebx
  801a94:	5e                   	pop    %esi
  801a95:	5f                   	pop    %edi
  801a96:	5d                   	pop    %ebp
  801a97:	c3                   	ret    
  801a98:	3b 04 24             	cmp    (%esp),%eax
  801a9b:	72 06                	jb     801aa3 <__umoddi3+0x113>
  801a9d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801aa1:	77 0f                	ja     801ab2 <__umoddi3+0x122>
  801aa3:	89 f2                	mov    %esi,%edx
  801aa5:	29 f9                	sub    %edi,%ecx
  801aa7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801aab:	89 14 24             	mov    %edx,(%esp)
  801aae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ab2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ab6:	8b 14 24             	mov    (%esp),%edx
  801ab9:	83 c4 1c             	add    $0x1c,%esp
  801abc:	5b                   	pop    %ebx
  801abd:	5e                   	pop    %esi
  801abe:	5f                   	pop    %edi
  801abf:	5d                   	pop    %ebp
  801ac0:	c3                   	ret    
  801ac1:	8d 76 00             	lea    0x0(%esi),%esi
  801ac4:	2b 04 24             	sub    (%esp),%eax
  801ac7:	19 fa                	sbb    %edi,%edx
  801ac9:	89 d1                	mov    %edx,%ecx
  801acb:	89 c6                	mov    %eax,%esi
  801acd:	e9 71 ff ff ff       	jmp    801a43 <__umoddi3+0xb3>
  801ad2:	66 90                	xchg   %ax,%ax
  801ad4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ad8:	72 ea                	jb     801ac4 <__umoddi3+0x134>
  801ada:	89 d9                	mov    %ebx,%ecx
  801adc:	e9 62 ff ff ff       	jmp    801a43 <__umoddi3+0xb3>
