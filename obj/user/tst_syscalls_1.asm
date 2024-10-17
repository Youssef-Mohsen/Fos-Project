
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
  80003e:	e8 ee 15 00 00       	call   801631 <rsttst>
	void * ret = sys_sbrk(10);
  800043:	83 ec 0c             	sub    $0xc,%esp
  800046:	6a 0a                	push   $0xa
  800048:	e8 f3 17 00 00       	call   801840 <sys_sbrk>
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
  800068:	e8 a6 01 00 00       	call   800213 <_panic>
	sys_allocate_user_mem(USER_HEAP_START,10);
  80006d:	83 ec 08             	sub    $0x8,%esp
  800070:	6a 0a                	push   $0xa
  800072:	68 00 00 00 80       	push   $0x80000000
  800077:	e8 fe 17 00 00       	call   80187a <sys_allocate_user_mem>
  80007c:	83 c4 10             	add    $0x10,%esp
	sys_free_user_mem(USER_HEAP_START + PAGE_SIZE, 10);
  80007f:	83 ec 08             	sub    $0x8,%esp
  800082:	6a 0a                	push   $0xa
  800084:	68 00 10 00 80       	push   $0x80001000
  800089:	e8 cf 17 00 00       	call   80185d <sys_free_user_mem>
  80008e:	83 c4 10             	add    $0x10,%esp
	int ret2 = gettst();
  800091:	e8 15 16 00 00       	call   8016ab <gettst>
  800096:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret2 != 2)
  800099:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  80009d:	74 14                	je     8000b3 <_main+0x7b>
		panic("tst system calls #1 failed: sys_allocate_user_mem and/or sys_free_user_mem are not handled correctly");
  80009f:	83 ec 04             	sub    $0x4,%esp
  8000a2:	68 54 1b 80 00       	push   $0x801b54
  8000a7:	6a 0f                	push   $0xf
  8000a9:	68 3e 1b 80 00       	push   $0x801b3e
  8000ae:	e8 60 01 00 00       	call   800213 <_panic>
	cprintf("Congratulations... tst system calls #1 completed successfully");
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	68 bc 1b 80 00       	push   $0x801bbc
  8000bb:	e8 10 04 00 00       	call   8004d0 <cprintf>
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
  8000cc:	e8 82 14 00 00       	call   801553 <sys_getenvindex>
  8000d1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000d7:	89 d0                	mov    %edx,%eax
  8000d9:	c1 e0 06             	shl    $0x6,%eax
  8000dc:	29 d0                	sub    %edx,%eax
  8000de:	c1 e0 02             	shl    $0x2,%eax
  8000e1:	01 d0                	add    %edx,%eax
  8000e3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000ea:	01 c8                	add    %ecx,%eax
  8000ec:	c1 e0 03             	shl    $0x3,%eax
  8000ef:	01 d0                	add    %edx,%eax
  8000f1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000f8:	29 c2                	sub    %eax,%edx
  8000fa:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800101:	89 c2                	mov    %eax,%edx
  800103:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800109:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80010e:	a1 04 30 80 00       	mov    0x803004,%eax
  800113:	8a 40 20             	mov    0x20(%eax),%al
  800116:	84 c0                	test   %al,%al
  800118:	74 0d                	je     800127 <libmain+0x61>
		binaryname = myEnv->prog_name;
  80011a:	a1 04 30 80 00       	mov    0x803004,%eax
  80011f:	83 c0 20             	add    $0x20,%eax
  800122:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800127:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80012b:	7e 0a                	jle    800137 <libmain+0x71>
		binaryname = argv[0];
  80012d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800130:	8b 00                	mov    (%eax),%eax
  800132:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800137:	83 ec 08             	sub    $0x8,%esp
  80013a:	ff 75 0c             	pushl  0xc(%ebp)
  80013d:	ff 75 08             	pushl  0x8(%ebp)
  800140:	e8 f3 fe ff ff       	call   800038 <_main>
  800145:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800148:	e8 8a 11 00 00       	call   8012d7 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80014d:	83 ec 0c             	sub    $0xc,%esp
  800150:	68 14 1c 80 00       	push   $0x801c14
  800155:	e8 76 03 00 00       	call   8004d0 <cprintf>
  80015a:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80015d:	a1 04 30 80 00       	mov    0x803004,%eax
  800162:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800168:	a1 04 30 80 00       	mov    0x803004,%eax
  80016d:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800173:	83 ec 04             	sub    $0x4,%esp
  800176:	52                   	push   %edx
  800177:	50                   	push   %eax
  800178:	68 3c 1c 80 00       	push   $0x801c3c
  80017d:	e8 4e 03 00 00       	call   8004d0 <cprintf>
  800182:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800185:	a1 04 30 80 00       	mov    0x803004,%eax
  80018a:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800190:	a1 04 30 80 00       	mov    0x803004,%eax
  800195:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80019b:	a1 04 30 80 00       	mov    0x803004,%eax
  8001a0:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8001a6:	51                   	push   %ecx
  8001a7:	52                   	push   %edx
  8001a8:	50                   	push   %eax
  8001a9:	68 64 1c 80 00       	push   $0x801c64
  8001ae:	e8 1d 03 00 00       	call   8004d0 <cprintf>
  8001b3:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001b6:	a1 04 30 80 00       	mov    0x803004,%eax
  8001bb:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8001c1:	83 ec 08             	sub    $0x8,%esp
  8001c4:	50                   	push   %eax
  8001c5:	68 bc 1c 80 00       	push   $0x801cbc
  8001ca:	e8 01 03 00 00       	call   8004d0 <cprintf>
  8001cf:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	68 14 1c 80 00       	push   $0x801c14
  8001da:	e8 f1 02 00 00       	call   8004d0 <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8001e2:	e8 0a 11 00 00       	call   8012f1 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8001e7:	e8 19 00 00 00       	call   800205 <exit>
}
  8001ec:	90                   	nop
  8001ed:	c9                   	leave  
  8001ee:	c3                   	ret    

008001ef <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001ef:	55                   	push   %ebp
  8001f0:	89 e5                	mov    %esp,%ebp
  8001f2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	6a 00                	push   $0x0
  8001fa:	e8 20 13 00 00       	call   80151f <sys_destroy_env>
  8001ff:	83 c4 10             	add    $0x10,%esp
}
  800202:	90                   	nop
  800203:	c9                   	leave  
  800204:	c3                   	ret    

00800205 <exit>:

void
exit(void)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80020b:	e8 75 13 00 00       	call   801585 <sys_exit_env>
}
  800210:	90                   	nop
  800211:	c9                   	leave  
  800212:	c3                   	ret    

00800213 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800213:	55                   	push   %ebp
  800214:	89 e5                	mov    %esp,%ebp
  800216:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800219:	8d 45 10             	lea    0x10(%ebp),%eax
  80021c:	83 c0 04             	add    $0x4,%eax
  80021f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800222:	a1 24 30 80 00       	mov    0x803024,%eax
  800227:	85 c0                	test   %eax,%eax
  800229:	74 16                	je     800241 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80022b:	a1 24 30 80 00       	mov    0x803024,%eax
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	50                   	push   %eax
  800234:	68 d0 1c 80 00       	push   $0x801cd0
  800239:	e8 92 02 00 00       	call   8004d0 <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800241:	a1 00 30 80 00       	mov    0x803000,%eax
  800246:	ff 75 0c             	pushl  0xc(%ebp)
  800249:	ff 75 08             	pushl  0x8(%ebp)
  80024c:	50                   	push   %eax
  80024d:	68 d5 1c 80 00       	push   $0x801cd5
  800252:	e8 79 02 00 00       	call   8004d0 <cprintf>
  800257:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80025a:	8b 45 10             	mov    0x10(%ebp),%eax
  80025d:	83 ec 08             	sub    $0x8,%esp
  800260:	ff 75 f4             	pushl  -0xc(%ebp)
  800263:	50                   	push   %eax
  800264:	e8 fc 01 00 00       	call   800465 <vcprintf>
  800269:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80026c:	83 ec 08             	sub    $0x8,%esp
  80026f:	6a 00                	push   $0x0
  800271:	68 f1 1c 80 00       	push   $0x801cf1
  800276:	e8 ea 01 00 00       	call   800465 <vcprintf>
  80027b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80027e:	e8 82 ff ff ff       	call   800205 <exit>

	// should not return here
	while (1) ;
  800283:	eb fe                	jmp    800283 <_panic+0x70>

00800285 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800285:	55                   	push   %ebp
  800286:	89 e5                	mov    %esp,%ebp
  800288:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80028b:	a1 04 30 80 00       	mov    0x803004,%eax
  800290:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800296:	8b 45 0c             	mov    0xc(%ebp),%eax
  800299:	39 c2                	cmp    %eax,%edx
  80029b:	74 14                	je     8002b1 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80029d:	83 ec 04             	sub    $0x4,%esp
  8002a0:	68 f4 1c 80 00       	push   $0x801cf4
  8002a5:	6a 26                	push   $0x26
  8002a7:	68 40 1d 80 00       	push   $0x801d40
  8002ac:	e8 62 ff ff ff       	call   800213 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002bf:	e9 c5 00 00 00       	jmp    800389 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8002c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d1:	01 d0                	add    %edx,%eax
  8002d3:	8b 00                	mov    (%eax),%eax
  8002d5:	85 c0                	test   %eax,%eax
  8002d7:	75 08                	jne    8002e1 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8002d9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8002dc:	e9 a5 00 00 00       	jmp    800386 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8002e1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002e8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002ef:	eb 69                	jmp    80035a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8002f1:	a1 04 30 80 00       	mov    0x803004,%eax
  8002f6:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8002fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002ff:	89 d0                	mov    %edx,%eax
  800301:	01 c0                	add    %eax,%eax
  800303:	01 d0                	add    %edx,%eax
  800305:	c1 e0 03             	shl    $0x3,%eax
  800308:	01 c8                	add    %ecx,%eax
  80030a:	8a 40 04             	mov    0x4(%eax),%al
  80030d:	84 c0                	test   %al,%al
  80030f:	75 46                	jne    800357 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800311:	a1 04 30 80 00       	mov    0x803004,%eax
  800316:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80031c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80031f:	89 d0                	mov    %edx,%eax
  800321:	01 c0                	add    %eax,%eax
  800323:	01 d0                	add    %edx,%eax
  800325:	c1 e0 03             	shl    $0x3,%eax
  800328:	01 c8                	add    %ecx,%eax
  80032a:	8b 00                	mov    (%eax),%eax
  80032c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80032f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800332:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800337:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800343:	8b 45 08             	mov    0x8(%ebp),%eax
  800346:	01 c8                	add    %ecx,%eax
  800348:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80034a:	39 c2                	cmp    %eax,%edx
  80034c:	75 09                	jne    800357 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80034e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800355:	eb 15                	jmp    80036c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800357:	ff 45 e8             	incl   -0x18(%ebp)
  80035a:	a1 04 30 80 00       	mov    0x803004,%eax
  80035f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800368:	39 c2                	cmp    %eax,%edx
  80036a:	77 85                	ja     8002f1 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80036c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800370:	75 14                	jne    800386 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800372:	83 ec 04             	sub    $0x4,%esp
  800375:	68 4c 1d 80 00       	push   $0x801d4c
  80037a:	6a 3a                	push   $0x3a
  80037c:	68 40 1d 80 00       	push   $0x801d40
  800381:	e8 8d fe ff ff       	call   800213 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800386:	ff 45 f0             	incl   -0x10(%ebp)
  800389:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80038c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80038f:	0f 8c 2f ff ff ff    	jl     8002c4 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800395:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80039c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003a3:	eb 26                	jmp    8003cb <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003a5:	a1 04 30 80 00       	mov    0x803004,%eax
  8003aa:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8003b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003b3:	89 d0                	mov    %edx,%eax
  8003b5:	01 c0                	add    %eax,%eax
  8003b7:	01 d0                	add    %edx,%eax
  8003b9:	c1 e0 03             	shl    $0x3,%eax
  8003bc:	01 c8                	add    %ecx,%eax
  8003be:	8a 40 04             	mov    0x4(%eax),%al
  8003c1:	3c 01                	cmp    $0x1,%al
  8003c3:	75 03                	jne    8003c8 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8003c5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c8:	ff 45 e0             	incl   -0x20(%ebp)
  8003cb:	a1 04 30 80 00       	mov    0x803004,%eax
  8003d0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d9:	39 c2                	cmp    %eax,%edx
  8003db:	77 c8                	ja     8003a5 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8003dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003e0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003e3:	74 14                	je     8003f9 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8003e5:	83 ec 04             	sub    $0x4,%esp
  8003e8:	68 a0 1d 80 00       	push   $0x801da0
  8003ed:	6a 44                	push   $0x44
  8003ef:	68 40 1d 80 00       	push   $0x801d40
  8003f4:	e8 1a fe ff ff       	call   800213 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8003f9:	90                   	nop
  8003fa:	c9                   	leave  
  8003fb:	c3                   	ret    

