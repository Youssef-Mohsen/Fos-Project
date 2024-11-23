
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
  80005b:	68 60 3c 80 00       	push   $0x803c60
  800060:	6a 0c                	push   $0xc
  800062:	68 7c 3c 80 00       	push   $0x803c7c
  800067:	e8 4e 03 00 00       	call   8003ba <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	cprintf("************************************************\n");
  80006c:	83 ec 0c             	sub    $0xc,%esp
  80006f:	68 94 3c 80 00       	push   $0x803c94
  800074:	e8 fe 05 00 00       	call   800677 <cprintf>
  800079:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	68 c8 3c 80 00       	push   $0x803cc8
  800084:	e8 ee 05 00 00       	call   800677 <cprintf>
  800089:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 24 3d 80 00       	push   $0x803d24
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
  8000b4:	68 58 3d 80 00       	push   $0x803d58
  8000b9:	e8 b9 05 00 00       	call   800677 <cprintf>
  8000be:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 01                	push   $0x1
  8000c6:	68 00 10 00 00       	push   $0x1000
  8000cb:	68 a6 3d 80 00       	push   $0x803da6
  8000d0:	e8 6f 16 00 00       	call   801744 <smalloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000db:	e8 73 19 00 00       	call   801a53 <sys_calculate_free_frames>
  8000e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000e3:	83 ec 04             	sub    $0x4,%esp
  8000e6:	6a 01                	push   $0x1
  8000e8:	68 00 10 00 00       	push   $0x1000
  8000ed:	68 a6 3d 80 00       	push   $0x803da6
  8000f2:	e8 4d 16 00 00       	call   801744 <smalloc>
  8000f7:	83 c4 10             	add    $0x10,%esp
  8000fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) {is_correct = 0; cprintf("Trying to create an already exists object and corresponding error is not returned!!");}
  8000fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800101:	74 17                	je     80011a <_main+0xe2>
  800103:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	68 a8 3d 80 00       	push   $0x803da8
  800112:	e8 60 05 00 00       	call   800677 <cprintf>
  800117:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");}
  80011a:	e8 34 19 00 00       	call   801a53 <sys_calculate_free_frames>
  80011f:	89 c2                	mov    %eax,%edx
  800121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800124:	39 c2                	cmp    %eax,%edx
  800126:	74 17                	je     80013f <_main+0x107>
  800128:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 fc 3d 80 00       	push   $0x803dfc
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
  800153:	68 58 3e 80 00       	push   $0x803e58
  800158:	e8 1a 05 00 00       	call   800677 <cprintf>
  80015d:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		x = sget(myEnv->env_id, "xx");
  800160:	a1 20 50 80 00       	mov    0x805020,%eax
  800165:	8b 40 10             	mov    0x10(%eax),%eax
  800168:	83 ec 08             	sub    $0x8,%esp
  80016b:	68 9d 3e 80 00       	push   $0x803e9d
  800170:	50                   	push   %eax
  800171:	e8 86 16 00 00       	call   8017fc <sget>
  800176:	83 c4 10             	add    $0x10,%esp
  800179:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  80017c:	e8 d2 18 00 00       	call   801a53 <sys_calculate_free_frames>
  800181:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != NULL) {is_correct = 0; cprintf("Trying to get a NON existing object and corresponding error is not returned!!");}
  800184:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800188:	74 17                	je     8001a1 <_main+0x169>
  80018a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800191:	83 ec 0c             	sub    $0xc,%esp
  800194:	68 a0 3e 80 00       	push   $0x803ea0
  800199:	e8 d9 04 00 00       	call   800677 <cprintf>
  80019e:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong get: make sure that you don't allocate any memory if the shared object not exists");}
  8001a1:	e8 ad 18 00 00       	call   801a53 <sys_calculate_free_frames>
  8001a6:	89 c2                	mov    %eax,%edx
  8001a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ab:	39 c2                	cmp    %eax,%edx
  8001ad:	74 17                	je     8001c6 <_main+0x18e>
  8001af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	68 f0 3e 80 00       	push   $0x803ef0
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
  8001da:	68 48 3f 80 00       	push   $0x803f48
  8001df:	e8 93 04 00 00       	call   800677 <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8001e7:	e8 67 18 00 00       	call   801a53 <sys_calculate_free_frames>
  8001ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uint32 size = USER_HEAP_MAX - pagealloc_start - PAGE_SIZE + 1;
  8001ef:	b8 01 f0 ff 9f       	mov    $0x9ffff001,%eax
  8001f4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8001f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		y = smalloc("y", size, 1);
  8001fa:	83 ec 04             	sub    $0x4,%esp
  8001fd:	6a 01                	push   $0x1
  8001ff:	ff 75 d8             	pushl  -0x28(%ebp)
  800202:	68 a5 3f 80 00       	push   $0x803fa5
  800207:	e8 38 15 00 00       	call   801744 <smalloc>
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (y != NULL) {is_correct = 0; cprintf("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");}
  800212:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800216:	74 17                	je     80022f <_main+0x1f7>
  800218:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	68 a8 3f 80 00       	push   $0x803fa8
  800227:	e8 4b 04 00 00       	call   800677 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");}
  80022f:	e8 1f 18 00 00       	call   801a53 <sys_calculate_free_frames>
  800234:	89 c2                	mov    %eax,%edx
  800236:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800239:	39 c2                	cmp    %eax,%edx
  80023b:	74 17                	je     800254 <_main+0x21c>
  80023d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 1c 40 80 00       	push   $0x80401c
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
  80026b:	68 90 40 80 00       	push   $0x804090
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
  800281:	e8 96 19 00 00       	call   801c1c <sys_getenvindex>
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
  8002ef:	e8 ac 16 00 00       	call   8019a0 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 fc 40 80 00       	push   $0x8040fc
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
  80031f:	68 24 41 80 00       	push   $0x804124
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
  800350:	68 4c 41 80 00       	push   $0x80414c
  800355:	e8 1d 03 00 00       	call   800677 <cprintf>
  80035a:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80035d:	a1 20 50 80 00       	mov    0x805020,%eax
  800362:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800368:	83 ec 08             	sub    $0x8,%esp
  80036b:	50                   	push   %eax
  80036c:	68 a4 41 80 00       	push   $0x8041a4
  800371:	e8 01 03 00 00       	call   800677 <cprintf>
  800376:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800379:	83 ec 0c             	sub    $0xc,%esp
  80037c:	68 fc 40 80 00       	push   $0x8040fc
  800381:	e8 f1 02 00 00       	call   800677 <cprintf>
  800386:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800389:	e8 2c 16 00 00       	call   8019ba <sys_unlock_cons>
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
  8003a1:	e8 42 18 00 00       	call   801be8 <sys_destroy_env>
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
  8003b2:	e8 97 18 00 00       	call   801c4e <sys_exit_env>
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
  8003db:	68 b8 41 80 00       	push   $0x8041b8
  8003e0:	e8 92 02 00 00       	call   800677 <cprintf>
  8003e5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003e8:	a1 00 50 80 00       	mov    0x805000,%eax
  8003ed:	ff 75 0c             	pushl  0xc(%ebp)
  8003f0:	ff 75 08             	pushl  0x8(%ebp)
  8003f3:	50                   	push   %eax
  8003f4:	68 bd 41 80 00       	push   $0x8041bd
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
  800418:	68 d9 41 80 00       	push   $0x8041d9
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
  800447:	68 dc 41 80 00       	push   $0x8041dc
  80044c:	6a 26                	push   $0x26
  80044e:	68 28 42 80 00       	push   $0x804228
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
  80051c:	68 34 42 80 00       	push   $0x804234
  800521:	6a 3a                	push   $0x3a
  800523:	68 28 42 80 00       	push   $0x804228
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
  80058f:	68 88 42 80 00       	push   $0x804288
  800594:	6a 44                	push   $0x44
  800596:	68 28 42 80 00       	push   $0x804228
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
  8005e9:	e8 70 13 00 00       	call   80195e <sys_cputs>
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
  800660:	e8 f9 12 00 00       	call   80195e <sys_cputs>
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
  8006aa:	e8 f1 12 00 00       	call   8019a0 <sys_lock_cons>
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
  8006ca:	e8 eb 12 00 00       	call   8019ba <sys_unlock_cons>
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
  800714:	e8 df 32 00 00       	call   8039f8 <__udivdi3>
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
  800764:	e8 9f 33 00 00       	call   803b08 <__umoddi3>
  800769:	83 c4 10             	add    $0x10,%esp
  80076c:	05 f4 44 80 00       	add    $0x8044f4,%eax
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
  8008bf:	8b 04 85 18 45 80 00 	mov    0x804518(,%eax,4),%eax
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
  8009a0:	8b 34 9d 60 43 80 00 	mov    0x804360(,%ebx,4),%esi
  8009a7:	85 f6                	test   %esi,%esi
  8009a9:	75 19                	jne    8009c4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009ab:	53                   	push   %ebx
  8009ac:	68 05 45 80 00       	push   $0x804505
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
  8009c5:	68 0e 45 80 00       	push   $0x80450e
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
  8009f2:	be 11 45 80 00       	mov    $0x804511,%esi
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
  8013fd:	68 88 46 80 00       	push   $0x804688
  801402:	68 3f 01 00 00       	push   $0x13f
  801407:	68 aa 46 80 00       	push   $0x8046aa
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
  80141d:	e8 e7 0a 00 00       	call   801f09 <sys_sbrk>
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
  801498:	e8 f0 08 00 00       	call   801d8d <sys_isUHeapPlacementStrategyFIRSTFIT>
  80149d:	85 c0                	test   %eax,%eax
  80149f:	74 16                	je     8014b7 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8014a1:	83 ec 0c             	sub    $0xc,%esp
  8014a4:	ff 75 08             	pushl  0x8(%ebp)
  8014a7:	e8 30 0e 00 00       	call   8022dc <alloc_block_FF>
  8014ac:	83 c4 10             	add    $0x10,%esp
  8014af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014b2:	e9 8a 01 00 00       	jmp    801641 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014b7:	e8 02 09 00 00       	call   801dbe <sys_isUHeapPlacementStrategyBESTFIT>
  8014bc:	85 c0                	test   %eax,%eax
  8014be:	0f 84 7d 01 00 00    	je     801641 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014c4:	83 ec 0c             	sub    $0xc,%esp
  8014c7:	ff 75 08             	pushl  0x8(%ebp)
  8014ca:	e8 c9 12 00 00       	call   802798 <alloc_block_BF>
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
  80151a:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801567:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801620:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801627:	83 ec 08             	sub    $0x8,%esp
  80162a:	ff 75 08             	pushl  0x8(%ebp)
  80162d:	ff 75 f0             	pushl  -0x10(%ebp)
  801630:	e8 0b 09 00 00       	call   801f40 <sys_allocate_user_mem>
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
  801678:	e8 df 08 00 00       	call   801f5c <get_block_size>
  80167d:	83 c4 10             	add    $0x10,%esp
  801680:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801683:	83 ec 0c             	sub    $0xc,%esp
  801686:	ff 75 08             	pushl  0x8(%ebp)
  801689:	e8 12 1b 00 00       	call   8031a0 <free_block>
  80168e:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
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
  8016dd:	eb 2f                	jmp    80170e <free+0xc8>
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
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  80170b:	ff 45 f4             	incl   -0xc(%ebp)
  80170e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801711:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801714:	72 c9                	jb     8016df <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	83 ec 08             	sub    $0x8,%esp
  80171c:	ff 75 ec             	pushl  -0x14(%ebp)
  80171f:	50                   	push   %eax
  801720:	e8 ff 07 00 00       	call   801f24 <sys_free_user_mem>
  801725:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801728:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801729:	eb 17                	jmp    801742 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  80172b:	83 ec 04             	sub    $0x4,%esp
  80172e:	68 b8 46 80 00       	push   $0x8046b8
  801733:	68 85 00 00 00       	push   $0x85
  801738:	68 e2 46 80 00       	push   $0x8046e2
  80173d:	e8 78 ec ff ff       	call   8003ba <_panic>
	}
}
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
  801747:	83 ec 28             	sub    $0x28,%esp
  80174a:	8b 45 10             	mov    0x10(%ebp),%eax
  80174d:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801750:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801754:	75 0a                	jne    801760 <smalloc+0x1c>
  801756:	b8 00 00 00 00       	mov    $0x0,%eax
  80175b:	e9 9a 00 00 00       	jmp    8017fa <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801760:	8b 45 0c             	mov    0xc(%ebp),%eax
  801763:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801766:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80176d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801773:	39 d0                	cmp    %edx,%eax
  801775:	73 02                	jae    801779 <smalloc+0x35>
  801777:	89 d0                	mov    %edx,%eax
  801779:	83 ec 0c             	sub    $0xc,%esp
  80177c:	50                   	push   %eax
  80177d:	e8 a5 fc ff ff       	call   801427 <malloc>
  801782:	83 c4 10             	add    $0x10,%esp
  801785:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801788:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80178c:	75 07                	jne    801795 <smalloc+0x51>
  80178e:	b8 00 00 00 00       	mov    $0x0,%eax
  801793:	eb 65                	jmp    8017fa <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801795:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801799:	ff 75 ec             	pushl  -0x14(%ebp)
  80179c:	50                   	push   %eax
  80179d:	ff 75 0c             	pushl  0xc(%ebp)
  8017a0:	ff 75 08             	pushl  0x8(%ebp)
  8017a3:	e8 83 03 00 00       	call   801b2b <sys_createSharedObject>
  8017a8:	83 c4 10             	add    $0x10,%esp
  8017ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8017ae:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8017b2:	74 06                	je     8017ba <smalloc+0x76>
  8017b4:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8017b8:	75 07                	jne    8017c1 <smalloc+0x7d>
  8017ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8017bf:	eb 39                	jmp    8017fa <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  8017c1:	83 ec 08             	sub    $0x8,%esp
  8017c4:	ff 75 ec             	pushl  -0x14(%ebp)
  8017c7:	68 ee 46 80 00       	push   $0x8046ee
  8017cc:	e8 a6 ee ff ff       	call   800677 <cprintf>
  8017d1:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  8017d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017d7:	a1 20 50 80 00       	mov    0x805020,%eax
  8017dc:	8b 40 78             	mov    0x78(%eax),%eax
  8017df:	29 c2                	sub    %eax,%edx
  8017e1:	89 d0                	mov    %edx,%eax
  8017e3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017e8:	c1 e8 0c             	shr    $0xc,%eax
  8017eb:	89 c2                	mov    %eax,%edx
  8017ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017f0:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8017f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
  8017ff:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801802:	83 ec 08             	sub    $0x8,%esp
  801805:	ff 75 0c             	pushl  0xc(%ebp)
  801808:	ff 75 08             	pushl  0x8(%ebp)
  80180b:	e8 45 03 00 00       	call   801b55 <sys_getSizeOfSharedObject>
  801810:	83 c4 10             	add    $0x10,%esp
  801813:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801816:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80181a:	75 07                	jne    801823 <sget+0x27>
  80181c:	b8 00 00 00 00       	mov    $0x0,%eax
  801821:	eb 5c                	jmp    80187f <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801826:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801829:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801830:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801833:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801836:	39 d0                	cmp    %edx,%eax
  801838:	7d 02                	jge    80183c <sget+0x40>
  80183a:	89 d0                	mov    %edx,%eax
  80183c:	83 ec 0c             	sub    $0xc,%esp
  80183f:	50                   	push   %eax
  801840:	e8 e2 fb ff ff       	call   801427 <malloc>
  801845:	83 c4 10             	add    $0x10,%esp
  801848:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80184b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80184f:	75 07                	jne    801858 <sget+0x5c>
  801851:	b8 00 00 00 00       	mov    $0x0,%eax
  801856:	eb 27                	jmp    80187f <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801858:	83 ec 04             	sub    $0x4,%esp
  80185b:	ff 75 e8             	pushl  -0x18(%ebp)
  80185e:	ff 75 0c             	pushl  0xc(%ebp)
  801861:	ff 75 08             	pushl  0x8(%ebp)
  801864:	e8 09 03 00 00       	call   801b72 <sys_getSharedObject>
  801869:	83 c4 10             	add    $0x10,%esp
  80186c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80186f:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801873:	75 07                	jne    80187c <sget+0x80>
  801875:	b8 00 00 00 00       	mov    $0x0,%eax
  80187a:	eb 03                	jmp    80187f <sget+0x83>
	return ptr;
  80187c:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801887:	8b 55 08             	mov    0x8(%ebp),%edx
  80188a:	a1 20 50 80 00       	mov    0x805020,%eax
  80188f:	8b 40 78             	mov    0x78(%eax),%eax
  801892:	29 c2                	sub    %eax,%edx
  801894:	89 d0                	mov    %edx,%eax
  801896:	2d 00 10 00 00       	sub    $0x1000,%eax
  80189b:	c1 e8 0c             	shr    $0xc,%eax
  80189e:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8018a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8018a8:	83 ec 08             	sub    $0x8,%esp
  8018ab:	ff 75 08             	pushl  0x8(%ebp)
  8018ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b1:	e8 db 02 00 00       	call   801b91 <sys_freeSharedObject>
  8018b6:	83 c4 10             	add    $0x10,%esp
  8018b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8018bc:	90                   	nop
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
  8018c2:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018c5:	83 ec 04             	sub    $0x4,%esp
  8018c8:	68 00 47 80 00       	push   $0x804700
  8018cd:	68 dd 00 00 00       	push   $0xdd
  8018d2:	68 e2 46 80 00       	push   $0x8046e2
  8018d7:	e8 de ea ff ff       	call   8003ba <_panic>

