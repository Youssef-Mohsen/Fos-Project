
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
  80005b:	68 c0 3b 80 00       	push   $0x803bc0
  800060:	6a 0c                	push   $0xc
  800062:	68 dc 3b 80 00       	push   $0x803bdc
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
  800073:	e8 6a 1a 00 00       	call   801ae2 <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 f9 3b 80 00       	push   $0x803bf9
  800080:	50                   	push   %eax
  800081:	e8 23 16 00 00       	call   8016a9 <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 fc 3b 80 00       	push   $0x803bfc
  800094:	e8 8b 04 00 00       	call   800524 <cprintf>
  800099:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got x
	inctst();
  80009c:	e8 66 1b 00 00       	call   801c07 <inctst>
	cprintf("Slave B1 please be patient ...\n");
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	68 24 3c 80 00       	push   $0x803c24
  8000a9:	e8 76 04 00 00       	call   800524 <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(6000);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 70 17 00 00       	push   $0x1770
  8000b9:	e8 e4 37 00 00       	call   8038a2 <env_sleep>
  8000be:	83 c4 10             	add    $0x10,%esp
	while (gettst()!=2) ;// panic("test failed");
  8000c1:	90                   	nop
  8000c2:	e8 5a 1b 00 00       	call   801c21 <gettst>
  8000c7:	83 f8 02             	cmp    $0x2,%eax
  8000ca:	75 f6                	jne    8000c2 <_main+0x8a>

	freeFrames = sys_calculate_free_frames() ;
  8000cc:	e8 2f 18 00 00       	call   801900 <sys_calculate_free_frames>
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	sfree(x);
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000da:	e8 4f 16 00 00       	call   80172e <sfree>
  8000df:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 44 3c 80 00       	push   $0x803c44
  8000ea:	e8 35 04 00 00       	call   800524 <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
	expected = 1+1; /*1page+1table*/
  8000f2:	c7 45 e8 02 00 00 00 	movl   $0x2,-0x18(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  8000f9:	e8 02 18 00 00       	call   801900 <sys_calculate_free_frames>
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800103:	29 c2                	sub    %eax,%edx
  800105:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800108:	39 c2                	cmp    %eax,%edx
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 5c 3c 80 00       	push   $0x803c5c
  800114:	6a 26                	push   $0x26
  800116:	68 dc 3b 80 00       	push   $0x803bdc
  80011b:	e8 47 01 00 00       	call   800267 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800120:	e8 e2 1a 00 00       	call   801c07 <inctst>
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
  80012e:	e8 96 19 00 00       	call   801ac9 <sys_getenvindex>
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
  80019c:	e8 ac 16 00 00       	call   80184d <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001a1:	83 ec 0c             	sub    $0xc,%esp
  8001a4:	68 1c 3d 80 00       	push   $0x803d1c
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
  8001cc:	68 44 3d 80 00       	push   $0x803d44
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
  8001fd:	68 6c 3d 80 00       	push   $0x803d6c
  800202:	e8 1d 03 00 00       	call   800524 <cprintf>
  800207:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80020a:	a1 20 50 80 00       	mov    0x805020,%eax
  80020f:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800215:	83 ec 08             	sub    $0x8,%esp
  800218:	50                   	push   %eax
  800219:	68 c4 3d 80 00       	push   $0x803dc4
  80021e:	e8 01 03 00 00       	call   800524 <cprintf>
  800223:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800226:	83 ec 0c             	sub    $0xc,%esp
  800229:	68 1c 3d 80 00       	push   $0x803d1c
  80022e:	e8 f1 02 00 00       	call   800524 <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800236:	e8 2c 16 00 00       	call   801867 <sys_unlock_cons>
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
  80024e:	e8 42 18 00 00       	call   801a95 <sys_destroy_env>
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
  80025f:	e8 97 18 00 00       	call   801afb <sys_exit_env>
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
  800288:	68 d8 3d 80 00       	push   $0x803dd8
  80028d:	e8 92 02 00 00       	call   800524 <cprintf>
  800292:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800295:	a1 00 50 80 00       	mov    0x805000,%eax
  80029a:	ff 75 0c             	pushl  0xc(%ebp)
  80029d:	ff 75 08             	pushl  0x8(%ebp)
  8002a0:	50                   	push   %eax
  8002a1:	68 dd 3d 80 00       	push   $0x803ddd
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
  8002c5:	68 f9 3d 80 00       	push   $0x803df9
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
  8002f4:	68 fc 3d 80 00       	push   $0x803dfc
  8002f9:	6a 26                	push   $0x26
  8002fb:	68 48 3e 80 00       	push   $0x803e48
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
  8003c9:	68 54 3e 80 00       	push   $0x803e54
  8003ce:	6a 3a                	push   $0x3a
  8003d0:	68 48 3e 80 00       	push   $0x803e48
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
  80043c:	68 a8 3e 80 00       	push   $0x803ea8
  800441:	6a 44                	push   $0x44
  800443:	68 48 3e 80 00       	push   $0x803e48
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
  800496:	e8 70 13 00 00       	call   80180b <sys_cputs>
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
  80050d:	e8 f9 12 00 00       	call   80180b <sys_cputs>
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
  800557:	e8 f1 12 00 00       	call   80184d <sys_lock_cons>
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
  800577:	e8 eb 12 00 00       	call   801867 <sys_unlock_cons>
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
  8005c1:	e8 92 33 00 00       	call   803958 <__udivdi3>
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
  800611:	e8 52 34 00 00       	call   803a68 <__umoddi3>
  800616:	83 c4 10             	add    $0x10,%esp
  800619:	05 14 41 80 00       	add    $0x804114,%eax
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
  80076c:	8b 04 85 38 41 80 00 	mov    0x804138(,%eax,4),%eax
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
  80084d:	8b 34 9d 80 3f 80 00 	mov    0x803f80(,%ebx,4),%esi
  800854:	85 f6                	test   %esi,%esi
  800856:	75 19                	jne    800871 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800858:	53                   	push   %ebx
  800859:	68 25 41 80 00       	push   $0x804125
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
  800872:	68 2e 41 80 00       	push   $0x80412e
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
  80089f:	be 31 41 80 00       	mov    $0x804131,%esi
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
  8012aa:	68 a8 42 80 00       	push   $0x8042a8
  8012af:	68 3f 01 00 00       	push   $0x13f
  8012b4:	68 ca 42 80 00       	push   $0x8042ca
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
  8012ca:	e8 e7 0a 00 00       	call   801db6 <sys_sbrk>
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
  801345:	e8 f0 08 00 00       	call   801c3a <sys_isUHeapPlacementStrategyFIRSTFIT>
  80134a:	85 c0                	test   %eax,%eax
  80134c:	74 16                	je     801364 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80134e:	83 ec 0c             	sub    $0xc,%esp
  801351:	ff 75 08             	pushl  0x8(%ebp)
  801354:	e8 30 0e 00 00       	call   802189 <alloc_block_FF>
  801359:	83 c4 10             	add    $0x10,%esp
  80135c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80135f:	e9 8a 01 00 00       	jmp    8014ee <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801364:	e8 02 09 00 00       	call   801c6b <sys_isUHeapPlacementStrategyBESTFIT>
  801369:	85 c0                	test   %eax,%eax
  80136b:	0f 84 7d 01 00 00    	je     8014ee <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801371:	83 ec 0c             	sub    $0xc,%esp
  801374:	ff 75 08             	pushl  0x8(%ebp)
  801377:	e8 c9 12 00 00       	call   802645 <alloc_block_BF>
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
  8014dd:	e8 0b 09 00 00       	call   801ded <sys_allocate_user_mem>
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
  801525:	e8 df 08 00 00       	call   801e09 <get_block_size>
  80152a:	83 c4 10             	add    $0x10,%esp
  80152d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801530:	83 ec 0c             	sub    $0xc,%esp
  801533:	ff 75 08             	pushl  0x8(%ebp)
  801536:	e8 12 1b 00 00       	call   80304d <free_block>
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
  8015cd:	e8 ff 07 00 00       	call   801dd1 <sys_free_user_mem>
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
  8015db:	68 d8 42 80 00       	push   $0x8042d8
  8015e0:	68 85 00 00 00       	push   $0x85
  8015e5:	68 02 43 80 00       	push   $0x804302
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
  801650:	e8 83 03 00 00       	call   8019d8 <sys_createSharedObject>
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
  801674:	68 0e 43 80 00       	push   $0x80430e
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
  8016b8:	e8 45 03 00 00       	call   801a02 <sys_getSizeOfSharedObject>
  8016bd:	83 c4 10             	add    $0x10,%esp
  8016c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8016c3:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016c7:	75 07                	jne    8016d0 <sget+0x27>
  8016c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ce:	eb 5c                	jmp    80172c <sget+0x83>
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
  801703:	eb 27                	jmp    80172c <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801705:	83 ec 04             	sub    $0x4,%esp
  801708:	ff 75 e8             	pushl  -0x18(%ebp)
  80170b:	ff 75 0c             	pushl  0xc(%ebp)
  80170e:	ff 75 08             	pushl  0x8(%ebp)
  801711:	e8 09 03 00 00       	call   801a1f <sys_getSharedObject>
  801716:	83 c4 10             	add    $0x10,%esp
  801719:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80171c:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801720:	75 07                	jne    801729 <sget+0x80>
  801722:	b8 00 00 00 00       	mov    $0x0,%eax
  801727:	eb 03                	jmp    80172c <sget+0x83>
	return ptr;
  801729:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801734:	8b 55 08             	mov    0x8(%ebp),%edx
  801737:	a1 20 50 80 00       	mov    0x805020,%eax
  80173c:	8b 40 78             	mov    0x78(%eax),%eax
  80173f:	29 c2                	sub    %eax,%edx
  801741:	89 d0                	mov    %edx,%eax
  801743:	2d 00 10 00 00       	sub    $0x1000,%eax
  801748:	c1 e8 0c             	shr    $0xc,%eax
  80174b:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801752:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801755:	83 ec 08             	sub    $0x8,%esp
  801758:	ff 75 08             	pushl  0x8(%ebp)
  80175b:	ff 75 f4             	pushl  -0xc(%ebp)
  80175e:	e8 db 02 00 00       	call   801a3e <sys_freeSharedObject>
  801763:	83 c4 10             	add    $0x10,%esp
  801766:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801769:	90                   	nop
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801772:	83 ec 04             	sub    $0x4,%esp
  801775:	68 20 43 80 00       	push   $0x804320
  80177a:	68 dd 00 00 00       	push   $0xdd
  80177f:	68 02 43 80 00       	push   $0x804302
  801784:	e8 de ea ff ff       	call   800267 <_panic>

00801789 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
  80178c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80178f:	83 ec 04             	sub    $0x4,%esp
  801792:	68 46 43 80 00       	push   $0x804346
  801797:	68 e9 00 00 00       	push   $0xe9
  80179c:	68 02 43 80 00       	push   $0x804302
  8017a1:	e8 c1 ea ff ff       	call   800267 <_panic>

008017a6 <shrink>:

}
void shrink(uint32 newSize)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ac:	83 ec 04             	sub    $0x4,%esp
  8017af:	68 46 43 80 00       	push   $0x804346
  8017b4:	68 ee 00 00 00       	push   $0xee
  8017b9:	68 02 43 80 00       	push   $0x804302
  8017be:	e8 a4 ea ff ff       	call   800267 <_panic>

008017c3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c9:	83 ec 04             	sub    $0x4,%esp
  8017cc:	68 46 43 80 00       	push   $0x804346
  8017d1:	68 f3 00 00 00       	push   $0xf3
  8017d6:	68 02 43 80 00       	push   $0x804302
  8017db:	e8 87 ea ff ff       	call   800267 <_panic>

008017e0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	57                   	push   %edi
  8017e4:	56                   	push   %esi
  8017e5:	53                   	push   %ebx
  8017e6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017f2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017f5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017f8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017fb:	cd 30                	int    $0x30
  8017fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801800:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801803:	83 c4 10             	add    $0x10,%esp
  801806:	5b                   	pop    %ebx
  801807:	5e                   	pop    %esi
  801808:	5f                   	pop    %edi
  801809:	5d                   	pop    %ebp
  80180a:	c3                   	ret    

0080180b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	83 ec 04             	sub    $0x4,%esp
  801811:	8b 45 10             	mov    0x10(%ebp),%eax
  801814:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801817:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	52                   	push   %edx
  801823:	ff 75 0c             	pushl  0xc(%ebp)
  801826:	50                   	push   %eax
  801827:	6a 00                	push   $0x0
  801829:	e8 b2 ff ff ff       	call   8017e0 <syscall>
  80182e:	83 c4 18             	add    $0x18,%esp
}
  801831:	90                   	nop
  801832:	c9                   	leave  
  801833:	c3                   	ret    

00801834 <sys_cgetc>:

int
sys_cgetc(void)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 02                	push   $0x2
  801843:	e8 98 ff ff ff       	call   8017e0 <syscall>
  801848:	83 c4 18             	add    $0x18,%esp
}
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 03                	push   $0x3
  80185c:	e8 7f ff ff ff       	call   8017e0 <syscall>
  801861:	83 c4 18             	add    $0x18,%esp
}
  801864:	90                   	nop
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 04                	push   $0x4
  801876:	e8 65 ff ff ff       	call   8017e0 <syscall>
  80187b:	83 c4 18             	add    $0x18,%esp
}
  80187e:	90                   	nop
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801884:	8b 55 0c             	mov    0xc(%ebp),%edx
  801887:	8b 45 08             	mov    0x8(%ebp),%eax
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	52                   	push   %edx
  801891:	50                   	push   %eax
  801892:	6a 08                	push   $0x8
  801894:	e8 47 ff ff ff       	call   8017e0 <syscall>
  801899:	83 c4 18             	add    $0x18,%esp
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
  8018a1:	56                   	push   %esi
  8018a2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018a3:	8b 75 18             	mov    0x18(%ebp),%esi
  8018a6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018af:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b2:	56                   	push   %esi
  8018b3:	53                   	push   %ebx
  8018b4:	51                   	push   %ecx
  8018b5:	52                   	push   %edx
  8018b6:	50                   	push   %eax
  8018b7:	6a 09                	push   $0x9
  8018b9:	e8 22 ff ff ff       	call   8017e0 <syscall>
  8018be:	83 c4 18             	add    $0x18,%esp
}
  8018c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c4:	5b                   	pop    %ebx
  8018c5:	5e                   	pop    %esi
  8018c6:	5d                   	pop    %ebp
  8018c7:	c3                   	ret    

008018c8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	52                   	push   %edx
  8018d8:	50                   	push   %eax
  8018d9:	6a 0a                	push   $0xa
  8018db:	e8 00 ff ff ff       	call   8017e0 <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	ff 75 0c             	pushl  0xc(%ebp)
  8018f1:	ff 75 08             	pushl  0x8(%ebp)
  8018f4:	6a 0b                	push   $0xb
  8018f6:	e8 e5 fe ff ff       	call   8017e0 <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 0c                	push   $0xc
  80190f:	e8 cc fe ff ff       	call   8017e0 <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 0d                	push   $0xd
  801928:	e8 b3 fe ff ff       	call   8017e0 <syscall>
  80192d:	83 c4 18             	add    $0x18,%esp
}
  801930:	c9                   	leave  
  801931:	c3                   	ret    

00801932 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 0e                	push   $0xe
  801941:	e8 9a fe ff ff       	call   8017e0 <syscall>
  801946:	83 c4 18             	add    $0x18,%esp
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 0f                	push   $0xf
  80195a:	e8 81 fe ff ff       	call   8017e0 <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	ff 75 08             	pushl  0x8(%ebp)
  801972:	6a 10                	push   $0x10
  801974:	e8 67 fe ff ff       	call   8017e0 <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 11                	push   $0x11
  80198d:	e8 4e fe ff ff       	call   8017e0 <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
}
  801995:	90                   	nop
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_cputc>:

void
sys_cputc(const char c)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
  80199b:	83 ec 04             	sub    $0x4,%esp
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019a4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	50                   	push   %eax
  8019b1:	6a 01                	push   $0x1
  8019b3:	e8 28 fe ff ff       	call   8017e0 <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
}
  8019bb:	90                   	nop
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 14                	push   $0x14
  8019cd:	e8 0e fe ff ff       	call   8017e0 <syscall>
  8019d2:	83 c4 18             	add    $0x18,%esp
}
  8019d5:	90                   	nop
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
  8019db:	83 ec 04             	sub    $0x4,%esp
  8019de:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019e4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019e7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	6a 00                	push   $0x0
  8019f0:	51                   	push   %ecx
  8019f1:	52                   	push   %edx
  8019f2:	ff 75 0c             	pushl  0xc(%ebp)
  8019f5:	50                   	push   %eax
  8019f6:	6a 15                	push   $0x15
  8019f8:	e8 e3 fd ff ff       	call   8017e0 <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	52                   	push   %edx
  801a12:	50                   	push   %eax
  801a13:	6a 16                	push   $0x16
  801a15:	e8 c6 fd ff ff       	call   8017e0 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a22:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	51                   	push   %ecx
  801a30:	52                   	push   %edx
  801a31:	50                   	push   %eax
  801a32:	6a 17                	push   $0x17
  801a34:	e8 a7 fd ff ff       	call   8017e0 <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
}
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	52                   	push   %edx
  801a4e:	50                   	push   %eax
  801a4f:	6a 18                	push   $0x18
  801a51:	e8 8a fd ff ff       	call   8017e0 <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	6a 00                	push   $0x0
  801a63:	ff 75 14             	pushl  0x14(%ebp)
  801a66:	ff 75 10             	pushl  0x10(%ebp)
  801a69:	ff 75 0c             	pushl  0xc(%ebp)
  801a6c:	50                   	push   %eax
  801a6d:	6a 19                	push   $0x19
  801a6f:	e8 6c fd ff ff       	call   8017e0 <syscall>
  801a74:	83 c4 18             	add    $0x18,%esp
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	50                   	push   %eax
  801a88:	6a 1a                	push   $0x1a
  801a8a:	e8 51 fd ff ff       	call   8017e0 <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	90                   	nop
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a98:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	50                   	push   %eax
  801aa4:	6a 1b                	push   $0x1b
  801aa6:	e8 35 fd ff ff       	call   8017e0 <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 05                	push   $0x5
  801abf:	e8 1c fd ff ff       	call   8017e0 <syscall>
  801ac4:	83 c4 18             	add    $0x18,%esp
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 06                	push   $0x6
  801ad8:	e8 03 fd ff ff       	call   8017e0 <syscall>
  801add:	83 c4 18             	add    $0x18,%esp
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 07                	push   $0x7
  801af1:	e8 ea fc ff ff       	call   8017e0 <syscall>
  801af6:	83 c4 18             	add    $0x18,%esp
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_exit_env>:


void sys_exit_env(void)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 1c                	push   $0x1c
  801b0a:	e8 d1 fc ff ff       	call   8017e0 <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	90                   	nop
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
  801b18:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b1b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b1e:	8d 50 04             	lea    0x4(%eax),%edx
  801b21:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	52                   	push   %edx
  801b2b:	50                   	push   %eax
  801b2c:	6a 1d                	push   $0x1d
  801b2e:	e8 ad fc ff ff       	call   8017e0 <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
	return result;
  801b36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b3c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b3f:	89 01                	mov    %eax,(%ecx)
  801b41:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	c9                   	leave  
  801b48:	c2 04 00             	ret    $0x4

00801b4b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	ff 75 10             	pushl  0x10(%ebp)
  801b55:	ff 75 0c             	pushl  0xc(%ebp)
  801b58:	ff 75 08             	pushl  0x8(%ebp)
  801b5b:	6a 13                	push   $0x13
  801b5d:	e8 7e fc ff ff       	call   8017e0 <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
	return ;
  801b65:	90                   	nop
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 1e                	push   $0x1e
  801b77:	e8 64 fc ff ff       	call   8017e0 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	83 ec 04             	sub    $0x4,%esp
  801b87:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b8d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	50                   	push   %eax
  801b9a:	6a 1f                	push   $0x1f
  801b9c:	e8 3f fc ff ff       	call   8017e0 <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba4:	90                   	nop
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <rsttst>:
void rsttst()
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 21                	push   $0x21
  801bb6:	e8 25 fc ff ff       	call   8017e0 <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bbe:	90                   	nop
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	83 ec 04             	sub    $0x4,%esp
  801bc7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bcd:	8b 55 18             	mov    0x18(%ebp),%edx
  801bd0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bd4:	52                   	push   %edx
  801bd5:	50                   	push   %eax
  801bd6:	ff 75 10             	pushl  0x10(%ebp)
  801bd9:	ff 75 0c             	pushl  0xc(%ebp)
  801bdc:	ff 75 08             	pushl  0x8(%ebp)
  801bdf:	6a 20                	push   $0x20
  801be1:	e8 fa fb ff ff       	call   8017e0 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
	return ;
  801be9:	90                   	nop
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <chktst>:
void chktst(uint32 n)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	ff 75 08             	pushl  0x8(%ebp)
  801bfa:	6a 22                	push   $0x22
  801bfc:	e8 df fb ff ff       	call   8017e0 <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
	return ;
  801c04:	90                   	nop
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <inctst>:

void inctst()
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 23                	push   $0x23
  801c16:	e8 c5 fb ff ff       	call   8017e0 <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c1e:	90                   	nop
}
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <gettst>:
uint32 gettst()
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 24                	push   $0x24
  801c30:	e8 ab fb ff ff       	call   8017e0 <syscall>
  801c35:	83 c4 18             	add    $0x18,%esp
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
  801c3d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 25                	push   $0x25
  801c4c:	e8 8f fb ff ff       	call   8017e0 <syscall>
  801c51:	83 c4 18             	add    $0x18,%esp
  801c54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c57:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c5b:	75 07                	jne    801c64 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c5d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c62:	eb 05                	jmp    801c69 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 25                	push   $0x25
  801c7d:	e8 5e fb ff ff       	call   8017e0 <syscall>
  801c82:	83 c4 18             	add    $0x18,%esp
  801c85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c88:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c8c:	75 07                	jne    801c95 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c93:	eb 05                	jmp    801c9a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 25                	push   $0x25
  801cae:	e8 2d fb ff ff       	call   8017e0 <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
  801cb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cb9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cbd:	75 07                	jne    801cc6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cbf:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc4:	eb 05                	jmp    801ccb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 25                	push   $0x25
  801cdf:	e8 fc fa ff ff       	call   8017e0 <syscall>
  801ce4:	83 c4 18             	add    $0x18,%esp
  801ce7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cea:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cee:	75 07                	jne    801cf7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cf0:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf5:	eb 05                	jmp    801cfc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cf7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	ff 75 08             	pushl  0x8(%ebp)
  801d0c:	6a 26                	push   $0x26
  801d0e:	e8 cd fa ff ff       	call   8017e0 <syscall>
  801d13:	83 c4 18             	add    $0x18,%esp
	return ;
  801d16:	90                   	nop
}
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d1d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d20:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d26:	8b 45 08             	mov    0x8(%ebp),%eax
  801d29:	6a 00                	push   $0x0
  801d2b:	53                   	push   %ebx
  801d2c:	51                   	push   %ecx
  801d2d:	52                   	push   %edx
  801d2e:	50                   	push   %eax
  801d2f:	6a 27                	push   $0x27
  801d31:	e8 aa fa ff ff       	call   8017e0 <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
}
  801d39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d44:	8b 45 08             	mov    0x8(%ebp),%eax
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	52                   	push   %edx
  801d4e:	50                   	push   %eax
  801d4f:	6a 28                	push   $0x28
  801d51:	e8 8a fa ff ff       	call   8017e0 <syscall>
  801d56:	83 c4 18             	add    $0x18,%esp
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d5e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d64:	8b 45 08             	mov    0x8(%ebp),%eax
  801d67:	6a 00                	push   $0x0
  801d69:	51                   	push   %ecx
  801d6a:	ff 75 10             	pushl  0x10(%ebp)
  801d6d:	52                   	push   %edx
  801d6e:	50                   	push   %eax
  801d6f:	6a 29                	push   $0x29
  801d71:	e8 6a fa ff ff       	call   8017e0 <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	ff 75 10             	pushl  0x10(%ebp)
  801d85:	ff 75 0c             	pushl  0xc(%ebp)
  801d88:	ff 75 08             	pushl  0x8(%ebp)
  801d8b:	6a 12                	push   $0x12
  801d8d:	e8 4e fa ff ff       	call   8017e0 <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
	return ;
  801d95:	90                   	nop
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	52                   	push   %edx
  801da8:	50                   	push   %eax
  801da9:	6a 2a                	push   $0x2a
  801dab:	e8 30 fa ff ff       	call   8017e0 <syscall>
  801db0:	83 c4 18             	add    $0x18,%esp
	return;
  801db3:	90                   	nop
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	50                   	push   %eax
  801dc5:	6a 2b                	push   $0x2b
  801dc7:	e8 14 fa ff ff       	call   8017e0 <syscall>
  801dcc:	83 c4 18             	add    $0x18,%esp
}
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	ff 75 0c             	pushl  0xc(%ebp)
  801ddd:	ff 75 08             	pushl  0x8(%ebp)
  801de0:	6a 2c                	push   $0x2c
  801de2:	e8 f9 f9 ff ff       	call   8017e0 <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
	return;
  801dea:	90                   	nop
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	ff 75 0c             	pushl  0xc(%ebp)
  801df9:	ff 75 08             	pushl  0x8(%ebp)
  801dfc:	6a 2d                	push   $0x2d
  801dfe:	e8 dd f9 ff ff       	call   8017e0 <syscall>
  801e03:	83 c4 18             	add    $0x18,%esp
	return;
  801e06:	90                   	nop
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e12:	83 e8 04             	sub    $0x4,%eax
  801e15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801e18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e1b:	8b 00                	mov    (%eax),%eax
  801e1d:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e28:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2b:	83 e8 04             	sub    $0x4,%eax
  801e2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801e31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e34:	8b 00                	mov    (%eax),%eax
  801e36:	83 e0 01             	and    $0x1,%eax
  801e39:	85 c0                	test   %eax,%eax
  801e3b:	0f 94 c0             	sete   %al
}
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801e46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e50:	83 f8 02             	cmp    $0x2,%eax
  801e53:	74 2b                	je     801e80 <alloc_block+0x40>
  801e55:	83 f8 02             	cmp    $0x2,%eax
  801e58:	7f 07                	jg     801e61 <alloc_block+0x21>
  801e5a:	83 f8 01             	cmp    $0x1,%eax
  801e5d:	74 0e                	je     801e6d <alloc_block+0x2d>
  801e5f:	eb 58                	jmp    801eb9 <alloc_block+0x79>
  801e61:	83 f8 03             	cmp    $0x3,%eax
  801e64:	74 2d                	je     801e93 <alloc_block+0x53>
  801e66:	83 f8 04             	cmp    $0x4,%eax
  801e69:	74 3b                	je     801ea6 <alloc_block+0x66>
  801e6b:	eb 4c                	jmp    801eb9 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801e6d:	83 ec 0c             	sub    $0xc,%esp
  801e70:	ff 75 08             	pushl  0x8(%ebp)
  801e73:	e8 11 03 00 00       	call   802189 <alloc_block_FF>
  801e78:	83 c4 10             	add    $0x10,%esp
  801e7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e7e:	eb 4a                	jmp    801eca <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801e80:	83 ec 0c             	sub    $0xc,%esp
  801e83:	ff 75 08             	pushl  0x8(%ebp)
  801e86:	e8 fa 19 00 00       	call   803885 <alloc_block_NF>
  801e8b:	83 c4 10             	add    $0x10,%esp
  801e8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e91:	eb 37                	jmp    801eca <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801e93:	83 ec 0c             	sub    $0xc,%esp
  801e96:	ff 75 08             	pushl  0x8(%ebp)
  801e99:	e8 a7 07 00 00       	call   802645 <alloc_block_BF>
  801e9e:	83 c4 10             	add    $0x10,%esp
  801ea1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ea4:	eb 24                	jmp    801eca <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801ea6:	83 ec 0c             	sub    $0xc,%esp
  801ea9:	ff 75 08             	pushl  0x8(%ebp)
  801eac:	e8 b7 19 00 00       	call   803868 <alloc_block_WF>
  801eb1:	83 c4 10             	add    $0x10,%esp
  801eb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801eb7:	eb 11                	jmp    801eca <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801eb9:	83 ec 0c             	sub    $0xc,%esp
  801ebc:	68 58 43 80 00       	push   $0x804358
  801ec1:	e8 5e e6 ff ff       	call   800524 <cprintf>
  801ec6:	83 c4 10             	add    $0x10,%esp
		break;
  801ec9:	90                   	nop
	}
	return va;
  801eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	53                   	push   %ebx
  801ed3:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801ed6:	83 ec 0c             	sub    $0xc,%esp
  801ed9:	68 78 43 80 00       	push   $0x804378
  801ede:	e8 41 e6 ff ff       	call   800524 <cprintf>
  801ee3:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801ee6:	83 ec 0c             	sub    $0xc,%esp
  801ee9:	68 a3 43 80 00       	push   $0x8043a3
  801eee:	e8 31 e6 ff ff       	call   800524 <cprintf>
  801ef3:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801efc:	eb 37                	jmp    801f35 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801efe:	83 ec 0c             	sub    $0xc,%esp
  801f01:	ff 75 f4             	pushl  -0xc(%ebp)
  801f04:	e8 19 ff ff ff       	call   801e22 <is_free_block>
  801f09:	83 c4 10             	add    $0x10,%esp
  801f0c:	0f be d8             	movsbl %al,%ebx
  801f0f:	83 ec 0c             	sub    $0xc,%esp
  801f12:	ff 75 f4             	pushl  -0xc(%ebp)
  801f15:	e8 ef fe ff ff       	call   801e09 <get_block_size>
  801f1a:	83 c4 10             	add    $0x10,%esp
  801f1d:	83 ec 04             	sub    $0x4,%esp
  801f20:	53                   	push   %ebx
  801f21:	50                   	push   %eax
  801f22:	68 bb 43 80 00       	push   $0x8043bb
  801f27:	e8 f8 e5 ff ff       	call   800524 <cprintf>
  801f2c:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801f2f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f39:	74 07                	je     801f42 <print_blocks_list+0x73>
  801f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3e:	8b 00                	mov    (%eax),%eax
  801f40:	eb 05                	jmp    801f47 <print_blocks_list+0x78>
  801f42:	b8 00 00 00 00       	mov    $0x0,%eax
  801f47:	89 45 10             	mov    %eax,0x10(%ebp)
  801f4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f4d:	85 c0                	test   %eax,%eax
  801f4f:	75 ad                	jne    801efe <print_blocks_list+0x2f>
  801f51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f55:	75 a7                	jne    801efe <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801f57:	83 ec 0c             	sub    $0xc,%esp
  801f5a:	68 78 43 80 00       	push   $0x804378
  801f5f:	e8 c0 e5 ff ff       	call   800524 <cprintf>
  801f64:	83 c4 10             	add    $0x10,%esp

}
  801f67:	90                   	nop
  801f68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
  801f70:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f76:	83 e0 01             	and    $0x1,%eax
  801f79:	85 c0                	test   %eax,%eax
  801f7b:	74 03                	je     801f80 <initialize_dynamic_allocator+0x13>
  801f7d:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801f80:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f84:	0f 84 c7 01 00 00    	je     802151 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801f8a:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801f91:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801f94:	8b 55 08             	mov    0x8(%ebp),%edx
  801f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f9a:	01 d0                	add    %edx,%eax
  801f9c:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801fa1:	0f 87 ad 01 00 00    	ja     802154 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	85 c0                	test   %eax,%eax
  801fac:	0f 89 a5 01 00 00    	jns    802157 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801fb2:	8b 55 08             	mov    0x8(%ebp),%edx
  801fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb8:	01 d0                	add    %edx,%eax
  801fba:	83 e8 04             	sub    $0x4,%eax
  801fbd:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801fc2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801fc9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801fce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd1:	e9 87 00 00 00       	jmp    80205d <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801fd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fda:	75 14                	jne    801ff0 <initialize_dynamic_allocator+0x83>
  801fdc:	83 ec 04             	sub    $0x4,%esp
  801fdf:	68 d3 43 80 00       	push   $0x8043d3
  801fe4:	6a 79                	push   $0x79
  801fe6:	68 f1 43 80 00       	push   $0x8043f1
  801feb:	e8 77 e2 ff ff       	call   800267 <_panic>
  801ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff3:	8b 00                	mov    (%eax),%eax
  801ff5:	85 c0                	test   %eax,%eax
  801ff7:	74 10                	je     802009 <initialize_dynamic_allocator+0x9c>
  801ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffc:	8b 00                	mov    (%eax),%eax
  801ffe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802001:	8b 52 04             	mov    0x4(%edx),%edx
  802004:	89 50 04             	mov    %edx,0x4(%eax)
  802007:	eb 0b                	jmp    802014 <initialize_dynamic_allocator+0xa7>
  802009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200c:	8b 40 04             	mov    0x4(%eax),%eax
  80200f:	a3 30 50 80 00       	mov    %eax,0x805030
  802014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802017:	8b 40 04             	mov    0x4(%eax),%eax
  80201a:	85 c0                	test   %eax,%eax
  80201c:	74 0f                	je     80202d <initialize_dynamic_allocator+0xc0>
  80201e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802021:	8b 40 04             	mov    0x4(%eax),%eax
  802024:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802027:	8b 12                	mov    (%edx),%edx
  802029:	89 10                	mov    %edx,(%eax)
  80202b:	eb 0a                	jmp    802037 <initialize_dynamic_allocator+0xca>
  80202d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802030:	8b 00                	mov    (%eax),%eax
  802032:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802043:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80204a:	a1 38 50 80 00       	mov    0x805038,%eax
  80204f:	48                   	dec    %eax
  802050:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802055:	a1 34 50 80 00       	mov    0x805034,%eax
  80205a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80205d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802061:	74 07                	je     80206a <initialize_dynamic_allocator+0xfd>
  802063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802066:	8b 00                	mov    (%eax),%eax
  802068:	eb 05                	jmp    80206f <initialize_dynamic_allocator+0x102>
  80206a:	b8 00 00 00 00       	mov    $0x0,%eax
  80206f:	a3 34 50 80 00       	mov    %eax,0x805034
  802074:	a1 34 50 80 00       	mov    0x805034,%eax
  802079:	85 c0                	test   %eax,%eax
  80207b:	0f 85 55 ff ff ff    	jne    801fd6 <initialize_dynamic_allocator+0x69>
  802081:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802085:	0f 85 4b ff ff ff    	jne    801fd6 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80208b:	8b 45 08             	mov    0x8(%ebp),%eax
  80208e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802091:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802094:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80209a:	a1 44 50 80 00       	mov    0x805044,%eax
  80209f:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8020a4:	a1 40 50 80 00       	mov    0x805040,%eax
  8020a9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	83 c0 08             	add    $0x8,%eax
  8020b5:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bb:	83 c0 04             	add    $0x4,%eax
  8020be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c1:	83 ea 08             	sub    $0x8,%edx
  8020c4:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	01 d0                	add    %edx,%eax
  8020ce:	83 e8 08             	sub    $0x8,%eax
  8020d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d4:	83 ea 08             	sub    $0x8,%edx
  8020d7:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8020d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8020e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8020ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020f0:	75 17                	jne    802109 <initialize_dynamic_allocator+0x19c>
  8020f2:	83 ec 04             	sub    $0x4,%esp
  8020f5:	68 0c 44 80 00       	push   $0x80440c
  8020fa:	68 90 00 00 00       	push   $0x90
  8020ff:	68 f1 43 80 00       	push   $0x8043f1
  802104:	e8 5e e1 ff ff       	call   800267 <_panic>
  802109:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80210f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802112:	89 10                	mov    %edx,(%eax)
  802114:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802117:	8b 00                	mov    (%eax),%eax
  802119:	85 c0                	test   %eax,%eax
  80211b:	74 0d                	je     80212a <initialize_dynamic_allocator+0x1bd>
  80211d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802122:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802125:	89 50 04             	mov    %edx,0x4(%eax)
  802128:	eb 08                	jmp    802132 <initialize_dynamic_allocator+0x1c5>
  80212a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80212d:	a3 30 50 80 00       	mov    %eax,0x805030
  802132:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802135:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80213a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80213d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802144:	a1 38 50 80 00       	mov    0x805038,%eax
  802149:	40                   	inc    %eax
  80214a:	a3 38 50 80 00       	mov    %eax,0x805038
  80214f:	eb 07                	jmp    802158 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802151:	90                   	nop
  802152:	eb 04                	jmp    802158 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802154:	90                   	nop
  802155:	eb 01                	jmp    802158 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802157:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80215d:	8b 45 10             	mov    0x10(%ebp),%eax
  802160:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	8d 50 fc             	lea    -0x4(%eax),%edx
  802169:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216c:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80216e:	8b 45 08             	mov    0x8(%ebp),%eax
  802171:	83 e8 04             	sub    $0x4,%eax
  802174:	8b 00                	mov    (%eax),%eax
  802176:	83 e0 fe             	and    $0xfffffffe,%eax
  802179:	8d 50 f8             	lea    -0x8(%eax),%edx
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	01 c2                	add    %eax,%edx
  802181:	8b 45 0c             	mov    0xc(%ebp),%eax
  802184:	89 02                	mov    %eax,(%edx)
}
  802186:	90                   	nop
  802187:	5d                   	pop    %ebp
  802188:	c3                   	ret    

