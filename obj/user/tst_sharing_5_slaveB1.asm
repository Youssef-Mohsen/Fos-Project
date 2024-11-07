
obj/user/tst_sharing_5_slaveB1:     file format elf32-i386


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
  800031:	e8 f2 00 00 00       	call   800128 <libmain>
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
  80003e:	a1 04 30 80 00       	mov    0x803004,%eax
  800043:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  800049:	a1 04 30 80 00       	mov    0x803004,%eax
  80004e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800054:	39 c2                	cmp    %eax,%edx
  800056:	72 14                	jb     80006c <_main+0x34>
			panic("Please increase the WS size");
  800058:	83 ec 04             	sub    $0x4,%esp
  80005b:	68 40 1d 80 00       	push   $0x801d40
  800060:	6a 0c                	push   $0xc
  800062:	68 5c 1d 80 00       	push   $0x801d5c
  800067:	e8 f3 01 00 00       	call   80025f <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006c:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	x = sget(sys_getparentenvid(),"x");
  800073:	e8 6a 16 00 00       	call   8016e2 <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 79 1d 80 00       	push   $0x801d79
  800080:	50                   	push   %eax
  800081:	e8 b8 12 00 00       	call   80133e <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 7c 1d 80 00       	push   $0x801d7c
  800094:	e8 83 04 00 00       	call   80051c <cprintf>
  800099:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got x
	inctst();
  80009c:	e8 66 17 00 00       	call   801807 <inctst>
	cprintf("Slave B1 please be patient ...\n");
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	68 a4 1d 80 00       	push   $0x801da4
  8000a9:	e8 6e 04 00 00       	call   80051c <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(6000);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 70 17 00 00       	push   $0x1770
  8000b9:	e8 4b 19 00 00       	call   801a09 <env_sleep>
  8000be:	83 c4 10             	add    $0x10,%esp
	while (gettst()!=2) ;// panic("test failed");
  8000c1:	90                   	nop
  8000c2:	e8 5a 17 00 00       	call   801821 <gettst>
  8000c7:	83 f8 02             	cmp    $0x2,%eax
  8000ca:	75 f6                	jne    8000c2 <_main+0x8a>

	freeFrames = sys_calculate_free_frames() ;
  8000cc:	e8 2f 14 00 00       	call   801500 <sys_calculate_free_frames>
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	sfree(x);
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000da:	e8 79 12 00 00       	call   801358 <sfree>
  8000df:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 c4 1d 80 00       	push   $0x801dc4
  8000ea:	e8 2d 04 00 00       	call   80051c <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
	expected = 1+1; /*1page+1table*/
  8000f2:	c7 45 e8 02 00 00 00 	movl   $0x2,-0x18(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  8000f9:	e8 02 14 00 00       	call   801500 <sys_calculate_free_frames>
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800103:	29 c2                	sub    %eax,%edx
  800105:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800108:	39 c2                	cmp    %eax,%edx
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 dc 1d 80 00       	push   $0x801ddc
  800114:	6a 26                	push   $0x26
  800116:	68 5c 1d 80 00       	push   $0x801d5c
  80011b:	e8 3f 01 00 00       	call   80025f <_panic>

	//To indicate that it's completed successfully
	inctst();
  800120:	e8 e2 16 00 00       	call   801807 <inctst>
	return;
  800125:	90                   	nop
}
  800126:	c9                   	leave  
  800127:	c3                   	ret    

00800128 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800128:	55                   	push   %ebp
  800129:	89 e5                	mov    %esp,%ebp
  80012b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80012e:	e8 96 15 00 00       	call   8016c9 <sys_getenvindex>
  800133:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800136:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800139:	89 d0                	mov    %edx,%eax
  80013b:	c1 e0 02             	shl    $0x2,%eax
  80013e:	01 d0                	add    %edx,%eax
  800140:	01 c0                	add    %eax,%eax
  800142:	01 d0                	add    %edx,%eax
  800144:	c1 e0 02             	shl    $0x2,%eax
  800147:	01 d0                	add    %edx,%eax
  800149:	01 c0                	add    %eax,%eax
  80014b:	01 d0                	add    %edx,%eax
  80014d:	c1 e0 04             	shl    $0x4,%eax
  800150:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800155:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80015a:	a1 04 30 80 00       	mov    0x803004,%eax
  80015f:	8a 40 20             	mov    0x20(%eax),%al
  800162:	84 c0                	test   %al,%al
  800164:	74 0d                	je     800173 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800166:	a1 04 30 80 00       	mov    0x803004,%eax
  80016b:	83 c0 20             	add    $0x20,%eax
  80016e:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800173:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800177:	7e 0a                	jle    800183 <libmain+0x5b>
		binaryname = argv[0];
  800179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80017c:	8b 00                	mov    (%eax),%eax
  80017e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	ff 75 0c             	pushl  0xc(%ebp)
  800189:	ff 75 08             	pushl  0x8(%ebp)
  80018c:	e8 a7 fe ff ff       	call   800038 <_main>
  800191:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800194:	e8 b4 12 00 00       	call   80144d <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800199:	83 ec 0c             	sub    $0xc,%esp
  80019c:	68 9c 1e 80 00       	push   $0x801e9c
  8001a1:	e8 76 03 00 00       	call   80051c <cprintf>
  8001a6:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001a9:	a1 04 30 80 00       	mov    0x803004,%eax
  8001ae:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8001b4:	a1 04 30 80 00       	mov    0x803004,%eax
  8001b9:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8001bf:	83 ec 04             	sub    $0x4,%esp
  8001c2:	52                   	push   %edx
  8001c3:	50                   	push   %eax
  8001c4:	68 c4 1e 80 00       	push   $0x801ec4
  8001c9:	e8 4e 03 00 00       	call   80051c <cprintf>
  8001ce:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001d1:	a1 04 30 80 00       	mov    0x803004,%eax
  8001d6:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  8001dc:	a1 04 30 80 00       	mov    0x803004,%eax
  8001e1:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  8001e7:	a1 04 30 80 00       	mov    0x803004,%eax
  8001ec:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8001f2:	51                   	push   %ecx
  8001f3:	52                   	push   %edx
  8001f4:	50                   	push   %eax
  8001f5:	68 ec 1e 80 00       	push   $0x801eec
  8001fa:	e8 1d 03 00 00       	call   80051c <cprintf>
  8001ff:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800202:	a1 04 30 80 00       	mov    0x803004,%eax
  800207:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80020d:	83 ec 08             	sub    $0x8,%esp
  800210:	50                   	push   %eax
  800211:	68 44 1f 80 00       	push   $0x801f44
  800216:	e8 01 03 00 00       	call   80051c <cprintf>
  80021b:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80021e:	83 ec 0c             	sub    $0xc,%esp
  800221:	68 9c 1e 80 00       	push   $0x801e9c
  800226:	e8 f1 02 00 00       	call   80051c <cprintf>
  80022b:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80022e:	e8 34 12 00 00       	call   801467 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800233:	e8 19 00 00 00       	call   800251 <exit>
}
  800238:	90                   	nop
  800239:	c9                   	leave  
  80023a:	c3                   	ret    

0080023b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80023b:	55                   	push   %ebp
  80023c:	89 e5                	mov    %esp,%ebp
  80023e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	6a 00                	push   $0x0
  800246:	e8 4a 14 00 00       	call   801695 <sys_destroy_env>
  80024b:	83 c4 10             	add    $0x10,%esp
}
  80024e:	90                   	nop
  80024f:	c9                   	leave  
  800250:	c3                   	ret    

00800251 <exit>:

void
exit(void)
{
  800251:	55                   	push   %ebp
  800252:	89 e5                	mov    %esp,%ebp
  800254:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800257:	e8 9f 14 00 00       	call   8016fb <sys_exit_env>
}
  80025c:	90                   	nop
  80025d:	c9                   	leave  
  80025e:	c3                   	ret    

0080025f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80025f:	55                   	push   %ebp
  800260:	89 e5                	mov    %esp,%ebp
  800262:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800265:	8d 45 10             	lea    0x10(%ebp),%eax
  800268:	83 c0 04             	add    $0x4,%eax
  80026b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80026e:	a1 24 30 80 00       	mov    0x803024,%eax
  800273:	85 c0                	test   %eax,%eax
  800275:	74 16                	je     80028d <_panic+0x2e>
		cprintf("%s: ", argv0);
  800277:	a1 24 30 80 00       	mov    0x803024,%eax
  80027c:	83 ec 08             	sub    $0x8,%esp
  80027f:	50                   	push   %eax
  800280:	68 58 1f 80 00       	push   $0x801f58
  800285:	e8 92 02 00 00       	call   80051c <cprintf>
  80028a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80028d:	a1 00 30 80 00       	mov    0x803000,%eax
  800292:	ff 75 0c             	pushl  0xc(%ebp)
  800295:	ff 75 08             	pushl  0x8(%ebp)
  800298:	50                   	push   %eax
  800299:	68 5d 1f 80 00       	push   $0x801f5d
  80029e:	e8 79 02 00 00       	call   80051c <cprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a9:	83 ec 08             	sub    $0x8,%esp
  8002ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8002af:	50                   	push   %eax
  8002b0:	e8 fc 01 00 00       	call   8004b1 <vcprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002b8:	83 ec 08             	sub    $0x8,%esp
  8002bb:	6a 00                	push   $0x0
  8002bd:	68 79 1f 80 00       	push   $0x801f79
  8002c2:	e8 ea 01 00 00       	call   8004b1 <vcprintf>
  8002c7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002ca:	e8 82 ff ff ff       	call   800251 <exit>

	// should not return here
	while (1) ;
  8002cf:	eb fe                	jmp    8002cf <_panic+0x70>

008002d1 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002d7:	a1 04 30 80 00       	mov    0x803004,%eax
  8002dc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8002e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e5:	39 c2                	cmp    %eax,%edx
  8002e7:	74 14                	je     8002fd <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002e9:	83 ec 04             	sub    $0x4,%esp
  8002ec:	68 7c 1f 80 00       	push   $0x801f7c
  8002f1:	6a 26                	push   $0x26
  8002f3:	68 c8 1f 80 00       	push   $0x801fc8
  8002f8:	e8 62 ff ff ff       	call   80025f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800304:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80030b:	e9 c5 00 00 00       	jmp    8003d5 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800310:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800313:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80031a:	8b 45 08             	mov    0x8(%ebp),%eax
  80031d:	01 d0                	add    %edx,%eax
  80031f:	8b 00                	mov    (%eax),%eax
  800321:	85 c0                	test   %eax,%eax
  800323:	75 08                	jne    80032d <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800325:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800328:	e9 a5 00 00 00       	jmp    8003d2 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80032d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800334:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80033b:	eb 69                	jmp    8003a6 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80033d:	a1 04 30 80 00       	mov    0x803004,%eax
  800342:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800348:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80034b:	89 d0                	mov    %edx,%eax
  80034d:	01 c0                	add    %eax,%eax
  80034f:	01 d0                	add    %edx,%eax
  800351:	c1 e0 03             	shl    $0x3,%eax
  800354:	01 c8                	add    %ecx,%eax
  800356:	8a 40 04             	mov    0x4(%eax),%al
  800359:	84 c0                	test   %al,%al
  80035b:	75 46                	jne    8003a3 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80035d:	a1 04 30 80 00       	mov    0x803004,%eax
  800362:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800368:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80036b:	89 d0                	mov    %edx,%eax
  80036d:	01 c0                	add    %eax,%eax
  80036f:	01 d0                	add    %edx,%eax
  800371:	c1 e0 03             	shl    $0x3,%eax
  800374:	01 c8                	add    %ecx,%eax
  800376:	8b 00                	mov    (%eax),%eax
  800378:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80037b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80037e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800383:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800385:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800388:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	01 c8                	add    %ecx,%eax
  800394:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800396:	39 c2                	cmp    %eax,%edx
  800398:	75 09                	jne    8003a3 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80039a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003a1:	eb 15                	jmp    8003b8 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003a3:	ff 45 e8             	incl   -0x18(%ebp)
  8003a6:	a1 04 30 80 00       	mov    0x803004,%eax
  8003ab:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003b4:	39 c2                	cmp    %eax,%edx
  8003b6:	77 85                	ja     80033d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003bc:	75 14                	jne    8003d2 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003be:	83 ec 04             	sub    $0x4,%esp
  8003c1:	68 d4 1f 80 00       	push   $0x801fd4
  8003c6:	6a 3a                	push   $0x3a
  8003c8:	68 c8 1f 80 00       	push   $0x801fc8
  8003cd:	e8 8d fe ff ff       	call   80025f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003d2:	ff 45 f0             	incl   -0x10(%ebp)
  8003d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003db:	0f 8c 2f ff ff ff    	jl     800310 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003e1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003ef:	eb 26                	jmp    800417 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003f1:	a1 04 30 80 00       	mov    0x803004,%eax
  8003f6:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8003fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ff:	89 d0                	mov    %edx,%eax
  800401:	01 c0                	add    %eax,%eax
  800403:	01 d0                	add    %edx,%eax
  800405:	c1 e0 03             	shl    $0x3,%eax
  800408:	01 c8                	add    %ecx,%eax
  80040a:	8a 40 04             	mov    0x4(%eax),%al
  80040d:	3c 01                	cmp    $0x1,%al
  80040f:	75 03                	jne    800414 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800411:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800414:	ff 45 e0             	incl   -0x20(%ebp)
  800417:	a1 04 30 80 00       	mov    0x803004,%eax
  80041c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800422:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800425:	39 c2                	cmp    %eax,%edx
  800427:	77 c8                	ja     8003f1 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80042c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80042f:	74 14                	je     800445 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800431:	83 ec 04             	sub    $0x4,%esp
  800434:	68 28 20 80 00       	push   $0x802028
  800439:	6a 44                	push   $0x44
  80043b:	68 c8 1f 80 00       	push   $0x801fc8
  800440:	e8 1a fe ff ff       	call   80025f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800445:	90                   	nop
  800446:	c9                   	leave  
  800447:	c3                   	ret    

