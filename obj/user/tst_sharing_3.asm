
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
  80005b:	68 60 3d 80 00       	push   $0x803d60
  800060:	6a 0c                	push   $0xc
  800062:	68 7c 3d 80 00       	push   $0x803d7c
  800067:	e8 4e 03 00 00       	call   8003ba <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	cprintf("************************************************\n");
  80006c:	83 ec 0c             	sub    $0xc,%esp
  80006f:	68 94 3d 80 00       	push   $0x803d94
  800074:	e8 fe 05 00 00       	call   800677 <cprintf>
  800079:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	68 c8 3d 80 00       	push   $0x803dc8
  800084:	e8 ee 05 00 00       	call   800677 <cprintf>
  800089:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 24 3e 80 00       	push   $0x803e24
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
  8000b4:	68 58 3e 80 00       	push   $0x803e58
  8000b9:	e8 b9 05 00 00       	call   800677 <cprintf>
  8000be:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 01                	push   $0x1
  8000c6:	68 00 10 00 00       	push   $0x1000
  8000cb:	68 a6 3e 80 00       	push   $0x803ea6
  8000d0:	e8 70 16 00 00       	call   801745 <smalloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000db:	e8 71 1a 00 00       	call   801b51 <sys_calculate_free_frames>
  8000e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000e3:	83 ec 04             	sub    $0x4,%esp
  8000e6:	6a 01                	push   $0x1
  8000e8:	68 00 10 00 00       	push   $0x1000
  8000ed:	68 a6 3e 80 00       	push   $0x803ea6
  8000f2:	e8 4e 16 00 00       	call   801745 <smalloc>
  8000f7:	83 c4 10             	add    $0x10,%esp
  8000fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) {is_correct = 0; cprintf("Trying to create an already exists object and corresponding error is not returned!!");}
  8000fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800101:	74 17                	je     80011a <_main+0xe2>
  800103:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	68 a8 3e 80 00       	push   $0x803ea8
  800112:	e8 60 05 00 00       	call   800677 <cprintf>
  800117:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");}
  80011a:	e8 32 1a 00 00       	call   801b51 <sys_calculate_free_frames>
  80011f:	89 c2                	mov    %eax,%edx
  800121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800124:	39 c2                	cmp    %eax,%edx
  800126:	74 17                	je     80013f <_main+0x107>
  800128:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 fc 3e 80 00       	push   $0x803efc
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
  800153:	68 58 3f 80 00       	push   $0x803f58
  800158:	e8 1a 05 00 00       	call   800677 <cprintf>
  80015d:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		x = sget(myEnv->env_id, "xx");
  800160:	a1 20 50 80 00       	mov    0x805020,%eax
  800165:	8b 40 10             	mov    0x10(%eax),%eax
  800168:	83 ec 08             	sub    $0x8,%esp
  80016b:	68 9d 3f 80 00       	push   $0x803f9d
  800170:	50                   	push   %eax
  800171:	e8 d9 16 00 00       	call   80184f <sget>
  800176:	83 c4 10             	add    $0x10,%esp
  800179:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  80017c:	e8 d0 19 00 00       	call   801b51 <sys_calculate_free_frames>
  800181:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != NULL) {is_correct = 0; cprintf("Trying to get a NON existing object and corresponding error is not returned!!");}
  800184:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800188:	74 17                	je     8001a1 <_main+0x169>
  80018a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800191:	83 ec 0c             	sub    $0xc,%esp
  800194:	68 a0 3f 80 00       	push   $0x803fa0
  800199:	e8 d9 04 00 00       	call   800677 <cprintf>
  80019e:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong get: make sure that you don't allocate any memory if the shared object not exists");}
  8001a1:	e8 ab 19 00 00       	call   801b51 <sys_calculate_free_frames>
  8001a6:	89 c2                	mov    %eax,%edx
  8001a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ab:	39 c2                	cmp    %eax,%edx
  8001ad:	74 17                	je     8001c6 <_main+0x18e>
  8001af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	68 f0 3f 80 00       	push   $0x803ff0
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
  8001da:	68 48 40 80 00       	push   $0x804048
  8001df:	e8 93 04 00 00       	call   800677 <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8001e7:	e8 65 19 00 00       	call   801b51 <sys_calculate_free_frames>
  8001ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uint32 size = USER_HEAP_MAX - pagealloc_start - PAGE_SIZE + 1;
  8001ef:	b8 01 f0 ff 9f       	mov    $0x9ffff001,%eax
  8001f4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8001f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		y = smalloc("y", size, 1);
  8001fa:	83 ec 04             	sub    $0x4,%esp
  8001fd:	6a 01                	push   $0x1
  8001ff:	ff 75 d8             	pushl  -0x28(%ebp)
  800202:	68 a5 40 80 00       	push   $0x8040a5
  800207:	e8 39 15 00 00       	call   801745 <smalloc>
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (y != NULL) {is_correct = 0; cprintf("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");}
  800212:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800216:	74 17                	je     80022f <_main+0x1f7>
  800218:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	68 a8 40 80 00       	push   $0x8040a8
  800227:	e8 4b 04 00 00       	call   800677 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");}
  80022f:	e8 1d 19 00 00       	call   801b51 <sys_calculate_free_frames>
  800234:	89 c2                	mov    %eax,%edx
  800236:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800239:	39 c2                	cmp    %eax,%edx
  80023b:	74 17                	je     800254 <_main+0x21c>
  80023d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 1c 41 80 00       	push   $0x80411c
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
  80026b:	68 90 41 80 00       	push   $0x804190
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
  800281:	e8 94 1a 00 00       	call   801d1a <sys_getenvindex>
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
  8002ef:	e8 aa 17 00 00       	call   801a9e <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 fc 41 80 00       	push   $0x8041fc
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
  80031f:	68 24 42 80 00       	push   $0x804224
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
  800350:	68 4c 42 80 00       	push   $0x80424c
  800355:	e8 1d 03 00 00       	call   800677 <cprintf>
  80035a:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80035d:	a1 20 50 80 00       	mov    0x805020,%eax
  800362:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800368:	83 ec 08             	sub    $0x8,%esp
  80036b:	50                   	push   %eax
  80036c:	68 a4 42 80 00       	push   $0x8042a4
  800371:	e8 01 03 00 00       	call   800677 <cprintf>
  800376:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800379:	83 ec 0c             	sub    $0xc,%esp
  80037c:	68 fc 41 80 00       	push   $0x8041fc
  800381:	e8 f1 02 00 00       	call   800677 <cprintf>
  800386:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800389:	e8 2a 17 00 00       	call   801ab8 <sys_unlock_cons>
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
  8003a1:	e8 40 19 00 00       	call   801ce6 <sys_destroy_env>
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
  8003b2:	e8 95 19 00 00       	call   801d4c <sys_exit_env>
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
  8003c9:	a1 50 50 80 00       	mov    0x805050,%eax
  8003ce:	85 c0                	test   %eax,%eax
  8003d0:	74 16                	je     8003e8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003d2:	a1 50 50 80 00       	mov    0x805050,%eax
  8003d7:	83 ec 08             	sub    $0x8,%esp
  8003da:	50                   	push   %eax
  8003db:	68 b8 42 80 00       	push   $0x8042b8
  8003e0:	e8 92 02 00 00       	call   800677 <cprintf>
  8003e5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003e8:	a1 00 50 80 00       	mov    0x805000,%eax
  8003ed:	ff 75 0c             	pushl  0xc(%ebp)
  8003f0:	ff 75 08             	pushl  0x8(%ebp)
  8003f3:	50                   	push   %eax
  8003f4:	68 bd 42 80 00       	push   $0x8042bd
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
  800418:	68 d9 42 80 00       	push   $0x8042d9
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
  800447:	68 dc 42 80 00       	push   $0x8042dc
  80044c:	6a 26                	push   $0x26
  80044e:	68 28 43 80 00       	push   $0x804328
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
  80051c:	68 34 43 80 00       	push   $0x804334
  800521:	6a 3a                	push   $0x3a
  800523:	68 28 43 80 00       	push   $0x804328
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
  80058f:	68 88 43 80 00       	push   $0x804388
  800594:	6a 44                	push   $0x44
  800596:	68 28 43 80 00       	push   $0x804328
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
  8005ce:	a0 2c 50 80 00       	mov    0x80502c,%al
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
  8005e9:	e8 6e 14 00 00       	call   801a5c <sys_cputs>
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
  800643:	a0 2c 50 80 00       	mov    0x80502c,%al
  800648:	0f b6 c0             	movzbl %al,%eax
  80064b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800651:	83 ec 04             	sub    $0x4,%esp
  800654:	50                   	push   %eax
  800655:	52                   	push   %edx
  800656:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80065c:	83 c0 08             	add    $0x8,%eax
  80065f:	50                   	push   %eax
  800660:	e8 f7 13 00 00       	call   801a5c <sys_cputs>
  800665:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800668:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
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
  80067d:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  8006aa:	e8 ef 13 00 00       	call   801a9e <sys_lock_cons>
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
  8006ca:	e8 e9 13 00 00       	call   801ab8 <sys_unlock_cons>
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
  800714:	e8 db 33 00 00       	call   803af4 <__udivdi3>
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
  800764:	e8 9b 34 00 00       	call   803c04 <__umoddi3>
  800769:	83 c4 10             	add    $0x10,%esp
  80076c:	05 f4 45 80 00       	add    $0x8045f4,%eax
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
  8008bf:	8b 04 85 18 46 80 00 	mov    0x804618(,%eax,4),%eax
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
  8009a0:	8b 34 9d 60 44 80 00 	mov    0x804460(,%ebx,4),%esi
  8009a7:	85 f6                	test   %esi,%esi
  8009a9:	75 19                	jne    8009c4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009ab:	53                   	push   %ebx
  8009ac:	68 05 46 80 00       	push   $0x804605
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
  8009c5:	68 0e 46 80 00       	push   $0x80460e
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
  8009f2:	be 11 46 80 00       	mov    $0x804611,%esi
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
  800bea:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  800bf1:	eb 2c                	jmp    800c1f <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800bf3:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  8013fd:	68 88 47 80 00       	push   $0x804788
  801402:	68 3f 01 00 00       	push   $0x13f
  801407:	68 aa 47 80 00       	push   $0x8047aa
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
  80141d:	e8 e5 0b 00 00       	call   802007 <sys_sbrk>
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
  801498:	e8 ee 09 00 00       	call   801e8b <sys_isUHeapPlacementStrategyFIRSTFIT>
  80149d:	85 c0                	test   %eax,%eax
  80149f:	74 16                	je     8014b7 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8014a1:	83 ec 0c             	sub    $0xc,%esp
  8014a4:	ff 75 08             	pushl  0x8(%ebp)
  8014a7:	e8 2e 0f 00 00       	call   8023da <alloc_block_FF>
  8014ac:	83 c4 10             	add    $0x10,%esp
  8014af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014b2:	e9 8a 01 00 00       	jmp    801641 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014b7:	e8 00 0a 00 00       	call   801ebc <sys_isUHeapPlacementStrategyBESTFIT>
  8014bc:	85 c0                	test   %eax,%eax
  8014be:	0f 84 7d 01 00 00    	je     801641 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014c4:	83 ec 0c             	sub    $0xc,%esp
  8014c7:	ff 75 08             	pushl  0x8(%ebp)
  8014ca:	e8 c7 13 00 00       	call   802896 <alloc_block_BF>
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
		//cprintf("52\n");
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
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801503:	a1 20 50 80 00       	mov    0x805020,%eax
  801508:	8b 40 78             	mov    0x78(%eax),%eax
  80150b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80150e:	29 c2                	sub    %eax,%edx
  801510:	89 d0                	mov    %edx,%eax
  801512:	2d 00 10 00 00       	sub    $0x1000,%eax
  801517:	c1 e8 0c             	shr    $0xc,%eax
  80151a:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
  801521:	85 c0                	test   %eax,%eax
  801523:	0f 85 ab 00 00 00    	jne    8015d4 <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801529:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152c:	05 00 10 00 00       	add    $0x1000,%eax
  801531:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801534:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
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
  801567:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
  80156e:	85 c0                	test   %eax,%eax
  801570:	74 08                	je     80157a <malloc+0x153>
					{
						//cprintf("71\n");
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
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
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
  8015be:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
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
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8015d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015d8:	75 16                	jne    8015f0 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8015da:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8015e1:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8015e8:	0f 86 15 ff ff ff    	jbe    801503 <malloc+0xdc>
  8015ee:	eb 01                	jmp    8015f1 <malloc+0x1ca>
				}
				//cprintf("79\n");

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
  801620:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801627:	83 ec 08             	sub    $0x8,%esp
  80162a:	ff 75 08             	pushl  0x8(%ebp)
  80162d:	ff 75 f0             	pushl  -0x10(%ebp)
  801630:	e8 09 0a 00 00       	call   80203e <sys_allocate_user_mem>
  801635:	83 c4 10             	add    $0x10,%esp
  801638:	eb 07                	jmp    801641 <malloc+0x21a>
		//cprintf("91\n");
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
  801678:	e8 dd 09 00 00       	call   80205a <get_block_size>
  80167d:	83 c4 10             	add    $0x10,%esp
  801680:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801683:	83 ec 0c             	sub    $0xc,%esp
  801686:	ff 75 08             	pushl  0x8(%ebp)
  801689:	e8 10 1c 00 00       	call   80329e <free_block>
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
  8016c3:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
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
  801700:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  801707:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  80170b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	83 ec 08             	sub    $0x8,%esp
  801714:	52                   	push   %edx
  801715:	50                   	push   %eax
  801716:	e8 07 09 00 00       	call   802022 <sys_free_user_mem>
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
  80172e:	68 b8 47 80 00       	push   $0x8047b8
  801733:	68 88 00 00 00       	push   $0x88
  801738:	68 e2 47 80 00       	push   $0x8047e2
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
  80175c:	e9 ec 00 00 00       	jmp    80184d <smalloc+0x108>
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
  80178d:	75 0a                	jne    801799 <smalloc+0x54>
  80178f:	b8 00 00 00 00       	mov    $0x0,%eax
  801794:	e9 b4 00 00 00       	jmp    80184d <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801799:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80179d:	ff 75 ec             	pushl  -0x14(%ebp)
  8017a0:	50                   	push   %eax
  8017a1:	ff 75 0c             	pushl  0xc(%ebp)
  8017a4:	ff 75 08             	pushl  0x8(%ebp)
  8017a7:	e8 7d 04 00 00       	call   801c29 <sys_createSharedObject>
  8017ac:	83 c4 10             	add    $0x10,%esp
  8017af:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8017b2:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8017b6:	74 06                	je     8017be <smalloc+0x79>
  8017b8:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8017bc:	75 0a                	jne    8017c8 <smalloc+0x83>
  8017be:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c3:	e9 85 00 00 00       	jmp    80184d <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  8017c8:	83 ec 08             	sub    $0x8,%esp
  8017cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8017ce:	68 ee 47 80 00       	push   $0x8047ee
  8017d3:	e8 9f ee ff ff       	call   800677 <cprintf>
  8017d8:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8017db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017de:	a1 20 50 80 00       	mov    0x805020,%eax
  8017e3:	8b 40 78             	mov    0x78(%eax),%eax
  8017e6:	29 c2                	sub    %eax,%edx
  8017e8:	89 d0                	mov    %edx,%eax
  8017ea:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017ef:	c1 e8 0c             	shr    $0xc,%eax
  8017f2:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8017f8:	42                   	inc    %edx
  8017f9:	89 15 24 50 80 00    	mov    %edx,0x805024
  8017ff:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801805:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  80180c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80180f:	a1 20 50 80 00       	mov    0x805020,%eax
  801814:	8b 40 78             	mov    0x78(%eax),%eax
  801817:	29 c2                	sub    %eax,%edx
  801819:	89 d0                	mov    %edx,%eax
  80181b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801820:	c1 e8 0c             	shr    $0xc,%eax
  801823:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  80182a:	a1 20 50 80 00       	mov    0x805020,%eax
  80182f:	8b 50 10             	mov    0x10(%eax),%edx
  801832:	89 c8                	mov    %ecx,%eax
  801834:	c1 e0 02             	shl    $0x2,%eax
  801837:	89 c1                	mov    %eax,%ecx
  801839:	c1 e1 09             	shl    $0x9,%ecx
  80183c:	01 c8                	add    %ecx,%eax
  80183e:	01 c2                	add    %eax,%edx
  801840:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801843:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  80184a:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
  801852:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801855:	83 ec 08             	sub    $0x8,%esp
  801858:	ff 75 0c             	pushl  0xc(%ebp)
  80185b:	ff 75 08             	pushl  0x8(%ebp)
  80185e:	e8 f0 03 00 00       	call   801c53 <sys_getSizeOfSharedObject>
  801863:	83 c4 10             	add    $0x10,%esp
  801866:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801869:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80186d:	75 0a                	jne    801879 <sget+0x2a>
  80186f:	b8 00 00 00 00       	mov    $0x0,%eax
  801874:	e9 e7 00 00 00       	jmp    801960 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80187f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801886:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188c:	39 d0                	cmp    %edx,%eax
  80188e:	73 02                	jae    801892 <sget+0x43>
  801890:	89 d0                	mov    %edx,%eax
  801892:	83 ec 0c             	sub    $0xc,%esp
  801895:	50                   	push   %eax
  801896:	e8 8c fb ff ff       	call   801427 <malloc>
  80189b:	83 c4 10             	add    $0x10,%esp
  80189e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8018a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8018a5:	75 0a                	jne    8018b1 <sget+0x62>
  8018a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ac:	e9 af 00 00 00       	jmp    801960 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8018b1:	83 ec 04             	sub    $0x4,%esp
  8018b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8018b7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ba:	ff 75 08             	pushl  0x8(%ebp)
  8018bd:	e8 ae 03 00 00       	call   801c70 <sys_getSharedObject>
  8018c2:	83 c4 10             	add    $0x10,%esp
  8018c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8018c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8018d0:	8b 40 78             	mov    0x78(%eax),%eax
  8018d3:	29 c2                	sub    %eax,%edx
  8018d5:	89 d0                	mov    %edx,%eax
  8018d7:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018dc:	c1 e8 0c             	shr    $0xc,%eax
  8018df:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8018e5:	42                   	inc    %edx
  8018e6:	89 15 24 50 80 00    	mov    %edx,0x805024
  8018ec:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8018f2:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  8018f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018fc:	a1 20 50 80 00       	mov    0x805020,%eax
  801901:	8b 40 78             	mov    0x78(%eax),%eax
  801904:	29 c2                	sub    %eax,%edx
  801906:	89 d0                	mov    %edx,%eax
  801908:	2d 00 10 00 00       	sub    $0x1000,%eax
  80190d:	c1 e8 0c             	shr    $0xc,%eax
  801910:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801917:	a1 20 50 80 00       	mov    0x805020,%eax
  80191c:	8b 50 10             	mov    0x10(%eax),%edx
  80191f:	89 c8                	mov    %ecx,%eax
  801921:	c1 e0 02             	shl    $0x2,%eax
  801924:	89 c1                	mov    %eax,%ecx
  801926:	c1 e1 09             	shl    $0x9,%ecx
  801929:	01 c8                	add    %ecx,%eax
  80192b:	01 c2                	add    %eax,%edx
  80192d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801930:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  801937:	a1 20 50 80 00       	mov    0x805020,%eax
  80193c:	8b 40 10             	mov    0x10(%eax),%eax
  80193f:	83 ec 08             	sub    $0x8,%esp
  801942:	50                   	push   %eax
  801943:	68 fd 47 80 00       	push   $0x8047fd
  801948:	e8 2a ed ff ff       	call   800677 <cprintf>
  80194d:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801950:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801954:	75 07                	jne    80195d <sget+0x10e>
  801956:	b8 00 00 00 00       	mov    $0x0,%eax
  80195b:	eb 03                	jmp    801960 <sget+0x111>
	return ptr;
  80195d:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
  801965:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  801968:	8b 55 08             	mov    0x8(%ebp),%edx
  80196b:	a1 20 50 80 00       	mov    0x805020,%eax
  801970:	8b 40 78             	mov    0x78(%eax),%eax
  801973:	29 c2                	sub    %eax,%edx
  801975:	89 d0                	mov    %edx,%eax
  801977:	2d 00 10 00 00       	sub    $0x1000,%eax
  80197c:	c1 e8 0c             	shr    $0xc,%eax
  80197f:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801986:	a1 20 50 80 00       	mov    0x805020,%eax
  80198b:	8b 50 10             	mov    0x10(%eax),%edx
  80198e:	89 c8                	mov    %ecx,%eax
  801990:	c1 e0 02             	shl    $0x2,%eax
  801993:	89 c1                	mov    %eax,%ecx
  801995:	c1 e1 09             	shl    $0x9,%ecx
  801998:	01 c8                	add    %ecx,%eax
  80199a:	01 d0                	add    %edx,%eax
  80199c:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8019a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8019a6:	83 ec 08             	sub    $0x8,%esp
  8019a9:	ff 75 08             	pushl  0x8(%ebp)
  8019ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8019af:	e8 db 02 00 00       	call   801c8f <sys_freeSharedObject>
  8019b4:	83 c4 10             	add    $0x10,%esp
  8019b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8019ba:	90                   	nop
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019c3:	83 ec 04             	sub    $0x4,%esp
  8019c6:	68 0c 48 80 00       	push   $0x80480c
  8019cb:	68 e5 00 00 00       	push   $0xe5
  8019d0:	68 e2 47 80 00       	push   $0x8047e2
  8019d5:	e8 e0 e9 ff ff       	call   8003ba <_panic>