008003fc <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8003fc:	55                   	push   %ebp
  8003fd:	89 e5                	mov    %esp,%ebp
  8003ff:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800402:	8b 45 0c             	mov    0xc(%ebp),%eax
  800405:	8b 00                	mov    (%eax),%eax
  800407:	8d 48 01             	lea    0x1(%eax),%ecx
  80040a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80040d:	89 0a                	mov    %ecx,(%edx)
  80040f:	8b 55 08             	mov    0x8(%ebp),%edx
  800412:	88 d1                	mov    %dl,%cl
  800414:	8b 55 0c             	mov    0xc(%ebp),%edx
  800417:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80041b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041e:	8b 00                	mov    (%eax),%eax
  800420:	3d ff 00 00 00       	cmp    $0xff,%eax
  800425:	75 2c                	jne    800453 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800427:	a0 08 30 80 00       	mov    0x803008,%al
  80042c:	0f b6 c0             	movzbl %al,%eax
  80042f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800432:	8b 12                	mov    (%edx),%edx
  800434:	89 d1                	mov    %edx,%ecx
  800436:	8b 55 0c             	mov    0xc(%ebp),%edx
  800439:	83 c2 08             	add    $0x8,%edx
  80043c:	83 ec 04             	sub    $0x4,%esp
  80043f:	50                   	push   %eax
  800440:	51                   	push   %ecx
  800441:	52                   	push   %edx
  800442:	e8 4e 0e 00 00       	call   801295 <sys_cputs>
  800447:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80044a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800453:	8b 45 0c             	mov    0xc(%ebp),%eax
  800456:	8b 40 04             	mov    0x4(%eax),%eax
  800459:	8d 50 01             	lea    0x1(%eax),%edx
  80045c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800462:	90                   	nop
  800463:	c9                   	leave  
  800464:	c3                   	ret    

00800465 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800465:	55                   	push   %ebp
  800466:	89 e5                	mov    %esp,%ebp
  800468:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80046e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800475:	00 00 00 
	b.cnt = 0;
  800478:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80047f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800482:	ff 75 0c             	pushl  0xc(%ebp)
  800485:	ff 75 08             	pushl  0x8(%ebp)
  800488:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80048e:	50                   	push   %eax
  80048f:	68 fc 03 80 00       	push   $0x8003fc
  800494:	e8 11 02 00 00       	call   8006aa <vprintfmt>
  800499:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80049c:	a0 08 30 80 00       	mov    0x803008,%al
  8004a1:	0f b6 c0             	movzbl %al,%eax
  8004a4:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	50                   	push   %eax
  8004ae:	52                   	push   %edx
  8004af:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004b5:	83 c0 08             	add    $0x8,%eax
  8004b8:	50                   	push   %eax
  8004b9:	e8 d7 0d 00 00       	call   801295 <sys_cputs>
  8004be:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004c1:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8004c8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004ce:	c9                   	leave  
  8004cf:	c3                   	ret    

008004d0 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8004d0:	55                   	push   %ebp
  8004d1:	89 e5                	mov    %esp,%ebp
  8004d3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8004d6:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8004dd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e6:	83 ec 08             	sub    $0x8,%esp
  8004e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ec:	50                   	push   %eax
  8004ed:	e8 73 ff ff ff       	call   800465 <vcprintf>
  8004f2:	83 c4 10             	add    $0x10,%esp
  8004f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8004f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004fb:	c9                   	leave  
  8004fc:	c3                   	ret    

008004fd <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8004fd:	55                   	push   %ebp
  8004fe:	89 e5                	mov    %esp,%ebp
  800500:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800503:	e8 cf 0d 00 00       	call   8012d7 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800508:	8d 45 0c             	lea    0xc(%ebp),%eax
  80050b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80050e:	8b 45 08             	mov    0x8(%ebp),%eax
  800511:	83 ec 08             	sub    $0x8,%esp
  800514:	ff 75 f4             	pushl  -0xc(%ebp)
  800517:	50                   	push   %eax
  800518:	e8 48 ff ff ff       	call   800465 <vcprintf>
  80051d:	83 c4 10             	add    $0x10,%esp
  800520:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800523:	e8 c9 0d 00 00       	call   8012f1 <sys_unlock_cons>
	return cnt;
  800528:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	53                   	push   %ebx
  800531:	83 ec 14             	sub    $0x14,%esp
  800534:	8b 45 10             	mov    0x10(%ebp),%eax
  800537:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80053a:	8b 45 14             	mov    0x14(%ebp),%eax
  80053d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800540:	8b 45 18             	mov    0x18(%ebp),%eax
  800543:	ba 00 00 00 00       	mov    $0x0,%edx
  800548:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80054b:	77 55                	ja     8005a2 <printnum+0x75>
  80054d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800550:	72 05                	jb     800557 <printnum+0x2a>
  800552:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800555:	77 4b                	ja     8005a2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800557:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80055a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80055d:	8b 45 18             	mov    0x18(%ebp),%eax
  800560:	ba 00 00 00 00       	mov    $0x0,%edx
  800565:	52                   	push   %edx
  800566:	50                   	push   %eax
  800567:	ff 75 f4             	pushl  -0xc(%ebp)
  80056a:	ff 75 f0             	pushl  -0x10(%ebp)
  80056d:	e8 26 13 00 00       	call   801898 <__udivdi3>
  800572:	83 c4 10             	add    $0x10,%esp
  800575:	83 ec 04             	sub    $0x4,%esp
  800578:	ff 75 20             	pushl  0x20(%ebp)
  80057b:	53                   	push   %ebx
  80057c:	ff 75 18             	pushl  0x18(%ebp)
  80057f:	52                   	push   %edx
  800580:	50                   	push   %eax
  800581:	ff 75 0c             	pushl  0xc(%ebp)
  800584:	ff 75 08             	pushl  0x8(%ebp)
  800587:	e8 a1 ff ff ff       	call   80052d <printnum>
  80058c:	83 c4 20             	add    $0x20,%esp
  80058f:	eb 1a                	jmp    8005ab <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800591:	83 ec 08             	sub    $0x8,%esp
  800594:	ff 75 0c             	pushl  0xc(%ebp)
  800597:	ff 75 20             	pushl  0x20(%ebp)
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	ff d0                	call   *%eax
  80059f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005a2:	ff 4d 1c             	decl   0x1c(%ebp)
  8005a5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005a9:	7f e6                	jg     800591 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005ab:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005b9:	53                   	push   %ebx
  8005ba:	51                   	push   %ecx
  8005bb:	52                   	push   %edx
  8005bc:	50                   	push   %eax
  8005bd:	e8 e6 13 00 00       	call   8019a8 <__umoddi3>
  8005c2:	83 c4 10             	add    $0x10,%esp
  8005c5:	05 14 20 80 00       	add    $0x802014,%eax
  8005ca:	8a 00                	mov    (%eax),%al
  8005cc:	0f be c0             	movsbl %al,%eax
  8005cf:	83 ec 08             	sub    $0x8,%esp
  8005d2:	ff 75 0c             	pushl  0xc(%ebp)
  8005d5:	50                   	push   %eax
  8005d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d9:	ff d0                	call   *%eax
  8005db:	83 c4 10             	add    $0x10,%esp
}
  8005de:	90                   	nop
  8005df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005e2:	c9                   	leave  
  8005e3:	c3                   	ret    

008005e4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005e4:	55                   	push   %ebp
  8005e5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005e7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005eb:	7e 1c                	jle    800609 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8005ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f0:	8b 00                	mov    (%eax),%eax
  8005f2:	8d 50 08             	lea    0x8(%eax),%edx
  8005f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f8:	89 10                	mov    %edx,(%eax)
  8005fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	83 e8 08             	sub    $0x8,%eax
  800602:	8b 50 04             	mov    0x4(%eax),%edx
  800605:	8b 00                	mov    (%eax),%eax
  800607:	eb 40                	jmp    800649 <getuint+0x65>
	else if (lflag)
  800609:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80060d:	74 1e                	je     80062d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80060f:	8b 45 08             	mov    0x8(%ebp),%eax
  800612:	8b 00                	mov    (%eax),%eax
  800614:	8d 50 04             	lea    0x4(%eax),%edx
  800617:	8b 45 08             	mov    0x8(%ebp),%eax
  80061a:	89 10                	mov    %edx,(%eax)
  80061c:	8b 45 08             	mov    0x8(%ebp),%eax
  80061f:	8b 00                	mov    (%eax),%eax
  800621:	83 e8 04             	sub    $0x4,%eax
  800624:	8b 00                	mov    (%eax),%eax
  800626:	ba 00 00 00 00       	mov    $0x0,%edx
  80062b:	eb 1c                	jmp    800649 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80062d:	8b 45 08             	mov    0x8(%ebp),%eax
  800630:	8b 00                	mov    (%eax),%eax
  800632:	8d 50 04             	lea    0x4(%eax),%edx
  800635:	8b 45 08             	mov    0x8(%ebp),%eax
  800638:	89 10                	mov    %edx,(%eax)
  80063a:	8b 45 08             	mov    0x8(%ebp),%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	83 e8 04             	sub    $0x4,%eax
  800642:	8b 00                	mov    (%eax),%eax
  800644:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800649:	5d                   	pop    %ebp
  80064a:	c3                   	ret    

0080064b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80064b:	55                   	push   %ebp
  80064c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80064e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800652:	7e 1c                	jle    800670 <getint+0x25>
		return va_arg(*ap, long long);
  800654:	8b 45 08             	mov    0x8(%ebp),%eax
  800657:	8b 00                	mov    (%eax),%eax
  800659:	8d 50 08             	lea    0x8(%eax),%edx
  80065c:	8b 45 08             	mov    0x8(%ebp),%eax
  80065f:	89 10                	mov    %edx,(%eax)
  800661:	8b 45 08             	mov    0x8(%ebp),%eax
  800664:	8b 00                	mov    (%eax),%eax
  800666:	83 e8 08             	sub    $0x8,%eax
  800669:	8b 50 04             	mov    0x4(%eax),%edx
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	eb 38                	jmp    8006a8 <getint+0x5d>
	else if (lflag)
  800670:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800674:	74 1a                	je     800690 <getint+0x45>
		return va_arg(*ap, long);
  800676:	8b 45 08             	mov    0x8(%ebp),%eax
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	8d 50 04             	lea    0x4(%eax),%edx
  80067e:	8b 45 08             	mov    0x8(%ebp),%eax
  800681:	89 10                	mov    %edx,(%eax)
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	83 e8 04             	sub    $0x4,%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	99                   	cltd   
  80068e:	eb 18                	jmp    8006a8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	8d 50 04             	lea    0x4(%eax),%edx
  800698:	8b 45 08             	mov    0x8(%ebp),%eax
  80069b:	89 10                	mov    %edx,(%eax)
  80069d:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	83 e8 04             	sub    $0x4,%eax
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	99                   	cltd   
}
  8006a8:	5d                   	pop    %ebp
  8006a9:	c3                   	ret    

