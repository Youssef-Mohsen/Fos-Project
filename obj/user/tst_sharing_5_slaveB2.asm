
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
  80005b:	68 a0 3b 80 00       	push   $0x803ba0
  800060:	6a 0c                	push   $0xc
  800062:	68 bc 3b 80 00       	push   $0x803bbc
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
  800073:	e8 3b 1a 00 00       	call   801ab3 <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 d9 3b 80 00       	push   $0x803bd9
  800080:	50                   	push   %eax
  800081:	e8 15 16 00 00       	call   80169b <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 dc 3b 80 00       	push   $0x803bdc
  800094:	e8 a6 04 00 00       	call   80053f <cprintf>
  800099:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got z
	inctst();
  80009c:	e8 37 1b 00 00       	call   801bd8 <inctst>

	cprintf("Slave B2 please be patient ...\n");
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	68 04 3c 80 00       	push   $0x803c04
  8000a9:	e8 91 04 00 00       	call   80053f <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 28 23 00 00       	push   $0x2328
  8000b9:	e8 b5 37 00 00       	call   803873 <env_sleep>
  8000be:	83 c4 10             	add    $0x10,%esp
	//to ensure that the other environments completed successfully
	while (gettst()!=3) ;// panic("test failed");
  8000c1:	90                   	nop
  8000c2:	e8 2b 1b 00 00       	call   801bf2 <gettst>
  8000c7:	83 f8 03             	cmp    $0x3,%eax
  8000ca:	75 f6                	jne    8000c2 <_main+0x8a>

	freeFrames = sys_calculate_free_frames() ;
  8000cc:	e8 00 18 00 00       	call   8018d1 <sys_calculate_free_frames>
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	sfree(z);
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000da:	e8 41 16 00 00       	call   801720 <sfree>
  8000df:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 24 3c 80 00       	push   $0x803c24
  8000ea:	e8 50 04 00 00       	call   80053f <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
	expected = 1+1; /*1page+1table*/
  8000f2:	c7 45 e8 02 00 00 00 	movl   $0x2,-0x18(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  8000f9:	e8 d3 17 00 00       	call   8018d1 <sys_calculate_free_frames>
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800103:	29 c2                	sub    %eax,%edx
  800105:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800108:	39 c2                	cmp    %eax,%edx
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 3c 3c 80 00       	push   $0x803c3c
  800114:	6a 28                	push   $0x28
  800116:	68 bc 3b 80 00       	push   $0x803bbc
  80011b:	e8 62 01 00 00       	call   800282 <_panic>


	cprintf("Step B completed successfully!!\n\n\n");
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	68 dc 3c 80 00       	push   $0x803cdc
  800128:	e8 12 04 00 00       	call   80053f <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n%~Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 00 3d 80 00       	push   $0x803d00
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
  800149:	e8 4c 19 00 00       	call   801a9a <sys_getenvindex>
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
  8001b7:	e8 62 16 00 00       	call   80181e <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	68 68 3d 80 00       	push   $0x803d68
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
  8001e7:	68 90 3d 80 00       	push   $0x803d90
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
  800218:	68 b8 3d 80 00       	push   $0x803db8
  80021d:	e8 1d 03 00 00       	call   80053f <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800225:	a1 20 50 80 00       	mov    0x805020,%eax
  80022a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	50                   	push   %eax
  800234:	68 10 3e 80 00       	push   $0x803e10
  800239:	e8 01 03 00 00       	call   80053f <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	68 68 3d 80 00       	push   $0x803d68
  800249:	e8 f1 02 00 00       	call   80053f <cprintf>
  80024e:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800251:	e8 e2 15 00 00       	call   801838 <sys_unlock_cons>
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
  800269:	e8 f8 17 00 00       	call   801a66 <sys_destroy_env>
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
  80027a:	e8 4d 18 00 00       	call   801acc <sys_exit_env>
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
  8002a3:	68 24 3e 80 00       	push   $0x803e24
  8002a8:	e8 92 02 00 00       	call   80053f <cprintf>
  8002ad:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b0:	a1 00 50 80 00       	mov    0x805000,%eax
  8002b5:	ff 75 0c             	pushl  0xc(%ebp)
  8002b8:	ff 75 08             	pushl  0x8(%ebp)
  8002bb:	50                   	push   %eax
  8002bc:	68 29 3e 80 00       	push   $0x803e29
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
  8002e0:	68 45 3e 80 00       	push   $0x803e45
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
  80030f:	68 48 3e 80 00       	push   $0x803e48
  800314:	6a 26                	push   $0x26
  800316:	68 94 3e 80 00       	push   $0x803e94
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
  8003e4:	68 a0 3e 80 00       	push   $0x803ea0
  8003e9:	6a 3a                	push   $0x3a
  8003eb:	68 94 3e 80 00       	push   $0x803e94
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
  800457:	68 f4 3e 80 00       	push   $0x803ef4
  80045c:	6a 44                	push   $0x44
  80045e:	68 94 3e 80 00       	push   $0x803e94
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
  8004b1:	e8 26 13 00 00       	call   8017dc <sys_cputs>
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
  800528:	e8 af 12 00 00       	call   8017dc <sys_cputs>
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
  800572:	e8 a7 12 00 00       	call   80181e <sys_lock_cons>
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
  800592:	e8 a1 12 00 00       	call   801838 <sys_unlock_cons>
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
  8005dc:	e8 47 33 00 00       	call   803928 <__udivdi3>
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
  80062c:	e8 07 34 00 00       	call   803a38 <__umoddi3>
  800631:	83 c4 10             	add    $0x10,%esp
  800634:	05 54 41 80 00       	add    $0x804154,%eax
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
  800787:	8b 04 85 78 41 80 00 	mov    0x804178(,%eax,4),%eax
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
  800868:	8b 34 9d c0 3f 80 00 	mov    0x803fc0(,%ebx,4),%esi
  80086f:	85 f6                	test   %esi,%esi
  800871:	75 19                	jne    80088c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800873:	53                   	push   %ebx
  800874:	68 65 41 80 00       	push   $0x804165
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
  80088d:	68 6e 41 80 00       	push   $0x80416e
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
  8008ba:	be 71 41 80 00       	mov    $0x804171,%esi
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
  8012c5:	68 e8 42 80 00       	push   $0x8042e8
  8012ca:	68 3f 01 00 00       	push   $0x13f
  8012cf:	68 0a 43 80 00       	push   $0x80430a
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
  8012e5:	e8 9d 0a 00 00       	call   801d87 <sys_sbrk>
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
  801360:	e8 a6 08 00 00       	call   801c0b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801365:	85 c0                	test   %eax,%eax
  801367:	74 16                	je     80137f <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801369:	83 ec 0c             	sub    $0xc,%esp
  80136c:	ff 75 08             	pushl  0x8(%ebp)
  80136f:	e8 e6 0d 00 00       	call   80215a <alloc_block_FF>
  801374:	83 c4 10             	add    $0x10,%esp
  801377:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80137a:	e9 8a 01 00 00       	jmp    801509 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80137f:	e8 b8 08 00 00       	call   801c3c <sys_isUHeapPlacementStrategyBESTFIT>
  801384:	85 c0                	test   %eax,%eax
  801386:	0f 84 7d 01 00 00    	je     801509 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80138c:	83 ec 0c             	sub    $0xc,%esp
  80138f:	ff 75 08             	pushl  0x8(%ebp)
  801392:	e8 7f 12 00 00       	call   802616 <alloc_block_BF>
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
  8014f8:	e8 c1 08 00 00       	call   801dbe <sys_allocate_user_mem>
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
  801540:	e8 95 08 00 00       	call   801dda <get_block_size>
  801545:	83 c4 10             	add    $0x10,%esp
  801548:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80154b:	83 ec 0c             	sub    $0xc,%esp
  80154e:	ff 75 08             	pushl  0x8(%ebp)
  801551:	e8 c8 1a 00 00       	call   80301e <free_block>
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
  8015e8:	e8 b5 07 00 00       	call   801da2 <sys_free_user_mem>
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
  8015f6:	68 18 43 80 00       	push   $0x804318
  8015fb:	68 84 00 00 00       	push   $0x84
  801600:	68 42 43 80 00       	push   $0x804342
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
  801668:	e8 3c 03 00 00       	call   8019a9 <sys_createSharedObject>
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
  801689:	68 4e 43 80 00       	push   $0x80434e
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
  80169e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016a1:	83 ec 08             	sub    $0x8,%esp
  8016a4:	ff 75 0c             	pushl  0xc(%ebp)
  8016a7:	ff 75 08             	pushl  0x8(%ebp)
  8016aa:	e8 24 03 00 00       	call   8019d3 <sys_getSizeOfSharedObject>
  8016af:	83 c4 10             	add    $0x10,%esp
  8016b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8016b5:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016b9:	75 07                	jne    8016c2 <sget+0x27>
  8016bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c0:	eb 5c                	jmp    80171e <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8016c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016c8:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d5:	39 d0                	cmp    %edx,%eax
  8016d7:	7d 02                	jge    8016db <sget+0x40>
  8016d9:	89 d0                	mov    %edx,%eax
  8016db:	83 ec 0c             	sub    $0xc,%esp
  8016de:	50                   	push   %eax
  8016df:	e8 0b fc ff ff       	call   8012ef <malloc>
  8016e4:	83 c4 10             	add    $0x10,%esp
  8016e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8016ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016ee:	75 07                	jne    8016f7 <sget+0x5c>
  8016f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f5:	eb 27                	jmp    80171e <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8016f7:	83 ec 04             	sub    $0x4,%esp
  8016fa:	ff 75 e8             	pushl  -0x18(%ebp)
  8016fd:	ff 75 0c             	pushl  0xc(%ebp)
  801700:	ff 75 08             	pushl  0x8(%ebp)
  801703:	e8 e8 02 00 00       	call   8019f0 <sys_getSharedObject>
  801708:	83 c4 10             	add    $0x10,%esp
  80170b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80170e:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801712:	75 07                	jne    80171b <sget+0x80>
  801714:	b8 00 00 00 00       	mov    $0x0,%eax
  801719:	eb 03                	jmp    80171e <sget+0x83>
	return ptr;
  80171b:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801726:	83 ec 04             	sub    $0x4,%esp
  801729:	68 54 43 80 00       	push   $0x804354
  80172e:	68 c2 00 00 00       	push   $0xc2
  801733:	68 42 43 80 00       	push   $0x804342
  801738:	e8 45 eb ff ff       	call   800282 <_panic>

0080173d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
  801740:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801743:	83 ec 04             	sub    $0x4,%esp
  801746:	68 78 43 80 00       	push   $0x804378
  80174b:	68 d9 00 00 00       	push   $0xd9
  801750:	68 42 43 80 00       	push   $0x804342
  801755:	e8 28 eb ff ff       	call   800282 <_panic>

0080175a <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801760:	83 ec 04             	sub    $0x4,%esp
  801763:	68 9e 43 80 00       	push   $0x80439e
  801768:	68 e5 00 00 00       	push   $0xe5
  80176d:	68 42 43 80 00       	push   $0x804342
  801772:	e8 0b eb ff ff       	call   800282 <_panic>

00801777 <shrink>:

}
void shrink(uint32 newSize)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80177d:	83 ec 04             	sub    $0x4,%esp
  801780:	68 9e 43 80 00       	push   $0x80439e
  801785:	68 ea 00 00 00       	push   $0xea
  80178a:	68 42 43 80 00       	push   $0x804342
  80178f:	e8 ee ea ff ff       	call   800282 <_panic>

00801794 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80179a:	83 ec 04             	sub    $0x4,%esp
  80179d:	68 9e 43 80 00       	push   $0x80439e
  8017a2:	68 ef 00 00 00       	push   $0xef
  8017a7:	68 42 43 80 00       	push   $0x804342
  8017ac:	e8 d1 ea ff ff       	call   800282 <_panic>

008017b1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
  8017b4:	57                   	push   %edi
  8017b5:	56                   	push   %esi
  8017b6:	53                   	push   %ebx
  8017b7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017c3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017c6:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017c9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017cc:	cd 30                	int    $0x30
  8017ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017d4:	83 c4 10             	add    $0x10,%esp
  8017d7:	5b                   	pop    %ebx
  8017d8:	5e                   	pop    %esi
  8017d9:	5f                   	pop    %edi
  8017da:	5d                   	pop    %ebp
  8017db:	c3                   	ret    

008017dc <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	83 ec 04             	sub    $0x4,%esp
  8017e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017e8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	52                   	push   %edx
  8017f4:	ff 75 0c             	pushl  0xc(%ebp)
  8017f7:	50                   	push   %eax
  8017f8:	6a 00                	push   $0x0
  8017fa:	e8 b2 ff ff ff       	call   8017b1 <syscall>
  8017ff:	83 c4 18             	add    $0x18,%esp
}
  801802:	90                   	nop
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <sys_cgetc>:

int
sys_cgetc(void)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 02                	push   $0x2
  801814:	e8 98 ff ff ff       	call   8017b1 <syscall>
  801819:	83 c4 18             	add    $0x18,%esp
}
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <sys_lock_cons>:

void sys_lock_cons(void)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 03                	push   $0x3
  80182d:	e8 7f ff ff ff       	call   8017b1 <syscall>
  801832:	83 c4 18             	add    $0x18,%esp
}
  801835:	90                   	nop
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 04                	push   $0x4
  801847:	e8 65 ff ff ff       	call   8017b1 <syscall>
  80184c:	83 c4 18             	add    $0x18,%esp
}
  80184f:	90                   	nop
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801855:	8b 55 0c             	mov    0xc(%ebp),%edx
  801858:	8b 45 08             	mov    0x8(%ebp),%eax
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	52                   	push   %edx
  801862:	50                   	push   %eax
  801863:	6a 08                	push   $0x8
  801865:	e8 47 ff ff ff       	call   8017b1 <syscall>
  80186a:	83 c4 18             	add    $0x18,%esp
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	56                   	push   %esi
  801873:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801874:	8b 75 18             	mov    0x18(%ebp),%esi
  801877:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80187a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80187d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801880:	8b 45 08             	mov    0x8(%ebp),%eax
  801883:	56                   	push   %esi
  801884:	53                   	push   %ebx
  801885:	51                   	push   %ecx
  801886:	52                   	push   %edx
  801887:	50                   	push   %eax
  801888:	6a 09                	push   $0x9
  80188a:	e8 22 ff ff ff       	call   8017b1 <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
}
  801892:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801895:	5b                   	pop    %ebx
  801896:	5e                   	pop    %esi
  801897:	5d                   	pop    %ebp
  801898:	c3                   	ret    

00801899 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80189c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	52                   	push   %edx
  8018a9:	50                   	push   %eax
  8018aa:	6a 0a                	push   $0xa
  8018ac:	e8 00 ff ff ff       	call   8017b1 <syscall>
  8018b1:	83 c4 18             	add    $0x18,%esp
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	ff 75 0c             	pushl  0xc(%ebp)
  8018c2:	ff 75 08             	pushl  0x8(%ebp)
  8018c5:	6a 0b                	push   $0xb
  8018c7:	e8 e5 fe ff ff       	call   8017b1 <syscall>
  8018cc:	83 c4 18             	add    $0x18,%esp
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 0c                	push   $0xc
  8018e0:	e8 cc fe ff ff       	call   8017b1 <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 0d                	push   $0xd
  8018f9:	e8 b3 fe ff ff       	call   8017b1 <syscall>
  8018fe:	83 c4 18             	add    $0x18,%esp
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 0e                	push   $0xe
  801912:	e8 9a fe ff ff       	call   8017b1 <syscall>
  801917:	83 c4 18             	add    $0x18,%esp
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 0f                	push   $0xf
  80192b:	e8 81 fe ff ff       	call   8017b1 <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	ff 75 08             	pushl  0x8(%ebp)
  801943:	6a 10                	push   $0x10
  801945:	e8 67 fe ff ff       	call   8017b1 <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
}
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 11                	push   $0x11
  80195e:	e8 4e fe ff ff       	call   8017b1 <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
}
  801966:	90                   	nop
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <sys_cputc>:

void
sys_cputc(const char c)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	83 ec 04             	sub    $0x4,%esp
  80196f:	8b 45 08             	mov    0x8(%ebp),%eax
  801972:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801975:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	50                   	push   %eax
  801982:	6a 01                	push   $0x1
  801984:	e8 28 fe ff ff       	call   8017b1 <syscall>
  801989:	83 c4 18             	add    $0x18,%esp
}
  80198c:	90                   	nop
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 14                	push   $0x14
  80199e:	e8 0e fe ff ff       	call   8017b1 <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
}
  8019a6:	90                   	nop
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	83 ec 04             	sub    $0x4,%esp
  8019af:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019b5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019b8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bf:	6a 00                	push   $0x0
  8019c1:	51                   	push   %ecx
  8019c2:	52                   	push   %edx
  8019c3:	ff 75 0c             	pushl  0xc(%ebp)
  8019c6:	50                   	push   %eax
  8019c7:	6a 15                	push   $0x15
  8019c9:	e8 e3 fd ff ff       	call   8017b1 <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	52                   	push   %edx
  8019e3:	50                   	push   %eax
  8019e4:	6a 16                	push   $0x16
  8019e6:	e8 c6 fd ff ff       	call   8017b1 <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
}
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	51                   	push   %ecx
  801a01:	52                   	push   %edx
  801a02:	50                   	push   %eax
  801a03:	6a 17                	push   $0x17
  801a05:	e8 a7 fd ff ff       	call   8017b1 <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a15:	8b 45 08             	mov    0x8(%ebp),%eax
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	52                   	push   %edx
  801a1f:	50                   	push   %eax
  801a20:	6a 18                	push   $0x18
  801a22:	e8 8a fd ff ff       	call   8017b1 <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	6a 00                	push   $0x0
  801a34:	ff 75 14             	pushl  0x14(%ebp)
  801a37:	ff 75 10             	pushl  0x10(%ebp)
  801a3a:	ff 75 0c             	pushl  0xc(%ebp)
  801a3d:	50                   	push   %eax
  801a3e:	6a 19                	push   $0x19
  801a40:	e8 6c fd ff ff       	call   8017b1 <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
}
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	50                   	push   %eax
  801a59:	6a 1a                	push   $0x1a
  801a5b:	e8 51 fd ff ff       	call   8017b1 <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
}
  801a63:	90                   	nop
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	50                   	push   %eax
  801a75:	6a 1b                	push   $0x1b
  801a77:	e8 35 fd ff ff       	call   8017b1 <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 05                	push   $0x5
  801a90:	e8 1c fd ff ff       	call   8017b1 <syscall>
  801a95:	83 c4 18             	add    $0x18,%esp
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 06                	push   $0x6
  801aa9:	e8 03 fd ff ff       	call   8017b1 <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 07                	push   $0x7
  801ac2:	e8 ea fc ff ff       	call   8017b1 <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sys_exit_env>:


void sys_exit_env(void)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 1c                	push   $0x1c
  801adb:	e8 d1 fc ff ff       	call   8017b1 <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	90                   	nop
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
  801ae9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801aec:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aef:	8d 50 04             	lea    0x4(%eax),%edx
  801af2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	52                   	push   %edx
  801afc:	50                   	push   %eax
  801afd:	6a 1d                	push   $0x1d
  801aff:	e8 ad fc ff ff       	call   8017b1 <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
	return result;
  801b07:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b0d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b10:	89 01                	mov    %eax,(%ecx)
  801b12:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b15:	8b 45 08             	mov    0x8(%ebp),%eax
  801b18:	c9                   	leave  
  801b19:	c2 04 00             	ret    $0x4

00801b1c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	ff 75 10             	pushl  0x10(%ebp)
  801b26:	ff 75 0c             	pushl  0xc(%ebp)
  801b29:	ff 75 08             	pushl  0x8(%ebp)
  801b2c:	6a 13                	push   $0x13
  801b2e:	e8 7e fc ff ff       	call   8017b1 <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
	return ;
  801b36:	90                   	nop
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 1e                	push   $0x1e
  801b48:	e8 64 fc ff ff       	call   8017b1 <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	83 ec 04             	sub    $0x4,%esp
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b5e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	50                   	push   %eax
  801b6b:	6a 1f                	push   $0x1f
  801b6d:	e8 3f fc ff ff       	call   8017b1 <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
	return ;
  801b75:	90                   	nop
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <rsttst>:
void rsttst()
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 21                	push   $0x21
  801b87:	e8 25 fc ff ff       	call   8017b1 <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8f:	90                   	nop
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
  801b95:	83 ec 04             	sub    $0x4,%esp
  801b98:	8b 45 14             	mov    0x14(%ebp),%eax
  801b9b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b9e:	8b 55 18             	mov    0x18(%ebp),%edx
  801ba1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ba5:	52                   	push   %edx
  801ba6:	50                   	push   %eax
  801ba7:	ff 75 10             	pushl  0x10(%ebp)
  801baa:	ff 75 0c             	pushl  0xc(%ebp)
  801bad:	ff 75 08             	pushl  0x8(%ebp)
  801bb0:	6a 20                	push   $0x20
  801bb2:	e8 fa fb ff ff       	call   8017b1 <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bba:	90                   	nop
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <chktst>:
void chktst(uint32 n)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	ff 75 08             	pushl  0x8(%ebp)
  801bcb:	6a 22                	push   $0x22
  801bcd:	e8 df fb ff ff       	call   8017b1 <syscall>
  801bd2:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd5:	90                   	nop
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <inctst>:

void inctst()
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 23                	push   $0x23
  801be7:	e8 c5 fb ff ff       	call   8017b1 <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
	return ;
  801bef:	90                   	nop
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <gettst>:
uint32 gettst()
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 24                	push   $0x24
  801c01:	e8 ab fb ff ff       	call   8017b1 <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 25                	push   $0x25
  801c1d:	e8 8f fb ff ff       	call   8017b1 <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
  801c25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c28:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c2c:	75 07                	jne    801c35 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c33:	eb 05                	jmp    801c3a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 25                	push   $0x25
  801c4e:	e8 5e fb ff ff       	call   8017b1 <syscall>
  801c53:	83 c4 18             	add    $0x18,%esp
  801c56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c59:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c5d:	75 07                	jne    801c66 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c5f:	b8 01 00 00 00       	mov    $0x1,%eax
  801c64:	eb 05                	jmp    801c6b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    

00801c6d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
  801c70:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 25                	push   $0x25
  801c7f:	e8 2d fb ff ff       	call   8017b1 <syscall>
  801c84:	83 c4 18             	add    $0x18,%esp
  801c87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c8a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c8e:	75 07                	jne    801c97 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c90:	b8 01 00 00 00       	mov    $0x1,%eax
  801c95:	eb 05                	jmp    801c9c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 25                	push   $0x25
  801cb0:	e8 fc fa ff ff       	call   8017b1 <syscall>
  801cb5:	83 c4 18             	add    $0x18,%esp
  801cb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cbb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cbf:	75 07                	jne    801cc8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cc1:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc6:	eb 05                	jmp    801ccd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	ff 75 08             	pushl  0x8(%ebp)
  801cdd:	6a 26                	push   $0x26
  801cdf:	e8 cd fa ff ff       	call   8017b1 <syscall>
  801ce4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce7:	90                   	nop
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cee:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cf1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cf4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	6a 00                	push   $0x0
  801cfc:	53                   	push   %ebx
  801cfd:	51                   	push   %ecx
  801cfe:	52                   	push   %edx
  801cff:	50                   	push   %eax
  801d00:	6a 27                	push   $0x27
  801d02:	e8 aa fa ff ff       	call   8017b1 <syscall>
  801d07:	83 c4 18             	add    $0x18,%esp
}
  801d0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d15:	8b 45 08             	mov    0x8(%ebp),%eax
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	52                   	push   %edx
  801d1f:	50                   	push   %eax
  801d20:	6a 28                	push   $0x28
  801d22:	e8 8a fa ff ff       	call   8017b1 <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
}
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d2f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	6a 00                	push   $0x0
  801d3a:	51                   	push   %ecx
  801d3b:	ff 75 10             	pushl  0x10(%ebp)
  801d3e:	52                   	push   %edx
  801d3f:	50                   	push   %eax
  801d40:	6a 29                	push   $0x29
  801d42:	e8 6a fa ff ff       	call   8017b1 <syscall>
  801d47:	83 c4 18             	add    $0x18,%esp
}
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	ff 75 10             	pushl  0x10(%ebp)
  801d56:	ff 75 0c             	pushl  0xc(%ebp)
  801d59:	ff 75 08             	pushl  0x8(%ebp)
  801d5c:	6a 12                	push   $0x12
  801d5e:	e8 4e fa ff ff       	call   8017b1 <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
	return ;
  801d66:	90                   	nop
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	52                   	push   %edx
  801d79:	50                   	push   %eax
  801d7a:	6a 2a                	push   $0x2a
  801d7c:	e8 30 fa ff ff       	call   8017b1 <syscall>
  801d81:	83 c4 18             	add    $0x18,%esp
	return;
  801d84:	90                   	nop
}
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	50                   	push   %eax
  801d96:	6a 2b                	push   $0x2b
  801d98:	e8 14 fa ff ff       	call   8017b1 <syscall>
  801d9d:	83 c4 18             	add    $0x18,%esp
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	ff 75 0c             	pushl  0xc(%ebp)
  801dae:	ff 75 08             	pushl  0x8(%ebp)
  801db1:	6a 2c                	push   $0x2c
  801db3:	e8 f9 f9 ff ff       	call   8017b1 <syscall>
  801db8:	83 c4 18             	add    $0x18,%esp
	return;
  801dbb:	90                   	nop
}
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	ff 75 0c             	pushl  0xc(%ebp)
  801dca:	ff 75 08             	pushl  0x8(%ebp)
  801dcd:	6a 2d                	push   $0x2d
  801dcf:	e8 dd f9 ff ff       	call   8017b1 <syscall>
  801dd4:	83 c4 18             	add    $0x18,%esp
	return;
  801dd7:	90                   	nop
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
  801ddd:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801de0:	8b 45 08             	mov    0x8(%ebp),%eax
  801de3:	83 e8 04             	sub    $0x4,%eax
  801de6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801de9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dec:	8b 00                	mov    (%eax),%eax
  801dee:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801df9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfc:	83 e8 04             	sub    $0x4,%eax
  801dff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801e02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e05:	8b 00                	mov    (%eax),%eax
  801e07:	83 e0 01             	and    $0x1,%eax
  801e0a:	85 c0                	test   %eax,%eax
  801e0c:	0f 94 c0             	sete   %al
}
  801e0f:	c9                   	leave  
  801e10:	c3                   	ret    

00801e11 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
  801e14:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801e17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e21:	83 f8 02             	cmp    $0x2,%eax
  801e24:	74 2b                	je     801e51 <alloc_block+0x40>
  801e26:	83 f8 02             	cmp    $0x2,%eax
  801e29:	7f 07                	jg     801e32 <alloc_block+0x21>
  801e2b:	83 f8 01             	cmp    $0x1,%eax
  801e2e:	74 0e                	je     801e3e <alloc_block+0x2d>
  801e30:	eb 58                	jmp    801e8a <alloc_block+0x79>
  801e32:	83 f8 03             	cmp    $0x3,%eax
  801e35:	74 2d                	je     801e64 <alloc_block+0x53>
  801e37:	83 f8 04             	cmp    $0x4,%eax
  801e3a:	74 3b                	je     801e77 <alloc_block+0x66>
  801e3c:	eb 4c                	jmp    801e8a <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801e3e:	83 ec 0c             	sub    $0xc,%esp
  801e41:	ff 75 08             	pushl  0x8(%ebp)
  801e44:	e8 11 03 00 00       	call   80215a <alloc_block_FF>
  801e49:	83 c4 10             	add    $0x10,%esp
  801e4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e4f:	eb 4a                	jmp    801e9b <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801e51:	83 ec 0c             	sub    $0xc,%esp
  801e54:	ff 75 08             	pushl  0x8(%ebp)
  801e57:	e8 fa 19 00 00       	call   803856 <alloc_block_NF>
  801e5c:	83 c4 10             	add    $0x10,%esp
  801e5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e62:	eb 37                	jmp    801e9b <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801e64:	83 ec 0c             	sub    $0xc,%esp
  801e67:	ff 75 08             	pushl  0x8(%ebp)
  801e6a:	e8 a7 07 00 00       	call   802616 <alloc_block_BF>
  801e6f:	83 c4 10             	add    $0x10,%esp
  801e72:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e75:	eb 24                	jmp    801e9b <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801e77:	83 ec 0c             	sub    $0xc,%esp
  801e7a:	ff 75 08             	pushl  0x8(%ebp)
  801e7d:	e8 b7 19 00 00       	call   803839 <alloc_block_WF>
  801e82:	83 c4 10             	add    $0x10,%esp
  801e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e88:	eb 11                	jmp    801e9b <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801e8a:	83 ec 0c             	sub    $0xc,%esp
  801e8d:	68 b0 43 80 00       	push   $0x8043b0
  801e92:	e8 a8 e6 ff ff       	call   80053f <cprintf>
  801e97:	83 c4 10             	add    $0x10,%esp
		break;
  801e9a:	90                   	nop
	}
	return va;
  801e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	53                   	push   %ebx
  801ea4:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801ea7:	83 ec 0c             	sub    $0xc,%esp
  801eaa:	68 d0 43 80 00       	push   $0x8043d0
  801eaf:	e8 8b e6 ff ff       	call   80053f <cprintf>
  801eb4:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801eb7:	83 ec 0c             	sub    $0xc,%esp
  801eba:	68 fb 43 80 00       	push   $0x8043fb
  801ebf:	e8 7b e6 ff ff       	call   80053f <cprintf>
  801ec4:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ecd:	eb 37                	jmp    801f06 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801ecf:	83 ec 0c             	sub    $0xc,%esp
  801ed2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed5:	e8 19 ff ff ff       	call   801df3 <is_free_block>
  801eda:	83 c4 10             	add    $0x10,%esp
  801edd:	0f be d8             	movsbl %al,%ebx
  801ee0:	83 ec 0c             	sub    $0xc,%esp
  801ee3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee6:	e8 ef fe ff ff       	call   801dda <get_block_size>
  801eeb:	83 c4 10             	add    $0x10,%esp
  801eee:	83 ec 04             	sub    $0x4,%esp
  801ef1:	53                   	push   %ebx
  801ef2:	50                   	push   %eax
  801ef3:	68 13 44 80 00       	push   $0x804413
  801ef8:	e8 42 e6 ff ff       	call   80053f <cprintf>
  801efd:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801f00:	8b 45 10             	mov    0x10(%ebp),%eax
  801f03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f0a:	74 07                	je     801f13 <print_blocks_list+0x73>
  801f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0f:	8b 00                	mov    (%eax),%eax
  801f11:	eb 05                	jmp    801f18 <print_blocks_list+0x78>
  801f13:	b8 00 00 00 00       	mov    $0x0,%eax
  801f18:	89 45 10             	mov    %eax,0x10(%ebp)
  801f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1e:	85 c0                	test   %eax,%eax
  801f20:	75 ad                	jne    801ecf <print_blocks_list+0x2f>
  801f22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f26:	75 a7                	jne    801ecf <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801f28:	83 ec 0c             	sub    $0xc,%esp
  801f2b:	68 d0 43 80 00       	push   $0x8043d0
  801f30:	e8 0a e6 ff ff       	call   80053f <cprintf>
  801f35:	83 c4 10             	add    $0x10,%esp

}
  801f38:	90                   	nop
  801f39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801f44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f47:	83 e0 01             	and    $0x1,%eax
  801f4a:	85 c0                	test   %eax,%eax
  801f4c:	74 03                	je     801f51 <initialize_dynamic_allocator+0x13>
  801f4e:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801f51:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f55:	0f 84 c7 01 00 00    	je     802122 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801f5b:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801f62:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801f65:	8b 55 08             	mov    0x8(%ebp),%edx
  801f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f6b:	01 d0                	add    %edx,%eax
  801f6d:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801f72:	0f 87 ad 01 00 00    	ja     802125 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7b:	85 c0                	test   %eax,%eax
  801f7d:	0f 89 a5 01 00 00    	jns    802128 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801f83:	8b 55 08             	mov    0x8(%ebp),%edx
  801f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f89:	01 d0                	add    %edx,%eax
  801f8b:	83 e8 04             	sub    $0x4,%eax
  801f8e:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801f93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801f9a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801f9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa2:	e9 87 00 00 00       	jmp    80202e <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801fa7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fab:	75 14                	jne    801fc1 <initialize_dynamic_allocator+0x83>
  801fad:	83 ec 04             	sub    $0x4,%esp
  801fb0:	68 2b 44 80 00       	push   $0x80442b
  801fb5:	6a 79                	push   $0x79
  801fb7:	68 49 44 80 00       	push   $0x804449
  801fbc:	e8 c1 e2 ff ff       	call   800282 <_panic>
  801fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc4:	8b 00                	mov    (%eax),%eax
  801fc6:	85 c0                	test   %eax,%eax
  801fc8:	74 10                	je     801fda <initialize_dynamic_allocator+0x9c>
  801fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcd:	8b 00                	mov    (%eax),%eax
  801fcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd2:	8b 52 04             	mov    0x4(%edx),%edx
  801fd5:	89 50 04             	mov    %edx,0x4(%eax)
  801fd8:	eb 0b                	jmp    801fe5 <initialize_dynamic_allocator+0xa7>
  801fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdd:	8b 40 04             	mov    0x4(%eax),%eax
  801fe0:	a3 30 50 80 00       	mov    %eax,0x805030
  801fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe8:	8b 40 04             	mov    0x4(%eax),%eax
  801feb:	85 c0                	test   %eax,%eax
  801fed:	74 0f                	je     801ffe <initialize_dynamic_allocator+0xc0>
  801fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff2:	8b 40 04             	mov    0x4(%eax),%eax
  801ff5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff8:	8b 12                	mov    (%edx),%edx
  801ffa:	89 10                	mov    %edx,(%eax)
  801ffc:	eb 0a                	jmp    802008 <initialize_dynamic_allocator+0xca>
  801ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802001:	8b 00                	mov    (%eax),%eax
  802003:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802014:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80201b:	a1 38 50 80 00       	mov    0x805038,%eax
  802020:	48                   	dec    %eax
  802021:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802026:	a1 34 50 80 00       	mov    0x805034,%eax
  80202b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80202e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802032:	74 07                	je     80203b <initialize_dynamic_allocator+0xfd>
  802034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802037:	8b 00                	mov    (%eax),%eax
  802039:	eb 05                	jmp    802040 <initialize_dynamic_allocator+0x102>
  80203b:	b8 00 00 00 00       	mov    $0x0,%eax
  802040:	a3 34 50 80 00       	mov    %eax,0x805034
  802045:	a1 34 50 80 00       	mov    0x805034,%eax
  80204a:	85 c0                	test   %eax,%eax
  80204c:	0f 85 55 ff ff ff    	jne    801fa7 <initialize_dynamic_allocator+0x69>
  802052:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802056:	0f 85 4b ff ff ff    	jne    801fa7 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80205c:	8b 45 08             	mov    0x8(%ebp),%eax
  80205f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802062:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802065:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80206b:	a1 44 50 80 00       	mov    0x805044,%eax
  802070:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802075:	a1 40 50 80 00       	mov    0x805040,%eax
  80207a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802080:	8b 45 08             	mov    0x8(%ebp),%eax
  802083:	83 c0 08             	add    $0x8,%eax
  802086:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802089:	8b 45 08             	mov    0x8(%ebp),%eax
  80208c:	83 c0 04             	add    $0x4,%eax
  80208f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802092:	83 ea 08             	sub    $0x8,%edx
  802095:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802097:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	01 d0                	add    %edx,%eax
  80209f:	83 e8 08             	sub    $0x8,%eax
  8020a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a5:	83 ea 08             	sub    $0x8,%edx
  8020a8:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8020aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8020b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8020bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020c1:	75 17                	jne    8020da <initialize_dynamic_allocator+0x19c>
  8020c3:	83 ec 04             	sub    $0x4,%esp
  8020c6:	68 64 44 80 00       	push   $0x804464
  8020cb:	68 90 00 00 00       	push   $0x90
  8020d0:	68 49 44 80 00       	push   $0x804449
  8020d5:	e8 a8 e1 ff ff       	call   800282 <_panic>
  8020da:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8020e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e3:	89 10                	mov    %edx,(%eax)
  8020e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e8:	8b 00                	mov    (%eax),%eax
  8020ea:	85 c0                	test   %eax,%eax
  8020ec:	74 0d                	je     8020fb <initialize_dynamic_allocator+0x1bd>
  8020ee:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020f6:	89 50 04             	mov    %edx,0x4(%eax)
  8020f9:	eb 08                	jmp    802103 <initialize_dynamic_allocator+0x1c5>
  8020fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020fe:	a3 30 50 80 00       	mov    %eax,0x805030
  802103:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802106:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80210b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80210e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802115:	a1 38 50 80 00       	mov    0x805038,%eax
  80211a:	40                   	inc    %eax
  80211b:	a3 38 50 80 00       	mov    %eax,0x805038
  802120:	eb 07                	jmp    802129 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802122:	90                   	nop
  802123:	eb 04                	jmp    802129 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802125:	90                   	nop
  802126:	eb 01                	jmp    802129 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802128:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802129:	c9                   	leave  
  80212a:	c3                   	ret    

