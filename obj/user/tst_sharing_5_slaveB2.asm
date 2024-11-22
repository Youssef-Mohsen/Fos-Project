
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
  800031:	e8 0d 01 00 00       	call   800143 <libmain>
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
  80005b:	68 40 3b 80 00       	push   $0x803b40
  800060:	6a 0c                	push   $0xc
  800062:	68 5c 3b 80 00       	push   $0x803b5c
  800067:	e8 16 02 00 00       	call   800282 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006c:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	z = sget(sys_getparentenvid(),"z");
  800073:	e8 d3 19 00 00       	call   801a4b <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 79 3b 80 00       	push   $0x803b79
  800080:	50                   	push   %eax
  800081:	e8 15 16 00 00       	call   80169b <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 7c 3b 80 00       	push   $0x803b7c
  800094:	e8 a6 04 00 00       	call   80053f <cprintf>
  800099:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got z
	inctst();
  80009c:	e8 cf 1a 00 00       	call   801b70 <inctst>

	cprintf("Slave B2 please be patient ...\n");
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	68 a4 3b 80 00       	push   $0x803ba4
  8000a9:	e8 91 04 00 00       	call   80053f <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 28 23 00 00       	push   $0x2328
  8000b9:	e8 4d 37 00 00       	call   80380b <env_sleep>
  8000be:	83 c4 10             	add    $0x10,%esp
	//to ensure that the other environments completed successfully
	while (gettst()!=3) ;// panic("test failed");
  8000c1:	90                   	nop
  8000c2:	e8 c3 1a 00 00       	call   801b8a <gettst>
  8000c7:	83 f8 03             	cmp    $0x3,%eax
  8000ca:	75 f6                	jne    8000c2 <_main+0x8a>

	freeFrames = sys_calculate_free_frames() ;
  8000cc:	e8 98 17 00 00       	call   801869 <sys_calculate_free_frames>
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	sfree(z);
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000da:	e8 d9 15 00 00       	call   8016b8 <sfree>
  8000df:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 c4 3b 80 00       	push   $0x803bc4
  8000ea:	e8 50 04 00 00       	call   80053f <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
	expected = 1+1; /*1page+1table*/
  8000f2:	c7 45 e8 02 00 00 00 	movl   $0x2,-0x18(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  8000f9:	e8 6b 17 00 00       	call   801869 <sys_calculate_free_frames>
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800103:	29 c2                	sub    %eax,%edx
  800105:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800108:	39 c2                	cmp    %eax,%edx
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 dc 3b 80 00       	push   $0x803bdc
  800114:	6a 28                	push   $0x28
  800116:	68 5c 3b 80 00       	push   $0x803b5c
  80011b:	e8 62 01 00 00       	call   800282 <_panic>


	cprintf("Step B completed successfully!!\n\n\n");
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	68 7c 3c 80 00       	push   $0x803c7c
  800128:	e8 12 04 00 00       	call   80053f <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n%~Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 a0 3c 80 00       	push   $0x803ca0
  800138:	e8 02 04 00 00       	call   80053f <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp

	return;
  800140:	90                   	nop
}
  800141:	c9                   	leave  
  800142:	c3                   	ret    

00800143 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800149:	e8 e4 18 00 00       	call   801a32 <sys_getenvindex>
  80014e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800151:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800154:	89 d0                	mov    %edx,%eax
  800156:	c1 e0 03             	shl    $0x3,%eax
  800159:	01 d0                	add    %edx,%eax
  80015b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800162:	01 c8                	add    %ecx,%eax
  800164:	01 c0                	add    %eax,%eax
  800166:	01 d0                	add    %edx,%eax
  800168:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80016f:	01 c8                	add    %ecx,%eax
  800171:	01 d0                	add    %edx,%eax
  800173:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800178:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80017d:	a1 20 50 80 00       	mov    0x805020,%eax
  800182:	8a 40 20             	mov    0x20(%eax),%al
  800185:	84 c0                	test   %al,%al
  800187:	74 0d                	je     800196 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800189:	a1 20 50 80 00       	mov    0x805020,%eax
  80018e:	83 c0 20             	add    $0x20,%eax
  800191:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800196:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80019a:	7e 0a                	jle    8001a6 <libmain+0x63>
		binaryname = argv[0];
  80019c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019f:	8b 00                	mov    (%eax),%eax
  8001a1:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8001a6:	83 ec 08             	sub    $0x8,%esp
  8001a9:	ff 75 0c             	pushl  0xc(%ebp)
  8001ac:	ff 75 08             	pushl  0x8(%ebp)
  8001af:	e8 84 fe ff ff       	call   800038 <_main>
  8001b4:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8001b7:	e8 fa 15 00 00       	call   8017b6 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	68 08 3d 80 00       	push   $0x803d08
  8001c4:	e8 76 03 00 00       	call   80053f <cprintf>
  8001c9:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001cc:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d1:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8001d7:	a1 20 50 80 00       	mov    0x805020,%eax
  8001dc:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	52                   	push   %edx
  8001e6:	50                   	push   %eax
  8001e7:	68 30 3d 80 00       	push   $0x803d30
  8001ec:	e8 4e 03 00 00       	call   80053f <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8001f9:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8001ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800204:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80020a:	a1 20 50 80 00       	mov    0x805020,%eax
  80020f:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800215:	51                   	push   %ecx
  800216:	52                   	push   %edx
  800217:	50                   	push   %eax
  800218:	68 58 3d 80 00       	push   $0x803d58
  80021d:	e8 1d 03 00 00       	call   80053f <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800225:	a1 20 50 80 00       	mov    0x805020,%eax
  80022a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	50                   	push   %eax
  800234:	68 b0 3d 80 00       	push   $0x803db0
  800239:	e8 01 03 00 00       	call   80053f <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	68 08 3d 80 00       	push   $0x803d08
  800249:	e8 f1 02 00 00       	call   80053f <cprintf>
  80024e:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800251:	e8 7a 15 00 00       	call   8017d0 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800256:	e8 19 00 00 00       	call   800274 <exit>
}
  80025b:	90                   	nop
  80025c:	c9                   	leave  
  80025d:	c3                   	ret    

0080025e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	6a 00                	push   $0x0
  800269:	e8 90 17 00 00       	call   8019fe <sys_destroy_env>
  80026e:	83 c4 10             	add    $0x10,%esp
}
  800271:	90                   	nop
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <exit>:

void
exit(void)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80027a:	e8 e5 17 00 00       	call   801a64 <sys_exit_env>
}
  80027f:	90                   	nop
  800280:	c9                   	leave  
  800281:	c3                   	ret    

00800282 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800288:	8d 45 10             	lea    0x10(%ebp),%eax
  80028b:	83 c0 04             	add    $0x4,%eax
  80028e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800291:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800296:	85 c0                	test   %eax,%eax
  800298:	74 16                	je     8002b0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80029a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80029f:	83 ec 08             	sub    $0x8,%esp
  8002a2:	50                   	push   %eax
  8002a3:	68 c4 3d 80 00       	push   $0x803dc4
  8002a8:	e8 92 02 00 00       	call   80053f <cprintf>
  8002ad:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b0:	a1 00 50 80 00       	mov    0x805000,%eax
  8002b5:	ff 75 0c             	pushl  0xc(%ebp)
  8002b8:	ff 75 08             	pushl  0x8(%ebp)
  8002bb:	50                   	push   %eax
  8002bc:	68 c9 3d 80 00       	push   $0x803dc9
  8002c1:	e8 79 02 00 00       	call   80053f <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002cc:	83 ec 08             	sub    $0x8,%esp
  8002cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8002d2:	50                   	push   %eax
  8002d3:	e8 fc 01 00 00       	call   8004d4 <vcprintf>
  8002d8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	6a 00                	push   $0x0
  8002e0:	68 e5 3d 80 00       	push   $0x803de5
  8002e5:	e8 ea 01 00 00       	call   8004d4 <vcprintf>
  8002ea:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002ed:	e8 82 ff ff ff       	call   800274 <exit>

	// should not return here
	while (1) ;
  8002f2:	eb fe                	jmp    8002f2 <_panic+0x70>

008002f4 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002fa:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ff:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800305:	8b 45 0c             	mov    0xc(%ebp),%eax
  800308:	39 c2                	cmp    %eax,%edx
  80030a:	74 14                	je     800320 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80030c:	83 ec 04             	sub    $0x4,%esp
  80030f:	68 e8 3d 80 00       	push   $0x803de8
  800314:	6a 26                	push   $0x26
  800316:	68 34 3e 80 00       	push   $0x803e34
  80031b:	e8 62 ff ff ff       	call   800282 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800320:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800327:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80032e:	e9 c5 00 00 00       	jmp    8003f8 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800333:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800336:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033d:	8b 45 08             	mov    0x8(%ebp),%eax
  800340:	01 d0                	add    %edx,%eax
  800342:	8b 00                	mov    (%eax),%eax
  800344:	85 c0                	test   %eax,%eax
  800346:	75 08                	jne    800350 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800348:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80034b:	e9 a5 00 00 00       	jmp    8003f5 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800350:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800357:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80035e:	eb 69                	jmp    8003c9 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800360:	a1 20 50 80 00       	mov    0x805020,%eax
  800365:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80036b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80036e:	89 d0                	mov    %edx,%eax
  800370:	01 c0                	add    %eax,%eax
  800372:	01 d0                	add    %edx,%eax
  800374:	c1 e0 03             	shl    $0x3,%eax
  800377:	01 c8                	add    %ecx,%eax
  800379:	8a 40 04             	mov    0x4(%eax),%al
  80037c:	84 c0                	test   %al,%al
  80037e:	75 46                	jne    8003c6 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800380:	a1 20 50 80 00       	mov    0x805020,%eax
  800385:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80038b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80038e:	89 d0                	mov    %edx,%eax
  800390:	01 c0                	add    %eax,%eax
  800392:	01 d0                	add    %edx,%eax
  800394:	c1 e0 03             	shl    $0x3,%eax
  800397:	01 c8                	add    %ecx,%eax
  800399:	8b 00                	mov    (%eax),%eax
  80039b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80039e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ab:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b5:	01 c8                	add    %ecx,%eax
  8003b7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b9:	39 c2                	cmp    %eax,%edx
  8003bb:	75 09                	jne    8003c6 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003bd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003c4:	eb 15                	jmp    8003db <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c6:	ff 45 e8             	incl   -0x18(%ebp)
  8003c9:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ce:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8003d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003d7:	39 c2                	cmp    %eax,%edx
  8003d9:	77 85                	ja     800360 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003df:	75 14                	jne    8003f5 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003e1:	83 ec 04             	sub    $0x4,%esp
  8003e4:	68 40 3e 80 00       	push   $0x803e40
  8003e9:	6a 3a                	push   $0x3a
  8003eb:	68 34 3e 80 00       	push   $0x803e34
  8003f0:	e8 8d fe ff ff       	call   800282 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003f5:	ff 45 f0             	incl   -0x10(%ebp)
  8003f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003fb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003fe:	0f 8c 2f ff ff ff    	jl     800333 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800404:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80040b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800412:	eb 26                	jmp    80043a <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800414:	a1 20 50 80 00       	mov    0x805020,%eax
  800419:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80041f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800422:	89 d0                	mov    %edx,%eax
  800424:	01 c0                	add    %eax,%eax
  800426:	01 d0                	add    %edx,%eax
  800428:	c1 e0 03             	shl    $0x3,%eax
  80042b:	01 c8                	add    %ecx,%eax
  80042d:	8a 40 04             	mov    0x4(%eax),%al
  800430:	3c 01                	cmp    $0x1,%al
  800432:	75 03                	jne    800437 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800434:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800437:	ff 45 e0             	incl   -0x20(%ebp)
  80043a:	a1 20 50 80 00       	mov    0x805020,%eax
  80043f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800445:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800448:	39 c2                	cmp    %eax,%edx
  80044a:	77 c8                	ja     800414 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80044c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80044f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800452:	74 14                	je     800468 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800454:	83 ec 04             	sub    $0x4,%esp
  800457:	68 94 3e 80 00       	push   $0x803e94
  80045c:	6a 44                	push   $0x44
  80045e:	68 34 3e 80 00       	push   $0x803e34
  800463:	e8 1a fe ff ff       	call   800282 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800468:	90                   	nop
  800469:	c9                   	leave  
  80046a:	c3                   	ret    

0080046b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80046b:	55                   	push   %ebp
  80046c:	89 e5                	mov    %esp,%ebp
  80046e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800471:	8b 45 0c             	mov    0xc(%ebp),%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	8d 48 01             	lea    0x1(%eax),%ecx
  800479:	8b 55 0c             	mov    0xc(%ebp),%edx
  80047c:	89 0a                	mov    %ecx,(%edx)
  80047e:	8b 55 08             	mov    0x8(%ebp),%edx
  800481:	88 d1                	mov    %dl,%cl
  800483:	8b 55 0c             	mov    0xc(%ebp),%edx
  800486:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80048a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048d:	8b 00                	mov    (%eax),%eax
  80048f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800494:	75 2c                	jne    8004c2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800496:	a0 28 50 80 00       	mov    0x805028,%al
  80049b:	0f b6 c0             	movzbl %al,%eax
  80049e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a1:	8b 12                	mov    (%edx),%edx
  8004a3:	89 d1                	mov    %edx,%ecx
  8004a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a8:	83 c2 08             	add    $0x8,%edx
  8004ab:	83 ec 04             	sub    $0x4,%esp
  8004ae:	50                   	push   %eax
  8004af:	51                   	push   %ecx
  8004b0:	52                   	push   %edx
  8004b1:	e8 be 12 00 00       	call   801774 <sys_cputs>
  8004b6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c5:	8b 40 04             	mov    0x4(%eax),%eax
  8004c8:	8d 50 01             	lea    0x1(%eax),%edx
  8004cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ce:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004d1:	90                   	nop
  8004d2:	c9                   	leave  
  8004d3:	c3                   	ret    

008004d4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004d4:	55                   	push   %ebp
  8004d5:	89 e5                	mov    %esp,%ebp
  8004d7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004dd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004e4:	00 00 00 
	b.cnt = 0;
  8004e7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004ee:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004f1:	ff 75 0c             	pushl  0xc(%ebp)
  8004f4:	ff 75 08             	pushl  0x8(%ebp)
  8004f7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004fd:	50                   	push   %eax
  8004fe:	68 6b 04 80 00       	push   $0x80046b
  800503:	e8 11 02 00 00       	call   800719 <vprintfmt>
  800508:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80050b:	a0 28 50 80 00       	mov    0x805028,%al
  800510:	0f b6 c0             	movzbl %al,%eax
  800513:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800519:	83 ec 04             	sub    $0x4,%esp
  80051c:	50                   	push   %eax
  80051d:	52                   	push   %edx
  80051e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800524:	83 c0 08             	add    $0x8,%eax
  800527:	50                   	push   %eax
  800528:	e8 47 12 00 00       	call   801774 <sys_cputs>
  80052d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800530:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800537:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80053d:	c9                   	leave  
  80053e:	c3                   	ret    

0080053f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80053f:	55                   	push   %ebp
  800540:	89 e5                	mov    %esp,%ebp
  800542:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800545:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  80054c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80054f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800552:	8b 45 08             	mov    0x8(%ebp),%eax
  800555:	83 ec 08             	sub    $0x8,%esp
  800558:	ff 75 f4             	pushl  -0xc(%ebp)
  80055b:	50                   	push   %eax
  80055c:	e8 73 ff ff ff       	call   8004d4 <vcprintf>
  800561:	83 c4 10             	add    $0x10,%esp
  800564:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800567:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80056a:	c9                   	leave  
  80056b:	c3                   	ret    

0080056c <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80056c:	55                   	push   %ebp
  80056d:	89 e5                	mov    %esp,%ebp
  80056f:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800572:	e8 3f 12 00 00       	call   8017b6 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800577:	8d 45 0c             	lea    0xc(%ebp),%eax
  80057a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80057d:	8b 45 08             	mov    0x8(%ebp),%eax
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	ff 75 f4             	pushl  -0xc(%ebp)
  800586:	50                   	push   %eax
  800587:	e8 48 ff ff ff       	call   8004d4 <vcprintf>
  80058c:	83 c4 10             	add    $0x10,%esp
  80058f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800592:	e8 39 12 00 00       	call   8017d0 <sys_unlock_cons>
	return cnt;
  800597:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059a:	c9                   	leave  
  80059b:	c3                   	ret    

0080059c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80059c:	55                   	push   %ebp
  80059d:	89 e5                	mov    %esp,%ebp
  80059f:	53                   	push   %ebx
  8005a0:	83 ec 14             	sub    $0x14,%esp
  8005a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005af:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ba:	77 55                	ja     800611 <printnum+0x75>
  8005bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005bf:	72 05                	jb     8005c6 <printnum+0x2a>
  8005c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005c4:	77 4b                	ja     800611 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005c6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005c9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005cc:	8b 45 18             	mov    0x18(%ebp),%eax
  8005cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d4:	52                   	push   %edx
  8005d5:	50                   	push   %eax
  8005d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8005dc:	e8 df 32 00 00       	call   8038c0 <__udivdi3>
  8005e1:	83 c4 10             	add    $0x10,%esp
  8005e4:	83 ec 04             	sub    $0x4,%esp
  8005e7:	ff 75 20             	pushl  0x20(%ebp)
  8005ea:	53                   	push   %ebx
  8005eb:	ff 75 18             	pushl  0x18(%ebp)
  8005ee:	52                   	push   %edx
  8005ef:	50                   	push   %eax
  8005f0:	ff 75 0c             	pushl  0xc(%ebp)
  8005f3:	ff 75 08             	pushl  0x8(%ebp)
  8005f6:	e8 a1 ff ff ff       	call   80059c <printnum>
  8005fb:	83 c4 20             	add    $0x20,%esp
  8005fe:	eb 1a                	jmp    80061a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800600:	83 ec 08             	sub    $0x8,%esp
  800603:	ff 75 0c             	pushl  0xc(%ebp)
  800606:	ff 75 20             	pushl  0x20(%ebp)
  800609:	8b 45 08             	mov    0x8(%ebp),%eax
  80060c:	ff d0                	call   *%eax
  80060e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800611:	ff 4d 1c             	decl   0x1c(%ebp)
  800614:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800618:	7f e6                	jg     800600 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80061a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80061d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800622:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800625:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800628:	53                   	push   %ebx
  800629:	51                   	push   %ecx
  80062a:	52                   	push   %edx
  80062b:	50                   	push   %eax
  80062c:	e8 9f 33 00 00       	call   8039d0 <__umoddi3>
  800631:	83 c4 10             	add    $0x10,%esp
  800634:	05 f4 40 80 00       	add    $0x8040f4,%eax
  800639:	8a 00                	mov    (%eax),%al
  80063b:	0f be c0             	movsbl %al,%eax
  80063e:	83 ec 08             	sub    $0x8,%esp
  800641:	ff 75 0c             	pushl  0xc(%ebp)
  800644:	50                   	push   %eax
  800645:	8b 45 08             	mov    0x8(%ebp),%eax
  800648:	ff d0                	call   *%eax
  80064a:	83 c4 10             	add    $0x10,%esp
}
  80064d:	90                   	nop
  80064e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800651:	c9                   	leave  
  800652:	c3                   	ret    

00800653 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800653:	55                   	push   %ebp
  800654:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800656:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80065a:	7e 1c                	jle    800678 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80065c:	8b 45 08             	mov    0x8(%ebp),%eax
  80065f:	8b 00                	mov    (%eax),%eax
  800661:	8d 50 08             	lea    0x8(%eax),%edx
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	89 10                	mov    %edx,(%eax)
  800669:	8b 45 08             	mov    0x8(%ebp),%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	83 e8 08             	sub    $0x8,%eax
  800671:	8b 50 04             	mov    0x4(%eax),%edx
  800674:	8b 00                	mov    (%eax),%eax
  800676:	eb 40                	jmp    8006b8 <getuint+0x65>
	else if (lflag)
  800678:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80067c:	74 1e                	je     80069c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80067e:	8b 45 08             	mov    0x8(%ebp),%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	8d 50 04             	lea    0x4(%eax),%edx
  800686:	8b 45 08             	mov    0x8(%ebp),%eax
  800689:	89 10                	mov    %edx,(%eax)
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	8b 00                	mov    (%eax),%eax
  800690:	83 e8 04             	sub    $0x4,%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	ba 00 00 00 00       	mov    $0x0,%edx
  80069a:	eb 1c                	jmp    8006b8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80069c:	8b 45 08             	mov    0x8(%ebp),%eax
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	8d 50 04             	lea    0x4(%eax),%edx
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	89 10                	mov    %edx,(%eax)
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	83 e8 04             	sub    $0x4,%eax
  8006b1:	8b 00                	mov    (%eax),%eax
  8006b3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006b8:	5d                   	pop    %ebp
  8006b9:	c3                   	ret    

008006ba <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ba:	55                   	push   %ebp
  8006bb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006c1:	7e 1c                	jle    8006df <getint+0x25>
		return va_arg(*ap, long long);
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	8d 50 08             	lea    0x8(%eax),%edx
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	89 10                	mov    %edx,(%eax)
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	8b 00                	mov    (%eax),%eax
  8006d5:	83 e8 08             	sub    $0x8,%eax
  8006d8:	8b 50 04             	mov    0x4(%eax),%edx
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	eb 38                	jmp    800717 <getint+0x5d>
	else if (lflag)
  8006df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006e3:	74 1a                	je     8006ff <getint+0x45>
		return va_arg(*ap, long);
  8006e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e8:	8b 00                	mov    (%eax),%eax
  8006ea:	8d 50 04             	lea    0x4(%eax),%edx
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	89 10                	mov    %edx,(%eax)
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	83 e8 04             	sub    $0x4,%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	99                   	cltd   
  8006fd:	eb 18                	jmp    800717 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	8b 00                	mov    (%eax),%eax
  800704:	8d 50 04             	lea    0x4(%eax),%edx
  800707:	8b 45 08             	mov    0x8(%ebp),%eax
  80070a:	89 10                	mov    %edx,(%eax)
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	83 e8 04             	sub    $0x4,%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	99                   	cltd   
}
  800717:	5d                   	pop    %ebp
  800718:	c3                   	ret    