00802189 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
  80218c:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80218f:	8b 45 08             	mov    0x8(%ebp),%eax
  802192:	83 e0 01             	and    $0x1,%eax
  802195:	85 c0                	test   %eax,%eax
  802197:	74 03                	je     80219c <alloc_block_FF+0x13>
  802199:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80219c:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8021a0:	77 07                	ja     8021a9 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8021a2:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8021a9:	a1 24 50 80 00       	mov    0x805024,%eax
  8021ae:	85 c0                	test   %eax,%eax
  8021b0:	75 73                	jne    802225 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8021b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b5:	83 c0 10             	add    $0x10,%eax
  8021b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8021bb:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8021c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c8:	01 d0                	add    %edx,%eax
  8021ca:	48                   	dec    %eax
  8021cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8021ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8021d6:	f7 75 ec             	divl   -0x14(%ebp)
  8021d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021dc:	29 d0                	sub    %edx,%eax
  8021de:	c1 e8 0c             	shr    $0xc,%eax
  8021e1:	83 ec 0c             	sub    $0xc,%esp
  8021e4:	50                   	push   %eax
  8021e5:	e8 d4 f0 ff ff       	call   8012be <sbrk>
  8021ea:	83 c4 10             	add    $0x10,%esp
  8021ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8021f0:	83 ec 0c             	sub    $0xc,%esp
  8021f3:	6a 00                	push   $0x0
  8021f5:	e8 c4 f0 ff ff       	call   8012be <sbrk>
  8021fa:	83 c4 10             	add    $0x10,%esp
  8021fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802200:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802203:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802206:	83 ec 08             	sub    $0x8,%esp
  802209:	50                   	push   %eax
  80220a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80220d:	e8 5b fd ff ff       	call   801f6d <initialize_dynamic_allocator>
  802212:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802215:	83 ec 0c             	sub    $0xc,%esp
  802218:	68 2f 44 80 00       	push   $0x80442f
  80221d:	e8 02 e3 ff ff       	call   800524 <cprintf>
  802222:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802225:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802229:	75 0a                	jne    802235 <alloc_block_FF+0xac>
	        return NULL;
  80222b:	b8 00 00 00 00       	mov    $0x0,%eax
  802230:	e9 0e 04 00 00       	jmp    802643 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802235:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80223c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802241:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802244:	e9 f3 02 00 00       	jmp    80253c <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80224f:	83 ec 0c             	sub    $0xc,%esp
  802252:	ff 75 bc             	pushl  -0x44(%ebp)
  802255:	e8 af fb ff ff       	call   801e09 <get_block_size>
  80225a:	83 c4 10             	add    $0x10,%esp
  80225d:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	83 c0 08             	add    $0x8,%eax
  802266:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802269:	0f 87 c5 02 00 00    	ja     802534 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	83 c0 18             	add    $0x18,%eax
  802275:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802278:	0f 87 19 02 00 00    	ja     802497 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80227e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802281:	2b 45 08             	sub    0x8(%ebp),%eax
  802284:	83 e8 08             	sub    $0x8,%eax
  802287:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80228a:	8b 45 08             	mov    0x8(%ebp),%eax
  80228d:	8d 50 08             	lea    0x8(%eax),%edx
  802290:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802293:	01 d0                	add    %edx,%eax
  802295:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802298:	8b 45 08             	mov    0x8(%ebp),%eax
  80229b:	83 c0 08             	add    $0x8,%eax
  80229e:	83 ec 04             	sub    $0x4,%esp
  8022a1:	6a 01                	push   $0x1
  8022a3:	50                   	push   %eax
  8022a4:	ff 75 bc             	pushl  -0x44(%ebp)
  8022a7:	e8 ae fe ff ff       	call   80215a <set_block_data>
  8022ac:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8022af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b2:	8b 40 04             	mov    0x4(%eax),%eax
  8022b5:	85 c0                	test   %eax,%eax
  8022b7:	75 68                	jne    802321 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8022b9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022bd:	75 17                	jne    8022d6 <alloc_block_FF+0x14d>
  8022bf:	83 ec 04             	sub    $0x4,%esp
  8022c2:	68 0c 44 80 00       	push   $0x80440c
  8022c7:	68 d7 00 00 00       	push   $0xd7
  8022cc:	68 f1 43 80 00       	push   $0x8043f1
  8022d1:	e8 91 df ff ff       	call   800267 <_panic>
  8022d6:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8022dc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022df:	89 10                	mov    %edx,(%eax)
  8022e1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022e4:	8b 00                	mov    (%eax),%eax
  8022e6:	85 c0                	test   %eax,%eax
  8022e8:	74 0d                	je     8022f7 <alloc_block_FF+0x16e>
  8022ea:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022ef:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022f2:	89 50 04             	mov    %edx,0x4(%eax)
  8022f5:	eb 08                	jmp    8022ff <alloc_block_FF+0x176>
  8022f7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022fa:	a3 30 50 80 00       	mov    %eax,0x805030
  8022ff:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802302:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802307:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80230a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802311:	a1 38 50 80 00       	mov    0x805038,%eax
  802316:	40                   	inc    %eax
  802317:	a3 38 50 80 00       	mov    %eax,0x805038
  80231c:	e9 dc 00 00 00       	jmp    8023fd <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802324:	8b 00                	mov    (%eax),%eax
  802326:	85 c0                	test   %eax,%eax
  802328:	75 65                	jne    80238f <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80232a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80232e:	75 17                	jne    802347 <alloc_block_FF+0x1be>
  802330:	83 ec 04             	sub    $0x4,%esp
  802333:	68 40 44 80 00       	push   $0x804440
  802338:	68 db 00 00 00       	push   $0xdb
  80233d:	68 f1 43 80 00       	push   $0x8043f1
  802342:	e8 20 df ff ff       	call   800267 <_panic>
  802347:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80234d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802350:	89 50 04             	mov    %edx,0x4(%eax)
  802353:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802356:	8b 40 04             	mov    0x4(%eax),%eax
  802359:	85 c0                	test   %eax,%eax
  80235b:	74 0c                	je     802369 <alloc_block_FF+0x1e0>
  80235d:	a1 30 50 80 00       	mov    0x805030,%eax
  802362:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802365:	89 10                	mov    %edx,(%eax)
  802367:	eb 08                	jmp    802371 <alloc_block_FF+0x1e8>
  802369:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80236c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802371:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802374:	a3 30 50 80 00       	mov    %eax,0x805030
  802379:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80237c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802382:	a1 38 50 80 00       	mov    0x805038,%eax
  802387:	40                   	inc    %eax
  802388:	a3 38 50 80 00       	mov    %eax,0x805038
  80238d:	eb 6e                	jmp    8023fd <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80238f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802393:	74 06                	je     80239b <alloc_block_FF+0x212>
  802395:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802399:	75 17                	jne    8023b2 <alloc_block_FF+0x229>
  80239b:	83 ec 04             	sub    $0x4,%esp
  80239e:	68 64 44 80 00       	push   $0x804464
  8023a3:	68 df 00 00 00       	push   $0xdf
  8023a8:	68 f1 43 80 00       	push   $0x8043f1
  8023ad:	e8 b5 de ff ff       	call   800267 <_panic>
  8023b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b5:	8b 10                	mov    (%eax),%edx
  8023b7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ba:	89 10                	mov    %edx,(%eax)
  8023bc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023bf:	8b 00                	mov    (%eax),%eax
  8023c1:	85 c0                	test   %eax,%eax
  8023c3:	74 0b                	je     8023d0 <alloc_block_FF+0x247>
  8023c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c8:	8b 00                	mov    (%eax),%eax
  8023ca:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023cd:	89 50 04             	mov    %edx,0x4(%eax)
  8023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023d6:	89 10                	mov    %edx,(%eax)
  8023d8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023de:	89 50 04             	mov    %edx,0x4(%eax)
  8023e1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023e4:	8b 00                	mov    (%eax),%eax
  8023e6:	85 c0                	test   %eax,%eax
  8023e8:	75 08                	jne    8023f2 <alloc_block_FF+0x269>
  8023ea:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ed:	a3 30 50 80 00       	mov    %eax,0x805030
  8023f2:	a1 38 50 80 00       	mov    0x805038,%eax
  8023f7:	40                   	inc    %eax
  8023f8:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8023fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802401:	75 17                	jne    80241a <alloc_block_FF+0x291>
  802403:	83 ec 04             	sub    $0x4,%esp
  802406:	68 d3 43 80 00       	push   $0x8043d3
  80240b:	68 e1 00 00 00       	push   $0xe1
  802410:	68 f1 43 80 00       	push   $0x8043f1
  802415:	e8 4d de ff ff       	call   800267 <_panic>
  80241a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241d:	8b 00                	mov    (%eax),%eax
  80241f:	85 c0                	test   %eax,%eax
  802421:	74 10                	je     802433 <alloc_block_FF+0x2aa>
  802423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802426:	8b 00                	mov    (%eax),%eax
  802428:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242b:	8b 52 04             	mov    0x4(%edx),%edx
  80242e:	89 50 04             	mov    %edx,0x4(%eax)
  802431:	eb 0b                	jmp    80243e <alloc_block_FF+0x2b5>
  802433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802436:	8b 40 04             	mov    0x4(%eax),%eax
  802439:	a3 30 50 80 00       	mov    %eax,0x805030
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	8b 40 04             	mov    0x4(%eax),%eax
  802444:	85 c0                	test   %eax,%eax
  802446:	74 0f                	je     802457 <alloc_block_FF+0x2ce>
  802448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244b:	8b 40 04             	mov    0x4(%eax),%eax
  80244e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802451:	8b 12                	mov    (%edx),%edx
  802453:	89 10                	mov    %edx,(%eax)
  802455:	eb 0a                	jmp    802461 <alloc_block_FF+0x2d8>
  802457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245a:	8b 00                	mov    (%eax),%eax
  80245c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802464:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802474:	a1 38 50 80 00       	mov    0x805038,%eax
  802479:	48                   	dec    %eax
  80247a:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80247f:	83 ec 04             	sub    $0x4,%esp
  802482:	6a 00                	push   $0x0
  802484:	ff 75 b4             	pushl  -0x4c(%ebp)
  802487:	ff 75 b0             	pushl  -0x50(%ebp)
  80248a:	e8 cb fc ff ff       	call   80215a <set_block_data>
  80248f:	83 c4 10             	add    $0x10,%esp
  802492:	e9 95 00 00 00       	jmp    80252c <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802497:	83 ec 04             	sub    $0x4,%esp
  80249a:	6a 01                	push   $0x1
  80249c:	ff 75 b8             	pushl  -0x48(%ebp)
  80249f:	ff 75 bc             	pushl  -0x44(%ebp)
  8024a2:	e8 b3 fc ff ff       	call   80215a <set_block_data>
  8024a7:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8024aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ae:	75 17                	jne    8024c7 <alloc_block_FF+0x33e>
  8024b0:	83 ec 04             	sub    $0x4,%esp
  8024b3:	68 d3 43 80 00       	push   $0x8043d3
  8024b8:	68 e8 00 00 00       	push   $0xe8
  8024bd:	68 f1 43 80 00       	push   $0x8043f1
  8024c2:	e8 a0 dd ff ff       	call   800267 <_panic>
  8024c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ca:	8b 00                	mov    (%eax),%eax
  8024cc:	85 c0                	test   %eax,%eax
  8024ce:	74 10                	je     8024e0 <alloc_block_FF+0x357>
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	8b 00                	mov    (%eax),%eax
  8024d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d8:	8b 52 04             	mov    0x4(%edx),%edx
  8024db:	89 50 04             	mov    %edx,0x4(%eax)
  8024de:	eb 0b                	jmp    8024eb <alloc_block_FF+0x362>
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	8b 40 04             	mov    0x4(%eax),%eax
  8024e6:	a3 30 50 80 00       	mov    %eax,0x805030
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	8b 40 04             	mov    0x4(%eax),%eax
  8024f1:	85 c0                	test   %eax,%eax
  8024f3:	74 0f                	je     802504 <alloc_block_FF+0x37b>
  8024f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f8:	8b 40 04             	mov    0x4(%eax),%eax
  8024fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fe:	8b 12                	mov    (%edx),%edx
  802500:	89 10                	mov    %edx,(%eax)
  802502:	eb 0a                	jmp    80250e <alloc_block_FF+0x385>
  802504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802507:	8b 00                	mov    (%eax),%eax
  802509:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80250e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802511:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802521:	a1 38 50 80 00       	mov    0x805038,%eax
  802526:	48                   	dec    %eax
  802527:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80252c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80252f:	e9 0f 01 00 00       	jmp    802643 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802534:	a1 34 50 80 00       	mov    0x805034,%eax
  802539:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80253c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802540:	74 07                	je     802549 <alloc_block_FF+0x3c0>
  802542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802545:	8b 00                	mov    (%eax),%eax
  802547:	eb 05                	jmp    80254e <alloc_block_FF+0x3c5>
  802549:	b8 00 00 00 00       	mov    $0x0,%eax
  80254e:	a3 34 50 80 00       	mov    %eax,0x805034
  802553:	a1 34 50 80 00       	mov    0x805034,%eax
  802558:	85 c0                	test   %eax,%eax
  80255a:	0f 85 e9 fc ff ff    	jne    802249 <alloc_block_FF+0xc0>
  802560:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802564:	0f 85 df fc ff ff    	jne    802249 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80256a:	8b 45 08             	mov    0x8(%ebp),%eax
  80256d:	83 c0 08             	add    $0x8,%eax
  802570:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802573:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80257a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80257d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802580:	01 d0                	add    %edx,%eax
  802582:	48                   	dec    %eax
  802583:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802586:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802589:	ba 00 00 00 00       	mov    $0x0,%edx
  80258e:	f7 75 d8             	divl   -0x28(%ebp)
  802591:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802594:	29 d0                	sub    %edx,%eax
  802596:	c1 e8 0c             	shr    $0xc,%eax
  802599:	83 ec 0c             	sub    $0xc,%esp
  80259c:	50                   	push   %eax
  80259d:	e8 1c ed ff ff       	call   8012be <sbrk>
  8025a2:	83 c4 10             	add    $0x10,%esp
  8025a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8025a8:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8025ac:	75 0a                	jne    8025b8 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8025ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b3:	e9 8b 00 00 00       	jmp    802643 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8025b8:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8025bf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025c5:	01 d0                	add    %edx,%eax
  8025c7:	48                   	dec    %eax
  8025c8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8025cb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8025d3:	f7 75 cc             	divl   -0x34(%ebp)
  8025d6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025d9:	29 d0                	sub    %edx,%eax
  8025db:	8d 50 fc             	lea    -0x4(%eax),%edx
  8025de:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025e1:	01 d0                	add    %edx,%eax
  8025e3:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8025e8:	a1 40 50 80 00       	mov    0x805040,%eax
  8025ed:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8025f3:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8025fa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025fd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802600:	01 d0                	add    %edx,%eax
  802602:	48                   	dec    %eax
  802603:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802606:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802609:	ba 00 00 00 00       	mov    $0x0,%edx
  80260e:	f7 75 c4             	divl   -0x3c(%ebp)
  802611:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802614:	29 d0                	sub    %edx,%eax
  802616:	83 ec 04             	sub    $0x4,%esp
  802619:	6a 01                	push   $0x1
  80261b:	50                   	push   %eax
  80261c:	ff 75 d0             	pushl  -0x30(%ebp)
  80261f:	e8 36 fb ff ff       	call   80215a <set_block_data>
  802624:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802627:	83 ec 0c             	sub    $0xc,%esp
  80262a:	ff 75 d0             	pushl  -0x30(%ebp)
  80262d:	e8 1b 0a 00 00       	call   80304d <free_block>
  802632:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802635:	83 ec 0c             	sub    $0xc,%esp
  802638:	ff 75 08             	pushl  0x8(%ebp)
  80263b:	e8 49 fb ff ff       	call   802189 <alloc_block_FF>
  802640:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802643:	c9                   	leave  
  802644:	c3                   	ret    

