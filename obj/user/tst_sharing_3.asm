
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
  80005b:	68 00 3c 80 00       	push   $0x803c00
  800060:	6a 0c                	push   $0xc
  800062:	68 1c 3c 80 00       	push   $0x803c1c
  800067:	e8 4e 03 00 00       	call   8003ba <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	cprintf("************************************************\n");
  80006c:	83 ec 0c             	sub    $0xc,%esp
  80006f:	68 34 3c 80 00       	push   $0x803c34
  800074:	e8 fe 05 00 00       	call   800677 <cprintf>
  800079:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	68 68 3c 80 00       	push   $0x803c68
  800084:	e8 ee 05 00 00       	call   800677 <cprintf>
  800089:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 c4 3c 80 00       	push   $0x803cc4
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
  8000b4:	68 f8 3c 80 00       	push   $0x803cf8
  8000b9:	e8 b9 05 00 00       	call   800677 <cprintf>
  8000be:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 01                	push   $0x1
  8000c6:	68 00 10 00 00       	push   $0x1000
  8000cb:	68 46 3d 80 00       	push   $0x803d46
  8000d0:	e8 6f 16 00 00       	call   801744 <smalloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000db:	e8 19 19 00 00       	call   8019f9 <sys_calculate_free_frames>
  8000e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000e3:	83 ec 04             	sub    $0x4,%esp
  8000e6:	6a 01                	push   $0x1
  8000e8:	68 00 10 00 00       	push   $0x1000
  8000ed:	68 46 3d 80 00       	push   $0x803d46
  8000f2:	e8 4d 16 00 00       	call   801744 <smalloc>
  8000f7:	83 c4 10             	add    $0x10,%esp
  8000fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) {is_correct = 0; cprintf("Trying to create an already exists object and corresponding error is not returned!!");}
  8000fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800101:	74 17                	je     80011a <_main+0xe2>
  800103:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	68 48 3d 80 00       	push   $0x803d48
  800112:	e8 60 05 00 00       	call   800677 <cprintf>
  800117:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");}
  80011a:	e8 da 18 00 00       	call   8019f9 <sys_calculate_free_frames>
  80011f:	89 c2                	mov    %eax,%edx
  800121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800124:	39 c2                	cmp    %eax,%edx
  800126:	74 17                	je     80013f <_main+0x107>
  800128:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 9c 3d 80 00       	push   $0x803d9c
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
  800153:	68 f8 3d 80 00       	push   $0x803df8
  800158:	e8 1a 05 00 00       	call   800677 <cprintf>
  80015d:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		x = sget(myEnv->env_id, "xx");
  800160:	a1 20 50 80 00       	mov    0x805020,%eax
  800165:	8b 40 10             	mov    0x10(%eax),%eax
  800168:	83 ec 08             	sub    $0x8,%esp
  80016b:	68 3d 3e 80 00       	push   $0x803e3d
  800170:	50                   	push   %eax
  800171:	e8 4d 16 00 00       	call   8017c3 <sget>
  800176:	83 c4 10             	add    $0x10,%esp
  800179:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  80017c:	e8 78 18 00 00       	call   8019f9 <sys_calculate_free_frames>
  800181:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != NULL) {is_correct = 0; cprintf("Trying to get a NON existing object and corresponding error is not returned!!");}
  800184:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800188:	74 17                	je     8001a1 <_main+0x169>
  80018a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800191:	83 ec 0c             	sub    $0xc,%esp
  800194:	68 40 3e 80 00       	push   $0x803e40
  800199:	e8 d9 04 00 00       	call   800677 <cprintf>
  80019e:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong get: make sure that you don't allocate any memory if the shared object not exists");}
  8001a1:	e8 53 18 00 00       	call   8019f9 <sys_calculate_free_frames>
  8001a6:	89 c2                	mov    %eax,%edx
  8001a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ab:	39 c2                	cmp    %eax,%edx
  8001ad:	74 17                	je     8001c6 <_main+0x18e>
  8001af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	68 90 3e 80 00       	push   $0x803e90
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
  8001da:	68 e8 3e 80 00       	push   $0x803ee8
  8001df:	e8 93 04 00 00       	call   800677 <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8001e7:	e8 0d 18 00 00       	call   8019f9 <sys_calculate_free_frames>
  8001ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uint32 size = USER_HEAP_MAX - pagealloc_start - PAGE_SIZE + 1;
  8001ef:	b8 01 f0 ff 9f       	mov    $0x9ffff001,%eax
  8001f4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8001f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		y = smalloc("y", size, 1);
  8001fa:	83 ec 04             	sub    $0x4,%esp
  8001fd:	6a 01                	push   $0x1
  8001ff:	ff 75 d8             	pushl  -0x28(%ebp)
  800202:	68 45 3f 80 00       	push   $0x803f45
  800207:	e8 38 15 00 00       	call   801744 <smalloc>
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (y != NULL) {is_correct = 0; cprintf("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");}
  800212:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800216:	74 17                	je     80022f <_main+0x1f7>
  800218:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	68 48 3f 80 00       	push   $0x803f48
  800227:	e8 4b 04 00 00       	call   800677 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");}
  80022f:	e8 c5 17 00 00       	call   8019f9 <sys_calculate_free_frames>
  800234:	89 c2                	mov    %eax,%edx
  800236:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800239:	39 c2                	cmp    %eax,%edx
  80023b:	74 17                	je     800254 <_main+0x21c>
  80023d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 bc 3f 80 00       	push   $0x803fbc
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
  80026b:	68 30 40 80 00       	push   $0x804030
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
  800281:	e8 3c 19 00 00       	call   801bc2 <sys_getenvindex>
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
  8002ef:	e8 52 16 00 00       	call   801946 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 9c 40 80 00       	push   $0x80409c
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
  80031f:	68 c4 40 80 00       	push   $0x8040c4
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
  800350:	68 ec 40 80 00       	push   $0x8040ec
  800355:	e8 1d 03 00 00       	call   800677 <cprintf>
  80035a:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80035d:	a1 20 50 80 00       	mov    0x805020,%eax
  800362:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800368:	83 ec 08             	sub    $0x8,%esp
  80036b:	50                   	push   %eax
  80036c:	68 44 41 80 00       	push   $0x804144
  800371:	e8 01 03 00 00       	call   800677 <cprintf>
  800376:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800379:	83 ec 0c             	sub    $0xc,%esp
  80037c:	68 9c 40 80 00       	push   $0x80409c
  800381:	e8 f1 02 00 00       	call   800677 <cprintf>
  800386:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800389:	e8 d2 15 00 00       	call   801960 <sys_unlock_cons>
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
  8003a1:	e8 e8 17 00 00       	call   801b8e <sys_destroy_env>
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
  8003b2:	e8 3d 18 00 00       	call   801bf4 <sys_exit_env>
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
  8003db:	68 58 41 80 00       	push   $0x804158
  8003e0:	e8 92 02 00 00       	call   800677 <cprintf>
  8003e5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003e8:	a1 00 50 80 00       	mov    0x805000,%eax
  8003ed:	ff 75 0c             	pushl  0xc(%ebp)
  8003f0:	ff 75 08             	pushl  0x8(%ebp)
  8003f3:	50                   	push   %eax
  8003f4:	68 5d 41 80 00       	push   $0x80415d
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
  800418:	68 79 41 80 00       	push   $0x804179
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
  800447:	68 7c 41 80 00       	push   $0x80417c
  80044c:	6a 26                	push   $0x26
  80044e:	68 c8 41 80 00       	push   $0x8041c8
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
  80051c:	68 d4 41 80 00       	push   $0x8041d4
  800521:	6a 3a                	push   $0x3a
  800523:	68 c8 41 80 00       	push   $0x8041c8
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
  80058f:	68 28 42 80 00       	push   $0x804228
  800594:	6a 44                	push   $0x44
  800596:	68 c8 41 80 00       	push   $0x8041c8
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
  8005e9:	e8 16 13 00 00       	call   801904 <sys_cputs>
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
  800660:	e8 9f 12 00 00       	call   801904 <sys_cputs>
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
  8006aa:	e8 97 12 00 00       	call   801946 <sys_lock_cons>
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
  8006ca:	e8 91 12 00 00       	call   801960 <sys_unlock_cons>
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
  800714:	e8 83 32 00 00       	call   80399c <__udivdi3>
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
  800764:	e8 43 33 00 00       	call   803aac <__umoddi3>
  800769:	83 c4 10             	add    $0x10,%esp
  80076c:	05 94 44 80 00       	add    $0x804494,%eax
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
  8008bf:	8b 04 85 b8 44 80 00 	mov    0x8044b8(,%eax,4),%eax
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
  8009a0:	8b 34 9d 00 43 80 00 	mov    0x804300(,%ebx,4),%esi
  8009a7:	85 f6                	test   %esi,%esi
  8009a9:	75 19                	jne    8009c4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009ab:	53                   	push   %ebx
  8009ac:	68 a5 44 80 00       	push   $0x8044a5
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
  8009c5:	68 ae 44 80 00       	push   $0x8044ae
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
  8009f2:	be b1 44 80 00       	mov    $0x8044b1,%esi
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
  8013fd:	68 28 46 80 00       	push   $0x804628
  801402:	68 3f 01 00 00       	push   $0x13f
  801407:	68 4a 46 80 00       	push   $0x80464a
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
  80141d:	e8 8d 0a 00 00       	call   801eaf <sys_sbrk>
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
  801498:	e8 96 08 00 00       	call   801d33 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80149d:	85 c0                	test   %eax,%eax
  80149f:	74 16                	je     8014b7 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8014a1:	83 ec 0c             	sub    $0xc,%esp
  8014a4:	ff 75 08             	pushl  0x8(%ebp)
  8014a7:	e8 d6 0d 00 00       	call   802282 <alloc_block_FF>
  8014ac:	83 c4 10             	add    $0x10,%esp
  8014af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014b2:	e9 8a 01 00 00       	jmp    801641 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014b7:	e8 a8 08 00 00       	call   801d64 <sys_isUHeapPlacementStrategyBESTFIT>
  8014bc:	85 c0                	test   %eax,%eax
  8014be:	0f 84 7d 01 00 00    	je     801641 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014c4:	83 ec 0c             	sub    $0xc,%esp
  8014c7:	ff 75 08             	pushl  0x8(%ebp)
  8014ca:	e8 6f 12 00 00       	call   80273e <alloc_block_BF>
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
  801630:	e8 b1 08 00 00       	call   801ee6 <sys_allocate_user_mem>
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
  801678:	e8 85 08 00 00       	call   801f02 <get_block_size>
  80167d:	83 c4 10             	add    $0x10,%esp
  801680:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801683:	83 ec 0c             	sub    $0xc,%esp
  801686:	ff 75 08             	pushl  0x8(%ebp)
  801689:	e8 b8 1a 00 00       	call   803146 <free_block>
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
  801720:	e8 a5 07 00 00       	call   801eca <sys_free_user_mem>
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
  80172e:	68 58 46 80 00       	push   $0x804658
  801733:	68 84 00 00 00       	push   $0x84
  801738:	68 82 46 80 00       	push   $0x804682
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
  80175b:	eb 64                	jmp    8017c1 <smalloc+0x7d>
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
  801790:	eb 2f                	jmp    8017c1 <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801792:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801796:	ff 75 ec             	pushl  -0x14(%ebp)
  801799:	50                   	push   %eax
  80179a:	ff 75 0c             	pushl  0xc(%ebp)
  80179d:	ff 75 08             	pushl  0x8(%ebp)
  8017a0:	e8 2c 03 00 00       	call   801ad1 <sys_createSharedObject>
  8017a5:	83 c4 10             	add    $0x10,%esp
  8017a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8017ab:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8017af:	74 06                	je     8017b7 <smalloc+0x73>
  8017b1:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8017b5:	75 07                	jne    8017be <smalloc+0x7a>
  8017b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017bc:	eb 03                	jmp    8017c1 <smalloc+0x7d>
	 return ptr;
  8017be:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017c9:	83 ec 08             	sub    $0x8,%esp
  8017cc:	ff 75 0c             	pushl  0xc(%ebp)
  8017cf:	ff 75 08             	pushl  0x8(%ebp)
  8017d2:	e8 24 03 00 00       	call   801afb <sys_getSizeOfSharedObject>
  8017d7:	83 c4 10             	add    $0x10,%esp
  8017da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8017dd:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8017e1:	75 07                	jne    8017ea <sget+0x27>
  8017e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e8:	eb 5c                	jmp    801846 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8017ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017f0:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8017f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017fd:	39 d0                	cmp    %edx,%eax
  8017ff:	7d 02                	jge    801803 <sget+0x40>
  801801:	89 d0                	mov    %edx,%eax
  801803:	83 ec 0c             	sub    $0xc,%esp
  801806:	50                   	push   %eax
  801807:	e8 1b fc ff ff       	call   801427 <malloc>
  80180c:	83 c4 10             	add    $0x10,%esp
  80180f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801812:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801816:	75 07                	jne    80181f <sget+0x5c>
  801818:	b8 00 00 00 00       	mov    $0x0,%eax
  80181d:	eb 27                	jmp    801846 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80181f:	83 ec 04             	sub    $0x4,%esp
  801822:	ff 75 e8             	pushl  -0x18(%ebp)
  801825:	ff 75 0c             	pushl  0xc(%ebp)
  801828:	ff 75 08             	pushl  0x8(%ebp)
  80182b:	e8 e8 02 00 00       	call   801b18 <sys_getSharedObject>
  801830:	83 c4 10             	add    $0x10,%esp
  801833:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801836:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80183a:	75 07                	jne    801843 <sget+0x80>
  80183c:	b8 00 00 00 00       	mov    $0x0,%eax
  801841:	eb 03                	jmp    801846 <sget+0x83>
	return ptr;
  801843:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80184e:	83 ec 04             	sub    $0x4,%esp
  801851:	68 90 46 80 00       	push   $0x804690
  801856:	68 c1 00 00 00       	push   $0xc1
  80185b:	68 82 46 80 00       	push   $0x804682
  801860:	e8 55 eb ff ff       	call   8003ba <_panic>

00801865 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
  801868:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80186b:	83 ec 04             	sub    $0x4,%esp
  80186e:	68 b4 46 80 00       	push   $0x8046b4
  801873:	68 d8 00 00 00       	push   $0xd8
  801878:	68 82 46 80 00       	push   $0x804682
  80187d:	e8 38 eb ff ff       	call   8003ba <_panic>

00801882 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801888:	83 ec 04             	sub    $0x4,%esp
  80188b:	68 da 46 80 00       	push   $0x8046da
  801890:	68 e4 00 00 00       	push   $0xe4
  801895:	68 82 46 80 00       	push   $0x804682
  80189a:	e8 1b eb ff ff       	call   8003ba <_panic>

0080189f <shrink>:

}
void shrink(uint32 newSize)
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
  8018a2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018a5:	83 ec 04             	sub    $0x4,%esp
  8018a8:	68 da 46 80 00       	push   $0x8046da
  8018ad:	68 e9 00 00 00       	push   $0xe9
  8018b2:	68 82 46 80 00       	push   $0x804682
  8018b7:	e8 fe ea ff ff       	call   8003ba <_panic>

008018bc <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018c2:	83 ec 04             	sub    $0x4,%esp
  8018c5:	68 da 46 80 00       	push   $0x8046da
  8018ca:	68 ee 00 00 00       	push   $0xee
  8018cf:	68 82 46 80 00       	push   $0x804682
  8018d4:	e8 e1 ea ff ff       	call   8003ba <_panic>

008018d9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	57                   	push   %edi
  8018dd:	56                   	push   %esi
  8018de:	53                   	push   %ebx
  8018df:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018eb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ee:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018f1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018f4:	cd 30                	int    $0x30
  8018f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018fc:	83 c4 10             	add    $0x10,%esp
  8018ff:	5b                   	pop    %ebx
  801900:	5e                   	pop    %esi
  801901:	5f                   	pop    %edi
  801902:	5d                   	pop    %ebp
  801903:	c3                   	ret    

00801904 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
  801907:	83 ec 04             	sub    $0x4,%esp
  80190a:	8b 45 10             	mov    0x10(%ebp),%eax
  80190d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801910:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801914:	8b 45 08             	mov    0x8(%ebp),%eax
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	52                   	push   %edx
  80191c:	ff 75 0c             	pushl  0xc(%ebp)
  80191f:	50                   	push   %eax
  801920:	6a 00                	push   $0x0
  801922:	e8 b2 ff ff ff       	call   8018d9 <syscall>
  801927:	83 c4 18             	add    $0x18,%esp
}
  80192a:	90                   	nop
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <sys_cgetc>:

int
sys_cgetc(void)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 02                	push   $0x2
  80193c:	e8 98 ff ff ff       	call   8018d9 <syscall>
  801941:	83 c4 18             	add    $0x18,%esp
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 03                	push   $0x3
  801955:	e8 7f ff ff ff       	call   8018d9 <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
}
  80195d:	90                   	nop
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 04                	push   $0x4
  80196f:	e8 65 ff ff ff       	call   8018d9 <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
}
  801977:	90                   	nop
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80197d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801980:	8b 45 08             	mov    0x8(%ebp),%eax
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	52                   	push   %edx
  80198a:	50                   	push   %eax
  80198b:	6a 08                	push   $0x8
  80198d:	e8 47 ff ff ff       	call   8018d9 <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	56                   	push   %esi
  80199b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80199c:	8b 75 18             	mov    0x18(%ebp),%esi
  80199f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	56                   	push   %esi
  8019ac:	53                   	push   %ebx
  8019ad:	51                   	push   %ecx
  8019ae:	52                   	push   %edx
  8019af:	50                   	push   %eax
  8019b0:	6a 09                	push   $0x9
  8019b2:	e8 22 ff ff ff       	call   8018d9 <syscall>
  8019b7:	83 c4 18             	add    $0x18,%esp
}
  8019ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019bd:	5b                   	pop    %ebx
  8019be:	5e                   	pop    %esi
  8019bf:	5d                   	pop    %ebp
  8019c0:	c3                   	ret    

008019c1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	52                   	push   %edx
  8019d1:	50                   	push   %eax
  8019d2:	6a 0a                	push   $0xa
  8019d4:	e8 00 ff ff ff       	call   8018d9 <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
}
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ea:	ff 75 08             	pushl  0x8(%ebp)
  8019ed:	6a 0b                	push   $0xb
  8019ef:	e8 e5 fe ff ff       	call   8018d9 <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 0c                	push   $0xc
  801a08:	e8 cc fe ff ff       	call   8018d9 <syscall>
  801a0d:	83 c4 18             	add    $0x18,%esp
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 0d                	push   $0xd
  801a21:	e8 b3 fe ff ff       	call   8018d9 <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 0e                	push   $0xe
  801a3a:	e8 9a fe ff ff       	call   8018d9 <syscall>
  801a3f:	83 c4 18             	add    $0x18,%esp
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 0f                	push   $0xf
  801a53:	e8 81 fe ff ff       	call   8018d9 <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	ff 75 08             	pushl  0x8(%ebp)
  801a6b:	6a 10                	push   $0x10
  801a6d:	e8 67 fe ff ff       	call   8018d9 <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
}
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 11                	push   $0x11
  801a86:	e8 4e fe ff ff       	call   8018d9 <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
}
  801a8e:	90                   	nop
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_cputc>:

void
sys_cputc(const char c)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
  801a94:	83 ec 04             	sub    $0x4,%esp
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a9d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	50                   	push   %eax
  801aaa:	6a 01                	push   $0x1
  801aac:	e8 28 fe ff ff       	call   8018d9 <syscall>
  801ab1:	83 c4 18             	add    $0x18,%esp
}
  801ab4:	90                   	nop
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 14                	push   $0x14
  801ac6:	e8 0e fe ff ff       	call   8018d9 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	90                   	nop
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	83 ec 04             	sub    $0x4,%esp
  801ad7:	8b 45 10             	mov    0x10(%ebp),%eax
  801ada:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801add:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ae0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae7:	6a 00                	push   $0x0
  801ae9:	51                   	push   %ecx
  801aea:	52                   	push   %edx
  801aeb:	ff 75 0c             	pushl  0xc(%ebp)
  801aee:	50                   	push   %eax
  801aef:	6a 15                	push   $0x15
  801af1:	e8 e3 fd ff ff       	call   8018d9 <syscall>
  801af6:	83 c4 18             	add    $0x18,%esp
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801afe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	52                   	push   %edx
  801b0b:	50                   	push   %eax
  801b0c:	6a 16                	push   $0x16
  801b0e:	e8 c6 fd ff ff       	call   8018d9 <syscall>
  801b13:	83 c4 18             	add    $0x18,%esp
}
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b1b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b21:	8b 45 08             	mov    0x8(%ebp),%eax
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	51                   	push   %ecx
  801b29:	52                   	push   %edx
  801b2a:	50                   	push   %eax
  801b2b:	6a 17                	push   $0x17
  801b2d:	e8 a7 fd ff ff       	call   8018d9 <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	52                   	push   %edx
  801b47:	50                   	push   %eax
  801b48:	6a 18                	push   $0x18
  801b4a:	e8 8a fd ff ff       	call   8018d9 <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5a:	6a 00                	push   $0x0
  801b5c:	ff 75 14             	pushl  0x14(%ebp)
  801b5f:	ff 75 10             	pushl  0x10(%ebp)
  801b62:	ff 75 0c             	pushl  0xc(%ebp)
  801b65:	50                   	push   %eax
  801b66:	6a 19                	push   $0x19
  801b68:	e8 6c fd ff ff       	call   8018d9 <syscall>
  801b6d:	83 c4 18             	add    $0x18,%esp
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b75:	8b 45 08             	mov    0x8(%ebp),%eax
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	50                   	push   %eax
  801b81:	6a 1a                	push   $0x1a
  801b83:	e8 51 fd ff ff       	call   8018d9 <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
}
  801b8b:	90                   	nop
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	50                   	push   %eax
  801b9d:	6a 1b                	push   $0x1b
  801b9f:	e8 35 fd ff ff       	call   8018d9 <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 05                	push   $0x5
  801bb8:	e8 1c fd ff ff       	call   8018d9 <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
}
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 06                	push   $0x6
  801bd1:	e8 03 fd ff ff       	call   8018d9 <syscall>
  801bd6:	83 c4 18             	add    $0x18,%esp
}
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 07                	push   $0x7
  801bea:	e8 ea fc ff ff       	call   8018d9 <syscall>
  801bef:	83 c4 18             	add    $0x18,%esp
}
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <sys_exit_env>:


void sys_exit_env(void)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 1c                	push   $0x1c
  801c03:	e8 d1 fc ff ff       	call   8018d9 <syscall>
  801c08:	83 c4 18             	add    $0x18,%esp
}
  801c0b:	90                   	nop
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c14:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c17:	8d 50 04             	lea    0x4(%eax),%edx
  801c1a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	52                   	push   %edx
  801c24:	50                   	push   %eax
  801c25:	6a 1d                	push   $0x1d
  801c27:	e8 ad fc ff ff       	call   8018d9 <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
	return result;
  801c2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c32:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c35:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c38:	89 01                	mov    %eax,(%ecx)
  801c3a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	c9                   	leave  
  801c41:	c2 04 00             	ret    $0x4

00801c44 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	ff 75 10             	pushl  0x10(%ebp)
  801c4e:	ff 75 0c             	pushl  0xc(%ebp)
  801c51:	ff 75 08             	pushl  0x8(%ebp)
  801c54:	6a 13                	push   $0x13
  801c56:	e8 7e fc ff ff       	call   8018d9 <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5e:	90                   	nop
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 1e                	push   $0x1e
  801c70:	e8 64 fc ff ff       	call   8018d9 <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	83 ec 04             	sub    $0x4,%esp
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c86:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	50                   	push   %eax
  801c93:	6a 1f                	push   $0x1f
  801c95:	e8 3f fc ff ff       	call   8018d9 <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9d:	90                   	nop
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <rsttst>:
void rsttst()
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 21                	push   $0x21
  801caf:	e8 25 fc ff ff       	call   8018d9 <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb7:	90                   	nop
}
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	83 ec 04             	sub    $0x4,%esp
  801cc0:	8b 45 14             	mov    0x14(%ebp),%eax
  801cc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cc6:	8b 55 18             	mov    0x18(%ebp),%edx
  801cc9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ccd:	52                   	push   %edx
  801cce:	50                   	push   %eax
  801ccf:	ff 75 10             	pushl  0x10(%ebp)
  801cd2:	ff 75 0c             	pushl  0xc(%ebp)
  801cd5:	ff 75 08             	pushl  0x8(%ebp)
  801cd8:	6a 20                	push   $0x20
  801cda:	e8 fa fb ff ff       	call   8018d9 <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce2:	90                   	nop
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <chktst>:
void chktst(uint32 n)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	ff 75 08             	pushl  0x8(%ebp)
  801cf3:	6a 22                	push   $0x22
  801cf5:	e8 df fb ff ff       	call   8018d9 <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfd:	90                   	nop
}
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <inctst>:

void inctst()
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 23                	push   $0x23
  801d0f:	e8 c5 fb ff ff       	call   8018d9 <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
	return ;
  801d17:	90                   	nop
}
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <gettst>:
uint32 gettst()
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 24                	push   $0x24
  801d29:	e8 ab fb ff ff       	call   8018d9 <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 25                	push   $0x25
  801d45:	e8 8f fb ff ff       	call   8018d9 <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
  801d4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d50:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d54:	75 07                	jne    801d5d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d56:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5b:	eb 05                	jmp    801d62 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
  801d67:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 25                	push   $0x25
  801d76:	e8 5e fb ff ff       	call   8018d9 <syscall>
  801d7b:	83 c4 18             	add    $0x18,%esp
  801d7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d81:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d85:	75 07                	jne    801d8e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d87:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8c:	eb 05                	jmp    801d93 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 25                	push   $0x25
  801da7:	e8 2d fb ff ff       	call   8018d9 <syscall>
  801dac:	83 c4 18             	add    $0x18,%esp
  801daf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801db2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801db6:	75 07                	jne    801dbf <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801db8:	b8 01 00 00 00       	mov    $0x1,%eax
  801dbd:	eb 05                	jmp    801dc4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    

00801dc6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
  801dc9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 25                	push   $0x25
  801dd8:	e8 fc fa ff ff       	call   8018d9 <syscall>
  801ddd:	83 c4 18             	add    $0x18,%esp
  801de0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801de3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801de7:	75 07                	jne    801df0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801de9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dee:	eb 05                	jmp    801df5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801df0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	ff 75 08             	pushl  0x8(%ebp)
  801e05:	6a 26                	push   $0x26
  801e07:	e8 cd fa ff ff       	call   8018d9 <syscall>
  801e0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0f:	90                   	nop
}
  801e10:	c9                   	leave  
  801e11:	c3                   	ret    

00801e12 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e16:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e19:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e22:	6a 00                	push   $0x0
  801e24:	53                   	push   %ebx
  801e25:	51                   	push   %ecx
  801e26:	52                   	push   %edx
  801e27:	50                   	push   %eax
  801e28:	6a 27                	push   $0x27
  801e2a:	e8 aa fa ff ff       	call   8018d9 <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
}
  801e32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e35:	c9                   	leave  
  801e36:	c3                   	ret    

00801e37 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	52                   	push   %edx
  801e47:	50                   	push   %eax
  801e48:	6a 28                	push   $0x28
  801e4a:	e8 8a fa ff ff       	call   8018d9 <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e57:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	6a 00                	push   $0x0
  801e62:	51                   	push   %ecx
  801e63:	ff 75 10             	pushl  0x10(%ebp)
  801e66:	52                   	push   %edx
  801e67:	50                   	push   %eax
  801e68:	6a 29                	push   $0x29
  801e6a:	e8 6a fa ff ff       	call   8018d9 <syscall>
  801e6f:	83 c4 18             	add    $0x18,%esp
}
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	ff 75 10             	pushl  0x10(%ebp)
  801e7e:	ff 75 0c             	pushl  0xc(%ebp)
  801e81:	ff 75 08             	pushl  0x8(%ebp)
  801e84:	6a 12                	push   $0x12
  801e86:	e8 4e fa ff ff       	call   8018d9 <syscall>
  801e8b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e8e:	90                   	nop
}
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801e94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e97:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	52                   	push   %edx
  801ea1:	50                   	push   %eax
  801ea2:	6a 2a                	push   $0x2a
  801ea4:	e8 30 fa ff ff       	call   8018d9 <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
	return;
  801eac:	90                   	nop
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	50                   	push   %eax
  801ebe:	6a 2b                	push   $0x2b
  801ec0:	e8 14 fa ff ff       	call   8018d9 <syscall>
  801ec5:	83 c4 18             	add    $0x18,%esp
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	ff 75 0c             	pushl  0xc(%ebp)
  801ed6:	ff 75 08             	pushl  0x8(%ebp)
  801ed9:	6a 2c                	push   $0x2c
  801edb:	e8 f9 f9 ff ff       	call   8018d9 <syscall>
  801ee0:	83 c4 18             	add    $0x18,%esp
	return;
  801ee3:	90                   	nop
}
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	ff 75 0c             	pushl  0xc(%ebp)
  801ef2:	ff 75 08             	pushl  0x8(%ebp)
  801ef5:	6a 2d                	push   $0x2d
  801ef7:	e8 dd f9 ff ff       	call   8018d9 <syscall>
  801efc:	83 c4 18             	add    $0x18,%esp
	return;
  801eff:	90                   	nop
}
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
  801f05:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f08:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0b:	83 e8 04             	sub    $0x4,%eax
  801f0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f11:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f14:	8b 00                	mov    (%eax),%eax
  801f16:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
  801f1e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f21:	8b 45 08             	mov    0x8(%ebp),%eax
  801f24:	83 e8 04             	sub    $0x4,%eax
  801f27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f2d:	8b 00                	mov    (%eax),%eax
  801f2f:	83 e0 01             	and    $0x1,%eax
  801f32:	85 c0                	test   %eax,%eax
  801f34:	0f 94 c0             	sete   %al
}
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    

00801f39 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
  801f3c:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f49:	83 f8 02             	cmp    $0x2,%eax
  801f4c:	74 2b                	je     801f79 <alloc_block+0x40>
  801f4e:	83 f8 02             	cmp    $0x2,%eax
  801f51:	7f 07                	jg     801f5a <alloc_block+0x21>
  801f53:	83 f8 01             	cmp    $0x1,%eax
  801f56:	74 0e                	je     801f66 <alloc_block+0x2d>
  801f58:	eb 58                	jmp    801fb2 <alloc_block+0x79>
  801f5a:	83 f8 03             	cmp    $0x3,%eax
  801f5d:	74 2d                	je     801f8c <alloc_block+0x53>
  801f5f:	83 f8 04             	cmp    $0x4,%eax
  801f62:	74 3b                	je     801f9f <alloc_block+0x66>
  801f64:	eb 4c                	jmp    801fb2 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f66:	83 ec 0c             	sub    $0xc,%esp
  801f69:	ff 75 08             	pushl  0x8(%ebp)
  801f6c:	e8 11 03 00 00       	call   802282 <alloc_block_FF>
  801f71:	83 c4 10             	add    $0x10,%esp
  801f74:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f77:	eb 4a                	jmp    801fc3 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f79:	83 ec 0c             	sub    $0xc,%esp
  801f7c:	ff 75 08             	pushl  0x8(%ebp)
  801f7f:	e8 fa 19 00 00       	call   80397e <alloc_block_NF>
  801f84:	83 c4 10             	add    $0x10,%esp
  801f87:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f8a:	eb 37                	jmp    801fc3 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f8c:	83 ec 0c             	sub    $0xc,%esp
  801f8f:	ff 75 08             	pushl  0x8(%ebp)
  801f92:	e8 a7 07 00 00       	call   80273e <alloc_block_BF>
  801f97:	83 c4 10             	add    $0x10,%esp
  801f9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f9d:	eb 24                	jmp    801fc3 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f9f:	83 ec 0c             	sub    $0xc,%esp
  801fa2:	ff 75 08             	pushl  0x8(%ebp)
  801fa5:	e8 b7 19 00 00       	call   803961 <alloc_block_WF>
  801faa:	83 c4 10             	add    $0x10,%esp
  801fad:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fb0:	eb 11                	jmp    801fc3 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801fb2:	83 ec 0c             	sub    $0xc,%esp
  801fb5:	68 ec 46 80 00       	push   $0x8046ec
  801fba:	e8 b8 e6 ff ff       	call   800677 <cprintf>
  801fbf:	83 c4 10             	add    $0x10,%esp
		break;
  801fc2:	90                   	nop
	}
	return va;
  801fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801fc6:	c9                   	leave  
  801fc7:	c3                   	ret    