00800719 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800719:	55                   	push   %ebp
  80071a:	89 e5                	mov    %esp,%ebp
  80071c:	56                   	push   %esi
  80071d:	53                   	push   %ebx
  80071e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800721:	eb 17                	jmp    80073a <vprintfmt+0x21>
			if (ch == '\0')
  800723:	85 db                	test   %ebx,%ebx
  800725:	0f 84 c1 03 00 00    	je     800aec <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	ff 75 0c             	pushl  0xc(%ebp)
  800731:	53                   	push   %ebx
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	ff d0                	call   *%eax
  800737:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80073a:	8b 45 10             	mov    0x10(%ebp),%eax
  80073d:	8d 50 01             	lea    0x1(%eax),%edx
  800740:	89 55 10             	mov    %edx,0x10(%ebp)
  800743:	8a 00                	mov    (%eax),%al
  800745:	0f b6 d8             	movzbl %al,%ebx
  800748:	83 fb 25             	cmp    $0x25,%ebx
  80074b:	75 d6                	jne    800723 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80074d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800751:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800758:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80075f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800766:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80076d:	8b 45 10             	mov    0x10(%ebp),%eax
  800770:	8d 50 01             	lea    0x1(%eax),%edx
  800773:	89 55 10             	mov    %edx,0x10(%ebp)
  800776:	8a 00                	mov    (%eax),%al
  800778:	0f b6 d8             	movzbl %al,%ebx
  80077b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80077e:	83 f8 5b             	cmp    $0x5b,%eax
  800781:	0f 87 3d 03 00 00    	ja     800ac4 <vprintfmt+0x3ab>
  800787:	8b 04 85 18 41 80 00 	mov    0x804118(,%eax,4),%eax
  80078e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800790:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800794:	eb d7                	jmp    80076d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800796:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80079a:	eb d1                	jmp    80076d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80079c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007a6:	89 d0                	mov    %edx,%eax
  8007a8:	c1 e0 02             	shl    $0x2,%eax
  8007ab:	01 d0                	add    %edx,%eax
  8007ad:	01 c0                	add    %eax,%eax
  8007af:	01 d8                	add    %ebx,%eax
  8007b1:	83 e8 30             	sub    $0x30,%eax
  8007b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ba:	8a 00                	mov    (%eax),%al
  8007bc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007bf:	83 fb 2f             	cmp    $0x2f,%ebx
  8007c2:	7e 3e                	jle    800802 <vprintfmt+0xe9>
  8007c4:	83 fb 39             	cmp    $0x39,%ebx
  8007c7:	7f 39                	jg     800802 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007cc:	eb d5                	jmp    8007a3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	83 c0 04             	add    $0x4,%eax
  8007d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	83 e8 04             	sub    $0x4,%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007e2:	eb 1f                	jmp    800803 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e8:	79 83                	jns    80076d <vprintfmt+0x54>
				width = 0;
  8007ea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007f1:	e9 77 ff ff ff       	jmp    80076d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007f6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007fd:	e9 6b ff ff ff       	jmp    80076d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800802:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800803:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800807:	0f 89 60 ff ff ff    	jns    80076d <vprintfmt+0x54>
				width = precision, precision = -1;
  80080d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800810:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800813:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80081a:	e9 4e ff ff ff       	jmp    80076d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80081f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800822:	e9 46 ff ff ff       	jmp    80076d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	83 c0 04             	add    $0x4,%eax
  80082d:	89 45 14             	mov    %eax,0x14(%ebp)
  800830:	8b 45 14             	mov    0x14(%ebp),%eax
  800833:	83 e8 04             	sub    $0x4,%eax
  800836:	8b 00                	mov    (%eax),%eax
  800838:	83 ec 08             	sub    $0x8,%esp
  80083b:	ff 75 0c             	pushl  0xc(%ebp)
  80083e:	50                   	push   %eax
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	ff d0                	call   *%eax
  800844:	83 c4 10             	add    $0x10,%esp
			break;
  800847:	e9 9b 02 00 00       	jmp    800ae7 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	83 c0 04             	add    $0x4,%eax
  800852:	89 45 14             	mov    %eax,0x14(%ebp)
  800855:	8b 45 14             	mov    0x14(%ebp),%eax
  800858:	83 e8 04             	sub    $0x4,%eax
  80085b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80085d:	85 db                	test   %ebx,%ebx
  80085f:	79 02                	jns    800863 <vprintfmt+0x14a>
				err = -err;
  800861:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800863:	83 fb 64             	cmp    $0x64,%ebx
  800866:	7f 0b                	jg     800873 <vprintfmt+0x15a>
  800868:	8b 34 9d 60 3f 80 00 	mov    0x803f60(,%ebx,4),%esi
  80086f:	85 f6                	test   %esi,%esi
  800871:	75 19                	jne    80088c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800873:	53                   	push   %ebx
  800874:	68 05 41 80 00       	push   $0x804105
  800879:	ff 75 0c             	pushl  0xc(%ebp)
  80087c:	ff 75 08             	pushl  0x8(%ebp)
  80087f:	e8 70 02 00 00       	call   800af4 <printfmt>
  800884:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800887:	e9 5b 02 00 00       	jmp    800ae7 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80088c:	56                   	push   %esi
  80088d:	68 0e 41 80 00       	push   $0x80410e
  800892:	ff 75 0c             	pushl  0xc(%ebp)
  800895:	ff 75 08             	pushl  0x8(%ebp)
  800898:	e8 57 02 00 00       	call   800af4 <printfmt>
  80089d:	83 c4 10             	add    $0x10,%esp
			break;
  8008a0:	e9 42 02 00 00       	jmp    800ae7 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	83 c0 04             	add    $0x4,%eax
  8008ab:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b1:	83 e8 04             	sub    $0x4,%eax
  8008b4:	8b 30                	mov    (%eax),%esi
  8008b6:	85 f6                	test   %esi,%esi
  8008b8:	75 05                	jne    8008bf <vprintfmt+0x1a6>
				p = "(null)";
  8008ba:	be 11 41 80 00       	mov    $0x804111,%esi
			if (width > 0 && padc != '-')
  8008bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c3:	7e 6d                	jle    800932 <vprintfmt+0x219>
  8008c5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008c9:	74 67                	je     800932 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ce:	83 ec 08             	sub    $0x8,%esp
  8008d1:	50                   	push   %eax
  8008d2:	56                   	push   %esi
  8008d3:	e8 1e 03 00 00       	call   800bf6 <strnlen>
  8008d8:	83 c4 10             	add    $0x10,%esp
  8008db:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008de:	eb 16                	jmp    8008f6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008e0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008e4:	83 ec 08             	sub    $0x8,%esp
  8008e7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ea:	50                   	push   %eax
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	ff d0                	call   *%eax
  8008f0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f3:	ff 4d e4             	decl   -0x1c(%ebp)
  8008f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fa:	7f e4                	jg     8008e0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008fc:	eb 34                	jmp    800932 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008fe:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800902:	74 1c                	je     800920 <vprintfmt+0x207>
  800904:	83 fb 1f             	cmp    $0x1f,%ebx
  800907:	7e 05                	jle    80090e <vprintfmt+0x1f5>
  800909:	83 fb 7e             	cmp    $0x7e,%ebx
  80090c:	7e 12                	jle    800920 <vprintfmt+0x207>
					putch('?', putdat);
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	ff 75 0c             	pushl  0xc(%ebp)
  800914:	6a 3f                	push   $0x3f
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	ff d0                	call   *%eax
  80091b:	83 c4 10             	add    $0x10,%esp
  80091e:	eb 0f                	jmp    80092f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800920:	83 ec 08             	sub    $0x8,%esp
  800923:	ff 75 0c             	pushl  0xc(%ebp)
  800926:	53                   	push   %ebx
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	ff d0                	call   *%eax
  80092c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80092f:	ff 4d e4             	decl   -0x1c(%ebp)
  800932:	89 f0                	mov    %esi,%eax
  800934:	8d 70 01             	lea    0x1(%eax),%esi
  800937:	8a 00                	mov    (%eax),%al
  800939:	0f be d8             	movsbl %al,%ebx
  80093c:	85 db                	test   %ebx,%ebx
  80093e:	74 24                	je     800964 <vprintfmt+0x24b>
  800940:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800944:	78 b8                	js     8008fe <vprintfmt+0x1e5>
  800946:	ff 4d e0             	decl   -0x20(%ebp)
  800949:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80094d:	79 af                	jns    8008fe <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80094f:	eb 13                	jmp    800964 <vprintfmt+0x24b>
				putch(' ', putdat);
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	ff 75 0c             	pushl  0xc(%ebp)
  800957:	6a 20                	push   $0x20
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	ff d0                	call   *%eax
  80095e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800961:	ff 4d e4             	decl   -0x1c(%ebp)
  800964:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800968:	7f e7                	jg     800951 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80096a:	e9 78 01 00 00       	jmp    800ae7 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80096f:	83 ec 08             	sub    $0x8,%esp
  800972:	ff 75 e8             	pushl  -0x18(%ebp)
  800975:	8d 45 14             	lea    0x14(%ebp),%eax
  800978:	50                   	push   %eax
  800979:	e8 3c fd ff ff       	call   8006ba <getint>
  80097e:	83 c4 10             	add    $0x10,%esp
  800981:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800984:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80098d:	85 d2                	test   %edx,%edx
  80098f:	79 23                	jns    8009b4 <vprintfmt+0x29b>
				putch('-', putdat);
  800991:	83 ec 08             	sub    $0x8,%esp
  800994:	ff 75 0c             	pushl  0xc(%ebp)
  800997:	6a 2d                	push   $0x2d
  800999:	8b 45 08             	mov    0x8(%ebp),%eax
  80099c:	ff d0                	call   *%eax
  80099e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009a7:	f7 d8                	neg    %eax
  8009a9:	83 d2 00             	adc    $0x0,%edx
  8009ac:	f7 da                	neg    %edx
  8009ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009b4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009bb:	e9 bc 00 00 00       	jmp    800a7c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009c0:	83 ec 08             	sub    $0x8,%esp
  8009c3:	ff 75 e8             	pushl  -0x18(%ebp)
  8009c6:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c9:	50                   	push   %eax
  8009ca:	e8 84 fc ff ff       	call   800653 <getuint>
  8009cf:	83 c4 10             	add    $0x10,%esp
  8009d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009d8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009df:	e9 98 00 00 00       	jmp    800a7c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009e4:	83 ec 08             	sub    $0x8,%esp
  8009e7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ea:	6a 58                	push   $0x58
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	ff d0                	call   *%eax
  8009f1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f4:	83 ec 08             	sub    $0x8,%esp
  8009f7:	ff 75 0c             	pushl  0xc(%ebp)
  8009fa:	6a 58                	push   $0x58
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	ff d0                	call   *%eax
  800a01:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a04:	83 ec 08             	sub    $0x8,%esp
  800a07:	ff 75 0c             	pushl  0xc(%ebp)
  800a0a:	6a 58                	push   $0x58
  800a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0f:	ff d0                	call   *%eax
  800a11:	83 c4 10             	add    $0x10,%esp
			break;
  800a14:	e9 ce 00 00 00       	jmp    800ae7 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a19:	83 ec 08             	sub    $0x8,%esp
  800a1c:	ff 75 0c             	pushl  0xc(%ebp)
  800a1f:	6a 30                	push   $0x30
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	ff d0                	call   *%eax
  800a26:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a29:	83 ec 08             	sub    $0x8,%esp
  800a2c:	ff 75 0c             	pushl  0xc(%ebp)
  800a2f:	6a 78                	push   $0x78
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	ff d0                	call   *%eax
  800a36:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a39:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3c:	83 c0 04             	add    $0x4,%eax
  800a3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a42:	8b 45 14             	mov    0x14(%ebp),%eax
  800a45:	83 e8 04             	sub    $0x4,%eax
  800a48:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a54:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a5b:	eb 1f                	jmp    800a7c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a5d:	83 ec 08             	sub    $0x8,%esp
  800a60:	ff 75 e8             	pushl  -0x18(%ebp)
  800a63:	8d 45 14             	lea    0x14(%ebp),%eax
  800a66:	50                   	push   %eax
  800a67:	e8 e7 fb ff ff       	call   800653 <getuint>
  800a6c:	83 c4 10             	add    $0x10,%esp
  800a6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a72:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a75:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a7c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a83:	83 ec 04             	sub    $0x4,%esp
  800a86:	52                   	push   %edx
  800a87:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a8a:	50                   	push   %eax
  800a8b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8e:	ff 75 f0             	pushl  -0x10(%ebp)
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	ff 75 08             	pushl  0x8(%ebp)
  800a97:	e8 00 fb ff ff       	call   80059c <printnum>
  800a9c:	83 c4 20             	add    $0x20,%esp
			break;
  800a9f:	eb 46                	jmp    800ae7 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aa1:	83 ec 08             	sub    $0x8,%esp
  800aa4:	ff 75 0c             	pushl  0xc(%ebp)
  800aa7:	53                   	push   %ebx
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	ff d0                	call   *%eax
  800aad:	83 c4 10             	add    $0x10,%esp
			break;
  800ab0:	eb 35                	jmp    800ae7 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ab2:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800ab9:	eb 2c                	jmp    800ae7 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800abb:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  800ac2:	eb 23                	jmp    800ae7 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ac4:	83 ec 08             	sub    $0x8,%esp
  800ac7:	ff 75 0c             	pushl  0xc(%ebp)
  800aca:	6a 25                	push   $0x25
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	ff d0                	call   *%eax
  800ad1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ad4:	ff 4d 10             	decl   0x10(%ebp)
  800ad7:	eb 03                	jmp    800adc <vprintfmt+0x3c3>
  800ad9:	ff 4d 10             	decl   0x10(%ebp)
  800adc:	8b 45 10             	mov    0x10(%ebp),%eax
  800adf:	48                   	dec    %eax
  800ae0:	8a 00                	mov    (%eax),%al
  800ae2:	3c 25                	cmp    $0x25,%al
  800ae4:	75 f3                	jne    800ad9 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ae6:	90                   	nop
		}
	}
  800ae7:	e9 35 fc ff ff       	jmp    800721 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800aec:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800aed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800af0:	5b                   	pop    %ebx
  800af1:	5e                   	pop    %esi
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800afa:	8d 45 10             	lea    0x10(%ebp),%eax
  800afd:	83 c0 04             	add    $0x4,%eax
  800b00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b03:	8b 45 10             	mov    0x10(%ebp),%eax
  800b06:	ff 75 f4             	pushl  -0xc(%ebp)
  800b09:	50                   	push   %eax
  800b0a:	ff 75 0c             	pushl  0xc(%ebp)
  800b0d:	ff 75 08             	pushl  0x8(%ebp)
  800b10:	e8 04 fc ff ff       	call   800719 <vprintfmt>
  800b15:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b18:	90                   	nop
  800b19:	c9                   	leave  
  800b1a:	c3                   	ret    

00800b1b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b21:	8b 40 08             	mov    0x8(%eax),%eax
  800b24:	8d 50 01             	lea    0x1(%eax),%edx
  800b27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b30:	8b 10                	mov    (%eax),%edx
  800b32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b35:	8b 40 04             	mov    0x4(%eax),%eax
  800b38:	39 c2                	cmp    %eax,%edx
  800b3a:	73 12                	jae    800b4e <sprintputch+0x33>
		*b->buf++ = ch;
  800b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3f:	8b 00                	mov    (%eax),%eax
  800b41:	8d 48 01             	lea    0x1(%eax),%ecx
  800b44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b47:	89 0a                	mov    %ecx,(%edx)
  800b49:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4c:	88 10                	mov    %dl,(%eax)
}
  800b4e:	90                   	nop
  800b4f:	5d                   	pop    %ebp
  800b50:	c3                   	ret    

00800b51 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b60:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	01 d0                	add    %edx,%eax
  800b68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b76:	74 06                	je     800b7e <vsnprintf+0x2d>
  800b78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b7c:	7f 07                	jg     800b85 <vsnprintf+0x34>
		return -E_INVAL;
  800b7e:	b8 03 00 00 00       	mov    $0x3,%eax
  800b83:	eb 20                	jmp    800ba5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b85:	ff 75 14             	pushl  0x14(%ebp)
  800b88:	ff 75 10             	pushl  0x10(%ebp)
  800b8b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b8e:	50                   	push   %eax
  800b8f:	68 1b 0b 80 00       	push   $0x800b1b
  800b94:	e8 80 fb ff ff       	call   800719 <vprintfmt>
  800b99:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b9f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ba5:	c9                   	leave  
  800ba6:	c3                   	ret    

00800ba7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bad:	8d 45 10             	lea    0x10(%ebp),%eax
  800bb0:	83 c0 04             	add    $0x4,%eax
  800bb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bbc:	50                   	push   %eax
  800bbd:	ff 75 0c             	pushl  0xc(%ebp)
  800bc0:	ff 75 08             	pushl  0x8(%ebp)
  800bc3:	e8 89 ff ff ff       	call   800b51 <vsnprintf>
  800bc8:	83 c4 10             	add    $0x10,%esp
  800bcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bd1:	c9                   	leave  
  800bd2:	c3                   	ret    

00800bd3 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be0:	eb 06                	jmp    800be8 <strlen+0x15>
		n++;
  800be2:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800be5:	ff 45 08             	incl   0x8(%ebp)
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	8a 00                	mov    (%eax),%al
  800bed:	84 c0                	test   %al,%al
  800bef:	75 f1                	jne    800be2 <strlen+0xf>
		n++;
	return n;
  800bf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf4:	c9                   	leave  
  800bf5:	c3                   	ret    

00800bf6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bfc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c03:	eb 09                	jmp    800c0e <strnlen+0x18>
		n++;
  800c05:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c08:	ff 45 08             	incl   0x8(%ebp)
  800c0b:	ff 4d 0c             	decl   0xc(%ebp)
  800c0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c12:	74 09                	je     800c1d <strnlen+0x27>
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	8a 00                	mov    (%eax),%al
  800c19:	84 c0                	test   %al,%al
  800c1b:	75 e8                	jne    800c05 <strnlen+0xf>
		n++;
	return n;
  800c1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c20:	c9                   	leave  
  800c21:	c3                   	ret    

00800c22 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c2e:	90                   	nop
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	8d 50 01             	lea    0x1(%eax),%edx
  800c35:	89 55 08             	mov    %edx,0x8(%ebp)
  800c38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c3e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c41:	8a 12                	mov    (%edx),%dl
  800c43:	88 10                	mov    %dl,(%eax)
  800c45:	8a 00                	mov    (%eax),%al
  800c47:	84 c0                	test   %al,%al
  800c49:	75 e4                	jne    800c2f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c4e:	c9                   	leave  
  800c4f:	c3                   	ret    

00800c50 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
  800c53:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c63:	eb 1f                	jmp    800c84 <strncpy+0x34>
		*dst++ = *src;
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	8d 50 01             	lea    0x1(%eax),%edx
  800c6b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c71:	8a 12                	mov    (%edx),%dl
  800c73:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c78:	8a 00                	mov    (%eax),%al
  800c7a:	84 c0                	test   %al,%al
  800c7c:	74 03                	je     800c81 <strncpy+0x31>
			src++;
  800c7e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c81:	ff 45 fc             	incl   -0x4(%ebp)
  800c84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c87:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c8a:	72 d9                	jb     800c65 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c8f:	c9                   	leave  
  800c90:	c3                   	ret    

00800c91 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca1:	74 30                	je     800cd3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ca3:	eb 16                	jmp    800cbb <strlcpy+0x2a>
			*dst++ = *src++;
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	8d 50 01             	lea    0x1(%eax),%edx
  800cab:	89 55 08             	mov    %edx,0x8(%ebp)
  800cae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cb7:	8a 12                	mov    (%edx),%dl
  800cb9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cbb:	ff 4d 10             	decl   0x10(%ebp)
  800cbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc2:	74 09                	je     800ccd <strlcpy+0x3c>
  800cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc7:	8a 00                	mov    (%eax),%al
  800cc9:	84 c0                	test   %al,%al
  800ccb:	75 d8                	jne    800ca5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd9:	29 c2                	sub    %eax,%edx
  800cdb:	89 d0                	mov    %edx,%eax
}
  800cdd:	c9                   	leave  
  800cde:	c3                   	ret    

00800cdf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ce2:	eb 06                	jmp    800cea <strcmp+0xb>
		p++, q++;
  800ce4:	ff 45 08             	incl   0x8(%ebp)
  800ce7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	8a 00                	mov    (%eax),%al
  800cef:	84 c0                	test   %al,%al
  800cf1:	74 0e                	je     800d01 <strcmp+0x22>
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	8a 10                	mov    (%eax),%dl
  800cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfb:	8a 00                	mov    (%eax),%al
  800cfd:	38 c2                	cmp    %al,%dl
  800cff:	74 e3                	je     800ce4 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	8a 00                	mov    (%eax),%al
  800d06:	0f b6 d0             	movzbl %al,%edx
  800d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0c:	8a 00                	mov    (%eax),%al
  800d0e:	0f b6 c0             	movzbl %al,%eax
  800d11:	29 c2                	sub    %eax,%edx
  800d13:	89 d0                	mov    %edx,%eax
}
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    

00800d17 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d1a:	eb 09                	jmp    800d25 <strncmp+0xe>
		n--, p++, q++;
  800d1c:	ff 4d 10             	decl   0x10(%ebp)
  800d1f:	ff 45 08             	incl   0x8(%ebp)
  800d22:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d29:	74 17                	je     800d42 <strncmp+0x2b>
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	84 c0                	test   %al,%al
  800d32:	74 0e                	je     800d42 <strncmp+0x2b>
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 10                	mov    (%eax),%dl
  800d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	38 c2                	cmp    %al,%dl
  800d40:	74 da                	je     800d1c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d46:	75 07                	jne    800d4f <strncmp+0x38>
		return 0;
  800d48:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4d:	eb 14                	jmp    800d63 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	8a 00                	mov    (%eax),%al
  800d54:	0f b6 d0             	movzbl %al,%edx
  800d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5a:	8a 00                	mov    (%eax),%al
  800d5c:	0f b6 c0             	movzbl %al,%eax
  800d5f:	29 c2                	sub    %eax,%edx
  800d61:	89 d0                	mov    %edx,%eax
}
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    

00800d65 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	83 ec 04             	sub    $0x4,%esp
  800d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d71:	eb 12                	jmp    800d85 <strchr+0x20>
		if (*s == c)
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d7b:	75 05                	jne    800d82 <strchr+0x1d>
			return (char *) s;
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	eb 11                	jmp    800d93 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d82:	ff 45 08             	incl   0x8(%ebp)
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	84 c0                	test   %al,%al
  800d8c:	75 e5                	jne    800d73 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d93:	c9                   	leave  
  800d94:	c3                   	ret    

00800d95 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	83 ec 04             	sub    $0x4,%esp
  800d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da1:	eb 0d                	jmp    800db0 <strfind+0x1b>
		if (*s == c)
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dab:	74 0e                	je     800dbb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dad:	ff 45 08             	incl   0x8(%ebp)
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	8a 00                	mov    (%eax),%al
  800db5:	84 c0                	test   %al,%al
  800db7:	75 ea                	jne    800da3 <strfind+0xe>
  800db9:	eb 01                	jmp    800dbc <strfind+0x27>
		if (*s == c)
			break;
  800dbb:	90                   	nop
	return (char *) s;
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dbf:	c9                   	leave  
  800dc0:	c3                   	ret    

00800dc1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dd3:	eb 0e                	jmp    800de3 <memset+0x22>
		*p++ = c;
  800dd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd8:	8d 50 01             	lea    0x1(%eax),%edx
  800ddb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dde:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de1:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800de3:	ff 4d f8             	decl   -0x8(%ebp)
  800de6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dea:	79 e9                	jns    800dd5 <memset+0x14>
		*p++ = c;

	return v;
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800def:	c9                   	leave  
  800df0:	c3                   	ret    

00800df1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800df7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e03:	eb 16                	jmp    800e1b <memcpy+0x2a>
		*d++ = *s++;
  800e05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e08:	8d 50 01             	lea    0x1(%eax),%edx
  800e0b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e0e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e11:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e14:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e17:	8a 12                	mov    (%edx),%dl
  800e19:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e21:	89 55 10             	mov    %edx,0x10(%ebp)
  800e24:	85 c0                	test   %eax,%eax
  800e26:	75 dd                	jne    800e05 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e45:	73 50                	jae    800e97 <memmove+0x6a>
  800e47:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4d:	01 d0                	add    %edx,%eax
  800e4f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e52:	76 43                	jbe    800e97 <memmove+0x6a>
		s += n;
  800e54:	8b 45 10             	mov    0x10(%ebp),%eax
  800e57:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e60:	eb 10                	jmp    800e72 <memmove+0x45>
			*--d = *--s;
  800e62:	ff 4d f8             	decl   -0x8(%ebp)
  800e65:	ff 4d fc             	decl   -0x4(%ebp)
  800e68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e6b:	8a 10                	mov    (%eax),%dl
  800e6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e70:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e72:	8b 45 10             	mov    0x10(%ebp),%eax
  800e75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e78:	89 55 10             	mov    %edx,0x10(%ebp)
  800e7b:	85 c0                	test   %eax,%eax
  800e7d:	75 e3                	jne    800e62 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e7f:	eb 23                	jmp    800ea4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e84:	8d 50 01             	lea    0x1(%eax),%edx
  800e87:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e8d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e90:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e93:	8a 12                	mov    (%edx),%dl
  800e95:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e97:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea0:	85 c0                	test   %eax,%eax
  800ea2:	75 dd                	jne    800e81 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ea4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea7:	c9                   	leave  
  800ea8:	c3                   	ret    

00800ea9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ea9:	55                   	push   %ebp
  800eaa:	89 e5                	mov    %esp,%ebp
  800eac:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ebb:	eb 2a                	jmp    800ee7 <memcmp+0x3e>
		if (*s1 != *s2)
  800ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec0:	8a 10                	mov    (%eax),%dl
  800ec2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec5:	8a 00                	mov    (%eax),%al
  800ec7:	38 c2                	cmp    %al,%dl
  800ec9:	74 16                	je     800ee1 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ecb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ece:	8a 00                	mov    (%eax),%al
  800ed0:	0f b6 d0             	movzbl %al,%edx
  800ed3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed6:	8a 00                	mov    (%eax),%al
  800ed8:	0f b6 c0             	movzbl %al,%eax
  800edb:	29 c2                	sub    %eax,%edx
  800edd:	89 d0                	mov    %edx,%eax
  800edf:	eb 18                	jmp    800ef9 <memcmp+0x50>
		s1++, s2++;
  800ee1:	ff 45 fc             	incl   -0x4(%ebp)
  800ee4:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ee7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eea:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eed:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef0:	85 c0                	test   %eax,%eax
  800ef2:	75 c9                	jne    800ebd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ef4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef9:	c9                   	leave  
  800efa:	c3                   	ret    

00800efb <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f01:	8b 55 08             	mov    0x8(%ebp),%edx
  800f04:	8b 45 10             	mov    0x10(%ebp),%eax
  800f07:	01 d0                	add    %edx,%eax
  800f09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f0c:	eb 15                	jmp    800f23 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f11:	8a 00                	mov    (%eax),%al
  800f13:	0f b6 d0             	movzbl %al,%edx
  800f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f19:	0f b6 c0             	movzbl %al,%eax
  800f1c:	39 c2                	cmp    %eax,%edx
  800f1e:	74 0d                	je     800f2d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f20:	ff 45 08             	incl   0x8(%ebp)
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f29:	72 e3                	jb     800f0e <memfind+0x13>
  800f2b:	eb 01                	jmp    800f2e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f2d:	90                   	nop
	return (void *) s;
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f31:	c9                   	leave  
  800f32:	c3                   	ret    

