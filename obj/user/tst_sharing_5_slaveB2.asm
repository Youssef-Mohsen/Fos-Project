
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
  80005b:	68 e0 3b 80 00       	push   $0x803be0
  800060:	6a 0c                	push   $0xc
  800062:	68 fc 3b 80 00       	push   $0x803bfc
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
  800073:	e8 b5 1a 00 00       	call   801b2d <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 19 3c 80 00       	push   $0x803c19
  800080:	50                   	push   %eax
  800081:	e8 4b 16 00 00       	call   8016d1 <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 1c 3c 80 00       	push   $0x803c1c
  800094:	e8 c5 04 00 00       	call   80055e <cprintf>
  800099:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got z
	inctst();
  80009c:	e8 b1 1b 00 00       	call   801c52 <inctst>

	cprintf("Slave B2 please be patient ...\n");
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	68 44 3c 80 00       	push   $0x803c44
  8000a9:	e8 b0 04 00 00       	call   80055e <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 28 23 00 00       	push   $0x2328
  8000b9:	e8 fc 37 00 00       	call   8038ba <env_sleep>
  8000be:	83 c4 10             	add    $0x10,%esp
	//to ensure that the other environments completed successfully
	while (gettst()!=3) ;// panic("test failed");
  8000c1:	90                   	nop
  8000c2:	e8 a5 1b 00 00       	call   801c6c <gettst>
  8000c7:	83 f8 03             	cmp    $0x3,%eax
  8000ca:	75 f6                	jne    8000c2 <_main+0x8a>

	freeFrames = sys_calculate_free_frames() ;
  8000cc:	e8 7a 18 00 00       	call   80194b <sys_calculate_free_frames>
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	sfree(z);
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000da:	e8 9a 16 00 00       	call   801779 <sfree>
  8000df:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 64 3c 80 00       	push   $0x803c64
  8000ea:	e8 6f 04 00 00       	call   80055e <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
	expected = 1+1; /*1page+1table*/
  8000f2:	c7 45 e8 02 00 00 00 	movl   $0x2,-0x18(%ebp)
	cprintf("diff 3: %d\n",sys_calculate_free_frames() - freeFrames);
  8000f9:	e8 4d 18 00 00       	call   80194b <sys_calculate_free_frames>
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800103:	29 c2                	sub    %eax,%edx
  800105:	89 d0                	mov    %edx,%eax
  800107:	83 ec 08             	sub    $0x8,%esp
  80010a:	50                   	push   %eax
  80010b:	68 7c 3c 80 00       	push   $0x803c7c
  800110:	e8 49 04 00 00       	call   80055e <cprintf>
  800115:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  800118:	e8 2e 18 00 00       	call   80194b <sys_calculate_free_frames>
  80011d:	89 c2                	mov    %eax,%edx
  80011f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800122:	29 c2                	sub    %eax,%edx
  800124:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800127:	39 c2                	cmp    %eax,%edx
  800129:	74 14                	je     80013f <_main+0x107>
  80012b:	83 ec 04             	sub    $0x4,%esp
  80012e:	68 88 3c 80 00       	push   $0x803c88
  800133:	6a 29                	push   $0x29
  800135:	68 fc 3b 80 00       	push   $0x803bfc
  80013a:	e8 62 01 00 00       	call   8002a1 <_panic>


	cprintf("Step B completed successfully!!\n\n\n");
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 28 3d 80 00       	push   $0x803d28
  800147:	e8 12 04 00 00       	call   80055e <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n%~Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	68 4c 3d 80 00       	push   $0x803d4c
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
  800168:	e8 a7 19 00 00       	call   801b14 <sys_getenvindex>
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
  8001d6:	e8 bd 16 00 00       	call   801898 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001db:	83 ec 0c             	sub    $0xc,%esp
  8001de:	68 b4 3d 80 00       	push   $0x803db4
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
  800206:	68 dc 3d 80 00       	push   $0x803ddc
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
  800237:	68 04 3e 80 00       	push   $0x803e04
  80023c:	e8 1d 03 00 00       	call   80055e <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800244:	a1 20 50 80 00       	mov    0x805020,%eax
  800249:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80024f:	83 ec 08             	sub    $0x8,%esp
  800252:	50                   	push   %eax
  800253:	68 5c 3e 80 00       	push   $0x803e5c
  800258:	e8 01 03 00 00       	call   80055e <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	68 b4 3d 80 00       	push   $0x803db4
  800268:	e8 f1 02 00 00       	call   80055e <cprintf>
  80026d:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800270:	e8 3d 16 00 00       	call   8018b2 <sys_unlock_cons>
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
  800288:	e8 53 18 00 00       	call   801ae0 <sys_destroy_env>
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
  800299:	e8 a8 18 00 00       	call   801b46 <sys_exit_env>
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
  8002b0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8002b5:	85 c0                	test   %eax,%eax
  8002b7:	74 16                	je     8002cf <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002b9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8002be:	83 ec 08             	sub    $0x8,%esp
  8002c1:	50                   	push   %eax
  8002c2:	68 70 3e 80 00       	push   $0x803e70
  8002c7:	e8 92 02 00 00       	call   80055e <cprintf>
  8002cc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002cf:	a1 00 50 80 00       	mov    0x805000,%eax
  8002d4:	ff 75 0c             	pushl  0xc(%ebp)
  8002d7:	ff 75 08             	pushl  0x8(%ebp)
  8002da:	50                   	push   %eax
  8002db:	68 75 3e 80 00       	push   $0x803e75
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
  8002ff:	68 91 3e 80 00       	push   $0x803e91
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
  80032e:	68 94 3e 80 00       	push   $0x803e94
  800333:	6a 26                	push   $0x26
  800335:	68 e0 3e 80 00       	push   $0x803ee0
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
  800403:	68 ec 3e 80 00       	push   $0x803eec
  800408:	6a 3a                	push   $0x3a
  80040a:	68 e0 3e 80 00       	push   $0x803ee0
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
  800476:	68 40 3f 80 00       	push   $0x803f40
  80047b:	6a 44                	push   $0x44
  80047d:	68 e0 3e 80 00       	push   $0x803ee0
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
  8004b5:	a0 28 50 80 00       	mov    0x805028,%al
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
  8004d0:	e8 81 13 00 00       	call   801856 <sys_cputs>
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
  80052a:	a0 28 50 80 00       	mov    0x805028,%al
  80052f:	0f b6 c0             	movzbl %al,%eax
  800532:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800538:	83 ec 04             	sub    $0x4,%esp
  80053b:	50                   	push   %eax
  80053c:	52                   	push   %edx
  80053d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800543:	83 c0 08             	add    $0x8,%eax
  800546:	50                   	push   %eax
  800547:	e8 0a 13 00 00       	call   801856 <sys_cputs>
  80054c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80054f:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
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
  800564:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
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
  800591:	e8 02 13 00 00       	call   801898 <sys_lock_cons>
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
  8005b1:	e8 fc 12 00 00       	call   8018b2 <sys_unlock_cons>
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
  8005fb:	e8 70 33 00 00       	call   803970 <__udivdi3>
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
  80064b:	e8 30 34 00 00       	call   803a80 <__umoddi3>
  800650:	83 c4 10             	add    $0x10,%esp
  800653:	05 b4 41 80 00       	add    $0x8041b4,%eax
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
  8007a6:	8b 04 85 d8 41 80 00 	mov    0x8041d8(,%eax,4),%eax
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
  800887:	8b 34 9d 20 40 80 00 	mov    0x804020(,%ebx,4),%esi
  80088e:	85 f6                	test   %esi,%esi
  800890:	75 19                	jne    8008ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800892:	53                   	push   %ebx
  800893:	68 c5 41 80 00       	push   $0x8041c5
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
  8008ac:	68 ce 41 80 00       	push   $0x8041ce
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
  8008d9:	be d1 41 80 00       	mov    $0x8041d1,%esi
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
  800ad1:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800ad8:	eb 2c                	jmp    800b06 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ada:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
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
  8012e4:	68 48 43 80 00       	push   $0x804348
  8012e9:	68 3f 01 00 00       	push   $0x13f
  8012ee:	68 6a 43 80 00       	push   $0x80436a
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
  801304:	e8 f8 0a 00 00       	call   801e01 <sys_sbrk>
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
  80137f:	e8 01 09 00 00       	call   801c85 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801384:	85 c0                	test   %eax,%eax
  801386:	74 16                	je     80139e <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  801388:	83 ec 0c             	sub    $0xc,%esp
  80138b:	ff 75 08             	pushl  0x8(%ebp)
  80138e:	e8 41 0e 00 00       	call   8021d4 <alloc_block_FF>
  801393:	83 c4 10             	add    $0x10,%esp
  801396:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801399:	e9 8a 01 00 00       	jmp    801528 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80139e:	e8 13 09 00 00       	call   801cb6 <sys_isUHeapPlacementStrategyBESTFIT>
  8013a3:	85 c0                	test   %eax,%eax
  8013a5:	0f 84 7d 01 00 00    	je     801528 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8013ab:	83 ec 0c             	sub    $0xc,%esp
  8013ae:	ff 75 08             	pushl  0x8(%ebp)
  8013b1:	e8 da 12 00 00       	call   802690 <alloc_block_BF>
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
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  8013ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8013ef:	8b 40 78             	mov    0x78(%eax),%eax
  8013f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013f5:	29 c2                	sub    %eax,%edx
  8013f7:	89 d0                	mov    %edx,%eax
  8013f9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013fe:	c1 e8 0c             	shr    $0xc,%eax
  801401:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801408:	85 c0                	test   %eax,%eax
  80140a:	0f 85 ab 00 00 00    	jne    8014bb <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801410:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801413:	05 00 10 00 00       	add    $0x1000,%eax
  801418:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80141b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
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
  80144e:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801455:	85 c0                	test   %eax,%eax
  801457:	74 08                	je     801461 <malloc+0x153>
					{
						
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
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
  8014a5:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
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
				

			}
			sayed:
			if(ok) break;
  8014bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014bf:	75 16                	jne    8014d7 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8014c1:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8014c8:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8014cf:	0f 86 15 ff ff ff    	jbe    8013ea <malloc+0xdc>
  8014d5:	eb 01                	jmp    8014d8 <malloc+0x1ca>
				}
				

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
  801507:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  80150e:	83 ec 08             	sub    $0x8,%esp
  801511:	ff 75 08             	pushl  0x8(%ebp)
  801514:	ff 75 f0             	pushl  -0x10(%ebp)
  801517:	e8 1c 09 00 00       	call   801e38 <sys_allocate_user_mem>
  80151c:	83 c4 10             	add    $0x10,%esp
  80151f:	eb 07                	jmp    801528 <malloc+0x21a>
		
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
  80155f:	e8 f0 08 00 00       	call   801e54 <get_block_size>
  801564:	83 c4 10             	add    $0x10,%esp
  801567:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80156a:	83 ec 0c             	sub    $0xc,%esp
  80156d:	ff 75 08             	pushl  0x8(%ebp)
  801570:	e8 00 1b 00 00       	call   803075 <free_block>
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
  8015aa:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  8015e7:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  8015ee:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  8015f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	83 ec 08             	sub    $0x8,%esp
  8015fb:	52                   	push   %edx
  8015fc:	50                   	push   %eax
  8015fd:	e8 1a 08 00 00       	call   801e1c <sys_free_user_mem>
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
  801615:	68 78 43 80 00       	push   $0x804378
  80161a:	68 87 00 00 00       	push   $0x87
  80161f:	68 a2 43 80 00       	push   $0x8043a2
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
  801643:	e9 87 00 00 00       	jmp    8016cf <smalloc+0xa3>
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
  801674:	75 07                	jne    80167d <smalloc+0x51>
  801676:	b8 00 00 00 00       	mov    $0x0,%eax
  80167b:	eb 52                	jmp    8016cf <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80167d:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801681:	ff 75 ec             	pushl  -0x14(%ebp)
  801684:	50                   	push   %eax
  801685:	ff 75 0c             	pushl  0xc(%ebp)
  801688:	ff 75 08             	pushl  0x8(%ebp)
  80168b:	e8 93 03 00 00       	call   801a23 <sys_createSharedObject>
  801690:	83 c4 10             	add    $0x10,%esp
  801693:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801696:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80169a:	74 06                	je     8016a2 <smalloc+0x76>
  80169c:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8016a0:	75 07                	jne    8016a9 <smalloc+0x7d>
  8016a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a7:	eb 26                	jmp    8016cf <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  8016a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016ac:	a1 20 50 80 00       	mov    0x805020,%eax
  8016b1:	8b 40 78             	mov    0x78(%eax),%eax
  8016b4:	29 c2                	sub    %eax,%edx
  8016b6:	89 d0                	mov    %edx,%eax
  8016b8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016bd:	c1 e8 0c             	shr    $0xc,%eax
  8016c0:	89 c2                	mov    %eax,%edx
  8016c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016c5:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8016cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
  8016d4:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016d7:	83 ec 08             	sub    $0x8,%esp
  8016da:	ff 75 0c             	pushl  0xc(%ebp)
  8016dd:	ff 75 08             	pushl  0x8(%ebp)
  8016e0:	e8 68 03 00 00       	call   801a4d <sys_getSizeOfSharedObject>
  8016e5:	83 c4 10             	add    $0x10,%esp
  8016e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8016eb:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016ef:	75 07                	jne    8016f8 <sget+0x27>
  8016f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f6:	eb 7f                	jmp    801777 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8016f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016fe:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801705:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801708:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170b:	39 d0                	cmp    %edx,%eax
  80170d:	73 02                	jae    801711 <sget+0x40>
  80170f:	89 d0                	mov    %edx,%eax
  801711:	83 ec 0c             	sub    $0xc,%esp
  801714:	50                   	push   %eax
  801715:	e8 f4 fb ff ff       	call   80130e <malloc>
  80171a:	83 c4 10             	add    $0x10,%esp
  80171d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801720:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801724:	75 07                	jne    80172d <sget+0x5c>
  801726:	b8 00 00 00 00       	mov    $0x0,%eax
  80172b:	eb 4a                	jmp    801777 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80172d:	83 ec 04             	sub    $0x4,%esp
  801730:	ff 75 e8             	pushl  -0x18(%ebp)
  801733:	ff 75 0c             	pushl  0xc(%ebp)
  801736:	ff 75 08             	pushl  0x8(%ebp)
  801739:	e8 2c 03 00 00       	call   801a6a <sys_getSharedObject>
  80173e:	83 c4 10             	add    $0x10,%esp
  801741:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801744:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801747:	a1 20 50 80 00       	mov    0x805020,%eax
  80174c:	8b 40 78             	mov    0x78(%eax),%eax
  80174f:	29 c2                	sub    %eax,%edx
  801751:	89 d0                	mov    %edx,%eax
  801753:	2d 00 10 00 00       	sub    $0x1000,%eax
  801758:	c1 e8 0c             	shr    $0xc,%eax
  80175b:	89 c2                	mov    %eax,%edx
  80175d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801760:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801767:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80176b:	75 07                	jne    801774 <sget+0xa3>
  80176d:	b8 00 00 00 00       	mov    $0x0,%eax
  801772:	eb 03                	jmp    801777 <sget+0xa6>
	return ptr;
  801774:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801777:	c9                   	leave  
  801778:	c3                   	ret    

00801779 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  80177f:	8b 55 08             	mov    0x8(%ebp),%edx
  801782:	a1 20 50 80 00       	mov    0x805020,%eax
  801787:	8b 40 78             	mov    0x78(%eax),%eax
  80178a:	29 c2                	sub    %eax,%edx
  80178c:	89 d0                	mov    %edx,%eax
  80178e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801793:	c1 e8 0c             	shr    $0xc,%eax
  801796:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  80179d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8017a0:	83 ec 08             	sub    $0x8,%esp
  8017a3:	ff 75 08             	pushl  0x8(%ebp)
  8017a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8017a9:	e8 db 02 00 00       	call   801a89 <sys_freeSharedObject>
  8017ae:	83 c4 10             	add    $0x10,%esp
  8017b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8017b4:	90                   	nop
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017bd:	83 ec 04             	sub    $0x4,%esp
  8017c0:	68 b0 43 80 00       	push   $0x8043b0
  8017c5:	68 e4 00 00 00       	push   $0xe4
  8017ca:	68 a2 43 80 00       	push   $0x8043a2
  8017cf:	e8 cd ea ff ff       	call   8002a1 <_panic>

008017d4 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017da:	83 ec 04             	sub    $0x4,%esp
  8017dd:	68 d6 43 80 00       	push   $0x8043d6
  8017e2:	68 f0 00 00 00       	push   $0xf0
  8017e7:	68 a2 43 80 00       	push   $0x8043a2
  8017ec:	e8 b0 ea ff ff       	call   8002a1 <_panic>

008017f1 <shrink>:

}
void shrink(uint32 newSize)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017f7:	83 ec 04             	sub    $0x4,%esp
  8017fa:	68 d6 43 80 00       	push   $0x8043d6
  8017ff:	68 f5 00 00 00       	push   $0xf5
  801804:	68 a2 43 80 00       	push   $0x8043a2
  801809:	e8 93 ea ff ff       	call   8002a1 <_panic>

0080180e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801814:	83 ec 04             	sub    $0x4,%esp
  801817:	68 d6 43 80 00       	push   $0x8043d6
  80181c:	68 fa 00 00 00       	push   $0xfa
  801821:	68 a2 43 80 00       	push   $0x8043a2
  801826:	e8 76 ea ff ff       	call   8002a1 <_panic>