008019da <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
  8019dd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019e0:	83 ec 04             	sub    $0x4,%esp
  8019e3:	68 32 48 80 00       	push   $0x804832
  8019e8:	68 f1 00 00 00       	push   $0xf1
  8019ed:	68 e2 47 80 00       	push   $0x8047e2
  8019f2:	e8 c3 e9 ff ff       	call   8003ba <_panic>

008019f7 <shrink>:

}
void shrink(uint32 newSize)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
  8019fa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019fd:	83 ec 04             	sub    $0x4,%esp
  801a00:	68 32 48 80 00       	push   $0x804832
  801a05:	68 f6 00 00 00       	push   $0xf6
  801a0a:	68 e2 47 80 00       	push   $0x8047e2
  801a0f:	e8 a6 e9 ff ff       	call   8003ba <_panic>

00801a14 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a1a:	83 ec 04             	sub    $0x4,%esp
  801a1d:	68 32 48 80 00       	push   $0x804832
  801a22:	68 fb 00 00 00       	push   $0xfb
  801a27:	68 e2 47 80 00       	push   $0x8047e2
  801a2c:	e8 89 e9 ff ff       	call   8003ba <_panic>

00801a31 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	57                   	push   %edi
  801a35:	56                   	push   %esi
  801a36:	53                   	push   %ebx
  801a37:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a40:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a43:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a46:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a49:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a4c:	cd 30                	int    $0x30
  801a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a54:	83 c4 10             	add    $0x10,%esp
  801a57:	5b                   	pop    %ebx
  801a58:	5e                   	pop    %esi
  801a59:	5f                   	pop    %edi
  801a5a:	5d                   	pop    %ebp
  801a5b:	c3                   	ret    

00801a5c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	83 ec 04             	sub    $0x4,%esp
  801a62:	8b 45 10             	mov    0x10(%ebp),%eax
  801a65:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a68:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	52                   	push   %edx
  801a74:	ff 75 0c             	pushl  0xc(%ebp)
  801a77:	50                   	push   %eax
  801a78:	6a 00                	push   $0x0
  801a7a:	e8 b2 ff ff ff       	call   801a31 <syscall>
  801a7f:	83 c4 18             	add    $0x18,%esp
}
  801a82:	90                   	nop
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 02                	push   $0x2
  801a94:	e8 98 ff ff ff       	call   801a31 <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <sys_lock_cons>:

void sys_lock_cons(void)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 03                	push   $0x3
  801aad:	e8 7f ff ff ff       	call   801a31 <syscall>
  801ab2:	83 c4 18             	add    $0x18,%esp
}
  801ab5:	90                   	nop
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 04                	push   $0x4
  801ac7:	e8 65 ff ff ff       	call   801a31 <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
}
  801acf:	90                   	nop
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ad5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	52                   	push   %edx
  801ae2:	50                   	push   %eax
  801ae3:	6a 08                	push   $0x8
  801ae5:	e8 47 ff ff ff       	call   801a31 <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
  801af2:	56                   	push   %esi
  801af3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801af4:	8b 75 18             	mov    0x18(%ebp),%esi
  801af7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801afa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801afd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	56                   	push   %esi
  801b04:	53                   	push   %ebx
  801b05:	51                   	push   %ecx
  801b06:	52                   	push   %edx
  801b07:	50                   	push   %eax
  801b08:	6a 09                	push   $0x9
  801b0a:	e8 22 ff ff ff       	call   801a31 <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b15:	5b                   	pop    %ebx
  801b16:	5e                   	pop    %esi
  801b17:	5d                   	pop    %ebp
  801b18:	c3                   	ret    

00801b19 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	52                   	push   %edx
  801b29:	50                   	push   %eax
  801b2a:	6a 0a                	push   $0xa
  801b2c:	e8 00 ff ff ff       	call   801a31 <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	ff 75 0c             	pushl  0xc(%ebp)
  801b42:	ff 75 08             	pushl  0x8(%ebp)
  801b45:	6a 0b                	push   $0xb
  801b47:	e8 e5 fe ff ff       	call   801a31 <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 0c                	push   $0xc
  801b60:	e8 cc fe ff ff       	call   801a31 <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 0d                	push   $0xd
  801b79:	e8 b3 fe ff ff       	call   801a31 <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 0e                	push   $0xe
  801b92:	e8 9a fe ff ff       	call   801a31 <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
}
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 0f                	push   $0xf
  801bab:	e8 81 fe ff ff       	call   801a31 <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
}
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	ff 75 08             	pushl  0x8(%ebp)
  801bc3:	6a 10                	push   $0x10
  801bc5:	e8 67 fe ff ff       	call   801a31 <syscall>
  801bca:	83 c4 18             	add    $0x18,%esp
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 11                	push   $0x11
  801bde:	e8 4e fe ff ff       	call   801a31 <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
}
  801be6:	90                   	nop
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <sys_cputc>:

void
sys_cputc(const char c)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
  801bec:	83 ec 04             	sub    $0x4,%esp
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801bf5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	50                   	push   %eax
  801c02:	6a 01                	push   $0x1
  801c04:	e8 28 fe ff ff       	call   801a31 <syscall>
  801c09:	83 c4 18             	add    $0x18,%esp
}
  801c0c:	90                   	nop
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 14                	push   $0x14
  801c1e:	e8 0e fe ff ff       	call   801a31 <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
}
  801c26:	90                   	nop
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	83 ec 04             	sub    $0x4,%esp
  801c2f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c32:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c35:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c38:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	6a 00                	push   $0x0
  801c41:	51                   	push   %ecx
  801c42:	52                   	push   %edx
  801c43:	ff 75 0c             	pushl  0xc(%ebp)
  801c46:	50                   	push   %eax
  801c47:	6a 15                	push   $0x15
  801c49:	e8 e3 fd ff ff       	call   801a31 <syscall>
  801c4e:	83 c4 18             	add    $0x18,%esp
}
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	52                   	push   %edx
  801c63:	50                   	push   %eax
  801c64:	6a 16                	push   $0x16
  801c66:	e8 c6 fd ff ff       	call   801a31 <syscall>
  801c6b:	83 c4 18             	add    $0x18,%esp
}
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    

00801c70 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c73:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c79:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	51                   	push   %ecx
  801c81:	52                   	push   %edx
  801c82:	50                   	push   %eax
  801c83:	6a 17                	push   $0x17
  801c85:	e8 a7 fd ff ff       	call   801a31 <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c95:	8b 45 08             	mov    0x8(%ebp),%eax
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	52                   	push   %edx
  801c9f:	50                   	push   %eax
  801ca0:	6a 18                	push   $0x18
  801ca2:	e8 8a fd ff ff       	call   801a31 <syscall>
  801ca7:	83 c4 18             	add    $0x18,%esp
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	6a 00                	push   $0x0
  801cb4:	ff 75 14             	pushl  0x14(%ebp)
  801cb7:	ff 75 10             	pushl  0x10(%ebp)
  801cba:	ff 75 0c             	pushl  0xc(%ebp)
  801cbd:	50                   	push   %eax
  801cbe:	6a 19                	push   $0x19
  801cc0:	e8 6c fd ff ff       	call   801a31 <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
}
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <sys_run_env>:

void sys_run_env(int32 envId)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	50                   	push   %eax
  801cd9:	6a 1a                	push   $0x1a
  801cdb:	e8 51 fd ff ff       	call   801a31 <syscall>
  801ce0:	83 c4 18             	add    $0x18,%esp
}
  801ce3:	90                   	nop
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	50                   	push   %eax
  801cf5:	6a 1b                	push   $0x1b
  801cf7:	e8 35 fd ff ff       	call   801a31 <syscall>
  801cfc:	83 c4 18             	add    $0x18,%esp
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 05                	push   $0x5
  801d10:	e8 1c fd ff ff       	call   801a31 <syscall>
  801d15:	83 c4 18             	add    $0x18,%esp
}
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 06                	push   $0x6
  801d29:	e8 03 fd ff ff       	call   801a31 <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 07                	push   $0x7
  801d42:	e8 ea fc ff ff       	call   801a31 <syscall>
  801d47:	83 c4 18             	add    $0x18,%esp
}
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <sys_exit_env>:


void sys_exit_env(void)
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 1c                	push   $0x1c
  801d5b:	e8 d1 fc ff ff       	call   801a31 <syscall>
  801d60:	83 c4 18             	add    $0x18,%esp
}
  801d63:	90                   	nop
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d6c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d6f:	8d 50 04             	lea    0x4(%eax),%edx
  801d72:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	52                   	push   %edx
  801d7c:	50                   	push   %eax
  801d7d:	6a 1d                	push   $0x1d
  801d7f:	e8 ad fc ff ff       	call   801a31 <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
	return result;
  801d87:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d8d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d90:	89 01                	mov    %eax,(%ecx)
  801d92:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d95:	8b 45 08             	mov    0x8(%ebp),%eax
  801d98:	c9                   	leave  
  801d99:	c2 04 00             	ret    $0x4

00801d9c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	ff 75 10             	pushl  0x10(%ebp)
  801da6:	ff 75 0c             	pushl  0xc(%ebp)
  801da9:	ff 75 08             	pushl  0x8(%ebp)
  801dac:	6a 13                	push   $0x13
  801dae:	e8 7e fc ff ff       	call   801a31 <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
	return ;
  801db6:	90                   	nop
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <sys_rcr2>:
uint32 sys_rcr2()
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 1e                	push   $0x1e
  801dc8:	e8 64 fc ff ff       	call   801a31 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	83 ec 04             	sub    $0x4,%esp
  801dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dde:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	50                   	push   %eax
  801deb:	6a 1f                	push   $0x1f
  801ded:	e8 3f fc ff ff       	call   801a31 <syscall>
  801df2:	83 c4 18             	add    $0x18,%esp
	return ;
  801df5:	90                   	nop
}
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    

00801df8 <rsttst>:
void rsttst()
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 21                	push   $0x21
  801e07:	e8 25 fc ff ff       	call   801a31 <syscall>
  801e0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0f:	90                   	nop
}
  801e10:	c9                   	leave  
  801e11:	c3                   	ret    

00801e12 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	83 ec 04             	sub    $0x4,%esp
  801e18:	8b 45 14             	mov    0x14(%ebp),%eax
  801e1b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e1e:	8b 55 18             	mov    0x18(%ebp),%edx
  801e21:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e25:	52                   	push   %edx
  801e26:	50                   	push   %eax
  801e27:	ff 75 10             	pushl  0x10(%ebp)
  801e2a:	ff 75 0c             	pushl  0xc(%ebp)
  801e2d:	ff 75 08             	pushl  0x8(%ebp)
  801e30:	6a 20                	push   $0x20
  801e32:	e8 fa fb ff ff       	call   801a31 <syscall>
  801e37:	83 c4 18             	add    $0x18,%esp
	return ;
  801e3a:	90                   	nop
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <chktst>:
void chktst(uint32 n)
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	ff 75 08             	pushl  0x8(%ebp)
  801e4b:	6a 22                	push   $0x22
  801e4d:	e8 df fb ff ff       	call   801a31 <syscall>
  801e52:	83 c4 18             	add    $0x18,%esp
	return ;
  801e55:	90                   	nop
}
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <inctst>:

void inctst()
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 23                	push   $0x23
  801e67:	e8 c5 fb ff ff       	call   801a31 <syscall>
  801e6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6f:	90                   	nop
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <gettst>:
uint32 gettst()
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 24                	push   $0x24
  801e81:	e8 ab fb ff ff       	call   801a31 <syscall>
  801e86:	83 c4 18             	add    $0x18,%esp
}
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 25                	push   $0x25
  801e9d:	e8 8f fb ff ff       	call   801a31 <syscall>
  801ea2:	83 c4 18             	add    $0x18,%esp
  801ea5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ea8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801eac:	75 07                	jne    801eb5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801eae:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb3:	eb 05                	jmp    801eba <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801eb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eba:	c9                   	leave  
  801ebb:	c3                   	ret    

00801ebc <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
  801ebf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 25                	push   $0x25
  801ece:	e8 5e fb ff ff       	call   801a31 <syscall>
  801ed3:	83 c4 18             	add    $0x18,%esp
  801ed6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ed9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801edd:	75 07                	jne    801ee6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801edf:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee4:	eb 05                	jmp    801eeb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ee6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eeb:	c9                   	leave  
  801eec:	c3                   	ret    

00801eed <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801eed:	55                   	push   %ebp
  801eee:	89 e5                	mov    %esp,%ebp
  801ef0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 25                	push   $0x25
  801eff:	e8 2d fb ff ff       	call   801a31 <syscall>
  801f04:	83 c4 18             	add    $0x18,%esp
  801f07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f0a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f0e:	75 07                	jne    801f17 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f10:	b8 01 00 00 00       	mov    $0x1,%eax
  801f15:	eb 05                	jmp    801f1c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f1c:	c9                   	leave  
  801f1d:	c3                   	ret    

00801f1e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
  801f21:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 25                	push   $0x25
  801f30:	e8 fc fa ff ff       	call   801a31 <syscall>
  801f35:	83 c4 18             	add    $0x18,%esp
  801f38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f3b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f3f:	75 07                	jne    801f48 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f41:	b8 01 00 00 00       	mov    $0x1,%eax
  801f46:	eb 05                	jmp    801f4d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	ff 75 08             	pushl  0x8(%ebp)
  801f5d:	6a 26                	push   $0x26
  801f5f:	e8 cd fa ff ff       	call   801a31 <syscall>
  801f64:	83 c4 18             	add    $0x18,%esp
	return ;
  801f67:	90                   	nop
}
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    

00801f6a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
  801f6d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f6e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f71:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f77:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7a:	6a 00                	push   $0x0
  801f7c:	53                   	push   %ebx
  801f7d:	51                   	push   %ecx
  801f7e:	52                   	push   %edx
  801f7f:	50                   	push   %eax
  801f80:	6a 27                	push   $0x27
  801f82:	e8 aa fa ff ff       	call   801a31 <syscall>
  801f87:	83 c4 18             	add    $0x18,%esp
}
  801f8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    

00801f8f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f95:	8b 45 08             	mov    0x8(%ebp),%eax
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	52                   	push   %edx
  801f9f:	50                   	push   %eax
  801fa0:	6a 28                	push   $0x28
  801fa2:	e8 8a fa ff ff       	call   801a31 <syscall>
  801fa7:	83 c4 18             	add    $0x18,%esp
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801faf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb8:	6a 00                	push   $0x0
  801fba:	51                   	push   %ecx
  801fbb:	ff 75 10             	pushl  0x10(%ebp)
  801fbe:	52                   	push   %edx
  801fbf:	50                   	push   %eax
  801fc0:	6a 29                	push   $0x29
  801fc2:	e8 6a fa ff ff       	call   801a31 <syscall>
  801fc7:	83 c4 18             	add    $0x18,%esp
}
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    

