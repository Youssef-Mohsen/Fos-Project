
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
  80005b:	68 e0 3b 80 00       	push   $0x803be0
  800060:	6a 0c                	push   $0xc
  800062:	68 fc 3b 80 00       	push   $0x803bfc
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
  800073:	e8 85 1a 00 00       	call   801afd <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 19 3c 80 00       	push   $0x803c19
  800080:	50                   	push   %eax
  800081:	e8 3e 16 00 00       	call   8016c4 <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 1c 3c 80 00       	push   $0x803c1c
  800094:	e8 a6 04 00 00       	call   80053f <cprintf>
  800099:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got z
	inctst();
  80009c:	e8 81 1b 00 00       	call   801c22 <inctst>

	cprintf("Slave B2 please be patient ...\n");
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	68 44 3c 80 00       	push   $0x803c44
  8000a9:	e8 91 04 00 00       	call   80053f <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 28 23 00 00       	push   $0x2328
  8000b9:	e8 ff 37 00 00       	call   8038bd <env_sleep>
  8000be:	83 c4 10             	add    $0x10,%esp
	//to ensure that the other environments completed successfully
	while (gettst()!=3) ;// panic("test failed");
  8000c1:	90                   	nop
  8000c2:	e8 75 1b 00 00       	call   801c3c <gettst>
  8000c7:	83 f8 03             	cmp    $0x3,%eax
  8000ca:	75 f6                	jne    8000c2 <_main+0x8a>

	freeFrames = sys_calculate_free_frames() ;
  8000cc:	e8 4a 18 00 00       	call   80191b <sys_calculate_free_frames>
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	sfree(z);
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000da:	e8 6a 16 00 00       	call   801749 <sfree>
  8000df:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 64 3c 80 00       	push   $0x803c64
  8000ea:	e8 50 04 00 00       	call   80053f <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
	expected = 1+1; /*1page+1table*/
  8000f2:	c7 45 e8 02 00 00 00 	movl   $0x2,-0x18(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  8000f9:	e8 1d 18 00 00       	call   80191b <sys_calculate_free_frames>
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800103:	29 c2                	sub    %eax,%edx
  800105:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800108:	39 c2                	cmp    %eax,%edx
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 7c 3c 80 00       	push   $0x803c7c
  800114:	6a 28                	push   $0x28
  800116:	68 fc 3b 80 00       	push   $0x803bfc
  80011b:	e8 62 01 00 00       	call   800282 <_panic>


	cprintf("Step B completed successfully!!\n\n\n");
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	68 1c 3d 80 00       	push   $0x803d1c
  800128:	e8 12 04 00 00       	call   80053f <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n%~Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 40 3d 80 00       	push   $0x803d40
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
  800149:	e8 96 19 00 00       	call   801ae4 <sys_getenvindex>
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
  8001b7:	e8 ac 16 00 00       	call   801868 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	68 a8 3d 80 00       	push   $0x803da8
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
  8001e7:	68 d0 3d 80 00       	push   $0x803dd0
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
  800218:	68 f8 3d 80 00       	push   $0x803df8
  80021d:	e8 1d 03 00 00       	call   80053f <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800225:	a1 20 50 80 00       	mov    0x805020,%eax
  80022a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	50                   	push   %eax
  800234:	68 50 3e 80 00       	push   $0x803e50
  800239:	e8 01 03 00 00       	call   80053f <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	68 a8 3d 80 00       	push   $0x803da8
  800249:	e8 f1 02 00 00       	call   80053f <cprintf>
  80024e:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800251:	e8 2c 16 00 00       	call   801882 <sys_unlock_cons>
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
  800269:	e8 42 18 00 00       	call   801ab0 <sys_destroy_env>
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
  80027a:	e8 97 18 00 00       	call   801b16 <sys_exit_env>
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
  8002a3:	68 64 3e 80 00       	push   $0x803e64
  8002a8:	e8 92 02 00 00       	call   80053f <cprintf>
  8002ad:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b0:	a1 00 50 80 00       	mov    0x805000,%eax
  8002b5:	ff 75 0c             	pushl  0xc(%ebp)
  8002b8:	ff 75 08             	pushl  0x8(%ebp)
  8002bb:	50                   	push   %eax
  8002bc:	68 69 3e 80 00       	push   $0x803e69
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
  8002e0:	68 85 3e 80 00       	push   $0x803e85
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
  80030f:	68 88 3e 80 00       	push   $0x803e88
  800314:	6a 26                	push   $0x26
  800316:	68 d4 3e 80 00       	push   $0x803ed4
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
  8003e4:	68 e0 3e 80 00       	push   $0x803ee0
  8003e9:	6a 3a                	push   $0x3a
  8003eb:	68 d4 3e 80 00       	push   $0x803ed4
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
  800457:	68 34 3f 80 00       	push   $0x803f34
  80045c:	6a 44                	push   $0x44
  80045e:	68 d4 3e 80 00       	push   $0x803ed4
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
  8004b1:	e8 70 13 00 00       	call   801826 <sys_cputs>
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
  800528:	e8 f9 12 00 00       	call   801826 <sys_cputs>
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
  800572:	e8 f1 12 00 00       	call   801868 <sys_lock_cons>
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
  800592:	e8 eb 12 00 00       	call   801882 <sys_unlock_cons>
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
  8005dc:	e8 93 33 00 00       	call   803974 <__udivdi3>
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
  80062c:	e8 53 34 00 00       	call   803a84 <__umoddi3>
  800631:	83 c4 10             	add    $0x10,%esp
  800634:	05 94 41 80 00       	add    $0x804194,%eax
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
  800787:	8b 04 85 b8 41 80 00 	mov    0x8041b8(,%eax,4),%eax
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
  800868:	8b 34 9d 00 40 80 00 	mov    0x804000(,%ebx,4),%esi
  80086f:	85 f6                	test   %esi,%esi
  800871:	75 19                	jne    80088c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800873:	53                   	push   %ebx
  800874:	68 a5 41 80 00       	push   $0x8041a5
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
  80088d:	68 ae 41 80 00       	push   $0x8041ae
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
  8008ba:	be b1 41 80 00       	mov    $0x8041b1,%esi
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
  8012c5:	68 28 43 80 00       	push   $0x804328
  8012ca:	68 3f 01 00 00       	push   $0x13f
  8012cf:	68 4a 43 80 00       	push   $0x80434a
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
  8012e5:	e8 e7 0a 00 00       	call   801dd1 <sys_sbrk>
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
  801360:	e8 f0 08 00 00       	call   801c55 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801365:	85 c0                	test   %eax,%eax
  801367:	74 16                	je     80137f <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801369:	83 ec 0c             	sub    $0xc,%esp
  80136c:	ff 75 08             	pushl  0x8(%ebp)
  80136f:	e8 30 0e 00 00       	call   8021a4 <alloc_block_FF>
  801374:	83 c4 10             	add    $0x10,%esp
  801377:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80137a:	e9 8a 01 00 00       	jmp    801509 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80137f:	e8 02 09 00 00       	call   801c86 <sys_isUHeapPlacementStrategyBESTFIT>
  801384:	85 c0                	test   %eax,%eax
  801386:	0f 84 7d 01 00 00    	je     801509 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80138c:	83 ec 0c             	sub    $0xc,%esp
  80138f:	ff 75 08             	pushl  0x8(%ebp)
  801392:	e8 c9 12 00 00       	call   802660 <alloc_block_BF>
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
  8013e2:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  80142f:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801486:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
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
  8014e8:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8014ef:	83 ec 08             	sub    $0x8,%esp
  8014f2:	ff 75 08             	pushl  0x8(%ebp)
  8014f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8014f8:	e8 0b 09 00 00       	call   801e08 <sys_allocate_user_mem>
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
  801540:	e8 df 08 00 00       	call   801e24 <get_block_size>
  801545:	83 c4 10             	add    $0x10,%esp
  801548:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80154b:	83 ec 0c             	sub    $0xc,%esp
  80154e:	ff 75 08             	pushl  0x8(%ebp)
  801551:	e8 12 1b 00 00       	call   803068 <free_block>
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
  80158b:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  8015c8:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
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
  8015e8:	e8 ff 07 00 00       	call   801dec <sys_free_user_mem>
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
  8015f6:	68 58 43 80 00       	push   $0x804358
  8015fb:	68 85 00 00 00       	push   $0x85
  801600:	68 82 43 80 00       	push   $0x804382
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
  80161c:	75 0a                	jne    801628 <smalloc+0x1c>
  80161e:	b8 00 00 00 00       	mov    $0x0,%eax
  801623:	e9 9a 00 00 00       	jmp    8016c2 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80162e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801635:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163b:	39 d0                	cmp    %edx,%eax
  80163d:	73 02                	jae    801641 <smalloc+0x35>
  80163f:	89 d0                	mov    %edx,%eax
  801641:	83 ec 0c             	sub    $0xc,%esp
  801644:	50                   	push   %eax
  801645:	e8 a5 fc ff ff       	call   8012ef <malloc>
  80164a:	83 c4 10             	add    $0x10,%esp
  80164d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801650:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801654:	75 07                	jne    80165d <smalloc+0x51>
  801656:	b8 00 00 00 00       	mov    $0x0,%eax
  80165b:	eb 65                	jmp    8016c2 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80165d:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801661:	ff 75 ec             	pushl  -0x14(%ebp)
  801664:	50                   	push   %eax
  801665:	ff 75 0c             	pushl  0xc(%ebp)
  801668:	ff 75 08             	pushl  0x8(%ebp)
  80166b:	e8 83 03 00 00       	call   8019f3 <sys_createSharedObject>
  801670:	83 c4 10             	add    $0x10,%esp
  801673:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801676:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80167a:	74 06                	je     801682 <smalloc+0x76>
  80167c:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801680:	75 07                	jne    801689 <smalloc+0x7d>
  801682:	b8 00 00 00 00       	mov    $0x0,%eax
  801687:	eb 39                	jmp    8016c2 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  801689:	83 ec 08             	sub    $0x8,%esp
  80168c:	ff 75 ec             	pushl  -0x14(%ebp)
  80168f:	68 8e 43 80 00       	push   $0x80438e
  801694:	e8 a6 ee ff ff       	call   80053f <cprintf>
  801699:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  80169c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80169f:	a1 20 50 80 00       	mov    0x805020,%eax
  8016a4:	8b 40 78             	mov    0x78(%eax),%eax
  8016a7:	29 c2                	sub    %eax,%edx
  8016a9:	89 d0                	mov    %edx,%eax
  8016ab:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016b0:	c1 e8 0c             	shr    $0xc,%eax
  8016b3:	89 c2                	mov    %eax,%edx
  8016b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016b8:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8016bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
  8016c7:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016ca:	83 ec 08             	sub    $0x8,%esp
  8016cd:	ff 75 0c             	pushl  0xc(%ebp)
  8016d0:	ff 75 08             	pushl  0x8(%ebp)
  8016d3:	e8 45 03 00 00       	call   801a1d <sys_getSizeOfSharedObject>
  8016d8:	83 c4 10             	add    $0x10,%esp
  8016db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8016de:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016e2:	75 07                	jne    8016eb <sget+0x27>
  8016e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e9:	eb 5c                	jmp    801747 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8016eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016f1:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fe:	39 d0                	cmp    %edx,%eax
  801700:	7d 02                	jge    801704 <sget+0x40>
  801702:	89 d0                	mov    %edx,%eax
  801704:	83 ec 0c             	sub    $0xc,%esp
  801707:	50                   	push   %eax
  801708:	e8 e2 fb ff ff       	call   8012ef <malloc>
  80170d:	83 c4 10             	add    $0x10,%esp
  801710:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801713:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801717:	75 07                	jne    801720 <sget+0x5c>
  801719:	b8 00 00 00 00       	mov    $0x0,%eax
  80171e:	eb 27                	jmp    801747 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801720:	83 ec 04             	sub    $0x4,%esp
  801723:	ff 75 e8             	pushl  -0x18(%ebp)
  801726:	ff 75 0c             	pushl  0xc(%ebp)
  801729:	ff 75 08             	pushl  0x8(%ebp)
  80172c:	e8 09 03 00 00       	call   801a3a <sys_getSharedObject>
  801731:	83 c4 10             	add    $0x10,%esp
  801734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801737:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80173b:	75 07                	jne    801744 <sget+0x80>
  80173d:	b8 00 00 00 00       	mov    $0x0,%eax
  801742:	eb 03                	jmp    801747 <sget+0x83>
	return ptr;
  801744:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801747:	c9                   	leave  
  801748:	c3                   	ret    

00801749 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
  80174c:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  80174f:	8b 55 08             	mov    0x8(%ebp),%edx
  801752:	a1 20 50 80 00       	mov    0x805020,%eax
  801757:	8b 40 78             	mov    0x78(%eax),%eax
  80175a:	29 c2                	sub    %eax,%edx
  80175c:	89 d0                	mov    %edx,%eax
  80175e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801763:	c1 e8 0c             	shr    $0xc,%eax
  801766:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  80176d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801770:	83 ec 08             	sub    $0x8,%esp
  801773:	ff 75 08             	pushl  0x8(%ebp)
  801776:	ff 75 f4             	pushl  -0xc(%ebp)
  801779:	e8 db 02 00 00       	call   801a59 <sys_freeSharedObject>
  80177e:	83 c4 10             	add    $0x10,%esp
  801781:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801784:	90                   	nop
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
  80178a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80178d:	83 ec 04             	sub    $0x4,%esp
  801790:	68 a0 43 80 00       	push   $0x8043a0
  801795:	68 dd 00 00 00       	push   $0xdd
  80179a:	68 82 43 80 00       	push   $0x804382
  80179f:	e8 de ea ff ff       	call   800282 <_panic>

008017a4 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017aa:	83 ec 04             	sub    $0x4,%esp
  8017ad:	68 c6 43 80 00       	push   $0x8043c6
  8017b2:	68 e9 00 00 00       	push   $0xe9
  8017b7:	68 82 43 80 00       	push   $0x804382
  8017bc:	e8 c1 ea ff ff       	call   800282 <_panic>

008017c1 <shrink>:

}
void shrink(uint32 newSize)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c7:	83 ec 04             	sub    $0x4,%esp
  8017ca:	68 c6 43 80 00       	push   $0x8043c6
  8017cf:	68 ee 00 00 00       	push   $0xee
  8017d4:	68 82 43 80 00       	push   $0x804382
  8017d9:	e8 a4 ea ff ff       	call   800282 <_panic>

008017de <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e4:	83 ec 04             	sub    $0x4,%esp
  8017e7:	68 c6 43 80 00       	push   $0x8043c6
  8017ec:	68 f3 00 00 00       	push   $0xf3
  8017f1:	68 82 43 80 00       	push   $0x804382
  8017f6:	e8 87 ea ff ff       	call   800282 <_panic>

008017fb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
  8017fe:	57                   	push   %edi
  8017ff:	56                   	push   %esi
  801800:	53                   	push   %ebx
  801801:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80180d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801810:	8b 7d 18             	mov    0x18(%ebp),%edi
  801813:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801816:	cd 30                	int    $0x30
  801818:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80181b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80181e:	83 c4 10             	add    $0x10,%esp
  801821:	5b                   	pop    %ebx
  801822:	5e                   	pop    %esi
  801823:	5f                   	pop    %edi
  801824:	5d                   	pop    %ebp
  801825:	c3                   	ret    

00801826 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	83 ec 04             	sub    $0x4,%esp
  80182c:	8b 45 10             	mov    0x10(%ebp),%eax
  80182f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801832:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	52                   	push   %edx
  80183e:	ff 75 0c             	pushl  0xc(%ebp)
  801841:	50                   	push   %eax
  801842:	6a 00                	push   $0x0
  801844:	e8 b2 ff ff ff       	call   8017fb <syscall>
  801849:	83 c4 18             	add    $0x18,%esp
}
  80184c:	90                   	nop
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <sys_cgetc>:

int
sys_cgetc(void)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 02                	push   $0x2
  80185e:	e8 98 ff ff ff       	call   8017fb <syscall>
  801863:	83 c4 18             	add    $0x18,%esp
}
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 03                	push   $0x3
  801877:	e8 7f ff ff ff       	call   8017fb <syscall>
  80187c:	83 c4 18             	add    $0x18,%esp
}
  80187f:	90                   	nop
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 04                	push   $0x4
  801891:	e8 65 ff ff ff       	call   8017fb <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	90                   	nop
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80189f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	52                   	push   %edx
  8018ac:	50                   	push   %eax
  8018ad:	6a 08                	push   $0x8
  8018af:	e8 47 ff ff ff       	call   8017fb <syscall>
  8018b4:	83 c4 18             	add    $0x18,%esp
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	56                   	push   %esi
  8018bd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018be:	8b 75 18             	mov    0x18(%ebp),%esi
  8018c1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	56                   	push   %esi
  8018ce:	53                   	push   %ebx
  8018cf:	51                   	push   %ecx
  8018d0:	52                   	push   %edx
  8018d1:	50                   	push   %eax
  8018d2:	6a 09                	push   $0x9
  8018d4:	e8 22 ff ff ff       	call   8017fb <syscall>
  8018d9:	83 c4 18             	add    $0x18,%esp
}
  8018dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018df:	5b                   	pop    %ebx
  8018e0:	5e                   	pop    %esi
  8018e1:	5d                   	pop    %ebp
  8018e2:	c3                   	ret    