0080182b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	57                   	push   %edi
  80182f:	56                   	push   %esi
  801830:	53                   	push   %ebx
  801831:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801834:	8b 45 08             	mov    0x8(%ebp),%eax
  801837:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80183d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801840:	8b 7d 18             	mov    0x18(%ebp),%edi
  801843:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801846:	cd 30                	int    $0x30
  801848:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80184b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80184e:	83 c4 10             	add    $0x10,%esp
  801851:	5b                   	pop    %ebx
  801852:	5e                   	pop    %esi
  801853:	5f                   	pop    %edi
  801854:	5d                   	pop    %ebp
  801855:	c3                   	ret    

00801856 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	83 ec 04             	sub    $0x4,%esp
  80185c:	8b 45 10             	mov    0x10(%ebp),%eax
  80185f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801862:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	52                   	push   %edx
  80186e:	ff 75 0c             	pushl  0xc(%ebp)
  801871:	50                   	push   %eax
  801872:	6a 00                	push   $0x0
  801874:	e8 b2 ff ff ff       	call   80182b <syscall>
  801879:	83 c4 18             	add    $0x18,%esp
}
  80187c:	90                   	nop
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <sys_cgetc>:

int
sys_cgetc(void)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 02                	push   $0x2
  80188e:	e8 98 ff ff ff       	call   80182b <syscall>
  801893:	83 c4 18             	add    $0x18,%esp
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 03                	push   $0x3
  8018a7:	e8 7f ff ff ff       	call   80182b <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
}
  8018af:	90                   	nop
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 04                	push   $0x4
  8018c1:	e8 65 ff ff ff       	call   80182b <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
}
  8018c9:	90                   	nop
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	52                   	push   %edx
  8018dc:	50                   	push   %eax
  8018dd:	6a 08                	push   $0x8
  8018df:	e8 47 ff ff ff       	call   80182b <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
  8018ec:	56                   	push   %esi
  8018ed:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018ee:	8b 75 18             	mov    0x18(%ebp),%esi
  8018f1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fd:	56                   	push   %esi
  8018fe:	53                   	push   %ebx
  8018ff:	51                   	push   %ecx
  801900:	52                   	push   %edx
  801901:	50                   	push   %eax
  801902:	6a 09                	push   $0x9
  801904:	e8 22 ff ff ff       	call   80182b <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
}
  80190c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80190f:	5b                   	pop    %ebx
  801910:	5e                   	pop    %esi
  801911:	5d                   	pop    %ebp
  801912:	c3                   	ret    

00801913 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801916:	8b 55 0c             	mov    0xc(%ebp),%edx
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	52                   	push   %edx
  801923:	50                   	push   %eax
  801924:	6a 0a                	push   $0xa
  801926:	e8 00 ff ff ff       	call   80182b <syscall>
  80192b:	83 c4 18             	add    $0x18,%esp
}
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	ff 75 0c             	pushl  0xc(%ebp)
  80193c:	ff 75 08             	pushl  0x8(%ebp)
  80193f:	6a 0b                	push   $0xb
  801941:	e8 e5 fe ff ff       	call   80182b <syscall>
  801946:	83 c4 18             	add    $0x18,%esp
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 0c                	push   $0xc
  80195a:	e8 cc fe ff ff       	call   80182b <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 0d                	push   $0xd
  801973:	e8 b3 fe ff ff       	call   80182b <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 0e                	push   $0xe
  80198c:	e8 9a fe ff ff       	call   80182b <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 0f                	push   $0xf
  8019a5:	e8 81 fe ff ff       	call   80182b <syscall>
  8019aa:	83 c4 18             	add    $0x18,%esp
}
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	ff 75 08             	pushl  0x8(%ebp)
  8019bd:	6a 10                	push   $0x10
  8019bf:	e8 67 fe ff ff       	call   80182b <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
}
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 11                	push   $0x11
  8019d8:	e8 4e fe ff ff       	call   80182b <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
}
  8019e0:	90                   	nop
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <sys_cputc>:

void
sys_cputc(const char c)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	83 ec 04             	sub    $0x4,%esp
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019ef:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	50                   	push   %eax
  8019fc:	6a 01                	push   $0x1
  8019fe:	e8 28 fe ff ff       	call   80182b <syscall>
  801a03:	83 c4 18             	add    $0x18,%esp
}
  801a06:	90                   	nop
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 14                	push   $0x14
  801a18:	e8 0e fe ff ff       	call   80182b <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
}
  801a20:	90                   	nop
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	83 ec 04             	sub    $0x4,%esp
  801a29:	8b 45 10             	mov    0x10(%ebp),%eax
  801a2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a2f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a32:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	6a 00                	push   $0x0
  801a3b:	51                   	push   %ecx
  801a3c:	52                   	push   %edx
  801a3d:	ff 75 0c             	pushl  0xc(%ebp)
  801a40:	50                   	push   %eax
  801a41:	6a 15                	push   $0x15
  801a43:	e8 e3 fd ff ff       	call   80182b <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a53:	8b 45 08             	mov    0x8(%ebp),%eax
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	52                   	push   %edx
  801a5d:	50                   	push   %eax
  801a5e:	6a 16                	push   $0x16
  801a60:	e8 c6 fd ff ff       	call   80182b <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a6d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a73:	8b 45 08             	mov    0x8(%ebp),%eax
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	51                   	push   %ecx
  801a7b:	52                   	push   %edx
  801a7c:	50                   	push   %eax
  801a7d:	6a 17                	push   $0x17
  801a7f:	e8 a7 fd ff ff       	call   80182b <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	52                   	push   %edx
  801a99:	50                   	push   %eax
  801a9a:	6a 18                	push   $0x18
  801a9c:	e8 8a fd ff ff       	call   80182b <syscall>
  801aa1:	83 c4 18             	add    $0x18,%esp
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	6a 00                	push   $0x0
  801aae:	ff 75 14             	pushl  0x14(%ebp)
  801ab1:	ff 75 10             	pushl  0x10(%ebp)
  801ab4:	ff 75 0c             	pushl  0xc(%ebp)
  801ab7:	50                   	push   %eax
  801ab8:	6a 19                	push   $0x19
  801aba:	e8 6c fd ff ff       	call   80182b <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
}
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	50                   	push   %eax
  801ad3:	6a 1a                	push   $0x1a
  801ad5:	e8 51 fd ff ff       	call   80182b <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
}
  801add:	90                   	nop
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	50                   	push   %eax
  801aef:	6a 1b                	push   $0x1b
  801af1:	e8 35 fd ff ff       	call   80182b <syscall>
  801af6:	83 c4 18             	add    $0x18,%esp
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_getenvid>:

int32 sys_getenvid(void)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 05                	push   $0x5
  801b0a:	e8 1c fd ff ff       	call   80182b <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 06                	push   $0x6
  801b23:	e8 03 fd ff ff       	call   80182b <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
}
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 07                	push   $0x7
  801b3c:	e8 ea fc ff ff       	call   80182b <syscall>
  801b41:	83 c4 18             	add    $0x18,%esp
}
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <sys_exit_env>:


void sys_exit_env(void)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 1c                	push   $0x1c
  801b55:	e8 d1 fc ff ff       	call   80182b <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
}
  801b5d:	90                   	nop
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b66:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b69:	8d 50 04             	lea    0x4(%eax),%edx
  801b6c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	52                   	push   %edx
  801b76:	50                   	push   %eax
  801b77:	6a 1d                	push   $0x1d
  801b79:	e8 ad fc ff ff       	call   80182b <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
	return result;
  801b81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b84:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b87:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b8a:	89 01                	mov    %eax,(%ecx)
  801b8c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	c9                   	leave  
  801b93:	c2 04 00             	ret    $0x4

00801b96 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	ff 75 10             	pushl  0x10(%ebp)
  801ba0:	ff 75 0c             	pushl  0xc(%ebp)
  801ba3:	ff 75 08             	pushl  0x8(%ebp)
  801ba6:	6a 13                	push   $0x13
  801ba8:	e8 7e fc ff ff       	call   80182b <syscall>
  801bad:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb0:	90                   	nop
}
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 1e                	push   $0x1e
  801bc2:	e8 64 fc ff ff       	call   80182b <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	83 ec 04             	sub    $0x4,%esp
  801bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bd8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	50                   	push   %eax
  801be5:	6a 1f                	push   $0x1f
  801be7:	e8 3f fc ff ff       	call   80182b <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
	return ;
  801bef:	90                   	nop
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <rsttst>:
void rsttst()
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 21                	push   $0x21
  801c01:	e8 25 fc ff ff       	call   80182b <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
	return ;
  801c09:	90                   	nop
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
  801c0f:	83 ec 04             	sub    $0x4,%esp
  801c12:	8b 45 14             	mov    0x14(%ebp),%eax
  801c15:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c18:	8b 55 18             	mov    0x18(%ebp),%edx
  801c1b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c1f:	52                   	push   %edx
  801c20:	50                   	push   %eax
  801c21:	ff 75 10             	pushl  0x10(%ebp)
  801c24:	ff 75 0c             	pushl  0xc(%ebp)
  801c27:	ff 75 08             	pushl  0x8(%ebp)
  801c2a:	6a 20                	push   $0x20
  801c2c:	e8 fa fb ff ff       	call   80182b <syscall>
  801c31:	83 c4 18             	add    $0x18,%esp
	return ;
  801c34:	90                   	nop
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <chktst>:
void chktst(uint32 n)
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	ff 75 08             	pushl  0x8(%ebp)
  801c45:	6a 22                	push   $0x22
  801c47:	e8 df fb ff ff       	call   80182b <syscall>
  801c4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4f:	90                   	nop
}
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <inctst>:

void inctst()
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 23                	push   $0x23
  801c61:	e8 c5 fb ff ff       	call   80182b <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
	return ;
  801c69:	90                   	nop
}
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <gettst>:
uint32 gettst()
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 24                	push   $0x24
  801c7b:	e8 ab fb ff ff       	call   80182b <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 25                	push   $0x25
  801c97:	e8 8f fb ff ff       	call   80182b <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
  801c9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ca2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ca6:	75 07                	jne    801caf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ca8:	b8 01 00 00 00       	mov    $0x1,%eax
  801cad:	eb 05                	jmp    801cb4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801caf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 25                	push   $0x25
  801cc8:	e8 5e fb ff ff       	call   80182b <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
  801cd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cd3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cd7:	75 07                	jne    801ce0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cd9:	b8 01 00 00 00       	mov    $0x1,%eax
  801cde:	eb 05                	jmp    801ce5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ce0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 25                	push   $0x25
  801cf9:	e8 2d fb ff ff       	call   80182b <syscall>
  801cfe:	83 c4 18             	add    $0x18,%esp
  801d01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d04:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d08:	75 07                	jne    801d11 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d0f:	eb 05                	jmp    801d16 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 25                	push   $0x25
  801d2a:	e8 fc fa ff ff       	call   80182b <syscall>
  801d2f:	83 c4 18             	add    $0x18,%esp
  801d32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d35:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d39:	75 07                	jne    801d42 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d3b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d40:	eb 05                	jmp    801d47 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	ff 75 08             	pushl  0x8(%ebp)
  801d57:	6a 26                	push   $0x26
  801d59:	e8 cd fa ff ff       	call   80182b <syscall>
  801d5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d61:	90                   	nop
}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
  801d67:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d68:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d6b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d71:	8b 45 08             	mov    0x8(%ebp),%eax
  801d74:	6a 00                	push   $0x0
  801d76:	53                   	push   %ebx
  801d77:	51                   	push   %ecx
  801d78:	52                   	push   %edx
  801d79:	50                   	push   %eax
  801d7a:	6a 27                	push   $0x27
  801d7c:	e8 aa fa ff ff       	call   80182b <syscall>
  801d81:	83 c4 18             	add    $0x18,%esp
}
  801d84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	52                   	push   %edx
  801d99:	50                   	push   %eax
  801d9a:	6a 28                	push   $0x28
  801d9c:	e8 8a fa ff ff       	call   80182b <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
}
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801da9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801dac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	6a 00                	push   $0x0
  801db4:	51                   	push   %ecx
  801db5:	ff 75 10             	pushl  0x10(%ebp)
  801db8:	52                   	push   %edx
  801db9:	50                   	push   %eax
  801dba:	6a 29                	push   $0x29
  801dbc:	e8 6a fa ff ff       	call   80182b <syscall>
  801dc1:	83 c4 18             	add    $0x18,%esp
}
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    

00801dc6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	ff 75 10             	pushl  0x10(%ebp)
  801dd0:	ff 75 0c             	pushl  0xc(%ebp)
  801dd3:	ff 75 08             	pushl  0x8(%ebp)
  801dd6:	6a 12                	push   $0x12
  801dd8:	e8 4e fa ff ff       	call   80182b <syscall>
  801ddd:	83 c4 18             	add    $0x18,%esp
	return ;
  801de0:	90                   	nop
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801de6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	52                   	push   %edx
  801df3:	50                   	push   %eax
  801df4:	6a 2a                	push   $0x2a
  801df6:	e8 30 fa ff ff       	call   80182b <syscall>
  801dfb:	83 c4 18             	add    $0x18,%esp
	return;
  801dfe:	90                   	nop
}
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801e04:	8b 45 08             	mov    0x8(%ebp),%eax
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	50                   	push   %eax
  801e10:	6a 2b                	push   $0x2b
  801e12:	e8 14 fa ff ff       	call   80182b <syscall>
  801e17:	83 c4 18             	add    $0x18,%esp
}
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	ff 75 0c             	pushl  0xc(%ebp)
  801e28:	ff 75 08             	pushl  0x8(%ebp)
  801e2b:	6a 2c                	push   $0x2c
  801e2d:	e8 f9 f9 ff ff       	call   80182b <syscall>
  801e32:	83 c4 18             	add    $0x18,%esp
	return;
  801e35:	90                   	nop
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	ff 75 0c             	pushl  0xc(%ebp)
  801e44:	ff 75 08             	pushl  0x8(%ebp)
  801e47:	6a 2d                	push   $0x2d
  801e49:	e8 dd f9 ff ff       	call   80182b <syscall>
  801e4e:	83 c4 18             	add    $0x18,%esp
	return;
  801e51:	90                   	nop
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5d:	83 e8 04             	sub    $0x4,%eax
  801e60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801e63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e66:	8b 00                	mov    (%eax),%eax
  801e68:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    

