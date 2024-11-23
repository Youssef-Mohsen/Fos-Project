
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
  80005b:	68 80 3b 80 00       	push   $0x803b80
  800060:	6a 0c                	push   $0xc
  800062:	68 9c 3b 80 00       	push   $0x803b9c
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
  800073:	e8 2b 1a 00 00       	call   801aa3 <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 b9 3b 80 00       	push   $0x803bb9
  800080:	50                   	push   %eax
  800081:	e8 05 16 00 00       	call   80168b <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 bc 3b 80 00       	push   $0x803bbc
  800094:	e8 a6 04 00 00       	call   80053f <cprintf>
  800099:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got z
	inctst();
  80009c:	e8 27 1b 00 00       	call   801bc8 <inctst>

	cprintf("Slave B2 please be patient ...\n");
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	68 e4 3b 80 00       	push   $0x803be4
  8000a9:	e8 91 04 00 00       	call   80053f <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 28 23 00 00       	push   $0x2328
  8000b9:	e8 a5 37 00 00       	call   803863 <env_sleep>
  8000be:	83 c4 10             	add    $0x10,%esp
	//to ensure that the other environments completed successfully
	while (gettst()!=3) ;// panic("test failed");
  8000c1:	90                   	nop
  8000c2:	e8 1b 1b 00 00       	call   801be2 <gettst>
  8000c7:	83 f8 03             	cmp    $0x3,%eax
  8000ca:	75 f6                	jne    8000c2 <_main+0x8a>

	freeFrames = sys_calculate_free_frames() ;
  8000cc:	e8 f0 17 00 00       	call   8018c1 <sys_calculate_free_frames>
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	sfree(z);
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000da:	e8 31 16 00 00       	call   801710 <sfree>
  8000df:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 04 3c 80 00       	push   $0x803c04
  8000ea:	e8 50 04 00 00       	call   80053f <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
	expected = 1+1; /*1page+1table*/
  8000f2:	c7 45 e8 02 00 00 00 	movl   $0x2,-0x18(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  8000f9:	e8 c3 17 00 00       	call   8018c1 <sys_calculate_free_frames>
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800103:	29 c2                	sub    %eax,%edx
  800105:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800108:	39 c2                	cmp    %eax,%edx
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 1c 3c 80 00       	push   $0x803c1c
  800114:	6a 28                	push   $0x28
  800116:	68 9c 3b 80 00       	push   $0x803b9c
  80011b:	e8 62 01 00 00       	call   800282 <_panic>


	cprintf("Step B completed successfully!!\n\n\n");
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	68 bc 3c 80 00       	push   $0x803cbc
  800128:	e8 12 04 00 00       	call   80053f <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n%~Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 e0 3c 80 00       	push   $0x803ce0
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
  800149:	e8 3c 19 00 00       	call   801a8a <sys_getenvindex>
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
  8001b7:	e8 52 16 00 00       	call   80180e <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	68 48 3d 80 00       	push   $0x803d48
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
  8001e7:	68 70 3d 80 00       	push   $0x803d70
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
  800218:	68 98 3d 80 00       	push   $0x803d98
  80021d:	e8 1d 03 00 00       	call   80053f <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800225:	a1 20 50 80 00       	mov    0x805020,%eax
  80022a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	50                   	push   %eax
  800234:	68 f0 3d 80 00       	push   $0x803df0
  800239:	e8 01 03 00 00       	call   80053f <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	68 48 3d 80 00       	push   $0x803d48
  800249:	e8 f1 02 00 00       	call   80053f <cprintf>
  80024e:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800251:	e8 d2 15 00 00       	call   801828 <sys_unlock_cons>
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
  800269:	e8 e8 17 00 00       	call   801a56 <sys_destroy_env>
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
  80027a:	e8 3d 18 00 00       	call   801abc <sys_exit_env>
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
  8002a3:	68 04 3e 80 00       	push   $0x803e04
  8002a8:	e8 92 02 00 00       	call   80053f <cprintf>
  8002ad:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b0:	a1 00 50 80 00       	mov    0x805000,%eax
  8002b5:	ff 75 0c             	pushl  0xc(%ebp)
  8002b8:	ff 75 08             	pushl  0x8(%ebp)
  8002bb:	50                   	push   %eax
  8002bc:	68 09 3e 80 00       	push   $0x803e09
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
  8002e0:	68 25 3e 80 00       	push   $0x803e25
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
  80030f:	68 28 3e 80 00       	push   $0x803e28
  800314:	6a 26                	push   $0x26
  800316:	68 74 3e 80 00       	push   $0x803e74
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
  8003e4:	68 80 3e 80 00       	push   $0x803e80
  8003e9:	6a 3a                	push   $0x3a
  8003eb:	68 74 3e 80 00       	push   $0x803e74
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
  800457:	68 d4 3e 80 00       	push   $0x803ed4
  80045c:	6a 44                	push   $0x44
  80045e:	68 74 3e 80 00       	push   $0x803e74
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
  8004b1:	e8 16 13 00 00       	call   8017cc <sys_cputs>
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
  800528:	e8 9f 12 00 00       	call   8017cc <sys_cputs>
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
  800572:	e8 97 12 00 00       	call   80180e <sys_lock_cons>
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
  800592:	e8 91 12 00 00       	call   801828 <sys_unlock_cons>
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
  8005dc:	e8 37 33 00 00       	call   803918 <__udivdi3>
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
  80062c:	e8 f7 33 00 00       	call   803a28 <__umoddi3>
  800631:	83 c4 10             	add    $0x10,%esp
  800634:	05 34 41 80 00       	add    $0x804134,%eax
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
  800787:	8b 04 85 58 41 80 00 	mov    0x804158(,%eax,4),%eax
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
  800868:	8b 34 9d a0 3f 80 00 	mov    0x803fa0(,%ebx,4),%esi
  80086f:	85 f6                	test   %esi,%esi
  800871:	75 19                	jne    80088c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800873:	53                   	push   %ebx
  800874:	68 45 41 80 00       	push   $0x804145
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
  80088d:	68 4e 41 80 00       	push   $0x80414e
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
  8008ba:	be 51 41 80 00       	mov    $0x804151,%esi
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
  8012c5:	68 c8 42 80 00       	push   $0x8042c8
  8012ca:	68 3f 01 00 00       	push   $0x13f
  8012cf:	68 ea 42 80 00       	push   $0x8042ea
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
  8012e5:	e8 8d 0a 00 00       	call   801d77 <sys_sbrk>
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
  801360:	e8 96 08 00 00       	call   801bfb <sys_isUHeapPlacementStrategyFIRSTFIT>
  801365:	85 c0                	test   %eax,%eax
  801367:	74 16                	je     80137f <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801369:	83 ec 0c             	sub    $0xc,%esp
  80136c:	ff 75 08             	pushl  0x8(%ebp)
  80136f:	e8 d6 0d 00 00       	call   80214a <alloc_block_FF>
  801374:	83 c4 10             	add    $0x10,%esp
  801377:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80137a:	e9 8a 01 00 00       	jmp    801509 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80137f:	e8 a8 08 00 00       	call   801c2c <sys_isUHeapPlacementStrategyBESTFIT>
  801384:	85 c0                	test   %eax,%eax
  801386:	0f 84 7d 01 00 00    	je     801509 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80138c:	83 ec 0c             	sub    $0xc,%esp
  80138f:	ff 75 08             	pushl  0x8(%ebp)
  801392:	e8 6f 12 00 00       	call   802606 <alloc_block_BF>
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
  8014f8:	e8 b1 08 00 00       	call   801dae <sys_allocate_user_mem>
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
  801540:	e8 85 08 00 00       	call   801dca <get_block_size>
  801545:	83 c4 10             	add    $0x10,%esp
  801548:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80154b:	83 ec 0c             	sub    $0xc,%esp
  80154e:	ff 75 08             	pushl  0x8(%ebp)
  801551:	e8 b8 1a 00 00       	call   80300e <free_block>
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
  8015e8:	e8 a5 07 00 00       	call   801d92 <sys_free_user_mem>
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
  8015f6:	68 f8 42 80 00       	push   $0x8042f8
  8015fb:	68 84 00 00 00       	push   $0x84
  801600:	68 22 43 80 00       	push   $0x804322
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
  801623:	eb 64                	jmp    801689 <smalloc+0x7d>
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
  801658:	eb 2f                	jmp    801689 <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80165a:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80165e:	ff 75 ec             	pushl  -0x14(%ebp)
  801661:	50                   	push   %eax
  801662:	ff 75 0c             	pushl  0xc(%ebp)
  801665:	ff 75 08             	pushl  0x8(%ebp)
  801668:	e8 2c 03 00 00       	call   801999 <sys_createSharedObject>
  80166d:	83 c4 10             	add    $0x10,%esp
  801670:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801673:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801677:	74 06                	je     80167f <smalloc+0x73>
  801679:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80167d:	75 07                	jne    801686 <smalloc+0x7a>
  80167f:	b8 00 00 00 00       	mov    $0x0,%eax
  801684:	eb 03                	jmp    801689 <smalloc+0x7d>
	 return ptr;
  801686:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801691:	83 ec 08             	sub    $0x8,%esp
  801694:	ff 75 0c             	pushl  0xc(%ebp)
  801697:	ff 75 08             	pushl  0x8(%ebp)
  80169a:	e8 24 03 00 00       	call   8019c3 <sys_getSizeOfSharedObject>
  80169f:	83 c4 10             	add    $0x10,%esp
  8016a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8016a5:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016a9:	75 07                	jne    8016b2 <sget+0x27>
  8016ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b0:	eb 5c                	jmp    80170e <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8016b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016b8:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c5:	39 d0                	cmp    %edx,%eax
  8016c7:	7d 02                	jge    8016cb <sget+0x40>
  8016c9:	89 d0                	mov    %edx,%eax
  8016cb:	83 ec 0c             	sub    $0xc,%esp
  8016ce:	50                   	push   %eax
  8016cf:	e8 1b fc ff ff       	call   8012ef <malloc>
  8016d4:	83 c4 10             	add    $0x10,%esp
  8016d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8016da:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016de:	75 07                	jne    8016e7 <sget+0x5c>
  8016e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e5:	eb 27                	jmp    80170e <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8016e7:	83 ec 04             	sub    $0x4,%esp
  8016ea:	ff 75 e8             	pushl  -0x18(%ebp)
  8016ed:	ff 75 0c             	pushl  0xc(%ebp)
  8016f0:	ff 75 08             	pushl  0x8(%ebp)
  8016f3:	e8 e8 02 00 00       	call   8019e0 <sys_getSharedObject>
  8016f8:	83 c4 10             	add    $0x10,%esp
  8016fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8016fe:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801702:	75 07                	jne    80170b <sget+0x80>
  801704:	b8 00 00 00 00       	mov    $0x0,%eax
  801709:	eb 03                	jmp    80170e <sget+0x83>
	return ptr;
  80170b:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    

00801710 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
  801713:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801716:	83 ec 04             	sub    $0x4,%esp
  801719:	68 30 43 80 00       	push   $0x804330
  80171e:	68 c1 00 00 00       	push   $0xc1
  801723:	68 22 43 80 00       	push   $0x804322
  801728:	e8 55 eb ff ff       	call   800282 <_panic>

0080172d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801733:	83 ec 04             	sub    $0x4,%esp
  801736:	68 54 43 80 00       	push   $0x804354
  80173b:	68 d8 00 00 00       	push   $0xd8
  801740:	68 22 43 80 00       	push   $0x804322
  801745:	e8 38 eb ff ff       	call   800282 <_panic>

0080174a <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801750:	83 ec 04             	sub    $0x4,%esp
  801753:	68 7a 43 80 00       	push   $0x80437a
  801758:	68 e4 00 00 00       	push   $0xe4
  80175d:	68 22 43 80 00       	push   $0x804322
  801762:	e8 1b eb ff ff       	call   800282 <_panic>

00801767 <shrink>:

}
void shrink(uint32 newSize)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80176d:	83 ec 04             	sub    $0x4,%esp
  801770:	68 7a 43 80 00       	push   $0x80437a
  801775:	68 e9 00 00 00       	push   $0xe9
  80177a:	68 22 43 80 00       	push   $0x804322
  80177f:	e8 fe ea ff ff       	call   800282 <_panic>

00801784 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
  801787:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80178a:	83 ec 04             	sub    $0x4,%esp
  80178d:	68 7a 43 80 00       	push   $0x80437a
  801792:	68 ee 00 00 00       	push   $0xee
  801797:	68 22 43 80 00       	push   $0x804322
  80179c:	e8 e1 ea ff ff       	call   800282 <_panic>

008017a1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	57                   	push   %edi
  8017a5:	56                   	push   %esi
  8017a6:	53                   	push   %ebx
  8017a7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017b3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017b6:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017b9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017bc:	cd 30                	int    $0x30
  8017be:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017c4:	83 c4 10             	add    $0x10,%esp
  8017c7:	5b                   	pop    %ebx
  8017c8:	5e                   	pop    %esi
  8017c9:	5f                   	pop    %edi
  8017ca:	5d                   	pop    %ebp
  8017cb:	c3                   	ret    

008017cc <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	83 ec 04             	sub    $0x4,%esp
  8017d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017d8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	52                   	push   %edx
  8017e4:	ff 75 0c             	pushl  0xc(%ebp)
  8017e7:	50                   	push   %eax
  8017e8:	6a 00                	push   $0x0
  8017ea:	e8 b2 ff ff ff       	call   8017a1 <syscall>
  8017ef:	83 c4 18             	add    $0x18,%esp
}
  8017f2:	90                   	nop
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 02                	push   $0x2
  801804:	e8 98 ff ff ff       	call   8017a1 <syscall>
  801809:	83 c4 18             	add    $0x18,%esp
}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <sys_lock_cons>:

void sys_lock_cons(void)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 03                	push   $0x3
  80181d:	e8 7f ff ff ff       	call   8017a1 <syscall>
  801822:	83 c4 18             	add    $0x18,%esp
}
  801825:	90                   	nop
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 04                	push   $0x4
  801837:	e8 65 ff ff ff       	call   8017a1 <syscall>
  80183c:	83 c4 18             	add    $0x18,%esp
}
  80183f:	90                   	nop
  801840:	c9                   	leave  
  801841:	c3                   	ret    

00801842 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801845:	8b 55 0c             	mov    0xc(%ebp),%edx
  801848:	8b 45 08             	mov    0x8(%ebp),%eax
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	52                   	push   %edx
  801852:	50                   	push   %eax
  801853:	6a 08                	push   $0x8
  801855:	e8 47 ff ff ff       	call   8017a1 <syscall>
  80185a:	83 c4 18             	add    $0x18,%esp
}
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	56                   	push   %esi
  801863:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801864:	8b 75 18             	mov    0x18(%ebp),%esi
  801867:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80186a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80186d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801870:	8b 45 08             	mov    0x8(%ebp),%eax
  801873:	56                   	push   %esi
  801874:	53                   	push   %ebx
  801875:	51                   	push   %ecx
  801876:	52                   	push   %edx
  801877:	50                   	push   %eax
  801878:	6a 09                	push   $0x9
  80187a:	e8 22 ff ff ff       	call   8017a1 <syscall>
  80187f:	83 c4 18             	add    $0x18,%esp
}
  801882:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801885:	5b                   	pop    %ebx
  801886:	5e                   	pop    %esi
  801887:	5d                   	pop    %ebp
  801888:	c3                   	ret    

00801889 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80188c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188f:	8b 45 08             	mov    0x8(%ebp),%eax
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	52                   	push   %edx
  801899:	50                   	push   %eax
  80189a:	6a 0a                	push   $0xa
  80189c:	e8 00 ff ff ff       	call   8017a1 <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	ff 75 0c             	pushl  0xc(%ebp)
  8018b2:	ff 75 08             	pushl  0x8(%ebp)
  8018b5:	6a 0b                	push   $0xb
  8018b7:	e8 e5 fe ff ff       	call   8017a1 <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 0c                	push   $0xc
  8018d0:	e8 cc fe ff ff       	call   8017a1 <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 0d                	push   $0xd
  8018e9:	e8 b3 fe ff ff       	call   8017a1 <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
}
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 0e                	push   $0xe
  801902:	e8 9a fe ff ff       	call   8017a1 <syscall>
  801907:	83 c4 18             	add    $0x18,%esp
}
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 0f                	push   $0xf
  80191b:	e8 81 fe ff ff       	call   8017a1 <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
}
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	ff 75 08             	pushl  0x8(%ebp)
  801933:	6a 10                	push   $0x10
  801935:	e8 67 fe ff ff       	call   8017a1 <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 11                	push   $0x11
  80194e:	e8 4e fe ff ff       	call   8017a1 <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
}
  801956:	90                   	nop
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <sys_cputc>:

void
sys_cputc(const char c)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
  80195c:	83 ec 04             	sub    $0x4,%esp
  80195f:	8b 45 08             	mov    0x8(%ebp),%eax
  801962:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801965:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	50                   	push   %eax
  801972:	6a 01                	push   $0x1
  801974:	e8 28 fe ff ff       	call   8017a1 <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
}
  80197c:	90                   	nop
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 14                	push   $0x14
  80198e:	e8 0e fe ff ff       	call   8017a1 <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
}
  801996:	90                   	nop
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	83 ec 04             	sub    $0x4,%esp
  80199f:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019a5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019a8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8019af:	6a 00                	push   $0x0
  8019b1:	51                   	push   %ecx
  8019b2:	52                   	push   %edx
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	50                   	push   %eax
  8019b7:	6a 15                	push   $0x15
  8019b9:	e8 e3 fd ff ff       	call   8017a1 <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	52                   	push   %edx
  8019d3:	50                   	push   %eax
  8019d4:	6a 16                	push   $0x16
  8019d6:	e8 c6 fd ff ff       	call   8017a1 <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	51                   	push   %ecx
  8019f1:	52                   	push   %edx
  8019f2:	50                   	push   %eax
  8019f3:	6a 17                	push   $0x17
  8019f5:	e8 a7 fd ff ff       	call   8017a1 <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	52                   	push   %edx
  801a0f:	50                   	push   %eax
  801a10:	6a 18                	push   $0x18
  801a12:	e8 8a fd ff ff       	call   8017a1 <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	6a 00                	push   $0x0
  801a24:	ff 75 14             	pushl  0x14(%ebp)
  801a27:	ff 75 10             	pushl  0x10(%ebp)
  801a2a:	ff 75 0c             	pushl  0xc(%ebp)
  801a2d:	50                   	push   %eax
  801a2e:	6a 19                	push   $0x19
  801a30:	e8 6c fd ff ff       	call   8017a1 <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	50                   	push   %eax
  801a49:	6a 1a                	push   $0x1a
  801a4b:	e8 51 fd ff ff       	call   8017a1 <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	90                   	nop
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	50                   	push   %eax
  801a65:	6a 1b                	push   $0x1b
  801a67:	e8 35 fd ff ff       	call   8017a1 <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 05                	push   $0x5
  801a80:	e8 1c fd ff ff       	call   8017a1 <syscall>
  801a85:	83 c4 18             	add    $0x18,%esp
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 06                	push   $0x6
  801a99:	e8 03 fd ff ff       	call   8017a1 <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 07                	push   $0x7
  801ab2:	e8 ea fc ff ff       	call   8017a1 <syscall>
  801ab7:	83 c4 18             	add    $0x18,%esp
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <sys_exit_env>:


void sys_exit_env(void)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 1c                	push   $0x1c
  801acb:	e8 d1 fc ff ff       	call   8017a1 <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
}
  801ad3:	90                   	nop
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801adc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801adf:	8d 50 04             	lea    0x4(%eax),%edx
  801ae2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	52                   	push   %edx
  801aec:	50                   	push   %eax
  801aed:	6a 1d                	push   $0x1d
  801aef:	e8 ad fc ff ff       	call   8017a1 <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
	return result;
  801af7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801afa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b00:	89 01                	mov    %eax,(%ecx)
  801b02:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b05:	8b 45 08             	mov    0x8(%ebp),%eax
  801b08:	c9                   	leave  
  801b09:	c2 04 00             	ret    $0x4

00801b0c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	ff 75 10             	pushl  0x10(%ebp)
  801b16:	ff 75 0c             	pushl  0xc(%ebp)
  801b19:	ff 75 08             	pushl  0x8(%ebp)
  801b1c:	6a 13                	push   $0x13
  801b1e:	e8 7e fc ff ff       	call   8017a1 <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
	return ;
  801b26:	90                   	nop
}
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 1e                	push   $0x1e
  801b38:	e8 64 fc ff ff       	call   8017a1 <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
  801b45:	83 ec 04             	sub    $0x4,%esp
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b4e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	50                   	push   %eax
  801b5b:	6a 1f                	push   $0x1f
  801b5d:	e8 3f fc ff ff       	call   8017a1 <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
	return ;
  801b65:	90                   	nop
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <rsttst>:
void rsttst()
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 21                	push   $0x21
  801b77:	e8 25 fc ff ff       	call   8017a1 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b7f:	90                   	nop
}
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
  801b85:	83 ec 04             	sub    $0x4,%esp
  801b88:	8b 45 14             	mov    0x14(%ebp),%eax
  801b8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b8e:	8b 55 18             	mov    0x18(%ebp),%edx
  801b91:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b95:	52                   	push   %edx
  801b96:	50                   	push   %eax
  801b97:	ff 75 10             	pushl  0x10(%ebp)
  801b9a:	ff 75 0c             	pushl  0xc(%ebp)
  801b9d:	ff 75 08             	pushl  0x8(%ebp)
  801ba0:	6a 20                	push   $0x20
  801ba2:	e8 fa fb ff ff       	call   8017a1 <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
	return ;
  801baa:	90                   	nop
}
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <chktst>:
void chktst(uint32 n)
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	ff 75 08             	pushl  0x8(%ebp)
  801bbb:	6a 22                	push   $0x22
  801bbd:	e8 df fb ff ff       	call   8017a1 <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc5:	90                   	nop
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <inctst>:

void inctst()
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 23                	push   $0x23
  801bd7:	e8 c5 fb ff ff       	call   8017a1 <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
	return ;
  801bdf:	90                   	nop
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <gettst>:
uint32 gettst()
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 24                	push   $0x24
  801bf1:	e8 ab fb ff ff       	call   8017a1 <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
  801bfe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 25                	push   $0x25
  801c0d:	e8 8f fb ff ff       	call   8017a1 <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
  801c15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c18:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c1c:	75 07                	jne    801c25 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c1e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c23:	eb 05                	jmp    801c2a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
  801c2f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 25                	push   $0x25
  801c3e:	e8 5e fb ff ff       	call   8017a1 <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
  801c46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c49:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c4d:	75 07                	jne    801c56 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c4f:	b8 01 00 00 00       	mov    $0x1,%eax
  801c54:	eb 05                	jmp    801c5b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 25                	push   $0x25
  801c6f:	e8 2d fb ff ff       	call   8017a1 <syscall>
  801c74:	83 c4 18             	add    $0x18,%esp
  801c77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c7a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c7e:	75 07                	jne    801c87 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c80:	b8 01 00 00 00       	mov    $0x1,%eax
  801c85:	eb 05                	jmp    801c8c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 25                	push   $0x25
  801ca0:	e8 fc fa ff ff       	call   8017a1 <syscall>
  801ca5:	83 c4 18             	add    $0x18,%esp
  801ca8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cab:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801caf:	75 07                	jne    801cb8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cb1:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb6:	eb 05                	jmp    801cbd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	ff 75 08             	pushl  0x8(%ebp)
  801ccd:	6a 26                	push   $0x26
  801ccf:	e8 cd fa ff ff       	call   8017a1 <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd7:	90                   	nop
}
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cde:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ce1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ce4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cea:	6a 00                	push   $0x0
  801cec:	53                   	push   %ebx
  801ced:	51                   	push   %ecx
  801cee:	52                   	push   %edx
  801cef:	50                   	push   %eax
  801cf0:	6a 27                	push   $0x27
  801cf2:	e8 aa fa ff ff       	call   8017a1 <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
}
  801cfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d05:	8b 45 08             	mov    0x8(%ebp),%eax
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	52                   	push   %edx
  801d0f:	50                   	push   %eax
  801d10:	6a 28                	push   $0x28
  801d12:	e8 8a fa ff ff       	call   8017a1 <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
}
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d1f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	6a 00                	push   $0x0
  801d2a:	51                   	push   %ecx
  801d2b:	ff 75 10             	pushl  0x10(%ebp)
  801d2e:	52                   	push   %edx
  801d2f:	50                   	push   %eax
  801d30:	6a 29                	push   $0x29
  801d32:	e8 6a fa ff ff       	call   8017a1 <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	ff 75 10             	pushl  0x10(%ebp)
  801d46:	ff 75 0c             	pushl  0xc(%ebp)
  801d49:	ff 75 08             	pushl  0x8(%ebp)
  801d4c:	6a 12                	push   $0x12
  801d4e:	e8 4e fa ff ff       	call   8017a1 <syscall>
  801d53:	83 c4 18             	add    $0x18,%esp
	return ;
  801d56:	90                   	nop
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	52                   	push   %edx
  801d69:	50                   	push   %eax
  801d6a:	6a 2a                	push   $0x2a
  801d6c:	e8 30 fa ff ff       	call   8017a1 <syscall>
  801d71:	83 c4 18             	add    $0x18,%esp
	return;
  801d74:	90                   	nop
}
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	50                   	push   %eax
  801d86:	6a 2b                	push   $0x2b
  801d88:	e8 14 fa ff ff       	call   8017a1 <syscall>
  801d8d:	83 c4 18             	add    $0x18,%esp
}
  801d90:	c9                   	leave  
  801d91:	c3                   	ret    

00801d92 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d92:	55                   	push   %ebp
  801d93:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	ff 75 0c             	pushl  0xc(%ebp)
  801d9e:	ff 75 08             	pushl  0x8(%ebp)
  801da1:	6a 2c                	push   $0x2c
  801da3:	e8 f9 f9 ff ff       	call   8017a1 <syscall>
  801da8:	83 c4 18             	add    $0x18,%esp
	return;
  801dab:	90                   	nop
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	ff 75 0c             	pushl  0xc(%ebp)
  801dba:	ff 75 08             	pushl  0x8(%ebp)
  801dbd:	6a 2d                	push   $0x2d
  801dbf:	e8 dd f9 ff ff       	call   8017a1 <syscall>
  801dc4:	83 c4 18             	add    $0x18,%esp
	return;
  801dc7:	90                   	nop
}
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd3:	83 e8 04             	sub    $0x4,%eax
  801dd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801dd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ddc:	8b 00                	mov    (%eax),%eax
  801dde:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
  801de6:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	83 e8 04             	sub    $0x4,%eax
  801def:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801df2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801df5:	8b 00                	mov    (%eax),%eax
  801df7:	83 e0 01             	and    $0x1,%eax
  801dfa:	85 c0                	test   %eax,%eax
  801dfc:	0f 94 c0             	sete   %al
}
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
  801e04:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801e07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e11:	83 f8 02             	cmp    $0x2,%eax
  801e14:	74 2b                	je     801e41 <alloc_block+0x40>
  801e16:	83 f8 02             	cmp    $0x2,%eax
  801e19:	7f 07                	jg     801e22 <alloc_block+0x21>
  801e1b:	83 f8 01             	cmp    $0x1,%eax
  801e1e:	74 0e                	je     801e2e <alloc_block+0x2d>
  801e20:	eb 58                	jmp    801e7a <alloc_block+0x79>
  801e22:	83 f8 03             	cmp    $0x3,%eax
  801e25:	74 2d                	je     801e54 <alloc_block+0x53>
  801e27:	83 f8 04             	cmp    $0x4,%eax
  801e2a:	74 3b                	je     801e67 <alloc_block+0x66>
  801e2c:	eb 4c                	jmp    801e7a <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801e2e:	83 ec 0c             	sub    $0xc,%esp
  801e31:	ff 75 08             	pushl  0x8(%ebp)
  801e34:	e8 11 03 00 00       	call   80214a <alloc_block_FF>
  801e39:	83 c4 10             	add    $0x10,%esp
  801e3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e3f:	eb 4a                	jmp    801e8b <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801e41:	83 ec 0c             	sub    $0xc,%esp
  801e44:	ff 75 08             	pushl  0x8(%ebp)
  801e47:	e8 fa 19 00 00       	call   803846 <alloc_block_NF>
  801e4c:	83 c4 10             	add    $0x10,%esp
  801e4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e52:	eb 37                	jmp    801e8b <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801e54:	83 ec 0c             	sub    $0xc,%esp
  801e57:	ff 75 08             	pushl  0x8(%ebp)
  801e5a:	e8 a7 07 00 00       	call   802606 <alloc_block_BF>
  801e5f:	83 c4 10             	add    $0x10,%esp
  801e62:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e65:	eb 24                	jmp    801e8b <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801e67:	83 ec 0c             	sub    $0xc,%esp
  801e6a:	ff 75 08             	pushl  0x8(%ebp)
  801e6d:	e8 b7 19 00 00       	call   803829 <alloc_block_WF>
  801e72:	83 c4 10             	add    $0x10,%esp
  801e75:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e78:	eb 11                	jmp    801e8b <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801e7a:	83 ec 0c             	sub    $0xc,%esp
  801e7d:	68 8c 43 80 00       	push   $0x80438c
  801e82:	e8 b8 e6 ff ff       	call   80053f <cprintf>
  801e87:	83 c4 10             	add    $0x10,%esp
		break;
  801e8a:	90                   	nop
	}
	return va;
  801e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e8e:	c9                   	leave  
  801e8f:	c3                   	ret    

00801e90 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	53                   	push   %ebx
  801e94:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801e97:	83 ec 0c             	sub    $0xc,%esp
  801e9a:	68 ac 43 80 00       	push   $0x8043ac
  801e9f:	e8 9b e6 ff ff       	call   80053f <cprintf>
  801ea4:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801ea7:	83 ec 0c             	sub    $0xc,%esp
  801eaa:	68 d7 43 80 00       	push   $0x8043d7
  801eaf:	e8 8b e6 ff ff       	call   80053f <cprintf>
  801eb4:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ebd:	eb 37                	jmp    801ef6 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801ebf:	83 ec 0c             	sub    $0xc,%esp
  801ec2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec5:	e8 19 ff ff ff       	call   801de3 <is_free_block>
  801eca:	83 c4 10             	add    $0x10,%esp
  801ecd:	0f be d8             	movsbl %al,%ebx
  801ed0:	83 ec 0c             	sub    $0xc,%esp
  801ed3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed6:	e8 ef fe ff ff       	call   801dca <get_block_size>
  801edb:	83 c4 10             	add    $0x10,%esp
  801ede:	83 ec 04             	sub    $0x4,%esp
  801ee1:	53                   	push   %ebx
  801ee2:	50                   	push   %eax
  801ee3:	68 ef 43 80 00       	push   $0x8043ef
  801ee8:	e8 52 e6 ff ff       	call   80053f <cprintf>
  801eed:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801ef0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ef6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801efa:	74 07                	je     801f03 <print_blocks_list+0x73>
  801efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eff:	8b 00                	mov    (%eax),%eax
  801f01:	eb 05                	jmp    801f08 <print_blocks_list+0x78>
  801f03:	b8 00 00 00 00       	mov    $0x0,%eax
  801f08:	89 45 10             	mov    %eax,0x10(%ebp)
  801f0b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0e:	85 c0                	test   %eax,%eax
  801f10:	75 ad                	jne    801ebf <print_blocks_list+0x2f>
  801f12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f16:	75 a7                	jne    801ebf <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801f18:	83 ec 0c             	sub    $0xc,%esp
  801f1b:	68 ac 43 80 00       	push   $0x8043ac
  801f20:	e8 1a e6 ff ff       	call   80053f <cprintf>
  801f25:	83 c4 10             	add    $0x10,%esp

}
  801f28:	90                   	nop
  801f29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f2c:	c9                   	leave  
  801f2d:	c3                   	ret    

