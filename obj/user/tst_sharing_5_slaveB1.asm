
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
  80003e:	a1 20 50 80 00       	mov    0x805020,%eax
  800043:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  800049:	a1 20 50 80 00       	mov    0x805020,%eax
  80004e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800054:	39 c2                	cmp    %eax,%edx
  800056:	72 14                	jb     80006c <_main+0x34>
			panic("Please increase the WS size");
  800058:	83 ec 04             	sub    $0x4,%esp
  80005b:	68 60 3b 80 00       	push   $0x803b60
  800060:	6a 0c                	push   $0xc
  800062:	68 7c 3b 80 00       	push   $0x803b7c
  800067:	e8 fb 01 00 00       	call   800267 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006c:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	x = sget(sys_getparentenvid(),"x");
  800073:	e8 10 1a 00 00       	call   801a88 <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 99 3b 80 00       	push   $0x803b99
  800080:	50                   	push   %eax
  800081:	e8 ea 15 00 00       	call   801670 <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 9c 3b 80 00       	push   $0x803b9c
  800094:	e8 8b 04 00 00       	call   800524 <cprintf>
  800099:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got x
	inctst();
  80009c:	e8 0c 1b 00 00       	call   801bad <inctst>
	cprintf("Slave B1 please be patient ...\n");
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	68 c4 3b 80 00       	push   $0x803bc4
  8000a9:	e8 76 04 00 00       	call   800524 <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(6000);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 70 17 00 00       	push   $0x1770
  8000b9:	e8 8a 37 00 00       	call   803848 <env_sleep>
  8000be:	83 c4 10             	add    $0x10,%esp
	while (gettst()!=2) ;// panic("test failed");
  8000c1:	90                   	nop
  8000c2:	e8 00 1b 00 00       	call   801bc7 <gettst>
  8000c7:	83 f8 02             	cmp    $0x2,%eax
  8000ca:	75 f6                	jne    8000c2 <_main+0x8a>

	freeFrames = sys_calculate_free_frames() ;
  8000cc:	e8 d5 17 00 00       	call   8018a6 <sys_calculate_free_frames>
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	sfree(x);
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000da:	e8 16 16 00 00       	call   8016f5 <sfree>
  8000df:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 e4 3b 80 00       	push   $0x803be4
  8000ea:	e8 35 04 00 00       	call   800524 <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
	expected = 1+1; /*1page+1table*/
  8000f2:	c7 45 e8 02 00 00 00 	movl   $0x2,-0x18(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  8000f9:	e8 a8 17 00 00       	call   8018a6 <sys_calculate_free_frames>
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800103:	29 c2                	sub    %eax,%edx
  800105:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800108:	39 c2                	cmp    %eax,%edx
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 fc 3b 80 00       	push   $0x803bfc
  800114:	6a 26                	push   $0x26
  800116:	68 7c 3b 80 00       	push   $0x803b7c
  80011b:	e8 47 01 00 00       	call   800267 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800120:	e8 88 1a 00 00       	call   801bad <inctst>
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
  80012e:	e8 3c 19 00 00       	call   801a6f <sys_getenvindex>
  800133:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800136:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800139:	89 d0                	mov    %edx,%eax
  80013b:	c1 e0 03             	shl    $0x3,%eax
  80013e:	01 d0                	add    %edx,%eax
  800140:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800147:	01 c8                	add    %ecx,%eax
  800149:	01 c0                	add    %eax,%eax
  80014b:	01 d0                	add    %edx,%eax
  80014d:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800154:	01 c8                	add    %ecx,%eax
  800156:	01 d0                	add    %edx,%eax
  800158:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80015d:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800162:	a1 20 50 80 00       	mov    0x805020,%eax
  800167:	8a 40 20             	mov    0x20(%eax),%al
  80016a:	84 c0                	test   %al,%al
  80016c:	74 0d                	je     80017b <libmain+0x53>
		binaryname = myEnv->prog_name;
  80016e:	a1 20 50 80 00       	mov    0x805020,%eax
  800173:	83 c0 20             	add    $0x20,%eax
  800176:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80017b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80017f:	7e 0a                	jle    80018b <libmain+0x63>
		binaryname = argv[0];
  800181:	8b 45 0c             	mov    0xc(%ebp),%eax
  800184:	8b 00                	mov    (%eax),%eax
  800186:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80018b:	83 ec 08             	sub    $0x8,%esp
  80018e:	ff 75 0c             	pushl  0xc(%ebp)
  800191:	ff 75 08             	pushl  0x8(%ebp)
  800194:	e8 9f fe ff ff       	call   800038 <_main>
  800199:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80019c:	e8 52 16 00 00       	call   8017f3 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001a1:	83 ec 0c             	sub    $0xc,%esp
  8001a4:	68 bc 3c 80 00       	push   $0x803cbc
  8001a9:	e8 76 03 00 00       	call   800524 <cprintf>
  8001ae:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001b1:	a1 20 50 80 00       	mov    0x805020,%eax
  8001b6:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8001bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8001c1:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8001c7:	83 ec 04             	sub    $0x4,%esp
  8001ca:	52                   	push   %edx
  8001cb:	50                   	push   %eax
  8001cc:	68 e4 3c 80 00       	push   $0x803ce4
  8001d1:	e8 4e 03 00 00       	call   800524 <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001d9:	a1 20 50 80 00       	mov    0x805020,%eax
  8001de:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8001e4:	a1 20 50 80 00       	mov    0x805020,%eax
  8001e9:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8001ef:	a1 20 50 80 00       	mov    0x805020,%eax
  8001f4:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8001fa:	51                   	push   %ecx
  8001fb:	52                   	push   %edx
  8001fc:	50                   	push   %eax
  8001fd:	68 0c 3d 80 00       	push   $0x803d0c
  800202:	e8 1d 03 00 00       	call   800524 <cprintf>
  800207:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80020a:	a1 20 50 80 00       	mov    0x805020,%eax
  80020f:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800215:	83 ec 08             	sub    $0x8,%esp
  800218:	50                   	push   %eax
  800219:	68 64 3d 80 00       	push   $0x803d64
  80021e:	e8 01 03 00 00       	call   800524 <cprintf>
  800223:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800226:	83 ec 0c             	sub    $0xc,%esp
  800229:	68 bc 3c 80 00       	push   $0x803cbc
  80022e:	e8 f1 02 00 00       	call   800524 <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800236:	e8 d2 15 00 00       	call   80180d <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80023b:	e8 19 00 00 00       	call   800259 <exit>
}
  800240:	90                   	nop
  800241:	c9                   	leave  
  800242:	c3                   	ret    

00800243 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800249:	83 ec 0c             	sub    $0xc,%esp
  80024c:	6a 00                	push   $0x0
  80024e:	e8 e8 17 00 00       	call   801a3b <sys_destroy_env>
  800253:	83 c4 10             	add    $0x10,%esp
}
  800256:	90                   	nop
  800257:	c9                   	leave  
  800258:	c3                   	ret    

00800259 <exit>:

void
exit(void)
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80025f:	e8 3d 18 00 00       	call   801aa1 <sys_exit_env>
}
  800264:	90                   	nop
  800265:	c9                   	leave  
  800266:	c3                   	ret    

00800267 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80026d:	8d 45 10             	lea    0x10(%ebp),%eax
  800270:	83 c0 04             	add    $0x4,%eax
  800273:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800276:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80027b:	85 c0                	test   %eax,%eax
  80027d:	74 16                	je     800295 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80027f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800284:	83 ec 08             	sub    $0x8,%esp
  800287:	50                   	push   %eax
  800288:	68 78 3d 80 00       	push   $0x803d78
  80028d:	e8 92 02 00 00       	call   800524 <cprintf>
  800292:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800295:	a1 00 50 80 00       	mov    0x805000,%eax
  80029a:	ff 75 0c             	pushl  0xc(%ebp)
  80029d:	ff 75 08             	pushl  0x8(%ebp)
  8002a0:	50                   	push   %eax
  8002a1:	68 7d 3d 80 00       	push   $0x803d7d
  8002a6:	e8 79 02 00 00       	call   800524 <cprintf>
  8002ab:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b1:	83 ec 08             	sub    $0x8,%esp
  8002b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8002b7:	50                   	push   %eax
  8002b8:	e8 fc 01 00 00       	call   8004b9 <vcprintf>
  8002bd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002c0:	83 ec 08             	sub    $0x8,%esp
  8002c3:	6a 00                	push   $0x0
  8002c5:	68 99 3d 80 00       	push   $0x803d99
  8002ca:	e8 ea 01 00 00       	call   8004b9 <vcprintf>
  8002cf:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002d2:	e8 82 ff ff ff       	call   800259 <exit>

	// should not return here
	while (1) ;
  8002d7:	eb fe                	jmp    8002d7 <_panic+0x70>

008002d9 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002d9:	55                   	push   %ebp
  8002da:	89 e5                	mov    %esp,%ebp
  8002dc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002df:	a1 20 50 80 00       	mov    0x805020,%eax
  8002e4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8002ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ed:	39 c2                	cmp    %eax,%edx
  8002ef:	74 14                	je     800305 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002f1:	83 ec 04             	sub    $0x4,%esp
  8002f4:	68 9c 3d 80 00       	push   $0x803d9c
  8002f9:	6a 26                	push   $0x26
  8002fb:	68 e8 3d 80 00       	push   $0x803de8
  800300:	e8 62 ff ff ff       	call   800267 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800305:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80030c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800313:	e9 c5 00 00 00       	jmp    8003dd <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800318:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80031b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800322:	8b 45 08             	mov    0x8(%ebp),%eax
  800325:	01 d0                	add    %edx,%eax
  800327:	8b 00                	mov    (%eax),%eax
  800329:	85 c0                	test   %eax,%eax
  80032b:	75 08                	jne    800335 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80032d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800330:	e9 a5 00 00 00       	jmp    8003da <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800335:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80033c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800343:	eb 69                	jmp    8003ae <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800345:	a1 20 50 80 00       	mov    0x805020,%eax
  80034a:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800350:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800353:	89 d0                	mov    %edx,%eax
  800355:	01 c0                	add    %eax,%eax
  800357:	01 d0                	add    %edx,%eax
  800359:	c1 e0 03             	shl    $0x3,%eax
  80035c:	01 c8                	add    %ecx,%eax
  80035e:	8a 40 04             	mov    0x4(%eax),%al
  800361:	84 c0                	test   %al,%al
  800363:	75 46                	jne    8003ab <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800365:	a1 20 50 80 00       	mov    0x805020,%eax
  80036a:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800370:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800373:	89 d0                	mov    %edx,%eax
  800375:	01 c0                	add    %eax,%eax
  800377:	01 d0                	add    %edx,%eax
  800379:	c1 e0 03             	shl    $0x3,%eax
  80037c:	01 c8                	add    %ecx,%eax
  80037e:	8b 00                	mov    (%eax),%eax
  800380:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800383:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800386:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80038b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80038d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800390:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800397:	8b 45 08             	mov    0x8(%ebp),%eax
  80039a:	01 c8                	add    %ecx,%eax
  80039c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80039e:	39 c2                	cmp    %eax,%edx
  8003a0:	75 09                	jne    8003ab <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003a2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003a9:	eb 15                	jmp    8003c0 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ab:	ff 45 e8             	incl   -0x18(%ebp)
  8003ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b3:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8003b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003bc:	39 c2                	cmp    %eax,%edx
  8003be:	77 85                	ja     800345 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003c4:	75 14                	jne    8003da <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003c6:	83 ec 04             	sub    $0x4,%esp
  8003c9:	68 f4 3d 80 00       	push   $0x803df4
  8003ce:	6a 3a                	push   $0x3a
  8003d0:	68 e8 3d 80 00       	push   $0x803de8
  8003d5:	e8 8d fe ff ff       	call   800267 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003da:	ff 45 f0             	incl   -0x10(%ebp)
  8003dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003e3:	0f 8c 2f ff ff ff    	jl     800318 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003e9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003f7:	eb 26                	jmp    80041f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8003fe:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800404:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800407:	89 d0                	mov    %edx,%eax
  800409:	01 c0                	add    %eax,%eax
  80040b:	01 d0                	add    %edx,%eax
  80040d:	c1 e0 03             	shl    $0x3,%eax
  800410:	01 c8                	add    %ecx,%eax
  800412:	8a 40 04             	mov    0x4(%eax),%al
  800415:	3c 01                	cmp    $0x1,%al
  800417:	75 03                	jne    80041c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800419:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80041c:	ff 45 e0             	incl   -0x20(%ebp)
  80041f:	a1 20 50 80 00       	mov    0x805020,%eax
  800424:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80042a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042d:	39 c2                	cmp    %eax,%edx
  80042f:	77 c8                	ja     8003f9 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800434:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800437:	74 14                	je     80044d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800439:	83 ec 04             	sub    $0x4,%esp
  80043c:	68 48 3e 80 00       	push   $0x803e48
  800441:	6a 44                	push   $0x44
  800443:	68 e8 3d 80 00       	push   $0x803de8
  800448:	e8 1a fe ff ff       	call   800267 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80044d:	90                   	nop
  80044e:	c9                   	leave  
  80044f:	c3                   	ret    

00800450 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800450:	55                   	push   %ebp
  800451:	89 e5                	mov    %esp,%ebp
  800453:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800456:	8b 45 0c             	mov    0xc(%ebp),%eax
  800459:	8b 00                	mov    (%eax),%eax
  80045b:	8d 48 01             	lea    0x1(%eax),%ecx
  80045e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800461:	89 0a                	mov    %ecx,(%edx)
  800463:	8b 55 08             	mov    0x8(%ebp),%edx
  800466:	88 d1                	mov    %dl,%cl
  800468:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80046f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800472:	8b 00                	mov    (%eax),%eax
  800474:	3d ff 00 00 00       	cmp    $0xff,%eax
  800479:	75 2c                	jne    8004a7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80047b:	a0 28 50 80 00       	mov    0x805028,%al
  800480:	0f b6 c0             	movzbl %al,%eax
  800483:	8b 55 0c             	mov    0xc(%ebp),%edx
  800486:	8b 12                	mov    (%edx),%edx
  800488:	89 d1                	mov    %edx,%ecx
  80048a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048d:	83 c2 08             	add    $0x8,%edx
  800490:	83 ec 04             	sub    $0x4,%esp
  800493:	50                   	push   %eax
  800494:	51                   	push   %ecx
  800495:	52                   	push   %edx
  800496:	e8 16 13 00 00       	call   8017b1 <sys_cputs>
  80049b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80049e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004aa:	8b 40 04             	mov    0x4(%eax),%eax
  8004ad:	8d 50 01             	lea    0x1(%eax),%edx
  8004b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004b6:	90                   	nop
  8004b7:	c9                   	leave  
  8004b8:	c3                   	ret    

008004b9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004b9:	55                   	push   %ebp
  8004ba:	89 e5                	mov    %esp,%ebp
  8004bc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004c9:	00 00 00 
	b.cnt = 0;
  8004cc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004d3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004d6:	ff 75 0c             	pushl  0xc(%ebp)
  8004d9:	ff 75 08             	pushl  0x8(%ebp)
  8004dc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e2:	50                   	push   %eax
  8004e3:	68 50 04 80 00       	push   $0x800450
  8004e8:	e8 11 02 00 00       	call   8006fe <vprintfmt>
  8004ed:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004f0:	a0 28 50 80 00       	mov    0x805028,%al
  8004f5:	0f b6 c0             	movzbl %al,%eax
  8004f8:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004fe:	83 ec 04             	sub    $0x4,%esp
  800501:	50                   	push   %eax
  800502:	52                   	push   %edx
  800503:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800509:	83 c0 08             	add    $0x8,%eax
  80050c:	50                   	push   %eax
  80050d:	e8 9f 12 00 00       	call   8017b1 <sys_cputs>
  800512:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800515:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  80051c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800522:	c9                   	leave  
  800523:	c3                   	ret    

00800524 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800524:	55                   	push   %ebp
  800525:	89 e5                	mov    %esp,%ebp
  800527:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80052a:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800531:	8d 45 0c             	lea    0xc(%ebp),%eax
  800534:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800537:	8b 45 08             	mov    0x8(%ebp),%eax
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	ff 75 f4             	pushl  -0xc(%ebp)
  800540:	50                   	push   %eax
  800541:	e8 73 ff ff ff       	call   8004b9 <vcprintf>
  800546:	83 c4 10             	add    $0x10,%esp
  800549:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80054c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80054f:	c9                   	leave  
  800550:	c3                   	ret    

00800551 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800551:	55                   	push   %ebp
  800552:	89 e5                	mov    %esp,%ebp
  800554:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800557:	e8 97 12 00 00       	call   8017f3 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80055c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80055f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800562:	8b 45 08             	mov    0x8(%ebp),%eax
  800565:	83 ec 08             	sub    $0x8,%esp
  800568:	ff 75 f4             	pushl  -0xc(%ebp)
  80056b:	50                   	push   %eax
  80056c:	e8 48 ff ff ff       	call   8004b9 <vcprintf>
  800571:	83 c4 10             	add    $0x10,%esp
  800574:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800577:	e8 91 12 00 00       	call   80180d <sys_unlock_cons>
	return cnt;
  80057c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80057f:	c9                   	leave  
  800580:	c3                   	ret    

00800581 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800581:	55                   	push   %ebp
  800582:	89 e5                	mov    %esp,%ebp
  800584:	53                   	push   %ebx
  800585:	83 ec 14             	sub    $0x14,%esp
  800588:	8b 45 10             	mov    0x10(%ebp),%eax
  80058b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80058e:	8b 45 14             	mov    0x14(%ebp),%eax
  800591:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800594:	8b 45 18             	mov    0x18(%ebp),%eax
  800597:	ba 00 00 00 00       	mov    $0x0,%edx
  80059c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80059f:	77 55                	ja     8005f6 <printnum+0x75>
  8005a1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a4:	72 05                	jb     8005ab <printnum+0x2a>
  8005a6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005a9:	77 4b                	ja     8005f6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ab:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005ae:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005b1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b9:	52                   	push   %edx
  8005ba:	50                   	push   %eax
  8005bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8005be:	ff 75 f0             	pushl  -0x10(%ebp)
  8005c1:	e8 36 33 00 00       	call   8038fc <__udivdi3>
  8005c6:	83 c4 10             	add    $0x10,%esp
  8005c9:	83 ec 04             	sub    $0x4,%esp
  8005cc:	ff 75 20             	pushl  0x20(%ebp)
  8005cf:	53                   	push   %ebx
  8005d0:	ff 75 18             	pushl  0x18(%ebp)
  8005d3:	52                   	push   %edx
  8005d4:	50                   	push   %eax
  8005d5:	ff 75 0c             	pushl  0xc(%ebp)
  8005d8:	ff 75 08             	pushl  0x8(%ebp)
  8005db:	e8 a1 ff ff ff       	call   800581 <printnum>
  8005e0:	83 c4 20             	add    $0x20,%esp
  8005e3:	eb 1a                	jmp    8005ff <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005e5:	83 ec 08             	sub    $0x8,%esp
  8005e8:	ff 75 0c             	pushl  0xc(%ebp)
  8005eb:	ff 75 20             	pushl  0x20(%ebp)
  8005ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f1:	ff d0                	call   *%eax
  8005f3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f6:	ff 4d 1c             	decl   0x1c(%ebp)
  8005f9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005fd:	7f e6                	jg     8005e5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005ff:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800602:	bb 00 00 00 00       	mov    $0x0,%ebx
  800607:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80060d:	53                   	push   %ebx
  80060e:	51                   	push   %ecx
  80060f:	52                   	push   %edx
  800610:	50                   	push   %eax
  800611:	e8 f6 33 00 00       	call   803a0c <__umoddi3>
  800616:	83 c4 10             	add    $0x10,%esp
  800619:	05 b4 40 80 00       	add    $0x8040b4,%eax
  80061e:	8a 00                	mov    (%eax),%al
  800620:	0f be c0             	movsbl %al,%eax
  800623:	83 ec 08             	sub    $0x8,%esp
  800626:	ff 75 0c             	pushl  0xc(%ebp)
  800629:	50                   	push   %eax
  80062a:	8b 45 08             	mov    0x8(%ebp),%eax
  80062d:	ff d0                	call   *%eax
  80062f:	83 c4 10             	add    $0x10,%esp
}
  800632:	90                   	nop
  800633:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800636:	c9                   	leave  
  800637:	c3                   	ret    

00800638 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800638:	55                   	push   %ebp
  800639:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80063b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80063f:	7e 1c                	jle    80065d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800641:	8b 45 08             	mov    0x8(%ebp),%eax
  800644:	8b 00                	mov    (%eax),%eax
  800646:	8d 50 08             	lea    0x8(%eax),%edx
  800649:	8b 45 08             	mov    0x8(%ebp),%eax
  80064c:	89 10                	mov    %edx,(%eax)
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	8b 00                	mov    (%eax),%eax
  800653:	83 e8 08             	sub    $0x8,%eax
  800656:	8b 50 04             	mov    0x4(%eax),%edx
  800659:	8b 00                	mov    (%eax),%eax
  80065b:	eb 40                	jmp    80069d <getuint+0x65>
	else if (lflag)
  80065d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800661:	74 1e                	je     800681 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800663:	8b 45 08             	mov    0x8(%ebp),%eax
  800666:	8b 00                	mov    (%eax),%eax
  800668:	8d 50 04             	lea    0x4(%eax),%edx
  80066b:	8b 45 08             	mov    0x8(%ebp),%eax
  80066e:	89 10                	mov    %edx,(%eax)
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	83 e8 04             	sub    $0x4,%eax
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	ba 00 00 00 00       	mov    $0x0,%edx
  80067f:	eb 1c                	jmp    80069d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	8b 00                	mov    (%eax),%eax
  800686:	8d 50 04             	lea    0x4(%eax),%edx
  800689:	8b 45 08             	mov    0x8(%ebp),%eax
  80068c:	89 10                	mov    %edx,(%eax)
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	8b 00                	mov    (%eax),%eax
  800693:	83 e8 04             	sub    $0x4,%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80069d:	5d                   	pop    %ebp
  80069e:	c3                   	ret    

0080069f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80069f:	55                   	push   %ebp
  8006a0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a6:	7e 1c                	jle    8006c4 <getint+0x25>
		return va_arg(*ap, long long);
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	8b 00                	mov    (%eax),%eax
  8006ad:	8d 50 08             	lea    0x8(%eax),%edx
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	89 10                	mov    %edx,(%eax)
  8006b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	83 e8 08             	sub    $0x8,%eax
  8006bd:	8b 50 04             	mov    0x4(%eax),%edx
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	eb 38                	jmp    8006fc <getint+0x5d>
	else if (lflag)
  8006c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c8:	74 1a                	je     8006e4 <getint+0x45>
		return va_arg(*ap, long);
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8b 00                	mov    (%eax),%eax
  8006cf:	8d 50 04             	lea    0x4(%eax),%edx
  8006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d5:	89 10                	mov    %edx,(%eax)
  8006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	83 e8 04             	sub    $0x4,%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	99                   	cltd   
  8006e2:	eb 18                	jmp    8006fc <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	8b 00                	mov    (%eax),%eax
  8006e9:	8d 50 04             	lea    0x4(%eax),%edx
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	89 10                	mov    %edx,(%eax)
  8006f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	83 e8 04             	sub    $0x4,%eax
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	99                   	cltd   
}
  8006fc:	5d                   	pop    %ebp
  8006fd:	c3                   	ret    

