
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
  80005b:	68 e0 3b 80 00       	push   $0x803be0
  800060:	6a 0c                	push   $0xc
  800062:	68 fc 3b 80 00       	push   $0x803bfc
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
  800073:	e8 8d 1a 00 00       	call   801b05 <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 19 3c 80 00       	push   $0x803c19
  800080:	50                   	push   %eax
  800081:	e8 23 16 00 00       	call   8016a9 <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 1c 3c 80 00       	push   $0x803c1c
  800094:	e8 8b 04 00 00       	call   800524 <cprintf>
  800099:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got x
	inctst();
  80009c:	e8 89 1b 00 00       	call   801c2a <inctst>
	cprintf("Slave B1 please be patient ...\n");
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	68 44 3c 80 00       	push   $0x803c44
  8000a9:	e8 76 04 00 00       	call   800524 <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(6000);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 70 17 00 00       	push   $0x1770
  8000b9:	e8 07 38 00 00       	call   8038c5 <env_sleep>
  8000be:	83 c4 10             	add    $0x10,%esp
	while (gettst()!=2) ;// panic("test failed");
  8000c1:	90                   	nop
  8000c2:	e8 7d 1b 00 00       	call   801c44 <gettst>
  8000c7:	83 f8 02             	cmp    $0x2,%eax
  8000ca:	75 f6                	jne    8000c2 <_main+0x8a>

	freeFrames = sys_calculate_free_frames() ;
  8000cc:	e8 52 18 00 00       	call   801923 <sys_calculate_free_frames>
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	sfree(x);
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000da:	e8 72 16 00 00       	call   801751 <sfree>
  8000df:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 64 3c 80 00       	push   $0x803c64
  8000ea:	e8 35 04 00 00       	call   800524 <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
	expected = 1+1; /*1page+1table*/
  8000f2:	c7 45 e8 02 00 00 00 	movl   $0x2,-0x18(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  8000f9:	e8 25 18 00 00       	call   801923 <sys_calculate_free_frames>
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800103:	29 c2                	sub    %eax,%edx
  800105:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800108:	39 c2                	cmp    %eax,%edx
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 7c 3c 80 00       	push   $0x803c7c
  800114:	6a 26                	push   $0x26
  800116:	68 fc 3b 80 00       	push   $0x803bfc
  80011b:	e8 47 01 00 00       	call   800267 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800120:	e8 05 1b 00 00       	call   801c2a <inctst>
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
  80012e:	e8 b9 19 00 00       	call   801aec <sys_getenvindex>
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
  80019c:	e8 cf 16 00 00       	call   801870 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001a1:	83 ec 0c             	sub    $0xc,%esp
  8001a4:	68 3c 3d 80 00       	push   $0x803d3c
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
  8001cc:	68 64 3d 80 00       	push   $0x803d64
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
  8001fd:	68 8c 3d 80 00       	push   $0x803d8c
  800202:	e8 1d 03 00 00       	call   800524 <cprintf>
  800207:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80020a:	a1 20 50 80 00       	mov    0x805020,%eax
  80020f:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800215:	83 ec 08             	sub    $0x8,%esp
  800218:	50                   	push   %eax
  800219:	68 e4 3d 80 00       	push   $0x803de4
  80021e:	e8 01 03 00 00       	call   800524 <cprintf>
  800223:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800226:	83 ec 0c             	sub    $0xc,%esp
  800229:	68 3c 3d 80 00       	push   $0x803d3c
  80022e:	e8 f1 02 00 00       	call   800524 <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800236:	e8 4f 16 00 00       	call   80188a <sys_unlock_cons>
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
  80024e:	e8 65 18 00 00       	call   801ab8 <sys_destroy_env>
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
  80025f:	e8 ba 18 00 00       	call   801b1e <sys_exit_env>
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
  800288:	68 f8 3d 80 00       	push   $0x803df8
  80028d:	e8 92 02 00 00       	call   800524 <cprintf>
  800292:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800295:	a1 00 50 80 00       	mov    0x805000,%eax
  80029a:	ff 75 0c             	pushl  0xc(%ebp)
  80029d:	ff 75 08             	pushl  0x8(%ebp)
  8002a0:	50                   	push   %eax
  8002a1:	68 fd 3d 80 00       	push   $0x803dfd
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
  8002c5:	68 19 3e 80 00       	push   $0x803e19
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
  8002f4:	68 1c 3e 80 00       	push   $0x803e1c
  8002f9:	6a 26                	push   $0x26
  8002fb:	68 68 3e 80 00       	push   $0x803e68
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
  8003c9:	68 74 3e 80 00       	push   $0x803e74
  8003ce:	6a 3a                	push   $0x3a
  8003d0:	68 68 3e 80 00       	push   $0x803e68
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
  80043c:	68 c8 3e 80 00       	push   $0x803ec8
  800441:	6a 44                	push   $0x44
  800443:	68 68 3e 80 00       	push   $0x803e68
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
  800496:	e8 93 13 00 00       	call   80182e <sys_cputs>
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
  80050d:	e8 1c 13 00 00       	call   80182e <sys_cputs>
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
  800557:	e8 14 13 00 00       	call   801870 <sys_lock_cons>
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
  800577:	e8 0e 13 00 00       	call   80188a <sys_unlock_cons>
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
  8005c1:	e8 b6 33 00 00       	call   80397c <__udivdi3>
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
  800611:	e8 76 34 00 00       	call   803a8c <__umoddi3>
  800616:	83 c4 10             	add    $0x10,%esp
  800619:	05 34 41 80 00       	add    $0x804134,%eax
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
  80076c:	8b 04 85 58 41 80 00 	mov    0x804158(,%eax,4),%eax
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
  80084d:	8b 34 9d a0 3f 80 00 	mov    0x803fa0(,%ebx,4),%esi
  800854:	85 f6                	test   %esi,%esi
  800856:	75 19                	jne    800871 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800858:	53                   	push   %ebx
  800859:	68 45 41 80 00       	push   $0x804145
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
  800872:	68 4e 41 80 00       	push   $0x80414e
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
  80089f:	be 51 41 80 00       	mov    $0x804151,%esi
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
  8012aa:	68 c8 42 80 00       	push   $0x8042c8
  8012af:	68 3f 01 00 00       	push   $0x13f
  8012b4:	68 ea 42 80 00       	push   $0x8042ea
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
  8012ca:	e8 0a 0b 00 00       	call   801dd9 <sys_sbrk>
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
  801345:	e8 13 09 00 00       	call   801c5d <sys_isUHeapPlacementStrategyFIRSTFIT>
  80134a:	85 c0                	test   %eax,%eax
  80134c:	74 16                	je     801364 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80134e:	83 ec 0c             	sub    $0xc,%esp
  801351:	ff 75 08             	pushl  0x8(%ebp)
  801354:	e8 53 0e 00 00       	call   8021ac <alloc_block_FF>
  801359:	83 c4 10             	add    $0x10,%esp
  80135c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80135f:	e9 8a 01 00 00       	jmp    8014ee <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801364:	e8 25 09 00 00       	call   801c8e <sys_isUHeapPlacementStrategyBESTFIT>
  801369:	85 c0                	test   %eax,%eax
  80136b:	0f 84 7d 01 00 00    	je     8014ee <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801371:	83 ec 0c             	sub    $0xc,%esp
  801374:	ff 75 08             	pushl  0x8(%ebp)
  801377:	e8 ec 12 00 00       	call   802668 <alloc_block_BF>
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
  8013c7:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801414:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  80146b:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
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
  8014cd:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8014d4:	83 ec 08             	sub    $0x8,%esp
  8014d7:	ff 75 08             	pushl  0x8(%ebp)
  8014da:	ff 75 f0             	pushl  -0x10(%ebp)
  8014dd:	e8 2e 09 00 00       	call   801e10 <sys_allocate_user_mem>
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
  801525:	e8 02 09 00 00       	call   801e2c <get_block_size>
  80152a:	83 c4 10             	add    $0x10,%esp
  80152d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801530:	83 ec 0c             	sub    $0xc,%esp
  801533:	ff 75 08             	pushl  0x8(%ebp)
  801536:	e8 35 1b 00 00       	call   803070 <free_block>
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
  801570:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  8015ad:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
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
  8015cd:	e8 22 08 00 00       	call   801df4 <sys_free_user_mem>
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
  8015db:	68 f8 42 80 00       	push   $0x8042f8
  8015e0:	68 85 00 00 00       	push   $0x85
  8015e5:	68 22 43 80 00       	push   $0x804322
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
  801601:	75 0a                	jne    80160d <smalloc+0x1c>
  801603:	b8 00 00 00 00       	mov    $0x0,%eax
  801608:	e9 9a 00 00 00       	jmp    8016a7 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  80160d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801610:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801613:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80161a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80161d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801620:	39 d0                	cmp    %edx,%eax
  801622:	73 02                	jae    801626 <smalloc+0x35>
  801624:	89 d0                	mov    %edx,%eax
  801626:	83 ec 0c             	sub    $0xc,%esp
  801629:	50                   	push   %eax
  80162a:	e8 a5 fc ff ff       	call   8012d4 <malloc>
  80162f:	83 c4 10             	add    $0x10,%esp
  801632:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801635:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801639:	75 07                	jne    801642 <smalloc+0x51>
  80163b:	b8 00 00 00 00       	mov    $0x0,%eax
  801640:	eb 65                	jmp    8016a7 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801642:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801646:	ff 75 ec             	pushl  -0x14(%ebp)
  801649:	50                   	push   %eax
  80164a:	ff 75 0c             	pushl  0xc(%ebp)
  80164d:	ff 75 08             	pushl  0x8(%ebp)
  801650:	e8 a6 03 00 00       	call   8019fb <sys_createSharedObject>
  801655:	83 c4 10             	add    $0x10,%esp
  801658:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80165b:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80165f:	74 06                	je     801667 <smalloc+0x76>
  801661:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801665:	75 07                	jne    80166e <smalloc+0x7d>
  801667:	b8 00 00 00 00       	mov    $0x0,%eax
  80166c:	eb 39                	jmp    8016a7 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  80166e:	83 ec 08             	sub    $0x8,%esp
  801671:	ff 75 ec             	pushl  -0x14(%ebp)
  801674:	68 2e 43 80 00       	push   $0x80432e
  801679:	e8 a6 ee ff ff       	call   800524 <cprintf>
  80167e:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801681:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801684:	a1 20 50 80 00       	mov    0x805020,%eax
  801689:	8b 40 78             	mov    0x78(%eax),%eax
  80168c:	29 c2                	sub    %eax,%edx
  80168e:	89 d0                	mov    %edx,%eax
  801690:	2d 00 10 00 00       	sub    $0x1000,%eax
  801695:	c1 e8 0c             	shr    $0xc,%eax
  801698:	89 c2                	mov    %eax,%edx
  80169a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80169d:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8016a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    

008016a9 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016af:	83 ec 08             	sub    $0x8,%esp
  8016b2:	ff 75 0c             	pushl  0xc(%ebp)
  8016b5:	ff 75 08             	pushl  0x8(%ebp)
  8016b8:	e8 68 03 00 00       	call   801a25 <sys_getSizeOfSharedObject>
  8016bd:	83 c4 10             	add    $0x10,%esp
  8016c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8016c3:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016c7:	75 07                	jne    8016d0 <sget+0x27>
  8016c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ce:	eb 7f                	jmp    80174f <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8016d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016d6:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e3:	39 d0                	cmp    %edx,%eax
  8016e5:	7d 02                	jge    8016e9 <sget+0x40>
  8016e7:	89 d0                	mov    %edx,%eax
  8016e9:	83 ec 0c             	sub    $0xc,%esp
  8016ec:	50                   	push   %eax
  8016ed:	e8 e2 fb ff ff       	call   8012d4 <malloc>
  8016f2:	83 c4 10             	add    $0x10,%esp
  8016f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8016f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016fc:	75 07                	jne    801705 <sget+0x5c>
  8016fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801703:	eb 4a                	jmp    80174f <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801705:	83 ec 04             	sub    $0x4,%esp
  801708:	ff 75 e8             	pushl  -0x18(%ebp)
  80170b:	ff 75 0c             	pushl  0xc(%ebp)
  80170e:	ff 75 08             	pushl  0x8(%ebp)
  801711:	e8 2c 03 00 00       	call   801a42 <sys_getSharedObject>
  801716:	83 c4 10             	add    $0x10,%esp
  801719:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  80171c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80171f:	a1 20 50 80 00       	mov    0x805020,%eax
  801724:	8b 40 78             	mov    0x78(%eax),%eax
  801727:	29 c2                	sub    %eax,%edx
  801729:	89 d0                	mov    %edx,%eax
  80172b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801730:	c1 e8 0c             	shr    $0xc,%eax
  801733:	89 c2                	mov    %eax,%edx
  801735:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801738:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80173f:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801743:	75 07                	jne    80174c <sget+0xa3>
  801745:	b8 00 00 00 00       	mov    $0x0,%eax
  80174a:	eb 03                	jmp    80174f <sget+0xa6>
	return ptr;
  80174c:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
  801754:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801757:	8b 55 08             	mov    0x8(%ebp),%edx
  80175a:	a1 20 50 80 00       	mov    0x805020,%eax
  80175f:	8b 40 78             	mov    0x78(%eax),%eax
  801762:	29 c2                	sub    %eax,%edx
  801764:	89 d0                	mov    %edx,%eax
  801766:	2d 00 10 00 00       	sub    $0x1000,%eax
  80176b:	c1 e8 0c             	shr    $0xc,%eax
  80176e:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801775:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801778:	83 ec 08             	sub    $0x8,%esp
  80177b:	ff 75 08             	pushl  0x8(%ebp)
  80177e:	ff 75 f4             	pushl  -0xc(%ebp)
  801781:	e8 db 02 00 00       	call   801a61 <sys_freeSharedObject>
  801786:	83 c4 10             	add    $0x10,%esp
  801789:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  80178c:	90                   	nop
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
  801792:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801795:	83 ec 04             	sub    $0x4,%esp
  801798:	68 40 43 80 00       	push   $0x804340
  80179d:	68 de 00 00 00       	push   $0xde
  8017a2:	68 22 43 80 00       	push   $0x804322
  8017a7:	e8 bb ea ff ff       	call   800267 <_panic>

008017ac <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017b2:	83 ec 04             	sub    $0x4,%esp
  8017b5:	68 66 43 80 00       	push   $0x804366
  8017ba:	68 ea 00 00 00       	push   $0xea
  8017bf:	68 22 43 80 00       	push   $0x804322
  8017c4:	e8 9e ea ff ff       	call   800267 <_panic>

008017c9 <shrink>:

}
void shrink(uint32 newSize)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017cf:	83 ec 04             	sub    $0x4,%esp
  8017d2:	68 66 43 80 00       	push   $0x804366
  8017d7:	68 ef 00 00 00       	push   $0xef
  8017dc:	68 22 43 80 00       	push   $0x804322
  8017e1:	e8 81 ea ff ff       	call   800267 <_panic>

008017e6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ec:	83 ec 04             	sub    $0x4,%esp
  8017ef:	68 66 43 80 00       	push   $0x804366
  8017f4:	68 f4 00 00 00       	push   $0xf4
  8017f9:	68 22 43 80 00       	push   $0x804322
  8017fe:	e8 64 ea ff ff       	call   800267 <_panic>

00801803 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	57                   	push   %edi
  801807:	56                   	push   %esi
  801808:	53                   	push   %ebx
  801809:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80180c:	8b 45 08             	mov    0x8(%ebp),%eax
  80180f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801812:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801815:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801818:	8b 7d 18             	mov    0x18(%ebp),%edi
  80181b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80181e:	cd 30                	int    $0x30
  801820:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801823:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801826:	83 c4 10             	add    $0x10,%esp
  801829:	5b                   	pop    %ebx
  80182a:	5e                   	pop    %esi
  80182b:	5f                   	pop    %edi
  80182c:	5d                   	pop    %ebp
  80182d:	c3                   	ret    

0080182e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
  801831:	83 ec 04             	sub    $0x4,%esp
  801834:	8b 45 10             	mov    0x10(%ebp),%eax
  801837:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80183a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	52                   	push   %edx
  801846:	ff 75 0c             	pushl  0xc(%ebp)
  801849:	50                   	push   %eax
  80184a:	6a 00                	push   $0x0
  80184c:	e8 b2 ff ff ff       	call   801803 <syscall>
  801851:	83 c4 18             	add    $0x18,%esp
}
  801854:	90                   	nop
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <sys_cgetc>:

int
sys_cgetc(void)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 02                	push   $0x2
  801866:	e8 98 ff ff ff       	call   801803 <syscall>
  80186b:	83 c4 18             	add    $0x18,%esp
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 03                	push   $0x3
  80187f:	e8 7f ff ff ff       	call   801803 <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
}
  801887:	90                   	nop
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 04                	push   $0x4
  801899:	e8 65 ff ff ff       	call   801803 <syscall>
  80189e:	83 c4 18             	add    $0x18,%esp
}
  8018a1:	90                   	nop
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	52                   	push   %edx
  8018b4:	50                   	push   %eax
  8018b5:	6a 08                	push   $0x8
  8018b7:	e8 47 ff ff ff       	call   801803 <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	56                   	push   %esi
  8018c5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018c6:	8b 75 18             	mov    0x18(%ebp),%esi
  8018c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	56                   	push   %esi
  8018d6:	53                   	push   %ebx
  8018d7:	51                   	push   %ecx
  8018d8:	52                   	push   %edx
  8018d9:	50                   	push   %eax
  8018da:	6a 09                	push   $0x9
  8018dc:	e8 22 ff ff ff       	call   801803 <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e7:	5b                   	pop    %ebx
  8018e8:	5e                   	pop    %esi
  8018e9:	5d                   	pop    %ebp
  8018ea:	c3                   	ret    

