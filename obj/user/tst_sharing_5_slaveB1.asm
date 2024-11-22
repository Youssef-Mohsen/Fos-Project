
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
  80005b:	68 80 3b 80 00       	push   $0x803b80
  800060:	6a 0c                	push   $0xc
  800062:	68 9c 3b 80 00       	push   $0x803b9c
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
  800073:	e8 20 1a 00 00       	call   801a98 <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 b9 3b 80 00       	push   $0x803bb9
  800080:	50                   	push   %eax
  800081:	e8 fa 15 00 00       	call   801680 <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 bc 3b 80 00       	push   $0x803bbc
  800094:	e8 8b 04 00 00       	call   800524 <cprintf>
  800099:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got x
	inctst();
  80009c:	e8 1c 1b 00 00       	call   801bbd <inctst>
	cprintf("Slave B1 please be patient ...\n");
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	68 e4 3b 80 00       	push   $0x803be4
  8000a9:	e8 76 04 00 00       	call   800524 <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(6000);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 70 17 00 00       	push   $0x1770
  8000b9:	e8 9a 37 00 00       	call   803858 <env_sleep>
  8000be:	83 c4 10             	add    $0x10,%esp
	while (gettst()!=2) ;// panic("test failed");
  8000c1:	90                   	nop
  8000c2:	e8 10 1b 00 00       	call   801bd7 <gettst>
  8000c7:	83 f8 02             	cmp    $0x2,%eax
  8000ca:	75 f6                	jne    8000c2 <_main+0x8a>

	freeFrames = sys_calculate_free_frames() ;
  8000cc:	e8 e5 17 00 00       	call   8018b6 <sys_calculate_free_frames>
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	sfree(x);
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000da:	e8 26 16 00 00       	call   801705 <sfree>
  8000df:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 04 3c 80 00       	push   $0x803c04
  8000ea:	e8 35 04 00 00       	call   800524 <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
	expected = 1+1; /*1page+1table*/
  8000f2:	c7 45 e8 02 00 00 00 	movl   $0x2,-0x18(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  8000f9:	e8 b8 17 00 00       	call   8018b6 <sys_calculate_free_frames>
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800103:	29 c2                	sub    %eax,%edx
  800105:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800108:	39 c2                	cmp    %eax,%edx
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 1c 3c 80 00       	push   $0x803c1c
  800114:	6a 26                	push   $0x26
  800116:	68 9c 3b 80 00       	push   $0x803b9c
  80011b:	e8 47 01 00 00       	call   800267 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800120:	e8 98 1a 00 00       	call   801bbd <inctst>
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
  80012e:	e8 4c 19 00 00       	call   801a7f <sys_getenvindex>
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
  80019c:	e8 62 16 00 00       	call   801803 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001a1:	83 ec 0c             	sub    $0xc,%esp
  8001a4:	68 dc 3c 80 00       	push   $0x803cdc
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
  8001cc:	68 04 3d 80 00       	push   $0x803d04
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
  8001fd:	68 2c 3d 80 00       	push   $0x803d2c
  800202:	e8 1d 03 00 00       	call   800524 <cprintf>
  800207:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80020a:	a1 20 50 80 00       	mov    0x805020,%eax
  80020f:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800215:	83 ec 08             	sub    $0x8,%esp
  800218:	50                   	push   %eax
  800219:	68 84 3d 80 00       	push   $0x803d84
  80021e:	e8 01 03 00 00       	call   800524 <cprintf>
  800223:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800226:	83 ec 0c             	sub    $0xc,%esp
  800229:	68 dc 3c 80 00       	push   $0x803cdc
  80022e:	e8 f1 02 00 00       	call   800524 <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800236:	e8 e2 15 00 00       	call   80181d <sys_unlock_cons>
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
  80024e:	e8 f8 17 00 00       	call   801a4b <sys_destroy_env>
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
  80025f:	e8 4d 18 00 00       	call   801ab1 <sys_exit_env>
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
  800288:	68 98 3d 80 00       	push   $0x803d98
  80028d:	e8 92 02 00 00       	call   800524 <cprintf>
  800292:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800295:	a1 00 50 80 00       	mov    0x805000,%eax
  80029a:	ff 75 0c             	pushl  0xc(%ebp)
  80029d:	ff 75 08             	pushl  0x8(%ebp)
  8002a0:	50                   	push   %eax
  8002a1:	68 9d 3d 80 00       	push   $0x803d9d
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
  8002c5:	68 b9 3d 80 00       	push   $0x803db9
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
  8002f4:	68 bc 3d 80 00       	push   $0x803dbc
  8002f9:	6a 26                	push   $0x26
  8002fb:	68 08 3e 80 00       	push   $0x803e08
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
  8003c9:	68 14 3e 80 00       	push   $0x803e14
  8003ce:	6a 3a                	push   $0x3a
  8003d0:	68 08 3e 80 00       	push   $0x803e08
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
  80043c:	68 68 3e 80 00       	push   $0x803e68
  800441:	6a 44                	push   $0x44
  800443:	68 08 3e 80 00       	push   $0x803e08
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
  800496:	e8 26 13 00 00       	call   8017c1 <sys_cputs>
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
  80050d:	e8 af 12 00 00       	call   8017c1 <sys_cputs>
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
  800557:	e8 a7 12 00 00       	call   801803 <sys_lock_cons>
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
  800577:	e8 a1 12 00 00       	call   80181d <sys_unlock_cons>
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
  8005c1:	e8 46 33 00 00       	call   80390c <__udivdi3>
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
  800611:	e8 06 34 00 00       	call   803a1c <__umoddi3>
  800616:	83 c4 10             	add    $0x10,%esp
  800619:	05 d4 40 80 00       	add    $0x8040d4,%eax
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
  80076c:	8b 04 85 f8 40 80 00 	mov    0x8040f8(,%eax,4),%eax
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
  80084d:	8b 34 9d 40 3f 80 00 	mov    0x803f40(,%ebx,4),%esi
  800854:	85 f6                	test   %esi,%esi
  800856:	75 19                	jne    800871 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800858:	53                   	push   %ebx
  800859:	68 e5 40 80 00       	push   $0x8040e5
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
  800872:	68 ee 40 80 00       	push   $0x8040ee
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
  80089f:	be f1 40 80 00       	mov    $0x8040f1,%esi
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
  8012aa:	68 68 42 80 00       	push   $0x804268
  8012af:	68 3f 01 00 00       	push   $0x13f
  8012b4:	68 8a 42 80 00       	push   $0x80428a
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
  8012ca:	e8 9d 0a 00 00       	call   801d6c <sys_sbrk>
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
  801345:	e8 a6 08 00 00       	call   801bf0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80134a:	85 c0                	test   %eax,%eax
  80134c:	74 16                	je     801364 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80134e:	83 ec 0c             	sub    $0xc,%esp
  801351:	ff 75 08             	pushl  0x8(%ebp)
  801354:	e8 e6 0d 00 00       	call   80213f <alloc_block_FF>
  801359:	83 c4 10             	add    $0x10,%esp
  80135c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80135f:	e9 8a 01 00 00       	jmp    8014ee <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801364:	e8 b8 08 00 00       	call   801c21 <sys_isUHeapPlacementStrategyBESTFIT>
  801369:	85 c0                	test   %eax,%eax
  80136b:	0f 84 7d 01 00 00    	je     8014ee <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801371:	83 ec 0c             	sub    $0xc,%esp
  801374:	ff 75 08             	pushl  0x8(%ebp)
  801377:	e8 7f 12 00 00       	call   8025fb <alloc_block_BF>
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
  8014dd:	e8 c1 08 00 00       	call   801da3 <sys_allocate_user_mem>
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
  801525:	e8 95 08 00 00       	call   801dbf <get_block_size>
  80152a:	83 c4 10             	add    $0x10,%esp
  80152d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801530:	83 ec 0c             	sub    $0xc,%esp
  801533:	ff 75 08             	pushl  0x8(%ebp)
  801536:	e8 c8 1a 00 00       	call   803003 <free_block>
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
  8015cd:	e8 b5 07 00 00       	call   801d87 <sys_free_user_mem>
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
  8015db:	68 98 42 80 00       	push   $0x804298
  8015e0:	68 84 00 00 00       	push   $0x84
  8015e5:	68 c2 42 80 00       	push   $0x8042c2
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
  80164d:	e8 3c 03 00 00       	call   80198e <sys_createSharedObject>
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
  80166e:	68 ce 42 80 00       	push   $0x8042ce
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
  801683:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801686:	83 ec 08             	sub    $0x8,%esp
  801689:	ff 75 0c             	pushl  0xc(%ebp)
  80168c:	ff 75 08             	pushl  0x8(%ebp)
  80168f:	e8 24 03 00 00       	call   8019b8 <sys_getSizeOfSharedObject>
  801694:	83 c4 10             	add    $0x10,%esp
  801697:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80169a:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80169e:	75 07                	jne    8016a7 <sget+0x27>
  8016a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a5:	eb 5c                	jmp    801703 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8016a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016ad:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ba:	39 d0                	cmp    %edx,%eax
  8016bc:	7d 02                	jge    8016c0 <sget+0x40>
  8016be:	89 d0                	mov    %edx,%eax
  8016c0:	83 ec 0c             	sub    $0xc,%esp
  8016c3:	50                   	push   %eax
  8016c4:	e8 0b fc ff ff       	call   8012d4 <malloc>
  8016c9:	83 c4 10             	add    $0x10,%esp
  8016cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8016cf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016d3:	75 07                	jne    8016dc <sget+0x5c>
  8016d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016da:	eb 27                	jmp    801703 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8016dc:	83 ec 04             	sub    $0x4,%esp
  8016df:	ff 75 e8             	pushl  -0x18(%ebp)
  8016e2:	ff 75 0c             	pushl  0xc(%ebp)
  8016e5:	ff 75 08             	pushl  0x8(%ebp)
  8016e8:	e8 e8 02 00 00       	call   8019d5 <sys_getSharedObject>
  8016ed:	83 c4 10             	add    $0x10,%esp
  8016f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8016f3:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8016f7:	75 07                	jne    801700 <sget+0x80>
  8016f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fe:	eb 03                	jmp    801703 <sget+0x83>
	return ptr;
  801700:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80170b:	83 ec 04             	sub    $0x4,%esp
  80170e:	68 d4 42 80 00       	push   $0x8042d4
  801713:	68 c2 00 00 00       	push   $0xc2
  801718:	68 c2 42 80 00       	push   $0x8042c2
  80171d:	e8 45 eb ff ff       	call   800267 <_panic>

00801722 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801728:	83 ec 04             	sub    $0x4,%esp
  80172b:	68 f8 42 80 00       	push   $0x8042f8
  801730:	68 d9 00 00 00       	push   $0xd9
  801735:	68 c2 42 80 00       	push   $0x8042c2
  80173a:	e8 28 eb ff ff       	call   800267 <_panic>

0080173f <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
  801742:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801745:	83 ec 04             	sub    $0x4,%esp
  801748:	68 1e 43 80 00       	push   $0x80431e
  80174d:	68 e5 00 00 00       	push   $0xe5
  801752:	68 c2 42 80 00       	push   $0x8042c2
  801757:	e8 0b eb ff ff       	call   800267 <_panic>

0080175c <shrink>:

}
void shrink(uint32 newSize)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801762:	83 ec 04             	sub    $0x4,%esp
  801765:	68 1e 43 80 00       	push   $0x80431e
  80176a:	68 ea 00 00 00       	push   $0xea
  80176f:	68 c2 42 80 00       	push   $0x8042c2
  801774:	e8 ee ea ff ff       	call   800267 <_panic>

00801779 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80177f:	83 ec 04             	sub    $0x4,%esp
  801782:	68 1e 43 80 00       	push   $0x80431e
  801787:	68 ef 00 00 00       	push   $0xef
  80178c:	68 c2 42 80 00       	push   $0x8042c2
  801791:	e8 d1 ea ff ff       	call   800267 <_panic>

00801796 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	57                   	push   %edi
  80179a:	56                   	push   %esi
  80179b:	53                   	push   %ebx
  80179c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017a8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017ab:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017ae:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017b1:	cd 30                	int    $0x30
  8017b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017b9:	83 c4 10             	add    $0x10,%esp
  8017bc:	5b                   	pop    %ebx
  8017bd:	5e                   	pop    %esi
  8017be:	5f                   	pop    %edi
  8017bf:	5d                   	pop    %ebp
  8017c0:	c3                   	ret    

008017c1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	83 ec 04             	sub    $0x4,%esp
  8017c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017cd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	52                   	push   %edx
  8017d9:	ff 75 0c             	pushl  0xc(%ebp)
  8017dc:	50                   	push   %eax
  8017dd:	6a 00                	push   $0x0
  8017df:	e8 b2 ff ff ff       	call   801796 <syscall>
  8017e4:	83 c4 18             	add    $0x18,%esp
}
  8017e7:	90                   	nop
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <sys_cgetc>:

int
sys_cgetc(void)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 02                	push   $0x2
  8017f9:	e8 98 ff ff ff       	call   801796 <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 03                	push   $0x3
  801812:	e8 7f ff ff ff       	call   801796 <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
}
  80181a:	90                   	nop
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 04                	push   $0x4
  80182c:	e8 65 ff ff ff       	call   801796 <syscall>
  801831:	83 c4 18             	add    $0x18,%esp
}
  801834:	90                   	nop
  801835:	c9                   	leave  
  801836:	c3                   	ret    

00801837 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80183a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	52                   	push   %edx
  801847:	50                   	push   %eax
  801848:	6a 08                	push   $0x8
  80184a:	e8 47 ff ff ff       	call   801796 <syscall>
  80184f:	83 c4 18             	add    $0x18,%esp
}
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	56                   	push   %esi
  801858:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801859:	8b 75 18             	mov    0x18(%ebp),%esi
  80185c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80185f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801862:	8b 55 0c             	mov    0xc(%ebp),%edx
  801865:	8b 45 08             	mov    0x8(%ebp),%eax
  801868:	56                   	push   %esi
  801869:	53                   	push   %ebx
  80186a:	51                   	push   %ecx
  80186b:	52                   	push   %edx
  80186c:	50                   	push   %eax
  80186d:	6a 09                	push   $0x9
  80186f:	e8 22 ff ff ff       	call   801796 <syscall>
  801874:	83 c4 18             	add    $0x18,%esp
}
  801877:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80187a:	5b                   	pop    %ebx
  80187b:	5e                   	pop    %esi
  80187c:	5d                   	pop    %ebp
  80187d:	c3                   	ret    

0080187e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801881:	8b 55 0c             	mov    0xc(%ebp),%edx
  801884:	8b 45 08             	mov    0x8(%ebp),%eax
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	52                   	push   %edx
  80188e:	50                   	push   %eax
  80188f:	6a 0a                	push   $0xa
  801891:	e8 00 ff ff ff       	call   801796 <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	ff 75 0c             	pushl  0xc(%ebp)
  8018a7:	ff 75 08             	pushl  0x8(%ebp)
  8018aa:	6a 0b                	push   $0xb
  8018ac:	e8 e5 fe ff ff       	call   801796 <syscall>
  8018b1:	83 c4 18             	add    $0x18,%esp
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 0c                	push   $0xc
  8018c5:	e8 cc fe ff ff       	call   801796 <syscall>
  8018ca:	83 c4 18             	add    $0x18,%esp
}
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 0d                	push   $0xd
  8018de:	e8 b3 fe ff ff       	call   801796 <syscall>
  8018e3:	83 c4 18             	add    $0x18,%esp
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 0e                	push   $0xe
  8018f7:	e8 9a fe ff ff       	call   801796 <syscall>
  8018fc:	83 c4 18             	add    $0x18,%esp
}
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 0f                	push   $0xf
  801910:	e8 81 fe ff ff       	call   801796 <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	ff 75 08             	pushl  0x8(%ebp)
  801928:	6a 10                	push   $0x10
  80192a:	e8 67 fe ff ff       	call   801796 <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 11                	push   $0x11
  801943:	e8 4e fe ff ff       	call   801796 <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
}
  80194b:	90                   	nop
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_cputc>:

void
sys_cputc(const char c)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	83 ec 04             	sub    $0x4,%esp
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80195a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	50                   	push   %eax
  801967:	6a 01                	push   $0x1
  801969:	e8 28 fe ff ff       	call   801796 <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
}
  801971:	90                   	nop
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 14                	push   $0x14
  801983:	e8 0e fe ff ff       	call   801796 <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
}
  80198b:	90                   	nop
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
  801991:	83 ec 04             	sub    $0x4,%esp
  801994:	8b 45 10             	mov    0x10(%ebp),%eax
  801997:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80199a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80199d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	6a 00                	push   $0x0
  8019a6:	51                   	push   %ecx
  8019a7:	52                   	push   %edx
  8019a8:	ff 75 0c             	pushl  0xc(%ebp)
  8019ab:	50                   	push   %eax
  8019ac:	6a 15                	push   $0x15
  8019ae:	e8 e3 fd ff ff       	call   801796 <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
}
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	52                   	push   %edx
  8019c8:	50                   	push   %eax
  8019c9:	6a 16                	push   $0x16
  8019cb:	e8 c6 fd ff ff       	call   801796 <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019de:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	51                   	push   %ecx
  8019e6:	52                   	push   %edx
  8019e7:	50                   	push   %eax
  8019e8:	6a 17                	push   $0x17
  8019ea:	e8 a7 fd ff ff       	call   801796 <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	52                   	push   %edx
  801a04:	50                   	push   %eax
  801a05:	6a 18                	push   $0x18
  801a07:	e8 8a fd ff ff       	call   801796 <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	6a 00                	push   $0x0
  801a19:	ff 75 14             	pushl  0x14(%ebp)
  801a1c:	ff 75 10             	pushl  0x10(%ebp)
  801a1f:	ff 75 0c             	pushl  0xc(%ebp)
  801a22:	50                   	push   %eax
  801a23:	6a 19                	push   $0x19
  801a25:	e8 6c fd ff ff       	call   801796 <syscall>
  801a2a:	83 c4 18             	add    $0x18,%esp
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	50                   	push   %eax
  801a3e:	6a 1a                	push   $0x1a
  801a40:	e8 51 fd ff ff       	call   801796 <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
}
  801a48:	90                   	nop
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	50                   	push   %eax
  801a5a:	6a 1b                	push   $0x1b
  801a5c:	e8 35 fd ff ff       	call   801796 <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
}
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 05                	push   $0x5
  801a75:	e8 1c fd ff ff       	call   801796 <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
}
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 06                	push   $0x6
  801a8e:	e8 03 fd ff ff       	call   801796 <syscall>
  801a93:	83 c4 18             	add    $0x18,%esp
}
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 07                	push   $0x7
  801aa7:	e8 ea fc ff ff       	call   801796 <syscall>
  801aac:	83 c4 18             	add    $0x18,%esp
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_exit_env>:


void sys_exit_env(void)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 1c                	push   $0x1c
  801ac0:	e8 d1 fc ff ff       	call   801796 <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
}
  801ac8:	90                   	nop
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ad1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ad4:	8d 50 04             	lea    0x4(%eax),%edx
  801ad7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	52                   	push   %edx
  801ae1:	50                   	push   %eax
  801ae2:	6a 1d                	push   $0x1d
  801ae4:	e8 ad fc ff ff       	call   801796 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
	return result;
  801aec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801af2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801af5:	89 01                	mov    %eax,(%ecx)
  801af7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801afa:	8b 45 08             	mov    0x8(%ebp),%eax
  801afd:	c9                   	leave  
  801afe:	c2 04 00             	ret    $0x4

00801b01 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	ff 75 10             	pushl  0x10(%ebp)
  801b0b:	ff 75 0c             	pushl  0xc(%ebp)
  801b0e:	ff 75 08             	pushl  0x8(%ebp)
  801b11:	6a 13                	push   $0x13
  801b13:	e8 7e fc ff ff       	call   801796 <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
	return ;
  801b1b:	90                   	nop
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_rcr2>:
uint32 sys_rcr2()
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 1e                	push   $0x1e
  801b2d:	e8 64 fc ff ff       	call   801796 <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
  801b3a:	83 ec 04             	sub    $0x4,%esp
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b43:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	50                   	push   %eax
  801b50:	6a 1f                	push   $0x1f
  801b52:	e8 3f fc ff ff       	call   801796 <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5a:	90                   	nop
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <rsttst>:
void rsttst()
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 21                	push   $0x21
  801b6c:	e8 25 fc ff ff       	call   801796 <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
	return ;
  801b74:	90                   	nop
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	83 ec 04             	sub    $0x4,%esp
  801b7d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b80:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b83:	8b 55 18             	mov    0x18(%ebp),%edx
  801b86:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b8a:	52                   	push   %edx
  801b8b:	50                   	push   %eax
  801b8c:	ff 75 10             	pushl  0x10(%ebp)
  801b8f:	ff 75 0c             	pushl  0xc(%ebp)
  801b92:	ff 75 08             	pushl  0x8(%ebp)
  801b95:	6a 20                	push   $0x20
  801b97:	e8 fa fb ff ff       	call   801796 <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9f:	90                   	nop
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <chktst>:
void chktst(uint32 n)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	ff 75 08             	pushl  0x8(%ebp)
  801bb0:	6a 22                	push   $0x22
  801bb2:	e8 df fb ff ff       	call   801796 <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bba:	90                   	nop
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <inctst>:

void inctst()
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 23                	push   $0x23
  801bcc:	e8 c5 fb ff ff       	call   801796 <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd4:	90                   	nop
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <gettst>:
uint32 gettst()
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 24                	push   $0x24
  801be6:	e8 ab fb ff ff       	call   801796 <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 25                	push   $0x25
  801c02:	e8 8f fb ff ff       	call   801796 <syscall>
  801c07:	83 c4 18             	add    $0x18,%esp
  801c0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c0d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c11:	75 07                	jne    801c1a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c13:	b8 01 00 00 00       	mov    $0x1,%eax
  801c18:	eb 05                	jmp    801c1f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 25                	push   $0x25
  801c33:	e8 5e fb ff ff       	call   801796 <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
  801c3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c3e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c42:	75 07                	jne    801c4b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c44:	b8 01 00 00 00       	mov    $0x1,%eax
  801c49:	eb 05                	jmp    801c50 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
  801c55:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 25                	push   $0x25
  801c64:	e8 2d fb ff ff       	call   801796 <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
  801c6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c6f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c73:	75 07                	jne    801c7c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c75:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7a:	eb 05                	jmp    801c81 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 25                	push   $0x25
  801c95:	e8 fc fa ff ff       	call   801796 <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
  801c9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ca0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ca4:	75 07                	jne    801cad <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ca6:	b8 01 00 00 00       	mov    $0x1,%eax
  801cab:	eb 05                	jmp    801cb2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	ff 75 08             	pushl  0x8(%ebp)
  801cc2:	6a 26                	push   $0x26
  801cc4:	e8 cd fa ff ff       	call   801796 <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ccc:	90                   	nop
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cd3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cd6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	6a 00                	push   $0x0
  801ce1:	53                   	push   %ebx
  801ce2:	51                   	push   %ecx
  801ce3:	52                   	push   %edx
  801ce4:	50                   	push   %eax
  801ce5:	6a 27                	push   $0x27
  801ce7:	e8 aa fa ff ff       	call   801796 <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
}
  801cef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	52                   	push   %edx
  801d04:	50                   	push   %eax
  801d05:	6a 28                	push   $0x28
  801d07:	e8 8a fa ff ff       	call   801796 <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d14:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	6a 00                	push   $0x0
  801d1f:	51                   	push   %ecx
  801d20:	ff 75 10             	pushl  0x10(%ebp)
  801d23:	52                   	push   %edx
  801d24:	50                   	push   %eax
  801d25:	6a 29                	push   $0x29
  801d27:	e8 6a fa ff ff       	call   801796 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
}
  801d2f:	c9                   	leave  
  801d30:	c3                   	ret    

00801d31 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	ff 75 10             	pushl  0x10(%ebp)
  801d3b:	ff 75 0c             	pushl  0xc(%ebp)
  801d3e:	ff 75 08             	pushl  0x8(%ebp)
  801d41:	6a 12                	push   $0x12
  801d43:	e8 4e fa ff ff       	call   801796 <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4b:	90                   	nop
}
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d54:	8b 45 08             	mov    0x8(%ebp),%eax
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	52                   	push   %edx
  801d5e:	50                   	push   %eax
  801d5f:	6a 2a                	push   $0x2a
  801d61:	e8 30 fa ff ff       	call   801796 <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
	return;
  801d69:	90                   	nop
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	50                   	push   %eax
  801d7b:	6a 2b                	push   $0x2b
  801d7d:	e8 14 fa ff ff       	call   801796 <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
}
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	ff 75 0c             	pushl  0xc(%ebp)
  801d93:	ff 75 08             	pushl  0x8(%ebp)
  801d96:	6a 2c                	push   $0x2c
  801d98:	e8 f9 f9 ff ff       	call   801796 <syscall>
  801d9d:	83 c4 18             	add    $0x18,%esp
	return;
  801da0:	90                   	nop
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	ff 75 0c             	pushl  0xc(%ebp)
  801daf:	ff 75 08             	pushl  0x8(%ebp)
  801db2:	6a 2d                	push   $0x2d
  801db4:	e8 dd f9 ff ff       	call   801796 <syscall>
  801db9:	83 c4 18             	add    $0x18,%esp
	return;
  801dbc:	90                   	nop
}
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
  801dc2:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc8:	83 e8 04             	sub    $0x4,%eax
  801dcb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801dce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dd1:	8b 00                	mov    (%eax),%eax
  801dd3:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    

00801dd8 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
  801ddb:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801dde:	8b 45 08             	mov    0x8(%ebp),%eax
  801de1:	83 e8 04             	sub    $0x4,%eax
  801de4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801de7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dea:	8b 00                	mov    (%eax),%eax
  801dec:	83 e0 01             	and    $0x1,%eax
  801def:	85 c0                	test   %eax,%eax
  801df1:	0f 94 c0             	sete   %al
}
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    

00801df6 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
  801df9:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801dfc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e06:	83 f8 02             	cmp    $0x2,%eax
  801e09:	74 2b                	je     801e36 <alloc_block+0x40>
  801e0b:	83 f8 02             	cmp    $0x2,%eax
  801e0e:	7f 07                	jg     801e17 <alloc_block+0x21>
  801e10:	83 f8 01             	cmp    $0x1,%eax
  801e13:	74 0e                	je     801e23 <alloc_block+0x2d>
  801e15:	eb 58                	jmp    801e6f <alloc_block+0x79>
  801e17:	83 f8 03             	cmp    $0x3,%eax
  801e1a:	74 2d                	je     801e49 <alloc_block+0x53>
  801e1c:	83 f8 04             	cmp    $0x4,%eax
  801e1f:	74 3b                	je     801e5c <alloc_block+0x66>
  801e21:	eb 4c                	jmp    801e6f <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801e23:	83 ec 0c             	sub    $0xc,%esp
  801e26:	ff 75 08             	pushl  0x8(%ebp)
  801e29:	e8 11 03 00 00       	call   80213f <alloc_block_FF>
  801e2e:	83 c4 10             	add    $0x10,%esp
  801e31:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e34:	eb 4a                	jmp    801e80 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801e36:	83 ec 0c             	sub    $0xc,%esp
  801e39:	ff 75 08             	pushl  0x8(%ebp)
  801e3c:	e8 fa 19 00 00       	call   80383b <alloc_block_NF>
  801e41:	83 c4 10             	add    $0x10,%esp
  801e44:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e47:	eb 37                	jmp    801e80 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801e49:	83 ec 0c             	sub    $0xc,%esp
  801e4c:	ff 75 08             	pushl  0x8(%ebp)
  801e4f:	e8 a7 07 00 00       	call   8025fb <alloc_block_BF>
  801e54:	83 c4 10             	add    $0x10,%esp
  801e57:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e5a:	eb 24                	jmp    801e80 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801e5c:	83 ec 0c             	sub    $0xc,%esp
  801e5f:	ff 75 08             	pushl  0x8(%ebp)
  801e62:	e8 b7 19 00 00       	call   80381e <alloc_block_WF>
  801e67:	83 c4 10             	add    $0x10,%esp
  801e6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e6d:	eb 11                	jmp    801e80 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801e6f:	83 ec 0c             	sub    $0xc,%esp
  801e72:	68 30 43 80 00       	push   $0x804330
  801e77:	e8 a8 e6 ff ff       	call   800524 <cprintf>
  801e7c:	83 c4 10             	add    $0x10,%esp
		break;
  801e7f:	90                   	nop
	}
	return va;
  801e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
  801e88:	53                   	push   %ebx
  801e89:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801e8c:	83 ec 0c             	sub    $0xc,%esp
  801e8f:	68 50 43 80 00       	push   $0x804350
  801e94:	e8 8b e6 ff ff       	call   800524 <cprintf>
  801e99:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801e9c:	83 ec 0c             	sub    $0xc,%esp
  801e9f:	68 7b 43 80 00       	push   $0x80437b
  801ea4:	e8 7b e6 ff ff       	call   800524 <cprintf>
  801ea9:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801eac:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb2:	eb 37                	jmp    801eeb <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801eb4:	83 ec 0c             	sub    $0xc,%esp
  801eb7:	ff 75 f4             	pushl  -0xc(%ebp)
  801eba:	e8 19 ff ff ff       	call   801dd8 <is_free_block>
  801ebf:	83 c4 10             	add    $0x10,%esp
  801ec2:	0f be d8             	movsbl %al,%ebx
  801ec5:	83 ec 0c             	sub    $0xc,%esp
  801ec8:	ff 75 f4             	pushl  -0xc(%ebp)
  801ecb:	e8 ef fe ff ff       	call   801dbf <get_block_size>
  801ed0:	83 c4 10             	add    $0x10,%esp
  801ed3:	83 ec 04             	sub    $0x4,%esp
  801ed6:	53                   	push   %ebx
  801ed7:	50                   	push   %eax
  801ed8:	68 93 43 80 00       	push   $0x804393
  801edd:	e8 42 e6 ff ff       	call   800524 <cprintf>
  801ee2:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801ee5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eeb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eef:	74 07                	je     801ef8 <print_blocks_list+0x73>
  801ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef4:	8b 00                	mov    (%eax),%eax
  801ef6:	eb 05                	jmp    801efd <print_blocks_list+0x78>
  801ef8:	b8 00 00 00 00       	mov    $0x0,%eax
  801efd:	89 45 10             	mov    %eax,0x10(%ebp)
  801f00:	8b 45 10             	mov    0x10(%ebp),%eax
  801f03:	85 c0                	test   %eax,%eax
  801f05:	75 ad                	jne    801eb4 <print_blocks_list+0x2f>
  801f07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f0b:	75 a7                	jne    801eb4 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801f0d:	83 ec 0c             	sub    $0xc,%esp
  801f10:	68 50 43 80 00       	push   $0x804350
  801f15:	e8 0a e6 ff ff       	call   800524 <cprintf>
  801f1a:	83 c4 10             	add    $0x10,%esp

}
  801f1d:	90                   	nop
  801f1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
  801f26:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2c:	83 e0 01             	and    $0x1,%eax
  801f2f:	85 c0                	test   %eax,%eax
  801f31:	74 03                	je     801f36 <initialize_dynamic_allocator+0x13>
  801f33:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801f36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f3a:	0f 84 c7 01 00 00    	je     802107 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801f40:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801f47:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801f4a:	8b 55 08             	mov    0x8(%ebp),%edx
  801f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f50:	01 d0                	add    %edx,%eax
  801f52:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801f57:	0f 87 ad 01 00 00    	ja     80210a <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f60:	85 c0                	test   %eax,%eax
  801f62:	0f 89 a5 01 00 00    	jns    80210d <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801f68:	8b 55 08             	mov    0x8(%ebp),%edx
  801f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f6e:	01 d0                	add    %edx,%eax
  801f70:	83 e8 04             	sub    $0x4,%eax
  801f73:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801f78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801f7f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801f84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f87:	e9 87 00 00 00       	jmp    802013 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801f8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f90:	75 14                	jne    801fa6 <initialize_dynamic_allocator+0x83>
  801f92:	83 ec 04             	sub    $0x4,%esp
  801f95:	68 ab 43 80 00       	push   $0x8043ab
  801f9a:	6a 79                	push   $0x79
  801f9c:	68 c9 43 80 00       	push   $0x8043c9
  801fa1:	e8 c1 e2 ff ff       	call   800267 <_panic>
  801fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa9:	8b 00                	mov    (%eax),%eax
  801fab:	85 c0                	test   %eax,%eax
  801fad:	74 10                	je     801fbf <initialize_dynamic_allocator+0x9c>
  801faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb2:	8b 00                	mov    (%eax),%eax
  801fb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb7:	8b 52 04             	mov    0x4(%edx),%edx
  801fba:	89 50 04             	mov    %edx,0x4(%eax)
  801fbd:	eb 0b                	jmp    801fca <initialize_dynamic_allocator+0xa7>
  801fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc2:	8b 40 04             	mov    0x4(%eax),%eax
  801fc5:	a3 30 50 80 00       	mov    %eax,0x805030
  801fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcd:	8b 40 04             	mov    0x4(%eax),%eax
  801fd0:	85 c0                	test   %eax,%eax
  801fd2:	74 0f                	je     801fe3 <initialize_dynamic_allocator+0xc0>
  801fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd7:	8b 40 04             	mov    0x4(%eax),%eax
  801fda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fdd:	8b 12                	mov    (%edx),%edx
  801fdf:	89 10                	mov    %edx,(%eax)
  801fe1:	eb 0a                	jmp    801fed <initialize_dynamic_allocator+0xca>
  801fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe6:	8b 00                	mov    (%eax),%eax
  801fe8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802000:	a1 38 50 80 00       	mov    0x805038,%eax
  802005:	48                   	dec    %eax
  802006:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80200b:	a1 34 50 80 00       	mov    0x805034,%eax
  802010:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802013:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802017:	74 07                	je     802020 <initialize_dynamic_allocator+0xfd>
  802019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201c:	8b 00                	mov    (%eax),%eax
  80201e:	eb 05                	jmp    802025 <initialize_dynamic_allocator+0x102>
  802020:	b8 00 00 00 00       	mov    $0x0,%eax
  802025:	a3 34 50 80 00       	mov    %eax,0x805034
  80202a:	a1 34 50 80 00       	mov    0x805034,%eax
  80202f:	85 c0                	test   %eax,%eax
  802031:	0f 85 55 ff ff ff    	jne    801f8c <initialize_dynamic_allocator+0x69>
  802037:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80203b:	0f 85 4b ff ff ff    	jne    801f8c <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802041:	8b 45 08             	mov    0x8(%ebp),%eax
  802044:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802047:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802050:	a1 44 50 80 00       	mov    0x805044,%eax
  802055:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80205a:	a1 40 50 80 00       	mov    0x805040,%eax
  80205f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	83 c0 08             	add    $0x8,%eax
  80206b:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80206e:	8b 45 08             	mov    0x8(%ebp),%eax
  802071:	83 c0 04             	add    $0x4,%eax
  802074:	8b 55 0c             	mov    0xc(%ebp),%edx
  802077:	83 ea 08             	sub    $0x8,%edx
  80207a:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80207c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207f:	8b 45 08             	mov    0x8(%ebp),%eax
  802082:	01 d0                	add    %edx,%eax
  802084:	83 e8 08             	sub    $0x8,%eax
  802087:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208a:	83 ea 08             	sub    $0x8,%edx
  80208d:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80208f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802092:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802098:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80209b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8020a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020a6:	75 17                	jne    8020bf <initialize_dynamic_allocator+0x19c>
  8020a8:	83 ec 04             	sub    $0x4,%esp
  8020ab:	68 e4 43 80 00       	push   $0x8043e4
  8020b0:	68 90 00 00 00       	push   $0x90
  8020b5:	68 c9 43 80 00       	push   $0x8043c9
  8020ba:	e8 a8 e1 ff ff       	call   800267 <_panic>
  8020bf:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8020c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c8:	89 10                	mov    %edx,(%eax)
  8020ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020cd:	8b 00                	mov    (%eax),%eax
  8020cf:	85 c0                	test   %eax,%eax
  8020d1:	74 0d                	je     8020e0 <initialize_dynamic_allocator+0x1bd>
  8020d3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020db:	89 50 04             	mov    %edx,0x4(%eax)
  8020de:	eb 08                	jmp    8020e8 <initialize_dynamic_allocator+0x1c5>
  8020e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e3:	a3 30 50 80 00       	mov    %eax,0x805030
  8020e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020eb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020fa:	a1 38 50 80 00       	mov    0x805038,%eax
  8020ff:	40                   	inc    %eax
  802100:	a3 38 50 80 00       	mov    %eax,0x805038
  802105:	eb 07                	jmp    80210e <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802107:	90                   	nop
  802108:	eb 04                	jmp    80210e <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80210a:	90                   	nop
  80210b:	eb 01                	jmp    80210e <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80210d:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80210e:	c9                   	leave  
  80210f:	c3                   	ret    