00800f33 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f40:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f47:	eb 03                	jmp    800f4c <strtol+0x19>
		s++;
  800f49:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	8a 00                	mov    (%eax),%al
  800f51:	3c 20                	cmp    $0x20,%al
  800f53:	74 f4                	je     800f49 <strtol+0x16>
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	3c 09                	cmp    $0x9,%al
  800f5c:	74 eb                	je     800f49 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	3c 2b                	cmp    $0x2b,%al
  800f65:	75 05                	jne    800f6c <strtol+0x39>
		s++;
  800f67:	ff 45 08             	incl   0x8(%ebp)
  800f6a:	eb 13                	jmp    800f7f <strtol+0x4c>
	else if (*s == '-')
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	3c 2d                	cmp    $0x2d,%al
  800f73:	75 0a                	jne    800f7f <strtol+0x4c>
		s++, neg = 1;
  800f75:	ff 45 08             	incl   0x8(%ebp)
  800f78:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f83:	74 06                	je     800f8b <strtol+0x58>
  800f85:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f89:	75 20                	jne    800fab <strtol+0x78>
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8e:	8a 00                	mov    (%eax),%al
  800f90:	3c 30                	cmp    $0x30,%al
  800f92:	75 17                	jne    800fab <strtol+0x78>
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	40                   	inc    %eax
  800f98:	8a 00                	mov    (%eax),%al
  800f9a:	3c 78                	cmp    $0x78,%al
  800f9c:	75 0d                	jne    800fab <strtol+0x78>
		s += 2, base = 16;
  800f9e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fa2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fa9:	eb 28                	jmp    800fd3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800faf:	75 15                	jne    800fc6 <strtol+0x93>
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	8a 00                	mov    (%eax),%al
  800fb6:	3c 30                	cmp    $0x30,%al
  800fb8:	75 0c                	jne    800fc6 <strtol+0x93>
		s++, base = 8;
  800fba:	ff 45 08             	incl   0x8(%ebp)
  800fbd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fc4:	eb 0d                	jmp    800fd3 <strtol+0xa0>
	else if (base == 0)
  800fc6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fca:	75 07                	jne    800fd3 <strtol+0xa0>
		base = 10;
  800fcc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	3c 2f                	cmp    $0x2f,%al
  800fda:	7e 19                	jle    800ff5 <strtol+0xc2>
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	3c 39                	cmp    $0x39,%al
  800fe3:	7f 10                	jg     800ff5 <strtol+0xc2>
			dig = *s - '0';
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	0f be c0             	movsbl %al,%eax
  800fed:	83 e8 30             	sub    $0x30,%eax
  800ff0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ff3:	eb 42                	jmp    801037 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	3c 60                	cmp    $0x60,%al
  800ffc:	7e 19                	jle    801017 <strtol+0xe4>
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	3c 7a                	cmp    $0x7a,%al
  801005:	7f 10                	jg     801017 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	0f be c0             	movsbl %al,%eax
  80100f:	83 e8 57             	sub    $0x57,%eax
  801012:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801015:	eb 20                	jmp    801037 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	8a 00                	mov    (%eax),%al
  80101c:	3c 40                	cmp    $0x40,%al
  80101e:	7e 39                	jle    801059 <strtol+0x126>
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	3c 5a                	cmp    $0x5a,%al
  801027:	7f 30                	jg     801059 <strtol+0x126>
			dig = *s - 'A' + 10;
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	0f be c0             	movsbl %al,%eax
  801031:	83 e8 37             	sub    $0x37,%eax
  801034:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80103a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80103d:	7d 19                	jge    801058 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80103f:	ff 45 08             	incl   0x8(%ebp)
  801042:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801045:	0f af 45 10          	imul   0x10(%ebp),%eax
  801049:	89 c2                	mov    %eax,%edx
  80104b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80104e:	01 d0                	add    %edx,%eax
  801050:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801053:	e9 7b ff ff ff       	jmp    800fd3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801058:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801059:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80105d:	74 08                	je     801067 <strtol+0x134>
		*endptr = (char *) s;
  80105f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801062:	8b 55 08             	mov    0x8(%ebp),%edx
  801065:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801067:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80106b:	74 07                	je     801074 <strtol+0x141>
  80106d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801070:	f7 d8                	neg    %eax
  801072:	eb 03                	jmp    801077 <strtol+0x144>
  801074:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801077:	c9                   	leave  
  801078:	c3                   	ret    

00801079 <ltostr>:

void
ltostr(long value, char *str)
{
  801079:	55                   	push   %ebp
  80107a:	89 e5                	mov    %esp,%ebp
  80107c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80107f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801086:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80108d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801091:	79 13                	jns    8010a6 <ltostr+0x2d>
	{
		neg = 1;
  801093:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80109a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010a0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010a3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010ae:	99                   	cltd   
  8010af:	f7 f9                	idiv   %ecx
  8010b1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b7:	8d 50 01             	lea    0x1(%eax),%edx
  8010ba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010bd:	89 c2                	mov    %eax,%edx
  8010bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c2:	01 d0                	add    %edx,%eax
  8010c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010c7:	83 c2 30             	add    $0x30,%edx
  8010ca:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010cf:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010d4:	f7 e9                	imul   %ecx
  8010d6:	c1 fa 02             	sar    $0x2,%edx
  8010d9:	89 c8                	mov    %ecx,%eax
  8010db:	c1 f8 1f             	sar    $0x1f,%eax
  8010de:	29 c2                	sub    %eax,%edx
  8010e0:	89 d0                	mov    %edx,%eax
  8010e2:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010e9:	75 bb                	jne    8010a6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f5:	48                   	dec    %eax
  8010f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010fd:	74 3d                	je     80113c <ltostr+0xc3>
		start = 1 ;
  8010ff:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801106:	eb 34                	jmp    80113c <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801108:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110e:	01 d0                	add    %edx,%eax
  801110:	8a 00                	mov    (%eax),%al
  801112:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801115:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111b:	01 c2                	add    %eax,%edx
  80111d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801120:	8b 45 0c             	mov    0xc(%ebp),%eax
  801123:	01 c8                	add    %ecx,%eax
  801125:	8a 00                	mov    (%eax),%al
  801127:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801129:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112f:	01 c2                	add    %eax,%edx
  801131:	8a 45 eb             	mov    -0x15(%ebp),%al
  801134:	88 02                	mov    %al,(%edx)
		start++ ;
  801136:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801139:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80113c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80113f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801142:	7c c4                	jl     801108 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801144:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801147:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114a:	01 d0                	add    %edx,%eax
  80114c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80114f:	90                   	nop
  801150:	c9                   	leave  
  801151:	c3                   	ret    

00801152 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801158:	ff 75 08             	pushl  0x8(%ebp)
  80115b:	e8 73 fa ff ff       	call   800bd3 <strlen>
  801160:	83 c4 04             	add    $0x4,%esp
  801163:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801166:	ff 75 0c             	pushl  0xc(%ebp)
  801169:	e8 65 fa ff ff       	call   800bd3 <strlen>
  80116e:	83 c4 04             	add    $0x4,%esp
  801171:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801174:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80117b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801182:	eb 17                	jmp    80119b <strcconcat+0x49>
		final[s] = str1[s] ;
  801184:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801187:	8b 45 10             	mov    0x10(%ebp),%eax
  80118a:	01 c2                	add    %eax,%edx
  80118c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	01 c8                	add    %ecx,%eax
  801194:	8a 00                	mov    (%eax),%al
  801196:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801198:	ff 45 fc             	incl   -0x4(%ebp)
  80119b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80119e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011a1:	7c e1                	jl     801184 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011b1:	eb 1f                	jmp    8011d2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b6:	8d 50 01             	lea    0x1(%eax),%edx
  8011b9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011bc:	89 c2                	mov    %eax,%edx
  8011be:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c1:	01 c2                	add    %eax,%edx
  8011c3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c9:	01 c8                	add    %ecx,%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011cf:	ff 45 f8             	incl   -0x8(%ebp)
  8011d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d8:	7c d9                	jl     8011b3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e0:	01 d0                	add    %edx,%eax
  8011e2:	c6 00 00             	movb   $0x0,(%eax)
}
  8011e5:	90                   	nop
  8011e6:	c9                   	leave  
  8011e7:	c3                   	ret    

008011e8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f7:	8b 00                	mov    (%eax),%eax
  8011f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801200:	8b 45 10             	mov    0x10(%ebp),%eax
  801203:	01 d0                	add    %edx,%eax
  801205:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120b:	eb 0c                	jmp    801219 <strsplit+0x31>
			*string++ = 0;
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	8d 50 01             	lea    0x1(%eax),%edx
  801213:	89 55 08             	mov    %edx,0x8(%ebp)
  801216:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8a 00                	mov    (%eax),%al
  80121e:	84 c0                	test   %al,%al
  801220:	74 18                	je     80123a <strsplit+0x52>
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
  801225:	8a 00                	mov    (%eax),%al
  801227:	0f be c0             	movsbl %al,%eax
  80122a:	50                   	push   %eax
  80122b:	ff 75 0c             	pushl  0xc(%ebp)
  80122e:	e8 32 fb ff ff       	call   800d65 <strchr>
  801233:	83 c4 08             	add    $0x8,%esp
  801236:	85 c0                	test   %eax,%eax
  801238:	75 d3                	jne    80120d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	8a 00                	mov    (%eax),%al
  80123f:	84 c0                	test   %al,%al
  801241:	74 5a                	je     80129d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801243:	8b 45 14             	mov    0x14(%ebp),%eax
  801246:	8b 00                	mov    (%eax),%eax
  801248:	83 f8 0f             	cmp    $0xf,%eax
  80124b:	75 07                	jne    801254 <strsplit+0x6c>
		{
			return 0;
  80124d:	b8 00 00 00 00       	mov    $0x0,%eax
  801252:	eb 66                	jmp    8012ba <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801254:	8b 45 14             	mov    0x14(%ebp),%eax
  801257:	8b 00                	mov    (%eax),%eax
  801259:	8d 48 01             	lea    0x1(%eax),%ecx
  80125c:	8b 55 14             	mov    0x14(%ebp),%edx
  80125f:	89 0a                	mov    %ecx,(%edx)
  801261:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801268:	8b 45 10             	mov    0x10(%ebp),%eax
  80126b:	01 c2                	add    %eax,%edx
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801272:	eb 03                	jmp    801277 <strsplit+0x8f>
			string++;
  801274:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	8a 00                	mov    (%eax),%al
  80127c:	84 c0                	test   %al,%al
  80127e:	74 8b                	je     80120b <strsplit+0x23>
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	8a 00                	mov    (%eax),%al
  801285:	0f be c0             	movsbl %al,%eax
  801288:	50                   	push   %eax
  801289:	ff 75 0c             	pushl  0xc(%ebp)
  80128c:	e8 d4 fa ff ff       	call   800d65 <strchr>
  801291:	83 c4 08             	add    $0x8,%esp
  801294:	85 c0                	test   %eax,%eax
  801296:	74 dc                	je     801274 <strsplit+0x8c>
			string++;
	}
  801298:	e9 6e ff ff ff       	jmp    80120b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80129d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80129e:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a1:	8b 00                	mov    (%eax),%eax
  8012a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ad:	01 d0                	add    %edx,%eax
  8012af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012ba:	c9                   	leave  
  8012bb:	c3                   	ret    

008012bc <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8012c2:	83 ec 04             	sub    $0x4,%esp
  8012c5:	68 88 42 80 00       	push   $0x804288
  8012ca:	68 3f 01 00 00       	push   $0x13f
  8012cf:	68 aa 42 80 00       	push   $0x8042aa
  8012d4:	e8 a9 ef ff ff       	call   800282 <_panic>

008012d9 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8012d9:	55                   	push   %ebp
  8012da:	89 e5                	mov    %esp,%ebp
  8012dc:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8012df:	83 ec 0c             	sub    $0xc,%esp
  8012e2:	ff 75 08             	pushl  0x8(%ebp)
  8012e5:	e8 35 0a 00 00       	call   801d1f <sys_sbrk>
  8012ea:	83 c4 10             	add    $0x10,%esp
}
  8012ed:	c9                   	leave  
  8012ee:	c3                   	ret    

008012ef <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8012f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012f9:	75 0a                	jne    801305 <malloc+0x16>
  8012fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801300:	e9 07 02 00 00       	jmp    80150c <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801305:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80130c:	8b 55 08             	mov    0x8(%ebp),%edx
  80130f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801312:	01 d0                	add    %edx,%eax
  801314:	48                   	dec    %eax
  801315:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801318:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80131b:	ba 00 00 00 00       	mov    $0x0,%edx
  801320:	f7 75 dc             	divl   -0x24(%ebp)
  801323:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801326:	29 d0                	sub    %edx,%eax
  801328:	c1 e8 0c             	shr    $0xc,%eax
  80132b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  80132e:	a1 20 50 80 00       	mov    0x805020,%eax
  801333:	8b 40 78             	mov    0x78(%eax),%eax
  801336:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80133b:	29 c2                	sub    %eax,%edx
  80133d:	89 d0                	mov    %edx,%eax
  80133f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801342:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801345:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80134a:	c1 e8 0c             	shr    $0xc,%eax
  80134d:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801350:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801357:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80135e:	77 42                	ja     8013a2 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801360:	e8 3e 08 00 00       	call   801ba3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801365:	85 c0                	test   %eax,%eax
  801367:	74 16                	je     80137f <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801369:	83 ec 0c             	sub    $0xc,%esp
  80136c:	ff 75 08             	pushl  0x8(%ebp)
  80136f:	e8 7e 0d 00 00       	call   8020f2 <alloc_block_FF>
  801374:	83 c4 10             	add    $0x10,%esp
  801377:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80137a:	e9 8a 01 00 00       	jmp    801509 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80137f:	e8 50 08 00 00       	call   801bd4 <sys_isUHeapPlacementStrategyBESTFIT>
  801384:	85 c0                	test   %eax,%eax
  801386:	0f 84 7d 01 00 00    	je     801509 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80138c:	83 ec 0c             	sub    $0xc,%esp
  80138f:	ff 75 08             	pushl  0x8(%ebp)
  801392:	e8 17 12 00 00       	call   8025ae <alloc_block_BF>
  801397:	83 c4 10             	add    $0x10,%esp
  80139a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80139d:	e9 67 01 00 00       	jmp    801509 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  8013a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8013a5:	48                   	dec    %eax
  8013a6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8013a9:	0f 86 53 01 00 00    	jbe    801502 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  8013af:	a1 20 50 80 00       	mov    0x805020,%eax
  8013b4:	8b 40 78             	mov    0x78(%eax),%eax
  8013b7:	05 00 10 00 00       	add    $0x1000,%eax
  8013bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  8013bf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  8013c6:	e9 de 00 00 00       	jmp    8014a9 <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  8013cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8013d0:	8b 40 78             	mov    0x78(%eax),%eax
  8013d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013d6:	29 c2                	sub    %eax,%edx
  8013d8:	89 d0                	mov    %edx,%eax
  8013da:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013df:	c1 e8 0c             	shr    $0xc,%eax
  8013e2:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8013e9:	85 c0                	test   %eax,%eax
  8013eb:	0f 85 ab 00 00 00    	jne    80149c <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  8013f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f4:	05 00 10 00 00       	add    $0x1000,%eax
  8013f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  8013fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801403:	eb 47                	jmp    80144c <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801405:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80140c:	76 0a                	jbe    801418 <malloc+0x129>
  80140e:	b8 00 00 00 00       	mov    $0x0,%eax
  801413:	e9 f4 00 00 00       	jmp    80150c <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801418:	a1 20 50 80 00       	mov    0x805020,%eax
  80141d:	8b 40 78             	mov    0x78(%eax),%eax
  801420:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801423:	29 c2                	sub    %eax,%edx
  801425:	89 d0                	mov    %edx,%eax
  801427:	2d 00 10 00 00       	sub    $0x1000,%eax
  80142c:	c1 e8 0c             	shr    $0xc,%eax
  80142f:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801436:	85 c0                	test   %eax,%eax
  801438:	74 08                	je     801442 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  80143a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80143d:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801440:	eb 5a                	jmp    80149c <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801442:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801449:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  80144c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80144f:	48                   	dec    %eax
  801450:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801453:	77 b0                	ja     801405 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801455:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  80145c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801463:	eb 2f                	jmp    801494 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801465:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801468:	c1 e0 0c             	shl    $0xc,%eax
  80146b:	89 c2                	mov    %eax,%edx
  80146d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801470:	01 c2                	add    %eax,%edx
  801472:	a1 20 50 80 00       	mov    0x805020,%eax
  801477:	8b 40 78             	mov    0x78(%eax),%eax
  80147a:	29 c2                	sub    %eax,%edx
  80147c:	89 d0                	mov    %edx,%eax
  80147e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801483:	c1 e8 0c             	shr    $0xc,%eax
  801486:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
  80148d:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801491:	ff 45 e0             	incl   -0x20(%ebp)
  801494:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801497:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80149a:	72 c9                	jb     801465 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  80149c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014a0:	75 16                	jne    8014b8 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8014a2:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8014a9:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8014b0:	0f 86 15 ff ff ff    	jbe    8013cb <malloc+0xdc>
  8014b6:	eb 01                	jmp    8014b9 <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8014b8:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  8014b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014bd:	75 07                	jne    8014c6 <malloc+0x1d7>
  8014bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c4:	eb 46                	jmp    80150c <malloc+0x21d>
		ptr = (void*)i;
  8014c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  8014cc:	a1 20 50 80 00       	mov    0x805020,%eax
  8014d1:	8b 40 78             	mov    0x78(%eax),%eax
  8014d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014d7:	29 c2                	sub    %eax,%edx
  8014d9:	89 d0                	mov    %edx,%eax
  8014db:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014e0:	c1 e8 0c             	shr    $0xc,%eax
  8014e3:	89 c2                	mov    %eax,%edx
  8014e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8014e8:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8014ef:	83 ec 08             	sub    $0x8,%esp
  8014f2:	ff 75 08             	pushl  0x8(%ebp)
  8014f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8014f8:	e8 59 08 00 00       	call   801d56 <sys_allocate_user_mem>
  8014fd:	83 c4 10             	add    $0x10,%esp
  801500:	eb 07                	jmp    801509 <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801502:	b8 00 00 00 00       	mov    $0x0,%eax
  801507:	eb 03                	jmp    80150c <malloc+0x21d>
	}
	return ptr;
  801509:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

0080150e <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
  801511:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801514:	a1 20 50 80 00       	mov    0x805020,%eax
  801519:	8b 40 78             	mov    0x78(%eax),%eax
  80151c:	05 00 10 00 00       	add    $0x1000,%eax
  801521:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801524:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  80152b:	a1 20 50 80 00       	mov    0x805020,%eax
  801530:	8b 50 78             	mov    0x78(%eax),%edx
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	39 c2                	cmp    %eax,%edx
  801538:	76 24                	jbe    80155e <free+0x50>
		size = get_block_size(va);
  80153a:	83 ec 0c             	sub    $0xc,%esp
  80153d:	ff 75 08             	pushl  0x8(%ebp)
  801540:	e8 2d 08 00 00       	call   801d72 <get_block_size>
  801545:	83 c4 10             	add    $0x10,%esp
  801548:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80154b:	83 ec 0c             	sub    $0xc,%esp
  80154e:	ff 75 08             	pushl  0x8(%ebp)
  801551:	e8 60 1a 00 00       	call   802fb6 <free_block>
  801556:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801559:	e9 ac 00 00 00       	jmp    80160a <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  80155e:	8b 45 08             	mov    0x8(%ebp),%eax
  801561:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801564:	0f 82 89 00 00 00    	jb     8015f3 <free+0xe5>
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801572:	77 7f                	ja     8015f3 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801574:	8b 55 08             	mov    0x8(%ebp),%edx
  801577:	a1 20 50 80 00       	mov    0x805020,%eax
  80157c:	8b 40 78             	mov    0x78(%eax),%eax
  80157f:	29 c2                	sub    %eax,%edx
  801581:	89 d0                	mov    %edx,%eax
  801583:	2d 00 10 00 00       	sub    $0x1000,%eax
  801588:	c1 e8 0c             	shr    $0xc,%eax
  80158b:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801592:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801595:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801598:	c1 e0 0c             	shl    $0xc,%eax
  80159b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  80159e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8015a5:	eb 2f                	jmp    8015d6 <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  8015a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015aa:	c1 e0 0c             	shl    $0xc,%eax
  8015ad:	89 c2                	mov    %eax,%edx
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	01 c2                	add    %eax,%edx
  8015b4:	a1 20 50 80 00       	mov    0x805020,%eax
  8015b9:	8b 40 78             	mov    0x78(%eax),%eax
  8015bc:	29 c2                	sub    %eax,%edx
  8015be:	89 d0                	mov    %edx,%eax
  8015c0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015c5:	c1 e8 0c             	shr    $0xc,%eax
  8015c8:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
  8015cf:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8015d3:	ff 45 f4             	incl   -0xc(%ebp)
  8015d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8015dc:	72 c9                	jb     8015a7 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  8015de:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e1:	83 ec 08             	sub    $0x8,%esp
  8015e4:	ff 75 ec             	pushl  -0x14(%ebp)
  8015e7:	50                   	push   %eax
  8015e8:	e8 4d 07 00 00       	call   801d3a <sys_free_user_mem>
  8015ed:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8015f0:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  8015f1:	eb 17                	jmp    80160a <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  8015f3:	83 ec 04             	sub    $0x4,%esp
  8015f6:	68 b8 42 80 00       	push   $0x8042b8
  8015fb:	68 84 00 00 00       	push   $0x84
  801600:	68 e2 42 80 00       	push   $0x8042e2
  801605:	e8 78 ec ff ff       	call   800282 <_panic>
	}
}
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	83 ec 28             	sub    $0x28,%esp
  801612:	8b 45 10             	mov    0x10(%ebp),%eax
  801615:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801618:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80161c:	75 07                	jne    801625 <smalloc+0x19>
  80161e:	b8 00 00 00 00       	mov    $0x0,%eax
  801623:	eb 74                	jmp    801699 <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801625:	8b 45 0c             	mov    0xc(%ebp),%eax
  801628:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80162b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801632:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801638:	39 d0                	cmp    %edx,%eax
  80163a:	73 02                	jae    80163e <smalloc+0x32>
  80163c:	89 d0                	mov    %edx,%eax
  80163e:	83 ec 0c             	sub    $0xc,%esp
  801641:	50                   	push   %eax
  801642:	e8 a8 fc ff ff       	call   8012ef <malloc>
  801647:	83 c4 10             	add    $0x10,%esp
  80164a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  80164d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801651:	75 07                	jne    80165a <smalloc+0x4e>
  801653:	b8 00 00 00 00       	mov    $0x0,%eax
  801658:	eb 3f                	jmp    801699 <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80165a:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80165e:	ff 75 ec             	pushl  -0x14(%ebp)
  801661:	50                   	push   %eax
  801662:	ff 75 0c             	pushl  0xc(%ebp)
  801665:	ff 75 08             	pushl  0x8(%ebp)
  801668:	e8 d4 02 00 00       	call   801941 <sys_createSharedObject>
  80166d:	83 c4 10             	add    $0x10,%esp
  801670:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801673:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801677:	74 06                	je     80167f <smalloc+0x73>
  801679:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80167d:	75 07                	jne    801686 <smalloc+0x7a>
  80167f:	b8 00 00 00 00       	mov    $0x0,%eax
  801684:	eb 13                	jmp    801699 <smalloc+0x8d>
	 cprintf("153\n");
  801686:	83 ec 0c             	sub    $0xc,%esp
  801689:	68 ee 42 80 00       	push   $0x8042ee
  80168e:	e8 ac ee ff ff       	call   80053f <cprintf>
  801693:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  801696:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
  80169e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8016a1:	83 ec 04             	sub    $0x4,%esp
  8016a4:	68 f4 42 80 00       	push   $0x8042f4
  8016a9:	68 a4 00 00 00       	push   $0xa4
  8016ae:	68 e2 42 80 00       	push   $0x8042e2
  8016b3:	e8 ca eb ff ff       	call   800282 <_panic>

008016b8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
  8016bb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016be:	83 ec 04             	sub    $0x4,%esp
  8016c1:	68 18 43 80 00       	push   $0x804318
  8016c6:	68 bc 00 00 00       	push   $0xbc
  8016cb:	68 e2 42 80 00       	push   $0x8042e2
  8016d0:	e8 ad eb ff ff       	call   800282 <_panic>

