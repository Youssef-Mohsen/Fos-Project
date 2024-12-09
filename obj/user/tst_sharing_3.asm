
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
  80005b:	68 e0 3c 80 00       	push   $0x803ce0
  800060:	6a 0c                	push   $0xc
  800062:	68 fc 3c 80 00       	push   $0x803cfc
  800067:	e8 4e 03 00 00       	call   8003ba <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	cprintf("************************************************\n");
  80006c:	83 ec 0c             	sub    $0xc,%esp
  80006f:	68 14 3d 80 00       	push   $0x803d14
  800074:	e8 fe 05 00 00       	call   800677 <cprintf>
  800079:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	68 48 3d 80 00       	push   $0x803d48
  800084:	e8 ee 05 00 00       	call   800677 <cprintf>
  800089:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 a4 3d 80 00       	push   $0x803da4
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
  8000b4:	68 d8 3d 80 00       	push   $0x803dd8
  8000b9:	e8 b9 05 00 00       	call   800677 <cprintf>
  8000be:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 01                	push   $0x1
  8000c6:	68 00 10 00 00       	push   $0x1000
  8000cb:	68 26 3e 80 00       	push   $0x803e26
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
  8000ed:	68 26 3e 80 00       	push   $0x803e26
  8000f2:	e8 4e 16 00 00       	call   801745 <smalloc>
  8000f7:	83 c4 10             	add    $0x10,%esp
  8000fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) {is_correct = 0; cprintf("Trying to create an already exists object and corresponding error is not returned!!");}
  8000fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800101:	74 17                	je     80011a <_main+0xe2>
  800103:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	68 28 3e 80 00       	push   $0x803e28
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
  800132:	68 7c 3e 80 00       	push   $0x803e7c
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
  800153:	68 d8 3e 80 00       	push   $0x803ed8
  800158:	e8 1a 05 00 00       	call   800677 <cprintf>
  80015d:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		x = sget(myEnv->env_id, "xx");
  800160:	a1 20 50 80 00       	mov    0x805020,%eax
  800165:	8b 40 10             	mov    0x10(%eax),%eax
  800168:	83 ec 08             	sub    $0x8,%esp
  80016b:	68 1d 3f 80 00       	push   $0x803f1d
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
  800194:	68 20 3f 80 00       	push   $0x803f20
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
  8001b9:	68 70 3f 80 00       	push   $0x803f70
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
  8001da:	68 c8 3f 80 00       	push   $0x803fc8
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
  800202:	68 25 40 80 00       	push   $0x804025
  800207:	e8 39 15 00 00       	call   801745 <smalloc>
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (y != NULL) {is_correct = 0; cprintf("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");}
  800212:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800216:	74 17                	je     80022f <_main+0x1f7>
  800218:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	68 28 40 80 00       	push   $0x804028
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
  800247:	68 9c 40 80 00       	push   $0x80409c
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
  80026b:	68 10 41 80 00       	push   $0x804110
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
  8002f7:	68 7c 41 80 00       	push   $0x80417c
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
  80031f:	68 a4 41 80 00       	push   $0x8041a4
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
  800350:	68 cc 41 80 00       	push   $0x8041cc
  800355:	e8 1d 03 00 00       	call   800677 <cprintf>
  80035a:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80035d:	a1 20 50 80 00       	mov    0x805020,%eax
  800362:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800368:	83 ec 08             	sub    $0x8,%esp
  80036b:	50                   	push   %eax
  80036c:	68 24 42 80 00       	push   $0x804224
  800371:	e8 01 03 00 00       	call   800677 <cprintf>
  800376:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800379:	83 ec 0c             	sub    $0xc,%esp
  80037c:	68 7c 41 80 00       	push   $0x80417c
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
  8003db:	68 38 42 80 00       	push   $0x804238
  8003e0:	e8 92 02 00 00       	call   800677 <cprintf>
  8003e5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003e8:	a1 00 50 80 00       	mov    0x805000,%eax
  8003ed:	ff 75 0c             	pushl  0xc(%ebp)
  8003f0:	ff 75 08             	pushl  0x8(%ebp)
  8003f3:	50                   	push   %eax
  8003f4:	68 3d 42 80 00       	push   $0x80423d
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
  800418:	68 59 42 80 00       	push   $0x804259
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
  800447:	68 5c 42 80 00       	push   $0x80425c
  80044c:	6a 26                	push   $0x26
  80044e:	68 a8 42 80 00       	push   $0x8042a8
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
  80051c:	68 b4 42 80 00       	push   $0x8042b4
  800521:	6a 3a                	push   $0x3a
  800523:	68 a8 42 80 00       	push   $0x8042a8
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
  80058f:	68 08 43 80 00       	push   $0x804308
  800594:	6a 44                	push   $0x44
  800596:	68 a8 42 80 00       	push   $0x8042a8
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
  800714:	e8 57 33 00 00       	call   803a70 <__udivdi3>
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
  800764:	e8 17 34 00 00       	call   803b80 <__umoddi3>
  800769:	83 c4 10             	add    $0x10,%esp
  80076c:	05 74 45 80 00       	add    $0x804574,%eax
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
  8008bf:	8b 04 85 98 45 80 00 	mov    0x804598(,%eax,4),%eax
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
  8009a0:	8b 34 9d e0 43 80 00 	mov    0x8043e0(,%ebx,4),%esi
  8009a7:	85 f6                	test   %esi,%esi
  8009a9:	75 19                	jne    8009c4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009ab:	53                   	push   %ebx
  8009ac:	68 85 45 80 00       	push   $0x804585
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
  8009c5:	68 8e 45 80 00       	push   $0x80458e
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
  8009f2:	be 91 45 80 00       	mov    $0x804591,%esi
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
  8013fd:	68 08 47 80 00       	push   $0x804708
  801402:	68 3f 01 00 00       	push   $0x13f
  801407:	68 2a 47 80 00       	push   $0x80472a
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
  8014a7:	e8 dd 0e 00 00       	call   802389 <alloc_block_FF>
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
  8014ca:	e8 76 13 00 00       	call   802845 <alloc_block_BF>
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
  801678:	e8 8c 09 00 00       	call   802009 <get_block_size>
  80167d:	83 c4 10             	add    $0x10,%esp
  801680:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801683:	83 ec 0c             	sub    $0xc,%esp
  801686:	ff 75 08             	pushl  0x8(%ebp)
  801689:	e8 9c 1b 00 00       	call   80322a <free_block>
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
  80172e:	68 38 47 80 00       	push   $0x804738
  801733:	68 87 00 00 00       	push   $0x87
  801738:	68 62 47 80 00       	push   $0x804762
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
  8018d9:	68 70 47 80 00       	push   $0x804770
  8018de:	68 e4 00 00 00       	push   $0xe4
  8018e3:	68 62 47 80 00       	push   $0x804762
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
  8018f6:	68 96 47 80 00       	push   $0x804796
  8018fb:	68 f0 00 00 00       	push   $0xf0
  801900:	68 62 47 80 00       	push   $0x804762
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
  801913:	68 96 47 80 00       	push   $0x804796
  801918:	68 f5 00 00 00       	push   $0xf5
  80191d:	68 62 47 80 00       	push   $0x804762
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
  801930:	68 96 47 80 00       	push   $0x804796
  801935:	68 fa 00 00 00       	push   $0xfa
  80193a:	68 62 47 80 00       	push   $0x804762
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

00801f6d <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
  801f70:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 2e                	push   $0x2e
  801f7f:	e8 c0 f9 ff ff       	call   801944 <syscall>
  801f84:	83 c4 18             	add    $0x18,%esp
  801f87:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801f8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    

00801f8f <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	50                   	push   %eax
  801f9e:	6a 2f                	push   $0x2f
  801fa0:	e8 9f f9 ff ff       	call   801944 <syscall>
  801fa5:	83 c4 18             	add    $0x18,%esp
	return;
  801fa8:	90                   	nop
}
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    

00801fab <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  801fae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	52                   	push   %edx
  801fbb:	50                   	push   %eax
  801fbc:	6a 30                	push   $0x30
  801fbe:	e8 81 f9 ff ff       	call   801944 <syscall>
  801fc3:	83 c4 18             	add    $0x18,%esp
	return;
  801fc6:	90                   	nop
}
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  801fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	50                   	push   %eax
  801fdb:	6a 31                	push   $0x31
  801fdd:	e8 62 f9 ff ff       	call   801944 <syscall>
  801fe2:	83 c4 18             	add    $0x18,%esp
  801fe5:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801fe8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  801ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	50                   	push   %eax
  801ffc:	6a 32                	push   $0x32
  801ffe:	e8 41 f9 ff ff       	call   801944 <syscall>
  802003:	83 c4 18             	add    $0x18,%esp
	return;
  802006:	90                   	nop
}
  802007:	c9                   	leave  
  802008:	c3                   	ret    

00802009 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
  80200c:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80200f:	8b 45 08             	mov    0x8(%ebp),%eax
  802012:	83 e8 04             	sub    $0x4,%eax
  802015:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802018:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80201b:	8b 00                	mov    (%eax),%eax
  80201d:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802020:	c9                   	leave  
  802021:	c3                   	ret    

00802022 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802022:	55                   	push   %ebp
  802023:	89 e5                	mov    %esp,%ebp
  802025:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802028:	8b 45 08             	mov    0x8(%ebp),%eax
  80202b:	83 e8 04             	sub    $0x4,%eax
  80202e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802031:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802034:	8b 00                	mov    (%eax),%eax
  802036:	83 e0 01             	and    $0x1,%eax
  802039:	85 c0                	test   %eax,%eax
  80203b:	0f 94 c0             	sete   %al
}
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
  802043:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802046:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80204d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802050:	83 f8 02             	cmp    $0x2,%eax
  802053:	74 2b                	je     802080 <alloc_block+0x40>
  802055:	83 f8 02             	cmp    $0x2,%eax
  802058:	7f 07                	jg     802061 <alloc_block+0x21>
  80205a:	83 f8 01             	cmp    $0x1,%eax
  80205d:	74 0e                	je     80206d <alloc_block+0x2d>
  80205f:	eb 58                	jmp    8020b9 <alloc_block+0x79>
  802061:	83 f8 03             	cmp    $0x3,%eax
  802064:	74 2d                	je     802093 <alloc_block+0x53>
  802066:	83 f8 04             	cmp    $0x4,%eax
  802069:	74 3b                	je     8020a6 <alloc_block+0x66>
  80206b:	eb 4c                	jmp    8020b9 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80206d:	83 ec 0c             	sub    $0xc,%esp
  802070:	ff 75 08             	pushl  0x8(%ebp)
  802073:	e8 11 03 00 00       	call   802389 <alloc_block_FF>
  802078:	83 c4 10             	add    $0x10,%esp
  80207b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80207e:	eb 4a                	jmp    8020ca <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802080:	83 ec 0c             	sub    $0xc,%esp
  802083:	ff 75 08             	pushl  0x8(%ebp)
  802086:	e8 c7 19 00 00       	call   803a52 <alloc_block_NF>
  80208b:	83 c4 10             	add    $0x10,%esp
  80208e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802091:	eb 37                	jmp    8020ca <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802093:	83 ec 0c             	sub    $0xc,%esp
  802096:	ff 75 08             	pushl  0x8(%ebp)
  802099:	e8 a7 07 00 00       	call   802845 <alloc_block_BF>
  80209e:	83 c4 10             	add    $0x10,%esp
  8020a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020a4:	eb 24                	jmp    8020ca <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8020a6:	83 ec 0c             	sub    $0xc,%esp
  8020a9:	ff 75 08             	pushl  0x8(%ebp)
  8020ac:	e8 84 19 00 00       	call   803a35 <alloc_block_WF>
  8020b1:	83 c4 10             	add    $0x10,%esp
  8020b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020b7:	eb 11                	jmp    8020ca <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8020b9:	83 ec 0c             	sub    $0xc,%esp
  8020bc:	68 a8 47 80 00       	push   $0x8047a8
  8020c1:	e8 b1 e5 ff ff       	call   800677 <cprintf>
  8020c6:	83 c4 10             	add    $0x10,%esp
		break;
  8020c9:	90                   	nop
	}
	return va;
  8020ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    

008020cf <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	53                   	push   %ebx
  8020d3:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8020d6:	83 ec 0c             	sub    $0xc,%esp
  8020d9:	68 c8 47 80 00       	push   $0x8047c8
  8020de:	e8 94 e5 ff ff       	call   800677 <cprintf>
  8020e3:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8020e6:	83 ec 0c             	sub    $0xc,%esp
  8020e9:	68 f3 47 80 00       	push   $0x8047f3
  8020ee:	e8 84 e5 ff ff       	call   800677 <cprintf>
  8020f3:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8020f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020fc:	eb 37                	jmp    802135 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8020fe:	83 ec 0c             	sub    $0xc,%esp
  802101:	ff 75 f4             	pushl  -0xc(%ebp)
  802104:	e8 19 ff ff ff       	call   802022 <is_free_block>
  802109:	83 c4 10             	add    $0x10,%esp
  80210c:	0f be d8             	movsbl %al,%ebx
  80210f:	83 ec 0c             	sub    $0xc,%esp
  802112:	ff 75 f4             	pushl  -0xc(%ebp)
  802115:	e8 ef fe ff ff       	call   802009 <get_block_size>
  80211a:	83 c4 10             	add    $0x10,%esp
  80211d:	83 ec 04             	sub    $0x4,%esp
  802120:	53                   	push   %ebx
  802121:	50                   	push   %eax
  802122:	68 0b 48 80 00       	push   $0x80480b
  802127:	e8 4b e5 ff ff       	call   800677 <cprintf>
  80212c:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80212f:	8b 45 10             	mov    0x10(%ebp),%eax
  802132:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802135:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802139:	74 07                	je     802142 <print_blocks_list+0x73>
  80213b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213e:	8b 00                	mov    (%eax),%eax
  802140:	eb 05                	jmp    802147 <print_blocks_list+0x78>
  802142:	b8 00 00 00 00       	mov    $0x0,%eax
  802147:	89 45 10             	mov    %eax,0x10(%ebp)
  80214a:	8b 45 10             	mov    0x10(%ebp),%eax
  80214d:	85 c0                	test   %eax,%eax
  80214f:	75 ad                	jne    8020fe <print_blocks_list+0x2f>
  802151:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802155:	75 a7                	jne    8020fe <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802157:	83 ec 0c             	sub    $0xc,%esp
  80215a:	68 c8 47 80 00       	push   $0x8047c8
  80215f:	e8 13 e5 ff ff       	call   800677 <cprintf>
  802164:	83 c4 10             	add    $0x10,%esp

}
  802167:	90                   	nop
  802168:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80216b:	c9                   	leave  
  80216c:	c3                   	ret    