008018dc <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018e2:	83 ec 04             	sub    $0x4,%esp
  8018e5:	68 26 47 80 00       	push   $0x804726
  8018ea:	68 e9 00 00 00       	push   $0xe9
  8018ef:	68 e2 46 80 00       	push   $0x8046e2
  8018f4:	e8 c1 ea ff ff       	call   8003ba <_panic>

008018f9 <shrink>:

}
void shrink(uint32 newSize)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
  8018fc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018ff:	83 ec 04             	sub    $0x4,%esp
  801902:	68 26 47 80 00       	push   $0x804726
  801907:	68 ee 00 00 00       	push   $0xee
  80190c:	68 e2 46 80 00       	push   $0x8046e2
  801911:	e8 a4 ea ff ff       	call   8003ba <_panic>

00801916 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80191c:	83 ec 04             	sub    $0x4,%esp
  80191f:	68 26 47 80 00       	push   $0x804726
  801924:	68 f3 00 00 00       	push   $0xf3
  801929:	68 e2 46 80 00       	push   $0x8046e2
  80192e:	e8 87 ea ff ff       	call   8003ba <_panic>

00801933 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	57                   	push   %edi
  801937:	56                   	push   %esi
  801938:	53                   	push   %ebx
  801939:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80193c:	8b 45 08             	mov    0x8(%ebp),%eax
  80193f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801942:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801945:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801948:	8b 7d 18             	mov    0x18(%ebp),%edi
  80194b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80194e:	cd 30                	int    $0x30
  801950:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801953:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801956:	83 c4 10             	add    $0x10,%esp
  801959:	5b                   	pop    %ebx
  80195a:	5e                   	pop    %esi
  80195b:	5f                   	pop    %edi
  80195c:	5d                   	pop    %ebp
  80195d:	c3                   	ret    

0080195e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	83 ec 04             	sub    $0x4,%esp
  801964:	8b 45 10             	mov    0x10(%ebp),%eax
  801967:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80196a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	52                   	push   %edx
  801976:	ff 75 0c             	pushl  0xc(%ebp)
  801979:	50                   	push   %eax
  80197a:	6a 00                	push   $0x0
  80197c:	e8 b2 ff ff ff       	call   801933 <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
}
  801984:	90                   	nop
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <sys_cgetc>:

int
sys_cgetc(void)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 02                	push   $0x2
  801996:	e8 98 ff ff ff       	call   801933 <syscall>
  80199b:	83 c4 18             	add    $0x18,%esp
}
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 03                	push   $0x3
  8019af:	e8 7f ff ff ff       	call   801933 <syscall>
  8019b4:	83 c4 18             	add    $0x18,%esp
}
  8019b7:	90                   	nop
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 04                	push   $0x4
  8019c9:	e8 65 ff ff ff       	call   801933 <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
}
  8019d1:	90                   	nop
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	52                   	push   %edx
  8019e4:	50                   	push   %eax
  8019e5:	6a 08                	push   $0x8
  8019e7:	e8 47 ff ff ff       	call   801933 <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
}
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	56                   	push   %esi
  8019f5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019f6:	8b 75 18             	mov    0x18(%ebp),%esi
  8019f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	56                   	push   %esi
  801a06:	53                   	push   %ebx
  801a07:	51                   	push   %ecx
  801a08:	52                   	push   %edx
  801a09:	50                   	push   %eax
  801a0a:	6a 09                	push   $0x9
  801a0c:	e8 22 ff ff ff       	call   801933 <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
}
  801a14:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a17:	5b                   	pop    %ebx
  801a18:	5e                   	pop    %esi
  801a19:	5d                   	pop    %ebp
  801a1a:	c3                   	ret    

00801a1b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	52                   	push   %edx
  801a2b:	50                   	push   %eax
  801a2c:	6a 0a                	push   $0xa
  801a2e:	e8 00 ff ff ff       	call   801933 <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	ff 75 0c             	pushl  0xc(%ebp)
  801a44:	ff 75 08             	pushl  0x8(%ebp)
  801a47:	6a 0b                	push   $0xb
  801a49:	e8 e5 fe ff ff       	call   801933 <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 0c                	push   $0xc
  801a62:	e8 cc fe ff ff       	call   801933 <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 0d                	push   $0xd
  801a7b:	e8 b3 fe ff ff       	call   801933 <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 0e                	push   $0xe
  801a94:	e8 9a fe ff ff       	call   801933 <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 0f                	push   $0xf
  801aad:	e8 81 fe ff ff       	call   801933 <syscall>
  801ab2:	83 c4 18             	add    $0x18,%esp
}
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	ff 75 08             	pushl  0x8(%ebp)
  801ac5:	6a 10                	push   $0x10
  801ac7:	e8 67 fe ff ff       	call   801933 <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
}
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 11                	push   $0x11
  801ae0:	e8 4e fe ff ff       	call   801933 <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
}
  801ae8:	90                   	nop
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <sys_cputc>:

void
sys_cputc(const char c)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	83 ec 04             	sub    $0x4,%esp
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801af7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	50                   	push   %eax
  801b04:	6a 01                	push   $0x1
  801b06:	e8 28 fe ff ff       	call   801933 <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
}
  801b0e:	90                   	nop
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 14                	push   $0x14
  801b20:	e8 0e fe ff ff       	call   801933 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	90                   	nop
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
  801b2e:	83 ec 04             	sub    $0x4,%esp
  801b31:	8b 45 10             	mov    0x10(%ebp),%eax
  801b34:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b37:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b3a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	6a 00                	push   $0x0
  801b43:	51                   	push   %ecx
  801b44:	52                   	push   %edx
  801b45:	ff 75 0c             	pushl  0xc(%ebp)
  801b48:	50                   	push   %eax
  801b49:	6a 15                	push   $0x15
  801b4b:	e8 e3 fd ff ff       	call   801933 <syscall>
  801b50:	83 c4 18             	add    $0x18,%esp
}
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	52                   	push   %edx
  801b65:	50                   	push   %eax
  801b66:	6a 16                	push   $0x16
  801b68:	e8 c6 fd ff ff       	call   801933 <syscall>
  801b6d:	83 c4 18             	add    $0x18,%esp
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b75:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	51                   	push   %ecx
  801b83:	52                   	push   %edx
  801b84:	50                   	push   %eax
  801b85:	6a 17                	push   $0x17
  801b87:	e8 a7 fd ff ff       	call   801933 <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	52                   	push   %edx
  801ba1:	50                   	push   %eax
  801ba2:	6a 18                	push   $0x18
  801ba4:	e8 8a fd ff ff       	call   801933 <syscall>
  801ba9:	83 c4 18             	add    $0x18,%esp
}
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb4:	6a 00                	push   $0x0
  801bb6:	ff 75 14             	pushl  0x14(%ebp)
  801bb9:	ff 75 10             	pushl  0x10(%ebp)
  801bbc:	ff 75 0c             	pushl  0xc(%ebp)
  801bbf:	50                   	push   %eax
  801bc0:	6a 19                	push   $0x19
  801bc2:	e8 6c fd ff ff       	call   801933 <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <sys_run_env>:

void sys_run_env(int32 envId)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	50                   	push   %eax
  801bdb:	6a 1a                	push   $0x1a
  801bdd:	e8 51 fd ff ff       	call   801933 <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
}
  801be5:	90                   	nop
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801beb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	50                   	push   %eax
  801bf7:	6a 1b                	push   $0x1b
  801bf9:	e8 35 fd ff ff       	call   801933 <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 05                	push   $0x5
  801c12:	e8 1c fd ff ff       	call   801933 <syscall>
  801c17:	83 c4 18             	add    $0x18,%esp
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 06                	push   $0x6
  801c2b:	e8 03 fd ff ff       	call   801933 <syscall>
  801c30:	83 c4 18             	add    $0x18,%esp
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 07                	push   $0x7
  801c44:	e8 ea fc ff ff       	call   801933 <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <sys_exit_env>:


void sys_exit_env(void)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 1c                	push   $0x1c
  801c5d:	e8 d1 fc ff ff       	call   801933 <syscall>
  801c62:	83 c4 18             	add    $0x18,%esp
}
  801c65:	90                   	nop
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
  801c6b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c6e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c71:	8d 50 04             	lea    0x4(%eax),%edx
  801c74:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	52                   	push   %edx
  801c7e:	50                   	push   %eax
  801c7f:	6a 1d                	push   $0x1d
  801c81:	e8 ad fc ff ff       	call   801933 <syscall>
  801c86:	83 c4 18             	add    $0x18,%esp
	return result;
  801c89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c8f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c92:	89 01                	mov    %eax,(%ecx)
  801c94:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c97:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9a:	c9                   	leave  
  801c9b:	c2 04 00             	ret    $0x4

00801c9e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	ff 75 10             	pushl  0x10(%ebp)
  801ca8:	ff 75 0c             	pushl  0xc(%ebp)
  801cab:	ff 75 08             	pushl  0x8(%ebp)
  801cae:	6a 13                	push   $0x13
  801cb0:	e8 7e fc ff ff       	call   801933 <syscall>
  801cb5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb8:	90                   	nop
}
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <sys_rcr2>:
uint32 sys_rcr2()
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 1e                	push   $0x1e
  801cca:	e8 64 fc ff ff       	call   801933 <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	83 ec 04             	sub    $0x4,%esp
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ce0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	50                   	push   %eax
  801ced:	6a 1f                	push   $0x1f
  801cef:	e8 3f fc ff ff       	call   801933 <syscall>
  801cf4:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf7:	90                   	nop
}
  801cf8:	c9                   	leave  
  801cf9:	c3                   	ret    

00801cfa <rsttst>:
void rsttst()
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 21                	push   $0x21
  801d09:	e8 25 fc ff ff       	call   801933 <syscall>
  801d0e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d11:	90                   	nop
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	83 ec 04             	sub    $0x4,%esp
  801d1a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d1d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d20:	8b 55 18             	mov    0x18(%ebp),%edx
  801d23:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d27:	52                   	push   %edx
  801d28:	50                   	push   %eax
  801d29:	ff 75 10             	pushl  0x10(%ebp)
  801d2c:	ff 75 0c             	pushl  0xc(%ebp)
  801d2f:	ff 75 08             	pushl  0x8(%ebp)
  801d32:	6a 20                	push   $0x20
  801d34:	e8 fa fb ff ff       	call   801933 <syscall>
  801d39:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3c:	90                   	nop
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <chktst>:
void chktst(uint32 n)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	ff 75 08             	pushl  0x8(%ebp)
  801d4d:	6a 22                	push   $0x22
  801d4f:	e8 df fb ff ff       	call   801933 <syscall>
  801d54:	83 c4 18             	add    $0x18,%esp
	return ;
  801d57:	90                   	nop
}
  801d58:	c9                   	leave  
  801d59:	c3                   	ret    

00801d5a <inctst>:

void inctst()
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 23                	push   $0x23
  801d69:	e8 c5 fb ff ff       	call   801933 <syscall>
  801d6e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d71:	90                   	nop
}
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <gettst>:
uint32 gettst()
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 24                	push   $0x24
  801d83:	e8 ab fb ff ff       	call   801933 <syscall>
  801d88:	83 c4 18             	add    $0x18,%esp
}
  801d8b:	c9                   	leave  
  801d8c:	c3                   	ret    

00801d8d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
  801d90:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 25                	push   $0x25
  801d9f:	e8 8f fb ff ff       	call   801933 <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
  801da7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801daa:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dae:	75 07                	jne    801db7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801db0:	b8 01 00 00 00       	mov    $0x1,%eax
  801db5:	eb 05                	jmp    801dbc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801db7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
  801dc1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 25                	push   $0x25
  801dd0:	e8 5e fb ff ff       	call   801933 <syscall>
  801dd5:	83 c4 18             	add    $0x18,%esp
  801dd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ddb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ddf:	75 07                	jne    801de8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801de1:	b8 01 00 00 00       	mov    $0x1,%eax
  801de6:	eb 05                	jmp    801ded <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801de8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
  801df2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 25                	push   $0x25
  801e01:	e8 2d fb ff ff       	call   801933 <syscall>
  801e06:	83 c4 18             	add    $0x18,%esp
  801e09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e0c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e10:	75 07                	jne    801e19 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e12:	b8 01 00 00 00       	mov    $0x1,%eax
  801e17:	eb 05                	jmp    801e1e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 25                	push   $0x25
  801e32:	e8 fc fa ff ff       	call   801933 <syscall>
  801e37:	83 c4 18             	add    $0x18,%esp
  801e3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e3d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e41:	75 07                	jne    801e4a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e43:	b8 01 00 00 00       	mov    $0x1,%eax
  801e48:	eb 05                	jmp    801e4f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	ff 75 08             	pushl  0x8(%ebp)
  801e5f:	6a 26                	push   $0x26
  801e61:	e8 cd fa ff ff       	call   801933 <syscall>
  801e66:	83 c4 18             	add    $0x18,%esp
	return ;
  801e69:	90                   	nop
}
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e70:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e73:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	6a 00                	push   $0x0
  801e7e:	53                   	push   %ebx
  801e7f:	51                   	push   %ecx
  801e80:	52                   	push   %edx
  801e81:	50                   	push   %eax
  801e82:	6a 27                	push   $0x27
  801e84:	e8 aa fa ff ff       	call   801933 <syscall>
  801e89:	83 c4 18             	add    $0x18,%esp
}
  801e8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e97:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	52                   	push   %edx
  801ea1:	50                   	push   %eax
  801ea2:	6a 28                	push   $0x28
  801ea4:	e8 8a fa ff ff       	call   801933 <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801eb1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801eb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	6a 00                	push   $0x0
  801ebc:	51                   	push   %ecx
  801ebd:	ff 75 10             	pushl  0x10(%ebp)
  801ec0:	52                   	push   %edx
  801ec1:	50                   	push   %eax
  801ec2:	6a 29                	push   $0x29
  801ec4:	e8 6a fa ff ff       	call   801933 <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
}
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    

00801ece <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	ff 75 10             	pushl  0x10(%ebp)
  801ed8:	ff 75 0c             	pushl  0xc(%ebp)
  801edb:	ff 75 08             	pushl  0x8(%ebp)
  801ede:	6a 12                	push   $0x12
  801ee0:	e8 4e fa ff ff       	call   801933 <syscall>
  801ee5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee8:	90                   	nop
}
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801eee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	52                   	push   %edx
  801efb:	50                   	push   %eax
  801efc:	6a 2a                	push   $0x2a
  801efe:	e8 30 fa ff ff       	call   801933 <syscall>
  801f03:	83 c4 18             	add    $0x18,%esp
	return;
  801f06:	90                   	nop
}
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    

00801f09 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	50                   	push   %eax
  801f18:	6a 2b                	push   $0x2b
  801f1a:	e8 14 fa ff ff       	call   801933 <syscall>
  801f1f:	83 c4 18             	add    $0x18,%esp
}
  801f22:	c9                   	leave  
  801f23:	c3                   	ret    

00801f24 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	ff 75 0c             	pushl  0xc(%ebp)
  801f30:	ff 75 08             	pushl  0x8(%ebp)
  801f33:	6a 2c                	push   $0x2c
  801f35:	e8 f9 f9 ff ff       	call   801933 <syscall>
  801f3a:	83 c4 18             	add    $0x18,%esp
	return;
  801f3d:	90                   	nop
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	ff 75 0c             	pushl  0xc(%ebp)
  801f4c:	ff 75 08             	pushl  0x8(%ebp)
  801f4f:	6a 2d                	push   $0x2d
  801f51:	e8 dd f9 ff ff       	call   801933 <syscall>
  801f56:	83 c4 18             	add    $0x18,%esp
	return;
  801f59:	90                   	nop
}
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	83 e8 04             	sub    $0x4,%eax
  801f68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f6e:	8b 00                	mov    (%eax),%eax
  801f70:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f73:	c9                   	leave  
  801f74:	c3                   	ret    

00801f75 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
  801f78:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7e:	83 e8 04             	sub    $0x4,%eax
  801f81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f87:	8b 00                	mov    (%eax),%eax
  801f89:	83 e0 01             	and    $0x1,%eax
  801f8c:	85 c0                	test   %eax,%eax
  801f8e:	0f 94 c0             	sete   %al
}
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
  801f96:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa3:	83 f8 02             	cmp    $0x2,%eax
  801fa6:	74 2b                	je     801fd3 <alloc_block+0x40>
  801fa8:	83 f8 02             	cmp    $0x2,%eax
  801fab:	7f 07                	jg     801fb4 <alloc_block+0x21>
  801fad:	83 f8 01             	cmp    $0x1,%eax
  801fb0:	74 0e                	je     801fc0 <alloc_block+0x2d>
  801fb2:	eb 58                	jmp    80200c <alloc_block+0x79>
  801fb4:	83 f8 03             	cmp    $0x3,%eax
  801fb7:	74 2d                	je     801fe6 <alloc_block+0x53>
  801fb9:	83 f8 04             	cmp    $0x4,%eax
  801fbc:	74 3b                	je     801ff9 <alloc_block+0x66>
  801fbe:	eb 4c                	jmp    80200c <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801fc0:	83 ec 0c             	sub    $0xc,%esp
  801fc3:	ff 75 08             	pushl  0x8(%ebp)
  801fc6:	e8 11 03 00 00       	call   8022dc <alloc_block_FF>
  801fcb:	83 c4 10             	add    $0x10,%esp
  801fce:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fd1:	eb 4a                	jmp    80201d <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801fd3:	83 ec 0c             	sub    $0xc,%esp
  801fd6:	ff 75 08             	pushl  0x8(%ebp)
  801fd9:	e8 fa 19 00 00       	call   8039d8 <alloc_block_NF>
  801fde:	83 c4 10             	add    $0x10,%esp
  801fe1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fe4:	eb 37                	jmp    80201d <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801fe6:	83 ec 0c             	sub    $0xc,%esp
  801fe9:	ff 75 08             	pushl  0x8(%ebp)
  801fec:	e8 a7 07 00 00       	call   802798 <alloc_block_BF>
  801ff1:	83 c4 10             	add    $0x10,%esp
  801ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ff7:	eb 24                	jmp    80201d <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801ff9:	83 ec 0c             	sub    $0xc,%esp
  801ffc:	ff 75 08             	pushl  0x8(%ebp)
  801fff:	e8 b7 19 00 00       	call   8039bb <alloc_block_WF>
  802004:	83 c4 10             	add    $0x10,%esp
  802007:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80200a:	eb 11                	jmp    80201d <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80200c:	83 ec 0c             	sub    $0xc,%esp
  80200f:	68 38 47 80 00       	push   $0x804738
  802014:	e8 5e e6 ff ff       	call   800677 <cprintf>
  802019:	83 c4 10             	add    $0x10,%esp
		break;
  80201c:	90                   	nop
	}
	return va;
  80201d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802020:	c9                   	leave  
  802021:	c3                   	ret    

