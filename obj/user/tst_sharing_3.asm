
obj/user/tst_sharing_3:     file format elf32-i386


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
  800031:	e8 45 02 00 00       	call   80027b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the SPECIAL CASES during the creation & get of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
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
  80005b:	68 40 3c 80 00       	push   $0x803c40
  800060:	6a 0c                	push   $0xc
  800062:	68 5c 3c 80 00       	push   $0x803c5c
  800067:	e8 4e 03 00 00       	call   8003ba <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	cprintf("************************************************\n");
  80006c:	83 ec 0c             	sub    $0xc,%esp
  80006f:	68 74 3c 80 00       	push   $0x803c74
  800074:	e8 fe 05 00 00       	call   800677 <cprintf>
  800079:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	68 a8 3c 80 00       	push   $0x803ca8
  800084:	e8 ee 05 00 00       	call   800677 <cprintf>
  800089:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 04 3d 80 00       	push   $0x803d04
  800094:	e8 de 05 00 00       	call   800677 <cprintf>
  800099:	83 c4 10             	add    $0x10,%esp

	int eval = 0;
  80009c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  8000a3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  8000aa:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking creation of shared object that is already exists... [35%] \n\n");
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 38 3d 80 00       	push   $0x803d38
  8000b9:	e8 b9 05 00 00       	call   800677 <cprintf>
  8000be:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 01                	push   $0x1
  8000c6:	68 00 10 00 00       	push   $0x1000
  8000cb:	68 86 3d 80 00       	push   $0x803d86
  8000d0:	e8 70 16 00 00       	call   801745 <smalloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000db:	e8 84 19 00 00       	call   801a64 <sys_calculate_free_frames>
  8000e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000e3:	83 ec 04             	sub    $0x4,%esp
  8000e6:	6a 01                	push   $0x1
  8000e8:	68 00 10 00 00       	push   $0x1000
  8000ed:	68 86 3d 80 00       	push   $0x803d86
  8000f2:	e8 4e 16 00 00       	call   801745 <smalloc>
  8000f7:	83 c4 10             	add    $0x10,%esp
  8000fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) {is_correct = 0; cprintf("Trying to create an already exists object and corresponding error is not returned!!");}
  8000fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800101:	74 17                	je     80011a <_main+0xe2>
  800103:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	68 88 3d 80 00       	push   $0x803d88
  800112:	e8 60 05 00 00       	call   800677 <cprintf>
  800117:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");}
  80011a:	e8 45 19 00 00       	call   801a64 <sys_calculate_free_frames>
  80011f:	89 c2                	mov    %eax,%edx
  800121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800124:	39 c2                	cmp    %eax,%edx
  800126:	74 17                	je     80013f <_main+0x107>
  800128:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 dc 3d 80 00       	push   $0x803ddc
  800137:	e8 3b 05 00 00       	call   800677 <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=35;
  80013f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800143:	74 04                	je     800149 <_main+0x111>
  800145:	83 45 f4 23          	addl   $0x23,-0xc(%ebp)
	is_correct = 1;
  800149:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("STEP B: checking getting shared object that is NOT exists... [35%]\n\n");
  800150:	83 ec 0c             	sub    $0xc,%esp
  800153:	68 38 3e 80 00       	push   $0x803e38
  800158:	e8 1a 05 00 00       	call   800677 <cprintf>
  80015d:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		x = sget(myEnv->env_id, "xx");
  800160:	a1 20 50 80 00       	mov    0x805020,%eax
  800165:	8b 40 10             	mov    0x10(%eax),%eax
  800168:	83 ec 08             	sub    $0x8,%esp
  80016b:	68 7d 3e 80 00       	push   $0x803e7d
  800170:	50                   	push   %eax
  800171:	e8 74 16 00 00       	call   8017ea <sget>
  800176:	83 c4 10             	add    $0x10,%esp
  800179:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  80017c:	e8 e3 18 00 00       	call   801a64 <sys_calculate_free_frames>
  800181:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != NULL) {is_correct = 0; cprintf("Trying to get a NON existing object and corresponding error is not returned!!");}
  800184:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800188:	74 17                	je     8001a1 <_main+0x169>
  80018a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800191:	83 ec 0c             	sub    $0xc,%esp
  800194:	68 80 3e 80 00       	push   $0x803e80
  800199:	e8 d9 04 00 00       	call   800677 <cprintf>
  80019e:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong get: make sure that you don't allocate any memory if the shared object not exists");}
  8001a1:	e8 be 18 00 00       	call   801a64 <sys_calculate_free_frames>
  8001a6:	89 c2                	mov    %eax,%edx
  8001a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ab:	39 c2                	cmp    %eax,%edx
  8001ad:	74 17                	je     8001c6 <_main+0x18e>
  8001af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	68 d0 3e 80 00       	push   $0x803ed0
  8001be:	e8 b4 04 00 00       	call   800677 <cprintf>
  8001c3:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=35;
  8001c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8001ca:	74 04                	je     8001d0 <_main+0x198>
  8001cc:	83 45 f4 23          	addl   $0x23,-0xc(%ebp)
	is_correct = 1;
  8001d0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("STEP C: checking the creation of shared object that exceeds the SHARED area limit... [30%]\n\n");
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	68 28 3f 80 00       	push   $0x803f28
  8001df:	e8 93 04 00 00       	call   800677 <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8001e7:	e8 78 18 00 00       	call   801a64 <sys_calculate_free_frames>
  8001ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uint32 size = USER_HEAP_MAX - pagealloc_start - PAGE_SIZE + 1;
  8001ef:	b8 01 f0 ff 9f       	mov    $0x9ffff001,%eax
  8001f4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8001f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		y = smalloc("y", size, 1);
  8001fa:	83 ec 04             	sub    $0x4,%esp
  8001fd:	6a 01                	push   $0x1
  8001ff:	ff 75 d8             	pushl  -0x28(%ebp)
  800202:	68 85 3f 80 00       	push   $0x803f85
  800207:	e8 39 15 00 00       	call   801745 <smalloc>
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (y != NULL) {is_correct = 0; cprintf("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");}
  800212:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800216:	74 17                	je     80022f <_main+0x1f7>
  800218:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	68 88 3f 80 00       	push   $0x803f88
  800227:	e8 4b 04 00 00       	call   800677 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");}
  80022f:	e8 30 18 00 00       	call   801a64 <sys_calculate_free_frames>
  800234:	89 c2                	mov    %eax,%edx
  800236:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800239:	39 c2                	cmp    %eax,%edx
  80023b:	74 17                	je     800254 <_main+0x21c>
  80023d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 fc 3f 80 00       	push   $0x803ffc
  80024c:	e8 26 04 00 00       	call   800677 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=30;
  800254:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800258:	74 04                	je     80025e <_main+0x226>
  80025a:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	is_correct = 1;
  80025e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("\n%~Test of Shared Variables [Create & Get: Special Cases] completed. Eval = %d%%\n\n", eval);
  800265:	83 ec 08             	sub    $0x8,%esp
  800268:	ff 75 f4             	pushl  -0xc(%ebp)
  80026b:	68 70 40 80 00       	push   $0x804070
  800270:	e8 02 04 00 00       	call   800677 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp

}
  800278:	90                   	nop
  800279:	c9                   	leave  
  80027a:	c3                   	ret    

0080027b <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800281:	e8 a7 19 00 00       	call   801c2d <sys_getenvindex>
  800286:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800289:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80028c:	89 d0                	mov    %edx,%eax
  80028e:	c1 e0 03             	shl    $0x3,%eax
  800291:	01 d0                	add    %edx,%eax
  800293:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80029a:	01 c8                	add    %ecx,%eax
  80029c:	01 c0                	add    %eax,%eax
  80029e:	01 d0                	add    %edx,%eax
  8002a0:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8002a7:	01 c8                	add    %ecx,%eax
  8002a9:	01 d0                	add    %edx,%eax
  8002ab:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002b0:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002b5:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ba:	8a 40 20             	mov    0x20(%eax),%al
  8002bd:	84 c0                	test   %al,%al
  8002bf:	74 0d                	je     8002ce <libmain+0x53>
		binaryname = myEnv->prog_name;
  8002c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8002c6:	83 c0 20             	add    $0x20,%eax
  8002c9:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002d2:	7e 0a                	jle    8002de <libmain+0x63>
		binaryname = argv[0];
  8002d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d7:	8b 00                	mov    (%eax),%eax
  8002d9:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8002de:	83 ec 08             	sub    $0x8,%esp
  8002e1:	ff 75 0c             	pushl  0xc(%ebp)
  8002e4:	ff 75 08             	pushl  0x8(%ebp)
  8002e7:	e8 4c fd ff ff       	call   800038 <_main>
  8002ec:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8002ef:	e8 bd 16 00 00       	call   8019b1 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 dc 40 80 00       	push   $0x8040dc
  8002fc:	e8 76 03 00 00       	call   800677 <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800304:	a1 20 50 80 00       	mov    0x805020,%eax
  800309:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80030f:	a1 20 50 80 00       	mov    0x805020,%eax
  800314:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  80031a:	83 ec 04             	sub    $0x4,%esp
  80031d:	52                   	push   %edx
  80031e:	50                   	push   %eax
  80031f:	68 04 41 80 00       	push   $0x804104
  800324:	e8 4e 03 00 00       	call   800677 <cprintf>
  800329:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80032c:	a1 20 50 80 00       	mov    0x805020,%eax
  800331:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800337:	a1 20 50 80 00       	mov    0x805020,%eax
  80033c:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  800342:	a1 20 50 80 00       	mov    0x805020,%eax
  800347:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80034d:	51                   	push   %ecx
  80034e:	52                   	push   %edx
  80034f:	50                   	push   %eax
  800350:	68 2c 41 80 00       	push   $0x80412c
  800355:	e8 1d 03 00 00       	call   800677 <cprintf>
  80035a:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80035d:	a1 20 50 80 00       	mov    0x805020,%eax
  800362:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800368:	83 ec 08             	sub    $0x8,%esp
  80036b:	50                   	push   %eax
  80036c:	68 84 41 80 00       	push   $0x804184
  800371:	e8 01 03 00 00       	call   800677 <cprintf>
  800376:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800379:	83 ec 0c             	sub    $0xc,%esp
  80037c:	68 dc 40 80 00       	push   $0x8040dc
  800381:	e8 f1 02 00 00       	call   800677 <cprintf>
  800386:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800389:	e8 3d 16 00 00       	call   8019cb <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80038e:	e8 19 00 00 00       	call   8003ac <exit>
}
  800393:	90                   	nop
  800394:	c9                   	leave  
  800395:	c3                   	ret    

00800396 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800396:	55                   	push   %ebp
  800397:	89 e5                	mov    %esp,%ebp
  800399:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80039c:	83 ec 0c             	sub    $0xc,%esp
  80039f:	6a 00                	push   $0x0
  8003a1:	e8 53 18 00 00       	call   801bf9 <sys_destroy_env>
  8003a6:	83 c4 10             	add    $0x10,%esp
}
  8003a9:	90                   	nop
  8003aa:	c9                   	leave  
  8003ab:	c3                   	ret    

008003ac <exit>:

void
exit(void)
{
  8003ac:	55                   	push   %ebp
  8003ad:	89 e5                	mov    %esp,%ebp
  8003af:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003b2:	e8 a8 18 00 00       	call   801c5f <sys_exit_env>
}
  8003b7:	90                   	nop
  8003b8:	c9                   	leave  
  8003b9:	c3                   	ret    

008003ba <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003ba:	55                   	push   %ebp
  8003bb:	89 e5                	mov    %esp,%ebp
  8003bd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003c0:	8d 45 10             	lea    0x10(%ebp),%eax
  8003c3:	83 c0 04             	add    $0x4,%eax
  8003c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003c9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8003ce:	85 c0                	test   %eax,%eax
  8003d0:	74 16                	je     8003e8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003d2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8003d7:	83 ec 08             	sub    $0x8,%esp
  8003da:	50                   	push   %eax
  8003db:	68 98 41 80 00       	push   $0x804198
  8003e0:	e8 92 02 00 00       	call   800677 <cprintf>
  8003e5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003e8:	a1 00 50 80 00       	mov    0x805000,%eax
  8003ed:	ff 75 0c             	pushl  0xc(%ebp)
  8003f0:	ff 75 08             	pushl  0x8(%ebp)
  8003f3:	50                   	push   %eax
  8003f4:	68 9d 41 80 00       	push   $0x80419d
  8003f9:	e8 79 02 00 00       	call   800677 <cprintf>
  8003fe:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800401:	8b 45 10             	mov    0x10(%ebp),%eax
  800404:	83 ec 08             	sub    $0x8,%esp
  800407:	ff 75 f4             	pushl  -0xc(%ebp)
  80040a:	50                   	push   %eax
  80040b:	e8 fc 01 00 00       	call   80060c <vcprintf>
  800410:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800413:	83 ec 08             	sub    $0x8,%esp
  800416:	6a 00                	push   $0x0
  800418:	68 b9 41 80 00       	push   $0x8041b9
  80041d:	e8 ea 01 00 00       	call   80060c <vcprintf>
  800422:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800425:	e8 82 ff ff ff       	call   8003ac <exit>

	// should not return here
	while (1) ;
  80042a:	eb fe                	jmp    80042a <_panic+0x70>

0080042c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
  80042f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800432:	a1 20 50 80 00       	mov    0x805020,%eax
  800437:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80043d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800440:	39 c2                	cmp    %eax,%edx
  800442:	74 14                	je     800458 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800444:	83 ec 04             	sub    $0x4,%esp
  800447:	68 bc 41 80 00       	push   $0x8041bc
  80044c:	6a 26                	push   $0x26
  80044e:	68 08 42 80 00       	push   $0x804208
  800453:	e8 62 ff ff ff       	call   8003ba <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800458:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80045f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800466:	e9 c5 00 00 00       	jmp    800530 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80046b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80046e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800475:	8b 45 08             	mov    0x8(%ebp),%eax
  800478:	01 d0                	add    %edx,%eax
  80047a:	8b 00                	mov    (%eax),%eax
  80047c:	85 c0                	test   %eax,%eax
  80047e:	75 08                	jne    800488 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800480:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800483:	e9 a5 00 00 00       	jmp    80052d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800488:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80048f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800496:	eb 69                	jmp    800501 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800498:	a1 20 50 80 00       	mov    0x805020,%eax
  80049d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8004a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004a6:	89 d0                	mov    %edx,%eax
  8004a8:	01 c0                	add    %eax,%eax
  8004aa:	01 d0                	add    %edx,%eax
  8004ac:	c1 e0 03             	shl    $0x3,%eax
  8004af:	01 c8                	add    %ecx,%eax
  8004b1:	8a 40 04             	mov    0x4(%eax),%al
  8004b4:	84 c0                	test   %al,%al
  8004b6:	75 46                	jne    8004fe <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8004bd:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8004c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004c6:	89 d0                	mov    %edx,%eax
  8004c8:	01 c0                	add    %eax,%eax
  8004ca:	01 d0                	add    %edx,%eax
  8004cc:	c1 e0 03             	shl    $0x3,%eax
  8004cf:	01 c8                	add    %ecx,%eax
  8004d1:	8b 00                	mov    (%eax),%eax
  8004d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004de:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004e3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	01 c8                	add    %ecx,%eax
  8004ef:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004f1:	39 c2                	cmp    %eax,%edx
  8004f3:	75 09                	jne    8004fe <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8004f5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004fc:	eb 15                	jmp    800513 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004fe:	ff 45 e8             	incl   -0x18(%ebp)
  800501:	a1 20 50 80 00       	mov    0x805020,%eax
  800506:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80050c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80050f:	39 c2                	cmp    %eax,%edx
  800511:	77 85                	ja     800498 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800513:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800517:	75 14                	jne    80052d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800519:	83 ec 04             	sub    $0x4,%esp
  80051c:	68 14 42 80 00       	push   $0x804214
  800521:	6a 3a                	push   $0x3a
  800523:	68 08 42 80 00       	push   $0x804208
  800528:	e8 8d fe ff ff       	call   8003ba <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80052d:	ff 45 f0             	incl   -0x10(%ebp)
  800530:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800533:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800536:	0f 8c 2f ff ff ff    	jl     80046b <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80053c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800543:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80054a:	eb 26                	jmp    800572 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80054c:	a1 20 50 80 00       	mov    0x805020,%eax
  800551:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800557:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80055a:	89 d0                	mov    %edx,%eax
  80055c:	01 c0                	add    %eax,%eax
  80055e:	01 d0                	add    %edx,%eax
  800560:	c1 e0 03             	shl    $0x3,%eax
  800563:	01 c8                	add    %ecx,%eax
  800565:	8a 40 04             	mov    0x4(%eax),%al
  800568:	3c 01                	cmp    $0x1,%al
  80056a:	75 03                	jne    80056f <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80056c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80056f:	ff 45 e0             	incl   -0x20(%ebp)
  800572:	a1 20 50 80 00       	mov    0x805020,%eax
  800577:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80057d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800580:	39 c2                	cmp    %eax,%edx
  800582:	77 c8                	ja     80054c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800587:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80058a:	74 14                	je     8005a0 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80058c:	83 ec 04             	sub    $0x4,%esp
  80058f:	68 68 42 80 00       	push   $0x804268
  800594:	6a 44                	push   $0x44
  800596:	68 08 42 80 00       	push   $0x804208
  80059b:	e8 1a fe ff ff       	call   8003ba <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005a0:	90                   	nop
  8005a1:	c9                   	leave  
  8005a2:	c3                   	ret    

008005a3 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005a3:	55                   	push   %ebp
  8005a4:	89 e5                	mov    %esp,%ebp
  8005a6:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	8d 48 01             	lea    0x1(%eax),%ecx
  8005b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005b4:	89 0a                	mov    %ecx,(%edx)
  8005b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8005b9:	88 d1                	mov    %dl,%cl
  8005bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005be:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c5:	8b 00                	mov    (%eax),%eax
  8005c7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005cc:	75 2c                	jne    8005fa <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005ce:	a0 28 50 80 00       	mov    0x805028,%al
  8005d3:	0f b6 c0             	movzbl %al,%eax
  8005d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005d9:	8b 12                	mov    (%edx),%edx
  8005db:	89 d1                	mov    %edx,%ecx
  8005dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e0:	83 c2 08             	add    $0x8,%edx
  8005e3:	83 ec 04             	sub    $0x4,%esp
  8005e6:	50                   	push   %eax
  8005e7:	51                   	push   %ecx
  8005e8:	52                   	push   %edx
  8005e9:	e8 81 13 00 00       	call   80196f <sys_cputs>
  8005ee:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fd:	8b 40 04             	mov    0x4(%eax),%eax
  800600:	8d 50 01             	lea    0x1(%eax),%edx
  800603:	8b 45 0c             	mov    0xc(%ebp),%eax
  800606:	89 50 04             	mov    %edx,0x4(%eax)
}
  800609:	90                   	nop
  80060a:	c9                   	leave  
  80060b:	c3                   	ret    

0080060c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80060c:	55                   	push   %ebp
  80060d:	89 e5                	mov    %esp,%ebp
  80060f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800615:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80061c:	00 00 00 
	b.cnt = 0;
  80061f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800626:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800629:	ff 75 0c             	pushl  0xc(%ebp)
  80062c:	ff 75 08             	pushl  0x8(%ebp)
  80062f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800635:	50                   	push   %eax
  800636:	68 a3 05 80 00       	push   $0x8005a3
  80063b:	e8 11 02 00 00       	call   800851 <vprintfmt>
  800640:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800643:	a0 28 50 80 00       	mov    0x805028,%al
  800648:	0f b6 c0             	movzbl %al,%eax
  80064b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800651:	83 ec 04             	sub    $0x4,%esp
  800654:	50                   	push   %eax
  800655:	52                   	push   %edx
  800656:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80065c:	83 c0 08             	add    $0x8,%eax
  80065f:	50                   	push   %eax
  800660:	e8 0a 13 00 00       	call   80196f <sys_cputs>
  800665:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800668:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  80066f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800675:	c9                   	leave  
  800676:	c3                   	ret    

00800677 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800677:	55                   	push   %ebp
  800678:	89 e5                	mov    %esp,%ebp
  80067a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80067d:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800684:	8d 45 0c             	lea    0xc(%ebp),%eax
  800687:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	ff 75 f4             	pushl  -0xc(%ebp)
  800693:	50                   	push   %eax
  800694:	e8 73 ff ff ff       	call   80060c <vcprintf>
  800699:	83 c4 10             	add    $0x10,%esp
  80069c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80069f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006a2:	c9                   	leave  
  8006a3:	c3                   	ret    

008006a4 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006a4:	55                   	push   %ebp
  8006a5:	89 e5                	mov    %esp,%ebp
  8006a7:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006aa:	e8 02 13 00 00       	call   8019b1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006af:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b8:	83 ec 08             	sub    $0x8,%esp
  8006bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8006be:	50                   	push   %eax
  8006bf:	e8 48 ff ff ff       	call   80060c <vcprintf>
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8006ca:	e8 fc 12 00 00       	call   8019cb <sys_unlock_cons>
	return cnt;
  8006cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006d2:	c9                   	leave  
  8006d3:	c3                   	ret    

008006d4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006d4:	55                   	push   %ebp
  8006d5:	89 e5                	mov    %esp,%ebp
  8006d7:	53                   	push   %ebx
  8006d8:	83 ec 14             	sub    $0x14,%esp
  8006db:	8b 45 10             	mov    0x10(%ebp),%eax
  8006de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006e7:	8b 45 18             	mov    0x18(%ebp),%eax
  8006ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ef:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006f2:	77 55                	ja     800749 <printnum+0x75>
  8006f4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006f7:	72 05                	jb     8006fe <printnum+0x2a>
  8006f9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006fc:	77 4b                	ja     800749 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006fe:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800701:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800704:	8b 45 18             	mov    0x18(%ebp),%eax
  800707:	ba 00 00 00 00       	mov    $0x0,%edx
  80070c:	52                   	push   %edx
  80070d:	50                   	push   %eax
  80070e:	ff 75 f4             	pushl  -0xc(%ebp)
  800711:	ff 75 f0             	pushl  -0x10(%ebp)
  800714:	e8 bb 32 00 00       	call   8039d4 <__udivdi3>
  800719:	83 c4 10             	add    $0x10,%esp
  80071c:	83 ec 04             	sub    $0x4,%esp
  80071f:	ff 75 20             	pushl  0x20(%ebp)
  800722:	53                   	push   %ebx
  800723:	ff 75 18             	pushl  0x18(%ebp)
  800726:	52                   	push   %edx
  800727:	50                   	push   %eax
  800728:	ff 75 0c             	pushl  0xc(%ebp)
  80072b:	ff 75 08             	pushl  0x8(%ebp)
  80072e:	e8 a1 ff ff ff       	call   8006d4 <printnum>
  800733:	83 c4 20             	add    $0x20,%esp
  800736:	eb 1a                	jmp    800752 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800738:	83 ec 08             	sub    $0x8,%esp
  80073b:	ff 75 0c             	pushl  0xc(%ebp)
  80073e:	ff 75 20             	pushl  0x20(%ebp)
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	ff d0                	call   *%eax
  800746:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800749:	ff 4d 1c             	decl   0x1c(%ebp)
  80074c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800750:	7f e6                	jg     800738 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800752:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800755:	bb 00 00 00 00       	mov    $0x0,%ebx
  80075a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80075d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800760:	53                   	push   %ebx
  800761:	51                   	push   %ecx
  800762:	52                   	push   %edx
  800763:	50                   	push   %eax
  800764:	e8 7b 33 00 00       	call   803ae4 <__umoddi3>
  800769:	83 c4 10             	add    $0x10,%esp
  80076c:	05 d4 44 80 00       	add    $0x8044d4,%eax
  800771:	8a 00                	mov    (%eax),%al
  800773:	0f be c0             	movsbl %al,%eax
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	ff 75 0c             	pushl  0xc(%ebp)
  80077c:	50                   	push   %eax
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	ff d0                	call   *%eax
  800782:	83 c4 10             	add    $0x10,%esp
}
  800785:	90                   	nop
  800786:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800789:	c9                   	leave  
  80078a:	c3                   	ret    

0080078b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80078b:	55                   	push   %ebp
  80078c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80078e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800792:	7e 1c                	jle    8007b0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800794:	8b 45 08             	mov    0x8(%ebp),%eax
  800797:	8b 00                	mov    (%eax),%eax
  800799:	8d 50 08             	lea    0x8(%eax),%edx
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	89 10                	mov    %edx,(%eax)
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	83 e8 08             	sub    $0x8,%eax
  8007a9:	8b 50 04             	mov    0x4(%eax),%edx
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	eb 40                	jmp    8007f0 <getuint+0x65>
	else if (lflag)
  8007b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007b4:	74 1e                	je     8007d4 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	8d 50 04             	lea    0x4(%eax),%edx
  8007be:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c1:	89 10                	mov    %edx,(%eax)
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	83 e8 04             	sub    $0x4,%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d2:	eb 1c                	jmp    8007f0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d7:	8b 00                	mov    (%eax),%eax
  8007d9:	8d 50 04             	lea    0x4(%eax),%edx
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	89 10                	mov    %edx,(%eax)
  8007e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e4:	8b 00                	mov    (%eax),%eax
  8007e6:	83 e8 04             	sub    $0x4,%eax
  8007e9:	8b 00                	mov    (%eax),%eax
  8007eb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007f0:	5d                   	pop    %ebp
  8007f1:	c3                   	ret    

