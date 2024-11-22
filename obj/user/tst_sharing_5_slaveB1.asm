
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
  80005b:	68 20 3b 80 00       	push   $0x803b20
  800060:	6a 0c                	push   $0xc
  800062:	68 3c 3b 80 00       	push   $0x803b3c
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
  800073:	e8 b8 19 00 00       	call   801a30 <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 59 3b 80 00       	push   $0x803b59
  800080:	50                   	push   %eax
  800081:	e8 fa 15 00 00       	call   801680 <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 5c 3b 80 00       	push   $0x803b5c
  800094:	e8 8b 04 00 00       	call   800524 <cprintf>
  800099:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got x
	inctst();
  80009c:	e8 b4 1a 00 00       	call   801b55 <inctst>
	cprintf("Slave B1 please be patient ...\n");
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	68 84 3b 80 00       	push   $0x803b84
  8000a9:	e8 76 04 00 00       	call   800524 <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(6000);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 70 17 00 00       	push   $0x1770
  8000b9:	e8 32 37 00 00       	call   8037f0 <env_sleep>
  8000be:	83 c4 10             	add    $0x10,%esp
	while (gettst()!=2) ;// panic("test failed");
  8000c1:	90                   	nop
  8000c2:	e8 a8 1a 00 00       	call   801b6f <gettst>
  8000c7:	83 f8 02             	cmp    $0x2,%eax
  8000ca:	75 f6                	jne    8000c2 <_main+0x8a>

	freeFrames = sys_calculate_free_frames() ;
  8000cc:	e8 7d 17 00 00       	call   80184e <sys_calculate_free_frames>
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	sfree(x);
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000da:	e8 be 15 00 00       	call   80169d <sfree>
  8000df:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 a4 3b 80 00       	push   $0x803ba4
  8000ea:	e8 35 04 00 00       	call   800524 <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
	expected = 1+1; /*1page+1table*/
  8000f2:	c7 45 e8 02 00 00 00 	movl   $0x2,-0x18(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  8000f9:	e8 50 17 00 00       	call   80184e <sys_calculate_free_frames>
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800103:	29 c2                	sub    %eax,%edx
  800105:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800108:	39 c2                	cmp    %eax,%edx
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 bc 3b 80 00       	push   $0x803bbc
  800114:	6a 26                	push   $0x26
  800116:	68 3c 3b 80 00       	push   $0x803b3c
  80011b:	e8 47 01 00 00       	call   800267 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800120:	e8 30 1a 00 00       	call   801b55 <inctst>
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
  80012e:	e8 e4 18 00 00       	call   801a17 <sys_getenvindex>
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
  80019c:	e8 fa 15 00 00       	call   80179b <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001a1:	83 ec 0c             	sub    $0xc,%esp
  8001a4:	68 7c 3c 80 00       	push   $0x803c7c
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
  8001cc:	68 a4 3c 80 00       	push   $0x803ca4
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
  8001fd:	68 cc 3c 80 00       	push   $0x803ccc
  800202:	e8 1d 03 00 00       	call   800524 <cprintf>
  800207:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80020a:	a1 20 50 80 00       	mov    0x805020,%eax
  80020f:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800215:	83 ec 08             	sub    $0x8,%esp
  800218:	50                   	push   %eax
  800219:	68 24 3d 80 00       	push   $0x803d24
  80021e:	e8 01 03 00 00       	call   800524 <cprintf>
  800223:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800226:	83 ec 0c             	sub    $0xc,%esp
  800229:	68 7c 3c 80 00       	push   $0x803c7c
  80022e:	e8 f1 02 00 00       	call   800524 <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800236:	e8 7a 15 00 00       	call   8017b5 <sys_unlock_cons>
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
  80024e:	e8 90 17 00 00       	call   8019e3 <sys_destroy_env>
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
  80025f:	e8 e5 17 00 00       	call   801a49 <sys_exit_env>
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
  800288:	68 38 3d 80 00       	push   $0x803d38
  80028d:	e8 92 02 00 00       	call   800524 <cprintf>
  800292:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800295:	a1 00 50 80 00       	mov    0x805000,%eax
  80029a:	ff 75 0c             	pushl  0xc(%ebp)
  80029d:	ff 75 08             	pushl  0x8(%ebp)
  8002a0:	50                   	push   %eax
  8002a1:	68 3d 3d 80 00       	push   $0x803d3d
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
  8002c5:	68 59 3d 80 00       	push   $0x803d59
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
  8002f4:	68 5c 3d 80 00       	push   $0x803d5c
  8002f9:	6a 26                	push   $0x26
  8002fb:	68 a8 3d 80 00       	push   $0x803da8
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
  8003c9:	68 b4 3d 80 00       	push   $0x803db4
  8003ce:	6a 3a                	push   $0x3a
  8003d0:	68 a8 3d 80 00       	push   $0x803da8
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
  80043c:	68 08 3e 80 00       	push   $0x803e08
  800441:	6a 44                	push   $0x44
  800443:	68 a8 3d 80 00       	push   $0x803da8
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
  800496:	e8 be 12 00 00       	call   801759 <sys_cputs>
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
  80050d:	e8 47 12 00 00       	call   801759 <sys_cputs>
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
  800557:	e8 3f 12 00 00       	call   80179b <sys_lock_cons>
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
  800577:	e8 39 12 00 00       	call   8017b5 <sys_unlock_cons>
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
  8005c1:	e8 de 32 00 00       	call   8038a4 <__udivdi3>
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
  800611:	e8 9e 33 00 00       	call   8039b4 <__umoddi3>
  800616:	83 c4 10             	add    $0x10,%esp
  800619:	05 74 40 80 00       	add    $0x804074,%eax
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
  80076c:	8b 04 85 98 40 80 00 	mov    0x804098(,%eax,4),%eax
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
  80084d:	8b 34 9d e0 3e 80 00 	mov    0x803ee0(,%ebx,4),%esi
  800854:	85 f6                	test   %esi,%esi
  800856:	75 19                	jne    800871 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800858:	53                   	push   %ebx
  800859:	68 85 40 80 00       	push   $0x804085
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
  800872:	68 8e 40 80 00       	push   $0x80408e
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
  80089f:	be 91 40 80 00       	mov    $0x804091,%esi
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
  8012aa:	68 08 42 80 00       	push   $0x804208
  8012af:	68 3f 01 00 00       	push   $0x13f
  8012b4:	68 2a 42 80 00       	push   $0x80422a
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
  8012ca:	e8 35 0a 00 00       	call   801d04 <sys_sbrk>
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
  801345:	e8 3e 08 00 00       	call   801b88 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80134a:	85 c0                	test   %eax,%eax
  80134c:	74 16                	je     801364 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80134e:	83 ec 0c             	sub    $0xc,%esp
  801351:	ff 75 08             	pushl  0x8(%ebp)
  801354:	e8 7e 0d 00 00       	call   8020d7 <alloc_block_FF>
  801359:	83 c4 10             	add    $0x10,%esp
  80135c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80135f:	e9 8a 01 00 00       	jmp    8014ee <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801364:	e8 50 08 00 00       	call   801bb9 <sys_isUHeapPlacementStrategyBESTFIT>
  801369:	85 c0                	test   %eax,%eax
  80136b:	0f 84 7d 01 00 00    	je     8014ee <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801371:	83 ec 0c             	sub    $0xc,%esp
  801374:	ff 75 08             	pushl  0x8(%ebp)
  801377:	e8 17 12 00 00       	call   802593 <alloc_block_BF>
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
  8014dd:	e8 59 08 00 00       	call   801d3b <sys_allocate_user_mem>
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
  801525:	e8 2d 08 00 00       	call   801d57 <get_block_size>
  80152a:	83 c4 10             	add    $0x10,%esp
  80152d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801530:	83 ec 0c             	sub    $0xc,%esp
  801533:	ff 75 08             	pushl  0x8(%ebp)
  801536:	e8 60 1a 00 00       	call   802f9b <free_block>
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
  8015cd:	e8 4d 07 00 00       	call   801d1f <sys_free_user_mem>
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
  8015db:	68 38 42 80 00       	push   $0x804238
  8015e0:	68 84 00 00 00       	push   $0x84
  8015e5:	68 62 42 80 00       	push   $0x804262
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
  801608:	eb 74                	jmp    80167e <smalloc+0x8d>
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
  80163d:	eb 3f                	jmp    80167e <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80163f:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801643:	ff 75 ec             	pushl  -0x14(%ebp)
  801646:	50                   	push   %eax
  801647:	ff 75 0c             	pushl  0xc(%ebp)
  80164a:	ff 75 08             	pushl  0x8(%ebp)
  80164d:	e8 d4 02 00 00       	call   801926 <sys_createSharedObject>
  801652:	83 c4 10             	add    $0x10,%esp
  801655:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801658:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80165c:	74 06                	je     801664 <smalloc+0x73>
  80165e:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801662:	75 07                	jne    80166b <smalloc+0x7a>
  801664:	b8 00 00 00 00       	mov    $0x0,%eax
  801669:	eb 13                	jmp    80167e <smalloc+0x8d>
	 cprintf("153\n");
  80166b:	83 ec 0c             	sub    $0xc,%esp
  80166e:	68 6e 42 80 00       	push   $0x80426e
  801673:	e8 ac ee ff ff       	call   800524 <cprintf>
  801678:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  80167b:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  80167e:	c9                   	leave  
  80167f:	c3                   	ret    

00801680 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801686:	83 ec 04             	sub    $0x4,%esp
  801689:	68 74 42 80 00       	push   $0x804274
  80168e:	68 a4 00 00 00       	push   $0xa4
  801693:	68 62 42 80 00       	push   $0x804262
  801698:	e8 ca eb ff ff       	call   800267 <_panic>

0080169d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
  8016a0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016a3:	83 ec 04             	sub    $0x4,%esp
  8016a6:	68 98 42 80 00       	push   $0x804298
  8016ab:	68 bc 00 00 00       	push   $0xbc
  8016b0:	68 62 42 80 00       	push   $0x804262
  8016b5:	e8 ad eb ff ff       	call   800267 <_panic>

008016ba <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
  8016bd:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016c0:	83 ec 04             	sub    $0x4,%esp
  8016c3:	68 bc 42 80 00       	push   $0x8042bc
  8016c8:	68 d3 00 00 00       	push   $0xd3
  8016cd:	68 62 42 80 00       	push   $0x804262
  8016d2:	e8 90 eb ff ff       	call   800267 <_panic>

008016d7 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016dd:	83 ec 04             	sub    $0x4,%esp
  8016e0:	68 e2 42 80 00       	push   $0x8042e2
  8016e5:	68 df 00 00 00       	push   $0xdf
  8016ea:	68 62 42 80 00       	push   $0x804262
  8016ef:	e8 73 eb ff ff       	call   800267 <_panic>

008016f4 <shrink>:

}
void shrink(uint32 newSize)
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
  8016f7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016fa:	83 ec 04             	sub    $0x4,%esp
  8016fd:	68 e2 42 80 00       	push   $0x8042e2
  801702:	68 e4 00 00 00       	push   $0xe4
  801707:	68 62 42 80 00       	push   $0x804262
  80170c:	e8 56 eb ff ff       	call   800267 <_panic>

00801711 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801717:	83 ec 04             	sub    $0x4,%esp
  80171a:	68 e2 42 80 00       	push   $0x8042e2
  80171f:	68 e9 00 00 00       	push   $0xe9
  801724:	68 62 42 80 00       	push   $0x804262
  801729:	e8 39 eb ff ff       	call   800267 <_panic>

0080172e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	57                   	push   %edi
  801732:	56                   	push   %esi
  801733:	53                   	push   %ebx
  801734:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801740:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801743:	8b 7d 18             	mov    0x18(%ebp),%edi
  801746:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801749:	cd 30                	int    $0x30
  80174b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80174e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801751:	83 c4 10             	add    $0x10,%esp
  801754:	5b                   	pop    %ebx
  801755:	5e                   	pop    %esi
  801756:	5f                   	pop    %edi
  801757:	5d                   	pop    %ebp
  801758:	c3                   	ret    

00801759 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	83 ec 04             	sub    $0x4,%esp
  80175f:	8b 45 10             	mov    0x10(%ebp),%eax
  801762:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801765:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	52                   	push   %edx
  801771:	ff 75 0c             	pushl  0xc(%ebp)
  801774:	50                   	push   %eax
  801775:	6a 00                	push   $0x0
  801777:	e8 b2 ff ff ff       	call   80172e <syscall>
  80177c:	83 c4 18             	add    $0x18,%esp
}
  80177f:	90                   	nop
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <sys_cgetc>:

int
sys_cgetc(void)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 02                	push   $0x2
  801791:	e8 98 ff ff ff       	call   80172e <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
}
  801799:	c9                   	leave  
  80179a:	c3                   	ret    

0080179b <sys_lock_cons>:

void sys_lock_cons(void)
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 03                	push   $0x3
  8017aa:	e8 7f ff ff ff       	call   80172e <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
}
  8017b2:	90                   	nop
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 04                	push   $0x4
  8017c4:	e8 65 ff ff ff       	call   80172e <syscall>
  8017c9:	83 c4 18             	add    $0x18,%esp
}
  8017cc:	90                   	nop
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	52                   	push   %edx
  8017df:	50                   	push   %eax
  8017e0:	6a 08                	push   $0x8
  8017e2:	e8 47 ff ff ff       	call   80172e <syscall>
  8017e7:	83 c4 18             	add    $0x18,%esp
}
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	56                   	push   %esi
  8017f0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017f1:	8b 75 18             	mov    0x18(%ebp),%esi
  8017f4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	56                   	push   %esi
  801801:	53                   	push   %ebx
  801802:	51                   	push   %ecx
  801803:	52                   	push   %edx
  801804:	50                   	push   %eax
  801805:	6a 09                	push   $0x9
  801807:	e8 22 ff ff ff       	call   80172e <syscall>
  80180c:	83 c4 18             	add    $0x18,%esp
}
  80180f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801812:	5b                   	pop    %ebx
  801813:	5e                   	pop    %esi
  801814:	5d                   	pop    %ebp
  801815:	c3                   	ret    

00801816 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801819:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	52                   	push   %edx
  801826:	50                   	push   %eax
  801827:	6a 0a                	push   $0xa
  801829:	e8 00 ff ff ff       	call   80172e <syscall>
  80182e:	83 c4 18             	add    $0x18,%esp
}
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	ff 75 0c             	pushl  0xc(%ebp)
  80183f:	ff 75 08             	pushl  0x8(%ebp)
  801842:	6a 0b                	push   $0xb
  801844:	e8 e5 fe ff ff       	call   80172e <syscall>
  801849:	83 c4 18             	add    $0x18,%esp
}
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 0c                	push   $0xc
  80185d:	e8 cc fe ff ff       	call   80172e <syscall>
  801862:	83 c4 18             	add    $0x18,%esp
}
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 0d                	push   $0xd
  801876:	e8 b3 fe ff ff       	call   80172e <syscall>
  80187b:	83 c4 18             	add    $0x18,%esp
}
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 0e                	push   $0xe
  80188f:	e8 9a fe ff ff       	call   80172e <syscall>
  801894:	83 c4 18             	add    $0x18,%esp
}
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 0f                	push   $0xf
  8018a8:	e8 81 fe ff ff       	call   80172e <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	ff 75 08             	pushl  0x8(%ebp)
  8018c0:	6a 10                	push   $0x10
  8018c2:	e8 67 fe ff ff       	call   80172e <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
}
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 11                	push   $0x11
  8018db:	e8 4e fe ff ff       	call   80172e <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
}
  8018e3:	90                   	nop
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_cputc>:

void
sys_cputc(const char c)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	83 ec 04             	sub    $0x4,%esp
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018f2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	50                   	push   %eax
  8018ff:	6a 01                	push   $0x1
  801901:	e8 28 fe ff ff       	call   80172e <syscall>
  801906:	83 c4 18             	add    $0x18,%esp
}
  801909:	90                   	nop
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 14                	push   $0x14
  80191b:	e8 0e fe ff ff       	call   80172e <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
}
  801923:	90                   	nop
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
  801929:	83 ec 04             	sub    $0x4,%esp
  80192c:	8b 45 10             	mov    0x10(%ebp),%eax
  80192f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801932:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801935:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801939:	8b 45 08             	mov    0x8(%ebp),%eax
  80193c:	6a 00                	push   $0x0
  80193e:	51                   	push   %ecx
  80193f:	52                   	push   %edx
  801940:	ff 75 0c             	pushl  0xc(%ebp)
  801943:	50                   	push   %eax
  801944:	6a 15                	push   $0x15
  801946:	e8 e3 fd ff ff       	call   80172e <syscall>
  80194b:	83 c4 18             	add    $0x18,%esp
}
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801953:	8b 55 0c             	mov    0xc(%ebp),%edx
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	52                   	push   %edx
  801960:	50                   	push   %eax
  801961:	6a 16                	push   $0x16
  801963:	e8 c6 fd ff ff       	call   80172e <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801970:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801973:	8b 55 0c             	mov    0xc(%ebp),%edx
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	51                   	push   %ecx
  80197e:	52                   	push   %edx
  80197f:	50                   	push   %eax
  801980:	6a 17                	push   $0x17
  801982:	e8 a7 fd ff ff       	call   80172e <syscall>
  801987:	83 c4 18             	add    $0x18,%esp
}
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80198f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	52                   	push   %edx
  80199c:	50                   	push   %eax
  80199d:	6a 18                	push   $0x18
  80199f:	e8 8a fd ff ff       	call   80172e <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8019af:	6a 00                	push   $0x0
  8019b1:	ff 75 14             	pushl  0x14(%ebp)
  8019b4:	ff 75 10             	pushl  0x10(%ebp)
  8019b7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ba:	50                   	push   %eax
  8019bb:	6a 19                	push   $0x19
  8019bd:	e8 6c fd ff ff       	call   80172e <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	50                   	push   %eax
  8019d6:	6a 1a                	push   $0x1a
  8019d8:	e8 51 fd ff ff       	call   80172e <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
}
  8019e0:	90                   	nop
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	50                   	push   %eax
  8019f2:	6a 1b                	push   $0x1b
  8019f4:	e8 35 fd ff ff       	call   80172e <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 05                	push   $0x5
  801a0d:	e8 1c fd ff ff       	call   80172e <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
}
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 06                	push   $0x6
  801a26:	e8 03 fd ff ff       	call   80172e <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
}
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 07                	push   $0x7
  801a3f:	e8 ea fc ff ff       	call   80172e <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
}
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <sys_exit_env>:


void sys_exit_env(void)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 1c                	push   $0x1c
  801a58:	e8 d1 fc ff ff       	call   80172e <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
}
  801a60:	90                   	nop
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a69:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a6c:	8d 50 04             	lea    0x4(%eax),%edx
  801a6f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	52                   	push   %edx
  801a79:	50                   	push   %eax
  801a7a:	6a 1d                	push   $0x1d
  801a7c:	e8 ad fc ff ff       	call   80172e <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
	return result;
  801a84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a87:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a8d:	89 01                	mov    %eax,(%ecx)
  801a8f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	c9                   	leave  
  801a96:	c2 04 00             	ret    $0x4

00801a99 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	ff 75 10             	pushl  0x10(%ebp)
  801aa3:	ff 75 0c             	pushl  0xc(%ebp)
  801aa6:	ff 75 08             	pushl  0x8(%ebp)
  801aa9:	6a 13                	push   $0x13
  801aab:	e8 7e fc ff ff       	call   80172e <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab3:	90                   	nop
}
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 1e                	push   $0x1e
  801ac5:	e8 64 fc ff ff       	call   80172e <syscall>
  801aca:	83 c4 18             	add    $0x18,%esp
}
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
  801ad2:	83 ec 04             	sub    $0x4,%esp
  801ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801adb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	50                   	push   %eax
  801ae8:	6a 1f                	push   $0x1f
  801aea:	e8 3f fc ff ff       	call   80172e <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
	return ;
  801af2:	90                   	nop
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <rsttst>:
void rsttst()
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 21                	push   $0x21
  801b04:	e8 25 fc ff ff       	call   80172e <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0c:	90                   	nop
}
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
  801b12:	83 ec 04             	sub    $0x4,%esp
  801b15:	8b 45 14             	mov    0x14(%ebp),%eax
  801b18:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b1b:	8b 55 18             	mov    0x18(%ebp),%edx
  801b1e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b22:	52                   	push   %edx
  801b23:	50                   	push   %eax
  801b24:	ff 75 10             	pushl  0x10(%ebp)
  801b27:	ff 75 0c             	pushl  0xc(%ebp)
  801b2a:	ff 75 08             	pushl  0x8(%ebp)
  801b2d:	6a 20                	push   $0x20
  801b2f:	e8 fa fb ff ff       	call   80172e <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
	return ;
  801b37:	90                   	nop
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <chktst>:
void chktst(uint32 n)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	ff 75 08             	pushl  0x8(%ebp)
  801b48:	6a 22                	push   $0x22
  801b4a:	e8 df fb ff ff       	call   80172e <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b52:	90                   	nop
}
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <inctst>:

void inctst()
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 23                	push   $0x23
  801b64:	e8 c5 fb ff ff       	call   80172e <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
	return ;
  801b6c:	90                   	nop
}
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <gettst>:
uint32 gettst()
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 24                	push   $0x24
  801b7e:	e8 ab fb ff ff       	call   80172e <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
  801b8b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 25                	push   $0x25
  801b9a:	e8 8f fb ff ff       	call   80172e <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
  801ba2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ba5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ba9:	75 07                	jne    801bb2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bab:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb0:	eb 05                	jmp    801bb7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
  801bbc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 25                	push   $0x25
  801bcb:	e8 5e fb ff ff       	call   80172e <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
  801bd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bd6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bda:	75 07                	jne    801be3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bdc:	b8 01 00 00 00       	mov    $0x1,%eax
  801be1:	eb 05                	jmp    801be8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801be3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
  801bed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 25                	push   $0x25
  801bfc:	e8 2d fb ff ff       	call   80172e <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
  801c04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c07:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c0b:	75 07                	jne    801c14 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c0d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c12:	eb 05                	jmp    801c19 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 25                	push   $0x25
  801c2d:	e8 fc fa ff ff       	call   80172e <syscall>
  801c32:	83 c4 18             	add    $0x18,%esp
  801c35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c38:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c3c:	75 07                	jne    801c45 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c3e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c43:	eb 05                	jmp    801c4a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	ff 75 08             	pushl  0x8(%ebp)
  801c5a:	6a 26                	push   $0x26
  801c5c:	e8 cd fa ff ff       	call   80172e <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
	return ;
  801c64:	90                   	nop
}
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
  801c6a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c6b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	6a 00                	push   $0x0
  801c79:	53                   	push   %ebx
  801c7a:	51                   	push   %ecx
  801c7b:	52                   	push   %edx
  801c7c:	50                   	push   %eax
  801c7d:	6a 27                	push   $0x27
  801c7f:	e8 aa fa ff ff       	call   80172e <syscall>
  801c84:	83 c4 18             	add    $0x18,%esp
}
  801c87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c92:	8b 45 08             	mov    0x8(%ebp),%eax
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	52                   	push   %edx
  801c9c:	50                   	push   %eax
  801c9d:	6a 28                	push   $0x28
  801c9f:	e8 8a fa ff ff       	call   80172e <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801cac:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801caf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb5:	6a 00                	push   $0x0
  801cb7:	51                   	push   %ecx
  801cb8:	ff 75 10             	pushl  0x10(%ebp)
  801cbb:	52                   	push   %edx
  801cbc:	50                   	push   %eax
  801cbd:	6a 29                	push   $0x29
  801cbf:	e8 6a fa ff ff       	call   80172e <syscall>
  801cc4:	83 c4 18             	add    $0x18,%esp
}
  801cc7:	c9                   	leave  
  801cc8:	c3                   	ret    

00801cc9 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	ff 75 10             	pushl  0x10(%ebp)
  801cd3:	ff 75 0c             	pushl  0xc(%ebp)
  801cd6:	ff 75 08             	pushl  0x8(%ebp)
  801cd9:	6a 12                	push   $0x12
  801cdb:	e8 4e fa ff ff       	call   80172e <syscall>
  801ce0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce3:	90                   	nop
}
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801ce9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cec:	8b 45 08             	mov    0x8(%ebp),%eax
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	52                   	push   %edx
  801cf6:	50                   	push   %eax
  801cf7:	6a 2a                	push   $0x2a
  801cf9:	e8 30 fa ff ff       	call   80172e <syscall>
  801cfe:	83 c4 18             	add    $0x18,%esp
	return;
  801d01:	90                   	nop
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801d07:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	50                   	push   %eax
  801d13:	6a 2b                	push   $0x2b
  801d15:	e8 14 fa ff ff       	call   80172e <syscall>
  801d1a:	83 c4 18             	add    $0x18,%esp
}
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	ff 75 0c             	pushl  0xc(%ebp)
  801d2b:	ff 75 08             	pushl  0x8(%ebp)
  801d2e:	6a 2c                	push   $0x2c
  801d30:	e8 f9 f9 ff ff       	call   80172e <syscall>
  801d35:	83 c4 18             	add    $0x18,%esp
	return;
  801d38:	90                   	nop
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	ff 75 0c             	pushl  0xc(%ebp)
  801d47:	ff 75 08             	pushl  0x8(%ebp)
  801d4a:	6a 2d                	push   $0x2d
  801d4c:	e8 dd f9 ff ff       	call   80172e <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
	return;
  801d54:	90                   	nop
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
  801d5a:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d60:	83 e8 04             	sub    $0x4,%eax
  801d63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801d66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d69:	8b 00                	mov    (%eax),%eax
  801d6b:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801d76:	8b 45 08             	mov    0x8(%ebp),%eax
  801d79:	83 e8 04             	sub    $0x4,%eax
  801d7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801d7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d82:	8b 00                	mov    (%eax),%eax
  801d84:	83 e0 01             	and    $0x1,%eax
  801d87:	85 c0                	test   %eax,%eax
  801d89:	0f 94 c0             	sete   %al
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801d94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d9e:	83 f8 02             	cmp    $0x2,%eax
  801da1:	74 2b                	je     801dce <alloc_block+0x40>
  801da3:	83 f8 02             	cmp    $0x2,%eax
  801da6:	7f 07                	jg     801daf <alloc_block+0x21>
  801da8:	83 f8 01             	cmp    $0x1,%eax
  801dab:	74 0e                	je     801dbb <alloc_block+0x2d>
  801dad:	eb 58                	jmp    801e07 <alloc_block+0x79>
  801daf:	83 f8 03             	cmp    $0x3,%eax
  801db2:	74 2d                	je     801de1 <alloc_block+0x53>
  801db4:	83 f8 04             	cmp    $0x4,%eax
  801db7:	74 3b                	je     801df4 <alloc_block+0x66>
  801db9:	eb 4c                	jmp    801e07 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801dbb:	83 ec 0c             	sub    $0xc,%esp
  801dbe:	ff 75 08             	pushl  0x8(%ebp)
  801dc1:	e8 11 03 00 00       	call   8020d7 <alloc_block_FF>
  801dc6:	83 c4 10             	add    $0x10,%esp
  801dc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801dcc:	eb 4a                	jmp    801e18 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801dce:	83 ec 0c             	sub    $0xc,%esp
  801dd1:	ff 75 08             	pushl  0x8(%ebp)
  801dd4:	e8 fa 19 00 00       	call   8037d3 <alloc_block_NF>
  801dd9:	83 c4 10             	add    $0x10,%esp
  801ddc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ddf:	eb 37                	jmp    801e18 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801de1:	83 ec 0c             	sub    $0xc,%esp
  801de4:	ff 75 08             	pushl  0x8(%ebp)
  801de7:	e8 a7 07 00 00       	call   802593 <alloc_block_BF>
  801dec:	83 c4 10             	add    $0x10,%esp
  801def:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801df2:	eb 24                	jmp    801e18 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801df4:	83 ec 0c             	sub    $0xc,%esp
  801df7:	ff 75 08             	pushl  0x8(%ebp)
  801dfa:	e8 b7 19 00 00       	call   8037b6 <alloc_block_WF>
  801dff:	83 c4 10             	add    $0x10,%esp
  801e02:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e05:	eb 11                	jmp    801e18 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801e07:	83 ec 0c             	sub    $0xc,%esp
  801e0a:	68 f4 42 80 00       	push   $0x8042f4
  801e0f:	e8 10 e7 ff ff       	call   800524 <cprintf>
  801e14:	83 c4 10             	add    $0x10,%esp
		break;
  801e17:	90                   	nop
	}
	return va;
  801e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	53                   	push   %ebx
  801e21:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801e24:	83 ec 0c             	sub    $0xc,%esp
  801e27:	68 14 43 80 00       	push   $0x804314
  801e2c:	e8 f3 e6 ff ff       	call   800524 <cprintf>
  801e31:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801e34:	83 ec 0c             	sub    $0xc,%esp
  801e37:	68 3f 43 80 00       	push   $0x80433f
  801e3c:	e8 e3 e6 ff ff       	call   800524 <cprintf>
  801e41:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801e44:	8b 45 08             	mov    0x8(%ebp),%eax
  801e47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e4a:	eb 37                	jmp    801e83 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801e4c:	83 ec 0c             	sub    $0xc,%esp
  801e4f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e52:	e8 19 ff ff ff       	call   801d70 <is_free_block>
  801e57:	83 c4 10             	add    $0x10,%esp
  801e5a:	0f be d8             	movsbl %al,%ebx
  801e5d:	83 ec 0c             	sub    $0xc,%esp
  801e60:	ff 75 f4             	pushl  -0xc(%ebp)
  801e63:	e8 ef fe ff ff       	call   801d57 <get_block_size>
  801e68:	83 c4 10             	add    $0x10,%esp
  801e6b:	83 ec 04             	sub    $0x4,%esp
  801e6e:	53                   	push   %ebx
  801e6f:	50                   	push   %eax
  801e70:	68 57 43 80 00       	push   $0x804357
  801e75:	e8 aa e6 ff ff       	call   800524 <cprintf>
  801e7a:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801e7d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e87:	74 07                	je     801e90 <print_blocks_list+0x73>
  801e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8c:	8b 00                	mov    (%eax),%eax
  801e8e:	eb 05                	jmp    801e95 <print_blocks_list+0x78>
  801e90:	b8 00 00 00 00       	mov    $0x0,%eax
  801e95:	89 45 10             	mov    %eax,0x10(%ebp)
  801e98:	8b 45 10             	mov    0x10(%ebp),%eax
  801e9b:	85 c0                	test   %eax,%eax
  801e9d:	75 ad                	jne    801e4c <print_blocks_list+0x2f>
  801e9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ea3:	75 a7                	jne    801e4c <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801ea5:	83 ec 0c             	sub    $0xc,%esp
  801ea8:	68 14 43 80 00       	push   $0x804314
  801ead:	e8 72 e6 ff ff       	call   800524 <cprintf>
  801eb2:	83 c4 10             	add    $0x10,%esp

}
  801eb5:	90                   	nop
  801eb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
  801ebe:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec4:	83 e0 01             	and    $0x1,%eax
  801ec7:	85 c0                	test   %eax,%eax
  801ec9:	74 03                	je     801ece <initialize_dynamic_allocator+0x13>
  801ecb:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801ece:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ed2:	0f 84 c7 01 00 00    	je     80209f <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801ed8:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801edf:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801ee2:	8b 55 08             	mov    0x8(%ebp),%edx
  801ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee8:	01 d0                	add    %edx,%eax
  801eea:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801eef:	0f 87 ad 01 00 00    	ja     8020a2 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef8:	85 c0                	test   %eax,%eax
  801efa:	0f 89 a5 01 00 00    	jns    8020a5 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801f00:	8b 55 08             	mov    0x8(%ebp),%edx
  801f03:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f06:	01 d0                	add    %edx,%eax
  801f08:	83 e8 04             	sub    $0x4,%eax
  801f0b:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801f10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801f17:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801f1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f1f:	e9 87 00 00 00       	jmp    801fab <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801f24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f28:	75 14                	jne    801f3e <initialize_dynamic_allocator+0x83>
  801f2a:	83 ec 04             	sub    $0x4,%esp
  801f2d:	68 6f 43 80 00       	push   $0x80436f
  801f32:	6a 79                	push   $0x79
  801f34:	68 8d 43 80 00       	push   $0x80438d
  801f39:	e8 29 e3 ff ff       	call   800267 <_panic>
  801f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f41:	8b 00                	mov    (%eax),%eax
  801f43:	85 c0                	test   %eax,%eax
  801f45:	74 10                	je     801f57 <initialize_dynamic_allocator+0x9c>
  801f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4a:	8b 00                	mov    (%eax),%eax
  801f4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f4f:	8b 52 04             	mov    0x4(%edx),%edx
  801f52:	89 50 04             	mov    %edx,0x4(%eax)
  801f55:	eb 0b                	jmp    801f62 <initialize_dynamic_allocator+0xa7>
  801f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5a:	8b 40 04             	mov    0x4(%eax),%eax
  801f5d:	a3 30 50 80 00       	mov    %eax,0x805030
  801f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f65:	8b 40 04             	mov    0x4(%eax),%eax
  801f68:	85 c0                	test   %eax,%eax
  801f6a:	74 0f                	je     801f7b <initialize_dynamic_allocator+0xc0>
  801f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6f:	8b 40 04             	mov    0x4(%eax),%eax
  801f72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f75:	8b 12                	mov    (%edx),%edx
  801f77:	89 10                	mov    %edx,(%eax)
  801f79:	eb 0a                	jmp    801f85 <initialize_dynamic_allocator+0xca>
  801f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7e:	8b 00                	mov    (%eax),%eax
  801f80:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f98:	a1 38 50 80 00       	mov    0x805038,%eax
  801f9d:	48                   	dec    %eax
  801f9e:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801fa3:	a1 34 50 80 00       	mov    0x805034,%eax
  801fa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801faf:	74 07                	je     801fb8 <initialize_dynamic_allocator+0xfd>
  801fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb4:	8b 00                	mov    (%eax),%eax
  801fb6:	eb 05                	jmp    801fbd <initialize_dynamic_allocator+0x102>
  801fb8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbd:	a3 34 50 80 00       	mov    %eax,0x805034
  801fc2:	a1 34 50 80 00       	mov    0x805034,%eax
  801fc7:	85 c0                	test   %eax,%eax
  801fc9:	0f 85 55 ff ff ff    	jne    801f24 <initialize_dynamic_allocator+0x69>
  801fcf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fd3:	0f 85 4b ff ff ff    	jne    801f24 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801fdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801fe8:	a1 44 50 80 00       	mov    0x805044,%eax
  801fed:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801ff2:	a1 40 50 80 00       	mov    0x805040,%eax
  801ff7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  802000:	83 c0 08             	add    $0x8,%eax
  802003:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	83 c0 04             	add    $0x4,%eax
  80200c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200f:	83 ea 08             	sub    $0x8,%edx
  802012:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802014:	8b 55 0c             	mov    0xc(%ebp),%edx
  802017:	8b 45 08             	mov    0x8(%ebp),%eax
  80201a:	01 d0                	add    %edx,%eax
  80201c:	83 e8 08             	sub    $0x8,%eax
  80201f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802022:	83 ea 08             	sub    $0x8,%edx
  802025:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802027:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80202a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802030:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802033:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80203a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80203e:	75 17                	jne    802057 <initialize_dynamic_allocator+0x19c>
  802040:	83 ec 04             	sub    $0x4,%esp
  802043:	68 a8 43 80 00       	push   $0x8043a8
  802048:	68 90 00 00 00       	push   $0x90
  80204d:	68 8d 43 80 00       	push   $0x80438d
  802052:	e8 10 e2 ff ff       	call   800267 <_panic>
  802057:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80205d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802060:	89 10                	mov    %edx,(%eax)
  802062:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802065:	8b 00                	mov    (%eax),%eax
  802067:	85 c0                	test   %eax,%eax
  802069:	74 0d                	je     802078 <initialize_dynamic_allocator+0x1bd>
  80206b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802070:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802073:	89 50 04             	mov    %edx,0x4(%eax)
  802076:	eb 08                	jmp    802080 <initialize_dynamic_allocator+0x1c5>
  802078:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80207b:	a3 30 50 80 00       	mov    %eax,0x805030
  802080:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802083:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802088:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80208b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802092:	a1 38 50 80 00       	mov    0x805038,%eax
  802097:	40                   	inc    %eax
  802098:	a3 38 50 80 00       	mov    %eax,0x805038
  80209d:	eb 07                	jmp    8020a6 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80209f:	90                   	nop
  8020a0:	eb 04                	jmp    8020a6 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8020a2:	90                   	nop
  8020a3:	eb 01                	jmp    8020a6 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8020a5:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8020ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ae:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	8d 50 fc             	lea    -0x4(%eax),%edx
  8020b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ba:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	83 e8 04             	sub    $0x4,%eax
  8020c2:	8b 00                	mov    (%eax),%eax
  8020c4:	83 e0 fe             	and    $0xfffffffe,%eax
  8020c7:	8d 50 f8             	lea    -0x8(%eax),%edx
  8020ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cd:	01 c2                	add    %eax,%edx
  8020cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d2:	89 02                	mov    %eax,(%edx)
}
  8020d4:	90                   	nop
  8020d5:	5d                   	pop    %ebp
  8020d6:	c3                   	ret    

