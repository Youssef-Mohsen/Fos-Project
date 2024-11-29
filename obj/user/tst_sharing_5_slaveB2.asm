
obj/user/tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 2c 01 00 00       	call   800162 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003e:	a1 20 50 80 00       	mov    0x805020,%eax
  800043:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  800049:	a1 20 50 80 00       	mov    0x805020,%eax
  80004e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800054:	39 c2                	cmp    %eax,%edx
  800056:	72 14                	jb     80006c <_main+0x34>
			panic("Please increase the WS size");
  800058:	83 ec 04             	sub    $0x4,%esp
  80005b:	68 00 3d 80 00       	push   $0x803d00
  800060:	6a 0c                	push   $0xc
  800062:	68 1c 3d 80 00       	push   $0x803d1c
  800067:	e8 35 02 00 00       	call   8002a1 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006c:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	z = sget(sys_getparentenvid(),"z");
  800073:	e8 a2 1b 00 00       	call   801c1a <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 39 3d 80 00       	push   $0x803d39
  800080:	50                   	push   %eax
  800081:	e8 b0 16 00 00       	call   801736 <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 3c 3d 80 00       	push   $0x803d3c
  800094:	e8 c5 04 00 00       	call   80055e <cprintf>
  800099:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got z
	inctst();
  80009c:	e8 9e 1c 00 00       	call   801d3f <inctst>

	cprintf("Slave B2 please be patient ...\n");
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	68 64 3d 80 00       	push   $0x803d64
  8000a9:	e8 b0 04 00 00       	call   80055e <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 28 23 00 00       	push   $0x2328
  8000b9:	e8 1c 39 00 00       	call   8039da <env_sleep>
  8000be:	83 c4 10             	add    $0x10,%esp
	//to ensure that the other environments completed successfully
	while (gettst()!=3) ;// panic("test failed");
  8000c1:	90                   	nop
  8000c2:	e8 92 1c 00 00       	call   801d59 <gettst>
  8000c7:	83 f8 03             	cmp    $0x3,%eax
  8000ca:	75 f6                	jne    8000c2 <_main+0x8a>

	freeFrames = sys_calculate_free_frames() ;
  8000cc:	e8 67 19 00 00       	call   801a38 <sys_calculate_free_frames>
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	sfree(z);
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000da:	e8 6a 17 00 00       	call   801849 <sfree>
  8000df:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 84 3d 80 00       	push   $0x803d84
  8000ea:	e8 6f 04 00 00       	call   80055e <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
	expected = 1+1; /*1page+1table*/
  8000f2:	c7 45 e8 02 00 00 00 	movl   $0x2,-0x18(%ebp)
	cprintf("diff 3: %d\n",sys_calculate_free_frames() - freeFrames);
  8000f9:	e8 3a 19 00 00       	call   801a38 <sys_calculate_free_frames>
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800103:	29 c2                	sub    %eax,%edx
  800105:	89 d0                	mov    %edx,%eax
  800107:	83 ec 08             	sub    $0x8,%esp
  80010a:	50                   	push   %eax
  80010b:	68 9c 3d 80 00       	push   $0x803d9c
  800110:	e8 49 04 00 00       	call   80055e <cprintf>
  800115:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  800118:	e8 1b 19 00 00       	call   801a38 <sys_calculate_free_frames>
  80011d:	89 c2                	mov    %eax,%edx
  80011f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800122:	29 c2                	sub    %eax,%edx
  800124:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800127:	39 c2                	cmp    %eax,%edx
  800129:	74 14                	je     80013f <_main+0x107>
  80012b:	83 ec 04             	sub    $0x4,%esp
  80012e:	68 a8 3d 80 00       	push   $0x803da8
  800133:	6a 29                	push   $0x29
  800135:	68 1c 3d 80 00       	push   $0x803d1c
  80013a:	e8 62 01 00 00       	call   8002a1 <_panic>


	cprintf("Step B completed successfully!!\n\n\n");
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 48 3e 80 00       	push   $0x803e48
  800147:	e8 12 04 00 00       	call   80055e <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n%~Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	68 6c 3e 80 00       	push   $0x803e6c
  800157:	e8 02 04 00 00       	call   80055e <cprintf>
  80015c:	83 c4 10             	add    $0x10,%esp

	return;
  80015f:	90                   	nop
}
  800160:	c9                   	leave  
  800161:	c3                   	ret    

00800162 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800162:	55                   	push   %ebp
  800163:	89 e5                	mov    %esp,%ebp
  800165:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800168:	e8 94 1a 00 00       	call   801c01 <sys_getenvindex>
  80016d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800170:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800173:	89 d0                	mov    %edx,%eax
  800175:	c1 e0 03             	shl    $0x3,%eax
  800178:	01 d0                	add    %edx,%eax
  80017a:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800181:	01 c8                	add    %ecx,%eax
  800183:	01 c0                	add    %eax,%eax
  800185:	01 d0                	add    %edx,%eax
  800187:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80018e:	01 c8                	add    %ecx,%eax
  800190:	01 d0                	add    %edx,%eax
  800192:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800197:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80019c:	a1 20 50 80 00       	mov    0x805020,%eax
  8001a1:	8a 40 20             	mov    0x20(%eax),%al
  8001a4:	84 c0                	test   %al,%al
  8001a6:	74 0d                	je     8001b5 <libmain+0x53>
		binaryname = myEnv->prog_name;
  8001a8:	a1 20 50 80 00       	mov    0x805020,%eax
  8001ad:	83 c0 20             	add    $0x20,%eax
  8001b0:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001b9:	7e 0a                	jle    8001c5 <libmain+0x63>
		binaryname = argv[0];
  8001bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001be:	8b 00                	mov    (%eax),%eax
  8001c0:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8001c5:	83 ec 08             	sub    $0x8,%esp
  8001c8:	ff 75 0c             	pushl  0xc(%ebp)
  8001cb:	ff 75 08             	pushl  0x8(%ebp)
  8001ce:	e8 65 fe ff ff       	call   800038 <_main>
  8001d3:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8001d6:	e8 aa 17 00 00       	call   801985 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001db:	83 ec 0c             	sub    $0xc,%esp
  8001de:	68 d4 3e 80 00       	push   $0x803ed4
  8001e3:	e8 76 03 00 00       	call   80055e <cprintf>
  8001e8:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001eb:	a1 20 50 80 00       	mov    0x805020,%eax
  8001f0:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8001f6:	a1 20 50 80 00       	mov    0x805020,%eax
  8001fb:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800201:	83 ec 04             	sub    $0x4,%esp
  800204:	52                   	push   %edx
  800205:	50                   	push   %eax
  800206:	68 fc 3e 80 00       	push   $0x803efc
  80020b:	e8 4e 03 00 00       	call   80055e <cprintf>
  800210:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800213:	a1 20 50 80 00       	mov    0x805020,%eax
  800218:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  80021e:	a1 20 50 80 00       	mov    0x805020,%eax
  800223:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  800229:	a1 20 50 80 00       	mov    0x805020,%eax
  80022e:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800234:	51                   	push   %ecx
  800235:	52                   	push   %edx
  800236:	50                   	push   %eax
  800237:	68 24 3f 80 00       	push   $0x803f24
  80023c:	e8 1d 03 00 00       	call   80055e <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800244:	a1 20 50 80 00       	mov    0x805020,%eax
  800249:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80024f:	83 ec 08             	sub    $0x8,%esp
  800252:	50                   	push   %eax
  800253:	68 7c 3f 80 00       	push   $0x803f7c
  800258:	e8 01 03 00 00       	call   80055e <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	68 d4 3e 80 00       	push   $0x803ed4
  800268:	e8 f1 02 00 00       	call   80055e <cprintf>
  80026d:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800270:	e8 2a 17 00 00       	call   80199f <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800275:	e8 19 00 00 00       	call   800293 <exit>
}
  80027a:	90                   	nop
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800283:	83 ec 0c             	sub    $0xc,%esp
  800286:	6a 00                	push   $0x0
  800288:	e8 40 19 00 00       	call   801bcd <sys_destroy_env>
  80028d:	83 c4 10             	add    $0x10,%esp
}
  800290:	90                   	nop
  800291:	c9                   	leave  
  800292:	c3                   	ret    

00800293 <exit>:

void
exit(void)
{
  800293:	55                   	push   %ebp
  800294:	89 e5                	mov    %esp,%ebp
  800296:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800299:	e8 95 19 00 00       	call   801c33 <sys_exit_env>
}
  80029e:	90                   	nop
  80029f:	c9                   	leave  
  8002a0:	c3                   	ret    

008002a1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002a7:	8d 45 10             	lea    0x10(%ebp),%eax
  8002aa:	83 c0 04             	add    $0x4,%eax
  8002ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002b0:	a1 50 50 80 00       	mov    0x805050,%eax
  8002b5:	85 c0                	test   %eax,%eax
  8002b7:	74 16                	je     8002cf <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002b9:	a1 50 50 80 00       	mov    0x805050,%eax
  8002be:	83 ec 08             	sub    $0x8,%esp
  8002c1:	50                   	push   %eax
  8002c2:	68 90 3f 80 00       	push   $0x803f90
  8002c7:	e8 92 02 00 00       	call   80055e <cprintf>
  8002cc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002cf:	a1 00 50 80 00       	mov    0x805000,%eax
  8002d4:	ff 75 0c             	pushl  0xc(%ebp)
  8002d7:	ff 75 08             	pushl  0x8(%ebp)
  8002da:	50                   	push   %eax
  8002db:	68 95 3f 80 00       	push   $0x803f95
  8002e0:	e8 79 02 00 00       	call   80055e <cprintf>
  8002e5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8002eb:	83 ec 08             	sub    $0x8,%esp
  8002ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f1:	50                   	push   %eax
  8002f2:	e8 fc 01 00 00       	call   8004f3 <vcprintf>
  8002f7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002fa:	83 ec 08             	sub    $0x8,%esp
  8002fd:	6a 00                	push   $0x0
  8002ff:	68 b1 3f 80 00       	push   $0x803fb1
  800304:	e8 ea 01 00 00       	call   8004f3 <vcprintf>
  800309:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80030c:	e8 82 ff ff ff       	call   800293 <exit>

	// should not return here
	while (1) ;
  800311:	eb fe                	jmp    800311 <_panic+0x70>

00800313 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800319:	a1 20 50 80 00       	mov    0x805020,%eax
  80031e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800324:	8b 45 0c             	mov    0xc(%ebp),%eax
  800327:	39 c2                	cmp    %eax,%edx
  800329:	74 14                	je     80033f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80032b:	83 ec 04             	sub    $0x4,%esp
  80032e:	68 b4 3f 80 00       	push   $0x803fb4
  800333:	6a 26                	push   $0x26
  800335:	68 00 40 80 00       	push   $0x804000
  80033a:	e8 62 ff ff ff       	call   8002a1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80033f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800346:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80034d:	e9 c5 00 00 00       	jmp    800417 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800352:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800355:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80035c:	8b 45 08             	mov    0x8(%ebp),%eax
  80035f:	01 d0                	add    %edx,%eax
  800361:	8b 00                	mov    (%eax),%eax
  800363:	85 c0                	test   %eax,%eax
  800365:	75 08                	jne    80036f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800367:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80036a:	e9 a5 00 00 00       	jmp    800414 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80036f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800376:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80037d:	eb 69                	jmp    8003e8 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80037f:	a1 20 50 80 00       	mov    0x805020,%eax
  800384:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80038a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80038d:	89 d0                	mov    %edx,%eax
  80038f:	01 c0                	add    %eax,%eax
  800391:	01 d0                	add    %edx,%eax
  800393:	c1 e0 03             	shl    $0x3,%eax
  800396:	01 c8                	add    %ecx,%eax
  800398:	8a 40 04             	mov    0x4(%eax),%al
  80039b:	84 c0                	test   %al,%al
  80039d:	75 46                	jne    8003e5 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80039f:	a1 20 50 80 00       	mov    0x805020,%eax
  8003a4:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8003aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003ad:	89 d0                	mov    %edx,%eax
  8003af:	01 c0                	add    %eax,%eax
  8003b1:	01 d0                	add    %edx,%eax
  8003b3:	c1 e0 03             	shl    $0x3,%eax
  8003b6:	01 c8                	add    %ecx,%eax
  8003b8:	8b 00                	mov    (%eax),%eax
  8003ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003c5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d4:	01 c8                	add    %ecx,%eax
  8003d6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003d8:	39 c2                	cmp    %eax,%edx
  8003da:	75 09                	jne    8003e5 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003dc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003e3:	eb 15                	jmp    8003fa <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e5:	ff 45 e8             	incl   -0x18(%ebp)
  8003e8:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ed:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8003f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003f6:	39 c2                	cmp    %eax,%edx
  8003f8:	77 85                	ja     80037f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003fe:	75 14                	jne    800414 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	68 0c 40 80 00       	push   $0x80400c
  800408:	6a 3a                	push   $0x3a
  80040a:	68 00 40 80 00       	push   $0x804000
  80040f:	e8 8d fe ff ff       	call   8002a1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800414:	ff 45 f0             	incl   -0x10(%ebp)
  800417:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80041a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041d:	0f 8c 2f ff ff ff    	jl     800352 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800423:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800431:	eb 26                	jmp    800459 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800433:	a1 20 50 80 00       	mov    0x805020,%eax
  800438:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80043e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800441:	89 d0                	mov    %edx,%eax
  800443:	01 c0                	add    %eax,%eax
  800445:	01 d0                	add    %edx,%eax
  800447:	c1 e0 03             	shl    $0x3,%eax
  80044a:	01 c8                	add    %ecx,%eax
  80044c:	8a 40 04             	mov    0x4(%eax),%al
  80044f:	3c 01                	cmp    $0x1,%al
  800451:	75 03                	jne    800456 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800453:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800456:	ff 45 e0             	incl   -0x20(%ebp)
  800459:	a1 20 50 80 00       	mov    0x805020,%eax
  80045e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800464:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800467:	39 c2                	cmp    %eax,%edx
  800469:	77 c8                	ja     800433 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80046b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80046e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800471:	74 14                	je     800487 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800473:	83 ec 04             	sub    $0x4,%esp
  800476:	68 60 40 80 00       	push   $0x804060
  80047b:	6a 44                	push   $0x44
  80047d:	68 00 40 80 00       	push   $0x804000
  800482:	e8 1a fe ff ff       	call   8002a1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800487:	90                   	nop
  800488:	c9                   	leave  
  800489:	c3                   	ret    

0080048a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80048a:	55                   	push   %ebp
  80048b:	89 e5                	mov    %esp,%ebp
  80048d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800490:	8b 45 0c             	mov    0xc(%ebp),%eax
  800493:	8b 00                	mov    (%eax),%eax
  800495:	8d 48 01             	lea    0x1(%eax),%ecx
  800498:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049b:	89 0a                	mov    %ecx,(%edx)
  80049d:	8b 55 08             	mov    0x8(%ebp),%edx
  8004a0:	88 d1                	mov    %dl,%cl
  8004a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ac:	8b 00                	mov    (%eax),%eax
  8004ae:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004b3:	75 2c                	jne    8004e1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004b5:	a0 2c 50 80 00       	mov    0x80502c,%al
  8004ba:	0f b6 c0             	movzbl %al,%eax
  8004bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c0:	8b 12                	mov    (%edx),%edx
  8004c2:	89 d1                	mov    %edx,%ecx
  8004c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c7:	83 c2 08             	add    $0x8,%edx
  8004ca:	83 ec 04             	sub    $0x4,%esp
  8004cd:	50                   	push   %eax
  8004ce:	51                   	push   %ecx
  8004cf:	52                   	push   %edx
  8004d0:	e8 6e 14 00 00       	call   801943 <sys_cputs>
  8004d5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e4:	8b 40 04             	mov    0x4(%eax),%eax
  8004e7:	8d 50 01             	lea    0x1(%eax),%edx
  8004ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ed:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004f0:	90                   	nop
  8004f1:	c9                   	leave  
  8004f2:	c3                   	ret    

008004f3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004f3:	55                   	push   %ebp
  8004f4:	89 e5                	mov    %esp,%ebp
  8004f6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004fc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800503:	00 00 00 
	b.cnt = 0;
  800506:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80050d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800510:	ff 75 0c             	pushl  0xc(%ebp)
  800513:	ff 75 08             	pushl  0x8(%ebp)
  800516:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80051c:	50                   	push   %eax
  80051d:	68 8a 04 80 00       	push   $0x80048a
  800522:	e8 11 02 00 00       	call   800738 <vprintfmt>
  800527:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80052a:	a0 2c 50 80 00       	mov    0x80502c,%al
  80052f:	0f b6 c0             	movzbl %al,%eax
  800532:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800538:	83 ec 04             	sub    $0x4,%esp
  80053b:	50                   	push   %eax
  80053c:	52                   	push   %edx
  80053d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800543:	83 c0 08             	add    $0x8,%eax
  800546:	50                   	push   %eax
  800547:	e8 f7 13 00 00       	call   801943 <sys_cputs>
  80054c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80054f:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
	return b.cnt;
  800556:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    

0080055e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800564:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
	va_start(ap, fmt);
  80056b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	ff 75 f4             	pushl  -0xc(%ebp)
  80057a:	50                   	push   %eax
  80057b:	e8 73 ff ff ff       	call   8004f3 <vcprintf>
  800580:	83 c4 10             	add    $0x10,%esp
  800583:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800586:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800589:	c9                   	leave  
  80058a:	c3                   	ret    

0080058b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80058b:	55                   	push   %ebp
  80058c:	89 e5                	mov    %esp,%ebp
  80058e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800591:	e8 ef 13 00 00       	call   801985 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800596:	8d 45 0c             	lea    0xc(%ebp),%eax
  800599:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80059c:	8b 45 08             	mov    0x8(%ebp),%eax
  80059f:	83 ec 08             	sub    $0x8,%esp
  8005a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a5:	50                   	push   %eax
  8005a6:	e8 48 ff ff ff       	call   8004f3 <vcprintf>
  8005ab:	83 c4 10             	add    $0x10,%esp
  8005ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005b1:	e8 e9 13 00 00       	call   80199f <sys_unlock_cons>
	return cnt;
  8005b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005b9:	c9                   	leave  
  8005ba:	c3                   	ret    

008005bb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005bb:	55                   	push   %ebp
  8005bc:	89 e5                	mov    %esp,%ebp
  8005be:	53                   	push   %ebx
  8005bf:	83 ec 14             	sub    $0x14,%esp
  8005c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005ce:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005d9:	77 55                	ja     800630 <printnum+0x75>
  8005db:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005de:	72 05                	jb     8005e5 <printnum+0x2a>
  8005e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005e3:	77 4b                	ja     800630 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005e5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005e8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8005ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f3:	52                   	push   %edx
  8005f4:	50                   	push   %eax
  8005f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8005fb:	e8 90 34 00 00       	call   803a90 <__udivdi3>
  800600:	83 c4 10             	add    $0x10,%esp
  800603:	83 ec 04             	sub    $0x4,%esp
  800606:	ff 75 20             	pushl  0x20(%ebp)
  800609:	53                   	push   %ebx
  80060a:	ff 75 18             	pushl  0x18(%ebp)
  80060d:	52                   	push   %edx
  80060e:	50                   	push   %eax
  80060f:	ff 75 0c             	pushl  0xc(%ebp)
  800612:	ff 75 08             	pushl  0x8(%ebp)
  800615:	e8 a1 ff ff ff       	call   8005bb <printnum>
  80061a:	83 c4 20             	add    $0x20,%esp
  80061d:	eb 1a                	jmp    800639 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	ff 75 0c             	pushl  0xc(%ebp)
  800625:	ff 75 20             	pushl  0x20(%ebp)
  800628:	8b 45 08             	mov    0x8(%ebp),%eax
  80062b:	ff d0                	call   *%eax
  80062d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800630:	ff 4d 1c             	decl   0x1c(%ebp)
  800633:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800637:	7f e6                	jg     80061f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800639:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80063c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800644:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800647:	53                   	push   %ebx
  800648:	51                   	push   %ecx
  800649:	52                   	push   %edx
  80064a:	50                   	push   %eax
  80064b:	e8 50 35 00 00       	call   803ba0 <__umoddi3>
  800650:	83 c4 10             	add    $0x10,%esp
  800653:	05 d4 42 80 00       	add    $0x8042d4,%eax
  800658:	8a 00                	mov    (%eax),%al
  80065a:	0f be c0             	movsbl %al,%eax
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	ff 75 0c             	pushl  0xc(%ebp)
  800663:	50                   	push   %eax
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	ff d0                	call   *%eax
  800669:	83 c4 10             	add    $0x10,%esp
}
  80066c:	90                   	nop
  80066d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800670:	c9                   	leave  
  800671:	c3                   	ret    

00800672 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800672:	55                   	push   %ebp
  800673:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800675:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800679:	7e 1c                	jle    800697 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80067b:	8b 45 08             	mov    0x8(%ebp),%eax
  80067e:	8b 00                	mov    (%eax),%eax
  800680:	8d 50 08             	lea    0x8(%eax),%edx
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	89 10                	mov    %edx,(%eax)
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	83 e8 08             	sub    $0x8,%eax
  800690:	8b 50 04             	mov    0x4(%eax),%edx
  800693:	8b 00                	mov    (%eax),%eax
  800695:	eb 40                	jmp    8006d7 <getuint+0x65>
	else if (lflag)
  800697:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80069b:	74 1e                	je     8006bb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80069d:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	8d 50 04             	lea    0x4(%eax),%edx
  8006a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a8:	89 10                	mov    %edx,(%eax)
  8006aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	83 e8 04             	sub    $0x4,%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b9:	eb 1c                	jmp    8006d7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	8d 50 04             	lea    0x4(%eax),%edx
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	89 10                	mov    %edx,(%eax)
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	83 e8 04             	sub    $0x4,%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006d7:	5d                   	pop    %ebp
  8006d8:	c3                   	ret    

008006d9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006d9:	55                   	push   %ebp
  8006da:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006dc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e0:	7e 1c                	jle    8006fe <getint+0x25>
		return va_arg(*ap, long long);
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	8d 50 08             	lea    0x8(%eax),%edx
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	89 10                	mov    %edx,(%eax)
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	83 e8 08             	sub    $0x8,%eax
  8006f7:	8b 50 04             	mov    0x4(%eax),%edx
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	eb 38                	jmp    800736 <getint+0x5d>
	else if (lflag)
  8006fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800702:	74 1a                	je     80071e <getint+0x45>
		return va_arg(*ap, long);
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	8d 50 04             	lea    0x4(%eax),%edx
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	89 10                	mov    %edx,(%eax)
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	83 e8 04             	sub    $0x4,%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	99                   	cltd   
  80071c:	eb 18                	jmp    800736 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	8b 00                	mov    (%eax),%eax
  800723:	8d 50 04             	lea    0x4(%eax),%edx
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	89 10                	mov    %edx,(%eax)
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	83 e8 04             	sub    $0x4,%eax
  800733:	8b 00                	mov    (%eax),%eax
  800735:	99                   	cltd   
}
  800736:	5d                   	pop    %ebp
  800737:	c3                   	ret    

