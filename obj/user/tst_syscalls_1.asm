
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
  80003e:	e8 e0 15 00 00       	call   801623 <rsttst>
	void * ret = sys_sbrk(10);
  800043:	83 ec 0c             	sub    $0xc,%esp
  800046:	6a 0a                	push   $0xa
  800048:	e8 e5 17 00 00       	call   801832 <sys_sbrk>
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
  800068:	e8 98 01 00 00       	call   800205 <_panic>
	sys_allocate_user_mem(USER_HEAP_START,10);
  80006d:	83 ec 08             	sub    $0x8,%esp
  800070:	6a 0a                	push   $0xa
  800072:	68 00 00 00 80       	push   $0x80000000
  800077:	e8 ed 17 00 00       	call   801869 <sys_allocate_user_mem>
  80007c:	83 c4 10             	add    $0x10,%esp
	sys_free_user_mem(USER_HEAP_START + PAGE_SIZE, 10);
  80007f:	83 ec 08             	sub    $0x8,%esp
  800082:	6a 0a                	push   $0xa
  800084:	68 00 10 00 80       	push   $0x80001000
  800089:	e8 bf 17 00 00       	call   80184d <sys_free_user_mem>
  80008e:	83 c4 10             	add    $0x10,%esp
	int ret2 = gettst();
  800091:	e8 07 16 00 00       	call   80169d <gettst>
  800096:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret2 != 2)
  800099:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  80009d:	74 14                	je     8000b3 <_main+0x7b>
		panic("tst system calls #1 failed: sys_allocate_user_mem and/or sys_free_user_mem are not handled correctly");
  80009f:	83 ec 04             	sub    $0x4,%esp
  8000a2:	68 54 1b 80 00       	push   $0x801b54
  8000a7:	6a 0f                	push   $0xf
  8000a9:	68 3e 1b 80 00       	push   $0x801b3e
  8000ae:	e8 52 01 00 00       	call   800205 <_panic>
	cprintf("Congratulations... tst system calls #1 completed successfully");
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	68 bc 1b 80 00       	push   $0x801bbc
  8000bb:	e8 02 04 00 00       	call   8004c2 <cprintf>
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
  8000cc:	e8 74 14 00 00       	call   801545 <sys_getenvindex>
  8000d1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000d7:	89 d0                	mov    %edx,%eax
  8000d9:	c1 e0 03             	shl    $0x3,%eax
  8000dc:	01 d0                	add    %edx,%eax
  8000de:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000e5:	01 c8                	add    %ecx,%eax
  8000e7:	01 c0                	add    %eax,%eax
  8000e9:	01 d0                	add    %edx,%eax
  8000eb:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000f2:	01 c8                	add    %ecx,%eax
  8000f4:	01 d0                	add    %edx,%eax
  8000f6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000fb:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800100:	a1 04 30 80 00       	mov    0x803004,%eax
  800105:	8a 40 20             	mov    0x20(%eax),%al
  800108:	84 c0                	test   %al,%al
  80010a:	74 0d                	je     800119 <libmain+0x53>
		binaryname = myEnv->prog_name;
  80010c:	a1 04 30 80 00       	mov    0x803004,%eax
  800111:	83 c0 20             	add    $0x20,%eax
  800114:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800119:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80011d:	7e 0a                	jle    800129 <libmain+0x63>
		binaryname = argv[0];
  80011f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800122:	8b 00                	mov    (%eax),%eax
  800124:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800129:	83 ec 08             	sub    $0x8,%esp
  80012c:	ff 75 0c             	pushl  0xc(%ebp)
  80012f:	ff 75 08             	pushl  0x8(%ebp)
  800132:	e8 01 ff ff ff       	call   800038 <_main>
  800137:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80013a:	e8 8a 11 00 00       	call   8012c9 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 14 1c 80 00       	push   $0x801c14
  800147:	e8 76 03 00 00       	call   8004c2 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80014f:	a1 04 30 80 00       	mov    0x803004,%eax
  800154:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80015a:	a1 04 30 80 00       	mov    0x803004,%eax
  80015f:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800165:	83 ec 04             	sub    $0x4,%esp
  800168:	52                   	push   %edx
  800169:	50                   	push   %eax
  80016a:	68 3c 1c 80 00       	push   $0x801c3c
  80016f:	e8 4e 03 00 00       	call   8004c2 <cprintf>
  800174:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800177:	a1 04 30 80 00       	mov    0x803004,%eax
  80017c:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800182:	a1 04 30 80 00       	mov    0x803004,%eax
  800187:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80018d:	a1 04 30 80 00       	mov    0x803004,%eax
  800192:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800198:	51                   	push   %ecx
  800199:	52                   	push   %edx
  80019a:	50                   	push   %eax
  80019b:	68 64 1c 80 00       	push   $0x801c64
  8001a0:	e8 1d 03 00 00       	call   8004c2 <cprintf>
  8001a5:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001a8:	a1 04 30 80 00       	mov    0x803004,%eax
  8001ad:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	50                   	push   %eax
  8001b7:	68 bc 1c 80 00       	push   $0x801cbc
  8001bc:	e8 01 03 00 00       	call   8004c2 <cprintf>
  8001c1:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001c4:	83 ec 0c             	sub    $0xc,%esp
  8001c7:	68 14 1c 80 00       	push   $0x801c14
  8001cc:	e8 f1 02 00 00       	call   8004c2 <cprintf>
  8001d1:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8001d4:	e8 0a 11 00 00       	call   8012e3 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8001d9:	e8 19 00 00 00       	call   8001f7 <exit>
}
  8001de:	90                   	nop
  8001df:	c9                   	leave  
  8001e0:	c3                   	ret    

008001e1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001e1:	55                   	push   %ebp
  8001e2:	89 e5                	mov    %esp,%ebp
  8001e4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	6a 00                	push   $0x0
  8001ec:	e8 20 13 00 00       	call   801511 <sys_destroy_env>
  8001f1:	83 c4 10             	add    $0x10,%esp
}
  8001f4:	90                   	nop
  8001f5:	c9                   	leave  
  8001f6:	c3                   	ret    

008001f7 <exit>:

void
exit(void)
{
  8001f7:	55                   	push   %ebp
  8001f8:	89 e5                	mov    %esp,%ebp
  8001fa:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001fd:	e8 75 13 00 00       	call   801577 <sys_exit_env>
}
  800202:	90                   	nop
  800203:	c9                   	leave  
  800204:	c3                   	ret    

00800205 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80020b:	8d 45 10             	lea    0x10(%ebp),%eax
  80020e:	83 c0 04             	add    $0x4,%eax
  800211:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800214:	a1 2c 30 80 00       	mov    0x80302c,%eax
  800219:	85 c0                	test   %eax,%eax
  80021b:	74 16                	je     800233 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80021d:	a1 2c 30 80 00       	mov    0x80302c,%eax
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	50                   	push   %eax
  800226:	68 d0 1c 80 00       	push   $0x801cd0
  80022b:	e8 92 02 00 00       	call   8004c2 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800233:	a1 00 30 80 00       	mov    0x803000,%eax
  800238:	ff 75 0c             	pushl  0xc(%ebp)
  80023b:	ff 75 08             	pushl  0x8(%ebp)
  80023e:	50                   	push   %eax
  80023f:	68 d5 1c 80 00       	push   $0x801cd5
  800244:	e8 79 02 00 00       	call   8004c2 <cprintf>
  800249:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80024c:	8b 45 10             	mov    0x10(%ebp),%eax
  80024f:	83 ec 08             	sub    $0x8,%esp
  800252:	ff 75 f4             	pushl  -0xc(%ebp)
  800255:	50                   	push   %eax
  800256:	e8 fc 01 00 00       	call   800457 <vcprintf>
  80025b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80025e:	83 ec 08             	sub    $0x8,%esp
  800261:	6a 00                	push   $0x0
  800263:	68 f1 1c 80 00       	push   $0x801cf1
  800268:	e8 ea 01 00 00       	call   800457 <vcprintf>
  80026d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800270:	e8 82 ff ff ff       	call   8001f7 <exit>

	// should not return here
	while (1) ;
  800275:	eb fe                	jmp    800275 <_panic+0x70>

00800277 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800277:	55                   	push   %ebp
  800278:	89 e5                	mov    %esp,%ebp
  80027a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80027d:	a1 04 30 80 00       	mov    0x803004,%eax
  800282:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800288:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028b:	39 c2                	cmp    %eax,%edx
  80028d:	74 14                	je     8002a3 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80028f:	83 ec 04             	sub    $0x4,%esp
  800292:	68 f4 1c 80 00       	push   $0x801cf4
  800297:	6a 26                	push   $0x26
  800299:	68 40 1d 80 00       	push   $0x801d40
  80029e:	e8 62 ff ff ff       	call   800205 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002b1:	e9 c5 00 00 00       	jmp    80037b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8002b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	8b 00                	mov    (%eax),%eax
  8002c7:	85 c0                	test   %eax,%eax
  8002c9:	75 08                	jne    8002d3 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8002cb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8002ce:	e9 a5 00 00 00       	jmp    800378 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8002d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002da:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002e1:	eb 69                	jmp    80034c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8002e3:	a1 04 30 80 00       	mov    0x803004,%eax
  8002e8:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8002ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002f1:	89 d0                	mov    %edx,%eax
  8002f3:	01 c0                	add    %eax,%eax
  8002f5:	01 d0                	add    %edx,%eax
  8002f7:	c1 e0 03             	shl    $0x3,%eax
  8002fa:	01 c8                	add    %ecx,%eax
  8002fc:	8a 40 04             	mov    0x4(%eax),%al
  8002ff:	84 c0                	test   %al,%al
  800301:	75 46                	jne    800349 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800303:	a1 04 30 80 00       	mov    0x803004,%eax
  800308:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80030e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800311:	89 d0                	mov    %edx,%eax
  800313:	01 c0                	add    %eax,%eax
  800315:	01 d0                	add    %edx,%eax
  800317:	c1 e0 03             	shl    $0x3,%eax
  80031a:	01 c8                	add    %ecx,%eax
  80031c:	8b 00                	mov    (%eax),%eax
  80031e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800321:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800324:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800329:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80032b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80032e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800335:	8b 45 08             	mov    0x8(%ebp),%eax
  800338:	01 c8                	add    %ecx,%eax
  80033a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80033c:	39 c2                	cmp    %eax,%edx
  80033e:	75 09                	jne    800349 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800340:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800347:	eb 15                	jmp    80035e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800349:	ff 45 e8             	incl   -0x18(%ebp)
  80034c:	a1 04 30 80 00       	mov    0x803004,%eax
  800351:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800357:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80035a:	39 c2                	cmp    %eax,%edx
  80035c:	77 85                	ja     8002e3 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80035e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800362:	75 14                	jne    800378 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800364:	83 ec 04             	sub    $0x4,%esp
  800367:	68 4c 1d 80 00       	push   $0x801d4c
  80036c:	6a 3a                	push   $0x3a
  80036e:	68 40 1d 80 00       	push   $0x801d40
  800373:	e8 8d fe ff ff       	call   800205 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800378:	ff 45 f0             	incl   -0x10(%ebp)
  80037b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80037e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800381:	0f 8c 2f ff ff ff    	jl     8002b6 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800387:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80038e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800395:	eb 26                	jmp    8003bd <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800397:	a1 04 30 80 00       	mov    0x803004,%eax
  80039c:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8003a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003a5:	89 d0                	mov    %edx,%eax
  8003a7:	01 c0                	add    %eax,%eax
  8003a9:	01 d0                	add    %edx,%eax
  8003ab:	c1 e0 03             	shl    $0x3,%eax
  8003ae:	01 c8                	add    %ecx,%eax
  8003b0:	8a 40 04             	mov    0x4(%eax),%al
  8003b3:	3c 01                	cmp    $0x1,%al
  8003b5:	75 03                	jne    8003ba <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8003b7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ba:	ff 45 e0             	incl   -0x20(%ebp)
  8003bd:	a1 04 30 80 00       	mov    0x803004,%eax
  8003c2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8003c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003cb:	39 c2                	cmp    %eax,%edx
  8003cd:	77 c8                	ja     800397 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8003cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003d2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003d5:	74 14                	je     8003eb <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8003d7:	83 ec 04             	sub    $0x4,%esp
  8003da:	68 a0 1d 80 00       	push   $0x801da0
  8003df:	6a 44                	push   $0x44
  8003e1:	68 40 1d 80 00       	push   $0x801d40
  8003e6:	e8 1a fe ff ff       	call   800205 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8003eb:	90                   	nop
  8003ec:	c9                   	leave  
  8003ed:	c3                   	ret    

