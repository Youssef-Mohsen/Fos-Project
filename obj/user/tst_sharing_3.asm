
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
  80005b:	68 c0 3b 80 00       	push   $0x803bc0
  800060:	6a 0c                	push   $0xc
  800062:	68 dc 3b 80 00       	push   $0x803bdc
  800067:	e8 4e 03 00 00       	call   8003ba <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	cprintf("************************************************\n");
  80006c:	83 ec 0c             	sub    $0xc,%esp
  80006f:	68 f4 3b 80 00       	push   $0x803bf4
  800074:	e8 fe 05 00 00       	call   800677 <cprintf>
  800079:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	68 28 3c 80 00       	push   $0x803c28
  800084:	e8 ee 05 00 00       	call   800677 <cprintf>
  800089:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 84 3c 80 00       	push   $0x803c84
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
  8000b4:	68 b8 3c 80 00       	push   $0x803cb8
  8000b9:	e8 b9 05 00 00       	call   800677 <cprintf>
  8000be:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 01                	push   $0x1
  8000c6:	68 00 10 00 00       	push   $0x1000
  8000cb:	68 06 3d 80 00       	push   $0x803d06
  8000d0:	e8 6f 16 00 00       	call   801744 <smalloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000db:	e8 c1 18 00 00       	call   8019a1 <sys_calculate_free_frames>
  8000e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000e3:	83 ec 04             	sub    $0x4,%esp
  8000e6:	6a 01                	push   $0x1
  8000e8:	68 00 10 00 00       	push   $0x1000
  8000ed:	68 06 3d 80 00       	push   $0x803d06
  8000f2:	e8 4d 16 00 00       	call   801744 <smalloc>
  8000f7:	83 c4 10             	add    $0x10,%esp
  8000fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) {is_correct = 0; cprintf("Trying to create an already exists object and corresponding error is not returned!!");}
  8000fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800101:	74 17                	je     80011a <_main+0xe2>
  800103:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	68 08 3d 80 00       	push   $0x803d08
  800112:	e8 60 05 00 00       	call   800677 <cprintf>
  800117:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");}
  80011a:	e8 82 18 00 00       	call   8019a1 <sys_calculate_free_frames>
  80011f:	89 c2                	mov    %eax,%edx
  800121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800124:	39 c2                	cmp    %eax,%edx
  800126:	74 17                	je     80013f <_main+0x107>
  800128:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 5c 3d 80 00       	push   $0x803d5c
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
  800153:	68 b8 3d 80 00       	push   $0x803db8
  800158:	e8 1a 05 00 00       	call   800677 <cprintf>
  80015d:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		x = sget(myEnv->env_id, "xx");
  800160:	a1 20 50 80 00       	mov    0x805020,%eax
  800165:	8b 40 10             	mov    0x10(%eax),%eax
  800168:	83 ec 08             	sub    $0x8,%esp
  80016b:	68 fd 3d 80 00       	push   $0x803dfd
  800170:	50                   	push   %eax
  800171:	e8 5d 16 00 00       	call   8017d3 <sget>
  800176:	83 c4 10             	add    $0x10,%esp
  800179:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  80017c:	e8 20 18 00 00       	call   8019a1 <sys_calculate_free_frames>
  800181:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != NULL) {is_correct = 0; cprintf("Trying to get a NON existing object and corresponding error is not returned!!");}
  800184:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800188:	74 17                	je     8001a1 <_main+0x169>
  80018a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800191:	83 ec 0c             	sub    $0xc,%esp
  800194:	68 00 3e 80 00       	push   $0x803e00
  800199:	e8 d9 04 00 00       	call   800677 <cprintf>
  80019e:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong get: make sure that you don't allocate any memory if the shared object not exists");}
  8001a1:	e8 fb 17 00 00       	call   8019a1 <sys_calculate_free_frames>
  8001a6:	89 c2                	mov    %eax,%edx
  8001a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ab:	39 c2                	cmp    %eax,%edx
  8001ad:	74 17                	je     8001c6 <_main+0x18e>
  8001af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	68 50 3e 80 00       	push   $0x803e50
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
  8001da:	68 a8 3e 80 00       	push   $0x803ea8
  8001df:	e8 93 04 00 00       	call   800677 <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8001e7:	e8 b5 17 00 00       	call   8019a1 <sys_calculate_free_frames>
  8001ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uint32 size = USER_HEAP_MAX - pagealloc_start - PAGE_SIZE + 1;
  8001ef:	b8 01 f0 ff 9f       	mov    $0x9ffff001,%eax
  8001f4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8001f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		y = smalloc("y", size, 1);
  8001fa:	83 ec 04             	sub    $0x4,%esp
  8001fd:	6a 01                	push   $0x1
  8001ff:	ff 75 d8             	pushl  -0x28(%ebp)
  800202:	68 05 3f 80 00       	push   $0x803f05
  800207:	e8 38 15 00 00       	call   801744 <smalloc>
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (y != NULL) {is_correct = 0; cprintf("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");}
  800212:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800216:	74 17                	je     80022f <_main+0x1f7>
  800218:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	68 08 3f 80 00       	push   $0x803f08
  800227:	e8 4b 04 00 00       	call   800677 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");}
  80022f:	e8 6d 17 00 00       	call   8019a1 <sys_calculate_free_frames>
  800234:	89 c2                	mov    %eax,%edx
  800236:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800239:	39 c2                	cmp    %eax,%edx
  80023b:	74 17                	je     800254 <_main+0x21c>
  80023d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 7c 3f 80 00       	push   $0x803f7c
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
  80026b:	68 f0 3f 80 00       	push   $0x803ff0
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
  800281:	e8 e4 18 00 00       	call   801b6a <sys_getenvindex>
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
  8002ef:	e8 fa 15 00 00       	call   8018ee <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 5c 40 80 00       	push   $0x80405c
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
  80031f:	68 84 40 80 00       	push   $0x804084
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
  800350:	68 ac 40 80 00       	push   $0x8040ac
  800355:	e8 1d 03 00 00       	call   800677 <cprintf>
  80035a:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80035d:	a1 20 50 80 00       	mov    0x805020,%eax
  800362:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800368:	83 ec 08             	sub    $0x8,%esp
  80036b:	50                   	push   %eax
  80036c:	68 04 41 80 00       	push   $0x804104
  800371:	e8 01 03 00 00       	call   800677 <cprintf>
  800376:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800379:	83 ec 0c             	sub    $0xc,%esp
  80037c:	68 5c 40 80 00       	push   $0x80405c
  800381:	e8 f1 02 00 00       	call   800677 <cprintf>
  800386:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800389:	e8 7a 15 00 00       	call   801908 <sys_unlock_cons>
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
  8003a1:	e8 90 17 00 00       	call   801b36 <sys_destroy_env>
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
  8003b2:	e8 e5 17 00 00       	call   801b9c <sys_exit_env>
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
  8003db:	68 18 41 80 00       	push   $0x804118
  8003e0:	e8 92 02 00 00       	call   800677 <cprintf>
  8003e5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003e8:	a1 00 50 80 00       	mov    0x805000,%eax
  8003ed:	ff 75 0c             	pushl  0xc(%ebp)
  8003f0:	ff 75 08             	pushl  0x8(%ebp)
  8003f3:	50                   	push   %eax
  8003f4:	68 1d 41 80 00       	push   $0x80411d
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
  800418:	68 39 41 80 00       	push   $0x804139
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
  800447:	68 3c 41 80 00       	push   $0x80413c
  80044c:	6a 26                	push   $0x26
  80044e:	68 88 41 80 00       	push   $0x804188
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
  80051c:	68 94 41 80 00       	push   $0x804194
  800521:	6a 3a                	push   $0x3a
  800523:	68 88 41 80 00       	push   $0x804188
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
  80058f:	68 e8 41 80 00       	push   $0x8041e8
  800594:	6a 44                	push   $0x44
  800596:	68 88 41 80 00       	push   $0x804188
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
  8005e9:	e8 be 12 00 00       	call   8018ac <sys_cputs>
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
  800660:	e8 47 12 00 00       	call   8018ac <sys_cputs>
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
  8006aa:	e8 3f 12 00 00       	call   8018ee <sys_lock_cons>
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
  8006ca:	e8 39 12 00 00       	call   801908 <sys_unlock_cons>
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
  800714:	e8 2b 32 00 00       	call   803944 <__udivdi3>
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
  800764:	e8 eb 32 00 00       	call   803a54 <__umoddi3>
  800769:	83 c4 10             	add    $0x10,%esp
  80076c:	05 54 44 80 00       	add    $0x804454,%eax
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
  8008bf:	8b 04 85 78 44 80 00 	mov    0x804478(,%eax,4),%eax
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
  8009a0:	8b 34 9d c0 42 80 00 	mov    0x8042c0(,%ebx,4),%esi
  8009a7:	85 f6                	test   %esi,%esi
  8009a9:	75 19                	jne    8009c4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009ab:	53                   	push   %ebx
  8009ac:	68 65 44 80 00       	push   $0x804465
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
  8009c5:	68 6e 44 80 00       	push   $0x80446e
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
  8009f2:	be 71 44 80 00       	mov    $0x804471,%esi
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
  8013fd:	68 e8 45 80 00       	push   $0x8045e8
  801402:	68 3f 01 00 00       	push   $0x13f
  801407:	68 0a 46 80 00       	push   $0x80460a
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
  80141d:	e8 35 0a 00 00       	call   801e57 <sys_sbrk>
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
  801498:	e8 3e 08 00 00       	call   801cdb <sys_isUHeapPlacementStrategyFIRSTFIT>
  80149d:	85 c0                	test   %eax,%eax
  80149f:	74 16                	je     8014b7 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8014a1:	83 ec 0c             	sub    $0xc,%esp
  8014a4:	ff 75 08             	pushl  0x8(%ebp)
  8014a7:	e8 7e 0d 00 00       	call   80222a <alloc_block_FF>
  8014ac:	83 c4 10             	add    $0x10,%esp
  8014af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014b2:	e9 8a 01 00 00       	jmp    801641 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014b7:	e8 50 08 00 00       	call   801d0c <sys_isUHeapPlacementStrategyBESTFIT>
  8014bc:	85 c0                	test   %eax,%eax
  8014be:	0f 84 7d 01 00 00    	je     801641 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014c4:	83 ec 0c             	sub    $0xc,%esp
  8014c7:	ff 75 08             	pushl  0x8(%ebp)
  8014ca:	e8 17 12 00 00       	call   8026e6 <alloc_block_BF>
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
  80151a:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  801567:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  8015be:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
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
  801620:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801627:	83 ec 08             	sub    $0x8,%esp
  80162a:	ff 75 08             	pushl  0x8(%ebp)
  80162d:	ff 75 f0             	pushl  -0x10(%ebp)
  801630:	e8 59 08 00 00       	call   801e8e <sys_allocate_user_mem>
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
  801678:	e8 2d 08 00 00       	call   801eaa <get_block_size>
  80167d:	83 c4 10             	add    $0x10,%esp
  801680:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801683:	83 ec 0c             	sub    $0xc,%esp
  801686:	ff 75 08             	pushl  0x8(%ebp)
  801689:	e8 60 1a 00 00       	call   8030ee <free_block>
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
  8016c3:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801700:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
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
  801720:	e8 4d 07 00 00       	call   801e72 <sys_free_user_mem>
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
  80172e:	68 18 46 80 00       	push   $0x804618
  801733:	68 84 00 00 00       	push   $0x84
  801738:	68 42 46 80 00       	push   $0x804642
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
  801754:	75 07                	jne    80175d <smalloc+0x19>
  801756:	b8 00 00 00 00       	mov    $0x0,%eax
  80175b:	eb 74                	jmp    8017d1 <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  80175d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801760:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801763:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80176a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80176d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801770:	39 d0                	cmp    %edx,%eax
  801772:	73 02                	jae    801776 <smalloc+0x32>
  801774:	89 d0                	mov    %edx,%eax
  801776:	83 ec 0c             	sub    $0xc,%esp
  801779:	50                   	push   %eax
  80177a:	e8 a8 fc ff ff       	call   801427 <malloc>
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801785:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801789:	75 07                	jne    801792 <smalloc+0x4e>
  80178b:	b8 00 00 00 00       	mov    $0x0,%eax
  801790:	eb 3f                	jmp    8017d1 <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801792:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801796:	ff 75 ec             	pushl  -0x14(%ebp)
  801799:	50                   	push   %eax
  80179a:	ff 75 0c             	pushl  0xc(%ebp)
  80179d:	ff 75 08             	pushl  0x8(%ebp)
  8017a0:	e8 d4 02 00 00       	call   801a79 <sys_createSharedObject>
  8017a5:	83 c4 10             	add    $0x10,%esp
  8017a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8017ab:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8017af:	74 06                	je     8017b7 <smalloc+0x73>
  8017b1:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8017b5:	75 07                	jne    8017be <smalloc+0x7a>
  8017b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017bc:	eb 13                	jmp    8017d1 <smalloc+0x8d>
	 cprintf("153\n");
  8017be:	83 ec 0c             	sub    $0xc,%esp
  8017c1:	68 4e 46 80 00       	push   $0x80464e
  8017c6:	e8 ac ee ff ff       	call   800677 <cprintf>
  8017cb:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  8017ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8017d9:	83 ec 04             	sub    $0x4,%esp
  8017dc:	68 54 46 80 00       	push   $0x804654
  8017e1:	68 a4 00 00 00       	push   $0xa4
  8017e6:	68 42 46 80 00       	push   $0x804642
  8017eb:	e8 ca eb ff ff       	call   8003ba <_panic>

008017f0 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017f6:	83 ec 04             	sub    $0x4,%esp
  8017f9:	68 78 46 80 00       	push   $0x804678
  8017fe:	68 bc 00 00 00       	push   $0xbc
  801803:	68 42 46 80 00       	push   $0x804642
  801808:	e8 ad eb ff ff       	call   8003ba <_panic>

0080180d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801813:	83 ec 04             	sub    $0x4,%esp
  801816:	68 9c 46 80 00       	push   $0x80469c
  80181b:	68 d3 00 00 00       	push   $0xd3
  801820:	68 42 46 80 00       	push   $0x804642
  801825:	e8 90 eb ff ff       	call   8003ba <_panic>

0080182a <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801830:	83 ec 04             	sub    $0x4,%esp
  801833:	68 c2 46 80 00       	push   $0x8046c2
  801838:	68 df 00 00 00       	push   $0xdf
  80183d:	68 42 46 80 00       	push   $0x804642
  801842:	e8 73 eb ff ff       	call   8003ba <_panic>

00801847 <shrink>:

}
void shrink(uint32 newSize)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80184d:	83 ec 04             	sub    $0x4,%esp
  801850:	68 c2 46 80 00       	push   $0x8046c2
  801855:	68 e4 00 00 00       	push   $0xe4
  80185a:	68 42 46 80 00       	push   $0x804642
  80185f:	e8 56 eb ff ff       	call   8003ba <_panic>

00801864 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80186a:	83 ec 04             	sub    $0x4,%esp
  80186d:	68 c2 46 80 00       	push   $0x8046c2
  801872:	68 e9 00 00 00       	push   $0xe9
  801877:	68 42 46 80 00       	push   $0x804642
  80187c:	e8 39 eb ff ff       	call   8003ba <_panic>

00801881 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	57                   	push   %edi
  801885:	56                   	push   %esi
  801886:	53                   	push   %ebx
  801887:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801890:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801893:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801896:	8b 7d 18             	mov    0x18(%ebp),%edi
  801899:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80189c:	cd 30                	int    $0x30
  80189e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018a4:	83 c4 10             	add    $0x10,%esp
  8018a7:	5b                   	pop    %ebx
  8018a8:	5e                   	pop    %esi
  8018a9:	5f                   	pop    %edi
  8018aa:	5d                   	pop    %ebp
  8018ab:	c3                   	ret    

008018ac <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	83 ec 04             	sub    $0x4,%esp
  8018b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018b8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	52                   	push   %edx
  8018c4:	ff 75 0c             	pushl  0xc(%ebp)
  8018c7:	50                   	push   %eax
  8018c8:	6a 00                	push   $0x0
  8018ca:	e8 b2 ff ff ff       	call   801881 <syscall>
  8018cf:	83 c4 18             	add    $0x18,%esp
}
  8018d2:	90                   	nop
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 02                	push   $0x2
  8018e4:	e8 98 ff ff ff       	call   801881 <syscall>
  8018e9:	83 c4 18             	add    $0x18,%esp
}
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    

008018ee <sys_lock_cons>:

void sys_lock_cons(void)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 03                	push   $0x3
  8018fd:	e8 7f ff ff ff       	call   801881 <syscall>
  801902:	83 c4 18             	add    $0x18,%esp
}
  801905:	90                   	nop
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 04                	push   $0x4
  801917:	e8 65 ff ff ff       	call   801881 <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
}
  80191f:	90                   	nop
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801925:	8b 55 0c             	mov    0xc(%ebp),%edx
  801928:	8b 45 08             	mov    0x8(%ebp),%eax
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	52                   	push   %edx
  801932:	50                   	push   %eax
  801933:	6a 08                	push   $0x8
  801935:	e8 47 ff ff ff       	call   801881 <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
  801942:	56                   	push   %esi
  801943:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801944:	8b 75 18             	mov    0x18(%ebp),%esi
  801947:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80194a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80194d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	56                   	push   %esi
  801954:	53                   	push   %ebx
  801955:	51                   	push   %ecx
  801956:	52                   	push   %edx
  801957:	50                   	push   %eax
  801958:	6a 09                	push   $0x9
  80195a:	e8 22 ff ff ff       	call   801881 <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
}
  801962:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801965:	5b                   	pop    %ebx
  801966:	5e                   	pop    %esi
  801967:	5d                   	pop    %ebp
  801968:	c3                   	ret    