00800738 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800738:	55                   	push   %ebp
  800739:	89 e5                	mov    %esp,%ebp
  80073b:	56                   	push   %esi
  80073c:	53                   	push   %ebx
  80073d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800740:	eb 17                	jmp    800759 <vprintfmt+0x21>
			if (ch == '\0')
  800742:	85 db                	test   %ebx,%ebx
  800744:	0f 84 c1 03 00 00    	je     800b0b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	ff 75 0c             	pushl  0xc(%ebp)
  800750:	53                   	push   %ebx
  800751:	8b 45 08             	mov    0x8(%ebp),%eax
  800754:	ff d0                	call   *%eax
  800756:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800759:	8b 45 10             	mov    0x10(%ebp),%eax
  80075c:	8d 50 01             	lea    0x1(%eax),%edx
  80075f:	89 55 10             	mov    %edx,0x10(%ebp)
  800762:	8a 00                	mov    (%eax),%al
  800764:	0f b6 d8             	movzbl %al,%ebx
  800767:	83 fb 25             	cmp    $0x25,%ebx
  80076a:	75 d6                	jne    800742 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80076c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800770:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800777:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80077e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800785:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80078c:	8b 45 10             	mov    0x10(%ebp),%eax
  80078f:	8d 50 01             	lea    0x1(%eax),%edx
  800792:	89 55 10             	mov    %edx,0x10(%ebp)
  800795:	8a 00                	mov    (%eax),%al
  800797:	0f b6 d8             	movzbl %al,%ebx
  80079a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80079d:	83 f8 5b             	cmp    $0x5b,%eax
  8007a0:	0f 87 3d 03 00 00    	ja     800ae3 <vprintfmt+0x3ab>
  8007a6:	8b 04 85 f8 42 80 00 	mov    0x8042f8(,%eax,4),%eax
  8007ad:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007af:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007b3:	eb d7                	jmp    80078c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007b5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007b9:	eb d1                	jmp    80078c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007c5:	89 d0                	mov    %edx,%eax
  8007c7:	c1 e0 02             	shl    $0x2,%eax
  8007ca:	01 d0                	add    %edx,%eax
  8007cc:	01 c0                	add    %eax,%eax
  8007ce:	01 d8                	add    %ebx,%eax
  8007d0:	83 e8 30             	sub    $0x30,%eax
  8007d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d9:	8a 00                	mov    (%eax),%al
  8007db:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007de:	83 fb 2f             	cmp    $0x2f,%ebx
  8007e1:	7e 3e                	jle    800821 <vprintfmt+0xe9>
  8007e3:	83 fb 39             	cmp    $0x39,%ebx
  8007e6:	7f 39                	jg     800821 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007e8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007eb:	eb d5                	jmp    8007c2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f0:	83 c0 04             	add    $0x4,%eax
  8007f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f9:	83 e8 04             	sub    $0x4,%eax
  8007fc:	8b 00                	mov    (%eax),%eax
  8007fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800801:	eb 1f                	jmp    800822 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800803:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800807:	79 83                	jns    80078c <vprintfmt+0x54>
				width = 0;
  800809:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800810:	e9 77 ff ff ff       	jmp    80078c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800815:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80081c:	e9 6b ff ff ff       	jmp    80078c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800821:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800822:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800826:	0f 89 60 ff ff ff    	jns    80078c <vprintfmt+0x54>
				width = precision, precision = -1;
  80082c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80082f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800832:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800839:	e9 4e ff ff ff       	jmp    80078c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80083e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800841:	e9 46 ff ff ff       	jmp    80078c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	83 c0 04             	add    $0x4,%eax
  80084c:	89 45 14             	mov    %eax,0x14(%ebp)
  80084f:	8b 45 14             	mov    0x14(%ebp),%eax
  800852:	83 e8 04             	sub    $0x4,%eax
  800855:	8b 00                	mov    (%eax),%eax
  800857:	83 ec 08             	sub    $0x8,%esp
  80085a:	ff 75 0c             	pushl  0xc(%ebp)
  80085d:	50                   	push   %eax
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	ff d0                	call   *%eax
  800863:	83 c4 10             	add    $0x10,%esp
			break;
  800866:	e9 9b 02 00 00       	jmp    800b06 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	83 c0 04             	add    $0x4,%eax
  800871:	89 45 14             	mov    %eax,0x14(%ebp)
  800874:	8b 45 14             	mov    0x14(%ebp),%eax
  800877:	83 e8 04             	sub    $0x4,%eax
  80087a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80087c:	85 db                	test   %ebx,%ebx
  80087e:	79 02                	jns    800882 <vprintfmt+0x14a>
				err = -err;
  800880:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800882:	83 fb 64             	cmp    $0x64,%ebx
  800885:	7f 0b                	jg     800892 <vprintfmt+0x15a>
  800887:	8b 34 9d 40 41 80 00 	mov    0x804140(,%ebx,4),%esi
  80088e:	85 f6                	test   %esi,%esi
  800890:	75 19                	jne    8008ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800892:	53                   	push   %ebx
  800893:	68 e5 42 80 00       	push   $0x8042e5
  800898:	ff 75 0c             	pushl  0xc(%ebp)
  80089b:	ff 75 08             	pushl  0x8(%ebp)
  80089e:	e8 70 02 00 00       	call   800b13 <printfmt>
  8008a3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008a6:	e9 5b 02 00 00       	jmp    800b06 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008ab:	56                   	push   %esi
  8008ac:	68 ee 42 80 00       	push   $0x8042ee
  8008b1:	ff 75 0c             	pushl  0xc(%ebp)
  8008b4:	ff 75 08             	pushl  0x8(%ebp)
  8008b7:	e8 57 02 00 00       	call   800b13 <printfmt>
  8008bc:	83 c4 10             	add    $0x10,%esp
			break;
  8008bf:	e9 42 02 00 00       	jmp    800b06 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c7:	83 c0 04             	add    $0x4,%eax
  8008ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	83 e8 04             	sub    $0x4,%eax
  8008d3:	8b 30                	mov    (%eax),%esi
  8008d5:	85 f6                	test   %esi,%esi
  8008d7:	75 05                	jne    8008de <vprintfmt+0x1a6>
				p = "(null)";
  8008d9:	be f1 42 80 00       	mov    $0x8042f1,%esi
			if (width > 0 && padc != '-')
  8008de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e2:	7e 6d                	jle    800951 <vprintfmt+0x219>
  8008e4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008e8:	74 67                	je     800951 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ed:	83 ec 08             	sub    $0x8,%esp
  8008f0:	50                   	push   %eax
  8008f1:	56                   	push   %esi
  8008f2:	e8 1e 03 00 00       	call   800c15 <strnlen>
  8008f7:	83 c4 10             	add    $0x10,%esp
  8008fa:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008fd:	eb 16                	jmp    800915 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008ff:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800903:	83 ec 08             	sub    $0x8,%esp
  800906:	ff 75 0c             	pushl  0xc(%ebp)
  800909:	50                   	push   %eax
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	ff d0                	call   *%eax
  80090f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800912:	ff 4d e4             	decl   -0x1c(%ebp)
  800915:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800919:	7f e4                	jg     8008ff <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80091b:	eb 34                	jmp    800951 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80091d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800921:	74 1c                	je     80093f <vprintfmt+0x207>
  800923:	83 fb 1f             	cmp    $0x1f,%ebx
  800926:	7e 05                	jle    80092d <vprintfmt+0x1f5>
  800928:	83 fb 7e             	cmp    $0x7e,%ebx
  80092b:	7e 12                	jle    80093f <vprintfmt+0x207>
					putch('?', putdat);
  80092d:	83 ec 08             	sub    $0x8,%esp
  800930:	ff 75 0c             	pushl  0xc(%ebp)
  800933:	6a 3f                	push   $0x3f
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	ff d0                	call   *%eax
  80093a:	83 c4 10             	add    $0x10,%esp
  80093d:	eb 0f                	jmp    80094e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80093f:	83 ec 08             	sub    $0x8,%esp
  800942:	ff 75 0c             	pushl  0xc(%ebp)
  800945:	53                   	push   %ebx
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	ff d0                	call   *%eax
  80094b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80094e:	ff 4d e4             	decl   -0x1c(%ebp)
  800951:	89 f0                	mov    %esi,%eax
  800953:	8d 70 01             	lea    0x1(%eax),%esi
  800956:	8a 00                	mov    (%eax),%al
  800958:	0f be d8             	movsbl %al,%ebx
  80095b:	85 db                	test   %ebx,%ebx
  80095d:	74 24                	je     800983 <vprintfmt+0x24b>
  80095f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800963:	78 b8                	js     80091d <vprintfmt+0x1e5>
  800965:	ff 4d e0             	decl   -0x20(%ebp)
  800968:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096c:	79 af                	jns    80091d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80096e:	eb 13                	jmp    800983 <vprintfmt+0x24b>
				putch(' ', putdat);
  800970:	83 ec 08             	sub    $0x8,%esp
  800973:	ff 75 0c             	pushl  0xc(%ebp)
  800976:	6a 20                	push   $0x20
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	ff d0                	call   *%eax
  80097d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800980:	ff 4d e4             	decl   -0x1c(%ebp)
  800983:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800987:	7f e7                	jg     800970 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800989:	e9 78 01 00 00       	jmp    800b06 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80098e:	83 ec 08             	sub    $0x8,%esp
  800991:	ff 75 e8             	pushl  -0x18(%ebp)
  800994:	8d 45 14             	lea    0x14(%ebp),%eax
  800997:	50                   	push   %eax
  800998:	e8 3c fd ff ff       	call   8006d9 <getint>
  80099d:	83 c4 10             	add    $0x10,%esp
  8009a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ac:	85 d2                	test   %edx,%edx
  8009ae:	79 23                	jns    8009d3 <vprintfmt+0x29b>
				putch('-', putdat);
  8009b0:	83 ec 08             	sub    $0x8,%esp
  8009b3:	ff 75 0c             	pushl  0xc(%ebp)
  8009b6:	6a 2d                	push   $0x2d
  8009b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bb:	ff d0                	call   *%eax
  8009bd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009c6:	f7 d8                	neg    %eax
  8009c8:	83 d2 00             	adc    $0x0,%edx
  8009cb:	f7 da                	neg    %edx
  8009cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009d3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009da:	e9 bc 00 00 00       	jmp    800a9b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009df:	83 ec 08             	sub    $0x8,%esp
  8009e2:	ff 75 e8             	pushl  -0x18(%ebp)
  8009e5:	8d 45 14             	lea    0x14(%ebp),%eax
  8009e8:	50                   	push   %eax
  8009e9:	e8 84 fc ff ff       	call   800672 <getuint>
  8009ee:	83 c4 10             	add    $0x10,%esp
  8009f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009fe:	e9 98 00 00 00       	jmp    800a9b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	ff 75 0c             	pushl  0xc(%ebp)
  800a09:	6a 58                	push   $0x58
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	ff d0                	call   *%eax
  800a10:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 0c             	pushl  0xc(%ebp)
  800a19:	6a 58                	push   $0x58
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	ff d0                	call   *%eax
  800a20:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	ff 75 0c             	pushl  0xc(%ebp)
  800a29:	6a 58                	push   $0x58
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	ff d0                	call   *%eax
  800a30:	83 c4 10             	add    $0x10,%esp
			break;
  800a33:	e9 ce 00 00 00       	jmp    800b06 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a38:	83 ec 08             	sub    $0x8,%esp
  800a3b:	ff 75 0c             	pushl  0xc(%ebp)
  800a3e:	6a 30                	push   $0x30
  800a40:	8b 45 08             	mov    0x8(%ebp),%eax
  800a43:	ff d0                	call   *%eax
  800a45:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a48:	83 ec 08             	sub    $0x8,%esp
  800a4b:	ff 75 0c             	pushl  0xc(%ebp)
  800a4e:	6a 78                	push   $0x78
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	ff d0                	call   *%eax
  800a55:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a58:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5b:	83 c0 04             	add    $0x4,%eax
  800a5e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a61:	8b 45 14             	mov    0x14(%ebp),%eax
  800a64:	83 e8 04             	sub    $0x4,%eax
  800a67:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a73:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a7a:	eb 1f                	jmp    800a9b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a7c:	83 ec 08             	sub    $0x8,%esp
  800a7f:	ff 75 e8             	pushl  -0x18(%ebp)
  800a82:	8d 45 14             	lea    0x14(%ebp),%eax
  800a85:	50                   	push   %eax
  800a86:	e8 e7 fb ff ff       	call   800672 <getuint>
  800a8b:	83 c4 10             	add    $0x10,%esp
  800a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a91:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a94:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a9b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa2:	83 ec 04             	sub    $0x4,%esp
  800aa5:	52                   	push   %edx
  800aa6:	ff 75 e4             	pushl  -0x1c(%ebp)
  800aa9:	50                   	push   %eax
  800aaa:	ff 75 f4             	pushl  -0xc(%ebp)
  800aad:	ff 75 f0             	pushl  -0x10(%ebp)
  800ab0:	ff 75 0c             	pushl  0xc(%ebp)
  800ab3:	ff 75 08             	pushl  0x8(%ebp)
  800ab6:	e8 00 fb ff ff       	call   8005bb <printnum>
  800abb:	83 c4 20             	add    $0x20,%esp
			break;
  800abe:	eb 46                	jmp    800b06 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ac0:	83 ec 08             	sub    $0x8,%esp
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	53                   	push   %ebx
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aca:	ff d0                	call   *%eax
  800acc:	83 c4 10             	add    $0x10,%esp
			break;
  800acf:	eb 35                	jmp    800b06 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ad1:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  800ad8:	eb 2c                	jmp    800b06 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ada:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
			break;
  800ae1:	eb 23                	jmp    800b06 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ae3:	83 ec 08             	sub    $0x8,%esp
  800ae6:	ff 75 0c             	pushl  0xc(%ebp)
  800ae9:	6a 25                	push   $0x25
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	ff d0                	call   *%eax
  800af0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800af3:	ff 4d 10             	decl   0x10(%ebp)
  800af6:	eb 03                	jmp    800afb <vprintfmt+0x3c3>
  800af8:	ff 4d 10             	decl   0x10(%ebp)
  800afb:	8b 45 10             	mov    0x10(%ebp),%eax
  800afe:	48                   	dec    %eax
  800aff:	8a 00                	mov    (%eax),%al
  800b01:	3c 25                	cmp    $0x25,%al
  800b03:	75 f3                	jne    800af8 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b05:	90                   	nop
		}
	}
  800b06:	e9 35 fc ff ff       	jmp    800740 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b0b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b0f:	5b                   	pop    %ebx
  800b10:	5e                   	pop    %esi
  800b11:	5d                   	pop    %ebp
  800b12:	c3                   	ret    

00800b13 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
  800b16:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b19:	8d 45 10             	lea    0x10(%ebp),%eax
  800b1c:	83 c0 04             	add    $0x4,%eax
  800b1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b22:	8b 45 10             	mov    0x10(%ebp),%eax
  800b25:	ff 75 f4             	pushl  -0xc(%ebp)
  800b28:	50                   	push   %eax
  800b29:	ff 75 0c             	pushl  0xc(%ebp)
  800b2c:	ff 75 08             	pushl  0x8(%ebp)
  800b2f:	e8 04 fc ff ff       	call   800738 <vprintfmt>
  800b34:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b37:	90                   	nop
  800b38:	c9                   	leave  
  800b39:	c3                   	ret    

00800b3a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b3a:	55                   	push   %ebp
  800b3b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b40:	8b 40 08             	mov    0x8(%eax),%eax
  800b43:	8d 50 01             	lea    0x1(%eax),%edx
  800b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b49:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4f:	8b 10                	mov    (%eax),%edx
  800b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b54:	8b 40 04             	mov    0x4(%eax),%eax
  800b57:	39 c2                	cmp    %eax,%edx
  800b59:	73 12                	jae    800b6d <sprintputch+0x33>
		*b->buf++ = ch;
  800b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5e:	8b 00                	mov    (%eax),%eax
  800b60:	8d 48 01             	lea    0x1(%eax),%ecx
  800b63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b66:	89 0a                	mov    %ecx,(%edx)
  800b68:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6b:	88 10                	mov    %dl,(%eax)
}
  800b6d:	90                   	nop
  800b6e:	5d                   	pop    %ebp
  800b6f:	c3                   	ret    

00800b70 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	01 d0                	add    %edx,%eax
  800b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b95:	74 06                	je     800b9d <vsnprintf+0x2d>
  800b97:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9b:	7f 07                	jg     800ba4 <vsnprintf+0x34>
		return -E_INVAL;
  800b9d:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba2:	eb 20                	jmp    800bc4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ba4:	ff 75 14             	pushl  0x14(%ebp)
  800ba7:	ff 75 10             	pushl  0x10(%ebp)
  800baa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bad:	50                   	push   %eax
  800bae:	68 3a 0b 80 00       	push   $0x800b3a
  800bb3:	e8 80 fb ff ff       	call   800738 <vprintfmt>
  800bb8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bbe:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bc4:	c9                   	leave  
  800bc5:	c3                   	ret    

00800bc6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bcc:	8d 45 10             	lea    0x10(%ebp),%eax
  800bcf:	83 c0 04             	add    $0x4,%eax
  800bd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd8:	ff 75 f4             	pushl  -0xc(%ebp)
  800bdb:	50                   	push   %eax
  800bdc:	ff 75 0c             	pushl  0xc(%ebp)
  800bdf:	ff 75 08             	pushl  0x8(%ebp)
  800be2:	e8 89 ff ff ff       	call   800b70 <vsnprintf>
  800be7:	83 c4 10             	add    $0x10,%esp
  800bea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bf0:	c9                   	leave  
  800bf1:	c3                   	ret    

00800bf2 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800bf2:	55                   	push   %ebp
  800bf3:	89 e5                	mov    %esp,%ebp
  800bf5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bff:	eb 06                	jmp    800c07 <strlen+0x15>
		n++;
  800c01:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c04:	ff 45 08             	incl   0x8(%ebp)
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	8a 00                	mov    (%eax),%al
  800c0c:	84 c0                	test   %al,%al
  800c0e:	75 f1                	jne    800c01 <strlen+0xf>
		n++;
	return n;
  800c10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c13:	c9                   	leave  
  800c14:	c3                   	ret    

00800c15 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c22:	eb 09                	jmp    800c2d <strnlen+0x18>
		n++;
  800c24:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c27:	ff 45 08             	incl   0x8(%ebp)
  800c2a:	ff 4d 0c             	decl   0xc(%ebp)
  800c2d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c31:	74 09                	je     800c3c <strnlen+0x27>
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	8a 00                	mov    (%eax),%al
  800c38:	84 c0                	test   %al,%al
  800c3a:	75 e8                	jne    800c24 <strnlen+0xf>
		n++;
	return n;
  800c3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c3f:	c9                   	leave  
  800c40:	c3                   	ret    

00800c41 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c41:	55                   	push   %ebp
  800c42:	89 e5                	mov    %esp,%ebp
  800c44:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c4d:	90                   	nop
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	8d 50 01             	lea    0x1(%eax),%edx
  800c54:	89 55 08             	mov    %edx,0x8(%ebp)
  800c57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c5d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c60:	8a 12                	mov    (%edx),%dl
  800c62:	88 10                	mov    %dl,(%eax)
  800c64:	8a 00                	mov    (%eax),%al
  800c66:	84 c0                	test   %al,%al
  800c68:	75 e4                	jne    800c4e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6d:	c9                   	leave  
  800c6e:	c3                   	ret    

00800c6f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c7b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c82:	eb 1f                	jmp    800ca3 <strncpy+0x34>
		*dst++ = *src;
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	8d 50 01             	lea    0x1(%eax),%edx
  800c8a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c90:	8a 12                	mov    (%edx),%dl
  800c92:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c97:	8a 00                	mov    (%eax),%al
  800c99:	84 c0                	test   %al,%al
  800c9b:	74 03                	je     800ca0 <strncpy+0x31>
			src++;
  800c9d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ca0:	ff 45 fc             	incl   -0x4(%ebp)
  800ca3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ca9:	72 d9                	jb     800c84 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cab:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cae:	c9                   	leave  
  800caf:	c3                   	ret    

00800cb0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cbc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc0:	74 30                	je     800cf2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cc2:	eb 16                	jmp    800cda <strlcpy+0x2a>
			*dst++ = *src++;
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8d 50 01             	lea    0x1(%eax),%edx
  800cca:	89 55 08             	mov    %edx,0x8(%ebp)
  800ccd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd6:	8a 12                	mov    (%edx),%dl
  800cd8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cda:	ff 4d 10             	decl   0x10(%ebp)
  800cdd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce1:	74 09                	je     800cec <strlcpy+0x3c>
  800ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	84 c0                	test   %al,%al
  800cea:	75 d8                	jne    800cc4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cf2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf8:	29 c2                	sub    %eax,%edx
  800cfa:	89 d0                	mov    %edx,%eax
}
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d01:	eb 06                	jmp    800d09 <strcmp+0xb>
		p++, q++;
  800d03:	ff 45 08             	incl   0x8(%ebp)
  800d06:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	8a 00                	mov    (%eax),%al
  800d0e:	84 c0                	test   %al,%al
  800d10:	74 0e                	je     800d20 <strcmp+0x22>
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	8a 10                	mov    (%eax),%dl
  800d17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1a:	8a 00                	mov    (%eax),%al
  800d1c:	38 c2                	cmp    %al,%dl
  800d1e:	74 e3                	je     800d03 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	8a 00                	mov    (%eax),%al
  800d25:	0f b6 d0             	movzbl %al,%edx
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	8a 00                	mov    (%eax),%al
  800d2d:	0f b6 c0             	movzbl %al,%eax
  800d30:	29 c2                	sub    %eax,%edx
  800d32:	89 d0                	mov    %edx,%eax
}
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    

00800d36 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d39:	eb 09                	jmp    800d44 <strncmp+0xe>
		n--, p++, q++;
  800d3b:	ff 4d 10             	decl   0x10(%ebp)
  800d3e:	ff 45 08             	incl   0x8(%ebp)
  800d41:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d44:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d48:	74 17                	je     800d61 <strncmp+0x2b>
  800d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4d:	8a 00                	mov    (%eax),%al
  800d4f:	84 c0                	test   %al,%al
  800d51:	74 0e                	je     800d61 <strncmp+0x2b>
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	8a 10                	mov    (%eax),%dl
  800d58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5b:	8a 00                	mov    (%eax),%al
  800d5d:	38 c2                	cmp    %al,%dl
  800d5f:	74 da                	je     800d3b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d65:	75 07                	jne    800d6e <strncmp+0x38>
		return 0;
  800d67:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6c:	eb 14                	jmp    800d82 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	8a 00                	mov    (%eax),%al
  800d73:	0f b6 d0             	movzbl %al,%edx
  800d76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d79:	8a 00                	mov    (%eax),%al
  800d7b:	0f b6 c0             	movzbl %al,%eax
  800d7e:	29 c2                	sub    %eax,%edx
  800d80:	89 d0                	mov    %edx,%eax
}
  800d82:	5d                   	pop    %ebp
  800d83:	c3                   	ret    

00800d84 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	83 ec 04             	sub    $0x4,%esp
  800d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d90:	eb 12                	jmp    800da4 <strchr+0x20>
		if (*s == c)
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9a:	75 05                	jne    800da1 <strchr+0x1d>
			return (char *) s;
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	eb 11                	jmp    800db2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800da1:	ff 45 08             	incl   0x8(%ebp)
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	8a 00                	mov    (%eax),%al
  800da9:	84 c0                	test   %al,%al
  800dab:	75 e5                	jne    800d92 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800db2:	c9                   	leave  
  800db3:	c3                   	ret    

00800db4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	83 ec 04             	sub    $0x4,%esp
  800dba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dc0:	eb 0d                	jmp    800dcf <strfind+0x1b>
		if (*s == c)
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	8a 00                	mov    (%eax),%al
  800dc7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dca:	74 0e                	je     800dda <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dcc:	ff 45 08             	incl   0x8(%ebp)
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	84 c0                	test   %al,%al
  800dd6:	75 ea                	jne    800dc2 <strfind+0xe>
  800dd8:	eb 01                	jmp    800ddb <strfind+0x27>
		if (*s == c)
			break;
  800dda:	90                   	nop
	return (char *) s;
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dde:	c9                   	leave  
  800ddf:	c3                   	ret    

00800de0 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dec:	8b 45 10             	mov    0x10(%ebp),%eax
  800def:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800df2:	eb 0e                	jmp    800e02 <memset+0x22>
		*p++ = c;
  800df4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df7:	8d 50 01             	lea    0x1(%eax),%edx
  800dfa:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e00:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e02:	ff 4d f8             	decl   -0x8(%ebp)
  800e05:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e09:	79 e9                	jns    800df4 <memset+0x14>
		*p++ = c;

	return v;
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0e:	c9                   	leave  
  800e0f:	c3                   	ret    

00800e10 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e22:	eb 16                	jmp    800e3a <memcpy+0x2a>
		*d++ = *s++;
  800e24:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e27:	8d 50 01             	lea    0x1(%eax),%edx
  800e2a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e2d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e30:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e33:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e36:	8a 12                	mov    (%edx),%dl
  800e38:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e40:	89 55 10             	mov    %edx,0x10(%ebp)
  800e43:	85 c0                	test   %eax,%eax
  800e45:	75 dd                	jne    800e24 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4a:	c9                   	leave  
  800e4b:	c3                   	ret    

00800e4c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e61:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e64:	73 50                	jae    800eb6 <memmove+0x6a>
  800e66:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e69:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6c:	01 d0                	add    %edx,%eax
  800e6e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e71:	76 43                	jbe    800eb6 <memmove+0x6a>
		s += n;
  800e73:	8b 45 10             	mov    0x10(%ebp),%eax
  800e76:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e79:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e7f:	eb 10                	jmp    800e91 <memmove+0x45>
			*--d = *--s;
  800e81:	ff 4d f8             	decl   -0x8(%ebp)
  800e84:	ff 4d fc             	decl   -0x4(%ebp)
  800e87:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8a:	8a 10                	mov    (%eax),%dl
  800e8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e8f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e91:	8b 45 10             	mov    0x10(%ebp),%eax
  800e94:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e97:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9a:	85 c0                	test   %eax,%eax
  800e9c:	75 e3                	jne    800e81 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e9e:	eb 23                	jmp    800ec3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ea0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea3:	8d 50 01             	lea    0x1(%eax),%edx
  800ea6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ea9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eac:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eaf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eb2:	8a 12                	mov    (%edx),%dl
  800eb4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebc:	89 55 10             	mov    %edx,0x10(%ebp)
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	75 dd                	jne    800ea0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec6:	c9                   	leave  
  800ec7:	c3                   	ret    

00800ec8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ec8:	55                   	push   %ebp
  800ec9:	89 e5                	mov    %esp,%ebp
  800ecb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eda:	eb 2a                	jmp    800f06 <memcmp+0x3e>
		if (*s1 != *s2)
  800edc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800edf:	8a 10                	mov    (%eax),%dl
  800ee1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee4:	8a 00                	mov    (%eax),%al
  800ee6:	38 c2                	cmp    %al,%dl
  800ee8:	74 16                	je     800f00 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eed:	8a 00                	mov    (%eax),%al
  800eef:	0f b6 d0             	movzbl %al,%edx
  800ef2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef5:	8a 00                	mov    (%eax),%al
  800ef7:	0f b6 c0             	movzbl %al,%eax
  800efa:	29 c2                	sub    %eax,%edx
  800efc:	89 d0                	mov    %edx,%eax
  800efe:	eb 18                	jmp    800f18 <memcmp+0x50>
		s1++, s2++;
  800f00:	ff 45 fc             	incl   -0x4(%ebp)
  800f03:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f06:	8b 45 10             	mov    0x10(%ebp),%eax
  800f09:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f0c:	89 55 10             	mov    %edx,0x10(%ebp)
  800f0f:	85 c0                	test   %eax,%eax
  800f11:	75 c9                	jne    800edc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f18:	c9                   	leave  
  800f19:	c3                   	ret    

00800f1a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f1a:	55                   	push   %ebp
  800f1b:	89 e5                	mov    %esp,%ebp
  800f1d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f20:	8b 55 08             	mov    0x8(%ebp),%edx
  800f23:	8b 45 10             	mov    0x10(%ebp),%eax
  800f26:	01 d0                	add    %edx,%eax
  800f28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f2b:	eb 15                	jmp    800f42 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	8a 00                	mov    (%eax),%al
  800f32:	0f b6 d0             	movzbl %al,%edx
  800f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f38:	0f b6 c0             	movzbl %al,%eax
  800f3b:	39 c2                	cmp    %eax,%edx
  800f3d:	74 0d                	je     800f4c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f3f:	ff 45 08             	incl   0x8(%ebp)
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f48:	72 e3                	jb     800f2d <memfind+0x13>
  800f4a:	eb 01                	jmp    800f4d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f4c:	90                   	nop
	return (void *) s;
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f50:	c9                   	leave  
  800f51:	c3                   	ret    