00801fcc <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	ff 75 10             	pushl  0x10(%ebp)
  801fd6:	ff 75 0c             	pushl  0xc(%ebp)
  801fd9:	ff 75 08             	pushl  0x8(%ebp)
  801fdc:	6a 12                	push   $0x12
  801fde:	e8 4e fa ff ff       	call   801a31 <syscall>
  801fe3:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe6:	90                   	nop
}
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801fec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	52                   	push   %edx
  801ff9:	50                   	push   %eax
  801ffa:	6a 2a                	push   $0x2a
  801ffc:	e8 30 fa ff ff       	call   801a31 <syscall>
  802001:	83 c4 18             	add    $0x18,%esp
	return;
  802004:	90                   	nop
}
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80200a:	8b 45 08             	mov    0x8(%ebp),%eax
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	50                   	push   %eax
  802016:	6a 2b                	push   $0x2b
  802018:	e8 14 fa ff ff       	call   801a31 <syscall>
  80201d:	83 c4 18             	add    $0x18,%esp
}
  802020:	c9                   	leave  
  802021:	c3                   	ret    

00802022 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802022:	55                   	push   %ebp
  802023:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	ff 75 0c             	pushl  0xc(%ebp)
  80202e:	ff 75 08             	pushl  0x8(%ebp)
  802031:	6a 2c                	push   $0x2c
  802033:	e8 f9 f9 ff ff       	call   801a31 <syscall>
  802038:	83 c4 18             	add    $0x18,%esp
	return;
  80203b:	90                   	nop
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	ff 75 0c             	pushl  0xc(%ebp)
  80204a:	ff 75 08             	pushl  0x8(%ebp)
  80204d:	6a 2d                	push   $0x2d
  80204f:	e8 dd f9 ff ff       	call   801a31 <syscall>
  802054:	83 c4 18             	add    $0x18,%esp
	return;
  802057:	90                   	nop
}
  802058:	c9                   	leave  
  802059:	c3                   	ret    

0080205a <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802060:	8b 45 08             	mov    0x8(%ebp),%eax
  802063:	83 e8 04             	sub    $0x4,%eax
  802066:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802069:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80206c:	8b 00                	mov    (%eax),%eax
  80206e:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802071:	c9                   	leave  
  802072:	c3                   	ret    

00802073 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802073:	55                   	push   %ebp
  802074:	89 e5                	mov    %esp,%ebp
  802076:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802079:	8b 45 08             	mov    0x8(%ebp),%eax
  80207c:	83 e8 04             	sub    $0x4,%eax
  80207f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802082:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802085:	8b 00                	mov    (%eax),%eax
  802087:	83 e0 01             	and    $0x1,%eax
  80208a:	85 c0                	test   %eax,%eax
  80208c:	0f 94 c0             	sete   %al
}
  80208f:	c9                   	leave  
  802090:	c3                   	ret    

00802091 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802091:	55                   	push   %ebp
  802092:	89 e5                	mov    %esp,%ebp
  802094:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802097:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80209e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a1:	83 f8 02             	cmp    $0x2,%eax
  8020a4:	74 2b                	je     8020d1 <alloc_block+0x40>
  8020a6:	83 f8 02             	cmp    $0x2,%eax
  8020a9:	7f 07                	jg     8020b2 <alloc_block+0x21>
  8020ab:	83 f8 01             	cmp    $0x1,%eax
  8020ae:	74 0e                	je     8020be <alloc_block+0x2d>
  8020b0:	eb 58                	jmp    80210a <alloc_block+0x79>
  8020b2:	83 f8 03             	cmp    $0x3,%eax
  8020b5:	74 2d                	je     8020e4 <alloc_block+0x53>
  8020b7:	83 f8 04             	cmp    $0x4,%eax
  8020ba:	74 3b                	je     8020f7 <alloc_block+0x66>
  8020bc:	eb 4c                	jmp    80210a <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8020be:	83 ec 0c             	sub    $0xc,%esp
  8020c1:	ff 75 08             	pushl  0x8(%ebp)
  8020c4:	e8 11 03 00 00       	call   8023da <alloc_block_FF>
  8020c9:	83 c4 10             	add    $0x10,%esp
  8020cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020cf:	eb 4a                	jmp    80211b <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8020d1:	83 ec 0c             	sub    $0xc,%esp
  8020d4:	ff 75 08             	pushl  0x8(%ebp)
  8020d7:	e8 fa 19 00 00       	call   803ad6 <alloc_block_NF>
  8020dc:	83 c4 10             	add    $0x10,%esp
  8020df:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020e2:	eb 37                	jmp    80211b <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8020e4:	83 ec 0c             	sub    $0xc,%esp
  8020e7:	ff 75 08             	pushl  0x8(%ebp)
  8020ea:	e8 a7 07 00 00       	call   802896 <alloc_block_BF>
  8020ef:	83 c4 10             	add    $0x10,%esp
  8020f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020f5:	eb 24                	jmp    80211b <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8020f7:	83 ec 0c             	sub    $0xc,%esp
  8020fa:	ff 75 08             	pushl  0x8(%ebp)
  8020fd:	e8 b7 19 00 00       	call   803ab9 <alloc_block_WF>
  802102:	83 c4 10             	add    $0x10,%esp
  802105:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802108:	eb 11                	jmp    80211b <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80210a:	83 ec 0c             	sub    $0xc,%esp
  80210d:	68 44 48 80 00       	push   $0x804844
  802112:	e8 60 e5 ff ff       	call   800677 <cprintf>
  802117:	83 c4 10             	add    $0x10,%esp
		break;
  80211a:	90                   	nop
	}
	return va;
  80211b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    

00802120 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
  802123:	53                   	push   %ebx
  802124:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802127:	83 ec 0c             	sub    $0xc,%esp
  80212a:	68 64 48 80 00       	push   $0x804864
  80212f:	e8 43 e5 ff ff       	call   800677 <cprintf>
  802134:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802137:	83 ec 0c             	sub    $0xc,%esp
  80213a:	68 8f 48 80 00       	push   $0x80488f
  80213f:	e8 33 e5 ff ff       	call   800677 <cprintf>
  802144:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80214d:	eb 37                	jmp    802186 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80214f:	83 ec 0c             	sub    $0xc,%esp
  802152:	ff 75 f4             	pushl  -0xc(%ebp)
  802155:	e8 19 ff ff ff       	call   802073 <is_free_block>
  80215a:	83 c4 10             	add    $0x10,%esp
  80215d:	0f be d8             	movsbl %al,%ebx
  802160:	83 ec 0c             	sub    $0xc,%esp
  802163:	ff 75 f4             	pushl  -0xc(%ebp)
  802166:	e8 ef fe ff ff       	call   80205a <get_block_size>
  80216b:	83 c4 10             	add    $0x10,%esp
  80216e:	83 ec 04             	sub    $0x4,%esp
  802171:	53                   	push   %ebx
  802172:	50                   	push   %eax
  802173:	68 a7 48 80 00       	push   $0x8048a7
  802178:	e8 fa e4 ff ff       	call   800677 <cprintf>
  80217d:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802180:	8b 45 10             	mov    0x10(%ebp),%eax
  802183:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802186:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80218a:	74 07                	je     802193 <print_blocks_list+0x73>
  80218c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218f:	8b 00                	mov    (%eax),%eax
  802191:	eb 05                	jmp    802198 <print_blocks_list+0x78>
  802193:	b8 00 00 00 00       	mov    $0x0,%eax
  802198:	89 45 10             	mov    %eax,0x10(%ebp)
  80219b:	8b 45 10             	mov    0x10(%ebp),%eax
  80219e:	85 c0                	test   %eax,%eax
  8021a0:	75 ad                	jne    80214f <print_blocks_list+0x2f>
  8021a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a6:	75 a7                	jne    80214f <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8021a8:	83 ec 0c             	sub    $0xc,%esp
  8021ab:	68 64 48 80 00       	push   $0x804864
  8021b0:	e8 c2 e4 ff ff       	call   800677 <cprintf>
  8021b5:	83 c4 10             	add    $0x10,%esp

}
  8021b8:	90                   	nop
  8021b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    

008021be <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
  8021c1:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8021c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c7:	83 e0 01             	and    $0x1,%eax
  8021ca:	85 c0                	test   %eax,%eax
  8021cc:	74 03                	je     8021d1 <initialize_dynamic_allocator+0x13>
  8021ce:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8021d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021d5:	0f 84 c7 01 00 00    	je     8023a2 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8021db:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  8021e2:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8021e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021eb:	01 d0                	add    %edx,%eax
  8021ed:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8021f2:	0f 87 ad 01 00 00    	ja     8023a5 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	85 c0                	test   %eax,%eax
  8021fd:	0f 89 a5 01 00 00    	jns    8023a8 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802203:	8b 55 08             	mov    0x8(%ebp),%edx
  802206:	8b 45 0c             	mov    0xc(%ebp),%eax
  802209:	01 d0                	add    %edx,%eax
  80220b:	83 e8 04             	sub    $0x4,%eax
  80220e:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  802213:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80221a:	a1 30 50 80 00       	mov    0x805030,%eax
  80221f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802222:	e9 87 00 00 00       	jmp    8022ae <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802227:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222b:	75 14                	jne    802241 <initialize_dynamic_allocator+0x83>
  80222d:	83 ec 04             	sub    $0x4,%esp
  802230:	68 bf 48 80 00       	push   $0x8048bf
  802235:	6a 79                	push   $0x79
  802237:	68 dd 48 80 00       	push   $0x8048dd
  80223c:	e8 79 e1 ff ff       	call   8003ba <_panic>
  802241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802244:	8b 00                	mov    (%eax),%eax
  802246:	85 c0                	test   %eax,%eax
  802248:	74 10                	je     80225a <initialize_dynamic_allocator+0x9c>
  80224a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224d:	8b 00                	mov    (%eax),%eax
  80224f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802252:	8b 52 04             	mov    0x4(%edx),%edx
  802255:	89 50 04             	mov    %edx,0x4(%eax)
  802258:	eb 0b                	jmp    802265 <initialize_dynamic_allocator+0xa7>
  80225a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225d:	8b 40 04             	mov    0x4(%eax),%eax
  802260:	a3 34 50 80 00       	mov    %eax,0x805034
  802265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802268:	8b 40 04             	mov    0x4(%eax),%eax
  80226b:	85 c0                	test   %eax,%eax
  80226d:	74 0f                	je     80227e <initialize_dynamic_allocator+0xc0>
  80226f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802272:	8b 40 04             	mov    0x4(%eax),%eax
  802275:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802278:	8b 12                	mov    (%edx),%edx
  80227a:	89 10                	mov    %edx,(%eax)
  80227c:	eb 0a                	jmp    802288 <initialize_dynamic_allocator+0xca>
  80227e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802281:	8b 00                	mov    (%eax),%eax
  802283:	a3 30 50 80 00       	mov    %eax,0x805030
  802288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802294:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80229b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8022a0:	48                   	dec    %eax
  8022a1:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8022a6:	a1 38 50 80 00       	mov    0x805038,%eax
  8022ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b2:	74 07                	je     8022bb <initialize_dynamic_allocator+0xfd>
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	8b 00                	mov    (%eax),%eax
  8022b9:	eb 05                	jmp    8022c0 <initialize_dynamic_allocator+0x102>
  8022bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c0:	a3 38 50 80 00       	mov    %eax,0x805038
  8022c5:	a1 38 50 80 00       	mov    0x805038,%eax
  8022ca:	85 c0                	test   %eax,%eax
  8022cc:	0f 85 55 ff ff ff    	jne    802227 <initialize_dynamic_allocator+0x69>
  8022d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d6:	0f 85 4b ff ff ff    	jne    802227 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8022dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022df:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8022e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8022eb:	a1 48 50 80 00       	mov    0x805048,%eax
  8022f0:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  8022f5:	a1 44 50 80 00       	mov    0x805044,%eax
  8022fa:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	83 c0 08             	add    $0x8,%eax
  802306:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	83 c0 04             	add    $0x4,%eax
  80230f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802312:	83 ea 08             	sub    $0x8,%edx
  802315:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802317:	8b 55 0c             	mov    0xc(%ebp),%edx
  80231a:	8b 45 08             	mov    0x8(%ebp),%eax
  80231d:	01 d0                	add    %edx,%eax
  80231f:	83 e8 08             	sub    $0x8,%eax
  802322:	8b 55 0c             	mov    0xc(%ebp),%edx
  802325:	83 ea 08             	sub    $0x8,%edx
  802328:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80232a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80232d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802333:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802336:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80233d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802341:	75 17                	jne    80235a <initialize_dynamic_allocator+0x19c>
  802343:	83 ec 04             	sub    $0x4,%esp
  802346:	68 f8 48 80 00       	push   $0x8048f8
  80234b:	68 90 00 00 00       	push   $0x90
  802350:	68 dd 48 80 00       	push   $0x8048dd
  802355:	e8 60 e0 ff ff       	call   8003ba <_panic>
  80235a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802360:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802363:	89 10                	mov    %edx,(%eax)
  802365:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802368:	8b 00                	mov    (%eax),%eax
  80236a:	85 c0                	test   %eax,%eax
  80236c:	74 0d                	je     80237b <initialize_dynamic_allocator+0x1bd>
  80236e:	a1 30 50 80 00       	mov    0x805030,%eax
  802373:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802376:	89 50 04             	mov    %edx,0x4(%eax)
  802379:	eb 08                	jmp    802383 <initialize_dynamic_allocator+0x1c5>
  80237b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80237e:	a3 34 50 80 00       	mov    %eax,0x805034
  802383:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802386:	a3 30 50 80 00       	mov    %eax,0x805030
  80238b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80238e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802395:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80239a:	40                   	inc    %eax
  80239b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8023a0:	eb 07                	jmp    8023a9 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8023a2:	90                   	nop
  8023a3:	eb 04                	jmp    8023a9 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8023a5:	90                   	nop
  8023a6:	eb 01                	jmp    8023a9 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8023a8:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8023ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8023b1:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8023b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b7:	8d 50 fc             	lea    -0x4(%eax),%edx
  8023ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023bd:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8023bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c2:	83 e8 04             	sub    $0x4,%eax
  8023c5:	8b 00                	mov    (%eax),%eax
  8023c7:	83 e0 fe             	and    $0xfffffffe,%eax
  8023ca:	8d 50 f8             	lea    -0x8(%eax),%edx
  8023cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d0:	01 c2                	add    %eax,%edx
  8023d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d5:	89 02                	mov    %eax,(%edx)
}
  8023d7:	90                   	nop
  8023d8:	5d                   	pop    %ebp
  8023d9:	c3                   	ret    