0080212b <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80212e:	8b 45 10             	mov    0x10(%ebp),%eax
  802131:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	8d 50 fc             	lea    -0x4(%eax),%edx
  80213a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213d:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80213f:	8b 45 08             	mov    0x8(%ebp),%eax
  802142:	83 e8 04             	sub    $0x4,%eax
  802145:	8b 00                	mov    (%eax),%eax
  802147:	83 e0 fe             	and    $0xfffffffe,%eax
  80214a:	8d 50 f8             	lea    -0x8(%eax),%edx
  80214d:	8b 45 08             	mov    0x8(%ebp),%eax
  802150:	01 c2                	add    %eax,%edx
  802152:	8b 45 0c             	mov    0xc(%ebp),%eax
  802155:	89 02                	mov    %eax,(%edx)
}
  802157:	90                   	nop
  802158:	5d                   	pop    %ebp
  802159:	c3                   	ret    

0080215a <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
  80215d:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	83 e0 01             	and    $0x1,%eax
  802166:	85 c0                	test   %eax,%eax
  802168:	74 03                	je     80216d <alloc_block_FF+0x13>
  80216a:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80216d:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802171:	77 07                	ja     80217a <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802173:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80217a:	a1 24 50 80 00       	mov    0x805024,%eax
  80217f:	85 c0                	test   %eax,%eax
  802181:	75 73                	jne    8021f6 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	83 c0 10             	add    $0x10,%eax
  802189:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80218c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802193:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802196:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802199:	01 d0                	add    %edx,%eax
  80219b:	48                   	dec    %eax
  80219c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80219f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8021a7:	f7 75 ec             	divl   -0x14(%ebp)
  8021aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021ad:	29 d0                	sub    %edx,%eax
  8021af:	c1 e8 0c             	shr    $0xc,%eax
  8021b2:	83 ec 0c             	sub    $0xc,%esp
  8021b5:	50                   	push   %eax
  8021b6:	e8 1e f1 ff ff       	call   8012d9 <sbrk>
  8021bb:	83 c4 10             	add    $0x10,%esp
  8021be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8021c1:	83 ec 0c             	sub    $0xc,%esp
  8021c4:	6a 00                	push   $0x0
  8021c6:	e8 0e f1 ff ff       	call   8012d9 <sbrk>
  8021cb:	83 c4 10             	add    $0x10,%esp
  8021ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8021d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021d4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8021d7:	83 ec 08             	sub    $0x8,%esp
  8021da:	50                   	push   %eax
  8021db:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021de:	e8 5b fd ff ff       	call   801f3e <initialize_dynamic_allocator>
  8021e3:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8021e6:	83 ec 0c             	sub    $0xc,%esp
  8021e9:	68 87 44 80 00       	push   $0x804487
  8021ee:	e8 4c e3 ff ff       	call   80053f <cprintf>
  8021f3:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8021f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021fa:	75 0a                	jne    802206 <alloc_block_FF+0xac>
	        return NULL;
  8021fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802201:	e9 0e 04 00 00       	jmp    802614 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802206:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80220d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802212:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802215:	e9 f3 02 00 00       	jmp    80250d <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80221a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221d:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802220:	83 ec 0c             	sub    $0xc,%esp
  802223:	ff 75 bc             	pushl  -0x44(%ebp)
  802226:	e8 af fb ff ff       	call   801dda <get_block_size>
  80222b:	83 c4 10             	add    $0x10,%esp
  80222e:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802231:	8b 45 08             	mov    0x8(%ebp),%eax
  802234:	83 c0 08             	add    $0x8,%eax
  802237:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80223a:	0f 87 c5 02 00 00    	ja     802505 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	83 c0 18             	add    $0x18,%eax
  802246:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802249:	0f 87 19 02 00 00    	ja     802468 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80224f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802252:	2b 45 08             	sub    0x8(%ebp),%eax
  802255:	83 e8 08             	sub    $0x8,%eax
  802258:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	8d 50 08             	lea    0x8(%eax),%edx
  802261:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802264:	01 d0                	add    %edx,%eax
  802266:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	83 c0 08             	add    $0x8,%eax
  80226f:	83 ec 04             	sub    $0x4,%esp
  802272:	6a 01                	push   $0x1
  802274:	50                   	push   %eax
  802275:	ff 75 bc             	pushl  -0x44(%ebp)
  802278:	e8 ae fe ff ff       	call   80212b <set_block_data>
  80227d:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802283:	8b 40 04             	mov    0x4(%eax),%eax
  802286:	85 c0                	test   %eax,%eax
  802288:	75 68                	jne    8022f2 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80228a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80228e:	75 17                	jne    8022a7 <alloc_block_FF+0x14d>
  802290:	83 ec 04             	sub    $0x4,%esp
  802293:	68 64 44 80 00       	push   $0x804464
  802298:	68 d7 00 00 00       	push   $0xd7
  80229d:	68 49 44 80 00       	push   $0x804449
  8022a2:	e8 db df ff ff       	call   800282 <_panic>
  8022a7:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8022ad:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022b0:	89 10                	mov    %edx,(%eax)
  8022b2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022b5:	8b 00                	mov    (%eax),%eax
  8022b7:	85 c0                	test   %eax,%eax
  8022b9:	74 0d                	je     8022c8 <alloc_block_FF+0x16e>
  8022bb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022c0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022c3:	89 50 04             	mov    %edx,0x4(%eax)
  8022c6:	eb 08                	jmp    8022d0 <alloc_block_FF+0x176>
  8022c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022cb:	a3 30 50 80 00       	mov    %eax,0x805030
  8022d0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022d3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022d8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022e2:	a1 38 50 80 00       	mov    0x805038,%eax
  8022e7:	40                   	inc    %eax
  8022e8:	a3 38 50 80 00       	mov    %eax,0x805038
  8022ed:	e9 dc 00 00 00       	jmp    8023ce <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8022f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f5:	8b 00                	mov    (%eax),%eax
  8022f7:	85 c0                	test   %eax,%eax
  8022f9:	75 65                	jne    802360 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8022fb:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022ff:	75 17                	jne    802318 <alloc_block_FF+0x1be>
  802301:	83 ec 04             	sub    $0x4,%esp
  802304:	68 98 44 80 00       	push   $0x804498
  802309:	68 db 00 00 00       	push   $0xdb
  80230e:	68 49 44 80 00       	push   $0x804449
  802313:	e8 6a df ff ff       	call   800282 <_panic>
  802318:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80231e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802321:	89 50 04             	mov    %edx,0x4(%eax)
  802324:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802327:	8b 40 04             	mov    0x4(%eax),%eax
  80232a:	85 c0                	test   %eax,%eax
  80232c:	74 0c                	je     80233a <alloc_block_FF+0x1e0>
  80232e:	a1 30 50 80 00       	mov    0x805030,%eax
  802333:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802336:	89 10                	mov    %edx,(%eax)
  802338:	eb 08                	jmp    802342 <alloc_block_FF+0x1e8>
  80233a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80233d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802342:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802345:	a3 30 50 80 00       	mov    %eax,0x805030
  80234a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80234d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802353:	a1 38 50 80 00       	mov    0x805038,%eax
  802358:	40                   	inc    %eax
  802359:	a3 38 50 80 00       	mov    %eax,0x805038
  80235e:	eb 6e                	jmp    8023ce <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802360:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802364:	74 06                	je     80236c <alloc_block_FF+0x212>
  802366:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80236a:	75 17                	jne    802383 <alloc_block_FF+0x229>
  80236c:	83 ec 04             	sub    $0x4,%esp
  80236f:	68 bc 44 80 00       	push   $0x8044bc
  802374:	68 df 00 00 00       	push   $0xdf
  802379:	68 49 44 80 00       	push   $0x804449
  80237e:	e8 ff de ff ff       	call   800282 <_panic>
  802383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802386:	8b 10                	mov    (%eax),%edx
  802388:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80238b:	89 10                	mov    %edx,(%eax)
  80238d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802390:	8b 00                	mov    (%eax),%eax
  802392:	85 c0                	test   %eax,%eax
  802394:	74 0b                	je     8023a1 <alloc_block_FF+0x247>
  802396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802399:	8b 00                	mov    (%eax),%eax
  80239b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80239e:	89 50 04             	mov    %edx,0x4(%eax)
  8023a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023a7:	89 10                	mov    %edx,(%eax)
  8023a9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023af:	89 50 04             	mov    %edx,0x4(%eax)
  8023b2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023b5:	8b 00                	mov    (%eax),%eax
  8023b7:	85 c0                	test   %eax,%eax
  8023b9:	75 08                	jne    8023c3 <alloc_block_FF+0x269>
  8023bb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023be:	a3 30 50 80 00       	mov    %eax,0x805030
  8023c3:	a1 38 50 80 00       	mov    0x805038,%eax
  8023c8:	40                   	inc    %eax
  8023c9:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8023ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d2:	75 17                	jne    8023eb <alloc_block_FF+0x291>
  8023d4:	83 ec 04             	sub    $0x4,%esp
  8023d7:	68 2b 44 80 00       	push   $0x80442b
  8023dc:	68 e1 00 00 00       	push   $0xe1
  8023e1:	68 49 44 80 00       	push   $0x804449
  8023e6:	e8 97 de ff ff       	call   800282 <_panic>
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 00                	mov    (%eax),%eax
  8023f0:	85 c0                	test   %eax,%eax
  8023f2:	74 10                	je     802404 <alloc_block_FF+0x2aa>
  8023f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f7:	8b 00                	mov    (%eax),%eax
  8023f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023fc:	8b 52 04             	mov    0x4(%edx),%edx
  8023ff:	89 50 04             	mov    %edx,0x4(%eax)
  802402:	eb 0b                	jmp    80240f <alloc_block_FF+0x2b5>
  802404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802407:	8b 40 04             	mov    0x4(%eax),%eax
  80240a:	a3 30 50 80 00       	mov    %eax,0x805030
  80240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802412:	8b 40 04             	mov    0x4(%eax),%eax
  802415:	85 c0                	test   %eax,%eax
  802417:	74 0f                	je     802428 <alloc_block_FF+0x2ce>
  802419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241c:	8b 40 04             	mov    0x4(%eax),%eax
  80241f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802422:	8b 12                	mov    (%edx),%edx
  802424:	89 10                	mov    %edx,(%eax)
  802426:	eb 0a                	jmp    802432 <alloc_block_FF+0x2d8>
  802428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242b:	8b 00                	mov    (%eax),%eax
  80242d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802435:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802445:	a1 38 50 80 00       	mov    0x805038,%eax
  80244a:	48                   	dec    %eax
  80244b:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802450:	83 ec 04             	sub    $0x4,%esp
  802453:	6a 00                	push   $0x0
  802455:	ff 75 b4             	pushl  -0x4c(%ebp)
  802458:	ff 75 b0             	pushl  -0x50(%ebp)
  80245b:	e8 cb fc ff ff       	call   80212b <set_block_data>
  802460:	83 c4 10             	add    $0x10,%esp
  802463:	e9 95 00 00 00       	jmp    8024fd <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802468:	83 ec 04             	sub    $0x4,%esp
  80246b:	6a 01                	push   $0x1
  80246d:	ff 75 b8             	pushl  -0x48(%ebp)
  802470:	ff 75 bc             	pushl  -0x44(%ebp)
  802473:	e8 b3 fc ff ff       	call   80212b <set_block_data>
  802478:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80247b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80247f:	75 17                	jne    802498 <alloc_block_FF+0x33e>
  802481:	83 ec 04             	sub    $0x4,%esp
  802484:	68 2b 44 80 00       	push   $0x80442b
  802489:	68 e8 00 00 00       	push   $0xe8
  80248e:	68 49 44 80 00       	push   $0x804449
  802493:	e8 ea dd ff ff       	call   800282 <_panic>
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	8b 00                	mov    (%eax),%eax
  80249d:	85 c0                	test   %eax,%eax
  80249f:	74 10                	je     8024b1 <alloc_block_FF+0x357>
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	8b 00                	mov    (%eax),%eax
  8024a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a9:	8b 52 04             	mov    0x4(%edx),%edx
  8024ac:	89 50 04             	mov    %edx,0x4(%eax)
  8024af:	eb 0b                	jmp    8024bc <alloc_block_FF+0x362>
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	8b 40 04             	mov    0x4(%eax),%eax
  8024b7:	a3 30 50 80 00       	mov    %eax,0x805030
  8024bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bf:	8b 40 04             	mov    0x4(%eax),%eax
  8024c2:	85 c0                	test   %eax,%eax
  8024c4:	74 0f                	je     8024d5 <alloc_block_FF+0x37b>
  8024c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c9:	8b 40 04             	mov    0x4(%eax),%eax
  8024cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024cf:	8b 12                	mov    (%edx),%edx
  8024d1:	89 10                	mov    %edx,(%eax)
  8024d3:	eb 0a                	jmp    8024df <alloc_block_FF+0x385>
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	8b 00                	mov    (%eax),%eax
  8024da:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f2:	a1 38 50 80 00       	mov    0x805038,%eax
  8024f7:	48                   	dec    %eax
  8024f8:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8024fd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802500:	e9 0f 01 00 00       	jmp    802614 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802505:	a1 34 50 80 00       	mov    0x805034,%eax
  80250a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80250d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802511:	74 07                	je     80251a <alloc_block_FF+0x3c0>
  802513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802516:	8b 00                	mov    (%eax),%eax
  802518:	eb 05                	jmp    80251f <alloc_block_FF+0x3c5>
  80251a:	b8 00 00 00 00       	mov    $0x0,%eax
  80251f:	a3 34 50 80 00       	mov    %eax,0x805034
  802524:	a1 34 50 80 00       	mov    0x805034,%eax
  802529:	85 c0                	test   %eax,%eax
  80252b:	0f 85 e9 fc ff ff    	jne    80221a <alloc_block_FF+0xc0>
  802531:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802535:	0f 85 df fc ff ff    	jne    80221a <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80253b:	8b 45 08             	mov    0x8(%ebp),%eax
  80253e:	83 c0 08             	add    $0x8,%eax
  802541:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802544:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80254b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80254e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802551:	01 d0                	add    %edx,%eax
  802553:	48                   	dec    %eax
  802554:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802557:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80255a:	ba 00 00 00 00       	mov    $0x0,%edx
  80255f:	f7 75 d8             	divl   -0x28(%ebp)
  802562:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802565:	29 d0                	sub    %edx,%eax
  802567:	c1 e8 0c             	shr    $0xc,%eax
  80256a:	83 ec 0c             	sub    $0xc,%esp
  80256d:	50                   	push   %eax
  80256e:	e8 66 ed ff ff       	call   8012d9 <sbrk>
  802573:	83 c4 10             	add    $0x10,%esp
  802576:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802579:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80257d:	75 0a                	jne    802589 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80257f:	b8 00 00 00 00       	mov    $0x0,%eax
  802584:	e9 8b 00 00 00       	jmp    802614 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802589:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802590:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802593:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802596:	01 d0                	add    %edx,%eax
  802598:	48                   	dec    %eax
  802599:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80259c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80259f:	ba 00 00 00 00       	mov    $0x0,%edx
  8025a4:	f7 75 cc             	divl   -0x34(%ebp)
  8025a7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025aa:	29 d0                	sub    %edx,%eax
  8025ac:	8d 50 fc             	lea    -0x4(%eax),%edx
  8025af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025b2:	01 d0                	add    %edx,%eax
  8025b4:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8025b9:	a1 40 50 80 00       	mov    0x805040,%eax
  8025be:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8025c4:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8025cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025ce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8025d1:	01 d0                	add    %edx,%eax
  8025d3:	48                   	dec    %eax
  8025d4:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8025d7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8025da:	ba 00 00 00 00       	mov    $0x0,%edx
  8025df:	f7 75 c4             	divl   -0x3c(%ebp)
  8025e2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8025e5:	29 d0                	sub    %edx,%eax
  8025e7:	83 ec 04             	sub    $0x4,%esp
  8025ea:	6a 01                	push   $0x1
  8025ec:	50                   	push   %eax
  8025ed:	ff 75 d0             	pushl  -0x30(%ebp)
  8025f0:	e8 36 fb ff ff       	call   80212b <set_block_data>
  8025f5:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8025f8:	83 ec 0c             	sub    $0xc,%esp
  8025fb:	ff 75 d0             	pushl  -0x30(%ebp)
  8025fe:	e8 1b 0a 00 00       	call   80301e <free_block>
  802603:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802606:	83 ec 0c             	sub    $0xc,%esp
  802609:	ff 75 08             	pushl  0x8(%ebp)
  80260c:	e8 49 fb ff ff       	call   80215a <alloc_block_FF>
  802611:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802614:	c9                   	leave  
  802615:	c3                   	ret    