00800f52 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f52:	55                   	push   %ebp
  800f53:	89 e5                	mov    %esp,%ebp
  800f55:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f5f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f66:	eb 03                	jmp    800f6b <strtol+0x19>
		s++;
  800f68:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	3c 20                	cmp    $0x20,%al
  800f72:	74 f4                	je     800f68 <strtol+0x16>
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	8a 00                	mov    (%eax),%al
  800f79:	3c 09                	cmp    $0x9,%al
  800f7b:	74 eb                	je     800f68 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	3c 2b                	cmp    $0x2b,%al
  800f84:	75 05                	jne    800f8b <strtol+0x39>
		s++;
  800f86:	ff 45 08             	incl   0x8(%ebp)
  800f89:	eb 13                	jmp    800f9e <strtol+0x4c>
	else if (*s == '-')
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8e:	8a 00                	mov    (%eax),%al
  800f90:	3c 2d                	cmp    $0x2d,%al
  800f92:	75 0a                	jne    800f9e <strtol+0x4c>
		s++, neg = 1;
  800f94:	ff 45 08             	incl   0x8(%ebp)
  800f97:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa2:	74 06                	je     800faa <strtol+0x58>
  800fa4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fa8:	75 20                	jne    800fca <strtol+0x78>
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 30                	cmp    $0x30,%al
  800fb1:	75 17                	jne    800fca <strtol+0x78>
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	40                   	inc    %eax
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	3c 78                	cmp    $0x78,%al
  800fbb:	75 0d                	jne    800fca <strtol+0x78>
		s += 2, base = 16;
  800fbd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fc1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fc8:	eb 28                	jmp    800ff2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fce:	75 15                	jne    800fe5 <strtol+0x93>
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	8a 00                	mov    (%eax),%al
  800fd5:	3c 30                	cmp    $0x30,%al
  800fd7:	75 0c                	jne    800fe5 <strtol+0x93>
		s++, base = 8;
  800fd9:	ff 45 08             	incl   0x8(%ebp)
  800fdc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fe3:	eb 0d                	jmp    800ff2 <strtol+0xa0>
	else if (base == 0)
  800fe5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe9:	75 07                	jne    800ff2 <strtol+0xa0>
		base = 10;
  800feb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	8a 00                	mov    (%eax),%al
  800ff7:	3c 2f                	cmp    $0x2f,%al
  800ff9:	7e 19                	jle    801014 <strtol+0xc2>
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	8a 00                	mov    (%eax),%al
  801000:	3c 39                	cmp    $0x39,%al
  801002:	7f 10                	jg     801014 <strtol+0xc2>
			dig = *s - '0';
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	0f be c0             	movsbl %al,%eax
  80100c:	83 e8 30             	sub    $0x30,%eax
  80100f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801012:	eb 42                	jmp    801056 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	3c 60                	cmp    $0x60,%al
  80101b:	7e 19                	jle    801036 <strtol+0xe4>
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	3c 7a                	cmp    $0x7a,%al
  801024:	7f 10                	jg     801036 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	0f be c0             	movsbl %al,%eax
  80102e:	83 e8 57             	sub    $0x57,%eax
  801031:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801034:	eb 20                	jmp    801056 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	3c 40                	cmp    $0x40,%al
  80103d:	7e 39                	jle    801078 <strtol+0x126>
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	3c 5a                	cmp    $0x5a,%al
  801046:	7f 30                	jg     801078 <strtol+0x126>
			dig = *s - 'A' + 10;
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	0f be c0             	movsbl %al,%eax
  801050:	83 e8 37             	sub    $0x37,%eax
  801053:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801059:	3b 45 10             	cmp    0x10(%ebp),%eax
  80105c:	7d 19                	jge    801077 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80105e:	ff 45 08             	incl   0x8(%ebp)
  801061:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801064:	0f af 45 10          	imul   0x10(%ebp),%eax
  801068:	89 c2                	mov    %eax,%edx
  80106a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106d:	01 d0                	add    %edx,%eax
  80106f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801072:	e9 7b ff ff ff       	jmp    800ff2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801077:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801078:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80107c:	74 08                	je     801086 <strtol+0x134>
		*endptr = (char *) s;
  80107e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801081:	8b 55 08             	mov    0x8(%ebp),%edx
  801084:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801086:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80108a:	74 07                	je     801093 <strtol+0x141>
  80108c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108f:	f7 d8                	neg    %eax
  801091:	eb 03                	jmp    801096 <strtol+0x144>
  801093:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801096:	c9                   	leave  
  801097:	c3                   	ret    

00801098 <ltostr>:

void
ltostr(long value, char *str)
{
  801098:	55                   	push   %ebp
  801099:	89 e5                	mov    %esp,%ebp
  80109b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80109e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010b0:	79 13                	jns    8010c5 <ltostr+0x2d>
	{
		neg = 1;
  8010b2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010bf:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010c2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010cd:	99                   	cltd   
  8010ce:	f7 f9                	idiv   %ecx
  8010d0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d6:	8d 50 01             	lea    0x1(%eax),%edx
  8010d9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010dc:	89 c2                	mov    %eax,%edx
  8010de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e1:	01 d0                	add    %edx,%eax
  8010e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010e6:	83 c2 30             	add    $0x30,%edx
  8010e9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ee:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010f3:	f7 e9                	imul   %ecx
  8010f5:	c1 fa 02             	sar    $0x2,%edx
  8010f8:	89 c8                	mov    %ecx,%eax
  8010fa:	c1 f8 1f             	sar    $0x1f,%eax
  8010fd:	29 c2                	sub    %eax,%edx
  8010ff:	89 d0                	mov    %edx,%eax
  801101:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801104:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801108:	75 bb                	jne    8010c5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80110a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801111:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801114:	48                   	dec    %eax
  801115:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801118:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80111c:	74 3d                	je     80115b <ltostr+0xc3>
		start = 1 ;
  80111e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801125:	eb 34                	jmp    80115b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801127:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80112a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112d:	01 d0                	add    %edx,%eax
  80112f:	8a 00                	mov    (%eax),%al
  801131:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801134:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113a:	01 c2                	add    %eax,%edx
  80113c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	01 c8                	add    %ecx,%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801148:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80114b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114e:	01 c2                	add    %eax,%edx
  801150:	8a 45 eb             	mov    -0x15(%ebp),%al
  801153:	88 02                	mov    %al,(%edx)
		start++ ;
  801155:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801158:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80115b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80115e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801161:	7c c4                	jl     801127 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801163:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801166:	8b 45 0c             	mov    0xc(%ebp),%eax
  801169:	01 d0                	add    %edx,%eax
  80116b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80116e:	90                   	nop
  80116f:	c9                   	leave  
  801170:	c3                   	ret    

00801171 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
  801174:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801177:	ff 75 08             	pushl  0x8(%ebp)
  80117a:	e8 73 fa ff ff       	call   800bf2 <strlen>
  80117f:	83 c4 04             	add    $0x4,%esp
  801182:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801185:	ff 75 0c             	pushl  0xc(%ebp)
  801188:	e8 65 fa ff ff       	call   800bf2 <strlen>
  80118d:	83 c4 04             	add    $0x4,%esp
  801190:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801193:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80119a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011a1:	eb 17                	jmp    8011ba <strcconcat+0x49>
		final[s] = str1[s] ;
  8011a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a9:	01 c2                	add    %eax,%edx
  8011ab:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b1:	01 c8                	add    %ecx,%eax
  8011b3:	8a 00                	mov    (%eax),%al
  8011b5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011b7:	ff 45 fc             	incl   -0x4(%ebp)
  8011ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011c0:	7c e1                	jl     8011a3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011c2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011c9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011d0:	eb 1f                	jmp    8011f1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d5:	8d 50 01             	lea    0x1(%eax),%edx
  8011d8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011db:	89 c2                	mov    %eax,%edx
  8011dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e0:	01 c2                	add    %eax,%edx
  8011e2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e8:	01 c8                	add    %ecx,%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011ee:	ff 45 f8             	incl   -0x8(%ebp)
  8011f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011f7:	7c d9                	jl     8011d2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ff:	01 d0                	add    %edx,%eax
  801201:	c6 00 00             	movb   $0x0,(%eax)
}
  801204:	90                   	nop
  801205:	c9                   	leave  
  801206:	c3                   	ret    

00801207 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80120a:	8b 45 14             	mov    0x14(%ebp),%eax
  80120d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801213:	8b 45 14             	mov    0x14(%ebp),%eax
  801216:	8b 00                	mov    (%eax),%eax
  801218:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80121f:	8b 45 10             	mov    0x10(%ebp),%eax
  801222:	01 d0                	add    %edx,%eax
  801224:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80122a:	eb 0c                	jmp    801238 <strsplit+0x31>
			*string++ = 0;
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
  80122f:	8d 50 01             	lea    0x1(%eax),%edx
  801232:	89 55 08             	mov    %edx,0x8(%ebp)
  801235:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8a 00                	mov    (%eax),%al
  80123d:	84 c0                	test   %al,%al
  80123f:	74 18                	je     801259 <strsplit+0x52>
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8a 00                	mov    (%eax),%al
  801246:	0f be c0             	movsbl %al,%eax
  801249:	50                   	push   %eax
  80124a:	ff 75 0c             	pushl  0xc(%ebp)
  80124d:	e8 32 fb ff ff       	call   800d84 <strchr>
  801252:	83 c4 08             	add    $0x8,%esp
  801255:	85 c0                	test   %eax,%eax
  801257:	75 d3                	jne    80122c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8a 00                	mov    (%eax),%al
  80125e:	84 c0                	test   %al,%al
  801260:	74 5a                	je     8012bc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801262:	8b 45 14             	mov    0x14(%ebp),%eax
  801265:	8b 00                	mov    (%eax),%eax
  801267:	83 f8 0f             	cmp    $0xf,%eax
  80126a:	75 07                	jne    801273 <strsplit+0x6c>
		{
			return 0;
  80126c:	b8 00 00 00 00       	mov    $0x0,%eax
  801271:	eb 66                	jmp    8012d9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801273:	8b 45 14             	mov    0x14(%ebp),%eax
  801276:	8b 00                	mov    (%eax),%eax
  801278:	8d 48 01             	lea    0x1(%eax),%ecx
  80127b:	8b 55 14             	mov    0x14(%ebp),%edx
  80127e:	89 0a                	mov    %ecx,(%edx)
  801280:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801287:	8b 45 10             	mov    0x10(%ebp),%eax
  80128a:	01 c2                	add    %eax,%edx
  80128c:	8b 45 08             	mov    0x8(%ebp),%eax
  80128f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801291:	eb 03                	jmp    801296 <strsplit+0x8f>
			string++;
  801293:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	8a 00                	mov    (%eax),%al
  80129b:	84 c0                	test   %al,%al
  80129d:	74 8b                	je     80122a <strsplit+0x23>
  80129f:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a2:	8a 00                	mov    (%eax),%al
  8012a4:	0f be c0             	movsbl %al,%eax
  8012a7:	50                   	push   %eax
  8012a8:	ff 75 0c             	pushl  0xc(%ebp)
  8012ab:	e8 d4 fa ff ff       	call   800d84 <strchr>
  8012b0:	83 c4 08             	add    $0x8,%esp
  8012b3:	85 c0                	test   %eax,%eax
  8012b5:	74 dc                	je     801293 <strsplit+0x8c>
			string++;
	}
  8012b7:	e9 6e ff ff ff       	jmp    80122a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012bc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c0:	8b 00                	mov    (%eax),%eax
  8012c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cc:	01 d0                	add    %edx,%eax
  8012ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012d4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012d9:	c9                   	leave  
  8012da:	c3                   	ret    

008012db <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8012e1:	83 ec 04             	sub    $0x4,%esp
  8012e4:	68 68 44 80 00       	push   $0x804468
  8012e9:	68 3f 01 00 00       	push   $0x13f
  8012ee:	68 8a 44 80 00       	push   $0x80448a
  8012f3:	e8 a9 ef ff ff       	call   8002a1 <_panic>

008012f8 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
  8012fb:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8012fe:	83 ec 0c             	sub    $0xc,%esp
  801301:	ff 75 08             	pushl  0x8(%ebp)
  801304:	e8 e5 0b 00 00       	call   801eee <sys_sbrk>
  801309:	83 c4 10             	add    $0x10,%esp
}
  80130c:	c9                   	leave  
  80130d:	c3                   	ret    

0080130e <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
  801311:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801314:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801318:	75 0a                	jne    801324 <malloc+0x16>
  80131a:	b8 00 00 00 00       	mov    $0x0,%eax
  80131f:	e9 07 02 00 00       	jmp    80152b <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801324:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80132b:	8b 55 08             	mov    0x8(%ebp),%edx
  80132e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801331:	01 d0                	add    %edx,%eax
  801333:	48                   	dec    %eax
  801334:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801337:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80133a:	ba 00 00 00 00       	mov    $0x0,%edx
  80133f:	f7 75 dc             	divl   -0x24(%ebp)
  801342:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801345:	29 d0                	sub    %edx,%eax
  801347:	c1 e8 0c             	shr    $0xc,%eax
  80134a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  80134d:	a1 20 50 80 00       	mov    0x805020,%eax
  801352:	8b 40 78             	mov    0x78(%eax),%eax
  801355:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80135a:	29 c2                	sub    %eax,%edx
  80135c:	89 d0                	mov    %edx,%eax
  80135e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801361:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801364:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801369:	c1 e8 0c             	shr    $0xc,%eax
  80136c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  80136f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801376:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80137d:	77 42                	ja     8013c1 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80137f:	e8 ee 09 00 00       	call   801d72 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801384:	85 c0                	test   %eax,%eax
  801386:	74 16                	je     80139e <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801388:	83 ec 0c             	sub    $0xc,%esp
  80138b:	ff 75 08             	pushl  0x8(%ebp)
  80138e:	e8 2e 0f 00 00       	call   8022c1 <alloc_block_FF>
  801393:	83 c4 10             	add    $0x10,%esp
  801396:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801399:	e9 8a 01 00 00       	jmp    801528 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80139e:	e8 00 0a 00 00       	call   801da3 <sys_isUHeapPlacementStrategyBESTFIT>
  8013a3:	85 c0                	test   %eax,%eax
  8013a5:	0f 84 7d 01 00 00    	je     801528 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8013ab:	83 ec 0c             	sub    $0xc,%esp
  8013ae:	ff 75 08             	pushl  0x8(%ebp)
  8013b1:	e8 c7 13 00 00       	call   80277d <alloc_block_BF>
  8013b6:	83 c4 10             	add    $0x10,%esp
  8013b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013bc:	e9 67 01 00 00       	jmp    801528 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  8013c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8013c4:	48                   	dec    %eax
  8013c5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8013c8:	0f 86 53 01 00 00    	jbe    801521 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  8013ce:	a1 20 50 80 00       	mov    0x805020,%eax
  8013d3:	8b 40 78             	mov    0x78(%eax),%eax
  8013d6:	05 00 10 00 00       	add    $0x1000,%eax
  8013db:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  8013de:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  8013e5:	e9 de 00 00 00       	jmp    8014c8 <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  8013ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8013ef:	8b 40 78             	mov    0x78(%eax),%eax
  8013f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013f5:	29 c2                	sub    %eax,%edx
  8013f7:	89 d0                	mov    %edx,%eax
  8013f9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013fe:	c1 e8 0c             	shr    $0xc,%eax
  801401:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
  801408:	85 c0                	test   %eax,%eax
  80140a:	0f 85 ab 00 00 00    	jne    8014bb <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801410:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801413:	05 00 10 00 00       	add    $0x1000,%eax
  801418:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80141b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801422:	eb 47                	jmp    80146b <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801424:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80142b:	76 0a                	jbe    801437 <malloc+0x129>
  80142d:	b8 00 00 00 00       	mov    $0x0,%eax
  801432:	e9 f4 00 00 00       	jmp    80152b <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801437:	a1 20 50 80 00       	mov    0x805020,%eax
  80143c:	8b 40 78             	mov    0x78(%eax),%eax
  80143f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801442:	29 c2                	sub    %eax,%edx
  801444:	89 d0                	mov    %edx,%eax
  801446:	2d 00 10 00 00       	sub    $0x1000,%eax
  80144b:	c1 e8 0c             	shr    $0xc,%eax
  80144e:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
  801455:	85 c0                	test   %eax,%eax
  801457:	74 08                	je     801461 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  801459:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80145c:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  80145f:	eb 5a                	jmp    8014bb <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801461:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801468:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  80146b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80146e:	48                   	dec    %eax
  80146f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801472:	77 b0                	ja     801424 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801474:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  80147b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801482:	eb 2f                	jmp    8014b3 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801484:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801487:	c1 e0 0c             	shl    $0xc,%eax
  80148a:	89 c2                	mov    %eax,%edx
  80148c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148f:	01 c2                	add    %eax,%edx
  801491:	a1 20 50 80 00       	mov    0x805020,%eax
  801496:	8b 40 78             	mov    0x78(%eax),%eax
  801499:	29 c2                	sub    %eax,%edx
  80149b:	89 d0                	mov    %edx,%eax
  80149d:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014a2:	c1 e8 0c             	shr    $0xc,%eax
  8014a5:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
  8014ac:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  8014b0:	ff 45 e0             	incl   -0x20(%ebp)
  8014b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8014b9:	72 c9                	jb     801484 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8014bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014bf:	75 16                	jne    8014d7 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8014c1:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8014c8:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8014cf:	0f 86 15 ff ff ff    	jbe    8013ea <malloc+0xdc>
  8014d5:	eb 01                	jmp    8014d8 <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8014d7:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  8014d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014dc:	75 07                	jne    8014e5 <malloc+0x1d7>
  8014de:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e3:	eb 46                	jmp    80152b <malloc+0x21d>
		ptr = (void*)i;
  8014e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  8014eb:	a1 20 50 80 00       	mov    0x805020,%eax
  8014f0:	8b 40 78             	mov    0x78(%eax),%eax
  8014f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014f6:	29 c2                	sub    %eax,%edx
  8014f8:	89 d0                	mov    %edx,%eax
  8014fa:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014ff:	c1 e8 0c             	shr    $0xc,%eax
  801502:	89 c2                	mov    %eax,%edx
  801504:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801507:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  80150e:	83 ec 08             	sub    $0x8,%esp
  801511:	ff 75 08             	pushl  0x8(%ebp)
  801514:	ff 75 f0             	pushl  -0x10(%ebp)
  801517:	e8 09 0a 00 00       	call   801f25 <sys_allocate_user_mem>
  80151c:	83 c4 10             	add    $0x10,%esp
  80151f:	eb 07                	jmp    801528 <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801521:	b8 00 00 00 00       	mov    $0x0,%eax
  801526:	eb 03                	jmp    80152b <malloc+0x21d>
	}
	return ptr;
  801528:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80152b:	c9                   	leave  
  80152c:	c3                   	ret    

0080152d <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
  801530:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801533:	a1 20 50 80 00       	mov    0x805020,%eax
  801538:	8b 40 78             	mov    0x78(%eax),%eax
  80153b:	05 00 10 00 00       	add    $0x1000,%eax
  801540:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801543:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  80154a:	a1 20 50 80 00       	mov    0x805020,%eax
  80154f:	8b 50 78             	mov    0x78(%eax),%edx
  801552:	8b 45 08             	mov    0x8(%ebp),%eax
  801555:	39 c2                	cmp    %eax,%edx
  801557:	76 24                	jbe    80157d <free+0x50>
		size = get_block_size(va);
  801559:	83 ec 0c             	sub    $0xc,%esp
  80155c:	ff 75 08             	pushl  0x8(%ebp)
  80155f:	e8 dd 09 00 00       	call   801f41 <get_block_size>
  801564:	83 c4 10             	add    $0x10,%esp
  801567:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80156a:	83 ec 0c             	sub    $0xc,%esp
  80156d:	ff 75 08             	pushl  0x8(%ebp)
  801570:	e8 10 1c 00 00       	call   803185 <free_block>
  801575:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801578:	e9 ac 00 00 00       	jmp    801629 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801583:	0f 82 89 00 00 00    	jb     801612 <free+0xe5>
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
  80158c:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801591:	77 7f                	ja     801612 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801593:	8b 55 08             	mov    0x8(%ebp),%edx
  801596:	a1 20 50 80 00       	mov    0x805020,%eax
  80159b:	8b 40 78             	mov    0x78(%eax),%eax
  80159e:	29 c2                	sub    %eax,%edx
  8015a0:	89 d0                	mov    %edx,%eax
  8015a2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015a7:	c1 e8 0c             	shr    $0xc,%eax
  8015aa:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
  8015b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8015b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015b7:	c1 e0 0c             	shl    $0xc,%eax
  8015ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8015bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8015c4:	eb 42                	jmp    801608 <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  8015c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c9:	c1 e0 0c             	shl    $0xc,%eax
  8015cc:	89 c2                	mov    %eax,%edx
  8015ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d1:	01 c2                	add    %eax,%edx
  8015d3:	a1 20 50 80 00       	mov    0x805020,%eax
  8015d8:	8b 40 78             	mov    0x78(%eax),%eax
  8015db:	29 c2                	sub    %eax,%edx
  8015dd:	89 d0                	mov    %edx,%eax
  8015df:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015e4:	c1 e8 0c             	shr    $0xc,%eax
  8015e7:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  8015ee:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  8015f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	83 ec 08             	sub    $0x8,%esp
  8015fb:	52                   	push   %edx
  8015fc:	50                   	push   %eax
  8015fd:	e8 07 09 00 00       	call   801f09 <sys_free_user_mem>
  801602:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801605:	ff 45 f4             	incl   -0xc(%ebp)
  801608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80160e:	72 b6                	jb     8015c6 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801610:	eb 17                	jmp    801629 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801612:	83 ec 04             	sub    $0x4,%esp
  801615:	68 98 44 80 00       	push   $0x804498
  80161a:	68 88 00 00 00       	push   $0x88
  80161f:	68 c2 44 80 00       	push   $0x8044c2
  801624:	e8 78 ec ff ff       	call   8002a1 <_panic>
	}
}
  801629:	90                   	nop
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	83 ec 28             	sub    $0x28,%esp
  801632:	8b 45 10             	mov    0x10(%ebp),%eax
  801635:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801638:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80163c:	75 0a                	jne    801648 <smalloc+0x1c>
  80163e:	b8 00 00 00 00       	mov    $0x0,%eax
  801643:	e9 ec 00 00 00       	jmp    801734 <smalloc+0x108>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801648:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80164e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801655:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165b:	39 d0                	cmp    %edx,%eax
  80165d:	73 02                	jae    801661 <smalloc+0x35>
  80165f:	89 d0                	mov    %edx,%eax
  801661:	83 ec 0c             	sub    $0xc,%esp
  801664:	50                   	push   %eax
  801665:	e8 a4 fc ff ff       	call   80130e <malloc>
  80166a:	83 c4 10             	add    $0x10,%esp
  80166d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801670:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801674:	75 0a                	jne    801680 <smalloc+0x54>
  801676:	b8 00 00 00 00       	mov    $0x0,%eax
  80167b:	e9 b4 00 00 00       	jmp    801734 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801680:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801684:	ff 75 ec             	pushl  -0x14(%ebp)
  801687:	50                   	push   %eax
  801688:	ff 75 0c             	pushl  0xc(%ebp)
  80168b:	ff 75 08             	pushl  0x8(%ebp)
  80168e:	e8 7d 04 00 00       	call   801b10 <sys_createSharedObject>
  801693:	83 c4 10             	add    $0x10,%esp
  801696:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801699:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80169d:	74 06                	je     8016a5 <smalloc+0x79>
  80169f:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8016a3:	75 0a                	jne    8016af <smalloc+0x83>
  8016a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016aa:	e9 85 00 00 00       	jmp    801734 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  8016af:	83 ec 08             	sub    $0x8,%esp
  8016b2:	ff 75 ec             	pushl  -0x14(%ebp)
  8016b5:	68 ce 44 80 00       	push   $0x8044ce
  8016ba:	e8 9f ee ff ff       	call   80055e <cprintf>
  8016bf:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8016c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8016ca:	8b 40 78             	mov    0x78(%eax),%eax
  8016cd:	29 c2                	sub    %eax,%edx
  8016cf:	89 d0                	mov    %edx,%eax
  8016d1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016d6:	c1 e8 0c             	shr    $0xc,%eax
  8016d9:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8016df:	42                   	inc    %edx
  8016e0:	89 15 24 50 80 00    	mov    %edx,0x805024
  8016e6:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8016ec:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  8016f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016f6:	a1 20 50 80 00       	mov    0x805020,%eax
  8016fb:	8b 40 78             	mov    0x78(%eax),%eax
  8016fe:	29 c2                	sub    %eax,%edx
  801700:	89 d0                	mov    %edx,%eax
  801702:	2d 00 10 00 00       	sub    $0x1000,%eax
  801707:	c1 e8 0c             	shr    $0xc,%eax
  80170a:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801711:	a1 20 50 80 00       	mov    0x805020,%eax
  801716:	8b 50 10             	mov    0x10(%eax),%edx
  801719:	89 c8                	mov    %ecx,%eax
  80171b:	c1 e0 02             	shl    $0x2,%eax
  80171e:	89 c1                	mov    %eax,%ecx
  801720:	c1 e1 09             	shl    $0x9,%ecx
  801723:	01 c8                	add    %ecx,%eax
  801725:	01 c2                	add    %eax,%edx
  801727:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80172a:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801731:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80173c:	83 ec 08             	sub    $0x8,%esp
  80173f:	ff 75 0c             	pushl  0xc(%ebp)
  801742:	ff 75 08             	pushl  0x8(%ebp)
  801745:	e8 f0 03 00 00       	call   801b3a <sys_getSizeOfSharedObject>
  80174a:	83 c4 10             	add    $0x10,%esp
  80174d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801750:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801754:	75 0a                	jne    801760 <sget+0x2a>
  801756:	b8 00 00 00 00       	mov    $0x0,%eax
  80175b:	e9 e7 00 00 00       	jmp    801847 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801763:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801766:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80176d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801770:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801773:	39 d0                	cmp    %edx,%eax
  801775:	73 02                	jae    801779 <sget+0x43>
  801777:	89 d0                	mov    %edx,%eax
  801779:	83 ec 0c             	sub    $0xc,%esp
  80177c:	50                   	push   %eax
  80177d:	e8 8c fb ff ff       	call   80130e <malloc>
  801782:	83 c4 10             	add    $0x10,%esp
  801785:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801788:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80178c:	75 0a                	jne    801798 <sget+0x62>
  80178e:	b8 00 00 00 00       	mov    $0x0,%eax
  801793:	e9 af 00 00 00       	jmp    801847 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801798:	83 ec 04             	sub    $0x4,%esp
  80179b:	ff 75 e8             	pushl  -0x18(%ebp)
  80179e:	ff 75 0c             	pushl  0xc(%ebp)
  8017a1:	ff 75 08             	pushl  0x8(%ebp)
  8017a4:	e8 ae 03 00 00       	call   801b57 <sys_getSharedObject>
  8017a9:	83 c4 10             	add    $0x10,%esp
  8017ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8017af:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017b2:	a1 20 50 80 00       	mov    0x805020,%eax
  8017b7:	8b 40 78             	mov    0x78(%eax),%eax
  8017ba:	29 c2                	sub    %eax,%edx
  8017bc:	89 d0                	mov    %edx,%eax
  8017be:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017c3:	c1 e8 0c             	shr    $0xc,%eax
  8017c6:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8017cc:	42                   	inc    %edx
  8017cd:	89 15 24 50 80 00    	mov    %edx,0x805024
  8017d3:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8017d9:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  8017e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017e3:	a1 20 50 80 00       	mov    0x805020,%eax
  8017e8:	8b 40 78             	mov    0x78(%eax),%eax
  8017eb:	29 c2                	sub    %eax,%edx
  8017ed:	89 d0                	mov    %edx,%eax
  8017ef:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017f4:	c1 e8 0c             	shr    $0xc,%eax
  8017f7:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  8017fe:	a1 20 50 80 00       	mov    0x805020,%eax
  801803:	8b 50 10             	mov    0x10(%eax),%edx
  801806:	89 c8                	mov    %ecx,%eax
  801808:	c1 e0 02             	shl    $0x2,%eax
  80180b:	89 c1                	mov    %eax,%ecx
  80180d:	c1 e1 09             	shl    $0x9,%ecx
  801810:	01 c8                	add    %ecx,%eax
  801812:	01 c2                	add    %eax,%edx
  801814:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801817:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  80181e:	a1 20 50 80 00       	mov    0x805020,%eax
  801823:	8b 40 10             	mov    0x10(%eax),%eax
  801826:	83 ec 08             	sub    $0x8,%esp
  801829:	50                   	push   %eax
  80182a:	68 dd 44 80 00       	push   $0x8044dd
  80182f:	e8 2a ed ff ff       	call   80055e <cprintf>
  801834:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801837:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80183b:	75 07                	jne    801844 <sget+0x10e>
  80183d:	b8 00 00 00 00       	mov    $0x0,%eax
  801842:	eb 03                	jmp    801847 <sget+0x111>
	return ptr;
  801844:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
  80184c:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  80184f:	8b 55 08             	mov    0x8(%ebp),%edx
  801852:	a1 20 50 80 00       	mov    0x805020,%eax
  801857:	8b 40 78             	mov    0x78(%eax),%eax
  80185a:	29 c2                	sub    %eax,%edx
  80185c:	89 d0                	mov    %edx,%eax
  80185e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801863:	c1 e8 0c             	shr    $0xc,%eax
  801866:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  80186d:	a1 20 50 80 00       	mov    0x805020,%eax
  801872:	8b 50 10             	mov    0x10(%eax),%edx
  801875:	89 c8                	mov    %ecx,%eax
  801877:	c1 e0 02             	shl    $0x2,%eax
  80187a:	89 c1                	mov    %eax,%ecx
  80187c:	c1 e1 09             	shl    $0x9,%ecx
  80187f:	01 c8                	add    %ecx,%eax
  801881:	01 d0                	add    %edx,%eax
  801883:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  80188a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  80188d:	83 ec 08             	sub    $0x8,%esp
  801890:	ff 75 08             	pushl  0x8(%ebp)
  801893:	ff 75 f4             	pushl  -0xc(%ebp)
  801896:	e8 db 02 00 00       	call   801b76 <sys_freeSharedObject>
  80189b:	83 c4 10             	add    $0x10,%esp
  80189e:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8018a1:	90                   	nop
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018aa:	83 ec 04             	sub    $0x4,%esp
  8018ad:	68 ec 44 80 00       	push   $0x8044ec
  8018b2:	68 e5 00 00 00       	push   $0xe5
  8018b7:	68 c2 44 80 00       	push   $0x8044c2
  8018bc:	e8 e0 e9 ff ff       	call   8002a1 <_panic>