00802645 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
  802648:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80264b:	8b 45 08             	mov    0x8(%ebp),%eax
  80264e:	83 e0 01             	and    $0x1,%eax
  802651:	85 c0                	test   %eax,%eax
  802653:	74 03                	je     802658 <alloc_block_BF+0x13>
  802655:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802658:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80265c:	77 07                	ja     802665 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80265e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802665:	a1 24 50 80 00       	mov    0x805024,%eax
  80266a:	85 c0                	test   %eax,%eax
  80266c:	75 73                	jne    8026e1 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80266e:	8b 45 08             	mov    0x8(%ebp),%eax
  802671:	83 c0 10             	add    $0x10,%eax
  802674:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802677:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80267e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802681:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802684:	01 d0                	add    %edx,%eax
  802686:	48                   	dec    %eax
  802687:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80268a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80268d:	ba 00 00 00 00       	mov    $0x0,%edx
  802692:	f7 75 e0             	divl   -0x20(%ebp)
  802695:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802698:	29 d0                	sub    %edx,%eax
  80269a:	c1 e8 0c             	shr    $0xc,%eax
  80269d:	83 ec 0c             	sub    $0xc,%esp
  8026a0:	50                   	push   %eax
  8026a1:	e8 18 ec ff ff       	call   8012be <sbrk>
  8026a6:	83 c4 10             	add    $0x10,%esp
  8026a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8026ac:	83 ec 0c             	sub    $0xc,%esp
  8026af:	6a 00                	push   $0x0
  8026b1:	e8 08 ec ff ff       	call   8012be <sbrk>
  8026b6:	83 c4 10             	add    $0x10,%esp
  8026b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8026bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026bf:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8026c2:	83 ec 08             	sub    $0x8,%esp
  8026c5:	50                   	push   %eax
  8026c6:	ff 75 d8             	pushl  -0x28(%ebp)
  8026c9:	e8 9f f8 ff ff       	call   801f6d <initialize_dynamic_allocator>
  8026ce:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8026d1:	83 ec 0c             	sub    $0xc,%esp
  8026d4:	68 2f 44 80 00       	push   $0x80442f
  8026d9:	e8 46 de ff ff       	call   800524 <cprintf>
  8026de:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8026e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8026e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8026ef:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8026f6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8026fd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802702:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802705:	e9 1d 01 00 00       	jmp    802827 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80270a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270d:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802710:	83 ec 0c             	sub    $0xc,%esp
  802713:	ff 75 a8             	pushl  -0x58(%ebp)
  802716:	e8 ee f6 ff ff       	call   801e09 <get_block_size>
  80271b:	83 c4 10             	add    $0x10,%esp
  80271e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802721:	8b 45 08             	mov    0x8(%ebp),%eax
  802724:	83 c0 08             	add    $0x8,%eax
  802727:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80272a:	0f 87 ef 00 00 00    	ja     80281f <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802730:	8b 45 08             	mov    0x8(%ebp),%eax
  802733:	83 c0 18             	add    $0x18,%eax
  802736:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802739:	77 1d                	ja     802758 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80273b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802741:	0f 86 d8 00 00 00    	jbe    80281f <alloc_block_BF+0x1da>
				{
					best_va = va;
  802747:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80274a:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80274d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802750:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802753:	e9 c7 00 00 00       	jmp    80281f <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802758:	8b 45 08             	mov    0x8(%ebp),%eax
  80275b:	83 c0 08             	add    $0x8,%eax
  80275e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802761:	0f 85 9d 00 00 00    	jne    802804 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802767:	83 ec 04             	sub    $0x4,%esp
  80276a:	6a 01                	push   $0x1
  80276c:	ff 75 a4             	pushl  -0x5c(%ebp)
  80276f:	ff 75 a8             	pushl  -0x58(%ebp)
  802772:	e8 e3 f9 ff ff       	call   80215a <set_block_data>
  802777:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80277a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277e:	75 17                	jne    802797 <alloc_block_BF+0x152>
  802780:	83 ec 04             	sub    $0x4,%esp
  802783:	68 d3 43 80 00       	push   $0x8043d3
  802788:	68 2c 01 00 00       	push   $0x12c
  80278d:	68 f1 43 80 00       	push   $0x8043f1
  802792:	e8 d0 da ff ff       	call   800267 <_panic>
  802797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279a:	8b 00                	mov    (%eax),%eax
  80279c:	85 c0                	test   %eax,%eax
  80279e:	74 10                	je     8027b0 <alloc_block_BF+0x16b>
  8027a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a3:	8b 00                	mov    (%eax),%eax
  8027a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a8:	8b 52 04             	mov    0x4(%edx),%edx
  8027ab:	89 50 04             	mov    %edx,0x4(%eax)
  8027ae:	eb 0b                	jmp    8027bb <alloc_block_BF+0x176>
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	8b 40 04             	mov    0x4(%eax),%eax
  8027b6:	a3 30 50 80 00       	mov    %eax,0x805030
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	8b 40 04             	mov    0x4(%eax),%eax
  8027c1:	85 c0                	test   %eax,%eax
  8027c3:	74 0f                	je     8027d4 <alloc_block_BF+0x18f>
  8027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c8:	8b 40 04             	mov    0x4(%eax),%eax
  8027cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ce:	8b 12                	mov    (%edx),%edx
  8027d0:	89 10                	mov    %edx,(%eax)
  8027d2:	eb 0a                	jmp    8027de <alloc_block_BF+0x199>
  8027d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d7:	8b 00                	mov    (%eax),%eax
  8027d9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f1:	a1 38 50 80 00       	mov    0x805038,%eax
  8027f6:	48                   	dec    %eax
  8027f7:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8027fc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027ff:	e9 24 04 00 00       	jmp    802c28 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802804:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802807:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80280a:	76 13                	jbe    80281f <alloc_block_BF+0x1da>
					{
						internal = 1;
  80280c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802813:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802816:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802819:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80281c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80281f:	a1 34 50 80 00       	mov    0x805034,%eax
  802824:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802827:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282b:	74 07                	je     802834 <alloc_block_BF+0x1ef>
  80282d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802830:	8b 00                	mov    (%eax),%eax
  802832:	eb 05                	jmp    802839 <alloc_block_BF+0x1f4>
  802834:	b8 00 00 00 00       	mov    $0x0,%eax
  802839:	a3 34 50 80 00       	mov    %eax,0x805034
  80283e:	a1 34 50 80 00       	mov    0x805034,%eax
  802843:	85 c0                	test   %eax,%eax
  802845:	0f 85 bf fe ff ff    	jne    80270a <alloc_block_BF+0xc5>
  80284b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284f:	0f 85 b5 fe ff ff    	jne    80270a <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802855:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802859:	0f 84 26 02 00 00    	je     802a85 <alloc_block_BF+0x440>
  80285f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802863:	0f 85 1c 02 00 00    	jne    802a85 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802869:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286c:	2b 45 08             	sub    0x8(%ebp),%eax
  80286f:	83 e8 08             	sub    $0x8,%eax
  802872:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802875:	8b 45 08             	mov    0x8(%ebp),%eax
  802878:	8d 50 08             	lea    0x8(%eax),%edx
  80287b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287e:	01 d0                	add    %edx,%eax
  802880:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802883:	8b 45 08             	mov    0x8(%ebp),%eax
  802886:	83 c0 08             	add    $0x8,%eax
  802889:	83 ec 04             	sub    $0x4,%esp
  80288c:	6a 01                	push   $0x1
  80288e:	50                   	push   %eax
  80288f:	ff 75 f0             	pushl  -0x10(%ebp)
  802892:	e8 c3 f8 ff ff       	call   80215a <set_block_data>
  802897:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80289a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289d:	8b 40 04             	mov    0x4(%eax),%eax
  8028a0:	85 c0                	test   %eax,%eax
  8028a2:	75 68                	jne    80290c <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028a4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028a8:	75 17                	jne    8028c1 <alloc_block_BF+0x27c>
  8028aa:	83 ec 04             	sub    $0x4,%esp
  8028ad:	68 0c 44 80 00       	push   $0x80440c
  8028b2:	68 45 01 00 00       	push   $0x145
  8028b7:	68 f1 43 80 00       	push   $0x8043f1
  8028bc:	e8 a6 d9 ff ff       	call   800267 <_panic>
  8028c1:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8028c7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ca:	89 10                	mov    %edx,(%eax)
  8028cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028cf:	8b 00                	mov    (%eax),%eax
  8028d1:	85 c0                	test   %eax,%eax
  8028d3:	74 0d                	je     8028e2 <alloc_block_BF+0x29d>
  8028d5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8028da:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028dd:	89 50 04             	mov    %edx,0x4(%eax)
  8028e0:	eb 08                	jmp    8028ea <alloc_block_BF+0x2a5>
  8028e2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028e5:	a3 30 50 80 00       	mov    %eax,0x805030
  8028ea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ed:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028fc:	a1 38 50 80 00       	mov    0x805038,%eax
  802901:	40                   	inc    %eax
  802902:	a3 38 50 80 00       	mov    %eax,0x805038
  802907:	e9 dc 00 00 00       	jmp    8029e8 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80290c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290f:	8b 00                	mov    (%eax),%eax
  802911:	85 c0                	test   %eax,%eax
  802913:	75 65                	jne    80297a <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802915:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802919:	75 17                	jne    802932 <alloc_block_BF+0x2ed>
  80291b:	83 ec 04             	sub    $0x4,%esp
  80291e:	68 40 44 80 00       	push   $0x804440
  802923:	68 4a 01 00 00       	push   $0x14a
  802928:	68 f1 43 80 00       	push   $0x8043f1
  80292d:	e8 35 d9 ff ff       	call   800267 <_panic>
  802932:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802938:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80293b:	89 50 04             	mov    %edx,0x4(%eax)
  80293e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802941:	8b 40 04             	mov    0x4(%eax),%eax
  802944:	85 c0                	test   %eax,%eax
  802946:	74 0c                	je     802954 <alloc_block_BF+0x30f>
  802948:	a1 30 50 80 00       	mov    0x805030,%eax
  80294d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802950:	89 10                	mov    %edx,(%eax)
  802952:	eb 08                	jmp    80295c <alloc_block_BF+0x317>
  802954:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802957:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80295c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80295f:	a3 30 50 80 00       	mov    %eax,0x805030
  802964:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802967:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80296d:	a1 38 50 80 00       	mov    0x805038,%eax
  802972:	40                   	inc    %eax
  802973:	a3 38 50 80 00       	mov    %eax,0x805038
  802978:	eb 6e                	jmp    8029e8 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80297a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80297e:	74 06                	je     802986 <alloc_block_BF+0x341>
  802980:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802984:	75 17                	jne    80299d <alloc_block_BF+0x358>
  802986:	83 ec 04             	sub    $0x4,%esp
  802989:	68 64 44 80 00       	push   $0x804464
  80298e:	68 4f 01 00 00       	push   $0x14f
  802993:	68 f1 43 80 00       	push   $0x8043f1
  802998:	e8 ca d8 ff ff       	call   800267 <_panic>
  80299d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a0:	8b 10                	mov    (%eax),%edx
  8029a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a5:	89 10                	mov    %edx,(%eax)
  8029a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029aa:	8b 00                	mov    (%eax),%eax
  8029ac:	85 c0                	test   %eax,%eax
  8029ae:	74 0b                	je     8029bb <alloc_block_BF+0x376>
  8029b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b3:	8b 00                	mov    (%eax),%eax
  8029b5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029b8:	89 50 04             	mov    %edx,0x4(%eax)
  8029bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029be:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029c1:	89 10                	mov    %edx,(%eax)
  8029c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029c9:	89 50 04             	mov    %edx,0x4(%eax)
  8029cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029cf:	8b 00                	mov    (%eax),%eax
  8029d1:	85 c0                	test   %eax,%eax
  8029d3:	75 08                	jne    8029dd <alloc_block_BF+0x398>
  8029d5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029d8:	a3 30 50 80 00       	mov    %eax,0x805030
  8029dd:	a1 38 50 80 00       	mov    0x805038,%eax
  8029e2:	40                   	inc    %eax
  8029e3:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8029e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029ec:	75 17                	jne    802a05 <alloc_block_BF+0x3c0>
  8029ee:	83 ec 04             	sub    $0x4,%esp
  8029f1:	68 d3 43 80 00       	push   $0x8043d3
  8029f6:	68 51 01 00 00       	push   $0x151
  8029fb:	68 f1 43 80 00       	push   $0x8043f1
  802a00:	e8 62 d8 ff ff       	call   800267 <_panic>
  802a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a08:	8b 00                	mov    (%eax),%eax
  802a0a:	85 c0                	test   %eax,%eax
  802a0c:	74 10                	je     802a1e <alloc_block_BF+0x3d9>
  802a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a11:	8b 00                	mov    (%eax),%eax
  802a13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a16:	8b 52 04             	mov    0x4(%edx),%edx
  802a19:	89 50 04             	mov    %edx,0x4(%eax)
  802a1c:	eb 0b                	jmp    802a29 <alloc_block_BF+0x3e4>
  802a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a21:	8b 40 04             	mov    0x4(%eax),%eax
  802a24:	a3 30 50 80 00       	mov    %eax,0x805030
  802a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2c:	8b 40 04             	mov    0x4(%eax),%eax
  802a2f:	85 c0                	test   %eax,%eax
  802a31:	74 0f                	je     802a42 <alloc_block_BF+0x3fd>
  802a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a36:	8b 40 04             	mov    0x4(%eax),%eax
  802a39:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a3c:	8b 12                	mov    (%edx),%edx
  802a3e:	89 10                	mov    %edx,(%eax)
  802a40:	eb 0a                	jmp    802a4c <alloc_block_BF+0x407>
  802a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a45:	8b 00                	mov    (%eax),%eax
  802a47:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a5f:	a1 38 50 80 00       	mov    0x805038,%eax
  802a64:	48                   	dec    %eax
  802a65:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802a6a:	83 ec 04             	sub    $0x4,%esp
  802a6d:	6a 00                	push   $0x0
  802a6f:	ff 75 d0             	pushl  -0x30(%ebp)
  802a72:	ff 75 cc             	pushl  -0x34(%ebp)
  802a75:	e8 e0 f6 ff ff       	call   80215a <set_block_data>
  802a7a:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a80:	e9 a3 01 00 00       	jmp    802c28 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802a85:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802a89:	0f 85 9d 00 00 00    	jne    802b2c <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802a8f:	83 ec 04             	sub    $0x4,%esp
  802a92:	6a 01                	push   $0x1
  802a94:	ff 75 ec             	pushl  -0x14(%ebp)
  802a97:	ff 75 f0             	pushl  -0x10(%ebp)
  802a9a:	e8 bb f6 ff ff       	call   80215a <set_block_data>
  802a9f:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802aa2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aa6:	75 17                	jne    802abf <alloc_block_BF+0x47a>
  802aa8:	83 ec 04             	sub    $0x4,%esp
  802aab:	68 d3 43 80 00       	push   $0x8043d3
  802ab0:	68 58 01 00 00       	push   $0x158
  802ab5:	68 f1 43 80 00       	push   $0x8043f1
  802aba:	e8 a8 d7 ff ff       	call   800267 <_panic>
  802abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac2:	8b 00                	mov    (%eax),%eax
  802ac4:	85 c0                	test   %eax,%eax
  802ac6:	74 10                	je     802ad8 <alloc_block_BF+0x493>
  802ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acb:	8b 00                	mov    (%eax),%eax
  802acd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ad0:	8b 52 04             	mov    0x4(%edx),%edx
  802ad3:	89 50 04             	mov    %edx,0x4(%eax)
  802ad6:	eb 0b                	jmp    802ae3 <alloc_block_BF+0x49e>
  802ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802adb:	8b 40 04             	mov    0x4(%eax),%eax
  802ade:	a3 30 50 80 00       	mov    %eax,0x805030
  802ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae6:	8b 40 04             	mov    0x4(%eax),%eax
  802ae9:	85 c0                	test   %eax,%eax
  802aeb:	74 0f                	je     802afc <alloc_block_BF+0x4b7>
  802aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af0:	8b 40 04             	mov    0x4(%eax),%eax
  802af3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802af6:	8b 12                	mov    (%edx),%edx
  802af8:	89 10                	mov    %edx,(%eax)
  802afa:	eb 0a                	jmp    802b06 <alloc_block_BF+0x4c1>
  802afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aff:	8b 00                	mov    (%eax),%eax
  802b01:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b19:	a1 38 50 80 00       	mov    0x805038,%eax
  802b1e:	48                   	dec    %eax
  802b1f:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802b24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b27:	e9 fc 00 00 00       	jmp    802c28 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2f:	83 c0 08             	add    $0x8,%eax
  802b32:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b35:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b3c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b3f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b42:	01 d0                	add    %edx,%eax
  802b44:	48                   	dec    %eax
  802b45:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b48:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b4b:	ba 00 00 00 00       	mov    $0x0,%edx
  802b50:	f7 75 c4             	divl   -0x3c(%ebp)
  802b53:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b56:	29 d0                	sub    %edx,%eax
  802b58:	c1 e8 0c             	shr    $0xc,%eax
  802b5b:	83 ec 0c             	sub    $0xc,%esp
  802b5e:	50                   	push   %eax
  802b5f:	e8 5a e7 ff ff       	call   8012be <sbrk>
  802b64:	83 c4 10             	add    $0x10,%esp
  802b67:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802b6a:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802b6e:	75 0a                	jne    802b7a <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802b70:	b8 00 00 00 00       	mov    $0x0,%eax
  802b75:	e9 ae 00 00 00       	jmp    802c28 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b7a:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802b81:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b84:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b87:	01 d0                	add    %edx,%eax
  802b89:	48                   	dec    %eax
  802b8a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802b8d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b90:	ba 00 00 00 00       	mov    $0x0,%edx
  802b95:	f7 75 b8             	divl   -0x48(%ebp)
  802b98:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b9b:	29 d0                	sub    %edx,%eax
  802b9d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ba0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ba3:	01 d0                	add    %edx,%eax
  802ba5:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802baa:	a1 40 50 80 00       	mov    0x805040,%eax
  802baf:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802bb5:	83 ec 0c             	sub    $0xc,%esp
  802bb8:	68 98 44 80 00       	push   $0x804498
  802bbd:	e8 62 d9 ff ff       	call   800524 <cprintf>
  802bc2:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802bc5:	83 ec 08             	sub    $0x8,%esp
  802bc8:	ff 75 bc             	pushl  -0x44(%ebp)
  802bcb:	68 9d 44 80 00       	push   $0x80449d
  802bd0:	e8 4f d9 ff ff       	call   800524 <cprintf>
  802bd5:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802bd8:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802bdf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802be2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802be5:	01 d0                	add    %edx,%eax
  802be7:	48                   	dec    %eax
  802be8:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802beb:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802bee:	ba 00 00 00 00       	mov    $0x0,%edx
  802bf3:	f7 75 b0             	divl   -0x50(%ebp)
  802bf6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802bf9:	29 d0                	sub    %edx,%eax
  802bfb:	83 ec 04             	sub    $0x4,%esp
  802bfe:	6a 01                	push   $0x1
  802c00:	50                   	push   %eax
  802c01:	ff 75 bc             	pushl  -0x44(%ebp)
  802c04:	e8 51 f5 ff ff       	call   80215a <set_block_data>
  802c09:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802c0c:	83 ec 0c             	sub    $0xc,%esp
  802c0f:	ff 75 bc             	pushl  -0x44(%ebp)
  802c12:	e8 36 04 00 00       	call   80304d <free_block>
  802c17:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802c1a:	83 ec 0c             	sub    $0xc,%esp
  802c1d:	ff 75 08             	pushl  0x8(%ebp)
  802c20:	e8 20 fa ff ff       	call   802645 <alloc_block_BF>
  802c25:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802c28:	c9                   	leave  
  802c29:	c3                   	ret    

00802c2a <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802c2a:	55                   	push   %ebp
  802c2b:	89 e5                	mov    %esp,%ebp
  802c2d:	53                   	push   %ebx
  802c2e:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802c31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c38:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802c3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c43:	74 1e                	je     802c63 <merging+0x39>
  802c45:	ff 75 08             	pushl  0x8(%ebp)
  802c48:	e8 bc f1 ff ff       	call   801e09 <get_block_size>
  802c4d:	83 c4 04             	add    $0x4,%esp
  802c50:	89 c2                	mov    %eax,%edx
  802c52:	8b 45 08             	mov    0x8(%ebp),%eax
  802c55:	01 d0                	add    %edx,%eax
  802c57:	3b 45 10             	cmp    0x10(%ebp),%eax
  802c5a:	75 07                	jne    802c63 <merging+0x39>
		prev_is_free = 1;
  802c5c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802c63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c67:	74 1e                	je     802c87 <merging+0x5d>
  802c69:	ff 75 10             	pushl  0x10(%ebp)
  802c6c:	e8 98 f1 ff ff       	call   801e09 <get_block_size>
  802c71:	83 c4 04             	add    $0x4,%esp
  802c74:	89 c2                	mov    %eax,%edx
  802c76:	8b 45 10             	mov    0x10(%ebp),%eax
  802c79:	01 d0                	add    %edx,%eax
  802c7b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c7e:	75 07                	jne    802c87 <merging+0x5d>
		next_is_free = 1;
  802c80:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802c87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c8b:	0f 84 cc 00 00 00    	je     802d5d <merging+0x133>
  802c91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c95:	0f 84 c2 00 00 00    	je     802d5d <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802c9b:	ff 75 08             	pushl  0x8(%ebp)
  802c9e:	e8 66 f1 ff ff       	call   801e09 <get_block_size>
  802ca3:	83 c4 04             	add    $0x4,%esp
  802ca6:	89 c3                	mov    %eax,%ebx
  802ca8:	ff 75 10             	pushl  0x10(%ebp)
  802cab:	e8 59 f1 ff ff       	call   801e09 <get_block_size>
  802cb0:	83 c4 04             	add    $0x4,%esp
  802cb3:	01 c3                	add    %eax,%ebx
  802cb5:	ff 75 0c             	pushl  0xc(%ebp)
  802cb8:	e8 4c f1 ff ff       	call   801e09 <get_block_size>
  802cbd:	83 c4 04             	add    $0x4,%esp
  802cc0:	01 d8                	add    %ebx,%eax
  802cc2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802cc5:	6a 00                	push   $0x0
  802cc7:	ff 75 ec             	pushl  -0x14(%ebp)
  802cca:	ff 75 08             	pushl  0x8(%ebp)
  802ccd:	e8 88 f4 ff ff       	call   80215a <set_block_data>
  802cd2:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802cd5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cd9:	75 17                	jne    802cf2 <merging+0xc8>
  802cdb:	83 ec 04             	sub    $0x4,%esp
  802cde:	68 d3 43 80 00       	push   $0x8043d3
  802ce3:	68 7d 01 00 00       	push   $0x17d
  802ce8:	68 f1 43 80 00       	push   $0x8043f1
  802ced:	e8 75 d5 ff ff       	call   800267 <_panic>
  802cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cf5:	8b 00                	mov    (%eax),%eax
  802cf7:	85 c0                	test   %eax,%eax
  802cf9:	74 10                	je     802d0b <merging+0xe1>
  802cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cfe:	8b 00                	mov    (%eax),%eax
  802d00:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d03:	8b 52 04             	mov    0x4(%edx),%edx
  802d06:	89 50 04             	mov    %edx,0x4(%eax)
  802d09:	eb 0b                	jmp    802d16 <merging+0xec>
  802d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d0e:	8b 40 04             	mov    0x4(%eax),%eax
  802d11:	a3 30 50 80 00       	mov    %eax,0x805030
  802d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d19:	8b 40 04             	mov    0x4(%eax),%eax
  802d1c:	85 c0                	test   %eax,%eax
  802d1e:	74 0f                	je     802d2f <merging+0x105>
  802d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d23:	8b 40 04             	mov    0x4(%eax),%eax
  802d26:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d29:	8b 12                	mov    (%edx),%edx
  802d2b:	89 10                	mov    %edx,(%eax)
  802d2d:	eb 0a                	jmp    802d39 <merging+0x10f>
  802d2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d32:	8b 00                	mov    (%eax),%eax
  802d34:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d42:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d4c:	a1 38 50 80 00       	mov    0x805038,%eax
  802d51:	48                   	dec    %eax
  802d52:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802d57:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d58:	e9 ea 02 00 00       	jmp    803047 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802d5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d61:	74 3b                	je     802d9e <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802d63:	83 ec 0c             	sub    $0xc,%esp
  802d66:	ff 75 08             	pushl  0x8(%ebp)
  802d69:	e8 9b f0 ff ff       	call   801e09 <get_block_size>
  802d6e:	83 c4 10             	add    $0x10,%esp
  802d71:	89 c3                	mov    %eax,%ebx
  802d73:	83 ec 0c             	sub    $0xc,%esp
  802d76:	ff 75 10             	pushl  0x10(%ebp)
  802d79:	e8 8b f0 ff ff       	call   801e09 <get_block_size>
  802d7e:	83 c4 10             	add    $0x10,%esp
  802d81:	01 d8                	add    %ebx,%eax
  802d83:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d86:	83 ec 04             	sub    $0x4,%esp
  802d89:	6a 00                	push   $0x0
  802d8b:	ff 75 e8             	pushl  -0x18(%ebp)
  802d8e:	ff 75 08             	pushl  0x8(%ebp)
  802d91:	e8 c4 f3 ff ff       	call   80215a <set_block_data>
  802d96:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d99:	e9 a9 02 00 00       	jmp    803047 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802d9e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802da2:	0f 84 2d 01 00 00    	je     802ed5 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802da8:	83 ec 0c             	sub    $0xc,%esp
  802dab:	ff 75 10             	pushl  0x10(%ebp)
  802dae:	e8 56 f0 ff ff       	call   801e09 <get_block_size>
  802db3:	83 c4 10             	add    $0x10,%esp
  802db6:	89 c3                	mov    %eax,%ebx
  802db8:	83 ec 0c             	sub    $0xc,%esp
  802dbb:	ff 75 0c             	pushl  0xc(%ebp)
  802dbe:	e8 46 f0 ff ff       	call   801e09 <get_block_size>
  802dc3:	83 c4 10             	add    $0x10,%esp
  802dc6:	01 d8                	add    %ebx,%eax
  802dc8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802dcb:	83 ec 04             	sub    $0x4,%esp
  802dce:	6a 00                	push   $0x0
  802dd0:	ff 75 e4             	pushl  -0x1c(%ebp)
  802dd3:	ff 75 10             	pushl  0x10(%ebp)
  802dd6:	e8 7f f3 ff ff       	call   80215a <set_block_data>
  802ddb:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802dde:	8b 45 10             	mov    0x10(%ebp),%eax
  802de1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802de4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802de8:	74 06                	je     802df0 <merging+0x1c6>
  802dea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802dee:	75 17                	jne    802e07 <merging+0x1dd>
  802df0:	83 ec 04             	sub    $0x4,%esp
  802df3:	68 ac 44 80 00       	push   $0x8044ac
  802df8:	68 8d 01 00 00       	push   $0x18d
  802dfd:	68 f1 43 80 00       	push   $0x8043f1
  802e02:	e8 60 d4 ff ff       	call   800267 <_panic>
  802e07:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e0a:	8b 50 04             	mov    0x4(%eax),%edx
  802e0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e10:	89 50 04             	mov    %edx,0x4(%eax)
  802e13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e16:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e19:	89 10                	mov    %edx,(%eax)
  802e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e1e:	8b 40 04             	mov    0x4(%eax),%eax
  802e21:	85 c0                	test   %eax,%eax
  802e23:	74 0d                	je     802e32 <merging+0x208>
  802e25:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e28:	8b 40 04             	mov    0x4(%eax),%eax
  802e2b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e2e:	89 10                	mov    %edx,(%eax)
  802e30:	eb 08                	jmp    802e3a <merging+0x210>
  802e32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e35:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e3d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e40:	89 50 04             	mov    %edx,0x4(%eax)
  802e43:	a1 38 50 80 00       	mov    0x805038,%eax
  802e48:	40                   	inc    %eax
  802e49:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802e4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e52:	75 17                	jne    802e6b <merging+0x241>
  802e54:	83 ec 04             	sub    $0x4,%esp
  802e57:	68 d3 43 80 00       	push   $0x8043d3
  802e5c:	68 8e 01 00 00       	push   $0x18e
  802e61:	68 f1 43 80 00       	push   $0x8043f1
  802e66:	e8 fc d3 ff ff       	call   800267 <_panic>
  802e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e6e:	8b 00                	mov    (%eax),%eax
  802e70:	85 c0                	test   %eax,%eax
  802e72:	74 10                	je     802e84 <merging+0x25a>
  802e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e77:	8b 00                	mov    (%eax),%eax
  802e79:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e7c:	8b 52 04             	mov    0x4(%edx),%edx
  802e7f:	89 50 04             	mov    %edx,0x4(%eax)
  802e82:	eb 0b                	jmp    802e8f <merging+0x265>
  802e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e87:	8b 40 04             	mov    0x4(%eax),%eax
  802e8a:	a3 30 50 80 00       	mov    %eax,0x805030
  802e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e92:	8b 40 04             	mov    0x4(%eax),%eax
  802e95:	85 c0                	test   %eax,%eax
  802e97:	74 0f                	je     802ea8 <merging+0x27e>
  802e99:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9c:	8b 40 04             	mov    0x4(%eax),%eax
  802e9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ea2:	8b 12                	mov    (%edx),%edx
  802ea4:	89 10                	mov    %edx,(%eax)
  802ea6:	eb 0a                	jmp    802eb2 <merging+0x288>
  802ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eab:	8b 00                	mov    (%eax),%eax
  802ead:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802eb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ebe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec5:	a1 38 50 80 00       	mov    0x805038,%eax
  802eca:	48                   	dec    %eax
  802ecb:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ed0:	e9 72 01 00 00       	jmp    803047 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802ed5:	8b 45 10             	mov    0x10(%ebp),%eax
  802ed8:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802edb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802edf:	74 79                	je     802f5a <merging+0x330>
  802ee1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ee5:	74 73                	je     802f5a <merging+0x330>
  802ee7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eeb:	74 06                	je     802ef3 <merging+0x2c9>
  802eed:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ef1:	75 17                	jne    802f0a <merging+0x2e0>
  802ef3:	83 ec 04             	sub    $0x4,%esp
  802ef6:	68 64 44 80 00       	push   $0x804464
  802efb:	68 94 01 00 00       	push   $0x194
  802f00:	68 f1 43 80 00       	push   $0x8043f1
  802f05:	e8 5d d3 ff ff       	call   800267 <_panic>
  802f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0d:	8b 10                	mov    (%eax),%edx
  802f0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f12:	89 10                	mov    %edx,(%eax)
  802f14:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f17:	8b 00                	mov    (%eax),%eax
  802f19:	85 c0                	test   %eax,%eax
  802f1b:	74 0b                	je     802f28 <merging+0x2fe>
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	8b 00                	mov    (%eax),%eax
  802f22:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f25:	89 50 04             	mov    %edx,0x4(%eax)
  802f28:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f2e:	89 10                	mov    %edx,(%eax)
  802f30:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f33:	8b 55 08             	mov    0x8(%ebp),%edx
  802f36:	89 50 04             	mov    %edx,0x4(%eax)
  802f39:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f3c:	8b 00                	mov    (%eax),%eax
  802f3e:	85 c0                	test   %eax,%eax
  802f40:	75 08                	jne    802f4a <merging+0x320>
  802f42:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f45:	a3 30 50 80 00       	mov    %eax,0x805030
  802f4a:	a1 38 50 80 00       	mov    0x805038,%eax
  802f4f:	40                   	inc    %eax
  802f50:	a3 38 50 80 00       	mov    %eax,0x805038
  802f55:	e9 ce 00 00 00       	jmp    803028 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802f5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f5e:	74 65                	je     802fc5 <merging+0x39b>
  802f60:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f64:	75 17                	jne    802f7d <merging+0x353>
  802f66:	83 ec 04             	sub    $0x4,%esp
  802f69:	68 40 44 80 00       	push   $0x804440
  802f6e:	68 95 01 00 00       	push   $0x195
  802f73:	68 f1 43 80 00       	push   $0x8043f1
  802f78:	e8 ea d2 ff ff       	call   800267 <_panic>
  802f7d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f83:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f86:	89 50 04             	mov    %edx,0x4(%eax)
  802f89:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f8c:	8b 40 04             	mov    0x4(%eax),%eax
  802f8f:	85 c0                	test   %eax,%eax
  802f91:	74 0c                	je     802f9f <merging+0x375>
  802f93:	a1 30 50 80 00       	mov    0x805030,%eax
  802f98:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f9b:	89 10                	mov    %edx,(%eax)
  802f9d:	eb 08                	jmp    802fa7 <merging+0x37d>
  802f9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fa7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802faa:	a3 30 50 80 00       	mov    %eax,0x805030
  802faf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fb2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb8:	a1 38 50 80 00       	mov    0x805038,%eax
  802fbd:	40                   	inc    %eax
  802fbe:	a3 38 50 80 00       	mov    %eax,0x805038
  802fc3:	eb 63                	jmp    803028 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802fc5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fc9:	75 17                	jne    802fe2 <merging+0x3b8>
  802fcb:	83 ec 04             	sub    $0x4,%esp
  802fce:	68 0c 44 80 00       	push   $0x80440c
  802fd3:	68 98 01 00 00       	push   $0x198
  802fd8:	68 f1 43 80 00       	push   $0x8043f1
  802fdd:	e8 85 d2 ff ff       	call   800267 <_panic>
  802fe2:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802fe8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802feb:	89 10                	mov    %edx,(%eax)
  802fed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ff0:	8b 00                	mov    (%eax),%eax
  802ff2:	85 c0                	test   %eax,%eax
  802ff4:	74 0d                	je     803003 <merging+0x3d9>
  802ff6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ffb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ffe:	89 50 04             	mov    %edx,0x4(%eax)
  803001:	eb 08                	jmp    80300b <merging+0x3e1>
  803003:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803006:	a3 30 50 80 00       	mov    %eax,0x805030
  80300b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80300e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803013:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803016:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80301d:	a1 38 50 80 00       	mov    0x805038,%eax
  803022:	40                   	inc    %eax
  803023:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803028:	83 ec 0c             	sub    $0xc,%esp
  80302b:	ff 75 10             	pushl  0x10(%ebp)
  80302e:	e8 d6 ed ff ff       	call   801e09 <get_block_size>
  803033:	83 c4 10             	add    $0x10,%esp
  803036:	83 ec 04             	sub    $0x4,%esp
  803039:	6a 00                	push   $0x0
  80303b:	50                   	push   %eax
  80303c:	ff 75 10             	pushl  0x10(%ebp)
  80303f:	e8 16 f1 ff ff       	call   80215a <set_block_data>
  803044:	83 c4 10             	add    $0x10,%esp
	}
}
  803047:	90                   	nop
  803048:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80304b:	c9                   	leave  
  80304c:	c3                   	ret    