00801f2e <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
  801f31:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f37:	83 e0 01             	and    $0x1,%eax
  801f3a:	85 c0                	test   %eax,%eax
  801f3c:	74 03                	je     801f41 <initialize_dynamic_allocator+0x13>
  801f3e:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801f41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f45:	0f 84 c7 01 00 00    	je     802112 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801f4b:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801f52:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801f55:	8b 55 08             	mov    0x8(%ebp),%edx
  801f58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f5b:	01 d0                	add    %edx,%eax
  801f5d:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801f62:	0f 87 ad 01 00 00    	ja     802115 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801f68:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6b:	85 c0                	test   %eax,%eax
  801f6d:	0f 89 a5 01 00 00    	jns    802118 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801f73:	8b 55 08             	mov    0x8(%ebp),%edx
  801f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f79:	01 d0                	add    %edx,%eax
  801f7b:	83 e8 04             	sub    $0x4,%eax
  801f7e:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801f83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801f8a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801f8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f92:	e9 87 00 00 00       	jmp    80201e <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801f97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f9b:	75 14                	jne    801fb1 <initialize_dynamic_allocator+0x83>
  801f9d:	83 ec 04             	sub    $0x4,%esp
  801fa0:	68 07 44 80 00       	push   $0x804407
  801fa5:	6a 79                	push   $0x79
  801fa7:	68 25 44 80 00       	push   $0x804425
  801fac:	e8 d1 e2 ff ff       	call   800282 <_panic>
  801fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb4:	8b 00                	mov    (%eax),%eax
  801fb6:	85 c0                	test   %eax,%eax
  801fb8:	74 10                	je     801fca <initialize_dynamic_allocator+0x9c>
  801fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbd:	8b 00                	mov    (%eax),%eax
  801fbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc2:	8b 52 04             	mov    0x4(%edx),%edx
  801fc5:	89 50 04             	mov    %edx,0x4(%eax)
  801fc8:	eb 0b                	jmp    801fd5 <initialize_dynamic_allocator+0xa7>
  801fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcd:	8b 40 04             	mov    0x4(%eax),%eax
  801fd0:	a3 30 50 80 00       	mov    %eax,0x805030
  801fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd8:	8b 40 04             	mov    0x4(%eax),%eax
  801fdb:	85 c0                	test   %eax,%eax
  801fdd:	74 0f                	je     801fee <initialize_dynamic_allocator+0xc0>
  801fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe2:	8b 40 04             	mov    0x4(%eax),%eax
  801fe5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe8:	8b 12                	mov    (%edx),%edx
  801fea:	89 10                	mov    %edx,(%eax)
  801fec:	eb 0a                	jmp    801ff8 <initialize_dynamic_allocator+0xca>
  801fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff1:	8b 00                	mov    (%eax),%eax
  801ff3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802004:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80200b:	a1 38 50 80 00       	mov    0x805038,%eax
  802010:	48                   	dec    %eax
  802011:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802016:	a1 34 50 80 00       	mov    0x805034,%eax
  80201b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80201e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802022:	74 07                	je     80202b <initialize_dynamic_allocator+0xfd>
  802024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802027:	8b 00                	mov    (%eax),%eax
  802029:	eb 05                	jmp    802030 <initialize_dynamic_allocator+0x102>
  80202b:	b8 00 00 00 00       	mov    $0x0,%eax
  802030:	a3 34 50 80 00       	mov    %eax,0x805034
  802035:	a1 34 50 80 00       	mov    0x805034,%eax
  80203a:	85 c0                	test   %eax,%eax
  80203c:	0f 85 55 ff ff ff    	jne    801f97 <initialize_dynamic_allocator+0x69>
  802042:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802046:	0f 85 4b ff ff ff    	jne    801f97 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802052:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802055:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80205b:	a1 44 50 80 00       	mov    0x805044,%eax
  802060:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802065:	a1 40 50 80 00       	mov    0x805040,%eax
  80206a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	83 c0 08             	add    $0x8,%eax
  802076:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802079:	8b 45 08             	mov    0x8(%ebp),%eax
  80207c:	83 c0 04             	add    $0x4,%eax
  80207f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802082:	83 ea 08             	sub    $0x8,%edx
  802085:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802087:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208a:	8b 45 08             	mov    0x8(%ebp),%eax
  80208d:	01 d0                	add    %edx,%eax
  80208f:	83 e8 08             	sub    $0x8,%eax
  802092:	8b 55 0c             	mov    0xc(%ebp),%edx
  802095:	83 ea 08             	sub    $0x8,%edx
  802098:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80209a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80209d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8020a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8020ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020b1:	75 17                	jne    8020ca <initialize_dynamic_allocator+0x19c>
  8020b3:	83 ec 04             	sub    $0x4,%esp
  8020b6:	68 40 44 80 00       	push   $0x804440
  8020bb:	68 90 00 00 00       	push   $0x90
  8020c0:	68 25 44 80 00       	push   $0x804425
  8020c5:	e8 b8 e1 ff ff       	call   800282 <_panic>
  8020ca:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8020d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d3:	89 10                	mov    %edx,(%eax)
  8020d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d8:	8b 00                	mov    (%eax),%eax
  8020da:	85 c0                	test   %eax,%eax
  8020dc:	74 0d                	je     8020eb <initialize_dynamic_allocator+0x1bd>
  8020de:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020e6:	89 50 04             	mov    %edx,0x4(%eax)
  8020e9:	eb 08                	jmp    8020f3 <initialize_dynamic_allocator+0x1c5>
  8020eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ee:	a3 30 50 80 00       	mov    %eax,0x805030
  8020f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802105:	a1 38 50 80 00       	mov    0x805038,%eax
  80210a:	40                   	inc    %eax
  80210b:	a3 38 50 80 00       	mov    %eax,0x805038
  802110:	eb 07                	jmp    802119 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802112:	90                   	nop
  802113:	eb 04                	jmp    802119 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802115:	90                   	nop
  802116:	eb 01                	jmp    802119 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802118:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802119:	c9                   	leave  
  80211a:	c3                   	ret    

0080211b <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80211e:	8b 45 10             	mov    0x10(%ebp),%eax
  802121:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802124:	8b 45 08             	mov    0x8(%ebp),%eax
  802127:	8d 50 fc             	lea    -0x4(%eax),%edx
  80212a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80212d:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80212f:	8b 45 08             	mov    0x8(%ebp),%eax
  802132:	83 e8 04             	sub    $0x4,%eax
  802135:	8b 00                	mov    (%eax),%eax
  802137:	83 e0 fe             	and    $0xfffffffe,%eax
  80213a:	8d 50 f8             	lea    -0x8(%eax),%edx
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	01 c2                	add    %eax,%edx
  802142:	8b 45 0c             	mov    0xc(%ebp),%eax
  802145:	89 02                	mov    %eax,(%edx)
}
  802147:	90                   	nop
  802148:	5d                   	pop    %ebp
  802149:	c3                   	ret    

0080214a <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
  80214d:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802150:	8b 45 08             	mov    0x8(%ebp),%eax
  802153:	83 e0 01             	and    $0x1,%eax
  802156:	85 c0                	test   %eax,%eax
  802158:	74 03                	je     80215d <alloc_block_FF+0x13>
  80215a:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80215d:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802161:	77 07                	ja     80216a <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802163:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80216a:	a1 24 50 80 00       	mov    0x805024,%eax
  80216f:	85 c0                	test   %eax,%eax
  802171:	75 73                	jne    8021e6 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802173:	8b 45 08             	mov    0x8(%ebp),%eax
  802176:	83 c0 10             	add    $0x10,%eax
  802179:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80217c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802183:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802186:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802189:	01 d0                	add    %edx,%eax
  80218b:	48                   	dec    %eax
  80218c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80218f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802192:	ba 00 00 00 00       	mov    $0x0,%edx
  802197:	f7 75 ec             	divl   -0x14(%ebp)
  80219a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80219d:	29 d0                	sub    %edx,%eax
  80219f:	c1 e8 0c             	shr    $0xc,%eax
  8021a2:	83 ec 0c             	sub    $0xc,%esp
  8021a5:	50                   	push   %eax
  8021a6:	e8 2e f1 ff ff       	call   8012d9 <sbrk>
  8021ab:	83 c4 10             	add    $0x10,%esp
  8021ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8021b1:	83 ec 0c             	sub    $0xc,%esp
  8021b4:	6a 00                	push   $0x0
  8021b6:	e8 1e f1 ff ff       	call   8012d9 <sbrk>
  8021bb:	83 c4 10             	add    $0x10,%esp
  8021be:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8021c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021c4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8021c7:	83 ec 08             	sub    $0x8,%esp
  8021ca:	50                   	push   %eax
  8021cb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021ce:	e8 5b fd ff ff       	call   801f2e <initialize_dynamic_allocator>
  8021d3:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8021d6:	83 ec 0c             	sub    $0xc,%esp
  8021d9:	68 63 44 80 00       	push   $0x804463
  8021de:	e8 5c e3 ff ff       	call   80053f <cprintf>
  8021e3:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8021e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ea:	75 0a                	jne    8021f6 <alloc_block_FF+0xac>
	        return NULL;
  8021ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f1:	e9 0e 04 00 00       	jmp    802604 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8021f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8021fd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802202:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802205:	e9 f3 02 00 00       	jmp    8024fd <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80220a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220d:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802210:	83 ec 0c             	sub    $0xc,%esp
  802213:	ff 75 bc             	pushl  -0x44(%ebp)
  802216:	e8 af fb ff ff       	call   801dca <get_block_size>
  80221b:	83 c4 10             	add    $0x10,%esp
  80221e:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802221:	8b 45 08             	mov    0x8(%ebp),%eax
  802224:	83 c0 08             	add    $0x8,%eax
  802227:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80222a:	0f 87 c5 02 00 00    	ja     8024f5 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802230:	8b 45 08             	mov    0x8(%ebp),%eax
  802233:	83 c0 18             	add    $0x18,%eax
  802236:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802239:	0f 87 19 02 00 00    	ja     802458 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80223f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802242:	2b 45 08             	sub    0x8(%ebp),%eax
  802245:	83 e8 08             	sub    $0x8,%eax
  802248:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
  80224e:	8d 50 08             	lea    0x8(%eax),%edx
  802251:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802254:	01 d0                	add    %edx,%eax
  802256:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	83 c0 08             	add    $0x8,%eax
  80225f:	83 ec 04             	sub    $0x4,%esp
  802262:	6a 01                	push   $0x1
  802264:	50                   	push   %eax
  802265:	ff 75 bc             	pushl  -0x44(%ebp)
  802268:	e8 ae fe ff ff       	call   80211b <set_block_data>
  80226d:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802273:	8b 40 04             	mov    0x4(%eax),%eax
  802276:	85 c0                	test   %eax,%eax
  802278:	75 68                	jne    8022e2 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80227a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80227e:	75 17                	jne    802297 <alloc_block_FF+0x14d>
  802280:	83 ec 04             	sub    $0x4,%esp
  802283:	68 40 44 80 00       	push   $0x804440
  802288:	68 d7 00 00 00       	push   $0xd7
  80228d:	68 25 44 80 00       	push   $0x804425
  802292:	e8 eb df ff ff       	call   800282 <_panic>
  802297:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80229d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022a0:	89 10                	mov    %edx,(%eax)
  8022a2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022a5:	8b 00                	mov    (%eax),%eax
  8022a7:	85 c0                	test   %eax,%eax
  8022a9:	74 0d                	je     8022b8 <alloc_block_FF+0x16e>
  8022ab:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022b0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022b3:	89 50 04             	mov    %edx,0x4(%eax)
  8022b6:	eb 08                	jmp    8022c0 <alloc_block_FF+0x176>
  8022b8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022bb:	a3 30 50 80 00       	mov    %eax,0x805030
  8022c0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022c3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022d2:	a1 38 50 80 00       	mov    0x805038,%eax
  8022d7:	40                   	inc    %eax
  8022d8:	a3 38 50 80 00       	mov    %eax,0x805038
  8022dd:	e9 dc 00 00 00       	jmp    8023be <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8022e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e5:	8b 00                	mov    (%eax),%eax
  8022e7:	85 c0                	test   %eax,%eax
  8022e9:	75 65                	jne    802350 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8022eb:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022ef:	75 17                	jne    802308 <alloc_block_FF+0x1be>
  8022f1:	83 ec 04             	sub    $0x4,%esp
  8022f4:	68 74 44 80 00       	push   $0x804474
  8022f9:	68 db 00 00 00       	push   $0xdb
  8022fe:	68 25 44 80 00       	push   $0x804425
  802303:	e8 7a df ff ff       	call   800282 <_panic>
  802308:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80230e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802311:	89 50 04             	mov    %edx,0x4(%eax)
  802314:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802317:	8b 40 04             	mov    0x4(%eax),%eax
  80231a:	85 c0                	test   %eax,%eax
  80231c:	74 0c                	je     80232a <alloc_block_FF+0x1e0>
  80231e:	a1 30 50 80 00       	mov    0x805030,%eax
  802323:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802326:	89 10                	mov    %edx,(%eax)
  802328:	eb 08                	jmp    802332 <alloc_block_FF+0x1e8>
  80232a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80232d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802332:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802335:	a3 30 50 80 00       	mov    %eax,0x805030
  80233a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80233d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802343:	a1 38 50 80 00       	mov    0x805038,%eax
  802348:	40                   	inc    %eax
  802349:	a3 38 50 80 00       	mov    %eax,0x805038
  80234e:	eb 6e                	jmp    8023be <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802350:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802354:	74 06                	je     80235c <alloc_block_FF+0x212>
  802356:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80235a:	75 17                	jne    802373 <alloc_block_FF+0x229>
  80235c:	83 ec 04             	sub    $0x4,%esp
  80235f:	68 98 44 80 00       	push   $0x804498
  802364:	68 df 00 00 00       	push   $0xdf
  802369:	68 25 44 80 00       	push   $0x804425
  80236e:	e8 0f df ff ff       	call   800282 <_panic>
  802373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802376:	8b 10                	mov    (%eax),%edx
  802378:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80237b:	89 10                	mov    %edx,(%eax)
  80237d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802380:	8b 00                	mov    (%eax),%eax
  802382:	85 c0                	test   %eax,%eax
  802384:	74 0b                	je     802391 <alloc_block_FF+0x247>
  802386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802389:	8b 00                	mov    (%eax),%eax
  80238b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80238e:	89 50 04             	mov    %edx,0x4(%eax)
  802391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802394:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802397:	89 10                	mov    %edx,(%eax)
  802399:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80239c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80239f:	89 50 04             	mov    %edx,0x4(%eax)
  8023a2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023a5:	8b 00                	mov    (%eax),%eax
  8023a7:	85 c0                	test   %eax,%eax
  8023a9:	75 08                	jne    8023b3 <alloc_block_FF+0x269>
  8023ab:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ae:	a3 30 50 80 00       	mov    %eax,0x805030
  8023b3:	a1 38 50 80 00       	mov    0x805038,%eax
  8023b8:	40                   	inc    %eax
  8023b9:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8023be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c2:	75 17                	jne    8023db <alloc_block_FF+0x291>
  8023c4:	83 ec 04             	sub    $0x4,%esp
  8023c7:	68 07 44 80 00       	push   $0x804407
  8023cc:	68 e1 00 00 00       	push   $0xe1
  8023d1:	68 25 44 80 00       	push   $0x804425
  8023d6:	e8 a7 de ff ff       	call   800282 <_panic>
  8023db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023de:	8b 00                	mov    (%eax),%eax
  8023e0:	85 c0                	test   %eax,%eax
  8023e2:	74 10                	je     8023f4 <alloc_block_FF+0x2aa>
  8023e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e7:	8b 00                	mov    (%eax),%eax
  8023e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ec:	8b 52 04             	mov    0x4(%edx),%edx
  8023ef:	89 50 04             	mov    %edx,0x4(%eax)
  8023f2:	eb 0b                	jmp    8023ff <alloc_block_FF+0x2b5>
  8023f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f7:	8b 40 04             	mov    0x4(%eax),%eax
  8023fa:	a3 30 50 80 00       	mov    %eax,0x805030
  8023ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802402:	8b 40 04             	mov    0x4(%eax),%eax
  802405:	85 c0                	test   %eax,%eax
  802407:	74 0f                	je     802418 <alloc_block_FF+0x2ce>
  802409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240c:	8b 40 04             	mov    0x4(%eax),%eax
  80240f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802412:	8b 12                	mov    (%edx),%edx
  802414:	89 10                	mov    %edx,(%eax)
  802416:	eb 0a                	jmp    802422 <alloc_block_FF+0x2d8>
  802418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241b:	8b 00                	mov    (%eax),%eax
  80241d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802425:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80242b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802435:	a1 38 50 80 00       	mov    0x805038,%eax
  80243a:	48                   	dec    %eax
  80243b:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802440:	83 ec 04             	sub    $0x4,%esp
  802443:	6a 00                	push   $0x0
  802445:	ff 75 b4             	pushl  -0x4c(%ebp)
  802448:	ff 75 b0             	pushl  -0x50(%ebp)
  80244b:	e8 cb fc ff ff       	call   80211b <set_block_data>
  802450:	83 c4 10             	add    $0x10,%esp
  802453:	e9 95 00 00 00       	jmp    8024ed <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802458:	83 ec 04             	sub    $0x4,%esp
  80245b:	6a 01                	push   $0x1
  80245d:	ff 75 b8             	pushl  -0x48(%ebp)
  802460:	ff 75 bc             	pushl  -0x44(%ebp)
  802463:	e8 b3 fc ff ff       	call   80211b <set_block_data>
  802468:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80246b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80246f:	75 17                	jne    802488 <alloc_block_FF+0x33e>
  802471:	83 ec 04             	sub    $0x4,%esp
  802474:	68 07 44 80 00       	push   $0x804407
  802479:	68 e8 00 00 00       	push   $0xe8
  80247e:	68 25 44 80 00       	push   $0x804425
  802483:	e8 fa dd ff ff       	call   800282 <_panic>
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	8b 00                	mov    (%eax),%eax
  80248d:	85 c0                	test   %eax,%eax
  80248f:	74 10                	je     8024a1 <alloc_block_FF+0x357>
  802491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802494:	8b 00                	mov    (%eax),%eax
  802496:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802499:	8b 52 04             	mov    0x4(%edx),%edx
  80249c:	89 50 04             	mov    %edx,0x4(%eax)
  80249f:	eb 0b                	jmp    8024ac <alloc_block_FF+0x362>
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	8b 40 04             	mov    0x4(%eax),%eax
  8024a7:	a3 30 50 80 00       	mov    %eax,0x805030
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	8b 40 04             	mov    0x4(%eax),%eax
  8024b2:	85 c0                	test   %eax,%eax
  8024b4:	74 0f                	je     8024c5 <alloc_block_FF+0x37b>
  8024b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b9:	8b 40 04             	mov    0x4(%eax),%eax
  8024bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024bf:	8b 12                	mov    (%edx),%edx
  8024c1:	89 10                	mov    %edx,(%eax)
  8024c3:	eb 0a                	jmp    8024cf <alloc_block_FF+0x385>
  8024c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c8:	8b 00                	mov    (%eax),%eax
  8024ca:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e2:	a1 38 50 80 00       	mov    0x805038,%eax
  8024e7:	48                   	dec    %eax
  8024e8:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8024ed:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024f0:	e9 0f 01 00 00       	jmp    802604 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8024f5:	a1 34 50 80 00       	mov    0x805034,%eax
  8024fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802501:	74 07                	je     80250a <alloc_block_FF+0x3c0>
  802503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802506:	8b 00                	mov    (%eax),%eax
  802508:	eb 05                	jmp    80250f <alloc_block_FF+0x3c5>
  80250a:	b8 00 00 00 00       	mov    $0x0,%eax
  80250f:	a3 34 50 80 00       	mov    %eax,0x805034
  802514:	a1 34 50 80 00       	mov    0x805034,%eax
  802519:	85 c0                	test   %eax,%eax
  80251b:	0f 85 e9 fc ff ff    	jne    80220a <alloc_block_FF+0xc0>
  802521:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802525:	0f 85 df fc ff ff    	jne    80220a <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80252b:	8b 45 08             	mov    0x8(%ebp),%eax
  80252e:	83 c0 08             	add    $0x8,%eax
  802531:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802534:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80253b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80253e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802541:	01 d0                	add    %edx,%eax
  802543:	48                   	dec    %eax
  802544:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802547:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80254a:	ba 00 00 00 00       	mov    $0x0,%edx
  80254f:	f7 75 d8             	divl   -0x28(%ebp)
  802552:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802555:	29 d0                	sub    %edx,%eax
  802557:	c1 e8 0c             	shr    $0xc,%eax
  80255a:	83 ec 0c             	sub    $0xc,%esp
  80255d:	50                   	push   %eax
  80255e:	e8 76 ed ff ff       	call   8012d9 <sbrk>
  802563:	83 c4 10             	add    $0x10,%esp
  802566:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802569:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80256d:	75 0a                	jne    802579 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80256f:	b8 00 00 00 00       	mov    $0x0,%eax
  802574:	e9 8b 00 00 00       	jmp    802604 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802579:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802580:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802583:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802586:	01 d0                	add    %edx,%eax
  802588:	48                   	dec    %eax
  802589:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80258c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80258f:	ba 00 00 00 00       	mov    $0x0,%edx
  802594:	f7 75 cc             	divl   -0x34(%ebp)
  802597:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80259a:	29 d0                	sub    %edx,%eax
  80259c:	8d 50 fc             	lea    -0x4(%eax),%edx
  80259f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025a2:	01 d0                	add    %edx,%eax
  8025a4:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8025a9:	a1 40 50 80 00       	mov    0x805040,%eax
  8025ae:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8025b4:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8025bb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025be:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8025c1:	01 d0                	add    %edx,%eax
  8025c3:	48                   	dec    %eax
  8025c4:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8025c7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8025ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8025cf:	f7 75 c4             	divl   -0x3c(%ebp)
  8025d2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8025d5:	29 d0                	sub    %edx,%eax
  8025d7:	83 ec 04             	sub    $0x4,%esp
  8025da:	6a 01                	push   $0x1
  8025dc:	50                   	push   %eax
  8025dd:	ff 75 d0             	pushl  -0x30(%ebp)
  8025e0:	e8 36 fb ff ff       	call   80211b <set_block_data>
  8025e5:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8025e8:	83 ec 0c             	sub    $0xc,%esp
  8025eb:	ff 75 d0             	pushl  -0x30(%ebp)
  8025ee:	e8 1b 0a 00 00       	call   80300e <free_block>
  8025f3:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8025f6:	83 ec 0c             	sub    $0xc,%esp
  8025f9:	ff 75 08             	pushl  0x8(%ebp)
  8025fc:	e8 49 fb ff ff       	call   80214a <alloc_block_FF>
  802601:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802604:	c9                   	leave  
  802605:	c3                   	ret    