008018c1 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018c7:	83 ec 04             	sub    $0x4,%esp
  8018ca:	68 12 45 80 00       	push   $0x804512
  8018cf:	68 f1 00 00 00       	push   $0xf1
  8018d4:	68 c2 44 80 00       	push   $0x8044c2
  8018d9:	e8 c3 e9 ff ff       	call   8002a1 <_panic>

008018de <shrink>:

}
void shrink(uint32 newSize)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018e4:	83 ec 04             	sub    $0x4,%esp
  8018e7:	68 12 45 80 00       	push   $0x804512
  8018ec:	68 f6 00 00 00       	push   $0xf6
  8018f1:	68 c2 44 80 00       	push   $0x8044c2
  8018f6:	e8 a6 e9 ff ff       	call   8002a1 <_panic>

008018fb <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801901:	83 ec 04             	sub    $0x4,%esp
  801904:	68 12 45 80 00       	push   $0x804512
  801909:	68 fb 00 00 00       	push   $0xfb
  80190e:	68 c2 44 80 00       	push   $0x8044c2
  801913:	e8 89 e9 ff ff       	call   8002a1 <_panic>

00801918 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	57                   	push   %edi
  80191c:	56                   	push   %esi
  80191d:	53                   	push   %ebx
  80191e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	8b 55 0c             	mov    0xc(%ebp),%edx
  801927:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80192a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80192d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801930:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801933:	cd 30                	int    $0x30
  801935:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801938:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80193b:	83 c4 10             	add    $0x10,%esp
  80193e:	5b                   	pop    %ebx
  80193f:	5e                   	pop    %esi
  801940:	5f                   	pop    %edi
  801941:	5d                   	pop    %ebp
  801942:	c3                   	ret    

00801943 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	83 ec 04             	sub    $0x4,%esp
  801949:	8b 45 10             	mov    0x10(%ebp),%eax
  80194c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80194f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	52                   	push   %edx
  80195b:	ff 75 0c             	pushl  0xc(%ebp)
  80195e:	50                   	push   %eax
  80195f:	6a 00                	push   $0x0
  801961:	e8 b2 ff ff ff       	call   801918 <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	90                   	nop
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_cgetc>:

int
sys_cgetc(void)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 02                	push   $0x2
  80197b:	e8 98 ff ff ff       	call   801918 <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 03                	push   $0x3
  801994:	e8 7f ff ff ff       	call   801918 <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
}
  80199c:	90                   	nop
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 04                	push   $0x4
  8019ae:	e8 65 ff ff ff       	call   801918 <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
}
  8019b6:	90                   	nop
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	52                   	push   %edx
  8019c9:	50                   	push   %eax
  8019ca:	6a 08                	push   $0x8
  8019cc:	e8 47 ff ff ff       	call   801918 <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	56                   	push   %esi
  8019da:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019db:	8b 75 18             	mov    0x18(%ebp),%esi
  8019de:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019e1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	56                   	push   %esi
  8019eb:	53                   	push   %ebx
  8019ec:	51                   	push   %ecx
  8019ed:	52                   	push   %edx
  8019ee:	50                   	push   %eax
  8019ef:	6a 09                	push   $0x9
  8019f1:	e8 22 ff ff ff       	call   801918 <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
}
  8019f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019fc:	5b                   	pop    %ebx
  8019fd:	5e                   	pop    %esi
  8019fe:	5d                   	pop    %ebp
  8019ff:	c3                   	ret    

00801a00 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a06:	8b 45 08             	mov    0x8(%ebp),%eax
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	52                   	push   %edx
  801a10:	50                   	push   %eax
  801a11:	6a 0a                	push   $0xa
  801a13:	e8 00 ff ff ff       	call   801918 <syscall>
  801a18:	83 c4 18             	add    $0x18,%esp
}
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	ff 75 0c             	pushl  0xc(%ebp)
  801a29:	ff 75 08             	pushl  0x8(%ebp)
  801a2c:	6a 0b                	push   $0xb
  801a2e:	e8 e5 fe ff ff       	call   801918 <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 0c                	push   $0xc
  801a47:	e8 cc fe ff ff       	call   801918 <syscall>
  801a4c:	83 c4 18             	add    $0x18,%esp
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 0d                	push   $0xd
  801a60:	e8 b3 fe ff ff       	call   801918 <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 0e                	push   $0xe
  801a79:	e8 9a fe ff ff       	call   801918 <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
}
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 0f                	push   $0xf
  801a92:	e8 81 fe ff ff       	call   801918 <syscall>
  801a97:	83 c4 18             	add    $0x18,%esp
}
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    

00801a9c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	ff 75 08             	pushl  0x8(%ebp)
  801aaa:	6a 10                	push   $0x10
  801aac:	e8 67 fe ff ff       	call   801918 <syscall>
  801ab1:	83 c4 18             	add    $0x18,%esp
}
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 11                	push   $0x11
  801ac5:	e8 4e fe ff ff       	call   801918 <syscall>
  801aca:	83 c4 18             	add    $0x18,%esp
}
  801acd:	90                   	nop
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <sys_cputc>:

void
sys_cputc(const char c)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
  801ad3:	83 ec 04             	sub    $0x4,%esp
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801adc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	50                   	push   %eax
  801ae9:	6a 01                	push   $0x1
  801aeb:	e8 28 fe ff ff       	call   801918 <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	90                   	nop
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 14                	push   $0x14
  801b05:	e8 0e fe ff ff       	call   801918 <syscall>
  801b0a:	83 c4 18             	add    $0x18,%esp
}
  801b0d:	90                   	nop
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
  801b13:	83 ec 04             	sub    $0x4,%esp
  801b16:	8b 45 10             	mov    0x10(%ebp),%eax
  801b19:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b1c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b1f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	6a 00                	push   $0x0
  801b28:	51                   	push   %ecx
  801b29:	52                   	push   %edx
  801b2a:	ff 75 0c             	pushl  0xc(%ebp)
  801b2d:	50                   	push   %eax
  801b2e:	6a 15                	push   $0x15
  801b30:	e8 e3 fd ff ff       	call   801918 <syscall>
  801b35:	83 c4 18             	add    $0x18,%esp
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b40:	8b 45 08             	mov    0x8(%ebp),%eax
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	52                   	push   %edx
  801b4a:	50                   	push   %eax
  801b4b:	6a 16                	push   $0x16
  801b4d:	e8 c6 fd ff ff       	call   801918 <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b5a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	51                   	push   %ecx
  801b68:	52                   	push   %edx
  801b69:	50                   	push   %eax
  801b6a:	6a 17                	push   $0x17
  801b6c:	e8 a7 fd ff ff       	call   801918 <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	52                   	push   %edx
  801b86:	50                   	push   %eax
  801b87:	6a 18                	push   $0x18
  801b89:	e8 8a fd ff ff       	call   801918 <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	6a 00                	push   $0x0
  801b9b:	ff 75 14             	pushl  0x14(%ebp)
  801b9e:	ff 75 10             	pushl  0x10(%ebp)
  801ba1:	ff 75 0c             	pushl  0xc(%ebp)
  801ba4:	50                   	push   %eax
  801ba5:	6a 19                	push   $0x19
  801ba7:	e8 6c fd ff ff       	call   801918 <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	50                   	push   %eax
  801bc0:	6a 1a                	push   $0x1a
  801bc2:	e8 51 fd ff ff       	call   801918 <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
}
  801bca:	90                   	nop
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	50                   	push   %eax
  801bdc:	6a 1b                	push   $0x1b
  801bde:	e8 35 fd ff ff       	call   801918 <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 05                	push   $0x5
  801bf7:	e8 1c fd ff ff       	call   801918 <syscall>
  801bfc:	83 c4 18             	add    $0x18,%esp
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 06                	push   $0x6
  801c10:	e8 03 fd ff ff       	call   801918 <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 07                	push   $0x7
  801c29:	e8 ea fc ff ff       	call   801918 <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_exit_env>:


void sys_exit_env(void)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 1c                	push   $0x1c
  801c42:	e8 d1 fc ff ff       	call   801918 <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
}
  801c4a:	90                   	nop
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c53:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c56:	8d 50 04             	lea    0x4(%eax),%edx
  801c59:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	52                   	push   %edx
  801c63:	50                   	push   %eax
  801c64:	6a 1d                	push   $0x1d
  801c66:	e8 ad fc ff ff       	call   801918 <syscall>
  801c6b:	83 c4 18             	add    $0x18,%esp
	return result;
  801c6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c74:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c77:	89 01                	mov    %eax,(%ecx)
  801c79:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	c9                   	leave  
  801c80:	c2 04 00             	ret    $0x4

00801c83 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	ff 75 10             	pushl  0x10(%ebp)
  801c8d:	ff 75 0c             	pushl  0xc(%ebp)
  801c90:	ff 75 08             	pushl  0x8(%ebp)
  801c93:	6a 13                	push   $0x13
  801c95:	e8 7e fc ff ff       	call   801918 <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9d:	90                   	nop
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 1e                	push   $0x1e
  801caf:	e8 64 fc ff ff       	call   801918 <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
}
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	83 ec 04             	sub    $0x4,%esp
  801cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cc5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	50                   	push   %eax
  801cd2:	6a 1f                	push   $0x1f
  801cd4:	e8 3f fc ff ff       	call   801918 <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdc:	90                   	nop
}
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <rsttst>:
void rsttst()
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 21                	push   $0x21
  801cee:	e8 25 fc ff ff       	call   801918 <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf6:	90                   	nop
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
  801cfc:	83 ec 04             	sub    $0x4,%esp
  801cff:	8b 45 14             	mov    0x14(%ebp),%eax
  801d02:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d05:	8b 55 18             	mov    0x18(%ebp),%edx
  801d08:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d0c:	52                   	push   %edx
  801d0d:	50                   	push   %eax
  801d0e:	ff 75 10             	pushl  0x10(%ebp)
  801d11:	ff 75 0c             	pushl  0xc(%ebp)
  801d14:	ff 75 08             	pushl  0x8(%ebp)
  801d17:	6a 20                	push   $0x20
  801d19:	e8 fa fb ff ff       	call   801918 <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d21:	90                   	nop
}
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <chktst>:
void chktst(uint32 n)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	ff 75 08             	pushl  0x8(%ebp)
  801d32:	6a 22                	push   $0x22
  801d34:	e8 df fb ff ff       	call   801918 <syscall>
  801d39:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3c:	90                   	nop
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <inctst>:

void inctst()
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 23                	push   $0x23
  801d4e:	e8 c5 fb ff ff       	call   801918 <syscall>
  801d53:	83 c4 18             	add    $0x18,%esp
	return ;
  801d56:	90                   	nop
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <gettst>:
uint32 gettst()
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 24                	push   $0x24
  801d68:	e8 ab fb ff ff       	call   801918 <syscall>
  801d6d:	83 c4 18             	add    $0x18,%esp
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 25                	push   $0x25
  801d84:	e8 8f fb ff ff       	call   801918 <syscall>
  801d89:	83 c4 18             	add    $0x18,%esp
  801d8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d8f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d93:	75 07                	jne    801d9c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d95:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9a:	eb 05                	jmp    801da1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
  801da6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 25                	push   $0x25
  801db5:	e8 5e fb ff ff       	call   801918 <syscall>
  801dba:	83 c4 18             	add    $0x18,%esp
  801dbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dc0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dc4:	75 07                	jne    801dcd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcb:	eb 05                	jmp    801dd2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
  801dd7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 25                	push   $0x25
  801de6:	e8 2d fb ff ff       	call   801918 <syscall>
  801deb:	83 c4 18             	add    $0x18,%esp
  801dee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801df1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801df5:	75 07                	jne    801dfe <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801df7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfc:	eb 05                	jmp    801e03 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
  801e08:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 25                	push   $0x25
  801e17:	e8 fc fa ff ff       	call   801918 <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
  801e1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e22:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e26:	75 07                	jne    801e2f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e28:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2d:	eb 05                	jmp    801e34 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	ff 75 08             	pushl  0x8(%ebp)
  801e44:	6a 26                	push   $0x26
  801e46:	e8 cd fa ff ff       	call   801918 <syscall>
  801e4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4e:	90                   	nop
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e55:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e58:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e61:	6a 00                	push   $0x0
  801e63:	53                   	push   %ebx
  801e64:	51                   	push   %ecx
  801e65:	52                   	push   %edx
  801e66:	50                   	push   %eax
  801e67:	6a 27                	push   $0x27
  801e69:	e8 aa fa ff ff       	call   801918 <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
}
  801e71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	52                   	push   %edx
  801e86:	50                   	push   %eax
  801e87:	6a 28                	push   $0x28
  801e89:	e8 8a fa ff ff       	call   801918 <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
}
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    

00801e93 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e96:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9f:	6a 00                	push   $0x0
  801ea1:	51                   	push   %ecx
  801ea2:	ff 75 10             	pushl  0x10(%ebp)
  801ea5:	52                   	push   %edx
  801ea6:	50                   	push   %eax
  801ea7:	6a 29                	push   $0x29
  801ea9:	e8 6a fa ff ff       	call   801918 <syscall>
  801eae:	83 c4 18             	add    $0x18,%esp
}
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	ff 75 10             	pushl  0x10(%ebp)
  801ebd:	ff 75 0c             	pushl  0xc(%ebp)
  801ec0:	ff 75 08             	pushl  0x8(%ebp)
  801ec3:	6a 12                	push   $0x12
  801ec5:	e8 4e fa ff ff       	call   801918 <syscall>
  801eca:	83 c4 18             	add    $0x18,%esp
	return ;
  801ecd:	90                   	nop
}
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    

00801ed0 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801ed3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	52                   	push   %edx
  801ee0:	50                   	push   %eax
  801ee1:	6a 2a                	push   $0x2a
  801ee3:	e8 30 fa ff ff       	call   801918 <syscall>
  801ee8:	83 c4 18             	add    $0x18,%esp
	return;
  801eeb:	90                   	nop
}
  801eec:	c9                   	leave  
  801eed:	c3                   	ret    

00801eee <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	50                   	push   %eax
  801efd:	6a 2b                	push   $0x2b
  801eff:	e8 14 fa ff ff       	call   801918 <syscall>
  801f04:	83 c4 18             	add    $0x18,%esp
}
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    

00801f09 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	ff 75 0c             	pushl  0xc(%ebp)
  801f15:	ff 75 08             	pushl  0x8(%ebp)
  801f18:	6a 2c                	push   $0x2c
  801f1a:	e8 f9 f9 ff ff       	call   801918 <syscall>
  801f1f:	83 c4 18             	add    $0x18,%esp
	return;
  801f22:	90                   	nop
}
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	ff 75 0c             	pushl  0xc(%ebp)
  801f31:	ff 75 08             	pushl  0x8(%ebp)
  801f34:	6a 2d                	push   $0x2d
  801f36:	e8 dd f9 ff ff       	call   801918 <syscall>
  801f3b:	83 c4 18             	add    $0x18,%esp
	return;
  801f3e:	90                   	nop
}
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    

00801f41 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
  801f44:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f47:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4a:	83 e8 04             	sub    $0x4,%eax
  801f4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f53:	8b 00                	mov    (%eax),%eax
  801f55:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f58:	c9                   	leave  
  801f59:	c3                   	ret    