00802110 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802113:	8b 45 10             	mov    0x10(%ebp),%eax
  802116:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	8d 50 fc             	lea    -0x4(%eax),%edx
  80211f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802122:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802124:	8b 45 08             	mov    0x8(%ebp),%eax
  802127:	83 e8 04             	sub    $0x4,%eax
  80212a:	8b 00                	mov    (%eax),%eax
  80212c:	83 e0 fe             	and    $0xfffffffe,%eax
  80212f:	8d 50 f8             	lea    -0x8(%eax),%edx
  802132:	8b 45 08             	mov    0x8(%ebp),%eax
  802135:	01 c2                	add    %eax,%edx
  802137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213a:	89 02                	mov    %eax,(%edx)
}
  80213c:	90                   	nop
  80213d:	5d                   	pop    %ebp
  80213e:	c3                   	ret    

0080213f <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
  802142:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	83 e0 01             	and    $0x1,%eax
  80214b:	85 c0                	test   %eax,%eax
  80214d:	74 03                	je     802152 <alloc_block_FF+0x13>
  80214f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802152:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802156:	77 07                	ja     80215f <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802158:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80215f:	a1 24 50 80 00       	mov    0x805024,%eax
  802164:	85 c0                	test   %eax,%eax
  802166:	75 73                	jne    8021db <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	83 c0 10             	add    $0x10,%eax
  80216e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802171:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802178:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80217b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80217e:	01 d0                	add    %edx,%eax
  802180:	48                   	dec    %eax
  802181:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802184:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802187:	ba 00 00 00 00       	mov    $0x0,%edx
  80218c:	f7 75 ec             	divl   -0x14(%ebp)
  80218f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802192:	29 d0                	sub    %edx,%eax
  802194:	c1 e8 0c             	shr    $0xc,%eax
  802197:	83 ec 0c             	sub    $0xc,%esp
  80219a:	50                   	push   %eax
  80219b:	e8 1e f1 ff ff       	call   8012be <sbrk>
  8021a0:	83 c4 10             	add    $0x10,%esp
  8021a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8021a6:	83 ec 0c             	sub    $0xc,%esp
  8021a9:	6a 00                	push   $0x0
  8021ab:	e8 0e f1 ff ff       	call   8012be <sbrk>
  8021b0:	83 c4 10             	add    $0x10,%esp
  8021b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8021b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021b9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8021bc:	83 ec 08             	sub    $0x8,%esp
  8021bf:	50                   	push   %eax
  8021c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021c3:	e8 5b fd ff ff       	call   801f23 <initialize_dynamic_allocator>
  8021c8:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8021cb:	83 ec 0c             	sub    $0xc,%esp
  8021ce:	68 07 44 80 00       	push   $0x804407
  8021d3:	e8 4c e3 ff ff       	call   800524 <cprintf>
  8021d8:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8021db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021df:	75 0a                	jne    8021eb <alloc_block_FF+0xac>
	        return NULL;
  8021e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e6:	e9 0e 04 00 00       	jmp    8025f9 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8021eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8021f2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021fa:	e9 f3 02 00 00       	jmp    8024f2 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8021ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802202:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802205:	83 ec 0c             	sub    $0xc,%esp
  802208:	ff 75 bc             	pushl  -0x44(%ebp)
  80220b:	e8 af fb ff ff       	call   801dbf <get_block_size>
  802210:	83 c4 10             	add    $0x10,%esp
  802213:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	83 c0 08             	add    $0x8,%eax
  80221c:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80221f:	0f 87 c5 02 00 00    	ja     8024ea <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	83 c0 18             	add    $0x18,%eax
  80222b:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80222e:	0f 87 19 02 00 00    	ja     80244d <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802234:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802237:	2b 45 08             	sub    0x8(%ebp),%eax
  80223a:	83 e8 08             	sub    $0x8,%eax
  80223d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	8d 50 08             	lea    0x8(%eax),%edx
  802246:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802249:	01 d0                	add    %edx,%eax
  80224b:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
  802251:	83 c0 08             	add    $0x8,%eax
  802254:	83 ec 04             	sub    $0x4,%esp
  802257:	6a 01                	push   $0x1
  802259:	50                   	push   %eax
  80225a:	ff 75 bc             	pushl  -0x44(%ebp)
  80225d:	e8 ae fe ff ff       	call   802110 <set_block_data>
  802262:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802268:	8b 40 04             	mov    0x4(%eax),%eax
  80226b:	85 c0                	test   %eax,%eax
  80226d:	75 68                	jne    8022d7 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80226f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802273:	75 17                	jne    80228c <alloc_block_FF+0x14d>
  802275:	83 ec 04             	sub    $0x4,%esp
  802278:	68 e4 43 80 00       	push   $0x8043e4
  80227d:	68 d7 00 00 00       	push   $0xd7
  802282:	68 c9 43 80 00       	push   $0x8043c9
  802287:	e8 db df ff ff       	call   800267 <_panic>
  80228c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802292:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802295:	89 10                	mov    %edx,(%eax)
  802297:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80229a:	8b 00                	mov    (%eax),%eax
  80229c:	85 c0                	test   %eax,%eax
  80229e:	74 0d                	je     8022ad <alloc_block_FF+0x16e>
  8022a0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022a5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022a8:	89 50 04             	mov    %edx,0x4(%eax)
  8022ab:	eb 08                	jmp    8022b5 <alloc_block_FF+0x176>
  8022ad:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022b0:	a3 30 50 80 00       	mov    %eax,0x805030
  8022b5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022b8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022bd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022c7:	a1 38 50 80 00       	mov    0x805038,%eax
  8022cc:	40                   	inc    %eax
  8022cd:	a3 38 50 80 00       	mov    %eax,0x805038
  8022d2:	e9 dc 00 00 00       	jmp    8023b3 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8022d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022da:	8b 00                	mov    (%eax),%eax
  8022dc:	85 c0                	test   %eax,%eax
  8022de:	75 65                	jne    802345 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8022e0:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022e4:	75 17                	jne    8022fd <alloc_block_FF+0x1be>
  8022e6:	83 ec 04             	sub    $0x4,%esp
  8022e9:	68 18 44 80 00       	push   $0x804418
  8022ee:	68 db 00 00 00       	push   $0xdb
  8022f3:	68 c9 43 80 00       	push   $0x8043c9
  8022f8:	e8 6a df ff ff       	call   800267 <_panic>
  8022fd:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802303:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802306:	89 50 04             	mov    %edx,0x4(%eax)
  802309:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80230c:	8b 40 04             	mov    0x4(%eax),%eax
  80230f:	85 c0                	test   %eax,%eax
  802311:	74 0c                	je     80231f <alloc_block_FF+0x1e0>
  802313:	a1 30 50 80 00       	mov    0x805030,%eax
  802318:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80231b:	89 10                	mov    %edx,(%eax)
  80231d:	eb 08                	jmp    802327 <alloc_block_FF+0x1e8>
  80231f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802322:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802327:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80232a:	a3 30 50 80 00       	mov    %eax,0x805030
  80232f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802332:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802338:	a1 38 50 80 00       	mov    0x805038,%eax
  80233d:	40                   	inc    %eax
  80233e:	a3 38 50 80 00       	mov    %eax,0x805038
  802343:	eb 6e                	jmp    8023b3 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802345:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802349:	74 06                	je     802351 <alloc_block_FF+0x212>
  80234b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80234f:	75 17                	jne    802368 <alloc_block_FF+0x229>
  802351:	83 ec 04             	sub    $0x4,%esp
  802354:	68 3c 44 80 00       	push   $0x80443c
  802359:	68 df 00 00 00       	push   $0xdf
  80235e:	68 c9 43 80 00       	push   $0x8043c9
  802363:	e8 ff de ff ff       	call   800267 <_panic>
  802368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236b:	8b 10                	mov    (%eax),%edx
  80236d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802370:	89 10                	mov    %edx,(%eax)
  802372:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802375:	8b 00                	mov    (%eax),%eax
  802377:	85 c0                	test   %eax,%eax
  802379:	74 0b                	je     802386 <alloc_block_FF+0x247>
  80237b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237e:	8b 00                	mov    (%eax),%eax
  802380:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802383:	89 50 04             	mov    %edx,0x4(%eax)
  802386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802389:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80238c:	89 10                	mov    %edx,(%eax)
  80238e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802391:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802394:	89 50 04             	mov    %edx,0x4(%eax)
  802397:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80239a:	8b 00                	mov    (%eax),%eax
  80239c:	85 c0                	test   %eax,%eax
  80239e:	75 08                	jne    8023a8 <alloc_block_FF+0x269>
  8023a0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023a3:	a3 30 50 80 00       	mov    %eax,0x805030
  8023a8:	a1 38 50 80 00       	mov    0x805038,%eax
  8023ad:	40                   	inc    %eax
  8023ae:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8023b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b7:	75 17                	jne    8023d0 <alloc_block_FF+0x291>
  8023b9:	83 ec 04             	sub    $0x4,%esp
  8023bc:	68 ab 43 80 00       	push   $0x8043ab
  8023c1:	68 e1 00 00 00       	push   $0xe1
  8023c6:	68 c9 43 80 00       	push   $0x8043c9
  8023cb:	e8 97 de ff ff       	call   800267 <_panic>
  8023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d3:	8b 00                	mov    (%eax),%eax
  8023d5:	85 c0                	test   %eax,%eax
  8023d7:	74 10                	je     8023e9 <alloc_block_FF+0x2aa>
  8023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dc:	8b 00                	mov    (%eax),%eax
  8023de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e1:	8b 52 04             	mov    0x4(%edx),%edx
  8023e4:	89 50 04             	mov    %edx,0x4(%eax)
  8023e7:	eb 0b                	jmp    8023f4 <alloc_block_FF+0x2b5>
  8023e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ec:	8b 40 04             	mov    0x4(%eax),%eax
  8023ef:	a3 30 50 80 00       	mov    %eax,0x805030
  8023f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f7:	8b 40 04             	mov    0x4(%eax),%eax
  8023fa:	85 c0                	test   %eax,%eax
  8023fc:	74 0f                	je     80240d <alloc_block_FF+0x2ce>
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802401:	8b 40 04             	mov    0x4(%eax),%eax
  802404:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802407:	8b 12                	mov    (%edx),%edx
  802409:	89 10                	mov    %edx,(%eax)
  80240b:	eb 0a                	jmp    802417 <alloc_block_FF+0x2d8>
  80240d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802410:	8b 00                	mov    (%eax),%eax
  802412:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802423:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80242a:	a1 38 50 80 00       	mov    0x805038,%eax
  80242f:	48                   	dec    %eax
  802430:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802435:	83 ec 04             	sub    $0x4,%esp
  802438:	6a 00                	push   $0x0
  80243a:	ff 75 b4             	pushl  -0x4c(%ebp)
  80243d:	ff 75 b0             	pushl  -0x50(%ebp)
  802440:	e8 cb fc ff ff       	call   802110 <set_block_data>
  802445:	83 c4 10             	add    $0x10,%esp
  802448:	e9 95 00 00 00       	jmp    8024e2 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80244d:	83 ec 04             	sub    $0x4,%esp
  802450:	6a 01                	push   $0x1
  802452:	ff 75 b8             	pushl  -0x48(%ebp)
  802455:	ff 75 bc             	pushl  -0x44(%ebp)
  802458:	e8 b3 fc ff ff       	call   802110 <set_block_data>
  80245d:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802460:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802464:	75 17                	jne    80247d <alloc_block_FF+0x33e>
  802466:	83 ec 04             	sub    $0x4,%esp
  802469:	68 ab 43 80 00       	push   $0x8043ab
  80246e:	68 e8 00 00 00       	push   $0xe8
  802473:	68 c9 43 80 00       	push   $0x8043c9
  802478:	e8 ea dd ff ff       	call   800267 <_panic>
  80247d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802480:	8b 00                	mov    (%eax),%eax
  802482:	85 c0                	test   %eax,%eax
  802484:	74 10                	je     802496 <alloc_block_FF+0x357>
  802486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802489:	8b 00                	mov    (%eax),%eax
  80248b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248e:	8b 52 04             	mov    0x4(%edx),%edx
  802491:	89 50 04             	mov    %edx,0x4(%eax)
  802494:	eb 0b                	jmp    8024a1 <alloc_block_FF+0x362>
  802496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802499:	8b 40 04             	mov    0x4(%eax),%eax
  80249c:	a3 30 50 80 00       	mov    %eax,0x805030
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	8b 40 04             	mov    0x4(%eax),%eax
  8024a7:	85 c0                	test   %eax,%eax
  8024a9:	74 0f                	je     8024ba <alloc_block_FF+0x37b>
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	8b 40 04             	mov    0x4(%eax),%eax
  8024b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b4:	8b 12                	mov    (%edx),%edx
  8024b6:	89 10                	mov    %edx,(%eax)
  8024b8:	eb 0a                	jmp    8024c4 <alloc_block_FF+0x385>
  8024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bd:	8b 00                	mov    (%eax),%eax
  8024bf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024d7:	a1 38 50 80 00       	mov    0x805038,%eax
  8024dc:	48                   	dec    %eax
  8024dd:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8024e2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024e5:	e9 0f 01 00 00       	jmp    8025f9 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8024ea:	a1 34 50 80 00       	mov    0x805034,%eax
  8024ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f6:	74 07                	je     8024ff <alloc_block_FF+0x3c0>
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	8b 00                	mov    (%eax),%eax
  8024fd:	eb 05                	jmp    802504 <alloc_block_FF+0x3c5>
  8024ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802504:	a3 34 50 80 00       	mov    %eax,0x805034
  802509:	a1 34 50 80 00       	mov    0x805034,%eax
  80250e:	85 c0                	test   %eax,%eax
  802510:	0f 85 e9 fc ff ff    	jne    8021ff <alloc_block_FF+0xc0>
  802516:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251a:	0f 85 df fc ff ff    	jne    8021ff <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802520:	8b 45 08             	mov    0x8(%ebp),%eax
  802523:	83 c0 08             	add    $0x8,%eax
  802526:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802529:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802530:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802533:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802536:	01 d0                	add    %edx,%eax
  802538:	48                   	dec    %eax
  802539:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80253c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80253f:	ba 00 00 00 00       	mov    $0x0,%edx
  802544:	f7 75 d8             	divl   -0x28(%ebp)
  802547:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80254a:	29 d0                	sub    %edx,%eax
  80254c:	c1 e8 0c             	shr    $0xc,%eax
  80254f:	83 ec 0c             	sub    $0xc,%esp
  802552:	50                   	push   %eax
  802553:	e8 66 ed ff ff       	call   8012be <sbrk>
  802558:	83 c4 10             	add    $0x10,%esp
  80255b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80255e:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802562:	75 0a                	jne    80256e <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802564:	b8 00 00 00 00       	mov    $0x0,%eax
  802569:	e9 8b 00 00 00       	jmp    8025f9 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80256e:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802575:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802578:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80257b:	01 d0                	add    %edx,%eax
  80257d:	48                   	dec    %eax
  80257e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802581:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802584:	ba 00 00 00 00       	mov    $0x0,%edx
  802589:	f7 75 cc             	divl   -0x34(%ebp)
  80258c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80258f:	29 d0                	sub    %edx,%eax
  802591:	8d 50 fc             	lea    -0x4(%eax),%edx
  802594:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802597:	01 d0                	add    %edx,%eax
  802599:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80259e:	a1 40 50 80 00       	mov    0x805040,%eax
  8025a3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8025a9:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8025b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025b3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8025b6:	01 d0                	add    %edx,%eax
  8025b8:	48                   	dec    %eax
  8025b9:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8025bc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8025bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8025c4:	f7 75 c4             	divl   -0x3c(%ebp)
  8025c7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8025ca:	29 d0                	sub    %edx,%eax
  8025cc:	83 ec 04             	sub    $0x4,%esp
  8025cf:	6a 01                	push   $0x1
  8025d1:	50                   	push   %eax
  8025d2:	ff 75 d0             	pushl  -0x30(%ebp)
  8025d5:	e8 36 fb ff ff       	call   802110 <set_block_data>
  8025da:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8025dd:	83 ec 0c             	sub    $0xc,%esp
  8025e0:	ff 75 d0             	pushl  -0x30(%ebp)
  8025e3:	e8 1b 0a 00 00       	call   803003 <free_block>
  8025e8:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8025eb:	83 ec 0c             	sub    $0xc,%esp
  8025ee:	ff 75 08             	pushl  0x8(%ebp)
  8025f1:	e8 49 fb ff ff       	call   80213f <alloc_block_FF>
  8025f6:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8025f9:	c9                   	leave  
  8025fa:	c3                   	ret    