00801969 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80196c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196f:	8b 45 08             	mov    0x8(%ebp),%eax
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	52                   	push   %edx
  801979:	50                   	push   %eax
  80197a:	6a 0a                	push   $0xa
  80197c:	e8 00 ff ff ff       	call   801881 <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	ff 75 0c             	pushl  0xc(%ebp)
  801992:	ff 75 08             	pushl  0x8(%ebp)
  801995:	6a 0b                	push   $0xb
  801997:	e8 e5 fe ff ff       	call   801881 <syscall>
  80199c:	83 c4 18             	add    $0x18,%esp
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 0c                	push   $0xc
  8019b0:	e8 cc fe ff ff       	call   801881 <syscall>
  8019b5:	83 c4 18             	add    $0x18,%esp
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 0d                	push   $0xd
  8019c9:	e8 b3 fe ff ff       	call   801881 <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 0e                	push   $0xe
  8019e2:	e8 9a fe ff ff       	call   801881 <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 0f                	push   $0xf
  8019fb:	e8 81 fe ff ff       	call   801881 <syscall>
  801a00:	83 c4 18             	add    $0x18,%esp
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	ff 75 08             	pushl  0x8(%ebp)
  801a13:	6a 10                	push   $0x10
  801a15:	e8 67 fe ff ff       	call   801881 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 11                	push   $0x11
  801a2e:	e8 4e fe ff ff       	call   801881 <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	90                   	nop
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <sys_cputc>:

void
sys_cputc(const char c)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
  801a3c:	83 ec 04             	sub    $0x4,%esp
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a45:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	50                   	push   %eax
  801a52:	6a 01                	push   $0x1
  801a54:	e8 28 fe ff ff       	call   801881 <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
}
  801a5c:	90                   	nop
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 14                	push   $0x14
  801a6e:	e8 0e fe ff ff       	call   801881 <syscall>
  801a73:	83 c4 18             	add    $0x18,%esp
}
  801a76:	90                   	nop
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
  801a7c:	83 ec 04             	sub    $0x4,%esp
  801a7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a82:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a85:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a88:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8f:	6a 00                	push   $0x0
  801a91:	51                   	push   %ecx
  801a92:	52                   	push   %edx
  801a93:	ff 75 0c             	pushl  0xc(%ebp)
  801a96:	50                   	push   %eax
  801a97:	6a 15                	push   $0x15
  801a99:	e8 e3 fd ff ff       	call   801881 <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801aa6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	52                   	push   %edx
  801ab3:	50                   	push   %eax
  801ab4:	6a 16                	push   $0x16
  801ab6:	e8 c6 fd ff ff       	call   801881 <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ac3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	51                   	push   %ecx
  801ad1:	52                   	push   %edx
  801ad2:	50                   	push   %eax
  801ad3:	6a 17                	push   $0x17
  801ad5:	e8 a7 fd ff ff       	call   801881 <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ae2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	52                   	push   %edx
  801aef:	50                   	push   %eax
  801af0:	6a 18                	push   $0x18
  801af2:	e8 8a fd ff ff       	call   801881 <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801aff:	8b 45 08             	mov    0x8(%ebp),%eax
  801b02:	6a 00                	push   $0x0
  801b04:	ff 75 14             	pushl  0x14(%ebp)
  801b07:	ff 75 10             	pushl  0x10(%ebp)
  801b0a:	ff 75 0c             	pushl  0xc(%ebp)
  801b0d:	50                   	push   %eax
  801b0e:	6a 19                	push   $0x19
  801b10:	e8 6c fd ff ff       	call   801881 <syscall>
  801b15:	83 c4 18             	add    $0x18,%esp
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <sys_run_env>:

void sys_run_env(int32 envId)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	50                   	push   %eax
  801b29:	6a 1a                	push   $0x1a
  801b2b:	e8 51 fd ff ff       	call   801881 <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
}
  801b33:	90                   	nop
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b39:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	50                   	push   %eax
  801b45:	6a 1b                	push   $0x1b
  801b47:	e8 35 fd ff ff       	call   801881 <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 05                	push   $0x5
  801b60:	e8 1c fd ff ff       	call   801881 <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 06                	push   $0x6
  801b79:	e8 03 fd ff ff       	call   801881 <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 07                	push   $0x7
  801b92:	e8 ea fc ff ff       	call   801881 <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
}
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <sys_exit_env>:


void sys_exit_env(void)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 1c                	push   $0x1c
  801bab:	e8 d1 fc ff ff       	call   801881 <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
}
  801bb3:	90                   	nop
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
  801bb9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bbc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bbf:	8d 50 04             	lea    0x4(%eax),%edx
  801bc2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	52                   	push   %edx
  801bcc:	50                   	push   %eax
  801bcd:	6a 1d                	push   $0x1d
  801bcf:	e8 ad fc ff ff       	call   801881 <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
	return result;
  801bd7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bdd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801be0:	89 01                	mov    %eax,(%ecx)
  801be2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801be5:	8b 45 08             	mov    0x8(%ebp),%eax
  801be8:	c9                   	leave  
  801be9:	c2 04 00             	ret    $0x4

00801bec <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	ff 75 10             	pushl  0x10(%ebp)
  801bf6:	ff 75 0c             	pushl  0xc(%ebp)
  801bf9:	ff 75 08             	pushl  0x8(%ebp)
  801bfc:	6a 13                	push   $0x13
  801bfe:	e8 7e fc ff ff       	call   801881 <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
	return ;
  801c06:	90                   	nop
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 1e                	push   $0x1e
  801c18:	e8 64 fc ff ff       	call   801881 <syscall>
  801c1d:	83 c4 18             	add    $0x18,%esp
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	83 ec 04             	sub    $0x4,%esp
  801c28:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c2e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	50                   	push   %eax
  801c3b:	6a 1f                	push   $0x1f
  801c3d:	e8 3f fc ff ff       	call   801881 <syscall>
  801c42:	83 c4 18             	add    $0x18,%esp
	return ;
  801c45:	90                   	nop
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <rsttst>:
void rsttst()
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 21                	push   $0x21
  801c57:	e8 25 fc ff ff       	call   801881 <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5f:	90                   	nop
}
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	83 ec 04             	sub    $0x4,%esp
  801c68:	8b 45 14             	mov    0x14(%ebp),%eax
  801c6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c6e:	8b 55 18             	mov    0x18(%ebp),%edx
  801c71:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c75:	52                   	push   %edx
  801c76:	50                   	push   %eax
  801c77:	ff 75 10             	pushl  0x10(%ebp)
  801c7a:	ff 75 0c             	pushl  0xc(%ebp)
  801c7d:	ff 75 08             	pushl  0x8(%ebp)
  801c80:	6a 20                	push   $0x20
  801c82:	e8 fa fb ff ff       	call   801881 <syscall>
  801c87:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8a:	90                   	nop
}
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    

00801c8d <chktst>:
void chktst(uint32 n)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	ff 75 08             	pushl  0x8(%ebp)
  801c9b:	6a 22                	push   $0x22
  801c9d:	e8 df fb ff ff       	call   801881 <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca5:	90                   	nop
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <inctst>:

void inctst()
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 23                	push   $0x23
  801cb7:	e8 c5 fb ff ff       	call   801881 <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
	return ;
  801cbf:	90                   	nop
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <gettst>:
uint32 gettst()
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 24                	push   $0x24
  801cd1:	e8 ab fb ff ff       	call   801881 <syscall>
  801cd6:	83 c4 18             	add    $0x18,%esp
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
  801cde:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 25                	push   $0x25
  801ced:	e8 8f fb ff ff       	call   801881 <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
  801cf5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cf8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cfc:	75 07                	jne    801d05 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cfe:	b8 01 00 00 00       	mov    $0x1,%eax
  801d03:	eb 05                	jmp    801d0a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 25                	push   $0x25
  801d1e:	e8 5e fb ff ff       	call   801881 <syscall>
  801d23:	83 c4 18             	add    $0x18,%esp
  801d26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d29:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d2d:	75 07                	jne    801d36 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d2f:	b8 01 00 00 00       	mov    $0x1,%eax
  801d34:	eb 05                	jmp    801d3b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 25                	push   $0x25
  801d4f:	e8 2d fb ff ff       	call   801881 <syscall>
  801d54:	83 c4 18             	add    $0x18,%esp
  801d57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d5a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d5e:	75 07                	jne    801d67 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d60:	b8 01 00 00 00       	mov    $0x1,%eax
  801d65:	eb 05                	jmp    801d6c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
  801d71:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 25                	push   $0x25
  801d80:	e8 fc fa ff ff       	call   801881 <syscall>
  801d85:	83 c4 18             	add    $0x18,%esp
  801d88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d8b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d8f:	75 07                	jne    801d98 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d91:	b8 01 00 00 00       	mov    $0x1,%eax
  801d96:	eb 05                	jmp    801d9d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    

00801d9f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	ff 75 08             	pushl  0x8(%ebp)
  801dad:	6a 26                	push   $0x26
  801daf:	e8 cd fa ff ff       	call   801881 <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
	return ;
  801db7:	90                   	nop
}
  801db8:	c9                   	leave  
  801db9:	c3                   	ret    

00801dba <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dbe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dc1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dca:	6a 00                	push   $0x0
  801dcc:	53                   	push   %ebx
  801dcd:	51                   	push   %ecx
  801dce:	52                   	push   %edx
  801dcf:	50                   	push   %eax
  801dd0:	6a 27                	push   $0x27
  801dd2:	e8 aa fa ff ff       	call   801881 <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
}
  801dda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801de2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de5:	8b 45 08             	mov    0x8(%ebp),%eax
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	52                   	push   %edx
  801def:	50                   	push   %eax
  801df0:	6a 28                	push   $0x28
  801df2:	e8 8a fa ff ff       	call   801881 <syscall>
  801df7:	83 c4 18             	add    $0x18,%esp
}
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    

00801dfc <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801dff:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e05:	8b 45 08             	mov    0x8(%ebp),%eax
  801e08:	6a 00                	push   $0x0
  801e0a:	51                   	push   %ecx
  801e0b:	ff 75 10             	pushl  0x10(%ebp)
  801e0e:	52                   	push   %edx
  801e0f:	50                   	push   %eax
  801e10:	6a 29                	push   $0x29
  801e12:	e8 6a fa ff ff       	call   801881 <syscall>
  801e17:	83 c4 18             	add    $0x18,%esp
}
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	ff 75 10             	pushl  0x10(%ebp)
  801e26:	ff 75 0c             	pushl  0xc(%ebp)
  801e29:	ff 75 08             	pushl  0x8(%ebp)
  801e2c:	6a 12                	push   $0x12
  801e2e:	e8 4e fa ff ff       	call   801881 <syscall>
  801e33:	83 c4 18             	add    $0x18,%esp
	return ;
  801e36:	90                   	nop
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	52                   	push   %edx
  801e49:	50                   	push   %eax
  801e4a:	6a 2a                	push   $0x2a
  801e4c:	e8 30 fa ff ff       	call   801881 <syscall>
  801e51:	83 c4 18             	add    $0x18,%esp
	return;
  801e54:	90                   	nop
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	50                   	push   %eax
  801e66:	6a 2b                	push   $0x2b
  801e68:	e8 14 fa ff ff       	call   801881 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	ff 75 0c             	pushl  0xc(%ebp)
  801e7e:	ff 75 08             	pushl  0x8(%ebp)
  801e81:	6a 2c                	push   $0x2c
  801e83:	e8 f9 f9 ff ff       	call   801881 <syscall>
  801e88:	83 c4 18             	add    $0x18,%esp
	return;
  801e8b:	90                   	nop
}
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	ff 75 0c             	pushl  0xc(%ebp)
  801e9a:	ff 75 08             	pushl  0x8(%ebp)
  801e9d:	6a 2d                	push   $0x2d
  801e9f:	e8 dd f9 ff ff       	call   801881 <syscall>
  801ea4:	83 c4 18             	add    $0x18,%esp
	return;
  801ea7:	90                   	nop
}
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    

00801eaa <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
  801ead:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb3:	83 e8 04             	sub    $0x4,%eax
  801eb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801eb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ebc:	8b 00                	mov    (%eax),%eax
  801ebe:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
  801ec6:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecc:	83 e8 04             	sub    $0x4,%eax
  801ecf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ed5:	8b 00                	mov    (%eax),%eax
  801ed7:	83 e0 01             	and    $0x1,%eax
  801eda:	85 c0                	test   %eax,%eax
  801edc:	0f 94 c0             	sete   %al
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801ee7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef1:	83 f8 02             	cmp    $0x2,%eax
  801ef4:	74 2b                	je     801f21 <alloc_block+0x40>
  801ef6:	83 f8 02             	cmp    $0x2,%eax
  801ef9:	7f 07                	jg     801f02 <alloc_block+0x21>
  801efb:	83 f8 01             	cmp    $0x1,%eax
  801efe:	74 0e                	je     801f0e <alloc_block+0x2d>
  801f00:	eb 58                	jmp    801f5a <alloc_block+0x79>
  801f02:	83 f8 03             	cmp    $0x3,%eax
  801f05:	74 2d                	je     801f34 <alloc_block+0x53>
  801f07:	83 f8 04             	cmp    $0x4,%eax
  801f0a:	74 3b                	je     801f47 <alloc_block+0x66>
  801f0c:	eb 4c                	jmp    801f5a <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f0e:	83 ec 0c             	sub    $0xc,%esp
  801f11:	ff 75 08             	pushl  0x8(%ebp)
  801f14:	e8 11 03 00 00       	call   80222a <alloc_block_FF>
  801f19:	83 c4 10             	add    $0x10,%esp
  801f1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f1f:	eb 4a                	jmp    801f6b <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f21:	83 ec 0c             	sub    $0xc,%esp
  801f24:	ff 75 08             	pushl  0x8(%ebp)
  801f27:	e8 fa 19 00 00       	call   803926 <alloc_block_NF>
  801f2c:	83 c4 10             	add    $0x10,%esp
  801f2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f32:	eb 37                	jmp    801f6b <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f34:	83 ec 0c             	sub    $0xc,%esp
  801f37:	ff 75 08             	pushl  0x8(%ebp)
  801f3a:	e8 a7 07 00 00       	call   8026e6 <alloc_block_BF>
  801f3f:	83 c4 10             	add    $0x10,%esp
  801f42:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f45:	eb 24                	jmp    801f6b <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f47:	83 ec 0c             	sub    $0xc,%esp
  801f4a:	ff 75 08             	pushl  0x8(%ebp)
  801f4d:	e8 b7 19 00 00       	call   803909 <alloc_block_WF>
  801f52:	83 c4 10             	add    $0x10,%esp
  801f55:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f58:	eb 11                	jmp    801f6b <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f5a:	83 ec 0c             	sub    $0xc,%esp
  801f5d:	68 d4 46 80 00       	push   $0x8046d4
  801f62:	e8 10 e7 ff ff       	call   800677 <cprintf>
  801f67:	83 c4 10             	add    $0x10,%esp
		break;
  801f6a:	90                   	nop
	}
	return va;
  801f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	53                   	push   %ebx
  801f74:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801f77:	83 ec 0c             	sub    $0xc,%esp
  801f7a:	68 f4 46 80 00       	push   $0x8046f4
  801f7f:	e8 f3 e6 ff ff       	call   800677 <cprintf>
  801f84:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801f87:	83 ec 0c             	sub    $0xc,%esp
  801f8a:	68 1f 47 80 00       	push   $0x80471f
  801f8f:	e8 e3 e6 ff ff       	call   800677 <cprintf>
  801f94:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f9d:	eb 37                	jmp    801fd6 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801f9f:	83 ec 0c             	sub    $0xc,%esp
  801fa2:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa5:	e8 19 ff ff ff       	call   801ec3 <is_free_block>
  801faa:	83 c4 10             	add    $0x10,%esp
  801fad:	0f be d8             	movsbl %al,%ebx
  801fb0:	83 ec 0c             	sub    $0xc,%esp
  801fb3:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb6:	e8 ef fe ff ff       	call   801eaa <get_block_size>
  801fbb:	83 c4 10             	add    $0x10,%esp
  801fbe:	83 ec 04             	sub    $0x4,%esp
  801fc1:	53                   	push   %ebx
  801fc2:	50                   	push   %eax
  801fc3:	68 37 47 80 00       	push   $0x804737
  801fc8:	e8 aa e6 ff ff       	call   800677 <cprintf>
  801fcd:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fda:	74 07                	je     801fe3 <print_blocks_list+0x73>
  801fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdf:	8b 00                	mov    (%eax),%eax
  801fe1:	eb 05                	jmp    801fe8 <print_blocks_list+0x78>
  801fe3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe8:	89 45 10             	mov    %eax,0x10(%ebp)
  801feb:	8b 45 10             	mov    0x10(%ebp),%eax
  801fee:	85 c0                	test   %eax,%eax
  801ff0:	75 ad                	jne    801f9f <print_blocks_list+0x2f>
  801ff2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff6:	75 a7                	jne    801f9f <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801ff8:	83 ec 0c             	sub    $0xc,%esp
  801ffb:	68 f4 46 80 00       	push   $0x8046f4
  802000:	e8 72 e6 ff ff       	call   800677 <cprintf>
  802005:	83 c4 10             	add    $0x10,%esp

}
  802008:	90                   	nop
  802009:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80200c:	c9                   	leave  
  80200d:	c3                   	ret    