00801f5a <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
  801f5d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f60:	8b 45 08             	mov    0x8(%ebp),%eax
  801f63:	83 e8 04             	sub    $0x4,%eax
  801f66:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f6c:	8b 00                	mov    (%eax),%eax
  801f6e:	83 e0 01             	and    $0x1,%eax
  801f71:	85 c0                	test   %eax,%eax
  801f73:	0f 94 c0             	sete   %al
}
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f88:	83 f8 02             	cmp    $0x2,%eax
  801f8b:	74 2b                	je     801fb8 <alloc_block+0x40>
  801f8d:	83 f8 02             	cmp    $0x2,%eax
  801f90:	7f 07                	jg     801f99 <alloc_block+0x21>
  801f92:	83 f8 01             	cmp    $0x1,%eax
  801f95:	74 0e                	je     801fa5 <alloc_block+0x2d>
  801f97:	eb 58                	jmp    801ff1 <alloc_block+0x79>
  801f99:	83 f8 03             	cmp    $0x3,%eax
  801f9c:	74 2d                	je     801fcb <alloc_block+0x53>
  801f9e:	83 f8 04             	cmp    $0x4,%eax
  801fa1:	74 3b                	je     801fde <alloc_block+0x66>
  801fa3:	eb 4c                	jmp    801ff1 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801fa5:	83 ec 0c             	sub    $0xc,%esp
  801fa8:	ff 75 08             	pushl  0x8(%ebp)
  801fab:	e8 11 03 00 00       	call   8022c1 <alloc_block_FF>
  801fb0:	83 c4 10             	add    $0x10,%esp
  801fb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fb6:	eb 4a                	jmp    802002 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801fb8:	83 ec 0c             	sub    $0xc,%esp
  801fbb:	ff 75 08             	pushl  0x8(%ebp)
  801fbe:	e8 fa 19 00 00       	call   8039bd <alloc_block_NF>
  801fc3:	83 c4 10             	add    $0x10,%esp
  801fc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fc9:	eb 37                	jmp    802002 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801fcb:	83 ec 0c             	sub    $0xc,%esp
  801fce:	ff 75 08             	pushl  0x8(%ebp)
  801fd1:	e8 a7 07 00 00       	call   80277d <alloc_block_BF>
  801fd6:	83 c4 10             	add    $0x10,%esp
  801fd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fdc:	eb 24                	jmp    802002 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801fde:	83 ec 0c             	sub    $0xc,%esp
  801fe1:	ff 75 08             	pushl  0x8(%ebp)
  801fe4:	e8 b7 19 00 00       	call   8039a0 <alloc_block_WF>
  801fe9:	83 c4 10             	add    $0x10,%esp
  801fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fef:	eb 11                	jmp    802002 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801ff1:	83 ec 0c             	sub    $0xc,%esp
  801ff4:	68 24 45 80 00       	push   $0x804524
  801ff9:	e8 60 e5 ff ff       	call   80055e <cprintf>
  801ffe:	83 c4 10             	add    $0x10,%esp
		break;
  802001:	90                   	nop
	}
	return va;
  802002:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	53                   	push   %ebx
  80200b:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80200e:	83 ec 0c             	sub    $0xc,%esp
  802011:	68 44 45 80 00       	push   $0x804544
  802016:	e8 43 e5 ff ff       	call   80055e <cprintf>
  80201b:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80201e:	83 ec 0c             	sub    $0xc,%esp
  802021:	68 6f 45 80 00       	push   $0x80456f
  802026:	e8 33 e5 ff ff       	call   80055e <cprintf>
  80202b:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80202e:	8b 45 08             	mov    0x8(%ebp),%eax
  802031:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802034:	eb 37                	jmp    80206d <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802036:	83 ec 0c             	sub    $0xc,%esp
  802039:	ff 75 f4             	pushl  -0xc(%ebp)
  80203c:	e8 19 ff ff ff       	call   801f5a <is_free_block>
  802041:	83 c4 10             	add    $0x10,%esp
  802044:	0f be d8             	movsbl %al,%ebx
  802047:	83 ec 0c             	sub    $0xc,%esp
  80204a:	ff 75 f4             	pushl  -0xc(%ebp)
  80204d:	e8 ef fe ff ff       	call   801f41 <get_block_size>
  802052:	83 c4 10             	add    $0x10,%esp
  802055:	83 ec 04             	sub    $0x4,%esp
  802058:	53                   	push   %ebx
  802059:	50                   	push   %eax
  80205a:	68 87 45 80 00       	push   $0x804587
  80205f:	e8 fa e4 ff ff       	call   80055e <cprintf>
  802064:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802067:	8b 45 10             	mov    0x10(%ebp),%eax
  80206a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80206d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802071:	74 07                	je     80207a <print_blocks_list+0x73>
  802073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802076:	8b 00                	mov    (%eax),%eax
  802078:	eb 05                	jmp    80207f <print_blocks_list+0x78>
  80207a:	b8 00 00 00 00       	mov    $0x0,%eax
  80207f:	89 45 10             	mov    %eax,0x10(%ebp)
  802082:	8b 45 10             	mov    0x10(%ebp),%eax
  802085:	85 c0                	test   %eax,%eax
  802087:	75 ad                	jne    802036 <print_blocks_list+0x2f>
  802089:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80208d:	75 a7                	jne    802036 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80208f:	83 ec 0c             	sub    $0xc,%esp
  802092:	68 44 45 80 00       	push   $0x804544
  802097:	e8 c2 e4 ff ff       	call   80055e <cprintf>
  80209c:	83 c4 10             	add    $0x10,%esp

}
  80209f:	90                   	nop
  8020a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8020ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ae:	83 e0 01             	and    $0x1,%eax
  8020b1:	85 c0                	test   %eax,%eax
  8020b3:	74 03                	je     8020b8 <initialize_dynamic_allocator+0x13>
  8020b5:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8020b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020bc:	0f 84 c7 01 00 00    	je     802289 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8020c2:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  8020c9:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8020cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8020cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d2:	01 d0                	add    %edx,%eax
  8020d4:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8020d9:	0f 87 ad 01 00 00    	ja     80228c <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8020df:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e2:	85 c0                	test   %eax,%eax
  8020e4:	0f 89 a5 01 00 00    	jns    80228f <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8020ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f0:	01 d0                	add    %edx,%eax
  8020f2:	83 e8 04             	sub    $0x4,%eax
  8020f5:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  8020fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802101:	a1 30 50 80 00       	mov    0x805030,%eax
  802106:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802109:	e9 87 00 00 00       	jmp    802195 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80210e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802112:	75 14                	jne    802128 <initialize_dynamic_allocator+0x83>
  802114:	83 ec 04             	sub    $0x4,%esp
  802117:	68 9f 45 80 00       	push   $0x80459f
  80211c:	6a 79                	push   $0x79
  80211e:	68 bd 45 80 00       	push   $0x8045bd
  802123:	e8 79 e1 ff ff       	call   8002a1 <_panic>
  802128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212b:	8b 00                	mov    (%eax),%eax
  80212d:	85 c0                	test   %eax,%eax
  80212f:	74 10                	je     802141 <initialize_dynamic_allocator+0x9c>
  802131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802134:	8b 00                	mov    (%eax),%eax
  802136:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802139:	8b 52 04             	mov    0x4(%edx),%edx
  80213c:	89 50 04             	mov    %edx,0x4(%eax)
  80213f:	eb 0b                	jmp    80214c <initialize_dynamic_allocator+0xa7>
  802141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802144:	8b 40 04             	mov    0x4(%eax),%eax
  802147:	a3 34 50 80 00       	mov    %eax,0x805034
  80214c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214f:	8b 40 04             	mov    0x4(%eax),%eax
  802152:	85 c0                	test   %eax,%eax
  802154:	74 0f                	je     802165 <initialize_dynamic_allocator+0xc0>
  802156:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802159:	8b 40 04             	mov    0x4(%eax),%eax
  80215c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80215f:	8b 12                	mov    (%edx),%edx
  802161:	89 10                	mov    %edx,(%eax)
  802163:	eb 0a                	jmp    80216f <initialize_dynamic_allocator+0xca>
  802165:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802168:	8b 00                	mov    (%eax),%eax
  80216a:	a3 30 50 80 00       	mov    %eax,0x805030
  80216f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802172:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802182:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802187:	48                   	dec    %eax
  802188:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80218d:	a1 38 50 80 00       	mov    0x805038,%eax
  802192:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802195:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802199:	74 07                	je     8021a2 <initialize_dynamic_allocator+0xfd>
  80219b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219e:	8b 00                	mov    (%eax),%eax
  8021a0:	eb 05                	jmp    8021a7 <initialize_dynamic_allocator+0x102>
  8021a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a7:	a3 38 50 80 00       	mov    %eax,0x805038
  8021ac:	a1 38 50 80 00       	mov    0x805038,%eax
  8021b1:	85 c0                	test   %eax,%eax
  8021b3:	0f 85 55 ff ff ff    	jne    80210e <initialize_dynamic_allocator+0x69>
  8021b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021bd:	0f 85 4b ff ff ff    	jne    80210e <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8021c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8021c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8021d2:	a1 48 50 80 00       	mov    0x805048,%eax
  8021d7:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  8021dc:	a1 44 50 80 00       	mov    0x805044,%eax
  8021e1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	83 c0 08             	add    $0x8,%eax
  8021ed:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	83 c0 04             	add    $0x4,%eax
  8021f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f9:	83 ea 08             	sub    $0x8,%edx
  8021fc:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	01 d0                	add    %edx,%eax
  802206:	83 e8 08             	sub    $0x8,%eax
  802209:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220c:	83 ea 08             	sub    $0x8,%edx
  80220f:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802211:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802214:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80221a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802224:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802228:	75 17                	jne    802241 <initialize_dynamic_allocator+0x19c>
  80222a:	83 ec 04             	sub    $0x4,%esp
  80222d:	68 d8 45 80 00       	push   $0x8045d8
  802232:	68 90 00 00 00       	push   $0x90
  802237:	68 bd 45 80 00       	push   $0x8045bd
  80223c:	e8 60 e0 ff ff       	call   8002a1 <_panic>
  802241:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802247:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80224a:	89 10                	mov    %edx,(%eax)
  80224c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80224f:	8b 00                	mov    (%eax),%eax
  802251:	85 c0                	test   %eax,%eax
  802253:	74 0d                	je     802262 <initialize_dynamic_allocator+0x1bd>
  802255:	a1 30 50 80 00       	mov    0x805030,%eax
  80225a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80225d:	89 50 04             	mov    %edx,0x4(%eax)
  802260:	eb 08                	jmp    80226a <initialize_dynamic_allocator+0x1c5>
  802262:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802265:	a3 34 50 80 00       	mov    %eax,0x805034
  80226a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226d:	a3 30 50 80 00       	mov    %eax,0x805030
  802272:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802275:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80227c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802281:	40                   	inc    %eax
  802282:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802287:	eb 07                	jmp    802290 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802289:	90                   	nop
  80228a:	eb 04                	jmp    802290 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80228c:	90                   	nop
  80228d:	eb 01                	jmp    802290 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80228f:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802290:	c9                   	leave  
  802291:	c3                   	ret    

00802292 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802295:	8b 45 10             	mov    0x10(%ebp),%eax
  802298:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	8d 50 fc             	lea    -0x4(%eax),%edx
  8022a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a4:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	83 e8 04             	sub    $0x4,%eax
  8022ac:	8b 00                	mov    (%eax),%eax
  8022ae:	83 e0 fe             	and    $0xfffffffe,%eax
  8022b1:	8d 50 f8             	lea    -0x8(%eax),%edx
  8022b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b7:	01 c2                	add    %eax,%edx
  8022b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022bc:	89 02                	mov    %eax,(%edx)
}
  8022be:	90                   	nop
  8022bf:	5d                   	pop    %ebp
  8022c0:	c3                   	ret    

008022c1 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
  8022c4:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8022c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ca:	83 e0 01             	and    $0x1,%eax
  8022cd:	85 c0                	test   %eax,%eax
  8022cf:	74 03                	je     8022d4 <alloc_block_FF+0x13>
  8022d1:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8022d4:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8022d8:	77 07                	ja     8022e1 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8022da:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8022e1:	a1 28 50 80 00       	mov    0x805028,%eax
  8022e6:	85 c0                	test   %eax,%eax
  8022e8:	75 73                	jne    80235d <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8022ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ed:	83 c0 10             	add    $0x10,%eax
  8022f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8022f3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8022fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802300:	01 d0                	add    %edx,%eax
  802302:	48                   	dec    %eax
  802303:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802306:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802309:	ba 00 00 00 00       	mov    $0x0,%edx
  80230e:	f7 75 ec             	divl   -0x14(%ebp)
  802311:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802314:	29 d0                	sub    %edx,%eax
  802316:	c1 e8 0c             	shr    $0xc,%eax
  802319:	83 ec 0c             	sub    $0xc,%esp
  80231c:	50                   	push   %eax
  80231d:	e8 d6 ef ff ff       	call   8012f8 <sbrk>
  802322:	83 c4 10             	add    $0x10,%esp
  802325:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802328:	83 ec 0c             	sub    $0xc,%esp
  80232b:	6a 00                	push   $0x0
  80232d:	e8 c6 ef ff ff       	call   8012f8 <sbrk>
  802332:	83 c4 10             	add    $0x10,%esp
  802335:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802338:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80233b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80233e:	83 ec 08             	sub    $0x8,%esp
  802341:	50                   	push   %eax
  802342:	ff 75 e4             	pushl  -0x1c(%ebp)
  802345:	e8 5b fd ff ff       	call   8020a5 <initialize_dynamic_allocator>
  80234a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80234d:	83 ec 0c             	sub    $0xc,%esp
  802350:	68 fb 45 80 00       	push   $0x8045fb
  802355:	e8 04 e2 ff ff       	call   80055e <cprintf>
  80235a:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80235d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802361:	75 0a                	jne    80236d <alloc_block_FF+0xac>
	        return NULL;
  802363:	b8 00 00 00 00       	mov    $0x0,%eax
  802368:	e9 0e 04 00 00       	jmp    80277b <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80236d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802374:	a1 30 50 80 00       	mov    0x805030,%eax
  802379:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80237c:	e9 f3 02 00 00       	jmp    802674 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802384:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802387:	83 ec 0c             	sub    $0xc,%esp
  80238a:	ff 75 bc             	pushl  -0x44(%ebp)
  80238d:	e8 af fb ff ff       	call   801f41 <get_block_size>
  802392:	83 c4 10             	add    $0x10,%esp
  802395:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	83 c0 08             	add    $0x8,%eax
  80239e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023a1:	0f 87 c5 02 00 00    	ja     80266c <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8023a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023aa:	83 c0 18             	add    $0x18,%eax
  8023ad:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023b0:	0f 87 19 02 00 00    	ja     8025cf <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8023b6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8023b9:	2b 45 08             	sub    0x8(%ebp),%eax
  8023bc:	83 e8 08             	sub    $0x8,%eax
  8023bf:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	8d 50 08             	lea    0x8(%eax),%edx
  8023c8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023cb:	01 d0                	add    %edx,%eax
  8023cd:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8023d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d3:	83 c0 08             	add    $0x8,%eax
  8023d6:	83 ec 04             	sub    $0x4,%esp
  8023d9:	6a 01                	push   $0x1
  8023db:	50                   	push   %eax
  8023dc:	ff 75 bc             	pushl  -0x44(%ebp)
  8023df:	e8 ae fe ff ff       	call   802292 <set_block_data>
  8023e4:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8023e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ea:	8b 40 04             	mov    0x4(%eax),%eax
  8023ed:	85 c0                	test   %eax,%eax
  8023ef:	75 68                	jne    802459 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023f1:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023f5:	75 17                	jne    80240e <alloc_block_FF+0x14d>
  8023f7:	83 ec 04             	sub    $0x4,%esp
  8023fa:	68 d8 45 80 00       	push   $0x8045d8
  8023ff:	68 d7 00 00 00       	push   $0xd7
  802404:	68 bd 45 80 00       	push   $0x8045bd
  802409:	e8 93 de ff ff       	call   8002a1 <_panic>
  80240e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802414:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802417:	89 10                	mov    %edx,(%eax)
  802419:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80241c:	8b 00                	mov    (%eax),%eax
  80241e:	85 c0                	test   %eax,%eax
  802420:	74 0d                	je     80242f <alloc_block_FF+0x16e>
  802422:	a1 30 50 80 00       	mov    0x805030,%eax
  802427:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80242a:	89 50 04             	mov    %edx,0x4(%eax)
  80242d:	eb 08                	jmp    802437 <alloc_block_FF+0x176>
  80242f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802432:	a3 34 50 80 00       	mov    %eax,0x805034
  802437:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80243a:	a3 30 50 80 00       	mov    %eax,0x805030
  80243f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802442:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802449:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80244e:	40                   	inc    %eax
  80244f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802454:	e9 dc 00 00 00       	jmp    802535 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245c:	8b 00                	mov    (%eax),%eax
  80245e:	85 c0                	test   %eax,%eax
  802460:	75 65                	jne    8024c7 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802462:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802466:	75 17                	jne    80247f <alloc_block_FF+0x1be>
  802468:	83 ec 04             	sub    $0x4,%esp
  80246b:	68 0c 46 80 00       	push   $0x80460c
  802470:	68 db 00 00 00       	push   $0xdb
  802475:	68 bd 45 80 00       	push   $0x8045bd
  80247a:	e8 22 de ff ff       	call   8002a1 <_panic>
  80247f:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802485:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802488:	89 50 04             	mov    %edx,0x4(%eax)
  80248b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80248e:	8b 40 04             	mov    0x4(%eax),%eax
  802491:	85 c0                	test   %eax,%eax
  802493:	74 0c                	je     8024a1 <alloc_block_FF+0x1e0>
  802495:	a1 34 50 80 00       	mov    0x805034,%eax
  80249a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80249d:	89 10                	mov    %edx,(%eax)
  80249f:	eb 08                	jmp    8024a9 <alloc_block_FF+0x1e8>
  8024a1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024a4:	a3 30 50 80 00       	mov    %eax,0x805030
  8024a9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ac:	a3 34 50 80 00       	mov    %eax,0x805034
  8024b1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ba:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8024bf:	40                   	inc    %eax
  8024c0:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8024c5:	eb 6e                	jmp    802535 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8024c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024cb:	74 06                	je     8024d3 <alloc_block_FF+0x212>
  8024cd:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024d1:	75 17                	jne    8024ea <alloc_block_FF+0x229>
  8024d3:	83 ec 04             	sub    $0x4,%esp
  8024d6:	68 30 46 80 00       	push   $0x804630
  8024db:	68 df 00 00 00       	push   $0xdf
  8024e0:	68 bd 45 80 00       	push   $0x8045bd
  8024e5:	e8 b7 dd ff ff       	call   8002a1 <_panic>
  8024ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ed:	8b 10                	mov    (%eax),%edx
  8024ef:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024f2:	89 10                	mov    %edx,(%eax)
  8024f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024f7:	8b 00                	mov    (%eax),%eax
  8024f9:	85 c0                	test   %eax,%eax
  8024fb:	74 0b                	je     802508 <alloc_block_FF+0x247>
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	8b 00                	mov    (%eax),%eax
  802502:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802505:	89 50 04             	mov    %edx,0x4(%eax)
  802508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80250e:	89 10                	mov    %edx,(%eax)
  802510:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802513:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802516:	89 50 04             	mov    %edx,0x4(%eax)
  802519:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80251c:	8b 00                	mov    (%eax),%eax
  80251e:	85 c0                	test   %eax,%eax
  802520:	75 08                	jne    80252a <alloc_block_FF+0x269>
  802522:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802525:	a3 34 50 80 00       	mov    %eax,0x805034
  80252a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80252f:	40                   	inc    %eax
  802530:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802535:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802539:	75 17                	jne    802552 <alloc_block_FF+0x291>
  80253b:	83 ec 04             	sub    $0x4,%esp
  80253e:	68 9f 45 80 00       	push   $0x80459f
  802543:	68 e1 00 00 00       	push   $0xe1
  802548:	68 bd 45 80 00       	push   $0x8045bd
  80254d:	e8 4f dd ff ff       	call   8002a1 <_panic>
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	8b 00                	mov    (%eax),%eax
  802557:	85 c0                	test   %eax,%eax
  802559:	74 10                	je     80256b <alloc_block_FF+0x2aa>
  80255b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255e:	8b 00                	mov    (%eax),%eax
  802560:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802563:	8b 52 04             	mov    0x4(%edx),%edx
  802566:	89 50 04             	mov    %edx,0x4(%eax)
  802569:	eb 0b                	jmp    802576 <alloc_block_FF+0x2b5>
  80256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256e:	8b 40 04             	mov    0x4(%eax),%eax
  802571:	a3 34 50 80 00       	mov    %eax,0x805034
  802576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802579:	8b 40 04             	mov    0x4(%eax),%eax
  80257c:	85 c0                	test   %eax,%eax
  80257e:	74 0f                	je     80258f <alloc_block_FF+0x2ce>
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	8b 40 04             	mov    0x4(%eax),%eax
  802586:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802589:	8b 12                	mov    (%edx),%edx
  80258b:	89 10                	mov    %edx,(%eax)
  80258d:	eb 0a                	jmp    802599 <alloc_block_FF+0x2d8>
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	8b 00                	mov    (%eax),%eax
  802594:	a3 30 50 80 00       	mov    %eax,0x805030
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ac:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8025b1:	48                   	dec    %eax
  8025b2:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  8025b7:	83 ec 04             	sub    $0x4,%esp
  8025ba:	6a 00                	push   $0x0
  8025bc:	ff 75 b4             	pushl  -0x4c(%ebp)
  8025bf:	ff 75 b0             	pushl  -0x50(%ebp)
  8025c2:	e8 cb fc ff ff       	call   802292 <set_block_data>
  8025c7:	83 c4 10             	add    $0x10,%esp
  8025ca:	e9 95 00 00 00       	jmp    802664 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8025cf:	83 ec 04             	sub    $0x4,%esp
  8025d2:	6a 01                	push   $0x1
  8025d4:	ff 75 b8             	pushl  -0x48(%ebp)
  8025d7:	ff 75 bc             	pushl  -0x44(%ebp)
  8025da:	e8 b3 fc ff ff       	call   802292 <set_block_data>
  8025df:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8025e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e6:	75 17                	jne    8025ff <alloc_block_FF+0x33e>
  8025e8:	83 ec 04             	sub    $0x4,%esp
  8025eb:	68 9f 45 80 00       	push   $0x80459f
  8025f0:	68 e8 00 00 00       	push   $0xe8
  8025f5:	68 bd 45 80 00       	push   $0x8045bd
  8025fa:	e8 a2 dc ff ff       	call   8002a1 <_panic>
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	8b 00                	mov    (%eax),%eax
  802604:	85 c0                	test   %eax,%eax
  802606:	74 10                	je     802618 <alloc_block_FF+0x357>
  802608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260b:	8b 00                	mov    (%eax),%eax
  80260d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802610:	8b 52 04             	mov    0x4(%edx),%edx
  802613:	89 50 04             	mov    %edx,0x4(%eax)
  802616:	eb 0b                	jmp    802623 <alloc_block_FF+0x362>
  802618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261b:	8b 40 04             	mov    0x4(%eax),%eax
  80261e:	a3 34 50 80 00       	mov    %eax,0x805034
  802623:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802626:	8b 40 04             	mov    0x4(%eax),%eax
  802629:	85 c0                	test   %eax,%eax
  80262b:	74 0f                	je     80263c <alloc_block_FF+0x37b>
  80262d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802630:	8b 40 04             	mov    0x4(%eax),%eax
  802633:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802636:	8b 12                	mov    (%edx),%edx
  802638:	89 10                	mov    %edx,(%eax)
  80263a:	eb 0a                	jmp    802646 <alloc_block_FF+0x385>
  80263c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263f:	8b 00                	mov    (%eax),%eax
  802641:	a3 30 50 80 00       	mov    %eax,0x805030
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80264f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802652:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802659:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80265e:	48                   	dec    %eax
  80265f:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802664:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802667:	e9 0f 01 00 00       	jmp    80277b <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80266c:	a1 38 50 80 00       	mov    0x805038,%eax
  802671:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802674:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802678:	74 07                	je     802681 <alloc_block_FF+0x3c0>
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	8b 00                	mov    (%eax),%eax
  80267f:	eb 05                	jmp    802686 <alloc_block_FF+0x3c5>
  802681:	b8 00 00 00 00       	mov    $0x0,%eax
  802686:	a3 38 50 80 00       	mov    %eax,0x805038
  80268b:	a1 38 50 80 00       	mov    0x805038,%eax
  802690:	85 c0                	test   %eax,%eax
  802692:	0f 85 e9 fc ff ff    	jne    802381 <alloc_block_FF+0xc0>
  802698:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269c:	0f 85 df fc ff ff    	jne    802381 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8026a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a5:	83 c0 08             	add    $0x8,%eax
  8026a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8026ab:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026b8:	01 d0                	add    %edx,%eax
  8026ba:	48                   	dec    %eax
  8026bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8026c6:	f7 75 d8             	divl   -0x28(%ebp)
  8026c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026cc:	29 d0                	sub    %edx,%eax
  8026ce:	c1 e8 0c             	shr    $0xc,%eax
  8026d1:	83 ec 0c             	sub    $0xc,%esp
  8026d4:	50                   	push   %eax
  8026d5:	e8 1e ec ff ff       	call   8012f8 <sbrk>
  8026da:	83 c4 10             	add    $0x10,%esp
  8026dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8026e0:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8026e4:	75 0a                	jne    8026f0 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8026e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026eb:	e9 8b 00 00 00       	jmp    80277b <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8026f0:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8026f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026fa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026fd:	01 d0                	add    %edx,%eax
  8026ff:	48                   	dec    %eax
  802700:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802703:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802706:	ba 00 00 00 00       	mov    $0x0,%edx
  80270b:	f7 75 cc             	divl   -0x34(%ebp)
  80270e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802711:	29 d0                	sub    %edx,%eax
  802713:	8d 50 fc             	lea    -0x4(%eax),%edx
  802716:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802719:	01 d0                	add    %edx,%eax
  80271b:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802720:	a1 44 50 80 00       	mov    0x805044,%eax
  802725:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80272b:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802732:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802735:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802738:	01 d0                	add    %edx,%eax
  80273a:	48                   	dec    %eax
  80273b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80273e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802741:	ba 00 00 00 00       	mov    $0x0,%edx
  802746:	f7 75 c4             	divl   -0x3c(%ebp)
  802749:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80274c:	29 d0                	sub    %edx,%eax
  80274e:	83 ec 04             	sub    $0x4,%esp
  802751:	6a 01                	push   $0x1
  802753:	50                   	push   %eax
  802754:	ff 75 d0             	pushl  -0x30(%ebp)
  802757:	e8 36 fb ff ff       	call   802292 <set_block_data>
  80275c:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80275f:	83 ec 0c             	sub    $0xc,%esp
  802762:	ff 75 d0             	pushl  -0x30(%ebp)
  802765:	e8 1b 0a 00 00       	call   803185 <free_block>
  80276a:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80276d:	83 ec 0c             	sub    $0xc,%esp
  802770:	ff 75 08             	pushl  0x8(%ebp)
  802773:	e8 49 fb ff ff       	call   8022c1 <alloc_block_FF>
  802778:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80277b:	c9                   	leave  
  80277c:	c3                   	ret    