008006aa <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006aa:	55                   	push   %ebp
  8006ab:	89 e5                	mov    %esp,%ebp
  8006ad:	56                   	push   %esi
  8006ae:	53                   	push   %ebx
  8006af:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006b2:	eb 17                	jmp    8006cb <vprintfmt+0x21>
			if (ch == '\0')
  8006b4:	85 db                	test   %ebx,%ebx
  8006b6:	0f 84 c1 03 00 00    	je     800a7d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	ff 75 0c             	pushl  0xc(%ebp)
  8006c2:	53                   	push   %ebx
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	ff d0                	call   *%eax
  8006c8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ce:	8d 50 01             	lea    0x1(%eax),%edx
  8006d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8006d4:	8a 00                	mov    (%eax),%al
  8006d6:	0f b6 d8             	movzbl %al,%ebx
  8006d9:	83 fb 25             	cmp    $0x25,%ebx
  8006dc:	75 d6                	jne    8006b4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006de:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8006e2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8006e9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8006f7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800701:	8d 50 01             	lea    0x1(%eax),%edx
  800704:	89 55 10             	mov    %edx,0x10(%ebp)
  800707:	8a 00                	mov    (%eax),%al
  800709:	0f b6 d8             	movzbl %al,%ebx
  80070c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80070f:	83 f8 5b             	cmp    $0x5b,%eax
  800712:	0f 87 3d 03 00 00    	ja     800a55 <vprintfmt+0x3ab>
  800718:	8b 04 85 38 20 80 00 	mov    0x802038(,%eax,4),%eax
  80071f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800721:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800725:	eb d7                	jmp    8006fe <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800727:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80072b:	eb d1                	jmp    8006fe <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80072d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800734:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800737:	89 d0                	mov    %edx,%eax
  800739:	c1 e0 02             	shl    $0x2,%eax
  80073c:	01 d0                	add    %edx,%eax
  80073e:	01 c0                	add    %eax,%eax
  800740:	01 d8                	add    %ebx,%eax
  800742:	83 e8 30             	sub    $0x30,%eax
  800745:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800748:	8b 45 10             	mov    0x10(%ebp),%eax
  80074b:	8a 00                	mov    (%eax),%al
  80074d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800750:	83 fb 2f             	cmp    $0x2f,%ebx
  800753:	7e 3e                	jle    800793 <vprintfmt+0xe9>
  800755:	83 fb 39             	cmp    $0x39,%ebx
  800758:	7f 39                	jg     800793 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80075a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80075d:	eb d5                	jmp    800734 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	83 c0 04             	add    $0x4,%eax
  800765:	89 45 14             	mov    %eax,0x14(%ebp)
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	83 e8 04             	sub    $0x4,%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800773:	eb 1f                	jmp    800794 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800775:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800779:	79 83                	jns    8006fe <vprintfmt+0x54>
				width = 0;
  80077b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800782:	e9 77 ff ff ff       	jmp    8006fe <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800787:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80078e:	e9 6b ff ff ff       	jmp    8006fe <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800793:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800794:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800798:	0f 89 60 ff ff ff    	jns    8006fe <vprintfmt+0x54>
				width = precision, precision = -1;
  80079e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007a4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007ab:	e9 4e ff ff ff       	jmp    8006fe <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007b0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007b3:	e9 46 ff ff ff       	jmp    8006fe <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bb:	83 c0 04             	add    $0x4,%eax
  8007be:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c4:	83 e8 04             	sub    $0x4,%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	ff 75 0c             	pushl  0xc(%ebp)
  8007cf:	50                   	push   %eax
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	ff d0                	call   *%eax
  8007d5:	83 c4 10             	add    $0x10,%esp
			break;
  8007d8:	e9 9b 02 00 00       	jmp    800a78 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8007dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e0:	83 c0 04             	add    $0x4,%eax
  8007e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e9:	83 e8 04             	sub    $0x4,%eax
  8007ec:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8007ee:	85 db                	test   %ebx,%ebx
  8007f0:	79 02                	jns    8007f4 <vprintfmt+0x14a>
				err = -err;
  8007f2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007f4:	83 fb 64             	cmp    $0x64,%ebx
  8007f7:	7f 0b                	jg     800804 <vprintfmt+0x15a>
  8007f9:	8b 34 9d 80 1e 80 00 	mov    0x801e80(,%ebx,4),%esi
  800800:	85 f6                	test   %esi,%esi
  800802:	75 19                	jne    80081d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800804:	53                   	push   %ebx
  800805:	68 25 20 80 00       	push   $0x802025
  80080a:	ff 75 0c             	pushl  0xc(%ebp)
  80080d:	ff 75 08             	pushl  0x8(%ebp)
  800810:	e8 70 02 00 00       	call   800a85 <printfmt>
  800815:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800818:	e9 5b 02 00 00       	jmp    800a78 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80081d:	56                   	push   %esi
  80081e:	68 2e 20 80 00       	push   $0x80202e
  800823:	ff 75 0c             	pushl  0xc(%ebp)
  800826:	ff 75 08             	pushl  0x8(%ebp)
  800829:	e8 57 02 00 00       	call   800a85 <printfmt>
  80082e:	83 c4 10             	add    $0x10,%esp
			break;
  800831:	e9 42 02 00 00       	jmp    800a78 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800836:	8b 45 14             	mov    0x14(%ebp),%eax
  800839:	83 c0 04             	add    $0x4,%eax
  80083c:	89 45 14             	mov    %eax,0x14(%ebp)
  80083f:	8b 45 14             	mov    0x14(%ebp),%eax
  800842:	83 e8 04             	sub    $0x4,%eax
  800845:	8b 30                	mov    (%eax),%esi
  800847:	85 f6                	test   %esi,%esi
  800849:	75 05                	jne    800850 <vprintfmt+0x1a6>
				p = "(null)";
  80084b:	be 31 20 80 00       	mov    $0x802031,%esi
			if (width > 0 && padc != '-')
  800850:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800854:	7e 6d                	jle    8008c3 <vprintfmt+0x219>
  800856:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80085a:	74 67                	je     8008c3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80085c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	50                   	push   %eax
  800863:	56                   	push   %esi
  800864:	e8 1e 03 00 00       	call   800b87 <strnlen>
  800869:	83 c4 10             	add    $0x10,%esp
  80086c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80086f:	eb 16                	jmp    800887 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800871:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800875:	83 ec 08             	sub    $0x8,%esp
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	50                   	push   %eax
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	ff d0                	call   *%eax
  800881:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800884:	ff 4d e4             	decl   -0x1c(%ebp)
  800887:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80088b:	7f e4                	jg     800871 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80088d:	eb 34                	jmp    8008c3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80088f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800893:	74 1c                	je     8008b1 <vprintfmt+0x207>
  800895:	83 fb 1f             	cmp    $0x1f,%ebx
  800898:	7e 05                	jle    80089f <vprintfmt+0x1f5>
  80089a:	83 fb 7e             	cmp    $0x7e,%ebx
  80089d:	7e 12                	jle    8008b1 <vprintfmt+0x207>
					putch('?', putdat);
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	ff 75 0c             	pushl  0xc(%ebp)
  8008a5:	6a 3f                	push   $0x3f
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	ff d0                	call   *%eax
  8008ac:	83 c4 10             	add    $0x10,%esp
  8008af:	eb 0f                	jmp    8008c0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008b1:	83 ec 08             	sub    $0x8,%esp
  8008b4:	ff 75 0c             	pushl  0xc(%ebp)
  8008b7:	53                   	push   %ebx
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	ff d0                	call   *%eax
  8008bd:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008c0:	ff 4d e4             	decl   -0x1c(%ebp)
  8008c3:	89 f0                	mov    %esi,%eax
  8008c5:	8d 70 01             	lea    0x1(%eax),%esi
  8008c8:	8a 00                	mov    (%eax),%al
  8008ca:	0f be d8             	movsbl %al,%ebx
  8008cd:	85 db                	test   %ebx,%ebx
  8008cf:	74 24                	je     8008f5 <vprintfmt+0x24b>
  8008d1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008d5:	78 b8                	js     80088f <vprintfmt+0x1e5>
  8008d7:	ff 4d e0             	decl   -0x20(%ebp)
  8008da:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008de:	79 af                	jns    80088f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008e0:	eb 13                	jmp    8008f5 <vprintfmt+0x24b>
				putch(' ', putdat);
  8008e2:	83 ec 08             	sub    $0x8,%esp
  8008e5:	ff 75 0c             	pushl  0xc(%ebp)
  8008e8:	6a 20                	push   $0x20
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	ff d0                	call   *%eax
  8008ef:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008f2:	ff 4d e4             	decl   -0x1c(%ebp)
  8008f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f9:	7f e7                	jg     8008e2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8008fb:	e9 78 01 00 00       	jmp    800a78 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800900:	83 ec 08             	sub    $0x8,%esp
  800903:	ff 75 e8             	pushl  -0x18(%ebp)
  800906:	8d 45 14             	lea    0x14(%ebp),%eax
  800909:	50                   	push   %eax
  80090a:	e8 3c fd ff ff       	call   80064b <getint>
  80090f:	83 c4 10             	add    $0x10,%esp
  800912:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800915:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800918:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80091b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80091e:	85 d2                	test   %edx,%edx
  800920:	79 23                	jns    800945 <vprintfmt+0x29b>
				putch('-', putdat);
  800922:	83 ec 08             	sub    $0x8,%esp
  800925:	ff 75 0c             	pushl  0xc(%ebp)
  800928:	6a 2d                	push   $0x2d
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	ff d0                	call   *%eax
  80092f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800932:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800935:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800938:	f7 d8                	neg    %eax
  80093a:	83 d2 00             	adc    $0x0,%edx
  80093d:	f7 da                	neg    %edx
  80093f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800942:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800945:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80094c:	e9 bc 00 00 00       	jmp    800a0d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	ff 75 e8             	pushl  -0x18(%ebp)
  800957:	8d 45 14             	lea    0x14(%ebp),%eax
  80095a:	50                   	push   %eax
  80095b:	e8 84 fc ff ff       	call   8005e4 <getuint>
  800960:	83 c4 10             	add    $0x10,%esp
  800963:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800966:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800969:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800970:	e9 98 00 00 00       	jmp    800a0d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800975:	83 ec 08             	sub    $0x8,%esp
  800978:	ff 75 0c             	pushl  0xc(%ebp)
  80097b:	6a 58                	push   $0x58
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	ff d0                	call   *%eax
  800982:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	ff 75 0c             	pushl  0xc(%ebp)
  80098b:	6a 58                	push   $0x58
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	ff d0                	call   *%eax
  800992:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800995:	83 ec 08             	sub    $0x8,%esp
  800998:	ff 75 0c             	pushl  0xc(%ebp)
  80099b:	6a 58                	push   $0x58
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	ff d0                	call   *%eax
  8009a2:	83 c4 10             	add    $0x10,%esp
			break;
  8009a5:	e9 ce 00 00 00       	jmp    800a78 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8009aa:	83 ec 08             	sub    $0x8,%esp
  8009ad:	ff 75 0c             	pushl  0xc(%ebp)
  8009b0:	6a 30                	push   $0x30
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	ff d0                	call   *%eax
  8009b7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8009ba:	83 ec 08             	sub    $0x8,%esp
  8009bd:	ff 75 0c             	pushl  0xc(%ebp)
  8009c0:	6a 78                	push   $0x78
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	ff d0                	call   *%eax
  8009c7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8009ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cd:	83 c0 04             	add    $0x4,%eax
  8009d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d6:	83 e8 04             	sub    $0x4,%eax
  8009d9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8009db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8009e5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8009ec:	eb 1f                	jmp    800a0d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8009ee:	83 ec 08             	sub    $0x8,%esp
  8009f1:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f4:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f7:	50                   	push   %eax
  8009f8:	e8 e7 fb ff ff       	call   8005e4 <getuint>
  8009fd:	83 c4 10             	add    $0x10,%esp
  800a00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a03:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a06:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a0d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a14:	83 ec 04             	sub    $0x4,%esp
  800a17:	52                   	push   %edx
  800a18:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a1b:	50                   	push   %eax
  800a1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a1f:	ff 75 f0             	pushl  -0x10(%ebp)
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	ff 75 08             	pushl  0x8(%ebp)
  800a28:	e8 00 fb ff ff       	call   80052d <printnum>
  800a2d:	83 c4 20             	add    $0x20,%esp
			break;
  800a30:	eb 46                	jmp    800a78 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a32:	83 ec 08             	sub    $0x8,%esp
  800a35:	ff 75 0c             	pushl  0xc(%ebp)
  800a38:	53                   	push   %ebx
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	ff d0                	call   *%eax
  800a3e:	83 c4 10             	add    $0x10,%esp
			break;
  800a41:	eb 35                	jmp    800a78 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a43:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800a4a:	eb 2c                	jmp    800a78 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a4c:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800a53:	eb 23                	jmp    800a78 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a55:	83 ec 08             	sub    $0x8,%esp
  800a58:	ff 75 0c             	pushl  0xc(%ebp)
  800a5b:	6a 25                	push   $0x25
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	ff d0                	call   *%eax
  800a62:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a65:	ff 4d 10             	decl   0x10(%ebp)
  800a68:	eb 03                	jmp    800a6d <vprintfmt+0x3c3>
  800a6a:	ff 4d 10             	decl   0x10(%ebp)
  800a6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a70:	48                   	dec    %eax
  800a71:	8a 00                	mov    (%eax),%al
  800a73:	3c 25                	cmp    $0x25,%al
  800a75:	75 f3                	jne    800a6a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a77:	90                   	nop
		}
	}
  800a78:	e9 35 fc ff ff       	jmp    8006b2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a7d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a81:	5b                   	pop    %ebx
  800a82:	5e                   	pop    %esi
  800a83:	5d                   	pop    %ebp
  800a84:	c3                   	ret    