008025fb <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8025fb:	55                   	push   %ebp
  8025fc:	89 e5                	mov    %esp,%ebp
  8025fe:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802601:	8b 45 08             	mov    0x8(%ebp),%eax
  802604:	83 e0 01             	and    $0x1,%eax
  802607:	85 c0                	test   %eax,%eax
  802609:	74 03                	je     80260e <alloc_block_BF+0x13>
  80260b:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80260e:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802612:	77 07                	ja     80261b <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802614:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80261b:	a1 24 50 80 00       	mov    0x805024,%eax
  802620:	85 c0                	test   %eax,%eax
  802622:	75 73                	jne    802697 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802624:	8b 45 08             	mov    0x8(%ebp),%eax
  802627:	83 c0 10             	add    $0x10,%eax
  80262a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80262d:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802634:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802637:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80263a:	01 d0                	add    %edx,%eax
  80263c:	48                   	dec    %eax
  80263d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802640:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802643:	ba 00 00 00 00       	mov    $0x0,%edx
  802648:	f7 75 e0             	divl   -0x20(%ebp)
  80264b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80264e:	29 d0                	sub    %edx,%eax
  802650:	c1 e8 0c             	shr    $0xc,%eax
  802653:	83 ec 0c             	sub    $0xc,%esp
  802656:	50                   	push   %eax
  802657:	e8 62 ec ff ff       	call   8012be <sbrk>
  80265c:	83 c4 10             	add    $0x10,%esp
  80265f:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802662:	83 ec 0c             	sub    $0xc,%esp
  802665:	6a 00                	push   $0x0
  802667:	e8 52 ec ff ff       	call   8012be <sbrk>
  80266c:	83 c4 10             	add    $0x10,%esp
  80266f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802672:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802675:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802678:	83 ec 08             	sub    $0x8,%esp
  80267b:	50                   	push   %eax
  80267c:	ff 75 d8             	pushl  -0x28(%ebp)
  80267f:	e8 9f f8 ff ff       	call   801f23 <initialize_dynamic_allocator>
  802684:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802687:	83 ec 0c             	sub    $0xc,%esp
  80268a:	68 07 44 80 00       	push   $0x804407
  80268f:	e8 90 de ff ff       	call   800524 <cprintf>
  802694:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802697:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80269e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8026a5:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8026ac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8026b3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8026b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026bb:	e9 1d 01 00 00       	jmp    8027dd <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8026c6:	83 ec 0c             	sub    $0xc,%esp
  8026c9:	ff 75 a8             	pushl  -0x58(%ebp)
  8026cc:	e8 ee f6 ff ff       	call   801dbf <get_block_size>
  8026d1:	83 c4 10             	add    $0x10,%esp
  8026d4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8026d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026da:	83 c0 08             	add    $0x8,%eax
  8026dd:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026e0:	0f 87 ef 00 00 00    	ja     8027d5 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8026e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e9:	83 c0 18             	add    $0x18,%eax
  8026ec:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026ef:	77 1d                	ja     80270e <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8026f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026f7:	0f 86 d8 00 00 00    	jbe    8027d5 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8026fd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802700:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802703:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802706:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802709:	e9 c7 00 00 00       	jmp    8027d5 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80270e:	8b 45 08             	mov    0x8(%ebp),%eax
  802711:	83 c0 08             	add    $0x8,%eax
  802714:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802717:	0f 85 9d 00 00 00    	jne    8027ba <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80271d:	83 ec 04             	sub    $0x4,%esp
  802720:	6a 01                	push   $0x1
  802722:	ff 75 a4             	pushl  -0x5c(%ebp)
  802725:	ff 75 a8             	pushl  -0x58(%ebp)
  802728:	e8 e3 f9 ff ff       	call   802110 <set_block_data>
  80272d:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802730:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802734:	75 17                	jne    80274d <alloc_block_BF+0x152>
  802736:	83 ec 04             	sub    $0x4,%esp
  802739:	68 ab 43 80 00       	push   $0x8043ab
  80273e:	68 2c 01 00 00       	push   $0x12c
  802743:	68 c9 43 80 00       	push   $0x8043c9
  802748:	e8 1a db ff ff       	call   800267 <_panic>
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	8b 00                	mov    (%eax),%eax
  802752:	85 c0                	test   %eax,%eax
  802754:	74 10                	je     802766 <alloc_block_BF+0x16b>
  802756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802759:	8b 00                	mov    (%eax),%eax
  80275b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80275e:	8b 52 04             	mov    0x4(%edx),%edx
  802761:	89 50 04             	mov    %edx,0x4(%eax)
  802764:	eb 0b                	jmp    802771 <alloc_block_BF+0x176>
  802766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802769:	8b 40 04             	mov    0x4(%eax),%eax
  80276c:	a3 30 50 80 00       	mov    %eax,0x805030
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	8b 40 04             	mov    0x4(%eax),%eax
  802777:	85 c0                	test   %eax,%eax
  802779:	74 0f                	je     80278a <alloc_block_BF+0x18f>
  80277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277e:	8b 40 04             	mov    0x4(%eax),%eax
  802781:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802784:	8b 12                	mov    (%edx),%edx
  802786:	89 10                	mov    %edx,(%eax)
  802788:	eb 0a                	jmp    802794 <alloc_block_BF+0x199>
  80278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278d:	8b 00                	mov    (%eax),%eax
  80278f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a7:	a1 38 50 80 00       	mov    0x805038,%eax
  8027ac:	48                   	dec    %eax
  8027ad:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8027b2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027b5:	e9 24 04 00 00       	jmp    802bde <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8027ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027bd:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027c0:	76 13                	jbe    8027d5 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8027c2:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8027c9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8027cf:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8027d2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8027d5:	a1 34 50 80 00       	mov    0x805034,%eax
  8027da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e1:	74 07                	je     8027ea <alloc_block_BF+0x1ef>
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	8b 00                	mov    (%eax),%eax
  8027e8:	eb 05                	jmp    8027ef <alloc_block_BF+0x1f4>
  8027ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ef:	a3 34 50 80 00       	mov    %eax,0x805034
  8027f4:	a1 34 50 80 00       	mov    0x805034,%eax
  8027f9:	85 c0                	test   %eax,%eax
  8027fb:	0f 85 bf fe ff ff    	jne    8026c0 <alloc_block_BF+0xc5>
  802801:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802805:	0f 85 b5 fe ff ff    	jne    8026c0 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80280b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80280f:	0f 84 26 02 00 00    	je     802a3b <alloc_block_BF+0x440>
  802815:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802819:	0f 85 1c 02 00 00    	jne    802a3b <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80281f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802822:	2b 45 08             	sub    0x8(%ebp),%eax
  802825:	83 e8 08             	sub    $0x8,%eax
  802828:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80282b:	8b 45 08             	mov    0x8(%ebp),%eax
  80282e:	8d 50 08             	lea    0x8(%eax),%edx
  802831:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802834:	01 d0                	add    %edx,%eax
  802836:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802839:	8b 45 08             	mov    0x8(%ebp),%eax
  80283c:	83 c0 08             	add    $0x8,%eax
  80283f:	83 ec 04             	sub    $0x4,%esp
  802842:	6a 01                	push   $0x1
  802844:	50                   	push   %eax
  802845:	ff 75 f0             	pushl  -0x10(%ebp)
  802848:	e8 c3 f8 ff ff       	call   802110 <set_block_data>
  80284d:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802850:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802853:	8b 40 04             	mov    0x4(%eax),%eax
  802856:	85 c0                	test   %eax,%eax
  802858:	75 68                	jne    8028c2 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80285a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80285e:	75 17                	jne    802877 <alloc_block_BF+0x27c>
  802860:	83 ec 04             	sub    $0x4,%esp
  802863:	68 e4 43 80 00       	push   $0x8043e4
  802868:	68 45 01 00 00       	push   $0x145
  80286d:	68 c9 43 80 00       	push   $0x8043c9
  802872:	e8 f0 d9 ff ff       	call   800267 <_panic>
  802877:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80287d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802880:	89 10                	mov    %edx,(%eax)
  802882:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802885:	8b 00                	mov    (%eax),%eax
  802887:	85 c0                	test   %eax,%eax
  802889:	74 0d                	je     802898 <alloc_block_BF+0x29d>
  80288b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802890:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802893:	89 50 04             	mov    %edx,0x4(%eax)
  802896:	eb 08                	jmp    8028a0 <alloc_block_BF+0x2a5>
  802898:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80289b:	a3 30 50 80 00       	mov    %eax,0x805030
  8028a0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028a3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028a8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b2:	a1 38 50 80 00       	mov    0x805038,%eax
  8028b7:	40                   	inc    %eax
  8028b8:	a3 38 50 80 00       	mov    %eax,0x805038
  8028bd:	e9 dc 00 00 00       	jmp    80299e <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8028c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c5:	8b 00                	mov    (%eax),%eax
  8028c7:	85 c0                	test   %eax,%eax
  8028c9:	75 65                	jne    802930 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028cb:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028cf:	75 17                	jne    8028e8 <alloc_block_BF+0x2ed>
  8028d1:	83 ec 04             	sub    $0x4,%esp
  8028d4:	68 18 44 80 00       	push   $0x804418
  8028d9:	68 4a 01 00 00       	push   $0x14a
  8028de:	68 c9 43 80 00       	push   $0x8043c9
  8028e3:	e8 7f d9 ff ff       	call   800267 <_panic>
  8028e8:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8028ee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028f1:	89 50 04             	mov    %edx,0x4(%eax)
  8028f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028f7:	8b 40 04             	mov    0x4(%eax),%eax
  8028fa:	85 c0                	test   %eax,%eax
  8028fc:	74 0c                	je     80290a <alloc_block_BF+0x30f>
  8028fe:	a1 30 50 80 00       	mov    0x805030,%eax
  802903:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802906:	89 10                	mov    %edx,(%eax)
  802908:	eb 08                	jmp    802912 <alloc_block_BF+0x317>
  80290a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80290d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802912:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802915:	a3 30 50 80 00       	mov    %eax,0x805030
  80291a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80291d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802923:	a1 38 50 80 00       	mov    0x805038,%eax
  802928:	40                   	inc    %eax
  802929:	a3 38 50 80 00       	mov    %eax,0x805038
  80292e:	eb 6e                	jmp    80299e <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802930:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802934:	74 06                	je     80293c <alloc_block_BF+0x341>
  802936:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80293a:	75 17                	jne    802953 <alloc_block_BF+0x358>
  80293c:	83 ec 04             	sub    $0x4,%esp
  80293f:	68 3c 44 80 00       	push   $0x80443c
  802944:	68 4f 01 00 00       	push   $0x14f
  802949:	68 c9 43 80 00       	push   $0x8043c9
  80294e:	e8 14 d9 ff ff       	call   800267 <_panic>
  802953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802956:	8b 10                	mov    (%eax),%edx
  802958:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80295b:	89 10                	mov    %edx,(%eax)
  80295d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802960:	8b 00                	mov    (%eax),%eax
  802962:	85 c0                	test   %eax,%eax
  802964:	74 0b                	je     802971 <alloc_block_BF+0x376>
  802966:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802969:	8b 00                	mov    (%eax),%eax
  80296b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80296e:	89 50 04             	mov    %edx,0x4(%eax)
  802971:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802974:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802977:	89 10                	mov    %edx,(%eax)
  802979:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80297c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80297f:	89 50 04             	mov    %edx,0x4(%eax)
  802982:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802985:	8b 00                	mov    (%eax),%eax
  802987:	85 c0                	test   %eax,%eax
  802989:	75 08                	jne    802993 <alloc_block_BF+0x398>
  80298b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80298e:	a3 30 50 80 00       	mov    %eax,0x805030
  802993:	a1 38 50 80 00       	mov    0x805038,%eax
  802998:	40                   	inc    %eax
  802999:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80299e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029a2:	75 17                	jne    8029bb <alloc_block_BF+0x3c0>
  8029a4:	83 ec 04             	sub    $0x4,%esp
  8029a7:	68 ab 43 80 00       	push   $0x8043ab
  8029ac:	68 51 01 00 00       	push   $0x151
  8029b1:	68 c9 43 80 00       	push   $0x8043c9
  8029b6:	e8 ac d8 ff ff       	call   800267 <_panic>
  8029bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029be:	8b 00                	mov    (%eax),%eax
  8029c0:	85 c0                	test   %eax,%eax
  8029c2:	74 10                	je     8029d4 <alloc_block_BF+0x3d9>
  8029c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c7:	8b 00                	mov    (%eax),%eax
  8029c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029cc:	8b 52 04             	mov    0x4(%edx),%edx
  8029cf:	89 50 04             	mov    %edx,0x4(%eax)
  8029d2:	eb 0b                	jmp    8029df <alloc_block_BF+0x3e4>
  8029d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d7:	8b 40 04             	mov    0x4(%eax),%eax
  8029da:	a3 30 50 80 00       	mov    %eax,0x805030
  8029df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e2:	8b 40 04             	mov    0x4(%eax),%eax
  8029e5:	85 c0                	test   %eax,%eax
  8029e7:	74 0f                	je     8029f8 <alloc_block_BF+0x3fd>
  8029e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ec:	8b 40 04             	mov    0x4(%eax),%eax
  8029ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029f2:	8b 12                	mov    (%edx),%edx
  8029f4:	89 10                	mov    %edx,(%eax)
  8029f6:	eb 0a                	jmp    802a02 <alloc_block_BF+0x407>
  8029f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fb:	8b 00                	mov    (%eax),%eax
  8029fd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a15:	a1 38 50 80 00       	mov    0x805038,%eax
  802a1a:	48                   	dec    %eax
  802a1b:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802a20:	83 ec 04             	sub    $0x4,%esp
  802a23:	6a 00                	push   $0x0
  802a25:	ff 75 d0             	pushl  -0x30(%ebp)
  802a28:	ff 75 cc             	pushl  -0x34(%ebp)
  802a2b:	e8 e0 f6 ff ff       	call   802110 <set_block_data>
  802a30:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a36:	e9 a3 01 00 00       	jmp    802bde <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802a3b:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802a3f:	0f 85 9d 00 00 00    	jne    802ae2 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802a45:	83 ec 04             	sub    $0x4,%esp
  802a48:	6a 01                	push   $0x1
  802a4a:	ff 75 ec             	pushl  -0x14(%ebp)
  802a4d:	ff 75 f0             	pushl  -0x10(%ebp)
  802a50:	e8 bb f6 ff ff       	call   802110 <set_block_data>
  802a55:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802a58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a5c:	75 17                	jne    802a75 <alloc_block_BF+0x47a>
  802a5e:	83 ec 04             	sub    $0x4,%esp
  802a61:	68 ab 43 80 00       	push   $0x8043ab
  802a66:	68 58 01 00 00       	push   $0x158
  802a6b:	68 c9 43 80 00       	push   $0x8043c9
  802a70:	e8 f2 d7 ff ff       	call   800267 <_panic>
  802a75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a78:	8b 00                	mov    (%eax),%eax
  802a7a:	85 c0                	test   %eax,%eax
  802a7c:	74 10                	je     802a8e <alloc_block_BF+0x493>
  802a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a81:	8b 00                	mov    (%eax),%eax
  802a83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a86:	8b 52 04             	mov    0x4(%edx),%edx
  802a89:	89 50 04             	mov    %edx,0x4(%eax)
  802a8c:	eb 0b                	jmp    802a99 <alloc_block_BF+0x49e>
  802a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a91:	8b 40 04             	mov    0x4(%eax),%eax
  802a94:	a3 30 50 80 00       	mov    %eax,0x805030
  802a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9c:	8b 40 04             	mov    0x4(%eax),%eax
  802a9f:	85 c0                	test   %eax,%eax
  802aa1:	74 0f                	je     802ab2 <alloc_block_BF+0x4b7>
  802aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa6:	8b 40 04             	mov    0x4(%eax),%eax
  802aa9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aac:	8b 12                	mov    (%edx),%edx
  802aae:	89 10                	mov    %edx,(%eax)
  802ab0:	eb 0a                	jmp    802abc <alloc_block_BF+0x4c1>
  802ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab5:	8b 00                	mov    (%eax),%eax
  802ab7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802acf:	a1 38 50 80 00       	mov    0x805038,%eax
  802ad4:	48                   	dec    %eax
  802ad5:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802add:	e9 fc 00 00 00       	jmp    802bde <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae5:	83 c0 08             	add    $0x8,%eax
  802ae8:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802aeb:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802af2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802af5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802af8:	01 d0                	add    %edx,%eax
  802afa:	48                   	dec    %eax
  802afb:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802afe:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b01:	ba 00 00 00 00       	mov    $0x0,%edx
  802b06:	f7 75 c4             	divl   -0x3c(%ebp)
  802b09:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b0c:	29 d0                	sub    %edx,%eax
  802b0e:	c1 e8 0c             	shr    $0xc,%eax
  802b11:	83 ec 0c             	sub    $0xc,%esp
  802b14:	50                   	push   %eax
  802b15:	e8 a4 e7 ff ff       	call   8012be <sbrk>
  802b1a:	83 c4 10             	add    $0x10,%esp
  802b1d:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802b20:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802b24:	75 0a                	jne    802b30 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802b26:	b8 00 00 00 00       	mov    $0x0,%eax
  802b2b:	e9 ae 00 00 00       	jmp    802bde <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b30:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802b37:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b3a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b3d:	01 d0                	add    %edx,%eax
  802b3f:	48                   	dec    %eax
  802b40:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802b43:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b46:	ba 00 00 00 00       	mov    $0x0,%edx
  802b4b:	f7 75 b8             	divl   -0x48(%ebp)
  802b4e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b51:	29 d0                	sub    %edx,%eax
  802b53:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b56:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b59:	01 d0                	add    %edx,%eax
  802b5b:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802b60:	a1 40 50 80 00       	mov    0x805040,%eax
  802b65:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802b6b:	83 ec 0c             	sub    $0xc,%esp
  802b6e:	68 70 44 80 00       	push   $0x804470
  802b73:	e8 ac d9 ff ff       	call   800524 <cprintf>
  802b78:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802b7b:	83 ec 08             	sub    $0x8,%esp
  802b7e:	ff 75 bc             	pushl  -0x44(%ebp)
  802b81:	68 75 44 80 00       	push   $0x804475
  802b86:	e8 99 d9 ff ff       	call   800524 <cprintf>
  802b8b:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802b8e:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802b95:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b98:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b9b:	01 d0                	add    %edx,%eax
  802b9d:	48                   	dec    %eax
  802b9e:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802ba1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ba4:	ba 00 00 00 00       	mov    $0x0,%edx
  802ba9:	f7 75 b0             	divl   -0x50(%ebp)
  802bac:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802baf:	29 d0                	sub    %edx,%eax
  802bb1:	83 ec 04             	sub    $0x4,%esp
  802bb4:	6a 01                	push   $0x1
  802bb6:	50                   	push   %eax
  802bb7:	ff 75 bc             	pushl  -0x44(%ebp)
  802bba:	e8 51 f5 ff ff       	call   802110 <set_block_data>
  802bbf:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802bc2:	83 ec 0c             	sub    $0xc,%esp
  802bc5:	ff 75 bc             	pushl  -0x44(%ebp)
  802bc8:	e8 36 04 00 00       	call   803003 <free_block>
  802bcd:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802bd0:	83 ec 0c             	sub    $0xc,%esp
  802bd3:	ff 75 08             	pushl  0x8(%ebp)
  802bd6:	e8 20 fa ff ff       	call   8025fb <alloc_block_BF>
  802bdb:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802bde:	c9                   	leave  
  802bdf:	c3                   	ret    