008007f2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007f5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007f9:	7e 1c                	jle    800817 <getint+0x25>
		return va_arg(*ap, long long);
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	8b 00                	mov    (%eax),%eax
  800800:	8d 50 08             	lea    0x8(%eax),%edx
  800803:	8b 45 08             	mov    0x8(%ebp),%eax
  800806:	89 10                	mov    %edx,(%eax)
  800808:	8b 45 08             	mov    0x8(%ebp),%eax
  80080b:	8b 00                	mov    (%eax),%eax
  80080d:	83 e8 08             	sub    $0x8,%eax
  800810:	8b 50 04             	mov    0x4(%eax),%edx
  800813:	8b 00                	mov    (%eax),%eax
  800815:	eb 38                	jmp    80084f <getint+0x5d>
	else if (lflag)
  800817:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80081b:	74 1a                	je     800837 <getint+0x45>
		return va_arg(*ap, long);
  80081d:	8b 45 08             	mov    0x8(%ebp),%eax
  800820:	8b 00                	mov    (%eax),%eax
  800822:	8d 50 04             	lea    0x4(%eax),%edx
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	89 10                	mov    %edx,(%eax)
  80082a:	8b 45 08             	mov    0x8(%ebp),%eax
  80082d:	8b 00                	mov    (%eax),%eax
  80082f:	83 e8 04             	sub    $0x4,%eax
  800832:	8b 00                	mov    (%eax),%eax
  800834:	99                   	cltd   
  800835:	eb 18                	jmp    80084f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	8d 50 04             	lea    0x4(%eax),%edx
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	89 10                	mov    %edx,(%eax)
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	8b 00                	mov    (%eax),%eax
  800849:	83 e8 04             	sub    $0x4,%eax
  80084c:	8b 00                	mov    (%eax),%eax
  80084e:	99                   	cltd   
}
  80084f:	5d                   	pop    %ebp
  800850:	c3                   	ret    

00800851 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
  800854:	56                   	push   %esi
  800855:	53                   	push   %ebx
  800856:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800859:	eb 17                	jmp    800872 <vprintfmt+0x21>
			if (ch == '\0')
  80085b:	85 db                	test   %ebx,%ebx
  80085d:	0f 84 c1 03 00 00    	je     800c24 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	ff 75 0c             	pushl  0xc(%ebp)
  800869:	53                   	push   %ebx
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	ff d0                	call   *%eax
  80086f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800872:	8b 45 10             	mov    0x10(%ebp),%eax
  800875:	8d 50 01             	lea    0x1(%eax),%edx
  800878:	89 55 10             	mov    %edx,0x10(%ebp)
  80087b:	8a 00                	mov    (%eax),%al
  80087d:	0f b6 d8             	movzbl %al,%ebx
  800880:	83 fb 25             	cmp    $0x25,%ebx
  800883:	75 d6                	jne    80085b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800885:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800889:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800890:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800897:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80089e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a8:	8d 50 01             	lea    0x1(%eax),%edx
  8008ab:	89 55 10             	mov    %edx,0x10(%ebp)
  8008ae:	8a 00                	mov    (%eax),%al
  8008b0:	0f b6 d8             	movzbl %al,%ebx
  8008b3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008b6:	83 f8 5b             	cmp    $0x5b,%eax
  8008b9:	0f 87 3d 03 00 00    	ja     800bfc <vprintfmt+0x3ab>
  8008bf:	8b 04 85 f8 44 80 00 	mov    0x8044f8(,%eax,4),%eax
  8008c6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008c8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008cc:	eb d7                	jmp    8008a5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008ce:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008d2:	eb d1                	jmp    8008a5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008d4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008de:	89 d0                	mov    %edx,%eax
  8008e0:	c1 e0 02             	shl    $0x2,%eax
  8008e3:	01 d0                	add    %edx,%eax
  8008e5:	01 c0                	add    %eax,%eax
  8008e7:	01 d8                	add    %ebx,%eax
  8008e9:	83 e8 30             	sub    $0x30,%eax
  8008ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f2:	8a 00                	mov    (%eax),%al
  8008f4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008f7:	83 fb 2f             	cmp    $0x2f,%ebx
  8008fa:	7e 3e                	jle    80093a <vprintfmt+0xe9>
  8008fc:	83 fb 39             	cmp    $0x39,%ebx
  8008ff:	7f 39                	jg     80093a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800901:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800904:	eb d5                	jmp    8008db <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800906:	8b 45 14             	mov    0x14(%ebp),%eax
  800909:	83 c0 04             	add    $0x4,%eax
  80090c:	89 45 14             	mov    %eax,0x14(%ebp)
  80090f:	8b 45 14             	mov    0x14(%ebp),%eax
  800912:	83 e8 04             	sub    $0x4,%eax
  800915:	8b 00                	mov    (%eax),%eax
  800917:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80091a:	eb 1f                	jmp    80093b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80091c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800920:	79 83                	jns    8008a5 <vprintfmt+0x54>
				width = 0;
  800922:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800929:	e9 77 ff ff ff       	jmp    8008a5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80092e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800935:	e9 6b ff ff ff       	jmp    8008a5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80093a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80093b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80093f:	0f 89 60 ff ff ff    	jns    8008a5 <vprintfmt+0x54>
				width = precision, precision = -1;
  800945:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800948:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80094b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800952:	e9 4e ff ff ff       	jmp    8008a5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800957:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80095a:	e9 46 ff ff ff       	jmp    8008a5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80095f:	8b 45 14             	mov    0x14(%ebp),%eax
  800962:	83 c0 04             	add    $0x4,%eax
  800965:	89 45 14             	mov    %eax,0x14(%ebp)
  800968:	8b 45 14             	mov    0x14(%ebp),%eax
  80096b:	83 e8 04             	sub    $0x4,%eax
  80096e:	8b 00                	mov    (%eax),%eax
  800970:	83 ec 08             	sub    $0x8,%esp
  800973:	ff 75 0c             	pushl  0xc(%ebp)
  800976:	50                   	push   %eax
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	ff d0                	call   *%eax
  80097c:	83 c4 10             	add    $0x10,%esp
			break;
  80097f:	e9 9b 02 00 00       	jmp    800c1f <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800984:	8b 45 14             	mov    0x14(%ebp),%eax
  800987:	83 c0 04             	add    $0x4,%eax
  80098a:	89 45 14             	mov    %eax,0x14(%ebp)
  80098d:	8b 45 14             	mov    0x14(%ebp),%eax
  800990:	83 e8 04             	sub    $0x4,%eax
  800993:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800995:	85 db                	test   %ebx,%ebx
  800997:	79 02                	jns    80099b <vprintfmt+0x14a>
				err = -err;
  800999:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80099b:	83 fb 64             	cmp    $0x64,%ebx
  80099e:	7f 0b                	jg     8009ab <vprintfmt+0x15a>
  8009a0:	8b 34 9d 40 43 80 00 	mov    0x804340(,%ebx,4),%esi
  8009a7:	85 f6                	test   %esi,%esi
  8009a9:	75 19                	jne    8009c4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009ab:	53                   	push   %ebx
  8009ac:	68 e5 44 80 00       	push   $0x8044e5
  8009b1:	ff 75 0c             	pushl  0xc(%ebp)
  8009b4:	ff 75 08             	pushl  0x8(%ebp)
  8009b7:	e8 70 02 00 00       	call   800c2c <printfmt>
  8009bc:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009bf:	e9 5b 02 00 00       	jmp    800c1f <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009c4:	56                   	push   %esi
  8009c5:	68 ee 44 80 00       	push   $0x8044ee
  8009ca:	ff 75 0c             	pushl  0xc(%ebp)
  8009cd:	ff 75 08             	pushl  0x8(%ebp)
  8009d0:	e8 57 02 00 00       	call   800c2c <printfmt>
  8009d5:	83 c4 10             	add    $0x10,%esp
			break;
  8009d8:	e9 42 02 00 00       	jmp    800c1f <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e0:	83 c0 04             	add    $0x4,%eax
  8009e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8009e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e9:	83 e8 04             	sub    $0x4,%eax
  8009ec:	8b 30                	mov    (%eax),%esi
  8009ee:	85 f6                	test   %esi,%esi
  8009f0:	75 05                	jne    8009f7 <vprintfmt+0x1a6>
				p = "(null)";
  8009f2:	be f1 44 80 00       	mov    $0x8044f1,%esi
			if (width > 0 && padc != '-')
  8009f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009fb:	7e 6d                	jle    800a6a <vprintfmt+0x219>
  8009fd:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a01:	74 67                	je     800a6a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	50                   	push   %eax
  800a0a:	56                   	push   %esi
  800a0b:	e8 1e 03 00 00       	call   800d2e <strnlen>
  800a10:	83 c4 10             	add    $0x10,%esp
  800a13:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a16:	eb 16                	jmp    800a2e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a18:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a1c:	83 ec 08             	sub    $0x8,%esp
  800a1f:	ff 75 0c             	pushl  0xc(%ebp)
  800a22:	50                   	push   %eax
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	ff d0                	call   *%eax
  800a28:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a2b:	ff 4d e4             	decl   -0x1c(%ebp)
  800a2e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a32:	7f e4                	jg     800a18 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a34:	eb 34                	jmp    800a6a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a36:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a3a:	74 1c                	je     800a58 <vprintfmt+0x207>
  800a3c:	83 fb 1f             	cmp    $0x1f,%ebx
  800a3f:	7e 05                	jle    800a46 <vprintfmt+0x1f5>
  800a41:	83 fb 7e             	cmp    $0x7e,%ebx
  800a44:	7e 12                	jle    800a58 <vprintfmt+0x207>
					putch('?', putdat);
  800a46:	83 ec 08             	sub    $0x8,%esp
  800a49:	ff 75 0c             	pushl  0xc(%ebp)
  800a4c:	6a 3f                	push   $0x3f
  800a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a51:	ff d0                	call   *%eax
  800a53:	83 c4 10             	add    $0x10,%esp
  800a56:	eb 0f                	jmp    800a67 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a58:	83 ec 08             	sub    $0x8,%esp
  800a5b:	ff 75 0c             	pushl  0xc(%ebp)
  800a5e:	53                   	push   %ebx
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	ff d0                	call   *%eax
  800a64:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a67:	ff 4d e4             	decl   -0x1c(%ebp)
  800a6a:	89 f0                	mov    %esi,%eax
  800a6c:	8d 70 01             	lea    0x1(%eax),%esi
  800a6f:	8a 00                	mov    (%eax),%al
  800a71:	0f be d8             	movsbl %al,%ebx
  800a74:	85 db                	test   %ebx,%ebx
  800a76:	74 24                	je     800a9c <vprintfmt+0x24b>
  800a78:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a7c:	78 b8                	js     800a36 <vprintfmt+0x1e5>
  800a7e:	ff 4d e0             	decl   -0x20(%ebp)
  800a81:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a85:	79 af                	jns    800a36 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a87:	eb 13                	jmp    800a9c <vprintfmt+0x24b>
				putch(' ', putdat);
  800a89:	83 ec 08             	sub    $0x8,%esp
  800a8c:	ff 75 0c             	pushl  0xc(%ebp)
  800a8f:	6a 20                	push   $0x20
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	ff d0                	call   *%eax
  800a96:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a99:	ff 4d e4             	decl   -0x1c(%ebp)
  800a9c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aa0:	7f e7                	jg     800a89 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800aa2:	e9 78 01 00 00       	jmp    800c1f <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800aa7:	83 ec 08             	sub    $0x8,%esp
  800aaa:	ff 75 e8             	pushl  -0x18(%ebp)
  800aad:	8d 45 14             	lea    0x14(%ebp),%eax
  800ab0:	50                   	push   %eax
  800ab1:	e8 3c fd ff ff       	call   8007f2 <getint>
  800ab6:	83 c4 10             	add    $0x10,%esp
  800ab9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800abc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ac5:	85 d2                	test   %edx,%edx
  800ac7:	79 23                	jns    800aec <vprintfmt+0x29b>
				putch('-', putdat);
  800ac9:	83 ec 08             	sub    $0x8,%esp
  800acc:	ff 75 0c             	pushl  0xc(%ebp)
  800acf:	6a 2d                	push   $0x2d
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	ff d0                	call   *%eax
  800ad6:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800adc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800adf:	f7 d8                	neg    %eax
  800ae1:	83 d2 00             	adc    $0x0,%edx
  800ae4:	f7 da                	neg    %edx
  800ae6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800aec:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800af3:	e9 bc 00 00 00       	jmp    800bb4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 e8             	pushl  -0x18(%ebp)
  800afe:	8d 45 14             	lea    0x14(%ebp),%eax
  800b01:	50                   	push   %eax
  800b02:	e8 84 fc ff ff       	call   80078b <getuint>
  800b07:	83 c4 10             	add    $0x10,%esp
  800b0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b10:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b17:	e9 98 00 00 00       	jmp    800bb4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b1c:	83 ec 08             	sub    $0x8,%esp
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	6a 58                	push   $0x58
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	ff d0                	call   *%eax
  800b29:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b2c:	83 ec 08             	sub    $0x8,%esp
  800b2f:	ff 75 0c             	pushl  0xc(%ebp)
  800b32:	6a 58                	push   $0x58
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	ff d0                	call   *%eax
  800b39:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	6a 58                	push   $0x58
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	ff d0                	call   *%eax
  800b49:	83 c4 10             	add    $0x10,%esp
			break;
  800b4c:	e9 ce 00 00 00       	jmp    800c1f <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b51:	83 ec 08             	sub    $0x8,%esp
  800b54:	ff 75 0c             	pushl  0xc(%ebp)
  800b57:	6a 30                	push   $0x30
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	ff d0                	call   *%eax
  800b5e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b61:	83 ec 08             	sub    $0x8,%esp
  800b64:	ff 75 0c             	pushl  0xc(%ebp)
  800b67:	6a 78                	push   $0x78
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	ff d0                	call   *%eax
  800b6e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b71:	8b 45 14             	mov    0x14(%ebp),%eax
  800b74:	83 c0 04             	add    $0x4,%eax
  800b77:	89 45 14             	mov    %eax,0x14(%ebp)
  800b7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7d:	83 e8 04             	sub    $0x4,%eax
  800b80:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b8c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b93:	eb 1f                	jmp    800bb4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b95:	83 ec 08             	sub    $0x8,%esp
  800b98:	ff 75 e8             	pushl  -0x18(%ebp)
  800b9b:	8d 45 14             	lea    0x14(%ebp),%eax
  800b9e:	50                   	push   %eax
  800b9f:	e8 e7 fb ff ff       	call   80078b <getuint>
  800ba4:	83 c4 10             	add    $0x10,%esp
  800ba7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800baa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bad:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bb4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bbb:	83 ec 04             	sub    $0x4,%esp
  800bbe:	52                   	push   %edx
  800bbf:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bc2:	50                   	push   %eax
  800bc3:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc6:	ff 75 f0             	pushl  -0x10(%ebp)
  800bc9:	ff 75 0c             	pushl  0xc(%ebp)
  800bcc:	ff 75 08             	pushl  0x8(%ebp)
  800bcf:	e8 00 fb ff ff       	call   8006d4 <printnum>
  800bd4:	83 c4 20             	add    $0x20,%esp
			break;
  800bd7:	eb 46                	jmp    800c1f <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bd9:	83 ec 08             	sub    $0x8,%esp
  800bdc:	ff 75 0c             	pushl  0xc(%ebp)
  800bdf:	53                   	push   %ebx
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	ff d0                	call   *%eax
  800be5:	83 c4 10             	add    $0x10,%esp
			break;
  800be8:	eb 35                	jmp    800c1f <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800bea:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800bf1:	eb 2c                	jmp    800c1f <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800bf3:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  800bfa:	eb 23                	jmp    800c1f <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bfc:	83 ec 08             	sub    $0x8,%esp
  800bff:	ff 75 0c             	pushl  0xc(%ebp)
  800c02:	6a 25                	push   $0x25
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
  800c07:	ff d0                	call   *%eax
  800c09:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c0c:	ff 4d 10             	decl   0x10(%ebp)
  800c0f:	eb 03                	jmp    800c14 <vprintfmt+0x3c3>
  800c11:	ff 4d 10             	decl   0x10(%ebp)
  800c14:	8b 45 10             	mov    0x10(%ebp),%eax
  800c17:	48                   	dec    %eax
  800c18:	8a 00                	mov    (%eax),%al
  800c1a:	3c 25                	cmp    $0x25,%al
  800c1c:	75 f3                	jne    800c11 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c1e:	90                   	nop
		}
	}
  800c1f:	e9 35 fc ff ff       	jmp    800859 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c24:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c28:	5b                   	pop    %ebx
  800c29:	5e                   	pop    %esi
  800c2a:	5d                   	pop    %ebp
  800c2b:	c3                   	ret    

00800c2c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c32:	8d 45 10             	lea    0x10(%ebp),%eax
  800c35:	83 c0 04             	add    $0x4,%eax
  800c38:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c41:	50                   	push   %eax
  800c42:	ff 75 0c             	pushl  0xc(%ebp)
  800c45:	ff 75 08             	pushl  0x8(%ebp)
  800c48:	e8 04 fc ff ff       	call   800851 <vprintfmt>
  800c4d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c50:	90                   	nop
  800c51:	c9                   	leave  
  800c52:	c3                   	ret    

00800c53 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c59:	8b 40 08             	mov    0x8(%eax),%eax
  800c5c:	8d 50 01             	lea    0x1(%eax),%edx
  800c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c62:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c68:	8b 10                	mov    (%eax),%edx
  800c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6d:	8b 40 04             	mov    0x4(%eax),%eax
  800c70:	39 c2                	cmp    %eax,%edx
  800c72:	73 12                	jae    800c86 <sprintputch+0x33>
		*b->buf++ = ch;
  800c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c77:	8b 00                	mov    (%eax),%eax
  800c79:	8d 48 01             	lea    0x1(%eax),%ecx
  800c7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c7f:	89 0a                	mov    %ecx,(%edx)
  800c81:	8b 55 08             	mov    0x8(%ebp),%edx
  800c84:	88 10                	mov    %dl,(%eax)
}
  800c86:	90                   	nop
  800c87:	5d                   	pop    %ebp
  800c88:	c3                   	ret    

00800c89 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c98:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	01 d0                	add    %edx,%eax
  800ca0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800caa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cae:	74 06                	je     800cb6 <vsnprintf+0x2d>
  800cb0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb4:	7f 07                	jg     800cbd <vsnprintf+0x34>
		return -E_INVAL;
  800cb6:	b8 03 00 00 00       	mov    $0x3,%eax
  800cbb:	eb 20                	jmp    800cdd <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cbd:	ff 75 14             	pushl  0x14(%ebp)
  800cc0:	ff 75 10             	pushl  0x10(%ebp)
  800cc3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cc6:	50                   	push   %eax
  800cc7:	68 53 0c 80 00       	push   $0x800c53
  800ccc:	e8 80 fb ff ff       	call   800851 <vprintfmt>
  800cd1:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cd7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cdd:	c9                   	leave  
  800cde:	c3                   	ret    

00800cdf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ce5:	8d 45 10             	lea    0x10(%ebp),%eax
  800ce8:	83 c0 04             	add    $0x4,%eax
  800ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cee:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf1:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf4:	50                   	push   %eax
  800cf5:	ff 75 0c             	pushl  0xc(%ebp)
  800cf8:	ff 75 08             	pushl  0x8(%ebp)
  800cfb:	e8 89 ff ff ff       	call   800c89 <vsnprintf>
  800d00:	83 c4 10             	add    $0x10,%esp
  800d03:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d06:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d09:	c9                   	leave  
  800d0a:	c3                   	ret    

00800d0b <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d18:	eb 06                	jmp    800d20 <strlen+0x15>
		n++;
  800d1a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d1d:	ff 45 08             	incl   0x8(%ebp)
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	8a 00                	mov    (%eax),%al
  800d25:	84 c0                	test   %al,%al
  800d27:	75 f1                	jne    800d1a <strlen+0xf>
		n++;
	return n;
  800d29:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d2c:	c9                   	leave  
  800d2d:	c3                   	ret    

00800d2e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d3b:	eb 09                	jmp    800d46 <strnlen+0x18>
		n++;
  800d3d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d40:	ff 45 08             	incl   0x8(%ebp)
  800d43:	ff 4d 0c             	decl   0xc(%ebp)
  800d46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d4a:	74 09                	je     800d55 <strnlen+0x27>
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8a 00                	mov    (%eax),%al
  800d51:	84 c0                	test   %al,%al
  800d53:	75 e8                	jne    800d3d <strnlen+0xf>
		n++;
	return n;
  800d55:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d58:	c9                   	leave  
  800d59:	c3                   	ret    

00800d5a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d66:	90                   	nop
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8d 50 01             	lea    0x1(%eax),%edx
  800d6d:	89 55 08             	mov    %edx,0x8(%ebp)
  800d70:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d73:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d76:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d79:	8a 12                	mov    (%edx),%dl
  800d7b:	88 10                	mov    %dl,(%eax)
  800d7d:	8a 00                	mov    (%eax),%al
  800d7f:	84 c0                	test   %al,%al
  800d81:	75 e4                	jne    800d67 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d83:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d86:	c9                   	leave  
  800d87:	c3                   	ret    

00800d88 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d9b:	eb 1f                	jmp    800dbc <strncpy+0x34>
		*dst++ = *src;
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	8d 50 01             	lea    0x1(%eax),%edx
  800da3:	89 55 08             	mov    %edx,0x8(%ebp)
  800da6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da9:	8a 12                	mov    (%edx),%dl
  800dab:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db0:	8a 00                	mov    (%eax),%al
  800db2:	84 c0                	test   %al,%al
  800db4:	74 03                	je     800db9 <strncpy+0x31>
			src++;
  800db6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800db9:	ff 45 fc             	incl   -0x4(%ebp)
  800dbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbf:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dc2:	72 d9                	jb     800d9d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800dc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dc7:	c9                   	leave  
  800dc8:	c3                   	ret    

00800dc9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd9:	74 30                	je     800e0b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ddb:	eb 16                	jmp    800df3 <strlcpy+0x2a>
			*dst++ = *src++;
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8d 50 01             	lea    0x1(%eax),%edx
  800de3:	89 55 08             	mov    %edx,0x8(%ebp)
  800de6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dec:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800def:	8a 12                	mov    (%edx),%dl
  800df1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800df3:	ff 4d 10             	decl   0x10(%ebp)
  800df6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dfa:	74 09                	je     800e05 <strlcpy+0x3c>
  800dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	84 c0                	test   %al,%al
  800e03:	75 d8                	jne    800ddd <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e11:	29 c2                	sub    %eax,%edx
  800e13:	89 d0                	mov    %edx,%eax
}
  800e15:	c9                   	leave  
  800e16:	c3                   	ret    

00800e17 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e1a:	eb 06                	jmp    800e22 <strcmp+0xb>
		p++, q++;
  800e1c:	ff 45 08             	incl   0x8(%ebp)
  800e1f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	8a 00                	mov    (%eax),%al
  800e27:	84 c0                	test   %al,%al
  800e29:	74 0e                	je     800e39 <strcmp+0x22>
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	8a 10                	mov    (%eax),%dl
  800e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e33:	8a 00                	mov    (%eax),%al
  800e35:	38 c2                	cmp    %al,%dl
  800e37:	74 e3                	je     800e1c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	0f b6 d0             	movzbl %al,%edx
  800e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	0f b6 c0             	movzbl %al,%eax
  800e49:	29 c2                	sub    %eax,%edx
  800e4b:	89 d0                	mov    %edx,%eax
}
  800e4d:	5d                   	pop    %ebp
  800e4e:	c3                   	ret    

00800e4f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e52:	eb 09                	jmp    800e5d <strncmp+0xe>
		n--, p++, q++;
  800e54:	ff 4d 10             	decl   0x10(%ebp)
  800e57:	ff 45 08             	incl   0x8(%ebp)
  800e5a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e5d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e61:	74 17                	je     800e7a <strncmp+0x2b>
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	8a 00                	mov    (%eax),%al
  800e68:	84 c0                	test   %al,%al
  800e6a:	74 0e                	je     800e7a <strncmp+0x2b>
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8a 10                	mov    (%eax),%dl
  800e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	38 c2                	cmp    %al,%dl
  800e78:	74 da                	je     800e54 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e7e:	75 07                	jne    800e87 <strncmp+0x38>
		return 0;
  800e80:	b8 00 00 00 00       	mov    $0x0,%eax
  800e85:	eb 14                	jmp    800e9b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	8a 00                	mov    (%eax),%al
  800e8c:	0f b6 d0             	movzbl %al,%edx
  800e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e92:	8a 00                	mov    (%eax),%al
  800e94:	0f b6 c0             	movzbl %al,%eax
  800e97:	29 c2                	sub    %eax,%edx
  800e99:	89 d0                	mov    %edx,%eax
}
  800e9b:	5d                   	pop    %ebp
  800e9c:	c3                   	ret    

00800e9d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e9d:	55                   	push   %ebp
  800e9e:	89 e5                	mov    %esp,%ebp
  800ea0:	83 ec 04             	sub    $0x4,%esp
  800ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ea9:	eb 12                	jmp    800ebd <strchr+0x20>
		if (*s == c)
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	8a 00                	mov    (%eax),%al
  800eb0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eb3:	75 05                	jne    800eba <strchr+0x1d>
			return (char *) s;
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	eb 11                	jmp    800ecb <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800eba:	ff 45 08             	incl   0x8(%ebp)
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	84 c0                	test   %al,%al
  800ec4:	75 e5                	jne    800eab <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ec6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ecb:	c9                   	leave  
  800ecc:	c3                   	ret    

00800ecd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	83 ec 04             	sub    $0x4,%esp
  800ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ed9:	eb 0d                	jmp    800ee8 <strfind+0x1b>
		if (*s == c)
  800edb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ede:	8a 00                	mov    (%eax),%al
  800ee0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ee3:	74 0e                	je     800ef3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ee5:	ff 45 08             	incl   0x8(%ebp)
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	84 c0                	test   %al,%al
  800eef:	75 ea                	jne    800edb <strfind+0xe>
  800ef1:	eb 01                	jmp    800ef4 <strfind+0x27>
		if (*s == c)
			break;
  800ef3:	90                   	nop
	return (char *) s;
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef7:	c9                   	leave  
  800ef8:	c3                   	ret    