00800a85 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a8b:	8d 45 10             	lea    0x10(%ebp),%eax
  800a8e:	83 c0 04             	add    $0x4,%eax
  800a91:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a94:	8b 45 10             	mov    0x10(%ebp),%eax
  800a97:	ff 75 f4             	pushl  -0xc(%ebp)
  800a9a:	50                   	push   %eax
  800a9b:	ff 75 0c             	pushl  0xc(%ebp)
  800a9e:	ff 75 08             	pushl  0x8(%ebp)
  800aa1:	e8 04 fc ff ff       	call   8006aa <vprintfmt>
  800aa6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800aa9:	90                   	nop
  800aaa:	c9                   	leave  
  800aab:	c3                   	ret    

00800aac <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800aaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab2:	8b 40 08             	mov    0x8(%eax),%eax
  800ab5:	8d 50 01             	lea    0x1(%eax),%edx
  800ab8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800abe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac1:	8b 10                	mov    (%eax),%edx
  800ac3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac6:	8b 40 04             	mov    0x4(%eax),%eax
  800ac9:	39 c2                	cmp    %eax,%edx
  800acb:	73 12                	jae    800adf <sprintputch+0x33>
		*b->buf++ = ch;
  800acd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad0:	8b 00                	mov    (%eax),%eax
  800ad2:	8d 48 01             	lea    0x1(%eax),%ecx
  800ad5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad8:	89 0a                	mov    %ecx,(%edx)
  800ada:	8b 55 08             	mov    0x8(%ebp),%edx
  800add:	88 10                	mov    %dl,(%eax)
}
  800adf:	90                   	nop
  800ae0:	5d                   	pop    %ebp
  800ae1:	c3                   	ret    

00800ae2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800aee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800af4:	8b 45 08             	mov    0x8(%ebp),%eax
  800af7:	01 d0                	add    %edx,%eax
  800af9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800afc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b07:	74 06                	je     800b0f <vsnprintf+0x2d>
  800b09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0d:	7f 07                	jg     800b16 <vsnprintf+0x34>
		return -E_INVAL;
  800b0f:	b8 03 00 00 00       	mov    $0x3,%eax
  800b14:	eb 20                	jmp    800b36 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b16:	ff 75 14             	pushl  0x14(%ebp)
  800b19:	ff 75 10             	pushl  0x10(%ebp)
  800b1c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b1f:	50                   	push   %eax
  800b20:	68 ac 0a 80 00       	push   $0x800aac
  800b25:	e8 80 fb ff ff       	call   8006aa <vprintfmt>
  800b2a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b30:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b36:	c9                   	leave  
  800b37:	c3                   	ret    

00800b38 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b3e:	8d 45 10             	lea    0x10(%ebp),%eax
  800b41:	83 c0 04             	add    $0x4,%eax
  800b44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b47:	8b 45 10             	mov    0x10(%ebp),%eax
  800b4a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b4d:	50                   	push   %eax
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	ff 75 08             	pushl  0x8(%ebp)
  800b54:	e8 89 ff ff ff       	call   800ae2 <vsnprintf>
  800b59:	83 c4 10             	add    $0x10,%esp
  800b5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b62:	c9                   	leave  
  800b63:	c3                   	ret    

00800b64 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
  800b67:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b71:	eb 06                	jmp    800b79 <strlen+0x15>
		n++;
  800b73:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b76:	ff 45 08             	incl   0x8(%ebp)
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8a 00                	mov    (%eax),%al
  800b7e:	84 c0                	test   %al,%al
  800b80:	75 f1                	jne    800b73 <strlen+0xf>
		n++;
	return n;
  800b82:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b85:	c9                   	leave  
  800b86:	c3                   	ret    

00800b87 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b94:	eb 09                	jmp    800b9f <strnlen+0x18>
		n++;
  800b96:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b99:	ff 45 08             	incl   0x8(%ebp)
  800b9c:	ff 4d 0c             	decl   0xc(%ebp)
  800b9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba3:	74 09                	je     800bae <strnlen+0x27>
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba8:	8a 00                	mov    (%eax),%al
  800baa:	84 c0                	test   %al,%al
  800bac:	75 e8                	jne    800b96 <strnlen+0xf>
		n++;
	return n;
  800bae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bb1:	c9                   	leave  
  800bb2:	c3                   	ret    

00800bb3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bbf:	90                   	nop
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	8d 50 01             	lea    0x1(%eax),%edx
  800bc6:	89 55 08             	mov    %edx,0x8(%ebp)
  800bc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bcc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bcf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bd2:	8a 12                	mov    (%edx),%dl
  800bd4:	88 10                	mov    %dl,(%eax)
  800bd6:	8a 00                	mov    (%eax),%al
  800bd8:	84 c0                	test   %al,%al
  800bda:	75 e4                	jne    800bc0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800bdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bdf:	c9                   	leave  
  800be0:	c3                   	ret    

00800be1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800bed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf4:	eb 1f                	jmp    800c15 <strncpy+0x34>
		*dst++ = *src;
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	8d 50 01             	lea    0x1(%eax),%edx
  800bfc:	89 55 08             	mov    %edx,0x8(%ebp)
  800bff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c02:	8a 12                	mov    (%edx),%dl
  800c04:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c09:	8a 00                	mov    (%eax),%al
  800c0b:	84 c0                	test   %al,%al
  800c0d:	74 03                	je     800c12 <strncpy+0x31>
			src++;
  800c0f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c12:	ff 45 fc             	incl   -0x4(%ebp)
  800c15:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c18:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c1b:	72 d9                	jb     800bf6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c20:	c9                   	leave  
  800c21:	c3                   	ret    

00800c22 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c32:	74 30                	je     800c64 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c34:	eb 16                	jmp    800c4c <strlcpy+0x2a>
			*dst++ = *src++;
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	8d 50 01             	lea    0x1(%eax),%edx
  800c3c:	89 55 08             	mov    %edx,0x8(%ebp)
  800c3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c42:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c45:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c48:	8a 12                	mov    (%edx),%dl
  800c4a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c4c:	ff 4d 10             	decl   0x10(%ebp)
  800c4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c53:	74 09                	je     800c5e <strlcpy+0x3c>
  800c55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c58:	8a 00                	mov    (%eax),%al
  800c5a:	84 c0                	test   %al,%al
  800c5c:	75 d8                	jne    800c36 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c64:	8b 55 08             	mov    0x8(%ebp),%edx
  800c67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6a:	29 c2                	sub    %eax,%edx
  800c6c:	89 d0                	mov    %edx,%eax
}
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c73:	eb 06                	jmp    800c7b <strcmp+0xb>
		p++, q++;
  800c75:	ff 45 08             	incl   0x8(%ebp)
  800c78:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8a 00                	mov    (%eax),%al
  800c80:	84 c0                	test   %al,%al
  800c82:	74 0e                	je     800c92 <strcmp+0x22>
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	8a 10                	mov    (%eax),%dl
  800c89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8c:	8a 00                	mov    (%eax),%al
  800c8e:	38 c2                	cmp    %al,%dl
  800c90:	74 e3                	je     800c75 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	8a 00                	mov    (%eax),%al
  800c97:	0f b6 d0             	movzbl %al,%edx
  800c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9d:	8a 00                	mov    (%eax),%al
  800c9f:	0f b6 c0             	movzbl %al,%eax
  800ca2:	29 c2                	sub    %eax,%edx
  800ca4:	89 d0                	mov    %edx,%eax
}
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    

00800ca8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cab:	eb 09                	jmp    800cb6 <strncmp+0xe>
		n--, p++, q++;
  800cad:	ff 4d 10             	decl   0x10(%ebp)
  800cb0:	ff 45 08             	incl   0x8(%ebp)
  800cb3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cba:	74 17                	je     800cd3 <strncmp+0x2b>
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	8a 00                	mov    (%eax),%al
  800cc1:	84 c0                	test   %al,%al
  800cc3:	74 0e                	je     800cd3 <strncmp+0x2b>
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8a 10                	mov    (%eax),%dl
  800cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccd:	8a 00                	mov    (%eax),%al
  800ccf:	38 c2                	cmp    %al,%dl
  800cd1:	74 da                	je     800cad <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800cd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd7:	75 07                	jne    800ce0 <strncmp+0x38>
		return 0;
  800cd9:	b8 00 00 00 00       	mov    $0x0,%eax
  800cde:	eb 14                	jmp    800cf4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	8a 00                	mov    (%eax),%al
  800ce5:	0f b6 d0             	movzbl %al,%edx
  800ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	0f b6 c0             	movzbl %al,%eax
  800cf0:	29 c2                	sub    %eax,%edx
  800cf2:	89 d0                	mov    %edx,%eax
}
  800cf4:	5d                   	pop    %ebp
  800cf5:	c3                   	ret    

00800cf6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	83 ec 04             	sub    $0x4,%esp
  800cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cff:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d02:	eb 12                	jmp    800d16 <strchr+0x20>
		if (*s == c)
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8a 00                	mov    (%eax),%al
  800d09:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d0c:	75 05                	jne    800d13 <strchr+0x1d>
			return (char *) s;
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	eb 11                	jmp    800d24 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d13:	ff 45 08             	incl   0x8(%ebp)
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	84 c0                	test   %al,%al
  800d1d:	75 e5                	jne    800d04 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d24:	c9                   	leave  
  800d25:	c3                   	ret    

00800d26 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	83 ec 04             	sub    $0x4,%esp
  800d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d32:	eb 0d                	jmp    800d41 <strfind+0x1b>
		if (*s == c)
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d3c:	74 0e                	je     800d4c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d3e:	ff 45 08             	incl   0x8(%ebp)
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	8a 00                	mov    (%eax),%al
  800d46:	84 c0                	test   %al,%al
  800d48:	75 ea                	jne    800d34 <strfind+0xe>
  800d4a:	eb 01                	jmp    800d4d <strfind+0x27>
		if (*s == c)
			break;
  800d4c:	90                   	nop
	return (char *) s;
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d50:	c9                   	leave  
  800d51:	c3                   	ret    

00800d52 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d61:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d64:	eb 0e                	jmp    800d74 <memset+0x22>
		*p++ = c;
  800d66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d69:	8d 50 01             	lea    0x1(%eax),%edx
  800d6c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d72:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d74:	ff 4d f8             	decl   -0x8(%ebp)
  800d77:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d7b:	79 e9                	jns    800d66 <memset+0x14>
		*p++ = c;

	return v;
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d80:	c9                   	leave  
  800d81:	c3                   	ret    

00800d82 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d94:	eb 16                	jmp    800dac <memcpy+0x2a>
		*d++ = *s++;
  800d96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d99:	8d 50 01             	lea    0x1(%eax),%edx
  800d9c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800da2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800da8:	8a 12                	mov    (%edx),%dl
  800daa:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dac:	8b 45 10             	mov    0x10(%ebp),%eax
  800daf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db2:	89 55 10             	mov    %edx,0x10(%ebp)
  800db5:	85 c0                	test   %eax,%eax
  800db7:	75 dd                	jne    800d96 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dbc:	c9                   	leave  
  800dbd:	c3                   	ret    