008020d7 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
  8020da:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e0:	83 e0 01             	and    $0x1,%eax
  8020e3:	85 c0                	test   %eax,%eax
  8020e5:	74 03                	je     8020ea <alloc_block_FF+0x13>
  8020e7:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8020ea:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8020ee:	77 07                	ja     8020f7 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8020f0:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8020f7:	a1 24 50 80 00       	mov    0x805024,%eax
  8020fc:	85 c0                	test   %eax,%eax
  8020fe:	75 73                	jne    802173 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802100:	8b 45 08             	mov    0x8(%ebp),%eax
  802103:	83 c0 10             	add    $0x10,%eax
  802106:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802109:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802110:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802113:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802116:	01 d0                	add    %edx,%eax
  802118:	48                   	dec    %eax
  802119:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80211c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80211f:	ba 00 00 00 00       	mov    $0x0,%edx
  802124:	f7 75 ec             	divl   -0x14(%ebp)
  802127:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80212a:	29 d0                	sub    %edx,%eax
  80212c:	c1 e8 0c             	shr    $0xc,%eax
  80212f:	83 ec 0c             	sub    $0xc,%esp
  802132:	50                   	push   %eax
  802133:	e8 86 f1 ff ff       	call   8012be <sbrk>
  802138:	83 c4 10             	add    $0x10,%esp
  80213b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80213e:	83 ec 0c             	sub    $0xc,%esp
  802141:	6a 00                	push   $0x0
  802143:	e8 76 f1 ff ff       	call   8012be <sbrk>
  802148:	83 c4 10             	add    $0x10,%esp
  80214b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80214e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802151:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802154:	83 ec 08             	sub    $0x8,%esp
  802157:	50                   	push   %eax
  802158:	ff 75 e4             	pushl  -0x1c(%ebp)
  80215b:	e8 5b fd ff ff       	call   801ebb <initialize_dynamic_allocator>
  802160:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802163:	83 ec 0c             	sub    $0xc,%esp
  802166:	68 cb 43 80 00       	push   $0x8043cb
  80216b:	e8 b4 e3 ff ff       	call   800524 <cprintf>
  802170:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802173:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802177:	75 0a                	jne    802183 <alloc_block_FF+0xac>
	        return NULL;
  802179:	b8 00 00 00 00       	mov    $0x0,%eax
  80217e:	e9 0e 04 00 00       	jmp    802591 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802183:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80218a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80218f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802192:	e9 f3 02 00 00       	jmp    80248a <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802197:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219a:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80219d:	83 ec 0c             	sub    $0xc,%esp
  8021a0:	ff 75 bc             	pushl  -0x44(%ebp)
  8021a3:	e8 af fb ff ff       	call   801d57 <get_block_size>
  8021a8:	83 c4 10             	add    $0x10,%esp
  8021ab:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8021ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b1:	83 c0 08             	add    $0x8,%eax
  8021b4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8021b7:	0f 87 c5 02 00 00    	ja     802482 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8021bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c0:	83 c0 18             	add    $0x18,%eax
  8021c3:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8021c6:	0f 87 19 02 00 00    	ja     8023e5 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8021cc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8021cf:	2b 45 08             	sub    0x8(%ebp),%eax
  8021d2:	83 e8 08             	sub    $0x8,%eax
  8021d5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	8d 50 08             	lea    0x8(%eax),%edx
  8021de:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8021e1:	01 d0                	add    %edx,%eax
  8021e3:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	83 c0 08             	add    $0x8,%eax
  8021ec:	83 ec 04             	sub    $0x4,%esp
  8021ef:	6a 01                	push   $0x1
  8021f1:	50                   	push   %eax
  8021f2:	ff 75 bc             	pushl  -0x44(%ebp)
  8021f5:	e8 ae fe ff ff       	call   8020a8 <set_block_data>
  8021fa:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8021fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802200:	8b 40 04             	mov    0x4(%eax),%eax
  802203:	85 c0                	test   %eax,%eax
  802205:	75 68                	jne    80226f <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802207:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80220b:	75 17                	jne    802224 <alloc_block_FF+0x14d>
  80220d:	83 ec 04             	sub    $0x4,%esp
  802210:	68 a8 43 80 00       	push   $0x8043a8
  802215:	68 d7 00 00 00       	push   $0xd7
  80221a:	68 8d 43 80 00       	push   $0x80438d
  80221f:	e8 43 e0 ff ff       	call   800267 <_panic>
  802224:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80222a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80222d:	89 10                	mov    %edx,(%eax)
  80222f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802232:	8b 00                	mov    (%eax),%eax
  802234:	85 c0                	test   %eax,%eax
  802236:	74 0d                	je     802245 <alloc_block_FF+0x16e>
  802238:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80223d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802240:	89 50 04             	mov    %edx,0x4(%eax)
  802243:	eb 08                	jmp    80224d <alloc_block_FF+0x176>
  802245:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802248:	a3 30 50 80 00       	mov    %eax,0x805030
  80224d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802250:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802255:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802258:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80225f:	a1 38 50 80 00       	mov    0x805038,%eax
  802264:	40                   	inc    %eax
  802265:	a3 38 50 80 00       	mov    %eax,0x805038
  80226a:	e9 dc 00 00 00       	jmp    80234b <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80226f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802272:	8b 00                	mov    (%eax),%eax
  802274:	85 c0                	test   %eax,%eax
  802276:	75 65                	jne    8022dd <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802278:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80227c:	75 17                	jne    802295 <alloc_block_FF+0x1be>
  80227e:	83 ec 04             	sub    $0x4,%esp
  802281:	68 dc 43 80 00       	push   $0x8043dc
  802286:	68 db 00 00 00       	push   $0xdb
  80228b:	68 8d 43 80 00       	push   $0x80438d
  802290:	e8 d2 df ff ff       	call   800267 <_panic>
  802295:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80229b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80229e:	89 50 04             	mov    %edx,0x4(%eax)
  8022a1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022a4:	8b 40 04             	mov    0x4(%eax),%eax
  8022a7:	85 c0                	test   %eax,%eax
  8022a9:	74 0c                	je     8022b7 <alloc_block_FF+0x1e0>
  8022ab:	a1 30 50 80 00       	mov    0x805030,%eax
  8022b0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022b3:	89 10                	mov    %edx,(%eax)
  8022b5:	eb 08                	jmp    8022bf <alloc_block_FF+0x1e8>
  8022b7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022ba:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022bf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022c2:	a3 30 50 80 00       	mov    %eax,0x805030
  8022c7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022d0:	a1 38 50 80 00       	mov    0x805038,%eax
  8022d5:	40                   	inc    %eax
  8022d6:	a3 38 50 80 00       	mov    %eax,0x805038
  8022db:	eb 6e                	jmp    80234b <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8022dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e1:	74 06                	je     8022e9 <alloc_block_FF+0x212>
  8022e3:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022e7:	75 17                	jne    802300 <alloc_block_FF+0x229>
  8022e9:	83 ec 04             	sub    $0x4,%esp
  8022ec:	68 00 44 80 00       	push   $0x804400
  8022f1:	68 df 00 00 00       	push   $0xdf
  8022f6:	68 8d 43 80 00       	push   $0x80438d
  8022fb:	e8 67 df ff ff       	call   800267 <_panic>
  802300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802303:	8b 10                	mov    (%eax),%edx
  802305:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802308:	89 10                	mov    %edx,(%eax)
  80230a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80230d:	8b 00                	mov    (%eax),%eax
  80230f:	85 c0                	test   %eax,%eax
  802311:	74 0b                	je     80231e <alloc_block_FF+0x247>
  802313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802316:	8b 00                	mov    (%eax),%eax
  802318:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80231b:	89 50 04             	mov    %edx,0x4(%eax)
  80231e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802321:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802324:	89 10                	mov    %edx,(%eax)
  802326:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802329:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232c:	89 50 04             	mov    %edx,0x4(%eax)
  80232f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802332:	8b 00                	mov    (%eax),%eax
  802334:	85 c0                	test   %eax,%eax
  802336:	75 08                	jne    802340 <alloc_block_FF+0x269>
  802338:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80233b:	a3 30 50 80 00       	mov    %eax,0x805030
  802340:	a1 38 50 80 00       	mov    0x805038,%eax
  802345:	40                   	inc    %eax
  802346:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80234b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80234f:	75 17                	jne    802368 <alloc_block_FF+0x291>
  802351:	83 ec 04             	sub    $0x4,%esp
  802354:	68 6f 43 80 00       	push   $0x80436f
  802359:	68 e1 00 00 00       	push   $0xe1
  80235e:	68 8d 43 80 00       	push   $0x80438d
  802363:	e8 ff de ff ff       	call   800267 <_panic>
  802368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236b:	8b 00                	mov    (%eax),%eax
  80236d:	85 c0                	test   %eax,%eax
  80236f:	74 10                	je     802381 <alloc_block_FF+0x2aa>
  802371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802374:	8b 00                	mov    (%eax),%eax
  802376:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802379:	8b 52 04             	mov    0x4(%edx),%edx
  80237c:	89 50 04             	mov    %edx,0x4(%eax)
  80237f:	eb 0b                	jmp    80238c <alloc_block_FF+0x2b5>
  802381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802384:	8b 40 04             	mov    0x4(%eax),%eax
  802387:	a3 30 50 80 00       	mov    %eax,0x805030
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	8b 40 04             	mov    0x4(%eax),%eax
  802392:	85 c0                	test   %eax,%eax
  802394:	74 0f                	je     8023a5 <alloc_block_FF+0x2ce>
  802396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802399:	8b 40 04             	mov    0x4(%eax),%eax
  80239c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80239f:	8b 12                	mov    (%edx),%edx
  8023a1:	89 10                	mov    %edx,(%eax)
  8023a3:	eb 0a                	jmp    8023af <alloc_block_FF+0x2d8>
  8023a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a8:	8b 00                	mov    (%eax),%eax
  8023aa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023c2:	a1 38 50 80 00       	mov    0x805038,%eax
  8023c7:	48                   	dec    %eax
  8023c8:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8023cd:	83 ec 04             	sub    $0x4,%esp
  8023d0:	6a 00                	push   $0x0
  8023d2:	ff 75 b4             	pushl  -0x4c(%ebp)
  8023d5:	ff 75 b0             	pushl  -0x50(%ebp)
  8023d8:	e8 cb fc ff ff       	call   8020a8 <set_block_data>
  8023dd:	83 c4 10             	add    $0x10,%esp
  8023e0:	e9 95 00 00 00       	jmp    80247a <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8023e5:	83 ec 04             	sub    $0x4,%esp
  8023e8:	6a 01                	push   $0x1
  8023ea:	ff 75 b8             	pushl  -0x48(%ebp)
  8023ed:	ff 75 bc             	pushl  -0x44(%ebp)
  8023f0:	e8 b3 fc ff ff       	call   8020a8 <set_block_data>
  8023f5:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8023f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023fc:	75 17                	jne    802415 <alloc_block_FF+0x33e>
  8023fe:	83 ec 04             	sub    $0x4,%esp
  802401:	68 6f 43 80 00       	push   $0x80436f
  802406:	68 e8 00 00 00       	push   $0xe8
  80240b:	68 8d 43 80 00       	push   $0x80438d
  802410:	e8 52 de ff ff       	call   800267 <_panic>
  802415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802418:	8b 00                	mov    (%eax),%eax
  80241a:	85 c0                	test   %eax,%eax
  80241c:	74 10                	je     80242e <alloc_block_FF+0x357>
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	8b 00                	mov    (%eax),%eax
  802423:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802426:	8b 52 04             	mov    0x4(%edx),%edx
  802429:	89 50 04             	mov    %edx,0x4(%eax)
  80242c:	eb 0b                	jmp    802439 <alloc_block_FF+0x362>
  80242e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802431:	8b 40 04             	mov    0x4(%eax),%eax
  802434:	a3 30 50 80 00       	mov    %eax,0x805030
  802439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243c:	8b 40 04             	mov    0x4(%eax),%eax
  80243f:	85 c0                	test   %eax,%eax
  802441:	74 0f                	je     802452 <alloc_block_FF+0x37b>
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	8b 40 04             	mov    0x4(%eax),%eax
  802449:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80244c:	8b 12                	mov    (%edx),%edx
  80244e:	89 10                	mov    %edx,(%eax)
  802450:	eb 0a                	jmp    80245c <alloc_block_FF+0x385>
  802452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802455:	8b 00                	mov    (%eax),%eax
  802457:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80245c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802468:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80246f:	a1 38 50 80 00       	mov    0x805038,%eax
  802474:	48                   	dec    %eax
  802475:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80247a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80247d:	e9 0f 01 00 00       	jmp    802591 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802482:	a1 34 50 80 00       	mov    0x805034,%eax
  802487:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80248a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80248e:	74 07                	je     802497 <alloc_block_FF+0x3c0>
  802490:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802493:	8b 00                	mov    (%eax),%eax
  802495:	eb 05                	jmp    80249c <alloc_block_FF+0x3c5>
  802497:	b8 00 00 00 00       	mov    $0x0,%eax
  80249c:	a3 34 50 80 00       	mov    %eax,0x805034
  8024a1:	a1 34 50 80 00       	mov    0x805034,%eax
  8024a6:	85 c0                	test   %eax,%eax
  8024a8:	0f 85 e9 fc ff ff    	jne    802197 <alloc_block_FF+0xc0>
  8024ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b2:	0f 85 df fc ff ff    	jne    802197 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8024b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bb:	83 c0 08             	add    $0x8,%eax
  8024be:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8024c1:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8024c8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8024cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024ce:	01 d0                	add    %edx,%eax
  8024d0:	48                   	dec    %eax
  8024d1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8024d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8024dc:	f7 75 d8             	divl   -0x28(%ebp)
  8024df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024e2:	29 d0                	sub    %edx,%eax
  8024e4:	c1 e8 0c             	shr    $0xc,%eax
  8024e7:	83 ec 0c             	sub    $0xc,%esp
  8024ea:	50                   	push   %eax
  8024eb:	e8 ce ed ff ff       	call   8012be <sbrk>
  8024f0:	83 c4 10             	add    $0x10,%esp
  8024f3:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8024f6:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8024fa:	75 0a                	jne    802506 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8024fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802501:	e9 8b 00 00 00       	jmp    802591 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802506:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80250d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802510:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802513:	01 d0                	add    %edx,%eax
  802515:	48                   	dec    %eax
  802516:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802519:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80251c:	ba 00 00 00 00       	mov    $0x0,%edx
  802521:	f7 75 cc             	divl   -0x34(%ebp)
  802524:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802527:	29 d0                	sub    %edx,%eax
  802529:	8d 50 fc             	lea    -0x4(%eax),%edx
  80252c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80252f:	01 d0                	add    %edx,%eax
  802531:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802536:	a1 40 50 80 00       	mov    0x805040,%eax
  80253b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802541:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802548:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80254b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80254e:	01 d0                	add    %edx,%eax
  802550:	48                   	dec    %eax
  802551:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802554:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802557:	ba 00 00 00 00       	mov    $0x0,%edx
  80255c:	f7 75 c4             	divl   -0x3c(%ebp)
  80255f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802562:	29 d0                	sub    %edx,%eax
  802564:	83 ec 04             	sub    $0x4,%esp
  802567:	6a 01                	push   $0x1
  802569:	50                   	push   %eax
  80256a:	ff 75 d0             	pushl  -0x30(%ebp)
  80256d:	e8 36 fb ff ff       	call   8020a8 <set_block_data>
  802572:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802575:	83 ec 0c             	sub    $0xc,%esp
  802578:	ff 75 d0             	pushl  -0x30(%ebp)
  80257b:	e8 1b 0a 00 00       	call   802f9b <free_block>
  802580:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802583:	83 ec 0c             	sub    $0xc,%esp
  802586:	ff 75 08             	pushl  0x8(%ebp)
  802589:	e8 49 fb ff ff       	call   8020d7 <alloc_block_FF>
  80258e:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802591:	c9                   	leave  
  802592:	c3                   	ret    