00800448 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800448:	55                   	push   %ebp
  800449:	89 e5                	mov    %esp,%ebp
  80044b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80044e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800451:	8b 00                	mov    (%eax),%eax
  800453:	8d 48 01             	lea    0x1(%eax),%ecx
  800456:	8b 55 0c             	mov    0xc(%ebp),%edx
  800459:	89 0a                	mov    %ecx,(%edx)
  80045b:	8b 55 08             	mov    0x8(%ebp),%edx
  80045e:	88 d1                	mov    %dl,%cl
  800460:	8b 55 0c             	mov    0xc(%ebp),%edx
  800463:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800467:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046a:	8b 00                	mov    (%eax),%eax
  80046c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800471:	75 2c                	jne    80049f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800473:	a0 08 30 80 00       	mov    0x803008,%al
  800478:	0f b6 c0             	movzbl %al,%eax
  80047b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80047e:	8b 12                	mov    (%edx),%edx
  800480:	89 d1                	mov    %edx,%ecx
  800482:	8b 55 0c             	mov    0xc(%ebp),%edx
  800485:	83 c2 08             	add    $0x8,%edx
  800488:	83 ec 04             	sub    $0x4,%esp
  80048b:	50                   	push   %eax
  80048c:	51                   	push   %ecx
  80048d:	52                   	push   %edx
  80048e:	e8 78 0f 00 00       	call   80140b <sys_cputs>
  800493:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800496:	8b 45 0c             	mov    0xc(%ebp),%eax
  800499:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80049f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a2:	8b 40 04             	mov    0x4(%eax),%eax
  8004a5:	8d 50 01             	lea    0x1(%eax),%edx
  8004a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ab:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004ae:	90                   	nop
  8004af:	c9                   	leave  
  8004b0:	c3                   	ret    

008004b1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004b1:	55                   	push   %ebp
  8004b2:	89 e5                	mov    %esp,%ebp
  8004b4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004ba:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004c1:	00 00 00 
	b.cnt = 0;
  8004c4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004cb:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004ce:	ff 75 0c             	pushl  0xc(%ebp)
  8004d1:	ff 75 08             	pushl  0x8(%ebp)
  8004d4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004da:	50                   	push   %eax
  8004db:	68 48 04 80 00       	push   $0x800448
  8004e0:	e8 11 02 00 00       	call   8006f6 <vprintfmt>
  8004e5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004e8:	a0 08 30 80 00       	mov    0x803008,%al
  8004ed:	0f b6 c0             	movzbl %al,%eax
  8004f0:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004f6:	83 ec 04             	sub    $0x4,%esp
  8004f9:	50                   	push   %eax
  8004fa:	52                   	push   %edx
  8004fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800501:	83 c0 08             	add    $0x8,%eax
  800504:	50                   	push   %eax
  800505:	e8 01 0f 00 00       	call   80140b <sys_cputs>
  80050a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80050d:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800514:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80051a:	c9                   	leave  
  80051b:	c3                   	ret    

0080051c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80051c:	55                   	push   %ebp
  80051d:	89 e5                	mov    %esp,%ebp
  80051f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800522:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800529:	8d 45 0c             	lea    0xc(%ebp),%eax
  80052c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	83 ec 08             	sub    $0x8,%esp
  800535:	ff 75 f4             	pushl  -0xc(%ebp)
  800538:	50                   	push   %eax
  800539:	e8 73 ff ff ff       	call   8004b1 <vcprintf>
  80053e:	83 c4 10             	add    $0x10,%esp
  800541:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800544:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800547:	c9                   	leave  
  800548:	c3                   	ret    

00800549 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800549:	55                   	push   %ebp
  80054a:	89 e5                	mov    %esp,%ebp
  80054c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80054f:	e8 f9 0e 00 00       	call   80144d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800554:	8d 45 0c             	lea    0xc(%ebp),%eax
  800557:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80055a:	8b 45 08             	mov    0x8(%ebp),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	ff 75 f4             	pushl  -0xc(%ebp)
  800563:	50                   	push   %eax
  800564:	e8 48 ff ff ff       	call   8004b1 <vcprintf>
  800569:	83 c4 10             	add    $0x10,%esp
  80056c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80056f:	e8 f3 0e 00 00       	call   801467 <sys_unlock_cons>
	return cnt;
  800574:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800577:	c9                   	leave  
  800578:	c3                   	ret    

00800579 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800579:	55                   	push   %ebp
  80057a:	89 e5                	mov    %esp,%ebp
  80057c:	53                   	push   %ebx
  80057d:	83 ec 14             	sub    $0x14,%esp
  800580:	8b 45 10             	mov    0x10(%ebp),%eax
  800583:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800586:	8b 45 14             	mov    0x14(%ebp),%eax
  800589:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80058c:	8b 45 18             	mov    0x18(%ebp),%eax
  80058f:	ba 00 00 00 00       	mov    $0x0,%edx
  800594:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800597:	77 55                	ja     8005ee <printnum+0x75>
  800599:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80059c:	72 05                	jb     8005a3 <printnum+0x2a>
  80059e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005a1:	77 4b                	ja     8005ee <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005a3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005a6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005a9:	8b 45 18             	mov    0x18(%ebp),%eax
  8005ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b1:	52                   	push   %edx
  8005b2:	50                   	push   %eax
  8005b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8005b9:	e8 02 15 00 00       	call   801ac0 <__udivdi3>
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	83 ec 04             	sub    $0x4,%esp
  8005c4:	ff 75 20             	pushl  0x20(%ebp)
  8005c7:	53                   	push   %ebx
  8005c8:	ff 75 18             	pushl  0x18(%ebp)
  8005cb:	52                   	push   %edx
  8005cc:	50                   	push   %eax
  8005cd:	ff 75 0c             	pushl  0xc(%ebp)
  8005d0:	ff 75 08             	pushl  0x8(%ebp)
  8005d3:	e8 a1 ff ff ff       	call   800579 <printnum>
  8005d8:	83 c4 20             	add    $0x20,%esp
  8005db:	eb 1a                	jmp    8005f7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005dd:	83 ec 08             	sub    $0x8,%esp
  8005e0:	ff 75 0c             	pushl  0xc(%ebp)
  8005e3:	ff 75 20             	pushl  0x20(%ebp)
  8005e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e9:	ff d0                	call   *%eax
  8005eb:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005ee:	ff 4d 1c             	decl   0x1c(%ebp)
  8005f1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005f5:	7f e6                	jg     8005dd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005f7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800602:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800605:	53                   	push   %ebx
  800606:	51                   	push   %ecx
  800607:	52                   	push   %edx
  800608:	50                   	push   %eax
  800609:	e8 c2 15 00 00       	call   801bd0 <__umoddi3>
  80060e:	83 c4 10             	add    $0x10,%esp
  800611:	05 94 22 80 00       	add    $0x802294,%eax
  800616:	8a 00                	mov    (%eax),%al
  800618:	0f be c0             	movsbl %al,%eax
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	ff 75 0c             	pushl  0xc(%ebp)
  800621:	50                   	push   %eax
  800622:	8b 45 08             	mov    0x8(%ebp),%eax
  800625:	ff d0                	call   *%eax
  800627:	83 c4 10             	add    $0x10,%esp
}
  80062a:	90                   	nop
  80062b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80062e:	c9                   	leave  
  80062f:	c3                   	ret    

00800630 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800630:	55                   	push   %ebp
  800631:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800633:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800637:	7e 1c                	jle    800655 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	8d 50 08             	lea    0x8(%eax),%edx
  800641:	8b 45 08             	mov    0x8(%ebp),%eax
  800644:	89 10                	mov    %edx,(%eax)
  800646:	8b 45 08             	mov    0x8(%ebp),%eax
  800649:	8b 00                	mov    (%eax),%eax
  80064b:	83 e8 08             	sub    $0x8,%eax
  80064e:	8b 50 04             	mov    0x4(%eax),%edx
  800651:	8b 00                	mov    (%eax),%eax
  800653:	eb 40                	jmp    800695 <getuint+0x65>
	else if (lflag)
  800655:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800659:	74 1e                	je     800679 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	8d 50 04             	lea    0x4(%eax),%edx
  800663:	8b 45 08             	mov    0x8(%ebp),%eax
  800666:	89 10                	mov    %edx,(%eax)
  800668:	8b 45 08             	mov    0x8(%ebp),%eax
  80066b:	8b 00                	mov    (%eax),%eax
  80066d:	83 e8 04             	sub    $0x4,%eax
  800670:	8b 00                	mov    (%eax),%eax
  800672:	ba 00 00 00 00       	mov    $0x0,%edx
  800677:	eb 1c                	jmp    800695 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	8d 50 04             	lea    0x4(%eax),%edx
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	89 10                	mov    %edx,(%eax)
  800686:	8b 45 08             	mov    0x8(%ebp),%eax
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	83 e8 04             	sub    $0x4,%eax
  80068e:	8b 00                	mov    (%eax),%eax
  800690:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800695:	5d                   	pop    %ebp
  800696:	c3                   	ret    

00800697 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800697:	55                   	push   %ebp
  800698:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80069a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80069e:	7e 1c                	jle    8006bc <getint+0x25>
		return va_arg(*ap, long long);
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	8d 50 08             	lea    0x8(%eax),%edx
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	89 10                	mov    %edx,(%eax)
  8006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b0:	8b 00                	mov    (%eax),%eax
  8006b2:	83 e8 08             	sub    $0x8,%eax
  8006b5:	8b 50 04             	mov    0x4(%eax),%edx
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	eb 38                	jmp    8006f4 <getint+0x5d>
	else if (lflag)
  8006bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c0:	74 1a                	je     8006dc <getint+0x45>
		return va_arg(*ap, long);
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	8d 50 04             	lea    0x4(%eax),%edx
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	89 10                	mov    %edx,(%eax)
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	83 e8 04             	sub    $0x4,%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	99                   	cltd   
  8006da:	eb 18                	jmp    8006f4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	8d 50 04             	lea    0x4(%eax),%edx
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	89 10                	mov    %edx,(%eax)
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	99                   	cltd   
}
  8006f4:	5d                   	pop    %ebp
  8006f5:	c3                   	ret    

