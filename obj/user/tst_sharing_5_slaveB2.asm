
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
  80005b:	68 80 3c 80 00       	push   $0x803c80
  800060:	6a 0c                	push   $0xc
  800062:	68 9c 3c 80 00       	push   $0x803c9c
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
  80007b:	68 b9 3c 80 00       	push   $0x803cb9
  800080:	50                   	push   %eax
  800081:	e8 4b 16 00 00       	call   8016d1 <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 bc 3c 80 00       	push   $0x803cbc
  800094:	e8 c5 04 00 00       	call   80055e <cprintf>
  800099:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got z
	inctst();
  80009c:	e8 b1 1b 00 00       	call   801c52 <inctst>

	cprintf("Slave B2 please be patient ...\n");
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	68 e4 3c 80 00       	push   $0x803ce4
  8000a9:	e8 b0 04 00 00       	call   80055e <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 28 23 00 00       	push   $0x2328
  8000b9:	e8 98 38 00 00       	call   803956 <env_sleep>
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
  8000e5:	68 04 3d 80 00       	push   $0x803d04
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
  80010b:	68 1c 3d 80 00       	push   $0x803d1c
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
  80012e:	68 28 3d 80 00       	push   $0x803d28
  800133:	6a 29                	push   $0x29
  800135:	68 9c 3c 80 00       	push   $0x803c9c
  80013a:	e8 62 01 00 00       	call   8002a1 <_panic>


	cprintf("Step B completed successfully!!\n\n\n");
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 c8 3d 80 00       	push   $0x803dc8
  800147:	e8 12 04 00 00       	call   80055e <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n%~Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	68 ec 3d 80 00       	push   $0x803dec
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
  8001de:	68 54 3e 80 00       	push   $0x803e54
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
  800206:	68 7c 3e 80 00       	push   $0x803e7c
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
  800237:	68 a4 3e 80 00       	push   $0x803ea4
  80023c:	e8 1d 03 00 00       	call   80055e <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800244:	a1 20 50 80 00       	mov    0x805020,%eax
  800249:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80024f:	83 ec 08             	sub    $0x8,%esp
  800252:	50                   	push   %eax
  800253:	68 fc 3e 80 00       	push   $0x803efc
  800258:	e8 01 03 00 00       	call   80055e <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	68 54 3e 80 00       	push   $0x803e54
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
  8002c2:	68 10 3f 80 00       	push   $0x803f10
  8002c7:	e8 92 02 00 00       	call   80055e <cprintf>
  8002cc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002cf:	a1 00 50 80 00       	mov    0x805000,%eax
  8002d4:	ff 75 0c             	pushl  0xc(%ebp)
  8002d7:	ff 75 08             	pushl  0x8(%ebp)
  8002da:	50                   	push   %eax
  8002db:	68 15 3f 80 00       	push   $0x803f15
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
  8002ff:	68 31 3f 80 00       	push   $0x803f31
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
  80032e:	68 34 3f 80 00       	push   $0x803f34
  800333:	6a 26                	push   $0x26
  800335:	68 80 3f 80 00       	push   $0x803f80
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
  800403:	68 8c 3f 80 00       	push   $0x803f8c
  800408:	6a 3a                	push   $0x3a
  80040a:	68 80 3f 80 00       	push   $0x803f80
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
  800476:	68 e0 3f 80 00       	push   $0x803fe0
  80047b:	6a 44                	push   $0x44
  80047d:	68 80 3f 80 00       	push   $0x803f80
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
  8005fb:	e8 0c 34 00 00       	call   803a0c <__udivdi3>
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
  80064b:	e8 cc 34 00 00       	call   803b1c <__umoddi3>
  800650:	83 c4 10             	add    $0x10,%esp
  800653:	05 54 42 80 00       	add    $0x804254,%eax
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
  8007a6:	8b 04 85 78 42 80 00 	mov    0x804278(,%eax,4),%eax
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
  800887:	8b 34 9d c0 40 80 00 	mov    0x8040c0(,%ebx,4),%esi
  80088e:	85 f6                	test   %esi,%esi
  800890:	75 19                	jne    8008ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800892:	53                   	push   %ebx
  800893:	68 65 42 80 00       	push   $0x804265
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
  8008ac:	68 6e 42 80 00       	push   $0x80426e
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
  8008d9:	be 71 42 80 00       	mov    $0x804271,%esi
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
  8012e4:	68 e8 43 80 00       	push   $0x8043e8
  8012e9:	68 3f 01 00 00       	push   $0x13f
  8012ee:	68 0a 44 80 00       	push   $0x80440a
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
  80138e:	e8 dd 0e 00 00       	call   802270 <alloc_block_FF>
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
  8013b1:	e8 76 13 00 00       	call   80272c <alloc_block_BF>
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
  80155f:	e8 8c 09 00 00       	call   801ef0 <get_block_size>
  801564:	83 c4 10             	add    $0x10,%esp
  801567:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80156a:	83 ec 0c             	sub    $0xc,%esp
  80156d:	ff 75 08             	pushl  0x8(%ebp)
  801570:	e8 9c 1b 00 00       	call   803111 <free_block>
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
  801615:	68 18 44 80 00       	push   $0x804418
  80161a:	68 87 00 00 00       	push   $0x87
  80161f:	68 42 44 80 00       	push   $0x804442
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
  8017c0:	68 50 44 80 00       	push   $0x804450
  8017c5:	68 e4 00 00 00       	push   $0xe4
  8017ca:	68 42 44 80 00       	push   $0x804442
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
  8017dd:	68 76 44 80 00       	push   $0x804476
  8017e2:	68 f0 00 00 00       	push   $0xf0
  8017e7:	68 42 44 80 00       	push   $0x804442
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
  8017fa:	68 76 44 80 00       	push   $0x804476
  8017ff:	68 f5 00 00 00       	push   $0xf5
  801804:	68 42 44 80 00       	push   $0x804442
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
  801817:	68 76 44 80 00       	push   $0x804476
  80181c:	68 fa 00 00 00       	push   $0xfa
  801821:	68 42 44 80 00       	push   $0x804442
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

00801e54 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 2e                	push   $0x2e
  801e66:	e8 c0 f9 ff ff       	call   80182b <syscall>
  801e6b:	83 c4 18             	add    $0x18,%esp
  801e6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801e71:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	50                   	push   %eax
  801e85:	6a 2f                	push   $0x2f
  801e87:	e8 9f f9 ff ff       	call   80182b <syscall>
  801e8c:	83 c4 18             	add    $0x18,%esp
	return;
  801e8f:	90                   	nop
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  801e95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e98:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	52                   	push   %edx
  801ea2:	50                   	push   %eax
  801ea3:	6a 30                	push   $0x30
  801ea5:	e8 81 f9 ff ff       	call   80182b <syscall>
  801eaa:	83 c4 18             	add    $0x18,%esp
	return;
  801ead:	90                   	nop
}
  801eae:	c9                   	leave  
  801eaf:	c3                   	ret    

00801eb0 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  801eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	50                   	push   %eax
  801ec2:	6a 31                	push   $0x31
  801ec4:	e8 62 f9 ff ff       	call   80182b <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
  801ecc:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801ecf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ed2:	c9                   	leave  
  801ed3:	c3                   	ret    

00801ed4 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  801ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	50                   	push   %eax
  801ee3:	6a 32                	push   $0x32
  801ee5:	e8 41 f9 ff ff       	call   80182b <syscall>
  801eea:	83 c4 18             	add    $0x18,%esp
	return;
  801eed:	90                   	nop
}
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
  801ef3:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef9:	83 e8 04             	sub    $0x4,%eax
  801efc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801eff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f02:	8b 00                	mov    (%eax),%eax
  801f04:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    

00801f09 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
  801f0c:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f12:	83 e8 04             	sub    $0x4,%eax
  801f15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f1b:	8b 00                	mov    (%eax),%eax
  801f1d:	83 e0 01             	and    $0x1,%eax
  801f20:	85 c0                	test   %eax,%eax
  801f22:	0f 94 c0             	sete   %al
}
  801f25:	c9                   	leave  
  801f26:	c3                   	ret    

00801f27 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
  801f2a:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f37:	83 f8 02             	cmp    $0x2,%eax
  801f3a:	74 2b                	je     801f67 <alloc_block+0x40>
  801f3c:	83 f8 02             	cmp    $0x2,%eax
  801f3f:	7f 07                	jg     801f48 <alloc_block+0x21>
  801f41:	83 f8 01             	cmp    $0x1,%eax
  801f44:	74 0e                	je     801f54 <alloc_block+0x2d>
  801f46:	eb 58                	jmp    801fa0 <alloc_block+0x79>
  801f48:	83 f8 03             	cmp    $0x3,%eax
  801f4b:	74 2d                	je     801f7a <alloc_block+0x53>
  801f4d:	83 f8 04             	cmp    $0x4,%eax
  801f50:	74 3b                	je     801f8d <alloc_block+0x66>
  801f52:	eb 4c                	jmp    801fa0 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f54:	83 ec 0c             	sub    $0xc,%esp
  801f57:	ff 75 08             	pushl  0x8(%ebp)
  801f5a:	e8 11 03 00 00       	call   802270 <alloc_block_FF>
  801f5f:	83 c4 10             	add    $0x10,%esp
  801f62:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f65:	eb 4a                	jmp    801fb1 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f67:	83 ec 0c             	sub    $0xc,%esp
  801f6a:	ff 75 08             	pushl  0x8(%ebp)
  801f6d:	e8 c7 19 00 00       	call   803939 <alloc_block_NF>
  801f72:	83 c4 10             	add    $0x10,%esp
  801f75:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f78:	eb 37                	jmp    801fb1 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f7a:	83 ec 0c             	sub    $0xc,%esp
  801f7d:	ff 75 08             	pushl  0x8(%ebp)
  801f80:	e8 a7 07 00 00       	call   80272c <alloc_block_BF>
  801f85:	83 c4 10             	add    $0x10,%esp
  801f88:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f8b:	eb 24                	jmp    801fb1 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f8d:	83 ec 0c             	sub    $0xc,%esp
  801f90:	ff 75 08             	pushl  0x8(%ebp)
  801f93:	e8 84 19 00 00       	call   80391c <alloc_block_WF>
  801f98:	83 c4 10             	add    $0x10,%esp
  801f9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f9e:	eb 11                	jmp    801fb1 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801fa0:	83 ec 0c             	sub    $0xc,%esp
  801fa3:	68 88 44 80 00       	push   $0x804488
  801fa8:	e8 b1 e5 ff ff       	call   80055e <cprintf>
  801fad:	83 c4 10             	add    $0x10,%esp
		break;
  801fb0:	90                   	nop
	}
	return va;
  801fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	53                   	push   %ebx
  801fba:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801fbd:	83 ec 0c             	sub    $0xc,%esp
  801fc0:	68 a8 44 80 00       	push   $0x8044a8
  801fc5:	e8 94 e5 ff ff       	call   80055e <cprintf>
  801fca:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801fcd:	83 ec 0c             	sub    $0xc,%esp
  801fd0:	68 d3 44 80 00       	push   $0x8044d3
  801fd5:	e8 84 e5 ff ff       	call   80055e <cprintf>
  801fda:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe3:	eb 37                	jmp    80201c <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801fe5:	83 ec 0c             	sub    $0xc,%esp
  801fe8:	ff 75 f4             	pushl  -0xc(%ebp)
  801feb:	e8 19 ff ff ff       	call   801f09 <is_free_block>
  801ff0:	83 c4 10             	add    $0x10,%esp
  801ff3:	0f be d8             	movsbl %al,%ebx
  801ff6:	83 ec 0c             	sub    $0xc,%esp
  801ff9:	ff 75 f4             	pushl  -0xc(%ebp)
  801ffc:	e8 ef fe ff ff       	call   801ef0 <get_block_size>
  802001:	83 c4 10             	add    $0x10,%esp
  802004:	83 ec 04             	sub    $0x4,%esp
  802007:	53                   	push   %ebx
  802008:	50                   	push   %eax
  802009:	68 eb 44 80 00       	push   $0x8044eb
  80200e:	e8 4b e5 ff ff       	call   80055e <cprintf>
  802013:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802016:	8b 45 10             	mov    0x10(%ebp),%eax
  802019:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80201c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802020:	74 07                	je     802029 <print_blocks_list+0x73>
  802022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802025:	8b 00                	mov    (%eax),%eax
  802027:	eb 05                	jmp    80202e <print_blocks_list+0x78>
  802029:	b8 00 00 00 00       	mov    $0x0,%eax
  80202e:	89 45 10             	mov    %eax,0x10(%ebp)
  802031:	8b 45 10             	mov    0x10(%ebp),%eax
  802034:	85 c0                	test   %eax,%eax
  802036:	75 ad                	jne    801fe5 <print_blocks_list+0x2f>
  802038:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80203c:	75 a7                	jne    801fe5 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80203e:	83 ec 0c             	sub    $0xc,%esp
  802041:	68 a8 44 80 00       	push   $0x8044a8
  802046:	e8 13 e5 ff ff       	call   80055e <cprintf>
  80204b:	83 c4 10             	add    $0x10,%esp

}
  80204e:	90                   	nop
  80204f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802052:	c9                   	leave  
  802053:	c3                   	ret    