0080216d <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80216d:	55                   	push   %ebp
  80216e:	89 e5                	mov    %esp,%ebp
  802170:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802173:	8b 45 0c             	mov    0xc(%ebp),%eax
  802176:	83 e0 01             	and    $0x1,%eax
  802179:	85 c0                	test   %eax,%eax
  80217b:	74 03                	je     802180 <initialize_dynamic_allocator+0x13>
  80217d:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802180:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802184:	0f 84 c7 01 00 00    	je     802351 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80218a:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802191:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802194:	8b 55 08             	mov    0x8(%ebp),%edx
  802197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80219a:	01 d0                	add    %edx,%eax
  80219c:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8021a1:	0f 87 ad 01 00 00    	ja     802354 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8021a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021aa:	85 c0                	test   %eax,%eax
  8021ac:	0f 89 a5 01 00 00    	jns    802357 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8021b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8021b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b8:	01 d0                	add    %edx,%eax
  8021ba:	83 e8 04             	sub    $0x4,%eax
  8021bd:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8021c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8021c9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021d1:	e9 87 00 00 00       	jmp    80225d <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8021d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021da:	75 14                	jne    8021f0 <initialize_dynamic_allocator+0x83>
  8021dc:	83 ec 04             	sub    $0x4,%esp
  8021df:	68 23 48 80 00       	push   $0x804823
  8021e4:	6a 79                	push   $0x79
  8021e6:	68 41 48 80 00       	push   $0x804841
  8021eb:	e8 ca e1 ff ff       	call   8003ba <_panic>
  8021f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f3:	8b 00                	mov    (%eax),%eax
  8021f5:	85 c0                	test   %eax,%eax
  8021f7:	74 10                	je     802209 <initialize_dynamic_allocator+0x9c>
  8021f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fc:	8b 00                	mov    (%eax),%eax
  8021fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802201:	8b 52 04             	mov    0x4(%edx),%edx
  802204:	89 50 04             	mov    %edx,0x4(%eax)
  802207:	eb 0b                	jmp    802214 <initialize_dynamic_allocator+0xa7>
  802209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220c:	8b 40 04             	mov    0x4(%eax),%eax
  80220f:	a3 30 50 80 00       	mov    %eax,0x805030
  802214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802217:	8b 40 04             	mov    0x4(%eax),%eax
  80221a:	85 c0                	test   %eax,%eax
  80221c:	74 0f                	je     80222d <initialize_dynamic_allocator+0xc0>
  80221e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802221:	8b 40 04             	mov    0x4(%eax),%eax
  802224:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802227:	8b 12                	mov    (%edx),%edx
  802229:	89 10                	mov    %edx,(%eax)
  80222b:	eb 0a                	jmp    802237 <initialize_dynamic_allocator+0xca>
  80222d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802230:	8b 00                	mov    (%eax),%eax
  802232:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802240:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802243:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80224a:	a1 38 50 80 00       	mov    0x805038,%eax
  80224f:	48                   	dec    %eax
  802250:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802255:	a1 34 50 80 00       	mov    0x805034,%eax
  80225a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80225d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802261:	74 07                	je     80226a <initialize_dynamic_allocator+0xfd>
  802263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802266:	8b 00                	mov    (%eax),%eax
  802268:	eb 05                	jmp    80226f <initialize_dynamic_allocator+0x102>
  80226a:	b8 00 00 00 00       	mov    $0x0,%eax
  80226f:	a3 34 50 80 00       	mov    %eax,0x805034
  802274:	a1 34 50 80 00       	mov    0x805034,%eax
  802279:	85 c0                	test   %eax,%eax
  80227b:	0f 85 55 ff ff ff    	jne    8021d6 <initialize_dynamic_allocator+0x69>
  802281:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802285:	0f 85 4b ff ff ff    	jne    8021d6 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80228b:	8b 45 08             	mov    0x8(%ebp),%eax
  80228e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802291:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802294:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80229a:	a1 44 50 80 00       	mov    0x805044,%eax
  80229f:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8022a4:	a1 40 50 80 00       	mov    0x805040,%eax
  8022a9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8022af:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b2:	83 c0 08             	add    $0x8,%eax
  8022b5:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8022b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bb:	83 c0 04             	add    $0x4,%eax
  8022be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c1:	83 ea 08             	sub    $0x8,%edx
  8022c4:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8022c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cc:	01 d0                	add    %edx,%eax
  8022ce:	83 e8 08             	sub    $0x8,%eax
  8022d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d4:	83 ea 08             	sub    $0x8,%edx
  8022d7:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8022d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8022e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8022ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022f0:	75 17                	jne    802309 <initialize_dynamic_allocator+0x19c>
  8022f2:	83 ec 04             	sub    $0x4,%esp
  8022f5:	68 5c 48 80 00       	push   $0x80485c
  8022fa:	68 90 00 00 00       	push   $0x90
  8022ff:	68 41 48 80 00       	push   $0x804841
  802304:	e8 b1 e0 ff ff       	call   8003ba <_panic>
  802309:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80230f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802312:	89 10                	mov    %edx,(%eax)
  802314:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802317:	8b 00                	mov    (%eax),%eax
  802319:	85 c0                	test   %eax,%eax
  80231b:	74 0d                	je     80232a <initialize_dynamic_allocator+0x1bd>
  80231d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802322:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802325:	89 50 04             	mov    %edx,0x4(%eax)
  802328:	eb 08                	jmp    802332 <initialize_dynamic_allocator+0x1c5>
  80232a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80232d:	a3 30 50 80 00       	mov    %eax,0x805030
  802332:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802335:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80233a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80233d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802344:	a1 38 50 80 00       	mov    0x805038,%eax
  802349:	40                   	inc    %eax
  80234a:	a3 38 50 80 00       	mov    %eax,0x805038
  80234f:	eb 07                	jmp    802358 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802351:	90                   	nop
  802352:	eb 04                	jmp    802358 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802354:	90                   	nop
  802355:	eb 01                	jmp    802358 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802357:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802358:	c9                   	leave  
  802359:	c3                   	ret    

0080235a <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80235a:	55                   	push   %ebp
  80235b:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80235d:	8b 45 10             	mov    0x10(%ebp),%eax
  802360:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802363:	8b 45 08             	mov    0x8(%ebp),%eax
  802366:	8d 50 fc             	lea    -0x4(%eax),%edx
  802369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80236c:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	83 e8 04             	sub    $0x4,%eax
  802374:	8b 00                	mov    (%eax),%eax
  802376:	83 e0 fe             	and    $0xfffffffe,%eax
  802379:	8d 50 f8             	lea    -0x8(%eax),%edx
  80237c:	8b 45 08             	mov    0x8(%ebp),%eax
  80237f:	01 c2                	add    %eax,%edx
  802381:	8b 45 0c             	mov    0xc(%ebp),%eax
  802384:	89 02                	mov    %eax,(%edx)
}
  802386:	90                   	nop
  802387:	5d                   	pop    %ebp
  802388:	c3                   	ret    