008018eb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	52                   	push   %edx
  8018fb:	50                   	push   %eax
  8018fc:	6a 0a                	push   $0xa
  8018fe:	e8 00 ff ff ff       	call   801803 <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	ff 75 0c             	pushl  0xc(%ebp)
  801914:	ff 75 08             	pushl  0x8(%ebp)
  801917:	6a 0b                	push   $0xb
  801919:	e8 e5 fe ff ff       	call   801803 <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 0c                	push   $0xc
  801932:	e8 cc fe ff ff       	call   801803 <syscall>
  801937:	83 c4 18             	add    $0x18,%esp
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 0d                	push   $0xd
  80194b:	e8 b3 fe ff ff       	call   801803 <syscall>
  801950:	83 c4 18             	add    $0x18,%esp
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 0e                	push   $0xe
  801964:	e8 9a fe ff ff       	call   801803 <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 0f                	push   $0xf
  80197d:	e8 81 fe ff ff       	call   801803 <syscall>
  801982:	83 c4 18             	add    $0x18,%esp
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	ff 75 08             	pushl  0x8(%ebp)
  801995:	6a 10                	push   $0x10
  801997:	e8 67 fe ff ff       	call   801803 <syscall>
  80199c:	83 c4 18             	add    $0x18,%esp
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 11                	push   $0x11
  8019b0:	e8 4e fe ff ff       	call   801803 <syscall>
  8019b5:	83 c4 18             	add    $0x18,%esp
}
  8019b8:	90                   	nop
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <sys_cputc>:

void
sys_cputc(const char c)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	83 ec 04             	sub    $0x4,%esp
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019c7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	50                   	push   %eax
  8019d4:	6a 01                	push   $0x1
  8019d6:	e8 28 fe ff ff       	call   801803 <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	90                   	nop
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 14                	push   $0x14
  8019f0:	e8 0e fe ff ff       	call   801803 <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
}
  8019f8:	90                   	nop
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
  8019fe:	83 ec 04             	sub    $0x4,%esp
  801a01:	8b 45 10             	mov    0x10(%ebp),%eax
  801a04:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a07:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a0a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	6a 00                	push   $0x0
  801a13:	51                   	push   %ecx
  801a14:	52                   	push   %edx
  801a15:	ff 75 0c             	pushl  0xc(%ebp)
  801a18:	50                   	push   %eax
  801a19:	6a 15                	push   $0x15
  801a1b:	e8 e3 fd ff ff       	call   801803 <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	52                   	push   %edx
  801a35:	50                   	push   %eax
  801a36:	6a 16                	push   $0x16
  801a38:	e8 c6 fd ff ff       	call   801803 <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a45:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	51                   	push   %ecx
  801a53:	52                   	push   %edx
  801a54:	50                   	push   %eax
  801a55:	6a 17                	push   $0x17
  801a57:	e8 a7 fd ff ff       	call   801803 <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	52                   	push   %edx
  801a71:	50                   	push   %eax
  801a72:	6a 18                	push   $0x18
  801a74:	e8 8a fd ff ff       	call   801803 <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	6a 00                	push   $0x0
  801a86:	ff 75 14             	pushl  0x14(%ebp)
  801a89:	ff 75 10             	pushl  0x10(%ebp)
  801a8c:	ff 75 0c             	pushl  0xc(%ebp)
  801a8f:	50                   	push   %eax
  801a90:	6a 19                	push   $0x19
  801a92:	e8 6c fd ff ff       	call   801803 <syscall>
  801a97:	83 c4 18             	add    $0x18,%esp
}
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    

00801a9c <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	50                   	push   %eax
  801aab:	6a 1a                	push   $0x1a
  801aad:	e8 51 fd ff ff       	call   801803 <syscall>
  801ab2:	83 c4 18             	add    $0x18,%esp
}
  801ab5:	90                   	nop
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	50                   	push   %eax
  801ac7:	6a 1b                	push   $0x1b
  801ac9:	e8 35 fd ff ff       	call   801803 <syscall>
  801ace:	83 c4 18             	add    $0x18,%esp
}
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 05                	push   $0x5
  801ae2:	e8 1c fd ff ff       	call   801803 <syscall>
  801ae7:	83 c4 18             	add    $0x18,%esp
}
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 06                	push   $0x6
  801afb:	e8 03 fd ff ff       	call   801803 <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 07                	push   $0x7
  801b14:	e8 ea fc ff ff       	call   801803 <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_exit_env>:


void sys_exit_env(void)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 1c                	push   $0x1c
  801b2d:	e8 d1 fc ff ff       	call   801803 <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	90                   	nop
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
  801b3b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b3e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b41:	8d 50 04             	lea    0x4(%eax),%edx
  801b44:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	52                   	push   %edx
  801b4e:	50                   	push   %eax
  801b4f:	6a 1d                	push   $0x1d
  801b51:	e8 ad fc ff ff       	call   801803 <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
	return result;
  801b59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b5f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b62:	89 01                	mov    %eax,(%ecx)
  801b64:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	c9                   	leave  
  801b6b:	c2 04 00             	ret    $0x4

00801b6e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	ff 75 10             	pushl  0x10(%ebp)
  801b78:	ff 75 0c             	pushl  0xc(%ebp)
  801b7b:	ff 75 08             	pushl  0x8(%ebp)
  801b7e:	6a 13                	push   $0x13
  801b80:	e8 7e fc ff ff       	call   801803 <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
	return ;
  801b88:	90                   	nop
}
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <sys_rcr2>:
uint32 sys_rcr2()
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 1e                	push   $0x1e
  801b9a:	e8 64 fc ff ff       	call   801803 <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	83 ec 04             	sub    $0x4,%esp
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bb0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	50                   	push   %eax
  801bbd:	6a 1f                	push   $0x1f
  801bbf:	e8 3f fc ff ff       	call   801803 <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc7:	90                   	nop
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <rsttst>:
void rsttst()
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 21                	push   $0x21
  801bd9:	e8 25 fc ff ff       	call   801803 <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
	return ;
  801be1:	90                   	nop
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
  801be7:	83 ec 04             	sub    $0x4,%esp
  801bea:	8b 45 14             	mov    0x14(%ebp),%eax
  801bed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bf0:	8b 55 18             	mov    0x18(%ebp),%edx
  801bf3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bf7:	52                   	push   %edx
  801bf8:	50                   	push   %eax
  801bf9:	ff 75 10             	pushl  0x10(%ebp)
  801bfc:	ff 75 0c             	pushl  0xc(%ebp)
  801bff:	ff 75 08             	pushl  0x8(%ebp)
  801c02:	6a 20                	push   $0x20
  801c04:	e8 fa fb ff ff       	call   801803 <syscall>
  801c09:	83 c4 18             	add    $0x18,%esp
	return ;
  801c0c:	90                   	nop
}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <chktst>:
void chktst(uint32 n)
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	ff 75 08             	pushl  0x8(%ebp)
  801c1d:	6a 22                	push   $0x22
  801c1f:	e8 df fb ff ff       	call   801803 <syscall>
  801c24:	83 c4 18             	add    $0x18,%esp
	return ;
  801c27:	90                   	nop
}
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <inctst>:

void inctst()
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 23                	push   $0x23
  801c39:	e8 c5 fb ff ff       	call   801803 <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c41:	90                   	nop
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <gettst>:
uint32 gettst()
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 24                	push   $0x24
  801c53:	e8 ab fb ff ff       	call   801803 <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
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
  801c6f:	e8 8f fb ff ff       	call   801803 <syscall>
  801c74:	83 c4 18             	add    $0x18,%esp
  801c77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c7a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c7e:	75 07                	jne    801c87 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c80:	b8 01 00 00 00       	mov    $0x1,%eax
  801c85:	eb 05                	jmp    801c8c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
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
  801ca0:	e8 5e fb ff ff       	call   801803 <syscall>
  801ca5:	83 c4 18             	add    $0x18,%esp
  801ca8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cab:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801caf:	75 07                	jne    801cb8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cb1:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb6:	eb 05                	jmp    801cbd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
  801cc2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 25                	push   $0x25
  801cd1:	e8 2d fb ff ff       	call   801803 <syscall>
  801cd6:	83 c4 18             	add    $0x18,%esp
  801cd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cdc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ce0:	75 07                	jne    801ce9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ce2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce7:	eb 05                	jmp    801cee <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ce9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 25                	push   $0x25
  801d02:	e8 fc fa ff ff       	call   801803 <syscall>
  801d07:	83 c4 18             	add    $0x18,%esp
  801d0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d0d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d11:	75 07                	jne    801d1a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d13:	b8 01 00 00 00       	mov    $0x1,%eax
  801d18:	eb 05                	jmp    801d1f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	ff 75 08             	pushl  0x8(%ebp)
  801d2f:	6a 26                	push   $0x26
  801d31:	e8 cd fa ff ff       	call   801803 <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
	return ;
  801d39:	90                   	nop
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d40:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d43:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d49:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4c:	6a 00                	push   $0x0
  801d4e:	53                   	push   %ebx
  801d4f:	51                   	push   %ecx
  801d50:	52                   	push   %edx
  801d51:	50                   	push   %eax
  801d52:	6a 27                	push   $0x27
  801d54:	e8 aa fa ff ff       	call   801803 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
}
  801d5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d67:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	52                   	push   %edx
  801d71:	50                   	push   %eax
  801d72:	6a 28                	push   $0x28
  801d74:	e8 8a fa ff ff       	call   801803 <syscall>
  801d79:	83 c4 18             	add    $0x18,%esp
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d81:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d87:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8a:	6a 00                	push   $0x0
  801d8c:	51                   	push   %ecx
  801d8d:	ff 75 10             	pushl  0x10(%ebp)
  801d90:	52                   	push   %edx
  801d91:	50                   	push   %eax
  801d92:	6a 29                	push   $0x29
  801d94:	e8 6a fa ff ff       	call   801803 <syscall>
  801d99:	83 c4 18             	add    $0x18,%esp
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	ff 75 10             	pushl  0x10(%ebp)
  801da8:	ff 75 0c             	pushl  0xc(%ebp)
  801dab:	ff 75 08             	pushl  0x8(%ebp)
  801dae:	6a 12                	push   $0x12
  801db0:	e8 4e fa ff ff       	call   801803 <syscall>
  801db5:	83 c4 18             	add    $0x18,%esp
	return ;
  801db8:	90                   	nop
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801dbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	52                   	push   %edx
  801dcb:	50                   	push   %eax
  801dcc:	6a 2a                	push   $0x2a
  801dce:	e8 30 fa ff ff       	call   801803 <syscall>
  801dd3:	83 c4 18             	add    $0x18,%esp
	return;
  801dd6:	90                   	nop
}
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	50                   	push   %eax
  801de8:	6a 2b                	push   $0x2b
  801dea:	e8 14 fa ff ff       	call   801803 <syscall>
  801def:	83 c4 18             	add    $0x18,%esp
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	ff 75 0c             	pushl  0xc(%ebp)
  801e00:	ff 75 08             	pushl  0x8(%ebp)
  801e03:	6a 2c                	push   $0x2c
  801e05:	e8 f9 f9 ff ff       	call   801803 <syscall>
  801e0a:	83 c4 18             	add    $0x18,%esp
	return;
  801e0d:	90                   	nop
}
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	ff 75 0c             	pushl  0xc(%ebp)
  801e1c:	ff 75 08             	pushl  0x8(%ebp)
  801e1f:	6a 2d                	push   $0x2d
  801e21:	e8 dd f9 ff ff       	call   801803 <syscall>
  801e26:	83 c4 18             	add    $0x18,%esp
	return;
  801e29:	90                   	nop
}
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e32:	8b 45 08             	mov    0x8(%ebp),%eax
  801e35:	83 e8 04             	sub    $0x4,%eax
  801e38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801e3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e3e:	8b 00                	mov    (%eax),%eax
  801e40:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801e43:	c9                   	leave  
  801e44:	c3                   	ret    

00801e45 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
  801e48:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4e:	83 e8 04             	sub    $0x4,%eax
  801e51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e57:	8b 00                	mov    (%eax),%eax
  801e59:	83 e0 01             	and    $0x1,%eax
  801e5c:	85 c0                	test   %eax,%eax
  801e5e:	0f 94 c0             	sete   %al
}
  801e61:	c9                   	leave  
  801e62:	c3                   	ret    

00801e63 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
  801e66:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801e69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e73:	83 f8 02             	cmp    $0x2,%eax
  801e76:	74 2b                	je     801ea3 <alloc_block+0x40>
  801e78:	83 f8 02             	cmp    $0x2,%eax
  801e7b:	7f 07                	jg     801e84 <alloc_block+0x21>
  801e7d:	83 f8 01             	cmp    $0x1,%eax
  801e80:	74 0e                	je     801e90 <alloc_block+0x2d>
  801e82:	eb 58                	jmp    801edc <alloc_block+0x79>
  801e84:	83 f8 03             	cmp    $0x3,%eax
  801e87:	74 2d                	je     801eb6 <alloc_block+0x53>
  801e89:	83 f8 04             	cmp    $0x4,%eax
  801e8c:	74 3b                	je     801ec9 <alloc_block+0x66>
  801e8e:	eb 4c                	jmp    801edc <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801e90:	83 ec 0c             	sub    $0xc,%esp
  801e93:	ff 75 08             	pushl  0x8(%ebp)
  801e96:	e8 11 03 00 00       	call   8021ac <alloc_block_FF>
  801e9b:	83 c4 10             	add    $0x10,%esp
  801e9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ea1:	eb 4a                	jmp    801eed <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801ea3:	83 ec 0c             	sub    $0xc,%esp
  801ea6:	ff 75 08             	pushl  0x8(%ebp)
  801ea9:	e8 fa 19 00 00       	call   8038a8 <alloc_block_NF>
  801eae:	83 c4 10             	add    $0x10,%esp
  801eb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801eb4:	eb 37                	jmp    801eed <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801eb6:	83 ec 0c             	sub    $0xc,%esp
  801eb9:	ff 75 08             	pushl  0x8(%ebp)
  801ebc:	e8 a7 07 00 00       	call   802668 <alloc_block_BF>
  801ec1:	83 c4 10             	add    $0x10,%esp
  801ec4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ec7:	eb 24                	jmp    801eed <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801ec9:	83 ec 0c             	sub    $0xc,%esp
  801ecc:	ff 75 08             	pushl  0x8(%ebp)
  801ecf:	e8 b7 19 00 00       	call   80388b <alloc_block_WF>
  801ed4:	83 c4 10             	add    $0x10,%esp
  801ed7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801eda:	eb 11                	jmp    801eed <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801edc:	83 ec 0c             	sub    $0xc,%esp
  801edf:	68 78 43 80 00       	push   $0x804378
  801ee4:	e8 3b e6 ff ff       	call   800524 <cprintf>
  801ee9:	83 c4 10             	add    $0x10,%esp
		break;
  801eec:	90                   	nop
	}
	return va;
  801eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    

00801ef2 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	53                   	push   %ebx
  801ef6:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801ef9:	83 ec 0c             	sub    $0xc,%esp
  801efc:	68 98 43 80 00       	push   $0x804398
  801f01:	e8 1e e6 ff ff       	call   800524 <cprintf>
  801f06:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801f09:	83 ec 0c             	sub    $0xc,%esp
  801f0c:	68 c3 43 80 00       	push   $0x8043c3
  801f11:	e8 0e e6 ff ff       	call   800524 <cprintf>
  801f16:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f1f:	eb 37                	jmp    801f58 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801f21:	83 ec 0c             	sub    $0xc,%esp
  801f24:	ff 75 f4             	pushl  -0xc(%ebp)
  801f27:	e8 19 ff ff ff       	call   801e45 <is_free_block>
  801f2c:	83 c4 10             	add    $0x10,%esp
  801f2f:	0f be d8             	movsbl %al,%ebx
  801f32:	83 ec 0c             	sub    $0xc,%esp
  801f35:	ff 75 f4             	pushl  -0xc(%ebp)
  801f38:	e8 ef fe ff ff       	call   801e2c <get_block_size>
  801f3d:	83 c4 10             	add    $0x10,%esp
  801f40:	83 ec 04             	sub    $0x4,%esp
  801f43:	53                   	push   %ebx
  801f44:	50                   	push   %eax
  801f45:	68 db 43 80 00       	push   $0x8043db
  801f4a:	e8 d5 e5 ff ff       	call   800524 <cprintf>
  801f4f:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801f52:	8b 45 10             	mov    0x10(%ebp),%eax
  801f55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f5c:	74 07                	je     801f65 <print_blocks_list+0x73>
  801f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f61:	8b 00                	mov    (%eax),%eax
  801f63:	eb 05                	jmp    801f6a <print_blocks_list+0x78>
  801f65:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6a:	89 45 10             	mov    %eax,0x10(%ebp)
  801f6d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f70:	85 c0                	test   %eax,%eax
  801f72:	75 ad                	jne    801f21 <print_blocks_list+0x2f>
  801f74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f78:	75 a7                	jne    801f21 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801f7a:	83 ec 0c             	sub    $0xc,%esp
  801f7d:	68 98 43 80 00       	push   $0x804398
  801f82:	e8 9d e5 ff ff       	call   800524 <cprintf>
  801f87:	83 c4 10             	add    $0x10,%esp

}
  801f8a:	90                   	nop
  801f8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f8e:	c9                   	leave  
  801f8f:	c3                   	ret    