00801e6d <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
  801e70:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e73:	8b 45 08             	mov    0x8(%ebp),%eax
  801e76:	83 e8 04             	sub    $0x4,%eax
  801e79:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801e7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e7f:	8b 00                	mov    (%eax),%eax
  801e81:	83 e0 01             	and    $0x1,%eax
  801e84:	85 c0                	test   %eax,%eax
  801e86:	0f 94 c0             	sete   %al
}
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801e91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9b:	83 f8 02             	cmp    $0x2,%eax
  801e9e:	74 2b                	je     801ecb <alloc_block+0x40>
  801ea0:	83 f8 02             	cmp    $0x2,%eax
  801ea3:	7f 07                	jg     801eac <alloc_block+0x21>
  801ea5:	83 f8 01             	cmp    $0x1,%eax
  801ea8:	74 0e                	je     801eb8 <alloc_block+0x2d>
  801eaa:	eb 58                	jmp    801f04 <alloc_block+0x79>
  801eac:	83 f8 03             	cmp    $0x3,%eax
  801eaf:	74 2d                	je     801ede <alloc_block+0x53>
  801eb1:	83 f8 04             	cmp    $0x4,%eax
  801eb4:	74 3b                	je     801ef1 <alloc_block+0x66>
  801eb6:	eb 4c                	jmp    801f04 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801eb8:	83 ec 0c             	sub    $0xc,%esp
  801ebb:	ff 75 08             	pushl  0x8(%ebp)
  801ebe:	e8 11 03 00 00       	call   8021d4 <alloc_block_FF>
  801ec3:	83 c4 10             	add    $0x10,%esp
  801ec6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ec9:	eb 4a                	jmp    801f15 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801ecb:	83 ec 0c             	sub    $0xc,%esp
  801ece:	ff 75 08             	pushl  0x8(%ebp)
  801ed1:	e8 c7 19 00 00       	call   80389d <alloc_block_NF>
  801ed6:	83 c4 10             	add    $0x10,%esp
  801ed9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801edc:	eb 37                	jmp    801f15 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801ede:	83 ec 0c             	sub    $0xc,%esp
  801ee1:	ff 75 08             	pushl  0x8(%ebp)
  801ee4:	e8 a7 07 00 00       	call   802690 <alloc_block_BF>
  801ee9:	83 c4 10             	add    $0x10,%esp
  801eec:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801eef:	eb 24                	jmp    801f15 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801ef1:	83 ec 0c             	sub    $0xc,%esp
  801ef4:	ff 75 08             	pushl  0x8(%ebp)
  801ef7:	e8 84 19 00 00       	call   803880 <alloc_block_WF>
  801efc:	83 c4 10             	add    $0x10,%esp
  801eff:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f02:	eb 11                	jmp    801f15 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f04:	83 ec 0c             	sub    $0xc,%esp
  801f07:	68 e8 43 80 00       	push   $0x8043e8
  801f0c:	e8 4d e6 ff ff       	call   80055e <cprintf>
  801f11:	83 c4 10             	add    $0x10,%esp
		break;
  801f14:	90                   	nop
	}
	return va;
  801f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	53                   	push   %ebx
  801f1e:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801f21:	83 ec 0c             	sub    $0xc,%esp
  801f24:	68 08 44 80 00       	push   $0x804408
  801f29:	e8 30 e6 ff ff       	call   80055e <cprintf>
  801f2e:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801f31:	83 ec 0c             	sub    $0xc,%esp
  801f34:	68 33 44 80 00       	push   $0x804433
  801f39:	e8 20 e6 ff ff       	call   80055e <cprintf>
  801f3e:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801f41:	8b 45 08             	mov    0x8(%ebp),%eax
  801f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f47:	eb 37                	jmp    801f80 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801f49:	83 ec 0c             	sub    $0xc,%esp
  801f4c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f4f:	e8 19 ff ff ff       	call   801e6d <is_free_block>
  801f54:	83 c4 10             	add    $0x10,%esp
  801f57:	0f be d8             	movsbl %al,%ebx
  801f5a:	83 ec 0c             	sub    $0xc,%esp
  801f5d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f60:	e8 ef fe ff ff       	call   801e54 <get_block_size>
  801f65:	83 c4 10             	add    $0x10,%esp
  801f68:	83 ec 04             	sub    $0x4,%esp
  801f6b:	53                   	push   %ebx
  801f6c:	50                   	push   %eax
  801f6d:	68 4b 44 80 00       	push   $0x80444b
  801f72:	e8 e7 e5 ff ff       	call   80055e <cprintf>
  801f77:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801f7a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f84:	74 07                	je     801f8d <print_blocks_list+0x73>
  801f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f89:	8b 00                	mov    (%eax),%eax
  801f8b:	eb 05                	jmp    801f92 <print_blocks_list+0x78>
  801f8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f92:	89 45 10             	mov    %eax,0x10(%ebp)
  801f95:	8b 45 10             	mov    0x10(%ebp),%eax
  801f98:	85 c0                	test   %eax,%eax
  801f9a:	75 ad                	jne    801f49 <print_blocks_list+0x2f>
  801f9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa0:	75 a7                	jne    801f49 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801fa2:	83 ec 0c             	sub    $0xc,%esp
  801fa5:	68 08 44 80 00       	push   $0x804408
  801faa:	e8 af e5 ff ff       	call   80055e <cprintf>
  801faf:	83 c4 10             	add    $0x10,%esp

}
  801fb2:	90                   	nop
  801fb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
  801fbb:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc1:	83 e0 01             	and    $0x1,%eax
  801fc4:	85 c0                	test   %eax,%eax
  801fc6:	74 03                	je     801fcb <initialize_dynamic_allocator+0x13>
  801fc8:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801fcb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fcf:	0f 84 c7 01 00 00    	je     80219c <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801fd5:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801fdc:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  801fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe5:	01 d0                	add    %edx,%eax
  801fe7:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801fec:	0f 87 ad 01 00 00    	ja     80219f <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff5:	85 c0                	test   %eax,%eax
  801ff7:	0f 89 a5 01 00 00    	jns    8021a2 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801ffd:	8b 55 08             	mov    0x8(%ebp),%edx
  802000:	8b 45 0c             	mov    0xc(%ebp),%eax
  802003:	01 d0                	add    %edx,%eax
  802005:	83 e8 04             	sub    $0x4,%eax
  802008:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80200d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802014:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802019:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80201c:	e9 87 00 00 00       	jmp    8020a8 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802021:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802025:	75 14                	jne    80203b <initialize_dynamic_allocator+0x83>
  802027:	83 ec 04             	sub    $0x4,%esp
  80202a:	68 63 44 80 00       	push   $0x804463
  80202f:	6a 79                	push   $0x79
  802031:	68 81 44 80 00       	push   $0x804481
  802036:	e8 66 e2 ff ff       	call   8002a1 <_panic>
  80203b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203e:	8b 00                	mov    (%eax),%eax
  802040:	85 c0                	test   %eax,%eax
  802042:	74 10                	je     802054 <initialize_dynamic_allocator+0x9c>
  802044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802047:	8b 00                	mov    (%eax),%eax
  802049:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204c:	8b 52 04             	mov    0x4(%edx),%edx
  80204f:	89 50 04             	mov    %edx,0x4(%eax)
  802052:	eb 0b                	jmp    80205f <initialize_dynamic_allocator+0xa7>
  802054:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802057:	8b 40 04             	mov    0x4(%eax),%eax
  80205a:	a3 30 50 80 00       	mov    %eax,0x805030
  80205f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802062:	8b 40 04             	mov    0x4(%eax),%eax
  802065:	85 c0                	test   %eax,%eax
  802067:	74 0f                	je     802078 <initialize_dynamic_allocator+0xc0>
  802069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206c:	8b 40 04             	mov    0x4(%eax),%eax
  80206f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802072:	8b 12                	mov    (%edx),%edx
  802074:	89 10                	mov    %edx,(%eax)
  802076:	eb 0a                	jmp    802082 <initialize_dynamic_allocator+0xca>
  802078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207b:	8b 00                	mov    (%eax),%eax
  80207d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802085:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80208b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802095:	a1 38 50 80 00       	mov    0x805038,%eax
  80209a:	48                   	dec    %eax
  80209b:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8020a0:	a1 34 50 80 00       	mov    0x805034,%eax
  8020a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020ac:	74 07                	je     8020b5 <initialize_dynamic_allocator+0xfd>
  8020ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b1:	8b 00                	mov    (%eax),%eax
  8020b3:	eb 05                	jmp    8020ba <initialize_dynamic_allocator+0x102>
  8020b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ba:	a3 34 50 80 00       	mov    %eax,0x805034
  8020bf:	a1 34 50 80 00       	mov    0x805034,%eax
  8020c4:	85 c0                	test   %eax,%eax
  8020c6:	0f 85 55 ff ff ff    	jne    802021 <initialize_dynamic_allocator+0x69>
  8020cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020d0:	0f 85 4b ff ff ff    	jne    802021 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8020dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020df:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8020e5:	a1 44 50 80 00       	mov    0x805044,%eax
  8020ea:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8020ef:	a1 40 50 80 00       	mov    0x805040,%eax
  8020f4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8020fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fd:	83 c0 08             	add    $0x8,%eax
  802100:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802103:	8b 45 08             	mov    0x8(%ebp),%eax
  802106:	83 c0 04             	add    $0x4,%eax
  802109:	8b 55 0c             	mov    0xc(%ebp),%edx
  80210c:	83 ea 08             	sub    $0x8,%edx
  80210f:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802111:	8b 55 0c             	mov    0xc(%ebp),%edx
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	01 d0                	add    %edx,%eax
  802119:	83 e8 08             	sub    $0x8,%eax
  80211c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211f:	83 ea 08             	sub    $0x8,%edx
  802122:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802124:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802127:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80212d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802130:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802137:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80213b:	75 17                	jne    802154 <initialize_dynamic_allocator+0x19c>
  80213d:	83 ec 04             	sub    $0x4,%esp
  802140:	68 9c 44 80 00       	push   $0x80449c
  802145:	68 90 00 00 00       	push   $0x90
  80214a:	68 81 44 80 00       	push   $0x804481
  80214f:	e8 4d e1 ff ff       	call   8002a1 <_panic>
  802154:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80215a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80215d:	89 10                	mov    %edx,(%eax)
  80215f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802162:	8b 00                	mov    (%eax),%eax
  802164:	85 c0                	test   %eax,%eax
  802166:	74 0d                	je     802175 <initialize_dynamic_allocator+0x1bd>
  802168:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80216d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802170:	89 50 04             	mov    %edx,0x4(%eax)
  802173:	eb 08                	jmp    80217d <initialize_dynamic_allocator+0x1c5>
  802175:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802178:	a3 30 50 80 00       	mov    %eax,0x805030
  80217d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802180:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802185:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802188:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80218f:	a1 38 50 80 00       	mov    0x805038,%eax
  802194:	40                   	inc    %eax
  802195:	a3 38 50 80 00       	mov    %eax,0x805038
  80219a:	eb 07                	jmp    8021a3 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80219c:	90                   	nop
  80219d:	eb 04                	jmp    8021a3 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80219f:	90                   	nop
  8021a0:	eb 01                	jmp    8021a3 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8021a2:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8021a3:	c9                   	leave  
  8021a4:	c3                   	ret    

008021a5 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8021a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ab:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8021ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b1:	8d 50 fc             	lea    -0x4(%eax),%edx
  8021b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b7:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8021b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bc:	83 e8 04             	sub    $0x4,%eax
  8021bf:	8b 00                	mov    (%eax),%eax
  8021c1:	83 e0 fe             	and    $0xfffffffe,%eax
  8021c4:	8d 50 f8             	lea    -0x8(%eax),%edx
  8021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ca:	01 c2                	add    %eax,%edx
  8021cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021cf:	89 02                	mov    %eax,(%edx)
}
  8021d1:	90                   	nop
  8021d2:	5d                   	pop    %ebp
  8021d3:	c3                   	ret    

008021d4 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8021d4:	55                   	push   %ebp
  8021d5:	89 e5                	mov    %esp,%ebp
  8021d7:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8021da:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dd:	83 e0 01             	and    $0x1,%eax
  8021e0:	85 c0                	test   %eax,%eax
  8021e2:	74 03                	je     8021e7 <alloc_block_FF+0x13>
  8021e4:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8021e7:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8021eb:	77 07                	ja     8021f4 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8021ed:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8021f4:	a1 24 50 80 00       	mov    0x805024,%eax
  8021f9:	85 c0                	test   %eax,%eax
  8021fb:	75 73                	jne    802270 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8021fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802200:	83 c0 10             	add    $0x10,%eax
  802203:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802206:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80220d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802210:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802213:	01 d0                	add    %edx,%eax
  802215:	48                   	dec    %eax
  802216:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80221c:	ba 00 00 00 00       	mov    $0x0,%edx
  802221:	f7 75 ec             	divl   -0x14(%ebp)
  802224:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802227:	29 d0                	sub    %edx,%eax
  802229:	c1 e8 0c             	shr    $0xc,%eax
  80222c:	83 ec 0c             	sub    $0xc,%esp
  80222f:	50                   	push   %eax
  802230:	e8 c3 f0 ff ff       	call   8012f8 <sbrk>
  802235:	83 c4 10             	add    $0x10,%esp
  802238:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80223b:	83 ec 0c             	sub    $0xc,%esp
  80223e:	6a 00                	push   $0x0
  802240:	e8 b3 f0 ff ff       	call   8012f8 <sbrk>
  802245:	83 c4 10             	add    $0x10,%esp
  802248:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80224b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80224e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802251:	83 ec 08             	sub    $0x8,%esp
  802254:	50                   	push   %eax
  802255:	ff 75 e4             	pushl  -0x1c(%ebp)
  802258:	e8 5b fd ff ff       	call   801fb8 <initialize_dynamic_allocator>
  80225d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802260:	83 ec 0c             	sub    $0xc,%esp
  802263:	68 bf 44 80 00       	push   $0x8044bf
  802268:	e8 f1 e2 ff ff       	call   80055e <cprintf>
  80226d:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802270:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802274:	75 0a                	jne    802280 <alloc_block_FF+0xac>
	        return NULL;
  802276:	b8 00 00 00 00       	mov    $0x0,%eax
  80227b:	e9 0e 04 00 00       	jmp    80268e <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802280:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802287:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80228c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80228f:	e9 f3 02 00 00       	jmp    802587 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802297:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80229a:	83 ec 0c             	sub    $0xc,%esp
  80229d:	ff 75 bc             	pushl  -0x44(%ebp)
  8022a0:	e8 af fb ff ff       	call   801e54 <get_block_size>
  8022a5:	83 c4 10             	add    $0x10,%esp
  8022a8:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	83 c0 08             	add    $0x8,%eax
  8022b1:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8022b4:	0f 87 c5 02 00 00    	ja     80257f <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	83 c0 18             	add    $0x18,%eax
  8022c0:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8022c3:	0f 87 19 02 00 00    	ja     8024e2 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8022c9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8022cc:	2b 45 08             	sub    0x8(%ebp),%eax
  8022cf:	83 e8 08             	sub    $0x8,%eax
  8022d2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8022d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d8:	8d 50 08             	lea    0x8(%eax),%edx
  8022db:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8022de:	01 d0                	add    %edx,%eax
  8022e0:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	83 c0 08             	add    $0x8,%eax
  8022e9:	83 ec 04             	sub    $0x4,%esp
  8022ec:	6a 01                	push   $0x1
  8022ee:	50                   	push   %eax
  8022ef:	ff 75 bc             	pushl  -0x44(%ebp)
  8022f2:	e8 ae fe ff ff       	call   8021a5 <set_block_data>
  8022f7:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8022fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fd:	8b 40 04             	mov    0x4(%eax),%eax
  802300:	85 c0                	test   %eax,%eax
  802302:	75 68                	jne    80236c <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802304:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802308:	75 17                	jne    802321 <alloc_block_FF+0x14d>
  80230a:	83 ec 04             	sub    $0x4,%esp
  80230d:	68 9c 44 80 00       	push   $0x80449c
  802312:	68 d7 00 00 00       	push   $0xd7
  802317:	68 81 44 80 00       	push   $0x804481
  80231c:	e8 80 df ff ff       	call   8002a1 <_panic>
  802321:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802327:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80232a:	89 10                	mov    %edx,(%eax)
  80232c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80232f:	8b 00                	mov    (%eax),%eax
  802331:	85 c0                	test   %eax,%eax
  802333:	74 0d                	je     802342 <alloc_block_FF+0x16e>
  802335:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80233a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80233d:	89 50 04             	mov    %edx,0x4(%eax)
  802340:	eb 08                	jmp    80234a <alloc_block_FF+0x176>
  802342:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802345:	a3 30 50 80 00       	mov    %eax,0x805030
  80234a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80234d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802352:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802355:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80235c:	a1 38 50 80 00       	mov    0x805038,%eax
  802361:	40                   	inc    %eax
  802362:	a3 38 50 80 00       	mov    %eax,0x805038
  802367:	e9 dc 00 00 00       	jmp    802448 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	8b 00                	mov    (%eax),%eax
  802371:	85 c0                	test   %eax,%eax
  802373:	75 65                	jne    8023da <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802375:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802379:	75 17                	jne    802392 <alloc_block_FF+0x1be>
  80237b:	83 ec 04             	sub    $0x4,%esp
  80237e:	68 d0 44 80 00       	push   $0x8044d0
  802383:	68 db 00 00 00       	push   $0xdb
  802388:	68 81 44 80 00       	push   $0x804481
  80238d:	e8 0f df ff ff       	call   8002a1 <_panic>
  802392:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802398:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80239b:	89 50 04             	mov    %edx,0x4(%eax)
  80239e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023a1:	8b 40 04             	mov    0x4(%eax),%eax
  8023a4:	85 c0                	test   %eax,%eax
  8023a6:	74 0c                	je     8023b4 <alloc_block_FF+0x1e0>
  8023a8:	a1 30 50 80 00       	mov    0x805030,%eax
  8023ad:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023b0:	89 10                	mov    %edx,(%eax)
  8023b2:	eb 08                	jmp    8023bc <alloc_block_FF+0x1e8>
  8023b4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023b7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023bc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023bf:	a3 30 50 80 00       	mov    %eax,0x805030
  8023c4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023cd:	a1 38 50 80 00       	mov    0x805038,%eax
  8023d2:	40                   	inc    %eax
  8023d3:	a3 38 50 80 00       	mov    %eax,0x805038
  8023d8:	eb 6e                	jmp    802448 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8023da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023de:	74 06                	je     8023e6 <alloc_block_FF+0x212>
  8023e0:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023e4:	75 17                	jne    8023fd <alloc_block_FF+0x229>
  8023e6:	83 ec 04             	sub    $0x4,%esp
  8023e9:	68 f4 44 80 00       	push   $0x8044f4
  8023ee:	68 df 00 00 00       	push   $0xdf
  8023f3:	68 81 44 80 00       	push   $0x804481
  8023f8:	e8 a4 de ff ff       	call   8002a1 <_panic>
  8023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802400:	8b 10                	mov    (%eax),%edx
  802402:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802405:	89 10                	mov    %edx,(%eax)
  802407:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80240a:	8b 00                	mov    (%eax),%eax
  80240c:	85 c0                	test   %eax,%eax
  80240e:	74 0b                	je     80241b <alloc_block_FF+0x247>
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	8b 00                	mov    (%eax),%eax
  802415:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802418:	89 50 04             	mov    %edx,0x4(%eax)
  80241b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802421:	89 10                	mov    %edx,(%eax)
  802423:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802426:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802429:	89 50 04             	mov    %edx,0x4(%eax)
  80242c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80242f:	8b 00                	mov    (%eax),%eax
  802431:	85 c0                	test   %eax,%eax
  802433:	75 08                	jne    80243d <alloc_block_FF+0x269>
  802435:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802438:	a3 30 50 80 00       	mov    %eax,0x805030
  80243d:	a1 38 50 80 00       	mov    0x805038,%eax
  802442:	40                   	inc    %eax
  802443:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802448:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80244c:	75 17                	jne    802465 <alloc_block_FF+0x291>
  80244e:	83 ec 04             	sub    $0x4,%esp
  802451:	68 63 44 80 00       	push   $0x804463
  802456:	68 e1 00 00 00       	push   $0xe1
  80245b:	68 81 44 80 00       	push   $0x804481
  802460:	e8 3c de ff ff       	call   8002a1 <_panic>
  802465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802468:	8b 00                	mov    (%eax),%eax
  80246a:	85 c0                	test   %eax,%eax
  80246c:	74 10                	je     80247e <alloc_block_FF+0x2aa>
  80246e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802471:	8b 00                	mov    (%eax),%eax
  802473:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802476:	8b 52 04             	mov    0x4(%edx),%edx
  802479:	89 50 04             	mov    %edx,0x4(%eax)
  80247c:	eb 0b                	jmp    802489 <alloc_block_FF+0x2b5>
  80247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802481:	8b 40 04             	mov    0x4(%eax),%eax
  802484:	a3 30 50 80 00       	mov    %eax,0x805030
  802489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248c:	8b 40 04             	mov    0x4(%eax),%eax
  80248f:	85 c0                	test   %eax,%eax
  802491:	74 0f                	je     8024a2 <alloc_block_FF+0x2ce>
  802493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802496:	8b 40 04             	mov    0x4(%eax),%eax
  802499:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249c:	8b 12                	mov    (%edx),%edx
  80249e:	89 10                	mov    %edx,(%eax)
  8024a0:	eb 0a                	jmp    8024ac <alloc_block_FF+0x2d8>
  8024a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a5:	8b 00                	mov    (%eax),%eax
  8024a7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024bf:	a1 38 50 80 00       	mov    0x805038,%eax
  8024c4:	48                   	dec    %eax
  8024c5:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8024ca:	83 ec 04             	sub    $0x4,%esp
  8024cd:	6a 00                	push   $0x0
  8024cf:	ff 75 b4             	pushl  -0x4c(%ebp)
  8024d2:	ff 75 b0             	pushl  -0x50(%ebp)
  8024d5:	e8 cb fc ff ff       	call   8021a5 <set_block_data>
  8024da:	83 c4 10             	add    $0x10,%esp
  8024dd:	e9 95 00 00 00       	jmp    802577 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8024e2:	83 ec 04             	sub    $0x4,%esp
  8024e5:	6a 01                	push   $0x1
  8024e7:	ff 75 b8             	pushl  -0x48(%ebp)
  8024ea:	ff 75 bc             	pushl  -0x44(%ebp)
  8024ed:	e8 b3 fc ff ff       	call   8021a5 <set_block_data>
  8024f2:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8024f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f9:	75 17                	jne    802512 <alloc_block_FF+0x33e>
  8024fb:	83 ec 04             	sub    $0x4,%esp
  8024fe:	68 63 44 80 00       	push   $0x804463
  802503:	68 e8 00 00 00       	push   $0xe8
  802508:	68 81 44 80 00       	push   $0x804481
  80250d:	e8 8f dd ff ff       	call   8002a1 <_panic>
  802512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802515:	8b 00                	mov    (%eax),%eax
  802517:	85 c0                	test   %eax,%eax
  802519:	74 10                	je     80252b <alloc_block_FF+0x357>
  80251b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251e:	8b 00                	mov    (%eax),%eax
  802520:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802523:	8b 52 04             	mov    0x4(%edx),%edx
  802526:	89 50 04             	mov    %edx,0x4(%eax)
  802529:	eb 0b                	jmp    802536 <alloc_block_FF+0x362>
  80252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252e:	8b 40 04             	mov    0x4(%eax),%eax
  802531:	a3 30 50 80 00       	mov    %eax,0x805030
  802536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802539:	8b 40 04             	mov    0x4(%eax),%eax
  80253c:	85 c0                	test   %eax,%eax
  80253e:	74 0f                	je     80254f <alloc_block_FF+0x37b>
  802540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802543:	8b 40 04             	mov    0x4(%eax),%eax
  802546:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802549:	8b 12                	mov    (%edx),%edx
  80254b:	89 10                	mov    %edx,(%eax)
  80254d:	eb 0a                	jmp    802559 <alloc_block_FF+0x385>
  80254f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802552:	8b 00                	mov    (%eax),%eax
  802554:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802565:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80256c:	a1 38 50 80 00       	mov    0x805038,%eax
  802571:	48                   	dec    %eax
  802572:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802577:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80257a:	e9 0f 01 00 00       	jmp    80268e <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80257f:	a1 34 50 80 00       	mov    0x805034,%eax
  802584:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802587:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258b:	74 07                	je     802594 <alloc_block_FF+0x3c0>
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	8b 00                	mov    (%eax),%eax
  802592:	eb 05                	jmp    802599 <alloc_block_FF+0x3c5>
  802594:	b8 00 00 00 00       	mov    $0x0,%eax
  802599:	a3 34 50 80 00       	mov    %eax,0x805034
  80259e:	a1 34 50 80 00       	mov    0x805034,%eax
  8025a3:	85 c0                	test   %eax,%eax
  8025a5:	0f 85 e9 fc ff ff    	jne    802294 <alloc_block_FF+0xc0>
  8025ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025af:	0f 85 df fc ff ff    	jne    802294 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8025b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b8:	83 c0 08             	add    $0x8,%eax
  8025bb:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8025be:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8025c5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025cb:	01 d0                	add    %edx,%eax
  8025cd:	48                   	dec    %eax
  8025ce:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8025d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8025d9:	f7 75 d8             	divl   -0x28(%ebp)
  8025dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025df:	29 d0                	sub    %edx,%eax
  8025e1:	c1 e8 0c             	shr    $0xc,%eax
  8025e4:	83 ec 0c             	sub    $0xc,%esp
  8025e7:	50                   	push   %eax
  8025e8:	e8 0b ed ff ff       	call   8012f8 <sbrk>
  8025ed:	83 c4 10             	add    $0x10,%esp
  8025f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8025f3:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8025f7:	75 0a                	jne    802603 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8025f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fe:	e9 8b 00 00 00       	jmp    80268e <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802603:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80260a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80260d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802610:	01 d0                	add    %edx,%eax
  802612:	48                   	dec    %eax
  802613:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802616:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802619:	ba 00 00 00 00       	mov    $0x0,%edx
  80261e:	f7 75 cc             	divl   -0x34(%ebp)
  802621:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802624:	29 d0                	sub    %edx,%eax
  802626:	8d 50 fc             	lea    -0x4(%eax),%edx
  802629:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80262c:	01 d0                	add    %edx,%eax
  80262e:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802633:	a1 40 50 80 00       	mov    0x805040,%eax
  802638:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80263e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802645:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802648:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80264b:	01 d0                	add    %edx,%eax
  80264d:	48                   	dec    %eax
  80264e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802651:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802654:	ba 00 00 00 00       	mov    $0x0,%edx
  802659:	f7 75 c4             	divl   -0x3c(%ebp)
  80265c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80265f:	29 d0                	sub    %edx,%eax
  802661:	83 ec 04             	sub    $0x4,%esp
  802664:	6a 01                	push   $0x1
  802666:	50                   	push   %eax
  802667:	ff 75 d0             	pushl  -0x30(%ebp)
  80266a:	e8 36 fb ff ff       	call   8021a5 <set_block_data>
  80266f:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802672:	83 ec 0c             	sub    $0xc,%esp
  802675:	ff 75 d0             	pushl  -0x30(%ebp)
  802678:	e8 f8 09 00 00       	call   803075 <free_block>
  80267d:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802680:	83 ec 0c             	sub    $0xc,%esp
  802683:	ff 75 08             	pushl  0x8(%ebp)
  802686:	e8 49 fb ff ff       	call   8021d4 <alloc_block_FF>
  80268b:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80268e:	c9                   	leave  
  80268f:	c3                   	ret    