008003ee <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8003ee:	55                   	push   %ebp
  8003ef:	89 e5                	mov    %esp,%ebp
  8003f1:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8003f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f7:	8b 00                	mov    (%eax),%eax
  8003f9:	8d 48 01             	lea    0x1(%eax),%ecx
  8003fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ff:	89 0a                	mov    %ecx,(%edx)
  800401:	8b 55 08             	mov    0x8(%ebp),%edx
  800404:	88 d1                	mov    %dl,%cl
  800406:	8b 55 0c             	mov    0xc(%ebp),%edx
  800409:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80040d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800410:	8b 00                	mov    (%eax),%eax
  800412:	3d ff 00 00 00       	cmp    $0xff,%eax
  800417:	75 2c                	jne    800445 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800419:	a0 08 30 80 00       	mov    0x803008,%al
  80041e:	0f b6 c0             	movzbl %al,%eax
  800421:	8b 55 0c             	mov    0xc(%ebp),%edx
  800424:	8b 12                	mov    (%edx),%edx
  800426:	89 d1                	mov    %edx,%ecx
  800428:	8b 55 0c             	mov    0xc(%ebp),%edx
  80042b:	83 c2 08             	add    $0x8,%edx
  80042e:	83 ec 04             	sub    $0x4,%esp
  800431:	50                   	push   %eax
  800432:	51                   	push   %ecx
  800433:	52                   	push   %edx
  800434:	e8 4e 0e 00 00       	call   801287 <sys_cputs>
  800439:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80043c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80043f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800445:	8b 45 0c             	mov    0xc(%ebp),%eax
  800448:	8b 40 04             	mov    0x4(%eax),%eax
  80044b:	8d 50 01             	lea    0x1(%eax),%edx
  80044e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800451:	89 50 04             	mov    %edx,0x4(%eax)
}
  800454:	90                   	nop
  800455:	c9                   	leave  
  800456:	c3                   	ret    

00800457 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800457:	55                   	push   %ebp
  800458:	89 e5                	mov    %esp,%ebp
  80045a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800460:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800467:	00 00 00 
	b.cnt = 0;
  80046a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800471:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800474:	ff 75 0c             	pushl  0xc(%ebp)
  800477:	ff 75 08             	pushl  0x8(%ebp)
  80047a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800480:	50                   	push   %eax
  800481:	68 ee 03 80 00       	push   $0x8003ee
  800486:	e8 11 02 00 00       	call   80069c <vprintfmt>
  80048b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80048e:	a0 08 30 80 00       	mov    0x803008,%al
  800493:	0f b6 c0             	movzbl %al,%eax
  800496:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80049c:	83 ec 04             	sub    $0x4,%esp
  80049f:	50                   	push   %eax
  8004a0:	52                   	push   %edx
  8004a1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004a7:	83 c0 08             	add    $0x8,%eax
  8004aa:	50                   	push   %eax
  8004ab:	e8 d7 0d 00 00       	call   801287 <sys_cputs>
  8004b0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004b3:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8004ba:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004c0:	c9                   	leave  
  8004c1:	c3                   	ret    

008004c2 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8004c2:	55                   	push   %ebp
  8004c3:	89 e5                	mov    %esp,%ebp
  8004c5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8004c8:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8004cf:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	83 ec 08             	sub    $0x8,%esp
  8004db:	ff 75 f4             	pushl  -0xc(%ebp)
  8004de:	50                   	push   %eax
  8004df:	e8 73 ff ff ff       	call   800457 <vcprintf>
  8004e4:	83 c4 10             	add    $0x10,%esp
  8004e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8004ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004ed:	c9                   	leave  
  8004ee:	c3                   	ret    

008004ef <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8004ef:	55                   	push   %ebp
  8004f0:	89 e5                	mov    %esp,%ebp
  8004f2:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8004f5:	e8 cf 0d 00 00       	call   8012c9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8004fa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800500:	8b 45 08             	mov    0x8(%ebp),%eax
  800503:	83 ec 08             	sub    $0x8,%esp
  800506:	ff 75 f4             	pushl  -0xc(%ebp)
  800509:	50                   	push   %eax
  80050a:	e8 48 ff ff ff       	call   800457 <vcprintf>
  80050f:	83 c4 10             	add    $0x10,%esp
  800512:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800515:	e8 c9 0d 00 00       	call   8012e3 <sys_unlock_cons>
	return cnt;
  80051a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80051d:	c9                   	leave  
  80051e:	c3                   	ret    

0080051f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80051f:	55                   	push   %ebp
  800520:	89 e5                	mov    %esp,%ebp
  800522:	53                   	push   %ebx
  800523:	83 ec 14             	sub    $0x14,%esp
  800526:	8b 45 10             	mov    0x10(%ebp),%eax
  800529:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80052c:	8b 45 14             	mov    0x14(%ebp),%eax
  80052f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800532:	8b 45 18             	mov    0x18(%ebp),%eax
  800535:	ba 00 00 00 00       	mov    $0x0,%edx
  80053a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80053d:	77 55                	ja     800594 <printnum+0x75>
  80053f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800542:	72 05                	jb     800549 <printnum+0x2a>
  800544:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800547:	77 4b                	ja     800594 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800549:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80054c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80054f:	8b 45 18             	mov    0x18(%ebp),%eax
  800552:	ba 00 00 00 00       	mov    $0x0,%edx
  800557:	52                   	push   %edx
  800558:	50                   	push   %eax
  800559:	ff 75 f4             	pushl  -0xc(%ebp)
  80055c:	ff 75 f0             	pushl  -0x10(%ebp)
  80055f:	e8 24 13 00 00       	call   801888 <__udivdi3>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	83 ec 04             	sub    $0x4,%esp
  80056a:	ff 75 20             	pushl  0x20(%ebp)
  80056d:	53                   	push   %ebx
  80056e:	ff 75 18             	pushl  0x18(%ebp)
  800571:	52                   	push   %edx
  800572:	50                   	push   %eax
  800573:	ff 75 0c             	pushl  0xc(%ebp)
  800576:	ff 75 08             	pushl  0x8(%ebp)
  800579:	e8 a1 ff ff ff       	call   80051f <printnum>
  80057e:	83 c4 20             	add    $0x20,%esp
  800581:	eb 1a                	jmp    80059d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	ff 75 0c             	pushl  0xc(%ebp)
  800589:	ff 75 20             	pushl  0x20(%ebp)
  80058c:	8b 45 08             	mov    0x8(%ebp),%eax
  80058f:	ff d0                	call   *%eax
  800591:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800594:	ff 4d 1c             	decl   0x1c(%ebp)
  800597:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80059b:	7f e6                	jg     800583 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80059d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005ab:	53                   	push   %ebx
  8005ac:	51                   	push   %ecx
  8005ad:	52                   	push   %edx
  8005ae:	50                   	push   %eax
  8005af:	e8 e4 13 00 00       	call   801998 <__umoddi3>
  8005b4:	83 c4 10             	add    $0x10,%esp
  8005b7:	05 14 20 80 00       	add    $0x802014,%eax
  8005bc:	8a 00                	mov    (%eax),%al
  8005be:	0f be c0             	movsbl %al,%eax
  8005c1:	83 ec 08             	sub    $0x8,%esp
  8005c4:	ff 75 0c             	pushl  0xc(%ebp)
  8005c7:	50                   	push   %eax
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	ff d0                	call   *%eax
  8005cd:	83 c4 10             	add    $0x10,%esp
}
  8005d0:	90                   	nop
  8005d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005d4:	c9                   	leave  
  8005d5:	c3                   	ret    

008005d6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005d6:	55                   	push   %ebp
  8005d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005d9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005dd:	7e 1c                	jle    8005fb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
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
  8005f9:	eb 40                	jmp    80063b <getuint+0x65>
	else if (lflag)
  8005fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005ff:	74 1e                	je     80061f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800601:	8b 45 08             	mov    0x8(%ebp),%eax
  800604:	8b 00                	mov    (%eax),%eax
  800606:	8d 50 04             	lea    0x4(%eax),%edx
  800609:	8b 45 08             	mov    0x8(%ebp),%eax
  80060c:	89 10                	mov    %edx,(%eax)
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	8b 00                	mov    (%eax),%eax
  800613:	83 e8 04             	sub    $0x4,%eax
  800616:	8b 00                	mov    (%eax),%eax
  800618:	ba 00 00 00 00       	mov    $0x0,%edx
  80061d:	eb 1c                	jmp    80063b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80061f:	8b 45 08             	mov    0x8(%ebp),%eax
  800622:	8b 00                	mov    (%eax),%eax
  800624:	8d 50 04             	lea    0x4(%eax),%edx
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	89 10                	mov    %edx,(%eax)
  80062c:	8b 45 08             	mov    0x8(%ebp),%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	83 e8 04             	sub    $0x4,%eax
  800634:	8b 00                	mov    (%eax),%eax
  800636:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80063b:	5d                   	pop    %ebp
  80063c:	c3                   	ret    

0080063d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80063d:	55                   	push   %ebp
  80063e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800640:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800644:	7e 1c                	jle    800662 <getint+0x25>
		return va_arg(*ap, long long);
  800646:	8b 45 08             	mov    0x8(%ebp),%eax
  800649:	8b 00                	mov    (%eax),%eax
  80064b:	8d 50 08             	lea    0x8(%eax),%edx
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	89 10                	mov    %edx,(%eax)
  800653:	8b 45 08             	mov    0x8(%ebp),%eax
  800656:	8b 00                	mov    (%eax),%eax
  800658:	83 e8 08             	sub    $0x8,%eax
  80065b:	8b 50 04             	mov    0x4(%eax),%edx
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	eb 38                	jmp    80069a <getint+0x5d>
	else if (lflag)
  800662:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800666:	74 1a                	je     800682 <getint+0x45>
		return va_arg(*ap, long);
  800668:	8b 45 08             	mov    0x8(%ebp),%eax
  80066b:	8b 00                	mov    (%eax),%eax
  80066d:	8d 50 04             	lea    0x4(%eax),%edx
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	89 10                	mov    %edx,(%eax)
  800675:	8b 45 08             	mov    0x8(%ebp),%eax
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	83 e8 04             	sub    $0x4,%eax
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	99                   	cltd   
  800680:	eb 18                	jmp    80069a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	8d 50 04             	lea    0x4(%eax),%edx
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	89 10                	mov    %edx,(%eax)
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	8b 00                	mov    (%eax),%eax
  800694:	83 e8 04             	sub    $0x4,%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	99                   	cltd   
}
  80069a:	5d                   	pop    %ebp
  80069b:	c3                   	ret    