00801f90 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
  801f93:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f99:	83 e0 01             	and    $0x1,%eax
  801f9c:	85 c0                	test   %eax,%eax
  801f9e:	74 03                	je     801fa3 <initialize_dynamic_allocator+0x13>
  801fa0:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801fa3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fa7:	0f 84 c7 01 00 00    	je     802174 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801fad:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801fb4:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801fb7:	8b 55 08             	mov    0x8(%ebp),%edx
  801fba:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fbd:	01 d0                	add    %edx,%eax
  801fbf:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801fc4:	0f 87 ad 01 00 00    	ja     802177 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801fca:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcd:	85 c0                	test   %eax,%eax
  801fcf:	0f 89 a5 01 00 00    	jns    80217a <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801fd5:	8b 55 08             	mov    0x8(%ebp),%edx
  801fd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fdb:	01 d0                	add    %edx,%eax
  801fdd:	83 e8 04             	sub    $0x4,%eax
  801fe0:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801fe5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801fec:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801ff1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff4:	e9 87 00 00 00       	jmp    802080 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801ff9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ffd:	75 14                	jne    802013 <initialize_dynamic_allocator+0x83>
  801fff:	83 ec 04             	sub    $0x4,%esp
  802002:	68 f3 43 80 00       	push   $0x8043f3
  802007:	6a 79                	push   $0x79
  802009:	68 11 44 80 00       	push   $0x804411
  80200e:	e8 54 e2 ff ff       	call   800267 <_panic>
  802013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802016:	8b 00                	mov    (%eax),%eax
  802018:	85 c0                	test   %eax,%eax
  80201a:	74 10                	je     80202c <initialize_dynamic_allocator+0x9c>
  80201c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201f:	8b 00                	mov    (%eax),%eax
  802021:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802024:	8b 52 04             	mov    0x4(%edx),%edx
  802027:	89 50 04             	mov    %edx,0x4(%eax)
  80202a:	eb 0b                	jmp    802037 <initialize_dynamic_allocator+0xa7>
  80202c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202f:	8b 40 04             	mov    0x4(%eax),%eax
  802032:	a3 30 50 80 00       	mov    %eax,0x805030
  802037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203a:	8b 40 04             	mov    0x4(%eax),%eax
  80203d:	85 c0                	test   %eax,%eax
  80203f:	74 0f                	je     802050 <initialize_dynamic_allocator+0xc0>
  802041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802044:	8b 40 04             	mov    0x4(%eax),%eax
  802047:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204a:	8b 12                	mov    (%edx),%edx
  80204c:	89 10                	mov    %edx,(%eax)
  80204e:	eb 0a                	jmp    80205a <initialize_dynamic_allocator+0xca>
  802050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802053:	8b 00                	mov    (%eax),%eax
  802055:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80205a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802066:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80206d:	a1 38 50 80 00       	mov    0x805038,%eax
  802072:	48                   	dec    %eax
  802073:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802078:	a1 34 50 80 00       	mov    0x805034,%eax
  80207d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802080:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802084:	74 07                	je     80208d <initialize_dynamic_allocator+0xfd>
  802086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802089:	8b 00                	mov    (%eax),%eax
  80208b:	eb 05                	jmp    802092 <initialize_dynamic_allocator+0x102>
  80208d:	b8 00 00 00 00       	mov    $0x0,%eax
  802092:	a3 34 50 80 00       	mov    %eax,0x805034
  802097:	a1 34 50 80 00       	mov    0x805034,%eax
  80209c:	85 c0                	test   %eax,%eax
  80209e:	0f 85 55 ff ff ff    	jne    801ff9 <initialize_dynamic_allocator+0x69>
  8020a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a8:	0f 85 4b ff ff ff    	jne    801ff9 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8020ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8020b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8020bd:	a1 44 50 80 00       	mov    0x805044,%eax
  8020c2:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8020c7:	a1 40 50 80 00       	mov    0x805040,%eax
  8020cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8020d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d5:	83 c0 08             	add    $0x8,%eax
  8020d8:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020db:	8b 45 08             	mov    0x8(%ebp),%eax
  8020de:	83 c0 04             	add    $0x4,%eax
  8020e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e4:	83 ea 08             	sub    $0x8,%edx
  8020e7:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	01 d0                	add    %edx,%eax
  8020f1:	83 e8 08             	sub    $0x8,%eax
  8020f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f7:	83 ea 08             	sub    $0x8,%edx
  8020fa:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8020fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802105:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802108:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80210f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802113:	75 17                	jne    80212c <initialize_dynamic_allocator+0x19c>
  802115:	83 ec 04             	sub    $0x4,%esp
  802118:	68 2c 44 80 00       	push   $0x80442c
  80211d:	68 90 00 00 00       	push   $0x90
  802122:	68 11 44 80 00       	push   $0x804411
  802127:	e8 3b e1 ff ff       	call   800267 <_panic>
  80212c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802132:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802135:	89 10                	mov    %edx,(%eax)
  802137:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80213a:	8b 00                	mov    (%eax),%eax
  80213c:	85 c0                	test   %eax,%eax
  80213e:	74 0d                	je     80214d <initialize_dynamic_allocator+0x1bd>
  802140:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802145:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802148:	89 50 04             	mov    %edx,0x4(%eax)
  80214b:	eb 08                	jmp    802155 <initialize_dynamic_allocator+0x1c5>
  80214d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802150:	a3 30 50 80 00       	mov    %eax,0x805030
  802155:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802158:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80215d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802160:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802167:	a1 38 50 80 00       	mov    0x805038,%eax
  80216c:	40                   	inc    %eax
  80216d:	a3 38 50 80 00       	mov    %eax,0x805038
  802172:	eb 07                	jmp    80217b <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802174:	90                   	nop
  802175:	eb 04                	jmp    80217b <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802177:	90                   	nop
  802178:	eb 01                	jmp    80217b <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80217a:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80217b:	c9                   	leave  
  80217c:	c3                   	ret    

0080217d <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802180:	8b 45 10             	mov    0x10(%ebp),%eax
  802183:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	8d 50 fc             	lea    -0x4(%eax),%edx
  80218c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218f:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802191:	8b 45 08             	mov    0x8(%ebp),%eax
  802194:	83 e8 04             	sub    $0x4,%eax
  802197:	8b 00                	mov    (%eax),%eax
  802199:	83 e0 fe             	and    $0xfffffffe,%eax
  80219c:	8d 50 f8             	lea    -0x8(%eax),%edx
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	01 c2                	add    %eax,%edx
  8021a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a7:	89 02                	mov    %eax,(%edx)
}
  8021a9:	90                   	nop
  8021aa:	5d                   	pop    %ebp
  8021ab:	c3                   	ret    

008021ac <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
  8021af:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8021b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b5:	83 e0 01             	and    $0x1,%eax
  8021b8:	85 c0                	test   %eax,%eax
  8021ba:	74 03                	je     8021bf <alloc_block_FF+0x13>
  8021bc:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8021bf:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8021c3:	77 07                	ja     8021cc <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8021c5:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8021cc:	a1 24 50 80 00       	mov    0x805024,%eax
  8021d1:	85 c0                	test   %eax,%eax
  8021d3:	75 73                	jne    802248 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	83 c0 10             	add    $0x10,%eax
  8021db:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8021de:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8021e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021eb:	01 d0                	add    %edx,%eax
  8021ed:	48                   	dec    %eax
  8021ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8021f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8021f9:	f7 75 ec             	divl   -0x14(%ebp)
  8021fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021ff:	29 d0                	sub    %edx,%eax
  802201:	c1 e8 0c             	shr    $0xc,%eax
  802204:	83 ec 0c             	sub    $0xc,%esp
  802207:	50                   	push   %eax
  802208:	e8 b1 f0 ff ff       	call   8012be <sbrk>
  80220d:	83 c4 10             	add    $0x10,%esp
  802210:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802213:	83 ec 0c             	sub    $0xc,%esp
  802216:	6a 00                	push   $0x0
  802218:	e8 a1 f0 ff ff       	call   8012be <sbrk>
  80221d:	83 c4 10             	add    $0x10,%esp
  802220:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802223:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802226:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802229:	83 ec 08             	sub    $0x8,%esp
  80222c:	50                   	push   %eax
  80222d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802230:	e8 5b fd ff ff       	call   801f90 <initialize_dynamic_allocator>
  802235:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802238:	83 ec 0c             	sub    $0xc,%esp
  80223b:	68 4f 44 80 00       	push   $0x80444f
  802240:	e8 df e2 ff ff       	call   800524 <cprintf>
  802245:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802248:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80224c:	75 0a                	jne    802258 <alloc_block_FF+0xac>
	        return NULL;
  80224e:	b8 00 00 00 00       	mov    $0x0,%eax
  802253:	e9 0e 04 00 00       	jmp    802666 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802258:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80225f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802264:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802267:	e9 f3 02 00 00       	jmp    80255f <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80226c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226f:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802272:	83 ec 0c             	sub    $0xc,%esp
  802275:	ff 75 bc             	pushl  -0x44(%ebp)
  802278:	e8 af fb ff ff       	call   801e2c <get_block_size>
  80227d:	83 c4 10             	add    $0x10,%esp
  802280:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802283:	8b 45 08             	mov    0x8(%ebp),%eax
  802286:	83 c0 08             	add    $0x8,%eax
  802289:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80228c:	0f 87 c5 02 00 00    	ja     802557 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802292:	8b 45 08             	mov    0x8(%ebp),%eax
  802295:	83 c0 18             	add    $0x18,%eax
  802298:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80229b:	0f 87 19 02 00 00    	ja     8024ba <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8022a1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8022a4:	2b 45 08             	sub    0x8(%ebp),%eax
  8022a7:	83 e8 08             	sub    $0x8,%eax
  8022aa:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8022ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b0:	8d 50 08             	lea    0x8(%eax),%edx
  8022b3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8022b6:	01 d0                	add    %edx,%eax
  8022b8:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	83 c0 08             	add    $0x8,%eax
  8022c1:	83 ec 04             	sub    $0x4,%esp
  8022c4:	6a 01                	push   $0x1
  8022c6:	50                   	push   %eax
  8022c7:	ff 75 bc             	pushl  -0x44(%ebp)
  8022ca:	e8 ae fe ff ff       	call   80217d <set_block_data>
  8022cf:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8022d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d5:	8b 40 04             	mov    0x4(%eax),%eax
  8022d8:	85 c0                	test   %eax,%eax
  8022da:	75 68                	jne    802344 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8022dc:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022e0:	75 17                	jne    8022f9 <alloc_block_FF+0x14d>
  8022e2:	83 ec 04             	sub    $0x4,%esp
  8022e5:	68 2c 44 80 00       	push   $0x80442c
  8022ea:	68 d7 00 00 00       	push   $0xd7
  8022ef:	68 11 44 80 00       	push   $0x804411
  8022f4:	e8 6e df ff ff       	call   800267 <_panic>
  8022f9:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8022ff:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802302:	89 10                	mov    %edx,(%eax)
  802304:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802307:	8b 00                	mov    (%eax),%eax
  802309:	85 c0                	test   %eax,%eax
  80230b:	74 0d                	je     80231a <alloc_block_FF+0x16e>
  80230d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802312:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802315:	89 50 04             	mov    %edx,0x4(%eax)
  802318:	eb 08                	jmp    802322 <alloc_block_FF+0x176>
  80231a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80231d:	a3 30 50 80 00       	mov    %eax,0x805030
  802322:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802325:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80232a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80232d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802334:	a1 38 50 80 00       	mov    0x805038,%eax
  802339:	40                   	inc    %eax
  80233a:	a3 38 50 80 00       	mov    %eax,0x805038
  80233f:	e9 dc 00 00 00       	jmp    802420 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802347:	8b 00                	mov    (%eax),%eax
  802349:	85 c0                	test   %eax,%eax
  80234b:	75 65                	jne    8023b2 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80234d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802351:	75 17                	jne    80236a <alloc_block_FF+0x1be>
  802353:	83 ec 04             	sub    $0x4,%esp
  802356:	68 60 44 80 00       	push   $0x804460
  80235b:	68 db 00 00 00       	push   $0xdb
  802360:	68 11 44 80 00       	push   $0x804411
  802365:	e8 fd de ff ff       	call   800267 <_panic>
  80236a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802370:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802373:	89 50 04             	mov    %edx,0x4(%eax)
  802376:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802379:	8b 40 04             	mov    0x4(%eax),%eax
  80237c:	85 c0                	test   %eax,%eax
  80237e:	74 0c                	je     80238c <alloc_block_FF+0x1e0>
  802380:	a1 30 50 80 00       	mov    0x805030,%eax
  802385:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802388:	89 10                	mov    %edx,(%eax)
  80238a:	eb 08                	jmp    802394 <alloc_block_FF+0x1e8>
  80238c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80238f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802394:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802397:	a3 30 50 80 00       	mov    %eax,0x805030
  80239c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80239f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023a5:	a1 38 50 80 00       	mov    0x805038,%eax
  8023aa:	40                   	inc    %eax
  8023ab:	a3 38 50 80 00       	mov    %eax,0x805038
  8023b0:	eb 6e                	jmp    802420 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8023b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b6:	74 06                	je     8023be <alloc_block_FF+0x212>
  8023b8:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023bc:	75 17                	jne    8023d5 <alloc_block_FF+0x229>
  8023be:	83 ec 04             	sub    $0x4,%esp
  8023c1:	68 84 44 80 00       	push   $0x804484
  8023c6:	68 df 00 00 00       	push   $0xdf
  8023cb:	68 11 44 80 00       	push   $0x804411
  8023d0:	e8 92 de ff ff       	call   800267 <_panic>
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	8b 10                	mov    (%eax),%edx
  8023da:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023dd:	89 10                	mov    %edx,(%eax)
  8023df:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023e2:	8b 00                	mov    (%eax),%eax
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	74 0b                	je     8023f3 <alloc_block_FF+0x247>
  8023e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023eb:	8b 00                	mov    (%eax),%eax
  8023ed:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023f0:	89 50 04             	mov    %edx,0x4(%eax)
  8023f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023f9:	89 10                	mov    %edx,(%eax)
  8023fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802401:	89 50 04             	mov    %edx,0x4(%eax)
  802404:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802407:	8b 00                	mov    (%eax),%eax
  802409:	85 c0                	test   %eax,%eax
  80240b:	75 08                	jne    802415 <alloc_block_FF+0x269>
  80240d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802410:	a3 30 50 80 00       	mov    %eax,0x805030
  802415:	a1 38 50 80 00       	mov    0x805038,%eax
  80241a:	40                   	inc    %eax
  80241b:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802420:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802424:	75 17                	jne    80243d <alloc_block_FF+0x291>
  802426:	83 ec 04             	sub    $0x4,%esp
  802429:	68 f3 43 80 00       	push   $0x8043f3
  80242e:	68 e1 00 00 00       	push   $0xe1
  802433:	68 11 44 80 00       	push   $0x804411
  802438:	e8 2a de ff ff       	call   800267 <_panic>
  80243d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802440:	8b 00                	mov    (%eax),%eax
  802442:	85 c0                	test   %eax,%eax
  802444:	74 10                	je     802456 <alloc_block_FF+0x2aa>
  802446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802449:	8b 00                	mov    (%eax),%eax
  80244b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80244e:	8b 52 04             	mov    0x4(%edx),%edx
  802451:	89 50 04             	mov    %edx,0x4(%eax)
  802454:	eb 0b                	jmp    802461 <alloc_block_FF+0x2b5>
  802456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802459:	8b 40 04             	mov    0x4(%eax),%eax
  80245c:	a3 30 50 80 00       	mov    %eax,0x805030
  802461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802464:	8b 40 04             	mov    0x4(%eax),%eax
  802467:	85 c0                	test   %eax,%eax
  802469:	74 0f                	je     80247a <alloc_block_FF+0x2ce>
  80246b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246e:	8b 40 04             	mov    0x4(%eax),%eax
  802471:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802474:	8b 12                	mov    (%edx),%edx
  802476:	89 10                	mov    %edx,(%eax)
  802478:	eb 0a                	jmp    802484 <alloc_block_FF+0x2d8>
  80247a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247d:	8b 00                	mov    (%eax),%eax
  80247f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80248d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802490:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802497:	a1 38 50 80 00       	mov    0x805038,%eax
  80249c:	48                   	dec    %eax
  80249d:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8024a2:	83 ec 04             	sub    $0x4,%esp
  8024a5:	6a 00                	push   $0x0
  8024a7:	ff 75 b4             	pushl  -0x4c(%ebp)
  8024aa:	ff 75 b0             	pushl  -0x50(%ebp)
  8024ad:	e8 cb fc ff ff       	call   80217d <set_block_data>
  8024b2:	83 c4 10             	add    $0x10,%esp
  8024b5:	e9 95 00 00 00       	jmp    80254f <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8024ba:	83 ec 04             	sub    $0x4,%esp
  8024bd:	6a 01                	push   $0x1
  8024bf:	ff 75 b8             	pushl  -0x48(%ebp)
  8024c2:	ff 75 bc             	pushl  -0x44(%ebp)
  8024c5:	e8 b3 fc ff ff       	call   80217d <set_block_data>
  8024ca:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8024cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d1:	75 17                	jne    8024ea <alloc_block_FF+0x33e>
  8024d3:	83 ec 04             	sub    $0x4,%esp
  8024d6:	68 f3 43 80 00       	push   $0x8043f3
  8024db:	68 e8 00 00 00       	push   $0xe8
  8024e0:	68 11 44 80 00       	push   $0x804411
  8024e5:	e8 7d dd ff ff       	call   800267 <_panic>
  8024ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ed:	8b 00                	mov    (%eax),%eax
  8024ef:	85 c0                	test   %eax,%eax
  8024f1:	74 10                	je     802503 <alloc_block_FF+0x357>
  8024f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f6:	8b 00                	mov    (%eax),%eax
  8024f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fb:	8b 52 04             	mov    0x4(%edx),%edx
  8024fe:	89 50 04             	mov    %edx,0x4(%eax)
  802501:	eb 0b                	jmp    80250e <alloc_block_FF+0x362>
  802503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802506:	8b 40 04             	mov    0x4(%eax),%eax
  802509:	a3 30 50 80 00       	mov    %eax,0x805030
  80250e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802511:	8b 40 04             	mov    0x4(%eax),%eax
  802514:	85 c0                	test   %eax,%eax
  802516:	74 0f                	je     802527 <alloc_block_FF+0x37b>
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 40 04             	mov    0x4(%eax),%eax
  80251e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802521:	8b 12                	mov    (%edx),%edx
  802523:	89 10                	mov    %edx,(%eax)
  802525:	eb 0a                	jmp    802531 <alloc_block_FF+0x385>
  802527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252a:	8b 00                	mov    (%eax),%eax
  80252c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802534:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802544:	a1 38 50 80 00       	mov    0x805038,%eax
  802549:	48                   	dec    %eax
  80254a:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80254f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802552:	e9 0f 01 00 00       	jmp    802666 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802557:	a1 34 50 80 00       	mov    0x805034,%eax
  80255c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80255f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802563:	74 07                	je     80256c <alloc_block_FF+0x3c0>
  802565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802568:	8b 00                	mov    (%eax),%eax
  80256a:	eb 05                	jmp    802571 <alloc_block_FF+0x3c5>
  80256c:	b8 00 00 00 00       	mov    $0x0,%eax
  802571:	a3 34 50 80 00       	mov    %eax,0x805034
  802576:	a1 34 50 80 00       	mov    0x805034,%eax
  80257b:	85 c0                	test   %eax,%eax
  80257d:	0f 85 e9 fc ff ff    	jne    80226c <alloc_block_FF+0xc0>
  802583:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802587:	0f 85 df fc ff ff    	jne    80226c <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80258d:	8b 45 08             	mov    0x8(%ebp),%eax
  802590:	83 c0 08             	add    $0x8,%eax
  802593:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802596:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80259d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025a3:	01 d0                	add    %edx,%eax
  8025a5:	48                   	dec    %eax
  8025a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8025a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8025b1:	f7 75 d8             	divl   -0x28(%ebp)
  8025b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025b7:	29 d0                	sub    %edx,%eax
  8025b9:	c1 e8 0c             	shr    $0xc,%eax
  8025bc:	83 ec 0c             	sub    $0xc,%esp
  8025bf:	50                   	push   %eax
  8025c0:	e8 f9 ec ff ff       	call   8012be <sbrk>
  8025c5:	83 c4 10             	add    $0x10,%esp
  8025c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8025cb:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8025cf:	75 0a                	jne    8025db <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8025d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d6:	e9 8b 00 00 00       	jmp    802666 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8025db:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8025e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025e8:	01 d0                	add    %edx,%eax
  8025ea:	48                   	dec    %eax
  8025eb:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8025ee:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8025f6:	f7 75 cc             	divl   -0x34(%ebp)
  8025f9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025fc:	29 d0                	sub    %edx,%eax
  8025fe:	8d 50 fc             	lea    -0x4(%eax),%edx
  802601:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802604:	01 d0                	add    %edx,%eax
  802606:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80260b:	a1 40 50 80 00       	mov    0x805040,%eax
  802610:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802616:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80261d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802620:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802623:	01 d0                	add    %edx,%eax
  802625:	48                   	dec    %eax
  802626:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802629:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80262c:	ba 00 00 00 00       	mov    $0x0,%edx
  802631:	f7 75 c4             	divl   -0x3c(%ebp)
  802634:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802637:	29 d0                	sub    %edx,%eax
  802639:	83 ec 04             	sub    $0x4,%esp
  80263c:	6a 01                	push   $0x1
  80263e:	50                   	push   %eax
  80263f:	ff 75 d0             	pushl  -0x30(%ebp)
  802642:	e8 36 fb ff ff       	call   80217d <set_block_data>
  802647:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80264a:	83 ec 0c             	sub    $0xc,%esp
  80264d:	ff 75 d0             	pushl  -0x30(%ebp)
  802650:	e8 1b 0a 00 00       	call   803070 <free_block>
  802655:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802658:	83 ec 0c             	sub    $0xc,%esp
  80265b:	ff 75 08             	pushl  0x8(%ebp)
  80265e:	e8 49 fb ff ff       	call   8021ac <alloc_block_FF>
  802663:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802666:	c9                   	leave  
  802667:	c3                   	ret    