008016d5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
  8016d8:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016db:	83 ec 04             	sub    $0x4,%esp
  8016de:	68 3c 43 80 00       	push   $0x80433c
  8016e3:	68 d3 00 00 00       	push   $0xd3
  8016e8:	68 e2 42 80 00       	push   $0x8042e2
  8016ed:	e8 90 eb ff ff       	call   800282 <_panic>

008016f2 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
  8016f5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016f8:	83 ec 04             	sub    $0x4,%esp
  8016fb:	68 62 43 80 00       	push   $0x804362
  801700:	68 df 00 00 00       	push   $0xdf
  801705:	68 e2 42 80 00       	push   $0x8042e2
  80170a:	e8 73 eb ff ff       	call   800282 <_panic>

0080170f <shrink>:

}
void shrink(uint32 newSize)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
  801712:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801715:	83 ec 04             	sub    $0x4,%esp
  801718:	68 62 43 80 00       	push   $0x804362
  80171d:	68 e4 00 00 00       	push   $0xe4
  801722:	68 e2 42 80 00       	push   $0x8042e2
  801727:	e8 56 eb ff ff       	call   800282 <_panic>

0080172c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
  80172f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801732:	83 ec 04             	sub    $0x4,%esp
  801735:	68 62 43 80 00       	push   $0x804362
  80173a:	68 e9 00 00 00       	push   $0xe9
  80173f:	68 e2 42 80 00       	push   $0x8042e2
  801744:	e8 39 eb ff ff       	call   800282 <_panic>

00801749 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
  80174c:	57                   	push   %edi
  80174d:	56                   	push   %esi
  80174e:	53                   	push   %ebx
  80174f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8b 55 0c             	mov    0xc(%ebp),%edx
  801758:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80175b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80175e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801761:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801764:	cd 30                	int    $0x30
  801766:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801769:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80176c:	83 c4 10             	add    $0x10,%esp
  80176f:	5b                   	pop    %ebx
  801770:	5e                   	pop    %esi
  801771:	5f                   	pop    %edi
  801772:	5d                   	pop    %ebp
  801773:	c3                   	ret    

00801774 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	83 ec 04             	sub    $0x4,%esp
  80177a:	8b 45 10             	mov    0x10(%ebp),%eax
  80177d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801780:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	52                   	push   %edx
  80178c:	ff 75 0c             	pushl  0xc(%ebp)
  80178f:	50                   	push   %eax
  801790:	6a 00                	push   $0x0
  801792:	e8 b2 ff ff ff       	call   801749 <syscall>
  801797:	83 c4 18             	add    $0x18,%esp
}
  80179a:	90                   	nop
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <sys_cgetc>:

int
sys_cgetc(void)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 02                	push   $0x2
  8017ac:	e8 98 ff ff ff       	call   801749 <syscall>
  8017b1:	83 c4 18             	add    $0x18,%esp
}
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 03                	push   $0x3
  8017c5:	e8 7f ff ff ff       	call   801749 <syscall>
  8017ca:	83 c4 18             	add    $0x18,%esp
}
  8017cd:	90                   	nop
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    

008017d0 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 04                	push   $0x4
  8017df:	e8 65 ff ff ff       	call   801749 <syscall>
  8017e4:	83 c4 18             	add    $0x18,%esp
}
  8017e7:	90                   	nop
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	52                   	push   %edx
  8017fa:	50                   	push   %eax
  8017fb:	6a 08                	push   $0x8
  8017fd:	e8 47 ff ff ff       	call   801749 <syscall>
  801802:	83 c4 18             	add    $0x18,%esp
}
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	56                   	push   %esi
  80180b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80180c:	8b 75 18             	mov    0x18(%ebp),%esi
  80180f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801812:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801815:	8b 55 0c             	mov    0xc(%ebp),%edx
  801818:	8b 45 08             	mov    0x8(%ebp),%eax
  80181b:	56                   	push   %esi
  80181c:	53                   	push   %ebx
  80181d:	51                   	push   %ecx
  80181e:	52                   	push   %edx
  80181f:	50                   	push   %eax
  801820:	6a 09                	push   $0x9
  801822:	e8 22 ff ff ff       	call   801749 <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
}
  80182a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80182d:	5b                   	pop    %ebx
  80182e:	5e                   	pop    %esi
  80182f:	5d                   	pop    %ebp
  801830:	c3                   	ret    

00801831 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801834:	8b 55 0c             	mov    0xc(%ebp),%edx
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	52                   	push   %edx
  801841:	50                   	push   %eax
  801842:	6a 0a                	push   $0xa
  801844:	e8 00 ff ff ff       	call   801749 <syscall>
  801849:	83 c4 18             	add    $0x18,%esp
}
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	ff 75 0c             	pushl  0xc(%ebp)
  80185a:	ff 75 08             	pushl  0x8(%ebp)
  80185d:	6a 0b                	push   $0xb
  80185f:	e8 e5 fe ff ff       	call   801749 <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 0c                	push   $0xc
  801878:	e8 cc fe ff ff       	call   801749 <syscall>
  80187d:	83 c4 18             	add    $0x18,%esp
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 0d                	push   $0xd
  801891:	e8 b3 fe ff ff       	call   801749 <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 0e                	push   $0xe
  8018aa:	e8 9a fe ff ff       	call   801749 <syscall>
  8018af:	83 c4 18             	add    $0x18,%esp
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 0f                	push   $0xf
  8018c3:	e8 81 fe ff ff       	call   801749 <syscall>
  8018c8:	83 c4 18             	add    $0x18,%esp
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	ff 75 08             	pushl  0x8(%ebp)
  8018db:	6a 10                	push   $0x10
  8018dd:	e8 67 fe ff ff       	call   801749 <syscall>
  8018e2:	83 c4 18             	add    $0x18,%esp
}
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 11                	push   $0x11
  8018f6:	e8 4e fe ff ff       	call   801749 <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
}
  8018fe:	90                   	nop
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <sys_cputc>:

void
sys_cputc(const char c)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
  801904:	83 ec 04             	sub    $0x4,%esp
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80190d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	50                   	push   %eax
  80191a:	6a 01                	push   $0x1
  80191c:	e8 28 fe ff ff       	call   801749 <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
}
  801924:	90                   	nop
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 14                	push   $0x14
  801936:	e8 0e fe ff ff       	call   801749 <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
}
  80193e:	90                   	nop
  80193f:	c9                   	leave  
  801940:	c3                   	ret    

00801941 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
  801944:	83 ec 04             	sub    $0x4,%esp
  801947:	8b 45 10             	mov    0x10(%ebp),%eax
  80194a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80194d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801950:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	6a 00                	push   $0x0
  801959:	51                   	push   %ecx
  80195a:	52                   	push   %edx
  80195b:	ff 75 0c             	pushl  0xc(%ebp)
  80195e:	50                   	push   %eax
  80195f:	6a 15                	push   $0x15
  801961:	e8 e3 fd ff ff       	call   801749 <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80196e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801971:	8b 45 08             	mov    0x8(%ebp),%eax
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	52                   	push   %edx
  80197b:	50                   	push   %eax
  80197c:	6a 16                	push   $0x16
  80197e:	e8 c6 fd ff ff       	call   801749 <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80198b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80198e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	51                   	push   %ecx
  801999:	52                   	push   %edx
  80199a:	50                   	push   %eax
  80199b:	6a 17                	push   $0x17
  80199d:	e8 a7 fd ff ff       	call   801749 <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	52                   	push   %edx
  8019b7:	50                   	push   %eax
  8019b8:	6a 18                	push   $0x18
  8019ba:	e8 8a fd ff ff       	call   801749 <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	6a 00                	push   $0x0
  8019cc:	ff 75 14             	pushl  0x14(%ebp)
  8019cf:	ff 75 10             	pushl  0x10(%ebp)
  8019d2:	ff 75 0c             	pushl  0xc(%ebp)
  8019d5:	50                   	push   %eax
  8019d6:	6a 19                	push   $0x19
  8019d8:	e8 6c fd ff ff       	call   801749 <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	50                   	push   %eax
  8019f1:	6a 1a                	push   $0x1a
  8019f3:	e8 51 fd ff ff       	call   801749 <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
}
  8019fb:	90                   	nop
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	50                   	push   %eax
  801a0d:	6a 1b                	push   $0x1b
  801a0f:	e8 35 fd ff ff       	call   801749 <syscall>
  801a14:	83 c4 18             	add    $0x18,%esp
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 05                	push   $0x5
  801a28:	e8 1c fd ff ff       	call   801749 <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 06                	push   $0x6
  801a41:	e8 03 fd ff ff       	call   801749 <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 07                	push   $0x7
  801a5a:	e8 ea fc ff ff       	call   801749 <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <sys_exit_env>:


void sys_exit_env(void)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 1c                	push   $0x1c
  801a73:	e8 d1 fc ff ff       	call   801749 <syscall>
  801a78:	83 c4 18             	add    $0x18,%esp
}
  801a7b:	90                   	nop
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
  801a81:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a84:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a87:	8d 50 04             	lea    0x4(%eax),%edx
  801a8a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	52                   	push   %edx
  801a94:	50                   	push   %eax
  801a95:	6a 1d                	push   $0x1d
  801a97:	e8 ad fc ff ff       	call   801749 <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
	return result;
  801a9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aa2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aa5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aa8:	89 01                	mov    %eax,(%ecx)
  801aaa:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	c9                   	leave  
  801ab1:	c2 04 00             	ret    $0x4

00801ab4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	ff 75 10             	pushl  0x10(%ebp)
  801abe:	ff 75 0c             	pushl  0xc(%ebp)
  801ac1:	ff 75 08             	pushl  0x8(%ebp)
  801ac4:	6a 13                	push   $0x13
  801ac6:	e8 7e fc ff ff       	call   801749 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ace:	90                   	nop
}
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 1e                	push   $0x1e
  801ae0:	e8 64 fc ff ff       	call   801749 <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
  801aed:	83 ec 04             	sub    $0x4,%esp
  801af0:	8b 45 08             	mov    0x8(%ebp),%eax
  801af3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801af6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	50                   	push   %eax
  801b03:	6a 1f                	push   $0x1f
  801b05:	e8 3f fc ff ff       	call   801749 <syscall>
  801b0a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0d:	90                   	nop
}
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <rsttst>:
void rsttst()
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 21                	push   $0x21
  801b1f:	e8 25 fc ff ff       	call   801749 <syscall>
  801b24:	83 c4 18             	add    $0x18,%esp
	return ;
  801b27:	90                   	nop
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
  801b2d:	83 ec 04             	sub    $0x4,%esp
  801b30:	8b 45 14             	mov    0x14(%ebp),%eax
  801b33:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b36:	8b 55 18             	mov    0x18(%ebp),%edx
  801b39:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b3d:	52                   	push   %edx
  801b3e:	50                   	push   %eax
  801b3f:	ff 75 10             	pushl  0x10(%ebp)
  801b42:	ff 75 0c             	pushl  0xc(%ebp)
  801b45:	ff 75 08             	pushl  0x8(%ebp)
  801b48:	6a 20                	push   $0x20
  801b4a:	e8 fa fb ff ff       	call   801749 <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b52:	90                   	nop
}
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <chktst>:
void chktst(uint32 n)
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	ff 75 08             	pushl  0x8(%ebp)
  801b63:	6a 22                	push   $0x22
  801b65:	e8 df fb ff ff       	call   801749 <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b6d:	90                   	nop
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <inctst>:

void inctst()
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 23                	push   $0x23
  801b7f:	e8 c5 fb ff ff       	call   801749 <syscall>
  801b84:	83 c4 18             	add    $0x18,%esp
	return ;
  801b87:	90                   	nop
}
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <gettst>:
uint32 gettst()
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 24                	push   $0x24
  801b99:	e8 ab fb ff ff       	call   801749 <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
}
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
  801ba6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 25                	push   $0x25
  801bb5:	e8 8f fb ff ff       	call   801749 <syscall>
  801bba:	83 c4 18             	add    $0x18,%esp
  801bbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bc0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bc4:	75 07                	jne    801bcd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bcb:	eb 05                	jmp    801bd2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
  801bd7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 25                	push   $0x25
  801be6:	e8 5e fb ff ff       	call   801749 <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
  801bee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bf1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bf5:	75 07                	jne    801bfe <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bf7:	b8 01 00 00 00       	mov    $0x1,%eax
  801bfc:	eb 05                	jmp    801c03 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 25                	push   $0x25
  801c17:	e8 2d fb ff ff       	call   801749 <syscall>
  801c1c:	83 c4 18             	add    $0x18,%esp
  801c1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c22:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c26:	75 07                	jne    801c2f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c28:	b8 01 00 00 00       	mov    $0x1,%eax
  801c2d:	eb 05                	jmp    801c34 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 25                	push   $0x25
  801c48:	e8 fc fa ff ff       	call   801749 <syscall>
  801c4d:	83 c4 18             	add    $0x18,%esp
  801c50:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c53:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c57:	75 07                	jne    801c60 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c59:	b8 01 00 00 00       	mov    $0x1,%eax
  801c5e:	eb 05                	jmp    801c65 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	ff 75 08             	pushl  0x8(%ebp)
  801c75:	6a 26                	push   $0x26
  801c77:	e8 cd fa ff ff       	call   801749 <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7f:	90                   	nop
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c86:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c89:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	6a 00                	push   $0x0
  801c94:	53                   	push   %ebx
  801c95:	51                   	push   %ecx
  801c96:	52                   	push   %edx
  801c97:	50                   	push   %eax
  801c98:	6a 27                	push   $0x27
  801c9a:	e8 aa fa ff ff       	call   801749 <syscall>
  801c9f:	83 c4 18             	add    $0x18,%esp
}
  801ca2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801caa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cad:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	52                   	push   %edx
  801cb7:	50                   	push   %eax
  801cb8:	6a 28                	push   $0x28
  801cba:	e8 8a fa ff ff       	call   801749 <syscall>
  801cbf:	83 c4 18             	add    $0x18,%esp
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801cc7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd0:	6a 00                	push   $0x0
  801cd2:	51                   	push   %ecx
  801cd3:	ff 75 10             	pushl  0x10(%ebp)
  801cd6:	52                   	push   %edx
  801cd7:	50                   	push   %eax
  801cd8:	6a 29                	push   $0x29
  801cda:	e8 6a fa ff ff       	call   801749 <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
}
  801ce2:	c9                   	leave  
  801ce3:	c3                   	ret    

00801ce4 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	ff 75 10             	pushl  0x10(%ebp)
  801cee:	ff 75 0c             	pushl  0xc(%ebp)
  801cf1:	ff 75 08             	pushl  0x8(%ebp)
  801cf4:	6a 12                	push   $0x12
  801cf6:	e8 4e fa ff ff       	call   801749 <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfe:	90                   	nop
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d07:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	52                   	push   %edx
  801d11:	50                   	push   %eax
  801d12:	6a 2a                	push   $0x2a
  801d14:	e8 30 fa ff ff       	call   801749 <syscall>
  801d19:	83 c4 18             	add    $0x18,%esp
	return;
  801d1c:	90                   	nop
}
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801d22:	8b 45 08             	mov    0x8(%ebp),%eax
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	50                   	push   %eax
  801d2e:	6a 2b                	push   $0x2b
  801d30:	e8 14 fa ff ff       	call   801749 <syscall>
  801d35:	83 c4 18             	add    $0x18,%esp
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	ff 75 0c             	pushl  0xc(%ebp)
  801d46:	ff 75 08             	pushl  0x8(%ebp)
  801d49:	6a 2c                	push   $0x2c
  801d4b:	e8 f9 f9 ff ff       	call   801749 <syscall>
  801d50:	83 c4 18             	add    $0x18,%esp
	return;
  801d53:	90                   	nop
}
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	ff 75 0c             	pushl  0xc(%ebp)
  801d62:	ff 75 08             	pushl  0x8(%ebp)
  801d65:	6a 2d                	push   $0x2d
  801d67:	e8 dd f9 ff ff       	call   801749 <syscall>
  801d6c:	83 c4 18             	add    $0x18,%esp
	return;
  801d6f:	90                   	nop
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801d78:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7b:	83 e8 04             	sub    $0x4,%eax
  801d7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801d81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d84:	8b 00                	mov    (%eax),%eax
  801d86:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    

00801d8b <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801d91:	8b 45 08             	mov    0x8(%ebp),%eax
  801d94:	83 e8 04             	sub    $0x4,%eax
  801d97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801d9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d9d:	8b 00                	mov    (%eax),%eax
  801d9f:	83 e0 01             	and    $0x1,%eax
  801da2:	85 c0                	test   %eax,%eax
  801da4:	0f 94 c0             	sete   %al
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
  801dac:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801daf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801db6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db9:	83 f8 02             	cmp    $0x2,%eax
  801dbc:	74 2b                	je     801de9 <alloc_block+0x40>
  801dbe:	83 f8 02             	cmp    $0x2,%eax
  801dc1:	7f 07                	jg     801dca <alloc_block+0x21>
  801dc3:	83 f8 01             	cmp    $0x1,%eax
  801dc6:	74 0e                	je     801dd6 <alloc_block+0x2d>
  801dc8:	eb 58                	jmp    801e22 <alloc_block+0x79>
  801dca:	83 f8 03             	cmp    $0x3,%eax
  801dcd:	74 2d                	je     801dfc <alloc_block+0x53>
  801dcf:	83 f8 04             	cmp    $0x4,%eax
  801dd2:	74 3b                	je     801e0f <alloc_block+0x66>
  801dd4:	eb 4c                	jmp    801e22 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801dd6:	83 ec 0c             	sub    $0xc,%esp
  801dd9:	ff 75 08             	pushl  0x8(%ebp)
  801ddc:	e8 11 03 00 00       	call   8020f2 <alloc_block_FF>
  801de1:	83 c4 10             	add    $0x10,%esp
  801de4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801de7:	eb 4a                	jmp    801e33 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801de9:	83 ec 0c             	sub    $0xc,%esp
  801dec:	ff 75 08             	pushl  0x8(%ebp)
  801def:	e8 fa 19 00 00       	call   8037ee <alloc_block_NF>
  801df4:	83 c4 10             	add    $0x10,%esp
  801df7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801dfa:	eb 37                	jmp    801e33 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801dfc:	83 ec 0c             	sub    $0xc,%esp
  801dff:	ff 75 08             	pushl  0x8(%ebp)
  801e02:	e8 a7 07 00 00       	call   8025ae <alloc_block_BF>
  801e07:	83 c4 10             	add    $0x10,%esp
  801e0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e0d:	eb 24                	jmp    801e33 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801e0f:	83 ec 0c             	sub    $0xc,%esp
  801e12:	ff 75 08             	pushl  0x8(%ebp)
  801e15:	e8 b7 19 00 00       	call   8037d1 <alloc_block_WF>
  801e1a:	83 c4 10             	add    $0x10,%esp
  801e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e20:	eb 11                	jmp    801e33 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801e22:	83 ec 0c             	sub    $0xc,%esp
  801e25:	68 74 43 80 00       	push   $0x804374
  801e2a:	e8 10 e7 ff ff       	call   80053f <cprintf>
  801e2f:	83 c4 10             	add    $0x10,%esp
		break;
  801e32:	90                   	nop
	}
	return va;
  801e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	53                   	push   %ebx
  801e3c:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801e3f:	83 ec 0c             	sub    $0xc,%esp
  801e42:	68 94 43 80 00       	push   $0x804394
  801e47:	e8 f3 e6 ff ff       	call   80053f <cprintf>
  801e4c:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801e4f:	83 ec 0c             	sub    $0xc,%esp
  801e52:	68 bf 43 80 00       	push   $0x8043bf
  801e57:	e8 e3 e6 ff ff       	call   80053f <cprintf>
  801e5c:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e65:	eb 37                	jmp    801e9e <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801e67:	83 ec 0c             	sub    $0xc,%esp
  801e6a:	ff 75 f4             	pushl  -0xc(%ebp)
  801e6d:	e8 19 ff ff ff       	call   801d8b <is_free_block>
  801e72:	83 c4 10             	add    $0x10,%esp
  801e75:	0f be d8             	movsbl %al,%ebx
  801e78:	83 ec 0c             	sub    $0xc,%esp
  801e7b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e7e:	e8 ef fe ff ff       	call   801d72 <get_block_size>
  801e83:	83 c4 10             	add    $0x10,%esp
  801e86:	83 ec 04             	sub    $0x4,%esp
  801e89:	53                   	push   %ebx
  801e8a:	50                   	push   %eax
  801e8b:	68 d7 43 80 00       	push   $0x8043d7
  801e90:	e8 aa e6 ff ff       	call   80053f <cprintf>
  801e95:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801e98:	8b 45 10             	mov    0x10(%ebp),%eax
  801e9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ea2:	74 07                	je     801eab <print_blocks_list+0x73>
  801ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea7:	8b 00                	mov    (%eax),%eax
  801ea9:	eb 05                	jmp    801eb0 <print_blocks_list+0x78>
  801eab:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb0:	89 45 10             	mov    %eax,0x10(%ebp)
  801eb3:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb6:	85 c0                	test   %eax,%eax
  801eb8:	75 ad                	jne    801e67 <print_blocks_list+0x2f>
  801eba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ebe:	75 a7                	jne    801e67 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801ec0:	83 ec 0c             	sub    $0xc,%esp
  801ec3:	68 94 43 80 00       	push   $0x804394
  801ec8:	e8 72 e6 ff ff       	call   80053f <cprintf>
  801ecd:	83 c4 10             	add    $0x10,%esp

}
  801ed0:	90                   	nop
  801ed1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
  801ed9:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801edc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801edf:	83 e0 01             	and    $0x1,%eax
  801ee2:	85 c0                	test   %eax,%eax
  801ee4:	74 03                	je     801ee9 <initialize_dynamic_allocator+0x13>
  801ee6:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801ee9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801eed:	0f 84 c7 01 00 00    	je     8020ba <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801ef3:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801efa:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801efd:	8b 55 08             	mov    0x8(%ebp),%edx
  801f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f03:	01 d0                	add    %edx,%eax
  801f05:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801f0a:	0f 87 ad 01 00 00    	ja     8020bd <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	85 c0                	test   %eax,%eax
  801f15:	0f 89 a5 01 00 00    	jns    8020c0 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  801f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f21:	01 d0                	add    %edx,%eax
  801f23:	83 e8 04             	sub    $0x4,%eax
  801f26:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801f2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801f32:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801f37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f3a:	e9 87 00 00 00       	jmp    801fc6 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801f3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f43:	75 14                	jne    801f59 <initialize_dynamic_allocator+0x83>
  801f45:	83 ec 04             	sub    $0x4,%esp
  801f48:	68 ef 43 80 00       	push   $0x8043ef
  801f4d:	6a 79                	push   $0x79
  801f4f:	68 0d 44 80 00       	push   $0x80440d
  801f54:	e8 29 e3 ff ff       	call   800282 <_panic>
  801f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5c:	8b 00                	mov    (%eax),%eax
  801f5e:	85 c0                	test   %eax,%eax
  801f60:	74 10                	je     801f72 <initialize_dynamic_allocator+0x9c>
  801f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f65:	8b 00                	mov    (%eax),%eax
  801f67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f6a:	8b 52 04             	mov    0x4(%edx),%edx
  801f6d:	89 50 04             	mov    %edx,0x4(%eax)
  801f70:	eb 0b                	jmp    801f7d <initialize_dynamic_allocator+0xa7>
  801f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f75:	8b 40 04             	mov    0x4(%eax),%eax
  801f78:	a3 30 50 80 00       	mov    %eax,0x805030
  801f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f80:	8b 40 04             	mov    0x4(%eax),%eax
  801f83:	85 c0                	test   %eax,%eax
  801f85:	74 0f                	je     801f96 <initialize_dynamic_allocator+0xc0>
  801f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8a:	8b 40 04             	mov    0x4(%eax),%eax
  801f8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f90:	8b 12                	mov    (%edx),%edx
  801f92:	89 10                	mov    %edx,(%eax)
  801f94:	eb 0a                	jmp    801fa0 <initialize_dynamic_allocator+0xca>
  801f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f99:	8b 00                	mov    (%eax),%eax
  801f9b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fb3:	a1 38 50 80 00       	mov    0x805038,%eax
  801fb8:	48                   	dec    %eax
  801fb9:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801fbe:	a1 34 50 80 00       	mov    0x805034,%eax
  801fc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fca:	74 07                	je     801fd3 <initialize_dynamic_allocator+0xfd>
  801fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcf:	8b 00                	mov    (%eax),%eax
  801fd1:	eb 05                	jmp    801fd8 <initialize_dynamic_allocator+0x102>
  801fd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd8:	a3 34 50 80 00       	mov    %eax,0x805034
  801fdd:	a1 34 50 80 00       	mov    0x805034,%eax
  801fe2:	85 c0                	test   %eax,%eax
  801fe4:	0f 85 55 ff ff ff    	jne    801f3f <initialize_dynamic_allocator+0x69>
  801fea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fee:	0f 85 4b ff ff ff    	jne    801f3f <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ffd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802003:	a1 44 50 80 00       	mov    0x805044,%eax
  802008:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80200d:	a1 40 50 80 00       	mov    0x805040,%eax
  802012:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802018:	8b 45 08             	mov    0x8(%ebp),%eax
  80201b:	83 c0 08             	add    $0x8,%eax
  80201e:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802021:	8b 45 08             	mov    0x8(%ebp),%eax
  802024:	83 c0 04             	add    $0x4,%eax
  802027:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202a:	83 ea 08             	sub    $0x8,%edx
  80202d:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80202f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	01 d0                	add    %edx,%eax
  802037:	83 e8 08             	sub    $0x8,%eax
  80203a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203d:	83 ea 08             	sub    $0x8,%edx
  802040:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802042:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802045:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80204b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80204e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802055:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802059:	75 17                	jne    802072 <initialize_dynamic_allocator+0x19c>
  80205b:	83 ec 04             	sub    $0x4,%esp
  80205e:	68 28 44 80 00       	push   $0x804428
  802063:	68 90 00 00 00       	push   $0x90
  802068:	68 0d 44 80 00       	push   $0x80440d
  80206d:	e8 10 e2 ff ff       	call   800282 <_panic>
  802072:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802078:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80207b:	89 10                	mov    %edx,(%eax)
  80207d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802080:	8b 00                	mov    (%eax),%eax
  802082:	85 c0                	test   %eax,%eax
  802084:	74 0d                	je     802093 <initialize_dynamic_allocator+0x1bd>
  802086:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80208b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80208e:	89 50 04             	mov    %edx,0x4(%eax)
  802091:	eb 08                	jmp    80209b <initialize_dynamic_allocator+0x1c5>
  802093:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802096:	a3 30 50 80 00       	mov    %eax,0x805030
  80209b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80209e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020ad:	a1 38 50 80 00       	mov    0x805038,%eax
  8020b2:	40                   	inc    %eax
  8020b3:	a3 38 50 80 00       	mov    %eax,0x805038
  8020b8:	eb 07                	jmp    8020c1 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8020ba:	90                   	nop
  8020bb:	eb 04                	jmp    8020c1 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8020bd:	90                   	nop
  8020be:	eb 01                	jmp    8020c1 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8020c0:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8020c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8020c9:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8020cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cf:	8d 50 fc             	lea    -0x4(%eax),%edx
  8020d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d5:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8020d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020da:	83 e8 04             	sub    $0x4,%eax
  8020dd:	8b 00                	mov    (%eax),%eax
  8020df:	83 e0 fe             	and    $0xfffffffe,%eax
  8020e2:	8d 50 f8             	lea    -0x8(%eax),%edx
  8020e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e8:	01 c2                	add    %eax,%edx
  8020ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ed:	89 02                	mov    %eax,(%edx)
}
  8020ef:	90                   	nop
  8020f0:	5d                   	pop    %ebp
  8020f1:	c3                   	ret    