008006fe <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006fe:	55                   	push   %ebp
  8006ff:	89 e5                	mov    %esp,%ebp
  800701:	56                   	push   %esi
  800702:	53                   	push   %ebx
  800703:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800706:	eb 17                	jmp    80071f <vprintfmt+0x21>
			if (ch == '\0')
  800708:	85 db                	test   %ebx,%ebx
  80070a:	0f 84 c1 03 00 00    	je     800ad1 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800710:	83 ec 08             	sub    $0x8,%esp
  800713:	ff 75 0c             	pushl  0xc(%ebp)
  800716:	53                   	push   %ebx
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	ff d0                	call   *%eax
  80071c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80071f:	8b 45 10             	mov    0x10(%ebp),%eax
  800722:	8d 50 01             	lea    0x1(%eax),%edx
  800725:	89 55 10             	mov    %edx,0x10(%ebp)
  800728:	8a 00                	mov    (%eax),%al
  80072a:	0f b6 d8             	movzbl %al,%ebx
  80072d:	83 fb 25             	cmp    $0x25,%ebx
  800730:	75 d6                	jne    800708 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800732:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800736:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80073d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800744:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80074b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800752:	8b 45 10             	mov    0x10(%ebp),%eax
  800755:	8d 50 01             	lea    0x1(%eax),%edx
  800758:	89 55 10             	mov    %edx,0x10(%ebp)
  80075b:	8a 00                	mov    (%eax),%al
  80075d:	0f b6 d8             	movzbl %al,%ebx
  800760:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800763:	83 f8 5b             	cmp    $0x5b,%eax
  800766:	0f 87 3d 03 00 00    	ja     800aa9 <vprintfmt+0x3ab>
  80076c:	8b 04 85 d8 40 80 00 	mov    0x8040d8(,%eax,4),%eax
  800773:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800775:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800779:	eb d7                	jmp    800752 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80077b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80077f:	eb d1                	jmp    800752 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800781:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800788:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80078b:	89 d0                	mov    %edx,%eax
  80078d:	c1 e0 02             	shl    $0x2,%eax
  800790:	01 d0                	add    %edx,%eax
  800792:	01 c0                	add    %eax,%eax
  800794:	01 d8                	add    %ebx,%eax
  800796:	83 e8 30             	sub    $0x30,%eax
  800799:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80079c:	8b 45 10             	mov    0x10(%ebp),%eax
  80079f:	8a 00                	mov    (%eax),%al
  8007a1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007a4:	83 fb 2f             	cmp    $0x2f,%ebx
  8007a7:	7e 3e                	jle    8007e7 <vprintfmt+0xe9>
  8007a9:	83 fb 39             	cmp    $0x39,%ebx
  8007ac:	7f 39                	jg     8007e7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ae:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b1:	eb d5                	jmp    800788 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b6:	83 c0 04             	add    $0x4,%eax
  8007b9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	83 e8 04             	sub    $0x4,%eax
  8007c2:	8b 00                	mov    (%eax),%eax
  8007c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007c7:	eb 1f                	jmp    8007e8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007cd:	79 83                	jns    800752 <vprintfmt+0x54>
				width = 0;
  8007cf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007d6:	e9 77 ff ff ff       	jmp    800752 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007db:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007e2:	e9 6b ff ff ff       	jmp    800752 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007e7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ec:	0f 89 60 ff ff ff    	jns    800752 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007ff:	e9 4e ff ff ff       	jmp    800752 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800804:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800807:	e9 46 ff ff ff       	jmp    800752 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80080c:	8b 45 14             	mov    0x14(%ebp),%eax
  80080f:	83 c0 04             	add    $0x4,%eax
  800812:	89 45 14             	mov    %eax,0x14(%ebp)
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	83 e8 04             	sub    $0x4,%eax
  80081b:	8b 00                	mov    (%eax),%eax
  80081d:	83 ec 08             	sub    $0x8,%esp
  800820:	ff 75 0c             	pushl  0xc(%ebp)
  800823:	50                   	push   %eax
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	ff d0                	call   *%eax
  800829:	83 c4 10             	add    $0x10,%esp
			break;
  80082c:	e9 9b 02 00 00       	jmp    800acc <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800831:	8b 45 14             	mov    0x14(%ebp),%eax
  800834:	83 c0 04             	add    $0x4,%eax
  800837:	89 45 14             	mov    %eax,0x14(%ebp)
  80083a:	8b 45 14             	mov    0x14(%ebp),%eax
  80083d:	83 e8 04             	sub    $0x4,%eax
  800840:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800842:	85 db                	test   %ebx,%ebx
  800844:	79 02                	jns    800848 <vprintfmt+0x14a>
				err = -err;
  800846:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800848:	83 fb 64             	cmp    $0x64,%ebx
  80084b:	7f 0b                	jg     800858 <vprintfmt+0x15a>
  80084d:	8b 34 9d 20 3f 80 00 	mov    0x803f20(,%ebx,4),%esi
  800854:	85 f6                	test   %esi,%esi
  800856:	75 19                	jne    800871 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800858:	53                   	push   %ebx
  800859:	68 c5 40 80 00       	push   $0x8040c5
  80085e:	ff 75 0c             	pushl  0xc(%ebp)
  800861:	ff 75 08             	pushl  0x8(%ebp)
  800864:	e8 70 02 00 00       	call   800ad9 <printfmt>
  800869:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80086c:	e9 5b 02 00 00       	jmp    800acc <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800871:	56                   	push   %esi
  800872:	68 ce 40 80 00       	push   $0x8040ce
  800877:	ff 75 0c             	pushl  0xc(%ebp)
  80087a:	ff 75 08             	pushl  0x8(%ebp)
  80087d:	e8 57 02 00 00       	call   800ad9 <printfmt>
  800882:	83 c4 10             	add    $0x10,%esp
			break;
  800885:	e9 42 02 00 00       	jmp    800acc <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80088a:	8b 45 14             	mov    0x14(%ebp),%eax
  80088d:	83 c0 04             	add    $0x4,%eax
  800890:	89 45 14             	mov    %eax,0x14(%ebp)
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	83 e8 04             	sub    $0x4,%eax
  800899:	8b 30                	mov    (%eax),%esi
  80089b:	85 f6                	test   %esi,%esi
  80089d:	75 05                	jne    8008a4 <vprintfmt+0x1a6>
				p = "(null)";
  80089f:	be d1 40 80 00       	mov    $0x8040d1,%esi
			if (width > 0 && padc != '-')
  8008a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a8:	7e 6d                	jle    800917 <vprintfmt+0x219>
  8008aa:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008ae:	74 67                	je     800917 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b3:	83 ec 08             	sub    $0x8,%esp
  8008b6:	50                   	push   %eax
  8008b7:	56                   	push   %esi
  8008b8:	e8 1e 03 00 00       	call   800bdb <strnlen>
  8008bd:	83 c4 10             	add    $0x10,%esp
  8008c0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008c3:	eb 16                	jmp    8008db <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008c5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008c9:	83 ec 08             	sub    $0x8,%esp
  8008cc:	ff 75 0c             	pushl  0xc(%ebp)
  8008cf:	50                   	push   %eax
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	ff d0                	call   *%eax
  8008d5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d8:	ff 4d e4             	decl   -0x1c(%ebp)
  8008db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008df:	7f e4                	jg     8008c5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e1:	eb 34                	jmp    800917 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008e3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008e7:	74 1c                	je     800905 <vprintfmt+0x207>
  8008e9:	83 fb 1f             	cmp    $0x1f,%ebx
  8008ec:	7e 05                	jle    8008f3 <vprintfmt+0x1f5>
  8008ee:	83 fb 7e             	cmp    $0x7e,%ebx
  8008f1:	7e 12                	jle    800905 <vprintfmt+0x207>
					putch('?', putdat);
  8008f3:	83 ec 08             	sub    $0x8,%esp
  8008f6:	ff 75 0c             	pushl  0xc(%ebp)
  8008f9:	6a 3f                	push   $0x3f
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	ff d0                	call   *%eax
  800900:	83 c4 10             	add    $0x10,%esp
  800903:	eb 0f                	jmp    800914 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800905:	83 ec 08             	sub    $0x8,%esp
  800908:	ff 75 0c             	pushl  0xc(%ebp)
  80090b:	53                   	push   %ebx
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	ff d0                	call   *%eax
  800911:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800914:	ff 4d e4             	decl   -0x1c(%ebp)
  800917:	89 f0                	mov    %esi,%eax
  800919:	8d 70 01             	lea    0x1(%eax),%esi
  80091c:	8a 00                	mov    (%eax),%al
  80091e:	0f be d8             	movsbl %al,%ebx
  800921:	85 db                	test   %ebx,%ebx
  800923:	74 24                	je     800949 <vprintfmt+0x24b>
  800925:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800929:	78 b8                	js     8008e3 <vprintfmt+0x1e5>
  80092b:	ff 4d e0             	decl   -0x20(%ebp)
  80092e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800932:	79 af                	jns    8008e3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800934:	eb 13                	jmp    800949 <vprintfmt+0x24b>
				putch(' ', putdat);
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	ff 75 0c             	pushl  0xc(%ebp)
  80093c:	6a 20                	push   $0x20
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	ff d0                	call   *%eax
  800943:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800946:	ff 4d e4             	decl   -0x1c(%ebp)
  800949:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094d:	7f e7                	jg     800936 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80094f:	e9 78 01 00 00       	jmp    800acc <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800954:	83 ec 08             	sub    $0x8,%esp
  800957:	ff 75 e8             	pushl  -0x18(%ebp)
  80095a:	8d 45 14             	lea    0x14(%ebp),%eax
  80095d:	50                   	push   %eax
  80095e:	e8 3c fd ff ff       	call   80069f <getint>
  800963:	83 c4 10             	add    $0x10,%esp
  800966:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800969:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80096c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80096f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800972:	85 d2                	test   %edx,%edx
  800974:	79 23                	jns    800999 <vprintfmt+0x29b>
				putch('-', putdat);
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	ff 75 0c             	pushl  0xc(%ebp)
  80097c:	6a 2d                	push   $0x2d
  80097e:	8b 45 08             	mov    0x8(%ebp),%eax
  800981:	ff d0                	call   *%eax
  800983:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800986:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800989:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80098c:	f7 d8                	neg    %eax
  80098e:	83 d2 00             	adc    $0x0,%edx
  800991:	f7 da                	neg    %edx
  800993:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800996:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800999:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a0:	e9 bc 00 00 00       	jmp    800a61 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009a5:	83 ec 08             	sub    $0x8,%esp
  8009a8:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ab:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ae:	50                   	push   %eax
  8009af:	e8 84 fc ff ff       	call   800638 <getuint>
  8009b4:	83 c4 10             	add    $0x10,%esp
  8009b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009bd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c4:	e9 98 00 00 00       	jmp    800a61 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009c9:	83 ec 08             	sub    $0x8,%esp
  8009cc:	ff 75 0c             	pushl  0xc(%ebp)
  8009cf:	6a 58                	push   $0x58
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	ff d0                	call   *%eax
  8009d6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009d9:	83 ec 08             	sub    $0x8,%esp
  8009dc:	ff 75 0c             	pushl  0xc(%ebp)
  8009df:	6a 58                	push   $0x58
  8009e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e4:	ff d0                	call   *%eax
  8009e6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	6a 58                	push   $0x58
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	ff d0                	call   *%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
			break;
  8009f9:	e9 ce 00 00 00       	jmp    800acc <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8009fe:	83 ec 08             	sub    $0x8,%esp
  800a01:	ff 75 0c             	pushl  0xc(%ebp)
  800a04:	6a 30                	push   $0x30
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	ff d0                	call   *%eax
  800a0b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a0e:	83 ec 08             	sub    $0x8,%esp
  800a11:	ff 75 0c             	pushl  0xc(%ebp)
  800a14:	6a 78                	push   $0x78
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	ff d0                	call   *%eax
  800a1b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a21:	83 c0 04             	add    $0x4,%eax
  800a24:	89 45 14             	mov    %eax,0x14(%ebp)
  800a27:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2a:	83 e8 04             	sub    $0x4,%eax
  800a2d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a39:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a40:	eb 1f                	jmp    800a61 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a42:	83 ec 08             	sub    $0x8,%esp
  800a45:	ff 75 e8             	pushl  -0x18(%ebp)
  800a48:	8d 45 14             	lea    0x14(%ebp),%eax
  800a4b:	50                   	push   %eax
  800a4c:	e8 e7 fb ff ff       	call   800638 <getuint>
  800a51:	83 c4 10             	add    $0x10,%esp
  800a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a57:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a5a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a61:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a68:	83 ec 04             	sub    $0x4,%esp
  800a6b:	52                   	push   %edx
  800a6c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a6f:	50                   	push   %eax
  800a70:	ff 75 f4             	pushl  -0xc(%ebp)
  800a73:	ff 75 f0             	pushl  -0x10(%ebp)
  800a76:	ff 75 0c             	pushl  0xc(%ebp)
  800a79:	ff 75 08             	pushl  0x8(%ebp)
  800a7c:	e8 00 fb ff ff       	call   800581 <printnum>
  800a81:	83 c4 20             	add    $0x20,%esp
			break;
  800a84:	eb 46                	jmp    800acc <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 0c             	pushl  0xc(%ebp)
  800a8c:	53                   	push   %ebx
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	ff d0                	call   *%eax
  800a92:	83 c4 10             	add    $0x10,%esp
			break;
  800a95:	eb 35                	jmp    800acc <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a97:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800a9e:	eb 2c                	jmp    800acc <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800aa0:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  800aa7:	eb 23                	jmp    800acc <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	6a 25                	push   $0x25
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	ff d0                	call   *%eax
  800ab6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab9:	ff 4d 10             	decl   0x10(%ebp)
  800abc:	eb 03                	jmp    800ac1 <vprintfmt+0x3c3>
  800abe:	ff 4d 10             	decl   0x10(%ebp)
  800ac1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac4:	48                   	dec    %eax
  800ac5:	8a 00                	mov    (%eax),%al
  800ac7:	3c 25                	cmp    $0x25,%al
  800ac9:	75 f3                	jne    800abe <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800acb:	90                   	nop
		}
	}
  800acc:	e9 35 fc ff ff       	jmp    800706 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ad1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ad2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ad5:	5b                   	pop    %ebx
  800ad6:	5e                   	pop    %esi
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800adf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ae2:	83 c0 04             	add    $0x4,%eax
  800ae5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ae8:	8b 45 10             	mov    0x10(%ebp),%eax
  800aeb:	ff 75 f4             	pushl  -0xc(%ebp)
  800aee:	50                   	push   %eax
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 08             	pushl  0x8(%ebp)
  800af5:	e8 04 fc ff ff       	call   8006fe <vprintfmt>
  800afa:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800afd:	90                   	nop
  800afe:	c9                   	leave  
  800aff:	c3                   	ret    

00800b00 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b06:	8b 40 08             	mov    0x8(%eax),%eax
  800b09:	8d 50 01             	lea    0x1(%eax),%edx
  800b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b15:	8b 10                	mov    (%eax),%edx
  800b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1a:	8b 40 04             	mov    0x4(%eax),%eax
  800b1d:	39 c2                	cmp    %eax,%edx
  800b1f:	73 12                	jae    800b33 <sprintputch+0x33>
		*b->buf++ = ch;
  800b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b24:	8b 00                	mov    (%eax),%eax
  800b26:	8d 48 01             	lea    0x1(%eax),%ecx
  800b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2c:	89 0a                	mov    %ecx,(%edx)
  800b2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b31:	88 10                	mov    %dl,(%eax)
}
  800b33:	90                   	nop
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	01 d0                	add    %edx,%eax
  800b4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b5b:	74 06                	je     800b63 <vsnprintf+0x2d>
  800b5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b61:	7f 07                	jg     800b6a <vsnprintf+0x34>
		return -E_INVAL;
  800b63:	b8 03 00 00 00       	mov    $0x3,%eax
  800b68:	eb 20                	jmp    800b8a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b6a:	ff 75 14             	pushl  0x14(%ebp)
  800b6d:	ff 75 10             	pushl  0x10(%ebp)
  800b70:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b73:	50                   	push   %eax
  800b74:	68 00 0b 80 00       	push   $0x800b00
  800b79:	e8 80 fb ff ff       	call   8006fe <vprintfmt>
  800b7e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b84:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b8a:	c9                   	leave  
  800b8b:	c3                   	ret    

00800b8c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b92:	8d 45 10             	lea    0x10(%ebp),%eax
  800b95:	83 c0 04             	add    $0x4,%eax
  800b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba1:	50                   	push   %eax
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	ff 75 08             	pushl  0x8(%ebp)
  800ba8:	e8 89 ff ff ff       	call   800b36 <vsnprintf>
  800bad:	83 c4 10             	add    $0x10,%esp
  800bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc5:	eb 06                	jmp    800bcd <strlen+0x15>
		n++;
  800bc7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bca:	ff 45 08             	incl   0x8(%ebp)
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	84 c0                	test   %al,%al
  800bd4:	75 f1                	jne    800bc7 <strlen+0xf>
		n++;
	return n;
  800bd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be8:	eb 09                	jmp    800bf3 <strnlen+0x18>
		n++;
  800bea:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bed:	ff 45 08             	incl   0x8(%ebp)
  800bf0:	ff 4d 0c             	decl   0xc(%ebp)
  800bf3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf7:	74 09                	je     800c02 <strnlen+0x27>
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8a 00                	mov    (%eax),%al
  800bfe:	84 c0                	test   %al,%al
  800c00:	75 e8                	jne    800bea <strnlen+0xf>
		n++;
	return n;
  800c02:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c13:	90                   	nop
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	8d 50 01             	lea    0x1(%eax),%edx
  800c1a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c20:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c23:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c26:	8a 12                	mov    (%edx),%dl
  800c28:	88 10                	mov    %dl,(%eax)
  800c2a:	8a 00                	mov    (%eax),%al
  800c2c:	84 c0                	test   %al,%al
  800c2e:	75 e4                	jne    800c14 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c30:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c33:	c9                   	leave  
  800c34:	c3                   	ret    

00800c35 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c48:	eb 1f                	jmp    800c69 <strncpy+0x34>
		*dst++ = *src;
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	8d 50 01             	lea    0x1(%eax),%edx
  800c50:	89 55 08             	mov    %edx,0x8(%ebp)
  800c53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c56:	8a 12                	mov    (%edx),%dl
  800c58:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5d:	8a 00                	mov    (%eax),%al
  800c5f:	84 c0                	test   %al,%al
  800c61:	74 03                	je     800c66 <strncpy+0x31>
			src++;
  800c63:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c66:	ff 45 fc             	incl   -0x4(%ebp)
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c6f:	72 d9                	jb     800c4a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c71:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c74:	c9                   	leave  
  800c75:	c3                   	ret    

00800c76 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c86:	74 30                	je     800cb8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c88:	eb 16                	jmp    800ca0 <strlcpy+0x2a>
			*dst++ = *src++;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	8d 50 01             	lea    0x1(%eax),%edx
  800c90:	89 55 08             	mov    %edx,0x8(%ebp)
  800c93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c96:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c99:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c9c:	8a 12                	mov    (%edx),%dl
  800c9e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ca0:	ff 4d 10             	decl   0x10(%ebp)
  800ca3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca7:	74 09                	je     800cb2 <strlcpy+0x3c>
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	84 c0                	test   %al,%al
  800cb0:	75 d8                	jne    800c8a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbe:	29 c2                	sub    %eax,%edx
  800cc0:	89 d0                	mov    %edx,%eax
}
  800cc2:	c9                   	leave  
  800cc3:	c3                   	ret    

00800cc4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cc7:	eb 06                	jmp    800ccf <strcmp+0xb>
		p++, q++;
  800cc9:	ff 45 08             	incl   0x8(%ebp)
  800ccc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	84 c0                	test   %al,%al
  800cd6:	74 0e                	je     800ce6 <strcmp+0x22>
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8a 10                	mov    (%eax),%dl
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	38 c2                	cmp    %al,%dl
  800ce4:	74 e3                	je     800cc9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8a 00                	mov    (%eax),%al
  800ceb:	0f b6 d0             	movzbl %al,%edx
  800cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	0f b6 c0             	movzbl %al,%eax
  800cf6:	29 c2                	sub    %eax,%edx
  800cf8:	89 d0                	mov    %edx,%eax
}
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    

00800cfc <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cff:	eb 09                	jmp    800d0a <strncmp+0xe>
		n--, p++, q++;
  800d01:	ff 4d 10             	decl   0x10(%ebp)
  800d04:	ff 45 08             	incl   0x8(%ebp)
  800d07:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0e:	74 17                	je     800d27 <strncmp+0x2b>
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	84 c0                	test   %al,%al
  800d17:	74 0e                	je     800d27 <strncmp+0x2b>
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8a 10                	mov    (%eax),%dl
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	38 c2                	cmp    %al,%dl
  800d25:	74 da                	je     800d01 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2b:	75 07                	jne    800d34 <strncmp+0x38>
		return 0;
  800d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d32:	eb 14                	jmp    800d48 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	0f b6 d0             	movzbl %al,%edx
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	0f b6 c0             	movzbl %al,%eax
  800d44:	29 c2                	sub    %eax,%edx
  800d46:	89 d0                	mov    %edx,%eax
}
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	83 ec 04             	sub    $0x4,%esp
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d56:	eb 12                	jmp    800d6a <strchr+0x20>
		if (*s == c)
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8a 00                	mov    (%eax),%al
  800d5d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d60:	75 05                	jne    800d67 <strchr+0x1d>
			return (char *) s;
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	eb 11                	jmp    800d78 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d67:	ff 45 08             	incl   0x8(%ebp)
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	84 c0                	test   %al,%al
  800d71:	75 e5                	jne    800d58 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d78:	c9                   	leave  
  800d79:	c3                   	ret    

00800d7a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 04             	sub    $0x4,%esp
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d86:	eb 0d                	jmp    800d95 <strfind+0x1b>
		if (*s == c)
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d90:	74 0e                	je     800da0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d92:	ff 45 08             	incl   0x8(%ebp)
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 ea                	jne    800d88 <strfind+0xe>
  800d9e:	eb 01                	jmp    800da1 <strfind+0x27>
		if (*s == c)
			break;
  800da0:	90                   	nop
	return (char *) s;
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da4:	c9                   	leave  
  800da5:	c3                   	ret    

00800da6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800db2:	8b 45 10             	mov    0x10(%ebp),%eax
  800db5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800db8:	eb 0e                	jmp    800dc8 <memset+0x22>
		*p++ = c;
  800dba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbd:	8d 50 01             	lea    0x1(%eax),%edx
  800dc0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dc8:	ff 4d f8             	decl   -0x8(%ebp)
  800dcb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dcf:	79 e9                	jns    800dba <memset+0x14>
		*p++ = c;

	return v;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd4:	c9                   	leave  
  800dd5:	c3                   	ret    

00800dd6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800de8:	eb 16                	jmp    800e00 <memcpy+0x2a>
		*d++ = *s++;
  800dea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ded:	8d 50 01             	lea    0x1(%eax),%edx
  800df0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dfc:	8a 12                	mov    (%edx),%dl
  800dfe:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e00:	8b 45 10             	mov    0x10(%ebp),%eax
  800e03:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e06:	89 55 10             	mov    %edx,0x10(%ebp)
  800e09:	85 c0                	test   %eax,%eax
  800e0b:	75 dd                	jne    800dea <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e10:	c9                   	leave  
  800e11:	c3                   	ret    

00800e12 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e27:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e2a:	73 50                	jae    800e7c <memmove+0x6a>
  800e2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e32:	01 d0                	add    %edx,%eax
  800e34:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e37:	76 43                	jbe    800e7c <memmove+0x6a>
		s += n;
  800e39:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e42:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e45:	eb 10                	jmp    800e57 <memmove+0x45>
			*--d = *--s;
  800e47:	ff 4d f8             	decl   -0x8(%ebp)
  800e4a:	ff 4d fc             	decl   -0x4(%ebp)
  800e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e50:	8a 10                	mov    (%eax),%dl
  800e52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e55:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e57:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e60:	85 c0                	test   %eax,%eax
  800e62:	75 e3                	jne    800e47 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e64:	eb 23                	jmp    800e89 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e69:	8d 50 01             	lea    0x1(%eax),%edx
  800e6c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e72:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e75:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e78:	8a 12                	mov    (%edx),%dl
  800e7a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e82:	89 55 10             	mov    %edx,0x10(%ebp)
  800e85:	85 c0                	test   %eax,%eax
  800e87:	75 dd                	jne    800e66 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ea0:	eb 2a                	jmp    800ecc <memcmp+0x3e>
		if (*s1 != *s2)
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	8a 10                	mov    (%eax),%dl
  800ea7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	38 c2                	cmp    %al,%dl
  800eae:	74 16                	je     800ec6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	0f b6 d0             	movzbl %al,%edx
  800eb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	0f b6 c0             	movzbl %al,%eax
  800ec0:	29 c2                	sub    %eax,%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	eb 18                	jmp    800ede <memcmp+0x50>
		s1++, s2++;
  800ec6:	ff 45 fc             	incl   -0x4(%ebp)
  800ec9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed5:	85 c0                	test   %eax,%eax
  800ed7:	75 c9                	jne    800ea2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ed9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ede:	c9                   	leave  
  800edf:	c3                   	ret    