00801fc8 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
  801fcb:	53                   	push   %ebx
  801fcc:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801fcf:	83 ec 0c             	sub    $0xc,%esp
  801fd2:	68 0c 47 80 00       	push   $0x80470c
  801fd7:	e8 9b e6 ff ff       	call   800677 <cprintf>
  801fdc:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801fdf:	83 ec 0c             	sub    $0xc,%esp
  801fe2:	68 37 47 80 00       	push   $0x804737
  801fe7:	e8 8b e6 ff ff       	call   800677 <cprintf>
  801fec:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801fef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff5:	eb 37                	jmp    80202e <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801ff7:	83 ec 0c             	sub    $0xc,%esp
  801ffa:	ff 75 f4             	pushl  -0xc(%ebp)
  801ffd:	e8 19 ff ff ff       	call   801f1b <is_free_block>
  802002:	83 c4 10             	add    $0x10,%esp
  802005:	0f be d8             	movsbl %al,%ebx
  802008:	83 ec 0c             	sub    $0xc,%esp
  80200b:	ff 75 f4             	pushl  -0xc(%ebp)
  80200e:	e8 ef fe ff ff       	call   801f02 <get_block_size>
  802013:	83 c4 10             	add    $0x10,%esp
  802016:	83 ec 04             	sub    $0x4,%esp
  802019:	53                   	push   %ebx
  80201a:	50                   	push   %eax
  80201b:	68 4f 47 80 00       	push   $0x80474f
  802020:	e8 52 e6 ff ff       	call   800677 <cprintf>
  802025:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802028:	8b 45 10             	mov    0x10(%ebp),%eax
  80202b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80202e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802032:	74 07                	je     80203b <print_blocks_list+0x73>
  802034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802037:	8b 00                	mov    (%eax),%eax
  802039:	eb 05                	jmp    802040 <print_blocks_list+0x78>
  80203b:	b8 00 00 00 00       	mov    $0x0,%eax
  802040:	89 45 10             	mov    %eax,0x10(%ebp)
  802043:	8b 45 10             	mov    0x10(%ebp),%eax
  802046:	85 c0                	test   %eax,%eax
  802048:	75 ad                	jne    801ff7 <print_blocks_list+0x2f>
  80204a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80204e:	75 a7                	jne    801ff7 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802050:	83 ec 0c             	sub    $0xc,%esp
  802053:	68 0c 47 80 00       	push   $0x80470c
  802058:	e8 1a e6 ff ff       	call   800677 <cprintf>
  80205d:	83 c4 10             	add    $0x10,%esp

}
  802060:	90                   	nop
  802061:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
  802069:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80206c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206f:	83 e0 01             	and    $0x1,%eax
  802072:	85 c0                	test   %eax,%eax
  802074:	74 03                	je     802079 <initialize_dynamic_allocator+0x13>
  802076:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802079:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80207d:	0f 84 c7 01 00 00    	je     80224a <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802083:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80208a:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80208d:	8b 55 08             	mov    0x8(%ebp),%edx
  802090:	8b 45 0c             	mov    0xc(%ebp),%eax
  802093:	01 d0                	add    %edx,%eax
  802095:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80209a:	0f 87 ad 01 00 00    	ja     80224d <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8020a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a3:	85 c0                	test   %eax,%eax
  8020a5:	0f 89 a5 01 00 00    	jns    802250 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8020ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b1:	01 d0                	add    %edx,%eax
  8020b3:	83 e8 04             	sub    $0x4,%eax
  8020b6:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8020bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8020c2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020ca:	e9 87 00 00 00       	jmp    802156 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8020cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020d3:	75 14                	jne    8020e9 <initialize_dynamic_allocator+0x83>
  8020d5:	83 ec 04             	sub    $0x4,%esp
  8020d8:	68 67 47 80 00       	push   $0x804767
  8020dd:	6a 79                	push   $0x79
  8020df:	68 85 47 80 00       	push   $0x804785
  8020e4:	e8 d1 e2 ff ff       	call   8003ba <_panic>
  8020e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ec:	8b 00                	mov    (%eax),%eax
  8020ee:	85 c0                	test   %eax,%eax
  8020f0:	74 10                	je     802102 <initialize_dynamic_allocator+0x9c>
  8020f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f5:	8b 00                	mov    (%eax),%eax
  8020f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020fa:	8b 52 04             	mov    0x4(%edx),%edx
  8020fd:	89 50 04             	mov    %edx,0x4(%eax)
  802100:	eb 0b                	jmp    80210d <initialize_dynamic_allocator+0xa7>
  802102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802105:	8b 40 04             	mov    0x4(%eax),%eax
  802108:	a3 30 50 80 00       	mov    %eax,0x805030
  80210d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802110:	8b 40 04             	mov    0x4(%eax),%eax
  802113:	85 c0                	test   %eax,%eax
  802115:	74 0f                	je     802126 <initialize_dynamic_allocator+0xc0>
  802117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211a:	8b 40 04             	mov    0x4(%eax),%eax
  80211d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802120:	8b 12                	mov    (%edx),%edx
  802122:	89 10                	mov    %edx,(%eax)
  802124:	eb 0a                	jmp    802130 <initialize_dynamic_allocator+0xca>
  802126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802129:	8b 00                	mov    (%eax),%eax
  80212b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802133:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802143:	a1 38 50 80 00       	mov    0x805038,%eax
  802148:	48                   	dec    %eax
  802149:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80214e:	a1 34 50 80 00       	mov    0x805034,%eax
  802153:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802156:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80215a:	74 07                	je     802163 <initialize_dynamic_allocator+0xfd>
  80215c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215f:	8b 00                	mov    (%eax),%eax
  802161:	eb 05                	jmp    802168 <initialize_dynamic_allocator+0x102>
  802163:	b8 00 00 00 00       	mov    $0x0,%eax
  802168:	a3 34 50 80 00       	mov    %eax,0x805034
  80216d:	a1 34 50 80 00       	mov    0x805034,%eax
  802172:	85 c0                	test   %eax,%eax
  802174:	0f 85 55 ff ff ff    	jne    8020cf <initialize_dynamic_allocator+0x69>
  80217a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80217e:	0f 85 4b ff ff ff    	jne    8020cf <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80218a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802193:	a1 44 50 80 00       	mov    0x805044,%eax
  802198:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80219d:	a1 40 50 80 00       	mov    0x805040,%eax
  8021a2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8021a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ab:	83 c0 08             	add    $0x8,%eax
  8021ae:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	83 c0 04             	add    $0x4,%eax
  8021b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ba:	83 ea 08             	sub    $0x8,%edx
  8021bd:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c5:	01 d0                	add    %edx,%eax
  8021c7:	83 e8 08             	sub    $0x8,%eax
  8021ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021cd:	83 ea 08             	sub    $0x8,%edx
  8021d0:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8021d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8021db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8021e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021e9:	75 17                	jne    802202 <initialize_dynamic_allocator+0x19c>
  8021eb:	83 ec 04             	sub    $0x4,%esp
  8021ee:	68 a0 47 80 00       	push   $0x8047a0
  8021f3:	68 90 00 00 00       	push   $0x90
  8021f8:	68 85 47 80 00       	push   $0x804785
  8021fd:	e8 b8 e1 ff ff       	call   8003ba <_panic>
  802202:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802208:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80220b:	89 10                	mov    %edx,(%eax)
  80220d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802210:	8b 00                	mov    (%eax),%eax
  802212:	85 c0                	test   %eax,%eax
  802214:	74 0d                	je     802223 <initialize_dynamic_allocator+0x1bd>
  802216:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80221b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80221e:	89 50 04             	mov    %edx,0x4(%eax)
  802221:	eb 08                	jmp    80222b <initialize_dynamic_allocator+0x1c5>
  802223:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802226:	a3 30 50 80 00       	mov    %eax,0x805030
  80222b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802233:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802236:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80223d:	a1 38 50 80 00       	mov    0x805038,%eax
  802242:	40                   	inc    %eax
  802243:	a3 38 50 80 00       	mov    %eax,0x805038
  802248:	eb 07                	jmp    802251 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80224a:	90                   	nop
  80224b:	eb 04                	jmp    802251 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80224d:	90                   	nop
  80224e:	eb 01                	jmp    802251 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802250:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802251:	c9                   	leave  
  802252:	c3                   	ret    

00802253 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802256:	8b 45 10             	mov    0x10(%ebp),%eax
  802259:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	8d 50 fc             	lea    -0x4(%eax),%edx
  802262:	8b 45 0c             	mov    0xc(%ebp),%eax
  802265:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	83 e8 04             	sub    $0x4,%eax
  80226d:	8b 00                	mov    (%eax),%eax
  80226f:	83 e0 fe             	and    $0xfffffffe,%eax
  802272:	8d 50 f8             	lea    -0x8(%eax),%edx
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	01 c2                	add    %eax,%edx
  80227a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227d:	89 02                	mov    %eax,(%edx)
}
  80227f:	90                   	nop
  802280:	5d                   	pop    %ebp
  802281:	c3                   	ret    

00802282 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
  802285:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	83 e0 01             	and    $0x1,%eax
  80228e:	85 c0                	test   %eax,%eax
  802290:	74 03                	je     802295 <alloc_block_FF+0x13>
  802292:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802295:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802299:	77 07                	ja     8022a2 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80229b:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8022a2:	a1 24 50 80 00       	mov    0x805024,%eax
  8022a7:	85 c0                	test   %eax,%eax
  8022a9:	75 73                	jne    80231e <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	83 c0 10             	add    $0x10,%eax
  8022b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8022b4:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8022bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c1:	01 d0                	add    %edx,%eax
  8022c3:	48                   	dec    %eax
  8022c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8022c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8022cf:	f7 75 ec             	divl   -0x14(%ebp)
  8022d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022d5:	29 d0                	sub    %edx,%eax
  8022d7:	c1 e8 0c             	shr    $0xc,%eax
  8022da:	83 ec 0c             	sub    $0xc,%esp
  8022dd:	50                   	push   %eax
  8022de:	e8 2e f1 ff ff       	call   801411 <sbrk>
  8022e3:	83 c4 10             	add    $0x10,%esp
  8022e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8022e9:	83 ec 0c             	sub    $0xc,%esp
  8022ec:	6a 00                	push   $0x0
  8022ee:	e8 1e f1 ff ff       	call   801411 <sbrk>
  8022f3:	83 c4 10             	add    $0x10,%esp
  8022f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8022f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022fc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8022ff:	83 ec 08             	sub    $0x8,%esp
  802302:	50                   	push   %eax
  802303:	ff 75 e4             	pushl  -0x1c(%ebp)
  802306:	e8 5b fd ff ff       	call   802066 <initialize_dynamic_allocator>
  80230b:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80230e:	83 ec 0c             	sub    $0xc,%esp
  802311:	68 c3 47 80 00       	push   $0x8047c3
  802316:	e8 5c e3 ff ff       	call   800677 <cprintf>
  80231b:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80231e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802322:	75 0a                	jne    80232e <alloc_block_FF+0xac>
	        return NULL;
  802324:	b8 00 00 00 00       	mov    $0x0,%eax
  802329:	e9 0e 04 00 00       	jmp    80273c <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80232e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802335:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80233a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80233d:	e9 f3 02 00 00       	jmp    802635 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802345:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802348:	83 ec 0c             	sub    $0xc,%esp
  80234b:	ff 75 bc             	pushl  -0x44(%ebp)
  80234e:	e8 af fb ff ff       	call   801f02 <get_block_size>
  802353:	83 c4 10             	add    $0x10,%esp
  802356:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802359:	8b 45 08             	mov    0x8(%ebp),%eax
  80235c:	83 c0 08             	add    $0x8,%eax
  80235f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802362:	0f 87 c5 02 00 00    	ja     80262d <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802368:	8b 45 08             	mov    0x8(%ebp),%eax
  80236b:	83 c0 18             	add    $0x18,%eax
  80236e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802371:	0f 87 19 02 00 00    	ja     802590 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802377:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80237a:	2b 45 08             	sub    0x8(%ebp),%eax
  80237d:	83 e8 08             	sub    $0x8,%eax
  802380:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802383:	8b 45 08             	mov    0x8(%ebp),%eax
  802386:	8d 50 08             	lea    0x8(%eax),%edx
  802389:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80238c:	01 d0                	add    %edx,%eax
  80238e:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802391:	8b 45 08             	mov    0x8(%ebp),%eax
  802394:	83 c0 08             	add    $0x8,%eax
  802397:	83 ec 04             	sub    $0x4,%esp
  80239a:	6a 01                	push   $0x1
  80239c:	50                   	push   %eax
  80239d:	ff 75 bc             	pushl  -0x44(%ebp)
  8023a0:	e8 ae fe ff ff       	call   802253 <set_block_data>
  8023a5:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	8b 40 04             	mov    0x4(%eax),%eax
  8023ae:	85 c0                	test   %eax,%eax
  8023b0:	75 68                	jne    80241a <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023b2:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023b6:	75 17                	jne    8023cf <alloc_block_FF+0x14d>
  8023b8:	83 ec 04             	sub    $0x4,%esp
  8023bb:	68 a0 47 80 00       	push   $0x8047a0
  8023c0:	68 d7 00 00 00       	push   $0xd7
  8023c5:	68 85 47 80 00       	push   $0x804785
  8023ca:	e8 eb df ff ff       	call   8003ba <_panic>
  8023cf:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8023d5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023d8:	89 10                	mov    %edx,(%eax)
  8023da:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023dd:	8b 00                	mov    (%eax),%eax
  8023df:	85 c0                	test   %eax,%eax
  8023e1:	74 0d                	je     8023f0 <alloc_block_FF+0x16e>
  8023e3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023e8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023eb:	89 50 04             	mov    %edx,0x4(%eax)
  8023ee:	eb 08                	jmp    8023f8 <alloc_block_FF+0x176>
  8023f0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023f3:	a3 30 50 80 00       	mov    %eax,0x805030
  8023f8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023fb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802400:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802403:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80240a:	a1 38 50 80 00       	mov    0x805038,%eax
  80240f:	40                   	inc    %eax
  802410:	a3 38 50 80 00       	mov    %eax,0x805038
  802415:	e9 dc 00 00 00       	jmp    8024f6 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80241a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241d:	8b 00                	mov    (%eax),%eax
  80241f:	85 c0                	test   %eax,%eax
  802421:	75 65                	jne    802488 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802423:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802427:	75 17                	jne    802440 <alloc_block_FF+0x1be>
  802429:	83 ec 04             	sub    $0x4,%esp
  80242c:	68 d4 47 80 00       	push   $0x8047d4
  802431:	68 db 00 00 00       	push   $0xdb
  802436:	68 85 47 80 00       	push   $0x804785
  80243b:	e8 7a df ff ff       	call   8003ba <_panic>
  802440:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802446:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802449:	89 50 04             	mov    %edx,0x4(%eax)
  80244c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80244f:	8b 40 04             	mov    0x4(%eax),%eax
  802452:	85 c0                	test   %eax,%eax
  802454:	74 0c                	je     802462 <alloc_block_FF+0x1e0>
  802456:	a1 30 50 80 00       	mov    0x805030,%eax
  80245b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80245e:	89 10                	mov    %edx,(%eax)
  802460:	eb 08                	jmp    80246a <alloc_block_FF+0x1e8>
  802462:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802465:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80246a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80246d:	a3 30 50 80 00       	mov    %eax,0x805030
  802472:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802475:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80247b:	a1 38 50 80 00       	mov    0x805038,%eax
  802480:	40                   	inc    %eax
  802481:	a3 38 50 80 00       	mov    %eax,0x805038
  802486:	eb 6e                	jmp    8024f6 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802488:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80248c:	74 06                	je     802494 <alloc_block_FF+0x212>
  80248e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802492:	75 17                	jne    8024ab <alloc_block_FF+0x229>
  802494:	83 ec 04             	sub    $0x4,%esp
  802497:	68 f8 47 80 00       	push   $0x8047f8
  80249c:	68 df 00 00 00       	push   $0xdf
  8024a1:	68 85 47 80 00       	push   $0x804785
  8024a6:	e8 0f df ff ff       	call   8003ba <_panic>
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	8b 10                	mov    (%eax),%edx
  8024b0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024b3:	89 10                	mov    %edx,(%eax)
  8024b5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024b8:	8b 00                	mov    (%eax),%eax
  8024ba:	85 c0                	test   %eax,%eax
  8024bc:	74 0b                	je     8024c9 <alloc_block_FF+0x247>
  8024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c1:	8b 00                	mov    (%eax),%eax
  8024c3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024c6:	89 50 04             	mov    %edx,0x4(%eax)
  8024c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024cf:	89 10                	mov    %edx,(%eax)
  8024d1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d7:	89 50 04             	mov    %edx,0x4(%eax)
  8024da:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024dd:	8b 00                	mov    (%eax),%eax
  8024df:	85 c0                	test   %eax,%eax
  8024e1:	75 08                	jne    8024eb <alloc_block_FF+0x269>
  8024e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024e6:	a3 30 50 80 00       	mov    %eax,0x805030
  8024eb:	a1 38 50 80 00       	mov    0x805038,%eax
  8024f0:	40                   	inc    %eax
  8024f1:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8024f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024fa:	75 17                	jne    802513 <alloc_block_FF+0x291>
  8024fc:	83 ec 04             	sub    $0x4,%esp
  8024ff:	68 67 47 80 00       	push   $0x804767
  802504:	68 e1 00 00 00       	push   $0xe1
  802509:	68 85 47 80 00       	push   $0x804785
  80250e:	e8 a7 de ff ff       	call   8003ba <_panic>
  802513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802516:	8b 00                	mov    (%eax),%eax
  802518:	85 c0                	test   %eax,%eax
  80251a:	74 10                	je     80252c <alloc_block_FF+0x2aa>
  80251c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251f:	8b 00                	mov    (%eax),%eax
  802521:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802524:	8b 52 04             	mov    0x4(%edx),%edx
  802527:	89 50 04             	mov    %edx,0x4(%eax)
  80252a:	eb 0b                	jmp    802537 <alloc_block_FF+0x2b5>
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	8b 40 04             	mov    0x4(%eax),%eax
  802532:	a3 30 50 80 00       	mov    %eax,0x805030
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	8b 40 04             	mov    0x4(%eax),%eax
  80253d:	85 c0                	test   %eax,%eax
  80253f:	74 0f                	je     802550 <alloc_block_FF+0x2ce>
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	8b 40 04             	mov    0x4(%eax),%eax
  802547:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254a:	8b 12                	mov    (%edx),%edx
  80254c:	89 10                	mov    %edx,(%eax)
  80254e:	eb 0a                	jmp    80255a <alloc_block_FF+0x2d8>
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	8b 00                	mov    (%eax),%eax
  802555:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80256d:	a1 38 50 80 00       	mov    0x805038,%eax
  802572:	48                   	dec    %eax
  802573:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802578:	83 ec 04             	sub    $0x4,%esp
  80257b:	6a 00                	push   $0x0
  80257d:	ff 75 b4             	pushl  -0x4c(%ebp)
  802580:	ff 75 b0             	pushl  -0x50(%ebp)
  802583:	e8 cb fc ff ff       	call   802253 <set_block_data>
  802588:	83 c4 10             	add    $0x10,%esp
  80258b:	e9 95 00 00 00       	jmp    802625 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802590:	83 ec 04             	sub    $0x4,%esp
  802593:	6a 01                	push   $0x1
  802595:	ff 75 b8             	pushl  -0x48(%ebp)
  802598:	ff 75 bc             	pushl  -0x44(%ebp)
  80259b:	e8 b3 fc ff ff       	call   802253 <set_block_data>
  8025a0:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8025a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a7:	75 17                	jne    8025c0 <alloc_block_FF+0x33e>
  8025a9:	83 ec 04             	sub    $0x4,%esp
  8025ac:	68 67 47 80 00       	push   $0x804767
  8025b1:	68 e8 00 00 00       	push   $0xe8
  8025b6:	68 85 47 80 00       	push   $0x804785
  8025bb:	e8 fa dd ff ff       	call   8003ba <_panic>
  8025c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c3:	8b 00                	mov    (%eax),%eax
  8025c5:	85 c0                	test   %eax,%eax
  8025c7:	74 10                	je     8025d9 <alloc_block_FF+0x357>
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	8b 00                	mov    (%eax),%eax
  8025ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d1:	8b 52 04             	mov    0x4(%edx),%edx
  8025d4:	89 50 04             	mov    %edx,0x4(%eax)
  8025d7:	eb 0b                	jmp    8025e4 <alloc_block_FF+0x362>
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	8b 40 04             	mov    0x4(%eax),%eax
  8025df:	a3 30 50 80 00       	mov    %eax,0x805030
  8025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e7:	8b 40 04             	mov    0x4(%eax),%eax
  8025ea:	85 c0                	test   %eax,%eax
  8025ec:	74 0f                	je     8025fd <alloc_block_FF+0x37b>
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	8b 40 04             	mov    0x4(%eax),%eax
  8025f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f7:	8b 12                	mov    (%edx),%edx
  8025f9:	89 10                	mov    %edx,(%eax)
  8025fb:	eb 0a                	jmp    802607 <alloc_block_FF+0x385>
  8025fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802600:	8b 00                	mov    (%eax),%eax
  802602:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802613:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80261a:	a1 38 50 80 00       	mov    0x805038,%eax
  80261f:	48                   	dec    %eax
  802620:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802625:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802628:	e9 0f 01 00 00       	jmp    80273c <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80262d:	a1 34 50 80 00       	mov    0x805034,%eax
  802632:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802635:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802639:	74 07                	je     802642 <alloc_block_FF+0x3c0>
  80263b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263e:	8b 00                	mov    (%eax),%eax
  802640:	eb 05                	jmp    802647 <alloc_block_FF+0x3c5>
  802642:	b8 00 00 00 00       	mov    $0x0,%eax
  802647:	a3 34 50 80 00       	mov    %eax,0x805034
  80264c:	a1 34 50 80 00       	mov    0x805034,%eax
  802651:	85 c0                	test   %eax,%eax
  802653:	0f 85 e9 fc ff ff    	jne    802342 <alloc_block_FF+0xc0>
  802659:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265d:	0f 85 df fc ff ff    	jne    802342 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802663:	8b 45 08             	mov    0x8(%ebp),%eax
  802666:	83 c0 08             	add    $0x8,%eax
  802669:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80266c:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802673:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802676:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802679:	01 d0                	add    %edx,%eax
  80267b:	48                   	dec    %eax
  80267c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80267f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802682:	ba 00 00 00 00       	mov    $0x0,%edx
  802687:	f7 75 d8             	divl   -0x28(%ebp)
  80268a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80268d:	29 d0                	sub    %edx,%eax
  80268f:	c1 e8 0c             	shr    $0xc,%eax
  802692:	83 ec 0c             	sub    $0xc,%esp
  802695:	50                   	push   %eax
  802696:	e8 76 ed ff ff       	call   801411 <sbrk>
  80269b:	83 c4 10             	add    $0x10,%esp
  80269e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8026a1:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8026a5:	75 0a                	jne    8026b1 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8026a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ac:	e9 8b 00 00 00       	jmp    80273c <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8026b1:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8026b8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026bb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026be:	01 d0                	add    %edx,%eax
  8026c0:	48                   	dec    %eax
  8026c1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8026c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8026cc:	f7 75 cc             	divl   -0x34(%ebp)
  8026cf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026d2:	29 d0                	sub    %edx,%eax
  8026d4:	8d 50 fc             	lea    -0x4(%eax),%edx
  8026d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026da:	01 d0                	add    %edx,%eax
  8026dc:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8026e1:	a1 40 50 80 00       	mov    0x805040,%eax
  8026e6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8026ec:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8026f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026f6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8026f9:	01 d0                	add    %edx,%eax
  8026fb:	48                   	dec    %eax
  8026fc:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8026ff:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802702:	ba 00 00 00 00       	mov    $0x0,%edx
  802707:	f7 75 c4             	divl   -0x3c(%ebp)
  80270a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80270d:	29 d0                	sub    %edx,%eax
  80270f:	83 ec 04             	sub    $0x4,%esp
  802712:	6a 01                	push   $0x1
  802714:	50                   	push   %eax
  802715:	ff 75 d0             	pushl  -0x30(%ebp)
  802718:	e8 36 fb ff ff       	call   802253 <set_block_data>
  80271d:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802720:	83 ec 0c             	sub    $0xc,%esp
  802723:	ff 75 d0             	pushl  -0x30(%ebp)
  802726:	e8 1b 0a 00 00       	call   803146 <free_block>
  80272b:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80272e:	83 ec 0c             	sub    $0xc,%esp
  802731:	ff 75 08             	pushl  0x8(%ebp)
  802734:	e8 49 fb ff ff       	call   802282 <alloc_block_FF>
  802739:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80273c:	c9                   	leave  
  80273d:	c3                   	ret    