008006f6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006f6:	55                   	push   %ebp
  8006f7:	89 e5                	mov    %esp,%ebp
  8006f9:	56                   	push   %esi
  8006fa:	53                   	push   %ebx
  8006fb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006fe:	eb 17                	jmp    800717 <vprintfmt+0x21>
			if (ch == '\0')
  800700:	85 db                	test   %ebx,%ebx
  800702:	0f 84 c1 03 00 00    	je     800ac9 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800708:	83 ec 08             	sub    $0x8,%esp
  80070b:	ff 75 0c             	pushl  0xc(%ebp)
  80070e:	53                   	push   %ebx
  80070f:	8b 45 08             	mov    0x8(%ebp),%eax
  800712:	ff d0                	call   *%eax
  800714:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800717:	8b 45 10             	mov    0x10(%ebp),%eax
  80071a:	8d 50 01             	lea    0x1(%eax),%edx
  80071d:	89 55 10             	mov    %edx,0x10(%ebp)
  800720:	8a 00                	mov    (%eax),%al
  800722:	0f b6 d8             	movzbl %al,%ebx
  800725:	83 fb 25             	cmp    $0x25,%ebx
  800728:	75 d6                	jne    800700 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80072a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80072e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800735:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80073c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800743:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80074a:	8b 45 10             	mov    0x10(%ebp),%eax
  80074d:	8d 50 01             	lea    0x1(%eax),%edx
  800750:	89 55 10             	mov    %edx,0x10(%ebp)
  800753:	8a 00                	mov    (%eax),%al
  800755:	0f b6 d8             	movzbl %al,%ebx
  800758:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80075b:	83 f8 5b             	cmp    $0x5b,%eax
  80075e:	0f 87 3d 03 00 00    	ja     800aa1 <vprintfmt+0x3ab>
  800764:	8b 04 85 b8 22 80 00 	mov    0x8022b8(,%eax,4),%eax
  80076b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80076d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800771:	eb d7                	jmp    80074a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800773:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800777:	eb d1                	jmp    80074a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800779:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800780:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800783:	89 d0                	mov    %edx,%eax
  800785:	c1 e0 02             	shl    $0x2,%eax
  800788:	01 d0                	add    %edx,%eax
  80078a:	01 c0                	add    %eax,%eax
  80078c:	01 d8                	add    %ebx,%eax
  80078e:	83 e8 30             	sub    $0x30,%eax
  800791:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800794:	8b 45 10             	mov    0x10(%ebp),%eax
  800797:	8a 00                	mov    (%eax),%al
  800799:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80079c:	83 fb 2f             	cmp    $0x2f,%ebx
  80079f:	7e 3e                	jle    8007df <vprintfmt+0xe9>
  8007a1:	83 fb 39             	cmp    $0x39,%ebx
  8007a4:	7f 39                	jg     8007df <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007a9:	eb d5                	jmp    800780 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ae:	83 c0 04             	add    $0x4,%eax
  8007b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	83 e8 04             	sub    $0x4,%eax
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007bf:	eb 1f                	jmp    8007e0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007c5:	79 83                	jns    80074a <vprintfmt+0x54>
				width = 0;
  8007c7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007ce:	e9 77 ff ff ff       	jmp    80074a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007d3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007da:	e9 6b ff ff ff       	jmp    80074a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007df:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e4:	0f 89 60 ff ff ff    	jns    80074a <vprintfmt+0x54>
				width = precision, precision = -1;
  8007ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007f7:	e9 4e ff ff ff       	jmp    80074a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007fc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007ff:	e9 46 ff ff ff       	jmp    80074a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800804:	8b 45 14             	mov    0x14(%ebp),%eax
  800807:	83 c0 04             	add    $0x4,%eax
  80080a:	89 45 14             	mov    %eax,0x14(%ebp)
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	83 e8 04             	sub    $0x4,%eax
  800813:	8b 00                	mov    (%eax),%eax
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	ff 75 0c             	pushl  0xc(%ebp)
  80081b:	50                   	push   %eax
  80081c:	8b 45 08             	mov    0x8(%ebp),%eax
  80081f:	ff d0                	call   *%eax
  800821:	83 c4 10             	add    $0x10,%esp
			break;
  800824:	e9 9b 02 00 00       	jmp    800ac4 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800829:	8b 45 14             	mov    0x14(%ebp),%eax
  80082c:	83 c0 04             	add    $0x4,%eax
  80082f:	89 45 14             	mov    %eax,0x14(%ebp)
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	83 e8 04             	sub    $0x4,%eax
  800838:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80083a:	85 db                	test   %ebx,%ebx
  80083c:	79 02                	jns    800840 <vprintfmt+0x14a>
				err = -err;
  80083e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800840:	83 fb 64             	cmp    $0x64,%ebx
  800843:	7f 0b                	jg     800850 <vprintfmt+0x15a>
  800845:	8b 34 9d 00 21 80 00 	mov    0x802100(,%ebx,4),%esi
  80084c:	85 f6                	test   %esi,%esi
  80084e:	75 19                	jne    800869 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800850:	53                   	push   %ebx
  800851:	68 a5 22 80 00       	push   $0x8022a5
  800856:	ff 75 0c             	pushl  0xc(%ebp)
  800859:	ff 75 08             	pushl  0x8(%ebp)
  80085c:	e8 70 02 00 00       	call   800ad1 <printfmt>
  800861:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800864:	e9 5b 02 00 00       	jmp    800ac4 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800869:	56                   	push   %esi
  80086a:	68 ae 22 80 00       	push   $0x8022ae
  80086f:	ff 75 0c             	pushl  0xc(%ebp)
  800872:	ff 75 08             	pushl  0x8(%ebp)
  800875:	e8 57 02 00 00       	call   800ad1 <printfmt>
  80087a:	83 c4 10             	add    $0x10,%esp
			break;
  80087d:	e9 42 02 00 00       	jmp    800ac4 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800882:	8b 45 14             	mov    0x14(%ebp),%eax
  800885:	83 c0 04             	add    $0x4,%eax
  800888:	89 45 14             	mov    %eax,0x14(%ebp)
  80088b:	8b 45 14             	mov    0x14(%ebp),%eax
  80088e:	83 e8 04             	sub    $0x4,%eax
  800891:	8b 30                	mov    (%eax),%esi
  800893:	85 f6                	test   %esi,%esi
  800895:	75 05                	jne    80089c <vprintfmt+0x1a6>
				p = "(null)";
  800897:	be b1 22 80 00       	mov    $0x8022b1,%esi
			if (width > 0 && padc != '-')
  80089c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a0:	7e 6d                	jle    80090f <vprintfmt+0x219>
  8008a2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008a6:	74 67                	je     80090f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ab:	83 ec 08             	sub    $0x8,%esp
  8008ae:	50                   	push   %eax
  8008af:	56                   	push   %esi
  8008b0:	e8 1e 03 00 00       	call   800bd3 <strnlen>
  8008b5:	83 c4 10             	add    $0x10,%esp
  8008b8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008bb:	eb 16                	jmp    8008d3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008bd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008c1:	83 ec 08             	sub    $0x8,%esp
  8008c4:	ff 75 0c             	pushl  0xc(%ebp)
  8008c7:	50                   	push   %eax
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	ff d0                	call   *%eax
  8008cd:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d0:	ff 4d e4             	decl   -0x1c(%ebp)
  8008d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008d7:	7f e4                	jg     8008bd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008d9:	eb 34                	jmp    80090f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008db:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008df:	74 1c                	je     8008fd <vprintfmt+0x207>
  8008e1:	83 fb 1f             	cmp    $0x1f,%ebx
  8008e4:	7e 05                	jle    8008eb <vprintfmt+0x1f5>
  8008e6:	83 fb 7e             	cmp    $0x7e,%ebx
  8008e9:	7e 12                	jle    8008fd <vprintfmt+0x207>
					putch('?', putdat);
  8008eb:	83 ec 08             	sub    $0x8,%esp
  8008ee:	ff 75 0c             	pushl  0xc(%ebp)
  8008f1:	6a 3f                	push   $0x3f
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	ff d0                	call   *%eax
  8008f8:	83 c4 10             	add    $0x10,%esp
  8008fb:	eb 0f                	jmp    80090c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008fd:	83 ec 08             	sub    $0x8,%esp
  800900:	ff 75 0c             	pushl  0xc(%ebp)
  800903:	53                   	push   %ebx
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	ff d0                	call   *%eax
  800909:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80090c:	ff 4d e4             	decl   -0x1c(%ebp)
  80090f:	89 f0                	mov    %esi,%eax
  800911:	8d 70 01             	lea    0x1(%eax),%esi
  800914:	8a 00                	mov    (%eax),%al
  800916:	0f be d8             	movsbl %al,%ebx
  800919:	85 db                	test   %ebx,%ebx
  80091b:	74 24                	je     800941 <vprintfmt+0x24b>
  80091d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800921:	78 b8                	js     8008db <vprintfmt+0x1e5>
  800923:	ff 4d e0             	decl   -0x20(%ebp)
  800926:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80092a:	79 af                	jns    8008db <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80092c:	eb 13                	jmp    800941 <vprintfmt+0x24b>
				putch(' ', putdat);
  80092e:	83 ec 08             	sub    $0x8,%esp
  800931:	ff 75 0c             	pushl  0xc(%ebp)
  800934:	6a 20                	push   $0x20
  800936:	8b 45 08             	mov    0x8(%ebp),%eax
  800939:	ff d0                	call   *%eax
  80093b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80093e:	ff 4d e4             	decl   -0x1c(%ebp)
  800941:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800945:	7f e7                	jg     80092e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800947:	e9 78 01 00 00       	jmp    800ac4 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	ff 75 e8             	pushl  -0x18(%ebp)
  800952:	8d 45 14             	lea    0x14(%ebp),%eax
  800955:	50                   	push   %eax
  800956:	e8 3c fd ff ff       	call   800697 <getint>
  80095b:	83 c4 10             	add    $0x10,%esp
  80095e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800961:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800964:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800967:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80096a:	85 d2                	test   %edx,%edx
  80096c:	79 23                	jns    800991 <vprintfmt+0x29b>
				putch('-', putdat);
  80096e:	83 ec 08             	sub    $0x8,%esp
  800971:	ff 75 0c             	pushl  0xc(%ebp)
  800974:	6a 2d                	push   $0x2d
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	ff d0                	call   *%eax
  80097b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80097e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800981:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800984:	f7 d8                	neg    %eax
  800986:	83 d2 00             	adc    $0x0,%edx
  800989:	f7 da                	neg    %edx
  80098b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80098e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800991:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800998:	e9 bc 00 00 00       	jmp    800a59 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80099d:	83 ec 08             	sub    $0x8,%esp
  8009a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a6:	50                   	push   %eax
  8009a7:	e8 84 fc ff ff       	call   800630 <getuint>
  8009ac:	83 c4 10             	add    $0x10,%esp
  8009af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009b5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009bc:	e9 98 00 00 00       	jmp    800a59 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009c1:	83 ec 08             	sub    $0x8,%esp
  8009c4:	ff 75 0c             	pushl  0xc(%ebp)
  8009c7:	6a 58                	push   $0x58
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	ff d0                	call   *%eax
  8009ce:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009d1:	83 ec 08             	sub    $0x8,%esp
  8009d4:	ff 75 0c             	pushl  0xc(%ebp)
  8009d7:	6a 58                	push   $0x58
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	ff d0                	call   *%eax
  8009de:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e1:	83 ec 08             	sub    $0x8,%esp
  8009e4:	ff 75 0c             	pushl  0xc(%ebp)
  8009e7:	6a 58                	push   $0x58
  8009e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ec:	ff d0                	call   *%eax
  8009ee:	83 c4 10             	add    $0x10,%esp
			break;
  8009f1:	e9 ce 00 00 00       	jmp    800ac4 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8009f6:	83 ec 08             	sub    $0x8,%esp
  8009f9:	ff 75 0c             	pushl  0xc(%ebp)
  8009fc:	6a 30                	push   $0x30
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	ff d0                	call   *%eax
  800a03:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	ff 75 0c             	pushl  0xc(%ebp)
  800a0c:	6a 78                	push   $0x78
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	ff d0                	call   *%eax
  800a13:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a16:	8b 45 14             	mov    0x14(%ebp),%eax
  800a19:	83 c0 04             	add    $0x4,%eax
  800a1c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a22:	83 e8 04             	sub    $0x4,%eax
  800a25:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a31:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a38:	eb 1f                	jmp    800a59 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a3a:	83 ec 08             	sub    $0x8,%esp
  800a3d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a40:	8d 45 14             	lea    0x14(%ebp),%eax
  800a43:	50                   	push   %eax
  800a44:	e8 e7 fb ff ff       	call   800630 <getuint>
  800a49:	83 c4 10             	add    $0x10,%esp
  800a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a52:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a59:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a60:	83 ec 04             	sub    $0x4,%esp
  800a63:	52                   	push   %edx
  800a64:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a67:	50                   	push   %eax
  800a68:	ff 75 f4             	pushl  -0xc(%ebp)
  800a6b:	ff 75 f0             	pushl  -0x10(%ebp)
  800a6e:	ff 75 0c             	pushl  0xc(%ebp)
  800a71:	ff 75 08             	pushl  0x8(%ebp)
  800a74:	e8 00 fb ff ff       	call   800579 <printnum>
  800a79:	83 c4 20             	add    $0x20,%esp
			break;
  800a7c:	eb 46                	jmp    800ac4 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a7e:	83 ec 08             	sub    $0x8,%esp
  800a81:	ff 75 0c             	pushl  0xc(%ebp)
  800a84:	53                   	push   %ebx
  800a85:	8b 45 08             	mov    0x8(%ebp),%eax
  800a88:	ff d0                	call   *%eax
  800a8a:	83 c4 10             	add    $0x10,%esp
			break;
  800a8d:	eb 35                	jmp    800ac4 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a8f:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800a96:	eb 2c                	jmp    800ac4 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a98:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800a9f:	eb 23                	jmp    800ac4 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aa1:	83 ec 08             	sub    $0x8,%esp
  800aa4:	ff 75 0c             	pushl  0xc(%ebp)
  800aa7:	6a 25                	push   $0x25
  800aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aac:	ff d0                	call   *%eax
  800aae:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab1:	ff 4d 10             	decl   0x10(%ebp)
  800ab4:	eb 03                	jmp    800ab9 <vprintfmt+0x3c3>
  800ab6:	ff 4d 10             	decl   0x10(%ebp)
  800ab9:	8b 45 10             	mov    0x10(%ebp),%eax
  800abc:	48                   	dec    %eax
  800abd:	8a 00                	mov    (%eax),%al
  800abf:	3c 25                	cmp    $0x25,%al
  800ac1:	75 f3                	jne    800ab6 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ac3:	90                   	nop
		}
	}
  800ac4:	e9 35 fc ff ff       	jmp    8006fe <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ac9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800aca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800acd:	5b                   	pop    %ebx
  800ace:	5e                   	pop    %esi
  800acf:	5d                   	pop    %ebp
  800ad0:	c3                   	ret    