008023da <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8023da:	55                   	push   %ebp
  8023db:	89 e5                	mov    %esp,%ebp
  8023dd:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8023e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e3:	83 e0 01             	and    $0x1,%eax
  8023e6:	85 c0                	test   %eax,%eax
  8023e8:	74 03                	je     8023ed <alloc_block_FF+0x13>
  8023ea:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8023ed:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8023f1:	77 07                	ja     8023fa <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8023f3:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8023fa:	a1 28 50 80 00       	mov    0x805028,%eax
  8023ff:	85 c0                	test   %eax,%eax
  802401:	75 73                	jne    802476 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802403:	8b 45 08             	mov    0x8(%ebp),%eax
  802406:	83 c0 10             	add    $0x10,%eax
  802409:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80240c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802413:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802416:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802419:	01 d0                	add    %edx,%eax
  80241b:	48                   	dec    %eax
  80241c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80241f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802422:	ba 00 00 00 00       	mov    $0x0,%edx
  802427:	f7 75 ec             	divl   -0x14(%ebp)
  80242a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80242d:	29 d0                	sub    %edx,%eax
  80242f:	c1 e8 0c             	shr    $0xc,%eax
  802432:	83 ec 0c             	sub    $0xc,%esp
  802435:	50                   	push   %eax
  802436:	e8 d6 ef ff ff       	call   801411 <sbrk>
  80243b:	83 c4 10             	add    $0x10,%esp
  80243e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802441:	83 ec 0c             	sub    $0xc,%esp
  802444:	6a 00                	push   $0x0
  802446:	e8 c6 ef ff ff       	call   801411 <sbrk>
  80244b:	83 c4 10             	add    $0x10,%esp
  80244e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802451:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802454:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802457:	83 ec 08             	sub    $0x8,%esp
  80245a:	50                   	push   %eax
  80245b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80245e:	e8 5b fd ff ff       	call   8021be <initialize_dynamic_allocator>
  802463:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802466:	83 ec 0c             	sub    $0xc,%esp
  802469:	68 1b 49 80 00       	push   $0x80491b
  80246e:	e8 04 e2 ff ff       	call   800677 <cprintf>
  802473:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802476:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80247a:	75 0a                	jne    802486 <alloc_block_FF+0xac>
	        return NULL;
  80247c:	b8 00 00 00 00       	mov    $0x0,%eax
  802481:	e9 0e 04 00 00       	jmp    802894 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802486:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80248d:	a1 30 50 80 00       	mov    0x805030,%eax
  802492:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802495:	e9 f3 02 00 00       	jmp    80278d <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249d:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8024a0:	83 ec 0c             	sub    $0xc,%esp
  8024a3:	ff 75 bc             	pushl  -0x44(%ebp)
  8024a6:	e8 af fb ff ff       	call   80205a <get_block_size>
  8024ab:	83 c4 10             	add    $0x10,%esp
  8024ae:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8024b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b4:	83 c0 08             	add    $0x8,%eax
  8024b7:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024ba:	0f 87 c5 02 00 00    	ja     802785 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8024c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c3:	83 c0 18             	add    $0x18,%eax
  8024c6:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024c9:	0f 87 19 02 00 00    	ja     8026e8 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8024cf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024d2:	2b 45 08             	sub    0x8(%ebp),%eax
  8024d5:	83 e8 08             	sub    $0x8,%eax
  8024d8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8024db:	8b 45 08             	mov    0x8(%ebp),%eax
  8024de:	8d 50 08             	lea    0x8(%eax),%edx
  8024e1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024e4:	01 d0                	add    %edx,%eax
  8024e6:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8024e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ec:	83 c0 08             	add    $0x8,%eax
  8024ef:	83 ec 04             	sub    $0x4,%esp
  8024f2:	6a 01                	push   $0x1
  8024f4:	50                   	push   %eax
  8024f5:	ff 75 bc             	pushl  -0x44(%ebp)
  8024f8:	e8 ae fe ff ff       	call   8023ab <set_block_data>
  8024fd:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	8b 40 04             	mov    0x4(%eax),%eax
  802506:	85 c0                	test   %eax,%eax
  802508:	75 68                	jne    802572 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80250a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80250e:	75 17                	jne    802527 <alloc_block_FF+0x14d>
  802510:	83 ec 04             	sub    $0x4,%esp
  802513:	68 f8 48 80 00       	push   $0x8048f8
  802518:	68 d7 00 00 00       	push   $0xd7
  80251d:	68 dd 48 80 00       	push   $0x8048dd
  802522:	e8 93 de ff ff       	call   8003ba <_panic>
  802527:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80252d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802530:	89 10                	mov    %edx,(%eax)
  802532:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802535:	8b 00                	mov    (%eax),%eax
  802537:	85 c0                	test   %eax,%eax
  802539:	74 0d                	je     802548 <alloc_block_FF+0x16e>
  80253b:	a1 30 50 80 00       	mov    0x805030,%eax
  802540:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802543:	89 50 04             	mov    %edx,0x4(%eax)
  802546:	eb 08                	jmp    802550 <alloc_block_FF+0x176>
  802548:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80254b:	a3 34 50 80 00       	mov    %eax,0x805034
  802550:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802553:	a3 30 50 80 00       	mov    %eax,0x805030
  802558:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80255b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802562:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802567:	40                   	inc    %eax
  802568:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80256d:	e9 dc 00 00 00       	jmp    80264e <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802575:	8b 00                	mov    (%eax),%eax
  802577:	85 c0                	test   %eax,%eax
  802579:	75 65                	jne    8025e0 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80257b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80257f:	75 17                	jne    802598 <alloc_block_FF+0x1be>
  802581:	83 ec 04             	sub    $0x4,%esp
  802584:	68 2c 49 80 00       	push   $0x80492c
  802589:	68 db 00 00 00       	push   $0xdb
  80258e:	68 dd 48 80 00       	push   $0x8048dd
  802593:	e8 22 de ff ff       	call   8003ba <_panic>
  802598:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80259e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025a1:	89 50 04             	mov    %edx,0x4(%eax)
  8025a4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025a7:	8b 40 04             	mov    0x4(%eax),%eax
  8025aa:	85 c0                	test   %eax,%eax
  8025ac:	74 0c                	je     8025ba <alloc_block_FF+0x1e0>
  8025ae:	a1 34 50 80 00       	mov    0x805034,%eax
  8025b3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025b6:	89 10                	mov    %edx,(%eax)
  8025b8:	eb 08                	jmp    8025c2 <alloc_block_FF+0x1e8>
  8025ba:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025bd:	a3 30 50 80 00       	mov    %eax,0x805030
  8025c2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025c5:	a3 34 50 80 00       	mov    %eax,0x805034
  8025ca:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8025d8:	40                   	inc    %eax
  8025d9:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8025de:	eb 6e                	jmp    80264e <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8025e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e4:	74 06                	je     8025ec <alloc_block_FF+0x212>
  8025e6:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025ea:	75 17                	jne    802603 <alloc_block_FF+0x229>
  8025ec:	83 ec 04             	sub    $0x4,%esp
  8025ef:	68 50 49 80 00       	push   $0x804950
  8025f4:	68 df 00 00 00       	push   $0xdf
  8025f9:	68 dd 48 80 00       	push   $0x8048dd
  8025fe:	e8 b7 dd ff ff       	call   8003ba <_panic>
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	8b 10                	mov    (%eax),%edx
  802608:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80260b:	89 10                	mov    %edx,(%eax)
  80260d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802610:	8b 00                	mov    (%eax),%eax
  802612:	85 c0                	test   %eax,%eax
  802614:	74 0b                	je     802621 <alloc_block_FF+0x247>
  802616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802619:	8b 00                	mov    (%eax),%eax
  80261b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80261e:	89 50 04             	mov    %edx,0x4(%eax)
  802621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802624:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802627:	89 10                	mov    %edx,(%eax)
  802629:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80262c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262f:	89 50 04             	mov    %edx,0x4(%eax)
  802632:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802635:	8b 00                	mov    (%eax),%eax
  802637:	85 c0                	test   %eax,%eax
  802639:	75 08                	jne    802643 <alloc_block_FF+0x269>
  80263b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80263e:	a3 34 50 80 00       	mov    %eax,0x805034
  802643:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802648:	40                   	inc    %eax
  802649:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80264e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802652:	75 17                	jne    80266b <alloc_block_FF+0x291>
  802654:	83 ec 04             	sub    $0x4,%esp
  802657:	68 bf 48 80 00       	push   $0x8048bf
  80265c:	68 e1 00 00 00       	push   $0xe1
  802661:	68 dd 48 80 00       	push   $0x8048dd
  802666:	e8 4f dd ff ff       	call   8003ba <_panic>
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	8b 00                	mov    (%eax),%eax
  802670:	85 c0                	test   %eax,%eax
  802672:	74 10                	je     802684 <alloc_block_FF+0x2aa>
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 00                	mov    (%eax),%eax
  802679:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267c:	8b 52 04             	mov    0x4(%edx),%edx
  80267f:	89 50 04             	mov    %edx,0x4(%eax)
  802682:	eb 0b                	jmp    80268f <alloc_block_FF+0x2b5>
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	8b 40 04             	mov    0x4(%eax),%eax
  80268a:	a3 34 50 80 00       	mov    %eax,0x805034
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 40 04             	mov    0x4(%eax),%eax
  802695:	85 c0                	test   %eax,%eax
  802697:	74 0f                	je     8026a8 <alloc_block_FF+0x2ce>
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	8b 40 04             	mov    0x4(%eax),%eax
  80269f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a2:	8b 12                	mov    (%edx),%edx
  8026a4:	89 10                	mov    %edx,(%eax)
  8026a6:	eb 0a                	jmp    8026b2 <alloc_block_FF+0x2d8>
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 00                	mov    (%eax),%eax
  8026ad:	a3 30 50 80 00       	mov    %eax,0x805030
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026c5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8026ca:	48                   	dec    %eax
  8026cb:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  8026d0:	83 ec 04             	sub    $0x4,%esp
  8026d3:	6a 00                	push   $0x0
  8026d5:	ff 75 b4             	pushl  -0x4c(%ebp)
  8026d8:	ff 75 b0             	pushl  -0x50(%ebp)
  8026db:	e8 cb fc ff ff       	call   8023ab <set_block_data>
  8026e0:	83 c4 10             	add    $0x10,%esp
  8026e3:	e9 95 00 00 00       	jmp    80277d <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8026e8:	83 ec 04             	sub    $0x4,%esp
  8026eb:	6a 01                	push   $0x1
  8026ed:	ff 75 b8             	pushl  -0x48(%ebp)
  8026f0:	ff 75 bc             	pushl  -0x44(%ebp)
  8026f3:	e8 b3 fc ff ff       	call   8023ab <set_block_data>
  8026f8:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8026fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ff:	75 17                	jne    802718 <alloc_block_FF+0x33e>
  802701:	83 ec 04             	sub    $0x4,%esp
  802704:	68 bf 48 80 00       	push   $0x8048bf
  802709:	68 e8 00 00 00       	push   $0xe8
  80270e:	68 dd 48 80 00       	push   $0x8048dd
  802713:	e8 a2 dc ff ff       	call   8003ba <_panic>
  802718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271b:	8b 00                	mov    (%eax),%eax
  80271d:	85 c0                	test   %eax,%eax
  80271f:	74 10                	je     802731 <alloc_block_FF+0x357>
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	8b 00                	mov    (%eax),%eax
  802726:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802729:	8b 52 04             	mov    0x4(%edx),%edx
  80272c:	89 50 04             	mov    %edx,0x4(%eax)
  80272f:	eb 0b                	jmp    80273c <alloc_block_FF+0x362>
  802731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802734:	8b 40 04             	mov    0x4(%eax),%eax
  802737:	a3 34 50 80 00       	mov    %eax,0x805034
  80273c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273f:	8b 40 04             	mov    0x4(%eax),%eax
  802742:	85 c0                	test   %eax,%eax
  802744:	74 0f                	je     802755 <alloc_block_FF+0x37b>
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	8b 40 04             	mov    0x4(%eax),%eax
  80274c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80274f:	8b 12                	mov    (%edx),%edx
  802751:	89 10                	mov    %edx,(%eax)
  802753:	eb 0a                	jmp    80275f <alloc_block_FF+0x385>
  802755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802758:	8b 00                	mov    (%eax),%eax
  80275a:	a3 30 50 80 00       	mov    %eax,0x805030
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802772:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802777:	48                   	dec    %eax
  802778:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  80277d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802780:	e9 0f 01 00 00       	jmp    802894 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802785:	a1 38 50 80 00       	mov    0x805038,%eax
  80278a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80278d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802791:	74 07                	je     80279a <alloc_block_FF+0x3c0>
  802793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802796:	8b 00                	mov    (%eax),%eax
  802798:	eb 05                	jmp    80279f <alloc_block_FF+0x3c5>
  80279a:	b8 00 00 00 00       	mov    $0x0,%eax
  80279f:	a3 38 50 80 00       	mov    %eax,0x805038
  8027a4:	a1 38 50 80 00       	mov    0x805038,%eax
  8027a9:	85 c0                	test   %eax,%eax
  8027ab:	0f 85 e9 fc ff ff    	jne    80249a <alloc_block_FF+0xc0>
  8027b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b5:	0f 85 df fc ff ff    	jne    80249a <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8027bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027be:	83 c0 08             	add    $0x8,%eax
  8027c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8027c4:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8027cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8027d1:	01 d0                	add    %edx,%eax
  8027d3:	48                   	dec    %eax
  8027d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8027d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027da:	ba 00 00 00 00       	mov    $0x0,%edx
  8027df:	f7 75 d8             	divl   -0x28(%ebp)
  8027e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027e5:	29 d0                	sub    %edx,%eax
  8027e7:	c1 e8 0c             	shr    $0xc,%eax
  8027ea:	83 ec 0c             	sub    $0xc,%esp
  8027ed:	50                   	push   %eax
  8027ee:	e8 1e ec ff ff       	call   801411 <sbrk>
  8027f3:	83 c4 10             	add    $0x10,%esp
  8027f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8027f9:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8027fd:	75 0a                	jne    802809 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8027ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802804:	e9 8b 00 00 00       	jmp    802894 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802809:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802810:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802813:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802816:	01 d0                	add    %edx,%eax
  802818:	48                   	dec    %eax
  802819:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80281c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80281f:	ba 00 00 00 00       	mov    $0x0,%edx
  802824:	f7 75 cc             	divl   -0x34(%ebp)
  802827:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80282a:	29 d0                	sub    %edx,%eax
  80282c:	8d 50 fc             	lea    -0x4(%eax),%edx
  80282f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802832:	01 d0                	add    %edx,%eax
  802834:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802839:	a1 44 50 80 00       	mov    0x805044,%eax
  80283e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802844:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80284b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80284e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802851:	01 d0                	add    %edx,%eax
  802853:	48                   	dec    %eax
  802854:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802857:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80285a:	ba 00 00 00 00       	mov    $0x0,%edx
  80285f:	f7 75 c4             	divl   -0x3c(%ebp)
  802862:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802865:	29 d0                	sub    %edx,%eax
  802867:	83 ec 04             	sub    $0x4,%esp
  80286a:	6a 01                	push   $0x1
  80286c:	50                   	push   %eax
  80286d:	ff 75 d0             	pushl  -0x30(%ebp)
  802870:	e8 36 fb ff ff       	call   8023ab <set_block_data>
  802875:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802878:	83 ec 0c             	sub    $0xc,%esp
  80287b:	ff 75 d0             	pushl  -0x30(%ebp)
  80287e:	e8 1b 0a 00 00       	call   80329e <free_block>
  802883:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802886:	83 ec 0c             	sub    $0xc,%esp
  802889:	ff 75 08             	pushl  0x8(%ebp)
  80288c:	e8 49 fb ff ff       	call   8023da <alloc_block_FF>
  802891:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802894:	c9                   	leave  
  802895:	c3                   	ret    