00802022 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802022:	55                   	push   %ebp
  802023:	89 e5                	mov    %esp,%ebp
  802025:	53                   	push   %ebx
  802026:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802029:	83 ec 0c             	sub    $0xc,%esp
  80202c:	68 58 47 80 00       	push   $0x804758
  802031:	e8 41 e6 ff ff       	call   800677 <cprintf>
  802036:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802039:	83 ec 0c             	sub    $0xc,%esp
  80203c:	68 83 47 80 00       	push   $0x804783
  802041:	e8 31 e6 ff ff       	call   800677 <cprintf>
  802046:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802049:	8b 45 08             	mov    0x8(%ebp),%eax
  80204c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80204f:	eb 37                	jmp    802088 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802051:	83 ec 0c             	sub    $0xc,%esp
  802054:	ff 75 f4             	pushl  -0xc(%ebp)
  802057:	e8 19 ff ff ff       	call   801f75 <is_free_block>
  80205c:	83 c4 10             	add    $0x10,%esp
  80205f:	0f be d8             	movsbl %al,%ebx
  802062:	83 ec 0c             	sub    $0xc,%esp
  802065:	ff 75 f4             	pushl  -0xc(%ebp)
  802068:	e8 ef fe ff ff       	call   801f5c <get_block_size>
  80206d:	83 c4 10             	add    $0x10,%esp
  802070:	83 ec 04             	sub    $0x4,%esp
  802073:	53                   	push   %ebx
  802074:	50                   	push   %eax
  802075:	68 9b 47 80 00       	push   $0x80479b
  80207a:	e8 f8 e5 ff ff       	call   800677 <cprintf>
  80207f:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802082:	8b 45 10             	mov    0x10(%ebp),%eax
  802085:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802088:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80208c:	74 07                	je     802095 <print_blocks_list+0x73>
  80208e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802091:	8b 00                	mov    (%eax),%eax
  802093:	eb 05                	jmp    80209a <print_blocks_list+0x78>
  802095:	b8 00 00 00 00       	mov    $0x0,%eax
  80209a:	89 45 10             	mov    %eax,0x10(%ebp)
  80209d:	8b 45 10             	mov    0x10(%ebp),%eax
  8020a0:	85 c0                	test   %eax,%eax
  8020a2:	75 ad                	jne    802051 <print_blocks_list+0x2f>
  8020a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a8:	75 a7                	jne    802051 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8020aa:	83 ec 0c             	sub    $0xc,%esp
  8020ad:	68 58 47 80 00       	push   $0x804758
  8020b2:	e8 c0 e5 ff ff       	call   800677 <cprintf>
  8020b7:	83 c4 10             	add    $0x10,%esp

}
  8020ba:	90                   	nop
  8020bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020be:	c9                   	leave  
  8020bf:	c3                   	ret    

008020c0 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
  8020c3:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8020c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c9:	83 e0 01             	and    $0x1,%eax
  8020cc:	85 c0                	test   %eax,%eax
  8020ce:	74 03                	je     8020d3 <initialize_dynamic_allocator+0x13>
  8020d0:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8020d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020d7:	0f 84 c7 01 00 00    	je     8022a4 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8020dd:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8020e4:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8020e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ed:	01 d0                	add    %edx,%eax
  8020ef:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8020f4:	0f 87 ad 01 00 00    	ja     8022a7 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8020fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fd:	85 c0                	test   %eax,%eax
  8020ff:	0f 89 a5 01 00 00    	jns    8022aa <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802105:	8b 55 08             	mov    0x8(%ebp),%edx
  802108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80210b:	01 d0                	add    %edx,%eax
  80210d:	83 e8 04             	sub    $0x4,%eax
  802110:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802115:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80211c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802121:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802124:	e9 87 00 00 00       	jmp    8021b0 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802129:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80212d:	75 14                	jne    802143 <initialize_dynamic_allocator+0x83>
  80212f:	83 ec 04             	sub    $0x4,%esp
  802132:	68 b3 47 80 00       	push   $0x8047b3
  802137:	6a 79                	push   $0x79
  802139:	68 d1 47 80 00       	push   $0x8047d1
  80213e:	e8 77 e2 ff ff       	call   8003ba <_panic>
  802143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802146:	8b 00                	mov    (%eax),%eax
  802148:	85 c0                	test   %eax,%eax
  80214a:	74 10                	je     80215c <initialize_dynamic_allocator+0x9c>
  80214c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214f:	8b 00                	mov    (%eax),%eax
  802151:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802154:	8b 52 04             	mov    0x4(%edx),%edx
  802157:	89 50 04             	mov    %edx,0x4(%eax)
  80215a:	eb 0b                	jmp    802167 <initialize_dynamic_allocator+0xa7>
  80215c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215f:	8b 40 04             	mov    0x4(%eax),%eax
  802162:	a3 30 50 80 00       	mov    %eax,0x805030
  802167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216a:	8b 40 04             	mov    0x4(%eax),%eax
  80216d:	85 c0                	test   %eax,%eax
  80216f:	74 0f                	je     802180 <initialize_dynamic_allocator+0xc0>
  802171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802174:	8b 40 04             	mov    0x4(%eax),%eax
  802177:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80217a:	8b 12                	mov    (%edx),%edx
  80217c:	89 10                	mov    %edx,(%eax)
  80217e:	eb 0a                	jmp    80218a <initialize_dynamic_allocator+0xca>
  802180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802183:	8b 00                	mov    (%eax),%eax
  802185:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80218a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802196:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80219d:	a1 38 50 80 00       	mov    0x805038,%eax
  8021a2:	48                   	dec    %eax
  8021a3:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8021a8:	a1 34 50 80 00       	mov    0x805034,%eax
  8021ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b4:	74 07                	je     8021bd <initialize_dynamic_allocator+0xfd>
  8021b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b9:	8b 00                	mov    (%eax),%eax
  8021bb:	eb 05                	jmp    8021c2 <initialize_dynamic_allocator+0x102>
  8021bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c2:	a3 34 50 80 00       	mov    %eax,0x805034
  8021c7:	a1 34 50 80 00       	mov    0x805034,%eax
  8021cc:	85 c0                	test   %eax,%eax
  8021ce:	0f 85 55 ff ff ff    	jne    802129 <initialize_dynamic_allocator+0x69>
  8021d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021d8:	0f 85 4b ff ff ff    	jne    802129 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8021e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8021ed:	a1 44 50 80 00       	mov    0x805044,%eax
  8021f2:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8021f7:	a1 40 50 80 00       	mov    0x805040,%eax
  8021fc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802202:	8b 45 08             	mov    0x8(%ebp),%eax
  802205:	83 c0 08             	add    $0x8,%eax
  802208:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	83 c0 04             	add    $0x4,%eax
  802211:	8b 55 0c             	mov    0xc(%ebp),%edx
  802214:	83 ea 08             	sub    $0x8,%edx
  802217:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802219:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221c:	8b 45 08             	mov    0x8(%ebp),%eax
  80221f:	01 d0                	add    %edx,%eax
  802221:	83 e8 08             	sub    $0x8,%eax
  802224:	8b 55 0c             	mov    0xc(%ebp),%edx
  802227:	83 ea 08             	sub    $0x8,%edx
  80222a:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80222c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802235:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802238:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80223f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802243:	75 17                	jne    80225c <initialize_dynamic_allocator+0x19c>
  802245:	83 ec 04             	sub    $0x4,%esp
  802248:	68 ec 47 80 00       	push   $0x8047ec
  80224d:	68 90 00 00 00       	push   $0x90
  802252:	68 d1 47 80 00       	push   $0x8047d1
  802257:	e8 5e e1 ff ff       	call   8003ba <_panic>
  80225c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802262:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802265:	89 10                	mov    %edx,(%eax)
  802267:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226a:	8b 00                	mov    (%eax),%eax
  80226c:	85 c0                	test   %eax,%eax
  80226e:	74 0d                	je     80227d <initialize_dynamic_allocator+0x1bd>
  802270:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802275:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802278:	89 50 04             	mov    %edx,0x4(%eax)
  80227b:	eb 08                	jmp    802285 <initialize_dynamic_allocator+0x1c5>
  80227d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802280:	a3 30 50 80 00       	mov    %eax,0x805030
  802285:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802288:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80228d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802290:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802297:	a1 38 50 80 00       	mov    0x805038,%eax
  80229c:	40                   	inc    %eax
  80229d:	a3 38 50 80 00       	mov    %eax,0x805038
  8022a2:	eb 07                	jmp    8022ab <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8022a4:	90                   	nop
  8022a5:	eb 04                	jmp    8022ab <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8022a7:	90                   	nop
  8022a8:	eb 01                	jmp    8022ab <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8022aa:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8022b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8022b3:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8022b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b9:	8d 50 fc             	lea    -0x4(%eax),%edx
  8022bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022bf:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8022c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c4:	83 e8 04             	sub    $0x4,%eax
  8022c7:	8b 00                	mov    (%eax),%eax
  8022c9:	83 e0 fe             	and    $0xfffffffe,%eax
  8022cc:	8d 50 f8             	lea    -0x8(%eax),%edx
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	01 c2                	add    %eax,%edx
  8022d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d7:	89 02                	mov    %eax,(%edx)
}
  8022d9:	90                   	nop
  8022da:	5d                   	pop    %ebp
  8022db:	c3                   	ret    