00800dbe <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
  800dc1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dd6:	73 50                	jae    800e28 <memmove+0x6a>
  800dd8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ddb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dde:	01 d0                	add    %edx,%eax
  800de0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800de3:	76 43                	jbe    800e28 <memmove+0x6a>
		s += n;
  800de5:	8b 45 10             	mov    0x10(%ebp),%eax
  800de8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800deb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dee:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800df1:	eb 10                	jmp    800e03 <memmove+0x45>
			*--d = *--s;
  800df3:	ff 4d f8             	decl   -0x8(%ebp)
  800df6:	ff 4d fc             	decl   -0x4(%ebp)
  800df9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dfc:	8a 10                	mov    (%eax),%dl
  800dfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e01:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e03:	8b 45 10             	mov    0x10(%ebp),%eax
  800e06:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e09:	89 55 10             	mov    %edx,0x10(%ebp)
  800e0c:	85 c0                	test   %eax,%eax
  800e0e:	75 e3                	jne    800df3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e10:	eb 23                	jmp    800e35 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e15:	8d 50 01             	lea    0x1(%eax),%edx
  800e18:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e1e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e21:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e24:	8a 12                	mov    (%edx),%dl
  800e26:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e28:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e2e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e31:	85 c0                	test   %eax,%eax
  800e33:	75 dd                	jne    800e12 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e38:	c9                   	leave  
  800e39:	c3                   	ret    

00800e3a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e49:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e4c:	eb 2a                	jmp    800e78 <memcmp+0x3e>
		if (*s1 != *s2)
  800e4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e51:	8a 10                	mov    (%eax),%dl
  800e53:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e56:	8a 00                	mov    (%eax),%al
  800e58:	38 c2                	cmp    %al,%dl
  800e5a:	74 16                	je     800e72 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5f:	8a 00                	mov    (%eax),%al
  800e61:	0f b6 d0             	movzbl %al,%edx
  800e64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e67:	8a 00                	mov    (%eax),%al
  800e69:	0f b6 c0             	movzbl %al,%eax
  800e6c:	29 c2                	sub    %eax,%edx
  800e6e:	89 d0                	mov    %edx,%eax
  800e70:	eb 18                	jmp    800e8a <memcmp+0x50>
		s1++, s2++;
  800e72:	ff 45 fc             	incl   -0x4(%ebp)
  800e75:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e78:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e7e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e81:	85 c0                	test   %eax,%eax
  800e83:	75 c9                	jne    800e4e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e8a:	c9                   	leave  
  800e8b:	c3                   	ret    

00800e8c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e92:	8b 55 08             	mov    0x8(%ebp),%edx
  800e95:	8b 45 10             	mov    0x10(%ebp),%eax
  800e98:	01 d0                	add    %edx,%eax
  800e9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e9d:	eb 15                	jmp    800eb4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	8a 00                	mov    (%eax),%al
  800ea4:	0f b6 d0             	movzbl %al,%edx
  800ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaa:	0f b6 c0             	movzbl %al,%eax
  800ead:	39 c2                	cmp    %eax,%edx
  800eaf:	74 0d                	je     800ebe <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800eb1:	ff 45 08             	incl   0x8(%ebp)
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800eba:	72 e3                	jb     800e9f <memfind+0x13>
  800ebc:	eb 01                	jmp    800ebf <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ebe:	90                   	nop
	return (void *) s;
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec2:	c9                   	leave  
  800ec3:	c3                   	ret    

00800ec4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800eca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ed1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ed8:	eb 03                	jmp    800edd <strtol+0x19>
		s++;
  800eda:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	8a 00                	mov    (%eax),%al
  800ee2:	3c 20                	cmp    $0x20,%al
  800ee4:	74 f4                	je     800eda <strtol+0x16>
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	8a 00                	mov    (%eax),%al
  800eeb:	3c 09                	cmp    $0x9,%al
  800eed:	74 eb                	je     800eda <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	3c 2b                	cmp    $0x2b,%al
  800ef6:	75 05                	jne    800efd <strtol+0x39>
		s++;
  800ef8:	ff 45 08             	incl   0x8(%ebp)
  800efb:	eb 13                	jmp    800f10 <strtol+0x4c>
	else if (*s == '-')
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	3c 2d                	cmp    $0x2d,%al
  800f04:	75 0a                	jne    800f10 <strtol+0x4c>
		s++, neg = 1;
  800f06:	ff 45 08             	incl   0x8(%ebp)
  800f09:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f10:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f14:	74 06                	je     800f1c <strtol+0x58>
  800f16:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f1a:	75 20                	jne    800f3c <strtol+0x78>
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8a 00                	mov    (%eax),%al
  800f21:	3c 30                	cmp    $0x30,%al
  800f23:	75 17                	jne    800f3c <strtol+0x78>
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	40                   	inc    %eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	3c 78                	cmp    $0x78,%al
  800f2d:	75 0d                	jne    800f3c <strtol+0x78>
		s += 2, base = 16;
  800f2f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f33:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f3a:	eb 28                	jmp    800f64 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f3c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f40:	75 15                	jne    800f57 <strtol+0x93>
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	3c 30                	cmp    $0x30,%al
  800f49:	75 0c                	jne    800f57 <strtol+0x93>
		s++, base = 8;
  800f4b:	ff 45 08             	incl   0x8(%ebp)
  800f4e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f55:	eb 0d                	jmp    800f64 <strtol+0xa0>
	else if (base == 0)
  800f57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5b:	75 07                	jne    800f64 <strtol+0xa0>
		base = 10;
  800f5d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	3c 2f                	cmp    $0x2f,%al
  800f6b:	7e 19                	jle    800f86 <strtol+0xc2>
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	3c 39                	cmp    $0x39,%al
  800f74:	7f 10                	jg     800f86 <strtol+0xc2>
			dig = *s - '0';
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	8a 00                	mov    (%eax),%al
  800f7b:	0f be c0             	movsbl %al,%eax
  800f7e:	83 e8 30             	sub    $0x30,%eax
  800f81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f84:	eb 42                	jmp    800fc8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	3c 60                	cmp    $0x60,%al
  800f8d:	7e 19                	jle    800fa8 <strtol+0xe4>
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3c 7a                	cmp    $0x7a,%al
  800f96:	7f 10                	jg     800fa8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	0f be c0             	movsbl %al,%eax
  800fa0:	83 e8 57             	sub    $0x57,%eax
  800fa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fa6:	eb 20                	jmp    800fc8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	8a 00                	mov    (%eax),%al
  800fad:	3c 40                	cmp    $0x40,%al
  800faf:	7e 39                	jle    800fea <strtol+0x126>
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	8a 00                	mov    (%eax),%al
  800fb6:	3c 5a                	cmp    $0x5a,%al
  800fb8:	7f 30                	jg     800fea <strtol+0x126>
			dig = *s - 'A' + 10;
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	0f be c0             	movsbl %al,%eax
  800fc2:	83 e8 37             	sub    $0x37,%eax
  800fc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fcb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fce:	7d 19                	jge    800fe9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fd0:	ff 45 08             	incl   0x8(%ebp)
  800fd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd6:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fda:	89 c2                	mov    %eax,%edx
  800fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fdf:	01 d0                	add    %edx,%eax
  800fe1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800fe4:	e9 7b ff ff ff       	jmp    800f64 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800fe9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800fea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fee:	74 08                	je     800ff8 <strtol+0x134>
		*endptr = (char *) s;
  800ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800ff8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ffc:	74 07                	je     801005 <strtol+0x141>
  800ffe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801001:	f7 d8                	neg    %eax
  801003:	eb 03                	jmp    801008 <strtol+0x144>
  801005:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801008:	c9                   	leave  
  801009:	c3                   	ret    

0080100a <ltostr>:

void
ltostr(long value, char *str)
{
  80100a:	55                   	push   %ebp
  80100b:	89 e5                	mov    %esp,%ebp
  80100d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801010:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801017:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80101e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801022:	79 13                	jns    801037 <ltostr+0x2d>
	{
		neg = 1;
  801024:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80102b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801031:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801034:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80103f:	99                   	cltd   
  801040:	f7 f9                	idiv   %ecx
  801042:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801045:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801048:	8d 50 01             	lea    0x1(%eax),%edx
  80104b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80104e:	89 c2                	mov    %eax,%edx
  801050:	8b 45 0c             	mov    0xc(%ebp),%eax
  801053:	01 d0                	add    %edx,%eax
  801055:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801058:	83 c2 30             	add    $0x30,%edx
  80105b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80105d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801060:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801065:	f7 e9                	imul   %ecx
  801067:	c1 fa 02             	sar    $0x2,%edx
  80106a:	89 c8                	mov    %ecx,%eax
  80106c:	c1 f8 1f             	sar    $0x1f,%eax
  80106f:	29 c2                	sub    %eax,%edx
  801071:	89 d0                	mov    %edx,%eax
  801073:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801076:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80107a:	75 bb                	jne    801037 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80107c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801083:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801086:	48                   	dec    %eax
  801087:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80108a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80108e:	74 3d                	je     8010cd <ltostr+0xc3>
		start = 1 ;
  801090:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801097:	eb 34                	jmp    8010cd <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801099:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80109c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109f:	01 d0                	add    %edx,%eax
  8010a1:	8a 00                	mov    (%eax),%al
  8010a3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ac:	01 c2                	add    %eax,%edx
  8010ae:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b4:	01 c8                	add    %ecx,%eax
  8010b6:	8a 00                	mov    (%eax),%al
  8010b8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c0:	01 c2                	add    %eax,%edx
  8010c2:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010c5:	88 02                	mov    %al,(%edx)
		start++ ;
  8010c7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010ca:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010d3:	7c c4                	jl     801099 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010d5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8010d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010db:	01 d0                	add    %edx,%eax
  8010dd:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8010e0:	90                   	nop
  8010e1:	c9                   	leave  
  8010e2:	c3                   	ret    

008010e3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8010e3:	55                   	push   %ebp
  8010e4:	89 e5                	mov    %esp,%ebp
  8010e6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8010e9:	ff 75 08             	pushl  0x8(%ebp)
  8010ec:	e8 73 fa ff ff       	call   800b64 <strlen>
  8010f1:	83 c4 04             	add    $0x4,%esp
  8010f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8010f7:	ff 75 0c             	pushl  0xc(%ebp)
  8010fa:	e8 65 fa ff ff       	call   800b64 <strlen>
  8010ff:	83 c4 04             	add    $0x4,%esp
  801102:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801105:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80110c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801113:	eb 17                	jmp    80112c <strcconcat+0x49>
		final[s] = str1[s] ;
  801115:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801118:	8b 45 10             	mov    0x10(%ebp),%eax
  80111b:	01 c2                	add    %eax,%edx
  80111d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	01 c8                	add    %ecx,%eax
  801125:	8a 00                	mov    (%eax),%al
  801127:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801129:	ff 45 fc             	incl   -0x4(%ebp)
  80112c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80112f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801132:	7c e1                	jl     801115 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801134:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80113b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801142:	eb 1f                	jmp    801163 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801144:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801147:	8d 50 01             	lea    0x1(%eax),%edx
  80114a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80114d:	89 c2                	mov    %eax,%edx
  80114f:	8b 45 10             	mov    0x10(%ebp),%eax
  801152:	01 c2                	add    %eax,%edx
  801154:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115a:	01 c8                	add    %ecx,%eax
  80115c:	8a 00                	mov    (%eax),%al
  80115e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801160:	ff 45 f8             	incl   -0x8(%ebp)
  801163:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801166:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801169:	7c d9                	jl     801144 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80116b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80116e:	8b 45 10             	mov    0x10(%ebp),%eax
  801171:	01 d0                	add    %edx,%eax
  801173:	c6 00 00             	movb   $0x0,(%eax)
}
  801176:	90                   	nop
  801177:	c9                   	leave  
  801178:	c3                   	ret    

00801179 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80117c:	8b 45 14             	mov    0x14(%ebp),%eax
  80117f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801185:	8b 45 14             	mov    0x14(%ebp),%eax
  801188:	8b 00                	mov    (%eax),%eax
  80118a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801191:	8b 45 10             	mov    0x10(%ebp),%eax
  801194:	01 d0                	add    %edx,%eax
  801196:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80119c:	eb 0c                	jmp    8011aa <strsplit+0x31>
			*string++ = 0;
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	8d 50 01             	lea    0x1(%eax),%edx
  8011a4:	89 55 08             	mov    %edx,0x8(%ebp)
  8011a7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	84 c0                	test   %al,%al
  8011b1:	74 18                	je     8011cb <strsplit+0x52>
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	0f be c0             	movsbl %al,%eax
  8011bb:	50                   	push   %eax
  8011bc:	ff 75 0c             	pushl  0xc(%ebp)
  8011bf:	e8 32 fb ff ff       	call   800cf6 <strchr>
  8011c4:	83 c4 08             	add    $0x8,%esp
  8011c7:	85 c0                	test   %eax,%eax
  8011c9:	75 d3                	jne    80119e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	8a 00                	mov    (%eax),%al
  8011d0:	84 c0                	test   %al,%al
  8011d2:	74 5a                	je     80122e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d7:	8b 00                	mov    (%eax),%eax
  8011d9:	83 f8 0f             	cmp    $0xf,%eax
  8011dc:	75 07                	jne    8011e5 <strsplit+0x6c>
		{
			return 0;
  8011de:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e3:	eb 66                	jmp    80124b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8011e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e8:	8b 00                	mov    (%eax),%eax
  8011ea:	8d 48 01             	lea    0x1(%eax),%ecx
  8011ed:	8b 55 14             	mov    0x14(%ebp),%edx
  8011f0:	89 0a                	mov    %ecx,(%edx)
  8011f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fc:	01 c2                	add    %eax,%edx
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801203:	eb 03                	jmp    801208 <strsplit+0x8f>
			string++;
  801205:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	84 c0                	test   %al,%al
  80120f:	74 8b                	je     80119c <strsplit+0x23>
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	0f be c0             	movsbl %al,%eax
  801219:	50                   	push   %eax
  80121a:	ff 75 0c             	pushl  0xc(%ebp)
  80121d:	e8 d4 fa ff ff       	call   800cf6 <strchr>
  801222:	83 c4 08             	add    $0x8,%esp
  801225:	85 c0                	test   %eax,%eax
  801227:	74 dc                	je     801205 <strsplit+0x8c>
			string++;
	}
  801229:	e9 6e ff ff ff       	jmp    80119c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80122e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80122f:	8b 45 14             	mov    0x14(%ebp),%eax
  801232:	8b 00                	mov    (%eax),%eax
  801234:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80123b:	8b 45 10             	mov    0x10(%ebp),%eax
  80123e:	01 d0                	add    %edx,%eax
  801240:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801246:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80124b:	c9                   	leave  
  80124c:	c3                   	ret    

0080124d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80124d:	55                   	push   %ebp
  80124e:	89 e5                	mov    %esp,%ebp
  801250:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801253:	83 ec 04             	sub    $0x4,%esp
  801256:	68 a8 21 80 00       	push   $0x8021a8
  80125b:	68 3f 01 00 00       	push   $0x13f
  801260:	68 ca 21 80 00       	push   $0x8021ca
  801265:	e8 a9 ef ff ff       	call   800213 <_panic>

0080126a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80126a:	55                   	push   %ebp
  80126b:	89 e5                	mov    %esp,%ebp
  80126d:	57                   	push   %edi
  80126e:	56                   	push   %esi
  80126f:	53                   	push   %ebx
  801270:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	8b 55 0c             	mov    0xc(%ebp),%edx
  801279:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80127c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80127f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801282:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801285:	cd 30                	int    $0x30
  801287:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80128a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80128d:	83 c4 10             	add    $0x10,%esp
  801290:	5b                   	pop    %ebx
  801291:	5e                   	pop    %esi
  801292:	5f                   	pop    %edi
  801293:	5d                   	pop    %ebp
  801294:	c3                   	ret    

00801295 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
  801298:	83 ec 04             	sub    $0x4,%esp
  80129b:	8b 45 10             	mov    0x10(%ebp),%eax
  80129e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012a1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	6a 00                	push   $0x0
  8012aa:	6a 00                	push   $0x0
  8012ac:	52                   	push   %edx
  8012ad:	ff 75 0c             	pushl  0xc(%ebp)
  8012b0:	50                   	push   %eax
  8012b1:	6a 00                	push   $0x0
  8012b3:	e8 b2 ff ff ff       	call   80126a <syscall>
  8012b8:	83 c4 18             	add    $0x18,%esp
}
  8012bb:	90                   	nop
  8012bc:	c9                   	leave  
  8012bd:	c3                   	ret    