00800ee0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	8b 45 10             	mov    0x10(%ebp),%eax
  800eec:	01 d0                	add    %edx,%eax
  800eee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ef1:	eb 15                	jmp    800f08 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	0f b6 d0             	movzbl %al,%edx
  800efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efe:	0f b6 c0             	movzbl %al,%eax
  800f01:	39 c2                	cmp    %eax,%edx
  800f03:	74 0d                	je     800f12 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f05:	ff 45 08             	incl   0x8(%ebp)
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f0e:	72 e3                	jb     800ef3 <memfind+0x13>
  800f10:	eb 01                	jmp    800f13 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f12:	90                   	nop
	return (void *) s;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f25:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f2c:	eb 03                	jmp    800f31 <strtol+0x19>
		s++;
  800f2e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	3c 20                	cmp    $0x20,%al
  800f38:	74 f4                	je     800f2e <strtol+0x16>
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	3c 09                	cmp    $0x9,%al
  800f41:	74 eb                	je     800f2e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	3c 2b                	cmp    $0x2b,%al
  800f4a:	75 05                	jne    800f51 <strtol+0x39>
		s++;
  800f4c:	ff 45 08             	incl   0x8(%ebp)
  800f4f:	eb 13                	jmp    800f64 <strtol+0x4c>
	else if (*s == '-')
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	3c 2d                	cmp    $0x2d,%al
  800f58:	75 0a                	jne    800f64 <strtol+0x4c>
		s++, neg = 1;
  800f5a:	ff 45 08             	incl   0x8(%ebp)
  800f5d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f68:	74 06                	je     800f70 <strtol+0x58>
  800f6a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f6e:	75 20                	jne    800f90 <strtol+0x78>
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	3c 30                	cmp    $0x30,%al
  800f77:	75 17                	jne    800f90 <strtol+0x78>
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	40                   	inc    %eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	3c 78                	cmp    $0x78,%al
  800f81:	75 0d                	jne    800f90 <strtol+0x78>
		s += 2, base = 16;
  800f83:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f87:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f8e:	eb 28                	jmp    800fb8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f94:	75 15                	jne    800fab <strtol+0x93>
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	3c 30                	cmp    $0x30,%al
  800f9d:	75 0c                	jne    800fab <strtol+0x93>
		s++, base = 8;
  800f9f:	ff 45 08             	incl   0x8(%ebp)
  800fa2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fa9:	eb 0d                	jmp    800fb8 <strtol+0xa0>
	else if (base == 0)
  800fab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800faf:	75 07                	jne    800fb8 <strtol+0xa0>
		base = 10;
  800fb1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	3c 2f                	cmp    $0x2f,%al
  800fbf:	7e 19                	jle    800fda <strtol+0xc2>
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	3c 39                	cmp    $0x39,%al
  800fc8:	7f 10                	jg     800fda <strtol+0xc2>
			dig = *s - '0';
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	0f be c0             	movsbl %al,%eax
  800fd2:	83 e8 30             	sub    $0x30,%eax
  800fd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd8:	eb 42                	jmp    80101c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	3c 60                	cmp    $0x60,%al
  800fe1:	7e 19                	jle    800ffc <strtol+0xe4>
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	3c 7a                	cmp    $0x7a,%al
  800fea:	7f 10                	jg     800ffc <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	0f be c0             	movsbl %al,%eax
  800ff4:	83 e8 57             	sub    $0x57,%eax
  800ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ffa:	eb 20                	jmp    80101c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 40                	cmp    $0x40,%al
  801003:	7e 39                	jle    80103e <strtol+0x126>
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	3c 5a                	cmp    $0x5a,%al
  80100c:	7f 30                	jg     80103e <strtol+0x126>
			dig = *s - 'A' + 10;
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	0f be c0             	movsbl %al,%eax
  801016:	83 e8 37             	sub    $0x37,%eax
  801019:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80101c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801022:	7d 19                	jge    80103d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801024:	ff 45 08             	incl   0x8(%ebp)
  801027:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80102e:	89 c2                	mov    %eax,%edx
  801030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801033:	01 d0                	add    %edx,%eax
  801035:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801038:	e9 7b ff ff ff       	jmp    800fb8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80103d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80103e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801042:	74 08                	je     80104c <strtol+0x134>
		*endptr = (char *) s;
  801044:	8b 45 0c             	mov    0xc(%ebp),%eax
  801047:	8b 55 08             	mov    0x8(%ebp),%edx
  80104a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80104c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801050:	74 07                	je     801059 <strtol+0x141>
  801052:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801055:	f7 d8                	neg    %eax
  801057:	eb 03                	jmp    80105c <strtol+0x144>
  801059:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80105c:	c9                   	leave  
  80105d:	c3                   	ret    

0080105e <ltostr>:

void
ltostr(long value, char *str)
{
  80105e:	55                   	push   %ebp
  80105f:	89 e5                	mov    %esp,%ebp
  801061:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801064:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80106b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801072:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801076:	79 13                	jns    80108b <ltostr+0x2d>
	{
		neg = 1;
  801078:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80107f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801082:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801085:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801088:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801093:	99                   	cltd   
  801094:	f7 f9                	idiv   %ecx
  801096:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801099:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109c:	8d 50 01             	lea    0x1(%eax),%edx
  80109f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a2:	89 c2                	mov    %eax,%edx
  8010a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a7:	01 d0                	add    %edx,%eax
  8010a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010ac:	83 c2 30             	add    $0x30,%edx
  8010af:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010b9:	f7 e9                	imul   %ecx
  8010bb:	c1 fa 02             	sar    $0x2,%edx
  8010be:	89 c8                	mov    %ecx,%eax
  8010c0:	c1 f8 1f             	sar    $0x1f,%eax
  8010c3:	29 c2                	sub    %eax,%edx
  8010c5:	89 d0                	mov    %edx,%eax
  8010c7:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010ce:	75 bb                	jne    80108b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010da:	48                   	dec    %eax
  8010db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010de:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010e2:	74 3d                	je     801121 <ltostr+0xc3>
		start = 1 ;
  8010e4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010eb:	eb 34                	jmp    801121 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	8a 00                	mov    (%eax),%al
  8010f7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801100:	01 c2                	add    %eax,%edx
  801102:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801105:	8b 45 0c             	mov    0xc(%ebp),%eax
  801108:	01 c8                	add    %ecx,%eax
  80110a:	8a 00                	mov    (%eax),%al
  80110c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80110e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801111:	8b 45 0c             	mov    0xc(%ebp),%eax
  801114:	01 c2                	add    %eax,%edx
  801116:	8a 45 eb             	mov    -0x15(%ebp),%al
  801119:	88 02                	mov    %al,(%edx)
		start++ ;
  80111b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80111e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801124:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801127:	7c c4                	jl     8010ed <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801129:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112f:	01 d0                	add    %edx,%eax
  801131:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801134:	90                   	nop
  801135:	c9                   	leave  
  801136:	c3                   	ret    

00801137 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80113d:	ff 75 08             	pushl  0x8(%ebp)
  801140:	e8 73 fa ff ff       	call   800bb8 <strlen>
  801145:	83 c4 04             	add    $0x4,%esp
  801148:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80114b:	ff 75 0c             	pushl  0xc(%ebp)
  80114e:	e8 65 fa ff ff       	call   800bb8 <strlen>
  801153:	83 c4 04             	add    $0x4,%esp
  801156:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801159:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801160:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801167:	eb 17                	jmp    801180 <strcconcat+0x49>
		final[s] = str1[s] ;
  801169:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80116c:	8b 45 10             	mov    0x10(%ebp),%eax
  80116f:	01 c2                	add    %eax,%edx
  801171:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	01 c8                	add    %ecx,%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80117d:	ff 45 fc             	incl   -0x4(%ebp)
  801180:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801183:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801186:	7c e1                	jl     801169 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801188:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80118f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801196:	eb 1f                	jmp    8011b7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801198:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80119b:	8d 50 01             	lea    0x1(%eax),%edx
  80119e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011a1:	89 c2                	mov    %eax,%edx
  8011a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a6:	01 c2                	add    %eax,%edx
  8011a8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ae:	01 c8                	add    %ecx,%eax
  8011b0:	8a 00                	mov    (%eax),%al
  8011b2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011b4:	ff 45 f8             	incl   -0x8(%ebp)
  8011b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011bd:	7c d9                	jl     801198 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c5:	01 d0                	add    %edx,%eax
  8011c7:	c6 00 00             	movb   $0x0,(%eax)
}
  8011ca:	90                   	nop
  8011cb:	c9                   	leave  
  8011cc:	c3                   	ret    

008011cd <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011dc:	8b 00                	mov    (%eax),%eax
  8011de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e8:	01 d0                	add    %edx,%eax
  8011ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011f0:	eb 0c                	jmp    8011fe <strsplit+0x31>
			*string++ = 0;
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	8d 50 01             	lea    0x1(%eax),%edx
  8011f8:	89 55 08             	mov    %edx,0x8(%ebp)
  8011fb:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	8a 00                	mov    (%eax),%al
  801203:	84 c0                	test   %al,%al
  801205:	74 18                	je     80121f <strsplit+0x52>
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	0f be c0             	movsbl %al,%eax
  80120f:	50                   	push   %eax
  801210:	ff 75 0c             	pushl  0xc(%ebp)
  801213:	e8 32 fb ff ff       	call   800d4a <strchr>
  801218:	83 c4 08             	add    $0x8,%esp
  80121b:	85 c0                	test   %eax,%eax
  80121d:	75 d3                	jne    8011f2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	8a 00                	mov    (%eax),%al
  801224:	84 c0                	test   %al,%al
  801226:	74 5a                	je     801282 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801228:	8b 45 14             	mov    0x14(%ebp),%eax
  80122b:	8b 00                	mov    (%eax),%eax
  80122d:	83 f8 0f             	cmp    $0xf,%eax
  801230:	75 07                	jne    801239 <strsplit+0x6c>
		{
			return 0;
  801232:	b8 00 00 00 00       	mov    $0x0,%eax
  801237:	eb 66                	jmp    80129f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801239:	8b 45 14             	mov    0x14(%ebp),%eax
  80123c:	8b 00                	mov    (%eax),%eax
  80123e:	8d 48 01             	lea    0x1(%eax),%ecx
  801241:	8b 55 14             	mov    0x14(%ebp),%edx
  801244:	89 0a                	mov    %ecx,(%edx)
  801246:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80124d:	8b 45 10             	mov    0x10(%ebp),%eax
  801250:	01 c2                	add    %eax,%edx
  801252:	8b 45 08             	mov    0x8(%ebp),%eax
  801255:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801257:	eb 03                	jmp    80125c <strsplit+0x8f>
			string++;
  801259:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	8a 00                	mov    (%eax),%al
  801261:	84 c0                	test   %al,%al
  801263:	74 8b                	je     8011f0 <strsplit+0x23>
  801265:	8b 45 08             	mov    0x8(%ebp),%eax
  801268:	8a 00                	mov    (%eax),%al
  80126a:	0f be c0             	movsbl %al,%eax
  80126d:	50                   	push   %eax
  80126e:	ff 75 0c             	pushl  0xc(%ebp)
  801271:	e8 d4 fa ff ff       	call   800d4a <strchr>
  801276:	83 c4 08             	add    $0x8,%esp
  801279:	85 c0                	test   %eax,%eax
  80127b:	74 dc                	je     801259 <strsplit+0x8c>
			string++;
	}
  80127d:	e9 6e ff ff ff       	jmp    8011f0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801282:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801283:	8b 45 14             	mov    0x14(%ebp),%eax
  801286:	8b 00                	mov    (%eax),%eax
  801288:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80128f:	8b 45 10             	mov    0x10(%ebp),%eax
  801292:	01 d0                	add    %edx,%eax
  801294:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80129a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80129f:	c9                   	leave  
  8012a0:	c3                   	ret    

008012a1 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
  8012a4:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8012a7:	83 ec 04             	sub    $0x4,%esp
  8012aa:	68 48 42 80 00       	push   $0x804248
  8012af:	68 3f 01 00 00       	push   $0x13f
  8012b4:	68 6a 42 80 00       	push   $0x80426a
  8012b9:	e8 a9 ef ff ff       	call   800267 <_panic>

008012be <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8012be:	55                   	push   %ebp
  8012bf:	89 e5                	mov    %esp,%ebp
  8012c1:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8012c4:	83 ec 0c             	sub    $0xc,%esp
  8012c7:	ff 75 08             	pushl  0x8(%ebp)
  8012ca:	e8 8d 0a 00 00       	call   801d5c <sys_sbrk>
  8012cf:	83 c4 10             	add    $0x10,%esp
}
  8012d2:	c9                   	leave  
  8012d3:	c3                   	ret    

008012d4 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
  8012d7:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8012da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012de:	75 0a                	jne    8012ea <malloc+0x16>
  8012e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e5:	e9 07 02 00 00       	jmp    8014f1 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  8012ea:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8012f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012f7:	01 d0                	add    %edx,%eax
  8012f9:	48                   	dec    %eax
  8012fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8012fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801300:	ba 00 00 00 00       	mov    $0x0,%edx
  801305:	f7 75 dc             	divl   -0x24(%ebp)
  801308:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80130b:	29 d0                	sub    %edx,%eax
  80130d:	c1 e8 0c             	shr    $0xc,%eax
  801310:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801313:	a1 20 50 80 00       	mov    0x805020,%eax
  801318:	8b 40 78             	mov    0x78(%eax),%eax
  80131b:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801320:	29 c2                	sub    %eax,%edx
  801322:	89 d0                	mov    %edx,%eax
  801324:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801327:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80132a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80132f:	c1 e8 0c             	shr    $0xc,%eax
  801332:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801335:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80133c:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801343:	77 42                	ja     801387 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801345:	e8 96 08 00 00       	call   801be0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80134a:	85 c0                	test   %eax,%eax
  80134c:	74 16                	je     801364 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80134e:	83 ec 0c             	sub    $0xc,%esp
  801351:	ff 75 08             	pushl  0x8(%ebp)
  801354:	e8 d6 0d 00 00       	call   80212f <alloc_block_FF>
  801359:	83 c4 10             	add    $0x10,%esp
  80135c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80135f:	e9 8a 01 00 00       	jmp    8014ee <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801364:	e8 a8 08 00 00       	call   801c11 <sys_isUHeapPlacementStrategyBESTFIT>
  801369:	85 c0                	test   %eax,%eax
  80136b:	0f 84 7d 01 00 00    	je     8014ee <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801371:	83 ec 0c             	sub    $0xc,%esp
  801374:	ff 75 08             	pushl  0x8(%ebp)
  801377:	e8 6f 12 00 00       	call   8025eb <alloc_block_BF>
  80137c:	83 c4 10             	add    $0x10,%esp
  80137f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801382:	e9 67 01 00 00       	jmp    8014ee <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801387:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80138a:	48                   	dec    %eax
  80138b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80138e:	0f 86 53 01 00 00    	jbe    8014e7 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801394:	a1 20 50 80 00       	mov    0x805020,%eax
  801399:	8b 40 78             	mov    0x78(%eax),%eax
  80139c:	05 00 10 00 00       	add    $0x1000,%eax
  8013a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  8013a4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  8013ab:	e9 de 00 00 00       	jmp    80148e <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  8013b0:	a1 20 50 80 00       	mov    0x805020,%eax
  8013b5:	8b 40 78             	mov    0x78(%eax),%eax
  8013b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013bb:	29 c2                	sub    %eax,%edx
  8013bd:	89 d0                	mov    %edx,%eax
  8013bf:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013c4:	c1 e8 0c             	shr    $0xc,%eax
  8013c7:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8013ce:	85 c0                	test   %eax,%eax
  8013d0:	0f 85 ab 00 00 00    	jne    801481 <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  8013d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d9:	05 00 10 00 00       	add    $0x1000,%eax
  8013de:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  8013e1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  8013e8:	eb 47                	jmp    801431 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  8013ea:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8013f1:	76 0a                	jbe    8013fd <malloc+0x129>
  8013f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f8:	e9 f4 00 00 00       	jmp    8014f1 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  8013fd:	a1 20 50 80 00       	mov    0x805020,%eax
  801402:	8b 40 78             	mov    0x78(%eax),%eax
  801405:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801408:	29 c2                	sub    %eax,%edx
  80140a:	89 d0                	mov    %edx,%eax
  80140c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801411:	c1 e8 0c             	shr    $0xc,%eax
  801414:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  80141b:	85 c0                	test   %eax,%eax
  80141d:	74 08                	je     801427 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  80141f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801422:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801425:	eb 5a                	jmp    801481 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801427:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  80142e:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801431:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801434:	48                   	dec    %eax
  801435:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801438:	77 b0                	ja     8013ea <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  80143a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801441:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801448:	eb 2f                	jmp    801479 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  80144a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80144d:	c1 e0 0c             	shl    $0xc,%eax
  801450:	89 c2                	mov    %eax,%edx
  801452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801455:	01 c2                	add    %eax,%edx
  801457:	a1 20 50 80 00       	mov    0x805020,%eax
  80145c:	8b 40 78             	mov    0x78(%eax),%eax
  80145f:	29 c2                	sub    %eax,%edx
  801461:	89 d0                	mov    %edx,%eax
  801463:	2d 00 10 00 00       	sub    $0x1000,%eax
  801468:	c1 e8 0c             	shr    $0xc,%eax
  80146b:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
  801472:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801476:	ff 45 e0             	incl   -0x20(%ebp)
  801479:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80147f:	72 c9                	jb     80144a <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801481:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801485:	75 16                	jne    80149d <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801487:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  80148e:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801495:	0f 86 15 ff ff ff    	jbe    8013b0 <malloc+0xdc>
  80149b:	eb 01                	jmp    80149e <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  80149d:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  80149e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014a2:	75 07                	jne    8014ab <malloc+0x1d7>
  8014a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a9:	eb 46                	jmp    8014f1 <malloc+0x21d>
		ptr = (void*)i;
  8014ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  8014b1:	a1 20 50 80 00       	mov    0x805020,%eax
  8014b6:	8b 40 78             	mov    0x78(%eax),%eax
  8014b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014bc:	29 c2                	sub    %eax,%edx
  8014be:	89 d0                	mov    %edx,%eax
  8014c0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014c5:	c1 e8 0c             	shr    $0xc,%eax
  8014c8:	89 c2                	mov    %eax,%edx
  8014ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8014cd:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8014d4:	83 ec 08             	sub    $0x8,%esp
  8014d7:	ff 75 08             	pushl  0x8(%ebp)
  8014da:	ff 75 f0             	pushl  -0x10(%ebp)
  8014dd:	e8 b1 08 00 00       	call   801d93 <sys_allocate_user_mem>
  8014e2:	83 c4 10             	add    $0x10,%esp
  8014e5:	eb 07                	jmp    8014ee <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  8014e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ec:	eb 03                	jmp    8014f1 <malloc+0x21d>
	}
	return ptr;
  8014ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    

008014f3 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
  8014f6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  8014f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8014fe:	8b 40 78             	mov    0x78(%eax),%eax
  801501:	05 00 10 00 00       	add    $0x1000,%eax
  801506:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801509:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801510:	a1 20 50 80 00       	mov    0x805020,%eax
  801515:	8b 50 78             	mov    0x78(%eax),%edx
  801518:	8b 45 08             	mov    0x8(%ebp),%eax
  80151b:	39 c2                	cmp    %eax,%edx
  80151d:	76 24                	jbe    801543 <free+0x50>
		size = get_block_size(va);
  80151f:	83 ec 0c             	sub    $0xc,%esp
  801522:	ff 75 08             	pushl  0x8(%ebp)
  801525:	e8 85 08 00 00       	call   801daf <get_block_size>
  80152a:	83 c4 10             	add    $0x10,%esp
  80152d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801530:	83 ec 0c             	sub    $0xc,%esp
  801533:	ff 75 08             	pushl  0x8(%ebp)
  801536:	e8 b8 1a 00 00       	call   802ff3 <free_block>
  80153b:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  80153e:	e9 ac 00 00 00       	jmp    8015ef <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801549:	0f 82 89 00 00 00    	jb     8015d8 <free+0xe5>
  80154f:	8b 45 08             	mov    0x8(%ebp),%eax
  801552:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801557:	77 7f                	ja     8015d8 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801559:	8b 55 08             	mov    0x8(%ebp),%edx
  80155c:	a1 20 50 80 00       	mov    0x805020,%eax
  801561:	8b 40 78             	mov    0x78(%eax),%eax
  801564:	29 c2                	sub    %eax,%edx
  801566:	89 d0                	mov    %edx,%eax
  801568:	2d 00 10 00 00       	sub    $0x1000,%eax
  80156d:	c1 e8 0c             	shr    $0xc,%eax
  801570:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801577:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  80157a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80157d:	c1 e0 0c             	shl    $0xc,%eax
  801580:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801583:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80158a:	eb 2f                	jmp    8015bb <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  80158c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80158f:	c1 e0 0c             	shl    $0xc,%eax
  801592:	89 c2                	mov    %eax,%edx
  801594:	8b 45 08             	mov    0x8(%ebp),%eax
  801597:	01 c2                	add    %eax,%edx
  801599:	a1 20 50 80 00       	mov    0x805020,%eax
  80159e:	8b 40 78             	mov    0x78(%eax),%eax
  8015a1:	29 c2                	sub    %eax,%edx
  8015a3:	89 d0                	mov    %edx,%eax
  8015a5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015aa:	c1 e8 0c             	shr    $0xc,%eax
  8015ad:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
  8015b4:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8015b8:	ff 45 f4             	incl   -0xc(%ebp)
  8015bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015be:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8015c1:	72 c9                	jb     80158c <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	83 ec 08             	sub    $0x8,%esp
  8015c9:	ff 75 ec             	pushl  -0x14(%ebp)
  8015cc:	50                   	push   %eax
  8015cd:	e8 a5 07 00 00       	call   801d77 <sys_free_user_mem>
  8015d2:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8015d5:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  8015d6:	eb 17                	jmp    8015ef <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  8015d8:	83 ec 04             	sub    $0x4,%esp
  8015db:	68 78 42 80 00       	push   $0x804278
  8015e0:	68 84 00 00 00       	push   $0x84
  8015e5:	68 a2 42 80 00       	push   $0x8042a2
  8015ea:	e8 78 ec ff ff       	call   800267 <_panic>
	}
}
  8015ef:	c9                   	leave  
  8015f0:	c3                   	ret    

008015f1 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
  8015f4:	83 ec 28             	sub    $0x28,%esp
  8015f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fa:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8015fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801601:	75 07                	jne    80160a <smalloc+0x19>
  801603:	b8 00 00 00 00       	mov    $0x0,%eax
  801608:	eb 64                	jmp    80166e <smalloc+0x7d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  80160a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801610:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801617:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80161a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161d:	39 d0                	cmp    %edx,%eax
  80161f:	73 02                	jae    801623 <smalloc+0x32>
  801621:	89 d0                	mov    %edx,%eax
  801623:	83 ec 0c             	sub    $0xc,%esp
  801626:	50                   	push   %eax
  801627:	e8 a8 fc ff ff       	call   8012d4 <malloc>
  80162c:	83 c4 10             	add    $0x10,%esp
  80162f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801632:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801636:	75 07                	jne    80163f <smalloc+0x4e>
  801638:	b8 00 00 00 00       	mov    $0x0,%eax
  80163d:	eb 2f                	jmp    80166e <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80163f:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801643:	ff 75 ec             	pushl  -0x14(%ebp)
  801646:	50                   	push   %eax
  801647:	ff 75 0c             	pushl  0xc(%ebp)
  80164a:	ff 75 08             	pushl  0x8(%ebp)
  80164d:	e8 2c 03 00 00       	call   80197e <sys_createSharedObject>
  801652:	83 c4 10             	add    $0x10,%esp
  801655:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801658:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80165c:	74 06                	je     801664 <smalloc+0x73>
  80165e:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801662:	75 07                	jne    80166b <smalloc+0x7a>
  801664:	b8 00 00 00 00       	mov    $0x0,%eax
  801669:	eb 03                	jmp    80166e <smalloc+0x7d>
	 return ptr;
  80166b:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  80166e:	c9                   	leave  
  80166f:	c3                   	ret    

00801670 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801676:	83 ec 08             	sub    $0x8,%esp
  801679:	ff 75 0c             	pushl  0xc(%ebp)
  80167c:	ff 75 08             	pushl  0x8(%ebp)
  80167f:	e8 24 03 00 00       	call   8019a8 <sys_getSizeOfSharedObject>
  801684:	83 c4 10             	add    $0x10,%esp
  801687:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80168a:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80168e:	75 07                	jne    801697 <sget+0x27>
  801690:	b8 00 00 00 00       	mov    $0x0,%eax
  801695:	eb 5c                	jmp    8016f3 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80169d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016aa:	39 d0                	cmp    %edx,%eax
  8016ac:	7d 02                	jge    8016b0 <sget+0x40>
  8016ae:	89 d0                	mov    %edx,%eax
  8016b0:	83 ec 0c             	sub    $0xc,%esp
  8016b3:	50                   	push   %eax
  8016b4:	e8 1b fc ff ff       	call   8012d4 <malloc>
  8016b9:	83 c4 10             	add    $0x10,%esp
  8016bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8016bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016c3:	75 07                	jne    8016cc <sget+0x5c>
  8016c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ca:	eb 27                	jmp    8016f3 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8016cc:	83 ec 04             	sub    $0x4,%esp
  8016cf:	ff 75 e8             	pushl  -0x18(%ebp)
  8016d2:	ff 75 0c             	pushl  0xc(%ebp)
  8016d5:	ff 75 08             	pushl  0x8(%ebp)
  8016d8:	e8 e8 02 00 00       	call   8019c5 <sys_getSharedObject>
  8016dd:	83 c4 10             	add    $0x10,%esp
  8016e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8016e3:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8016e7:	75 07                	jne    8016f0 <sget+0x80>
  8016e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ee:	eb 03                	jmp    8016f3 <sget+0x83>
	return ptr;
  8016f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8016f3:	c9                   	leave  
  8016f4:	c3                   	ret    

008016f5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016fb:	83 ec 04             	sub    $0x4,%esp
  8016fe:	68 b0 42 80 00       	push   $0x8042b0
  801703:	68 c1 00 00 00       	push   $0xc1
  801708:	68 a2 42 80 00       	push   $0x8042a2
  80170d:	e8 55 eb ff ff       	call   800267 <_panic>

