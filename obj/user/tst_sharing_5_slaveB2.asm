
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
  80005b:	68 00 3c 80 00       	push   $0x803c00
  800060:	6a 0c                	push   $0xc
  800062:	68 1c 3c 80 00       	push   $0x803c1c
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
  800073:	e8 a8 1a 00 00       	call   801b20 <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 39 3c 80 00       	push   $0x803c39
  800080:	50                   	push   %eax
  800081:	e8 3e 16 00 00       	call   8016c4 <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 3c 3c 80 00       	push   $0x803c3c
  800094:	e8 a6 04 00 00       	call   80053f <cprintf>
  800099:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got z
	inctst();
  80009c:	e8 a4 1b 00 00       	call   801c45 <inctst>

	cprintf("Slave B2 please be patient ...\n");
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	68 64 3c 80 00       	push   $0x803c64
  8000a9:	e8 91 04 00 00       	call   80053f <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 28 23 00 00       	push   $0x2328
  8000b9:	e8 22 38 00 00       	call   8038e0 <env_sleep>
  8000be:	83 c4 10             	add    $0x10,%esp
	//to ensure that the other environments completed successfully
	while (gettst()!=3) ;// panic("test failed");
  8000c1:	90                   	nop
  8000c2:	e8 98 1b 00 00       	call   801c5f <gettst>
  8000c7:	83 f8 03             	cmp    $0x3,%eax
  8000ca:	75 f6                	jne    8000c2 <_main+0x8a>

	freeFrames = sys_calculate_free_frames() ;
  8000cc:	e8 6d 18 00 00       	call   80193e <sys_calculate_free_frames>
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	sfree(z);
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000da:	e8 8d 16 00 00       	call   80176c <sfree>
  8000df:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 84 3c 80 00       	push   $0x803c84
  8000ea:	e8 50 04 00 00       	call   80053f <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
	expected = 1+1; /*1page+1table*/
  8000f2:	c7 45 e8 02 00 00 00 	movl   $0x2,-0x18(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  8000f9:	e8 40 18 00 00       	call   80193e <sys_calculate_free_frames>
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800103:	29 c2                	sub    %eax,%edx
  800105:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800108:	39 c2                	cmp    %eax,%edx
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 9c 3c 80 00       	push   $0x803c9c
  800114:	6a 28                	push   $0x28
  800116:	68 1c 3c 80 00       	push   $0x803c1c
  80011b:	e8 62 01 00 00       	call   800282 <_panic>


	cprintf("Step B completed successfully!!\n\n\n");
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	68 3c 3d 80 00       	push   $0x803d3c
  800128:	e8 12 04 00 00       	call   80053f <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n%~Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 60 3d 80 00       	push   $0x803d60
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
  800149:	e8 b9 19 00 00       	call   801b07 <sys_getenvindex>
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
  8001b7:	e8 cf 16 00 00       	call   80188b <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	68 c8 3d 80 00       	push   $0x803dc8
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
  8001e7:	68 f0 3d 80 00       	push   $0x803df0
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
  800218:	68 18 3e 80 00       	push   $0x803e18
  80021d:	e8 1d 03 00 00       	call   80053f <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800225:	a1 20 50 80 00       	mov    0x805020,%eax
  80022a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	50                   	push   %eax
  800234:	68 70 3e 80 00       	push   $0x803e70
  800239:	e8 01 03 00 00       	call   80053f <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	68 c8 3d 80 00       	push   $0x803dc8
  800249:	e8 f1 02 00 00       	call   80053f <cprintf>
  80024e:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800251:	e8 4f 16 00 00       	call   8018a5 <sys_unlock_cons>
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
  800269:	e8 65 18 00 00       	call   801ad3 <sys_destroy_env>
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
  80027a:	e8 ba 18 00 00       	call   801b39 <sys_exit_env>
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
  8002a3:	68 84 3e 80 00       	push   $0x803e84
  8002a8:	e8 92 02 00 00       	call   80053f <cprintf>
  8002ad:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b0:	a1 00 50 80 00       	mov    0x805000,%eax
  8002b5:	ff 75 0c             	pushl  0xc(%ebp)
  8002b8:	ff 75 08             	pushl  0x8(%ebp)
  8002bb:	50                   	push   %eax
  8002bc:	68 89 3e 80 00       	push   $0x803e89
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
  8002e0:	68 a5 3e 80 00       	push   $0x803ea5
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
  80030f:	68 a8 3e 80 00       	push   $0x803ea8
  800314:	6a 26                	push   $0x26
  800316:	68 f4 3e 80 00       	push   $0x803ef4
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
  8003e4:	68 00 3f 80 00       	push   $0x803f00
  8003e9:	6a 3a                	push   $0x3a
  8003eb:	68 f4 3e 80 00       	push   $0x803ef4
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
  800457:	68 54 3f 80 00       	push   $0x803f54
  80045c:	6a 44                	push   $0x44
  80045e:	68 f4 3e 80 00       	push   $0x803ef4
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
  8004b1:	e8 93 13 00 00       	call   801849 <sys_cputs>
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
  800528:	e8 1c 13 00 00       	call   801849 <sys_cputs>
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
  800572:	e8 14 13 00 00       	call   80188b <sys_lock_cons>
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
  800592:	e8 0e 13 00 00       	call   8018a5 <sys_unlock_cons>
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
  8005dc:	e8 b3 33 00 00       	call   803994 <__udivdi3>
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
  80062c:	e8 73 34 00 00       	call   803aa4 <__umoddi3>
  800631:	83 c4 10             	add    $0x10,%esp
  800634:	05 b4 41 80 00       	add    $0x8041b4,%eax
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
  800787:	8b 04 85 d8 41 80 00 	mov    0x8041d8(,%eax,4),%eax
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
  800868:	8b 34 9d 20 40 80 00 	mov    0x804020(,%ebx,4),%esi
  80086f:	85 f6                	test   %esi,%esi
  800871:	75 19                	jne    80088c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800873:	53                   	push   %ebx
  800874:	68 c5 41 80 00       	push   $0x8041c5
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
  80088d:	68 ce 41 80 00       	push   $0x8041ce
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
  8008ba:	be d1 41 80 00       	mov    $0x8041d1,%esi
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
  8012c5:	68 48 43 80 00       	push   $0x804348
  8012ca:	68 3f 01 00 00       	push   $0x13f
  8012cf:	68 6a 43 80 00       	push   $0x80436a
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
  8012e5:	e8 0a 0b 00 00       	call   801df4 <sys_sbrk>
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
  801360:	e8 13 09 00 00       	call   801c78 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801365:	85 c0                	test   %eax,%eax
  801367:	74 16                	je     80137f <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801369:	83 ec 0c             	sub    $0xc,%esp
  80136c:	ff 75 08             	pushl  0x8(%ebp)
  80136f:	e8 53 0e 00 00       	call   8021c7 <alloc_block_FF>
  801374:	83 c4 10             	add    $0x10,%esp
  801377:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80137a:	e9 8a 01 00 00       	jmp    801509 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80137f:	e8 25 09 00 00       	call   801ca9 <sys_isUHeapPlacementStrategyBESTFIT>
  801384:	85 c0                	test   %eax,%eax
  801386:	0f 84 7d 01 00 00    	je     801509 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80138c:	83 ec 0c             	sub    $0xc,%esp
  80138f:	ff 75 08             	pushl  0x8(%ebp)
  801392:	e8 ec 12 00 00       	call   802683 <alloc_block_BF>
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
  8014f8:	e8 2e 09 00 00       	call   801e2b <sys_allocate_user_mem>
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
  801540:	e8 02 09 00 00       	call   801e47 <get_block_size>
  801545:	83 c4 10             	add    $0x10,%esp
  801548:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80154b:	83 ec 0c             	sub    $0xc,%esp
  80154e:	ff 75 08             	pushl  0x8(%ebp)
  801551:	e8 35 1b 00 00       	call   80308b <free_block>
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
  8015e8:	e8 22 08 00 00       	call   801e0f <sys_free_user_mem>
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
  8015f6:	68 78 43 80 00       	push   $0x804378
  8015fb:	68 85 00 00 00       	push   $0x85
  801600:	68 a2 43 80 00       	push   $0x8043a2
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
  80166b:	e8 a6 03 00 00       	call   801a16 <sys_createSharedObject>
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
  80168f:	68 ae 43 80 00       	push   $0x8043ae
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
  8016d3:	e8 68 03 00 00       	call   801a40 <sys_getSizeOfSharedObject>
  8016d8:	83 c4 10             	add    $0x10,%esp
  8016db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8016de:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016e2:	75 07                	jne    8016eb <sget+0x27>
  8016e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e9:	eb 7f                	jmp    80176a <sget+0xa6>
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
  80171e:	eb 4a                	jmp    80176a <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801720:	83 ec 04             	sub    $0x4,%esp
  801723:	ff 75 e8             	pushl  -0x18(%ebp)
  801726:	ff 75 0c             	pushl  0xc(%ebp)
  801729:	ff 75 08             	pushl  0x8(%ebp)
  80172c:	e8 2c 03 00 00       	call   801a5d <sys_getSharedObject>
  801731:	83 c4 10             	add    $0x10,%esp
  801734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801737:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80173a:	a1 20 50 80 00       	mov    0x805020,%eax
  80173f:	8b 40 78             	mov    0x78(%eax),%eax
  801742:	29 c2                	sub    %eax,%edx
  801744:	89 d0                	mov    %edx,%eax
  801746:	2d 00 10 00 00       	sub    $0x1000,%eax
  80174b:	c1 e8 0c             	shr    $0xc,%eax
  80174e:	89 c2                	mov    %eax,%edx
  801750:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801753:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80175a:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80175e:	75 07                	jne    801767 <sget+0xa3>
  801760:	b8 00 00 00 00       	mov    $0x0,%eax
  801765:	eb 03                	jmp    80176a <sget+0xa6>
	return ptr;
  801767:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801772:	8b 55 08             	mov    0x8(%ebp),%edx
  801775:	a1 20 50 80 00       	mov    0x805020,%eax
  80177a:	8b 40 78             	mov    0x78(%eax),%eax
  80177d:	29 c2                	sub    %eax,%edx
  80177f:	89 d0                	mov    %edx,%eax
  801781:	2d 00 10 00 00       	sub    $0x1000,%eax
  801786:	c1 e8 0c             	shr    $0xc,%eax
  801789:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801790:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801793:	83 ec 08             	sub    $0x8,%esp
  801796:	ff 75 08             	pushl  0x8(%ebp)
  801799:	ff 75 f4             	pushl  -0xc(%ebp)
  80179c:	e8 db 02 00 00       	call   801a7c <sys_freeSharedObject>
  8017a1:	83 c4 10             	add    $0x10,%esp
  8017a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8017a7:	90                   	nop
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017b0:	83 ec 04             	sub    $0x4,%esp
  8017b3:	68 c0 43 80 00       	push   $0x8043c0
  8017b8:	68 de 00 00 00       	push   $0xde
  8017bd:	68 a2 43 80 00       	push   $0x8043a2
  8017c2:	e8 bb ea ff ff       	call   800282 <_panic>

008017c7 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017cd:	83 ec 04             	sub    $0x4,%esp
  8017d0:	68 e6 43 80 00       	push   $0x8043e6
  8017d5:	68 ea 00 00 00       	push   $0xea
  8017da:	68 a2 43 80 00       	push   $0x8043a2
  8017df:	e8 9e ea ff ff       	call   800282 <_panic>

008017e4 <shrink>:

}
void shrink(uint32 newSize)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ea:	83 ec 04             	sub    $0x4,%esp
  8017ed:	68 e6 43 80 00       	push   $0x8043e6
  8017f2:	68 ef 00 00 00       	push   $0xef
  8017f7:	68 a2 43 80 00       	push   $0x8043a2
  8017fc:	e8 81 ea ff ff       	call   800282 <_panic>

00801801 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801807:	83 ec 04             	sub    $0x4,%esp
  80180a:	68 e6 43 80 00       	push   $0x8043e6
  80180f:	68 f4 00 00 00       	push   $0xf4
  801814:	68 a2 43 80 00       	push   $0x8043a2
  801819:	e8 64 ea ff ff       	call   800282 <_panic>

0080181e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	57                   	push   %edi
  801822:	56                   	push   %esi
  801823:	53                   	push   %ebx
  801824:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801827:	8b 45 08             	mov    0x8(%ebp),%eax
  80182a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801830:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801833:	8b 7d 18             	mov    0x18(%ebp),%edi
  801836:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801839:	cd 30                	int    $0x30
  80183b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80183e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801841:	83 c4 10             	add    $0x10,%esp
  801844:	5b                   	pop    %ebx
  801845:	5e                   	pop    %esi
  801846:	5f                   	pop    %edi
  801847:	5d                   	pop    %ebp
  801848:	c3                   	ret    

00801849 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
  80184c:	83 ec 04             	sub    $0x4,%esp
  80184f:	8b 45 10             	mov    0x10(%ebp),%eax
  801852:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801855:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	52                   	push   %edx
  801861:	ff 75 0c             	pushl  0xc(%ebp)
  801864:	50                   	push   %eax
  801865:	6a 00                	push   $0x0
  801867:	e8 b2 ff ff ff       	call   80181e <syscall>
  80186c:	83 c4 18             	add    $0x18,%esp
}
  80186f:	90                   	nop
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <sys_cgetc>:

int
sys_cgetc(void)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 02                	push   $0x2
  801881:	e8 98 ff ff ff       	call   80181e <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_lock_cons>:

void sys_lock_cons(void)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 03                	push   $0x3
  80189a:	e8 7f ff ff ff       	call   80181e <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
}
  8018a2:	90                   	nop
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 04                	push   $0x4
  8018b4:	e8 65 ff ff ff       	call   80181e <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
}
  8018bc:	90                   	nop
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	52                   	push   %edx
  8018cf:	50                   	push   %eax
  8018d0:	6a 08                	push   $0x8
  8018d2:	e8 47 ff ff ff       	call   80181e <syscall>
  8018d7:	83 c4 18             	add    $0x18,%esp
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	56                   	push   %esi
  8018e0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018e1:	8b 75 18             	mov    0x18(%ebp),%esi
  8018e4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f0:	56                   	push   %esi
  8018f1:	53                   	push   %ebx
  8018f2:	51                   	push   %ecx
  8018f3:	52                   	push   %edx
  8018f4:	50                   	push   %eax
  8018f5:	6a 09                	push   $0x9
  8018f7:	e8 22 ff ff ff       	call   80181e <syscall>
  8018fc:	83 c4 18             	add    $0x18,%esp
}
  8018ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801902:	5b                   	pop    %ebx
  801903:	5e                   	pop    %esi
  801904:	5d                   	pop    %ebp
  801905:	c3                   	ret    

00801906 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801909:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	52                   	push   %edx
  801916:	50                   	push   %eax
  801917:	6a 0a                	push   $0xa
  801919:	e8 00 ff ff ff       	call   80181e <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	ff 75 0c             	pushl  0xc(%ebp)
  80192f:	ff 75 08             	pushl  0x8(%ebp)
  801932:	6a 0b                	push   $0xb
  801934:	e8 e5 fe ff ff       	call   80181e <syscall>
  801939:	83 c4 18             	add    $0x18,%esp
}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 0c                	push   $0xc
  80194d:	e8 cc fe ff ff       	call   80181e <syscall>
  801952:	83 c4 18             	add    $0x18,%esp
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 0d                	push   $0xd
  801966:	e8 b3 fe ff ff       	call   80181e <syscall>
  80196b:	83 c4 18             	add    $0x18,%esp
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 0e                	push   $0xe
  80197f:	e8 9a fe ff ff       	call   80181e <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 0f                	push   $0xf
  801998:	e8 81 fe ff ff       	call   80181e <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	ff 75 08             	pushl  0x8(%ebp)
  8019b0:	6a 10                	push   $0x10
  8019b2:	e8 67 fe ff ff       	call   80181e <syscall>
  8019b7:	83 c4 18             	add    $0x18,%esp
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 11                	push   $0x11
  8019cb:	e8 4e fe ff ff       	call   80181e <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
}
  8019d3:	90                   	nop
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <sys_cputc>:

void
sys_cputc(const char c)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	83 ec 04             	sub    $0x4,%esp
  8019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019df:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019e2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	50                   	push   %eax
  8019ef:	6a 01                	push   $0x1
  8019f1:	e8 28 fe ff ff       	call   80181e <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
}
  8019f9:	90                   	nop
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 14                	push   $0x14
  801a0b:	e8 0e fe ff ff       	call   80181e <syscall>
  801a10:	83 c4 18             	add    $0x18,%esp
}
  801a13:	90                   	nop
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	83 ec 04             	sub    $0x4,%esp
  801a1c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a1f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a22:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a25:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	6a 00                	push   $0x0
  801a2e:	51                   	push   %ecx
  801a2f:	52                   	push   %edx
  801a30:	ff 75 0c             	pushl  0xc(%ebp)
  801a33:	50                   	push   %eax
  801a34:	6a 15                	push   $0x15
  801a36:	e8 e3 fd ff ff       	call   80181e <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	52                   	push   %edx
  801a50:	50                   	push   %eax
  801a51:	6a 16                	push   $0x16
  801a53:	e8 c6 fd ff ff       	call   80181e <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a60:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a66:	8b 45 08             	mov    0x8(%ebp),%eax
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	51                   	push   %ecx
  801a6e:	52                   	push   %edx
  801a6f:	50                   	push   %eax
  801a70:	6a 17                	push   $0x17
  801a72:	e8 a7 fd ff ff       	call   80181e <syscall>
  801a77:	83 c4 18             	add    $0x18,%esp
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a82:	8b 45 08             	mov    0x8(%ebp),%eax
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	52                   	push   %edx
  801a8c:	50                   	push   %eax
  801a8d:	6a 18                	push   $0x18
  801a8f:	e8 8a fd ff ff       	call   80181e <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	6a 00                	push   $0x0
  801aa1:	ff 75 14             	pushl  0x14(%ebp)
  801aa4:	ff 75 10             	pushl  0x10(%ebp)
  801aa7:	ff 75 0c             	pushl  0xc(%ebp)
  801aaa:	50                   	push   %eax
  801aab:	6a 19                	push   $0x19
  801aad:	e8 6c fd ff ff       	call   80181e <syscall>
  801ab2:	83 c4 18             	add    $0x18,%esp
}
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801aba:	8b 45 08             	mov    0x8(%ebp),%eax
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	50                   	push   %eax
  801ac6:	6a 1a                	push   $0x1a
  801ac8:	e8 51 fd ff ff       	call   80181e <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
}
  801ad0:	90                   	nop
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	50                   	push   %eax
  801ae2:	6a 1b                	push   $0x1b
  801ae4:	e8 35 fd ff ff       	call   80181e <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_getenvid>:

int32 sys_getenvid(void)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 05                	push   $0x5
  801afd:	e8 1c fd ff ff       	call   80181e <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 06                	push   $0x6
  801b16:	e8 03 fd ff ff       	call   80181e <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 07                	push   $0x7
  801b2f:	e8 ea fc ff ff       	call   80181e <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_exit_env>:


void sys_exit_env(void)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 1c                	push   $0x1c
  801b48:	e8 d1 fc ff ff       	call   80181e <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
}
  801b50:	90                   	nop
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b59:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b5c:	8d 50 04             	lea    0x4(%eax),%edx
  801b5f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	52                   	push   %edx
  801b69:	50                   	push   %eax
  801b6a:	6a 1d                	push   $0x1d
  801b6c:	e8 ad fc ff ff       	call   80181e <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
	return result;
  801b74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b77:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b7a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b7d:	89 01                	mov    %eax,(%ecx)
  801b7f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	c9                   	leave  
  801b86:	c2 04 00             	ret    $0x4

00801b89 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	ff 75 10             	pushl  0x10(%ebp)
  801b93:	ff 75 0c             	pushl  0xc(%ebp)
  801b96:	ff 75 08             	pushl  0x8(%ebp)
  801b99:	6a 13                	push   $0x13
  801b9b:	e8 7e fc ff ff       	call   80181e <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba3:	90                   	nop
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 1e                	push   $0x1e
  801bb5:	e8 64 fc ff ff       	call   80181e <syscall>
  801bba:	83 c4 18             	add    $0x18,%esp
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	83 ec 04             	sub    $0x4,%esp
  801bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bcb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	50                   	push   %eax
  801bd8:	6a 1f                	push   $0x1f
  801bda:	e8 3f fc ff ff       	call   80181e <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
	return ;
  801be2:	90                   	nop
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <rsttst>:
void rsttst()
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 21                	push   $0x21
  801bf4:	e8 25 fc ff ff       	call   80181e <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfc:	90                   	nop
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
  801c02:	83 ec 04             	sub    $0x4,%esp
  801c05:	8b 45 14             	mov    0x14(%ebp),%eax
  801c08:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c0b:	8b 55 18             	mov    0x18(%ebp),%edx
  801c0e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c12:	52                   	push   %edx
  801c13:	50                   	push   %eax
  801c14:	ff 75 10             	pushl  0x10(%ebp)
  801c17:	ff 75 0c             	pushl  0xc(%ebp)
  801c1a:	ff 75 08             	pushl  0x8(%ebp)
  801c1d:	6a 20                	push   $0x20
  801c1f:	e8 fa fb ff ff       	call   80181e <syscall>
  801c24:	83 c4 18             	add    $0x18,%esp
	return ;
  801c27:	90                   	nop
}
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <chktst>:
void chktst(uint32 n)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	ff 75 08             	pushl  0x8(%ebp)
  801c38:	6a 22                	push   $0x22
  801c3a:	e8 df fb ff ff       	call   80181e <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c42:	90                   	nop
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <inctst>:

void inctst()
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 23                	push   $0x23
  801c54:	e8 c5 fb ff ff       	call   80181e <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5c:	90                   	nop
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <gettst>:
uint32 gettst()
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 24                	push   $0x24
  801c6e:	e8 ab fb ff ff       	call   80181e <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
  801c7b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 25                	push   $0x25
  801c8a:	e8 8f fb ff ff       	call   80181e <syscall>
  801c8f:	83 c4 18             	add    $0x18,%esp
  801c92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c95:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c99:	75 07                	jne    801ca2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c9b:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca0:	eb 05                	jmp    801ca7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ca2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
  801cac:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 25                	push   $0x25
  801cbb:	e8 5e fb ff ff       	call   80181e <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
  801cc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cc6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cca:	75 07                	jne    801cd3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ccc:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd1:	eb 05                	jmp    801cd8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 25                	push   $0x25
  801cec:	e8 2d fb ff ff       	call   80181e <syscall>
  801cf1:	83 c4 18             	add    $0x18,%esp
  801cf4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cf7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cfb:	75 07                	jne    801d04 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cfd:	b8 01 00 00 00       	mov    $0x1,%eax
  801d02:	eb 05                	jmp    801d09 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
  801d0e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 25                	push   $0x25
  801d1d:	e8 fc fa ff ff       	call   80181e <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
  801d25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d28:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d2c:	75 07                	jne    801d35 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d33:	eb 05                	jmp    801d3a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	ff 75 08             	pushl  0x8(%ebp)
  801d4a:	6a 26                	push   $0x26
  801d4c:	e8 cd fa ff ff       	call   80181e <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
	return ;
  801d54:	90                   	nop
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
  801d5a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d5b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d64:	8b 45 08             	mov    0x8(%ebp),%eax
  801d67:	6a 00                	push   $0x0
  801d69:	53                   	push   %ebx
  801d6a:	51                   	push   %ecx
  801d6b:	52                   	push   %edx
  801d6c:	50                   	push   %eax
  801d6d:	6a 27                	push   $0x27
  801d6f:	e8 aa fa ff ff       	call   80181e <syscall>
  801d74:	83 c4 18             	add    $0x18,%esp
}
  801d77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d82:	8b 45 08             	mov    0x8(%ebp),%eax
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	52                   	push   %edx
  801d8c:	50                   	push   %eax
  801d8d:	6a 28                	push   $0x28
  801d8f:	e8 8a fa ff ff       	call   80181e <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
}
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d9c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	6a 00                	push   $0x0
  801da7:	51                   	push   %ecx
  801da8:	ff 75 10             	pushl  0x10(%ebp)
  801dab:	52                   	push   %edx
  801dac:	50                   	push   %eax
  801dad:	6a 29                	push   $0x29
  801daf:	e8 6a fa ff ff       	call   80181e <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	ff 75 10             	pushl  0x10(%ebp)
  801dc3:	ff 75 0c             	pushl  0xc(%ebp)
  801dc6:	ff 75 08             	pushl  0x8(%ebp)
  801dc9:	6a 12                	push   $0x12
  801dcb:	e8 4e fa ff ff       	call   80181e <syscall>
  801dd0:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd3:	90                   	nop
}
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801dd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	52                   	push   %edx
  801de6:	50                   	push   %eax
  801de7:	6a 2a                	push   $0x2a
  801de9:	e8 30 fa ff ff       	call   80181e <syscall>
  801dee:	83 c4 18             	add    $0x18,%esp
	return;
  801df1:	90                   	nop
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801df7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	50                   	push   %eax
  801e03:	6a 2b                	push   $0x2b
  801e05:	e8 14 fa ff ff       	call   80181e <syscall>
  801e0a:	83 c4 18             	add    $0x18,%esp
}
  801e0d:	c9                   	leave  
  801e0e:	c3                   	ret    

00801e0f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	ff 75 0c             	pushl  0xc(%ebp)
  801e1b:	ff 75 08             	pushl  0x8(%ebp)
  801e1e:	6a 2c                	push   $0x2c
  801e20:	e8 f9 f9 ff ff       	call   80181e <syscall>
  801e25:	83 c4 18             	add    $0x18,%esp
	return;
  801e28:	90                   	nop
}
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

00801e2b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	ff 75 0c             	pushl  0xc(%ebp)
  801e37:	ff 75 08             	pushl  0x8(%ebp)
  801e3a:	6a 2d                	push   $0x2d
  801e3c:	e8 dd f9 ff ff       	call   80181e <syscall>
  801e41:	83 c4 18             	add    $0x18,%esp
	return;
  801e44:	90                   	nop
}
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    

00801e47 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
  801e4a:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e50:	83 e8 04             	sub    $0x4,%eax
  801e53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801e56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e59:	8b 00                	mov    (%eax),%eax
  801e5b:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
  801e63:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e66:	8b 45 08             	mov    0x8(%ebp),%eax
  801e69:	83 e8 04             	sub    $0x4,%eax
  801e6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801e6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e72:	8b 00                	mov    (%eax),%eax
  801e74:	83 e0 01             	and    $0x1,%eax
  801e77:	85 c0                	test   %eax,%eax
  801e79:	0f 94 c0             	sete   %al
}
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
  801e81:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801e84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801e8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8e:	83 f8 02             	cmp    $0x2,%eax
  801e91:	74 2b                	je     801ebe <alloc_block+0x40>
  801e93:	83 f8 02             	cmp    $0x2,%eax
  801e96:	7f 07                	jg     801e9f <alloc_block+0x21>
  801e98:	83 f8 01             	cmp    $0x1,%eax
  801e9b:	74 0e                	je     801eab <alloc_block+0x2d>
  801e9d:	eb 58                	jmp    801ef7 <alloc_block+0x79>
  801e9f:	83 f8 03             	cmp    $0x3,%eax
  801ea2:	74 2d                	je     801ed1 <alloc_block+0x53>
  801ea4:	83 f8 04             	cmp    $0x4,%eax
  801ea7:	74 3b                	je     801ee4 <alloc_block+0x66>
  801ea9:	eb 4c                	jmp    801ef7 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801eab:	83 ec 0c             	sub    $0xc,%esp
  801eae:	ff 75 08             	pushl  0x8(%ebp)
  801eb1:	e8 11 03 00 00       	call   8021c7 <alloc_block_FF>
  801eb6:	83 c4 10             	add    $0x10,%esp
  801eb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ebc:	eb 4a                	jmp    801f08 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801ebe:	83 ec 0c             	sub    $0xc,%esp
  801ec1:	ff 75 08             	pushl  0x8(%ebp)
  801ec4:	e8 fa 19 00 00       	call   8038c3 <alloc_block_NF>
  801ec9:	83 c4 10             	add    $0x10,%esp
  801ecc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ecf:	eb 37                	jmp    801f08 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801ed1:	83 ec 0c             	sub    $0xc,%esp
  801ed4:	ff 75 08             	pushl  0x8(%ebp)
  801ed7:	e8 a7 07 00 00       	call   802683 <alloc_block_BF>
  801edc:	83 c4 10             	add    $0x10,%esp
  801edf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ee2:	eb 24                	jmp    801f08 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801ee4:	83 ec 0c             	sub    $0xc,%esp
  801ee7:	ff 75 08             	pushl  0x8(%ebp)
  801eea:	e8 b7 19 00 00       	call   8038a6 <alloc_block_WF>
  801eef:	83 c4 10             	add    $0x10,%esp
  801ef2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ef5:	eb 11                	jmp    801f08 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801ef7:	83 ec 0c             	sub    $0xc,%esp
  801efa:	68 f8 43 80 00       	push   $0x8043f8
  801eff:	e8 3b e6 ff ff       	call   80053f <cprintf>
  801f04:	83 c4 10             	add    $0x10,%esp
		break;
  801f07:	90                   	nop
	}
	return va;
  801f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
  801f10:	53                   	push   %ebx
  801f11:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801f14:	83 ec 0c             	sub    $0xc,%esp
  801f17:	68 18 44 80 00       	push   $0x804418
  801f1c:	e8 1e e6 ff ff       	call   80053f <cprintf>
  801f21:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801f24:	83 ec 0c             	sub    $0xc,%esp
  801f27:	68 43 44 80 00       	push   $0x804443
  801f2c:	e8 0e e6 ff ff       	call   80053f <cprintf>
  801f31:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801f34:	8b 45 08             	mov    0x8(%ebp),%eax
  801f37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f3a:	eb 37                	jmp    801f73 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801f3c:	83 ec 0c             	sub    $0xc,%esp
  801f3f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f42:	e8 19 ff ff ff       	call   801e60 <is_free_block>
  801f47:	83 c4 10             	add    $0x10,%esp
  801f4a:	0f be d8             	movsbl %al,%ebx
  801f4d:	83 ec 0c             	sub    $0xc,%esp
  801f50:	ff 75 f4             	pushl  -0xc(%ebp)
  801f53:	e8 ef fe ff ff       	call   801e47 <get_block_size>
  801f58:	83 c4 10             	add    $0x10,%esp
  801f5b:	83 ec 04             	sub    $0x4,%esp
  801f5e:	53                   	push   %ebx
  801f5f:	50                   	push   %eax
  801f60:	68 5b 44 80 00       	push   $0x80445b
  801f65:	e8 d5 e5 ff ff       	call   80053f <cprintf>
  801f6a:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801f6d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f77:	74 07                	je     801f80 <print_blocks_list+0x73>
  801f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7c:	8b 00                	mov    (%eax),%eax
  801f7e:	eb 05                	jmp    801f85 <print_blocks_list+0x78>
  801f80:	b8 00 00 00 00       	mov    $0x0,%eax
  801f85:	89 45 10             	mov    %eax,0x10(%ebp)
  801f88:	8b 45 10             	mov    0x10(%ebp),%eax
  801f8b:	85 c0                	test   %eax,%eax
  801f8d:	75 ad                	jne    801f3c <print_blocks_list+0x2f>
  801f8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f93:	75 a7                	jne    801f3c <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801f95:	83 ec 0c             	sub    $0xc,%esp
  801f98:	68 18 44 80 00       	push   $0x804418
  801f9d:	e8 9d e5 ff ff       	call   80053f <cprintf>
  801fa2:	83 c4 10             	add    $0x10,%esp

}
  801fa5:	90                   	nop
  801fa6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    