00802389 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802389:	55                   	push   %ebp
  80238a:	89 e5                	mov    %esp,%ebp
  80238c:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80238f:	8b 45 08             	mov    0x8(%ebp),%eax
  802392:	83 e0 01             	and    $0x1,%eax
  802395:	85 c0                	test   %eax,%eax
  802397:	74 03                	je     80239c <alloc_block_FF+0x13>
  802399:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80239c:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8023a0:	77 07                	ja     8023a9 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8023a2:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8023a9:	a1 24 50 80 00       	mov    0x805024,%eax
  8023ae:	85 c0                	test   %eax,%eax
  8023b0:	75 73                	jne    802425 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8023b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b5:	83 c0 10             	add    $0x10,%eax
  8023b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8023bb:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8023c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c8:	01 d0                	add    %edx,%eax
  8023ca:	48                   	dec    %eax
  8023cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8023ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8023d6:	f7 75 ec             	divl   -0x14(%ebp)
  8023d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023dc:	29 d0                	sub    %edx,%eax
  8023de:	c1 e8 0c             	shr    $0xc,%eax
  8023e1:	83 ec 0c             	sub    $0xc,%esp
  8023e4:	50                   	push   %eax
  8023e5:	e8 27 f0 ff ff       	call   801411 <sbrk>
  8023ea:	83 c4 10             	add    $0x10,%esp
  8023ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8023f0:	83 ec 0c             	sub    $0xc,%esp
  8023f3:	6a 00                	push   $0x0
  8023f5:	e8 17 f0 ff ff       	call   801411 <sbrk>
  8023fa:	83 c4 10             	add    $0x10,%esp
  8023fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802400:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802403:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802406:	83 ec 08             	sub    $0x8,%esp
  802409:	50                   	push   %eax
  80240a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80240d:	e8 5b fd ff ff       	call   80216d <initialize_dynamic_allocator>
  802412:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802415:	83 ec 0c             	sub    $0xc,%esp
  802418:	68 7f 48 80 00       	push   $0x80487f
  80241d:	e8 55 e2 ff ff       	call   800677 <cprintf>
  802422:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802425:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802429:	75 0a                	jne    802435 <alloc_block_FF+0xac>
	        return NULL;
  80242b:	b8 00 00 00 00       	mov    $0x0,%eax
  802430:	e9 0e 04 00 00       	jmp    802843 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802435:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80243c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802441:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802444:	e9 f3 02 00 00       	jmp    80273c <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80244f:	83 ec 0c             	sub    $0xc,%esp
  802452:	ff 75 bc             	pushl  -0x44(%ebp)
  802455:	e8 af fb ff ff       	call   802009 <get_block_size>
  80245a:	83 c4 10             	add    $0x10,%esp
  80245d:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802460:	8b 45 08             	mov    0x8(%ebp),%eax
  802463:	83 c0 08             	add    $0x8,%eax
  802466:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802469:	0f 87 c5 02 00 00    	ja     802734 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80246f:	8b 45 08             	mov    0x8(%ebp),%eax
  802472:	83 c0 18             	add    $0x18,%eax
  802475:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802478:	0f 87 19 02 00 00    	ja     802697 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80247e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802481:	2b 45 08             	sub    0x8(%ebp),%eax
  802484:	83 e8 08             	sub    $0x8,%eax
  802487:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80248a:	8b 45 08             	mov    0x8(%ebp),%eax
  80248d:	8d 50 08             	lea    0x8(%eax),%edx
  802490:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802493:	01 d0                	add    %edx,%eax
  802495:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802498:	8b 45 08             	mov    0x8(%ebp),%eax
  80249b:	83 c0 08             	add    $0x8,%eax
  80249e:	83 ec 04             	sub    $0x4,%esp
  8024a1:	6a 01                	push   $0x1
  8024a3:	50                   	push   %eax
  8024a4:	ff 75 bc             	pushl  -0x44(%ebp)
  8024a7:	e8 ae fe ff ff       	call   80235a <set_block_data>
  8024ac:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	8b 40 04             	mov    0x4(%eax),%eax
  8024b5:	85 c0                	test   %eax,%eax
  8024b7:	75 68                	jne    802521 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8024b9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024bd:	75 17                	jne    8024d6 <alloc_block_FF+0x14d>
  8024bf:	83 ec 04             	sub    $0x4,%esp
  8024c2:	68 5c 48 80 00       	push   $0x80485c
  8024c7:	68 d7 00 00 00       	push   $0xd7
  8024cc:	68 41 48 80 00       	push   $0x804841
  8024d1:	e8 e4 de ff ff       	call   8003ba <_panic>
  8024d6:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8024dc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024df:	89 10                	mov    %edx,(%eax)
  8024e1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024e4:	8b 00                	mov    (%eax),%eax
  8024e6:	85 c0                	test   %eax,%eax
  8024e8:	74 0d                	je     8024f7 <alloc_block_FF+0x16e>
  8024ea:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8024ef:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024f2:	89 50 04             	mov    %edx,0x4(%eax)
  8024f5:	eb 08                	jmp    8024ff <alloc_block_FF+0x176>
  8024f7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024fa:	a3 30 50 80 00       	mov    %eax,0x805030
  8024ff:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802502:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802507:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80250a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802511:	a1 38 50 80 00       	mov    0x805038,%eax
  802516:	40                   	inc    %eax
  802517:	a3 38 50 80 00       	mov    %eax,0x805038
  80251c:	e9 dc 00 00 00       	jmp    8025fd <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802524:	8b 00                	mov    (%eax),%eax
  802526:	85 c0                	test   %eax,%eax
  802528:	75 65                	jne    80258f <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80252a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80252e:	75 17                	jne    802547 <alloc_block_FF+0x1be>
  802530:	83 ec 04             	sub    $0x4,%esp
  802533:	68 90 48 80 00       	push   $0x804890
  802538:	68 db 00 00 00       	push   $0xdb
  80253d:	68 41 48 80 00       	push   $0x804841
  802542:	e8 73 de ff ff       	call   8003ba <_panic>
  802547:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80254d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802550:	89 50 04             	mov    %edx,0x4(%eax)
  802553:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802556:	8b 40 04             	mov    0x4(%eax),%eax
  802559:	85 c0                	test   %eax,%eax
  80255b:	74 0c                	je     802569 <alloc_block_FF+0x1e0>
  80255d:	a1 30 50 80 00       	mov    0x805030,%eax
  802562:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802565:	89 10                	mov    %edx,(%eax)
  802567:	eb 08                	jmp    802571 <alloc_block_FF+0x1e8>
  802569:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80256c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802571:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802574:	a3 30 50 80 00       	mov    %eax,0x805030
  802579:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80257c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802582:	a1 38 50 80 00       	mov    0x805038,%eax
  802587:	40                   	inc    %eax
  802588:	a3 38 50 80 00       	mov    %eax,0x805038
  80258d:	eb 6e                	jmp    8025fd <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80258f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802593:	74 06                	je     80259b <alloc_block_FF+0x212>
  802595:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802599:	75 17                	jne    8025b2 <alloc_block_FF+0x229>
  80259b:	83 ec 04             	sub    $0x4,%esp
  80259e:	68 b4 48 80 00       	push   $0x8048b4
  8025a3:	68 df 00 00 00       	push   $0xdf
  8025a8:	68 41 48 80 00       	push   $0x804841
  8025ad:	e8 08 de ff ff       	call   8003ba <_panic>
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	8b 10                	mov    (%eax),%edx
  8025b7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025ba:	89 10                	mov    %edx,(%eax)
  8025bc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025bf:	8b 00                	mov    (%eax),%eax
  8025c1:	85 c0                	test   %eax,%eax
  8025c3:	74 0b                	je     8025d0 <alloc_block_FF+0x247>
  8025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c8:	8b 00                	mov    (%eax),%eax
  8025ca:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025cd:	89 50 04             	mov    %edx,0x4(%eax)
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025d6:	89 10                	mov    %edx,(%eax)
  8025d8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025de:	89 50 04             	mov    %edx,0x4(%eax)
  8025e1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025e4:	8b 00                	mov    (%eax),%eax
  8025e6:	85 c0                	test   %eax,%eax
  8025e8:	75 08                	jne    8025f2 <alloc_block_FF+0x269>
  8025ea:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025ed:	a3 30 50 80 00       	mov    %eax,0x805030
  8025f2:	a1 38 50 80 00       	mov    0x805038,%eax
  8025f7:	40                   	inc    %eax
  8025f8:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8025fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802601:	75 17                	jne    80261a <alloc_block_FF+0x291>
  802603:	83 ec 04             	sub    $0x4,%esp
  802606:	68 23 48 80 00       	push   $0x804823
  80260b:	68 e1 00 00 00       	push   $0xe1
  802610:	68 41 48 80 00       	push   $0x804841
  802615:	e8 a0 dd ff ff       	call   8003ba <_panic>
  80261a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261d:	8b 00                	mov    (%eax),%eax
  80261f:	85 c0                	test   %eax,%eax
  802621:	74 10                	je     802633 <alloc_block_FF+0x2aa>
  802623:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802626:	8b 00                	mov    (%eax),%eax
  802628:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262b:	8b 52 04             	mov    0x4(%edx),%edx
  80262e:	89 50 04             	mov    %edx,0x4(%eax)
  802631:	eb 0b                	jmp    80263e <alloc_block_FF+0x2b5>
  802633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802636:	8b 40 04             	mov    0x4(%eax),%eax
  802639:	a3 30 50 80 00       	mov    %eax,0x805030
  80263e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802641:	8b 40 04             	mov    0x4(%eax),%eax
  802644:	85 c0                	test   %eax,%eax
  802646:	74 0f                	je     802657 <alloc_block_FF+0x2ce>
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	8b 40 04             	mov    0x4(%eax),%eax
  80264e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802651:	8b 12                	mov    (%edx),%edx
  802653:	89 10                	mov    %edx,(%eax)
  802655:	eb 0a                	jmp    802661 <alloc_block_FF+0x2d8>
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	8b 00                	mov    (%eax),%eax
  80265c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80266a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802674:	a1 38 50 80 00       	mov    0x805038,%eax
  802679:	48                   	dec    %eax
  80267a:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80267f:	83 ec 04             	sub    $0x4,%esp
  802682:	6a 00                	push   $0x0
  802684:	ff 75 b4             	pushl  -0x4c(%ebp)
  802687:	ff 75 b0             	pushl  -0x50(%ebp)
  80268a:	e8 cb fc ff ff       	call   80235a <set_block_data>
  80268f:	83 c4 10             	add    $0x10,%esp
  802692:	e9 95 00 00 00       	jmp    80272c <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802697:	83 ec 04             	sub    $0x4,%esp
  80269a:	6a 01                	push   $0x1
  80269c:	ff 75 b8             	pushl  -0x48(%ebp)
  80269f:	ff 75 bc             	pushl  -0x44(%ebp)
  8026a2:	e8 b3 fc ff ff       	call   80235a <set_block_data>
  8026a7:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8026aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ae:	75 17                	jne    8026c7 <alloc_block_FF+0x33e>
  8026b0:	83 ec 04             	sub    $0x4,%esp
  8026b3:	68 23 48 80 00       	push   $0x804823
  8026b8:	68 e8 00 00 00       	push   $0xe8
  8026bd:	68 41 48 80 00       	push   $0x804841
  8026c2:	e8 f3 dc ff ff       	call   8003ba <_panic>
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	8b 00                	mov    (%eax),%eax
  8026cc:	85 c0                	test   %eax,%eax
  8026ce:	74 10                	je     8026e0 <alloc_block_FF+0x357>
  8026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d3:	8b 00                	mov    (%eax),%eax
  8026d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d8:	8b 52 04             	mov    0x4(%edx),%edx
  8026db:	89 50 04             	mov    %edx,0x4(%eax)
  8026de:	eb 0b                	jmp    8026eb <alloc_block_FF+0x362>
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	8b 40 04             	mov    0x4(%eax),%eax
  8026e6:	a3 30 50 80 00       	mov    %eax,0x805030
  8026eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ee:	8b 40 04             	mov    0x4(%eax),%eax
  8026f1:	85 c0                	test   %eax,%eax
  8026f3:	74 0f                	je     802704 <alloc_block_FF+0x37b>
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	8b 40 04             	mov    0x4(%eax),%eax
  8026fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026fe:	8b 12                	mov    (%edx),%edx
  802700:	89 10                	mov    %edx,(%eax)
  802702:	eb 0a                	jmp    80270e <alloc_block_FF+0x385>
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 00                	mov    (%eax),%eax
  802709:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80270e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802711:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802721:	a1 38 50 80 00       	mov    0x805038,%eax
  802726:	48                   	dec    %eax
  802727:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80272c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80272f:	e9 0f 01 00 00       	jmp    802843 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802734:	a1 34 50 80 00       	mov    0x805034,%eax
  802739:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80273c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802740:	74 07                	je     802749 <alloc_block_FF+0x3c0>
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	8b 00                	mov    (%eax),%eax
  802747:	eb 05                	jmp    80274e <alloc_block_FF+0x3c5>
  802749:	b8 00 00 00 00       	mov    $0x0,%eax
  80274e:	a3 34 50 80 00       	mov    %eax,0x805034
  802753:	a1 34 50 80 00       	mov    0x805034,%eax
  802758:	85 c0                	test   %eax,%eax
  80275a:	0f 85 e9 fc ff ff    	jne    802449 <alloc_block_FF+0xc0>
  802760:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802764:	0f 85 df fc ff ff    	jne    802449 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80276a:	8b 45 08             	mov    0x8(%ebp),%eax
  80276d:	83 c0 08             	add    $0x8,%eax
  802770:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802773:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80277a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80277d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802780:	01 d0                	add    %edx,%eax
  802782:	48                   	dec    %eax
  802783:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802786:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802789:	ba 00 00 00 00       	mov    $0x0,%edx
  80278e:	f7 75 d8             	divl   -0x28(%ebp)
  802791:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802794:	29 d0                	sub    %edx,%eax
  802796:	c1 e8 0c             	shr    $0xc,%eax
  802799:	83 ec 0c             	sub    $0xc,%esp
  80279c:	50                   	push   %eax
  80279d:	e8 6f ec ff ff       	call   801411 <sbrk>
  8027a2:	83 c4 10             	add    $0x10,%esp
  8027a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8027a8:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8027ac:	75 0a                	jne    8027b8 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8027ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b3:	e9 8b 00 00 00       	jmp    802843 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8027b8:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8027bf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027c5:	01 d0                	add    %edx,%eax
  8027c7:	48                   	dec    %eax
  8027c8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8027cb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8027ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8027d3:	f7 75 cc             	divl   -0x34(%ebp)
  8027d6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8027d9:	29 d0                	sub    %edx,%eax
  8027db:	8d 50 fc             	lea    -0x4(%eax),%edx
  8027de:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027e1:	01 d0                	add    %edx,%eax
  8027e3:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8027e8:	a1 40 50 80 00       	mov    0x805040,%eax
  8027ed:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8027f3:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8027fa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027fd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802800:	01 d0                	add    %edx,%eax
  802802:	48                   	dec    %eax
  802803:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802806:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802809:	ba 00 00 00 00       	mov    $0x0,%edx
  80280e:	f7 75 c4             	divl   -0x3c(%ebp)
  802811:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802814:	29 d0                	sub    %edx,%eax
  802816:	83 ec 04             	sub    $0x4,%esp
  802819:	6a 01                	push   $0x1
  80281b:	50                   	push   %eax
  80281c:	ff 75 d0             	pushl  -0x30(%ebp)
  80281f:	e8 36 fb ff ff       	call   80235a <set_block_data>
  802824:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802827:	83 ec 0c             	sub    $0xc,%esp
  80282a:	ff 75 d0             	pushl  -0x30(%ebp)
  80282d:	e8 f8 09 00 00       	call   80322a <free_block>
  802832:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802835:	83 ec 0c             	sub    $0xc,%esp
  802838:	ff 75 08             	pushl  0x8(%ebp)
  80283b:	e8 49 fb ff ff       	call   802389 <alloc_block_FF>
  802840:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802843:	c9                   	leave  
  802844:	c3                   	ret    