00802616 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
  802619:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80261c:	8b 45 08             	mov    0x8(%ebp),%eax
  80261f:	83 e0 01             	and    $0x1,%eax
  802622:	85 c0                	test   %eax,%eax
  802624:	74 03                	je     802629 <alloc_block_BF+0x13>
  802626:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802629:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80262d:	77 07                	ja     802636 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80262f:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802636:	a1 24 50 80 00       	mov    0x805024,%eax
  80263b:	85 c0                	test   %eax,%eax
  80263d:	75 73                	jne    8026b2 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80263f:	8b 45 08             	mov    0x8(%ebp),%eax
  802642:	83 c0 10             	add    $0x10,%eax
  802645:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802648:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80264f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802652:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802655:	01 d0                	add    %edx,%eax
  802657:	48                   	dec    %eax
  802658:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80265b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80265e:	ba 00 00 00 00       	mov    $0x0,%edx
  802663:	f7 75 e0             	divl   -0x20(%ebp)
  802666:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802669:	29 d0                	sub    %edx,%eax
  80266b:	c1 e8 0c             	shr    $0xc,%eax
  80266e:	83 ec 0c             	sub    $0xc,%esp
  802671:	50                   	push   %eax
  802672:	e8 62 ec ff ff       	call   8012d9 <sbrk>
  802677:	83 c4 10             	add    $0x10,%esp
  80267a:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80267d:	83 ec 0c             	sub    $0xc,%esp
  802680:	6a 00                	push   $0x0
  802682:	e8 52 ec ff ff       	call   8012d9 <sbrk>
  802687:	83 c4 10             	add    $0x10,%esp
  80268a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80268d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802690:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802693:	83 ec 08             	sub    $0x8,%esp
  802696:	50                   	push   %eax
  802697:	ff 75 d8             	pushl  -0x28(%ebp)
  80269a:	e8 9f f8 ff ff       	call   801f3e <initialize_dynamic_allocator>
  80269f:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8026a2:	83 ec 0c             	sub    $0xc,%esp
  8026a5:	68 87 44 80 00       	push   $0x804487
  8026aa:	e8 90 de ff ff       	call   80053f <cprintf>
  8026af:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8026b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8026b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8026c0:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8026c7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8026ce:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8026d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d6:	e9 1d 01 00 00       	jmp    8027f8 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8026db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026de:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8026e1:	83 ec 0c             	sub    $0xc,%esp
  8026e4:	ff 75 a8             	pushl  -0x58(%ebp)
  8026e7:	e8 ee f6 ff ff       	call   801dda <get_block_size>
  8026ec:	83 c4 10             	add    $0x10,%esp
  8026ef:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8026f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f5:	83 c0 08             	add    $0x8,%eax
  8026f8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026fb:	0f 87 ef 00 00 00    	ja     8027f0 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802701:	8b 45 08             	mov    0x8(%ebp),%eax
  802704:	83 c0 18             	add    $0x18,%eax
  802707:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80270a:	77 1d                	ja     802729 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80270c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802712:	0f 86 d8 00 00 00    	jbe    8027f0 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802718:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80271b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80271e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802721:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802724:	e9 c7 00 00 00       	jmp    8027f0 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802729:	8b 45 08             	mov    0x8(%ebp),%eax
  80272c:	83 c0 08             	add    $0x8,%eax
  80272f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802732:	0f 85 9d 00 00 00    	jne    8027d5 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802738:	83 ec 04             	sub    $0x4,%esp
  80273b:	6a 01                	push   $0x1
  80273d:	ff 75 a4             	pushl  -0x5c(%ebp)
  802740:	ff 75 a8             	pushl  -0x58(%ebp)
  802743:	e8 e3 f9 ff ff       	call   80212b <set_block_data>
  802748:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80274b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274f:	75 17                	jne    802768 <alloc_block_BF+0x152>
  802751:	83 ec 04             	sub    $0x4,%esp
  802754:	68 2b 44 80 00       	push   $0x80442b
  802759:	68 2c 01 00 00       	push   $0x12c
  80275e:	68 49 44 80 00       	push   $0x804449
  802763:	e8 1a db ff ff       	call   800282 <_panic>
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 00                	mov    (%eax),%eax
  80276d:	85 c0                	test   %eax,%eax
  80276f:	74 10                	je     802781 <alloc_block_BF+0x16b>
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	8b 00                	mov    (%eax),%eax
  802776:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802779:	8b 52 04             	mov    0x4(%edx),%edx
  80277c:	89 50 04             	mov    %edx,0x4(%eax)
  80277f:	eb 0b                	jmp    80278c <alloc_block_BF+0x176>
  802781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802784:	8b 40 04             	mov    0x4(%eax),%eax
  802787:	a3 30 50 80 00       	mov    %eax,0x805030
  80278c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278f:	8b 40 04             	mov    0x4(%eax),%eax
  802792:	85 c0                	test   %eax,%eax
  802794:	74 0f                	je     8027a5 <alloc_block_BF+0x18f>
  802796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802799:	8b 40 04             	mov    0x4(%eax),%eax
  80279c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80279f:	8b 12                	mov    (%edx),%edx
  8027a1:	89 10                	mov    %edx,(%eax)
  8027a3:	eb 0a                	jmp    8027af <alloc_block_BF+0x199>
  8027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a8:	8b 00                	mov    (%eax),%eax
  8027aa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c2:	a1 38 50 80 00       	mov    0x805038,%eax
  8027c7:	48                   	dec    %eax
  8027c8:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8027cd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027d0:	e9 24 04 00 00       	jmp    802bf9 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8027d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027db:	76 13                	jbe    8027f0 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8027dd:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8027e4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8027ea:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8027ed:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8027f0:	a1 34 50 80 00       	mov    0x805034,%eax
  8027f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fc:	74 07                	je     802805 <alloc_block_BF+0x1ef>
  8027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802801:	8b 00                	mov    (%eax),%eax
  802803:	eb 05                	jmp    80280a <alloc_block_BF+0x1f4>
  802805:	b8 00 00 00 00       	mov    $0x0,%eax
  80280a:	a3 34 50 80 00       	mov    %eax,0x805034
  80280f:	a1 34 50 80 00       	mov    0x805034,%eax
  802814:	85 c0                	test   %eax,%eax
  802816:	0f 85 bf fe ff ff    	jne    8026db <alloc_block_BF+0xc5>
  80281c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802820:	0f 85 b5 fe ff ff    	jne    8026db <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802826:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80282a:	0f 84 26 02 00 00    	je     802a56 <alloc_block_BF+0x440>
  802830:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802834:	0f 85 1c 02 00 00    	jne    802a56 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80283a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283d:	2b 45 08             	sub    0x8(%ebp),%eax
  802840:	83 e8 08             	sub    $0x8,%eax
  802843:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802846:	8b 45 08             	mov    0x8(%ebp),%eax
  802849:	8d 50 08             	lea    0x8(%eax),%edx
  80284c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284f:	01 d0                	add    %edx,%eax
  802851:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802854:	8b 45 08             	mov    0x8(%ebp),%eax
  802857:	83 c0 08             	add    $0x8,%eax
  80285a:	83 ec 04             	sub    $0x4,%esp
  80285d:	6a 01                	push   $0x1
  80285f:	50                   	push   %eax
  802860:	ff 75 f0             	pushl  -0x10(%ebp)
  802863:	e8 c3 f8 ff ff       	call   80212b <set_block_data>
  802868:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80286b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286e:	8b 40 04             	mov    0x4(%eax),%eax
  802871:	85 c0                	test   %eax,%eax
  802873:	75 68                	jne    8028dd <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802875:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802879:	75 17                	jne    802892 <alloc_block_BF+0x27c>
  80287b:	83 ec 04             	sub    $0x4,%esp
  80287e:	68 64 44 80 00       	push   $0x804464
  802883:	68 45 01 00 00       	push   $0x145
  802888:	68 49 44 80 00       	push   $0x804449
  80288d:	e8 f0 d9 ff ff       	call   800282 <_panic>
  802892:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802898:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80289b:	89 10                	mov    %edx,(%eax)
  80289d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028a0:	8b 00                	mov    (%eax),%eax
  8028a2:	85 c0                	test   %eax,%eax
  8028a4:	74 0d                	je     8028b3 <alloc_block_BF+0x29d>
  8028a6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8028ab:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028ae:	89 50 04             	mov    %edx,0x4(%eax)
  8028b1:	eb 08                	jmp    8028bb <alloc_block_BF+0x2a5>
  8028b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028b6:	a3 30 50 80 00       	mov    %eax,0x805030
  8028bb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028be:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028cd:	a1 38 50 80 00       	mov    0x805038,%eax
  8028d2:	40                   	inc    %eax
  8028d3:	a3 38 50 80 00       	mov    %eax,0x805038
  8028d8:	e9 dc 00 00 00       	jmp    8029b9 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8028dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e0:	8b 00                	mov    (%eax),%eax
  8028e2:	85 c0                	test   %eax,%eax
  8028e4:	75 65                	jne    80294b <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028e6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028ea:	75 17                	jne    802903 <alloc_block_BF+0x2ed>
  8028ec:	83 ec 04             	sub    $0x4,%esp
  8028ef:	68 98 44 80 00       	push   $0x804498
  8028f4:	68 4a 01 00 00       	push   $0x14a
  8028f9:	68 49 44 80 00       	push   $0x804449
  8028fe:	e8 7f d9 ff ff       	call   800282 <_panic>
  802903:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802909:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80290c:	89 50 04             	mov    %edx,0x4(%eax)
  80290f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802912:	8b 40 04             	mov    0x4(%eax),%eax
  802915:	85 c0                	test   %eax,%eax
  802917:	74 0c                	je     802925 <alloc_block_BF+0x30f>
  802919:	a1 30 50 80 00       	mov    0x805030,%eax
  80291e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802921:	89 10                	mov    %edx,(%eax)
  802923:	eb 08                	jmp    80292d <alloc_block_BF+0x317>
  802925:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802928:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80292d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802930:	a3 30 50 80 00       	mov    %eax,0x805030
  802935:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802938:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80293e:	a1 38 50 80 00       	mov    0x805038,%eax
  802943:	40                   	inc    %eax
  802944:	a3 38 50 80 00       	mov    %eax,0x805038
  802949:	eb 6e                	jmp    8029b9 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80294b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80294f:	74 06                	je     802957 <alloc_block_BF+0x341>
  802951:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802955:	75 17                	jne    80296e <alloc_block_BF+0x358>
  802957:	83 ec 04             	sub    $0x4,%esp
  80295a:	68 bc 44 80 00       	push   $0x8044bc
  80295f:	68 4f 01 00 00       	push   $0x14f
  802964:	68 49 44 80 00       	push   $0x804449
  802969:	e8 14 d9 ff ff       	call   800282 <_panic>
  80296e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802971:	8b 10                	mov    (%eax),%edx
  802973:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802976:	89 10                	mov    %edx,(%eax)
  802978:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80297b:	8b 00                	mov    (%eax),%eax
  80297d:	85 c0                	test   %eax,%eax
  80297f:	74 0b                	je     80298c <alloc_block_BF+0x376>
  802981:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802984:	8b 00                	mov    (%eax),%eax
  802986:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802989:	89 50 04             	mov    %edx,0x4(%eax)
  80298c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802992:	89 10                	mov    %edx,(%eax)
  802994:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802997:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80299a:	89 50 04             	mov    %edx,0x4(%eax)
  80299d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a0:	8b 00                	mov    (%eax),%eax
  8029a2:	85 c0                	test   %eax,%eax
  8029a4:	75 08                	jne    8029ae <alloc_block_BF+0x398>
  8029a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a9:	a3 30 50 80 00       	mov    %eax,0x805030
  8029ae:	a1 38 50 80 00       	mov    0x805038,%eax
  8029b3:	40                   	inc    %eax
  8029b4:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8029b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029bd:	75 17                	jne    8029d6 <alloc_block_BF+0x3c0>
  8029bf:	83 ec 04             	sub    $0x4,%esp
  8029c2:	68 2b 44 80 00       	push   $0x80442b
  8029c7:	68 51 01 00 00       	push   $0x151
  8029cc:	68 49 44 80 00       	push   $0x804449
  8029d1:	e8 ac d8 ff ff       	call   800282 <_panic>
  8029d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d9:	8b 00                	mov    (%eax),%eax
  8029db:	85 c0                	test   %eax,%eax
  8029dd:	74 10                	je     8029ef <alloc_block_BF+0x3d9>
  8029df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e2:	8b 00                	mov    (%eax),%eax
  8029e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029e7:	8b 52 04             	mov    0x4(%edx),%edx
  8029ea:	89 50 04             	mov    %edx,0x4(%eax)
  8029ed:	eb 0b                	jmp    8029fa <alloc_block_BF+0x3e4>
  8029ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f2:	8b 40 04             	mov    0x4(%eax),%eax
  8029f5:	a3 30 50 80 00       	mov    %eax,0x805030
  8029fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fd:	8b 40 04             	mov    0x4(%eax),%eax
  802a00:	85 c0                	test   %eax,%eax
  802a02:	74 0f                	je     802a13 <alloc_block_BF+0x3fd>
  802a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a07:	8b 40 04             	mov    0x4(%eax),%eax
  802a0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a0d:	8b 12                	mov    (%edx),%edx
  802a0f:	89 10                	mov    %edx,(%eax)
  802a11:	eb 0a                	jmp    802a1d <alloc_block_BF+0x407>
  802a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a16:	8b 00                	mov    (%eax),%eax
  802a18:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a30:	a1 38 50 80 00       	mov    0x805038,%eax
  802a35:	48                   	dec    %eax
  802a36:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802a3b:	83 ec 04             	sub    $0x4,%esp
  802a3e:	6a 00                	push   $0x0
  802a40:	ff 75 d0             	pushl  -0x30(%ebp)
  802a43:	ff 75 cc             	pushl  -0x34(%ebp)
  802a46:	e8 e0 f6 ff ff       	call   80212b <set_block_data>
  802a4b:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a51:	e9 a3 01 00 00       	jmp    802bf9 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802a56:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802a5a:	0f 85 9d 00 00 00    	jne    802afd <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802a60:	83 ec 04             	sub    $0x4,%esp
  802a63:	6a 01                	push   $0x1
  802a65:	ff 75 ec             	pushl  -0x14(%ebp)
  802a68:	ff 75 f0             	pushl  -0x10(%ebp)
  802a6b:	e8 bb f6 ff ff       	call   80212b <set_block_data>
  802a70:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802a73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a77:	75 17                	jne    802a90 <alloc_block_BF+0x47a>
  802a79:	83 ec 04             	sub    $0x4,%esp
  802a7c:	68 2b 44 80 00       	push   $0x80442b
  802a81:	68 58 01 00 00       	push   $0x158
  802a86:	68 49 44 80 00       	push   $0x804449
  802a8b:	e8 f2 d7 ff ff       	call   800282 <_panic>
  802a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a93:	8b 00                	mov    (%eax),%eax
  802a95:	85 c0                	test   %eax,%eax
  802a97:	74 10                	je     802aa9 <alloc_block_BF+0x493>
  802a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9c:	8b 00                	mov    (%eax),%eax
  802a9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aa1:	8b 52 04             	mov    0x4(%edx),%edx
  802aa4:	89 50 04             	mov    %edx,0x4(%eax)
  802aa7:	eb 0b                	jmp    802ab4 <alloc_block_BF+0x49e>
  802aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aac:	8b 40 04             	mov    0x4(%eax),%eax
  802aaf:	a3 30 50 80 00       	mov    %eax,0x805030
  802ab4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab7:	8b 40 04             	mov    0x4(%eax),%eax
  802aba:	85 c0                	test   %eax,%eax
  802abc:	74 0f                	je     802acd <alloc_block_BF+0x4b7>
  802abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac1:	8b 40 04             	mov    0x4(%eax),%eax
  802ac4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ac7:	8b 12                	mov    (%edx),%edx
  802ac9:	89 10                	mov    %edx,(%eax)
  802acb:	eb 0a                	jmp    802ad7 <alloc_block_BF+0x4c1>
  802acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad0:	8b 00                	mov    (%eax),%eax
  802ad2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ada:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aea:	a1 38 50 80 00       	mov    0x805038,%eax
  802aef:	48                   	dec    %eax
  802af0:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af8:	e9 fc 00 00 00       	jmp    802bf9 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802afd:	8b 45 08             	mov    0x8(%ebp),%eax
  802b00:	83 c0 08             	add    $0x8,%eax
  802b03:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b06:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b0d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b10:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b13:	01 d0                	add    %edx,%eax
  802b15:	48                   	dec    %eax
  802b16:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b19:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b1c:	ba 00 00 00 00       	mov    $0x0,%edx
  802b21:	f7 75 c4             	divl   -0x3c(%ebp)
  802b24:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b27:	29 d0                	sub    %edx,%eax
  802b29:	c1 e8 0c             	shr    $0xc,%eax
  802b2c:	83 ec 0c             	sub    $0xc,%esp
  802b2f:	50                   	push   %eax
  802b30:	e8 a4 e7 ff ff       	call   8012d9 <sbrk>
  802b35:	83 c4 10             	add    $0x10,%esp
  802b38:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802b3b:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802b3f:	75 0a                	jne    802b4b <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802b41:	b8 00 00 00 00       	mov    $0x0,%eax
  802b46:	e9 ae 00 00 00       	jmp    802bf9 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b4b:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802b52:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b55:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b58:	01 d0                	add    %edx,%eax
  802b5a:	48                   	dec    %eax
  802b5b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802b5e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b61:	ba 00 00 00 00       	mov    $0x0,%edx
  802b66:	f7 75 b8             	divl   -0x48(%ebp)
  802b69:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b6c:	29 d0                	sub    %edx,%eax
  802b6e:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b71:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b74:	01 d0                	add    %edx,%eax
  802b76:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802b7b:	a1 40 50 80 00       	mov    0x805040,%eax
  802b80:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802b86:	83 ec 0c             	sub    $0xc,%esp
  802b89:	68 f0 44 80 00       	push   $0x8044f0
  802b8e:	e8 ac d9 ff ff       	call   80053f <cprintf>
  802b93:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802b96:	83 ec 08             	sub    $0x8,%esp
  802b99:	ff 75 bc             	pushl  -0x44(%ebp)
  802b9c:	68 f5 44 80 00       	push   $0x8044f5
  802ba1:	e8 99 d9 ff ff       	call   80053f <cprintf>
  802ba6:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802ba9:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802bb0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bb3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bb6:	01 d0                	add    %edx,%eax
  802bb8:	48                   	dec    %eax
  802bb9:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802bbc:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802bbf:	ba 00 00 00 00       	mov    $0x0,%edx
  802bc4:	f7 75 b0             	divl   -0x50(%ebp)
  802bc7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802bca:	29 d0                	sub    %edx,%eax
  802bcc:	83 ec 04             	sub    $0x4,%esp
  802bcf:	6a 01                	push   $0x1
  802bd1:	50                   	push   %eax
  802bd2:	ff 75 bc             	pushl  -0x44(%ebp)
  802bd5:	e8 51 f5 ff ff       	call   80212b <set_block_data>
  802bda:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802bdd:	83 ec 0c             	sub    $0xc,%esp
  802be0:	ff 75 bc             	pushl  -0x44(%ebp)
  802be3:	e8 36 04 00 00       	call   80301e <free_block>
  802be8:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802beb:	83 ec 0c             	sub    $0xc,%esp
  802bee:	ff 75 08             	pushl  0x8(%ebp)
  802bf1:	e8 20 fa ff ff       	call   802616 <alloc_block_BF>
  802bf6:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802bf9:	c9                   	leave  
  802bfa:	c3                   	ret    