0080273e <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80273e:	55                   	push   %ebp
  80273f:	89 e5                	mov    %esp,%ebp
  802741:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802744:	8b 45 08             	mov    0x8(%ebp),%eax
  802747:	83 e0 01             	and    $0x1,%eax
  80274a:	85 c0                	test   %eax,%eax
  80274c:	74 03                	je     802751 <alloc_block_BF+0x13>
  80274e:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802751:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802755:	77 07                	ja     80275e <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802757:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80275e:	a1 24 50 80 00       	mov    0x805024,%eax
  802763:	85 c0                	test   %eax,%eax
  802765:	75 73                	jne    8027da <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802767:	8b 45 08             	mov    0x8(%ebp),%eax
  80276a:	83 c0 10             	add    $0x10,%eax
  80276d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802770:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802777:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80277a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80277d:	01 d0                	add    %edx,%eax
  80277f:	48                   	dec    %eax
  802780:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802783:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802786:	ba 00 00 00 00       	mov    $0x0,%edx
  80278b:	f7 75 e0             	divl   -0x20(%ebp)
  80278e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802791:	29 d0                	sub    %edx,%eax
  802793:	c1 e8 0c             	shr    $0xc,%eax
  802796:	83 ec 0c             	sub    $0xc,%esp
  802799:	50                   	push   %eax
  80279a:	e8 72 ec ff ff       	call   801411 <sbrk>
  80279f:	83 c4 10             	add    $0x10,%esp
  8027a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8027a5:	83 ec 0c             	sub    $0xc,%esp
  8027a8:	6a 00                	push   $0x0
  8027aa:	e8 62 ec ff ff       	call   801411 <sbrk>
  8027af:	83 c4 10             	add    $0x10,%esp
  8027b2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8027b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027b8:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8027bb:	83 ec 08             	sub    $0x8,%esp
  8027be:	50                   	push   %eax
  8027bf:	ff 75 d8             	pushl  -0x28(%ebp)
  8027c2:	e8 9f f8 ff ff       	call   802066 <initialize_dynamic_allocator>
  8027c7:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8027ca:	83 ec 0c             	sub    $0xc,%esp
  8027cd:	68 c3 47 80 00       	push   $0x8047c3
  8027d2:	e8 a0 de ff ff       	call   800677 <cprintf>
  8027d7:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8027da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8027e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8027e8:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8027ef:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8027f6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027fe:	e9 1d 01 00 00       	jmp    802920 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802809:	83 ec 0c             	sub    $0xc,%esp
  80280c:	ff 75 a8             	pushl  -0x58(%ebp)
  80280f:	e8 ee f6 ff ff       	call   801f02 <get_block_size>
  802814:	83 c4 10             	add    $0x10,%esp
  802817:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80281a:	8b 45 08             	mov    0x8(%ebp),%eax
  80281d:	83 c0 08             	add    $0x8,%eax
  802820:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802823:	0f 87 ef 00 00 00    	ja     802918 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802829:	8b 45 08             	mov    0x8(%ebp),%eax
  80282c:	83 c0 18             	add    $0x18,%eax
  80282f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802832:	77 1d                	ja     802851 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802834:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802837:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80283a:	0f 86 d8 00 00 00    	jbe    802918 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802840:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802843:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802846:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802849:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80284c:	e9 c7 00 00 00       	jmp    802918 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802851:	8b 45 08             	mov    0x8(%ebp),%eax
  802854:	83 c0 08             	add    $0x8,%eax
  802857:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80285a:	0f 85 9d 00 00 00    	jne    8028fd <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802860:	83 ec 04             	sub    $0x4,%esp
  802863:	6a 01                	push   $0x1
  802865:	ff 75 a4             	pushl  -0x5c(%ebp)
  802868:	ff 75 a8             	pushl  -0x58(%ebp)
  80286b:	e8 e3 f9 ff ff       	call   802253 <set_block_data>
  802870:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802873:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802877:	75 17                	jne    802890 <alloc_block_BF+0x152>
  802879:	83 ec 04             	sub    $0x4,%esp
  80287c:	68 67 47 80 00       	push   $0x804767
  802881:	68 2c 01 00 00       	push   $0x12c
  802886:	68 85 47 80 00       	push   $0x804785
  80288b:	e8 2a db ff ff       	call   8003ba <_panic>
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 00                	mov    (%eax),%eax
  802895:	85 c0                	test   %eax,%eax
  802897:	74 10                	je     8028a9 <alloc_block_BF+0x16b>
  802899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289c:	8b 00                	mov    (%eax),%eax
  80289e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a1:	8b 52 04             	mov    0x4(%edx),%edx
  8028a4:	89 50 04             	mov    %edx,0x4(%eax)
  8028a7:	eb 0b                	jmp    8028b4 <alloc_block_BF+0x176>
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	8b 40 04             	mov    0x4(%eax),%eax
  8028af:	a3 30 50 80 00       	mov    %eax,0x805030
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ba:	85 c0                	test   %eax,%eax
  8028bc:	74 0f                	je     8028cd <alloc_block_BF+0x18f>
  8028be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c1:	8b 40 04             	mov    0x4(%eax),%eax
  8028c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c7:	8b 12                	mov    (%edx),%edx
  8028c9:	89 10                	mov    %edx,(%eax)
  8028cb:	eb 0a                	jmp    8028d7 <alloc_block_BF+0x199>
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d0:	8b 00                	mov    (%eax),%eax
  8028d2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ea:	a1 38 50 80 00       	mov    0x805038,%eax
  8028ef:	48                   	dec    %eax
  8028f0:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8028f5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028f8:	e9 24 04 00 00       	jmp    802d21 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8028fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802900:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802903:	76 13                	jbe    802918 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802905:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80290c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80290f:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802912:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802915:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802918:	a1 34 50 80 00       	mov    0x805034,%eax
  80291d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802920:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802924:	74 07                	je     80292d <alloc_block_BF+0x1ef>
  802926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802929:	8b 00                	mov    (%eax),%eax
  80292b:	eb 05                	jmp    802932 <alloc_block_BF+0x1f4>
  80292d:	b8 00 00 00 00       	mov    $0x0,%eax
  802932:	a3 34 50 80 00       	mov    %eax,0x805034
  802937:	a1 34 50 80 00       	mov    0x805034,%eax
  80293c:	85 c0                	test   %eax,%eax
  80293e:	0f 85 bf fe ff ff    	jne    802803 <alloc_block_BF+0xc5>
  802944:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802948:	0f 85 b5 fe ff ff    	jne    802803 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80294e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802952:	0f 84 26 02 00 00    	je     802b7e <alloc_block_BF+0x440>
  802958:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80295c:	0f 85 1c 02 00 00    	jne    802b7e <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802962:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802965:	2b 45 08             	sub    0x8(%ebp),%eax
  802968:	83 e8 08             	sub    $0x8,%eax
  80296b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80296e:	8b 45 08             	mov    0x8(%ebp),%eax
  802971:	8d 50 08             	lea    0x8(%eax),%edx
  802974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802977:	01 d0                	add    %edx,%eax
  802979:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80297c:	8b 45 08             	mov    0x8(%ebp),%eax
  80297f:	83 c0 08             	add    $0x8,%eax
  802982:	83 ec 04             	sub    $0x4,%esp
  802985:	6a 01                	push   $0x1
  802987:	50                   	push   %eax
  802988:	ff 75 f0             	pushl  -0x10(%ebp)
  80298b:	e8 c3 f8 ff ff       	call   802253 <set_block_data>
  802990:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802993:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802996:	8b 40 04             	mov    0x4(%eax),%eax
  802999:	85 c0                	test   %eax,%eax
  80299b:	75 68                	jne    802a05 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80299d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029a1:	75 17                	jne    8029ba <alloc_block_BF+0x27c>
  8029a3:	83 ec 04             	sub    $0x4,%esp
  8029a6:	68 a0 47 80 00       	push   $0x8047a0
  8029ab:	68 45 01 00 00       	push   $0x145
  8029b0:	68 85 47 80 00       	push   $0x804785
  8029b5:	e8 00 da ff ff       	call   8003ba <_panic>
  8029ba:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8029c0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029c3:	89 10                	mov    %edx,(%eax)
  8029c5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029c8:	8b 00                	mov    (%eax),%eax
  8029ca:	85 c0                	test   %eax,%eax
  8029cc:	74 0d                	je     8029db <alloc_block_BF+0x29d>
  8029ce:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029d3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029d6:	89 50 04             	mov    %edx,0x4(%eax)
  8029d9:	eb 08                	jmp    8029e3 <alloc_block_BF+0x2a5>
  8029db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029de:	a3 30 50 80 00       	mov    %eax,0x805030
  8029e3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029e6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f5:	a1 38 50 80 00       	mov    0x805038,%eax
  8029fa:	40                   	inc    %eax
  8029fb:	a3 38 50 80 00       	mov    %eax,0x805038
  802a00:	e9 dc 00 00 00       	jmp    802ae1 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a08:	8b 00                	mov    (%eax),%eax
  802a0a:	85 c0                	test   %eax,%eax
  802a0c:	75 65                	jne    802a73 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a0e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a12:	75 17                	jne    802a2b <alloc_block_BF+0x2ed>
  802a14:	83 ec 04             	sub    $0x4,%esp
  802a17:	68 d4 47 80 00       	push   $0x8047d4
  802a1c:	68 4a 01 00 00       	push   $0x14a
  802a21:	68 85 47 80 00       	push   $0x804785
  802a26:	e8 8f d9 ff ff       	call   8003ba <_panic>
  802a2b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a31:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a34:	89 50 04             	mov    %edx,0x4(%eax)
  802a37:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a3a:	8b 40 04             	mov    0x4(%eax),%eax
  802a3d:	85 c0                	test   %eax,%eax
  802a3f:	74 0c                	je     802a4d <alloc_block_BF+0x30f>
  802a41:	a1 30 50 80 00       	mov    0x805030,%eax
  802a46:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a49:	89 10                	mov    %edx,(%eax)
  802a4b:	eb 08                	jmp    802a55 <alloc_block_BF+0x317>
  802a4d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a50:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a55:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a58:	a3 30 50 80 00       	mov    %eax,0x805030
  802a5d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a66:	a1 38 50 80 00       	mov    0x805038,%eax
  802a6b:	40                   	inc    %eax
  802a6c:	a3 38 50 80 00       	mov    %eax,0x805038
  802a71:	eb 6e                	jmp    802ae1 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802a73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a77:	74 06                	je     802a7f <alloc_block_BF+0x341>
  802a79:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a7d:	75 17                	jne    802a96 <alloc_block_BF+0x358>
  802a7f:	83 ec 04             	sub    $0x4,%esp
  802a82:	68 f8 47 80 00       	push   $0x8047f8
  802a87:	68 4f 01 00 00       	push   $0x14f
  802a8c:	68 85 47 80 00       	push   $0x804785
  802a91:	e8 24 d9 ff ff       	call   8003ba <_panic>
  802a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a99:	8b 10                	mov    (%eax),%edx
  802a9b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a9e:	89 10                	mov    %edx,(%eax)
  802aa0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aa3:	8b 00                	mov    (%eax),%eax
  802aa5:	85 c0                	test   %eax,%eax
  802aa7:	74 0b                	je     802ab4 <alloc_block_BF+0x376>
  802aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aac:	8b 00                	mov    (%eax),%eax
  802aae:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ab1:	89 50 04             	mov    %edx,0x4(%eax)
  802ab4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802aba:	89 10                	mov    %edx,(%eax)
  802abc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802abf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ac2:	89 50 04             	mov    %edx,0x4(%eax)
  802ac5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ac8:	8b 00                	mov    (%eax),%eax
  802aca:	85 c0                	test   %eax,%eax
  802acc:	75 08                	jne    802ad6 <alloc_block_BF+0x398>
  802ace:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ad1:	a3 30 50 80 00       	mov    %eax,0x805030
  802ad6:	a1 38 50 80 00       	mov    0x805038,%eax
  802adb:	40                   	inc    %eax
  802adc:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802ae1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ae5:	75 17                	jne    802afe <alloc_block_BF+0x3c0>
  802ae7:	83 ec 04             	sub    $0x4,%esp
  802aea:	68 67 47 80 00       	push   $0x804767
  802aef:	68 51 01 00 00       	push   $0x151
  802af4:	68 85 47 80 00       	push   $0x804785
  802af9:	e8 bc d8 ff ff       	call   8003ba <_panic>
  802afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b01:	8b 00                	mov    (%eax),%eax
  802b03:	85 c0                	test   %eax,%eax
  802b05:	74 10                	je     802b17 <alloc_block_BF+0x3d9>
  802b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0a:	8b 00                	mov    (%eax),%eax
  802b0c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b0f:	8b 52 04             	mov    0x4(%edx),%edx
  802b12:	89 50 04             	mov    %edx,0x4(%eax)
  802b15:	eb 0b                	jmp    802b22 <alloc_block_BF+0x3e4>
  802b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1a:	8b 40 04             	mov    0x4(%eax),%eax
  802b1d:	a3 30 50 80 00       	mov    %eax,0x805030
  802b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b25:	8b 40 04             	mov    0x4(%eax),%eax
  802b28:	85 c0                	test   %eax,%eax
  802b2a:	74 0f                	je     802b3b <alloc_block_BF+0x3fd>
  802b2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2f:	8b 40 04             	mov    0x4(%eax),%eax
  802b32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b35:	8b 12                	mov    (%edx),%edx
  802b37:	89 10                	mov    %edx,(%eax)
  802b39:	eb 0a                	jmp    802b45 <alloc_block_BF+0x407>
  802b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3e:	8b 00                	mov    (%eax),%eax
  802b40:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b58:	a1 38 50 80 00       	mov    0x805038,%eax
  802b5d:	48                   	dec    %eax
  802b5e:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802b63:	83 ec 04             	sub    $0x4,%esp
  802b66:	6a 00                	push   $0x0
  802b68:	ff 75 d0             	pushl  -0x30(%ebp)
  802b6b:	ff 75 cc             	pushl  -0x34(%ebp)
  802b6e:	e8 e0 f6 ff ff       	call   802253 <set_block_data>
  802b73:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b79:	e9 a3 01 00 00       	jmp    802d21 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802b7e:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802b82:	0f 85 9d 00 00 00    	jne    802c25 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802b88:	83 ec 04             	sub    $0x4,%esp
  802b8b:	6a 01                	push   $0x1
  802b8d:	ff 75 ec             	pushl  -0x14(%ebp)
  802b90:	ff 75 f0             	pushl  -0x10(%ebp)
  802b93:	e8 bb f6 ff ff       	call   802253 <set_block_data>
  802b98:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802b9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b9f:	75 17                	jne    802bb8 <alloc_block_BF+0x47a>
  802ba1:	83 ec 04             	sub    $0x4,%esp
  802ba4:	68 67 47 80 00       	push   $0x804767
  802ba9:	68 58 01 00 00       	push   $0x158
  802bae:	68 85 47 80 00       	push   $0x804785
  802bb3:	e8 02 d8 ff ff       	call   8003ba <_panic>
  802bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbb:	8b 00                	mov    (%eax),%eax
  802bbd:	85 c0                	test   %eax,%eax
  802bbf:	74 10                	je     802bd1 <alloc_block_BF+0x493>
  802bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc4:	8b 00                	mov    (%eax),%eax
  802bc6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bc9:	8b 52 04             	mov    0x4(%edx),%edx
  802bcc:	89 50 04             	mov    %edx,0x4(%eax)
  802bcf:	eb 0b                	jmp    802bdc <alloc_block_BF+0x49e>
  802bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd4:	8b 40 04             	mov    0x4(%eax),%eax
  802bd7:	a3 30 50 80 00       	mov    %eax,0x805030
  802bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdf:	8b 40 04             	mov    0x4(%eax),%eax
  802be2:	85 c0                	test   %eax,%eax
  802be4:	74 0f                	je     802bf5 <alloc_block_BF+0x4b7>
  802be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be9:	8b 40 04             	mov    0x4(%eax),%eax
  802bec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bef:	8b 12                	mov    (%edx),%edx
  802bf1:	89 10                	mov    %edx,(%eax)
  802bf3:	eb 0a                	jmp    802bff <alloc_block_BF+0x4c1>
  802bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf8:	8b 00                	mov    (%eax),%eax
  802bfa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c12:	a1 38 50 80 00       	mov    0x805038,%eax
  802c17:	48                   	dec    %eax
  802c18:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c20:	e9 fc 00 00 00       	jmp    802d21 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c25:	8b 45 08             	mov    0x8(%ebp),%eax
  802c28:	83 c0 08             	add    $0x8,%eax
  802c2b:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c2e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c35:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c38:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c3b:	01 d0                	add    %edx,%eax
  802c3d:	48                   	dec    %eax
  802c3e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c41:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c44:	ba 00 00 00 00       	mov    $0x0,%edx
  802c49:	f7 75 c4             	divl   -0x3c(%ebp)
  802c4c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c4f:	29 d0                	sub    %edx,%eax
  802c51:	c1 e8 0c             	shr    $0xc,%eax
  802c54:	83 ec 0c             	sub    $0xc,%esp
  802c57:	50                   	push   %eax
  802c58:	e8 b4 e7 ff ff       	call   801411 <sbrk>
  802c5d:	83 c4 10             	add    $0x10,%esp
  802c60:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802c63:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802c67:	75 0a                	jne    802c73 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802c69:	b8 00 00 00 00       	mov    $0x0,%eax
  802c6e:	e9 ae 00 00 00       	jmp    802d21 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c73:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802c7a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c7d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c80:	01 d0                	add    %edx,%eax
  802c82:	48                   	dec    %eax
  802c83:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802c86:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c89:	ba 00 00 00 00       	mov    $0x0,%edx
  802c8e:	f7 75 b8             	divl   -0x48(%ebp)
  802c91:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c94:	29 d0                	sub    %edx,%eax
  802c96:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c99:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c9c:	01 d0                	add    %edx,%eax
  802c9e:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802ca3:	a1 40 50 80 00       	mov    0x805040,%eax
  802ca8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802cae:	83 ec 0c             	sub    $0xc,%esp
  802cb1:	68 2c 48 80 00       	push   $0x80482c
  802cb6:	e8 bc d9 ff ff       	call   800677 <cprintf>
  802cbb:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802cbe:	83 ec 08             	sub    $0x8,%esp
  802cc1:	ff 75 bc             	pushl  -0x44(%ebp)
  802cc4:	68 31 48 80 00       	push   $0x804831
  802cc9:	e8 a9 d9 ff ff       	call   800677 <cprintf>
  802cce:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802cd1:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802cd8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cdb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cde:	01 d0                	add    %edx,%eax
  802ce0:	48                   	dec    %eax
  802ce1:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802ce4:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ce7:	ba 00 00 00 00       	mov    $0x0,%edx
  802cec:	f7 75 b0             	divl   -0x50(%ebp)
  802cef:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802cf2:	29 d0                	sub    %edx,%eax
  802cf4:	83 ec 04             	sub    $0x4,%esp
  802cf7:	6a 01                	push   $0x1
  802cf9:	50                   	push   %eax
  802cfa:	ff 75 bc             	pushl  -0x44(%ebp)
  802cfd:	e8 51 f5 ff ff       	call   802253 <set_block_data>
  802d02:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d05:	83 ec 0c             	sub    $0xc,%esp
  802d08:	ff 75 bc             	pushl  -0x44(%ebp)
  802d0b:	e8 36 04 00 00       	call   803146 <free_block>
  802d10:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d13:	83 ec 0c             	sub    $0xc,%esp
  802d16:	ff 75 08             	pushl  0x8(%ebp)
  802d19:	e8 20 fa ff ff       	call   80273e <alloc_block_BF>
  802d1e:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d21:	c9                   	leave  
  802d22:	c3                   	ret    