00802054 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
  802057:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80205a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80205d:	83 e0 01             	and    $0x1,%eax
  802060:	85 c0                	test   %eax,%eax
  802062:	74 03                	je     802067 <initialize_dynamic_allocator+0x13>
  802064:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802067:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80206b:	0f 84 c7 01 00 00    	je     802238 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802071:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802078:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80207b:	8b 55 08             	mov    0x8(%ebp),%edx
  80207e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802081:	01 d0                	add    %edx,%eax
  802083:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802088:	0f 87 ad 01 00 00    	ja     80223b <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80208e:	8b 45 08             	mov    0x8(%ebp),%eax
  802091:	85 c0                	test   %eax,%eax
  802093:	0f 89 a5 01 00 00    	jns    80223e <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802099:	8b 55 08             	mov    0x8(%ebp),%edx
  80209c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80209f:	01 d0                	add    %edx,%eax
  8020a1:	83 e8 04             	sub    $0x4,%eax
  8020a4:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8020a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8020b0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020b8:	e9 87 00 00 00       	jmp    802144 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8020bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c1:	75 14                	jne    8020d7 <initialize_dynamic_allocator+0x83>
  8020c3:	83 ec 04             	sub    $0x4,%esp
  8020c6:	68 03 45 80 00       	push   $0x804503
  8020cb:	6a 79                	push   $0x79
  8020cd:	68 21 45 80 00       	push   $0x804521
  8020d2:	e8 ca e1 ff ff       	call   8002a1 <_panic>
  8020d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020da:	8b 00                	mov    (%eax),%eax
  8020dc:	85 c0                	test   %eax,%eax
  8020de:	74 10                	je     8020f0 <initialize_dynamic_allocator+0x9c>
  8020e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e3:	8b 00                	mov    (%eax),%eax
  8020e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e8:	8b 52 04             	mov    0x4(%edx),%edx
  8020eb:	89 50 04             	mov    %edx,0x4(%eax)
  8020ee:	eb 0b                	jmp    8020fb <initialize_dynamic_allocator+0xa7>
  8020f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f3:	8b 40 04             	mov    0x4(%eax),%eax
  8020f6:	a3 30 50 80 00       	mov    %eax,0x805030
  8020fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fe:	8b 40 04             	mov    0x4(%eax),%eax
  802101:	85 c0                	test   %eax,%eax
  802103:	74 0f                	je     802114 <initialize_dynamic_allocator+0xc0>
  802105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802108:	8b 40 04             	mov    0x4(%eax),%eax
  80210b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210e:	8b 12                	mov    (%edx),%edx
  802110:	89 10                	mov    %edx,(%eax)
  802112:	eb 0a                	jmp    80211e <initialize_dynamic_allocator+0xca>
  802114:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802117:	8b 00                	mov    (%eax),%eax
  802119:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80211e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802121:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802131:	a1 38 50 80 00       	mov    0x805038,%eax
  802136:	48                   	dec    %eax
  802137:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80213c:	a1 34 50 80 00       	mov    0x805034,%eax
  802141:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802144:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802148:	74 07                	je     802151 <initialize_dynamic_allocator+0xfd>
  80214a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214d:	8b 00                	mov    (%eax),%eax
  80214f:	eb 05                	jmp    802156 <initialize_dynamic_allocator+0x102>
  802151:	b8 00 00 00 00       	mov    $0x0,%eax
  802156:	a3 34 50 80 00       	mov    %eax,0x805034
  80215b:	a1 34 50 80 00       	mov    0x805034,%eax
  802160:	85 c0                	test   %eax,%eax
  802162:	0f 85 55 ff ff ff    	jne    8020bd <initialize_dynamic_allocator+0x69>
  802168:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80216c:	0f 85 4b ff ff ff    	jne    8020bd <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802172:	8b 45 08             	mov    0x8(%ebp),%eax
  802175:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802178:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802181:	a1 44 50 80 00       	mov    0x805044,%eax
  802186:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80218b:	a1 40 50 80 00       	mov    0x805040,%eax
  802190:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
  802199:	83 c0 08             	add    $0x8,%eax
  80219c:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	83 c0 04             	add    $0x4,%eax
  8021a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a8:	83 ea 08             	sub    $0x8,%edx
  8021ab:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b3:	01 d0                	add    %edx,%eax
  8021b5:	83 e8 08             	sub    $0x8,%eax
  8021b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021bb:	83 ea 08             	sub    $0x8,%edx
  8021be:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8021c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8021c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8021d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021d7:	75 17                	jne    8021f0 <initialize_dynamic_allocator+0x19c>
  8021d9:	83 ec 04             	sub    $0x4,%esp
  8021dc:	68 3c 45 80 00       	push   $0x80453c
  8021e1:	68 90 00 00 00       	push   $0x90
  8021e6:	68 21 45 80 00       	push   $0x804521
  8021eb:	e8 b1 e0 ff ff       	call   8002a1 <_panic>
  8021f0:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8021f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f9:	89 10                	mov    %edx,(%eax)
  8021fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021fe:	8b 00                	mov    (%eax),%eax
  802200:	85 c0                	test   %eax,%eax
  802202:	74 0d                	je     802211 <initialize_dynamic_allocator+0x1bd>
  802204:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802209:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80220c:	89 50 04             	mov    %edx,0x4(%eax)
  80220f:	eb 08                	jmp    802219 <initialize_dynamic_allocator+0x1c5>
  802211:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802214:	a3 30 50 80 00       	mov    %eax,0x805030
  802219:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802221:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802224:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80222b:	a1 38 50 80 00       	mov    0x805038,%eax
  802230:	40                   	inc    %eax
  802231:	a3 38 50 80 00       	mov    %eax,0x805038
  802236:	eb 07                	jmp    80223f <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802238:	90                   	nop
  802239:	eb 04                	jmp    80223f <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80223b:	90                   	nop
  80223c:	eb 01                	jmp    80223f <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80223e:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80223f:	c9                   	leave  
  802240:	c3                   	ret    

00802241 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802244:	8b 45 10             	mov    0x10(%ebp),%eax
  802247:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802250:	8b 45 0c             	mov    0xc(%ebp),%eax
  802253:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802255:	8b 45 08             	mov    0x8(%ebp),%eax
  802258:	83 e8 04             	sub    $0x4,%eax
  80225b:	8b 00                	mov    (%eax),%eax
  80225d:	83 e0 fe             	and    $0xfffffffe,%eax
  802260:	8d 50 f8             	lea    -0x8(%eax),%edx
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	01 c2                	add    %eax,%edx
  802268:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226b:	89 02                	mov    %eax,(%edx)
}
  80226d:	90                   	nop
  80226e:	5d                   	pop    %ebp
  80226f:	c3                   	ret    

00802270 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
  802273:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802276:	8b 45 08             	mov    0x8(%ebp),%eax
  802279:	83 e0 01             	and    $0x1,%eax
  80227c:	85 c0                	test   %eax,%eax
  80227e:	74 03                	je     802283 <alloc_block_FF+0x13>
  802280:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802283:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802287:	77 07                	ja     802290 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802289:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802290:	a1 24 50 80 00       	mov    0x805024,%eax
  802295:	85 c0                	test   %eax,%eax
  802297:	75 73                	jne    80230c <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	83 c0 10             	add    $0x10,%eax
  80229f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8022a2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8022a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022af:	01 d0                	add    %edx,%eax
  8022b1:	48                   	dec    %eax
  8022b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8022b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8022bd:	f7 75 ec             	divl   -0x14(%ebp)
  8022c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022c3:	29 d0                	sub    %edx,%eax
  8022c5:	c1 e8 0c             	shr    $0xc,%eax
  8022c8:	83 ec 0c             	sub    $0xc,%esp
  8022cb:	50                   	push   %eax
  8022cc:	e8 27 f0 ff ff       	call   8012f8 <sbrk>
  8022d1:	83 c4 10             	add    $0x10,%esp
  8022d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8022d7:	83 ec 0c             	sub    $0xc,%esp
  8022da:	6a 00                	push   $0x0
  8022dc:	e8 17 f0 ff ff       	call   8012f8 <sbrk>
  8022e1:	83 c4 10             	add    $0x10,%esp
  8022e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8022e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022ea:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8022ed:	83 ec 08             	sub    $0x8,%esp
  8022f0:	50                   	push   %eax
  8022f1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8022f4:	e8 5b fd ff ff       	call   802054 <initialize_dynamic_allocator>
  8022f9:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8022fc:	83 ec 0c             	sub    $0xc,%esp
  8022ff:	68 5f 45 80 00       	push   $0x80455f
  802304:	e8 55 e2 ff ff       	call   80055e <cprintf>
  802309:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80230c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802310:	75 0a                	jne    80231c <alloc_block_FF+0xac>
	        return NULL;
  802312:	b8 00 00 00 00       	mov    $0x0,%eax
  802317:	e9 0e 04 00 00       	jmp    80272a <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80231c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802323:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802328:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80232b:	e9 f3 02 00 00       	jmp    802623 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802333:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802336:	83 ec 0c             	sub    $0xc,%esp
  802339:	ff 75 bc             	pushl  -0x44(%ebp)
  80233c:	e8 af fb ff ff       	call   801ef0 <get_block_size>
  802341:	83 c4 10             	add    $0x10,%esp
  802344:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	83 c0 08             	add    $0x8,%eax
  80234d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802350:	0f 87 c5 02 00 00    	ja     80261b <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	83 c0 18             	add    $0x18,%eax
  80235c:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80235f:	0f 87 19 02 00 00    	ja     80257e <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802365:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802368:	2b 45 08             	sub    0x8(%ebp),%eax
  80236b:	83 e8 08             	sub    $0x8,%eax
  80236e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802371:	8b 45 08             	mov    0x8(%ebp),%eax
  802374:	8d 50 08             	lea    0x8(%eax),%edx
  802377:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80237a:	01 d0                	add    %edx,%eax
  80237c:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	83 c0 08             	add    $0x8,%eax
  802385:	83 ec 04             	sub    $0x4,%esp
  802388:	6a 01                	push   $0x1
  80238a:	50                   	push   %eax
  80238b:	ff 75 bc             	pushl  -0x44(%ebp)
  80238e:	e8 ae fe ff ff       	call   802241 <set_block_data>
  802393:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802399:	8b 40 04             	mov    0x4(%eax),%eax
  80239c:	85 c0                	test   %eax,%eax
  80239e:	75 68                	jne    802408 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023a0:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023a4:	75 17                	jne    8023bd <alloc_block_FF+0x14d>
  8023a6:	83 ec 04             	sub    $0x4,%esp
  8023a9:	68 3c 45 80 00       	push   $0x80453c
  8023ae:	68 d7 00 00 00       	push   $0xd7
  8023b3:	68 21 45 80 00       	push   $0x804521
  8023b8:	e8 e4 de ff ff       	call   8002a1 <_panic>
  8023bd:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8023c3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023c6:	89 10                	mov    %edx,(%eax)
  8023c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023cb:	8b 00                	mov    (%eax),%eax
  8023cd:	85 c0                	test   %eax,%eax
  8023cf:	74 0d                	je     8023de <alloc_block_FF+0x16e>
  8023d1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023d6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023d9:	89 50 04             	mov    %edx,0x4(%eax)
  8023dc:	eb 08                	jmp    8023e6 <alloc_block_FF+0x176>
  8023de:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023e1:	a3 30 50 80 00       	mov    %eax,0x805030
  8023e6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023e9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023ee:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023f8:	a1 38 50 80 00       	mov    0x805038,%eax
  8023fd:	40                   	inc    %eax
  8023fe:	a3 38 50 80 00       	mov    %eax,0x805038
  802403:	e9 dc 00 00 00       	jmp    8024e4 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240b:	8b 00                	mov    (%eax),%eax
  80240d:	85 c0                	test   %eax,%eax
  80240f:	75 65                	jne    802476 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802411:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802415:	75 17                	jne    80242e <alloc_block_FF+0x1be>
  802417:	83 ec 04             	sub    $0x4,%esp
  80241a:	68 70 45 80 00       	push   $0x804570
  80241f:	68 db 00 00 00       	push   $0xdb
  802424:	68 21 45 80 00       	push   $0x804521
  802429:	e8 73 de ff ff       	call   8002a1 <_panic>
  80242e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802434:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802437:	89 50 04             	mov    %edx,0x4(%eax)
  80243a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80243d:	8b 40 04             	mov    0x4(%eax),%eax
  802440:	85 c0                	test   %eax,%eax
  802442:	74 0c                	je     802450 <alloc_block_FF+0x1e0>
  802444:	a1 30 50 80 00       	mov    0x805030,%eax
  802449:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80244c:	89 10                	mov    %edx,(%eax)
  80244e:	eb 08                	jmp    802458 <alloc_block_FF+0x1e8>
  802450:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802453:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802458:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80245b:	a3 30 50 80 00       	mov    %eax,0x805030
  802460:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802463:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802469:	a1 38 50 80 00       	mov    0x805038,%eax
  80246e:	40                   	inc    %eax
  80246f:	a3 38 50 80 00       	mov    %eax,0x805038
  802474:	eb 6e                	jmp    8024e4 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802476:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80247a:	74 06                	je     802482 <alloc_block_FF+0x212>
  80247c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802480:	75 17                	jne    802499 <alloc_block_FF+0x229>
  802482:	83 ec 04             	sub    $0x4,%esp
  802485:	68 94 45 80 00       	push   $0x804594
  80248a:	68 df 00 00 00       	push   $0xdf
  80248f:	68 21 45 80 00       	push   $0x804521
  802494:	e8 08 de ff ff       	call   8002a1 <_panic>
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	8b 10                	mov    (%eax),%edx
  80249e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024a1:	89 10                	mov    %edx,(%eax)
  8024a3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024a6:	8b 00                	mov    (%eax),%eax
  8024a8:	85 c0                	test   %eax,%eax
  8024aa:	74 0b                	je     8024b7 <alloc_block_FF+0x247>
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	8b 00                	mov    (%eax),%eax
  8024b1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024b4:	89 50 04             	mov    %edx,0x4(%eax)
  8024b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ba:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024bd:	89 10                	mov    %edx,(%eax)
  8024bf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c5:	89 50 04             	mov    %edx,0x4(%eax)
  8024c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024cb:	8b 00                	mov    (%eax),%eax
  8024cd:	85 c0                	test   %eax,%eax
  8024cf:	75 08                	jne    8024d9 <alloc_block_FF+0x269>
  8024d1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024d4:	a3 30 50 80 00       	mov    %eax,0x805030
  8024d9:	a1 38 50 80 00       	mov    0x805038,%eax
  8024de:	40                   	inc    %eax
  8024df:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8024e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e8:	75 17                	jne    802501 <alloc_block_FF+0x291>
  8024ea:	83 ec 04             	sub    $0x4,%esp
  8024ed:	68 03 45 80 00       	push   $0x804503
  8024f2:	68 e1 00 00 00       	push   $0xe1
  8024f7:	68 21 45 80 00       	push   $0x804521
  8024fc:	e8 a0 dd ff ff       	call   8002a1 <_panic>
  802501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802504:	8b 00                	mov    (%eax),%eax
  802506:	85 c0                	test   %eax,%eax
  802508:	74 10                	je     80251a <alloc_block_FF+0x2aa>
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	8b 00                	mov    (%eax),%eax
  80250f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802512:	8b 52 04             	mov    0x4(%edx),%edx
  802515:	89 50 04             	mov    %edx,0x4(%eax)
  802518:	eb 0b                	jmp    802525 <alloc_block_FF+0x2b5>
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	8b 40 04             	mov    0x4(%eax),%eax
  802520:	a3 30 50 80 00       	mov    %eax,0x805030
  802525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802528:	8b 40 04             	mov    0x4(%eax),%eax
  80252b:	85 c0                	test   %eax,%eax
  80252d:	74 0f                	je     80253e <alloc_block_FF+0x2ce>
  80252f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802532:	8b 40 04             	mov    0x4(%eax),%eax
  802535:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802538:	8b 12                	mov    (%edx),%edx
  80253a:	89 10                	mov    %edx,(%eax)
  80253c:	eb 0a                	jmp    802548 <alloc_block_FF+0x2d8>
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	8b 00                	mov    (%eax),%eax
  802543:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80255b:	a1 38 50 80 00       	mov    0x805038,%eax
  802560:	48                   	dec    %eax
  802561:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802566:	83 ec 04             	sub    $0x4,%esp
  802569:	6a 00                	push   $0x0
  80256b:	ff 75 b4             	pushl  -0x4c(%ebp)
  80256e:	ff 75 b0             	pushl  -0x50(%ebp)
  802571:	e8 cb fc ff ff       	call   802241 <set_block_data>
  802576:	83 c4 10             	add    $0x10,%esp
  802579:	e9 95 00 00 00       	jmp    802613 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80257e:	83 ec 04             	sub    $0x4,%esp
  802581:	6a 01                	push   $0x1
  802583:	ff 75 b8             	pushl  -0x48(%ebp)
  802586:	ff 75 bc             	pushl  -0x44(%ebp)
  802589:	e8 b3 fc ff ff       	call   802241 <set_block_data>
  80258e:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802591:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802595:	75 17                	jne    8025ae <alloc_block_FF+0x33e>
  802597:	83 ec 04             	sub    $0x4,%esp
  80259a:	68 03 45 80 00       	push   $0x804503
  80259f:	68 e8 00 00 00       	push   $0xe8
  8025a4:	68 21 45 80 00       	push   $0x804521
  8025a9:	e8 f3 dc ff ff       	call   8002a1 <_panic>
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	8b 00                	mov    (%eax),%eax
  8025b3:	85 c0                	test   %eax,%eax
  8025b5:	74 10                	je     8025c7 <alloc_block_FF+0x357>
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 00                	mov    (%eax),%eax
  8025bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025bf:	8b 52 04             	mov    0x4(%edx),%edx
  8025c2:	89 50 04             	mov    %edx,0x4(%eax)
  8025c5:	eb 0b                	jmp    8025d2 <alloc_block_FF+0x362>
  8025c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ca:	8b 40 04             	mov    0x4(%eax),%eax
  8025cd:	a3 30 50 80 00       	mov    %eax,0x805030
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	8b 40 04             	mov    0x4(%eax),%eax
  8025d8:	85 c0                	test   %eax,%eax
  8025da:	74 0f                	je     8025eb <alloc_block_FF+0x37b>
  8025dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025df:	8b 40 04             	mov    0x4(%eax),%eax
  8025e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e5:	8b 12                	mov    (%edx),%edx
  8025e7:	89 10                	mov    %edx,(%eax)
  8025e9:	eb 0a                	jmp    8025f5 <alloc_block_FF+0x385>
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 00                	mov    (%eax),%eax
  8025f0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802608:	a1 38 50 80 00       	mov    0x805038,%eax
  80260d:	48                   	dec    %eax
  80260e:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802613:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802616:	e9 0f 01 00 00       	jmp    80272a <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80261b:	a1 34 50 80 00       	mov    0x805034,%eax
  802620:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802623:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802627:	74 07                	je     802630 <alloc_block_FF+0x3c0>
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	8b 00                	mov    (%eax),%eax
  80262e:	eb 05                	jmp    802635 <alloc_block_FF+0x3c5>
  802630:	b8 00 00 00 00       	mov    $0x0,%eax
  802635:	a3 34 50 80 00       	mov    %eax,0x805034
  80263a:	a1 34 50 80 00       	mov    0x805034,%eax
  80263f:	85 c0                	test   %eax,%eax
  802641:	0f 85 e9 fc ff ff    	jne    802330 <alloc_block_FF+0xc0>
  802647:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264b:	0f 85 df fc ff ff    	jne    802330 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802651:	8b 45 08             	mov    0x8(%ebp),%eax
  802654:	83 c0 08             	add    $0x8,%eax
  802657:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80265a:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802661:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802664:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802667:	01 d0                	add    %edx,%eax
  802669:	48                   	dec    %eax
  80266a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80266d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802670:	ba 00 00 00 00       	mov    $0x0,%edx
  802675:	f7 75 d8             	divl   -0x28(%ebp)
  802678:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80267b:	29 d0                	sub    %edx,%eax
  80267d:	c1 e8 0c             	shr    $0xc,%eax
  802680:	83 ec 0c             	sub    $0xc,%esp
  802683:	50                   	push   %eax
  802684:	e8 6f ec ff ff       	call   8012f8 <sbrk>
  802689:	83 c4 10             	add    $0x10,%esp
  80268c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80268f:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802693:	75 0a                	jne    80269f <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802695:	b8 00 00 00 00       	mov    $0x0,%eax
  80269a:	e9 8b 00 00 00       	jmp    80272a <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80269f:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8026a6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026ac:	01 d0                	add    %edx,%eax
  8026ae:	48                   	dec    %eax
  8026af:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8026b2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ba:	f7 75 cc             	divl   -0x34(%ebp)
  8026bd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026c0:	29 d0                	sub    %edx,%eax
  8026c2:	8d 50 fc             	lea    -0x4(%eax),%edx
  8026c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026c8:	01 d0                	add    %edx,%eax
  8026ca:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8026cf:	a1 40 50 80 00       	mov    0x805040,%eax
  8026d4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8026da:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8026e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026e4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8026e7:	01 d0                	add    %edx,%eax
  8026e9:	48                   	dec    %eax
  8026ea:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8026ed:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8026f5:	f7 75 c4             	divl   -0x3c(%ebp)
  8026f8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026fb:	29 d0                	sub    %edx,%eax
  8026fd:	83 ec 04             	sub    $0x4,%esp
  802700:	6a 01                	push   $0x1
  802702:	50                   	push   %eax
  802703:	ff 75 d0             	pushl  -0x30(%ebp)
  802706:	e8 36 fb ff ff       	call   802241 <set_block_data>
  80270b:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80270e:	83 ec 0c             	sub    $0xc,%esp
  802711:	ff 75 d0             	pushl  -0x30(%ebp)
  802714:	e8 f8 09 00 00       	call   803111 <free_block>
  802719:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80271c:	83 ec 0c             	sub    $0xc,%esp
  80271f:	ff 75 08             	pushl  0x8(%ebp)
  802722:	e8 49 fb ff ff       	call   802270 <alloc_block_FF>
  802727:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80272a:	c9                   	leave  
  80272b:	c3                   	ret    