0080200e <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802014:	8b 45 0c             	mov    0xc(%ebp),%eax
  802017:	83 e0 01             	and    $0x1,%eax
  80201a:	85 c0                	test   %eax,%eax
  80201c:	74 03                	je     802021 <initialize_dynamic_allocator+0x13>
  80201e:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802021:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802025:	0f 84 c7 01 00 00    	je     8021f2 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80202b:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802032:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802035:	8b 55 08             	mov    0x8(%ebp),%edx
  802038:	8b 45 0c             	mov    0xc(%ebp),%eax
  80203b:	01 d0                	add    %edx,%eax
  80203d:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802042:	0f 87 ad 01 00 00    	ja     8021f5 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802048:	8b 45 08             	mov    0x8(%ebp),%eax
  80204b:	85 c0                	test   %eax,%eax
  80204d:	0f 89 a5 01 00 00    	jns    8021f8 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802053:	8b 55 08             	mov    0x8(%ebp),%edx
  802056:	8b 45 0c             	mov    0xc(%ebp),%eax
  802059:	01 d0                	add    %edx,%eax
  80205b:	83 e8 04             	sub    $0x4,%eax
  80205e:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802063:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80206a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80206f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802072:	e9 87 00 00 00       	jmp    8020fe <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802077:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80207b:	75 14                	jne    802091 <initialize_dynamic_allocator+0x83>
  80207d:	83 ec 04             	sub    $0x4,%esp
  802080:	68 4f 47 80 00       	push   $0x80474f
  802085:	6a 79                	push   $0x79
  802087:	68 6d 47 80 00       	push   $0x80476d
  80208c:	e8 29 e3 ff ff       	call   8003ba <_panic>
  802091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802094:	8b 00                	mov    (%eax),%eax
  802096:	85 c0                	test   %eax,%eax
  802098:	74 10                	je     8020aa <initialize_dynamic_allocator+0x9c>
  80209a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209d:	8b 00                	mov    (%eax),%eax
  80209f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a2:	8b 52 04             	mov    0x4(%edx),%edx
  8020a5:	89 50 04             	mov    %edx,0x4(%eax)
  8020a8:	eb 0b                	jmp    8020b5 <initialize_dynamic_allocator+0xa7>
  8020aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ad:	8b 40 04             	mov    0x4(%eax),%eax
  8020b0:	a3 30 50 80 00       	mov    %eax,0x805030
  8020b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b8:	8b 40 04             	mov    0x4(%eax),%eax
  8020bb:	85 c0                	test   %eax,%eax
  8020bd:	74 0f                	je     8020ce <initialize_dynamic_allocator+0xc0>
  8020bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c2:	8b 40 04             	mov    0x4(%eax),%eax
  8020c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c8:	8b 12                	mov    (%edx),%edx
  8020ca:	89 10                	mov    %edx,(%eax)
  8020cc:	eb 0a                	jmp    8020d8 <initialize_dynamic_allocator+0xca>
  8020ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d1:	8b 00                	mov    (%eax),%eax
  8020d3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020eb:	a1 38 50 80 00       	mov    0x805038,%eax
  8020f0:	48                   	dec    %eax
  8020f1:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8020f6:	a1 34 50 80 00       	mov    0x805034,%eax
  8020fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802102:	74 07                	je     80210b <initialize_dynamic_allocator+0xfd>
  802104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802107:	8b 00                	mov    (%eax),%eax
  802109:	eb 05                	jmp    802110 <initialize_dynamic_allocator+0x102>
  80210b:	b8 00 00 00 00       	mov    $0x0,%eax
  802110:	a3 34 50 80 00       	mov    %eax,0x805034
  802115:	a1 34 50 80 00       	mov    0x805034,%eax
  80211a:	85 c0                	test   %eax,%eax
  80211c:	0f 85 55 ff ff ff    	jne    802077 <initialize_dynamic_allocator+0x69>
  802122:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802126:	0f 85 4b ff ff ff    	jne    802077 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80212c:	8b 45 08             	mov    0x8(%ebp),%eax
  80212f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802132:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802135:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80213b:	a1 44 50 80 00       	mov    0x805044,%eax
  802140:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802145:	a1 40 50 80 00       	mov    0x805040,%eax
  80214a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802150:	8b 45 08             	mov    0x8(%ebp),%eax
  802153:	83 c0 08             	add    $0x8,%eax
  802156:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	83 c0 04             	add    $0x4,%eax
  80215f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802162:	83 ea 08             	sub    $0x8,%edx
  802165:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802167:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216a:	8b 45 08             	mov    0x8(%ebp),%eax
  80216d:	01 d0                	add    %edx,%eax
  80216f:	83 e8 08             	sub    $0x8,%eax
  802172:	8b 55 0c             	mov    0xc(%ebp),%edx
  802175:	83 ea 08             	sub    $0x8,%edx
  802178:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80217a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80217d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802183:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802186:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80218d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802191:	75 17                	jne    8021aa <initialize_dynamic_allocator+0x19c>
  802193:	83 ec 04             	sub    $0x4,%esp
  802196:	68 88 47 80 00       	push   $0x804788
  80219b:	68 90 00 00 00       	push   $0x90
  8021a0:	68 6d 47 80 00       	push   $0x80476d
  8021a5:	e8 10 e2 ff ff       	call   8003ba <_panic>
  8021aa:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8021b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b3:	89 10                	mov    %edx,(%eax)
  8021b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b8:	8b 00                	mov    (%eax),%eax
  8021ba:	85 c0                	test   %eax,%eax
  8021bc:	74 0d                	je     8021cb <initialize_dynamic_allocator+0x1bd>
  8021be:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021c3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021c6:	89 50 04             	mov    %edx,0x4(%eax)
  8021c9:	eb 08                	jmp    8021d3 <initialize_dynamic_allocator+0x1c5>
  8021cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ce:	a3 30 50 80 00       	mov    %eax,0x805030
  8021d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021e5:	a1 38 50 80 00       	mov    0x805038,%eax
  8021ea:	40                   	inc    %eax
  8021eb:	a3 38 50 80 00       	mov    %eax,0x805038
  8021f0:	eb 07                	jmp    8021f9 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8021f2:	90                   	nop
  8021f3:	eb 04                	jmp    8021f9 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8021f5:	90                   	nop
  8021f6:	eb 01                	jmp    8021f9 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8021f8:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    

008021fb <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8021fe:	8b 45 10             	mov    0x10(%ebp),%eax
  802201:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802204:	8b 45 08             	mov    0x8(%ebp),%eax
  802207:	8d 50 fc             	lea    -0x4(%eax),%edx
  80220a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220d:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80220f:	8b 45 08             	mov    0x8(%ebp),%eax
  802212:	83 e8 04             	sub    $0x4,%eax
  802215:	8b 00                	mov    (%eax),%eax
  802217:	83 e0 fe             	and    $0xfffffffe,%eax
  80221a:	8d 50 f8             	lea    -0x8(%eax),%edx
  80221d:	8b 45 08             	mov    0x8(%ebp),%eax
  802220:	01 c2                	add    %eax,%edx
  802222:	8b 45 0c             	mov    0xc(%ebp),%eax
  802225:	89 02                	mov    %eax,(%edx)
}
  802227:	90                   	nop
  802228:	5d                   	pop    %ebp
  802229:	c3                   	ret    

0080222a <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
  80222d:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802230:	8b 45 08             	mov    0x8(%ebp),%eax
  802233:	83 e0 01             	and    $0x1,%eax
  802236:	85 c0                	test   %eax,%eax
  802238:	74 03                	je     80223d <alloc_block_FF+0x13>
  80223a:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80223d:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802241:	77 07                	ja     80224a <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802243:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80224a:	a1 24 50 80 00       	mov    0x805024,%eax
  80224f:	85 c0                	test   %eax,%eax
  802251:	75 73                	jne    8022c6 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	83 c0 10             	add    $0x10,%eax
  802259:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80225c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802263:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802266:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802269:	01 d0                	add    %edx,%eax
  80226b:	48                   	dec    %eax
  80226c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80226f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802272:	ba 00 00 00 00       	mov    $0x0,%edx
  802277:	f7 75 ec             	divl   -0x14(%ebp)
  80227a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80227d:	29 d0                	sub    %edx,%eax
  80227f:	c1 e8 0c             	shr    $0xc,%eax
  802282:	83 ec 0c             	sub    $0xc,%esp
  802285:	50                   	push   %eax
  802286:	e8 86 f1 ff ff       	call   801411 <sbrk>
  80228b:	83 c4 10             	add    $0x10,%esp
  80228e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802291:	83 ec 0c             	sub    $0xc,%esp
  802294:	6a 00                	push   $0x0
  802296:	e8 76 f1 ff ff       	call   801411 <sbrk>
  80229b:	83 c4 10             	add    $0x10,%esp
  80229e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8022a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022a4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8022a7:	83 ec 08             	sub    $0x8,%esp
  8022aa:	50                   	push   %eax
  8022ab:	ff 75 e4             	pushl  -0x1c(%ebp)
  8022ae:	e8 5b fd ff ff       	call   80200e <initialize_dynamic_allocator>
  8022b3:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8022b6:	83 ec 0c             	sub    $0xc,%esp
  8022b9:	68 ab 47 80 00       	push   $0x8047ab
  8022be:	e8 b4 e3 ff ff       	call   800677 <cprintf>
  8022c3:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8022c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022ca:	75 0a                	jne    8022d6 <alloc_block_FF+0xac>
	        return NULL;
  8022cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d1:	e9 0e 04 00 00       	jmp    8026e4 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8022d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8022dd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e5:	e9 f3 02 00 00       	jmp    8025dd <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ed:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8022f0:	83 ec 0c             	sub    $0xc,%esp
  8022f3:	ff 75 bc             	pushl  -0x44(%ebp)
  8022f6:	e8 af fb ff ff       	call   801eaa <get_block_size>
  8022fb:	83 c4 10             	add    $0x10,%esp
  8022fe:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802301:	8b 45 08             	mov    0x8(%ebp),%eax
  802304:	83 c0 08             	add    $0x8,%eax
  802307:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80230a:	0f 87 c5 02 00 00    	ja     8025d5 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802310:	8b 45 08             	mov    0x8(%ebp),%eax
  802313:	83 c0 18             	add    $0x18,%eax
  802316:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802319:	0f 87 19 02 00 00    	ja     802538 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80231f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802322:	2b 45 08             	sub    0x8(%ebp),%eax
  802325:	83 e8 08             	sub    $0x8,%eax
  802328:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80232b:	8b 45 08             	mov    0x8(%ebp),%eax
  80232e:	8d 50 08             	lea    0x8(%eax),%edx
  802331:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802334:	01 d0                	add    %edx,%eax
  802336:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802339:	8b 45 08             	mov    0x8(%ebp),%eax
  80233c:	83 c0 08             	add    $0x8,%eax
  80233f:	83 ec 04             	sub    $0x4,%esp
  802342:	6a 01                	push   $0x1
  802344:	50                   	push   %eax
  802345:	ff 75 bc             	pushl  -0x44(%ebp)
  802348:	e8 ae fe ff ff       	call   8021fb <set_block_data>
  80234d:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802353:	8b 40 04             	mov    0x4(%eax),%eax
  802356:	85 c0                	test   %eax,%eax
  802358:	75 68                	jne    8023c2 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80235a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80235e:	75 17                	jne    802377 <alloc_block_FF+0x14d>
  802360:	83 ec 04             	sub    $0x4,%esp
  802363:	68 88 47 80 00       	push   $0x804788
  802368:	68 d7 00 00 00       	push   $0xd7
  80236d:	68 6d 47 80 00       	push   $0x80476d
  802372:	e8 43 e0 ff ff       	call   8003ba <_panic>
  802377:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80237d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802380:	89 10                	mov    %edx,(%eax)
  802382:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802385:	8b 00                	mov    (%eax),%eax
  802387:	85 c0                	test   %eax,%eax
  802389:	74 0d                	je     802398 <alloc_block_FF+0x16e>
  80238b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802390:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802393:	89 50 04             	mov    %edx,0x4(%eax)
  802396:	eb 08                	jmp    8023a0 <alloc_block_FF+0x176>
  802398:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80239b:	a3 30 50 80 00       	mov    %eax,0x805030
  8023a0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023a3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023a8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023b2:	a1 38 50 80 00       	mov    0x805038,%eax
  8023b7:	40                   	inc    %eax
  8023b8:	a3 38 50 80 00       	mov    %eax,0x805038
  8023bd:	e9 dc 00 00 00       	jmp    80249e <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8023c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c5:	8b 00                	mov    (%eax),%eax
  8023c7:	85 c0                	test   %eax,%eax
  8023c9:	75 65                	jne    802430 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023cb:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023cf:	75 17                	jne    8023e8 <alloc_block_FF+0x1be>
  8023d1:	83 ec 04             	sub    $0x4,%esp
  8023d4:	68 bc 47 80 00       	push   $0x8047bc
  8023d9:	68 db 00 00 00       	push   $0xdb
  8023de:	68 6d 47 80 00       	push   $0x80476d
  8023e3:	e8 d2 df ff ff       	call   8003ba <_panic>
  8023e8:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8023ee:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023f1:	89 50 04             	mov    %edx,0x4(%eax)
  8023f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023f7:	8b 40 04             	mov    0x4(%eax),%eax
  8023fa:	85 c0                	test   %eax,%eax
  8023fc:	74 0c                	je     80240a <alloc_block_FF+0x1e0>
  8023fe:	a1 30 50 80 00       	mov    0x805030,%eax
  802403:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802406:	89 10                	mov    %edx,(%eax)
  802408:	eb 08                	jmp    802412 <alloc_block_FF+0x1e8>
  80240a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80240d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802412:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802415:	a3 30 50 80 00       	mov    %eax,0x805030
  80241a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80241d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802423:	a1 38 50 80 00       	mov    0x805038,%eax
  802428:	40                   	inc    %eax
  802429:	a3 38 50 80 00       	mov    %eax,0x805038
  80242e:	eb 6e                	jmp    80249e <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802430:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802434:	74 06                	je     80243c <alloc_block_FF+0x212>
  802436:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80243a:	75 17                	jne    802453 <alloc_block_FF+0x229>
  80243c:	83 ec 04             	sub    $0x4,%esp
  80243f:	68 e0 47 80 00       	push   $0x8047e0
  802444:	68 df 00 00 00       	push   $0xdf
  802449:	68 6d 47 80 00       	push   $0x80476d
  80244e:	e8 67 df ff ff       	call   8003ba <_panic>
  802453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802456:	8b 10                	mov    (%eax),%edx
  802458:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80245b:	89 10                	mov    %edx,(%eax)
  80245d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802460:	8b 00                	mov    (%eax),%eax
  802462:	85 c0                	test   %eax,%eax
  802464:	74 0b                	je     802471 <alloc_block_FF+0x247>
  802466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802469:	8b 00                	mov    (%eax),%eax
  80246b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80246e:	89 50 04             	mov    %edx,0x4(%eax)
  802471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802474:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802477:	89 10                	mov    %edx,(%eax)
  802479:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80247c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247f:	89 50 04             	mov    %edx,0x4(%eax)
  802482:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802485:	8b 00                	mov    (%eax),%eax
  802487:	85 c0                	test   %eax,%eax
  802489:	75 08                	jne    802493 <alloc_block_FF+0x269>
  80248b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80248e:	a3 30 50 80 00       	mov    %eax,0x805030
  802493:	a1 38 50 80 00       	mov    0x805038,%eax
  802498:	40                   	inc    %eax
  802499:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80249e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a2:	75 17                	jne    8024bb <alloc_block_FF+0x291>
  8024a4:	83 ec 04             	sub    $0x4,%esp
  8024a7:	68 4f 47 80 00       	push   $0x80474f
  8024ac:	68 e1 00 00 00       	push   $0xe1
  8024b1:	68 6d 47 80 00       	push   $0x80476d
  8024b6:	e8 ff de ff ff       	call   8003ba <_panic>
  8024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024be:	8b 00                	mov    (%eax),%eax
  8024c0:	85 c0                	test   %eax,%eax
  8024c2:	74 10                	je     8024d4 <alloc_block_FF+0x2aa>
  8024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c7:	8b 00                	mov    (%eax),%eax
  8024c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024cc:	8b 52 04             	mov    0x4(%edx),%edx
  8024cf:	89 50 04             	mov    %edx,0x4(%eax)
  8024d2:	eb 0b                	jmp    8024df <alloc_block_FF+0x2b5>
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	8b 40 04             	mov    0x4(%eax),%eax
  8024da:	a3 30 50 80 00       	mov    %eax,0x805030
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	8b 40 04             	mov    0x4(%eax),%eax
  8024e5:	85 c0                	test   %eax,%eax
  8024e7:	74 0f                	je     8024f8 <alloc_block_FF+0x2ce>
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	8b 40 04             	mov    0x4(%eax),%eax
  8024ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f2:	8b 12                	mov    (%edx),%edx
  8024f4:	89 10                	mov    %edx,(%eax)
  8024f6:	eb 0a                	jmp    802502 <alloc_block_FF+0x2d8>
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	8b 00                	mov    (%eax),%eax
  8024fd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802505:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80250b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802515:	a1 38 50 80 00       	mov    0x805038,%eax
  80251a:	48                   	dec    %eax
  80251b:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802520:	83 ec 04             	sub    $0x4,%esp
  802523:	6a 00                	push   $0x0
  802525:	ff 75 b4             	pushl  -0x4c(%ebp)
  802528:	ff 75 b0             	pushl  -0x50(%ebp)
  80252b:	e8 cb fc ff ff       	call   8021fb <set_block_data>
  802530:	83 c4 10             	add    $0x10,%esp
  802533:	e9 95 00 00 00       	jmp    8025cd <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802538:	83 ec 04             	sub    $0x4,%esp
  80253b:	6a 01                	push   $0x1
  80253d:	ff 75 b8             	pushl  -0x48(%ebp)
  802540:	ff 75 bc             	pushl  -0x44(%ebp)
  802543:	e8 b3 fc ff ff       	call   8021fb <set_block_data>
  802548:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80254b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254f:	75 17                	jne    802568 <alloc_block_FF+0x33e>
  802551:	83 ec 04             	sub    $0x4,%esp
  802554:	68 4f 47 80 00       	push   $0x80474f
  802559:	68 e8 00 00 00       	push   $0xe8
  80255e:	68 6d 47 80 00       	push   $0x80476d
  802563:	e8 52 de ff ff       	call   8003ba <_panic>
  802568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256b:	8b 00                	mov    (%eax),%eax
  80256d:	85 c0                	test   %eax,%eax
  80256f:	74 10                	je     802581 <alloc_block_FF+0x357>
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	8b 00                	mov    (%eax),%eax
  802576:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802579:	8b 52 04             	mov    0x4(%edx),%edx
  80257c:	89 50 04             	mov    %edx,0x4(%eax)
  80257f:	eb 0b                	jmp    80258c <alloc_block_FF+0x362>
  802581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802584:	8b 40 04             	mov    0x4(%eax),%eax
  802587:	a3 30 50 80 00       	mov    %eax,0x805030
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	8b 40 04             	mov    0x4(%eax),%eax
  802592:	85 c0                	test   %eax,%eax
  802594:	74 0f                	je     8025a5 <alloc_block_FF+0x37b>
  802596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802599:	8b 40 04             	mov    0x4(%eax),%eax
  80259c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259f:	8b 12                	mov    (%edx),%edx
  8025a1:	89 10                	mov    %edx,(%eax)
  8025a3:	eb 0a                	jmp    8025af <alloc_block_FF+0x385>
  8025a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a8:	8b 00                	mov    (%eax),%eax
  8025aa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c2:	a1 38 50 80 00       	mov    0x805038,%eax
  8025c7:	48                   	dec    %eax
  8025c8:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8025cd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8025d0:	e9 0f 01 00 00       	jmp    8026e4 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8025d5:	a1 34 50 80 00       	mov    0x805034,%eax
  8025da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e1:	74 07                	je     8025ea <alloc_block_FF+0x3c0>
  8025e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e6:	8b 00                	mov    (%eax),%eax
  8025e8:	eb 05                	jmp    8025ef <alloc_block_FF+0x3c5>
  8025ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ef:	a3 34 50 80 00       	mov    %eax,0x805034
  8025f4:	a1 34 50 80 00       	mov    0x805034,%eax
  8025f9:	85 c0                	test   %eax,%eax
  8025fb:	0f 85 e9 fc ff ff    	jne    8022ea <alloc_block_FF+0xc0>
  802601:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802605:	0f 85 df fc ff ff    	jne    8022ea <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80260b:	8b 45 08             	mov    0x8(%ebp),%eax
  80260e:	83 c0 08             	add    $0x8,%eax
  802611:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802614:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80261b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80261e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802621:	01 d0                	add    %edx,%eax
  802623:	48                   	dec    %eax
  802624:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802627:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80262a:	ba 00 00 00 00       	mov    $0x0,%edx
  80262f:	f7 75 d8             	divl   -0x28(%ebp)
  802632:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802635:	29 d0                	sub    %edx,%eax
  802637:	c1 e8 0c             	shr    $0xc,%eax
  80263a:	83 ec 0c             	sub    $0xc,%esp
  80263d:	50                   	push   %eax
  80263e:	e8 ce ed ff ff       	call   801411 <sbrk>
  802643:	83 c4 10             	add    $0x10,%esp
  802646:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802649:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80264d:	75 0a                	jne    802659 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80264f:	b8 00 00 00 00       	mov    $0x0,%eax
  802654:	e9 8b 00 00 00       	jmp    8026e4 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802659:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802660:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802663:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802666:	01 d0                	add    %edx,%eax
  802668:	48                   	dec    %eax
  802669:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80266c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80266f:	ba 00 00 00 00       	mov    $0x0,%edx
  802674:	f7 75 cc             	divl   -0x34(%ebp)
  802677:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80267a:	29 d0                	sub    %edx,%eax
  80267c:	8d 50 fc             	lea    -0x4(%eax),%edx
  80267f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802682:	01 d0                	add    %edx,%eax
  802684:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802689:	a1 40 50 80 00       	mov    0x805040,%eax
  80268e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802694:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80269b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80269e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8026a1:	01 d0                	add    %edx,%eax
  8026a3:	48                   	dec    %eax
  8026a4:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8026a7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8026af:	f7 75 c4             	divl   -0x3c(%ebp)
  8026b2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026b5:	29 d0                	sub    %edx,%eax
  8026b7:	83 ec 04             	sub    $0x4,%esp
  8026ba:	6a 01                	push   $0x1
  8026bc:	50                   	push   %eax
  8026bd:	ff 75 d0             	pushl  -0x30(%ebp)
  8026c0:	e8 36 fb ff ff       	call   8021fb <set_block_data>
  8026c5:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8026c8:	83 ec 0c             	sub    $0xc,%esp
  8026cb:	ff 75 d0             	pushl  -0x30(%ebp)
  8026ce:	e8 1b 0a 00 00       	call   8030ee <free_block>
  8026d3:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8026d6:	83 ec 0c             	sub    $0xc,%esp
  8026d9:	ff 75 08             	pushl  0x8(%ebp)
  8026dc:	e8 49 fb ff ff       	call   80222a <alloc_block_FF>
  8026e1:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8026e4:	c9                   	leave  
  8026e5:	c3                   	ret    