00802be0 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802be0:	55                   	push   %ebp
  802be1:	89 e5                	mov    %esp,%ebp
  802be3:	53                   	push   %ebx
  802be4:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802be7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802bee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802bf5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bf9:	74 1e                	je     802c19 <merging+0x39>
  802bfb:	ff 75 08             	pushl  0x8(%ebp)
  802bfe:	e8 bc f1 ff ff       	call   801dbf <get_block_size>
  802c03:	83 c4 04             	add    $0x4,%esp
  802c06:	89 c2                	mov    %eax,%edx
  802c08:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0b:	01 d0                	add    %edx,%eax
  802c0d:	3b 45 10             	cmp    0x10(%ebp),%eax
  802c10:	75 07                	jne    802c19 <merging+0x39>
		prev_is_free = 1;
  802c12:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802c19:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c1d:	74 1e                	je     802c3d <merging+0x5d>
  802c1f:	ff 75 10             	pushl  0x10(%ebp)
  802c22:	e8 98 f1 ff ff       	call   801dbf <get_block_size>
  802c27:	83 c4 04             	add    $0x4,%esp
  802c2a:	89 c2                	mov    %eax,%edx
  802c2c:	8b 45 10             	mov    0x10(%ebp),%eax
  802c2f:	01 d0                	add    %edx,%eax
  802c31:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c34:	75 07                	jne    802c3d <merging+0x5d>
		next_is_free = 1;
  802c36:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802c3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c41:	0f 84 cc 00 00 00    	je     802d13 <merging+0x133>
  802c47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c4b:	0f 84 c2 00 00 00    	je     802d13 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802c51:	ff 75 08             	pushl  0x8(%ebp)
  802c54:	e8 66 f1 ff ff       	call   801dbf <get_block_size>
  802c59:	83 c4 04             	add    $0x4,%esp
  802c5c:	89 c3                	mov    %eax,%ebx
  802c5e:	ff 75 10             	pushl  0x10(%ebp)
  802c61:	e8 59 f1 ff ff       	call   801dbf <get_block_size>
  802c66:	83 c4 04             	add    $0x4,%esp
  802c69:	01 c3                	add    %eax,%ebx
  802c6b:	ff 75 0c             	pushl  0xc(%ebp)
  802c6e:	e8 4c f1 ff ff       	call   801dbf <get_block_size>
  802c73:	83 c4 04             	add    $0x4,%esp
  802c76:	01 d8                	add    %ebx,%eax
  802c78:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802c7b:	6a 00                	push   $0x0
  802c7d:	ff 75 ec             	pushl  -0x14(%ebp)
  802c80:	ff 75 08             	pushl  0x8(%ebp)
  802c83:	e8 88 f4 ff ff       	call   802110 <set_block_data>
  802c88:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802c8b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c8f:	75 17                	jne    802ca8 <merging+0xc8>
  802c91:	83 ec 04             	sub    $0x4,%esp
  802c94:	68 ab 43 80 00       	push   $0x8043ab
  802c99:	68 7d 01 00 00       	push   $0x17d
  802c9e:	68 c9 43 80 00       	push   $0x8043c9
  802ca3:	e8 bf d5 ff ff       	call   800267 <_panic>
  802ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cab:	8b 00                	mov    (%eax),%eax
  802cad:	85 c0                	test   %eax,%eax
  802caf:	74 10                	je     802cc1 <merging+0xe1>
  802cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cb4:	8b 00                	mov    (%eax),%eax
  802cb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cb9:	8b 52 04             	mov    0x4(%edx),%edx
  802cbc:	89 50 04             	mov    %edx,0x4(%eax)
  802cbf:	eb 0b                	jmp    802ccc <merging+0xec>
  802cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cc4:	8b 40 04             	mov    0x4(%eax),%eax
  802cc7:	a3 30 50 80 00       	mov    %eax,0x805030
  802ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ccf:	8b 40 04             	mov    0x4(%eax),%eax
  802cd2:	85 c0                	test   %eax,%eax
  802cd4:	74 0f                	je     802ce5 <merging+0x105>
  802cd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cd9:	8b 40 04             	mov    0x4(%eax),%eax
  802cdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cdf:	8b 12                	mov    (%edx),%edx
  802ce1:	89 10                	mov    %edx,(%eax)
  802ce3:	eb 0a                	jmp    802cef <merging+0x10f>
  802ce5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ce8:	8b 00                	mov    (%eax),%eax
  802cea:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cef:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cf2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cfb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d02:	a1 38 50 80 00       	mov    0x805038,%eax
  802d07:	48                   	dec    %eax
  802d08:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802d0d:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d0e:	e9 ea 02 00 00       	jmp    802ffd <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802d13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d17:	74 3b                	je     802d54 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802d19:	83 ec 0c             	sub    $0xc,%esp
  802d1c:	ff 75 08             	pushl  0x8(%ebp)
  802d1f:	e8 9b f0 ff ff       	call   801dbf <get_block_size>
  802d24:	83 c4 10             	add    $0x10,%esp
  802d27:	89 c3                	mov    %eax,%ebx
  802d29:	83 ec 0c             	sub    $0xc,%esp
  802d2c:	ff 75 10             	pushl  0x10(%ebp)
  802d2f:	e8 8b f0 ff ff       	call   801dbf <get_block_size>
  802d34:	83 c4 10             	add    $0x10,%esp
  802d37:	01 d8                	add    %ebx,%eax
  802d39:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d3c:	83 ec 04             	sub    $0x4,%esp
  802d3f:	6a 00                	push   $0x0
  802d41:	ff 75 e8             	pushl  -0x18(%ebp)
  802d44:	ff 75 08             	pushl  0x8(%ebp)
  802d47:	e8 c4 f3 ff ff       	call   802110 <set_block_data>
  802d4c:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d4f:	e9 a9 02 00 00       	jmp    802ffd <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802d54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d58:	0f 84 2d 01 00 00    	je     802e8b <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802d5e:	83 ec 0c             	sub    $0xc,%esp
  802d61:	ff 75 10             	pushl  0x10(%ebp)
  802d64:	e8 56 f0 ff ff       	call   801dbf <get_block_size>
  802d69:	83 c4 10             	add    $0x10,%esp
  802d6c:	89 c3                	mov    %eax,%ebx
  802d6e:	83 ec 0c             	sub    $0xc,%esp
  802d71:	ff 75 0c             	pushl  0xc(%ebp)
  802d74:	e8 46 f0 ff ff       	call   801dbf <get_block_size>
  802d79:	83 c4 10             	add    $0x10,%esp
  802d7c:	01 d8                	add    %ebx,%eax
  802d7e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802d81:	83 ec 04             	sub    $0x4,%esp
  802d84:	6a 00                	push   $0x0
  802d86:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d89:	ff 75 10             	pushl  0x10(%ebp)
  802d8c:	e8 7f f3 ff ff       	call   802110 <set_block_data>
  802d91:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802d94:	8b 45 10             	mov    0x10(%ebp),%eax
  802d97:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802d9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d9e:	74 06                	je     802da6 <merging+0x1c6>
  802da0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802da4:	75 17                	jne    802dbd <merging+0x1dd>
  802da6:	83 ec 04             	sub    $0x4,%esp
  802da9:	68 84 44 80 00       	push   $0x804484
  802dae:	68 8d 01 00 00       	push   $0x18d
  802db3:	68 c9 43 80 00       	push   $0x8043c9
  802db8:	e8 aa d4 ff ff       	call   800267 <_panic>
  802dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dc0:	8b 50 04             	mov    0x4(%eax),%edx
  802dc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dc6:	89 50 04             	mov    %edx,0x4(%eax)
  802dc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dcf:	89 10                	mov    %edx,(%eax)
  802dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dd4:	8b 40 04             	mov    0x4(%eax),%eax
  802dd7:	85 c0                	test   %eax,%eax
  802dd9:	74 0d                	je     802de8 <merging+0x208>
  802ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dde:	8b 40 04             	mov    0x4(%eax),%eax
  802de1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802de4:	89 10                	mov    %edx,(%eax)
  802de6:	eb 08                	jmp    802df0 <merging+0x210>
  802de8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802deb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802df0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802df6:	89 50 04             	mov    %edx,0x4(%eax)
  802df9:	a1 38 50 80 00       	mov    0x805038,%eax
  802dfe:	40                   	inc    %eax
  802dff:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802e04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e08:	75 17                	jne    802e21 <merging+0x241>
  802e0a:	83 ec 04             	sub    $0x4,%esp
  802e0d:	68 ab 43 80 00       	push   $0x8043ab
  802e12:	68 8e 01 00 00       	push   $0x18e
  802e17:	68 c9 43 80 00       	push   $0x8043c9
  802e1c:	e8 46 d4 ff ff       	call   800267 <_panic>
  802e21:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e24:	8b 00                	mov    (%eax),%eax
  802e26:	85 c0                	test   %eax,%eax
  802e28:	74 10                	je     802e3a <merging+0x25a>
  802e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e2d:	8b 00                	mov    (%eax),%eax
  802e2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e32:	8b 52 04             	mov    0x4(%edx),%edx
  802e35:	89 50 04             	mov    %edx,0x4(%eax)
  802e38:	eb 0b                	jmp    802e45 <merging+0x265>
  802e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e3d:	8b 40 04             	mov    0x4(%eax),%eax
  802e40:	a3 30 50 80 00       	mov    %eax,0x805030
  802e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e48:	8b 40 04             	mov    0x4(%eax),%eax
  802e4b:	85 c0                	test   %eax,%eax
  802e4d:	74 0f                	je     802e5e <merging+0x27e>
  802e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e52:	8b 40 04             	mov    0x4(%eax),%eax
  802e55:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e58:	8b 12                	mov    (%edx),%edx
  802e5a:	89 10                	mov    %edx,(%eax)
  802e5c:	eb 0a                	jmp    802e68 <merging+0x288>
  802e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e61:	8b 00                	mov    (%eax),%eax
  802e63:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e7b:	a1 38 50 80 00       	mov    0x805038,%eax
  802e80:	48                   	dec    %eax
  802e81:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e86:	e9 72 01 00 00       	jmp    802ffd <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  802e8e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802e91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e95:	74 79                	je     802f10 <merging+0x330>
  802e97:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e9b:	74 73                	je     802f10 <merging+0x330>
  802e9d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ea1:	74 06                	je     802ea9 <merging+0x2c9>
  802ea3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ea7:	75 17                	jne    802ec0 <merging+0x2e0>
  802ea9:	83 ec 04             	sub    $0x4,%esp
  802eac:	68 3c 44 80 00       	push   $0x80443c
  802eb1:	68 94 01 00 00       	push   $0x194
  802eb6:	68 c9 43 80 00       	push   $0x8043c9
  802ebb:	e8 a7 d3 ff ff       	call   800267 <_panic>
  802ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec3:	8b 10                	mov    (%eax),%edx
  802ec5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ec8:	89 10                	mov    %edx,(%eax)
  802eca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ecd:	8b 00                	mov    (%eax),%eax
  802ecf:	85 c0                	test   %eax,%eax
  802ed1:	74 0b                	je     802ede <merging+0x2fe>
  802ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed6:	8b 00                	mov    (%eax),%eax
  802ed8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802edb:	89 50 04             	mov    %edx,0x4(%eax)
  802ede:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ee4:	89 10                	mov    %edx,(%eax)
  802ee6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ee9:	8b 55 08             	mov    0x8(%ebp),%edx
  802eec:	89 50 04             	mov    %edx,0x4(%eax)
  802eef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ef2:	8b 00                	mov    (%eax),%eax
  802ef4:	85 c0                	test   %eax,%eax
  802ef6:	75 08                	jne    802f00 <merging+0x320>
  802ef8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802efb:	a3 30 50 80 00       	mov    %eax,0x805030
  802f00:	a1 38 50 80 00       	mov    0x805038,%eax
  802f05:	40                   	inc    %eax
  802f06:	a3 38 50 80 00       	mov    %eax,0x805038
  802f0b:	e9 ce 00 00 00       	jmp    802fde <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802f10:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f14:	74 65                	je     802f7b <merging+0x39b>
  802f16:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f1a:	75 17                	jne    802f33 <merging+0x353>
  802f1c:	83 ec 04             	sub    $0x4,%esp
  802f1f:	68 18 44 80 00       	push   $0x804418
  802f24:	68 95 01 00 00       	push   $0x195
  802f29:	68 c9 43 80 00       	push   $0x8043c9
  802f2e:	e8 34 d3 ff ff       	call   800267 <_panic>
  802f33:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f39:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f3c:	89 50 04             	mov    %edx,0x4(%eax)
  802f3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f42:	8b 40 04             	mov    0x4(%eax),%eax
  802f45:	85 c0                	test   %eax,%eax
  802f47:	74 0c                	je     802f55 <merging+0x375>
  802f49:	a1 30 50 80 00       	mov    0x805030,%eax
  802f4e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f51:	89 10                	mov    %edx,(%eax)
  802f53:	eb 08                	jmp    802f5d <merging+0x37d>
  802f55:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f58:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f60:	a3 30 50 80 00       	mov    %eax,0x805030
  802f65:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f6e:	a1 38 50 80 00       	mov    0x805038,%eax
  802f73:	40                   	inc    %eax
  802f74:	a3 38 50 80 00       	mov    %eax,0x805038
  802f79:	eb 63                	jmp    802fde <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802f7b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f7f:	75 17                	jne    802f98 <merging+0x3b8>
  802f81:	83 ec 04             	sub    $0x4,%esp
  802f84:	68 e4 43 80 00       	push   $0x8043e4
  802f89:	68 98 01 00 00       	push   $0x198
  802f8e:	68 c9 43 80 00       	push   $0x8043c9
  802f93:	e8 cf d2 ff ff       	call   800267 <_panic>
  802f98:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802f9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa1:	89 10                	mov    %edx,(%eax)
  802fa3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa6:	8b 00                	mov    (%eax),%eax
  802fa8:	85 c0                	test   %eax,%eax
  802faa:	74 0d                	je     802fb9 <merging+0x3d9>
  802fac:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fb1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fb4:	89 50 04             	mov    %edx,0x4(%eax)
  802fb7:	eb 08                	jmp    802fc1 <merging+0x3e1>
  802fb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fbc:	a3 30 50 80 00       	mov    %eax,0x805030
  802fc1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fc4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fc9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fcc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd3:	a1 38 50 80 00       	mov    0x805038,%eax
  802fd8:	40                   	inc    %eax
  802fd9:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802fde:	83 ec 0c             	sub    $0xc,%esp
  802fe1:	ff 75 10             	pushl  0x10(%ebp)
  802fe4:	e8 d6 ed ff ff       	call   801dbf <get_block_size>
  802fe9:	83 c4 10             	add    $0x10,%esp
  802fec:	83 ec 04             	sub    $0x4,%esp
  802fef:	6a 00                	push   $0x0
  802ff1:	50                   	push   %eax
  802ff2:	ff 75 10             	pushl  0x10(%ebp)
  802ff5:	e8 16 f1 ff ff       	call   802110 <set_block_data>
  802ffa:	83 c4 10             	add    $0x10,%esp
	}
}
  802ffd:	90                   	nop
  802ffe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803001:	c9                   	leave  
  803002:	c3                   	ret    