0080272c <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80272c:	55                   	push   %ebp
  80272d:	89 e5                	mov    %esp,%ebp
  80272f:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802732:	8b 45 08             	mov    0x8(%ebp),%eax
  802735:	83 e0 01             	and    $0x1,%eax
  802738:	85 c0                	test   %eax,%eax
  80273a:	74 03                	je     80273f <alloc_block_BF+0x13>
  80273c:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80273f:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802743:	77 07                	ja     80274c <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802745:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80274c:	a1 24 50 80 00       	mov    0x805024,%eax
  802751:	85 c0                	test   %eax,%eax
  802753:	75 73                	jne    8027c8 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802755:	8b 45 08             	mov    0x8(%ebp),%eax
  802758:	83 c0 10             	add    $0x10,%eax
  80275b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80275e:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802765:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802768:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80276b:	01 d0                	add    %edx,%eax
  80276d:	48                   	dec    %eax
  80276e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802771:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802774:	ba 00 00 00 00       	mov    $0x0,%edx
  802779:	f7 75 e0             	divl   -0x20(%ebp)
  80277c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80277f:	29 d0                	sub    %edx,%eax
  802781:	c1 e8 0c             	shr    $0xc,%eax
  802784:	83 ec 0c             	sub    $0xc,%esp
  802787:	50                   	push   %eax
  802788:	e8 6b eb ff ff       	call   8012f8 <sbrk>
  80278d:	83 c4 10             	add    $0x10,%esp
  802790:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802793:	83 ec 0c             	sub    $0xc,%esp
  802796:	6a 00                	push   $0x0
  802798:	e8 5b eb ff ff       	call   8012f8 <sbrk>
  80279d:	83 c4 10             	add    $0x10,%esp
  8027a0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8027a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027a6:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8027a9:	83 ec 08             	sub    $0x8,%esp
  8027ac:	50                   	push   %eax
  8027ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8027b0:	e8 9f f8 ff ff       	call   802054 <initialize_dynamic_allocator>
  8027b5:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8027b8:	83 ec 0c             	sub    $0xc,%esp
  8027bb:	68 5f 45 80 00       	push   $0x80455f
  8027c0:	e8 99 dd ff ff       	call   80055e <cprintf>
  8027c5:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8027c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8027cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8027d6:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8027dd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8027e4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ec:	e9 1d 01 00 00       	jmp    80290e <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8027f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f4:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8027f7:	83 ec 0c             	sub    $0xc,%esp
  8027fa:	ff 75 a8             	pushl  -0x58(%ebp)
  8027fd:	e8 ee f6 ff ff       	call   801ef0 <get_block_size>
  802802:	83 c4 10             	add    $0x10,%esp
  802805:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802808:	8b 45 08             	mov    0x8(%ebp),%eax
  80280b:	83 c0 08             	add    $0x8,%eax
  80280e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802811:	0f 87 ef 00 00 00    	ja     802906 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802817:	8b 45 08             	mov    0x8(%ebp),%eax
  80281a:	83 c0 18             	add    $0x18,%eax
  80281d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802820:	77 1d                	ja     80283f <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802822:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802825:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802828:	0f 86 d8 00 00 00    	jbe    802906 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80282e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802831:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802834:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802837:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80283a:	e9 c7 00 00 00       	jmp    802906 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80283f:	8b 45 08             	mov    0x8(%ebp),%eax
  802842:	83 c0 08             	add    $0x8,%eax
  802845:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802848:	0f 85 9d 00 00 00    	jne    8028eb <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80284e:	83 ec 04             	sub    $0x4,%esp
  802851:	6a 01                	push   $0x1
  802853:	ff 75 a4             	pushl  -0x5c(%ebp)
  802856:	ff 75 a8             	pushl  -0x58(%ebp)
  802859:	e8 e3 f9 ff ff       	call   802241 <set_block_data>
  80285e:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802861:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802865:	75 17                	jne    80287e <alloc_block_BF+0x152>
  802867:	83 ec 04             	sub    $0x4,%esp
  80286a:	68 03 45 80 00       	push   $0x804503
  80286f:	68 2c 01 00 00       	push   $0x12c
  802874:	68 21 45 80 00       	push   $0x804521
  802879:	e8 23 da ff ff       	call   8002a1 <_panic>
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802881:	8b 00                	mov    (%eax),%eax
  802883:	85 c0                	test   %eax,%eax
  802885:	74 10                	je     802897 <alloc_block_BF+0x16b>
  802887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288a:	8b 00                	mov    (%eax),%eax
  80288c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80288f:	8b 52 04             	mov    0x4(%edx),%edx
  802892:	89 50 04             	mov    %edx,0x4(%eax)
  802895:	eb 0b                	jmp    8028a2 <alloc_block_BF+0x176>
  802897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289a:	8b 40 04             	mov    0x4(%eax),%eax
  80289d:	a3 30 50 80 00       	mov    %eax,0x805030
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	8b 40 04             	mov    0x4(%eax),%eax
  8028a8:	85 c0                	test   %eax,%eax
  8028aa:	74 0f                	je     8028bb <alloc_block_BF+0x18f>
  8028ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028af:	8b 40 04             	mov    0x4(%eax),%eax
  8028b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b5:	8b 12                	mov    (%edx),%edx
  8028b7:	89 10                	mov    %edx,(%eax)
  8028b9:	eb 0a                	jmp    8028c5 <alloc_block_BF+0x199>
  8028bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028be:	8b 00                	mov    (%eax),%eax
  8028c0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d8:	a1 38 50 80 00       	mov    0x805038,%eax
  8028dd:	48                   	dec    %eax
  8028de:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8028e3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028e6:	e9 01 04 00 00       	jmp    802cec <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  8028eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ee:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028f1:	76 13                	jbe    802906 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8028f3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8028fa:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802900:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802903:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802906:	a1 34 50 80 00       	mov    0x805034,%eax
  80290b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80290e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802912:	74 07                	je     80291b <alloc_block_BF+0x1ef>
  802914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802917:	8b 00                	mov    (%eax),%eax
  802919:	eb 05                	jmp    802920 <alloc_block_BF+0x1f4>
  80291b:	b8 00 00 00 00       	mov    $0x0,%eax
  802920:	a3 34 50 80 00       	mov    %eax,0x805034
  802925:	a1 34 50 80 00       	mov    0x805034,%eax
  80292a:	85 c0                	test   %eax,%eax
  80292c:	0f 85 bf fe ff ff    	jne    8027f1 <alloc_block_BF+0xc5>
  802932:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802936:	0f 85 b5 fe ff ff    	jne    8027f1 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80293c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802940:	0f 84 26 02 00 00    	je     802b6c <alloc_block_BF+0x440>
  802946:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80294a:	0f 85 1c 02 00 00    	jne    802b6c <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802950:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802953:	2b 45 08             	sub    0x8(%ebp),%eax
  802956:	83 e8 08             	sub    $0x8,%eax
  802959:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80295c:	8b 45 08             	mov    0x8(%ebp),%eax
  80295f:	8d 50 08             	lea    0x8(%eax),%edx
  802962:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802965:	01 d0                	add    %edx,%eax
  802967:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80296a:	8b 45 08             	mov    0x8(%ebp),%eax
  80296d:	83 c0 08             	add    $0x8,%eax
  802970:	83 ec 04             	sub    $0x4,%esp
  802973:	6a 01                	push   $0x1
  802975:	50                   	push   %eax
  802976:	ff 75 f0             	pushl  -0x10(%ebp)
  802979:	e8 c3 f8 ff ff       	call   802241 <set_block_data>
  80297e:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802981:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802984:	8b 40 04             	mov    0x4(%eax),%eax
  802987:	85 c0                	test   %eax,%eax
  802989:	75 68                	jne    8029f3 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80298b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80298f:	75 17                	jne    8029a8 <alloc_block_BF+0x27c>
  802991:	83 ec 04             	sub    $0x4,%esp
  802994:	68 3c 45 80 00       	push   $0x80453c
  802999:	68 45 01 00 00       	push   $0x145
  80299e:	68 21 45 80 00       	push   $0x804521
  8029a3:	e8 f9 d8 ff ff       	call   8002a1 <_panic>
  8029a8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8029ae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029b1:	89 10                	mov    %edx,(%eax)
  8029b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029b6:	8b 00                	mov    (%eax),%eax
  8029b8:	85 c0                	test   %eax,%eax
  8029ba:	74 0d                	je     8029c9 <alloc_block_BF+0x29d>
  8029bc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029c1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029c4:	89 50 04             	mov    %edx,0x4(%eax)
  8029c7:	eb 08                	jmp    8029d1 <alloc_block_BF+0x2a5>
  8029c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029cc:	a3 30 50 80 00       	mov    %eax,0x805030
  8029d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029d4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e3:	a1 38 50 80 00       	mov    0x805038,%eax
  8029e8:	40                   	inc    %eax
  8029e9:	a3 38 50 80 00       	mov    %eax,0x805038
  8029ee:	e9 dc 00 00 00       	jmp    802acf <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8029f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f6:	8b 00                	mov    (%eax),%eax
  8029f8:	85 c0                	test   %eax,%eax
  8029fa:	75 65                	jne    802a61 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029fc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a00:	75 17                	jne    802a19 <alloc_block_BF+0x2ed>
  802a02:	83 ec 04             	sub    $0x4,%esp
  802a05:	68 70 45 80 00       	push   $0x804570
  802a0a:	68 4a 01 00 00       	push   $0x14a
  802a0f:	68 21 45 80 00       	push   $0x804521
  802a14:	e8 88 d8 ff ff       	call   8002a1 <_panic>
  802a19:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a1f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a22:	89 50 04             	mov    %edx,0x4(%eax)
  802a25:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a28:	8b 40 04             	mov    0x4(%eax),%eax
  802a2b:	85 c0                	test   %eax,%eax
  802a2d:	74 0c                	je     802a3b <alloc_block_BF+0x30f>
  802a2f:	a1 30 50 80 00       	mov    0x805030,%eax
  802a34:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a37:	89 10                	mov    %edx,(%eax)
  802a39:	eb 08                	jmp    802a43 <alloc_block_BF+0x317>
  802a3b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a3e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a43:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a46:	a3 30 50 80 00       	mov    %eax,0x805030
  802a4b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a54:	a1 38 50 80 00       	mov    0x805038,%eax
  802a59:	40                   	inc    %eax
  802a5a:	a3 38 50 80 00       	mov    %eax,0x805038
  802a5f:	eb 6e                	jmp    802acf <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802a61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a65:	74 06                	je     802a6d <alloc_block_BF+0x341>
  802a67:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a6b:	75 17                	jne    802a84 <alloc_block_BF+0x358>
  802a6d:	83 ec 04             	sub    $0x4,%esp
  802a70:	68 94 45 80 00       	push   $0x804594
  802a75:	68 4f 01 00 00       	push   $0x14f
  802a7a:	68 21 45 80 00       	push   $0x804521
  802a7f:	e8 1d d8 ff ff       	call   8002a1 <_panic>
  802a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a87:	8b 10                	mov    (%eax),%edx
  802a89:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a8c:	89 10                	mov    %edx,(%eax)
  802a8e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a91:	8b 00                	mov    (%eax),%eax
  802a93:	85 c0                	test   %eax,%eax
  802a95:	74 0b                	je     802aa2 <alloc_block_BF+0x376>
  802a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9a:	8b 00                	mov    (%eax),%eax
  802a9c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a9f:	89 50 04             	mov    %edx,0x4(%eax)
  802aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802aa8:	89 10                	mov    %edx,(%eax)
  802aaa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ab0:	89 50 04             	mov    %edx,0x4(%eax)
  802ab3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ab6:	8b 00                	mov    (%eax),%eax
  802ab8:	85 c0                	test   %eax,%eax
  802aba:	75 08                	jne    802ac4 <alloc_block_BF+0x398>
  802abc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802abf:	a3 30 50 80 00       	mov    %eax,0x805030
  802ac4:	a1 38 50 80 00       	mov    0x805038,%eax
  802ac9:	40                   	inc    %eax
  802aca:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802acf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ad3:	75 17                	jne    802aec <alloc_block_BF+0x3c0>
  802ad5:	83 ec 04             	sub    $0x4,%esp
  802ad8:	68 03 45 80 00       	push   $0x804503
  802add:	68 51 01 00 00       	push   $0x151
  802ae2:	68 21 45 80 00       	push   $0x804521
  802ae7:	e8 b5 d7 ff ff       	call   8002a1 <_panic>
  802aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aef:	8b 00                	mov    (%eax),%eax
  802af1:	85 c0                	test   %eax,%eax
  802af3:	74 10                	je     802b05 <alloc_block_BF+0x3d9>
  802af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af8:	8b 00                	mov    (%eax),%eax
  802afa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802afd:	8b 52 04             	mov    0x4(%edx),%edx
  802b00:	89 50 04             	mov    %edx,0x4(%eax)
  802b03:	eb 0b                	jmp    802b10 <alloc_block_BF+0x3e4>
  802b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b08:	8b 40 04             	mov    0x4(%eax),%eax
  802b0b:	a3 30 50 80 00       	mov    %eax,0x805030
  802b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b13:	8b 40 04             	mov    0x4(%eax),%eax
  802b16:	85 c0                	test   %eax,%eax
  802b18:	74 0f                	je     802b29 <alloc_block_BF+0x3fd>
  802b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1d:	8b 40 04             	mov    0x4(%eax),%eax
  802b20:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b23:	8b 12                	mov    (%edx),%edx
  802b25:	89 10                	mov    %edx,(%eax)
  802b27:	eb 0a                	jmp    802b33 <alloc_block_BF+0x407>
  802b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2c:	8b 00                	mov    (%eax),%eax
  802b2e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b46:	a1 38 50 80 00       	mov    0x805038,%eax
  802b4b:	48                   	dec    %eax
  802b4c:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802b51:	83 ec 04             	sub    $0x4,%esp
  802b54:	6a 00                	push   $0x0
  802b56:	ff 75 d0             	pushl  -0x30(%ebp)
  802b59:	ff 75 cc             	pushl  -0x34(%ebp)
  802b5c:	e8 e0 f6 ff ff       	call   802241 <set_block_data>
  802b61:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b67:	e9 80 01 00 00       	jmp    802cec <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802b6c:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802b70:	0f 85 9d 00 00 00    	jne    802c13 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802b76:	83 ec 04             	sub    $0x4,%esp
  802b79:	6a 01                	push   $0x1
  802b7b:	ff 75 ec             	pushl  -0x14(%ebp)
  802b7e:	ff 75 f0             	pushl  -0x10(%ebp)
  802b81:	e8 bb f6 ff ff       	call   802241 <set_block_data>
  802b86:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802b89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b8d:	75 17                	jne    802ba6 <alloc_block_BF+0x47a>
  802b8f:	83 ec 04             	sub    $0x4,%esp
  802b92:	68 03 45 80 00       	push   $0x804503
  802b97:	68 58 01 00 00       	push   $0x158
  802b9c:	68 21 45 80 00       	push   $0x804521
  802ba1:	e8 fb d6 ff ff       	call   8002a1 <_panic>
  802ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba9:	8b 00                	mov    (%eax),%eax
  802bab:	85 c0                	test   %eax,%eax
  802bad:	74 10                	je     802bbf <alloc_block_BF+0x493>
  802baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb2:	8b 00                	mov    (%eax),%eax
  802bb4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bb7:	8b 52 04             	mov    0x4(%edx),%edx
  802bba:	89 50 04             	mov    %edx,0x4(%eax)
  802bbd:	eb 0b                	jmp    802bca <alloc_block_BF+0x49e>
  802bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc2:	8b 40 04             	mov    0x4(%eax),%eax
  802bc5:	a3 30 50 80 00       	mov    %eax,0x805030
  802bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcd:	8b 40 04             	mov    0x4(%eax),%eax
  802bd0:	85 c0                	test   %eax,%eax
  802bd2:	74 0f                	je     802be3 <alloc_block_BF+0x4b7>
  802bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd7:	8b 40 04             	mov    0x4(%eax),%eax
  802bda:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bdd:	8b 12                	mov    (%edx),%edx
  802bdf:	89 10                	mov    %edx,(%eax)
  802be1:	eb 0a                	jmp    802bed <alloc_block_BF+0x4c1>
  802be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be6:	8b 00                	mov    (%eax),%eax
  802be8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c00:	a1 38 50 80 00       	mov    0x805038,%eax
  802c05:	48                   	dec    %eax
  802c06:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0e:	e9 d9 00 00 00       	jmp    802cec <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c13:	8b 45 08             	mov    0x8(%ebp),%eax
  802c16:	83 c0 08             	add    $0x8,%eax
  802c19:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c1c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c23:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c26:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c29:	01 d0                	add    %edx,%eax
  802c2b:	48                   	dec    %eax
  802c2c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c2f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c32:	ba 00 00 00 00       	mov    $0x0,%edx
  802c37:	f7 75 c4             	divl   -0x3c(%ebp)
  802c3a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c3d:	29 d0                	sub    %edx,%eax
  802c3f:	c1 e8 0c             	shr    $0xc,%eax
  802c42:	83 ec 0c             	sub    $0xc,%esp
  802c45:	50                   	push   %eax
  802c46:	e8 ad e6 ff ff       	call   8012f8 <sbrk>
  802c4b:	83 c4 10             	add    $0x10,%esp
  802c4e:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802c51:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802c55:	75 0a                	jne    802c61 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802c57:	b8 00 00 00 00       	mov    $0x0,%eax
  802c5c:	e9 8b 00 00 00       	jmp    802cec <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c61:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802c68:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c6b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c6e:	01 d0                	add    %edx,%eax
  802c70:	48                   	dec    %eax
  802c71:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802c74:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c77:	ba 00 00 00 00       	mov    $0x0,%edx
  802c7c:	f7 75 b8             	divl   -0x48(%ebp)
  802c7f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c82:	29 d0                	sub    %edx,%eax
  802c84:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c87:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c8a:	01 d0                	add    %edx,%eax
  802c8c:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802c91:	a1 40 50 80 00       	mov    0x805040,%eax
  802c96:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c9c:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802ca3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ca6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ca9:	01 d0                	add    %edx,%eax
  802cab:	48                   	dec    %eax
  802cac:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802caf:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802cb2:	ba 00 00 00 00       	mov    $0x0,%edx
  802cb7:	f7 75 b0             	divl   -0x50(%ebp)
  802cba:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802cbd:	29 d0                	sub    %edx,%eax
  802cbf:	83 ec 04             	sub    $0x4,%esp
  802cc2:	6a 01                	push   $0x1
  802cc4:	50                   	push   %eax
  802cc5:	ff 75 bc             	pushl  -0x44(%ebp)
  802cc8:	e8 74 f5 ff ff       	call   802241 <set_block_data>
  802ccd:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802cd0:	83 ec 0c             	sub    $0xc,%esp
  802cd3:	ff 75 bc             	pushl  -0x44(%ebp)
  802cd6:	e8 36 04 00 00       	call   803111 <free_block>
  802cdb:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802cde:	83 ec 0c             	sub    $0xc,%esp
  802ce1:	ff 75 08             	pushl  0x8(%ebp)
  802ce4:	e8 43 fa ff ff       	call   80272c <alloc_block_BF>
  802ce9:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802cec:	c9                   	leave  
  802ced:	c3                   	ret    