008018e3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	52                   	push   %edx
  8018f3:	50                   	push   %eax
  8018f4:	6a 0a                	push   $0xa
  8018f6:	e8 00 ff ff ff       	call   8017fb <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	ff 75 0c             	pushl  0xc(%ebp)
  80190c:	ff 75 08             	pushl  0x8(%ebp)
  80190f:	6a 0b                	push   $0xb
  801911:	e8 e5 fe ff ff       	call   8017fb <syscall>
  801916:	83 c4 18             	add    $0x18,%esp
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 0c                	push   $0xc
  80192a:	e8 cc fe ff ff       	call   8017fb <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 0d                	push   $0xd
  801943:	e8 b3 fe ff ff       	call   8017fb <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 0e                	push   $0xe
  80195c:	e8 9a fe ff ff       	call   8017fb <syscall>
  801961:	83 c4 18             	add    $0x18,%esp
}
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 0f                	push   $0xf
  801975:	e8 81 fe ff ff       	call   8017fb <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	ff 75 08             	pushl  0x8(%ebp)
  80198d:	6a 10                	push   $0x10
  80198f:	e8 67 fe ff ff       	call   8017fb <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 11                	push   $0x11
  8019a8:	e8 4e fe ff ff       	call   8017fb <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
}
  8019b0:	90                   	nop
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_cputc>:

void
sys_cputc(const char c)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
  8019b6:	83 ec 04             	sub    $0x4,%esp
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019bf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	50                   	push   %eax
  8019cc:	6a 01                	push   $0x1
  8019ce:	e8 28 fe ff ff       	call   8017fb <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
}
  8019d6:	90                   	nop
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 14                	push   $0x14
  8019e8:	e8 0e fe ff ff       	call   8017fb <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
}
  8019f0:	90                   	nop
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	83 ec 04             	sub    $0x4,%esp
  8019f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019ff:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a02:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a06:	8b 45 08             	mov    0x8(%ebp),%eax
  801a09:	6a 00                	push   $0x0
  801a0b:	51                   	push   %ecx
  801a0c:	52                   	push   %edx
  801a0d:	ff 75 0c             	pushl  0xc(%ebp)
  801a10:	50                   	push   %eax
  801a11:	6a 15                	push   $0x15
  801a13:	e8 e3 fd ff ff       	call   8017fb <syscall>
  801a18:	83 c4 18             	add    $0x18,%esp
}
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a23:	8b 45 08             	mov    0x8(%ebp),%eax
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	52                   	push   %edx
  801a2d:	50                   	push   %eax
  801a2e:	6a 16                	push   $0x16
  801a30:	e8 c6 fd ff ff       	call   8017fb <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a43:	8b 45 08             	mov    0x8(%ebp),%eax
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	51                   	push   %ecx
  801a4b:	52                   	push   %edx
  801a4c:	50                   	push   %eax
  801a4d:	6a 17                	push   $0x17
  801a4f:	e8 a7 fd ff ff       	call   8017fb <syscall>
  801a54:	83 c4 18             	add    $0x18,%esp
}
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	52                   	push   %edx
  801a69:	50                   	push   %eax
  801a6a:	6a 18                	push   $0x18
  801a6c:	e8 8a fd ff ff       	call   8017fb <syscall>
  801a71:	83 c4 18             	add    $0x18,%esp
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	6a 00                	push   $0x0
  801a7e:	ff 75 14             	pushl  0x14(%ebp)
  801a81:	ff 75 10             	pushl  0x10(%ebp)
  801a84:	ff 75 0c             	pushl  0xc(%ebp)
  801a87:	50                   	push   %eax
  801a88:	6a 19                	push   $0x19
  801a8a:	e8 6c fd ff ff       	call   8017fb <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	50                   	push   %eax
  801aa3:	6a 1a                	push   $0x1a
  801aa5:	e8 51 fd ff ff       	call   8017fb <syscall>
  801aaa:	83 c4 18             	add    $0x18,%esp
}
  801aad:	90                   	nop
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	50                   	push   %eax
  801abf:	6a 1b                	push   $0x1b
  801ac1:	e8 35 fd ff ff       	call   8017fb <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_getenvid>:

int32 sys_getenvid(void)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 05                	push   $0x5
  801ada:	e8 1c fd ff ff       	call   8017fb <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
}
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 06                	push   $0x6
  801af3:	e8 03 fd ff ff       	call   8017fb <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
}
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 07                	push   $0x7
  801b0c:	e8 ea fc ff ff       	call   8017fb <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
}
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <sys_exit_env>:


void sys_exit_env(void)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 1c                	push   $0x1c
  801b25:	e8 d1 fc ff ff       	call   8017fb <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
}
  801b2d:	90                   	nop
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b36:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b39:	8d 50 04             	lea    0x4(%eax),%edx
  801b3c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	52                   	push   %edx
  801b46:	50                   	push   %eax
  801b47:	6a 1d                	push   $0x1d
  801b49:	e8 ad fc ff ff       	call   8017fb <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
	return result;
  801b51:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b57:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b5a:	89 01                	mov    %eax,(%ecx)
  801b5c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b62:	c9                   	leave  
  801b63:	c2 04 00             	ret    $0x4

00801b66 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	ff 75 10             	pushl  0x10(%ebp)
  801b70:	ff 75 0c             	pushl  0xc(%ebp)
  801b73:	ff 75 08             	pushl  0x8(%ebp)
  801b76:	6a 13                	push   $0x13
  801b78:	e8 7e fc ff ff       	call   8017fb <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b80:	90                   	nop
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 1e                	push   $0x1e
  801b92:	e8 64 fc ff ff       	call   8017fb <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
}
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
  801b9f:	83 ec 04             	sub    $0x4,%esp
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ba8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	50                   	push   %eax
  801bb5:	6a 1f                	push   $0x1f
  801bb7:	e8 3f fc ff ff       	call   8017fb <syscall>
  801bbc:	83 c4 18             	add    $0x18,%esp
	return ;
  801bbf:	90                   	nop
}
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <rsttst>:
void rsttst()
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 21                	push   $0x21
  801bd1:	e8 25 fc ff ff       	call   8017fb <syscall>
  801bd6:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd9:	90                   	nop
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 04             	sub    $0x4,%esp
  801be2:	8b 45 14             	mov    0x14(%ebp),%eax
  801be5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801be8:	8b 55 18             	mov    0x18(%ebp),%edx
  801beb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bef:	52                   	push   %edx
  801bf0:	50                   	push   %eax
  801bf1:	ff 75 10             	pushl  0x10(%ebp)
  801bf4:	ff 75 0c             	pushl  0xc(%ebp)
  801bf7:	ff 75 08             	pushl  0x8(%ebp)
  801bfa:	6a 20                	push   $0x20
  801bfc:	e8 fa fb ff ff       	call   8017fb <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
	return ;
  801c04:	90                   	nop
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <chktst>:
void chktst(uint32 n)
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	ff 75 08             	pushl  0x8(%ebp)
  801c15:	6a 22                	push   $0x22
  801c17:	e8 df fb ff ff       	call   8017fb <syscall>
  801c1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c1f:	90                   	nop
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <inctst>:

void inctst()
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 23                	push   $0x23
  801c31:	e8 c5 fb ff ff       	call   8017fb <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
	return ;
  801c39:	90                   	nop
}
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <gettst>:
uint32 gettst()
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 24                	push   $0x24
  801c4b:	e8 ab fb ff ff       	call   8017fb <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 25                	push   $0x25
  801c67:	e8 8f fb ff ff       	call   8017fb <syscall>
  801c6c:	83 c4 18             	add    $0x18,%esp
  801c6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c72:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c76:	75 07                	jne    801c7f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c78:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7d:	eb 05                	jmp    801c84 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 25                	push   $0x25
  801c98:	e8 5e fb ff ff       	call   8017fb <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
  801ca0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ca3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ca7:	75 07                	jne    801cb0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ca9:	b8 01 00 00 00       	mov    $0x1,%eax
  801cae:	eb 05                	jmp    801cb5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 25                	push   $0x25
  801cc9:	e8 2d fb ff ff       	call   8017fb <syscall>
  801cce:	83 c4 18             	add    $0x18,%esp
  801cd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cd4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cd8:	75 07                	jne    801ce1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cda:	b8 01 00 00 00       	mov    $0x1,%eax
  801cdf:	eb 05                	jmp    801ce6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ce1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 25                	push   $0x25
  801cfa:	e8 fc fa ff ff       	call   8017fb <syscall>
  801cff:	83 c4 18             	add    $0x18,%esp
  801d02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d05:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d09:	75 07                	jne    801d12 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d0b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d10:	eb 05                	jmp    801d17 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	ff 75 08             	pushl  0x8(%ebp)
  801d27:	6a 26                	push   $0x26
  801d29:	e8 cd fa ff ff       	call   8017fb <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d31:	90                   	nop
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
  801d37:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d38:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d3b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	6a 00                	push   $0x0
  801d46:	53                   	push   %ebx
  801d47:	51                   	push   %ecx
  801d48:	52                   	push   %edx
  801d49:	50                   	push   %eax
  801d4a:	6a 27                	push   $0x27
  801d4c:	e8 aa fa ff ff       	call   8017fb <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
}
  801d54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	52                   	push   %edx
  801d69:	50                   	push   %eax
  801d6a:	6a 28                	push   $0x28
  801d6c:	e8 8a fa ff ff       	call   8017fb <syscall>
  801d71:	83 c4 18             	add    $0x18,%esp
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d79:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	6a 00                	push   $0x0
  801d84:	51                   	push   %ecx
  801d85:	ff 75 10             	pushl  0x10(%ebp)
  801d88:	52                   	push   %edx
  801d89:	50                   	push   %eax
  801d8a:	6a 29                	push   $0x29
  801d8c:	e8 6a fa ff ff       	call   8017fb <syscall>
  801d91:	83 c4 18             	add    $0x18,%esp
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	ff 75 10             	pushl  0x10(%ebp)
  801da0:	ff 75 0c             	pushl  0xc(%ebp)
  801da3:	ff 75 08             	pushl  0x8(%ebp)
  801da6:	6a 12                	push   $0x12
  801da8:	e8 4e fa ff ff       	call   8017fb <syscall>
  801dad:	83 c4 18             	add    $0x18,%esp
	return ;
  801db0:	90                   	nop
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801db6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	52                   	push   %edx
  801dc3:	50                   	push   %eax
  801dc4:	6a 2a                	push   $0x2a
  801dc6:	e8 30 fa ff ff       	call   8017fb <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
	return;
  801dce:	90                   	nop
}
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	50                   	push   %eax
  801de0:	6a 2b                	push   $0x2b
  801de2:	e8 14 fa ff ff       	call   8017fb <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	ff 75 0c             	pushl  0xc(%ebp)
  801df8:	ff 75 08             	pushl  0x8(%ebp)
  801dfb:	6a 2c                	push   $0x2c
  801dfd:	e8 f9 f9 ff ff       	call   8017fb <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
	return;
  801e05:	90                   	nop
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	ff 75 0c             	pushl  0xc(%ebp)
  801e14:	ff 75 08             	pushl  0x8(%ebp)
  801e17:	6a 2d                	push   $0x2d
  801e19:	e8 dd f9 ff ff       	call   8017fb <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
	return;
  801e21:	90                   	nop
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2d:	83 e8 04             	sub    $0x4,%eax
  801e30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801e33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e36:	8b 00                	mov    (%eax),%eax
  801e38:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
  801e40:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e43:	8b 45 08             	mov    0x8(%ebp),%eax
  801e46:	83 e8 04             	sub    $0x4,%eax
  801e49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801e4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e4f:	8b 00                	mov    (%eax),%eax
  801e51:	83 e0 01             	and    $0x1,%eax
  801e54:	85 c0                	test   %eax,%eax
  801e56:	0f 94 c0             	sete   %al
}
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801e61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e6b:	83 f8 02             	cmp    $0x2,%eax
  801e6e:	74 2b                	je     801e9b <alloc_block+0x40>
  801e70:	83 f8 02             	cmp    $0x2,%eax
  801e73:	7f 07                	jg     801e7c <alloc_block+0x21>
  801e75:	83 f8 01             	cmp    $0x1,%eax
  801e78:	74 0e                	je     801e88 <alloc_block+0x2d>
  801e7a:	eb 58                	jmp    801ed4 <alloc_block+0x79>
  801e7c:	83 f8 03             	cmp    $0x3,%eax
  801e7f:	74 2d                	je     801eae <alloc_block+0x53>
  801e81:	83 f8 04             	cmp    $0x4,%eax
  801e84:	74 3b                	je     801ec1 <alloc_block+0x66>
  801e86:	eb 4c                	jmp    801ed4 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801e88:	83 ec 0c             	sub    $0xc,%esp
  801e8b:	ff 75 08             	pushl  0x8(%ebp)
  801e8e:	e8 11 03 00 00       	call   8021a4 <alloc_block_FF>
  801e93:	83 c4 10             	add    $0x10,%esp
  801e96:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e99:	eb 4a                	jmp    801ee5 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801e9b:	83 ec 0c             	sub    $0xc,%esp
  801e9e:	ff 75 08             	pushl  0x8(%ebp)
  801ea1:	e8 fa 19 00 00       	call   8038a0 <alloc_block_NF>
  801ea6:	83 c4 10             	add    $0x10,%esp
  801ea9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801eac:	eb 37                	jmp    801ee5 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801eae:	83 ec 0c             	sub    $0xc,%esp
  801eb1:	ff 75 08             	pushl  0x8(%ebp)
  801eb4:	e8 a7 07 00 00       	call   802660 <alloc_block_BF>
  801eb9:	83 c4 10             	add    $0x10,%esp
  801ebc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ebf:	eb 24                	jmp    801ee5 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801ec1:	83 ec 0c             	sub    $0xc,%esp
  801ec4:	ff 75 08             	pushl  0x8(%ebp)
  801ec7:	e8 b7 19 00 00       	call   803883 <alloc_block_WF>
  801ecc:	83 c4 10             	add    $0x10,%esp
  801ecf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ed2:	eb 11                	jmp    801ee5 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801ed4:	83 ec 0c             	sub    $0xc,%esp
  801ed7:	68 d8 43 80 00       	push   $0x8043d8
  801edc:	e8 5e e6 ff ff       	call   80053f <cprintf>
  801ee1:	83 c4 10             	add    $0x10,%esp
		break;
  801ee4:	90                   	nop
	}
	return va;
  801ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	53                   	push   %ebx
  801eee:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801ef1:	83 ec 0c             	sub    $0xc,%esp
  801ef4:	68 f8 43 80 00       	push   $0x8043f8
  801ef9:	e8 41 e6 ff ff       	call   80053f <cprintf>
  801efe:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801f01:	83 ec 0c             	sub    $0xc,%esp
  801f04:	68 23 44 80 00       	push   $0x804423
  801f09:	e8 31 e6 ff ff       	call   80053f <cprintf>
  801f0e:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f17:	eb 37                	jmp    801f50 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801f19:	83 ec 0c             	sub    $0xc,%esp
  801f1c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f1f:	e8 19 ff ff ff       	call   801e3d <is_free_block>
  801f24:	83 c4 10             	add    $0x10,%esp
  801f27:	0f be d8             	movsbl %al,%ebx
  801f2a:	83 ec 0c             	sub    $0xc,%esp
  801f2d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f30:	e8 ef fe ff ff       	call   801e24 <get_block_size>
  801f35:	83 c4 10             	add    $0x10,%esp
  801f38:	83 ec 04             	sub    $0x4,%esp
  801f3b:	53                   	push   %ebx
  801f3c:	50                   	push   %eax
  801f3d:	68 3b 44 80 00       	push   $0x80443b
  801f42:	e8 f8 e5 ff ff       	call   80053f <cprintf>
  801f47:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801f4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f54:	74 07                	je     801f5d <print_blocks_list+0x73>
  801f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f59:	8b 00                	mov    (%eax),%eax
  801f5b:	eb 05                	jmp    801f62 <print_blocks_list+0x78>
  801f5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f62:	89 45 10             	mov    %eax,0x10(%ebp)
  801f65:	8b 45 10             	mov    0x10(%ebp),%eax
  801f68:	85 c0                	test   %eax,%eax
  801f6a:	75 ad                	jne    801f19 <print_blocks_list+0x2f>
  801f6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f70:	75 a7                	jne    801f19 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801f72:	83 ec 0c             	sub    $0xc,%esp
  801f75:	68 f8 43 80 00       	push   $0x8043f8
  801f7a:	e8 c0 e5 ff ff       	call   80053f <cprintf>
  801f7f:	83 c4 10             	add    $0x10,%esp

}
  801f82:	90                   	nop
  801f83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
  801f8b:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f91:	83 e0 01             	and    $0x1,%eax
  801f94:	85 c0                	test   %eax,%eax
  801f96:	74 03                	je     801f9b <initialize_dynamic_allocator+0x13>
  801f98:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801f9b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f9f:	0f 84 c7 01 00 00    	je     80216c <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801fa5:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801fac:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801faf:	8b 55 08             	mov    0x8(%ebp),%edx
  801fb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb5:	01 d0                	add    %edx,%eax
  801fb7:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801fbc:	0f 87 ad 01 00 00    	ja     80216f <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc5:	85 c0                	test   %eax,%eax
  801fc7:	0f 89 a5 01 00 00    	jns    802172 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801fcd:	8b 55 08             	mov    0x8(%ebp),%edx
  801fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd3:	01 d0                	add    %edx,%eax
  801fd5:	83 e8 04             	sub    $0x4,%eax
  801fd8:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801fdd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801fe4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801fe9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fec:	e9 87 00 00 00       	jmp    802078 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801ff1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff5:	75 14                	jne    80200b <initialize_dynamic_allocator+0x83>
  801ff7:	83 ec 04             	sub    $0x4,%esp
  801ffa:	68 53 44 80 00       	push   $0x804453
  801fff:	6a 79                	push   $0x79
  802001:	68 71 44 80 00       	push   $0x804471
  802006:	e8 77 e2 ff ff       	call   800282 <_panic>
  80200b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200e:	8b 00                	mov    (%eax),%eax
  802010:	85 c0                	test   %eax,%eax
  802012:	74 10                	je     802024 <initialize_dynamic_allocator+0x9c>
  802014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802017:	8b 00                	mov    (%eax),%eax
  802019:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80201c:	8b 52 04             	mov    0x4(%edx),%edx
  80201f:	89 50 04             	mov    %edx,0x4(%eax)
  802022:	eb 0b                	jmp    80202f <initialize_dynamic_allocator+0xa7>
  802024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802027:	8b 40 04             	mov    0x4(%eax),%eax
  80202a:	a3 30 50 80 00       	mov    %eax,0x805030
  80202f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802032:	8b 40 04             	mov    0x4(%eax),%eax
  802035:	85 c0                	test   %eax,%eax
  802037:	74 0f                	je     802048 <initialize_dynamic_allocator+0xc0>
  802039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203c:	8b 40 04             	mov    0x4(%eax),%eax
  80203f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802042:	8b 12                	mov    (%edx),%edx
  802044:	89 10                	mov    %edx,(%eax)
  802046:	eb 0a                	jmp    802052 <initialize_dynamic_allocator+0xca>
  802048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204b:	8b 00                	mov    (%eax),%eax
  80204d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802055:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80205b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802065:	a1 38 50 80 00       	mov    0x805038,%eax
  80206a:	48                   	dec    %eax
  80206b:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802070:	a1 34 50 80 00       	mov    0x805034,%eax
  802075:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802078:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80207c:	74 07                	je     802085 <initialize_dynamic_allocator+0xfd>
  80207e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802081:	8b 00                	mov    (%eax),%eax
  802083:	eb 05                	jmp    80208a <initialize_dynamic_allocator+0x102>
  802085:	b8 00 00 00 00       	mov    $0x0,%eax
  80208a:	a3 34 50 80 00       	mov    %eax,0x805034
  80208f:	a1 34 50 80 00       	mov    0x805034,%eax
  802094:	85 c0                	test   %eax,%eax
  802096:	0f 85 55 ff ff ff    	jne    801ff1 <initialize_dynamic_allocator+0x69>
  80209c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a0:	0f 85 4b ff ff ff    	jne    801ff1 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8020ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020af:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8020b5:	a1 44 50 80 00       	mov    0x805044,%eax
  8020ba:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8020bf:	a1 40 50 80 00       	mov    0x805040,%eax
  8020c4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8020ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cd:	83 c0 08             	add    $0x8,%eax
  8020d0:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d6:	83 c0 04             	add    $0x4,%eax
  8020d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020dc:	83 ea 08             	sub    $0x8,%edx
  8020df:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e7:	01 d0                	add    %edx,%eax
  8020e9:	83 e8 08             	sub    $0x8,%eax
  8020ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ef:	83 ea 08             	sub    $0x8,%edx
  8020f2:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8020f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8020fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802100:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802107:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80210b:	75 17                	jne    802124 <initialize_dynamic_allocator+0x19c>
  80210d:	83 ec 04             	sub    $0x4,%esp
  802110:	68 8c 44 80 00       	push   $0x80448c
  802115:	68 90 00 00 00       	push   $0x90
  80211a:	68 71 44 80 00       	push   $0x804471
  80211f:	e8 5e e1 ff ff       	call   800282 <_panic>
  802124:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80212a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80212d:	89 10                	mov    %edx,(%eax)
  80212f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802132:	8b 00                	mov    (%eax),%eax
  802134:	85 c0                	test   %eax,%eax
  802136:	74 0d                	je     802145 <initialize_dynamic_allocator+0x1bd>
  802138:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80213d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802140:	89 50 04             	mov    %edx,0x4(%eax)
  802143:	eb 08                	jmp    80214d <initialize_dynamic_allocator+0x1c5>
  802145:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802148:	a3 30 50 80 00       	mov    %eax,0x805030
  80214d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802150:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802155:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802158:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80215f:	a1 38 50 80 00       	mov    0x805038,%eax
  802164:	40                   	inc    %eax
  802165:	a3 38 50 80 00       	mov    %eax,0x805038
  80216a:	eb 07                	jmp    802173 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80216c:	90                   	nop
  80216d:	eb 04                	jmp    802173 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80216f:	90                   	nop
  802170:	eb 01                	jmp    802173 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802172:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802173:	c9                   	leave  
  802174:	c3                   	ret    