00800ad1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ad7:	8d 45 10             	lea    0x10(%ebp),%eax
  800ada:	83 c0 04             	add    $0x4,%eax
  800add:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ae0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae3:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae6:	50                   	push   %eax
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	ff 75 08             	pushl  0x8(%ebp)
  800aed:	e8 04 fc ff ff       	call   8006f6 <vprintfmt>
  800af2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800af5:	90                   	nop
  800af6:	c9                   	leave  
  800af7:	c3                   	ret    

00800af8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afe:	8b 40 08             	mov    0x8(%eax),%eax
  800b01:	8d 50 01             	lea    0x1(%eax),%edx
  800b04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b07:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0d:	8b 10                	mov    (%eax),%edx
  800b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b12:	8b 40 04             	mov    0x4(%eax),%eax
  800b15:	39 c2                	cmp    %eax,%edx
  800b17:	73 12                	jae    800b2b <sprintputch+0x33>
		*b->buf++ = ch;
  800b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1c:	8b 00                	mov    (%eax),%eax
  800b1e:	8d 48 01             	lea    0x1(%eax),%ecx
  800b21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b24:	89 0a                	mov    %ecx,(%edx)
  800b26:	8b 55 08             	mov    0x8(%ebp),%edx
  800b29:	88 10                	mov    %dl,(%eax)
}
  800b2b:	90                   	nop
  800b2c:	5d                   	pop    %ebp
  800b2d:	c3                   	ret    

00800b2e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b2e:	55                   	push   %ebp
  800b2f:	89 e5                	mov    %esp,%ebp
  800b31:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	01 d0                	add    %edx,%eax
  800b45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b53:	74 06                	je     800b5b <vsnprintf+0x2d>
  800b55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b59:	7f 07                	jg     800b62 <vsnprintf+0x34>
		return -E_INVAL;
  800b5b:	b8 03 00 00 00       	mov    $0x3,%eax
  800b60:	eb 20                	jmp    800b82 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b62:	ff 75 14             	pushl  0x14(%ebp)
  800b65:	ff 75 10             	pushl  0x10(%ebp)
  800b68:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b6b:	50                   	push   %eax
  800b6c:	68 f8 0a 80 00       	push   $0x800af8
  800b71:	e8 80 fb ff ff       	call   8006f6 <vprintfmt>
  800b76:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b7c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b82:	c9                   	leave  
  800b83:	c3                   	ret    

00800b84 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b8a:	8d 45 10             	lea    0x10(%ebp),%eax
  800b8d:	83 c0 04             	add    $0x4,%eax
  800b90:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b93:	8b 45 10             	mov    0x10(%ebp),%eax
  800b96:	ff 75 f4             	pushl  -0xc(%ebp)
  800b99:	50                   	push   %eax
  800b9a:	ff 75 0c             	pushl  0xc(%ebp)
  800b9d:	ff 75 08             	pushl  0x8(%ebp)
  800ba0:	e8 89 ff ff ff       	call   800b2e <vsnprintf>
  800ba5:	83 c4 10             	add    $0x10,%esp
  800ba8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bae:	c9                   	leave  
  800baf:	c3                   	ret    

00800bb0 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bbd:	eb 06                	jmp    800bc5 <strlen+0x15>
		n++;
  800bbf:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc2:	ff 45 08             	incl   0x8(%ebp)
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	8a 00                	mov    (%eax),%al
  800bca:	84 c0                	test   %al,%al
  800bcc:	75 f1                	jne    800bbf <strlen+0xf>
		n++;
	return n;
  800bce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd1:	c9                   	leave  
  800bd2:	c3                   	ret    

00800bd3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be0:	eb 09                	jmp    800beb <strnlen+0x18>
		n++;
  800be2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be5:	ff 45 08             	incl   0x8(%ebp)
  800be8:	ff 4d 0c             	decl   0xc(%ebp)
  800beb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bef:	74 09                	je     800bfa <strnlen+0x27>
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	8a 00                	mov    (%eax),%al
  800bf6:	84 c0                	test   %al,%al
  800bf8:	75 e8                	jne    800be2 <strnlen+0xf>
		n++;
	return n;
  800bfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bfd:	c9                   	leave  
  800bfe:	c3                   	ret    

00800bff <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
  800c02:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c0b:	90                   	nop
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	8d 50 01             	lea    0x1(%eax),%edx
  800c12:	89 55 08             	mov    %edx,0x8(%ebp)
  800c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c18:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c1b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c1e:	8a 12                	mov    (%edx),%dl
  800c20:	88 10                	mov    %dl,(%eax)
  800c22:	8a 00                	mov    (%eax),%al
  800c24:	84 c0                	test   %al,%al
  800c26:	75 e4                	jne    800c0c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c28:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c2b:	c9                   	leave  
  800c2c:	c3                   	ret    

00800c2d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
  800c30:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c40:	eb 1f                	jmp    800c61 <strncpy+0x34>
		*dst++ = *src;
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	8d 50 01             	lea    0x1(%eax),%edx
  800c48:	89 55 08             	mov    %edx,0x8(%ebp)
  800c4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4e:	8a 12                	mov    (%edx),%dl
  800c50:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c55:	8a 00                	mov    (%eax),%al
  800c57:	84 c0                	test   %al,%al
  800c59:	74 03                	je     800c5e <strncpy+0x31>
			src++;
  800c5b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c5e:	ff 45 fc             	incl   -0x4(%ebp)
  800c61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c64:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c67:	72 d9                	jb     800c42 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c69:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c7e:	74 30                	je     800cb0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c80:	eb 16                	jmp    800c98 <strlcpy+0x2a>
			*dst++ = *src++;
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	8d 50 01             	lea    0x1(%eax),%edx
  800c88:	89 55 08             	mov    %edx,0x8(%ebp)
  800c8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c91:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c94:	8a 12                	mov    (%edx),%dl
  800c96:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c98:	ff 4d 10             	decl   0x10(%ebp)
  800c9b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c9f:	74 09                	je     800caa <strlcpy+0x3c>
  800ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca4:	8a 00                	mov    (%eax),%al
  800ca6:	84 c0                	test   %al,%al
  800ca8:	75 d8                	jne    800c82 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800caa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cad:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb6:	29 c2                	sub    %eax,%edx
  800cb8:	89 d0                	mov    %edx,%eax
}
  800cba:	c9                   	leave  
  800cbb:	c3                   	ret    

00800cbc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cbf:	eb 06                	jmp    800cc7 <strcmp+0xb>
		p++, q++;
  800cc1:	ff 45 08             	incl   0x8(%ebp)
  800cc4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	84 c0                	test   %al,%al
  800cce:	74 0e                	je     800cde <strcmp+0x22>
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	8a 10                	mov    (%eax),%dl
  800cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd8:	8a 00                	mov    (%eax),%al
  800cda:	38 c2                	cmp    %al,%dl
  800cdc:	74 e3                	je     800cc1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	8a 00                	mov    (%eax),%al
  800ce3:	0f b6 d0             	movzbl %al,%edx
  800ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce9:	8a 00                	mov    (%eax),%al
  800ceb:	0f b6 c0             	movzbl %al,%eax
  800cee:	29 c2                	sub    %eax,%edx
  800cf0:	89 d0                	mov    %edx,%eax
}
  800cf2:	5d                   	pop    %ebp
  800cf3:	c3                   	ret    

00800cf4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cf7:	eb 09                	jmp    800d02 <strncmp+0xe>
		n--, p++, q++;
  800cf9:	ff 4d 10             	decl   0x10(%ebp)
  800cfc:	ff 45 08             	incl   0x8(%ebp)
  800cff:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d02:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d06:	74 17                	je     800d1f <strncmp+0x2b>
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8a 00                	mov    (%eax),%al
  800d0d:	84 c0                	test   %al,%al
  800d0f:	74 0e                	je     800d1f <strncmp+0x2b>
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8a 10                	mov    (%eax),%dl
  800d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	38 c2                	cmp    %al,%dl
  800d1d:	74 da                	je     800cf9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d23:	75 07                	jne    800d2c <strncmp+0x38>
		return 0;
  800d25:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2a:	eb 14                	jmp    800d40 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	0f b6 d0             	movzbl %al,%edx
  800d34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	0f b6 c0             	movzbl %al,%eax
  800d3c:	29 c2                	sub    %eax,%edx
  800d3e:	89 d0                	mov    %edx,%eax
}
  800d40:	5d                   	pop    %ebp
  800d41:	c3                   	ret    

00800d42 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
  800d45:	83 ec 04             	sub    $0x4,%esp
  800d48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d4e:	eb 12                	jmp    800d62 <strchr+0x20>
		if (*s == c)
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	8a 00                	mov    (%eax),%al
  800d55:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d58:	75 05                	jne    800d5f <strchr+0x1d>
			return (char *) s;
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	eb 11                	jmp    800d70 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d5f:	ff 45 08             	incl   0x8(%ebp)
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	84 c0                	test   %al,%al
  800d69:	75 e5                	jne    800d50 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d70:	c9                   	leave  
  800d71:	c3                   	ret    

00800d72 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
  800d75:	83 ec 04             	sub    $0x4,%esp
  800d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d7e:	eb 0d                	jmp    800d8d <strfind+0x1b>
		if (*s == c)
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d88:	74 0e                	je     800d98 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d8a:	ff 45 08             	incl   0x8(%ebp)
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	8a 00                	mov    (%eax),%al
  800d92:	84 c0                	test   %al,%al
  800d94:	75 ea                	jne    800d80 <strfind+0xe>
  800d96:	eb 01                	jmp    800d99 <strfind+0x27>
		if (*s == c)
			break;
  800d98:	90                   	nop
	return (char *) s;
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d9c:	c9                   	leave  
  800d9d:	c3                   	ret    

00800d9e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d9e:	55                   	push   %ebp
  800d9f:	89 e5                	mov    %esp,%ebp
  800da1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800daa:	8b 45 10             	mov    0x10(%ebp),%eax
  800dad:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800db0:	eb 0e                	jmp    800dc0 <memset+0x22>
		*p++ = c;
  800db2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db5:	8d 50 01             	lea    0x1(%eax),%edx
  800db8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dbe:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dc0:	ff 4d f8             	decl   -0x8(%ebp)
  800dc3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dc7:	79 e9                	jns    800db2 <memset+0x14>
		*p++ = c;

	return v;
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dcc:	c9                   	leave  
  800dcd:	c3                   	ret    

00800dce <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dce:	55                   	push   %ebp
  800dcf:	89 e5                	mov    %esp,%ebp
  800dd1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800de0:	eb 16                	jmp    800df8 <memcpy+0x2a>
		*d++ = *s++;
  800de2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de5:	8d 50 01             	lea    0x1(%eax),%edx
  800de8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800deb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dee:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800df4:	8a 12                	mov    (%edx),%dl
  800df6:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800df8:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dfe:	89 55 10             	mov    %edx,0x10(%ebp)
  800e01:	85 c0                	test   %eax,%eax
  800e03:	75 dd                	jne    800de2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e08:	c9                   	leave  
  800e09:	c3                   	ret    

00800e0a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e22:	73 50                	jae    800e74 <memmove+0x6a>
  800e24:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e27:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2a:	01 d0                	add    %edx,%eax
  800e2c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e2f:	76 43                	jbe    800e74 <memmove+0x6a>
		s += n;
  800e31:	8b 45 10             	mov    0x10(%ebp),%eax
  800e34:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e37:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e3d:	eb 10                	jmp    800e4f <memmove+0x45>
			*--d = *--s;
  800e3f:	ff 4d f8             	decl   -0x8(%ebp)
  800e42:	ff 4d fc             	decl   -0x4(%ebp)
  800e45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e48:	8a 10                	mov    (%eax),%dl
  800e4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e52:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e55:	89 55 10             	mov    %edx,0x10(%ebp)
  800e58:	85 c0                	test   %eax,%eax
  800e5a:	75 e3                	jne    800e3f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e5c:	eb 23                	jmp    800e81 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e61:	8d 50 01             	lea    0x1(%eax),%edx
  800e64:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e67:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e6a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e6d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e70:	8a 12                	mov    (%edx),%dl
  800e72:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e74:	8b 45 10             	mov    0x10(%ebp),%eax
  800e77:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e7a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e7d:	85 c0                	test   %eax,%eax
  800e7f:	75 dd                	jne    800e5e <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e84:	c9                   	leave  
  800e85:	c3                   	ret    