0080069c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80069c:	55                   	push   %ebp
  80069d:	89 e5                	mov    %esp,%ebp
  80069f:	56                   	push   %esi
  8006a0:	53                   	push   %ebx
  8006a1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006a4:	eb 17                	jmp    8006bd <vprintfmt+0x21>
			if (ch == '\0')
  8006a6:	85 db                	test   %ebx,%ebx
  8006a8:	0f 84 c1 03 00 00    	je     800a6f <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8006ae:	83 ec 08             	sub    $0x8,%esp
  8006b1:	ff 75 0c             	pushl  0xc(%ebp)
  8006b4:	53                   	push   %ebx
  8006b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b8:	ff d0                	call   *%eax
  8006ba:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8006c0:	8d 50 01             	lea    0x1(%eax),%edx
  8006c3:	89 55 10             	mov    %edx,0x10(%ebp)
  8006c6:	8a 00                	mov    (%eax),%al
  8006c8:	0f b6 d8             	movzbl %al,%ebx
  8006cb:	83 fb 25             	cmp    $0x25,%ebx
  8006ce:	75 d6                	jne    8006a6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006d0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8006d4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8006db:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006e2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8006e9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8006f3:	8d 50 01             	lea    0x1(%eax),%edx
  8006f6:	89 55 10             	mov    %edx,0x10(%ebp)
  8006f9:	8a 00                	mov    (%eax),%al
  8006fb:	0f b6 d8             	movzbl %al,%ebx
  8006fe:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800701:	83 f8 5b             	cmp    $0x5b,%eax
  800704:	0f 87 3d 03 00 00    	ja     800a47 <vprintfmt+0x3ab>
  80070a:	8b 04 85 38 20 80 00 	mov    0x802038(,%eax,4),%eax
  800711:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800713:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800717:	eb d7                	jmp    8006f0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800719:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80071d:	eb d1                	jmp    8006f0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80071f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800726:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800729:	89 d0                	mov    %edx,%eax
  80072b:	c1 e0 02             	shl    $0x2,%eax
  80072e:	01 d0                	add    %edx,%eax
  800730:	01 c0                	add    %eax,%eax
  800732:	01 d8                	add    %ebx,%eax
  800734:	83 e8 30             	sub    $0x30,%eax
  800737:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80073a:	8b 45 10             	mov    0x10(%ebp),%eax
  80073d:	8a 00                	mov    (%eax),%al
  80073f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800742:	83 fb 2f             	cmp    $0x2f,%ebx
  800745:	7e 3e                	jle    800785 <vprintfmt+0xe9>
  800747:	83 fb 39             	cmp    $0x39,%ebx
  80074a:	7f 39                	jg     800785 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80074c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80074f:	eb d5                	jmp    800726 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	83 c0 04             	add    $0x4,%eax
  800757:	89 45 14             	mov    %eax,0x14(%ebp)
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	83 e8 04             	sub    $0x4,%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800765:	eb 1f                	jmp    800786 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800767:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80076b:	79 83                	jns    8006f0 <vprintfmt+0x54>
				width = 0;
  80076d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800774:	e9 77 ff ff ff       	jmp    8006f0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800779:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800780:	e9 6b ff ff ff       	jmp    8006f0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800785:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800786:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80078a:	0f 89 60 ff ff ff    	jns    8006f0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800790:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800793:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800796:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80079d:	e9 4e ff ff ff       	jmp    8006f0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007a2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007a5:	e9 46 ff ff ff       	jmp    8006f0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ad:	83 c0 04             	add    $0x4,%eax
  8007b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b6:	83 e8 04             	sub    $0x4,%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	ff 75 0c             	pushl  0xc(%ebp)
  8007c1:	50                   	push   %eax
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	ff d0                	call   *%eax
  8007c7:	83 c4 10             	add    $0x10,%esp
			break;
  8007ca:	e9 9b 02 00 00       	jmp    800a6a <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	83 c0 04             	add    $0x4,%eax
  8007d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007db:	83 e8 04             	sub    $0x4,%eax
  8007de:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8007e0:	85 db                	test   %ebx,%ebx
  8007e2:	79 02                	jns    8007e6 <vprintfmt+0x14a>
				err = -err;
  8007e4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007e6:	83 fb 64             	cmp    $0x64,%ebx
  8007e9:	7f 0b                	jg     8007f6 <vprintfmt+0x15a>
  8007eb:	8b 34 9d 80 1e 80 00 	mov    0x801e80(,%ebx,4),%esi
  8007f2:	85 f6                	test   %esi,%esi
  8007f4:	75 19                	jne    80080f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007f6:	53                   	push   %ebx
  8007f7:	68 25 20 80 00       	push   $0x802025
  8007fc:	ff 75 0c             	pushl  0xc(%ebp)
  8007ff:	ff 75 08             	pushl  0x8(%ebp)
  800802:	e8 70 02 00 00       	call   800a77 <printfmt>
  800807:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80080a:	e9 5b 02 00 00       	jmp    800a6a <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80080f:	56                   	push   %esi
  800810:	68 2e 20 80 00       	push   $0x80202e
  800815:	ff 75 0c             	pushl  0xc(%ebp)
  800818:	ff 75 08             	pushl  0x8(%ebp)
  80081b:	e8 57 02 00 00       	call   800a77 <printfmt>
  800820:	83 c4 10             	add    $0x10,%esp
			break;
  800823:	e9 42 02 00 00       	jmp    800a6a <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800828:	8b 45 14             	mov    0x14(%ebp),%eax
  80082b:	83 c0 04             	add    $0x4,%eax
  80082e:	89 45 14             	mov    %eax,0x14(%ebp)
  800831:	8b 45 14             	mov    0x14(%ebp),%eax
  800834:	83 e8 04             	sub    $0x4,%eax
  800837:	8b 30                	mov    (%eax),%esi
  800839:	85 f6                	test   %esi,%esi
  80083b:	75 05                	jne    800842 <vprintfmt+0x1a6>
				p = "(null)";
  80083d:	be 31 20 80 00       	mov    $0x802031,%esi
			if (width > 0 && padc != '-')
  800842:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800846:	7e 6d                	jle    8008b5 <vprintfmt+0x219>
  800848:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80084c:	74 67                	je     8008b5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80084e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800851:	83 ec 08             	sub    $0x8,%esp
  800854:	50                   	push   %eax
  800855:	56                   	push   %esi
  800856:	e8 1e 03 00 00       	call   800b79 <strnlen>
  80085b:	83 c4 10             	add    $0x10,%esp
  80085e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800861:	eb 16                	jmp    800879 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800863:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800867:	83 ec 08             	sub    $0x8,%esp
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	50                   	push   %eax
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	ff d0                	call   *%eax
  800873:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800876:	ff 4d e4             	decl   -0x1c(%ebp)
  800879:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80087d:	7f e4                	jg     800863 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80087f:	eb 34                	jmp    8008b5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800881:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800885:	74 1c                	je     8008a3 <vprintfmt+0x207>
  800887:	83 fb 1f             	cmp    $0x1f,%ebx
  80088a:	7e 05                	jle    800891 <vprintfmt+0x1f5>
  80088c:	83 fb 7e             	cmp    $0x7e,%ebx
  80088f:	7e 12                	jle    8008a3 <vprintfmt+0x207>
					putch('?', putdat);
  800891:	83 ec 08             	sub    $0x8,%esp
  800894:	ff 75 0c             	pushl  0xc(%ebp)
  800897:	6a 3f                	push   $0x3f
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	ff d0                	call   *%eax
  80089e:	83 c4 10             	add    $0x10,%esp
  8008a1:	eb 0f                	jmp    8008b2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008a3:	83 ec 08             	sub    $0x8,%esp
  8008a6:	ff 75 0c             	pushl  0xc(%ebp)
  8008a9:	53                   	push   %ebx
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	ff d0                	call   *%eax
  8008af:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008b2:	ff 4d e4             	decl   -0x1c(%ebp)
  8008b5:	89 f0                	mov    %esi,%eax
  8008b7:	8d 70 01             	lea    0x1(%eax),%esi
  8008ba:	8a 00                	mov    (%eax),%al
  8008bc:	0f be d8             	movsbl %al,%ebx
  8008bf:	85 db                	test   %ebx,%ebx
  8008c1:	74 24                	je     8008e7 <vprintfmt+0x24b>
  8008c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008c7:	78 b8                	js     800881 <vprintfmt+0x1e5>
  8008c9:	ff 4d e0             	decl   -0x20(%ebp)
  8008cc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008d0:	79 af                	jns    800881 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008d2:	eb 13                	jmp    8008e7 <vprintfmt+0x24b>
				putch(' ', putdat);
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	ff 75 0c             	pushl  0xc(%ebp)
  8008da:	6a 20                	push   $0x20
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	ff d0                	call   *%eax
  8008e1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008e4:	ff 4d e4             	decl   -0x1c(%ebp)
  8008e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008eb:	7f e7                	jg     8008d4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8008ed:	e9 78 01 00 00       	jmp    800a6a <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	ff 75 e8             	pushl  -0x18(%ebp)
  8008f8:	8d 45 14             	lea    0x14(%ebp),%eax
  8008fb:	50                   	push   %eax
  8008fc:	e8 3c fd ff ff       	call   80063d <getint>
  800901:	83 c4 10             	add    $0x10,%esp
  800904:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800907:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80090a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80090d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800910:	85 d2                	test   %edx,%edx
  800912:	79 23                	jns    800937 <vprintfmt+0x29b>
				putch('-', putdat);
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	ff 75 0c             	pushl  0xc(%ebp)
  80091a:	6a 2d                	push   $0x2d
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	ff d0                	call   *%eax
  800921:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800924:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800927:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80092a:	f7 d8                	neg    %eax
  80092c:	83 d2 00             	adc    $0x0,%edx
  80092f:	f7 da                	neg    %edx
  800931:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800934:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800937:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80093e:	e9 bc 00 00 00       	jmp    8009ff <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800943:	83 ec 08             	sub    $0x8,%esp
  800946:	ff 75 e8             	pushl  -0x18(%ebp)
  800949:	8d 45 14             	lea    0x14(%ebp),%eax
  80094c:	50                   	push   %eax
  80094d:	e8 84 fc ff ff       	call   8005d6 <getuint>
  800952:	83 c4 10             	add    $0x10,%esp
  800955:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800958:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80095b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800962:	e9 98 00 00 00       	jmp    8009ff <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	ff 75 0c             	pushl  0xc(%ebp)
  80096d:	6a 58                	push   $0x58
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	ff d0                	call   *%eax
  800974:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800977:	83 ec 08             	sub    $0x8,%esp
  80097a:	ff 75 0c             	pushl  0xc(%ebp)
  80097d:	6a 58                	push   $0x58
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	ff d0                	call   *%eax
  800984:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800987:	83 ec 08             	sub    $0x8,%esp
  80098a:	ff 75 0c             	pushl  0xc(%ebp)
  80098d:	6a 58                	push   $0x58
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	ff d0                	call   *%eax
  800994:	83 c4 10             	add    $0x10,%esp
			break;
  800997:	e9 ce 00 00 00       	jmp    800a6a <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80099c:	83 ec 08             	sub    $0x8,%esp
  80099f:	ff 75 0c             	pushl  0xc(%ebp)
  8009a2:	6a 30                	push   $0x30
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	ff d0                	call   *%eax
  8009a9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8009ac:	83 ec 08             	sub    $0x8,%esp
  8009af:	ff 75 0c             	pushl  0xc(%ebp)
  8009b2:	6a 78                	push   $0x78
  8009b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b7:	ff d0                	call   *%eax
  8009b9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8009bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bf:	83 c0 04             	add    $0x4,%eax
  8009c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c8:	83 e8 04             	sub    $0x4,%eax
  8009cb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8009cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8009d7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8009de:	eb 1f                	jmp    8009ff <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	ff 75 e8             	pushl  -0x18(%ebp)
  8009e6:	8d 45 14             	lea    0x14(%ebp),%eax
  8009e9:	50                   	push   %eax
  8009ea:	e8 e7 fb ff ff       	call   8005d6 <getuint>
  8009ef:	83 c4 10             	add    $0x10,%esp
  8009f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009f8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009ff:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a06:	83 ec 04             	sub    $0x4,%esp
  800a09:	52                   	push   %edx
  800a0a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a0d:	50                   	push   %eax
  800a0e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a11:	ff 75 f0             	pushl  -0x10(%ebp)
  800a14:	ff 75 0c             	pushl  0xc(%ebp)
  800a17:	ff 75 08             	pushl  0x8(%ebp)
  800a1a:	e8 00 fb ff ff       	call   80051f <printnum>
  800a1f:	83 c4 20             	add    $0x20,%esp
			break;
  800a22:	eb 46                	jmp    800a6a <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a24:	83 ec 08             	sub    $0x8,%esp
  800a27:	ff 75 0c             	pushl  0xc(%ebp)
  800a2a:	53                   	push   %ebx
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	ff d0                	call   *%eax
  800a30:	83 c4 10             	add    $0x10,%esp
			break;
  800a33:	eb 35                	jmp    800a6a <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a35:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800a3c:	eb 2c                	jmp    800a6a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a3e:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800a45:	eb 23                	jmp    800a6a <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a47:	83 ec 08             	sub    $0x8,%esp
  800a4a:	ff 75 0c             	pushl  0xc(%ebp)
  800a4d:	6a 25                	push   $0x25
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	ff d0                	call   *%eax
  800a54:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a57:	ff 4d 10             	decl   0x10(%ebp)
  800a5a:	eb 03                	jmp    800a5f <vprintfmt+0x3c3>
  800a5c:	ff 4d 10             	decl   0x10(%ebp)
  800a5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800a62:	48                   	dec    %eax
  800a63:	8a 00                	mov    (%eax),%al
  800a65:	3c 25                	cmp    $0x25,%al
  800a67:	75 f3                	jne    800a5c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a69:	90                   	nop
		}
	}
  800a6a:	e9 35 fc ff ff       	jmp    8006a4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a6f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a70:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a73:	5b                   	pop    %ebx
  800a74:	5e                   	pop    %esi
  800a75:	5d                   	pop    %ebp
  800a76:	c3                   	ret    