008012be <sys_cgetc>:

int
sys_cgetc(void)
{
  8012be:	55                   	push   %ebp
  8012bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012c1:	6a 00                	push   $0x0
  8012c3:	6a 00                	push   $0x0
  8012c5:	6a 00                	push   $0x0
  8012c7:	6a 00                	push   $0x0
  8012c9:	6a 00                	push   $0x0
  8012cb:	6a 02                	push   $0x2
  8012cd:	e8 98 ff ff ff       	call   80126a <syscall>
  8012d2:	83 c4 18             	add    $0x18,%esp
}
  8012d5:	c9                   	leave  
  8012d6:	c3                   	ret    

008012d7 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8012da:	6a 00                	push   $0x0
  8012dc:	6a 00                	push   $0x0
  8012de:	6a 00                	push   $0x0
  8012e0:	6a 00                	push   $0x0
  8012e2:	6a 00                	push   $0x0
  8012e4:	6a 03                	push   $0x3
  8012e6:	e8 7f ff ff ff       	call   80126a <syscall>
  8012eb:	83 c4 18             	add    $0x18,%esp
}
  8012ee:	90                   	nop
  8012ef:	c9                   	leave  
  8012f0:	c3                   	ret    

008012f1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8012f4:	6a 00                	push   $0x0
  8012f6:	6a 00                	push   $0x0
  8012f8:	6a 00                	push   $0x0
  8012fa:	6a 00                	push   $0x0
  8012fc:	6a 00                	push   $0x0
  8012fe:	6a 04                	push   $0x4
  801300:	e8 65 ff ff ff       	call   80126a <syscall>
  801305:	83 c4 18             	add    $0x18,%esp
}
  801308:	90                   	nop
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80130e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	6a 00                	push   $0x0
  801316:	6a 00                	push   $0x0
  801318:	6a 00                	push   $0x0
  80131a:	52                   	push   %edx
  80131b:	50                   	push   %eax
  80131c:	6a 08                	push   $0x8
  80131e:	e8 47 ff ff ff       	call   80126a <syscall>
  801323:	83 c4 18             	add    $0x18,%esp
}
  801326:	c9                   	leave  
  801327:	c3                   	ret    

00801328 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
  80132b:	56                   	push   %esi
  80132c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80132d:	8b 75 18             	mov    0x18(%ebp),%esi
  801330:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801333:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801336:	8b 55 0c             	mov    0xc(%ebp),%edx
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	56                   	push   %esi
  80133d:	53                   	push   %ebx
  80133e:	51                   	push   %ecx
  80133f:	52                   	push   %edx
  801340:	50                   	push   %eax
  801341:	6a 09                	push   $0x9
  801343:	e8 22 ff ff ff       	call   80126a <syscall>
  801348:	83 c4 18             	add    $0x18,%esp
}
  80134b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80134e:	5b                   	pop    %ebx
  80134f:	5e                   	pop    %esi
  801350:	5d                   	pop    %ebp
  801351:	c3                   	ret    

00801352 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801352:	55                   	push   %ebp
  801353:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801355:	8b 55 0c             	mov    0xc(%ebp),%edx
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	6a 00                	push   $0x0
  80135d:	6a 00                	push   $0x0
  80135f:	6a 00                	push   $0x0
  801361:	52                   	push   %edx
  801362:	50                   	push   %eax
  801363:	6a 0a                	push   $0xa
  801365:	e8 00 ff ff ff       	call   80126a <syscall>
  80136a:	83 c4 18             	add    $0x18,%esp
}
  80136d:	c9                   	leave  
  80136e:	c3                   	ret    

0080136f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	6a 00                	push   $0x0
  801378:	ff 75 0c             	pushl  0xc(%ebp)
  80137b:	ff 75 08             	pushl  0x8(%ebp)
  80137e:	6a 0b                	push   $0xb
  801380:	e8 e5 fe ff ff       	call   80126a <syscall>
  801385:	83 c4 18             	add    $0x18,%esp
}
  801388:	c9                   	leave  
  801389:	c3                   	ret    

0080138a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	6a 00                	push   $0x0
  801393:	6a 00                	push   $0x0
  801395:	6a 00                	push   $0x0
  801397:	6a 0c                	push   $0xc
  801399:	e8 cc fe ff ff       	call   80126a <syscall>
  80139e:	83 c4 18             	add    $0x18,%esp
}
  8013a1:	c9                   	leave  
  8013a2:	c3                   	ret    

008013a3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013a3:	55                   	push   %ebp
  8013a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 0d                	push   $0xd
  8013b2:	e8 b3 fe ff ff       	call   80126a <syscall>
  8013b7:	83 c4 18             	add    $0x18,%esp
}
  8013ba:	c9                   	leave  
  8013bb:	c3                   	ret    

008013bc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 0e                	push   $0xe
  8013cb:	e8 9a fe ff ff       	call   80126a <syscall>
  8013d0:	83 c4 18             	add    $0x18,%esp
}
  8013d3:	c9                   	leave  
  8013d4:	c3                   	ret    

008013d5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 0f                	push   $0xf
  8013e4:	e8 81 fe ff ff       	call   80126a <syscall>
  8013e9:	83 c4 18             	add    $0x18,%esp
}
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    

008013ee <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	ff 75 08             	pushl  0x8(%ebp)
  8013fc:	6a 10                	push   $0x10
  8013fe:	e8 67 fe ff ff       	call   80126a <syscall>
  801403:	83 c4 18             	add    $0x18,%esp
}
  801406:	c9                   	leave  
  801407:	c3                   	ret    

00801408 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80140b:	6a 00                	push   $0x0
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	6a 11                	push   $0x11
  801417:	e8 4e fe ff ff       	call   80126a <syscall>
  80141c:	83 c4 18             	add    $0x18,%esp
}
  80141f:	90                   	nop
  801420:	c9                   	leave  
  801421:	c3                   	ret    

00801422 <sys_cputc>:

void
sys_cputc(const char c)
{
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
  801425:	83 ec 04             	sub    $0x4,%esp
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80142e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	6a 00                	push   $0x0
  80143a:	50                   	push   %eax
  80143b:	6a 01                	push   $0x1
  80143d:	e8 28 fe ff ff       	call   80126a <syscall>
  801442:	83 c4 18             	add    $0x18,%esp
}
  801445:	90                   	nop
  801446:	c9                   	leave  
  801447:	c3                   	ret    

00801448 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80144b:	6a 00                	push   $0x0
  80144d:	6a 00                	push   $0x0
  80144f:	6a 00                	push   $0x0
  801451:	6a 00                	push   $0x0
  801453:	6a 00                	push   $0x0
  801455:	6a 14                	push   $0x14
  801457:	e8 0e fe ff ff       	call   80126a <syscall>
  80145c:	83 c4 18             	add    $0x18,%esp
}
  80145f:	90                   	nop
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 04             	sub    $0x4,%esp
  801468:	8b 45 10             	mov    0x10(%ebp),%eax
  80146b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80146e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801471:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801475:	8b 45 08             	mov    0x8(%ebp),%eax
  801478:	6a 00                	push   $0x0
  80147a:	51                   	push   %ecx
  80147b:	52                   	push   %edx
  80147c:	ff 75 0c             	pushl  0xc(%ebp)
  80147f:	50                   	push   %eax
  801480:	6a 15                	push   $0x15
  801482:	e8 e3 fd ff ff       	call   80126a <syscall>
  801487:	83 c4 18             	add    $0x18,%esp
}
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80148f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	52                   	push   %edx
  80149c:	50                   	push   %eax
  80149d:	6a 16                	push   $0x16
  80149f:	e8 c6 fd ff ff       	call   80126a <syscall>
  8014a4:	83 c4 18             	add    $0x18,%esp
}
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    

008014a9 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8014ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	51                   	push   %ecx
  8014ba:	52                   	push   %edx
  8014bb:	50                   	push   %eax
  8014bc:	6a 17                	push   $0x17
  8014be:	e8 a7 fd ff ff       	call   80126a <syscall>
  8014c3:	83 c4 18             	add    $0x18,%esp
}
  8014c6:	c9                   	leave  
  8014c7:	c3                   	ret    