00800e86 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e95:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e98:	eb 2a                	jmp    800ec4 <memcmp+0x3e>
		if (*s1 != *s2)
  800e9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9d:	8a 10                	mov    (%eax),%dl
  800e9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea2:	8a 00                	mov    (%eax),%al
  800ea4:	38 c2                	cmp    %al,%dl
  800ea6:	74 16                	je     800ebe <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ea8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eab:	8a 00                	mov    (%eax),%al
  800ead:	0f b6 d0             	movzbl %al,%edx
  800eb0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	0f b6 c0             	movzbl %al,%eax
  800eb8:	29 c2                	sub    %eax,%edx
  800eba:	89 d0                	mov    %edx,%eax
  800ebc:	eb 18                	jmp    800ed6 <memcmp+0x50>
		s1++, s2++;
  800ebe:	ff 45 fc             	incl   -0x4(%ebp)
  800ec1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ec4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eca:	89 55 10             	mov    %edx,0x10(%ebp)
  800ecd:	85 c0                	test   %eax,%eax
  800ecf:	75 c9                	jne    800e9a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ed1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ed6:	c9                   	leave  
  800ed7:	c3                   	ret    

00800ed8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ed8:	55                   	push   %ebp
  800ed9:	89 e5                	mov    %esp,%ebp
  800edb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ede:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee4:	01 d0                	add    %edx,%eax
  800ee6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ee9:	eb 15                	jmp    800f00 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	8a 00                	mov    (%eax),%al
  800ef0:	0f b6 d0             	movzbl %al,%edx
  800ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef6:	0f b6 c0             	movzbl %al,%eax
  800ef9:	39 c2                	cmp    %eax,%edx
  800efb:	74 0d                	je     800f0a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800efd:	ff 45 08             	incl   0x8(%ebp)
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f06:	72 e3                	jb     800eeb <memfind+0x13>
  800f08:	eb 01                	jmp    800f0b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f0a:	90                   	nop
	return (void *) s;
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0e:	c9                   	leave  
  800f0f:	c3                   	ret    

00800f10 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f1d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f24:	eb 03                	jmp    800f29 <strtol+0x19>
		s++;
  800f26:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	3c 20                	cmp    $0x20,%al
  800f30:	74 f4                	je     800f26 <strtol+0x16>
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	3c 09                	cmp    $0x9,%al
  800f39:	74 eb                	je     800f26 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	8a 00                	mov    (%eax),%al
  800f40:	3c 2b                	cmp    $0x2b,%al
  800f42:	75 05                	jne    800f49 <strtol+0x39>
		s++;
  800f44:	ff 45 08             	incl   0x8(%ebp)
  800f47:	eb 13                	jmp    800f5c <strtol+0x4c>
	else if (*s == '-')
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	3c 2d                	cmp    $0x2d,%al
  800f50:	75 0a                	jne    800f5c <strtol+0x4c>
		s++, neg = 1;
  800f52:	ff 45 08             	incl   0x8(%ebp)
  800f55:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f5c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f60:	74 06                	je     800f68 <strtol+0x58>
  800f62:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f66:	75 20                	jne    800f88 <strtol+0x78>
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	8a 00                	mov    (%eax),%al
  800f6d:	3c 30                	cmp    $0x30,%al
  800f6f:	75 17                	jne    800f88 <strtol+0x78>
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	40                   	inc    %eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	3c 78                	cmp    $0x78,%al
  800f79:	75 0d                	jne    800f88 <strtol+0x78>
		s += 2, base = 16;
  800f7b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f7f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f86:	eb 28                	jmp    800fb0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f88:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f8c:	75 15                	jne    800fa3 <strtol+0x93>
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	8a 00                	mov    (%eax),%al
  800f93:	3c 30                	cmp    $0x30,%al
  800f95:	75 0c                	jne    800fa3 <strtol+0x93>
		s++, base = 8;
  800f97:	ff 45 08             	incl   0x8(%ebp)
  800f9a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fa1:	eb 0d                	jmp    800fb0 <strtol+0xa0>
	else if (base == 0)
  800fa3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa7:	75 07                	jne    800fb0 <strtol+0xa0>
		base = 10;
  800fa9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	8a 00                	mov    (%eax),%al
  800fb5:	3c 2f                	cmp    $0x2f,%al
  800fb7:	7e 19                	jle    800fd2 <strtol+0xc2>
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	8a 00                	mov    (%eax),%al
  800fbe:	3c 39                	cmp    $0x39,%al
  800fc0:	7f 10                	jg     800fd2 <strtol+0xc2>
			dig = *s - '0';
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	8a 00                	mov    (%eax),%al
  800fc7:	0f be c0             	movsbl %al,%eax
  800fca:	83 e8 30             	sub    $0x30,%eax
  800fcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd0:	eb 42                	jmp    801014 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	3c 60                	cmp    $0x60,%al
  800fd9:	7e 19                	jle    800ff4 <strtol+0xe4>
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	3c 7a                	cmp    $0x7a,%al
  800fe2:	7f 10                	jg     800ff4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	0f be c0             	movsbl %al,%eax
  800fec:	83 e8 57             	sub    $0x57,%eax
  800fef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ff2:	eb 20                	jmp    801014 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	3c 40                	cmp    $0x40,%al
  800ffb:	7e 39                	jle    801036 <strtol+0x126>
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	3c 5a                	cmp    $0x5a,%al
  801004:	7f 30                	jg     801036 <strtol+0x126>
			dig = *s - 'A' + 10;
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	8a 00                	mov    (%eax),%al
  80100b:	0f be c0             	movsbl %al,%eax
  80100e:	83 e8 37             	sub    $0x37,%eax
  801011:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801017:	3b 45 10             	cmp    0x10(%ebp),%eax
  80101a:	7d 19                	jge    801035 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80101c:	ff 45 08             	incl   0x8(%ebp)
  80101f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801022:	0f af 45 10          	imul   0x10(%ebp),%eax
  801026:	89 c2                	mov    %eax,%edx
  801028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102b:	01 d0                	add    %edx,%eax
  80102d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801030:	e9 7b ff ff ff       	jmp    800fb0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801035:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801036:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80103a:	74 08                	je     801044 <strtol+0x134>
		*endptr = (char *) s;
  80103c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103f:	8b 55 08             	mov    0x8(%ebp),%edx
  801042:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801044:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801048:	74 07                	je     801051 <strtol+0x141>
  80104a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104d:	f7 d8                	neg    %eax
  80104f:	eb 03                	jmp    801054 <strtol+0x144>
  801051:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801054:	c9                   	leave  
  801055:	c3                   	ret    

00801056 <ltostr>:

void
ltostr(long value, char *str)
{
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80105c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801063:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80106a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80106e:	79 13                	jns    801083 <ltostr+0x2d>
	{
		neg = 1;
  801070:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801077:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80107d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801080:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80108b:	99                   	cltd   
  80108c:	f7 f9                	idiv   %ecx
  80108e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801091:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801094:	8d 50 01             	lea    0x1(%eax),%edx
  801097:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80109a:	89 c2                	mov    %eax,%edx
  80109c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109f:	01 d0                	add    %edx,%eax
  8010a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010a4:	83 c2 30             	add    $0x30,%edx
  8010a7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ac:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010b1:	f7 e9                	imul   %ecx
  8010b3:	c1 fa 02             	sar    $0x2,%edx
  8010b6:	89 c8                	mov    %ecx,%eax
  8010b8:	c1 f8 1f             	sar    $0x1f,%eax
  8010bb:	29 c2                	sub    %eax,%edx
  8010bd:	89 d0                	mov    %edx,%eax
  8010bf:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c6:	75 bb                	jne    801083 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d2:	48                   	dec    %eax
  8010d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010da:	74 3d                	je     801119 <ltostr+0xc3>
		start = 1 ;
  8010dc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010e3:	eb 34                	jmp    801119 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	01 d0                	add    %edx,%eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f8:	01 c2                	add    %eax,%edx
  8010fa:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801100:	01 c8                	add    %ecx,%eax
  801102:	8a 00                	mov    (%eax),%al
  801104:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801106:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	01 c2                	add    %eax,%edx
  80110e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801111:	88 02                	mov    %al,(%edx)
		start++ ;
  801113:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801116:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80111f:	7c c4                	jl     8010e5 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801121:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	01 d0                	add    %edx,%eax
  801129:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80112c:	90                   	nop
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801135:	ff 75 08             	pushl  0x8(%ebp)
  801138:	e8 73 fa ff ff       	call   800bb0 <strlen>
  80113d:	83 c4 04             	add    $0x4,%esp
  801140:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801143:	ff 75 0c             	pushl  0xc(%ebp)
  801146:	e8 65 fa ff ff       	call   800bb0 <strlen>
  80114b:	83 c4 04             	add    $0x4,%esp
  80114e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801151:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801158:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80115f:	eb 17                	jmp    801178 <strcconcat+0x49>
		final[s] = str1[s] ;
  801161:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801164:	8b 45 10             	mov    0x10(%ebp),%eax
  801167:	01 c2                	add    %eax,%edx
  801169:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	01 c8                	add    %ecx,%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801175:	ff 45 fc             	incl   -0x4(%ebp)
  801178:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80117e:	7c e1                	jl     801161 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801180:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801187:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80118e:	eb 1f                	jmp    8011af <strcconcat+0x80>
		final[s++] = str2[i] ;
  801190:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801193:	8d 50 01             	lea    0x1(%eax),%edx
  801196:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801199:	89 c2                	mov    %eax,%edx
  80119b:	8b 45 10             	mov    0x10(%ebp),%eax
  80119e:	01 c2                	add    %eax,%edx
  8011a0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a6:	01 c8                	add    %ecx,%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011ac:	ff 45 f8             	incl   -0x8(%ebp)
  8011af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011b5:	7c d9                	jl     801190 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bd:	01 d0                	add    %edx,%eax
  8011bf:	c6 00 00             	movb   $0x0,(%eax)
}
  8011c2:	90                   	nop
  8011c3:	c9                   	leave  
  8011c4:	c3                   	ret    

008011c5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d4:	8b 00                	mov    (%eax),%eax
  8011d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e0:	01 d0                	add    %edx,%eax
  8011e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e8:	eb 0c                	jmp    8011f6 <strsplit+0x31>
			*string++ = 0;
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8d 50 01             	lea    0x1(%eax),%edx
  8011f0:	89 55 08             	mov    %edx,0x8(%ebp)
  8011f3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f9:	8a 00                	mov    (%eax),%al
  8011fb:	84 c0                	test   %al,%al
  8011fd:	74 18                	je     801217 <strsplit+0x52>
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	0f be c0             	movsbl %al,%eax
  801207:	50                   	push   %eax
  801208:	ff 75 0c             	pushl  0xc(%ebp)
  80120b:	e8 32 fb ff ff       	call   800d42 <strchr>
  801210:	83 c4 08             	add    $0x8,%esp
  801213:	85 c0                	test   %eax,%eax
  801215:	75 d3                	jne    8011ea <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	84 c0                	test   %al,%al
  80121e:	74 5a                	je     80127a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801220:	8b 45 14             	mov    0x14(%ebp),%eax
  801223:	8b 00                	mov    (%eax),%eax
  801225:	83 f8 0f             	cmp    $0xf,%eax
  801228:	75 07                	jne    801231 <strsplit+0x6c>
		{
			return 0;
  80122a:	b8 00 00 00 00       	mov    $0x0,%eax
  80122f:	eb 66                	jmp    801297 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801231:	8b 45 14             	mov    0x14(%ebp),%eax
  801234:	8b 00                	mov    (%eax),%eax
  801236:	8d 48 01             	lea    0x1(%eax),%ecx
  801239:	8b 55 14             	mov    0x14(%ebp),%edx
  80123c:	89 0a                	mov    %ecx,(%edx)
  80123e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801245:	8b 45 10             	mov    0x10(%ebp),%eax
  801248:	01 c2                	add    %eax,%edx
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80124f:	eb 03                	jmp    801254 <strsplit+0x8f>
			string++;
  801251:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	84 c0                	test   %al,%al
  80125b:	74 8b                	je     8011e8 <strsplit+0x23>
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8a 00                	mov    (%eax),%al
  801262:	0f be c0             	movsbl %al,%eax
  801265:	50                   	push   %eax
  801266:	ff 75 0c             	pushl  0xc(%ebp)
  801269:	e8 d4 fa ff ff       	call   800d42 <strchr>
  80126e:	83 c4 08             	add    $0x8,%esp
  801271:	85 c0                	test   %eax,%eax
  801273:	74 dc                	je     801251 <strsplit+0x8c>
			string++;
	}
  801275:	e9 6e ff ff ff       	jmp    8011e8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80127a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80127b:	8b 45 14             	mov    0x14(%ebp),%eax
  80127e:	8b 00                	mov    (%eax),%eax
  801280:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801287:	8b 45 10             	mov    0x10(%ebp),%eax
  80128a:	01 d0                	add    %edx,%eax
  80128c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801292:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801297:	c9                   	leave  
  801298:	c3                   	ret    

00801299 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80129f:	83 ec 04             	sub    $0x4,%esp
  8012a2:	68 28 24 80 00       	push   $0x802428
  8012a7:	68 3f 01 00 00       	push   $0x13f
  8012ac:	68 4a 24 80 00       	push   $0x80244a
  8012b1:	e8 a9 ef ff ff       	call   80025f <_panic>

008012b6 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8012b6:	55                   	push   %ebp
  8012b7:	89 e5                	mov    %esp,%ebp
  8012b9:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8012bc:	83 ec 0c             	sub    $0xc,%esp
  8012bf:	ff 75 08             	pushl  0x8(%ebp)
  8012c2:	e8 ef 06 00 00       	call   8019b6 <sys_sbrk>
  8012c7:	83 c4 10             	add    $0x10,%esp
}
  8012ca:	c9                   	leave  
  8012cb:	c3                   	ret    