00801712 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801718:	83 ec 04             	sub    $0x4,%esp
  80171b:	68 d4 42 80 00       	push   $0x8042d4
  801720:	68 d8 00 00 00       	push   $0xd8
  801725:	68 a2 42 80 00       	push   $0x8042a2
  80172a:	e8 38 eb ff ff       	call   800267 <_panic>

0080172f <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801735:	83 ec 04             	sub    $0x4,%esp
  801738:	68 fa 42 80 00       	push   $0x8042fa
  80173d:	68 e4 00 00 00       	push   $0xe4
  801742:	68 a2 42 80 00       	push   $0x8042a2
  801747:	e8 1b eb ff ff       	call   800267 <_panic>

0080174c <shrink>:

}
void shrink(uint32 newSize)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801752:	83 ec 04             	sub    $0x4,%esp
  801755:	68 fa 42 80 00       	push   $0x8042fa
  80175a:	68 e9 00 00 00       	push   $0xe9
  80175f:	68 a2 42 80 00       	push   $0x8042a2
  801764:	e8 fe ea ff ff       	call   800267 <_panic>

00801769 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80176f:	83 ec 04             	sub    $0x4,%esp
  801772:	68 fa 42 80 00       	push   $0x8042fa
  801777:	68 ee 00 00 00       	push   $0xee
  80177c:	68 a2 42 80 00       	push   $0x8042a2
  801781:	e8 e1 ea ff ff       	call   800267 <_panic>

00801786 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	57                   	push   %edi
  80178a:	56                   	push   %esi
  80178b:	53                   	push   %ebx
  80178c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	8b 55 0c             	mov    0xc(%ebp),%edx
  801795:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801798:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80179b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80179e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017a1:	cd 30                	int    $0x30
  8017a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017a9:	83 c4 10             	add    $0x10,%esp
  8017ac:	5b                   	pop    %ebx
  8017ad:	5e                   	pop    %esi
  8017ae:	5f                   	pop    %edi
  8017af:	5d                   	pop    %ebp
  8017b0:	c3                   	ret    

008017b1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
  8017b4:	83 ec 04             	sub    $0x4,%esp
  8017b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017bd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	52                   	push   %edx
  8017c9:	ff 75 0c             	pushl  0xc(%ebp)
  8017cc:	50                   	push   %eax
  8017cd:	6a 00                	push   $0x0
  8017cf:	e8 b2 ff ff ff       	call   801786 <syscall>
  8017d4:	83 c4 18             	add    $0x18,%esp
}
  8017d7:	90                   	nop
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    

008017da <sys_cgetc>:

int
sys_cgetc(void)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 02                	push   $0x2
  8017e9:	e8 98 ff ff ff       	call   801786 <syscall>
  8017ee:	83 c4 18             	add    $0x18,%esp
}
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 03                	push   $0x3
  801802:	e8 7f ff ff ff       	call   801786 <syscall>
  801807:	83 c4 18             	add    $0x18,%esp
}
  80180a:	90                   	nop
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 04                	push   $0x4
  80181c:	e8 65 ff ff ff       	call   801786 <syscall>
  801821:	83 c4 18             	add    $0x18,%esp
}
  801824:	90                   	nop
  801825:	c9                   	leave  
  801826:	c3                   	ret    

00801827 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80182a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182d:	8b 45 08             	mov    0x8(%ebp),%eax
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	52                   	push   %edx
  801837:	50                   	push   %eax
  801838:	6a 08                	push   $0x8
  80183a:	e8 47 ff ff ff       	call   801786 <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	56                   	push   %esi
  801848:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801849:	8b 75 18             	mov    0x18(%ebp),%esi
  80184c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80184f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801852:	8b 55 0c             	mov    0xc(%ebp),%edx
  801855:	8b 45 08             	mov    0x8(%ebp),%eax
  801858:	56                   	push   %esi
  801859:	53                   	push   %ebx
  80185a:	51                   	push   %ecx
  80185b:	52                   	push   %edx
  80185c:	50                   	push   %eax
  80185d:	6a 09                	push   $0x9
  80185f:	e8 22 ff ff ff       	call   801786 <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
}
  801867:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80186a:	5b                   	pop    %ebx
  80186b:	5e                   	pop    %esi
  80186c:	5d                   	pop    %ebp
  80186d:	c3                   	ret    

0080186e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801871:	8b 55 0c             	mov    0xc(%ebp),%edx
  801874:	8b 45 08             	mov    0x8(%ebp),%eax
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	52                   	push   %edx
  80187e:	50                   	push   %eax
  80187f:	6a 0a                	push   $0xa
  801881:	e8 00 ff ff ff       	call   801786 <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	ff 75 0c             	pushl  0xc(%ebp)
  801897:	ff 75 08             	pushl  0x8(%ebp)
  80189a:	6a 0b                	push   $0xb
  80189c:	e8 e5 fe ff ff       	call   801786 <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 0c                	push   $0xc
  8018b5:	e8 cc fe ff ff       	call   801786 <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 0d                	push   $0xd
  8018ce:	e8 b3 fe ff ff       	call   801786 <syscall>
  8018d3:	83 c4 18             	add    $0x18,%esp
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 0e                	push   $0xe
  8018e7:	e8 9a fe ff ff       	call   801786 <syscall>
  8018ec:	83 c4 18             	add    $0x18,%esp
}
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 0f                	push   $0xf
  801900:	e8 81 fe ff ff       	call   801786 <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	ff 75 08             	pushl  0x8(%ebp)
  801918:	6a 10                	push   $0x10
  80191a:	e8 67 fe ff ff       	call   801786 <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
}
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 11                	push   $0x11
  801933:	e8 4e fe ff ff       	call   801786 <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	90                   	nop
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_cputc>:

void
sys_cputc(const char c)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	83 ec 04             	sub    $0x4,%esp
  801944:	8b 45 08             	mov    0x8(%ebp),%eax
  801947:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80194a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	50                   	push   %eax
  801957:	6a 01                	push   $0x1
  801959:	e8 28 fe ff ff       	call   801786 <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
}
  801961:	90                   	nop
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 14                	push   $0x14
  801973:	e8 0e fe ff ff       	call   801786 <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
}
  80197b:	90                   	nop
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
  801981:	83 ec 04             	sub    $0x4,%esp
  801984:	8b 45 10             	mov    0x10(%ebp),%eax
  801987:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80198a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80198d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	6a 00                	push   $0x0
  801996:	51                   	push   %ecx
  801997:	52                   	push   %edx
  801998:	ff 75 0c             	pushl  0xc(%ebp)
  80199b:	50                   	push   %eax
  80199c:	6a 15                	push   $0x15
  80199e:	e8 e3 fd ff ff       	call   801786 <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
}
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	52                   	push   %edx
  8019b8:	50                   	push   %eax
  8019b9:	6a 16                	push   $0x16
  8019bb:	e8 c6 fd ff ff       	call   801786 <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	51                   	push   %ecx
  8019d6:	52                   	push   %edx
  8019d7:	50                   	push   %eax
  8019d8:	6a 17                	push   $0x17
  8019da:	e8 a7 fd ff ff       	call   801786 <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
}
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	52                   	push   %edx
  8019f4:	50                   	push   %eax
  8019f5:	6a 18                	push   $0x18
  8019f7:	e8 8a fd ff ff       	call   801786 <syscall>
  8019fc:	83 c4 18             	add    $0x18,%esp
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a04:	8b 45 08             	mov    0x8(%ebp),%eax
  801a07:	6a 00                	push   $0x0
  801a09:	ff 75 14             	pushl  0x14(%ebp)
  801a0c:	ff 75 10             	pushl  0x10(%ebp)
  801a0f:	ff 75 0c             	pushl  0xc(%ebp)
  801a12:	50                   	push   %eax
  801a13:	6a 19                	push   $0x19
  801a15:	e8 6c fd ff ff       	call   801786 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	50                   	push   %eax
  801a2e:	6a 1a                	push   $0x1a
  801a30:	e8 51 fd ff ff       	call   801786 <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
}
  801a38:	90                   	nop
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	50                   	push   %eax
  801a4a:	6a 1b                	push   $0x1b
  801a4c:	e8 35 fd ff ff       	call   801786 <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 05                	push   $0x5
  801a65:	e8 1c fd ff ff       	call   801786 <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
}
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 06                	push   $0x6
  801a7e:	e8 03 fd ff ff       	call   801786 <syscall>
  801a83:	83 c4 18             	add    $0x18,%esp
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 07                	push   $0x7
  801a97:	e8 ea fc ff ff       	call   801786 <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
}
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <sys_exit_env>:


void sys_exit_env(void)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 1c                	push   $0x1c
  801ab0:	e8 d1 fc ff ff       	call   801786 <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
}
  801ab8:	90                   	nop
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ac1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ac4:	8d 50 04             	lea    0x4(%eax),%edx
  801ac7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	52                   	push   %edx
  801ad1:	50                   	push   %eax
  801ad2:	6a 1d                	push   $0x1d
  801ad4:	e8 ad fc ff ff       	call   801786 <syscall>
  801ad9:	83 c4 18             	add    $0x18,%esp
	return result;
  801adc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801adf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ae2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ae5:	89 01                	mov    %eax,(%ecx)
  801ae7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	c9                   	leave  
  801aee:	c2 04 00             	ret    $0x4

00801af1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	ff 75 10             	pushl  0x10(%ebp)
  801afb:	ff 75 0c             	pushl  0xc(%ebp)
  801afe:	ff 75 08             	pushl  0x8(%ebp)
  801b01:	6a 13                	push   $0x13
  801b03:	e8 7e fc ff ff       	call   801786 <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0b:	90                   	nop
}
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <sys_rcr2>:
uint32 sys_rcr2()
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 1e                	push   $0x1e
  801b1d:	e8 64 fc ff ff       	call   801786 <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
  801b2a:	83 ec 04             	sub    $0x4,%esp
  801b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b30:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b33:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	50                   	push   %eax
  801b40:	6a 1f                	push   $0x1f
  801b42:	e8 3f fc ff ff       	call   801786 <syscall>
  801b47:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4a:	90                   	nop
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <rsttst>:
void rsttst()
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 21                	push   $0x21
  801b5c:	e8 25 fc ff ff       	call   801786 <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
	return ;
  801b64:	90                   	nop
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	83 ec 04             	sub    $0x4,%esp
  801b6d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b70:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b73:	8b 55 18             	mov    0x18(%ebp),%edx
  801b76:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b7a:	52                   	push   %edx
  801b7b:	50                   	push   %eax
  801b7c:	ff 75 10             	pushl  0x10(%ebp)
  801b7f:	ff 75 0c             	pushl  0xc(%ebp)
  801b82:	ff 75 08             	pushl  0x8(%ebp)
  801b85:	6a 20                	push   $0x20
  801b87:	e8 fa fb ff ff       	call   801786 <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8f:	90                   	nop
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <chktst>:
void chktst(uint32 n)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	ff 75 08             	pushl  0x8(%ebp)
  801ba0:	6a 22                	push   $0x22
  801ba2:	e8 df fb ff ff       	call   801786 <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
	return ;
  801baa:	90                   	nop
}
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <inctst>:

void inctst()
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 23                	push   $0x23
  801bbc:	e8 c5 fb ff ff       	call   801786 <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc4:	90                   	nop
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <gettst>:
uint32 gettst()
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 24                	push   $0x24
  801bd6:	e8 ab fb ff ff       	call   801786 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 25                	push   $0x25
  801bf2:	e8 8f fb ff ff       	call   801786 <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
  801bfa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bfd:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c01:	75 07                	jne    801c0a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c03:	b8 01 00 00 00       	mov    $0x1,%eax
  801c08:	eb 05                	jmp    801c0f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 25                	push   $0x25
  801c23:	e8 5e fb ff ff       	call   801786 <syscall>
  801c28:	83 c4 18             	add    $0x18,%esp
  801c2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c2e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c32:	75 07                	jne    801c3b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c34:	b8 01 00 00 00       	mov    $0x1,%eax
  801c39:	eb 05                	jmp    801c40 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
  801c45:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 25                	push   $0x25
  801c54:	e8 2d fb ff ff       	call   801786 <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
  801c5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c5f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c63:	75 07                	jne    801c6c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c65:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6a:	eb 05                	jmp    801c71 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
  801c76:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 25                	push   $0x25
  801c85:	e8 fc fa ff ff       	call   801786 <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
  801c8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c90:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c94:	75 07                	jne    801c9d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c96:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9b:	eb 05                	jmp    801ca2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca2:	c9                   	leave  
  801ca3:	c3                   	ret    

00801ca4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	ff 75 08             	pushl  0x8(%ebp)
  801cb2:	6a 26                	push   $0x26
  801cb4:	e8 cd fa ff ff       	call   801786 <syscall>
  801cb9:	83 c4 18             	add    $0x18,%esp
	return ;
  801cbc:	90                   	nop
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
  801cc2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cc3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cc6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccf:	6a 00                	push   $0x0
  801cd1:	53                   	push   %ebx
  801cd2:	51                   	push   %ecx
  801cd3:	52                   	push   %edx
  801cd4:	50                   	push   %eax
  801cd5:	6a 27                	push   $0x27
  801cd7:	e8 aa fa ff ff       	call   801786 <syscall>
  801cdc:	83 c4 18             	add    $0x18,%esp
}
  801cdf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ce2:	c9                   	leave  
  801ce3:	c3                   	ret    

00801ce4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ce7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	52                   	push   %edx
  801cf4:	50                   	push   %eax
  801cf5:	6a 28                	push   $0x28
  801cf7:	e8 8a fa ff ff       	call   801786 <syscall>
  801cfc:	83 c4 18             	add    $0x18,%esp
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d04:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	6a 00                	push   $0x0
  801d0f:	51                   	push   %ecx
  801d10:	ff 75 10             	pushl  0x10(%ebp)
  801d13:	52                   	push   %edx
  801d14:	50                   	push   %eax
  801d15:	6a 29                	push   $0x29
  801d17:	e8 6a fa ff ff       	call   801786 <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	ff 75 10             	pushl  0x10(%ebp)
  801d2b:	ff 75 0c             	pushl  0xc(%ebp)
  801d2e:	ff 75 08             	pushl  0x8(%ebp)
  801d31:	6a 12                	push   $0x12
  801d33:	e8 4e fa ff ff       	call   801786 <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3b:	90                   	nop
}
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d44:	8b 45 08             	mov    0x8(%ebp),%eax
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	52                   	push   %edx
  801d4e:	50                   	push   %eax
  801d4f:	6a 2a                	push   $0x2a
  801d51:	e8 30 fa ff ff       	call   801786 <syscall>
  801d56:	83 c4 18             	add    $0x18,%esp
	return;
  801d59:	90                   	nop
}
  801d5a:	c9                   	leave  
  801d5b:	c3                   	ret    

00801d5c <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	50                   	push   %eax
  801d6b:	6a 2b                	push   $0x2b
  801d6d:	e8 14 fa ff ff       	call   801786 <syscall>
  801d72:	83 c4 18             	add    $0x18,%esp
}
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	ff 75 0c             	pushl  0xc(%ebp)
  801d83:	ff 75 08             	pushl  0x8(%ebp)
  801d86:	6a 2c                	push   $0x2c
  801d88:	e8 f9 f9 ff ff       	call   801786 <syscall>
  801d8d:	83 c4 18             	add    $0x18,%esp
	return;
  801d90:	90                   	nop
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	ff 75 0c             	pushl  0xc(%ebp)
  801d9f:	ff 75 08             	pushl  0x8(%ebp)
  801da2:	6a 2d                	push   $0x2d
  801da4:	e8 dd f9 ff ff       	call   801786 <syscall>
  801da9:	83 c4 18             	add    $0x18,%esp
	return;
  801dac:	90                   	nop
}
  801dad:	c9                   	leave  
  801dae:	c3                   	ret    

00801daf <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801db5:	8b 45 08             	mov    0x8(%ebp),%eax
  801db8:	83 e8 04             	sub    $0x4,%eax
  801dbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801dbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dc1:	8b 00                	mov    (%eax),%eax
  801dc3:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801dc6:	c9                   	leave  
  801dc7:	c3                   	ret    

00801dc8 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801dc8:	55                   	push   %ebp
  801dc9:	89 e5                	mov    %esp,%ebp
  801dcb:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801dce:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd1:	83 e8 04             	sub    $0x4,%eax
  801dd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dda:	8b 00                	mov    (%eax),%eax
  801ddc:	83 e0 01             	and    $0x1,%eax
  801ddf:	85 c0                	test   %eax,%eax
  801de1:	0f 94 c0             	sete   %al
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801dec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801df3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df6:	83 f8 02             	cmp    $0x2,%eax
  801df9:	74 2b                	je     801e26 <alloc_block+0x40>
  801dfb:	83 f8 02             	cmp    $0x2,%eax
  801dfe:	7f 07                	jg     801e07 <alloc_block+0x21>
  801e00:	83 f8 01             	cmp    $0x1,%eax
  801e03:	74 0e                	je     801e13 <alloc_block+0x2d>
  801e05:	eb 58                	jmp    801e5f <alloc_block+0x79>
  801e07:	83 f8 03             	cmp    $0x3,%eax
  801e0a:	74 2d                	je     801e39 <alloc_block+0x53>
  801e0c:	83 f8 04             	cmp    $0x4,%eax
  801e0f:	74 3b                	je     801e4c <alloc_block+0x66>
  801e11:	eb 4c                	jmp    801e5f <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801e13:	83 ec 0c             	sub    $0xc,%esp
  801e16:	ff 75 08             	pushl  0x8(%ebp)
  801e19:	e8 11 03 00 00       	call   80212f <alloc_block_FF>
  801e1e:	83 c4 10             	add    $0x10,%esp
  801e21:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e24:	eb 4a                	jmp    801e70 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801e26:	83 ec 0c             	sub    $0xc,%esp
  801e29:	ff 75 08             	pushl  0x8(%ebp)
  801e2c:	e8 fa 19 00 00       	call   80382b <alloc_block_NF>
  801e31:	83 c4 10             	add    $0x10,%esp
  801e34:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e37:	eb 37                	jmp    801e70 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801e39:	83 ec 0c             	sub    $0xc,%esp
  801e3c:	ff 75 08             	pushl  0x8(%ebp)
  801e3f:	e8 a7 07 00 00       	call   8025eb <alloc_block_BF>
  801e44:	83 c4 10             	add    $0x10,%esp
  801e47:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e4a:	eb 24                	jmp    801e70 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801e4c:	83 ec 0c             	sub    $0xc,%esp
  801e4f:	ff 75 08             	pushl  0x8(%ebp)
  801e52:	e8 b7 19 00 00       	call   80380e <alloc_block_WF>
  801e57:	83 c4 10             	add    $0x10,%esp
  801e5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e5d:	eb 11                	jmp    801e70 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801e5f:	83 ec 0c             	sub    $0xc,%esp
  801e62:	68 0c 43 80 00       	push   $0x80430c
  801e67:	e8 b8 e6 ff ff       	call   800524 <cprintf>
  801e6c:	83 c4 10             	add    $0x10,%esp
		break;
  801e6f:	90                   	nop
	}
	return va;
  801e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    

00801e75 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
  801e78:	53                   	push   %ebx
  801e79:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801e7c:	83 ec 0c             	sub    $0xc,%esp
  801e7f:	68 2c 43 80 00       	push   $0x80432c
  801e84:	e8 9b e6 ff ff       	call   800524 <cprintf>
  801e89:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801e8c:	83 ec 0c             	sub    $0xc,%esp
  801e8f:	68 57 43 80 00       	push   $0x804357
  801e94:	e8 8b e6 ff ff       	call   800524 <cprintf>
  801e99:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ea2:	eb 37                	jmp    801edb <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801ea4:	83 ec 0c             	sub    $0xc,%esp
  801ea7:	ff 75 f4             	pushl  -0xc(%ebp)
  801eaa:	e8 19 ff ff ff       	call   801dc8 <is_free_block>
  801eaf:	83 c4 10             	add    $0x10,%esp
  801eb2:	0f be d8             	movsbl %al,%ebx
  801eb5:	83 ec 0c             	sub    $0xc,%esp
  801eb8:	ff 75 f4             	pushl  -0xc(%ebp)
  801ebb:	e8 ef fe ff ff       	call   801daf <get_block_size>
  801ec0:	83 c4 10             	add    $0x10,%esp
  801ec3:	83 ec 04             	sub    $0x4,%esp
  801ec6:	53                   	push   %ebx
  801ec7:	50                   	push   %eax
  801ec8:	68 6f 43 80 00       	push   $0x80436f
  801ecd:	e8 52 e6 ff ff       	call   800524 <cprintf>
  801ed2:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801ed5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801edb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801edf:	74 07                	je     801ee8 <print_blocks_list+0x73>
  801ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee4:	8b 00                	mov    (%eax),%eax
  801ee6:	eb 05                	jmp    801eed <print_blocks_list+0x78>
  801ee8:	b8 00 00 00 00       	mov    $0x0,%eax
  801eed:	89 45 10             	mov    %eax,0x10(%ebp)
  801ef0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef3:	85 c0                	test   %eax,%eax
  801ef5:	75 ad                	jne    801ea4 <print_blocks_list+0x2f>
  801ef7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801efb:	75 a7                	jne    801ea4 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801efd:	83 ec 0c             	sub    $0xc,%esp
  801f00:	68 2c 43 80 00       	push   $0x80432c
  801f05:	e8 1a e6 ff ff       	call   800524 <cprintf>
  801f0a:	83 c4 10             	add    $0x10,%esp

}
  801f0d:	90                   	nop
  801f0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    

00801f13 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
  801f16:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801f19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f1c:	83 e0 01             	and    $0x1,%eax
  801f1f:	85 c0                	test   %eax,%eax
  801f21:	74 03                	je     801f26 <initialize_dynamic_allocator+0x13>
  801f23:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801f26:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f2a:	0f 84 c7 01 00 00    	je     8020f7 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801f30:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801f37:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801f3a:	8b 55 08             	mov    0x8(%ebp),%edx
  801f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f40:	01 d0                	add    %edx,%eax
  801f42:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801f47:	0f 87 ad 01 00 00    	ja     8020fa <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f50:	85 c0                	test   %eax,%eax
  801f52:	0f 89 a5 01 00 00    	jns    8020fd <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801f58:	8b 55 08             	mov    0x8(%ebp),%edx
  801f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f5e:	01 d0                	add    %edx,%eax
  801f60:	83 e8 04             	sub    $0x4,%eax
  801f63:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801f68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801f6f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801f74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f77:	e9 87 00 00 00       	jmp    802003 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801f7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f80:	75 14                	jne    801f96 <initialize_dynamic_allocator+0x83>
  801f82:	83 ec 04             	sub    $0x4,%esp
  801f85:	68 87 43 80 00       	push   $0x804387
  801f8a:	6a 79                	push   $0x79
  801f8c:	68 a5 43 80 00       	push   $0x8043a5
  801f91:	e8 d1 e2 ff ff       	call   800267 <_panic>
  801f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f99:	8b 00                	mov    (%eax),%eax
  801f9b:	85 c0                	test   %eax,%eax
  801f9d:	74 10                	je     801faf <initialize_dynamic_allocator+0x9c>
  801f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa2:	8b 00                	mov    (%eax),%eax
  801fa4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa7:	8b 52 04             	mov    0x4(%edx),%edx
  801faa:	89 50 04             	mov    %edx,0x4(%eax)
  801fad:	eb 0b                	jmp    801fba <initialize_dynamic_allocator+0xa7>
  801faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb2:	8b 40 04             	mov    0x4(%eax),%eax
  801fb5:	a3 30 50 80 00       	mov    %eax,0x805030
  801fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbd:	8b 40 04             	mov    0x4(%eax),%eax
  801fc0:	85 c0                	test   %eax,%eax
  801fc2:	74 0f                	je     801fd3 <initialize_dynamic_allocator+0xc0>
  801fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc7:	8b 40 04             	mov    0x4(%eax),%eax
  801fca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fcd:	8b 12                	mov    (%edx),%edx
  801fcf:	89 10                	mov    %edx,(%eax)
  801fd1:	eb 0a                	jmp    801fdd <initialize_dynamic_allocator+0xca>
  801fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd6:	8b 00                	mov    (%eax),%eax
  801fd8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ff0:	a1 38 50 80 00       	mov    0x805038,%eax
  801ff5:	48                   	dec    %eax
  801ff6:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801ffb:	a1 34 50 80 00       	mov    0x805034,%eax
  802000:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802003:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802007:	74 07                	je     802010 <initialize_dynamic_allocator+0xfd>
  802009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200c:	8b 00                	mov    (%eax),%eax
  80200e:	eb 05                	jmp    802015 <initialize_dynamic_allocator+0x102>
  802010:	b8 00 00 00 00       	mov    $0x0,%eax
  802015:	a3 34 50 80 00       	mov    %eax,0x805034
  80201a:	a1 34 50 80 00       	mov    0x805034,%eax
  80201f:	85 c0                	test   %eax,%eax
  802021:	0f 85 55 ff ff ff    	jne    801f7c <initialize_dynamic_allocator+0x69>
  802027:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80202b:	0f 85 4b ff ff ff    	jne    801f7c <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802031:	8b 45 08             	mov    0x8(%ebp),%eax
  802034:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802037:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802040:	a1 44 50 80 00       	mov    0x805044,%eax
  802045:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80204a:	a1 40 50 80 00       	mov    0x805040,%eax
  80204f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802055:	8b 45 08             	mov    0x8(%ebp),%eax
  802058:	83 c0 08             	add    $0x8,%eax
  80205b:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	83 c0 04             	add    $0x4,%eax
  802064:	8b 55 0c             	mov    0xc(%ebp),%edx
  802067:	83 ea 08             	sub    $0x8,%edx
  80206a:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80206c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206f:	8b 45 08             	mov    0x8(%ebp),%eax
  802072:	01 d0                	add    %edx,%eax
  802074:	83 e8 08             	sub    $0x8,%eax
  802077:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207a:	83 ea 08             	sub    $0x8,%edx
  80207d:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80207f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802082:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802088:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80208b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802092:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802096:	75 17                	jne    8020af <initialize_dynamic_allocator+0x19c>
  802098:	83 ec 04             	sub    $0x4,%esp
  80209b:	68 c0 43 80 00       	push   $0x8043c0
  8020a0:	68 90 00 00 00       	push   $0x90
  8020a5:	68 a5 43 80 00       	push   $0x8043a5
  8020aa:	e8 b8 e1 ff ff       	call   800267 <_panic>
  8020af:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8020b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b8:	89 10                	mov    %edx,(%eax)
  8020ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020bd:	8b 00                	mov    (%eax),%eax
  8020bf:	85 c0                	test   %eax,%eax
  8020c1:	74 0d                	je     8020d0 <initialize_dynamic_allocator+0x1bd>
  8020c3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020cb:	89 50 04             	mov    %edx,0x4(%eax)
  8020ce:	eb 08                	jmp    8020d8 <initialize_dynamic_allocator+0x1c5>
  8020d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d3:	a3 30 50 80 00       	mov    %eax,0x805030
  8020d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020db:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020ea:	a1 38 50 80 00       	mov    0x805038,%eax
  8020ef:	40                   	inc    %eax
  8020f0:	a3 38 50 80 00       	mov    %eax,0x805038
  8020f5:	eb 07                	jmp    8020fe <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8020f7:	90                   	nop
  8020f8:	eb 04                	jmp    8020fe <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8020fa:	90                   	nop
  8020fb:	eb 01                	jmp    8020fe <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8020fd:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802103:	8b 45 10             	mov    0x10(%ebp),%eax
  802106:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	8d 50 fc             	lea    -0x4(%eax),%edx
  80210f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802112:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	83 e8 04             	sub    $0x4,%eax
  80211a:	8b 00                	mov    (%eax),%eax
  80211c:	83 e0 fe             	and    $0xfffffffe,%eax
  80211f:	8d 50 f8             	lea    -0x8(%eax),%edx
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	01 c2                	add    %eax,%edx
  802127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80212a:	89 02                	mov    %eax,(%edx)
}
  80212c:	90                   	nop
  80212d:	5d                   	pop    %ebp
  80212e:	c3                   	ret    