00801fab <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
  801fae:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb4:	83 e0 01             	and    $0x1,%eax
  801fb7:	85 c0                	test   %eax,%eax
  801fb9:	74 03                	je     801fbe <initialize_dynamic_allocator+0x13>
  801fbb:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801fbe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fc2:	0f 84 c7 01 00 00    	je     80218f <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801fc8:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801fcf:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  801fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd8:	01 d0                	add    %edx,%eax
  801fda:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801fdf:	0f 87 ad 01 00 00    	ja     802192 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe8:	85 c0                	test   %eax,%eax
  801fea:	0f 89 a5 01 00 00    	jns    802195 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801ff0:	8b 55 08             	mov    0x8(%ebp),%edx
  801ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff6:	01 d0                	add    %edx,%eax
  801ff8:	83 e8 04             	sub    $0x4,%eax
  801ffb:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802000:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802007:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80200c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80200f:	e9 87 00 00 00       	jmp    80209b <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802014:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802018:	75 14                	jne    80202e <initialize_dynamic_allocator+0x83>
  80201a:	83 ec 04             	sub    $0x4,%esp
  80201d:	68 73 44 80 00       	push   $0x804473
  802022:	6a 79                	push   $0x79
  802024:	68 91 44 80 00       	push   $0x804491
  802029:	e8 54 e2 ff ff       	call   800282 <_panic>
  80202e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802031:	8b 00                	mov    (%eax),%eax
  802033:	85 c0                	test   %eax,%eax
  802035:	74 10                	je     802047 <initialize_dynamic_allocator+0x9c>
  802037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203a:	8b 00                	mov    (%eax),%eax
  80203c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80203f:	8b 52 04             	mov    0x4(%edx),%edx
  802042:	89 50 04             	mov    %edx,0x4(%eax)
  802045:	eb 0b                	jmp    802052 <initialize_dynamic_allocator+0xa7>
  802047:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204a:	8b 40 04             	mov    0x4(%eax),%eax
  80204d:	a3 30 50 80 00       	mov    %eax,0x805030
  802052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802055:	8b 40 04             	mov    0x4(%eax),%eax
  802058:	85 c0                	test   %eax,%eax
  80205a:	74 0f                	je     80206b <initialize_dynamic_allocator+0xc0>
  80205c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205f:	8b 40 04             	mov    0x4(%eax),%eax
  802062:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802065:	8b 12                	mov    (%edx),%edx
  802067:	89 10                	mov    %edx,(%eax)
  802069:	eb 0a                	jmp    802075 <initialize_dynamic_allocator+0xca>
  80206b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206e:	8b 00                	mov    (%eax),%eax
  802070:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802078:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80207e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802081:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802088:	a1 38 50 80 00       	mov    0x805038,%eax
  80208d:	48                   	dec    %eax
  80208e:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802093:	a1 34 50 80 00       	mov    0x805034,%eax
  802098:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80209b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80209f:	74 07                	je     8020a8 <initialize_dynamic_allocator+0xfd>
  8020a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a4:	8b 00                	mov    (%eax),%eax
  8020a6:	eb 05                	jmp    8020ad <initialize_dynamic_allocator+0x102>
  8020a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ad:	a3 34 50 80 00       	mov    %eax,0x805034
  8020b2:	a1 34 50 80 00       	mov    0x805034,%eax
  8020b7:	85 c0                	test   %eax,%eax
  8020b9:	0f 85 55 ff ff ff    	jne    802014 <initialize_dynamic_allocator+0x69>
  8020bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c3:	0f 85 4b ff ff ff    	jne    802014 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8020cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8020d8:	a1 44 50 80 00       	mov    0x805044,%eax
  8020dd:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8020e2:	a1 40 50 80 00       	mov    0x805040,%eax
  8020e7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8020ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f0:	83 c0 08             	add    $0x8,%eax
  8020f3:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f9:	83 c0 04             	add    $0x4,%eax
  8020fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ff:	83 ea 08             	sub    $0x8,%edx
  802102:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802104:	8b 55 0c             	mov    0xc(%ebp),%edx
  802107:	8b 45 08             	mov    0x8(%ebp),%eax
  80210a:	01 d0                	add    %edx,%eax
  80210c:	83 e8 08             	sub    $0x8,%eax
  80210f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802112:	83 ea 08             	sub    $0x8,%edx
  802115:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802117:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80211a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802120:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802123:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80212a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80212e:	75 17                	jne    802147 <initialize_dynamic_allocator+0x19c>
  802130:	83 ec 04             	sub    $0x4,%esp
  802133:	68 ac 44 80 00       	push   $0x8044ac
  802138:	68 90 00 00 00       	push   $0x90
  80213d:	68 91 44 80 00       	push   $0x804491
  802142:	e8 3b e1 ff ff       	call   800282 <_panic>
  802147:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80214d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802150:	89 10                	mov    %edx,(%eax)
  802152:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802155:	8b 00                	mov    (%eax),%eax
  802157:	85 c0                	test   %eax,%eax
  802159:	74 0d                	je     802168 <initialize_dynamic_allocator+0x1bd>
  80215b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802160:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802163:	89 50 04             	mov    %edx,0x4(%eax)
  802166:	eb 08                	jmp    802170 <initialize_dynamic_allocator+0x1c5>
  802168:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80216b:	a3 30 50 80 00       	mov    %eax,0x805030
  802170:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802173:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802178:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80217b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802182:	a1 38 50 80 00       	mov    0x805038,%eax
  802187:	40                   	inc    %eax
  802188:	a3 38 50 80 00       	mov    %eax,0x805038
  80218d:	eb 07                	jmp    802196 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80218f:	90                   	nop
  802190:	eb 04                	jmp    802196 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802192:	90                   	nop
  802193:	eb 01                	jmp    802196 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802195:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802196:	c9                   	leave  
  802197:	c3                   	ret    

00802198 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80219b:	8b 45 10             	mov    0x10(%ebp),%eax
  80219e:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	8d 50 fc             	lea    -0x4(%eax),%edx
  8021a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021aa:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	83 e8 04             	sub    $0x4,%eax
  8021b2:	8b 00                	mov    (%eax),%eax
  8021b4:	83 e0 fe             	and    $0xfffffffe,%eax
  8021b7:	8d 50 f8             	lea    -0x8(%eax),%edx
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	01 c2                	add    %eax,%edx
  8021bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c2:	89 02                	mov    %eax,(%edx)
}
  8021c4:	90                   	nop
  8021c5:	5d                   	pop    %ebp
  8021c6:	c3                   	ret    

008021c7 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8021c7:	55                   	push   %ebp
  8021c8:	89 e5                	mov    %esp,%ebp
  8021ca:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	83 e0 01             	and    $0x1,%eax
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	74 03                	je     8021da <alloc_block_FF+0x13>
  8021d7:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8021da:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8021de:	77 07                	ja     8021e7 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8021e0:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8021e7:	a1 24 50 80 00       	mov    0x805024,%eax
  8021ec:	85 c0                	test   %eax,%eax
  8021ee:	75 73                	jne    802263 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	83 c0 10             	add    $0x10,%eax
  8021f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8021f9:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802200:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802203:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802206:	01 d0                	add    %edx,%eax
  802208:	48                   	dec    %eax
  802209:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80220c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80220f:	ba 00 00 00 00       	mov    $0x0,%edx
  802214:	f7 75 ec             	divl   -0x14(%ebp)
  802217:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80221a:	29 d0                	sub    %edx,%eax
  80221c:	c1 e8 0c             	shr    $0xc,%eax
  80221f:	83 ec 0c             	sub    $0xc,%esp
  802222:	50                   	push   %eax
  802223:	e8 b1 f0 ff ff       	call   8012d9 <sbrk>
  802228:	83 c4 10             	add    $0x10,%esp
  80222b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80222e:	83 ec 0c             	sub    $0xc,%esp
  802231:	6a 00                	push   $0x0
  802233:	e8 a1 f0 ff ff       	call   8012d9 <sbrk>
  802238:	83 c4 10             	add    $0x10,%esp
  80223b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80223e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802241:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802244:	83 ec 08             	sub    $0x8,%esp
  802247:	50                   	push   %eax
  802248:	ff 75 e4             	pushl  -0x1c(%ebp)
  80224b:	e8 5b fd ff ff       	call   801fab <initialize_dynamic_allocator>
  802250:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802253:	83 ec 0c             	sub    $0xc,%esp
  802256:	68 cf 44 80 00       	push   $0x8044cf
  80225b:	e8 df e2 ff ff       	call   80053f <cprintf>
  802260:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802263:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802267:	75 0a                	jne    802273 <alloc_block_FF+0xac>
	        return NULL;
  802269:	b8 00 00 00 00       	mov    $0x0,%eax
  80226e:	e9 0e 04 00 00       	jmp    802681 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802273:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80227a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80227f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802282:	e9 f3 02 00 00       	jmp    80257a <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228a:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80228d:	83 ec 0c             	sub    $0xc,%esp
  802290:	ff 75 bc             	pushl  -0x44(%ebp)
  802293:	e8 af fb ff ff       	call   801e47 <get_block_size>
  802298:	83 c4 10             	add    $0x10,%esp
  80229b:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	83 c0 08             	add    $0x8,%eax
  8022a4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8022a7:	0f 87 c5 02 00 00    	ja     802572 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8022ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b0:	83 c0 18             	add    $0x18,%eax
  8022b3:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8022b6:	0f 87 19 02 00 00    	ja     8024d5 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8022bc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8022bf:	2b 45 08             	sub    0x8(%ebp),%eax
  8022c2:	83 e8 08             	sub    $0x8,%eax
  8022c5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	8d 50 08             	lea    0x8(%eax),%edx
  8022ce:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8022d1:	01 d0                	add    %edx,%eax
  8022d3:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	83 c0 08             	add    $0x8,%eax
  8022dc:	83 ec 04             	sub    $0x4,%esp
  8022df:	6a 01                	push   $0x1
  8022e1:	50                   	push   %eax
  8022e2:	ff 75 bc             	pushl  -0x44(%ebp)
  8022e5:	e8 ae fe ff ff       	call   802198 <set_block_data>
  8022ea:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8022ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f0:	8b 40 04             	mov    0x4(%eax),%eax
  8022f3:	85 c0                	test   %eax,%eax
  8022f5:	75 68                	jne    80235f <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8022f7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022fb:	75 17                	jne    802314 <alloc_block_FF+0x14d>
  8022fd:	83 ec 04             	sub    $0x4,%esp
  802300:	68 ac 44 80 00       	push   $0x8044ac
  802305:	68 d7 00 00 00       	push   $0xd7
  80230a:	68 91 44 80 00       	push   $0x804491
  80230f:	e8 6e df ff ff       	call   800282 <_panic>
  802314:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80231a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80231d:	89 10                	mov    %edx,(%eax)
  80231f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802322:	8b 00                	mov    (%eax),%eax
  802324:	85 c0                	test   %eax,%eax
  802326:	74 0d                	je     802335 <alloc_block_FF+0x16e>
  802328:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80232d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802330:	89 50 04             	mov    %edx,0x4(%eax)
  802333:	eb 08                	jmp    80233d <alloc_block_FF+0x176>
  802335:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802338:	a3 30 50 80 00       	mov    %eax,0x805030
  80233d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802340:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802345:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802348:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80234f:	a1 38 50 80 00       	mov    0x805038,%eax
  802354:	40                   	inc    %eax
  802355:	a3 38 50 80 00       	mov    %eax,0x805038
  80235a:	e9 dc 00 00 00       	jmp    80243b <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80235f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802362:	8b 00                	mov    (%eax),%eax
  802364:	85 c0                	test   %eax,%eax
  802366:	75 65                	jne    8023cd <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802368:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80236c:	75 17                	jne    802385 <alloc_block_FF+0x1be>
  80236e:	83 ec 04             	sub    $0x4,%esp
  802371:	68 e0 44 80 00       	push   $0x8044e0
  802376:	68 db 00 00 00       	push   $0xdb
  80237b:	68 91 44 80 00       	push   $0x804491
  802380:	e8 fd de ff ff       	call   800282 <_panic>
  802385:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80238b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80238e:	89 50 04             	mov    %edx,0x4(%eax)
  802391:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802394:	8b 40 04             	mov    0x4(%eax),%eax
  802397:	85 c0                	test   %eax,%eax
  802399:	74 0c                	je     8023a7 <alloc_block_FF+0x1e0>
  80239b:	a1 30 50 80 00       	mov    0x805030,%eax
  8023a0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023a3:	89 10                	mov    %edx,(%eax)
  8023a5:	eb 08                	jmp    8023af <alloc_block_FF+0x1e8>
  8023a7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023aa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023af:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023b2:	a3 30 50 80 00       	mov    %eax,0x805030
  8023b7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023c0:	a1 38 50 80 00       	mov    0x805038,%eax
  8023c5:	40                   	inc    %eax
  8023c6:	a3 38 50 80 00       	mov    %eax,0x805038
  8023cb:	eb 6e                	jmp    80243b <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8023cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d1:	74 06                	je     8023d9 <alloc_block_FF+0x212>
  8023d3:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023d7:	75 17                	jne    8023f0 <alloc_block_FF+0x229>
  8023d9:	83 ec 04             	sub    $0x4,%esp
  8023dc:	68 04 45 80 00       	push   $0x804504
  8023e1:	68 df 00 00 00       	push   $0xdf
  8023e6:	68 91 44 80 00       	push   $0x804491
  8023eb:	e8 92 de ff ff       	call   800282 <_panic>
  8023f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f3:	8b 10                	mov    (%eax),%edx
  8023f5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023f8:	89 10                	mov    %edx,(%eax)
  8023fa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023fd:	8b 00                	mov    (%eax),%eax
  8023ff:	85 c0                	test   %eax,%eax
  802401:	74 0b                	je     80240e <alloc_block_FF+0x247>
  802403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802406:	8b 00                	mov    (%eax),%eax
  802408:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80240b:	89 50 04             	mov    %edx,0x4(%eax)
  80240e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802411:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802414:	89 10                	mov    %edx,(%eax)
  802416:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802419:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241c:	89 50 04             	mov    %edx,0x4(%eax)
  80241f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802422:	8b 00                	mov    (%eax),%eax
  802424:	85 c0                	test   %eax,%eax
  802426:	75 08                	jne    802430 <alloc_block_FF+0x269>
  802428:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80242b:	a3 30 50 80 00       	mov    %eax,0x805030
  802430:	a1 38 50 80 00       	mov    0x805038,%eax
  802435:	40                   	inc    %eax
  802436:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80243b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80243f:	75 17                	jne    802458 <alloc_block_FF+0x291>
  802441:	83 ec 04             	sub    $0x4,%esp
  802444:	68 73 44 80 00       	push   $0x804473
  802449:	68 e1 00 00 00       	push   $0xe1
  80244e:	68 91 44 80 00       	push   $0x804491
  802453:	e8 2a de ff ff       	call   800282 <_panic>
  802458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245b:	8b 00                	mov    (%eax),%eax
  80245d:	85 c0                	test   %eax,%eax
  80245f:	74 10                	je     802471 <alloc_block_FF+0x2aa>
  802461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802464:	8b 00                	mov    (%eax),%eax
  802466:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802469:	8b 52 04             	mov    0x4(%edx),%edx
  80246c:	89 50 04             	mov    %edx,0x4(%eax)
  80246f:	eb 0b                	jmp    80247c <alloc_block_FF+0x2b5>
  802471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802474:	8b 40 04             	mov    0x4(%eax),%eax
  802477:	a3 30 50 80 00       	mov    %eax,0x805030
  80247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247f:	8b 40 04             	mov    0x4(%eax),%eax
  802482:	85 c0                	test   %eax,%eax
  802484:	74 0f                	je     802495 <alloc_block_FF+0x2ce>
  802486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802489:	8b 40 04             	mov    0x4(%eax),%eax
  80248c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248f:	8b 12                	mov    (%edx),%edx
  802491:	89 10                	mov    %edx,(%eax)
  802493:	eb 0a                	jmp    80249f <alloc_block_FF+0x2d8>
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	8b 00                	mov    (%eax),%eax
  80249a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024b2:	a1 38 50 80 00       	mov    0x805038,%eax
  8024b7:	48                   	dec    %eax
  8024b8:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8024bd:	83 ec 04             	sub    $0x4,%esp
  8024c0:	6a 00                	push   $0x0
  8024c2:	ff 75 b4             	pushl  -0x4c(%ebp)
  8024c5:	ff 75 b0             	pushl  -0x50(%ebp)
  8024c8:	e8 cb fc ff ff       	call   802198 <set_block_data>
  8024cd:	83 c4 10             	add    $0x10,%esp
  8024d0:	e9 95 00 00 00       	jmp    80256a <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8024d5:	83 ec 04             	sub    $0x4,%esp
  8024d8:	6a 01                	push   $0x1
  8024da:	ff 75 b8             	pushl  -0x48(%ebp)
  8024dd:	ff 75 bc             	pushl  -0x44(%ebp)
  8024e0:	e8 b3 fc ff ff       	call   802198 <set_block_data>
  8024e5:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8024e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ec:	75 17                	jne    802505 <alloc_block_FF+0x33e>
  8024ee:	83 ec 04             	sub    $0x4,%esp
  8024f1:	68 73 44 80 00       	push   $0x804473
  8024f6:	68 e8 00 00 00       	push   $0xe8
  8024fb:	68 91 44 80 00       	push   $0x804491
  802500:	e8 7d dd ff ff       	call   800282 <_panic>
  802505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802508:	8b 00                	mov    (%eax),%eax
  80250a:	85 c0                	test   %eax,%eax
  80250c:	74 10                	je     80251e <alloc_block_FF+0x357>
  80250e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802511:	8b 00                	mov    (%eax),%eax
  802513:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802516:	8b 52 04             	mov    0x4(%edx),%edx
  802519:	89 50 04             	mov    %edx,0x4(%eax)
  80251c:	eb 0b                	jmp    802529 <alloc_block_FF+0x362>
  80251e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802521:	8b 40 04             	mov    0x4(%eax),%eax
  802524:	a3 30 50 80 00       	mov    %eax,0x805030
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	8b 40 04             	mov    0x4(%eax),%eax
  80252f:	85 c0                	test   %eax,%eax
  802531:	74 0f                	je     802542 <alloc_block_FF+0x37b>
  802533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802536:	8b 40 04             	mov    0x4(%eax),%eax
  802539:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80253c:	8b 12                	mov    (%edx),%edx
  80253e:	89 10                	mov    %edx,(%eax)
  802540:	eb 0a                	jmp    80254c <alloc_block_FF+0x385>
  802542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802545:	8b 00                	mov    (%eax),%eax
  802547:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80255f:	a1 38 50 80 00       	mov    0x805038,%eax
  802564:	48                   	dec    %eax
  802565:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80256a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80256d:	e9 0f 01 00 00       	jmp    802681 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802572:	a1 34 50 80 00       	mov    0x805034,%eax
  802577:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80257a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257e:	74 07                	je     802587 <alloc_block_FF+0x3c0>
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	8b 00                	mov    (%eax),%eax
  802585:	eb 05                	jmp    80258c <alloc_block_FF+0x3c5>
  802587:	b8 00 00 00 00       	mov    $0x0,%eax
  80258c:	a3 34 50 80 00       	mov    %eax,0x805034
  802591:	a1 34 50 80 00       	mov    0x805034,%eax
  802596:	85 c0                	test   %eax,%eax
  802598:	0f 85 e9 fc ff ff    	jne    802287 <alloc_block_FF+0xc0>
  80259e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a2:	0f 85 df fc ff ff    	jne    802287 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8025a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ab:	83 c0 08             	add    $0x8,%eax
  8025ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8025b1:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8025b8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025be:	01 d0                	add    %edx,%eax
  8025c0:	48                   	dec    %eax
  8025c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8025c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8025cc:	f7 75 d8             	divl   -0x28(%ebp)
  8025cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025d2:	29 d0                	sub    %edx,%eax
  8025d4:	c1 e8 0c             	shr    $0xc,%eax
  8025d7:	83 ec 0c             	sub    $0xc,%esp
  8025da:	50                   	push   %eax
  8025db:	e8 f9 ec ff ff       	call   8012d9 <sbrk>
  8025e0:	83 c4 10             	add    $0x10,%esp
  8025e3:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8025e6:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8025ea:	75 0a                	jne    8025f6 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8025ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f1:	e9 8b 00 00 00       	jmp    802681 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8025f6:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8025fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802600:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802603:	01 d0                	add    %edx,%eax
  802605:	48                   	dec    %eax
  802606:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802609:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80260c:	ba 00 00 00 00       	mov    $0x0,%edx
  802611:	f7 75 cc             	divl   -0x34(%ebp)
  802614:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802617:	29 d0                	sub    %edx,%eax
  802619:	8d 50 fc             	lea    -0x4(%eax),%edx
  80261c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80261f:	01 d0                	add    %edx,%eax
  802621:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802626:	a1 40 50 80 00       	mov    0x805040,%eax
  80262b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802631:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802638:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80263b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80263e:	01 d0                	add    %edx,%eax
  802640:	48                   	dec    %eax
  802641:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802644:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802647:	ba 00 00 00 00       	mov    $0x0,%edx
  80264c:	f7 75 c4             	divl   -0x3c(%ebp)
  80264f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802652:	29 d0                	sub    %edx,%eax
  802654:	83 ec 04             	sub    $0x4,%esp
  802657:	6a 01                	push   $0x1
  802659:	50                   	push   %eax
  80265a:	ff 75 d0             	pushl  -0x30(%ebp)
  80265d:	e8 36 fb ff ff       	call   802198 <set_block_data>
  802662:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802665:	83 ec 0c             	sub    $0xc,%esp
  802668:	ff 75 d0             	pushl  -0x30(%ebp)
  80266b:	e8 1b 0a 00 00       	call   80308b <free_block>
  802670:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802673:	83 ec 0c             	sub    $0xc,%esp
  802676:	ff 75 08             	pushl  0x8(%ebp)
  802679:	e8 49 fb ff ff       	call   8021c7 <alloc_block_FF>
  80267e:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802681:	c9                   	leave  
  802682:	c3                   	ret    