00800ef9 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ef9:	55                   	push   %ebp
  800efa:	89 e5                	mov    %esp,%ebp
  800efc:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f05:	8b 45 10             	mov    0x10(%ebp),%eax
  800f08:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f0b:	eb 0e                	jmp    800f1b <memset+0x22>
		*p++ = c;
  800f0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f10:	8d 50 01             	lea    0x1(%eax),%edx
  800f13:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f19:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f1b:	ff 4d f8             	decl   -0x8(%ebp)
  800f1e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f22:	79 e9                	jns    800f0d <memset+0x14>
		*p++ = c;

	return v;
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f27:	c9                   	leave  
  800f28:	c3                   	ret    

00800f29 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
  800f2c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f3b:	eb 16                	jmp    800f53 <memcpy+0x2a>
		*d++ = *s++;
  800f3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f40:	8d 50 01             	lea    0x1(%eax),%edx
  800f43:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f46:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f49:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f4c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f4f:	8a 12                	mov    (%edx),%dl
  800f51:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f53:	8b 45 10             	mov    0x10(%ebp),%eax
  800f56:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f59:	89 55 10             	mov    %edx,0x10(%ebp)
  800f5c:	85 c0                	test   %eax,%eax
  800f5e:	75 dd                	jne    800f3d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f63:	c9                   	leave  
  800f64:	c3                   	ret    

00800f65 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f7a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f7d:	73 50                	jae    800fcf <memmove+0x6a>
  800f7f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f82:	8b 45 10             	mov    0x10(%ebp),%eax
  800f85:	01 d0                	add    %edx,%eax
  800f87:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f8a:	76 43                	jbe    800fcf <memmove+0x6a>
		s += n;
  800f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f92:	8b 45 10             	mov    0x10(%ebp),%eax
  800f95:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f98:	eb 10                	jmp    800faa <memmove+0x45>
			*--d = *--s;
  800f9a:	ff 4d f8             	decl   -0x8(%ebp)
  800f9d:	ff 4d fc             	decl   -0x4(%ebp)
  800fa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa3:	8a 10                	mov    (%eax),%dl
  800fa5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800faa:	8b 45 10             	mov    0x10(%ebp),%eax
  800fad:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb0:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb3:	85 c0                	test   %eax,%eax
  800fb5:	75 e3                	jne    800f9a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fb7:	eb 23                	jmp    800fdc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fbc:	8d 50 01             	lea    0x1(%eax),%edx
  800fbf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fc5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fcb:	8a 12                	mov    (%edx),%dl
  800fcd:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd5:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd8:	85 c0                	test   %eax,%eax
  800fda:	75 dd                	jne    800fb9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fdf:	c9                   	leave  
  800fe0:	c3                   	ret    

00800fe1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ff3:	eb 2a                	jmp    80101f <memcmp+0x3e>
		if (*s1 != *s2)
  800ff5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff8:	8a 10                	mov    (%eax),%dl
  800ffa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	38 c2                	cmp    %al,%dl
  801001:	74 16                	je     801019 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801003:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	0f b6 d0             	movzbl %al,%edx
  80100b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	0f b6 c0             	movzbl %al,%eax
  801013:	29 c2                	sub    %eax,%edx
  801015:	89 d0                	mov    %edx,%eax
  801017:	eb 18                	jmp    801031 <memcmp+0x50>
		s1++, s2++;
  801019:	ff 45 fc             	incl   -0x4(%ebp)
  80101c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80101f:	8b 45 10             	mov    0x10(%ebp),%eax
  801022:	8d 50 ff             	lea    -0x1(%eax),%edx
  801025:	89 55 10             	mov    %edx,0x10(%ebp)
  801028:	85 c0                	test   %eax,%eax
  80102a:	75 c9                	jne    800ff5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80102c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801031:	c9                   	leave  
  801032:	c3                   	ret    

00801033 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801039:	8b 55 08             	mov    0x8(%ebp),%edx
  80103c:	8b 45 10             	mov    0x10(%ebp),%eax
  80103f:	01 d0                	add    %edx,%eax
  801041:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801044:	eb 15                	jmp    80105b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 00                	mov    (%eax),%al
  80104b:	0f b6 d0             	movzbl %al,%edx
  80104e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801051:	0f b6 c0             	movzbl %al,%eax
  801054:	39 c2                	cmp    %eax,%edx
  801056:	74 0d                	je     801065 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801058:	ff 45 08             	incl   0x8(%ebp)
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801061:	72 e3                	jb     801046 <memfind+0x13>
  801063:	eb 01                	jmp    801066 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801065:	90                   	nop
	return (void *) s;
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801069:	c9                   	leave  
  80106a:	c3                   	ret    

0080106b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801071:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801078:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80107f:	eb 03                	jmp    801084 <strtol+0x19>
		s++;
  801081:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	3c 20                	cmp    $0x20,%al
  80108b:	74 f4                	je     801081 <strtol+0x16>
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	3c 09                	cmp    $0x9,%al
  801094:	74 eb                	je     801081 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	3c 2b                	cmp    $0x2b,%al
  80109d:	75 05                	jne    8010a4 <strtol+0x39>
		s++;
  80109f:	ff 45 08             	incl   0x8(%ebp)
  8010a2:	eb 13                	jmp    8010b7 <strtol+0x4c>
	else if (*s == '-')
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	3c 2d                	cmp    $0x2d,%al
  8010ab:	75 0a                	jne    8010b7 <strtol+0x4c>
		s++, neg = 1;
  8010ad:	ff 45 08             	incl   0x8(%ebp)
  8010b0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010bb:	74 06                	je     8010c3 <strtol+0x58>
  8010bd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010c1:	75 20                	jne    8010e3 <strtol+0x78>
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	3c 30                	cmp    $0x30,%al
  8010ca:	75 17                	jne    8010e3 <strtol+0x78>
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	40                   	inc    %eax
  8010d0:	8a 00                	mov    (%eax),%al
  8010d2:	3c 78                	cmp    $0x78,%al
  8010d4:	75 0d                	jne    8010e3 <strtol+0x78>
		s += 2, base = 16;
  8010d6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010da:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010e1:	eb 28                	jmp    80110b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e7:	75 15                	jne    8010fe <strtol+0x93>
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	8a 00                	mov    (%eax),%al
  8010ee:	3c 30                	cmp    $0x30,%al
  8010f0:	75 0c                	jne    8010fe <strtol+0x93>
		s++, base = 8;
  8010f2:	ff 45 08             	incl   0x8(%ebp)
  8010f5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010fc:	eb 0d                	jmp    80110b <strtol+0xa0>
	else if (base == 0)
  8010fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801102:	75 07                	jne    80110b <strtol+0xa0>
		base = 10;
  801104:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	8a 00                	mov    (%eax),%al
  801110:	3c 2f                	cmp    $0x2f,%al
  801112:	7e 19                	jle    80112d <strtol+0xc2>
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	8a 00                	mov    (%eax),%al
  801119:	3c 39                	cmp    $0x39,%al
  80111b:	7f 10                	jg     80112d <strtol+0xc2>
			dig = *s - '0';
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	8a 00                	mov    (%eax),%al
  801122:	0f be c0             	movsbl %al,%eax
  801125:	83 e8 30             	sub    $0x30,%eax
  801128:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80112b:	eb 42                	jmp    80116f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	8a 00                	mov    (%eax),%al
  801132:	3c 60                	cmp    $0x60,%al
  801134:	7e 19                	jle    80114f <strtol+0xe4>
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	8a 00                	mov    (%eax),%al
  80113b:	3c 7a                	cmp    $0x7a,%al
  80113d:	7f 10                	jg     80114f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	0f be c0             	movsbl %al,%eax
  801147:	83 e8 57             	sub    $0x57,%eax
  80114a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80114d:	eb 20                	jmp    80116f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	8a 00                	mov    (%eax),%al
  801154:	3c 40                	cmp    $0x40,%al
  801156:	7e 39                	jle    801191 <strtol+0x126>
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	8a 00                	mov    (%eax),%al
  80115d:	3c 5a                	cmp    $0x5a,%al
  80115f:	7f 30                	jg     801191 <strtol+0x126>
			dig = *s - 'A' + 10;
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	0f be c0             	movsbl %al,%eax
  801169:	83 e8 37             	sub    $0x37,%eax
  80116c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80116f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801172:	3b 45 10             	cmp    0x10(%ebp),%eax
  801175:	7d 19                	jge    801190 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801177:	ff 45 08             	incl   0x8(%ebp)
  80117a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801181:	89 c2                	mov    %eax,%edx
  801183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801186:	01 d0                	add    %edx,%eax
  801188:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80118b:	e9 7b ff ff ff       	jmp    80110b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801190:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801191:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801195:	74 08                	je     80119f <strtol+0x134>
		*endptr = (char *) s;
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	8b 55 08             	mov    0x8(%ebp),%edx
  80119d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80119f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011a3:	74 07                	je     8011ac <strtol+0x141>
  8011a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a8:	f7 d8                	neg    %eax
  8011aa:	eb 03                	jmp    8011af <strtol+0x144>
  8011ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011af:	c9                   	leave  
  8011b0:	c3                   	ret    

008011b1 <ltostr>:

void
ltostr(long value, char *str)
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c9:	79 13                	jns    8011de <ltostr+0x2d>
	{
		neg = 1;
  8011cb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011d8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011db:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011de:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011e6:	99                   	cltd   
  8011e7:	f7 f9                	idiv   %ecx
  8011e9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ef:	8d 50 01             	lea    0x1(%eax),%edx
  8011f2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011f5:	89 c2                	mov    %eax,%edx
  8011f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fa:	01 d0                	add    %edx,%eax
  8011fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011ff:	83 c2 30             	add    $0x30,%edx
  801202:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801204:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801207:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80120c:	f7 e9                	imul   %ecx
  80120e:	c1 fa 02             	sar    $0x2,%edx
  801211:	89 c8                	mov    %ecx,%eax
  801213:	c1 f8 1f             	sar    $0x1f,%eax
  801216:	29 c2                	sub    %eax,%edx
  801218:	89 d0                	mov    %edx,%eax
  80121a:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80121d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801221:	75 bb                	jne    8011de <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801223:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80122a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80122d:	48                   	dec    %eax
  80122e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801231:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801235:	74 3d                	je     801274 <ltostr+0xc3>
		start = 1 ;
  801237:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80123e:	eb 34                	jmp    801274 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801240:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801243:	8b 45 0c             	mov    0xc(%ebp),%eax
  801246:	01 d0                	add    %edx,%eax
  801248:	8a 00                	mov    (%eax),%al
  80124a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80124d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801250:	8b 45 0c             	mov    0xc(%ebp),%eax
  801253:	01 c2                	add    %eax,%edx
  801255:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801258:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125b:	01 c8                	add    %ecx,%eax
  80125d:	8a 00                	mov    (%eax),%al
  80125f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801261:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801264:	8b 45 0c             	mov    0xc(%ebp),%eax
  801267:	01 c2                	add    %eax,%edx
  801269:	8a 45 eb             	mov    -0x15(%ebp),%al
  80126c:	88 02                	mov    %al,(%edx)
		start++ ;
  80126e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801271:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801277:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80127a:	7c c4                	jl     801240 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80127c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80127f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801282:	01 d0                	add    %edx,%eax
  801284:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801287:	90                   	nop
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801290:	ff 75 08             	pushl  0x8(%ebp)
  801293:	e8 73 fa ff ff       	call   800d0b <strlen>
  801298:	83 c4 04             	add    $0x4,%esp
  80129b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80129e:	ff 75 0c             	pushl  0xc(%ebp)
  8012a1:	e8 65 fa ff ff       	call   800d0b <strlen>
  8012a6:	83 c4 04             	add    $0x4,%esp
  8012a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012ba:	eb 17                	jmp    8012d3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c2:	01 c2                	add    %eax,%edx
  8012c4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	01 c8                	add    %ecx,%eax
  8012cc:	8a 00                	mov    (%eax),%al
  8012ce:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012d0:	ff 45 fc             	incl   -0x4(%ebp)
  8012d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012d9:	7c e1                	jl     8012bc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012e9:	eb 1f                	jmp    80130a <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ee:	8d 50 01             	lea    0x1(%eax),%edx
  8012f1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012f4:	89 c2                	mov    %eax,%edx
  8012f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f9:	01 c2                	add    %eax,%edx
  8012fb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801301:	01 c8                	add    %ecx,%eax
  801303:	8a 00                	mov    (%eax),%al
  801305:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801307:	ff 45 f8             	incl   -0x8(%ebp)
  80130a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801310:	7c d9                	jl     8012eb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801312:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801315:	8b 45 10             	mov    0x10(%ebp),%eax
  801318:	01 d0                	add    %edx,%eax
  80131a:	c6 00 00             	movb   $0x0,(%eax)
}
  80131d:	90                   	nop
  80131e:	c9                   	leave  
  80131f:	c3                   	ret    

00801320 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801323:	8b 45 14             	mov    0x14(%ebp),%eax
  801326:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80132c:	8b 45 14             	mov    0x14(%ebp),%eax
  80132f:	8b 00                	mov    (%eax),%eax
  801331:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801338:	8b 45 10             	mov    0x10(%ebp),%eax
  80133b:	01 d0                	add    %edx,%eax
  80133d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801343:	eb 0c                	jmp    801351 <strsplit+0x31>
			*string++ = 0;
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
  801348:	8d 50 01             	lea    0x1(%eax),%edx
  80134b:	89 55 08             	mov    %edx,0x8(%ebp)
  80134e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	8a 00                	mov    (%eax),%al
  801356:	84 c0                	test   %al,%al
  801358:	74 18                	je     801372 <strsplit+0x52>
  80135a:	8b 45 08             	mov    0x8(%ebp),%eax
  80135d:	8a 00                	mov    (%eax),%al
  80135f:	0f be c0             	movsbl %al,%eax
  801362:	50                   	push   %eax
  801363:	ff 75 0c             	pushl  0xc(%ebp)
  801366:	e8 32 fb ff ff       	call   800e9d <strchr>
  80136b:	83 c4 08             	add    $0x8,%esp
  80136e:	85 c0                	test   %eax,%eax
  801370:	75 d3                	jne    801345 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	8a 00                	mov    (%eax),%al
  801377:	84 c0                	test   %al,%al
  801379:	74 5a                	je     8013d5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80137b:	8b 45 14             	mov    0x14(%ebp),%eax
  80137e:	8b 00                	mov    (%eax),%eax
  801380:	83 f8 0f             	cmp    $0xf,%eax
  801383:	75 07                	jne    80138c <strsplit+0x6c>
		{
			return 0;
  801385:	b8 00 00 00 00       	mov    $0x0,%eax
  80138a:	eb 66                	jmp    8013f2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80138c:	8b 45 14             	mov    0x14(%ebp),%eax
  80138f:	8b 00                	mov    (%eax),%eax
  801391:	8d 48 01             	lea    0x1(%eax),%ecx
  801394:	8b 55 14             	mov    0x14(%ebp),%edx
  801397:	89 0a                	mov    %ecx,(%edx)
  801399:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a3:	01 c2                	add    %eax,%edx
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013aa:	eb 03                	jmp    8013af <strsplit+0x8f>
			string++;
  8013ac:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b2:	8a 00                	mov    (%eax),%al
  8013b4:	84 c0                	test   %al,%al
  8013b6:	74 8b                	je     801343 <strsplit+0x23>
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	0f be c0             	movsbl %al,%eax
  8013c0:	50                   	push   %eax
  8013c1:	ff 75 0c             	pushl  0xc(%ebp)
  8013c4:	e8 d4 fa ff ff       	call   800e9d <strchr>
  8013c9:	83 c4 08             	add    $0x8,%esp
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	74 dc                	je     8013ac <strsplit+0x8c>
			string++;
	}
  8013d0:	e9 6e ff ff ff       	jmp    801343 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013d5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d9:	8b 00                	mov    (%eax),%eax
  8013db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e5:	01 d0                	add    %edx,%eax
  8013e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013ed:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    

008013f4 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8013fa:	83 ec 04             	sub    $0x4,%esp
  8013fd:	68 68 46 80 00       	push   $0x804668
  801402:	68 3f 01 00 00       	push   $0x13f
  801407:	68 8a 46 80 00       	push   $0x80468a
  80140c:	e8 a9 ef ff ff       	call   8003ba <_panic>

00801411 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
  801414:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801417:	83 ec 0c             	sub    $0xc,%esp
  80141a:	ff 75 08             	pushl  0x8(%ebp)
  80141d:	e8 f8 0a 00 00       	call   801f1a <sys_sbrk>
  801422:	83 c4 10             	add    $0x10,%esp
}
  801425:	c9                   	leave  
  801426:	c3                   	ret    

00801427 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
  80142a:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80142d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801431:	75 0a                	jne    80143d <malloc+0x16>
  801433:	b8 00 00 00 00       	mov    $0x0,%eax
  801438:	e9 07 02 00 00       	jmp    801644 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  80143d:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801444:	8b 55 08             	mov    0x8(%ebp),%edx
  801447:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80144a:	01 d0                	add    %edx,%eax
  80144c:	48                   	dec    %eax
  80144d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801450:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801453:	ba 00 00 00 00       	mov    $0x0,%edx
  801458:	f7 75 dc             	divl   -0x24(%ebp)
  80145b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80145e:	29 d0                	sub    %edx,%eax
  801460:	c1 e8 0c             	shr    $0xc,%eax
  801463:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801466:	a1 20 50 80 00       	mov    0x805020,%eax
  80146b:	8b 40 78             	mov    0x78(%eax),%eax
  80146e:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801473:	29 c2                	sub    %eax,%edx
  801475:	89 d0                	mov    %edx,%eax
  801477:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80147a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80147d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801482:	c1 e8 0c             	shr    $0xc,%eax
  801485:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801488:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80148f:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801496:	77 42                	ja     8014da <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801498:	e8 01 09 00 00       	call   801d9e <sys_isUHeapPlacementStrategyFIRSTFIT>
  80149d:	85 c0                	test   %eax,%eax
  80149f:	74 16                	je     8014b7 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  8014a1:	83 ec 0c             	sub    $0xc,%esp
  8014a4:	ff 75 08             	pushl  0x8(%ebp)
  8014a7:	e8 41 0e 00 00       	call   8022ed <alloc_block_FF>
  8014ac:	83 c4 10             	add    $0x10,%esp
  8014af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014b2:	e9 8a 01 00 00       	jmp    801641 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014b7:	e8 13 09 00 00       	call   801dcf <sys_isUHeapPlacementStrategyBESTFIT>
  8014bc:	85 c0                	test   %eax,%eax
  8014be:	0f 84 7d 01 00 00    	je     801641 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014c4:	83 ec 0c             	sub    $0xc,%esp
  8014c7:	ff 75 08             	pushl  0x8(%ebp)
  8014ca:	e8 da 12 00 00       	call   8027a9 <alloc_block_BF>
  8014cf:	83 c4 10             	add    $0x10,%esp
  8014d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014d5:	e9 67 01 00 00       	jmp    801641 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  8014da:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8014dd:	48                   	dec    %eax
  8014de:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8014e1:	0f 86 53 01 00 00    	jbe    80163a <malloc+0x213>
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  8014e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8014ec:	8b 40 78             	mov    0x78(%eax),%eax
  8014ef:	05 00 10 00 00       	add    $0x1000,%eax
  8014f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  8014f7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  8014fe:	e9 de 00 00 00       	jmp    8015e1 <malloc+0x1ba>
		{
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801503:	a1 20 50 80 00       	mov    0x805020,%eax
  801508:	8b 40 78             	mov    0x78(%eax),%eax
  80150b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80150e:	29 c2                	sub    %eax,%edx
  801510:	89 d0                	mov    %edx,%eax
  801512:	2d 00 10 00 00       	sub    $0x1000,%eax
  801517:	c1 e8 0c             	shr    $0xc,%eax
  80151a:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801521:	85 c0                	test   %eax,%eax
  801523:	0f 85 ab 00 00 00    	jne    8015d4 <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801529:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152c:	05 00 10 00 00       	add    $0x1000,%eax
  801531:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801534:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
				while(cnt < num_pages - 1)
  80153b:	eb 47                	jmp    801584 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  80153d:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801544:	76 0a                	jbe    801550 <malloc+0x129>
  801546:	b8 00 00 00 00       	mov    $0x0,%eax
  80154b:	e9 f4 00 00 00       	jmp    801644 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801550:	a1 20 50 80 00       	mov    0x805020,%eax
  801555:	8b 40 78             	mov    0x78(%eax),%eax
  801558:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80155b:	29 c2                	sub    %eax,%edx
  80155d:	89 d0                	mov    %edx,%eax
  80155f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801564:	c1 e8 0c             	shr    $0xc,%eax
  801567:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  80156e:	85 c0                	test   %eax,%eax
  801570:	74 08                	je     80157a <malloc+0x153>
					{
						
						i = j;
  801572:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801575:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801578:	eb 5a                	jmp    8015d4 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  80157a:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801581:	ff 45 e4             	incl   -0x1c(%ebp)
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
				while(cnt < num_pages - 1)
  801584:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801587:	48                   	dec    %eax
  801588:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80158b:	77 b0                	ja     80153d <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  80158d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801594:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80159b:	eb 2f                	jmp    8015cc <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  80159d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015a0:	c1 e0 0c             	shl    $0xc,%eax
  8015a3:	89 c2                	mov    %eax,%edx
  8015a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a8:	01 c2                	add    %eax,%edx
  8015aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8015af:	8b 40 78             	mov    0x78(%eax),%eax
  8015b2:	29 c2                	sub    %eax,%edx
  8015b4:	89 d0                	mov    %edx,%eax
  8015b6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015bb:	c1 e8 0c             	shr    $0xc,%eax
  8015be:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
  8015c5:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  8015c9:	ff 45 e0             	incl   -0x20(%ebp)
  8015cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015cf:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8015d2:	72 c9                	jb     80159d <malloc+0x176>
				}
				

			}
			sayed:
			if(ok) break;
  8015d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015d8:	75 16                	jne    8015f0 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8015da:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8015e1:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8015e8:	0f 86 15 ff ff ff    	jbe    801503 <malloc+0xdc>
  8015ee:	eb 01                	jmp    8015f1 <malloc+0x1ca>
				}
				

			}
			sayed:
			if(ok) break;
  8015f0:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  8015f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015f5:	75 07                	jne    8015fe <malloc+0x1d7>
  8015f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fc:	eb 46                	jmp    801644 <malloc+0x21d>
		ptr = (void*)i;
  8015fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801601:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801604:	a1 20 50 80 00       	mov    0x805020,%eax
  801609:	8b 40 78             	mov    0x78(%eax),%eax
  80160c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80160f:	29 c2                	sub    %eax,%edx
  801611:	89 d0                	mov    %edx,%eax
  801613:	2d 00 10 00 00       	sub    $0x1000,%eax
  801618:	c1 e8 0c             	shr    $0xc,%eax
  80161b:	89 c2                	mov    %eax,%edx
  80161d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801620:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801627:	83 ec 08             	sub    $0x8,%esp
  80162a:	ff 75 08             	pushl  0x8(%ebp)
  80162d:	ff 75 f0             	pushl  -0x10(%ebp)
  801630:	e8 1c 09 00 00       	call   801f51 <sys_allocate_user_mem>
  801635:	83 c4 10             	add    $0x10,%esp
  801638:	eb 07                	jmp    801641 <malloc+0x21a>
		
	}
	else
	{
		return NULL;
  80163a:	b8 00 00 00 00       	mov    $0x0,%eax
  80163f:	eb 03                	jmp    801644 <malloc+0x21d>
	}
	return ptr;
  801641:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801644:	c9                   	leave  
  801645:	c3                   	ret    