008022dc <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
  8022df:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e5:	83 e0 01             	and    $0x1,%eax
  8022e8:	85 c0                	test   %eax,%eax
  8022ea:	74 03                	je     8022ef <alloc_block_FF+0x13>
  8022ec:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8022ef:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8022f3:	77 07                	ja     8022fc <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8022f5:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8022fc:	a1 24 50 80 00       	mov    0x805024,%eax
  802301:	85 c0                	test   %eax,%eax
  802303:	75 73                	jne    802378 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	83 c0 10             	add    $0x10,%eax
  80230b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80230e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802315:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802318:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80231b:	01 d0                	add    %edx,%eax
  80231d:	48                   	dec    %eax
  80231e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802321:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802324:	ba 00 00 00 00       	mov    $0x0,%edx
  802329:	f7 75 ec             	divl   -0x14(%ebp)
  80232c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80232f:	29 d0                	sub    %edx,%eax
  802331:	c1 e8 0c             	shr    $0xc,%eax
  802334:	83 ec 0c             	sub    $0xc,%esp
  802337:	50                   	push   %eax
  802338:	e8 d4 f0 ff ff       	call   801411 <sbrk>
  80233d:	83 c4 10             	add    $0x10,%esp
  802340:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802343:	83 ec 0c             	sub    $0xc,%esp
  802346:	6a 00                	push   $0x0
  802348:	e8 c4 f0 ff ff       	call   801411 <sbrk>
  80234d:	83 c4 10             	add    $0x10,%esp
  802350:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802353:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802356:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802359:	83 ec 08             	sub    $0x8,%esp
  80235c:	50                   	push   %eax
  80235d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802360:	e8 5b fd ff ff       	call   8020c0 <initialize_dynamic_allocator>
  802365:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802368:	83 ec 0c             	sub    $0xc,%esp
  80236b:	68 0f 48 80 00       	push   $0x80480f
  802370:	e8 02 e3 ff ff       	call   800677 <cprintf>
  802375:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802378:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80237c:	75 0a                	jne    802388 <alloc_block_FF+0xac>
	        return NULL;
  80237e:	b8 00 00 00 00       	mov    $0x0,%eax
  802383:	e9 0e 04 00 00       	jmp    802796 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802388:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80238f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802394:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802397:	e9 f3 02 00 00       	jmp    80268f <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80239c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239f:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8023a2:	83 ec 0c             	sub    $0xc,%esp
  8023a5:	ff 75 bc             	pushl  -0x44(%ebp)
  8023a8:	e8 af fb ff ff       	call   801f5c <get_block_size>
  8023ad:	83 c4 10             	add    $0x10,%esp
  8023b0:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8023b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b6:	83 c0 08             	add    $0x8,%eax
  8023b9:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023bc:	0f 87 c5 02 00 00    	ja     802687 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	83 c0 18             	add    $0x18,%eax
  8023c8:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023cb:	0f 87 19 02 00 00    	ja     8025ea <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8023d1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8023d4:	2b 45 08             	sub    0x8(%ebp),%eax
  8023d7:	83 e8 08             	sub    $0x8,%eax
  8023da:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8023dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e0:	8d 50 08             	lea    0x8(%eax),%edx
  8023e3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023e6:	01 d0                	add    %edx,%eax
  8023e8:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8023eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ee:	83 c0 08             	add    $0x8,%eax
  8023f1:	83 ec 04             	sub    $0x4,%esp
  8023f4:	6a 01                	push   $0x1
  8023f6:	50                   	push   %eax
  8023f7:	ff 75 bc             	pushl  -0x44(%ebp)
  8023fa:	e8 ae fe ff ff       	call   8022ad <set_block_data>
  8023ff:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802405:	8b 40 04             	mov    0x4(%eax),%eax
  802408:	85 c0                	test   %eax,%eax
  80240a:	75 68                	jne    802474 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80240c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802410:	75 17                	jne    802429 <alloc_block_FF+0x14d>
  802412:	83 ec 04             	sub    $0x4,%esp
  802415:	68 ec 47 80 00       	push   $0x8047ec
  80241a:	68 d7 00 00 00       	push   $0xd7
  80241f:	68 d1 47 80 00       	push   $0x8047d1
  802424:	e8 91 df ff ff       	call   8003ba <_panic>
  802429:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80242f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802432:	89 10                	mov    %edx,(%eax)
  802434:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802437:	8b 00                	mov    (%eax),%eax
  802439:	85 c0                	test   %eax,%eax
  80243b:	74 0d                	je     80244a <alloc_block_FF+0x16e>
  80243d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802442:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802445:	89 50 04             	mov    %edx,0x4(%eax)
  802448:	eb 08                	jmp    802452 <alloc_block_FF+0x176>
  80244a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80244d:	a3 30 50 80 00       	mov    %eax,0x805030
  802452:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802455:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80245a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80245d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802464:	a1 38 50 80 00       	mov    0x805038,%eax
  802469:	40                   	inc    %eax
  80246a:	a3 38 50 80 00       	mov    %eax,0x805038
  80246f:	e9 dc 00 00 00       	jmp    802550 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802477:	8b 00                	mov    (%eax),%eax
  802479:	85 c0                	test   %eax,%eax
  80247b:	75 65                	jne    8024e2 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80247d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802481:	75 17                	jne    80249a <alloc_block_FF+0x1be>
  802483:	83 ec 04             	sub    $0x4,%esp
  802486:	68 20 48 80 00       	push   $0x804820
  80248b:	68 db 00 00 00       	push   $0xdb
  802490:	68 d1 47 80 00       	push   $0x8047d1
  802495:	e8 20 df ff ff       	call   8003ba <_panic>
  80249a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8024a0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024a3:	89 50 04             	mov    %edx,0x4(%eax)
  8024a6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024a9:	8b 40 04             	mov    0x4(%eax),%eax
  8024ac:	85 c0                	test   %eax,%eax
  8024ae:	74 0c                	je     8024bc <alloc_block_FF+0x1e0>
  8024b0:	a1 30 50 80 00       	mov    0x805030,%eax
  8024b5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024b8:	89 10                	mov    %edx,(%eax)
  8024ba:	eb 08                	jmp    8024c4 <alloc_block_FF+0x1e8>
  8024bc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024bf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024c4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024c7:	a3 30 50 80 00       	mov    %eax,0x805030
  8024cc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d5:	a1 38 50 80 00       	mov    0x805038,%eax
  8024da:	40                   	inc    %eax
  8024db:	a3 38 50 80 00       	mov    %eax,0x805038
  8024e0:	eb 6e                	jmp    802550 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8024e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e6:	74 06                	je     8024ee <alloc_block_FF+0x212>
  8024e8:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024ec:	75 17                	jne    802505 <alloc_block_FF+0x229>
  8024ee:	83 ec 04             	sub    $0x4,%esp
  8024f1:	68 44 48 80 00       	push   $0x804844
  8024f6:	68 df 00 00 00       	push   $0xdf
  8024fb:	68 d1 47 80 00       	push   $0x8047d1
  802500:	e8 b5 de ff ff       	call   8003ba <_panic>
  802505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802508:	8b 10                	mov    (%eax),%edx
  80250a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80250d:	89 10                	mov    %edx,(%eax)
  80250f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802512:	8b 00                	mov    (%eax),%eax
  802514:	85 c0                	test   %eax,%eax
  802516:	74 0b                	je     802523 <alloc_block_FF+0x247>
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 00                	mov    (%eax),%eax
  80251d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802520:	89 50 04             	mov    %edx,0x4(%eax)
  802523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802526:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802529:	89 10                	mov    %edx,(%eax)
  80252b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80252e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802531:	89 50 04             	mov    %edx,0x4(%eax)
  802534:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802537:	8b 00                	mov    (%eax),%eax
  802539:	85 c0                	test   %eax,%eax
  80253b:	75 08                	jne    802545 <alloc_block_FF+0x269>
  80253d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802540:	a3 30 50 80 00       	mov    %eax,0x805030
  802545:	a1 38 50 80 00       	mov    0x805038,%eax
  80254a:	40                   	inc    %eax
  80254b:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802550:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802554:	75 17                	jne    80256d <alloc_block_FF+0x291>
  802556:	83 ec 04             	sub    $0x4,%esp
  802559:	68 b3 47 80 00       	push   $0x8047b3
  80255e:	68 e1 00 00 00       	push   $0xe1
  802563:	68 d1 47 80 00       	push   $0x8047d1
  802568:	e8 4d de ff ff       	call   8003ba <_panic>
  80256d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802570:	8b 00                	mov    (%eax),%eax
  802572:	85 c0                	test   %eax,%eax
  802574:	74 10                	je     802586 <alloc_block_FF+0x2aa>
  802576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802579:	8b 00                	mov    (%eax),%eax
  80257b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257e:	8b 52 04             	mov    0x4(%edx),%edx
  802581:	89 50 04             	mov    %edx,0x4(%eax)
  802584:	eb 0b                	jmp    802591 <alloc_block_FF+0x2b5>
  802586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802589:	8b 40 04             	mov    0x4(%eax),%eax
  80258c:	a3 30 50 80 00       	mov    %eax,0x805030
  802591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802594:	8b 40 04             	mov    0x4(%eax),%eax
  802597:	85 c0                	test   %eax,%eax
  802599:	74 0f                	je     8025aa <alloc_block_FF+0x2ce>
  80259b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259e:	8b 40 04             	mov    0x4(%eax),%eax
  8025a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a4:	8b 12                	mov    (%edx),%edx
  8025a6:	89 10                	mov    %edx,(%eax)
  8025a8:	eb 0a                	jmp    8025b4 <alloc_block_FF+0x2d8>
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	8b 00                	mov    (%eax),%eax
  8025af:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c7:	a1 38 50 80 00       	mov    0x805038,%eax
  8025cc:	48                   	dec    %eax
  8025cd:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8025d2:	83 ec 04             	sub    $0x4,%esp
  8025d5:	6a 00                	push   $0x0
  8025d7:	ff 75 b4             	pushl  -0x4c(%ebp)
  8025da:	ff 75 b0             	pushl  -0x50(%ebp)
  8025dd:	e8 cb fc ff ff       	call   8022ad <set_block_data>
  8025e2:	83 c4 10             	add    $0x10,%esp
  8025e5:	e9 95 00 00 00       	jmp    80267f <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8025ea:	83 ec 04             	sub    $0x4,%esp
  8025ed:	6a 01                	push   $0x1
  8025ef:	ff 75 b8             	pushl  -0x48(%ebp)
  8025f2:	ff 75 bc             	pushl  -0x44(%ebp)
  8025f5:	e8 b3 fc ff ff       	call   8022ad <set_block_data>
  8025fa:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8025fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802601:	75 17                	jne    80261a <alloc_block_FF+0x33e>
  802603:	83 ec 04             	sub    $0x4,%esp
  802606:	68 b3 47 80 00       	push   $0x8047b3
  80260b:	68 e8 00 00 00       	push   $0xe8
  802610:	68 d1 47 80 00       	push   $0x8047d1
  802615:	e8 a0 dd ff ff       	call   8003ba <_panic>
  80261a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261d:	8b 00                	mov    (%eax),%eax
  80261f:	85 c0                	test   %eax,%eax
  802621:	74 10                	je     802633 <alloc_block_FF+0x357>
  802623:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802626:	8b 00                	mov    (%eax),%eax
  802628:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262b:	8b 52 04             	mov    0x4(%edx),%edx
  80262e:	89 50 04             	mov    %edx,0x4(%eax)
  802631:	eb 0b                	jmp    80263e <alloc_block_FF+0x362>
  802633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802636:	8b 40 04             	mov    0x4(%eax),%eax
  802639:	a3 30 50 80 00       	mov    %eax,0x805030
  80263e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802641:	8b 40 04             	mov    0x4(%eax),%eax
  802644:	85 c0                	test   %eax,%eax
  802646:	74 0f                	je     802657 <alloc_block_FF+0x37b>
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	8b 40 04             	mov    0x4(%eax),%eax
  80264e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802651:	8b 12                	mov    (%edx),%edx
  802653:	89 10                	mov    %edx,(%eax)
  802655:	eb 0a                	jmp    802661 <alloc_block_FF+0x385>
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
	            }
	            return va;
  80267f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802682:	e9 0f 01 00 00       	jmp    802796 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802687:	a1 34 50 80 00       	mov    0x805034,%eax
  80268c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80268f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802693:	74 07                	je     80269c <alloc_block_FF+0x3c0>
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8b 00                	mov    (%eax),%eax
  80269a:	eb 05                	jmp    8026a1 <alloc_block_FF+0x3c5>
  80269c:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a1:	a3 34 50 80 00       	mov    %eax,0x805034
  8026a6:	a1 34 50 80 00       	mov    0x805034,%eax
  8026ab:	85 c0                	test   %eax,%eax
  8026ad:	0f 85 e9 fc ff ff    	jne    80239c <alloc_block_FF+0xc0>
  8026b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b7:	0f 85 df fc ff ff    	jne    80239c <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8026bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c0:	83 c0 08             	add    $0x8,%eax
  8026c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8026c6:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026d3:	01 d0                	add    %edx,%eax
  8026d5:	48                   	dec    %eax
  8026d6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8026e1:	f7 75 d8             	divl   -0x28(%ebp)
  8026e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026e7:	29 d0                	sub    %edx,%eax
  8026e9:	c1 e8 0c             	shr    $0xc,%eax
  8026ec:	83 ec 0c             	sub    $0xc,%esp
  8026ef:	50                   	push   %eax
  8026f0:	e8 1c ed ff ff       	call   801411 <sbrk>
  8026f5:	83 c4 10             	add    $0x10,%esp
  8026f8:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8026fb:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8026ff:	75 0a                	jne    80270b <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802701:	b8 00 00 00 00       	mov    $0x0,%eax
  802706:	e9 8b 00 00 00       	jmp    802796 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80270b:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802712:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802715:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802718:	01 d0                	add    %edx,%eax
  80271a:	48                   	dec    %eax
  80271b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80271e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802721:	ba 00 00 00 00       	mov    $0x0,%edx
  802726:	f7 75 cc             	divl   -0x34(%ebp)
  802729:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80272c:	29 d0                	sub    %edx,%eax
  80272e:	8d 50 fc             	lea    -0x4(%eax),%edx
  802731:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802734:	01 d0                	add    %edx,%eax
  802736:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80273b:	a1 40 50 80 00       	mov    0x805040,%eax
  802740:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802746:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80274d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802750:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802753:	01 d0                	add    %edx,%eax
  802755:	48                   	dec    %eax
  802756:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802759:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80275c:	ba 00 00 00 00       	mov    $0x0,%edx
  802761:	f7 75 c4             	divl   -0x3c(%ebp)
  802764:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802767:	29 d0                	sub    %edx,%eax
  802769:	83 ec 04             	sub    $0x4,%esp
  80276c:	6a 01                	push   $0x1
  80276e:	50                   	push   %eax
  80276f:	ff 75 d0             	pushl  -0x30(%ebp)
  802772:	e8 36 fb ff ff       	call   8022ad <set_block_data>
  802777:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80277a:	83 ec 0c             	sub    $0xc,%esp
  80277d:	ff 75 d0             	pushl  -0x30(%ebp)
  802780:	e8 1b 0a 00 00       	call   8031a0 <free_block>
  802785:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802788:	83 ec 0c             	sub    $0xc,%esp
  80278b:	ff 75 08             	pushl  0x8(%ebp)
  80278e:	e8 49 fb ff ff       	call   8022dc <alloc_block_FF>
  802793:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802796:	c9                   	leave  
  802797:	c3                   	ret    