008012cc <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
  8012cf:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8012d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012d6:	75 07                	jne    8012df <malloc+0x13>
  8012d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012dd:	eb 14                	jmp    8012f3 <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8012df:	83 ec 04             	sub    $0x4,%esp
  8012e2:	68 58 24 80 00       	push   $0x802458
  8012e7:	6a 1b                	push   $0x1b
  8012e9:	68 7d 24 80 00       	push   $0x80247d
  8012ee:	e8 6c ef ff ff       	call   80025f <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  8012f3:	c9                   	leave  
  8012f4:	c3                   	ret    

008012f5 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
  8012f8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8012fb:	83 ec 04             	sub    $0x4,%esp
  8012fe:	68 8c 24 80 00       	push   $0x80248c
  801303:	6a 29                	push   $0x29
  801305:	68 7d 24 80 00       	push   $0x80247d
  80130a:	e8 50 ef ff ff       	call   80025f <_panic>

0080130f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	83 ec 18             	sub    $0x18,%esp
  801315:	8b 45 10             	mov    0x10(%ebp),%eax
  801318:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80131b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80131f:	75 07                	jne    801328 <smalloc+0x19>
  801321:	b8 00 00 00 00       	mov    $0x0,%eax
  801326:	eb 14                	jmp    80133c <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801328:	83 ec 04             	sub    $0x4,%esp
  80132b:	68 b0 24 80 00       	push   $0x8024b0
  801330:	6a 38                	push   $0x38
  801332:	68 7d 24 80 00       	push   $0x80247d
  801337:	e8 23 ef ff ff       	call   80025f <_panic>
	return NULL;
}
  80133c:	c9                   	leave  
  80133d:	c3                   	ret    

0080133e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
  801341:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801344:	83 ec 04             	sub    $0x4,%esp
  801347:	68 d8 24 80 00       	push   $0x8024d8
  80134c:	6a 43                	push   $0x43
  80134e:	68 7d 24 80 00       	push   $0x80247d
  801353:	e8 07 ef ff ff       	call   80025f <_panic>

00801358 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
  80135b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80135e:	83 ec 04             	sub    $0x4,%esp
  801361:	68 fc 24 80 00       	push   $0x8024fc
  801366:	6a 5b                	push   $0x5b
  801368:	68 7d 24 80 00       	push   $0x80247d
  80136d:	e8 ed ee ff ff       	call   80025f <_panic>

00801372 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801372:	55                   	push   %ebp
  801373:	89 e5                	mov    %esp,%ebp
  801375:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801378:	83 ec 04             	sub    $0x4,%esp
  80137b:	68 20 25 80 00       	push   $0x802520
  801380:	6a 72                	push   $0x72
  801382:	68 7d 24 80 00       	push   $0x80247d
  801387:	e8 d3 ee ff ff       	call   80025f <_panic>

0080138c <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
  80138f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801392:	83 ec 04             	sub    $0x4,%esp
  801395:	68 46 25 80 00       	push   $0x802546
  80139a:	6a 7e                	push   $0x7e
  80139c:	68 7d 24 80 00       	push   $0x80247d
  8013a1:	e8 b9 ee ff ff       	call   80025f <_panic>

008013a6 <shrink>:

}
void shrink(uint32 newSize)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
  8013a9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8013ac:	83 ec 04             	sub    $0x4,%esp
  8013af:	68 46 25 80 00       	push   $0x802546
  8013b4:	68 83 00 00 00       	push   $0x83
  8013b9:	68 7d 24 80 00       	push   $0x80247d
  8013be:	e8 9c ee ff ff       	call   80025f <_panic>

008013c3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
  8013c6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8013c9:	83 ec 04             	sub    $0x4,%esp
  8013cc:	68 46 25 80 00       	push   $0x802546
  8013d1:	68 88 00 00 00       	push   $0x88
  8013d6:	68 7d 24 80 00       	push   $0x80247d
  8013db:	e8 7f ee ff ff       	call   80025f <_panic>

008013e0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
  8013e3:	57                   	push   %edi
  8013e4:	56                   	push   %esi
  8013e5:	53                   	push   %ebx
  8013e6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013f2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013f5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8013f8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8013fb:	cd 30                	int    $0x30
  8013fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801400:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801403:	83 c4 10             	add    $0x10,%esp
  801406:	5b                   	pop    %ebx
  801407:	5e                   	pop    %esi
  801408:	5f                   	pop    %edi
  801409:	5d                   	pop    %ebp
  80140a:	c3                   	ret    

0080140b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
  80140e:	83 ec 04             	sub    $0x4,%esp
  801411:	8b 45 10             	mov    0x10(%ebp),%eax
  801414:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801417:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	6a 00                	push   $0x0
  801420:	6a 00                	push   $0x0
  801422:	52                   	push   %edx
  801423:	ff 75 0c             	pushl  0xc(%ebp)
  801426:	50                   	push   %eax
  801427:	6a 00                	push   $0x0
  801429:	e8 b2 ff ff ff       	call   8013e0 <syscall>
  80142e:	83 c4 18             	add    $0x18,%esp
}
  801431:	90                   	nop
  801432:	c9                   	leave  
  801433:	c3                   	ret    

00801434 <sys_cgetc>:

int
sys_cgetc(void)
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 02                	push   $0x2
  801443:	e8 98 ff ff ff       	call   8013e0 <syscall>
  801448:	83 c4 18             	add    $0x18,%esp
}
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    

0080144d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 03                	push   $0x3
  80145c:	e8 7f ff ff ff       	call   8013e0 <syscall>
  801461:	83 c4 18             	add    $0x18,%esp
}
  801464:	90                   	nop
  801465:	c9                   	leave  
  801466:	c3                   	ret    

00801467 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801467:	55                   	push   %ebp
  801468:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80146a:	6a 00                	push   $0x0
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	6a 04                	push   $0x4
  801476:	e8 65 ff ff ff       	call   8013e0 <syscall>
  80147b:	83 c4 18             	add    $0x18,%esp
}
  80147e:	90                   	nop
  80147f:	c9                   	leave  
  801480:	c3                   	ret    

00801481 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801484:	8b 55 0c             	mov    0xc(%ebp),%edx
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	52                   	push   %edx
  801491:	50                   	push   %eax
  801492:	6a 08                	push   $0x8
  801494:	e8 47 ff ff ff       	call   8013e0 <syscall>
  801499:	83 c4 18             	add    $0x18,%esp
}
  80149c:	c9                   	leave  
  80149d:	c3                   	ret    

0080149e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
  8014a1:	56                   	push   %esi
  8014a2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014a3:	8b 75 18             	mov    0x18(%ebp),%esi
  8014a6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	56                   	push   %esi
  8014b3:	53                   	push   %ebx
  8014b4:	51                   	push   %ecx
  8014b5:	52                   	push   %edx
  8014b6:	50                   	push   %eax
  8014b7:	6a 09                	push   $0x9
  8014b9:	e8 22 ff ff ff       	call   8013e0 <syscall>
  8014be:	83 c4 18             	add    $0x18,%esp
}
  8014c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014c4:	5b                   	pop    %ebx
  8014c5:	5e                   	pop    %esi
  8014c6:	5d                   	pop    %ebp
  8014c7:	c3                   	ret    

008014c8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8014cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	52                   	push   %edx
  8014d8:	50                   	push   %eax
  8014d9:	6a 0a                	push   $0xa
  8014db:	e8 00 ff ff ff       	call   8013e0 <syscall>
  8014e0:	83 c4 18             	add    $0x18,%esp
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 00                	push   $0x0
  8014ee:	ff 75 0c             	pushl  0xc(%ebp)
  8014f1:	ff 75 08             	pushl  0x8(%ebp)
  8014f4:	6a 0b                	push   $0xb
  8014f6:	e8 e5 fe ff ff       	call   8013e0 <syscall>
  8014fb:	83 c4 18             	add    $0x18,%esp
}
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 0c                	push   $0xc
  80150f:	e8 cc fe ff ff       	call   8013e0 <syscall>
  801514:	83 c4 18             	add    $0x18,%esp
}
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 0d                	push   $0xd
  801528:	e8 b3 fe ff ff       	call   8013e0 <syscall>
  80152d:	83 c4 18             	add    $0x18,%esp
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 0e                	push   $0xe
  801541:	e8 9a fe ff ff       	call   8013e0 <syscall>
  801546:	83 c4 18             	add    $0x18,%esp
}
  801549:	c9                   	leave  
  80154a:	c3                   	ret    

0080154b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	6a 0f                	push   $0xf
  80155a:	e8 81 fe ff ff       	call   8013e0 <syscall>
  80155f:	83 c4 18             	add    $0x18,%esp
}
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	ff 75 08             	pushl  0x8(%ebp)
  801572:	6a 10                	push   $0x10
  801574:	e8 67 fe ff ff       	call   8013e0 <syscall>
  801579:	83 c4 18             	add    $0x18,%esp
}
  80157c:	c9                   	leave  
  80157d:	c3                   	ret    

0080157e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 11                	push   $0x11
  80158d:	e8 4e fe ff ff       	call   8013e0 <syscall>
  801592:	83 c4 18             	add    $0x18,%esp
}
  801595:	90                   	nop
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <sys_cputc>:

void
sys_cputc(const char c)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	83 ec 04             	sub    $0x4,%esp
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8015a4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	50                   	push   %eax
  8015b1:	6a 01                	push   $0x1
  8015b3:	e8 28 fe ff ff       	call   8013e0 <syscall>
  8015b8:	83 c4 18             	add    $0x18,%esp
}
  8015bb:	90                   	nop
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 14                	push   $0x14
  8015cd:	e8 0e fe ff ff       	call   8013e0 <syscall>
  8015d2:	83 c4 18             	add    $0x18,%esp
}
  8015d5:	90                   	nop
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	83 ec 04             	sub    $0x4,%esp
  8015de:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015e4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015e7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ee:	6a 00                	push   $0x0
  8015f0:	51                   	push   %ecx
  8015f1:	52                   	push   %edx
  8015f2:	ff 75 0c             	pushl  0xc(%ebp)
  8015f5:	50                   	push   %eax
  8015f6:	6a 15                	push   $0x15
  8015f8:	e8 e3 fd ff ff       	call   8013e0 <syscall>
  8015fd:	83 c4 18             	add    $0x18,%esp
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801605:	8b 55 0c             	mov    0xc(%ebp),%edx
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	52                   	push   %edx
  801612:	50                   	push   %eax
  801613:	6a 16                	push   $0x16
  801615:	e8 c6 fd ff ff       	call   8013e0 <syscall>
  80161a:	83 c4 18             	add    $0x18,%esp
}
  80161d:	c9                   	leave  
  80161e:	c3                   	ret    

0080161f <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801622:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801625:	8b 55 0c             	mov    0xc(%ebp),%edx
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	51                   	push   %ecx
  801630:	52                   	push   %edx
  801631:	50                   	push   %eax
  801632:	6a 17                	push   $0x17
  801634:	e8 a7 fd ff ff       	call   8013e0 <syscall>
  801639:	83 c4 18             	add    $0x18,%esp
}
  80163c:	c9                   	leave  
  80163d:	c3                   	ret    