0080277d <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80277d:	55                   	push   %ebp
  80277e:	89 e5                	mov    %esp,%ebp
  802780:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802783:	8b 45 08             	mov    0x8(%ebp),%eax
  802786:	83 e0 01             	and    $0x1,%eax
  802789:	85 c0                	test   %eax,%eax
  80278b:	74 03                	je     802790 <alloc_block_BF+0x13>
  80278d:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802790:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802794:	77 07                	ja     80279d <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802796:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80279d:	a1 28 50 80 00       	mov    0x805028,%eax
  8027a2:	85 c0                	test   %eax,%eax
  8027a4:	75 73                	jne    802819 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a9:	83 c0 10             	add    $0x10,%eax
  8027ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027af:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8027b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027bc:	01 d0                	add    %edx,%eax
  8027be:	48                   	dec    %eax
  8027bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8027c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8027ca:	f7 75 e0             	divl   -0x20(%ebp)
  8027cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027d0:	29 d0                	sub    %edx,%eax
  8027d2:	c1 e8 0c             	shr    $0xc,%eax
  8027d5:	83 ec 0c             	sub    $0xc,%esp
  8027d8:	50                   	push   %eax
  8027d9:	e8 1a eb ff ff       	call   8012f8 <sbrk>
  8027de:	83 c4 10             	add    $0x10,%esp
  8027e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8027e4:	83 ec 0c             	sub    $0xc,%esp
  8027e7:	6a 00                	push   $0x0
  8027e9:	e8 0a eb ff ff       	call   8012f8 <sbrk>
  8027ee:	83 c4 10             	add    $0x10,%esp
  8027f1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8027f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027f7:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8027fa:	83 ec 08             	sub    $0x8,%esp
  8027fd:	50                   	push   %eax
  8027fe:	ff 75 d8             	pushl  -0x28(%ebp)
  802801:	e8 9f f8 ff ff       	call   8020a5 <initialize_dynamic_allocator>
  802806:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802809:	83 ec 0c             	sub    $0xc,%esp
  80280c:	68 fb 45 80 00       	push   $0x8045fb
  802811:	e8 48 dd ff ff       	call   80055e <cprintf>
  802816:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802819:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802820:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802827:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80282e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802835:	a1 30 50 80 00       	mov    0x805030,%eax
  80283a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80283d:	e9 1d 01 00 00       	jmp    80295f <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802848:	83 ec 0c             	sub    $0xc,%esp
  80284b:	ff 75 a8             	pushl  -0x58(%ebp)
  80284e:	e8 ee f6 ff ff       	call   801f41 <get_block_size>
  802853:	83 c4 10             	add    $0x10,%esp
  802856:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802859:	8b 45 08             	mov    0x8(%ebp),%eax
  80285c:	83 c0 08             	add    $0x8,%eax
  80285f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802862:	0f 87 ef 00 00 00    	ja     802957 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802868:	8b 45 08             	mov    0x8(%ebp),%eax
  80286b:	83 c0 18             	add    $0x18,%eax
  80286e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802871:	77 1d                	ja     802890 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802873:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802876:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802879:	0f 86 d8 00 00 00    	jbe    802957 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80287f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802882:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802885:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802888:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80288b:	e9 c7 00 00 00       	jmp    802957 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802890:	8b 45 08             	mov    0x8(%ebp),%eax
  802893:	83 c0 08             	add    $0x8,%eax
  802896:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802899:	0f 85 9d 00 00 00    	jne    80293c <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80289f:	83 ec 04             	sub    $0x4,%esp
  8028a2:	6a 01                	push   $0x1
  8028a4:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028a7:	ff 75 a8             	pushl  -0x58(%ebp)
  8028aa:	e8 e3 f9 ff ff       	call   802292 <set_block_data>
  8028af:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8028b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b6:	75 17                	jne    8028cf <alloc_block_BF+0x152>
  8028b8:	83 ec 04             	sub    $0x4,%esp
  8028bb:	68 9f 45 80 00       	push   $0x80459f
  8028c0:	68 2c 01 00 00       	push   $0x12c
  8028c5:	68 bd 45 80 00       	push   $0x8045bd
  8028ca:	e8 d2 d9 ff ff       	call   8002a1 <_panic>
  8028cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d2:	8b 00                	mov    (%eax),%eax
  8028d4:	85 c0                	test   %eax,%eax
  8028d6:	74 10                	je     8028e8 <alloc_block_BF+0x16b>
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	8b 00                	mov    (%eax),%eax
  8028dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e0:	8b 52 04             	mov    0x4(%edx),%edx
  8028e3:	89 50 04             	mov    %edx,0x4(%eax)
  8028e6:	eb 0b                	jmp    8028f3 <alloc_block_BF+0x176>
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	8b 40 04             	mov    0x4(%eax),%eax
  8028ee:	a3 34 50 80 00       	mov    %eax,0x805034
  8028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f6:	8b 40 04             	mov    0x4(%eax),%eax
  8028f9:	85 c0                	test   %eax,%eax
  8028fb:	74 0f                	je     80290c <alloc_block_BF+0x18f>
  8028fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802900:	8b 40 04             	mov    0x4(%eax),%eax
  802903:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802906:	8b 12                	mov    (%edx),%edx
  802908:	89 10                	mov    %edx,(%eax)
  80290a:	eb 0a                	jmp    802916 <alloc_block_BF+0x199>
  80290c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290f:	8b 00                	mov    (%eax),%eax
  802911:	a3 30 50 80 00       	mov    %eax,0x805030
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80291f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802922:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802929:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80292e:	48                   	dec    %eax
  80292f:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802934:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802937:	e9 24 04 00 00       	jmp    802d60 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80293c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802942:	76 13                	jbe    802957 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802944:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80294b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80294e:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802951:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802954:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802957:	a1 38 50 80 00       	mov    0x805038,%eax
  80295c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80295f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802963:	74 07                	je     80296c <alloc_block_BF+0x1ef>
  802965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802968:	8b 00                	mov    (%eax),%eax
  80296a:	eb 05                	jmp    802971 <alloc_block_BF+0x1f4>
  80296c:	b8 00 00 00 00       	mov    $0x0,%eax
  802971:	a3 38 50 80 00       	mov    %eax,0x805038
  802976:	a1 38 50 80 00       	mov    0x805038,%eax
  80297b:	85 c0                	test   %eax,%eax
  80297d:	0f 85 bf fe ff ff    	jne    802842 <alloc_block_BF+0xc5>
  802983:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802987:	0f 85 b5 fe ff ff    	jne    802842 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80298d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802991:	0f 84 26 02 00 00    	je     802bbd <alloc_block_BF+0x440>
  802997:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80299b:	0f 85 1c 02 00 00    	jne    802bbd <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8029a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a4:	2b 45 08             	sub    0x8(%ebp),%eax
  8029a7:	83 e8 08             	sub    $0x8,%eax
  8029aa:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8029ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b0:	8d 50 08             	lea    0x8(%eax),%edx
  8029b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b6:	01 d0                	add    %edx,%eax
  8029b8:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8029bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029be:	83 c0 08             	add    $0x8,%eax
  8029c1:	83 ec 04             	sub    $0x4,%esp
  8029c4:	6a 01                	push   $0x1
  8029c6:	50                   	push   %eax
  8029c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8029ca:	e8 c3 f8 ff ff       	call   802292 <set_block_data>
  8029cf:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8029d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d5:	8b 40 04             	mov    0x4(%eax),%eax
  8029d8:	85 c0                	test   %eax,%eax
  8029da:	75 68                	jne    802a44 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029dc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029e0:	75 17                	jne    8029f9 <alloc_block_BF+0x27c>
  8029e2:	83 ec 04             	sub    $0x4,%esp
  8029e5:	68 d8 45 80 00       	push   $0x8045d8
  8029ea:	68 45 01 00 00       	push   $0x145
  8029ef:	68 bd 45 80 00       	push   $0x8045bd
  8029f4:	e8 a8 d8 ff ff       	call   8002a1 <_panic>
  8029f9:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8029ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a02:	89 10                	mov    %edx,(%eax)
  802a04:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a07:	8b 00                	mov    (%eax),%eax
  802a09:	85 c0                	test   %eax,%eax
  802a0b:	74 0d                	je     802a1a <alloc_block_BF+0x29d>
  802a0d:	a1 30 50 80 00       	mov    0x805030,%eax
  802a12:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a15:	89 50 04             	mov    %edx,0x4(%eax)
  802a18:	eb 08                	jmp    802a22 <alloc_block_BF+0x2a5>
  802a1a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a1d:	a3 34 50 80 00       	mov    %eax,0x805034
  802a22:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a25:	a3 30 50 80 00       	mov    %eax,0x805030
  802a2a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a2d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a34:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a39:	40                   	inc    %eax
  802a3a:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a3f:	e9 dc 00 00 00       	jmp    802b20 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a47:	8b 00                	mov    (%eax),%eax
  802a49:	85 c0                	test   %eax,%eax
  802a4b:	75 65                	jne    802ab2 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a4d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a51:	75 17                	jne    802a6a <alloc_block_BF+0x2ed>
  802a53:	83 ec 04             	sub    $0x4,%esp
  802a56:	68 0c 46 80 00       	push   $0x80460c
  802a5b:	68 4a 01 00 00       	push   $0x14a
  802a60:	68 bd 45 80 00       	push   $0x8045bd
  802a65:	e8 37 d8 ff ff       	call   8002a1 <_panic>
  802a6a:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802a70:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a73:	89 50 04             	mov    %edx,0x4(%eax)
  802a76:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a79:	8b 40 04             	mov    0x4(%eax),%eax
  802a7c:	85 c0                	test   %eax,%eax
  802a7e:	74 0c                	je     802a8c <alloc_block_BF+0x30f>
  802a80:	a1 34 50 80 00       	mov    0x805034,%eax
  802a85:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a88:	89 10                	mov    %edx,(%eax)
  802a8a:	eb 08                	jmp    802a94 <alloc_block_BF+0x317>
  802a8c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a8f:	a3 30 50 80 00       	mov    %eax,0x805030
  802a94:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a97:	a3 34 50 80 00       	mov    %eax,0x805034
  802a9c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802aaa:	40                   	inc    %eax
  802aab:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802ab0:	eb 6e                	jmp    802b20 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802ab2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ab6:	74 06                	je     802abe <alloc_block_BF+0x341>
  802ab8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802abc:	75 17                	jne    802ad5 <alloc_block_BF+0x358>
  802abe:	83 ec 04             	sub    $0x4,%esp
  802ac1:	68 30 46 80 00       	push   $0x804630
  802ac6:	68 4f 01 00 00       	push   $0x14f
  802acb:	68 bd 45 80 00       	push   $0x8045bd
  802ad0:	e8 cc d7 ff ff       	call   8002a1 <_panic>
  802ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad8:	8b 10                	mov    (%eax),%edx
  802ada:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802add:	89 10                	mov    %edx,(%eax)
  802adf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae2:	8b 00                	mov    (%eax),%eax
  802ae4:	85 c0                	test   %eax,%eax
  802ae6:	74 0b                	je     802af3 <alloc_block_BF+0x376>
  802ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aeb:	8b 00                	mov    (%eax),%eax
  802aed:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802af0:	89 50 04             	mov    %edx,0x4(%eax)
  802af3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802af9:	89 10                	mov    %edx,(%eax)
  802afb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802afe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b01:	89 50 04             	mov    %edx,0x4(%eax)
  802b04:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b07:	8b 00                	mov    (%eax),%eax
  802b09:	85 c0                	test   %eax,%eax
  802b0b:	75 08                	jne    802b15 <alloc_block_BF+0x398>
  802b0d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b10:	a3 34 50 80 00       	mov    %eax,0x805034
  802b15:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b1a:	40                   	inc    %eax
  802b1b:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b20:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b24:	75 17                	jne    802b3d <alloc_block_BF+0x3c0>
  802b26:	83 ec 04             	sub    $0x4,%esp
  802b29:	68 9f 45 80 00       	push   $0x80459f
  802b2e:	68 51 01 00 00       	push   $0x151
  802b33:	68 bd 45 80 00       	push   $0x8045bd
  802b38:	e8 64 d7 ff ff       	call   8002a1 <_panic>
  802b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b40:	8b 00                	mov    (%eax),%eax
  802b42:	85 c0                	test   %eax,%eax
  802b44:	74 10                	je     802b56 <alloc_block_BF+0x3d9>
  802b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b49:	8b 00                	mov    (%eax),%eax
  802b4b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b4e:	8b 52 04             	mov    0x4(%edx),%edx
  802b51:	89 50 04             	mov    %edx,0x4(%eax)
  802b54:	eb 0b                	jmp    802b61 <alloc_block_BF+0x3e4>
  802b56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b59:	8b 40 04             	mov    0x4(%eax),%eax
  802b5c:	a3 34 50 80 00       	mov    %eax,0x805034
  802b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b64:	8b 40 04             	mov    0x4(%eax),%eax
  802b67:	85 c0                	test   %eax,%eax
  802b69:	74 0f                	je     802b7a <alloc_block_BF+0x3fd>
  802b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6e:	8b 40 04             	mov    0x4(%eax),%eax
  802b71:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b74:	8b 12                	mov    (%edx),%edx
  802b76:	89 10                	mov    %edx,(%eax)
  802b78:	eb 0a                	jmp    802b84 <alloc_block_BF+0x407>
  802b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7d:	8b 00                	mov    (%eax),%eax
  802b7f:	a3 30 50 80 00       	mov    %eax,0x805030
  802b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b97:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b9c:	48                   	dec    %eax
  802b9d:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  802ba2:	83 ec 04             	sub    $0x4,%esp
  802ba5:	6a 00                	push   $0x0
  802ba7:	ff 75 d0             	pushl  -0x30(%ebp)
  802baa:	ff 75 cc             	pushl  -0x34(%ebp)
  802bad:	e8 e0 f6 ff ff       	call   802292 <set_block_data>
  802bb2:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb8:	e9 a3 01 00 00       	jmp    802d60 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802bbd:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802bc1:	0f 85 9d 00 00 00    	jne    802c64 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802bc7:	83 ec 04             	sub    $0x4,%esp
  802bca:	6a 01                	push   $0x1
  802bcc:	ff 75 ec             	pushl  -0x14(%ebp)
  802bcf:	ff 75 f0             	pushl  -0x10(%ebp)
  802bd2:	e8 bb f6 ff ff       	call   802292 <set_block_data>
  802bd7:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802bda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bde:	75 17                	jne    802bf7 <alloc_block_BF+0x47a>
  802be0:	83 ec 04             	sub    $0x4,%esp
  802be3:	68 9f 45 80 00       	push   $0x80459f
  802be8:	68 58 01 00 00       	push   $0x158
  802bed:	68 bd 45 80 00       	push   $0x8045bd
  802bf2:	e8 aa d6 ff ff       	call   8002a1 <_panic>
  802bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfa:	8b 00                	mov    (%eax),%eax
  802bfc:	85 c0                	test   %eax,%eax
  802bfe:	74 10                	je     802c10 <alloc_block_BF+0x493>
  802c00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c03:	8b 00                	mov    (%eax),%eax
  802c05:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c08:	8b 52 04             	mov    0x4(%edx),%edx
  802c0b:	89 50 04             	mov    %edx,0x4(%eax)
  802c0e:	eb 0b                	jmp    802c1b <alloc_block_BF+0x49e>
  802c10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c13:	8b 40 04             	mov    0x4(%eax),%eax
  802c16:	a3 34 50 80 00       	mov    %eax,0x805034
  802c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1e:	8b 40 04             	mov    0x4(%eax),%eax
  802c21:	85 c0                	test   %eax,%eax
  802c23:	74 0f                	je     802c34 <alloc_block_BF+0x4b7>
  802c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c28:	8b 40 04             	mov    0x4(%eax),%eax
  802c2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c2e:	8b 12                	mov    (%edx),%edx
  802c30:	89 10                	mov    %edx,(%eax)
  802c32:	eb 0a                	jmp    802c3e <alloc_block_BF+0x4c1>
  802c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c37:	8b 00                	mov    (%eax),%eax
  802c39:	a3 30 50 80 00       	mov    %eax,0x805030
  802c3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c51:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c56:	48                   	dec    %eax
  802c57:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  802c5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5f:	e9 fc 00 00 00       	jmp    802d60 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c64:	8b 45 08             	mov    0x8(%ebp),%eax
  802c67:	83 c0 08             	add    $0x8,%eax
  802c6a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c6d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c74:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c77:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c7a:	01 d0                	add    %edx,%eax
  802c7c:	48                   	dec    %eax
  802c7d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c80:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c83:	ba 00 00 00 00       	mov    $0x0,%edx
  802c88:	f7 75 c4             	divl   -0x3c(%ebp)
  802c8b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c8e:	29 d0                	sub    %edx,%eax
  802c90:	c1 e8 0c             	shr    $0xc,%eax
  802c93:	83 ec 0c             	sub    $0xc,%esp
  802c96:	50                   	push   %eax
  802c97:	e8 5c e6 ff ff       	call   8012f8 <sbrk>
  802c9c:	83 c4 10             	add    $0x10,%esp
  802c9f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802ca2:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802ca6:	75 0a                	jne    802cb2 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802ca8:	b8 00 00 00 00       	mov    $0x0,%eax
  802cad:	e9 ae 00 00 00       	jmp    802d60 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802cb2:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802cb9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cbc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802cbf:	01 d0                	add    %edx,%eax
  802cc1:	48                   	dec    %eax
  802cc2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802cc5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cc8:	ba 00 00 00 00       	mov    $0x0,%edx
  802ccd:	f7 75 b8             	divl   -0x48(%ebp)
  802cd0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cd3:	29 d0                	sub    %edx,%eax
  802cd5:	8d 50 fc             	lea    -0x4(%eax),%edx
  802cd8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802cdb:	01 d0                	add    %edx,%eax
  802cdd:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  802ce2:	a1 44 50 80 00       	mov    0x805044,%eax
  802ce7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802ced:	83 ec 0c             	sub    $0xc,%esp
  802cf0:	68 64 46 80 00       	push   $0x804664
  802cf5:	e8 64 d8 ff ff       	call   80055e <cprintf>
  802cfa:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802cfd:	83 ec 08             	sub    $0x8,%esp
  802d00:	ff 75 bc             	pushl  -0x44(%ebp)
  802d03:	68 69 46 80 00       	push   $0x804669
  802d08:	e8 51 d8 ff ff       	call   80055e <cprintf>
  802d0d:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d10:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d17:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d1a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d1d:	01 d0                	add    %edx,%eax
  802d1f:	48                   	dec    %eax
  802d20:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d23:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d26:	ba 00 00 00 00       	mov    $0x0,%edx
  802d2b:	f7 75 b0             	divl   -0x50(%ebp)
  802d2e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d31:	29 d0                	sub    %edx,%eax
  802d33:	83 ec 04             	sub    $0x4,%esp
  802d36:	6a 01                	push   $0x1
  802d38:	50                   	push   %eax
  802d39:	ff 75 bc             	pushl  -0x44(%ebp)
  802d3c:	e8 51 f5 ff ff       	call   802292 <set_block_data>
  802d41:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d44:	83 ec 0c             	sub    $0xc,%esp
  802d47:	ff 75 bc             	pushl  -0x44(%ebp)
  802d4a:	e8 36 04 00 00       	call   803185 <free_block>
  802d4f:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d52:	83 ec 0c             	sub    $0xc,%esp
  802d55:	ff 75 08             	pushl  0x8(%ebp)
  802d58:	e8 20 fa ff ff       	call   80277d <alloc_block_BF>
  802d5d:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d60:	c9                   	leave  
  802d61:	c3                   	ret    

00802d62 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d62:	55                   	push   %ebp
  802d63:	89 e5                	mov    %esp,%ebp
  802d65:	53                   	push   %ebx
  802d66:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d70:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d7b:	74 1e                	je     802d9b <merging+0x39>
  802d7d:	ff 75 08             	pushl  0x8(%ebp)
  802d80:	e8 bc f1 ff ff       	call   801f41 <get_block_size>
  802d85:	83 c4 04             	add    $0x4,%esp
  802d88:	89 c2                	mov    %eax,%edx
  802d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8d:	01 d0                	add    %edx,%eax
  802d8f:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d92:	75 07                	jne    802d9b <merging+0x39>
		prev_is_free = 1;
  802d94:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802d9b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d9f:	74 1e                	je     802dbf <merging+0x5d>
  802da1:	ff 75 10             	pushl  0x10(%ebp)
  802da4:	e8 98 f1 ff ff       	call   801f41 <get_block_size>
  802da9:	83 c4 04             	add    $0x4,%esp
  802dac:	89 c2                	mov    %eax,%edx
  802dae:	8b 45 10             	mov    0x10(%ebp),%eax
  802db1:	01 d0                	add    %edx,%eax
  802db3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802db6:	75 07                	jne    802dbf <merging+0x5d>
		next_is_free = 1;
  802db8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802dbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc3:	0f 84 cc 00 00 00    	je     802e95 <merging+0x133>
  802dc9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dcd:	0f 84 c2 00 00 00    	je     802e95 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802dd3:	ff 75 08             	pushl  0x8(%ebp)
  802dd6:	e8 66 f1 ff ff       	call   801f41 <get_block_size>
  802ddb:	83 c4 04             	add    $0x4,%esp
  802dde:	89 c3                	mov    %eax,%ebx
  802de0:	ff 75 10             	pushl  0x10(%ebp)
  802de3:	e8 59 f1 ff ff       	call   801f41 <get_block_size>
  802de8:	83 c4 04             	add    $0x4,%esp
  802deb:	01 c3                	add    %eax,%ebx
  802ded:	ff 75 0c             	pushl  0xc(%ebp)
  802df0:	e8 4c f1 ff ff       	call   801f41 <get_block_size>
  802df5:	83 c4 04             	add    $0x4,%esp
  802df8:	01 d8                	add    %ebx,%eax
  802dfa:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802dfd:	6a 00                	push   $0x0
  802dff:	ff 75 ec             	pushl  -0x14(%ebp)
  802e02:	ff 75 08             	pushl  0x8(%ebp)
  802e05:	e8 88 f4 ff ff       	call   802292 <set_block_data>
  802e0a:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e11:	75 17                	jne    802e2a <merging+0xc8>
  802e13:	83 ec 04             	sub    $0x4,%esp
  802e16:	68 9f 45 80 00       	push   $0x80459f
  802e1b:	68 7d 01 00 00       	push   $0x17d
  802e20:	68 bd 45 80 00       	push   $0x8045bd
  802e25:	e8 77 d4 ff ff       	call   8002a1 <_panic>
  802e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e2d:	8b 00                	mov    (%eax),%eax
  802e2f:	85 c0                	test   %eax,%eax
  802e31:	74 10                	je     802e43 <merging+0xe1>
  802e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e36:	8b 00                	mov    (%eax),%eax
  802e38:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e3b:	8b 52 04             	mov    0x4(%edx),%edx
  802e3e:	89 50 04             	mov    %edx,0x4(%eax)
  802e41:	eb 0b                	jmp    802e4e <merging+0xec>
  802e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e46:	8b 40 04             	mov    0x4(%eax),%eax
  802e49:	a3 34 50 80 00       	mov    %eax,0x805034
  802e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e51:	8b 40 04             	mov    0x4(%eax),%eax
  802e54:	85 c0                	test   %eax,%eax
  802e56:	74 0f                	je     802e67 <merging+0x105>
  802e58:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e5b:	8b 40 04             	mov    0x4(%eax),%eax
  802e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e61:	8b 12                	mov    (%edx),%edx
  802e63:	89 10                	mov    %edx,(%eax)
  802e65:	eb 0a                	jmp    802e71 <merging+0x10f>
  802e67:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e6a:	8b 00                	mov    (%eax),%eax
  802e6c:	a3 30 50 80 00       	mov    %eax,0x805030
  802e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e84:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e89:	48                   	dec    %eax
  802e8a:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e8f:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e90:	e9 ea 02 00 00       	jmp    80317f <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e99:	74 3b                	je     802ed6 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802e9b:	83 ec 0c             	sub    $0xc,%esp
  802e9e:	ff 75 08             	pushl  0x8(%ebp)
  802ea1:	e8 9b f0 ff ff       	call   801f41 <get_block_size>
  802ea6:	83 c4 10             	add    $0x10,%esp
  802ea9:	89 c3                	mov    %eax,%ebx
  802eab:	83 ec 0c             	sub    $0xc,%esp
  802eae:	ff 75 10             	pushl  0x10(%ebp)
  802eb1:	e8 8b f0 ff ff       	call   801f41 <get_block_size>
  802eb6:	83 c4 10             	add    $0x10,%esp
  802eb9:	01 d8                	add    %ebx,%eax
  802ebb:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ebe:	83 ec 04             	sub    $0x4,%esp
  802ec1:	6a 00                	push   $0x0
  802ec3:	ff 75 e8             	pushl  -0x18(%ebp)
  802ec6:	ff 75 08             	pushl  0x8(%ebp)
  802ec9:	e8 c4 f3 ff ff       	call   802292 <set_block_data>
  802ece:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ed1:	e9 a9 02 00 00       	jmp    80317f <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802ed6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eda:	0f 84 2d 01 00 00    	je     80300d <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802ee0:	83 ec 0c             	sub    $0xc,%esp
  802ee3:	ff 75 10             	pushl  0x10(%ebp)
  802ee6:	e8 56 f0 ff ff       	call   801f41 <get_block_size>
  802eeb:	83 c4 10             	add    $0x10,%esp
  802eee:	89 c3                	mov    %eax,%ebx
  802ef0:	83 ec 0c             	sub    $0xc,%esp
  802ef3:	ff 75 0c             	pushl  0xc(%ebp)
  802ef6:	e8 46 f0 ff ff       	call   801f41 <get_block_size>
  802efb:	83 c4 10             	add    $0x10,%esp
  802efe:	01 d8                	add    %ebx,%eax
  802f00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f03:	83 ec 04             	sub    $0x4,%esp
  802f06:	6a 00                	push   $0x0
  802f08:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f0b:	ff 75 10             	pushl  0x10(%ebp)
  802f0e:	e8 7f f3 ff ff       	call   802292 <set_block_data>
  802f13:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f16:	8b 45 10             	mov    0x10(%ebp),%eax
  802f19:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f1c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f20:	74 06                	je     802f28 <merging+0x1c6>
  802f22:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f26:	75 17                	jne    802f3f <merging+0x1dd>
  802f28:	83 ec 04             	sub    $0x4,%esp
  802f2b:	68 78 46 80 00       	push   $0x804678
  802f30:	68 8d 01 00 00       	push   $0x18d
  802f35:	68 bd 45 80 00       	push   $0x8045bd
  802f3a:	e8 62 d3 ff ff       	call   8002a1 <_panic>
  802f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f42:	8b 50 04             	mov    0x4(%eax),%edx
  802f45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f48:	89 50 04             	mov    %edx,0x4(%eax)
  802f4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f51:	89 10                	mov    %edx,(%eax)
  802f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f56:	8b 40 04             	mov    0x4(%eax),%eax
  802f59:	85 c0                	test   %eax,%eax
  802f5b:	74 0d                	je     802f6a <merging+0x208>
  802f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f60:	8b 40 04             	mov    0x4(%eax),%eax
  802f63:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f66:	89 10                	mov    %edx,(%eax)
  802f68:	eb 08                	jmp    802f72 <merging+0x210>
  802f6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f6d:	a3 30 50 80 00       	mov    %eax,0x805030
  802f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f75:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f78:	89 50 04             	mov    %edx,0x4(%eax)
  802f7b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f80:	40                   	inc    %eax
  802f81:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  802f86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f8a:	75 17                	jne    802fa3 <merging+0x241>
  802f8c:	83 ec 04             	sub    $0x4,%esp
  802f8f:	68 9f 45 80 00       	push   $0x80459f
  802f94:	68 8e 01 00 00       	push   $0x18e
  802f99:	68 bd 45 80 00       	push   $0x8045bd
  802f9e:	e8 fe d2 ff ff       	call   8002a1 <_panic>
  802fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa6:	8b 00                	mov    (%eax),%eax
  802fa8:	85 c0                	test   %eax,%eax
  802faa:	74 10                	je     802fbc <merging+0x25a>
  802fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  802faf:	8b 00                	mov    (%eax),%eax
  802fb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fb4:	8b 52 04             	mov    0x4(%edx),%edx
  802fb7:	89 50 04             	mov    %edx,0x4(%eax)
  802fba:	eb 0b                	jmp    802fc7 <merging+0x265>
  802fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fbf:	8b 40 04             	mov    0x4(%eax),%eax
  802fc2:	a3 34 50 80 00       	mov    %eax,0x805034
  802fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fca:	8b 40 04             	mov    0x4(%eax),%eax
  802fcd:	85 c0                	test   %eax,%eax
  802fcf:	74 0f                	je     802fe0 <merging+0x27e>
  802fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd4:	8b 40 04             	mov    0x4(%eax),%eax
  802fd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fda:	8b 12                	mov    (%edx),%edx
  802fdc:	89 10                	mov    %edx,(%eax)
  802fde:	eb 0a                	jmp    802fea <merging+0x288>
  802fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe3:	8b 00                	mov    (%eax),%eax
  802fe5:	a3 30 50 80 00       	mov    %eax,0x805030
  802fea:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ffd:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803002:	48                   	dec    %eax
  803003:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803008:	e9 72 01 00 00       	jmp    80317f <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80300d:	8b 45 10             	mov    0x10(%ebp),%eax
  803010:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803013:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803017:	74 79                	je     803092 <merging+0x330>
  803019:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80301d:	74 73                	je     803092 <merging+0x330>
  80301f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803023:	74 06                	je     80302b <merging+0x2c9>
  803025:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803029:	75 17                	jne    803042 <merging+0x2e0>
  80302b:	83 ec 04             	sub    $0x4,%esp
  80302e:	68 30 46 80 00       	push   $0x804630
  803033:	68 94 01 00 00       	push   $0x194
  803038:	68 bd 45 80 00       	push   $0x8045bd
  80303d:	e8 5f d2 ff ff       	call   8002a1 <_panic>
  803042:	8b 45 08             	mov    0x8(%ebp),%eax
  803045:	8b 10                	mov    (%eax),%edx
  803047:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80304a:	89 10                	mov    %edx,(%eax)
  80304c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80304f:	8b 00                	mov    (%eax),%eax
  803051:	85 c0                	test   %eax,%eax
  803053:	74 0b                	je     803060 <merging+0x2fe>
  803055:	8b 45 08             	mov    0x8(%ebp),%eax
  803058:	8b 00                	mov    (%eax),%eax
  80305a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80305d:	89 50 04             	mov    %edx,0x4(%eax)
  803060:	8b 45 08             	mov    0x8(%ebp),%eax
  803063:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803066:	89 10                	mov    %edx,(%eax)
  803068:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80306b:	8b 55 08             	mov    0x8(%ebp),%edx
  80306e:	89 50 04             	mov    %edx,0x4(%eax)
  803071:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803074:	8b 00                	mov    (%eax),%eax
  803076:	85 c0                	test   %eax,%eax
  803078:	75 08                	jne    803082 <merging+0x320>
  80307a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80307d:	a3 34 50 80 00       	mov    %eax,0x805034
  803082:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803087:	40                   	inc    %eax
  803088:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80308d:	e9 ce 00 00 00       	jmp    803160 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803092:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803096:	74 65                	je     8030fd <merging+0x39b>
  803098:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80309c:	75 17                	jne    8030b5 <merging+0x353>
  80309e:	83 ec 04             	sub    $0x4,%esp
  8030a1:	68 0c 46 80 00       	push   $0x80460c
  8030a6:	68 95 01 00 00       	push   $0x195
  8030ab:	68 bd 45 80 00       	push   $0x8045bd
  8030b0:	e8 ec d1 ff ff       	call   8002a1 <_panic>
  8030b5:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8030bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030be:	89 50 04             	mov    %edx,0x4(%eax)
  8030c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c4:	8b 40 04             	mov    0x4(%eax),%eax
  8030c7:	85 c0                	test   %eax,%eax
  8030c9:	74 0c                	je     8030d7 <merging+0x375>
  8030cb:	a1 34 50 80 00       	mov    0x805034,%eax
  8030d0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030d3:	89 10                	mov    %edx,(%eax)
  8030d5:	eb 08                	jmp    8030df <merging+0x37d>
  8030d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030da:	a3 30 50 80 00       	mov    %eax,0x805030
  8030df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e2:	a3 34 50 80 00       	mov    %eax,0x805034
  8030e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030f0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030f5:	40                   	inc    %eax
  8030f6:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8030fb:	eb 63                	jmp    803160 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8030fd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803101:	75 17                	jne    80311a <merging+0x3b8>
  803103:	83 ec 04             	sub    $0x4,%esp
  803106:	68 d8 45 80 00       	push   $0x8045d8
  80310b:	68 98 01 00 00       	push   $0x198
  803110:	68 bd 45 80 00       	push   $0x8045bd
  803115:	e8 87 d1 ff ff       	call   8002a1 <_panic>
  80311a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803120:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803123:	89 10                	mov    %edx,(%eax)
  803125:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803128:	8b 00                	mov    (%eax),%eax
  80312a:	85 c0                	test   %eax,%eax
  80312c:	74 0d                	je     80313b <merging+0x3d9>
  80312e:	a1 30 50 80 00       	mov    0x805030,%eax
  803133:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803136:	89 50 04             	mov    %edx,0x4(%eax)
  803139:	eb 08                	jmp    803143 <merging+0x3e1>
  80313b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80313e:	a3 34 50 80 00       	mov    %eax,0x805034
  803143:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803146:	a3 30 50 80 00       	mov    %eax,0x805030
  80314b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80314e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803155:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80315a:	40                   	inc    %eax
  80315b:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  803160:	83 ec 0c             	sub    $0xc,%esp
  803163:	ff 75 10             	pushl  0x10(%ebp)
  803166:	e8 d6 ed ff ff       	call   801f41 <get_block_size>
  80316b:	83 c4 10             	add    $0x10,%esp
  80316e:	83 ec 04             	sub    $0x4,%esp
  803171:	6a 00                	push   $0x0
  803173:	50                   	push   %eax
  803174:	ff 75 10             	pushl  0x10(%ebp)
  803177:	e8 16 f1 ff ff       	call   802292 <set_block_data>
  80317c:	83 c4 10             	add    $0x10,%esp
	}
}
  80317f:	90                   	nop
  803180:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803183:	c9                   	leave  
  803184:	c3                   	ret    