00802845 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802845:	55                   	push   %ebp
  802846:	89 e5                	mov    %esp,%ebp
  802848:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80284b:	8b 45 08             	mov    0x8(%ebp),%eax
  80284e:	83 e0 01             	and    $0x1,%eax
  802851:	85 c0                	test   %eax,%eax
  802853:	74 03                	je     802858 <alloc_block_BF+0x13>
  802855:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802858:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80285c:	77 07                	ja     802865 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80285e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802865:	a1 24 50 80 00       	mov    0x805024,%eax
  80286a:	85 c0                	test   %eax,%eax
  80286c:	75 73                	jne    8028e1 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80286e:	8b 45 08             	mov    0x8(%ebp),%eax
  802871:	83 c0 10             	add    $0x10,%eax
  802874:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802877:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80287e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802881:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802884:	01 d0                	add    %edx,%eax
  802886:	48                   	dec    %eax
  802887:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80288a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80288d:	ba 00 00 00 00       	mov    $0x0,%edx
  802892:	f7 75 e0             	divl   -0x20(%ebp)
  802895:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802898:	29 d0                	sub    %edx,%eax
  80289a:	c1 e8 0c             	shr    $0xc,%eax
  80289d:	83 ec 0c             	sub    $0xc,%esp
  8028a0:	50                   	push   %eax
  8028a1:	e8 6b eb ff ff       	call   801411 <sbrk>
  8028a6:	83 c4 10             	add    $0x10,%esp
  8028a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8028ac:	83 ec 0c             	sub    $0xc,%esp
  8028af:	6a 00                	push   $0x0
  8028b1:	e8 5b eb ff ff       	call   801411 <sbrk>
  8028b6:	83 c4 10             	add    $0x10,%esp
  8028b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8028bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028bf:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8028c2:	83 ec 08             	sub    $0x8,%esp
  8028c5:	50                   	push   %eax
  8028c6:	ff 75 d8             	pushl  -0x28(%ebp)
  8028c9:	e8 9f f8 ff ff       	call   80216d <initialize_dynamic_allocator>
  8028ce:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8028d1:	83 ec 0c             	sub    $0xc,%esp
  8028d4:	68 7f 48 80 00       	push   $0x80487f
  8028d9:	e8 99 dd ff ff       	call   800677 <cprintf>
  8028de:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8028e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8028e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8028ef:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8028f6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8028fd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802902:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802905:	e9 1d 01 00 00       	jmp    802a27 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802910:	83 ec 0c             	sub    $0xc,%esp
  802913:	ff 75 a8             	pushl  -0x58(%ebp)
  802916:	e8 ee f6 ff ff       	call   802009 <get_block_size>
  80291b:	83 c4 10             	add    $0x10,%esp
  80291e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802921:	8b 45 08             	mov    0x8(%ebp),%eax
  802924:	83 c0 08             	add    $0x8,%eax
  802927:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80292a:	0f 87 ef 00 00 00    	ja     802a1f <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802930:	8b 45 08             	mov    0x8(%ebp),%eax
  802933:	83 c0 18             	add    $0x18,%eax
  802936:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802939:	77 1d                	ja     802958 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80293b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802941:	0f 86 d8 00 00 00    	jbe    802a1f <alloc_block_BF+0x1da>
				{
					best_va = va;
  802947:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80294a:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80294d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802950:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802953:	e9 c7 00 00 00       	jmp    802a1f <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802958:	8b 45 08             	mov    0x8(%ebp),%eax
  80295b:	83 c0 08             	add    $0x8,%eax
  80295e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802961:	0f 85 9d 00 00 00    	jne    802a04 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802967:	83 ec 04             	sub    $0x4,%esp
  80296a:	6a 01                	push   $0x1
  80296c:	ff 75 a4             	pushl  -0x5c(%ebp)
  80296f:	ff 75 a8             	pushl  -0x58(%ebp)
  802972:	e8 e3 f9 ff ff       	call   80235a <set_block_data>
  802977:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80297a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297e:	75 17                	jne    802997 <alloc_block_BF+0x152>
  802980:	83 ec 04             	sub    $0x4,%esp
  802983:	68 23 48 80 00       	push   $0x804823
  802988:	68 2c 01 00 00       	push   $0x12c
  80298d:	68 41 48 80 00       	push   $0x804841
  802992:	e8 23 da ff ff       	call   8003ba <_panic>
  802997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299a:	8b 00                	mov    (%eax),%eax
  80299c:	85 c0                	test   %eax,%eax
  80299e:	74 10                	je     8029b0 <alloc_block_BF+0x16b>
  8029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a3:	8b 00                	mov    (%eax),%eax
  8029a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a8:	8b 52 04             	mov    0x4(%edx),%edx
  8029ab:	89 50 04             	mov    %edx,0x4(%eax)
  8029ae:	eb 0b                	jmp    8029bb <alloc_block_BF+0x176>
  8029b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b3:	8b 40 04             	mov    0x4(%eax),%eax
  8029b6:	a3 30 50 80 00       	mov    %eax,0x805030
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	8b 40 04             	mov    0x4(%eax),%eax
  8029c1:	85 c0                	test   %eax,%eax
  8029c3:	74 0f                	je     8029d4 <alloc_block_BF+0x18f>
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	8b 40 04             	mov    0x4(%eax),%eax
  8029cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ce:	8b 12                	mov    (%edx),%edx
  8029d0:	89 10                	mov    %edx,(%eax)
  8029d2:	eb 0a                	jmp    8029de <alloc_block_BF+0x199>
  8029d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d7:	8b 00                	mov    (%eax),%eax
  8029d9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f1:	a1 38 50 80 00       	mov    0x805038,%eax
  8029f6:	48                   	dec    %eax
  8029f7:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8029fc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029ff:	e9 01 04 00 00       	jmp    802e05 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802a04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a07:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a0a:	76 13                	jbe    802a1f <alloc_block_BF+0x1da>
					{
						internal = 1;
  802a0c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802a13:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a16:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802a19:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a1c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802a1f:	a1 34 50 80 00       	mov    0x805034,%eax
  802a24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a2b:	74 07                	je     802a34 <alloc_block_BF+0x1ef>
  802a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a30:	8b 00                	mov    (%eax),%eax
  802a32:	eb 05                	jmp    802a39 <alloc_block_BF+0x1f4>
  802a34:	b8 00 00 00 00       	mov    $0x0,%eax
  802a39:	a3 34 50 80 00       	mov    %eax,0x805034
  802a3e:	a1 34 50 80 00       	mov    0x805034,%eax
  802a43:	85 c0                	test   %eax,%eax
  802a45:	0f 85 bf fe ff ff    	jne    80290a <alloc_block_BF+0xc5>
  802a4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4f:	0f 85 b5 fe ff ff    	jne    80290a <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802a55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a59:	0f 84 26 02 00 00    	je     802c85 <alloc_block_BF+0x440>
  802a5f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a63:	0f 85 1c 02 00 00    	jne    802c85 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802a69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6c:	2b 45 08             	sub    0x8(%ebp),%eax
  802a6f:	83 e8 08             	sub    $0x8,%eax
  802a72:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802a75:	8b 45 08             	mov    0x8(%ebp),%eax
  802a78:	8d 50 08             	lea    0x8(%eax),%edx
  802a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7e:	01 d0                	add    %edx,%eax
  802a80:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802a83:	8b 45 08             	mov    0x8(%ebp),%eax
  802a86:	83 c0 08             	add    $0x8,%eax
  802a89:	83 ec 04             	sub    $0x4,%esp
  802a8c:	6a 01                	push   $0x1
  802a8e:	50                   	push   %eax
  802a8f:	ff 75 f0             	pushl  -0x10(%ebp)
  802a92:	e8 c3 f8 ff ff       	call   80235a <set_block_data>
  802a97:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9d:	8b 40 04             	mov    0x4(%eax),%eax
  802aa0:	85 c0                	test   %eax,%eax
  802aa2:	75 68                	jne    802b0c <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802aa4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802aa8:	75 17                	jne    802ac1 <alloc_block_BF+0x27c>
  802aaa:	83 ec 04             	sub    $0x4,%esp
  802aad:	68 5c 48 80 00       	push   $0x80485c
  802ab2:	68 45 01 00 00       	push   $0x145
  802ab7:	68 41 48 80 00       	push   $0x804841
  802abc:	e8 f9 d8 ff ff       	call   8003ba <_panic>
  802ac1:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802ac7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aca:	89 10                	mov    %edx,(%eax)
  802acc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802acf:	8b 00                	mov    (%eax),%eax
  802ad1:	85 c0                	test   %eax,%eax
  802ad3:	74 0d                	je     802ae2 <alloc_block_BF+0x29d>
  802ad5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ada:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802add:	89 50 04             	mov    %edx,0x4(%eax)
  802ae0:	eb 08                	jmp    802aea <alloc_block_BF+0x2a5>
  802ae2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae5:	a3 30 50 80 00       	mov    %eax,0x805030
  802aea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aed:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802af2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802af5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802afc:	a1 38 50 80 00       	mov    0x805038,%eax
  802b01:	40                   	inc    %eax
  802b02:	a3 38 50 80 00       	mov    %eax,0x805038
  802b07:	e9 dc 00 00 00       	jmp    802be8 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0f:	8b 00                	mov    (%eax),%eax
  802b11:	85 c0                	test   %eax,%eax
  802b13:	75 65                	jne    802b7a <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b15:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b19:	75 17                	jne    802b32 <alloc_block_BF+0x2ed>
  802b1b:	83 ec 04             	sub    $0x4,%esp
  802b1e:	68 90 48 80 00       	push   $0x804890
  802b23:	68 4a 01 00 00       	push   $0x14a
  802b28:	68 41 48 80 00       	push   $0x804841
  802b2d:	e8 88 d8 ff ff       	call   8003ba <_panic>
  802b32:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802b38:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b3b:	89 50 04             	mov    %edx,0x4(%eax)
  802b3e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b41:	8b 40 04             	mov    0x4(%eax),%eax
  802b44:	85 c0                	test   %eax,%eax
  802b46:	74 0c                	je     802b54 <alloc_block_BF+0x30f>
  802b48:	a1 30 50 80 00       	mov    0x805030,%eax
  802b4d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b50:	89 10                	mov    %edx,(%eax)
  802b52:	eb 08                	jmp    802b5c <alloc_block_BF+0x317>
  802b54:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b57:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b5c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b5f:	a3 30 50 80 00       	mov    %eax,0x805030
  802b64:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b6d:	a1 38 50 80 00       	mov    0x805038,%eax
  802b72:	40                   	inc    %eax
  802b73:	a3 38 50 80 00       	mov    %eax,0x805038
  802b78:	eb 6e                	jmp    802be8 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802b7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b7e:	74 06                	je     802b86 <alloc_block_BF+0x341>
  802b80:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b84:	75 17                	jne    802b9d <alloc_block_BF+0x358>
  802b86:	83 ec 04             	sub    $0x4,%esp
  802b89:	68 b4 48 80 00       	push   $0x8048b4
  802b8e:	68 4f 01 00 00       	push   $0x14f
  802b93:	68 41 48 80 00       	push   $0x804841
  802b98:	e8 1d d8 ff ff       	call   8003ba <_panic>
  802b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba0:	8b 10                	mov    (%eax),%edx
  802ba2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ba5:	89 10                	mov    %edx,(%eax)
  802ba7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802baa:	8b 00                	mov    (%eax),%eax
  802bac:	85 c0                	test   %eax,%eax
  802bae:	74 0b                	je     802bbb <alloc_block_BF+0x376>
  802bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb3:	8b 00                	mov    (%eax),%eax
  802bb5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bb8:	89 50 04             	mov    %edx,0x4(%eax)
  802bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbe:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bc1:	89 10                	mov    %edx,(%eax)
  802bc3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bc6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bc9:	89 50 04             	mov    %edx,0x4(%eax)
  802bcc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bcf:	8b 00                	mov    (%eax),%eax
  802bd1:	85 c0                	test   %eax,%eax
  802bd3:	75 08                	jne    802bdd <alloc_block_BF+0x398>
  802bd5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bd8:	a3 30 50 80 00       	mov    %eax,0x805030
  802bdd:	a1 38 50 80 00       	mov    0x805038,%eax
  802be2:	40                   	inc    %eax
  802be3:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802be8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bec:	75 17                	jne    802c05 <alloc_block_BF+0x3c0>
  802bee:	83 ec 04             	sub    $0x4,%esp
  802bf1:	68 23 48 80 00       	push   $0x804823
  802bf6:	68 51 01 00 00       	push   $0x151
  802bfb:	68 41 48 80 00       	push   $0x804841
  802c00:	e8 b5 d7 ff ff       	call   8003ba <_panic>
  802c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c08:	8b 00                	mov    (%eax),%eax
  802c0a:	85 c0                	test   %eax,%eax
  802c0c:	74 10                	je     802c1e <alloc_block_BF+0x3d9>
  802c0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c11:	8b 00                	mov    (%eax),%eax
  802c13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c16:	8b 52 04             	mov    0x4(%edx),%edx
  802c19:	89 50 04             	mov    %edx,0x4(%eax)
  802c1c:	eb 0b                	jmp    802c29 <alloc_block_BF+0x3e4>
  802c1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c21:	8b 40 04             	mov    0x4(%eax),%eax
  802c24:	a3 30 50 80 00       	mov    %eax,0x805030
  802c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2c:	8b 40 04             	mov    0x4(%eax),%eax
  802c2f:	85 c0                	test   %eax,%eax
  802c31:	74 0f                	je     802c42 <alloc_block_BF+0x3fd>
  802c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c36:	8b 40 04             	mov    0x4(%eax),%eax
  802c39:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c3c:	8b 12                	mov    (%edx),%edx
  802c3e:	89 10                	mov    %edx,(%eax)
  802c40:	eb 0a                	jmp    802c4c <alloc_block_BF+0x407>
  802c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c45:	8b 00                	mov    (%eax),%eax
  802c47:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c5f:	a1 38 50 80 00       	mov    0x805038,%eax
  802c64:	48                   	dec    %eax
  802c65:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802c6a:	83 ec 04             	sub    $0x4,%esp
  802c6d:	6a 00                	push   $0x0
  802c6f:	ff 75 d0             	pushl  -0x30(%ebp)
  802c72:	ff 75 cc             	pushl  -0x34(%ebp)
  802c75:	e8 e0 f6 ff ff       	call   80235a <set_block_data>
  802c7a:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c80:	e9 80 01 00 00       	jmp    802e05 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802c85:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802c89:	0f 85 9d 00 00 00    	jne    802d2c <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802c8f:	83 ec 04             	sub    $0x4,%esp
  802c92:	6a 01                	push   $0x1
  802c94:	ff 75 ec             	pushl  -0x14(%ebp)
  802c97:	ff 75 f0             	pushl  -0x10(%ebp)
  802c9a:	e8 bb f6 ff ff       	call   80235a <set_block_data>
  802c9f:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802ca2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ca6:	75 17                	jne    802cbf <alloc_block_BF+0x47a>
  802ca8:	83 ec 04             	sub    $0x4,%esp
  802cab:	68 23 48 80 00       	push   $0x804823
  802cb0:	68 58 01 00 00       	push   $0x158
  802cb5:	68 41 48 80 00       	push   $0x804841
  802cba:	e8 fb d6 ff ff       	call   8003ba <_panic>
  802cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc2:	8b 00                	mov    (%eax),%eax
  802cc4:	85 c0                	test   %eax,%eax
  802cc6:	74 10                	je     802cd8 <alloc_block_BF+0x493>
  802cc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccb:	8b 00                	mov    (%eax),%eax
  802ccd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cd0:	8b 52 04             	mov    0x4(%edx),%edx
  802cd3:	89 50 04             	mov    %edx,0x4(%eax)
  802cd6:	eb 0b                	jmp    802ce3 <alloc_block_BF+0x49e>
  802cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdb:	8b 40 04             	mov    0x4(%eax),%eax
  802cde:	a3 30 50 80 00       	mov    %eax,0x805030
  802ce3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce6:	8b 40 04             	mov    0x4(%eax),%eax
  802ce9:	85 c0                	test   %eax,%eax
  802ceb:	74 0f                	je     802cfc <alloc_block_BF+0x4b7>
  802ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf0:	8b 40 04             	mov    0x4(%eax),%eax
  802cf3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cf6:	8b 12                	mov    (%edx),%edx
  802cf8:	89 10                	mov    %edx,(%eax)
  802cfa:	eb 0a                	jmp    802d06 <alloc_block_BF+0x4c1>
  802cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cff:	8b 00                	mov    (%eax),%eax
  802d01:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d19:	a1 38 50 80 00       	mov    0x805038,%eax
  802d1e:	48                   	dec    %eax
  802d1f:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d27:	e9 d9 00 00 00       	jmp    802e05 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2f:	83 c0 08             	add    $0x8,%eax
  802d32:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802d35:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d3c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d3f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d42:	01 d0                	add    %edx,%eax
  802d44:	48                   	dec    %eax
  802d45:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d48:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d4b:	ba 00 00 00 00       	mov    $0x0,%edx
  802d50:	f7 75 c4             	divl   -0x3c(%ebp)
  802d53:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d56:	29 d0                	sub    %edx,%eax
  802d58:	c1 e8 0c             	shr    $0xc,%eax
  802d5b:	83 ec 0c             	sub    $0xc,%esp
  802d5e:	50                   	push   %eax
  802d5f:	e8 ad e6 ff ff       	call   801411 <sbrk>
  802d64:	83 c4 10             	add    $0x10,%esp
  802d67:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802d6a:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802d6e:	75 0a                	jne    802d7a <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802d70:	b8 00 00 00 00       	mov    $0x0,%eax
  802d75:	e9 8b 00 00 00       	jmp    802e05 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d7a:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802d81:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d84:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802d87:	01 d0                	add    %edx,%eax
  802d89:	48                   	dec    %eax
  802d8a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802d8d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d90:	ba 00 00 00 00       	mov    $0x0,%edx
  802d95:	f7 75 b8             	divl   -0x48(%ebp)
  802d98:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d9b:	29 d0                	sub    %edx,%eax
  802d9d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802da0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802da3:	01 d0                	add    %edx,%eax
  802da5:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802daa:	a1 40 50 80 00       	mov    0x805040,%eax
  802daf:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802db5:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802dbc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802dbf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dc2:	01 d0                	add    %edx,%eax
  802dc4:	48                   	dec    %eax
  802dc5:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802dc8:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802dcb:	ba 00 00 00 00       	mov    $0x0,%edx
  802dd0:	f7 75 b0             	divl   -0x50(%ebp)
  802dd3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802dd6:	29 d0                	sub    %edx,%eax
  802dd8:	83 ec 04             	sub    $0x4,%esp
  802ddb:	6a 01                	push   $0x1
  802ddd:	50                   	push   %eax
  802dde:	ff 75 bc             	pushl  -0x44(%ebp)
  802de1:	e8 74 f5 ff ff       	call   80235a <set_block_data>
  802de6:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802de9:	83 ec 0c             	sub    $0xc,%esp
  802dec:	ff 75 bc             	pushl  -0x44(%ebp)
  802def:	e8 36 04 00 00       	call   80322a <free_block>
  802df4:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802df7:	83 ec 0c             	sub    $0xc,%esp
  802dfa:	ff 75 08             	pushl  0x8(%ebp)
  802dfd:	e8 43 fa ff ff       	call   802845 <alloc_block_BF>
  802e02:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802e05:	c9                   	leave  
  802e06:	c3                   	ret    

00802e07 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802e07:	55                   	push   %ebp
  802e08:	89 e5                	mov    %esp,%ebp
  802e0a:	53                   	push   %ebx
  802e0b:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802e0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802e15:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802e1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e20:	74 1e                	je     802e40 <merging+0x39>
  802e22:	ff 75 08             	pushl  0x8(%ebp)
  802e25:	e8 df f1 ff ff       	call   802009 <get_block_size>
  802e2a:	83 c4 04             	add    $0x4,%esp
  802e2d:	89 c2                	mov    %eax,%edx
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	01 d0                	add    %edx,%eax
  802e34:	3b 45 10             	cmp    0x10(%ebp),%eax
  802e37:	75 07                	jne    802e40 <merging+0x39>
		prev_is_free = 1;
  802e39:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802e40:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e44:	74 1e                	je     802e64 <merging+0x5d>
  802e46:	ff 75 10             	pushl  0x10(%ebp)
  802e49:	e8 bb f1 ff ff       	call   802009 <get_block_size>
  802e4e:	83 c4 04             	add    $0x4,%esp
  802e51:	89 c2                	mov    %eax,%edx
  802e53:	8b 45 10             	mov    0x10(%ebp),%eax
  802e56:	01 d0                	add    %edx,%eax
  802e58:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e5b:	75 07                	jne    802e64 <merging+0x5d>
		next_is_free = 1;
  802e5d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802e64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e68:	0f 84 cc 00 00 00    	je     802f3a <merging+0x133>
  802e6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e72:	0f 84 c2 00 00 00    	je     802f3a <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802e78:	ff 75 08             	pushl  0x8(%ebp)
  802e7b:	e8 89 f1 ff ff       	call   802009 <get_block_size>
  802e80:	83 c4 04             	add    $0x4,%esp
  802e83:	89 c3                	mov    %eax,%ebx
  802e85:	ff 75 10             	pushl  0x10(%ebp)
  802e88:	e8 7c f1 ff ff       	call   802009 <get_block_size>
  802e8d:	83 c4 04             	add    $0x4,%esp
  802e90:	01 c3                	add    %eax,%ebx
  802e92:	ff 75 0c             	pushl  0xc(%ebp)
  802e95:	e8 6f f1 ff ff       	call   802009 <get_block_size>
  802e9a:	83 c4 04             	add    $0x4,%esp
  802e9d:	01 d8                	add    %ebx,%eax
  802e9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ea2:	6a 00                	push   $0x0
  802ea4:	ff 75 ec             	pushl  -0x14(%ebp)
  802ea7:	ff 75 08             	pushl  0x8(%ebp)
  802eaa:	e8 ab f4 ff ff       	call   80235a <set_block_data>
  802eaf:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802eb2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802eb6:	75 17                	jne    802ecf <merging+0xc8>
  802eb8:	83 ec 04             	sub    $0x4,%esp
  802ebb:	68 23 48 80 00       	push   $0x804823
  802ec0:	68 7d 01 00 00       	push   $0x17d
  802ec5:	68 41 48 80 00       	push   $0x804841
  802eca:	e8 eb d4 ff ff       	call   8003ba <_panic>
  802ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ed2:	8b 00                	mov    (%eax),%eax
  802ed4:	85 c0                	test   %eax,%eax
  802ed6:	74 10                	je     802ee8 <merging+0xe1>
  802ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802edb:	8b 00                	mov    (%eax),%eax
  802edd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ee0:	8b 52 04             	mov    0x4(%edx),%edx
  802ee3:	89 50 04             	mov    %edx,0x4(%eax)
  802ee6:	eb 0b                	jmp    802ef3 <merging+0xec>
  802ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eeb:	8b 40 04             	mov    0x4(%eax),%eax
  802eee:	a3 30 50 80 00       	mov    %eax,0x805030
  802ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef6:	8b 40 04             	mov    0x4(%eax),%eax
  802ef9:	85 c0                	test   %eax,%eax
  802efb:	74 0f                	je     802f0c <merging+0x105>
  802efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f00:	8b 40 04             	mov    0x4(%eax),%eax
  802f03:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f06:	8b 12                	mov    (%edx),%edx
  802f08:	89 10                	mov    %edx,(%eax)
  802f0a:	eb 0a                	jmp    802f16 <merging+0x10f>
  802f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f0f:	8b 00                	mov    (%eax),%eax
  802f11:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f22:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f29:	a1 38 50 80 00       	mov    0x805038,%eax
  802f2e:	48                   	dec    %eax
  802f2f:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802f34:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f35:	e9 ea 02 00 00       	jmp    803224 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802f3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f3e:	74 3b                	je     802f7b <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802f40:	83 ec 0c             	sub    $0xc,%esp
  802f43:	ff 75 08             	pushl  0x8(%ebp)
  802f46:	e8 be f0 ff ff       	call   802009 <get_block_size>
  802f4b:	83 c4 10             	add    $0x10,%esp
  802f4e:	89 c3                	mov    %eax,%ebx
  802f50:	83 ec 0c             	sub    $0xc,%esp
  802f53:	ff 75 10             	pushl  0x10(%ebp)
  802f56:	e8 ae f0 ff ff       	call   802009 <get_block_size>
  802f5b:	83 c4 10             	add    $0x10,%esp
  802f5e:	01 d8                	add    %ebx,%eax
  802f60:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f63:	83 ec 04             	sub    $0x4,%esp
  802f66:	6a 00                	push   $0x0
  802f68:	ff 75 e8             	pushl  -0x18(%ebp)
  802f6b:	ff 75 08             	pushl  0x8(%ebp)
  802f6e:	e8 e7 f3 ff ff       	call   80235a <set_block_data>
  802f73:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f76:	e9 a9 02 00 00       	jmp    803224 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802f7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f7f:	0f 84 2d 01 00 00    	je     8030b2 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802f85:	83 ec 0c             	sub    $0xc,%esp
  802f88:	ff 75 10             	pushl  0x10(%ebp)
  802f8b:	e8 79 f0 ff ff       	call   802009 <get_block_size>
  802f90:	83 c4 10             	add    $0x10,%esp
  802f93:	89 c3                	mov    %eax,%ebx
  802f95:	83 ec 0c             	sub    $0xc,%esp
  802f98:	ff 75 0c             	pushl  0xc(%ebp)
  802f9b:	e8 69 f0 ff ff       	call   802009 <get_block_size>
  802fa0:	83 c4 10             	add    $0x10,%esp
  802fa3:	01 d8                	add    %ebx,%eax
  802fa5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802fa8:	83 ec 04             	sub    $0x4,%esp
  802fab:	6a 00                	push   $0x0
  802fad:	ff 75 e4             	pushl  -0x1c(%ebp)
  802fb0:	ff 75 10             	pushl  0x10(%ebp)
  802fb3:	e8 a2 f3 ff ff       	call   80235a <set_block_data>
  802fb8:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802fbb:	8b 45 10             	mov    0x10(%ebp),%eax
  802fbe:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802fc1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fc5:	74 06                	je     802fcd <merging+0x1c6>
  802fc7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802fcb:	75 17                	jne    802fe4 <merging+0x1dd>
  802fcd:	83 ec 04             	sub    $0x4,%esp
  802fd0:	68 e8 48 80 00       	push   $0x8048e8
  802fd5:	68 8d 01 00 00       	push   $0x18d
  802fda:	68 41 48 80 00       	push   $0x804841
  802fdf:	e8 d6 d3 ff ff       	call   8003ba <_panic>
  802fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe7:	8b 50 04             	mov    0x4(%eax),%edx
  802fea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fed:	89 50 04             	mov    %edx,0x4(%eax)
  802ff0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ff3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ff6:	89 10                	mov    %edx,(%eax)
  802ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ffb:	8b 40 04             	mov    0x4(%eax),%eax
  802ffe:	85 c0                	test   %eax,%eax
  803000:	74 0d                	je     80300f <merging+0x208>
  803002:	8b 45 0c             	mov    0xc(%ebp),%eax
  803005:	8b 40 04             	mov    0x4(%eax),%eax
  803008:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80300b:	89 10                	mov    %edx,(%eax)
  80300d:	eb 08                	jmp    803017 <merging+0x210>
  80300f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803012:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803017:	8b 45 0c             	mov    0xc(%ebp),%eax
  80301a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80301d:	89 50 04             	mov    %edx,0x4(%eax)
  803020:	a1 38 50 80 00       	mov    0x805038,%eax
  803025:	40                   	inc    %eax
  803026:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  80302b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80302f:	75 17                	jne    803048 <merging+0x241>
  803031:	83 ec 04             	sub    $0x4,%esp
  803034:	68 23 48 80 00       	push   $0x804823
  803039:	68 8e 01 00 00       	push   $0x18e
  80303e:	68 41 48 80 00       	push   $0x804841
  803043:	e8 72 d3 ff ff       	call   8003ba <_panic>
  803048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80304b:	8b 00                	mov    (%eax),%eax
  80304d:	85 c0                	test   %eax,%eax
  80304f:	74 10                	je     803061 <merging+0x25a>
  803051:	8b 45 0c             	mov    0xc(%ebp),%eax
  803054:	8b 00                	mov    (%eax),%eax
  803056:	8b 55 0c             	mov    0xc(%ebp),%edx
  803059:	8b 52 04             	mov    0x4(%edx),%edx
  80305c:	89 50 04             	mov    %edx,0x4(%eax)
  80305f:	eb 0b                	jmp    80306c <merging+0x265>
  803061:	8b 45 0c             	mov    0xc(%ebp),%eax
  803064:	8b 40 04             	mov    0x4(%eax),%eax
  803067:	a3 30 50 80 00       	mov    %eax,0x805030
  80306c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80306f:	8b 40 04             	mov    0x4(%eax),%eax
  803072:	85 c0                	test   %eax,%eax
  803074:	74 0f                	je     803085 <merging+0x27e>
  803076:	8b 45 0c             	mov    0xc(%ebp),%eax
  803079:	8b 40 04             	mov    0x4(%eax),%eax
  80307c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80307f:	8b 12                	mov    (%edx),%edx
  803081:	89 10                	mov    %edx,(%eax)
  803083:	eb 0a                	jmp    80308f <merging+0x288>
  803085:	8b 45 0c             	mov    0xc(%ebp),%eax
  803088:	8b 00                	mov    (%eax),%eax
  80308a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80308f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803092:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803098:	8b 45 0c             	mov    0xc(%ebp),%eax
  80309b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a2:	a1 38 50 80 00       	mov    0x805038,%eax
  8030a7:	48                   	dec    %eax
  8030a8:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8030ad:	e9 72 01 00 00       	jmp    803224 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8030b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8030b5:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8030b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030bc:	74 79                	je     803137 <merging+0x330>
  8030be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030c2:	74 73                	je     803137 <merging+0x330>
  8030c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c8:	74 06                	je     8030d0 <merging+0x2c9>
  8030ca:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030ce:	75 17                	jne    8030e7 <merging+0x2e0>
  8030d0:	83 ec 04             	sub    $0x4,%esp
  8030d3:	68 b4 48 80 00       	push   $0x8048b4
  8030d8:	68 94 01 00 00       	push   $0x194
  8030dd:	68 41 48 80 00       	push   $0x804841
  8030e2:	e8 d3 d2 ff ff       	call   8003ba <_panic>
  8030e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ea:	8b 10                	mov    (%eax),%edx
  8030ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ef:	89 10                	mov    %edx,(%eax)
  8030f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f4:	8b 00                	mov    (%eax),%eax
  8030f6:	85 c0                	test   %eax,%eax
  8030f8:	74 0b                	je     803105 <merging+0x2fe>
  8030fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fd:	8b 00                	mov    (%eax),%eax
  8030ff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803102:	89 50 04             	mov    %edx,0x4(%eax)
  803105:	8b 45 08             	mov    0x8(%ebp),%eax
  803108:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80310b:	89 10                	mov    %edx,(%eax)
  80310d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803110:	8b 55 08             	mov    0x8(%ebp),%edx
  803113:	89 50 04             	mov    %edx,0x4(%eax)
  803116:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803119:	8b 00                	mov    (%eax),%eax
  80311b:	85 c0                	test   %eax,%eax
  80311d:	75 08                	jne    803127 <merging+0x320>
  80311f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803122:	a3 30 50 80 00       	mov    %eax,0x805030
  803127:	a1 38 50 80 00       	mov    0x805038,%eax
  80312c:	40                   	inc    %eax
  80312d:	a3 38 50 80 00       	mov    %eax,0x805038
  803132:	e9 ce 00 00 00       	jmp    803205 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803137:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80313b:	74 65                	je     8031a2 <merging+0x39b>
  80313d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803141:	75 17                	jne    80315a <merging+0x353>
  803143:	83 ec 04             	sub    $0x4,%esp
  803146:	68 90 48 80 00       	push   $0x804890
  80314b:	68 95 01 00 00       	push   $0x195
  803150:	68 41 48 80 00       	push   $0x804841
  803155:	e8 60 d2 ff ff       	call   8003ba <_panic>
  80315a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803160:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803163:	89 50 04             	mov    %edx,0x4(%eax)
  803166:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803169:	8b 40 04             	mov    0x4(%eax),%eax
  80316c:	85 c0                	test   %eax,%eax
  80316e:	74 0c                	je     80317c <merging+0x375>
  803170:	a1 30 50 80 00       	mov    0x805030,%eax
  803175:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803178:	89 10                	mov    %edx,(%eax)
  80317a:	eb 08                	jmp    803184 <merging+0x37d>
  80317c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80317f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803184:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803187:	a3 30 50 80 00       	mov    %eax,0x805030
  80318c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80318f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803195:	a1 38 50 80 00       	mov    0x805038,%eax
  80319a:	40                   	inc    %eax
  80319b:	a3 38 50 80 00       	mov    %eax,0x805038
  8031a0:	eb 63                	jmp    803205 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8031a2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031a6:	75 17                	jne    8031bf <merging+0x3b8>
  8031a8:	83 ec 04             	sub    $0x4,%esp
  8031ab:	68 5c 48 80 00       	push   $0x80485c
  8031b0:	68 98 01 00 00       	push   $0x198
  8031b5:	68 41 48 80 00       	push   $0x804841
  8031ba:	e8 fb d1 ff ff       	call   8003ba <_panic>
  8031bf:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8031c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031c8:	89 10                	mov    %edx,(%eax)
  8031ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031cd:	8b 00                	mov    (%eax),%eax
  8031cf:	85 c0                	test   %eax,%eax
  8031d1:	74 0d                	je     8031e0 <merging+0x3d9>
  8031d3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031d8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031db:	89 50 04             	mov    %edx,0x4(%eax)
  8031de:	eb 08                	jmp    8031e8 <merging+0x3e1>
  8031e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031e3:	a3 30 50 80 00       	mov    %eax,0x805030
  8031e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031eb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031fa:	a1 38 50 80 00       	mov    0x805038,%eax
  8031ff:	40                   	inc    %eax
  803200:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803205:	83 ec 0c             	sub    $0xc,%esp
  803208:	ff 75 10             	pushl  0x10(%ebp)
  80320b:	e8 f9 ed ff ff       	call   802009 <get_block_size>
  803210:	83 c4 10             	add    $0x10,%esp
  803213:	83 ec 04             	sub    $0x4,%esp
  803216:	6a 00                	push   $0x0
  803218:	50                   	push   %eax
  803219:	ff 75 10             	pushl  0x10(%ebp)
  80321c:	e8 39 f1 ff ff       	call   80235a <set_block_data>
  803221:	83 c4 10             	add    $0x10,%esp
	}
}
  803224:	90                   	nop
  803225:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803228:	c9                   	leave  
  803229:	c3                   	ret    