00801646 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  80164c:	a1 20 50 80 00       	mov    0x805020,%eax
  801651:	8b 40 78             	mov    0x78(%eax),%eax
  801654:	05 00 10 00 00       	add    $0x1000,%eax
  801659:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  80165c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801663:	a1 20 50 80 00       	mov    0x805020,%eax
  801668:	8b 50 78             	mov    0x78(%eax),%edx
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	39 c2                	cmp    %eax,%edx
  801670:	76 24                	jbe    801696 <free+0x50>
		size = get_block_size(va);
  801672:	83 ec 0c             	sub    $0xc,%esp
  801675:	ff 75 08             	pushl  0x8(%ebp)
  801678:	e8 f0 08 00 00       	call   801f6d <get_block_size>
  80167d:	83 c4 10             	add    $0x10,%esp
  801680:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801683:	83 ec 0c             	sub    $0xc,%esp
  801686:	ff 75 08             	pushl  0x8(%ebp)
  801689:	e8 00 1b 00 00       	call   80318e <free_block>
  80168e:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801691:	e9 ac 00 00 00       	jmp    801742 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80169c:	0f 82 89 00 00 00    	jb     80172b <free+0xe5>
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  8016aa:	77 7f                	ja     80172b <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  8016ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8016af:	a1 20 50 80 00       	mov    0x805020,%eax
  8016b4:	8b 40 78             	mov    0x78(%eax),%eax
  8016b7:	29 c2                	sub    %eax,%edx
  8016b9:	89 d0                	mov    %edx,%eax
  8016bb:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016c0:	c1 e8 0c             	shr    $0xc,%eax
  8016c3:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  8016ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8016cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016d0:	c1 e0 0c             	shl    $0xc,%eax
  8016d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8016d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8016dd:	eb 42                	jmp    801721 <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  8016df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e2:	c1 e0 0c             	shl    $0xc,%eax
  8016e5:	89 c2                	mov    %eax,%edx
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	01 c2                	add    %eax,%edx
  8016ec:	a1 20 50 80 00       	mov    0x805020,%eax
  8016f1:	8b 40 78             	mov    0x78(%eax),%eax
  8016f4:	29 c2                	sub    %eax,%edx
  8016f6:	89 d0                	mov    %edx,%eax
  8016f8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016fd:	c1 e8 0c             	shr    $0xc,%eax
  801700:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801707:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  80170b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	83 ec 08             	sub    $0x8,%esp
  801714:	52                   	push   %edx
  801715:	50                   	push   %eax
  801716:	e8 1a 08 00 00       	call   801f35 <sys_free_user_mem>
  80171b:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  80171e:	ff 45 f4             	incl   -0xc(%ebp)
  801721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801724:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801727:	72 b6                	jb     8016df <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801729:	eb 17                	jmp    801742 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  80172b:	83 ec 04             	sub    $0x4,%esp
  80172e:	68 98 46 80 00       	push   $0x804698
  801733:	68 87 00 00 00       	push   $0x87
  801738:	68 c2 46 80 00       	push   $0x8046c2
  80173d:	e8 78 ec ff ff       	call   8003ba <_panic>
	}
}
  801742:	90                   	nop
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	83 ec 28             	sub    $0x28,%esp
  80174b:	8b 45 10             	mov    0x10(%ebp),%eax
  80174e:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801751:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801755:	75 0a                	jne    801761 <smalloc+0x1c>
  801757:	b8 00 00 00 00       	mov    $0x0,%eax
  80175c:	e9 87 00 00 00       	jmp    8017e8 <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801761:	8b 45 0c             	mov    0xc(%ebp),%eax
  801764:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801767:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80176e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801774:	39 d0                	cmp    %edx,%eax
  801776:	73 02                	jae    80177a <smalloc+0x35>
  801778:	89 d0                	mov    %edx,%eax
  80177a:	83 ec 0c             	sub    $0xc,%esp
  80177d:	50                   	push   %eax
  80177e:	e8 a4 fc ff ff       	call   801427 <malloc>
  801783:	83 c4 10             	add    $0x10,%esp
  801786:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801789:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80178d:	75 07                	jne    801796 <smalloc+0x51>
  80178f:	b8 00 00 00 00       	mov    $0x0,%eax
  801794:	eb 52                	jmp    8017e8 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801796:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80179a:	ff 75 ec             	pushl  -0x14(%ebp)
  80179d:	50                   	push   %eax
  80179e:	ff 75 0c             	pushl  0xc(%ebp)
  8017a1:	ff 75 08             	pushl  0x8(%ebp)
  8017a4:	e8 93 03 00 00       	call   801b3c <sys_createSharedObject>
  8017a9:	83 c4 10             	add    $0x10,%esp
  8017ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8017af:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8017b3:	74 06                	je     8017bb <smalloc+0x76>
  8017b5:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8017b9:	75 07                	jne    8017c2 <smalloc+0x7d>
  8017bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c0:	eb 26                	jmp    8017e8 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  8017c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8017ca:	8b 40 78             	mov    0x78(%eax),%eax
  8017cd:	29 c2                	sub    %eax,%edx
  8017cf:	89 d0                	mov    %edx,%eax
  8017d1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017d6:	c1 e8 0c             	shr    $0xc,%eax
  8017d9:	89 c2                	mov    %eax,%edx
  8017db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017de:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8017e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017f0:	83 ec 08             	sub    $0x8,%esp
  8017f3:	ff 75 0c             	pushl  0xc(%ebp)
  8017f6:	ff 75 08             	pushl  0x8(%ebp)
  8017f9:	e8 68 03 00 00       	call   801b66 <sys_getSizeOfSharedObject>
  8017fe:	83 c4 10             	add    $0x10,%esp
  801801:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801804:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801808:	75 07                	jne    801811 <sget+0x27>
  80180a:	b8 00 00 00 00       	mov    $0x0,%eax
  80180f:	eb 7f                	jmp    801890 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801814:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801817:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80181e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801821:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801824:	39 d0                	cmp    %edx,%eax
  801826:	73 02                	jae    80182a <sget+0x40>
  801828:	89 d0                	mov    %edx,%eax
  80182a:	83 ec 0c             	sub    $0xc,%esp
  80182d:	50                   	push   %eax
  80182e:	e8 f4 fb ff ff       	call   801427 <malloc>
  801833:	83 c4 10             	add    $0x10,%esp
  801836:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801839:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80183d:	75 07                	jne    801846 <sget+0x5c>
  80183f:	b8 00 00 00 00       	mov    $0x0,%eax
  801844:	eb 4a                	jmp    801890 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801846:	83 ec 04             	sub    $0x4,%esp
  801849:	ff 75 e8             	pushl  -0x18(%ebp)
  80184c:	ff 75 0c             	pushl  0xc(%ebp)
  80184f:	ff 75 08             	pushl  0x8(%ebp)
  801852:	e8 2c 03 00 00       	call   801b83 <sys_getSharedObject>
  801857:	83 c4 10             	add    $0x10,%esp
  80185a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  80185d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801860:	a1 20 50 80 00       	mov    0x805020,%eax
  801865:	8b 40 78             	mov    0x78(%eax),%eax
  801868:	29 c2                	sub    %eax,%edx
  80186a:	89 d0                	mov    %edx,%eax
  80186c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801871:	c1 e8 0c             	shr    $0xc,%eax
  801874:	89 c2                	mov    %eax,%edx
  801876:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801879:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801880:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801884:	75 07                	jne    80188d <sget+0xa3>
  801886:	b8 00 00 00 00       	mov    $0x0,%eax
  80188b:	eb 03                	jmp    801890 <sget+0xa6>
	return ptr;
  80188d:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
  801895:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801898:	8b 55 08             	mov    0x8(%ebp),%edx
  80189b:	a1 20 50 80 00       	mov    0x805020,%eax
  8018a0:	8b 40 78             	mov    0x78(%eax),%eax
  8018a3:	29 c2                	sub    %eax,%edx
  8018a5:	89 d0                	mov    %edx,%eax
  8018a7:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018ac:	c1 e8 0c             	shr    $0xc,%eax
  8018af:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8018b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8018b9:	83 ec 08             	sub    $0x8,%esp
  8018bc:	ff 75 08             	pushl  0x8(%ebp)
  8018bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c2:	e8 db 02 00 00       	call   801ba2 <sys_freeSharedObject>
  8018c7:	83 c4 10             	add    $0x10,%esp
  8018ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8018cd:	90                   	nop
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018d6:	83 ec 04             	sub    $0x4,%esp
  8018d9:	68 d0 46 80 00       	push   $0x8046d0
  8018de:	68 e4 00 00 00       	push   $0xe4
  8018e3:	68 c2 46 80 00       	push   $0x8046c2
  8018e8:	e8 cd ea ff ff       	call   8003ba <_panic>

008018ed <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018f3:	83 ec 04             	sub    $0x4,%esp
  8018f6:	68 f6 46 80 00       	push   $0x8046f6
  8018fb:	68 f0 00 00 00       	push   $0xf0
  801900:	68 c2 46 80 00       	push   $0x8046c2
  801905:	e8 b0 ea ff ff       	call   8003ba <_panic>

0080190a <shrink>:

}
void shrink(uint32 newSize)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801910:	83 ec 04             	sub    $0x4,%esp
  801913:	68 f6 46 80 00       	push   $0x8046f6
  801918:	68 f5 00 00 00       	push   $0xf5
  80191d:	68 c2 46 80 00       	push   $0x8046c2
  801922:	e8 93 ea ff ff       	call   8003ba <_panic>

00801927 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
  80192a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80192d:	83 ec 04             	sub    $0x4,%esp
  801930:	68 f6 46 80 00       	push   $0x8046f6
  801935:	68 fa 00 00 00       	push   $0xfa
  80193a:	68 c2 46 80 00       	push   $0x8046c2
  80193f:	e8 76 ea ff ff       	call   8003ba <_panic>

00801944 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	57                   	push   %edi
  801948:	56                   	push   %esi
  801949:	53                   	push   %ebx
  80194a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	8b 55 0c             	mov    0xc(%ebp),%edx
  801953:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801956:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801959:	8b 7d 18             	mov    0x18(%ebp),%edi
  80195c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80195f:	cd 30                	int    $0x30
  801961:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801964:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801967:	83 c4 10             	add    $0x10,%esp
  80196a:	5b                   	pop    %ebx
  80196b:	5e                   	pop    %esi
  80196c:	5f                   	pop    %edi
  80196d:	5d                   	pop    %ebp
  80196e:	c3                   	ret    

0080196f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
  801972:	83 ec 04             	sub    $0x4,%esp
  801975:	8b 45 10             	mov    0x10(%ebp),%eax
  801978:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80197b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80197f:	8b 45 08             	mov    0x8(%ebp),%eax
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	52                   	push   %edx
  801987:	ff 75 0c             	pushl  0xc(%ebp)
  80198a:	50                   	push   %eax
  80198b:	6a 00                	push   $0x0
  80198d:	e8 b2 ff ff ff       	call   801944 <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
}
  801995:	90                   	nop
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_cgetc>:

int
sys_cgetc(void)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 02                	push   $0x2
  8019a7:	e8 98 ff ff ff       	call   801944 <syscall>
  8019ac:	83 c4 18             	add    $0x18,%esp
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 03                	push   $0x3
  8019c0:	e8 7f ff ff ff       	call   801944 <syscall>
  8019c5:	83 c4 18             	add    $0x18,%esp
}
  8019c8:	90                   	nop
  8019c9:	c9                   	leave  
  8019ca:	c3                   	ret    

008019cb <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 04                	push   $0x4
  8019da:	e8 65 ff ff ff       	call   801944 <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
}
  8019e2:	90                   	nop
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	52                   	push   %edx
  8019f5:	50                   	push   %eax
  8019f6:	6a 08                	push   $0x8
  8019f8:	e8 47 ff ff ff       	call   801944 <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
  801a05:	56                   	push   %esi
  801a06:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a07:	8b 75 18             	mov    0x18(%ebp),%esi
  801a0a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a0d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	56                   	push   %esi
  801a17:	53                   	push   %ebx
  801a18:	51                   	push   %ecx
  801a19:	52                   	push   %edx
  801a1a:	50                   	push   %eax
  801a1b:	6a 09                	push   $0x9
  801a1d:	e8 22 ff ff ff       	call   801944 <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
}
  801a25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a28:	5b                   	pop    %ebx
  801a29:	5e                   	pop    %esi
  801a2a:	5d                   	pop    %ebp
  801a2b:	c3                   	ret    

00801a2c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	52                   	push   %edx
  801a3c:	50                   	push   %eax
  801a3d:	6a 0a                	push   $0xa
  801a3f:	e8 00 ff ff ff       	call   801944 <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
}
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	ff 75 0c             	pushl  0xc(%ebp)
  801a55:	ff 75 08             	pushl  0x8(%ebp)
  801a58:	6a 0b                	push   $0xb
  801a5a:	e8 e5 fe ff ff       	call   801944 <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 0c                	push   $0xc
  801a73:	e8 cc fe ff ff       	call   801944 <syscall>
  801a78:	83 c4 18             	add    $0x18,%esp
}
  801a7b:	c9                   	leave  
  801a7c:	c3                   	ret    

00801a7d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 0d                	push   $0xd
  801a8c:	e8 b3 fe ff ff       	call   801944 <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
}
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 0e                	push   $0xe
  801aa5:	e8 9a fe ff ff       	call   801944 <syscall>
  801aaa:	83 c4 18             	add    $0x18,%esp
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 0f                	push   $0xf
  801abe:	e8 81 fe ff ff       	call   801944 <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	ff 75 08             	pushl  0x8(%ebp)
  801ad6:	6a 10                	push   $0x10
  801ad8:	e8 67 fe ff ff       	call   801944 <syscall>
  801add:	83 c4 18             	add    $0x18,%esp
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 11                	push   $0x11
  801af1:	e8 4e fe ff ff       	call   801944 <syscall>
  801af6:	83 c4 18             	add    $0x18,%esp
}
  801af9:	90                   	nop
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <sys_cputc>:

void
sys_cputc(const char c)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
  801aff:	83 ec 04             	sub    $0x4,%esp
  801b02:	8b 45 08             	mov    0x8(%ebp),%eax
  801b05:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b08:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	50                   	push   %eax
  801b15:	6a 01                	push   $0x1
  801b17:	e8 28 fe ff ff       	call   801944 <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
}
  801b1f:	90                   	nop
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 14                	push   $0x14
  801b31:	e8 0e fe ff ff       	call   801944 <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	90                   	nop
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
  801b3f:	83 ec 04             	sub    $0x4,%esp
  801b42:	8b 45 10             	mov    0x10(%ebp),%eax
  801b45:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b48:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b4b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b52:	6a 00                	push   $0x0
  801b54:	51                   	push   %ecx
  801b55:	52                   	push   %edx
  801b56:	ff 75 0c             	pushl  0xc(%ebp)
  801b59:	50                   	push   %eax
  801b5a:	6a 15                	push   $0x15
  801b5c:	e8 e3 fd ff ff       	call   801944 <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	52                   	push   %edx
  801b76:	50                   	push   %eax
  801b77:	6a 16                	push   $0x16
  801b79:	e8 c6 fd ff ff       	call   801944 <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b86:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b89:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	51                   	push   %ecx
  801b94:	52                   	push   %edx
  801b95:	50                   	push   %eax
  801b96:	6a 17                	push   $0x17
  801b98:	e8 a7 fd ff ff       	call   801944 <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ba5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	52                   	push   %edx
  801bb2:	50                   	push   %eax
  801bb3:	6a 18                	push   $0x18
  801bb5:	e8 8a fd ff ff       	call   801944 <syscall>
  801bba:	83 c4 18             	add    $0x18,%esp
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc5:	6a 00                	push   $0x0
  801bc7:	ff 75 14             	pushl  0x14(%ebp)
  801bca:	ff 75 10             	pushl  0x10(%ebp)
  801bcd:	ff 75 0c             	pushl  0xc(%ebp)
  801bd0:	50                   	push   %eax
  801bd1:	6a 19                	push   $0x19
  801bd3:	e8 6c fd ff ff       	call   801944 <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_run_env>:

void sys_run_env(int32 envId)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801be0:	8b 45 08             	mov    0x8(%ebp),%eax
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	50                   	push   %eax
  801bec:	6a 1a                	push   $0x1a
  801bee:	e8 51 fd ff ff       	call   801944 <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
}
  801bf6:	90                   	nop
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	50                   	push   %eax
  801c08:	6a 1b                	push   $0x1b
  801c0a:	e8 35 fd ff ff       	call   801944 <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 05                	push   $0x5
  801c23:	e8 1c fd ff ff       	call   801944 <syscall>
  801c28:	83 c4 18             	add    $0x18,%esp
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 06                	push   $0x6
  801c3c:	e8 03 fd ff ff       	call   801944 <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 07                	push   $0x7
  801c55:	e8 ea fc ff ff       	call   801944 <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_exit_env>:


void sys_exit_env(void)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 1c                	push   $0x1c
  801c6e:	e8 d1 fc ff ff       	call   801944 <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
}
  801c76:	90                   	nop
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c7f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c82:	8d 50 04             	lea    0x4(%eax),%edx
  801c85:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	52                   	push   %edx
  801c8f:	50                   	push   %eax
  801c90:	6a 1d                	push   $0x1d
  801c92:	e8 ad fc ff ff       	call   801944 <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
	return result;
  801c9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ca0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ca3:	89 01                	mov    %eax,(%ecx)
  801ca5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	c9                   	leave  
  801cac:	c2 04 00             	ret    $0x4

00801caf <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	ff 75 10             	pushl  0x10(%ebp)
  801cb9:	ff 75 0c             	pushl  0xc(%ebp)
  801cbc:	ff 75 08             	pushl  0x8(%ebp)
  801cbf:	6a 13                	push   $0x13
  801cc1:	e8 7e fc ff ff       	call   801944 <syscall>
  801cc6:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc9:	90                   	nop
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <sys_rcr2>:
uint32 sys_rcr2()
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 1e                	push   $0x1e
  801cdb:	e8 64 fc ff ff       	call   801944 <syscall>
  801ce0:	83 c4 18             	add    $0x18,%esp
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	83 ec 04             	sub    $0x4,%esp
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cf1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	50                   	push   %eax
  801cfe:	6a 1f                	push   $0x1f
  801d00:	e8 3f fc ff ff       	call   801944 <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
	return ;
  801d08:	90                   	nop
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <rsttst>:
void rsttst()
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 21                	push   $0x21
  801d1a:	e8 25 fc ff ff       	call   801944 <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d22:	90                   	nop
}
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
  801d28:	83 ec 04             	sub    $0x4,%esp
  801d2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d2e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d31:	8b 55 18             	mov    0x18(%ebp),%edx
  801d34:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d38:	52                   	push   %edx
  801d39:	50                   	push   %eax
  801d3a:	ff 75 10             	pushl  0x10(%ebp)
  801d3d:	ff 75 0c             	pushl  0xc(%ebp)
  801d40:	ff 75 08             	pushl  0x8(%ebp)
  801d43:	6a 20                	push   $0x20
  801d45:	e8 fa fb ff ff       	call   801944 <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4d:	90                   	nop
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <chktst>:
void chktst(uint32 n)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	ff 75 08             	pushl  0x8(%ebp)
  801d5e:	6a 22                	push   $0x22
  801d60:	e8 df fb ff ff       	call   801944 <syscall>
  801d65:	83 c4 18             	add    $0x18,%esp
	return ;
  801d68:	90                   	nop
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <inctst>:

void inctst()
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 23                	push   $0x23
  801d7a:	e8 c5 fb ff ff       	call   801944 <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d82:	90                   	nop
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <gettst>:
uint32 gettst()
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 24                	push   $0x24
  801d94:	e8 ab fb ff ff       	call   801944 <syscall>
  801d99:	83 c4 18             	add    $0x18,%esp
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
  801da1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 25                	push   $0x25
  801db0:	e8 8f fb ff ff       	call   801944 <syscall>
  801db5:	83 c4 18             	add    $0x18,%esp
  801db8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dbb:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dbf:	75 07                	jne    801dc8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dc1:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc6:	eb 05                	jmp    801dcd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
  801dd2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 25                	push   $0x25
  801de1:	e8 5e fb ff ff       	call   801944 <syscall>
  801de6:	83 c4 18             	add    $0x18,%esp
  801de9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dec:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801df0:	75 07                	jne    801df9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801df2:	b8 01 00 00 00       	mov    $0x1,%eax
  801df7:	eb 05                	jmp    801dfe <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801df9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 25                	push   $0x25
  801e12:	e8 2d fb ff ff       	call   801944 <syscall>
  801e17:	83 c4 18             	add    $0x18,%esp
  801e1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e1d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e21:	75 07                	jne    801e2a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e23:	b8 01 00 00 00       	mov    $0x1,%eax
  801e28:	eb 05                	jmp    801e2f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 25                	push   $0x25
  801e43:	e8 fc fa ff ff       	call   801944 <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
  801e4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e4e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e52:	75 07                	jne    801e5b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e54:	b8 01 00 00 00       	mov    $0x1,%eax
  801e59:	eb 05                	jmp    801e60 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	ff 75 08             	pushl  0x8(%ebp)
  801e70:	6a 26                	push   $0x26
  801e72:	e8 cd fa ff ff       	call   801944 <syscall>
  801e77:	83 c4 18             	add    $0x18,%esp
	return ;
  801e7a:	90                   	nop
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
  801e80:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e81:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e84:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8d:	6a 00                	push   $0x0
  801e8f:	53                   	push   %ebx
  801e90:	51                   	push   %ecx
  801e91:	52                   	push   %edx
  801e92:	50                   	push   %eax
  801e93:	6a 27                	push   $0x27
  801e95:	e8 aa fa ff ff       	call   801944 <syscall>
  801e9a:	83 c4 18             	add    $0x18,%esp
}
  801e9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ea5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	52                   	push   %edx
  801eb2:	50                   	push   %eax
  801eb3:	6a 28                	push   $0x28
  801eb5:	e8 8a fa ff ff       	call   801944 <syscall>
  801eba:	83 c4 18             	add    $0x18,%esp
}
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ec2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ec5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecb:	6a 00                	push   $0x0
  801ecd:	51                   	push   %ecx
  801ece:	ff 75 10             	pushl  0x10(%ebp)
  801ed1:	52                   	push   %edx
  801ed2:	50                   	push   %eax
  801ed3:	6a 29                	push   $0x29
  801ed5:	e8 6a fa ff ff       	call   801944 <syscall>
  801eda:	83 c4 18             	add    $0x18,%esp
}
  801edd:	c9                   	leave  
  801ede:	c3                   	ret    

00801edf <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	ff 75 10             	pushl  0x10(%ebp)
  801ee9:	ff 75 0c             	pushl  0xc(%ebp)
  801eec:	ff 75 08             	pushl  0x8(%ebp)
  801eef:	6a 12                	push   $0x12
  801ef1:	e8 4e fa ff ff       	call   801944 <syscall>
  801ef6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef9:	90                   	nop
}
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801eff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f02:	8b 45 08             	mov    0x8(%ebp),%eax
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	52                   	push   %edx
  801f0c:	50                   	push   %eax
  801f0d:	6a 2a                	push   $0x2a
  801f0f:	e8 30 fa ff ff       	call   801944 <syscall>
  801f14:	83 c4 18             	add    $0x18,%esp
	return;
  801f17:	90                   	nop
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	50                   	push   %eax
  801f29:	6a 2b                	push   $0x2b
  801f2b:	e8 14 fa ff ff       	call   801944 <syscall>
  801f30:	83 c4 18             	add    $0x18,%esp
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	ff 75 0c             	pushl  0xc(%ebp)
  801f41:	ff 75 08             	pushl  0x8(%ebp)
  801f44:	6a 2c                	push   $0x2c
  801f46:	e8 f9 f9 ff ff       	call   801944 <syscall>
  801f4b:	83 c4 18             	add    $0x18,%esp
	return;
  801f4e:	90                   	nop
}
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	ff 75 0c             	pushl  0xc(%ebp)
  801f5d:	ff 75 08             	pushl  0x8(%ebp)
  801f60:	6a 2d                	push   $0x2d
  801f62:	e8 dd f9 ff ff       	call   801944 <syscall>
  801f67:	83 c4 18             	add    $0x18,%esp
	return;
  801f6a:	90                   	nop
}
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
  801f70:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f73:	8b 45 08             	mov    0x8(%ebp),%eax
  801f76:	83 e8 04             	sub    $0x4,%eax
  801f79:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f7f:	8b 00                	mov    (%eax),%eax
  801f81:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f84:	c9                   	leave  
  801f85:	c3                   	ret    

00801f86 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp
  801f89:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8f:	83 e8 04             	sub    $0x4,%eax
  801f92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f98:	8b 00                	mov    (%eax),%eax
  801f9a:	83 e0 01             	and    $0x1,%eax
  801f9d:	85 c0                	test   %eax,%eax
  801f9f:	0f 94 c0             	sete   %al
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
  801fa7:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801faa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb4:	83 f8 02             	cmp    $0x2,%eax
  801fb7:	74 2b                	je     801fe4 <alloc_block+0x40>
  801fb9:	83 f8 02             	cmp    $0x2,%eax
  801fbc:	7f 07                	jg     801fc5 <alloc_block+0x21>
  801fbe:	83 f8 01             	cmp    $0x1,%eax
  801fc1:	74 0e                	je     801fd1 <alloc_block+0x2d>
  801fc3:	eb 58                	jmp    80201d <alloc_block+0x79>
  801fc5:	83 f8 03             	cmp    $0x3,%eax
  801fc8:	74 2d                	je     801ff7 <alloc_block+0x53>
  801fca:	83 f8 04             	cmp    $0x4,%eax
  801fcd:	74 3b                	je     80200a <alloc_block+0x66>
  801fcf:	eb 4c                	jmp    80201d <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801fd1:	83 ec 0c             	sub    $0xc,%esp
  801fd4:	ff 75 08             	pushl  0x8(%ebp)
  801fd7:	e8 11 03 00 00       	call   8022ed <alloc_block_FF>
  801fdc:	83 c4 10             	add    $0x10,%esp
  801fdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fe2:	eb 4a                	jmp    80202e <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801fe4:	83 ec 0c             	sub    $0xc,%esp
  801fe7:	ff 75 08             	pushl  0x8(%ebp)
  801fea:	e8 c7 19 00 00       	call   8039b6 <alloc_block_NF>
  801fef:	83 c4 10             	add    $0x10,%esp
  801ff2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ff5:	eb 37                	jmp    80202e <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801ff7:	83 ec 0c             	sub    $0xc,%esp
  801ffa:	ff 75 08             	pushl  0x8(%ebp)
  801ffd:	e8 a7 07 00 00       	call   8027a9 <alloc_block_BF>
  802002:	83 c4 10             	add    $0x10,%esp
  802005:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802008:	eb 24                	jmp    80202e <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80200a:	83 ec 0c             	sub    $0xc,%esp
  80200d:	ff 75 08             	pushl  0x8(%ebp)
  802010:	e8 84 19 00 00       	call   803999 <alloc_block_WF>
  802015:	83 c4 10             	add    $0x10,%esp
  802018:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80201b:	eb 11                	jmp    80202e <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80201d:	83 ec 0c             	sub    $0xc,%esp
  802020:	68 08 47 80 00       	push   $0x804708
  802025:	e8 4d e6 ff ff       	call   800677 <cprintf>
  80202a:	83 c4 10             	add    $0x10,%esp
		break;
  80202d:	90                   	nop
	}
	return va;
  80202e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802031:	c9                   	leave  
  802032:	c3                   	ret    