00803185 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803185:	55                   	push   %ebp
  803186:	89 e5                	mov    %esp,%ebp
  803188:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80318b:	a1 30 50 80 00       	mov    0x805030,%eax
  803190:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803193:	a1 34 50 80 00       	mov    0x805034,%eax
  803198:	3b 45 08             	cmp    0x8(%ebp),%eax
  80319b:	73 1b                	jae    8031b8 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80319d:	a1 34 50 80 00       	mov    0x805034,%eax
  8031a2:	83 ec 04             	sub    $0x4,%esp
  8031a5:	ff 75 08             	pushl  0x8(%ebp)
  8031a8:	6a 00                	push   $0x0
  8031aa:	50                   	push   %eax
  8031ab:	e8 b2 fb ff ff       	call   802d62 <merging>
  8031b0:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031b3:	e9 8b 00 00 00       	jmp    803243 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8031b8:	a1 30 50 80 00       	mov    0x805030,%eax
  8031bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031c0:	76 18                	jbe    8031da <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8031c2:	a1 30 50 80 00       	mov    0x805030,%eax
  8031c7:	83 ec 04             	sub    $0x4,%esp
  8031ca:	ff 75 08             	pushl  0x8(%ebp)
  8031cd:	50                   	push   %eax
  8031ce:	6a 00                	push   $0x0
  8031d0:	e8 8d fb ff ff       	call   802d62 <merging>
  8031d5:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031d8:	eb 69                	jmp    803243 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031da:	a1 30 50 80 00       	mov    0x805030,%eax
  8031df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031e2:	eb 39                	jmp    80321d <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8031e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031ea:	73 29                	jae    803215 <free_block+0x90>
  8031ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ef:	8b 00                	mov    (%eax),%eax
  8031f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031f4:	76 1f                	jbe    803215 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8031f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f9:	8b 00                	mov    (%eax),%eax
  8031fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8031fe:	83 ec 04             	sub    $0x4,%esp
  803201:	ff 75 08             	pushl  0x8(%ebp)
  803204:	ff 75 f0             	pushl  -0x10(%ebp)
  803207:	ff 75 f4             	pushl  -0xc(%ebp)
  80320a:	e8 53 fb ff ff       	call   802d62 <merging>
  80320f:	83 c4 10             	add    $0x10,%esp
			break;
  803212:	90                   	nop
		}
	}
}
  803213:	eb 2e                	jmp    803243 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803215:	a1 38 50 80 00       	mov    0x805038,%eax
  80321a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80321d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803221:	74 07                	je     80322a <free_block+0xa5>
  803223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803226:	8b 00                	mov    (%eax),%eax
  803228:	eb 05                	jmp    80322f <free_block+0xaa>
  80322a:	b8 00 00 00 00       	mov    $0x0,%eax
  80322f:	a3 38 50 80 00       	mov    %eax,0x805038
  803234:	a1 38 50 80 00       	mov    0x805038,%eax
  803239:	85 c0                	test   %eax,%eax
  80323b:	75 a7                	jne    8031e4 <free_block+0x5f>
  80323d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803241:	75 a1                	jne    8031e4 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803243:	90                   	nop
  803244:	c9                   	leave  
  803245:	c3                   	ret    

00803246 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803246:	55                   	push   %ebp
  803247:	89 e5                	mov    %esp,%ebp
  803249:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80324c:	ff 75 08             	pushl  0x8(%ebp)
  80324f:	e8 ed ec ff ff       	call   801f41 <get_block_size>
  803254:	83 c4 04             	add    $0x4,%esp
  803257:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80325a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803261:	eb 17                	jmp    80327a <copy_data+0x34>
  803263:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803266:	8b 45 0c             	mov    0xc(%ebp),%eax
  803269:	01 c2                	add    %eax,%edx
  80326b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80326e:	8b 45 08             	mov    0x8(%ebp),%eax
  803271:	01 c8                	add    %ecx,%eax
  803273:	8a 00                	mov    (%eax),%al
  803275:	88 02                	mov    %al,(%edx)
  803277:	ff 45 fc             	incl   -0x4(%ebp)
  80327a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80327d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803280:	72 e1                	jb     803263 <copy_data+0x1d>
}
  803282:	90                   	nop
  803283:	c9                   	leave  
  803284:	c3                   	ret    