00802690 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
  802693:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802696:	8b 45 08             	mov    0x8(%ebp),%eax
  802699:	83 e0 01             	and    $0x1,%eax
  80269c:	85 c0                	test   %eax,%eax
  80269e:	74 03                	je     8026a3 <alloc_block_BF+0x13>
  8026a0:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8026a3:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8026a7:	77 07                	ja     8026b0 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8026a9:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8026b0:	a1 24 50 80 00       	mov    0x805024,%eax
  8026b5:	85 c0                	test   %eax,%eax
  8026b7:	75 73                	jne    80272c <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8026b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bc:	83 c0 10             	add    $0x10,%eax
  8026bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8026c2:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8026c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026cf:	01 d0                	add    %edx,%eax
  8026d1:	48                   	dec    %eax
  8026d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8026d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8026dd:	f7 75 e0             	divl   -0x20(%ebp)
  8026e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026e3:	29 d0                	sub    %edx,%eax
  8026e5:	c1 e8 0c             	shr    $0xc,%eax
  8026e8:	83 ec 0c             	sub    $0xc,%esp
  8026eb:	50                   	push   %eax
  8026ec:	e8 07 ec ff ff       	call   8012f8 <sbrk>
  8026f1:	83 c4 10             	add    $0x10,%esp
  8026f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8026f7:	83 ec 0c             	sub    $0xc,%esp
  8026fa:	6a 00                	push   $0x0
  8026fc:	e8 f7 eb ff ff       	call   8012f8 <sbrk>
  802701:	83 c4 10             	add    $0x10,%esp
  802704:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802707:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80270a:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80270d:	83 ec 08             	sub    $0x8,%esp
  802710:	50                   	push   %eax
  802711:	ff 75 d8             	pushl  -0x28(%ebp)
  802714:	e8 9f f8 ff ff       	call   801fb8 <initialize_dynamic_allocator>
  802719:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80271c:	83 ec 0c             	sub    $0xc,%esp
  80271f:	68 bf 44 80 00       	push   $0x8044bf
  802724:	e8 35 de ff ff       	call   80055e <cprintf>
  802729:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80272c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802733:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80273a:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802741:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802748:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80274d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802750:	e9 1d 01 00 00       	jmp    802872 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802758:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80275b:	83 ec 0c             	sub    $0xc,%esp
  80275e:	ff 75 a8             	pushl  -0x58(%ebp)
  802761:	e8 ee f6 ff ff       	call   801e54 <get_block_size>
  802766:	83 c4 10             	add    $0x10,%esp
  802769:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80276c:	8b 45 08             	mov    0x8(%ebp),%eax
  80276f:	83 c0 08             	add    $0x8,%eax
  802772:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802775:	0f 87 ef 00 00 00    	ja     80286a <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80277b:	8b 45 08             	mov    0x8(%ebp),%eax
  80277e:	83 c0 18             	add    $0x18,%eax
  802781:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802784:	77 1d                	ja     8027a3 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802786:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802789:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80278c:	0f 86 d8 00 00 00    	jbe    80286a <alloc_block_BF+0x1da>
				{
					best_va = va;
  802792:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802795:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802798:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80279b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80279e:	e9 c7 00 00 00       	jmp    80286a <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8027a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a6:	83 c0 08             	add    $0x8,%eax
  8027a9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027ac:	0f 85 9d 00 00 00    	jne    80284f <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8027b2:	83 ec 04             	sub    $0x4,%esp
  8027b5:	6a 01                	push   $0x1
  8027b7:	ff 75 a4             	pushl  -0x5c(%ebp)
  8027ba:	ff 75 a8             	pushl  -0x58(%ebp)
  8027bd:	e8 e3 f9 ff ff       	call   8021a5 <set_block_data>
  8027c2:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8027c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c9:	75 17                	jne    8027e2 <alloc_block_BF+0x152>
  8027cb:	83 ec 04             	sub    $0x4,%esp
  8027ce:	68 63 44 80 00       	push   $0x804463
  8027d3:	68 2c 01 00 00       	push   $0x12c
  8027d8:	68 81 44 80 00       	push   $0x804481
  8027dd:	e8 bf da ff ff       	call   8002a1 <_panic>
  8027e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e5:	8b 00                	mov    (%eax),%eax
  8027e7:	85 c0                	test   %eax,%eax
  8027e9:	74 10                	je     8027fb <alloc_block_BF+0x16b>
  8027eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ee:	8b 00                	mov    (%eax),%eax
  8027f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f3:	8b 52 04             	mov    0x4(%edx),%edx
  8027f6:	89 50 04             	mov    %edx,0x4(%eax)
  8027f9:	eb 0b                	jmp    802806 <alloc_block_BF+0x176>
  8027fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fe:	8b 40 04             	mov    0x4(%eax),%eax
  802801:	a3 30 50 80 00       	mov    %eax,0x805030
  802806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802809:	8b 40 04             	mov    0x4(%eax),%eax
  80280c:	85 c0                	test   %eax,%eax
  80280e:	74 0f                	je     80281f <alloc_block_BF+0x18f>
  802810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802813:	8b 40 04             	mov    0x4(%eax),%eax
  802816:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802819:	8b 12                	mov    (%edx),%edx
  80281b:	89 10                	mov    %edx,(%eax)
  80281d:	eb 0a                	jmp    802829 <alloc_block_BF+0x199>
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	8b 00                	mov    (%eax),%eax
  802824:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802835:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80283c:	a1 38 50 80 00       	mov    0x805038,%eax
  802841:	48                   	dec    %eax
  802842:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802847:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80284a:	e9 01 04 00 00       	jmp    802c50 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  80284f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802852:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802855:	76 13                	jbe    80286a <alloc_block_BF+0x1da>
					{
						internal = 1;
  802857:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80285e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802861:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802864:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802867:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80286a:	a1 34 50 80 00       	mov    0x805034,%eax
  80286f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802872:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802876:	74 07                	je     80287f <alloc_block_BF+0x1ef>
  802878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287b:	8b 00                	mov    (%eax),%eax
  80287d:	eb 05                	jmp    802884 <alloc_block_BF+0x1f4>
  80287f:	b8 00 00 00 00       	mov    $0x0,%eax
  802884:	a3 34 50 80 00       	mov    %eax,0x805034
  802889:	a1 34 50 80 00       	mov    0x805034,%eax
  80288e:	85 c0                	test   %eax,%eax
  802890:	0f 85 bf fe ff ff    	jne    802755 <alloc_block_BF+0xc5>
  802896:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80289a:	0f 85 b5 fe ff ff    	jne    802755 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8028a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028a4:	0f 84 26 02 00 00    	je     802ad0 <alloc_block_BF+0x440>
  8028aa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028ae:	0f 85 1c 02 00 00    	jne    802ad0 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8028b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b7:	2b 45 08             	sub    0x8(%ebp),%eax
  8028ba:	83 e8 08             	sub    $0x8,%eax
  8028bd:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8028c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c3:	8d 50 08             	lea    0x8(%eax),%edx
  8028c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c9:	01 d0                	add    %edx,%eax
  8028cb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d1:	83 c0 08             	add    $0x8,%eax
  8028d4:	83 ec 04             	sub    $0x4,%esp
  8028d7:	6a 01                	push   $0x1
  8028d9:	50                   	push   %eax
  8028da:	ff 75 f0             	pushl  -0x10(%ebp)
  8028dd:	e8 c3 f8 ff ff       	call   8021a5 <set_block_data>
  8028e2:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8028e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e8:	8b 40 04             	mov    0x4(%eax),%eax
  8028eb:	85 c0                	test   %eax,%eax
  8028ed:	75 68                	jne    802957 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028ef:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028f3:	75 17                	jne    80290c <alloc_block_BF+0x27c>
  8028f5:	83 ec 04             	sub    $0x4,%esp
  8028f8:	68 9c 44 80 00       	push   $0x80449c
  8028fd:	68 45 01 00 00       	push   $0x145
  802902:	68 81 44 80 00       	push   $0x804481
  802907:	e8 95 d9 ff ff       	call   8002a1 <_panic>
  80290c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802912:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802915:	89 10                	mov    %edx,(%eax)
  802917:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80291a:	8b 00                	mov    (%eax),%eax
  80291c:	85 c0                	test   %eax,%eax
  80291e:	74 0d                	je     80292d <alloc_block_BF+0x29d>
  802920:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802925:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802928:	89 50 04             	mov    %edx,0x4(%eax)
  80292b:	eb 08                	jmp    802935 <alloc_block_BF+0x2a5>
  80292d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802930:	a3 30 50 80 00       	mov    %eax,0x805030
  802935:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802938:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80293d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802940:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802947:	a1 38 50 80 00       	mov    0x805038,%eax
  80294c:	40                   	inc    %eax
  80294d:	a3 38 50 80 00       	mov    %eax,0x805038
  802952:	e9 dc 00 00 00       	jmp    802a33 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802957:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295a:	8b 00                	mov    (%eax),%eax
  80295c:	85 c0                	test   %eax,%eax
  80295e:	75 65                	jne    8029c5 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802960:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802964:	75 17                	jne    80297d <alloc_block_BF+0x2ed>
  802966:	83 ec 04             	sub    $0x4,%esp
  802969:	68 d0 44 80 00       	push   $0x8044d0
  80296e:	68 4a 01 00 00       	push   $0x14a
  802973:	68 81 44 80 00       	push   $0x804481
  802978:	e8 24 d9 ff ff       	call   8002a1 <_panic>
  80297d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802983:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802986:	89 50 04             	mov    %edx,0x4(%eax)
  802989:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80298c:	8b 40 04             	mov    0x4(%eax),%eax
  80298f:	85 c0                	test   %eax,%eax
  802991:	74 0c                	je     80299f <alloc_block_BF+0x30f>
  802993:	a1 30 50 80 00       	mov    0x805030,%eax
  802998:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80299b:	89 10                	mov    %edx,(%eax)
  80299d:	eb 08                	jmp    8029a7 <alloc_block_BF+0x317>
  80299f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029aa:	a3 30 50 80 00       	mov    %eax,0x805030
  8029af:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029b8:	a1 38 50 80 00       	mov    0x805038,%eax
  8029bd:	40                   	inc    %eax
  8029be:	a3 38 50 80 00       	mov    %eax,0x805038
  8029c3:	eb 6e                	jmp    802a33 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8029c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029c9:	74 06                	je     8029d1 <alloc_block_BF+0x341>
  8029cb:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029cf:	75 17                	jne    8029e8 <alloc_block_BF+0x358>
  8029d1:	83 ec 04             	sub    $0x4,%esp
  8029d4:	68 f4 44 80 00       	push   $0x8044f4
  8029d9:	68 4f 01 00 00       	push   $0x14f
  8029de:	68 81 44 80 00       	push   $0x804481
  8029e3:	e8 b9 d8 ff ff       	call   8002a1 <_panic>
  8029e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029eb:	8b 10                	mov    (%eax),%edx
  8029ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029f0:	89 10                	mov    %edx,(%eax)
  8029f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029f5:	8b 00                	mov    (%eax),%eax
  8029f7:	85 c0                	test   %eax,%eax
  8029f9:	74 0b                	je     802a06 <alloc_block_BF+0x376>
  8029fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fe:	8b 00                	mov    (%eax),%eax
  802a00:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a03:	89 50 04             	mov    %edx,0x4(%eax)
  802a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a09:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a0c:	89 10                	mov    %edx,(%eax)
  802a0e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a11:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a14:	89 50 04             	mov    %edx,0x4(%eax)
  802a17:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a1a:	8b 00                	mov    (%eax),%eax
  802a1c:	85 c0                	test   %eax,%eax
  802a1e:	75 08                	jne    802a28 <alloc_block_BF+0x398>
  802a20:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a23:	a3 30 50 80 00       	mov    %eax,0x805030
  802a28:	a1 38 50 80 00       	mov    0x805038,%eax
  802a2d:	40                   	inc    %eax
  802a2e:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802a33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a37:	75 17                	jne    802a50 <alloc_block_BF+0x3c0>
  802a39:	83 ec 04             	sub    $0x4,%esp
  802a3c:	68 63 44 80 00       	push   $0x804463
  802a41:	68 51 01 00 00       	push   $0x151
  802a46:	68 81 44 80 00       	push   $0x804481
  802a4b:	e8 51 d8 ff ff       	call   8002a1 <_panic>
  802a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a53:	8b 00                	mov    (%eax),%eax
  802a55:	85 c0                	test   %eax,%eax
  802a57:	74 10                	je     802a69 <alloc_block_BF+0x3d9>
  802a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5c:	8b 00                	mov    (%eax),%eax
  802a5e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a61:	8b 52 04             	mov    0x4(%edx),%edx
  802a64:	89 50 04             	mov    %edx,0x4(%eax)
  802a67:	eb 0b                	jmp    802a74 <alloc_block_BF+0x3e4>
  802a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6c:	8b 40 04             	mov    0x4(%eax),%eax
  802a6f:	a3 30 50 80 00       	mov    %eax,0x805030
  802a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a77:	8b 40 04             	mov    0x4(%eax),%eax
  802a7a:	85 c0                	test   %eax,%eax
  802a7c:	74 0f                	je     802a8d <alloc_block_BF+0x3fd>
  802a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a81:	8b 40 04             	mov    0x4(%eax),%eax
  802a84:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a87:	8b 12                	mov    (%edx),%edx
  802a89:	89 10                	mov    %edx,(%eax)
  802a8b:	eb 0a                	jmp    802a97 <alloc_block_BF+0x407>
  802a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a90:	8b 00                	mov    (%eax),%eax
  802a92:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aaa:	a1 38 50 80 00       	mov    0x805038,%eax
  802aaf:	48                   	dec    %eax
  802ab0:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802ab5:	83 ec 04             	sub    $0x4,%esp
  802ab8:	6a 00                	push   $0x0
  802aba:	ff 75 d0             	pushl  -0x30(%ebp)
  802abd:	ff 75 cc             	pushl  -0x34(%ebp)
  802ac0:	e8 e0 f6 ff ff       	call   8021a5 <set_block_data>
  802ac5:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acb:	e9 80 01 00 00       	jmp    802c50 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802ad0:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802ad4:	0f 85 9d 00 00 00    	jne    802b77 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802ada:	83 ec 04             	sub    $0x4,%esp
  802add:	6a 01                	push   $0x1
  802adf:	ff 75 ec             	pushl  -0x14(%ebp)
  802ae2:	ff 75 f0             	pushl  -0x10(%ebp)
  802ae5:	e8 bb f6 ff ff       	call   8021a5 <set_block_data>
  802aea:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802aed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802af1:	75 17                	jne    802b0a <alloc_block_BF+0x47a>
  802af3:	83 ec 04             	sub    $0x4,%esp
  802af6:	68 63 44 80 00       	push   $0x804463
  802afb:	68 58 01 00 00       	push   $0x158
  802b00:	68 81 44 80 00       	push   $0x804481
  802b05:	e8 97 d7 ff ff       	call   8002a1 <_panic>
  802b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0d:	8b 00                	mov    (%eax),%eax
  802b0f:	85 c0                	test   %eax,%eax
  802b11:	74 10                	je     802b23 <alloc_block_BF+0x493>
  802b13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b16:	8b 00                	mov    (%eax),%eax
  802b18:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b1b:	8b 52 04             	mov    0x4(%edx),%edx
  802b1e:	89 50 04             	mov    %edx,0x4(%eax)
  802b21:	eb 0b                	jmp    802b2e <alloc_block_BF+0x49e>
  802b23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b26:	8b 40 04             	mov    0x4(%eax),%eax
  802b29:	a3 30 50 80 00       	mov    %eax,0x805030
  802b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b31:	8b 40 04             	mov    0x4(%eax),%eax
  802b34:	85 c0                	test   %eax,%eax
  802b36:	74 0f                	je     802b47 <alloc_block_BF+0x4b7>
  802b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3b:	8b 40 04             	mov    0x4(%eax),%eax
  802b3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b41:	8b 12                	mov    (%edx),%edx
  802b43:	89 10                	mov    %edx,(%eax)
  802b45:	eb 0a                	jmp    802b51 <alloc_block_BF+0x4c1>
  802b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4a:	8b 00                	mov    (%eax),%eax
  802b4c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b64:	a1 38 50 80 00       	mov    0x805038,%eax
  802b69:	48                   	dec    %eax
  802b6a:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b72:	e9 d9 00 00 00       	jmp    802c50 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802b77:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7a:	83 c0 08             	add    $0x8,%eax
  802b7d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b80:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b87:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b8a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b8d:	01 d0                	add    %edx,%eax
  802b8f:	48                   	dec    %eax
  802b90:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b93:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b96:	ba 00 00 00 00       	mov    $0x0,%edx
  802b9b:	f7 75 c4             	divl   -0x3c(%ebp)
  802b9e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ba1:	29 d0                	sub    %edx,%eax
  802ba3:	c1 e8 0c             	shr    $0xc,%eax
  802ba6:	83 ec 0c             	sub    $0xc,%esp
  802ba9:	50                   	push   %eax
  802baa:	e8 49 e7 ff ff       	call   8012f8 <sbrk>
  802baf:	83 c4 10             	add    $0x10,%esp
  802bb2:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802bb5:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802bb9:	75 0a                	jne    802bc5 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802bbb:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc0:	e9 8b 00 00 00       	jmp    802c50 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802bc5:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802bcc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bcf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802bd2:	01 d0                	add    %edx,%eax
  802bd4:	48                   	dec    %eax
  802bd5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802bd8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bdb:	ba 00 00 00 00       	mov    $0x0,%edx
  802be0:	f7 75 b8             	divl   -0x48(%ebp)
  802be3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802be6:	29 d0                	sub    %edx,%eax
  802be8:	8d 50 fc             	lea    -0x4(%eax),%edx
  802beb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802bee:	01 d0                	add    %edx,%eax
  802bf0:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802bf5:	a1 40 50 80 00       	mov    0x805040,%eax
  802bfa:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c00:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802c07:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c0a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c0d:	01 d0                	add    %edx,%eax
  802c0f:	48                   	dec    %eax
  802c10:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802c13:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c16:	ba 00 00 00 00       	mov    $0x0,%edx
  802c1b:	f7 75 b0             	divl   -0x50(%ebp)
  802c1e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c21:	29 d0                	sub    %edx,%eax
  802c23:	83 ec 04             	sub    $0x4,%esp
  802c26:	6a 01                	push   $0x1
  802c28:	50                   	push   %eax
  802c29:	ff 75 bc             	pushl  -0x44(%ebp)
  802c2c:	e8 74 f5 ff ff       	call   8021a5 <set_block_data>
  802c31:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802c34:	83 ec 0c             	sub    $0xc,%esp
  802c37:	ff 75 bc             	pushl  -0x44(%ebp)
  802c3a:	e8 36 04 00 00       	call   803075 <free_block>
  802c3f:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802c42:	83 ec 0c             	sub    $0xc,%esp
  802c45:	ff 75 08             	pushl  0x8(%ebp)
  802c48:	e8 43 fa ff ff       	call   802690 <alloc_block_BF>
  802c4d:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802c50:	c9                   	leave  
  802c51:	c3                   	ret    

00802c52 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802c52:	55                   	push   %ebp
  802c53:	89 e5                	mov    %esp,%ebp
  802c55:	53                   	push   %ebx
  802c56:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802c59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c60:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802c67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c6b:	74 1e                	je     802c8b <merging+0x39>
  802c6d:	ff 75 08             	pushl  0x8(%ebp)
  802c70:	e8 df f1 ff ff       	call   801e54 <get_block_size>
  802c75:	83 c4 04             	add    $0x4,%esp
  802c78:	89 c2                	mov    %eax,%edx
  802c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7d:	01 d0                	add    %edx,%eax
  802c7f:	3b 45 10             	cmp    0x10(%ebp),%eax
  802c82:	75 07                	jne    802c8b <merging+0x39>
		prev_is_free = 1;
  802c84:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802c8b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c8f:	74 1e                	je     802caf <merging+0x5d>
  802c91:	ff 75 10             	pushl  0x10(%ebp)
  802c94:	e8 bb f1 ff ff       	call   801e54 <get_block_size>
  802c99:	83 c4 04             	add    $0x4,%esp
  802c9c:	89 c2                	mov    %eax,%edx
  802c9e:	8b 45 10             	mov    0x10(%ebp),%eax
  802ca1:	01 d0                	add    %edx,%eax
  802ca3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ca6:	75 07                	jne    802caf <merging+0x5d>
		next_is_free = 1;
  802ca8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802caf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb3:	0f 84 cc 00 00 00    	je     802d85 <merging+0x133>
  802cb9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cbd:	0f 84 c2 00 00 00    	je     802d85 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802cc3:	ff 75 08             	pushl  0x8(%ebp)
  802cc6:	e8 89 f1 ff ff       	call   801e54 <get_block_size>
  802ccb:	83 c4 04             	add    $0x4,%esp
  802cce:	89 c3                	mov    %eax,%ebx
  802cd0:	ff 75 10             	pushl  0x10(%ebp)
  802cd3:	e8 7c f1 ff ff       	call   801e54 <get_block_size>
  802cd8:	83 c4 04             	add    $0x4,%esp
  802cdb:	01 c3                	add    %eax,%ebx
  802cdd:	ff 75 0c             	pushl  0xc(%ebp)
  802ce0:	e8 6f f1 ff ff       	call   801e54 <get_block_size>
  802ce5:	83 c4 04             	add    $0x4,%esp
  802ce8:	01 d8                	add    %ebx,%eax
  802cea:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ced:	6a 00                	push   $0x0
  802cef:	ff 75 ec             	pushl  -0x14(%ebp)
  802cf2:	ff 75 08             	pushl  0x8(%ebp)
  802cf5:	e8 ab f4 ff ff       	call   8021a5 <set_block_data>
  802cfa:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802cfd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d01:	75 17                	jne    802d1a <merging+0xc8>
  802d03:	83 ec 04             	sub    $0x4,%esp
  802d06:	68 63 44 80 00       	push   $0x804463
  802d0b:	68 7d 01 00 00       	push   $0x17d
  802d10:	68 81 44 80 00       	push   $0x804481
  802d15:	e8 87 d5 ff ff       	call   8002a1 <_panic>
  802d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d1d:	8b 00                	mov    (%eax),%eax
  802d1f:	85 c0                	test   %eax,%eax
  802d21:	74 10                	je     802d33 <merging+0xe1>
  802d23:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d26:	8b 00                	mov    (%eax),%eax
  802d28:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d2b:	8b 52 04             	mov    0x4(%edx),%edx
  802d2e:	89 50 04             	mov    %edx,0x4(%eax)
  802d31:	eb 0b                	jmp    802d3e <merging+0xec>
  802d33:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d36:	8b 40 04             	mov    0x4(%eax),%eax
  802d39:	a3 30 50 80 00       	mov    %eax,0x805030
  802d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d41:	8b 40 04             	mov    0x4(%eax),%eax
  802d44:	85 c0                	test   %eax,%eax
  802d46:	74 0f                	je     802d57 <merging+0x105>
  802d48:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d4b:	8b 40 04             	mov    0x4(%eax),%eax
  802d4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d51:	8b 12                	mov    (%edx),%edx
  802d53:	89 10                	mov    %edx,(%eax)
  802d55:	eb 0a                	jmp    802d61 <merging+0x10f>
  802d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d5a:	8b 00                	mov    (%eax),%eax
  802d5c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d61:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d74:	a1 38 50 80 00       	mov    0x805038,%eax
  802d79:	48                   	dec    %eax
  802d7a:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802d7f:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d80:	e9 ea 02 00 00       	jmp    80306f <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802d85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d89:	74 3b                	je     802dc6 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802d8b:	83 ec 0c             	sub    $0xc,%esp
  802d8e:	ff 75 08             	pushl  0x8(%ebp)
  802d91:	e8 be f0 ff ff       	call   801e54 <get_block_size>
  802d96:	83 c4 10             	add    $0x10,%esp
  802d99:	89 c3                	mov    %eax,%ebx
  802d9b:	83 ec 0c             	sub    $0xc,%esp
  802d9e:	ff 75 10             	pushl  0x10(%ebp)
  802da1:	e8 ae f0 ff ff       	call   801e54 <get_block_size>
  802da6:	83 c4 10             	add    $0x10,%esp
  802da9:	01 d8                	add    %ebx,%eax
  802dab:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802dae:	83 ec 04             	sub    $0x4,%esp
  802db1:	6a 00                	push   $0x0
  802db3:	ff 75 e8             	pushl  -0x18(%ebp)
  802db6:	ff 75 08             	pushl  0x8(%ebp)
  802db9:	e8 e7 f3 ff ff       	call   8021a5 <set_block_data>
  802dbe:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802dc1:	e9 a9 02 00 00       	jmp    80306f <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802dc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dca:	0f 84 2d 01 00 00    	je     802efd <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802dd0:	83 ec 0c             	sub    $0xc,%esp
  802dd3:	ff 75 10             	pushl  0x10(%ebp)
  802dd6:	e8 79 f0 ff ff       	call   801e54 <get_block_size>
  802ddb:	83 c4 10             	add    $0x10,%esp
  802dde:	89 c3                	mov    %eax,%ebx
  802de0:	83 ec 0c             	sub    $0xc,%esp
  802de3:	ff 75 0c             	pushl  0xc(%ebp)
  802de6:	e8 69 f0 ff ff       	call   801e54 <get_block_size>
  802deb:	83 c4 10             	add    $0x10,%esp
  802dee:	01 d8                	add    %ebx,%eax
  802df0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802df3:	83 ec 04             	sub    $0x4,%esp
  802df6:	6a 00                	push   $0x0
  802df8:	ff 75 e4             	pushl  -0x1c(%ebp)
  802dfb:	ff 75 10             	pushl  0x10(%ebp)
  802dfe:	e8 a2 f3 ff ff       	call   8021a5 <set_block_data>
  802e03:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802e06:	8b 45 10             	mov    0x10(%ebp),%eax
  802e09:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802e0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e10:	74 06                	je     802e18 <merging+0x1c6>
  802e12:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e16:	75 17                	jne    802e2f <merging+0x1dd>
  802e18:	83 ec 04             	sub    $0x4,%esp
  802e1b:	68 28 45 80 00       	push   $0x804528
  802e20:	68 8d 01 00 00       	push   $0x18d
  802e25:	68 81 44 80 00       	push   $0x804481
  802e2a:	e8 72 d4 ff ff       	call   8002a1 <_panic>
  802e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e32:	8b 50 04             	mov    0x4(%eax),%edx
  802e35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e38:	89 50 04             	mov    %edx,0x4(%eax)
  802e3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e41:	89 10                	mov    %edx,(%eax)
  802e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e46:	8b 40 04             	mov    0x4(%eax),%eax
  802e49:	85 c0                	test   %eax,%eax
  802e4b:	74 0d                	je     802e5a <merging+0x208>
  802e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e50:	8b 40 04             	mov    0x4(%eax),%eax
  802e53:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e56:	89 10                	mov    %edx,(%eax)
  802e58:	eb 08                	jmp    802e62 <merging+0x210>
  802e5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e5d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e62:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e65:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e68:	89 50 04             	mov    %edx,0x4(%eax)
  802e6b:	a1 38 50 80 00       	mov    0x805038,%eax
  802e70:	40                   	inc    %eax
  802e71:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802e76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e7a:	75 17                	jne    802e93 <merging+0x241>
  802e7c:	83 ec 04             	sub    $0x4,%esp
  802e7f:	68 63 44 80 00       	push   $0x804463
  802e84:	68 8e 01 00 00       	push   $0x18e
  802e89:	68 81 44 80 00       	push   $0x804481
  802e8e:	e8 0e d4 ff ff       	call   8002a1 <_panic>
  802e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e96:	8b 00                	mov    (%eax),%eax
  802e98:	85 c0                	test   %eax,%eax
  802e9a:	74 10                	je     802eac <merging+0x25a>
  802e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9f:	8b 00                	mov    (%eax),%eax
  802ea1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ea4:	8b 52 04             	mov    0x4(%edx),%edx
  802ea7:	89 50 04             	mov    %edx,0x4(%eax)
  802eaa:	eb 0b                	jmp    802eb7 <merging+0x265>
  802eac:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eaf:	8b 40 04             	mov    0x4(%eax),%eax
  802eb2:	a3 30 50 80 00       	mov    %eax,0x805030
  802eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eba:	8b 40 04             	mov    0x4(%eax),%eax
  802ebd:	85 c0                	test   %eax,%eax
  802ebf:	74 0f                	je     802ed0 <merging+0x27e>
  802ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec4:	8b 40 04             	mov    0x4(%eax),%eax
  802ec7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eca:	8b 12                	mov    (%edx),%edx
  802ecc:	89 10                	mov    %edx,(%eax)
  802ece:	eb 0a                	jmp    802eda <merging+0x288>
  802ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ed3:	8b 00                	mov    (%eax),%eax
  802ed5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802eda:	8b 45 0c             	mov    0xc(%ebp),%eax
  802edd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eed:	a1 38 50 80 00       	mov    0x805038,%eax
  802ef2:	48                   	dec    %eax
  802ef3:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ef8:	e9 72 01 00 00       	jmp    80306f <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802efd:	8b 45 10             	mov    0x10(%ebp),%eax
  802f00:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802f03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f07:	74 79                	je     802f82 <merging+0x330>
  802f09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f0d:	74 73                	je     802f82 <merging+0x330>
  802f0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f13:	74 06                	je     802f1b <merging+0x2c9>
  802f15:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f19:	75 17                	jne    802f32 <merging+0x2e0>
  802f1b:	83 ec 04             	sub    $0x4,%esp
  802f1e:	68 f4 44 80 00       	push   $0x8044f4
  802f23:	68 94 01 00 00       	push   $0x194
  802f28:	68 81 44 80 00       	push   $0x804481
  802f2d:	e8 6f d3 ff ff       	call   8002a1 <_panic>
  802f32:	8b 45 08             	mov    0x8(%ebp),%eax
  802f35:	8b 10                	mov    (%eax),%edx
  802f37:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f3a:	89 10                	mov    %edx,(%eax)
  802f3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f3f:	8b 00                	mov    (%eax),%eax
  802f41:	85 c0                	test   %eax,%eax
  802f43:	74 0b                	je     802f50 <merging+0x2fe>
  802f45:	8b 45 08             	mov    0x8(%ebp),%eax
  802f48:	8b 00                	mov    (%eax),%eax
  802f4a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f4d:	89 50 04             	mov    %edx,0x4(%eax)
  802f50:	8b 45 08             	mov    0x8(%ebp),%eax
  802f53:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f56:	89 10                	mov    %edx,(%eax)
  802f58:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f5b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f5e:	89 50 04             	mov    %edx,0x4(%eax)
  802f61:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f64:	8b 00                	mov    (%eax),%eax
  802f66:	85 c0                	test   %eax,%eax
  802f68:	75 08                	jne    802f72 <merging+0x320>
  802f6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f6d:	a3 30 50 80 00       	mov    %eax,0x805030
  802f72:	a1 38 50 80 00       	mov    0x805038,%eax
  802f77:	40                   	inc    %eax
  802f78:	a3 38 50 80 00       	mov    %eax,0x805038
  802f7d:	e9 ce 00 00 00       	jmp    803050 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802f82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f86:	74 65                	je     802fed <merging+0x39b>
  802f88:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f8c:	75 17                	jne    802fa5 <merging+0x353>
  802f8e:	83 ec 04             	sub    $0x4,%esp
  802f91:	68 d0 44 80 00       	push   $0x8044d0
  802f96:	68 95 01 00 00       	push   $0x195
  802f9b:	68 81 44 80 00       	push   $0x804481
  802fa0:	e8 fc d2 ff ff       	call   8002a1 <_panic>
  802fa5:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802fab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fae:	89 50 04             	mov    %edx,0x4(%eax)
  802fb1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fb4:	8b 40 04             	mov    0x4(%eax),%eax
  802fb7:	85 c0                	test   %eax,%eax
  802fb9:	74 0c                	je     802fc7 <merging+0x375>
  802fbb:	a1 30 50 80 00       	mov    0x805030,%eax
  802fc0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fc3:	89 10                	mov    %edx,(%eax)
  802fc5:	eb 08                	jmp    802fcf <merging+0x37d>
  802fc7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fca:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fcf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fd2:	a3 30 50 80 00       	mov    %eax,0x805030
  802fd7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fda:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fe0:	a1 38 50 80 00       	mov    0x805038,%eax
  802fe5:	40                   	inc    %eax
  802fe6:	a3 38 50 80 00       	mov    %eax,0x805038
  802feb:	eb 63                	jmp    803050 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802fed:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ff1:	75 17                	jne    80300a <merging+0x3b8>
  802ff3:	83 ec 04             	sub    $0x4,%esp
  802ff6:	68 9c 44 80 00       	push   $0x80449c
  802ffb:	68 98 01 00 00       	push   $0x198
  803000:	68 81 44 80 00       	push   $0x804481
  803005:	e8 97 d2 ff ff       	call   8002a1 <_panic>
  80300a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803010:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803013:	89 10                	mov    %edx,(%eax)
  803015:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803018:	8b 00                	mov    (%eax),%eax
  80301a:	85 c0                	test   %eax,%eax
  80301c:	74 0d                	je     80302b <merging+0x3d9>
  80301e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803023:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803026:	89 50 04             	mov    %edx,0x4(%eax)
  803029:	eb 08                	jmp    803033 <merging+0x3e1>
  80302b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80302e:	a3 30 50 80 00       	mov    %eax,0x805030
  803033:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803036:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80303b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80303e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803045:	a1 38 50 80 00       	mov    0x805038,%eax
  80304a:	40                   	inc    %eax
  80304b:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803050:	83 ec 0c             	sub    $0xc,%esp
  803053:	ff 75 10             	pushl  0x10(%ebp)
  803056:	e8 f9 ed ff ff       	call   801e54 <get_block_size>
  80305b:	83 c4 10             	add    $0x10,%esp
  80305e:	83 ec 04             	sub    $0x4,%esp
  803061:	6a 00                	push   $0x0
  803063:	50                   	push   %eax
  803064:	ff 75 10             	pushl  0x10(%ebp)
  803067:	e8 39 f1 ff ff       	call   8021a5 <set_block_data>
  80306c:	83 c4 10             	add    $0x10,%esp
	}
}
  80306f:	90                   	nop
  803070:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803073:	c9                   	leave  
  803074:	c3                   	ret    