00802593 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802593:	55                   	push   %ebp
  802594:	89 e5                	mov    %esp,%ebp
  802596:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802599:	8b 45 08             	mov    0x8(%ebp),%eax
  80259c:	83 e0 01             	and    $0x1,%eax
  80259f:	85 c0                	test   %eax,%eax
  8025a1:	74 03                	je     8025a6 <alloc_block_BF+0x13>
  8025a3:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8025a6:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8025aa:	77 07                	ja     8025b3 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8025ac:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8025b3:	a1 24 50 80 00       	mov    0x805024,%eax
  8025b8:	85 c0                	test   %eax,%eax
  8025ba:	75 73                	jne    80262f <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8025bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bf:	83 c0 10             	add    $0x10,%eax
  8025c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8025c5:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8025cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025d2:	01 d0                	add    %edx,%eax
  8025d4:	48                   	dec    %eax
  8025d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8025d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025db:	ba 00 00 00 00       	mov    $0x0,%edx
  8025e0:	f7 75 e0             	divl   -0x20(%ebp)
  8025e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025e6:	29 d0                	sub    %edx,%eax
  8025e8:	c1 e8 0c             	shr    $0xc,%eax
  8025eb:	83 ec 0c             	sub    $0xc,%esp
  8025ee:	50                   	push   %eax
  8025ef:	e8 ca ec ff ff       	call   8012be <sbrk>
  8025f4:	83 c4 10             	add    $0x10,%esp
  8025f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8025fa:	83 ec 0c             	sub    $0xc,%esp
  8025fd:	6a 00                	push   $0x0
  8025ff:	e8 ba ec ff ff       	call   8012be <sbrk>
  802604:	83 c4 10             	add    $0x10,%esp
  802607:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80260a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80260d:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802610:	83 ec 08             	sub    $0x8,%esp
  802613:	50                   	push   %eax
  802614:	ff 75 d8             	pushl  -0x28(%ebp)
  802617:	e8 9f f8 ff ff       	call   801ebb <initialize_dynamic_allocator>
  80261c:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80261f:	83 ec 0c             	sub    $0xc,%esp
  802622:	68 cb 43 80 00       	push   $0x8043cb
  802627:	e8 f8 de ff ff       	call   800524 <cprintf>
  80262c:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80262f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802636:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80263d:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802644:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80264b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802650:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802653:	e9 1d 01 00 00       	jmp    802775 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80265e:	83 ec 0c             	sub    $0xc,%esp
  802661:	ff 75 a8             	pushl  -0x58(%ebp)
  802664:	e8 ee f6 ff ff       	call   801d57 <get_block_size>
  802669:	83 c4 10             	add    $0x10,%esp
  80266c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80266f:	8b 45 08             	mov    0x8(%ebp),%eax
  802672:	83 c0 08             	add    $0x8,%eax
  802675:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802678:	0f 87 ef 00 00 00    	ja     80276d <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80267e:	8b 45 08             	mov    0x8(%ebp),%eax
  802681:	83 c0 18             	add    $0x18,%eax
  802684:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802687:	77 1d                	ja     8026a6 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802689:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80268f:	0f 86 d8 00 00 00    	jbe    80276d <alloc_block_BF+0x1da>
				{
					best_va = va;
  802695:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802698:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80269b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80269e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8026a1:	e9 c7 00 00 00       	jmp    80276d <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8026a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a9:	83 c0 08             	add    $0x8,%eax
  8026ac:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026af:	0f 85 9d 00 00 00    	jne    802752 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8026b5:	83 ec 04             	sub    $0x4,%esp
  8026b8:	6a 01                	push   $0x1
  8026ba:	ff 75 a4             	pushl  -0x5c(%ebp)
  8026bd:	ff 75 a8             	pushl  -0x58(%ebp)
  8026c0:	e8 e3 f9 ff ff       	call   8020a8 <set_block_data>
  8026c5:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8026c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026cc:	75 17                	jne    8026e5 <alloc_block_BF+0x152>
  8026ce:	83 ec 04             	sub    $0x4,%esp
  8026d1:	68 6f 43 80 00       	push   $0x80436f
  8026d6:	68 2c 01 00 00       	push   $0x12c
  8026db:	68 8d 43 80 00       	push   $0x80438d
  8026e0:	e8 82 db ff ff       	call   800267 <_panic>
  8026e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e8:	8b 00                	mov    (%eax),%eax
  8026ea:	85 c0                	test   %eax,%eax
  8026ec:	74 10                	je     8026fe <alloc_block_BF+0x16b>
  8026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f1:	8b 00                	mov    (%eax),%eax
  8026f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f6:	8b 52 04             	mov    0x4(%edx),%edx
  8026f9:	89 50 04             	mov    %edx,0x4(%eax)
  8026fc:	eb 0b                	jmp    802709 <alloc_block_BF+0x176>
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 40 04             	mov    0x4(%eax),%eax
  802704:	a3 30 50 80 00       	mov    %eax,0x805030
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	8b 40 04             	mov    0x4(%eax),%eax
  80270f:	85 c0                	test   %eax,%eax
  802711:	74 0f                	je     802722 <alloc_block_BF+0x18f>
  802713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802716:	8b 40 04             	mov    0x4(%eax),%eax
  802719:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80271c:	8b 12                	mov    (%edx),%edx
  80271e:	89 10                	mov    %edx,(%eax)
  802720:	eb 0a                	jmp    80272c <alloc_block_BF+0x199>
  802722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802725:	8b 00                	mov    (%eax),%eax
  802727:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802738:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80273f:	a1 38 50 80 00       	mov    0x805038,%eax
  802744:	48                   	dec    %eax
  802745:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80274a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80274d:	e9 24 04 00 00       	jmp    802b76 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802752:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802755:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802758:	76 13                	jbe    80276d <alloc_block_BF+0x1da>
					{
						internal = 1;
  80275a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802761:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802764:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802767:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80276a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80276d:	a1 34 50 80 00       	mov    0x805034,%eax
  802772:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802775:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802779:	74 07                	je     802782 <alloc_block_BF+0x1ef>
  80277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277e:	8b 00                	mov    (%eax),%eax
  802780:	eb 05                	jmp    802787 <alloc_block_BF+0x1f4>
  802782:	b8 00 00 00 00       	mov    $0x0,%eax
  802787:	a3 34 50 80 00       	mov    %eax,0x805034
  80278c:	a1 34 50 80 00       	mov    0x805034,%eax
  802791:	85 c0                	test   %eax,%eax
  802793:	0f 85 bf fe ff ff    	jne    802658 <alloc_block_BF+0xc5>
  802799:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279d:	0f 85 b5 fe ff ff    	jne    802658 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8027a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027a7:	0f 84 26 02 00 00    	je     8029d3 <alloc_block_BF+0x440>
  8027ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027b1:	0f 85 1c 02 00 00    	jne    8029d3 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8027b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ba:	2b 45 08             	sub    0x8(%ebp),%eax
  8027bd:	83 e8 08             	sub    $0x8,%eax
  8027c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8027c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c6:	8d 50 08             	lea    0x8(%eax),%edx
  8027c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cc:	01 d0                	add    %edx,%eax
  8027ce:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8027d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d4:	83 c0 08             	add    $0x8,%eax
  8027d7:	83 ec 04             	sub    $0x4,%esp
  8027da:	6a 01                	push   $0x1
  8027dc:	50                   	push   %eax
  8027dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8027e0:	e8 c3 f8 ff ff       	call   8020a8 <set_block_data>
  8027e5:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8027e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027eb:	8b 40 04             	mov    0x4(%eax),%eax
  8027ee:	85 c0                	test   %eax,%eax
  8027f0:	75 68                	jne    80285a <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8027f2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8027f6:	75 17                	jne    80280f <alloc_block_BF+0x27c>
  8027f8:	83 ec 04             	sub    $0x4,%esp
  8027fb:	68 a8 43 80 00       	push   $0x8043a8
  802800:	68 45 01 00 00       	push   $0x145
  802805:	68 8d 43 80 00       	push   $0x80438d
  80280a:	e8 58 da ff ff       	call   800267 <_panic>
  80280f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802815:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802818:	89 10                	mov    %edx,(%eax)
  80281a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80281d:	8b 00                	mov    (%eax),%eax
  80281f:	85 c0                	test   %eax,%eax
  802821:	74 0d                	je     802830 <alloc_block_BF+0x29d>
  802823:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802828:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80282b:	89 50 04             	mov    %edx,0x4(%eax)
  80282e:	eb 08                	jmp    802838 <alloc_block_BF+0x2a5>
  802830:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802833:	a3 30 50 80 00       	mov    %eax,0x805030
  802838:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80283b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802840:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802843:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80284a:	a1 38 50 80 00       	mov    0x805038,%eax
  80284f:	40                   	inc    %eax
  802850:	a3 38 50 80 00       	mov    %eax,0x805038
  802855:	e9 dc 00 00 00       	jmp    802936 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80285a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285d:	8b 00                	mov    (%eax),%eax
  80285f:	85 c0                	test   %eax,%eax
  802861:	75 65                	jne    8028c8 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802863:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802867:	75 17                	jne    802880 <alloc_block_BF+0x2ed>
  802869:	83 ec 04             	sub    $0x4,%esp
  80286c:	68 dc 43 80 00       	push   $0x8043dc
  802871:	68 4a 01 00 00       	push   $0x14a
  802876:	68 8d 43 80 00       	push   $0x80438d
  80287b:	e8 e7 d9 ff ff       	call   800267 <_panic>
  802880:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802886:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802889:	89 50 04             	mov    %edx,0x4(%eax)
  80288c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80288f:	8b 40 04             	mov    0x4(%eax),%eax
  802892:	85 c0                	test   %eax,%eax
  802894:	74 0c                	je     8028a2 <alloc_block_BF+0x30f>
  802896:	a1 30 50 80 00       	mov    0x805030,%eax
  80289b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80289e:	89 10                	mov    %edx,(%eax)
  8028a0:	eb 08                	jmp    8028aa <alloc_block_BF+0x317>
  8028a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028a5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ad:	a3 30 50 80 00       	mov    %eax,0x805030
  8028b2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028bb:	a1 38 50 80 00       	mov    0x805038,%eax
  8028c0:	40                   	inc    %eax
  8028c1:	a3 38 50 80 00       	mov    %eax,0x805038
  8028c6:	eb 6e                	jmp    802936 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8028c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028cc:	74 06                	je     8028d4 <alloc_block_BF+0x341>
  8028ce:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028d2:	75 17                	jne    8028eb <alloc_block_BF+0x358>
  8028d4:	83 ec 04             	sub    $0x4,%esp
  8028d7:	68 00 44 80 00       	push   $0x804400
  8028dc:	68 4f 01 00 00       	push   $0x14f
  8028e1:	68 8d 43 80 00       	push   $0x80438d
  8028e6:	e8 7c d9 ff ff       	call   800267 <_panic>
  8028eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ee:	8b 10                	mov    (%eax),%edx
  8028f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028f3:	89 10                	mov    %edx,(%eax)
  8028f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028f8:	8b 00                	mov    (%eax),%eax
  8028fa:	85 c0                	test   %eax,%eax
  8028fc:	74 0b                	je     802909 <alloc_block_BF+0x376>
  8028fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802901:	8b 00                	mov    (%eax),%eax
  802903:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802906:	89 50 04             	mov    %edx,0x4(%eax)
  802909:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80290f:	89 10                	mov    %edx,(%eax)
  802911:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802914:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802917:	89 50 04             	mov    %edx,0x4(%eax)
  80291a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80291d:	8b 00                	mov    (%eax),%eax
  80291f:	85 c0                	test   %eax,%eax
  802921:	75 08                	jne    80292b <alloc_block_BF+0x398>
  802923:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802926:	a3 30 50 80 00       	mov    %eax,0x805030
  80292b:	a1 38 50 80 00       	mov    0x805038,%eax
  802930:	40                   	inc    %eax
  802931:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802936:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80293a:	75 17                	jne    802953 <alloc_block_BF+0x3c0>
  80293c:	83 ec 04             	sub    $0x4,%esp
  80293f:	68 6f 43 80 00       	push   $0x80436f
  802944:	68 51 01 00 00       	push   $0x151
  802949:	68 8d 43 80 00       	push   $0x80438d
  80294e:	e8 14 d9 ff ff       	call   800267 <_panic>
  802953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802956:	8b 00                	mov    (%eax),%eax
  802958:	85 c0                	test   %eax,%eax
  80295a:	74 10                	je     80296c <alloc_block_BF+0x3d9>
  80295c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295f:	8b 00                	mov    (%eax),%eax
  802961:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802964:	8b 52 04             	mov    0x4(%edx),%edx
  802967:	89 50 04             	mov    %edx,0x4(%eax)
  80296a:	eb 0b                	jmp    802977 <alloc_block_BF+0x3e4>
  80296c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296f:	8b 40 04             	mov    0x4(%eax),%eax
  802972:	a3 30 50 80 00       	mov    %eax,0x805030
  802977:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297a:	8b 40 04             	mov    0x4(%eax),%eax
  80297d:	85 c0                	test   %eax,%eax
  80297f:	74 0f                	je     802990 <alloc_block_BF+0x3fd>
  802981:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802984:	8b 40 04             	mov    0x4(%eax),%eax
  802987:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80298a:	8b 12                	mov    (%edx),%edx
  80298c:	89 10                	mov    %edx,(%eax)
  80298e:	eb 0a                	jmp    80299a <alloc_block_BF+0x407>
  802990:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802993:	8b 00                	mov    (%eax),%eax
  802995:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80299a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ad:	a1 38 50 80 00       	mov    0x805038,%eax
  8029b2:	48                   	dec    %eax
  8029b3:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  8029b8:	83 ec 04             	sub    $0x4,%esp
  8029bb:	6a 00                	push   $0x0
  8029bd:	ff 75 d0             	pushl  -0x30(%ebp)
  8029c0:	ff 75 cc             	pushl  -0x34(%ebp)
  8029c3:	e8 e0 f6 ff ff       	call   8020a8 <set_block_data>
  8029c8:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8029cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ce:	e9 a3 01 00 00       	jmp    802b76 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8029d3:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8029d7:	0f 85 9d 00 00 00    	jne    802a7a <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8029dd:	83 ec 04             	sub    $0x4,%esp
  8029e0:	6a 01                	push   $0x1
  8029e2:	ff 75 ec             	pushl  -0x14(%ebp)
  8029e5:	ff 75 f0             	pushl  -0x10(%ebp)
  8029e8:	e8 bb f6 ff ff       	call   8020a8 <set_block_data>
  8029ed:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8029f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029f4:	75 17                	jne    802a0d <alloc_block_BF+0x47a>
  8029f6:	83 ec 04             	sub    $0x4,%esp
  8029f9:	68 6f 43 80 00       	push   $0x80436f
  8029fe:	68 58 01 00 00       	push   $0x158
  802a03:	68 8d 43 80 00       	push   $0x80438d
  802a08:	e8 5a d8 ff ff       	call   800267 <_panic>
  802a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a10:	8b 00                	mov    (%eax),%eax
  802a12:	85 c0                	test   %eax,%eax
  802a14:	74 10                	je     802a26 <alloc_block_BF+0x493>
  802a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a19:	8b 00                	mov    (%eax),%eax
  802a1b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a1e:	8b 52 04             	mov    0x4(%edx),%edx
  802a21:	89 50 04             	mov    %edx,0x4(%eax)
  802a24:	eb 0b                	jmp    802a31 <alloc_block_BF+0x49e>
  802a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a29:	8b 40 04             	mov    0x4(%eax),%eax
  802a2c:	a3 30 50 80 00       	mov    %eax,0x805030
  802a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a34:	8b 40 04             	mov    0x4(%eax),%eax
  802a37:	85 c0                	test   %eax,%eax
  802a39:	74 0f                	je     802a4a <alloc_block_BF+0x4b7>
  802a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3e:	8b 40 04             	mov    0x4(%eax),%eax
  802a41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a44:	8b 12                	mov    (%edx),%edx
  802a46:	89 10                	mov    %edx,(%eax)
  802a48:	eb 0a                	jmp    802a54 <alloc_block_BF+0x4c1>
  802a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4d:	8b 00                	mov    (%eax),%eax
  802a4f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a67:	a1 38 50 80 00       	mov    0x805038,%eax
  802a6c:	48                   	dec    %eax
  802a6d:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a75:	e9 fc 00 00 00       	jmp    802b76 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7d:	83 c0 08             	add    $0x8,%eax
  802a80:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802a83:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802a8a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a8d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a90:	01 d0                	add    %edx,%eax
  802a92:	48                   	dec    %eax
  802a93:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802a96:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a99:	ba 00 00 00 00       	mov    $0x0,%edx
  802a9e:	f7 75 c4             	divl   -0x3c(%ebp)
  802aa1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802aa4:	29 d0                	sub    %edx,%eax
  802aa6:	c1 e8 0c             	shr    $0xc,%eax
  802aa9:	83 ec 0c             	sub    $0xc,%esp
  802aac:	50                   	push   %eax
  802aad:	e8 0c e8 ff ff       	call   8012be <sbrk>
  802ab2:	83 c4 10             	add    $0x10,%esp
  802ab5:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802ab8:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802abc:	75 0a                	jne    802ac8 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802abe:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac3:	e9 ae 00 00 00       	jmp    802b76 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802ac8:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802acf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ad2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802ad5:	01 d0                	add    %edx,%eax
  802ad7:	48                   	dec    %eax
  802ad8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802adb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ade:	ba 00 00 00 00       	mov    $0x0,%edx
  802ae3:	f7 75 b8             	divl   -0x48(%ebp)
  802ae6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ae9:	29 d0                	sub    %edx,%eax
  802aeb:	8d 50 fc             	lea    -0x4(%eax),%edx
  802aee:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802af1:	01 d0                	add    %edx,%eax
  802af3:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802af8:	a1 40 50 80 00       	mov    0x805040,%eax
  802afd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802b03:	83 ec 0c             	sub    $0xc,%esp
  802b06:	68 34 44 80 00       	push   $0x804434
  802b0b:	e8 14 da ff ff       	call   800524 <cprintf>
  802b10:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802b13:	83 ec 08             	sub    $0x8,%esp
  802b16:	ff 75 bc             	pushl  -0x44(%ebp)
  802b19:	68 39 44 80 00       	push   $0x804439
  802b1e:	e8 01 da ff ff       	call   800524 <cprintf>
  802b23:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802b26:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802b2d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b30:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b33:	01 d0                	add    %edx,%eax
  802b35:	48                   	dec    %eax
  802b36:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802b39:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b3c:	ba 00 00 00 00       	mov    $0x0,%edx
  802b41:	f7 75 b0             	divl   -0x50(%ebp)
  802b44:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b47:	29 d0                	sub    %edx,%eax
  802b49:	83 ec 04             	sub    $0x4,%esp
  802b4c:	6a 01                	push   $0x1
  802b4e:	50                   	push   %eax
  802b4f:	ff 75 bc             	pushl  -0x44(%ebp)
  802b52:	e8 51 f5 ff ff       	call   8020a8 <set_block_data>
  802b57:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802b5a:	83 ec 0c             	sub    $0xc,%esp
  802b5d:	ff 75 bc             	pushl  -0x44(%ebp)
  802b60:	e8 36 04 00 00       	call   802f9b <free_block>
  802b65:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802b68:	83 ec 0c             	sub    $0xc,%esp
  802b6b:	ff 75 08             	pushl  0x8(%ebp)
  802b6e:	e8 20 fa ff ff       	call   802593 <alloc_block_BF>
  802b73:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802b76:	c9                   	leave  
  802b77:	c3                   	ret    

00802b78 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802b78:	55                   	push   %ebp
  802b79:	89 e5                	mov    %esp,%ebp
  802b7b:	53                   	push   %ebx
  802b7c:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802b7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b86:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802b8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b91:	74 1e                	je     802bb1 <merging+0x39>
  802b93:	ff 75 08             	pushl  0x8(%ebp)
  802b96:	e8 bc f1 ff ff       	call   801d57 <get_block_size>
  802b9b:	83 c4 04             	add    $0x4,%esp
  802b9e:	89 c2                	mov    %eax,%edx
  802ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba3:	01 d0                	add    %edx,%eax
  802ba5:	3b 45 10             	cmp    0x10(%ebp),%eax
  802ba8:	75 07                	jne    802bb1 <merging+0x39>
		prev_is_free = 1;
  802baa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802bb1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802bb5:	74 1e                	je     802bd5 <merging+0x5d>
  802bb7:	ff 75 10             	pushl  0x10(%ebp)
  802bba:	e8 98 f1 ff ff       	call   801d57 <get_block_size>
  802bbf:	83 c4 04             	add    $0x4,%esp
  802bc2:	89 c2                	mov    %eax,%edx
  802bc4:	8b 45 10             	mov    0x10(%ebp),%eax
  802bc7:	01 d0                	add    %edx,%eax
  802bc9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802bcc:	75 07                	jne    802bd5 <merging+0x5d>
		next_is_free = 1;
  802bce:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802bd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd9:	0f 84 cc 00 00 00    	je     802cab <merging+0x133>
  802bdf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802be3:	0f 84 c2 00 00 00    	je     802cab <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802be9:	ff 75 08             	pushl  0x8(%ebp)
  802bec:	e8 66 f1 ff ff       	call   801d57 <get_block_size>
  802bf1:	83 c4 04             	add    $0x4,%esp
  802bf4:	89 c3                	mov    %eax,%ebx
  802bf6:	ff 75 10             	pushl  0x10(%ebp)
  802bf9:	e8 59 f1 ff ff       	call   801d57 <get_block_size>
  802bfe:	83 c4 04             	add    $0x4,%esp
  802c01:	01 c3                	add    %eax,%ebx
  802c03:	ff 75 0c             	pushl  0xc(%ebp)
  802c06:	e8 4c f1 ff ff       	call   801d57 <get_block_size>
  802c0b:	83 c4 04             	add    $0x4,%esp
  802c0e:	01 d8                	add    %ebx,%eax
  802c10:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802c13:	6a 00                	push   $0x0
  802c15:	ff 75 ec             	pushl  -0x14(%ebp)
  802c18:	ff 75 08             	pushl  0x8(%ebp)
  802c1b:	e8 88 f4 ff ff       	call   8020a8 <set_block_data>
  802c20:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802c23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c27:	75 17                	jne    802c40 <merging+0xc8>
  802c29:	83 ec 04             	sub    $0x4,%esp
  802c2c:	68 6f 43 80 00       	push   $0x80436f
  802c31:	68 7d 01 00 00       	push   $0x17d
  802c36:	68 8d 43 80 00       	push   $0x80438d
  802c3b:	e8 27 d6 ff ff       	call   800267 <_panic>
  802c40:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c43:	8b 00                	mov    (%eax),%eax
  802c45:	85 c0                	test   %eax,%eax
  802c47:	74 10                	je     802c59 <merging+0xe1>
  802c49:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c4c:	8b 00                	mov    (%eax),%eax
  802c4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c51:	8b 52 04             	mov    0x4(%edx),%edx
  802c54:	89 50 04             	mov    %edx,0x4(%eax)
  802c57:	eb 0b                	jmp    802c64 <merging+0xec>
  802c59:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c5c:	8b 40 04             	mov    0x4(%eax),%eax
  802c5f:	a3 30 50 80 00       	mov    %eax,0x805030
  802c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c67:	8b 40 04             	mov    0x4(%eax),%eax
  802c6a:	85 c0                	test   %eax,%eax
  802c6c:	74 0f                	je     802c7d <merging+0x105>
  802c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c71:	8b 40 04             	mov    0x4(%eax),%eax
  802c74:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c77:	8b 12                	mov    (%edx),%edx
  802c79:	89 10                	mov    %edx,(%eax)
  802c7b:	eb 0a                	jmp    802c87 <merging+0x10f>
  802c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c80:	8b 00                	mov    (%eax),%eax
  802c82:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c87:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c8a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c90:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c93:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c9a:	a1 38 50 80 00       	mov    0x805038,%eax
  802c9f:	48                   	dec    %eax
  802ca0:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802ca5:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ca6:	e9 ea 02 00 00       	jmp    802f95 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802cab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802caf:	74 3b                	je     802cec <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802cb1:	83 ec 0c             	sub    $0xc,%esp
  802cb4:	ff 75 08             	pushl  0x8(%ebp)
  802cb7:	e8 9b f0 ff ff       	call   801d57 <get_block_size>
  802cbc:	83 c4 10             	add    $0x10,%esp
  802cbf:	89 c3                	mov    %eax,%ebx
  802cc1:	83 ec 0c             	sub    $0xc,%esp
  802cc4:	ff 75 10             	pushl  0x10(%ebp)
  802cc7:	e8 8b f0 ff ff       	call   801d57 <get_block_size>
  802ccc:	83 c4 10             	add    $0x10,%esp
  802ccf:	01 d8                	add    %ebx,%eax
  802cd1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802cd4:	83 ec 04             	sub    $0x4,%esp
  802cd7:	6a 00                	push   $0x0
  802cd9:	ff 75 e8             	pushl  -0x18(%ebp)
  802cdc:	ff 75 08             	pushl  0x8(%ebp)
  802cdf:	e8 c4 f3 ff ff       	call   8020a8 <set_block_data>
  802ce4:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ce7:	e9 a9 02 00 00       	jmp    802f95 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802cec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cf0:	0f 84 2d 01 00 00    	je     802e23 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802cf6:	83 ec 0c             	sub    $0xc,%esp
  802cf9:	ff 75 10             	pushl  0x10(%ebp)
  802cfc:	e8 56 f0 ff ff       	call   801d57 <get_block_size>
  802d01:	83 c4 10             	add    $0x10,%esp
  802d04:	89 c3                	mov    %eax,%ebx
  802d06:	83 ec 0c             	sub    $0xc,%esp
  802d09:	ff 75 0c             	pushl  0xc(%ebp)
  802d0c:	e8 46 f0 ff ff       	call   801d57 <get_block_size>
  802d11:	83 c4 10             	add    $0x10,%esp
  802d14:	01 d8                	add    %ebx,%eax
  802d16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802d19:	83 ec 04             	sub    $0x4,%esp
  802d1c:	6a 00                	push   $0x0
  802d1e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d21:	ff 75 10             	pushl  0x10(%ebp)
  802d24:	e8 7f f3 ff ff       	call   8020a8 <set_block_data>
  802d29:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802d2c:	8b 45 10             	mov    0x10(%ebp),%eax
  802d2f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802d32:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d36:	74 06                	je     802d3e <merging+0x1c6>
  802d38:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d3c:	75 17                	jne    802d55 <merging+0x1dd>
  802d3e:	83 ec 04             	sub    $0x4,%esp
  802d41:	68 48 44 80 00       	push   $0x804448
  802d46:	68 8d 01 00 00       	push   $0x18d
  802d4b:	68 8d 43 80 00       	push   $0x80438d
  802d50:	e8 12 d5 ff ff       	call   800267 <_panic>
  802d55:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d58:	8b 50 04             	mov    0x4(%eax),%edx
  802d5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d5e:	89 50 04             	mov    %edx,0x4(%eax)
  802d61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d64:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d67:	89 10                	mov    %edx,(%eax)
  802d69:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d6c:	8b 40 04             	mov    0x4(%eax),%eax
  802d6f:	85 c0                	test   %eax,%eax
  802d71:	74 0d                	je     802d80 <merging+0x208>
  802d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d76:	8b 40 04             	mov    0x4(%eax),%eax
  802d79:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d7c:	89 10                	mov    %edx,(%eax)
  802d7e:	eb 08                	jmp    802d88 <merging+0x210>
  802d80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d83:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d8b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d8e:	89 50 04             	mov    %edx,0x4(%eax)
  802d91:	a1 38 50 80 00       	mov    0x805038,%eax
  802d96:	40                   	inc    %eax
  802d97:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802d9c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802da0:	75 17                	jne    802db9 <merging+0x241>
  802da2:	83 ec 04             	sub    $0x4,%esp
  802da5:	68 6f 43 80 00       	push   $0x80436f
  802daa:	68 8e 01 00 00       	push   $0x18e
  802daf:	68 8d 43 80 00       	push   $0x80438d
  802db4:	e8 ae d4 ff ff       	call   800267 <_panic>
  802db9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dbc:	8b 00                	mov    (%eax),%eax
  802dbe:	85 c0                	test   %eax,%eax
  802dc0:	74 10                	je     802dd2 <merging+0x25a>
  802dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dc5:	8b 00                	mov    (%eax),%eax
  802dc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dca:	8b 52 04             	mov    0x4(%edx),%edx
  802dcd:	89 50 04             	mov    %edx,0x4(%eax)
  802dd0:	eb 0b                	jmp    802ddd <merging+0x265>
  802dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dd5:	8b 40 04             	mov    0x4(%eax),%eax
  802dd8:	a3 30 50 80 00       	mov    %eax,0x805030
  802ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de0:	8b 40 04             	mov    0x4(%eax),%eax
  802de3:	85 c0                	test   %eax,%eax
  802de5:	74 0f                	je     802df6 <merging+0x27e>
  802de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dea:	8b 40 04             	mov    0x4(%eax),%eax
  802ded:	8b 55 0c             	mov    0xc(%ebp),%edx
  802df0:	8b 12                	mov    (%edx),%edx
  802df2:	89 10                	mov    %edx,(%eax)
  802df4:	eb 0a                	jmp    802e00 <merging+0x288>
  802df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df9:	8b 00                	mov    (%eax),%eax
  802dfb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e00:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e09:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e13:	a1 38 50 80 00       	mov    0x805038,%eax
  802e18:	48                   	dec    %eax
  802e19:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e1e:	e9 72 01 00 00       	jmp    802f95 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802e23:	8b 45 10             	mov    0x10(%ebp),%eax
  802e26:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802e29:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e2d:	74 79                	je     802ea8 <merging+0x330>
  802e2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e33:	74 73                	je     802ea8 <merging+0x330>
  802e35:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e39:	74 06                	je     802e41 <merging+0x2c9>
  802e3b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e3f:	75 17                	jne    802e58 <merging+0x2e0>
  802e41:	83 ec 04             	sub    $0x4,%esp
  802e44:	68 00 44 80 00       	push   $0x804400
  802e49:	68 94 01 00 00       	push   $0x194
  802e4e:	68 8d 43 80 00       	push   $0x80438d
  802e53:	e8 0f d4 ff ff       	call   800267 <_panic>
  802e58:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5b:	8b 10                	mov    (%eax),%edx
  802e5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e60:	89 10                	mov    %edx,(%eax)
  802e62:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e65:	8b 00                	mov    (%eax),%eax
  802e67:	85 c0                	test   %eax,%eax
  802e69:	74 0b                	je     802e76 <merging+0x2fe>
  802e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6e:	8b 00                	mov    (%eax),%eax
  802e70:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e73:	89 50 04             	mov    %edx,0x4(%eax)
  802e76:	8b 45 08             	mov    0x8(%ebp),%eax
  802e79:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e7c:	89 10                	mov    %edx,(%eax)
  802e7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e81:	8b 55 08             	mov    0x8(%ebp),%edx
  802e84:	89 50 04             	mov    %edx,0x4(%eax)
  802e87:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e8a:	8b 00                	mov    (%eax),%eax
  802e8c:	85 c0                	test   %eax,%eax
  802e8e:	75 08                	jne    802e98 <merging+0x320>
  802e90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e93:	a3 30 50 80 00       	mov    %eax,0x805030
  802e98:	a1 38 50 80 00       	mov    0x805038,%eax
  802e9d:	40                   	inc    %eax
  802e9e:	a3 38 50 80 00       	mov    %eax,0x805038
  802ea3:	e9 ce 00 00 00       	jmp    802f76 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802ea8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eac:	74 65                	je     802f13 <merging+0x39b>
  802eae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802eb2:	75 17                	jne    802ecb <merging+0x353>
  802eb4:	83 ec 04             	sub    $0x4,%esp
  802eb7:	68 dc 43 80 00       	push   $0x8043dc
  802ebc:	68 95 01 00 00       	push   $0x195
  802ec1:	68 8d 43 80 00       	push   $0x80438d
  802ec6:	e8 9c d3 ff ff       	call   800267 <_panic>
  802ecb:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802ed1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ed4:	89 50 04             	mov    %edx,0x4(%eax)
  802ed7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eda:	8b 40 04             	mov    0x4(%eax),%eax
  802edd:	85 c0                	test   %eax,%eax
  802edf:	74 0c                	je     802eed <merging+0x375>
  802ee1:	a1 30 50 80 00       	mov    0x805030,%eax
  802ee6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ee9:	89 10                	mov    %edx,(%eax)
  802eeb:	eb 08                	jmp    802ef5 <merging+0x37d>
  802eed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ef0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ef5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ef8:	a3 30 50 80 00       	mov    %eax,0x805030
  802efd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f06:	a1 38 50 80 00       	mov    0x805038,%eax
  802f0b:	40                   	inc    %eax
  802f0c:	a3 38 50 80 00       	mov    %eax,0x805038
  802f11:	eb 63                	jmp    802f76 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802f13:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f17:	75 17                	jne    802f30 <merging+0x3b8>
  802f19:	83 ec 04             	sub    $0x4,%esp
  802f1c:	68 a8 43 80 00       	push   $0x8043a8
  802f21:	68 98 01 00 00       	push   $0x198
  802f26:	68 8d 43 80 00       	push   $0x80438d
  802f2b:	e8 37 d3 ff ff       	call   800267 <_panic>
  802f30:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802f36:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f39:	89 10                	mov    %edx,(%eax)
  802f3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f3e:	8b 00                	mov    (%eax),%eax
  802f40:	85 c0                	test   %eax,%eax
  802f42:	74 0d                	je     802f51 <merging+0x3d9>
  802f44:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f49:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f4c:	89 50 04             	mov    %edx,0x4(%eax)
  802f4f:	eb 08                	jmp    802f59 <merging+0x3e1>
  802f51:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f54:	a3 30 50 80 00       	mov    %eax,0x805030
  802f59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f5c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f61:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f6b:	a1 38 50 80 00       	mov    0x805038,%eax
  802f70:	40                   	inc    %eax
  802f71:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802f76:	83 ec 0c             	sub    $0xc,%esp
  802f79:	ff 75 10             	pushl  0x10(%ebp)
  802f7c:	e8 d6 ed ff ff       	call   801d57 <get_block_size>
  802f81:	83 c4 10             	add    $0x10,%esp
  802f84:	83 ec 04             	sub    $0x4,%esp
  802f87:	6a 00                	push   $0x0
  802f89:	50                   	push   %eax
  802f8a:	ff 75 10             	pushl  0x10(%ebp)
  802f8d:	e8 16 f1 ff ff       	call   8020a8 <set_block_data>
  802f92:	83 c4 10             	add    $0x10,%esp
	}
}
  802f95:	90                   	nop
  802f96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f99:	c9                   	leave  
  802f9a:	c3                   	ret    