00800a77 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a77:	55                   	push   %ebp
  800a78:	89 e5                	mov    %esp,%ebp
  800a7a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a7d:	8d 45 10             	lea    0x10(%ebp),%eax
  800a80:	83 c0 04             	add    $0x4,%eax
  800a83:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a86:	8b 45 10             	mov    0x10(%ebp),%eax
  800a89:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8c:	50                   	push   %eax
  800a8d:	ff 75 0c             	pushl  0xc(%ebp)
  800a90:	ff 75 08             	pushl  0x8(%ebp)
  800a93:	e8 04 fc ff ff       	call   80069c <vprintfmt>
  800a98:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a9b:	90                   	nop
  800a9c:	c9                   	leave  
  800a9d:	c3                   	ret    

00800a9e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a9e:	55                   	push   %ebp
  800a9f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800aa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa4:	8b 40 08             	mov    0x8(%eax),%eax
  800aa7:	8d 50 01             	lea    0x1(%eax),%edx
  800aaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aad:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ab0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab3:	8b 10                	mov    (%eax),%edx
  800ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab8:	8b 40 04             	mov    0x4(%eax),%eax
  800abb:	39 c2                	cmp    %eax,%edx
  800abd:	73 12                	jae    800ad1 <sprintputch+0x33>
		*b->buf++ = ch;
  800abf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac2:	8b 00                	mov    (%eax),%eax
  800ac4:	8d 48 01             	lea    0x1(%eax),%ecx
  800ac7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aca:	89 0a                	mov    %ecx,(%edx)
  800acc:	8b 55 08             	mov    0x8(%ebp),%edx
  800acf:	88 10                	mov    %dl,(%eax)
}
  800ad1:	90                   	nop
  800ad2:	5d                   	pop    %ebp
  800ad3:	c3                   	ret    

00800ad4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ad4:	55                   	push   %ebp
  800ad5:	89 e5                	mov    %esp,%ebp
  800ad7:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	01 d0                	add    %edx,%eax
  800aeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800af5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800af9:	74 06                	je     800b01 <vsnprintf+0x2d>
  800afb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aff:	7f 07                	jg     800b08 <vsnprintf+0x34>
		return -E_INVAL;
  800b01:	b8 03 00 00 00       	mov    $0x3,%eax
  800b06:	eb 20                	jmp    800b28 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b08:	ff 75 14             	pushl  0x14(%ebp)
  800b0b:	ff 75 10             	pushl  0x10(%ebp)
  800b0e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b11:	50                   	push   %eax
  800b12:	68 9e 0a 80 00       	push   $0x800a9e
  800b17:	e8 80 fb ff ff       	call   80069c <vprintfmt>
  800b1c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b22:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b28:	c9                   	leave  
  800b29:	c3                   	ret    

00800b2a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b30:	8d 45 10             	lea    0x10(%ebp),%eax
  800b33:	83 c0 04             	add    $0x4,%eax
  800b36:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b39:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3f:	50                   	push   %eax
  800b40:	ff 75 0c             	pushl  0xc(%ebp)
  800b43:	ff 75 08             	pushl  0x8(%ebp)
  800b46:	e8 89 ff ff ff       	call   800ad4 <vsnprintf>
  800b4b:	83 c4 10             	add    $0x10,%esp
  800b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b54:	c9                   	leave  
  800b55:	c3                   	ret    

00800b56 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b63:	eb 06                	jmp    800b6b <strlen+0x15>
		n++;
  800b65:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b68:	ff 45 08             	incl   0x8(%ebp)
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	8a 00                	mov    (%eax),%al
  800b70:	84 c0                	test   %al,%al
  800b72:	75 f1                	jne    800b65 <strlen+0xf>
		n++;
	return n;
  800b74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b77:	c9                   	leave  
  800b78:	c3                   	ret    

00800b79 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
  800b7c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b86:	eb 09                	jmp    800b91 <strnlen+0x18>
		n++;
  800b88:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b8b:	ff 45 08             	incl   0x8(%ebp)
  800b8e:	ff 4d 0c             	decl   0xc(%ebp)
  800b91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b95:	74 09                	je     800ba0 <strnlen+0x27>
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	8a 00                	mov    (%eax),%al
  800b9c:	84 c0                	test   %al,%al
  800b9e:	75 e8                	jne    800b88 <strnlen+0xf>
		n++;
	return n;
  800ba0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ba3:	c9                   	leave  
  800ba4:	c3                   	ret    

00800ba5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bab:	8b 45 08             	mov    0x8(%ebp),%eax
  800bae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bb1:	90                   	nop
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb5:	8d 50 01             	lea    0x1(%eax),%edx
  800bb8:	89 55 08             	mov    %edx,0x8(%ebp)
  800bbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bc1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bc4:	8a 12                	mov    (%edx),%dl
  800bc6:	88 10                	mov    %dl,(%eax)
  800bc8:	8a 00                	mov    (%eax),%al
  800bca:	84 c0                	test   %al,%al
  800bcc:	75 e4                	jne    800bb2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800bce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd1:	c9                   	leave  
  800bd2:	c3                   	ret    

00800bd3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800bdf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be6:	eb 1f                	jmp    800c07 <strncpy+0x34>
		*dst++ = *src;
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	8d 50 01             	lea    0x1(%eax),%edx
  800bee:	89 55 08             	mov    %edx,0x8(%ebp)
  800bf1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf4:	8a 12                	mov    (%edx),%dl
  800bf6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfb:	8a 00                	mov    (%eax),%al
  800bfd:	84 c0                	test   %al,%al
  800bff:	74 03                	je     800c04 <strncpy+0x31>
			src++;
  800c01:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c04:	ff 45 fc             	incl   -0x4(%ebp)
  800c07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c0a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c0d:	72 d9                	jb     800be8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c12:	c9                   	leave  
  800c13:	c3                   	ret    

00800c14 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c20:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c24:	74 30                	je     800c56 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c26:	eb 16                	jmp    800c3e <strlcpy+0x2a>
			*dst++ = *src++;
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	8d 50 01             	lea    0x1(%eax),%edx
  800c2e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c31:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c34:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c37:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c3a:	8a 12                	mov    (%edx),%dl
  800c3c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c3e:	ff 4d 10             	decl   0x10(%ebp)
  800c41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c45:	74 09                	je     800c50 <strlcpy+0x3c>
  800c47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4a:	8a 00                	mov    (%eax),%al
  800c4c:	84 c0                	test   %al,%al
  800c4e:	75 d8                	jne    800c28 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c56:	8b 55 08             	mov    0x8(%ebp),%edx
  800c59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c5c:	29 c2                	sub    %eax,%edx
  800c5e:	89 d0                	mov    %edx,%eax
}
  800c60:	c9                   	leave  
  800c61:	c3                   	ret    

00800c62 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c65:	eb 06                	jmp    800c6d <strcmp+0xb>
		p++, q++;
  800c67:	ff 45 08             	incl   0x8(%ebp)
  800c6a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	8a 00                	mov    (%eax),%al
  800c72:	84 c0                	test   %al,%al
  800c74:	74 0e                	je     800c84 <strcmp+0x22>
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	8a 10                	mov    (%eax),%dl
  800c7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7e:	8a 00                	mov    (%eax),%al
  800c80:	38 c2                	cmp    %al,%dl
  800c82:	74 e3                	je     800c67 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	8a 00                	mov    (%eax),%al
  800c89:	0f b6 d0             	movzbl %al,%edx
  800c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8f:	8a 00                	mov    (%eax),%al
  800c91:	0f b6 c0             	movzbl %al,%eax
  800c94:	29 c2                	sub    %eax,%edx
  800c96:	89 d0                	mov    %edx,%eax
}
  800c98:	5d                   	pop    %ebp
  800c99:	c3                   	ret    

00800c9a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c9d:	eb 09                	jmp    800ca8 <strncmp+0xe>
		n--, p++, q++;
  800c9f:	ff 4d 10             	decl   0x10(%ebp)
  800ca2:	ff 45 08             	incl   0x8(%ebp)
  800ca5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ca8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cac:	74 17                	je     800cc5 <strncmp+0x2b>
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	8a 00                	mov    (%eax),%al
  800cb3:	84 c0                	test   %al,%al
  800cb5:	74 0e                	je     800cc5 <strncmp+0x2b>
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	8a 10                	mov    (%eax),%dl
  800cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbf:	8a 00                	mov    (%eax),%al
  800cc1:	38 c2                	cmp    %al,%dl
  800cc3:	74 da                	je     800c9f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800cc5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc9:	75 07                	jne    800cd2 <strncmp+0x38>
		return 0;
  800ccb:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd0:	eb 14                	jmp    800ce6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	0f b6 d0             	movzbl %al,%edx
  800cda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	0f b6 c0             	movzbl %al,%eax
  800ce2:	29 c2                	sub    %eax,%edx
  800ce4:	89 d0                	mov    %edx,%eax
}
  800ce6:	5d                   	pop    %ebp
  800ce7:	c3                   	ret    

00800ce8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	83 ec 04             	sub    $0x4,%esp
  800cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cf4:	eb 12                	jmp    800d08 <strchr+0x20>
		if (*s == c)
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	8a 00                	mov    (%eax),%al
  800cfb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cfe:	75 05                	jne    800d05 <strchr+0x1d>
			return (char *) s;
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	eb 11                	jmp    800d16 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d05:	ff 45 08             	incl   0x8(%ebp)
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8a 00                	mov    (%eax),%al
  800d0d:	84 c0                	test   %al,%al
  800d0f:	75 e5                	jne    800cf6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d16:	c9                   	leave  
  800d17:	c3                   	ret    

00800d18 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
  800d1b:	83 ec 04             	sub    $0x4,%esp
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d24:	eb 0d                	jmp    800d33 <strfind+0x1b>
		if (*s == c)
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	8a 00                	mov    (%eax),%al
  800d2b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d2e:	74 0e                	je     800d3e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d30:	ff 45 08             	incl   0x8(%ebp)
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	8a 00                	mov    (%eax),%al
  800d38:	84 c0                	test   %al,%al
  800d3a:	75 ea                	jne    800d26 <strfind+0xe>
  800d3c:	eb 01                	jmp    800d3f <strfind+0x27>
		if (*s == c)
			break;
  800d3e:	90                   	nop
	return (char *) s;
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d42:	c9                   	leave  
  800d43:	c3                   	ret    

00800d44 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d50:	8b 45 10             	mov    0x10(%ebp),%eax
  800d53:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d56:	eb 0e                	jmp    800d66 <memset+0x22>
		*p++ = c;
  800d58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d5b:	8d 50 01             	lea    0x1(%eax),%edx
  800d5e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d64:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d66:	ff 4d f8             	decl   -0x8(%ebp)
  800d69:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d6d:	79 e9                	jns    800d58 <memset+0x14>
		*p++ = c;

	return v;
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d72:	c9                   	leave  
  800d73:	c3                   	ret    

00800d74 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
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
	while (n-- > 0)
  800d86:	eb 16                	jmp    800d9e <memcpy+0x2a>
		*d++ = *s++;
  800d88:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8b:	8d 50 01             	lea    0x1(%eax),%edx
  800d8e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d91:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d94:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d97:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d9a:	8a 12                	mov    (%edx),%dl
  800d9c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800da1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da4:	89 55 10             	mov    %edx,0x10(%ebp)
  800da7:	85 c0                	test   %eax,%eax
  800da9:	75 dd                	jne    800d88 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800db6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dc8:	73 50                	jae    800e1a <memmove+0x6a>
  800dca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd0:	01 d0                	add    %edx,%eax
  800dd2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dd5:	76 43                	jbe    800e1a <memmove+0x6a>
		s += n;
  800dd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dda:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ddd:	8b 45 10             	mov    0x10(%ebp),%eax
  800de0:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800de3:	eb 10                	jmp    800df5 <memmove+0x45>
			*--d = *--s;
  800de5:	ff 4d f8             	decl   -0x8(%ebp)
  800de8:	ff 4d fc             	decl   -0x4(%ebp)
  800deb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dee:	8a 10                	mov    (%eax),%dl
  800df0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df3:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800df5:	8b 45 10             	mov    0x10(%ebp),%eax
  800df8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dfb:	89 55 10             	mov    %edx,0x10(%ebp)
  800dfe:	85 c0                	test   %eax,%eax
  800e00:	75 e3                	jne    800de5 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e02:	eb 23                	jmp    800e27 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e04:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e07:	8d 50 01             	lea    0x1(%eax),%edx
  800e0a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e0d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e10:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e13:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e16:	8a 12                	mov    (%edx),%dl
  800e18:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e20:	89 55 10             	mov    %edx,0x10(%ebp)
  800e23:	85 c0                	test   %eax,%eax
  800e25:	75 dd                	jne    800e04 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e2a:	c9                   	leave  
  800e2b:	c3                   	ret    