00802cee <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802cee:	55                   	push   %ebp
  802cef:	89 e5                	mov    %esp,%ebp
  802cf1:	53                   	push   %ebx
  802cf2:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802cf5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802cfc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d07:	74 1e                	je     802d27 <merging+0x39>
  802d09:	ff 75 08             	pushl  0x8(%ebp)
  802d0c:	e8 df f1 ff ff       	call   801ef0 <get_block_size>
  802d11:	83 c4 04             	add    $0x4,%esp
  802d14:	89 c2                	mov    %eax,%edx
  802d16:	8b 45 08             	mov    0x8(%ebp),%eax
  802d19:	01 d0                	add    %edx,%eax
  802d1b:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d1e:	75 07                	jne    802d27 <merging+0x39>
		prev_is_free = 1;
  802d20:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802d27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d2b:	74 1e                	je     802d4b <merging+0x5d>
  802d2d:	ff 75 10             	pushl  0x10(%ebp)
  802d30:	e8 bb f1 ff ff       	call   801ef0 <get_block_size>
  802d35:	83 c4 04             	add    $0x4,%esp
  802d38:	89 c2                	mov    %eax,%edx
  802d3a:	8b 45 10             	mov    0x10(%ebp),%eax
  802d3d:	01 d0                	add    %edx,%eax
  802d3f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d42:	75 07                	jne    802d4b <merging+0x5d>
		next_is_free = 1;
  802d44:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802d4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d4f:	0f 84 cc 00 00 00    	je     802e21 <merging+0x133>
  802d55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d59:	0f 84 c2 00 00 00    	je     802e21 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802d5f:	ff 75 08             	pushl  0x8(%ebp)
  802d62:	e8 89 f1 ff ff       	call   801ef0 <get_block_size>
  802d67:	83 c4 04             	add    $0x4,%esp
  802d6a:	89 c3                	mov    %eax,%ebx
  802d6c:	ff 75 10             	pushl  0x10(%ebp)
  802d6f:	e8 7c f1 ff ff       	call   801ef0 <get_block_size>
  802d74:	83 c4 04             	add    $0x4,%esp
  802d77:	01 c3                	add    %eax,%ebx
  802d79:	ff 75 0c             	pushl  0xc(%ebp)
  802d7c:	e8 6f f1 ff ff       	call   801ef0 <get_block_size>
  802d81:	83 c4 04             	add    $0x4,%esp
  802d84:	01 d8                	add    %ebx,%eax
  802d86:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d89:	6a 00                	push   $0x0
  802d8b:	ff 75 ec             	pushl  -0x14(%ebp)
  802d8e:	ff 75 08             	pushl  0x8(%ebp)
  802d91:	e8 ab f4 ff ff       	call   802241 <set_block_data>
  802d96:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802d99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d9d:	75 17                	jne    802db6 <merging+0xc8>
  802d9f:	83 ec 04             	sub    $0x4,%esp
  802da2:	68 03 45 80 00       	push   $0x804503
  802da7:	68 7d 01 00 00       	push   $0x17d
  802dac:	68 21 45 80 00       	push   $0x804521
  802db1:	e8 eb d4 ff ff       	call   8002a1 <_panic>
  802db6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802db9:	8b 00                	mov    (%eax),%eax
  802dbb:	85 c0                	test   %eax,%eax
  802dbd:	74 10                	je     802dcf <merging+0xe1>
  802dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dc2:	8b 00                	mov    (%eax),%eax
  802dc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dc7:	8b 52 04             	mov    0x4(%edx),%edx
  802dca:	89 50 04             	mov    %edx,0x4(%eax)
  802dcd:	eb 0b                	jmp    802dda <merging+0xec>
  802dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dd2:	8b 40 04             	mov    0x4(%eax),%eax
  802dd5:	a3 30 50 80 00       	mov    %eax,0x805030
  802dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ddd:	8b 40 04             	mov    0x4(%eax),%eax
  802de0:	85 c0                	test   %eax,%eax
  802de2:	74 0f                	je     802df3 <merging+0x105>
  802de4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de7:	8b 40 04             	mov    0x4(%eax),%eax
  802dea:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ded:	8b 12                	mov    (%edx),%edx
  802def:	89 10                	mov    %edx,(%eax)
  802df1:	eb 0a                	jmp    802dfd <merging+0x10f>
  802df3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df6:	8b 00                	mov    (%eax),%eax
  802df8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e09:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e10:	a1 38 50 80 00       	mov    0x805038,%eax
  802e15:	48                   	dec    %eax
  802e16:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e1b:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e1c:	e9 ea 02 00 00       	jmp    80310b <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e25:	74 3b                	je     802e62 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802e27:	83 ec 0c             	sub    $0xc,%esp
  802e2a:	ff 75 08             	pushl  0x8(%ebp)
  802e2d:	e8 be f0 ff ff       	call   801ef0 <get_block_size>
  802e32:	83 c4 10             	add    $0x10,%esp
  802e35:	89 c3                	mov    %eax,%ebx
  802e37:	83 ec 0c             	sub    $0xc,%esp
  802e3a:	ff 75 10             	pushl  0x10(%ebp)
  802e3d:	e8 ae f0 ff ff       	call   801ef0 <get_block_size>
  802e42:	83 c4 10             	add    $0x10,%esp
  802e45:	01 d8                	add    %ebx,%eax
  802e47:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e4a:	83 ec 04             	sub    $0x4,%esp
  802e4d:	6a 00                	push   $0x0
  802e4f:	ff 75 e8             	pushl  -0x18(%ebp)
  802e52:	ff 75 08             	pushl  0x8(%ebp)
  802e55:	e8 e7 f3 ff ff       	call   802241 <set_block_data>
  802e5a:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e5d:	e9 a9 02 00 00       	jmp    80310b <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802e62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e66:	0f 84 2d 01 00 00    	je     802f99 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802e6c:	83 ec 0c             	sub    $0xc,%esp
  802e6f:	ff 75 10             	pushl  0x10(%ebp)
  802e72:	e8 79 f0 ff ff       	call   801ef0 <get_block_size>
  802e77:	83 c4 10             	add    $0x10,%esp
  802e7a:	89 c3                	mov    %eax,%ebx
  802e7c:	83 ec 0c             	sub    $0xc,%esp
  802e7f:	ff 75 0c             	pushl  0xc(%ebp)
  802e82:	e8 69 f0 ff ff       	call   801ef0 <get_block_size>
  802e87:	83 c4 10             	add    $0x10,%esp
  802e8a:	01 d8                	add    %ebx,%eax
  802e8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802e8f:	83 ec 04             	sub    $0x4,%esp
  802e92:	6a 00                	push   $0x0
  802e94:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e97:	ff 75 10             	pushl  0x10(%ebp)
  802e9a:	e8 a2 f3 ff ff       	call   802241 <set_block_data>
  802e9f:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802ea2:	8b 45 10             	mov    0x10(%ebp),%eax
  802ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802ea8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802eac:	74 06                	je     802eb4 <merging+0x1c6>
  802eae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802eb2:	75 17                	jne    802ecb <merging+0x1dd>
  802eb4:	83 ec 04             	sub    $0x4,%esp
  802eb7:	68 c8 45 80 00       	push   $0x8045c8
  802ebc:	68 8d 01 00 00       	push   $0x18d
  802ec1:	68 21 45 80 00       	push   $0x804521
  802ec6:	e8 d6 d3 ff ff       	call   8002a1 <_panic>
  802ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ece:	8b 50 04             	mov    0x4(%eax),%edx
  802ed1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed4:	89 50 04             	mov    %edx,0x4(%eax)
  802ed7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eda:	8b 55 0c             	mov    0xc(%ebp),%edx
  802edd:	89 10                	mov    %edx,(%eax)
  802edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee2:	8b 40 04             	mov    0x4(%eax),%eax
  802ee5:	85 c0                	test   %eax,%eax
  802ee7:	74 0d                	je     802ef6 <merging+0x208>
  802ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eec:	8b 40 04             	mov    0x4(%eax),%eax
  802eef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ef2:	89 10                	mov    %edx,(%eax)
  802ef4:	eb 08                	jmp    802efe <merging+0x210>
  802ef6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ef9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802efe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f01:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f04:	89 50 04             	mov    %edx,0x4(%eax)
  802f07:	a1 38 50 80 00       	mov    0x805038,%eax
  802f0c:	40                   	inc    %eax
  802f0d:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802f12:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f16:	75 17                	jne    802f2f <merging+0x241>
  802f18:	83 ec 04             	sub    $0x4,%esp
  802f1b:	68 03 45 80 00       	push   $0x804503
  802f20:	68 8e 01 00 00       	push   $0x18e
  802f25:	68 21 45 80 00       	push   $0x804521
  802f2a:	e8 72 d3 ff ff       	call   8002a1 <_panic>
  802f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f32:	8b 00                	mov    (%eax),%eax
  802f34:	85 c0                	test   %eax,%eax
  802f36:	74 10                	je     802f48 <merging+0x25a>
  802f38:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f3b:	8b 00                	mov    (%eax),%eax
  802f3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f40:	8b 52 04             	mov    0x4(%edx),%edx
  802f43:	89 50 04             	mov    %edx,0x4(%eax)
  802f46:	eb 0b                	jmp    802f53 <merging+0x265>
  802f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4b:	8b 40 04             	mov    0x4(%eax),%eax
  802f4e:	a3 30 50 80 00       	mov    %eax,0x805030
  802f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f56:	8b 40 04             	mov    0x4(%eax),%eax
  802f59:	85 c0                	test   %eax,%eax
  802f5b:	74 0f                	je     802f6c <merging+0x27e>
  802f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f60:	8b 40 04             	mov    0x4(%eax),%eax
  802f63:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f66:	8b 12                	mov    (%edx),%edx
  802f68:	89 10                	mov    %edx,(%eax)
  802f6a:	eb 0a                	jmp    802f76 <merging+0x288>
  802f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f6f:	8b 00                	mov    (%eax),%eax
  802f71:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f89:	a1 38 50 80 00       	mov    0x805038,%eax
  802f8e:	48                   	dec    %eax
  802f8f:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f94:	e9 72 01 00 00       	jmp    80310b <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802f99:	8b 45 10             	mov    0x10(%ebp),%eax
  802f9c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802f9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fa3:	74 79                	je     80301e <merging+0x330>
  802fa5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fa9:	74 73                	je     80301e <merging+0x330>
  802fab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802faf:	74 06                	je     802fb7 <merging+0x2c9>
  802fb1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fb5:	75 17                	jne    802fce <merging+0x2e0>
  802fb7:	83 ec 04             	sub    $0x4,%esp
  802fba:	68 94 45 80 00       	push   $0x804594
  802fbf:	68 94 01 00 00       	push   $0x194
  802fc4:	68 21 45 80 00       	push   $0x804521
  802fc9:	e8 d3 d2 ff ff       	call   8002a1 <_panic>
  802fce:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd1:	8b 10                	mov    (%eax),%edx
  802fd3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fd6:	89 10                	mov    %edx,(%eax)
  802fd8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fdb:	8b 00                	mov    (%eax),%eax
  802fdd:	85 c0                	test   %eax,%eax
  802fdf:	74 0b                	je     802fec <merging+0x2fe>
  802fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe4:	8b 00                	mov    (%eax),%eax
  802fe6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fe9:	89 50 04             	mov    %edx,0x4(%eax)
  802fec:	8b 45 08             	mov    0x8(%ebp),%eax
  802fef:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ff2:	89 10                	mov    %edx,(%eax)
  802ff4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ff7:	8b 55 08             	mov    0x8(%ebp),%edx
  802ffa:	89 50 04             	mov    %edx,0x4(%eax)
  802ffd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803000:	8b 00                	mov    (%eax),%eax
  803002:	85 c0                	test   %eax,%eax
  803004:	75 08                	jne    80300e <merging+0x320>
  803006:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803009:	a3 30 50 80 00       	mov    %eax,0x805030
  80300e:	a1 38 50 80 00       	mov    0x805038,%eax
  803013:	40                   	inc    %eax
  803014:	a3 38 50 80 00       	mov    %eax,0x805038
  803019:	e9 ce 00 00 00       	jmp    8030ec <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80301e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803022:	74 65                	je     803089 <merging+0x39b>
  803024:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803028:	75 17                	jne    803041 <merging+0x353>
  80302a:	83 ec 04             	sub    $0x4,%esp
  80302d:	68 70 45 80 00       	push   $0x804570
  803032:	68 95 01 00 00       	push   $0x195
  803037:	68 21 45 80 00       	push   $0x804521
  80303c:	e8 60 d2 ff ff       	call   8002a1 <_panic>
  803041:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803047:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80304a:	89 50 04             	mov    %edx,0x4(%eax)
  80304d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803050:	8b 40 04             	mov    0x4(%eax),%eax
  803053:	85 c0                	test   %eax,%eax
  803055:	74 0c                	je     803063 <merging+0x375>
  803057:	a1 30 50 80 00       	mov    0x805030,%eax
  80305c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80305f:	89 10                	mov    %edx,(%eax)
  803061:	eb 08                	jmp    80306b <merging+0x37d>
  803063:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803066:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80306b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80306e:	a3 30 50 80 00       	mov    %eax,0x805030
  803073:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803076:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80307c:	a1 38 50 80 00       	mov    0x805038,%eax
  803081:	40                   	inc    %eax
  803082:	a3 38 50 80 00       	mov    %eax,0x805038
  803087:	eb 63                	jmp    8030ec <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803089:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80308d:	75 17                	jne    8030a6 <merging+0x3b8>
  80308f:	83 ec 04             	sub    $0x4,%esp
  803092:	68 3c 45 80 00       	push   $0x80453c
  803097:	68 98 01 00 00       	push   $0x198
  80309c:	68 21 45 80 00       	push   $0x804521
  8030a1:	e8 fb d1 ff ff       	call   8002a1 <_panic>
  8030a6:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8030ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030af:	89 10                	mov    %edx,(%eax)
  8030b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030b4:	8b 00                	mov    (%eax),%eax
  8030b6:	85 c0                	test   %eax,%eax
  8030b8:	74 0d                	je     8030c7 <merging+0x3d9>
  8030ba:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030bf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030c2:	89 50 04             	mov    %edx,0x4(%eax)
  8030c5:	eb 08                	jmp    8030cf <merging+0x3e1>
  8030c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ca:	a3 30 50 80 00       	mov    %eax,0x805030
  8030cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030d2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e1:	a1 38 50 80 00       	mov    0x805038,%eax
  8030e6:	40                   	inc    %eax
  8030e7:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8030ec:	83 ec 0c             	sub    $0xc,%esp
  8030ef:	ff 75 10             	pushl  0x10(%ebp)
  8030f2:	e8 f9 ed ff ff       	call   801ef0 <get_block_size>
  8030f7:	83 c4 10             	add    $0x10,%esp
  8030fa:	83 ec 04             	sub    $0x4,%esp
  8030fd:	6a 00                	push   $0x0
  8030ff:	50                   	push   %eax
  803100:	ff 75 10             	pushl  0x10(%ebp)
  803103:	e8 39 f1 ff ff       	call   802241 <set_block_data>
  803108:	83 c4 10             	add    $0x10,%esp
	}
}
  80310b:	90                   	nop
  80310c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80310f:	c9                   	leave  
  803110:	c3                   	ret    