00802606 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802606:	55                   	push   %ebp
  802607:	89 e5                	mov    %esp,%ebp
  802609:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80260c:	8b 45 08             	mov    0x8(%ebp),%eax
  80260f:	83 e0 01             	and    $0x1,%eax
  802612:	85 c0                	test   %eax,%eax
  802614:	74 03                	je     802619 <alloc_block_BF+0x13>
  802616:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802619:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80261d:	77 07                	ja     802626 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80261f:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802626:	a1 24 50 80 00       	mov    0x805024,%eax
  80262b:	85 c0                	test   %eax,%eax
  80262d:	75 73                	jne    8026a2 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80262f:	8b 45 08             	mov    0x8(%ebp),%eax
  802632:	83 c0 10             	add    $0x10,%eax
  802635:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802638:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80263f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802642:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802645:	01 d0                	add    %edx,%eax
  802647:	48                   	dec    %eax
  802648:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80264b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80264e:	ba 00 00 00 00       	mov    $0x0,%edx
  802653:	f7 75 e0             	divl   -0x20(%ebp)
  802656:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802659:	29 d0                	sub    %edx,%eax
  80265b:	c1 e8 0c             	shr    $0xc,%eax
  80265e:	83 ec 0c             	sub    $0xc,%esp
  802661:	50                   	push   %eax
  802662:	e8 72 ec ff ff       	call   8012d9 <sbrk>
  802667:	83 c4 10             	add    $0x10,%esp
  80266a:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80266d:	83 ec 0c             	sub    $0xc,%esp
  802670:	6a 00                	push   $0x0
  802672:	e8 62 ec ff ff       	call   8012d9 <sbrk>
  802677:	83 c4 10             	add    $0x10,%esp
  80267a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80267d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802680:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802683:	83 ec 08             	sub    $0x8,%esp
  802686:	50                   	push   %eax
  802687:	ff 75 d8             	pushl  -0x28(%ebp)
  80268a:	e8 9f f8 ff ff       	call   801f2e <initialize_dynamic_allocator>
  80268f:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802692:	83 ec 0c             	sub    $0xc,%esp
  802695:	68 63 44 80 00       	push   $0x804463
  80269a:	e8 a0 de ff ff       	call   80053f <cprintf>
  80269f:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8026a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8026a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8026b0:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8026b7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8026be:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8026c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c6:	e9 1d 01 00 00       	jmp    8027e8 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8026cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ce:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8026d1:	83 ec 0c             	sub    $0xc,%esp
  8026d4:	ff 75 a8             	pushl  -0x58(%ebp)
  8026d7:	e8 ee f6 ff ff       	call   801dca <get_block_size>
  8026dc:	83 c4 10             	add    $0x10,%esp
  8026df:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8026e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e5:	83 c0 08             	add    $0x8,%eax
  8026e8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026eb:	0f 87 ef 00 00 00    	ja     8027e0 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8026f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f4:	83 c0 18             	add    $0x18,%eax
  8026f7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026fa:	77 1d                	ja     802719 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8026fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ff:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802702:	0f 86 d8 00 00 00    	jbe    8027e0 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802708:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80270b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80270e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802711:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802714:	e9 c7 00 00 00       	jmp    8027e0 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802719:	8b 45 08             	mov    0x8(%ebp),%eax
  80271c:	83 c0 08             	add    $0x8,%eax
  80271f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802722:	0f 85 9d 00 00 00    	jne    8027c5 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802728:	83 ec 04             	sub    $0x4,%esp
  80272b:	6a 01                	push   $0x1
  80272d:	ff 75 a4             	pushl  -0x5c(%ebp)
  802730:	ff 75 a8             	pushl  -0x58(%ebp)
  802733:	e8 e3 f9 ff ff       	call   80211b <set_block_data>
  802738:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80273b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273f:	75 17                	jne    802758 <alloc_block_BF+0x152>
  802741:	83 ec 04             	sub    $0x4,%esp
  802744:	68 07 44 80 00       	push   $0x804407
  802749:	68 2c 01 00 00       	push   $0x12c
  80274e:	68 25 44 80 00       	push   $0x804425
  802753:	e8 2a db ff ff       	call   800282 <_panic>
  802758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275b:	8b 00                	mov    (%eax),%eax
  80275d:	85 c0                	test   %eax,%eax
  80275f:	74 10                	je     802771 <alloc_block_BF+0x16b>
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	8b 00                	mov    (%eax),%eax
  802766:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802769:	8b 52 04             	mov    0x4(%edx),%edx
  80276c:	89 50 04             	mov    %edx,0x4(%eax)
  80276f:	eb 0b                	jmp    80277c <alloc_block_BF+0x176>
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	8b 40 04             	mov    0x4(%eax),%eax
  802777:	a3 30 50 80 00       	mov    %eax,0x805030
  80277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277f:	8b 40 04             	mov    0x4(%eax),%eax
  802782:	85 c0                	test   %eax,%eax
  802784:	74 0f                	je     802795 <alloc_block_BF+0x18f>
  802786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802789:	8b 40 04             	mov    0x4(%eax),%eax
  80278c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80278f:	8b 12                	mov    (%edx),%edx
  802791:	89 10                	mov    %edx,(%eax)
  802793:	eb 0a                	jmp    80279f <alloc_block_BF+0x199>
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	8b 00                	mov    (%eax),%eax
  80279a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b2:	a1 38 50 80 00       	mov    0x805038,%eax
  8027b7:	48                   	dec    %eax
  8027b8:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8027bd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027c0:	e9 24 04 00 00       	jmp    802be9 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8027c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027cb:	76 13                	jbe    8027e0 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8027cd:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8027d4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8027da:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8027dd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8027e0:	a1 34 50 80 00       	mov    0x805034,%eax
  8027e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ec:	74 07                	je     8027f5 <alloc_block_BF+0x1ef>
  8027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f1:	8b 00                	mov    (%eax),%eax
  8027f3:	eb 05                	jmp    8027fa <alloc_block_BF+0x1f4>
  8027f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fa:	a3 34 50 80 00       	mov    %eax,0x805034
  8027ff:	a1 34 50 80 00       	mov    0x805034,%eax
  802804:	85 c0                	test   %eax,%eax
  802806:	0f 85 bf fe ff ff    	jne    8026cb <alloc_block_BF+0xc5>
  80280c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802810:	0f 85 b5 fe ff ff    	jne    8026cb <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802816:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80281a:	0f 84 26 02 00 00    	je     802a46 <alloc_block_BF+0x440>
  802820:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802824:	0f 85 1c 02 00 00    	jne    802a46 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80282a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282d:	2b 45 08             	sub    0x8(%ebp),%eax
  802830:	83 e8 08             	sub    $0x8,%eax
  802833:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802836:	8b 45 08             	mov    0x8(%ebp),%eax
  802839:	8d 50 08             	lea    0x8(%eax),%edx
  80283c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283f:	01 d0                	add    %edx,%eax
  802841:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802844:	8b 45 08             	mov    0x8(%ebp),%eax
  802847:	83 c0 08             	add    $0x8,%eax
  80284a:	83 ec 04             	sub    $0x4,%esp
  80284d:	6a 01                	push   $0x1
  80284f:	50                   	push   %eax
  802850:	ff 75 f0             	pushl  -0x10(%ebp)
  802853:	e8 c3 f8 ff ff       	call   80211b <set_block_data>
  802858:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80285b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285e:	8b 40 04             	mov    0x4(%eax),%eax
  802861:	85 c0                	test   %eax,%eax
  802863:	75 68                	jne    8028cd <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802865:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802869:	75 17                	jne    802882 <alloc_block_BF+0x27c>
  80286b:	83 ec 04             	sub    $0x4,%esp
  80286e:	68 40 44 80 00       	push   $0x804440
  802873:	68 45 01 00 00       	push   $0x145
  802878:	68 25 44 80 00       	push   $0x804425
  80287d:	e8 00 da ff ff       	call   800282 <_panic>
  802882:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802888:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80288b:	89 10                	mov    %edx,(%eax)
  80288d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802890:	8b 00                	mov    (%eax),%eax
  802892:	85 c0                	test   %eax,%eax
  802894:	74 0d                	je     8028a3 <alloc_block_BF+0x29d>
  802896:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80289b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80289e:	89 50 04             	mov    %edx,0x4(%eax)
  8028a1:	eb 08                	jmp    8028ab <alloc_block_BF+0x2a5>
  8028a3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028a6:	a3 30 50 80 00       	mov    %eax,0x805030
  8028ab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ae:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028bd:	a1 38 50 80 00       	mov    0x805038,%eax
  8028c2:	40                   	inc    %eax
  8028c3:	a3 38 50 80 00       	mov    %eax,0x805038
  8028c8:	e9 dc 00 00 00       	jmp    8029a9 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8028cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d0:	8b 00                	mov    (%eax),%eax
  8028d2:	85 c0                	test   %eax,%eax
  8028d4:	75 65                	jne    80293b <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028d6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028da:	75 17                	jne    8028f3 <alloc_block_BF+0x2ed>
  8028dc:	83 ec 04             	sub    $0x4,%esp
  8028df:	68 74 44 80 00       	push   $0x804474
  8028e4:	68 4a 01 00 00       	push   $0x14a
  8028e9:	68 25 44 80 00       	push   $0x804425
  8028ee:	e8 8f d9 ff ff       	call   800282 <_panic>
  8028f3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8028f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028fc:	89 50 04             	mov    %edx,0x4(%eax)
  8028ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802902:	8b 40 04             	mov    0x4(%eax),%eax
  802905:	85 c0                	test   %eax,%eax
  802907:	74 0c                	je     802915 <alloc_block_BF+0x30f>
  802909:	a1 30 50 80 00       	mov    0x805030,%eax
  80290e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802911:	89 10                	mov    %edx,(%eax)
  802913:	eb 08                	jmp    80291d <alloc_block_BF+0x317>
  802915:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802918:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80291d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802920:	a3 30 50 80 00       	mov    %eax,0x805030
  802925:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802928:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80292e:	a1 38 50 80 00       	mov    0x805038,%eax
  802933:	40                   	inc    %eax
  802934:	a3 38 50 80 00       	mov    %eax,0x805038
  802939:	eb 6e                	jmp    8029a9 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80293b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80293f:	74 06                	je     802947 <alloc_block_BF+0x341>
  802941:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802945:	75 17                	jne    80295e <alloc_block_BF+0x358>
  802947:	83 ec 04             	sub    $0x4,%esp
  80294a:	68 98 44 80 00       	push   $0x804498
  80294f:	68 4f 01 00 00       	push   $0x14f
  802954:	68 25 44 80 00       	push   $0x804425
  802959:	e8 24 d9 ff ff       	call   800282 <_panic>
  80295e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802961:	8b 10                	mov    (%eax),%edx
  802963:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802966:	89 10                	mov    %edx,(%eax)
  802968:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80296b:	8b 00                	mov    (%eax),%eax
  80296d:	85 c0                	test   %eax,%eax
  80296f:	74 0b                	je     80297c <alloc_block_BF+0x376>
  802971:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802974:	8b 00                	mov    (%eax),%eax
  802976:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802979:	89 50 04             	mov    %edx,0x4(%eax)
  80297c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802982:	89 10                	mov    %edx,(%eax)
  802984:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802987:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80298a:	89 50 04             	mov    %edx,0x4(%eax)
  80298d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802990:	8b 00                	mov    (%eax),%eax
  802992:	85 c0                	test   %eax,%eax
  802994:	75 08                	jne    80299e <alloc_block_BF+0x398>
  802996:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802999:	a3 30 50 80 00       	mov    %eax,0x805030
  80299e:	a1 38 50 80 00       	mov    0x805038,%eax
  8029a3:	40                   	inc    %eax
  8029a4:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8029a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029ad:	75 17                	jne    8029c6 <alloc_block_BF+0x3c0>
  8029af:	83 ec 04             	sub    $0x4,%esp
  8029b2:	68 07 44 80 00       	push   $0x804407
  8029b7:	68 51 01 00 00       	push   $0x151
  8029bc:	68 25 44 80 00       	push   $0x804425
  8029c1:	e8 bc d8 ff ff       	call   800282 <_panic>
  8029c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c9:	8b 00                	mov    (%eax),%eax
  8029cb:	85 c0                	test   %eax,%eax
  8029cd:	74 10                	je     8029df <alloc_block_BF+0x3d9>
  8029cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d2:	8b 00                	mov    (%eax),%eax
  8029d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029d7:	8b 52 04             	mov    0x4(%edx),%edx
  8029da:	89 50 04             	mov    %edx,0x4(%eax)
  8029dd:	eb 0b                	jmp    8029ea <alloc_block_BF+0x3e4>
  8029df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e2:	8b 40 04             	mov    0x4(%eax),%eax
  8029e5:	a3 30 50 80 00       	mov    %eax,0x805030
  8029ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ed:	8b 40 04             	mov    0x4(%eax),%eax
  8029f0:	85 c0                	test   %eax,%eax
  8029f2:	74 0f                	je     802a03 <alloc_block_BF+0x3fd>
  8029f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f7:	8b 40 04             	mov    0x4(%eax),%eax
  8029fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029fd:	8b 12                	mov    (%edx),%edx
  8029ff:	89 10                	mov    %edx,(%eax)
  802a01:	eb 0a                	jmp    802a0d <alloc_block_BF+0x407>
  802a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a06:	8b 00                	mov    (%eax),%eax
  802a08:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a20:	a1 38 50 80 00       	mov    0x805038,%eax
  802a25:	48                   	dec    %eax
  802a26:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802a2b:	83 ec 04             	sub    $0x4,%esp
  802a2e:	6a 00                	push   $0x0
  802a30:	ff 75 d0             	pushl  -0x30(%ebp)
  802a33:	ff 75 cc             	pushl  -0x34(%ebp)
  802a36:	e8 e0 f6 ff ff       	call   80211b <set_block_data>
  802a3b:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802a3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a41:	e9 a3 01 00 00       	jmp    802be9 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802a46:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802a4a:	0f 85 9d 00 00 00    	jne    802aed <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802a50:	83 ec 04             	sub    $0x4,%esp
  802a53:	6a 01                	push   $0x1
  802a55:	ff 75 ec             	pushl  -0x14(%ebp)
  802a58:	ff 75 f0             	pushl  -0x10(%ebp)
  802a5b:	e8 bb f6 ff ff       	call   80211b <set_block_data>
  802a60:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802a63:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a67:	75 17                	jne    802a80 <alloc_block_BF+0x47a>
  802a69:	83 ec 04             	sub    $0x4,%esp
  802a6c:	68 07 44 80 00       	push   $0x804407
  802a71:	68 58 01 00 00       	push   $0x158
  802a76:	68 25 44 80 00       	push   $0x804425
  802a7b:	e8 02 d8 ff ff       	call   800282 <_panic>
  802a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a83:	8b 00                	mov    (%eax),%eax
  802a85:	85 c0                	test   %eax,%eax
  802a87:	74 10                	je     802a99 <alloc_block_BF+0x493>
  802a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8c:	8b 00                	mov    (%eax),%eax
  802a8e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a91:	8b 52 04             	mov    0x4(%edx),%edx
  802a94:	89 50 04             	mov    %edx,0x4(%eax)
  802a97:	eb 0b                	jmp    802aa4 <alloc_block_BF+0x49e>
  802a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9c:	8b 40 04             	mov    0x4(%eax),%eax
  802a9f:	a3 30 50 80 00       	mov    %eax,0x805030
  802aa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa7:	8b 40 04             	mov    0x4(%eax),%eax
  802aaa:	85 c0                	test   %eax,%eax
  802aac:	74 0f                	je     802abd <alloc_block_BF+0x4b7>
  802aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab1:	8b 40 04             	mov    0x4(%eax),%eax
  802ab4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ab7:	8b 12                	mov    (%edx),%edx
  802ab9:	89 10                	mov    %edx,(%eax)
  802abb:	eb 0a                	jmp    802ac7 <alloc_block_BF+0x4c1>
  802abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac0:	8b 00                	mov    (%eax),%eax
  802ac2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ada:	a1 38 50 80 00       	mov    0x805038,%eax
  802adf:	48                   	dec    %eax
  802ae0:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae8:	e9 fc 00 00 00       	jmp    802be9 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802aed:	8b 45 08             	mov    0x8(%ebp),%eax
  802af0:	83 c0 08             	add    $0x8,%eax
  802af3:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802af6:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802afd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b00:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b03:	01 d0                	add    %edx,%eax
  802b05:	48                   	dec    %eax
  802b06:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b09:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b0c:	ba 00 00 00 00       	mov    $0x0,%edx
  802b11:	f7 75 c4             	divl   -0x3c(%ebp)
  802b14:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b17:	29 d0                	sub    %edx,%eax
  802b19:	c1 e8 0c             	shr    $0xc,%eax
  802b1c:	83 ec 0c             	sub    $0xc,%esp
  802b1f:	50                   	push   %eax
  802b20:	e8 b4 e7 ff ff       	call   8012d9 <sbrk>
  802b25:	83 c4 10             	add    $0x10,%esp
  802b28:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802b2b:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802b2f:	75 0a                	jne    802b3b <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802b31:	b8 00 00 00 00       	mov    $0x0,%eax
  802b36:	e9 ae 00 00 00       	jmp    802be9 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b3b:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802b42:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b45:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b48:	01 d0                	add    %edx,%eax
  802b4a:	48                   	dec    %eax
  802b4b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802b4e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b51:	ba 00 00 00 00       	mov    $0x0,%edx
  802b56:	f7 75 b8             	divl   -0x48(%ebp)
  802b59:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b5c:	29 d0                	sub    %edx,%eax
  802b5e:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b61:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b64:	01 d0                	add    %edx,%eax
  802b66:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802b6b:	a1 40 50 80 00       	mov    0x805040,%eax
  802b70:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802b76:	83 ec 0c             	sub    $0xc,%esp
  802b79:	68 cc 44 80 00       	push   $0x8044cc
  802b7e:	e8 bc d9 ff ff       	call   80053f <cprintf>
  802b83:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802b86:	83 ec 08             	sub    $0x8,%esp
  802b89:	ff 75 bc             	pushl  -0x44(%ebp)
  802b8c:	68 d1 44 80 00       	push   $0x8044d1
  802b91:	e8 a9 d9 ff ff       	call   80053f <cprintf>
  802b96:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802b99:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802ba0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ba3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ba6:	01 d0                	add    %edx,%eax
  802ba8:	48                   	dec    %eax
  802ba9:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802bac:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802baf:	ba 00 00 00 00       	mov    $0x0,%edx
  802bb4:	f7 75 b0             	divl   -0x50(%ebp)
  802bb7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802bba:	29 d0                	sub    %edx,%eax
  802bbc:	83 ec 04             	sub    $0x4,%esp
  802bbf:	6a 01                	push   $0x1
  802bc1:	50                   	push   %eax
  802bc2:	ff 75 bc             	pushl  -0x44(%ebp)
  802bc5:	e8 51 f5 ff ff       	call   80211b <set_block_data>
  802bca:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802bcd:	83 ec 0c             	sub    $0xc,%esp
  802bd0:	ff 75 bc             	pushl  -0x44(%ebp)
  802bd3:	e8 36 04 00 00       	call   80300e <free_block>
  802bd8:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802bdb:	83 ec 0c             	sub    $0xc,%esp
  802bde:	ff 75 08             	pushl  0x8(%ebp)
  802be1:	e8 20 fa ff ff       	call   802606 <alloc_block_BF>
  802be6:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802be9:	c9                   	leave  
  802bea:	c3                   	ret    