00802683 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802683:	55                   	push   %ebp
  802684:	89 e5                	mov    %esp,%ebp
  802686:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802689:	8b 45 08             	mov    0x8(%ebp),%eax
  80268c:	83 e0 01             	and    $0x1,%eax
  80268f:	85 c0                	test   %eax,%eax
  802691:	74 03                	je     802696 <alloc_block_BF+0x13>
  802693:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802696:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80269a:	77 07                	ja     8026a3 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80269c:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8026a3:	a1 24 50 80 00       	mov    0x805024,%eax
  8026a8:	85 c0                	test   %eax,%eax
  8026aa:	75 73                	jne    80271f <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8026ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8026af:	83 c0 10             	add    $0x10,%eax
  8026b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8026b5:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8026bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c2:	01 d0                	add    %edx,%eax
  8026c4:	48                   	dec    %eax
  8026c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8026c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8026d0:	f7 75 e0             	divl   -0x20(%ebp)
  8026d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026d6:	29 d0                	sub    %edx,%eax
  8026d8:	c1 e8 0c             	shr    $0xc,%eax
  8026db:	83 ec 0c             	sub    $0xc,%esp
  8026de:	50                   	push   %eax
  8026df:	e8 f5 eb ff ff       	call   8012d9 <sbrk>
  8026e4:	83 c4 10             	add    $0x10,%esp
  8026e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8026ea:	83 ec 0c             	sub    $0xc,%esp
  8026ed:	6a 00                	push   $0x0
  8026ef:	e8 e5 eb ff ff       	call   8012d9 <sbrk>
  8026f4:	83 c4 10             	add    $0x10,%esp
  8026f7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8026fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026fd:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802700:	83 ec 08             	sub    $0x8,%esp
  802703:	50                   	push   %eax
  802704:	ff 75 d8             	pushl  -0x28(%ebp)
  802707:	e8 9f f8 ff ff       	call   801fab <initialize_dynamic_allocator>
  80270c:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80270f:	83 ec 0c             	sub    $0xc,%esp
  802712:	68 cf 44 80 00       	push   $0x8044cf
  802717:	e8 23 de ff ff       	call   80053f <cprintf>
  80271c:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80271f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802726:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80272d:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802734:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80273b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802740:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802743:	e9 1d 01 00 00       	jmp    802865 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80274e:	83 ec 0c             	sub    $0xc,%esp
  802751:	ff 75 a8             	pushl  -0x58(%ebp)
  802754:	e8 ee f6 ff ff       	call   801e47 <get_block_size>
  802759:	83 c4 10             	add    $0x10,%esp
  80275c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80275f:	8b 45 08             	mov    0x8(%ebp),%eax
  802762:	83 c0 08             	add    $0x8,%eax
  802765:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802768:	0f 87 ef 00 00 00    	ja     80285d <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80276e:	8b 45 08             	mov    0x8(%ebp),%eax
  802771:	83 c0 18             	add    $0x18,%eax
  802774:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802777:	77 1d                	ja     802796 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802779:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80277f:	0f 86 d8 00 00 00    	jbe    80285d <alloc_block_BF+0x1da>
				{
					best_va = va;
  802785:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802788:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80278b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80278e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802791:	e9 c7 00 00 00       	jmp    80285d <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802796:	8b 45 08             	mov    0x8(%ebp),%eax
  802799:	83 c0 08             	add    $0x8,%eax
  80279c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80279f:	0f 85 9d 00 00 00    	jne    802842 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8027a5:	83 ec 04             	sub    $0x4,%esp
  8027a8:	6a 01                	push   $0x1
  8027aa:	ff 75 a4             	pushl  -0x5c(%ebp)
  8027ad:	ff 75 a8             	pushl  -0x58(%ebp)
  8027b0:	e8 e3 f9 ff ff       	call   802198 <set_block_data>
  8027b5:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8027b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027bc:	75 17                	jne    8027d5 <alloc_block_BF+0x152>
  8027be:	83 ec 04             	sub    $0x4,%esp
  8027c1:	68 73 44 80 00       	push   $0x804473
  8027c6:	68 2c 01 00 00       	push   $0x12c
  8027cb:	68 91 44 80 00       	push   $0x804491
  8027d0:	e8 ad da ff ff       	call   800282 <_panic>
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	8b 00                	mov    (%eax),%eax
  8027da:	85 c0                	test   %eax,%eax
  8027dc:	74 10                	je     8027ee <alloc_block_BF+0x16b>
  8027de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e1:	8b 00                	mov    (%eax),%eax
  8027e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e6:	8b 52 04             	mov    0x4(%edx),%edx
  8027e9:	89 50 04             	mov    %edx,0x4(%eax)
  8027ec:	eb 0b                	jmp    8027f9 <alloc_block_BF+0x176>
  8027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f1:	8b 40 04             	mov    0x4(%eax),%eax
  8027f4:	a3 30 50 80 00       	mov    %eax,0x805030
  8027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fc:	8b 40 04             	mov    0x4(%eax),%eax
  8027ff:	85 c0                	test   %eax,%eax
  802801:	74 0f                	je     802812 <alloc_block_BF+0x18f>
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	8b 40 04             	mov    0x4(%eax),%eax
  802809:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80280c:	8b 12                	mov    (%edx),%edx
  80280e:	89 10                	mov    %edx,(%eax)
  802810:	eb 0a                	jmp    80281c <alloc_block_BF+0x199>
  802812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802815:	8b 00                	mov    (%eax),%eax
  802817:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802828:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80282f:	a1 38 50 80 00       	mov    0x805038,%eax
  802834:	48                   	dec    %eax
  802835:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80283a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80283d:	e9 24 04 00 00       	jmp    802c66 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802842:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802845:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802848:	76 13                	jbe    80285d <alloc_block_BF+0x1da>
					{
						internal = 1;
  80284a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802851:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802854:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802857:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80285a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80285d:	a1 34 50 80 00       	mov    0x805034,%eax
  802862:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802865:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802869:	74 07                	je     802872 <alloc_block_BF+0x1ef>
  80286b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286e:	8b 00                	mov    (%eax),%eax
  802870:	eb 05                	jmp    802877 <alloc_block_BF+0x1f4>
  802872:	b8 00 00 00 00       	mov    $0x0,%eax
  802877:	a3 34 50 80 00       	mov    %eax,0x805034
  80287c:	a1 34 50 80 00       	mov    0x805034,%eax
  802881:	85 c0                	test   %eax,%eax
  802883:	0f 85 bf fe ff ff    	jne    802748 <alloc_block_BF+0xc5>
  802889:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80288d:	0f 85 b5 fe ff ff    	jne    802748 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802893:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802897:	0f 84 26 02 00 00    	je     802ac3 <alloc_block_BF+0x440>
  80289d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028a1:	0f 85 1c 02 00 00    	jne    802ac3 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8028a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028aa:	2b 45 08             	sub    0x8(%ebp),%eax
  8028ad:	83 e8 08             	sub    $0x8,%eax
  8028b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8028b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b6:	8d 50 08             	lea    0x8(%eax),%edx
  8028b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bc:	01 d0                	add    %edx,%eax
  8028be:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8028c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c4:	83 c0 08             	add    $0x8,%eax
  8028c7:	83 ec 04             	sub    $0x4,%esp
  8028ca:	6a 01                	push   $0x1
  8028cc:	50                   	push   %eax
  8028cd:	ff 75 f0             	pushl  -0x10(%ebp)
  8028d0:	e8 c3 f8 ff ff       	call   802198 <set_block_data>
  8028d5:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8028d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028db:	8b 40 04             	mov    0x4(%eax),%eax
  8028de:	85 c0                	test   %eax,%eax
  8028e0:	75 68                	jne    80294a <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028e2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028e6:	75 17                	jne    8028ff <alloc_block_BF+0x27c>
  8028e8:	83 ec 04             	sub    $0x4,%esp
  8028eb:	68 ac 44 80 00       	push   $0x8044ac
  8028f0:	68 45 01 00 00       	push   $0x145
  8028f5:	68 91 44 80 00       	push   $0x804491
  8028fa:	e8 83 d9 ff ff       	call   800282 <_panic>
  8028ff:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802905:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802908:	89 10                	mov    %edx,(%eax)
  80290a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80290d:	8b 00                	mov    (%eax),%eax
  80290f:	85 c0                	test   %eax,%eax
  802911:	74 0d                	je     802920 <alloc_block_BF+0x29d>
  802913:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802918:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80291b:	89 50 04             	mov    %edx,0x4(%eax)
  80291e:	eb 08                	jmp    802928 <alloc_block_BF+0x2a5>
  802920:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802923:	a3 30 50 80 00       	mov    %eax,0x805030
  802928:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80292b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802930:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802933:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80293a:	a1 38 50 80 00       	mov    0x805038,%eax
  80293f:	40                   	inc    %eax
  802940:	a3 38 50 80 00       	mov    %eax,0x805038
  802945:	e9 dc 00 00 00       	jmp    802a26 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80294a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294d:	8b 00                	mov    (%eax),%eax
  80294f:	85 c0                	test   %eax,%eax
  802951:	75 65                	jne    8029b8 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802953:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802957:	75 17                	jne    802970 <alloc_block_BF+0x2ed>
  802959:	83 ec 04             	sub    $0x4,%esp
  80295c:	68 e0 44 80 00       	push   $0x8044e0
  802961:	68 4a 01 00 00       	push   $0x14a
  802966:	68 91 44 80 00       	push   $0x804491
  80296b:	e8 12 d9 ff ff       	call   800282 <_panic>
  802970:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802976:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802979:	89 50 04             	mov    %edx,0x4(%eax)
  80297c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80297f:	8b 40 04             	mov    0x4(%eax),%eax
  802982:	85 c0                	test   %eax,%eax
  802984:	74 0c                	je     802992 <alloc_block_BF+0x30f>
  802986:	a1 30 50 80 00       	mov    0x805030,%eax
  80298b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80298e:	89 10                	mov    %edx,(%eax)
  802990:	eb 08                	jmp    80299a <alloc_block_BF+0x317>
  802992:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802995:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80299a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80299d:	a3 30 50 80 00       	mov    %eax,0x805030
  8029a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ab:	a1 38 50 80 00       	mov    0x805038,%eax
  8029b0:	40                   	inc    %eax
  8029b1:	a3 38 50 80 00       	mov    %eax,0x805038
  8029b6:	eb 6e                	jmp    802a26 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8029b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029bc:	74 06                	je     8029c4 <alloc_block_BF+0x341>
  8029be:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029c2:	75 17                	jne    8029db <alloc_block_BF+0x358>
  8029c4:	83 ec 04             	sub    $0x4,%esp
  8029c7:	68 04 45 80 00       	push   $0x804504
  8029cc:	68 4f 01 00 00       	push   $0x14f
  8029d1:	68 91 44 80 00       	push   $0x804491
  8029d6:	e8 a7 d8 ff ff       	call   800282 <_panic>
  8029db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029de:	8b 10                	mov    (%eax),%edx
  8029e0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029e3:	89 10                	mov    %edx,(%eax)
  8029e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029e8:	8b 00                	mov    (%eax),%eax
  8029ea:	85 c0                	test   %eax,%eax
  8029ec:	74 0b                	je     8029f9 <alloc_block_BF+0x376>
  8029ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f1:	8b 00                	mov    (%eax),%eax
  8029f3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029f6:	89 50 04             	mov    %edx,0x4(%eax)
  8029f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029ff:	89 10                	mov    %edx,(%eax)
  802a01:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a04:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a07:	89 50 04             	mov    %edx,0x4(%eax)
  802a0a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a0d:	8b 00                	mov    (%eax),%eax
  802a0f:	85 c0                	test   %eax,%eax
  802a11:	75 08                	jne    802a1b <alloc_block_BF+0x398>
  802a13:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a16:	a3 30 50 80 00       	mov    %eax,0x805030
  802a1b:	a1 38 50 80 00       	mov    0x805038,%eax
  802a20:	40                   	inc    %eax
  802a21:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802a26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a2a:	75 17                	jne    802a43 <alloc_block_BF+0x3c0>
  802a2c:	83 ec 04             	sub    $0x4,%esp
  802a2f:	68 73 44 80 00       	push   $0x804473
  802a34:	68 51 01 00 00       	push   $0x151
  802a39:	68 91 44 80 00       	push   $0x804491
  802a3e:	e8 3f d8 ff ff       	call   800282 <_panic>
  802a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a46:	8b 00                	mov    (%eax),%eax
  802a48:	85 c0                	test   %eax,%eax
  802a4a:	74 10                	je     802a5c <alloc_block_BF+0x3d9>
  802a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4f:	8b 00                	mov    (%eax),%eax
  802a51:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a54:	8b 52 04             	mov    0x4(%edx),%edx
  802a57:	89 50 04             	mov    %edx,0x4(%eax)
  802a5a:	eb 0b                	jmp    802a67 <alloc_block_BF+0x3e4>
  802a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5f:	8b 40 04             	mov    0x4(%eax),%eax
  802a62:	a3 30 50 80 00       	mov    %eax,0x805030
  802a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6a:	8b 40 04             	mov    0x4(%eax),%eax
  802a6d:	85 c0                	test   %eax,%eax
  802a6f:	74 0f                	je     802a80 <alloc_block_BF+0x3fd>
  802a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a74:	8b 40 04             	mov    0x4(%eax),%eax
  802a77:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a7a:	8b 12                	mov    (%edx),%edx
  802a7c:	89 10                	mov    %edx,(%eax)
  802a7e:	eb 0a                	jmp    802a8a <alloc_block_BF+0x407>
  802a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a83:	8b 00                	mov    (%eax),%eax
  802a85:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a9d:	a1 38 50 80 00       	mov    0x805038,%eax
  802aa2:	48                   	dec    %eax
  802aa3:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802aa8:	83 ec 04             	sub    $0x4,%esp
  802aab:	6a 00                	push   $0x0
  802aad:	ff 75 d0             	pushl  -0x30(%ebp)
  802ab0:	ff 75 cc             	pushl  -0x34(%ebp)
  802ab3:	e8 e0 f6 ff ff       	call   802198 <set_block_data>
  802ab8:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abe:	e9 a3 01 00 00       	jmp    802c66 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802ac3:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802ac7:	0f 85 9d 00 00 00    	jne    802b6a <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802acd:	83 ec 04             	sub    $0x4,%esp
  802ad0:	6a 01                	push   $0x1
  802ad2:	ff 75 ec             	pushl  -0x14(%ebp)
  802ad5:	ff 75 f0             	pushl  -0x10(%ebp)
  802ad8:	e8 bb f6 ff ff       	call   802198 <set_block_data>
  802add:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802ae0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ae4:	75 17                	jne    802afd <alloc_block_BF+0x47a>
  802ae6:	83 ec 04             	sub    $0x4,%esp
  802ae9:	68 73 44 80 00       	push   $0x804473
  802aee:	68 58 01 00 00       	push   $0x158
  802af3:	68 91 44 80 00       	push   $0x804491
  802af8:	e8 85 d7 ff ff       	call   800282 <_panic>
  802afd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b00:	8b 00                	mov    (%eax),%eax
  802b02:	85 c0                	test   %eax,%eax
  802b04:	74 10                	je     802b16 <alloc_block_BF+0x493>
  802b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b09:	8b 00                	mov    (%eax),%eax
  802b0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b0e:	8b 52 04             	mov    0x4(%edx),%edx
  802b11:	89 50 04             	mov    %edx,0x4(%eax)
  802b14:	eb 0b                	jmp    802b21 <alloc_block_BF+0x49e>
  802b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b19:	8b 40 04             	mov    0x4(%eax),%eax
  802b1c:	a3 30 50 80 00       	mov    %eax,0x805030
  802b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b24:	8b 40 04             	mov    0x4(%eax),%eax
  802b27:	85 c0                	test   %eax,%eax
  802b29:	74 0f                	je     802b3a <alloc_block_BF+0x4b7>
  802b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2e:	8b 40 04             	mov    0x4(%eax),%eax
  802b31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b34:	8b 12                	mov    (%edx),%edx
  802b36:	89 10                	mov    %edx,(%eax)
  802b38:	eb 0a                	jmp    802b44 <alloc_block_BF+0x4c1>
  802b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3d:	8b 00                	mov    (%eax),%eax
  802b3f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b57:	a1 38 50 80 00       	mov    0x805038,%eax
  802b5c:	48                   	dec    %eax
  802b5d:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b65:	e9 fc 00 00 00       	jmp    802c66 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6d:	83 c0 08             	add    $0x8,%eax
  802b70:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b73:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b7a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b7d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b80:	01 d0                	add    %edx,%eax
  802b82:	48                   	dec    %eax
  802b83:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b86:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b89:	ba 00 00 00 00       	mov    $0x0,%edx
  802b8e:	f7 75 c4             	divl   -0x3c(%ebp)
  802b91:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b94:	29 d0                	sub    %edx,%eax
  802b96:	c1 e8 0c             	shr    $0xc,%eax
  802b99:	83 ec 0c             	sub    $0xc,%esp
  802b9c:	50                   	push   %eax
  802b9d:	e8 37 e7 ff ff       	call   8012d9 <sbrk>
  802ba2:	83 c4 10             	add    $0x10,%esp
  802ba5:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802ba8:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802bac:	75 0a                	jne    802bb8 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802bae:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb3:	e9 ae 00 00 00       	jmp    802c66 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802bb8:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802bbf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bc2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802bc5:	01 d0                	add    %edx,%eax
  802bc7:	48                   	dec    %eax
  802bc8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802bcb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bce:	ba 00 00 00 00       	mov    $0x0,%edx
  802bd3:	f7 75 b8             	divl   -0x48(%ebp)
  802bd6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bd9:	29 d0                	sub    %edx,%eax
  802bdb:	8d 50 fc             	lea    -0x4(%eax),%edx
  802bde:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802be1:	01 d0                	add    %edx,%eax
  802be3:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802be8:	a1 40 50 80 00       	mov    0x805040,%eax
  802bed:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802bf3:	83 ec 0c             	sub    $0xc,%esp
  802bf6:	68 38 45 80 00       	push   $0x804538
  802bfb:	e8 3f d9 ff ff       	call   80053f <cprintf>
  802c00:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802c03:	83 ec 08             	sub    $0x8,%esp
  802c06:	ff 75 bc             	pushl  -0x44(%ebp)
  802c09:	68 3d 45 80 00       	push   $0x80453d
  802c0e:	e8 2c d9 ff ff       	call   80053f <cprintf>
  802c13:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c16:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802c1d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c20:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c23:	01 d0                	add    %edx,%eax
  802c25:	48                   	dec    %eax
  802c26:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802c29:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c2c:	ba 00 00 00 00       	mov    $0x0,%edx
  802c31:	f7 75 b0             	divl   -0x50(%ebp)
  802c34:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c37:	29 d0                	sub    %edx,%eax
  802c39:	83 ec 04             	sub    $0x4,%esp
  802c3c:	6a 01                	push   $0x1
  802c3e:	50                   	push   %eax
  802c3f:	ff 75 bc             	pushl  -0x44(%ebp)
  802c42:	e8 51 f5 ff ff       	call   802198 <set_block_data>
  802c47:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802c4a:	83 ec 0c             	sub    $0xc,%esp
  802c4d:	ff 75 bc             	pushl  -0x44(%ebp)
  802c50:	e8 36 04 00 00       	call   80308b <free_block>
  802c55:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802c58:	83 ec 0c             	sub    $0xc,%esp
  802c5b:	ff 75 08             	pushl  0x8(%ebp)
  802c5e:	e8 20 fa ff ff       	call   802683 <alloc_block_BF>
  802c63:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802c66:	c9                   	leave  
  802c67:	c3                   	ret    

00802c68 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802c68:	55                   	push   %ebp
  802c69:	89 e5                	mov    %esp,%ebp
  802c6b:	53                   	push   %ebx
  802c6c:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802c6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c76:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802c7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c81:	74 1e                	je     802ca1 <merging+0x39>
  802c83:	ff 75 08             	pushl  0x8(%ebp)
  802c86:	e8 bc f1 ff ff       	call   801e47 <get_block_size>
  802c8b:	83 c4 04             	add    $0x4,%esp
  802c8e:	89 c2                	mov    %eax,%edx
  802c90:	8b 45 08             	mov    0x8(%ebp),%eax
  802c93:	01 d0                	add    %edx,%eax
  802c95:	3b 45 10             	cmp    0x10(%ebp),%eax
  802c98:	75 07                	jne    802ca1 <merging+0x39>
		prev_is_free = 1;
  802c9a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802ca1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ca5:	74 1e                	je     802cc5 <merging+0x5d>
  802ca7:	ff 75 10             	pushl  0x10(%ebp)
  802caa:	e8 98 f1 ff ff       	call   801e47 <get_block_size>
  802caf:	83 c4 04             	add    $0x4,%esp
  802cb2:	89 c2                	mov    %eax,%edx
  802cb4:	8b 45 10             	mov    0x10(%ebp),%eax
  802cb7:	01 d0                	add    %edx,%eax
  802cb9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802cbc:	75 07                	jne    802cc5 <merging+0x5d>
		next_is_free = 1;
  802cbe:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802cc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc9:	0f 84 cc 00 00 00    	je     802d9b <merging+0x133>
  802ccf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cd3:	0f 84 c2 00 00 00    	je     802d9b <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802cd9:	ff 75 08             	pushl  0x8(%ebp)
  802cdc:	e8 66 f1 ff ff       	call   801e47 <get_block_size>
  802ce1:	83 c4 04             	add    $0x4,%esp
  802ce4:	89 c3                	mov    %eax,%ebx
  802ce6:	ff 75 10             	pushl  0x10(%ebp)
  802ce9:	e8 59 f1 ff ff       	call   801e47 <get_block_size>
  802cee:	83 c4 04             	add    $0x4,%esp
  802cf1:	01 c3                	add    %eax,%ebx
  802cf3:	ff 75 0c             	pushl  0xc(%ebp)
  802cf6:	e8 4c f1 ff ff       	call   801e47 <get_block_size>
  802cfb:	83 c4 04             	add    $0x4,%esp
  802cfe:	01 d8                	add    %ebx,%eax
  802d00:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d03:	6a 00                	push   $0x0
  802d05:	ff 75 ec             	pushl  -0x14(%ebp)
  802d08:	ff 75 08             	pushl  0x8(%ebp)
  802d0b:	e8 88 f4 ff ff       	call   802198 <set_block_data>
  802d10:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802d13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d17:	75 17                	jne    802d30 <merging+0xc8>
  802d19:	83 ec 04             	sub    $0x4,%esp
  802d1c:	68 73 44 80 00       	push   $0x804473
  802d21:	68 7d 01 00 00       	push   $0x17d
  802d26:	68 91 44 80 00       	push   $0x804491
  802d2b:	e8 52 d5 ff ff       	call   800282 <_panic>
  802d30:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d33:	8b 00                	mov    (%eax),%eax
  802d35:	85 c0                	test   %eax,%eax
  802d37:	74 10                	je     802d49 <merging+0xe1>
  802d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d3c:	8b 00                	mov    (%eax),%eax
  802d3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d41:	8b 52 04             	mov    0x4(%edx),%edx
  802d44:	89 50 04             	mov    %edx,0x4(%eax)
  802d47:	eb 0b                	jmp    802d54 <merging+0xec>
  802d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d4c:	8b 40 04             	mov    0x4(%eax),%eax
  802d4f:	a3 30 50 80 00       	mov    %eax,0x805030
  802d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d57:	8b 40 04             	mov    0x4(%eax),%eax
  802d5a:	85 c0                	test   %eax,%eax
  802d5c:	74 0f                	je     802d6d <merging+0x105>
  802d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d61:	8b 40 04             	mov    0x4(%eax),%eax
  802d64:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d67:	8b 12                	mov    (%edx),%edx
  802d69:	89 10                	mov    %edx,(%eax)
  802d6b:	eb 0a                	jmp    802d77 <merging+0x10f>
  802d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d70:	8b 00                	mov    (%eax),%eax
  802d72:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d8a:	a1 38 50 80 00       	mov    0x805038,%eax
  802d8f:	48                   	dec    %eax
  802d90:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802d95:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d96:	e9 ea 02 00 00       	jmp    803085 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802d9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d9f:	74 3b                	je     802ddc <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802da1:	83 ec 0c             	sub    $0xc,%esp
  802da4:	ff 75 08             	pushl  0x8(%ebp)
  802da7:	e8 9b f0 ff ff       	call   801e47 <get_block_size>
  802dac:	83 c4 10             	add    $0x10,%esp
  802daf:	89 c3                	mov    %eax,%ebx
  802db1:	83 ec 0c             	sub    $0xc,%esp
  802db4:	ff 75 10             	pushl  0x10(%ebp)
  802db7:	e8 8b f0 ff ff       	call   801e47 <get_block_size>
  802dbc:	83 c4 10             	add    $0x10,%esp
  802dbf:	01 d8                	add    %ebx,%eax
  802dc1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802dc4:	83 ec 04             	sub    $0x4,%esp
  802dc7:	6a 00                	push   $0x0
  802dc9:	ff 75 e8             	pushl  -0x18(%ebp)
  802dcc:	ff 75 08             	pushl  0x8(%ebp)
  802dcf:	e8 c4 f3 ff ff       	call   802198 <set_block_data>
  802dd4:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802dd7:	e9 a9 02 00 00       	jmp    803085 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802ddc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802de0:	0f 84 2d 01 00 00    	je     802f13 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802de6:	83 ec 0c             	sub    $0xc,%esp
  802de9:	ff 75 10             	pushl  0x10(%ebp)
  802dec:	e8 56 f0 ff ff       	call   801e47 <get_block_size>
  802df1:	83 c4 10             	add    $0x10,%esp
  802df4:	89 c3                	mov    %eax,%ebx
  802df6:	83 ec 0c             	sub    $0xc,%esp
  802df9:	ff 75 0c             	pushl  0xc(%ebp)
  802dfc:	e8 46 f0 ff ff       	call   801e47 <get_block_size>
  802e01:	83 c4 10             	add    $0x10,%esp
  802e04:	01 d8                	add    %ebx,%eax
  802e06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802e09:	83 ec 04             	sub    $0x4,%esp
  802e0c:	6a 00                	push   $0x0
  802e0e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e11:	ff 75 10             	pushl  0x10(%ebp)
  802e14:	e8 7f f3 ff ff       	call   802198 <set_block_data>
  802e19:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802e1c:	8b 45 10             	mov    0x10(%ebp),%eax
  802e1f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802e22:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e26:	74 06                	je     802e2e <merging+0x1c6>
  802e28:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e2c:	75 17                	jne    802e45 <merging+0x1dd>
  802e2e:	83 ec 04             	sub    $0x4,%esp
  802e31:	68 4c 45 80 00       	push   $0x80454c
  802e36:	68 8d 01 00 00       	push   $0x18d
  802e3b:	68 91 44 80 00       	push   $0x804491
  802e40:	e8 3d d4 ff ff       	call   800282 <_panic>
  802e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e48:	8b 50 04             	mov    0x4(%eax),%edx
  802e4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e4e:	89 50 04             	mov    %edx,0x4(%eax)
  802e51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e54:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e57:	89 10                	mov    %edx,(%eax)
  802e59:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e5c:	8b 40 04             	mov    0x4(%eax),%eax
  802e5f:	85 c0                	test   %eax,%eax
  802e61:	74 0d                	je     802e70 <merging+0x208>
  802e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e66:	8b 40 04             	mov    0x4(%eax),%eax
  802e69:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e6c:	89 10                	mov    %edx,(%eax)
  802e6e:	eb 08                	jmp    802e78 <merging+0x210>
  802e70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e73:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e7e:	89 50 04             	mov    %edx,0x4(%eax)
  802e81:	a1 38 50 80 00       	mov    0x805038,%eax
  802e86:	40                   	inc    %eax
  802e87:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802e8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e90:	75 17                	jne    802ea9 <merging+0x241>
  802e92:	83 ec 04             	sub    $0x4,%esp
  802e95:	68 73 44 80 00       	push   $0x804473
  802e9a:	68 8e 01 00 00       	push   $0x18e
  802e9f:	68 91 44 80 00       	push   $0x804491
  802ea4:	e8 d9 d3 ff ff       	call   800282 <_panic>
  802ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eac:	8b 00                	mov    (%eax),%eax
  802eae:	85 c0                	test   %eax,%eax
  802eb0:	74 10                	je     802ec2 <merging+0x25a>
  802eb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb5:	8b 00                	mov    (%eax),%eax
  802eb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eba:	8b 52 04             	mov    0x4(%edx),%edx
  802ebd:	89 50 04             	mov    %edx,0x4(%eax)
  802ec0:	eb 0b                	jmp    802ecd <merging+0x265>
  802ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec5:	8b 40 04             	mov    0x4(%eax),%eax
  802ec8:	a3 30 50 80 00       	mov    %eax,0x805030
  802ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ed0:	8b 40 04             	mov    0x4(%eax),%eax
  802ed3:	85 c0                	test   %eax,%eax
  802ed5:	74 0f                	je     802ee6 <merging+0x27e>
  802ed7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eda:	8b 40 04             	mov    0x4(%eax),%eax
  802edd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ee0:	8b 12                	mov    (%edx),%edx
  802ee2:	89 10                	mov    %edx,(%eax)
  802ee4:	eb 0a                	jmp    802ef0 <merging+0x288>
  802ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee9:	8b 00                	mov    (%eax),%eax
  802eeb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ef9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802efc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f03:	a1 38 50 80 00       	mov    0x805038,%eax
  802f08:	48                   	dec    %eax
  802f09:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f0e:	e9 72 01 00 00       	jmp    803085 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802f13:	8b 45 10             	mov    0x10(%ebp),%eax
  802f16:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802f19:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f1d:	74 79                	je     802f98 <merging+0x330>
  802f1f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f23:	74 73                	je     802f98 <merging+0x330>
  802f25:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f29:	74 06                	je     802f31 <merging+0x2c9>
  802f2b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f2f:	75 17                	jne    802f48 <merging+0x2e0>
  802f31:	83 ec 04             	sub    $0x4,%esp
  802f34:	68 04 45 80 00       	push   $0x804504
  802f39:	68 94 01 00 00       	push   $0x194
  802f3e:	68 91 44 80 00       	push   $0x804491
  802f43:	e8 3a d3 ff ff       	call   800282 <_panic>
  802f48:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4b:	8b 10                	mov    (%eax),%edx
  802f4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f50:	89 10                	mov    %edx,(%eax)
  802f52:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f55:	8b 00                	mov    (%eax),%eax
  802f57:	85 c0                	test   %eax,%eax
  802f59:	74 0b                	je     802f66 <merging+0x2fe>
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	8b 00                	mov    (%eax),%eax
  802f60:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f63:	89 50 04             	mov    %edx,0x4(%eax)
  802f66:	8b 45 08             	mov    0x8(%ebp),%eax
  802f69:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f6c:	89 10                	mov    %edx,(%eax)
  802f6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f71:	8b 55 08             	mov    0x8(%ebp),%edx
  802f74:	89 50 04             	mov    %edx,0x4(%eax)
  802f77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f7a:	8b 00                	mov    (%eax),%eax
  802f7c:	85 c0                	test   %eax,%eax
  802f7e:	75 08                	jne    802f88 <merging+0x320>
  802f80:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f83:	a3 30 50 80 00       	mov    %eax,0x805030
  802f88:	a1 38 50 80 00       	mov    0x805038,%eax
  802f8d:	40                   	inc    %eax
  802f8e:	a3 38 50 80 00       	mov    %eax,0x805038
  802f93:	e9 ce 00 00 00       	jmp    803066 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802f98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f9c:	74 65                	je     803003 <merging+0x39b>
  802f9e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fa2:	75 17                	jne    802fbb <merging+0x353>
  802fa4:	83 ec 04             	sub    $0x4,%esp
  802fa7:	68 e0 44 80 00       	push   $0x8044e0
  802fac:	68 95 01 00 00       	push   $0x195
  802fb1:	68 91 44 80 00       	push   $0x804491
  802fb6:	e8 c7 d2 ff ff       	call   800282 <_panic>
  802fbb:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802fc1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fc4:	89 50 04             	mov    %edx,0x4(%eax)
  802fc7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fca:	8b 40 04             	mov    0x4(%eax),%eax
  802fcd:	85 c0                	test   %eax,%eax
  802fcf:	74 0c                	je     802fdd <merging+0x375>
  802fd1:	a1 30 50 80 00       	mov    0x805030,%eax
  802fd6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fd9:	89 10                	mov    %edx,(%eax)
  802fdb:	eb 08                	jmp    802fe5 <merging+0x37d>
  802fdd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fe5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe8:	a3 30 50 80 00       	mov    %eax,0x805030
  802fed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ff0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ff6:	a1 38 50 80 00       	mov    0x805038,%eax
  802ffb:	40                   	inc    %eax
  802ffc:	a3 38 50 80 00       	mov    %eax,0x805038
  803001:	eb 63                	jmp    803066 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803003:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803007:	75 17                	jne    803020 <merging+0x3b8>
  803009:	83 ec 04             	sub    $0x4,%esp
  80300c:	68 ac 44 80 00       	push   $0x8044ac
  803011:	68 98 01 00 00       	push   $0x198
  803016:	68 91 44 80 00       	push   $0x804491
  80301b:	e8 62 d2 ff ff       	call   800282 <_panic>
  803020:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803026:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803029:	89 10                	mov    %edx,(%eax)
  80302b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80302e:	8b 00                	mov    (%eax),%eax
  803030:	85 c0                	test   %eax,%eax
  803032:	74 0d                	je     803041 <merging+0x3d9>
  803034:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803039:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80303c:	89 50 04             	mov    %edx,0x4(%eax)
  80303f:	eb 08                	jmp    803049 <merging+0x3e1>
  803041:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803044:	a3 30 50 80 00       	mov    %eax,0x805030
  803049:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80304c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803051:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803054:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305b:	a1 38 50 80 00       	mov    0x805038,%eax
  803060:	40                   	inc    %eax
  803061:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803066:	83 ec 0c             	sub    $0xc,%esp
  803069:	ff 75 10             	pushl  0x10(%ebp)
  80306c:	e8 d6 ed ff ff       	call   801e47 <get_block_size>
  803071:	83 c4 10             	add    $0x10,%esp
  803074:	83 ec 04             	sub    $0x4,%esp
  803077:	6a 00                	push   $0x0
  803079:	50                   	push   %eax
  80307a:	ff 75 10             	pushl  0x10(%ebp)
  80307d:	e8 16 f1 ff ff       	call   802198 <set_block_data>
  803082:	83 c4 10             	add    $0x10,%esp
	}
}
  803085:	90                   	nop
  803086:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803089:	c9                   	leave  
  80308a:	c3                   	ret    