00802bfb <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802bfb:	55                   	push   %ebp
  802bfc:	89 e5                	mov    %esp,%ebp
  802bfe:	53                   	push   %ebx
  802bff:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802c02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c09:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802c10:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c14:	74 1e                	je     802c34 <merging+0x39>
  802c16:	ff 75 08             	pushl  0x8(%ebp)
  802c19:	e8 bc f1 ff ff       	call   801dda <get_block_size>
  802c1e:	83 c4 04             	add    $0x4,%esp
  802c21:	89 c2                	mov    %eax,%edx
  802c23:	8b 45 08             	mov    0x8(%ebp),%eax
  802c26:	01 d0                	add    %edx,%eax
  802c28:	3b 45 10             	cmp    0x10(%ebp),%eax
  802c2b:	75 07                	jne    802c34 <merging+0x39>
		prev_is_free = 1;
  802c2d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802c34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c38:	74 1e                	je     802c58 <merging+0x5d>
  802c3a:	ff 75 10             	pushl  0x10(%ebp)
  802c3d:	e8 98 f1 ff ff       	call   801dda <get_block_size>
  802c42:	83 c4 04             	add    $0x4,%esp
  802c45:	89 c2                	mov    %eax,%edx
  802c47:	8b 45 10             	mov    0x10(%ebp),%eax
  802c4a:	01 d0                	add    %edx,%eax
  802c4c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c4f:	75 07                	jne    802c58 <merging+0x5d>
		next_is_free = 1;
  802c51:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802c58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c5c:	0f 84 cc 00 00 00    	je     802d2e <merging+0x133>
  802c62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c66:	0f 84 c2 00 00 00    	je     802d2e <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802c6c:	ff 75 08             	pushl  0x8(%ebp)
  802c6f:	e8 66 f1 ff ff       	call   801dda <get_block_size>
  802c74:	83 c4 04             	add    $0x4,%esp
  802c77:	89 c3                	mov    %eax,%ebx
  802c79:	ff 75 10             	pushl  0x10(%ebp)
  802c7c:	e8 59 f1 ff ff       	call   801dda <get_block_size>
  802c81:	83 c4 04             	add    $0x4,%esp
  802c84:	01 c3                	add    %eax,%ebx
  802c86:	ff 75 0c             	pushl  0xc(%ebp)
  802c89:	e8 4c f1 ff ff       	call   801dda <get_block_size>
  802c8e:	83 c4 04             	add    $0x4,%esp
  802c91:	01 d8                	add    %ebx,%eax
  802c93:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802c96:	6a 00                	push   $0x0
  802c98:	ff 75 ec             	pushl  -0x14(%ebp)
  802c9b:	ff 75 08             	pushl  0x8(%ebp)
  802c9e:	e8 88 f4 ff ff       	call   80212b <set_block_data>
  802ca3:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802ca6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802caa:	75 17                	jne    802cc3 <merging+0xc8>
  802cac:	83 ec 04             	sub    $0x4,%esp
  802caf:	68 2b 44 80 00       	push   $0x80442b
  802cb4:	68 7d 01 00 00       	push   $0x17d
  802cb9:	68 49 44 80 00       	push   $0x804449
  802cbe:	e8 bf d5 ff ff       	call   800282 <_panic>
  802cc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cc6:	8b 00                	mov    (%eax),%eax
  802cc8:	85 c0                	test   %eax,%eax
  802cca:	74 10                	je     802cdc <merging+0xe1>
  802ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ccf:	8b 00                	mov    (%eax),%eax
  802cd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cd4:	8b 52 04             	mov    0x4(%edx),%edx
  802cd7:	89 50 04             	mov    %edx,0x4(%eax)
  802cda:	eb 0b                	jmp    802ce7 <merging+0xec>
  802cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cdf:	8b 40 04             	mov    0x4(%eax),%eax
  802ce2:	a3 30 50 80 00       	mov    %eax,0x805030
  802ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cea:	8b 40 04             	mov    0x4(%eax),%eax
  802ced:	85 c0                	test   %eax,%eax
  802cef:	74 0f                	je     802d00 <merging+0x105>
  802cf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cf4:	8b 40 04             	mov    0x4(%eax),%eax
  802cf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cfa:	8b 12                	mov    (%edx),%edx
  802cfc:	89 10                	mov    %edx,(%eax)
  802cfe:	eb 0a                	jmp    802d0a <merging+0x10f>
  802d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d03:	8b 00                	mov    (%eax),%eax
  802d05:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d1d:	a1 38 50 80 00       	mov    0x805038,%eax
  802d22:	48                   	dec    %eax
  802d23:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802d28:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d29:	e9 ea 02 00 00       	jmp    803018 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802d2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d32:	74 3b                	je     802d6f <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802d34:	83 ec 0c             	sub    $0xc,%esp
  802d37:	ff 75 08             	pushl  0x8(%ebp)
  802d3a:	e8 9b f0 ff ff       	call   801dda <get_block_size>
  802d3f:	83 c4 10             	add    $0x10,%esp
  802d42:	89 c3                	mov    %eax,%ebx
  802d44:	83 ec 0c             	sub    $0xc,%esp
  802d47:	ff 75 10             	pushl  0x10(%ebp)
  802d4a:	e8 8b f0 ff ff       	call   801dda <get_block_size>
  802d4f:	83 c4 10             	add    $0x10,%esp
  802d52:	01 d8                	add    %ebx,%eax
  802d54:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d57:	83 ec 04             	sub    $0x4,%esp
  802d5a:	6a 00                	push   $0x0
  802d5c:	ff 75 e8             	pushl  -0x18(%ebp)
  802d5f:	ff 75 08             	pushl  0x8(%ebp)
  802d62:	e8 c4 f3 ff ff       	call   80212b <set_block_data>
  802d67:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d6a:	e9 a9 02 00 00       	jmp    803018 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802d6f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d73:	0f 84 2d 01 00 00    	je     802ea6 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802d79:	83 ec 0c             	sub    $0xc,%esp
  802d7c:	ff 75 10             	pushl  0x10(%ebp)
  802d7f:	e8 56 f0 ff ff       	call   801dda <get_block_size>
  802d84:	83 c4 10             	add    $0x10,%esp
  802d87:	89 c3                	mov    %eax,%ebx
  802d89:	83 ec 0c             	sub    $0xc,%esp
  802d8c:	ff 75 0c             	pushl  0xc(%ebp)
  802d8f:	e8 46 f0 ff ff       	call   801dda <get_block_size>
  802d94:	83 c4 10             	add    $0x10,%esp
  802d97:	01 d8                	add    %ebx,%eax
  802d99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802d9c:	83 ec 04             	sub    $0x4,%esp
  802d9f:	6a 00                	push   $0x0
  802da1:	ff 75 e4             	pushl  -0x1c(%ebp)
  802da4:	ff 75 10             	pushl  0x10(%ebp)
  802da7:	e8 7f f3 ff ff       	call   80212b <set_block_data>
  802dac:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802daf:	8b 45 10             	mov    0x10(%ebp),%eax
  802db2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802db5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802db9:	74 06                	je     802dc1 <merging+0x1c6>
  802dbb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802dbf:	75 17                	jne    802dd8 <merging+0x1dd>
  802dc1:	83 ec 04             	sub    $0x4,%esp
  802dc4:	68 04 45 80 00       	push   $0x804504
  802dc9:	68 8d 01 00 00       	push   $0x18d
  802dce:	68 49 44 80 00       	push   $0x804449
  802dd3:	e8 aa d4 ff ff       	call   800282 <_panic>
  802dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ddb:	8b 50 04             	mov    0x4(%eax),%edx
  802dde:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802de1:	89 50 04             	mov    %edx,0x4(%eax)
  802de4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802de7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dea:	89 10                	mov    %edx,(%eax)
  802dec:	8b 45 0c             	mov    0xc(%ebp),%eax
  802def:	8b 40 04             	mov    0x4(%eax),%eax
  802df2:	85 c0                	test   %eax,%eax
  802df4:	74 0d                	je     802e03 <merging+0x208>
  802df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df9:	8b 40 04             	mov    0x4(%eax),%eax
  802dfc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dff:	89 10                	mov    %edx,(%eax)
  802e01:	eb 08                	jmp    802e0b <merging+0x210>
  802e03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e06:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e0e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e11:	89 50 04             	mov    %edx,0x4(%eax)
  802e14:	a1 38 50 80 00       	mov    0x805038,%eax
  802e19:	40                   	inc    %eax
  802e1a:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802e1f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e23:	75 17                	jne    802e3c <merging+0x241>
  802e25:	83 ec 04             	sub    $0x4,%esp
  802e28:	68 2b 44 80 00       	push   $0x80442b
  802e2d:	68 8e 01 00 00       	push   $0x18e
  802e32:	68 49 44 80 00       	push   $0x804449
  802e37:	e8 46 d4 ff ff       	call   800282 <_panic>
  802e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e3f:	8b 00                	mov    (%eax),%eax
  802e41:	85 c0                	test   %eax,%eax
  802e43:	74 10                	je     802e55 <merging+0x25a>
  802e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e48:	8b 00                	mov    (%eax),%eax
  802e4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e4d:	8b 52 04             	mov    0x4(%edx),%edx
  802e50:	89 50 04             	mov    %edx,0x4(%eax)
  802e53:	eb 0b                	jmp    802e60 <merging+0x265>
  802e55:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e58:	8b 40 04             	mov    0x4(%eax),%eax
  802e5b:	a3 30 50 80 00       	mov    %eax,0x805030
  802e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e63:	8b 40 04             	mov    0x4(%eax),%eax
  802e66:	85 c0                	test   %eax,%eax
  802e68:	74 0f                	je     802e79 <merging+0x27e>
  802e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e6d:	8b 40 04             	mov    0x4(%eax),%eax
  802e70:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e73:	8b 12                	mov    (%edx),%edx
  802e75:	89 10                	mov    %edx,(%eax)
  802e77:	eb 0a                	jmp    802e83 <merging+0x288>
  802e79:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7c:	8b 00                	mov    (%eax),%eax
  802e7e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e83:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e96:	a1 38 50 80 00       	mov    0x805038,%eax
  802e9b:	48                   	dec    %eax
  802e9c:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ea1:	e9 72 01 00 00       	jmp    803018 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802ea6:	8b 45 10             	mov    0x10(%ebp),%eax
  802ea9:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802eac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eb0:	74 79                	je     802f2b <merging+0x330>
  802eb2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802eb6:	74 73                	je     802f2b <merging+0x330>
  802eb8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ebc:	74 06                	je     802ec4 <merging+0x2c9>
  802ebe:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ec2:	75 17                	jne    802edb <merging+0x2e0>
  802ec4:	83 ec 04             	sub    $0x4,%esp
  802ec7:	68 bc 44 80 00       	push   $0x8044bc
  802ecc:	68 94 01 00 00       	push   $0x194
  802ed1:	68 49 44 80 00       	push   $0x804449
  802ed6:	e8 a7 d3 ff ff       	call   800282 <_panic>
  802edb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ede:	8b 10                	mov    (%eax),%edx
  802ee0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ee3:	89 10                	mov    %edx,(%eax)
  802ee5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ee8:	8b 00                	mov    (%eax),%eax
  802eea:	85 c0                	test   %eax,%eax
  802eec:	74 0b                	je     802ef9 <merging+0x2fe>
  802eee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef1:	8b 00                	mov    (%eax),%eax
  802ef3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ef6:	89 50 04             	mov    %edx,0x4(%eax)
  802ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  802efc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802eff:	89 10                	mov    %edx,(%eax)
  802f01:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f04:	8b 55 08             	mov    0x8(%ebp),%edx
  802f07:	89 50 04             	mov    %edx,0x4(%eax)
  802f0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f0d:	8b 00                	mov    (%eax),%eax
  802f0f:	85 c0                	test   %eax,%eax
  802f11:	75 08                	jne    802f1b <merging+0x320>
  802f13:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f16:	a3 30 50 80 00       	mov    %eax,0x805030
  802f1b:	a1 38 50 80 00       	mov    0x805038,%eax
  802f20:	40                   	inc    %eax
  802f21:	a3 38 50 80 00       	mov    %eax,0x805038
  802f26:	e9 ce 00 00 00       	jmp    802ff9 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802f2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f2f:	74 65                	je     802f96 <merging+0x39b>
  802f31:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f35:	75 17                	jne    802f4e <merging+0x353>
  802f37:	83 ec 04             	sub    $0x4,%esp
  802f3a:	68 98 44 80 00       	push   $0x804498
  802f3f:	68 95 01 00 00       	push   $0x195
  802f44:	68 49 44 80 00       	push   $0x804449
  802f49:	e8 34 d3 ff ff       	call   800282 <_panic>
  802f4e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f54:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f57:	89 50 04             	mov    %edx,0x4(%eax)
  802f5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f5d:	8b 40 04             	mov    0x4(%eax),%eax
  802f60:	85 c0                	test   %eax,%eax
  802f62:	74 0c                	je     802f70 <merging+0x375>
  802f64:	a1 30 50 80 00       	mov    0x805030,%eax
  802f69:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f6c:	89 10                	mov    %edx,(%eax)
  802f6e:	eb 08                	jmp    802f78 <merging+0x37d>
  802f70:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f73:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f78:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f7b:	a3 30 50 80 00       	mov    %eax,0x805030
  802f80:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f89:	a1 38 50 80 00       	mov    0x805038,%eax
  802f8e:	40                   	inc    %eax
  802f8f:	a3 38 50 80 00       	mov    %eax,0x805038
  802f94:	eb 63                	jmp    802ff9 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802f96:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f9a:	75 17                	jne    802fb3 <merging+0x3b8>
  802f9c:	83 ec 04             	sub    $0x4,%esp
  802f9f:	68 64 44 80 00       	push   $0x804464
  802fa4:	68 98 01 00 00       	push   $0x198
  802fa9:	68 49 44 80 00       	push   $0x804449
  802fae:	e8 cf d2 ff ff       	call   800282 <_panic>
  802fb3:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802fb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fbc:	89 10                	mov    %edx,(%eax)
  802fbe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fc1:	8b 00                	mov    (%eax),%eax
  802fc3:	85 c0                	test   %eax,%eax
  802fc5:	74 0d                	je     802fd4 <merging+0x3d9>
  802fc7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fcc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fcf:	89 50 04             	mov    %edx,0x4(%eax)
  802fd2:	eb 08                	jmp    802fdc <merging+0x3e1>
  802fd4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fd7:	a3 30 50 80 00       	mov    %eax,0x805030
  802fdc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fdf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fe4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fee:	a1 38 50 80 00       	mov    0x805038,%eax
  802ff3:	40                   	inc    %eax
  802ff4:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802ff9:	83 ec 0c             	sub    $0xc,%esp
  802ffc:	ff 75 10             	pushl  0x10(%ebp)
  802fff:	e8 d6 ed ff ff       	call   801dda <get_block_size>
  803004:	83 c4 10             	add    $0x10,%esp
  803007:	83 ec 04             	sub    $0x4,%esp
  80300a:	6a 00                	push   $0x0
  80300c:	50                   	push   %eax
  80300d:	ff 75 10             	pushl  0x10(%ebp)
  803010:	e8 16 f1 ff ff       	call   80212b <set_block_data>
  803015:	83 c4 10             	add    $0x10,%esp
	}
}
  803018:	90                   	nop
  803019:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80301c:	c9                   	leave  
  80301d:	c3                   	ret    