00802798 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802798:	55                   	push   %ebp
  802799:	89 e5                	mov    %esp,%ebp
  80279b:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80279e:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a1:	83 e0 01             	and    $0x1,%eax
  8027a4:	85 c0                	test   %eax,%eax
  8027a6:	74 03                	je     8027ab <alloc_block_BF+0x13>
  8027a8:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8027ab:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8027af:	77 07                	ja     8027b8 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027b1:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027b8:	a1 24 50 80 00       	mov    0x805024,%eax
  8027bd:	85 c0                	test   %eax,%eax
  8027bf:	75 73                	jne    802834 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c4:	83 c0 10             	add    $0x10,%eax
  8027c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027ca:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8027d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027d7:	01 d0                	add    %edx,%eax
  8027d9:	48                   	dec    %eax
  8027da:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8027dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8027e5:	f7 75 e0             	divl   -0x20(%ebp)
  8027e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027eb:	29 d0                	sub    %edx,%eax
  8027ed:	c1 e8 0c             	shr    $0xc,%eax
  8027f0:	83 ec 0c             	sub    $0xc,%esp
  8027f3:	50                   	push   %eax
  8027f4:	e8 18 ec ff ff       	call   801411 <sbrk>
  8027f9:	83 c4 10             	add    $0x10,%esp
  8027fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8027ff:	83 ec 0c             	sub    $0xc,%esp
  802802:	6a 00                	push   $0x0
  802804:	e8 08 ec ff ff       	call   801411 <sbrk>
  802809:	83 c4 10             	add    $0x10,%esp
  80280c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80280f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802812:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802815:	83 ec 08             	sub    $0x8,%esp
  802818:	50                   	push   %eax
  802819:	ff 75 d8             	pushl  -0x28(%ebp)
  80281c:	e8 9f f8 ff ff       	call   8020c0 <initialize_dynamic_allocator>
  802821:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802824:	83 ec 0c             	sub    $0xc,%esp
  802827:	68 0f 48 80 00       	push   $0x80480f
  80282c:	e8 46 de ff ff       	call   800677 <cprintf>
  802831:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802834:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80283b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802842:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802849:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802850:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802855:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802858:	e9 1d 01 00 00       	jmp    80297a <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802863:	83 ec 0c             	sub    $0xc,%esp
  802866:	ff 75 a8             	pushl  -0x58(%ebp)
  802869:	e8 ee f6 ff ff       	call   801f5c <get_block_size>
  80286e:	83 c4 10             	add    $0x10,%esp
  802871:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802874:	8b 45 08             	mov    0x8(%ebp),%eax
  802877:	83 c0 08             	add    $0x8,%eax
  80287a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80287d:	0f 87 ef 00 00 00    	ja     802972 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802883:	8b 45 08             	mov    0x8(%ebp),%eax
  802886:	83 c0 18             	add    $0x18,%eax
  802889:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80288c:	77 1d                	ja     8028ab <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80288e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802891:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802894:	0f 86 d8 00 00 00    	jbe    802972 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80289a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80289d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8028a0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028a6:	e9 c7 00 00 00       	jmp    802972 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8028ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ae:	83 c0 08             	add    $0x8,%eax
  8028b1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028b4:	0f 85 9d 00 00 00    	jne    802957 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8028ba:	83 ec 04             	sub    $0x4,%esp
  8028bd:	6a 01                	push   $0x1
  8028bf:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028c2:	ff 75 a8             	pushl  -0x58(%ebp)
  8028c5:	e8 e3 f9 ff ff       	call   8022ad <set_block_data>
  8028ca:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8028cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d1:	75 17                	jne    8028ea <alloc_block_BF+0x152>
  8028d3:	83 ec 04             	sub    $0x4,%esp
  8028d6:	68 b3 47 80 00       	push   $0x8047b3
  8028db:	68 2c 01 00 00       	push   $0x12c
  8028e0:	68 d1 47 80 00       	push   $0x8047d1
  8028e5:	e8 d0 da ff ff       	call   8003ba <_panic>
  8028ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ed:	8b 00                	mov    (%eax),%eax
  8028ef:	85 c0                	test   %eax,%eax
  8028f1:	74 10                	je     802903 <alloc_block_BF+0x16b>
  8028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f6:	8b 00                	mov    (%eax),%eax
  8028f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028fb:	8b 52 04             	mov    0x4(%edx),%edx
  8028fe:	89 50 04             	mov    %edx,0x4(%eax)
  802901:	eb 0b                	jmp    80290e <alloc_block_BF+0x176>
  802903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802906:	8b 40 04             	mov    0x4(%eax),%eax
  802909:	a3 30 50 80 00       	mov    %eax,0x805030
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	8b 40 04             	mov    0x4(%eax),%eax
  802914:	85 c0                	test   %eax,%eax
  802916:	74 0f                	je     802927 <alloc_block_BF+0x18f>
  802918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291b:	8b 40 04             	mov    0x4(%eax),%eax
  80291e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802921:	8b 12                	mov    (%edx),%edx
  802923:	89 10                	mov    %edx,(%eax)
  802925:	eb 0a                	jmp    802931 <alloc_block_BF+0x199>
  802927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292a:	8b 00                	mov    (%eax),%eax
  80292c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802934:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80293a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802944:	a1 38 50 80 00       	mov    0x805038,%eax
  802949:	48                   	dec    %eax
  80294a:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80294f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802952:	e9 24 04 00 00       	jmp    802d7b <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802957:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80295d:	76 13                	jbe    802972 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80295f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802966:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802969:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80296c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80296f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802972:	a1 34 50 80 00       	mov    0x805034,%eax
  802977:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80297a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297e:	74 07                	je     802987 <alloc_block_BF+0x1ef>
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	8b 00                	mov    (%eax),%eax
  802985:	eb 05                	jmp    80298c <alloc_block_BF+0x1f4>
  802987:	b8 00 00 00 00       	mov    $0x0,%eax
  80298c:	a3 34 50 80 00       	mov    %eax,0x805034
  802991:	a1 34 50 80 00       	mov    0x805034,%eax
  802996:	85 c0                	test   %eax,%eax
  802998:	0f 85 bf fe ff ff    	jne    80285d <alloc_block_BF+0xc5>
  80299e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a2:	0f 85 b5 fe ff ff    	jne    80285d <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8029a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029ac:	0f 84 26 02 00 00    	je     802bd8 <alloc_block_BF+0x440>
  8029b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029b6:	0f 85 1c 02 00 00    	jne    802bd8 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8029bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029bf:	2b 45 08             	sub    0x8(%ebp),%eax
  8029c2:	83 e8 08             	sub    $0x8,%eax
  8029c5:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8029c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cb:	8d 50 08             	lea    0x8(%eax),%edx
  8029ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d1:	01 d0                	add    %edx,%eax
  8029d3:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d9:	83 c0 08             	add    $0x8,%eax
  8029dc:	83 ec 04             	sub    $0x4,%esp
  8029df:	6a 01                	push   $0x1
  8029e1:	50                   	push   %eax
  8029e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8029e5:	e8 c3 f8 ff ff       	call   8022ad <set_block_data>
  8029ea:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8029ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f0:	8b 40 04             	mov    0x4(%eax),%eax
  8029f3:	85 c0                	test   %eax,%eax
  8029f5:	75 68                	jne    802a5f <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029f7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029fb:	75 17                	jne    802a14 <alloc_block_BF+0x27c>
  8029fd:	83 ec 04             	sub    $0x4,%esp
  802a00:	68 ec 47 80 00       	push   $0x8047ec
  802a05:	68 45 01 00 00       	push   $0x145
  802a0a:	68 d1 47 80 00       	push   $0x8047d1
  802a0f:	e8 a6 d9 ff ff       	call   8003ba <_panic>
  802a14:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a1a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a1d:	89 10                	mov    %edx,(%eax)
  802a1f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a22:	8b 00                	mov    (%eax),%eax
  802a24:	85 c0                	test   %eax,%eax
  802a26:	74 0d                	je     802a35 <alloc_block_BF+0x29d>
  802a28:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a2d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a30:	89 50 04             	mov    %edx,0x4(%eax)
  802a33:	eb 08                	jmp    802a3d <alloc_block_BF+0x2a5>
  802a35:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a38:	a3 30 50 80 00       	mov    %eax,0x805030
  802a3d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a40:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a45:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a4f:	a1 38 50 80 00       	mov    0x805038,%eax
  802a54:	40                   	inc    %eax
  802a55:	a3 38 50 80 00       	mov    %eax,0x805038
  802a5a:	e9 dc 00 00 00       	jmp    802b3b <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a62:	8b 00                	mov    (%eax),%eax
  802a64:	85 c0                	test   %eax,%eax
  802a66:	75 65                	jne    802acd <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a68:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a6c:	75 17                	jne    802a85 <alloc_block_BF+0x2ed>
  802a6e:	83 ec 04             	sub    $0x4,%esp
  802a71:	68 20 48 80 00       	push   $0x804820
  802a76:	68 4a 01 00 00       	push   $0x14a
  802a7b:	68 d1 47 80 00       	push   $0x8047d1
  802a80:	e8 35 d9 ff ff       	call   8003ba <_panic>
  802a85:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a8b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a8e:	89 50 04             	mov    %edx,0x4(%eax)
  802a91:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a94:	8b 40 04             	mov    0x4(%eax),%eax
  802a97:	85 c0                	test   %eax,%eax
  802a99:	74 0c                	je     802aa7 <alloc_block_BF+0x30f>
  802a9b:	a1 30 50 80 00       	mov    0x805030,%eax
  802aa0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802aa3:	89 10                	mov    %edx,(%eax)
  802aa5:	eb 08                	jmp    802aaf <alloc_block_BF+0x317>
  802aa7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aaa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802aaf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ab2:	a3 30 50 80 00       	mov    %eax,0x805030
  802ab7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac0:	a1 38 50 80 00       	mov    0x805038,%eax
  802ac5:	40                   	inc    %eax
  802ac6:	a3 38 50 80 00       	mov    %eax,0x805038
  802acb:	eb 6e                	jmp    802b3b <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802acd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ad1:	74 06                	je     802ad9 <alloc_block_BF+0x341>
  802ad3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ad7:	75 17                	jne    802af0 <alloc_block_BF+0x358>
  802ad9:	83 ec 04             	sub    $0x4,%esp
  802adc:	68 44 48 80 00       	push   $0x804844
  802ae1:	68 4f 01 00 00       	push   $0x14f
  802ae6:	68 d1 47 80 00       	push   $0x8047d1
  802aeb:	e8 ca d8 ff ff       	call   8003ba <_panic>
  802af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af3:	8b 10                	mov    (%eax),%edx
  802af5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802af8:	89 10                	mov    %edx,(%eax)
  802afa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802afd:	8b 00                	mov    (%eax),%eax
  802aff:	85 c0                	test   %eax,%eax
  802b01:	74 0b                	je     802b0e <alloc_block_BF+0x376>
  802b03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b06:	8b 00                	mov    (%eax),%eax
  802b08:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b0b:	89 50 04             	mov    %edx,0x4(%eax)
  802b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b11:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b14:	89 10                	mov    %edx,(%eax)
  802b16:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b19:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b1c:	89 50 04             	mov    %edx,0x4(%eax)
  802b1f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b22:	8b 00                	mov    (%eax),%eax
  802b24:	85 c0                	test   %eax,%eax
  802b26:	75 08                	jne    802b30 <alloc_block_BF+0x398>
  802b28:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b2b:	a3 30 50 80 00       	mov    %eax,0x805030
  802b30:	a1 38 50 80 00       	mov    0x805038,%eax
  802b35:	40                   	inc    %eax
  802b36:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b3f:	75 17                	jne    802b58 <alloc_block_BF+0x3c0>
  802b41:	83 ec 04             	sub    $0x4,%esp
  802b44:	68 b3 47 80 00       	push   $0x8047b3
  802b49:	68 51 01 00 00       	push   $0x151
  802b4e:	68 d1 47 80 00       	push   $0x8047d1
  802b53:	e8 62 d8 ff ff       	call   8003ba <_panic>
  802b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5b:	8b 00                	mov    (%eax),%eax
  802b5d:	85 c0                	test   %eax,%eax
  802b5f:	74 10                	je     802b71 <alloc_block_BF+0x3d9>
  802b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b64:	8b 00                	mov    (%eax),%eax
  802b66:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b69:	8b 52 04             	mov    0x4(%edx),%edx
  802b6c:	89 50 04             	mov    %edx,0x4(%eax)
  802b6f:	eb 0b                	jmp    802b7c <alloc_block_BF+0x3e4>
  802b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b74:	8b 40 04             	mov    0x4(%eax),%eax
  802b77:	a3 30 50 80 00       	mov    %eax,0x805030
  802b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7f:	8b 40 04             	mov    0x4(%eax),%eax
  802b82:	85 c0                	test   %eax,%eax
  802b84:	74 0f                	je     802b95 <alloc_block_BF+0x3fd>
  802b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b89:	8b 40 04             	mov    0x4(%eax),%eax
  802b8c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b8f:	8b 12                	mov    (%edx),%edx
  802b91:	89 10                	mov    %edx,(%eax)
  802b93:	eb 0a                	jmp    802b9f <alloc_block_BF+0x407>
  802b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b98:	8b 00                	mov    (%eax),%eax
  802b9a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb2:	a1 38 50 80 00       	mov    0x805038,%eax
  802bb7:	48                   	dec    %eax
  802bb8:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802bbd:	83 ec 04             	sub    $0x4,%esp
  802bc0:	6a 00                	push   $0x0
  802bc2:	ff 75 d0             	pushl  -0x30(%ebp)
  802bc5:	ff 75 cc             	pushl  -0x34(%ebp)
  802bc8:	e8 e0 f6 ff ff       	call   8022ad <set_block_data>
  802bcd:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd3:	e9 a3 01 00 00       	jmp    802d7b <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802bd8:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802bdc:	0f 85 9d 00 00 00    	jne    802c7f <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802be2:	83 ec 04             	sub    $0x4,%esp
  802be5:	6a 01                	push   $0x1
  802be7:	ff 75 ec             	pushl  -0x14(%ebp)
  802bea:	ff 75 f0             	pushl  -0x10(%ebp)
  802bed:	e8 bb f6 ff ff       	call   8022ad <set_block_data>
  802bf2:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802bf5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bf9:	75 17                	jne    802c12 <alloc_block_BF+0x47a>
  802bfb:	83 ec 04             	sub    $0x4,%esp
  802bfe:	68 b3 47 80 00       	push   $0x8047b3
  802c03:	68 58 01 00 00       	push   $0x158
  802c08:	68 d1 47 80 00       	push   $0x8047d1
  802c0d:	e8 a8 d7 ff ff       	call   8003ba <_panic>
  802c12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c15:	8b 00                	mov    (%eax),%eax
  802c17:	85 c0                	test   %eax,%eax
  802c19:	74 10                	je     802c2b <alloc_block_BF+0x493>
  802c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1e:	8b 00                	mov    (%eax),%eax
  802c20:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c23:	8b 52 04             	mov    0x4(%edx),%edx
  802c26:	89 50 04             	mov    %edx,0x4(%eax)
  802c29:	eb 0b                	jmp    802c36 <alloc_block_BF+0x49e>
  802c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2e:	8b 40 04             	mov    0x4(%eax),%eax
  802c31:	a3 30 50 80 00       	mov    %eax,0x805030
  802c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c39:	8b 40 04             	mov    0x4(%eax),%eax
  802c3c:	85 c0                	test   %eax,%eax
  802c3e:	74 0f                	je     802c4f <alloc_block_BF+0x4b7>
  802c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c43:	8b 40 04             	mov    0x4(%eax),%eax
  802c46:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c49:	8b 12                	mov    (%edx),%edx
  802c4b:	89 10                	mov    %edx,(%eax)
  802c4d:	eb 0a                	jmp    802c59 <alloc_block_BF+0x4c1>
  802c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c52:	8b 00                	mov    (%eax),%eax
  802c54:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6c:	a1 38 50 80 00       	mov    0x805038,%eax
  802c71:	48                   	dec    %eax
  802c72:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7a:	e9 fc 00 00 00       	jmp    802d7b <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c82:	83 c0 08             	add    $0x8,%eax
  802c85:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c88:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c8f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c92:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c95:	01 d0                	add    %edx,%eax
  802c97:	48                   	dec    %eax
  802c98:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c9b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c9e:	ba 00 00 00 00       	mov    $0x0,%edx
  802ca3:	f7 75 c4             	divl   -0x3c(%ebp)
  802ca6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ca9:	29 d0                	sub    %edx,%eax
  802cab:	c1 e8 0c             	shr    $0xc,%eax
  802cae:	83 ec 0c             	sub    $0xc,%esp
  802cb1:	50                   	push   %eax
  802cb2:	e8 5a e7 ff ff       	call   801411 <sbrk>
  802cb7:	83 c4 10             	add    $0x10,%esp
  802cba:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802cbd:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802cc1:	75 0a                	jne    802ccd <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc8:	e9 ae 00 00 00       	jmp    802d7b <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802ccd:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802cd4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cd7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802cda:	01 d0                	add    %edx,%eax
  802cdc:	48                   	dec    %eax
  802cdd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802ce0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ce3:	ba 00 00 00 00       	mov    $0x0,%edx
  802ce8:	f7 75 b8             	divl   -0x48(%ebp)
  802ceb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cee:	29 d0                	sub    %edx,%eax
  802cf0:	8d 50 fc             	lea    -0x4(%eax),%edx
  802cf3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802cf6:	01 d0                	add    %edx,%eax
  802cf8:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802cfd:	a1 40 50 80 00       	mov    0x805040,%eax
  802d02:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802d08:	83 ec 0c             	sub    $0xc,%esp
  802d0b:	68 78 48 80 00       	push   $0x804878
  802d10:	e8 62 d9 ff ff       	call   800677 <cprintf>
  802d15:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802d18:	83 ec 08             	sub    $0x8,%esp
  802d1b:	ff 75 bc             	pushl  -0x44(%ebp)
  802d1e:	68 7d 48 80 00       	push   $0x80487d
  802d23:	e8 4f d9 ff ff       	call   800677 <cprintf>
  802d28:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d2b:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d32:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d35:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d38:	01 d0                	add    %edx,%eax
  802d3a:	48                   	dec    %eax
  802d3b:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d3e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d41:	ba 00 00 00 00       	mov    $0x0,%edx
  802d46:	f7 75 b0             	divl   -0x50(%ebp)
  802d49:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d4c:	29 d0                	sub    %edx,%eax
  802d4e:	83 ec 04             	sub    $0x4,%esp
  802d51:	6a 01                	push   $0x1
  802d53:	50                   	push   %eax
  802d54:	ff 75 bc             	pushl  -0x44(%ebp)
  802d57:	e8 51 f5 ff ff       	call   8022ad <set_block_data>
  802d5c:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d5f:	83 ec 0c             	sub    $0xc,%esp
  802d62:	ff 75 bc             	pushl  -0x44(%ebp)
  802d65:	e8 36 04 00 00       	call   8031a0 <free_block>
  802d6a:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d6d:	83 ec 0c             	sub    $0xc,%esp
  802d70:	ff 75 08             	pushl  0x8(%ebp)
  802d73:	e8 20 fa ff ff       	call   802798 <alloc_block_BF>
  802d78:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d7b:	c9                   	leave  
  802d7c:	c3                   	ret    