00802668 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802668:	55                   	push   %ebp
  802669:	89 e5                	mov    %esp,%ebp
  80266b:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80266e:	8b 45 08             	mov    0x8(%ebp),%eax
  802671:	83 e0 01             	and    $0x1,%eax
  802674:	85 c0                	test   %eax,%eax
  802676:	74 03                	je     80267b <alloc_block_BF+0x13>
  802678:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80267b:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80267f:	77 07                	ja     802688 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802681:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802688:	a1 24 50 80 00       	mov    0x805024,%eax
  80268d:	85 c0                	test   %eax,%eax
  80268f:	75 73                	jne    802704 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802691:	8b 45 08             	mov    0x8(%ebp),%eax
  802694:	83 c0 10             	add    $0x10,%eax
  802697:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80269a:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8026a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026a7:	01 d0                	add    %edx,%eax
  8026a9:	48                   	dec    %eax
  8026aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8026ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8026b5:	f7 75 e0             	divl   -0x20(%ebp)
  8026b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026bb:	29 d0                	sub    %edx,%eax
  8026bd:	c1 e8 0c             	shr    $0xc,%eax
  8026c0:	83 ec 0c             	sub    $0xc,%esp
  8026c3:	50                   	push   %eax
  8026c4:	e8 f5 eb ff ff       	call   8012be <sbrk>
  8026c9:	83 c4 10             	add    $0x10,%esp
  8026cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8026cf:	83 ec 0c             	sub    $0xc,%esp
  8026d2:	6a 00                	push   $0x0
  8026d4:	e8 e5 eb ff ff       	call   8012be <sbrk>
  8026d9:	83 c4 10             	add    $0x10,%esp
  8026dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8026df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026e2:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8026e5:	83 ec 08             	sub    $0x8,%esp
  8026e8:	50                   	push   %eax
  8026e9:	ff 75 d8             	pushl  -0x28(%ebp)
  8026ec:	e8 9f f8 ff ff       	call   801f90 <initialize_dynamic_allocator>
  8026f1:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8026f4:	83 ec 0c             	sub    $0xc,%esp
  8026f7:	68 4f 44 80 00       	push   $0x80444f
  8026fc:	e8 23 de ff ff       	call   800524 <cprintf>
  802701:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802704:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80270b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802712:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802719:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802720:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802725:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802728:	e9 1d 01 00 00       	jmp    80284a <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802730:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802733:	83 ec 0c             	sub    $0xc,%esp
  802736:	ff 75 a8             	pushl  -0x58(%ebp)
  802739:	e8 ee f6 ff ff       	call   801e2c <get_block_size>
  80273e:	83 c4 10             	add    $0x10,%esp
  802741:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802744:	8b 45 08             	mov    0x8(%ebp),%eax
  802747:	83 c0 08             	add    $0x8,%eax
  80274a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80274d:	0f 87 ef 00 00 00    	ja     802842 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802753:	8b 45 08             	mov    0x8(%ebp),%eax
  802756:	83 c0 18             	add    $0x18,%eax
  802759:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80275c:	77 1d                	ja     80277b <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80275e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802761:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802764:	0f 86 d8 00 00 00    	jbe    802842 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80276a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80276d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802770:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802773:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802776:	e9 c7 00 00 00       	jmp    802842 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80277b:	8b 45 08             	mov    0x8(%ebp),%eax
  80277e:	83 c0 08             	add    $0x8,%eax
  802781:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802784:	0f 85 9d 00 00 00    	jne    802827 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80278a:	83 ec 04             	sub    $0x4,%esp
  80278d:	6a 01                	push   $0x1
  80278f:	ff 75 a4             	pushl  -0x5c(%ebp)
  802792:	ff 75 a8             	pushl  -0x58(%ebp)
  802795:	e8 e3 f9 ff ff       	call   80217d <set_block_data>
  80279a:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80279d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a1:	75 17                	jne    8027ba <alloc_block_BF+0x152>
  8027a3:	83 ec 04             	sub    $0x4,%esp
  8027a6:	68 f3 43 80 00       	push   $0x8043f3
  8027ab:	68 2c 01 00 00       	push   $0x12c
  8027b0:	68 11 44 80 00       	push   $0x804411
  8027b5:	e8 ad da ff ff       	call   800267 <_panic>
  8027ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bd:	8b 00                	mov    (%eax),%eax
  8027bf:	85 c0                	test   %eax,%eax
  8027c1:	74 10                	je     8027d3 <alloc_block_BF+0x16b>
  8027c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c6:	8b 00                	mov    (%eax),%eax
  8027c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027cb:	8b 52 04             	mov    0x4(%edx),%edx
  8027ce:	89 50 04             	mov    %edx,0x4(%eax)
  8027d1:	eb 0b                	jmp    8027de <alloc_block_BF+0x176>
  8027d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d6:	8b 40 04             	mov    0x4(%eax),%eax
  8027d9:	a3 30 50 80 00       	mov    %eax,0x805030
  8027de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e1:	8b 40 04             	mov    0x4(%eax),%eax
  8027e4:	85 c0                	test   %eax,%eax
  8027e6:	74 0f                	je     8027f7 <alloc_block_BF+0x18f>
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	8b 40 04             	mov    0x4(%eax),%eax
  8027ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f1:	8b 12                	mov    (%edx),%edx
  8027f3:	89 10                	mov    %edx,(%eax)
  8027f5:	eb 0a                	jmp    802801 <alloc_block_BF+0x199>
  8027f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fa:	8b 00                	mov    (%eax),%eax
  8027fc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802804:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802814:	a1 38 50 80 00       	mov    0x805038,%eax
  802819:	48                   	dec    %eax
  80281a:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80281f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802822:	e9 24 04 00 00       	jmp    802c4b <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802827:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80282d:	76 13                	jbe    802842 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80282f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802836:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802839:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80283c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80283f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802842:	a1 34 50 80 00       	mov    0x805034,%eax
  802847:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80284a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284e:	74 07                	je     802857 <alloc_block_BF+0x1ef>
  802850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802853:	8b 00                	mov    (%eax),%eax
  802855:	eb 05                	jmp    80285c <alloc_block_BF+0x1f4>
  802857:	b8 00 00 00 00       	mov    $0x0,%eax
  80285c:	a3 34 50 80 00       	mov    %eax,0x805034
  802861:	a1 34 50 80 00       	mov    0x805034,%eax
  802866:	85 c0                	test   %eax,%eax
  802868:	0f 85 bf fe ff ff    	jne    80272d <alloc_block_BF+0xc5>
  80286e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802872:	0f 85 b5 fe ff ff    	jne    80272d <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802878:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80287c:	0f 84 26 02 00 00    	je     802aa8 <alloc_block_BF+0x440>
  802882:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802886:	0f 85 1c 02 00 00    	jne    802aa8 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80288c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288f:	2b 45 08             	sub    0x8(%ebp),%eax
  802892:	83 e8 08             	sub    $0x8,%eax
  802895:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802898:	8b 45 08             	mov    0x8(%ebp),%eax
  80289b:	8d 50 08             	lea    0x8(%eax),%edx
  80289e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a1:	01 d0                	add    %edx,%eax
  8028a3:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8028a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a9:	83 c0 08             	add    $0x8,%eax
  8028ac:	83 ec 04             	sub    $0x4,%esp
  8028af:	6a 01                	push   $0x1
  8028b1:	50                   	push   %eax
  8028b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8028b5:	e8 c3 f8 ff ff       	call   80217d <set_block_data>
  8028ba:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8028bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c0:	8b 40 04             	mov    0x4(%eax),%eax
  8028c3:	85 c0                	test   %eax,%eax
  8028c5:	75 68                	jne    80292f <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028c7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028cb:	75 17                	jne    8028e4 <alloc_block_BF+0x27c>
  8028cd:	83 ec 04             	sub    $0x4,%esp
  8028d0:	68 2c 44 80 00       	push   $0x80442c
  8028d5:	68 45 01 00 00       	push   $0x145
  8028da:	68 11 44 80 00       	push   $0x804411
  8028df:	e8 83 d9 ff ff       	call   800267 <_panic>
  8028e4:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8028ea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ed:	89 10                	mov    %edx,(%eax)
  8028ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028f2:	8b 00                	mov    (%eax),%eax
  8028f4:	85 c0                	test   %eax,%eax
  8028f6:	74 0d                	je     802905 <alloc_block_BF+0x29d>
  8028f8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8028fd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802900:	89 50 04             	mov    %edx,0x4(%eax)
  802903:	eb 08                	jmp    80290d <alloc_block_BF+0x2a5>
  802905:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802908:	a3 30 50 80 00       	mov    %eax,0x805030
  80290d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802910:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802915:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802918:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80291f:	a1 38 50 80 00       	mov    0x805038,%eax
  802924:	40                   	inc    %eax
  802925:	a3 38 50 80 00       	mov    %eax,0x805038
  80292a:	e9 dc 00 00 00       	jmp    802a0b <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80292f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802932:	8b 00                	mov    (%eax),%eax
  802934:	85 c0                	test   %eax,%eax
  802936:	75 65                	jne    80299d <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802938:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80293c:	75 17                	jne    802955 <alloc_block_BF+0x2ed>
  80293e:	83 ec 04             	sub    $0x4,%esp
  802941:	68 60 44 80 00       	push   $0x804460
  802946:	68 4a 01 00 00       	push   $0x14a
  80294b:	68 11 44 80 00       	push   $0x804411
  802950:	e8 12 d9 ff ff       	call   800267 <_panic>
  802955:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80295b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80295e:	89 50 04             	mov    %edx,0x4(%eax)
  802961:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802964:	8b 40 04             	mov    0x4(%eax),%eax
  802967:	85 c0                	test   %eax,%eax
  802969:	74 0c                	je     802977 <alloc_block_BF+0x30f>
  80296b:	a1 30 50 80 00       	mov    0x805030,%eax
  802970:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802973:	89 10                	mov    %edx,(%eax)
  802975:	eb 08                	jmp    80297f <alloc_block_BF+0x317>
  802977:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80297a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80297f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802982:	a3 30 50 80 00       	mov    %eax,0x805030
  802987:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80298a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802990:	a1 38 50 80 00       	mov    0x805038,%eax
  802995:	40                   	inc    %eax
  802996:	a3 38 50 80 00       	mov    %eax,0x805038
  80299b:	eb 6e                	jmp    802a0b <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80299d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029a1:	74 06                	je     8029a9 <alloc_block_BF+0x341>
  8029a3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029a7:	75 17                	jne    8029c0 <alloc_block_BF+0x358>
  8029a9:	83 ec 04             	sub    $0x4,%esp
  8029ac:	68 84 44 80 00       	push   $0x804484
  8029b1:	68 4f 01 00 00       	push   $0x14f
  8029b6:	68 11 44 80 00       	push   $0x804411
  8029bb:	e8 a7 d8 ff ff       	call   800267 <_panic>
  8029c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c3:	8b 10                	mov    (%eax),%edx
  8029c5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029c8:	89 10                	mov    %edx,(%eax)
  8029ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029cd:	8b 00                	mov    (%eax),%eax
  8029cf:	85 c0                	test   %eax,%eax
  8029d1:	74 0b                	je     8029de <alloc_block_BF+0x376>
  8029d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d6:	8b 00                	mov    (%eax),%eax
  8029d8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029db:	89 50 04             	mov    %edx,0x4(%eax)
  8029de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029e4:	89 10                	mov    %edx,(%eax)
  8029e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ec:	89 50 04             	mov    %edx,0x4(%eax)
  8029ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029f2:	8b 00                	mov    (%eax),%eax
  8029f4:	85 c0                	test   %eax,%eax
  8029f6:	75 08                	jne    802a00 <alloc_block_BF+0x398>
  8029f8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029fb:	a3 30 50 80 00       	mov    %eax,0x805030
  802a00:	a1 38 50 80 00       	mov    0x805038,%eax
  802a05:	40                   	inc    %eax
  802a06:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802a0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a0f:	75 17                	jne    802a28 <alloc_block_BF+0x3c0>
  802a11:	83 ec 04             	sub    $0x4,%esp
  802a14:	68 f3 43 80 00       	push   $0x8043f3
  802a19:	68 51 01 00 00       	push   $0x151
  802a1e:	68 11 44 80 00       	push   $0x804411
  802a23:	e8 3f d8 ff ff       	call   800267 <_panic>
  802a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2b:	8b 00                	mov    (%eax),%eax
  802a2d:	85 c0                	test   %eax,%eax
  802a2f:	74 10                	je     802a41 <alloc_block_BF+0x3d9>
  802a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a34:	8b 00                	mov    (%eax),%eax
  802a36:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a39:	8b 52 04             	mov    0x4(%edx),%edx
  802a3c:	89 50 04             	mov    %edx,0x4(%eax)
  802a3f:	eb 0b                	jmp    802a4c <alloc_block_BF+0x3e4>
  802a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a44:	8b 40 04             	mov    0x4(%eax),%eax
  802a47:	a3 30 50 80 00       	mov    %eax,0x805030
  802a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4f:	8b 40 04             	mov    0x4(%eax),%eax
  802a52:	85 c0                	test   %eax,%eax
  802a54:	74 0f                	je     802a65 <alloc_block_BF+0x3fd>
  802a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a59:	8b 40 04             	mov    0x4(%eax),%eax
  802a5c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a5f:	8b 12                	mov    (%edx),%edx
  802a61:	89 10                	mov    %edx,(%eax)
  802a63:	eb 0a                	jmp    802a6f <alloc_block_BF+0x407>
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
			set_block_data(new_block_va, remaining_size, 0);
  802a8d:	83 ec 04             	sub    $0x4,%esp
  802a90:	6a 00                	push   $0x0
  802a92:	ff 75 d0             	pushl  -0x30(%ebp)
  802a95:	ff 75 cc             	pushl  -0x34(%ebp)
  802a98:	e8 e0 f6 ff ff       	call   80217d <set_block_data>
  802a9d:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa3:	e9 a3 01 00 00       	jmp    802c4b <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802aa8:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802aac:	0f 85 9d 00 00 00    	jne    802b4f <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802ab2:	83 ec 04             	sub    $0x4,%esp
  802ab5:	6a 01                	push   $0x1
  802ab7:	ff 75 ec             	pushl  -0x14(%ebp)
  802aba:	ff 75 f0             	pushl  -0x10(%ebp)
  802abd:	e8 bb f6 ff ff       	call   80217d <set_block_data>
  802ac2:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802ac5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ac9:	75 17                	jne    802ae2 <alloc_block_BF+0x47a>
  802acb:	83 ec 04             	sub    $0x4,%esp
  802ace:	68 f3 43 80 00       	push   $0x8043f3
  802ad3:	68 58 01 00 00       	push   $0x158
  802ad8:	68 11 44 80 00       	push   $0x804411
  802add:	e8 85 d7 ff ff       	call   800267 <_panic>
  802ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae5:	8b 00                	mov    (%eax),%eax
  802ae7:	85 c0                	test   %eax,%eax
  802ae9:	74 10                	je     802afb <alloc_block_BF+0x493>
  802aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aee:	8b 00                	mov    (%eax),%eax
  802af0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802af3:	8b 52 04             	mov    0x4(%edx),%edx
  802af6:	89 50 04             	mov    %edx,0x4(%eax)
  802af9:	eb 0b                	jmp    802b06 <alloc_block_BF+0x49e>
  802afb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afe:	8b 40 04             	mov    0x4(%eax),%eax
  802b01:	a3 30 50 80 00       	mov    %eax,0x805030
  802b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b09:	8b 40 04             	mov    0x4(%eax),%eax
  802b0c:	85 c0                	test   %eax,%eax
  802b0e:	74 0f                	je     802b1f <alloc_block_BF+0x4b7>
  802b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b13:	8b 40 04             	mov    0x4(%eax),%eax
  802b16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b19:	8b 12                	mov    (%edx),%edx
  802b1b:	89 10                	mov    %edx,(%eax)
  802b1d:	eb 0a                	jmp    802b29 <alloc_block_BF+0x4c1>
  802b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b22:	8b 00                	mov    (%eax),%eax
  802b24:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3c:	a1 38 50 80 00       	mov    0x805038,%eax
  802b41:	48                   	dec    %eax
  802b42:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4a:	e9 fc 00 00 00       	jmp    802c4b <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b52:	83 c0 08             	add    $0x8,%eax
  802b55:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b58:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b5f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b62:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b65:	01 d0                	add    %edx,%eax
  802b67:	48                   	dec    %eax
  802b68:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b6e:	ba 00 00 00 00       	mov    $0x0,%edx
  802b73:	f7 75 c4             	divl   -0x3c(%ebp)
  802b76:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b79:	29 d0                	sub    %edx,%eax
  802b7b:	c1 e8 0c             	shr    $0xc,%eax
  802b7e:	83 ec 0c             	sub    $0xc,%esp
  802b81:	50                   	push   %eax
  802b82:	e8 37 e7 ff ff       	call   8012be <sbrk>
  802b87:	83 c4 10             	add    $0x10,%esp
  802b8a:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802b8d:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802b91:	75 0a                	jne    802b9d <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802b93:	b8 00 00 00 00       	mov    $0x0,%eax
  802b98:	e9 ae 00 00 00       	jmp    802c4b <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b9d:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802ba4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ba7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802baa:	01 d0                	add    %edx,%eax
  802bac:	48                   	dec    %eax
  802bad:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802bb0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bb3:	ba 00 00 00 00       	mov    $0x0,%edx
  802bb8:	f7 75 b8             	divl   -0x48(%ebp)
  802bbb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bbe:	29 d0                	sub    %edx,%eax
  802bc0:	8d 50 fc             	lea    -0x4(%eax),%edx
  802bc3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802bc6:	01 d0                	add    %edx,%eax
  802bc8:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802bcd:	a1 40 50 80 00       	mov    0x805040,%eax
  802bd2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802bd8:	83 ec 0c             	sub    $0xc,%esp
  802bdb:	68 b8 44 80 00       	push   $0x8044b8
  802be0:	e8 3f d9 ff ff       	call   800524 <cprintf>
  802be5:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802be8:	83 ec 08             	sub    $0x8,%esp
  802beb:	ff 75 bc             	pushl  -0x44(%ebp)
  802bee:	68 bd 44 80 00       	push   $0x8044bd
  802bf3:	e8 2c d9 ff ff       	call   800524 <cprintf>
  802bf8:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802bfb:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802c02:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c05:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c08:	01 d0                	add    %edx,%eax
  802c0a:	48                   	dec    %eax
  802c0b:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802c0e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c11:	ba 00 00 00 00       	mov    $0x0,%edx
  802c16:	f7 75 b0             	divl   -0x50(%ebp)
  802c19:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c1c:	29 d0                	sub    %edx,%eax
  802c1e:	83 ec 04             	sub    $0x4,%esp
  802c21:	6a 01                	push   $0x1
  802c23:	50                   	push   %eax
  802c24:	ff 75 bc             	pushl  -0x44(%ebp)
  802c27:	e8 51 f5 ff ff       	call   80217d <set_block_data>
  802c2c:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802c2f:	83 ec 0c             	sub    $0xc,%esp
  802c32:	ff 75 bc             	pushl  -0x44(%ebp)
  802c35:	e8 36 04 00 00       	call   803070 <free_block>
  802c3a:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802c3d:	83 ec 0c             	sub    $0xc,%esp
  802c40:	ff 75 08             	pushl  0x8(%ebp)
  802c43:	e8 20 fa ff ff       	call   802668 <alloc_block_BF>
  802c48:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802c4b:	c9                   	leave  
  802c4c:	c3                   	ret    