0080212f <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
  802132:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802135:	8b 45 08             	mov    0x8(%ebp),%eax
  802138:	83 e0 01             	and    $0x1,%eax
  80213b:	85 c0                	test   %eax,%eax
  80213d:	74 03                	je     802142 <alloc_block_FF+0x13>
  80213f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802142:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802146:	77 07                	ja     80214f <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802148:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80214f:	a1 24 50 80 00       	mov    0x805024,%eax
  802154:	85 c0                	test   %eax,%eax
  802156:	75 73                	jne    8021cb <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802158:	8b 45 08             	mov    0x8(%ebp),%eax
  80215b:	83 c0 10             	add    $0x10,%eax
  80215e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802161:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802168:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80216b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80216e:	01 d0                	add    %edx,%eax
  802170:	48                   	dec    %eax
  802171:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802174:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802177:	ba 00 00 00 00       	mov    $0x0,%edx
  80217c:	f7 75 ec             	divl   -0x14(%ebp)
  80217f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802182:	29 d0                	sub    %edx,%eax
  802184:	c1 e8 0c             	shr    $0xc,%eax
  802187:	83 ec 0c             	sub    $0xc,%esp
  80218a:	50                   	push   %eax
  80218b:	e8 2e f1 ff ff       	call   8012be <sbrk>
  802190:	83 c4 10             	add    $0x10,%esp
  802193:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802196:	83 ec 0c             	sub    $0xc,%esp
  802199:	6a 00                	push   $0x0
  80219b:	e8 1e f1 ff ff       	call   8012be <sbrk>
  8021a0:	83 c4 10             	add    $0x10,%esp
  8021a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8021a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021a9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8021ac:	83 ec 08             	sub    $0x8,%esp
  8021af:	50                   	push   %eax
  8021b0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021b3:	e8 5b fd ff ff       	call   801f13 <initialize_dynamic_allocator>
  8021b8:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8021bb:	83 ec 0c             	sub    $0xc,%esp
  8021be:	68 e3 43 80 00       	push   $0x8043e3
  8021c3:	e8 5c e3 ff ff       	call   800524 <cprintf>
  8021c8:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8021cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021cf:	75 0a                	jne    8021db <alloc_block_FF+0xac>
	        return NULL;
  8021d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d6:	e9 0e 04 00 00       	jmp    8025e9 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8021db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8021e2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ea:	e9 f3 02 00 00       	jmp    8024e2 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8021ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f2:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8021f5:	83 ec 0c             	sub    $0xc,%esp
  8021f8:	ff 75 bc             	pushl  -0x44(%ebp)
  8021fb:	e8 af fb ff ff       	call   801daf <get_block_size>
  802200:	83 c4 10             	add    $0x10,%esp
  802203:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	83 c0 08             	add    $0x8,%eax
  80220c:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80220f:	0f 87 c5 02 00 00    	ja     8024da <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802215:	8b 45 08             	mov    0x8(%ebp),%eax
  802218:	83 c0 18             	add    $0x18,%eax
  80221b:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80221e:	0f 87 19 02 00 00    	ja     80243d <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802224:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802227:	2b 45 08             	sub    0x8(%ebp),%eax
  80222a:	83 e8 08             	sub    $0x8,%eax
  80222d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802230:	8b 45 08             	mov    0x8(%ebp),%eax
  802233:	8d 50 08             	lea    0x8(%eax),%edx
  802236:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802239:	01 d0                	add    %edx,%eax
  80223b:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80223e:	8b 45 08             	mov    0x8(%ebp),%eax
  802241:	83 c0 08             	add    $0x8,%eax
  802244:	83 ec 04             	sub    $0x4,%esp
  802247:	6a 01                	push   $0x1
  802249:	50                   	push   %eax
  80224a:	ff 75 bc             	pushl  -0x44(%ebp)
  80224d:	e8 ae fe ff ff       	call   802100 <set_block_data>
  802252:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802258:	8b 40 04             	mov    0x4(%eax),%eax
  80225b:	85 c0                	test   %eax,%eax
  80225d:	75 68                	jne    8022c7 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80225f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802263:	75 17                	jne    80227c <alloc_block_FF+0x14d>
  802265:	83 ec 04             	sub    $0x4,%esp
  802268:	68 c0 43 80 00       	push   $0x8043c0
  80226d:	68 d7 00 00 00       	push   $0xd7
  802272:	68 a5 43 80 00       	push   $0x8043a5
  802277:	e8 eb df ff ff       	call   800267 <_panic>
  80227c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802282:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802285:	89 10                	mov    %edx,(%eax)
  802287:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80228a:	8b 00                	mov    (%eax),%eax
  80228c:	85 c0                	test   %eax,%eax
  80228e:	74 0d                	je     80229d <alloc_block_FF+0x16e>
  802290:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802295:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802298:	89 50 04             	mov    %edx,0x4(%eax)
  80229b:	eb 08                	jmp    8022a5 <alloc_block_FF+0x176>
  80229d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022a0:	a3 30 50 80 00       	mov    %eax,0x805030
  8022a5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022a8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022ad:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022b7:	a1 38 50 80 00       	mov    0x805038,%eax
  8022bc:	40                   	inc    %eax
  8022bd:	a3 38 50 80 00       	mov    %eax,0x805038
  8022c2:	e9 dc 00 00 00       	jmp    8023a3 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8022c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ca:	8b 00                	mov    (%eax),%eax
  8022cc:	85 c0                	test   %eax,%eax
  8022ce:	75 65                	jne    802335 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8022d0:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022d4:	75 17                	jne    8022ed <alloc_block_FF+0x1be>
  8022d6:	83 ec 04             	sub    $0x4,%esp
  8022d9:	68 f4 43 80 00       	push   $0x8043f4
  8022de:	68 db 00 00 00       	push   $0xdb
  8022e3:	68 a5 43 80 00       	push   $0x8043a5
  8022e8:	e8 7a df ff ff       	call   800267 <_panic>
  8022ed:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8022f3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022f6:	89 50 04             	mov    %edx,0x4(%eax)
  8022f9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022fc:	8b 40 04             	mov    0x4(%eax),%eax
  8022ff:	85 c0                	test   %eax,%eax
  802301:	74 0c                	je     80230f <alloc_block_FF+0x1e0>
  802303:	a1 30 50 80 00       	mov    0x805030,%eax
  802308:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80230b:	89 10                	mov    %edx,(%eax)
  80230d:	eb 08                	jmp    802317 <alloc_block_FF+0x1e8>
  80230f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802312:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802317:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80231a:	a3 30 50 80 00       	mov    %eax,0x805030
  80231f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802322:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802328:	a1 38 50 80 00       	mov    0x805038,%eax
  80232d:	40                   	inc    %eax
  80232e:	a3 38 50 80 00       	mov    %eax,0x805038
  802333:	eb 6e                	jmp    8023a3 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802335:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802339:	74 06                	je     802341 <alloc_block_FF+0x212>
  80233b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80233f:	75 17                	jne    802358 <alloc_block_FF+0x229>
  802341:	83 ec 04             	sub    $0x4,%esp
  802344:	68 18 44 80 00       	push   $0x804418
  802349:	68 df 00 00 00       	push   $0xdf
  80234e:	68 a5 43 80 00       	push   $0x8043a5
  802353:	e8 0f df ff ff       	call   800267 <_panic>
  802358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235b:	8b 10                	mov    (%eax),%edx
  80235d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802360:	89 10                	mov    %edx,(%eax)
  802362:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802365:	8b 00                	mov    (%eax),%eax
  802367:	85 c0                	test   %eax,%eax
  802369:	74 0b                	je     802376 <alloc_block_FF+0x247>
  80236b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236e:	8b 00                	mov    (%eax),%eax
  802370:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802373:	89 50 04             	mov    %edx,0x4(%eax)
  802376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802379:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80237c:	89 10                	mov    %edx,(%eax)
  80237e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802381:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802384:	89 50 04             	mov    %edx,0x4(%eax)
  802387:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80238a:	8b 00                	mov    (%eax),%eax
  80238c:	85 c0                	test   %eax,%eax
  80238e:	75 08                	jne    802398 <alloc_block_FF+0x269>
  802390:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802393:	a3 30 50 80 00       	mov    %eax,0x805030
  802398:	a1 38 50 80 00       	mov    0x805038,%eax
  80239d:	40                   	inc    %eax
  80239e:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8023a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a7:	75 17                	jne    8023c0 <alloc_block_FF+0x291>
  8023a9:	83 ec 04             	sub    $0x4,%esp
  8023ac:	68 87 43 80 00       	push   $0x804387
  8023b1:	68 e1 00 00 00       	push   $0xe1
  8023b6:	68 a5 43 80 00       	push   $0x8043a5
  8023bb:	e8 a7 de ff ff       	call   800267 <_panic>
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	8b 00                	mov    (%eax),%eax
  8023c5:	85 c0                	test   %eax,%eax
  8023c7:	74 10                	je     8023d9 <alloc_block_FF+0x2aa>
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	8b 00                	mov    (%eax),%eax
  8023ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d1:	8b 52 04             	mov    0x4(%edx),%edx
  8023d4:	89 50 04             	mov    %edx,0x4(%eax)
  8023d7:	eb 0b                	jmp    8023e4 <alloc_block_FF+0x2b5>
  8023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dc:	8b 40 04             	mov    0x4(%eax),%eax
  8023df:	a3 30 50 80 00       	mov    %eax,0x805030
  8023e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e7:	8b 40 04             	mov    0x4(%eax),%eax
  8023ea:	85 c0                	test   %eax,%eax
  8023ec:	74 0f                	je     8023fd <alloc_block_FF+0x2ce>
  8023ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f1:	8b 40 04             	mov    0x4(%eax),%eax
  8023f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f7:	8b 12                	mov    (%edx),%edx
  8023f9:	89 10                	mov    %edx,(%eax)
  8023fb:	eb 0a                	jmp    802407 <alloc_block_FF+0x2d8>
  8023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802400:	8b 00                	mov    (%eax),%eax
  802402:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80241a:	a1 38 50 80 00       	mov    0x805038,%eax
  80241f:	48                   	dec    %eax
  802420:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802425:	83 ec 04             	sub    $0x4,%esp
  802428:	6a 00                	push   $0x0
  80242a:	ff 75 b4             	pushl  -0x4c(%ebp)
  80242d:	ff 75 b0             	pushl  -0x50(%ebp)
  802430:	e8 cb fc ff ff       	call   802100 <set_block_data>
  802435:	83 c4 10             	add    $0x10,%esp
  802438:	e9 95 00 00 00       	jmp    8024d2 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80243d:	83 ec 04             	sub    $0x4,%esp
  802440:	6a 01                	push   $0x1
  802442:	ff 75 b8             	pushl  -0x48(%ebp)
  802445:	ff 75 bc             	pushl  -0x44(%ebp)
  802448:	e8 b3 fc ff ff       	call   802100 <set_block_data>
  80244d:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802450:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802454:	75 17                	jne    80246d <alloc_block_FF+0x33e>
  802456:	83 ec 04             	sub    $0x4,%esp
  802459:	68 87 43 80 00       	push   $0x804387
  80245e:	68 e8 00 00 00       	push   $0xe8
  802463:	68 a5 43 80 00       	push   $0x8043a5
  802468:	e8 fa dd ff ff       	call   800267 <_panic>
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	8b 00                	mov    (%eax),%eax
  802472:	85 c0                	test   %eax,%eax
  802474:	74 10                	je     802486 <alloc_block_FF+0x357>
  802476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802479:	8b 00                	mov    (%eax),%eax
  80247b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247e:	8b 52 04             	mov    0x4(%edx),%edx
  802481:	89 50 04             	mov    %edx,0x4(%eax)
  802484:	eb 0b                	jmp    802491 <alloc_block_FF+0x362>
  802486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802489:	8b 40 04             	mov    0x4(%eax),%eax
  80248c:	a3 30 50 80 00       	mov    %eax,0x805030
  802491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802494:	8b 40 04             	mov    0x4(%eax),%eax
  802497:	85 c0                	test   %eax,%eax
  802499:	74 0f                	je     8024aa <alloc_block_FF+0x37b>
  80249b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249e:	8b 40 04             	mov    0x4(%eax),%eax
  8024a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a4:	8b 12                	mov    (%edx),%edx
  8024a6:	89 10                	mov    %edx,(%eax)
  8024a8:	eb 0a                	jmp    8024b4 <alloc_block_FF+0x385>
  8024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ad:	8b 00                	mov    (%eax),%eax
  8024af:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024c7:	a1 38 50 80 00       	mov    0x805038,%eax
  8024cc:	48                   	dec    %eax
  8024cd:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8024d2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024d5:	e9 0f 01 00 00       	jmp    8025e9 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8024da:	a1 34 50 80 00       	mov    0x805034,%eax
  8024df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e6:	74 07                	je     8024ef <alloc_block_FF+0x3c0>
  8024e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024eb:	8b 00                	mov    (%eax),%eax
  8024ed:	eb 05                	jmp    8024f4 <alloc_block_FF+0x3c5>
  8024ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f4:	a3 34 50 80 00       	mov    %eax,0x805034
  8024f9:	a1 34 50 80 00       	mov    0x805034,%eax
  8024fe:	85 c0                	test   %eax,%eax
  802500:	0f 85 e9 fc ff ff    	jne    8021ef <alloc_block_FF+0xc0>
  802506:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80250a:	0f 85 df fc ff ff    	jne    8021ef <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802510:	8b 45 08             	mov    0x8(%ebp),%eax
  802513:	83 c0 08             	add    $0x8,%eax
  802516:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802519:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802520:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802523:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802526:	01 d0                	add    %edx,%eax
  802528:	48                   	dec    %eax
  802529:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80252c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80252f:	ba 00 00 00 00       	mov    $0x0,%edx
  802534:	f7 75 d8             	divl   -0x28(%ebp)
  802537:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80253a:	29 d0                	sub    %edx,%eax
  80253c:	c1 e8 0c             	shr    $0xc,%eax
  80253f:	83 ec 0c             	sub    $0xc,%esp
  802542:	50                   	push   %eax
  802543:	e8 76 ed ff ff       	call   8012be <sbrk>
  802548:	83 c4 10             	add    $0x10,%esp
  80254b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80254e:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802552:	75 0a                	jne    80255e <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802554:	b8 00 00 00 00       	mov    $0x0,%eax
  802559:	e9 8b 00 00 00       	jmp    8025e9 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80255e:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802565:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802568:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80256b:	01 d0                	add    %edx,%eax
  80256d:	48                   	dec    %eax
  80256e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802571:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802574:	ba 00 00 00 00       	mov    $0x0,%edx
  802579:	f7 75 cc             	divl   -0x34(%ebp)
  80257c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80257f:	29 d0                	sub    %edx,%eax
  802581:	8d 50 fc             	lea    -0x4(%eax),%edx
  802584:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802587:	01 d0                	add    %edx,%eax
  802589:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80258e:	a1 40 50 80 00       	mov    0x805040,%eax
  802593:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802599:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8025a0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025a3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8025a6:	01 d0                	add    %edx,%eax
  8025a8:	48                   	dec    %eax
  8025a9:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8025ac:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8025af:	ba 00 00 00 00       	mov    $0x0,%edx
  8025b4:	f7 75 c4             	divl   -0x3c(%ebp)
  8025b7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8025ba:	29 d0                	sub    %edx,%eax
  8025bc:	83 ec 04             	sub    $0x4,%esp
  8025bf:	6a 01                	push   $0x1
  8025c1:	50                   	push   %eax
  8025c2:	ff 75 d0             	pushl  -0x30(%ebp)
  8025c5:	e8 36 fb ff ff       	call   802100 <set_block_data>
  8025ca:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8025cd:	83 ec 0c             	sub    $0xc,%esp
  8025d0:	ff 75 d0             	pushl  -0x30(%ebp)
  8025d3:	e8 1b 0a 00 00       	call   802ff3 <free_block>
  8025d8:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8025db:	83 ec 0c             	sub    $0xc,%esp
  8025de:	ff 75 08             	pushl  0x8(%ebp)
  8025e1:	e8 49 fb ff ff       	call   80212f <alloc_block_FF>
  8025e6:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8025e9:	c9                   	leave  
  8025ea:	c3                   	ret    