00802d7d <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d7d:	55                   	push   %ebp
  802d7e:	89 e5                	mov    %esp,%ebp
  802d80:	53                   	push   %ebx
  802d81:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d8b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d96:	74 1e                	je     802db6 <merging+0x39>
  802d98:	ff 75 08             	pushl  0x8(%ebp)
  802d9b:	e8 bc f1 ff ff       	call   801f5c <get_block_size>
  802da0:	83 c4 04             	add    $0x4,%esp
  802da3:	89 c2                	mov    %eax,%edx
  802da5:	8b 45 08             	mov    0x8(%ebp),%eax
  802da8:	01 d0                	add    %edx,%eax
  802daa:	3b 45 10             	cmp    0x10(%ebp),%eax
  802dad:	75 07                	jne    802db6 <merging+0x39>
		prev_is_free = 1;
  802daf:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802db6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dba:	74 1e                	je     802dda <merging+0x5d>
  802dbc:	ff 75 10             	pushl  0x10(%ebp)
  802dbf:	e8 98 f1 ff ff       	call   801f5c <get_block_size>
  802dc4:	83 c4 04             	add    $0x4,%esp
  802dc7:	89 c2                	mov    %eax,%edx
  802dc9:	8b 45 10             	mov    0x10(%ebp),%eax
  802dcc:	01 d0                	add    %edx,%eax
  802dce:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802dd1:	75 07                	jne    802dda <merging+0x5d>
		next_is_free = 1;
  802dd3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802dda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dde:	0f 84 cc 00 00 00    	je     802eb0 <merging+0x133>
  802de4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802de8:	0f 84 c2 00 00 00    	je     802eb0 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802dee:	ff 75 08             	pushl  0x8(%ebp)
  802df1:	e8 66 f1 ff ff       	call   801f5c <get_block_size>
  802df6:	83 c4 04             	add    $0x4,%esp
  802df9:	89 c3                	mov    %eax,%ebx
  802dfb:	ff 75 10             	pushl  0x10(%ebp)
  802dfe:	e8 59 f1 ff ff       	call   801f5c <get_block_size>
  802e03:	83 c4 04             	add    $0x4,%esp
  802e06:	01 c3                	add    %eax,%ebx
  802e08:	ff 75 0c             	pushl  0xc(%ebp)
  802e0b:	e8 4c f1 ff ff       	call   801f5c <get_block_size>
  802e10:	83 c4 04             	add    $0x4,%esp
  802e13:	01 d8                	add    %ebx,%eax
  802e15:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e18:	6a 00                	push   $0x0
  802e1a:	ff 75 ec             	pushl  -0x14(%ebp)
  802e1d:	ff 75 08             	pushl  0x8(%ebp)
  802e20:	e8 88 f4 ff ff       	call   8022ad <set_block_data>
  802e25:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e28:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e2c:	75 17                	jne    802e45 <merging+0xc8>
  802e2e:	83 ec 04             	sub    $0x4,%esp
  802e31:	68 b3 47 80 00       	push   $0x8047b3
  802e36:	68 7d 01 00 00       	push   $0x17d
  802e3b:	68 d1 47 80 00       	push   $0x8047d1
  802e40:	e8 75 d5 ff ff       	call   8003ba <_panic>
  802e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e48:	8b 00                	mov    (%eax),%eax
  802e4a:	85 c0                	test   %eax,%eax
  802e4c:	74 10                	je     802e5e <merging+0xe1>
  802e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e51:	8b 00                	mov    (%eax),%eax
  802e53:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e56:	8b 52 04             	mov    0x4(%edx),%edx
  802e59:	89 50 04             	mov    %edx,0x4(%eax)
  802e5c:	eb 0b                	jmp    802e69 <merging+0xec>
  802e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e61:	8b 40 04             	mov    0x4(%eax),%eax
  802e64:	a3 30 50 80 00       	mov    %eax,0x805030
  802e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e6c:	8b 40 04             	mov    0x4(%eax),%eax
  802e6f:	85 c0                	test   %eax,%eax
  802e71:	74 0f                	je     802e82 <merging+0x105>
  802e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e76:	8b 40 04             	mov    0x4(%eax),%eax
  802e79:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e7c:	8b 12                	mov    (%edx),%edx
  802e7e:	89 10                	mov    %edx,(%eax)
  802e80:	eb 0a                	jmp    802e8c <merging+0x10f>
  802e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e85:	8b 00                	mov    (%eax),%eax
  802e87:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e9f:	a1 38 50 80 00       	mov    0x805038,%eax
  802ea4:	48                   	dec    %eax
  802ea5:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802eaa:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802eab:	e9 ea 02 00 00       	jmp    80319a <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802eb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb4:	74 3b                	je     802ef1 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802eb6:	83 ec 0c             	sub    $0xc,%esp
  802eb9:	ff 75 08             	pushl  0x8(%ebp)
  802ebc:	e8 9b f0 ff ff       	call   801f5c <get_block_size>
  802ec1:	83 c4 10             	add    $0x10,%esp
  802ec4:	89 c3                	mov    %eax,%ebx
  802ec6:	83 ec 0c             	sub    $0xc,%esp
  802ec9:	ff 75 10             	pushl  0x10(%ebp)
  802ecc:	e8 8b f0 ff ff       	call   801f5c <get_block_size>
  802ed1:	83 c4 10             	add    $0x10,%esp
  802ed4:	01 d8                	add    %ebx,%eax
  802ed6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ed9:	83 ec 04             	sub    $0x4,%esp
  802edc:	6a 00                	push   $0x0
  802ede:	ff 75 e8             	pushl  -0x18(%ebp)
  802ee1:	ff 75 08             	pushl  0x8(%ebp)
  802ee4:	e8 c4 f3 ff ff       	call   8022ad <set_block_data>
  802ee9:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802eec:	e9 a9 02 00 00       	jmp    80319a <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802ef1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ef5:	0f 84 2d 01 00 00    	je     803028 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802efb:	83 ec 0c             	sub    $0xc,%esp
  802efe:	ff 75 10             	pushl  0x10(%ebp)
  802f01:	e8 56 f0 ff ff       	call   801f5c <get_block_size>
  802f06:	83 c4 10             	add    $0x10,%esp
  802f09:	89 c3                	mov    %eax,%ebx
  802f0b:	83 ec 0c             	sub    $0xc,%esp
  802f0e:	ff 75 0c             	pushl  0xc(%ebp)
  802f11:	e8 46 f0 ff ff       	call   801f5c <get_block_size>
  802f16:	83 c4 10             	add    $0x10,%esp
  802f19:	01 d8                	add    %ebx,%eax
  802f1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f1e:	83 ec 04             	sub    $0x4,%esp
  802f21:	6a 00                	push   $0x0
  802f23:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f26:	ff 75 10             	pushl  0x10(%ebp)
  802f29:	e8 7f f3 ff ff       	call   8022ad <set_block_data>
  802f2e:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f31:	8b 45 10             	mov    0x10(%ebp),%eax
  802f34:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f37:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f3b:	74 06                	je     802f43 <merging+0x1c6>
  802f3d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f41:	75 17                	jne    802f5a <merging+0x1dd>
  802f43:	83 ec 04             	sub    $0x4,%esp
  802f46:	68 8c 48 80 00       	push   $0x80488c
  802f4b:	68 8d 01 00 00       	push   $0x18d
  802f50:	68 d1 47 80 00       	push   $0x8047d1
  802f55:	e8 60 d4 ff ff       	call   8003ba <_panic>
  802f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f5d:	8b 50 04             	mov    0x4(%eax),%edx
  802f60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f63:	89 50 04             	mov    %edx,0x4(%eax)
  802f66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f69:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f6c:	89 10                	mov    %edx,(%eax)
  802f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f71:	8b 40 04             	mov    0x4(%eax),%eax
  802f74:	85 c0                	test   %eax,%eax
  802f76:	74 0d                	je     802f85 <merging+0x208>
  802f78:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f7b:	8b 40 04             	mov    0x4(%eax),%eax
  802f7e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f81:	89 10                	mov    %edx,(%eax)
  802f83:	eb 08                	jmp    802f8d <merging+0x210>
  802f85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f88:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f90:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f93:	89 50 04             	mov    %edx,0x4(%eax)
  802f96:	a1 38 50 80 00       	mov    0x805038,%eax
  802f9b:	40                   	inc    %eax
  802f9c:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802fa1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fa5:	75 17                	jne    802fbe <merging+0x241>
  802fa7:	83 ec 04             	sub    $0x4,%esp
  802faa:	68 b3 47 80 00       	push   $0x8047b3
  802faf:	68 8e 01 00 00       	push   $0x18e
  802fb4:	68 d1 47 80 00       	push   $0x8047d1
  802fb9:	e8 fc d3 ff ff       	call   8003ba <_panic>
  802fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc1:	8b 00                	mov    (%eax),%eax
  802fc3:	85 c0                	test   %eax,%eax
  802fc5:	74 10                	je     802fd7 <merging+0x25a>
  802fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fca:	8b 00                	mov    (%eax),%eax
  802fcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fcf:	8b 52 04             	mov    0x4(%edx),%edx
  802fd2:	89 50 04             	mov    %edx,0x4(%eax)
  802fd5:	eb 0b                	jmp    802fe2 <merging+0x265>
  802fd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fda:	8b 40 04             	mov    0x4(%eax),%eax
  802fdd:	a3 30 50 80 00       	mov    %eax,0x805030
  802fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe5:	8b 40 04             	mov    0x4(%eax),%eax
  802fe8:	85 c0                	test   %eax,%eax
  802fea:	74 0f                	je     802ffb <merging+0x27e>
  802fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fef:	8b 40 04             	mov    0x4(%eax),%eax
  802ff2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ff5:	8b 12                	mov    (%edx),%edx
  802ff7:	89 10                	mov    %edx,(%eax)
  802ff9:	eb 0a                	jmp    803005 <merging+0x288>
  802ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ffe:	8b 00                	mov    (%eax),%eax
  803000:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803005:	8b 45 0c             	mov    0xc(%ebp),%eax
  803008:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80300e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803011:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803018:	a1 38 50 80 00       	mov    0x805038,%eax
  80301d:	48                   	dec    %eax
  80301e:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803023:	e9 72 01 00 00       	jmp    80319a <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803028:	8b 45 10             	mov    0x10(%ebp),%eax
  80302b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80302e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803032:	74 79                	je     8030ad <merging+0x330>
  803034:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803038:	74 73                	je     8030ad <merging+0x330>
  80303a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80303e:	74 06                	je     803046 <merging+0x2c9>
  803040:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803044:	75 17                	jne    80305d <merging+0x2e0>
  803046:	83 ec 04             	sub    $0x4,%esp
  803049:	68 44 48 80 00       	push   $0x804844
  80304e:	68 94 01 00 00       	push   $0x194
  803053:	68 d1 47 80 00       	push   $0x8047d1
  803058:	e8 5d d3 ff ff       	call   8003ba <_panic>
  80305d:	8b 45 08             	mov    0x8(%ebp),%eax
  803060:	8b 10                	mov    (%eax),%edx
  803062:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803065:	89 10                	mov    %edx,(%eax)
  803067:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80306a:	8b 00                	mov    (%eax),%eax
  80306c:	85 c0                	test   %eax,%eax
  80306e:	74 0b                	je     80307b <merging+0x2fe>
  803070:	8b 45 08             	mov    0x8(%ebp),%eax
  803073:	8b 00                	mov    (%eax),%eax
  803075:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803078:	89 50 04             	mov    %edx,0x4(%eax)
  80307b:	8b 45 08             	mov    0x8(%ebp),%eax
  80307e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803081:	89 10                	mov    %edx,(%eax)
  803083:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803086:	8b 55 08             	mov    0x8(%ebp),%edx
  803089:	89 50 04             	mov    %edx,0x4(%eax)
  80308c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80308f:	8b 00                	mov    (%eax),%eax
  803091:	85 c0                	test   %eax,%eax
  803093:	75 08                	jne    80309d <merging+0x320>
  803095:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803098:	a3 30 50 80 00       	mov    %eax,0x805030
  80309d:	a1 38 50 80 00       	mov    0x805038,%eax
  8030a2:	40                   	inc    %eax
  8030a3:	a3 38 50 80 00       	mov    %eax,0x805038
  8030a8:	e9 ce 00 00 00       	jmp    80317b <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8030ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030b1:	74 65                	je     803118 <merging+0x39b>
  8030b3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030b7:	75 17                	jne    8030d0 <merging+0x353>
  8030b9:	83 ec 04             	sub    $0x4,%esp
  8030bc:	68 20 48 80 00       	push   $0x804820
  8030c1:	68 95 01 00 00       	push   $0x195
  8030c6:	68 d1 47 80 00       	push   $0x8047d1
  8030cb:	e8 ea d2 ff ff       	call   8003ba <_panic>
  8030d0:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8030d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030d9:	89 50 04             	mov    %edx,0x4(%eax)
  8030dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030df:	8b 40 04             	mov    0x4(%eax),%eax
  8030e2:	85 c0                	test   %eax,%eax
  8030e4:	74 0c                	je     8030f2 <merging+0x375>
  8030e6:	a1 30 50 80 00       	mov    0x805030,%eax
  8030eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030ee:	89 10                	mov    %edx,(%eax)
  8030f0:	eb 08                	jmp    8030fa <merging+0x37d>
  8030f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030fd:	a3 30 50 80 00       	mov    %eax,0x805030
  803102:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803105:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80310b:	a1 38 50 80 00       	mov    0x805038,%eax
  803110:	40                   	inc    %eax
  803111:	a3 38 50 80 00       	mov    %eax,0x805038
  803116:	eb 63                	jmp    80317b <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803118:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80311c:	75 17                	jne    803135 <merging+0x3b8>
  80311e:	83 ec 04             	sub    $0x4,%esp
  803121:	68 ec 47 80 00       	push   $0x8047ec
  803126:	68 98 01 00 00       	push   $0x198
  80312b:	68 d1 47 80 00       	push   $0x8047d1
  803130:	e8 85 d2 ff ff       	call   8003ba <_panic>
  803135:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80313b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80313e:	89 10                	mov    %edx,(%eax)
  803140:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803143:	8b 00                	mov    (%eax),%eax
  803145:	85 c0                	test   %eax,%eax
  803147:	74 0d                	je     803156 <merging+0x3d9>
  803149:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80314e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803151:	89 50 04             	mov    %edx,0x4(%eax)
  803154:	eb 08                	jmp    80315e <merging+0x3e1>
  803156:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803159:	a3 30 50 80 00       	mov    %eax,0x805030
  80315e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803161:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803166:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803169:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803170:	a1 38 50 80 00       	mov    0x805038,%eax
  803175:	40                   	inc    %eax
  803176:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80317b:	83 ec 0c             	sub    $0xc,%esp
  80317e:	ff 75 10             	pushl  0x10(%ebp)
  803181:	e8 d6 ed ff ff       	call   801f5c <get_block_size>
  803186:	83 c4 10             	add    $0x10,%esp
  803189:	83 ec 04             	sub    $0x4,%esp
  80318c:	6a 00                	push   $0x0
  80318e:	50                   	push   %eax
  80318f:	ff 75 10             	pushl  0x10(%ebp)
  803192:	e8 16 f1 ff ff       	call   8022ad <set_block_data>
  803197:	83 c4 10             	add    $0x10,%esp
	}
}
  80319a:	90                   	nop
  80319b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80319e:	c9                   	leave  
  80319f:	c3                   	ret    

008031a0 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8031a0:	55                   	push   %ebp
  8031a1:	89 e5                	mov    %esp,%ebp
  8031a3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8031a6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031ab:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8031ae:	a1 30 50 80 00       	mov    0x805030,%eax
  8031b3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031b6:	73 1b                	jae    8031d3 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8031b8:	a1 30 50 80 00       	mov    0x805030,%eax
  8031bd:	83 ec 04             	sub    $0x4,%esp
  8031c0:	ff 75 08             	pushl  0x8(%ebp)
  8031c3:	6a 00                	push   $0x0
  8031c5:	50                   	push   %eax
  8031c6:	e8 b2 fb ff ff       	call   802d7d <merging>
  8031cb:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031ce:	e9 8b 00 00 00       	jmp    80325e <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8031d3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031db:	76 18                	jbe    8031f5 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8031dd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031e2:	83 ec 04             	sub    $0x4,%esp
  8031e5:	ff 75 08             	pushl  0x8(%ebp)
  8031e8:	50                   	push   %eax
  8031e9:	6a 00                	push   $0x0
  8031eb:	e8 8d fb ff ff       	call   802d7d <merging>
  8031f0:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031f3:	eb 69                	jmp    80325e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031f5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031fd:	eb 39                	jmp    803238 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8031ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803202:	3b 45 08             	cmp    0x8(%ebp),%eax
  803205:	73 29                	jae    803230 <free_block+0x90>
  803207:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320a:	8b 00                	mov    (%eax),%eax
  80320c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80320f:	76 1f                	jbe    803230 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803214:	8b 00                	mov    (%eax),%eax
  803216:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803219:	83 ec 04             	sub    $0x4,%esp
  80321c:	ff 75 08             	pushl  0x8(%ebp)
  80321f:	ff 75 f0             	pushl  -0x10(%ebp)
  803222:	ff 75 f4             	pushl  -0xc(%ebp)
  803225:	e8 53 fb ff ff       	call   802d7d <merging>
  80322a:	83 c4 10             	add    $0x10,%esp
			break;
  80322d:	90                   	nop
		}
	}
}
  80322e:	eb 2e                	jmp    80325e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803230:	a1 34 50 80 00       	mov    0x805034,%eax
  803235:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803238:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80323c:	74 07                	je     803245 <free_block+0xa5>
  80323e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803241:	8b 00                	mov    (%eax),%eax
  803243:	eb 05                	jmp    80324a <free_block+0xaa>
  803245:	b8 00 00 00 00       	mov    $0x0,%eax
  80324a:	a3 34 50 80 00       	mov    %eax,0x805034
  80324f:	a1 34 50 80 00       	mov    0x805034,%eax
  803254:	85 c0                	test   %eax,%eax
  803256:	75 a7                	jne    8031ff <free_block+0x5f>
  803258:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80325c:	75 a1                	jne    8031ff <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80325e:	90                   	nop
  80325f:	c9                   	leave  
  803260:	c3                   	ret    

00803261 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803261:	55                   	push   %ebp
  803262:	89 e5                	mov    %esp,%ebp
  803264:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803267:	ff 75 08             	pushl  0x8(%ebp)
  80326a:	e8 ed ec ff ff       	call   801f5c <get_block_size>
  80326f:	83 c4 04             	add    $0x4,%esp
  803272:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803275:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80327c:	eb 17                	jmp    803295 <copy_data+0x34>
  80327e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803281:	8b 45 0c             	mov    0xc(%ebp),%eax
  803284:	01 c2                	add    %eax,%edx
  803286:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803289:	8b 45 08             	mov    0x8(%ebp),%eax
  80328c:	01 c8                	add    %ecx,%eax
  80328e:	8a 00                	mov    (%eax),%al
  803290:	88 02                	mov    %al,(%edx)
  803292:	ff 45 fc             	incl   -0x4(%ebp)
  803295:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803298:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80329b:	72 e1                	jb     80327e <copy_data+0x1d>
}
  80329d:	90                   	nop
  80329e:	c9                   	leave  
  80329f:	c3                   	ret    