008026e6 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8026e6:	55                   	push   %ebp
  8026e7:	89 e5                	mov    %esp,%ebp
  8026e9:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8026ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ef:	83 e0 01             	and    $0x1,%eax
  8026f2:	85 c0                	test   %eax,%eax
  8026f4:	74 03                	je     8026f9 <alloc_block_BF+0x13>
  8026f6:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8026f9:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8026fd:	77 07                	ja     802706 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8026ff:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802706:	a1 24 50 80 00       	mov    0x805024,%eax
  80270b:	85 c0                	test   %eax,%eax
  80270d:	75 73                	jne    802782 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80270f:	8b 45 08             	mov    0x8(%ebp),%eax
  802712:	83 c0 10             	add    $0x10,%eax
  802715:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802718:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80271f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802722:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802725:	01 d0                	add    %edx,%eax
  802727:	48                   	dec    %eax
  802728:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80272b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80272e:	ba 00 00 00 00       	mov    $0x0,%edx
  802733:	f7 75 e0             	divl   -0x20(%ebp)
  802736:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802739:	29 d0                	sub    %edx,%eax
  80273b:	c1 e8 0c             	shr    $0xc,%eax
  80273e:	83 ec 0c             	sub    $0xc,%esp
  802741:	50                   	push   %eax
  802742:	e8 ca ec ff ff       	call   801411 <sbrk>
  802747:	83 c4 10             	add    $0x10,%esp
  80274a:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80274d:	83 ec 0c             	sub    $0xc,%esp
  802750:	6a 00                	push   $0x0
  802752:	e8 ba ec ff ff       	call   801411 <sbrk>
  802757:	83 c4 10             	add    $0x10,%esp
  80275a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80275d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802760:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802763:	83 ec 08             	sub    $0x8,%esp
  802766:	50                   	push   %eax
  802767:	ff 75 d8             	pushl  -0x28(%ebp)
  80276a:	e8 9f f8 ff ff       	call   80200e <initialize_dynamic_allocator>
  80276f:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802772:	83 ec 0c             	sub    $0xc,%esp
  802775:	68 ab 47 80 00       	push   $0x8047ab
  80277a:	e8 f8 de ff ff       	call   800677 <cprintf>
  80277f:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802782:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802789:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802790:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802797:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80279e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a6:	e9 1d 01 00 00       	jmp    8028c8 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8027b1:	83 ec 0c             	sub    $0xc,%esp
  8027b4:	ff 75 a8             	pushl  -0x58(%ebp)
  8027b7:	e8 ee f6 ff ff       	call   801eaa <get_block_size>
  8027bc:	83 c4 10             	add    $0x10,%esp
  8027bf:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8027c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c5:	83 c0 08             	add    $0x8,%eax
  8027c8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027cb:	0f 87 ef 00 00 00    	ja     8028c0 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8027d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d4:	83 c0 18             	add    $0x18,%eax
  8027d7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027da:	77 1d                	ja     8027f9 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8027dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027df:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027e2:	0f 86 d8 00 00 00    	jbe    8028c0 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8027e8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8027ee:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8027f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8027f4:	e9 c7 00 00 00       	jmp    8028c0 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8027f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fc:	83 c0 08             	add    $0x8,%eax
  8027ff:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802802:	0f 85 9d 00 00 00    	jne    8028a5 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802808:	83 ec 04             	sub    $0x4,%esp
  80280b:	6a 01                	push   $0x1
  80280d:	ff 75 a4             	pushl  -0x5c(%ebp)
  802810:	ff 75 a8             	pushl  -0x58(%ebp)
  802813:	e8 e3 f9 ff ff       	call   8021fb <set_block_data>
  802818:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80281b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281f:	75 17                	jne    802838 <alloc_block_BF+0x152>
  802821:	83 ec 04             	sub    $0x4,%esp
  802824:	68 4f 47 80 00       	push   $0x80474f
  802829:	68 2c 01 00 00       	push   $0x12c
  80282e:	68 6d 47 80 00       	push   $0x80476d
  802833:	e8 82 db ff ff       	call   8003ba <_panic>
  802838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283b:	8b 00                	mov    (%eax),%eax
  80283d:	85 c0                	test   %eax,%eax
  80283f:	74 10                	je     802851 <alloc_block_BF+0x16b>
  802841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802844:	8b 00                	mov    (%eax),%eax
  802846:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802849:	8b 52 04             	mov    0x4(%edx),%edx
  80284c:	89 50 04             	mov    %edx,0x4(%eax)
  80284f:	eb 0b                	jmp    80285c <alloc_block_BF+0x176>
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	8b 40 04             	mov    0x4(%eax),%eax
  802857:	a3 30 50 80 00       	mov    %eax,0x805030
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	8b 40 04             	mov    0x4(%eax),%eax
  802862:	85 c0                	test   %eax,%eax
  802864:	74 0f                	je     802875 <alloc_block_BF+0x18f>
  802866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802869:	8b 40 04             	mov    0x4(%eax),%eax
  80286c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80286f:	8b 12                	mov    (%edx),%edx
  802871:	89 10                	mov    %edx,(%eax)
  802873:	eb 0a                	jmp    80287f <alloc_block_BF+0x199>
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	8b 00                	mov    (%eax),%eax
  80287a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802892:	a1 38 50 80 00       	mov    0x805038,%eax
  802897:	48                   	dec    %eax
  802898:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80289d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028a0:	e9 24 04 00 00       	jmp    802cc9 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8028a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028ab:	76 13                	jbe    8028c0 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8028ad:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8028b4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8028ba:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028bd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8028c0:	a1 34 50 80 00       	mov    0x805034,%eax
  8028c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028cc:	74 07                	je     8028d5 <alloc_block_BF+0x1ef>
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	8b 00                	mov    (%eax),%eax
  8028d3:	eb 05                	jmp    8028da <alloc_block_BF+0x1f4>
  8028d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8028da:	a3 34 50 80 00       	mov    %eax,0x805034
  8028df:	a1 34 50 80 00       	mov    0x805034,%eax
  8028e4:	85 c0                	test   %eax,%eax
  8028e6:	0f 85 bf fe ff ff    	jne    8027ab <alloc_block_BF+0xc5>
  8028ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f0:	0f 85 b5 fe ff ff    	jne    8027ab <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8028f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028fa:	0f 84 26 02 00 00    	je     802b26 <alloc_block_BF+0x440>
  802900:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802904:	0f 85 1c 02 00 00    	jne    802b26 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80290a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290d:	2b 45 08             	sub    0x8(%ebp),%eax
  802910:	83 e8 08             	sub    $0x8,%eax
  802913:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802916:	8b 45 08             	mov    0x8(%ebp),%eax
  802919:	8d 50 08             	lea    0x8(%eax),%edx
  80291c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291f:	01 d0                	add    %edx,%eax
  802921:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802924:	8b 45 08             	mov    0x8(%ebp),%eax
  802927:	83 c0 08             	add    $0x8,%eax
  80292a:	83 ec 04             	sub    $0x4,%esp
  80292d:	6a 01                	push   $0x1
  80292f:	50                   	push   %eax
  802930:	ff 75 f0             	pushl  -0x10(%ebp)
  802933:	e8 c3 f8 ff ff       	call   8021fb <set_block_data>
  802938:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80293b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293e:	8b 40 04             	mov    0x4(%eax),%eax
  802941:	85 c0                	test   %eax,%eax
  802943:	75 68                	jne    8029ad <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802945:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802949:	75 17                	jne    802962 <alloc_block_BF+0x27c>
  80294b:	83 ec 04             	sub    $0x4,%esp
  80294e:	68 88 47 80 00       	push   $0x804788
  802953:	68 45 01 00 00       	push   $0x145
  802958:	68 6d 47 80 00       	push   $0x80476d
  80295d:	e8 58 da ff ff       	call   8003ba <_panic>
  802962:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802968:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80296b:	89 10                	mov    %edx,(%eax)
  80296d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802970:	8b 00                	mov    (%eax),%eax
  802972:	85 c0                	test   %eax,%eax
  802974:	74 0d                	je     802983 <alloc_block_BF+0x29d>
  802976:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80297b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80297e:	89 50 04             	mov    %edx,0x4(%eax)
  802981:	eb 08                	jmp    80298b <alloc_block_BF+0x2a5>
  802983:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802986:	a3 30 50 80 00       	mov    %eax,0x805030
  80298b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80298e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802993:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802996:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80299d:	a1 38 50 80 00       	mov    0x805038,%eax
  8029a2:	40                   	inc    %eax
  8029a3:	a3 38 50 80 00       	mov    %eax,0x805038
  8029a8:	e9 dc 00 00 00       	jmp    802a89 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8029ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b0:	8b 00                	mov    (%eax),%eax
  8029b2:	85 c0                	test   %eax,%eax
  8029b4:	75 65                	jne    802a1b <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029b6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029ba:	75 17                	jne    8029d3 <alloc_block_BF+0x2ed>
  8029bc:	83 ec 04             	sub    $0x4,%esp
  8029bf:	68 bc 47 80 00       	push   $0x8047bc
  8029c4:	68 4a 01 00 00       	push   $0x14a
  8029c9:	68 6d 47 80 00       	push   $0x80476d
  8029ce:	e8 e7 d9 ff ff       	call   8003ba <_panic>
  8029d3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8029d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029dc:	89 50 04             	mov    %edx,0x4(%eax)
  8029df:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029e2:	8b 40 04             	mov    0x4(%eax),%eax
  8029e5:	85 c0                	test   %eax,%eax
  8029e7:	74 0c                	je     8029f5 <alloc_block_BF+0x30f>
  8029e9:	a1 30 50 80 00       	mov    0x805030,%eax
  8029ee:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029f1:	89 10                	mov    %edx,(%eax)
  8029f3:	eb 08                	jmp    8029fd <alloc_block_BF+0x317>
  8029f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029f8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029fd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a00:	a3 30 50 80 00       	mov    %eax,0x805030
  802a05:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a0e:	a1 38 50 80 00       	mov    0x805038,%eax
  802a13:	40                   	inc    %eax
  802a14:	a3 38 50 80 00       	mov    %eax,0x805038
  802a19:	eb 6e                	jmp    802a89 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802a1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a1f:	74 06                	je     802a27 <alloc_block_BF+0x341>
  802a21:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a25:	75 17                	jne    802a3e <alloc_block_BF+0x358>
  802a27:	83 ec 04             	sub    $0x4,%esp
  802a2a:	68 e0 47 80 00       	push   $0x8047e0
  802a2f:	68 4f 01 00 00       	push   $0x14f
  802a34:	68 6d 47 80 00       	push   $0x80476d
  802a39:	e8 7c d9 ff ff       	call   8003ba <_panic>
  802a3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a41:	8b 10                	mov    (%eax),%edx
  802a43:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a46:	89 10                	mov    %edx,(%eax)
  802a48:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a4b:	8b 00                	mov    (%eax),%eax
  802a4d:	85 c0                	test   %eax,%eax
  802a4f:	74 0b                	je     802a5c <alloc_block_BF+0x376>
  802a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a54:	8b 00                	mov    (%eax),%eax
  802a56:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a59:	89 50 04             	mov    %edx,0x4(%eax)
  802a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a62:	89 10                	mov    %edx,(%eax)
  802a64:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a67:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a6a:	89 50 04             	mov    %edx,0x4(%eax)
  802a6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a70:	8b 00                	mov    (%eax),%eax
  802a72:	85 c0                	test   %eax,%eax
  802a74:	75 08                	jne    802a7e <alloc_block_BF+0x398>
  802a76:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a79:	a3 30 50 80 00       	mov    %eax,0x805030
  802a7e:	a1 38 50 80 00       	mov    0x805038,%eax
  802a83:	40                   	inc    %eax
  802a84:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802a89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a8d:	75 17                	jne    802aa6 <alloc_block_BF+0x3c0>
  802a8f:	83 ec 04             	sub    $0x4,%esp
  802a92:	68 4f 47 80 00       	push   $0x80474f
  802a97:	68 51 01 00 00       	push   $0x151
  802a9c:	68 6d 47 80 00       	push   $0x80476d
  802aa1:	e8 14 d9 ff ff       	call   8003ba <_panic>
  802aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa9:	8b 00                	mov    (%eax),%eax
  802aab:	85 c0                	test   %eax,%eax
  802aad:	74 10                	je     802abf <alloc_block_BF+0x3d9>
  802aaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab2:	8b 00                	mov    (%eax),%eax
  802ab4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ab7:	8b 52 04             	mov    0x4(%edx),%edx
  802aba:	89 50 04             	mov    %edx,0x4(%eax)
  802abd:	eb 0b                	jmp    802aca <alloc_block_BF+0x3e4>
  802abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac2:	8b 40 04             	mov    0x4(%eax),%eax
  802ac5:	a3 30 50 80 00       	mov    %eax,0x805030
  802aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acd:	8b 40 04             	mov    0x4(%eax),%eax
  802ad0:	85 c0                	test   %eax,%eax
  802ad2:	74 0f                	je     802ae3 <alloc_block_BF+0x3fd>
  802ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad7:	8b 40 04             	mov    0x4(%eax),%eax
  802ada:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802add:	8b 12                	mov    (%edx),%edx
  802adf:	89 10                	mov    %edx,(%eax)
  802ae1:	eb 0a                	jmp    802aed <alloc_block_BF+0x407>
  802ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae6:	8b 00                	mov    (%eax),%eax
  802ae8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b00:	a1 38 50 80 00       	mov    0x805038,%eax
  802b05:	48                   	dec    %eax
  802b06:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802b0b:	83 ec 04             	sub    $0x4,%esp
  802b0e:	6a 00                	push   $0x0
  802b10:	ff 75 d0             	pushl  -0x30(%ebp)
  802b13:	ff 75 cc             	pushl  -0x34(%ebp)
  802b16:	e8 e0 f6 ff ff       	call   8021fb <set_block_data>
  802b1b:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b21:	e9 a3 01 00 00       	jmp    802cc9 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802b26:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802b2a:	0f 85 9d 00 00 00    	jne    802bcd <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802b30:	83 ec 04             	sub    $0x4,%esp
  802b33:	6a 01                	push   $0x1
  802b35:	ff 75 ec             	pushl  -0x14(%ebp)
  802b38:	ff 75 f0             	pushl  -0x10(%ebp)
  802b3b:	e8 bb f6 ff ff       	call   8021fb <set_block_data>
  802b40:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802b43:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b47:	75 17                	jne    802b60 <alloc_block_BF+0x47a>
  802b49:	83 ec 04             	sub    $0x4,%esp
  802b4c:	68 4f 47 80 00       	push   $0x80474f
  802b51:	68 58 01 00 00       	push   $0x158
  802b56:	68 6d 47 80 00       	push   $0x80476d
  802b5b:	e8 5a d8 ff ff       	call   8003ba <_panic>
  802b60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b63:	8b 00                	mov    (%eax),%eax
  802b65:	85 c0                	test   %eax,%eax
  802b67:	74 10                	je     802b79 <alloc_block_BF+0x493>
  802b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6c:	8b 00                	mov    (%eax),%eax
  802b6e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b71:	8b 52 04             	mov    0x4(%edx),%edx
  802b74:	89 50 04             	mov    %edx,0x4(%eax)
  802b77:	eb 0b                	jmp    802b84 <alloc_block_BF+0x49e>
  802b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7c:	8b 40 04             	mov    0x4(%eax),%eax
  802b7f:	a3 30 50 80 00       	mov    %eax,0x805030
  802b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b87:	8b 40 04             	mov    0x4(%eax),%eax
  802b8a:	85 c0                	test   %eax,%eax
  802b8c:	74 0f                	je     802b9d <alloc_block_BF+0x4b7>
  802b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b91:	8b 40 04             	mov    0x4(%eax),%eax
  802b94:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b97:	8b 12                	mov    (%edx),%edx
  802b99:	89 10                	mov    %edx,(%eax)
  802b9b:	eb 0a                	jmp    802ba7 <alloc_block_BF+0x4c1>
  802b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba0:	8b 00                	mov    (%eax),%eax
  802ba2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802baa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bba:	a1 38 50 80 00       	mov    0x805038,%eax
  802bbf:	48                   	dec    %eax
  802bc0:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802bc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc8:	e9 fc 00 00 00       	jmp    802cc9 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd0:	83 c0 08             	add    $0x8,%eax
  802bd3:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802bd6:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802bdd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802be0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802be3:	01 d0                	add    %edx,%eax
  802be5:	48                   	dec    %eax
  802be6:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802be9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bec:	ba 00 00 00 00       	mov    $0x0,%edx
  802bf1:	f7 75 c4             	divl   -0x3c(%ebp)
  802bf4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bf7:	29 d0                	sub    %edx,%eax
  802bf9:	c1 e8 0c             	shr    $0xc,%eax
  802bfc:	83 ec 0c             	sub    $0xc,%esp
  802bff:	50                   	push   %eax
  802c00:	e8 0c e8 ff ff       	call   801411 <sbrk>
  802c05:	83 c4 10             	add    $0x10,%esp
  802c08:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802c0b:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802c0f:	75 0a                	jne    802c1b <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802c11:	b8 00 00 00 00       	mov    $0x0,%eax
  802c16:	e9 ae 00 00 00       	jmp    802cc9 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c1b:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802c22:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c25:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c28:	01 d0                	add    %edx,%eax
  802c2a:	48                   	dec    %eax
  802c2b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802c2e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c31:	ba 00 00 00 00       	mov    $0x0,%edx
  802c36:	f7 75 b8             	divl   -0x48(%ebp)
  802c39:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c3c:	29 d0                	sub    %edx,%eax
  802c3e:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c41:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c44:	01 d0                	add    %edx,%eax
  802c46:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802c4b:	a1 40 50 80 00       	mov    0x805040,%eax
  802c50:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802c56:	83 ec 0c             	sub    $0xc,%esp
  802c59:	68 14 48 80 00       	push   $0x804814
  802c5e:	e8 14 da ff ff       	call   800677 <cprintf>
  802c63:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802c66:	83 ec 08             	sub    $0x8,%esp
  802c69:	ff 75 bc             	pushl  -0x44(%ebp)
  802c6c:	68 19 48 80 00       	push   $0x804819
  802c71:	e8 01 da ff ff       	call   800677 <cprintf>
  802c76:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c79:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802c80:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c83:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c86:	01 d0                	add    %edx,%eax
  802c88:	48                   	dec    %eax
  802c89:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802c8c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c8f:	ba 00 00 00 00       	mov    $0x0,%edx
  802c94:	f7 75 b0             	divl   -0x50(%ebp)
  802c97:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c9a:	29 d0                	sub    %edx,%eax
  802c9c:	83 ec 04             	sub    $0x4,%esp
  802c9f:	6a 01                	push   $0x1
  802ca1:	50                   	push   %eax
  802ca2:	ff 75 bc             	pushl  -0x44(%ebp)
  802ca5:	e8 51 f5 ff ff       	call   8021fb <set_block_data>
  802caa:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802cad:	83 ec 0c             	sub    $0xc,%esp
  802cb0:	ff 75 bc             	pushl  -0x44(%ebp)
  802cb3:	e8 36 04 00 00       	call   8030ee <free_block>
  802cb8:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802cbb:	83 ec 0c             	sub    $0xc,%esp
  802cbe:	ff 75 08             	pushl  0x8(%ebp)
  802cc1:	e8 20 fa ff ff       	call   8026e6 <alloc_block_BF>
  802cc6:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802cc9:	c9                   	leave  
  802cca:	c3                   	ret    