00802896 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802896:	55                   	push   %ebp
  802897:	89 e5                	mov    %esp,%ebp
  802899:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80289c:	8b 45 08             	mov    0x8(%ebp),%eax
  80289f:	83 e0 01             	and    $0x1,%eax
  8028a2:	85 c0                	test   %eax,%eax
  8028a4:	74 03                	je     8028a9 <alloc_block_BF+0x13>
  8028a6:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8028a9:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8028ad:	77 07                	ja     8028b6 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8028af:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8028b6:	a1 28 50 80 00       	mov    0x805028,%eax
  8028bb:	85 c0                	test   %eax,%eax
  8028bd:	75 73                	jne    802932 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8028bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c2:	83 c0 10             	add    $0x10,%eax
  8028c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8028c8:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8028cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d5:	01 d0                	add    %edx,%eax
  8028d7:	48                   	dec    %eax
  8028d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8028db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028de:	ba 00 00 00 00       	mov    $0x0,%edx
  8028e3:	f7 75 e0             	divl   -0x20(%ebp)
  8028e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028e9:	29 d0                	sub    %edx,%eax
  8028eb:	c1 e8 0c             	shr    $0xc,%eax
  8028ee:	83 ec 0c             	sub    $0xc,%esp
  8028f1:	50                   	push   %eax
  8028f2:	e8 1a eb ff ff       	call   801411 <sbrk>
  8028f7:	83 c4 10             	add    $0x10,%esp
  8028fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8028fd:	83 ec 0c             	sub    $0xc,%esp
  802900:	6a 00                	push   $0x0
  802902:	e8 0a eb ff ff       	call   801411 <sbrk>
  802907:	83 c4 10             	add    $0x10,%esp
  80290a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80290d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802910:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802913:	83 ec 08             	sub    $0x8,%esp
  802916:	50                   	push   %eax
  802917:	ff 75 d8             	pushl  -0x28(%ebp)
  80291a:	e8 9f f8 ff ff       	call   8021be <initialize_dynamic_allocator>
  80291f:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802922:	83 ec 0c             	sub    $0xc,%esp
  802925:	68 1b 49 80 00       	push   $0x80491b
  80292a:	e8 48 dd ff ff       	call   800677 <cprintf>
  80292f:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802932:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802939:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802940:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802947:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80294e:	a1 30 50 80 00       	mov    0x805030,%eax
  802953:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802956:	e9 1d 01 00 00       	jmp    802a78 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802961:	83 ec 0c             	sub    $0xc,%esp
  802964:	ff 75 a8             	pushl  -0x58(%ebp)
  802967:	e8 ee f6 ff ff       	call   80205a <get_block_size>
  80296c:	83 c4 10             	add    $0x10,%esp
  80296f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802972:	8b 45 08             	mov    0x8(%ebp),%eax
  802975:	83 c0 08             	add    $0x8,%eax
  802978:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80297b:	0f 87 ef 00 00 00    	ja     802a70 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802981:	8b 45 08             	mov    0x8(%ebp),%eax
  802984:	83 c0 18             	add    $0x18,%eax
  802987:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80298a:	77 1d                	ja     8029a9 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80298c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802992:	0f 86 d8 00 00 00    	jbe    802a70 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802998:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80299b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80299e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8029a4:	e9 c7 00 00 00       	jmp    802a70 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8029a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ac:	83 c0 08             	add    $0x8,%eax
  8029af:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029b2:	0f 85 9d 00 00 00    	jne    802a55 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8029b8:	83 ec 04             	sub    $0x4,%esp
  8029bb:	6a 01                	push   $0x1
  8029bd:	ff 75 a4             	pushl  -0x5c(%ebp)
  8029c0:	ff 75 a8             	pushl  -0x58(%ebp)
  8029c3:	e8 e3 f9 ff ff       	call   8023ab <set_block_data>
  8029c8:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8029cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029cf:	75 17                	jne    8029e8 <alloc_block_BF+0x152>
  8029d1:	83 ec 04             	sub    $0x4,%esp
  8029d4:	68 bf 48 80 00       	push   $0x8048bf
  8029d9:	68 2c 01 00 00       	push   $0x12c
  8029de:	68 dd 48 80 00       	push   $0x8048dd
  8029e3:	e8 d2 d9 ff ff       	call   8003ba <_panic>
  8029e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029eb:	8b 00                	mov    (%eax),%eax
  8029ed:	85 c0                	test   %eax,%eax
  8029ef:	74 10                	je     802a01 <alloc_block_BF+0x16b>
  8029f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f4:	8b 00                	mov    (%eax),%eax
  8029f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f9:	8b 52 04             	mov    0x4(%edx),%edx
  8029fc:	89 50 04             	mov    %edx,0x4(%eax)
  8029ff:	eb 0b                	jmp    802a0c <alloc_block_BF+0x176>
  802a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a04:	8b 40 04             	mov    0x4(%eax),%eax
  802a07:	a3 34 50 80 00       	mov    %eax,0x805034
  802a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0f:	8b 40 04             	mov    0x4(%eax),%eax
  802a12:	85 c0                	test   %eax,%eax
  802a14:	74 0f                	je     802a25 <alloc_block_BF+0x18f>
  802a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a19:	8b 40 04             	mov    0x4(%eax),%eax
  802a1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1f:	8b 12                	mov    (%edx),%edx
  802a21:	89 10                	mov    %edx,(%eax)
  802a23:	eb 0a                	jmp    802a2f <alloc_block_BF+0x199>
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	8b 00                	mov    (%eax),%eax
  802a2a:	a3 30 50 80 00       	mov    %eax,0x805030
  802a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a42:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a47:	48                   	dec    %eax
  802a48:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802a4d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a50:	e9 24 04 00 00       	jmp    802e79 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802a55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a58:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a5b:	76 13                	jbe    802a70 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802a5d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802a64:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a67:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802a6a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a6d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802a70:	a1 38 50 80 00       	mov    0x805038,%eax
  802a75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7c:	74 07                	je     802a85 <alloc_block_BF+0x1ef>
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	8b 00                	mov    (%eax),%eax
  802a83:	eb 05                	jmp    802a8a <alloc_block_BF+0x1f4>
  802a85:	b8 00 00 00 00       	mov    $0x0,%eax
  802a8a:	a3 38 50 80 00       	mov    %eax,0x805038
  802a8f:	a1 38 50 80 00       	mov    0x805038,%eax
  802a94:	85 c0                	test   %eax,%eax
  802a96:	0f 85 bf fe ff ff    	jne    80295b <alloc_block_BF+0xc5>
  802a9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa0:	0f 85 b5 fe ff ff    	jne    80295b <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802aa6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aaa:	0f 84 26 02 00 00    	je     802cd6 <alloc_block_BF+0x440>
  802ab0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ab4:	0f 85 1c 02 00 00    	jne    802cd6 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802aba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abd:	2b 45 08             	sub    0x8(%ebp),%eax
  802ac0:	83 e8 08             	sub    $0x8,%eax
  802ac3:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac9:	8d 50 08             	lea    0x8(%eax),%edx
  802acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acf:	01 d0                	add    %edx,%eax
  802ad1:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad7:	83 c0 08             	add    $0x8,%eax
  802ada:	83 ec 04             	sub    $0x4,%esp
  802add:	6a 01                	push   $0x1
  802adf:	50                   	push   %eax
  802ae0:	ff 75 f0             	pushl  -0x10(%ebp)
  802ae3:	e8 c3 f8 ff ff       	call   8023ab <set_block_data>
  802ae8:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aee:	8b 40 04             	mov    0x4(%eax),%eax
  802af1:	85 c0                	test   %eax,%eax
  802af3:	75 68                	jne    802b5d <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802af5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802af9:	75 17                	jne    802b12 <alloc_block_BF+0x27c>
  802afb:	83 ec 04             	sub    $0x4,%esp
  802afe:	68 f8 48 80 00       	push   $0x8048f8
  802b03:	68 45 01 00 00       	push   $0x145
  802b08:	68 dd 48 80 00       	push   $0x8048dd
  802b0d:	e8 a8 d8 ff ff       	call   8003ba <_panic>
  802b12:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802b18:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b1b:	89 10                	mov    %edx,(%eax)
  802b1d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b20:	8b 00                	mov    (%eax),%eax
  802b22:	85 c0                	test   %eax,%eax
  802b24:	74 0d                	je     802b33 <alloc_block_BF+0x29d>
  802b26:	a1 30 50 80 00       	mov    0x805030,%eax
  802b2b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b2e:	89 50 04             	mov    %edx,0x4(%eax)
  802b31:	eb 08                	jmp    802b3b <alloc_block_BF+0x2a5>
  802b33:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b36:	a3 34 50 80 00       	mov    %eax,0x805034
  802b3b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b3e:	a3 30 50 80 00       	mov    %eax,0x805030
  802b43:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b4d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b52:	40                   	inc    %eax
  802b53:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802b58:	e9 dc 00 00 00       	jmp    802c39 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b60:	8b 00                	mov    (%eax),%eax
  802b62:	85 c0                	test   %eax,%eax
  802b64:	75 65                	jne    802bcb <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b66:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b6a:	75 17                	jne    802b83 <alloc_block_BF+0x2ed>
  802b6c:	83 ec 04             	sub    $0x4,%esp
  802b6f:	68 2c 49 80 00       	push   $0x80492c
  802b74:	68 4a 01 00 00       	push   $0x14a
  802b79:	68 dd 48 80 00       	push   $0x8048dd
  802b7e:	e8 37 d8 ff ff       	call   8003ba <_panic>
  802b83:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802b89:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b8c:	89 50 04             	mov    %edx,0x4(%eax)
  802b8f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b92:	8b 40 04             	mov    0x4(%eax),%eax
  802b95:	85 c0                	test   %eax,%eax
  802b97:	74 0c                	je     802ba5 <alloc_block_BF+0x30f>
  802b99:	a1 34 50 80 00       	mov    0x805034,%eax
  802b9e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ba1:	89 10                	mov    %edx,(%eax)
  802ba3:	eb 08                	jmp    802bad <alloc_block_BF+0x317>
  802ba5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ba8:	a3 30 50 80 00       	mov    %eax,0x805030
  802bad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bb0:	a3 34 50 80 00       	mov    %eax,0x805034
  802bb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bbe:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802bc3:	40                   	inc    %eax
  802bc4:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802bc9:	eb 6e                	jmp    802c39 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802bcb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bcf:	74 06                	je     802bd7 <alloc_block_BF+0x341>
  802bd1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bd5:	75 17                	jne    802bee <alloc_block_BF+0x358>
  802bd7:	83 ec 04             	sub    $0x4,%esp
  802bda:	68 50 49 80 00       	push   $0x804950
  802bdf:	68 4f 01 00 00       	push   $0x14f
  802be4:	68 dd 48 80 00       	push   $0x8048dd
  802be9:	e8 cc d7 ff ff       	call   8003ba <_panic>
  802bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf1:	8b 10                	mov    (%eax),%edx
  802bf3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bf6:	89 10                	mov    %edx,(%eax)
  802bf8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bfb:	8b 00                	mov    (%eax),%eax
  802bfd:	85 c0                	test   %eax,%eax
  802bff:	74 0b                	je     802c0c <alloc_block_BF+0x376>
  802c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c04:	8b 00                	mov    (%eax),%eax
  802c06:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c09:	89 50 04             	mov    %edx,0x4(%eax)
  802c0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c12:	89 10                	mov    %edx,(%eax)
  802c14:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c1a:	89 50 04             	mov    %edx,0x4(%eax)
  802c1d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c20:	8b 00                	mov    (%eax),%eax
  802c22:	85 c0                	test   %eax,%eax
  802c24:	75 08                	jne    802c2e <alloc_block_BF+0x398>
  802c26:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c29:	a3 34 50 80 00       	mov    %eax,0x805034
  802c2e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c33:	40                   	inc    %eax
  802c34:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802c39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c3d:	75 17                	jne    802c56 <alloc_block_BF+0x3c0>
  802c3f:	83 ec 04             	sub    $0x4,%esp
  802c42:	68 bf 48 80 00       	push   $0x8048bf
  802c47:	68 51 01 00 00       	push   $0x151
  802c4c:	68 dd 48 80 00       	push   $0x8048dd
  802c51:	e8 64 d7 ff ff       	call   8003ba <_panic>
  802c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c59:	8b 00                	mov    (%eax),%eax
  802c5b:	85 c0                	test   %eax,%eax
  802c5d:	74 10                	je     802c6f <alloc_block_BF+0x3d9>
  802c5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c62:	8b 00                	mov    (%eax),%eax
  802c64:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c67:	8b 52 04             	mov    0x4(%edx),%edx
  802c6a:	89 50 04             	mov    %edx,0x4(%eax)
  802c6d:	eb 0b                	jmp    802c7a <alloc_block_BF+0x3e4>
  802c6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c72:	8b 40 04             	mov    0x4(%eax),%eax
  802c75:	a3 34 50 80 00       	mov    %eax,0x805034
  802c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7d:	8b 40 04             	mov    0x4(%eax),%eax
  802c80:	85 c0                	test   %eax,%eax
  802c82:	74 0f                	je     802c93 <alloc_block_BF+0x3fd>
  802c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c87:	8b 40 04             	mov    0x4(%eax),%eax
  802c8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c8d:	8b 12                	mov    (%edx),%edx
  802c8f:	89 10                	mov    %edx,(%eax)
  802c91:	eb 0a                	jmp    802c9d <alloc_block_BF+0x407>
  802c93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c96:	8b 00                	mov    (%eax),%eax
  802c98:	a3 30 50 80 00       	mov    %eax,0x805030
  802c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802cb5:	48                   	dec    %eax
  802cb6:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  802cbb:	83 ec 04             	sub    $0x4,%esp
  802cbe:	6a 00                	push   $0x0
  802cc0:	ff 75 d0             	pushl  -0x30(%ebp)
  802cc3:	ff 75 cc             	pushl  -0x34(%ebp)
  802cc6:	e8 e0 f6 ff ff       	call   8023ab <set_block_data>
  802ccb:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd1:	e9 a3 01 00 00       	jmp    802e79 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802cd6:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802cda:	0f 85 9d 00 00 00    	jne    802d7d <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802ce0:	83 ec 04             	sub    $0x4,%esp
  802ce3:	6a 01                	push   $0x1
  802ce5:	ff 75 ec             	pushl  -0x14(%ebp)
  802ce8:	ff 75 f0             	pushl  -0x10(%ebp)
  802ceb:	e8 bb f6 ff ff       	call   8023ab <set_block_data>
  802cf0:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802cf3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cf7:	75 17                	jne    802d10 <alloc_block_BF+0x47a>
  802cf9:	83 ec 04             	sub    $0x4,%esp
  802cfc:	68 bf 48 80 00       	push   $0x8048bf
  802d01:	68 58 01 00 00       	push   $0x158
  802d06:	68 dd 48 80 00       	push   $0x8048dd
  802d0b:	e8 aa d6 ff ff       	call   8003ba <_panic>
  802d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d13:	8b 00                	mov    (%eax),%eax
  802d15:	85 c0                	test   %eax,%eax
  802d17:	74 10                	je     802d29 <alloc_block_BF+0x493>
  802d19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1c:	8b 00                	mov    (%eax),%eax
  802d1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d21:	8b 52 04             	mov    0x4(%edx),%edx
  802d24:	89 50 04             	mov    %edx,0x4(%eax)
  802d27:	eb 0b                	jmp    802d34 <alloc_block_BF+0x49e>
  802d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2c:	8b 40 04             	mov    0x4(%eax),%eax
  802d2f:	a3 34 50 80 00       	mov    %eax,0x805034
  802d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d37:	8b 40 04             	mov    0x4(%eax),%eax
  802d3a:	85 c0                	test   %eax,%eax
  802d3c:	74 0f                	je     802d4d <alloc_block_BF+0x4b7>
  802d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d41:	8b 40 04             	mov    0x4(%eax),%eax
  802d44:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d47:	8b 12                	mov    (%edx),%edx
  802d49:	89 10                	mov    %edx,(%eax)
  802d4b:	eb 0a                	jmp    802d57 <alloc_block_BF+0x4c1>
  802d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d50:	8b 00                	mov    (%eax),%eax
  802d52:	a3 30 50 80 00       	mov    %eax,0x805030
  802d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d6a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802d6f:	48                   	dec    %eax
  802d70:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  802d75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d78:	e9 fc 00 00 00       	jmp    802e79 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d80:	83 c0 08             	add    $0x8,%eax
  802d83:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802d86:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d8d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d90:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d93:	01 d0                	add    %edx,%eax
  802d95:	48                   	dec    %eax
  802d96:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d99:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d9c:	ba 00 00 00 00       	mov    $0x0,%edx
  802da1:	f7 75 c4             	divl   -0x3c(%ebp)
  802da4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802da7:	29 d0                	sub    %edx,%eax
  802da9:	c1 e8 0c             	shr    $0xc,%eax
  802dac:	83 ec 0c             	sub    $0xc,%esp
  802daf:	50                   	push   %eax
  802db0:	e8 5c e6 ff ff       	call   801411 <sbrk>
  802db5:	83 c4 10             	add    $0x10,%esp
  802db8:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802dbb:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802dbf:	75 0a                	jne    802dcb <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802dc1:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc6:	e9 ae 00 00 00       	jmp    802e79 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802dcb:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802dd2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802dd5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802dd8:	01 d0                	add    %edx,%eax
  802dda:	48                   	dec    %eax
  802ddb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802dde:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802de1:	ba 00 00 00 00       	mov    $0x0,%edx
  802de6:	f7 75 b8             	divl   -0x48(%ebp)
  802de9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802dec:	29 d0                	sub    %edx,%eax
  802dee:	8d 50 fc             	lea    -0x4(%eax),%edx
  802df1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802df4:	01 d0                	add    %edx,%eax
  802df6:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  802dfb:	a1 44 50 80 00       	mov    0x805044,%eax
  802e00:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802e06:	83 ec 0c             	sub    $0xc,%esp
  802e09:	68 84 49 80 00       	push   $0x804984
  802e0e:	e8 64 d8 ff ff       	call   800677 <cprintf>
  802e13:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802e16:	83 ec 08             	sub    $0x8,%esp
  802e19:	ff 75 bc             	pushl  -0x44(%ebp)
  802e1c:	68 89 49 80 00       	push   $0x804989
  802e21:	e8 51 d8 ff ff       	call   800677 <cprintf>
  802e26:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e29:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802e30:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e33:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e36:	01 d0                	add    %edx,%eax
  802e38:	48                   	dec    %eax
  802e39:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802e3c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e3f:	ba 00 00 00 00       	mov    $0x0,%edx
  802e44:	f7 75 b0             	divl   -0x50(%ebp)
  802e47:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e4a:	29 d0                	sub    %edx,%eax
  802e4c:	83 ec 04             	sub    $0x4,%esp
  802e4f:	6a 01                	push   $0x1
  802e51:	50                   	push   %eax
  802e52:	ff 75 bc             	pushl  -0x44(%ebp)
  802e55:	e8 51 f5 ff ff       	call   8023ab <set_block_data>
  802e5a:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802e5d:	83 ec 0c             	sub    $0xc,%esp
  802e60:	ff 75 bc             	pushl  -0x44(%ebp)
  802e63:	e8 36 04 00 00       	call   80329e <free_block>
  802e68:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802e6b:	83 ec 0c             	sub    $0xc,%esp
  802e6e:	ff 75 08             	pushl  0x8(%ebp)
  802e71:	e8 20 fa ff ff       	call   802896 <alloc_block_BF>
  802e76:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802e79:	c9                   	leave  
  802e7a:	c3                   	ret    