0080308b <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80308b:	55                   	push   %ebp
  80308c:	89 e5                	mov    %esp,%ebp
  80308e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803091:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803096:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803099:	a1 30 50 80 00       	mov    0x805030,%eax
  80309e:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030a1:	73 1b                	jae    8030be <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8030a3:	a1 30 50 80 00       	mov    0x805030,%eax
  8030a8:	83 ec 04             	sub    $0x4,%esp
  8030ab:	ff 75 08             	pushl  0x8(%ebp)
  8030ae:	6a 00                	push   $0x0
  8030b0:	50                   	push   %eax
  8030b1:	e8 b2 fb ff ff       	call   802c68 <merging>
  8030b6:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030b9:	e9 8b 00 00 00       	jmp    803149 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8030be:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030c6:	76 18                	jbe    8030e0 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8030c8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030cd:	83 ec 04             	sub    $0x4,%esp
  8030d0:	ff 75 08             	pushl  0x8(%ebp)
  8030d3:	50                   	push   %eax
  8030d4:	6a 00                	push   $0x0
  8030d6:	e8 8d fb ff ff       	call   802c68 <merging>
  8030db:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030de:	eb 69                	jmp    803149 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030e0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030e8:	eb 39                	jmp    803123 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8030ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030f0:	73 29                	jae    80311b <free_block+0x90>
  8030f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f5:	8b 00                	mov    (%eax),%eax
  8030f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030fa:	76 1f                	jbe    80311b <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8030fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ff:	8b 00                	mov    (%eax),%eax
  803101:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803104:	83 ec 04             	sub    $0x4,%esp
  803107:	ff 75 08             	pushl  0x8(%ebp)
  80310a:	ff 75 f0             	pushl  -0x10(%ebp)
  80310d:	ff 75 f4             	pushl  -0xc(%ebp)
  803110:	e8 53 fb ff ff       	call   802c68 <merging>
  803115:	83 c4 10             	add    $0x10,%esp
			break;
  803118:	90                   	nop
		}
	}
}
  803119:	eb 2e                	jmp    803149 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80311b:	a1 34 50 80 00       	mov    0x805034,%eax
  803120:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803123:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803127:	74 07                	je     803130 <free_block+0xa5>
  803129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312c:	8b 00                	mov    (%eax),%eax
  80312e:	eb 05                	jmp    803135 <free_block+0xaa>
  803130:	b8 00 00 00 00       	mov    $0x0,%eax
  803135:	a3 34 50 80 00       	mov    %eax,0x805034
  80313a:	a1 34 50 80 00       	mov    0x805034,%eax
  80313f:	85 c0                	test   %eax,%eax
  803141:	75 a7                	jne    8030ea <free_block+0x5f>
  803143:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803147:	75 a1                	jne    8030ea <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803149:	90                   	nop
  80314a:	c9                   	leave  
  80314b:	c3                   	ret    