00802033 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	53                   	push   %ebx
  802037:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80203a:	83 ec 0c             	sub    $0xc,%esp
  80203d:	68 28 47 80 00       	push   $0x804728
  802042:	e8 30 e6 ff ff       	call   800677 <cprintf>
  802047:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80204a:	83 ec 0c             	sub    $0xc,%esp
  80204d:	68 53 47 80 00       	push   $0x804753
  802052:	e8 20 e6 ff ff       	call   800677 <cprintf>
  802057:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80205a:	8b 45 08             	mov    0x8(%ebp),%eax
  80205d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802060:	eb 37                	jmp    802099 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802062:	83 ec 0c             	sub    $0xc,%esp
  802065:	ff 75 f4             	pushl  -0xc(%ebp)
  802068:	e8 19 ff ff ff       	call   801f86 <is_free_block>
  80206d:	83 c4 10             	add    $0x10,%esp
  802070:	0f be d8             	movsbl %al,%ebx
  802073:	83 ec 0c             	sub    $0xc,%esp
  802076:	ff 75 f4             	pushl  -0xc(%ebp)
  802079:	e8 ef fe ff ff       	call   801f6d <get_block_size>
  80207e:	83 c4 10             	add    $0x10,%esp
  802081:	83 ec 04             	sub    $0x4,%esp
  802084:	53                   	push   %ebx
  802085:	50                   	push   %eax
  802086:	68 6b 47 80 00       	push   $0x80476b
  80208b:	e8 e7 e5 ff ff       	call   800677 <cprintf>
  802090:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802093:	8b 45 10             	mov    0x10(%ebp),%eax
  802096:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802099:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80209d:	74 07                	je     8020a6 <print_blocks_list+0x73>
  80209f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a2:	8b 00                	mov    (%eax),%eax
  8020a4:	eb 05                	jmp    8020ab <print_blocks_list+0x78>
  8020a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ab:	89 45 10             	mov    %eax,0x10(%ebp)
  8020ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b1:	85 c0                	test   %eax,%eax
  8020b3:	75 ad                	jne    802062 <print_blocks_list+0x2f>
  8020b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020b9:	75 a7                	jne    802062 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8020bb:	83 ec 0c             	sub    $0xc,%esp
  8020be:	68 28 47 80 00       	push   $0x804728
  8020c3:	e8 af e5 ff ff       	call   800677 <cprintf>
  8020c8:	83 c4 10             	add    $0x10,%esp

}
  8020cb:	90                   	nop
  8020cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020cf:	c9                   	leave  
  8020d0:	c3                   	ret    

008020d1 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
  8020d4:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8020d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020da:	83 e0 01             	and    $0x1,%eax
  8020dd:	85 c0                	test   %eax,%eax
  8020df:	74 03                	je     8020e4 <initialize_dynamic_allocator+0x13>
  8020e1:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8020e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020e8:	0f 84 c7 01 00 00    	je     8022b5 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8020ee:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8020f5:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8020f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8020fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020fe:	01 d0                	add    %edx,%eax
  802100:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802105:	0f 87 ad 01 00 00    	ja     8022b8 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80210b:	8b 45 08             	mov    0x8(%ebp),%eax
  80210e:	85 c0                	test   %eax,%eax
  802110:	0f 89 a5 01 00 00    	jns    8022bb <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802116:	8b 55 08             	mov    0x8(%ebp),%edx
  802119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211c:	01 d0                	add    %edx,%eax
  80211e:	83 e8 04             	sub    $0x4,%eax
  802121:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802126:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80212d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802132:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802135:	e9 87 00 00 00       	jmp    8021c1 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80213a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80213e:	75 14                	jne    802154 <initialize_dynamic_allocator+0x83>
  802140:	83 ec 04             	sub    $0x4,%esp
  802143:	68 83 47 80 00       	push   $0x804783
  802148:	6a 79                	push   $0x79
  80214a:	68 a1 47 80 00       	push   $0x8047a1
  80214f:	e8 66 e2 ff ff       	call   8003ba <_panic>
  802154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802157:	8b 00                	mov    (%eax),%eax
  802159:	85 c0                	test   %eax,%eax
  80215b:	74 10                	je     80216d <initialize_dynamic_allocator+0x9c>
  80215d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802160:	8b 00                	mov    (%eax),%eax
  802162:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802165:	8b 52 04             	mov    0x4(%edx),%edx
  802168:	89 50 04             	mov    %edx,0x4(%eax)
  80216b:	eb 0b                	jmp    802178 <initialize_dynamic_allocator+0xa7>
  80216d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802170:	8b 40 04             	mov    0x4(%eax),%eax
  802173:	a3 30 50 80 00       	mov    %eax,0x805030
  802178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217b:	8b 40 04             	mov    0x4(%eax),%eax
  80217e:	85 c0                	test   %eax,%eax
  802180:	74 0f                	je     802191 <initialize_dynamic_allocator+0xc0>
  802182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802185:	8b 40 04             	mov    0x4(%eax),%eax
  802188:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218b:	8b 12                	mov    (%edx),%edx
  80218d:	89 10                	mov    %edx,(%eax)
  80218f:	eb 0a                	jmp    80219b <initialize_dynamic_allocator+0xca>
  802191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802194:	8b 00                	mov    (%eax),%eax
  802196:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80219b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021ae:	a1 38 50 80 00       	mov    0x805038,%eax
  8021b3:	48                   	dec    %eax
  8021b4:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8021b9:	a1 34 50 80 00       	mov    0x805034,%eax
  8021be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c5:	74 07                	je     8021ce <initialize_dynamic_allocator+0xfd>
  8021c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ca:	8b 00                	mov    (%eax),%eax
  8021cc:	eb 05                	jmp    8021d3 <initialize_dynamic_allocator+0x102>
  8021ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d3:	a3 34 50 80 00       	mov    %eax,0x805034
  8021d8:	a1 34 50 80 00       	mov    0x805034,%eax
  8021dd:	85 c0                	test   %eax,%eax
  8021df:	0f 85 55 ff ff ff    	jne    80213a <initialize_dynamic_allocator+0x69>
  8021e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e9:	0f 85 4b ff ff ff    	jne    80213a <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8021ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8021f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8021fe:	a1 44 50 80 00       	mov    0x805044,%eax
  802203:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802208:	a1 40 50 80 00       	mov    0x805040,%eax
  80220d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802213:	8b 45 08             	mov    0x8(%ebp),%eax
  802216:	83 c0 08             	add    $0x8,%eax
  802219:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80221c:	8b 45 08             	mov    0x8(%ebp),%eax
  80221f:	83 c0 04             	add    $0x4,%eax
  802222:	8b 55 0c             	mov    0xc(%ebp),%edx
  802225:	83 ea 08             	sub    $0x8,%edx
  802228:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80222a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222d:	8b 45 08             	mov    0x8(%ebp),%eax
  802230:	01 d0                	add    %edx,%eax
  802232:	83 e8 08             	sub    $0x8,%eax
  802235:	8b 55 0c             	mov    0xc(%ebp),%edx
  802238:	83 ea 08             	sub    $0x8,%edx
  80223b:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80223d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802240:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802246:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802249:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802250:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802254:	75 17                	jne    80226d <initialize_dynamic_allocator+0x19c>
  802256:	83 ec 04             	sub    $0x4,%esp
  802259:	68 bc 47 80 00       	push   $0x8047bc
  80225e:	68 90 00 00 00       	push   $0x90
  802263:	68 a1 47 80 00       	push   $0x8047a1
  802268:	e8 4d e1 ff ff       	call   8003ba <_panic>
  80226d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802273:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802276:	89 10                	mov    %edx,(%eax)
  802278:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80227b:	8b 00                	mov    (%eax),%eax
  80227d:	85 c0                	test   %eax,%eax
  80227f:	74 0d                	je     80228e <initialize_dynamic_allocator+0x1bd>
  802281:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802286:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802289:	89 50 04             	mov    %edx,0x4(%eax)
  80228c:	eb 08                	jmp    802296 <initialize_dynamic_allocator+0x1c5>
  80228e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802291:	a3 30 50 80 00       	mov    %eax,0x805030
  802296:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802299:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80229e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022a8:	a1 38 50 80 00       	mov    0x805038,%eax
  8022ad:	40                   	inc    %eax
  8022ae:	a3 38 50 80 00       	mov    %eax,0x805038
  8022b3:	eb 07                	jmp    8022bc <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8022b5:	90                   	nop
  8022b6:	eb 04                	jmp    8022bc <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8022b8:	90                   	nop
  8022b9:	eb 01                	jmp    8022bc <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8022bb:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8022bc:	c9                   	leave  
  8022bd:	c3                   	ret    

008022be <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8022c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c4:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8022c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ca:	8d 50 fc             	lea    -0x4(%eax),%edx
  8022cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d0:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	83 e8 04             	sub    $0x4,%eax
  8022d8:	8b 00                	mov    (%eax),%eax
  8022da:	83 e0 fe             	and    $0xfffffffe,%eax
  8022dd:	8d 50 f8             	lea    -0x8(%eax),%edx
  8022e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e3:	01 c2                	add    %eax,%edx
  8022e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e8:	89 02                	mov    %eax,(%edx)
}
  8022ea:	90                   	nop
  8022eb:	5d                   	pop    %ebp
  8022ec:	c3                   	ret    

008022ed <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
  8022f0:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8022f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f6:	83 e0 01             	and    $0x1,%eax
  8022f9:	85 c0                	test   %eax,%eax
  8022fb:	74 03                	je     802300 <alloc_block_FF+0x13>
  8022fd:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802300:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802304:	77 07                	ja     80230d <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802306:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80230d:	a1 24 50 80 00       	mov    0x805024,%eax
  802312:	85 c0                	test   %eax,%eax
  802314:	75 73                	jne    802389 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	83 c0 10             	add    $0x10,%eax
  80231c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80231f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802326:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802329:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80232c:	01 d0                	add    %edx,%eax
  80232e:	48                   	dec    %eax
  80232f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802332:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802335:	ba 00 00 00 00       	mov    $0x0,%edx
  80233a:	f7 75 ec             	divl   -0x14(%ebp)
  80233d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802340:	29 d0                	sub    %edx,%eax
  802342:	c1 e8 0c             	shr    $0xc,%eax
  802345:	83 ec 0c             	sub    $0xc,%esp
  802348:	50                   	push   %eax
  802349:	e8 c3 f0 ff ff       	call   801411 <sbrk>
  80234e:	83 c4 10             	add    $0x10,%esp
  802351:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802354:	83 ec 0c             	sub    $0xc,%esp
  802357:	6a 00                	push   $0x0
  802359:	e8 b3 f0 ff ff       	call   801411 <sbrk>
  80235e:	83 c4 10             	add    $0x10,%esp
  802361:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802364:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802367:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80236a:	83 ec 08             	sub    $0x8,%esp
  80236d:	50                   	push   %eax
  80236e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802371:	e8 5b fd ff ff       	call   8020d1 <initialize_dynamic_allocator>
  802376:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802379:	83 ec 0c             	sub    $0xc,%esp
  80237c:	68 df 47 80 00       	push   $0x8047df
  802381:	e8 f1 e2 ff ff       	call   800677 <cprintf>
  802386:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802389:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80238d:	75 0a                	jne    802399 <alloc_block_FF+0xac>
	        return NULL;
  80238f:	b8 00 00 00 00       	mov    $0x0,%eax
  802394:	e9 0e 04 00 00       	jmp    8027a7 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802399:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8023a0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a8:	e9 f3 02 00 00       	jmp    8026a0 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8023ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b0:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8023b3:	83 ec 0c             	sub    $0xc,%esp
  8023b6:	ff 75 bc             	pushl  -0x44(%ebp)
  8023b9:	e8 af fb ff ff       	call   801f6d <get_block_size>
  8023be:	83 c4 10             	add    $0x10,%esp
  8023c1:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8023c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c7:	83 c0 08             	add    $0x8,%eax
  8023ca:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023cd:	0f 87 c5 02 00 00    	ja     802698 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8023d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d6:	83 c0 18             	add    $0x18,%eax
  8023d9:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023dc:	0f 87 19 02 00 00    	ja     8025fb <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8023e2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8023e5:	2b 45 08             	sub    0x8(%ebp),%eax
  8023e8:	83 e8 08             	sub    $0x8,%eax
  8023eb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8023ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f1:	8d 50 08             	lea    0x8(%eax),%edx
  8023f4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023f7:	01 d0                	add    %edx,%eax
  8023f9:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8023fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ff:	83 c0 08             	add    $0x8,%eax
  802402:	83 ec 04             	sub    $0x4,%esp
  802405:	6a 01                	push   $0x1
  802407:	50                   	push   %eax
  802408:	ff 75 bc             	pushl  -0x44(%ebp)
  80240b:	e8 ae fe ff ff       	call   8022be <set_block_data>
  802410:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802416:	8b 40 04             	mov    0x4(%eax),%eax
  802419:	85 c0                	test   %eax,%eax
  80241b:	75 68                	jne    802485 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80241d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802421:	75 17                	jne    80243a <alloc_block_FF+0x14d>
  802423:	83 ec 04             	sub    $0x4,%esp
  802426:	68 bc 47 80 00       	push   $0x8047bc
  80242b:	68 d7 00 00 00       	push   $0xd7
  802430:	68 a1 47 80 00       	push   $0x8047a1
  802435:	e8 80 df ff ff       	call   8003ba <_panic>
  80243a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802440:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802443:	89 10                	mov    %edx,(%eax)
  802445:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802448:	8b 00                	mov    (%eax),%eax
  80244a:	85 c0                	test   %eax,%eax
  80244c:	74 0d                	je     80245b <alloc_block_FF+0x16e>
  80244e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802453:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802456:	89 50 04             	mov    %edx,0x4(%eax)
  802459:	eb 08                	jmp    802463 <alloc_block_FF+0x176>
  80245b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80245e:	a3 30 50 80 00       	mov    %eax,0x805030
  802463:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802466:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80246b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80246e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802475:	a1 38 50 80 00       	mov    0x805038,%eax
  80247a:	40                   	inc    %eax
  80247b:	a3 38 50 80 00       	mov    %eax,0x805038
  802480:	e9 dc 00 00 00       	jmp    802561 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802488:	8b 00                	mov    (%eax),%eax
  80248a:	85 c0                	test   %eax,%eax
  80248c:	75 65                	jne    8024f3 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80248e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802492:	75 17                	jne    8024ab <alloc_block_FF+0x1be>
  802494:	83 ec 04             	sub    $0x4,%esp
  802497:	68 f0 47 80 00       	push   $0x8047f0
  80249c:	68 db 00 00 00       	push   $0xdb
  8024a1:	68 a1 47 80 00       	push   $0x8047a1
  8024a6:	e8 0f df ff ff       	call   8003ba <_panic>
  8024ab:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8024b1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024b4:	89 50 04             	mov    %edx,0x4(%eax)
  8024b7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ba:	8b 40 04             	mov    0x4(%eax),%eax
  8024bd:	85 c0                	test   %eax,%eax
  8024bf:	74 0c                	je     8024cd <alloc_block_FF+0x1e0>
  8024c1:	a1 30 50 80 00       	mov    0x805030,%eax
  8024c6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024c9:	89 10                	mov    %edx,(%eax)
  8024cb:	eb 08                	jmp    8024d5 <alloc_block_FF+0x1e8>
  8024cd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024d0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024d5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024d8:	a3 30 50 80 00       	mov    %eax,0x805030
  8024dd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e6:	a1 38 50 80 00       	mov    0x805038,%eax
  8024eb:	40                   	inc    %eax
  8024ec:	a3 38 50 80 00       	mov    %eax,0x805038
  8024f1:	eb 6e                	jmp    802561 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8024f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f7:	74 06                	je     8024ff <alloc_block_FF+0x212>
  8024f9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024fd:	75 17                	jne    802516 <alloc_block_FF+0x229>
  8024ff:	83 ec 04             	sub    $0x4,%esp
  802502:	68 14 48 80 00       	push   $0x804814
  802507:	68 df 00 00 00       	push   $0xdf
  80250c:	68 a1 47 80 00       	push   $0x8047a1
  802511:	e8 a4 de ff ff       	call   8003ba <_panic>
  802516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802519:	8b 10                	mov    (%eax),%edx
  80251b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80251e:	89 10                	mov    %edx,(%eax)
  802520:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802523:	8b 00                	mov    (%eax),%eax
  802525:	85 c0                	test   %eax,%eax
  802527:	74 0b                	je     802534 <alloc_block_FF+0x247>
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	8b 00                	mov    (%eax),%eax
  80252e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802531:	89 50 04             	mov    %edx,0x4(%eax)
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80253a:	89 10                	mov    %edx,(%eax)
  80253c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80253f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802542:	89 50 04             	mov    %edx,0x4(%eax)
  802545:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802548:	8b 00                	mov    (%eax),%eax
  80254a:	85 c0                	test   %eax,%eax
  80254c:	75 08                	jne    802556 <alloc_block_FF+0x269>
  80254e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802551:	a3 30 50 80 00       	mov    %eax,0x805030
  802556:	a1 38 50 80 00       	mov    0x805038,%eax
  80255b:	40                   	inc    %eax
  80255c:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802561:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802565:	75 17                	jne    80257e <alloc_block_FF+0x291>
  802567:	83 ec 04             	sub    $0x4,%esp
  80256a:	68 83 47 80 00       	push   $0x804783
  80256f:	68 e1 00 00 00       	push   $0xe1
  802574:	68 a1 47 80 00       	push   $0x8047a1
  802579:	e8 3c de ff ff       	call   8003ba <_panic>
  80257e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802581:	8b 00                	mov    (%eax),%eax
  802583:	85 c0                	test   %eax,%eax
  802585:	74 10                	je     802597 <alloc_block_FF+0x2aa>
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	8b 00                	mov    (%eax),%eax
  80258c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258f:	8b 52 04             	mov    0x4(%edx),%edx
  802592:	89 50 04             	mov    %edx,0x4(%eax)
  802595:	eb 0b                	jmp    8025a2 <alloc_block_FF+0x2b5>
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	8b 40 04             	mov    0x4(%eax),%eax
  80259d:	a3 30 50 80 00       	mov    %eax,0x805030
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	8b 40 04             	mov    0x4(%eax),%eax
  8025a8:	85 c0                	test   %eax,%eax
  8025aa:	74 0f                	je     8025bb <alloc_block_FF+0x2ce>
  8025ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025af:	8b 40 04             	mov    0x4(%eax),%eax
  8025b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b5:	8b 12                	mov    (%edx),%edx
  8025b7:	89 10                	mov    %edx,(%eax)
  8025b9:	eb 0a                	jmp    8025c5 <alloc_block_FF+0x2d8>
  8025bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025be:	8b 00                	mov    (%eax),%eax
  8025c0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d8:	a1 38 50 80 00       	mov    0x805038,%eax
  8025dd:	48                   	dec    %eax
  8025de:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8025e3:	83 ec 04             	sub    $0x4,%esp
  8025e6:	6a 00                	push   $0x0
  8025e8:	ff 75 b4             	pushl  -0x4c(%ebp)
  8025eb:	ff 75 b0             	pushl  -0x50(%ebp)
  8025ee:	e8 cb fc ff ff       	call   8022be <set_block_data>
  8025f3:	83 c4 10             	add    $0x10,%esp
  8025f6:	e9 95 00 00 00       	jmp    802690 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8025fb:	83 ec 04             	sub    $0x4,%esp
  8025fe:	6a 01                	push   $0x1
  802600:	ff 75 b8             	pushl  -0x48(%ebp)
  802603:	ff 75 bc             	pushl  -0x44(%ebp)
  802606:	e8 b3 fc ff ff       	call   8022be <set_block_data>
  80260b:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80260e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802612:	75 17                	jne    80262b <alloc_block_FF+0x33e>
  802614:	83 ec 04             	sub    $0x4,%esp
  802617:	68 83 47 80 00       	push   $0x804783
  80261c:	68 e8 00 00 00       	push   $0xe8
  802621:	68 a1 47 80 00       	push   $0x8047a1
  802626:	e8 8f dd ff ff       	call   8003ba <_panic>
  80262b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262e:	8b 00                	mov    (%eax),%eax
  802630:	85 c0                	test   %eax,%eax
  802632:	74 10                	je     802644 <alloc_block_FF+0x357>
  802634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802637:	8b 00                	mov    (%eax),%eax
  802639:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80263c:	8b 52 04             	mov    0x4(%edx),%edx
  80263f:	89 50 04             	mov    %edx,0x4(%eax)
  802642:	eb 0b                	jmp    80264f <alloc_block_FF+0x362>
  802644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802647:	8b 40 04             	mov    0x4(%eax),%eax
  80264a:	a3 30 50 80 00       	mov    %eax,0x805030
  80264f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802652:	8b 40 04             	mov    0x4(%eax),%eax
  802655:	85 c0                	test   %eax,%eax
  802657:	74 0f                	je     802668 <alloc_block_FF+0x37b>
  802659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265c:	8b 40 04             	mov    0x4(%eax),%eax
  80265f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802662:	8b 12                	mov    (%edx),%edx
  802664:	89 10                	mov    %edx,(%eax)
  802666:	eb 0a                	jmp    802672 <alloc_block_FF+0x385>
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	8b 00                	mov    (%eax),%eax
  80266d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802675:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80267b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802685:	a1 38 50 80 00       	mov    0x805038,%eax
  80268a:	48                   	dec    %eax
  80268b:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802690:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802693:	e9 0f 01 00 00       	jmp    8027a7 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802698:	a1 34 50 80 00       	mov    0x805034,%eax
  80269d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a4:	74 07                	je     8026ad <alloc_block_FF+0x3c0>
  8026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a9:	8b 00                	mov    (%eax),%eax
  8026ab:	eb 05                	jmp    8026b2 <alloc_block_FF+0x3c5>
  8026ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b2:	a3 34 50 80 00       	mov    %eax,0x805034
  8026b7:	a1 34 50 80 00       	mov    0x805034,%eax
  8026bc:	85 c0                	test   %eax,%eax
  8026be:	0f 85 e9 fc ff ff    	jne    8023ad <alloc_block_FF+0xc0>
  8026c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c8:	0f 85 df fc ff ff    	jne    8023ad <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8026ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d1:	83 c0 08             	add    $0x8,%eax
  8026d4:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8026d7:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026de:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026e4:	01 d0                	add    %edx,%eax
  8026e6:	48                   	dec    %eax
  8026e7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8026f2:	f7 75 d8             	divl   -0x28(%ebp)
  8026f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026f8:	29 d0                	sub    %edx,%eax
  8026fa:	c1 e8 0c             	shr    $0xc,%eax
  8026fd:	83 ec 0c             	sub    $0xc,%esp
  802700:	50                   	push   %eax
  802701:	e8 0b ed ff ff       	call   801411 <sbrk>
  802706:	83 c4 10             	add    $0x10,%esp
  802709:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80270c:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802710:	75 0a                	jne    80271c <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802712:	b8 00 00 00 00       	mov    $0x0,%eax
  802717:	e9 8b 00 00 00       	jmp    8027a7 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80271c:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802723:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802726:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802729:	01 d0                	add    %edx,%eax
  80272b:	48                   	dec    %eax
  80272c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80272f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802732:	ba 00 00 00 00       	mov    $0x0,%edx
  802737:	f7 75 cc             	divl   -0x34(%ebp)
  80273a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80273d:	29 d0                	sub    %edx,%eax
  80273f:	8d 50 fc             	lea    -0x4(%eax),%edx
  802742:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802745:	01 d0                	add    %edx,%eax
  802747:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80274c:	a1 40 50 80 00       	mov    0x805040,%eax
  802751:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802757:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80275e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802761:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802764:	01 d0                	add    %edx,%eax
  802766:	48                   	dec    %eax
  802767:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80276a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80276d:	ba 00 00 00 00       	mov    $0x0,%edx
  802772:	f7 75 c4             	divl   -0x3c(%ebp)
  802775:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802778:	29 d0                	sub    %edx,%eax
  80277a:	83 ec 04             	sub    $0x4,%esp
  80277d:	6a 01                	push   $0x1
  80277f:	50                   	push   %eax
  802780:	ff 75 d0             	pushl  -0x30(%ebp)
  802783:	e8 36 fb ff ff       	call   8022be <set_block_data>
  802788:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80278b:	83 ec 0c             	sub    $0xc,%esp
  80278e:	ff 75 d0             	pushl  -0x30(%ebp)
  802791:	e8 f8 09 00 00       	call   80318e <free_block>
  802796:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802799:	83 ec 0c             	sub    $0xc,%esp
  80279c:	ff 75 08             	pushl  0x8(%ebp)
  80279f:	e8 49 fb ff ff       	call   8022ed <alloc_block_FF>
  8027a4:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8027a7:	c9                   	leave  
  8027a8:	c3                   	ret    