0080322a <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80322a:	55                   	push   %ebp
  80322b:	89 e5                	mov    %esp,%ebp
  80322d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803230:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803235:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803238:	a1 30 50 80 00       	mov    0x805030,%eax
  80323d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803240:	73 1b                	jae    80325d <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803242:	a1 30 50 80 00       	mov    0x805030,%eax
  803247:	83 ec 04             	sub    $0x4,%esp
  80324a:	ff 75 08             	pushl  0x8(%ebp)
  80324d:	6a 00                	push   $0x0
  80324f:	50                   	push   %eax
  803250:	e8 b2 fb ff ff       	call   802e07 <merging>
  803255:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803258:	e9 8b 00 00 00       	jmp    8032e8 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80325d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803262:	3b 45 08             	cmp    0x8(%ebp),%eax
  803265:	76 18                	jbe    80327f <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803267:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80326c:	83 ec 04             	sub    $0x4,%esp
  80326f:	ff 75 08             	pushl  0x8(%ebp)
  803272:	50                   	push   %eax
  803273:	6a 00                	push   $0x0
  803275:	e8 8d fb ff ff       	call   802e07 <merging>
  80327a:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80327d:	eb 69                	jmp    8032e8 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80327f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803284:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803287:	eb 39                	jmp    8032c2 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803289:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80328f:	73 29                	jae    8032ba <free_block+0x90>
  803291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803294:	8b 00                	mov    (%eax),%eax
  803296:	3b 45 08             	cmp    0x8(%ebp),%eax
  803299:	76 1f                	jbe    8032ba <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80329b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329e:	8b 00                	mov    (%eax),%eax
  8032a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8032a3:	83 ec 04             	sub    $0x4,%esp
  8032a6:	ff 75 08             	pushl  0x8(%ebp)
  8032a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8032ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8032af:	e8 53 fb ff ff       	call   802e07 <merging>
  8032b4:	83 c4 10             	add    $0x10,%esp
			break;
  8032b7:	90                   	nop
		}
	}
}
  8032b8:	eb 2e                	jmp    8032e8 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8032ba:	a1 34 50 80 00       	mov    0x805034,%eax
  8032bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032c6:	74 07                	je     8032cf <free_block+0xa5>
  8032c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cb:	8b 00                	mov    (%eax),%eax
  8032cd:	eb 05                	jmp    8032d4 <free_block+0xaa>
  8032cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8032d4:	a3 34 50 80 00       	mov    %eax,0x805034
  8032d9:	a1 34 50 80 00       	mov    0x805034,%eax
  8032de:	85 c0                	test   %eax,%eax
  8032e0:	75 a7                	jne    803289 <free_block+0x5f>
  8032e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032e6:	75 a1                	jne    803289 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032e8:	90                   	nop
  8032e9:	c9                   	leave  
  8032ea:	c3                   	ret    