00800e2c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e3e:	eb 2a                	jmp    800e6a <memcmp+0x3e>
		if (*s1 != *s2)
  800e40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e43:	8a 10                	mov    (%eax),%dl
  800e45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e48:	8a 00                	mov    (%eax),%al
  800e4a:	38 c2                	cmp    %al,%dl
  800e4c:	74 16                	je     800e64 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e51:	8a 00                	mov    (%eax),%al
  800e53:	0f b6 d0             	movzbl %al,%edx
  800e56:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	0f b6 c0             	movzbl %al,%eax
  800e5e:	29 c2                	sub    %eax,%edx
  800e60:	89 d0                	mov    %edx,%eax
  800e62:	eb 18                	jmp    800e7c <memcmp+0x50>
		s1++, s2++;
  800e64:	ff 45 fc             	incl   -0x4(%ebp)
  800e67:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e70:	89 55 10             	mov    %edx,0x10(%ebp)
  800e73:	85 c0                	test   %eax,%eax
  800e75:	75 c9                	jne    800e40 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e7c:	c9                   	leave  
  800e7d:	c3                   	ret    

00800e7e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e84:	8b 55 08             	mov    0x8(%ebp),%edx
  800e87:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8a:	01 d0                	add    %edx,%eax
  800e8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e8f:	eb 15                	jmp    800ea6 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	0f b6 d0             	movzbl %al,%edx
  800e99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9c:	0f b6 c0             	movzbl %al,%eax
  800e9f:	39 c2                	cmp    %eax,%edx
  800ea1:	74 0d                	je     800eb0 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ea3:	ff 45 08             	incl   0x8(%ebp)
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800eac:	72 e3                	jb     800e91 <memfind+0x13>
  800eae:	eb 01                	jmp    800eb1 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800eb0:	90                   	nop
	return (void *) s;
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb4:	c9                   	leave  
  800eb5:	c3                   	ret    

00800eb6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ebc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ec3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eca:	eb 03                	jmp    800ecf <strtol+0x19>
		s++;
  800ecc:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	8a 00                	mov    (%eax),%al
  800ed4:	3c 20                	cmp    $0x20,%al
  800ed6:	74 f4                	je     800ecc <strtol+0x16>
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	8a 00                	mov    (%eax),%al
  800edd:	3c 09                	cmp    $0x9,%al
  800edf:	74 eb                	je     800ecc <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	8a 00                	mov    (%eax),%al
  800ee6:	3c 2b                	cmp    $0x2b,%al
  800ee8:	75 05                	jne    800eef <strtol+0x39>
		s++;
  800eea:	ff 45 08             	incl   0x8(%ebp)
  800eed:	eb 13                	jmp    800f02 <strtol+0x4c>
	else if (*s == '-')
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	3c 2d                	cmp    $0x2d,%al
  800ef6:	75 0a                	jne    800f02 <strtol+0x4c>
		s++, neg = 1;
  800ef8:	ff 45 08             	incl   0x8(%ebp)
  800efb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f02:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f06:	74 06                	je     800f0e <strtol+0x58>
  800f08:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f0c:	75 20                	jne    800f2e <strtol+0x78>
  800f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f11:	8a 00                	mov    (%eax),%al
  800f13:	3c 30                	cmp    $0x30,%al
  800f15:	75 17                	jne    800f2e <strtol+0x78>
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	40                   	inc    %eax
  800f1b:	8a 00                	mov    (%eax),%al
  800f1d:	3c 78                	cmp    $0x78,%al
  800f1f:	75 0d                	jne    800f2e <strtol+0x78>
		s += 2, base = 16;
  800f21:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f25:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f2c:	eb 28                	jmp    800f56 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f32:	75 15                	jne    800f49 <strtol+0x93>
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	8a 00                	mov    (%eax),%al
  800f39:	3c 30                	cmp    $0x30,%al
  800f3b:	75 0c                	jne    800f49 <strtol+0x93>
		s++, base = 8;
  800f3d:	ff 45 08             	incl   0x8(%ebp)
  800f40:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f47:	eb 0d                	jmp    800f56 <strtol+0xa0>
	else if (base == 0)
  800f49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4d:	75 07                	jne    800f56 <strtol+0xa0>
		base = 10;
  800f4f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	3c 2f                	cmp    $0x2f,%al
  800f5d:	7e 19                	jle    800f78 <strtol+0xc2>
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3c 39                	cmp    $0x39,%al
  800f66:	7f 10                	jg     800f78 <strtol+0xc2>
			dig = *s - '0';
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	8a 00                	mov    (%eax),%al
  800f6d:	0f be c0             	movsbl %al,%eax
  800f70:	83 e8 30             	sub    $0x30,%eax
  800f73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f76:	eb 42                	jmp    800fba <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7b:	8a 00                	mov    (%eax),%al
  800f7d:	3c 60                	cmp    $0x60,%al
  800f7f:	7e 19                	jle    800f9a <strtol+0xe4>
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	3c 7a                	cmp    $0x7a,%al
  800f88:	7f 10                	jg     800f9a <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	8a 00                	mov    (%eax),%al
  800f8f:	0f be c0             	movsbl %al,%eax
  800f92:	83 e8 57             	sub    $0x57,%eax
  800f95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f98:	eb 20                	jmp    800fba <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	3c 40                	cmp    $0x40,%al
  800fa1:	7e 39                	jle    800fdc <strtol+0x126>
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	3c 5a                	cmp    $0x5a,%al
  800faa:	7f 30                	jg     800fdc <strtol+0x126>
			dig = *s - 'A' + 10;
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f be c0             	movsbl %al,%eax
  800fb4:	83 e8 37             	sub    $0x37,%eax
  800fb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fbd:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fc0:	7d 19                	jge    800fdb <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fc2:	ff 45 08             	incl   0x8(%ebp)
  800fc5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc8:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fcc:	89 c2                	mov    %eax,%edx
  800fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd1:	01 d0                	add    %edx,%eax
  800fd3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800fd6:	e9 7b ff ff ff       	jmp    800f56 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800fdb:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800fdc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fe0:	74 08                	je     800fea <strtol+0x134>
		*endptr = (char *) s;
  800fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe8:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800fea:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fee:	74 07                	je     800ff7 <strtol+0x141>
  800ff0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff3:	f7 d8                	neg    %eax
  800ff5:	eb 03                	jmp    800ffa <strtol+0x144>
  800ff7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ffa:	c9                   	leave  
  800ffb:	c3                   	ret    

00800ffc <ltostr>:

void
ltostr(long value, char *str)
{
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
  800fff:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801002:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801009:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801010:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801014:	79 13                	jns    801029 <ltostr+0x2d>
	{
		neg = 1;
  801016:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80101d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801020:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801023:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801026:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801031:	99                   	cltd   
  801032:	f7 f9                	idiv   %ecx
  801034:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801037:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103a:	8d 50 01             	lea    0x1(%eax),%edx
  80103d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801040:	89 c2                	mov    %eax,%edx
  801042:	8b 45 0c             	mov    0xc(%ebp),%eax
  801045:	01 d0                	add    %edx,%eax
  801047:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80104a:	83 c2 30             	add    $0x30,%edx
  80104d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80104f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801052:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801057:	f7 e9                	imul   %ecx
  801059:	c1 fa 02             	sar    $0x2,%edx
  80105c:	89 c8                	mov    %ecx,%eax
  80105e:	c1 f8 1f             	sar    $0x1f,%eax
  801061:	29 c2                	sub    %eax,%edx
  801063:	89 d0                	mov    %edx,%eax
  801065:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801068:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80106c:	75 bb                	jne    801029 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80106e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801075:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801078:	48                   	dec    %eax
  801079:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80107c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801080:	74 3d                	je     8010bf <ltostr+0xc3>
		start = 1 ;
  801082:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801089:	eb 34                	jmp    8010bf <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80108b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80108e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801091:	01 d0                	add    %edx,%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801098:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80109b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109e:	01 c2                	add    %eax,%edx
  8010a0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a6:	01 c8                	add    %ecx,%eax
  8010a8:	8a 00                	mov    (%eax),%al
  8010aa:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b2:	01 c2                	add    %eax,%edx
  8010b4:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010b7:	88 02                	mov    %al,(%edx)
		start++ ;
  8010b9:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010bc:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010c5:	7c c4                	jl     80108b <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010c7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8010ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cd:	01 d0                	add    %edx,%eax
  8010cf:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8010d2:	90                   	nop
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    

008010d5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8010db:	ff 75 08             	pushl  0x8(%ebp)
  8010de:	e8 73 fa ff ff       	call   800b56 <strlen>
  8010e3:	83 c4 04             	add    $0x4,%esp
  8010e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8010e9:	ff 75 0c             	pushl  0xc(%ebp)
  8010ec:	e8 65 fa ff ff       	call   800b56 <strlen>
  8010f1:	83 c4 04             	add    $0x4,%esp
  8010f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801105:	eb 17                	jmp    80111e <strcconcat+0x49>
		final[s] = str1[s] ;
  801107:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80110a:	8b 45 10             	mov    0x10(%ebp),%eax
  80110d:	01 c2                	add    %eax,%edx
  80110f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	01 c8                	add    %ecx,%eax
  801117:	8a 00                	mov    (%eax),%al
  801119:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80111b:	ff 45 fc             	incl   -0x4(%ebp)
  80111e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801121:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801124:	7c e1                	jl     801107 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801126:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80112d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801134:	eb 1f                	jmp    801155 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801136:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801139:	8d 50 01             	lea    0x1(%eax),%edx
  80113c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80113f:	89 c2                	mov    %eax,%edx
  801141:	8b 45 10             	mov    0x10(%ebp),%eax
  801144:	01 c2                	add    %eax,%edx
  801146:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801149:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114c:	01 c8                	add    %ecx,%eax
  80114e:	8a 00                	mov    (%eax),%al
  801150:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801152:	ff 45 f8             	incl   -0x8(%ebp)
  801155:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801158:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80115b:	7c d9                	jl     801136 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80115d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801160:	8b 45 10             	mov    0x10(%ebp),%eax
  801163:	01 d0                	add    %edx,%eax
  801165:	c6 00 00             	movb   $0x0,(%eax)
}
  801168:	90                   	nop
  801169:	c9                   	leave  
  80116a:	c3                   	ret    

0080116b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80116b:	55                   	push   %ebp
  80116c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80116e:	8b 45 14             	mov    0x14(%ebp),%eax
  801171:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801177:	8b 45 14             	mov    0x14(%ebp),%eax
  80117a:	8b 00                	mov    (%eax),%eax
  80117c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801183:	8b 45 10             	mov    0x10(%ebp),%eax
  801186:	01 d0                	add    %edx,%eax
  801188:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80118e:	eb 0c                	jmp    80119c <strsplit+0x31>
			*string++ = 0;
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	8d 50 01             	lea    0x1(%eax),%edx
  801196:	89 55 08             	mov    %edx,0x8(%ebp)
  801199:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	8a 00                	mov    (%eax),%al
  8011a1:	84 c0                	test   %al,%al
  8011a3:	74 18                	je     8011bd <strsplit+0x52>
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	0f be c0             	movsbl %al,%eax
  8011ad:	50                   	push   %eax
  8011ae:	ff 75 0c             	pushl  0xc(%ebp)
  8011b1:	e8 32 fb ff ff       	call   800ce8 <strchr>
  8011b6:	83 c4 08             	add    $0x8,%esp
  8011b9:	85 c0                	test   %eax,%eax
  8011bb:	75 d3                	jne    801190 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	8a 00                	mov    (%eax),%al
  8011c2:	84 c0                	test   %al,%al
  8011c4:	74 5a                	je     801220 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c9:	8b 00                	mov    (%eax),%eax
  8011cb:	83 f8 0f             	cmp    $0xf,%eax
  8011ce:	75 07                	jne    8011d7 <strsplit+0x6c>
		{
			return 0;
  8011d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d5:	eb 66                	jmp    80123d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8011d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8011da:	8b 00                	mov    (%eax),%eax
  8011dc:	8d 48 01             	lea    0x1(%eax),%ecx
  8011df:	8b 55 14             	mov    0x14(%ebp),%edx
  8011e2:	89 0a                	mov    %ecx,(%edx)
  8011e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ee:	01 c2                	add    %eax,%edx
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011f5:	eb 03                	jmp    8011fa <strsplit+0x8f>
			string++;
  8011f7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	84 c0                	test   %al,%al
  801201:	74 8b                	je     80118e <strsplit+0x23>
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	0f be c0             	movsbl %al,%eax
  80120b:	50                   	push   %eax
  80120c:	ff 75 0c             	pushl  0xc(%ebp)
  80120f:	e8 d4 fa ff ff       	call   800ce8 <strchr>
  801214:	83 c4 08             	add    $0x8,%esp
  801217:	85 c0                	test   %eax,%eax
  801219:	74 dc                	je     8011f7 <strsplit+0x8c>
			string++;
	}
  80121b:	e9 6e ff ff ff       	jmp    80118e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801220:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801221:	8b 45 14             	mov    0x14(%ebp),%eax
  801224:	8b 00                	mov    (%eax),%eax
  801226:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80122d:	8b 45 10             	mov    0x10(%ebp),%eax
  801230:	01 d0                	add    %edx,%eax
  801232:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801238:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80123d:	c9                   	leave  
  80123e:	c3                   	ret    

0080123f <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80123f:	55                   	push   %ebp
  801240:	89 e5                	mov    %esp,%ebp
  801242:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801245:	83 ec 04             	sub    $0x4,%esp
  801248:	68 a8 21 80 00       	push   $0x8021a8
  80124d:	68 3f 01 00 00       	push   $0x13f
  801252:	68 ca 21 80 00       	push   $0x8021ca
  801257:	e8 a9 ef ff ff       	call   800205 <_panic>

0080125c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
  80125f:	57                   	push   %edi
  801260:	56                   	push   %esi
  801261:	53                   	push   %ebx
  801262:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801265:	8b 45 08             	mov    0x8(%ebp),%eax
  801268:	8b 55 0c             	mov    0xc(%ebp),%edx
  80126b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80126e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801271:	8b 7d 18             	mov    0x18(%ebp),%edi
  801274:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801277:	cd 30                	int    $0x30
  801279:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80127c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80127f:	83 c4 10             	add    $0x10,%esp
  801282:	5b                   	pop    %ebx
  801283:	5e                   	pop    %esi
  801284:	5f                   	pop    %edi
  801285:	5d                   	pop    %ebp
  801286:	c3                   	ret    

00801287 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801287:	55                   	push   %ebp
  801288:	89 e5                	mov    %esp,%ebp
  80128a:	83 ec 04             	sub    $0x4,%esp
  80128d:	8b 45 10             	mov    0x10(%ebp),%eax
  801290:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801293:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	6a 00                	push   $0x0
  80129c:	6a 00                	push   $0x0
  80129e:	52                   	push   %edx
  80129f:	ff 75 0c             	pushl  0xc(%ebp)
  8012a2:	50                   	push   %eax
  8012a3:	6a 00                	push   $0x0
  8012a5:	e8 b2 ff ff ff       	call   80125c <syscall>
  8012aa:	83 c4 18             	add    $0x18,%esp
}
  8012ad:	90                   	nop
  8012ae:	c9                   	leave  
  8012af:	c3                   	ret    