008027a9 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8027a9:	55                   	push   %ebp
  8027aa:	89 e5                	mov    %esp,%ebp
  8027ac:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027af:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b2:	83 e0 01             	and    $0x1,%eax
  8027b5:	85 c0                	test   %eax,%eax
  8027b7:	74 03                	je     8027bc <alloc_block_BF+0x13>
  8027b9:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8027bc:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8027c0:	77 07                	ja     8027c9 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027c2:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027c9:	a1 24 50 80 00       	mov    0x805024,%eax
  8027ce:	85 c0                	test   %eax,%eax
  8027d0:	75 73                	jne    802845 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d5:	83 c0 10             	add    $0x10,%eax
  8027d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027db:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8027e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e8:	01 d0                	add    %edx,%eax
  8027ea:	48                   	dec    %eax
  8027eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8027ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8027f6:	f7 75 e0             	divl   -0x20(%ebp)
  8027f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027fc:	29 d0                	sub    %edx,%eax
  8027fe:	c1 e8 0c             	shr    $0xc,%eax
  802801:	83 ec 0c             	sub    $0xc,%esp
  802804:	50                   	push   %eax
  802805:	e8 07 ec ff ff       	call   801411 <sbrk>
  80280a:	83 c4 10             	add    $0x10,%esp
  80280d:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802810:	83 ec 0c             	sub    $0xc,%esp
  802813:	6a 00                	push   $0x0
  802815:	e8 f7 eb ff ff       	call   801411 <sbrk>
  80281a:	83 c4 10             	add    $0x10,%esp
  80281d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802820:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802823:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802826:	83 ec 08             	sub    $0x8,%esp
  802829:	50                   	push   %eax
  80282a:	ff 75 d8             	pushl  -0x28(%ebp)
  80282d:	e8 9f f8 ff ff       	call   8020d1 <initialize_dynamic_allocator>
  802832:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802835:	83 ec 0c             	sub    $0xc,%esp
  802838:	68 df 47 80 00       	push   $0x8047df
  80283d:	e8 35 de ff ff       	call   800677 <cprintf>
  802842:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802845:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80284c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802853:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80285a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802861:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802866:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802869:	e9 1d 01 00 00       	jmp    80298b <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802874:	83 ec 0c             	sub    $0xc,%esp
  802877:	ff 75 a8             	pushl  -0x58(%ebp)
  80287a:	e8 ee f6 ff ff       	call   801f6d <get_block_size>
  80287f:	83 c4 10             	add    $0x10,%esp
  802882:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802885:	8b 45 08             	mov    0x8(%ebp),%eax
  802888:	83 c0 08             	add    $0x8,%eax
  80288b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80288e:	0f 87 ef 00 00 00    	ja     802983 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802894:	8b 45 08             	mov    0x8(%ebp),%eax
  802897:	83 c0 18             	add    $0x18,%eax
  80289a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80289d:	77 1d                	ja     8028bc <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80289f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028a5:	0f 86 d8 00 00 00    	jbe    802983 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8028ab:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8028b1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028b7:	e9 c7 00 00 00       	jmp    802983 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8028bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bf:	83 c0 08             	add    $0x8,%eax
  8028c2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028c5:	0f 85 9d 00 00 00    	jne    802968 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8028cb:	83 ec 04             	sub    $0x4,%esp
  8028ce:	6a 01                	push   $0x1
  8028d0:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028d3:	ff 75 a8             	pushl  -0x58(%ebp)
  8028d6:	e8 e3 f9 ff ff       	call   8022be <set_block_data>
  8028db:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8028de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e2:	75 17                	jne    8028fb <alloc_block_BF+0x152>
  8028e4:	83 ec 04             	sub    $0x4,%esp
  8028e7:	68 83 47 80 00       	push   $0x804783
  8028ec:	68 2c 01 00 00       	push   $0x12c
  8028f1:	68 a1 47 80 00       	push   $0x8047a1
  8028f6:	e8 bf da ff ff       	call   8003ba <_panic>
  8028fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fe:	8b 00                	mov    (%eax),%eax
  802900:	85 c0                	test   %eax,%eax
  802902:	74 10                	je     802914 <alloc_block_BF+0x16b>
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	8b 00                	mov    (%eax),%eax
  802909:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80290c:	8b 52 04             	mov    0x4(%edx),%edx
  80290f:	89 50 04             	mov    %edx,0x4(%eax)
  802912:	eb 0b                	jmp    80291f <alloc_block_BF+0x176>
  802914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802917:	8b 40 04             	mov    0x4(%eax),%eax
  80291a:	a3 30 50 80 00       	mov    %eax,0x805030
  80291f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802922:	8b 40 04             	mov    0x4(%eax),%eax
  802925:	85 c0                	test   %eax,%eax
  802927:	74 0f                	je     802938 <alloc_block_BF+0x18f>
  802929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292c:	8b 40 04             	mov    0x4(%eax),%eax
  80292f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802932:	8b 12                	mov    (%edx),%edx
  802934:	89 10                	mov    %edx,(%eax)
  802936:	eb 0a                	jmp    802942 <alloc_block_BF+0x199>
  802938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293b:	8b 00                	mov    (%eax),%eax
  80293d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802945:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802955:	a1 38 50 80 00       	mov    0x805038,%eax
  80295a:	48                   	dec    %eax
  80295b:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802960:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802963:	e9 01 04 00 00       	jmp    802d69 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802968:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80296e:	76 13                	jbe    802983 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802970:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802977:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80297a:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80297d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802980:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802983:	a1 34 50 80 00       	mov    0x805034,%eax
  802988:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80298b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298f:	74 07                	je     802998 <alloc_block_BF+0x1ef>
  802991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802994:	8b 00                	mov    (%eax),%eax
  802996:	eb 05                	jmp    80299d <alloc_block_BF+0x1f4>
  802998:	b8 00 00 00 00       	mov    $0x0,%eax
  80299d:	a3 34 50 80 00       	mov    %eax,0x805034
  8029a2:	a1 34 50 80 00       	mov    0x805034,%eax
  8029a7:	85 c0                	test   %eax,%eax
  8029a9:	0f 85 bf fe ff ff    	jne    80286e <alloc_block_BF+0xc5>
  8029af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b3:	0f 85 b5 fe ff ff    	jne    80286e <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8029b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029bd:	0f 84 26 02 00 00    	je     802be9 <alloc_block_BF+0x440>
  8029c3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029c7:	0f 85 1c 02 00 00    	jne    802be9 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8029cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d0:	2b 45 08             	sub    0x8(%ebp),%eax
  8029d3:	83 e8 08             	sub    $0x8,%eax
  8029d6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8029d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dc:	8d 50 08             	lea    0x8(%eax),%edx
  8029df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e2:	01 d0                	add    %edx,%eax
  8029e4:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8029e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ea:	83 c0 08             	add    $0x8,%eax
  8029ed:	83 ec 04             	sub    $0x4,%esp
  8029f0:	6a 01                	push   $0x1
  8029f2:	50                   	push   %eax
  8029f3:	ff 75 f0             	pushl  -0x10(%ebp)
  8029f6:	e8 c3 f8 ff ff       	call   8022be <set_block_data>
  8029fb:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8029fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a01:	8b 40 04             	mov    0x4(%eax),%eax
  802a04:	85 c0                	test   %eax,%eax
  802a06:	75 68                	jne    802a70 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a08:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a0c:	75 17                	jne    802a25 <alloc_block_BF+0x27c>
  802a0e:	83 ec 04             	sub    $0x4,%esp
  802a11:	68 bc 47 80 00       	push   $0x8047bc
  802a16:	68 45 01 00 00       	push   $0x145
  802a1b:	68 a1 47 80 00       	push   $0x8047a1
  802a20:	e8 95 d9 ff ff       	call   8003ba <_panic>
  802a25:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a2b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a2e:	89 10                	mov    %edx,(%eax)
  802a30:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a33:	8b 00                	mov    (%eax),%eax
  802a35:	85 c0                	test   %eax,%eax
  802a37:	74 0d                	je     802a46 <alloc_block_BF+0x29d>
  802a39:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a3e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a41:	89 50 04             	mov    %edx,0x4(%eax)
  802a44:	eb 08                	jmp    802a4e <alloc_block_BF+0x2a5>
  802a46:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a49:	a3 30 50 80 00       	mov    %eax,0x805030
  802a4e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a51:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a56:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a60:	a1 38 50 80 00       	mov    0x805038,%eax
  802a65:	40                   	inc    %eax
  802a66:	a3 38 50 80 00       	mov    %eax,0x805038
  802a6b:	e9 dc 00 00 00       	jmp    802b4c <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a73:	8b 00                	mov    (%eax),%eax
  802a75:	85 c0                	test   %eax,%eax
  802a77:	75 65                	jne    802ade <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a79:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a7d:	75 17                	jne    802a96 <alloc_block_BF+0x2ed>
  802a7f:	83 ec 04             	sub    $0x4,%esp
  802a82:	68 f0 47 80 00       	push   $0x8047f0
  802a87:	68 4a 01 00 00       	push   $0x14a
  802a8c:	68 a1 47 80 00       	push   $0x8047a1
  802a91:	e8 24 d9 ff ff       	call   8003ba <_panic>
  802a96:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a9c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a9f:	89 50 04             	mov    %edx,0x4(%eax)
  802aa2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aa5:	8b 40 04             	mov    0x4(%eax),%eax
  802aa8:	85 c0                	test   %eax,%eax
  802aaa:	74 0c                	je     802ab8 <alloc_block_BF+0x30f>
  802aac:	a1 30 50 80 00       	mov    0x805030,%eax
  802ab1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ab4:	89 10                	mov    %edx,(%eax)
  802ab6:	eb 08                	jmp    802ac0 <alloc_block_BF+0x317>
  802ab8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802abb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ac0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ac3:	a3 30 50 80 00       	mov    %eax,0x805030
  802ac8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802acb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad1:	a1 38 50 80 00       	mov    0x805038,%eax
  802ad6:	40                   	inc    %eax
  802ad7:	a3 38 50 80 00       	mov    %eax,0x805038
  802adc:	eb 6e                	jmp    802b4c <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802ade:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ae2:	74 06                	je     802aea <alloc_block_BF+0x341>
  802ae4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ae8:	75 17                	jne    802b01 <alloc_block_BF+0x358>
  802aea:	83 ec 04             	sub    $0x4,%esp
  802aed:	68 14 48 80 00       	push   $0x804814
  802af2:	68 4f 01 00 00       	push   $0x14f
  802af7:	68 a1 47 80 00       	push   $0x8047a1
  802afc:	e8 b9 d8 ff ff       	call   8003ba <_panic>
  802b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b04:	8b 10                	mov    (%eax),%edx
  802b06:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b09:	89 10                	mov    %edx,(%eax)
  802b0b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b0e:	8b 00                	mov    (%eax),%eax
  802b10:	85 c0                	test   %eax,%eax
  802b12:	74 0b                	je     802b1f <alloc_block_BF+0x376>
  802b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b17:	8b 00                	mov    (%eax),%eax
  802b19:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b1c:	89 50 04             	mov    %edx,0x4(%eax)
  802b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b22:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b25:	89 10                	mov    %edx,(%eax)
  802b27:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b2d:	89 50 04             	mov    %edx,0x4(%eax)
  802b30:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b33:	8b 00                	mov    (%eax),%eax
  802b35:	85 c0                	test   %eax,%eax
  802b37:	75 08                	jne    802b41 <alloc_block_BF+0x398>
  802b39:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b3c:	a3 30 50 80 00       	mov    %eax,0x805030
  802b41:	a1 38 50 80 00       	mov    0x805038,%eax
  802b46:	40                   	inc    %eax
  802b47:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b50:	75 17                	jne    802b69 <alloc_block_BF+0x3c0>
  802b52:	83 ec 04             	sub    $0x4,%esp
  802b55:	68 83 47 80 00       	push   $0x804783
  802b5a:	68 51 01 00 00       	push   $0x151
  802b5f:	68 a1 47 80 00       	push   $0x8047a1
  802b64:	e8 51 d8 ff ff       	call   8003ba <_panic>
  802b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6c:	8b 00                	mov    (%eax),%eax
  802b6e:	85 c0                	test   %eax,%eax
  802b70:	74 10                	je     802b82 <alloc_block_BF+0x3d9>
  802b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b75:	8b 00                	mov    (%eax),%eax
  802b77:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b7a:	8b 52 04             	mov    0x4(%edx),%edx
  802b7d:	89 50 04             	mov    %edx,0x4(%eax)
  802b80:	eb 0b                	jmp    802b8d <alloc_block_BF+0x3e4>
  802b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b85:	8b 40 04             	mov    0x4(%eax),%eax
  802b88:	a3 30 50 80 00       	mov    %eax,0x805030
  802b8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b90:	8b 40 04             	mov    0x4(%eax),%eax
  802b93:	85 c0                	test   %eax,%eax
  802b95:	74 0f                	je     802ba6 <alloc_block_BF+0x3fd>
  802b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9a:	8b 40 04             	mov    0x4(%eax),%eax
  802b9d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba0:	8b 12                	mov    (%edx),%edx
  802ba2:	89 10                	mov    %edx,(%eax)
  802ba4:	eb 0a                	jmp    802bb0 <alloc_block_BF+0x407>
  802ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba9:	8b 00                	mov    (%eax),%eax
  802bab:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc3:	a1 38 50 80 00       	mov    0x805038,%eax
  802bc8:	48                   	dec    %eax
  802bc9:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802bce:	83 ec 04             	sub    $0x4,%esp
  802bd1:	6a 00                	push   $0x0
  802bd3:	ff 75 d0             	pushl  -0x30(%ebp)
  802bd6:	ff 75 cc             	pushl  -0x34(%ebp)
  802bd9:	e8 e0 f6 ff ff       	call   8022be <set_block_data>
  802bde:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be4:	e9 80 01 00 00       	jmp    802d69 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802be9:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802bed:	0f 85 9d 00 00 00    	jne    802c90 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802bf3:	83 ec 04             	sub    $0x4,%esp
  802bf6:	6a 01                	push   $0x1
  802bf8:	ff 75 ec             	pushl  -0x14(%ebp)
  802bfb:	ff 75 f0             	pushl  -0x10(%ebp)
  802bfe:	e8 bb f6 ff ff       	call   8022be <set_block_data>
  802c03:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802c06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c0a:	75 17                	jne    802c23 <alloc_block_BF+0x47a>
  802c0c:	83 ec 04             	sub    $0x4,%esp
  802c0f:	68 83 47 80 00       	push   $0x804783
  802c14:	68 58 01 00 00       	push   $0x158
  802c19:	68 a1 47 80 00       	push   $0x8047a1
  802c1e:	e8 97 d7 ff ff       	call   8003ba <_panic>
  802c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c26:	8b 00                	mov    (%eax),%eax
  802c28:	85 c0                	test   %eax,%eax
  802c2a:	74 10                	je     802c3c <alloc_block_BF+0x493>
  802c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2f:	8b 00                	mov    (%eax),%eax
  802c31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c34:	8b 52 04             	mov    0x4(%edx),%edx
  802c37:	89 50 04             	mov    %edx,0x4(%eax)
  802c3a:	eb 0b                	jmp    802c47 <alloc_block_BF+0x49e>
  802c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3f:	8b 40 04             	mov    0x4(%eax),%eax
  802c42:	a3 30 50 80 00       	mov    %eax,0x805030
  802c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4a:	8b 40 04             	mov    0x4(%eax),%eax
  802c4d:	85 c0                	test   %eax,%eax
  802c4f:	74 0f                	je     802c60 <alloc_block_BF+0x4b7>
  802c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c54:	8b 40 04             	mov    0x4(%eax),%eax
  802c57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c5a:	8b 12                	mov    (%edx),%edx
  802c5c:	89 10                	mov    %edx,(%eax)
  802c5e:	eb 0a                	jmp    802c6a <alloc_block_BF+0x4c1>
  802c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c63:	8b 00                	mov    (%eax),%eax
  802c65:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7d:	a1 38 50 80 00       	mov    0x805038,%eax
  802c82:	48                   	dec    %eax
  802c83:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8b:	e9 d9 00 00 00       	jmp    802d69 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c90:	8b 45 08             	mov    0x8(%ebp),%eax
  802c93:	83 c0 08             	add    $0x8,%eax
  802c96:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c99:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ca0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ca3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ca6:	01 d0                	add    %edx,%eax
  802ca8:	48                   	dec    %eax
  802ca9:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802cac:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802caf:	ba 00 00 00 00       	mov    $0x0,%edx
  802cb4:	f7 75 c4             	divl   -0x3c(%ebp)
  802cb7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cba:	29 d0                	sub    %edx,%eax
  802cbc:	c1 e8 0c             	shr    $0xc,%eax
  802cbf:	83 ec 0c             	sub    $0xc,%esp
  802cc2:	50                   	push   %eax
  802cc3:	e8 49 e7 ff ff       	call   801411 <sbrk>
  802cc8:	83 c4 10             	add    $0x10,%esp
  802ccb:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802cce:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802cd2:	75 0a                	jne    802cde <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802cd4:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd9:	e9 8b 00 00 00       	jmp    802d69 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802cde:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802ce5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ce8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802ceb:	01 d0                	add    %edx,%eax
  802ced:	48                   	dec    %eax
  802cee:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802cf1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cf4:	ba 00 00 00 00       	mov    $0x0,%edx
  802cf9:	f7 75 b8             	divl   -0x48(%ebp)
  802cfc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cff:	29 d0                	sub    %edx,%eax
  802d01:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d04:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d07:	01 d0                	add    %edx,%eax
  802d09:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802d0e:	a1 40 50 80 00       	mov    0x805040,%eax
  802d13:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d19:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d20:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d23:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d26:	01 d0                	add    %edx,%eax
  802d28:	48                   	dec    %eax
  802d29:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d2c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d2f:	ba 00 00 00 00       	mov    $0x0,%edx
  802d34:	f7 75 b0             	divl   -0x50(%ebp)
  802d37:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d3a:	29 d0                	sub    %edx,%eax
  802d3c:	83 ec 04             	sub    $0x4,%esp
  802d3f:	6a 01                	push   $0x1
  802d41:	50                   	push   %eax
  802d42:	ff 75 bc             	pushl  -0x44(%ebp)
  802d45:	e8 74 f5 ff ff       	call   8022be <set_block_data>
  802d4a:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d4d:	83 ec 0c             	sub    $0xc,%esp
  802d50:	ff 75 bc             	pushl  -0x44(%ebp)
  802d53:	e8 36 04 00 00       	call   80318e <free_block>
  802d58:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d5b:	83 ec 0c             	sub    $0xc,%esp
  802d5e:	ff 75 08             	pushl  0x8(%ebp)
  802d61:	e8 43 fa ff ff       	call   8027a9 <alloc_block_BF>
  802d66:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d69:	c9                   	leave  
  802d6a:	c3                   	ret    

00802d6b <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d6b:	55                   	push   %ebp
  802d6c:	89 e5                	mov    %esp,%ebp
  802d6e:	53                   	push   %ebx
  802d6f:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d79:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d80:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d84:	74 1e                	je     802da4 <merging+0x39>
  802d86:	ff 75 08             	pushl  0x8(%ebp)
  802d89:	e8 df f1 ff ff       	call   801f6d <get_block_size>
  802d8e:	83 c4 04             	add    $0x4,%esp
  802d91:	89 c2                	mov    %eax,%edx
  802d93:	8b 45 08             	mov    0x8(%ebp),%eax
  802d96:	01 d0                	add    %edx,%eax
  802d98:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d9b:	75 07                	jne    802da4 <merging+0x39>
		prev_is_free = 1;
  802d9d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802da4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802da8:	74 1e                	je     802dc8 <merging+0x5d>
  802daa:	ff 75 10             	pushl  0x10(%ebp)
  802dad:	e8 bb f1 ff ff       	call   801f6d <get_block_size>
  802db2:	83 c4 04             	add    $0x4,%esp
  802db5:	89 c2                	mov    %eax,%edx
  802db7:	8b 45 10             	mov    0x10(%ebp),%eax
  802dba:	01 d0                	add    %edx,%eax
  802dbc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802dbf:	75 07                	jne    802dc8 <merging+0x5d>
		next_is_free = 1;
  802dc1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802dc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dcc:	0f 84 cc 00 00 00    	je     802e9e <merging+0x133>
  802dd2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dd6:	0f 84 c2 00 00 00    	je     802e9e <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802ddc:	ff 75 08             	pushl  0x8(%ebp)
  802ddf:	e8 89 f1 ff ff       	call   801f6d <get_block_size>
  802de4:	83 c4 04             	add    $0x4,%esp
  802de7:	89 c3                	mov    %eax,%ebx
  802de9:	ff 75 10             	pushl  0x10(%ebp)
  802dec:	e8 7c f1 ff ff       	call   801f6d <get_block_size>
  802df1:	83 c4 04             	add    $0x4,%esp
  802df4:	01 c3                	add    %eax,%ebx
  802df6:	ff 75 0c             	pushl  0xc(%ebp)
  802df9:	e8 6f f1 ff ff       	call   801f6d <get_block_size>
  802dfe:	83 c4 04             	add    $0x4,%esp
  802e01:	01 d8                	add    %ebx,%eax
  802e03:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e06:	6a 00                	push   $0x0
  802e08:	ff 75 ec             	pushl  -0x14(%ebp)
  802e0b:	ff 75 08             	pushl  0x8(%ebp)
  802e0e:	e8 ab f4 ff ff       	call   8022be <set_block_data>
  802e13:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e16:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e1a:	75 17                	jne    802e33 <merging+0xc8>
  802e1c:	83 ec 04             	sub    $0x4,%esp
  802e1f:	68 83 47 80 00       	push   $0x804783
  802e24:	68 7d 01 00 00       	push   $0x17d
  802e29:	68 a1 47 80 00       	push   $0x8047a1
  802e2e:	e8 87 d5 ff ff       	call   8003ba <_panic>
  802e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e36:	8b 00                	mov    (%eax),%eax
  802e38:	85 c0                	test   %eax,%eax
  802e3a:	74 10                	je     802e4c <merging+0xe1>
  802e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e3f:	8b 00                	mov    (%eax),%eax
  802e41:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e44:	8b 52 04             	mov    0x4(%edx),%edx
  802e47:	89 50 04             	mov    %edx,0x4(%eax)
  802e4a:	eb 0b                	jmp    802e57 <merging+0xec>
  802e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e4f:	8b 40 04             	mov    0x4(%eax),%eax
  802e52:	a3 30 50 80 00       	mov    %eax,0x805030
  802e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e5a:	8b 40 04             	mov    0x4(%eax),%eax
  802e5d:	85 c0                	test   %eax,%eax
  802e5f:	74 0f                	je     802e70 <merging+0x105>
  802e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e64:	8b 40 04             	mov    0x4(%eax),%eax
  802e67:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e6a:	8b 12                	mov    (%edx),%edx
  802e6c:	89 10                	mov    %edx,(%eax)
  802e6e:	eb 0a                	jmp    802e7a <merging+0x10f>
  802e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e73:	8b 00                	mov    (%eax),%eax
  802e75:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e83:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8d:	a1 38 50 80 00       	mov    0x805038,%eax
  802e92:	48                   	dec    %eax
  802e93:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e98:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e99:	e9 ea 02 00 00       	jmp    803188 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea2:	74 3b                	je     802edf <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802ea4:	83 ec 0c             	sub    $0xc,%esp
  802ea7:	ff 75 08             	pushl  0x8(%ebp)
  802eaa:	e8 be f0 ff ff       	call   801f6d <get_block_size>
  802eaf:	83 c4 10             	add    $0x10,%esp
  802eb2:	89 c3                	mov    %eax,%ebx
  802eb4:	83 ec 0c             	sub    $0xc,%esp
  802eb7:	ff 75 10             	pushl  0x10(%ebp)
  802eba:	e8 ae f0 ff ff       	call   801f6d <get_block_size>
  802ebf:	83 c4 10             	add    $0x10,%esp
  802ec2:	01 d8                	add    %ebx,%eax
  802ec4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ec7:	83 ec 04             	sub    $0x4,%esp
  802eca:	6a 00                	push   $0x0
  802ecc:	ff 75 e8             	pushl  -0x18(%ebp)
  802ecf:	ff 75 08             	pushl  0x8(%ebp)
  802ed2:	e8 e7 f3 ff ff       	call   8022be <set_block_data>
  802ed7:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802eda:	e9 a9 02 00 00       	jmp    803188 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802edf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ee3:	0f 84 2d 01 00 00    	je     803016 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802ee9:	83 ec 0c             	sub    $0xc,%esp
  802eec:	ff 75 10             	pushl  0x10(%ebp)
  802eef:	e8 79 f0 ff ff       	call   801f6d <get_block_size>
  802ef4:	83 c4 10             	add    $0x10,%esp
  802ef7:	89 c3                	mov    %eax,%ebx
  802ef9:	83 ec 0c             	sub    $0xc,%esp
  802efc:	ff 75 0c             	pushl  0xc(%ebp)
  802eff:	e8 69 f0 ff ff       	call   801f6d <get_block_size>
  802f04:	83 c4 10             	add    $0x10,%esp
  802f07:	01 d8                	add    %ebx,%eax
  802f09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f0c:	83 ec 04             	sub    $0x4,%esp
  802f0f:	6a 00                	push   $0x0
  802f11:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f14:	ff 75 10             	pushl  0x10(%ebp)
  802f17:	e8 a2 f3 ff ff       	call   8022be <set_block_data>
  802f1c:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f1f:	8b 45 10             	mov    0x10(%ebp),%eax
  802f22:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f29:	74 06                	je     802f31 <merging+0x1c6>
  802f2b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f2f:	75 17                	jne    802f48 <merging+0x1dd>
  802f31:	83 ec 04             	sub    $0x4,%esp
  802f34:	68 48 48 80 00       	push   $0x804848
  802f39:	68 8d 01 00 00       	push   $0x18d
  802f3e:	68 a1 47 80 00       	push   $0x8047a1
  802f43:	e8 72 d4 ff ff       	call   8003ba <_panic>
  802f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4b:	8b 50 04             	mov    0x4(%eax),%edx
  802f4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f51:	89 50 04             	mov    %edx,0x4(%eax)
  802f54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f57:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f5a:	89 10                	mov    %edx,(%eax)
  802f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f5f:	8b 40 04             	mov    0x4(%eax),%eax
  802f62:	85 c0                	test   %eax,%eax
  802f64:	74 0d                	je     802f73 <merging+0x208>
  802f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f69:	8b 40 04             	mov    0x4(%eax),%eax
  802f6c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f6f:	89 10                	mov    %edx,(%eax)
  802f71:	eb 08                	jmp    802f7b <merging+0x210>
  802f73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f76:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f7e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f81:	89 50 04             	mov    %edx,0x4(%eax)
  802f84:	a1 38 50 80 00       	mov    0x805038,%eax
  802f89:	40                   	inc    %eax
  802f8a:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802f8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f93:	75 17                	jne    802fac <merging+0x241>
  802f95:	83 ec 04             	sub    $0x4,%esp
  802f98:	68 83 47 80 00       	push   $0x804783
  802f9d:	68 8e 01 00 00       	push   $0x18e
  802fa2:	68 a1 47 80 00       	push   $0x8047a1
  802fa7:	e8 0e d4 ff ff       	call   8003ba <_panic>
  802fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  802faf:	8b 00                	mov    (%eax),%eax
  802fb1:	85 c0                	test   %eax,%eax
  802fb3:	74 10                	je     802fc5 <merging+0x25a>
  802fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb8:	8b 00                	mov    (%eax),%eax
  802fba:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fbd:	8b 52 04             	mov    0x4(%edx),%edx
  802fc0:	89 50 04             	mov    %edx,0x4(%eax)
  802fc3:	eb 0b                	jmp    802fd0 <merging+0x265>
  802fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc8:	8b 40 04             	mov    0x4(%eax),%eax
  802fcb:	a3 30 50 80 00       	mov    %eax,0x805030
  802fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd3:	8b 40 04             	mov    0x4(%eax),%eax
  802fd6:	85 c0                	test   %eax,%eax
  802fd8:	74 0f                	je     802fe9 <merging+0x27e>
  802fda:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fdd:	8b 40 04             	mov    0x4(%eax),%eax
  802fe0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fe3:	8b 12                	mov    (%edx),%edx
  802fe5:	89 10                	mov    %edx,(%eax)
  802fe7:	eb 0a                	jmp    802ff3 <merging+0x288>
  802fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fec:	8b 00                	mov    (%eax),%eax
  802fee:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803006:	a1 38 50 80 00       	mov    0x805038,%eax
  80300b:	48                   	dec    %eax
  80300c:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803011:	e9 72 01 00 00       	jmp    803188 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803016:	8b 45 10             	mov    0x10(%ebp),%eax
  803019:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80301c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803020:	74 79                	je     80309b <merging+0x330>
  803022:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803026:	74 73                	je     80309b <merging+0x330>
  803028:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80302c:	74 06                	je     803034 <merging+0x2c9>
  80302e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803032:	75 17                	jne    80304b <merging+0x2e0>
  803034:	83 ec 04             	sub    $0x4,%esp
  803037:	68 14 48 80 00       	push   $0x804814
  80303c:	68 94 01 00 00       	push   $0x194
  803041:	68 a1 47 80 00       	push   $0x8047a1
  803046:	e8 6f d3 ff ff       	call   8003ba <_panic>
  80304b:	8b 45 08             	mov    0x8(%ebp),%eax
  80304e:	8b 10                	mov    (%eax),%edx
  803050:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803053:	89 10                	mov    %edx,(%eax)
  803055:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803058:	8b 00                	mov    (%eax),%eax
  80305a:	85 c0                	test   %eax,%eax
  80305c:	74 0b                	je     803069 <merging+0x2fe>
  80305e:	8b 45 08             	mov    0x8(%ebp),%eax
  803061:	8b 00                	mov    (%eax),%eax
  803063:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803066:	89 50 04             	mov    %edx,0x4(%eax)
  803069:	8b 45 08             	mov    0x8(%ebp),%eax
  80306c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80306f:	89 10                	mov    %edx,(%eax)
  803071:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803074:	8b 55 08             	mov    0x8(%ebp),%edx
  803077:	89 50 04             	mov    %edx,0x4(%eax)
  80307a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80307d:	8b 00                	mov    (%eax),%eax
  80307f:	85 c0                	test   %eax,%eax
  803081:	75 08                	jne    80308b <merging+0x320>
  803083:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803086:	a3 30 50 80 00       	mov    %eax,0x805030
  80308b:	a1 38 50 80 00       	mov    0x805038,%eax
  803090:	40                   	inc    %eax
  803091:	a3 38 50 80 00       	mov    %eax,0x805038
  803096:	e9 ce 00 00 00       	jmp    803169 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80309b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80309f:	74 65                	je     803106 <merging+0x39b>
  8030a1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030a5:	75 17                	jne    8030be <merging+0x353>
  8030a7:	83 ec 04             	sub    $0x4,%esp
  8030aa:	68 f0 47 80 00       	push   $0x8047f0
  8030af:	68 95 01 00 00       	push   $0x195
  8030b4:	68 a1 47 80 00       	push   $0x8047a1
  8030b9:	e8 fc d2 ff ff       	call   8003ba <_panic>
  8030be:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8030c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c7:	89 50 04             	mov    %edx,0x4(%eax)
  8030ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030cd:	8b 40 04             	mov    0x4(%eax),%eax
  8030d0:	85 c0                	test   %eax,%eax
  8030d2:	74 0c                	je     8030e0 <merging+0x375>
  8030d4:	a1 30 50 80 00       	mov    0x805030,%eax
  8030d9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030dc:	89 10                	mov    %edx,(%eax)
  8030de:	eb 08                	jmp    8030e8 <merging+0x37d>
  8030e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030eb:	a3 30 50 80 00       	mov    %eax,0x805030
  8030f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030f9:	a1 38 50 80 00       	mov    0x805038,%eax
  8030fe:	40                   	inc    %eax
  8030ff:	a3 38 50 80 00       	mov    %eax,0x805038
  803104:	eb 63                	jmp    803169 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803106:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80310a:	75 17                	jne    803123 <merging+0x3b8>
  80310c:	83 ec 04             	sub    $0x4,%esp
  80310f:	68 bc 47 80 00       	push   $0x8047bc
  803114:	68 98 01 00 00       	push   $0x198
  803119:	68 a1 47 80 00       	push   $0x8047a1
  80311e:	e8 97 d2 ff ff       	call   8003ba <_panic>
  803123:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803129:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80312c:	89 10                	mov    %edx,(%eax)
  80312e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803131:	8b 00                	mov    (%eax),%eax
  803133:	85 c0                	test   %eax,%eax
  803135:	74 0d                	je     803144 <merging+0x3d9>
  803137:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80313c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80313f:	89 50 04             	mov    %edx,0x4(%eax)
  803142:	eb 08                	jmp    80314c <merging+0x3e1>
  803144:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803147:	a3 30 50 80 00       	mov    %eax,0x805030
  80314c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80314f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803154:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803157:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80315e:	a1 38 50 80 00       	mov    0x805038,%eax
  803163:	40                   	inc    %eax
  803164:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803169:	83 ec 0c             	sub    $0xc,%esp
  80316c:	ff 75 10             	pushl  0x10(%ebp)
  80316f:	e8 f9 ed ff ff       	call   801f6d <get_block_size>
  803174:	83 c4 10             	add    $0x10,%esp
  803177:	83 ec 04             	sub    $0x4,%esp
  80317a:	6a 00                	push   $0x0
  80317c:	50                   	push   %eax
  80317d:	ff 75 10             	pushl  0x10(%ebp)
  803180:	e8 39 f1 ff ff       	call   8022be <set_block_data>
  803185:	83 c4 10             	add    $0x10,%esp
	}
}
  803188:	90                   	nop
  803189:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80318c:	c9                   	leave  
  80318d:	c3                   	ret    