00802ccb <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802ccb:	55                   	push   %ebp
  802ccc:	89 e5                	mov    %esp,%ebp
  802cce:	53                   	push   %ebx
  802ccf:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802cd2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802cd9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802ce0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ce4:	74 1e                	je     802d04 <merging+0x39>
  802ce6:	ff 75 08             	pushl  0x8(%ebp)
  802ce9:	e8 bc f1 ff ff       	call   801eaa <get_block_size>
  802cee:	83 c4 04             	add    $0x4,%esp
  802cf1:	89 c2                	mov    %eax,%edx
  802cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf6:	01 d0                	add    %edx,%eax
  802cf8:	3b 45 10             	cmp    0x10(%ebp),%eax
  802cfb:	75 07                	jne    802d04 <merging+0x39>
		prev_is_free = 1;
  802cfd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802d04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d08:	74 1e                	je     802d28 <merging+0x5d>
  802d0a:	ff 75 10             	pushl  0x10(%ebp)
  802d0d:	e8 98 f1 ff ff       	call   801eaa <get_block_size>
  802d12:	83 c4 04             	add    $0x4,%esp
  802d15:	89 c2                	mov    %eax,%edx
  802d17:	8b 45 10             	mov    0x10(%ebp),%eax
  802d1a:	01 d0                	add    %edx,%eax
  802d1c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d1f:	75 07                	jne    802d28 <merging+0x5d>
		next_is_free = 1;
  802d21:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802d28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2c:	0f 84 cc 00 00 00    	je     802dfe <merging+0x133>
  802d32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d36:	0f 84 c2 00 00 00    	je     802dfe <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802d3c:	ff 75 08             	pushl  0x8(%ebp)
  802d3f:	e8 66 f1 ff ff       	call   801eaa <get_block_size>
  802d44:	83 c4 04             	add    $0x4,%esp
  802d47:	89 c3                	mov    %eax,%ebx
  802d49:	ff 75 10             	pushl  0x10(%ebp)
  802d4c:	e8 59 f1 ff ff       	call   801eaa <get_block_size>
  802d51:	83 c4 04             	add    $0x4,%esp
  802d54:	01 c3                	add    %eax,%ebx
  802d56:	ff 75 0c             	pushl  0xc(%ebp)
  802d59:	e8 4c f1 ff ff       	call   801eaa <get_block_size>
  802d5e:	83 c4 04             	add    $0x4,%esp
  802d61:	01 d8                	add    %ebx,%eax
  802d63:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d66:	6a 00                	push   $0x0
  802d68:	ff 75 ec             	pushl  -0x14(%ebp)
  802d6b:	ff 75 08             	pushl  0x8(%ebp)
  802d6e:	e8 88 f4 ff ff       	call   8021fb <set_block_data>
  802d73:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802d76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d7a:	75 17                	jne    802d93 <merging+0xc8>
  802d7c:	83 ec 04             	sub    $0x4,%esp
  802d7f:	68 4f 47 80 00       	push   $0x80474f
  802d84:	68 7d 01 00 00       	push   $0x17d
  802d89:	68 6d 47 80 00       	push   $0x80476d
  802d8e:	e8 27 d6 ff ff       	call   8003ba <_panic>
  802d93:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d96:	8b 00                	mov    (%eax),%eax
  802d98:	85 c0                	test   %eax,%eax
  802d9a:	74 10                	je     802dac <merging+0xe1>
  802d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d9f:	8b 00                	mov    (%eax),%eax
  802da1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802da4:	8b 52 04             	mov    0x4(%edx),%edx
  802da7:	89 50 04             	mov    %edx,0x4(%eax)
  802daa:	eb 0b                	jmp    802db7 <merging+0xec>
  802dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  802daf:	8b 40 04             	mov    0x4(%eax),%eax
  802db2:	a3 30 50 80 00       	mov    %eax,0x805030
  802db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dba:	8b 40 04             	mov    0x4(%eax),%eax
  802dbd:	85 c0                	test   %eax,%eax
  802dbf:	74 0f                	je     802dd0 <merging+0x105>
  802dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dc4:	8b 40 04             	mov    0x4(%eax),%eax
  802dc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dca:	8b 12                	mov    (%edx),%edx
  802dcc:	89 10                	mov    %edx,(%eax)
  802dce:	eb 0a                	jmp    802dda <merging+0x10f>
  802dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dd3:	8b 00                	mov    (%eax),%eax
  802dd5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ddd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802de3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ded:	a1 38 50 80 00       	mov    0x805038,%eax
  802df2:	48                   	dec    %eax
  802df3:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802df8:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802df9:	e9 ea 02 00 00       	jmp    8030e8 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802dfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e02:	74 3b                	je     802e3f <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802e04:	83 ec 0c             	sub    $0xc,%esp
  802e07:	ff 75 08             	pushl  0x8(%ebp)
  802e0a:	e8 9b f0 ff ff       	call   801eaa <get_block_size>
  802e0f:	83 c4 10             	add    $0x10,%esp
  802e12:	89 c3                	mov    %eax,%ebx
  802e14:	83 ec 0c             	sub    $0xc,%esp
  802e17:	ff 75 10             	pushl  0x10(%ebp)
  802e1a:	e8 8b f0 ff ff       	call   801eaa <get_block_size>
  802e1f:	83 c4 10             	add    $0x10,%esp
  802e22:	01 d8                	add    %ebx,%eax
  802e24:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e27:	83 ec 04             	sub    $0x4,%esp
  802e2a:	6a 00                	push   $0x0
  802e2c:	ff 75 e8             	pushl  -0x18(%ebp)
  802e2f:	ff 75 08             	pushl  0x8(%ebp)
  802e32:	e8 c4 f3 ff ff       	call   8021fb <set_block_data>
  802e37:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e3a:	e9 a9 02 00 00       	jmp    8030e8 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802e3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e43:	0f 84 2d 01 00 00    	je     802f76 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802e49:	83 ec 0c             	sub    $0xc,%esp
  802e4c:	ff 75 10             	pushl  0x10(%ebp)
  802e4f:	e8 56 f0 ff ff       	call   801eaa <get_block_size>
  802e54:	83 c4 10             	add    $0x10,%esp
  802e57:	89 c3                	mov    %eax,%ebx
  802e59:	83 ec 0c             	sub    $0xc,%esp
  802e5c:	ff 75 0c             	pushl  0xc(%ebp)
  802e5f:	e8 46 f0 ff ff       	call   801eaa <get_block_size>
  802e64:	83 c4 10             	add    $0x10,%esp
  802e67:	01 d8                	add    %ebx,%eax
  802e69:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802e6c:	83 ec 04             	sub    $0x4,%esp
  802e6f:	6a 00                	push   $0x0
  802e71:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e74:	ff 75 10             	pushl  0x10(%ebp)
  802e77:	e8 7f f3 ff ff       	call   8021fb <set_block_data>
  802e7c:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802e7f:	8b 45 10             	mov    0x10(%ebp),%eax
  802e82:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802e85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e89:	74 06                	je     802e91 <merging+0x1c6>
  802e8b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e8f:	75 17                	jne    802ea8 <merging+0x1dd>
  802e91:	83 ec 04             	sub    $0x4,%esp
  802e94:	68 28 48 80 00       	push   $0x804828
  802e99:	68 8d 01 00 00       	push   $0x18d
  802e9e:	68 6d 47 80 00       	push   $0x80476d
  802ea3:	e8 12 d5 ff ff       	call   8003ba <_panic>
  802ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eab:	8b 50 04             	mov    0x4(%eax),%edx
  802eae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eb1:	89 50 04             	mov    %edx,0x4(%eax)
  802eb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eba:	89 10                	mov    %edx,(%eax)
  802ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ebf:	8b 40 04             	mov    0x4(%eax),%eax
  802ec2:	85 c0                	test   %eax,%eax
  802ec4:	74 0d                	je     802ed3 <merging+0x208>
  802ec6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec9:	8b 40 04             	mov    0x4(%eax),%eax
  802ecc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ecf:	89 10                	mov    %edx,(%eax)
  802ed1:	eb 08                	jmp    802edb <merging+0x210>
  802ed3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802edb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ede:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ee1:	89 50 04             	mov    %edx,0x4(%eax)
  802ee4:	a1 38 50 80 00       	mov    0x805038,%eax
  802ee9:	40                   	inc    %eax
  802eea:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802eef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ef3:	75 17                	jne    802f0c <merging+0x241>
  802ef5:	83 ec 04             	sub    $0x4,%esp
  802ef8:	68 4f 47 80 00       	push   $0x80474f
  802efd:	68 8e 01 00 00       	push   $0x18e
  802f02:	68 6d 47 80 00       	push   $0x80476d
  802f07:	e8 ae d4 ff ff       	call   8003ba <_panic>
  802f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f0f:	8b 00                	mov    (%eax),%eax
  802f11:	85 c0                	test   %eax,%eax
  802f13:	74 10                	je     802f25 <merging+0x25a>
  802f15:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f18:	8b 00                	mov    (%eax),%eax
  802f1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f1d:	8b 52 04             	mov    0x4(%edx),%edx
  802f20:	89 50 04             	mov    %edx,0x4(%eax)
  802f23:	eb 0b                	jmp    802f30 <merging+0x265>
  802f25:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f28:	8b 40 04             	mov    0x4(%eax),%eax
  802f2b:	a3 30 50 80 00       	mov    %eax,0x805030
  802f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f33:	8b 40 04             	mov    0x4(%eax),%eax
  802f36:	85 c0                	test   %eax,%eax
  802f38:	74 0f                	je     802f49 <merging+0x27e>
  802f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f3d:	8b 40 04             	mov    0x4(%eax),%eax
  802f40:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f43:	8b 12                	mov    (%edx),%edx
  802f45:	89 10                	mov    %edx,(%eax)
  802f47:	eb 0a                	jmp    802f53 <merging+0x288>
  802f49:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4c:	8b 00                	mov    (%eax),%eax
  802f4e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f66:	a1 38 50 80 00       	mov    0x805038,%eax
  802f6b:	48                   	dec    %eax
  802f6c:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f71:	e9 72 01 00 00       	jmp    8030e8 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802f76:	8b 45 10             	mov    0x10(%ebp),%eax
  802f79:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802f7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f80:	74 79                	je     802ffb <merging+0x330>
  802f82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f86:	74 73                	je     802ffb <merging+0x330>
  802f88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f8c:	74 06                	je     802f94 <merging+0x2c9>
  802f8e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f92:	75 17                	jne    802fab <merging+0x2e0>
  802f94:	83 ec 04             	sub    $0x4,%esp
  802f97:	68 e0 47 80 00       	push   $0x8047e0
  802f9c:	68 94 01 00 00       	push   $0x194
  802fa1:	68 6d 47 80 00       	push   $0x80476d
  802fa6:	e8 0f d4 ff ff       	call   8003ba <_panic>
  802fab:	8b 45 08             	mov    0x8(%ebp),%eax
  802fae:	8b 10                	mov    (%eax),%edx
  802fb0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fb3:	89 10                	mov    %edx,(%eax)
  802fb5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fb8:	8b 00                	mov    (%eax),%eax
  802fba:	85 c0                	test   %eax,%eax
  802fbc:	74 0b                	je     802fc9 <merging+0x2fe>
  802fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc1:	8b 00                	mov    (%eax),%eax
  802fc3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fc6:	89 50 04             	mov    %edx,0x4(%eax)
  802fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fcf:	89 10                	mov    %edx,(%eax)
  802fd1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fd4:	8b 55 08             	mov    0x8(%ebp),%edx
  802fd7:	89 50 04             	mov    %edx,0x4(%eax)
  802fda:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fdd:	8b 00                	mov    (%eax),%eax
  802fdf:	85 c0                	test   %eax,%eax
  802fe1:	75 08                	jne    802feb <merging+0x320>
  802fe3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe6:	a3 30 50 80 00       	mov    %eax,0x805030
  802feb:	a1 38 50 80 00       	mov    0x805038,%eax
  802ff0:	40                   	inc    %eax
  802ff1:	a3 38 50 80 00       	mov    %eax,0x805038
  802ff6:	e9 ce 00 00 00       	jmp    8030c9 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802ffb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fff:	74 65                	je     803066 <merging+0x39b>
  803001:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803005:	75 17                	jne    80301e <merging+0x353>
  803007:	83 ec 04             	sub    $0x4,%esp
  80300a:	68 bc 47 80 00       	push   $0x8047bc
  80300f:	68 95 01 00 00       	push   $0x195
  803014:	68 6d 47 80 00       	push   $0x80476d
  803019:	e8 9c d3 ff ff       	call   8003ba <_panic>
  80301e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803024:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803027:	89 50 04             	mov    %edx,0x4(%eax)
  80302a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80302d:	8b 40 04             	mov    0x4(%eax),%eax
  803030:	85 c0                	test   %eax,%eax
  803032:	74 0c                	je     803040 <merging+0x375>
  803034:	a1 30 50 80 00       	mov    0x805030,%eax
  803039:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80303c:	89 10                	mov    %edx,(%eax)
  80303e:	eb 08                	jmp    803048 <merging+0x37d>
  803040:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803043:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803048:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80304b:	a3 30 50 80 00       	mov    %eax,0x805030
  803050:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803053:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803059:	a1 38 50 80 00       	mov    0x805038,%eax
  80305e:	40                   	inc    %eax
  80305f:	a3 38 50 80 00       	mov    %eax,0x805038
  803064:	eb 63                	jmp    8030c9 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803066:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80306a:	75 17                	jne    803083 <merging+0x3b8>
  80306c:	83 ec 04             	sub    $0x4,%esp
  80306f:	68 88 47 80 00       	push   $0x804788
  803074:	68 98 01 00 00       	push   $0x198
  803079:	68 6d 47 80 00       	push   $0x80476d
  80307e:	e8 37 d3 ff ff       	call   8003ba <_panic>
  803083:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803089:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80308c:	89 10                	mov    %edx,(%eax)
  80308e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803091:	8b 00                	mov    (%eax),%eax
  803093:	85 c0                	test   %eax,%eax
  803095:	74 0d                	je     8030a4 <merging+0x3d9>
  803097:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80309c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80309f:	89 50 04             	mov    %edx,0x4(%eax)
  8030a2:	eb 08                	jmp    8030ac <merging+0x3e1>
  8030a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030a7:	a3 30 50 80 00       	mov    %eax,0x805030
  8030ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030af:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030be:	a1 38 50 80 00       	mov    0x805038,%eax
  8030c3:	40                   	inc    %eax
  8030c4:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8030c9:	83 ec 0c             	sub    $0xc,%esp
  8030cc:	ff 75 10             	pushl  0x10(%ebp)
  8030cf:	e8 d6 ed ff ff       	call   801eaa <get_block_size>
  8030d4:	83 c4 10             	add    $0x10,%esp
  8030d7:	83 ec 04             	sub    $0x4,%esp
  8030da:	6a 00                	push   $0x0
  8030dc:	50                   	push   %eax
  8030dd:	ff 75 10             	pushl  0x10(%ebp)
  8030e0:	e8 16 f1 ff ff       	call   8021fb <set_block_data>
  8030e5:	83 c4 10             	add    $0x10,%esp
	}
}
  8030e8:	90                   	nop
  8030e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030ec:	c9                   	leave  
  8030ed:	c3                   	ret    