00802beb <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802beb:	55                   	push   %ebp
  802bec:	89 e5                	mov    %esp,%ebp
  802bee:	53                   	push   %ebx
  802bef:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802bf2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802bf9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802c00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c04:	74 1e                	je     802c24 <merging+0x39>
  802c06:	ff 75 08             	pushl  0x8(%ebp)
  802c09:	e8 bc f1 ff ff       	call   801dca <get_block_size>
  802c0e:	83 c4 04             	add    $0x4,%esp
  802c11:	89 c2                	mov    %eax,%edx
  802c13:	8b 45 08             	mov    0x8(%ebp),%eax
  802c16:	01 d0                	add    %edx,%eax
  802c18:	3b 45 10             	cmp    0x10(%ebp),%eax
  802c1b:	75 07                	jne    802c24 <merging+0x39>
		prev_is_free = 1;
  802c1d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802c24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c28:	74 1e                	je     802c48 <merging+0x5d>
  802c2a:	ff 75 10             	pushl  0x10(%ebp)
  802c2d:	e8 98 f1 ff ff       	call   801dca <get_block_size>
  802c32:	83 c4 04             	add    $0x4,%esp
  802c35:	89 c2                	mov    %eax,%edx
  802c37:	8b 45 10             	mov    0x10(%ebp),%eax
  802c3a:	01 d0                	add    %edx,%eax
  802c3c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c3f:	75 07                	jne    802c48 <merging+0x5d>
		next_is_free = 1;
  802c41:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802c48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c4c:	0f 84 cc 00 00 00    	je     802d1e <merging+0x133>
  802c52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c56:	0f 84 c2 00 00 00    	je     802d1e <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802c5c:	ff 75 08             	pushl  0x8(%ebp)
  802c5f:	e8 66 f1 ff ff       	call   801dca <get_block_size>
  802c64:	83 c4 04             	add    $0x4,%esp
  802c67:	89 c3                	mov    %eax,%ebx
  802c69:	ff 75 10             	pushl  0x10(%ebp)
  802c6c:	e8 59 f1 ff ff       	call   801dca <get_block_size>
  802c71:	83 c4 04             	add    $0x4,%esp
  802c74:	01 c3                	add    %eax,%ebx
  802c76:	ff 75 0c             	pushl  0xc(%ebp)
  802c79:	e8 4c f1 ff ff       	call   801dca <get_block_size>
  802c7e:	83 c4 04             	add    $0x4,%esp
  802c81:	01 d8                	add    %ebx,%eax
  802c83:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802c86:	6a 00                	push   $0x0
  802c88:	ff 75 ec             	pushl  -0x14(%ebp)
  802c8b:	ff 75 08             	pushl  0x8(%ebp)
  802c8e:	e8 88 f4 ff ff       	call   80211b <set_block_data>
  802c93:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802c96:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c9a:	75 17                	jne    802cb3 <merging+0xc8>
  802c9c:	83 ec 04             	sub    $0x4,%esp
  802c9f:	68 07 44 80 00       	push   $0x804407
  802ca4:	68 7d 01 00 00       	push   $0x17d
  802ca9:	68 25 44 80 00       	push   $0x804425
  802cae:	e8 cf d5 ff ff       	call   800282 <_panic>
  802cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cb6:	8b 00                	mov    (%eax),%eax
  802cb8:	85 c0                	test   %eax,%eax
  802cba:	74 10                	je     802ccc <merging+0xe1>
  802cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cbf:	8b 00                	mov    (%eax),%eax
  802cc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cc4:	8b 52 04             	mov    0x4(%edx),%edx
  802cc7:	89 50 04             	mov    %edx,0x4(%eax)
  802cca:	eb 0b                	jmp    802cd7 <merging+0xec>
  802ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ccf:	8b 40 04             	mov    0x4(%eax),%eax
  802cd2:	a3 30 50 80 00       	mov    %eax,0x805030
  802cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cda:	8b 40 04             	mov    0x4(%eax),%eax
  802cdd:	85 c0                	test   %eax,%eax
  802cdf:	74 0f                	je     802cf0 <merging+0x105>
  802ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ce4:	8b 40 04             	mov    0x4(%eax),%eax
  802ce7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cea:	8b 12                	mov    (%edx),%edx
  802cec:	89 10                	mov    %edx,(%eax)
  802cee:	eb 0a                	jmp    802cfa <merging+0x10f>
  802cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cf3:	8b 00                	mov    (%eax),%eax
  802cf5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cfd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d03:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d06:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d0d:	a1 38 50 80 00       	mov    0x805038,%eax
  802d12:	48                   	dec    %eax
  802d13:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802d18:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d19:	e9 ea 02 00 00       	jmp    803008 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802d1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d22:	74 3b                	je     802d5f <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802d24:	83 ec 0c             	sub    $0xc,%esp
  802d27:	ff 75 08             	pushl  0x8(%ebp)
  802d2a:	e8 9b f0 ff ff       	call   801dca <get_block_size>
  802d2f:	83 c4 10             	add    $0x10,%esp
  802d32:	89 c3                	mov    %eax,%ebx
  802d34:	83 ec 0c             	sub    $0xc,%esp
  802d37:	ff 75 10             	pushl  0x10(%ebp)
  802d3a:	e8 8b f0 ff ff       	call   801dca <get_block_size>
  802d3f:	83 c4 10             	add    $0x10,%esp
  802d42:	01 d8                	add    %ebx,%eax
  802d44:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d47:	83 ec 04             	sub    $0x4,%esp
  802d4a:	6a 00                	push   $0x0
  802d4c:	ff 75 e8             	pushl  -0x18(%ebp)
  802d4f:	ff 75 08             	pushl  0x8(%ebp)
  802d52:	e8 c4 f3 ff ff       	call   80211b <set_block_data>
  802d57:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d5a:	e9 a9 02 00 00       	jmp    803008 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802d5f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d63:	0f 84 2d 01 00 00    	je     802e96 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802d69:	83 ec 0c             	sub    $0xc,%esp
  802d6c:	ff 75 10             	pushl  0x10(%ebp)
  802d6f:	e8 56 f0 ff ff       	call   801dca <get_block_size>
  802d74:	83 c4 10             	add    $0x10,%esp
  802d77:	89 c3                	mov    %eax,%ebx
  802d79:	83 ec 0c             	sub    $0xc,%esp
  802d7c:	ff 75 0c             	pushl  0xc(%ebp)
  802d7f:	e8 46 f0 ff ff       	call   801dca <get_block_size>
  802d84:	83 c4 10             	add    $0x10,%esp
  802d87:	01 d8                	add    %ebx,%eax
  802d89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802d8c:	83 ec 04             	sub    $0x4,%esp
  802d8f:	6a 00                	push   $0x0
  802d91:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d94:	ff 75 10             	pushl  0x10(%ebp)
  802d97:	e8 7f f3 ff ff       	call   80211b <set_block_data>
  802d9c:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802d9f:	8b 45 10             	mov    0x10(%ebp),%eax
  802da2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802da5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802da9:	74 06                	je     802db1 <merging+0x1c6>
  802dab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802daf:	75 17                	jne    802dc8 <merging+0x1dd>
  802db1:	83 ec 04             	sub    $0x4,%esp
  802db4:	68 e0 44 80 00       	push   $0x8044e0
  802db9:	68 8d 01 00 00       	push   $0x18d
  802dbe:	68 25 44 80 00       	push   $0x804425
  802dc3:	e8 ba d4 ff ff       	call   800282 <_panic>
  802dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dcb:	8b 50 04             	mov    0x4(%eax),%edx
  802dce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dd1:	89 50 04             	mov    %edx,0x4(%eax)
  802dd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dda:	89 10                	mov    %edx,(%eax)
  802ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ddf:	8b 40 04             	mov    0x4(%eax),%eax
  802de2:	85 c0                	test   %eax,%eax
  802de4:	74 0d                	je     802df3 <merging+0x208>
  802de6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de9:	8b 40 04             	mov    0x4(%eax),%eax
  802dec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802def:	89 10                	mov    %edx,(%eax)
  802df1:	eb 08                	jmp    802dfb <merging+0x210>
  802df3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802df6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dfe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e01:	89 50 04             	mov    %edx,0x4(%eax)
  802e04:	a1 38 50 80 00       	mov    0x805038,%eax
  802e09:	40                   	inc    %eax
  802e0a:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802e0f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e13:	75 17                	jne    802e2c <merging+0x241>
  802e15:	83 ec 04             	sub    $0x4,%esp
  802e18:	68 07 44 80 00       	push   $0x804407
  802e1d:	68 8e 01 00 00       	push   $0x18e
  802e22:	68 25 44 80 00       	push   $0x804425
  802e27:	e8 56 d4 ff ff       	call   800282 <_panic>
  802e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e2f:	8b 00                	mov    (%eax),%eax
  802e31:	85 c0                	test   %eax,%eax
  802e33:	74 10                	je     802e45 <merging+0x25a>
  802e35:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e38:	8b 00                	mov    (%eax),%eax
  802e3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e3d:	8b 52 04             	mov    0x4(%edx),%edx
  802e40:	89 50 04             	mov    %edx,0x4(%eax)
  802e43:	eb 0b                	jmp    802e50 <merging+0x265>
  802e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e48:	8b 40 04             	mov    0x4(%eax),%eax
  802e4b:	a3 30 50 80 00       	mov    %eax,0x805030
  802e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e53:	8b 40 04             	mov    0x4(%eax),%eax
  802e56:	85 c0                	test   %eax,%eax
  802e58:	74 0f                	je     802e69 <merging+0x27e>
  802e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e5d:	8b 40 04             	mov    0x4(%eax),%eax
  802e60:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e63:	8b 12                	mov    (%edx),%edx
  802e65:	89 10                	mov    %edx,(%eax)
  802e67:	eb 0a                	jmp    802e73 <merging+0x288>
  802e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e6c:	8b 00                	mov    (%eax),%eax
  802e6e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e86:	a1 38 50 80 00       	mov    0x805038,%eax
  802e8b:	48                   	dec    %eax
  802e8c:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e91:	e9 72 01 00 00       	jmp    803008 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802e96:	8b 45 10             	mov    0x10(%ebp),%eax
  802e99:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802e9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ea0:	74 79                	je     802f1b <merging+0x330>
  802ea2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ea6:	74 73                	je     802f1b <merging+0x330>
  802ea8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eac:	74 06                	je     802eb4 <merging+0x2c9>
  802eae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802eb2:	75 17                	jne    802ecb <merging+0x2e0>
  802eb4:	83 ec 04             	sub    $0x4,%esp
  802eb7:	68 98 44 80 00       	push   $0x804498
  802ebc:	68 94 01 00 00       	push   $0x194
  802ec1:	68 25 44 80 00       	push   $0x804425
  802ec6:	e8 b7 d3 ff ff       	call   800282 <_panic>
  802ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ece:	8b 10                	mov    (%eax),%edx
  802ed0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ed3:	89 10                	mov    %edx,(%eax)
  802ed5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ed8:	8b 00                	mov    (%eax),%eax
  802eda:	85 c0                	test   %eax,%eax
  802edc:	74 0b                	je     802ee9 <merging+0x2fe>
  802ede:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee1:	8b 00                	mov    (%eax),%eax
  802ee3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ee6:	89 50 04             	mov    %edx,0x4(%eax)
  802ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eec:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802eef:	89 10                	mov    %edx,(%eax)
  802ef1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef7:	89 50 04             	mov    %edx,0x4(%eax)
  802efa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802efd:	8b 00                	mov    (%eax),%eax
  802eff:	85 c0                	test   %eax,%eax
  802f01:	75 08                	jne    802f0b <merging+0x320>
  802f03:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f06:	a3 30 50 80 00       	mov    %eax,0x805030
  802f0b:	a1 38 50 80 00       	mov    0x805038,%eax
  802f10:	40                   	inc    %eax
  802f11:	a3 38 50 80 00       	mov    %eax,0x805038
  802f16:	e9 ce 00 00 00       	jmp    802fe9 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802f1b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f1f:	74 65                	je     802f86 <merging+0x39b>
  802f21:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f25:	75 17                	jne    802f3e <merging+0x353>
  802f27:	83 ec 04             	sub    $0x4,%esp
  802f2a:	68 74 44 80 00       	push   $0x804474
  802f2f:	68 95 01 00 00       	push   $0x195
  802f34:	68 25 44 80 00       	push   $0x804425
  802f39:	e8 44 d3 ff ff       	call   800282 <_panic>
  802f3e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f44:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f47:	89 50 04             	mov    %edx,0x4(%eax)
  802f4a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f4d:	8b 40 04             	mov    0x4(%eax),%eax
  802f50:	85 c0                	test   %eax,%eax
  802f52:	74 0c                	je     802f60 <merging+0x375>
  802f54:	a1 30 50 80 00       	mov    0x805030,%eax
  802f59:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f5c:	89 10                	mov    %edx,(%eax)
  802f5e:	eb 08                	jmp    802f68 <merging+0x37d>
  802f60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f63:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f68:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f6b:	a3 30 50 80 00       	mov    %eax,0x805030
  802f70:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f79:	a1 38 50 80 00       	mov    0x805038,%eax
  802f7e:	40                   	inc    %eax
  802f7f:	a3 38 50 80 00       	mov    %eax,0x805038
  802f84:	eb 63                	jmp    802fe9 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802f86:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f8a:	75 17                	jne    802fa3 <merging+0x3b8>
  802f8c:	83 ec 04             	sub    $0x4,%esp
  802f8f:	68 40 44 80 00       	push   $0x804440
  802f94:	68 98 01 00 00       	push   $0x198
  802f99:	68 25 44 80 00       	push   $0x804425
  802f9e:	e8 df d2 ff ff       	call   800282 <_panic>
  802fa3:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802fa9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fac:	89 10                	mov    %edx,(%eax)
  802fae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fb1:	8b 00                	mov    (%eax),%eax
  802fb3:	85 c0                	test   %eax,%eax
  802fb5:	74 0d                	je     802fc4 <merging+0x3d9>
  802fb7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fbc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fbf:	89 50 04             	mov    %edx,0x4(%eax)
  802fc2:	eb 08                	jmp    802fcc <merging+0x3e1>
  802fc4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fc7:	a3 30 50 80 00       	mov    %eax,0x805030
  802fcc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fcf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fd4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fd7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fde:	a1 38 50 80 00       	mov    0x805038,%eax
  802fe3:	40                   	inc    %eax
  802fe4:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802fe9:	83 ec 0c             	sub    $0xc,%esp
  802fec:	ff 75 10             	pushl  0x10(%ebp)
  802fef:	e8 d6 ed ff ff       	call   801dca <get_block_size>
  802ff4:	83 c4 10             	add    $0x10,%esp
  802ff7:	83 ec 04             	sub    $0x4,%esp
  802ffa:	6a 00                	push   $0x0
  802ffc:	50                   	push   %eax
  802ffd:	ff 75 10             	pushl  0x10(%ebp)
  803000:	e8 16 f1 ff ff       	call   80211b <set_block_data>
  803005:	83 c4 10             	add    $0x10,%esp
	}
}
  803008:	90                   	nop
  803009:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80300c:	c9                   	leave  
  80300d:	c3                   	ret    