00802c4d <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802c4d:	55                   	push   %ebp
  802c4e:	89 e5                	mov    %esp,%ebp
  802c50:	53                   	push   %ebx
  802c51:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802c54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c5b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802c62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c66:	74 1e                	je     802c86 <merging+0x39>
  802c68:	ff 75 08             	pushl  0x8(%ebp)
  802c6b:	e8 bc f1 ff ff       	call   801e2c <get_block_size>
  802c70:	83 c4 04             	add    $0x4,%esp
  802c73:	89 c2                	mov    %eax,%edx
  802c75:	8b 45 08             	mov    0x8(%ebp),%eax
  802c78:	01 d0                	add    %edx,%eax
  802c7a:	3b 45 10             	cmp    0x10(%ebp),%eax
  802c7d:	75 07                	jne    802c86 <merging+0x39>
		prev_is_free = 1;
  802c7f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802c86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c8a:	74 1e                	je     802caa <merging+0x5d>
  802c8c:	ff 75 10             	pushl  0x10(%ebp)
  802c8f:	e8 98 f1 ff ff       	call   801e2c <get_block_size>
  802c94:	83 c4 04             	add    $0x4,%esp
  802c97:	89 c2                	mov    %eax,%edx
  802c99:	8b 45 10             	mov    0x10(%ebp),%eax
  802c9c:	01 d0                	add    %edx,%eax
  802c9e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ca1:	75 07                	jne    802caa <merging+0x5d>
		next_is_free = 1;
  802ca3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802caa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cae:	0f 84 cc 00 00 00    	je     802d80 <merging+0x133>
  802cb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cb8:	0f 84 c2 00 00 00    	je     802d80 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802cbe:	ff 75 08             	pushl  0x8(%ebp)
  802cc1:	e8 66 f1 ff ff       	call   801e2c <get_block_size>
  802cc6:	83 c4 04             	add    $0x4,%esp
  802cc9:	89 c3                	mov    %eax,%ebx
  802ccb:	ff 75 10             	pushl  0x10(%ebp)
  802cce:	e8 59 f1 ff ff       	call   801e2c <get_block_size>
  802cd3:	83 c4 04             	add    $0x4,%esp
  802cd6:	01 c3                	add    %eax,%ebx
  802cd8:	ff 75 0c             	pushl  0xc(%ebp)
  802cdb:	e8 4c f1 ff ff       	call   801e2c <get_block_size>
  802ce0:	83 c4 04             	add    $0x4,%esp
  802ce3:	01 d8                	add    %ebx,%eax
  802ce5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ce8:	6a 00                	push   $0x0
  802cea:	ff 75 ec             	pushl  -0x14(%ebp)
  802ced:	ff 75 08             	pushl  0x8(%ebp)
  802cf0:	e8 88 f4 ff ff       	call   80217d <set_block_data>
  802cf5:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802cf8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cfc:	75 17                	jne    802d15 <merging+0xc8>
  802cfe:	83 ec 04             	sub    $0x4,%esp
  802d01:	68 f3 43 80 00       	push   $0x8043f3
  802d06:	68 7d 01 00 00       	push   $0x17d
  802d0b:	68 11 44 80 00       	push   $0x804411
  802d10:	e8 52 d5 ff ff       	call   800267 <_panic>
  802d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d18:	8b 00                	mov    (%eax),%eax
  802d1a:	85 c0                	test   %eax,%eax
  802d1c:	74 10                	je     802d2e <merging+0xe1>
  802d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d21:	8b 00                	mov    (%eax),%eax
  802d23:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d26:	8b 52 04             	mov    0x4(%edx),%edx
  802d29:	89 50 04             	mov    %edx,0x4(%eax)
  802d2c:	eb 0b                	jmp    802d39 <merging+0xec>
  802d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d31:	8b 40 04             	mov    0x4(%eax),%eax
  802d34:	a3 30 50 80 00       	mov    %eax,0x805030
  802d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d3c:	8b 40 04             	mov    0x4(%eax),%eax
  802d3f:	85 c0                	test   %eax,%eax
  802d41:	74 0f                	je     802d52 <merging+0x105>
  802d43:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d46:	8b 40 04             	mov    0x4(%eax),%eax
  802d49:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d4c:	8b 12                	mov    (%edx),%edx
  802d4e:	89 10                	mov    %edx,(%eax)
  802d50:	eb 0a                	jmp    802d5c <merging+0x10f>
  802d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d55:	8b 00                	mov    (%eax),%eax
  802d57:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d65:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d6f:	a1 38 50 80 00       	mov    0x805038,%eax
  802d74:	48                   	dec    %eax
  802d75:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802d7a:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d7b:	e9 ea 02 00 00       	jmp    80306a <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802d80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d84:	74 3b                	je     802dc1 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802d86:	83 ec 0c             	sub    $0xc,%esp
  802d89:	ff 75 08             	pushl  0x8(%ebp)
  802d8c:	e8 9b f0 ff ff       	call   801e2c <get_block_size>
  802d91:	83 c4 10             	add    $0x10,%esp
  802d94:	89 c3                	mov    %eax,%ebx
  802d96:	83 ec 0c             	sub    $0xc,%esp
  802d99:	ff 75 10             	pushl  0x10(%ebp)
  802d9c:	e8 8b f0 ff ff       	call   801e2c <get_block_size>
  802da1:	83 c4 10             	add    $0x10,%esp
  802da4:	01 d8                	add    %ebx,%eax
  802da6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802da9:	83 ec 04             	sub    $0x4,%esp
  802dac:	6a 00                	push   $0x0
  802dae:	ff 75 e8             	pushl  -0x18(%ebp)
  802db1:	ff 75 08             	pushl  0x8(%ebp)
  802db4:	e8 c4 f3 ff ff       	call   80217d <set_block_data>
  802db9:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802dbc:	e9 a9 02 00 00       	jmp    80306a <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802dc1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dc5:	0f 84 2d 01 00 00    	je     802ef8 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802dcb:	83 ec 0c             	sub    $0xc,%esp
  802dce:	ff 75 10             	pushl  0x10(%ebp)
  802dd1:	e8 56 f0 ff ff       	call   801e2c <get_block_size>
  802dd6:	83 c4 10             	add    $0x10,%esp
  802dd9:	89 c3                	mov    %eax,%ebx
  802ddb:	83 ec 0c             	sub    $0xc,%esp
  802dde:	ff 75 0c             	pushl  0xc(%ebp)
  802de1:	e8 46 f0 ff ff       	call   801e2c <get_block_size>
  802de6:	83 c4 10             	add    $0x10,%esp
  802de9:	01 d8                	add    %ebx,%eax
  802deb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802dee:	83 ec 04             	sub    $0x4,%esp
  802df1:	6a 00                	push   $0x0
  802df3:	ff 75 e4             	pushl  -0x1c(%ebp)
  802df6:	ff 75 10             	pushl  0x10(%ebp)
  802df9:	e8 7f f3 ff ff       	call   80217d <set_block_data>
  802dfe:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802e01:	8b 45 10             	mov    0x10(%ebp),%eax
  802e04:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802e07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e0b:	74 06                	je     802e13 <merging+0x1c6>
  802e0d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e11:	75 17                	jne    802e2a <merging+0x1dd>
  802e13:	83 ec 04             	sub    $0x4,%esp
  802e16:	68 cc 44 80 00       	push   $0x8044cc
  802e1b:	68 8d 01 00 00       	push   $0x18d
  802e20:	68 11 44 80 00       	push   $0x804411
  802e25:	e8 3d d4 ff ff       	call   800267 <_panic>
  802e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e2d:	8b 50 04             	mov    0x4(%eax),%edx
  802e30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e33:	89 50 04             	mov    %edx,0x4(%eax)
  802e36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e39:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e3c:	89 10                	mov    %edx,(%eax)
  802e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e41:	8b 40 04             	mov    0x4(%eax),%eax
  802e44:	85 c0                	test   %eax,%eax
  802e46:	74 0d                	je     802e55 <merging+0x208>
  802e48:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e4b:	8b 40 04             	mov    0x4(%eax),%eax
  802e4e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e51:	89 10                	mov    %edx,(%eax)
  802e53:	eb 08                	jmp    802e5d <merging+0x210>
  802e55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e58:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e60:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e63:	89 50 04             	mov    %edx,0x4(%eax)
  802e66:	a1 38 50 80 00       	mov    0x805038,%eax
  802e6b:	40                   	inc    %eax
  802e6c:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802e71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e75:	75 17                	jne    802e8e <merging+0x241>
  802e77:	83 ec 04             	sub    $0x4,%esp
  802e7a:	68 f3 43 80 00       	push   $0x8043f3
  802e7f:	68 8e 01 00 00       	push   $0x18e
  802e84:	68 11 44 80 00       	push   $0x804411
  802e89:	e8 d9 d3 ff ff       	call   800267 <_panic>
  802e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e91:	8b 00                	mov    (%eax),%eax
  802e93:	85 c0                	test   %eax,%eax
  802e95:	74 10                	je     802ea7 <merging+0x25a>
  802e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9a:	8b 00                	mov    (%eax),%eax
  802e9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e9f:	8b 52 04             	mov    0x4(%edx),%edx
  802ea2:	89 50 04             	mov    %edx,0x4(%eax)
  802ea5:	eb 0b                	jmp    802eb2 <merging+0x265>
  802ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eaa:	8b 40 04             	mov    0x4(%eax),%eax
  802ead:	a3 30 50 80 00       	mov    %eax,0x805030
  802eb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb5:	8b 40 04             	mov    0x4(%eax),%eax
  802eb8:	85 c0                	test   %eax,%eax
  802eba:	74 0f                	je     802ecb <merging+0x27e>
  802ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ebf:	8b 40 04             	mov    0x4(%eax),%eax
  802ec2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ec5:	8b 12                	mov    (%edx),%edx
  802ec7:	89 10                	mov    %edx,(%eax)
  802ec9:	eb 0a                	jmp    802ed5 <merging+0x288>
  802ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ece:	8b 00                	mov    (%eax),%eax
  802ed0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ed8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ede:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee8:	a1 38 50 80 00       	mov    0x805038,%eax
  802eed:	48                   	dec    %eax
  802eee:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ef3:	e9 72 01 00 00       	jmp    80306a <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802ef8:	8b 45 10             	mov    0x10(%ebp),%eax
  802efb:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802efe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f02:	74 79                	je     802f7d <merging+0x330>
  802f04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f08:	74 73                	je     802f7d <merging+0x330>
  802f0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f0e:	74 06                	je     802f16 <merging+0x2c9>
  802f10:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f14:	75 17                	jne    802f2d <merging+0x2e0>
  802f16:	83 ec 04             	sub    $0x4,%esp
  802f19:	68 84 44 80 00       	push   $0x804484
  802f1e:	68 94 01 00 00       	push   $0x194
  802f23:	68 11 44 80 00       	push   $0x804411
  802f28:	e8 3a d3 ff ff       	call   800267 <_panic>
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	8b 10                	mov    (%eax),%edx
  802f32:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f35:	89 10                	mov    %edx,(%eax)
  802f37:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f3a:	8b 00                	mov    (%eax),%eax
  802f3c:	85 c0                	test   %eax,%eax
  802f3e:	74 0b                	je     802f4b <merging+0x2fe>
  802f40:	8b 45 08             	mov    0x8(%ebp),%eax
  802f43:	8b 00                	mov    (%eax),%eax
  802f45:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f48:	89 50 04             	mov    %edx,0x4(%eax)
  802f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f51:	89 10                	mov    %edx,(%eax)
  802f53:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f56:	8b 55 08             	mov    0x8(%ebp),%edx
  802f59:	89 50 04             	mov    %edx,0x4(%eax)
  802f5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f5f:	8b 00                	mov    (%eax),%eax
  802f61:	85 c0                	test   %eax,%eax
  802f63:	75 08                	jne    802f6d <merging+0x320>
  802f65:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f68:	a3 30 50 80 00       	mov    %eax,0x805030
  802f6d:	a1 38 50 80 00       	mov    0x805038,%eax
  802f72:	40                   	inc    %eax
  802f73:	a3 38 50 80 00       	mov    %eax,0x805038
  802f78:	e9 ce 00 00 00       	jmp    80304b <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802f7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f81:	74 65                	je     802fe8 <merging+0x39b>
  802f83:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f87:	75 17                	jne    802fa0 <merging+0x353>
  802f89:	83 ec 04             	sub    $0x4,%esp
  802f8c:	68 60 44 80 00       	push   $0x804460
  802f91:	68 95 01 00 00       	push   $0x195
  802f96:	68 11 44 80 00       	push   $0x804411
  802f9b:	e8 c7 d2 ff ff       	call   800267 <_panic>
  802fa0:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802fa6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa9:	89 50 04             	mov    %edx,0x4(%eax)
  802fac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802faf:	8b 40 04             	mov    0x4(%eax),%eax
  802fb2:	85 c0                	test   %eax,%eax
  802fb4:	74 0c                	je     802fc2 <merging+0x375>
  802fb6:	a1 30 50 80 00       	mov    0x805030,%eax
  802fbb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fbe:	89 10                	mov    %edx,(%eax)
  802fc0:	eb 08                	jmp    802fca <merging+0x37d>
  802fc2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fc5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fcd:	a3 30 50 80 00       	mov    %eax,0x805030
  802fd2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fdb:	a1 38 50 80 00       	mov    0x805038,%eax
  802fe0:	40                   	inc    %eax
  802fe1:	a3 38 50 80 00       	mov    %eax,0x805038
  802fe6:	eb 63                	jmp    80304b <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802fe8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fec:	75 17                	jne    803005 <merging+0x3b8>
  802fee:	83 ec 04             	sub    $0x4,%esp
  802ff1:	68 2c 44 80 00       	push   $0x80442c
  802ff6:	68 98 01 00 00       	push   $0x198
  802ffb:	68 11 44 80 00       	push   $0x804411
  803000:	e8 62 d2 ff ff       	call   800267 <_panic>
  803005:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80300b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80300e:	89 10                	mov    %edx,(%eax)
  803010:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803013:	8b 00                	mov    (%eax),%eax
  803015:	85 c0                	test   %eax,%eax
  803017:	74 0d                	je     803026 <merging+0x3d9>
  803019:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80301e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803021:	89 50 04             	mov    %edx,0x4(%eax)
  803024:	eb 08                	jmp    80302e <merging+0x3e1>
  803026:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803029:	a3 30 50 80 00       	mov    %eax,0x805030
  80302e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803031:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803036:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803039:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803040:	a1 38 50 80 00       	mov    0x805038,%eax
  803045:	40                   	inc    %eax
  803046:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80304b:	83 ec 0c             	sub    $0xc,%esp
  80304e:	ff 75 10             	pushl  0x10(%ebp)
  803051:	e8 d6 ed ff ff       	call   801e2c <get_block_size>
  803056:	83 c4 10             	add    $0x10,%esp
  803059:	83 ec 04             	sub    $0x4,%esp
  80305c:	6a 00                	push   $0x0
  80305e:	50                   	push   %eax
  80305f:	ff 75 10             	pushl  0x10(%ebp)
  803062:	e8 16 f1 ff ff       	call   80217d <set_block_data>
  803067:	83 c4 10             	add    $0x10,%esp
	}
}
  80306a:	90                   	nop
  80306b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80306e:	c9                   	leave  
  80306f:	c3                   	ret    