00803111 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803111:	55                   	push   %ebp
  803112:	89 e5                	mov    %esp,%ebp
  803114:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803117:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80311c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80311f:	a1 30 50 80 00       	mov    0x805030,%eax
  803124:	3b 45 08             	cmp    0x8(%ebp),%eax
  803127:	73 1b                	jae    803144 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803129:	a1 30 50 80 00       	mov    0x805030,%eax
  80312e:	83 ec 04             	sub    $0x4,%esp
  803131:	ff 75 08             	pushl  0x8(%ebp)
  803134:	6a 00                	push   $0x0
  803136:	50                   	push   %eax
  803137:	e8 b2 fb ff ff       	call   802cee <merging>
  80313c:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80313f:	e9 8b 00 00 00       	jmp    8031cf <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803144:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803149:	3b 45 08             	cmp    0x8(%ebp),%eax
  80314c:	76 18                	jbe    803166 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80314e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803153:	83 ec 04             	sub    $0x4,%esp
  803156:	ff 75 08             	pushl  0x8(%ebp)
  803159:	50                   	push   %eax
  80315a:	6a 00                	push   $0x0
  80315c:	e8 8d fb ff ff       	call   802cee <merging>
  803161:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803164:	eb 69                	jmp    8031cf <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803166:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80316b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80316e:	eb 39                	jmp    8031a9 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803173:	3b 45 08             	cmp    0x8(%ebp),%eax
  803176:	73 29                	jae    8031a1 <free_block+0x90>
  803178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317b:	8b 00                	mov    (%eax),%eax
  80317d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803180:	76 1f                	jbe    8031a1 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803185:	8b 00                	mov    (%eax),%eax
  803187:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80318a:	83 ec 04             	sub    $0x4,%esp
  80318d:	ff 75 08             	pushl  0x8(%ebp)
  803190:	ff 75 f0             	pushl  -0x10(%ebp)
  803193:	ff 75 f4             	pushl  -0xc(%ebp)
  803196:	e8 53 fb ff ff       	call   802cee <merging>
  80319b:	83 c4 10             	add    $0x10,%esp
			break;
  80319e:	90                   	nop
		}
	}
}
  80319f:	eb 2e                	jmp    8031cf <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031a1:	a1 34 50 80 00       	mov    0x805034,%eax
  8031a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031ad:	74 07                	je     8031b6 <free_block+0xa5>
  8031af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b2:	8b 00                	mov    (%eax),%eax
  8031b4:	eb 05                	jmp    8031bb <free_block+0xaa>
  8031b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8031bb:	a3 34 50 80 00       	mov    %eax,0x805034
  8031c0:	a1 34 50 80 00       	mov    0x805034,%eax
  8031c5:	85 c0                	test   %eax,%eax
  8031c7:	75 a7                	jne    803170 <free_block+0x5f>
  8031c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031cd:	75 a1                	jne    803170 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031cf:	90                   	nop
  8031d0:	c9                   	leave  
  8031d1:	c3                   	ret    