0080304d <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80304d:	55                   	push   %ebp
  80304e:	89 e5                	mov    %esp,%ebp
  803050:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803053:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803058:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80305b:	a1 30 50 80 00       	mov    0x805030,%eax
  803060:	3b 45 08             	cmp    0x8(%ebp),%eax
  803063:	73 1b                	jae    803080 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803065:	a1 30 50 80 00       	mov    0x805030,%eax
  80306a:	83 ec 04             	sub    $0x4,%esp
  80306d:	ff 75 08             	pushl  0x8(%ebp)
  803070:	6a 00                	push   $0x0
  803072:	50                   	push   %eax
  803073:	e8 b2 fb ff ff       	call   802c2a <merging>
  803078:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80307b:	e9 8b 00 00 00       	jmp    80310b <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803080:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803085:	3b 45 08             	cmp    0x8(%ebp),%eax
  803088:	76 18                	jbe    8030a2 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80308a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80308f:	83 ec 04             	sub    $0x4,%esp
  803092:	ff 75 08             	pushl  0x8(%ebp)
  803095:	50                   	push   %eax
  803096:	6a 00                	push   $0x0
  803098:	e8 8d fb ff ff       	call   802c2a <merging>
  80309d:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030a0:	eb 69                	jmp    80310b <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030a2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030aa:	eb 39                	jmp    8030e5 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8030ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030b2:	73 29                	jae    8030dd <free_block+0x90>
  8030b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b7:	8b 00                	mov    (%eax),%eax
  8030b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030bc:	76 1f                	jbe    8030dd <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8030be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c1:	8b 00                	mov    (%eax),%eax
  8030c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8030c6:	83 ec 04             	sub    $0x4,%esp
  8030c9:	ff 75 08             	pushl  0x8(%ebp)
  8030cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8030cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8030d2:	e8 53 fb ff ff       	call   802c2a <merging>
  8030d7:	83 c4 10             	add    $0x10,%esp
			break;
  8030da:	90                   	nop
		}
	}
}
  8030db:	eb 2e                	jmp    80310b <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030dd:	a1 34 50 80 00       	mov    0x805034,%eax
  8030e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030e9:	74 07                	je     8030f2 <free_block+0xa5>
  8030eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ee:	8b 00                	mov    (%eax),%eax
  8030f0:	eb 05                	jmp    8030f7 <free_block+0xaa>
  8030f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f7:	a3 34 50 80 00       	mov    %eax,0x805034
  8030fc:	a1 34 50 80 00       	mov    0x805034,%eax
  803101:	85 c0                	test   %eax,%eax
  803103:	75 a7                	jne    8030ac <free_block+0x5f>
  803105:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803109:	75 a1                	jne    8030ac <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80310b:	90                   	nop
  80310c:	c9                   	leave  
  80310d:	c3                   	ret    