00803075 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803075:	55                   	push   %ebp
  803076:	89 e5                	mov    %esp,%ebp
  803078:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80307b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803080:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803083:	a1 30 50 80 00       	mov    0x805030,%eax
  803088:	3b 45 08             	cmp    0x8(%ebp),%eax
  80308b:	73 1b                	jae    8030a8 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80308d:	a1 30 50 80 00       	mov    0x805030,%eax
  803092:	83 ec 04             	sub    $0x4,%esp
  803095:	ff 75 08             	pushl  0x8(%ebp)
  803098:	6a 00                	push   $0x0
  80309a:	50                   	push   %eax
  80309b:	e8 b2 fb ff ff       	call   802c52 <merging>
  8030a0:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030a3:	e9 8b 00 00 00       	jmp    803133 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8030a8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030ad:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030b0:	76 18                	jbe    8030ca <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8030b2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030b7:	83 ec 04             	sub    $0x4,%esp
  8030ba:	ff 75 08             	pushl  0x8(%ebp)
  8030bd:	50                   	push   %eax
  8030be:	6a 00                	push   $0x0
  8030c0:	e8 8d fb ff ff       	call   802c52 <merging>
  8030c5:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030c8:	eb 69                	jmp    803133 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030ca:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030d2:	eb 39                	jmp    80310d <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8030d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030da:	73 29                	jae    803105 <free_block+0x90>
  8030dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030df:	8b 00                	mov    (%eax),%eax
  8030e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030e4:	76 1f                	jbe    803105 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8030e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e9:	8b 00                	mov    (%eax),%eax
  8030eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8030ee:	83 ec 04             	sub    $0x4,%esp
  8030f1:	ff 75 08             	pushl  0x8(%ebp)
  8030f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8030f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8030fa:	e8 53 fb ff ff       	call   802c52 <merging>
  8030ff:	83 c4 10             	add    $0x10,%esp
			break;
  803102:	90                   	nop
		}
	}
}
  803103:	eb 2e                	jmp    803133 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803105:	a1 34 50 80 00       	mov    0x805034,%eax
  80310a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80310d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803111:	74 07                	je     80311a <free_block+0xa5>
  803113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803116:	8b 00                	mov    (%eax),%eax
  803118:	eb 05                	jmp    80311f <free_block+0xaa>
  80311a:	b8 00 00 00 00       	mov    $0x0,%eax
  80311f:	a3 34 50 80 00       	mov    %eax,0x805034
  803124:	a1 34 50 80 00       	mov    0x805034,%eax
  803129:	85 c0                	test   %eax,%eax
  80312b:	75 a7                	jne    8030d4 <free_block+0x5f>
  80312d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803131:	75 a1                	jne    8030d4 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803133:	90                   	nop
  803134:	c9                   	leave  
  803135:	c3                   	ret    