008031d2 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8031d2:	55                   	push   %ebp
  8031d3:	89 e5                	mov    %esp,%ebp
  8031d5:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8031d8:	ff 75 08             	pushl  0x8(%ebp)
  8031db:	e8 10 ed ff ff       	call   801ef0 <get_block_size>
  8031e0:	83 c4 04             	add    $0x4,%esp
  8031e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8031e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8031ed:	eb 17                	jmp    803206 <copy_data+0x34>
  8031ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8031f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031f5:	01 c2                	add    %eax,%edx
  8031f7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8031fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fd:	01 c8                	add    %ecx,%eax
  8031ff:	8a 00                	mov    (%eax),%al
  803201:	88 02                	mov    %al,(%edx)
  803203:	ff 45 fc             	incl   -0x4(%ebp)
  803206:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803209:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80320c:	72 e1                	jb     8031ef <copy_data+0x1d>
}
  80320e:	90                   	nop
  80320f:	c9                   	leave  
  803210:	c3                   	ret    

00803211 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803211:	55                   	push   %ebp
  803212:	89 e5                	mov    %esp,%ebp
  803214:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803217:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80321b:	75 23                	jne    803240 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80321d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803221:	74 13                	je     803236 <realloc_block_FF+0x25>
  803223:	83 ec 0c             	sub    $0xc,%esp
  803226:	ff 75 0c             	pushl  0xc(%ebp)
  803229:	e8 42 f0 ff ff       	call   802270 <alloc_block_FF>
  80322e:	83 c4 10             	add    $0x10,%esp
  803231:	e9 e4 06 00 00       	jmp    80391a <realloc_block_FF+0x709>
		return NULL;
  803236:	b8 00 00 00 00       	mov    $0x0,%eax
  80323b:	e9 da 06 00 00       	jmp    80391a <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803240:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803244:	75 18                	jne    80325e <realloc_block_FF+0x4d>
	{
		free_block(va);
  803246:	83 ec 0c             	sub    $0xc,%esp
  803249:	ff 75 08             	pushl  0x8(%ebp)
  80324c:	e8 c0 fe ff ff       	call   803111 <free_block>
  803251:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803254:	b8 00 00 00 00       	mov    $0x0,%eax
  803259:	e9 bc 06 00 00       	jmp    80391a <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  80325e:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803262:	77 07                	ja     80326b <realloc_block_FF+0x5a>
  803264:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80326b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80326e:	83 e0 01             	and    $0x1,%eax
  803271:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803274:	8b 45 0c             	mov    0xc(%ebp),%eax
  803277:	83 c0 08             	add    $0x8,%eax
  80327a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80327d:	83 ec 0c             	sub    $0xc,%esp
  803280:	ff 75 08             	pushl  0x8(%ebp)
  803283:	e8 68 ec ff ff       	call   801ef0 <get_block_size>
  803288:	83 c4 10             	add    $0x10,%esp
  80328b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80328e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803291:	83 e8 08             	sub    $0x8,%eax
  803294:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803297:	8b 45 08             	mov    0x8(%ebp),%eax
  80329a:	83 e8 04             	sub    $0x4,%eax
  80329d:	8b 00                	mov    (%eax),%eax
  80329f:	83 e0 fe             	and    $0xfffffffe,%eax
  8032a2:	89 c2                	mov    %eax,%edx
  8032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a7:	01 d0                	add    %edx,%eax
  8032a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8032ac:	83 ec 0c             	sub    $0xc,%esp
  8032af:	ff 75 e4             	pushl  -0x1c(%ebp)
  8032b2:	e8 39 ec ff ff       	call   801ef0 <get_block_size>
  8032b7:	83 c4 10             	add    $0x10,%esp
  8032ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032c0:	83 e8 08             	sub    $0x8,%eax
  8032c3:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8032c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032cc:	75 08                	jne    8032d6 <realloc_block_FF+0xc5>
	{
		 return va;
  8032ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d1:	e9 44 06 00 00       	jmp    80391a <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  8032d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032d9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032dc:	0f 83 d5 03 00 00    	jae    8036b7 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8032e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e5:	2b 45 0c             	sub    0xc(%ebp),%eax
  8032e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8032eb:	83 ec 0c             	sub    $0xc,%esp
  8032ee:	ff 75 e4             	pushl  -0x1c(%ebp)
  8032f1:	e8 13 ec ff ff       	call   801f09 <is_free_block>
  8032f6:	83 c4 10             	add    $0x10,%esp
  8032f9:	84 c0                	test   %al,%al
  8032fb:	0f 84 3b 01 00 00    	je     80343c <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803301:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803304:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803307:	01 d0                	add    %edx,%eax
  803309:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80330c:	83 ec 04             	sub    $0x4,%esp
  80330f:	6a 01                	push   $0x1
  803311:	ff 75 f0             	pushl  -0x10(%ebp)
  803314:	ff 75 08             	pushl  0x8(%ebp)
  803317:	e8 25 ef ff ff       	call   802241 <set_block_data>
  80331c:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80331f:	8b 45 08             	mov    0x8(%ebp),%eax
  803322:	83 e8 04             	sub    $0x4,%eax
  803325:	8b 00                	mov    (%eax),%eax
  803327:	83 e0 fe             	and    $0xfffffffe,%eax
  80332a:	89 c2                	mov    %eax,%edx
  80332c:	8b 45 08             	mov    0x8(%ebp),%eax
  80332f:	01 d0                	add    %edx,%eax
  803331:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803334:	83 ec 04             	sub    $0x4,%esp
  803337:	6a 00                	push   $0x0
  803339:	ff 75 cc             	pushl  -0x34(%ebp)
  80333c:	ff 75 c8             	pushl  -0x38(%ebp)
  80333f:	e8 fd ee ff ff       	call   802241 <set_block_data>
  803344:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803347:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80334b:	74 06                	je     803353 <realloc_block_FF+0x142>
  80334d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803351:	75 17                	jne    80336a <realloc_block_FF+0x159>
  803353:	83 ec 04             	sub    $0x4,%esp
  803356:	68 94 45 80 00       	push   $0x804594
  80335b:	68 f6 01 00 00       	push   $0x1f6
  803360:	68 21 45 80 00       	push   $0x804521
  803365:	e8 37 cf ff ff       	call   8002a1 <_panic>
  80336a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80336d:	8b 10                	mov    (%eax),%edx
  80336f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803372:	89 10                	mov    %edx,(%eax)
  803374:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803377:	8b 00                	mov    (%eax),%eax
  803379:	85 c0                	test   %eax,%eax
  80337b:	74 0b                	je     803388 <realloc_block_FF+0x177>
  80337d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803380:	8b 00                	mov    (%eax),%eax
  803382:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803385:	89 50 04             	mov    %edx,0x4(%eax)
  803388:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80338b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80338e:	89 10                	mov    %edx,(%eax)
  803390:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803393:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803396:	89 50 04             	mov    %edx,0x4(%eax)
  803399:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80339c:	8b 00                	mov    (%eax),%eax
  80339e:	85 c0                	test   %eax,%eax
  8033a0:	75 08                	jne    8033aa <realloc_block_FF+0x199>
  8033a2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033a5:	a3 30 50 80 00       	mov    %eax,0x805030
  8033aa:	a1 38 50 80 00       	mov    0x805038,%eax
  8033af:	40                   	inc    %eax
  8033b0:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8033b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033b9:	75 17                	jne    8033d2 <realloc_block_FF+0x1c1>
  8033bb:	83 ec 04             	sub    $0x4,%esp
  8033be:	68 03 45 80 00       	push   $0x804503
  8033c3:	68 f7 01 00 00       	push   $0x1f7
  8033c8:	68 21 45 80 00       	push   $0x804521
  8033cd:	e8 cf ce ff ff       	call   8002a1 <_panic>
  8033d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033d5:	8b 00                	mov    (%eax),%eax
  8033d7:	85 c0                	test   %eax,%eax
  8033d9:	74 10                	je     8033eb <realloc_block_FF+0x1da>
  8033db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033de:	8b 00                	mov    (%eax),%eax
  8033e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033e3:	8b 52 04             	mov    0x4(%edx),%edx
  8033e6:	89 50 04             	mov    %edx,0x4(%eax)
  8033e9:	eb 0b                	jmp    8033f6 <realloc_block_FF+0x1e5>
  8033eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ee:	8b 40 04             	mov    0x4(%eax),%eax
  8033f1:	a3 30 50 80 00       	mov    %eax,0x805030
  8033f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f9:	8b 40 04             	mov    0x4(%eax),%eax
  8033fc:	85 c0                	test   %eax,%eax
  8033fe:	74 0f                	je     80340f <realloc_block_FF+0x1fe>
  803400:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803403:	8b 40 04             	mov    0x4(%eax),%eax
  803406:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803409:	8b 12                	mov    (%edx),%edx
  80340b:	89 10                	mov    %edx,(%eax)
  80340d:	eb 0a                	jmp    803419 <realloc_block_FF+0x208>
  80340f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803412:	8b 00                	mov    (%eax),%eax
  803414:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803419:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80341c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803422:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803425:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80342c:	a1 38 50 80 00       	mov    0x805038,%eax
  803431:	48                   	dec    %eax
  803432:	a3 38 50 80 00       	mov    %eax,0x805038
  803437:	e9 73 02 00 00       	jmp    8036af <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  80343c:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803440:	0f 86 69 02 00 00    	jbe    8036af <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803446:	83 ec 04             	sub    $0x4,%esp
  803449:	6a 01                	push   $0x1
  80344b:	ff 75 f0             	pushl  -0x10(%ebp)
  80344e:	ff 75 08             	pushl  0x8(%ebp)
  803451:	e8 eb ed ff ff       	call   802241 <set_block_data>
  803456:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803459:	8b 45 08             	mov    0x8(%ebp),%eax
  80345c:	83 e8 04             	sub    $0x4,%eax
  80345f:	8b 00                	mov    (%eax),%eax
  803461:	83 e0 fe             	and    $0xfffffffe,%eax
  803464:	89 c2                	mov    %eax,%edx
  803466:	8b 45 08             	mov    0x8(%ebp),%eax
  803469:	01 d0                	add    %edx,%eax
  80346b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80346e:	a1 38 50 80 00       	mov    0x805038,%eax
  803473:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803476:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80347a:	75 68                	jne    8034e4 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80347c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803480:	75 17                	jne    803499 <realloc_block_FF+0x288>
  803482:	83 ec 04             	sub    $0x4,%esp
  803485:	68 3c 45 80 00       	push   $0x80453c
  80348a:	68 06 02 00 00       	push   $0x206
  80348f:	68 21 45 80 00       	push   $0x804521
  803494:	e8 08 ce ff ff       	call   8002a1 <_panic>
  803499:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80349f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034a2:	89 10                	mov    %edx,(%eax)
  8034a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034a7:	8b 00                	mov    (%eax),%eax
  8034a9:	85 c0                	test   %eax,%eax
  8034ab:	74 0d                	je     8034ba <realloc_block_FF+0x2a9>
  8034ad:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034b2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034b5:	89 50 04             	mov    %edx,0x4(%eax)
  8034b8:	eb 08                	jmp    8034c2 <realloc_block_FF+0x2b1>
  8034ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034bd:	a3 30 50 80 00       	mov    %eax,0x805030
  8034c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d4:	a1 38 50 80 00       	mov    0x805038,%eax
  8034d9:	40                   	inc    %eax
  8034da:	a3 38 50 80 00       	mov    %eax,0x805038
  8034df:	e9 b0 01 00 00       	jmp    803694 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8034e4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034e9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034ec:	76 68                	jbe    803556 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034ee:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034f2:	75 17                	jne    80350b <realloc_block_FF+0x2fa>
  8034f4:	83 ec 04             	sub    $0x4,%esp
  8034f7:	68 3c 45 80 00       	push   $0x80453c
  8034fc:	68 0b 02 00 00       	push   $0x20b
  803501:	68 21 45 80 00       	push   $0x804521
  803506:	e8 96 cd ff ff       	call   8002a1 <_panic>
  80350b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803511:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803514:	89 10                	mov    %edx,(%eax)
  803516:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803519:	8b 00                	mov    (%eax),%eax
  80351b:	85 c0                	test   %eax,%eax
  80351d:	74 0d                	je     80352c <realloc_block_FF+0x31b>
  80351f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803524:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803527:	89 50 04             	mov    %edx,0x4(%eax)
  80352a:	eb 08                	jmp    803534 <realloc_block_FF+0x323>
  80352c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80352f:	a3 30 50 80 00       	mov    %eax,0x805030
  803534:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803537:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80353c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80353f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803546:	a1 38 50 80 00       	mov    0x805038,%eax
  80354b:	40                   	inc    %eax
  80354c:	a3 38 50 80 00       	mov    %eax,0x805038
  803551:	e9 3e 01 00 00       	jmp    803694 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803556:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80355b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80355e:	73 68                	jae    8035c8 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803560:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803564:	75 17                	jne    80357d <realloc_block_FF+0x36c>
  803566:	83 ec 04             	sub    $0x4,%esp
  803569:	68 70 45 80 00       	push   $0x804570
  80356e:	68 10 02 00 00       	push   $0x210
  803573:	68 21 45 80 00       	push   $0x804521
  803578:	e8 24 cd ff ff       	call   8002a1 <_panic>
  80357d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803583:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803586:	89 50 04             	mov    %edx,0x4(%eax)
  803589:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80358c:	8b 40 04             	mov    0x4(%eax),%eax
  80358f:	85 c0                	test   %eax,%eax
  803591:	74 0c                	je     80359f <realloc_block_FF+0x38e>
  803593:	a1 30 50 80 00       	mov    0x805030,%eax
  803598:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80359b:	89 10                	mov    %edx,(%eax)
  80359d:	eb 08                	jmp    8035a7 <realloc_block_FF+0x396>
  80359f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035aa:	a3 30 50 80 00       	mov    %eax,0x805030
  8035af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035b8:	a1 38 50 80 00       	mov    0x805038,%eax
  8035bd:	40                   	inc    %eax
  8035be:	a3 38 50 80 00       	mov    %eax,0x805038
  8035c3:	e9 cc 00 00 00       	jmp    803694 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8035c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8035cf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035d7:	e9 8a 00 00 00       	jmp    803666 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8035dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035df:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035e2:	73 7a                	jae    80365e <realloc_block_FF+0x44d>
  8035e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e7:	8b 00                	mov    (%eax),%eax
  8035e9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035ec:	73 70                	jae    80365e <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8035ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035f2:	74 06                	je     8035fa <realloc_block_FF+0x3e9>
  8035f4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035f8:	75 17                	jne    803611 <realloc_block_FF+0x400>
  8035fa:	83 ec 04             	sub    $0x4,%esp
  8035fd:	68 94 45 80 00       	push   $0x804594
  803602:	68 1a 02 00 00       	push   $0x21a
  803607:	68 21 45 80 00       	push   $0x804521
  80360c:	e8 90 cc ff ff       	call   8002a1 <_panic>
  803611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803614:	8b 10                	mov    (%eax),%edx
  803616:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803619:	89 10                	mov    %edx,(%eax)
  80361b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80361e:	8b 00                	mov    (%eax),%eax
  803620:	85 c0                	test   %eax,%eax
  803622:	74 0b                	je     80362f <realloc_block_FF+0x41e>
  803624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803627:	8b 00                	mov    (%eax),%eax
  803629:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80362c:	89 50 04             	mov    %edx,0x4(%eax)
  80362f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803632:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803635:	89 10                	mov    %edx,(%eax)
  803637:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80363a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80363d:	89 50 04             	mov    %edx,0x4(%eax)
  803640:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803643:	8b 00                	mov    (%eax),%eax
  803645:	85 c0                	test   %eax,%eax
  803647:	75 08                	jne    803651 <realloc_block_FF+0x440>
  803649:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80364c:	a3 30 50 80 00       	mov    %eax,0x805030
  803651:	a1 38 50 80 00       	mov    0x805038,%eax
  803656:	40                   	inc    %eax
  803657:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80365c:	eb 36                	jmp    803694 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80365e:	a1 34 50 80 00       	mov    0x805034,%eax
  803663:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803666:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80366a:	74 07                	je     803673 <realloc_block_FF+0x462>
  80366c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366f:	8b 00                	mov    (%eax),%eax
  803671:	eb 05                	jmp    803678 <realloc_block_FF+0x467>
  803673:	b8 00 00 00 00       	mov    $0x0,%eax
  803678:	a3 34 50 80 00       	mov    %eax,0x805034
  80367d:	a1 34 50 80 00       	mov    0x805034,%eax
  803682:	85 c0                	test   %eax,%eax
  803684:	0f 85 52 ff ff ff    	jne    8035dc <realloc_block_FF+0x3cb>
  80368a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80368e:	0f 85 48 ff ff ff    	jne    8035dc <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803694:	83 ec 04             	sub    $0x4,%esp
  803697:	6a 00                	push   $0x0
  803699:	ff 75 d8             	pushl  -0x28(%ebp)
  80369c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80369f:	e8 9d eb ff ff       	call   802241 <set_block_data>
  8036a4:	83 c4 10             	add    $0x10,%esp
				return va;
  8036a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036aa:	e9 6b 02 00 00       	jmp    80391a <realloc_block_FF+0x709>
			}
			
		}
		return va;
  8036af:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b2:	e9 63 02 00 00       	jmp    80391a <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  8036b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ba:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8036bd:	0f 86 4d 02 00 00    	jbe    803910 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  8036c3:	83 ec 0c             	sub    $0xc,%esp
  8036c6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036c9:	e8 3b e8 ff ff       	call   801f09 <is_free_block>
  8036ce:	83 c4 10             	add    $0x10,%esp
  8036d1:	84 c0                	test   %al,%al
  8036d3:	0f 84 37 02 00 00    	je     803910 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8036d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036dc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8036df:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8036e2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8036e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8036e8:	76 38                	jbe    803722 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  8036ea:	83 ec 0c             	sub    $0xc,%esp
  8036ed:	ff 75 0c             	pushl  0xc(%ebp)
  8036f0:	e8 7b eb ff ff       	call   802270 <alloc_block_FF>
  8036f5:	83 c4 10             	add    $0x10,%esp
  8036f8:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8036fb:	83 ec 08             	sub    $0x8,%esp
  8036fe:	ff 75 c0             	pushl  -0x40(%ebp)
  803701:	ff 75 08             	pushl  0x8(%ebp)
  803704:	e8 c9 fa ff ff       	call   8031d2 <copy_data>
  803709:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  80370c:	83 ec 0c             	sub    $0xc,%esp
  80370f:	ff 75 08             	pushl  0x8(%ebp)
  803712:	e8 fa f9 ff ff       	call   803111 <free_block>
  803717:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80371a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80371d:	e9 f8 01 00 00       	jmp    80391a <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803722:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803725:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803728:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80372b:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80372f:	0f 87 a0 00 00 00    	ja     8037d5 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803735:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803739:	75 17                	jne    803752 <realloc_block_FF+0x541>
  80373b:	83 ec 04             	sub    $0x4,%esp
  80373e:	68 03 45 80 00       	push   $0x804503
  803743:	68 38 02 00 00       	push   $0x238
  803748:	68 21 45 80 00       	push   $0x804521
  80374d:	e8 4f cb ff ff       	call   8002a1 <_panic>
  803752:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803755:	8b 00                	mov    (%eax),%eax
  803757:	85 c0                	test   %eax,%eax
  803759:	74 10                	je     80376b <realloc_block_FF+0x55a>
  80375b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80375e:	8b 00                	mov    (%eax),%eax
  803760:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803763:	8b 52 04             	mov    0x4(%edx),%edx
  803766:	89 50 04             	mov    %edx,0x4(%eax)
  803769:	eb 0b                	jmp    803776 <realloc_block_FF+0x565>
  80376b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80376e:	8b 40 04             	mov    0x4(%eax),%eax
  803771:	a3 30 50 80 00       	mov    %eax,0x805030
  803776:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803779:	8b 40 04             	mov    0x4(%eax),%eax
  80377c:	85 c0                	test   %eax,%eax
  80377e:	74 0f                	je     80378f <realloc_block_FF+0x57e>
  803780:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803783:	8b 40 04             	mov    0x4(%eax),%eax
  803786:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803789:	8b 12                	mov    (%edx),%edx
  80378b:	89 10                	mov    %edx,(%eax)
  80378d:	eb 0a                	jmp    803799 <realloc_block_FF+0x588>
  80378f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803792:	8b 00                	mov    (%eax),%eax
  803794:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803799:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037ac:	a1 38 50 80 00       	mov    0x805038,%eax
  8037b1:	48                   	dec    %eax
  8037b2:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8037b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037bd:	01 d0                	add    %edx,%eax
  8037bf:	83 ec 04             	sub    $0x4,%esp
  8037c2:	6a 01                	push   $0x1
  8037c4:	50                   	push   %eax
  8037c5:	ff 75 08             	pushl  0x8(%ebp)
  8037c8:	e8 74 ea ff ff       	call   802241 <set_block_data>
  8037cd:	83 c4 10             	add    $0x10,%esp
  8037d0:	e9 36 01 00 00       	jmp    80390b <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8037d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037d8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037db:	01 d0                	add    %edx,%eax
  8037dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8037e0:	83 ec 04             	sub    $0x4,%esp
  8037e3:	6a 01                	push   $0x1
  8037e5:	ff 75 f0             	pushl  -0x10(%ebp)
  8037e8:	ff 75 08             	pushl  0x8(%ebp)
  8037eb:	e8 51 ea ff ff       	call   802241 <set_block_data>
  8037f0:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8037f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f6:	83 e8 04             	sub    $0x4,%eax
  8037f9:	8b 00                	mov    (%eax),%eax
  8037fb:	83 e0 fe             	and    $0xfffffffe,%eax
  8037fe:	89 c2                	mov    %eax,%edx
  803800:	8b 45 08             	mov    0x8(%ebp),%eax
  803803:	01 d0                	add    %edx,%eax
  803805:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803808:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80380c:	74 06                	je     803814 <realloc_block_FF+0x603>
  80380e:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803812:	75 17                	jne    80382b <realloc_block_FF+0x61a>
  803814:	83 ec 04             	sub    $0x4,%esp
  803817:	68 94 45 80 00       	push   $0x804594
  80381c:	68 44 02 00 00       	push   $0x244
  803821:	68 21 45 80 00       	push   $0x804521
  803826:	e8 76 ca ff ff       	call   8002a1 <_panic>
  80382b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382e:	8b 10                	mov    (%eax),%edx
  803830:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803833:	89 10                	mov    %edx,(%eax)
  803835:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803838:	8b 00                	mov    (%eax),%eax
  80383a:	85 c0                	test   %eax,%eax
  80383c:	74 0b                	je     803849 <realloc_block_FF+0x638>
  80383e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803841:	8b 00                	mov    (%eax),%eax
  803843:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803846:	89 50 04             	mov    %edx,0x4(%eax)
  803849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384c:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80384f:	89 10                	mov    %edx,(%eax)
  803851:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803854:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803857:	89 50 04             	mov    %edx,0x4(%eax)
  80385a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80385d:	8b 00                	mov    (%eax),%eax
  80385f:	85 c0                	test   %eax,%eax
  803861:	75 08                	jne    80386b <realloc_block_FF+0x65a>
  803863:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803866:	a3 30 50 80 00       	mov    %eax,0x805030
  80386b:	a1 38 50 80 00       	mov    0x805038,%eax
  803870:	40                   	inc    %eax
  803871:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803876:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80387a:	75 17                	jne    803893 <realloc_block_FF+0x682>
  80387c:	83 ec 04             	sub    $0x4,%esp
  80387f:	68 03 45 80 00       	push   $0x804503
  803884:	68 45 02 00 00       	push   $0x245
  803889:	68 21 45 80 00       	push   $0x804521
  80388e:	e8 0e ca ff ff       	call   8002a1 <_panic>
  803893:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803896:	8b 00                	mov    (%eax),%eax
  803898:	85 c0                	test   %eax,%eax
  80389a:	74 10                	je     8038ac <realloc_block_FF+0x69b>
  80389c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389f:	8b 00                	mov    (%eax),%eax
  8038a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038a4:	8b 52 04             	mov    0x4(%edx),%edx
  8038a7:	89 50 04             	mov    %edx,0x4(%eax)
  8038aa:	eb 0b                	jmp    8038b7 <realloc_block_FF+0x6a6>
  8038ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038af:	8b 40 04             	mov    0x4(%eax),%eax
  8038b2:	a3 30 50 80 00       	mov    %eax,0x805030
  8038b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ba:	8b 40 04             	mov    0x4(%eax),%eax
  8038bd:	85 c0                	test   %eax,%eax
  8038bf:	74 0f                	je     8038d0 <realloc_block_FF+0x6bf>
  8038c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c4:	8b 40 04             	mov    0x4(%eax),%eax
  8038c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038ca:	8b 12                	mov    (%edx),%edx
  8038cc:	89 10                	mov    %edx,(%eax)
  8038ce:	eb 0a                	jmp    8038da <realloc_block_FF+0x6c9>
  8038d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d3:	8b 00                	mov    (%eax),%eax
  8038d5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038ed:	a1 38 50 80 00       	mov    0x805038,%eax
  8038f2:	48                   	dec    %eax
  8038f3:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8038f8:	83 ec 04             	sub    $0x4,%esp
  8038fb:	6a 00                	push   $0x0
  8038fd:	ff 75 bc             	pushl  -0x44(%ebp)
  803900:	ff 75 b8             	pushl  -0x48(%ebp)
  803903:	e8 39 e9 ff ff       	call   802241 <set_block_data>
  803908:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80390b:	8b 45 08             	mov    0x8(%ebp),%eax
  80390e:	eb 0a                	jmp    80391a <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803910:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803917:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80391a:	c9                   	leave  
  80391b:	c3                   	ret    