00802f9b <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802f9b:	55                   	push   %ebp
  802f9c:	89 e5                	mov    %esp,%ebp
  802f9e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802fa1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fa6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802fa9:	a1 30 50 80 00       	mov    0x805030,%eax
  802fae:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fb1:	73 1b                	jae    802fce <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802fb3:	a1 30 50 80 00       	mov    0x805030,%eax
  802fb8:	83 ec 04             	sub    $0x4,%esp
  802fbb:	ff 75 08             	pushl  0x8(%ebp)
  802fbe:	6a 00                	push   $0x0
  802fc0:	50                   	push   %eax
  802fc1:	e8 b2 fb ff ff       	call   802b78 <merging>
  802fc6:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802fc9:	e9 8b 00 00 00       	jmp    803059 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802fce:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fd3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fd6:	76 18                	jbe    802ff0 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802fd8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fdd:	83 ec 04             	sub    $0x4,%esp
  802fe0:	ff 75 08             	pushl  0x8(%ebp)
  802fe3:	50                   	push   %eax
  802fe4:	6a 00                	push   $0x0
  802fe6:	e8 8d fb ff ff       	call   802b78 <merging>
  802feb:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802fee:	eb 69                	jmp    803059 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802ff0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ff5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ff8:	eb 39                	jmp    803033 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffd:	3b 45 08             	cmp    0x8(%ebp),%eax
  803000:	73 29                	jae    80302b <free_block+0x90>
  803002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803005:	8b 00                	mov    (%eax),%eax
  803007:	3b 45 08             	cmp    0x8(%ebp),%eax
  80300a:	76 1f                	jbe    80302b <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80300c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300f:	8b 00                	mov    (%eax),%eax
  803011:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803014:	83 ec 04             	sub    $0x4,%esp
  803017:	ff 75 08             	pushl  0x8(%ebp)
  80301a:	ff 75 f0             	pushl  -0x10(%ebp)
  80301d:	ff 75 f4             	pushl  -0xc(%ebp)
  803020:	e8 53 fb ff ff       	call   802b78 <merging>
  803025:	83 c4 10             	add    $0x10,%esp
			break;
  803028:	90                   	nop
		}
	}
}
  803029:	eb 2e                	jmp    803059 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80302b:	a1 34 50 80 00       	mov    0x805034,%eax
  803030:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803033:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803037:	74 07                	je     803040 <free_block+0xa5>
  803039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303c:	8b 00                	mov    (%eax),%eax
  80303e:	eb 05                	jmp    803045 <free_block+0xaa>
  803040:	b8 00 00 00 00       	mov    $0x0,%eax
  803045:	a3 34 50 80 00       	mov    %eax,0x805034
  80304a:	a1 34 50 80 00       	mov    0x805034,%eax
  80304f:	85 c0                	test   %eax,%eax
  803051:	75 a7                	jne    802ffa <free_block+0x5f>
  803053:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803057:	75 a1                	jne    802ffa <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803059:	90                   	nop
  80305a:	c9                   	leave  
  80305b:	c3                   	ret    