0080318e <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80318e:	55                   	push   %ebp
  80318f:	89 e5                	mov    %esp,%ebp
  803191:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803194:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803199:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80319c:	a1 30 50 80 00       	mov    0x805030,%eax
  8031a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031a4:	73 1b                	jae    8031c1 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8031a6:	a1 30 50 80 00       	mov    0x805030,%eax
  8031ab:	83 ec 04             	sub    $0x4,%esp
  8031ae:	ff 75 08             	pushl  0x8(%ebp)
  8031b1:	6a 00                	push   $0x0
  8031b3:	50                   	push   %eax
  8031b4:	e8 b2 fb ff ff       	call   802d6b <merging>
  8031b9:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031bc:	e9 8b 00 00 00       	jmp    80324c <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8031c1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031c6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031c9:	76 18                	jbe    8031e3 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8031cb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031d0:	83 ec 04             	sub    $0x4,%esp
  8031d3:	ff 75 08             	pushl  0x8(%ebp)
  8031d6:	50                   	push   %eax
  8031d7:	6a 00                	push   $0x0
  8031d9:	e8 8d fb ff ff       	call   802d6b <merging>
  8031de:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031e1:	eb 69                	jmp    80324c <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031e3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031eb:	eb 39                	jmp    803226 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8031ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031f3:	73 29                	jae    80321e <free_block+0x90>
  8031f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f8:	8b 00                	mov    (%eax),%eax
  8031fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031fd:	76 1f                	jbe    80321e <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8031ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803202:	8b 00                	mov    (%eax),%eax
  803204:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803207:	83 ec 04             	sub    $0x4,%esp
  80320a:	ff 75 08             	pushl  0x8(%ebp)
  80320d:	ff 75 f0             	pushl  -0x10(%ebp)
  803210:	ff 75 f4             	pushl  -0xc(%ebp)
  803213:	e8 53 fb ff ff       	call   802d6b <merging>
  803218:	83 c4 10             	add    $0x10,%esp
			break;
  80321b:	90                   	nop
		}
	}
}
  80321c:	eb 2e                	jmp    80324c <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80321e:	a1 34 50 80 00       	mov    0x805034,%eax
  803223:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803226:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80322a:	74 07                	je     803233 <free_block+0xa5>
  80322c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322f:	8b 00                	mov    (%eax),%eax
  803231:	eb 05                	jmp    803238 <free_block+0xaa>
  803233:	b8 00 00 00 00       	mov    $0x0,%eax
  803238:	a3 34 50 80 00       	mov    %eax,0x805034
  80323d:	a1 34 50 80 00       	mov    0x805034,%eax
  803242:	85 c0                	test   %eax,%eax
  803244:	75 a7                	jne    8031ed <free_block+0x5f>
  803246:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80324a:	75 a1                	jne    8031ed <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80324c:	90                   	nop
  80324d:	c9                   	leave  
  80324e:	c3                   	ret    

0080324f <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80324f:	55                   	push   %ebp
  803250:	89 e5                	mov    %esp,%ebp
  803252:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803255:	ff 75 08             	pushl  0x8(%ebp)
  803258:	e8 10 ed ff ff       	call   801f6d <get_block_size>
  80325d:	83 c4 04             	add    $0x4,%esp
  803260:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803263:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80326a:	eb 17                	jmp    803283 <copy_data+0x34>
  80326c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80326f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803272:	01 c2                	add    %eax,%edx
  803274:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803277:	8b 45 08             	mov    0x8(%ebp),%eax
  80327a:	01 c8                	add    %ecx,%eax
  80327c:	8a 00                	mov    (%eax),%al
  80327e:	88 02                	mov    %al,(%edx)
  803280:	ff 45 fc             	incl   -0x4(%ebp)
  803283:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803286:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803289:	72 e1                	jb     80326c <copy_data+0x1d>
}
  80328b:	90                   	nop
  80328c:	c9                   	leave  
  80328d:	c3                   	ret    