00803070 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803070:	55                   	push   %ebp
  803071:	89 e5                	mov    %esp,%ebp
  803073:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803076:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80307b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80307e:	a1 30 50 80 00       	mov    0x805030,%eax
  803083:	3b 45 08             	cmp    0x8(%ebp),%eax
  803086:	73 1b                	jae    8030a3 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803088:	a1 30 50 80 00       	mov    0x805030,%eax
  80308d:	83 ec 04             	sub    $0x4,%esp
  803090:	ff 75 08             	pushl  0x8(%ebp)
  803093:	6a 00                	push   $0x0
  803095:	50                   	push   %eax
  803096:	e8 b2 fb ff ff       	call   802c4d <merging>
  80309b:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80309e:	e9 8b 00 00 00       	jmp    80312e <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8030a3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030ab:	76 18                	jbe    8030c5 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8030ad:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030b2:	83 ec 04             	sub    $0x4,%esp
  8030b5:	ff 75 08             	pushl  0x8(%ebp)
  8030b8:	50                   	push   %eax
  8030b9:	6a 00                	push   $0x0
  8030bb:	e8 8d fb ff ff       	call   802c4d <merging>
  8030c0:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030c3:	eb 69                	jmp    80312e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030c5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030cd:	eb 39                	jmp    803108 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8030cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030d5:	73 29                	jae    803100 <free_block+0x90>
  8030d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030da:	8b 00                	mov    (%eax),%eax
  8030dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030df:	76 1f                	jbe    803100 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8030e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e4:	8b 00                	mov    (%eax),%eax
  8030e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8030e9:	83 ec 04             	sub    $0x4,%esp
  8030ec:	ff 75 08             	pushl  0x8(%ebp)
  8030ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8030f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8030f5:	e8 53 fb ff ff       	call   802c4d <merging>
  8030fa:	83 c4 10             	add    $0x10,%esp
			break;
  8030fd:	90                   	nop
		}
	}
}
  8030fe:	eb 2e                	jmp    80312e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803100:	a1 34 50 80 00       	mov    0x805034,%eax
  803105:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803108:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80310c:	74 07                	je     803115 <free_block+0xa5>
  80310e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803111:	8b 00                	mov    (%eax),%eax
  803113:	eb 05                	jmp    80311a <free_block+0xaa>
  803115:	b8 00 00 00 00       	mov    $0x0,%eax
  80311a:	a3 34 50 80 00       	mov    %eax,0x805034
  80311f:	a1 34 50 80 00       	mov    0x805034,%eax
  803124:	85 c0                	test   %eax,%eax
  803126:	75 a7                	jne    8030cf <free_block+0x5f>
  803128:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80312c:	75 a1                	jne    8030cf <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80312e:	90                   	nop
  80312f:	c9                   	leave  
  803130:	c3                   	ret    

00803131 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803131:	55                   	push   %ebp
  803132:	89 e5                	mov    %esp,%ebp
  803134:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803137:	ff 75 08             	pushl  0x8(%ebp)
  80313a:	e8 ed ec ff ff       	call   801e2c <get_block_size>
  80313f:	83 c4 04             	add    $0x4,%esp
  803142:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803145:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80314c:	eb 17                	jmp    803165 <copy_data+0x34>
  80314e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803151:	8b 45 0c             	mov    0xc(%ebp),%eax
  803154:	01 c2                	add    %eax,%edx
  803156:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803159:	8b 45 08             	mov    0x8(%ebp),%eax
  80315c:	01 c8                	add    %ecx,%eax
  80315e:	8a 00                	mov    (%eax),%al
  803160:	88 02                	mov    %al,(%edx)
  803162:	ff 45 fc             	incl   -0x4(%ebp)
  803165:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803168:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80316b:	72 e1                	jb     80314e <copy_data+0x1d>
}
  80316d:	90                   	nop
  80316e:	c9                   	leave  
  80316f:	c3                   	ret    