00802e7b <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802e7b:	55                   	push   %ebp
  802e7c:	89 e5                	mov    %esp,%ebp
  802e7e:	53                   	push   %ebx
  802e7f:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802e82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802e89:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802e90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e94:	74 1e                	je     802eb4 <merging+0x39>
  802e96:	ff 75 08             	pushl  0x8(%ebp)
  802e99:	e8 bc f1 ff ff       	call   80205a <get_block_size>
  802e9e:	83 c4 04             	add    $0x4,%esp
  802ea1:	89 c2                	mov    %eax,%edx
  802ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea6:	01 d0                	add    %edx,%eax
  802ea8:	3b 45 10             	cmp    0x10(%ebp),%eax
  802eab:	75 07                	jne    802eb4 <merging+0x39>
		prev_is_free = 1;
  802ead:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802eb4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802eb8:	74 1e                	je     802ed8 <merging+0x5d>
  802eba:	ff 75 10             	pushl  0x10(%ebp)
  802ebd:	e8 98 f1 ff ff       	call   80205a <get_block_size>
  802ec2:	83 c4 04             	add    $0x4,%esp
  802ec5:	89 c2                	mov    %eax,%edx
  802ec7:	8b 45 10             	mov    0x10(%ebp),%eax
  802eca:	01 d0                	add    %edx,%eax
  802ecc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ecf:	75 07                	jne    802ed8 <merging+0x5d>
		next_is_free = 1;
  802ed1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802ed8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802edc:	0f 84 cc 00 00 00    	je     802fae <merging+0x133>
  802ee2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ee6:	0f 84 c2 00 00 00    	je     802fae <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802eec:	ff 75 08             	pushl  0x8(%ebp)
  802eef:	e8 66 f1 ff ff       	call   80205a <get_block_size>
  802ef4:	83 c4 04             	add    $0x4,%esp
  802ef7:	89 c3                	mov    %eax,%ebx
  802ef9:	ff 75 10             	pushl  0x10(%ebp)
  802efc:	e8 59 f1 ff ff       	call   80205a <get_block_size>
  802f01:	83 c4 04             	add    $0x4,%esp
  802f04:	01 c3                	add    %eax,%ebx
  802f06:	ff 75 0c             	pushl  0xc(%ebp)
  802f09:	e8 4c f1 ff ff       	call   80205a <get_block_size>
  802f0e:	83 c4 04             	add    $0x4,%esp
  802f11:	01 d8                	add    %ebx,%eax
  802f13:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f16:	6a 00                	push   $0x0
  802f18:	ff 75 ec             	pushl  -0x14(%ebp)
  802f1b:	ff 75 08             	pushl  0x8(%ebp)
  802f1e:	e8 88 f4 ff ff       	call   8023ab <set_block_data>
  802f23:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802f26:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f2a:	75 17                	jne    802f43 <merging+0xc8>
  802f2c:	83 ec 04             	sub    $0x4,%esp
  802f2f:	68 bf 48 80 00       	push   $0x8048bf
  802f34:	68 7d 01 00 00       	push   $0x17d
  802f39:	68 dd 48 80 00       	push   $0x8048dd
  802f3e:	e8 77 d4 ff ff       	call   8003ba <_panic>
  802f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f46:	8b 00                	mov    (%eax),%eax
  802f48:	85 c0                	test   %eax,%eax
  802f4a:	74 10                	je     802f5c <merging+0xe1>
  802f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4f:	8b 00                	mov    (%eax),%eax
  802f51:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f54:	8b 52 04             	mov    0x4(%edx),%edx
  802f57:	89 50 04             	mov    %edx,0x4(%eax)
  802f5a:	eb 0b                	jmp    802f67 <merging+0xec>
  802f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f5f:	8b 40 04             	mov    0x4(%eax),%eax
  802f62:	a3 34 50 80 00       	mov    %eax,0x805034
  802f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f6a:	8b 40 04             	mov    0x4(%eax),%eax
  802f6d:	85 c0                	test   %eax,%eax
  802f6f:	74 0f                	je     802f80 <merging+0x105>
  802f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f74:	8b 40 04             	mov    0x4(%eax),%eax
  802f77:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f7a:	8b 12                	mov    (%edx),%edx
  802f7c:	89 10                	mov    %edx,(%eax)
  802f7e:	eb 0a                	jmp    802f8a <merging+0x10f>
  802f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f83:	8b 00                	mov    (%eax),%eax
  802f85:	a3 30 50 80 00       	mov    %eax,0x805030
  802f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f93:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802fa2:	48                   	dec    %eax
  802fa3:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802fa8:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fa9:	e9 ea 02 00 00       	jmp    803298 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802fae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb2:	74 3b                	je     802fef <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802fb4:	83 ec 0c             	sub    $0xc,%esp
  802fb7:	ff 75 08             	pushl  0x8(%ebp)
  802fba:	e8 9b f0 ff ff       	call   80205a <get_block_size>
  802fbf:	83 c4 10             	add    $0x10,%esp
  802fc2:	89 c3                	mov    %eax,%ebx
  802fc4:	83 ec 0c             	sub    $0xc,%esp
  802fc7:	ff 75 10             	pushl  0x10(%ebp)
  802fca:	e8 8b f0 ff ff       	call   80205a <get_block_size>
  802fcf:	83 c4 10             	add    $0x10,%esp
  802fd2:	01 d8                	add    %ebx,%eax
  802fd4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802fd7:	83 ec 04             	sub    $0x4,%esp
  802fda:	6a 00                	push   $0x0
  802fdc:	ff 75 e8             	pushl  -0x18(%ebp)
  802fdf:	ff 75 08             	pushl  0x8(%ebp)
  802fe2:	e8 c4 f3 ff ff       	call   8023ab <set_block_data>
  802fe7:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fea:	e9 a9 02 00 00       	jmp    803298 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802fef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ff3:	0f 84 2d 01 00 00    	je     803126 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802ff9:	83 ec 0c             	sub    $0xc,%esp
  802ffc:	ff 75 10             	pushl  0x10(%ebp)
  802fff:	e8 56 f0 ff ff       	call   80205a <get_block_size>
  803004:	83 c4 10             	add    $0x10,%esp
  803007:	89 c3                	mov    %eax,%ebx
  803009:	83 ec 0c             	sub    $0xc,%esp
  80300c:	ff 75 0c             	pushl  0xc(%ebp)
  80300f:	e8 46 f0 ff ff       	call   80205a <get_block_size>
  803014:	83 c4 10             	add    $0x10,%esp
  803017:	01 d8                	add    %ebx,%eax
  803019:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80301c:	83 ec 04             	sub    $0x4,%esp
  80301f:	6a 00                	push   $0x0
  803021:	ff 75 e4             	pushl  -0x1c(%ebp)
  803024:	ff 75 10             	pushl  0x10(%ebp)
  803027:	e8 7f f3 ff ff       	call   8023ab <set_block_data>
  80302c:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80302f:	8b 45 10             	mov    0x10(%ebp),%eax
  803032:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803035:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803039:	74 06                	je     803041 <merging+0x1c6>
  80303b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80303f:	75 17                	jne    803058 <merging+0x1dd>
  803041:	83 ec 04             	sub    $0x4,%esp
  803044:	68 98 49 80 00       	push   $0x804998
  803049:	68 8d 01 00 00       	push   $0x18d
  80304e:	68 dd 48 80 00       	push   $0x8048dd
  803053:	e8 62 d3 ff ff       	call   8003ba <_panic>
  803058:	8b 45 0c             	mov    0xc(%ebp),%eax
  80305b:	8b 50 04             	mov    0x4(%eax),%edx
  80305e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803061:	89 50 04             	mov    %edx,0x4(%eax)
  803064:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803067:	8b 55 0c             	mov    0xc(%ebp),%edx
  80306a:	89 10                	mov    %edx,(%eax)
  80306c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80306f:	8b 40 04             	mov    0x4(%eax),%eax
  803072:	85 c0                	test   %eax,%eax
  803074:	74 0d                	je     803083 <merging+0x208>
  803076:	8b 45 0c             	mov    0xc(%ebp),%eax
  803079:	8b 40 04             	mov    0x4(%eax),%eax
  80307c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80307f:	89 10                	mov    %edx,(%eax)
  803081:	eb 08                	jmp    80308b <merging+0x210>
  803083:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803086:	a3 30 50 80 00       	mov    %eax,0x805030
  80308b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80308e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803091:	89 50 04             	mov    %edx,0x4(%eax)
  803094:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803099:	40                   	inc    %eax
  80309a:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  80309f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030a3:	75 17                	jne    8030bc <merging+0x241>
  8030a5:	83 ec 04             	sub    $0x4,%esp
  8030a8:	68 bf 48 80 00       	push   $0x8048bf
  8030ad:	68 8e 01 00 00       	push   $0x18e
  8030b2:	68 dd 48 80 00       	push   $0x8048dd
  8030b7:	e8 fe d2 ff ff       	call   8003ba <_panic>
  8030bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030bf:	8b 00                	mov    (%eax),%eax
  8030c1:	85 c0                	test   %eax,%eax
  8030c3:	74 10                	je     8030d5 <merging+0x25a>
  8030c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030c8:	8b 00                	mov    (%eax),%eax
  8030ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030cd:	8b 52 04             	mov    0x4(%edx),%edx
  8030d0:	89 50 04             	mov    %edx,0x4(%eax)
  8030d3:	eb 0b                	jmp    8030e0 <merging+0x265>
  8030d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d8:	8b 40 04             	mov    0x4(%eax),%eax
  8030db:	a3 34 50 80 00       	mov    %eax,0x805034
  8030e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030e3:	8b 40 04             	mov    0x4(%eax),%eax
  8030e6:	85 c0                	test   %eax,%eax
  8030e8:	74 0f                	je     8030f9 <merging+0x27e>
  8030ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ed:	8b 40 04             	mov    0x4(%eax),%eax
  8030f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030f3:	8b 12                	mov    (%edx),%edx
  8030f5:	89 10                	mov    %edx,(%eax)
  8030f7:	eb 0a                	jmp    803103 <merging+0x288>
  8030f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030fc:	8b 00                	mov    (%eax),%eax
  8030fe:	a3 30 50 80 00       	mov    %eax,0x805030
  803103:	8b 45 0c             	mov    0xc(%ebp),%eax
  803106:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80310c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80310f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803116:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80311b:	48                   	dec    %eax
  80311c:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803121:	e9 72 01 00 00       	jmp    803298 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803126:	8b 45 10             	mov    0x10(%ebp),%eax
  803129:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80312c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803130:	74 79                	je     8031ab <merging+0x330>
  803132:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803136:	74 73                	je     8031ab <merging+0x330>
  803138:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80313c:	74 06                	je     803144 <merging+0x2c9>
  80313e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803142:	75 17                	jne    80315b <merging+0x2e0>
  803144:	83 ec 04             	sub    $0x4,%esp
  803147:	68 50 49 80 00       	push   $0x804950
  80314c:	68 94 01 00 00       	push   $0x194
  803151:	68 dd 48 80 00       	push   $0x8048dd
  803156:	e8 5f d2 ff ff       	call   8003ba <_panic>
  80315b:	8b 45 08             	mov    0x8(%ebp),%eax
  80315e:	8b 10                	mov    (%eax),%edx
  803160:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803163:	89 10                	mov    %edx,(%eax)
  803165:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803168:	8b 00                	mov    (%eax),%eax
  80316a:	85 c0                	test   %eax,%eax
  80316c:	74 0b                	je     803179 <merging+0x2fe>
  80316e:	8b 45 08             	mov    0x8(%ebp),%eax
  803171:	8b 00                	mov    (%eax),%eax
  803173:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803176:	89 50 04             	mov    %edx,0x4(%eax)
  803179:	8b 45 08             	mov    0x8(%ebp),%eax
  80317c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80317f:	89 10                	mov    %edx,(%eax)
  803181:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803184:	8b 55 08             	mov    0x8(%ebp),%edx
  803187:	89 50 04             	mov    %edx,0x4(%eax)
  80318a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80318d:	8b 00                	mov    (%eax),%eax
  80318f:	85 c0                	test   %eax,%eax
  803191:	75 08                	jne    80319b <merging+0x320>
  803193:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803196:	a3 34 50 80 00       	mov    %eax,0x805034
  80319b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8031a0:	40                   	inc    %eax
  8031a1:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8031a6:	e9 ce 00 00 00       	jmp    803279 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8031ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031af:	74 65                	je     803216 <merging+0x39b>
  8031b1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031b5:	75 17                	jne    8031ce <merging+0x353>
  8031b7:	83 ec 04             	sub    $0x4,%esp
  8031ba:	68 2c 49 80 00       	push   $0x80492c
  8031bf:	68 95 01 00 00       	push   $0x195
  8031c4:	68 dd 48 80 00       	push   $0x8048dd
  8031c9:	e8 ec d1 ff ff       	call   8003ba <_panic>
  8031ce:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8031d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031d7:	89 50 04             	mov    %edx,0x4(%eax)
  8031da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031dd:	8b 40 04             	mov    0x4(%eax),%eax
  8031e0:	85 c0                	test   %eax,%eax
  8031e2:	74 0c                	je     8031f0 <merging+0x375>
  8031e4:	a1 34 50 80 00       	mov    0x805034,%eax
  8031e9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031ec:	89 10                	mov    %edx,(%eax)
  8031ee:	eb 08                	jmp    8031f8 <merging+0x37d>
  8031f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f3:	a3 30 50 80 00       	mov    %eax,0x805030
  8031f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031fb:	a3 34 50 80 00       	mov    %eax,0x805034
  803200:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803203:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803209:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80320e:	40                   	inc    %eax
  80320f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803214:	eb 63                	jmp    803279 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803216:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80321a:	75 17                	jne    803233 <merging+0x3b8>
  80321c:	83 ec 04             	sub    $0x4,%esp
  80321f:	68 f8 48 80 00       	push   $0x8048f8
  803224:	68 98 01 00 00       	push   $0x198
  803229:	68 dd 48 80 00       	push   $0x8048dd
  80322e:	e8 87 d1 ff ff       	call   8003ba <_panic>
  803233:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803239:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80323c:	89 10                	mov    %edx,(%eax)
  80323e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803241:	8b 00                	mov    (%eax),%eax
  803243:	85 c0                	test   %eax,%eax
  803245:	74 0d                	je     803254 <merging+0x3d9>
  803247:	a1 30 50 80 00       	mov    0x805030,%eax
  80324c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80324f:	89 50 04             	mov    %edx,0x4(%eax)
  803252:	eb 08                	jmp    80325c <merging+0x3e1>
  803254:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803257:	a3 34 50 80 00       	mov    %eax,0x805034
  80325c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80325f:	a3 30 50 80 00       	mov    %eax,0x805030
  803264:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803267:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80326e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803273:	40                   	inc    %eax
  803274:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  803279:	83 ec 0c             	sub    $0xc,%esp
  80327c:	ff 75 10             	pushl  0x10(%ebp)
  80327f:	e8 d6 ed ff ff       	call   80205a <get_block_size>
  803284:	83 c4 10             	add    $0x10,%esp
  803287:	83 ec 04             	sub    $0x4,%esp
  80328a:	6a 00                	push   $0x0
  80328c:	50                   	push   %eax
  80328d:	ff 75 10             	pushl  0x10(%ebp)
  803290:	e8 16 f1 ff ff       	call   8023ab <set_block_data>
  803295:	83 c4 10             	add    $0x10,%esp
	}
}
  803298:	90                   	nop
  803299:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80329c:	c9                   	leave  
  80329d:	c3                   	ret    

0080329e <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80329e:	55                   	push   %ebp
  80329f:	89 e5                	mov    %esp,%ebp
  8032a1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8032a4:	a1 30 50 80 00       	mov    0x805030,%eax
  8032a9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8032ac:	a1 34 50 80 00       	mov    0x805034,%eax
  8032b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032b4:	73 1b                	jae    8032d1 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8032b6:	a1 34 50 80 00       	mov    0x805034,%eax
  8032bb:	83 ec 04             	sub    $0x4,%esp
  8032be:	ff 75 08             	pushl  0x8(%ebp)
  8032c1:	6a 00                	push   $0x0
  8032c3:	50                   	push   %eax
  8032c4:	e8 b2 fb ff ff       	call   802e7b <merging>
  8032c9:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032cc:	e9 8b 00 00 00       	jmp    80335c <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8032d1:	a1 30 50 80 00       	mov    0x805030,%eax
  8032d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032d9:	76 18                	jbe    8032f3 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8032db:	a1 30 50 80 00       	mov    0x805030,%eax
  8032e0:	83 ec 04             	sub    $0x4,%esp
  8032e3:	ff 75 08             	pushl  0x8(%ebp)
  8032e6:	50                   	push   %eax
  8032e7:	6a 00                	push   $0x0
  8032e9:	e8 8d fb ff ff       	call   802e7b <merging>
  8032ee:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032f1:	eb 69                	jmp    80335c <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8032f3:	a1 30 50 80 00       	mov    0x805030,%eax
  8032f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032fb:	eb 39                	jmp    803336 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8032fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803300:	3b 45 08             	cmp    0x8(%ebp),%eax
  803303:	73 29                	jae    80332e <free_block+0x90>
  803305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803308:	8b 00                	mov    (%eax),%eax
  80330a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80330d:	76 1f                	jbe    80332e <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80330f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803312:	8b 00                	mov    (%eax),%eax
  803314:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803317:	83 ec 04             	sub    $0x4,%esp
  80331a:	ff 75 08             	pushl  0x8(%ebp)
  80331d:	ff 75 f0             	pushl  -0x10(%ebp)
  803320:	ff 75 f4             	pushl  -0xc(%ebp)
  803323:	e8 53 fb ff ff       	call   802e7b <merging>
  803328:	83 c4 10             	add    $0x10,%esp
			break;
  80332b:	90                   	nop
		}
	}
}
  80332c:	eb 2e                	jmp    80335c <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80332e:	a1 38 50 80 00       	mov    0x805038,%eax
  803333:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803336:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80333a:	74 07                	je     803343 <free_block+0xa5>
  80333c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333f:	8b 00                	mov    (%eax),%eax
  803341:	eb 05                	jmp    803348 <free_block+0xaa>
  803343:	b8 00 00 00 00       	mov    $0x0,%eax
  803348:	a3 38 50 80 00       	mov    %eax,0x805038
  80334d:	a1 38 50 80 00       	mov    0x805038,%eax
  803352:	85 c0                	test   %eax,%eax
  803354:	75 a7                	jne    8032fd <free_block+0x5f>
  803356:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80335a:	75 a1                	jne    8032fd <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80335c:	90                   	nop
  80335d:	c9                   	leave  
  80335e:	c3                   	ret    

0080335f <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80335f:	55                   	push   %ebp
  803360:	89 e5                	mov    %esp,%ebp
  803362:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803365:	ff 75 08             	pushl  0x8(%ebp)
  803368:	e8 ed ec ff ff       	call   80205a <get_block_size>
  80336d:	83 c4 04             	add    $0x4,%esp
  803370:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803373:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80337a:	eb 17                	jmp    803393 <copy_data+0x34>
  80337c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80337f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803382:	01 c2                	add    %eax,%edx
  803384:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803387:	8b 45 08             	mov    0x8(%ebp),%eax
  80338a:	01 c8                	add    %ecx,%eax
  80338c:	8a 00                	mov    (%eax),%al
  80338e:	88 02                	mov    %al,(%edx)
  803390:	ff 45 fc             	incl   -0x4(%ebp)
  803393:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803396:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803399:	72 e1                	jb     80337c <copy_data+0x1d>
}
  80339b:	90                   	nop
  80339c:	c9                   	leave  
  80339d:	c3                   	ret    