0080163e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801641:	8b 55 0c             	mov    0xc(%ebp),%edx
  801644:	8b 45 08             	mov    0x8(%ebp),%eax
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	52                   	push   %edx
  80164e:	50                   	push   %eax
  80164f:	6a 18                	push   $0x18
  801651:	e8 8a fd ff ff       	call   8013e0 <syscall>
  801656:	83 c4 18             	add    $0x18,%esp
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	6a 00                	push   $0x0
  801663:	ff 75 14             	pushl  0x14(%ebp)
  801666:	ff 75 10             	pushl  0x10(%ebp)
  801669:	ff 75 0c             	pushl  0xc(%ebp)
  80166c:	50                   	push   %eax
  80166d:	6a 19                	push   $0x19
  80166f:	e8 6c fd ff ff       	call   8013e0 <syscall>
  801674:	83 c4 18             	add    $0x18,%esp
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	50                   	push   %eax
  801688:	6a 1a                	push   $0x1a
  80168a:	e8 51 fd ff ff       	call   8013e0 <syscall>
  80168f:	83 c4 18             	add    $0x18,%esp
}
  801692:	90                   	nop
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	50                   	push   %eax
  8016a4:	6a 1b                	push   $0x1b
  8016a6:	e8 35 fd ff ff       	call   8013e0 <syscall>
  8016ab:	83 c4 18             	add    $0x18,%esp
}
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 05                	push   $0x5
  8016bf:	e8 1c fd ff ff       	call   8013e0 <syscall>
  8016c4:	83 c4 18             	add    $0x18,%esp
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 06                	push   $0x6
  8016d8:	e8 03 fd ff ff       	call   8013e0 <syscall>
  8016dd:	83 c4 18             	add    $0x18,%esp
}
  8016e0:	c9                   	leave  
  8016e1:	c3                   	ret    

008016e2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 07                	push   $0x7
  8016f1:	e8 ea fc ff ff       	call   8013e0 <syscall>
  8016f6:	83 c4 18             	add    $0x18,%esp
}
  8016f9:	c9                   	leave  
  8016fa:	c3                   	ret    

008016fb <sys_exit_env>:


void sys_exit_env(void)
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 1c                	push   $0x1c
  80170a:	e8 d1 fc ff ff       	call   8013e0 <syscall>
  80170f:	83 c4 18             	add    $0x18,%esp
}
  801712:	90                   	nop
  801713:	c9                   	leave  
  801714:	c3                   	ret    

00801715 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
  801718:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80171b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80171e:	8d 50 04             	lea    0x4(%eax),%edx
  801721:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	52                   	push   %edx
  80172b:	50                   	push   %eax
  80172c:	6a 1d                	push   $0x1d
  80172e:	e8 ad fc ff ff       	call   8013e0 <syscall>
  801733:	83 c4 18             	add    $0x18,%esp
	return result;
  801736:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801739:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80173c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80173f:	89 01                	mov    %eax,(%ecx)
  801741:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	c9                   	leave  
  801748:	c2 04 00             	ret    $0x4

0080174b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	ff 75 10             	pushl  0x10(%ebp)
  801755:	ff 75 0c             	pushl  0xc(%ebp)
  801758:	ff 75 08             	pushl  0x8(%ebp)
  80175b:	6a 13                	push   $0x13
  80175d:	e8 7e fc ff ff       	call   8013e0 <syscall>
  801762:	83 c4 18             	add    $0x18,%esp
	return ;
  801765:	90                   	nop
}
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <sys_rcr2>:
uint32 sys_rcr2()
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 1e                	push   $0x1e
  801777:	e8 64 fc ff ff       	call   8013e0 <syscall>
  80177c:	83 c4 18             	add    $0x18,%esp
}
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	83 ec 04             	sub    $0x4,%esp
  801787:	8b 45 08             	mov    0x8(%ebp),%eax
  80178a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80178d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	50                   	push   %eax
  80179a:	6a 1f                	push   $0x1f
  80179c:	e8 3f fc ff ff       	call   8013e0 <syscall>
  8017a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a4:	90                   	nop
}
  8017a5:	c9                   	leave  
  8017a6:	c3                   	ret    

008017a7 <rsttst>:
void rsttst()
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 21                	push   $0x21
  8017b6:	e8 25 fc ff ff       	call   8013e0 <syscall>
  8017bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8017be:	90                   	nop
}
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	83 ec 04             	sub    $0x4,%esp
  8017c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017cd:	8b 55 18             	mov    0x18(%ebp),%edx
  8017d0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017d4:	52                   	push   %edx
  8017d5:	50                   	push   %eax
  8017d6:	ff 75 10             	pushl  0x10(%ebp)
  8017d9:	ff 75 0c             	pushl  0xc(%ebp)
  8017dc:	ff 75 08             	pushl  0x8(%ebp)
  8017df:	6a 20                	push   $0x20
  8017e1:	e8 fa fb ff ff       	call   8013e0 <syscall>
  8017e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e9:	90                   	nop
}
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <chktst>:
void chktst(uint32 n)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	ff 75 08             	pushl  0x8(%ebp)
  8017fa:	6a 22                	push   $0x22
  8017fc:	e8 df fb ff ff       	call   8013e0 <syscall>
  801801:	83 c4 18             	add    $0x18,%esp
	return ;
  801804:	90                   	nop
}
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <inctst>:

void inctst()
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 23                	push   $0x23
  801816:	e8 c5 fb ff ff       	call   8013e0 <syscall>
  80181b:	83 c4 18             	add    $0x18,%esp
	return ;
  80181e:	90                   	nop
}
  80181f:	c9                   	leave  
  801820:	c3                   	ret    

00801821 <gettst>:
uint32 gettst()
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 24                	push   $0x24
  801830:	e8 ab fb ff ff       	call   8013e0 <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 25                	push   $0x25
  80184c:	e8 8f fb ff ff       	call   8013e0 <syscall>
  801851:	83 c4 18             	add    $0x18,%esp
  801854:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801857:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80185b:	75 07                	jne    801864 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80185d:	b8 01 00 00 00       	mov    $0x1,%eax
  801862:	eb 05                	jmp    801869 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801864:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
  80186e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 25                	push   $0x25
  80187d:	e8 5e fb ff ff       	call   8013e0 <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
  801885:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801888:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80188c:	75 07                	jne    801895 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80188e:	b8 01 00 00 00       	mov    $0x1,%eax
  801893:	eb 05                	jmp    80189a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801895:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 25                	push   $0x25
  8018ae:	e8 2d fb ff ff       	call   8013e0 <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
  8018b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8018b9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8018bd:	75 07                	jne    8018c6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8018bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8018c4:	eb 05                	jmp    8018cb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8018c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
  8018d0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 25                	push   $0x25
  8018df:	e8 fc fa ff ff       	call   8013e0 <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
  8018e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8018ea:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8018ee:	75 07                	jne    8018f7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8018f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8018f5:	eb 05                	jmp    8018fc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8018f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    

008018fe <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	ff 75 08             	pushl  0x8(%ebp)
  80190c:	6a 26                	push   $0x26
  80190e:	e8 cd fa ff ff       	call   8013e0 <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
	return ;
  801916:	90                   	nop
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80191d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801920:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801923:	8b 55 0c             	mov    0xc(%ebp),%edx
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	6a 00                	push   $0x0
  80192b:	53                   	push   %ebx
  80192c:	51                   	push   %ecx
  80192d:	52                   	push   %edx
  80192e:	50                   	push   %eax
  80192f:	6a 27                	push   $0x27
  801931:	e8 aa fa ff ff       	call   8013e0 <syscall>
  801936:	83 c4 18             	add    $0x18,%esp
}
  801939:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801941:	8b 55 0c             	mov    0xc(%ebp),%edx
  801944:	8b 45 08             	mov    0x8(%ebp),%eax
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	52                   	push   %edx
  80194e:	50                   	push   %eax
  80194f:	6a 28                	push   $0x28
  801951:	e8 8a fa ff ff       	call   8013e0 <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80195e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801961:	8b 55 0c             	mov    0xc(%ebp),%edx
  801964:	8b 45 08             	mov    0x8(%ebp),%eax
  801967:	6a 00                	push   $0x0
  801969:	51                   	push   %ecx
  80196a:	ff 75 10             	pushl  0x10(%ebp)
  80196d:	52                   	push   %edx
  80196e:	50                   	push   %eax
  80196f:	6a 29                	push   $0x29
  801971:	e8 6a fa ff ff       	call   8013e0 <syscall>
  801976:	83 c4 18             	add    $0x18,%esp
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	ff 75 10             	pushl  0x10(%ebp)
  801985:	ff 75 0c             	pushl  0xc(%ebp)
  801988:	ff 75 08             	pushl  0x8(%ebp)
  80198b:	6a 12                	push   $0x12
  80198d:	e8 4e fa ff ff       	call   8013e0 <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
	return ;
  801995:	90                   	nop
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80199b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	52                   	push   %edx
  8019a8:	50                   	push   %eax
  8019a9:	6a 2a                	push   $0x2a
  8019ab:	e8 30 fa ff ff       	call   8013e0 <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
	return;
  8019b3:	90                   	nop
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	50                   	push   %eax
  8019c5:	6a 2b                	push   $0x2b
  8019c7:	e8 14 fa ff ff       	call   8013e0 <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	ff 75 0c             	pushl  0xc(%ebp)
  8019dd:	ff 75 08             	pushl  0x8(%ebp)
  8019e0:	6a 2c                	push   $0x2c
  8019e2:	e8 f9 f9 ff ff       	call   8013e0 <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
	return;
  8019ea:	90                   	nop
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	ff 75 0c             	pushl  0xc(%ebp)
  8019f9:	ff 75 08             	pushl  0x8(%ebp)
  8019fc:	6a 2d                	push   $0x2d
  8019fe:	e8 dd f9 ff ff       	call   8013e0 <syscall>
  801a03:	83 c4 18             	add    $0x18,%esp
	return;
  801a06:	90                   	nop
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801a0f:	8b 55 08             	mov    0x8(%ebp),%edx
  801a12:	89 d0                	mov    %edx,%eax
  801a14:	c1 e0 02             	shl    $0x2,%eax
  801a17:	01 d0                	add    %edx,%eax
  801a19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a20:	01 d0                	add    %edx,%eax
  801a22:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a29:	01 d0                	add    %edx,%eax
  801a2b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a32:	01 d0                	add    %edx,%eax
  801a34:	c1 e0 04             	shl    $0x4,%eax
  801a37:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801a3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801a41:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801a44:	83 ec 0c             	sub    $0xc,%esp
  801a47:	50                   	push   %eax
  801a48:	e8 c8 fc ff ff       	call   801715 <sys_get_virtual_time>
  801a4d:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801a50:	eb 41                	jmp    801a93 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801a52:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801a55:	83 ec 0c             	sub    $0xc,%esp
  801a58:	50                   	push   %eax
  801a59:	e8 b7 fc ff ff       	call   801715 <sys_get_virtual_time>
  801a5e:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801a61:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a67:	29 c2                	sub    %eax,%edx
  801a69:	89 d0                	mov    %edx,%eax
  801a6b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801a6e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a74:	89 d1                	mov    %edx,%ecx
  801a76:	29 c1                	sub    %eax,%ecx
  801a78:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a7e:	39 c2                	cmp    %eax,%edx
  801a80:	0f 97 c0             	seta   %al
  801a83:	0f b6 c0             	movzbl %al,%eax
  801a86:	29 c1                	sub    %eax,%ecx
  801a88:	89 c8                	mov    %ecx,%eax
  801a8a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801a8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a90:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a96:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a99:	72 b7                	jb     801a52 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801a9b:	90                   	nop
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801aa4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801aab:	eb 03                	jmp    801ab0 <busy_wait+0x12>
  801aad:	ff 45 fc             	incl   -0x4(%ebp)
  801ab0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ab3:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ab6:	72 f5                	jb     801aad <busy_wait+0xf>
	return i;
  801ab8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    
  801abd:	66 90                	xchg   %ax,%ax
  801abf:	90                   	nop