008030ee <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8030ee:	55                   	push   %ebp
  8030ef:	89 e5                	mov    %esp,%ebp
  8030f1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8030f4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030f9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8030fc:	a1 30 50 80 00       	mov    0x805030,%eax
  803101:	3b 45 08             	cmp    0x8(%ebp),%eax
  803104:	73 1b                	jae    803121 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803106:	a1 30 50 80 00       	mov    0x805030,%eax
  80310b:	83 ec 04             	sub    $0x4,%esp
  80310e:	ff 75 08             	pushl  0x8(%ebp)
  803111:	6a 00                	push   $0x0
  803113:	50                   	push   %eax
  803114:	e8 b2 fb ff ff       	call   802ccb <merging>
  803119:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80311c:	e9 8b 00 00 00       	jmp    8031ac <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803121:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803126:	3b 45 08             	cmp    0x8(%ebp),%eax
  803129:	76 18                	jbe    803143 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80312b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803130:	83 ec 04             	sub    $0x4,%esp
  803133:	ff 75 08             	pushl  0x8(%ebp)
  803136:	50                   	push   %eax
  803137:	6a 00                	push   $0x0
  803139:	e8 8d fb ff ff       	call   802ccb <merging>
  80313e:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803141:	eb 69                	jmp    8031ac <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803143:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803148:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80314b:	eb 39                	jmp    803186 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80314d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803150:	3b 45 08             	cmp    0x8(%ebp),%eax
  803153:	73 29                	jae    80317e <free_block+0x90>
  803155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803158:	8b 00                	mov    (%eax),%eax
  80315a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80315d:	76 1f                	jbe    80317e <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80315f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803162:	8b 00                	mov    (%eax),%eax
  803164:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803167:	83 ec 04             	sub    $0x4,%esp
  80316a:	ff 75 08             	pushl  0x8(%ebp)
  80316d:	ff 75 f0             	pushl  -0x10(%ebp)
  803170:	ff 75 f4             	pushl  -0xc(%ebp)
  803173:	e8 53 fb ff ff       	call   802ccb <merging>
  803178:	83 c4 10             	add    $0x10,%esp
			break;
  80317b:	90                   	nop
		}
	}
}
  80317c:	eb 2e                	jmp    8031ac <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80317e:	a1 34 50 80 00       	mov    0x805034,%eax
  803183:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803186:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80318a:	74 07                	je     803193 <free_block+0xa5>
  80318c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318f:	8b 00                	mov    (%eax),%eax
  803191:	eb 05                	jmp    803198 <free_block+0xaa>
  803193:	b8 00 00 00 00       	mov    $0x0,%eax
  803198:	a3 34 50 80 00       	mov    %eax,0x805034
  80319d:	a1 34 50 80 00       	mov    0x805034,%eax
  8031a2:	85 c0                	test   %eax,%eax
  8031a4:	75 a7                	jne    80314d <free_block+0x5f>
  8031a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031aa:	75 a1                	jne    80314d <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031ac:	90                   	nop
  8031ad:	c9                   	leave  
  8031ae:	c3                   	ret    

008031af <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8031af:	55                   	push   %ebp
  8031b0:	89 e5                	mov    %esp,%ebp
  8031b2:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8031b5:	ff 75 08             	pushl  0x8(%ebp)
  8031b8:	e8 ed ec ff ff       	call   801eaa <get_block_size>
  8031bd:	83 c4 04             	add    $0x4,%esp
  8031c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8031c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8031ca:	eb 17                	jmp    8031e3 <copy_data+0x34>
  8031cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8031cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031d2:	01 c2                	add    %eax,%edx
  8031d4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8031d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031da:	01 c8                	add    %ecx,%eax
  8031dc:	8a 00                	mov    (%eax),%al
  8031de:	88 02                	mov    %al,(%edx)
  8031e0:	ff 45 fc             	incl   -0x4(%ebp)
  8031e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031e6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8031e9:	72 e1                	jb     8031cc <copy_data+0x1d>
}
  8031eb:	90                   	nop
  8031ec:	c9                   	leave  
  8031ed:	c3                   	ret    