008020f2 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	83 e0 01             	and    $0x1,%eax
  8020fe:	85 c0                	test   %eax,%eax
  802100:	74 03                	je     802105 <alloc_block_FF+0x13>
  802102:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802105:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802109:	77 07                	ja     802112 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80210b:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802112:	a1 24 50 80 00       	mov    0x805024,%eax
  802117:	85 c0                	test   %eax,%eax
  802119:	75 73                	jne    80218e <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
  80211e:	83 c0 10             	add    $0x10,%eax
  802121:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802124:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80212b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80212e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802131:	01 d0                	add    %edx,%eax
  802133:	48                   	dec    %eax
  802134:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802137:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80213a:	ba 00 00 00 00       	mov    $0x0,%edx
  80213f:	f7 75 ec             	divl   -0x14(%ebp)
  802142:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802145:	29 d0                	sub    %edx,%eax
  802147:	c1 e8 0c             	shr    $0xc,%eax
  80214a:	83 ec 0c             	sub    $0xc,%esp
  80214d:	50                   	push   %eax
  80214e:	e8 86 f1 ff ff       	call   8012d9 <sbrk>
  802153:	83 c4 10             	add    $0x10,%esp
  802156:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802159:	83 ec 0c             	sub    $0xc,%esp
  80215c:	6a 00                	push   $0x0
  80215e:	e8 76 f1 ff ff       	call   8012d9 <sbrk>
  802163:	83 c4 10             	add    $0x10,%esp
  802166:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802169:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80216c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80216f:	83 ec 08             	sub    $0x8,%esp
  802172:	50                   	push   %eax
  802173:	ff 75 e4             	pushl  -0x1c(%ebp)
  802176:	e8 5b fd ff ff       	call   801ed6 <initialize_dynamic_allocator>
  80217b:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80217e:	83 ec 0c             	sub    $0xc,%esp
  802181:	68 4b 44 80 00       	push   $0x80444b
  802186:	e8 b4 e3 ff ff       	call   80053f <cprintf>
  80218b:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80218e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802192:	75 0a                	jne    80219e <alloc_block_FF+0xac>
	        return NULL;
  802194:	b8 00 00 00 00       	mov    $0x0,%eax
  802199:	e9 0e 04 00 00       	jmp    8025ac <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80219e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8021a5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ad:	e9 f3 02 00 00       	jmp    8024a5 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8021b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b5:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8021b8:	83 ec 0c             	sub    $0xc,%esp
  8021bb:	ff 75 bc             	pushl  -0x44(%ebp)
  8021be:	e8 af fb ff ff       	call   801d72 <get_block_size>
  8021c3:	83 c4 10             	add    $0x10,%esp
  8021c6:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cc:	83 c0 08             	add    $0x8,%eax
  8021cf:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8021d2:	0f 87 c5 02 00 00    	ja     80249d <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	83 c0 18             	add    $0x18,%eax
  8021de:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8021e1:	0f 87 19 02 00 00    	ja     802400 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8021e7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8021ea:	2b 45 08             	sub    0x8(%ebp),%eax
  8021ed:	83 e8 08             	sub    $0x8,%eax
  8021f0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	8d 50 08             	lea    0x8(%eax),%edx
  8021f9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8021fc:	01 d0                	add    %edx,%eax
  8021fe:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	83 c0 08             	add    $0x8,%eax
  802207:	83 ec 04             	sub    $0x4,%esp
  80220a:	6a 01                	push   $0x1
  80220c:	50                   	push   %eax
  80220d:	ff 75 bc             	pushl  -0x44(%ebp)
  802210:	e8 ae fe ff ff       	call   8020c3 <set_block_data>
  802215:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221b:	8b 40 04             	mov    0x4(%eax),%eax
  80221e:	85 c0                	test   %eax,%eax
  802220:	75 68                	jne    80228a <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802222:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802226:	75 17                	jne    80223f <alloc_block_FF+0x14d>
  802228:	83 ec 04             	sub    $0x4,%esp
  80222b:	68 28 44 80 00       	push   $0x804428
  802230:	68 d7 00 00 00       	push   $0xd7
  802235:	68 0d 44 80 00       	push   $0x80440d
  80223a:	e8 43 e0 ff ff       	call   800282 <_panic>
  80223f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802245:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802248:	89 10                	mov    %edx,(%eax)
  80224a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80224d:	8b 00                	mov    (%eax),%eax
  80224f:	85 c0                	test   %eax,%eax
  802251:	74 0d                	je     802260 <alloc_block_FF+0x16e>
  802253:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802258:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80225b:	89 50 04             	mov    %edx,0x4(%eax)
  80225e:	eb 08                	jmp    802268 <alloc_block_FF+0x176>
  802260:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802263:	a3 30 50 80 00       	mov    %eax,0x805030
  802268:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80226b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802270:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802273:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80227a:	a1 38 50 80 00       	mov    0x805038,%eax
  80227f:	40                   	inc    %eax
  802280:	a3 38 50 80 00       	mov    %eax,0x805038
  802285:	e9 dc 00 00 00       	jmp    802366 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80228a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228d:	8b 00                	mov    (%eax),%eax
  80228f:	85 c0                	test   %eax,%eax
  802291:	75 65                	jne    8022f8 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802293:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802297:	75 17                	jne    8022b0 <alloc_block_FF+0x1be>
  802299:	83 ec 04             	sub    $0x4,%esp
  80229c:	68 5c 44 80 00       	push   $0x80445c
  8022a1:	68 db 00 00 00       	push   $0xdb
  8022a6:	68 0d 44 80 00       	push   $0x80440d
  8022ab:	e8 d2 df ff ff       	call   800282 <_panic>
  8022b0:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8022b6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022b9:	89 50 04             	mov    %edx,0x4(%eax)
  8022bc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022bf:	8b 40 04             	mov    0x4(%eax),%eax
  8022c2:	85 c0                	test   %eax,%eax
  8022c4:	74 0c                	je     8022d2 <alloc_block_FF+0x1e0>
  8022c6:	a1 30 50 80 00       	mov    0x805030,%eax
  8022cb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022ce:	89 10                	mov    %edx,(%eax)
  8022d0:	eb 08                	jmp    8022da <alloc_block_FF+0x1e8>
  8022d2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022d5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022da:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022dd:	a3 30 50 80 00       	mov    %eax,0x805030
  8022e2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022eb:	a1 38 50 80 00       	mov    0x805038,%eax
  8022f0:	40                   	inc    %eax
  8022f1:	a3 38 50 80 00       	mov    %eax,0x805038
  8022f6:	eb 6e                	jmp    802366 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8022f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022fc:	74 06                	je     802304 <alloc_block_FF+0x212>
  8022fe:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802302:	75 17                	jne    80231b <alloc_block_FF+0x229>
  802304:	83 ec 04             	sub    $0x4,%esp
  802307:	68 80 44 80 00       	push   $0x804480
  80230c:	68 df 00 00 00       	push   $0xdf
  802311:	68 0d 44 80 00       	push   $0x80440d
  802316:	e8 67 df ff ff       	call   800282 <_panic>
  80231b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231e:	8b 10                	mov    (%eax),%edx
  802320:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802323:	89 10                	mov    %edx,(%eax)
  802325:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802328:	8b 00                	mov    (%eax),%eax
  80232a:	85 c0                	test   %eax,%eax
  80232c:	74 0b                	je     802339 <alloc_block_FF+0x247>
  80232e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802331:	8b 00                	mov    (%eax),%eax
  802333:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802336:	89 50 04             	mov    %edx,0x4(%eax)
  802339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80233f:	89 10                	mov    %edx,(%eax)
  802341:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802344:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802347:	89 50 04             	mov    %edx,0x4(%eax)
  80234a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80234d:	8b 00                	mov    (%eax),%eax
  80234f:	85 c0                	test   %eax,%eax
  802351:	75 08                	jne    80235b <alloc_block_FF+0x269>
  802353:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802356:	a3 30 50 80 00       	mov    %eax,0x805030
  80235b:	a1 38 50 80 00       	mov    0x805038,%eax
  802360:	40                   	inc    %eax
  802361:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80236a:	75 17                	jne    802383 <alloc_block_FF+0x291>
  80236c:	83 ec 04             	sub    $0x4,%esp
  80236f:	68 ef 43 80 00       	push   $0x8043ef
  802374:	68 e1 00 00 00       	push   $0xe1
  802379:	68 0d 44 80 00       	push   $0x80440d
  80237e:	e8 ff de ff ff       	call   800282 <_panic>
  802383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802386:	8b 00                	mov    (%eax),%eax
  802388:	85 c0                	test   %eax,%eax
  80238a:	74 10                	je     80239c <alloc_block_FF+0x2aa>
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	8b 00                	mov    (%eax),%eax
  802391:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802394:	8b 52 04             	mov    0x4(%edx),%edx
  802397:	89 50 04             	mov    %edx,0x4(%eax)
  80239a:	eb 0b                	jmp    8023a7 <alloc_block_FF+0x2b5>
  80239c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239f:	8b 40 04             	mov    0x4(%eax),%eax
  8023a2:	a3 30 50 80 00       	mov    %eax,0x805030
  8023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023aa:	8b 40 04             	mov    0x4(%eax),%eax
  8023ad:	85 c0                	test   %eax,%eax
  8023af:	74 0f                	je     8023c0 <alloc_block_FF+0x2ce>
  8023b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b4:	8b 40 04             	mov    0x4(%eax),%eax
  8023b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ba:	8b 12                	mov    (%edx),%edx
  8023bc:	89 10                	mov    %edx,(%eax)
  8023be:	eb 0a                	jmp    8023ca <alloc_block_FF+0x2d8>
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	8b 00                	mov    (%eax),%eax
  8023c5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023dd:	a1 38 50 80 00       	mov    0x805038,%eax
  8023e2:	48                   	dec    %eax
  8023e3:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8023e8:	83 ec 04             	sub    $0x4,%esp
  8023eb:	6a 00                	push   $0x0
  8023ed:	ff 75 b4             	pushl  -0x4c(%ebp)
  8023f0:	ff 75 b0             	pushl  -0x50(%ebp)
  8023f3:	e8 cb fc ff ff       	call   8020c3 <set_block_data>
  8023f8:	83 c4 10             	add    $0x10,%esp
  8023fb:	e9 95 00 00 00       	jmp    802495 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802400:	83 ec 04             	sub    $0x4,%esp
  802403:	6a 01                	push   $0x1
  802405:	ff 75 b8             	pushl  -0x48(%ebp)
  802408:	ff 75 bc             	pushl  -0x44(%ebp)
  80240b:	e8 b3 fc ff ff       	call   8020c3 <set_block_data>
  802410:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802413:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802417:	75 17                	jne    802430 <alloc_block_FF+0x33e>
  802419:	83 ec 04             	sub    $0x4,%esp
  80241c:	68 ef 43 80 00       	push   $0x8043ef
  802421:	68 e8 00 00 00       	push   $0xe8
  802426:	68 0d 44 80 00       	push   $0x80440d
  80242b:	e8 52 de ff ff       	call   800282 <_panic>
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	8b 00                	mov    (%eax),%eax
  802435:	85 c0                	test   %eax,%eax
  802437:	74 10                	je     802449 <alloc_block_FF+0x357>
  802439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243c:	8b 00                	mov    (%eax),%eax
  80243e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802441:	8b 52 04             	mov    0x4(%edx),%edx
  802444:	89 50 04             	mov    %edx,0x4(%eax)
  802447:	eb 0b                	jmp    802454 <alloc_block_FF+0x362>
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	8b 40 04             	mov    0x4(%eax),%eax
  80244f:	a3 30 50 80 00       	mov    %eax,0x805030
  802454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802457:	8b 40 04             	mov    0x4(%eax),%eax
  80245a:	85 c0                	test   %eax,%eax
  80245c:	74 0f                	je     80246d <alloc_block_FF+0x37b>
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	8b 40 04             	mov    0x4(%eax),%eax
  802464:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802467:	8b 12                	mov    (%edx),%edx
  802469:	89 10                	mov    %edx,(%eax)
  80246b:	eb 0a                	jmp    802477 <alloc_block_FF+0x385>
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	8b 00                	mov    (%eax),%eax
  802472:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802483:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80248a:	a1 38 50 80 00       	mov    0x805038,%eax
  80248f:	48                   	dec    %eax
  802490:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802495:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802498:	e9 0f 01 00 00       	jmp    8025ac <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80249d:	a1 34 50 80 00       	mov    0x805034,%eax
  8024a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a9:	74 07                	je     8024b2 <alloc_block_FF+0x3c0>
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	8b 00                	mov    (%eax),%eax
  8024b0:	eb 05                	jmp    8024b7 <alloc_block_FF+0x3c5>
  8024b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b7:	a3 34 50 80 00       	mov    %eax,0x805034
  8024bc:	a1 34 50 80 00       	mov    0x805034,%eax
  8024c1:	85 c0                	test   %eax,%eax
  8024c3:	0f 85 e9 fc ff ff    	jne    8021b2 <alloc_block_FF+0xc0>
  8024c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024cd:	0f 85 df fc ff ff    	jne    8021b2 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8024d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d6:	83 c0 08             	add    $0x8,%eax
  8024d9:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8024dc:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8024e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8024e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024e9:	01 d0                	add    %edx,%eax
  8024eb:	48                   	dec    %eax
  8024ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8024ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8024f7:	f7 75 d8             	divl   -0x28(%ebp)
  8024fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024fd:	29 d0                	sub    %edx,%eax
  8024ff:	c1 e8 0c             	shr    $0xc,%eax
  802502:	83 ec 0c             	sub    $0xc,%esp
  802505:	50                   	push   %eax
  802506:	e8 ce ed ff ff       	call   8012d9 <sbrk>
  80250b:	83 c4 10             	add    $0x10,%esp
  80250e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802511:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802515:	75 0a                	jne    802521 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802517:	b8 00 00 00 00       	mov    $0x0,%eax
  80251c:	e9 8b 00 00 00       	jmp    8025ac <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802521:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802528:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80252b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80252e:	01 d0                	add    %edx,%eax
  802530:	48                   	dec    %eax
  802531:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802534:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802537:	ba 00 00 00 00       	mov    $0x0,%edx
  80253c:	f7 75 cc             	divl   -0x34(%ebp)
  80253f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802542:	29 d0                	sub    %edx,%eax
  802544:	8d 50 fc             	lea    -0x4(%eax),%edx
  802547:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80254a:	01 d0                	add    %edx,%eax
  80254c:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802551:	a1 40 50 80 00       	mov    0x805040,%eax
  802556:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80255c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802563:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802566:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802569:	01 d0                	add    %edx,%eax
  80256b:	48                   	dec    %eax
  80256c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80256f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802572:	ba 00 00 00 00       	mov    $0x0,%edx
  802577:	f7 75 c4             	divl   -0x3c(%ebp)
  80257a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80257d:	29 d0                	sub    %edx,%eax
  80257f:	83 ec 04             	sub    $0x4,%esp
  802582:	6a 01                	push   $0x1
  802584:	50                   	push   %eax
  802585:	ff 75 d0             	pushl  -0x30(%ebp)
  802588:	e8 36 fb ff ff       	call   8020c3 <set_block_data>
  80258d:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802590:	83 ec 0c             	sub    $0xc,%esp
  802593:	ff 75 d0             	pushl  -0x30(%ebp)
  802596:	e8 1b 0a 00 00       	call   802fb6 <free_block>
  80259b:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80259e:	83 ec 0c             	sub    $0xc,%esp
  8025a1:	ff 75 08             	pushl  0x8(%ebp)
  8025a4:	e8 49 fb ff ff       	call   8020f2 <alloc_block_FF>
  8025a9:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8025ac:	c9                   	leave  
  8025ad:	c3                   	ret    