0080391c <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80391c:	55                   	push   %ebp
  80391d:	89 e5                	mov    %esp,%ebp
  80391f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803922:	83 ec 04             	sub    $0x4,%esp
  803925:	68 00 46 80 00       	push   $0x804600
  80392a:	68 58 02 00 00       	push   $0x258
  80392f:	68 21 45 80 00       	push   $0x804521
  803934:	e8 68 c9 ff ff       	call   8002a1 <_panic>

00803939 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803939:	55                   	push   %ebp
  80393a:	89 e5                	mov    %esp,%ebp
  80393c:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80393f:	83 ec 04             	sub    $0x4,%esp
  803942:	68 28 46 80 00       	push   $0x804628
  803947:	68 61 02 00 00       	push   $0x261
  80394c:	68 21 45 80 00       	push   $0x804521
  803951:	e8 4b c9 ff ff       	call   8002a1 <_panic>

00803956 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803956:	55                   	push   %ebp
  803957:	89 e5                	mov    %esp,%ebp
  803959:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80395c:	8b 55 08             	mov    0x8(%ebp),%edx
  80395f:	89 d0                	mov    %edx,%eax
  803961:	c1 e0 02             	shl    $0x2,%eax
  803964:	01 d0                	add    %edx,%eax
  803966:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80396d:	01 d0                	add    %edx,%eax
  80396f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803976:	01 d0                	add    %edx,%eax
  803978:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80397f:	01 d0                	add    %edx,%eax
  803981:	c1 e0 04             	shl    $0x4,%eax
  803984:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803987:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80398e:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803991:	83 ec 0c             	sub    $0xc,%esp
  803994:	50                   	push   %eax
  803995:	e8 c6 e1 ff ff       	call   801b60 <sys_get_virtual_time>
  80399a:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80399d:	eb 41                	jmp    8039e0 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80399f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8039a2:	83 ec 0c             	sub    $0xc,%esp
  8039a5:	50                   	push   %eax
  8039a6:	e8 b5 e1 ff ff       	call   801b60 <sys_get_virtual_time>
  8039ab:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8039ae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b4:	29 c2                	sub    %eax,%edx
  8039b6:	89 d0                	mov    %edx,%eax
  8039b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8039bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039c1:	89 d1                	mov    %edx,%ecx
  8039c3:	29 c1                	sub    %eax,%ecx
  8039c5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8039c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039cb:	39 c2                	cmp    %eax,%edx
  8039cd:	0f 97 c0             	seta   %al
  8039d0:	0f b6 c0             	movzbl %al,%eax
  8039d3:	29 c1                	sub    %eax,%ecx
  8039d5:	89 c8                	mov    %ecx,%eax
  8039d7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8039da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8039e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8039e6:	72 b7                	jb     80399f <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8039e8:	90                   	nop
  8039e9:	c9                   	leave  
  8039ea:	c3                   	ret    