008025eb <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8025eb:	55                   	push   %ebp
  8025ec:	89 e5                	mov    %esp,%ebp
  8025ee:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8025f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f4:	83 e0 01             	and    $0x1,%eax
  8025f7:	85 c0                	test   %eax,%eax
  8025f9:	74 03                	je     8025fe <alloc_block_BF+0x13>
  8025fb:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8025fe:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802602:	77 07                	ja     80260b <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802604:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80260b:	a1 24 50 80 00       	mov    0x805024,%eax
  802610:	85 c0                	test   %eax,%eax
  802612:	75 73                	jne    802687 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802614:	8b 45 08             	mov    0x8(%ebp),%eax
  802617:	83 c0 10             	add    $0x10,%eax
  80261a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80261d:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802624:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802627:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80262a:	01 d0                	add    %edx,%eax
  80262c:	48                   	dec    %eax
  80262d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802630:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802633:	ba 00 00 00 00       	mov    $0x0,%edx
  802638:	f7 75 e0             	divl   -0x20(%ebp)
  80263b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80263e:	29 d0                	sub    %edx,%eax
  802640:	c1 e8 0c             	shr    $0xc,%eax
  802643:	83 ec 0c             	sub    $0xc,%esp
  802646:	50                   	push   %eax
  802647:	e8 72 ec ff ff       	call   8012be <sbrk>
  80264c:	83 c4 10             	add    $0x10,%esp
  80264f:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802652:	83 ec 0c             	sub    $0xc,%esp
  802655:	6a 00                	push   $0x0
  802657:	e8 62 ec ff ff       	call   8012be <sbrk>
  80265c:	83 c4 10             	add    $0x10,%esp
  80265f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802662:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802665:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802668:	83 ec 08             	sub    $0x8,%esp
  80266b:	50                   	push   %eax
  80266c:	ff 75 d8             	pushl  -0x28(%ebp)
  80266f:	e8 9f f8 ff ff       	call   801f13 <initialize_dynamic_allocator>
  802674:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802677:	83 ec 0c             	sub    $0xc,%esp
  80267a:	68 e3 43 80 00       	push   $0x8043e3
  80267f:	e8 a0 de ff ff       	call   800524 <cprintf>
  802684:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802687:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80268e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802695:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80269c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8026a3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8026a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ab:	e9 1d 01 00 00       	jmp    8027cd <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8026b6:	83 ec 0c             	sub    $0xc,%esp
  8026b9:	ff 75 a8             	pushl  -0x58(%ebp)
  8026bc:	e8 ee f6 ff ff       	call   801daf <get_block_size>
  8026c1:	83 c4 10             	add    $0x10,%esp
  8026c4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8026c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ca:	83 c0 08             	add    $0x8,%eax
  8026cd:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026d0:	0f 87 ef 00 00 00    	ja     8027c5 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8026d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d9:	83 c0 18             	add    $0x18,%eax
  8026dc:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026df:	77 1d                	ja     8026fe <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8026e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026e7:	0f 86 d8 00 00 00    	jbe    8027c5 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8026ed:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8026f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8026f3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8026f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8026f9:	e9 c7 00 00 00       	jmp    8027c5 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8026fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802701:	83 c0 08             	add    $0x8,%eax
  802704:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802707:	0f 85 9d 00 00 00    	jne    8027aa <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80270d:	83 ec 04             	sub    $0x4,%esp
  802710:	6a 01                	push   $0x1
  802712:	ff 75 a4             	pushl  -0x5c(%ebp)
  802715:	ff 75 a8             	pushl  -0x58(%ebp)
  802718:	e8 e3 f9 ff ff       	call   802100 <set_block_data>
  80271d:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802720:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802724:	75 17                	jne    80273d <alloc_block_BF+0x152>
  802726:	83 ec 04             	sub    $0x4,%esp
  802729:	68 87 43 80 00       	push   $0x804387
  80272e:	68 2c 01 00 00       	push   $0x12c
  802733:	68 a5 43 80 00       	push   $0x8043a5
  802738:	e8 2a db ff ff       	call   800267 <_panic>
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	8b 00                	mov    (%eax),%eax
  802742:	85 c0                	test   %eax,%eax
  802744:	74 10                	je     802756 <alloc_block_BF+0x16b>
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	8b 00                	mov    (%eax),%eax
  80274b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80274e:	8b 52 04             	mov    0x4(%edx),%edx
  802751:	89 50 04             	mov    %edx,0x4(%eax)
  802754:	eb 0b                	jmp    802761 <alloc_block_BF+0x176>
  802756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802759:	8b 40 04             	mov    0x4(%eax),%eax
  80275c:	a3 30 50 80 00       	mov    %eax,0x805030
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	8b 40 04             	mov    0x4(%eax),%eax
  802767:	85 c0                	test   %eax,%eax
  802769:	74 0f                	je     80277a <alloc_block_BF+0x18f>
  80276b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276e:	8b 40 04             	mov    0x4(%eax),%eax
  802771:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802774:	8b 12                	mov    (%edx),%edx
  802776:	89 10                	mov    %edx,(%eax)
  802778:	eb 0a                	jmp    802784 <alloc_block_BF+0x199>
  80277a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277d:	8b 00                	mov    (%eax),%eax
  80277f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802784:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802787:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802790:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802797:	a1 38 50 80 00       	mov    0x805038,%eax
  80279c:	48                   	dec    %eax
  80279d:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8027a2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027a5:	e9 24 04 00 00       	jmp    802bce <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8027aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ad:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027b0:	76 13                	jbe    8027c5 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8027b2:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8027b9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8027bf:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8027c2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8027c5:	a1 34 50 80 00       	mov    0x805034,%eax
  8027ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d1:	74 07                	je     8027da <alloc_block_BF+0x1ef>
  8027d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d6:	8b 00                	mov    (%eax),%eax
  8027d8:	eb 05                	jmp    8027df <alloc_block_BF+0x1f4>
  8027da:	b8 00 00 00 00       	mov    $0x0,%eax
  8027df:	a3 34 50 80 00       	mov    %eax,0x805034
  8027e4:	a1 34 50 80 00       	mov    0x805034,%eax
  8027e9:	85 c0                	test   %eax,%eax
  8027eb:	0f 85 bf fe ff ff    	jne    8026b0 <alloc_block_BF+0xc5>
  8027f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f5:	0f 85 b5 fe ff ff    	jne    8026b0 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8027fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ff:	0f 84 26 02 00 00    	je     802a2b <alloc_block_BF+0x440>
  802805:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802809:	0f 85 1c 02 00 00    	jne    802a2b <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80280f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802812:	2b 45 08             	sub    0x8(%ebp),%eax
  802815:	83 e8 08             	sub    $0x8,%eax
  802818:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80281b:	8b 45 08             	mov    0x8(%ebp),%eax
  80281e:	8d 50 08             	lea    0x8(%eax),%edx
  802821:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802824:	01 d0                	add    %edx,%eax
  802826:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802829:	8b 45 08             	mov    0x8(%ebp),%eax
  80282c:	83 c0 08             	add    $0x8,%eax
  80282f:	83 ec 04             	sub    $0x4,%esp
  802832:	6a 01                	push   $0x1
  802834:	50                   	push   %eax
  802835:	ff 75 f0             	pushl  -0x10(%ebp)
  802838:	e8 c3 f8 ff ff       	call   802100 <set_block_data>
  80283d:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802843:	8b 40 04             	mov    0x4(%eax),%eax
  802846:	85 c0                	test   %eax,%eax
  802848:	75 68                	jne    8028b2 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80284a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80284e:	75 17                	jne    802867 <alloc_block_BF+0x27c>
  802850:	83 ec 04             	sub    $0x4,%esp
  802853:	68 c0 43 80 00       	push   $0x8043c0
  802858:	68 45 01 00 00       	push   $0x145
  80285d:	68 a5 43 80 00       	push   $0x8043a5
  802862:	e8 00 da ff ff       	call   800267 <_panic>
  802867:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80286d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802870:	89 10                	mov    %edx,(%eax)
  802872:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802875:	8b 00                	mov    (%eax),%eax
  802877:	85 c0                	test   %eax,%eax
  802879:	74 0d                	je     802888 <alloc_block_BF+0x29d>
  80287b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802880:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802883:	89 50 04             	mov    %edx,0x4(%eax)
  802886:	eb 08                	jmp    802890 <alloc_block_BF+0x2a5>
  802888:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80288b:	a3 30 50 80 00       	mov    %eax,0x805030
  802890:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802893:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802898:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80289b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a2:	a1 38 50 80 00       	mov    0x805038,%eax
  8028a7:	40                   	inc    %eax
  8028a8:	a3 38 50 80 00       	mov    %eax,0x805038
  8028ad:	e9 dc 00 00 00       	jmp    80298e <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8028b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b5:	8b 00                	mov    (%eax),%eax
  8028b7:	85 c0                	test   %eax,%eax
  8028b9:	75 65                	jne    802920 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028bb:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028bf:	75 17                	jne    8028d8 <alloc_block_BF+0x2ed>
  8028c1:	83 ec 04             	sub    $0x4,%esp
  8028c4:	68 f4 43 80 00       	push   $0x8043f4
  8028c9:	68 4a 01 00 00       	push   $0x14a
  8028ce:	68 a5 43 80 00       	push   $0x8043a5
  8028d3:	e8 8f d9 ff ff       	call   800267 <_panic>
  8028d8:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8028de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028e1:	89 50 04             	mov    %edx,0x4(%eax)
  8028e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028e7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ea:	85 c0                	test   %eax,%eax
  8028ec:	74 0c                	je     8028fa <alloc_block_BF+0x30f>
  8028ee:	a1 30 50 80 00       	mov    0x805030,%eax
  8028f3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028f6:	89 10                	mov    %edx,(%eax)
  8028f8:	eb 08                	jmp    802902 <alloc_block_BF+0x317>
  8028fa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028fd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802902:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802905:	a3 30 50 80 00       	mov    %eax,0x805030
  80290a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80290d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802913:	a1 38 50 80 00       	mov    0x805038,%eax
  802918:	40                   	inc    %eax
  802919:	a3 38 50 80 00       	mov    %eax,0x805038
  80291e:	eb 6e                	jmp    80298e <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802920:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802924:	74 06                	je     80292c <alloc_block_BF+0x341>
  802926:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80292a:	75 17                	jne    802943 <alloc_block_BF+0x358>
  80292c:	83 ec 04             	sub    $0x4,%esp
  80292f:	68 18 44 80 00       	push   $0x804418
  802934:	68 4f 01 00 00       	push   $0x14f
  802939:	68 a5 43 80 00       	push   $0x8043a5
  80293e:	e8 24 d9 ff ff       	call   800267 <_panic>
  802943:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802946:	8b 10                	mov    (%eax),%edx
  802948:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80294b:	89 10                	mov    %edx,(%eax)
  80294d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802950:	8b 00                	mov    (%eax),%eax
  802952:	85 c0                	test   %eax,%eax
  802954:	74 0b                	je     802961 <alloc_block_BF+0x376>
  802956:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802959:	8b 00                	mov    (%eax),%eax
  80295b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80295e:	89 50 04             	mov    %edx,0x4(%eax)
  802961:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802964:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802967:	89 10                	mov    %edx,(%eax)
  802969:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80296c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80296f:	89 50 04             	mov    %edx,0x4(%eax)
  802972:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802975:	8b 00                	mov    (%eax),%eax
  802977:	85 c0                	test   %eax,%eax
  802979:	75 08                	jne    802983 <alloc_block_BF+0x398>
  80297b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80297e:	a3 30 50 80 00       	mov    %eax,0x805030
  802983:	a1 38 50 80 00       	mov    0x805038,%eax
  802988:	40                   	inc    %eax
  802989:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80298e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802992:	75 17                	jne    8029ab <alloc_block_BF+0x3c0>
  802994:	83 ec 04             	sub    $0x4,%esp
  802997:	68 87 43 80 00       	push   $0x804387
  80299c:	68 51 01 00 00       	push   $0x151
  8029a1:	68 a5 43 80 00       	push   $0x8043a5
  8029a6:	e8 bc d8 ff ff       	call   800267 <_panic>
  8029ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ae:	8b 00                	mov    (%eax),%eax
  8029b0:	85 c0                	test   %eax,%eax
  8029b2:	74 10                	je     8029c4 <alloc_block_BF+0x3d9>
  8029b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b7:	8b 00                	mov    (%eax),%eax
  8029b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029bc:	8b 52 04             	mov    0x4(%edx),%edx
  8029bf:	89 50 04             	mov    %edx,0x4(%eax)
  8029c2:	eb 0b                	jmp    8029cf <alloc_block_BF+0x3e4>
  8029c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c7:	8b 40 04             	mov    0x4(%eax),%eax
  8029ca:	a3 30 50 80 00       	mov    %eax,0x805030
  8029cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d2:	8b 40 04             	mov    0x4(%eax),%eax
  8029d5:	85 c0                	test   %eax,%eax
  8029d7:	74 0f                	je     8029e8 <alloc_block_BF+0x3fd>
  8029d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029dc:	8b 40 04             	mov    0x4(%eax),%eax
  8029df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029e2:	8b 12                	mov    (%edx),%edx
  8029e4:	89 10                	mov    %edx,(%eax)
  8029e6:	eb 0a                	jmp    8029f2 <alloc_block_BF+0x407>
  8029e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029eb:	8b 00                	mov    (%eax),%eax
  8029ed:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a05:	a1 38 50 80 00       	mov    0x805038,%eax
  802a0a:	48                   	dec    %eax
  802a0b:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802a10:	83 ec 04             	sub    $0x4,%esp
  802a13:	6a 00                	push   $0x0
  802a15:	ff 75 d0             	pushl  -0x30(%ebp)
  802a18:	ff 75 cc             	pushl  -0x34(%ebp)
  802a1b:	e8 e0 f6 ff ff       	call   802100 <set_block_data>
  802a20:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a26:	e9 a3 01 00 00       	jmp    802bce <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802a2b:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802a2f:	0f 85 9d 00 00 00    	jne    802ad2 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802a35:	83 ec 04             	sub    $0x4,%esp
  802a38:	6a 01                	push   $0x1
  802a3a:	ff 75 ec             	pushl  -0x14(%ebp)
  802a3d:	ff 75 f0             	pushl  -0x10(%ebp)
  802a40:	e8 bb f6 ff ff       	call   802100 <set_block_data>
  802a45:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802a48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a4c:	75 17                	jne    802a65 <alloc_block_BF+0x47a>
  802a4e:	83 ec 04             	sub    $0x4,%esp
  802a51:	68 87 43 80 00       	push   $0x804387
  802a56:	68 58 01 00 00       	push   $0x158
  802a5b:	68 a5 43 80 00       	push   $0x8043a5
  802a60:	e8 02 d8 ff ff       	call   800267 <_panic>
  802a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a68:	8b 00                	mov    (%eax),%eax
  802a6a:	85 c0                	test   %eax,%eax
  802a6c:	74 10                	je     802a7e <alloc_block_BF+0x493>
  802a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a71:	8b 00                	mov    (%eax),%eax
  802a73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a76:	8b 52 04             	mov    0x4(%edx),%edx
  802a79:	89 50 04             	mov    %edx,0x4(%eax)
  802a7c:	eb 0b                	jmp    802a89 <alloc_block_BF+0x49e>
  802a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a81:	8b 40 04             	mov    0x4(%eax),%eax
  802a84:	a3 30 50 80 00       	mov    %eax,0x805030
  802a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8c:	8b 40 04             	mov    0x4(%eax),%eax
  802a8f:	85 c0                	test   %eax,%eax
  802a91:	74 0f                	je     802aa2 <alloc_block_BF+0x4b7>
  802a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a96:	8b 40 04             	mov    0x4(%eax),%eax
  802a99:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a9c:	8b 12                	mov    (%edx),%edx
  802a9e:	89 10                	mov    %edx,(%eax)
  802aa0:	eb 0a                	jmp    802aac <alloc_block_BF+0x4c1>
  802aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa5:	8b 00                	mov    (%eax),%eax
  802aa7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aaf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802abf:	a1 38 50 80 00       	mov    0x805038,%eax
  802ac4:	48                   	dec    %eax
  802ac5:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acd:	e9 fc 00 00 00       	jmp    802bce <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad5:	83 c0 08             	add    $0x8,%eax
  802ad8:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802adb:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ae2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ae5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ae8:	01 d0                	add    %edx,%eax
  802aea:	48                   	dec    %eax
  802aeb:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802aee:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802af1:	ba 00 00 00 00       	mov    $0x0,%edx
  802af6:	f7 75 c4             	divl   -0x3c(%ebp)
  802af9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802afc:	29 d0                	sub    %edx,%eax
  802afe:	c1 e8 0c             	shr    $0xc,%eax
  802b01:	83 ec 0c             	sub    $0xc,%esp
  802b04:	50                   	push   %eax
  802b05:	e8 b4 e7 ff ff       	call   8012be <sbrk>
  802b0a:	83 c4 10             	add    $0x10,%esp
  802b0d:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802b10:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802b14:	75 0a                	jne    802b20 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802b16:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1b:	e9 ae 00 00 00       	jmp    802bce <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b20:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802b27:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b2a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b2d:	01 d0                	add    %edx,%eax
  802b2f:	48                   	dec    %eax
  802b30:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802b33:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b36:	ba 00 00 00 00       	mov    $0x0,%edx
  802b3b:	f7 75 b8             	divl   -0x48(%ebp)
  802b3e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b41:	29 d0                	sub    %edx,%eax
  802b43:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b46:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b49:	01 d0                	add    %edx,%eax
  802b4b:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802b50:	a1 40 50 80 00       	mov    0x805040,%eax
  802b55:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802b5b:	83 ec 0c             	sub    $0xc,%esp
  802b5e:	68 4c 44 80 00       	push   $0x80444c
  802b63:	e8 bc d9 ff ff       	call   800524 <cprintf>
  802b68:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802b6b:	83 ec 08             	sub    $0x8,%esp
  802b6e:	ff 75 bc             	pushl  -0x44(%ebp)
  802b71:	68 51 44 80 00       	push   $0x804451
  802b76:	e8 a9 d9 ff ff       	call   800524 <cprintf>
  802b7b:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802b7e:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802b85:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b88:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b8b:	01 d0                	add    %edx,%eax
  802b8d:	48                   	dec    %eax
  802b8e:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802b91:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b94:	ba 00 00 00 00       	mov    $0x0,%edx
  802b99:	f7 75 b0             	divl   -0x50(%ebp)
  802b9c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b9f:	29 d0                	sub    %edx,%eax
  802ba1:	83 ec 04             	sub    $0x4,%esp
  802ba4:	6a 01                	push   $0x1
  802ba6:	50                   	push   %eax
  802ba7:	ff 75 bc             	pushl  -0x44(%ebp)
  802baa:	e8 51 f5 ff ff       	call   802100 <set_block_data>
  802baf:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802bb2:	83 ec 0c             	sub    $0xc,%esp
  802bb5:	ff 75 bc             	pushl  -0x44(%ebp)
  802bb8:	e8 36 04 00 00       	call   802ff3 <free_block>
  802bbd:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802bc0:	83 ec 0c             	sub    $0xc,%esp
  802bc3:	ff 75 08             	pushl  0x8(%ebp)
  802bc6:	e8 20 fa ff ff       	call   8025eb <alloc_block_BF>
  802bcb:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802bce:	c9                   	leave  
  802bcf:	c3                   	ret    

00802bd0 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802bd0:	55                   	push   %ebp
  802bd1:	89 e5                	mov    %esp,%ebp
  802bd3:	53                   	push   %ebx
  802bd4:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802bd7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802bde:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802be5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802be9:	74 1e                	je     802c09 <merging+0x39>
  802beb:	ff 75 08             	pushl  0x8(%ebp)
  802bee:	e8 bc f1 ff ff       	call   801daf <get_block_size>
  802bf3:	83 c4 04             	add    $0x4,%esp
  802bf6:	89 c2                	mov    %eax,%edx
  802bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfb:	01 d0                	add    %edx,%eax
  802bfd:	3b 45 10             	cmp    0x10(%ebp),%eax
  802c00:	75 07                	jne    802c09 <merging+0x39>
		prev_is_free = 1;
  802c02:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802c09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c0d:	74 1e                	je     802c2d <merging+0x5d>
  802c0f:	ff 75 10             	pushl  0x10(%ebp)
  802c12:	e8 98 f1 ff ff       	call   801daf <get_block_size>
  802c17:	83 c4 04             	add    $0x4,%esp
  802c1a:	89 c2                	mov    %eax,%edx
  802c1c:	8b 45 10             	mov    0x10(%ebp),%eax
  802c1f:	01 d0                	add    %edx,%eax
  802c21:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c24:	75 07                	jne    802c2d <merging+0x5d>
		next_is_free = 1;
  802c26:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802c2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c31:	0f 84 cc 00 00 00    	je     802d03 <merging+0x133>
  802c37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c3b:	0f 84 c2 00 00 00    	je     802d03 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802c41:	ff 75 08             	pushl  0x8(%ebp)
  802c44:	e8 66 f1 ff ff       	call   801daf <get_block_size>
  802c49:	83 c4 04             	add    $0x4,%esp
  802c4c:	89 c3                	mov    %eax,%ebx
  802c4e:	ff 75 10             	pushl  0x10(%ebp)
  802c51:	e8 59 f1 ff ff       	call   801daf <get_block_size>
  802c56:	83 c4 04             	add    $0x4,%esp
  802c59:	01 c3                	add    %eax,%ebx
  802c5b:	ff 75 0c             	pushl  0xc(%ebp)
  802c5e:	e8 4c f1 ff ff       	call   801daf <get_block_size>
  802c63:	83 c4 04             	add    $0x4,%esp
  802c66:	01 d8                	add    %ebx,%eax
  802c68:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802c6b:	6a 00                	push   $0x0
  802c6d:	ff 75 ec             	pushl  -0x14(%ebp)
  802c70:	ff 75 08             	pushl  0x8(%ebp)
  802c73:	e8 88 f4 ff ff       	call   802100 <set_block_data>
  802c78:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802c7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c7f:	75 17                	jne    802c98 <merging+0xc8>
  802c81:	83 ec 04             	sub    $0x4,%esp
  802c84:	68 87 43 80 00       	push   $0x804387
  802c89:	68 7d 01 00 00       	push   $0x17d
  802c8e:	68 a5 43 80 00       	push   $0x8043a5
  802c93:	e8 cf d5 ff ff       	call   800267 <_panic>
  802c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c9b:	8b 00                	mov    (%eax),%eax
  802c9d:	85 c0                	test   %eax,%eax
  802c9f:	74 10                	je     802cb1 <merging+0xe1>
  802ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ca4:	8b 00                	mov    (%eax),%eax
  802ca6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ca9:	8b 52 04             	mov    0x4(%edx),%edx
  802cac:	89 50 04             	mov    %edx,0x4(%eax)
  802caf:	eb 0b                	jmp    802cbc <merging+0xec>
  802cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cb4:	8b 40 04             	mov    0x4(%eax),%eax
  802cb7:	a3 30 50 80 00       	mov    %eax,0x805030
  802cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cbf:	8b 40 04             	mov    0x4(%eax),%eax
  802cc2:	85 c0                	test   %eax,%eax
  802cc4:	74 0f                	je     802cd5 <merging+0x105>
  802cc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cc9:	8b 40 04             	mov    0x4(%eax),%eax
  802ccc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ccf:	8b 12                	mov    (%edx),%edx
  802cd1:	89 10                	mov    %edx,(%eax)
  802cd3:	eb 0a                	jmp    802cdf <merging+0x10f>
  802cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cd8:	8b 00                	mov    (%eax),%eax
  802cda:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ce2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ceb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf2:	a1 38 50 80 00       	mov    0x805038,%eax
  802cf7:	48                   	dec    %eax
  802cf8:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802cfd:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802cfe:	e9 ea 02 00 00       	jmp    802fed <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802d03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d07:	74 3b                	je     802d44 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802d09:	83 ec 0c             	sub    $0xc,%esp
  802d0c:	ff 75 08             	pushl  0x8(%ebp)
  802d0f:	e8 9b f0 ff ff       	call   801daf <get_block_size>
  802d14:	83 c4 10             	add    $0x10,%esp
  802d17:	89 c3                	mov    %eax,%ebx
  802d19:	83 ec 0c             	sub    $0xc,%esp
  802d1c:	ff 75 10             	pushl  0x10(%ebp)
  802d1f:	e8 8b f0 ff ff       	call   801daf <get_block_size>
  802d24:	83 c4 10             	add    $0x10,%esp
  802d27:	01 d8                	add    %ebx,%eax
  802d29:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d2c:	83 ec 04             	sub    $0x4,%esp
  802d2f:	6a 00                	push   $0x0
  802d31:	ff 75 e8             	pushl  -0x18(%ebp)
  802d34:	ff 75 08             	pushl  0x8(%ebp)
  802d37:	e8 c4 f3 ff ff       	call   802100 <set_block_data>
  802d3c:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d3f:	e9 a9 02 00 00       	jmp    802fed <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802d44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d48:	0f 84 2d 01 00 00    	je     802e7b <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802d4e:	83 ec 0c             	sub    $0xc,%esp
  802d51:	ff 75 10             	pushl  0x10(%ebp)
  802d54:	e8 56 f0 ff ff       	call   801daf <get_block_size>
  802d59:	83 c4 10             	add    $0x10,%esp
  802d5c:	89 c3                	mov    %eax,%ebx
  802d5e:	83 ec 0c             	sub    $0xc,%esp
  802d61:	ff 75 0c             	pushl  0xc(%ebp)
  802d64:	e8 46 f0 ff ff       	call   801daf <get_block_size>
  802d69:	83 c4 10             	add    $0x10,%esp
  802d6c:	01 d8                	add    %ebx,%eax
  802d6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802d71:	83 ec 04             	sub    $0x4,%esp
  802d74:	6a 00                	push   $0x0
  802d76:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d79:	ff 75 10             	pushl  0x10(%ebp)
  802d7c:	e8 7f f3 ff ff       	call   802100 <set_block_data>
  802d81:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802d84:	8b 45 10             	mov    0x10(%ebp),%eax
  802d87:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802d8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d8e:	74 06                	je     802d96 <merging+0x1c6>
  802d90:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d94:	75 17                	jne    802dad <merging+0x1dd>
  802d96:	83 ec 04             	sub    $0x4,%esp
  802d99:	68 60 44 80 00       	push   $0x804460
  802d9e:	68 8d 01 00 00       	push   $0x18d
  802da3:	68 a5 43 80 00       	push   $0x8043a5
  802da8:	e8 ba d4 ff ff       	call   800267 <_panic>
  802dad:	8b 45 0c             	mov    0xc(%ebp),%eax
  802db0:	8b 50 04             	mov    0x4(%eax),%edx
  802db3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802db6:	89 50 04             	mov    %edx,0x4(%eax)
  802db9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dbf:	89 10                	mov    %edx,(%eax)
  802dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dc4:	8b 40 04             	mov    0x4(%eax),%eax
  802dc7:	85 c0                	test   %eax,%eax
  802dc9:	74 0d                	je     802dd8 <merging+0x208>
  802dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dce:	8b 40 04             	mov    0x4(%eax),%eax
  802dd1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dd4:	89 10                	mov    %edx,(%eax)
  802dd6:	eb 08                	jmp    802de0 <merging+0x210>
  802dd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ddb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802de6:	89 50 04             	mov    %edx,0x4(%eax)
  802de9:	a1 38 50 80 00       	mov    0x805038,%eax
  802dee:	40                   	inc    %eax
  802def:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802df4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802df8:	75 17                	jne    802e11 <merging+0x241>
  802dfa:	83 ec 04             	sub    $0x4,%esp
  802dfd:	68 87 43 80 00       	push   $0x804387
  802e02:	68 8e 01 00 00       	push   $0x18e
  802e07:	68 a5 43 80 00       	push   $0x8043a5
  802e0c:	e8 56 d4 ff ff       	call   800267 <_panic>
  802e11:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e14:	8b 00                	mov    (%eax),%eax
  802e16:	85 c0                	test   %eax,%eax
  802e18:	74 10                	je     802e2a <merging+0x25a>
  802e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e1d:	8b 00                	mov    (%eax),%eax
  802e1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e22:	8b 52 04             	mov    0x4(%edx),%edx
  802e25:	89 50 04             	mov    %edx,0x4(%eax)
  802e28:	eb 0b                	jmp    802e35 <merging+0x265>
  802e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e2d:	8b 40 04             	mov    0x4(%eax),%eax
  802e30:	a3 30 50 80 00       	mov    %eax,0x805030
  802e35:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e38:	8b 40 04             	mov    0x4(%eax),%eax
  802e3b:	85 c0                	test   %eax,%eax
  802e3d:	74 0f                	je     802e4e <merging+0x27e>
  802e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e42:	8b 40 04             	mov    0x4(%eax),%eax
  802e45:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e48:	8b 12                	mov    (%edx),%edx
  802e4a:	89 10                	mov    %edx,(%eax)
  802e4c:	eb 0a                	jmp    802e58 <merging+0x288>
  802e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e51:	8b 00                	mov    (%eax),%eax
  802e53:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e58:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6b:	a1 38 50 80 00       	mov    0x805038,%eax
  802e70:	48                   	dec    %eax
  802e71:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e76:	e9 72 01 00 00       	jmp    802fed <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802e7b:	8b 45 10             	mov    0x10(%ebp),%eax
  802e7e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802e81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e85:	74 79                	je     802f00 <merging+0x330>
  802e87:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e8b:	74 73                	je     802f00 <merging+0x330>
  802e8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e91:	74 06                	je     802e99 <merging+0x2c9>
  802e93:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e97:	75 17                	jne    802eb0 <merging+0x2e0>
  802e99:	83 ec 04             	sub    $0x4,%esp
  802e9c:	68 18 44 80 00       	push   $0x804418
  802ea1:	68 94 01 00 00       	push   $0x194
  802ea6:	68 a5 43 80 00       	push   $0x8043a5
  802eab:	e8 b7 d3 ff ff       	call   800267 <_panic>
  802eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb3:	8b 10                	mov    (%eax),%edx
  802eb5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eb8:	89 10                	mov    %edx,(%eax)
  802eba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ebd:	8b 00                	mov    (%eax),%eax
  802ebf:	85 c0                	test   %eax,%eax
  802ec1:	74 0b                	je     802ece <merging+0x2fe>
  802ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec6:	8b 00                	mov    (%eax),%eax
  802ec8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ecb:	89 50 04             	mov    %edx,0x4(%eax)
  802ece:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ed4:	89 10                	mov    %edx,(%eax)
  802ed6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ed9:	8b 55 08             	mov    0x8(%ebp),%edx
  802edc:	89 50 04             	mov    %edx,0x4(%eax)
  802edf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ee2:	8b 00                	mov    (%eax),%eax
  802ee4:	85 c0                	test   %eax,%eax
  802ee6:	75 08                	jne    802ef0 <merging+0x320>
  802ee8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eeb:	a3 30 50 80 00       	mov    %eax,0x805030
  802ef0:	a1 38 50 80 00       	mov    0x805038,%eax
  802ef5:	40                   	inc    %eax
  802ef6:	a3 38 50 80 00       	mov    %eax,0x805038
  802efb:	e9 ce 00 00 00       	jmp    802fce <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802f00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f04:	74 65                	je     802f6b <merging+0x39b>
  802f06:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f0a:	75 17                	jne    802f23 <merging+0x353>
  802f0c:	83 ec 04             	sub    $0x4,%esp
  802f0f:	68 f4 43 80 00       	push   $0x8043f4
  802f14:	68 95 01 00 00       	push   $0x195
  802f19:	68 a5 43 80 00       	push   $0x8043a5
  802f1e:	e8 44 d3 ff ff       	call   800267 <_panic>
  802f23:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f29:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f2c:	89 50 04             	mov    %edx,0x4(%eax)
  802f2f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f32:	8b 40 04             	mov    0x4(%eax),%eax
  802f35:	85 c0                	test   %eax,%eax
  802f37:	74 0c                	je     802f45 <merging+0x375>
  802f39:	a1 30 50 80 00       	mov    0x805030,%eax
  802f3e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f41:	89 10                	mov    %edx,(%eax)
  802f43:	eb 08                	jmp    802f4d <merging+0x37d>
  802f45:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f48:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f50:	a3 30 50 80 00       	mov    %eax,0x805030
  802f55:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f5e:	a1 38 50 80 00       	mov    0x805038,%eax
  802f63:	40                   	inc    %eax
  802f64:	a3 38 50 80 00       	mov    %eax,0x805038
  802f69:	eb 63                	jmp    802fce <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802f6b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f6f:	75 17                	jne    802f88 <merging+0x3b8>
  802f71:	83 ec 04             	sub    $0x4,%esp
  802f74:	68 c0 43 80 00       	push   $0x8043c0
  802f79:	68 98 01 00 00       	push   $0x198
  802f7e:	68 a5 43 80 00       	push   $0x8043a5
  802f83:	e8 df d2 ff ff       	call   800267 <_panic>
  802f88:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802f8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f91:	89 10                	mov    %edx,(%eax)
  802f93:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f96:	8b 00                	mov    (%eax),%eax
  802f98:	85 c0                	test   %eax,%eax
  802f9a:	74 0d                	je     802fa9 <merging+0x3d9>
  802f9c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fa1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fa4:	89 50 04             	mov    %edx,0x4(%eax)
  802fa7:	eb 08                	jmp    802fb1 <merging+0x3e1>
  802fa9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fac:	a3 30 50 80 00       	mov    %eax,0x805030
  802fb1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fb4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fbc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc3:	a1 38 50 80 00       	mov    0x805038,%eax
  802fc8:	40                   	inc    %eax
  802fc9:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802fce:	83 ec 0c             	sub    $0xc,%esp
  802fd1:	ff 75 10             	pushl  0x10(%ebp)
  802fd4:	e8 d6 ed ff ff       	call   801daf <get_block_size>
  802fd9:	83 c4 10             	add    $0x10,%esp
  802fdc:	83 ec 04             	sub    $0x4,%esp
  802fdf:	6a 00                	push   $0x0
  802fe1:	50                   	push   %eax
  802fe2:	ff 75 10             	pushl  0x10(%ebp)
  802fe5:	e8 16 f1 ff ff       	call   802100 <set_block_data>
  802fea:	83 c4 10             	add    $0x10,%esp
	}
}
  802fed:	90                   	nop
  802fee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ff1:	c9                   	leave  
  802ff2:	c3                   	ret    