0080305c <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80305c:	55                   	push   %ebp
  80305d:	89 e5                	mov    %esp,%ebp
  80305f:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803062:	ff 75 08             	pushl  0x8(%ebp)
  803065:	e8 ed ec ff ff       	call   801d57 <get_block_size>
  80306a:	83 c4 04             	add    $0x4,%esp
  80306d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803070:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803077:	eb 17                	jmp    803090 <copy_data+0x34>
  803079:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80307c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80307f:	01 c2                	add    %eax,%edx
  803081:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803084:	8b 45 08             	mov    0x8(%ebp),%eax
  803087:	01 c8                	add    %ecx,%eax
  803089:	8a 00                	mov    (%eax),%al
  80308b:	88 02                	mov    %al,(%edx)
  80308d:	ff 45 fc             	incl   -0x4(%ebp)
  803090:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803093:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803096:	72 e1                	jb     803079 <copy_data+0x1d>
}
  803098:	90                   	nop
  803099:	c9                   	leave  
  80309a:	c3                   	ret    

0080309b <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80309b:	55                   	push   %ebp
  80309c:	89 e5                	mov    %esp,%ebp
  80309e:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8030a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030a5:	75 23                	jne    8030ca <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8030a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030ab:	74 13                	je     8030c0 <realloc_block_FF+0x25>
  8030ad:	83 ec 0c             	sub    $0xc,%esp
  8030b0:	ff 75 0c             	pushl  0xc(%ebp)
  8030b3:	e8 1f f0 ff ff       	call   8020d7 <alloc_block_FF>
  8030b8:	83 c4 10             	add    $0x10,%esp
  8030bb:	e9 f4 06 00 00       	jmp    8037b4 <realloc_block_FF+0x719>
		return NULL;
  8030c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c5:	e9 ea 06 00 00       	jmp    8037b4 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8030ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030ce:	75 18                	jne    8030e8 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8030d0:	83 ec 0c             	sub    $0xc,%esp
  8030d3:	ff 75 08             	pushl  0x8(%ebp)
  8030d6:	e8 c0 fe ff ff       	call   802f9b <free_block>
  8030db:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8030de:	b8 00 00 00 00       	mov    $0x0,%eax
  8030e3:	e9 cc 06 00 00       	jmp    8037b4 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8030e8:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8030ec:	77 07                	ja     8030f5 <realloc_block_FF+0x5a>
  8030ee:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8030f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f8:	83 e0 01             	and    $0x1,%eax
  8030fb:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8030fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803101:	83 c0 08             	add    $0x8,%eax
  803104:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803107:	83 ec 0c             	sub    $0xc,%esp
  80310a:	ff 75 08             	pushl  0x8(%ebp)
  80310d:	e8 45 ec ff ff       	call   801d57 <get_block_size>
  803112:	83 c4 10             	add    $0x10,%esp
  803115:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803118:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80311b:	83 e8 08             	sub    $0x8,%eax
  80311e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803121:	8b 45 08             	mov    0x8(%ebp),%eax
  803124:	83 e8 04             	sub    $0x4,%eax
  803127:	8b 00                	mov    (%eax),%eax
  803129:	83 e0 fe             	and    $0xfffffffe,%eax
  80312c:	89 c2                	mov    %eax,%edx
  80312e:	8b 45 08             	mov    0x8(%ebp),%eax
  803131:	01 d0                	add    %edx,%eax
  803133:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803136:	83 ec 0c             	sub    $0xc,%esp
  803139:	ff 75 e4             	pushl  -0x1c(%ebp)
  80313c:	e8 16 ec ff ff       	call   801d57 <get_block_size>
  803141:	83 c4 10             	add    $0x10,%esp
  803144:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803147:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80314a:	83 e8 08             	sub    $0x8,%eax
  80314d:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803150:	8b 45 0c             	mov    0xc(%ebp),%eax
  803153:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803156:	75 08                	jne    803160 <realloc_block_FF+0xc5>
	{
		 return va;
  803158:	8b 45 08             	mov    0x8(%ebp),%eax
  80315b:	e9 54 06 00 00       	jmp    8037b4 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803160:	8b 45 0c             	mov    0xc(%ebp),%eax
  803163:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803166:	0f 83 e5 03 00 00    	jae    803551 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80316c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316f:	2b 45 0c             	sub    0xc(%ebp),%eax
  803172:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803175:	83 ec 0c             	sub    $0xc,%esp
  803178:	ff 75 e4             	pushl  -0x1c(%ebp)
  80317b:	e8 f0 eb ff ff       	call   801d70 <is_free_block>
  803180:	83 c4 10             	add    $0x10,%esp
  803183:	84 c0                	test   %al,%al
  803185:	0f 84 3b 01 00 00    	je     8032c6 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80318b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80318e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803191:	01 d0                	add    %edx,%eax
  803193:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803196:	83 ec 04             	sub    $0x4,%esp
  803199:	6a 01                	push   $0x1
  80319b:	ff 75 f0             	pushl  -0x10(%ebp)
  80319e:	ff 75 08             	pushl  0x8(%ebp)
  8031a1:	e8 02 ef ff ff       	call   8020a8 <set_block_data>
  8031a6:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8031a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ac:	83 e8 04             	sub    $0x4,%eax
  8031af:	8b 00                	mov    (%eax),%eax
  8031b1:	83 e0 fe             	and    $0xfffffffe,%eax
  8031b4:	89 c2                	mov    %eax,%edx
  8031b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b9:	01 d0                	add    %edx,%eax
  8031bb:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8031be:	83 ec 04             	sub    $0x4,%esp
  8031c1:	6a 00                	push   $0x0
  8031c3:	ff 75 cc             	pushl  -0x34(%ebp)
  8031c6:	ff 75 c8             	pushl  -0x38(%ebp)
  8031c9:	e8 da ee ff ff       	call   8020a8 <set_block_data>
  8031ce:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8031d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031d5:	74 06                	je     8031dd <realloc_block_FF+0x142>
  8031d7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8031db:	75 17                	jne    8031f4 <realloc_block_FF+0x159>
  8031dd:	83 ec 04             	sub    $0x4,%esp
  8031e0:	68 00 44 80 00       	push   $0x804400
  8031e5:	68 f6 01 00 00       	push   $0x1f6
  8031ea:	68 8d 43 80 00       	push   $0x80438d
  8031ef:	e8 73 d0 ff ff       	call   800267 <_panic>
  8031f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031f7:	8b 10                	mov    (%eax),%edx
  8031f9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031fc:	89 10                	mov    %edx,(%eax)
  8031fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803201:	8b 00                	mov    (%eax),%eax
  803203:	85 c0                	test   %eax,%eax
  803205:	74 0b                	je     803212 <realloc_block_FF+0x177>
  803207:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80320a:	8b 00                	mov    (%eax),%eax
  80320c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80320f:	89 50 04             	mov    %edx,0x4(%eax)
  803212:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803215:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803218:	89 10                	mov    %edx,(%eax)
  80321a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80321d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803220:	89 50 04             	mov    %edx,0x4(%eax)
  803223:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803226:	8b 00                	mov    (%eax),%eax
  803228:	85 c0                	test   %eax,%eax
  80322a:	75 08                	jne    803234 <realloc_block_FF+0x199>
  80322c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80322f:	a3 30 50 80 00       	mov    %eax,0x805030
  803234:	a1 38 50 80 00       	mov    0x805038,%eax
  803239:	40                   	inc    %eax
  80323a:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80323f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803243:	75 17                	jne    80325c <realloc_block_FF+0x1c1>
  803245:	83 ec 04             	sub    $0x4,%esp
  803248:	68 6f 43 80 00       	push   $0x80436f
  80324d:	68 f7 01 00 00       	push   $0x1f7
  803252:	68 8d 43 80 00       	push   $0x80438d
  803257:	e8 0b d0 ff ff       	call   800267 <_panic>
  80325c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80325f:	8b 00                	mov    (%eax),%eax
  803261:	85 c0                	test   %eax,%eax
  803263:	74 10                	je     803275 <realloc_block_FF+0x1da>
  803265:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803268:	8b 00                	mov    (%eax),%eax
  80326a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80326d:	8b 52 04             	mov    0x4(%edx),%edx
  803270:	89 50 04             	mov    %edx,0x4(%eax)
  803273:	eb 0b                	jmp    803280 <realloc_block_FF+0x1e5>
  803275:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803278:	8b 40 04             	mov    0x4(%eax),%eax
  80327b:	a3 30 50 80 00       	mov    %eax,0x805030
  803280:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803283:	8b 40 04             	mov    0x4(%eax),%eax
  803286:	85 c0                	test   %eax,%eax
  803288:	74 0f                	je     803299 <realloc_block_FF+0x1fe>
  80328a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80328d:	8b 40 04             	mov    0x4(%eax),%eax
  803290:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803293:	8b 12                	mov    (%edx),%edx
  803295:	89 10                	mov    %edx,(%eax)
  803297:	eb 0a                	jmp    8032a3 <realloc_block_FF+0x208>
  803299:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80329c:	8b 00                	mov    (%eax),%eax
  80329e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b6:	a1 38 50 80 00       	mov    0x805038,%eax
  8032bb:	48                   	dec    %eax
  8032bc:	a3 38 50 80 00       	mov    %eax,0x805038
  8032c1:	e9 83 02 00 00       	jmp    803549 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8032c6:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8032ca:	0f 86 69 02 00 00    	jbe    803539 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8032d0:	83 ec 04             	sub    $0x4,%esp
  8032d3:	6a 01                	push   $0x1
  8032d5:	ff 75 f0             	pushl  -0x10(%ebp)
  8032d8:	ff 75 08             	pushl  0x8(%ebp)
  8032db:	e8 c8 ed ff ff       	call   8020a8 <set_block_data>
  8032e0:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8032e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e6:	83 e8 04             	sub    $0x4,%eax
  8032e9:	8b 00                	mov    (%eax),%eax
  8032eb:	83 e0 fe             	and    $0xfffffffe,%eax
  8032ee:	89 c2                	mov    %eax,%edx
  8032f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f3:	01 d0                	add    %edx,%eax
  8032f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8032f8:	a1 38 50 80 00       	mov    0x805038,%eax
  8032fd:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803300:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803304:	75 68                	jne    80336e <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803306:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80330a:	75 17                	jne    803323 <realloc_block_FF+0x288>
  80330c:	83 ec 04             	sub    $0x4,%esp
  80330f:	68 a8 43 80 00       	push   $0x8043a8
  803314:	68 06 02 00 00       	push   $0x206
  803319:	68 8d 43 80 00       	push   $0x80438d
  80331e:	e8 44 cf ff ff       	call   800267 <_panic>
  803323:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803329:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80332c:	89 10                	mov    %edx,(%eax)
  80332e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803331:	8b 00                	mov    (%eax),%eax
  803333:	85 c0                	test   %eax,%eax
  803335:	74 0d                	je     803344 <realloc_block_FF+0x2a9>
  803337:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80333c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80333f:	89 50 04             	mov    %edx,0x4(%eax)
  803342:	eb 08                	jmp    80334c <realloc_block_FF+0x2b1>
  803344:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803347:	a3 30 50 80 00       	mov    %eax,0x805030
  80334c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80334f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803354:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803357:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80335e:	a1 38 50 80 00       	mov    0x805038,%eax
  803363:	40                   	inc    %eax
  803364:	a3 38 50 80 00       	mov    %eax,0x805038
  803369:	e9 b0 01 00 00       	jmp    80351e <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80336e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803373:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803376:	76 68                	jbe    8033e0 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803378:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80337c:	75 17                	jne    803395 <realloc_block_FF+0x2fa>
  80337e:	83 ec 04             	sub    $0x4,%esp
  803381:	68 a8 43 80 00       	push   $0x8043a8
  803386:	68 0b 02 00 00       	push   $0x20b
  80338b:	68 8d 43 80 00       	push   $0x80438d
  803390:	e8 d2 ce ff ff       	call   800267 <_panic>
  803395:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80339b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80339e:	89 10                	mov    %edx,(%eax)
  8033a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033a3:	8b 00                	mov    (%eax),%eax
  8033a5:	85 c0                	test   %eax,%eax
  8033a7:	74 0d                	je     8033b6 <realloc_block_FF+0x31b>
  8033a9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033b1:	89 50 04             	mov    %edx,0x4(%eax)
  8033b4:	eb 08                	jmp    8033be <realloc_block_FF+0x323>
  8033b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033b9:	a3 30 50 80 00       	mov    %eax,0x805030
  8033be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033c1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033d0:	a1 38 50 80 00       	mov    0x805038,%eax
  8033d5:	40                   	inc    %eax
  8033d6:	a3 38 50 80 00       	mov    %eax,0x805038
  8033db:	e9 3e 01 00 00       	jmp    80351e <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8033e0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033e5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8033e8:	73 68                	jae    803452 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8033ea:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033ee:	75 17                	jne    803407 <realloc_block_FF+0x36c>
  8033f0:	83 ec 04             	sub    $0x4,%esp
  8033f3:	68 dc 43 80 00       	push   $0x8043dc
  8033f8:	68 10 02 00 00       	push   $0x210
  8033fd:	68 8d 43 80 00       	push   $0x80438d
  803402:	e8 60 ce ff ff       	call   800267 <_panic>
  803407:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80340d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803410:	89 50 04             	mov    %edx,0x4(%eax)
  803413:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803416:	8b 40 04             	mov    0x4(%eax),%eax
  803419:	85 c0                	test   %eax,%eax
  80341b:	74 0c                	je     803429 <realloc_block_FF+0x38e>
  80341d:	a1 30 50 80 00       	mov    0x805030,%eax
  803422:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803425:	89 10                	mov    %edx,(%eax)
  803427:	eb 08                	jmp    803431 <realloc_block_FF+0x396>
  803429:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80342c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803431:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803434:	a3 30 50 80 00       	mov    %eax,0x805030
  803439:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80343c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803442:	a1 38 50 80 00       	mov    0x805038,%eax
  803447:	40                   	inc    %eax
  803448:	a3 38 50 80 00       	mov    %eax,0x805038
  80344d:	e9 cc 00 00 00       	jmp    80351e <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803452:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803459:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80345e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803461:	e9 8a 00 00 00       	jmp    8034f0 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803469:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80346c:	73 7a                	jae    8034e8 <realloc_block_FF+0x44d>
  80346e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803471:	8b 00                	mov    (%eax),%eax
  803473:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803476:	73 70                	jae    8034e8 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803478:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80347c:	74 06                	je     803484 <realloc_block_FF+0x3e9>
  80347e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803482:	75 17                	jne    80349b <realloc_block_FF+0x400>
  803484:	83 ec 04             	sub    $0x4,%esp
  803487:	68 00 44 80 00       	push   $0x804400
  80348c:	68 1a 02 00 00       	push   $0x21a
  803491:	68 8d 43 80 00       	push   $0x80438d
  803496:	e8 cc cd ff ff       	call   800267 <_panic>
  80349b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349e:	8b 10                	mov    (%eax),%edx
  8034a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034a3:	89 10                	mov    %edx,(%eax)
  8034a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034a8:	8b 00                	mov    (%eax),%eax
  8034aa:	85 c0                	test   %eax,%eax
  8034ac:	74 0b                	je     8034b9 <realloc_block_FF+0x41e>
  8034ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b1:	8b 00                	mov    (%eax),%eax
  8034b3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034b6:	89 50 04             	mov    %edx,0x4(%eax)
  8034b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034bf:	89 10                	mov    %edx,(%eax)
  8034c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034c7:	89 50 04             	mov    %edx,0x4(%eax)
  8034ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034cd:	8b 00                	mov    (%eax),%eax
  8034cf:	85 c0                	test   %eax,%eax
  8034d1:	75 08                	jne    8034db <realloc_block_FF+0x440>
  8034d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d6:	a3 30 50 80 00       	mov    %eax,0x805030
  8034db:	a1 38 50 80 00       	mov    0x805038,%eax
  8034e0:	40                   	inc    %eax
  8034e1:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8034e6:	eb 36                	jmp    80351e <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8034e8:	a1 34 50 80 00       	mov    0x805034,%eax
  8034ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034f4:	74 07                	je     8034fd <realloc_block_FF+0x462>
  8034f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f9:	8b 00                	mov    (%eax),%eax
  8034fb:	eb 05                	jmp    803502 <realloc_block_FF+0x467>
  8034fd:	b8 00 00 00 00       	mov    $0x0,%eax
  803502:	a3 34 50 80 00       	mov    %eax,0x805034
  803507:	a1 34 50 80 00       	mov    0x805034,%eax
  80350c:	85 c0                	test   %eax,%eax
  80350e:	0f 85 52 ff ff ff    	jne    803466 <realloc_block_FF+0x3cb>
  803514:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803518:	0f 85 48 ff ff ff    	jne    803466 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80351e:	83 ec 04             	sub    $0x4,%esp
  803521:	6a 00                	push   $0x0
  803523:	ff 75 d8             	pushl  -0x28(%ebp)
  803526:	ff 75 d4             	pushl  -0x2c(%ebp)
  803529:	e8 7a eb ff ff       	call   8020a8 <set_block_data>
  80352e:	83 c4 10             	add    $0x10,%esp
				return va;
  803531:	8b 45 08             	mov    0x8(%ebp),%eax
  803534:	e9 7b 02 00 00       	jmp    8037b4 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803539:	83 ec 0c             	sub    $0xc,%esp
  80353c:	68 7d 44 80 00       	push   $0x80447d
  803541:	e8 de cf ff ff       	call   800524 <cprintf>
  803546:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803549:	8b 45 08             	mov    0x8(%ebp),%eax
  80354c:	e9 63 02 00 00       	jmp    8037b4 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803551:	8b 45 0c             	mov    0xc(%ebp),%eax
  803554:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803557:	0f 86 4d 02 00 00    	jbe    8037aa <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80355d:	83 ec 0c             	sub    $0xc,%esp
  803560:	ff 75 e4             	pushl  -0x1c(%ebp)
  803563:	e8 08 e8 ff ff       	call   801d70 <is_free_block>
  803568:	83 c4 10             	add    $0x10,%esp
  80356b:	84 c0                	test   %al,%al
  80356d:	0f 84 37 02 00 00    	je     8037aa <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803573:	8b 45 0c             	mov    0xc(%ebp),%eax
  803576:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803579:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80357c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80357f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803582:	76 38                	jbe    8035bc <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803584:	83 ec 0c             	sub    $0xc,%esp
  803587:	ff 75 08             	pushl  0x8(%ebp)
  80358a:	e8 0c fa ff ff       	call   802f9b <free_block>
  80358f:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803592:	83 ec 0c             	sub    $0xc,%esp
  803595:	ff 75 0c             	pushl  0xc(%ebp)
  803598:	e8 3a eb ff ff       	call   8020d7 <alloc_block_FF>
  80359d:	83 c4 10             	add    $0x10,%esp
  8035a0:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8035a3:	83 ec 08             	sub    $0x8,%esp
  8035a6:	ff 75 c0             	pushl  -0x40(%ebp)
  8035a9:	ff 75 08             	pushl  0x8(%ebp)
  8035ac:	e8 ab fa ff ff       	call   80305c <copy_data>
  8035b1:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8035b4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8035b7:	e9 f8 01 00 00       	jmp    8037b4 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8035bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035bf:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8035c2:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8035c5:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8035c9:	0f 87 a0 00 00 00    	ja     80366f <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8035cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035d3:	75 17                	jne    8035ec <realloc_block_FF+0x551>
  8035d5:	83 ec 04             	sub    $0x4,%esp
  8035d8:	68 6f 43 80 00       	push   $0x80436f
  8035dd:	68 38 02 00 00       	push   $0x238
  8035e2:	68 8d 43 80 00       	push   $0x80438d
  8035e7:	e8 7b cc ff ff       	call   800267 <_panic>
  8035ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ef:	8b 00                	mov    (%eax),%eax
  8035f1:	85 c0                	test   %eax,%eax
  8035f3:	74 10                	je     803605 <realloc_block_FF+0x56a>
  8035f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f8:	8b 00                	mov    (%eax),%eax
  8035fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035fd:	8b 52 04             	mov    0x4(%edx),%edx
  803600:	89 50 04             	mov    %edx,0x4(%eax)
  803603:	eb 0b                	jmp    803610 <realloc_block_FF+0x575>
  803605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803608:	8b 40 04             	mov    0x4(%eax),%eax
  80360b:	a3 30 50 80 00       	mov    %eax,0x805030
  803610:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803613:	8b 40 04             	mov    0x4(%eax),%eax
  803616:	85 c0                	test   %eax,%eax
  803618:	74 0f                	je     803629 <realloc_block_FF+0x58e>
  80361a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361d:	8b 40 04             	mov    0x4(%eax),%eax
  803620:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803623:	8b 12                	mov    (%edx),%edx
  803625:	89 10                	mov    %edx,(%eax)
  803627:	eb 0a                	jmp    803633 <realloc_block_FF+0x598>
  803629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80362c:	8b 00                	mov    (%eax),%eax
  80362e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803636:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80363c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80363f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803646:	a1 38 50 80 00       	mov    0x805038,%eax
  80364b:	48                   	dec    %eax
  80364c:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803651:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803654:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803657:	01 d0                	add    %edx,%eax
  803659:	83 ec 04             	sub    $0x4,%esp
  80365c:	6a 01                	push   $0x1
  80365e:	50                   	push   %eax
  80365f:	ff 75 08             	pushl  0x8(%ebp)
  803662:	e8 41 ea ff ff       	call   8020a8 <set_block_data>
  803667:	83 c4 10             	add    $0x10,%esp
  80366a:	e9 36 01 00 00       	jmp    8037a5 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80366f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803672:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803675:	01 d0                	add    %edx,%eax
  803677:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80367a:	83 ec 04             	sub    $0x4,%esp
  80367d:	6a 01                	push   $0x1
  80367f:	ff 75 f0             	pushl  -0x10(%ebp)
  803682:	ff 75 08             	pushl  0x8(%ebp)
  803685:	e8 1e ea ff ff       	call   8020a8 <set_block_data>
  80368a:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80368d:	8b 45 08             	mov    0x8(%ebp),%eax
  803690:	83 e8 04             	sub    $0x4,%eax
  803693:	8b 00                	mov    (%eax),%eax
  803695:	83 e0 fe             	and    $0xfffffffe,%eax
  803698:	89 c2                	mov    %eax,%edx
  80369a:	8b 45 08             	mov    0x8(%ebp),%eax
  80369d:	01 d0                	add    %edx,%eax
  80369f:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8036a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036a6:	74 06                	je     8036ae <realloc_block_FF+0x613>
  8036a8:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8036ac:	75 17                	jne    8036c5 <realloc_block_FF+0x62a>
  8036ae:	83 ec 04             	sub    $0x4,%esp
  8036b1:	68 00 44 80 00       	push   $0x804400
  8036b6:	68 44 02 00 00       	push   $0x244
  8036bb:	68 8d 43 80 00       	push   $0x80438d
  8036c0:	e8 a2 cb ff ff       	call   800267 <_panic>
  8036c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c8:	8b 10                	mov    (%eax),%edx
  8036ca:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036cd:	89 10                	mov    %edx,(%eax)
  8036cf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036d2:	8b 00                	mov    (%eax),%eax
  8036d4:	85 c0                	test   %eax,%eax
  8036d6:	74 0b                	je     8036e3 <realloc_block_FF+0x648>
  8036d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036db:	8b 00                	mov    (%eax),%eax
  8036dd:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8036e0:	89 50 04             	mov    %edx,0x4(%eax)
  8036e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e6:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8036e9:	89 10                	mov    %edx,(%eax)
  8036eb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036f1:	89 50 04             	mov    %edx,0x4(%eax)
  8036f4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036f7:	8b 00                	mov    (%eax),%eax
  8036f9:	85 c0                	test   %eax,%eax
  8036fb:	75 08                	jne    803705 <realloc_block_FF+0x66a>
  8036fd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803700:	a3 30 50 80 00       	mov    %eax,0x805030
  803705:	a1 38 50 80 00       	mov    0x805038,%eax
  80370a:	40                   	inc    %eax
  80370b:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803710:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803714:	75 17                	jne    80372d <realloc_block_FF+0x692>
  803716:	83 ec 04             	sub    $0x4,%esp
  803719:	68 6f 43 80 00       	push   $0x80436f
  80371e:	68 45 02 00 00       	push   $0x245
  803723:	68 8d 43 80 00       	push   $0x80438d
  803728:	e8 3a cb ff ff       	call   800267 <_panic>
  80372d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803730:	8b 00                	mov    (%eax),%eax
  803732:	85 c0                	test   %eax,%eax
  803734:	74 10                	je     803746 <realloc_block_FF+0x6ab>
  803736:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803739:	8b 00                	mov    (%eax),%eax
  80373b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80373e:	8b 52 04             	mov    0x4(%edx),%edx
  803741:	89 50 04             	mov    %edx,0x4(%eax)
  803744:	eb 0b                	jmp    803751 <realloc_block_FF+0x6b6>
  803746:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803749:	8b 40 04             	mov    0x4(%eax),%eax
  80374c:	a3 30 50 80 00       	mov    %eax,0x805030
  803751:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803754:	8b 40 04             	mov    0x4(%eax),%eax
  803757:	85 c0                	test   %eax,%eax
  803759:	74 0f                	je     80376a <realloc_block_FF+0x6cf>
  80375b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80375e:	8b 40 04             	mov    0x4(%eax),%eax
  803761:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803764:	8b 12                	mov    (%edx),%edx
  803766:	89 10                	mov    %edx,(%eax)
  803768:	eb 0a                	jmp    803774 <realloc_block_FF+0x6d9>
  80376a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80376d:	8b 00                	mov    (%eax),%eax
  80376f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803777:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80377d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803780:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803787:	a1 38 50 80 00       	mov    0x805038,%eax
  80378c:	48                   	dec    %eax
  80378d:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803792:	83 ec 04             	sub    $0x4,%esp
  803795:	6a 00                	push   $0x0
  803797:	ff 75 bc             	pushl  -0x44(%ebp)
  80379a:	ff 75 b8             	pushl  -0x48(%ebp)
  80379d:	e8 06 e9 ff ff       	call   8020a8 <set_block_data>
  8037a2:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8037a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a8:	eb 0a                	jmp    8037b4 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8037aa:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8037b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8037b4:	c9                   	leave  
  8037b5:	c3                   	ret    

008037b6 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8037b6:	55                   	push   %ebp
  8037b7:	89 e5                	mov    %esp,%ebp
  8037b9:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8037bc:	83 ec 04             	sub    $0x4,%esp
  8037bf:	68 84 44 80 00       	push   $0x804484
  8037c4:	68 58 02 00 00       	push   $0x258
  8037c9:	68 8d 43 80 00       	push   $0x80438d
  8037ce:	e8 94 ca ff ff       	call   800267 <_panic>

008037d3 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8037d3:	55                   	push   %ebp
  8037d4:	89 e5                	mov    %esp,%ebp
  8037d6:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8037d9:	83 ec 04             	sub    $0x4,%esp
  8037dc:	68 ac 44 80 00       	push   $0x8044ac
  8037e1:	68 61 02 00 00       	push   $0x261
  8037e6:	68 8d 43 80 00       	push   $0x80438d
  8037eb:	e8 77 ca ff ff       	call   800267 <_panic>

008037f0 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8037f0:	55                   	push   %ebp
  8037f1:	89 e5                	mov    %esp,%ebp
  8037f3:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8037f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8037f9:	89 d0                	mov    %edx,%eax
  8037fb:	c1 e0 02             	shl    $0x2,%eax
  8037fe:	01 d0                	add    %edx,%eax
  803800:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803807:	01 d0                	add    %edx,%eax
  803809:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803810:	01 d0                	add    %edx,%eax
  803812:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803819:	01 d0                	add    %edx,%eax
  80381b:	c1 e0 04             	shl    $0x4,%eax
  80381e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803821:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803828:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80382b:	83 ec 0c             	sub    $0xc,%esp
  80382e:	50                   	push   %eax
  80382f:	e8 2f e2 ff ff       	call   801a63 <sys_get_virtual_time>
  803834:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803837:	eb 41                	jmp    80387a <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803839:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80383c:	83 ec 0c             	sub    $0xc,%esp
  80383f:	50                   	push   %eax
  803840:	e8 1e e2 ff ff       	call   801a63 <sys_get_virtual_time>
  803845:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803848:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80384b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384e:	29 c2                	sub    %eax,%edx
  803850:	89 d0                	mov    %edx,%eax
  803852:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803855:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803858:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80385b:	89 d1                	mov    %edx,%ecx
  80385d:	29 c1                	sub    %eax,%ecx
  80385f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803862:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803865:	39 c2                	cmp    %eax,%edx
  803867:	0f 97 c0             	seta   %al
  80386a:	0f b6 c0             	movzbl %al,%eax
  80386d:	29 c1                	sub    %eax,%ecx
  80386f:	89 c8                	mov    %ecx,%eax
  803871:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803874:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803877:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80387a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803880:	72 b7                	jb     803839 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803882:	90                   	nop
  803883:	c9                   	leave  
  803884:	c3                   	ret    

00803885 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803885:	55                   	push   %ebp
  803886:	89 e5                	mov    %esp,%ebp
  803888:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80388b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803892:	eb 03                	jmp    803897 <busy_wait+0x12>
  803894:	ff 45 fc             	incl   -0x4(%ebp)
  803897:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80389a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80389d:	72 f5                	jb     803894 <busy_wait+0xf>
	return i;
  80389f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8038a2:	c9                   	leave  
  8038a3:	c3                   	ret    

008038a4 <__udivdi3>:
  8038a4:	55                   	push   %ebp
  8038a5:	57                   	push   %edi
  8038a6:	56                   	push   %esi
  8038a7:	53                   	push   %ebx
  8038a8:	83 ec 1c             	sub    $0x1c,%esp
  8038ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8038af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8038b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038bb:	89 ca                	mov    %ecx,%edx
  8038bd:	89 f8                	mov    %edi,%eax
  8038bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8038c3:	85 f6                	test   %esi,%esi
  8038c5:	75 2d                	jne    8038f4 <__udivdi3+0x50>
  8038c7:	39 cf                	cmp    %ecx,%edi
  8038c9:	77 65                	ja     803930 <__udivdi3+0x8c>
  8038cb:	89 fd                	mov    %edi,%ebp
  8038cd:	85 ff                	test   %edi,%edi
  8038cf:	75 0b                	jne    8038dc <__udivdi3+0x38>
  8038d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8038d6:	31 d2                	xor    %edx,%edx
  8038d8:	f7 f7                	div    %edi
  8038da:	89 c5                	mov    %eax,%ebp
  8038dc:	31 d2                	xor    %edx,%edx
  8038de:	89 c8                	mov    %ecx,%eax
  8038e0:	f7 f5                	div    %ebp
  8038e2:	89 c1                	mov    %eax,%ecx
  8038e4:	89 d8                	mov    %ebx,%eax
  8038e6:	f7 f5                	div    %ebp
  8038e8:	89 cf                	mov    %ecx,%edi
  8038ea:	89 fa                	mov    %edi,%edx
  8038ec:	83 c4 1c             	add    $0x1c,%esp
  8038ef:	5b                   	pop    %ebx
  8038f0:	5e                   	pop    %esi
  8038f1:	5f                   	pop    %edi
  8038f2:	5d                   	pop    %ebp
  8038f3:	c3                   	ret    
  8038f4:	39 ce                	cmp    %ecx,%esi
  8038f6:	77 28                	ja     803920 <__udivdi3+0x7c>
  8038f8:	0f bd fe             	bsr    %esi,%edi
  8038fb:	83 f7 1f             	xor    $0x1f,%edi
  8038fe:	75 40                	jne    803940 <__udivdi3+0x9c>
  803900:	39 ce                	cmp    %ecx,%esi
  803902:	72 0a                	jb     80390e <__udivdi3+0x6a>
  803904:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803908:	0f 87 9e 00 00 00    	ja     8039ac <__udivdi3+0x108>
  80390e:	b8 01 00 00 00       	mov    $0x1,%eax
  803913:	89 fa                	mov    %edi,%edx
  803915:	83 c4 1c             	add    $0x1c,%esp
  803918:	5b                   	pop    %ebx
  803919:	5e                   	pop    %esi
  80391a:	5f                   	pop    %edi
  80391b:	5d                   	pop    %ebp
  80391c:	c3                   	ret    
  80391d:	8d 76 00             	lea    0x0(%esi),%esi
  803920:	31 ff                	xor    %edi,%edi
  803922:	31 c0                	xor    %eax,%eax
  803924:	89 fa                	mov    %edi,%edx
  803926:	83 c4 1c             	add    $0x1c,%esp
  803929:	5b                   	pop    %ebx
  80392a:	5e                   	pop    %esi
  80392b:	5f                   	pop    %edi
  80392c:	5d                   	pop    %ebp
  80392d:	c3                   	ret    
  80392e:	66 90                	xchg   %ax,%ax
  803930:	89 d8                	mov    %ebx,%eax
  803932:	f7 f7                	div    %edi
  803934:	31 ff                	xor    %edi,%edi
  803936:	89 fa                	mov    %edi,%edx
  803938:	83 c4 1c             	add    $0x1c,%esp
  80393b:	5b                   	pop    %ebx
  80393c:	5e                   	pop    %esi
  80393d:	5f                   	pop    %edi
  80393e:	5d                   	pop    %ebp
  80393f:	c3                   	ret    
  803940:	bd 20 00 00 00       	mov    $0x20,%ebp
  803945:	89 eb                	mov    %ebp,%ebx
  803947:	29 fb                	sub    %edi,%ebx
  803949:	89 f9                	mov    %edi,%ecx
  80394b:	d3 e6                	shl    %cl,%esi
  80394d:	89 c5                	mov    %eax,%ebp
  80394f:	88 d9                	mov    %bl,%cl
  803951:	d3 ed                	shr    %cl,%ebp
  803953:	89 e9                	mov    %ebp,%ecx
  803955:	09 f1                	or     %esi,%ecx
  803957:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80395b:	89 f9                	mov    %edi,%ecx
  80395d:	d3 e0                	shl    %cl,%eax
  80395f:	89 c5                	mov    %eax,%ebp
  803961:	89 d6                	mov    %edx,%esi
  803963:	88 d9                	mov    %bl,%cl
  803965:	d3 ee                	shr    %cl,%esi
  803967:	89 f9                	mov    %edi,%ecx
  803969:	d3 e2                	shl    %cl,%edx
  80396b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80396f:	88 d9                	mov    %bl,%cl
  803971:	d3 e8                	shr    %cl,%eax
  803973:	09 c2                	or     %eax,%edx
  803975:	89 d0                	mov    %edx,%eax
  803977:	89 f2                	mov    %esi,%edx
  803979:	f7 74 24 0c          	divl   0xc(%esp)
  80397d:	89 d6                	mov    %edx,%esi
  80397f:	89 c3                	mov    %eax,%ebx
  803981:	f7 e5                	mul    %ebp
  803983:	39 d6                	cmp    %edx,%esi
  803985:	72 19                	jb     8039a0 <__udivdi3+0xfc>
  803987:	74 0b                	je     803994 <__udivdi3+0xf0>
  803989:	89 d8                	mov    %ebx,%eax
  80398b:	31 ff                	xor    %edi,%edi
  80398d:	e9 58 ff ff ff       	jmp    8038ea <__udivdi3+0x46>
  803992:	66 90                	xchg   %ax,%ax
  803994:	8b 54 24 08          	mov    0x8(%esp),%edx
  803998:	89 f9                	mov    %edi,%ecx
  80399a:	d3 e2                	shl    %cl,%edx
  80399c:	39 c2                	cmp    %eax,%edx
  80399e:	73 e9                	jae    803989 <__udivdi3+0xe5>
  8039a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8039a3:	31 ff                	xor    %edi,%edi
  8039a5:	e9 40 ff ff ff       	jmp    8038ea <__udivdi3+0x46>
  8039aa:	66 90                	xchg   %ax,%ax
  8039ac:	31 c0                	xor    %eax,%eax
  8039ae:	e9 37 ff ff ff       	jmp    8038ea <__udivdi3+0x46>
  8039b3:	90                   	nop

008039b4 <__umoddi3>:
  8039b4:	55                   	push   %ebp
  8039b5:	57                   	push   %edi
  8039b6:	56                   	push   %esi
  8039b7:	53                   	push   %ebx
  8039b8:	83 ec 1c             	sub    $0x1c,%esp
  8039bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8039bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8039c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039d3:	89 f3                	mov    %esi,%ebx
  8039d5:	89 fa                	mov    %edi,%edx
  8039d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039db:	89 34 24             	mov    %esi,(%esp)
  8039de:	85 c0                	test   %eax,%eax
  8039e0:	75 1a                	jne    8039fc <__umoddi3+0x48>
  8039e2:	39 f7                	cmp    %esi,%edi
  8039e4:	0f 86 a2 00 00 00    	jbe    803a8c <__umoddi3+0xd8>
  8039ea:	89 c8                	mov    %ecx,%eax
  8039ec:	89 f2                	mov    %esi,%edx
  8039ee:	f7 f7                	div    %edi
  8039f0:	89 d0                	mov    %edx,%eax
  8039f2:	31 d2                	xor    %edx,%edx
  8039f4:	83 c4 1c             	add    $0x1c,%esp
  8039f7:	5b                   	pop    %ebx
  8039f8:	5e                   	pop    %esi
  8039f9:	5f                   	pop    %edi
  8039fa:	5d                   	pop    %ebp
  8039fb:	c3                   	ret    
  8039fc:	39 f0                	cmp    %esi,%eax
  8039fe:	0f 87 ac 00 00 00    	ja     803ab0 <__umoddi3+0xfc>
  803a04:	0f bd e8             	bsr    %eax,%ebp
  803a07:	83 f5 1f             	xor    $0x1f,%ebp
  803a0a:	0f 84 ac 00 00 00    	je     803abc <__umoddi3+0x108>
  803a10:	bf 20 00 00 00       	mov    $0x20,%edi
  803a15:	29 ef                	sub    %ebp,%edi
  803a17:	89 fe                	mov    %edi,%esi
  803a19:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a1d:	89 e9                	mov    %ebp,%ecx
  803a1f:	d3 e0                	shl    %cl,%eax
  803a21:	89 d7                	mov    %edx,%edi
  803a23:	89 f1                	mov    %esi,%ecx
  803a25:	d3 ef                	shr    %cl,%edi
  803a27:	09 c7                	or     %eax,%edi
  803a29:	89 e9                	mov    %ebp,%ecx
  803a2b:	d3 e2                	shl    %cl,%edx
  803a2d:	89 14 24             	mov    %edx,(%esp)
  803a30:	89 d8                	mov    %ebx,%eax
  803a32:	d3 e0                	shl    %cl,%eax
  803a34:	89 c2                	mov    %eax,%edx
  803a36:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a3a:	d3 e0                	shl    %cl,%eax
  803a3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a40:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a44:	89 f1                	mov    %esi,%ecx
  803a46:	d3 e8                	shr    %cl,%eax
  803a48:	09 d0                	or     %edx,%eax
  803a4a:	d3 eb                	shr    %cl,%ebx
  803a4c:	89 da                	mov    %ebx,%edx
  803a4e:	f7 f7                	div    %edi
  803a50:	89 d3                	mov    %edx,%ebx
  803a52:	f7 24 24             	mull   (%esp)
  803a55:	89 c6                	mov    %eax,%esi
  803a57:	89 d1                	mov    %edx,%ecx
  803a59:	39 d3                	cmp    %edx,%ebx
  803a5b:	0f 82 87 00 00 00    	jb     803ae8 <__umoddi3+0x134>
  803a61:	0f 84 91 00 00 00    	je     803af8 <__umoddi3+0x144>
  803a67:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a6b:	29 f2                	sub    %esi,%edx
  803a6d:	19 cb                	sbb    %ecx,%ebx
  803a6f:	89 d8                	mov    %ebx,%eax
  803a71:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a75:	d3 e0                	shl    %cl,%eax
  803a77:	89 e9                	mov    %ebp,%ecx
  803a79:	d3 ea                	shr    %cl,%edx
  803a7b:	09 d0                	or     %edx,%eax
  803a7d:	89 e9                	mov    %ebp,%ecx
  803a7f:	d3 eb                	shr    %cl,%ebx
  803a81:	89 da                	mov    %ebx,%edx
  803a83:	83 c4 1c             	add    $0x1c,%esp
  803a86:	5b                   	pop    %ebx
  803a87:	5e                   	pop    %esi
  803a88:	5f                   	pop    %edi
  803a89:	5d                   	pop    %ebp
  803a8a:	c3                   	ret    
  803a8b:	90                   	nop
  803a8c:	89 fd                	mov    %edi,%ebp
  803a8e:	85 ff                	test   %edi,%edi
  803a90:	75 0b                	jne    803a9d <__umoddi3+0xe9>
  803a92:	b8 01 00 00 00       	mov    $0x1,%eax
  803a97:	31 d2                	xor    %edx,%edx
  803a99:	f7 f7                	div    %edi
  803a9b:	89 c5                	mov    %eax,%ebp
  803a9d:	89 f0                	mov    %esi,%eax
  803a9f:	31 d2                	xor    %edx,%edx
  803aa1:	f7 f5                	div    %ebp
  803aa3:	89 c8                	mov    %ecx,%eax
  803aa5:	f7 f5                	div    %ebp
  803aa7:	89 d0                	mov    %edx,%eax
  803aa9:	e9 44 ff ff ff       	jmp    8039f2 <__umoddi3+0x3e>
  803aae:	66 90                	xchg   %ax,%ax
  803ab0:	89 c8                	mov    %ecx,%eax
  803ab2:	89 f2                	mov    %esi,%edx
  803ab4:	83 c4 1c             	add    $0x1c,%esp
  803ab7:	5b                   	pop    %ebx
  803ab8:	5e                   	pop    %esi
  803ab9:	5f                   	pop    %edi
  803aba:	5d                   	pop    %ebp
  803abb:	c3                   	ret    
  803abc:	3b 04 24             	cmp    (%esp),%eax
  803abf:	72 06                	jb     803ac7 <__umoddi3+0x113>
  803ac1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ac5:	77 0f                	ja     803ad6 <__umoddi3+0x122>
  803ac7:	89 f2                	mov    %esi,%edx
  803ac9:	29 f9                	sub    %edi,%ecx
  803acb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803acf:	89 14 24             	mov    %edx,(%esp)
  803ad2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ad6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ada:	8b 14 24             	mov    (%esp),%edx
  803add:	83 c4 1c             	add    $0x1c,%esp
  803ae0:	5b                   	pop    %ebx
  803ae1:	5e                   	pop    %esi
  803ae2:	5f                   	pop    %edi
  803ae3:	5d                   	pop    %ebp
  803ae4:	c3                   	ret    
  803ae5:	8d 76 00             	lea    0x0(%esi),%esi
  803ae8:	2b 04 24             	sub    (%esp),%eax
  803aeb:	19 fa                	sbb    %edi,%edx
  803aed:	89 d1                	mov    %edx,%ecx
  803aef:	89 c6                	mov    %eax,%esi
  803af1:	e9 71 ff ff ff       	jmp    803a67 <__umoddi3+0xb3>
  803af6:	66 90                	xchg   %ax,%ax
  803af8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803afc:	72 ea                	jb     803ae8 <__umoddi3+0x134>
  803afe:	89 d9                	mov    %ebx,%ecx
  803b00:	e9 62 ff ff ff       	jmp    803a67 <__umoddi3+0xb3>