008039eb <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8039eb:	55                   	push   %ebp
  8039ec:	89 e5                	mov    %esp,%ebp
  8039ee:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8039f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8039f8:	eb 03                	jmp    8039fd <busy_wait+0x12>
  8039fa:	ff 45 fc             	incl   -0x4(%ebp)
  8039fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803a00:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a03:	72 f5                	jb     8039fa <busy_wait+0xf>
	return i;
  803a05:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803a08:	c9                   	leave  
  803a09:	c3                   	ret    
  803a0a:	66 90                	xchg   %ax,%ax

00803a0c <__udivdi3>:
  803a0c:	55                   	push   %ebp
  803a0d:	57                   	push   %edi
  803a0e:	56                   	push   %esi
  803a0f:	53                   	push   %ebx
  803a10:	83 ec 1c             	sub    $0x1c,%esp
  803a13:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a17:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a1f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a23:	89 ca                	mov    %ecx,%edx
  803a25:	89 f8                	mov    %edi,%eax
  803a27:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a2b:	85 f6                	test   %esi,%esi
  803a2d:	75 2d                	jne    803a5c <__udivdi3+0x50>
  803a2f:	39 cf                	cmp    %ecx,%edi
  803a31:	77 65                	ja     803a98 <__udivdi3+0x8c>
  803a33:	89 fd                	mov    %edi,%ebp
  803a35:	85 ff                	test   %edi,%edi
  803a37:	75 0b                	jne    803a44 <__udivdi3+0x38>
  803a39:	b8 01 00 00 00       	mov    $0x1,%eax
  803a3e:	31 d2                	xor    %edx,%edx
  803a40:	f7 f7                	div    %edi
  803a42:	89 c5                	mov    %eax,%ebp
  803a44:	31 d2                	xor    %edx,%edx
  803a46:	89 c8                	mov    %ecx,%eax
  803a48:	f7 f5                	div    %ebp
  803a4a:	89 c1                	mov    %eax,%ecx
  803a4c:	89 d8                	mov    %ebx,%eax
  803a4e:	f7 f5                	div    %ebp
  803a50:	89 cf                	mov    %ecx,%edi
  803a52:	89 fa                	mov    %edi,%edx
  803a54:	83 c4 1c             	add    $0x1c,%esp
  803a57:	5b                   	pop    %ebx
  803a58:	5e                   	pop    %esi
  803a59:	5f                   	pop    %edi
  803a5a:	5d                   	pop    %ebp
  803a5b:	c3                   	ret    
  803a5c:	39 ce                	cmp    %ecx,%esi
  803a5e:	77 28                	ja     803a88 <__udivdi3+0x7c>
  803a60:	0f bd fe             	bsr    %esi,%edi
  803a63:	83 f7 1f             	xor    $0x1f,%edi
  803a66:	75 40                	jne    803aa8 <__udivdi3+0x9c>
  803a68:	39 ce                	cmp    %ecx,%esi
  803a6a:	72 0a                	jb     803a76 <__udivdi3+0x6a>
  803a6c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a70:	0f 87 9e 00 00 00    	ja     803b14 <__udivdi3+0x108>
  803a76:	b8 01 00 00 00       	mov    $0x1,%eax
  803a7b:	89 fa                	mov    %edi,%edx
  803a7d:	83 c4 1c             	add    $0x1c,%esp
  803a80:	5b                   	pop    %ebx
  803a81:	5e                   	pop    %esi
  803a82:	5f                   	pop    %edi
  803a83:	5d                   	pop    %ebp
  803a84:	c3                   	ret    
  803a85:	8d 76 00             	lea    0x0(%esi),%esi
  803a88:	31 ff                	xor    %edi,%edi
  803a8a:	31 c0                	xor    %eax,%eax
  803a8c:	89 fa                	mov    %edi,%edx
  803a8e:	83 c4 1c             	add    $0x1c,%esp
  803a91:	5b                   	pop    %ebx
  803a92:	5e                   	pop    %esi
  803a93:	5f                   	pop    %edi
  803a94:	5d                   	pop    %ebp
  803a95:	c3                   	ret    
  803a96:	66 90                	xchg   %ax,%ax
  803a98:	89 d8                	mov    %ebx,%eax
  803a9a:	f7 f7                	div    %edi
  803a9c:	31 ff                	xor    %edi,%edi
  803a9e:	89 fa                	mov    %edi,%edx
  803aa0:	83 c4 1c             	add    $0x1c,%esp
  803aa3:	5b                   	pop    %ebx
  803aa4:	5e                   	pop    %esi
  803aa5:	5f                   	pop    %edi
  803aa6:	5d                   	pop    %ebp
  803aa7:	c3                   	ret    
  803aa8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803aad:	89 eb                	mov    %ebp,%ebx
  803aaf:	29 fb                	sub    %edi,%ebx
  803ab1:	89 f9                	mov    %edi,%ecx
  803ab3:	d3 e6                	shl    %cl,%esi
  803ab5:	89 c5                	mov    %eax,%ebp
  803ab7:	88 d9                	mov    %bl,%cl
  803ab9:	d3 ed                	shr    %cl,%ebp
  803abb:	89 e9                	mov    %ebp,%ecx
  803abd:	09 f1                	or     %esi,%ecx
  803abf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ac3:	89 f9                	mov    %edi,%ecx
  803ac5:	d3 e0                	shl    %cl,%eax
  803ac7:	89 c5                	mov    %eax,%ebp
  803ac9:	89 d6                	mov    %edx,%esi
  803acb:	88 d9                	mov    %bl,%cl
  803acd:	d3 ee                	shr    %cl,%esi
  803acf:	89 f9                	mov    %edi,%ecx
  803ad1:	d3 e2                	shl    %cl,%edx
  803ad3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ad7:	88 d9                	mov    %bl,%cl
  803ad9:	d3 e8                	shr    %cl,%eax
  803adb:	09 c2                	or     %eax,%edx
  803add:	89 d0                	mov    %edx,%eax
  803adf:	89 f2                	mov    %esi,%edx
  803ae1:	f7 74 24 0c          	divl   0xc(%esp)
  803ae5:	89 d6                	mov    %edx,%esi
  803ae7:	89 c3                	mov    %eax,%ebx
  803ae9:	f7 e5                	mul    %ebp
  803aeb:	39 d6                	cmp    %edx,%esi
  803aed:	72 19                	jb     803b08 <__udivdi3+0xfc>
  803aef:	74 0b                	je     803afc <__udivdi3+0xf0>
  803af1:	89 d8                	mov    %ebx,%eax
  803af3:	31 ff                	xor    %edi,%edi
  803af5:	e9 58 ff ff ff       	jmp    803a52 <__udivdi3+0x46>
  803afa:	66 90                	xchg   %ax,%ax
  803afc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b00:	89 f9                	mov    %edi,%ecx
  803b02:	d3 e2                	shl    %cl,%edx
  803b04:	39 c2                	cmp    %eax,%edx
  803b06:	73 e9                	jae    803af1 <__udivdi3+0xe5>
  803b08:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b0b:	31 ff                	xor    %edi,%edi
  803b0d:	e9 40 ff ff ff       	jmp    803a52 <__udivdi3+0x46>
  803b12:	66 90                	xchg   %ax,%ax
  803b14:	31 c0                	xor    %eax,%eax
  803b16:	e9 37 ff ff ff       	jmp    803a52 <__udivdi3+0x46>
  803b1b:	90                   	nop

00803b1c <__umoddi3>:
  803b1c:	55                   	push   %ebp
  803b1d:	57                   	push   %edi
  803b1e:	56                   	push   %esi
  803b1f:	53                   	push   %ebx
  803b20:	83 ec 1c             	sub    $0x1c,%esp
  803b23:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b27:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b2f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b37:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b3b:	89 f3                	mov    %esi,%ebx
  803b3d:	89 fa                	mov    %edi,%edx
  803b3f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b43:	89 34 24             	mov    %esi,(%esp)
  803b46:	85 c0                	test   %eax,%eax
  803b48:	75 1a                	jne    803b64 <__umoddi3+0x48>
  803b4a:	39 f7                	cmp    %esi,%edi
  803b4c:	0f 86 a2 00 00 00    	jbe    803bf4 <__umoddi3+0xd8>
  803b52:	89 c8                	mov    %ecx,%eax
  803b54:	89 f2                	mov    %esi,%edx
  803b56:	f7 f7                	div    %edi
  803b58:	89 d0                	mov    %edx,%eax
  803b5a:	31 d2                	xor    %edx,%edx
  803b5c:	83 c4 1c             	add    $0x1c,%esp
  803b5f:	5b                   	pop    %ebx
  803b60:	5e                   	pop    %esi
  803b61:	5f                   	pop    %edi
  803b62:	5d                   	pop    %ebp
  803b63:	c3                   	ret    
  803b64:	39 f0                	cmp    %esi,%eax
  803b66:	0f 87 ac 00 00 00    	ja     803c18 <__umoddi3+0xfc>
  803b6c:	0f bd e8             	bsr    %eax,%ebp
  803b6f:	83 f5 1f             	xor    $0x1f,%ebp
  803b72:	0f 84 ac 00 00 00    	je     803c24 <__umoddi3+0x108>
  803b78:	bf 20 00 00 00       	mov    $0x20,%edi
  803b7d:	29 ef                	sub    %ebp,%edi
  803b7f:	89 fe                	mov    %edi,%esi
  803b81:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b85:	89 e9                	mov    %ebp,%ecx
  803b87:	d3 e0                	shl    %cl,%eax
  803b89:	89 d7                	mov    %edx,%edi
  803b8b:	89 f1                	mov    %esi,%ecx
  803b8d:	d3 ef                	shr    %cl,%edi
  803b8f:	09 c7                	or     %eax,%edi
  803b91:	89 e9                	mov    %ebp,%ecx
  803b93:	d3 e2                	shl    %cl,%edx
  803b95:	89 14 24             	mov    %edx,(%esp)
  803b98:	89 d8                	mov    %ebx,%eax
  803b9a:	d3 e0                	shl    %cl,%eax
  803b9c:	89 c2                	mov    %eax,%edx
  803b9e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ba2:	d3 e0                	shl    %cl,%eax
  803ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ba8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bac:	89 f1                	mov    %esi,%ecx
  803bae:	d3 e8                	shr    %cl,%eax
  803bb0:	09 d0                	or     %edx,%eax
  803bb2:	d3 eb                	shr    %cl,%ebx
  803bb4:	89 da                	mov    %ebx,%edx
  803bb6:	f7 f7                	div    %edi
  803bb8:	89 d3                	mov    %edx,%ebx
  803bba:	f7 24 24             	mull   (%esp)
  803bbd:	89 c6                	mov    %eax,%esi
  803bbf:	89 d1                	mov    %edx,%ecx
  803bc1:	39 d3                	cmp    %edx,%ebx
  803bc3:	0f 82 87 00 00 00    	jb     803c50 <__umoddi3+0x134>
  803bc9:	0f 84 91 00 00 00    	je     803c60 <__umoddi3+0x144>
  803bcf:	8b 54 24 04          	mov    0x4(%esp),%edx
  803bd3:	29 f2                	sub    %esi,%edx
  803bd5:	19 cb                	sbb    %ecx,%ebx
  803bd7:	89 d8                	mov    %ebx,%eax
  803bd9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803bdd:	d3 e0                	shl    %cl,%eax
  803bdf:	89 e9                	mov    %ebp,%ecx
  803be1:	d3 ea                	shr    %cl,%edx
  803be3:	09 d0                	or     %edx,%eax
  803be5:	89 e9                	mov    %ebp,%ecx
  803be7:	d3 eb                	shr    %cl,%ebx
  803be9:	89 da                	mov    %ebx,%edx
  803beb:	83 c4 1c             	add    $0x1c,%esp
  803bee:	5b                   	pop    %ebx
  803bef:	5e                   	pop    %esi
  803bf0:	5f                   	pop    %edi
  803bf1:	5d                   	pop    %ebp
  803bf2:	c3                   	ret    
  803bf3:	90                   	nop
  803bf4:	89 fd                	mov    %edi,%ebp
  803bf6:	85 ff                	test   %edi,%edi
  803bf8:	75 0b                	jne    803c05 <__umoddi3+0xe9>
  803bfa:	b8 01 00 00 00       	mov    $0x1,%eax
  803bff:	31 d2                	xor    %edx,%edx
  803c01:	f7 f7                	div    %edi
  803c03:	89 c5                	mov    %eax,%ebp
  803c05:	89 f0                	mov    %esi,%eax
  803c07:	31 d2                	xor    %edx,%edx
  803c09:	f7 f5                	div    %ebp
  803c0b:	89 c8                	mov    %ecx,%eax
  803c0d:	f7 f5                	div    %ebp
  803c0f:	89 d0                	mov    %edx,%eax
  803c11:	e9 44 ff ff ff       	jmp    803b5a <__umoddi3+0x3e>
  803c16:	66 90                	xchg   %ax,%ax
  803c18:	89 c8                	mov    %ecx,%eax
  803c1a:	89 f2                	mov    %esi,%edx
  803c1c:	83 c4 1c             	add    $0x1c,%esp
  803c1f:	5b                   	pop    %ebx
  803c20:	5e                   	pop    %esi
  803c21:	5f                   	pop    %edi
  803c22:	5d                   	pop    %ebp
  803c23:	c3                   	ret    
  803c24:	3b 04 24             	cmp    (%esp),%eax
  803c27:	72 06                	jb     803c2f <__umoddi3+0x113>
  803c29:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c2d:	77 0f                	ja     803c3e <__umoddi3+0x122>
  803c2f:	89 f2                	mov    %esi,%edx
  803c31:	29 f9                	sub    %edi,%ecx
  803c33:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c37:	89 14 24             	mov    %edx,(%esp)
  803c3a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c3e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c42:	8b 14 24             	mov    (%esp),%edx
  803c45:	83 c4 1c             	add    $0x1c,%esp
  803c48:	5b                   	pop    %ebx
  803c49:	5e                   	pop    %esi
  803c4a:	5f                   	pop    %edi
  803c4b:	5d                   	pop    %ebp
  803c4c:	c3                   	ret    
  803c4d:	8d 76 00             	lea    0x0(%esi),%esi
  803c50:	2b 04 24             	sub    (%esp),%eax
  803c53:	19 fa                	sbb    %edi,%edx
  803c55:	89 d1                	mov    %edx,%ecx
  803c57:	89 c6                	mov    %eax,%esi
  803c59:	e9 71 ff ff ff       	jmp    803bcf <__umoddi3+0xb3>
  803c5e:	66 90                	xchg   %ax,%ax
  803c60:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c64:	72 ea                	jb     803c50 <__umoddi3+0x134>
  803c66:	89 d9                	mov    %ebx,%ecx
  803c68:	e9 62 ff ff ff       	jmp    803bcf <__umoddi3+0xb3>