008025ae <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8025ae:	55                   	push   %ebp
  8025af:	89 e5                	mov    %esp,%ebp
  8025b1:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8025b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b7:	83 e0 01             	and    $0x1,%eax
  8025ba:	85 c0                	test   %eax,%eax
  8025bc:	74 03                	je     8025c1 <alloc_block_BF+0x13>
  8025be:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8025c1:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8025c5:	77 07                	ja     8025ce <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8025c7:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8025ce:	a1 24 50 80 00       	mov    0x805024,%eax
  8025d3:	85 c0                	test   %eax,%eax
  8025d5:	75 73                	jne    80264a <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8025d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025da:	83 c0 10             	add    $0x10,%eax
  8025dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8025e0:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8025e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ed:	01 d0                	add    %edx,%eax
  8025ef:	48                   	dec    %eax
  8025f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8025f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8025fb:	f7 75 e0             	divl   -0x20(%ebp)
  8025fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802601:	29 d0                	sub    %edx,%eax
  802603:	c1 e8 0c             	shr    $0xc,%eax
  802606:	83 ec 0c             	sub    $0xc,%esp
  802609:	50                   	push   %eax
  80260a:	e8 ca ec ff ff       	call   8012d9 <sbrk>
  80260f:	83 c4 10             	add    $0x10,%esp
  802612:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802615:	83 ec 0c             	sub    $0xc,%esp
  802618:	6a 00                	push   $0x0
  80261a:	e8 ba ec ff ff       	call   8012d9 <sbrk>
  80261f:	83 c4 10             	add    $0x10,%esp
  802622:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802625:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802628:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80262b:	83 ec 08             	sub    $0x8,%esp
  80262e:	50                   	push   %eax
  80262f:	ff 75 d8             	pushl  -0x28(%ebp)
  802632:	e8 9f f8 ff ff       	call   801ed6 <initialize_dynamic_allocator>
  802637:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80263a:	83 ec 0c             	sub    $0xc,%esp
  80263d:	68 4b 44 80 00       	push   $0x80444b
  802642:	e8 f8 de ff ff       	call   80053f <cprintf>
  802647:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80264a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802651:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802658:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80265f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802666:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80266b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266e:	e9 1d 01 00 00       	jmp    802790 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802676:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802679:	83 ec 0c             	sub    $0xc,%esp
  80267c:	ff 75 a8             	pushl  -0x58(%ebp)
  80267f:	e8 ee f6 ff ff       	call   801d72 <get_block_size>
  802684:	83 c4 10             	add    $0x10,%esp
  802687:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80268a:	8b 45 08             	mov    0x8(%ebp),%eax
  80268d:	83 c0 08             	add    $0x8,%eax
  802690:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802693:	0f 87 ef 00 00 00    	ja     802788 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802699:	8b 45 08             	mov    0x8(%ebp),%eax
  80269c:	83 c0 18             	add    $0x18,%eax
  80269f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026a2:	77 1d                	ja     8026c1 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8026a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026aa:	0f 86 d8 00 00 00    	jbe    802788 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8026b0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8026b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8026b6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8026b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8026bc:	e9 c7 00 00 00       	jmp    802788 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8026c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c4:	83 c0 08             	add    $0x8,%eax
  8026c7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026ca:	0f 85 9d 00 00 00    	jne    80276d <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8026d0:	83 ec 04             	sub    $0x4,%esp
  8026d3:	6a 01                	push   $0x1
  8026d5:	ff 75 a4             	pushl  -0x5c(%ebp)
  8026d8:	ff 75 a8             	pushl  -0x58(%ebp)
  8026db:	e8 e3 f9 ff ff       	call   8020c3 <set_block_data>
  8026e0:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8026e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e7:	75 17                	jne    802700 <alloc_block_BF+0x152>
  8026e9:	83 ec 04             	sub    $0x4,%esp
  8026ec:	68 ef 43 80 00       	push   $0x8043ef
  8026f1:	68 2c 01 00 00       	push   $0x12c
  8026f6:	68 0d 44 80 00       	push   $0x80440d
  8026fb:	e8 82 db ff ff       	call   800282 <_panic>
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	8b 00                	mov    (%eax),%eax
  802705:	85 c0                	test   %eax,%eax
  802707:	74 10                	je     802719 <alloc_block_BF+0x16b>
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	8b 00                	mov    (%eax),%eax
  80270e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802711:	8b 52 04             	mov    0x4(%edx),%edx
  802714:	89 50 04             	mov    %edx,0x4(%eax)
  802717:	eb 0b                	jmp    802724 <alloc_block_BF+0x176>
  802719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271c:	8b 40 04             	mov    0x4(%eax),%eax
  80271f:	a3 30 50 80 00       	mov    %eax,0x805030
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	8b 40 04             	mov    0x4(%eax),%eax
  80272a:	85 c0                	test   %eax,%eax
  80272c:	74 0f                	je     80273d <alloc_block_BF+0x18f>
  80272e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802731:	8b 40 04             	mov    0x4(%eax),%eax
  802734:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802737:	8b 12                	mov    (%edx),%edx
  802739:	89 10                	mov    %edx,(%eax)
  80273b:	eb 0a                	jmp    802747 <alloc_block_BF+0x199>
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	8b 00                	mov    (%eax),%eax
  802742:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80275a:	a1 38 50 80 00       	mov    0x805038,%eax
  80275f:	48                   	dec    %eax
  802760:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802765:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802768:	e9 24 04 00 00       	jmp    802b91 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80276d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802770:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802773:	76 13                	jbe    802788 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802775:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80277c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80277f:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802782:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802785:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802788:	a1 34 50 80 00       	mov    0x805034,%eax
  80278d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802790:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802794:	74 07                	je     80279d <alloc_block_BF+0x1ef>
  802796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802799:	8b 00                	mov    (%eax),%eax
  80279b:	eb 05                	jmp    8027a2 <alloc_block_BF+0x1f4>
  80279d:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a2:	a3 34 50 80 00       	mov    %eax,0x805034
  8027a7:	a1 34 50 80 00       	mov    0x805034,%eax
  8027ac:	85 c0                	test   %eax,%eax
  8027ae:	0f 85 bf fe ff ff    	jne    802673 <alloc_block_BF+0xc5>
  8027b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b8:	0f 85 b5 fe ff ff    	jne    802673 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8027be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027c2:	0f 84 26 02 00 00    	je     8029ee <alloc_block_BF+0x440>
  8027c8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027cc:	0f 85 1c 02 00 00    	jne    8029ee <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8027d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d5:	2b 45 08             	sub    0x8(%ebp),%eax
  8027d8:	83 e8 08             	sub    $0x8,%eax
  8027db:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8027de:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e1:	8d 50 08             	lea    0x8(%eax),%edx
  8027e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e7:	01 d0                	add    %edx,%eax
  8027e9:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8027ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ef:	83 c0 08             	add    $0x8,%eax
  8027f2:	83 ec 04             	sub    $0x4,%esp
  8027f5:	6a 01                	push   $0x1
  8027f7:	50                   	push   %eax
  8027f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8027fb:	e8 c3 f8 ff ff       	call   8020c3 <set_block_data>
  802800:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802806:	8b 40 04             	mov    0x4(%eax),%eax
  802809:	85 c0                	test   %eax,%eax
  80280b:	75 68                	jne    802875 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80280d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802811:	75 17                	jne    80282a <alloc_block_BF+0x27c>
  802813:	83 ec 04             	sub    $0x4,%esp
  802816:	68 28 44 80 00       	push   $0x804428
  80281b:	68 45 01 00 00       	push   $0x145
  802820:	68 0d 44 80 00       	push   $0x80440d
  802825:	e8 58 da ff ff       	call   800282 <_panic>
  80282a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802830:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802833:	89 10                	mov    %edx,(%eax)
  802835:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802838:	8b 00                	mov    (%eax),%eax
  80283a:	85 c0                	test   %eax,%eax
  80283c:	74 0d                	je     80284b <alloc_block_BF+0x29d>
  80283e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802843:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802846:	89 50 04             	mov    %edx,0x4(%eax)
  802849:	eb 08                	jmp    802853 <alloc_block_BF+0x2a5>
  80284b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80284e:	a3 30 50 80 00       	mov    %eax,0x805030
  802853:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802856:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80285b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80285e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802865:	a1 38 50 80 00       	mov    0x805038,%eax
  80286a:	40                   	inc    %eax
  80286b:	a3 38 50 80 00       	mov    %eax,0x805038
  802870:	e9 dc 00 00 00       	jmp    802951 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802875:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802878:	8b 00                	mov    (%eax),%eax
  80287a:	85 c0                	test   %eax,%eax
  80287c:	75 65                	jne    8028e3 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80287e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802882:	75 17                	jne    80289b <alloc_block_BF+0x2ed>
  802884:	83 ec 04             	sub    $0x4,%esp
  802887:	68 5c 44 80 00       	push   $0x80445c
  80288c:	68 4a 01 00 00       	push   $0x14a
  802891:	68 0d 44 80 00       	push   $0x80440d
  802896:	e8 e7 d9 ff ff       	call   800282 <_panic>
  80289b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8028a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028a4:	89 50 04             	mov    %edx,0x4(%eax)
  8028a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028aa:	8b 40 04             	mov    0x4(%eax),%eax
  8028ad:	85 c0                	test   %eax,%eax
  8028af:	74 0c                	je     8028bd <alloc_block_BF+0x30f>
  8028b1:	a1 30 50 80 00       	mov    0x805030,%eax
  8028b6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028b9:	89 10                	mov    %edx,(%eax)
  8028bb:	eb 08                	jmp    8028c5 <alloc_block_BF+0x317>
  8028bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028c0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028c5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028c8:	a3 30 50 80 00       	mov    %eax,0x805030
  8028cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d6:	a1 38 50 80 00       	mov    0x805038,%eax
  8028db:	40                   	inc    %eax
  8028dc:	a3 38 50 80 00       	mov    %eax,0x805038
  8028e1:	eb 6e                	jmp    802951 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8028e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028e7:	74 06                	je     8028ef <alloc_block_BF+0x341>
  8028e9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028ed:	75 17                	jne    802906 <alloc_block_BF+0x358>
  8028ef:	83 ec 04             	sub    $0x4,%esp
  8028f2:	68 80 44 80 00       	push   $0x804480
  8028f7:	68 4f 01 00 00       	push   $0x14f
  8028fc:	68 0d 44 80 00       	push   $0x80440d
  802901:	e8 7c d9 ff ff       	call   800282 <_panic>
  802906:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802909:	8b 10                	mov    (%eax),%edx
  80290b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80290e:	89 10                	mov    %edx,(%eax)
  802910:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802913:	8b 00                	mov    (%eax),%eax
  802915:	85 c0                	test   %eax,%eax
  802917:	74 0b                	je     802924 <alloc_block_BF+0x376>
  802919:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291c:	8b 00                	mov    (%eax),%eax
  80291e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802921:	89 50 04             	mov    %edx,0x4(%eax)
  802924:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802927:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80292a:	89 10                	mov    %edx,(%eax)
  80292c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80292f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802932:	89 50 04             	mov    %edx,0x4(%eax)
  802935:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802938:	8b 00                	mov    (%eax),%eax
  80293a:	85 c0                	test   %eax,%eax
  80293c:	75 08                	jne    802946 <alloc_block_BF+0x398>
  80293e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802941:	a3 30 50 80 00       	mov    %eax,0x805030
  802946:	a1 38 50 80 00       	mov    0x805038,%eax
  80294b:	40                   	inc    %eax
  80294c:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802951:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802955:	75 17                	jne    80296e <alloc_block_BF+0x3c0>
  802957:	83 ec 04             	sub    $0x4,%esp
  80295a:	68 ef 43 80 00       	push   $0x8043ef
  80295f:	68 51 01 00 00       	push   $0x151
  802964:	68 0d 44 80 00       	push   $0x80440d
  802969:	e8 14 d9 ff ff       	call   800282 <_panic>
  80296e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802971:	8b 00                	mov    (%eax),%eax
  802973:	85 c0                	test   %eax,%eax
  802975:	74 10                	je     802987 <alloc_block_BF+0x3d9>
  802977:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297a:	8b 00                	mov    (%eax),%eax
  80297c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80297f:	8b 52 04             	mov    0x4(%edx),%edx
  802982:	89 50 04             	mov    %edx,0x4(%eax)
  802985:	eb 0b                	jmp    802992 <alloc_block_BF+0x3e4>
  802987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298a:	8b 40 04             	mov    0x4(%eax),%eax
  80298d:	a3 30 50 80 00       	mov    %eax,0x805030
  802992:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802995:	8b 40 04             	mov    0x4(%eax),%eax
  802998:	85 c0                	test   %eax,%eax
  80299a:	74 0f                	je     8029ab <alloc_block_BF+0x3fd>
  80299c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299f:	8b 40 04             	mov    0x4(%eax),%eax
  8029a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029a5:	8b 12                	mov    (%edx),%edx
  8029a7:	89 10                	mov    %edx,(%eax)
  8029a9:	eb 0a                	jmp    8029b5 <alloc_block_BF+0x407>
  8029ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ae:	8b 00                	mov    (%eax),%eax
  8029b0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c8:	a1 38 50 80 00       	mov    0x805038,%eax
  8029cd:	48                   	dec    %eax
  8029ce:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  8029d3:	83 ec 04             	sub    $0x4,%esp
  8029d6:	6a 00                	push   $0x0
  8029d8:	ff 75 d0             	pushl  -0x30(%ebp)
  8029db:	ff 75 cc             	pushl  -0x34(%ebp)
  8029de:	e8 e0 f6 ff ff       	call   8020c3 <set_block_data>
  8029e3:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8029e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e9:	e9 a3 01 00 00       	jmp    802b91 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8029ee:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8029f2:	0f 85 9d 00 00 00    	jne    802a95 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8029f8:	83 ec 04             	sub    $0x4,%esp
  8029fb:	6a 01                	push   $0x1
  8029fd:	ff 75 ec             	pushl  -0x14(%ebp)
  802a00:	ff 75 f0             	pushl  -0x10(%ebp)
  802a03:	e8 bb f6 ff ff       	call   8020c3 <set_block_data>
  802a08:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802a0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a0f:	75 17                	jne    802a28 <alloc_block_BF+0x47a>
  802a11:	83 ec 04             	sub    $0x4,%esp
  802a14:	68 ef 43 80 00       	push   $0x8043ef
  802a19:	68 58 01 00 00       	push   $0x158
  802a1e:	68 0d 44 80 00       	push   $0x80440d
  802a23:	e8 5a d8 ff ff       	call   800282 <_panic>
  802a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2b:	8b 00                	mov    (%eax),%eax
  802a2d:	85 c0                	test   %eax,%eax
  802a2f:	74 10                	je     802a41 <alloc_block_BF+0x493>
  802a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a34:	8b 00                	mov    (%eax),%eax
  802a36:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a39:	8b 52 04             	mov    0x4(%edx),%edx
  802a3c:	89 50 04             	mov    %edx,0x4(%eax)
  802a3f:	eb 0b                	jmp    802a4c <alloc_block_BF+0x49e>
  802a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a44:	8b 40 04             	mov    0x4(%eax),%eax
  802a47:	a3 30 50 80 00       	mov    %eax,0x805030
  802a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4f:	8b 40 04             	mov    0x4(%eax),%eax
  802a52:	85 c0                	test   %eax,%eax
  802a54:	74 0f                	je     802a65 <alloc_block_BF+0x4b7>
  802a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a59:	8b 40 04             	mov    0x4(%eax),%eax
  802a5c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a5f:	8b 12                	mov    (%edx),%edx
  802a61:	89 10                	mov    %edx,(%eax)
  802a63:	eb 0a                	jmp    802a6f <alloc_block_BF+0x4c1>
  802a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a68:	8b 00                	mov    (%eax),%eax
  802a6a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a82:	a1 38 50 80 00       	mov    0x805038,%eax
  802a87:	48                   	dec    %eax
  802a88:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a90:	e9 fc 00 00 00       	jmp    802b91 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802a95:	8b 45 08             	mov    0x8(%ebp),%eax
  802a98:	83 c0 08             	add    $0x8,%eax
  802a9b:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802a9e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802aa5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802aa8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802aab:	01 d0                	add    %edx,%eax
  802aad:	48                   	dec    %eax
  802aae:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802ab1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ab4:	ba 00 00 00 00       	mov    $0x0,%edx
  802ab9:	f7 75 c4             	divl   -0x3c(%ebp)
  802abc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802abf:	29 d0                	sub    %edx,%eax
  802ac1:	c1 e8 0c             	shr    $0xc,%eax
  802ac4:	83 ec 0c             	sub    $0xc,%esp
  802ac7:	50                   	push   %eax
  802ac8:	e8 0c e8 ff ff       	call   8012d9 <sbrk>
  802acd:	83 c4 10             	add    $0x10,%esp
  802ad0:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802ad3:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802ad7:	75 0a                	jne    802ae3 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802ad9:	b8 00 00 00 00       	mov    $0x0,%eax
  802ade:	e9 ae 00 00 00       	jmp    802b91 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802ae3:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802aea:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802aed:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802af0:	01 d0                	add    %edx,%eax
  802af2:	48                   	dec    %eax
  802af3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802af6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802af9:	ba 00 00 00 00       	mov    $0x0,%edx
  802afe:	f7 75 b8             	divl   -0x48(%ebp)
  802b01:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b04:	29 d0                	sub    %edx,%eax
  802b06:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b09:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b0c:	01 d0                	add    %edx,%eax
  802b0e:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802b13:	a1 40 50 80 00       	mov    0x805040,%eax
  802b18:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802b1e:	83 ec 0c             	sub    $0xc,%esp
  802b21:	68 b4 44 80 00       	push   $0x8044b4
  802b26:	e8 14 da ff ff       	call   80053f <cprintf>
  802b2b:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802b2e:	83 ec 08             	sub    $0x8,%esp
  802b31:	ff 75 bc             	pushl  -0x44(%ebp)
  802b34:	68 b9 44 80 00       	push   $0x8044b9
  802b39:	e8 01 da ff ff       	call   80053f <cprintf>
  802b3e:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802b41:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802b48:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b4b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b4e:	01 d0                	add    %edx,%eax
  802b50:	48                   	dec    %eax
  802b51:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802b54:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b57:	ba 00 00 00 00       	mov    $0x0,%edx
  802b5c:	f7 75 b0             	divl   -0x50(%ebp)
  802b5f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b62:	29 d0                	sub    %edx,%eax
  802b64:	83 ec 04             	sub    $0x4,%esp
  802b67:	6a 01                	push   $0x1
  802b69:	50                   	push   %eax
  802b6a:	ff 75 bc             	pushl  -0x44(%ebp)
  802b6d:	e8 51 f5 ff ff       	call   8020c3 <set_block_data>
  802b72:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802b75:	83 ec 0c             	sub    $0xc,%esp
  802b78:	ff 75 bc             	pushl  -0x44(%ebp)
  802b7b:	e8 36 04 00 00       	call   802fb6 <free_block>
  802b80:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802b83:	83 ec 0c             	sub    $0xc,%esp
  802b86:	ff 75 08             	pushl  0x8(%ebp)
  802b89:	e8 20 fa ff ff       	call   8025ae <alloc_block_BF>
  802b8e:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802b91:	c9                   	leave  
  802b92:	c3                   	ret    

00802b93 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802b93:	55                   	push   %ebp
  802b94:	89 e5                	mov    %esp,%ebp
  802b96:	53                   	push   %ebx
  802b97:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802b9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ba1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802ba8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bac:	74 1e                	je     802bcc <merging+0x39>
  802bae:	ff 75 08             	pushl  0x8(%ebp)
  802bb1:	e8 bc f1 ff ff       	call   801d72 <get_block_size>
  802bb6:	83 c4 04             	add    $0x4,%esp
  802bb9:	89 c2                	mov    %eax,%edx
  802bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbe:	01 d0                	add    %edx,%eax
  802bc0:	3b 45 10             	cmp    0x10(%ebp),%eax
  802bc3:	75 07                	jne    802bcc <merging+0x39>
		prev_is_free = 1;
  802bc5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802bcc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802bd0:	74 1e                	je     802bf0 <merging+0x5d>
  802bd2:	ff 75 10             	pushl  0x10(%ebp)
  802bd5:	e8 98 f1 ff ff       	call   801d72 <get_block_size>
  802bda:	83 c4 04             	add    $0x4,%esp
  802bdd:	89 c2                	mov    %eax,%edx
  802bdf:	8b 45 10             	mov    0x10(%ebp),%eax
  802be2:	01 d0                	add    %edx,%eax
  802be4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802be7:	75 07                	jne    802bf0 <merging+0x5d>
		next_is_free = 1;
  802be9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802bf0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf4:	0f 84 cc 00 00 00    	je     802cc6 <merging+0x133>
  802bfa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bfe:	0f 84 c2 00 00 00    	je     802cc6 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802c04:	ff 75 08             	pushl  0x8(%ebp)
  802c07:	e8 66 f1 ff ff       	call   801d72 <get_block_size>
  802c0c:	83 c4 04             	add    $0x4,%esp
  802c0f:	89 c3                	mov    %eax,%ebx
  802c11:	ff 75 10             	pushl  0x10(%ebp)
  802c14:	e8 59 f1 ff ff       	call   801d72 <get_block_size>
  802c19:	83 c4 04             	add    $0x4,%esp
  802c1c:	01 c3                	add    %eax,%ebx
  802c1e:	ff 75 0c             	pushl  0xc(%ebp)
  802c21:	e8 4c f1 ff ff       	call   801d72 <get_block_size>
  802c26:	83 c4 04             	add    $0x4,%esp
  802c29:	01 d8                	add    %ebx,%eax
  802c2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802c2e:	6a 00                	push   $0x0
  802c30:	ff 75 ec             	pushl  -0x14(%ebp)
  802c33:	ff 75 08             	pushl  0x8(%ebp)
  802c36:	e8 88 f4 ff ff       	call   8020c3 <set_block_data>
  802c3b:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802c3e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c42:	75 17                	jne    802c5b <merging+0xc8>
  802c44:	83 ec 04             	sub    $0x4,%esp
  802c47:	68 ef 43 80 00       	push   $0x8043ef
  802c4c:	68 7d 01 00 00       	push   $0x17d
  802c51:	68 0d 44 80 00       	push   $0x80440d
  802c56:	e8 27 d6 ff ff       	call   800282 <_panic>
  802c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c5e:	8b 00                	mov    (%eax),%eax
  802c60:	85 c0                	test   %eax,%eax
  802c62:	74 10                	je     802c74 <merging+0xe1>
  802c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c67:	8b 00                	mov    (%eax),%eax
  802c69:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c6c:	8b 52 04             	mov    0x4(%edx),%edx
  802c6f:	89 50 04             	mov    %edx,0x4(%eax)
  802c72:	eb 0b                	jmp    802c7f <merging+0xec>
  802c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c77:	8b 40 04             	mov    0x4(%eax),%eax
  802c7a:	a3 30 50 80 00       	mov    %eax,0x805030
  802c7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c82:	8b 40 04             	mov    0x4(%eax),%eax
  802c85:	85 c0                	test   %eax,%eax
  802c87:	74 0f                	je     802c98 <merging+0x105>
  802c89:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c8c:	8b 40 04             	mov    0x4(%eax),%eax
  802c8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c92:	8b 12                	mov    (%edx),%edx
  802c94:	89 10                	mov    %edx,(%eax)
  802c96:	eb 0a                	jmp    802ca2 <merging+0x10f>
  802c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c9b:	8b 00                	mov    (%eax),%eax
  802c9d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ca5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cab:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb5:	a1 38 50 80 00       	mov    0x805038,%eax
  802cba:	48                   	dec    %eax
  802cbb:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802cc0:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802cc1:	e9 ea 02 00 00       	jmp    802fb0 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802cc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cca:	74 3b                	je     802d07 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802ccc:	83 ec 0c             	sub    $0xc,%esp
  802ccf:	ff 75 08             	pushl  0x8(%ebp)
  802cd2:	e8 9b f0 ff ff       	call   801d72 <get_block_size>
  802cd7:	83 c4 10             	add    $0x10,%esp
  802cda:	89 c3                	mov    %eax,%ebx
  802cdc:	83 ec 0c             	sub    $0xc,%esp
  802cdf:	ff 75 10             	pushl  0x10(%ebp)
  802ce2:	e8 8b f0 ff ff       	call   801d72 <get_block_size>
  802ce7:	83 c4 10             	add    $0x10,%esp
  802cea:	01 d8                	add    %ebx,%eax
  802cec:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802cef:	83 ec 04             	sub    $0x4,%esp
  802cf2:	6a 00                	push   $0x0
  802cf4:	ff 75 e8             	pushl  -0x18(%ebp)
  802cf7:	ff 75 08             	pushl  0x8(%ebp)
  802cfa:	e8 c4 f3 ff ff       	call   8020c3 <set_block_data>
  802cff:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d02:	e9 a9 02 00 00       	jmp    802fb0 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802d07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d0b:	0f 84 2d 01 00 00    	je     802e3e <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802d11:	83 ec 0c             	sub    $0xc,%esp
  802d14:	ff 75 10             	pushl  0x10(%ebp)
  802d17:	e8 56 f0 ff ff       	call   801d72 <get_block_size>
  802d1c:	83 c4 10             	add    $0x10,%esp
  802d1f:	89 c3                	mov    %eax,%ebx
  802d21:	83 ec 0c             	sub    $0xc,%esp
  802d24:	ff 75 0c             	pushl  0xc(%ebp)
  802d27:	e8 46 f0 ff ff       	call   801d72 <get_block_size>
  802d2c:	83 c4 10             	add    $0x10,%esp
  802d2f:	01 d8                	add    %ebx,%eax
  802d31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802d34:	83 ec 04             	sub    $0x4,%esp
  802d37:	6a 00                	push   $0x0
  802d39:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d3c:	ff 75 10             	pushl  0x10(%ebp)
  802d3f:	e8 7f f3 ff ff       	call   8020c3 <set_block_data>
  802d44:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802d47:	8b 45 10             	mov    0x10(%ebp),%eax
  802d4a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802d4d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d51:	74 06                	je     802d59 <merging+0x1c6>
  802d53:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d57:	75 17                	jne    802d70 <merging+0x1dd>
  802d59:	83 ec 04             	sub    $0x4,%esp
  802d5c:	68 c8 44 80 00       	push   $0x8044c8
  802d61:	68 8d 01 00 00       	push   $0x18d
  802d66:	68 0d 44 80 00       	push   $0x80440d
  802d6b:	e8 12 d5 ff ff       	call   800282 <_panic>
  802d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d73:	8b 50 04             	mov    0x4(%eax),%edx
  802d76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d79:	89 50 04             	mov    %edx,0x4(%eax)
  802d7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d82:	89 10                	mov    %edx,(%eax)
  802d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d87:	8b 40 04             	mov    0x4(%eax),%eax
  802d8a:	85 c0                	test   %eax,%eax
  802d8c:	74 0d                	je     802d9b <merging+0x208>
  802d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d91:	8b 40 04             	mov    0x4(%eax),%eax
  802d94:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d97:	89 10                	mov    %edx,(%eax)
  802d99:	eb 08                	jmp    802da3 <merging+0x210>
  802d9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d9e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802da6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802da9:	89 50 04             	mov    %edx,0x4(%eax)
  802dac:	a1 38 50 80 00       	mov    0x805038,%eax
  802db1:	40                   	inc    %eax
  802db2:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802db7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dbb:	75 17                	jne    802dd4 <merging+0x241>
  802dbd:	83 ec 04             	sub    $0x4,%esp
  802dc0:	68 ef 43 80 00       	push   $0x8043ef
  802dc5:	68 8e 01 00 00       	push   $0x18e
  802dca:	68 0d 44 80 00       	push   $0x80440d
  802dcf:	e8 ae d4 ff ff       	call   800282 <_panic>
  802dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dd7:	8b 00                	mov    (%eax),%eax
  802dd9:	85 c0                	test   %eax,%eax
  802ddb:	74 10                	je     802ded <merging+0x25a>
  802ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de0:	8b 00                	mov    (%eax),%eax
  802de2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802de5:	8b 52 04             	mov    0x4(%edx),%edx
  802de8:	89 50 04             	mov    %edx,0x4(%eax)
  802deb:	eb 0b                	jmp    802df8 <merging+0x265>
  802ded:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df0:	8b 40 04             	mov    0x4(%eax),%eax
  802df3:	a3 30 50 80 00       	mov    %eax,0x805030
  802df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dfb:	8b 40 04             	mov    0x4(%eax),%eax
  802dfe:	85 c0                	test   %eax,%eax
  802e00:	74 0f                	je     802e11 <merging+0x27e>
  802e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e05:	8b 40 04             	mov    0x4(%eax),%eax
  802e08:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e0b:	8b 12                	mov    (%edx),%edx
  802e0d:	89 10                	mov    %edx,(%eax)
  802e0f:	eb 0a                	jmp    802e1b <merging+0x288>
  802e11:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e14:	8b 00                	mov    (%eax),%eax
  802e16:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e2e:	a1 38 50 80 00       	mov    0x805038,%eax
  802e33:	48                   	dec    %eax
  802e34:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e39:	e9 72 01 00 00       	jmp    802fb0 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802e3e:	8b 45 10             	mov    0x10(%ebp),%eax
  802e41:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802e44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e48:	74 79                	je     802ec3 <merging+0x330>
  802e4a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e4e:	74 73                	je     802ec3 <merging+0x330>
  802e50:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e54:	74 06                	je     802e5c <merging+0x2c9>
  802e56:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e5a:	75 17                	jne    802e73 <merging+0x2e0>
  802e5c:	83 ec 04             	sub    $0x4,%esp
  802e5f:	68 80 44 80 00       	push   $0x804480
  802e64:	68 94 01 00 00       	push   $0x194
  802e69:	68 0d 44 80 00       	push   $0x80440d
  802e6e:	e8 0f d4 ff ff       	call   800282 <_panic>
  802e73:	8b 45 08             	mov    0x8(%ebp),%eax
  802e76:	8b 10                	mov    (%eax),%edx
  802e78:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e7b:	89 10                	mov    %edx,(%eax)
  802e7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e80:	8b 00                	mov    (%eax),%eax
  802e82:	85 c0                	test   %eax,%eax
  802e84:	74 0b                	je     802e91 <merging+0x2fe>
  802e86:	8b 45 08             	mov    0x8(%ebp),%eax
  802e89:	8b 00                	mov    (%eax),%eax
  802e8b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e8e:	89 50 04             	mov    %edx,0x4(%eax)
  802e91:	8b 45 08             	mov    0x8(%ebp),%eax
  802e94:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e97:	89 10                	mov    %edx,(%eax)
  802e99:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e9f:	89 50 04             	mov    %edx,0x4(%eax)
  802ea2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ea5:	8b 00                	mov    (%eax),%eax
  802ea7:	85 c0                	test   %eax,%eax
  802ea9:	75 08                	jne    802eb3 <merging+0x320>
  802eab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eae:	a3 30 50 80 00       	mov    %eax,0x805030
  802eb3:	a1 38 50 80 00       	mov    0x805038,%eax
  802eb8:	40                   	inc    %eax
  802eb9:	a3 38 50 80 00       	mov    %eax,0x805038
  802ebe:	e9 ce 00 00 00       	jmp    802f91 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802ec3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec7:	74 65                	je     802f2e <merging+0x39b>
  802ec9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ecd:	75 17                	jne    802ee6 <merging+0x353>
  802ecf:	83 ec 04             	sub    $0x4,%esp
  802ed2:	68 5c 44 80 00       	push   $0x80445c
  802ed7:	68 95 01 00 00       	push   $0x195
  802edc:	68 0d 44 80 00       	push   $0x80440d
  802ee1:	e8 9c d3 ff ff       	call   800282 <_panic>
  802ee6:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802eec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eef:	89 50 04             	mov    %edx,0x4(%eax)
  802ef2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ef5:	8b 40 04             	mov    0x4(%eax),%eax
  802ef8:	85 c0                	test   %eax,%eax
  802efa:	74 0c                	je     802f08 <merging+0x375>
  802efc:	a1 30 50 80 00       	mov    0x805030,%eax
  802f01:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f04:	89 10                	mov    %edx,(%eax)
  802f06:	eb 08                	jmp    802f10 <merging+0x37d>
  802f08:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f0b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f10:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f13:	a3 30 50 80 00       	mov    %eax,0x805030
  802f18:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f21:	a1 38 50 80 00       	mov    0x805038,%eax
  802f26:	40                   	inc    %eax
  802f27:	a3 38 50 80 00       	mov    %eax,0x805038
  802f2c:	eb 63                	jmp    802f91 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802f2e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f32:	75 17                	jne    802f4b <merging+0x3b8>
  802f34:	83 ec 04             	sub    $0x4,%esp
  802f37:	68 28 44 80 00       	push   $0x804428
  802f3c:	68 98 01 00 00       	push   $0x198
  802f41:	68 0d 44 80 00       	push   $0x80440d
  802f46:	e8 37 d3 ff ff       	call   800282 <_panic>
  802f4b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802f51:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f54:	89 10                	mov    %edx,(%eax)
  802f56:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f59:	8b 00                	mov    (%eax),%eax
  802f5b:	85 c0                	test   %eax,%eax
  802f5d:	74 0d                	je     802f6c <merging+0x3d9>
  802f5f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f64:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f67:	89 50 04             	mov    %edx,0x4(%eax)
  802f6a:	eb 08                	jmp    802f74 <merging+0x3e1>
  802f6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f6f:	a3 30 50 80 00       	mov    %eax,0x805030
  802f74:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f77:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f86:	a1 38 50 80 00       	mov    0x805038,%eax
  802f8b:	40                   	inc    %eax
  802f8c:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802f91:	83 ec 0c             	sub    $0xc,%esp
  802f94:	ff 75 10             	pushl  0x10(%ebp)
  802f97:	e8 d6 ed ff ff       	call   801d72 <get_block_size>
  802f9c:	83 c4 10             	add    $0x10,%esp
  802f9f:	83 ec 04             	sub    $0x4,%esp
  802fa2:	6a 00                	push   $0x0
  802fa4:	50                   	push   %eax
  802fa5:	ff 75 10             	pushl  0x10(%ebp)
  802fa8:	e8 16 f1 ff ff       	call   8020c3 <set_block_data>
  802fad:	83 c4 10             	add    $0x10,%esp
	}
}
  802fb0:	90                   	nop
  802fb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fb4:	c9                   	leave  
  802fb5:	c3                   	ret    