00803170 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803170:	55                   	push   %ebp
  803171:	89 e5                	mov    %esp,%ebp
  803173:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803176:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80317a:	75 23                	jne    80319f <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80317c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803180:	74 13                	je     803195 <realloc_block_FF+0x25>
  803182:	83 ec 0c             	sub    $0xc,%esp
  803185:	ff 75 0c             	pushl  0xc(%ebp)
  803188:	e8 1f f0 ff ff       	call   8021ac <alloc_block_FF>
  80318d:	83 c4 10             	add    $0x10,%esp
  803190:	e9 f4 06 00 00       	jmp    803889 <realloc_block_FF+0x719>
		return NULL;
  803195:	b8 00 00 00 00       	mov    $0x0,%eax
  80319a:	e9 ea 06 00 00       	jmp    803889 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80319f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031a3:	75 18                	jne    8031bd <realloc_block_FF+0x4d>
	{
		free_block(va);
  8031a5:	83 ec 0c             	sub    $0xc,%esp
  8031a8:	ff 75 08             	pushl  0x8(%ebp)
  8031ab:	e8 c0 fe ff ff       	call   803070 <free_block>
  8031b0:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8031b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b8:	e9 cc 06 00 00       	jmp    803889 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8031bd:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8031c1:	77 07                	ja     8031ca <realloc_block_FF+0x5a>
  8031c3:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8031ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031cd:	83 e0 01             	and    $0x1,%eax
  8031d0:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8031d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031d6:	83 c0 08             	add    $0x8,%eax
  8031d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8031dc:	83 ec 0c             	sub    $0xc,%esp
  8031df:	ff 75 08             	pushl  0x8(%ebp)
  8031e2:	e8 45 ec ff ff       	call   801e2c <get_block_size>
  8031e7:	83 c4 10             	add    $0x10,%esp
  8031ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f0:	83 e8 08             	sub    $0x8,%eax
  8031f3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8031f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f9:	83 e8 04             	sub    $0x4,%eax
  8031fc:	8b 00                	mov    (%eax),%eax
  8031fe:	83 e0 fe             	and    $0xfffffffe,%eax
  803201:	89 c2                	mov    %eax,%edx
  803203:	8b 45 08             	mov    0x8(%ebp),%eax
  803206:	01 d0                	add    %edx,%eax
  803208:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80320b:	83 ec 0c             	sub    $0xc,%esp
  80320e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803211:	e8 16 ec ff ff       	call   801e2c <get_block_size>
  803216:	83 c4 10             	add    $0x10,%esp
  803219:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80321c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80321f:	83 e8 08             	sub    $0x8,%eax
  803222:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803225:	8b 45 0c             	mov    0xc(%ebp),%eax
  803228:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80322b:	75 08                	jne    803235 <realloc_block_FF+0xc5>
	{
		 return va;
  80322d:	8b 45 08             	mov    0x8(%ebp),%eax
  803230:	e9 54 06 00 00       	jmp    803889 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803235:	8b 45 0c             	mov    0xc(%ebp),%eax
  803238:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80323b:	0f 83 e5 03 00 00    	jae    803626 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803241:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803244:	2b 45 0c             	sub    0xc(%ebp),%eax
  803247:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80324a:	83 ec 0c             	sub    $0xc,%esp
  80324d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803250:	e8 f0 eb ff ff       	call   801e45 <is_free_block>
  803255:	83 c4 10             	add    $0x10,%esp
  803258:	84 c0                	test   %al,%al
  80325a:	0f 84 3b 01 00 00    	je     80339b <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803260:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803263:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803266:	01 d0                	add    %edx,%eax
  803268:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80326b:	83 ec 04             	sub    $0x4,%esp
  80326e:	6a 01                	push   $0x1
  803270:	ff 75 f0             	pushl  -0x10(%ebp)
  803273:	ff 75 08             	pushl  0x8(%ebp)
  803276:	e8 02 ef ff ff       	call   80217d <set_block_data>
  80327b:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80327e:	8b 45 08             	mov    0x8(%ebp),%eax
  803281:	83 e8 04             	sub    $0x4,%eax
  803284:	8b 00                	mov    (%eax),%eax
  803286:	83 e0 fe             	and    $0xfffffffe,%eax
  803289:	89 c2                	mov    %eax,%edx
  80328b:	8b 45 08             	mov    0x8(%ebp),%eax
  80328e:	01 d0                	add    %edx,%eax
  803290:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803293:	83 ec 04             	sub    $0x4,%esp
  803296:	6a 00                	push   $0x0
  803298:	ff 75 cc             	pushl  -0x34(%ebp)
  80329b:	ff 75 c8             	pushl  -0x38(%ebp)
  80329e:	e8 da ee ff ff       	call   80217d <set_block_data>
  8032a3:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8032a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032aa:	74 06                	je     8032b2 <realloc_block_FF+0x142>
  8032ac:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8032b0:	75 17                	jne    8032c9 <realloc_block_FF+0x159>
  8032b2:	83 ec 04             	sub    $0x4,%esp
  8032b5:	68 84 44 80 00       	push   $0x804484
  8032ba:	68 f6 01 00 00       	push   $0x1f6
  8032bf:	68 11 44 80 00       	push   $0x804411
  8032c4:	e8 9e cf ff ff       	call   800267 <_panic>
  8032c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032cc:	8b 10                	mov    (%eax),%edx
  8032ce:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032d1:	89 10                	mov    %edx,(%eax)
  8032d3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032d6:	8b 00                	mov    (%eax),%eax
  8032d8:	85 c0                	test   %eax,%eax
  8032da:	74 0b                	je     8032e7 <realloc_block_FF+0x177>
  8032dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032df:	8b 00                	mov    (%eax),%eax
  8032e1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032e4:	89 50 04             	mov    %edx,0x4(%eax)
  8032e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ea:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032ed:	89 10                	mov    %edx,(%eax)
  8032ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032f5:	89 50 04             	mov    %edx,0x4(%eax)
  8032f8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032fb:	8b 00                	mov    (%eax),%eax
  8032fd:	85 c0                	test   %eax,%eax
  8032ff:	75 08                	jne    803309 <realloc_block_FF+0x199>
  803301:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803304:	a3 30 50 80 00       	mov    %eax,0x805030
  803309:	a1 38 50 80 00       	mov    0x805038,%eax
  80330e:	40                   	inc    %eax
  80330f:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803314:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803318:	75 17                	jne    803331 <realloc_block_FF+0x1c1>
  80331a:	83 ec 04             	sub    $0x4,%esp
  80331d:	68 f3 43 80 00       	push   $0x8043f3
  803322:	68 f7 01 00 00       	push   $0x1f7
  803327:	68 11 44 80 00       	push   $0x804411
  80332c:	e8 36 cf ff ff       	call   800267 <_panic>
  803331:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803334:	8b 00                	mov    (%eax),%eax
  803336:	85 c0                	test   %eax,%eax
  803338:	74 10                	je     80334a <realloc_block_FF+0x1da>
  80333a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80333d:	8b 00                	mov    (%eax),%eax
  80333f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803342:	8b 52 04             	mov    0x4(%edx),%edx
  803345:	89 50 04             	mov    %edx,0x4(%eax)
  803348:	eb 0b                	jmp    803355 <realloc_block_FF+0x1e5>
  80334a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80334d:	8b 40 04             	mov    0x4(%eax),%eax
  803350:	a3 30 50 80 00       	mov    %eax,0x805030
  803355:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803358:	8b 40 04             	mov    0x4(%eax),%eax
  80335b:	85 c0                	test   %eax,%eax
  80335d:	74 0f                	je     80336e <realloc_block_FF+0x1fe>
  80335f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803362:	8b 40 04             	mov    0x4(%eax),%eax
  803365:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803368:	8b 12                	mov    (%edx),%edx
  80336a:	89 10                	mov    %edx,(%eax)
  80336c:	eb 0a                	jmp    803378 <realloc_block_FF+0x208>
  80336e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803371:	8b 00                	mov    (%eax),%eax
  803373:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803378:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80337b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803381:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803384:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80338b:	a1 38 50 80 00       	mov    0x805038,%eax
  803390:	48                   	dec    %eax
  803391:	a3 38 50 80 00       	mov    %eax,0x805038
  803396:	e9 83 02 00 00       	jmp    80361e <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80339b:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80339f:	0f 86 69 02 00 00    	jbe    80360e <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8033a5:	83 ec 04             	sub    $0x4,%esp
  8033a8:	6a 01                	push   $0x1
  8033aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8033ad:	ff 75 08             	pushl  0x8(%ebp)
  8033b0:	e8 c8 ed ff ff       	call   80217d <set_block_data>
  8033b5:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8033b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bb:	83 e8 04             	sub    $0x4,%eax
  8033be:	8b 00                	mov    (%eax),%eax
  8033c0:	83 e0 fe             	and    $0xfffffffe,%eax
  8033c3:	89 c2                	mov    %eax,%edx
  8033c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c8:	01 d0                	add    %edx,%eax
  8033ca:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8033cd:	a1 38 50 80 00       	mov    0x805038,%eax
  8033d2:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8033d5:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8033d9:	75 68                	jne    803443 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8033db:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033df:	75 17                	jne    8033f8 <realloc_block_FF+0x288>
  8033e1:	83 ec 04             	sub    $0x4,%esp
  8033e4:	68 2c 44 80 00       	push   $0x80442c
  8033e9:	68 06 02 00 00       	push   $0x206
  8033ee:	68 11 44 80 00       	push   $0x804411
  8033f3:	e8 6f ce ff ff       	call   800267 <_panic>
  8033f8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8033fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803401:	89 10                	mov    %edx,(%eax)
  803403:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803406:	8b 00                	mov    (%eax),%eax
  803408:	85 c0                	test   %eax,%eax
  80340a:	74 0d                	je     803419 <realloc_block_FF+0x2a9>
  80340c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803411:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803414:	89 50 04             	mov    %edx,0x4(%eax)
  803417:	eb 08                	jmp    803421 <realloc_block_FF+0x2b1>
  803419:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80341c:	a3 30 50 80 00       	mov    %eax,0x805030
  803421:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803424:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803429:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80342c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803433:	a1 38 50 80 00       	mov    0x805038,%eax
  803438:	40                   	inc    %eax
  803439:	a3 38 50 80 00       	mov    %eax,0x805038
  80343e:	e9 b0 01 00 00       	jmp    8035f3 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803443:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803448:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80344b:	76 68                	jbe    8034b5 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80344d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803451:	75 17                	jne    80346a <realloc_block_FF+0x2fa>
  803453:	83 ec 04             	sub    $0x4,%esp
  803456:	68 2c 44 80 00       	push   $0x80442c
  80345b:	68 0b 02 00 00       	push   $0x20b
  803460:	68 11 44 80 00       	push   $0x804411
  803465:	e8 fd cd ff ff       	call   800267 <_panic>
  80346a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803470:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803473:	89 10                	mov    %edx,(%eax)
  803475:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803478:	8b 00                	mov    (%eax),%eax
  80347a:	85 c0                	test   %eax,%eax
  80347c:	74 0d                	je     80348b <realloc_block_FF+0x31b>
  80347e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803483:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803486:	89 50 04             	mov    %edx,0x4(%eax)
  803489:	eb 08                	jmp    803493 <realloc_block_FF+0x323>
  80348b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80348e:	a3 30 50 80 00       	mov    %eax,0x805030
  803493:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803496:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80349b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80349e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034a5:	a1 38 50 80 00       	mov    0x805038,%eax
  8034aa:	40                   	inc    %eax
  8034ab:	a3 38 50 80 00       	mov    %eax,0x805038
  8034b0:	e9 3e 01 00 00       	jmp    8035f3 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8034b5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034ba:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034bd:	73 68                	jae    803527 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034bf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034c3:	75 17                	jne    8034dc <realloc_block_FF+0x36c>
  8034c5:	83 ec 04             	sub    $0x4,%esp
  8034c8:	68 60 44 80 00       	push   $0x804460
  8034cd:	68 10 02 00 00       	push   $0x210
  8034d2:	68 11 44 80 00       	push   $0x804411
  8034d7:	e8 8b cd ff ff       	call   800267 <_panic>
  8034dc:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8034e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e5:	89 50 04             	mov    %edx,0x4(%eax)
  8034e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034eb:	8b 40 04             	mov    0x4(%eax),%eax
  8034ee:	85 c0                	test   %eax,%eax
  8034f0:	74 0c                	je     8034fe <realloc_block_FF+0x38e>
  8034f2:	a1 30 50 80 00       	mov    0x805030,%eax
  8034f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034fa:	89 10                	mov    %edx,(%eax)
  8034fc:	eb 08                	jmp    803506 <realloc_block_FF+0x396>
  8034fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803501:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803506:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803509:	a3 30 50 80 00       	mov    %eax,0x805030
  80350e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803511:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803517:	a1 38 50 80 00       	mov    0x805038,%eax
  80351c:	40                   	inc    %eax
  80351d:	a3 38 50 80 00       	mov    %eax,0x805038
  803522:	e9 cc 00 00 00       	jmp    8035f3 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803527:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80352e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803533:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803536:	e9 8a 00 00 00       	jmp    8035c5 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80353b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803541:	73 7a                	jae    8035bd <realloc_block_FF+0x44d>
  803543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803546:	8b 00                	mov    (%eax),%eax
  803548:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80354b:	73 70                	jae    8035bd <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80354d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803551:	74 06                	je     803559 <realloc_block_FF+0x3e9>
  803553:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803557:	75 17                	jne    803570 <realloc_block_FF+0x400>
  803559:	83 ec 04             	sub    $0x4,%esp
  80355c:	68 84 44 80 00       	push   $0x804484
  803561:	68 1a 02 00 00       	push   $0x21a
  803566:	68 11 44 80 00       	push   $0x804411
  80356b:	e8 f7 cc ff ff       	call   800267 <_panic>
  803570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803573:	8b 10                	mov    (%eax),%edx
  803575:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803578:	89 10                	mov    %edx,(%eax)
  80357a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80357d:	8b 00                	mov    (%eax),%eax
  80357f:	85 c0                	test   %eax,%eax
  803581:	74 0b                	je     80358e <realloc_block_FF+0x41e>
  803583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803586:	8b 00                	mov    (%eax),%eax
  803588:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80358b:	89 50 04             	mov    %edx,0x4(%eax)
  80358e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803591:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803594:	89 10                	mov    %edx,(%eax)
  803596:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803599:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80359c:	89 50 04             	mov    %edx,0x4(%eax)
  80359f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a2:	8b 00                	mov    (%eax),%eax
  8035a4:	85 c0                	test   %eax,%eax
  8035a6:	75 08                	jne    8035b0 <realloc_block_FF+0x440>
  8035a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ab:	a3 30 50 80 00       	mov    %eax,0x805030
  8035b0:	a1 38 50 80 00       	mov    0x805038,%eax
  8035b5:	40                   	inc    %eax
  8035b6:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8035bb:	eb 36                	jmp    8035f3 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8035bd:	a1 34 50 80 00       	mov    0x805034,%eax
  8035c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035c9:	74 07                	je     8035d2 <realloc_block_FF+0x462>
  8035cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ce:	8b 00                	mov    (%eax),%eax
  8035d0:	eb 05                	jmp    8035d7 <realloc_block_FF+0x467>
  8035d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8035d7:	a3 34 50 80 00       	mov    %eax,0x805034
  8035dc:	a1 34 50 80 00       	mov    0x805034,%eax
  8035e1:	85 c0                	test   %eax,%eax
  8035e3:	0f 85 52 ff ff ff    	jne    80353b <realloc_block_FF+0x3cb>
  8035e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035ed:	0f 85 48 ff ff ff    	jne    80353b <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8035f3:	83 ec 04             	sub    $0x4,%esp
  8035f6:	6a 00                	push   $0x0
  8035f8:	ff 75 d8             	pushl  -0x28(%ebp)
  8035fb:	ff 75 d4             	pushl  -0x2c(%ebp)
  8035fe:	e8 7a eb ff ff       	call   80217d <set_block_data>
  803603:	83 c4 10             	add    $0x10,%esp
				return va;
  803606:	8b 45 08             	mov    0x8(%ebp),%eax
  803609:	e9 7b 02 00 00       	jmp    803889 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80360e:	83 ec 0c             	sub    $0xc,%esp
  803611:	68 01 45 80 00       	push   $0x804501
  803616:	e8 09 cf ff ff       	call   800524 <cprintf>
  80361b:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80361e:	8b 45 08             	mov    0x8(%ebp),%eax
  803621:	e9 63 02 00 00       	jmp    803889 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803626:	8b 45 0c             	mov    0xc(%ebp),%eax
  803629:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80362c:	0f 86 4d 02 00 00    	jbe    80387f <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803632:	83 ec 0c             	sub    $0xc,%esp
  803635:	ff 75 e4             	pushl  -0x1c(%ebp)
  803638:	e8 08 e8 ff ff       	call   801e45 <is_free_block>
  80363d:	83 c4 10             	add    $0x10,%esp
  803640:	84 c0                	test   %al,%al
  803642:	0f 84 37 02 00 00    	je     80387f <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803648:	8b 45 0c             	mov    0xc(%ebp),%eax
  80364b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80364e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803651:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803654:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803657:	76 38                	jbe    803691 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803659:	83 ec 0c             	sub    $0xc,%esp
  80365c:	ff 75 08             	pushl  0x8(%ebp)
  80365f:	e8 0c fa ff ff       	call   803070 <free_block>
  803664:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803667:	83 ec 0c             	sub    $0xc,%esp
  80366a:	ff 75 0c             	pushl  0xc(%ebp)
  80366d:	e8 3a eb ff ff       	call   8021ac <alloc_block_FF>
  803672:	83 c4 10             	add    $0x10,%esp
  803675:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803678:	83 ec 08             	sub    $0x8,%esp
  80367b:	ff 75 c0             	pushl  -0x40(%ebp)
  80367e:	ff 75 08             	pushl  0x8(%ebp)
  803681:	e8 ab fa ff ff       	call   803131 <copy_data>
  803686:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803689:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80368c:	e9 f8 01 00 00       	jmp    803889 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803691:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803694:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803697:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80369a:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80369e:	0f 87 a0 00 00 00    	ja     803744 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8036a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036a8:	75 17                	jne    8036c1 <realloc_block_FF+0x551>
  8036aa:	83 ec 04             	sub    $0x4,%esp
  8036ad:	68 f3 43 80 00       	push   $0x8043f3
  8036b2:	68 38 02 00 00       	push   $0x238
  8036b7:	68 11 44 80 00       	push   $0x804411
  8036bc:	e8 a6 cb ff ff       	call   800267 <_panic>
  8036c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c4:	8b 00                	mov    (%eax),%eax
  8036c6:	85 c0                	test   %eax,%eax
  8036c8:	74 10                	je     8036da <realloc_block_FF+0x56a>
  8036ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036cd:	8b 00                	mov    (%eax),%eax
  8036cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036d2:	8b 52 04             	mov    0x4(%edx),%edx
  8036d5:	89 50 04             	mov    %edx,0x4(%eax)
  8036d8:	eb 0b                	jmp    8036e5 <realloc_block_FF+0x575>
  8036da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036dd:	8b 40 04             	mov    0x4(%eax),%eax
  8036e0:	a3 30 50 80 00       	mov    %eax,0x805030
  8036e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e8:	8b 40 04             	mov    0x4(%eax),%eax
  8036eb:	85 c0                	test   %eax,%eax
  8036ed:	74 0f                	je     8036fe <realloc_block_FF+0x58e>
  8036ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f2:	8b 40 04             	mov    0x4(%eax),%eax
  8036f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036f8:	8b 12                	mov    (%edx),%edx
  8036fa:	89 10                	mov    %edx,(%eax)
  8036fc:	eb 0a                	jmp    803708 <realloc_block_FF+0x598>
  8036fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803701:	8b 00                	mov    (%eax),%eax
  803703:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803708:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80370b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803711:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803714:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80371b:	a1 38 50 80 00       	mov    0x805038,%eax
  803720:	48                   	dec    %eax
  803721:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803726:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803729:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80372c:	01 d0                	add    %edx,%eax
  80372e:	83 ec 04             	sub    $0x4,%esp
  803731:	6a 01                	push   $0x1
  803733:	50                   	push   %eax
  803734:	ff 75 08             	pushl  0x8(%ebp)
  803737:	e8 41 ea ff ff       	call   80217d <set_block_data>
  80373c:	83 c4 10             	add    $0x10,%esp
  80373f:	e9 36 01 00 00       	jmp    80387a <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803744:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803747:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80374a:	01 d0                	add    %edx,%eax
  80374c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80374f:	83 ec 04             	sub    $0x4,%esp
  803752:	6a 01                	push   $0x1
  803754:	ff 75 f0             	pushl  -0x10(%ebp)
  803757:	ff 75 08             	pushl  0x8(%ebp)
  80375a:	e8 1e ea ff ff       	call   80217d <set_block_data>
  80375f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803762:	8b 45 08             	mov    0x8(%ebp),%eax
  803765:	83 e8 04             	sub    $0x4,%eax
  803768:	8b 00                	mov    (%eax),%eax
  80376a:	83 e0 fe             	and    $0xfffffffe,%eax
  80376d:	89 c2                	mov    %eax,%edx
  80376f:	8b 45 08             	mov    0x8(%ebp),%eax
  803772:	01 d0                	add    %edx,%eax
  803774:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803777:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80377b:	74 06                	je     803783 <realloc_block_FF+0x613>
  80377d:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803781:	75 17                	jne    80379a <realloc_block_FF+0x62a>
  803783:	83 ec 04             	sub    $0x4,%esp
  803786:	68 84 44 80 00       	push   $0x804484
  80378b:	68 44 02 00 00       	push   $0x244
  803790:	68 11 44 80 00       	push   $0x804411
  803795:	e8 cd ca ff ff       	call   800267 <_panic>
  80379a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379d:	8b 10                	mov    (%eax),%edx
  80379f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037a2:	89 10                	mov    %edx,(%eax)
  8037a4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037a7:	8b 00                	mov    (%eax),%eax
  8037a9:	85 c0                	test   %eax,%eax
  8037ab:	74 0b                	je     8037b8 <realloc_block_FF+0x648>
  8037ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b0:	8b 00                	mov    (%eax),%eax
  8037b2:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037b5:	89 50 04             	mov    %edx,0x4(%eax)
  8037b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037bb:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037be:	89 10                	mov    %edx,(%eax)
  8037c0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037c6:	89 50 04             	mov    %edx,0x4(%eax)
  8037c9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037cc:	8b 00                	mov    (%eax),%eax
  8037ce:	85 c0                	test   %eax,%eax
  8037d0:	75 08                	jne    8037da <realloc_block_FF+0x66a>
  8037d2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037d5:	a3 30 50 80 00       	mov    %eax,0x805030
  8037da:	a1 38 50 80 00       	mov    0x805038,%eax
  8037df:	40                   	inc    %eax
  8037e0:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8037e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037e9:	75 17                	jne    803802 <realloc_block_FF+0x692>
  8037eb:	83 ec 04             	sub    $0x4,%esp
  8037ee:	68 f3 43 80 00       	push   $0x8043f3
  8037f3:	68 45 02 00 00       	push   $0x245
  8037f8:	68 11 44 80 00       	push   $0x804411
  8037fd:	e8 65 ca ff ff       	call   800267 <_panic>
  803802:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803805:	8b 00                	mov    (%eax),%eax
  803807:	85 c0                	test   %eax,%eax
  803809:	74 10                	je     80381b <realloc_block_FF+0x6ab>
  80380b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380e:	8b 00                	mov    (%eax),%eax
  803810:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803813:	8b 52 04             	mov    0x4(%edx),%edx
  803816:	89 50 04             	mov    %edx,0x4(%eax)
  803819:	eb 0b                	jmp    803826 <realloc_block_FF+0x6b6>
  80381b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381e:	8b 40 04             	mov    0x4(%eax),%eax
  803821:	a3 30 50 80 00       	mov    %eax,0x805030
  803826:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803829:	8b 40 04             	mov    0x4(%eax),%eax
  80382c:	85 c0                	test   %eax,%eax
  80382e:	74 0f                	je     80383f <realloc_block_FF+0x6cf>
  803830:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803833:	8b 40 04             	mov    0x4(%eax),%eax
  803836:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803839:	8b 12                	mov    (%edx),%edx
  80383b:	89 10                	mov    %edx,(%eax)
  80383d:	eb 0a                	jmp    803849 <realloc_block_FF+0x6d9>
  80383f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803842:	8b 00                	mov    (%eax),%eax
  803844:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803852:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803855:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80385c:	a1 38 50 80 00       	mov    0x805038,%eax
  803861:	48                   	dec    %eax
  803862:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803867:	83 ec 04             	sub    $0x4,%esp
  80386a:	6a 00                	push   $0x0
  80386c:	ff 75 bc             	pushl  -0x44(%ebp)
  80386f:	ff 75 b8             	pushl  -0x48(%ebp)
  803872:	e8 06 e9 ff ff       	call   80217d <set_block_data>
  803877:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80387a:	8b 45 08             	mov    0x8(%ebp),%eax
  80387d:	eb 0a                	jmp    803889 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80387f:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803886:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803889:	c9                   	leave  
  80388a:	c3                   	ret    

0080388b <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80388b:	55                   	push   %ebp
  80388c:	89 e5                	mov    %esp,%ebp
  80388e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803891:	83 ec 04             	sub    $0x4,%esp
  803894:	68 08 45 80 00       	push   $0x804508
  803899:	68 58 02 00 00       	push   $0x258
  80389e:	68 11 44 80 00       	push   $0x804411
  8038a3:	e8 bf c9 ff ff       	call   800267 <_panic>

008038a8 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8038a8:	55                   	push   %ebp
  8038a9:	89 e5                	mov    %esp,%ebp
  8038ab:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8038ae:	83 ec 04             	sub    $0x4,%esp
  8038b1:	68 30 45 80 00       	push   $0x804530
  8038b6:	68 61 02 00 00       	push   $0x261
  8038bb:	68 11 44 80 00       	push   $0x804411
  8038c0:	e8 a2 c9 ff ff       	call   800267 <_panic>

008038c5 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8038c5:	55                   	push   %ebp
  8038c6:	89 e5                	mov    %esp,%ebp
  8038c8:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8038cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8038ce:	89 d0                	mov    %edx,%eax
  8038d0:	c1 e0 02             	shl    $0x2,%eax
  8038d3:	01 d0                	add    %edx,%eax
  8038d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038dc:	01 d0                	add    %edx,%eax
  8038de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038e5:	01 d0                	add    %edx,%eax
  8038e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038ee:	01 d0                	add    %edx,%eax
  8038f0:	c1 e0 04             	shl    $0x4,%eax
  8038f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8038f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8038fd:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803900:	83 ec 0c             	sub    $0xc,%esp
  803903:	50                   	push   %eax
  803904:	e8 2f e2 ff ff       	call   801b38 <sys_get_virtual_time>
  803909:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80390c:	eb 41                	jmp    80394f <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80390e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803911:	83 ec 0c             	sub    $0xc,%esp
  803914:	50                   	push   %eax
  803915:	e8 1e e2 ff ff       	call   801b38 <sys_get_virtual_time>
  80391a:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80391d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803920:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803923:	29 c2                	sub    %eax,%edx
  803925:	89 d0                	mov    %edx,%eax
  803927:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80392a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80392d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803930:	89 d1                	mov    %edx,%ecx
  803932:	29 c1                	sub    %eax,%ecx
  803934:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803937:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80393a:	39 c2                	cmp    %eax,%edx
  80393c:	0f 97 c0             	seta   %al
  80393f:	0f b6 c0             	movzbl %al,%eax
  803942:	29 c1                	sub    %eax,%ecx
  803944:	89 c8                	mov    %ecx,%eax
  803946:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803949:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80394c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80394f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803952:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803955:	72 b7                	jb     80390e <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803957:	90                   	nop
  803958:	c9                   	leave  
  803959:	c3                   	ret    

0080395a <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80395a:	55                   	push   %ebp
  80395b:	89 e5                	mov    %esp,%ebp
  80395d:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803960:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803967:	eb 03                	jmp    80396c <busy_wait+0x12>
  803969:	ff 45 fc             	incl   -0x4(%ebp)
  80396c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80396f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803972:	72 f5                	jb     803969 <busy_wait+0xf>
	return i;
  803974:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803977:	c9                   	leave  
  803978:	c3                   	ret    
  803979:	66 90                	xchg   %ax,%ax
  80397b:	90                   	nop

0080397c <__udivdi3>:
  80397c:	55                   	push   %ebp
  80397d:	57                   	push   %edi
  80397e:	56                   	push   %esi
  80397f:	53                   	push   %ebx
  803980:	83 ec 1c             	sub    $0x1c,%esp
  803983:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803987:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80398b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80398f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803993:	89 ca                	mov    %ecx,%edx
  803995:	89 f8                	mov    %edi,%eax
  803997:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80399b:	85 f6                	test   %esi,%esi
  80399d:	75 2d                	jne    8039cc <__udivdi3+0x50>
  80399f:	39 cf                	cmp    %ecx,%edi
  8039a1:	77 65                	ja     803a08 <__udivdi3+0x8c>
  8039a3:	89 fd                	mov    %edi,%ebp
  8039a5:	85 ff                	test   %edi,%edi
  8039a7:	75 0b                	jne    8039b4 <__udivdi3+0x38>
  8039a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8039ae:	31 d2                	xor    %edx,%edx
  8039b0:	f7 f7                	div    %edi
  8039b2:	89 c5                	mov    %eax,%ebp
  8039b4:	31 d2                	xor    %edx,%edx
  8039b6:	89 c8                	mov    %ecx,%eax
  8039b8:	f7 f5                	div    %ebp
  8039ba:	89 c1                	mov    %eax,%ecx
  8039bc:	89 d8                	mov    %ebx,%eax
  8039be:	f7 f5                	div    %ebp
  8039c0:	89 cf                	mov    %ecx,%edi
  8039c2:	89 fa                	mov    %edi,%edx
  8039c4:	83 c4 1c             	add    $0x1c,%esp
  8039c7:	5b                   	pop    %ebx
  8039c8:	5e                   	pop    %esi
  8039c9:	5f                   	pop    %edi
  8039ca:	5d                   	pop    %ebp
  8039cb:	c3                   	ret    
  8039cc:	39 ce                	cmp    %ecx,%esi
  8039ce:	77 28                	ja     8039f8 <__udivdi3+0x7c>
  8039d0:	0f bd fe             	bsr    %esi,%edi
  8039d3:	83 f7 1f             	xor    $0x1f,%edi
  8039d6:	75 40                	jne    803a18 <__udivdi3+0x9c>
  8039d8:	39 ce                	cmp    %ecx,%esi
  8039da:	72 0a                	jb     8039e6 <__udivdi3+0x6a>
  8039dc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8039e0:	0f 87 9e 00 00 00    	ja     803a84 <__udivdi3+0x108>
  8039e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8039eb:	89 fa                	mov    %edi,%edx
  8039ed:	83 c4 1c             	add    $0x1c,%esp
  8039f0:	5b                   	pop    %ebx
  8039f1:	5e                   	pop    %esi
  8039f2:	5f                   	pop    %edi
  8039f3:	5d                   	pop    %ebp
  8039f4:	c3                   	ret    
  8039f5:	8d 76 00             	lea    0x0(%esi),%esi
  8039f8:	31 ff                	xor    %edi,%edi
  8039fa:	31 c0                	xor    %eax,%eax
  8039fc:	89 fa                	mov    %edi,%edx
  8039fe:	83 c4 1c             	add    $0x1c,%esp
  803a01:	5b                   	pop    %ebx
  803a02:	5e                   	pop    %esi
  803a03:	5f                   	pop    %edi
  803a04:	5d                   	pop    %ebp
  803a05:	c3                   	ret    
  803a06:	66 90                	xchg   %ax,%ax
  803a08:	89 d8                	mov    %ebx,%eax
  803a0a:	f7 f7                	div    %edi
  803a0c:	31 ff                	xor    %edi,%edi
  803a0e:	89 fa                	mov    %edi,%edx
  803a10:	83 c4 1c             	add    $0x1c,%esp
  803a13:	5b                   	pop    %ebx
  803a14:	5e                   	pop    %esi
  803a15:	5f                   	pop    %edi
  803a16:	5d                   	pop    %ebp
  803a17:	c3                   	ret    
  803a18:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a1d:	89 eb                	mov    %ebp,%ebx
  803a1f:	29 fb                	sub    %edi,%ebx
  803a21:	89 f9                	mov    %edi,%ecx
  803a23:	d3 e6                	shl    %cl,%esi
  803a25:	89 c5                	mov    %eax,%ebp
  803a27:	88 d9                	mov    %bl,%cl
  803a29:	d3 ed                	shr    %cl,%ebp
  803a2b:	89 e9                	mov    %ebp,%ecx
  803a2d:	09 f1                	or     %esi,%ecx
  803a2f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a33:	89 f9                	mov    %edi,%ecx
  803a35:	d3 e0                	shl    %cl,%eax
  803a37:	89 c5                	mov    %eax,%ebp
  803a39:	89 d6                	mov    %edx,%esi
  803a3b:	88 d9                	mov    %bl,%cl
  803a3d:	d3 ee                	shr    %cl,%esi
  803a3f:	89 f9                	mov    %edi,%ecx
  803a41:	d3 e2                	shl    %cl,%edx
  803a43:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a47:	88 d9                	mov    %bl,%cl
  803a49:	d3 e8                	shr    %cl,%eax
  803a4b:	09 c2                	or     %eax,%edx
  803a4d:	89 d0                	mov    %edx,%eax
  803a4f:	89 f2                	mov    %esi,%edx
  803a51:	f7 74 24 0c          	divl   0xc(%esp)
  803a55:	89 d6                	mov    %edx,%esi
  803a57:	89 c3                	mov    %eax,%ebx
  803a59:	f7 e5                	mul    %ebp
  803a5b:	39 d6                	cmp    %edx,%esi
  803a5d:	72 19                	jb     803a78 <__udivdi3+0xfc>
  803a5f:	74 0b                	je     803a6c <__udivdi3+0xf0>
  803a61:	89 d8                	mov    %ebx,%eax
  803a63:	31 ff                	xor    %edi,%edi
  803a65:	e9 58 ff ff ff       	jmp    8039c2 <__udivdi3+0x46>
  803a6a:	66 90                	xchg   %ax,%ax
  803a6c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a70:	89 f9                	mov    %edi,%ecx
  803a72:	d3 e2                	shl    %cl,%edx
  803a74:	39 c2                	cmp    %eax,%edx
  803a76:	73 e9                	jae    803a61 <__udivdi3+0xe5>
  803a78:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a7b:	31 ff                	xor    %edi,%edi
  803a7d:	e9 40 ff ff ff       	jmp    8039c2 <__udivdi3+0x46>
  803a82:	66 90                	xchg   %ax,%ax
  803a84:	31 c0                	xor    %eax,%eax
  803a86:	e9 37 ff ff ff       	jmp    8039c2 <__udivdi3+0x46>
  803a8b:	90                   	nop

00803a8c <__umoddi3>:
  803a8c:	55                   	push   %ebp
  803a8d:	57                   	push   %edi
  803a8e:	56                   	push   %esi
  803a8f:	53                   	push   %ebx
  803a90:	83 ec 1c             	sub    $0x1c,%esp
  803a93:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a97:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a9f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803aa3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803aa7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803aab:	89 f3                	mov    %esi,%ebx
  803aad:	89 fa                	mov    %edi,%edx
  803aaf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ab3:	89 34 24             	mov    %esi,(%esp)
  803ab6:	85 c0                	test   %eax,%eax
  803ab8:	75 1a                	jne    803ad4 <__umoddi3+0x48>
  803aba:	39 f7                	cmp    %esi,%edi
  803abc:	0f 86 a2 00 00 00    	jbe    803b64 <__umoddi3+0xd8>
  803ac2:	89 c8                	mov    %ecx,%eax
  803ac4:	89 f2                	mov    %esi,%edx
  803ac6:	f7 f7                	div    %edi
  803ac8:	89 d0                	mov    %edx,%eax
  803aca:	31 d2                	xor    %edx,%edx
  803acc:	83 c4 1c             	add    $0x1c,%esp
  803acf:	5b                   	pop    %ebx
  803ad0:	5e                   	pop    %esi
  803ad1:	5f                   	pop    %edi
  803ad2:	5d                   	pop    %ebp
  803ad3:	c3                   	ret    
  803ad4:	39 f0                	cmp    %esi,%eax
  803ad6:	0f 87 ac 00 00 00    	ja     803b88 <__umoddi3+0xfc>
  803adc:	0f bd e8             	bsr    %eax,%ebp
  803adf:	83 f5 1f             	xor    $0x1f,%ebp
  803ae2:	0f 84 ac 00 00 00    	je     803b94 <__umoddi3+0x108>
  803ae8:	bf 20 00 00 00       	mov    $0x20,%edi
  803aed:	29 ef                	sub    %ebp,%edi
  803aef:	89 fe                	mov    %edi,%esi
  803af1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803af5:	89 e9                	mov    %ebp,%ecx
  803af7:	d3 e0                	shl    %cl,%eax
  803af9:	89 d7                	mov    %edx,%edi
  803afb:	89 f1                	mov    %esi,%ecx
  803afd:	d3 ef                	shr    %cl,%edi
  803aff:	09 c7                	or     %eax,%edi
  803b01:	89 e9                	mov    %ebp,%ecx
  803b03:	d3 e2                	shl    %cl,%edx
  803b05:	89 14 24             	mov    %edx,(%esp)
  803b08:	89 d8                	mov    %ebx,%eax
  803b0a:	d3 e0                	shl    %cl,%eax
  803b0c:	89 c2                	mov    %eax,%edx
  803b0e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b12:	d3 e0                	shl    %cl,%eax
  803b14:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b18:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b1c:	89 f1                	mov    %esi,%ecx
  803b1e:	d3 e8                	shr    %cl,%eax
  803b20:	09 d0                	or     %edx,%eax
  803b22:	d3 eb                	shr    %cl,%ebx
  803b24:	89 da                	mov    %ebx,%edx
  803b26:	f7 f7                	div    %edi
  803b28:	89 d3                	mov    %edx,%ebx
  803b2a:	f7 24 24             	mull   (%esp)
  803b2d:	89 c6                	mov    %eax,%esi
  803b2f:	89 d1                	mov    %edx,%ecx
  803b31:	39 d3                	cmp    %edx,%ebx
  803b33:	0f 82 87 00 00 00    	jb     803bc0 <__umoddi3+0x134>
  803b39:	0f 84 91 00 00 00    	je     803bd0 <__umoddi3+0x144>
  803b3f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b43:	29 f2                	sub    %esi,%edx
  803b45:	19 cb                	sbb    %ecx,%ebx
  803b47:	89 d8                	mov    %ebx,%eax
  803b49:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b4d:	d3 e0                	shl    %cl,%eax
  803b4f:	89 e9                	mov    %ebp,%ecx
  803b51:	d3 ea                	shr    %cl,%edx
  803b53:	09 d0                	or     %edx,%eax
  803b55:	89 e9                	mov    %ebp,%ecx
  803b57:	d3 eb                	shr    %cl,%ebx
  803b59:	89 da                	mov    %ebx,%edx
  803b5b:	83 c4 1c             	add    $0x1c,%esp
  803b5e:	5b                   	pop    %ebx
  803b5f:	5e                   	pop    %esi
  803b60:	5f                   	pop    %edi
  803b61:	5d                   	pop    %ebp
  803b62:	c3                   	ret    
  803b63:	90                   	nop
  803b64:	89 fd                	mov    %edi,%ebp
  803b66:	85 ff                	test   %edi,%edi
  803b68:	75 0b                	jne    803b75 <__umoddi3+0xe9>
  803b6a:	b8 01 00 00 00       	mov    $0x1,%eax
  803b6f:	31 d2                	xor    %edx,%edx
  803b71:	f7 f7                	div    %edi
  803b73:	89 c5                	mov    %eax,%ebp
  803b75:	89 f0                	mov    %esi,%eax
  803b77:	31 d2                	xor    %edx,%edx
  803b79:	f7 f5                	div    %ebp
  803b7b:	89 c8                	mov    %ecx,%eax
  803b7d:	f7 f5                	div    %ebp
  803b7f:	89 d0                	mov    %edx,%eax
  803b81:	e9 44 ff ff ff       	jmp    803aca <__umoddi3+0x3e>
  803b86:	66 90                	xchg   %ax,%ax
  803b88:	89 c8                	mov    %ecx,%eax
  803b8a:	89 f2                	mov    %esi,%edx
  803b8c:	83 c4 1c             	add    $0x1c,%esp
  803b8f:	5b                   	pop    %ebx
  803b90:	5e                   	pop    %esi
  803b91:	5f                   	pop    %edi
  803b92:	5d                   	pop    %ebp
  803b93:	c3                   	ret    
  803b94:	3b 04 24             	cmp    (%esp),%eax
  803b97:	72 06                	jb     803b9f <__umoddi3+0x113>
  803b99:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b9d:	77 0f                	ja     803bae <__umoddi3+0x122>
  803b9f:	89 f2                	mov    %esi,%edx
  803ba1:	29 f9                	sub    %edi,%ecx
  803ba3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ba7:	89 14 24             	mov    %edx,(%esp)
  803baa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bae:	8b 44 24 04          	mov    0x4(%esp),%eax
  803bb2:	8b 14 24             	mov    (%esp),%edx
  803bb5:	83 c4 1c             	add    $0x1c,%esp
  803bb8:	5b                   	pop    %ebx
  803bb9:	5e                   	pop    %esi
  803bba:	5f                   	pop    %edi
  803bbb:	5d                   	pop    %ebp
  803bbc:	c3                   	ret    
  803bbd:	8d 76 00             	lea    0x0(%esi),%esi
  803bc0:	2b 04 24             	sub    (%esp),%eax
  803bc3:	19 fa                	sbb    %edi,%edx
  803bc5:	89 d1                	mov    %edx,%ecx
  803bc7:	89 c6                	mov    %eax,%esi
  803bc9:	e9 71 ff ff ff       	jmp    803b3f <__umoddi3+0xb3>
  803bce:	66 90                	xchg   %ax,%ax
  803bd0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803bd4:	72 ea                	jb     803bc0 <__umoddi3+0x134>
  803bd6:	89 d9                	mov    %ebx,%ecx
  803bd8:	e9 62 ff ff ff       	jmp    803b3f <__umoddi3+0xb3>