00802d23 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d23:	55                   	push   %ebp
  802d24:	89 e5                	mov    %esp,%ebp
  802d26:	53                   	push   %ebx
  802d27:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d31:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d3c:	74 1e                	je     802d5c <merging+0x39>
  802d3e:	ff 75 08             	pushl  0x8(%ebp)
  802d41:	e8 bc f1 ff ff       	call   801f02 <get_block_size>
  802d46:	83 c4 04             	add    $0x4,%esp
  802d49:	89 c2                	mov    %eax,%edx
  802d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4e:	01 d0                	add    %edx,%eax
  802d50:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d53:	75 07                	jne    802d5c <merging+0x39>
		prev_is_free = 1;
  802d55:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802d5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d60:	74 1e                	je     802d80 <merging+0x5d>
  802d62:	ff 75 10             	pushl  0x10(%ebp)
  802d65:	e8 98 f1 ff ff       	call   801f02 <get_block_size>
  802d6a:	83 c4 04             	add    $0x4,%esp
  802d6d:	89 c2                	mov    %eax,%edx
  802d6f:	8b 45 10             	mov    0x10(%ebp),%eax
  802d72:	01 d0                	add    %edx,%eax
  802d74:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d77:	75 07                	jne    802d80 <merging+0x5d>
		next_is_free = 1;
  802d79:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802d80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d84:	0f 84 cc 00 00 00    	je     802e56 <merging+0x133>
  802d8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d8e:	0f 84 c2 00 00 00    	je     802e56 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802d94:	ff 75 08             	pushl  0x8(%ebp)
  802d97:	e8 66 f1 ff ff       	call   801f02 <get_block_size>
  802d9c:	83 c4 04             	add    $0x4,%esp
  802d9f:	89 c3                	mov    %eax,%ebx
  802da1:	ff 75 10             	pushl  0x10(%ebp)
  802da4:	e8 59 f1 ff ff       	call   801f02 <get_block_size>
  802da9:	83 c4 04             	add    $0x4,%esp
  802dac:	01 c3                	add    %eax,%ebx
  802dae:	ff 75 0c             	pushl  0xc(%ebp)
  802db1:	e8 4c f1 ff ff       	call   801f02 <get_block_size>
  802db6:	83 c4 04             	add    $0x4,%esp
  802db9:	01 d8                	add    %ebx,%eax
  802dbb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802dbe:	6a 00                	push   $0x0
  802dc0:	ff 75 ec             	pushl  -0x14(%ebp)
  802dc3:	ff 75 08             	pushl  0x8(%ebp)
  802dc6:	e8 88 f4 ff ff       	call   802253 <set_block_data>
  802dcb:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802dce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dd2:	75 17                	jne    802deb <merging+0xc8>
  802dd4:	83 ec 04             	sub    $0x4,%esp
  802dd7:	68 67 47 80 00       	push   $0x804767
  802ddc:	68 7d 01 00 00       	push   $0x17d
  802de1:	68 85 47 80 00       	push   $0x804785
  802de6:	e8 cf d5 ff ff       	call   8003ba <_panic>
  802deb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dee:	8b 00                	mov    (%eax),%eax
  802df0:	85 c0                	test   %eax,%eax
  802df2:	74 10                	je     802e04 <merging+0xe1>
  802df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df7:	8b 00                	mov    (%eax),%eax
  802df9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dfc:	8b 52 04             	mov    0x4(%edx),%edx
  802dff:	89 50 04             	mov    %edx,0x4(%eax)
  802e02:	eb 0b                	jmp    802e0f <merging+0xec>
  802e04:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e07:	8b 40 04             	mov    0x4(%eax),%eax
  802e0a:	a3 30 50 80 00       	mov    %eax,0x805030
  802e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e12:	8b 40 04             	mov    0x4(%eax),%eax
  802e15:	85 c0                	test   %eax,%eax
  802e17:	74 0f                	je     802e28 <merging+0x105>
  802e19:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e1c:	8b 40 04             	mov    0x4(%eax),%eax
  802e1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e22:	8b 12                	mov    (%edx),%edx
  802e24:	89 10                	mov    %edx,(%eax)
  802e26:	eb 0a                	jmp    802e32 <merging+0x10f>
  802e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e2b:	8b 00                	mov    (%eax),%eax
  802e2d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e32:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e45:	a1 38 50 80 00       	mov    0x805038,%eax
  802e4a:	48                   	dec    %eax
  802e4b:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e50:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e51:	e9 ea 02 00 00       	jmp    803140 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e5a:	74 3b                	je     802e97 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802e5c:	83 ec 0c             	sub    $0xc,%esp
  802e5f:	ff 75 08             	pushl  0x8(%ebp)
  802e62:	e8 9b f0 ff ff       	call   801f02 <get_block_size>
  802e67:	83 c4 10             	add    $0x10,%esp
  802e6a:	89 c3                	mov    %eax,%ebx
  802e6c:	83 ec 0c             	sub    $0xc,%esp
  802e6f:	ff 75 10             	pushl  0x10(%ebp)
  802e72:	e8 8b f0 ff ff       	call   801f02 <get_block_size>
  802e77:	83 c4 10             	add    $0x10,%esp
  802e7a:	01 d8                	add    %ebx,%eax
  802e7c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e7f:	83 ec 04             	sub    $0x4,%esp
  802e82:	6a 00                	push   $0x0
  802e84:	ff 75 e8             	pushl  -0x18(%ebp)
  802e87:	ff 75 08             	pushl  0x8(%ebp)
  802e8a:	e8 c4 f3 ff ff       	call   802253 <set_block_data>
  802e8f:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e92:	e9 a9 02 00 00       	jmp    803140 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802e97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e9b:	0f 84 2d 01 00 00    	je     802fce <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802ea1:	83 ec 0c             	sub    $0xc,%esp
  802ea4:	ff 75 10             	pushl  0x10(%ebp)
  802ea7:	e8 56 f0 ff ff       	call   801f02 <get_block_size>
  802eac:	83 c4 10             	add    $0x10,%esp
  802eaf:	89 c3                	mov    %eax,%ebx
  802eb1:	83 ec 0c             	sub    $0xc,%esp
  802eb4:	ff 75 0c             	pushl  0xc(%ebp)
  802eb7:	e8 46 f0 ff ff       	call   801f02 <get_block_size>
  802ebc:	83 c4 10             	add    $0x10,%esp
  802ebf:	01 d8                	add    %ebx,%eax
  802ec1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802ec4:	83 ec 04             	sub    $0x4,%esp
  802ec7:	6a 00                	push   $0x0
  802ec9:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ecc:	ff 75 10             	pushl  0x10(%ebp)
  802ecf:	e8 7f f3 ff ff       	call   802253 <set_block_data>
  802ed4:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802ed7:	8b 45 10             	mov    0x10(%ebp),%eax
  802eda:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802edd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ee1:	74 06                	je     802ee9 <merging+0x1c6>
  802ee3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ee7:	75 17                	jne    802f00 <merging+0x1dd>
  802ee9:	83 ec 04             	sub    $0x4,%esp
  802eec:	68 40 48 80 00       	push   $0x804840
  802ef1:	68 8d 01 00 00       	push   $0x18d
  802ef6:	68 85 47 80 00       	push   $0x804785
  802efb:	e8 ba d4 ff ff       	call   8003ba <_panic>
  802f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f03:	8b 50 04             	mov    0x4(%eax),%edx
  802f06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f09:	89 50 04             	mov    %edx,0x4(%eax)
  802f0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f12:	89 10                	mov    %edx,(%eax)
  802f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f17:	8b 40 04             	mov    0x4(%eax),%eax
  802f1a:	85 c0                	test   %eax,%eax
  802f1c:	74 0d                	je     802f2b <merging+0x208>
  802f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f21:	8b 40 04             	mov    0x4(%eax),%eax
  802f24:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f27:	89 10                	mov    %edx,(%eax)
  802f29:	eb 08                	jmp    802f33 <merging+0x210>
  802f2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f2e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f33:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f36:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f39:	89 50 04             	mov    %edx,0x4(%eax)
  802f3c:	a1 38 50 80 00       	mov    0x805038,%eax
  802f41:	40                   	inc    %eax
  802f42:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802f47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f4b:	75 17                	jne    802f64 <merging+0x241>
  802f4d:	83 ec 04             	sub    $0x4,%esp
  802f50:	68 67 47 80 00       	push   $0x804767
  802f55:	68 8e 01 00 00       	push   $0x18e
  802f5a:	68 85 47 80 00       	push   $0x804785
  802f5f:	e8 56 d4 ff ff       	call   8003ba <_panic>
  802f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f67:	8b 00                	mov    (%eax),%eax
  802f69:	85 c0                	test   %eax,%eax
  802f6b:	74 10                	je     802f7d <merging+0x25a>
  802f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f70:	8b 00                	mov    (%eax),%eax
  802f72:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f75:	8b 52 04             	mov    0x4(%edx),%edx
  802f78:	89 50 04             	mov    %edx,0x4(%eax)
  802f7b:	eb 0b                	jmp    802f88 <merging+0x265>
  802f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f80:	8b 40 04             	mov    0x4(%eax),%eax
  802f83:	a3 30 50 80 00       	mov    %eax,0x805030
  802f88:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f8b:	8b 40 04             	mov    0x4(%eax),%eax
  802f8e:	85 c0                	test   %eax,%eax
  802f90:	74 0f                	je     802fa1 <merging+0x27e>
  802f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f95:	8b 40 04             	mov    0x4(%eax),%eax
  802f98:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f9b:	8b 12                	mov    (%edx),%edx
  802f9d:	89 10                	mov    %edx,(%eax)
  802f9f:	eb 0a                	jmp    802fab <merging+0x288>
  802fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa4:	8b 00                	mov    (%eax),%eax
  802fa6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fab:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fbe:	a1 38 50 80 00       	mov    0x805038,%eax
  802fc3:	48                   	dec    %eax
  802fc4:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fc9:	e9 72 01 00 00       	jmp    803140 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802fce:	8b 45 10             	mov    0x10(%ebp),%eax
  802fd1:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802fd4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd8:	74 79                	je     803053 <merging+0x330>
  802fda:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fde:	74 73                	je     803053 <merging+0x330>
  802fe0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fe4:	74 06                	je     802fec <merging+0x2c9>
  802fe6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fea:	75 17                	jne    803003 <merging+0x2e0>
  802fec:	83 ec 04             	sub    $0x4,%esp
  802fef:	68 f8 47 80 00       	push   $0x8047f8
  802ff4:	68 94 01 00 00       	push   $0x194
  802ff9:	68 85 47 80 00       	push   $0x804785
  802ffe:	e8 b7 d3 ff ff       	call   8003ba <_panic>
  803003:	8b 45 08             	mov    0x8(%ebp),%eax
  803006:	8b 10                	mov    (%eax),%edx
  803008:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80300b:	89 10                	mov    %edx,(%eax)
  80300d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803010:	8b 00                	mov    (%eax),%eax
  803012:	85 c0                	test   %eax,%eax
  803014:	74 0b                	je     803021 <merging+0x2fe>
  803016:	8b 45 08             	mov    0x8(%ebp),%eax
  803019:	8b 00                	mov    (%eax),%eax
  80301b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80301e:	89 50 04             	mov    %edx,0x4(%eax)
  803021:	8b 45 08             	mov    0x8(%ebp),%eax
  803024:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803027:	89 10                	mov    %edx,(%eax)
  803029:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80302c:	8b 55 08             	mov    0x8(%ebp),%edx
  80302f:	89 50 04             	mov    %edx,0x4(%eax)
  803032:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803035:	8b 00                	mov    (%eax),%eax
  803037:	85 c0                	test   %eax,%eax
  803039:	75 08                	jne    803043 <merging+0x320>
  80303b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80303e:	a3 30 50 80 00       	mov    %eax,0x805030
  803043:	a1 38 50 80 00       	mov    0x805038,%eax
  803048:	40                   	inc    %eax
  803049:	a3 38 50 80 00       	mov    %eax,0x805038
  80304e:	e9 ce 00 00 00       	jmp    803121 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803053:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803057:	74 65                	je     8030be <merging+0x39b>
  803059:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80305d:	75 17                	jne    803076 <merging+0x353>
  80305f:	83 ec 04             	sub    $0x4,%esp
  803062:	68 d4 47 80 00       	push   $0x8047d4
  803067:	68 95 01 00 00       	push   $0x195
  80306c:	68 85 47 80 00       	push   $0x804785
  803071:	e8 44 d3 ff ff       	call   8003ba <_panic>
  803076:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80307c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80307f:	89 50 04             	mov    %edx,0x4(%eax)
  803082:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803085:	8b 40 04             	mov    0x4(%eax),%eax
  803088:	85 c0                	test   %eax,%eax
  80308a:	74 0c                	je     803098 <merging+0x375>
  80308c:	a1 30 50 80 00       	mov    0x805030,%eax
  803091:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803094:	89 10                	mov    %edx,(%eax)
  803096:	eb 08                	jmp    8030a0 <merging+0x37d>
  803098:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80309b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030a3:	a3 30 50 80 00       	mov    %eax,0x805030
  8030a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030b1:	a1 38 50 80 00       	mov    0x805038,%eax
  8030b6:	40                   	inc    %eax
  8030b7:	a3 38 50 80 00       	mov    %eax,0x805038
  8030bc:	eb 63                	jmp    803121 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8030be:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030c2:	75 17                	jne    8030db <merging+0x3b8>
  8030c4:	83 ec 04             	sub    $0x4,%esp
  8030c7:	68 a0 47 80 00       	push   $0x8047a0
  8030cc:	68 98 01 00 00       	push   $0x198
  8030d1:	68 85 47 80 00       	push   $0x804785
  8030d6:	e8 df d2 ff ff       	call   8003ba <_panic>
  8030db:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8030e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e4:	89 10                	mov    %edx,(%eax)
  8030e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e9:	8b 00                	mov    (%eax),%eax
  8030eb:	85 c0                	test   %eax,%eax
  8030ed:	74 0d                	je     8030fc <merging+0x3d9>
  8030ef:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030f4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030f7:	89 50 04             	mov    %edx,0x4(%eax)
  8030fa:	eb 08                	jmp    803104 <merging+0x3e1>
  8030fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ff:	a3 30 50 80 00       	mov    %eax,0x805030
  803104:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803107:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80310c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80310f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803116:	a1 38 50 80 00       	mov    0x805038,%eax
  80311b:	40                   	inc    %eax
  80311c:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803121:	83 ec 0c             	sub    $0xc,%esp
  803124:	ff 75 10             	pushl  0x10(%ebp)
  803127:	e8 d6 ed ff ff       	call   801f02 <get_block_size>
  80312c:	83 c4 10             	add    $0x10,%esp
  80312f:	83 ec 04             	sub    $0x4,%esp
  803132:	6a 00                	push   $0x0
  803134:	50                   	push   %eax
  803135:	ff 75 10             	pushl  0x10(%ebp)
  803138:	e8 16 f1 ff ff       	call   802253 <set_block_data>
  80313d:	83 c4 10             	add    $0x10,%esp
	}
}
  803140:	90                   	nop
  803141:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803144:	c9                   	leave  
  803145:	c3                   	ret    