0080339e <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80339e:	55                   	push   %ebp
  80339f:	89 e5                	mov    %esp,%ebp
  8033a1:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8033a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033a8:	75 23                	jne    8033cd <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8033aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033ae:	74 13                	je     8033c3 <realloc_block_FF+0x25>
  8033b0:	83 ec 0c             	sub    $0xc,%esp
  8033b3:	ff 75 0c             	pushl  0xc(%ebp)
  8033b6:	e8 1f f0 ff ff       	call   8023da <alloc_block_FF>
  8033bb:	83 c4 10             	add    $0x10,%esp
  8033be:	e9 f4 06 00 00       	jmp    803ab7 <realloc_block_FF+0x719>
		return NULL;
  8033c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c8:	e9 ea 06 00 00       	jmp    803ab7 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8033cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033d1:	75 18                	jne    8033eb <realloc_block_FF+0x4d>
	{
		free_block(va);
  8033d3:	83 ec 0c             	sub    $0xc,%esp
  8033d6:	ff 75 08             	pushl  0x8(%ebp)
  8033d9:	e8 c0 fe ff ff       	call   80329e <free_block>
  8033de:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8033e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8033e6:	e9 cc 06 00 00       	jmp    803ab7 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8033eb:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8033ef:	77 07                	ja     8033f8 <realloc_block_FF+0x5a>
  8033f1:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8033f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033fb:	83 e0 01             	and    $0x1,%eax
  8033fe:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803401:	8b 45 0c             	mov    0xc(%ebp),%eax
  803404:	83 c0 08             	add    $0x8,%eax
  803407:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80340a:	83 ec 0c             	sub    $0xc,%esp
  80340d:	ff 75 08             	pushl  0x8(%ebp)
  803410:	e8 45 ec ff ff       	call   80205a <get_block_size>
  803415:	83 c4 10             	add    $0x10,%esp
  803418:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80341b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80341e:	83 e8 08             	sub    $0x8,%eax
  803421:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803424:	8b 45 08             	mov    0x8(%ebp),%eax
  803427:	83 e8 04             	sub    $0x4,%eax
  80342a:	8b 00                	mov    (%eax),%eax
  80342c:	83 e0 fe             	and    $0xfffffffe,%eax
  80342f:	89 c2                	mov    %eax,%edx
  803431:	8b 45 08             	mov    0x8(%ebp),%eax
  803434:	01 d0                	add    %edx,%eax
  803436:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803439:	83 ec 0c             	sub    $0xc,%esp
  80343c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80343f:	e8 16 ec ff ff       	call   80205a <get_block_size>
  803444:	83 c4 10             	add    $0x10,%esp
  803447:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80344a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80344d:	83 e8 08             	sub    $0x8,%eax
  803450:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803453:	8b 45 0c             	mov    0xc(%ebp),%eax
  803456:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803459:	75 08                	jne    803463 <realloc_block_FF+0xc5>
	{
		 return va;
  80345b:	8b 45 08             	mov    0x8(%ebp),%eax
  80345e:	e9 54 06 00 00       	jmp    803ab7 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803463:	8b 45 0c             	mov    0xc(%ebp),%eax
  803466:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803469:	0f 83 e5 03 00 00    	jae    803854 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80346f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803472:	2b 45 0c             	sub    0xc(%ebp),%eax
  803475:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803478:	83 ec 0c             	sub    $0xc,%esp
  80347b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80347e:	e8 f0 eb ff ff       	call   802073 <is_free_block>
  803483:	83 c4 10             	add    $0x10,%esp
  803486:	84 c0                	test   %al,%al
  803488:	0f 84 3b 01 00 00    	je     8035c9 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80348e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803491:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803494:	01 d0                	add    %edx,%eax
  803496:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803499:	83 ec 04             	sub    $0x4,%esp
  80349c:	6a 01                	push   $0x1
  80349e:	ff 75 f0             	pushl  -0x10(%ebp)
  8034a1:	ff 75 08             	pushl  0x8(%ebp)
  8034a4:	e8 02 ef ff ff       	call   8023ab <set_block_data>
  8034a9:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8034ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8034af:	83 e8 04             	sub    $0x4,%eax
  8034b2:	8b 00                	mov    (%eax),%eax
  8034b4:	83 e0 fe             	and    $0xfffffffe,%eax
  8034b7:	89 c2                	mov    %eax,%edx
  8034b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bc:	01 d0                	add    %edx,%eax
  8034be:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8034c1:	83 ec 04             	sub    $0x4,%esp
  8034c4:	6a 00                	push   $0x0
  8034c6:	ff 75 cc             	pushl  -0x34(%ebp)
  8034c9:	ff 75 c8             	pushl  -0x38(%ebp)
  8034cc:	e8 da ee ff ff       	call   8023ab <set_block_data>
  8034d1:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8034d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034d8:	74 06                	je     8034e0 <realloc_block_FF+0x142>
  8034da:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8034de:	75 17                	jne    8034f7 <realloc_block_FF+0x159>
  8034e0:	83 ec 04             	sub    $0x4,%esp
  8034e3:	68 50 49 80 00       	push   $0x804950
  8034e8:	68 f6 01 00 00       	push   $0x1f6
  8034ed:	68 dd 48 80 00       	push   $0x8048dd
  8034f2:	e8 c3 ce ff ff       	call   8003ba <_panic>
  8034f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034fa:	8b 10                	mov    (%eax),%edx
  8034fc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034ff:	89 10                	mov    %edx,(%eax)
  803501:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803504:	8b 00                	mov    (%eax),%eax
  803506:	85 c0                	test   %eax,%eax
  803508:	74 0b                	je     803515 <realloc_block_FF+0x177>
  80350a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80350d:	8b 00                	mov    (%eax),%eax
  80350f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803512:	89 50 04             	mov    %edx,0x4(%eax)
  803515:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803518:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80351b:	89 10                	mov    %edx,(%eax)
  80351d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803520:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803523:	89 50 04             	mov    %edx,0x4(%eax)
  803526:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803529:	8b 00                	mov    (%eax),%eax
  80352b:	85 c0                	test   %eax,%eax
  80352d:	75 08                	jne    803537 <realloc_block_FF+0x199>
  80352f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803532:	a3 34 50 80 00       	mov    %eax,0x805034
  803537:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80353c:	40                   	inc    %eax
  80353d:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803542:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803546:	75 17                	jne    80355f <realloc_block_FF+0x1c1>
  803548:	83 ec 04             	sub    $0x4,%esp
  80354b:	68 bf 48 80 00       	push   $0x8048bf
  803550:	68 f7 01 00 00       	push   $0x1f7
  803555:	68 dd 48 80 00       	push   $0x8048dd
  80355a:	e8 5b ce ff ff       	call   8003ba <_panic>
  80355f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803562:	8b 00                	mov    (%eax),%eax
  803564:	85 c0                	test   %eax,%eax
  803566:	74 10                	je     803578 <realloc_block_FF+0x1da>
  803568:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80356b:	8b 00                	mov    (%eax),%eax
  80356d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803570:	8b 52 04             	mov    0x4(%edx),%edx
  803573:	89 50 04             	mov    %edx,0x4(%eax)
  803576:	eb 0b                	jmp    803583 <realloc_block_FF+0x1e5>
  803578:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80357b:	8b 40 04             	mov    0x4(%eax),%eax
  80357e:	a3 34 50 80 00       	mov    %eax,0x805034
  803583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803586:	8b 40 04             	mov    0x4(%eax),%eax
  803589:	85 c0                	test   %eax,%eax
  80358b:	74 0f                	je     80359c <realloc_block_FF+0x1fe>
  80358d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803590:	8b 40 04             	mov    0x4(%eax),%eax
  803593:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803596:	8b 12                	mov    (%edx),%edx
  803598:	89 10                	mov    %edx,(%eax)
  80359a:	eb 0a                	jmp    8035a6 <realloc_block_FF+0x208>
  80359c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80359f:	8b 00                	mov    (%eax),%eax
  8035a1:	a3 30 50 80 00       	mov    %eax,0x805030
  8035a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035b9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035be:	48                   	dec    %eax
  8035bf:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8035c4:	e9 83 02 00 00       	jmp    80384c <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8035c9:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8035cd:	0f 86 69 02 00 00    	jbe    80383c <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8035d3:	83 ec 04             	sub    $0x4,%esp
  8035d6:	6a 01                	push   $0x1
  8035d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8035db:	ff 75 08             	pushl  0x8(%ebp)
  8035de:	e8 c8 ed ff ff       	call   8023ab <set_block_data>
  8035e3:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8035e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e9:	83 e8 04             	sub    $0x4,%eax
  8035ec:	8b 00                	mov    (%eax),%eax
  8035ee:	83 e0 fe             	and    $0xfffffffe,%eax
  8035f1:	89 c2                	mov    %eax,%edx
  8035f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f6:	01 d0                	add    %edx,%eax
  8035f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8035fb:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803600:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803603:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803607:	75 68                	jne    803671 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803609:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80360d:	75 17                	jne    803626 <realloc_block_FF+0x288>
  80360f:	83 ec 04             	sub    $0x4,%esp
  803612:	68 f8 48 80 00       	push   $0x8048f8
  803617:	68 06 02 00 00       	push   $0x206
  80361c:	68 dd 48 80 00       	push   $0x8048dd
  803621:	e8 94 cd ff ff       	call   8003ba <_panic>
  803626:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80362c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80362f:	89 10                	mov    %edx,(%eax)
  803631:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803634:	8b 00                	mov    (%eax),%eax
  803636:	85 c0                	test   %eax,%eax
  803638:	74 0d                	je     803647 <realloc_block_FF+0x2a9>
  80363a:	a1 30 50 80 00       	mov    0x805030,%eax
  80363f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803642:	89 50 04             	mov    %edx,0x4(%eax)
  803645:	eb 08                	jmp    80364f <realloc_block_FF+0x2b1>
  803647:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80364a:	a3 34 50 80 00       	mov    %eax,0x805034
  80364f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803652:	a3 30 50 80 00       	mov    %eax,0x805030
  803657:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80365a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803661:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803666:	40                   	inc    %eax
  803667:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80366c:	e9 b0 01 00 00       	jmp    803821 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803671:	a1 30 50 80 00       	mov    0x805030,%eax
  803676:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803679:	76 68                	jbe    8036e3 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80367b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80367f:	75 17                	jne    803698 <realloc_block_FF+0x2fa>
  803681:	83 ec 04             	sub    $0x4,%esp
  803684:	68 f8 48 80 00       	push   $0x8048f8
  803689:	68 0b 02 00 00       	push   $0x20b
  80368e:	68 dd 48 80 00       	push   $0x8048dd
  803693:	e8 22 cd ff ff       	call   8003ba <_panic>
  803698:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80369e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a1:	89 10                	mov    %edx,(%eax)
  8036a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a6:	8b 00                	mov    (%eax),%eax
  8036a8:	85 c0                	test   %eax,%eax
  8036aa:	74 0d                	je     8036b9 <realloc_block_FF+0x31b>
  8036ac:	a1 30 50 80 00       	mov    0x805030,%eax
  8036b1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036b4:	89 50 04             	mov    %edx,0x4(%eax)
  8036b7:	eb 08                	jmp    8036c1 <realloc_block_FF+0x323>
  8036b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036bc:	a3 34 50 80 00       	mov    %eax,0x805034
  8036c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c4:	a3 30 50 80 00       	mov    %eax,0x805030
  8036c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036d3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036d8:	40                   	inc    %eax
  8036d9:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8036de:	e9 3e 01 00 00       	jmp    803821 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8036e3:	a1 30 50 80 00       	mov    0x805030,%eax
  8036e8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036eb:	73 68                	jae    803755 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036ed:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036f1:	75 17                	jne    80370a <realloc_block_FF+0x36c>
  8036f3:	83 ec 04             	sub    $0x4,%esp
  8036f6:	68 2c 49 80 00       	push   $0x80492c
  8036fb:	68 10 02 00 00       	push   $0x210
  803700:	68 dd 48 80 00       	push   $0x8048dd
  803705:	e8 b0 cc ff ff       	call   8003ba <_panic>
  80370a:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803710:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803713:	89 50 04             	mov    %edx,0x4(%eax)
  803716:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803719:	8b 40 04             	mov    0x4(%eax),%eax
  80371c:	85 c0                	test   %eax,%eax
  80371e:	74 0c                	je     80372c <realloc_block_FF+0x38e>
  803720:	a1 34 50 80 00       	mov    0x805034,%eax
  803725:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803728:	89 10                	mov    %edx,(%eax)
  80372a:	eb 08                	jmp    803734 <realloc_block_FF+0x396>
  80372c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80372f:	a3 30 50 80 00       	mov    %eax,0x805030
  803734:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803737:	a3 34 50 80 00       	mov    %eax,0x805034
  80373c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80373f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803745:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80374a:	40                   	inc    %eax
  80374b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803750:	e9 cc 00 00 00       	jmp    803821 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803755:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80375c:	a1 30 50 80 00       	mov    0x805030,%eax
  803761:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803764:	e9 8a 00 00 00       	jmp    8037f3 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80376f:	73 7a                	jae    8037eb <realloc_block_FF+0x44d>
  803771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803774:	8b 00                	mov    (%eax),%eax
  803776:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803779:	73 70                	jae    8037eb <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80377b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80377f:	74 06                	je     803787 <realloc_block_FF+0x3e9>
  803781:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803785:	75 17                	jne    80379e <realloc_block_FF+0x400>
  803787:	83 ec 04             	sub    $0x4,%esp
  80378a:	68 50 49 80 00       	push   $0x804950
  80378f:	68 1a 02 00 00       	push   $0x21a
  803794:	68 dd 48 80 00       	push   $0x8048dd
  803799:	e8 1c cc ff ff       	call   8003ba <_panic>
  80379e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a1:	8b 10                	mov    (%eax),%edx
  8037a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a6:	89 10                	mov    %edx,(%eax)
  8037a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037ab:	8b 00                	mov    (%eax),%eax
  8037ad:	85 c0                	test   %eax,%eax
  8037af:	74 0b                	je     8037bc <realloc_block_FF+0x41e>
  8037b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b4:	8b 00                	mov    (%eax),%eax
  8037b6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037b9:	89 50 04             	mov    %edx,0x4(%eax)
  8037bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037c2:	89 10                	mov    %edx,(%eax)
  8037c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037ca:	89 50 04             	mov    %edx,0x4(%eax)
  8037cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037d0:	8b 00                	mov    (%eax),%eax
  8037d2:	85 c0                	test   %eax,%eax
  8037d4:	75 08                	jne    8037de <realloc_block_FF+0x440>
  8037d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037d9:	a3 34 50 80 00       	mov    %eax,0x805034
  8037de:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8037e3:	40                   	inc    %eax
  8037e4:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  8037e9:	eb 36                	jmp    803821 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8037eb:	a1 38 50 80 00       	mov    0x805038,%eax
  8037f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037f7:	74 07                	je     803800 <realloc_block_FF+0x462>
  8037f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fc:	8b 00                	mov    (%eax),%eax
  8037fe:	eb 05                	jmp    803805 <realloc_block_FF+0x467>
  803800:	b8 00 00 00 00       	mov    $0x0,%eax
  803805:	a3 38 50 80 00       	mov    %eax,0x805038
  80380a:	a1 38 50 80 00       	mov    0x805038,%eax
  80380f:	85 c0                	test   %eax,%eax
  803811:	0f 85 52 ff ff ff    	jne    803769 <realloc_block_FF+0x3cb>
  803817:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80381b:	0f 85 48 ff ff ff    	jne    803769 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803821:	83 ec 04             	sub    $0x4,%esp
  803824:	6a 00                	push   $0x0
  803826:	ff 75 d8             	pushl  -0x28(%ebp)
  803829:	ff 75 d4             	pushl  -0x2c(%ebp)
  80382c:	e8 7a eb ff ff       	call   8023ab <set_block_data>
  803831:	83 c4 10             	add    $0x10,%esp
				return va;
  803834:	8b 45 08             	mov    0x8(%ebp),%eax
  803837:	e9 7b 02 00 00       	jmp    803ab7 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80383c:	83 ec 0c             	sub    $0xc,%esp
  80383f:	68 cd 49 80 00       	push   $0x8049cd
  803844:	e8 2e ce ff ff       	call   800677 <cprintf>
  803849:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80384c:	8b 45 08             	mov    0x8(%ebp),%eax
  80384f:	e9 63 02 00 00       	jmp    803ab7 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803854:	8b 45 0c             	mov    0xc(%ebp),%eax
  803857:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80385a:	0f 86 4d 02 00 00    	jbe    803aad <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803860:	83 ec 0c             	sub    $0xc,%esp
  803863:	ff 75 e4             	pushl  -0x1c(%ebp)
  803866:	e8 08 e8 ff ff       	call   802073 <is_free_block>
  80386b:	83 c4 10             	add    $0x10,%esp
  80386e:	84 c0                	test   %al,%al
  803870:	0f 84 37 02 00 00    	je     803aad <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803876:	8b 45 0c             	mov    0xc(%ebp),%eax
  803879:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80387c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80387f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803882:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803885:	76 38                	jbe    8038bf <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803887:	83 ec 0c             	sub    $0xc,%esp
  80388a:	ff 75 08             	pushl  0x8(%ebp)
  80388d:	e8 0c fa ff ff       	call   80329e <free_block>
  803892:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803895:	83 ec 0c             	sub    $0xc,%esp
  803898:	ff 75 0c             	pushl  0xc(%ebp)
  80389b:	e8 3a eb ff ff       	call   8023da <alloc_block_FF>
  8038a0:	83 c4 10             	add    $0x10,%esp
  8038a3:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8038a6:	83 ec 08             	sub    $0x8,%esp
  8038a9:	ff 75 c0             	pushl  -0x40(%ebp)
  8038ac:	ff 75 08             	pushl  0x8(%ebp)
  8038af:	e8 ab fa ff ff       	call   80335f <copy_data>
  8038b4:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8038b7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8038ba:	e9 f8 01 00 00       	jmp    803ab7 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8038bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038c2:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8038c5:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8038c8:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8038cc:	0f 87 a0 00 00 00    	ja     803972 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8038d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038d6:	75 17                	jne    8038ef <realloc_block_FF+0x551>
  8038d8:	83 ec 04             	sub    $0x4,%esp
  8038db:	68 bf 48 80 00       	push   $0x8048bf
  8038e0:	68 38 02 00 00       	push   $0x238
  8038e5:	68 dd 48 80 00       	push   $0x8048dd
  8038ea:	e8 cb ca ff ff       	call   8003ba <_panic>
  8038ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f2:	8b 00                	mov    (%eax),%eax
  8038f4:	85 c0                	test   %eax,%eax
  8038f6:	74 10                	je     803908 <realloc_block_FF+0x56a>
  8038f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038fb:	8b 00                	mov    (%eax),%eax
  8038fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803900:	8b 52 04             	mov    0x4(%edx),%edx
  803903:	89 50 04             	mov    %edx,0x4(%eax)
  803906:	eb 0b                	jmp    803913 <realloc_block_FF+0x575>
  803908:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80390b:	8b 40 04             	mov    0x4(%eax),%eax
  80390e:	a3 34 50 80 00       	mov    %eax,0x805034
  803913:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803916:	8b 40 04             	mov    0x4(%eax),%eax
  803919:	85 c0                	test   %eax,%eax
  80391b:	74 0f                	je     80392c <realloc_block_FF+0x58e>
  80391d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803920:	8b 40 04             	mov    0x4(%eax),%eax
  803923:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803926:	8b 12                	mov    (%edx),%edx
  803928:	89 10                	mov    %edx,(%eax)
  80392a:	eb 0a                	jmp    803936 <realloc_block_FF+0x598>
  80392c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80392f:	8b 00                	mov    (%eax),%eax
  803931:	a3 30 50 80 00       	mov    %eax,0x805030
  803936:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803939:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80393f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803942:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803949:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80394e:	48                   	dec    %eax
  80394f:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803954:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803957:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80395a:	01 d0                	add    %edx,%eax
  80395c:	83 ec 04             	sub    $0x4,%esp
  80395f:	6a 01                	push   $0x1
  803961:	50                   	push   %eax
  803962:	ff 75 08             	pushl  0x8(%ebp)
  803965:	e8 41 ea ff ff       	call   8023ab <set_block_data>
  80396a:	83 c4 10             	add    $0x10,%esp
  80396d:	e9 36 01 00 00       	jmp    803aa8 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803972:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803975:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803978:	01 d0                	add    %edx,%eax
  80397a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80397d:	83 ec 04             	sub    $0x4,%esp
  803980:	6a 01                	push   $0x1
  803982:	ff 75 f0             	pushl  -0x10(%ebp)
  803985:	ff 75 08             	pushl  0x8(%ebp)
  803988:	e8 1e ea ff ff       	call   8023ab <set_block_data>
  80398d:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803990:	8b 45 08             	mov    0x8(%ebp),%eax
  803993:	83 e8 04             	sub    $0x4,%eax
  803996:	8b 00                	mov    (%eax),%eax
  803998:	83 e0 fe             	and    $0xfffffffe,%eax
  80399b:	89 c2                	mov    %eax,%edx
  80399d:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a0:	01 d0                	add    %edx,%eax
  8039a2:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8039a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039a9:	74 06                	je     8039b1 <realloc_block_FF+0x613>
  8039ab:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8039af:	75 17                	jne    8039c8 <realloc_block_FF+0x62a>
  8039b1:	83 ec 04             	sub    $0x4,%esp
  8039b4:	68 50 49 80 00       	push   $0x804950
  8039b9:	68 44 02 00 00       	push   $0x244
  8039be:	68 dd 48 80 00       	push   $0x8048dd
  8039c3:	e8 f2 c9 ff ff       	call   8003ba <_panic>
  8039c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039cb:	8b 10                	mov    (%eax),%edx
  8039cd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039d0:	89 10                	mov    %edx,(%eax)
  8039d2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039d5:	8b 00                	mov    (%eax),%eax
  8039d7:	85 c0                	test   %eax,%eax
  8039d9:	74 0b                	je     8039e6 <realloc_block_FF+0x648>
  8039db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039de:	8b 00                	mov    (%eax),%eax
  8039e0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8039e3:	89 50 04             	mov    %edx,0x4(%eax)
  8039e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e9:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8039ec:	89 10                	mov    %edx,(%eax)
  8039ee:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039f4:	89 50 04             	mov    %edx,0x4(%eax)
  8039f7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039fa:	8b 00                	mov    (%eax),%eax
  8039fc:	85 c0                	test   %eax,%eax
  8039fe:	75 08                	jne    803a08 <realloc_block_FF+0x66a>
  803a00:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a03:	a3 34 50 80 00       	mov    %eax,0x805034
  803a08:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a0d:	40                   	inc    %eax
  803a0e:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a17:	75 17                	jne    803a30 <realloc_block_FF+0x692>
  803a19:	83 ec 04             	sub    $0x4,%esp
  803a1c:	68 bf 48 80 00       	push   $0x8048bf
  803a21:	68 45 02 00 00       	push   $0x245
  803a26:	68 dd 48 80 00       	push   $0x8048dd
  803a2b:	e8 8a c9 ff ff       	call   8003ba <_panic>
  803a30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a33:	8b 00                	mov    (%eax),%eax
  803a35:	85 c0                	test   %eax,%eax
  803a37:	74 10                	je     803a49 <realloc_block_FF+0x6ab>
  803a39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a3c:	8b 00                	mov    (%eax),%eax
  803a3e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a41:	8b 52 04             	mov    0x4(%edx),%edx
  803a44:	89 50 04             	mov    %edx,0x4(%eax)
  803a47:	eb 0b                	jmp    803a54 <realloc_block_FF+0x6b6>
  803a49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4c:	8b 40 04             	mov    0x4(%eax),%eax
  803a4f:	a3 34 50 80 00       	mov    %eax,0x805034
  803a54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a57:	8b 40 04             	mov    0x4(%eax),%eax
  803a5a:	85 c0                	test   %eax,%eax
  803a5c:	74 0f                	je     803a6d <realloc_block_FF+0x6cf>
  803a5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a61:	8b 40 04             	mov    0x4(%eax),%eax
  803a64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a67:	8b 12                	mov    (%edx),%edx
  803a69:	89 10                	mov    %edx,(%eax)
  803a6b:	eb 0a                	jmp    803a77 <realloc_block_FF+0x6d9>
  803a6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a70:	8b 00                	mov    (%eax),%eax
  803a72:	a3 30 50 80 00       	mov    %eax,0x805030
  803a77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a8a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a8f:	48                   	dec    %eax
  803a90:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803a95:	83 ec 04             	sub    $0x4,%esp
  803a98:	6a 00                	push   $0x0
  803a9a:	ff 75 bc             	pushl  -0x44(%ebp)
  803a9d:	ff 75 b8             	pushl  -0x48(%ebp)
  803aa0:	e8 06 e9 ff ff       	call   8023ab <set_block_data>
  803aa5:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  803aab:	eb 0a                	jmp    803ab7 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803aad:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803ab4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803ab7:	c9                   	leave  
  803ab8:	c3                   	ret    

00803ab9 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803ab9:	55                   	push   %ebp
  803aba:	89 e5                	mov    %esp,%ebp
  803abc:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803abf:	83 ec 04             	sub    $0x4,%esp
  803ac2:	68 d4 49 80 00       	push   $0x8049d4
  803ac7:	68 58 02 00 00       	push   $0x258
  803acc:	68 dd 48 80 00       	push   $0x8048dd
  803ad1:	e8 e4 c8 ff ff       	call   8003ba <_panic>

00803ad6 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803ad6:	55                   	push   %ebp
  803ad7:	89 e5                	mov    %esp,%ebp
  803ad9:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803adc:	83 ec 04             	sub    $0x4,%esp
  803adf:	68 fc 49 80 00       	push   $0x8049fc
  803ae4:	68 61 02 00 00       	push   $0x261
  803ae9:	68 dd 48 80 00       	push   $0x8048dd
  803aee:	e8 c7 c8 ff ff       	call   8003ba <_panic>
  803af3:	90                   	nop

00803af4 <__udivdi3>:
  803af4:	55                   	push   %ebp
  803af5:	57                   	push   %edi
  803af6:	56                   	push   %esi
  803af7:	53                   	push   %ebx
  803af8:	83 ec 1c             	sub    $0x1c,%esp
  803afb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803aff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b07:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b0b:	89 ca                	mov    %ecx,%edx
  803b0d:	89 f8                	mov    %edi,%eax
  803b0f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b13:	85 f6                	test   %esi,%esi
  803b15:	75 2d                	jne    803b44 <__udivdi3+0x50>
  803b17:	39 cf                	cmp    %ecx,%edi
  803b19:	77 65                	ja     803b80 <__udivdi3+0x8c>
  803b1b:	89 fd                	mov    %edi,%ebp
  803b1d:	85 ff                	test   %edi,%edi
  803b1f:	75 0b                	jne    803b2c <__udivdi3+0x38>
  803b21:	b8 01 00 00 00       	mov    $0x1,%eax
  803b26:	31 d2                	xor    %edx,%edx
  803b28:	f7 f7                	div    %edi
  803b2a:	89 c5                	mov    %eax,%ebp
  803b2c:	31 d2                	xor    %edx,%edx
  803b2e:	89 c8                	mov    %ecx,%eax
  803b30:	f7 f5                	div    %ebp
  803b32:	89 c1                	mov    %eax,%ecx
  803b34:	89 d8                	mov    %ebx,%eax
  803b36:	f7 f5                	div    %ebp
  803b38:	89 cf                	mov    %ecx,%edi
  803b3a:	89 fa                	mov    %edi,%edx
  803b3c:	83 c4 1c             	add    $0x1c,%esp
  803b3f:	5b                   	pop    %ebx
  803b40:	5e                   	pop    %esi
  803b41:	5f                   	pop    %edi
  803b42:	5d                   	pop    %ebp
  803b43:	c3                   	ret    
  803b44:	39 ce                	cmp    %ecx,%esi
  803b46:	77 28                	ja     803b70 <__udivdi3+0x7c>
  803b48:	0f bd fe             	bsr    %esi,%edi
  803b4b:	83 f7 1f             	xor    $0x1f,%edi
  803b4e:	75 40                	jne    803b90 <__udivdi3+0x9c>
  803b50:	39 ce                	cmp    %ecx,%esi
  803b52:	72 0a                	jb     803b5e <__udivdi3+0x6a>
  803b54:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b58:	0f 87 9e 00 00 00    	ja     803bfc <__udivdi3+0x108>
  803b5e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b63:	89 fa                	mov    %edi,%edx
  803b65:	83 c4 1c             	add    $0x1c,%esp
  803b68:	5b                   	pop    %ebx
  803b69:	5e                   	pop    %esi
  803b6a:	5f                   	pop    %edi
  803b6b:	5d                   	pop    %ebp
  803b6c:	c3                   	ret    
  803b6d:	8d 76 00             	lea    0x0(%esi),%esi
  803b70:	31 ff                	xor    %edi,%edi
  803b72:	31 c0                	xor    %eax,%eax
  803b74:	89 fa                	mov    %edi,%edx
  803b76:	83 c4 1c             	add    $0x1c,%esp
  803b79:	5b                   	pop    %ebx
  803b7a:	5e                   	pop    %esi
  803b7b:	5f                   	pop    %edi
  803b7c:	5d                   	pop    %ebp
  803b7d:	c3                   	ret    
  803b7e:	66 90                	xchg   %ax,%ax
  803b80:	89 d8                	mov    %ebx,%eax
  803b82:	f7 f7                	div    %edi
  803b84:	31 ff                	xor    %edi,%edi
  803b86:	89 fa                	mov    %edi,%edx
  803b88:	83 c4 1c             	add    $0x1c,%esp
  803b8b:	5b                   	pop    %ebx
  803b8c:	5e                   	pop    %esi
  803b8d:	5f                   	pop    %edi
  803b8e:	5d                   	pop    %ebp
  803b8f:	c3                   	ret    
  803b90:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b95:	89 eb                	mov    %ebp,%ebx
  803b97:	29 fb                	sub    %edi,%ebx
  803b99:	89 f9                	mov    %edi,%ecx
  803b9b:	d3 e6                	shl    %cl,%esi
  803b9d:	89 c5                	mov    %eax,%ebp
  803b9f:	88 d9                	mov    %bl,%cl
  803ba1:	d3 ed                	shr    %cl,%ebp
  803ba3:	89 e9                	mov    %ebp,%ecx
  803ba5:	09 f1                	or     %esi,%ecx
  803ba7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bab:	89 f9                	mov    %edi,%ecx
  803bad:	d3 e0                	shl    %cl,%eax
  803baf:	89 c5                	mov    %eax,%ebp
  803bb1:	89 d6                	mov    %edx,%esi
  803bb3:	88 d9                	mov    %bl,%cl
  803bb5:	d3 ee                	shr    %cl,%esi
  803bb7:	89 f9                	mov    %edi,%ecx
  803bb9:	d3 e2                	shl    %cl,%edx
  803bbb:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bbf:	88 d9                	mov    %bl,%cl
  803bc1:	d3 e8                	shr    %cl,%eax
  803bc3:	09 c2                	or     %eax,%edx
  803bc5:	89 d0                	mov    %edx,%eax
  803bc7:	89 f2                	mov    %esi,%edx
  803bc9:	f7 74 24 0c          	divl   0xc(%esp)
  803bcd:	89 d6                	mov    %edx,%esi
  803bcf:	89 c3                	mov    %eax,%ebx
  803bd1:	f7 e5                	mul    %ebp
  803bd3:	39 d6                	cmp    %edx,%esi
  803bd5:	72 19                	jb     803bf0 <__udivdi3+0xfc>
  803bd7:	74 0b                	je     803be4 <__udivdi3+0xf0>
  803bd9:	89 d8                	mov    %ebx,%eax
  803bdb:	31 ff                	xor    %edi,%edi
  803bdd:	e9 58 ff ff ff       	jmp    803b3a <__udivdi3+0x46>
  803be2:	66 90                	xchg   %ax,%ax
  803be4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803be8:	89 f9                	mov    %edi,%ecx
  803bea:	d3 e2                	shl    %cl,%edx
  803bec:	39 c2                	cmp    %eax,%edx
  803bee:	73 e9                	jae    803bd9 <__udivdi3+0xe5>
  803bf0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bf3:	31 ff                	xor    %edi,%edi
  803bf5:	e9 40 ff ff ff       	jmp    803b3a <__udivdi3+0x46>
  803bfa:	66 90                	xchg   %ax,%ax
  803bfc:	31 c0                	xor    %eax,%eax
  803bfe:	e9 37 ff ff ff       	jmp    803b3a <__udivdi3+0x46>
  803c03:	90                   	nop

00803c04 <__umoddi3>:
  803c04:	55                   	push   %ebp
  803c05:	57                   	push   %edi
  803c06:	56                   	push   %esi
  803c07:	53                   	push   %ebx
  803c08:	83 ec 1c             	sub    $0x1c,%esp
  803c0b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c0f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c17:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c1b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c1f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c23:	89 f3                	mov    %esi,%ebx
  803c25:	89 fa                	mov    %edi,%edx
  803c27:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c2b:	89 34 24             	mov    %esi,(%esp)
  803c2e:	85 c0                	test   %eax,%eax
  803c30:	75 1a                	jne    803c4c <__umoddi3+0x48>
  803c32:	39 f7                	cmp    %esi,%edi
  803c34:	0f 86 a2 00 00 00    	jbe    803cdc <__umoddi3+0xd8>
  803c3a:	89 c8                	mov    %ecx,%eax
  803c3c:	89 f2                	mov    %esi,%edx
  803c3e:	f7 f7                	div    %edi
  803c40:	89 d0                	mov    %edx,%eax
  803c42:	31 d2                	xor    %edx,%edx
  803c44:	83 c4 1c             	add    $0x1c,%esp
  803c47:	5b                   	pop    %ebx
  803c48:	5e                   	pop    %esi
  803c49:	5f                   	pop    %edi
  803c4a:	5d                   	pop    %ebp
  803c4b:	c3                   	ret    
  803c4c:	39 f0                	cmp    %esi,%eax
  803c4e:	0f 87 ac 00 00 00    	ja     803d00 <__umoddi3+0xfc>
  803c54:	0f bd e8             	bsr    %eax,%ebp
  803c57:	83 f5 1f             	xor    $0x1f,%ebp
  803c5a:	0f 84 ac 00 00 00    	je     803d0c <__umoddi3+0x108>
  803c60:	bf 20 00 00 00       	mov    $0x20,%edi
  803c65:	29 ef                	sub    %ebp,%edi
  803c67:	89 fe                	mov    %edi,%esi
  803c69:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c6d:	89 e9                	mov    %ebp,%ecx
  803c6f:	d3 e0                	shl    %cl,%eax
  803c71:	89 d7                	mov    %edx,%edi
  803c73:	89 f1                	mov    %esi,%ecx
  803c75:	d3 ef                	shr    %cl,%edi
  803c77:	09 c7                	or     %eax,%edi
  803c79:	89 e9                	mov    %ebp,%ecx
  803c7b:	d3 e2                	shl    %cl,%edx
  803c7d:	89 14 24             	mov    %edx,(%esp)
  803c80:	89 d8                	mov    %ebx,%eax
  803c82:	d3 e0                	shl    %cl,%eax
  803c84:	89 c2                	mov    %eax,%edx
  803c86:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c8a:	d3 e0                	shl    %cl,%eax
  803c8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c90:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c94:	89 f1                	mov    %esi,%ecx
  803c96:	d3 e8                	shr    %cl,%eax
  803c98:	09 d0                	or     %edx,%eax
  803c9a:	d3 eb                	shr    %cl,%ebx
  803c9c:	89 da                	mov    %ebx,%edx
  803c9e:	f7 f7                	div    %edi
  803ca0:	89 d3                	mov    %edx,%ebx
  803ca2:	f7 24 24             	mull   (%esp)
  803ca5:	89 c6                	mov    %eax,%esi
  803ca7:	89 d1                	mov    %edx,%ecx
  803ca9:	39 d3                	cmp    %edx,%ebx
  803cab:	0f 82 87 00 00 00    	jb     803d38 <__umoddi3+0x134>
  803cb1:	0f 84 91 00 00 00    	je     803d48 <__umoddi3+0x144>
  803cb7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cbb:	29 f2                	sub    %esi,%edx
  803cbd:	19 cb                	sbb    %ecx,%ebx
  803cbf:	89 d8                	mov    %ebx,%eax
  803cc1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803cc5:	d3 e0                	shl    %cl,%eax
  803cc7:	89 e9                	mov    %ebp,%ecx
  803cc9:	d3 ea                	shr    %cl,%edx
  803ccb:	09 d0                	or     %edx,%eax
  803ccd:	89 e9                	mov    %ebp,%ecx
  803ccf:	d3 eb                	shr    %cl,%ebx
  803cd1:	89 da                	mov    %ebx,%edx
  803cd3:	83 c4 1c             	add    $0x1c,%esp
  803cd6:	5b                   	pop    %ebx
  803cd7:	5e                   	pop    %esi
  803cd8:	5f                   	pop    %edi
  803cd9:	5d                   	pop    %ebp
  803cda:	c3                   	ret    
  803cdb:	90                   	nop
  803cdc:	89 fd                	mov    %edi,%ebp
  803cde:	85 ff                	test   %edi,%edi
  803ce0:	75 0b                	jne    803ced <__umoddi3+0xe9>
  803ce2:	b8 01 00 00 00       	mov    $0x1,%eax
  803ce7:	31 d2                	xor    %edx,%edx
  803ce9:	f7 f7                	div    %edi
  803ceb:	89 c5                	mov    %eax,%ebp
  803ced:	89 f0                	mov    %esi,%eax
  803cef:	31 d2                	xor    %edx,%edx
  803cf1:	f7 f5                	div    %ebp
  803cf3:	89 c8                	mov    %ecx,%eax
  803cf5:	f7 f5                	div    %ebp
  803cf7:	89 d0                	mov    %edx,%eax
  803cf9:	e9 44 ff ff ff       	jmp    803c42 <__umoddi3+0x3e>
  803cfe:	66 90                	xchg   %ax,%ax
  803d00:	89 c8                	mov    %ecx,%eax
  803d02:	89 f2                	mov    %esi,%edx
  803d04:	83 c4 1c             	add    $0x1c,%esp
  803d07:	5b                   	pop    %ebx
  803d08:	5e                   	pop    %esi
  803d09:	5f                   	pop    %edi
  803d0a:	5d                   	pop    %ebp
  803d0b:	c3                   	ret    
  803d0c:	3b 04 24             	cmp    (%esp),%eax
  803d0f:	72 06                	jb     803d17 <__umoddi3+0x113>
  803d11:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d15:	77 0f                	ja     803d26 <__umoddi3+0x122>
  803d17:	89 f2                	mov    %esi,%edx
  803d19:	29 f9                	sub    %edi,%ecx
  803d1b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d1f:	89 14 24             	mov    %edx,(%esp)
  803d22:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d26:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d2a:	8b 14 24             	mov    (%esp),%edx
  803d2d:	83 c4 1c             	add    $0x1c,%esp
  803d30:	5b                   	pop    %ebx
  803d31:	5e                   	pop    %esi
  803d32:	5f                   	pop    %edi
  803d33:	5d                   	pop    %ebp
  803d34:	c3                   	ret    
  803d35:	8d 76 00             	lea    0x0(%esi),%esi
  803d38:	2b 04 24             	sub    (%esp),%eax
  803d3b:	19 fa                	sbb    %edi,%edx
  803d3d:	89 d1                	mov    %edx,%ecx
  803d3f:	89 c6                	mov    %eax,%esi
  803d41:	e9 71 ff ff ff       	jmp    803cb7 <__umoddi3+0xb3>
  803d46:	66 90                	xchg   %ax,%ax
  803d48:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d4c:	72 ea                	jb     803d38 <__umoddi3+0x134>
  803d4e:	89 d9                	mov    %ebx,%ecx
  803d50:	e9 62 ff ff ff       	jmp    803cb7 <__umoddi3+0xb3>