00803136 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803136:	55                   	push   %ebp
  803137:	89 e5                	mov    %esp,%ebp
  803139:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80313c:	ff 75 08             	pushl  0x8(%ebp)
  80313f:	e8 10 ed ff ff       	call   801e54 <get_block_size>
  803144:	83 c4 04             	add    $0x4,%esp
  803147:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80314a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803151:	eb 17                	jmp    80316a <copy_data+0x34>
  803153:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803156:	8b 45 0c             	mov    0xc(%ebp),%eax
  803159:	01 c2                	add    %eax,%edx
  80315b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80315e:	8b 45 08             	mov    0x8(%ebp),%eax
  803161:	01 c8                	add    %ecx,%eax
  803163:	8a 00                	mov    (%eax),%al
  803165:	88 02                	mov    %al,(%edx)
  803167:	ff 45 fc             	incl   -0x4(%ebp)
  80316a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80316d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803170:	72 e1                	jb     803153 <copy_data+0x1d>
}
  803172:	90                   	nop
  803173:	c9                   	leave  
  803174:	c3                   	ret    

00803175 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803175:	55                   	push   %ebp
  803176:	89 e5                	mov    %esp,%ebp
  803178:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80317b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80317f:	75 23                	jne    8031a4 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803181:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803185:	74 13                	je     80319a <realloc_block_FF+0x25>
  803187:	83 ec 0c             	sub    $0xc,%esp
  80318a:	ff 75 0c             	pushl  0xc(%ebp)
  80318d:	e8 42 f0 ff ff       	call   8021d4 <alloc_block_FF>
  803192:	83 c4 10             	add    $0x10,%esp
  803195:	e9 e4 06 00 00       	jmp    80387e <realloc_block_FF+0x709>
		return NULL;
  80319a:	b8 00 00 00 00       	mov    $0x0,%eax
  80319f:	e9 da 06 00 00       	jmp    80387e <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  8031a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031a8:	75 18                	jne    8031c2 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8031aa:	83 ec 0c             	sub    $0xc,%esp
  8031ad:	ff 75 08             	pushl  0x8(%ebp)
  8031b0:	e8 c0 fe ff ff       	call   803075 <free_block>
  8031b5:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8031b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8031bd:	e9 bc 06 00 00       	jmp    80387e <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  8031c2:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8031c6:	77 07                	ja     8031cf <realloc_block_FF+0x5a>
  8031c8:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8031cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031d2:	83 e0 01             	and    $0x1,%eax
  8031d5:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8031d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031db:	83 c0 08             	add    $0x8,%eax
  8031de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8031e1:	83 ec 0c             	sub    $0xc,%esp
  8031e4:	ff 75 08             	pushl  0x8(%ebp)
  8031e7:	e8 68 ec ff ff       	call   801e54 <get_block_size>
  8031ec:	83 c4 10             	add    $0x10,%esp
  8031ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f5:	83 e8 08             	sub    $0x8,%eax
  8031f8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8031fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fe:	83 e8 04             	sub    $0x4,%eax
  803201:	8b 00                	mov    (%eax),%eax
  803203:	83 e0 fe             	and    $0xfffffffe,%eax
  803206:	89 c2                	mov    %eax,%edx
  803208:	8b 45 08             	mov    0x8(%ebp),%eax
  80320b:	01 d0                	add    %edx,%eax
  80320d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803210:	83 ec 0c             	sub    $0xc,%esp
  803213:	ff 75 e4             	pushl  -0x1c(%ebp)
  803216:	e8 39 ec ff ff       	call   801e54 <get_block_size>
  80321b:	83 c4 10             	add    $0x10,%esp
  80321e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803221:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803224:	83 e8 08             	sub    $0x8,%eax
  803227:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80322a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80322d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803230:	75 08                	jne    80323a <realloc_block_FF+0xc5>
	{
		 return va;
  803232:	8b 45 08             	mov    0x8(%ebp),%eax
  803235:	e9 44 06 00 00       	jmp    80387e <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  80323a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80323d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803240:	0f 83 d5 03 00 00    	jae    80361b <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803246:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803249:	2b 45 0c             	sub    0xc(%ebp),%eax
  80324c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80324f:	83 ec 0c             	sub    $0xc,%esp
  803252:	ff 75 e4             	pushl  -0x1c(%ebp)
  803255:	e8 13 ec ff ff       	call   801e6d <is_free_block>
  80325a:	83 c4 10             	add    $0x10,%esp
  80325d:	84 c0                	test   %al,%al
  80325f:	0f 84 3b 01 00 00    	je     8033a0 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803265:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803268:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80326b:	01 d0                	add    %edx,%eax
  80326d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803270:	83 ec 04             	sub    $0x4,%esp
  803273:	6a 01                	push   $0x1
  803275:	ff 75 f0             	pushl  -0x10(%ebp)
  803278:	ff 75 08             	pushl  0x8(%ebp)
  80327b:	e8 25 ef ff ff       	call   8021a5 <set_block_data>
  803280:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803283:	8b 45 08             	mov    0x8(%ebp),%eax
  803286:	83 e8 04             	sub    $0x4,%eax
  803289:	8b 00                	mov    (%eax),%eax
  80328b:	83 e0 fe             	and    $0xfffffffe,%eax
  80328e:	89 c2                	mov    %eax,%edx
  803290:	8b 45 08             	mov    0x8(%ebp),%eax
  803293:	01 d0                	add    %edx,%eax
  803295:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803298:	83 ec 04             	sub    $0x4,%esp
  80329b:	6a 00                	push   $0x0
  80329d:	ff 75 cc             	pushl  -0x34(%ebp)
  8032a0:	ff 75 c8             	pushl  -0x38(%ebp)
  8032a3:	e8 fd ee ff ff       	call   8021a5 <set_block_data>
  8032a8:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8032ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032af:	74 06                	je     8032b7 <realloc_block_FF+0x142>
  8032b1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8032b5:	75 17                	jne    8032ce <realloc_block_FF+0x159>
  8032b7:	83 ec 04             	sub    $0x4,%esp
  8032ba:	68 f4 44 80 00       	push   $0x8044f4
  8032bf:	68 f6 01 00 00       	push   $0x1f6
  8032c4:	68 81 44 80 00       	push   $0x804481
  8032c9:	e8 d3 cf ff ff       	call   8002a1 <_panic>
  8032ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d1:	8b 10                	mov    (%eax),%edx
  8032d3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032d6:	89 10                	mov    %edx,(%eax)
  8032d8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032db:	8b 00                	mov    (%eax),%eax
  8032dd:	85 c0                	test   %eax,%eax
  8032df:	74 0b                	je     8032ec <realloc_block_FF+0x177>
  8032e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e4:	8b 00                	mov    (%eax),%eax
  8032e6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032e9:	89 50 04             	mov    %edx,0x4(%eax)
  8032ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ef:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032f2:	89 10                	mov    %edx,(%eax)
  8032f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032fa:	89 50 04             	mov    %edx,0x4(%eax)
  8032fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803300:	8b 00                	mov    (%eax),%eax
  803302:	85 c0                	test   %eax,%eax
  803304:	75 08                	jne    80330e <realloc_block_FF+0x199>
  803306:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803309:	a3 30 50 80 00       	mov    %eax,0x805030
  80330e:	a1 38 50 80 00       	mov    0x805038,%eax
  803313:	40                   	inc    %eax
  803314:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803319:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80331d:	75 17                	jne    803336 <realloc_block_FF+0x1c1>
  80331f:	83 ec 04             	sub    $0x4,%esp
  803322:	68 63 44 80 00       	push   $0x804463
  803327:	68 f7 01 00 00       	push   $0x1f7
  80332c:	68 81 44 80 00       	push   $0x804481
  803331:	e8 6b cf ff ff       	call   8002a1 <_panic>
  803336:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803339:	8b 00                	mov    (%eax),%eax
  80333b:	85 c0                	test   %eax,%eax
  80333d:	74 10                	je     80334f <realloc_block_FF+0x1da>
  80333f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803342:	8b 00                	mov    (%eax),%eax
  803344:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803347:	8b 52 04             	mov    0x4(%edx),%edx
  80334a:	89 50 04             	mov    %edx,0x4(%eax)
  80334d:	eb 0b                	jmp    80335a <realloc_block_FF+0x1e5>
  80334f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803352:	8b 40 04             	mov    0x4(%eax),%eax
  803355:	a3 30 50 80 00       	mov    %eax,0x805030
  80335a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80335d:	8b 40 04             	mov    0x4(%eax),%eax
  803360:	85 c0                	test   %eax,%eax
  803362:	74 0f                	je     803373 <realloc_block_FF+0x1fe>
  803364:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803367:	8b 40 04             	mov    0x4(%eax),%eax
  80336a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80336d:	8b 12                	mov    (%edx),%edx
  80336f:	89 10                	mov    %edx,(%eax)
  803371:	eb 0a                	jmp    80337d <realloc_block_FF+0x208>
  803373:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803376:	8b 00                	mov    (%eax),%eax
  803378:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80337d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803380:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803386:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803389:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803390:	a1 38 50 80 00       	mov    0x805038,%eax
  803395:	48                   	dec    %eax
  803396:	a3 38 50 80 00       	mov    %eax,0x805038
  80339b:	e9 73 02 00 00       	jmp    803613 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  8033a0:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8033a4:	0f 86 69 02 00 00    	jbe    803613 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8033aa:	83 ec 04             	sub    $0x4,%esp
  8033ad:	6a 01                	push   $0x1
  8033af:	ff 75 f0             	pushl  -0x10(%ebp)
  8033b2:	ff 75 08             	pushl  0x8(%ebp)
  8033b5:	e8 eb ed ff ff       	call   8021a5 <set_block_data>
  8033ba:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8033bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c0:	83 e8 04             	sub    $0x4,%eax
  8033c3:	8b 00                	mov    (%eax),%eax
  8033c5:	83 e0 fe             	and    $0xfffffffe,%eax
  8033c8:	89 c2                	mov    %eax,%edx
  8033ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cd:	01 d0                	add    %edx,%eax
  8033cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8033d2:	a1 38 50 80 00       	mov    0x805038,%eax
  8033d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8033da:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8033de:	75 68                	jne    803448 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8033e0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033e4:	75 17                	jne    8033fd <realloc_block_FF+0x288>
  8033e6:	83 ec 04             	sub    $0x4,%esp
  8033e9:	68 9c 44 80 00       	push   $0x80449c
  8033ee:	68 06 02 00 00       	push   $0x206
  8033f3:	68 81 44 80 00       	push   $0x804481
  8033f8:	e8 a4 ce ff ff       	call   8002a1 <_panic>
  8033fd:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803403:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803406:	89 10                	mov    %edx,(%eax)
  803408:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80340b:	8b 00                	mov    (%eax),%eax
  80340d:	85 c0                	test   %eax,%eax
  80340f:	74 0d                	je     80341e <realloc_block_FF+0x2a9>
  803411:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803416:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803419:	89 50 04             	mov    %edx,0x4(%eax)
  80341c:	eb 08                	jmp    803426 <realloc_block_FF+0x2b1>
  80341e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803421:	a3 30 50 80 00       	mov    %eax,0x805030
  803426:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803429:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80342e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803431:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803438:	a1 38 50 80 00       	mov    0x805038,%eax
  80343d:	40                   	inc    %eax
  80343e:	a3 38 50 80 00       	mov    %eax,0x805038
  803443:	e9 b0 01 00 00       	jmp    8035f8 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803448:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80344d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803450:	76 68                	jbe    8034ba <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803452:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803456:	75 17                	jne    80346f <realloc_block_FF+0x2fa>
  803458:	83 ec 04             	sub    $0x4,%esp
  80345b:	68 9c 44 80 00       	push   $0x80449c
  803460:	68 0b 02 00 00       	push   $0x20b
  803465:	68 81 44 80 00       	push   $0x804481
  80346a:	e8 32 ce ff ff       	call   8002a1 <_panic>
  80346f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803475:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803478:	89 10                	mov    %edx,(%eax)
  80347a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80347d:	8b 00                	mov    (%eax),%eax
  80347f:	85 c0                	test   %eax,%eax
  803481:	74 0d                	je     803490 <realloc_block_FF+0x31b>
  803483:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803488:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80348b:	89 50 04             	mov    %edx,0x4(%eax)
  80348e:	eb 08                	jmp    803498 <realloc_block_FF+0x323>
  803490:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803493:	a3 30 50 80 00       	mov    %eax,0x805030
  803498:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80349b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034aa:	a1 38 50 80 00       	mov    0x805038,%eax
  8034af:	40                   	inc    %eax
  8034b0:	a3 38 50 80 00       	mov    %eax,0x805038
  8034b5:	e9 3e 01 00 00       	jmp    8035f8 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8034ba:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034bf:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034c2:	73 68                	jae    80352c <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034c4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034c8:	75 17                	jne    8034e1 <realloc_block_FF+0x36c>
  8034ca:	83 ec 04             	sub    $0x4,%esp
  8034cd:	68 d0 44 80 00       	push   $0x8044d0
  8034d2:	68 10 02 00 00       	push   $0x210
  8034d7:	68 81 44 80 00       	push   $0x804481
  8034dc:	e8 c0 cd ff ff       	call   8002a1 <_panic>
  8034e1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8034e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ea:	89 50 04             	mov    %edx,0x4(%eax)
  8034ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034f0:	8b 40 04             	mov    0x4(%eax),%eax
  8034f3:	85 c0                	test   %eax,%eax
  8034f5:	74 0c                	je     803503 <realloc_block_FF+0x38e>
  8034f7:	a1 30 50 80 00       	mov    0x805030,%eax
  8034fc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034ff:	89 10                	mov    %edx,(%eax)
  803501:	eb 08                	jmp    80350b <realloc_block_FF+0x396>
  803503:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803506:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80350b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80350e:	a3 30 50 80 00       	mov    %eax,0x805030
  803513:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803516:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80351c:	a1 38 50 80 00       	mov    0x805038,%eax
  803521:	40                   	inc    %eax
  803522:	a3 38 50 80 00       	mov    %eax,0x805038
  803527:	e9 cc 00 00 00       	jmp    8035f8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80352c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803533:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803538:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80353b:	e9 8a 00 00 00       	jmp    8035ca <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803543:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803546:	73 7a                	jae    8035c2 <realloc_block_FF+0x44d>
  803548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354b:	8b 00                	mov    (%eax),%eax
  80354d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803550:	73 70                	jae    8035c2 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803552:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803556:	74 06                	je     80355e <realloc_block_FF+0x3e9>
  803558:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80355c:	75 17                	jne    803575 <realloc_block_FF+0x400>
  80355e:	83 ec 04             	sub    $0x4,%esp
  803561:	68 f4 44 80 00       	push   $0x8044f4
  803566:	68 1a 02 00 00       	push   $0x21a
  80356b:	68 81 44 80 00       	push   $0x804481
  803570:	e8 2c cd ff ff       	call   8002a1 <_panic>
  803575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803578:	8b 10                	mov    (%eax),%edx
  80357a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80357d:	89 10                	mov    %edx,(%eax)
  80357f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803582:	8b 00                	mov    (%eax),%eax
  803584:	85 c0                	test   %eax,%eax
  803586:	74 0b                	je     803593 <realloc_block_FF+0x41e>
  803588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358b:	8b 00                	mov    (%eax),%eax
  80358d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803590:	89 50 04             	mov    %edx,0x4(%eax)
  803593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803596:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803599:	89 10                	mov    %edx,(%eax)
  80359b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80359e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035a1:	89 50 04             	mov    %edx,0x4(%eax)
  8035a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a7:	8b 00                	mov    (%eax),%eax
  8035a9:	85 c0                	test   %eax,%eax
  8035ab:	75 08                	jne    8035b5 <realloc_block_FF+0x440>
  8035ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b0:	a3 30 50 80 00       	mov    %eax,0x805030
  8035b5:	a1 38 50 80 00       	mov    0x805038,%eax
  8035ba:	40                   	inc    %eax
  8035bb:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8035c0:	eb 36                	jmp    8035f8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8035c2:	a1 34 50 80 00       	mov    0x805034,%eax
  8035c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035ce:	74 07                	je     8035d7 <realloc_block_FF+0x462>
  8035d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d3:	8b 00                	mov    (%eax),%eax
  8035d5:	eb 05                	jmp    8035dc <realloc_block_FF+0x467>
  8035d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8035dc:	a3 34 50 80 00       	mov    %eax,0x805034
  8035e1:	a1 34 50 80 00       	mov    0x805034,%eax
  8035e6:	85 c0                	test   %eax,%eax
  8035e8:	0f 85 52 ff ff ff    	jne    803540 <realloc_block_FF+0x3cb>
  8035ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035f2:	0f 85 48 ff ff ff    	jne    803540 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8035f8:	83 ec 04             	sub    $0x4,%esp
  8035fb:	6a 00                	push   $0x0
  8035fd:	ff 75 d8             	pushl  -0x28(%ebp)
  803600:	ff 75 d4             	pushl  -0x2c(%ebp)
  803603:	e8 9d eb ff ff       	call   8021a5 <set_block_data>
  803608:	83 c4 10             	add    $0x10,%esp
				return va;
  80360b:	8b 45 08             	mov    0x8(%ebp),%eax
  80360e:	e9 6b 02 00 00       	jmp    80387e <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803613:	8b 45 08             	mov    0x8(%ebp),%eax
  803616:	e9 63 02 00 00       	jmp    80387e <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  80361b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80361e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803621:	0f 86 4d 02 00 00    	jbe    803874 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803627:	83 ec 0c             	sub    $0xc,%esp
  80362a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80362d:	e8 3b e8 ff ff       	call   801e6d <is_free_block>
  803632:	83 c4 10             	add    $0x10,%esp
  803635:	84 c0                	test   %al,%al
  803637:	0f 84 37 02 00 00    	je     803874 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80363d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803640:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803643:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803646:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803649:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80364c:	76 38                	jbe    803686 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  80364e:	83 ec 0c             	sub    $0xc,%esp
  803651:	ff 75 0c             	pushl  0xc(%ebp)
  803654:	e8 7b eb ff ff       	call   8021d4 <alloc_block_FF>
  803659:	83 c4 10             	add    $0x10,%esp
  80365c:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80365f:	83 ec 08             	sub    $0x8,%esp
  803662:	ff 75 c0             	pushl  -0x40(%ebp)
  803665:	ff 75 08             	pushl  0x8(%ebp)
  803668:	e8 c9 fa ff ff       	call   803136 <copy_data>
  80366d:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803670:	83 ec 0c             	sub    $0xc,%esp
  803673:	ff 75 08             	pushl  0x8(%ebp)
  803676:	e8 fa f9 ff ff       	call   803075 <free_block>
  80367b:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80367e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803681:	e9 f8 01 00 00       	jmp    80387e <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803686:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803689:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80368c:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80368f:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803693:	0f 87 a0 00 00 00    	ja     803739 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803699:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80369d:	75 17                	jne    8036b6 <realloc_block_FF+0x541>
  80369f:	83 ec 04             	sub    $0x4,%esp
  8036a2:	68 63 44 80 00       	push   $0x804463
  8036a7:	68 38 02 00 00       	push   $0x238
  8036ac:	68 81 44 80 00       	push   $0x804481
  8036b1:	e8 eb cb ff ff       	call   8002a1 <_panic>
  8036b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b9:	8b 00                	mov    (%eax),%eax
  8036bb:	85 c0                	test   %eax,%eax
  8036bd:	74 10                	je     8036cf <realloc_block_FF+0x55a>
  8036bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c2:	8b 00                	mov    (%eax),%eax
  8036c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036c7:	8b 52 04             	mov    0x4(%edx),%edx
  8036ca:	89 50 04             	mov    %edx,0x4(%eax)
  8036cd:	eb 0b                	jmp    8036da <realloc_block_FF+0x565>
  8036cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d2:	8b 40 04             	mov    0x4(%eax),%eax
  8036d5:	a3 30 50 80 00       	mov    %eax,0x805030
  8036da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036dd:	8b 40 04             	mov    0x4(%eax),%eax
  8036e0:	85 c0                	test   %eax,%eax
  8036e2:	74 0f                	je     8036f3 <realloc_block_FF+0x57e>
  8036e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e7:	8b 40 04             	mov    0x4(%eax),%eax
  8036ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036ed:	8b 12                	mov    (%edx),%edx
  8036ef:	89 10                	mov    %edx,(%eax)
  8036f1:	eb 0a                	jmp    8036fd <realloc_block_FF+0x588>
  8036f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f6:	8b 00                	mov    (%eax),%eax
  8036f8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803700:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803706:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803709:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803710:	a1 38 50 80 00       	mov    0x805038,%eax
  803715:	48                   	dec    %eax
  803716:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80371b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80371e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803721:	01 d0                	add    %edx,%eax
  803723:	83 ec 04             	sub    $0x4,%esp
  803726:	6a 01                	push   $0x1
  803728:	50                   	push   %eax
  803729:	ff 75 08             	pushl  0x8(%ebp)
  80372c:	e8 74 ea ff ff       	call   8021a5 <set_block_data>
  803731:	83 c4 10             	add    $0x10,%esp
  803734:	e9 36 01 00 00       	jmp    80386f <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803739:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80373c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80373f:	01 d0                	add    %edx,%eax
  803741:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803744:	83 ec 04             	sub    $0x4,%esp
  803747:	6a 01                	push   $0x1
  803749:	ff 75 f0             	pushl  -0x10(%ebp)
  80374c:	ff 75 08             	pushl  0x8(%ebp)
  80374f:	e8 51 ea ff ff       	call   8021a5 <set_block_data>
  803754:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803757:	8b 45 08             	mov    0x8(%ebp),%eax
  80375a:	83 e8 04             	sub    $0x4,%eax
  80375d:	8b 00                	mov    (%eax),%eax
  80375f:	83 e0 fe             	and    $0xfffffffe,%eax
  803762:	89 c2                	mov    %eax,%edx
  803764:	8b 45 08             	mov    0x8(%ebp),%eax
  803767:	01 d0                	add    %edx,%eax
  803769:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80376c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803770:	74 06                	je     803778 <realloc_block_FF+0x603>
  803772:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803776:	75 17                	jne    80378f <realloc_block_FF+0x61a>
  803778:	83 ec 04             	sub    $0x4,%esp
  80377b:	68 f4 44 80 00       	push   $0x8044f4
  803780:	68 44 02 00 00       	push   $0x244
  803785:	68 81 44 80 00       	push   $0x804481
  80378a:	e8 12 cb ff ff       	call   8002a1 <_panic>
  80378f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803792:	8b 10                	mov    (%eax),%edx
  803794:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803797:	89 10                	mov    %edx,(%eax)
  803799:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80379c:	8b 00                	mov    (%eax),%eax
  80379e:	85 c0                	test   %eax,%eax
  8037a0:	74 0b                	je     8037ad <realloc_block_FF+0x638>
  8037a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a5:	8b 00                	mov    (%eax),%eax
  8037a7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037aa:	89 50 04             	mov    %edx,0x4(%eax)
  8037ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037b3:	89 10                	mov    %edx,(%eax)
  8037b5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037bb:	89 50 04             	mov    %edx,0x4(%eax)
  8037be:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037c1:	8b 00                	mov    (%eax),%eax
  8037c3:	85 c0                	test   %eax,%eax
  8037c5:	75 08                	jne    8037cf <realloc_block_FF+0x65a>
  8037c7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037ca:	a3 30 50 80 00       	mov    %eax,0x805030
  8037cf:	a1 38 50 80 00       	mov    0x805038,%eax
  8037d4:	40                   	inc    %eax
  8037d5:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8037da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037de:	75 17                	jne    8037f7 <realloc_block_FF+0x682>
  8037e0:	83 ec 04             	sub    $0x4,%esp
  8037e3:	68 63 44 80 00       	push   $0x804463
  8037e8:	68 45 02 00 00       	push   $0x245
  8037ed:	68 81 44 80 00       	push   $0x804481
  8037f2:	e8 aa ca ff ff       	call   8002a1 <_panic>
  8037f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fa:	8b 00                	mov    (%eax),%eax
  8037fc:	85 c0                	test   %eax,%eax
  8037fe:	74 10                	je     803810 <realloc_block_FF+0x69b>
  803800:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803803:	8b 00                	mov    (%eax),%eax
  803805:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803808:	8b 52 04             	mov    0x4(%edx),%edx
  80380b:	89 50 04             	mov    %edx,0x4(%eax)
  80380e:	eb 0b                	jmp    80381b <realloc_block_FF+0x6a6>
  803810:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803813:	8b 40 04             	mov    0x4(%eax),%eax
  803816:	a3 30 50 80 00       	mov    %eax,0x805030
  80381b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381e:	8b 40 04             	mov    0x4(%eax),%eax
  803821:	85 c0                	test   %eax,%eax
  803823:	74 0f                	je     803834 <realloc_block_FF+0x6bf>
  803825:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803828:	8b 40 04             	mov    0x4(%eax),%eax
  80382b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80382e:	8b 12                	mov    (%edx),%edx
  803830:	89 10                	mov    %edx,(%eax)
  803832:	eb 0a                	jmp    80383e <realloc_block_FF+0x6c9>
  803834:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803837:	8b 00                	mov    (%eax),%eax
  803839:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80383e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803841:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803847:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803851:	a1 38 50 80 00       	mov    0x805038,%eax
  803856:	48                   	dec    %eax
  803857:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  80385c:	83 ec 04             	sub    $0x4,%esp
  80385f:	6a 00                	push   $0x0
  803861:	ff 75 bc             	pushl  -0x44(%ebp)
  803864:	ff 75 b8             	pushl  -0x48(%ebp)
  803867:	e8 39 e9 ff ff       	call   8021a5 <set_block_data>
  80386c:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80386f:	8b 45 08             	mov    0x8(%ebp),%eax
  803872:	eb 0a                	jmp    80387e <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803874:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80387b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80387e:	c9                   	leave  
  80387f:	c3                   	ret    

00803880 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803880:	55                   	push   %ebp
  803881:	89 e5                	mov    %esp,%ebp
  803883:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803886:	83 ec 04             	sub    $0x4,%esp
  803889:	68 60 45 80 00       	push   $0x804560
  80388e:	68 58 02 00 00       	push   $0x258
  803893:	68 81 44 80 00       	push   $0x804481
  803898:	e8 04 ca ff ff       	call   8002a1 <_panic>

0080389d <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80389d:	55                   	push   %ebp
  80389e:	89 e5                	mov    %esp,%ebp
  8038a0:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8038a3:	83 ec 04             	sub    $0x4,%esp
  8038a6:	68 88 45 80 00       	push   $0x804588
  8038ab:	68 61 02 00 00       	push   $0x261
  8038b0:	68 81 44 80 00       	push   $0x804481
  8038b5:	e8 e7 c9 ff ff       	call   8002a1 <_panic>

008038ba <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8038ba:	55                   	push   %ebp
  8038bb:	89 e5                	mov    %esp,%ebp
  8038bd:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8038c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8038c3:	89 d0                	mov    %edx,%eax
  8038c5:	c1 e0 02             	shl    $0x2,%eax
  8038c8:	01 d0                	add    %edx,%eax
  8038ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038d1:	01 d0                	add    %edx,%eax
  8038d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038da:	01 d0                	add    %edx,%eax
  8038dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038e3:	01 d0                	add    %edx,%eax
  8038e5:	c1 e0 04             	shl    $0x4,%eax
  8038e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8038eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8038f2:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8038f5:	83 ec 0c             	sub    $0xc,%esp
  8038f8:	50                   	push   %eax
  8038f9:	e8 62 e2 ff ff       	call   801b60 <sys_get_virtual_time>
  8038fe:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803901:	eb 41                	jmp    803944 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803903:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803906:	83 ec 0c             	sub    $0xc,%esp
  803909:	50                   	push   %eax
  80390a:	e8 51 e2 ff ff       	call   801b60 <sys_get_virtual_time>
  80390f:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803912:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803915:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803918:	29 c2                	sub    %eax,%edx
  80391a:	89 d0                	mov    %edx,%eax
  80391c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80391f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803922:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803925:	89 d1                	mov    %edx,%ecx
  803927:	29 c1                	sub    %eax,%ecx
  803929:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80392c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80392f:	39 c2                	cmp    %eax,%edx
  803931:	0f 97 c0             	seta   %al
  803934:	0f b6 c0             	movzbl %al,%eax
  803937:	29 c1                	sub    %eax,%ecx
  803939:	89 c8                	mov    %ecx,%eax
  80393b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80393e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803941:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803947:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80394a:	72 b7                	jb     803903 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80394c:	90                   	nop
  80394d:	c9                   	leave  
  80394e:	c3                   	ret    

0080394f <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80394f:	55                   	push   %ebp
  803950:	89 e5                	mov    %esp,%ebp
  803952:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803955:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80395c:	eb 03                	jmp    803961 <busy_wait+0x12>
  80395e:	ff 45 fc             	incl   -0x4(%ebp)
  803961:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803964:	3b 45 08             	cmp    0x8(%ebp),%eax
  803967:	72 f5                	jb     80395e <busy_wait+0xf>
	return i;
  803969:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80396c:	c9                   	leave  
  80396d:	c3                   	ret    
  80396e:	66 90                	xchg   %ax,%ax

00803970 <__udivdi3>:
  803970:	55                   	push   %ebp
  803971:	57                   	push   %edi
  803972:	56                   	push   %esi
  803973:	53                   	push   %ebx
  803974:	83 ec 1c             	sub    $0x1c,%esp
  803977:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80397b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80397f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803983:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803987:	89 ca                	mov    %ecx,%edx
  803989:	89 f8                	mov    %edi,%eax
  80398b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80398f:	85 f6                	test   %esi,%esi
  803991:	75 2d                	jne    8039c0 <__udivdi3+0x50>
  803993:	39 cf                	cmp    %ecx,%edi
  803995:	77 65                	ja     8039fc <__udivdi3+0x8c>
  803997:	89 fd                	mov    %edi,%ebp
  803999:	85 ff                	test   %edi,%edi
  80399b:	75 0b                	jne    8039a8 <__udivdi3+0x38>
  80399d:	b8 01 00 00 00       	mov    $0x1,%eax
  8039a2:	31 d2                	xor    %edx,%edx
  8039a4:	f7 f7                	div    %edi
  8039a6:	89 c5                	mov    %eax,%ebp
  8039a8:	31 d2                	xor    %edx,%edx
  8039aa:	89 c8                	mov    %ecx,%eax
  8039ac:	f7 f5                	div    %ebp
  8039ae:	89 c1                	mov    %eax,%ecx
  8039b0:	89 d8                	mov    %ebx,%eax
  8039b2:	f7 f5                	div    %ebp
  8039b4:	89 cf                	mov    %ecx,%edi
  8039b6:	89 fa                	mov    %edi,%edx
  8039b8:	83 c4 1c             	add    $0x1c,%esp
  8039bb:	5b                   	pop    %ebx
  8039bc:	5e                   	pop    %esi
  8039bd:	5f                   	pop    %edi
  8039be:	5d                   	pop    %ebp
  8039bf:	c3                   	ret    
  8039c0:	39 ce                	cmp    %ecx,%esi
  8039c2:	77 28                	ja     8039ec <__udivdi3+0x7c>
  8039c4:	0f bd fe             	bsr    %esi,%edi
  8039c7:	83 f7 1f             	xor    $0x1f,%edi
  8039ca:	75 40                	jne    803a0c <__udivdi3+0x9c>
  8039cc:	39 ce                	cmp    %ecx,%esi
  8039ce:	72 0a                	jb     8039da <__udivdi3+0x6a>
  8039d0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8039d4:	0f 87 9e 00 00 00    	ja     803a78 <__udivdi3+0x108>
  8039da:	b8 01 00 00 00       	mov    $0x1,%eax
  8039df:	89 fa                	mov    %edi,%edx
  8039e1:	83 c4 1c             	add    $0x1c,%esp
  8039e4:	5b                   	pop    %ebx
  8039e5:	5e                   	pop    %esi
  8039e6:	5f                   	pop    %edi
  8039e7:	5d                   	pop    %ebp
  8039e8:	c3                   	ret    
  8039e9:	8d 76 00             	lea    0x0(%esi),%esi
  8039ec:	31 ff                	xor    %edi,%edi
  8039ee:	31 c0                	xor    %eax,%eax
  8039f0:	89 fa                	mov    %edi,%edx
  8039f2:	83 c4 1c             	add    $0x1c,%esp
  8039f5:	5b                   	pop    %ebx
  8039f6:	5e                   	pop    %esi
  8039f7:	5f                   	pop    %edi
  8039f8:	5d                   	pop    %ebp
  8039f9:	c3                   	ret    
  8039fa:	66 90                	xchg   %ax,%ax
  8039fc:	89 d8                	mov    %ebx,%eax
  8039fe:	f7 f7                	div    %edi
  803a00:	31 ff                	xor    %edi,%edi
  803a02:	89 fa                	mov    %edi,%edx
  803a04:	83 c4 1c             	add    $0x1c,%esp
  803a07:	5b                   	pop    %ebx
  803a08:	5e                   	pop    %esi
  803a09:	5f                   	pop    %edi
  803a0a:	5d                   	pop    %ebp
  803a0b:	c3                   	ret    
  803a0c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a11:	89 eb                	mov    %ebp,%ebx
  803a13:	29 fb                	sub    %edi,%ebx
  803a15:	89 f9                	mov    %edi,%ecx
  803a17:	d3 e6                	shl    %cl,%esi
  803a19:	89 c5                	mov    %eax,%ebp
  803a1b:	88 d9                	mov    %bl,%cl
  803a1d:	d3 ed                	shr    %cl,%ebp
  803a1f:	89 e9                	mov    %ebp,%ecx
  803a21:	09 f1                	or     %esi,%ecx
  803a23:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a27:	89 f9                	mov    %edi,%ecx
  803a29:	d3 e0                	shl    %cl,%eax
  803a2b:	89 c5                	mov    %eax,%ebp
  803a2d:	89 d6                	mov    %edx,%esi
  803a2f:	88 d9                	mov    %bl,%cl
  803a31:	d3 ee                	shr    %cl,%esi
  803a33:	89 f9                	mov    %edi,%ecx
  803a35:	d3 e2                	shl    %cl,%edx
  803a37:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a3b:	88 d9                	mov    %bl,%cl
  803a3d:	d3 e8                	shr    %cl,%eax
  803a3f:	09 c2                	or     %eax,%edx
  803a41:	89 d0                	mov    %edx,%eax
  803a43:	89 f2                	mov    %esi,%edx
  803a45:	f7 74 24 0c          	divl   0xc(%esp)
  803a49:	89 d6                	mov    %edx,%esi
  803a4b:	89 c3                	mov    %eax,%ebx
  803a4d:	f7 e5                	mul    %ebp
  803a4f:	39 d6                	cmp    %edx,%esi
  803a51:	72 19                	jb     803a6c <__udivdi3+0xfc>
  803a53:	74 0b                	je     803a60 <__udivdi3+0xf0>
  803a55:	89 d8                	mov    %ebx,%eax
  803a57:	31 ff                	xor    %edi,%edi
  803a59:	e9 58 ff ff ff       	jmp    8039b6 <__udivdi3+0x46>
  803a5e:	66 90                	xchg   %ax,%ax
  803a60:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a64:	89 f9                	mov    %edi,%ecx
  803a66:	d3 e2                	shl    %cl,%edx
  803a68:	39 c2                	cmp    %eax,%edx
  803a6a:	73 e9                	jae    803a55 <__udivdi3+0xe5>
  803a6c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a6f:	31 ff                	xor    %edi,%edi
  803a71:	e9 40 ff ff ff       	jmp    8039b6 <__udivdi3+0x46>
  803a76:	66 90                	xchg   %ax,%ax
  803a78:	31 c0                	xor    %eax,%eax
  803a7a:	e9 37 ff ff ff       	jmp    8039b6 <__udivdi3+0x46>
  803a7f:	90                   	nop

00803a80 <__umoddi3>:
  803a80:	55                   	push   %ebp
  803a81:	57                   	push   %edi
  803a82:	56                   	push   %esi
  803a83:	53                   	push   %ebx
  803a84:	83 ec 1c             	sub    $0x1c,%esp
  803a87:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a8b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a93:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a97:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a9b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a9f:	89 f3                	mov    %esi,%ebx
  803aa1:	89 fa                	mov    %edi,%edx
  803aa3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803aa7:	89 34 24             	mov    %esi,(%esp)
  803aaa:	85 c0                	test   %eax,%eax
  803aac:	75 1a                	jne    803ac8 <__umoddi3+0x48>
  803aae:	39 f7                	cmp    %esi,%edi
  803ab0:	0f 86 a2 00 00 00    	jbe    803b58 <__umoddi3+0xd8>
  803ab6:	89 c8                	mov    %ecx,%eax
  803ab8:	89 f2                	mov    %esi,%edx
  803aba:	f7 f7                	div    %edi
  803abc:	89 d0                	mov    %edx,%eax
  803abe:	31 d2                	xor    %edx,%edx
  803ac0:	83 c4 1c             	add    $0x1c,%esp
  803ac3:	5b                   	pop    %ebx
  803ac4:	5e                   	pop    %esi
  803ac5:	5f                   	pop    %edi
  803ac6:	5d                   	pop    %ebp
  803ac7:	c3                   	ret    
  803ac8:	39 f0                	cmp    %esi,%eax
  803aca:	0f 87 ac 00 00 00    	ja     803b7c <__umoddi3+0xfc>
  803ad0:	0f bd e8             	bsr    %eax,%ebp
  803ad3:	83 f5 1f             	xor    $0x1f,%ebp
  803ad6:	0f 84 ac 00 00 00    	je     803b88 <__umoddi3+0x108>
  803adc:	bf 20 00 00 00       	mov    $0x20,%edi
  803ae1:	29 ef                	sub    %ebp,%edi
  803ae3:	89 fe                	mov    %edi,%esi
  803ae5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ae9:	89 e9                	mov    %ebp,%ecx
  803aeb:	d3 e0                	shl    %cl,%eax
  803aed:	89 d7                	mov    %edx,%edi
  803aef:	89 f1                	mov    %esi,%ecx
  803af1:	d3 ef                	shr    %cl,%edi
  803af3:	09 c7                	or     %eax,%edi
  803af5:	89 e9                	mov    %ebp,%ecx
  803af7:	d3 e2                	shl    %cl,%edx
  803af9:	89 14 24             	mov    %edx,(%esp)
  803afc:	89 d8                	mov    %ebx,%eax
  803afe:	d3 e0                	shl    %cl,%eax
  803b00:	89 c2                	mov    %eax,%edx
  803b02:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b06:	d3 e0                	shl    %cl,%eax
  803b08:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b0c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b10:	89 f1                	mov    %esi,%ecx
  803b12:	d3 e8                	shr    %cl,%eax
  803b14:	09 d0                	or     %edx,%eax
  803b16:	d3 eb                	shr    %cl,%ebx
  803b18:	89 da                	mov    %ebx,%edx
  803b1a:	f7 f7                	div    %edi
  803b1c:	89 d3                	mov    %edx,%ebx
  803b1e:	f7 24 24             	mull   (%esp)
  803b21:	89 c6                	mov    %eax,%esi
  803b23:	89 d1                	mov    %edx,%ecx
  803b25:	39 d3                	cmp    %edx,%ebx
  803b27:	0f 82 87 00 00 00    	jb     803bb4 <__umoddi3+0x134>
  803b2d:	0f 84 91 00 00 00    	je     803bc4 <__umoddi3+0x144>
  803b33:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b37:	29 f2                	sub    %esi,%edx
  803b39:	19 cb                	sbb    %ecx,%ebx
  803b3b:	89 d8                	mov    %ebx,%eax
  803b3d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b41:	d3 e0                	shl    %cl,%eax
  803b43:	89 e9                	mov    %ebp,%ecx
  803b45:	d3 ea                	shr    %cl,%edx
  803b47:	09 d0                	or     %edx,%eax
  803b49:	89 e9                	mov    %ebp,%ecx
  803b4b:	d3 eb                	shr    %cl,%ebx
  803b4d:	89 da                	mov    %ebx,%edx
  803b4f:	83 c4 1c             	add    $0x1c,%esp
  803b52:	5b                   	pop    %ebx
  803b53:	5e                   	pop    %esi
  803b54:	5f                   	pop    %edi
  803b55:	5d                   	pop    %ebp
  803b56:	c3                   	ret    
  803b57:	90                   	nop
  803b58:	89 fd                	mov    %edi,%ebp
  803b5a:	85 ff                	test   %edi,%edi
  803b5c:	75 0b                	jne    803b69 <__umoddi3+0xe9>
  803b5e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b63:	31 d2                	xor    %edx,%edx
  803b65:	f7 f7                	div    %edi
  803b67:	89 c5                	mov    %eax,%ebp
  803b69:	89 f0                	mov    %esi,%eax
  803b6b:	31 d2                	xor    %edx,%edx
  803b6d:	f7 f5                	div    %ebp
  803b6f:	89 c8                	mov    %ecx,%eax
  803b71:	f7 f5                	div    %ebp
  803b73:	89 d0                	mov    %edx,%eax
  803b75:	e9 44 ff ff ff       	jmp    803abe <__umoddi3+0x3e>
  803b7a:	66 90                	xchg   %ax,%ax
  803b7c:	89 c8                	mov    %ecx,%eax
  803b7e:	89 f2                	mov    %esi,%edx
  803b80:	83 c4 1c             	add    $0x1c,%esp
  803b83:	5b                   	pop    %ebx
  803b84:	5e                   	pop    %esi
  803b85:	5f                   	pop    %edi
  803b86:	5d                   	pop    %ebp
  803b87:	c3                   	ret    
  803b88:	3b 04 24             	cmp    (%esp),%eax
  803b8b:	72 06                	jb     803b93 <__umoddi3+0x113>
  803b8d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b91:	77 0f                	ja     803ba2 <__umoddi3+0x122>
  803b93:	89 f2                	mov    %esi,%edx
  803b95:	29 f9                	sub    %edi,%ecx
  803b97:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b9b:	89 14 24             	mov    %edx,(%esp)
  803b9e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ba2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ba6:	8b 14 24             	mov    (%esp),%edx
  803ba9:	83 c4 1c             	add    $0x1c,%esp
  803bac:	5b                   	pop    %ebx
  803bad:	5e                   	pop    %esi
  803bae:	5f                   	pop    %edi
  803baf:	5d                   	pop    %ebp
  803bb0:	c3                   	ret    
  803bb1:	8d 76 00             	lea    0x0(%esi),%esi
  803bb4:	2b 04 24             	sub    (%esp),%eax
  803bb7:	19 fa                	sbb    %edi,%edx
  803bb9:	89 d1                	mov    %edx,%ecx
  803bbb:	89 c6                	mov    %eax,%esi
  803bbd:	e9 71 ff ff ff       	jmp    803b33 <__umoddi3+0xb3>
  803bc2:	66 90                	xchg   %ax,%ax
  803bc4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803bc8:	72 ea                	jb     803bb4 <__umoddi3+0x134>
  803bca:	89 d9                	mov    %ebx,%ecx
  803bcc:	e9 62 ff ff ff       	jmp    803b33 <__umoddi3+0xb3>