00803146 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803146:	55                   	push   %ebp
  803147:	89 e5                	mov    %esp,%ebp
  803149:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80314c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803151:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803154:	a1 30 50 80 00       	mov    0x805030,%eax
  803159:	3b 45 08             	cmp    0x8(%ebp),%eax
  80315c:	73 1b                	jae    803179 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80315e:	a1 30 50 80 00       	mov    0x805030,%eax
  803163:	83 ec 04             	sub    $0x4,%esp
  803166:	ff 75 08             	pushl  0x8(%ebp)
  803169:	6a 00                	push   $0x0
  80316b:	50                   	push   %eax
  80316c:	e8 b2 fb ff ff       	call   802d23 <merging>
  803171:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803174:	e9 8b 00 00 00       	jmp    803204 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803179:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80317e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803181:	76 18                	jbe    80319b <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803183:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803188:	83 ec 04             	sub    $0x4,%esp
  80318b:	ff 75 08             	pushl  0x8(%ebp)
  80318e:	50                   	push   %eax
  80318f:	6a 00                	push   $0x0
  803191:	e8 8d fb ff ff       	call   802d23 <merging>
  803196:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803199:	eb 69                	jmp    803204 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80319b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031a3:	eb 39                	jmp    8031de <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8031a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031ab:	73 29                	jae    8031d6 <free_block+0x90>
  8031ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b0:	8b 00                	mov    (%eax),%eax
  8031b2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031b5:	76 1f                	jbe    8031d6 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8031b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ba:	8b 00                	mov    (%eax),%eax
  8031bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8031bf:	83 ec 04             	sub    $0x4,%esp
  8031c2:	ff 75 08             	pushl  0x8(%ebp)
  8031c5:	ff 75 f0             	pushl  -0x10(%ebp)
  8031c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8031cb:	e8 53 fb ff ff       	call   802d23 <merging>
  8031d0:	83 c4 10             	add    $0x10,%esp
			break;
  8031d3:	90                   	nop
		}
	}
}
  8031d4:	eb 2e                	jmp    803204 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031d6:	a1 34 50 80 00       	mov    0x805034,%eax
  8031db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e2:	74 07                	je     8031eb <free_block+0xa5>
  8031e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e7:	8b 00                	mov    (%eax),%eax
  8031e9:	eb 05                	jmp    8031f0 <free_block+0xaa>
  8031eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8031f0:	a3 34 50 80 00       	mov    %eax,0x805034
  8031f5:	a1 34 50 80 00       	mov    0x805034,%eax
  8031fa:	85 c0                	test   %eax,%eax
  8031fc:	75 a7                	jne    8031a5 <free_block+0x5f>
  8031fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803202:	75 a1                	jne    8031a5 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803204:	90                   	nop
  803205:	c9                   	leave  
  803206:	c3                   	ret    

00803207 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803207:	55                   	push   %ebp
  803208:	89 e5                	mov    %esp,%ebp
  80320a:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80320d:	ff 75 08             	pushl  0x8(%ebp)
  803210:	e8 ed ec ff ff       	call   801f02 <get_block_size>
  803215:	83 c4 04             	add    $0x4,%esp
  803218:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80321b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803222:	eb 17                	jmp    80323b <copy_data+0x34>
  803224:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80322a:	01 c2                	add    %eax,%edx
  80322c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80322f:	8b 45 08             	mov    0x8(%ebp),%eax
  803232:	01 c8                	add    %ecx,%eax
  803234:	8a 00                	mov    (%eax),%al
  803236:	88 02                	mov    %al,(%edx)
  803238:	ff 45 fc             	incl   -0x4(%ebp)
  80323b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80323e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803241:	72 e1                	jb     803224 <copy_data+0x1d>
}
  803243:	90                   	nop
  803244:	c9                   	leave  
  803245:	c3                   	ret    