0080310e <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80310e:	55                   	push   %ebp
  80310f:	89 e5                	mov    %esp,%ebp
  803111:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803114:	ff 75 08             	pushl  0x8(%ebp)
  803117:	e8 ed ec ff ff       	call   801e09 <get_block_size>
  80311c:	83 c4 04             	add    $0x4,%esp
  80311f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803122:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803129:	eb 17                	jmp    803142 <copy_data+0x34>
  80312b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80312e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803131:	01 c2                	add    %eax,%edx
  803133:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803136:	8b 45 08             	mov    0x8(%ebp),%eax
  803139:	01 c8                	add    %ecx,%eax
  80313b:	8a 00                	mov    (%eax),%al
  80313d:	88 02                	mov    %al,(%edx)
  80313f:	ff 45 fc             	incl   -0x4(%ebp)
  803142:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803145:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803148:	72 e1                	jb     80312b <copy_data+0x1d>
}
  80314a:	90                   	nop
  80314b:	c9                   	leave  
  80314c:	c3                   	ret    

0080314d <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80314d:	55                   	push   %ebp
  80314e:	89 e5                	mov    %esp,%ebp
  803150:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803153:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803157:	75 23                	jne    80317c <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803159:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80315d:	74 13                	je     803172 <realloc_block_FF+0x25>
  80315f:	83 ec 0c             	sub    $0xc,%esp
  803162:	ff 75 0c             	pushl  0xc(%ebp)
  803165:	e8 1f f0 ff ff       	call   802189 <alloc_block_FF>
  80316a:	83 c4 10             	add    $0x10,%esp
  80316d:	e9 f4 06 00 00       	jmp    803866 <realloc_block_FF+0x719>
		return NULL;
  803172:	b8 00 00 00 00       	mov    $0x0,%eax
  803177:	e9 ea 06 00 00       	jmp    803866 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80317c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803180:	75 18                	jne    80319a <realloc_block_FF+0x4d>
	{
		free_block(va);
  803182:	83 ec 0c             	sub    $0xc,%esp
  803185:	ff 75 08             	pushl  0x8(%ebp)
  803188:	e8 c0 fe ff ff       	call   80304d <free_block>
  80318d:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803190:	b8 00 00 00 00       	mov    $0x0,%eax
  803195:	e9 cc 06 00 00       	jmp    803866 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80319a:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80319e:	77 07                	ja     8031a7 <realloc_block_FF+0x5a>
  8031a0:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8031a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031aa:	83 e0 01             	and    $0x1,%eax
  8031ad:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8031b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031b3:	83 c0 08             	add    $0x8,%eax
  8031b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8031b9:	83 ec 0c             	sub    $0xc,%esp
  8031bc:	ff 75 08             	pushl  0x8(%ebp)
  8031bf:	e8 45 ec ff ff       	call   801e09 <get_block_size>
  8031c4:	83 c4 10             	add    $0x10,%esp
  8031c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031cd:	83 e8 08             	sub    $0x8,%eax
  8031d0:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8031d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d6:	83 e8 04             	sub    $0x4,%eax
  8031d9:	8b 00                	mov    (%eax),%eax
  8031db:	83 e0 fe             	and    $0xfffffffe,%eax
  8031de:	89 c2                	mov    %eax,%edx
  8031e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e3:	01 d0                	add    %edx,%eax
  8031e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8031e8:	83 ec 0c             	sub    $0xc,%esp
  8031eb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031ee:	e8 16 ec ff ff       	call   801e09 <get_block_size>
  8031f3:	83 c4 10             	add    $0x10,%esp
  8031f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031fc:	83 e8 08             	sub    $0x8,%eax
  8031ff:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803202:	8b 45 0c             	mov    0xc(%ebp),%eax
  803205:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803208:	75 08                	jne    803212 <realloc_block_FF+0xc5>
	{
		 return va;
  80320a:	8b 45 08             	mov    0x8(%ebp),%eax
  80320d:	e9 54 06 00 00       	jmp    803866 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803212:	8b 45 0c             	mov    0xc(%ebp),%eax
  803215:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803218:	0f 83 e5 03 00 00    	jae    803603 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80321e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803221:	2b 45 0c             	sub    0xc(%ebp),%eax
  803224:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803227:	83 ec 0c             	sub    $0xc,%esp
  80322a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80322d:	e8 f0 eb ff ff       	call   801e22 <is_free_block>
  803232:	83 c4 10             	add    $0x10,%esp
  803235:	84 c0                	test   %al,%al
  803237:	0f 84 3b 01 00 00    	je     803378 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80323d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803240:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803243:	01 d0                	add    %edx,%eax
  803245:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803248:	83 ec 04             	sub    $0x4,%esp
  80324b:	6a 01                	push   $0x1
  80324d:	ff 75 f0             	pushl  -0x10(%ebp)
  803250:	ff 75 08             	pushl  0x8(%ebp)
  803253:	e8 02 ef ff ff       	call   80215a <set_block_data>
  803258:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80325b:	8b 45 08             	mov    0x8(%ebp),%eax
  80325e:	83 e8 04             	sub    $0x4,%eax
  803261:	8b 00                	mov    (%eax),%eax
  803263:	83 e0 fe             	and    $0xfffffffe,%eax
  803266:	89 c2                	mov    %eax,%edx
  803268:	8b 45 08             	mov    0x8(%ebp),%eax
  80326b:	01 d0                	add    %edx,%eax
  80326d:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803270:	83 ec 04             	sub    $0x4,%esp
  803273:	6a 00                	push   $0x0
  803275:	ff 75 cc             	pushl  -0x34(%ebp)
  803278:	ff 75 c8             	pushl  -0x38(%ebp)
  80327b:	e8 da ee ff ff       	call   80215a <set_block_data>
  803280:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803283:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803287:	74 06                	je     80328f <realloc_block_FF+0x142>
  803289:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80328d:	75 17                	jne    8032a6 <realloc_block_FF+0x159>
  80328f:	83 ec 04             	sub    $0x4,%esp
  803292:	68 64 44 80 00       	push   $0x804464
  803297:	68 f6 01 00 00       	push   $0x1f6
  80329c:	68 f1 43 80 00       	push   $0x8043f1
  8032a1:	e8 c1 cf ff ff       	call   800267 <_panic>
  8032a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a9:	8b 10                	mov    (%eax),%edx
  8032ab:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032ae:	89 10                	mov    %edx,(%eax)
  8032b0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032b3:	8b 00                	mov    (%eax),%eax
  8032b5:	85 c0                	test   %eax,%eax
  8032b7:	74 0b                	je     8032c4 <realloc_block_FF+0x177>
  8032b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032bc:	8b 00                	mov    (%eax),%eax
  8032be:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032c1:	89 50 04             	mov    %edx,0x4(%eax)
  8032c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032c7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032ca:	89 10                	mov    %edx,(%eax)
  8032cc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032d2:	89 50 04             	mov    %edx,0x4(%eax)
  8032d5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032d8:	8b 00                	mov    (%eax),%eax
  8032da:	85 c0                	test   %eax,%eax
  8032dc:	75 08                	jne    8032e6 <realloc_block_FF+0x199>
  8032de:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032e1:	a3 30 50 80 00       	mov    %eax,0x805030
  8032e6:	a1 38 50 80 00       	mov    0x805038,%eax
  8032eb:	40                   	inc    %eax
  8032ec:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8032f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032f5:	75 17                	jne    80330e <realloc_block_FF+0x1c1>
  8032f7:	83 ec 04             	sub    $0x4,%esp
  8032fa:	68 d3 43 80 00       	push   $0x8043d3
  8032ff:	68 f7 01 00 00       	push   $0x1f7
  803304:	68 f1 43 80 00       	push   $0x8043f1
  803309:	e8 59 cf ff ff       	call   800267 <_panic>
  80330e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803311:	8b 00                	mov    (%eax),%eax
  803313:	85 c0                	test   %eax,%eax
  803315:	74 10                	je     803327 <realloc_block_FF+0x1da>
  803317:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80331a:	8b 00                	mov    (%eax),%eax
  80331c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80331f:	8b 52 04             	mov    0x4(%edx),%edx
  803322:	89 50 04             	mov    %edx,0x4(%eax)
  803325:	eb 0b                	jmp    803332 <realloc_block_FF+0x1e5>
  803327:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80332a:	8b 40 04             	mov    0x4(%eax),%eax
  80332d:	a3 30 50 80 00       	mov    %eax,0x805030
  803332:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803335:	8b 40 04             	mov    0x4(%eax),%eax
  803338:	85 c0                	test   %eax,%eax
  80333a:	74 0f                	je     80334b <realloc_block_FF+0x1fe>
  80333c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80333f:	8b 40 04             	mov    0x4(%eax),%eax
  803342:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803345:	8b 12                	mov    (%edx),%edx
  803347:	89 10                	mov    %edx,(%eax)
  803349:	eb 0a                	jmp    803355 <realloc_block_FF+0x208>
  80334b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80334e:	8b 00                	mov    (%eax),%eax
  803350:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803355:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803358:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80335e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803361:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803368:	a1 38 50 80 00       	mov    0x805038,%eax
  80336d:	48                   	dec    %eax
  80336e:	a3 38 50 80 00       	mov    %eax,0x805038
  803373:	e9 83 02 00 00       	jmp    8035fb <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803378:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80337c:	0f 86 69 02 00 00    	jbe    8035eb <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803382:	83 ec 04             	sub    $0x4,%esp
  803385:	6a 01                	push   $0x1
  803387:	ff 75 f0             	pushl  -0x10(%ebp)
  80338a:	ff 75 08             	pushl  0x8(%ebp)
  80338d:	e8 c8 ed ff ff       	call   80215a <set_block_data>
  803392:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803395:	8b 45 08             	mov    0x8(%ebp),%eax
  803398:	83 e8 04             	sub    $0x4,%eax
  80339b:	8b 00                	mov    (%eax),%eax
  80339d:	83 e0 fe             	and    $0xfffffffe,%eax
  8033a0:	89 c2                	mov    %eax,%edx
  8033a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a5:	01 d0                	add    %edx,%eax
  8033a7:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8033aa:	a1 38 50 80 00       	mov    0x805038,%eax
  8033af:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8033b2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8033b6:	75 68                	jne    803420 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8033b8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033bc:	75 17                	jne    8033d5 <realloc_block_FF+0x288>
  8033be:	83 ec 04             	sub    $0x4,%esp
  8033c1:	68 0c 44 80 00       	push   $0x80440c
  8033c6:	68 06 02 00 00       	push   $0x206
  8033cb:	68 f1 43 80 00       	push   $0x8043f1
  8033d0:	e8 92 ce ff ff       	call   800267 <_panic>
  8033d5:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8033db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033de:	89 10                	mov    %edx,(%eax)
  8033e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e3:	8b 00                	mov    (%eax),%eax
  8033e5:	85 c0                	test   %eax,%eax
  8033e7:	74 0d                	je     8033f6 <realloc_block_FF+0x2a9>
  8033e9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033f1:	89 50 04             	mov    %edx,0x4(%eax)
  8033f4:	eb 08                	jmp    8033fe <realloc_block_FF+0x2b1>
  8033f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033f9:	a3 30 50 80 00       	mov    %eax,0x805030
  8033fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803401:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803406:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803409:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803410:	a1 38 50 80 00       	mov    0x805038,%eax
  803415:	40                   	inc    %eax
  803416:	a3 38 50 80 00       	mov    %eax,0x805038
  80341b:	e9 b0 01 00 00       	jmp    8035d0 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803420:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803425:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803428:	76 68                	jbe    803492 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80342a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80342e:	75 17                	jne    803447 <realloc_block_FF+0x2fa>
  803430:	83 ec 04             	sub    $0x4,%esp
  803433:	68 0c 44 80 00       	push   $0x80440c
  803438:	68 0b 02 00 00       	push   $0x20b
  80343d:	68 f1 43 80 00       	push   $0x8043f1
  803442:	e8 20 ce ff ff       	call   800267 <_panic>
  803447:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80344d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803450:	89 10                	mov    %edx,(%eax)
  803452:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803455:	8b 00                	mov    (%eax),%eax
  803457:	85 c0                	test   %eax,%eax
  803459:	74 0d                	je     803468 <realloc_block_FF+0x31b>
  80345b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803460:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803463:	89 50 04             	mov    %edx,0x4(%eax)
  803466:	eb 08                	jmp    803470 <realloc_block_FF+0x323>
  803468:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80346b:	a3 30 50 80 00       	mov    %eax,0x805030
  803470:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803473:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803478:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80347b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803482:	a1 38 50 80 00       	mov    0x805038,%eax
  803487:	40                   	inc    %eax
  803488:	a3 38 50 80 00       	mov    %eax,0x805038
  80348d:	e9 3e 01 00 00       	jmp    8035d0 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803492:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803497:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80349a:	73 68                	jae    803504 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80349c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034a0:	75 17                	jne    8034b9 <realloc_block_FF+0x36c>
  8034a2:	83 ec 04             	sub    $0x4,%esp
  8034a5:	68 40 44 80 00       	push   $0x804440
  8034aa:	68 10 02 00 00       	push   $0x210
  8034af:	68 f1 43 80 00       	push   $0x8043f1
  8034b4:	e8 ae cd ff ff       	call   800267 <_panic>
  8034b9:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8034bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c2:	89 50 04             	mov    %edx,0x4(%eax)
  8034c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c8:	8b 40 04             	mov    0x4(%eax),%eax
  8034cb:	85 c0                	test   %eax,%eax
  8034cd:	74 0c                	je     8034db <realloc_block_FF+0x38e>
  8034cf:	a1 30 50 80 00       	mov    0x805030,%eax
  8034d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034d7:	89 10                	mov    %edx,(%eax)
  8034d9:	eb 08                	jmp    8034e3 <realloc_block_FF+0x396>
  8034db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034de:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e6:	a3 30 50 80 00       	mov    %eax,0x805030
  8034eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034f4:	a1 38 50 80 00       	mov    0x805038,%eax
  8034f9:	40                   	inc    %eax
  8034fa:	a3 38 50 80 00       	mov    %eax,0x805038
  8034ff:	e9 cc 00 00 00       	jmp    8035d0 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803504:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80350b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803510:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803513:	e9 8a 00 00 00       	jmp    8035a2 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80351e:	73 7a                	jae    80359a <realloc_block_FF+0x44d>
  803520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803523:	8b 00                	mov    (%eax),%eax
  803525:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803528:	73 70                	jae    80359a <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80352a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80352e:	74 06                	je     803536 <realloc_block_FF+0x3e9>
  803530:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803534:	75 17                	jne    80354d <realloc_block_FF+0x400>
  803536:	83 ec 04             	sub    $0x4,%esp
  803539:	68 64 44 80 00       	push   $0x804464
  80353e:	68 1a 02 00 00       	push   $0x21a
  803543:	68 f1 43 80 00       	push   $0x8043f1
  803548:	e8 1a cd ff ff       	call   800267 <_panic>
  80354d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803550:	8b 10                	mov    (%eax),%edx
  803552:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803555:	89 10                	mov    %edx,(%eax)
  803557:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80355a:	8b 00                	mov    (%eax),%eax
  80355c:	85 c0                	test   %eax,%eax
  80355e:	74 0b                	je     80356b <realloc_block_FF+0x41e>
  803560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803563:	8b 00                	mov    (%eax),%eax
  803565:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803568:	89 50 04             	mov    %edx,0x4(%eax)
  80356b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803571:	89 10                	mov    %edx,(%eax)
  803573:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803576:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803579:	89 50 04             	mov    %edx,0x4(%eax)
  80357c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80357f:	8b 00                	mov    (%eax),%eax
  803581:	85 c0                	test   %eax,%eax
  803583:	75 08                	jne    80358d <realloc_block_FF+0x440>
  803585:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803588:	a3 30 50 80 00       	mov    %eax,0x805030
  80358d:	a1 38 50 80 00       	mov    0x805038,%eax
  803592:	40                   	inc    %eax
  803593:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803598:	eb 36                	jmp    8035d0 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80359a:	a1 34 50 80 00       	mov    0x805034,%eax
  80359f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035a6:	74 07                	je     8035af <realloc_block_FF+0x462>
  8035a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ab:	8b 00                	mov    (%eax),%eax
  8035ad:	eb 05                	jmp    8035b4 <realloc_block_FF+0x467>
  8035af:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b4:	a3 34 50 80 00       	mov    %eax,0x805034
  8035b9:	a1 34 50 80 00       	mov    0x805034,%eax
  8035be:	85 c0                	test   %eax,%eax
  8035c0:	0f 85 52 ff ff ff    	jne    803518 <realloc_block_FF+0x3cb>
  8035c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035ca:	0f 85 48 ff ff ff    	jne    803518 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8035d0:	83 ec 04             	sub    $0x4,%esp
  8035d3:	6a 00                	push   $0x0
  8035d5:	ff 75 d8             	pushl  -0x28(%ebp)
  8035d8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8035db:	e8 7a eb ff ff       	call   80215a <set_block_data>
  8035e0:	83 c4 10             	add    $0x10,%esp
				return va;
  8035e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e6:	e9 7b 02 00 00       	jmp    803866 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8035eb:	83 ec 0c             	sub    $0xc,%esp
  8035ee:	68 e1 44 80 00       	push   $0x8044e1
  8035f3:	e8 2c cf ff ff       	call   800524 <cprintf>
  8035f8:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8035fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fe:	e9 63 02 00 00       	jmp    803866 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803603:	8b 45 0c             	mov    0xc(%ebp),%eax
  803606:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803609:	0f 86 4d 02 00 00    	jbe    80385c <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80360f:	83 ec 0c             	sub    $0xc,%esp
  803612:	ff 75 e4             	pushl  -0x1c(%ebp)
  803615:	e8 08 e8 ff ff       	call   801e22 <is_free_block>
  80361a:	83 c4 10             	add    $0x10,%esp
  80361d:	84 c0                	test   %al,%al
  80361f:	0f 84 37 02 00 00    	je     80385c <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803625:	8b 45 0c             	mov    0xc(%ebp),%eax
  803628:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80362b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80362e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803631:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803634:	76 38                	jbe    80366e <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803636:	83 ec 0c             	sub    $0xc,%esp
  803639:	ff 75 08             	pushl  0x8(%ebp)
  80363c:	e8 0c fa ff ff       	call   80304d <free_block>
  803641:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803644:	83 ec 0c             	sub    $0xc,%esp
  803647:	ff 75 0c             	pushl  0xc(%ebp)
  80364a:	e8 3a eb ff ff       	call   802189 <alloc_block_FF>
  80364f:	83 c4 10             	add    $0x10,%esp
  803652:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803655:	83 ec 08             	sub    $0x8,%esp
  803658:	ff 75 c0             	pushl  -0x40(%ebp)
  80365b:	ff 75 08             	pushl  0x8(%ebp)
  80365e:	e8 ab fa ff ff       	call   80310e <copy_data>
  803663:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803666:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803669:	e9 f8 01 00 00       	jmp    803866 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80366e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803671:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803674:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803677:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80367b:	0f 87 a0 00 00 00    	ja     803721 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803681:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803685:	75 17                	jne    80369e <realloc_block_FF+0x551>
  803687:	83 ec 04             	sub    $0x4,%esp
  80368a:	68 d3 43 80 00       	push   $0x8043d3
  80368f:	68 38 02 00 00       	push   $0x238
  803694:	68 f1 43 80 00       	push   $0x8043f1
  803699:	e8 c9 cb ff ff       	call   800267 <_panic>
  80369e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a1:	8b 00                	mov    (%eax),%eax
  8036a3:	85 c0                	test   %eax,%eax
  8036a5:	74 10                	je     8036b7 <realloc_block_FF+0x56a>
  8036a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036aa:	8b 00                	mov    (%eax),%eax
  8036ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036af:	8b 52 04             	mov    0x4(%edx),%edx
  8036b2:	89 50 04             	mov    %edx,0x4(%eax)
  8036b5:	eb 0b                	jmp    8036c2 <realloc_block_FF+0x575>
  8036b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ba:	8b 40 04             	mov    0x4(%eax),%eax
  8036bd:	a3 30 50 80 00       	mov    %eax,0x805030
  8036c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c5:	8b 40 04             	mov    0x4(%eax),%eax
  8036c8:	85 c0                	test   %eax,%eax
  8036ca:	74 0f                	je     8036db <realloc_block_FF+0x58e>
  8036cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036cf:	8b 40 04             	mov    0x4(%eax),%eax
  8036d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036d5:	8b 12                	mov    (%edx),%edx
  8036d7:	89 10                	mov    %edx,(%eax)
  8036d9:	eb 0a                	jmp    8036e5 <realloc_block_FF+0x598>
  8036db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036de:	8b 00                	mov    (%eax),%eax
  8036e0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036f8:	a1 38 50 80 00       	mov    0x805038,%eax
  8036fd:	48                   	dec    %eax
  8036fe:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803703:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803706:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803709:	01 d0                	add    %edx,%eax
  80370b:	83 ec 04             	sub    $0x4,%esp
  80370e:	6a 01                	push   $0x1
  803710:	50                   	push   %eax
  803711:	ff 75 08             	pushl  0x8(%ebp)
  803714:	e8 41 ea ff ff       	call   80215a <set_block_data>
  803719:	83 c4 10             	add    $0x10,%esp
  80371c:	e9 36 01 00 00       	jmp    803857 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803721:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803724:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803727:	01 d0                	add    %edx,%eax
  803729:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80372c:	83 ec 04             	sub    $0x4,%esp
  80372f:	6a 01                	push   $0x1
  803731:	ff 75 f0             	pushl  -0x10(%ebp)
  803734:	ff 75 08             	pushl  0x8(%ebp)
  803737:	e8 1e ea ff ff       	call   80215a <set_block_data>
  80373c:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80373f:	8b 45 08             	mov    0x8(%ebp),%eax
  803742:	83 e8 04             	sub    $0x4,%eax
  803745:	8b 00                	mov    (%eax),%eax
  803747:	83 e0 fe             	and    $0xfffffffe,%eax
  80374a:	89 c2                	mov    %eax,%edx
  80374c:	8b 45 08             	mov    0x8(%ebp),%eax
  80374f:	01 d0                	add    %edx,%eax
  803751:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803754:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803758:	74 06                	je     803760 <realloc_block_FF+0x613>
  80375a:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80375e:	75 17                	jne    803777 <realloc_block_FF+0x62a>
  803760:	83 ec 04             	sub    $0x4,%esp
  803763:	68 64 44 80 00       	push   $0x804464
  803768:	68 44 02 00 00       	push   $0x244
  80376d:	68 f1 43 80 00       	push   $0x8043f1
  803772:	e8 f0 ca ff ff       	call   800267 <_panic>
  803777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80377a:	8b 10                	mov    (%eax),%edx
  80377c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80377f:	89 10                	mov    %edx,(%eax)
  803781:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803784:	8b 00                	mov    (%eax),%eax
  803786:	85 c0                	test   %eax,%eax
  803788:	74 0b                	je     803795 <realloc_block_FF+0x648>
  80378a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80378d:	8b 00                	mov    (%eax),%eax
  80378f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803792:	89 50 04             	mov    %edx,0x4(%eax)
  803795:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803798:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80379b:	89 10                	mov    %edx,(%eax)
  80379d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037a3:	89 50 04             	mov    %edx,0x4(%eax)
  8037a6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037a9:	8b 00                	mov    (%eax),%eax
  8037ab:	85 c0                	test   %eax,%eax
  8037ad:	75 08                	jne    8037b7 <realloc_block_FF+0x66a>
  8037af:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037b2:	a3 30 50 80 00       	mov    %eax,0x805030
  8037b7:	a1 38 50 80 00       	mov    0x805038,%eax
  8037bc:	40                   	inc    %eax
  8037bd:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8037c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037c6:	75 17                	jne    8037df <realloc_block_FF+0x692>
  8037c8:	83 ec 04             	sub    $0x4,%esp
  8037cb:	68 d3 43 80 00       	push   $0x8043d3
  8037d0:	68 45 02 00 00       	push   $0x245
  8037d5:	68 f1 43 80 00       	push   $0x8043f1
  8037da:	e8 88 ca ff ff       	call   800267 <_panic>
  8037df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e2:	8b 00                	mov    (%eax),%eax
  8037e4:	85 c0                	test   %eax,%eax
  8037e6:	74 10                	je     8037f8 <realloc_block_FF+0x6ab>
  8037e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037eb:	8b 00                	mov    (%eax),%eax
  8037ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037f0:	8b 52 04             	mov    0x4(%edx),%edx
  8037f3:	89 50 04             	mov    %edx,0x4(%eax)
  8037f6:	eb 0b                	jmp    803803 <realloc_block_FF+0x6b6>
  8037f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fb:	8b 40 04             	mov    0x4(%eax),%eax
  8037fe:	a3 30 50 80 00       	mov    %eax,0x805030
  803803:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803806:	8b 40 04             	mov    0x4(%eax),%eax
  803809:	85 c0                	test   %eax,%eax
  80380b:	74 0f                	je     80381c <realloc_block_FF+0x6cf>
  80380d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803810:	8b 40 04             	mov    0x4(%eax),%eax
  803813:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803816:	8b 12                	mov    (%edx),%edx
  803818:	89 10                	mov    %edx,(%eax)
  80381a:	eb 0a                	jmp    803826 <realloc_block_FF+0x6d9>
  80381c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381f:	8b 00                	mov    (%eax),%eax
  803821:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803826:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803829:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80382f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803832:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803839:	a1 38 50 80 00       	mov    0x805038,%eax
  80383e:	48                   	dec    %eax
  80383f:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803844:	83 ec 04             	sub    $0x4,%esp
  803847:	6a 00                	push   $0x0
  803849:	ff 75 bc             	pushl  -0x44(%ebp)
  80384c:	ff 75 b8             	pushl  -0x48(%ebp)
  80384f:	e8 06 e9 ff ff       	call   80215a <set_block_data>
  803854:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803857:	8b 45 08             	mov    0x8(%ebp),%eax
  80385a:	eb 0a                	jmp    803866 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80385c:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803863:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803866:	c9                   	leave  
  803867:	c3                   	ret    

00803868 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803868:	55                   	push   %ebp
  803869:	89 e5                	mov    %esp,%ebp
  80386b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80386e:	83 ec 04             	sub    $0x4,%esp
  803871:	68 e8 44 80 00       	push   $0x8044e8
  803876:	68 58 02 00 00       	push   $0x258
  80387b:	68 f1 43 80 00       	push   $0x8043f1
  803880:	e8 e2 c9 ff ff       	call   800267 <_panic>

00803885 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803885:	55                   	push   %ebp
  803886:	89 e5                	mov    %esp,%ebp
  803888:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80388b:	83 ec 04             	sub    $0x4,%esp
  80388e:	68 10 45 80 00       	push   $0x804510
  803893:	68 61 02 00 00       	push   $0x261
  803898:	68 f1 43 80 00       	push   $0x8043f1
  80389d:	e8 c5 c9 ff ff       	call   800267 <_panic>

008038a2 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8038a2:	55                   	push   %ebp
  8038a3:	89 e5                	mov    %esp,%ebp
  8038a5:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8038a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8038ab:	89 d0                	mov    %edx,%eax
  8038ad:	c1 e0 02             	shl    $0x2,%eax
  8038b0:	01 d0                	add    %edx,%eax
  8038b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038b9:	01 d0                	add    %edx,%eax
  8038bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038c2:	01 d0                	add    %edx,%eax
  8038c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038cb:	01 d0                	add    %edx,%eax
  8038cd:	c1 e0 04             	shl    $0x4,%eax
  8038d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8038d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8038da:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8038dd:	83 ec 0c             	sub    $0xc,%esp
  8038e0:	50                   	push   %eax
  8038e1:	e8 2f e2 ff ff       	call   801b15 <sys_get_virtual_time>
  8038e6:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8038e9:	eb 41                	jmp    80392c <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8038eb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8038ee:	83 ec 0c             	sub    $0xc,%esp
  8038f1:	50                   	push   %eax
  8038f2:	e8 1e e2 ff ff       	call   801b15 <sys_get_virtual_time>
  8038f7:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8038fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803900:	29 c2                	sub    %eax,%edx
  803902:	89 d0                	mov    %edx,%eax
  803904:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803907:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80390a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80390d:	89 d1                	mov    %edx,%ecx
  80390f:	29 c1                	sub    %eax,%ecx
  803911:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803914:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803917:	39 c2                	cmp    %eax,%edx
  803919:	0f 97 c0             	seta   %al
  80391c:	0f b6 c0             	movzbl %al,%eax
  80391f:	29 c1                	sub    %eax,%ecx
  803921:	89 c8                	mov    %ecx,%eax
  803923:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803926:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803929:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80392c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803932:	72 b7                	jb     8038eb <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803934:	90                   	nop
  803935:	c9                   	leave  
  803936:	c3                   	ret    

00803937 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803937:	55                   	push   %ebp
  803938:	89 e5                	mov    %esp,%ebp
  80393a:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80393d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803944:	eb 03                	jmp    803949 <busy_wait+0x12>
  803946:	ff 45 fc             	incl   -0x4(%ebp)
  803949:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80394c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80394f:	72 f5                	jb     803946 <busy_wait+0xf>
	return i;
  803951:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803954:	c9                   	leave  
  803955:	c3                   	ret    
  803956:	66 90                	xchg   %ax,%ax

00803958 <__udivdi3>:
  803958:	55                   	push   %ebp
  803959:	57                   	push   %edi
  80395a:	56                   	push   %esi
  80395b:	53                   	push   %ebx
  80395c:	83 ec 1c             	sub    $0x1c,%esp
  80395f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803963:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803967:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80396b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80396f:	89 ca                	mov    %ecx,%edx
  803971:	89 f8                	mov    %edi,%eax
  803973:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803977:	85 f6                	test   %esi,%esi
  803979:	75 2d                	jne    8039a8 <__udivdi3+0x50>
  80397b:	39 cf                	cmp    %ecx,%edi
  80397d:	77 65                	ja     8039e4 <__udivdi3+0x8c>
  80397f:	89 fd                	mov    %edi,%ebp
  803981:	85 ff                	test   %edi,%edi
  803983:	75 0b                	jne    803990 <__udivdi3+0x38>
  803985:	b8 01 00 00 00       	mov    $0x1,%eax
  80398a:	31 d2                	xor    %edx,%edx
  80398c:	f7 f7                	div    %edi
  80398e:	89 c5                	mov    %eax,%ebp
  803990:	31 d2                	xor    %edx,%edx
  803992:	89 c8                	mov    %ecx,%eax
  803994:	f7 f5                	div    %ebp
  803996:	89 c1                	mov    %eax,%ecx
  803998:	89 d8                	mov    %ebx,%eax
  80399a:	f7 f5                	div    %ebp
  80399c:	89 cf                	mov    %ecx,%edi
  80399e:	89 fa                	mov    %edi,%edx
  8039a0:	83 c4 1c             	add    $0x1c,%esp
  8039a3:	5b                   	pop    %ebx
  8039a4:	5e                   	pop    %esi
  8039a5:	5f                   	pop    %edi
  8039a6:	5d                   	pop    %ebp
  8039a7:	c3                   	ret    
  8039a8:	39 ce                	cmp    %ecx,%esi
  8039aa:	77 28                	ja     8039d4 <__udivdi3+0x7c>
  8039ac:	0f bd fe             	bsr    %esi,%edi
  8039af:	83 f7 1f             	xor    $0x1f,%edi
  8039b2:	75 40                	jne    8039f4 <__udivdi3+0x9c>
  8039b4:	39 ce                	cmp    %ecx,%esi
  8039b6:	72 0a                	jb     8039c2 <__udivdi3+0x6a>
  8039b8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8039bc:	0f 87 9e 00 00 00    	ja     803a60 <__udivdi3+0x108>
  8039c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8039c7:	89 fa                	mov    %edi,%edx
  8039c9:	83 c4 1c             	add    $0x1c,%esp
  8039cc:	5b                   	pop    %ebx
  8039cd:	5e                   	pop    %esi
  8039ce:	5f                   	pop    %edi
  8039cf:	5d                   	pop    %ebp
  8039d0:	c3                   	ret    
  8039d1:	8d 76 00             	lea    0x0(%esi),%esi
  8039d4:	31 ff                	xor    %edi,%edi
  8039d6:	31 c0                	xor    %eax,%eax
  8039d8:	89 fa                	mov    %edi,%edx
  8039da:	83 c4 1c             	add    $0x1c,%esp
  8039dd:	5b                   	pop    %ebx
  8039de:	5e                   	pop    %esi
  8039df:	5f                   	pop    %edi
  8039e0:	5d                   	pop    %ebp
  8039e1:	c3                   	ret    
  8039e2:	66 90                	xchg   %ax,%ax
  8039e4:	89 d8                	mov    %ebx,%eax
  8039e6:	f7 f7                	div    %edi
  8039e8:	31 ff                	xor    %edi,%edi
  8039ea:	89 fa                	mov    %edi,%edx
  8039ec:	83 c4 1c             	add    $0x1c,%esp
  8039ef:	5b                   	pop    %ebx
  8039f0:	5e                   	pop    %esi
  8039f1:	5f                   	pop    %edi
  8039f2:	5d                   	pop    %ebp
  8039f3:	c3                   	ret    
  8039f4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8039f9:	89 eb                	mov    %ebp,%ebx
  8039fb:	29 fb                	sub    %edi,%ebx
  8039fd:	89 f9                	mov    %edi,%ecx
  8039ff:	d3 e6                	shl    %cl,%esi
  803a01:	89 c5                	mov    %eax,%ebp
  803a03:	88 d9                	mov    %bl,%cl
  803a05:	d3 ed                	shr    %cl,%ebp
  803a07:	89 e9                	mov    %ebp,%ecx
  803a09:	09 f1                	or     %esi,%ecx
  803a0b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a0f:	89 f9                	mov    %edi,%ecx
  803a11:	d3 e0                	shl    %cl,%eax
  803a13:	89 c5                	mov    %eax,%ebp
  803a15:	89 d6                	mov    %edx,%esi
  803a17:	88 d9                	mov    %bl,%cl
  803a19:	d3 ee                	shr    %cl,%esi
  803a1b:	89 f9                	mov    %edi,%ecx
  803a1d:	d3 e2                	shl    %cl,%edx
  803a1f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a23:	88 d9                	mov    %bl,%cl
  803a25:	d3 e8                	shr    %cl,%eax
  803a27:	09 c2                	or     %eax,%edx
  803a29:	89 d0                	mov    %edx,%eax
  803a2b:	89 f2                	mov    %esi,%edx
  803a2d:	f7 74 24 0c          	divl   0xc(%esp)
  803a31:	89 d6                	mov    %edx,%esi
  803a33:	89 c3                	mov    %eax,%ebx
  803a35:	f7 e5                	mul    %ebp
  803a37:	39 d6                	cmp    %edx,%esi
  803a39:	72 19                	jb     803a54 <__udivdi3+0xfc>
  803a3b:	74 0b                	je     803a48 <__udivdi3+0xf0>
  803a3d:	89 d8                	mov    %ebx,%eax
  803a3f:	31 ff                	xor    %edi,%edi
  803a41:	e9 58 ff ff ff       	jmp    80399e <__udivdi3+0x46>
  803a46:	66 90                	xchg   %ax,%ax
  803a48:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a4c:	89 f9                	mov    %edi,%ecx
  803a4e:	d3 e2                	shl    %cl,%edx
  803a50:	39 c2                	cmp    %eax,%edx
  803a52:	73 e9                	jae    803a3d <__udivdi3+0xe5>
  803a54:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a57:	31 ff                	xor    %edi,%edi
  803a59:	e9 40 ff ff ff       	jmp    80399e <__udivdi3+0x46>
  803a5e:	66 90                	xchg   %ax,%ax
  803a60:	31 c0                	xor    %eax,%eax
  803a62:	e9 37 ff ff ff       	jmp    80399e <__udivdi3+0x46>
  803a67:	90                   	nop

00803a68 <__umoddi3>:
  803a68:	55                   	push   %ebp
  803a69:	57                   	push   %edi
  803a6a:	56                   	push   %esi
  803a6b:	53                   	push   %ebx
  803a6c:	83 ec 1c             	sub    $0x1c,%esp
  803a6f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a73:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a7b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a83:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a87:	89 f3                	mov    %esi,%ebx
  803a89:	89 fa                	mov    %edi,%edx
  803a8b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a8f:	89 34 24             	mov    %esi,(%esp)
  803a92:	85 c0                	test   %eax,%eax
  803a94:	75 1a                	jne    803ab0 <__umoddi3+0x48>
  803a96:	39 f7                	cmp    %esi,%edi
  803a98:	0f 86 a2 00 00 00    	jbe    803b40 <__umoddi3+0xd8>
  803a9e:	89 c8                	mov    %ecx,%eax
  803aa0:	89 f2                	mov    %esi,%edx
  803aa2:	f7 f7                	div    %edi
  803aa4:	89 d0                	mov    %edx,%eax
  803aa6:	31 d2                	xor    %edx,%edx
  803aa8:	83 c4 1c             	add    $0x1c,%esp
  803aab:	5b                   	pop    %ebx
  803aac:	5e                   	pop    %esi
  803aad:	5f                   	pop    %edi
  803aae:	5d                   	pop    %ebp
  803aaf:	c3                   	ret    
  803ab0:	39 f0                	cmp    %esi,%eax
  803ab2:	0f 87 ac 00 00 00    	ja     803b64 <__umoddi3+0xfc>
  803ab8:	0f bd e8             	bsr    %eax,%ebp
  803abb:	83 f5 1f             	xor    $0x1f,%ebp
  803abe:	0f 84 ac 00 00 00    	je     803b70 <__umoddi3+0x108>
  803ac4:	bf 20 00 00 00       	mov    $0x20,%edi
  803ac9:	29 ef                	sub    %ebp,%edi
  803acb:	89 fe                	mov    %edi,%esi
  803acd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ad1:	89 e9                	mov    %ebp,%ecx
  803ad3:	d3 e0                	shl    %cl,%eax
  803ad5:	89 d7                	mov    %edx,%edi
  803ad7:	89 f1                	mov    %esi,%ecx
  803ad9:	d3 ef                	shr    %cl,%edi
  803adb:	09 c7                	or     %eax,%edi
  803add:	89 e9                	mov    %ebp,%ecx
  803adf:	d3 e2                	shl    %cl,%edx
  803ae1:	89 14 24             	mov    %edx,(%esp)
  803ae4:	89 d8                	mov    %ebx,%eax
  803ae6:	d3 e0                	shl    %cl,%eax
  803ae8:	89 c2                	mov    %eax,%edx
  803aea:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aee:	d3 e0                	shl    %cl,%eax
  803af0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803af4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803af8:	89 f1                	mov    %esi,%ecx
  803afa:	d3 e8                	shr    %cl,%eax
  803afc:	09 d0                	or     %edx,%eax
  803afe:	d3 eb                	shr    %cl,%ebx
  803b00:	89 da                	mov    %ebx,%edx
  803b02:	f7 f7                	div    %edi
  803b04:	89 d3                	mov    %edx,%ebx
  803b06:	f7 24 24             	mull   (%esp)
  803b09:	89 c6                	mov    %eax,%esi
  803b0b:	89 d1                	mov    %edx,%ecx
  803b0d:	39 d3                	cmp    %edx,%ebx
  803b0f:	0f 82 87 00 00 00    	jb     803b9c <__umoddi3+0x134>
  803b15:	0f 84 91 00 00 00    	je     803bac <__umoddi3+0x144>
  803b1b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b1f:	29 f2                	sub    %esi,%edx
  803b21:	19 cb                	sbb    %ecx,%ebx
  803b23:	89 d8                	mov    %ebx,%eax
  803b25:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b29:	d3 e0                	shl    %cl,%eax
  803b2b:	89 e9                	mov    %ebp,%ecx
  803b2d:	d3 ea                	shr    %cl,%edx
  803b2f:	09 d0                	or     %edx,%eax
  803b31:	89 e9                	mov    %ebp,%ecx
  803b33:	d3 eb                	shr    %cl,%ebx
  803b35:	89 da                	mov    %ebx,%edx
  803b37:	83 c4 1c             	add    $0x1c,%esp
  803b3a:	5b                   	pop    %ebx
  803b3b:	5e                   	pop    %esi
  803b3c:	5f                   	pop    %edi
  803b3d:	5d                   	pop    %ebp
  803b3e:	c3                   	ret    
  803b3f:	90                   	nop
  803b40:	89 fd                	mov    %edi,%ebp
  803b42:	85 ff                	test   %edi,%edi
  803b44:	75 0b                	jne    803b51 <__umoddi3+0xe9>
  803b46:	b8 01 00 00 00       	mov    $0x1,%eax
  803b4b:	31 d2                	xor    %edx,%edx
  803b4d:	f7 f7                	div    %edi
  803b4f:	89 c5                	mov    %eax,%ebp
  803b51:	89 f0                	mov    %esi,%eax
  803b53:	31 d2                	xor    %edx,%edx
  803b55:	f7 f5                	div    %ebp
  803b57:	89 c8                	mov    %ecx,%eax
  803b59:	f7 f5                	div    %ebp
  803b5b:	89 d0                	mov    %edx,%eax
  803b5d:	e9 44 ff ff ff       	jmp    803aa6 <__umoddi3+0x3e>
  803b62:	66 90                	xchg   %ax,%ax
  803b64:	89 c8                	mov    %ecx,%eax
  803b66:	89 f2                	mov    %esi,%edx
  803b68:	83 c4 1c             	add    $0x1c,%esp
  803b6b:	5b                   	pop    %ebx
  803b6c:	5e                   	pop    %esi
  803b6d:	5f                   	pop    %edi
  803b6e:	5d                   	pop    %ebp
  803b6f:	c3                   	ret    
  803b70:	3b 04 24             	cmp    (%esp),%eax
  803b73:	72 06                	jb     803b7b <__umoddi3+0x113>
  803b75:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b79:	77 0f                	ja     803b8a <__umoddi3+0x122>
  803b7b:	89 f2                	mov    %esi,%edx
  803b7d:	29 f9                	sub    %edi,%ecx
  803b7f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b83:	89 14 24             	mov    %edx,(%esp)
  803b86:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b8a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b8e:	8b 14 24             	mov    (%esp),%edx
  803b91:	83 c4 1c             	add    $0x1c,%esp
  803b94:	5b                   	pop    %ebx
  803b95:	5e                   	pop    %esi
  803b96:	5f                   	pop    %edi
  803b97:	5d                   	pop    %ebp
  803b98:	c3                   	ret    
  803b99:	8d 76 00             	lea    0x0(%esi),%esi
  803b9c:	2b 04 24             	sub    (%esp),%eax
  803b9f:	19 fa                	sbb    %edi,%edx
  803ba1:	89 d1                	mov    %edx,%ecx
  803ba3:	89 c6                	mov    %eax,%esi
  803ba5:	e9 71 ff ff ff       	jmp    803b1b <__umoddi3+0xb3>
  803baa:	66 90                	xchg   %ax,%ax
  803bac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803bb0:	72 ea                	jb     803b9c <__umoddi3+0x134>
  803bb2:	89 d9                	mov    %ebx,%ecx
  803bb4:	e9 62 ff ff ff       	jmp    803b1b <__umoddi3+0xb3>