00802fb6 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802fb6:	55                   	push   %ebp
  802fb7:	89 e5                	mov    %esp,%ebp
  802fb9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802fbc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fc1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802fc4:	a1 30 50 80 00       	mov    0x805030,%eax
  802fc9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fcc:	73 1b                	jae    802fe9 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802fce:	a1 30 50 80 00       	mov    0x805030,%eax
  802fd3:	83 ec 04             	sub    $0x4,%esp
  802fd6:	ff 75 08             	pushl  0x8(%ebp)
  802fd9:	6a 00                	push   $0x0
  802fdb:	50                   	push   %eax
  802fdc:	e8 b2 fb ff ff       	call   802b93 <merging>
  802fe1:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802fe4:	e9 8b 00 00 00       	jmp    803074 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802fe9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fee:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ff1:	76 18                	jbe    80300b <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802ff3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ff8:	83 ec 04             	sub    $0x4,%esp
  802ffb:	ff 75 08             	pushl  0x8(%ebp)
  802ffe:	50                   	push   %eax
  802fff:	6a 00                	push   $0x0
  803001:	e8 8d fb ff ff       	call   802b93 <merging>
  803006:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803009:	eb 69                	jmp    803074 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80300b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803010:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803013:	eb 39                	jmp    80304e <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803018:	3b 45 08             	cmp    0x8(%ebp),%eax
  80301b:	73 29                	jae    803046 <free_block+0x90>
  80301d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803020:	8b 00                	mov    (%eax),%eax
  803022:	3b 45 08             	cmp    0x8(%ebp),%eax
  803025:	76 1f                	jbe    803046 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302a:	8b 00                	mov    (%eax),%eax
  80302c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80302f:	83 ec 04             	sub    $0x4,%esp
  803032:	ff 75 08             	pushl  0x8(%ebp)
  803035:	ff 75 f0             	pushl  -0x10(%ebp)
  803038:	ff 75 f4             	pushl  -0xc(%ebp)
  80303b:	e8 53 fb ff ff       	call   802b93 <merging>
  803040:	83 c4 10             	add    $0x10,%esp
			break;
  803043:	90                   	nop
		}
	}
}
  803044:	eb 2e                	jmp    803074 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803046:	a1 34 50 80 00       	mov    0x805034,%eax
  80304b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80304e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803052:	74 07                	je     80305b <free_block+0xa5>
  803054:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803057:	8b 00                	mov    (%eax),%eax
  803059:	eb 05                	jmp    803060 <free_block+0xaa>
  80305b:	b8 00 00 00 00       	mov    $0x0,%eax
  803060:	a3 34 50 80 00       	mov    %eax,0x805034
  803065:	a1 34 50 80 00       	mov    0x805034,%eax
  80306a:	85 c0                	test   %eax,%eax
  80306c:	75 a7                	jne    803015 <free_block+0x5f>
  80306e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803072:	75 a1                	jne    803015 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803074:	90                   	nop
  803075:	c9                   	leave  
  803076:	c3                   	ret    

00803077 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803077:	55                   	push   %ebp
  803078:	89 e5                	mov    %esp,%ebp
  80307a:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80307d:	ff 75 08             	pushl  0x8(%ebp)
  803080:	e8 ed ec ff ff       	call   801d72 <get_block_size>
  803085:	83 c4 04             	add    $0x4,%esp
  803088:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80308b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803092:	eb 17                	jmp    8030ab <copy_data+0x34>
  803094:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803097:	8b 45 0c             	mov    0xc(%ebp),%eax
  80309a:	01 c2                	add    %eax,%edx
  80309c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80309f:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a2:	01 c8                	add    %ecx,%eax
  8030a4:	8a 00                	mov    (%eax),%al
  8030a6:	88 02                	mov    %al,(%edx)
  8030a8:	ff 45 fc             	incl   -0x4(%ebp)
  8030ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8030b1:	72 e1                	jb     803094 <copy_data+0x1d>
}
  8030b3:	90                   	nop
  8030b4:	c9                   	leave  
  8030b5:	c3                   	ret    