0080300e <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80300e:	55                   	push   %ebp
  80300f:	89 e5                	mov    %esp,%ebp
  803011:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803014:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803019:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80301c:	a1 30 50 80 00       	mov    0x805030,%eax
  803021:	3b 45 08             	cmp    0x8(%ebp),%eax
  803024:	73 1b                	jae    803041 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803026:	a1 30 50 80 00       	mov    0x805030,%eax
  80302b:	83 ec 04             	sub    $0x4,%esp
  80302e:	ff 75 08             	pushl  0x8(%ebp)
  803031:	6a 00                	push   $0x0
  803033:	50                   	push   %eax
  803034:	e8 b2 fb ff ff       	call   802beb <merging>
  803039:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80303c:	e9 8b 00 00 00       	jmp    8030cc <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803041:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803046:	3b 45 08             	cmp    0x8(%ebp),%eax
  803049:	76 18                	jbe    803063 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80304b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803050:	83 ec 04             	sub    $0x4,%esp
  803053:	ff 75 08             	pushl  0x8(%ebp)
  803056:	50                   	push   %eax
  803057:	6a 00                	push   $0x0
  803059:	e8 8d fb ff ff       	call   802beb <merging>
  80305e:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803061:	eb 69                	jmp    8030cc <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803063:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803068:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80306b:	eb 39                	jmp    8030a6 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80306d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803070:	3b 45 08             	cmp    0x8(%ebp),%eax
  803073:	73 29                	jae    80309e <free_block+0x90>
  803075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803078:	8b 00                	mov    (%eax),%eax
  80307a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80307d:	76 1f                	jbe    80309e <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80307f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803082:	8b 00                	mov    (%eax),%eax
  803084:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803087:	83 ec 04             	sub    $0x4,%esp
  80308a:	ff 75 08             	pushl  0x8(%ebp)
  80308d:	ff 75 f0             	pushl  -0x10(%ebp)
  803090:	ff 75 f4             	pushl  -0xc(%ebp)
  803093:	e8 53 fb ff ff       	call   802beb <merging>
  803098:	83 c4 10             	add    $0x10,%esp
			break;
  80309b:	90                   	nop
		}
	}
}
  80309c:	eb 2e                	jmp    8030cc <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80309e:	a1 34 50 80 00       	mov    0x805034,%eax
  8030a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030aa:	74 07                	je     8030b3 <free_block+0xa5>
  8030ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030af:	8b 00                	mov    (%eax),%eax
  8030b1:	eb 05                	jmp    8030b8 <free_block+0xaa>
  8030b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b8:	a3 34 50 80 00       	mov    %eax,0x805034
  8030bd:	a1 34 50 80 00       	mov    0x805034,%eax
  8030c2:	85 c0                	test   %eax,%eax
  8030c4:	75 a7                	jne    80306d <free_block+0x5f>
  8030c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ca:	75 a1                	jne    80306d <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030cc:	90                   	nop
  8030cd:	c9                   	leave  
  8030ce:	c3                   	ret    

008030cf <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8030cf:	55                   	push   %ebp
  8030d0:	89 e5                	mov    %esp,%ebp
  8030d2:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8030d5:	ff 75 08             	pushl  0x8(%ebp)
  8030d8:	e8 ed ec ff ff       	call   801dca <get_block_size>
  8030dd:	83 c4 04             	add    $0x4,%esp
  8030e0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8030e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8030ea:	eb 17                	jmp    803103 <copy_data+0x34>
  8030ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8030ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f2:	01 c2                	add    %eax,%edx
  8030f4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8030f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fa:	01 c8                	add    %ecx,%eax
  8030fc:	8a 00                	mov    (%eax),%al
  8030fe:	88 02                	mov    %al,(%edx)
  803100:	ff 45 fc             	incl   -0x4(%ebp)
  803103:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803106:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803109:	72 e1                	jb     8030ec <copy_data+0x1d>
}
  80310b:	90                   	nop
  80310c:	c9                   	leave  
  80310d:	c3                   	ret    