00802ff3 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802ff3:	55                   	push   %ebp
  802ff4:	89 e5                	mov    %esp,%ebp
  802ff6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802ff9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ffe:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803001:	a1 30 50 80 00       	mov    0x805030,%eax
  803006:	3b 45 08             	cmp    0x8(%ebp),%eax
  803009:	73 1b                	jae    803026 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80300b:	a1 30 50 80 00       	mov    0x805030,%eax
  803010:	83 ec 04             	sub    $0x4,%esp
  803013:	ff 75 08             	pushl  0x8(%ebp)
  803016:	6a 00                	push   $0x0
  803018:	50                   	push   %eax
  803019:	e8 b2 fb ff ff       	call   802bd0 <merging>
  80301e:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803021:	e9 8b 00 00 00       	jmp    8030b1 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803026:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80302b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80302e:	76 18                	jbe    803048 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803030:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803035:	83 ec 04             	sub    $0x4,%esp
  803038:	ff 75 08             	pushl  0x8(%ebp)
  80303b:	50                   	push   %eax
  80303c:	6a 00                	push   $0x0
  80303e:	e8 8d fb ff ff       	call   802bd0 <merging>
  803043:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803046:	eb 69                	jmp    8030b1 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803048:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80304d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803050:	eb 39                	jmp    80308b <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803055:	3b 45 08             	cmp    0x8(%ebp),%eax
  803058:	73 29                	jae    803083 <free_block+0x90>
  80305a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305d:	8b 00                	mov    (%eax),%eax
  80305f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803062:	76 1f                	jbe    803083 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803067:	8b 00                	mov    (%eax),%eax
  803069:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80306c:	83 ec 04             	sub    $0x4,%esp
  80306f:	ff 75 08             	pushl  0x8(%ebp)
  803072:	ff 75 f0             	pushl  -0x10(%ebp)
  803075:	ff 75 f4             	pushl  -0xc(%ebp)
  803078:	e8 53 fb ff ff       	call   802bd0 <merging>
  80307d:	83 c4 10             	add    $0x10,%esp
			break;
  803080:	90                   	nop
		}
	}
}
  803081:	eb 2e                	jmp    8030b1 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803083:	a1 34 50 80 00       	mov    0x805034,%eax
  803088:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80308b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80308f:	74 07                	je     803098 <free_block+0xa5>
  803091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803094:	8b 00                	mov    (%eax),%eax
  803096:	eb 05                	jmp    80309d <free_block+0xaa>
  803098:	b8 00 00 00 00       	mov    $0x0,%eax
  80309d:	a3 34 50 80 00       	mov    %eax,0x805034
  8030a2:	a1 34 50 80 00       	mov    0x805034,%eax
  8030a7:	85 c0                	test   %eax,%eax
  8030a9:	75 a7                	jne    803052 <free_block+0x5f>
  8030ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030af:	75 a1                	jne    803052 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030b1:	90                   	nop
  8030b2:	c9                   	leave  
  8030b3:	c3                   	ret    

008030b4 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8030b4:	55                   	push   %ebp
  8030b5:	89 e5                	mov    %esp,%ebp
  8030b7:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8030ba:	ff 75 08             	pushl  0x8(%ebp)
  8030bd:	e8 ed ec ff ff       	call   801daf <get_block_size>
  8030c2:	83 c4 04             	add    $0x4,%esp
  8030c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8030c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8030cf:	eb 17                	jmp    8030e8 <copy_data+0x34>
  8030d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8030d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d7:	01 c2                	add    %eax,%edx
  8030d9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8030dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030df:	01 c8                	add    %ecx,%eax
  8030e1:	8a 00                	mov    (%eax),%al
  8030e3:	88 02                	mov    %al,(%edx)
  8030e5:	ff 45 fc             	incl   -0x4(%ebp)
  8030e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030eb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8030ee:	72 e1                	jb     8030d1 <copy_data+0x1d>
}
  8030f0:	90                   	nop
  8030f1:	c9                   	leave  
  8030f2:	c3                   	ret    