008032a0 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8032a0:	55                   	push   %ebp
  8032a1:	89 e5                	mov    %esp,%ebp
  8032a3:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8032a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032aa:	75 23                	jne    8032cf <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8032ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032b0:	74 13                	je     8032c5 <realloc_block_FF+0x25>
  8032b2:	83 ec 0c             	sub    $0xc,%esp
  8032b5:	ff 75 0c             	pushl  0xc(%ebp)
  8032b8:	e8 1f f0 ff ff       	call   8022dc <alloc_block_FF>
  8032bd:	83 c4 10             	add    $0x10,%esp
  8032c0:	e9 f4 06 00 00       	jmp    8039b9 <realloc_block_FF+0x719>
		return NULL;
  8032c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ca:	e9 ea 06 00 00       	jmp    8039b9 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8032cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032d3:	75 18                	jne    8032ed <realloc_block_FF+0x4d>
	{
		free_block(va);
  8032d5:	83 ec 0c             	sub    $0xc,%esp
  8032d8:	ff 75 08             	pushl  0x8(%ebp)
  8032db:	e8 c0 fe ff ff       	call   8031a0 <free_block>
  8032e0:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8032e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e8:	e9 cc 06 00 00       	jmp    8039b9 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8032ed:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8032f1:	77 07                	ja     8032fa <realloc_block_FF+0x5a>
  8032f3:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8032fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032fd:	83 e0 01             	and    $0x1,%eax
  803300:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803303:	8b 45 0c             	mov    0xc(%ebp),%eax
  803306:	83 c0 08             	add    $0x8,%eax
  803309:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80330c:	83 ec 0c             	sub    $0xc,%esp
  80330f:	ff 75 08             	pushl  0x8(%ebp)
  803312:	e8 45 ec ff ff       	call   801f5c <get_block_size>
  803317:	83 c4 10             	add    $0x10,%esp
  80331a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80331d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803320:	83 e8 08             	sub    $0x8,%eax
  803323:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803326:	8b 45 08             	mov    0x8(%ebp),%eax
  803329:	83 e8 04             	sub    $0x4,%eax
  80332c:	8b 00                	mov    (%eax),%eax
  80332e:	83 e0 fe             	and    $0xfffffffe,%eax
  803331:	89 c2                	mov    %eax,%edx
  803333:	8b 45 08             	mov    0x8(%ebp),%eax
  803336:	01 d0                	add    %edx,%eax
  803338:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80333b:	83 ec 0c             	sub    $0xc,%esp
  80333e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803341:	e8 16 ec ff ff       	call   801f5c <get_block_size>
  803346:	83 c4 10             	add    $0x10,%esp
  803349:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80334c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80334f:	83 e8 08             	sub    $0x8,%eax
  803352:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803355:	8b 45 0c             	mov    0xc(%ebp),%eax
  803358:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80335b:	75 08                	jne    803365 <realloc_block_FF+0xc5>
	{
		 return va;
  80335d:	8b 45 08             	mov    0x8(%ebp),%eax
  803360:	e9 54 06 00 00       	jmp    8039b9 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803365:	8b 45 0c             	mov    0xc(%ebp),%eax
  803368:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80336b:	0f 83 e5 03 00 00    	jae    803756 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803371:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803374:	2b 45 0c             	sub    0xc(%ebp),%eax
  803377:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80337a:	83 ec 0c             	sub    $0xc,%esp
  80337d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803380:	e8 f0 eb ff ff       	call   801f75 <is_free_block>
  803385:	83 c4 10             	add    $0x10,%esp
  803388:	84 c0                	test   %al,%al
  80338a:	0f 84 3b 01 00 00    	je     8034cb <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803390:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803393:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803396:	01 d0                	add    %edx,%eax
  803398:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80339b:	83 ec 04             	sub    $0x4,%esp
  80339e:	6a 01                	push   $0x1
  8033a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8033a3:	ff 75 08             	pushl  0x8(%ebp)
  8033a6:	e8 02 ef ff ff       	call   8022ad <set_block_data>
  8033ab:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8033ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b1:	83 e8 04             	sub    $0x4,%eax
  8033b4:	8b 00                	mov    (%eax),%eax
  8033b6:	83 e0 fe             	and    $0xfffffffe,%eax
  8033b9:	89 c2                	mov    %eax,%edx
  8033bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033be:	01 d0                	add    %edx,%eax
  8033c0:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8033c3:	83 ec 04             	sub    $0x4,%esp
  8033c6:	6a 00                	push   $0x0
  8033c8:	ff 75 cc             	pushl  -0x34(%ebp)
  8033cb:	ff 75 c8             	pushl  -0x38(%ebp)
  8033ce:	e8 da ee ff ff       	call   8022ad <set_block_data>
  8033d3:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8033d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033da:	74 06                	je     8033e2 <realloc_block_FF+0x142>
  8033dc:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8033e0:	75 17                	jne    8033f9 <realloc_block_FF+0x159>
  8033e2:	83 ec 04             	sub    $0x4,%esp
  8033e5:	68 44 48 80 00       	push   $0x804844
  8033ea:	68 f6 01 00 00       	push   $0x1f6
  8033ef:	68 d1 47 80 00       	push   $0x8047d1
  8033f4:	e8 c1 cf ff ff       	call   8003ba <_panic>
  8033f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033fc:	8b 10                	mov    (%eax),%edx
  8033fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803401:	89 10                	mov    %edx,(%eax)
  803403:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803406:	8b 00                	mov    (%eax),%eax
  803408:	85 c0                	test   %eax,%eax
  80340a:	74 0b                	je     803417 <realloc_block_FF+0x177>
  80340c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80340f:	8b 00                	mov    (%eax),%eax
  803411:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803414:	89 50 04             	mov    %edx,0x4(%eax)
  803417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80341a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80341d:	89 10                	mov    %edx,(%eax)
  80341f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803422:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803425:	89 50 04             	mov    %edx,0x4(%eax)
  803428:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80342b:	8b 00                	mov    (%eax),%eax
  80342d:	85 c0                	test   %eax,%eax
  80342f:	75 08                	jne    803439 <realloc_block_FF+0x199>
  803431:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803434:	a3 30 50 80 00       	mov    %eax,0x805030
  803439:	a1 38 50 80 00       	mov    0x805038,%eax
  80343e:	40                   	inc    %eax
  80343f:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803444:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803448:	75 17                	jne    803461 <realloc_block_FF+0x1c1>
  80344a:	83 ec 04             	sub    $0x4,%esp
  80344d:	68 b3 47 80 00       	push   $0x8047b3
  803452:	68 f7 01 00 00       	push   $0x1f7
  803457:	68 d1 47 80 00       	push   $0x8047d1
  80345c:	e8 59 cf ff ff       	call   8003ba <_panic>
  803461:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803464:	8b 00                	mov    (%eax),%eax
  803466:	85 c0                	test   %eax,%eax
  803468:	74 10                	je     80347a <realloc_block_FF+0x1da>
  80346a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80346d:	8b 00                	mov    (%eax),%eax
  80346f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803472:	8b 52 04             	mov    0x4(%edx),%edx
  803475:	89 50 04             	mov    %edx,0x4(%eax)
  803478:	eb 0b                	jmp    803485 <realloc_block_FF+0x1e5>
  80347a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347d:	8b 40 04             	mov    0x4(%eax),%eax
  803480:	a3 30 50 80 00       	mov    %eax,0x805030
  803485:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803488:	8b 40 04             	mov    0x4(%eax),%eax
  80348b:	85 c0                	test   %eax,%eax
  80348d:	74 0f                	je     80349e <realloc_block_FF+0x1fe>
  80348f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803492:	8b 40 04             	mov    0x4(%eax),%eax
  803495:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803498:	8b 12                	mov    (%edx),%edx
  80349a:	89 10                	mov    %edx,(%eax)
  80349c:	eb 0a                	jmp    8034a8 <realloc_block_FF+0x208>
  80349e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a1:	8b 00                	mov    (%eax),%eax
  8034a3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034bb:	a1 38 50 80 00       	mov    0x805038,%eax
  8034c0:	48                   	dec    %eax
  8034c1:	a3 38 50 80 00       	mov    %eax,0x805038
  8034c6:	e9 83 02 00 00       	jmp    80374e <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8034cb:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8034cf:	0f 86 69 02 00 00    	jbe    80373e <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8034d5:	83 ec 04             	sub    $0x4,%esp
  8034d8:	6a 01                	push   $0x1
  8034da:	ff 75 f0             	pushl  -0x10(%ebp)
  8034dd:	ff 75 08             	pushl  0x8(%ebp)
  8034e0:	e8 c8 ed ff ff       	call   8022ad <set_block_data>
  8034e5:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8034e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034eb:	83 e8 04             	sub    $0x4,%eax
  8034ee:	8b 00                	mov    (%eax),%eax
  8034f0:	83 e0 fe             	and    $0xfffffffe,%eax
  8034f3:	89 c2                	mov    %eax,%edx
  8034f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f8:	01 d0                	add    %edx,%eax
  8034fa:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8034fd:	a1 38 50 80 00       	mov    0x805038,%eax
  803502:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803505:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803509:	75 68                	jne    803573 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80350b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80350f:	75 17                	jne    803528 <realloc_block_FF+0x288>
  803511:	83 ec 04             	sub    $0x4,%esp
  803514:	68 ec 47 80 00       	push   $0x8047ec
  803519:	68 06 02 00 00       	push   $0x206
  80351e:	68 d1 47 80 00       	push   $0x8047d1
  803523:	e8 92 ce ff ff       	call   8003ba <_panic>
  803528:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80352e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803531:	89 10                	mov    %edx,(%eax)
  803533:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803536:	8b 00                	mov    (%eax),%eax
  803538:	85 c0                	test   %eax,%eax
  80353a:	74 0d                	je     803549 <realloc_block_FF+0x2a9>
  80353c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803541:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803544:	89 50 04             	mov    %edx,0x4(%eax)
  803547:	eb 08                	jmp    803551 <realloc_block_FF+0x2b1>
  803549:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80354c:	a3 30 50 80 00       	mov    %eax,0x805030
  803551:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803554:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803559:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80355c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803563:	a1 38 50 80 00       	mov    0x805038,%eax
  803568:	40                   	inc    %eax
  803569:	a3 38 50 80 00       	mov    %eax,0x805038
  80356e:	e9 b0 01 00 00       	jmp    803723 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803573:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803578:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80357b:	76 68                	jbe    8035e5 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80357d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803581:	75 17                	jne    80359a <realloc_block_FF+0x2fa>
  803583:	83 ec 04             	sub    $0x4,%esp
  803586:	68 ec 47 80 00       	push   $0x8047ec
  80358b:	68 0b 02 00 00       	push   $0x20b
  803590:	68 d1 47 80 00       	push   $0x8047d1
  803595:	e8 20 ce ff ff       	call   8003ba <_panic>
  80359a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a3:	89 10                	mov    %edx,(%eax)
  8035a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a8:	8b 00                	mov    (%eax),%eax
  8035aa:	85 c0                	test   %eax,%eax
  8035ac:	74 0d                	je     8035bb <realloc_block_FF+0x31b>
  8035ae:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035b3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035b6:	89 50 04             	mov    %edx,0x4(%eax)
  8035b9:	eb 08                	jmp    8035c3 <realloc_block_FF+0x323>
  8035bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035be:	a3 30 50 80 00       	mov    %eax,0x805030
  8035c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035d5:	a1 38 50 80 00       	mov    0x805038,%eax
  8035da:	40                   	inc    %eax
  8035db:	a3 38 50 80 00       	mov    %eax,0x805038
  8035e0:	e9 3e 01 00 00       	jmp    803723 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8035e5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035ea:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035ed:	73 68                	jae    803657 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035ef:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035f3:	75 17                	jne    80360c <realloc_block_FF+0x36c>
  8035f5:	83 ec 04             	sub    $0x4,%esp
  8035f8:	68 20 48 80 00       	push   $0x804820
  8035fd:	68 10 02 00 00       	push   $0x210
  803602:	68 d1 47 80 00       	push   $0x8047d1
  803607:	e8 ae cd ff ff       	call   8003ba <_panic>
  80360c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803612:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803615:	89 50 04             	mov    %edx,0x4(%eax)
  803618:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80361b:	8b 40 04             	mov    0x4(%eax),%eax
  80361e:	85 c0                	test   %eax,%eax
  803620:	74 0c                	je     80362e <realloc_block_FF+0x38e>
  803622:	a1 30 50 80 00       	mov    0x805030,%eax
  803627:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80362a:	89 10                	mov    %edx,(%eax)
  80362c:	eb 08                	jmp    803636 <realloc_block_FF+0x396>
  80362e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803631:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803636:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803639:	a3 30 50 80 00       	mov    %eax,0x805030
  80363e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803641:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803647:	a1 38 50 80 00       	mov    0x805038,%eax
  80364c:	40                   	inc    %eax
  80364d:	a3 38 50 80 00       	mov    %eax,0x805038
  803652:	e9 cc 00 00 00       	jmp    803723 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803657:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80365e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803663:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803666:	e9 8a 00 00 00       	jmp    8036f5 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80366b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803671:	73 7a                	jae    8036ed <realloc_block_FF+0x44d>
  803673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803676:	8b 00                	mov    (%eax),%eax
  803678:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80367b:	73 70                	jae    8036ed <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80367d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803681:	74 06                	je     803689 <realloc_block_FF+0x3e9>
  803683:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803687:	75 17                	jne    8036a0 <realloc_block_FF+0x400>
  803689:	83 ec 04             	sub    $0x4,%esp
  80368c:	68 44 48 80 00       	push   $0x804844
  803691:	68 1a 02 00 00       	push   $0x21a
  803696:	68 d1 47 80 00       	push   $0x8047d1
  80369b:	e8 1a cd ff ff       	call   8003ba <_panic>
  8036a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a3:	8b 10                	mov    (%eax),%edx
  8036a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a8:	89 10                	mov    %edx,(%eax)
  8036aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ad:	8b 00                	mov    (%eax),%eax
  8036af:	85 c0                	test   %eax,%eax
  8036b1:	74 0b                	je     8036be <realloc_block_FF+0x41e>
  8036b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b6:	8b 00                	mov    (%eax),%eax
  8036b8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036bb:	89 50 04             	mov    %edx,0x4(%eax)
  8036be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036c4:	89 10                	mov    %edx,(%eax)
  8036c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036cc:	89 50 04             	mov    %edx,0x4(%eax)
  8036cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036d2:	8b 00                	mov    (%eax),%eax
  8036d4:	85 c0                	test   %eax,%eax
  8036d6:	75 08                	jne    8036e0 <realloc_block_FF+0x440>
  8036d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036db:	a3 30 50 80 00       	mov    %eax,0x805030
  8036e0:	a1 38 50 80 00       	mov    0x805038,%eax
  8036e5:	40                   	inc    %eax
  8036e6:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8036eb:	eb 36                	jmp    803723 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8036ed:	a1 34 50 80 00       	mov    0x805034,%eax
  8036f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036f9:	74 07                	je     803702 <realloc_block_FF+0x462>
  8036fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fe:	8b 00                	mov    (%eax),%eax
  803700:	eb 05                	jmp    803707 <realloc_block_FF+0x467>
  803702:	b8 00 00 00 00       	mov    $0x0,%eax
  803707:	a3 34 50 80 00       	mov    %eax,0x805034
  80370c:	a1 34 50 80 00       	mov    0x805034,%eax
  803711:	85 c0                	test   %eax,%eax
  803713:	0f 85 52 ff ff ff    	jne    80366b <realloc_block_FF+0x3cb>
  803719:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80371d:	0f 85 48 ff ff ff    	jne    80366b <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803723:	83 ec 04             	sub    $0x4,%esp
  803726:	6a 00                	push   $0x0
  803728:	ff 75 d8             	pushl  -0x28(%ebp)
  80372b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80372e:	e8 7a eb ff ff       	call   8022ad <set_block_data>
  803733:	83 c4 10             	add    $0x10,%esp
				return va;
  803736:	8b 45 08             	mov    0x8(%ebp),%eax
  803739:	e9 7b 02 00 00       	jmp    8039b9 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80373e:	83 ec 0c             	sub    $0xc,%esp
  803741:	68 c1 48 80 00       	push   $0x8048c1
  803746:	e8 2c cf ff ff       	call   800677 <cprintf>
  80374b:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80374e:	8b 45 08             	mov    0x8(%ebp),%eax
  803751:	e9 63 02 00 00       	jmp    8039b9 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803756:	8b 45 0c             	mov    0xc(%ebp),%eax
  803759:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80375c:	0f 86 4d 02 00 00    	jbe    8039af <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803762:	83 ec 0c             	sub    $0xc,%esp
  803765:	ff 75 e4             	pushl  -0x1c(%ebp)
  803768:	e8 08 e8 ff ff       	call   801f75 <is_free_block>
  80376d:	83 c4 10             	add    $0x10,%esp
  803770:	84 c0                	test   %al,%al
  803772:	0f 84 37 02 00 00    	je     8039af <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80377b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80377e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803781:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803784:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803787:	76 38                	jbe    8037c1 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803789:	83 ec 0c             	sub    $0xc,%esp
  80378c:	ff 75 08             	pushl  0x8(%ebp)
  80378f:	e8 0c fa ff ff       	call   8031a0 <free_block>
  803794:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803797:	83 ec 0c             	sub    $0xc,%esp
  80379a:	ff 75 0c             	pushl  0xc(%ebp)
  80379d:	e8 3a eb ff ff       	call   8022dc <alloc_block_FF>
  8037a2:	83 c4 10             	add    $0x10,%esp
  8037a5:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8037a8:	83 ec 08             	sub    $0x8,%esp
  8037ab:	ff 75 c0             	pushl  -0x40(%ebp)
  8037ae:	ff 75 08             	pushl  0x8(%ebp)
  8037b1:	e8 ab fa ff ff       	call   803261 <copy_data>
  8037b6:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8037b9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8037bc:	e9 f8 01 00 00       	jmp    8039b9 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8037c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037c4:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8037c7:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8037ca:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8037ce:	0f 87 a0 00 00 00    	ja     803874 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8037d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037d8:	75 17                	jne    8037f1 <realloc_block_FF+0x551>
  8037da:	83 ec 04             	sub    $0x4,%esp
  8037dd:	68 b3 47 80 00       	push   $0x8047b3
  8037e2:	68 38 02 00 00       	push   $0x238
  8037e7:	68 d1 47 80 00       	push   $0x8047d1
  8037ec:	e8 c9 cb ff ff       	call   8003ba <_panic>
  8037f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f4:	8b 00                	mov    (%eax),%eax
  8037f6:	85 c0                	test   %eax,%eax
  8037f8:	74 10                	je     80380a <realloc_block_FF+0x56a>
  8037fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fd:	8b 00                	mov    (%eax),%eax
  8037ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803802:	8b 52 04             	mov    0x4(%edx),%edx
  803805:	89 50 04             	mov    %edx,0x4(%eax)
  803808:	eb 0b                	jmp    803815 <realloc_block_FF+0x575>
  80380a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380d:	8b 40 04             	mov    0x4(%eax),%eax
  803810:	a3 30 50 80 00       	mov    %eax,0x805030
  803815:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803818:	8b 40 04             	mov    0x4(%eax),%eax
  80381b:	85 c0                	test   %eax,%eax
  80381d:	74 0f                	je     80382e <realloc_block_FF+0x58e>
  80381f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803822:	8b 40 04             	mov    0x4(%eax),%eax
  803825:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803828:	8b 12                	mov    (%edx),%edx
  80382a:	89 10                	mov    %edx,(%eax)
  80382c:	eb 0a                	jmp    803838 <realloc_block_FF+0x598>
  80382e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803831:	8b 00                	mov    (%eax),%eax
  803833:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803838:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80383b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803841:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803844:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80384b:	a1 38 50 80 00       	mov    0x805038,%eax
  803850:	48                   	dec    %eax
  803851:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803856:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803859:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80385c:	01 d0                	add    %edx,%eax
  80385e:	83 ec 04             	sub    $0x4,%esp
  803861:	6a 01                	push   $0x1
  803863:	50                   	push   %eax
  803864:	ff 75 08             	pushl  0x8(%ebp)
  803867:	e8 41 ea ff ff       	call   8022ad <set_block_data>
  80386c:	83 c4 10             	add    $0x10,%esp
  80386f:	e9 36 01 00 00       	jmp    8039aa <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803874:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803877:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80387a:	01 d0                	add    %edx,%eax
  80387c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80387f:	83 ec 04             	sub    $0x4,%esp
  803882:	6a 01                	push   $0x1
  803884:	ff 75 f0             	pushl  -0x10(%ebp)
  803887:	ff 75 08             	pushl  0x8(%ebp)
  80388a:	e8 1e ea ff ff       	call   8022ad <set_block_data>
  80388f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803892:	8b 45 08             	mov    0x8(%ebp),%eax
  803895:	83 e8 04             	sub    $0x4,%eax
  803898:	8b 00                	mov    (%eax),%eax
  80389a:	83 e0 fe             	and    $0xfffffffe,%eax
  80389d:	89 c2                	mov    %eax,%edx
  80389f:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a2:	01 d0                	add    %edx,%eax
  8038a4:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8038a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038ab:	74 06                	je     8038b3 <realloc_block_FF+0x613>
  8038ad:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8038b1:	75 17                	jne    8038ca <realloc_block_FF+0x62a>
  8038b3:	83 ec 04             	sub    $0x4,%esp
  8038b6:	68 44 48 80 00       	push   $0x804844
  8038bb:	68 44 02 00 00       	push   $0x244
  8038c0:	68 d1 47 80 00       	push   $0x8047d1
  8038c5:	e8 f0 ca ff ff       	call   8003ba <_panic>
  8038ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038cd:	8b 10                	mov    (%eax),%edx
  8038cf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038d2:	89 10                	mov    %edx,(%eax)
  8038d4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038d7:	8b 00                	mov    (%eax),%eax
  8038d9:	85 c0                	test   %eax,%eax
  8038db:	74 0b                	je     8038e8 <realloc_block_FF+0x648>
  8038dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e0:	8b 00                	mov    (%eax),%eax
  8038e2:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038e5:	89 50 04             	mov    %edx,0x4(%eax)
  8038e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038eb:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038ee:	89 10                	mov    %edx,(%eax)
  8038f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038f6:	89 50 04             	mov    %edx,0x4(%eax)
  8038f9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038fc:	8b 00                	mov    (%eax),%eax
  8038fe:	85 c0                	test   %eax,%eax
  803900:	75 08                	jne    80390a <realloc_block_FF+0x66a>
  803902:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803905:	a3 30 50 80 00       	mov    %eax,0x805030
  80390a:	a1 38 50 80 00       	mov    0x805038,%eax
  80390f:	40                   	inc    %eax
  803910:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803915:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803919:	75 17                	jne    803932 <realloc_block_FF+0x692>
  80391b:	83 ec 04             	sub    $0x4,%esp
  80391e:	68 b3 47 80 00       	push   $0x8047b3
  803923:	68 45 02 00 00       	push   $0x245
  803928:	68 d1 47 80 00       	push   $0x8047d1
  80392d:	e8 88 ca ff ff       	call   8003ba <_panic>
  803932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803935:	8b 00                	mov    (%eax),%eax
  803937:	85 c0                	test   %eax,%eax
  803939:	74 10                	je     80394b <realloc_block_FF+0x6ab>
  80393b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393e:	8b 00                	mov    (%eax),%eax
  803940:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803943:	8b 52 04             	mov    0x4(%edx),%edx
  803946:	89 50 04             	mov    %edx,0x4(%eax)
  803949:	eb 0b                	jmp    803956 <realloc_block_FF+0x6b6>
  80394b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394e:	8b 40 04             	mov    0x4(%eax),%eax
  803951:	a3 30 50 80 00       	mov    %eax,0x805030
  803956:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803959:	8b 40 04             	mov    0x4(%eax),%eax
  80395c:	85 c0                	test   %eax,%eax
  80395e:	74 0f                	je     80396f <realloc_block_FF+0x6cf>
  803960:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803963:	8b 40 04             	mov    0x4(%eax),%eax
  803966:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803969:	8b 12                	mov    (%edx),%edx
  80396b:	89 10                	mov    %edx,(%eax)
  80396d:	eb 0a                	jmp    803979 <realloc_block_FF+0x6d9>
  80396f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803972:	8b 00                	mov    (%eax),%eax
  803974:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803979:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80397c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803982:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803985:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80398c:	a1 38 50 80 00       	mov    0x805038,%eax
  803991:	48                   	dec    %eax
  803992:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803997:	83 ec 04             	sub    $0x4,%esp
  80399a:	6a 00                	push   $0x0
  80399c:	ff 75 bc             	pushl  -0x44(%ebp)
  80399f:	ff 75 b8             	pushl  -0x48(%ebp)
  8039a2:	e8 06 e9 ff ff       	call   8022ad <set_block_data>
  8039a7:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8039aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ad:	eb 0a                	jmp    8039b9 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8039af:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8039b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8039b9:	c9                   	leave  
  8039ba:	c3                   	ret    

008039bb <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8039bb:	55                   	push   %ebp
  8039bc:	89 e5                	mov    %esp,%ebp
  8039be:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8039c1:	83 ec 04             	sub    $0x4,%esp
  8039c4:	68 c8 48 80 00       	push   $0x8048c8
  8039c9:	68 58 02 00 00       	push   $0x258
  8039ce:	68 d1 47 80 00       	push   $0x8047d1
  8039d3:	e8 e2 c9 ff ff       	call   8003ba <_panic>

008039d8 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8039d8:	55                   	push   %ebp
  8039d9:	89 e5                	mov    %esp,%ebp
  8039db:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8039de:	83 ec 04             	sub    $0x4,%esp
  8039e1:	68 f0 48 80 00       	push   $0x8048f0
  8039e6:	68 61 02 00 00       	push   $0x261
  8039eb:	68 d1 47 80 00       	push   $0x8047d1
  8039f0:	e8 c5 c9 ff ff       	call   8003ba <_panic>
  8039f5:	66 90                	xchg   %ax,%ax
  8039f7:	90                   	nop

008039f8 <__udivdi3>:
  8039f8:	55                   	push   %ebp
  8039f9:	57                   	push   %edi
  8039fa:	56                   	push   %esi
  8039fb:	53                   	push   %ebx
  8039fc:	83 ec 1c             	sub    $0x1c,%esp
  8039ff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a03:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a0b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a0f:	89 ca                	mov    %ecx,%edx
  803a11:	89 f8                	mov    %edi,%eax
  803a13:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a17:	85 f6                	test   %esi,%esi
  803a19:	75 2d                	jne    803a48 <__udivdi3+0x50>
  803a1b:	39 cf                	cmp    %ecx,%edi
  803a1d:	77 65                	ja     803a84 <__udivdi3+0x8c>
  803a1f:	89 fd                	mov    %edi,%ebp
  803a21:	85 ff                	test   %edi,%edi
  803a23:	75 0b                	jne    803a30 <__udivdi3+0x38>
  803a25:	b8 01 00 00 00       	mov    $0x1,%eax
  803a2a:	31 d2                	xor    %edx,%edx
  803a2c:	f7 f7                	div    %edi
  803a2e:	89 c5                	mov    %eax,%ebp
  803a30:	31 d2                	xor    %edx,%edx
  803a32:	89 c8                	mov    %ecx,%eax
  803a34:	f7 f5                	div    %ebp
  803a36:	89 c1                	mov    %eax,%ecx
  803a38:	89 d8                	mov    %ebx,%eax
  803a3a:	f7 f5                	div    %ebp
  803a3c:	89 cf                	mov    %ecx,%edi
  803a3e:	89 fa                	mov    %edi,%edx
  803a40:	83 c4 1c             	add    $0x1c,%esp
  803a43:	5b                   	pop    %ebx
  803a44:	5e                   	pop    %esi
  803a45:	5f                   	pop    %edi
  803a46:	5d                   	pop    %ebp
  803a47:	c3                   	ret    
  803a48:	39 ce                	cmp    %ecx,%esi
  803a4a:	77 28                	ja     803a74 <__udivdi3+0x7c>
  803a4c:	0f bd fe             	bsr    %esi,%edi
  803a4f:	83 f7 1f             	xor    $0x1f,%edi
  803a52:	75 40                	jne    803a94 <__udivdi3+0x9c>
  803a54:	39 ce                	cmp    %ecx,%esi
  803a56:	72 0a                	jb     803a62 <__udivdi3+0x6a>
  803a58:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a5c:	0f 87 9e 00 00 00    	ja     803b00 <__udivdi3+0x108>
  803a62:	b8 01 00 00 00       	mov    $0x1,%eax
  803a67:	89 fa                	mov    %edi,%edx
  803a69:	83 c4 1c             	add    $0x1c,%esp
  803a6c:	5b                   	pop    %ebx
  803a6d:	5e                   	pop    %esi
  803a6e:	5f                   	pop    %edi
  803a6f:	5d                   	pop    %ebp
  803a70:	c3                   	ret    
  803a71:	8d 76 00             	lea    0x0(%esi),%esi
  803a74:	31 ff                	xor    %edi,%edi
  803a76:	31 c0                	xor    %eax,%eax
  803a78:	89 fa                	mov    %edi,%edx
  803a7a:	83 c4 1c             	add    $0x1c,%esp
  803a7d:	5b                   	pop    %ebx
  803a7e:	5e                   	pop    %esi
  803a7f:	5f                   	pop    %edi
  803a80:	5d                   	pop    %ebp
  803a81:	c3                   	ret    
  803a82:	66 90                	xchg   %ax,%ax
  803a84:	89 d8                	mov    %ebx,%eax
  803a86:	f7 f7                	div    %edi
  803a88:	31 ff                	xor    %edi,%edi
  803a8a:	89 fa                	mov    %edi,%edx
  803a8c:	83 c4 1c             	add    $0x1c,%esp
  803a8f:	5b                   	pop    %ebx
  803a90:	5e                   	pop    %esi
  803a91:	5f                   	pop    %edi
  803a92:	5d                   	pop    %ebp
  803a93:	c3                   	ret    
  803a94:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a99:	89 eb                	mov    %ebp,%ebx
  803a9b:	29 fb                	sub    %edi,%ebx
  803a9d:	89 f9                	mov    %edi,%ecx
  803a9f:	d3 e6                	shl    %cl,%esi
  803aa1:	89 c5                	mov    %eax,%ebp
  803aa3:	88 d9                	mov    %bl,%cl
  803aa5:	d3 ed                	shr    %cl,%ebp
  803aa7:	89 e9                	mov    %ebp,%ecx
  803aa9:	09 f1                	or     %esi,%ecx
  803aab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803aaf:	89 f9                	mov    %edi,%ecx
  803ab1:	d3 e0                	shl    %cl,%eax
  803ab3:	89 c5                	mov    %eax,%ebp
  803ab5:	89 d6                	mov    %edx,%esi
  803ab7:	88 d9                	mov    %bl,%cl
  803ab9:	d3 ee                	shr    %cl,%esi
  803abb:	89 f9                	mov    %edi,%ecx
  803abd:	d3 e2                	shl    %cl,%edx
  803abf:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ac3:	88 d9                	mov    %bl,%cl
  803ac5:	d3 e8                	shr    %cl,%eax
  803ac7:	09 c2                	or     %eax,%edx
  803ac9:	89 d0                	mov    %edx,%eax
  803acb:	89 f2                	mov    %esi,%edx
  803acd:	f7 74 24 0c          	divl   0xc(%esp)
  803ad1:	89 d6                	mov    %edx,%esi
  803ad3:	89 c3                	mov    %eax,%ebx
  803ad5:	f7 e5                	mul    %ebp
  803ad7:	39 d6                	cmp    %edx,%esi
  803ad9:	72 19                	jb     803af4 <__udivdi3+0xfc>
  803adb:	74 0b                	je     803ae8 <__udivdi3+0xf0>
  803add:	89 d8                	mov    %ebx,%eax
  803adf:	31 ff                	xor    %edi,%edi
  803ae1:	e9 58 ff ff ff       	jmp    803a3e <__udivdi3+0x46>
  803ae6:	66 90                	xchg   %ax,%ax
  803ae8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803aec:	89 f9                	mov    %edi,%ecx
  803aee:	d3 e2                	shl    %cl,%edx
  803af0:	39 c2                	cmp    %eax,%edx
  803af2:	73 e9                	jae    803add <__udivdi3+0xe5>
  803af4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803af7:	31 ff                	xor    %edi,%edi
  803af9:	e9 40 ff ff ff       	jmp    803a3e <__udivdi3+0x46>
  803afe:	66 90                	xchg   %ax,%ax
  803b00:	31 c0                	xor    %eax,%eax
  803b02:	e9 37 ff ff ff       	jmp    803a3e <__udivdi3+0x46>
  803b07:	90                   	nop

00803b08 <__umoddi3>:
  803b08:	55                   	push   %ebp
  803b09:	57                   	push   %edi
  803b0a:	56                   	push   %esi
  803b0b:	53                   	push   %ebx
  803b0c:	83 ec 1c             	sub    $0x1c,%esp
  803b0f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b13:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b1b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b23:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b27:	89 f3                	mov    %esi,%ebx
  803b29:	89 fa                	mov    %edi,%edx
  803b2b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b2f:	89 34 24             	mov    %esi,(%esp)
  803b32:	85 c0                	test   %eax,%eax
  803b34:	75 1a                	jne    803b50 <__umoddi3+0x48>
  803b36:	39 f7                	cmp    %esi,%edi
  803b38:	0f 86 a2 00 00 00    	jbe    803be0 <__umoddi3+0xd8>
  803b3e:	89 c8                	mov    %ecx,%eax
  803b40:	89 f2                	mov    %esi,%edx
  803b42:	f7 f7                	div    %edi
  803b44:	89 d0                	mov    %edx,%eax
  803b46:	31 d2                	xor    %edx,%edx
  803b48:	83 c4 1c             	add    $0x1c,%esp
  803b4b:	5b                   	pop    %ebx
  803b4c:	5e                   	pop    %esi
  803b4d:	5f                   	pop    %edi
  803b4e:	5d                   	pop    %ebp
  803b4f:	c3                   	ret    
  803b50:	39 f0                	cmp    %esi,%eax
  803b52:	0f 87 ac 00 00 00    	ja     803c04 <__umoddi3+0xfc>
  803b58:	0f bd e8             	bsr    %eax,%ebp
  803b5b:	83 f5 1f             	xor    $0x1f,%ebp
  803b5e:	0f 84 ac 00 00 00    	je     803c10 <__umoddi3+0x108>
  803b64:	bf 20 00 00 00       	mov    $0x20,%edi
  803b69:	29 ef                	sub    %ebp,%edi
  803b6b:	89 fe                	mov    %edi,%esi
  803b6d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b71:	89 e9                	mov    %ebp,%ecx
  803b73:	d3 e0                	shl    %cl,%eax
  803b75:	89 d7                	mov    %edx,%edi
  803b77:	89 f1                	mov    %esi,%ecx
  803b79:	d3 ef                	shr    %cl,%edi
  803b7b:	09 c7                	or     %eax,%edi
  803b7d:	89 e9                	mov    %ebp,%ecx
  803b7f:	d3 e2                	shl    %cl,%edx
  803b81:	89 14 24             	mov    %edx,(%esp)
  803b84:	89 d8                	mov    %ebx,%eax
  803b86:	d3 e0                	shl    %cl,%eax
  803b88:	89 c2                	mov    %eax,%edx
  803b8a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b8e:	d3 e0                	shl    %cl,%eax
  803b90:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b94:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b98:	89 f1                	mov    %esi,%ecx
  803b9a:	d3 e8                	shr    %cl,%eax
  803b9c:	09 d0                	or     %edx,%eax
  803b9e:	d3 eb                	shr    %cl,%ebx
  803ba0:	89 da                	mov    %ebx,%edx
  803ba2:	f7 f7                	div    %edi
  803ba4:	89 d3                	mov    %edx,%ebx
  803ba6:	f7 24 24             	mull   (%esp)
  803ba9:	89 c6                	mov    %eax,%esi
  803bab:	89 d1                	mov    %edx,%ecx
  803bad:	39 d3                	cmp    %edx,%ebx
  803baf:	0f 82 87 00 00 00    	jb     803c3c <__umoddi3+0x134>
  803bb5:	0f 84 91 00 00 00    	je     803c4c <__umoddi3+0x144>
  803bbb:	8b 54 24 04          	mov    0x4(%esp),%edx
  803bbf:	29 f2                	sub    %esi,%edx
  803bc1:	19 cb                	sbb    %ecx,%ebx
  803bc3:	89 d8                	mov    %ebx,%eax
  803bc5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803bc9:	d3 e0                	shl    %cl,%eax
  803bcb:	89 e9                	mov    %ebp,%ecx
  803bcd:	d3 ea                	shr    %cl,%edx
  803bcf:	09 d0                	or     %edx,%eax
  803bd1:	89 e9                	mov    %ebp,%ecx
  803bd3:	d3 eb                	shr    %cl,%ebx
  803bd5:	89 da                	mov    %ebx,%edx
  803bd7:	83 c4 1c             	add    $0x1c,%esp
  803bda:	5b                   	pop    %ebx
  803bdb:	5e                   	pop    %esi
  803bdc:	5f                   	pop    %edi
  803bdd:	5d                   	pop    %ebp
  803bde:	c3                   	ret    
  803bdf:	90                   	nop
  803be0:	89 fd                	mov    %edi,%ebp
  803be2:	85 ff                	test   %edi,%edi
  803be4:	75 0b                	jne    803bf1 <__umoddi3+0xe9>
  803be6:	b8 01 00 00 00       	mov    $0x1,%eax
  803beb:	31 d2                	xor    %edx,%edx
  803bed:	f7 f7                	div    %edi
  803bef:	89 c5                	mov    %eax,%ebp
  803bf1:	89 f0                	mov    %esi,%eax
  803bf3:	31 d2                	xor    %edx,%edx
  803bf5:	f7 f5                	div    %ebp
  803bf7:	89 c8                	mov    %ecx,%eax
  803bf9:	f7 f5                	div    %ebp
  803bfb:	89 d0                	mov    %edx,%eax
  803bfd:	e9 44 ff ff ff       	jmp    803b46 <__umoddi3+0x3e>
  803c02:	66 90                	xchg   %ax,%ax
  803c04:	89 c8                	mov    %ecx,%eax
  803c06:	89 f2                	mov    %esi,%edx
  803c08:	83 c4 1c             	add    $0x1c,%esp
  803c0b:	5b                   	pop    %ebx
  803c0c:	5e                   	pop    %esi
  803c0d:	5f                   	pop    %edi
  803c0e:	5d                   	pop    %ebp
  803c0f:	c3                   	ret    
  803c10:	3b 04 24             	cmp    (%esp),%eax
  803c13:	72 06                	jb     803c1b <__umoddi3+0x113>
  803c15:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c19:	77 0f                	ja     803c2a <__umoddi3+0x122>
  803c1b:	89 f2                	mov    %esi,%edx
  803c1d:	29 f9                	sub    %edi,%ecx
  803c1f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c23:	89 14 24             	mov    %edx,(%esp)
  803c26:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c2a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c2e:	8b 14 24             	mov    (%esp),%edx
  803c31:	83 c4 1c             	add    $0x1c,%esp
  803c34:	5b                   	pop    %ebx
  803c35:	5e                   	pop    %esi
  803c36:	5f                   	pop    %edi
  803c37:	5d                   	pop    %ebp
  803c38:	c3                   	ret    
  803c39:	8d 76 00             	lea    0x0(%esi),%esi
  803c3c:	2b 04 24             	sub    (%esp),%eax
  803c3f:	19 fa                	sbb    %edi,%edx
  803c41:	89 d1                	mov    %edx,%ecx
  803c43:	89 c6                	mov    %eax,%esi
  803c45:	e9 71 ff ff ff       	jmp    803bbb <__umoddi3+0xb3>
  803c4a:	66 90                	xchg   %ax,%ax
  803c4c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c50:	72 ea                	jb     803c3c <__umoddi3+0x134>
  803c52:	89 d9                	mov    %ebx,%ecx
  803c54:	e9 62 ff ff ff       	jmp    803bbb <__umoddi3+0xb3>