008012b0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012b3:	6a 00                	push   $0x0
  8012b5:	6a 00                	push   $0x0
  8012b7:	6a 00                	push   $0x0
  8012b9:	6a 00                	push   $0x0
  8012bb:	6a 00                	push   $0x0
  8012bd:	6a 02                	push   $0x2
  8012bf:	e8 98 ff ff ff       	call   80125c <syscall>
  8012c4:	83 c4 18             	add    $0x18,%esp
}
  8012c7:	c9                   	leave  
  8012c8:	c3                   	ret    

008012c9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8012c9:	55                   	push   %ebp
  8012ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8012cc:	6a 00                	push   $0x0
  8012ce:	6a 00                	push   $0x0
  8012d0:	6a 00                	push   $0x0
  8012d2:	6a 00                	push   $0x0
  8012d4:	6a 00                	push   $0x0
  8012d6:	6a 03                	push   $0x3
  8012d8:	e8 7f ff ff ff       	call   80125c <syscall>
  8012dd:	83 c4 18             	add    $0x18,%esp
}
  8012e0:	90                   	nop
  8012e1:	c9                   	leave  
  8012e2:	c3                   	ret    

008012e3 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8012e6:	6a 00                	push   $0x0
  8012e8:	6a 00                	push   $0x0
  8012ea:	6a 00                	push   $0x0
  8012ec:	6a 00                	push   $0x0
  8012ee:	6a 00                	push   $0x0
  8012f0:	6a 04                	push   $0x4
  8012f2:	e8 65 ff ff ff       	call   80125c <syscall>
  8012f7:	83 c4 18             	add    $0x18,%esp
}
  8012fa:	90                   	nop
  8012fb:	c9                   	leave  
  8012fc:	c3                   	ret    

008012fd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801300:	8b 55 0c             	mov    0xc(%ebp),%edx
  801303:	8b 45 08             	mov    0x8(%ebp),%eax
  801306:	6a 00                	push   $0x0
  801308:	6a 00                	push   $0x0
  80130a:	6a 00                	push   $0x0
  80130c:	52                   	push   %edx
  80130d:	50                   	push   %eax
  80130e:	6a 08                	push   $0x8
  801310:	e8 47 ff ff ff       	call   80125c <syscall>
  801315:	83 c4 18             	add    $0x18,%esp
}
  801318:	c9                   	leave  
  801319:	c3                   	ret    

0080131a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
  80131d:	56                   	push   %esi
  80131e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80131f:	8b 75 18             	mov    0x18(%ebp),%esi
  801322:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801325:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801328:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132b:	8b 45 08             	mov    0x8(%ebp),%eax
  80132e:	56                   	push   %esi
  80132f:	53                   	push   %ebx
  801330:	51                   	push   %ecx
  801331:	52                   	push   %edx
  801332:	50                   	push   %eax
  801333:	6a 09                	push   $0x9
  801335:	e8 22 ff ff ff       	call   80125c <syscall>
  80133a:	83 c4 18             	add    $0x18,%esp
}
  80133d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801340:	5b                   	pop    %ebx
  801341:	5e                   	pop    %esi
  801342:	5d                   	pop    %ebp
  801343:	c3                   	ret    

00801344 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801347:	8b 55 0c             	mov    0xc(%ebp),%edx
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	6a 00                	push   $0x0
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	52                   	push   %edx
  801354:	50                   	push   %eax
  801355:	6a 0a                	push   $0xa
  801357:	e8 00 ff ff ff       	call   80125c <syscall>
  80135c:	83 c4 18             	add    $0x18,%esp
}
  80135f:	c9                   	leave  
  801360:	c3                   	ret    

00801361 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801364:	6a 00                	push   $0x0
  801366:	6a 00                	push   $0x0
  801368:	6a 00                	push   $0x0
  80136a:	ff 75 0c             	pushl  0xc(%ebp)
  80136d:	ff 75 08             	pushl  0x8(%ebp)
  801370:	6a 0b                	push   $0xb
  801372:	e8 e5 fe ff ff       	call   80125c <syscall>
  801377:	83 c4 18             	add    $0x18,%esp
}
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    

0080137c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	6a 0c                	push   $0xc
  80138b:	e8 cc fe ff ff       	call   80125c <syscall>
  801390:	83 c4 18             	add    $0x18,%esp
}
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 0d                	push   $0xd
  8013a4:	e8 b3 fe ff ff       	call   80125c <syscall>
  8013a9:	83 c4 18             	add    $0x18,%esp
}
  8013ac:	c9                   	leave  
  8013ad:	c3                   	ret    

008013ae <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 0e                	push   $0xe
  8013bd:	e8 9a fe ff ff       	call   80125c <syscall>
  8013c2:	83 c4 18             	add    $0x18,%esp
}
  8013c5:	c9                   	leave  
  8013c6:	c3                   	ret    

008013c7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 00                	push   $0x0
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 0f                	push   $0xf
  8013d6:	e8 81 fe ff ff       	call   80125c <syscall>
  8013db:	83 c4 18             	add    $0x18,%esp
}
  8013de:	c9                   	leave  
  8013df:	c3                   	ret    

008013e0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	ff 75 08             	pushl  0x8(%ebp)
  8013ee:	6a 10                	push   $0x10
  8013f0:	e8 67 fe ff ff       	call   80125c <syscall>
  8013f5:	83 c4 18             	add    $0x18,%esp
}
  8013f8:	c9                   	leave  
  8013f9:	c3                   	ret    

008013fa <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	6a 00                	push   $0x0
  801403:	6a 00                	push   $0x0
  801405:	6a 00                	push   $0x0
  801407:	6a 11                	push   $0x11
  801409:	e8 4e fe ff ff       	call   80125c <syscall>
  80140e:	83 c4 18             	add    $0x18,%esp
}
  801411:	90                   	nop
  801412:	c9                   	leave  
  801413:	c3                   	ret    

00801414 <sys_cputc>:

void
sys_cputc(const char c)
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
  801417:	83 ec 04             	sub    $0x4,%esp
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801420:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	50                   	push   %eax
  80142d:	6a 01                	push   $0x1
  80142f:	e8 28 fe ff ff       	call   80125c <syscall>
  801434:	83 c4 18             	add    $0x18,%esp
}
  801437:	90                   	nop
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 14                	push   $0x14
  801449:	e8 0e fe ff ff       	call   80125c <syscall>
  80144e:	83 c4 18             	add    $0x18,%esp
}
  801451:	90                   	nop
  801452:	c9                   	leave  
  801453:	c3                   	ret    

00801454 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
  801457:	83 ec 04             	sub    $0x4,%esp
  80145a:	8b 45 10             	mov    0x10(%ebp),%eax
  80145d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801460:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801463:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	6a 00                	push   $0x0
  80146c:	51                   	push   %ecx
  80146d:	52                   	push   %edx
  80146e:	ff 75 0c             	pushl  0xc(%ebp)
  801471:	50                   	push   %eax
  801472:	6a 15                	push   $0x15
  801474:	e8 e3 fd ff ff       	call   80125c <syscall>
  801479:	83 c4 18             	add    $0x18,%esp
}
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801481:	8b 55 0c             	mov    0xc(%ebp),%edx
  801484:	8b 45 08             	mov    0x8(%ebp),%eax
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	52                   	push   %edx
  80148e:	50                   	push   %eax
  80148f:	6a 16                	push   $0x16
  801491:	e8 c6 fd ff ff       	call   80125c <syscall>
  801496:	83 c4 18             	add    $0x18,%esp
}
  801499:	c9                   	leave  
  80149a:	c3                   	ret    

0080149b <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80149e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	51                   	push   %ecx
  8014ac:	52                   	push   %edx
  8014ad:	50                   	push   %eax
  8014ae:	6a 17                	push   $0x17
  8014b0:	e8 a7 fd ff ff       	call   80125c <syscall>
  8014b5:	83 c4 18             	add    $0x18,%esp
}
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8014bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 00                	push   $0x0
  8014c9:	52                   	push   %edx
  8014ca:	50                   	push   %eax
  8014cb:	6a 18                	push   $0x18
  8014cd:	e8 8a fd ff ff       	call   80125c <syscall>
  8014d2:	83 c4 18             	add    $0x18,%esp
}
  8014d5:	c9                   	leave  
  8014d6:	c3                   	ret    