008030f3 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8030f3:	55                   	push   %ebp
  8030f4:	89 e5                	mov    %esp,%ebp
  8030f6:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8030f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030fd:	75 23                	jne    803122 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8030ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803103:	74 13                	je     803118 <realloc_block_FF+0x25>
  803105:	83 ec 0c             	sub    $0xc,%esp
  803108:	ff 75 0c             	pushl  0xc(%ebp)
  80310b:	e8 1f f0 ff ff       	call   80212f <alloc_block_FF>
  803110:	83 c4 10             	add    $0x10,%esp
  803113:	e9 f4 06 00 00       	jmp    80380c <realloc_block_FF+0x719>
		return NULL;
  803118:	b8 00 00 00 00       	mov    $0x0,%eax
  80311d:	e9 ea 06 00 00       	jmp    80380c <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803122:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803126:	75 18                	jne    803140 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803128:	83 ec 0c             	sub    $0xc,%esp
  80312b:	ff 75 08             	pushl  0x8(%ebp)
  80312e:	e8 c0 fe ff ff       	call   802ff3 <free_block>
  803133:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803136:	b8 00 00 00 00       	mov    $0x0,%eax
  80313b:	e9 cc 06 00 00       	jmp    80380c <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803140:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803144:	77 07                	ja     80314d <realloc_block_FF+0x5a>
  803146:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80314d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803150:	83 e0 01             	and    $0x1,%eax
  803153:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803156:	8b 45 0c             	mov    0xc(%ebp),%eax
  803159:	83 c0 08             	add    $0x8,%eax
  80315c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80315f:	83 ec 0c             	sub    $0xc,%esp
  803162:	ff 75 08             	pushl  0x8(%ebp)
  803165:	e8 45 ec ff ff       	call   801daf <get_block_size>
  80316a:	83 c4 10             	add    $0x10,%esp
  80316d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803170:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803173:	83 e8 08             	sub    $0x8,%eax
  803176:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803179:	8b 45 08             	mov    0x8(%ebp),%eax
  80317c:	83 e8 04             	sub    $0x4,%eax
  80317f:	8b 00                	mov    (%eax),%eax
  803181:	83 e0 fe             	and    $0xfffffffe,%eax
  803184:	89 c2                	mov    %eax,%edx
  803186:	8b 45 08             	mov    0x8(%ebp),%eax
  803189:	01 d0                	add    %edx,%eax
  80318b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80318e:	83 ec 0c             	sub    $0xc,%esp
  803191:	ff 75 e4             	pushl  -0x1c(%ebp)
  803194:	e8 16 ec ff ff       	call   801daf <get_block_size>
  803199:	83 c4 10             	add    $0x10,%esp
  80319c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80319f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031a2:	83 e8 08             	sub    $0x8,%eax
  8031a5:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8031a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ab:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8031ae:	75 08                	jne    8031b8 <realloc_block_FF+0xc5>
	{
		 return va;
  8031b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b3:	e9 54 06 00 00       	jmp    80380c <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8031b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031bb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8031be:	0f 83 e5 03 00 00    	jae    8035a9 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8031c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c7:	2b 45 0c             	sub    0xc(%ebp),%eax
  8031ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8031cd:	83 ec 0c             	sub    $0xc,%esp
  8031d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031d3:	e8 f0 eb ff ff       	call   801dc8 <is_free_block>
  8031d8:	83 c4 10             	add    $0x10,%esp
  8031db:	84 c0                	test   %al,%al
  8031dd:	0f 84 3b 01 00 00    	je     80331e <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8031e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031e9:	01 d0                	add    %edx,%eax
  8031eb:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8031ee:	83 ec 04             	sub    $0x4,%esp
  8031f1:	6a 01                	push   $0x1
  8031f3:	ff 75 f0             	pushl  -0x10(%ebp)
  8031f6:	ff 75 08             	pushl  0x8(%ebp)
  8031f9:	e8 02 ef ff ff       	call   802100 <set_block_data>
  8031fe:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803201:	8b 45 08             	mov    0x8(%ebp),%eax
  803204:	83 e8 04             	sub    $0x4,%eax
  803207:	8b 00                	mov    (%eax),%eax
  803209:	83 e0 fe             	and    $0xfffffffe,%eax
  80320c:	89 c2                	mov    %eax,%edx
  80320e:	8b 45 08             	mov    0x8(%ebp),%eax
  803211:	01 d0                	add    %edx,%eax
  803213:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803216:	83 ec 04             	sub    $0x4,%esp
  803219:	6a 00                	push   $0x0
  80321b:	ff 75 cc             	pushl  -0x34(%ebp)
  80321e:	ff 75 c8             	pushl  -0x38(%ebp)
  803221:	e8 da ee ff ff       	call   802100 <set_block_data>
  803226:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803229:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80322d:	74 06                	je     803235 <realloc_block_FF+0x142>
  80322f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803233:	75 17                	jne    80324c <realloc_block_FF+0x159>
  803235:	83 ec 04             	sub    $0x4,%esp
  803238:	68 18 44 80 00       	push   $0x804418
  80323d:	68 f6 01 00 00       	push   $0x1f6
  803242:	68 a5 43 80 00       	push   $0x8043a5
  803247:	e8 1b d0 ff ff       	call   800267 <_panic>
  80324c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80324f:	8b 10                	mov    (%eax),%edx
  803251:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803254:	89 10                	mov    %edx,(%eax)
  803256:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803259:	8b 00                	mov    (%eax),%eax
  80325b:	85 c0                	test   %eax,%eax
  80325d:	74 0b                	je     80326a <realloc_block_FF+0x177>
  80325f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803262:	8b 00                	mov    (%eax),%eax
  803264:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803267:	89 50 04             	mov    %edx,0x4(%eax)
  80326a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80326d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803270:	89 10                	mov    %edx,(%eax)
  803272:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803275:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803278:	89 50 04             	mov    %edx,0x4(%eax)
  80327b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80327e:	8b 00                	mov    (%eax),%eax
  803280:	85 c0                	test   %eax,%eax
  803282:	75 08                	jne    80328c <realloc_block_FF+0x199>
  803284:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803287:	a3 30 50 80 00       	mov    %eax,0x805030
  80328c:	a1 38 50 80 00       	mov    0x805038,%eax
  803291:	40                   	inc    %eax
  803292:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803297:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80329b:	75 17                	jne    8032b4 <realloc_block_FF+0x1c1>
  80329d:	83 ec 04             	sub    $0x4,%esp
  8032a0:	68 87 43 80 00       	push   $0x804387
  8032a5:	68 f7 01 00 00       	push   $0x1f7
  8032aa:	68 a5 43 80 00       	push   $0x8043a5
  8032af:	e8 b3 cf ff ff       	call   800267 <_panic>
  8032b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b7:	8b 00                	mov    (%eax),%eax
  8032b9:	85 c0                	test   %eax,%eax
  8032bb:	74 10                	je     8032cd <realloc_block_FF+0x1da>
  8032bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032c0:	8b 00                	mov    (%eax),%eax
  8032c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032c5:	8b 52 04             	mov    0x4(%edx),%edx
  8032c8:	89 50 04             	mov    %edx,0x4(%eax)
  8032cb:	eb 0b                	jmp    8032d8 <realloc_block_FF+0x1e5>
  8032cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d0:	8b 40 04             	mov    0x4(%eax),%eax
  8032d3:	a3 30 50 80 00       	mov    %eax,0x805030
  8032d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032db:	8b 40 04             	mov    0x4(%eax),%eax
  8032de:	85 c0                	test   %eax,%eax
  8032e0:	74 0f                	je     8032f1 <realloc_block_FF+0x1fe>
  8032e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e5:	8b 40 04             	mov    0x4(%eax),%eax
  8032e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032eb:	8b 12                	mov    (%edx),%edx
  8032ed:	89 10                	mov    %edx,(%eax)
  8032ef:	eb 0a                	jmp    8032fb <realloc_block_FF+0x208>
  8032f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032f4:	8b 00                	mov    (%eax),%eax
  8032f6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803304:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803307:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80330e:	a1 38 50 80 00       	mov    0x805038,%eax
  803313:	48                   	dec    %eax
  803314:	a3 38 50 80 00       	mov    %eax,0x805038
  803319:	e9 83 02 00 00       	jmp    8035a1 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80331e:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803322:	0f 86 69 02 00 00    	jbe    803591 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803328:	83 ec 04             	sub    $0x4,%esp
  80332b:	6a 01                	push   $0x1
  80332d:	ff 75 f0             	pushl  -0x10(%ebp)
  803330:	ff 75 08             	pushl  0x8(%ebp)
  803333:	e8 c8 ed ff ff       	call   802100 <set_block_data>
  803338:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80333b:	8b 45 08             	mov    0x8(%ebp),%eax
  80333e:	83 e8 04             	sub    $0x4,%eax
  803341:	8b 00                	mov    (%eax),%eax
  803343:	83 e0 fe             	and    $0xfffffffe,%eax
  803346:	89 c2                	mov    %eax,%edx
  803348:	8b 45 08             	mov    0x8(%ebp),%eax
  80334b:	01 d0                	add    %edx,%eax
  80334d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803350:	a1 38 50 80 00       	mov    0x805038,%eax
  803355:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803358:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80335c:	75 68                	jne    8033c6 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80335e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803362:	75 17                	jne    80337b <realloc_block_FF+0x288>
  803364:	83 ec 04             	sub    $0x4,%esp
  803367:	68 c0 43 80 00       	push   $0x8043c0
  80336c:	68 06 02 00 00       	push   $0x206
  803371:	68 a5 43 80 00       	push   $0x8043a5
  803376:	e8 ec ce ff ff       	call   800267 <_panic>
  80337b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803381:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803384:	89 10                	mov    %edx,(%eax)
  803386:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803389:	8b 00                	mov    (%eax),%eax
  80338b:	85 c0                	test   %eax,%eax
  80338d:	74 0d                	je     80339c <realloc_block_FF+0x2a9>
  80338f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803394:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803397:	89 50 04             	mov    %edx,0x4(%eax)
  80339a:	eb 08                	jmp    8033a4 <realloc_block_FF+0x2b1>
  80339c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80339f:	a3 30 50 80 00       	mov    %eax,0x805030
  8033a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033a7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b6:	a1 38 50 80 00       	mov    0x805038,%eax
  8033bb:	40                   	inc    %eax
  8033bc:	a3 38 50 80 00       	mov    %eax,0x805038
  8033c1:	e9 b0 01 00 00       	jmp    803576 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8033c6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033cb:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8033ce:	76 68                	jbe    803438 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8033d0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033d4:	75 17                	jne    8033ed <realloc_block_FF+0x2fa>
  8033d6:	83 ec 04             	sub    $0x4,%esp
  8033d9:	68 c0 43 80 00       	push   $0x8043c0
  8033de:	68 0b 02 00 00       	push   $0x20b
  8033e3:	68 a5 43 80 00       	push   $0x8043a5
  8033e8:	e8 7a ce ff ff       	call   800267 <_panic>
  8033ed:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8033f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033f6:	89 10                	mov    %edx,(%eax)
  8033f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033fb:	8b 00                	mov    (%eax),%eax
  8033fd:	85 c0                	test   %eax,%eax
  8033ff:	74 0d                	je     80340e <realloc_block_FF+0x31b>
  803401:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803406:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803409:	89 50 04             	mov    %edx,0x4(%eax)
  80340c:	eb 08                	jmp    803416 <realloc_block_FF+0x323>
  80340e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803411:	a3 30 50 80 00       	mov    %eax,0x805030
  803416:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803419:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80341e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803421:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803428:	a1 38 50 80 00       	mov    0x805038,%eax
  80342d:	40                   	inc    %eax
  80342e:	a3 38 50 80 00       	mov    %eax,0x805038
  803433:	e9 3e 01 00 00       	jmp    803576 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803438:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80343d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803440:	73 68                	jae    8034aa <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803442:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803446:	75 17                	jne    80345f <realloc_block_FF+0x36c>
  803448:	83 ec 04             	sub    $0x4,%esp
  80344b:	68 f4 43 80 00       	push   $0x8043f4
  803450:	68 10 02 00 00       	push   $0x210
  803455:	68 a5 43 80 00       	push   $0x8043a5
  80345a:	e8 08 ce ff ff       	call   800267 <_panic>
  80345f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803465:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803468:	89 50 04             	mov    %edx,0x4(%eax)
  80346b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80346e:	8b 40 04             	mov    0x4(%eax),%eax
  803471:	85 c0                	test   %eax,%eax
  803473:	74 0c                	je     803481 <realloc_block_FF+0x38e>
  803475:	a1 30 50 80 00       	mov    0x805030,%eax
  80347a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80347d:	89 10                	mov    %edx,(%eax)
  80347f:	eb 08                	jmp    803489 <realloc_block_FF+0x396>
  803481:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803484:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803489:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80348c:	a3 30 50 80 00       	mov    %eax,0x805030
  803491:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803494:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80349a:	a1 38 50 80 00       	mov    0x805038,%eax
  80349f:	40                   	inc    %eax
  8034a0:	a3 38 50 80 00       	mov    %eax,0x805038
  8034a5:	e9 cc 00 00 00       	jmp    803576 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8034aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8034b1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034b9:	e9 8a 00 00 00       	jmp    803548 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8034be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034c4:	73 7a                	jae    803540 <realloc_block_FF+0x44d>
  8034c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c9:	8b 00                	mov    (%eax),%eax
  8034cb:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034ce:	73 70                	jae    803540 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8034d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034d4:	74 06                	je     8034dc <realloc_block_FF+0x3e9>
  8034d6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034da:	75 17                	jne    8034f3 <realloc_block_FF+0x400>
  8034dc:	83 ec 04             	sub    $0x4,%esp
  8034df:	68 18 44 80 00       	push   $0x804418
  8034e4:	68 1a 02 00 00       	push   $0x21a
  8034e9:	68 a5 43 80 00       	push   $0x8043a5
  8034ee:	e8 74 cd ff ff       	call   800267 <_panic>
  8034f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f6:	8b 10                	mov    (%eax),%edx
  8034f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034fb:	89 10                	mov    %edx,(%eax)
  8034fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803500:	8b 00                	mov    (%eax),%eax
  803502:	85 c0                	test   %eax,%eax
  803504:	74 0b                	je     803511 <realloc_block_FF+0x41e>
  803506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803509:	8b 00                	mov    (%eax),%eax
  80350b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80350e:	89 50 04             	mov    %edx,0x4(%eax)
  803511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803514:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803517:	89 10                	mov    %edx,(%eax)
  803519:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80351c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80351f:	89 50 04             	mov    %edx,0x4(%eax)
  803522:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803525:	8b 00                	mov    (%eax),%eax
  803527:	85 c0                	test   %eax,%eax
  803529:	75 08                	jne    803533 <realloc_block_FF+0x440>
  80352b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80352e:	a3 30 50 80 00       	mov    %eax,0x805030
  803533:	a1 38 50 80 00       	mov    0x805038,%eax
  803538:	40                   	inc    %eax
  803539:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80353e:	eb 36                	jmp    803576 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803540:	a1 34 50 80 00       	mov    0x805034,%eax
  803545:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803548:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80354c:	74 07                	je     803555 <realloc_block_FF+0x462>
  80354e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803551:	8b 00                	mov    (%eax),%eax
  803553:	eb 05                	jmp    80355a <realloc_block_FF+0x467>
  803555:	b8 00 00 00 00       	mov    $0x0,%eax
  80355a:	a3 34 50 80 00       	mov    %eax,0x805034
  80355f:	a1 34 50 80 00       	mov    0x805034,%eax
  803564:	85 c0                	test   %eax,%eax
  803566:	0f 85 52 ff ff ff    	jne    8034be <realloc_block_FF+0x3cb>
  80356c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803570:	0f 85 48 ff ff ff    	jne    8034be <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803576:	83 ec 04             	sub    $0x4,%esp
  803579:	6a 00                	push   $0x0
  80357b:	ff 75 d8             	pushl  -0x28(%ebp)
  80357e:	ff 75 d4             	pushl  -0x2c(%ebp)
  803581:	e8 7a eb ff ff       	call   802100 <set_block_data>
  803586:	83 c4 10             	add    $0x10,%esp
				return va;
  803589:	8b 45 08             	mov    0x8(%ebp),%eax
  80358c:	e9 7b 02 00 00       	jmp    80380c <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803591:	83 ec 0c             	sub    $0xc,%esp
  803594:	68 95 44 80 00       	push   $0x804495
  803599:	e8 86 cf ff ff       	call   800524 <cprintf>
  80359e:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8035a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a4:	e9 63 02 00 00       	jmp    80380c <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8035a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ac:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8035af:	0f 86 4d 02 00 00    	jbe    803802 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8035b5:	83 ec 0c             	sub    $0xc,%esp
  8035b8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8035bb:	e8 08 e8 ff ff       	call   801dc8 <is_free_block>
  8035c0:	83 c4 10             	add    $0x10,%esp
  8035c3:	84 c0                	test   %al,%al
  8035c5:	0f 84 37 02 00 00    	je     803802 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8035cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ce:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8035d1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8035d4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8035d7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8035da:	76 38                	jbe    803614 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8035dc:	83 ec 0c             	sub    $0xc,%esp
  8035df:	ff 75 08             	pushl  0x8(%ebp)
  8035e2:	e8 0c fa ff ff       	call   802ff3 <free_block>
  8035e7:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8035ea:	83 ec 0c             	sub    $0xc,%esp
  8035ed:	ff 75 0c             	pushl  0xc(%ebp)
  8035f0:	e8 3a eb ff ff       	call   80212f <alloc_block_FF>
  8035f5:	83 c4 10             	add    $0x10,%esp
  8035f8:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8035fb:	83 ec 08             	sub    $0x8,%esp
  8035fe:	ff 75 c0             	pushl  -0x40(%ebp)
  803601:	ff 75 08             	pushl  0x8(%ebp)
  803604:	e8 ab fa ff ff       	call   8030b4 <copy_data>
  803609:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80360c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80360f:	e9 f8 01 00 00       	jmp    80380c <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803614:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803617:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80361a:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80361d:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803621:	0f 87 a0 00 00 00    	ja     8036c7 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803627:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80362b:	75 17                	jne    803644 <realloc_block_FF+0x551>
  80362d:	83 ec 04             	sub    $0x4,%esp
  803630:	68 87 43 80 00       	push   $0x804387
  803635:	68 38 02 00 00       	push   $0x238
  80363a:	68 a5 43 80 00       	push   $0x8043a5
  80363f:	e8 23 cc ff ff       	call   800267 <_panic>
  803644:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803647:	8b 00                	mov    (%eax),%eax
  803649:	85 c0                	test   %eax,%eax
  80364b:	74 10                	je     80365d <realloc_block_FF+0x56a>
  80364d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803650:	8b 00                	mov    (%eax),%eax
  803652:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803655:	8b 52 04             	mov    0x4(%edx),%edx
  803658:	89 50 04             	mov    %edx,0x4(%eax)
  80365b:	eb 0b                	jmp    803668 <realloc_block_FF+0x575>
  80365d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803660:	8b 40 04             	mov    0x4(%eax),%eax
  803663:	a3 30 50 80 00       	mov    %eax,0x805030
  803668:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80366b:	8b 40 04             	mov    0x4(%eax),%eax
  80366e:	85 c0                	test   %eax,%eax
  803670:	74 0f                	je     803681 <realloc_block_FF+0x58e>
  803672:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803675:	8b 40 04             	mov    0x4(%eax),%eax
  803678:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80367b:	8b 12                	mov    (%edx),%edx
  80367d:	89 10                	mov    %edx,(%eax)
  80367f:	eb 0a                	jmp    80368b <realloc_block_FF+0x598>
  803681:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803684:	8b 00                	mov    (%eax),%eax
  803686:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80368b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80368e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803694:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803697:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80369e:	a1 38 50 80 00       	mov    0x805038,%eax
  8036a3:	48                   	dec    %eax
  8036a4:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8036a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036af:	01 d0                	add    %edx,%eax
  8036b1:	83 ec 04             	sub    $0x4,%esp
  8036b4:	6a 01                	push   $0x1
  8036b6:	50                   	push   %eax
  8036b7:	ff 75 08             	pushl  0x8(%ebp)
  8036ba:	e8 41 ea ff ff       	call   802100 <set_block_data>
  8036bf:	83 c4 10             	add    $0x10,%esp
  8036c2:	e9 36 01 00 00       	jmp    8037fd <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8036c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036ca:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8036cd:	01 d0                	add    %edx,%eax
  8036cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8036d2:	83 ec 04             	sub    $0x4,%esp
  8036d5:	6a 01                	push   $0x1
  8036d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8036da:	ff 75 08             	pushl  0x8(%ebp)
  8036dd:	e8 1e ea ff ff       	call   802100 <set_block_data>
  8036e2:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8036e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e8:	83 e8 04             	sub    $0x4,%eax
  8036eb:	8b 00                	mov    (%eax),%eax
  8036ed:	83 e0 fe             	and    $0xfffffffe,%eax
  8036f0:	89 c2                	mov    %eax,%edx
  8036f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f5:	01 d0                	add    %edx,%eax
  8036f7:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8036fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036fe:	74 06                	je     803706 <realloc_block_FF+0x613>
  803700:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803704:	75 17                	jne    80371d <realloc_block_FF+0x62a>
  803706:	83 ec 04             	sub    $0x4,%esp
  803709:	68 18 44 80 00       	push   $0x804418
  80370e:	68 44 02 00 00       	push   $0x244
  803713:	68 a5 43 80 00       	push   $0x8043a5
  803718:	e8 4a cb ff ff       	call   800267 <_panic>
  80371d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803720:	8b 10                	mov    (%eax),%edx
  803722:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803725:	89 10                	mov    %edx,(%eax)
  803727:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80372a:	8b 00                	mov    (%eax),%eax
  80372c:	85 c0                	test   %eax,%eax
  80372e:	74 0b                	je     80373b <realloc_block_FF+0x648>
  803730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803733:	8b 00                	mov    (%eax),%eax
  803735:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803738:	89 50 04             	mov    %edx,0x4(%eax)
  80373b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80373e:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803741:	89 10                	mov    %edx,(%eax)
  803743:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803746:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803749:	89 50 04             	mov    %edx,0x4(%eax)
  80374c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80374f:	8b 00                	mov    (%eax),%eax
  803751:	85 c0                	test   %eax,%eax
  803753:	75 08                	jne    80375d <realloc_block_FF+0x66a>
  803755:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803758:	a3 30 50 80 00       	mov    %eax,0x805030
  80375d:	a1 38 50 80 00       	mov    0x805038,%eax
  803762:	40                   	inc    %eax
  803763:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803768:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80376c:	75 17                	jne    803785 <realloc_block_FF+0x692>
  80376e:	83 ec 04             	sub    $0x4,%esp
  803771:	68 87 43 80 00       	push   $0x804387
  803776:	68 45 02 00 00       	push   $0x245
  80377b:	68 a5 43 80 00       	push   $0x8043a5
  803780:	e8 e2 ca ff ff       	call   800267 <_panic>
  803785:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803788:	8b 00                	mov    (%eax),%eax
  80378a:	85 c0                	test   %eax,%eax
  80378c:	74 10                	je     80379e <realloc_block_FF+0x6ab>
  80378e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803791:	8b 00                	mov    (%eax),%eax
  803793:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803796:	8b 52 04             	mov    0x4(%edx),%edx
  803799:	89 50 04             	mov    %edx,0x4(%eax)
  80379c:	eb 0b                	jmp    8037a9 <realloc_block_FF+0x6b6>
  80379e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a1:	8b 40 04             	mov    0x4(%eax),%eax
  8037a4:	a3 30 50 80 00       	mov    %eax,0x805030
  8037a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ac:	8b 40 04             	mov    0x4(%eax),%eax
  8037af:	85 c0                	test   %eax,%eax
  8037b1:	74 0f                	je     8037c2 <realloc_block_FF+0x6cf>
  8037b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b6:	8b 40 04             	mov    0x4(%eax),%eax
  8037b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037bc:	8b 12                	mov    (%edx),%edx
  8037be:	89 10                	mov    %edx,(%eax)
  8037c0:	eb 0a                	jmp    8037cc <realloc_block_FF+0x6d9>
  8037c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c5:	8b 00                	mov    (%eax),%eax
  8037c7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037df:	a1 38 50 80 00       	mov    0x805038,%eax
  8037e4:	48                   	dec    %eax
  8037e5:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8037ea:	83 ec 04             	sub    $0x4,%esp
  8037ed:	6a 00                	push   $0x0
  8037ef:	ff 75 bc             	pushl  -0x44(%ebp)
  8037f2:	ff 75 b8             	pushl  -0x48(%ebp)
  8037f5:	e8 06 e9 ff ff       	call   802100 <set_block_data>
  8037fa:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8037fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803800:	eb 0a                	jmp    80380c <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803802:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803809:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80380c:	c9                   	leave  
  80380d:	c3                   	ret    

0080380e <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80380e:	55                   	push   %ebp
  80380f:	89 e5                	mov    %esp,%ebp
  803811:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803814:	83 ec 04             	sub    $0x4,%esp
  803817:	68 9c 44 80 00       	push   $0x80449c
  80381c:	68 58 02 00 00       	push   $0x258
  803821:	68 a5 43 80 00       	push   $0x8043a5
  803826:	e8 3c ca ff ff       	call   800267 <_panic>

0080382b <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80382b:	55                   	push   %ebp
  80382c:	89 e5                	mov    %esp,%ebp
  80382e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803831:	83 ec 04             	sub    $0x4,%esp
  803834:	68 c4 44 80 00       	push   $0x8044c4
  803839:	68 61 02 00 00       	push   $0x261
  80383e:	68 a5 43 80 00       	push   $0x8043a5
  803843:	e8 1f ca ff ff       	call   800267 <_panic>

00803848 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803848:	55                   	push   %ebp
  803849:	89 e5                	mov    %esp,%ebp
  80384b:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80384e:	8b 55 08             	mov    0x8(%ebp),%edx
  803851:	89 d0                	mov    %edx,%eax
  803853:	c1 e0 02             	shl    $0x2,%eax
  803856:	01 d0                	add    %edx,%eax
  803858:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80385f:	01 d0                	add    %edx,%eax
  803861:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803868:	01 d0                	add    %edx,%eax
  80386a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803871:	01 d0                	add    %edx,%eax
  803873:	c1 e0 04             	shl    $0x4,%eax
  803876:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803879:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803880:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803883:	83 ec 0c             	sub    $0xc,%esp
  803886:	50                   	push   %eax
  803887:	e8 2f e2 ff ff       	call   801abb <sys_get_virtual_time>
  80388c:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80388f:	eb 41                	jmp    8038d2 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803891:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803894:	83 ec 0c             	sub    $0xc,%esp
  803897:	50                   	push   %eax
  803898:	e8 1e e2 ff ff       	call   801abb <sys_get_virtual_time>
  80389d:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8038a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a6:	29 c2                	sub    %eax,%edx
  8038a8:	89 d0                	mov    %edx,%eax
  8038aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8038ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038b3:	89 d1                	mov    %edx,%ecx
  8038b5:	29 c1                	sub    %eax,%ecx
  8038b7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8038ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038bd:	39 c2                	cmp    %eax,%edx
  8038bf:	0f 97 c0             	seta   %al
  8038c2:	0f b6 c0             	movzbl %al,%eax
  8038c5:	29 c1                	sub    %eax,%ecx
  8038c7:	89 c8                	mov    %ecx,%eax
  8038c9:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8038cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8038d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8038d8:	72 b7                	jb     803891 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8038da:	90                   	nop
  8038db:	c9                   	leave  
  8038dc:	c3                   	ret    

008038dd <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8038dd:	55                   	push   %ebp
  8038de:	89 e5                	mov    %esp,%ebp
  8038e0:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8038e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8038ea:	eb 03                	jmp    8038ef <busy_wait+0x12>
  8038ec:	ff 45 fc             	incl   -0x4(%ebp)
  8038ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8038f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038f5:	72 f5                	jb     8038ec <busy_wait+0xf>
	return i;
  8038f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8038fa:	c9                   	leave  
  8038fb:	c3                   	ret    

008038fc <__udivdi3>:
  8038fc:	55                   	push   %ebp
  8038fd:	57                   	push   %edi
  8038fe:	56                   	push   %esi
  8038ff:	53                   	push   %ebx
  803900:	83 ec 1c             	sub    $0x1c,%esp
  803903:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803907:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80390b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80390f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803913:	89 ca                	mov    %ecx,%edx
  803915:	89 f8                	mov    %edi,%eax
  803917:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80391b:	85 f6                	test   %esi,%esi
  80391d:	75 2d                	jne    80394c <__udivdi3+0x50>
  80391f:	39 cf                	cmp    %ecx,%edi
  803921:	77 65                	ja     803988 <__udivdi3+0x8c>
  803923:	89 fd                	mov    %edi,%ebp
  803925:	85 ff                	test   %edi,%edi
  803927:	75 0b                	jne    803934 <__udivdi3+0x38>
  803929:	b8 01 00 00 00       	mov    $0x1,%eax
  80392e:	31 d2                	xor    %edx,%edx
  803930:	f7 f7                	div    %edi
  803932:	89 c5                	mov    %eax,%ebp
  803934:	31 d2                	xor    %edx,%edx
  803936:	89 c8                	mov    %ecx,%eax
  803938:	f7 f5                	div    %ebp
  80393a:	89 c1                	mov    %eax,%ecx
  80393c:	89 d8                	mov    %ebx,%eax
  80393e:	f7 f5                	div    %ebp
  803940:	89 cf                	mov    %ecx,%edi
  803942:	89 fa                	mov    %edi,%edx
  803944:	83 c4 1c             	add    $0x1c,%esp
  803947:	5b                   	pop    %ebx
  803948:	5e                   	pop    %esi
  803949:	5f                   	pop    %edi
  80394a:	5d                   	pop    %ebp
  80394b:	c3                   	ret    
  80394c:	39 ce                	cmp    %ecx,%esi
  80394e:	77 28                	ja     803978 <__udivdi3+0x7c>
  803950:	0f bd fe             	bsr    %esi,%edi
  803953:	83 f7 1f             	xor    $0x1f,%edi
  803956:	75 40                	jne    803998 <__udivdi3+0x9c>
  803958:	39 ce                	cmp    %ecx,%esi
  80395a:	72 0a                	jb     803966 <__udivdi3+0x6a>
  80395c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803960:	0f 87 9e 00 00 00    	ja     803a04 <__udivdi3+0x108>
  803966:	b8 01 00 00 00       	mov    $0x1,%eax
  80396b:	89 fa                	mov    %edi,%edx
  80396d:	83 c4 1c             	add    $0x1c,%esp
  803970:	5b                   	pop    %ebx
  803971:	5e                   	pop    %esi
  803972:	5f                   	pop    %edi
  803973:	5d                   	pop    %ebp
  803974:	c3                   	ret    
  803975:	8d 76 00             	lea    0x0(%esi),%esi
  803978:	31 ff                	xor    %edi,%edi
  80397a:	31 c0                	xor    %eax,%eax
  80397c:	89 fa                	mov    %edi,%edx
  80397e:	83 c4 1c             	add    $0x1c,%esp
  803981:	5b                   	pop    %ebx
  803982:	5e                   	pop    %esi
  803983:	5f                   	pop    %edi
  803984:	5d                   	pop    %ebp
  803985:	c3                   	ret    
  803986:	66 90                	xchg   %ax,%ax
  803988:	89 d8                	mov    %ebx,%eax
  80398a:	f7 f7                	div    %edi
  80398c:	31 ff                	xor    %edi,%edi
  80398e:	89 fa                	mov    %edi,%edx
  803990:	83 c4 1c             	add    $0x1c,%esp
  803993:	5b                   	pop    %ebx
  803994:	5e                   	pop    %esi
  803995:	5f                   	pop    %edi
  803996:	5d                   	pop    %ebp
  803997:	c3                   	ret    
  803998:	bd 20 00 00 00       	mov    $0x20,%ebp
  80399d:	89 eb                	mov    %ebp,%ebx
  80399f:	29 fb                	sub    %edi,%ebx
  8039a1:	89 f9                	mov    %edi,%ecx
  8039a3:	d3 e6                	shl    %cl,%esi
  8039a5:	89 c5                	mov    %eax,%ebp
  8039a7:	88 d9                	mov    %bl,%cl
  8039a9:	d3 ed                	shr    %cl,%ebp
  8039ab:	89 e9                	mov    %ebp,%ecx
  8039ad:	09 f1                	or     %esi,%ecx
  8039af:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8039b3:	89 f9                	mov    %edi,%ecx
  8039b5:	d3 e0                	shl    %cl,%eax
  8039b7:	89 c5                	mov    %eax,%ebp
  8039b9:	89 d6                	mov    %edx,%esi
  8039bb:	88 d9                	mov    %bl,%cl
  8039bd:	d3 ee                	shr    %cl,%esi
  8039bf:	89 f9                	mov    %edi,%ecx
  8039c1:	d3 e2                	shl    %cl,%edx
  8039c3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039c7:	88 d9                	mov    %bl,%cl
  8039c9:	d3 e8                	shr    %cl,%eax
  8039cb:	09 c2                	or     %eax,%edx
  8039cd:	89 d0                	mov    %edx,%eax
  8039cf:	89 f2                	mov    %esi,%edx
  8039d1:	f7 74 24 0c          	divl   0xc(%esp)
  8039d5:	89 d6                	mov    %edx,%esi
  8039d7:	89 c3                	mov    %eax,%ebx
  8039d9:	f7 e5                	mul    %ebp
  8039db:	39 d6                	cmp    %edx,%esi
  8039dd:	72 19                	jb     8039f8 <__udivdi3+0xfc>
  8039df:	74 0b                	je     8039ec <__udivdi3+0xf0>
  8039e1:	89 d8                	mov    %ebx,%eax
  8039e3:	31 ff                	xor    %edi,%edi
  8039e5:	e9 58 ff ff ff       	jmp    803942 <__udivdi3+0x46>
  8039ea:	66 90                	xchg   %ax,%ax
  8039ec:	8b 54 24 08          	mov    0x8(%esp),%edx
  8039f0:	89 f9                	mov    %edi,%ecx
  8039f2:	d3 e2                	shl    %cl,%edx
  8039f4:	39 c2                	cmp    %eax,%edx
  8039f6:	73 e9                	jae    8039e1 <__udivdi3+0xe5>
  8039f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8039fb:	31 ff                	xor    %edi,%edi
  8039fd:	e9 40 ff ff ff       	jmp    803942 <__udivdi3+0x46>
  803a02:	66 90                	xchg   %ax,%ax
  803a04:	31 c0                	xor    %eax,%eax
  803a06:	e9 37 ff ff ff       	jmp    803942 <__udivdi3+0x46>
  803a0b:	90                   	nop

00803a0c <__umoddi3>:
  803a0c:	55                   	push   %ebp
  803a0d:	57                   	push   %edi
  803a0e:	56                   	push   %esi
  803a0f:	53                   	push   %ebx
  803a10:	83 ec 1c             	sub    $0x1c,%esp
  803a13:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a17:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a1f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a23:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a27:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a2b:	89 f3                	mov    %esi,%ebx
  803a2d:	89 fa                	mov    %edi,%edx
  803a2f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a33:	89 34 24             	mov    %esi,(%esp)
  803a36:	85 c0                	test   %eax,%eax
  803a38:	75 1a                	jne    803a54 <__umoddi3+0x48>
  803a3a:	39 f7                	cmp    %esi,%edi
  803a3c:	0f 86 a2 00 00 00    	jbe    803ae4 <__umoddi3+0xd8>
  803a42:	89 c8                	mov    %ecx,%eax
  803a44:	89 f2                	mov    %esi,%edx
  803a46:	f7 f7                	div    %edi
  803a48:	89 d0                	mov    %edx,%eax
  803a4a:	31 d2                	xor    %edx,%edx
  803a4c:	83 c4 1c             	add    $0x1c,%esp
  803a4f:	5b                   	pop    %ebx
  803a50:	5e                   	pop    %esi
  803a51:	5f                   	pop    %edi
  803a52:	5d                   	pop    %ebp
  803a53:	c3                   	ret    
  803a54:	39 f0                	cmp    %esi,%eax
  803a56:	0f 87 ac 00 00 00    	ja     803b08 <__umoddi3+0xfc>
  803a5c:	0f bd e8             	bsr    %eax,%ebp
  803a5f:	83 f5 1f             	xor    $0x1f,%ebp
  803a62:	0f 84 ac 00 00 00    	je     803b14 <__umoddi3+0x108>
  803a68:	bf 20 00 00 00       	mov    $0x20,%edi
  803a6d:	29 ef                	sub    %ebp,%edi
  803a6f:	89 fe                	mov    %edi,%esi
  803a71:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a75:	89 e9                	mov    %ebp,%ecx
  803a77:	d3 e0                	shl    %cl,%eax
  803a79:	89 d7                	mov    %edx,%edi
  803a7b:	89 f1                	mov    %esi,%ecx
  803a7d:	d3 ef                	shr    %cl,%edi
  803a7f:	09 c7                	or     %eax,%edi
  803a81:	89 e9                	mov    %ebp,%ecx
  803a83:	d3 e2                	shl    %cl,%edx
  803a85:	89 14 24             	mov    %edx,(%esp)
  803a88:	89 d8                	mov    %ebx,%eax
  803a8a:	d3 e0                	shl    %cl,%eax
  803a8c:	89 c2                	mov    %eax,%edx
  803a8e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a92:	d3 e0                	shl    %cl,%eax
  803a94:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a98:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a9c:	89 f1                	mov    %esi,%ecx
  803a9e:	d3 e8                	shr    %cl,%eax
  803aa0:	09 d0                	or     %edx,%eax
  803aa2:	d3 eb                	shr    %cl,%ebx
  803aa4:	89 da                	mov    %ebx,%edx
  803aa6:	f7 f7                	div    %edi
  803aa8:	89 d3                	mov    %edx,%ebx
  803aaa:	f7 24 24             	mull   (%esp)
  803aad:	89 c6                	mov    %eax,%esi
  803aaf:	89 d1                	mov    %edx,%ecx
  803ab1:	39 d3                	cmp    %edx,%ebx
  803ab3:	0f 82 87 00 00 00    	jb     803b40 <__umoddi3+0x134>
  803ab9:	0f 84 91 00 00 00    	je     803b50 <__umoddi3+0x144>
  803abf:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ac3:	29 f2                	sub    %esi,%edx
  803ac5:	19 cb                	sbb    %ecx,%ebx
  803ac7:	89 d8                	mov    %ebx,%eax
  803ac9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803acd:	d3 e0                	shl    %cl,%eax
  803acf:	89 e9                	mov    %ebp,%ecx
  803ad1:	d3 ea                	shr    %cl,%edx
  803ad3:	09 d0                	or     %edx,%eax
  803ad5:	89 e9                	mov    %ebp,%ecx
  803ad7:	d3 eb                	shr    %cl,%ebx
  803ad9:	89 da                	mov    %ebx,%edx
  803adb:	83 c4 1c             	add    $0x1c,%esp
  803ade:	5b                   	pop    %ebx
  803adf:	5e                   	pop    %esi
  803ae0:	5f                   	pop    %edi
  803ae1:	5d                   	pop    %ebp
  803ae2:	c3                   	ret    
  803ae3:	90                   	nop
  803ae4:	89 fd                	mov    %edi,%ebp
  803ae6:	85 ff                	test   %edi,%edi
  803ae8:	75 0b                	jne    803af5 <__umoddi3+0xe9>
  803aea:	b8 01 00 00 00       	mov    $0x1,%eax
  803aef:	31 d2                	xor    %edx,%edx
  803af1:	f7 f7                	div    %edi
  803af3:	89 c5                	mov    %eax,%ebp
  803af5:	89 f0                	mov    %esi,%eax
  803af7:	31 d2                	xor    %edx,%edx
  803af9:	f7 f5                	div    %ebp
  803afb:	89 c8                	mov    %ecx,%eax
  803afd:	f7 f5                	div    %ebp
  803aff:	89 d0                	mov    %edx,%eax
  803b01:	e9 44 ff ff ff       	jmp    803a4a <__umoddi3+0x3e>
  803b06:	66 90                	xchg   %ax,%ax
  803b08:	89 c8                	mov    %ecx,%eax
  803b0a:	89 f2                	mov    %esi,%edx
  803b0c:	83 c4 1c             	add    $0x1c,%esp
  803b0f:	5b                   	pop    %ebx
  803b10:	5e                   	pop    %esi
  803b11:	5f                   	pop    %edi
  803b12:	5d                   	pop    %ebp
  803b13:	c3                   	ret    
  803b14:	3b 04 24             	cmp    (%esp),%eax
  803b17:	72 06                	jb     803b1f <__umoddi3+0x113>
  803b19:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b1d:	77 0f                	ja     803b2e <__umoddi3+0x122>
  803b1f:	89 f2                	mov    %esi,%edx
  803b21:	29 f9                	sub    %edi,%ecx
  803b23:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b27:	89 14 24             	mov    %edx,(%esp)
  803b2a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b2e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b32:	8b 14 24             	mov    (%esp),%edx
  803b35:	83 c4 1c             	add    $0x1c,%esp
  803b38:	5b                   	pop    %ebx
  803b39:	5e                   	pop    %esi
  803b3a:	5f                   	pop    %edi
  803b3b:	5d                   	pop    %ebp
  803b3c:	c3                   	ret    
  803b3d:	8d 76 00             	lea    0x0(%esi),%esi
  803b40:	2b 04 24             	sub    (%esp),%eax
  803b43:	19 fa                	sbb    %edi,%edx
  803b45:	89 d1                	mov    %edx,%ecx
  803b47:	89 c6                	mov    %eax,%esi
  803b49:	e9 71 ff ff ff       	jmp    803abf <__umoddi3+0xb3>
  803b4e:	66 90                	xchg   %ax,%ax
  803b50:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b54:	72 ea                	jb     803b40 <__umoddi3+0x134>
  803b56:	89 d9                	mov    %ebx,%ecx
  803b58:	e9 62 ff ff ff       	jmp    803abf <__umoddi3+0xb3>