00803003 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803003:	55                   	push   %ebp
  803004:	89 e5                	mov    %esp,%ebp
  803006:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803009:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80300e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803011:	a1 30 50 80 00       	mov    0x805030,%eax
  803016:	3b 45 08             	cmp    0x8(%ebp),%eax
  803019:	73 1b                	jae    803036 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80301b:	a1 30 50 80 00       	mov    0x805030,%eax
  803020:	83 ec 04             	sub    $0x4,%esp
  803023:	ff 75 08             	pushl  0x8(%ebp)
  803026:	6a 00                	push   $0x0
  803028:	50                   	push   %eax
  803029:	e8 b2 fb ff ff       	call   802be0 <merging>
  80302e:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803031:	e9 8b 00 00 00       	jmp    8030c1 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803036:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80303b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80303e:	76 18                	jbe    803058 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803040:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803045:	83 ec 04             	sub    $0x4,%esp
  803048:	ff 75 08             	pushl  0x8(%ebp)
  80304b:	50                   	push   %eax
  80304c:	6a 00                	push   $0x0
  80304e:	e8 8d fb ff ff       	call   802be0 <merging>
  803053:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803056:	eb 69                	jmp    8030c1 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803058:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80305d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803060:	eb 39                	jmp    80309b <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803065:	3b 45 08             	cmp    0x8(%ebp),%eax
  803068:	73 29                	jae    803093 <free_block+0x90>
  80306a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306d:	8b 00                	mov    (%eax),%eax
  80306f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803072:	76 1f                	jbe    803093 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803074:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803077:	8b 00                	mov    (%eax),%eax
  803079:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80307c:	83 ec 04             	sub    $0x4,%esp
  80307f:	ff 75 08             	pushl  0x8(%ebp)
  803082:	ff 75 f0             	pushl  -0x10(%ebp)
  803085:	ff 75 f4             	pushl  -0xc(%ebp)
  803088:	e8 53 fb ff ff       	call   802be0 <merging>
  80308d:	83 c4 10             	add    $0x10,%esp
			break;
  803090:	90                   	nop
		}
	}
}
  803091:	eb 2e                	jmp    8030c1 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803093:	a1 34 50 80 00       	mov    0x805034,%eax
  803098:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80309b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80309f:	74 07                	je     8030a8 <free_block+0xa5>
  8030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a4:	8b 00                	mov    (%eax),%eax
  8030a6:	eb 05                	jmp    8030ad <free_block+0xaa>
  8030a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ad:	a3 34 50 80 00       	mov    %eax,0x805034
  8030b2:	a1 34 50 80 00       	mov    0x805034,%eax
  8030b7:	85 c0                	test   %eax,%eax
  8030b9:	75 a7                	jne    803062 <free_block+0x5f>
  8030bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030bf:	75 a1                	jne    803062 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030c1:	90                   	nop
  8030c2:	c9                   	leave  
  8030c3:	c3                   	ret    

008030c4 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8030c4:	55                   	push   %ebp
  8030c5:	89 e5                	mov    %esp,%ebp
  8030c7:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8030ca:	ff 75 08             	pushl  0x8(%ebp)
  8030cd:	e8 ed ec ff ff       	call   801dbf <get_block_size>
  8030d2:	83 c4 04             	add    $0x4,%esp
  8030d5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8030d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8030df:	eb 17                	jmp    8030f8 <copy_data+0x34>
  8030e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8030e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030e7:	01 c2                	add    %eax,%edx
  8030e9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8030ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ef:	01 c8                	add    %ecx,%eax
  8030f1:	8a 00                	mov    (%eax),%al
  8030f3:	88 02                	mov    %al,(%edx)
  8030f5:	ff 45 fc             	incl   -0x4(%ebp)
  8030f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8030fe:	72 e1                	jb     8030e1 <copy_data+0x1d>
}
  803100:	90                   	nop
  803101:	c9                   	leave  
  803102:	c3                   	ret    