0080314c <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80314c:	55                   	push   %ebp
  80314d:	89 e5                	mov    %esp,%ebp
  80314f:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803152:	ff 75 08             	pushl  0x8(%ebp)
  803155:	e8 ed ec ff ff       	call   801e47 <get_block_size>
  80315a:	83 c4 04             	add    $0x4,%esp
  80315d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803160:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803167:	eb 17                	jmp    803180 <copy_data+0x34>
  803169:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80316c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80316f:	01 c2                	add    %eax,%edx
  803171:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803174:	8b 45 08             	mov    0x8(%ebp),%eax
  803177:	01 c8                	add    %ecx,%eax
  803179:	8a 00                	mov    (%eax),%al
  80317b:	88 02                	mov    %al,(%edx)
  80317d:	ff 45 fc             	incl   -0x4(%ebp)
  803180:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803183:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803186:	72 e1                	jb     803169 <copy_data+0x1d>
}
  803188:	90                   	nop
  803189:	c9                   	leave  
  80318a:	c3                   	ret    

0080318b <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80318b:	55                   	push   %ebp
  80318c:	89 e5                	mov    %esp,%ebp
  80318e:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803191:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803195:	75 23                	jne    8031ba <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803197:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80319b:	74 13                	je     8031b0 <realloc_block_FF+0x25>
  80319d:	83 ec 0c             	sub    $0xc,%esp
  8031a0:	ff 75 0c             	pushl  0xc(%ebp)
  8031a3:	e8 1f f0 ff ff       	call   8021c7 <alloc_block_FF>
  8031a8:	83 c4 10             	add    $0x10,%esp
  8031ab:	e9 f4 06 00 00       	jmp    8038a4 <realloc_block_FF+0x719>
		return NULL;
  8031b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b5:	e9 ea 06 00 00       	jmp    8038a4 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8031ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031be:	75 18                	jne    8031d8 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8031c0:	83 ec 0c             	sub    $0xc,%esp
  8031c3:	ff 75 08             	pushl  0x8(%ebp)
  8031c6:	e8 c0 fe ff ff       	call   80308b <free_block>
  8031cb:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8031ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8031d3:	e9 cc 06 00 00       	jmp    8038a4 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8031d8:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8031dc:	77 07                	ja     8031e5 <realloc_block_FF+0x5a>
  8031de:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8031e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031e8:	83 e0 01             	and    $0x1,%eax
  8031eb:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8031ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031f1:	83 c0 08             	add    $0x8,%eax
  8031f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8031f7:	83 ec 0c             	sub    $0xc,%esp
  8031fa:	ff 75 08             	pushl  0x8(%ebp)
  8031fd:	e8 45 ec ff ff       	call   801e47 <get_block_size>
  803202:	83 c4 10             	add    $0x10,%esp
  803205:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803208:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80320b:	83 e8 08             	sub    $0x8,%eax
  80320e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803211:	8b 45 08             	mov    0x8(%ebp),%eax
  803214:	83 e8 04             	sub    $0x4,%eax
  803217:	8b 00                	mov    (%eax),%eax
  803219:	83 e0 fe             	and    $0xfffffffe,%eax
  80321c:	89 c2                	mov    %eax,%edx
  80321e:	8b 45 08             	mov    0x8(%ebp),%eax
  803221:	01 d0                	add    %edx,%eax
  803223:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803226:	83 ec 0c             	sub    $0xc,%esp
  803229:	ff 75 e4             	pushl  -0x1c(%ebp)
  80322c:	e8 16 ec ff ff       	call   801e47 <get_block_size>
  803231:	83 c4 10             	add    $0x10,%esp
  803234:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803237:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80323a:	83 e8 08             	sub    $0x8,%eax
  80323d:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803240:	8b 45 0c             	mov    0xc(%ebp),%eax
  803243:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803246:	75 08                	jne    803250 <realloc_block_FF+0xc5>
	{
		 return va;
  803248:	8b 45 08             	mov    0x8(%ebp),%eax
  80324b:	e9 54 06 00 00       	jmp    8038a4 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803250:	8b 45 0c             	mov    0xc(%ebp),%eax
  803253:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803256:	0f 83 e5 03 00 00    	jae    803641 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80325c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325f:	2b 45 0c             	sub    0xc(%ebp),%eax
  803262:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803265:	83 ec 0c             	sub    $0xc,%esp
  803268:	ff 75 e4             	pushl  -0x1c(%ebp)
  80326b:	e8 f0 eb ff ff       	call   801e60 <is_free_block>
  803270:	83 c4 10             	add    $0x10,%esp
  803273:	84 c0                	test   %al,%al
  803275:	0f 84 3b 01 00 00    	je     8033b6 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80327b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80327e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803281:	01 d0                	add    %edx,%eax
  803283:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803286:	83 ec 04             	sub    $0x4,%esp
  803289:	6a 01                	push   $0x1
  80328b:	ff 75 f0             	pushl  -0x10(%ebp)
  80328e:	ff 75 08             	pushl  0x8(%ebp)
  803291:	e8 02 ef ff ff       	call   802198 <set_block_data>
  803296:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803299:	8b 45 08             	mov    0x8(%ebp),%eax
  80329c:	83 e8 04             	sub    $0x4,%eax
  80329f:	8b 00                	mov    (%eax),%eax
  8032a1:	83 e0 fe             	and    $0xfffffffe,%eax
  8032a4:	89 c2                	mov    %eax,%edx
  8032a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a9:	01 d0                	add    %edx,%eax
  8032ab:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8032ae:	83 ec 04             	sub    $0x4,%esp
  8032b1:	6a 00                	push   $0x0
  8032b3:	ff 75 cc             	pushl  -0x34(%ebp)
  8032b6:	ff 75 c8             	pushl  -0x38(%ebp)
  8032b9:	e8 da ee ff ff       	call   802198 <set_block_data>
  8032be:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8032c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032c5:	74 06                	je     8032cd <realloc_block_FF+0x142>
  8032c7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8032cb:	75 17                	jne    8032e4 <realloc_block_FF+0x159>
  8032cd:	83 ec 04             	sub    $0x4,%esp
  8032d0:	68 04 45 80 00       	push   $0x804504
  8032d5:	68 f6 01 00 00       	push   $0x1f6
  8032da:	68 91 44 80 00       	push   $0x804491
  8032df:	e8 9e cf ff ff       	call   800282 <_panic>
  8032e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e7:	8b 10                	mov    (%eax),%edx
  8032e9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032ec:	89 10                	mov    %edx,(%eax)
  8032ee:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032f1:	8b 00                	mov    (%eax),%eax
  8032f3:	85 c0                	test   %eax,%eax
  8032f5:	74 0b                	je     803302 <realloc_block_FF+0x177>
  8032f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032fa:	8b 00                	mov    (%eax),%eax
  8032fc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032ff:	89 50 04             	mov    %edx,0x4(%eax)
  803302:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803305:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803308:	89 10                	mov    %edx,(%eax)
  80330a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80330d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803310:	89 50 04             	mov    %edx,0x4(%eax)
  803313:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803316:	8b 00                	mov    (%eax),%eax
  803318:	85 c0                	test   %eax,%eax
  80331a:	75 08                	jne    803324 <realloc_block_FF+0x199>
  80331c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80331f:	a3 30 50 80 00       	mov    %eax,0x805030
  803324:	a1 38 50 80 00       	mov    0x805038,%eax
  803329:	40                   	inc    %eax
  80332a:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80332f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803333:	75 17                	jne    80334c <realloc_block_FF+0x1c1>
  803335:	83 ec 04             	sub    $0x4,%esp
  803338:	68 73 44 80 00       	push   $0x804473
  80333d:	68 f7 01 00 00       	push   $0x1f7
  803342:	68 91 44 80 00       	push   $0x804491
  803347:	e8 36 cf ff ff       	call   800282 <_panic>
  80334c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80334f:	8b 00                	mov    (%eax),%eax
  803351:	85 c0                	test   %eax,%eax
  803353:	74 10                	je     803365 <realloc_block_FF+0x1da>
  803355:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803358:	8b 00                	mov    (%eax),%eax
  80335a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80335d:	8b 52 04             	mov    0x4(%edx),%edx
  803360:	89 50 04             	mov    %edx,0x4(%eax)
  803363:	eb 0b                	jmp    803370 <realloc_block_FF+0x1e5>
  803365:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803368:	8b 40 04             	mov    0x4(%eax),%eax
  80336b:	a3 30 50 80 00       	mov    %eax,0x805030
  803370:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803373:	8b 40 04             	mov    0x4(%eax),%eax
  803376:	85 c0                	test   %eax,%eax
  803378:	74 0f                	je     803389 <realloc_block_FF+0x1fe>
  80337a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80337d:	8b 40 04             	mov    0x4(%eax),%eax
  803380:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803383:	8b 12                	mov    (%edx),%edx
  803385:	89 10                	mov    %edx,(%eax)
  803387:	eb 0a                	jmp    803393 <realloc_block_FF+0x208>
  803389:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80338c:	8b 00                	mov    (%eax),%eax
  80338e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803393:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803396:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80339c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80339f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a6:	a1 38 50 80 00       	mov    0x805038,%eax
  8033ab:	48                   	dec    %eax
  8033ac:	a3 38 50 80 00       	mov    %eax,0x805038
  8033b1:	e9 83 02 00 00       	jmp    803639 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8033b6:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8033ba:	0f 86 69 02 00 00    	jbe    803629 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8033c0:	83 ec 04             	sub    $0x4,%esp
  8033c3:	6a 01                	push   $0x1
  8033c5:	ff 75 f0             	pushl  -0x10(%ebp)
  8033c8:	ff 75 08             	pushl  0x8(%ebp)
  8033cb:	e8 c8 ed ff ff       	call   802198 <set_block_data>
  8033d0:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8033d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d6:	83 e8 04             	sub    $0x4,%eax
  8033d9:	8b 00                	mov    (%eax),%eax
  8033db:	83 e0 fe             	and    $0xfffffffe,%eax
  8033de:	89 c2                	mov    %eax,%edx
  8033e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e3:	01 d0                	add    %edx,%eax
  8033e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8033e8:	a1 38 50 80 00       	mov    0x805038,%eax
  8033ed:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8033f0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8033f4:	75 68                	jne    80345e <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8033f6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033fa:	75 17                	jne    803413 <realloc_block_FF+0x288>
  8033fc:	83 ec 04             	sub    $0x4,%esp
  8033ff:	68 ac 44 80 00       	push   $0x8044ac
  803404:	68 06 02 00 00       	push   $0x206
  803409:	68 91 44 80 00       	push   $0x804491
  80340e:	e8 6f ce ff ff       	call   800282 <_panic>
  803413:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803419:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80341c:	89 10                	mov    %edx,(%eax)
  80341e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803421:	8b 00                	mov    (%eax),%eax
  803423:	85 c0                	test   %eax,%eax
  803425:	74 0d                	je     803434 <realloc_block_FF+0x2a9>
  803427:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80342c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80342f:	89 50 04             	mov    %edx,0x4(%eax)
  803432:	eb 08                	jmp    80343c <realloc_block_FF+0x2b1>
  803434:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803437:	a3 30 50 80 00       	mov    %eax,0x805030
  80343c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80343f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803444:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803447:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80344e:	a1 38 50 80 00       	mov    0x805038,%eax
  803453:	40                   	inc    %eax
  803454:	a3 38 50 80 00       	mov    %eax,0x805038
  803459:	e9 b0 01 00 00       	jmp    80360e <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80345e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803463:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803466:	76 68                	jbe    8034d0 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803468:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80346c:	75 17                	jne    803485 <realloc_block_FF+0x2fa>
  80346e:	83 ec 04             	sub    $0x4,%esp
  803471:	68 ac 44 80 00       	push   $0x8044ac
  803476:	68 0b 02 00 00       	push   $0x20b
  80347b:	68 91 44 80 00       	push   $0x804491
  803480:	e8 fd cd ff ff       	call   800282 <_panic>
  803485:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80348b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80348e:	89 10                	mov    %edx,(%eax)
  803490:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803493:	8b 00                	mov    (%eax),%eax
  803495:	85 c0                	test   %eax,%eax
  803497:	74 0d                	je     8034a6 <realloc_block_FF+0x31b>
  803499:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80349e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034a1:	89 50 04             	mov    %edx,0x4(%eax)
  8034a4:	eb 08                	jmp    8034ae <realloc_block_FF+0x323>
  8034a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034a9:	a3 30 50 80 00       	mov    %eax,0x805030
  8034ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034b1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c0:	a1 38 50 80 00       	mov    0x805038,%eax
  8034c5:	40                   	inc    %eax
  8034c6:	a3 38 50 80 00       	mov    %eax,0x805038
  8034cb:	e9 3e 01 00 00       	jmp    80360e <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8034d0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034d5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034d8:	73 68                	jae    803542 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034da:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034de:	75 17                	jne    8034f7 <realloc_block_FF+0x36c>
  8034e0:	83 ec 04             	sub    $0x4,%esp
  8034e3:	68 e0 44 80 00       	push   $0x8044e0
  8034e8:	68 10 02 00 00       	push   $0x210
  8034ed:	68 91 44 80 00       	push   $0x804491
  8034f2:	e8 8b cd ff ff       	call   800282 <_panic>
  8034f7:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8034fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803500:	89 50 04             	mov    %edx,0x4(%eax)
  803503:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803506:	8b 40 04             	mov    0x4(%eax),%eax
  803509:	85 c0                	test   %eax,%eax
  80350b:	74 0c                	je     803519 <realloc_block_FF+0x38e>
  80350d:	a1 30 50 80 00       	mov    0x805030,%eax
  803512:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803515:	89 10                	mov    %edx,(%eax)
  803517:	eb 08                	jmp    803521 <realloc_block_FF+0x396>
  803519:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80351c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803521:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803524:	a3 30 50 80 00       	mov    %eax,0x805030
  803529:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80352c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803532:	a1 38 50 80 00       	mov    0x805038,%eax
  803537:	40                   	inc    %eax
  803538:	a3 38 50 80 00       	mov    %eax,0x805038
  80353d:	e9 cc 00 00 00       	jmp    80360e <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803542:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803549:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80354e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803551:	e9 8a 00 00 00       	jmp    8035e0 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803559:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80355c:	73 7a                	jae    8035d8 <realloc_block_FF+0x44d>
  80355e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803561:	8b 00                	mov    (%eax),%eax
  803563:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803566:	73 70                	jae    8035d8 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803568:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80356c:	74 06                	je     803574 <realloc_block_FF+0x3e9>
  80356e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803572:	75 17                	jne    80358b <realloc_block_FF+0x400>
  803574:	83 ec 04             	sub    $0x4,%esp
  803577:	68 04 45 80 00       	push   $0x804504
  80357c:	68 1a 02 00 00       	push   $0x21a
  803581:	68 91 44 80 00       	push   $0x804491
  803586:	e8 f7 cc ff ff       	call   800282 <_panic>
  80358b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358e:	8b 10                	mov    (%eax),%edx
  803590:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803593:	89 10                	mov    %edx,(%eax)
  803595:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803598:	8b 00                	mov    (%eax),%eax
  80359a:	85 c0                	test   %eax,%eax
  80359c:	74 0b                	je     8035a9 <realloc_block_FF+0x41e>
  80359e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a1:	8b 00                	mov    (%eax),%eax
  8035a3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035a6:	89 50 04             	mov    %edx,0x4(%eax)
  8035a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ac:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035af:	89 10                	mov    %edx,(%eax)
  8035b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035b7:	89 50 04             	mov    %edx,0x4(%eax)
  8035ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035bd:	8b 00                	mov    (%eax),%eax
  8035bf:	85 c0                	test   %eax,%eax
  8035c1:	75 08                	jne    8035cb <realloc_block_FF+0x440>
  8035c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c6:	a3 30 50 80 00       	mov    %eax,0x805030
  8035cb:	a1 38 50 80 00       	mov    0x805038,%eax
  8035d0:	40                   	inc    %eax
  8035d1:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8035d6:	eb 36                	jmp    80360e <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8035d8:	a1 34 50 80 00       	mov    0x805034,%eax
  8035dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035e4:	74 07                	je     8035ed <realloc_block_FF+0x462>
  8035e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e9:	8b 00                	mov    (%eax),%eax
  8035eb:	eb 05                	jmp    8035f2 <realloc_block_FF+0x467>
  8035ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8035f2:	a3 34 50 80 00       	mov    %eax,0x805034
  8035f7:	a1 34 50 80 00       	mov    0x805034,%eax
  8035fc:	85 c0                	test   %eax,%eax
  8035fe:	0f 85 52 ff ff ff    	jne    803556 <realloc_block_FF+0x3cb>
  803604:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803608:	0f 85 48 ff ff ff    	jne    803556 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80360e:	83 ec 04             	sub    $0x4,%esp
  803611:	6a 00                	push   $0x0
  803613:	ff 75 d8             	pushl  -0x28(%ebp)
  803616:	ff 75 d4             	pushl  -0x2c(%ebp)
  803619:	e8 7a eb ff ff       	call   802198 <set_block_data>
  80361e:	83 c4 10             	add    $0x10,%esp
				return va;
  803621:	8b 45 08             	mov    0x8(%ebp),%eax
  803624:	e9 7b 02 00 00       	jmp    8038a4 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803629:	83 ec 0c             	sub    $0xc,%esp
  80362c:	68 81 45 80 00       	push   $0x804581
  803631:	e8 09 cf ff ff       	call   80053f <cprintf>
  803636:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803639:	8b 45 08             	mov    0x8(%ebp),%eax
  80363c:	e9 63 02 00 00       	jmp    8038a4 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803641:	8b 45 0c             	mov    0xc(%ebp),%eax
  803644:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803647:	0f 86 4d 02 00 00    	jbe    80389a <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80364d:	83 ec 0c             	sub    $0xc,%esp
  803650:	ff 75 e4             	pushl  -0x1c(%ebp)
  803653:	e8 08 e8 ff ff       	call   801e60 <is_free_block>
  803658:	83 c4 10             	add    $0x10,%esp
  80365b:	84 c0                	test   %al,%al
  80365d:	0f 84 37 02 00 00    	je     80389a <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803663:	8b 45 0c             	mov    0xc(%ebp),%eax
  803666:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803669:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80366c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80366f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803672:	76 38                	jbe    8036ac <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803674:	83 ec 0c             	sub    $0xc,%esp
  803677:	ff 75 08             	pushl  0x8(%ebp)
  80367a:	e8 0c fa ff ff       	call   80308b <free_block>
  80367f:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803682:	83 ec 0c             	sub    $0xc,%esp
  803685:	ff 75 0c             	pushl  0xc(%ebp)
  803688:	e8 3a eb ff ff       	call   8021c7 <alloc_block_FF>
  80368d:	83 c4 10             	add    $0x10,%esp
  803690:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803693:	83 ec 08             	sub    $0x8,%esp
  803696:	ff 75 c0             	pushl  -0x40(%ebp)
  803699:	ff 75 08             	pushl  0x8(%ebp)
  80369c:	e8 ab fa ff ff       	call   80314c <copy_data>
  8036a1:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8036a4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8036a7:	e9 f8 01 00 00       	jmp    8038a4 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8036ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036af:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8036b2:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8036b5:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8036b9:	0f 87 a0 00 00 00    	ja     80375f <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8036bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036c3:	75 17                	jne    8036dc <realloc_block_FF+0x551>
  8036c5:	83 ec 04             	sub    $0x4,%esp
  8036c8:	68 73 44 80 00       	push   $0x804473
  8036cd:	68 38 02 00 00       	push   $0x238
  8036d2:	68 91 44 80 00       	push   $0x804491
  8036d7:	e8 a6 cb ff ff       	call   800282 <_panic>
  8036dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036df:	8b 00                	mov    (%eax),%eax
  8036e1:	85 c0                	test   %eax,%eax
  8036e3:	74 10                	je     8036f5 <realloc_block_FF+0x56a>
  8036e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e8:	8b 00                	mov    (%eax),%eax
  8036ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036ed:	8b 52 04             	mov    0x4(%edx),%edx
  8036f0:	89 50 04             	mov    %edx,0x4(%eax)
  8036f3:	eb 0b                	jmp    803700 <realloc_block_FF+0x575>
  8036f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f8:	8b 40 04             	mov    0x4(%eax),%eax
  8036fb:	a3 30 50 80 00       	mov    %eax,0x805030
  803700:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803703:	8b 40 04             	mov    0x4(%eax),%eax
  803706:	85 c0                	test   %eax,%eax
  803708:	74 0f                	je     803719 <realloc_block_FF+0x58e>
  80370a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80370d:	8b 40 04             	mov    0x4(%eax),%eax
  803710:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803713:	8b 12                	mov    (%edx),%edx
  803715:	89 10                	mov    %edx,(%eax)
  803717:	eb 0a                	jmp    803723 <realloc_block_FF+0x598>
  803719:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80371c:	8b 00                	mov    (%eax),%eax
  80371e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803726:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80372c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80372f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803736:	a1 38 50 80 00       	mov    0x805038,%eax
  80373b:	48                   	dec    %eax
  80373c:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803741:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803744:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803747:	01 d0                	add    %edx,%eax
  803749:	83 ec 04             	sub    $0x4,%esp
  80374c:	6a 01                	push   $0x1
  80374e:	50                   	push   %eax
  80374f:	ff 75 08             	pushl  0x8(%ebp)
  803752:	e8 41 ea ff ff       	call   802198 <set_block_data>
  803757:	83 c4 10             	add    $0x10,%esp
  80375a:	e9 36 01 00 00       	jmp    803895 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80375f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803762:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803765:	01 d0                	add    %edx,%eax
  803767:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80376a:	83 ec 04             	sub    $0x4,%esp
  80376d:	6a 01                	push   $0x1
  80376f:	ff 75 f0             	pushl  -0x10(%ebp)
  803772:	ff 75 08             	pushl  0x8(%ebp)
  803775:	e8 1e ea ff ff       	call   802198 <set_block_data>
  80377a:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80377d:	8b 45 08             	mov    0x8(%ebp),%eax
  803780:	83 e8 04             	sub    $0x4,%eax
  803783:	8b 00                	mov    (%eax),%eax
  803785:	83 e0 fe             	and    $0xfffffffe,%eax
  803788:	89 c2                	mov    %eax,%edx
  80378a:	8b 45 08             	mov    0x8(%ebp),%eax
  80378d:	01 d0                	add    %edx,%eax
  80378f:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803792:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803796:	74 06                	je     80379e <realloc_block_FF+0x613>
  803798:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80379c:	75 17                	jne    8037b5 <realloc_block_FF+0x62a>
  80379e:	83 ec 04             	sub    $0x4,%esp
  8037a1:	68 04 45 80 00       	push   $0x804504
  8037a6:	68 44 02 00 00       	push   $0x244
  8037ab:	68 91 44 80 00       	push   $0x804491
  8037b0:	e8 cd ca ff ff       	call   800282 <_panic>
  8037b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b8:	8b 10                	mov    (%eax),%edx
  8037ba:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037bd:	89 10                	mov    %edx,(%eax)
  8037bf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037c2:	8b 00                	mov    (%eax),%eax
  8037c4:	85 c0                	test   %eax,%eax
  8037c6:	74 0b                	je     8037d3 <realloc_block_FF+0x648>
  8037c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037cb:	8b 00                	mov    (%eax),%eax
  8037cd:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037d0:	89 50 04             	mov    %edx,0x4(%eax)
  8037d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d6:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037d9:	89 10                	mov    %edx,(%eax)
  8037db:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037e1:	89 50 04             	mov    %edx,0x4(%eax)
  8037e4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037e7:	8b 00                	mov    (%eax),%eax
  8037e9:	85 c0                	test   %eax,%eax
  8037eb:	75 08                	jne    8037f5 <realloc_block_FF+0x66a>
  8037ed:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037f0:	a3 30 50 80 00       	mov    %eax,0x805030
  8037f5:	a1 38 50 80 00       	mov    0x805038,%eax
  8037fa:	40                   	inc    %eax
  8037fb:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803800:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803804:	75 17                	jne    80381d <realloc_block_FF+0x692>
  803806:	83 ec 04             	sub    $0x4,%esp
  803809:	68 73 44 80 00       	push   $0x804473
  80380e:	68 45 02 00 00       	push   $0x245
  803813:	68 91 44 80 00       	push   $0x804491
  803818:	e8 65 ca ff ff       	call   800282 <_panic>
  80381d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803820:	8b 00                	mov    (%eax),%eax
  803822:	85 c0                	test   %eax,%eax
  803824:	74 10                	je     803836 <realloc_block_FF+0x6ab>
  803826:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803829:	8b 00                	mov    (%eax),%eax
  80382b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80382e:	8b 52 04             	mov    0x4(%edx),%edx
  803831:	89 50 04             	mov    %edx,0x4(%eax)
  803834:	eb 0b                	jmp    803841 <realloc_block_FF+0x6b6>
  803836:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803839:	8b 40 04             	mov    0x4(%eax),%eax
  80383c:	a3 30 50 80 00       	mov    %eax,0x805030
  803841:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803844:	8b 40 04             	mov    0x4(%eax),%eax
  803847:	85 c0                	test   %eax,%eax
  803849:	74 0f                	je     80385a <realloc_block_FF+0x6cf>
  80384b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384e:	8b 40 04             	mov    0x4(%eax),%eax
  803851:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803854:	8b 12                	mov    (%edx),%edx
  803856:	89 10                	mov    %edx,(%eax)
  803858:	eb 0a                	jmp    803864 <realloc_block_FF+0x6d9>
  80385a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80385d:	8b 00                	mov    (%eax),%eax
  80385f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803864:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803867:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80386d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803870:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803877:	a1 38 50 80 00       	mov    0x805038,%eax
  80387c:	48                   	dec    %eax
  80387d:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803882:	83 ec 04             	sub    $0x4,%esp
  803885:	6a 00                	push   $0x0
  803887:	ff 75 bc             	pushl  -0x44(%ebp)
  80388a:	ff 75 b8             	pushl  -0x48(%ebp)
  80388d:	e8 06 e9 ff ff       	call   802198 <set_block_data>
  803892:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803895:	8b 45 08             	mov    0x8(%ebp),%eax
  803898:	eb 0a                	jmp    8038a4 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80389a:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8038a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8038a4:	c9                   	leave  
  8038a5:	c3                   	ret    

008038a6 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8038a6:	55                   	push   %ebp
  8038a7:	89 e5                	mov    %esp,%ebp
  8038a9:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8038ac:	83 ec 04             	sub    $0x4,%esp
  8038af:	68 88 45 80 00       	push   $0x804588
  8038b4:	68 58 02 00 00       	push   $0x258
  8038b9:	68 91 44 80 00       	push   $0x804491
  8038be:	e8 bf c9 ff ff       	call   800282 <_panic>

008038c3 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8038c3:	55                   	push   %ebp
  8038c4:	89 e5                	mov    %esp,%ebp
  8038c6:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8038c9:	83 ec 04             	sub    $0x4,%esp
  8038cc:	68 b0 45 80 00       	push   $0x8045b0
  8038d1:	68 61 02 00 00       	push   $0x261
  8038d6:	68 91 44 80 00       	push   $0x804491
  8038db:	e8 a2 c9 ff ff       	call   800282 <_panic>

008038e0 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8038e0:	55                   	push   %ebp
  8038e1:	89 e5                	mov    %esp,%ebp
  8038e3:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8038e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8038e9:	89 d0                	mov    %edx,%eax
  8038eb:	c1 e0 02             	shl    $0x2,%eax
  8038ee:	01 d0                	add    %edx,%eax
  8038f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038f7:	01 d0                	add    %edx,%eax
  8038f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803900:	01 d0                	add    %edx,%eax
  803902:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803909:	01 d0                	add    %edx,%eax
  80390b:	c1 e0 04             	shl    $0x4,%eax
  80390e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803911:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803918:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80391b:	83 ec 0c             	sub    $0xc,%esp
  80391e:	50                   	push   %eax
  80391f:	e8 2f e2 ff ff       	call   801b53 <sys_get_virtual_time>
  803924:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803927:	eb 41                	jmp    80396a <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803929:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80392c:	83 ec 0c             	sub    $0xc,%esp
  80392f:	50                   	push   %eax
  803930:	e8 1e e2 ff ff       	call   801b53 <sys_get_virtual_time>
  803935:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803938:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80393b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80393e:	29 c2                	sub    %eax,%edx
  803940:	89 d0                	mov    %edx,%eax
  803942:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803945:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803948:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80394b:	89 d1                	mov    %edx,%ecx
  80394d:	29 c1                	sub    %eax,%ecx
  80394f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803952:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803955:	39 c2                	cmp    %eax,%edx
  803957:	0f 97 c0             	seta   %al
  80395a:	0f b6 c0             	movzbl %al,%eax
  80395d:	29 c1                	sub    %eax,%ecx
  80395f:	89 c8                	mov    %ecx,%eax
  803961:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803964:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803967:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80396a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80396d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803970:	72 b7                	jb     803929 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803972:	90                   	nop
  803973:	c9                   	leave  
  803974:	c3                   	ret    

00803975 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803975:	55                   	push   %ebp
  803976:	89 e5                	mov    %esp,%ebp
  803978:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80397b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803982:	eb 03                	jmp    803987 <busy_wait+0x12>
  803984:	ff 45 fc             	incl   -0x4(%ebp)
  803987:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80398a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80398d:	72 f5                	jb     803984 <busy_wait+0xf>
	return i;
  80398f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803992:	c9                   	leave  
  803993:	c3                   	ret    

00803994 <__udivdi3>:
  803994:	55                   	push   %ebp
  803995:	57                   	push   %edi
  803996:	56                   	push   %esi
  803997:	53                   	push   %ebx
  803998:	83 ec 1c             	sub    $0x1c,%esp
  80399b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80399f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039ab:	89 ca                	mov    %ecx,%edx
  8039ad:	89 f8                	mov    %edi,%eax
  8039af:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039b3:	85 f6                	test   %esi,%esi
  8039b5:	75 2d                	jne    8039e4 <__udivdi3+0x50>
  8039b7:	39 cf                	cmp    %ecx,%edi
  8039b9:	77 65                	ja     803a20 <__udivdi3+0x8c>
  8039bb:	89 fd                	mov    %edi,%ebp
  8039bd:	85 ff                	test   %edi,%edi
  8039bf:	75 0b                	jne    8039cc <__udivdi3+0x38>
  8039c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8039c6:	31 d2                	xor    %edx,%edx
  8039c8:	f7 f7                	div    %edi
  8039ca:	89 c5                	mov    %eax,%ebp
  8039cc:	31 d2                	xor    %edx,%edx
  8039ce:	89 c8                	mov    %ecx,%eax
  8039d0:	f7 f5                	div    %ebp
  8039d2:	89 c1                	mov    %eax,%ecx
  8039d4:	89 d8                	mov    %ebx,%eax
  8039d6:	f7 f5                	div    %ebp
  8039d8:	89 cf                	mov    %ecx,%edi
  8039da:	89 fa                	mov    %edi,%edx
  8039dc:	83 c4 1c             	add    $0x1c,%esp
  8039df:	5b                   	pop    %ebx
  8039e0:	5e                   	pop    %esi
  8039e1:	5f                   	pop    %edi
  8039e2:	5d                   	pop    %ebp
  8039e3:	c3                   	ret    
  8039e4:	39 ce                	cmp    %ecx,%esi
  8039e6:	77 28                	ja     803a10 <__udivdi3+0x7c>
  8039e8:	0f bd fe             	bsr    %esi,%edi
  8039eb:	83 f7 1f             	xor    $0x1f,%edi
  8039ee:	75 40                	jne    803a30 <__udivdi3+0x9c>
  8039f0:	39 ce                	cmp    %ecx,%esi
  8039f2:	72 0a                	jb     8039fe <__udivdi3+0x6a>
  8039f4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8039f8:	0f 87 9e 00 00 00    	ja     803a9c <__udivdi3+0x108>
  8039fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803a03:	89 fa                	mov    %edi,%edx
  803a05:	83 c4 1c             	add    $0x1c,%esp
  803a08:	5b                   	pop    %ebx
  803a09:	5e                   	pop    %esi
  803a0a:	5f                   	pop    %edi
  803a0b:	5d                   	pop    %ebp
  803a0c:	c3                   	ret    
  803a0d:	8d 76 00             	lea    0x0(%esi),%esi
  803a10:	31 ff                	xor    %edi,%edi
  803a12:	31 c0                	xor    %eax,%eax
  803a14:	89 fa                	mov    %edi,%edx
  803a16:	83 c4 1c             	add    $0x1c,%esp
  803a19:	5b                   	pop    %ebx
  803a1a:	5e                   	pop    %esi
  803a1b:	5f                   	pop    %edi
  803a1c:	5d                   	pop    %ebp
  803a1d:	c3                   	ret    
  803a1e:	66 90                	xchg   %ax,%ax
  803a20:	89 d8                	mov    %ebx,%eax
  803a22:	f7 f7                	div    %edi
  803a24:	31 ff                	xor    %edi,%edi
  803a26:	89 fa                	mov    %edi,%edx
  803a28:	83 c4 1c             	add    $0x1c,%esp
  803a2b:	5b                   	pop    %ebx
  803a2c:	5e                   	pop    %esi
  803a2d:	5f                   	pop    %edi
  803a2e:	5d                   	pop    %ebp
  803a2f:	c3                   	ret    
  803a30:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a35:	89 eb                	mov    %ebp,%ebx
  803a37:	29 fb                	sub    %edi,%ebx
  803a39:	89 f9                	mov    %edi,%ecx
  803a3b:	d3 e6                	shl    %cl,%esi
  803a3d:	89 c5                	mov    %eax,%ebp
  803a3f:	88 d9                	mov    %bl,%cl
  803a41:	d3 ed                	shr    %cl,%ebp
  803a43:	89 e9                	mov    %ebp,%ecx
  803a45:	09 f1                	or     %esi,%ecx
  803a47:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a4b:	89 f9                	mov    %edi,%ecx
  803a4d:	d3 e0                	shl    %cl,%eax
  803a4f:	89 c5                	mov    %eax,%ebp
  803a51:	89 d6                	mov    %edx,%esi
  803a53:	88 d9                	mov    %bl,%cl
  803a55:	d3 ee                	shr    %cl,%esi
  803a57:	89 f9                	mov    %edi,%ecx
  803a59:	d3 e2                	shl    %cl,%edx
  803a5b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a5f:	88 d9                	mov    %bl,%cl
  803a61:	d3 e8                	shr    %cl,%eax
  803a63:	09 c2                	or     %eax,%edx
  803a65:	89 d0                	mov    %edx,%eax
  803a67:	89 f2                	mov    %esi,%edx
  803a69:	f7 74 24 0c          	divl   0xc(%esp)
  803a6d:	89 d6                	mov    %edx,%esi
  803a6f:	89 c3                	mov    %eax,%ebx
  803a71:	f7 e5                	mul    %ebp
  803a73:	39 d6                	cmp    %edx,%esi
  803a75:	72 19                	jb     803a90 <__udivdi3+0xfc>
  803a77:	74 0b                	je     803a84 <__udivdi3+0xf0>
  803a79:	89 d8                	mov    %ebx,%eax
  803a7b:	31 ff                	xor    %edi,%edi
  803a7d:	e9 58 ff ff ff       	jmp    8039da <__udivdi3+0x46>
  803a82:	66 90                	xchg   %ax,%ax
  803a84:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a88:	89 f9                	mov    %edi,%ecx
  803a8a:	d3 e2                	shl    %cl,%edx
  803a8c:	39 c2                	cmp    %eax,%edx
  803a8e:	73 e9                	jae    803a79 <__udivdi3+0xe5>
  803a90:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a93:	31 ff                	xor    %edi,%edi
  803a95:	e9 40 ff ff ff       	jmp    8039da <__udivdi3+0x46>
  803a9a:	66 90                	xchg   %ax,%ax
  803a9c:	31 c0                	xor    %eax,%eax
  803a9e:	e9 37 ff ff ff       	jmp    8039da <__udivdi3+0x46>
  803aa3:	90                   	nop

00803aa4 <__umoddi3>:
  803aa4:	55                   	push   %ebp
  803aa5:	57                   	push   %edi
  803aa6:	56                   	push   %esi
  803aa7:	53                   	push   %ebx
  803aa8:	83 ec 1c             	sub    $0x1c,%esp
  803aab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803aaf:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ab3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ab7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803abb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803abf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ac3:	89 f3                	mov    %esi,%ebx
  803ac5:	89 fa                	mov    %edi,%edx
  803ac7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803acb:	89 34 24             	mov    %esi,(%esp)
  803ace:	85 c0                	test   %eax,%eax
  803ad0:	75 1a                	jne    803aec <__umoddi3+0x48>
  803ad2:	39 f7                	cmp    %esi,%edi
  803ad4:	0f 86 a2 00 00 00    	jbe    803b7c <__umoddi3+0xd8>
  803ada:	89 c8                	mov    %ecx,%eax
  803adc:	89 f2                	mov    %esi,%edx
  803ade:	f7 f7                	div    %edi
  803ae0:	89 d0                	mov    %edx,%eax
  803ae2:	31 d2                	xor    %edx,%edx
  803ae4:	83 c4 1c             	add    $0x1c,%esp
  803ae7:	5b                   	pop    %ebx
  803ae8:	5e                   	pop    %esi
  803ae9:	5f                   	pop    %edi
  803aea:	5d                   	pop    %ebp
  803aeb:	c3                   	ret    
  803aec:	39 f0                	cmp    %esi,%eax
  803aee:	0f 87 ac 00 00 00    	ja     803ba0 <__umoddi3+0xfc>
  803af4:	0f bd e8             	bsr    %eax,%ebp
  803af7:	83 f5 1f             	xor    $0x1f,%ebp
  803afa:	0f 84 ac 00 00 00    	je     803bac <__umoddi3+0x108>
  803b00:	bf 20 00 00 00       	mov    $0x20,%edi
  803b05:	29 ef                	sub    %ebp,%edi
  803b07:	89 fe                	mov    %edi,%esi
  803b09:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b0d:	89 e9                	mov    %ebp,%ecx
  803b0f:	d3 e0                	shl    %cl,%eax
  803b11:	89 d7                	mov    %edx,%edi
  803b13:	89 f1                	mov    %esi,%ecx
  803b15:	d3 ef                	shr    %cl,%edi
  803b17:	09 c7                	or     %eax,%edi
  803b19:	89 e9                	mov    %ebp,%ecx
  803b1b:	d3 e2                	shl    %cl,%edx
  803b1d:	89 14 24             	mov    %edx,(%esp)
  803b20:	89 d8                	mov    %ebx,%eax
  803b22:	d3 e0                	shl    %cl,%eax
  803b24:	89 c2                	mov    %eax,%edx
  803b26:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b2a:	d3 e0                	shl    %cl,%eax
  803b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b30:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b34:	89 f1                	mov    %esi,%ecx
  803b36:	d3 e8                	shr    %cl,%eax
  803b38:	09 d0                	or     %edx,%eax
  803b3a:	d3 eb                	shr    %cl,%ebx
  803b3c:	89 da                	mov    %ebx,%edx
  803b3e:	f7 f7                	div    %edi
  803b40:	89 d3                	mov    %edx,%ebx
  803b42:	f7 24 24             	mull   (%esp)
  803b45:	89 c6                	mov    %eax,%esi
  803b47:	89 d1                	mov    %edx,%ecx
  803b49:	39 d3                	cmp    %edx,%ebx
  803b4b:	0f 82 87 00 00 00    	jb     803bd8 <__umoddi3+0x134>
  803b51:	0f 84 91 00 00 00    	je     803be8 <__umoddi3+0x144>
  803b57:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b5b:	29 f2                	sub    %esi,%edx
  803b5d:	19 cb                	sbb    %ecx,%ebx
  803b5f:	89 d8                	mov    %ebx,%eax
  803b61:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b65:	d3 e0                	shl    %cl,%eax
  803b67:	89 e9                	mov    %ebp,%ecx
  803b69:	d3 ea                	shr    %cl,%edx
  803b6b:	09 d0                	or     %edx,%eax
  803b6d:	89 e9                	mov    %ebp,%ecx
  803b6f:	d3 eb                	shr    %cl,%ebx
  803b71:	89 da                	mov    %ebx,%edx
  803b73:	83 c4 1c             	add    $0x1c,%esp
  803b76:	5b                   	pop    %ebx
  803b77:	5e                   	pop    %esi
  803b78:	5f                   	pop    %edi
  803b79:	5d                   	pop    %ebp
  803b7a:	c3                   	ret    
  803b7b:	90                   	nop
  803b7c:	89 fd                	mov    %edi,%ebp
  803b7e:	85 ff                	test   %edi,%edi
  803b80:	75 0b                	jne    803b8d <__umoddi3+0xe9>
  803b82:	b8 01 00 00 00       	mov    $0x1,%eax
  803b87:	31 d2                	xor    %edx,%edx
  803b89:	f7 f7                	div    %edi
  803b8b:	89 c5                	mov    %eax,%ebp
  803b8d:	89 f0                	mov    %esi,%eax
  803b8f:	31 d2                	xor    %edx,%edx
  803b91:	f7 f5                	div    %ebp
  803b93:	89 c8                	mov    %ecx,%eax
  803b95:	f7 f5                	div    %ebp
  803b97:	89 d0                	mov    %edx,%eax
  803b99:	e9 44 ff ff ff       	jmp    803ae2 <__umoddi3+0x3e>
  803b9e:	66 90                	xchg   %ax,%ax
  803ba0:	89 c8                	mov    %ecx,%eax
  803ba2:	89 f2                	mov    %esi,%edx
  803ba4:	83 c4 1c             	add    $0x1c,%esp
  803ba7:	5b                   	pop    %ebx
  803ba8:	5e                   	pop    %esi
  803ba9:	5f                   	pop    %edi
  803baa:	5d                   	pop    %ebp
  803bab:	c3                   	ret    
  803bac:	3b 04 24             	cmp    (%esp),%eax
  803baf:	72 06                	jb     803bb7 <__umoddi3+0x113>
  803bb1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803bb5:	77 0f                	ja     803bc6 <__umoddi3+0x122>
  803bb7:	89 f2                	mov    %esi,%edx
  803bb9:	29 f9                	sub    %edi,%ecx
  803bbb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803bbf:	89 14 24             	mov    %edx,(%esp)
  803bc2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bc6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803bca:	8b 14 24             	mov    (%esp),%edx
  803bcd:	83 c4 1c             	add    $0x1c,%esp
  803bd0:	5b                   	pop    %ebx
  803bd1:	5e                   	pop    %esi
  803bd2:	5f                   	pop    %edi
  803bd3:	5d                   	pop    %ebp
  803bd4:	c3                   	ret    
  803bd5:	8d 76 00             	lea    0x0(%esi),%esi
  803bd8:	2b 04 24             	sub    (%esp),%eax
  803bdb:	19 fa                	sbb    %edi,%edx
  803bdd:	89 d1                	mov    %edx,%ecx
  803bdf:	89 c6                	mov    %eax,%esi
  803be1:	e9 71 ff ff ff       	jmp    803b57 <__umoddi3+0xb3>
  803be6:	66 90                	xchg   %ax,%ax
  803be8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803bec:	72 ea                	jb     803bd8 <__umoddi3+0x134>
  803bee:	89 d9                	mov    %ebx,%ecx
  803bf0:	e9 62 ff ff ff       	jmp    803b57 <__umoddi3+0xb3>