00803285 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803285:	55                   	push   %ebp
  803286:	89 e5                	mov    %esp,%ebp
  803288:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80328b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80328f:	75 23                	jne    8032b4 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803291:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803295:	74 13                	je     8032aa <realloc_block_FF+0x25>
  803297:	83 ec 0c             	sub    $0xc,%esp
  80329a:	ff 75 0c             	pushl  0xc(%ebp)
  80329d:	e8 1f f0 ff ff       	call   8022c1 <alloc_block_FF>
  8032a2:	83 c4 10             	add    $0x10,%esp
  8032a5:	e9 f4 06 00 00       	jmp    80399e <realloc_block_FF+0x719>
		return NULL;
  8032aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8032af:	e9 ea 06 00 00       	jmp    80399e <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8032b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032b8:	75 18                	jne    8032d2 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8032ba:	83 ec 0c             	sub    $0xc,%esp
  8032bd:	ff 75 08             	pushl  0x8(%ebp)
  8032c0:	e8 c0 fe ff ff       	call   803185 <free_block>
  8032c5:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8032c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8032cd:	e9 cc 06 00 00       	jmp    80399e <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8032d2:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8032d6:	77 07                	ja     8032df <realloc_block_FF+0x5a>
  8032d8:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8032df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032e2:	83 e0 01             	and    $0x1,%eax
  8032e5:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8032e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032eb:	83 c0 08             	add    $0x8,%eax
  8032ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8032f1:	83 ec 0c             	sub    $0xc,%esp
  8032f4:	ff 75 08             	pushl  0x8(%ebp)
  8032f7:	e8 45 ec ff ff       	call   801f41 <get_block_size>
  8032fc:	83 c4 10             	add    $0x10,%esp
  8032ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803302:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803305:	83 e8 08             	sub    $0x8,%eax
  803308:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80330b:	8b 45 08             	mov    0x8(%ebp),%eax
  80330e:	83 e8 04             	sub    $0x4,%eax
  803311:	8b 00                	mov    (%eax),%eax
  803313:	83 e0 fe             	and    $0xfffffffe,%eax
  803316:	89 c2                	mov    %eax,%edx
  803318:	8b 45 08             	mov    0x8(%ebp),%eax
  80331b:	01 d0                	add    %edx,%eax
  80331d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803320:	83 ec 0c             	sub    $0xc,%esp
  803323:	ff 75 e4             	pushl  -0x1c(%ebp)
  803326:	e8 16 ec ff ff       	call   801f41 <get_block_size>
  80332b:	83 c4 10             	add    $0x10,%esp
  80332e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803331:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803334:	83 e8 08             	sub    $0x8,%eax
  803337:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80333a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80333d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803340:	75 08                	jne    80334a <realloc_block_FF+0xc5>
	{
		 return va;
  803342:	8b 45 08             	mov    0x8(%ebp),%eax
  803345:	e9 54 06 00 00       	jmp    80399e <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80334a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80334d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803350:	0f 83 e5 03 00 00    	jae    80373b <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803356:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803359:	2b 45 0c             	sub    0xc(%ebp),%eax
  80335c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80335f:	83 ec 0c             	sub    $0xc,%esp
  803362:	ff 75 e4             	pushl  -0x1c(%ebp)
  803365:	e8 f0 eb ff ff       	call   801f5a <is_free_block>
  80336a:	83 c4 10             	add    $0x10,%esp
  80336d:	84 c0                	test   %al,%al
  80336f:	0f 84 3b 01 00 00    	je     8034b0 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803375:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803378:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80337b:	01 d0                	add    %edx,%eax
  80337d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803380:	83 ec 04             	sub    $0x4,%esp
  803383:	6a 01                	push   $0x1
  803385:	ff 75 f0             	pushl  -0x10(%ebp)
  803388:	ff 75 08             	pushl  0x8(%ebp)
  80338b:	e8 02 ef ff ff       	call   802292 <set_block_data>
  803390:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803393:	8b 45 08             	mov    0x8(%ebp),%eax
  803396:	83 e8 04             	sub    $0x4,%eax
  803399:	8b 00                	mov    (%eax),%eax
  80339b:	83 e0 fe             	and    $0xfffffffe,%eax
  80339e:	89 c2                	mov    %eax,%edx
  8033a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a3:	01 d0                	add    %edx,%eax
  8033a5:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8033a8:	83 ec 04             	sub    $0x4,%esp
  8033ab:	6a 00                	push   $0x0
  8033ad:	ff 75 cc             	pushl  -0x34(%ebp)
  8033b0:	ff 75 c8             	pushl  -0x38(%ebp)
  8033b3:	e8 da ee ff ff       	call   802292 <set_block_data>
  8033b8:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8033bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033bf:	74 06                	je     8033c7 <realloc_block_FF+0x142>
  8033c1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8033c5:	75 17                	jne    8033de <realloc_block_FF+0x159>
  8033c7:	83 ec 04             	sub    $0x4,%esp
  8033ca:	68 30 46 80 00       	push   $0x804630
  8033cf:	68 f6 01 00 00       	push   $0x1f6
  8033d4:	68 bd 45 80 00       	push   $0x8045bd
  8033d9:	e8 c3 ce ff ff       	call   8002a1 <_panic>
  8033de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e1:	8b 10                	mov    (%eax),%edx
  8033e3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033e6:	89 10                	mov    %edx,(%eax)
  8033e8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033eb:	8b 00                	mov    (%eax),%eax
  8033ed:	85 c0                	test   %eax,%eax
  8033ef:	74 0b                	je     8033fc <realloc_block_FF+0x177>
  8033f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f4:	8b 00                	mov    (%eax),%eax
  8033f6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033f9:	89 50 04             	mov    %edx,0x4(%eax)
  8033fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ff:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803402:	89 10                	mov    %edx,(%eax)
  803404:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803407:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80340a:	89 50 04             	mov    %edx,0x4(%eax)
  80340d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803410:	8b 00                	mov    (%eax),%eax
  803412:	85 c0                	test   %eax,%eax
  803414:	75 08                	jne    80341e <realloc_block_FF+0x199>
  803416:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803419:	a3 34 50 80 00       	mov    %eax,0x805034
  80341e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803423:	40                   	inc    %eax
  803424:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803429:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80342d:	75 17                	jne    803446 <realloc_block_FF+0x1c1>
  80342f:	83 ec 04             	sub    $0x4,%esp
  803432:	68 9f 45 80 00       	push   $0x80459f
  803437:	68 f7 01 00 00       	push   $0x1f7
  80343c:	68 bd 45 80 00       	push   $0x8045bd
  803441:	e8 5b ce ff ff       	call   8002a1 <_panic>
  803446:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803449:	8b 00                	mov    (%eax),%eax
  80344b:	85 c0                	test   %eax,%eax
  80344d:	74 10                	je     80345f <realloc_block_FF+0x1da>
  80344f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803452:	8b 00                	mov    (%eax),%eax
  803454:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803457:	8b 52 04             	mov    0x4(%edx),%edx
  80345a:	89 50 04             	mov    %edx,0x4(%eax)
  80345d:	eb 0b                	jmp    80346a <realloc_block_FF+0x1e5>
  80345f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803462:	8b 40 04             	mov    0x4(%eax),%eax
  803465:	a3 34 50 80 00       	mov    %eax,0x805034
  80346a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80346d:	8b 40 04             	mov    0x4(%eax),%eax
  803470:	85 c0                	test   %eax,%eax
  803472:	74 0f                	je     803483 <realloc_block_FF+0x1fe>
  803474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803477:	8b 40 04             	mov    0x4(%eax),%eax
  80347a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80347d:	8b 12                	mov    (%edx),%edx
  80347f:	89 10                	mov    %edx,(%eax)
  803481:	eb 0a                	jmp    80348d <realloc_block_FF+0x208>
  803483:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803486:	8b 00                	mov    (%eax),%eax
  803488:	a3 30 50 80 00       	mov    %eax,0x805030
  80348d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803490:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803496:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803499:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034a0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8034a5:	48                   	dec    %eax
  8034a6:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8034ab:	e9 83 02 00 00       	jmp    803733 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8034b0:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8034b4:	0f 86 69 02 00 00    	jbe    803723 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8034ba:	83 ec 04             	sub    $0x4,%esp
  8034bd:	6a 01                	push   $0x1
  8034bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8034c2:	ff 75 08             	pushl  0x8(%ebp)
  8034c5:	e8 c8 ed ff ff       	call   802292 <set_block_data>
  8034ca:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8034cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d0:	83 e8 04             	sub    $0x4,%eax
  8034d3:	8b 00                	mov    (%eax),%eax
  8034d5:	83 e0 fe             	and    $0xfffffffe,%eax
  8034d8:	89 c2                	mov    %eax,%edx
  8034da:	8b 45 08             	mov    0x8(%ebp),%eax
  8034dd:	01 d0                	add    %edx,%eax
  8034df:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8034e2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8034e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8034ea:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8034ee:	75 68                	jne    803558 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034f0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034f4:	75 17                	jne    80350d <realloc_block_FF+0x288>
  8034f6:	83 ec 04             	sub    $0x4,%esp
  8034f9:	68 d8 45 80 00       	push   $0x8045d8
  8034fe:	68 06 02 00 00       	push   $0x206
  803503:	68 bd 45 80 00       	push   $0x8045bd
  803508:	e8 94 cd ff ff       	call   8002a1 <_panic>
  80350d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803513:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803516:	89 10                	mov    %edx,(%eax)
  803518:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80351b:	8b 00                	mov    (%eax),%eax
  80351d:	85 c0                	test   %eax,%eax
  80351f:	74 0d                	je     80352e <realloc_block_FF+0x2a9>
  803521:	a1 30 50 80 00       	mov    0x805030,%eax
  803526:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803529:	89 50 04             	mov    %edx,0x4(%eax)
  80352c:	eb 08                	jmp    803536 <realloc_block_FF+0x2b1>
  80352e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803531:	a3 34 50 80 00       	mov    %eax,0x805034
  803536:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803539:	a3 30 50 80 00       	mov    %eax,0x805030
  80353e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803541:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803548:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80354d:	40                   	inc    %eax
  80354e:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803553:	e9 b0 01 00 00       	jmp    803708 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803558:	a1 30 50 80 00       	mov    0x805030,%eax
  80355d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803560:	76 68                	jbe    8035ca <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803562:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803566:	75 17                	jne    80357f <realloc_block_FF+0x2fa>
  803568:	83 ec 04             	sub    $0x4,%esp
  80356b:	68 d8 45 80 00       	push   $0x8045d8
  803570:	68 0b 02 00 00       	push   $0x20b
  803575:	68 bd 45 80 00       	push   $0x8045bd
  80357a:	e8 22 cd ff ff       	call   8002a1 <_panic>
  80357f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803585:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803588:	89 10                	mov    %edx,(%eax)
  80358a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80358d:	8b 00                	mov    (%eax),%eax
  80358f:	85 c0                	test   %eax,%eax
  803591:	74 0d                	je     8035a0 <realloc_block_FF+0x31b>
  803593:	a1 30 50 80 00       	mov    0x805030,%eax
  803598:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80359b:	89 50 04             	mov    %edx,0x4(%eax)
  80359e:	eb 08                	jmp    8035a8 <realloc_block_FF+0x323>
  8035a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a3:	a3 34 50 80 00       	mov    %eax,0x805034
  8035a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ab:	a3 30 50 80 00       	mov    %eax,0x805030
  8035b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ba:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035bf:	40                   	inc    %eax
  8035c0:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8035c5:	e9 3e 01 00 00       	jmp    803708 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8035ca:	a1 30 50 80 00       	mov    0x805030,%eax
  8035cf:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035d2:	73 68                	jae    80363c <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035d4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035d8:	75 17                	jne    8035f1 <realloc_block_FF+0x36c>
  8035da:	83 ec 04             	sub    $0x4,%esp
  8035dd:	68 0c 46 80 00       	push   $0x80460c
  8035e2:	68 10 02 00 00       	push   $0x210
  8035e7:	68 bd 45 80 00       	push   $0x8045bd
  8035ec:	e8 b0 cc ff ff       	call   8002a1 <_panic>
  8035f1:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8035f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035fa:	89 50 04             	mov    %edx,0x4(%eax)
  8035fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803600:	8b 40 04             	mov    0x4(%eax),%eax
  803603:	85 c0                	test   %eax,%eax
  803605:	74 0c                	je     803613 <realloc_block_FF+0x38e>
  803607:	a1 34 50 80 00       	mov    0x805034,%eax
  80360c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80360f:	89 10                	mov    %edx,(%eax)
  803611:	eb 08                	jmp    80361b <realloc_block_FF+0x396>
  803613:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803616:	a3 30 50 80 00       	mov    %eax,0x805030
  80361b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80361e:	a3 34 50 80 00       	mov    %eax,0x805034
  803623:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803626:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80362c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803631:	40                   	inc    %eax
  803632:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803637:	e9 cc 00 00 00       	jmp    803708 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80363c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803643:	a1 30 50 80 00       	mov    0x805030,%eax
  803648:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80364b:	e9 8a 00 00 00       	jmp    8036da <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803653:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803656:	73 7a                	jae    8036d2 <realloc_block_FF+0x44d>
  803658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365b:	8b 00                	mov    (%eax),%eax
  80365d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803660:	73 70                	jae    8036d2 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803662:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803666:	74 06                	je     80366e <realloc_block_FF+0x3e9>
  803668:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80366c:	75 17                	jne    803685 <realloc_block_FF+0x400>
  80366e:	83 ec 04             	sub    $0x4,%esp
  803671:	68 30 46 80 00       	push   $0x804630
  803676:	68 1a 02 00 00       	push   $0x21a
  80367b:	68 bd 45 80 00       	push   $0x8045bd
  803680:	e8 1c cc ff ff       	call   8002a1 <_panic>
  803685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803688:	8b 10                	mov    (%eax),%edx
  80368a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80368d:	89 10                	mov    %edx,(%eax)
  80368f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803692:	8b 00                	mov    (%eax),%eax
  803694:	85 c0                	test   %eax,%eax
  803696:	74 0b                	je     8036a3 <realloc_block_FF+0x41e>
  803698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369b:	8b 00                	mov    (%eax),%eax
  80369d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036a0:	89 50 04             	mov    %edx,0x4(%eax)
  8036a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036a9:	89 10                	mov    %edx,(%eax)
  8036ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036b1:	89 50 04             	mov    %edx,0x4(%eax)
  8036b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b7:	8b 00                	mov    (%eax),%eax
  8036b9:	85 c0                	test   %eax,%eax
  8036bb:	75 08                	jne    8036c5 <realloc_block_FF+0x440>
  8036bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c0:	a3 34 50 80 00       	mov    %eax,0x805034
  8036c5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036ca:	40                   	inc    %eax
  8036cb:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  8036d0:	eb 36                	jmp    803708 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8036d2:	a1 38 50 80 00       	mov    0x805038,%eax
  8036d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036de:	74 07                	je     8036e7 <realloc_block_FF+0x462>
  8036e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e3:	8b 00                	mov    (%eax),%eax
  8036e5:	eb 05                	jmp    8036ec <realloc_block_FF+0x467>
  8036e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8036ec:	a3 38 50 80 00       	mov    %eax,0x805038
  8036f1:	a1 38 50 80 00       	mov    0x805038,%eax
  8036f6:	85 c0                	test   %eax,%eax
  8036f8:	0f 85 52 ff ff ff    	jne    803650 <realloc_block_FF+0x3cb>
  8036fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803702:	0f 85 48 ff ff ff    	jne    803650 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803708:	83 ec 04             	sub    $0x4,%esp
  80370b:	6a 00                	push   $0x0
  80370d:	ff 75 d8             	pushl  -0x28(%ebp)
  803710:	ff 75 d4             	pushl  -0x2c(%ebp)
  803713:	e8 7a eb ff ff       	call   802292 <set_block_data>
  803718:	83 c4 10             	add    $0x10,%esp
				return va;
  80371b:	8b 45 08             	mov    0x8(%ebp),%eax
  80371e:	e9 7b 02 00 00       	jmp    80399e <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803723:	83 ec 0c             	sub    $0xc,%esp
  803726:	68 ad 46 80 00       	push   $0x8046ad
  80372b:	e8 2e ce ff ff       	call   80055e <cprintf>
  803730:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803733:	8b 45 08             	mov    0x8(%ebp),%eax
  803736:	e9 63 02 00 00       	jmp    80399e <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80373b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80373e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803741:	0f 86 4d 02 00 00    	jbe    803994 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803747:	83 ec 0c             	sub    $0xc,%esp
  80374a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80374d:	e8 08 e8 ff ff       	call   801f5a <is_free_block>
  803752:	83 c4 10             	add    $0x10,%esp
  803755:	84 c0                	test   %al,%al
  803757:	0f 84 37 02 00 00    	je     803994 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80375d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803760:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803763:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803766:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803769:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80376c:	76 38                	jbe    8037a6 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80376e:	83 ec 0c             	sub    $0xc,%esp
  803771:	ff 75 08             	pushl  0x8(%ebp)
  803774:	e8 0c fa ff ff       	call   803185 <free_block>
  803779:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80377c:	83 ec 0c             	sub    $0xc,%esp
  80377f:	ff 75 0c             	pushl  0xc(%ebp)
  803782:	e8 3a eb ff ff       	call   8022c1 <alloc_block_FF>
  803787:	83 c4 10             	add    $0x10,%esp
  80378a:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80378d:	83 ec 08             	sub    $0x8,%esp
  803790:	ff 75 c0             	pushl  -0x40(%ebp)
  803793:	ff 75 08             	pushl  0x8(%ebp)
  803796:	e8 ab fa ff ff       	call   803246 <copy_data>
  80379b:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80379e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8037a1:	e9 f8 01 00 00       	jmp    80399e <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8037a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037a9:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8037ac:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8037af:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8037b3:	0f 87 a0 00 00 00    	ja     803859 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8037b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037bd:	75 17                	jne    8037d6 <realloc_block_FF+0x551>
  8037bf:	83 ec 04             	sub    $0x4,%esp
  8037c2:	68 9f 45 80 00       	push   $0x80459f
  8037c7:	68 38 02 00 00       	push   $0x238
  8037cc:	68 bd 45 80 00       	push   $0x8045bd
  8037d1:	e8 cb ca ff ff       	call   8002a1 <_panic>
  8037d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d9:	8b 00                	mov    (%eax),%eax
  8037db:	85 c0                	test   %eax,%eax
  8037dd:	74 10                	je     8037ef <realloc_block_FF+0x56a>
  8037df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e2:	8b 00                	mov    (%eax),%eax
  8037e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037e7:	8b 52 04             	mov    0x4(%edx),%edx
  8037ea:	89 50 04             	mov    %edx,0x4(%eax)
  8037ed:	eb 0b                	jmp    8037fa <realloc_block_FF+0x575>
  8037ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f2:	8b 40 04             	mov    0x4(%eax),%eax
  8037f5:	a3 34 50 80 00       	mov    %eax,0x805034
  8037fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fd:	8b 40 04             	mov    0x4(%eax),%eax
  803800:	85 c0                	test   %eax,%eax
  803802:	74 0f                	je     803813 <realloc_block_FF+0x58e>
  803804:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803807:	8b 40 04             	mov    0x4(%eax),%eax
  80380a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80380d:	8b 12                	mov    (%edx),%edx
  80380f:	89 10                	mov    %edx,(%eax)
  803811:	eb 0a                	jmp    80381d <realloc_block_FF+0x598>
  803813:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803816:	8b 00                	mov    (%eax),%eax
  803818:	a3 30 50 80 00       	mov    %eax,0x805030
  80381d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803820:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803826:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803829:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803830:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803835:	48                   	dec    %eax
  803836:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80383b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80383e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803841:	01 d0                	add    %edx,%eax
  803843:	83 ec 04             	sub    $0x4,%esp
  803846:	6a 01                	push   $0x1
  803848:	50                   	push   %eax
  803849:	ff 75 08             	pushl  0x8(%ebp)
  80384c:	e8 41 ea ff ff       	call   802292 <set_block_data>
  803851:	83 c4 10             	add    $0x10,%esp
  803854:	e9 36 01 00 00       	jmp    80398f <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803859:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80385c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80385f:	01 d0                	add    %edx,%eax
  803861:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803864:	83 ec 04             	sub    $0x4,%esp
  803867:	6a 01                	push   $0x1
  803869:	ff 75 f0             	pushl  -0x10(%ebp)
  80386c:	ff 75 08             	pushl  0x8(%ebp)
  80386f:	e8 1e ea ff ff       	call   802292 <set_block_data>
  803874:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803877:	8b 45 08             	mov    0x8(%ebp),%eax
  80387a:	83 e8 04             	sub    $0x4,%eax
  80387d:	8b 00                	mov    (%eax),%eax
  80387f:	83 e0 fe             	and    $0xfffffffe,%eax
  803882:	89 c2                	mov    %eax,%edx
  803884:	8b 45 08             	mov    0x8(%ebp),%eax
  803887:	01 d0                	add    %edx,%eax
  803889:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80388c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803890:	74 06                	je     803898 <realloc_block_FF+0x613>
  803892:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803896:	75 17                	jne    8038af <realloc_block_FF+0x62a>
  803898:	83 ec 04             	sub    $0x4,%esp
  80389b:	68 30 46 80 00       	push   $0x804630
  8038a0:	68 44 02 00 00       	push   $0x244
  8038a5:	68 bd 45 80 00       	push   $0x8045bd
  8038aa:	e8 f2 c9 ff ff       	call   8002a1 <_panic>
  8038af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b2:	8b 10                	mov    (%eax),%edx
  8038b4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038b7:	89 10                	mov    %edx,(%eax)
  8038b9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038bc:	8b 00                	mov    (%eax),%eax
  8038be:	85 c0                	test   %eax,%eax
  8038c0:	74 0b                	je     8038cd <realloc_block_FF+0x648>
  8038c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c5:	8b 00                	mov    (%eax),%eax
  8038c7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038ca:	89 50 04             	mov    %edx,0x4(%eax)
  8038cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038d3:	89 10                	mov    %edx,(%eax)
  8038d5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038db:	89 50 04             	mov    %edx,0x4(%eax)
  8038de:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038e1:	8b 00                	mov    (%eax),%eax
  8038e3:	85 c0                	test   %eax,%eax
  8038e5:	75 08                	jne    8038ef <realloc_block_FF+0x66a>
  8038e7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038ea:	a3 34 50 80 00       	mov    %eax,0x805034
  8038ef:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8038f4:	40                   	inc    %eax
  8038f5:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8038fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038fe:	75 17                	jne    803917 <realloc_block_FF+0x692>
  803900:	83 ec 04             	sub    $0x4,%esp
  803903:	68 9f 45 80 00       	push   $0x80459f
  803908:	68 45 02 00 00       	push   $0x245
  80390d:	68 bd 45 80 00       	push   $0x8045bd
  803912:	e8 8a c9 ff ff       	call   8002a1 <_panic>
  803917:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391a:	8b 00                	mov    (%eax),%eax
  80391c:	85 c0                	test   %eax,%eax
  80391e:	74 10                	je     803930 <realloc_block_FF+0x6ab>
  803920:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803923:	8b 00                	mov    (%eax),%eax
  803925:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803928:	8b 52 04             	mov    0x4(%edx),%edx
  80392b:	89 50 04             	mov    %edx,0x4(%eax)
  80392e:	eb 0b                	jmp    80393b <realloc_block_FF+0x6b6>
  803930:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803933:	8b 40 04             	mov    0x4(%eax),%eax
  803936:	a3 34 50 80 00       	mov    %eax,0x805034
  80393b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393e:	8b 40 04             	mov    0x4(%eax),%eax
  803941:	85 c0                	test   %eax,%eax
  803943:	74 0f                	je     803954 <realloc_block_FF+0x6cf>
  803945:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803948:	8b 40 04             	mov    0x4(%eax),%eax
  80394b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80394e:	8b 12                	mov    (%edx),%edx
  803950:	89 10                	mov    %edx,(%eax)
  803952:	eb 0a                	jmp    80395e <realloc_block_FF+0x6d9>
  803954:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803957:	8b 00                	mov    (%eax),%eax
  803959:	a3 30 50 80 00       	mov    %eax,0x805030
  80395e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803961:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803967:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80396a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803971:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803976:	48                   	dec    %eax
  803977:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  80397c:	83 ec 04             	sub    $0x4,%esp
  80397f:	6a 00                	push   $0x0
  803981:	ff 75 bc             	pushl  -0x44(%ebp)
  803984:	ff 75 b8             	pushl  -0x48(%ebp)
  803987:	e8 06 e9 ff ff       	call   802292 <set_block_data>
  80398c:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80398f:	8b 45 08             	mov    0x8(%ebp),%eax
  803992:	eb 0a                	jmp    80399e <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803994:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80399b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80399e:	c9                   	leave  
  80399f:	c3                   	ret    

008039a0 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8039a0:	55                   	push   %ebp
  8039a1:	89 e5                	mov    %esp,%ebp
  8039a3:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8039a6:	83 ec 04             	sub    $0x4,%esp
  8039a9:	68 b4 46 80 00       	push   $0x8046b4
  8039ae:	68 58 02 00 00       	push   $0x258
  8039b3:	68 bd 45 80 00       	push   $0x8045bd
  8039b8:	e8 e4 c8 ff ff       	call   8002a1 <_panic>

008039bd <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8039bd:	55                   	push   %ebp
  8039be:	89 e5                	mov    %esp,%ebp
  8039c0:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8039c3:	83 ec 04             	sub    $0x4,%esp
  8039c6:	68 dc 46 80 00       	push   $0x8046dc
  8039cb:	68 61 02 00 00       	push   $0x261
  8039d0:	68 bd 45 80 00       	push   $0x8045bd
  8039d5:	e8 c7 c8 ff ff       	call   8002a1 <_panic>

008039da <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8039da:	55                   	push   %ebp
  8039db:	89 e5                	mov    %esp,%ebp
  8039dd:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8039e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8039e3:	89 d0                	mov    %edx,%eax
  8039e5:	c1 e0 02             	shl    $0x2,%eax
  8039e8:	01 d0                	add    %edx,%eax
  8039ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039f1:	01 d0                	add    %edx,%eax
  8039f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039fa:	01 d0                	add    %edx,%eax
  8039fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803a03:	01 d0                	add    %edx,%eax
  803a05:	c1 e0 04             	shl    $0x4,%eax
  803a08:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803a0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803a12:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803a15:	83 ec 0c             	sub    $0xc,%esp
  803a18:	50                   	push   %eax
  803a19:	e8 2f e2 ff ff       	call   801c4d <sys_get_virtual_time>
  803a1e:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803a21:	eb 41                	jmp    803a64 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803a23:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803a26:	83 ec 0c             	sub    $0xc,%esp
  803a29:	50                   	push   %eax
  803a2a:	e8 1e e2 ff ff       	call   801c4d <sys_get_virtual_time>
  803a2f:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803a32:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a38:	29 c2                	sub    %eax,%edx
  803a3a:	89 d0                	mov    %edx,%eax
  803a3c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803a3f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a45:	89 d1                	mov    %edx,%ecx
  803a47:	29 c1                	sub    %eax,%ecx
  803a49:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803a4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a4f:	39 c2                	cmp    %eax,%edx
  803a51:	0f 97 c0             	seta   %al
  803a54:	0f b6 c0             	movzbl %al,%eax
  803a57:	29 c1                	sub    %eax,%ecx
  803a59:	89 c8                	mov    %ecx,%eax
  803a5b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803a5e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a61:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a67:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803a6a:	72 b7                	jb     803a23 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803a6c:	90                   	nop
  803a6d:	c9                   	leave  
  803a6e:	c3                   	ret    

00803a6f <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803a6f:	55                   	push   %ebp
  803a70:	89 e5                	mov    %esp,%ebp
  803a72:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803a75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803a7c:	eb 03                	jmp    803a81 <busy_wait+0x12>
  803a7e:	ff 45 fc             	incl   -0x4(%ebp)
  803a81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803a84:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a87:	72 f5                	jb     803a7e <busy_wait+0xf>
	return i;
  803a89:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803a8c:	c9                   	leave  
  803a8d:	c3                   	ret    
  803a8e:	66 90                	xchg   %ax,%ax

00803a90 <__udivdi3>:
  803a90:	55                   	push   %ebp
  803a91:	57                   	push   %edi
  803a92:	56                   	push   %esi
  803a93:	53                   	push   %ebx
  803a94:	83 ec 1c             	sub    $0x1c,%esp
  803a97:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a9b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a9f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803aa3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803aa7:	89 ca                	mov    %ecx,%edx
  803aa9:	89 f8                	mov    %edi,%eax
  803aab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803aaf:	85 f6                	test   %esi,%esi
  803ab1:	75 2d                	jne    803ae0 <__udivdi3+0x50>
  803ab3:	39 cf                	cmp    %ecx,%edi
  803ab5:	77 65                	ja     803b1c <__udivdi3+0x8c>
  803ab7:	89 fd                	mov    %edi,%ebp
  803ab9:	85 ff                	test   %edi,%edi
  803abb:	75 0b                	jne    803ac8 <__udivdi3+0x38>
  803abd:	b8 01 00 00 00       	mov    $0x1,%eax
  803ac2:	31 d2                	xor    %edx,%edx
  803ac4:	f7 f7                	div    %edi
  803ac6:	89 c5                	mov    %eax,%ebp
  803ac8:	31 d2                	xor    %edx,%edx
  803aca:	89 c8                	mov    %ecx,%eax
  803acc:	f7 f5                	div    %ebp
  803ace:	89 c1                	mov    %eax,%ecx
  803ad0:	89 d8                	mov    %ebx,%eax
  803ad2:	f7 f5                	div    %ebp
  803ad4:	89 cf                	mov    %ecx,%edi
  803ad6:	89 fa                	mov    %edi,%edx
  803ad8:	83 c4 1c             	add    $0x1c,%esp
  803adb:	5b                   	pop    %ebx
  803adc:	5e                   	pop    %esi
  803add:	5f                   	pop    %edi
  803ade:	5d                   	pop    %ebp
  803adf:	c3                   	ret    
  803ae0:	39 ce                	cmp    %ecx,%esi
  803ae2:	77 28                	ja     803b0c <__udivdi3+0x7c>
  803ae4:	0f bd fe             	bsr    %esi,%edi
  803ae7:	83 f7 1f             	xor    $0x1f,%edi
  803aea:	75 40                	jne    803b2c <__udivdi3+0x9c>
  803aec:	39 ce                	cmp    %ecx,%esi
  803aee:	72 0a                	jb     803afa <__udivdi3+0x6a>
  803af0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803af4:	0f 87 9e 00 00 00    	ja     803b98 <__udivdi3+0x108>
  803afa:	b8 01 00 00 00       	mov    $0x1,%eax
  803aff:	89 fa                	mov    %edi,%edx
  803b01:	83 c4 1c             	add    $0x1c,%esp
  803b04:	5b                   	pop    %ebx
  803b05:	5e                   	pop    %esi
  803b06:	5f                   	pop    %edi
  803b07:	5d                   	pop    %ebp
  803b08:	c3                   	ret    
  803b09:	8d 76 00             	lea    0x0(%esi),%esi
  803b0c:	31 ff                	xor    %edi,%edi
  803b0e:	31 c0                	xor    %eax,%eax
  803b10:	89 fa                	mov    %edi,%edx
  803b12:	83 c4 1c             	add    $0x1c,%esp
  803b15:	5b                   	pop    %ebx
  803b16:	5e                   	pop    %esi
  803b17:	5f                   	pop    %edi
  803b18:	5d                   	pop    %ebp
  803b19:	c3                   	ret    
  803b1a:	66 90                	xchg   %ax,%ax
  803b1c:	89 d8                	mov    %ebx,%eax
  803b1e:	f7 f7                	div    %edi
  803b20:	31 ff                	xor    %edi,%edi
  803b22:	89 fa                	mov    %edi,%edx
  803b24:	83 c4 1c             	add    $0x1c,%esp
  803b27:	5b                   	pop    %ebx
  803b28:	5e                   	pop    %esi
  803b29:	5f                   	pop    %edi
  803b2a:	5d                   	pop    %ebp
  803b2b:	c3                   	ret    
  803b2c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b31:	89 eb                	mov    %ebp,%ebx
  803b33:	29 fb                	sub    %edi,%ebx
  803b35:	89 f9                	mov    %edi,%ecx
  803b37:	d3 e6                	shl    %cl,%esi
  803b39:	89 c5                	mov    %eax,%ebp
  803b3b:	88 d9                	mov    %bl,%cl
  803b3d:	d3 ed                	shr    %cl,%ebp
  803b3f:	89 e9                	mov    %ebp,%ecx
  803b41:	09 f1                	or     %esi,%ecx
  803b43:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b47:	89 f9                	mov    %edi,%ecx
  803b49:	d3 e0                	shl    %cl,%eax
  803b4b:	89 c5                	mov    %eax,%ebp
  803b4d:	89 d6                	mov    %edx,%esi
  803b4f:	88 d9                	mov    %bl,%cl
  803b51:	d3 ee                	shr    %cl,%esi
  803b53:	89 f9                	mov    %edi,%ecx
  803b55:	d3 e2                	shl    %cl,%edx
  803b57:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b5b:	88 d9                	mov    %bl,%cl
  803b5d:	d3 e8                	shr    %cl,%eax
  803b5f:	09 c2                	or     %eax,%edx
  803b61:	89 d0                	mov    %edx,%eax
  803b63:	89 f2                	mov    %esi,%edx
  803b65:	f7 74 24 0c          	divl   0xc(%esp)
  803b69:	89 d6                	mov    %edx,%esi
  803b6b:	89 c3                	mov    %eax,%ebx
  803b6d:	f7 e5                	mul    %ebp
  803b6f:	39 d6                	cmp    %edx,%esi
  803b71:	72 19                	jb     803b8c <__udivdi3+0xfc>
  803b73:	74 0b                	je     803b80 <__udivdi3+0xf0>
  803b75:	89 d8                	mov    %ebx,%eax
  803b77:	31 ff                	xor    %edi,%edi
  803b79:	e9 58 ff ff ff       	jmp    803ad6 <__udivdi3+0x46>
  803b7e:	66 90                	xchg   %ax,%ax
  803b80:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b84:	89 f9                	mov    %edi,%ecx
  803b86:	d3 e2                	shl    %cl,%edx
  803b88:	39 c2                	cmp    %eax,%edx
  803b8a:	73 e9                	jae    803b75 <__udivdi3+0xe5>
  803b8c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b8f:	31 ff                	xor    %edi,%edi
  803b91:	e9 40 ff ff ff       	jmp    803ad6 <__udivdi3+0x46>
  803b96:	66 90                	xchg   %ax,%ax
  803b98:	31 c0                	xor    %eax,%eax
  803b9a:	e9 37 ff ff ff       	jmp    803ad6 <__udivdi3+0x46>
  803b9f:	90                   	nop

00803ba0 <__umoddi3>:
  803ba0:	55                   	push   %ebp
  803ba1:	57                   	push   %edi
  803ba2:	56                   	push   %esi
  803ba3:	53                   	push   %ebx
  803ba4:	83 ec 1c             	sub    $0x1c,%esp
  803ba7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803bab:	8b 74 24 34          	mov    0x34(%esp),%esi
  803baf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bb3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803bb7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803bbb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803bbf:	89 f3                	mov    %esi,%ebx
  803bc1:	89 fa                	mov    %edi,%edx
  803bc3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bc7:	89 34 24             	mov    %esi,(%esp)
  803bca:	85 c0                	test   %eax,%eax
  803bcc:	75 1a                	jne    803be8 <__umoddi3+0x48>
  803bce:	39 f7                	cmp    %esi,%edi
  803bd0:	0f 86 a2 00 00 00    	jbe    803c78 <__umoddi3+0xd8>
  803bd6:	89 c8                	mov    %ecx,%eax
  803bd8:	89 f2                	mov    %esi,%edx
  803bda:	f7 f7                	div    %edi
  803bdc:	89 d0                	mov    %edx,%eax
  803bde:	31 d2                	xor    %edx,%edx
  803be0:	83 c4 1c             	add    $0x1c,%esp
  803be3:	5b                   	pop    %ebx
  803be4:	5e                   	pop    %esi
  803be5:	5f                   	pop    %edi
  803be6:	5d                   	pop    %ebp
  803be7:	c3                   	ret    
  803be8:	39 f0                	cmp    %esi,%eax
  803bea:	0f 87 ac 00 00 00    	ja     803c9c <__umoddi3+0xfc>
  803bf0:	0f bd e8             	bsr    %eax,%ebp
  803bf3:	83 f5 1f             	xor    $0x1f,%ebp
  803bf6:	0f 84 ac 00 00 00    	je     803ca8 <__umoddi3+0x108>
  803bfc:	bf 20 00 00 00       	mov    $0x20,%edi
  803c01:	29 ef                	sub    %ebp,%edi
  803c03:	89 fe                	mov    %edi,%esi
  803c05:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c09:	89 e9                	mov    %ebp,%ecx
  803c0b:	d3 e0                	shl    %cl,%eax
  803c0d:	89 d7                	mov    %edx,%edi
  803c0f:	89 f1                	mov    %esi,%ecx
  803c11:	d3 ef                	shr    %cl,%edi
  803c13:	09 c7                	or     %eax,%edi
  803c15:	89 e9                	mov    %ebp,%ecx
  803c17:	d3 e2                	shl    %cl,%edx
  803c19:	89 14 24             	mov    %edx,(%esp)
  803c1c:	89 d8                	mov    %ebx,%eax
  803c1e:	d3 e0                	shl    %cl,%eax
  803c20:	89 c2                	mov    %eax,%edx
  803c22:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c26:	d3 e0                	shl    %cl,%eax
  803c28:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c2c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c30:	89 f1                	mov    %esi,%ecx
  803c32:	d3 e8                	shr    %cl,%eax
  803c34:	09 d0                	or     %edx,%eax
  803c36:	d3 eb                	shr    %cl,%ebx
  803c38:	89 da                	mov    %ebx,%edx
  803c3a:	f7 f7                	div    %edi
  803c3c:	89 d3                	mov    %edx,%ebx
  803c3e:	f7 24 24             	mull   (%esp)
  803c41:	89 c6                	mov    %eax,%esi
  803c43:	89 d1                	mov    %edx,%ecx
  803c45:	39 d3                	cmp    %edx,%ebx
  803c47:	0f 82 87 00 00 00    	jb     803cd4 <__umoddi3+0x134>
  803c4d:	0f 84 91 00 00 00    	je     803ce4 <__umoddi3+0x144>
  803c53:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c57:	29 f2                	sub    %esi,%edx
  803c59:	19 cb                	sbb    %ecx,%ebx
  803c5b:	89 d8                	mov    %ebx,%eax
  803c5d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c61:	d3 e0                	shl    %cl,%eax
  803c63:	89 e9                	mov    %ebp,%ecx
  803c65:	d3 ea                	shr    %cl,%edx
  803c67:	09 d0                	or     %edx,%eax
  803c69:	89 e9                	mov    %ebp,%ecx
  803c6b:	d3 eb                	shr    %cl,%ebx
  803c6d:	89 da                	mov    %ebx,%edx
  803c6f:	83 c4 1c             	add    $0x1c,%esp
  803c72:	5b                   	pop    %ebx
  803c73:	5e                   	pop    %esi
  803c74:	5f                   	pop    %edi
  803c75:	5d                   	pop    %ebp
  803c76:	c3                   	ret    
  803c77:	90                   	nop
  803c78:	89 fd                	mov    %edi,%ebp
  803c7a:	85 ff                	test   %edi,%edi
  803c7c:	75 0b                	jne    803c89 <__umoddi3+0xe9>
  803c7e:	b8 01 00 00 00       	mov    $0x1,%eax
  803c83:	31 d2                	xor    %edx,%edx
  803c85:	f7 f7                	div    %edi
  803c87:	89 c5                	mov    %eax,%ebp
  803c89:	89 f0                	mov    %esi,%eax
  803c8b:	31 d2                	xor    %edx,%edx
  803c8d:	f7 f5                	div    %ebp
  803c8f:	89 c8                	mov    %ecx,%eax
  803c91:	f7 f5                	div    %ebp
  803c93:	89 d0                	mov    %edx,%eax
  803c95:	e9 44 ff ff ff       	jmp    803bde <__umoddi3+0x3e>
  803c9a:	66 90                	xchg   %ax,%ax
  803c9c:	89 c8                	mov    %ecx,%eax
  803c9e:	89 f2                	mov    %esi,%edx
  803ca0:	83 c4 1c             	add    $0x1c,%esp
  803ca3:	5b                   	pop    %ebx
  803ca4:	5e                   	pop    %esi
  803ca5:	5f                   	pop    %edi
  803ca6:	5d                   	pop    %ebp
  803ca7:	c3                   	ret    
  803ca8:	3b 04 24             	cmp    (%esp),%eax
  803cab:	72 06                	jb     803cb3 <__umoddi3+0x113>
  803cad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803cb1:	77 0f                	ja     803cc2 <__umoddi3+0x122>
  803cb3:	89 f2                	mov    %esi,%edx
  803cb5:	29 f9                	sub    %edi,%ecx
  803cb7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803cbb:	89 14 24             	mov    %edx,(%esp)
  803cbe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803cc2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803cc6:	8b 14 24             	mov    (%esp),%edx
  803cc9:	83 c4 1c             	add    $0x1c,%esp
  803ccc:	5b                   	pop    %ebx
  803ccd:	5e                   	pop    %esi
  803cce:	5f                   	pop    %edi
  803ccf:	5d                   	pop    %ebp
  803cd0:	c3                   	ret    
  803cd1:	8d 76 00             	lea    0x0(%esi),%esi
  803cd4:	2b 04 24             	sub    (%esp),%eax
  803cd7:	19 fa                	sbb    %edi,%edx
  803cd9:	89 d1                	mov    %edx,%ecx
  803cdb:	89 c6                	mov    %eax,%esi
  803cdd:	e9 71 ff ff ff       	jmp    803c53 <__umoddi3+0xb3>
  803ce2:	66 90                	xchg   %ax,%ax
  803ce4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ce8:	72 ea                	jb     803cd4 <__umoddi3+0x134>
  803cea:	89 d9                	mov    %ebx,%ecx
  803cec:	e9 62 ff ff ff       	jmp    803c53 <__umoddi3+0xb3>