00802175 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802178:	8b 45 10             	mov    0x10(%ebp),%eax
  80217b:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80217e:	8b 45 08             	mov    0x8(%ebp),%eax
  802181:	8d 50 fc             	lea    -0x4(%eax),%edx
  802184:	8b 45 0c             	mov    0xc(%ebp),%eax
  802187:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	83 e8 04             	sub    $0x4,%eax
  80218f:	8b 00                	mov    (%eax),%eax
  802191:	83 e0 fe             	and    $0xfffffffe,%eax
  802194:	8d 50 f8             	lea    -0x8(%eax),%edx
  802197:	8b 45 08             	mov    0x8(%ebp),%eax
  80219a:	01 c2                	add    %eax,%edx
  80219c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80219f:	89 02                	mov    %eax,(%edx)
}
  8021a1:	90                   	nop
  8021a2:	5d                   	pop    %ebp
  8021a3:	c3                   	ret    

008021a4 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
  8021a7:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8021aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ad:	83 e0 01             	and    $0x1,%eax
  8021b0:	85 c0                	test   %eax,%eax
  8021b2:	74 03                	je     8021b7 <alloc_block_FF+0x13>
  8021b4:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8021b7:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8021bb:	77 07                	ja     8021c4 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8021bd:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8021c4:	a1 24 50 80 00       	mov    0x805024,%eax
  8021c9:	85 c0                	test   %eax,%eax
  8021cb:	75 73                	jne    802240 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	83 c0 10             	add    $0x10,%eax
  8021d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8021d6:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8021dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e3:	01 d0                	add    %edx,%eax
  8021e5:	48                   	dec    %eax
  8021e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8021e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8021f1:	f7 75 ec             	divl   -0x14(%ebp)
  8021f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021f7:	29 d0                	sub    %edx,%eax
  8021f9:	c1 e8 0c             	shr    $0xc,%eax
  8021fc:	83 ec 0c             	sub    $0xc,%esp
  8021ff:	50                   	push   %eax
  802200:	e8 d4 f0 ff ff       	call   8012d9 <sbrk>
  802205:	83 c4 10             	add    $0x10,%esp
  802208:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80220b:	83 ec 0c             	sub    $0xc,%esp
  80220e:	6a 00                	push   $0x0
  802210:	e8 c4 f0 ff ff       	call   8012d9 <sbrk>
  802215:	83 c4 10             	add    $0x10,%esp
  802218:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80221b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80221e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802221:	83 ec 08             	sub    $0x8,%esp
  802224:	50                   	push   %eax
  802225:	ff 75 e4             	pushl  -0x1c(%ebp)
  802228:	e8 5b fd ff ff       	call   801f88 <initialize_dynamic_allocator>
  80222d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802230:	83 ec 0c             	sub    $0xc,%esp
  802233:	68 af 44 80 00       	push   $0x8044af
  802238:	e8 02 e3 ff ff       	call   80053f <cprintf>
  80223d:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802240:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802244:	75 0a                	jne    802250 <alloc_block_FF+0xac>
	        return NULL;
  802246:	b8 00 00 00 00       	mov    $0x0,%eax
  80224b:	e9 0e 04 00 00       	jmp    80265e <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802250:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802257:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80225c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80225f:	e9 f3 02 00 00       	jmp    802557 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802264:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802267:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80226a:	83 ec 0c             	sub    $0xc,%esp
  80226d:	ff 75 bc             	pushl  -0x44(%ebp)
  802270:	e8 af fb ff ff       	call   801e24 <get_block_size>
  802275:	83 c4 10             	add    $0x10,%esp
  802278:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80227b:	8b 45 08             	mov    0x8(%ebp),%eax
  80227e:	83 c0 08             	add    $0x8,%eax
  802281:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802284:	0f 87 c5 02 00 00    	ja     80254f <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80228a:	8b 45 08             	mov    0x8(%ebp),%eax
  80228d:	83 c0 18             	add    $0x18,%eax
  802290:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802293:	0f 87 19 02 00 00    	ja     8024b2 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802299:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80229c:	2b 45 08             	sub    0x8(%ebp),%eax
  80229f:	83 e8 08             	sub    $0x8,%eax
  8022a2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	8d 50 08             	lea    0x8(%eax),%edx
  8022ab:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8022ae:	01 d0                	add    %edx,%eax
  8022b0:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8022b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b6:	83 c0 08             	add    $0x8,%eax
  8022b9:	83 ec 04             	sub    $0x4,%esp
  8022bc:	6a 01                	push   $0x1
  8022be:	50                   	push   %eax
  8022bf:	ff 75 bc             	pushl  -0x44(%ebp)
  8022c2:	e8 ae fe ff ff       	call   802175 <set_block_data>
  8022c7:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8022ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cd:	8b 40 04             	mov    0x4(%eax),%eax
  8022d0:	85 c0                	test   %eax,%eax
  8022d2:	75 68                	jne    80233c <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8022d4:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022d8:	75 17                	jne    8022f1 <alloc_block_FF+0x14d>
  8022da:	83 ec 04             	sub    $0x4,%esp
  8022dd:	68 8c 44 80 00       	push   $0x80448c
  8022e2:	68 d7 00 00 00       	push   $0xd7
  8022e7:	68 71 44 80 00       	push   $0x804471
  8022ec:	e8 91 df ff ff       	call   800282 <_panic>
  8022f1:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8022f7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022fa:	89 10                	mov    %edx,(%eax)
  8022fc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022ff:	8b 00                	mov    (%eax),%eax
  802301:	85 c0                	test   %eax,%eax
  802303:	74 0d                	je     802312 <alloc_block_FF+0x16e>
  802305:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80230a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80230d:	89 50 04             	mov    %edx,0x4(%eax)
  802310:	eb 08                	jmp    80231a <alloc_block_FF+0x176>
  802312:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802315:	a3 30 50 80 00       	mov    %eax,0x805030
  80231a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80231d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802322:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802325:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80232c:	a1 38 50 80 00       	mov    0x805038,%eax
  802331:	40                   	inc    %eax
  802332:	a3 38 50 80 00       	mov    %eax,0x805038
  802337:	e9 dc 00 00 00       	jmp    802418 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	8b 00                	mov    (%eax),%eax
  802341:	85 c0                	test   %eax,%eax
  802343:	75 65                	jne    8023aa <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802345:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802349:	75 17                	jne    802362 <alloc_block_FF+0x1be>
  80234b:	83 ec 04             	sub    $0x4,%esp
  80234e:	68 c0 44 80 00       	push   $0x8044c0
  802353:	68 db 00 00 00       	push   $0xdb
  802358:	68 71 44 80 00       	push   $0x804471
  80235d:	e8 20 df ff ff       	call   800282 <_panic>
  802362:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802368:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80236b:	89 50 04             	mov    %edx,0x4(%eax)
  80236e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802371:	8b 40 04             	mov    0x4(%eax),%eax
  802374:	85 c0                	test   %eax,%eax
  802376:	74 0c                	je     802384 <alloc_block_FF+0x1e0>
  802378:	a1 30 50 80 00       	mov    0x805030,%eax
  80237d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802380:	89 10                	mov    %edx,(%eax)
  802382:	eb 08                	jmp    80238c <alloc_block_FF+0x1e8>
  802384:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802387:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80238c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80238f:	a3 30 50 80 00       	mov    %eax,0x805030
  802394:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802397:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80239d:	a1 38 50 80 00       	mov    0x805038,%eax
  8023a2:	40                   	inc    %eax
  8023a3:	a3 38 50 80 00       	mov    %eax,0x805038
  8023a8:	eb 6e                	jmp    802418 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8023aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ae:	74 06                	je     8023b6 <alloc_block_FF+0x212>
  8023b0:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023b4:	75 17                	jne    8023cd <alloc_block_FF+0x229>
  8023b6:	83 ec 04             	sub    $0x4,%esp
  8023b9:	68 e4 44 80 00       	push   $0x8044e4
  8023be:	68 df 00 00 00       	push   $0xdf
  8023c3:	68 71 44 80 00       	push   $0x804471
  8023c8:	e8 b5 de ff ff       	call   800282 <_panic>
  8023cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d0:	8b 10                	mov    (%eax),%edx
  8023d2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023d5:	89 10                	mov    %edx,(%eax)
  8023d7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023da:	8b 00                	mov    (%eax),%eax
  8023dc:	85 c0                	test   %eax,%eax
  8023de:	74 0b                	je     8023eb <alloc_block_FF+0x247>
  8023e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e3:	8b 00                	mov    (%eax),%eax
  8023e5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023e8:	89 50 04             	mov    %edx,0x4(%eax)
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023f1:	89 10                	mov    %edx,(%eax)
  8023f3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f9:	89 50 04             	mov    %edx,0x4(%eax)
  8023fc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ff:	8b 00                	mov    (%eax),%eax
  802401:	85 c0                	test   %eax,%eax
  802403:	75 08                	jne    80240d <alloc_block_FF+0x269>
  802405:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802408:	a3 30 50 80 00       	mov    %eax,0x805030
  80240d:	a1 38 50 80 00       	mov    0x805038,%eax
  802412:	40                   	inc    %eax
  802413:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802418:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241c:	75 17                	jne    802435 <alloc_block_FF+0x291>
  80241e:	83 ec 04             	sub    $0x4,%esp
  802421:	68 53 44 80 00       	push   $0x804453
  802426:	68 e1 00 00 00       	push   $0xe1
  80242b:	68 71 44 80 00       	push   $0x804471
  802430:	e8 4d de ff ff       	call   800282 <_panic>
  802435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802438:	8b 00                	mov    (%eax),%eax
  80243a:	85 c0                	test   %eax,%eax
  80243c:	74 10                	je     80244e <alloc_block_FF+0x2aa>
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	8b 00                	mov    (%eax),%eax
  802443:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802446:	8b 52 04             	mov    0x4(%edx),%edx
  802449:	89 50 04             	mov    %edx,0x4(%eax)
  80244c:	eb 0b                	jmp    802459 <alloc_block_FF+0x2b5>
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802451:	8b 40 04             	mov    0x4(%eax),%eax
  802454:	a3 30 50 80 00       	mov    %eax,0x805030
  802459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245c:	8b 40 04             	mov    0x4(%eax),%eax
  80245f:	85 c0                	test   %eax,%eax
  802461:	74 0f                	je     802472 <alloc_block_FF+0x2ce>
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	8b 40 04             	mov    0x4(%eax),%eax
  802469:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246c:	8b 12                	mov    (%edx),%edx
  80246e:	89 10                	mov    %edx,(%eax)
  802470:	eb 0a                	jmp    80247c <alloc_block_FF+0x2d8>
  802472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802475:	8b 00                	mov    (%eax),%eax
  802477:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802488:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80248f:	a1 38 50 80 00       	mov    0x805038,%eax
  802494:	48                   	dec    %eax
  802495:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80249a:	83 ec 04             	sub    $0x4,%esp
  80249d:	6a 00                	push   $0x0
  80249f:	ff 75 b4             	pushl  -0x4c(%ebp)
  8024a2:	ff 75 b0             	pushl  -0x50(%ebp)
  8024a5:	e8 cb fc ff ff       	call   802175 <set_block_data>
  8024aa:	83 c4 10             	add    $0x10,%esp
  8024ad:	e9 95 00 00 00       	jmp    802547 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8024b2:	83 ec 04             	sub    $0x4,%esp
  8024b5:	6a 01                	push   $0x1
  8024b7:	ff 75 b8             	pushl  -0x48(%ebp)
  8024ba:	ff 75 bc             	pushl  -0x44(%ebp)
  8024bd:	e8 b3 fc ff ff       	call   802175 <set_block_data>
  8024c2:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8024c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c9:	75 17                	jne    8024e2 <alloc_block_FF+0x33e>
  8024cb:	83 ec 04             	sub    $0x4,%esp
  8024ce:	68 53 44 80 00       	push   $0x804453
  8024d3:	68 e8 00 00 00       	push   $0xe8
  8024d8:	68 71 44 80 00       	push   $0x804471
  8024dd:	e8 a0 dd ff ff       	call   800282 <_panic>
  8024e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e5:	8b 00                	mov    (%eax),%eax
  8024e7:	85 c0                	test   %eax,%eax
  8024e9:	74 10                	je     8024fb <alloc_block_FF+0x357>
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	8b 00                	mov    (%eax),%eax
  8024f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f3:	8b 52 04             	mov    0x4(%edx),%edx
  8024f6:	89 50 04             	mov    %edx,0x4(%eax)
  8024f9:	eb 0b                	jmp    802506 <alloc_block_FF+0x362>
  8024fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fe:	8b 40 04             	mov    0x4(%eax),%eax
  802501:	a3 30 50 80 00       	mov    %eax,0x805030
  802506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802509:	8b 40 04             	mov    0x4(%eax),%eax
  80250c:	85 c0                	test   %eax,%eax
  80250e:	74 0f                	je     80251f <alloc_block_FF+0x37b>
  802510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802513:	8b 40 04             	mov    0x4(%eax),%eax
  802516:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802519:	8b 12                	mov    (%edx),%edx
  80251b:	89 10                	mov    %edx,(%eax)
  80251d:	eb 0a                	jmp    802529 <alloc_block_FF+0x385>
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	8b 00                	mov    (%eax),%eax
  802524:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80253c:	a1 38 50 80 00       	mov    0x805038,%eax
  802541:	48                   	dec    %eax
  802542:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802547:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80254a:	e9 0f 01 00 00       	jmp    80265e <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80254f:	a1 34 50 80 00       	mov    0x805034,%eax
  802554:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802557:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255b:	74 07                	je     802564 <alloc_block_FF+0x3c0>
  80255d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802560:	8b 00                	mov    (%eax),%eax
  802562:	eb 05                	jmp    802569 <alloc_block_FF+0x3c5>
  802564:	b8 00 00 00 00       	mov    $0x0,%eax
  802569:	a3 34 50 80 00       	mov    %eax,0x805034
  80256e:	a1 34 50 80 00       	mov    0x805034,%eax
  802573:	85 c0                	test   %eax,%eax
  802575:	0f 85 e9 fc ff ff    	jne    802264 <alloc_block_FF+0xc0>
  80257b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257f:	0f 85 df fc ff ff    	jne    802264 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802585:	8b 45 08             	mov    0x8(%ebp),%eax
  802588:	83 c0 08             	add    $0x8,%eax
  80258b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80258e:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802595:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802598:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80259b:	01 d0                	add    %edx,%eax
  80259d:	48                   	dec    %eax
  80259e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8025a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8025a9:	f7 75 d8             	divl   -0x28(%ebp)
  8025ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025af:	29 d0                	sub    %edx,%eax
  8025b1:	c1 e8 0c             	shr    $0xc,%eax
  8025b4:	83 ec 0c             	sub    $0xc,%esp
  8025b7:	50                   	push   %eax
  8025b8:	e8 1c ed ff ff       	call   8012d9 <sbrk>
  8025bd:	83 c4 10             	add    $0x10,%esp
  8025c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8025c3:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8025c7:	75 0a                	jne    8025d3 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8025c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ce:	e9 8b 00 00 00       	jmp    80265e <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8025d3:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8025da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025dd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025e0:	01 d0                	add    %edx,%eax
  8025e2:	48                   	dec    %eax
  8025e3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8025e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8025ee:	f7 75 cc             	divl   -0x34(%ebp)
  8025f1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025f4:	29 d0                	sub    %edx,%eax
  8025f6:	8d 50 fc             	lea    -0x4(%eax),%edx
  8025f9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025fc:	01 d0                	add    %edx,%eax
  8025fe:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802603:	a1 40 50 80 00       	mov    0x805040,%eax
  802608:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80260e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802615:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802618:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80261b:	01 d0                	add    %edx,%eax
  80261d:	48                   	dec    %eax
  80261e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802621:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802624:	ba 00 00 00 00       	mov    $0x0,%edx
  802629:	f7 75 c4             	divl   -0x3c(%ebp)
  80262c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80262f:	29 d0                	sub    %edx,%eax
  802631:	83 ec 04             	sub    $0x4,%esp
  802634:	6a 01                	push   $0x1
  802636:	50                   	push   %eax
  802637:	ff 75 d0             	pushl  -0x30(%ebp)
  80263a:	e8 36 fb ff ff       	call   802175 <set_block_data>
  80263f:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802642:	83 ec 0c             	sub    $0xc,%esp
  802645:	ff 75 d0             	pushl  -0x30(%ebp)
  802648:	e8 1b 0a 00 00       	call   803068 <free_block>
  80264d:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802650:	83 ec 0c             	sub    $0xc,%esp
  802653:	ff 75 08             	pushl  0x8(%ebp)
  802656:	e8 49 fb ff ff       	call   8021a4 <alloc_block_FF>
  80265b:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80265e:	c9                   	leave  
  80265f:	c3                   	ret    