008014c8 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8014cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	52                   	push   %edx
  8014d8:	50                   	push   %eax
  8014d9:	6a 18                	push   $0x18
  8014db:	e8 8a fd ff ff       	call   80126a <syscall>
  8014e0:	83 c4 18             	add    $0x18,%esp
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	6a 00                	push   $0x0
  8014ed:	ff 75 14             	pushl  0x14(%ebp)
  8014f0:	ff 75 10             	pushl  0x10(%ebp)
  8014f3:	ff 75 0c             	pushl  0xc(%ebp)
  8014f6:	50                   	push   %eax
  8014f7:	6a 19                	push   $0x19
  8014f9:	e8 6c fd ff ff       	call   80126a <syscall>
  8014fe:	83 c4 18             	add    $0x18,%esp
}
  801501:	c9                   	leave  
  801502:	c3                   	ret    

00801503 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	50                   	push   %eax
  801512:	6a 1a                	push   $0x1a
  801514:	e8 51 fd ff ff       	call   80126a <syscall>
  801519:	83 c4 18             	add    $0x18,%esp
}
  80151c:	90                   	nop
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	50                   	push   %eax
  80152e:	6a 1b                	push   $0x1b
  801530:	e8 35 fd ff ff       	call   80126a <syscall>
  801535:	83 c4 18             	add    $0x18,%esp
}
  801538:	c9                   	leave  
  801539:	c3                   	ret    

0080153a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	6a 05                	push   $0x5
  801549:	e8 1c fd ff ff       	call   80126a <syscall>
  80154e:	83 c4 18             	add    $0x18,%esp
}
  801551:	c9                   	leave  
  801552:	c3                   	ret    

00801553 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	6a 06                	push   $0x6
  801562:	e8 03 fd ff ff       	call   80126a <syscall>
  801567:	83 c4 18             	add    $0x18,%esp
}
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 07                	push   $0x7
  80157b:	e8 ea fc ff ff       	call   80126a <syscall>
  801580:	83 c4 18             	add    $0x18,%esp
}
  801583:	c9                   	leave  
  801584:	c3                   	ret    

00801585 <sys_exit_env>:


void sys_exit_env(void)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 1c                	push   $0x1c
  801594:	e8 d1 fc ff ff       	call   80126a <syscall>
  801599:	83 c4 18             	add    $0x18,%esp
}
  80159c:	90                   	nop
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    

0080159f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
  8015a2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8015a5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015a8:	8d 50 04             	lea    0x4(%eax),%edx
  8015ab:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	52                   	push   %edx
  8015b5:	50                   	push   %eax
  8015b6:	6a 1d                	push   $0x1d
  8015b8:	e8 ad fc ff ff       	call   80126a <syscall>
  8015bd:	83 c4 18             	add    $0x18,%esp
	return result;
  8015c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c9:	89 01                	mov    %eax,(%ecx)
  8015cb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8015ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d1:	c9                   	leave  
  8015d2:	c2 04 00             	ret    $0x4

008015d5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	ff 75 10             	pushl  0x10(%ebp)
  8015df:	ff 75 0c             	pushl  0xc(%ebp)
  8015e2:	ff 75 08             	pushl  0x8(%ebp)
  8015e5:	6a 13                	push   $0x13
  8015e7:	e8 7e fc ff ff       	call   80126a <syscall>
  8015ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8015ef:	90                   	nop
}
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 1e                	push   $0x1e
  801601:	e8 64 fc ff ff       	call   80126a <syscall>
  801606:	83 c4 18             	add    $0x18,%esp
}
  801609:	c9                   	leave  
  80160a:	c3                   	ret    

0080160b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
  80160e:	83 ec 04             	sub    $0x4,%esp
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801617:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	50                   	push   %eax
  801624:	6a 1f                	push   $0x1f
  801626:	e8 3f fc ff ff       	call   80126a <syscall>
  80162b:	83 c4 18             	add    $0x18,%esp
	return ;
  80162e:	90                   	nop
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <rsttst>:
void rsttst()
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 21                	push   $0x21
  801640:	e8 25 fc ff ff       	call   80126a <syscall>
  801645:	83 c4 18             	add    $0x18,%esp
	return ;
  801648:	90                   	nop
}
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
  80164e:	83 ec 04             	sub    $0x4,%esp
  801651:	8b 45 14             	mov    0x14(%ebp),%eax
  801654:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801657:	8b 55 18             	mov    0x18(%ebp),%edx
  80165a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80165e:	52                   	push   %edx
  80165f:	50                   	push   %eax
  801660:	ff 75 10             	pushl  0x10(%ebp)
  801663:	ff 75 0c             	pushl  0xc(%ebp)
  801666:	ff 75 08             	pushl  0x8(%ebp)
  801669:	6a 20                	push   $0x20
  80166b:	e8 fa fb ff ff       	call   80126a <syscall>
  801670:	83 c4 18             	add    $0x18,%esp
	return ;
  801673:	90                   	nop
}
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <chktst>:
void chktst(uint32 n)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	ff 75 08             	pushl  0x8(%ebp)
  801684:	6a 22                	push   $0x22
  801686:	e8 df fb ff ff       	call   80126a <syscall>
  80168b:	83 c4 18             	add    $0x18,%esp
	return ;
  80168e:	90                   	nop
}
  80168f:	c9                   	leave  
  801690:	c3                   	ret    

00801691 <inctst>:

void inctst()
{
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 23                	push   $0x23
  8016a0:	e8 c5 fb ff ff       	call   80126a <syscall>
  8016a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8016a8:	90                   	nop
}
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    

008016ab <gettst>:
uint32 gettst()
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 24                	push   $0x24
  8016ba:	e8 ab fb ff ff       	call   80126a <syscall>
  8016bf:	83 c4 18             	add    $0x18,%esp
}
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
  8016c7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 25                	push   $0x25
  8016d6:	e8 8f fb ff ff       	call   80126a <syscall>
  8016db:	83 c4 18             	add    $0x18,%esp
  8016de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8016e1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8016e5:	75 07                	jne    8016ee <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8016e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8016ec:	eb 05                	jmp    8016f3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8016ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f3:	c9                   	leave  
  8016f4:	c3                   	ret    

008016f5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 25                	push   $0x25
  801707:	e8 5e fb ff ff       	call   80126a <syscall>
  80170c:	83 c4 18             	add    $0x18,%esp
  80170f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801712:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801716:	75 07                	jne    80171f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801718:	b8 01 00 00 00       	mov    $0x1,%eax
  80171d:	eb 05                	jmp    801724 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80171f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 25                	push   $0x25
  801738:	e8 2d fb ff ff       	call   80126a <syscall>
  80173d:	83 c4 18             	add    $0x18,%esp
  801740:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801743:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801747:	75 07                	jne    801750 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801749:	b8 01 00 00 00       	mov    $0x1,%eax
  80174e:	eb 05                	jmp    801755 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801750:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801755:	c9                   	leave  
  801756:	c3                   	ret    

00801757 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
  80175a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 25                	push   $0x25
  801769:	e8 fc fa ff ff       	call   80126a <syscall>
  80176e:	83 c4 18             	add    $0x18,%esp
  801771:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801774:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801778:	75 07                	jne    801781 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80177a:	b8 01 00 00 00       	mov    $0x1,%eax
  80177f:	eb 05                	jmp    801786 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801781:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801786:	c9                   	leave  
  801787:	c3                   	ret    

00801788 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	ff 75 08             	pushl  0x8(%ebp)
  801796:	6a 26                	push   $0x26
  801798:	e8 cd fa ff ff       	call   80126a <syscall>
  80179d:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a0:	90                   	nop
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8017a7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	6a 00                	push   $0x0
  8017b5:	53                   	push   %ebx
  8017b6:	51                   	push   %ecx
  8017b7:	52                   	push   %edx
  8017b8:	50                   	push   %eax
  8017b9:	6a 27                	push   $0x27
  8017bb:	e8 aa fa ff ff       	call   80126a <syscall>
  8017c0:	83 c4 18             	add    $0x18,%esp
}
  8017c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8017cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	52                   	push   %edx
  8017d8:	50                   	push   %eax
  8017d9:	6a 28                	push   $0x28
  8017db:	e8 8a fa ff ff       	call   80126a <syscall>
  8017e0:	83 c4 18             	add    $0x18,%esp
}
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    

008017e5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8017e8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f1:	6a 00                	push   $0x0
  8017f3:	51                   	push   %ecx
  8017f4:	ff 75 10             	pushl  0x10(%ebp)
  8017f7:	52                   	push   %edx
  8017f8:	50                   	push   %eax
  8017f9:	6a 29                	push   $0x29
  8017fb:	e8 6a fa ff ff       	call   80126a <syscall>
  801800:	83 c4 18             	add    $0x18,%esp
}
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	ff 75 10             	pushl  0x10(%ebp)
  80180f:	ff 75 0c             	pushl  0xc(%ebp)
  801812:	ff 75 08             	pushl  0x8(%ebp)
  801815:	6a 12                	push   $0x12
  801817:	e8 4e fa ff ff       	call   80126a <syscall>
  80181c:	83 c4 18             	add    $0x18,%esp
	return ;
  80181f:	90                   	nop
}
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801825:	8b 55 0c             	mov    0xc(%ebp),%edx
  801828:	8b 45 08             	mov    0x8(%ebp),%eax
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	52                   	push   %edx
  801832:	50                   	push   %eax
  801833:	6a 2a                	push   $0x2a
  801835:	e8 30 fa ff ff       	call   80126a <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
	return;
  80183d:	90                   	nop
}
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801846:	83 ec 04             	sub    $0x4,%esp
  801849:	68 d7 21 80 00       	push   $0x8021d7
  80184e:	68 2e 01 00 00       	push   $0x12e
  801853:	68 eb 21 80 00       	push   $0x8021eb
  801858:	e8 b6 e9 ff ff       	call   800213 <_panic>

0080185d <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801863:	83 ec 04             	sub    $0x4,%esp
  801866:	68 d7 21 80 00       	push   $0x8021d7
  80186b:	68 35 01 00 00       	push   $0x135
  801870:	68 eb 21 80 00       	push   $0x8021eb
  801875:	e8 99 e9 ff ff       	call   800213 <_panic>

0080187a <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
  80187d:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801880:	83 ec 04             	sub    $0x4,%esp
  801883:	68 d7 21 80 00       	push   $0x8021d7
  801888:	68 3b 01 00 00       	push   $0x13b
  80188d:	68 eb 21 80 00       	push   $0x8021eb
  801892:	e8 7c e9 ff ff       	call   800213 <_panic>
  801897:	90                   	nop