008030b6 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8030b6:	55                   	push   %ebp
  8030b7:	89 e5                	mov    %esp,%ebp
  8030b9:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8030bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c0:	75 23                	jne    8030e5 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8030c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030c6:	74 13                	je     8030db <realloc_block_FF+0x25>
  8030c8:	83 ec 0c             	sub    $0xc,%esp
  8030cb:	ff 75 0c             	pushl  0xc(%ebp)
  8030ce:	e8 1f f0 ff ff       	call   8020f2 <alloc_block_FF>
  8030d3:	83 c4 10             	add    $0x10,%esp
  8030d6:	e9 f4 06 00 00       	jmp    8037cf <realloc_block_FF+0x719>
		return NULL;
  8030db:	b8 00 00 00 00       	mov    $0x0,%eax
  8030e0:	e9 ea 06 00 00       	jmp    8037cf <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8030e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030e9:	75 18                	jne    803103 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8030eb:	83 ec 0c             	sub    $0xc,%esp
  8030ee:	ff 75 08             	pushl  0x8(%ebp)
  8030f1:	e8 c0 fe ff ff       	call   802fb6 <free_block>
  8030f6:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8030f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8030fe:	e9 cc 06 00 00       	jmp    8037cf <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803103:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803107:	77 07                	ja     803110 <realloc_block_FF+0x5a>
  803109:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803110:	8b 45 0c             	mov    0xc(%ebp),%eax
  803113:	83 e0 01             	and    $0x1,%eax
  803116:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80311c:	83 c0 08             	add    $0x8,%eax
  80311f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803122:	83 ec 0c             	sub    $0xc,%esp
  803125:	ff 75 08             	pushl  0x8(%ebp)
  803128:	e8 45 ec ff ff       	call   801d72 <get_block_size>
  80312d:	83 c4 10             	add    $0x10,%esp
  803130:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803133:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803136:	83 e8 08             	sub    $0x8,%eax
  803139:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80313c:	8b 45 08             	mov    0x8(%ebp),%eax
  80313f:	83 e8 04             	sub    $0x4,%eax
  803142:	8b 00                	mov    (%eax),%eax
  803144:	83 e0 fe             	and    $0xfffffffe,%eax
  803147:	89 c2                	mov    %eax,%edx
  803149:	8b 45 08             	mov    0x8(%ebp),%eax
  80314c:	01 d0                	add    %edx,%eax
  80314e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803151:	83 ec 0c             	sub    $0xc,%esp
  803154:	ff 75 e4             	pushl  -0x1c(%ebp)
  803157:	e8 16 ec ff ff       	call   801d72 <get_block_size>
  80315c:	83 c4 10             	add    $0x10,%esp
  80315f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803162:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803165:	83 e8 08             	sub    $0x8,%eax
  803168:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80316b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80316e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803171:	75 08                	jne    80317b <realloc_block_FF+0xc5>
	{
		 return va;
  803173:	8b 45 08             	mov    0x8(%ebp),%eax
  803176:	e9 54 06 00 00       	jmp    8037cf <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80317b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80317e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803181:	0f 83 e5 03 00 00    	jae    80356c <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803187:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318a:	2b 45 0c             	sub    0xc(%ebp),%eax
  80318d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803190:	83 ec 0c             	sub    $0xc,%esp
  803193:	ff 75 e4             	pushl  -0x1c(%ebp)
  803196:	e8 f0 eb ff ff       	call   801d8b <is_free_block>
  80319b:	83 c4 10             	add    $0x10,%esp
  80319e:	84 c0                	test   %al,%al
  8031a0:	0f 84 3b 01 00 00    	je     8032e1 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8031a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031ac:	01 d0                	add    %edx,%eax
  8031ae:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8031b1:	83 ec 04             	sub    $0x4,%esp
  8031b4:	6a 01                	push   $0x1
  8031b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8031b9:	ff 75 08             	pushl  0x8(%ebp)
  8031bc:	e8 02 ef ff ff       	call   8020c3 <set_block_data>
  8031c1:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c7:	83 e8 04             	sub    $0x4,%eax
  8031ca:	8b 00                	mov    (%eax),%eax
  8031cc:	83 e0 fe             	and    $0xfffffffe,%eax
  8031cf:	89 c2                	mov    %eax,%edx
  8031d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d4:	01 d0                	add    %edx,%eax
  8031d6:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8031d9:	83 ec 04             	sub    $0x4,%esp
  8031dc:	6a 00                	push   $0x0
  8031de:	ff 75 cc             	pushl  -0x34(%ebp)
  8031e1:	ff 75 c8             	pushl  -0x38(%ebp)
  8031e4:	e8 da ee ff ff       	call   8020c3 <set_block_data>
  8031e9:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8031ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031f0:	74 06                	je     8031f8 <realloc_block_FF+0x142>
  8031f2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8031f6:	75 17                	jne    80320f <realloc_block_FF+0x159>
  8031f8:	83 ec 04             	sub    $0x4,%esp
  8031fb:	68 80 44 80 00       	push   $0x804480
  803200:	68 f6 01 00 00       	push   $0x1f6
  803205:	68 0d 44 80 00       	push   $0x80440d
  80320a:	e8 73 d0 ff ff       	call   800282 <_panic>
  80320f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803212:	8b 10                	mov    (%eax),%edx
  803214:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803217:	89 10                	mov    %edx,(%eax)
  803219:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80321c:	8b 00                	mov    (%eax),%eax
  80321e:	85 c0                	test   %eax,%eax
  803220:	74 0b                	je     80322d <realloc_block_FF+0x177>
  803222:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803225:	8b 00                	mov    (%eax),%eax
  803227:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80322a:	89 50 04             	mov    %edx,0x4(%eax)
  80322d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803230:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803233:	89 10                	mov    %edx,(%eax)
  803235:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803238:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80323b:	89 50 04             	mov    %edx,0x4(%eax)
  80323e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803241:	8b 00                	mov    (%eax),%eax
  803243:	85 c0                	test   %eax,%eax
  803245:	75 08                	jne    80324f <realloc_block_FF+0x199>
  803247:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80324a:	a3 30 50 80 00       	mov    %eax,0x805030
  80324f:	a1 38 50 80 00       	mov    0x805038,%eax
  803254:	40                   	inc    %eax
  803255:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80325a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80325e:	75 17                	jne    803277 <realloc_block_FF+0x1c1>
  803260:	83 ec 04             	sub    $0x4,%esp
  803263:	68 ef 43 80 00       	push   $0x8043ef
  803268:	68 f7 01 00 00       	push   $0x1f7
  80326d:	68 0d 44 80 00       	push   $0x80440d
  803272:	e8 0b d0 ff ff       	call   800282 <_panic>
  803277:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80327a:	8b 00                	mov    (%eax),%eax
  80327c:	85 c0                	test   %eax,%eax
  80327e:	74 10                	je     803290 <realloc_block_FF+0x1da>
  803280:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803283:	8b 00                	mov    (%eax),%eax
  803285:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803288:	8b 52 04             	mov    0x4(%edx),%edx
  80328b:	89 50 04             	mov    %edx,0x4(%eax)
  80328e:	eb 0b                	jmp    80329b <realloc_block_FF+0x1e5>
  803290:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803293:	8b 40 04             	mov    0x4(%eax),%eax
  803296:	a3 30 50 80 00       	mov    %eax,0x805030
  80329b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80329e:	8b 40 04             	mov    0x4(%eax),%eax
  8032a1:	85 c0                	test   %eax,%eax
  8032a3:	74 0f                	je     8032b4 <realloc_block_FF+0x1fe>
  8032a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a8:	8b 40 04             	mov    0x4(%eax),%eax
  8032ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032ae:	8b 12                	mov    (%edx),%edx
  8032b0:	89 10                	mov    %edx,(%eax)
  8032b2:	eb 0a                	jmp    8032be <realloc_block_FF+0x208>
  8032b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b7:	8b 00                	mov    (%eax),%eax
  8032b9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d1:	a1 38 50 80 00       	mov    0x805038,%eax
  8032d6:	48                   	dec    %eax
  8032d7:	a3 38 50 80 00       	mov    %eax,0x805038
  8032dc:	e9 83 02 00 00       	jmp    803564 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8032e1:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8032e5:	0f 86 69 02 00 00    	jbe    803554 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8032eb:	83 ec 04             	sub    $0x4,%esp
  8032ee:	6a 01                	push   $0x1
  8032f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8032f3:	ff 75 08             	pushl  0x8(%ebp)
  8032f6:	e8 c8 ed ff ff       	call   8020c3 <set_block_data>
  8032fb:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8032fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803301:	83 e8 04             	sub    $0x4,%eax
  803304:	8b 00                	mov    (%eax),%eax
  803306:	83 e0 fe             	and    $0xfffffffe,%eax
  803309:	89 c2                	mov    %eax,%edx
  80330b:	8b 45 08             	mov    0x8(%ebp),%eax
  80330e:	01 d0                	add    %edx,%eax
  803310:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803313:	a1 38 50 80 00       	mov    0x805038,%eax
  803318:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80331b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80331f:	75 68                	jne    803389 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803321:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803325:	75 17                	jne    80333e <realloc_block_FF+0x288>
  803327:	83 ec 04             	sub    $0x4,%esp
  80332a:	68 28 44 80 00       	push   $0x804428
  80332f:	68 06 02 00 00       	push   $0x206
  803334:	68 0d 44 80 00       	push   $0x80440d
  803339:	e8 44 cf ff ff       	call   800282 <_panic>
  80333e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803344:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803347:	89 10                	mov    %edx,(%eax)
  803349:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80334c:	8b 00                	mov    (%eax),%eax
  80334e:	85 c0                	test   %eax,%eax
  803350:	74 0d                	je     80335f <realloc_block_FF+0x2a9>
  803352:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803357:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80335a:	89 50 04             	mov    %edx,0x4(%eax)
  80335d:	eb 08                	jmp    803367 <realloc_block_FF+0x2b1>
  80335f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803362:	a3 30 50 80 00       	mov    %eax,0x805030
  803367:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80336a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80336f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803372:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803379:	a1 38 50 80 00       	mov    0x805038,%eax
  80337e:	40                   	inc    %eax
  80337f:	a3 38 50 80 00       	mov    %eax,0x805038
  803384:	e9 b0 01 00 00       	jmp    803539 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803389:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80338e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803391:	76 68                	jbe    8033fb <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803393:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803397:	75 17                	jne    8033b0 <realloc_block_FF+0x2fa>
  803399:	83 ec 04             	sub    $0x4,%esp
  80339c:	68 28 44 80 00       	push   $0x804428
  8033a1:	68 0b 02 00 00       	push   $0x20b
  8033a6:	68 0d 44 80 00       	push   $0x80440d
  8033ab:	e8 d2 ce ff ff       	call   800282 <_panic>
  8033b0:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8033b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033b9:	89 10                	mov    %edx,(%eax)
  8033bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033be:	8b 00                	mov    (%eax),%eax
  8033c0:	85 c0                	test   %eax,%eax
  8033c2:	74 0d                	je     8033d1 <realloc_block_FF+0x31b>
  8033c4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033c9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033cc:	89 50 04             	mov    %edx,0x4(%eax)
  8033cf:	eb 08                	jmp    8033d9 <realloc_block_FF+0x323>
  8033d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033d4:	a3 30 50 80 00       	mov    %eax,0x805030
  8033d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033dc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033eb:	a1 38 50 80 00       	mov    0x805038,%eax
  8033f0:	40                   	inc    %eax
  8033f1:	a3 38 50 80 00       	mov    %eax,0x805038
  8033f6:	e9 3e 01 00 00       	jmp    803539 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8033fb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803400:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803403:	73 68                	jae    80346d <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803405:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803409:	75 17                	jne    803422 <realloc_block_FF+0x36c>
  80340b:	83 ec 04             	sub    $0x4,%esp
  80340e:	68 5c 44 80 00       	push   $0x80445c
  803413:	68 10 02 00 00       	push   $0x210
  803418:	68 0d 44 80 00       	push   $0x80440d
  80341d:	e8 60 ce ff ff       	call   800282 <_panic>
  803422:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803428:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80342b:	89 50 04             	mov    %edx,0x4(%eax)
  80342e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803431:	8b 40 04             	mov    0x4(%eax),%eax
  803434:	85 c0                	test   %eax,%eax
  803436:	74 0c                	je     803444 <realloc_block_FF+0x38e>
  803438:	a1 30 50 80 00       	mov    0x805030,%eax
  80343d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803440:	89 10                	mov    %edx,(%eax)
  803442:	eb 08                	jmp    80344c <realloc_block_FF+0x396>
  803444:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803447:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80344c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80344f:	a3 30 50 80 00       	mov    %eax,0x805030
  803454:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803457:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80345d:	a1 38 50 80 00       	mov    0x805038,%eax
  803462:	40                   	inc    %eax
  803463:	a3 38 50 80 00       	mov    %eax,0x805038
  803468:	e9 cc 00 00 00       	jmp    803539 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80346d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803474:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803479:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80347c:	e9 8a 00 00 00       	jmp    80350b <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803484:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803487:	73 7a                	jae    803503 <realloc_block_FF+0x44d>
  803489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348c:	8b 00                	mov    (%eax),%eax
  80348e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803491:	73 70                	jae    803503 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803493:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803497:	74 06                	je     80349f <realloc_block_FF+0x3e9>
  803499:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80349d:	75 17                	jne    8034b6 <realloc_block_FF+0x400>
  80349f:	83 ec 04             	sub    $0x4,%esp
  8034a2:	68 80 44 80 00       	push   $0x804480
  8034a7:	68 1a 02 00 00       	push   $0x21a
  8034ac:	68 0d 44 80 00       	push   $0x80440d
  8034b1:	e8 cc cd ff ff       	call   800282 <_panic>
  8034b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b9:	8b 10                	mov    (%eax),%edx
  8034bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034be:	89 10                	mov    %edx,(%eax)
  8034c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c3:	8b 00                	mov    (%eax),%eax
  8034c5:	85 c0                	test   %eax,%eax
  8034c7:	74 0b                	je     8034d4 <realloc_block_FF+0x41e>
  8034c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cc:	8b 00                	mov    (%eax),%eax
  8034ce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034d1:	89 50 04             	mov    %edx,0x4(%eax)
  8034d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034da:	89 10                	mov    %edx,(%eax)
  8034dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034e2:	89 50 04             	mov    %edx,0x4(%eax)
  8034e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e8:	8b 00                	mov    (%eax),%eax
  8034ea:	85 c0                	test   %eax,%eax
  8034ec:	75 08                	jne    8034f6 <realloc_block_FF+0x440>
  8034ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034f1:	a3 30 50 80 00       	mov    %eax,0x805030
  8034f6:	a1 38 50 80 00       	mov    0x805038,%eax
  8034fb:	40                   	inc    %eax
  8034fc:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803501:	eb 36                	jmp    803539 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803503:	a1 34 50 80 00       	mov    0x805034,%eax
  803508:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80350b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80350f:	74 07                	je     803518 <realloc_block_FF+0x462>
  803511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803514:	8b 00                	mov    (%eax),%eax
  803516:	eb 05                	jmp    80351d <realloc_block_FF+0x467>
  803518:	b8 00 00 00 00       	mov    $0x0,%eax
  80351d:	a3 34 50 80 00       	mov    %eax,0x805034
  803522:	a1 34 50 80 00       	mov    0x805034,%eax
  803527:	85 c0                	test   %eax,%eax
  803529:	0f 85 52 ff ff ff    	jne    803481 <realloc_block_FF+0x3cb>
  80352f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803533:	0f 85 48 ff ff ff    	jne    803481 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803539:	83 ec 04             	sub    $0x4,%esp
  80353c:	6a 00                	push   $0x0
  80353e:	ff 75 d8             	pushl  -0x28(%ebp)
  803541:	ff 75 d4             	pushl  -0x2c(%ebp)
  803544:	e8 7a eb ff ff       	call   8020c3 <set_block_data>
  803549:	83 c4 10             	add    $0x10,%esp
				return va;
  80354c:	8b 45 08             	mov    0x8(%ebp),%eax
  80354f:	e9 7b 02 00 00       	jmp    8037cf <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803554:	83 ec 0c             	sub    $0xc,%esp
  803557:	68 fd 44 80 00       	push   $0x8044fd
  80355c:	e8 de cf ff ff       	call   80053f <cprintf>
  803561:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803564:	8b 45 08             	mov    0x8(%ebp),%eax
  803567:	e9 63 02 00 00       	jmp    8037cf <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80356c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80356f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803572:	0f 86 4d 02 00 00    	jbe    8037c5 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803578:	83 ec 0c             	sub    $0xc,%esp
  80357b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80357e:	e8 08 e8 ff ff       	call   801d8b <is_free_block>
  803583:	83 c4 10             	add    $0x10,%esp
  803586:	84 c0                	test   %al,%al
  803588:	0f 84 37 02 00 00    	je     8037c5 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80358e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803591:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803594:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803597:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80359a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80359d:	76 38                	jbe    8035d7 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80359f:	83 ec 0c             	sub    $0xc,%esp
  8035a2:	ff 75 08             	pushl  0x8(%ebp)
  8035a5:	e8 0c fa ff ff       	call   802fb6 <free_block>
  8035aa:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8035ad:	83 ec 0c             	sub    $0xc,%esp
  8035b0:	ff 75 0c             	pushl  0xc(%ebp)
  8035b3:	e8 3a eb ff ff       	call   8020f2 <alloc_block_FF>
  8035b8:	83 c4 10             	add    $0x10,%esp
  8035bb:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8035be:	83 ec 08             	sub    $0x8,%esp
  8035c1:	ff 75 c0             	pushl  -0x40(%ebp)
  8035c4:	ff 75 08             	pushl  0x8(%ebp)
  8035c7:	e8 ab fa ff ff       	call   803077 <copy_data>
  8035cc:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8035cf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8035d2:	e9 f8 01 00 00       	jmp    8037cf <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8035d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035da:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8035dd:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8035e0:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8035e4:	0f 87 a0 00 00 00    	ja     80368a <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8035ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035ee:	75 17                	jne    803607 <realloc_block_FF+0x551>
  8035f0:	83 ec 04             	sub    $0x4,%esp
  8035f3:	68 ef 43 80 00       	push   $0x8043ef
  8035f8:	68 38 02 00 00       	push   $0x238
  8035fd:	68 0d 44 80 00       	push   $0x80440d
  803602:	e8 7b cc ff ff       	call   800282 <_panic>
  803607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360a:	8b 00                	mov    (%eax),%eax
  80360c:	85 c0                	test   %eax,%eax
  80360e:	74 10                	je     803620 <realloc_block_FF+0x56a>
  803610:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803613:	8b 00                	mov    (%eax),%eax
  803615:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803618:	8b 52 04             	mov    0x4(%edx),%edx
  80361b:	89 50 04             	mov    %edx,0x4(%eax)
  80361e:	eb 0b                	jmp    80362b <realloc_block_FF+0x575>
  803620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803623:	8b 40 04             	mov    0x4(%eax),%eax
  803626:	a3 30 50 80 00       	mov    %eax,0x805030
  80362b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80362e:	8b 40 04             	mov    0x4(%eax),%eax
  803631:	85 c0                	test   %eax,%eax
  803633:	74 0f                	je     803644 <realloc_block_FF+0x58e>
  803635:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803638:	8b 40 04             	mov    0x4(%eax),%eax
  80363b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80363e:	8b 12                	mov    (%edx),%edx
  803640:	89 10                	mov    %edx,(%eax)
  803642:	eb 0a                	jmp    80364e <realloc_block_FF+0x598>
  803644:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803647:	8b 00                	mov    (%eax),%eax
  803649:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80364e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803651:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80365a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803661:	a1 38 50 80 00       	mov    0x805038,%eax
  803666:	48                   	dec    %eax
  803667:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80366c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80366f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803672:	01 d0                	add    %edx,%eax
  803674:	83 ec 04             	sub    $0x4,%esp
  803677:	6a 01                	push   $0x1
  803679:	50                   	push   %eax
  80367a:	ff 75 08             	pushl  0x8(%ebp)
  80367d:	e8 41 ea ff ff       	call   8020c3 <set_block_data>
  803682:	83 c4 10             	add    $0x10,%esp
  803685:	e9 36 01 00 00       	jmp    8037c0 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80368a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80368d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803690:	01 d0                	add    %edx,%eax
  803692:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803695:	83 ec 04             	sub    $0x4,%esp
  803698:	6a 01                	push   $0x1
  80369a:	ff 75 f0             	pushl  -0x10(%ebp)
  80369d:	ff 75 08             	pushl  0x8(%ebp)
  8036a0:	e8 1e ea ff ff       	call   8020c3 <set_block_data>
  8036a5:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8036a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ab:	83 e8 04             	sub    $0x4,%eax
  8036ae:	8b 00                	mov    (%eax),%eax
  8036b0:	83 e0 fe             	and    $0xfffffffe,%eax
  8036b3:	89 c2                	mov    %eax,%edx
  8036b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b8:	01 d0                	add    %edx,%eax
  8036ba:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8036bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036c1:	74 06                	je     8036c9 <realloc_block_FF+0x613>
  8036c3:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8036c7:	75 17                	jne    8036e0 <realloc_block_FF+0x62a>
  8036c9:	83 ec 04             	sub    $0x4,%esp
  8036cc:	68 80 44 80 00       	push   $0x804480
  8036d1:	68 44 02 00 00       	push   $0x244
  8036d6:	68 0d 44 80 00       	push   $0x80440d
  8036db:	e8 a2 cb ff ff       	call   800282 <_panic>
  8036e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e3:	8b 10                	mov    (%eax),%edx
  8036e5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036e8:	89 10                	mov    %edx,(%eax)
  8036ea:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036ed:	8b 00                	mov    (%eax),%eax
  8036ef:	85 c0                	test   %eax,%eax
  8036f1:	74 0b                	je     8036fe <realloc_block_FF+0x648>
  8036f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f6:	8b 00                	mov    (%eax),%eax
  8036f8:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8036fb:	89 50 04             	mov    %edx,0x4(%eax)
  8036fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803701:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803704:	89 10                	mov    %edx,(%eax)
  803706:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803709:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80370c:	89 50 04             	mov    %edx,0x4(%eax)
  80370f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803712:	8b 00                	mov    (%eax),%eax
  803714:	85 c0                	test   %eax,%eax
  803716:	75 08                	jne    803720 <realloc_block_FF+0x66a>
  803718:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80371b:	a3 30 50 80 00       	mov    %eax,0x805030
  803720:	a1 38 50 80 00       	mov    0x805038,%eax
  803725:	40                   	inc    %eax
  803726:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80372b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80372f:	75 17                	jne    803748 <realloc_block_FF+0x692>
  803731:	83 ec 04             	sub    $0x4,%esp
  803734:	68 ef 43 80 00       	push   $0x8043ef
  803739:	68 45 02 00 00       	push   $0x245
  80373e:	68 0d 44 80 00       	push   $0x80440d
  803743:	e8 3a cb ff ff       	call   800282 <_panic>
  803748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80374b:	8b 00                	mov    (%eax),%eax
  80374d:	85 c0                	test   %eax,%eax
  80374f:	74 10                	je     803761 <realloc_block_FF+0x6ab>
  803751:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803754:	8b 00                	mov    (%eax),%eax
  803756:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803759:	8b 52 04             	mov    0x4(%edx),%edx
  80375c:	89 50 04             	mov    %edx,0x4(%eax)
  80375f:	eb 0b                	jmp    80376c <realloc_block_FF+0x6b6>
  803761:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803764:	8b 40 04             	mov    0x4(%eax),%eax
  803767:	a3 30 50 80 00       	mov    %eax,0x805030
  80376c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80376f:	8b 40 04             	mov    0x4(%eax),%eax
  803772:	85 c0                	test   %eax,%eax
  803774:	74 0f                	je     803785 <realloc_block_FF+0x6cf>
  803776:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803779:	8b 40 04             	mov    0x4(%eax),%eax
  80377c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80377f:	8b 12                	mov    (%edx),%edx
  803781:	89 10                	mov    %edx,(%eax)
  803783:	eb 0a                	jmp    80378f <realloc_block_FF+0x6d9>
  803785:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803788:	8b 00                	mov    (%eax),%eax
  80378a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80378f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803792:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803798:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037a2:	a1 38 50 80 00       	mov    0x805038,%eax
  8037a7:	48                   	dec    %eax
  8037a8:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8037ad:	83 ec 04             	sub    $0x4,%esp
  8037b0:	6a 00                	push   $0x0
  8037b2:	ff 75 bc             	pushl  -0x44(%ebp)
  8037b5:	ff 75 b8             	pushl  -0x48(%ebp)
  8037b8:	e8 06 e9 ff ff       	call   8020c3 <set_block_data>
  8037bd:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8037c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c3:	eb 0a                	jmp    8037cf <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8037c5:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8037cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8037cf:	c9                   	leave  
  8037d0:	c3                   	ret    

008037d1 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8037d1:	55                   	push   %ebp
  8037d2:	89 e5                	mov    %esp,%ebp
  8037d4:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8037d7:	83 ec 04             	sub    $0x4,%esp
  8037da:	68 04 45 80 00       	push   $0x804504
  8037df:	68 58 02 00 00       	push   $0x258
  8037e4:	68 0d 44 80 00       	push   $0x80440d
  8037e9:	e8 94 ca ff ff       	call   800282 <_panic>

008037ee <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8037ee:	55                   	push   %ebp
  8037ef:	89 e5                	mov    %esp,%ebp
  8037f1:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8037f4:	83 ec 04             	sub    $0x4,%esp
  8037f7:	68 2c 45 80 00       	push   $0x80452c
  8037fc:	68 61 02 00 00       	push   $0x261
  803801:	68 0d 44 80 00       	push   $0x80440d
  803806:	e8 77 ca ff ff       	call   800282 <_panic>

0080380b <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80380b:	55                   	push   %ebp
  80380c:	89 e5                	mov    %esp,%ebp
  80380e:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803811:	8b 55 08             	mov    0x8(%ebp),%edx
  803814:	89 d0                	mov    %edx,%eax
  803816:	c1 e0 02             	shl    $0x2,%eax
  803819:	01 d0                	add    %edx,%eax
  80381b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803822:	01 d0                	add    %edx,%eax
  803824:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80382b:	01 d0                	add    %edx,%eax
  80382d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803834:	01 d0                	add    %edx,%eax
  803836:	c1 e0 04             	shl    $0x4,%eax
  803839:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80383c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803843:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803846:	83 ec 0c             	sub    $0xc,%esp
  803849:	50                   	push   %eax
  80384a:	e8 2f e2 ff ff       	call   801a7e <sys_get_virtual_time>
  80384f:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803852:	eb 41                	jmp    803895 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803854:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803857:	83 ec 0c             	sub    $0xc,%esp
  80385a:	50                   	push   %eax
  80385b:	e8 1e e2 ff ff       	call   801a7e <sys_get_virtual_time>
  803860:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803863:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803866:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803869:	29 c2                	sub    %eax,%edx
  80386b:	89 d0                	mov    %edx,%eax
  80386d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803870:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803873:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803876:	89 d1                	mov    %edx,%ecx
  803878:	29 c1                	sub    %eax,%ecx
  80387a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80387d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803880:	39 c2                	cmp    %eax,%edx
  803882:	0f 97 c0             	seta   %al
  803885:	0f b6 c0             	movzbl %al,%eax
  803888:	29 c1                	sub    %eax,%ecx
  80388a:	89 c8                	mov    %ecx,%eax
  80388c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80388f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803892:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803898:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80389b:	72 b7                	jb     803854 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80389d:	90                   	nop
  80389e:	c9                   	leave  
  80389f:	c3                   	ret    

008038a0 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8038a0:	55                   	push   %ebp
  8038a1:	89 e5                	mov    %esp,%ebp
  8038a3:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8038a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8038ad:	eb 03                	jmp    8038b2 <busy_wait+0x12>
  8038af:	ff 45 fc             	incl   -0x4(%ebp)
  8038b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8038b5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038b8:	72 f5                	jb     8038af <busy_wait+0xf>
	return i;
  8038ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8038bd:	c9                   	leave  
  8038be:	c3                   	ret    
  8038bf:	90                   	nop

008038c0 <__udivdi3>:
  8038c0:	55                   	push   %ebp
  8038c1:	57                   	push   %edi
  8038c2:	56                   	push   %esi
  8038c3:	53                   	push   %ebx
  8038c4:	83 ec 1c             	sub    $0x1c,%esp
  8038c7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8038cb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8038cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038d7:	89 ca                	mov    %ecx,%edx
  8038d9:	89 f8                	mov    %edi,%eax
  8038db:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8038df:	85 f6                	test   %esi,%esi
  8038e1:	75 2d                	jne    803910 <__udivdi3+0x50>
  8038e3:	39 cf                	cmp    %ecx,%edi
  8038e5:	77 65                	ja     80394c <__udivdi3+0x8c>
  8038e7:	89 fd                	mov    %edi,%ebp
  8038e9:	85 ff                	test   %edi,%edi
  8038eb:	75 0b                	jne    8038f8 <__udivdi3+0x38>
  8038ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8038f2:	31 d2                	xor    %edx,%edx
  8038f4:	f7 f7                	div    %edi
  8038f6:	89 c5                	mov    %eax,%ebp
  8038f8:	31 d2                	xor    %edx,%edx
  8038fa:	89 c8                	mov    %ecx,%eax
  8038fc:	f7 f5                	div    %ebp
  8038fe:	89 c1                	mov    %eax,%ecx
  803900:	89 d8                	mov    %ebx,%eax
  803902:	f7 f5                	div    %ebp
  803904:	89 cf                	mov    %ecx,%edi
  803906:	89 fa                	mov    %edi,%edx
  803908:	83 c4 1c             	add    $0x1c,%esp
  80390b:	5b                   	pop    %ebx
  80390c:	5e                   	pop    %esi
  80390d:	5f                   	pop    %edi
  80390e:	5d                   	pop    %ebp
  80390f:	c3                   	ret    
  803910:	39 ce                	cmp    %ecx,%esi
  803912:	77 28                	ja     80393c <__udivdi3+0x7c>
  803914:	0f bd fe             	bsr    %esi,%edi
  803917:	83 f7 1f             	xor    $0x1f,%edi
  80391a:	75 40                	jne    80395c <__udivdi3+0x9c>
  80391c:	39 ce                	cmp    %ecx,%esi
  80391e:	72 0a                	jb     80392a <__udivdi3+0x6a>
  803920:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803924:	0f 87 9e 00 00 00    	ja     8039c8 <__udivdi3+0x108>
  80392a:	b8 01 00 00 00       	mov    $0x1,%eax
  80392f:	89 fa                	mov    %edi,%edx
  803931:	83 c4 1c             	add    $0x1c,%esp
  803934:	5b                   	pop    %ebx
  803935:	5e                   	pop    %esi
  803936:	5f                   	pop    %edi
  803937:	5d                   	pop    %ebp
  803938:	c3                   	ret    
  803939:	8d 76 00             	lea    0x0(%esi),%esi
  80393c:	31 ff                	xor    %edi,%edi
  80393e:	31 c0                	xor    %eax,%eax
  803940:	89 fa                	mov    %edi,%edx
  803942:	83 c4 1c             	add    $0x1c,%esp
  803945:	5b                   	pop    %ebx
  803946:	5e                   	pop    %esi
  803947:	5f                   	pop    %edi
  803948:	5d                   	pop    %ebp
  803949:	c3                   	ret    
  80394a:	66 90                	xchg   %ax,%ax
  80394c:	89 d8                	mov    %ebx,%eax
  80394e:	f7 f7                	div    %edi
  803950:	31 ff                	xor    %edi,%edi
  803952:	89 fa                	mov    %edi,%edx
  803954:	83 c4 1c             	add    $0x1c,%esp
  803957:	5b                   	pop    %ebx
  803958:	5e                   	pop    %esi
  803959:	5f                   	pop    %edi
  80395a:	5d                   	pop    %ebp
  80395b:	c3                   	ret    
  80395c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803961:	89 eb                	mov    %ebp,%ebx
  803963:	29 fb                	sub    %edi,%ebx
  803965:	89 f9                	mov    %edi,%ecx
  803967:	d3 e6                	shl    %cl,%esi
  803969:	89 c5                	mov    %eax,%ebp
  80396b:	88 d9                	mov    %bl,%cl
  80396d:	d3 ed                	shr    %cl,%ebp
  80396f:	89 e9                	mov    %ebp,%ecx
  803971:	09 f1                	or     %esi,%ecx
  803973:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803977:	89 f9                	mov    %edi,%ecx
  803979:	d3 e0                	shl    %cl,%eax
  80397b:	89 c5                	mov    %eax,%ebp
  80397d:	89 d6                	mov    %edx,%esi
  80397f:	88 d9                	mov    %bl,%cl
  803981:	d3 ee                	shr    %cl,%esi
  803983:	89 f9                	mov    %edi,%ecx
  803985:	d3 e2                	shl    %cl,%edx
  803987:	8b 44 24 08          	mov    0x8(%esp),%eax
  80398b:	88 d9                	mov    %bl,%cl
  80398d:	d3 e8                	shr    %cl,%eax
  80398f:	09 c2                	or     %eax,%edx
  803991:	89 d0                	mov    %edx,%eax
  803993:	89 f2                	mov    %esi,%edx
  803995:	f7 74 24 0c          	divl   0xc(%esp)
  803999:	89 d6                	mov    %edx,%esi
  80399b:	89 c3                	mov    %eax,%ebx
  80399d:	f7 e5                	mul    %ebp
  80399f:	39 d6                	cmp    %edx,%esi
  8039a1:	72 19                	jb     8039bc <__udivdi3+0xfc>
  8039a3:	74 0b                	je     8039b0 <__udivdi3+0xf0>
  8039a5:	89 d8                	mov    %ebx,%eax
  8039a7:	31 ff                	xor    %edi,%edi
  8039a9:	e9 58 ff ff ff       	jmp    803906 <__udivdi3+0x46>
  8039ae:	66 90                	xchg   %ax,%ax
  8039b0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8039b4:	89 f9                	mov    %edi,%ecx
  8039b6:	d3 e2                	shl    %cl,%edx
  8039b8:	39 c2                	cmp    %eax,%edx
  8039ba:	73 e9                	jae    8039a5 <__udivdi3+0xe5>
  8039bc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8039bf:	31 ff                	xor    %edi,%edi
  8039c1:	e9 40 ff ff ff       	jmp    803906 <__udivdi3+0x46>
  8039c6:	66 90                	xchg   %ax,%ax
  8039c8:	31 c0                	xor    %eax,%eax
  8039ca:	e9 37 ff ff ff       	jmp    803906 <__udivdi3+0x46>
  8039cf:	90                   	nop

008039d0 <__umoddi3>:
  8039d0:	55                   	push   %ebp
  8039d1:	57                   	push   %edi
  8039d2:	56                   	push   %esi
  8039d3:	53                   	push   %ebx
  8039d4:	83 ec 1c             	sub    $0x1c,%esp
  8039d7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8039db:	8b 74 24 34          	mov    0x34(%esp),%esi
  8039df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039e3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039eb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039ef:	89 f3                	mov    %esi,%ebx
  8039f1:	89 fa                	mov    %edi,%edx
  8039f3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039f7:	89 34 24             	mov    %esi,(%esp)
  8039fa:	85 c0                	test   %eax,%eax
  8039fc:	75 1a                	jne    803a18 <__umoddi3+0x48>
  8039fe:	39 f7                	cmp    %esi,%edi
  803a00:	0f 86 a2 00 00 00    	jbe    803aa8 <__umoddi3+0xd8>
  803a06:	89 c8                	mov    %ecx,%eax
  803a08:	89 f2                	mov    %esi,%edx
  803a0a:	f7 f7                	div    %edi
  803a0c:	89 d0                	mov    %edx,%eax
  803a0e:	31 d2                	xor    %edx,%edx
  803a10:	83 c4 1c             	add    $0x1c,%esp
  803a13:	5b                   	pop    %ebx
  803a14:	5e                   	pop    %esi
  803a15:	5f                   	pop    %edi
  803a16:	5d                   	pop    %ebp
  803a17:	c3                   	ret    
  803a18:	39 f0                	cmp    %esi,%eax
  803a1a:	0f 87 ac 00 00 00    	ja     803acc <__umoddi3+0xfc>
  803a20:	0f bd e8             	bsr    %eax,%ebp
  803a23:	83 f5 1f             	xor    $0x1f,%ebp
  803a26:	0f 84 ac 00 00 00    	je     803ad8 <__umoddi3+0x108>
  803a2c:	bf 20 00 00 00       	mov    $0x20,%edi
  803a31:	29 ef                	sub    %ebp,%edi
  803a33:	89 fe                	mov    %edi,%esi
  803a35:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a39:	89 e9                	mov    %ebp,%ecx
  803a3b:	d3 e0                	shl    %cl,%eax
  803a3d:	89 d7                	mov    %edx,%edi
  803a3f:	89 f1                	mov    %esi,%ecx
  803a41:	d3 ef                	shr    %cl,%edi
  803a43:	09 c7                	or     %eax,%edi
  803a45:	89 e9                	mov    %ebp,%ecx
  803a47:	d3 e2                	shl    %cl,%edx
  803a49:	89 14 24             	mov    %edx,(%esp)
  803a4c:	89 d8                	mov    %ebx,%eax
  803a4e:	d3 e0                	shl    %cl,%eax
  803a50:	89 c2                	mov    %eax,%edx
  803a52:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a56:	d3 e0                	shl    %cl,%eax
  803a58:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a5c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a60:	89 f1                	mov    %esi,%ecx
  803a62:	d3 e8                	shr    %cl,%eax
  803a64:	09 d0                	or     %edx,%eax
  803a66:	d3 eb                	shr    %cl,%ebx
  803a68:	89 da                	mov    %ebx,%edx
  803a6a:	f7 f7                	div    %edi
  803a6c:	89 d3                	mov    %edx,%ebx
  803a6e:	f7 24 24             	mull   (%esp)
  803a71:	89 c6                	mov    %eax,%esi
  803a73:	89 d1                	mov    %edx,%ecx
  803a75:	39 d3                	cmp    %edx,%ebx
  803a77:	0f 82 87 00 00 00    	jb     803b04 <__umoddi3+0x134>
  803a7d:	0f 84 91 00 00 00    	je     803b14 <__umoddi3+0x144>
  803a83:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a87:	29 f2                	sub    %esi,%edx
  803a89:	19 cb                	sbb    %ecx,%ebx
  803a8b:	89 d8                	mov    %ebx,%eax
  803a8d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a91:	d3 e0                	shl    %cl,%eax
  803a93:	89 e9                	mov    %ebp,%ecx
  803a95:	d3 ea                	shr    %cl,%edx
  803a97:	09 d0                	or     %edx,%eax
  803a99:	89 e9                	mov    %ebp,%ecx
  803a9b:	d3 eb                	shr    %cl,%ebx
  803a9d:	89 da                	mov    %ebx,%edx
  803a9f:	83 c4 1c             	add    $0x1c,%esp
  803aa2:	5b                   	pop    %ebx
  803aa3:	5e                   	pop    %esi
  803aa4:	5f                   	pop    %edi
  803aa5:	5d                   	pop    %ebp
  803aa6:	c3                   	ret    
  803aa7:	90                   	nop
  803aa8:	89 fd                	mov    %edi,%ebp
  803aaa:	85 ff                	test   %edi,%edi
  803aac:	75 0b                	jne    803ab9 <__umoddi3+0xe9>
  803aae:	b8 01 00 00 00       	mov    $0x1,%eax
  803ab3:	31 d2                	xor    %edx,%edx
  803ab5:	f7 f7                	div    %edi
  803ab7:	89 c5                	mov    %eax,%ebp
  803ab9:	89 f0                	mov    %esi,%eax
  803abb:	31 d2                	xor    %edx,%edx
  803abd:	f7 f5                	div    %ebp
  803abf:	89 c8                	mov    %ecx,%eax
  803ac1:	f7 f5                	div    %ebp
  803ac3:	89 d0                	mov    %edx,%eax
  803ac5:	e9 44 ff ff ff       	jmp    803a0e <__umoddi3+0x3e>
  803aca:	66 90                	xchg   %ax,%ax
  803acc:	89 c8                	mov    %ecx,%eax
  803ace:	89 f2                	mov    %esi,%edx
  803ad0:	83 c4 1c             	add    $0x1c,%esp
  803ad3:	5b                   	pop    %ebx
  803ad4:	5e                   	pop    %esi
  803ad5:	5f                   	pop    %edi
  803ad6:	5d                   	pop    %ebp
  803ad7:	c3                   	ret    
  803ad8:	3b 04 24             	cmp    (%esp),%eax
  803adb:	72 06                	jb     803ae3 <__umoddi3+0x113>
  803add:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ae1:	77 0f                	ja     803af2 <__umoddi3+0x122>
  803ae3:	89 f2                	mov    %esi,%edx
  803ae5:	29 f9                	sub    %edi,%ecx
  803ae7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803aeb:	89 14 24             	mov    %edx,(%esp)
  803aee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803af2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803af6:	8b 14 24             	mov    (%esp),%edx
  803af9:	83 c4 1c             	add    $0x1c,%esp
  803afc:	5b                   	pop    %ebx
  803afd:	5e                   	pop    %esi
  803afe:	5f                   	pop    %edi
  803aff:	5d                   	pop    %ebp
  803b00:	c3                   	ret    
  803b01:	8d 76 00             	lea    0x0(%esi),%esi
  803b04:	2b 04 24             	sub    (%esp),%eax
  803b07:	19 fa                	sbb    %edi,%edx
  803b09:	89 d1                	mov    %edx,%ecx
  803b0b:	89 c6                	mov    %eax,%esi
  803b0d:	e9 71 ff ff ff       	jmp    803a83 <__umoddi3+0xb3>
  803b12:	66 90                	xchg   %ax,%ax
  803b14:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b18:	72 ea                	jb     803b04 <__umoddi3+0x134>
  803b1a:	89 d9                	mov    %ebx,%ecx
  803b1c:	e9 62 ff ff ff       	jmp    803a83 <__umoddi3+0xb3>