008031ee <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8031ee:	55                   	push   %ebp
  8031ef:	89 e5                	mov    %esp,%ebp
  8031f1:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8031f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031f8:	75 23                	jne    80321d <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8031fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031fe:	74 13                	je     803213 <realloc_block_FF+0x25>
  803200:	83 ec 0c             	sub    $0xc,%esp
  803203:	ff 75 0c             	pushl  0xc(%ebp)
  803206:	e8 1f f0 ff ff       	call   80222a <alloc_block_FF>
  80320b:	83 c4 10             	add    $0x10,%esp
  80320e:	e9 f4 06 00 00       	jmp    803907 <realloc_block_FF+0x719>
		return NULL;
  803213:	b8 00 00 00 00       	mov    $0x0,%eax
  803218:	e9 ea 06 00 00       	jmp    803907 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80321d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803221:	75 18                	jne    80323b <realloc_block_FF+0x4d>
	{
		free_block(va);
  803223:	83 ec 0c             	sub    $0xc,%esp
  803226:	ff 75 08             	pushl  0x8(%ebp)
  803229:	e8 c0 fe ff ff       	call   8030ee <free_block>
  80322e:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803231:	b8 00 00 00 00       	mov    $0x0,%eax
  803236:	e9 cc 06 00 00       	jmp    803907 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80323b:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80323f:	77 07                	ja     803248 <realloc_block_FF+0x5a>
  803241:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80324b:	83 e0 01             	and    $0x1,%eax
  80324e:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803251:	8b 45 0c             	mov    0xc(%ebp),%eax
  803254:	83 c0 08             	add    $0x8,%eax
  803257:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80325a:	83 ec 0c             	sub    $0xc,%esp
  80325d:	ff 75 08             	pushl  0x8(%ebp)
  803260:	e8 45 ec ff ff       	call   801eaa <get_block_size>
  803265:	83 c4 10             	add    $0x10,%esp
  803268:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80326b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80326e:	83 e8 08             	sub    $0x8,%eax
  803271:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803274:	8b 45 08             	mov    0x8(%ebp),%eax
  803277:	83 e8 04             	sub    $0x4,%eax
  80327a:	8b 00                	mov    (%eax),%eax
  80327c:	83 e0 fe             	and    $0xfffffffe,%eax
  80327f:	89 c2                	mov    %eax,%edx
  803281:	8b 45 08             	mov    0x8(%ebp),%eax
  803284:	01 d0                	add    %edx,%eax
  803286:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803289:	83 ec 0c             	sub    $0xc,%esp
  80328c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80328f:	e8 16 ec ff ff       	call   801eaa <get_block_size>
  803294:	83 c4 10             	add    $0x10,%esp
  803297:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80329a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80329d:	83 e8 08             	sub    $0x8,%eax
  8032a0:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8032a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032a6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032a9:	75 08                	jne    8032b3 <realloc_block_FF+0xc5>
	{
		 return va;
  8032ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ae:	e9 54 06 00 00       	jmp    803907 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8032b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032b6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032b9:	0f 83 e5 03 00 00    	jae    8036a4 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8032bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c2:	2b 45 0c             	sub    0xc(%ebp),%eax
  8032c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8032c8:	83 ec 0c             	sub    $0xc,%esp
  8032cb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8032ce:	e8 f0 eb ff ff       	call   801ec3 <is_free_block>
  8032d3:	83 c4 10             	add    $0x10,%esp
  8032d6:	84 c0                	test   %al,%al
  8032d8:	0f 84 3b 01 00 00    	je     803419 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8032de:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032e4:	01 d0                	add    %edx,%eax
  8032e6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8032e9:	83 ec 04             	sub    $0x4,%esp
  8032ec:	6a 01                	push   $0x1
  8032ee:	ff 75 f0             	pushl  -0x10(%ebp)
  8032f1:	ff 75 08             	pushl  0x8(%ebp)
  8032f4:	e8 02 ef ff ff       	call   8021fb <set_block_data>
  8032f9:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8032fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ff:	83 e8 04             	sub    $0x4,%eax
  803302:	8b 00                	mov    (%eax),%eax
  803304:	83 e0 fe             	and    $0xfffffffe,%eax
  803307:	89 c2                	mov    %eax,%edx
  803309:	8b 45 08             	mov    0x8(%ebp),%eax
  80330c:	01 d0                	add    %edx,%eax
  80330e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803311:	83 ec 04             	sub    $0x4,%esp
  803314:	6a 00                	push   $0x0
  803316:	ff 75 cc             	pushl  -0x34(%ebp)
  803319:	ff 75 c8             	pushl  -0x38(%ebp)
  80331c:	e8 da ee ff ff       	call   8021fb <set_block_data>
  803321:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803324:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803328:	74 06                	je     803330 <realloc_block_FF+0x142>
  80332a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80332e:	75 17                	jne    803347 <realloc_block_FF+0x159>
  803330:	83 ec 04             	sub    $0x4,%esp
  803333:	68 e0 47 80 00       	push   $0x8047e0
  803338:	68 f6 01 00 00       	push   $0x1f6
  80333d:	68 6d 47 80 00       	push   $0x80476d
  803342:	e8 73 d0 ff ff       	call   8003ba <_panic>
  803347:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80334a:	8b 10                	mov    (%eax),%edx
  80334c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80334f:	89 10                	mov    %edx,(%eax)
  803351:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803354:	8b 00                	mov    (%eax),%eax
  803356:	85 c0                	test   %eax,%eax
  803358:	74 0b                	je     803365 <realloc_block_FF+0x177>
  80335a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80335d:	8b 00                	mov    (%eax),%eax
  80335f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803362:	89 50 04             	mov    %edx,0x4(%eax)
  803365:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803368:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80336b:	89 10                	mov    %edx,(%eax)
  80336d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803370:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803373:	89 50 04             	mov    %edx,0x4(%eax)
  803376:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803379:	8b 00                	mov    (%eax),%eax
  80337b:	85 c0                	test   %eax,%eax
  80337d:	75 08                	jne    803387 <realloc_block_FF+0x199>
  80337f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803382:	a3 30 50 80 00       	mov    %eax,0x805030
  803387:	a1 38 50 80 00       	mov    0x805038,%eax
  80338c:	40                   	inc    %eax
  80338d:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803392:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803396:	75 17                	jne    8033af <realloc_block_FF+0x1c1>
  803398:	83 ec 04             	sub    $0x4,%esp
  80339b:	68 4f 47 80 00       	push   $0x80474f
  8033a0:	68 f7 01 00 00       	push   $0x1f7
  8033a5:	68 6d 47 80 00       	push   $0x80476d
  8033aa:	e8 0b d0 ff ff       	call   8003ba <_panic>
  8033af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b2:	8b 00                	mov    (%eax),%eax
  8033b4:	85 c0                	test   %eax,%eax
  8033b6:	74 10                	je     8033c8 <realloc_block_FF+0x1da>
  8033b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033bb:	8b 00                	mov    (%eax),%eax
  8033bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033c0:	8b 52 04             	mov    0x4(%edx),%edx
  8033c3:	89 50 04             	mov    %edx,0x4(%eax)
  8033c6:	eb 0b                	jmp    8033d3 <realloc_block_FF+0x1e5>
  8033c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033cb:	8b 40 04             	mov    0x4(%eax),%eax
  8033ce:	a3 30 50 80 00       	mov    %eax,0x805030
  8033d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033d6:	8b 40 04             	mov    0x4(%eax),%eax
  8033d9:	85 c0                	test   %eax,%eax
  8033db:	74 0f                	je     8033ec <realloc_block_FF+0x1fe>
  8033dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e0:	8b 40 04             	mov    0x4(%eax),%eax
  8033e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033e6:	8b 12                	mov    (%edx),%edx
  8033e8:	89 10                	mov    %edx,(%eax)
  8033ea:	eb 0a                	jmp    8033f6 <realloc_block_FF+0x208>
  8033ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ef:	8b 00                	mov    (%eax),%eax
  8033f1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803402:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803409:	a1 38 50 80 00       	mov    0x805038,%eax
  80340e:	48                   	dec    %eax
  80340f:	a3 38 50 80 00       	mov    %eax,0x805038
  803414:	e9 83 02 00 00       	jmp    80369c <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803419:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80341d:	0f 86 69 02 00 00    	jbe    80368c <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803423:	83 ec 04             	sub    $0x4,%esp
  803426:	6a 01                	push   $0x1
  803428:	ff 75 f0             	pushl  -0x10(%ebp)
  80342b:	ff 75 08             	pushl  0x8(%ebp)
  80342e:	e8 c8 ed ff ff       	call   8021fb <set_block_data>
  803433:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803436:	8b 45 08             	mov    0x8(%ebp),%eax
  803439:	83 e8 04             	sub    $0x4,%eax
  80343c:	8b 00                	mov    (%eax),%eax
  80343e:	83 e0 fe             	and    $0xfffffffe,%eax
  803441:	89 c2                	mov    %eax,%edx
  803443:	8b 45 08             	mov    0x8(%ebp),%eax
  803446:	01 d0                	add    %edx,%eax
  803448:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80344b:	a1 38 50 80 00       	mov    0x805038,%eax
  803450:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803453:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803457:	75 68                	jne    8034c1 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803459:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80345d:	75 17                	jne    803476 <realloc_block_FF+0x288>
  80345f:	83 ec 04             	sub    $0x4,%esp
  803462:	68 88 47 80 00       	push   $0x804788
  803467:	68 06 02 00 00       	push   $0x206
  80346c:	68 6d 47 80 00       	push   $0x80476d
  803471:	e8 44 cf ff ff       	call   8003ba <_panic>
  803476:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80347c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80347f:	89 10                	mov    %edx,(%eax)
  803481:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803484:	8b 00                	mov    (%eax),%eax
  803486:	85 c0                	test   %eax,%eax
  803488:	74 0d                	je     803497 <realloc_block_FF+0x2a9>
  80348a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80348f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803492:	89 50 04             	mov    %edx,0x4(%eax)
  803495:	eb 08                	jmp    80349f <realloc_block_FF+0x2b1>
  803497:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80349a:	a3 30 50 80 00       	mov    %eax,0x805030
  80349f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034a2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034b1:	a1 38 50 80 00       	mov    0x805038,%eax
  8034b6:	40                   	inc    %eax
  8034b7:	a3 38 50 80 00       	mov    %eax,0x805038
  8034bc:	e9 b0 01 00 00       	jmp    803671 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8034c1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034c6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034c9:	76 68                	jbe    803533 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034cb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034cf:	75 17                	jne    8034e8 <realloc_block_FF+0x2fa>
  8034d1:	83 ec 04             	sub    $0x4,%esp
  8034d4:	68 88 47 80 00       	push   $0x804788
  8034d9:	68 0b 02 00 00       	push   $0x20b
  8034de:	68 6d 47 80 00       	push   $0x80476d
  8034e3:	e8 d2 ce ff ff       	call   8003ba <_panic>
  8034e8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034f1:	89 10                	mov    %edx,(%eax)
  8034f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034f6:	8b 00                	mov    (%eax),%eax
  8034f8:	85 c0                	test   %eax,%eax
  8034fa:	74 0d                	je     803509 <realloc_block_FF+0x31b>
  8034fc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803501:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803504:	89 50 04             	mov    %edx,0x4(%eax)
  803507:	eb 08                	jmp    803511 <realloc_block_FF+0x323>
  803509:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80350c:	a3 30 50 80 00       	mov    %eax,0x805030
  803511:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803514:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803519:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80351c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803523:	a1 38 50 80 00       	mov    0x805038,%eax
  803528:	40                   	inc    %eax
  803529:	a3 38 50 80 00       	mov    %eax,0x805038
  80352e:	e9 3e 01 00 00       	jmp    803671 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803533:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803538:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80353b:	73 68                	jae    8035a5 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80353d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803541:	75 17                	jne    80355a <realloc_block_FF+0x36c>
  803543:	83 ec 04             	sub    $0x4,%esp
  803546:	68 bc 47 80 00       	push   $0x8047bc
  80354b:	68 10 02 00 00       	push   $0x210
  803550:	68 6d 47 80 00       	push   $0x80476d
  803555:	e8 60 ce ff ff       	call   8003ba <_panic>
  80355a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803560:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803563:	89 50 04             	mov    %edx,0x4(%eax)
  803566:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803569:	8b 40 04             	mov    0x4(%eax),%eax
  80356c:	85 c0                	test   %eax,%eax
  80356e:	74 0c                	je     80357c <realloc_block_FF+0x38e>
  803570:	a1 30 50 80 00       	mov    0x805030,%eax
  803575:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803578:	89 10                	mov    %edx,(%eax)
  80357a:	eb 08                	jmp    803584 <realloc_block_FF+0x396>
  80357c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80357f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803584:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803587:	a3 30 50 80 00       	mov    %eax,0x805030
  80358c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80358f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803595:	a1 38 50 80 00       	mov    0x805038,%eax
  80359a:	40                   	inc    %eax
  80359b:	a3 38 50 80 00       	mov    %eax,0x805038
  8035a0:	e9 cc 00 00 00       	jmp    803671 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8035a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8035ac:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035b4:	e9 8a 00 00 00       	jmp    803643 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8035b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035bf:	73 7a                	jae    80363b <realloc_block_FF+0x44d>
  8035c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c4:	8b 00                	mov    (%eax),%eax
  8035c6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035c9:	73 70                	jae    80363b <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8035cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035cf:	74 06                	je     8035d7 <realloc_block_FF+0x3e9>
  8035d1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035d5:	75 17                	jne    8035ee <realloc_block_FF+0x400>
  8035d7:	83 ec 04             	sub    $0x4,%esp
  8035da:	68 e0 47 80 00       	push   $0x8047e0
  8035df:	68 1a 02 00 00       	push   $0x21a
  8035e4:	68 6d 47 80 00       	push   $0x80476d
  8035e9:	e8 cc cd ff ff       	call   8003ba <_panic>
  8035ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f1:	8b 10                	mov    (%eax),%edx
  8035f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f6:	89 10                	mov    %edx,(%eax)
  8035f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035fb:	8b 00                	mov    (%eax),%eax
  8035fd:	85 c0                	test   %eax,%eax
  8035ff:	74 0b                	je     80360c <realloc_block_FF+0x41e>
  803601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803604:	8b 00                	mov    (%eax),%eax
  803606:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803609:	89 50 04             	mov    %edx,0x4(%eax)
  80360c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803612:	89 10                	mov    %edx,(%eax)
  803614:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803617:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80361a:	89 50 04             	mov    %edx,0x4(%eax)
  80361d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803620:	8b 00                	mov    (%eax),%eax
  803622:	85 c0                	test   %eax,%eax
  803624:	75 08                	jne    80362e <realloc_block_FF+0x440>
  803626:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803629:	a3 30 50 80 00       	mov    %eax,0x805030
  80362e:	a1 38 50 80 00       	mov    0x805038,%eax
  803633:	40                   	inc    %eax
  803634:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803639:	eb 36                	jmp    803671 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80363b:	a1 34 50 80 00       	mov    0x805034,%eax
  803640:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803643:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803647:	74 07                	je     803650 <realloc_block_FF+0x462>
  803649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364c:	8b 00                	mov    (%eax),%eax
  80364e:	eb 05                	jmp    803655 <realloc_block_FF+0x467>
  803650:	b8 00 00 00 00       	mov    $0x0,%eax
  803655:	a3 34 50 80 00       	mov    %eax,0x805034
  80365a:	a1 34 50 80 00       	mov    0x805034,%eax
  80365f:	85 c0                	test   %eax,%eax
  803661:	0f 85 52 ff ff ff    	jne    8035b9 <realloc_block_FF+0x3cb>
  803667:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80366b:	0f 85 48 ff ff ff    	jne    8035b9 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803671:	83 ec 04             	sub    $0x4,%esp
  803674:	6a 00                	push   $0x0
  803676:	ff 75 d8             	pushl  -0x28(%ebp)
  803679:	ff 75 d4             	pushl  -0x2c(%ebp)
  80367c:	e8 7a eb ff ff       	call   8021fb <set_block_data>
  803681:	83 c4 10             	add    $0x10,%esp
				return va;
  803684:	8b 45 08             	mov    0x8(%ebp),%eax
  803687:	e9 7b 02 00 00       	jmp    803907 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80368c:	83 ec 0c             	sub    $0xc,%esp
  80368f:	68 5d 48 80 00       	push   $0x80485d
  803694:	e8 de cf ff ff       	call   800677 <cprintf>
  803699:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80369c:	8b 45 08             	mov    0x8(%ebp),%eax
  80369f:	e9 63 02 00 00       	jmp    803907 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8036a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036a7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8036aa:	0f 86 4d 02 00 00    	jbe    8038fd <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8036b0:	83 ec 0c             	sub    $0xc,%esp
  8036b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036b6:	e8 08 e8 ff ff       	call   801ec3 <is_free_block>
  8036bb:	83 c4 10             	add    $0x10,%esp
  8036be:	84 c0                	test   %al,%al
  8036c0:	0f 84 37 02 00 00    	je     8038fd <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8036c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036c9:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8036cc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8036cf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8036d2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8036d5:	76 38                	jbe    80370f <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8036d7:	83 ec 0c             	sub    $0xc,%esp
  8036da:	ff 75 08             	pushl  0x8(%ebp)
  8036dd:	e8 0c fa ff ff       	call   8030ee <free_block>
  8036e2:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8036e5:	83 ec 0c             	sub    $0xc,%esp
  8036e8:	ff 75 0c             	pushl  0xc(%ebp)
  8036eb:	e8 3a eb ff ff       	call   80222a <alloc_block_FF>
  8036f0:	83 c4 10             	add    $0x10,%esp
  8036f3:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8036f6:	83 ec 08             	sub    $0x8,%esp
  8036f9:	ff 75 c0             	pushl  -0x40(%ebp)
  8036fc:	ff 75 08             	pushl  0x8(%ebp)
  8036ff:	e8 ab fa ff ff       	call   8031af <copy_data>
  803704:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803707:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80370a:	e9 f8 01 00 00       	jmp    803907 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80370f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803712:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803715:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803718:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80371c:	0f 87 a0 00 00 00    	ja     8037c2 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803722:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803726:	75 17                	jne    80373f <realloc_block_FF+0x551>
  803728:	83 ec 04             	sub    $0x4,%esp
  80372b:	68 4f 47 80 00       	push   $0x80474f
  803730:	68 38 02 00 00       	push   $0x238
  803735:	68 6d 47 80 00       	push   $0x80476d
  80373a:	e8 7b cc ff ff       	call   8003ba <_panic>
  80373f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803742:	8b 00                	mov    (%eax),%eax
  803744:	85 c0                	test   %eax,%eax
  803746:	74 10                	je     803758 <realloc_block_FF+0x56a>
  803748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80374b:	8b 00                	mov    (%eax),%eax
  80374d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803750:	8b 52 04             	mov    0x4(%edx),%edx
  803753:	89 50 04             	mov    %edx,0x4(%eax)
  803756:	eb 0b                	jmp    803763 <realloc_block_FF+0x575>
  803758:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80375b:	8b 40 04             	mov    0x4(%eax),%eax
  80375e:	a3 30 50 80 00       	mov    %eax,0x805030
  803763:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803766:	8b 40 04             	mov    0x4(%eax),%eax
  803769:	85 c0                	test   %eax,%eax
  80376b:	74 0f                	je     80377c <realloc_block_FF+0x58e>
  80376d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803770:	8b 40 04             	mov    0x4(%eax),%eax
  803773:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803776:	8b 12                	mov    (%edx),%edx
  803778:	89 10                	mov    %edx,(%eax)
  80377a:	eb 0a                	jmp    803786 <realloc_block_FF+0x598>
  80377c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80377f:	8b 00                	mov    (%eax),%eax
  803781:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803789:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80378f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803792:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803799:	a1 38 50 80 00       	mov    0x805038,%eax
  80379e:	48                   	dec    %eax
  80379f:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8037a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037aa:	01 d0                	add    %edx,%eax
  8037ac:	83 ec 04             	sub    $0x4,%esp
  8037af:	6a 01                	push   $0x1
  8037b1:	50                   	push   %eax
  8037b2:	ff 75 08             	pushl  0x8(%ebp)
  8037b5:	e8 41 ea ff ff       	call   8021fb <set_block_data>
  8037ba:	83 c4 10             	add    $0x10,%esp
  8037bd:	e9 36 01 00 00       	jmp    8038f8 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8037c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037c5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037c8:	01 d0                	add    %edx,%eax
  8037ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8037cd:	83 ec 04             	sub    $0x4,%esp
  8037d0:	6a 01                	push   $0x1
  8037d2:	ff 75 f0             	pushl  -0x10(%ebp)
  8037d5:	ff 75 08             	pushl  0x8(%ebp)
  8037d8:	e8 1e ea ff ff       	call   8021fb <set_block_data>
  8037dd:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8037e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e3:	83 e8 04             	sub    $0x4,%eax
  8037e6:	8b 00                	mov    (%eax),%eax
  8037e8:	83 e0 fe             	and    $0xfffffffe,%eax
  8037eb:	89 c2                	mov    %eax,%edx
  8037ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f0:	01 d0                	add    %edx,%eax
  8037f2:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8037f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037f9:	74 06                	je     803801 <realloc_block_FF+0x613>
  8037fb:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8037ff:	75 17                	jne    803818 <realloc_block_FF+0x62a>
  803801:	83 ec 04             	sub    $0x4,%esp
  803804:	68 e0 47 80 00       	push   $0x8047e0
  803809:	68 44 02 00 00       	push   $0x244
  80380e:	68 6d 47 80 00       	push   $0x80476d
  803813:	e8 a2 cb ff ff       	call   8003ba <_panic>
  803818:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381b:	8b 10                	mov    (%eax),%edx
  80381d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803820:	89 10                	mov    %edx,(%eax)
  803822:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803825:	8b 00                	mov    (%eax),%eax
  803827:	85 c0                	test   %eax,%eax
  803829:	74 0b                	je     803836 <realloc_block_FF+0x648>
  80382b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382e:	8b 00                	mov    (%eax),%eax
  803830:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803833:	89 50 04             	mov    %edx,0x4(%eax)
  803836:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803839:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80383c:	89 10                	mov    %edx,(%eax)
  80383e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803841:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803844:	89 50 04             	mov    %edx,0x4(%eax)
  803847:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80384a:	8b 00                	mov    (%eax),%eax
  80384c:	85 c0                	test   %eax,%eax
  80384e:	75 08                	jne    803858 <realloc_block_FF+0x66a>
  803850:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803853:	a3 30 50 80 00       	mov    %eax,0x805030
  803858:	a1 38 50 80 00       	mov    0x805038,%eax
  80385d:	40                   	inc    %eax
  80385e:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803863:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803867:	75 17                	jne    803880 <realloc_block_FF+0x692>
  803869:	83 ec 04             	sub    $0x4,%esp
  80386c:	68 4f 47 80 00       	push   $0x80474f
  803871:	68 45 02 00 00       	push   $0x245
  803876:	68 6d 47 80 00       	push   $0x80476d
  80387b:	e8 3a cb ff ff       	call   8003ba <_panic>
  803880:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803883:	8b 00                	mov    (%eax),%eax
  803885:	85 c0                	test   %eax,%eax
  803887:	74 10                	je     803899 <realloc_block_FF+0x6ab>
  803889:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388c:	8b 00                	mov    (%eax),%eax
  80388e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803891:	8b 52 04             	mov    0x4(%edx),%edx
  803894:	89 50 04             	mov    %edx,0x4(%eax)
  803897:	eb 0b                	jmp    8038a4 <realloc_block_FF+0x6b6>
  803899:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389c:	8b 40 04             	mov    0x4(%eax),%eax
  80389f:	a3 30 50 80 00       	mov    %eax,0x805030
  8038a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a7:	8b 40 04             	mov    0x4(%eax),%eax
  8038aa:	85 c0                	test   %eax,%eax
  8038ac:	74 0f                	je     8038bd <realloc_block_FF+0x6cf>
  8038ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b1:	8b 40 04             	mov    0x4(%eax),%eax
  8038b4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038b7:	8b 12                	mov    (%edx),%edx
  8038b9:	89 10                	mov    %edx,(%eax)
  8038bb:	eb 0a                	jmp    8038c7 <realloc_block_FF+0x6d9>
  8038bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c0:	8b 00                	mov    (%eax),%eax
  8038c2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038da:	a1 38 50 80 00       	mov    0x805038,%eax
  8038df:	48                   	dec    %eax
  8038e0:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8038e5:	83 ec 04             	sub    $0x4,%esp
  8038e8:	6a 00                	push   $0x0
  8038ea:	ff 75 bc             	pushl  -0x44(%ebp)
  8038ed:	ff 75 b8             	pushl  -0x48(%ebp)
  8038f0:	e8 06 e9 ff ff       	call   8021fb <set_block_data>
  8038f5:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8038f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fb:	eb 0a                	jmp    803907 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8038fd:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803904:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803907:	c9                   	leave  
  803908:	c3                   	ret    

00803909 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803909:	55                   	push   %ebp
  80390a:	89 e5                	mov    %esp,%ebp
  80390c:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80390f:	83 ec 04             	sub    $0x4,%esp
  803912:	68 64 48 80 00       	push   $0x804864
  803917:	68 58 02 00 00       	push   $0x258
  80391c:	68 6d 47 80 00       	push   $0x80476d
  803921:	e8 94 ca ff ff       	call   8003ba <_panic>

00803926 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803926:	55                   	push   %ebp
  803927:	89 e5                	mov    %esp,%ebp
  803929:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80392c:	83 ec 04             	sub    $0x4,%esp
  80392f:	68 8c 48 80 00       	push   $0x80488c
  803934:	68 61 02 00 00       	push   $0x261
  803939:	68 6d 47 80 00       	push   $0x80476d
  80393e:	e8 77 ca ff ff       	call   8003ba <_panic>
  803943:	90                   	nop

00803944 <__udivdi3>:
  803944:	55                   	push   %ebp
  803945:	57                   	push   %edi
  803946:	56                   	push   %esi
  803947:	53                   	push   %ebx
  803948:	83 ec 1c             	sub    $0x1c,%esp
  80394b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80394f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803953:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803957:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80395b:	89 ca                	mov    %ecx,%edx
  80395d:	89 f8                	mov    %edi,%eax
  80395f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803963:	85 f6                	test   %esi,%esi
  803965:	75 2d                	jne    803994 <__udivdi3+0x50>
  803967:	39 cf                	cmp    %ecx,%edi
  803969:	77 65                	ja     8039d0 <__udivdi3+0x8c>
  80396b:	89 fd                	mov    %edi,%ebp
  80396d:	85 ff                	test   %edi,%edi
  80396f:	75 0b                	jne    80397c <__udivdi3+0x38>
  803971:	b8 01 00 00 00       	mov    $0x1,%eax
  803976:	31 d2                	xor    %edx,%edx
  803978:	f7 f7                	div    %edi
  80397a:	89 c5                	mov    %eax,%ebp
  80397c:	31 d2                	xor    %edx,%edx
  80397e:	89 c8                	mov    %ecx,%eax
  803980:	f7 f5                	div    %ebp
  803982:	89 c1                	mov    %eax,%ecx
  803984:	89 d8                	mov    %ebx,%eax
  803986:	f7 f5                	div    %ebp
  803988:	89 cf                	mov    %ecx,%edi
  80398a:	89 fa                	mov    %edi,%edx
  80398c:	83 c4 1c             	add    $0x1c,%esp
  80398f:	5b                   	pop    %ebx
  803990:	5e                   	pop    %esi
  803991:	5f                   	pop    %edi
  803992:	5d                   	pop    %ebp
  803993:	c3                   	ret    
  803994:	39 ce                	cmp    %ecx,%esi
  803996:	77 28                	ja     8039c0 <__udivdi3+0x7c>
  803998:	0f bd fe             	bsr    %esi,%edi
  80399b:	83 f7 1f             	xor    $0x1f,%edi
  80399e:	75 40                	jne    8039e0 <__udivdi3+0x9c>
  8039a0:	39 ce                	cmp    %ecx,%esi
  8039a2:	72 0a                	jb     8039ae <__udivdi3+0x6a>
  8039a4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8039a8:	0f 87 9e 00 00 00    	ja     803a4c <__udivdi3+0x108>
  8039ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8039b3:	89 fa                	mov    %edi,%edx
  8039b5:	83 c4 1c             	add    $0x1c,%esp
  8039b8:	5b                   	pop    %ebx
  8039b9:	5e                   	pop    %esi
  8039ba:	5f                   	pop    %edi
  8039bb:	5d                   	pop    %ebp
  8039bc:	c3                   	ret    
  8039bd:	8d 76 00             	lea    0x0(%esi),%esi
  8039c0:	31 ff                	xor    %edi,%edi
  8039c2:	31 c0                	xor    %eax,%eax
  8039c4:	89 fa                	mov    %edi,%edx
  8039c6:	83 c4 1c             	add    $0x1c,%esp
  8039c9:	5b                   	pop    %ebx
  8039ca:	5e                   	pop    %esi
  8039cb:	5f                   	pop    %edi
  8039cc:	5d                   	pop    %ebp
  8039cd:	c3                   	ret    
  8039ce:	66 90                	xchg   %ax,%ax
  8039d0:	89 d8                	mov    %ebx,%eax
  8039d2:	f7 f7                	div    %edi
  8039d4:	31 ff                	xor    %edi,%edi
  8039d6:	89 fa                	mov    %edi,%edx
  8039d8:	83 c4 1c             	add    $0x1c,%esp
  8039db:	5b                   	pop    %ebx
  8039dc:	5e                   	pop    %esi
  8039dd:	5f                   	pop    %edi
  8039de:	5d                   	pop    %ebp
  8039df:	c3                   	ret    
  8039e0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8039e5:	89 eb                	mov    %ebp,%ebx
  8039e7:	29 fb                	sub    %edi,%ebx
  8039e9:	89 f9                	mov    %edi,%ecx
  8039eb:	d3 e6                	shl    %cl,%esi
  8039ed:	89 c5                	mov    %eax,%ebp
  8039ef:	88 d9                	mov    %bl,%cl
  8039f1:	d3 ed                	shr    %cl,%ebp
  8039f3:	89 e9                	mov    %ebp,%ecx
  8039f5:	09 f1                	or     %esi,%ecx
  8039f7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8039fb:	89 f9                	mov    %edi,%ecx
  8039fd:	d3 e0                	shl    %cl,%eax
  8039ff:	89 c5                	mov    %eax,%ebp
  803a01:	89 d6                	mov    %edx,%esi
  803a03:	88 d9                	mov    %bl,%cl
  803a05:	d3 ee                	shr    %cl,%esi
  803a07:	89 f9                	mov    %edi,%ecx
  803a09:	d3 e2                	shl    %cl,%edx
  803a0b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a0f:	88 d9                	mov    %bl,%cl
  803a11:	d3 e8                	shr    %cl,%eax
  803a13:	09 c2                	or     %eax,%edx
  803a15:	89 d0                	mov    %edx,%eax
  803a17:	89 f2                	mov    %esi,%edx
  803a19:	f7 74 24 0c          	divl   0xc(%esp)
  803a1d:	89 d6                	mov    %edx,%esi
  803a1f:	89 c3                	mov    %eax,%ebx
  803a21:	f7 e5                	mul    %ebp
  803a23:	39 d6                	cmp    %edx,%esi
  803a25:	72 19                	jb     803a40 <__udivdi3+0xfc>
  803a27:	74 0b                	je     803a34 <__udivdi3+0xf0>
  803a29:	89 d8                	mov    %ebx,%eax
  803a2b:	31 ff                	xor    %edi,%edi
  803a2d:	e9 58 ff ff ff       	jmp    80398a <__udivdi3+0x46>
  803a32:	66 90                	xchg   %ax,%ax
  803a34:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a38:	89 f9                	mov    %edi,%ecx
  803a3a:	d3 e2                	shl    %cl,%edx
  803a3c:	39 c2                	cmp    %eax,%edx
  803a3e:	73 e9                	jae    803a29 <__udivdi3+0xe5>
  803a40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a43:	31 ff                	xor    %edi,%edi
  803a45:	e9 40 ff ff ff       	jmp    80398a <__udivdi3+0x46>
  803a4a:	66 90                	xchg   %ax,%ax
  803a4c:	31 c0                	xor    %eax,%eax
  803a4e:	e9 37 ff ff ff       	jmp    80398a <__udivdi3+0x46>
  803a53:	90                   	nop

00803a54 <__umoddi3>:
  803a54:	55                   	push   %ebp
  803a55:	57                   	push   %edi
  803a56:	56                   	push   %esi
  803a57:	53                   	push   %ebx
  803a58:	83 ec 1c             	sub    $0x1c,%esp
  803a5b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a67:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a6f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a73:	89 f3                	mov    %esi,%ebx
  803a75:	89 fa                	mov    %edi,%edx
  803a77:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a7b:	89 34 24             	mov    %esi,(%esp)
  803a7e:	85 c0                	test   %eax,%eax
  803a80:	75 1a                	jne    803a9c <__umoddi3+0x48>
  803a82:	39 f7                	cmp    %esi,%edi
  803a84:	0f 86 a2 00 00 00    	jbe    803b2c <__umoddi3+0xd8>
  803a8a:	89 c8                	mov    %ecx,%eax
  803a8c:	89 f2                	mov    %esi,%edx
  803a8e:	f7 f7                	div    %edi
  803a90:	89 d0                	mov    %edx,%eax
  803a92:	31 d2                	xor    %edx,%edx
  803a94:	83 c4 1c             	add    $0x1c,%esp
  803a97:	5b                   	pop    %ebx
  803a98:	5e                   	pop    %esi
  803a99:	5f                   	pop    %edi
  803a9a:	5d                   	pop    %ebp
  803a9b:	c3                   	ret    
  803a9c:	39 f0                	cmp    %esi,%eax
  803a9e:	0f 87 ac 00 00 00    	ja     803b50 <__umoddi3+0xfc>
  803aa4:	0f bd e8             	bsr    %eax,%ebp
  803aa7:	83 f5 1f             	xor    $0x1f,%ebp
  803aaa:	0f 84 ac 00 00 00    	je     803b5c <__umoddi3+0x108>
  803ab0:	bf 20 00 00 00       	mov    $0x20,%edi
  803ab5:	29 ef                	sub    %ebp,%edi
  803ab7:	89 fe                	mov    %edi,%esi
  803ab9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803abd:	89 e9                	mov    %ebp,%ecx
  803abf:	d3 e0                	shl    %cl,%eax
  803ac1:	89 d7                	mov    %edx,%edi
  803ac3:	89 f1                	mov    %esi,%ecx
  803ac5:	d3 ef                	shr    %cl,%edi
  803ac7:	09 c7                	or     %eax,%edi
  803ac9:	89 e9                	mov    %ebp,%ecx
  803acb:	d3 e2                	shl    %cl,%edx
  803acd:	89 14 24             	mov    %edx,(%esp)
  803ad0:	89 d8                	mov    %ebx,%eax
  803ad2:	d3 e0                	shl    %cl,%eax
  803ad4:	89 c2                	mov    %eax,%edx
  803ad6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ada:	d3 e0                	shl    %cl,%eax
  803adc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ae0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ae4:	89 f1                	mov    %esi,%ecx
  803ae6:	d3 e8                	shr    %cl,%eax
  803ae8:	09 d0                	or     %edx,%eax
  803aea:	d3 eb                	shr    %cl,%ebx
  803aec:	89 da                	mov    %ebx,%edx
  803aee:	f7 f7                	div    %edi
  803af0:	89 d3                	mov    %edx,%ebx
  803af2:	f7 24 24             	mull   (%esp)
  803af5:	89 c6                	mov    %eax,%esi
  803af7:	89 d1                	mov    %edx,%ecx
  803af9:	39 d3                	cmp    %edx,%ebx
  803afb:	0f 82 87 00 00 00    	jb     803b88 <__umoddi3+0x134>
  803b01:	0f 84 91 00 00 00    	je     803b98 <__umoddi3+0x144>
  803b07:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b0b:	29 f2                	sub    %esi,%edx
  803b0d:	19 cb                	sbb    %ecx,%ebx
  803b0f:	89 d8                	mov    %ebx,%eax
  803b11:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b15:	d3 e0                	shl    %cl,%eax
  803b17:	89 e9                	mov    %ebp,%ecx
  803b19:	d3 ea                	shr    %cl,%edx
  803b1b:	09 d0                	or     %edx,%eax
  803b1d:	89 e9                	mov    %ebp,%ecx
  803b1f:	d3 eb                	shr    %cl,%ebx
  803b21:	89 da                	mov    %ebx,%edx
  803b23:	83 c4 1c             	add    $0x1c,%esp
  803b26:	5b                   	pop    %ebx
  803b27:	5e                   	pop    %esi
  803b28:	5f                   	pop    %edi
  803b29:	5d                   	pop    %ebp
  803b2a:	c3                   	ret    
  803b2b:	90                   	nop
  803b2c:	89 fd                	mov    %edi,%ebp
  803b2e:	85 ff                	test   %edi,%edi
  803b30:	75 0b                	jne    803b3d <__umoddi3+0xe9>
  803b32:	b8 01 00 00 00       	mov    $0x1,%eax
  803b37:	31 d2                	xor    %edx,%edx
  803b39:	f7 f7                	div    %edi
  803b3b:	89 c5                	mov    %eax,%ebp
  803b3d:	89 f0                	mov    %esi,%eax
  803b3f:	31 d2                	xor    %edx,%edx
  803b41:	f7 f5                	div    %ebp
  803b43:	89 c8                	mov    %ecx,%eax
  803b45:	f7 f5                	div    %ebp
  803b47:	89 d0                	mov    %edx,%eax
  803b49:	e9 44 ff ff ff       	jmp    803a92 <__umoddi3+0x3e>
  803b4e:	66 90                	xchg   %ax,%ax
  803b50:	89 c8                	mov    %ecx,%eax
  803b52:	89 f2                	mov    %esi,%edx
  803b54:	83 c4 1c             	add    $0x1c,%esp
  803b57:	5b                   	pop    %ebx
  803b58:	5e                   	pop    %esi
  803b59:	5f                   	pop    %edi
  803b5a:	5d                   	pop    %ebp
  803b5b:	c3                   	ret    
  803b5c:	3b 04 24             	cmp    (%esp),%eax
  803b5f:	72 06                	jb     803b67 <__umoddi3+0x113>
  803b61:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b65:	77 0f                	ja     803b76 <__umoddi3+0x122>
  803b67:	89 f2                	mov    %esi,%edx
  803b69:	29 f9                	sub    %edi,%ecx
  803b6b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b6f:	89 14 24             	mov    %edx,(%esp)
  803b72:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b76:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b7a:	8b 14 24             	mov    (%esp),%edx
  803b7d:	83 c4 1c             	add    $0x1c,%esp
  803b80:	5b                   	pop    %ebx
  803b81:	5e                   	pop    %esi
  803b82:	5f                   	pop    %edi
  803b83:	5d                   	pop    %ebp
  803b84:	c3                   	ret    
  803b85:	8d 76 00             	lea    0x0(%esi),%esi
  803b88:	2b 04 24             	sub    (%esp),%eax
  803b8b:	19 fa                	sbb    %edi,%edx
  803b8d:	89 d1                	mov    %edx,%ecx
  803b8f:	89 c6                	mov    %eax,%esi
  803b91:	e9 71 ff ff ff       	jmp    803b07 <__umoddi3+0xb3>
  803b96:	66 90                	xchg   %ax,%ax
  803b98:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b9c:	72 ea                	jb     803b88 <__umoddi3+0x134>
  803b9e:	89 d9                	mov    %ebx,%ecx
  803ba0:	e9 62 ff ff ff       	jmp    803b07 <__umoddi3+0xb3>