00802660 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802660:	55                   	push   %ebp
  802661:	89 e5                	mov    %esp,%ebp
  802663:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802666:	8b 45 08             	mov    0x8(%ebp),%eax
  802669:	83 e0 01             	and    $0x1,%eax
  80266c:	85 c0                	test   %eax,%eax
  80266e:	74 03                	je     802673 <alloc_block_BF+0x13>
  802670:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802673:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802677:	77 07                	ja     802680 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802679:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802680:	a1 24 50 80 00       	mov    0x805024,%eax
  802685:	85 c0                	test   %eax,%eax
  802687:	75 73                	jne    8026fc <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802689:	8b 45 08             	mov    0x8(%ebp),%eax
  80268c:	83 c0 10             	add    $0x10,%eax
  80268f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802692:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802699:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80269c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80269f:	01 d0                	add    %edx,%eax
  8026a1:	48                   	dec    %eax
  8026a2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8026a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ad:	f7 75 e0             	divl   -0x20(%ebp)
  8026b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026b3:	29 d0                	sub    %edx,%eax
  8026b5:	c1 e8 0c             	shr    $0xc,%eax
  8026b8:	83 ec 0c             	sub    $0xc,%esp
  8026bb:	50                   	push   %eax
  8026bc:	e8 18 ec ff ff       	call   8012d9 <sbrk>
  8026c1:	83 c4 10             	add    $0x10,%esp
  8026c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8026c7:	83 ec 0c             	sub    $0xc,%esp
  8026ca:	6a 00                	push   $0x0
  8026cc:	e8 08 ec ff ff       	call   8012d9 <sbrk>
  8026d1:	83 c4 10             	add    $0x10,%esp
  8026d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8026d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026da:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8026dd:	83 ec 08             	sub    $0x8,%esp
  8026e0:	50                   	push   %eax
  8026e1:	ff 75 d8             	pushl  -0x28(%ebp)
  8026e4:	e8 9f f8 ff ff       	call   801f88 <initialize_dynamic_allocator>
  8026e9:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8026ec:	83 ec 0c             	sub    $0xc,%esp
  8026ef:	68 af 44 80 00       	push   $0x8044af
  8026f4:	e8 46 de ff ff       	call   80053f <cprintf>
  8026f9:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8026fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802703:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80270a:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802711:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802718:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80271d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802720:	e9 1d 01 00 00       	jmp    802842 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802728:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80272b:	83 ec 0c             	sub    $0xc,%esp
  80272e:	ff 75 a8             	pushl  -0x58(%ebp)
  802731:	e8 ee f6 ff ff       	call   801e24 <get_block_size>
  802736:	83 c4 10             	add    $0x10,%esp
  802739:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80273c:	8b 45 08             	mov    0x8(%ebp),%eax
  80273f:	83 c0 08             	add    $0x8,%eax
  802742:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802745:	0f 87 ef 00 00 00    	ja     80283a <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80274b:	8b 45 08             	mov    0x8(%ebp),%eax
  80274e:	83 c0 18             	add    $0x18,%eax
  802751:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802754:	77 1d                	ja     802773 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802756:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802759:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80275c:	0f 86 d8 00 00 00    	jbe    80283a <alloc_block_BF+0x1da>
				{
					best_va = va;
  802762:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802765:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802768:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80276b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80276e:	e9 c7 00 00 00       	jmp    80283a <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802773:	8b 45 08             	mov    0x8(%ebp),%eax
  802776:	83 c0 08             	add    $0x8,%eax
  802779:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80277c:	0f 85 9d 00 00 00    	jne    80281f <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802782:	83 ec 04             	sub    $0x4,%esp
  802785:	6a 01                	push   $0x1
  802787:	ff 75 a4             	pushl  -0x5c(%ebp)
  80278a:	ff 75 a8             	pushl  -0x58(%ebp)
  80278d:	e8 e3 f9 ff ff       	call   802175 <set_block_data>
  802792:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802795:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802799:	75 17                	jne    8027b2 <alloc_block_BF+0x152>
  80279b:	83 ec 04             	sub    $0x4,%esp
  80279e:	68 53 44 80 00       	push   $0x804453
  8027a3:	68 2c 01 00 00       	push   $0x12c
  8027a8:	68 71 44 80 00       	push   $0x804471
  8027ad:	e8 d0 da ff ff       	call   800282 <_panic>
  8027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b5:	8b 00                	mov    (%eax),%eax
  8027b7:	85 c0                	test   %eax,%eax
  8027b9:	74 10                	je     8027cb <alloc_block_BF+0x16b>
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	8b 00                	mov    (%eax),%eax
  8027c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c3:	8b 52 04             	mov    0x4(%edx),%edx
  8027c6:	89 50 04             	mov    %edx,0x4(%eax)
  8027c9:	eb 0b                	jmp    8027d6 <alloc_block_BF+0x176>
  8027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ce:	8b 40 04             	mov    0x4(%eax),%eax
  8027d1:	a3 30 50 80 00       	mov    %eax,0x805030
  8027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d9:	8b 40 04             	mov    0x4(%eax),%eax
  8027dc:	85 c0                	test   %eax,%eax
  8027de:	74 0f                	je     8027ef <alloc_block_BF+0x18f>
  8027e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e3:	8b 40 04             	mov    0x4(%eax),%eax
  8027e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e9:	8b 12                	mov    (%edx),%edx
  8027eb:	89 10                	mov    %edx,(%eax)
  8027ed:	eb 0a                	jmp    8027f9 <alloc_block_BF+0x199>
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	8b 00                	mov    (%eax),%eax
  8027f4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802805:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80280c:	a1 38 50 80 00       	mov    0x805038,%eax
  802811:	48                   	dec    %eax
  802812:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802817:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80281a:	e9 24 04 00 00       	jmp    802c43 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80281f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802822:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802825:	76 13                	jbe    80283a <alloc_block_BF+0x1da>
					{
						internal = 1;
  802827:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80282e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802831:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802834:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802837:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80283a:	a1 34 50 80 00       	mov    0x805034,%eax
  80283f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802842:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802846:	74 07                	je     80284f <alloc_block_BF+0x1ef>
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	8b 00                	mov    (%eax),%eax
  80284d:	eb 05                	jmp    802854 <alloc_block_BF+0x1f4>
  80284f:	b8 00 00 00 00       	mov    $0x0,%eax
  802854:	a3 34 50 80 00       	mov    %eax,0x805034
  802859:	a1 34 50 80 00       	mov    0x805034,%eax
  80285e:	85 c0                	test   %eax,%eax
  802860:	0f 85 bf fe ff ff    	jne    802725 <alloc_block_BF+0xc5>
  802866:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286a:	0f 85 b5 fe ff ff    	jne    802725 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802870:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802874:	0f 84 26 02 00 00    	je     802aa0 <alloc_block_BF+0x440>
  80287a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80287e:	0f 85 1c 02 00 00    	jne    802aa0 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802884:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802887:	2b 45 08             	sub    0x8(%ebp),%eax
  80288a:	83 e8 08             	sub    $0x8,%eax
  80288d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802890:	8b 45 08             	mov    0x8(%ebp),%eax
  802893:	8d 50 08             	lea    0x8(%eax),%edx
  802896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802899:	01 d0                	add    %edx,%eax
  80289b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80289e:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a1:	83 c0 08             	add    $0x8,%eax
  8028a4:	83 ec 04             	sub    $0x4,%esp
  8028a7:	6a 01                	push   $0x1
  8028a9:	50                   	push   %eax
  8028aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8028ad:	e8 c3 f8 ff ff       	call   802175 <set_block_data>
  8028b2:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8028b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b8:	8b 40 04             	mov    0x4(%eax),%eax
  8028bb:	85 c0                	test   %eax,%eax
  8028bd:	75 68                	jne    802927 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028bf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028c3:	75 17                	jne    8028dc <alloc_block_BF+0x27c>
  8028c5:	83 ec 04             	sub    $0x4,%esp
  8028c8:	68 8c 44 80 00       	push   $0x80448c
  8028cd:	68 45 01 00 00       	push   $0x145
  8028d2:	68 71 44 80 00       	push   $0x804471
  8028d7:	e8 a6 d9 ff ff       	call   800282 <_panic>
  8028dc:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8028e2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028e5:	89 10                	mov    %edx,(%eax)
  8028e7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ea:	8b 00                	mov    (%eax),%eax
  8028ec:	85 c0                	test   %eax,%eax
  8028ee:	74 0d                	je     8028fd <alloc_block_BF+0x29d>
  8028f0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8028f5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028f8:	89 50 04             	mov    %edx,0x4(%eax)
  8028fb:	eb 08                	jmp    802905 <alloc_block_BF+0x2a5>
  8028fd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802900:	a3 30 50 80 00       	mov    %eax,0x805030
  802905:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802908:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80290d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802910:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802917:	a1 38 50 80 00       	mov    0x805038,%eax
  80291c:	40                   	inc    %eax
  80291d:	a3 38 50 80 00       	mov    %eax,0x805038
  802922:	e9 dc 00 00 00       	jmp    802a03 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802927:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292a:	8b 00                	mov    (%eax),%eax
  80292c:	85 c0                	test   %eax,%eax
  80292e:	75 65                	jne    802995 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802930:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802934:	75 17                	jne    80294d <alloc_block_BF+0x2ed>
  802936:	83 ec 04             	sub    $0x4,%esp
  802939:	68 c0 44 80 00       	push   $0x8044c0
  80293e:	68 4a 01 00 00       	push   $0x14a
  802943:	68 71 44 80 00       	push   $0x804471
  802948:	e8 35 d9 ff ff       	call   800282 <_panic>
  80294d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802953:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802956:	89 50 04             	mov    %edx,0x4(%eax)
  802959:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80295c:	8b 40 04             	mov    0x4(%eax),%eax
  80295f:	85 c0                	test   %eax,%eax
  802961:	74 0c                	je     80296f <alloc_block_BF+0x30f>
  802963:	a1 30 50 80 00       	mov    0x805030,%eax
  802968:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80296b:	89 10                	mov    %edx,(%eax)
  80296d:	eb 08                	jmp    802977 <alloc_block_BF+0x317>
  80296f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802972:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802977:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80297a:	a3 30 50 80 00       	mov    %eax,0x805030
  80297f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802982:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802988:	a1 38 50 80 00       	mov    0x805038,%eax
  80298d:	40                   	inc    %eax
  80298e:	a3 38 50 80 00       	mov    %eax,0x805038
  802993:	eb 6e                	jmp    802a03 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802995:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802999:	74 06                	je     8029a1 <alloc_block_BF+0x341>
  80299b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80299f:	75 17                	jne    8029b8 <alloc_block_BF+0x358>
  8029a1:	83 ec 04             	sub    $0x4,%esp
  8029a4:	68 e4 44 80 00       	push   $0x8044e4
  8029a9:	68 4f 01 00 00       	push   $0x14f
  8029ae:	68 71 44 80 00       	push   $0x804471
  8029b3:	e8 ca d8 ff ff       	call   800282 <_panic>
  8029b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bb:	8b 10                	mov    (%eax),%edx
  8029bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029c0:	89 10                	mov    %edx,(%eax)
  8029c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029c5:	8b 00                	mov    (%eax),%eax
  8029c7:	85 c0                	test   %eax,%eax
  8029c9:	74 0b                	je     8029d6 <alloc_block_BF+0x376>
  8029cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ce:	8b 00                	mov    (%eax),%eax
  8029d0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029d3:	89 50 04             	mov    %edx,0x4(%eax)
  8029d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029dc:	89 10                	mov    %edx,(%eax)
  8029de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029e4:	89 50 04             	mov    %edx,0x4(%eax)
  8029e7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ea:	8b 00                	mov    (%eax),%eax
  8029ec:	85 c0                	test   %eax,%eax
  8029ee:	75 08                	jne    8029f8 <alloc_block_BF+0x398>
  8029f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029f3:	a3 30 50 80 00       	mov    %eax,0x805030
  8029f8:	a1 38 50 80 00       	mov    0x805038,%eax
  8029fd:	40                   	inc    %eax
  8029fe:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802a03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a07:	75 17                	jne    802a20 <alloc_block_BF+0x3c0>
  802a09:	83 ec 04             	sub    $0x4,%esp
  802a0c:	68 53 44 80 00       	push   $0x804453
  802a11:	68 51 01 00 00       	push   $0x151
  802a16:	68 71 44 80 00       	push   $0x804471
  802a1b:	e8 62 d8 ff ff       	call   800282 <_panic>
  802a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a23:	8b 00                	mov    (%eax),%eax
  802a25:	85 c0                	test   %eax,%eax
  802a27:	74 10                	je     802a39 <alloc_block_BF+0x3d9>
  802a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2c:	8b 00                	mov    (%eax),%eax
  802a2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a31:	8b 52 04             	mov    0x4(%edx),%edx
  802a34:	89 50 04             	mov    %edx,0x4(%eax)
  802a37:	eb 0b                	jmp    802a44 <alloc_block_BF+0x3e4>
  802a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3c:	8b 40 04             	mov    0x4(%eax),%eax
  802a3f:	a3 30 50 80 00       	mov    %eax,0x805030
  802a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a47:	8b 40 04             	mov    0x4(%eax),%eax
  802a4a:	85 c0                	test   %eax,%eax
  802a4c:	74 0f                	je     802a5d <alloc_block_BF+0x3fd>
  802a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a51:	8b 40 04             	mov    0x4(%eax),%eax
  802a54:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a57:	8b 12                	mov    (%edx),%edx
  802a59:	89 10                	mov    %edx,(%eax)
  802a5b:	eb 0a                	jmp    802a67 <alloc_block_BF+0x407>
  802a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a60:	8b 00                	mov    (%eax),%eax
  802a62:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a7a:	a1 38 50 80 00       	mov    0x805038,%eax
  802a7f:	48                   	dec    %eax
  802a80:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802a85:	83 ec 04             	sub    $0x4,%esp
  802a88:	6a 00                	push   $0x0
  802a8a:	ff 75 d0             	pushl  -0x30(%ebp)
  802a8d:	ff 75 cc             	pushl  -0x34(%ebp)
  802a90:	e8 e0 f6 ff ff       	call   802175 <set_block_data>
  802a95:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9b:	e9 a3 01 00 00       	jmp    802c43 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802aa0:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802aa4:	0f 85 9d 00 00 00    	jne    802b47 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802aaa:	83 ec 04             	sub    $0x4,%esp
  802aad:	6a 01                	push   $0x1
  802aaf:	ff 75 ec             	pushl  -0x14(%ebp)
  802ab2:	ff 75 f0             	pushl  -0x10(%ebp)
  802ab5:	e8 bb f6 ff ff       	call   802175 <set_block_data>
  802aba:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802abd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ac1:	75 17                	jne    802ada <alloc_block_BF+0x47a>
  802ac3:	83 ec 04             	sub    $0x4,%esp
  802ac6:	68 53 44 80 00       	push   $0x804453
  802acb:	68 58 01 00 00       	push   $0x158
  802ad0:	68 71 44 80 00       	push   $0x804471
  802ad5:	e8 a8 d7 ff ff       	call   800282 <_panic>
  802ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802add:	8b 00                	mov    (%eax),%eax
  802adf:	85 c0                	test   %eax,%eax
  802ae1:	74 10                	je     802af3 <alloc_block_BF+0x493>
  802ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae6:	8b 00                	mov    (%eax),%eax
  802ae8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aeb:	8b 52 04             	mov    0x4(%edx),%edx
  802aee:	89 50 04             	mov    %edx,0x4(%eax)
  802af1:	eb 0b                	jmp    802afe <alloc_block_BF+0x49e>
  802af3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af6:	8b 40 04             	mov    0x4(%eax),%eax
  802af9:	a3 30 50 80 00       	mov    %eax,0x805030
  802afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b01:	8b 40 04             	mov    0x4(%eax),%eax
  802b04:	85 c0                	test   %eax,%eax
  802b06:	74 0f                	je     802b17 <alloc_block_BF+0x4b7>
  802b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0b:	8b 40 04             	mov    0x4(%eax),%eax
  802b0e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b11:	8b 12                	mov    (%edx),%edx
  802b13:	89 10                	mov    %edx,(%eax)
  802b15:	eb 0a                	jmp    802b21 <alloc_block_BF+0x4c1>
  802b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1a:	8b 00                	mov    (%eax),%eax
  802b1c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b34:	a1 38 50 80 00       	mov    0x805038,%eax
  802b39:	48                   	dec    %eax
  802b3a:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b42:	e9 fc 00 00 00       	jmp    802c43 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802b47:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4a:	83 c0 08             	add    $0x8,%eax
  802b4d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b50:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b57:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b5a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b5d:	01 d0                	add    %edx,%eax
  802b5f:	48                   	dec    %eax
  802b60:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b63:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b66:	ba 00 00 00 00       	mov    $0x0,%edx
  802b6b:	f7 75 c4             	divl   -0x3c(%ebp)
  802b6e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b71:	29 d0                	sub    %edx,%eax
  802b73:	c1 e8 0c             	shr    $0xc,%eax
  802b76:	83 ec 0c             	sub    $0xc,%esp
  802b79:	50                   	push   %eax
  802b7a:	e8 5a e7 ff ff       	call   8012d9 <sbrk>
  802b7f:	83 c4 10             	add    $0x10,%esp
  802b82:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802b85:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802b89:	75 0a                	jne    802b95 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802b8b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b90:	e9 ae 00 00 00       	jmp    802c43 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b95:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802b9c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b9f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802ba2:	01 d0                	add    %edx,%eax
  802ba4:	48                   	dec    %eax
  802ba5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802ba8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bab:	ba 00 00 00 00       	mov    $0x0,%edx
  802bb0:	f7 75 b8             	divl   -0x48(%ebp)
  802bb3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bb6:	29 d0                	sub    %edx,%eax
  802bb8:	8d 50 fc             	lea    -0x4(%eax),%edx
  802bbb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802bbe:	01 d0                	add    %edx,%eax
  802bc0:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802bc5:	a1 40 50 80 00       	mov    0x805040,%eax
  802bca:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802bd0:	83 ec 0c             	sub    $0xc,%esp
  802bd3:	68 18 45 80 00       	push   $0x804518
  802bd8:	e8 62 d9 ff ff       	call   80053f <cprintf>
  802bdd:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802be0:	83 ec 08             	sub    $0x8,%esp
  802be3:	ff 75 bc             	pushl  -0x44(%ebp)
  802be6:	68 1d 45 80 00       	push   $0x80451d
  802beb:	e8 4f d9 ff ff       	call   80053f <cprintf>
  802bf0:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802bf3:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802bfa:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bfd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c00:	01 d0                	add    %edx,%eax
  802c02:	48                   	dec    %eax
  802c03:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802c06:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c09:	ba 00 00 00 00       	mov    $0x0,%edx
  802c0e:	f7 75 b0             	divl   -0x50(%ebp)
  802c11:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c14:	29 d0                	sub    %edx,%eax
  802c16:	83 ec 04             	sub    $0x4,%esp
  802c19:	6a 01                	push   $0x1
  802c1b:	50                   	push   %eax
  802c1c:	ff 75 bc             	pushl  -0x44(%ebp)
  802c1f:	e8 51 f5 ff ff       	call   802175 <set_block_data>
  802c24:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802c27:	83 ec 0c             	sub    $0xc,%esp
  802c2a:	ff 75 bc             	pushl  -0x44(%ebp)
  802c2d:	e8 36 04 00 00       	call   803068 <free_block>
  802c32:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802c35:	83 ec 0c             	sub    $0xc,%esp
  802c38:	ff 75 08             	pushl  0x8(%ebp)
  802c3b:	e8 20 fa ff ff       	call   802660 <alloc_block_BF>
  802c40:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802c43:	c9                   	leave  
  802c44:	c3                   	ret    

00802c45 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802c45:	55                   	push   %ebp
  802c46:	89 e5                	mov    %esp,%ebp
  802c48:	53                   	push   %ebx
  802c49:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802c4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c53:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802c5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c5e:	74 1e                	je     802c7e <merging+0x39>
  802c60:	ff 75 08             	pushl  0x8(%ebp)
  802c63:	e8 bc f1 ff ff       	call   801e24 <get_block_size>
  802c68:	83 c4 04             	add    $0x4,%esp
  802c6b:	89 c2                	mov    %eax,%edx
  802c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c70:	01 d0                	add    %edx,%eax
  802c72:	3b 45 10             	cmp    0x10(%ebp),%eax
  802c75:	75 07                	jne    802c7e <merging+0x39>
		prev_is_free = 1;
  802c77:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802c7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c82:	74 1e                	je     802ca2 <merging+0x5d>
  802c84:	ff 75 10             	pushl  0x10(%ebp)
  802c87:	e8 98 f1 ff ff       	call   801e24 <get_block_size>
  802c8c:	83 c4 04             	add    $0x4,%esp
  802c8f:	89 c2                	mov    %eax,%edx
  802c91:	8b 45 10             	mov    0x10(%ebp),%eax
  802c94:	01 d0                	add    %edx,%eax
  802c96:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c99:	75 07                	jne    802ca2 <merging+0x5d>
		next_is_free = 1;
  802c9b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802ca2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca6:	0f 84 cc 00 00 00    	je     802d78 <merging+0x133>
  802cac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cb0:	0f 84 c2 00 00 00    	je     802d78 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802cb6:	ff 75 08             	pushl  0x8(%ebp)
  802cb9:	e8 66 f1 ff ff       	call   801e24 <get_block_size>
  802cbe:	83 c4 04             	add    $0x4,%esp
  802cc1:	89 c3                	mov    %eax,%ebx
  802cc3:	ff 75 10             	pushl  0x10(%ebp)
  802cc6:	e8 59 f1 ff ff       	call   801e24 <get_block_size>
  802ccb:	83 c4 04             	add    $0x4,%esp
  802cce:	01 c3                	add    %eax,%ebx
  802cd0:	ff 75 0c             	pushl  0xc(%ebp)
  802cd3:	e8 4c f1 ff ff       	call   801e24 <get_block_size>
  802cd8:	83 c4 04             	add    $0x4,%esp
  802cdb:	01 d8                	add    %ebx,%eax
  802cdd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ce0:	6a 00                	push   $0x0
  802ce2:	ff 75 ec             	pushl  -0x14(%ebp)
  802ce5:	ff 75 08             	pushl  0x8(%ebp)
  802ce8:	e8 88 f4 ff ff       	call   802175 <set_block_data>
  802ced:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802cf0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cf4:	75 17                	jne    802d0d <merging+0xc8>
  802cf6:	83 ec 04             	sub    $0x4,%esp
  802cf9:	68 53 44 80 00       	push   $0x804453
  802cfe:	68 7d 01 00 00       	push   $0x17d
  802d03:	68 71 44 80 00       	push   $0x804471
  802d08:	e8 75 d5 ff ff       	call   800282 <_panic>
  802d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d10:	8b 00                	mov    (%eax),%eax
  802d12:	85 c0                	test   %eax,%eax
  802d14:	74 10                	je     802d26 <merging+0xe1>
  802d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d19:	8b 00                	mov    (%eax),%eax
  802d1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d1e:	8b 52 04             	mov    0x4(%edx),%edx
  802d21:	89 50 04             	mov    %edx,0x4(%eax)
  802d24:	eb 0b                	jmp    802d31 <merging+0xec>
  802d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d29:	8b 40 04             	mov    0x4(%eax),%eax
  802d2c:	a3 30 50 80 00       	mov    %eax,0x805030
  802d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d34:	8b 40 04             	mov    0x4(%eax),%eax
  802d37:	85 c0                	test   %eax,%eax
  802d39:	74 0f                	je     802d4a <merging+0x105>
  802d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d3e:	8b 40 04             	mov    0x4(%eax),%eax
  802d41:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d44:	8b 12                	mov    (%edx),%edx
  802d46:	89 10                	mov    %edx,(%eax)
  802d48:	eb 0a                	jmp    802d54 <merging+0x10f>
  802d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d4d:	8b 00                	mov    (%eax),%eax
  802d4f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d67:	a1 38 50 80 00       	mov    0x805038,%eax
  802d6c:	48                   	dec    %eax
  802d6d:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802d72:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d73:	e9 ea 02 00 00       	jmp    803062 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802d78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d7c:	74 3b                	je     802db9 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802d7e:	83 ec 0c             	sub    $0xc,%esp
  802d81:	ff 75 08             	pushl  0x8(%ebp)
  802d84:	e8 9b f0 ff ff       	call   801e24 <get_block_size>
  802d89:	83 c4 10             	add    $0x10,%esp
  802d8c:	89 c3                	mov    %eax,%ebx
  802d8e:	83 ec 0c             	sub    $0xc,%esp
  802d91:	ff 75 10             	pushl  0x10(%ebp)
  802d94:	e8 8b f0 ff ff       	call   801e24 <get_block_size>
  802d99:	83 c4 10             	add    $0x10,%esp
  802d9c:	01 d8                	add    %ebx,%eax
  802d9e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802da1:	83 ec 04             	sub    $0x4,%esp
  802da4:	6a 00                	push   $0x0
  802da6:	ff 75 e8             	pushl  -0x18(%ebp)
  802da9:	ff 75 08             	pushl  0x8(%ebp)
  802dac:	e8 c4 f3 ff ff       	call   802175 <set_block_data>
  802db1:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802db4:	e9 a9 02 00 00       	jmp    803062 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802db9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dbd:	0f 84 2d 01 00 00    	je     802ef0 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802dc3:	83 ec 0c             	sub    $0xc,%esp
  802dc6:	ff 75 10             	pushl  0x10(%ebp)
  802dc9:	e8 56 f0 ff ff       	call   801e24 <get_block_size>
  802dce:	83 c4 10             	add    $0x10,%esp
  802dd1:	89 c3                	mov    %eax,%ebx
  802dd3:	83 ec 0c             	sub    $0xc,%esp
  802dd6:	ff 75 0c             	pushl  0xc(%ebp)
  802dd9:	e8 46 f0 ff ff       	call   801e24 <get_block_size>
  802dde:	83 c4 10             	add    $0x10,%esp
  802de1:	01 d8                	add    %ebx,%eax
  802de3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802de6:	83 ec 04             	sub    $0x4,%esp
  802de9:	6a 00                	push   $0x0
  802deb:	ff 75 e4             	pushl  -0x1c(%ebp)
  802dee:	ff 75 10             	pushl  0x10(%ebp)
  802df1:	e8 7f f3 ff ff       	call   802175 <set_block_data>
  802df6:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802df9:	8b 45 10             	mov    0x10(%ebp),%eax
  802dfc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802dff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e03:	74 06                	je     802e0b <merging+0x1c6>
  802e05:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e09:	75 17                	jne    802e22 <merging+0x1dd>
  802e0b:	83 ec 04             	sub    $0x4,%esp
  802e0e:	68 2c 45 80 00       	push   $0x80452c
  802e13:	68 8d 01 00 00       	push   $0x18d
  802e18:	68 71 44 80 00       	push   $0x804471
  802e1d:	e8 60 d4 ff ff       	call   800282 <_panic>
  802e22:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e25:	8b 50 04             	mov    0x4(%eax),%edx
  802e28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e2b:	89 50 04             	mov    %edx,0x4(%eax)
  802e2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e31:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e34:	89 10                	mov    %edx,(%eax)
  802e36:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e39:	8b 40 04             	mov    0x4(%eax),%eax
  802e3c:	85 c0                	test   %eax,%eax
  802e3e:	74 0d                	je     802e4d <merging+0x208>
  802e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e43:	8b 40 04             	mov    0x4(%eax),%eax
  802e46:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e49:	89 10                	mov    %edx,(%eax)
  802e4b:	eb 08                	jmp    802e55 <merging+0x210>
  802e4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e50:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e55:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e58:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e5b:	89 50 04             	mov    %edx,0x4(%eax)
  802e5e:	a1 38 50 80 00       	mov    0x805038,%eax
  802e63:	40                   	inc    %eax
  802e64:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802e69:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e6d:	75 17                	jne    802e86 <merging+0x241>
  802e6f:	83 ec 04             	sub    $0x4,%esp
  802e72:	68 53 44 80 00       	push   $0x804453
  802e77:	68 8e 01 00 00       	push   $0x18e
  802e7c:	68 71 44 80 00       	push   $0x804471
  802e81:	e8 fc d3 ff ff       	call   800282 <_panic>
  802e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e89:	8b 00                	mov    (%eax),%eax
  802e8b:	85 c0                	test   %eax,%eax
  802e8d:	74 10                	je     802e9f <merging+0x25a>
  802e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e92:	8b 00                	mov    (%eax),%eax
  802e94:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e97:	8b 52 04             	mov    0x4(%edx),%edx
  802e9a:	89 50 04             	mov    %edx,0x4(%eax)
  802e9d:	eb 0b                	jmp    802eaa <merging+0x265>
  802e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea2:	8b 40 04             	mov    0x4(%eax),%eax
  802ea5:	a3 30 50 80 00       	mov    %eax,0x805030
  802eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ead:	8b 40 04             	mov    0x4(%eax),%eax
  802eb0:	85 c0                	test   %eax,%eax
  802eb2:	74 0f                	je     802ec3 <merging+0x27e>
  802eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb7:	8b 40 04             	mov    0x4(%eax),%eax
  802eba:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ebd:	8b 12                	mov    (%edx),%edx
  802ebf:	89 10                	mov    %edx,(%eax)
  802ec1:	eb 0a                	jmp    802ecd <merging+0x288>
  802ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec6:	8b 00                	mov    (%eax),%eax
  802ec8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ed0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ed9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee0:	a1 38 50 80 00       	mov    0x805038,%eax
  802ee5:	48                   	dec    %eax
  802ee6:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802eeb:	e9 72 01 00 00       	jmp    803062 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802ef0:	8b 45 10             	mov    0x10(%ebp),%eax
  802ef3:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802ef6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802efa:	74 79                	je     802f75 <merging+0x330>
  802efc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f00:	74 73                	je     802f75 <merging+0x330>
  802f02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f06:	74 06                	je     802f0e <merging+0x2c9>
  802f08:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f0c:	75 17                	jne    802f25 <merging+0x2e0>
  802f0e:	83 ec 04             	sub    $0x4,%esp
  802f11:	68 e4 44 80 00       	push   $0x8044e4
  802f16:	68 94 01 00 00       	push   $0x194
  802f1b:	68 71 44 80 00       	push   $0x804471
  802f20:	e8 5d d3 ff ff       	call   800282 <_panic>
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	8b 10                	mov    (%eax),%edx
  802f2a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f2d:	89 10                	mov    %edx,(%eax)
  802f2f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f32:	8b 00                	mov    (%eax),%eax
  802f34:	85 c0                	test   %eax,%eax
  802f36:	74 0b                	je     802f43 <merging+0x2fe>
  802f38:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3b:	8b 00                	mov    (%eax),%eax
  802f3d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f40:	89 50 04             	mov    %edx,0x4(%eax)
  802f43:	8b 45 08             	mov    0x8(%ebp),%eax
  802f46:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f49:	89 10                	mov    %edx,(%eax)
  802f4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f4e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f51:	89 50 04             	mov    %edx,0x4(%eax)
  802f54:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f57:	8b 00                	mov    (%eax),%eax
  802f59:	85 c0                	test   %eax,%eax
  802f5b:	75 08                	jne    802f65 <merging+0x320>
  802f5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f60:	a3 30 50 80 00       	mov    %eax,0x805030
  802f65:	a1 38 50 80 00       	mov    0x805038,%eax
  802f6a:	40                   	inc    %eax
  802f6b:	a3 38 50 80 00       	mov    %eax,0x805038
  802f70:	e9 ce 00 00 00       	jmp    803043 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802f75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f79:	74 65                	je     802fe0 <merging+0x39b>
  802f7b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f7f:	75 17                	jne    802f98 <merging+0x353>
  802f81:	83 ec 04             	sub    $0x4,%esp
  802f84:	68 c0 44 80 00       	push   $0x8044c0
  802f89:	68 95 01 00 00       	push   $0x195
  802f8e:	68 71 44 80 00       	push   $0x804471
  802f93:	e8 ea d2 ff ff       	call   800282 <_panic>
  802f98:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa1:	89 50 04             	mov    %edx,0x4(%eax)
  802fa4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa7:	8b 40 04             	mov    0x4(%eax),%eax
  802faa:	85 c0                	test   %eax,%eax
  802fac:	74 0c                	je     802fba <merging+0x375>
  802fae:	a1 30 50 80 00       	mov    0x805030,%eax
  802fb3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fb6:	89 10                	mov    %edx,(%eax)
  802fb8:	eb 08                	jmp    802fc2 <merging+0x37d>
  802fba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fbd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fc2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fc5:	a3 30 50 80 00       	mov    %eax,0x805030
  802fca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fcd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fd3:	a1 38 50 80 00       	mov    0x805038,%eax
  802fd8:	40                   	inc    %eax
  802fd9:	a3 38 50 80 00       	mov    %eax,0x805038
  802fde:	eb 63                	jmp    803043 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802fe0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fe4:	75 17                	jne    802ffd <merging+0x3b8>
  802fe6:	83 ec 04             	sub    $0x4,%esp
  802fe9:	68 8c 44 80 00       	push   $0x80448c
  802fee:	68 98 01 00 00       	push   $0x198
  802ff3:	68 71 44 80 00       	push   $0x804471
  802ff8:	e8 85 d2 ff ff       	call   800282 <_panic>
  802ffd:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803003:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803006:	89 10                	mov    %edx,(%eax)
  803008:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80300b:	8b 00                	mov    (%eax),%eax
  80300d:	85 c0                	test   %eax,%eax
  80300f:	74 0d                	je     80301e <merging+0x3d9>
  803011:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803016:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803019:	89 50 04             	mov    %edx,0x4(%eax)
  80301c:	eb 08                	jmp    803026 <merging+0x3e1>
  80301e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803021:	a3 30 50 80 00       	mov    %eax,0x805030
  803026:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803029:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80302e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803031:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803038:	a1 38 50 80 00       	mov    0x805038,%eax
  80303d:	40                   	inc    %eax
  80303e:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803043:	83 ec 0c             	sub    $0xc,%esp
  803046:	ff 75 10             	pushl  0x10(%ebp)
  803049:	e8 d6 ed ff ff       	call   801e24 <get_block_size>
  80304e:	83 c4 10             	add    $0x10,%esp
  803051:	83 ec 04             	sub    $0x4,%esp
  803054:	6a 00                	push   $0x0
  803056:	50                   	push   %eax
  803057:	ff 75 10             	pushl  0x10(%ebp)
  80305a:	e8 16 f1 ff ff       	call   802175 <set_block_data>
  80305f:	83 c4 10             	add    $0x10,%esp
	}
}
  803062:	90                   	nop
  803063:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803066:	c9                   	leave  
  803067:	c3                   	ret    