00803103 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803103:	55                   	push   %ebp
  803104:	89 e5                	mov    %esp,%ebp
  803106:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803109:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80310d:	75 23                	jne    803132 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80310f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803113:	74 13                	je     803128 <realloc_block_FF+0x25>
  803115:	83 ec 0c             	sub    $0xc,%esp
  803118:	ff 75 0c             	pushl  0xc(%ebp)
  80311b:	e8 1f f0 ff ff       	call   80213f <alloc_block_FF>
  803120:	83 c4 10             	add    $0x10,%esp
  803123:	e9 f4 06 00 00       	jmp    80381c <realloc_block_FF+0x719>
		return NULL;
  803128:	b8 00 00 00 00       	mov    $0x0,%eax
  80312d:	e9 ea 06 00 00       	jmp    80381c <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803132:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803136:	75 18                	jne    803150 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803138:	83 ec 0c             	sub    $0xc,%esp
  80313b:	ff 75 08             	pushl  0x8(%ebp)
  80313e:	e8 c0 fe ff ff       	call   803003 <free_block>
  803143:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803146:	b8 00 00 00 00       	mov    $0x0,%eax
  80314b:	e9 cc 06 00 00       	jmp    80381c <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803150:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803154:	77 07                	ja     80315d <realloc_block_FF+0x5a>
  803156:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80315d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803160:	83 e0 01             	and    $0x1,%eax
  803163:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803166:	8b 45 0c             	mov    0xc(%ebp),%eax
  803169:	83 c0 08             	add    $0x8,%eax
  80316c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80316f:	83 ec 0c             	sub    $0xc,%esp
  803172:	ff 75 08             	pushl  0x8(%ebp)
  803175:	e8 45 ec ff ff       	call   801dbf <get_block_size>
  80317a:	83 c4 10             	add    $0x10,%esp
  80317d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803180:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803183:	83 e8 08             	sub    $0x8,%eax
  803186:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803189:	8b 45 08             	mov    0x8(%ebp),%eax
  80318c:	83 e8 04             	sub    $0x4,%eax
  80318f:	8b 00                	mov    (%eax),%eax
  803191:	83 e0 fe             	and    $0xfffffffe,%eax
  803194:	89 c2                	mov    %eax,%edx
  803196:	8b 45 08             	mov    0x8(%ebp),%eax
  803199:	01 d0                	add    %edx,%eax
  80319b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80319e:	83 ec 0c             	sub    $0xc,%esp
  8031a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031a4:	e8 16 ec ff ff       	call   801dbf <get_block_size>
  8031a9:	83 c4 10             	add    $0x10,%esp
  8031ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031b2:	83 e8 08             	sub    $0x8,%eax
  8031b5:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8031b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031bb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8031be:	75 08                	jne    8031c8 <realloc_block_FF+0xc5>
	{
		 return va;
  8031c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c3:	e9 54 06 00 00       	jmp    80381c <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8031c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031cb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8031ce:	0f 83 e5 03 00 00    	jae    8035b9 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8031d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d7:	2b 45 0c             	sub    0xc(%ebp),%eax
  8031da:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8031dd:	83 ec 0c             	sub    $0xc,%esp
  8031e0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031e3:	e8 f0 eb ff ff       	call   801dd8 <is_free_block>
  8031e8:	83 c4 10             	add    $0x10,%esp
  8031eb:	84 c0                	test   %al,%al
  8031ed:	0f 84 3b 01 00 00    	je     80332e <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8031f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031f9:	01 d0                	add    %edx,%eax
  8031fb:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8031fe:	83 ec 04             	sub    $0x4,%esp
  803201:	6a 01                	push   $0x1
  803203:	ff 75 f0             	pushl  -0x10(%ebp)
  803206:	ff 75 08             	pushl  0x8(%ebp)
  803209:	e8 02 ef ff ff       	call   802110 <set_block_data>
  80320e:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803211:	8b 45 08             	mov    0x8(%ebp),%eax
  803214:	83 e8 04             	sub    $0x4,%eax
  803217:	8b 00                	mov    (%eax),%eax
  803219:	83 e0 fe             	and    $0xfffffffe,%eax
  80321c:	89 c2                	mov    %eax,%edx
  80321e:	8b 45 08             	mov    0x8(%ebp),%eax
  803221:	01 d0                	add    %edx,%eax
  803223:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803226:	83 ec 04             	sub    $0x4,%esp
  803229:	6a 00                	push   $0x0
  80322b:	ff 75 cc             	pushl  -0x34(%ebp)
  80322e:	ff 75 c8             	pushl  -0x38(%ebp)
  803231:	e8 da ee ff ff       	call   802110 <set_block_data>
  803236:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803239:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80323d:	74 06                	je     803245 <realloc_block_FF+0x142>
  80323f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803243:	75 17                	jne    80325c <realloc_block_FF+0x159>
  803245:	83 ec 04             	sub    $0x4,%esp
  803248:	68 3c 44 80 00       	push   $0x80443c
  80324d:	68 f6 01 00 00       	push   $0x1f6
  803252:	68 c9 43 80 00       	push   $0x8043c9
  803257:	e8 0b d0 ff ff       	call   800267 <_panic>
  80325c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80325f:	8b 10                	mov    (%eax),%edx
  803261:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803264:	89 10                	mov    %edx,(%eax)
  803266:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803269:	8b 00                	mov    (%eax),%eax
  80326b:	85 c0                	test   %eax,%eax
  80326d:	74 0b                	je     80327a <realloc_block_FF+0x177>
  80326f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803272:	8b 00                	mov    (%eax),%eax
  803274:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803277:	89 50 04             	mov    %edx,0x4(%eax)
  80327a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80327d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803280:	89 10                	mov    %edx,(%eax)
  803282:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803285:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803288:	89 50 04             	mov    %edx,0x4(%eax)
  80328b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80328e:	8b 00                	mov    (%eax),%eax
  803290:	85 c0                	test   %eax,%eax
  803292:	75 08                	jne    80329c <realloc_block_FF+0x199>
  803294:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803297:	a3 30 50 80 00       	mov    %eax,0x805030
  80329c:	a1 38 50 80 00       	mov    0x805038,%eax
  8032a1:	40                   	inc    %eax
  8032a2:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8032a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032ab:	75 17                	jne    8032c4 <realloc_block_FF+0x1c1>
  8032ad:	83 ec 04             	sub    $0x4,%esp
  8032b0:	68 ab 43 80 00       	push   $0x8043ab
  8032b5:	68 f7 01 00 00       	push   $0x1f7
  8032ba:	68 c9 43 80 00       	push   $0x8043c9
  8032bf:	e8 a3 cf ff ff       	call   800267 <_panic>
  8032c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032c7:	8b 00                	mov    (%eax),%eax
  8032c9:	85 c0                	test   %eax,%eax
  8032cb:	74 10                	je     8032dd <realloc_block_FF+0x1da>
  8032cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d0:	8b 00                	mov    (%eax),%eax
  8032d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032d5:	8b 52 04             	mov    0x4(%edx),%edx
  8032d8:	89 50 04             	mov    %edx,0x4(%eax)
  8032db:	eb 0b                	jmp    8032e8 <realloc_block_FF+0x1e5>
  8032dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e0:	8b 40 04             	mov    0x4(%eax),%eax
  8032e3:	a3 30 50 80 00       	mov    %eax,0x805030
  8032e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032eb:	8b 40 04             	mov    0x4(%eax),%eax
  8032ee:	85 c0                	test   %eax,%eax
  8032f0:	74 0f                	je     803301 <realloc_block_FF+0x1fe>
  8032f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032f5:	8b 40 04             	mov    0x4(%eax),%eax
  8032f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032fb:	8b 12                	mov    (%edx),%edx
  8032fd:	89 10                	mov    %edx,(%eax)
  8032ff:	eb 0a                	jmp    80330b <realloc_block_FF+0x208>
  803301:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803304:	8b 00                	mov    (%eax),%eax
  803306:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80330b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80330e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803314:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803317:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80331e:	a1 38 50 80 00       	mov    0x805038,%eax
  803323:	48                   	dec    %eax
  803324:	a3 38 50 80 00       	mov    %eax,0x805038
  803329:	e9 83 02 00 00       	jmp    8035b1 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80332e:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803332:	0f 86 69 02 00 00    	jbe    8035a1 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803338:	83 ec 04             	sub    $0x4,%esp
  80333b:	6a 01                	push   $0x1
  80333d:	ff 75 f0             	pushl  -0x10(%ebp)
  803340:	ff 75 08             	pushl  0x8(%ebp)
  803343:	e8 c8 ed ff ff       	call   802110 <set_block_data>
  803348:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80334b:	8b 45 08             	mov    0x8(%ebp),%eax
  80334e:	83 e8 04             	sub    $0x4,%eax
  803351:	8b 00                	mov    (%eax),%eax
  803353:	83 e0 fe             	and    $0xfffffffe,%eax
  803356:	89 c2                	mov    %eax,%edx
  803358:	8b 45 08             	mov    0x8(%ebp),%eax
  80335b:	01 d0                	add    %edx,%eax
  80335d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803360:	a1 38 50 80 00       	mov    0x805038,%eax
  803365:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803368:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80336c:	75 68                	jne    8033d6 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80336e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803372:	75 17                	jne    80338b <realloc_block_FF+0x288>
  803374:	83 ec 04             	sub    $0x4,%esp
  803377:	68 e4 43 80 00       	push   $0x8043e4
  80337c:	68 06 02 00 00       	push   $0x206
  803381:	68 c9 43 80 00       	push   $0x8043c9
  803386:	e8 dc ce ff ff       	call   800267 <_panic>
  80338b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803391:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803394:	89 10                	mov    %edx,(%eax)
  803396:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803399:	8b 00                	mov    (%eax),%eax
  80339b:	85 c0                	test   %eax,%eax
  80339d:	74 0d                	je     8033ac <realloc_block_FF+0x2a9>
  80339f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033a7:	89 50 04             	mov    %edx,0x4(%eax)
  8033aa:	eb 08                	jmp    8033b4 <realloc_block_FF+0x2b1>
  8033ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033af:	a3 30 50 80 00       	mov    %eax,0x805030
  8033b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033b7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c6:	a1 38 50 80 00       	mov    0x805038,%eax
  8033cb:	40                   	inc    %eax
  8033cc:	a3 38 50 80 00       	mov    %eax,0x805038
  8033d1:	e9 b0 01 00 00       	jmp    803586 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8033d6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033db:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8033de:	76 68                	jbe    803448 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8033e0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033e4:	75 17                	jne    8033fd <realloc_block_FF+0x2fa>
  8033e6:	83 ec 04             	sub    $0x4,%esp
  8033e9:	68 e4 43 80 00       	push   $0x8043e4
  8033ee:	68 0b 02 00 00       	push   $0x20b
  8033f3:	68 c9 43 80 00       	push   $0x8043c9
  8033f8:	e8 6a ce ff ff       	call   800267 <_panic>
  8033fd:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803403:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803406:	89 10                	mov    %edx,(%eax)
  803408:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80340b:	8b 00                	mov    (%eax),%eax
  80340d:	85 c0                	test   %eax,%eax
  80340f:	74 0d                	je     80341e <realloc_block_FF+0x31b>
  803411:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803416:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803419:	89 50 04             	mov    %edx,0x4(%eax)
  80341c:	eb 08                	jmp    803426 <realloc_block_FF+0x323>
  80341e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803421:	a3 30 50 80 00       	mov    %eax,0x805030
  803426:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803429:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80342e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803431:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803438:	a1 38 50 80 00       	mov    0x805038,%eax
  80343d:	40                   	inc    %eax
  80343e:	a3 38 50 80 00       	mov    %eax,0x805038
  803443:	e9 3e 01 00 00       	jmp    803586 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803448:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80344d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803450:	73 68                	jae    8034ba <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803452:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803456:	75 17                	jne    80346f <realloc_block_FF+0x36c>
  803458:	83 ec 04             	sub    $0x4,%esp
  80345b:	68 18 44 80 00       	push   $0x804418
  803460:	68 10 02 00 00       	push   $0x210
  803465:	68 c9 43 80 00       	push   $0x8043c9
  80346a:	e8 f8 cd ff ff       	call   800267 <_panic>
  80346f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803475:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803478:	89 50 04             	mov    %edx,0x4(%eax)
  80347b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80347e:	8b 40 04             	mov    0x4(%eax),%eax
  803481:	85 c0                	test   %eax,%eax
  803483:	74 0c                	je     803491 <realloc_block_FF+0x38e>
  803485:	a1 30 50 80 00       	mov    0x805030,%eax
  80348a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80348d:	89 10                	mov    %edx,(%eax)
  80348f:	eb 08                	jmp    803499 <realloc_block_FF+0x396>
  803491:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803494:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803499:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80349c:	a3 30 50 80 00       	mov    %eax,0x805030
  8034a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034aa:	a1 38 50 80 00       	mov    0x805038,%eax
  8034af:	40                   	inc    %eax
  8034b0:	a3 38 50 80 00       	mov    %eax,0x805038
  8034b5:	e9 cc 00 00 00       	jmp    803586 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8034ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8034c1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034c9:	e9 8a 00 00 00       	jmp    803558 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8034ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034d4:	73 7a                	jae    803550 <realloc_block_FF+0x44d>
  8034d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d9:	8b 00                	mov    (%eax),%eax
  8034db:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034de:	73 70                	jae    803550 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8034e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e4:	74 06                	je     8034ec <realloc_block_FF+0x3e9>
  8034e6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034ea:	75 17                	jne    803503 <realloc_block_FF+0x400>
  8034ec:	83 ec 04             	sub    $0x4,%esp
  8034ef:	68 3c 44 80 00       	push   $0x80443c
  8034f4:	68 1a 02 00 00       	push   $0x21a
  8034f9:	68 c9 43 80 00       	push   $0x8043c9
  8034fe:	e8 64 cd ff ff       	call   800267 <_panic>
  803503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803506:	8b 10                	mov    (%eax),%edx
  803508:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80350b:	89 10                	mov    %edx,(%eax)
  80350d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803510:	8b 00                	mov    (%eax),%eax
  803512:	85 c0                	test   %eax,%eax
  803514:	74 0b                	je     803521 <realloc_block_FF+0x41e>
  803516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803519:	8b 00                	mov    (%eax),%eax
  80351b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80351e:	89 50 04             	mov    %edx,0x4(%eax)
  803521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803524:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803527:	89 10                	mov    %edx,(%eax)
  803529:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80352c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80352f:	89 50 04             	mov    %edx,0x4(%eax)
  803532:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803535:	8b 00                	mov    (%eax),%eax
  803537:	85 c0                	test   %eax,%eax
  803539:	75 08                	jne    803543 <realloc_block_FF+0x440>
  80353b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80353e:	a3 30 50 80 00       	mov    %eax,0x805030
  803543:	a1 38 50 80 00       	mov    0x805038,%eax
  803548:	40                   	inc    %eax
  803549:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80354e:	eb 36                	jmp    803586 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803550:	a1 34 50 80 00       	mov    0x805034,%eax
  803555:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803558:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80355c:	74 07                	je     803565 <realloc_block_FF+0x462>
  80355e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803561:	8b 00                	mov    (%eax),%eax
  803563:	eb 05                	jmp    80356a <realloc_block_FF+0x467>
  803565:	b8 00 00 00 00       	mov    $0x0,%eax
  80356a:	a3 34 50 80 00       	mov    %eax,0x805034
  80356f:	a1 34 50 80 00       	mov    0x805034,%eax
  803574:	85 c0                	test   %eax,%eax
  803576:	0f 85 52 ff ff ff    	jne    8034ce <realloc_block_FF+0x3cb>
  80357c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803580:	0f 85 48 ff ff ff    	jne    8034ce <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803586:	83 ec 04             	sub    $0x4,%esp
  803589:	6a 00                	push   $0x0
  80358b:	ff 75 d8             	pushl  -0x28(%ebp)
  80358e:	ff 75 d4             	pushl  -0x2c(%ebp)
  803591:	e8 7a eb ff ff       	call   802110 <set_block_data>
  803596:	83 c4 10             	add    $0x10,%esp
				return va;
  803599:	8b 45 08             	mov    0x8(%ebp),%eax
  80359c:	e9 7b 02 00 00       	jmp    80381c <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8035a1:	83 ec 0c             	sub    $0xc,%esp
  8035a4:	68 b9 44 80 00       	push   $0x8044b9
  8035a9:	e8 76 cf ff ff       	call   800524 <cprintf>
  8035ae:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8035b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b4:	e9 63 02 00 00       	jmp    80381c <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8035b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035bc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8035bf:	0f 86 4d 02 00 00    	jbe    803812 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8035c5:	83 ec 0c             	sub    $0xc,%esp
  8035c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8035cb:	e8 08 e8 ff ff       	call   801dd8 <is_free_block>
  8035d0:	83 c4 10             	add    $0x10,%esp
  8035d3:	84 c0                	test   %al,%al
  8035d5:	0f 84 37 02 00 00    	je     803812 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8035db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035de:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8035e1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8035e4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8035e7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8035ea:	76 38                	jbe    803624 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8035ec:	83 ec 0c             	sub    $0xc,%esp
  8035ef:	ff 75 08             	pushl  0x8(%ebp)
  8035f2:	e8 0c fa ff ff       	call   803003 <free_block>
  8035f7:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8035fa:	83 ec 0c             	sub    $0xc,%esp
  8035fd:	ff 75 0c             	pushl  0xc(%ebp)
  803600:	e8 3a eb ff ff       	call   80213f <alloc_block_FF>
  803605:	83 c4 10             	add    $0x10,%esp
  803608:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80360b:	83 ec 08             	sub    $0x8,%esp
  80360e:	ff 75 c0             	pushl  -0x40(%ebp)
  803611:	ff 75 08             	pushl  0x8(%ebp)
  803614:	e8 ab fa ff ff       	call   8030c4 <copy_data>
  803619:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80361c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80361f:	e9 f8 01 00 00       	jmp    80381c <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803624:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803627:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80362a:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80362d:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803631:	0f 87 a0 00 00 00    	ja     8036d7 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803637:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80363b:	75 17                	jne    803654 <realloc_block_FF+0x551>
  80363d:	83 ec 04             	sub    $0x4,%esp
  803640:	68 ab 43 80 00       	push   $0x8043ab
  803645:	68 38 02 00 00       	push   $0x238
  80364a:	68 c9 43 80 00       	push   $0x8043c9
  80364f:	e8 13 cc ff ff       	call   800267 <_panic>
  803654:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803657:	8b 00                	mov    (%eax),%eax
  803659:	85 c0                	test   %eax,%eax
  80365b:	74 10                	je     80366d <realloc_block_FF+0x56a>
  80365d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803660:	8b 00                	mov    (%eax),%eax
  803662:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803665:	8b 52 04             	mov    0x4(%edx),%edx
  803668:	89 50 04             	mov    %edx,0x4(%eax)
  80366b:	eb 0b                	jmp    803678 <realloc_block_FF+0x575>
  80366d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803670:	8b 40 04             	mov    0x4(%eax),%eax
  803673:	a3 30 50 80 00       	mov    %eax,0x805030
  803678:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367b:	8b 40 04             	mov    0x4(%eax),%eax
  80367e:	85 c0                	test   %eax,%eax
  803680:	74 0f                	je     803691 <realloc_block_FF+0x58e>
  803682:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803685:	8b 40 04             	mov    0x4(%eax),%eax
  803688:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80368b:	8b 12                	mov    (%edx),%edx
  80368d:	89 10                	mov    %edx,(%eax)
  80368f:	eb 0a                	jmp    80369b <realloc_block_FF+0x598>
  803691:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803694:	8b 00                	mov    (%eax),%eax
  803696:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80369b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ae:	a1 38 50 80 00       	mov    0x805038,%eax
  8036b3:	48                   	dec    %eax
  8036b4:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8036b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036bf:	01 d0                	add    %edx,%eax
  8036c1:	83 ec 04             	sub    $0x4,%esp
  8036c4:	6a 01                	push   $0x1
  8036c6:	50                   	push   %eax
  8036c7:	ff 75 08             	pushl  0x8(%ebp)
  8036ca:	e8 41 ea ff ff       	call   802110 <set_block_data>
  8036cf:	83 c4 10             	add    $0x10,%esp
  8036d2:	e9 36 01 00 00       	jmp    80380d <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8036d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036da:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8036dd:	01 d0                	add    %edx,%eax
  8036df:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8036e2:	83 ec 04             	sub    $0x4,%esp
  8036e5:	6a 01                	push   $0x1
  8036e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8036ea:	ff 75 08             	pushl  0x8(%ebp)
  8036ed:	e8 1e ea ff ff       	call   802110 <set_block_data>
  8036f2:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8036f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f8:	83 e8 04             	sub    $0x4,%eax
  8036fb:	8b 00                	mov    (%eax),%eax
  8036fd:	83 e0 fe             	and    $0xfffffffe,%eax
  803700:	89 c2                	mov    %eax,%edx
  803702:	8b 45 08             	mov    0x8(%ebp),%eax
  803705:	01 d0                	add    %edx,%eax
  803707:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80370a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80370e:	74 06                	je     803716 <realloc_block_FF+0x613>
  803710:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803714:	75 17                	jne    80372d <realloc_block_FF+0x62a>
  803716:	83 ec 04             	sub    $0x4,%esp
  803719:	68 3c 44 80 00       	push   $0x80443c
  80371e:	68 44 02 00 00       	push   $0x244
  803723:	68 c9 43 80 00       	push   $0x8043c9
  803728:	e8 3a cb ff ff       	call   800267 <_panic>
  80372d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803730:	8b 10                	mov    (%eax),%edx
  803732:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803735:	89 10                	mov    %edx,(%eax)
  803737:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80373a:	8b 00                	mov    (%eax),%eax
  80373c:	85 c0                	test   %eax,%eax
  80373e:	74 0b                	je     80374b <realloc_block_FF+0x648>
  803740:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803743:	8b 00                	mov    (%eax),%eax
  803745:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803748:	89 50 04             	mov    %edx,0x4(%eax)
  80374b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80374e:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803751:	89 10                	mov    %edx,(%eax)
  803753:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803756:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803759:	89 50 04             	mov    %edx,0x4(%eax)
  80375c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80375f:	8b 00                	mov    (%eax),%eax
  803761:	85 c0                	test   %eax,%eax
  803763:	75 08                	jne    80376d <realloc_block_FF+0x66a>
  803765:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803768:	a3 30 50 80 00       	mov    %eax,0x805030
  80376d:	a1 38 50 80 00       	mov    0x805038,%eax
  803772:	40                   	inc    %eax
  803773:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803778:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80377c:	75 17                	jne    803795 <realloc_block_FF+0x692>
  80377e:	83 ec 04             	sub    $0x4,%esp
  803781:	68 ab 43 80 00       	push   $0x8043ab
  803786:	68 45 02 00 00       	push   $0x245
  80378b:	68 c9 43 80 00       	push   $0x8043c9
  803790:	e8 d2 ca ff ff       	call   800267 <_panic>
  803795:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803798:	8b 00                	mov    (%eax),%eax
  80379a:	85 c0                	test   %eax,%eax
  80379c:	74 10                	je     8037ae <realloc_block_FF+0x6ab>
  80379e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a1:	8b 00                	mov    (%eax),%eax
  8037a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037a6:	8b 52 04             	mov    0x4(%edx),%edx
  8037a9:	89 50 04             	mov    %edx,0x4(%eax)
  8037ac:	eb 0b                	jmp    8037b9 <realloc_block_FF+0x6b6>
  8037ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b1:	8b 40 04             	mov    0x4(%eax),%eax
  8037b4:	a3 30 50 80 00       	mov    %eax,0x805030
  8037b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037bc:	8b 40 04             	mov    0x4(%eax),%eax
  8037bf:	85 c0                	test   %eax,%eax
  8037c1:	74 0f                	je     8037d2 <realloc_block_FF+0x6cf>
  8037c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c6:	8b 40 04             	mov    0x4(%eax),%eax
  8037c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037cc:	8b 12                	mov    (%edx),%edx
  8037ce:	89 10                	mov    %edx,(%eax)
  8037d0:	eb 0a                	jmp    8037dc <realloc_block_FF+0x6d9>
  8037d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d5:	8b 00                	mov    (%eax),%eax
  8037d7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037ef:	a1 38 50 80 00       	mov    0x805038,%eax
  8037f4:	48                   	dec    %eax
  8037f5:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8037fa:	83 ec 04             	sub    $0x4,%esp
  8037fd:	6a 00                	push   $0x0
  8037ff:	ff 75 bc             	pushl  -0x44(%ebp)
  803802:	ff 75 b8             	pushl  -0x48(%ebp)
  803805:	e8 06 e9 ff ff       	call   802110 <set_block_data>
  80380a:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80380d:	8b 45 08             	mov    0x8(%ebp),%eax
  803810:	eb 0a                	jmp    80381c <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803812:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803819:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80381c:	c9                   	leave  
  80381d:	c3                   	ret    

0080381e <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80381e:	55                   	push   %ebp
  80381f:	89 e5                	mov    %esp,%ebp
  803821:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803824:	83 ec 04             	sub    $0x4,%esp
  803827:	68 c0 44 80 00       	push   $0x8044c0
  80382c:	68 58 02 00 00       	push   $0x258
  803831:	68 c9 43 80 00       	push   $0x8043c9
  803836:	e8 2c ca ff ff       	call   800267 <_panic>

0080383b <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80383b:	55                   	push   %ebp
  80383c:	89 e5                	mov    %esp,%ebp
  80383e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803841:	83 ec 04             	sub    $0x4,%esp
  803844:	68 e8 44 80 00       	push   $0x8044e8
  803849:	68 61 02 00 00       	push   $0x261
  80384e:	68 c9 43 80 00       	push   $0x8043c9
  803853:	e8 0f ca ff ff       	call   800267 <_panic>

00803858 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803858:	55                   	push   %ebp
  803859:	89 e5                	mov    %esp,%ebp
  80385b:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80385e:	8b 55 08             	mov    0x8(%ebp),%edx
  803861:	89 d0                	mov    %edx,%eax
  803863:	c1 e0 02             	shl    $0x2,%eax
  803866:	01 d0                	add    %edx,%eax
  803868:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80386f:	01 d0                	add    %edx,%eax
  803871:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803878:	01 d0                	add    %edx,%eax
  80387a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803881:	01 d0                	add    %edx,%eax
  803883:	c1 e0 04             	shl    $0x4,%eax
  803886:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803889:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803890:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803893:	83 ec 0c             	sub    $0xc,%esp
  803896:	50                   	push   %eax
  803897:	e8 2f e2 ff ff       	call   801acb <sys_get_virtual_time>
  80389c:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80389f:	eb 41                	jmp    8038e2 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8038a1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8038a4:	83 ec 0c             	sub    $0xc,%esp
  8038a7:	50                   	push   %eax
  8038a8:	e8 1e e2 ff ff       	call   801acb <sys_get_virtual_time>
  8038ad:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8038b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b6:	29 c2                	sub    %eax,%edx
  8038b8:	89 d0                	mov    %edx,%eax
  8038ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8038bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038c3:	89 d1                	mov    %edx,%ecx
  8038c5:	29 c1                	sub    %eax,%ecx
  8038c7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8038ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038cd:	39 c2                	cmp    %eax,%edx
  8038cf:	0f 97 c0             	seta   %al
  8038d2:	0f b6 c0             	movzbl %al,%eax
  8038d5:	29 c1                	sub    %eax,%ecx
  8038d7:	89 c8                	mov    %ecx,%eax
  8038d9:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8038dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038df:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8038e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8038e8:	72 b7                	jb     8038a1 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8038ea:	90                   	nop
  8038eb:	c9                   	leave  
  8038ec:	c3                   	ret    

008038ed <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8038ed:	55                   	push   %ebp
  8038ee:	89 e5                	mov    %esp,%ebp
  8038f0:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8038f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8038fa:	eb 03                	jmp    8038ff <busy_wait+0x12>
  8038fc:	ff 45 fc             	incl   -0x4(%ebp)
  8038ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803902:	3b 45 08             	cmp    0x8(%ebp),%eax
  803905:	72 f5                	jb     8038fc <busy_wait+0xf>
	return i;
  803907:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80390a:	c9                   	leave  
  80390b:	c3                   	ret    

0080390c <__udivdi3>:
  80390c:	55                   	push   %ebp
  80390d:	57                   	push   %edi
  80390e:	56                   	push   %esi
  80390f:	53                   	push   %ebx
  803910:	83 ec 1c             	sub    $0x1c,%esp
  803913:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803917:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80391b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80391f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803923:	89 ca                	mov    %ecx,%edx
  803925:	89 f8                	mov    %edi,%eax
  803927:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80392b:	85 f6                	test   %esi,%esi
  80392d:	75 2d                	jne    80395c <__udivdi3+0x50>
  80392f:	39 cf                	cmp    %ecx,%edi
  803931:	77 65                	ja     803998 <__udivdi3+0x8c>
  803933:	89 fd                	mov    %edi,%ebp
  803935:	85 ff                	test   %edi,%edi
  803937:	75 0b                	jne    803944 <__udivdi3+0x38>
  803939:	b8 01 00 00 00       	mov    $0x1,%eax
  80393e:	31 d2                	xor    %edx,%edx
  803940:	f7 f7                	div    %edi
  803942:	89 c5                	mov    %eax,%ebp
  803944:	31 d2                	xor    %edx,%edx
  803946:	89 c8                	mov    %ecx,%eax
  803948:	f7 f5                	div    %ebp
  80394a:	89 c1                	mov    %eax,%ecx
  80394c:	89 d8                	mov    %ebx,%eax
  80394e:	f7 f5                	div    %ebp
  803950:	89 cf                	mov    %ecx,%edi
  803952:	89 fa                	mov    %edi,%edx
  803954:	83 c4 1c             	add    $0x1c,%esp
  803957:	5b                   	pop    %ebx
  803958:	5e                   	pop    %esi
  803959:	5f                   	pop    %edi
  80395a:	5d                   	pop    %ebp
  80395b:	c3                   	ret    
  80395c:	39 ce                	cmp    %ecx,%esi
  80395e:	77 28                	ja     803988 <__udivdi3+0x7c>
  803960:	0f bd fe             	bsr    %esi,%edi
  803963:	83 f7 1f             	xor    $0x1f,%edi
  803966:	75 40                	jne    8039a8 <__udivdi3+0x9c>
  803968:	39 ce                	cmp    %ecx,%esi
  80396a:	72 0a                	jb     803976 <__udivdi3+0x6a>
  80396c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803970:	0f 87 9e 00 00 00    	ja     803a14 <__udivdi3+0x108>
  803976:	b8 01 00 00 00       	mov    $0x1,%eax
  80397b:	89 fa                	mov    %edi,%edx
  80397d:	83 c4 1c             	add    $0x1c,%esp
  803980:	5b                   	pop    %ebx
  803981:	5e                   	pop    %esi
  803982:	5f                   	pop    %edi
  803983:	5d                   	pop    %ebp
  803984:	c3                   	ret    
  803985:	8d 76 00             	lea    0x0(%esi),%esi
  803988:	31 ff                	xor    %edi,%edi
  80398a:	31 c0                	xor    %eax,%eax
  80398c:	89 fa                	mov    %edi,%edx
  80398e:	83 c4 1c             	add    $0x1c,%esp
  803991:	5b                   	pop    %ebx
  803992:	5e                   	pop    %esi
  803993:	5f                   	pop    %edi
  803994:	5d                   	pop    %ebp
  803995:	c3                   	ret    
  803996:	66 90                	xchg   %ax,%ax
  803998:	89 d8                	mov    %ebx,%eax
  80399a:	f7 f7                	div    %edi
  80399c:	31 ff                	xor    %edi,%edi
  80399e:	89 fa                	mov    %edi,%edx
  8039a0:	83 c4 1c             	add    $0x1c,%esp
  8039a3:	5b                   	pop    %ebx
  8039a4:	5e                   	pop    %esi
  8039a5:	5f                   	pop    %edi
  8039a6:	5d                   	pop    %ebp
  8039a7:	c3                   	ret    
  8039a8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8039ad:	89 eb                	mov    %ebp,%ebx
  8039af:	29 fb                	sub    %edi,%ebx
  8039b1:	89 f9                	mov    %edi,%ecx
  8039b3:	d3 e6                	shl    %cl,%esi
  8039b5:	89 c5                	mov    %eax,%ebp
  8039b7:	88 d9                	mov    %bl,%cl
  8039b9:	d3 ed                	shr    %cl,%ebp
  8039bb:	89 e9                	mov    %ebp,%ecx
  8039bd:	09 f1                	or     %esi,%ecx
  8039bf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8039c3:	89 f9                	mov    %edi,%ecx
  8039c5:	d3 e0                	shl    %cl,%eax
  8039c7:	89 c5                	mov    %eax,%ebp
  8039c9:	89 d6                	mov    %edx,%esi
  8039cb:	88 d9                	mov    %bl,%cl
  8039cd:	d3 ee                	shr    %cl,%esi
  8039cf:	89 f9                	mov    %edi,%ecx
  8039d1:	d3 e2                	shl    %cl,%edx
  8039d3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039d7:	88 d9                	mov    %bl,%cl
  8039d9:	d3 e8                	shr    %cl,%eax
  8039db:	09 c2                	or     %eax,%edx
  8039dd:	89 d0                	mov    %edx,%eax
  8039df:	89 f2                	mov    %esi,%edx
  8039e1:	f7 74 24 0c          	divl   0xc(%esp)
  8039e5:	89 d6                	mov    %edx,%esi
  8039e7:	89 c3                	mov    %eax,%ebx
  8039e9:	f7 e5                	mul    %ebp
  8039eb:	39 d6                	cmp    %edx,%esi
  8039ed:	72 19                	jb     803a08 <__udivdi3+0xfc>
  8039ef:	74 0b                	je     8039fc <__udivdi3+0xf0>
  8039f1:	89 d8                	mov    %ebx,%eax
  8039f3:	31 ff                	xor    %edi,%edi
  8039f5:	e9 58 ff ff ff       	jmp    803952 <__udivdi3+0x46>
  8039fa:	66 90                	xchg   %ax,%ax
  8039fc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a00:	89 f9                	mov    %edi,%ecx
  803a02:	d3 e2                	shl    %cl,%edx
  803a04:	39 c2                	cmp    %eax,%edx
  803a06:	73 e9                	jae    8039f1 <__udivdi3+0xe5>
  803a08:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a0b:	31 ff                	xor    %edi,%edi
  803a0d:	e9 40 ff ff ff       	jmp    803952 <__udivdi3+0x46>
  803a12:	66 90                	xchg   %ax,%ax
  803a14:	31 c0                	xor    %eax,%eax
  803a16:	e9 37 ff ff ff       	jmp    803952 <__udivdi3+0x46>
  803a1b:	90                   	nop

00803a1c <__umoddi3>:
  803a1c:	55                   	push   %ebp
  803a1d:	57                   	push   %edi
  803a1e:	56                   	push   %esi
  803a1f:	53                   	push   %ebx
  803a20:	83 ec 1c             	sub    $0x1c,%esp
  803a23:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a27:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a2f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a37:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a3b:	89 f3                	mov    %esi,%ebx
  803a3d:	89 fa                	mov    %edi,%edx
  803a3f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a43:	89 34 24             	mov    %esi,(%esp)
  803a46:	85 c0                	test   %eax,%eax
  803a48:	75 1a                	jne    803a64 <__umoddi3+0x48>
  803a4a:	39 f7                	cmp    %esi,%edi
  803a4c:	0f 86 a2 00 00 00    	jbe    803af4 <__umoddi3+0xd8>
  803a52:	89 c8                	mov    %ecx,%eax
  803a54:	89 f2                	mov    %esi,%edx
  803a56:	f7 f7                	div    %edi
  803a58:	89 d0                	mov    %edx,%eax
  803a5a:	31 d2                	xor    %edx,%edx
  803a5c:	83 c4 1c             	add    $0x1c,%esp
  803a5f:	5b                   	pop    %ebx
  803a60:	5e                   	pop    %esi
  803a61:	5f                   	pop    %edi
  803a62:	5d                   	pop    %ebp
  803a63:	c3                   	ret    
  803a64:	39 f0                	cmp    %esi,%eax
  803a66:	0f 87 ac 00 00 00    	ja     803b18 <__umoddi3+0xfc>
  803a6c:	0f bd e8             	bsr    %eax,%ebp
  803a6f:	83 f5 1f             	xor    $0x1f,%ebp
  803a72:	0f 84 ac 00 00 00    	je     803b24 <__umoddi3+0x108>
  803a78:	bf 20 00 00 00       	mov    $0x20,%edi
  803a7d:	29 ef                	sub    %ebp,%edi
  803a7f:	89 fe                	mov    %edi,%esi
  803a81:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a85:	89 e9                	mov    %ebp,%ecx
  803a87:	d3 e0                	shl    %cl,%eax
  803a89:	89 d7                	mov    %edx,%edi
  803a8b:	89 f1                	mov    %esi,%ecx
  803a8d:	d3 ef                	shr    %cl,%edi
  803a8f:	09 c7                	or     %eax,%edi
  803a91:	89 e9                	mov    %ebp,%ecx
  803a93:	d3 e2                	shl    %cl,%edx
  803a95:	89 14 24             	mov    %edx,(%esp)
  803a98:	89 d8                	mov    %ebx,%eax
  803a9a:	d3 e0                	shl    %cl,%eax
  803a9c:	89 c2                	mov    %eax,%edx
  803a9e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aa2:	d3 e0                	shl    %cl,%eax
  803aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803aa8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aac:	89 f1                	mov    %esi,%ecx
  803aae:	d3 e8                	shr    %cl,%eax
  803ab0:	09 d0                	or     %edx,%eax
  803ab2:	d3 eb                	shr    %cl,%ebx
  803ab4:	89 da                	mov    %ebx,%edx
  803ab6:	f7 f7                	div    %edi
  803ab8:	89 d3                	mov    %edx,%ebx
  803aba:	f7 24 24             	mull   (%esp)
  803abd:	89 c6                	mov    %eax,%esi
  803abf:	89 d1                	mov    %edx,%ecx
  803ac1:	39 d3                	cmp    %edx,%ebx
  803ac3:	0f 82 87 00 00 00    	jb     803b50 <__umoddi3+0x134>
  803ac9:	0f 84 91 00 00 00    	je     803b60 <__umoddi3+0x144>
  803acf:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ad3:	29 f2                	sub    %esi,%edx
  803ad5:	19 cb                	sbb    %ecx,%ebx
  803ad7:	89 d8                	mov    %ebx,%eax
  803ad9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803add:	d3 e0                	shl    %cl,%eax
  803adf:	89 e9                	mov    %ebp,%ecx
  803ae1:	d3 ea                	shr    %cl,%edx
  803ae3:	09 d0                	or     %edx,%eax
  803ae5:	89 e9                	mov    %ebp,%ecx
  803ae7:	d3 eb                	shr    %cl,%ebx
  803ae9:	89 da                	mov    %ebx,%edx
  803aeb:	83 c4 1c             	add    $0x1c,%esp
  803aee:	5b                   	pop    %ebx
  803aef:	5e                   	pop    %esi
  803af0:	5f                   	pop    %edi
  803af1:	5d                   	pop    %ebp
  803af2:	c3                   	ret    
  803af3:	90                   	nop
  803af4:	89 fd                	mov    %edi,%ebp
  803af6:	85 ff                	test   %edi,%edi
  803af8:	75 0b                	jne    803b05 <__umoddi3+0xe9>
  803afa:	b8 01 00 00 00       	mov    $0x1,%eax
  803aff:	31 d2                	xor    %edx,%edx
  803b01:	f7 f7                	div    %edi
  803b03:	89 c5                	mov    %eax,%ebp
  803b05:	89 f0                	mov    %esi,%eax
  803b07:	31 d2                	xor    %edx,%edx
  803b09:	f7 f5                	div    %ebp
  803b0b:	89 c8                	mov    %ecx,%eax
  803b0d:	f7 f5                	div    %ebp
  803b0f:	89 d0                	mov    %edx,%eax
  803b11:	e9 44 ff ff ff       	jmp    803a5a <__umoddi3+0x3e>
  803b16:	66 90                	xchg   %ax,%ax
  803b18:	89 c8                	mov    %ecx,%eax
  803b1a:	89 f2                	mov    %esi,%edx
  803b1c:	83 c4 1c             	add    $0x1c,%esp
  803b1f:	5b                   	pop    %ebx
  803b20:	5e                   	pop    %esi
  803b21:	5f                   	pop    %edi
  803b22:	5d                   	pop    %ebp
  803b23:	c3                   	ret    
  803b24:	3b 04 24             	cmp    (%esp),%eax
  803b27:	72 06                	jb     803b2f <__umoddi3+0x113>
  803b29:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b2d:	77 0f                	ja     803b3e <__umoddi3+0x122>
  803b2f:	89 f2                	mov    %esi,%edx
  803b31:	29 f9                	sub    %edi,%ecx
  803b33:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b37:	89 14 24             	mov    %edx,(%esp)
  803b3a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b3e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b42:	8b 14 24             	mov    (%esp),%edx
  803b45:	83 c4 1c             	add    $0x1c,%esp
  803b48:	5b                   	pop    %ebx
  803b49:	5e                   	pop    %esi
  803b4a:	5f                   	pop    %edi
  803b4b:	5d                   	pop    %ebp
  803b4c:	c3                   	ret    
  803b4d:	8d 76 00             	lea    0x0(%esi),%esi
  803b50:	2b 04 24             	sub    (%esp),%eax
  803b53:	19 fa                	sbb    %edi,%edx
  803b55:	89 d1                	mov    %edx,%ecx
  803b57:	89 c6                	mov    %eax,%esi
  803b59:	e9 71 ff ff ff       	jmp    803acf <__umoddi3+0xb3>
  803b5e:	66 90                	xchg   %ax,%ax
  803b60:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b64:	72 ea                	jb     803b50 <__umoddi3+0x134>
  803b66:	89 d9                	mov    %ebx,%ecx
  803b68:	e9 62 ff ff ff       	jmp    803acf <__umoddi3+0xb3>