008014d7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	6a 00                	push   $0x0
  8014df:	ff 75 14             	pushl  0x14(%ebp)
  8014e2:	ff 75 10             	pushl  0x10(%ebp)
  8014e5:	ff 75 0c             	pushl  0xc(%ebp)
  8014e8:	50                   	push   %eax
  8014e9:	6a 19                	push   $0x19
  8014eb:	e8 6c fd ff ff       	call   80125c <syscall>
  8014f0:	83 c4 18             	add    $0x18,%esp
}
  8014f3:	c9                   	leave  
  8014f4:	c3                   	ret    

008014f5 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	50                   	push   %eax
  801504:	6a 1a                	push   $0x1a
  801506:	e8 51 fd ff ff       	call   80125c <syscall>
  80150b:	83 c4 18             	add    $0x18,%esp
}
  80150e:	90                   	nop
  80150f:	c9                   	leave  
  801510:	c3                   	ret    

00801511 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	6a 00                	push   $0x0
  80151f:	50                   	push   %eax
  801520:	6a 1b                	push   $0x1b
  801522:	e8 35 fd ff ff       	call   80125c <syscall>
  801527:	83 c4 18             	add    $0x18,%esp
}
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 05                	push   $0x5
  80153b:	e8 1c fd ff ff       	call   80125c <syscall>
  801540:	83 c4 18             	add    $0x18,%esp
}
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 06                	push   $0x6
  801554:	e8 03 fd ff ff       	call   80125c <syscall>
  801559:	83 c4 18             	add    $0x18,%esp
}
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    

0080155e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 07                	push   $0x7
  80156d:	e8 ea fc ff ff       	call   80125c <syscall>
  801572:	83 c4 18             	add    $0x18,%esp
}
  801575:	c9                   	leave  
  801576:	c3                   	ret    

00801577 <sys_exit_env>:


void sys_exit_env(void)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 1c                	push   $0x1c
  801586:	e8 d1 fc ff ff       	call   80125c <syscall>
  80158b:	83 c4 18             	add    $0x18,%esp
}
  80158e:	90                   	nop
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
  801594:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801597:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80159a:	8d 50 04             	lea    0x4(%eax),%edx
  80159d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	52                   	push   %edx
  8015a7:	50                   	push   %eax
  8015a8:	6a 1d                	push   $0x1d
  8015aa:	e8 ad fc ff ff       	call   80125c <syscall>
  8015af:	83 c4 18             	add    $0x18,%esp
	return result;
  8015b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015bb:	89 01                	mov    %eax,(%ecx)
  8015bd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c3:	c9                   	leave  
  8015c4:	c2 04 00             	ret    $0x4

008015c7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	ff 75 10             	pushl  0x10(%ebp)
  8015d1:	ff 75 0c             	pushl  0xc(%ebp)
  8015d4:	ff 75 08             	pushl  0x8(%ebp)
  8015d7:	6a 13                	push   $0x13
  8015d9:	e8 7e fc ff ff       	call   80125c <syscall>
  8015de:	83 c4 18             	add    $0x18,%esp
	return ;
  8015e1:	90                   	nop
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 1e                	push   $0x1e
  8015f3:	e8 64 fc ff ff       	call   80125c <syscall>
  8015f8:	83 c4 18             	add    $0x18,%esp
}
  8015fb:	c9                   	leave  
  8015fc:	c3                   	ret    

008015fd <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
  801600:	83 ec 04             	sub    $0x4,%esp
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801609:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	50                   	push   %eax
  801616:	6a 1f                	push   $0x1f
  801618:	e8 3f fc ff ff       	call   80125c <syscall>
  80161d:	83 c4 18             	add    $0x18,%esp
	return ;
  801620:	90                   	nop
}
  801621:	c9                   	leave  
  801622:	c3                   	ret    

00801623 <rsttst>:
void rsttst()
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 21                	push   $0x21
  801632:	e8 25 fc ff ff       	call   80125c <syscall>
  801637:	83 c4 18             	add    $0x18,%esp
	return ;
  80163a:	90                   	nop
}
  80163b:	c9                   	leave  
  80163c:	c3                   	ret    

0080163d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	83 ec 04             	sub    $0x4,%esp
  801643:	8b 45 14             	mov    0x14(%ebp),%eax
  801646:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801649:	8b 55 18             	mov    0x18(%ebp),%edx
  80164c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801650:	52                   	push   %edx
  801651:	50                   	push   %eax
  801652:	ff 75 10             	pushl  0x10(%ebp)
  801655:	ff 75 0c             	pushl  0xc(%ebp)
  801658:	ff 75 08             	pushl  0x8(%ebp)
  80165b:	6a 20                	push   $0x20
  80165d:	e8 fa fb ff ff       	call   80125c <syscall>
  801662:	83 c4 18             	add    $0x18,%esp
	return ;
  801665:	90                   	nop
}
  801666:	c9                   	leave  
  801667:	c3                   	ret    

00801668 <chktst>:
void chktst(uint32 n)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	ff 75 08             	pushl  0x8(%ebp)
  801676:	6a 22                	push   $0x22
  801678:	e8 df fb ff ff       	call   80125c <syscall>
  80167d:	83 c4 18             	add    $0x18,%esp
	return ;
  801680:	90                   	nop
}
  801681:	c9                   	leave  
  801682:	c3                   	ret    

00801683 <inctst>:

void inctst()
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 23                	push   $0x23
  801692:	e8 c5 fb ff ff       	call   80125c <syscall>
  801697:	83 c4 18             	add    $0x18,%esp
	return ;
  80169a:	90                   	nop
}
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    

0080169d <gettst>:
uint32 gettst()
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 24                	push   $0x24
  8016ac:	e8 ab fb ff ff       	call   80125c <syscall>
  8016b1:	83 c4 18             	add    $0x18,%esp
}
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    

008016b6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 25                	push   $0x25
  8016c8:	e8 8f fb ff ff       	call   80125c <syscall>
  8016cd:	83 c4 18             	add    $0x18,%esp
  8016d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8016d3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8016d7:	75 07                	jne    8016e0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8016d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8016de:	eb 05                	jmp    8016e5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8016e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e5:	c9                   	leave  
  8016e6:	c3                   	ret    

008016e7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 25                	push   $0x25
  8016f9:	e8 5e fb ff ff       	call   80125c <syscall>
  8016fe:	83 c4 18             	add    $0x18,%esp
  801701:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801704:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801708:	75 07                	jne    801711 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80170a:	b8 01 00 00 00       	mov    $0x1,%eax
  80170f:	eb 05                	jmp    801716 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801711:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
  80171b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 25                	push   $0x25
  80172a:	e8 2d fb ff ff       	call   80125c <syscall>
  80172f:	83 c4 18             	add    $0x18,%esp
  801732:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801735:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801739:	75 07                	jne    801742 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80173b:	b8 01 00 00 00       	mov    $0x1,%eax
  801740:	eb 05                	jmp    801747 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801742:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801747:	c9                   	leave  
  801748:	c3                   	ret    

00801749 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
  80174c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 25                	push   $0x25
  80175b:	e8 fc fa ff ff       	call   80125c <syscall>
  801760:	83 c4 18             	add    $0x18,%esp
  801763:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801766:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80176a:	75 07                	jne    801773 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80176c:	b8 01 00 00 00       	mov    $0x1,%eax
  801771:	eb 05                	jmp    801778 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801773:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	ff 75 08             	pushl  0x8(%ebp)
  801788:	6a 26                	push   $0x26
  80178a:	e8 cd fa ff ff       	call   80125c <syscall>
  80178f:	83 c4 18             	add    $0x18,%esp
	return ;
  801792:	90                   	nop
}
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801799:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80179c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80179f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a5:	6a 00                	push   $0x0
  8017a7:	53                   	push   %ebx
  8017a8:	51                   	push   %ecx
  8017a9:	52                   	push   %edx
  8017aa:	50                   	push   %eax
  8017ab:	6a 27                	push   $0x27
  8017ad:	e8 aa fa ff ff       	call   80125c <syscall>
  8017b2:	83 c4 18             	add    $0x18,%esp
}
  8017b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8017bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	52                   	push   %edx
  8017ca:	50                   	push   %eax
  8017cb:	6a 28                	push   $0x28
  8017cd:	e8 8a fa ff ff       	call   80125c <syscall>
  8017d2:	83 c4 18             	add    $0x18,%esp
}
  8017d5:	c9                   	leave  
  8017d6:	c3                   	ret    

008017d7 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8017da:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	6a 00                	push   $0x0
  8017e5:	51                   	push   %ecx
  8017e6:	ff 75 10             	pushl  0x10(%ebp)
  8017e9:	52                   	push   %edx
  8017ea:	50                   	push   %eax
  8017eb:	6a 29                	push   $0x29
  8017ed:	e8 6a fa ff ff       	call   80125c <syscall>
  8017f2:	83 c4 18             	add    $0x18,%esp
}
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	ff 75 10             	pushl  0x10(%ebp)
  801801:	ff 75 0c             	pushl  0xc(%ebp)
  801804:	ff 75 08             	pushl  0x8(%ebp)
  801807:	6a 12                	push   $0x12
  801809:	e8 4e fa ff ff       	call   80125c <syscall>
  80180e:	83 c4 18             	add    $0x18,%esp
	return ;
  801811:	90                   	nop
}
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801817:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181a:	8b 45 08             	mov    0x8(%ebp),%eax
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	52                   	push   %edx
  801824:	50                   	push   %eax
  801825:	6a 2a                	push   $0x2a
  801827:	e8 30 fa ff ff       	call   80125c <syscall>
  80182c:	83 c4 18             	add    $0x18,%esp
	return;
  80182f:	90                   	nop
}
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	50                   	push   %eax
  801841:	6a 2b                	push   $0x2b
  801843:	e8 14 fa ff ff       	call   80125c <syscall>
  801848:	83 c4 18             	add    $0x18,%esp
}
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	ff 75 0c             	pushl  0xc(%ebp)
  801859:	ff 75 08             	pushl  0x8(%ebp)
  80185c:	6a 2c                	push   $0x2c
  80185e:	e8 f9 f9 ff ff       	call   80125c <syscall>
  801863:	83 c4 18             	add    $0x18,%esp
	return;
  801866:	90                   	nop
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	ff 75 0c             	pushl  0xc(%ebp)
  801875:	ff 75 08             	pushl  0x8(%ebp)
  801878:	6a 2d                	push   $0x2d
  80187a:	e8 dd f9 ff ff       	call   80125c <syscall>
  80187f:	83 c4 18             	add    $0x18,%esp
	return;
  801882:	90                   	nop
}
  801883:	c9                   	leave  
  801884:	c3                   	ret    
  801885:	66 90                	xchg   %ax,%ax
  801887:	90                   	nop