00803068 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803068:	55                   	push   %ebp
  803069:	89 e5                	mov    %esp,%ebp
  80306b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80306e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803073:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803076:	a1 30 50 80 00       	mov    0x805030,%eax
  80307b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80307e:	73 1b                	jae    80309b <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803080:	a1 30 50 80 00       	mov    0x805030,%eax
  803085:	83 ec 04             	sub    $0x4,%esp
  803088:	ff 75 08             	pushl  0x8(%ebp)
  80308b:	6a 00                	push   $0x0
  80308d:	50                   	push   %eax
  80308e:	e8 b2 fb ff ff       	call   802c45 <merging>
  803093:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803096:	e9 8b 00 00 00       	jmp    803126 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80309b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030a0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030a3:	76 18                	jbe    8030bd <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8030a5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030aa:	83 ec 04             	sub    $0x4,%esp
  8030ad:	ff 75 08             	pushl  0x8(%ebp)
  8030b0:	50                   	push   %eax
  8030b1:	6a 00                	push   $0x0
  8030b3:	e8 8d fb ff ff       	call   802c45 <merging>
  8030b8:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030bb:	eb 69                	jmp    803126 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030bd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030c5:	eb 39                	jmp    803100 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8030c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030cd:	73 29                	jae    8030f8 <free_block+0x90>
  8030cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d2:	8b 00                	mov    (%eax),%eax
  8030d4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030d7:	76 1f                	jbe    8030f8 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8030d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dc:	8b 00                	mov    (%eax),%eax
  8030de:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8030e1:	83 ec 04             	sub    $0x4,%esp
  8030e4:	ff 75 08             	pushl  0x8(%ebp)
  8030e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8030ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8030ed:	e8 53 fb ff ff       	call   802c45 <merging>
  8030f2:	83 c4 10             	add    $0x10,%esp
			break;
  8030f5:	90                   	nop
		}
	}
}
  8030f6:	eb 2e                	jmp    803126 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030f8:	a1 34 50 80 00       	mov    0x805034,%eax
  8030fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803100:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803104:	74 07                	je     80310d <free_block+0xa5>
  803106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803109:	8b 00                	mov    (%eax),%eax
  80310b:	eb 05                	jmp    803112 <free_block+0xaa>
  80310d:	b8 00 00 00 00       	mov    $0x0,%eax
  803112:	a3 34 50 80 00       	mov    %eax,0x805034
  803117:	a1 34 50 80 00       	mov    0x805034,%eax
  80311c:	85 c0                	test   %eax,%eax
  80311e:	75 a7                	jne    8030c7 <free_block+0x5f>
  803120:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803124:	75 a1                	jne    8030c7 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803126:	90                   	nop
  803127:	c9                   	leave  
  803128:	c3                   	ret    