00803246 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803246:	55                   	push   %ebp
  803247:	89 e5                	mov    %esp,%ebp
  803249:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80324c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803250:	75 23                	jne    803275 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803252:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803256:	74 13                	je     80326b <realloc_block_FF+0x25>
  803258:	83 ec 0c             	sub    $0xc,%esp
  80325b:	ff 75 0c             	pushl  0xc(%ebp)
  80325e:	e8 1f f0 ff ff       	call   802282 <alloc_block_FF>
  803263:	83 c4 10             	add    $0x10,%esp
  803266:	e9 f4 06 00 00       	jmp    80395f <realloc_block_FF+0x719>
		return NULL;
  80326b:	b8 00 00 00 00       	mov    $0x0,%eax
  803270:	e9 ea 06 00 00       	jmp    80395f <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803275:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803279:	75 18                	jne    803293 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80327b:	83 ec 0c             	sub    $0xc,%esp
  80327e:	ff 75 08             	pushl  0x8(%ebp)
  803281:	e8 c0 fe ff ff       	call   803146 <free_block>
  803286:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803289:	b8 00 00 00 00       	mov    $0x0,%eax
  80328e:	e9 cc 06 00 00       	jmp    80395f <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803293:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803297:	77 07                	ja     8032a0 <realloc_block_FF+0x5a>
  803299:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8032a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032a3:	83 e0 01             	and    $0x1,%eax
  8032a6:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8032a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ac:	83 c0 08             	add    $0x8,%eax
  8032af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8032b2:	83 ec 0c             	sub    $0xc,%esp
  8032b5:	ff 75 08             	pushl  0x8(%ebp)
  8032b8:	e8 45 ec ff ff       	call   801f02 <get_block_size>
  8032bd:	83 c4 10             	add    $0x10,%esp
  8032c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c6:	83 e8 08             	sub    $0x8,%eax
  8032c9:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8032cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cf:	83 e8 04             	sub    $0x4,%eax
  8032d2:	8b 00                	mov    (%eax),%eax
  8032d4:	83 e0 fe             	and    $0xfffffffe,%eax
  8032d7:	89 c2                	mov    %eax,%edx
  8032d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dc:	01 d0                	add    %edx,%eax
  8032de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8032e1:	83 ec 0c             	sub    $0xc,%esp
  8032e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8032e7:	e8 16 ec ff ff       	call   801f02 <get_block_size>
  8032ec:	83 c4 10             	add    $0x10,%esp
  8032ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032f5:	83 e8 08             	sub    $0x8,%eax
  8032f8:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8032fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032fe:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803301:	75 08                	jne    80330b <realloc_block_FF+0xc5>
	{
		 return va;
  803303:	8b 45 08             	mov    0x8(%ebp),%eax
  803306:	e9 54 06 00 00       	jmp    80395f <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80330b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80330e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803311:	0f 83 e5 03 00 00    	jae    8036fc <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803317:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331a:	2b 45 0c             	sub    0xc(%ebp),%eax
  80331d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803320:	83 ec 0c             	sub    $0xc,%esp
  803323:	ff 75 e4             	pushl  -0x1c(%ebp)
  803326:	e8 f0 eb ff ff       	call   801f1b <is_free_block>
  80332b:	83 c4 10             	add    $0x10,%esp
  80332e:	84 c0                	test   %al,%al
  803330:	0f 84 3b 01 00 00    	je     803471 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803336:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803339:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80333c:	01 d0                	add    %edx,%eax
  80333e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803341:	83 ec 04             	sub    $0x4,%esp
  803344:	6a 01                	push   $0x1
  803346:	ff 75 f0             	pushl  -0x10(%ebp)
  803349:	ff 75 08             	pushl  0x8(%ebp)
  80334c:	e8 02 ef ff ff       	call   802253 <set_block_data>
  803351:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803354:	8b 45 08             	mov    0x8(%ebp),%eax
  803357:	83 e8 04             	sub    $0x4,%eax
  80335a:	8b 00                	mov    (%eax),%eax
  80335c:	83 e0 fe             	and    $0xfffffffe,%eax
  80335f:	89 c2                	mov    %eax,%edx
  803361:	8b 45 08             	mov    0x8(%ebp),%eax
  803364:	01 d0                	add    %edx,%eax
  803366:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803369:	83 ec 04             	sub    $0x4,%esp
  80336c:	6a 00                	push   $0x0
  80336e:	ff 75 cc             	pushl  -0x34(%ebp)
  803371:	ff 75 c8             	pushl  -0x38(%ebp)
  803374:	e8 da ee ff ff       	call   802253 <set_block_data>
  803379:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80337c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803380:	74 06                	je     803388 <realloc_block_FF+0x142>
  803382:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803386:	75 17                	jne    80339f <realloc_block_FF+0x159>
  803388:	83 ec 04             	sub    $0x4,%esp
  80338b:	68 f8 47 80 00       	push   $0x8047f8
  803390:	68 f6 01 00 00       	push   $0x1f6
  803395:	68 85 47 80 00       	push   $0x804785
  80339a:	e8 1b d0 ff ff       	call   8003ba <_panic>
  80339f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033a2:	8b 10                	mov    (%eax),%edx
  8033a4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033a7:	89 10                	mov    %edx,(%eax)
  8033a9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033ac:	8b 00                	mov    (%eax),%eax
  8033ae:	85 c0                	test   %eax,%eax
  8033b0:	74 0b                	je     8033bd <realloc_block_FF+0x177>
  8033b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b5:	8b 00                	mov    (%eax),%eax
  8033b7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033ba:	89 50 04             	mov    %edx,0x4(%eax)
  8033bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033c3:	89 10                	mov    %edx,(%eax)
  8033c5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033cb:	89 50 04             	mov    %edx,0x4(%eax)
  8033ce:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033d1:	8b 00                	mov    (%eax),%eax
  8033d3:	85 c0                	test   %eax,%eax
  8033d5:	75 08                	jne    8033df <realloc_block_FF+0x199>
  8033d7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033da:	a3 30 50 80 00       	mov    %eax,0x805030
  8033df:	a1 38 50 80 00       	mov    0x805038,%eax
  8033e4:	40                   	inc    %eax
  8033e5:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8033ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033ee:	75 17                	jne    803407 <realloc_block_FF+0x1c1>
  8033f0:	83 ec 04             	sub    $0x4,%esp
  8033f3:	68 67 47 80 00       	push   $0x804767
  8033f8:	68 f7 01 00 00       	push   $0x1f7
  8033fd:	68 85 47 80 00       	push   $0x804785
  803402:	e8 b3 cf ff ff       	call   8003ba <_panic>
  803407:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80340a:	8b 00                	mov    (%eax),%eax
  80340c:	85 c0                	test   %eax,%eax
  80340e:	74 10                	je     803420 <realloc_block_FF+0x1da>
  803410:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803413:	8b 00                	mov    (%eax),%eax
  803415:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803418:	8b 52 04             	mov    0x4(%edx),%edx
  80341b:	89 50 04             	mov    %edx,0x4(%eax)
  80341e:	eb 0b                	jmp    80342b <realloc_block_FF+0x1e5>
  803420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803423:	8b 40 04             	mov    0x4(%eax),%eax
  803426:	a3 30 50 80 00       	mov    %eax,0x805030
  80342b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80342e:	8b 40 04             	mov    0x4(%eax),%eax
  803431:	85 c0                	test   %eax,%eax
  803433:	74 0f                	je     803444 <realloc_block_FF+0x1fe>
  803435:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803438:	8b 40 04             	mov    0x4(%eax),%eax
  80343b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80343e:	8b 12                	mov    (%edx),%edx
  803440:	89 10                	mov    %edx,(%eax)
  803442:	eb 0a                	jmp    80344e <realloc_block_FF+0x208>
  803444:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803447:	8b 00                	mov    (%eax),%eax
  803449:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80344e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803451:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803457:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803461:	a1 38 50 80 00       	mov    0x805038,%eax
  803466:	48                   	dec    %eax
  803467:	a3 38 50 80 00       	mov    %eax,0x805038
  80346c:	e9 83 02 00 00       	jmp    8036f4 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803471:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803475:	0f 86 69 02 00 00    	jbe    8036e4 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80347b:	83 ec 04             	sub    $0x4,%esp
  80347e:	6a 01                	push   $0x1
  803480:	ff 75 f0             	pushl  -0x10(%ebp)
  803483:	ff 75 08             	pushl  0x8(%ebp)
  803486:	e8 c8 ed ff ff       	call   802253 <set_block_data>
  80348b:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80348e:	8b 45 08             	mov    0x8(%ebp),%eax
  803491:	83 e8 04             	sub    $0x4,%eax
  803494:	8b 00                	mov    (%eax),%eax
  803496:	83 e0 fe             	and    $0xfffffffe,%eax
  803499:	89 c2                	mov    %eax,%edx
  80349b:	8b 45 08             	mov    0x8(%ebp),%eax
  80349e:	01 d0                	add    %edx,%eax
  8034a0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8034a3:	a1 38 50 80 00       	mov    0x805038,%eax
  8034a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8034ab:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8034af:	75 68                	jne    803519 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034b1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034b5:	75 17                	jne    8034ce <realloc_block_FF+0x288>
  8034b7:	83 ec 04             	sub    $0x4,%esp
  8034ba:	68 a0 47 80 00       	push   $0x8047a0
  8034bf:	68 06 02 00 00       	push   $0x206
  8034c4:	68 85 47 80 00       	push   $0x804785
  8034c9:	e8 ec ce ff ff       	call   8003ba <_panic>
  8034ce:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d7:	89 10                	mov    %edx,(%eax)
  8034d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034dc:	8b 00                	mov    (%eax),%eax
  8034de:	85 c0                	test   %eax,%eax
  8034e0:	74 0d                	je     8034ef <realloc_block_FF+0x2a9>
  8034e2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034ea:	89 50 04             	mov    %edx,0x4(%eax)
  8034ed:	eb 08                	jmp    8034f7 <realloc_block_FF+0x2b1>
  8034ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034f2:	a3 30 50 80 00       	mov    %eax,0x805030
  8034f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034fa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803502:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803509:	a1 38 50 80 00       	mov    0x805038,%eax
  80350e:	40                   	inc    %eax
  80350f:	a3 38 50 80 00       	mov    %eax,0x805038
  803514:	e9 b0 01 00 00       	jmp    8036c9 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803519:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80351e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803521:	76 68                	jbe    80358b <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803523:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803527:	75 17                	jne    803540 <realloc_block_FF+0x2fa>
  803529:	83 ec 04             	sub    $0x4,%esp
  80352c:	68 a0 47 80 00       	push   $0x8047a0
  803531:	68 0b 02 00 00       	push   $0x20b
  803536:	68 85 47 80 00       	push   $0x804785
  80353b:	e8 7a ce ff ff       	call   8003ba <_panic>
  803540:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803546:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803549:	89 10                	mov    %edx,(%eax)
  80354b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80354e:	8b 00                	mov    (%eax),%eax
  803550:	85 c0                	test   %eax,%eax
  803552:	74 0d                	je     803561 <realloc_block_FF+0x31b>
  803554:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803559:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80355c:	89 50 04             	mov    %edx,0x4(%eax)
  80355f:	eb 08                	jmp    803569 <realloc_block_FF+0x323>
  803561:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803564:	a3 30 50 80 00       	mov    %eax,0x805030
  803569:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80356c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803571:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803574:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80357b:	a1 38 50 80 00       	mov    0x805038,%eax
  803580:	40                   	inc    %eax
  803581:	a3 38 50 80 00       	mov    %eax,0x805038
  803586:	e9 3e 01 00 00       	jmp    8036c9 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80358b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803590:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803593:	73 68                	jae    8035fd <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803595:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803599:	75 17                	jne    8035b2 <realloc_block_FF+0x36c>
  80359b:	83 ec 04             	sub    $0x4,%esp
  80359e:	68 d4 47 80 00       	push   $0x8047d4
  8035a3:	68 10 02 00 00       	push   $0x210
  8035a8:	68 85 47 80 00       	push   $0x804785
  8035ad:	e8 08 ce ff ff       	call   8003ba <_panic>
  8035b2:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8035b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035bb:	89 50 04             	mov    %edx,0x4(%eax)
  8035be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c1:	8b 40 04             	mov    0x4(%eax),%eax
  8035c4:	85 c0                	test   %eax,%eax
  8035c6:	74 0c                	je     8035d4 <realloc_block_FF+0x38e>
  8035c8:	a1 30 50 80 00       	mov    0x805030,%eax
  8035cd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035d0:	89 10                	mov    %edx,(%eax)
  8035d2:	eb 08                	jmp    8035dc <realloc_block_FF+0x396>
  8035d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035df:	a3 30 50 80 00       	mov    %eax,0x805030
  8035e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035ed:	a1 38 50 80 00       	mov    0x805038,%eax
  8035f2:	40                   	inc    %eax
  8035f3:	a3 38 50 80 00       	mov    %eax,0x805038
  8035f8:	e9 cc 00 00 00       	jmp    8036c9 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8035fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803604:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803609:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80360c:	e9 8a 00 00 00       	jmp    80369b <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803614:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803617:	73 7a                	jae    803693 <realloc_block_FF+0x44d>
  803619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361c:	8b 00                	mov    (%eax),%eax
  80361e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803621:	73 70                	jae    803693 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803623:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803627:	74 06                	je     80362f <realloc_block_FF+0x3e9>
  803629:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80362d:	75 17                	jne    803646 <realloc_block_FF+0x400>
  80362f:	83 ec 04             	sub    $0x4,%esp
  803632:	68 f8 47 80 00       	push   $0x8047f8
  803637:	68 1a 02 00 00       	push   $0x21a
  80363c:	68 85 47 80 00       	push   $0x804785
  803641:	e8 74 cd ff ff       	call   8003ba <_panic>
  803646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803649:	8b 10                	mov    (%eax),%edx
  80364b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80364e:	89 10                	mov    %edx,(%eax)
  803650:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803653:	8b 00                	mov    (%eax),%eax
  803655:	85 c0                	test   %eax,%eax
  803657:	74 0b                	je     803664 <realloc_block_FF+0x41e>
  803659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365c:	8b 00                	mov    (%eax),%eax
  80365e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803661:	89 50 04             	mov    %edx,0x4(%eax)
  803664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803667:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80366a:	89 10                	mov    %edx,(%eax)
  80366c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80366f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803672:	89 50 04             	mov    %edx,0x4(%eax)
  803675:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803678:	8b 00                	mov    (%eax),%eax
  80367a:	85 c0                	test   %eax,%eax
  80367c:	75 08                	jne    803686 <realloc_block_FF+0x440>
  80367e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803681:	a3 30 50 80 00       	mov    %eax,0x805030
  803686:	a1 38 50 80 00       	mov    0x805038,%eax
  80368b:	40                   	inc    %eax
  80368c:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803691:	eb 36                	jmp    8036c9 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803693:	a1 34 50 80 00       	mov    0x805034,%eax
  803698:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80369b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80369f:	74 07                	je     8036a8 <realloc_block_FF+0x462>
  8036a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a4:	8b 00                	mov    (%eax),%eax
  8036a6:	eb 05                	jmp    8036ad <realloc_block_FF+0x467>
  8036a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8036ad:	a3 34 50 80 00       	mov    %eax,0x805034
  8036b2:	a1 34 50 80 00       	mov    0x805034,%eax
  8036b7:	85 c0                	test   %eax,%eax
  8036b9:	0f 85 52 ff ff ff    	jne    803611 <realloc_block_FF+0x3cb>
  8036bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036c3:	0f 85 48 ff ff ff    	jne    803611 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8036c9:	83 ec 04             	sub    $0x4,%esp
  8036cc:	6a 00                	push   $0x0
  8036ce:	ff 75 d8             	pushl  -0x28(%ebp)
  8036d1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8036d4:	e8 7a eb ff ff       	call   802253 <set_block_data>
  8036d9:	83 c4 10             	add    $0x10,%esp
				return va;
  8036dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036df:	e9 7b 02 00 00       	jmp    80395f <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8036e4:	83 ec 0c             	sub    $0xc,%esp
  8036e7:	68 75 48 80 00       	push   $0x804875
  8036ec:	e8 86 cf ff ff       	call   800677 <cprintf>
  8036f1:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8036f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f7:	e9 63 02 00 00       	jmp    80395f <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8036fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ff:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803702:	0f 86 4d 02 00 00    	jbe    803955 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803708:	83 ec 0c             	sub    $0xc,%esp
  80370b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80370e:	e8 08 e8 ff ff       	call   801f1b <is_free_block>
  803713:	83 c4 10             	add    $0x10,%esp
  803716:	84 c0                	test   %al,%al
  803718:	0f 84 37 02 00 00    	je     803955 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80371e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803721:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803724:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803727:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80372a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80372d:	76 38                	jbe    803767 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80372f:	83 ec 0c             	sub    $0xc,%esp
  803732:	ff 75 08             	pushl  0x8(%ebp)
  803735:	e8 0c fa ff ff       	call   803146 <free_block>
  80373a:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80373d:	83 ec 0c             	sub    $0xc,%esp
  803740:	ff 75 0c             	pushl  0xc(%ebp)
  803743:	e8 3a eb ff ff       	call   802282 <alloc_block_FF>
  803748:	83 c4 10             	add    $0x10,%esp
  80374b:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80374e:	83 ec 08             	sub    $0x8,%esp
  803751:	ff 75 c0             	pushl  -0x40(%ebp)
  803754:	ff 75 08             	pushl  0x8(%ebp)
  803757:	e8 ab fa ff ff       	call   803207 <copy_data>
  80375c:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80375f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803762:	e9 f8 01 00 00       	jmp    80395f <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803767:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80376a:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80376d:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803770:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803774:	0f 87 a0 00 00 00    	ja     80381a <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80377a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80377e:	75 17                	jne    803797 <realloc_block_FF+0x551>
  803780:	83 ec 04             	sub    $0x4,%esp
  803783:	68 67 47 80 00       	push   $0x804767
  803788:	68 38 02 00 00       	push   $0x238
  80378d:	68 85 47 80 00       	push   $0x804785
  803792:	e8 23 cc ff ff       	call   8003ba <_panic>
  803797:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379a:	8b 00                	mov    (%eax),%eax
  80379c:	85 c0                	test   %eax,%eax
  80379e:	74 10                	je     8037b0 <realloc_block_FF+0x56a>
  8037a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a3:	8b 00                	mov    (%eax),%eax
  8037a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037a8:	8b 52 04             	mov    0x4(%edx),%edx
  8037ab:	89 50 04             	mov    %edx,0x4(%eax)
  8037ae:	eb 0b                	jmp    8037bb <realloc_block_FF+0x575>
  8037b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b3:	8b 40 04             	mov    0x4(%eax),%eax
  8037b6:	a3 30 50 80 00       	mov    %eax,0x805030
  8037bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037be:	8b 40 04             	mov    0x4(%eax),%eax
  8037c1:	85 c0                	test   %eax,%eax
  8037c3:	74 0f                	je     8037d4 <realloc_block_FF+0x58e>
  8037c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c8:	8b 40 04             	mov    0x4(%eax),%eax
  8037cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037ce:	8b 12                	mov    (%edx),%edx
  8037d0:	89 10                	mov    %edx,(%eax)
  8037d2:	eb 0a                	jmp    8037de <realloc_block_FF+0x598>
  8037d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d7:	8b 00                	mov    (%eax),%eax
  8037d9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037f1:	a1 38 50 80 00       	mov    0x805038,%eax
  8037f6:	48                   	dec    %eax
  8037f7:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8037fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803802:	01 d0                	add    %edx,%eax
  803804:	83 ec 04             	sub    $0x4,%esp
  803807:	6a 01                	push   $0x1
  803809:	50                   	push   %eax
  80380a:	ff 75 08             	pushl  0x8(%ebp)
  80380d:	e8 41 ea ff ff       	call   802253 <set_block_data>
  803812:	83 c4 10             	add    $0x10,%esp
  803815:	e9 36 01 00 00       	jmp    803950 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80381a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80381d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803820:	01 d0                	add    %edx,%eax
  803822:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803825:	83 ec 04             	sub    $0x4,%esp
  803828:	6a 01                	push   $0x1
  80382a:	ff 75 f0             	pushl  -0x10(%ebp)
  80382d:	ff 75 08             	pushl  0x8(%ebp)
  803830:	e8 1e ea ff ff       	call   802253 <set_block_data>
  803835:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803838:	8b 45 08             	mov    0x8(%ebp),%eax
  80383b:	83 e8 04             	sub    $0x4,%eax
  80383e:	8b 00                	mov    (%eax),%eax
  803840:	83 e0 fe             	and    $0xfffffffe,%eax
  803843:	89 c2                	mov    %eax,%edx
  803845:	8b 45 08             	mov    0x8(%ebp),%eax
  803848:	01 d0                	add    %edx,%eax
  80384a:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80384d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803851:	74 06                	je     803859 <realloc_block_FF+0x613>
  803853:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803857:	75 17                	jne    803870 <realloc_block_FF+0x62a>
  803859:	83 ec 04             	sub    $0x4,%esp
  80385c:	68 f8 47 80 00       	push   $0x8047f8
  803861:	68 44 02 00 00       	push   $0x244
  803866:	68 85 47 80 00       	push   $0x804785
  80386b:	e8 4a cb ff ff       	call   8003ba <_panic>
  803870:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803873:	8b 10                	mov    (%eax),%edx
  803875:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803878:	89 10                	mov    %edx,(%eax)
  80387a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80387d:	8b 00                	mov    (%eax),%eax
  80387f:	85 c0                	test   %eax,%eax
  803881:	74 0b                	je     80388e <realloc_block_FF+0x648>
  803883:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803886:	8b 00                	mov    (%eax),%eax
  803888:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80388b:	89 50 04             	mov    %edx,0x4(%eax)
  80388e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803891:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803894:	89 10                	mov    %edx,(%eax)
  803896:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803899:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80389c:	89 50 04             	mov    %edx,0x4(%eax)
  80389f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038a2:	8b 00                	mov    (%eax),%eax
  8038a4:	85 c0                	test   %eax,%eax
  8038a6:	75 08                	jne    8038b0 <realloc_block_FF+0x66a>
  8038a8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038ab:	a3 30 50 80 00       	mov    %eax,0x805030
  8038b0:	a1 38 50 80 00       	mov    0x805038,%eax
  8038b5:	40                   	inc    %eax
  8038b6:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8038bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038bf:	75 17                	jne    8038d8 <realloc_block_FF+0x692>
  8038c1:	83 ec 04             	sub    $0x4,%esp
  8038c4:	68 67 47 80 00       	push   $0x804767
  8038c9:	68 45 02 00 00       	push   $0x245
  8038ce:	68 85 47 80 00       	push   $0x804785
  8038d3:	e8 e2 ca ff ff       	call   8003ba <_panic>
  8038d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038db:	8b 00                	mov    (%eax),%eax
  8038dd:	85 c0                	test   %eax,%eax
  8038df:	74 10                	je     8038f1 <realloc_block_FF+0x6ab>
  8038e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e4:	8b 00                	mov    (%eax),%eax
  8038e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038e9:	8b 52 04             	mov    0x4(%edx),%edx
  8038ec:	89 50 04             	mov    %edx,0x4(%eax)
  8038ef:	eb 0b                	jmp    8038fc <realloc_block_FF+0x6b6>
  8038f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f4:	8b 40 04             	mov    0x4(%eax),%eax
  8038f7:	a3 30 50 80 00       	mov    %eax,0x805030
  8038fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ff:	8b 40 04             	mov    0x4(%eax),%eax
  803902:	85 c0                	test   %eax,%eax
  803904:	74 0f                	je     803915 <realloc_block_FF+0x6cf>
  803906:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803909:	8b 40 04             	mov    0x4(%eax),%eax
  80390c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80390f:	8b 12                	mov    (%edx),%edx
  803911:	89 10                	mov    %edx,(%eax)
  803913:	eb 0a                	jmp    80391f <realloc_block_FF+0x6d9>
  803915:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803918:	8b 00                	mov    (%eax),%eax
  80391a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80391f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803922:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803928:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80392b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803932:	a1 38 50 80 00       	mov    0x805038,%eax
  803937:	48                   	dec    %eax
  803938:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  80393d:	83 ec 04             	sub    $0x4,%esp
  803940:	6a 00                	push   $0x0
  803942:	ff 75 bc             	pushl  -0x44(%ebp)
  803945:	ff 75 b8             	pushl  -0x48(%ebp)
  803948:	e8 06 e9 ff ff       	call   802253 <set_block_data>
  80394d:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803950:	8b 45 08             	mov    0x8(%ebp),%eax
  803953:	eb 0a                	jmp    80395f <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803955:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80395c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80395f:	c9                   	leave  
  803960:	c3                   	ret    

00803961 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803961:	55                   	push   %ebp
  803962:	89 e5                	mov    %esp,%ebp
  803964:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803967:	83 ec 04             	sub    $0x4,%esp
  80396a:	68 7c 48 80 00       	push   $0x80487c
  80396f:	68 58 02 00 00       	push   $0x258
  803974:	68 85 47 80 00       	push   $0x804785
  803979:	e8 3c ca ff ff       	call   8003ba <_panic>

0080397e <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80397e:	55                   	push   %ebp
  80397f:	89 e5                	mov    %esp,%ebp
  803981:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803984:	83 ec 04             	sub    $0x4,%esp
  803987:	68 a4 48 80 00       	push   $0x8048a4
  80398c:	68 61 02 00 00       	push   $0x261
  803991:	68 85 47 80 00       	push   $0x804785
  803996:	e8 1f ca ff ff       	call   8003ba <_panic>
  80399b:	90                   	nop

0080399c <__udivdi3>:
  80399c:	55                   	push   %ebp
  80399d:	57                   	push   %edi
  80399e:	56                   	push   %esi
  80399f:	53                   	push   %ebx
  8039a0:	83 ec 1c             	sub    $0x1c,%esp
  8039a3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039a7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039b3:	89 ca                	mov    %ecx,%edx
  8039b5:	89 f8                	mov    %edi,%eax
  8039b7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039bb:	85 f6                	test   %esi,%esi
  8039bd:	75 2d                	jne    8039ec <__udivdi3+0x50>
  8039bf:	39 cf                	cmp    %ecx,%edi
  8039c1:	77 65                	ja     803a28 <__udivdi3+0x8c>
  8039c3:	89 fd                	mov    %edi,%ebp
  8039c5:	85 ff                	test   %edi,%edi
  8039c7:	75 0b                	jne    8039d4 <__udivdi3+0x38>
  8039c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8039ce:	31 d2                	xor    %edx,%edx
  8039d0:	f7 f7                	div    %edi
  8039d2:	89 c5                	mov    %eax,%ebp
  8039d4:	31 d2                	xor    %edx,%edx
  8039d6:	89 c8                	mov    %ecx,%eax
  8039d8:	f7 f5                	div    %ebp
  8039da:	89 c1                	mov    %eax,%ecx
  8039dc:	89 d8                	mov    %ebx,%eax
  8039de:	f7 f5                	div    %ebp
  8039e0:	89 cf                	mov    %ecx,%edi
  8039e2:	89 fa                	mov    %edi,%edx
  8039e4:	83 c4 1c             	add    $0x1c,%esp
  8039e7:	5b                   	pop    %ebx
  8039e8:	5e                   	pop    %esi
  8039e9:	5f                   	pop    %edi
  8039ea:	5d                   	pop    %ebp
  8039eb:	c3                   	ret    
  8039ec:	39 ce                	cmp    %ecx,%esi
  8039ee:	77 28                	ja     803a18 <__udivdi3+0x7c>
  8039f0:	0f bd fe             	bsr    %esi,%edi
  8039f3:	83 f7 1f             	xor    $0x1f,%edi
  8039f6:	75 40                	jne    803a38 <__udivdi3+0x9c>
  8039f8:	39 ce                	cmp    %ecx,%esi
  8039fa:	72 0a                	jb     803a06 <__udivdi3+0x6a>
  8039fc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a00:	0f 87 9e 00 00 00    	ja     803aa4 <__udivdi3+0x108>
  803a06:	b8 01 00 00 00       	mov    $0x1,%eax
  803a0b:	89 fa                	mov    %edi,%edx
  803a0d:	83 c4 1c             	add    $0x1c,%esp
  803a10:	5b                   	pop    %ebx
  803a11:	5e                   	pop    %esi
  803a12:	5f                   	pop    %edi
  803a13:	5d                   	pop    %ebp
  803a14:	c3                   	ret    
  803a15:	8d 76 00             	lea    0x0(%esi),%esi
  803a18:	31 ff                	xor    %edi,%edi
  803a1a:	31 c0                	xor    %eax,%eax
  803a1c:	89 fa                	mov    %edi,%edx
  803a1e:	83 c4 1c             	add    $0x1c,%esp
  803a21:	5b                   	pop    %ebx
  803a22:	5e                   	pop    %esi
  803a23:	5f                   	pop    %edi
  803a24:	5d                   	pop    %ebp
  803a25:	c3                   	ret    
  803a26:	66 90                	xchg   %ax,%ax
  803a28:	89 d8                	mov    %ebx,%eax
  803a2a:	f7 f7                	div    %edi
  803a2c:	31 ff                	xor    %edi,%edi
  803a2e:	89 fa                	mov    %edi,%edx
  803a30:	83 c4 1c             	add    $0x1c,%esp
  803a33:	5b                   	pop    %ebx
  803a34:	5e                   	pop    %esi
  803a35:	5f                   	pop    %edi
  803a36:	5d                   	pop    %ebp
  803a37:	c3                   	ret    
  803a38:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a3d:	89 eb                	mov    %ebp,%ebx
  803a3f:	29 fb                	sub    %edi,%ebx
  803a41:	89 f9                	mov    %edi,%ecx
  803a43:	d3 e6                	shl    %cl,%esi
  803a45:	89 c5                	mov    %eax,%ebp
  803a47:	88 d9                	mov    %bl,%cl
  803a49:	d3 ed                	shr    %cl,%ebp
  803a4b:	89 e9                	mov    %ebp,%ecx
  803a4d:	09 f1                	or     %esi,%ecx
  803a4f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a53:	89 f9                	mov    %edi,%ecx
  803a55:	d3 e0                	shl    %cl,%eax
  803a57:	89 c5                	mov    %eax,%ebp
  803a59:	89 d6                	mov    %edx,%esi
  803a5b:	88 d9                	mov    %bl,%cl
  803a5d:	d3 ee                	shr    %cl,%esi
  803a5f:	89 f9                	mov    %edi,%ecx
  803a61:	d3 e2                	shl    %cl,%edx
  803a63:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a67:	88 d9                	mov    %bl,%cl
  803a69:	d3 e8                	shr    %cl,%eax
  803a6b:	09 c2                	or     %eax,%edx
  803a6d:	89 d0                	mov    %edx,%eax
  803a6f:	89 f2                	mov    %esi,%edx
  803a71:	f7 74 24 0c          	divl   0xc(%esp)
  803a75:	89 d6                	mov    %edx,%esi
  803a77:	89 c3                	mov    %eax,%ebx
  803a79:	f7 e5                	mul    %ebp
  803a7b:	39 d6                	cmp    %edx,%esi
  803a7d:	72 19                	jb     803a98 <__udivdi3+0xfc>
  803a7f:	74 0b                	je     803a8c <__udivdi3+0xf0>
  803a81:	89 d8                	mov    %ebx,%eax
  803a83:	31 ff                	xor    %edi,%edi
  803a85:	e9 58 ff ff ff       	jmp    8039e2 <__udivdi3+0x46>
  803a8a:	66 90                	xchg   %ax,%ax
  803a8c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a90:	89 f9                	mov    %edi,%ecx
  803a92:	d3 e2                	shl    %cl,%edx
  803a94:	39 c2                	cmp    %eax,%edx
  803a96:	73 e9                	jae    803a81 <__udivdi3+0xe5>
  803a98:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a9b:	31 ff                	xor    %edi,%edi
  803a9d:	e9 40 ff ff ff       	jmp    8039e2 <__udivdi3+0x46>
  803aa2:	66 90                	xchg   %ax,%ax
  803aa4:	31 c0                	xor    %eax,%eax
  803aa6:	e9 37 ff ff ff       	jmp    8039e2 <__udivdi3+0x46>
  803aab:	90                   	nop

00803aac <__umoddi3>:
  803aac:	55                   	push   %ebp
  803aad:	57                   	push   %edi
  803aae:	56                   	push   %esi
  803aaf:	53                   	push   %ebx
  803ab0:	83 ec 1c             	sub    $0x1c,%esp
  803ab3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ab7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803abb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803abf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803ac3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ac7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803acb:	89 f3                	mov    %esi,%ebx
  803acd:	89 fa                	mov    %edi,%edx
  803acf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ad3:	89 34 24             	mov    %esi,(%esp)
  803ad6:	85 c0                	test   %eax,%eax
  803ad8:	75 1a                	jne    803af4 <__umoddi3+0x48>
  803ada:	39 f7                	cmp    %esi,%edi
  803adc:	0f 86 a2 00 00 00    	jbe    803b84 <__umoddi3+0xd8>
  803ae2:	89 c8                	mov    %ecx,%eax
  803ae4:	89 f2                	mov    %esi,%edx
  803ae6:	f7 f7                	div    %edi
  803ae8:	89 d0                	mov    %edx,%eax
  803aea:	31 d2                	xor    %edx,%edx
  803aec:	83 c4 1c             	add    $0x1c,%esp
  803aef:	5b                   	pop    %ebx
  803af0:	5e                   	pop    %esi
  803af1:	5f                   	pop    %edi
  803af2:	5d                   	pop    %ebp
  803af3:	c3                   	ret    
  803af4:	39 f0                	cmp    %esi,%eax
  803af6:	0f 87 ac 00 00 00    	ja     803ba8 <__umoddi3+0xfc>
  803afc:	0f bd e8             	bsr    %eax,%ebp
  803aff:	83 f5 1f             	xor    $0x1f,%ebp
  803b02:	0f 84 ac 00 00 00    	je     803bb4 <__umoddi3+0x108>
  803b08:	bf 20 00 00 00       	mov    $0x20,%edi
  803b0d:	29 ef                	sub    %ebp,%edi
  803b0f:	89 fe                	mov    %edi,%esi
  803b11:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b15:	89 e9                	mov    %ebp,%ecx
  803b17:	d3 e0                	shl    %cl,%eax
  803b19:	89 d7                	mov    %edx,%edi
  803b1b:	89 f1                	mov    %esi,%ecx
  803b1d:	d3 ef                	shr    %cl,%edi
  803b1f:	09 c7                	or     %eax,%edi
  803b21:	89 e9                	mov    %ebp,%ecx
  803b23:	d3 e2                	shl    %cl,%edx
  803b25:	89 14 24             	mov    %edx,(%esp)
  803b28:	89 d8                	mov    %ebx,%eax
  803b2a:	d3 e0                	shl    %cl,%eax
  803b2c:	89 c2                	mov    %eax,%edx
  803b2e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b32:	d3 e0                	shl    %cl,%eax
  803b34:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b38:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b3c:	89 f1                	mov    %esi,%ecx
  803b3e:	d3 e8                	shr    %cl,%eax
  803b40:	09 d0                	or     %edx,%eax
  803b42:	d3 eb                	shr    %cl,%ebx
  803b44:	89 da                	mov    %ebx,%edx
  803b46:	f7 f7                	div    %edi
  803b48:	89 d3                	mov    %edx,%ebx
  803b4a:	f7 24 24             	mull   (%esp)
  803b4d:	89 c6                	mov    %eax,%esi
  803b4f:	89 d1                	mov    %edx,%ecx
  803b51:	39 d3                	cmp    %edx,%ebx
  803b53:	0f 82 87 00 00 00    	jb     803be0 <__umoddi3+0x134>
  803b59:	0f 84 91 00 00 00    	je     803bf0 <__umoddi3+0x144>
  803b5f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b63:	29 f2                	sub    %esi,%edx
  803b65:	19 cb                	sbb    %ecx,%ebx
  803b67:	89 d8                	mov    %ebx,%eax
  803b69:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b6d:	d3 e0                	shl    %cl,%eax
  803b6f:	89 e9                	mov    %ebp,%ecx
  803b71:	d3 ea                	shr    %cl,%edx
  803b73:	09 d0                	or     %edx,%eax
  803b75:	89 e9                	mov    %ebp,%ecx
  803b77:	d3 eb                	shr    %cl,%ebx
  803b79:	89 da                	mov    %ebx,%edx
  803b7b:	83 c4 1c             	add    $0x1c,%esp
  803b7e:	5b                   	pop    %ebx
  803b7f:	5e                   	pop    %esi
  803b80:	5f                   	pop    %edi
  803b81:	5d                   	pop    %ebp
  803b82:	c3                   	ret    
  803b83:	90                   	nop
  803b84:	89 fd                	mov    %edi,%ebp
  803b86:	85 ff                	test   %edi,%edi
  803b88:	75 0b                	jne    803b95 <__umoddi3+0xe9>
  803b8a:	b8 01 00 00 00       	mov    $0x1,%eax
  803b8f:	31 d2                	xor    %edx,%edx
  803b91:	f7 f7                	div    %edi
  803b93:	89 c5                	mov    %eax,%ebp
  803b95:	89 f0                	mov    %esi,%eax
  803b97:	31 d2                	xor    %edx,%edx
  803b99:	f7 f5                	div    %ebp
  803b9b:	89 c8                	mov    %ecx,%eax
  803b9d:	f7 f5                	div    %ebp
  803b9f:	89 d0                	mov    %edx,%eax
  803ba1:	e9 44 ff ff ff       	jmp    803aea <__umoddi3+0x3e>
  803ba6:	66 90                	xchg   %ax,%ax
  803ba8:	89 c8                	mov    %ecx,%eax
  803baa:	89 f2                	mov    %esi,%edx
  803bac:	83 c4 1c             	add    $0x1c,%esp
  803baf:	5b                   	pop    %ebx
  803bb0:	5e                   	pop    %esi
  803bb1:	5f                   	pop    %edi
  803bb2:	5d                   	pop    %ebp
  803bb3:	c3                   	ret    
  803bb4:	3b 04 24             	cmp    (%esp),%eax
  803bb7:	72 06                	jb     803bbf <__umoddi3+0x113>
  803bb9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803bbd:	77 0f                	ja     803bce <__umoddi3+0x122>
  803bbf:	89 f2                	mov    %esi,%edx
  803bc1:	29 f9                	sub    %edi,%ecx
  803bc3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803bc7:	89 14 24             	mov    %edx,(%esp)
  803bca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bce:	8b 44 24 04          	mov    0x4(%esp),%eax
  803bd2:	8b 14 24             	mov    (%esp),%edx
  803bd5:	83 c4 1c             	add    $0x1c,%esp
  803bd8:	5b                   	pop    %ebx
  803bd9:	5e                   	pop    %esi
  803bda:	5f                   	pop    %edi
  803bdb:	5d                   	pop    %ebp
  803bdc:	c3                   	ret    
  803bdd:	8d 76 00             	lea    0x0(%esi),%esi
  803be0:	2b 04 24             	sub    (%esp),%eax
  803be3:	19 fa                	sbb    %edi,%edx
  803be5:	89 d1                	mov    %edx,%ecx
  803be7:	89 c6                	mov    %eax,%esi
  803be9:	e9 71 ff ff ff       	jmp    803b5f <__umoddi3+0xb3>
  803bee:	66 90                	xchg   %ax,%ax
  803bf0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803bf4:	72 ea                	jb     803be0 <__umoddi3+0x134>
  803bf6:	89 d9                	mov    %ebx,%ecx
  803bf8:	e9 62 ff ff ff       	jmp    803b5f <__umoddi3+0xb3>