00801888 <__udivdi3>:
  801888:	55                   	push   %ebp
  801889:	57                   	push   %edi
  80188a:	56                   	push   %esi
  80188b:	53                   	push   %ebx
  80188c:	83 ec 1c             	sub    $0x1c,%esp
  80188f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801893:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801897:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80189b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80189f:	89 ca                	mov    %ecx,%edx
  8018a1:	89 f8                	mov    %edi,%eax
  8018a3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8018a7:	85 f6                	test   %esi,%esi
  8018a9:	75 2d                	jne    8018d8 <__udivdi3+0x50>
  8018ab:	39 cf                	cmp    %ecx,%edi
  8018ad:	77 65                	ja     801914 <__udivdi3+0x8c>
  8018af:	89 fd                	mov    %edi,%ebp
  8018b1:	85 ff                	test   %edi,%edi
  8018b3:	75 0b                	jne    8018c0 <__udivdi3+0x38>
  8018b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ba:	31 d2                	xor    %edx,%edx
  8018bc:	f7 f7                	div    %edi
  8018be:	89 c5                	mov    %eax,%ebp
  8018c0:	31 d2                	xor    %edx,%edx
  8018c2:	89 c8                	mov    %ecx,%eax
  8018c4:	f7 f5                	div    %ebp
  8018c6:	89 c1                	mov    %eax,%ecx
  8018c8:	89 d8                	mov    %ebx,%eax
  8018ca:	f7 f5                	div    %ebp
  8018cc:	89 cf                	mov    %ecx,%edi
  8018ce:	89 fa                	mov    %edi,%edx
  8018d0:	83 c4 1c             	add    $0x1c,%esp
  8018d3:	5b                   	pop    %ebx
  8018d4:	5e                   	pop    %esi
  8018d5:	5f                   	pop    %edi
  8018d6:	5d                   	pop    %ebp
  8018d7:	c3                   	ret    
  8018d8:	39 ce                	cmp    %ecx,%esi
  8018da:	77 28                	ja     801904 <__udivdi3+0x7c>
  8018dc:	0f bd fe             	bsr    %esi,%edi
  8018df:	83 f7 1f             	xor    $0x1f,%edi
  8018e2:	75 40                	jne    801924 <__udivdi3+0x9c>
  8018e4:	39 ce                	cmp    %ecx,%esi
  8018e6:	72 0a                	jb     8018f2 <__udivdi3+0x6a>
  8018e8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8018ec:	0f 87 9e 00 00 00    	ja     801990 <__udivdi3+0x108>
  8018f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8018f7:	89 fa                	mov    %edi,%edx
  8018f9:	83 c4 1c             	add    $0x1c,%esp
  8018fc:	5b                   	pop    %ebx
  8018fd:	5e                   	pop    %esi
  8018fe:	5f                   	pop    %edi
  8018ff:	5d                   	pop    %ebp
  801900:	c3                   	ret    
  801901:	8d 76 00             	lea    0x0(%esi),%esi
  801904:	31 ff                	xor    %edi,%edi
  801906:	31 c0                	xor    %eax,%eax
  801908:	89 fa                	mov    %edi,%edx
  80190a:	83 c4 1c             	add    $0x1c,%esp
  80190d:	5b                   	pop    %ebx
  80190e:	5e                   	pop    %esi
  80190f:	5f                   	pop    %edi
  801910:	5d                   	pop    %ebp
  801911:	c3                   	ret    
  801912:	66 90                	xchg   %ax,%ax
  801914:	89 d8                	mov    %ebx,%eax
  801916:	f7 f7                	div    %edi
  801918:	31 ff                	xor    %edi,%edi
  80191a:	89 fa                	mov    %edi,%edx
  80191c:	83 c4 1c             	add    $0x1c,%esp
  80191f:	5b                   	pop    %ebx
  801920:	5e                   	pop    %esi
  801921:	5f                   	pop    %edi
  801922:	5d                   	pop    %ebp
  801923:	c3                   	ret    
  801924:	bd 20 00 00 00       	mov    $0x20,%ebp
  801929:	89 eb                	mov    %ebp,%ebx
  80192b:	29 fb                	sub    %edi,%ebx
  80192d:	89 f9                	mov    %edi,%ecx
  80192f:	d3 e6                	shl    %cl,%esi
  801931:	89 c5                	mov    %eax,%ebp
  801933:	88 d9                	mov    %bl,%cl
  801935:	d3 ed                	shr    %cl,%ebp
  801937:	89 e9                	mov    %ebp,%ecx
  801939:	09 f1                	or     %esi,%ecx
  80193b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80193f:	89 f9                	mov    %edi,%ecx
  801941:	d3 e0                	shl    %cl,%eax
  801943:	89 c5                	mov    %eax,%ebp
  801945:	89 d6                	mov    %edx,%esi
  801947:	88 d9                	mov    %bl,%cl
  801949:	d3 ee                	shr    %cl,%esi
  80194b:	89 f9                	mov    %edi,%ecx
  80194d:	d3 e2                	shl    %cl,%edx
  80194f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801953:	88 d9                	mov    %bl,%cl
  801955:	d3 e8                	shr    %cl,%eax
  801957:	09 c2                	or     %eax,%edx
  801959:	89 d0                	mov    %edx,%eax
  80195b:	89 f2                	mov    %esi,%edx
  80195d:	f7 74 24 0c          	divl   0xc(%esp)
  801961:	89 d6                	mov    %edx,%esi
  801963:	89 c3                	mov    %eax,%ebx
  801965:	f7 e5                	mul    %ebp
  801967:	39 d6                	cmp    %edx,%esi
  801969:	72 19                	jb     801984 <__udivdi3+0xfc>
  80196b:	74 0b                	je     801978 <__udivdi3+0xf0>
  80196d:	89 d8                	mov    %ebx,%eax
  80196f:	31 ff                	xor    %edi,%edi
  801971:	e9 58 ff ff ff       	jmp    8018ce <__udivdi3+0x46>
  801976:	66 90                	xchg   %ax,%ax
  801978:	8b 54 24 08          	mov    0x8(%esp),%edx
  80197c:	89 f9                	mov    %edi,%ecx
  80197e:	d3 e2                	shl    %cl,%edx
  801980:	39 c2                	cmp    %eax,%edx
  801982:	73 e9                	jae    80196d <__udivdi3+0xe5>
  801984:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801987:	31 ff                	xor    %edi,%edi
  801989:	e9 40 ff ff ff       	jmp    8018ce <__udivdi3+0x46>
  80198e:	66 90                	xchg   %ax,%ax
  801990:	31 c0                	xor    %eax,%eax
  801992:	e9 37 ff ff ff       	jmp    8018ce <__udivdi3+0x46>
  801997:	90                   	nop

00801998 <__umoddi3>:
  801998:	55                   	push   %ebp
  801999:	57                   	push   %edi
  80199a:	56                   	push   %esi
  80199b:	53                   	push   %ebx
  80199c:	83 ec 1c             	sub    $0x1c,%esp
  80199f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8019a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8019a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8019af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019b7:	89 f3                	mov    %esi,%ebx
  8019b9:	89 fa                	mov    %edi,%edx
  8019bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019bf:	89 34 24             	mov    %esi,(%esp)
  8019c2:	85 c0                	test   %eax,%eax
  8019c4:	75 1a                	jne    8019e0 <__umoddi3+0x48>
  8019c6:	39 f7                	cmp    %esi,%edi
  8019c8:	0f 86 a2 00 00 00    	jbe    801a70 <__umoddi3+0xd8>
  8019ce:	89 c8                	mov    %ecx,%eax
  8019d0:	89 f2                	mov    %esi,%edx
  8019d2:	f7 f7                	div    %edi
  8019d4:	89 d0                	mov    %edx,%eax
  8019d6:	31 d2                	xor    %edx,%edx
  8019d8:	83 c4 1c             	add    $0x1c,%esp
  8019db:	5b                   	pop    %ebx
  8019dc:	5e                   	pop    %esi
  8019dd:	5f                   	pop    %edi
  8019de:	5d                   	pop    %ebp
  8019df:	c3                   	ret    
  8019e0:	39 f0                	cmp    %esi,%eax
  8019e2:	0f 87 ac 00 00 00    	ja     801a94 <__umoddi3+0xfc>
  8019e8:	0f bd e8             	bsr    %eax,%ebp
  8019eb:	83 f5 1f             	xor    $0x1f,%ebp
  8019ee:	0f 84 ac 00 00 00    	je     801aa0 <__umoddi3+0x108>
  8019f4:	bf 20 00 00 00       	mov    $0x20,%edi
  8019f9:	29 ef                	sub    %ebp,%edi
  8019fb:	89 fe                	mov    %edi,%esi
  8019fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a01:	89 e9                	mov    %ebp,%ecx
  801a03:	d3 e0                	shl    %cl,%eax
  801a05:	89 d7                	mov    %edx,%edi
  801a07:	89 f1                	mov    %esi,%ecx
  801a09:	d3 ef                	shr    %cl,%edi
  801a0b:	09 c7                	or     %eax,%edi
  801a0d:	89 e9                	mov    %ebp,%ecx
  801a0f:	d3 e2                	shl    %cl,%edx
  801a11:	89 14 24             	mov    %edx,(%esp)
  801a14:	89 d8                	mov    %ebx,%eax
  801a16:	d3 e0                	shl    %cl,%eax
  801a18:	89 c2                	mov    %eax,%edx
  801a1a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a1e:	d3 e0                	shl    %cl,%eax
  801a20:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a24:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a28:	89 f1                	mov    %esi,%ecx
  801a2a:	d3 e8                	shr    %cl,%eax
  801a2c:	09 d0                	or     %edx,%eax
  801a2e:	d3 eb                	shr    %cl,%ebx
  801a30:	89 da                	mov    %ebx,%edx
  801a32:	f7 f7                	div    %edi
  801a34:	89 d3                	mov    %edx,%ebx
  801a36:	f7 24 24             	mull   (%esp)
  801a39:	89 c6                	mov    %eax,%esi
  801a3b:	89 d1                	mov    %edx,%ecx
  801a3d:	39 d3                	cmp    %edx,%ebx
  801a3f:	0f 82 87 00 00 00    	jb     801acc <__umoddi3+0x134>
  801a45:	0f 84 91 00 00 00    	je     801adc <__umoddi3+0x144>
  801a4b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a4f:	29 f2                	sub    %esi,%edx
  801a51:	19 cb                	sbb    %ecx,%ebx
  801a53:	89 d8                	mov    %ebx,%eax
  801a55:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a59:	d3 e0                	shl    %cl,%eax
  801a5b:	89 e9                	mov    %ebp,%ecx
  801a5d:	d3 ea                	shr    %cl,%edx
  801a5f:	09 d0                	or     %edx,%eax
  801a61:	89 e9                	mov    %ebp,%ecx
  801a63:	d3 eb                	shr    %cl,%ebx
  801a65:	89 da                	mov    %ebx,%edx
  801a67:	83 c4 1c             	add    $0x1c,%esp
  801a6a:	5b                   	pop    %ebx
  801a6b:	5e                   	pop    %esi
  801a6c:	5f                   	pop    %edi
  801a6d:	5d                   	pop    %ebp
  801a6e:	c3                   	ret    
  801a6f:	90                   	nop
  801a70:	89 fd                	mov    %edi,%ebp
  801a72:	85 ff                	test   %edi,%edi
  801a74:	75 0b                	jne    801a81 <__umoddi3+0xe9>
  801a76:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7b:	31 d2                	xor    %edx,%edx
  801a7d:	f7 f7                	div    %edi
  801a7f:	89 c5                	mov    %eax,%ebp
  801a81:	89 f0                	mov    %esi,%eax
  801a83:	31 d2                	xor    %edx,%edx
  801a85:	f7 f5                	div    %ebp
  801a87:	89 c8                	mov    %ecx,%eax
  801a89:	f7 f5                	div    %ebp
  801a8b:	89 d0                	mov    %edx,%eax
  801a8d:	e9 44 ff ff ff       	jmp    8019d6 <__umoddi3+0x3e>
  801a92:	66 90                	xchg   %ax,%ax
  801a94:	89 c8                	mov    %ecx,%eax
  801a96:	89 f2                	mov    %esi,%edx
  801a98:	83 c4 1c             	add    $0x1c,%esp
  801a9b:	5b                   	pop    %ebx
  801a9c:	5e                   	pop    %esi
  801a9d:	5f                   	pop    %edi
  801a9e:	5d                   	pop    %ebp
  801a9f:	c3                   	ret    
  801aa0:	3b 04 24             	cmp    (%esp),%eax
  801aa3:	72 06                	jb     801aab <__umoddi3+0x113>
  801aa5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801aa9:	77 0f                	ja     801aba <__umoddi3+0x122>
  801aab:	89 f2                	mov    %esi,%edx
  801aad:	29 f9                	sub    %edi,%ecx
  801aaf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ab3:	89 14 24             	mov    %edx,(%esp)
  801ab6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801aba:	8b 44 24 04          	mov    0x4(%esp),%eax
  801abe:	8b 14 24             	mov    (%esp),%edx
  801ac1:	83 c4 1c             	add    $0x1c,%esp
  801ac4:	5b                   	pop    %ebx
  801ac5:	5e                   	pop    %esi
  801ac6:	5f                   	pop    %edi
  801ac7:	5d                   	pop    %ebp
  801ac8:	c3                   	ret    
  801ac9:	8d 76 00             	lea    0x0(%esi),%esi
  801acc:	2b 04 24             	sub    (%esp),%eax
  801acf:	19 fa                	sbb    %edi,%edx
  801ad1:	89 d1                	mov    %edx,%ecx
  801ad3:	89 c6                	mov    %eax,%esi
  801ad5:	e9 71 ff ff ff       	jmp    801a4b <__umoddi3+0xb3>
  801ada:	66 90                	xchg   %ax,%ax
  801adc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ae0:	72 ea                	jb     801acc <__umoddi3+0x134>
  801ae2:	89 d9                	mov    %ebx,%ecx
  801ae4:	e9 62 ff ff ff       	jmp    801a4b <__umoddi3+0xb3>