00801898 <__udivdi3>:
  801898:	55                   	push   %ebp
  801899:	57                   	push   %edi
  80189a:	56                   	push   %esi
  80189b:	53                   	push   %ebx
  80189c:	83 ec 1c             	sub    $0x1c,%esp
  80189f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8018a3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8018a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018af:	89 ca                	mov    %ecx,%edx
  8018b1:	89 f8                	mov    %edi,%eax
  8018b3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8018b7:	85 f6                	test   %esi,%esi
  8018b9:	75 2d                	jne    8018e8 <__udivdi3+0x50>
  8018bb:	39 cf                	cmp    %ecx,%edi
  8018bd:	77 65                	ja     801924 <__udivdi3+0x8c>
  8018bf:	89 fd                	mov    %edi,%ebp
  8018c1:	85 ff                	test   %edi,%edi
  8018c3:	75 0b                	jne    8018d0 <__udivdi3+0x38>
  8018c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ca:	31 d2                	xor    %edx,%edx
  8018cc:	f7 f7                	div    %edi
  8018ce:	89 c5                	mov    %eax,%ebp
  8018d0:	31 d2                	xor    %edx,%edx
  8018d2:	89 c8                	mov    %ecx,%eax
  8018d4:	f7 f5                	div    %ebp
  8018d6:	89 c1                	mov    %eax,%ecx
  8018d8:	89 d8                	mov    %ebx,%eax
  8018da:	f7 f5                	div    %ebp
  8018dc:	89 cf                	mov    %ecx,%edi
  8018de:	89 fa                	mov    %edi,%edx
  8018e0:	83 c4 1c             	add    $0x1c,%esp
  8018e3:	5b                   	pop    %ebx
  8018e4:	5e                   	pop    %esi
  8018e5:	5f                   	pop    %edi
  8018e6:	5d                   	pop    %ebp
  8018e7:	c3                   	ret    
  8018e8:	39 ce                	cmp    %ecx,%esi
  8018ea:	77 28                	ja     801914 <__udivdi3+0x7c>
  8018ec:	0f bd fe             	bsr    %esi,%edi
  8018ef:	83 f7 1f             	xor    $0x1f,%edi
  8018f2:	75 40                	jne    801934 <__udivdi3+0x9c>
  8018f4:	39 ce                	cmp    %ecx,%esi
  8018f6:	72 0a                	jb     801902 <__udivdi3+0x6a>
  8018f8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8018fc:	0f 87 9e 00 00 00    	ja     8019a0 <__udivdi3+0x108>
  801902:	b8 01 00 00 00       	mov    $0x1,%eax
  801907:	89 fa                	mov    %edi,%edx
  801909:	83 c4 1c             	add    $0x1c,%esp
  80190c:	5b                   	pop    %ebx
  80190d:	5e                   	pop    %esi
  80190e:	5f                   	pop    %edi
  80190f:	5d                   	pop    %ebp
  801910:	c3                   	ret    
  801911:	8d 76 00             	lea    0x0(%esi),%esi
  801914:	31 ff                	xor    %edi,%edi
  801916:	31 c0                	xor    %eax,%eax
  801918:	89 fa                	mov    %edi,%edx
  80191a:	83 c4 1c             	add    $0x1c,%esp
  80191d:	5b                   	pop    %ebx
  80191e:	5e                   	pop    %esi
  80191f:	5f                   	pop    %edi
  801920:	5d                   	pop    %ebp
  801921:	c3                   	ret    
  801922:	66 90                	xchg   %ax,%ax
  801924:	89 d8                	mov    %ebx,%eax
  801926:	f7 f7                	div    %edi
  801928:	31 ff                	xor    %edi,%edi
  80192a:	89 fa                	mov    %edi,%edx
  80192c:	83 c4 1c             	add    $0x1c,%esp
  80192f:	5b                   	pop    %ebx
  801930:	5e                   	pop    %esi
  801931:	5f                   	pop    %edi
  801932:	5d                   	pop    %ebp
  801933:	c3                   	ret    
  801934:	bd 20 00 00 00       	mov    $0x20,%ebp
  801939:	89 eb                	mov    %ebp,%ebx
  80193b:	29 fb                	sub    %edi,%ebx
  80193d:	89 f9                	mov    %edi,%ecx
  80193f:	d3 e6                	shl    %cl,%esi
  801941:	89 c5                	mov    %eax,%ebp
  801943:	88 d9                	mov    %bl,%cl
  801945:	d3 ed                	shr    %cl,%ebp
  801947:	89 e9                	mov    %ebp,%ecx
  801949:	09 f1                	or     %esi,%ecx
  80194b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80194f:	89 f9                	mov    %edi,%ecx
  801951:	d3 e0                	shl    %cl,%eax
  801953:	89 c5                	mov    %eax,%ebp
  801955:	89 d6                	mov    %edx,%esi
  801957:	88 d9                	mov    %bl,%cl
  801959:	d3 ee                	shr    %cl,%esi
  80195b:	89 f9                	mov    %edi,%ecx
  80195d:	d3 e2                	shl    %cl,%edx
  80195f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801963:	88 d9                	mov    %bl,%cl
  801965:	d3 e8                	shr    %cl,%eax
  801967:	09 c2                	or     %eax,%edx
  801969:	89 d0                	mov    %edx,%eax
  80196b:	89 f2                	mov    %esi,%edx
  80196d:	f7 74 24 0c          	divl   0xc(%esp)
  801971:	89 d6                	mov    %edx,%esi
  801973:	89 c3                	mov    %eax,%ebx
  801975:	f7 e5                	mul    %ebp
  801977:	39 d6                	cmp    %edx,%esi
  801979:	72 19                	jb     801994 <__udivdi3+0xfc>
  80197b:	74 0b                	je     801988 <__udivdi3+0xf0>
  80197d:	89 d8                	mov    %ebx,%eax
  80197f:	31 ff                	xor    %edi,%edi
  801981:	e9 58 ff ff ff       	jmp    8018de <__udivdi3+0x46>
  801986:	66 90                	xchg   %ax,%ax
  801988:	8b 54 24 08          	mov    0x8(%esp),%edx
  80198c:	89 f9                	mov    %edi,%ecx
  80198e:	d3 e2                	shl    %cl,%edx
  801990:	39 c2                	cmp    %eax,%edx
  801992:	73 e9                	jae    80197d <__udivdi3+0xe5>
  801994:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801997:	31 ff                	xor    %edi,%edi
  801999:	e9 40 ff ff ff       	jmp    8018de <__udivdi3+0x46>
  80199e:	66 90                	xchg   %ax,%ax
  8019a0:	31 c0                	xor    %eax,%eax
  8019a2:	e9 37 ff ff ff       	jmp    8018de <__udivdi3+0x46>
  8019a7:	90                   	nop

008019a8 <__umoddi3>:
  8019a8:	55                   	push   %ebp
  8019a9:	57                   	push   %edi
  8019aa:	56                   	push   %esi
  8019ab:	53                   	push   %ebx
  8019ac:	83 ec 1c             	sub    $0x1c,%esp
  8019af:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8019b3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8019b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8019bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019c7:	89 f3                	mov    %esi,%ebx
  8019c9:	89 fa                	mov    %edi,%edx
  8019cb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019cf:	89 34 24             	mov    %esi,(%esp)
  8019d2:	85 c0                	test   %eax,%eax
  8019d4:	75 1a                	jne    8019f0 <__umoddi3+0x48>
  8019d6:	39 f7                	cmp    %esi,%edi
  8019d8:	0f 86 a2 00 00 00    	jbe    801a80 <__umoddi3+0xd8>
  8019de:	89 c8                	mov    %ecx,%eax
  8019e0:	89 f2                	mov    %esi,%edx
  8019e2:	f7 f7                	div    %edi
  8019e4:	89 d0                	mov    %edx,%eax
  8019e6:	31 d2                	xor    %edx,%edx
  8019e8:	83 c4 1c             	add    $0x1c,%esp
  8019eb:	5b                   	pop    %ebx
  8019ec:	5e                   	pop    %esi
  8019ed:	5f                   	pop    %edi
  8019ee:	5d                   	pop    %ebp
  8019ef:	c3                   	ret    
  8019f0:	39 f0                	cmp    %esi,%eax
  8019f2:	0f 87 ac 00 00 00    	ja     801aa4 <__umoddi3+0xfc>
  8019f8:	0f bd e8             	bsr    %eax,%ebp
  8019fb:	83 f5 1f             	xor    $0x1f,%ebp
  8019fe:	0f 84 ac 00 00 00    	je     801ab0 <__umoddi3+0x108>
  801a04:	bf 20 00 00 00       	mov    $0x20,%edi
  801a09:	29 ef                	sub    %ebp,%edi
  801a0b:	89 fe                	mov    %edi,%esi
  801a0d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a11:	89 e9                	mov    %ebp,%ecx
  801a13:	d3 e0                	shl    %cl,%eax
  801a15:	89 d7                	mov    %edx,%edi
  801a17:	89 f1                	mov    %esi,%ecx
  801a19:	d3 ef                	shr    %cl,%edi
  801a1b:	09 c7                	or     %eax,%edi
  801a1d:	89 e9                	mov    %ebp,%ecx
  801a1f:	d3 e2                	shl    %cl,%edx
  801a21:	89 14 24             	mov    %edx,(%esp)
  801a24:	89 d8                	mov    %ebx,%eax
  801a26:	d3 e0                	shl    %cl,%eax
  801a28:	89 c2                	mov    %eax,%edx
  801a2a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a2e:	d3 e0                	shl    %cl,%eax
  801a30:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a34:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a38:	89 f1                	mov    %esi,%ecx
  801a3a:	d3 e8                	shr    %cl,%eax
  801a3c:	09 d0                	or     %edx,%eax
  801a3e:	d3 eb                	shr    %cl,%ebx
  801a40:	89 da                	mov    %ebx,%edx
  801a42:	f7 f7                	div    %edi
  801a44:	89 d3                	mov    %edx,%ebx
  801a46:	f7 24 24             	mull   (%esp)
  801a49:	89 c6                	mov    %eax,%esi
  801a4b:	89 d1                	mov    %edx,%ecx
  801a4d:	39 d3                	cmp    %edx,%ebx
  801a4f:	0f 82 87 00 00 00    	jb     801adc <__umoddi3+0x134>
  801a55:	0f 84 91 00 00 00    	je     801aec <__umoddi3+0x144>
  801a5b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a5f:	29 f2                	sub    %esi,%edx
  801a61:	19 cb                	sbb    %ecx,%ebx
  801a63:	89 d8                	mov    %ebx,%eax
  801a65:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a69:	d3 e0                	shl    %cl,%eax
  801a6b:	89 e9                	mov    %ebp,%ecx
  801a6d:	d3 ea                	shr    %cl,%edx
  801a6f:	09 d0                	or     %edx,%eax
  801a71:	89 e9                	mov    %ebp,%ecx
  801a73:	d3 eb                	shr    %cl,%ebx
  801a75:	89 da                	mov    %ebx,%edx
  801a77:	83 c4 1c             	add    $0x1c,%esp
  801a7a:	5b                   	pop    %ebx
  801a7b:	5e                   	pop    %esi
  801a7c:	5f                   	pop    %edi
  801a7d:	5d                   	pop    %ebp
  801a7e:	c3                   	ret    
  801a7f:	90                   	nop
  801a80:	89 fd                	mov    %edi,%ebp
  801a82:	85 ff                	test   %edi,%edi
  801a84:	75 0b                	jne    801a91 <__umoddi3+0xe9>
  801a86:	b8 01 00 00 00       	mov    $0x1,%eax
  801a8b:	31 d2                	xor    %edx,%edx
  801a8d:	f7 f7                	div    %edi
  801a8f:	89 c5                	mov    %eax,%ebp
  801a91:	89 f0                	mov    %esi,%eax
  801a93:	31 d2                	xor    %edx,%edx
  801a95:	f7 f5                	div    %ebp
  801a97:	89 c8                	mov    %ecx,%eax
  801a99:	f7 f5                	div    %ebp
  801a9b:	89 d0                	mov    %edx,%eax
  801a9d:	e9 44 ff ff ff       	jmp    8019e6 <__umoddi3+0x3e>
  801aa2:	66 90                	xchg   %ax,%ax
  801aa4:	89 c8                	mov    %ecx,%eax
  801aa6:	89 f2                	mov    %esi,%edx
  801aa8:	83 c4 1c             	add    $0x1c,%esp
  801aab:	5b                   	pop    %ebx
  801aac:	5e                   	pop    %esi
  801aad:	5f                   	pop    %edi
  801aae:	5d                   	pop    %ebp
  801aaf:	c3                   	ret    
  801ab0:	3b 04 24             	cmp    (%esp),%eax
  801ab3:	72 06                	jb     801abb <__umoddi3+0x113>
  801ab5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ab9:	77 0f                	ja     801aca <__umoddi3+0x122>
  801abb:	89 f2                	mov    %esi,%edx
  801abd:	29 f9                	sub    %edi,%ecx
  801abf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ac3:	89 14 24             	mov    %edx,(%esp)
  801ac6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801aca:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ace:	8b 14 24             	mov    (%esp),%edx
  801ad1:	83 c4 1c             	add    $0x1c,%esp
  801ad4:	5b                   	pop    %ebx
  801ad5:	5e                   	pop    %esi
  801ad6:	5f                   	pop    %edi
  801ad7:	5d                   	pop    %ebp
  801ad8:	c3                   	ret    
  801ad9:	8d 76 00             	lea    0x0(%esi),%esi
  801adc:	2b 04 24             	sub    (%esp),%eax
  801adf:	19 fa                	sbb    %edi,%edx
  801ae1:	89 d1                	mov    %edx,%ecx
  801ae3:	89 c6                	mov    %eax,%esi
  801ae5:	e9 71 ff ff ff       	jmp    801a5b <__umoddi3+0xb3>
  801aea:	66 90                	xchg   %ax,%ax
  801aec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801af0:	72 ea                	jb     801adc <__umoddi3+0x134>
  801af2:	89 d9                	mov    %ebx,%ecx
  801af4:	e9 62 ff ff ff       	jmp    801a5b <__umoddi3+0xb3>