00801ac0 <__udivdi3>:
  801ac0:	55                   	push   %ebp
  801ac1:	57                   	push   %edi
  801ac2:	56                   	push   %esi
  801ac3:	53                   	push   %ebx
  801ac4:	83 ec 1c             	sub    $0x1c,%esp
  801ac7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801acb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801acf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ad3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ad7:	89 ca                	mov    %ecx,%edx
  801ad9:	89 f8                	mov    %edi,%eax
  801adb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801adf:	85 f6                	test   %esi,%esi
  801ae1:	75 2d                	jne    801b10 <__udivdi3+0x50>
  801ae3:	39 cf                	cmp    %ecx,%edi
  801ae5:	77 65                	ja     801b4c <__udivdi3+0x8c>
  801ae7:	89 fd                	mov    %edi,%ebp
  801ae9:	85 ff                	test   %edi,%edi
  801aeb:	75 0b                	jne    801af8 <__udivdi3+0x38>
  801aed:	b8 01 00 00 00       	mov    $0x1,%eax
  801af2:	31 d2                	xor    %edx,%edx
  801af4:	f7 f7                	div    %edi
  801af6:	89 c5                	mov    %eax,%ebp
  801af8:	31 d2                	xor    %edx,%edx
  801afa:	89 c8                	mov    %ecx,%eax
  801afc:	f7 f5                	div    %ebp
  801afe:	89 c1                	mov    %eax,%ecx
  801b00:	89 d8                	mov    %ebx,%eax
  801b02:	f7 f5                	div    %ebp
  801b04:	89 cf                	mov    %ecx,%edi
  801b06:	89 fa                	mov    %edi,%edx
  801b08:	83 c4 1c             	add    $0x1c,%esp
  801b0b:	5b                   	pop    %ebx
  801b0c:	5e                   	pop    %esi
  801b0d:	5f                   	pop    %edi
  801b0e:	5d                   	pop    %ebp
  801b0f:	c3                   	ret    
  801b10:	39 ce                	cmp    %ecx,%esi
  801b12:	77 28                	ja     801b3c <__udivdi3+0x7c>
  801b14:	0f bd fe             	bsr    %esi,%edi
  801b17:	83 f7 1f             	xor    $0x1f,%edi
  801b1a:	75 40                	jne    801b5c <__udivdi3+0x9c>
  801b1c:	39 ce                	cmp    %ecx,%esi
  801b1e:	72 0a                	jb     801b2a <__udivdi3+0x6a>
  801b20:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b24:	0f 87 9e 00 00 00    	ja     801bc8 <__udivdi3+0x108>
  801b2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b2f:	89 fa                	mov    %edi,%edx
  801b31:	83 c4 1c             	add    $0x1c,%esp
  801b34:	5b                   	pop    %ebx
  801b35:	5e                   	pop    %esi
  801b36:	5f                   	pop    %edi
  801b37:	5d                   	pop    %ebp
  801b38:	c3                   	ret    
  801b39:	8d 76 00             	lea    0x0(%esi),%esi
  801b3c:	31 ff                	xor    %edi,%edi
  801b3e:	31 c0                	xor    %eax,%eax
  801b40:	89 fa                	mov    %edi,%edx
  801b42:	83 c4 1c             	add    $0x1c,%esp
  801b45:	5b                   	pop    %ebx
  801b46:	5e                   	pop    %esi
  801b47:	5f                   	pop    %edi
  801b48:	5d                   	pop    %ebp
  801b49:	c3                   	ret    
  801b4a:	66 90                	xchg   %ax,%ax
  801b4c:	89 d8                	mov    %ebx,%eax
  801b4e:	f7 f7                	div    %edi
  801b50:	31 ff                	xor    %edi,%edi
  801b52:	89 fa                	mov    %edi,%edx
  801b54:	83 c4 1c             	add    $0x1c,%esp
  801b57:	5b                   	pop    %ebx
  801b58:	5e                   	pop    %esi
  801b59:	5f                   	pop    %edi
  801b5a:	5d                   	pop    %ebp
  801b5b:	c3                   	ret    
  801b5c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b61:	89 eb                	mov    %ebp,%ebx
  801b63:	29 fb                	sub    %edi,%ebx
  801b65:	89 f9                	mov    %edi,%ecx
  801b67:	d3 e6                	shl    %cl,%esi
  801b69:	89 c5                	mov    %eax,%ebp
  801b6b:	88 d9                	mov    %bl,%cl
  801b6d:	d3 ed                	shr    %cl,%ebp
  801b6f:	89 e9                	mov    %ebp,%ecx
  801b71:	09 f1                	or     %esi,%ecx
  801b73:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b77:	89 f9                	mov    %edi,%ecx
  801b79:	d3 e0                	shl    %cl,%eax
  801b7b:	89 c5                	mov    %eax,%ebp
  801b7d:	89 d6                	mov    %edx,%esi
  801b7f:	88 d9                	mov    %bl,%cl
  801b81:	d3 ee                	shr    %cl,%esi
  801b83:	89 f9                	mov    %edi,%ecx
  801b85:	d3 e2                	shl    %cl,%edx
  801b87:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b8b:	88 d9                	mov    %bl,%cl
  801b8d:	d3 e8                	shr    %cl,%eax
  801b8f:	09 c2                	or     %eax,%edx
  801b91:	89 d0                	mov    %edx,%eax
  801b93:	89 f2                	mov    %esi,%edx
  801b95:	f7 74 24 0c          	divl   0xc(%esp)
  801b99:	89 d6                	mov    %edx,%esi
  801b9b:	89 c3                	mov    %eax,%ebx
  801b9d:	f7 e5                	mul    %ebp
  801b9f:	39 d6                	cmp    %edx,%esi
  801ba1:	72 19                	jb     801bbc <__udivdi3+0xfc>
  801ba3:	74 0b                	je     801bb0 <__udivdi3+0xf0>
  801ba5:	89 d8                	mov    %ebx,%eax
  801ba7:	31 ff                	xor    %edi,%edi
  801ba9:	e9 58 ff ff ff       	jmp    801b06 <__udivdi3+0x46>
  801bae:	66 90                	xchg   %ax,%ax
  801bb0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801bb4:	89 f9                	mov    %edi,%ecx
  801bb6:	d3 e2                	shl    %cl,%edx
  801bb8:	39 c2                	cmp    %eax,%edx
  801bba:	73 e9                	jae    801ba5 <__udivdi3+0xe5>
  801bbc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801bbf:	31 ff                	xor    %edi,%edi
  801bc1:	e9 40 ff ff ff       	jmp    801b06 <__udivdi3+0x46>
  801bc6:	66 90                	xchg   %ax,%ax
  801bc8:	31 c0                	xor    %eax,%eax
  801bca:	e9 37 ff ff ff       	jmp    801b06 <__udivdi3+0x46>
  801bcf:	90                   	nop

00801bd0 <__umoddi3>:
  801bd0:	55                   	push   %ebp
  801bd1:	57                   	push   %edi
  801bd2:	56                   	push   %esi
  801bd3:	53                   	push   %ebx
  801bd4:	83 ec 1c             	sub    $0x1c,%esp
  801bd7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bdb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bdf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801be3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801be7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801beb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bef:	89 f3                	mov    %esi,%ebx
  801bf1:	89 fa                	mov    %edi,%edx
  801bf3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bf7:	89 34 24             	mov    %esi,(%esp)
  801bfa:	85 c0                	test   %eax,%eax
  801bfc:	75 1a                	jne    801c18 <__umoddi3+0x48>
  801bfe:	39 f7                	cmp    %esi,%edi
  801c00:	0f 86 a2 00 00 00    	jbe    801ca8 <__umoddi3+0xd8>
  801c06:	89 c8                	mov    %ecx,%eax
  801c08:	89 f2                	mov    %esi,%edx
  801c0a:	f7 f7                	div    %edi
  801c0c:	89 d0                	mov    %edx,%eax
  801c0e:	31 d2                	xor    %edx,%edx
  801c10:	83 c4 1c             	add    $0x1c,%esp
  801c13:	5b                   	pop    %ebx
  801c14:	5e                   	pop    %esi
  801c15:	5f                   	pop    %edi
  801c16:	5d                   	pop    %ebp
  801c17:	c3                   	ret    
  801c18:	39 f0                	cmp    %esi,%eax
  801c1a:	0f 87 ac 00 00 00    	ja     801ccc <__umoddi3+0xfc>
  801c20:	0f bd e8             	bsr    %eax,%ebp
  801c23:	83 f5 1f             	xor    $0x1f,%ebp
  801c26:	0f 84 ac 00 00 00    	je     801cd8 <__umoddi3+0x108>
  801c2c:	bf 20 00 00 00       	mov    $0x20,%edi
  801c31:	29 ef                	sub    %ebp,%edi
  801c33:	89 fe                	mov    %edi,%esi
  801c35:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c39:	89 e9                	mov    %ebp,%ecx
  801c3b:	d3 e0                	shl    %cl,%eax
  801c3d:	89 d7                	mov    %edx,%edi
  801c3f:	89 f1                	mov    %esi,%ecx
  801c41:	d3 ef                	shr    %cl,%edi
  801c43:	09 c7                	or     %eax,%edi
  801c45:	89 e9                	mov    %ebp,%ecx
  801c47:	d3 e2                	shl    %cl,%edx
  801c49:	89 14 24             	mov    %edx,(%esp)
  801c4c:	89 d8                	mov    %ebx,%eax
  801c4e:	d3 e0                	shl    %cl,%eax
  801c50:	89 c2                	mov    %eax,%edx
  801c52:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c56:	d3 e0                	shl    %cl,%eax
  801c58:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c5c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c60:	89 f1                	mov    %esi,%ecx
  801c62:	d3 e8                	shr    %cl,%eax
  801c64:	09 d0                	or     %edx,%eax
  801c66:	d3 eb                	shr    %cl,%ebx
  801c68:	89 da                	mov    %ebx,%edx
  801c6a:	f7 f7                	div    %edi
  801c6c:	89 d3                	mov    %edx,%ebx
  801c6e:	f7 24 24             	mull   (%esp)
  801c71:	89 c6                	mov    %eax,%esi
  801c73:	89 d1                	mov    %edx,%ecx
  801c75:	39 d3                	cmp    %edx,%ebx
  801c77:	0f 82 87 00 00 00    	jb     801d04 <__umoddi3+0x134>
  801c7d:	0f 84 91 00 00 00    	je     801d14 <__umoddi3+0x144>
  801c83:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c87:	29 f2                	sub    %esi,%edx
  801c89:	19 cb                	sbb    %ecx,%ebx
  801c8b:	89 d8                	mov    %ebx,%eax
  801c8d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c91:	d3 e0                	shl    %cl,%eax
  801c93:	89 e9                	mov    %ebp,%ecx
  801c95:	d3 ea                	shr    %cl,%edx
  801c97:	09 d0                	or     %edx,%eax
  801c99:	89 e9                	mov    %ebp,%ecx
  801c9b:	d3 eb                	shr    %cl,%ebx
  801c9d:	89 da                	mov    %ebx,%edx
  801c9f:	83 c4 1c             	add    $0x1c,%esp
  801ca2:	5b                   	pop    %ebx
  801ca3:	5e                   	pop    %esi
  801ca4:	5f                   	pop    %edi
  801ca5:	5d                   	pop    %ebp
  801ca6:	c3                   	ret    
  801ca7:	90                   	nop
  801ca8:	89 fd                	mov    %edi,%ebp
  801caa:	85 ff                	test   %edi,%edi
  801cac:	75 0b                	jne    801cb9 <__umoddi3+0xe9>
  801cae:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb3:	31 d2                	xor    %edx,%edx
  801cb5:	f7 f7                	div    %edi
  801cb7:	89 c5                	mov    %eax,%ebp
  801cb9:	89 f0                	mov    %esi,%eax
  801cbb:	31 d2                	xor    %edx,%edx
  801cbd:	f7 f5                	div    %ebp
  801cbf:	89 c8                	mov    %ecx,%eax
  801cc1:	f7 f5                	div    %ebp
  801cc3:	89 d0                	mov    %edx,%eax
  801cc5:	e9 44 ff ff ff       	jmp    801c0e <__umoddi3+0x3e>
  801cca:	66 90                	xchg   %ax,%ax
  801ccc:	89 c8                	mov    %ecx,%eax
  801cce:	89 f2                	mov    %esi,%edx
  801cd0:	83 c4 1c             	add    $0x1c,%esp
  801cd3:	5b                   	pop    %ebx
  801cd4:	5e                   	pop    %esi
  801cd5:	5f                   	pop    %edi
  801cd6:	5d                   	pop    %ebp
  801cd7:	c3                   	ret    
  801cd8:	3b 04 24             	cmp    (%esp),%eax
  801cdb:	72 06                	jb     801ce3 <__umoddi3+0x113>
  801cdd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ce1:	77 0f                	ja     801cf2 <__umoddi3+0x122>
  801ce3:	89 f2                	mov    %esi,%edx
  801ce5:	29 f9                	sub    %edi,%ecx
  801ce7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ceb:	89 14 24             	mov    %edx,(%esp)
  801cee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cf2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801cf6:	8b 14 24             	mov    (%esp),%edx
  801cf9:	83 c4 1c             	add    $0x1c,%esp
  801cfc:	5b                   	pop    %ebx
  801cfd:	5e                   	pop    %esi
  801cfe:	5f                   	pop    %edi
  801cff:	5d                   	pop    %ebp
  801d00:	c3                   	ret    
  801d01:	8d 76 00             	lea    0x0(%esi),%esi
  801d04:	2b 04 24             	sub    (%esp),%eax
  801d07:	19 fa                	sbb    %edi,%edx
  801d09:	89 d1                	mov    %edx,%ecx
  801d0b:	89 c6                	mov    %eax,%esi
  801d0d:	e9 71 ff ff ff       	jmp    801c83 <__umoddi3+0xb3>
  801d12:	66 90                	xchg   %ax,%ax
  801d14:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d18:	72 ea                	jb     801d04 <__umoddi3+0x134>
  801d1a:	89 d9                	mov    %ebx,%ecx
  801d1c:	e9 62 ff ff ff       	jmp    801c83 <__umoddi3+0xb3>