00803129 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803129:	55                   	push   %ebp
  80312a:	89 e5                	mov    %esp,%ebp
  80312c:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80312f:	ff 75 08             	pushl  0x8(%ebp)
  803132:	e8 ed ec ff ff       	call   801e24 <get_block_size>
  803137:	83 c4 04             	add    $0x4,%esp
  80313a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80313d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803144:	eb 17                	jmp    80315d <copy_data+0x34>
  803146:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803149:	8b 45 0c             	mov    0xc(%ebp),%eax
  80314c:	01 c2                	add    %eax,%edx
  80314e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803151:	8b 45 08             	mov    0x8(%ebp),%eax
  803154:	01 c8                	add    %ecx,%eax
  803156:	8a 00                	mov    (%eax),%al
  803158:	88 02                	mov    %al,(%edx)
  80315a:	ff 45 fc             	incl   -0x4(%ebp)
  80315d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803160:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803163:	72 e1                	jb     803146 <copy_data+0x1d>
}
  803165:	90                   	nop
  803166:	c9                   	leave  
  803167:	c3                   	ret    

00803168 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803168:	55                   	push   %ebp
  803169:	89 e5                	mov    %esp,%ebp
  80316b:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80316e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803172:	75 23                	jne    803197 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803174:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803178:	74 13                	je     80318d <realloc_block_FF+0x25>
  80317a:	83 ec 0c             	sub    $0xc,%esp
  80317d:	ff 75 0c             	pushl  0xc(%ebp)
  803180:	e8 1f f0 ff ff       	call   8021a4 <alloc_block_FF>
  803185:	83 c4 10             	add    $0x10,%esp
  803188:	e9 f4 06 00 00       	jmp    803881 <realloc_block_FF+0x719>
		return NULL;
  80318d:	b8 00 00 00 00       	mov    $0x0,%eax
  803192:	e9 ea 06 00 00       	jmp    803881 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803197:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80319b:	75 18                	jne    8031b5 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80319d:	83 ec 0c             	sub    $0xc,%esp
  8031a0:	ff 75 08             	pushl  0x8(%ebp)
  8031a3:	e8 c0 fe ff ff       	call   803068 <free_block>
  8031a8:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8031ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b0:	e9 cc 06 00 00       	jmp    803881 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8031b5:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8031b9:	77 07                	ja     8031c2 <realloc_block_FF+0x5a>
  8031bb:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8031c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031c5:	83 e0 01             	and    $0x1,%eax
  8031c8:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8031cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ce:	83 c0 08             	add    $0x8,%eax
  8031d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8031d4:	83 ec 0c             	sub    $0xc,%esp
  8031d7:	ff 75 08             	pushl  0x8(%ebp)
  8031da:	e8 45 ec ff ff       	call   801e24 <get_block_size>
  8031df:	83 c4 10             	add    $0x10,%esp
  8031e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e8:	83 e8 08             	sub    $0x8,%eax
  8031eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8031ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f1:	83 e8 04             	sub    $0x4,%eax
  8031f4:	8b 00                	mov    (%eax),%eax
  8031f6:	83 e0 fe             	and    $0xfffffffe,%eax
  8031f9:	89 c2                	mov    %eax,%edx
  8031fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fe:	01 d0                	add    %edx,%eax
  803200:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803203:	83 ec 0c             	sub    $0xc,%esp
  803206:	ff 75 e4             	pushl  -0x1c(%ebp)
  803209:	e8 16 ec ff ff       	call   801e24 <get_block_size>
  80320e:	83 c4 10             	add    $0x10,%esp
  803211:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803214:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803217:	83 e8 08             	sub    $0x8,%eax
  80321a:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80321d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803220:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803223:	75 08                	jne    80322d <realloc_block_FF+0xc5>
	{
		 return va;
  803225:	8b 45 08             	mov    0x8(%ebp),%eax
  803228:	e9 54 06 00 00       	jmp    803881 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80322d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803230:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803233:	0f 83 e5 03 00 00    	jae    80361e <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803239:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323c:	2b 45 0c             	sub    0xc(%ebp),%eax
  80323f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803242:	83 ec 0c             	sub    $0xc,%esp
  803245:	ff 75 e4             	pushl  -0x1c(%ebp)
  803248:	e8 f0 eb ff ff       	call   801e3d <is_free_block>
  80324d:	83 c4 10             	add    $0x10,%esp
  803250:	84 c0                	test   %al,%al
  803252:	0f 84 3b 01 00 00    	je     803393 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803258:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80325b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80325e:	01 d0                	add    %edx,%eax
  803260:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803263:	83 ec 04             	sub    $0x4,%esp
  803266:	6a 01                	push   $0x1
  803268:	ff 75 f0             	pushl  -0x10(%ebp)
  80326b:	ff 75 08             	pushl  0x8(%ebp)
  80326e:	e8 02 ef ff ff       	call   802175 <set_block_data>
  803273:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803276:	8b 45 08             	mov    0x8(%ebp),%eax
  803279:	83 e8 04             	sub    $0x4,%eax
  80327c:	8b 00                	mov    (%eax),%eax
  80327e:	83 e0 fe             	and    $0xfffffffe,%eax
  803281:	89 c2                	mov    %eax,%edx
  803283:	8b 45 08             	mov    0x8(%ebp),%eax
  803286:	01 d0                	add    %edx,%eax
  803288:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80328b:	83 ec 04             	sub    $0x4,%esp
  80328e:	6a 00                	push   $0x0
  803290:	ff 75 cc             	pushl  -0x34(%ebp)
  803293:	ff 75 c8             	pushl  -0x38(%ebp)
  803296:	e8 da ee ff ff       	call   802175 <set_block_data>
  80329b:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80329e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032a2:	74 06                	je     8032aa <realloc_block_FF+0x142>
  8032a4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8032a8:	75 17                	jne    8032c1 <realloc_block_FF+0x159>
  8032aa:	83 ec 04             	sub    $0x4,%esp
  8032ad:	68 e4 44 80 00       	push   $0x8044e4
  8032b2:	68 f6 01 00 00       	push   $0x1f6
  8032b7:	68 71 44 80 00       	push   $0x804471
  8032bc:	e8 c1 cf ff ff       	call   800282 <_panic>
  8032c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032c4:	8b 10                	mov    (%eax),%edx
  8032c6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032c9:	89 10                	mov    %edx,(%eax)
  8032cb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032ce:	8b 00                	mov    (%eax),%eax
  8032d0:	85 c0                	test   %eax,%eax
  8032d2:	74 0b                	je     8032df <realloc_block_FF+0x177>
  8032d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d7:	8b 00                	mov    (%eax),%eax
  8032d9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032dc:	89 50 04             	mov    %edx,0x4(%eax)
  8032df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032e5:	89 10                	mov    %edx,(%eax)
  8032e7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032ed:	89 50 04             	mov    %edx,0x4(%eax)
  8032f0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032f3:	8b 00                	mov    (%eax),%eax
  8032f5:	85 c0                	test   %eax,%eax
  8032f7:	75 08                	jne    803301 <realloc_block_FF+0x199>
  8032f9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032fc:	a3 30 50 80 00       	mov    %eax,0x805030
  803301:	a1 38 50 80 00       	mov    0x805038,%eax
  803306:	40                   	inc    %eax
  803307:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80330c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803310:	75 17                	jne    803329 <realloc_block_FF+0x1c1>
  803312:	83 ec 04             	sub    $0x4,%esp
  803315:	68 53 44 80 00       	push   $0x804453
  80331a:	68 f7 01 00 00       	push   $0x1f7
  80331f:	68 71 44 80 00       	push   $0x804471
  803324:	e8 59 cf ff ff       	call   800282 <_panic>
  803329:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80332c:	8b 00                	mov    (%eax),%eax
  80332e:	85 c0                	test   %eax,%eax
  803330:	74 10                	je     803342 <realloc_block_FF+0x1da>
  803332:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803335:	8b 00                	mov    (%eax),%eax
  803337:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80333a:	8b 52 04             	mov    0x4(%edx),%edx
  80333d:	89 50 04             	mov    %edx,0x4(%eax)
  803340:	eb 0b                	jmp    80334d <realloc_block_FF+0x1e5>
  803342:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803345:	8b 40 04             	mov    0x4(%eax),%eax
  803348:	a3 30 50 80 00       	mov    %eax,0x805030
  80334d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803350:	8b 40 04             	mov    0x4(%eax),%eax
  803353:	85 c0                	test   %eax,%eax
  803355:	74 0f                	je     803366 <realloc_block_FF+0x1fe>
  803357:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80335a:	8b 40 04             	mov    0x4(%eax),%eax
  80335d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803360:	8b 12                	mov    (%edx),%edx
  803362:	89 10                	mov    %edx,(%eax)
  803364:	eb 0a                	jmp    803370 <realloc_block_FF+0x208>
  803366:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803369:	8b 00                	mov    (%eax),%eax
  80336b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803370:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803373:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803379:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80337c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803383:	a1 38 50 80 00       	mov    0x805038,%eax
  803388:	48                   	dec    %eax
  803389:	a3 38 50 80 00       	mov    %eax,0x805038
  80338e:	e9 83 02 00 00       	jmp    803616 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803393:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803397:	0f 86 69 02 00 00    	jbe    803606 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80339d:	83 ec 04             	sub    $0x4,%esp
  8033a0:	6a 01                	push   $0x1
  8033a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8033a5:	ff 75 08             	pushl  0x8(%ebp)
  8033a8:	e8 c8 ed ff ff       	call   802175 <set_block_data>
  8033ad:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8033b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b3:	83 e8 04             	sub    $0x4,%eax
  8033b6:	8b 00                	mov    (%eax),%eax
  8033b8:	83 e0 fe             	and    $0xfffffffe,%eax
  8033bb:	89 c2                	mov    %eax,%edx
  8033bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c0:	01 d0                	add    %edx,%eax
  8033c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8033c5:	a1 38 50 80 00       	mov    0x805038,%eax
  8033ca:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8033cd:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8033d1:	75 68                	jne    80343b <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8033d3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033d7:	75 17                	jne    8033f0 <realloc_block_FF+0x288>
  8033d9:	83 ec 04             	sub    $0x4,%esp
  8033dc:	68 8c 44 80 00       	push   $0x80448c
  8033e1:	68 06 02 00 00       	push   $0x206
  8033e6:	68 71 44 80 00       	push   $0x804471
  8033eb:	e8 92 ce ff ff       	call   800282 <_panic>
  8033f0:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8033f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033f9:	89 10                	mov    %edx,(%eax)
  8033fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033fe:	8b 00                	mov    (%eax),%eax
  803400:	85 c0                	test   %eax,%eax
  803402:	74 0d                	je     803411 <realloc_block_FF+0x2a9>
  803404:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803409:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80340c:	89 50 04             	mov    %edx,0x4(%eax)
  80340f:	eb 08                	jmp    803419 <realloc_block_FF+0x2b1>
  803411:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803414:	a3 30 50 80 00       	mov    %eax,0x805030
  803419:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80341c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803421:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803424:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80342b:	a1 38 50 80 00       	mov    0x805038,%eax
  803430:	40                   	inc    %eax
  803431:	a3 38 50 80 00       	mov    %eax,0x805038
  803436:	e9 b0 01 00 00       	jmp    8035eb <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80343b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803440:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803443:	76 68                	jbe    8034ad <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803445:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803449:	75 17                	jne    803462 <realloc_block_FF+0x2fa>
  80344b:	83 ec 04             	sub    $0x4,%esp
  80344e:	68 8c 44 80 00       	push   $0x80448c
  803453:	68 0b 02 00 00       	push   $0x20b
  803458:	68 71 44 80 00       	push   $0x804471
  80345d:	e8 20 ce ff ff       	call   800282 <_panic>
  803462:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803468:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80346b:	89 10                	mov    %edx,(%eax)
  80346d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803470:	8b 00                	mov    (%eax),%eax
  803472:	85 c0                	test   %eax,%eax
  803474:	74 0d                	je     803483 <realloc_block_FF+0x31b>
  803476:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80347b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80347e:	89 50 04             	mov    %edx,0x4(%eax)
  803481:	eb 08                	jmp    80348b <realloc_block_FF+0x323>
  803483:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803486:	a3 30 50 80 00       	mov    %eax,0x805030
  80348b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80348e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803493:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803496:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80349d:	a1 38 50 80 00       	mov    0x805038,%eax
  8034a2:	40                   	inc    %eax
  8034a3:	a3 38 50 80 00       	mov    %eax,0x805038
  8034a8:	e9 3e 01 00 00       	jmp    8035eb <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8034ad:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034b2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034b5:	73 68                	jae    80351f <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034b7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034bb:	75 17                	jne    8034d4 <realloc_block_FF+0x36c>
  8034bd:	83 ec 04             	sub    $0x4,%esp
  8034c0:	68 c0 44 80 00       	push   $0x8044c0
  8034c5:	68 10 02 00 00       	push   $0x210
  8034ca:	68 71 44 80 00       	push   $0x804471
  8034cf:	e8 ae cd ff ff       	call   800282 <_panic>
  8034d4:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8034da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034dd:	89 50 04             	mov    %edx,0x4(%eax)
  8034e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e3:	8b 40 04             	mov    0x4(%eax),%eax
  8034e6:	85 c0                	test   %eax,%eax
  8034e8:	74 0c                	je     8034f6 <realloc_block_FF+0x38e>
  8034ea:	a1 30 50 80 00       	mov    0x805030,%eax
  8034ef:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034f2:	89 10                	mov    %edx,(%eax)
  8034f4:	eb 08                	jmp    8034fe <realloc_block_FF+0x396>
  8034f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034f9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803501:	a3 30 50 80 00       	mov    %eax,0x805030
  803506:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803509:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80350f:	a1 38 50 80 00       	mov    0x805038,%eax
  803514:	40                   	inc    %eax
  803515:	a3 38 50 80 00       	mov    %eax,0x805038
  80351a:	e9 cc 00 00 00       	jmp    8035eb <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80351f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803526:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80352b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80352e:	e9 8a 00 00 00       	jmp    8035bd <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803536:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803539:	73 7a                	jae    8035b5 <realloc_block_FF+0x44d>
  80353b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353e:	8b 00                	mov    (%eax),%eax
  803540:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803543:	73 70                	jae    8035b5 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803545:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803549:	74 06                	je     803551 <realloc_block_FF+0x3e9>
  80354b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80354f:	75 17                	jne    803568 <realloc_block_FF+0x400>
  803551:	83 ec 04             	sub    $0x4,%esp
  803554:	68 e4 44 80 00       	push   $0x8044e4
  803559:	68 1a 02 00 00       	push   $0x21a
  80355e:	68 71 44 80 00       	push   $0x804471
  803563:	e8 1a cd ff ff       	call   800282 <_panic>
  803568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356b:	8b 10                	mov    (%eax),%edx
  80356d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803570:	89 10                	mov    %edx,(%eax)
  803572:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803575:	8b 00                	mov    (%eax),%eax
  803577:	85 c0                	test   %eax,%eax
  803579:	74 0b                	je     803586 <realloc_block_FF+0x41e>
  80357b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357e:	8b 00                	mov    (%eax),%eax
  803580:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803583:	89 50 04             	mov    %edx,0x4(%eax)
  803586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803589:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80358c:	89 10                	mov    %edx,(%eax)
  80358e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803591:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803594:	89 50 04             	mov    %edx,0x4(%eax)
  803597:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80359a:	8b 00                	mov    (%eax),%eax
  80359c:	85 c0                	test   %eax,%eax
  80359e:	75 08                	jne    8035a8 <realloc_block_FF+0x440>
  8035a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a3:	a3 30 50 80 00       	mov    %eax,0x805030
  8035a8:	a1 38 50 80 00       	mov    0x805038,%eax
  8035ad:	40                   	inc    %eax
  8035ae:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8035b3:	eb 36                	jmp    8035eb <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8035b5:	a1 34 50 80 00       	mov    0x805034,%eax
  8035ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035c1:	74 07                	je     8035ca <realloc_block_FF+0x462>
  8035c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c6:	8b 00                	mov    (%eax),%eax
  8035c8:	eb 05                	jmp    8035cf <realloc_block_FF+0x467>
  8035ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8035cf:	a3 34 50 80 00       	mov    %eax,0x805034
  8035d4:	a1 34 50 80 00       	mov    0x805034,%eax
  8035d9:	85 c0                	test   %eax,%eax
  8035db:	0f 85 52 ff ff ff    	jne    803533 <realloc_block_FF+0x3cb>
  8035e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035e5:	0f 85 48 ff ff ff    	jne    803533 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8035eb:	83 ec 04             	sub    $0x4,%esp
  8035ee:	6a 00                	push   $0x0
  8035f0:	ff 75 d8             	pushl  -0x28(%ebp)
  8035f3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8035f6:	e8 7a eb ff ff       	call   802175 <set_block_data>
  8035fb:	83 c4 10             	add    $0x10,%esp
				return va;
  8035fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803601:	e9 7b 02 00 00       	jmp    803881 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803606:	83 ec 0c             	sub    $0xc,%esp
  803609:	68 61 45 80 00       	push   $0x804561
  80360e:	e8 2c cf ff ff       	call   80053f <cprintf>
  803613:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803616:	8b 45 08             	mov    0x8(%ebp),%eax
  803619:	e9 63 02 00 00       	jmp    803881 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80361e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803621:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803624:	0f 86 4d 02 00 00    	jbe    803877 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80362a:	83 ec 0c             	sub    $0xc,%esp
  80362d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803630:	e8 08 e8 ff ff       	call   801e3d <is_free_block>
  803635:	83 c4 10             	add    $0x10,%esp
  803638:	84 c0                	test   %al,%al
  80363a:	0f 84 37 02 00 00    	je     803877 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803640:	8b 45 0c             	mov    0xc(%ebp),%eax
  803643:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803646:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803649:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80364c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80364f:	76 38                	jbe    803689 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803651:	83 ec 0c             	sub    $0xc,%esp
  803654:	ff 75 08             	pushl  0x8(%ebp)
  803657:	e8 0c fa ff ff       	call   803068 <free_block>
  80365c:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80365f:	83 ec 0c             	sub    $0xc,%esp
  803662:	ff 75 0c             	pushl  0xc(%ebp)
  803665:	e8 3a eb ff ff       	call   8021a4 <alloc_block_FF>
  80366a:	83 c4 10             	add    $0x10,%esp
  80366d:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803670:	83 ec 08             	sub    $0x8,%esp
  803673:	ff 75 c0             	pushl  -0x40(%ebp)
  803676:	ff 75 08             	pushl  0x8(%ebp)
  803679:	e8 ab fa ff ff       	call   803129 <copy_data>
  80367e:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803681:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803684:	e9 f8 01 00 00       	jmp    803881 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803689:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80368c:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80368f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803692:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803696:	0f 87 a0 00 00 00    	ja     80373c <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80369c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036a0:	75 17                	jne    8036b9 <realloc_block_FF+0x551>
  8036a2:	83 ec 04             	sub    $0x4,%esp
  8036a5:	68 53 44 80 00       	push   $0x804453
  8036aa:	68 38 02 00 00       	push   $0x238
  8036af:	68 71 44 80 00       	push   $0x804471
  8036b4:	e8 c9 cb ff ff       	call   800282 <_panic>
  8036b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036bc:	8b 00                	mov    (%eax),%eax
  8036be:	85 c0                	test   %eax,%eax
  8036c0:	74 10                	je     8036d2 <realloc_block_FF+0x56a>
  8036c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c5:	8b 00                	mov    (%eax),%eax
  8036c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036ca:	8b 52 04             	mov    0x4(%edx),%edx
  8036cd:	89 50 04             	mov    %edx,0x4(%eax)
  8036d0:	eb 0b                	jmp    8036dd <realloc_block_FF+0x575>
  8036d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d5:	8b 40 04             	mov    0x4(%eax),%eax
  8036d8:	a3 30 50 80 00       	mov    %eax,0x805030
  8036dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e0:	8b 40 04             	mov    0x4(%eax),%eax
  8036e3:	85 c0                	test   %eax,%eax
  8036e5:	74 0f                	je     8036f6 <realloc_block_FF+0x58e>
  8036e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ea:	8b 40 04             	mov    0x4(%eax),%eax
  8036ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036f0:	8b 12                	mov    (%edx),%edx
  8036f2:	89 10                	mov    %edx,(%eax)
  8036f4:	eb 0a                	jmp    803700 <realloc_block_FF+0x598>
  8036f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f9:	8b 00                	mov    (%eax),%eax
  8036fb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803700:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803703:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80370c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803713:	a1 38 50 80 00       	mov    0x805038,%eax
  803718:	48                   	dec    %eax
  803719:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80371e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803721:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803724:	01 d0                	add    %edx,%eax
  803726:	83 ec 04             	sub    $0x4,%esp
  803729:	6a 01                	push   $0x1
  80372b:	50                   	push   %eax
  80372c:	ff 75 08             	pushl  0x8(%ebp)
  80372f:	e8 41 ea ff ff       	call   802175 <set_block_data>
  803734:	83 c4 10             	add    $0x10,%esp
  803737:	e9 36 01 00 00       	jmp    803872 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80373c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80373f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803742:	01 d0                	add    %edx,%eax
  803744:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803747:	83 ec 04             	sub    $0x4,%esp
  80374a:	6a 01                	push   $0x1
  80374c:	ff 75 f0             	pushl  -0x10(%ebp)
  80374f:	ff 75 08             	pushl  0x8(%ebp)
  803752:	e8 1e ea ff ff       	call   802175 <set_block_data>
  803757:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80375a:	8b 45 08             	mov    0x8(%ebp),%eax
  80375d:	83 e8 04             	sub    $0x4,%eax
  803760:	8b 00                	mov    (%eax),%eax
  803762:	83 e0 fe             	and    $0xfffffffe,%eax
  803765:	89 c2                	mov    %eax,%edx
  803767:	8b 45 08             	mov    0x8(%ebp),%eax
  80376a:	01 d0                	add    %edx,%eax
  80376c:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80376f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803773:	74 06                	je     80377b <realloc_block_FF+0x613>
  803775:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803779:	75 17                	jne    803792 <realloc_block_FF+0x62a>
  80377b:	83 ec 04             	sub    $0x4,%esp
  80377e:	68 e4 44 80 00       	push   $0x8044e4
  803783:	68 44 02 00 00       	push   $0x244
  803788:	68 71 44 80 00       	push   $0x804471
  80378d:	e8 f0 ca ff ff       	call   800282 <_panic>
  803792:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803795:	8b 10                	mov    (%eax),%edx
  803797:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80379a:	89 10                	mov    %edx,(%eax)
  80379c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80379f:	8b 00                	mov    (%eax),%eax
  8037a1:	85 c0                	test   %eax,%eax
  8037a3:	74 0b                	je     8037b0 <realloc_block_FF+0x648>
  8037a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a8:	8b 00                	mov    (%eax),%eax
  8037aa:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037ad:	89 50 04             	mov    %edx,0x4(%eax)
  8037b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b3:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037b6:	89 10                	mov    %edx,(%eax)
  8037b8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037be:	89 50 04             	mov    %edx,0x4(%eax)
  8037c1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037c4:	8b 00                	mov    (%eax),%eax
  8037c6:	85 c0                	test   %eax,%eax
  8037c8:	75 08                	jne    8037d2 <realloc_block_FF+0x66a>
  8037ca:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037cd:	a3 30 50 80 00       	mov    %eax,0x805030
  8037d2:	a1 38 50 80 00       	mov    0x805038,%eax
  8037d7:	40                   	inc    %eax
  8037d8:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8037dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037e1:	75 17                	jne    8037fa <realloc_block_FF+0x692>
  8037e3:	83 ec 04             	sub    $0x4,%esp
  8037e6:	68 53 44 80 00       	push   $0x804453
  8037eb:	68 45 02 00 00       	push   $0x245
  8037f0:	68 71 44 80 00       	push   $0x804471
  8037f5:	e8 88 ca ff ff       	call   800282 <_panic>
  8037fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fd:	8b 00                	mov    (%eax),%eax
  8037ff:	85 c0                	test   %eax,%eax
  803801:	74 10                	je     803813 <realloc_block_FF+0x6ab>
  803803:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803806:	8b 00                	mov    (%eax),%eax
  803808:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80380b:	8b 52 04             	mov    0x4(%edx),%edx
  80380e:	89 50 04             	mov    %edx,0x4(%eax)
  803811:	eb 0b                	jmp    80381e <realloc_block_FF+0x6b6>
  803813:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803816:	8b 40 04             	mov    0x4(%eax),%eax
  803819:	a3 30 50 80 00       	mov    %eax,0x805030
  80381e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803821:	8b 40 04             	mov    0x4(%eax),%eax
  803824:	85 c0                	test   %eax,%eax
  803826:	74 0f                	je     803837 <realloc_block_FF+0x6cf>
  803828:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382b:	8b 40 04             	mov    0x4(%eax),%eax
  80382e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803831:	8b 12                	mov    (%edx),%edx
  803833:	89 10                	mov    %edx,(%eax)
  803835:	eb 0a                	jmp    803841 <realloc_block_FF+0x6d9>
  803837:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80383a:	8b 00                	mov    (%eax),%eax
  80383c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803841:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803844:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80384a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803854:	a1 38 50 80 00       	mov    0x805038,%eax
  803859:	48                   	dec    %eax
  80385a:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  80385f:	83 ec 04             	sub    $0x4,%esp
  803862:	6a 00                	push   $0x0
  803864:	ff 75 bc             	pushl  -0x44(%ebp)
  803867:	ff 75 b8             	pushl  -0x48(%ebp)
  80386a:	e8 06 e9 ff ff       	call   802175 <set_block_data>
  80386f:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803872:	8b 45 08             	mov    0x8(%ebp),%eax
  803875:	eb 0a                	jmp    803881 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803877:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80387e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803881:	c9                   	leave  
  803882:	c3                   	ret    

00803883 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803883:	55                   	push   %ebp
  803884:	89 e5                	mov    %esp,%ebp
  803886:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803889:	83 ec 04             	sub    $0x4,%esp
  80388c:	68 68 45 80 00       	push   $0x804568
  803891:	68 58 02 00 00       	push   $0x258
  803896:	68 71 44 80 00       	push   $0x804471
  80389b:	e8 e2 c9 ff ff       	call   800282 <_panic>

008038a0 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8038a0:	55                   	push   %ebp
  8038a1:	89 e5                	mov    %esp,%ebp
  8038a3:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8038a6:	83 ec 04             	sub    $0x4,%esp
  8038a9:	68 90 45 80 00       	push   $0x804590
  8038ae:	68 61 02 00 00       	push   $0x261
  8038b3:	68 71 44 80 00       	push   $0x804471
  8038b8:	e8 c5 c9 ff ff       	call   800282 <_panic>

008038bd <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8038bd:	55                   	push   %ebp
  8038be:	89 e5                	mov    %esp,%ebp
  8038c0:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8038c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8038c6:	89 d0                	mov    %edx,%eax
  8038c8:	c1 e0 02             	shl    $0x2,%eax
  8038cb:	01 d0                	add    %edx,%eax
  8038cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038d4:	01 d0                	add    %edx,%eax
  8038d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038dd:	01 d0                	add    %edx,%eax
  8038df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038e6:	01 d0                	add    %edx,%eax
  8038e8:	c1 e0 04             	shl    $0x4,%eax
  8038eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8038ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8038f5:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8038f8:	83 ec 0c             	sub    $0xc,%esp
  8038fb:	50                   	push   %eax
  8038fc:	e8 2f e2 ff ff       	call   801b30 <sys_get_virtual_time>
  803901:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803904:	eb 41                	jmp    803947 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803906:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803909:	83 ec 0c             	sub    $0xc,%esp
  80390c:	50                   	push   %eax
  80390d:	e8 1e e2 ff ff       	call   801b30 <sys_get_virtual_time>
  803912:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803915:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803918:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80391b:	29 c2                	sub    %eax,%edx
  80391d:	89 d0                	mov    %edx,%eax
  80391f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803922:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803925:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803928:	89 d1                	mov    %edx,%ecx
  80392a:	29 c1                	sub    %eax,%ecx
  80392c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80392f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803932:	39 c2                	cmp    %eax,%edx
  803934:	0f 97 c0             	seta   %al
  803937:	0f b6 c0             	movzbl %al,%eax
  80393a:	29 c1                	sub    %eax,%ecx
  80393c:	89 c8                	mov    %ecx,%eax
  80393e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803941:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803944:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80394d:	72 b7                	jb     803906 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80394f:	90                   	nop
  803950:	c9                   	leave  
  803951:	c3                   	ret    

00803952 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803952:	55                   	push   %ebp
  803953:	89 e5                	mov    %esp,%ebp
  803955:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803958:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80395f:	eb 03                	jmp    803964 <busy_wait+0x12>
  803961:	ff 45 fc             	incl   -0x4(%ebp)
  803964:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803967:	3b 45 08             	cmp    0x8(%ebp),%eax
  80396a:	72 f5                	jb     803961 <busy_wait+0xf>
	return i;
  80396c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80396f:	c9                   	leave  
  803970:	c3                   	ret    
  803971:	66 90                	xchg   %ax,%ax
  803973:	90                   	nop

00803974 <__udivdi3>:
  803974:	55                   	push   %ebp
  803975:	57                   	push   %edi
  803976:	56                   	push   %esi
  803977:	53                   	push   %ebx
  803978:	83 ec 1c             	sub    $0x1c,%esp
  80397b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80397f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803983:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803987:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80398b:	89 ca                	mov    %ecx,%edx
  80398d:	89 f8                	mov    %edi,%eax
  80398f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803993:	85 f6                	test   %esi,%esi
  803995:	75 2d                	jne    8039c4 <__udivdi3+0x50>
  803997:	39 cf                	cmp    %ecx,%edi
  803999:	77 65                	ja     803a00 <__udivdi3+0x8c>
  80399b:	89 fd                	mov    %edi,%ebp
  80399d:	85 ff                	test   %edi,%edi
  80399f:	75 0b                	jne    8039ac <__udivdi3+0x38>
  8039a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8039a6:	31 d2                	xor    %edx,%edx
  8039a8:	f7 f7                	div    %edi
  8039aa:	89 c5                	mov    %eax,%ebp
  8039ac:	31 d2                	xor    %edx,%edx
  8039ae:	89 c8                	mov    %ecx,%eax
  8039b0:	f7 f5                	div    %ebp
  8039b2:	89 c1                	mov    %eax,%ecx
  8039b4:	89 d8                	mov    %ebx,%eax
  8039b6:	f7 f5                	div    %ebp
  8039b8:	89 cf                	mov    %ecx,%edi
  8039ba:	89 fa                	mov    %edi,%edx
  8039bc:	83 c4 1c             	add    $0x1c,%esp
  8039bf:	5b                   	pop    %ebx
  8039c0:	5e                   	pop    %esi
  8039c1:	5f                   	pop    %edi
  8039c2:	5d                   	pop    %ebp
  8039c3:	c3                   	ret    
  8039c4:	39 ce                	cmp    %ecx,%esi
  8039c6:	77 28                	ja     8039f0 <__udivdi3+0x7c>
  8039c8:	0f bd fe             	bsr    %esi,%edi
  8039cb:	83 f7 1f             	xor    $0x1f,%edi
  8039ce:	75 40                	jne    803a10 <__udivdi3+0x9c>
  8039d0:	39 ce                	cmp    %ecx,%esi
  8039d2:	72 0a                	jb     8039de <__udivdi3+0x6a>
  8039d4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8039d8:	0f 87 9e 00 00 00    	ja     803a7c <__udivdi3+0x108>
  8039de:	b8 01 00 00 00       	mov    $0x1,%eax
  8039e3:	89 fa                	mov    %edi,%edx
  8039e5:	83 c4 1c             	add    $0x1c,%esp
  8039e8:	5b                   	pop    %ebx
  8039e9:	5e                   	pop    %esi
  8039ea:	5f                   	pop    %edi
  8039eb:	5d                   	pop    %ebp
  8039ec:	c3                   	ret    
  8039ed:	8d 76 00             	lea    0x0(%esi),%esi
  8039f0:	31 ff                	xor    %edi,%edi
  8039f2:	31 c0                	xor    %eax,%eax
  8039f4:	89 fa                	mov    %edi,%edx
  8039f6:	83 c4 1c             	add    $0x1c,%esp
  8039f9:	5b                   	pop    %ebx
  8039fa:	5e                   	pop    %esi
  8039fb:	5f                   	pop    %edi
  8039fc:	5d                   	pop    %ebp
  8039fd:	c3                   	ret    
  8039fe:	66 90                	xchg   %ax,%ax
  803a00:	89 d8                	mov    %ebx,%eax
  803a02:	f7 f7                	div    %edi
  803a04:	31 ff                	xor    %edi,%edi
  803a06:	89 fa                	mov    %edi,%edx
  803a08:	83 c4 1c             	add    $0x1c,%esp
  803a0b:	5b                   	pop    %ebx
  803a0c:	5e                   	pop    %esi
  803a0d:	5f                   	pop    %edi
  803a0e:	5d                   	pop    %ebp
  803a0f:	c3                   	ret    
  803a10:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a15:	89 eb                	mov    %ebp,%ebx
  803a17:	29 fb                	sub    %edi,%ebx
  803a19:	89 f9                	mov    %edi,%ecx
  803a1b:	d3 e6                	shl    %cl,%esi
  803a1d:	89 c5                	mov    %eax,%ebp
  803a1f:	88 d9                	mov    %bl,%cl
  803a21:	d3 ed                	shr    %cl,%ebp
  803a23:	89 e9                	mov    %ebp,%ecx
  803a25:	09 f1                	or     %esi,%ecx
  803a27:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a2b:	89 f9                	mov    %edi,%ecx
  803a2d:	d3 e0                	shl    %cl,%eax
  803a2f:	89 c5                	mov    %eax,%ebp
  803a31:	89 d6                	mov    %edx,%esi
  803a33:	88 d9                	mov    %bl,%cl
  803a35:	d3 ee                	shr    %cl,%esi
  803a37:	89 f9                	mov    %edi,%ecx
  803a39:	d3 e2                	shl    %cl,%edx
  803a3b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a3f:	88 d9                	mov    %bl,%cl
  803a41:	d3 e8                	shr    %cl,%eax
  803a43:	09 c2                	or     %eax,%edx
  803a45:	89 d0                	mov    %edx,%eax
  803a47:	89 f2                	mov    %esi,%edx
  803a49:	f7 74 24 0c          	divl   0xc(%esp)
  803a4d:	89 d6                	mov    %edx,%esi
  803a4f:	89 c3                	mov    %eax,%ebx
  803a51:	f7 e5                	mul    %ebp
  803a53:	39 d6                	cmp    %edx,%esi
  803a55:	72 19                	jb     803a70 <__udivdi3+0xfc>
  803a57:	74 0b                	je     803a64 <__udivdi3+0xf0>
  803a59:	89 d8                	mov    %ebx,%eax
  803a5b:	31 ff                	xor    %edi,%edi
  803a5d:	e9 58 ff ff ff       	jmp    8039ba <__udivdi3+0x46>
  803a62:	66 90                	xchg   %ax,%ax
  803a64:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a68:	89 f9                	mov    %edi,%ecx
  803a6a:	d3 e2                	shl    %cl,%edx
  803a6c:	39 c2                	cmp    %eax,%edx
  803a6e:	73 e9                	jae    803a59 <__udivdi3+0xe5>
  803a70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a73:	31 ff                	xor    %edi,%edi
  803a75:	e9 40 ff ff ff       	jmp    8039ba <__udivdi3+0x46>
  803a7a:	66 90                	xchg   %ax,%ax
  803a7c:	31 c0                	xor    %eax,%eax
  803a7e:	e9 37 ff ff ff       	jmp    8039ba <__udivdi3+0x46>
  803a83:	90                   	nop

00803a84 <__umoddi3>:
  803a84:	55                   	push   %ebp
  803a85:	57                   	push   %edi
  803a86:	56                   	push   %esi
  803a87:	53                   	push   %ebx
  803a88:	83 ec 1c             	sub    $0x1c,%esp
  803a8b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a97:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a9f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803aa3:	89 f3                	mov    %esi,%ebx
  803aa5:	89 fa                	mov    %edi,%edx
  803aa7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803aab:	89 34 24             	mov    %esi,(%esp)
  803aae:	85 c0                	test   %eax,%eax
  803ab0:	75 1a                	jne    803acc <__umoddi3+0x48>
  803ab2:	39 f7                	cmp    %esi,%edi
  803ab4:	0f 86 a2 00 00 00    	jbe    803b5c <__umoddi3+0xd8>
  803aba:	89 c8                	mov    %ecx,%eax
  803abc:	89 f2                	mov    %esi,%edx
  803abe:	f7 f7                	div    %edi
  803ac0:	89 d0                	mov    %edx,%eax
  803ac2:	31 d2                	xor    %edx,%edx
  803ac4:	83 c4 1c             	add    $0x1c,%esp
  803ac7:	5b                   	pop    %ebx
  803ac8:	5e                   	pop    %esi
  803ac9:	5f                   	pop    %edi
  803aca:	5d                   	pop    %ebp
  803acb:	c3                   	ret    
  803acc:	39 f0                	cmp    %esi,%eax
  803ace:	0f 87 ac 00 00 00    	ja     803b80 <__umoddi3+0xfc>
  803ad4:	0f bd e8             	bsr    %eax,%ebp
  803ad7:	83 f5 1f             	xor    $0x1f,%ebp
  803ada:	0f 84 ac 00 00 00    	je     803b8c <__umoddi3+0x108>
  803ae0:	bf 20 00 00 00       	mov    $0x20,%edi
  803ae5:	29 ef                	sub    %ebp,%edi
  803ae7:	89 fe                	mov    %edi,%esi
  803ae9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803aed:	89 e9                	mov    %ebp,%ecx
  803aef:	d3 e0                	shl    %cl,%eax
  803af1:	89 d7                	mov    %edx,%edi
  803af3:	89 f1                	mov    %esi,%ecx
  803af5:	d3 ef                	shr    %cl,%edi
  803af7:	09 c7                	or     %eax,%edi
  803af9:	89 e9                	mov    %ebp,%ecx
  803afb:	d3 e2                	shl    %cl,%edx
  803afd:	89 14 24             	mov    %edx,(%esp)
  803b00:	89 d8                	mov    %ebx,%eax
  803b02:	d3 e0                	shl    %cl,%eax
  803b04:	89 c2                	mov    %eax,%edx
  803b06:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b0a:	d3 e0                	shl    %cl,%eax
  803b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b10:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b14:	89 f1                	mov    %esi,%ecx
  803b16:	d3 e8                	shr    %cl,%eax
  803b18:	09 d0                	or     %edx,%eax
  803b1a:	d3 eb                	shr    %cl,%ebx
  803b1c:	89 da                	mov    %ebx,%edx
  803b1e:	f7 f7                	div    %edi
  803b20:	89 d3                	mov    %edx,%ebx
  803b22:	f7 24 24             	mull   (%esp)
  803b25:	89 c6                	mov    %eax,%esi
  803b27:	89 d1                	mov    %edx,%ecx
  803b29:	39 d3                	cmp    %edx,%ebx
  803b2b:	0f 82 87 00 00 00    	jb     803bb8 <__umoddi3+0x134>
  803b31:	0f 84 91 00 00 00    	je     803bc8 <__umoddi3+0x144>
  803b37:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b3b:	29 f2                	sub    %esi,%edx
  803b3d:	19 cb                	sbb    %ecx,%ebx
  803b3f:	89 d8                	mov    %ebx,%eax
  803b41:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b45:	d3 e0                	shl    %cl,%eax
  803b47:	89 e9                	mov    %ebp,%ecx
  803b49:	d3 ea                	shr    %cl,%edx
  803b4b:	09 d0                	or     %edx,%eax
  803b4d:	89 e9                	mov    %ebp,%ecx
  803b4f:	d3 eb                	shr    %cl,%ebx
  803b51:	89 da                	mov    %ebx,%edx
  803b53:	83 c4 1c             	add    $0x1c,%esp
  803b56:	5b                   	pop    %ebx
  803b57:	5e                   	pop    %esi
  803b58:	5f                   	pop    %edi
  803b59:	5d                   	pop    %ebp
  803b5a:	c3                   	ret    
  803b5b:	90                   	nop
  803b5c:	89 fd                	mov    %edi,%ebp
  803b5e:	85 ff                	test   %edi,%edi
  803b60:	75 0b                	jne    803b6d <__umoddi3+0xe9>
  803b62:	b8 01 00 00 00       	mov    $0x1,%eax
  803b67:	31 d2                	xor    %edx,%edx
  803b69:	f7 f7                	div    %edi
  803b6b:	89 c5                	mov    %eax,%ebp
  803b6d:	89 f0                	mov    %esi,%eax
  803b6f:	31 d2                	xor    %edx,%edx
  803b71:	f7 f5                	div    %ebp
  803b73:	89 c8                	mov    %ecx,%eax
  803b75:	f7 f5                	div    %ebp
  803b77:	89 d0                	mov    %edx,%eax
  803b79:	e9 44 ff ff ff       	jmp    803ac2 <__umoddi3+0x3e>
  803b7e:	66 90                	xchg   %ax,%ax
  803b80:	89 c8                	mov    %ecx,%eax
  803b82:	89 f2                	mov    %esi,%edx
  803b84:	83 c4 1c             	add    $0x1c,%esp
  803b87:	5b                   	pop    %ebx
  803b88:	5e                   	pop    %esi
  803b89:	5f                   	pop    %edi
  803b8a:	5d                   	pop    %ebp
  803b8b:	c3                   	ret    
  803b8c:	3b 04 24             	cmp    (%esp),%eax
  803b8f:	72 06                	jb     803b97 <__umoddi3+0x113>
  803b91:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b95:	77 0f                	ja     803ba6 <__umoddi3+0x122>
  803b97:	89 f2                	mov    %esi,%edx
  803b99:	29 f9                	sub    %edi,%ecx
  803b9b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b9f:	89 14 24             	mov    %edx,(%esp)
  803ba2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ba6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803baa:	8b 14 24             	mov    (%esp),%edx
  803bad:	83 c4 1c             	add    $0x1c,%esp
  803bb0:	5b                   	pop    %ebx
  803bb1:	5e                   	pop    %esi
  803bb2:	5f                   	pop    %edi
  803bb3:	5d                   	pop    %ebp
  803bb4:	c3                   	ret    
  803bb5:	8d 76 00             	lea    0x0(%esi),%esi
  803bb8:	2b 04 24             	sub    (%esp),%eax
  803bbb:	19 fa                	sbb    %edi,%edx
  803bbd:	89 d1                	mov    %edx,%ecx
  803bbf:	89 c6                	mov    %eax,%esi
  803bc1:	e9 71 ff ff ff       	jmp    803b37 <__umoddi3+0xb3>
  803bc6:	66 90                	xchg   %ax,%ax
  803bc8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803bcc:	72 ea                	jb     803bb8 <__umoddi3+0x134>
  803bce:	89 d9                	mov    %ebx,%ecx
  803bd0:	e9 62 ff ff ff       	jmp    803b37 <__umoddi3+0xb3>