0080301e <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80301e:	55                   	push   %ebp
  80301f:	89 e5                	mov    %esp,%ebp
  803021:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803024:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803029:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80302c:	a1 30 50 80 00       	mov    0x805030,%eax
  803031:	3b 45 08             	cmp    0x8(%ebp),%eax
  803034:	73 1b                	jae    803051 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803036:	a1 30 50 80 00       	mov    0x805030,%eax
  80303b:	83 ec 04             	sub    $0x4,%esp
  80303e:	ff 75 08             	pushl  0x8(%ebp)
  803041:	6a 00                	push   $0x0
  803043:	50                   	push   %eax
  803044:	e8 b2 fb ff ff       	call   802bfb <merging>
  803049:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80304c:	e9 8b 00 00 00       	jmp    8030dc <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803051:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803056:	3b 45 08             	cmp    0x8(%ebp),%eax
  803059:	76 18                	jbe    803073 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80305b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803060:	83 ec 04             	sub    $0x4,%esp
  803063:	ff 75 08             	pushl  0x8(%ebp)
  803066:	50                   	push   %eax
  803067:	6a 00                	push   $0x0
  803069:	e8 8d fb ff ff       	call   802bfb <merging>
  80306e:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803071:	eb 69                	jmp    8030dc <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803073:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803078:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80307b:	eb 39                	jmp    8030b6 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80307d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803080:	3b 45 08             	cmp    0x8(%ebp),%eax
  803083:	73 29                	jae    8030ae <free_block+0x90>
  803085:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803088:	8b 00                	mov    (%eax),%eax
  80308a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80308d:	76 1f                	jbe    8030ae <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803092:	8b 00                	mov    (%eax),%eax
  803094:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803097:	83 ec 04             	sub    $0x4,%esp
  80309a:	ff 75 08             	pushl  0x8(%ebp)
  80309d:	ff 75 f0             	pushl  -0x10(%ebp)
  8030a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8030a3:	e8 53 fb ff ff       	call   802bfb <merging>
  8030a8:	83 c4 10             	add    $0x10,%esp
			break;
  8030ab:	90                   	nop
		}
	}
}
  8030ac:	eb 2e                	jmp    8030dc <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030ae:	a1 34 50 80 00       	mov    0x805034,%eax
  8030b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ba:	74 07                	je     8030c3 <free_block+0xa5>
  8030bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bf:	8b 00                	mov    (%eax),%eax
  8030c1:	eb 05                	jmp    8030c8 <free_block+0xaa>
  8030c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c8:	a3 34 50 80 00       	mov    %eax,0x805034
  8030cd:	a1 34 50 80 00       	mov    0x805034,%eax
  8030d2:	85 c0                	test   %eax,%eax
  8030d4:	75 a7                	jne    80307d <free_block+0x5f>
  8030d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030da:	75 a1                	jne    80307d <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030dc:	90                   	nop
  8030dd:	c9                   	leave  
  8030de:	c3                   	ret    

008030df <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8030df:	55                   	push   %ebp
  8030e0:	89 e5                	mov    %esp,%ebp
  8030e2:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8030e5:	ff 75 08             	pushl  0x8(%ebp)
  8030e8:	e8 ed ec ff ff       	call   801dda <get_block_size>
  8030ed:	83 c4 04             	add    $0x4,%esp
  8030f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8030f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8030fa:	eb 17                	jmp    803113 <copy_data+0x34>
  8030fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8030ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803102:	01 c2                	add    %eax,%edx
  803104:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803107:	8b 45 08             	mov    0x8(%ebp),%eax
  80310a:	01 c8                	add    %ecx,%eax
  80310c:	8a 00                	mov    (%eax),%al
  80310e:	88 02                	mov    %al,(%edx)
  803110:	ff 45 fc             	incl   -0x4(%ebp)
  803113:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803116:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803119:	72 e1                	jb     8030fc <copy_data+0x1d>
}
  80311b:	90                   	nop
  80311c:	c9                   	leave  
  80311d:	c3                   	ret    