008032eb <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8032eb:	55                   	push   %ebp
  8032ec:	89 e5                	mov    %esp,%ebp
  8032ee:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8032f1:	ff 75 08             	pushl  0x8(%ebp)
  8032f4:	e8 10 ed ff ff       	call   802009 <get_block_size>
  8032f9:	83 c4 04             	add    $0x4,%esp
  8032fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8032ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803306:	eb 17                	jmp    80331f <copy_data+0x34>
  803308:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80330b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80330e:	01 c2                	add    %eax,%edx
  803310:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803313:	8b 45 08             	mov    0x8(%ebp),%eax
  803316:	01 c8                	add    %ecx,%eax
  803318:	8a 00                	mov    (%eax),%al
  80331a:	88 02                	mov    %al,(%edx)
  80331c:	ff 45 fc             	incl   -0x4(%ebp)
  80331f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803322:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803325:	72 e1                	jb     803308 <copy_data+0x1d>
}
  803327:	90                   	nop
  803328:	c9                   	leave  
  803329:	c3                   	ret    

0080332a <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80332a:	55                   	push   %ebp
  80332b:	89 e5                	mov    %esp,%ebp
  80332d:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803330:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803334:	75 23                	jne    803359 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803336:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80333a:	74 13                	je     80334f <realloc_block_FF+0x25>
  80333c:	83 ec 0c             	sub    $0xc,%esp
  80333f:	ff 75 0c             	pushl  0xc(%ebp)
  803342:	e8 42 f0 ff ff       	call   802389 <alloc_block_FF>
  803347:	83 c4 10             	add    $0x10,%esp
  80334a:	e9 e4 06 00 00       	jmp    803a33 <realloc_block_FF+0x709>
		return NULL;
  80334f:	b8 00 00 00 00       	mov    $0x0,%eax
  803354:	e9 da 06 00 00       	jmp    803a33 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803359:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80335d:	75 18                	jne    803377 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80335f:	83 ec 0c             	sub    $0xc,%esp
  803362:	ff 75 08             	pushl  0x8(%ebp)
  803365:	e8 c0 fe ff ff       	call   80322a <free_block>
  80336a:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80336d:	b8 00 00 00 00       	mov    $0x0,%eax
  803372:	e9 bc 06 00 00       	jmp    803a33 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803377:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80337b:	77 07                	ja     803384 <realloc_block_FF+0x5a>
  80337d:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803384:	8b 45 0c             	mov    0xc(%ebp),%eax
  803387:	83 e0 01             	and    $0x1,%eax
  80338a:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80338d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803390:	83 c0 08             	add    $0x8,%eax
  803393:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803396:	83 ec 0c             	sub    $0xc,%esp
  803399:	ff 75 08             	pushl  0x8(%ebp)
  80339c:	e8 68 ec ff ff       	call   802009 <get_block_size>
  8033a1:	83 c4 10             	add    $0x10,%esp
  8033a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8033a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033aa:	83 e8 08             	sub    $0x8,%eax
  8033ad:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8033b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b3:	83 e8 04             	sub    $0x4,%eax
  8033b6:	8b 00                	mov    (%eax),%eax
  8033b8:	83 e0 fe             	and    $0xfffffffe,%eax
  8033bb:	89 c2                	mov    %eax,%edx
  8033bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c0:	01 d0                	add    %edx,%eax
  8033c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8033c5:	83 ec 0c             	sub    $0xc,%esp
  8033c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033cb:	e8 39 ec ff ff       	call   802009 <get_block_size>
  8033d0:	83 c4 10             	add    $0x10,%esp
  8033d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8033d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033d9:	83 e8 08             	sub    $0x8,%eax
  8033dc:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8033df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033e2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8033e5:	75 08                	jne    8033ef <realloc_block_FF+0xc5>
	{
		 return va;
  8033e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ea:	e9 44 06 00 00       	jmp    803a33 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  8033ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8033f5:	0f 83 d5 03 00 00    	jae    8037d0 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8033fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fe:	2b 45 0c             	sub    0xc(%ebp),%eax
  803401:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803404:	83 ec 0c             	sub    $0xc,%esp
  803407:	ff 75 e4             	pushl  -0x1c(%ebp)
  80340a:	e8 13 ec ff ff       	call   802022 <is_free_block>
  80340f:	83 c4 10             	add    $0x10,%esp
  803412:	84 c0                	test   %al,%al
  803414:	0f 84 3b 01 00 00    	je     803555 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80341a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80341d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803420:	01 d0                	add    %edx,%eax
  803422:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803425:	83 ec 04             	sub    $0x4,%esp
  803428:	6a 01                	push   $0x1
  80342a:	ff 75 f0             	pushl  -0x10(%ebp)
  80342d:	ff 75 08             	pushl  0x8(%ebp)
  803430:	e8 25 ef ff ff       	call   80235a <set_block_data>
  803435:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803438:	8b 45 08             	mov    0x8(%ebp),%eax
  80343b:	83 e8 04             	sub    $0x4,%eax
  80343e:	8b 00                	mov    (%eax),%eax
  803440:	83 e0 fe             	and    $0xfffffffe,%eax
  803443:	89 c2                	mov    %eax,%edx
  803445:	8b 45 08             	mov    0x8(%ebp),%eax
  803448:	01 d0                	add    %edx,%eax
  80344a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80344d:	83 ec 04             	sub    $0x4,%esp
  803450:	6a 00                	push   $0x0
  803452:	ff 75 cc             	pushl  -0x34(%ebp)
  803455:	ff 75 c8             	pushl  -0x38(%ebp)
  803458:	e8 fd ee ff ff       	call   80235a <set_block_data>
  80345d:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803460:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803464:	74 06                	je     80346c <realloc_block_FF+0x142>
  803466:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80346a:	75 17                	jne    803483 <realloc_block_FF+0x159>
  80346c:	83 ec 04             	sub    $0x4,%esp
  80346f:	68 b4 48 80 00       	push   $0x8048b4
  803474:	68 f6 01 00 00       	push   $0x1f6
  803479:	68 41 48 80 00       	push   $0x804841
  80347e:	e8 37 cf ff ff       	call   8003ba <_panic>
  803483:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803486:	8b 10                	mov    (%eax),%edx
  803488:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80348b:	89 10                	mov    %edx,(%eax)
  80348d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803490:	8b 00                	mov    (%eax),%eax
  803492:	85 c0                	test   %eax,%eax
  803494:	74 0b                	je     8034a1 <realloc_block_FF+0x177>
  803496:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803499:	8b 00                	mov    (%eax),%eax
  80349b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80349e:	89 50 04             	mov    %edx,0x4(%eax)
  8034a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034a7:	89 10                	mov    %edx,(%eax)
  8034a9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034af:	89 50 04             	mov    %edx,0x4(%eax)
  8034b2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034b5:	8b 00                	mov    (%eax),%eax
  8034b7:	85 c0                	test   %eax,%eax
  8034b9:	75 08                	jne    8034c3 <realloc_block_FF+0x199>
  8034bb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034be:	a3 30 50 80 00       	mov    %eax,0x805030
  8034c3:	a1 38 50 80 00       	mov    0x805038,%eax
  8034c8:	40                   	inc    %eax
  8034c9:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8034ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034d2:	75 17                	jne    8034eb <realloc_block_FF+0x1c1>
  8034d4:	83 ec 04             	sub    $0x4,%esp
  8034d7:	68 23 48 80 00       	push   $0x804823
  8034dc:	68 f7 01 00 00       	push   $0x1f7
  8034e1:	68 41 48 80 00       	push   $0x804841
  8034e6:	e8 cf ce ff ff       	call   8003ba <_panic>
  8034eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ee:	8b 00                	mov    (%eax),%eax
  8034f0:	85 c0                	test   %eax,%eax
  8034f2:	74 10                	je     803504 <realloc_block_FF+0x1da>
  8034f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f7:	8b 00                	mov    (%eax),%eax
  8034f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034fc:	8b 52 04             	mov    0x4(%edx),%edx
  8034ff:	89 50 04             	mov    %edx,0x4(%eax)
  803502:	eb 0b                	jmp    80350f <realloc_block_FF+0x1e5>
  803504:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803507:	8b 40 04             	mov    0x4(%eax),%eax
  80350a:	a3 30 50 80 00       	mov    %eax,0x805030
  80350f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803512:	8b 40 04             	mov    0x4(%eax),%eax
  803515:	85 c0                	test   %eax,%eax
  803517:	74 0f                	je     803528 <realloc_block_FF+0x1fe>
  803519:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80351c:	8b 40 04             	mov    0x4(%eax),%eax
  80351f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803522:	8b 12                	mov    (%edx),%edx
  803524:	89 10                	mov    %edx,(%eax)
  803526:	eb 0a                	jmp    803532 <realloc_block_FF+0x208>
  803528:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80352b:	8b 00                	mov    (%eax),%eax
  80352d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803532:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803535:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80353b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80353e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803545:	a1 38 50 80 00       	mov    0x805038,%eax
  80354a:	48                   	dec    %eax
  80354b:	a3 38 50 80 00       	mov    %eax,0x805038
  803550:	e9 73 02 00 00       	jmp    8037c8 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803555:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803559:	0f 86 69 02 00 00    	jbe    8037c8 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80355f:	83 ec 04             	sub    $0x4,%esp
  803562:	6a 01                	push   $0x1
  803564:	ff 75 f0             	pushl  -0x10(%ebp)
  803567:	ff 75 08             	pushl  0x8(%ebp)
  80356a:	e8 eb ed ff ff       	call   80235a <set_block_data>
  80356f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803572:	8b 45 08             	mov    0x8(%ebp),%eax
  803575:	83 e8 04             	sub    $0x4,%eax
  803578:	8b 00                	mov    (%eax),%eax
  80357a:	83 e0 fe             	and    $0xfffffffe,%eax
  80357d:	89 c2                	mov    %eax,%edx
  80357f:	8b 45 08             	mov    0x8(%ebp),%eax
  803582:	01 d0                	add    %edx,%eax
  803584:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803587:	a1 38 50 80 00       	mov    0x805038,%eax
  80358c:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80358f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803593:	75 68                	jne    8035fd <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803595:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803599:	75 17                	jne    8035b2 <realloc_block_FF+0x288>
  80359b:	83 ec 04             	sub    $0x4,%esp
  80359e:	68 5c 48 80 00       	push   $0x80485c
  8035a3:	68 06 02 00 00       	push   $0x206
  8035a8:	68 41 48 80 00       	push   $0x804841
  8035ad:	e8 08 ce ff ff       	call   8003ba <_panic>
  8035b2:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035bb:	89 10                	mov    %edx,(%eax)
  8035bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c0:	8b 00                	mov    (%eax),%eax
  8035c2:	85 c0                	test   %eax,%eax
  8035c4:	74 0d                	je     8035d3 <realloc_block_FF+0x2a9>
  8035c6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035cb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035ce:	89 50 04             	mov    %edx,0x4(%eax)
  8035d1:	eb 08                	jmp    8035db <realloc_block_FF+0x2b1>
  8035d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d6:	a3 30 50 80 00       	mov    %eax,0x805030
  8035db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035de:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ed:	a1 38 50 80 00       	mov    0x805038,%eax
  8035f2:	40                   	inc    %eax
  8035f3:	a3 38 50 80 00       	mov    %eax,0x805038
  8035f8:	e9 b0 01 00 00       	jmp    8037ad <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8035fd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803602:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803605:	76 68                	jbe    80366f <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803607:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80360b:	75 17                	jne    803624 <realloc_block_FF+0x2fa>
  80360d:	83 ec 04             	sub    $0x4,%esp
  803610:	68 5c 48 80 00       	push   $0x80485c
  803615:	68 0b 02 00 00       	push   $0x20b
  80361a:	68 41 48 80 00       	push   $0x804841
  80361f:	e8 96 cd ff ff       	call   8003ba <_panic>
  803624:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80362a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80362d:	89 10                	mov    %edx,(%eax)
  80362f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803632:	8b 00                	mov    (%eax),%eax
  803634:	85 c0                	test   %eax,%eax
  803636:	74 0d                	je     803645 <realloc_block_FF+0x31b>
  803638:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80363d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803640:	89 50 04             	mov    %edx,0x4(%eax)
  803643:	eb 08                	jmp    80364d <realloc_block_FF+0x323>
  803645:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803648:	a3 30 50 80 00       	mov    %eax,0x805030
  80364d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803650:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803655:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803658:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80365f:	a1 38 50 80 00       	mov    0x805038,%eax
  803664:	40                   	inc    %eax
  803665:	a3 38 50 80 00       	mov    %eax,0x805038
  80366a:	e9 3e 01 00 00       	jmp    8037ad <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80366f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803674:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803677:	73 68                	jae    8036e1 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803679:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80367d:	75 17                	jne    803696 <realloc_block_FF+0x36c>
  80367f:	83 ec 04             	sub    $0x4,%esp
  803682:	68 90 48 80 00       	push   $0x804890
  803687:	68 10 02 00 00       	push   $0x210
  80368c:	68 41 48 80 00       	push   $0x804841
  803691:	e8 24 cd ff ff       	call   8003ba <_panic>
  803696:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80369c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80369f:	89 50 04             	mov    %edx,0x4(%eax)
  8036a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a5:	8b 40 04             	mov    0x4(%eax),%eax
  8036a8:	85 c0                	test   %eax,%eax
  8036aa:	74 0c                	je     8036b8 <realloc_block_FF+0x38e>
  8036ac:	a1 30 50 80 00       	mov    0x805030,%eax
  8036b1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036b4:	89 10                	mov    %edx,(%eax)
  8036b6:	eb 08                	jmp    8036c0 <realloc_block_FF+0x396>
  8036b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036bb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c3:	a3 30 50 80 00       	mov    %eax,0x805030
  8036c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036d1:	a1 38 50 80 00       	mov    0x805038,%eax
  8036d6:	40                   	inc    %eax
  8036d7:	a3 38 50 80 00       	mov    %eax,0x805038
  8036dc:	e9 cc 00 00 00       	jmp    8037ad <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8036e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8036e8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036f0:	e9 8a 00 00 00       	jmp    80377f <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8036f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036fb:	73 7a                	jae    803777 <realloc_block_FF+0x44d>
  8036fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803700:	8b 00                	mov    (%eax),%eax
  803702:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803705:	73 70                	jae    803777 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803707:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80370b:	74 06                	je     803713 <realloc_block_FF+0x3e9>
  80370d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803711:	75 17                	jne    80372a <realloc_block_FF+0x400>
  803713:	83 ec 04             	sub    $0x4,%esp
  803716:	68 b4 48 80 00       	push   $0x8048b4
  80371b:	68 1a 02 00 00       	push   $0x21a
  803720:	68 41 48 80 00       	push   $0x804841
  803725:	e8 90 cc ff ff       	call   8003ba <_panic>
  80372a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372d:	8b 10                	mov    (%eax),%edx
  80372f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803732:	89 10                	mov    %edx,(%eax)
  803734:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803737:	8b 00                	mov    (%eax),%eax
  803739:	85 c0                	test   %eax,%eax
  80373b:	74 0b                	je     803748 <realloc_block_FF+0x41e>
  80373d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803740:	8b 00                	mov    (%eax),%eax
  803742:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803745:	89 50 04             	mov    %edx,0x4(%eax)
  803748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80374e:	89 10                	mov    %edx,(%eax)
  803750:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803753:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803756:	89 50 04             	mov    %edx,0x4(%eax)
  803759:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80375c:	8b 00                	mov    (%eax),%eax
  80375e:	85 c0                	test   %eax,%eax
  803760:	75 08                	jne    80376a <realloc_block_FF+0x440>
  803762:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803765:	a3 30 50 80 00       	mov    %eax,0x805030
  80376a:	a1 38 50 80 00       	mov    0x805038,%eax
  80376f:	40                   	inc    %eax
  803770:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803775:	eb 36                	jmp    8037ad <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803777:	a1 34 50 80 00       	mov    0x805034,%eax
  80377c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80377f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803783:	74 07                	je     80378c <realloc_block_FF+0x462>
  803785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803788:	8b 00                	mov    (%eax),%eax
  80378a:	eb 05                	jmp    803791 <realloc_block_FF+0x467>
  80378c:	b8 00 00 00 00       	mov    $0x0,%eax
  803791:	a3 34 50 80 00       	mov    %eax,0x805034
  803796:	a1 34 50 80 00       	mov    0x805034,%eax
  80379b:	85 c0                	test   %eax,%eax
  80379d:	0f 85 52 ff ff ff    	jne    8036f5 <realloc_block_FF+0x3cb>
  8037a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037a7:	0f 85 48 ff ff ff    	jne    8036f5 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8037ad:	83 ec 04             	sub    $0x4,%esp
  8037b0:	6a 00                	push   $0x0
  8037b2:	ff 75 d8             	pushl  -0x28(%ebp)
  8037b5:	ff 75 d4             	pushl  -0x2c(%ebp)
  8037b8:	e8 9d eb ff ff       	call   80235a <set_block_data>
  8037bd:	83 c4 10             	add    $0x10,%esp
				return va;
  8037c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c3:	e9 6b 02 00 00       	jmp    803a33 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  8037c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cb:	e9 63 02 00 00       	jmp    803a33 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  8037d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037d3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8037d6:	0f 86 4d 02 00 00    	jbe    803a29 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  8037dc:	83 ec 0c             	sub    $0xc,%esp
  8037df:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037e2:	e8 3b e8 ff ff       	call   802022 <is_free_block>
  8037e7:	83 c4 10             	add    $0x10,%esp
  8037ea:	84 c0                	test   %al,%al
  8037ec:	0f 84 37 02 00 00    	je     803a29 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8037f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037f5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8037f8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8037fb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037fe:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803801:	76 38                	jbe    80383b <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803803:	83 ec 0c             	sub    $0xc,%esp
  803806:	ff 75 0c             	pushl  0xc(%ebp)
  803809:	e8 7b eb ff ff       	call   802389 <alloc_block_FF>
  80380e:	83 c4 10             	add    $0x10,%esp
  803811:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803814:	83 ec 08             	sub    $0x8,%esp
  803817:	ff 75 c0             	pushl  -0x40(%ebp)
  80381a:	ff 75 08             	pushl  0x8(%ebp)
  80381d:	e8 c9 fa ff ff       	call   8032eb <copy_data>
  803822:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803825:	83 ec 0c             	sub    $0xc,%esp
  803828:	ff 75 08             	pushl  0x8(%ebp)
  80382b:	e8 fa f9 ff ff       	call   80322a <free_block>
  803830:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803833:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803836:	e9 f8 01 00 00       	jmp    803a33 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80383b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80383e:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803841:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803844:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803848:	0f 87 a0 00 00 00    	ja     8038ee <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80384e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803852:	75 17                	jne    80386b <realloc_block_FF+0x541>
  803854:	83 ec 04             	sub    $0x4,%esp
  803857:	68 23 48 80 00       	push   $0x804823
  80385c:	68 38 02 00 00       	push   $0x238
  803861:	68 41 48 80 00       	push   $0x804841
  803866:	e8 4f cb ff ff       	call   8003ba <_panic>
  80386b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386e:	8b 00                	mov    (%eax),%eax
  803870:	85 c0                	test   %eax,%eax
  803872:	74 10                	je     803884 <realloc_block_FF+0x55a>
  803874:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803877:	8b 00                	mov    (%eax),%eax
  803879:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80387c:	8b 52 04             	mov    0x4(%edx),%edx
  80387f:	89 50 04             	mov    %edx,0x4(%eax)
  803882:	eb 0b                	jmp    80388f <realloc_block_FF+0x565>
  803884:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803887:	8b 40 04             	mov    0x4(%eax),%eax
  80388a:	a3 30 50 80 00       	mov    %eax,0x805030
  80388f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803892:	8b 40 04             	mov    0x4(%eax),%eax
  803895:	85 c0                	test   %eax,%eax
  803897:	74 0f                	je     8038a8 <realloc_block_FF+0x57e>
  803899:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389c:	8b 40 04             	mov    0x4(%eax),%eax
  80389f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038a2:	8b 12                	mov    (%edx),%edx
  8038a4:	89 10                	mov    %edx,(%eax)
  8038a6:	eb 0a                	jmp    8038b2 <realloc_block_FF+0x588>
  8038a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ab:	8b 00                	mov    (%eax),%eax
  8038ad:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038c5:	a1 38 50 80 00       	mov    0x805038,%eax
  8038ca:	48                   	dec    %eax
  8038cb:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8038d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038d6:	01 d0                	add    %edx,%eax
  8038d8:	83 ec 04             	sub    $0x4,%esp
  8038db:	6a 01                	push   $0x1
  8038dd:	50                   	push   %eax
  8038de:	ff 75 08             	pushl  0x8(%ebp)
  8038e1:	e8 74 ea ff ff       	call   80235a <set_block_data>
  8038e6:	83 c4 10             	add    $0x10,%esp
  8038e9:	e9 36 01 00 00       	jmp    803a24 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8038ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038f1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038f4:	01 d0                	add    %edx,%eax
  8038f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8038f9:	83 ec 04             	sub    $0x4,%esp
  8038fc:	6a 01                	push   $0x1
  8038fe:	ff 75 f0             	pushl  -0x10(%ebp)
  803901:	ff 75 08             	pushl  0x8(%ebp)
  803904:	e8 51 ea ff ff       	call   80235a <set_block_data>
  803909:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80390c:	8b 45 08             	mov    0x8(%ebp),%eax
  80390f:	83 e8 04             	sub    $0x4,%eax
  803912:	8b 00                	mov    (%eax),%eax
  803914:	83 e0 fe             	and    $0xfffffffe,%eax
  803917:	89 c2                	mov    %eax,%edx
  803919:	8b 45 08             	mov    0x8(%ebp),%eax
  80391c:	01 d0                	add    %edx,%eax
  80391e:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803921:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803925:	74 06                	je     80392d <realloc_block_FF+0x603>
  803927:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80392b:	75 17                	jne    803944 <realloc_block_FF+0x61a>
  80392d:	83 ec 04             	sub    $0x4,%esp
  803930:	68 b4 48 80 00       	push   $0x8048b4
  803935:	68 44 02 00 00       	push   $0x244
  80393a:	68 41 48 80 00       	push   $0x804841
  80393f:	e8 76 ca ff ff       	call   8003ba <_panic>
  803944:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803947:	8b 10                	mov    (%eax),%edx
  803949:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80394c:	89 10                	mov    %edx,(%eax)
  80394e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803951:	8b 00                	mov    (%eax),%eax
  803953:	85 c0                	test   %eax,%eax
  803955:	74 0b                	je     803962 <realloc_block_FF+0x638>
  803957:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395a:	8b 00                	mov    (%eax),%eax
  80395c:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80395f:	89 50 04             	mov    %edx,0x4(%eax)
  803962:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803965:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803968:	89 10                	mov    %edx,(%eax)
  80396a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80396d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803970:	89 50 04             	mov    %edx,0x4(%eax)
  803973:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803976:	8b 00                	mov    (%eax),%eax
  803978:	85 c0                	test   %eax,%eax
  80397a:	75 08                	jne    803984 <realloc_block_FF+0x65a>
  80397c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80397f:	a3 30 50 80 00       	mov    %eax,0x805030
  803984:	a1 38 50 80 00       	mov    0x805038,%eax
  803989:	40                   	inc    %eax
  80398a:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80398f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803993:	75 17                	jne    8039ac <realloc_block_FF+0x682>
  803995:	83 ec 04             	sub    $0x4,%esp
  803998:	68 23 48 80 00       	push   $0x804823
  80399d:	68 45 02 00 00       	push   $0x245
  8039a2:	68 41 48 80 00       	push   $0x804841
  8039a7:	e8 0e ca ff ff       	call   8003ba <_panic>
  8039ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039af:	8b 00                	mov    (%eax),%eax
  8039b1:	85 c0                	test   %eax,%eax
  8039b3:	74 10                	je     8039c5 <realloc_block_FF+0x69b>
  8039b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b8:	8b 00                	mov    (%eax),%eax
  8039ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039bd:	8b 52 04             	mov    0x4(%edx),%edx
  8039c0:	89 50 04             	mov    %edx,0x4(%eax)
  8039c3:	eb 0b                	jmp    8039d0 <realloc_block_FF+0x6a6>
  8039c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c8:	8b 40 04             	mov    0x4(%eax),%eax
  8039cb:	a3 30 50 80 00       	mov    %eax,0x805030
  8039d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d3:	8b 40 04             	mov    0x4(%eax),%eax
  8039d6:	85 c0                	test   %eax,%eax
  8039d8:	74 0f                	je     8039e9 <realloc_block_FF+0x6bf>
  8039da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039dd:	8b 40 04             	mov    0x4(%eax),%eax
  8039e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039e3:	8b 12                	mov    (%edx),%edx
  8039e5:	89 10                	mov    %edx,(%eax)
  8039e7:	eb 0a                	jmp    8039f3 <realloc_block_FF+0x6c9>
  8039e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ec:	8b 00                	mov    (%eax),%eax
  8039ee:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a06:	a1 38 50 80 00       	mov    0x805038,%eax
  803a0b:	48                   	dec    %eax
  803a0c:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803a11:	83 ec 04             	sub    $0x4,%esp
  803a14:	6a 00                	push   $0x0
  803a16:	ff 75 bc             	pushl  -0x44(%ebp)
  803a19:	ff 75 b8             	pushl  -0x48(%ebp)
  803a1c:	e8 39 e9 ff ff       	call   80235a <set_block_data>
  803a21:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803a24:	8b 45 08             	mov    0x8(%ebp),%eax
  803a27:	eb 0a                	jmp    803a33 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803a29:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803a30:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803a33:	c9                   	leave  
  803a34:	c3                   	ret    

00803a35 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803a35:	55                   	push   %ebp
  803a36:	89 e5                	mov    %esp,%ebp
  803a38:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803a3b:	83 ec 04             	sub    $0x4,%esp
  803a3e:	68 20 49 80 00       	push   $0x804920
  803a43:	68 58 02 00 00       	push   $0x258
  803a48:	68 41 48 80 00       	push   $0x804841
  803a4d:	e8 68 c9 ff ff       	call   8003ba <_panic>

00803a52 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803a52:	55                   	push   %ebp
  803a53:	89 e5                	mov    %esp,%ebp
  803a55:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803a58:	83 ec 04             	sub    $0x4,%esp
  803a5b:	68 48 49 80 00       	push   $0x804948
  803a60:	68 61 02 00 00       	push   $0x261
  803a65:	68 41 48 80 00       	push   $0x804841
  803a6a:	e8 4b c9 ff ff       	call   8003ba <_panic>
  803a6f:	90                   	nop

00803a70 <__udivdi3>:
  803a70:	55                   	push   %ebp
  803a71:	57                   	push   %edi
  803a72:	56                   	push   %esi
  803a73:	53                   	push   %ebx
  803a74:	83 ec 1c             	sub    $0x1c,%esp
  803a77:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a7b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a83:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a87:	89 ca                	mov    %ecx,%edx
  803a89:	89 f8                	mov    %edi,%eax
  803a8b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a8f:	85 f6                	test   %esi,%esi
  803a91:	75 2d                	jne    803ac0 <__udivdi3+0x50>
  803a93:	39 cf                	cmp    %ecx,%edi
  803a95:	77 65                	ja     803afc <__udivdi3+0x8c>
  803a97:	89 fd                	mov    %edi,%ebp
  803a99:	85 ff                	test   %edi,%edi
  803a9b:	75 0b                	jne    803aa8 <__udivdi3+0x38>
  803a9d:	b8 01 00 00 00       	mov    $0x1,%eax
  803aa2:	31 d2                	xor    %edx,%edx
  803aa4:	f7 f7                	div    %edi
  803aa6:	89 c5                	mov    %eax,%ebp
  803aa8:	31 d2                	xor    %edx,%edx
  803aaa:	89 c8                	mov    %ecx,%eax
  803aac:	f7 f5                	div    %ebp
  803aae:	89 c1                	mov    %eax,%ecx
  803ab0:	89 d8                	mov    %ebx,%eax
  803ab2:	f7 f5                	div    %ebp
  803ab4:	89 cf                	mov    %ecx,%edi
  803ab6:	89 fa                	mov    %edi,%edx
  803ab8:	83 c4 1c             	add    $0x1c,%esp
  803abb:	5b                   	pop    %ebx
  803abc:	5e                   	pop    %esi
  803abd:	5f                   	pop    %edi
  803abe:	5d                   	pop    %ebp
  803abf:	c3                   	ret    
  803ac0:	39 ce                	cmp    %ecx,%esi
  803ac2:	77 28                	ja     803aec <__udivdi3+0x7c>
  803ac4:	0f bd fe             	bsr    %esi,%edi
  803ac7:	83 f7 1f             	xor    $0x1f,%edi
  803aca:	75 40                	jne    803b0c <__udivdi3+0x9c>
  803acc:	39 ce                	cmp    %ecx,%esi
  803ace:	72 0a                	jb     803ada <__udivdi3+0x6a>
  803ad0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ad4:	0f 87 9e 00 00 00    	ja     803b78 <__udivdi3+0x108>
  803ada:	b8 01 00 00 00       	mov    $0x1,%eax
  803adf:	89 fa                	mov    %edi,%edx
  803ae1:	83 c4 1c             	add    $0x1c,%esp
  803ae4:	5b                   	pop    %ebx
  803ae5:	5e                   	pop    %esi
  803ae6:	5f                   	pop    %edi
  803ae7:	5d                   	pop    %ebp
  803ae8:	c3                   	ret    
  803ae9:	8d 76 00             	lea    0x0(%esi),%esi
  803aec:	31 ff                	xor    %edi,%edi
  803aee:	31 c0                	xor    %eax,%eax
  803af0:	89 fa                	mov    %edi,%edx
  803af2:	83 c4 1c             	add    $0x1c,%esp
  803af5:	5b                   	pop    %ebx
  803af6:	5e                   	pop    %esi
  803af7:	5f                   	pop    %edi
  803af8:	5d                   	pop    %ebp
  803af9:	c3                   	ret    
  803afa:	66 90                	xchg   %ax,%ax
  803afc:	89 d8                	mov    %ebx,%eax
  803afe:	f7 f7                	div    %edi
  803b00:	31 ff                	xor    %edi,%edi
  803b02:	89 fa                	mov    %edi,%edx
  803b04:	83 c4 1c             	add    $0x1c,%esp
  803b07:	5b                   	pop    %ebx
  803b08:	5e                   	pop    %esi
  803b09:	5f                   	pop    %edi
  803b0a:	5d                   	pop    %ebp
  803b0b:	c3                   	ret    
  803b0c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b11:	89 eb                	mov    %ebp,%ebx
  803b13:	29 fb                	sub    %edi,%ebx
  803b15:	89 f9                	mov    %edi,%ecx
  803b17:	d3 e6                	shl    %cl,%esi
  803b19:	89 c5                	mov    %eax,%ebp
  803b1b:	88 d9                	mov    %bl,%cl
  803b1d:	d3 ed                	shr    %cl,%ebp
  803b1f:	89 e9                	mov    %ebp,%ecx
  803b21:	09 f1                	or     %esi,%ecx
  803b23:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b27:	89 f9                	mov    %edi,%ecx
  803b29:	d3 e0                	shl    %cl,%eax
  803b2b:	89 c5                	mov    %eax,%ebp
  803b2d:	89 d6                	mov    %edx,%esi
  803b2f:	88 d9                	mov    %bl,%cl
  803b31:	d3 ee                	shr    %cl,%esi
  803b33:	89 f9                	mov    %edi,%ecx
  803b35:	d3 e2                	shl    %cl,%edx
  803b37:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b3b:	88 d9                	mov    %bl,%cl
  803b3d:	d3 e8                	shr    %cl,%eax
  803b3f:	09 c2                	or     %eax,%edx
  803b41:	89 d0                	mov    %edx,%eax
  803b43:	89 f2                	mov    %esi,%edx
  803b45:	f7 74 24 0c          	divl   0xc(%esp)
  803b49:	89 d6                	mov    %edx,%esi
  803b4b:	89 c3                	mov    %eax,%ebx
  803b4d:	f7 e5                	mul    %ebp
  803b4f:	39 d6                	cmp    %edx,%esi
  803b51:	72 19                	jb     803b6c <__udivdi3+0xfc>
  803b53:	74 0b                	je     803b60 <__udivdi3+0xf0>
  803b55:	89 d8                	mov    %ebx,%eax
  803b57:	31 ff                	xor    %edi,%edi
  803b59:	e9 58 ff ff ff       	jmp    803ab6 <__udivdi3+0x46>
  803b5e:	66 90                	xchg   %ax,%ax
  803b60:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b64:	89 f9                	mov    %edi,%ecx
  803b66:	d3 e2                	shl    %cl,%edx
  803b68:	39 c2                	cmp    %eax,%edx
  803b6a:	73 e9                	jae    803b55 <__udivdi3+0xe5>
  803b6c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b6f:	31 ff                	xor    %edi,%edi
  803b71:	e9 40 ff ff ff       	jmp    803ab6 <__udivdi3+0x46>
  803b76:	66 90                	xchg   %ax,%ax
  803b78:	31 c0                	xor    %eax,%eax
  803b7a:	e9 37 ff ff ff       	jmp    803ab6 <__udivdi3+0x46>
  803b7f:	90                   	nop

00803b80 <__umoddi3>:
  803b80:	55                   	push   %ebp
  803b81:	57                   	push   %edi
  803b82:	56                   	push   %esi
  803b83:	53                   	push   %ebx
  803b84:	83 ec 1c             	sub    $0x1c,%esp
  803b87:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b8b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b93:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b97:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b9b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b9f:	89 f3                	mov    %esi,%ebx
  803ba1:	89 fa                	mov    %edi,%edx
  803ba3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ba7:	89 34 24             	mov    %esi,(%esp)
  803baa:	85 c0                	test   %eax,%eax
  803bac:	75 1a                	jne    803bc8 <__umoddi3+0x48>
  803bae:	39 f7                	cmp    %esi,%edi
  803bb0:	0f 86 a2 00 00 00    	jbe    803c58 <__umoddi3+0xd8>
  803bb6:	89 c8                	mov    %ecx,%eax
  803bb8:	89 f2                	mov    %esi,%edx
  803bba:	f7 f7                	div    %edi
  803bbc:	89 d0                	mov    %edx,%eax
  803bbe:	31 d2                	xor    %edx,%edx
  803bc0:	83 c4 1c             	add    $0x1c,%esp
  803bc3:	5b                   	pop    %ebx
  803bc4:	5e                   	pop    %esi
  803bc5:	5f                   	pop    %edi
  803bc6:	5d                   	pop    %ebp
  803bc7:	c3                   	ret    
  803bc8:	39 f0                	cmp    %esi,%eax
  803bca:	0f 87 ac 00 00 00    	ja     803c7c <__umoddi3+0xfc>
  803bd0:	0f bd e8             	bsr    %eax,%ebp
  803bd3:	83 f5 1f             	xor    $0x1f,%ebp
  803bd6:	0f 84 ac 00 00 00    	je     803c88 <__umoddi3+0x108>
  803bdc:	bf 20 00 00 00       	mov    $0x20,%edi
  803be1:	29 ef                	sub    %ebp,%edi
  803be3:	89 fe                	mov    %edi,%esi
  803be5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803be9:	89 e9                	mov    %ebp,%ecx
  803beb:	d3 e0                	shl    %cl,%eax
  803bed:	89 d7                	mov    %edx,%edi
  803bef:	89 f1                	mov    %esi,%ecx
  803bf1:	d3 ef                	shr    %cl,%edi
  803bf3:	09 c7                	or     %eax,%edi
  803bf5:	89 e9                	mov    %ebp,%ecx
  803bf7:	d3 e2                	shl    %cl,%edx
  803bf9:	89 14 24             	mov    %edx,(%esp)
  803bfc:	89 d8                	mov    %ebx,%eax
  803bfe:	d3 e0                	shl    %cl,%eax
  803c00:	89 c2                	mov    %eax,%edx
  803c02:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c06:	d3 e0                	shl    %cl,%eax
  803c08:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c0c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c10:	89 f1                	mov    %esi,%ecx
  803c12:	d3 e8                	shr    %cl,%eax
  803c14:	09 d0                	or     %edx,%eax
  803c16:	d3 eb                	shr    %cl,%ebx
  803c18:	89 da                	mov    %ebx,%edx
  803c1a:	f7 f7                	div    %edi
  803c1c:	89 d3                	mov    %edx,%ebx
  803c1e:	f7 24 24             	mull   (%esp)
  803c21:	89 c6                	mov    %eax,%esi
  803c23:	89 d1                	mov    %edx,%ecx
  803c25:	39 d3                	cmp    %edx,%ebx
  803c27:	0f 82 87 00 00 00    	jb     803cb4 <__umoddi3+0x134>
  803c2d:	0f 84 91 00 00 00    	je     803cc4 <__umoddi3+0x144>
  803c33:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c37:	29 f2                	sub    %esi,%edx
  803c39:	19 cb                	sbb    %ecx,%ebx
  803c3b:	89 d8                	mov    %ebx,%eax
  803c3d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c41:	d3 e0                	shl    %cl,%eax
  803c43:	89 e9                	mov    %ebp,%ecx
  803c45:	d3 ea                	shr    %cl,%edx
  803c47:	09 d0                	or     %edx,%eax
  803c49:	89 e9                	mov    %ebp,%ecx
  803c4b:	d3 eb                	shr    %cl,%ebx
  803c4d:	89 da                	mov    %ebx,%edx
  803c4f:	83 c4 1c             	add    $0x1c,%esp
  803c52:	5b                   	pop    %ebx
  803c53:	5e                   	pop    %esi
  803c54:	5f                   	pop    %edi
  803c55:	5d                   	pop    %ebp
  803c56:	c3                   	ret    
  803c57:	90                   	nop
  803c58:	89 fd                	mov    %edi,%ebp
  803c5a:	85 ff                	test   %edi,%edi
  803c5c:	75 0b                	jne    803c69 <__umoddi3+0xe9>
  803c5e:	b8 01 00 00 00       	mov    $0x1,%eax
  803c63:	31 d2                	xor    %edx,%edx
  803c65:	f7 f7                	div    %edi
  803c67:	89 c5                	mov    %eax,%ebp
  803c69:	89 f0                	mov    %esi,%eax
  803c6b:	31 d2                	xor    %edx,%edx
  803c6d:	f7 f5                	div    %ebp
  803c6f:	89 c8                	mov    %ecx,%eax
  803c71:	f7 f5                	div    %ebp
  803c73:	89 d0                	mov    %edx,%eax
  803c75:	e9 44 ff ff ff       	jmp    803bbe <__umoddi3+0x3e>
  803c7a:	66 90                	xchg   %ax,%ax
  803c7c:	89 c8                	mov    %ecx,%eax
  803c7e:	89 f2                	mov    %esi,%edx
  803c80:	83 c4 1c             	add    $0x1c,%esp
  803c83:	5b                   	pop    %ebx
  803c84:	5e                   	pop    %esi
  803c85:	5f                   	pop    %edi
  803c86:	5d                   	pop    %ebp
  803c87:	c3                   	ret    
  803c88:	3b 04 24             	cmp    (%esp),%eax
  803c8b:	72 06                	jb     803c93 <__umoddi3+0x113>
  803c8d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c91:	77 0f                	ja     803ca2 <__umoddi3+0x122>
  803c93:	89 f2                	mov    %esi,%edx
  803c95:	29 f9                	sub    %edi,%ecx
  803c97:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c9b:	89 14 24             	mov    %edx,(%esp)
  803c9e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ca2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ca6:	8b 14 24             	mov    (%esp),%edx
  803ca9:	83 c4 1c             	add    $0x1c,%esp
  803cac:	5b                   	pop    %ebx
  803cad:	5e                   	pop    %esi
  803cae:	5f                   	pop    %edi
  803caf:	5d                   	pop    %ebp
  803cb0:	c3                   	ret    
  803cb1:	8d 76 00             	lea    0x0(%esi),%esi
  803cb4:	2b 04 24             	sub    (%esp),%eax
  803cb7:	19 fa                	sbb    %edi,%edx
  803cb9:	89 d1                	mov    %edx,%ecx
  803cbb:	89 c6                	mov    %eax,%esi
  803cbd:	e9 71 ff ff ff       	jmp    803c33 <__umoddi3+0xb3>
  803cc2:	66 90                	xchg   %ax,%ax
  803cc4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803cc8:	72 ea                	jb     803cb4 <__umoddi3+0x134>
  803cca:	89 d9                	mov    %ebx,%ecx
  803ccc:	e9 62 ff ff ff       	jmp    803c33 <__umoddi3+0xb3>