0080310e <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80310e:	55                   	push   %ebp
  80310f:	89 e5                	mov    %esp,%ebp
  803111:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803114:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803118:	75 23                	jne    80313d <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80311a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80311e:	74 13                	je     803133 <realloc_block_FF+0x25>
  803120:	83 ec 0c             	sub    $0xc,%esp
  803123:	ff 75 0c             	pushl  0xc(%ebp)
  803126:	e8 1f f0 ff ff       	call   80214a <alloc_block_FF>
  80312b:	83 c4 10             	add    $0x10,%esp
  80312e:	e9 f4 06 00 00       	jmp    803827 <realloc_block_FF+0x719>
		return NULL;
  803133:	b8 00 00 00 00       	mov    $0x0,%eax
  803138:	e9 ea 06 00 00       	jmp    803827 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80313d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803141:	75 18                	jne    80315b <realloc_block_FF+0x4d>
	{
		free_block(va);
  803143:	83 ec 0c             	sub    $0xc,%esp
  803146:	ff 75 08             	pushl  0x8(%ebp)
  803149:	e8 c0 fe ff ff       	call   80300e <free_block>
  80314e:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803151:	b8 00 00 00 00       	mov    $0x0,%eax
  803156:	e9 cc 06 00 00       	jmp    803827 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80315b:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80315f:	77 07                	ja     803168 <realloc_block_FF+0x5a>
  803161:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80316b:	83 e0 01             	and    $0x1,%eax
  80316e:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803171:	8b 45 0c             	mov    0xc(%ebp),%eax
  803174:	83 c0 08             	add    $0x8,%eax
  803177:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80317a:	83 ec 0c             	sub    $0xc,%esp
  80317d:	ff 75 08             	pushl  0x8(%ebp)
  803180:	e8 45 ec ff ff       	call   801dca <get_block_size>
  803185:	83 c4 10             	add    $0x10,%esp
  803188:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80318b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80318e:	83 e8 08             	sub    $0x8,%eax
  803191:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803194:	8b 45 08             	mov    0x8(%ebp),%eax
  803197:	83 e8 04             	sub    $0x4,%eax
  80319a:	8b 00                	mov    (%eax),%eax
  80319c:	83 e0 fe             	and    $0xfffffffe,%eax
  80319f:	89 c2                	mov    %eax,%edx
  8031a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a4:	01 d0                	add    %edx,%eax
  8031a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8031a9:	83 ec 0c             	sub    $0xc,%esp
  8031ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031af:	e8 16 ec ff ff       	call   801dca <get_block_size>
  8031b4:	83 c4 10             	add    $0x10,%esp
  8031b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031bd:	83 e8 08             	sub    $0x8,%eax
  8031c0:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8031c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031c6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8031c9:	75 08                	jne    8031d3 <realloc_block_FF+0xc5>
	{
		 return va;
  8031cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ce:	e9 54 06 00 00       	jmp    803827 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8031d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031d6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8031d9:	0f 83 e5 03 00 00    	jae    8035c4 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8031df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e2:	2b 45 0c             	sub    0xc(%ebp),%eax
  8031e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8031e8:	83 ec 0c             	sub    $0xc,%esp
  8031eb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031ee:	e8 f0 eb ff ff       	call   801de3 <is_free_block>
  8031f3:	83 c4 10             	add    $0x10,%esp
  8031f6:	84 c0                	test   %al,%al
  8031f8:	0f 84 3b 01 00 00    	je     803339 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8031fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803201:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803204:	01 d0                	add    %edx,%eax
  803206:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803209:	83 ec 04             	sub    $0x4,%esp
  80320c:	6a 01                	push   $0x1
  80320e:	ff 75 f0             	pushl  -0x10(%ebp)
  803211:	ff 75 08             	pushl  0x8(%ebp)
  803214:	e8 02 ef ff ff       	call   80211b <set_block_data>
  803219:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80321c:	8b 45 08             	mov    0x8(%ebp),%eax
  80321f:	83 e8 04             	sub    $0x4,%eax
  803222:	8b 00                	mov    (%eax),%eax
  803224:	83 e0 fe             	and    $0xfffffffe,%eax
  803227:	89 c2                	mov    %eax,%edx
  803229:	8b 45 08             	mov    0x8(%ebp),%eax
  80322c:	01 d0                	add    %edx,%eax
  80322e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803231:	83 ec 04             	sub    $0x4,%esp
  803234:	6a 00                	push   $0x0
  803236:	ff 75 cc             	pushl  -0x34(%ebp)
  803239:	ff 75 c8             	pushl  -0x38(%ebp)
  80323c:	e8 da ee ff ff       	call   80211b <set_block_data>
  803241:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803244:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803248:	74 06                	je     803250 <realloc_block_FF+0x142>
  80324a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80324e:	75 17                	jne    803267 <realloc_block_FF+0x159>
  803250:	83 ec 04             	sub    $0x4,%esp
  803253:	68 98 44 80 00       	push   $0x804498
  803258:	68 f6 01 00 00       	push   $0x1f6
  80325d:	68 25 44 80 00       	push   $0x804425
  803262:	e8 1b d0 ff ff       	call   800282 <_panic>
  803267:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80326a:	8b 10                	mov    (%eax),%edx
  80326c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80326f:	89 10                	mov    %edx,(%eax)
  803271:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803274:	8b 00                	mov    (%eax),%eax
  803276:	85 c0                	test   %eax,%eax
  803278:	74 0b                	je     803285 <realloc_block_FF+0x177>
  80327a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80327d:	8b 00                	mov    (%eax),%eax
  80327f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803282:	89 50 04             	mov    %edx,0x4(%eax)
  803285:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803288:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80328b:	89 10                	mov    %edx,(%eax)
  80328d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803290:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803293:	89 50 04             	mov    %edx,0x4(%eax)
  803296:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803299:	8b 00                	mov    (%eax),%eax
  80329b:	85 c0                	test   %eax,%eax
  80329d:	75 08                	jne    8032a7 <realloc_block_FF+0x199>
  80329f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032a2:	a3 30 50 80 00       	mov    %eax,0x805030
  8032a7:	a1 38 50 80 00       	mov    0x805038,%eax
  8032ac:	40                   	inc    %eax
  8032ad:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8032b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032b6:	75 17                	jne    8032cf <realloc_block_FF+0x1c1>
  8032b8:	83 ec 04             	sub    $0x4,%esp
  8032bb:	68 07 44 80 00       	push   $0x804407
  8032c0:	68 f7 01 00 00       	push   $0x1f7
  8032c5:	68 25 44 80 00       	push   $0x804425
  8032ca:	e8 b3 cf ff ff       	call   800282 <_panic>
  8032cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d2:	8b 00                	mov    (%eax),%eax
  8032d4:	85 c0                	test   %eax,%eax
  8032d6:	74 10                	je     8032e8 <realloc_block_FF+0x1da>
  8032d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032db:	8b 00                	mov    (%eax),%eax
  8032dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032e0:	8b 52 04             	mov    0x4(%edx),%edx
  8032e3:	89 50 04             	mov    %edx,0x4(%eax)
  8032e6:	eb 0b                	jmp    8032f3 <realloc_block_FF+0x1e5>
  8032e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032eb:	8b 40 04             	mov    0x4(%eax),%eax
  8032ee:	a3 30 50 80 00       	mov    %eax,0x805030
  8032f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032f6:	8b 40 04             	mov    0x4(%eax),%eax
  8032f9:	85 c0                	test   %eax,%eax
  8032fb:	74 0f                	je     80330c <realloc_block_FF+0x1fe>
  8032fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803300:	8b 40 04             	mov    0x4(%eax),%eax
  803303:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803306:	8b 12                	mov    (%edx),%edx
  803308:	89 10                	mov    %edx,(%eax)
  80330a:	eb 0a                	jmp    803316 <realloc_block_FF+0x208>
  80330c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80330f:	8b 00                	mov    (%eax),%eax
  803311:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803316:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803319:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80331f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803322:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803329:	a1 38 50 80 00       	mov    0x805038,%eax
  80332e:	48                   	dec    %eax
  80332f:	a3 38 50 80 00       	mov    %eax,0x805038
  803334:	e9 83 02 00 00       	jmp    8035bc <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803339:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80333d:	0f 86 69 02 00 00    	jbe    8035ac <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803343:	83 ec 04             	sub    $0x4,%esp
  803346:	6a 01                	push   $0x1
  803348:	ff 75 f0             	pushl  -0x10(%ebp)
  80334b:	ff 75 08             	pushl  0x8(%ebp)
  80334e:	e8 c8 ed ff ff       	call   80211b <set_block_data>
  803353:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803356:	8b 45 08             	mov    0x8(%ebp),%eax
  803359:	83 e8 04             	sub    $0x4,%eax
  80335c:	8b 00                	mov    (%eax),%eax
  80335e:	83 e0 fe             	and    $0xfffffffe,%eax
  803361:	89 c2                	mov    %eax,%edx
  803363:	8b 45 08             	mov    0x8(%ebp),%eax
  803366:	01 d0                	add    %edx,%eax
  803368:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80336b:	a1 38 50 80 00       	mov    0x805038,%eax
  803370:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803373:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803377:	75 68                	jne    8033e1 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803379:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80337d:	75 17                	jne    803396 <realloc_block_FF+0x288>
  80337f:	83 ec 04             	sub    $0x4,%esp
  803382:	68 40 44 80 00       	push   $0x804440
  803387:	68 06 02 00 00       	push   $0x206
  80338c:	68 25 44 80 00       	push   $0x804425
  803391:	e8 ec ce ff ff       	call   800282 <_panic>
  803396:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80339c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80339f:	89 10                	mov    %edx,(%eax)
  8033a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033a4:	8b 00                	mov    (%eax),%eax
  8033a6:	85 c0                	test   %eax,%eax
  8033a8:	74 0d                	je     8033b7 <realloc_block_FF+0x2a9>
  8033aa:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033af:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033b2:	89 50 04             	mov    %edx,0x4(%eax)
  8033b5:	eb 08                	jmp    8033bf <realloc_block_FF+0x2b1>
  8033b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033ba:	a3 30 50 80 00       	mov    %eax,0x805030
  8033bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033c2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033d1:	a1 38 50 80 00       	mov    0x805038,%eax
  8033d6:	40                   	inc    %eax
  8033d7:	a3 38 50 80 00       	mov    %eax,0x805038
  8033dc:	e9 b0 01 00 00       	jmp    803591 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8033e1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033e6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8033e9:	76 68                	jbe    803453 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8033eb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033ef:	75 17                	jne    803408 <realloc_block_FF+0x2fa>
  8033f1:	83 ec 04             	sub    $0x4,%esp
  8033f4:	68 40 44 80 00       	push   $0x804440
  8033f9:	68 0b 02 00 00       	push   $0x20b
  8033fe:	68 25 44 80 00       	push   $0x804425
  803403:	e8 7a ce ff ff       	call   800282 <_panic>
  803408:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80340e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803411:	89 10                	mov    %edx,(%eax)
  803413:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803416:	8b 00                	mov    (%eax),%eax
  803418:	85 c0                	test   %eax,%eax
  80341a:	74 0d                	je     803429 <realloc_block_FF+0x31b>
  80341c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803421:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803424:	89 50 04             	mov    %edx,0x4(%eax)
  803427:	eb 08                	jmp    803431 <realloc_block_FF+0x323>
  803429:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80342c:	a3 30 50 80 00       	mov    %eax,0x805030
  803431:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803434:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803439:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80343c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803443:	a1 38 50 80 00       	mov    0x805038,%eax
  803448:	40                   	inc    %eax
  803449:	a3 38 50 80 00       	mov    %eax,0x805038
  80344e:	e9 3e 01 00 00       	jmp    803591 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803453:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803458:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80345b:	73 68                	jae    8034c5 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80345d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803461:	75 17                	jne    80347a <realloc_block_FF+0x36c>
  803463:	83 ec 04             	sub    $0x4,%esp
  803466:	68 74 44 80 00       	push   $0x804474
  80346b:	68 10 02 00 00       	push   $0x210
  803470:	68 25 44 80 00       	push   $0x804425
  803475:	e8 08 ce ff ff       	call   800282 <_panic>
  80347a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803480:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803483:	89 50 04             	mov    %edx,0x4(%eax)
  803486:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803489:	8b 40 04             	mov    0x4(%eax),%eax
  80348c:	85 c0                	test   %eax,%eax
  80348e:	74 0c                	je     80349c <realloc_block_FF+0x38e>
  803490:	a1 30 50 80 00       	mov    0x805030,%eax
  803495:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803498:	89 10                	mov    %edx,(%eax)
  80349a:	eb 08                	jmp    8034a4 <realloc_block_FF+0x396>
  80349c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80349f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034a7:	a3 30 50 80 00       	mov    %eax,0x805030
  8034ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034b5:	a1 38 50 80 00       	mov    0x805038,%eax
  8034ba:	40                   	inc    %eax
  8034bb:	a3 38 50 80 00       	mov    %eax,0x805038
  8034c0:	e9 cc 00 00 00       	jmp    803591 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8034c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8034cc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034d4:	e9 8a 00 00 00       	jmp    803563 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8034d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034dc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034df:	73 7a                	jae    80355b <realloc_block_FF+0x44d>
  8034e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e4:	8b 00                	mov    (%eax),%eax
  8034e6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034e9:	73 70                	jae    80355b <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8034eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034ef:	74 06                	je     8034f7 <realloc_block_FF+0x3e9>
  8034f1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034f5:	75 17                	jne    80350e <realloc_block_FF+0x400>
  8034f7:	83 ec 04             	sub    $0x4,%esp
  8034fa:	68 98 44 80 00       	push   $0x804498
  8034ff:	68 1a 02 00 00       	push   $0x21a
  803504:	68 25 44 80 00       	push   $0x804425
  803509:	e8 74 cd ff ff       	call   800282 <_panic>
  80350e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803511:	8b 10                	mov    (%eax),%edx
  803513:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803516:	89 10                	mov    %edx,(%eax)
  803518:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80351b:	8b 00                	mov    (%eax),%eax
  80351d:	85 c0                	test   %eax,%eax
  80351f:	74 0b                	je     80352c <realloc_block_FF+0x41e>
  803521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803524:	8b 00                	mov    (%eax),%eax
  803526:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803529:	89 50 04             	mov    %edx,0x4(%eax)
  80352c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803532:	89 10                	mov    %edx,(%eax)
  803534:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803537:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80353a:	89 50 04             	mov    %edx,0x4(%eax)
  80353d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803540:	8b 00                	mov    (%eax),%eax
  803542:	85 c0                	test   %eax,%eax
  803544:	75 08                	jne    80354e <realloc_block_FF+0x440>
  803546:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803549:	a3 30 50 80 00       	mov    %eax,0x805030
  80354e:	a1 38 50 80 00       	mov    0x805038,%eax
  803553:	40                   	inc    %eax
  803554:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803559:	eb 36                	jmp    803591 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80355b:	a1 34 50 80 00       	mov    0x805034,%eax
  803560:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803563:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803567:	74 07                	je     803570 <realloc_block_FF+0x462>
  803569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356c:	8b 00                	mov    (%eax),%eax
  80356e:	eb 05                	jmp    803575 <realloc_block_FF+0x467>
  803570:	b8 00 00 00 00       	mov    $0x0,%eax
  803575:	a3 34 50 80 00       	mov    %eax,0x805034
  80357a:	a1 34 50 80 00       	mov    0x805034,%eax
  80357f:	85 c0                	test   %eax,%eax
  803581:	0f 85 52 ff ff ff    	jne    8034d9 <realloc_block_FF+0x3cb>
  803587:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80358b:	0f 85 48 ff ff ff    	jne    8034d9 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803591:	83 ec 04             	sub    $0x4,%esp
  803594:	6a 00                	push   $0x0
  803596:	ff 75 d8             	pushl  -0x28(%ebp)
  803599:	ff 75 d4             	pushl  -0x2c(%ebp)
  80359c:	e8 7a eb ff ff       	call   80211b <set_block_data>
  8035a1:	83 c4 10             	add    $0x10,%esp
				return va;
  8035a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a7:	e9 7b 02 00 00       	jmp    803827 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8035ac:	83 ec 0c             	sub    $0xc,%esp
  8035af:	68 15 45 80 00       	push   $0x804515
  8035b4:	e8 86 cf ff ff       	call   80053f <cprintf>
  8035b9:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8035bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bf:	e9 63 02 00 00       	jmp    803827 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8035c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035c7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8035ca:	0f 86 4d 02 00 00    	jbe    80381d <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8035d0:	83 ec 0c             	sub    $0xc,%esp
  8035d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8035d6:	e8 08 e8 ff ff       	call   801de3 <is_free_block>
  8035db:	83 c4 10             	add    $0x10,%esp
  8035de:	84 c0                	test   %al,%al
  8035e0:	0f 84 37 02 00 00    	je     80381d <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8035e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035e9:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8035ec:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8035ef:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8035f2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8035f5:	76 38                	jbe    80362f <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8035f7:	83 ec 0c             	sub    $0xc,%esp
  8035fa:	ff 75 08             	pushl  0x8(%ebp)
  8035fd:	e8 0c fa ff ff       	call   80300e <free_block>
  803602:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803605:	83 ec 0c             	sub    $0xc,%esp
  803608:	ff 75 0c             	pushl  0xc(%ebp)
  80360b:	e8 3a eb ff ff       	call   80214a <alloc_block_FF>
  803610:	83 c4 10             	add    $0x10,%esp
  803613:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803616:	83 ec 08             	sub    $0x8,%esp
  803619:	ff 75 c0             	pushl  -0x40(%ebp)
  80361c:	ff 75 08             	pushl  0x8(%ebp)
  80361f:	e8 ab fa ff ff       	call   8030cf <copy_data>
  803624:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803627:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80362a:	e9 f8 01 00 00       	jmp    803827 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80362f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803632:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803635:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803638:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80363c:	0f 87 a0 00 00 00    	ja     8036e2 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803642:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803646:	75 17                	jne    80365f <realloc_block_FF+0x551>
  803648:	83 ec 04             	sub    $0x4,%esp
  80364b:	68 07 44 80 00       	push   $0x804407
  803650:	68 38 02 00 00       	push   $0x238
  803655:	68 25 44 80 00       	push   $0x804425
  80365a:	e8 23 cc ff ff       	call   800282 <_panic>
  80365f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803662:	8b 00                	mov    (%eax),%eax
  803664:	85 c0                	test   %eax,%eax
  803666:	74 10                	je     803678 <realloc_block_FF+0x56a>
  803668:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80366b:	8b 00                	mov    (%eax),%eax
  80366d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803670:	8b 52 04             	mov    0x4(%edx),%edx
  803673:	89 50 04             	mov    %edx,0x4(%eax)
  803676:	eb 0b                	jmp    803683 <realloc_block_FF+0x575>
  803678:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367b:	8b 40 04             	mov    0x4(%eax),%eax
  80367e:	a3 30 50 80 00       	mov    %eax,0x805030
  803683:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803686:	8b 40 04             	mov    0x4(%eax),%eax
  803689:	85 c0                	test   %eax,%eax
  80368b:	74 0f                	je     80369c <realloc_block_FF+0x58e>
  80368d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803690:	8b 40 04             	mov    0x4(%eax),%eax
  803693:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803696:	8b 12                	mov    (%edx),%edx
  803698:	89 10                	mov    %edx,(%eax)
  80369a:	eb 0a                	jmp    8036a6 <realloc_block_FF+0x598>
  80369c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369f:	8b 00                	mov    (%eax),%eax
  8036a1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036b9:	a1 38 50 80 00       	mov    0x805038,%eax
  8036be:	48                   	dec    %eax
  8036bf:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8036c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036ca:	01 d0                	add    %edx,%eax
  8036cc:	83 ec 04             	sub    $0x4,%esp
  8036cf:	6a 01                	push   $0x1
  8036d1:	50                   	push   %eax
  8036d2:	ff 75 08             	pushl  0x8(%ebp)
  8036d5:	e8 41 ea ff ff       	call   80211b <set_block_data>
  8036da:	83 c4 10             	add    $0x10,%esp
  8036dd:	e9 36 01 00 00       	jmp    803818 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8036e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036e5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8036e8:	01 d0                	add    %edx,%eax
  8036ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8036ed:	83 ec 04             	sub    $0x4,%esp
  8036f0:	6a 01                	push   $0x1
  8036f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8036f5:	ff 75 08             	pushl  0x8(%ebp)
  8036f8:	e8 1e ea ff ff       	call   80211b <set_block_data>
  8036fd:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803700:	8b 45 08             	mov    0x8(%ebp),%eax
  803703:	83 e8 04             	sub    $0x4,%eax
  803706:	8b 00                	mov    (%eax),%eax
  803708:	83 e0 fe             	and    $0xfffffffe,%eax
  80370b:	89 c2                	mov    %eax,%edx
  80370d:	8b 45 08             	mov    0x8(%ebp),%eax
  803710:	01 d0                	add    %edx,%eax
  803712:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803715:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803719:	74 06                	je     803721 <realloc_block_FF+0x613>
  80371b:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80371f:	75 17                	jne    803738 <realloc_block_FF+0x62a>
  803721:	83 ec 04             	sub    $0x4,%esp
  803724:	68 98 44 80 00       	push   $0x804498
  803729:	68 44 02 00 00       	push   $0x244
  80372e:	68 25 44 80 00       	push   $0x804425
  803733:	e8 4a cb ff ff       	call   800282 <_panic>
  803738:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80373b:	8b 10                	mov    (%eax),%edx
  80373d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803740:	89 10                	mov    %edx,(%eax)
  803742:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803745:	8b 00                	mov    (%eax),%eax
  803747:	85 c0                	test   %eax,%eax
  803749:	74 0b                	je     803756 <realloc_block_FF+0x648>
  80374b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80374e:	8b 00                	mov    (%eax),%eax
  803750:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803753:	89 50 04             	mov    %edx,0x4(%eax)
  803756:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803759:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80375c:	89 10                	mov    %edx,(%eax)
  80375e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803761:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803764:	89 50 04             	mov    %edx,0x4(%eax)
  803767:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80376a:	8b 00                	mov    (%eax),%eax
  80376c:	85 c0                	test   %eax,%eax
  80376e:	75 08                	jne    803778 <realloc_block_FF+0x66a>
  803770:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803773:	a3 30 50 80 00       	mov    %eax,0x805030
  803778:	a1 38 50 80 00       	mov    0x805038,%eax
  80377d:	40                   	inc    %eax
  80377e:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803783:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803787:	75 17                	jne    8037a0 <realloc_block_FF+0x692>
  803789:	83 ec 04             	sub    $0x4,%esp
  80378c:	68 07 44 80 00       	push   $0x804407
  803791:	68 45 02 00 00       	push   $0x245
  803796:	68 25 44 80 00       	push   $0x804425
  80379b:	e8 e2 ca ff ff       	call   800282 <_panic>
  8037a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a3:	8b 00                	mov    (%eax),%eax
  8037a5:	85 c0                	test   %eax,%eax
  8037a7:	74 10                	je     8037b9 <realloc_block_FF+0x6ab>
  8037a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ac:	8b 00                	mov    (%eax),%eax
  8037ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037b1:	8b 52 04             	mov    0x4(%edx),%edx
  8037b4:	89 50 04             	mov    %edx,0x4(%eax)
  8037b7:	eb 0b                	jmp    8037c4 <realloc_block_FF+0x6b6>
  8037b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037bc:	8b 40 04             	mov    0x4(%eax),%eax
  8037bf:	a3 30 50 80 00       	mov    %eax,0x805030
  8037c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c7:	8b 40 04             	mov    0x4(%eax),%eax
  8037ca:	85 c0                	test   %eax,%eax
  8037cc:	74 0f                	je     8037dd <realloc_block_FF+0x6cf>
  8037ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d1:	8b 40 04             	mov    0x4(%eax),%eax
  8037d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037d7:	8b 12                	mov    (%edx),%edx
  8037d9:	89 10                	mov    %edx,(%eax)
  8037db:	eb 0a                	jmp    8037e7 <realloc_block_FF+0x6d9>
  8037dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e0:	8b 00                	mov    (%eax),%eax
  8037e2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037fa:	a1 38 50 80 00       	mov    0x805038,%eax
  8037ff:	48                   	dec    %eax
  803800:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803805:	83 ec 04             	sub    $0x4,%esp
  803808:	6a 00                	push   $0x0
  80380a:	ff 75 bc             	pushl  -0x44(%ebp)
  80380d:	ff 75 b8             	pushl  -0x48(%ebp)
  803810:	e8 06 e9 ff ff       	call   80211b <set_block_data>
  803815:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803818:	8b 45 08             	mov    0x8(%ebp),%eax
  80381b:	eb 0a                	jmp    803827 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80381d:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803824:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803827:	c9                   	leave  
  803828:	c3                   	ret    

00803829 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803829:	55                   	push   %ebp
  80382a:	89 e5                	mov    %esp,%ebp
  80382c:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80382f:	83 ec 04             	sub    $0x4,%esp
  803832:	68 1c 45 80 00       	push   $0x80451c
  803837:	68 58 02 00 00       	push   $0x258
  80383c:	68 25 44 80 00       	push   $0x804425
  803841:	e8 3c ca ff ff       	call   800282 <_panic>

00803846 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803846:	55                   	push   %ebp
  803847:	89 e5                	mov    %esp,%ebp
  803849:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80384c:	83 ec 04             	sub    $0x4,%esp
  80384f:	68 44 45 80 00       	push   $0x804544
  803854:	68 61 02 00 00       	push   $0x261
  803859:	68 25 44 80 00       	push   $0x804425
  80385e:	e8 1f ca ff ff       	call   800282 <_panic>

00803863 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803863:	55                   	push   %ebp
  803864:	89 e5                	mov    %esp,%ebp
  803866:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803869:	8b 55 08             	mov    0x8(%ebp),%edx
  80386c:	89 d0                	mov    %edx,%eax
  80386e:	c1 e0 02             	shl    $0x2,%eax
  803871:	01 d0                	add    %edx,%eax
  803873:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80387a:	01 d0                	add    %edx,%eax
  80387c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803883:	01 d0                	add    %edx,%eax
  803885:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80388c:	01 d0                	add    %edx,%eax
  80388e:	c1 e0 04             	shl    $0x4,%eax
  803891:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803894:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80389b:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80389e:	83 ec 0c             	sub    $0xc,%esp
  8038a1:	50                   	push   %eax
  8038a2:	e8 2f e2 ff ff       	call   801ad6 <sys_get_virtual_time>
  8038a7:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8038aa:	eb 41                	jmp    8038ed <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8038ac:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8038af:	83 ec 0c             	sub    $0xc,%esp
  8038b2:	50                   	push   %eax
  8038b3:	e8 1e e2 ff ff       	call   801ad6 <sys_get_virtual_time>
  8038b8:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8038bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c1:	29 c2                	sub    %eax,%edx
  8038c3:	89 d0                	mov    %edx,%eax
  8038c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8038c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038ce:	89 d1                	mov    %edx,%ecx
  8038d0:	29 c1                	sub    %eax,%ecx
  8038d2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8038d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038d8:	39 c2                	cmp    %eax,%edx
  8038da:	0f 97 c0             	seta   %al
  8038dd:	0f b6 c0             	movzbl %al,%eax
  8038e0:	29 c1                	sub    %eax,%ecx
  8038e2:	89 c8                	mov    %ecx,%eax
  8038e4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8038e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8038ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8038f3:	72 b7                	jb     8038ac <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8038f5:	90                   	nop
  8038f6:	c9                   	leave  
  8038f7:	c3                   	ret    

008038f8 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8038f8:	55                   	push   %ebp
  8038f9:	89 e5                	mov    %esp,%ebp
  8038fb:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8038fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803905:	eb 03                	jmp    80390a <busy_wait+0x12>
  803907:	ff 45 fc             	incl   -0x4(%ebp)
  80390a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80390d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803910:	72 f5                	jb     803907 <busy_wait+0xf>
	return i;
  803912:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803915:	c9                   	leave  
  803916:	c3                   	ret    
  803917:	90                   	nop

00803918 <__udivdi3>:
  803918:	55                   	push   %ebp
  803919:	57                   	push   %edi
  80391a:	56                   	push   %esi
  80391b:	53                   	push   %ebx
  80391c:	83 ec 1c             	sub    $0x1c,%esp
  80391f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803923:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803927:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80392b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80392f:	89 ca                	mov    %ecx,%edx
  803931:	89 f8                	mov    %edi,%eax
  803933:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803937:	85 f6                	test   %esi,%esi
  803939:	75 2d                	jne    803968 <__udivdi3+0x50>
  80393b:	39 cf                	cmp    %ecx,%edi
  80393d:	77 65                	ja     8039a4 <__udivdi3+0x8c>
  80393f:	89 fd                	mov    %edi,%ebp
  803941:	85 ff                	test   %edi,%edi
  803943:	75 0b                	jne    803950 <__udivdi3+0x38>
  803945:	b8 01 00 00 00       	mov    $0x1,%eax
  80394a:	31 d2                	xor    %edx,%edx
  80394c:	f7 f7                	div    %edi
  80394e:	89 c5                	mov    %eax,%ebp
  803950:	31 d2                	xor    %edx,%edx
  803952:	89 c8                	mov    %ecx,%eax
  803954:	f7 f5                	div    %ebp
  803956:	89 c1                	mov    %eax,%ecx
  803958:	89 d8                	mov    %ebx,%eax
  80395a:	f7 f5                	div    %ebp
  80395c:	89 cf                	mov    %ecx,%edi
  80395e:	89 fa                	mov    %edi,%edx
  803960:	83 c4 1c             	add    $0x1c,%esp
  803963:	5b                   	pop    %ebx
  803964:	5e                   	pop    %esi
  803965:	5f                   	pop    %edi
  803966:	5d                   	pop    %ebp
  803967:	c3                   	ret    
  803968:	39 ce                	cmp    %ecx,%esi
  80396a:	77 28                	ja     803994 <__udivdi3+0x7c>
  80396c:	0f bd fe             	bsr    %esi,%edi
  80396f:	83 f7 1f             	xor    $0x1f,%edi
  803972:	75 40                	jne    8039b4 <__udivdi3+0x9c>
  803974:	39 ce                	cmp    %ecx,%esi
  803976:	72 0a                	jb     803982 <__udivdi3+0x6a>
  803978:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80397c:	0f 87 9e 00 00 00    	ja     803a20 <__udivdi3+0x108>
  803982:	b8 01 00 00 00       	mov    $0x1,%eax
  803987:	89 fa                	mov    %edi,%edx
  803989:	83 c4 1c             	add    $0x1c,%esp
  80398c:	5b                   	pop    %ebx
  80398d:	5e                   	pop    %esi
  80398e:	5f                   	pop    %edi
  80398f:	5d                   	pop    %ebp
  803990:	c3                   	ret    
  803991:	8d 76 00             	lea    0x0(%esi),%esi
  803994:	31 ff                	xor    %edi,%edi
  803996:	31 c0                	xor    %eax,%eax
  803998:	89 fa                	mov    %edi,%edx
  80399a:	83 c4 1c             	add    $0x1c,%esp
  80399d:	5b                   	pop    %ebx
  80399e:	5e                   	pop    %esi
  80399f:	5f                   	pop    %edi
  8039a0:	5d                   	pop    %ebp
  8039a1:	c3                   	ret    
  8039a2:	66 90                	xchg   %ax,%ax
  8039a4:	89 d8                	mov    %ebx,%eax
  8039a6:	f7 f7                	div    %edi
  8039a8:	31 ff                	xor    %edi,%edi
  8039aa:	89 fa                	mov    %edi,%edx
  8039ac:	83 c4 1c             	add    $0x1c,%esp
  8039af:	5b                   	pop    %ebx
  8039b0:	5e                   	pop    %esi
  8039b1:	5f                   	pop    %edi
  8039b2:	5d                   	pop    %ebp
  8039b3:	c3                   	ret    
  8039b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8039b9:	89 eb                	mov    %ebp,%ebx
  8039bb:	29 fb                	sub    %edi,%ebx
  8039bd:	89 f9                	mov    %edi,%ecx
  8039bf:	d3 e6                	shl    %cl,%esi
  8039c1:	89 c5                	mov    %eax,%ebp
  8039c3:	88 d9                	mov    %bl,%cl
  8039c5:	d3 ed                	shr    %cl,%ebp
  8039c7:	89 e9                	mov    %ebp,%ecx
  8039c9:	09 f1                	or     %esi,%ecx
  8039cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8039cf:	89 f9                	mov    %edi,%ecx
  8039d1:	d3 e0                	shl    %cl,%eax
  8039d3:	89 c5                	mov    %eax,%ebp
  8039d5:	89 d6                	mov    %edx,%esi
  8039d7:	88 d9                	mov    %bl,%cl
  8039d9:	d3 ee                	shr    %cl,%esi
  8039db:	89 f9                	mov    %edi,%ecx
  8039dd:	d3 e2                	shl    %cl,%edx
  8039df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039e3:	88 d9                	mov    %bl,%cl
  8039e5:	d3 e8                	shr    %cl,%eax
  8039e7:	09 c2                	or     %eax,%edx
  8039e9:	89 d0                	mov    %edx,%eax
  8039eb:	89 f2                	mov    %esi,%edx
  8039ed:	f7 74 24 0c          	divl   0xc(%esp)
  8039f1:	89 d6                	mov    %edx,%esi
  8039f3:	89 c3                	mov    %eax,%ebx
  8039f5:	f7 e5                	mul    %ebp
  8039f7:	39 d6                	cmp    %edx,%esi
  8039f9:	72 19                	jb     803a14 <__udivdi3+0xfc>
  8039fb:	74 0b                	je     803a08 <__udivdi3+0xf0>
  8039fd:	89 d8                	mov    %ebx,%eax
  8039ff:	31 ff                	xor    %edi,%edi
  803a01:	e9 58 ff ff ff       	jmp    80395e <__udivdi3+0x46>
  803a06:	66 90                	xchg   %ax,%ax
  803a08:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a0c:	89 f9                	mov    %edi,%ecx
  803a0e:	d3 e2                	shl    %cl,%edx
  803a10:	39 c2                	cmp    %eax,%edx
  803a12:	73 e9                	jae    8039fd <__udivdi3+0xe5>
  803a14:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a17:	31 ff                	xor    %edi,%edi
  803a19:	e9 40 ff ff ff       	jmp    80395e <__udivdi3+0x46>
  803a1e:	66 90                	xchg   %ax,%ax
  803a20:	31 c0                	xor    %eax,%eax
  803a22:	e9 37 ff ff ff       	jmp    80395e <__udivdi3+0x46>
  803a27:	90                   	nop

00803a28 <__umoddi3>:
  803a28:	55                   	push   %ebp
  803a29:	57                   	push   %edi
  803a2a:	56                   	push   %esi
  803a2b:	53                   	push   %ebx
  803a2c:	83 ec 1c             	sub    $0x1c,%esp
  803a2f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a33:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a3f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a43:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a47:	89 f3                	mov    %esi,%ebx
  803a49:	89 fa                	mov    %edi,%edx
  803a4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a4f:	89 34 24             	mov    %esi,(%esp)
  803a52:	85 c0                	test   %eax,%eax
  803a54:	75 1a                	jne    803a70 <__umoddi3+0x48>
  803a56:	39 f7                	cmp    %esi,%edi
  803a58:	0f 86 a2 00 00 00    	jbe    803b00 <__umoddi3+0xd8>
  803a5e:	89 c8                	mov    %ecx,%eax
  803a60:	89 f2                	mov    %esi,%edx
  803a62:	f7 f7                	div    %edi
  803a64:	89 d0                	mov    %edx,%eax
  803a66:	31 d2                	xor    %edx,%edx
  803a68:	83 c4 1c             	add    $0x1c,%esp
  803a6b:	5b                   	pop    %ebx
  803a6c:	5e                   	pop    %esi
  803a6d:	5f                   	pop    %edi
  803a6e:	5d                   	pop    %ebp
  803a6f:	c3                   	ret    
  803a70:	39 f0                	cmp    %esi,%eax
  803a72:	0f 87 ac 00 00 00    	ja     803b24 <__umoddi3+0xfc>
  803a78:	0f bd e8             	bsr    %eax,%ebp
  803a7b:	83 f5 1f             	xor    $0x1f,%ebp
  803a7e:	0f 84 ac 00 00 00    	je     803b30 <__umoddi3+0x108>
  803a84:	bf 20 00 00 00       	mov    $0x20,%edi
  803a89:	29 ef                	sub    %ebp,%edi
  803a8b:	89 fe                	mov    %edi,%esi
  803a8d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a91:	89 e9                	mov    %ebp,%ecx
  803a93:	d3 e0                	shl    %cl,%eax
  803a95:	89 d7                	mov    %edx,%edi
  803a97:	89 f1                	mov    %esi,%ecx
  803a99:	d3 ef                	shr    %cl,%edi
  803a9b:	09 c7                	or     %eax,%edi
  803a9d:	89 e9                	mov    %ebp,%ecx
  803a9f:	d3 e2                	shl    %cl,%edx
  803aa1:	89 14 24             	mov    %edx,(%esp)
  803aa4:	89 d8                	mov    %ebx,%eax
  803aa6:	d3 e0                	shl    %cl,%eax
  803aa8:	89 c2                	mov    %eax,%edx
  803aaa:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aae:	d3 e0                	shl    %cl,%eax
  803ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ab4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ab8:	89 f1                	mov    %esi,%ecx
  803aba:	d3 e8                	shr    %cl,%eax
  803abc:	09 d0                	or     %edx,%eax
  803abe:	d3 eb                	shr    %cl,%ebx
  803ac0:	89 da                	mov    %ebx,%edx
  803ac2:	f7 f7                	div    %edi
  803ac4:	89 d3                	mov    %edx,%ebx
  803ac6:	f7 24 24             	mull   (%esp)
  803ac9:	89 c6                	mov    %eax,%esi
  803acb:	89 d1                	mov    %edx,%ecx
  803acd:	39 d3                	cmp    %edx,%ebx
  803acf:	0f 82 87 00 00 00    	jb     803b5c <__umoddi3+0x134>
  803ad5:	0f 84 91 00 00 00    	je     803b6c <__umoddi3+0x144>
  803adb:	8b 54 24 04          	mov    0x4(%esp),%edx
  803adf:	29 f2                	sub    %esi,%edx
  803ae1:	19 cb                	sbb    %ecx,%ebx
  803ae3:	89 d8                	mov    %ebx,%eax
  803ae5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ae9:	d3 e0                	shl    %cl,%eax
  803aeb:	89 e9                	mov    %ebp,%ecx
  803aed:	d3 ea                	shr    %cl,%edx
  803aef:	09 d0                	or     %edx,%eax
  803af1:	89 e9                	mov    %ebp,%ecx
  803af3:	d3 eb                	shr    %cl,%ebx
  803af5:	89 da                	mov    %ebx,%edx
  803af7:	83 c4 1c             	add    $0x1c,%esp
  803afa:	5b                   	pop    %ebx
  803afb:	5e                   	pop    %esi
  803afc:	5f                   	pop    %edi
  803afd:	5d                   	pop    %ebp
  803afe:	c3                   	ret    
  803aff:	90                   	nop
  803b00:	89 fd                	mov    %edi,%ebp
  803b02:	85 ff                	test   %edi,%edi
  803b04:	75 0b                	jne    803b11 <__umoddi3+0xe9>
  803b06:	b8 01 00 00 00       	mov    $0x1,%eax
  803b0b:	31 d2                	xor    %edx,%edx
  803b0d:	f7 f7                	div    %edi
  803b0f:	89 c5                	mov    %eax,%ebp
  803b11:	89 f0                	mov    %esi,%eax
  803b13:	31 d2                	xor    %edx,%edx
  803b15:	f7 f5                	div    %ebp
  803b17:	89 c8                	mov    %ecx,%eax
  803b19:	f7 f5                	div    %ebp
  803b1b:	89 d0                	mov    %edx,%eax
  803b1d:	e9 44 ff ff ff       	jmp    803a66 <__umoddi3+0x3e>
  803b22:	66 90                	xchg   %ax,%ax
  803b24:	89 c8                	mov    %ecx,%eax
  803b26:	89 f2                	mov    %esi,%edx
  803b28:	83 c4 1c             	add    $0x1c,%esp
  803b2b:	5b                   	pop    %ebx
  803b2c:	5e                   	pop    %esi
  803b2d:	5f                   	pop    %edi
  803b2e:	5d                   	pop    %ebp
  803b2f:	c3                   	ret    
  803b30:	3b 04 24             	cmp    (%esp),%eax
  803b33:	72 06                	jb     803b3b <__umoddi3+0x113>
  803b35:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b39:	77 0f                	ja     803b4a <__umoddi3+0x122>
  803b3b:	89 f2                	mov    %esi,%edx
  803b3d:	29 f9                	sub    %edi,%ecx
  803b3f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b43:	89 14 24             	mov    %edx,(%esp)
  803b46:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b4a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b4e:	8b 14 24             	mov    (%esp),%edx
  803b51:	83 c4 1c             	add    $0x1c,%esp
  803b54:	5b                   	pop    %ebx
  803b55:	5e                   	pop    %esi
  803b56:	5f                   	pop    %edi
  803b57:	5d                   	pop    %ebp
  803b58:	c3                   	ret    
  803b59:	8d 76 00             	lea    0x0(%esi),%esi
  803b5c:	2b 04 24             	sub    (%esp),%eax
  803b5f:	19 fa                	sbb    %edi,%edx
  803b61:	89 d1                	mov    %edx,%ecx
  803b63:	89 c6                	mov    %eax,%esi
  803b65:	e9 71 ff ff ff       	jmp    803adb <__umoddi3+0xb3>
  803b6a:	66 90                	xchg   %ax,%ax
  803b6c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b70:	72 ea                	jb     803b5c <__umoddi3+0x134>
  803b72:	89 d9                	mov    %ebx,%ecx
  803b74:	e9 62 ff ff ff       	jmp    803adb <__umoddi3+0xb3>