0080328e <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80328e:	55                   	push   %ebp
  80328f:	89 e5                	mov    %esp,%ebp
  803291:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803294:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803298:	75 23                	jne    8032bd <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80329a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80329e:	74 13                	je     8032b3 <realloc_block_FF+0x25>
  8032a0:	83 ec 0c             	sub    $0xc,%esp
  8032a3:	ff 75 0c             	pushl  0xc(%ebp)
  8032a6:	e8 42 f0 ff ff       	call   8022ed <alloc_block_FF>
  8032ab:	83 c4 10             	add    $0x10,%esp
  8032ae:	e9 e4 06 00 00       	jmp    803997 <realloc_block_FF+0x709>
		return NULL;
  8032b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b8:	e9 da 06 00 00       	jmp    803997 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  8032bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032c1:	75 18                	jne    8032db <realloc_block_FF+0x4d>
	{
		free_block(va);
  8032c3:	83 ec 0c             	sub    $0xc,%esp
  8032c6:	ff 75 08             	pushl  0x8(%ebp)
  8032c9:	e8 c0 fe ff ff       	call   80318e <free_block>
  8032ce:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8032d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032d6:	e9 bc 06 00 00       	jmp    803997 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  8032db:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8032df:	77 07                	ja     8032e8 <realloc_block_FF+0x5a>
  8032e1:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8032e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032eb:	83 e0 01             	and    $0x1,%eax
  8032ee:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8032f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032f4:	83 c0 08             	add    $0x8,%eax
  8032f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8032fa:	83 ec 0c             	sub    $0xc,%esp
  8032fd:	ff 75 08             	pushl  0x8(%ebp)
  803300:	e8 68 ec ff ff       	call   801f6d <get_block_size>
  803305:	83 c4 10             	add    $0x10,%esp
  803308:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80330b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330e:	83 e8 08             	sub    $0x8,%eax
  803311:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803314:	8b 45 08             	mov    0x8(%ebp),%eax
  803317:	83 e8 04             	sub    $0x4,%eax
  80331a:	8b 00                	mov    (%eax),%eax
  80331c:	83 e0 fe             	and    $0xfffffffe,%eax
  80331f:	89 c2                	mov    %eax,%edx
  803321:	8b 45 08             	mov    0x8(%ebp),%eax
  803324:	01 d0                	add    %edx,%eax
  803326:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803329:	83 ec 0c             	sub    $0xc,%esp
  80332c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80332f:	e8 39 ec ff ff       	call   801f6d <get_block_size>
  803334:	83 c4 10             	add    $0x10,%esp
  803337:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80333a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80333d:	83 e8 08             	sub    $0x8,%eax
  803340:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803343:	8b 45 0c             	mov    0xc(%ebp),%eax
  803346:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803349:	75 08                	jne    803353 <realloc_block_FF+0xc5>
	{
		 return va;
  80334b:	8b 45 08             	mov    0x8(%ebp),%eax
  80334e:	e9 44 06 00 00       	jmp    803997 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803353:	8b 45 0c             	mov    0xc(%ebp),%eax
  803356:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803359:	0f 83 d5 03 00 00    	jae    803734 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80335f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803362:	2b 45 0c             	sub    0xc(%ebp),%eax
  803365:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803368:	83 ec 0c             	sub    $0xc,%esp
  80336b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80336e:	e8 13 ec ff ff       	call   801f86 <is_free_block>
  803373:	83 c4 10             	add    $0x10,%esp
  803376:	84 c0                	test   %al,%al
  803378:	0f 84 3b 01 00 00    	je     8034b9 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80337e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803381:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803384:	01 d0                	add    %edx,%eax
  803386:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803389:	83 ec 04             	sub    $0x4,%esp
  80338c:	6a 01                	push   $0x1
  80338e:	ff 75 f0             	pushl  -0x10(%ebp)
  803391:	ff 75 08             	pushl  0x8(%ebp)
  803394:	e8 25 ef ff ff       	call   8022be <set_block_data>
  803399:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80339c:	8b 45 08             	mov    0x8(%ebp),%eax
  80339f:	83 e8 04             	sub    $0x4,%eax
  8033a2:	8b 00                	mov    (%eax),%eax
  8033a4:	83 e0 fe             	and    $0xfffffffe,%eax
  8033a7:	89 c2                	mov    %eax,%edx
  8033a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ac:	01 d0                	add    %edx,%eax
  8033ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8033b1:	83 ec 04             	sub    $0x4,%esp
  8033b4:	6a 00                	push   $0x0
  8033b6:	ff 75 cc             	pushl  -0x34(%ebp)
  8033b9:	ff 75 c8             	pushl  -0x38(%ebp)
  8033bc:	e8 fd ee ff ff       	call   8022be <set_block_data>
  8033c1:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8033c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033c8:	74 06                	je     8033d0 <realloc_block_FF+0x142>
  8033ca:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8033ce:	75 17                	jne    8033e7 <realloc_block_FF+0x159>
  8033d0:	83 ec 04             	sub    $0x4,%esp
  8033d3:	68 14 48 80 00       	push   $0x804814
  8033d8:	68 f6 01 00 00       	push   $0x1f6
  8033dd:	68 a1 47 80 00       	push   $0x8047a1
  8033e2:	e8 d3 cf ff ff       	call   8003ba <_panic>
  8033e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ea:	8b 10                	mov    (%eax),%edx
  8033ec:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033ef:	89 10                	mov    %edx,(%eax)
  8033f1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033f4:	8b 00                	mov    (%eax),%eax
  8033f6:	85 c0                	test   %eax,%eax
  8033f8:	74 0b                	je     803405 <realloc_block_FF+0x177>
  8033fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033fd:	8b 00                	mov    (%eax),%eax
  8033ff:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803402:	89 50 04             	mov    %edx,0x4(%eax)
  803405:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803408:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80340b:	89 10                	mov    %edx,(%eax)
  80340d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803410:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803413:	89 50 04             	mov    %edx,0x4(%eax)
  803416:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803419:	8b 00                	mov    (%eax),%eax
  80341b:	85 c0                	test   %eax,%eax
  80341d:	75 08                	jne    803427 <realloc_block_FF+0x199>
  80341f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803422:	a3 30 50 80 00       	mov    %eax,0x805030
  803427:	a1 38 50 80 00       	mov    0x805038,%eax
  80342c:	40                   	inc    %eax
  80342d:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803432:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803436:	75 17                	jne    80344f <realloc_block_FF+0x1c1>
  803438:	83 ec 04             	sub    $0x4,%esp
  80343b:	68 83 47 80 00       	push   $0x804783
  803440:	68 f7 01 00 00       	push   $0x1f7
  803445:	68 a1 47 80 00       	push   $0x8047a1
  80344a:	e8 6b cf ff ff       	call   8003ba <_panic>
  80344f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803452:	8b 00                	mov    (%eax),%eax
  803454:	85 c0                	test   %eax,%eax
  803456:	74 10                	je     803468 <realloc_block_FF+0x1da>
  803458:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345b:	8b 00                	mov    (%eax),%eax
  80345d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803460:	8b 52 04             	mov    0x4(%edx),%edx
  803463:	89 50 04             	mov    %edx,0x4(%eax)
  803466:	eb 0b                	jmp    803473 <realloc_block_FF+0x1e5>
  803468:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80346b:	8b 40 04             	mov    0x4(%eax),%eax
  80346e:	a3 30 50 80 00       	mov    %eax,0x805030
  803473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803476:	8b 40 04             	mov    0x4(%eax),%eax
  803479:	85 c0                	test   %eax,%eax
  80347b:	74 0f                	je     80348c <realloc_block_FF+0x1fe>
  80347d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803480:	8b 40 04             	mov    0x4(%eax),%eax
  803483:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803486:	8b 12                	mov    (%edx),%edx
  803488:	89 10                	mov    %edx,(%eax)
  80348a:	eb 0a                	jmp    803496 <realloc_block_FF+0x208>
  80348c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80348f:	8b 00                	mov    (%eax),%eax
  803491:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803496:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803499:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80349f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034a9:	a1 38 50 80 00       	mov    0x805038,%eax
  8034ae:	48                   	dec    %eax
  8034af:	a3 38 50 80 00       	mov    %eax,0x805038
  8034b4:	e9 73 02 00 00       	jmp    80372c <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  8034b9:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8034bd:	0f 86 69 02 00 00    	jbe    80372c <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8034c3:	83 ec 04             	sub    $0x4,%esp
  8034c6:	6a 01                	push   $0x1
  8034c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8034cb:	ff 75 08             	pushl  0x8(%ebp)
  8034ce:	e8 eb ed ff ff       	call   8022be <set_block_data>
  8034d3:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8034d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d9:	83 e8 04             	sub    $0x4,%eax
  8034dc:	8b 00                	mov    (%eax),%eax
  8034de:	83 e0 fe             	and    $0xfffffffe,%eax
  8034e1:	89 c2                	mov    %eax,%edx
  8034e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e6:	01 d0                	add    %edx,%eax
  8034e8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8034eb:	a1 38 50 80 00       	mov    0x805038,%eax
  8034f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8034f3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8034f7:	75 68                	jne    803561 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034f9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034fd:	75 17                	jne    803516 <realloc_block_FF+0x288>
  8034ff:	83 ec 04             	sub    $0x4,%esp
  803502:	68 bc 47 80 00       	push   $0x8047bc
  803507:	68 06 02 00 00       	push   $0x206
  80350c:	68 a1 47 80 00       	push   $0x8047a1
  803511:	e8 a4 ce ff ff       	call   8003ba <_panic>
  803516:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80351c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80351f:	89 10                	mov    %edx,(%eax)
  803521:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803524:	8b 00                	mov    (%eax),%eax
  803526:	85 c0                	test   %eax,%eax
  803528:	74 0d                	je     803537 <realloc_block_FF+0x2a9>
  80352a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80352f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803532:	89 50 04             	mov    %edx,0x4(%eax)
  803535:	eb 08                	jmp    80353f <realloc_block_FF+0x2b1>
  803537:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80353a:	a3 30 50 80 00       	mov    %eax,0x805030
  80353f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803542:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803547:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80354a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803551:	a1 38 50 80 00       	mov    0x805038,%eax
  803556:	40                   	inc    %eax
  803557:	a3 38 50 80 00       	mov    %eax,0x805038
  80355c:	e9 b0 01 00 00       	jmp    803711 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803561:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803566:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803569:	76 68                	jbe    8035d3 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80356b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80356f:	75 17                	jne    803588 <realloc_block_FF+0x2fa>
  803571:	83 ec 04             	sub    $0x4,%esp
  803574:	68 bc 47 80 00       	push   $0x8047bc
  803579:	68 0b 02 00 00       	push   $0x20b
  80357e:	68 a1 47 80 00       	push   $0x8047a1
  803583:	e8 32 ce ff ff       	call   8003ba <_panic>
  803588:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80358e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803591:	89 10                	mov    %edx,(%eax)
  803593:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803596:	8b 00                	mov    (%eax),%eax
  803598:	85 c0                	test   %eax,%eax
  80359a:	74 0d                	je     8035a9 <realloc_block_FF+0x31b>
  80359c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035a1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035a4:	89 50 04             	mov    %edx,0x4(%eax)
  8035a7:	eb 08                	jmp    8035b1 <realloc_block_FF+0x323>
  8035a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ac:	a3 30 50 80 00       	mov    %eax,0x805030
  8035b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035c3:	a1 38 50 80 00       	mov    0x805038,%eax
  8035c8:	40                   	inc    %eax
  8035c9:	a3 38 50 80 00       	mov    %eax,0x805038
  8035ce:	e9 3e 01 00 00       	jmp    803711 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8035d3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035d8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035db:	73 68                	jae    803645 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035dd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035e1:	75 17                	jne    8035fa <realloc_block_FF+0x36c>
  8035e3:	83 ec 04             	sub    $0x4,%esp
  8035e6:	68 f0 47 80 00       	push   $0x8047f0
  8035eb:	68 10 02 00 00       	push   $0x210
  8035f0:	68 a1 47 80 00       	push   $0x8047a1
  8035f5:	e8 c0 cd ff ff       	call   8003ba <_panic>
  8035fa:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803600:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803603:	89 50 04             	mov    %edx,0x4(%eax)
  803606:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803609:	8b 40 04             	mov    0x4(%eax),%eax
  80360c:	85 c0                	test   %eax,%eax
  80360e:	74 0c                	je     80361c <realloc_block_FF+0x38e>
  803610:	a1 30 50 80 00       	mov    0x805030,%eax
  803615:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803618:	89 10                	mov    %edx,(%eax)
  80361a:	eb 08                	jmp    803624 <realloc_block_FF+0x396>
  80361c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80361f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803624:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803627:	a3 30 50 80 00       	mov    %eax,0x805030
  80362c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80362f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803635:	a1 38 50 80 00       	mov    0x805038,%eax
  80363a:	40                   	inc    %eax
  80363b:	a3 38 50 80 00       	mov    %eax,0x805038
  803640:	e9 cc 00 00 00       	jmp    803711 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803645:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80364c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803651:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803654:	e9 8a 00 00 00       	jmp    8036e3 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80365f:	73 7a                	jae    8036db <realloc_block_FF+0x44d>
  803661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803664:	8b 00                	mov    (%eax),%eax
  803666:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803669:	73 70                	jae    8036db <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80366b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80366f:	74 06                	je     803677 <realloc_block_FF+0x3e9>
  803671:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803675:	75 17                	jne    80368e <realloc_block_FF+0x400>
  803677:	83 ec 04             	sub    $0x4,%esp
  80367a:	68 14 48 80 00       	push   $0x804814
  80367f:	68 1a 02 00 00       	push   $0x21a
  803684:	68 a1 47 80 00       	push   $0x8047a1
  803689:	e8 2c cd ff ff       	call   8003ba <_panic>
  80368e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803691:	8b 10                	mov    (%eax),%edx
  803693:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803696:	89 10                	mov    %edx,(%eax)
  803698:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80369b:	8b 00                	mov    (%eax),%eax
  80369d:	85 c0                	test   %eax,%eax
  80369f:	74 0b                	je     8036ac <realloc_block_FF+0x41e>
  8036a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a4:	8b 00                	mov    (%eax),%eax
  8036a6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036a9:	89 50 04             	mov    %edx,0x4(%eax)
  8036ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036af:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036b2:	89 10                	mov    %edx,(%eax)
  8036b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036ba:	89 50 04             	mov    %edx,0x4(%eax)
  8036bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c0:	8b 00                	mov    (%eax),%eax
  8036c2:	85 c0                	test   %eax,%eax
  8036c4:	75 08                	jne    8036ce <realloc_block_FF+0x440>
  8036c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c9:	a3 30 50 80 00       	mov    %eax,0x805030
  8036ce:	a1 38 50 80 00       	mov    0x805038,%eax
  8036d3:	40                   	inc    %eax
  8036d4:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8036d9:	eb 36                	jmp    803711 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8036db:	a1 34 50 80 00       	mov    0x805034,%eax
  8036e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036e7:	74 07                	je     8036f0 <realloc_block_FF+0x462>
  8036e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ec:	8b 00                	mov    (%eax),%eax
  8036ee:	eb 05                	jmp    8036f5 <realloc_block_FF+0x467>
  8036f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f5:	a3 34 50 80 00       	mov    %eax,0x805034
  8036fa:	a1 34 50 80 00       	mov    0x805034,%eax
  8036ff:	85 c0                	test   %eax,%eax
  803701:	0f 85 52 ff ff ff    	jne    803659 <realloc_block_FF+0x3cb>
  803707:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80370b:	0f 85 48 ff ff ff    	jne    803659 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803711:	83 ec 04             	sub    $0x4,%esp
  803714:	6a 00                	push   $0x0
  803716:	ff 75 d8             	pushl  -0x28(%ebp)
  803719:	ff 75 d4             	pushl  -0x2c(%ebp)
  80371c:	e8 9d eb ff ff       	call   8022be <set_block_data>
  803721:	83 c4 10             	add    $0x10,%esp
				return va;
  803724:	8b 45 08             	mov    0x8(%ebp),%eax
  803727:	e9 6b 02 00 00       	jmp    803997 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  80372c:	8b 45 08             	mov    0x8(%ebp),%eax
  80372f:	e9 63 02 00 00       	jmp    803997 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803734:	8b 45 0c             	mov    0xc(%ebp),%eax
  803737:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80373a:	0f 86 4d 02 00 00    	jbe    80398d <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803740:	83 ec 0c             	sub    $0xc,%esp
  803743:	ff 75 e4             	pushl  -0x1c(%ebp)
  803746:	e8 3b e8 ff ff       	call   801f86 <is_free_block>
  80374b:	83 c4 10             	add    $0x10,%esp
  80374e:	84 c0                	test   %al,%al
  803750:	0f 84 37 02 00 00    	je     80398d <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803756:	8b 45 0c             	mov    0xc(%ebp),%eax
  803759:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80375c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80375f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803762:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803765:	76 38                	jbe    80379f <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803767:	83 ec 0c             	sub    $0xc,%esp
  80376a:	ff 75 0c             	pushl  0xc(%ebp)
  80376d:	e8 7b eb ff ff       	call   8022ed <alloc_block_FF>
  803772:	83 c4 10             	add    $0x10,%esp
  803775:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803778:	83 ec 08             	sub    $0x8,%esp
  80377b:	ff 75 c0             	pushl  -0x40(%ebp)
  80377e:	ff 75 08             	pushl  0x8(%ebp)
  803781:	e8 c9 fa ff ff       	call   80324f <copy_data>
  803786:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803789:	83 ec 0c             	sub    $0xc,%esp
  80378c:	ff 75 08             	pushl  0x8(%ebp)
  80378f:	e8 fa f9 ff ff       	call   80318e <free_block>
  803794:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803797:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80379a:	e9 f8 01 00 00       	jmp    803997 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80379f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037a2:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8037a5:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8037a8:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8037ac:	0f 87 a0 00 00 00    	ja     803852 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8037b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037b6:	75 17                	jne    8037cf <realloc_block_FF+0x541>
  8037b8:	83 ec 04             	sub    $0x4,%esp
  8037bb:	68 83 47 80 00       	push   $0x804783
  8037c0:	68 38 02 00 00       	push   $0x238
  8037c5:	68 a1 47 80 00       	push   $0x8047a1
  8037ca:	e8 eb cb ff ff       	call   8003ba <_panic>
  8037cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d2:	8b 00                	mov    (%eax),%eax
  8037d4:	85 c0                	test   %eax,%eax
  8037d6:	74 10                	je     8037e8 <realloc_block_FF+0x55a>
  8037d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037db:	8b 00                	mov    (%eax),%eax
  8037dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037e0:	8b 52 04             	mov    0x4(%edx),%edx
  8037e3:	89 50 04             	mov    %edx,0x4(%eax)
  8037e6:	eb 0b                	jmp    8037f3 <realloc_block_FF+0x565>
  8037e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037eb:	8b 40 04             	mov    0x4(%eax),%eax
  8037ee:	a3 30 50 80 00       	mov    %eax,0x805030
  8037f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f6:	8b 40 04             	mov    0x4(%eax),%eax
  8037f9:	85 c0                	test   %eax,%eax
  8037fb:	74 0f                	je     80380c <realloc_block_FF+0x57e>
  8037fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803800:	8b 40 04             	mov    0x4(%eax),%eax
  803803:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803806:	8b 12                	mov    (%edx),%edx
  803808:	89 10                	mov    %edx,(%eax)
  80380a:	eb 0a                	jmp    803816 <realloc_block_FF+0x588>
  80380c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380f:	8b 00                	mov    (%eax),%eax
  803811:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803816:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803819:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80381f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803822:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803829:	a1 38 50 80 00       	mov    0x805038,%eax
  80382e:	48                   	dec    %eax
  80382f:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803834:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803837:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80383a:	01 d0                	add    %edx,%eax
  80383c:	83 ec 04             	sub    $0x4,%esp
  80383f:	6a 01                	push   $0x1
  803841:	50                   	push   %eax
  803842:	ff 75 08             	pushl  0x8(%ebp)
  803845:	e8 74 ea ff ff       	call   8022be <set_block_data>
  80384a:	83 c4 10             	add    $0x10,%esp
  80384d:	e9 36 01 00 00       	jmp    803988 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803852:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803855:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803858:	01 d0                	add    %edx,%eax
  80385a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80385d:	83 ec 04             	sub    $0x4,%esp
  803860:	6a 01                	push   $0x1
  803862:	ff 75 f0             	pushl  -0x10(%ebp)
  803865:	ff 75 08             	pushl  0x8(%ebp)
  803868:	e8 51 ea ff ff       	call   8022be <set_block_data>
  80386d:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803870:	8b 45 08             	mov    0x8(%ebp),%eax
  803873:	83 e8 04             	sub    $0x4,%eax
  803876:	8b 00                	mov    (%eax),%eax
  803878:	83 e0 fe             	and    $0xfffffffe,%eax
  80387b:	89 c2                	mov    %eax,%edx
  80387d:	8b 45 08             	mov    0x8(%ebp),%eax
  803880:	01 d0                	add    %edx,%eax
  803882:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803885:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803889:	74 06                	je     803891 <realloc_block_FF+0x603>
  80388b:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80388f:	75 17                	jne    8038a8 <realloc_block_FF+0x61a>
  803891:	83 ec 04             	sub    $0x4,%esp
  803894:	68 14 48 80 00       	push   $0x804814
  803899:	68 44 02 00 00       	push   $0x244
  80389e:	68 a1 47 80 00       	push   $0x8047a1
  8038a3:	e8 12 cb ff ff       	call   8003ba <_panic>
  8038a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ab:	8b 10                	mov    (%eax),%edx
  8038ad:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038b0:	89 10                	mov    %edx,(%eax)
  8038b2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038b5:	8b 00                	mov    (%eax),%eax
  8038b7:	85 c0                	test   %eax,%eax
  8038b9:	74 0b                	je     8038c6 <realloc_block_FF+0x638>
  8038bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038be:	8b 00                	mov    (%eax),%eax
  8038c0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038c3:	89 50 04             	mov    %edx,0x4(%eax)
  8038c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c9:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038cc:	89 10                	mov    %edx,(%eax)
  8038ce:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038d4:	89 50 04             	mov    %edx,0x4(%eax)
  8038d7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038da:	8b 00                	mov    (%eax),%eax
  8038dc:	85 c0                	test   %eax,%eax
  8038de:	75 08                	jne    8038e8 <realloc_block_FF+0x65a>
  8038e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038e3:	a3 30 50 80 00       	mov    %eax,0x805030
  8038e8:	a1 38 50 80 00       	mov    0x805038,%eax
  8038ed:	40                   	inc    %eax
  8038ee:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8038f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038f7:	75 17                	jne    803910 <realloc_block_FF+0x682>
  8038f9:	83 ec 04             	sub    $0x4,%esp
  8038fc:	68 83 47 80 00       	push   $0x804783
  803901:	68 45 02 00 00       	push   $0x245
  803906:	68 a1 47 80 00       	push   $0x8047a1
  80390b:	e8 aa ca ff ff       	call   8003ba <_panic>
  803910:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803913:	8b 00                	mov    (%eax),%eax
  803915:	85 c0                	test   %eax,%eax
  803917:	74 10                	je     803929 <realloc_block_FF+0x69b>
  803919:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391c:	8b 00                	mov    (%eax),%eax
  80391e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803921:	8b 52 04             	mov    0x4(%edx),%edx
  803924:	89 50 04             	mov    %edx,0x4(%eax)
  803927:	eb 0b                	jmp    803934 <realloc_block_FF+0x6a6>
  803929:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80392c:	8b 40 04             	mov    0x4(%eax),%eax
  80392f:	a3 30 50 80 00       	mov    %eax,0x805030
  803934:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803937:	8b 40 04             	mov    0x4(%eax),%eax
  80393a:	85 c0                	test   %eax,%eax
  80393c:	74 0f                	je     80394d <realloc_block_FF+0x6bf>
  80393e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803941:	8b 40 04             	mov    0x4(%eax),%eax
  803944:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803947:	8b 12                	mov    (%edx),%edx
  803949:	89 10                	mov    %edx,(%eax)
  80394b:	eb 0a                	jmp    803957 <realloc_block_FF+0x6c9>
  80394d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803950:	8b 00                	mov    (%eax),%eax
  803952:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803957:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803960:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803963:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80396a:	a1 38 50 80 00       	mov    0x805038,%eax
  80396f:	48                   	dec    %eax
  803970:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803975:	83 ec 04             	sub    $0x4,%esp
  803978:	6a 00                	push   $0x0
  80397a:	ff 75 bc             	pushl  -0x44(%ebp)
  80397d:	ff 75 b8             	pushl  -0x48(%ebp)
  803980:	e8 39 e9 ff ff       	call   8022be <set_block_data>
  803985:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803988:	8b 45 08             	mov    0x8(%ebp),%eax
  80398b:	eb 0a                	jmp    803997 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80398d:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803994:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803997:	c9                   	leave  
  803998:	c3                   	ret    

00803999 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803999:	55                   	push   %ebp
  80399a:	89 e5                	mov    %esp,%ebp
  80399c:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80399f:	83 ec 04             	sub    $0x4,%esp
  8039a2:	68 80 48 80 00       	push   $0x804880
  8039a7:	68 58 02 00 00       	push   $0x258
  8039ac:	68 a1 47 80 00       	push   $0x8047a1
  8039b1:	e8 04 ca ff ff       	call   8003ba <_panic>

008039b6 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8039b6:	55                   	push   %ebp
  8039b7:	89 e5                	mov    %esp,%ebp
  8039b9:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8039bc:	83 ec 04             	sub    $0x4,%esp
  8039bf:	68 a8 48 80 00       	push   $0x8048a8
  8039c4:	68 61 02 00 00       	push   $0x261
  8039c9:	68 a1 47 80 00       	push   $0x8047a1
  8039ce:	e8 e7 c9 ff ff       	call   8003ba <_panic>
  8039d3:	90                   	nop

008039d4 <__udivdi3>:
  8039d4:	55                   	push   %ebp
  8039d5:	57                   	push   %edi
  8039d6:	56                   	push   %esi
  8039d7:	53                   	push   %ebx
  8039d8:	83 ec 1c             	sub    $0x1c,%esp
  8039db:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039df:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039eb:	89 ca                	mov    %ecx,%edx
  8039ed:	89 f8                	mov    %edi,%eax
  8039ef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039f3:	85 f6                	test   %esi,%esi
  8039f5:	75 2d                	jne    803a24 <__udivdi3+0x50>
  8039f7:	39 cf                	cmp    %ecx,%edi
  8039f9:	77 65                	ja     803a60 <__udivdi3+0x8c>
  8039fb:	89 fd                	mov    %edi,%ebp
  8039fd:	85 ff                	test   %edi,%edi
  8039ff:	75 0b                	jne    803a0c <__udivdi3+0x38>
  803a01:	b8 01 00 00 00       	mov    $0x1,%eax
  803a06:	31 d2                	xor    %edx,%edx
  803a08:	f7 f7                	div    %edi
  803a0a:	89 c5                	mov    %eax,%ebp
  803a0c:	31 d2                	xor    %edx,%edx
  803a0e:	89 c8                	mov    %ecx,%eax
  803a10:	f7 f5                	div    %ebp
  803a12:	89 c1                	mov    %eax,%ecx
  803a14:	89 d8                	mov    %ebx,%eax
  803a16:	f7 f5                	div    %ebp
  803a18:	89 cf                	mov    %ecx,%edi
  803a1a:	89 fa                	mov    %edi,%edx
  803a1c:	83 c4 1c             	add    $0x1c,%esp
  803a1f:	5b                   	pop    %ebx
  803a20:	5e                   	pop    %esi
  803a21:	5f                   	pop    %edi
  803a22:	5d                   	pop    %ebp
  803a23:	c3                   	ret    
  803a24:	39 ce                	cmp    %ecx,%esi
  803a26:	77 28                	ja     803a50 <__udivdi3+0x7c>
  803a28:	0f bd fe             	bsr    %esi,%edi
  803a2b:	83 f7 1f             	xor    $0x1f,%edi
  803a2e:	75 40                	jne    803a70 <__udivdi3+0x9c>
  803a30:	39 ce                	cmp    %ecx,%esi
  803a32:	72 0a                	jb     803a3e <__udivdi3+0x6a>
  803a34:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a38:	0f 87 9e 00 00 00    	ja     803adc <__udivdi3+0x108>
  803a3e:	b8 01 00 00 00       	mov    $0x1,%eax
  803a43:	89 fa                	mov    %edi,%edx
  803a45:	83 c4 1c             	add    $0x1c,%esp
  803a48:	5b                   	pop    %ebx
  803a49:	5e                   	pop    %esi
  803a4a:	5f                   	pop    %edi
  803a4b:	5d                   	pop    %ebp
  803a4c:	c3                   	ret    
  803a4d:	8d 76 00             	lea    0x0(%esi),%esi
  803a50:	31 ff                	xor    %edi,%edi
  803a52:	31 c0                	xor    %eax,%eax
  803a54:	89 fa                	mov    %edi,%edx
  803a56:	83 c4 1c             	add    $0x1c,%esp
  803a59:	5b                   	pop    %ebx
  803a5a:	5e                   	pop    %esi
  803a5b:	5f                   	pop    %edi
  803a5c:	5d                   	pop    %ebp
  803a5d:	c3                   	ret    
  803a5e:	66 90                	xchg   %ax,%ax
  803a60:	89 d8                	mov    %ebx,%eax
  803a62:	f7 f7                	div    %edi
  803a64:	31 ff                	xor    %edi,%edi
  803a66:	89 fa                	mov    %edi,%edx
  803a68:	83 c4 1c             	add    $0x1c,%esp
  803a6b:	5b                   	pop    %ebx
  803a6c:	5e                   	pop    %esi
  803a6d:	5f                   	pop    %edi
  803a6e:	5d                   	pop    %ebp
  803a6f:	c3                   	ret    
  803a70:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a75:	89 eb                	mov    %ebp,%ebx
  803a77:	29 fb                	sub    %edi,%ebx
  803a79:	89 f9                	mov    %edi,%ecx
  803a7b:	d3 e6                	shl    %cl,%esi
  803a7d:	89 c5                	mov    %eax,%ebp
  803a7f:	88 d9                	mov    %bl,%cl
  803a81:	d3 ed                	shr    %cl,%ebp
  803a83:	89 e9                	mov    %ebp,%ecx
  803a85:	09 f1                	or     %esi,%ecx
  803a87:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a8b:	89 f9                	mov    %edi,%ecx
  803a8d:	d3 e0                	shl    %cl,%eax
  803a8f:	89 c5                	mov    %eax,%ebp
  803a91:	89 d6                	mov    %edx,%esi
  803a93:	88 d9                	mov    %bl,%cl
  803a95:	d3 ee                	shr    %cl,%esi
  803a97:	89 f9                	mov    %edi,%ecx
  803a99:	d3 e2                	shl    %cl,%edx
  803a9b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a9f:	88 d9                	mov    %bl,%cl
  803aa1:	d3 e8                	shr    %cl,%eax
  803aa3:	09 c2                	or     %eax,%edx
  803aa5:	89 d0                	mov    %edx,%eax
  803aa7:	89 f2                	mov    %esi,%edx
  803aa9:	f7 74 24 0c          	divl   0xc(%esp)
  803aad:	89 d6                	mov    %edx,%esi
  803aaf:	89 c3                	mov    %eax,%ebx
  803ab1:	f7 e5                	mul    %ebp
  803ab3:	39 d6                	cmp    %edx,%esi
  803ab5:	72 19                	jb     803ad0 <__udivdi3+0xfc>
  803ab7:	74 0b                	je     803ac4 <__udivdi3+0xf0>
  803ab9:	89 d8                	mov    %ebx,%eax
  803abb:	31 ff                	xor    %edi,%edi
  803abd:	e9 58 ff ff ff       	jmp    803a1a <__udivdi3+0x46>
  803ac2:	66 90                	xchg   %ax,%ax
  803ac4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ac8:	89 f9                	mov    %edi,%ecx
  803aca:	d3 e2                	shl    %cl,%edx
  803acc:	39 c2                	cmp    %eax,%edx
  803ace:	73 e9                	jae    803ab9 <__udivdi3+0xe5>
  803ad0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ad3:	31 ff                	xor    %edi,%edi
  803ad5:	e9 40 ff ff ff       	jmp    803a1a <__udivdi3+0x46>
  803ada:	66 90                	xchg   %ax,%ax
  803adc:	31 c0                	xor    %eax,%eax
  803ade:	e9 37 ff ff ff       	jmp    803a1a <__udivdi3+0x46>
  803ae3:	90                   	nop

00803ae4 <__umoddi3>:
  803ae4:	55                   	push   %ebp
  803ae5:	57                   	push   %edi
  803ae6:	56                   	push   %esi
  803ae7:	53                   	push   %ebx
  803ae8:	83 ec 1c             	sub    $0x1c,%esp
  803aeb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803aef:	8b 74 24 34          	mov    0x34(%esp),%esi
  803af3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803af7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803afb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803aff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b03:	89 f3                	mov    %esi,%ebx
  803b05:	89 fa                	mov    %edi,%edx
  803b07:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b0b:	89 34 24             	mov    %esi,(%esp)
  803b0e:	85 c0                	test   %eax,%eax
  803b10:	75 1a                	jne    803b2c <__umoddi3+0x48>
  803b12:	39 f7                	cmp    %esi,%edi
  803b14:	0f 86 a2 00 00 00    	jbe    803bbc <__umoddi3+0xd8>
  803b1a:	89 c8                	mov    %ecx,%eax
  803b1c:	89 f2                	mov    %esi,%edx
  803b1e:	f7 f7                	div    %edi
  803b20:	89 d0                	mov    %edx,%eax
  803b22:	31 d2                	xor    %edx,%edx
  803b24:	83 c4 1c             	add    $0x1c,%esp
  803b27:	5b                   	pop    %ebx
  803b28:	5e                   	pop    %esi
  803b29:	5f                   	pop    %edi
  803b2a:	5d                   	pop    %ebp
  803b2b:	c3                   	ret    
  803b2c:	39 f0                	cmp    %esi,%eax
  803b2e:	0f 87 ac 00 00 00    	ja     803be0 <__umoddi3+0xfc>
  803b34:	0f bd e8             	bsr    %eax,%ebp
  803b37:	83 f5 1f             	xor    $0x1f,%ebp
  803b3a:	0f 84 ac 00 00 00    	je     803bec <__umoddi3+0x108>
  803b40:	bf 20 00 00 00       	mov    $0x20,%edi
  803b45:	29 ef                	sub    %ebp,%edi
  803b47:	89 fe                	mov    %edi,%esi
  803b49:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b4d:	89 e9                	mov    %ebp,%ecx
  803b4f:	d3 e0                	shl    %cl,%eax
  803b51:	89 d7                	mov    %edx,%edi
  803b53:	89 f1                	mov    %esi,%ecx
  803b55:	d3 ef                	shr    %cl,%edi
  803b57:	09 c7                	or     %eax,%edi
  803b59:	89 e9                	mov    %ebp,%ecx
  803b5b:	d3 e2                	shl    %cl,%edx
  803b5d:	89 14 24             	mov    %edx,(%esp)
  803b60:	89 d8                	mov    %ebx,%eax
  803b62:	d3 e0                	shl    %cl,%eax
  803b64:	89 c2                	mov    %eax,%edx
  803b66:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b6a:	d3 e0                	shl    %cl,%eax
  803b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b70:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b74:	89 f1                	mov    %esi,%ecx
  803b76:	d3 e8                	shr    %cl,%eax
  803b78:	09 d0                	or     %edx,%eax
  803b7a:	d3 eb                	shr    %cl,%ebx
  803b7c:	89 da                	mov    %ebx,%edx
  803b7e:	f7 f7                	div    %edi
  803b80:	89 d3                	mov    %edx,%ebx
  803b82:	f7 24 24             	mull   (%esp)
  803b85:	89 c6                	mov    %eax,%esi
  803b87:	89 d1                	mov    %edx,%ecx
  803b89:	39 d3                	cmp    %edx,%ebx
  803b8b:	0f 82 87 00 00 00    	jb     803c18 <__umoddi3+0x134>
  803b91:	0f 84 91 00 00 00    	je     803c28 <__umoddi3+0x144>
  803b97:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b9b:	29 f2                	sub    %esi,%edx
  803b9d:	19 cb                	sbb    %ecx,%ebx
  803b9f:	89 d8                	mov    %ebx,%eax
  803ba1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ba5:	d3 e0                	shl    %cl,%eax
  803ba7:	89 e9                	mov    %ebp,%ecx
  803ba9:	d3 ea                	shr    %cl,%edx
  803bab:	09 d0                	or     %edx,%eax
  803bad:	89 e9                	mov    %ebp,%ecx
  803baf:	d3 eb                	shr    %cl,%ebx
  803bb1:	89 da                	mov    %ebx,%edx
  803bb3:	83 c4 1c             	add    $0x1c,%esp
  803bb6:	5b                   	pop    %ebx
  803bb7:	5e                   	pop    %esi
  803bb8:	5f                   	pop    %edi
  803bb9:	5d                   	pop    %ebp
  803bba:	c3                   	ret    
  803bbb:	90                   	nop
  803bbc:	89 fd                	mov    %edi,%ebp
  803bbe:	85 ff                	test   %edi,%edi
  803bc0:	75 0b                	jne    803bcd <__umoddi3+0xe9>
  803bc2:	b8 01 00 00 00       	mov    $0x1,%eax
  803bc7:	31 d2                	xor    %edx,%edx
  803bc9:	f7 f7                	div    %edi
  803bcb:	89 c5                	mov    %eax,%ebp
  803bcd:	89 f0                	mov    %esi,%eax
  803bcf:	31 d2                	xor    %edx,%edx
  803bd1:	f7 f5                	div    %ebp
  803bd3:	89 c8                	mov    %ecx,%eax
  803bd5:	f7 f5                	div    %ebp
  803bd7:	89 d0                	mov    %edx,%eax
  803bd9:	e9 44 ff ff ff       	jmp    803b22 <__umoddi3+0x3e>
  803bde:	66 90                	xchg   %ax,%ax
  803be0:	89 c8                	mov    %ecx,%eax
  803be2:	89 f2                	mov    %esi,%edx
  803be4:	83 c4 1c             	add    $0x1c,%esp
  803be7:	5b                   	pop    %ebx
  803be8:	5e                   	pop    %esi
  803be9:	5f                   	pop    %edi
  803bea:	5d                   	pop    %ebp
  803beb:	c3                   	ret    
  803bec:	3b 04 24             	cmp    (%esp),%eax
  803bef:	72 06                	jb     803bf7 <__umoddi3+0x113>
  803bf1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803bf5:	77 0f                	ja     803c06 <__umoddi3+0x122>
  803bf7:	89 f2                	mov    %esi,%edx
  803bf9:	29 f9                	sub    %edi,%ecx
  803bfb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803bff:	89 14 24             	mov    %edx,(%esp)
  803c02:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c06:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c0a:	8b 14 24             	mov    (%esp),%edx
  803c0d:	83 c4 1c             	add    $0x1c,%esp
  803c10:	5b                   	pop    %ebx
  803c11:	5e                   	pop    %esi
  803c12:	5f                   	pop    %edi
  803c13:	5d                   	pop    %ebp
  803c14:	c3                   	ret    
  803c15:	8d 76 00             	lea    0x0(%esi),%esi
  803c18:	2b 04 24             	sub    (%esp),%eax
  803c1b:	19 fa                	sbb    %edi,%edx
  803c1d:	89 d1                	mov    %edx,%ecx
  803c1f:	89 c6                	mov    %eax,%esi
  803c21:	e9 71 ff ff ff       	jmp    803b97 <__umoddi3+0xb3>
  803c26:	66 90                	xchg   %ax,%ax
  803c28:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c2c:	72 ea                	jb     803c18 <__umoddi3+0x134>
  803c2e:	89 d9                	mov    %ebx,%ecx
  803c30:	e9 62 ff ff ff       	jmp    803b97 <__umoddi3+0xb3>