0080311e <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80311e:	55                   	push   %ebp
  80311f:	89 e5                	mov    %esp,%ebp
  803121:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803124:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803128:	75 23                	jne    80314d <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80312a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80312e:	74 13                	je     803143 <realloc_block_FF+0x25>
  803130:	83 ec 0c             	sub    $0xc,%esp
  803133:	ff 75 0c             	pushl  0xc(%ebp)
  803136:	e8 1f f0 ff ff       	call   80215a <alloc_block_FF>
  80313b:	83 c4 10             	add    $0x10,%esp
  80313e:	e9 f4 06 00 00       	jmp    803837 <realloc_block_FF+0x719>
		return NULL;
  803143:	b8 00 00 00 00       	mov    $0x0,%eax
  803148:	e9 ea 06 00 00       	jmp    803837 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80314d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803151:	75 18                	jne    80316b <realloc_block_FF+0x4d>
	{
		free_block(va);
  803153:	83 ec 0c             	sub    $0xc,%esp
  803156:	ff 75 08             	pushl  0x8(%ebp)
  803159:	e8 c0 fe ff ff       	call   80301e <free_block>
  80315e:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803161:	b8 00 00 00 00       	mov    $0x0,%eax
  803166:	e9 cc 06 00 00       	jmp    803837 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80316b:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80316f:	77 07                	ja     803178 <realloc_block_FF+0x5a>
  803171:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803178:	8b 45 0c             	mov    0xc(%ebp),%eax
  80317b:	83 e0 01             	and    $0x1,%eax
  80317e:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803181:	8b 45 0c             	mov    0xc(%ebp),%eax
  803184:	83 c0 08             	add    $0x8,%eax
  803187:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80318a:	83 ec 0c             	sub    $0xc,%esp
  80318d:	ff 75 08             	pushl  0x8(%ebp)
  803190:	e8 45 ec ff ff       	call   801dda <get_block_size>
  803195:	83 c4 10             	add    $0x10,%esp
  803198:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80319b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80319e:	83 e8 08             	sub    $0x8,%eax
  8031a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8031a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a7:	83 e8 04             	sub    $0x4,%eax
  8031aa:	8b 00                	mov    (%eax),%eax
  8031ac:	83 e0 fe             	and    $0xfffffffe,%eax
  8031af:	89 c2                	mov    %eax,%edx
  8031b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b4:	01 d0                	add    %edx,%eax
  8031b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8031b9:	83 ec 0c             	sub    $0xc,%esp
  8031bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031bf:	e8 16 ec ff ff       	call   801dda <get_block_size>
  8031c4:	83 c4 10             	add    $0x10,%esp
  8031c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031cd:	83 e8 08             	sub    $0x8,%eax
  8031d0:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8031d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031d6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8031d9:	75 08                	jne    8031e3 <realloc_block_FF+0xc5>
	{
		 return va;
  8031db:	8b 45 08             	mov    0x8(%ebp),%eax
  8031de:	e9 54 06 00 00       	jmp    803837 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8031e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031e6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8031e9:	0f 83 e5 03 00 00    	jae    8035d4 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8031ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f2:	2b 45 0c             	sub    0xc(%ebp),%eax
  8031f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8031f8:	83 ec 0c             	sub    $0xc,%esp
  8031fb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031fe:	e8 f0 eb ff ff       	call   801df3 <is_free_block>
  803203:	83 c4 10             	add    $0x10,%esp
  803206:	84 c0                	test   %al,%al
  803208:	0f 84 3b 01 00 00    	je     803349 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80320e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803211:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803214:	01 d0                	add    %edx,%eax
  803216:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803219:	83 ec 04             	sub    $0x4,%esp
  80321c:	6a 01                	push   $0x1
  80321e:	ff 75 f0             	pushl  -0x10(%ebp)
  803221:	ff 75 08             	pushl  0x8(%ebp)
  803224:	e8 02 ef ff ff       	call   80212b <set_block_data>
  803229:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80322c:	8b 45 08             	mov    0x8(%ebp),%eax
  80322f:	83 e8 04             	sub    $0x4,%eax
  803232:	8b 00                	mov    (%eax),%eax
  803234:	83 e0 fe             	and    $0xfffffffe,%eax
  803237:	89 c2                	mov    %eax,%edx
  803239:	8b 45 08             	mov    0x8(%ebp),%eax
  80323c:	01 d0                	add    %edx,%eax
  80323e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803241:	83 ec 04             	sub    $0x4,%esp
  803244:	6a 00                	push   $0x0
  803246:	ff 75 cc             	pushl  -0x34(%ebp)
  803249:	ff 75 c8             	pushl  -0x38(%ebp)
  80324c:	e8 da ee ff ff       	call   80212b <set_block_data>
  803251:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803254:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803258:	74 06                	je     803260 <realloc_block_FF+0x142>
  80325a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80325e:	75 17                	jne    803277 <realloc_block_FF+0x159>
  803260:	83 ec 04             	sub    $0x4,%esp
  803263:	68 bc 44 80 00       	push   $0x8044bc
  803268:	68 f6 01 00 00       	push   $0x1f6
  80326d:	68 49 44 80 00       	push   $0x804449
  803272:	e8 0b d0 ff ff       	call   800282 <_panic>
  803277:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80327a:	8b 10                	mov    (%eax),%edx
  80327c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80327f:	89 10                	mov    %edx,(%eax)
  803281:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803284:	8b 00                	mov    (%eax),%eax
  803286:	85 c0                	test   %eax,%eax
  803288:	74 0b                	je     803295 <realloc_block_FF+0x177>
  80328a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80328d:	8b 00                	mov    (%eax),%eax
  80328f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803292:	89 50 04             	mov    %edx,0x4(%eax)
  803295:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803298:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80329b:	89 10                	mov    %edx,(%eax)
  80329d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032a3:	89 50 04             	mov    %edx,0x4(%eax)
  8032a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032a9:	8b 00                	mov    (%eax),%eax
  8032ab:	85 c0                	test   %eax,%eax
  8032ad:	75 08                	jne    8032b7 <realloc_block_FF+0x199>
  8032af:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032b2:	a3 30 50 80 00       	mov    %eax,0x805030
  8032b7:	a1 38 50 80 00       	mov    0x805038,%eax
  8032bc:	40                   	inc    %eax
  8032bd:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8032c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032c6:	75 17                	jne    8032df <realloc_block_FF+0x1c1>
  8032c8:	83 ec 04             	sub    $0x4,%esp
  8032cb:	68 2b 44 80 00       	push   $0x80442b
  8032d0:	68 f7 01 00 00       	push   $0x1f7
  8032d5:	68 49 44 80 00       	push   $0x804449
  8032da:	e8 a3 cf ff ff       	call   800282 <_panic>
  8032df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e2:	8b 00                	mov    (%eax),%eax
  8032e4:	85 c0                	test   %eax,%eax
  8032e6:	74 10                	je     8032f8 <realloc_block_FF+0x1da>
  8032e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032eb:	8b 00                	mov    (%eax),%eax
  8032ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032f0:	8b 52 04             	mov    0x4(%edx),%edx
  8032f3:	89 50 04             	mov    %edx,0x4(%eax)
  8032f6:	eb 0b                	jmp    803303 <realloc_block_FF+0x1e5>
  8032f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032fb:	8b 40 04             	mov    0x4(%eax),%eax
  8032fe:	a3 30 50 80 00       	mov    %eax,0x805030
  803303:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803306:	8b 40 04             	mov    0x4(%eax),%eax
  803309:	85 c0                	test   %eax,%eax
  80330b:	74 0f                	je     80331c <realloc_block_FF+0x1fe>
  80330d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803310:	8b 40 04             	mov    0x4(%eax),%eax
  803313:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803316:	8b 12                	mov    (%edx),%edx
  803318:	89 10                	mov    %edx,(%eax)
  80331a:	eb 0a                	jmp    803326 <realloc_block_FF+0x208>
  80331c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80331f:	8b 00                	mov    (%eax),%eax
  803321:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803326:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803329:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80332f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803332:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803339:	a1 38 50 80 00       	mov    0x805038,%eax
  80333e:	48                   	dec    %eax
  80333f:	a3 38 50 80 00       	mov    %eax,0x805038
  803344:	e9 83 02 00 00       	jmp    8035cc <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803349:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80334d:	0f 86 69 02 00 00    	jbe    8035bc <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803353:	83 ec 04             	sub    $0x4,%esp
  803356:	6a 01                	push   $0x1
  803358:	ff 75 f0             	pushl  -0x10(%ebp)
  80335b:	ff 75 08             	pushl  0x8(%ebp)
  80335e:	e8 c8 ed ff ff       	call   80212b <set_block_data>
  803363:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803366:	8b 45 08             	mov    0x8(%ebp),%eax
  803369:	83 e8 04             	sub    $0x4,%eax
  80336c:	8b 00                	mov    (%eax),%eax
  80336e:	83 e0 fe             	and    $0xfffffffe,%eax
  803371:	89 c2                	mov    %eax,%edx
  803373:	8b 45 08             	mov    0x8(%ebp),%eax
  803376:	01 d0                	add    %edx,%eax
  803378:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80337b:	a1 38 50 80 00       	mov    0x805038,%eax
  803380:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803383:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803387:	75 68                	jne    8033f1 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803389:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80338d:	75 17                	jne    8033a6 <realloc_block_FF+0x288>
  80338f:	83 ec 04             	sub    $0x4,%esp
  803392:	68 64 44 80 00       	push   $0x804464
  803397:	68 06 02 00 00       	push   $0x206
  80339c:	68 49 44 80 00       	push   $0x804449
  8033a1:	e8 dc ce ff ff       	call   800282 <_panic>
  8033a6:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8033ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033af:	89 10                	mov    %edx,(%eax)
  8033b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033b4:	8b 00                	mov    (%eax),%eax
  8033b6:	85 c0                	test   %eax,%eax
  8033b8:	74 0d                	je     8033c7 <realloc_block_FF+0x2a9>
  8033ba:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033c2:	89 50 04             	mov    %edx,0x4(%eax)
  8033c5:	eb 08                	jmp    8033cf <realloc_block_FF+0x2b1>
  8033c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033ca:	a3 30 50 80 00       	mov    %eax,0x805030
  8033cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033d2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e1:	a1 38 50 80 00       	mov    0x805038,%eax
  8033e6:	40                   	inc    %eax
  8033e7:	a3 38 50 80 00       	mov    %eax,0x805038
  8033ec:	e9 b0 01 00 00       	jmp    8035a1 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8033f1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033f6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8033f9:	76 68                	jbe    803463 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8033fb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033ff:	75 17                	jne    803418 <realloc_block_FF+0x2fa>
  803401:	83 ec 04             	sub    $0x4,%esp
  803404:	68 64 44 80 00       	push   $0x804464
  803409:	68 0b 02 00 00       	push   $0x20b
  80340e:	68 49 44 80 00       	push   $0x804449
  803413:	e8 6a ce ff ff       	call   800282 <_panic>
  803418:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80341e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803421:	89 10                	mov    %edx,(%eax)
  803423:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803426:	8b 00                	mov    (%eax),%eax
  803428:	85 c0                	test   %eax,%eax
  80342a:	74 0d                	je     803439 <realloc_block_FF+0x31b>
  80342c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803431:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803434:	89 50 04             	mov    %edx,0x4(%eax)
  803437:	eb 08                	jmp    803441 <realloc_block_FF+0x323>
  803439:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80343c:	a3 30 50 80 00       	mov    %eax,0x805030
  803441:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803444:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803449:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80344c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803453:	a1 38 50 80 00       	mov    0x805038,%eax
  803458:	40                   	inc    %eax
  803459:	a3 38 50 80 00       	mov    %eax,0x805038
  80345e:	e9 3e 01 00 00       	jmp    8035a1 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803463:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803468:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80346b:	73 68                	jae    8034d5 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80346d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803471:	75 17                	jne    80348a <realloc_block_FF+0x36c>
  803473:	83 ec 04             	sub    $0x4,%esp
  803476:	68 98 44 80 00       	push   $0x804498
  80347b:	68 10 02 00 00       	push   $0x210
  803480:	68 49 44 80 00       	push   $0x804449
  803485:	e8 f8 cd ff ff       	call   800282 <_panic>
  80348a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803490:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803493:	89 50 04             	mov    %edx,0x4(%eax)
  803496:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803499:	8b 40 04             	mov    0x4(%eax),%eax
  80349c:	85 c0                	test   %eax,%eax
  80349e:	74 0c                	je     8034ac <realloc_block_FF+0x38e>
  8034a0:	a1 30 50 80 00       	mov    0x805030,%eax
  8034a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034a8:	89 10                	mov    %edx,(%eax)
  8034aa:	eb 08                	jmp    8034b4 <realloc_block_FF+0x396>
  8034ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034af:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034b7:	a3 30 50 80 00       	mov    %eax,0x805030
  8034bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034c5:	a1 38 50 80 00       	mov    0x805038,%eax
  8034ca:	40                   	inc    %eax
  8034cb:	a3 38 50 80 00       	mov    %eax,0x805038
  8034d0:	e9 cc 00 00 00       	jmp    8035a1 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8034d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8034dc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034e4:	e9 8a 00 00 00       	jmp    803573 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8034e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ec:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034ef:	73 7a                	jae    80356b <realloc_block_FF+0x44d>
  8034f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f4:	8b 00                	mov    (%eax),%eax
  8034f6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034f9:	73 70                	jae    80356b <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8034fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034ff:	74 06                	je     803507 <realloc_block_FF+0x3e9>
  803501:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803505:	75 17                	jne    80351e <realloc_block_FF+0x400>
  803507:	83 ec 04             	sub    $0x4,%esp
  80350a:	68 bc 44 80 00       	push   $0x8044bc
  80350f:	68 1a 02 00 00       	push   $0x21a
  803514:	68 49 44 80 00       	push   $0x804449
  803519:	e8 64 cd ff ff       	call   800282 <_panic>
  80351e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803521:	8b 10                	mov    (%eax),%edx
  803523:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803526:	89 10                	mov    %edx,(%eax)
  803528:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80352b:	8b 00                	mov    (%eax),%eax
  80352d:	85 c0                	test   %eax,%eax
  80352f:	74 0b                	je     80353c <realloc_block_FF+0x41e>
  803531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803534:	8b 00                	mov    (%eax),%eax
  803536:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803539:	89 50 04             	mov    %edx,0x4(%eax)
  80353c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803542:	89 10                	mov    %edx,(%eax)
  803544:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803547:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80354a:	89 50 04             	mov    %edx,0x4(%eax)
  80354d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803550:	8b 00                	mov    (%eax),%eax
  803552:	85 c0                	test   %eax,%eax
  803554:	75 08                	jne    80355e <realloc_block_FF+0x440>
  803556:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803559:	a3 30 50 80 00       	mov    %eax,0x805030
  80355e:	a1 38 50 80 00       	mov    0x805038,%eax
  803563:	40                   	inc    %eax
  803564:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803569:	eb 36                	jmp    8035a1 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80356b:	a1 34 50 80 00       	mov    0x805034,%eax
  803570:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803573:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803577:	74 07                	je     803580 <realloc_block_FF+0x462>
  803579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357c:	8b 00                	mov    (%eax),%eax
  80357e:	eb 05                	jmp    803585 <realloc_block_FF+0x467>
  803580:	b8 00 00 00 00       	mov    $0x0,%eax
  803585:	a3 34 50 80 00       	mov    %eax,0x805034
  80358a:	a1 34 50 80 00       	mov    0x805034,%eax
  80358f:	85 c0                	test   %eax,%eax
  803591:	0f 85 52 ff ff ff    	jne    8034e9 <realloc_block_FF+0x3cb>
  803597:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80359b:	0f 85 48 ff ff ff    	jne    8034e9 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8035a1:	83 ec 04             	sub    $0x4,%esp
  8035a4:	6a 00                	push   $0x0
  8035a6:	ff 75 d8             	pushl  -0x28(%ebp)
  8035a9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8035ac:	e8 7a eb ff ff       	call   80212b <set_block_data>
  8035b1:	83 c4 10             	add    $0x10,%esp
				return va;
  8035b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b7:	e9 7b 02 00 00       	jmp    803837 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8035bc:	83 ec 0c             	sub    $0xc,%esp
  8035bf:	68 39 45 80 00       	push   $0x804539
  8035c4:	e8 76 cf ff ff       	call   80053f <cprintf>
  8035c9:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8035cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cf:	e9 63 02 00 00       	jmp    803837 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8035d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035d7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8035da:	0f 86 4d 02 00 00    	jbe    80382d <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8035e0:	83 ec 0c             	sub    $0xc,%esp
  8035e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8035e6:	e8 08 e8 ff ff       	call   801df3 <is_free_block>
  8035eb:	83 c4 10             	add    $0x10,%esp
  8035ee:	84 c0                	test   %al,%al
  8035f0:	0f 84 37 02 00 00    	je     80382d <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8035f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035f9:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8035fc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8035ff:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803602:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803605:	76 38                	jbe    80363f <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803607:	83 ec 0c             	sub    $0xc,%esp
  80360a:	ff 75 08             	pushl  0x8(%ebp)
  80360d:	e8 0c fa ff ff       	call   80301e <free_block>
  803612:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803615:	83 ec 0c             	sub    $0xc,%esp
  803618:	ff 75 0c             	pushl  0xc(%ebp)
  80361b:	e8 3a eb ff ff       	call   80215a <alloc_block_FF>
  803620:	83 c4 10             	add    $0x10,%esp
  803623:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803626:	83 ec 08             	sub    $0x8,%esp
  803629:	ff 75 c0             	pushl  -0x40(%ebp)
  80362c:	ff 75 08             	pushl  0x8(%ebp)
  80362f:	e8 ab fa ff ff       	call   8030df <copy_data>
  803634:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803637:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80363a:	e9 f8 01 00 00       	jmp    803837 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80363f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803642:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803645:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803648:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80364c:	0f 87 a0 00 00 00    	ja     8036f2 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803652:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803656:	75 17                	jne    80366f <realloc_block_FF+0x551>
  803658:	83 ec 04             	sub    $0x4,%esp
  80365b:	68 2b 44 80 00       	push   $0x80442b
  803660:	68 38 02 00 00       	push   $0x238
  803665:	68 49 44 80 00       	push   $0x804449
  80366a:	e8 13 cc ff ff       	call   800282 <_panic>
  80366f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803672:	8b 00                	mov    (%eax),%eax
  803674:	85 c0                	test   %eax,%eax
  803676:	74 10                	je     803688 <realloc_block_FF+0x56a>
  803678:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367b:	8b 00                	mov    (%eax),%eax
  80367d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803680:	8b 52 04             	mov    0x4(%edx),%edx
  803683:	89 50 04             	mov    %edx,0x4(%eax)
  803686:	eb 0b                	jmp    803693 <realloc_block_FF+0x575>
  803688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80368b:	8b 40 04             	mov    0x4(%eax),%eax
  80368e:	a3 30 50 80 00       	mov    %eax,0x805030
  803693:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803696:	8b 40 04             	mov    0x4(%eax),%eax
  803699:	85 c0                	test   %eax,%eax
  80369b:	74 0f                	je     8036ac <realloc_block_FF+0x58e>
  80369d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a0:	8b 40 04             	mov    0x4(%eax),%eax
  8036a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036a6:	8b 12                	mov    (%edx),%edx
  8036a8:	89 10                	mov    %edx,(%eax)
  8036aa:	eb 0a                	jmp    8036b6 <realloc_block_FF+0x598>
  8036ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036af:	8b 00                	mov    (%eax),%eax
  8036b1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c9:	a1 38 50 80 00       	mov    0x805038,%eax
  8036ce:	48                   	dec    %eax
  8036cf:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8036d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036da:	01 d0                	add    %edx,%eax
  8036dc:	83 ec 04             	sub    $0x4,%esp
  8036df:	6a 01                	push   $0x1
  8036e1:	50                   	push   %eax
  8036e2:	ff 75 08             	pushl  0x8(%ebp)
  8036e5:	e8 41 ea ff ff       	call   80212b <set_block_data>
  8036ea:	83 c4 10             	add    $0x10,%esp
  8036ed:	e9 36 01 00 00       	jmp    803828 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8036f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036f5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8036f8:	01 d0                	add    %edx,%eax
  8036fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8036fd:	83 ec 04             	sub    $0x4,%esp
  803700:	6a 01                	push   $0x1
  803702:	ff 75 f0             	pushl  -0x10(%ebp)
  803705:	ff 75 08             	pushl  0x8(%ebp)
  803708:	e8 1e ea ff ff       	call   80212b <set_block_data>
  80370d:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803710:	8b 45 08             	mov    0x8(%ebp),%eax
  803713:	83 e8 04             	sub    $0x4,%eax
  803716:	8b 00                	mov    (%eax),%eax
  803718:	83 e0 fe             	and    $0xfffffffe,%eax
  80371b:	89 c2                	mov    %eax,%edx
  80371d:	8b 45 08             	mov    0x8(%ebp),%eax
  803720:	01 d0                	add    %edx,%eax
  803722:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803725:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803729:	74 06                	je     803731 <realloc_block_FF+0x613>
  80372b:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80372f:	75 17                	jne    803748 <realloc_block_FF+0x62a>
  803731:	83 ec 04             	sub    $0x4,%esp
  803734:	68 bc 44 80 00       	push   $0x8044bc
  803739:	68 44 02 00 00       	push   $0x244
  80373e:	68 49 44 80 00       	push   $0x804449
  803743:	e8 3a cb ff ff       	call   800282 <_panic>
  803748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80374b:	8b 10                	mov    (%eax),%edx
  80374d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803750:	89 10                	mov    %edx,(%eax)
  803752:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803755:	8b 00                	mov    (%eax),%eax
  803757:	85 c0                	test   %eax,%eax
  803759:	74 0b                	je     803766 <realloc_block_FF+0x648>
  80375b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80375e:	8b 00                	mov    (%eax),%eax
  803760:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803763:	89 50 04             	mov    %edx,0x4(%eax)
  803766:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803769:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80376c:	89 10                	mov    %edx,(%eax)
  80376e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803771:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803774:	89 50 04             	mov    %edx,0x4(%eax)
  803777:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80377a:	8b 00                	mov    (%eax),%eax
  80377c:	85 c0                	test   %eax,%eax
  80377e:	75 08                	jne    803788 <realloc_block_FF+0x66a>
  803780:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803783:	a3 30 50 80 00       	mov    %eax,0x805030
  803788:	a1 38 50 80 00       	mov    0x805038,%eax
  80378d:	40                   	inc    %eax
  80378e:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803793:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803797:	75 17                	jne    8037b0 <realloc_block_FF+0x692>
  803799:	83 ec 04             	sub    $0x4,%esp
  80379c:	68 2b 44 80 00       	push   $0x80442b
  8037a1:	68 45 02 00 00       	push   $0x245
  8037a6:	68 49 44 80 00       	push   $0x804449
  8037ab:	e8 d2 ca ff ff       	call   800282 <_panic>
  8037b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b3:	8b 00                	mov    (%eax),%eax
  8037b5:	85 c0                	test   %eax,%eax
  8037b7:	74 10                	je     8037c9 <realloc_block_FF+0x6ab>
  8037b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037bc:	8b 00                	mov    (%eax),%eax
  8037be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037c1:	8b 52 04             	mov    0x4(%edx),%edx
  8037c4:	89 50 04             	mov    %edx,0x4(%eax)
  8037c7:	eb 0b                	jmp    8037d4 <realloc_block_FF+0x6b6>
  8037c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037cc:	8b 40 04             	mov    0x4(%eax),%eax
  8037cf:	a3 30 50 80 00       	mov    %eax,0x805030
  8037d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d7:	8b 40 04             	mov    0x4(%eax),%eax
  8037da:	85 c0                	test   %eax,%eax
  8037dc:	74 0f                	je     8037ed <realloc_block_FF+0x6cf>
  8037de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e1:	8b 40 04             	mov    0x4(%eax),%eax
  8037e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037e7:	8b 12                	mov    (%edx),%edx
  8037e9:	89 10                	mov    %edx,(%eax)
  8037eb:	eb 0a                	jmp    8037f7 <realloc_block_FF+0x6d9>
  8037ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f0:	8b 00                	mov    (%eax),%eax
  8037f2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803800:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803803:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80380a:	a1 38 50 80 00       	mov    0x805038,%eax
  80380f:	48                   	dec    %eax
  803810:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803815:	83 ec 04             	sub    $0x4,%esp
  803818:	6a 00                	push   $0x0
  80381a:	ff 75 bc             	pushl  -0x44(%ebp)
  80381d:	ff 75 b8             	pushl  -0x48(%ebp)
  803820:	e8 06 e9 ff ff       	call   80212b <set_block_data>
  803825:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803828:	8b 45 08             	mov    0x8(%ebp),%eax
  80382b:	eb 0a                	jmp    803837 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80382d:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803834:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803837:	c9                   	leave  
  803838:	c3                   	ret    

00803839 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803839:	55                   	push   %ebp
  80383a:	89 e5                	mov    %esp,%ebp
  80383c:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80383f:	83 ec 04             	sub    $0x4,%esp
  803842:	68 40 45 80 00       	push   $0x804540
  803847:	68 58 02 00 00       	push   $0x258
  80384c:	68 49 44 80 00       	push   $0x804449
  803851:	e8 2c ca ff ff       	call   800282 <_panic>

00803856 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803856:	55                   	push   %ebp
  803857:	89 e5                	mov    %esp,%ebp
  803859:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80385c:	83 ec 04             	sub    $0x4,%esp
  80385f:	68 68 45 80 00       	push   $0x804568
  803864:	68 61 02 00 00       	push   $0x261
  803869:	68 49 44 80 00       	push   $0x804449
  80386e:	e8 0f ca ff ff       	call   800282 <_panic>

00803873 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803873:	55                   	push   %ebp
  803874:	89 e5                	mov    %esp,%ebp
  803876:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803879:	8b 55 08             	mov    0x8(%ebp),%edx
  80387c:	89 d0                	mov    %edx,%eax
  80387e:	c1 e0 02             	shl    $0x2,%eax
  803881:	01 d0                	add    %edx,%eax
  803883:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80388a:	01 d0                	add    %edx,%eax
  80388c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803893:	01 d0                	add    %edx,%eax
  803895:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80389c:	01 d0                	add    %edx,%eax
  80389e:	c1 e0 04             	shl    $0x4,%eax
  8038a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8038a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8038ab:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8038ae:	83 ec 0c             	sub    $0xc,%esp
  8038b1:	50                   	push   %eax
  8038b2:	e8 2f e2 ff ff       	call   801ae6 <sys_get_virtual_time>
  8038b7:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8038ba:	eb 41                	jmp    8038fd <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8038bc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8038bf:	83 ec 0c             	sub    $0xc,%esp
  8038c2:	50                   	push   %eax
  8038c3:	e8 1e e2 ff ff       	call   801ae6 <sys_get_virtual_time>
  8038c8:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8038cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d1:	29 c2                	sub    %eax,%edx
  8038d3:	89 d0                	mov    %edx,%eax
  8038d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8038d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038de:	89 d1                	mov    %edx,%ecx
  8038e0:	29 c1                	sub    %eax,%ecx
  8038e2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8038e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038e8:	39 c2                	cmp    %eax,%edx
  8038ea:	0f 97 c0             	seta   %al
  8038ed:	0f b6 c0             	movzbl %al,%eax
  8038f0:	29 c1                	sub    %eax,%ecx
  8038f2:	89 c8                	mov    %ecx,%eax
  8038f4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8038f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8038fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803900:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803903:	72 b7                	jb     8038bc <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803905:	90                   	nop
  803906:	c9                   	leave  
  803907:	c3                   	ret    

00803908 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803908:	55                   	push   %ebp
  803909:	89 e5                	mov    %esp,%ebp
  80390b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80390e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803915:	eb 03                	jmp    80391a <busy_wait+0x12>
  803917:	ff 45 fc             	incl   -0x4(%ebp)
  80391a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80391d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803920:	72 f5                	jb     803917 <busy_wait+0xf>
	return i;
  803922:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803925:	c9                   	leave  
  803926:	c3                   	ret    
  803927:	90                   	nop

00803928 <__udivdi3>:
  803928:	55                   	push   %ebp
  803929:	57                   	push   %edi
  80392a:	56                   	push   %esi
  80392b:	53                   	push   %ebx
  80392c:	83 ec 1c             	sub    $0x1c,%esp
  80392f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803933:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803937:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80393b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80393f:	89 ca                	mov    %ecx,%edx
  803941:	89 f8                	mov    %edi,%eax
  803943:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803947:	85 f6                	test   %esi,%esi
  803949:	75 2d                	jne    803978 <__udivdi3+0x50>
  80394b:	39 cf                	cmp    %ecx,%edi
  80394d:	77 65                	ja     8039b4 <__udivdi3+0x8c>
  80394f:	89 fd                	mov    %edi,%ebp
  803951:	85 ff                	test   %edi,%edi
  803953:	75 0b                	jne    803960 <__udivdi3+0x38>
  803955:	b8 01 00 00 00       	mov    $0x1,%eax
  80395a:	31 d2                	xor    %edx,%edx
  80395c:	f7 f7                	div    %edi
  80395e:	89 c5                	mov    %eax,%ebp
  803960:	31 d2                	xor    %edx,%edx
  803962:	89 c8                	mov    %ecx,%eax
  803964:	f7 f5                	div    %ebp
  803966:	89 c1                	mov    %eax,%ecx
  803968:	89 d8                	mov    %ebx,%eax
  80396a:	f7 f5                	div    %ebp
  80396c:	89 cf                	mov    %ecx,%edi
  80396e:	89 fa                	mov    %edi,%edx
  803970:	83 c4 1c             	add    $0x1c,%esp
  803973:	5b                   	pop    %ebx
  803974:	5e                   	pop    %esi
  803975:	5f                   	pop    %edi
  803976:	5d                   	pop    %ebp
  803977:	c3                   	ret    
  803978:	39 ce                	cmp    %ecx,%esi
  80397a:	77 28                	ja     8039a4 <__udivdi3+0x7c>
  80397c:	0f bd fe             	bsr    %esi,%edi
  80397f:	83 f7 1f             	xor    $0x1f,%edi
  803982:	75 40                	jne    8039c4 <__udivdi3+0x9c>
  803984:	39 ce                	cmp    %ecx,%esi
  803986:	72 0a                	jb     803992 <__udivdi3+0x6a>
  803988:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80398c:	0f 87 9e 00 00 00    	ja     803a30 <__udivdi3+0x108>
  803992:	b8 01 00 00 00       	mov    $0x1,%eax
  803997:	89 fa                	mov    %edi,%edx
  803999:	83 c4 1c             	add    $0x1c,%esp
  80399c:	5b                   	pop    %ebx
  80399d:	5e                   	pop    %esi
  80399e:	5f                   	pop    %edi
  80399f:	5d                   	pop    %ebp
  8039a0:	c3                   	ret    
  8039a1:	8d 76 00             	lea    0x0(%esi),%esi
  8039a4:	31 ff                	xor    %edi,%edi
  8039a6:	31 c0                	xor    %eax,%eax
  8039a8:	89 fa                	mov    %edi,%edx
  8039aa:	83 c4 1c             	add    $0x1c,%esp
  8039ad:	5b                   	pop    %ebx
  8039ae:	5e                   	pop    %esi
  8039af:	5f                   	pop    %edi
  8039b0:	5d                   	pop    %ebp
  8039b1:	c3                   	ret    
  8039b2:	66 90                	xchg   %ax,%ax
  8039b4:	89 d8                	mov    %ebx,%eax
  8039b6:	f7 f7                	div    %edi
  8039b8:	31 ff                	xor    %edi,%edi
  8039ba:	89 fa                	mov    %edi,%edx
  8039bc:	83 c4 1c             	add    $0x1c,%esp
  8039bf:	5b                   	pop    %ebx
  8039c0:	5e                   	pop    %esi
  8039c1:	5f                   	pop    %edi
  8039c2:	5d                   	pop    %ebp
  8039c3:	c3                   	ret    
  8039c4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8039c9:	89 eb                	mov    %ebp,%ebx
  8039cb:	29 fb                	sub    %edi,%ebx
  8039cd:	89 f9                	mov    %edi,%ecx
  8039cf:	d3 e6                	shl    %cl,%esi
  8039d1:	89 c5                	mov    %eax,%ebp
  8039d3:	88 d9                	mov    %bl,%cl
  8039d5:	d3 ed                	shr    %cl,%ebp
  8039d7:	89 e9                	mov    %ebp,%ecx
  8039d9:	09 f1                	or     %esi,%ecx
  8039db:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8039df:	89 f9                	mov    %edi,%ecx
  8039e1:	d3 e0                	shl    %cl,%eax
  8039e3:	89 c5                	mov    %eax,%ebp
  8039e5:	89 d6                	mov    %edx,%esi
  8039e7:	88 d9                	mov    %bl,%cl
  8039e9:	d3 ee                	shr    %cl,%esi
  8039eb:	89 f9                	mov    %edi,%ecx
  8039ed:	d3 e2                	shl    %cl,%edx
  8039ef:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039f3:	88 d9                	mov    %bl,%cl
  8039f5:	d3 e8                	shr    %cl,%eax
  8039f7:	09 c2                	or     %eax,%edx
  8039f9:	89 d0                	mov    %edx,%eax
  8039fb:	89 f2                	mov    %esi,%edx
  8039fd:	f7 74 24 0c          	divl   0xc(%esp)
  803a01:	89 d6                	mov    %edx,%esi
  803a03:	89 c3                	mov    %eax,%ebx
  803a05:	f7 e5                	mul    %ebp
  803a07:	39 d6                	cmp    %edx,%esi
  803a09:	72 19                	jb     803a24 <__udivdi3+0xfc>
  803a0b:	74 0b                	je     803a18 <__udivdi3+0xf0>
  803a0d:	89 d8                	mov    %ebx,%eax
  803a0f:	31 ff                	xor    %edi,%edi
  803a11:	e9 58 ff ff ff       	jmp    80396e <__udivdi3+0x46>
  803a16:	66 90                	xchg   %ax,%ax
  803a18:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a1c:	89 f9                	mov    %edi,%ecx
  803a1e:	d3 e2                	shl    %cl,%edx
  803a20:	39 c2                	cmp    %eax,%edx
  803a22:	73 e9                	jae    803a0d <__udivdi3+0xe5>
  803a24:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a27:	31 ff                	xor    %edi,%edi
  803a29:	e9 40 ff ff ff       	jmp    80396e <__udivdi3+0x46>
  803a2e:	66 90                	xchg   %ax,%ax
  803a30:	31 c0                	xor    %eax,%eax
  803a32:	e9 37 ff ff ff       	jmp    80396e <__udivdi3+0x46>
  803a37:	90                   	nop

00803a38 <__umoddi3>:
  803a38:	55                   	push   %ebp
  803a39:	57                   	push   %edi
  803a3a:	56                   	push   %esi
  803a3b:	53                   	push   %ebx
  803a3c:	83 ec 1c             	sub    $0x1c,%esp
  803a3f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a43:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a47:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a4b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a53:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a57:	89 f3                	mov    %esi,%ebx
  803a59:	89 fa                	mov    %edi,%edx
  803a5b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a5f:	89 34 24             	mov    %esi,(%esp)
  803a62:	85 c0                	test   %eax,%eax
  803a64:	75 1a                	jne    803a80 <__umoddi3+0x48>
  803a66:	39 f7                	cmp    %esi,%edi
  803a68:	0f 86 a2 00 00 00    	jbe    803b10 <__umoddi3+0xd8>
  803a6e:	89 c8                	mov    %ecx,%eax
  803a70:	89 f2                	mov    %esi,%edx
  803a72:	f7 f7                	div    %edi
  803a74:	89 d0                	mov    %edx,%eax
  803a76:	31 d2                	xor    %edx,%edx
  803a78:	83 c4 1c             	add    $0x1c,%esp
  803a7b:	5b                   	pop    %ebx
  803a7c:	5e                   	pop    %esi
  803a7d:	5f                   	pop    %edi
  803a7e:	5d                   	pop    %ebp
  803a7f:	c3                   	ret    
  803a80:	39 f0                	cmp    %esi,%eax
  803a82:	0f 87 ac 00 00 00    	ja     803b34 <__umoddi3+0xfc>
  803a88:	0f bd e8             	bsr    %eax,%ebp
  803a8b:	83 f5 1f             	xor    $0x1f,%ebp
  803a8e:	0f 84 ac 00 00 00    	je     803b40 <__umoddi3+0x108>
  803a94:	bf 20 00 00 00       	mov    $0x20,%edi
  803a99:	29 ef                	sub    %ebp,%edi
  803a9b:	89 fe                	mov    %edi,%esi
  803a9d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803aa1:	89 e9                	mov    %ebp,%ecx
  803aa3:	d3 e0                	shl    %cl,%eax
  803aa5:	89 d7                	mov    %edx,%edi
  803aa7:	89 f1                	mov    %esi,%ecx
  803aa9:	d3 ef                	shr    %cl,%edi
  803aab:	09 c7                	or     %eax,%edi
  803aad:	89 e9                	mov    %ebp,%ecx
  803aaf:	d3 e2                	shl    %cl,%edx
  803ab1:	89 14 24             	mov    %edx,(%esp)
  803ab4:	89 d8                	mov    %ebx,%eax
  803ab6:	d3 e0                	shl    %cl,%eax
  803ab8:	89 c2                	mov    %eax,%edx
  803aba:	8b 44 24 08          	mov    0x8(%esp),%eax
  803abe:	d3 e0                	shl    %cl,%eax
  803ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ac4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ac8:	89 f1                	mov    %esi,%ecx
  803aca:	d3 e8                	shr    %cl,%eax
  803acc:	09 d0                	or     %edx,%eax
  803ace:	d3 eb                	shr    %cl,%ebx
  803ad0:	89 da                	mov    %ebx,%edx
  803ad2:	f7 f7                	div    %edi
  803ad4:	89 d3                	mov    %edx,%ebx
  803ad6:	f7 24 24             	mull   (%esp)
  803ad9:	89 c6                	mov    %eax,%esi
  803adb:	89 d1                	mov    %edx,%ecx
  803add:	39 d3                	cmp    %edx,%ebx
  803adf:	0f 82 87 00 00 00    	jb     803b6c <__umoddi3+0x134>
  803ae5:	0f 84 91 00 00 00    	je     803b7c <__umoddi3+0x144>
  803aeb:	8b 54 24 04          	mov    0x4(%esp),%edx
  803aef:	29 f2                	sub    %esi,%edx
  803af1:	19 cb                	sbb    %ecx,%ebx
  803af3:	89 d8                	mov    %ebx,%eax
  803af5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803af9:	d3 e0                	shl    %cl,%eax
  803afb:	89 e9                	mov    %ebp,%ecx
  803afd:	d3 ea                	shr    %cl,%edx
  803aff:	09 d0                	or     %edx,%eax
  803b01:	89 e9                	mov    %ebp,%ecx
  803b03:	d3 eb                	shr    %cl,%ebx
  803b05:	89 da                	mov    %ebx,%edx
  803b07:	83 c4 1c             	add    $0x1c,%esp
  803b0a:	5b                   	pop    %ebx
  803b0b:	5e                   	pop    %esi
  803b0c:	5f                   	pop    %edi
  803b0d:	5d                   	pop    %ebp
  803b0e:	c3                   	ret    
  803b0f:	90                   	nop
  803b10:	89 fd                	mov    %edi,%ebp
  803b12:	85 ff                	test   %edi,%edi
  803b14:	75 0b                	jne    803b21 <__umoddi3+0xe9>
  803b16:	b8 01 00 00 00       	mov    $0x1,%eax
  803b1b:	31 d2                	xor    %edx,%edx
  803b1d:	f7 f7                	div    %edi
  803b1f:	89 c5                	mov    %eax,%ebp
  803b21:	89 f0                	mov    %esi,%eax
  803b23:	31 d2                	xor    %edx,%edx
  803b25:	f7 f5                	div    %ebp
  803b27:	89 c8                	mov    %ecx,%eax
  803b29:	f7 f5                	div    %ebp
  803b2b:	89 d0                	mov    %edx,%eax
  803b2d:	e9 44 ff ff ff       	jmp    803a76 <__umoddi3+0x3e>
  803b32:	66 90                	xchg   %ax,%ax
  803b34:	89 c8                	mov    %ecx,%eax
  803b36:	89 f2                	mov    %esi,%edx
  803b38:	83 c4 1c             	add    $0x1c,%esp
  803b3b:	5b                   	pop    %ebx
  803b3c:	5e                   	pop    %esi
  803b3d:	5f                   	pop    %edi
  803b3e:	5d                   	pop    %ebp
  803b3f:	c3                   	ret    
  803b40:	3b 04 24             	cmp    (%esp),%eax
  803b43:	72 06                	jb     803b4b <__umoddi3+0x113>
  803b45:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b49:	77 0f                	ja     803b5a <__umoddi3+0x122>
  803b4b:	89 f2                	mov    %esi,%edx
  803b4d:	29 f9                	sub    %edi,%ecx
  803b4f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b53:	89 14 24             	mov    %edx,(%esp)
  803b56:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b5a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b5e:	8b 14 24             	mov    (%esp),%edx
  803b61:	83 c4 1c             	add    $0x1c,%esp
  803b64:	5b                   	pop    %ebx
  803b65:	5e                   	pop    %esi
  803b66:	5f                   	pop    %edi
  803b67:	5d                   	pop    %ebp
  803b68:	c3                   	ret    
  803b69:	8d 76 00             	lea    0x0(%esi),%esi
  803b6c:	2b 04 24             	sub    (%esp),%eax
  803b6f:	19 fa                	sbb    %edi,%edx
  803b71:	89 d1                	mov    %edx,%ecx
  803b73:	89 c6                	mov    %eax,%esi
  803b75:	e9 71 ff ff ff       	jmp    803aeb <__umoddi3+0xb3>
  803b7a:	66 90                	xchg   %ax,%ax
  803b7c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b80:	72 ea                	jb     803b6c <__umoddi3+0x134>
  803b82:	89 d9                	mov    %ebx,%ecx
  803b84:	e9 62 ff ff ff       	jmp    803aeb <__umoddi3+0xb3>
