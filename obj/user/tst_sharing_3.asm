
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
  80005b:	68 80 3c 80 00       	push   $0x803c80
  800060:	6a 0c                	push   $0xc
  800062:	68 9c 3c 80 00       	push   $0x803c9c
  800067:	e8 4e 03 00 00       	call   8003ba <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	cprintf("************************************************\n");
  80006c:	83 ec 0c             	sub    $0xc,%esp
  80006f:	68 b4 3c 80 00       	push   $0x803cb4
  800074:	e8 fe 05 00 00       	call   800677 <cprintf>
  800079:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	68 e8 3c 80 00       	push   $0x803ce8
  800084:	e8 ee 05 00 00       	call   800677 <cprintf>
  800089:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 44 3d 80 00       	push   $0x803d44
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
  8000b4:	68 78 3d 80 00       	push   $0x803d78
  8000b9:	e8 b9 05 00 00       	call   800677 <cprintf>
  8000be:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 01                	push   $0x1
  8000c6:	68 00 10 00 00       	push   $0x1000
  8000cb:	68 c6 3d 80 00       	push   $0x803dc6
  8000d0:	e8 6f 16 00 00       	call   801744 <smalloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000db:	e8 96 19 00 00       	call   801a76 <sys_calculate_free_frames>
  8000e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000e3:	83 ec 04             	sub    $0x4,%esp
  8000e6:	6a 01                	push   $0x1
  8000e8:	68 00 10 00 00       	push   $0x1000
  8000ed:	68 c6 3d 80 00       	push   $0x803dc6
  8000f2:	e8 4d 16 00 00       	call   801744 <smalloc>
  8000f7:	83 c4 10             	add    $0x10,%esp
  8000fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) {is_correct = 0; cprintf("Trying to create an already exists object and corresponding error is not returned!!");}
  8000fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800101:	74 17                	je     80011a <_main+0xe2>
  800103:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	68 c8 3d 80 00       	push   $0x803dc8
  800112:	e8 60 05 00 00       	call   800677 <cprintf>
  800117:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");}
  80011a:	e8 57 19 00 00       	call   801a76 <sys_calculate_free_frames>
  80011f:	89 c2                	mov    %eax,%edx
  800121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800124:	39 c2                	cmp    %eax,%edx
  800126:	74 17                	je     80013f <_main+0x107>
  800128:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 1c 3e 80 00       	push   $0x803e1c
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
  800153:	68 78 3e 80 00       	push   $0x803e78
  800158:	e8 1a 05 00 00       	call   800677 <cprintf>
  80015d:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		x = sget(myEnv->env_id, "xx");
  800160:	a1 20 50 80 00       	mov    0x805020,%eax
  800165:	8b 40 10             	mov    0x10(%eax),%eax
  800168:	83 ec 08             	sub    $0x8,%esp
  80016b:	68 bd 3e 80 00       	push   $0x803ebd
  800170:	50                   	push   %eax
  800171:	e8 86 16 00 00       	call   8017fc <sget>
  800176:	83 c4 10             	add    $0x10,%esp
  800179:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  80017c:	e8 f5 18 00 00       	call   801a76 <sys_calculate_free_frames>
  800181:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != NULL) {is_correct = 0; cprintf("Trying to get a NON existing object and corresponding error is not returned!!");}
  800184:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800188:	74 17                	je     8001a1 <_main+0x169>
  80018a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800191:	83 ec 0c             	sub    $0xc,%esp
  800194:	68 c0 3e 80 00       	push   $0x803ec0
  800199:	e8 d9 04 00 00       	call   800677 <cprintf>
  80019e:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong get: make sure that you don't allocate any memory if the shared object not exists");}
  8001a1:	e8 d0 18 00 00       	call   801a76 <sys_calculate_free_frames>
  8001a6:	89 c2                	mov    %eax,%edx
  8001a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ab:	39 c2                	cmp    %eax,%edx
  8001ad:	74 17                	je     8001c6 <_main+0x18e>
  8001af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	68 10 3f 80 00       	push   $0x803f10
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
  8001da:	68 68 3f 80 00       	push   $0x803f68
  8001df:	e8 93 04 00 00       	call   800677 <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8001e7:	e8 8a 18 00 00       	call   801a76 <sys_calculate_free_frames>
  8001ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uint32 size = USER_HEAP_MAX - pagealloc_start - PAGE_SIZE + 1;
  8001ef:	b8 01 f0 ff 9f       	mov    $0x9ffff001,%eax
  8001f4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8001f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		y = smalloc("y", size, 1);
  8001fa:	83 ec 04             	sub    $0x4,%esp
  8001fd:	6a 01                	push   $0x1
  8001ff:	ff 75 d8             	pushl  -0x28(%ebp)
  800202:	68 c5 3f 80 00       	push   $0x803fc5
  800207:	e8 38 15 00 00       	call   801744 <smalloc>
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (y != NULL) {is_correct = 0; cprintf("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");}
  800212:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800216:	74 17                	je     80022f <_main+0x1f7>
  800218:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	68 c8 3f 80 00       	push   $0x803fc8
  800227:	e8 4b 04 00 00       	call   800677 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");}
  80022f:	e8 42 18 00 00       	call   801a76 <sys_calculate_free_frames>
  800234:	89 c2                	mov    %eax,%edx
  800236:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800239:	39 c2                	cmp    %eax,%edx
  80023b:	74 17                	je     800254 <_main+0x21c>
  80023d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 3c 40 80 00       	push   $0x80403c
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
  80026b:	68 b0 40 80 00       	push   $0x8040b0
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
  800281:	e8 b9 19 00 00       	call   801c3f <sys_getenvindex>
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
  8002ef:	e8 cf 16 00 00       	call   8019c3 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 1c 41 80 00       	push   $0x80411c
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
  80031f:	68 44 41 80 00       	push   $0x804144
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
  800350:	68 6c 41 80 00       	push   $0x80416c
  800355:	e8 1d 03 00 00       	call   800677 <cprintf>
  80035a:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80035d:	a1 20 50 80 00       	mov    0x805020,%eax
  800362:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800368:	83 ec 08             	sub    $0x8,%esp
  80036b:	50                   	push   %eax
  80036c:	68 c4 41 80 00       	push   $0x8041c4
  800371:	e8 01 03 00 00       	call   800677 <cprintf>
  800376:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800379:	83 ec 0c             	sub    $0xc,%esp
  80037c:	68 1c 41 80 00       	push   $0x80411c
  800381:	e8 f1 02 00 00       	call   800677 <cprintf>
  800386:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800389:	e8 4f 16 00 00       	call   8019dd <sys_unlock_cons>
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
  8003a1:	e8 65 18 00 00       	call   801c0b <sys_destroy_env>
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
  8003b2:	e8 ba 18 00 00       	call   801c71 <sys_exit_env>
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
  8003db:	68 d8 41 80 00       	push   $0x8041d8
  8003e0:	e8 92 02 00 00       	call   800677 <cprintf>
  8003e5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003e8:	a1 00 50 80 00       	mov    0x805000,%eax
  8003ed:	ff 75 0c             	pushl  0xc(%ebp)
  8003f0:	ff 75 08             	pushl  0x8(%ebp)
  8003f3:	50                   	push   %eax
  8003f4:	68 dd 41 80 00       	push   $0x8041dd
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
  800418:	68 f9 41 80 00       	push   $0x8041f9
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
  800447:	68 fc 41 80 00       	push   $0x8041fc
  80044c:	6a 26                	push   $0x26
  80044e:	68 48 42 80 00       	push   $0x804248
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
  80051c:	68 54 42 80 00       	push   $0x804254
  800521:	6a 3a                	push   $0x3a
  800523:	68 48 42 80 00       	push   $0x804248
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
  80058f:	68 a8 42 80 00       	push   $0x8042a8
  800594:	6a 44                	push   $0x44
  800596:	68 48 42 80 00       	push   $0x804248
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
  8005e9:	e8 93 13 00 00       	call   801981 <sys_cputs>
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
  800660:	e8 1c 13 00 00       	call   801981 <sys_cputs>
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
  8006aa:	e8 14 13 00 00       	call   8019c3 <sys_lock_cons>
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
  8006ca:	e8 0e 13 00 00       	call   8019dd <sys_unlock_cons>
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
  800714:	e8 ff 32 00 00       	call   803a18 <__udivdi3>
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
  800764:	e8 bf 33 00 00       	call   803b28 <__umoddi3>
  800769:	83 c4 10             	add    $0x10,%esp
  80076c:	05 14 45 80 00       	add    $0x804514,%eax
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
  8008bf:	8b 04 85 38 45 80 00 	mov    0x804538(,%eax,4),%eax
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
  8009a0:	8b 34 9d 80 43 80 00 	mov    0x804380(,%ebx,4),%esi
  8009a7:	85 f6                	test   %esi,%esi
  8009a9:	75 19                	jne    8009c4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009ab:	53                   	push   %ebx
  8009ac:	68 25 45 80 00       	push   $0x804525
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
  8009c5:	68 2e 45 80 00       	push   $0x80452e
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
  8009f2:	be 31 45 80 00       	mov    $0x804531,%esi
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
  8013fd:	68 a8 46 80 00       	push   $0x8046a8
  801402:	68 3f 01 00 00       	push   $0x13f
  801407:	68 ca 46 80 00       	push   $0x8046ca
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
  80141d:	e8 0a 0b 00 00       	call   801f2c <sys_sbrk>
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
  801498:	e8 13 09 00 00       	call   801db0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80149d:	85 c0                	test   %eax,%eax
  80149f:	74 16                	je     8014b7 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8014a1:	83 ec 0c             	sub    $0xc,%esp
  8014a4:	ff 75 08             	pushl  0x8(%ebp)
  8014a7:	e8 53 0e 00 00       	call   8022ff <alloc_block_FF>
  8014ac:	83 c4 10             	add    $0x10,%esp
  8014af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014b2:	e9 8a 01 00 00       	jmp    801641 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014b7:	e8 25 09 00 00       	call   801de1 <sys_isUHeapPlacementStrategyBESTFIT>
  8014bc:	85 c0                	test   %eax,%eax
  8014be:	0f 84 7d 01 00 00    	je     801641 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014c4:	83 ec 0c             	sub    $0xc,%esp
  8014c7:	ff 75 08             	pushl  0x8(%ebp)
  8014ca:	e8 ec 12 00 00       	call   8027bb <alloc_block_BF>
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
  801630:	e8 2e 09 00 00       	call   801f63 <sys_allocate_user_mem>
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
  801678:	e8 02 09 00 00       	call   801f7f <get_block_size>
  80167d:	83 c4 10             	add    $0x10,%esp
  801680:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801683:	83 ec 0c             	sub    $0xc,%esp
  801686:	ff 75 08             	pushl  0x8(%ebp)
  801689:	e8 35 1b 00 00       	call   8031c3 <free_block>
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
  801720:	e8 22 08 00 00       	call   801f47 <sys_free_user_mem>
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
  80172e:	68 d8 46 80 00       	push   $0x8046d8
  801733:	68 85 00 00 00       	push   $0x85
  801738:	68 02 47 80 00       	push   $0x804702
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
  8017a3:	e8 a6 03 00 00       	call   801b4e <sys_createSharedObject>
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
  8017c7:	68 0e 47 80 00       	push   $0x80470e
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
  80180b:	e8 68 03 00 00       	call   801b78 <sys_getSizeOfSharedObject>
  801810:	83 c4 10             	add    $0x10,%esp
  801813:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801816:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80181a:	75 07                	jne    801823 <sget+0x27>
  80181c:	b8 00 00 00 00       	mov    $0x0,%eax
  801821:	eb 7f                	jmp    8018a2 <sget+0xa6>
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
  801856:	eb 4a                	jmp    8018a2 <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801858:	83 ec 04             	sub    $0x4,%esp
  80185b:	ff 75 e8             	pushl  -0x18(%ebp)
  80185e:	ff 75 0c             	pushl  0xc(%ebp)
  801861:	ff 75 08             	pushl  0x8(%ebp)
  801864:	e8 2c 03 00 00       	call   801b95 <sys_getSharedObject>
  801869:	83 c4 10             	add    $0x10,%esp
  80186c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  80186f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801872:	a1 20 50 80 00       	mov    0x805020,%eax
  801877:	8b 40 78             	mov    0x78(%eax),%eax
  80187a:	29 c2                	sub    %eax,%edx
  80187c:	89 d0                	mov    %edx,%eax
  80187e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801883:	c1 e8 0c             	shr    $0xc,%eax
  801886:	89 c2                	mov    %eax,%edx
  801888:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80188b:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801892:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801896:	75 07                	jne    80189f <sget+0xa3>
  801898:	b8 00 00 00 00       	mov    $0x0,%eax
  80189d:	eb 03                	jmp    8018a2 <sget+0xa6>
	return ptr;
  80189f:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  8018aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ad:	a1 20 50 80 00       	mov    0x805020,%eax
  8018b2:	8b 40 78             	mov    0x78(%eax),%eax
  8018b5:	29 c2                	sub    %eax,%edx
  8018b7:	89 d0                	mov    %edx,%eax
  8018b9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018be:	c1 e8 0c             	shr    $0xc,%eax
  8018c1:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8018c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8018cb:	83 ec 08             	sub    $0x8,%esp
  8018ce:	ff 75 08             	pushl  0x8(%ebp)
  8018d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8018d4:	e8 db 02 00 00       	call   801bb4 <sys_freeSharedObject>
  8018d9:	83 c4 10             	add    $0x10,%esp
  8018dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8018df:	90                   	nop
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018e8:	83 ec 04             	sub    $0x4,%esp
  8018eb:	68 20 47 80 00       	push   $0x804720
  8018f0:	68 de 00 00 00       	push   $0xde
  8018f5:	68 02 47 80 00       	push   $0x804702
  8018fa:	e8 bb ea ff ff       	call   8003ba <_panic>

008018ff <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801905:	83 ec 04             	sub    $0x4,%esp
  801908:	68 46 47 80 00       	push   $0x804746
  80190d:	68 ea 00 00 00       	push   $0xea
  801912:	68 02 47 80 00       	push   $0x804702
  801917:	e8 9e ea ff ff       	call   8003ba <_panic>

0080191c <shrink>:

}
void shrink(uint32 newSize)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801922:	83 ec 04             	sub    $0x4,%esp
  801925:	68 46 47 80 00       	push   $0x804746
  80192a:	68 ef 00 00 00       	push   $0xef
  80192f:	68 02 47 80 00       	push   $0x804702
  801934:	e8 81 ea ff ff       	call   8003ba <_panic>

00801939 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80193f:	83 ec 04             	sub    $0x4,%esp
  801942:	68 46 47 80 00       	push   $0x804746
  801947:	68 f4 00 00 00       	push   $0xf4
  80194c:	68 02 47 80 00       	push   $0x804702
  801951:	e8 64 ea ff ff       	call   8003ba <_panic>

00801956 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
  801959:	57                   	push   %edi
  80195a:	56                   	push   %esi
  80195b:	53                   	push   %ebx
  80195c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80195f:	8b 45 08             	mov    0x8(%ebp),%eax
  801962:	8b 55 0c             	mov    0xc(%ebp),%edx
  801965:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801968:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80196b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80196e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801971:	cd 30                	int    $0x30
  801973:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801976:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801979:	83 c4 10             	add    $0x10,%esp
  80197c:	5b                   	pop    %ebx
  80197d:	5e                   	pop    %esi
  80197e:	5f                   	pop    %edi
  80197f:	5d                   	pop    %ebp
  801980:	c3                   	ret    

00801981 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
  801984:	83 ec 04             	sub    $0x4,%esp
  801987:	8b 45 10             	mov    0x10(%ebp),%eax
  80198a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80198d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	52                   	push   %edx
  801999:	ff 75 0c             	pushl  0xc(%ebp)
  80199c:	50                   	push   %eax
  80199d:	6a 00                	push   $0x0
  80199f:	e8 b2 ff ff ff       	call   801956 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	90                   	nop
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <sys_cgetc>:

int
sys_cgetc(void)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 02                	push   $0x2
  8019b9:	e8 98 ff ff ff       	call   801956 <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 03                	push   $0x3
  8019d2:	e8 7f ff ff ff       	call   801956 <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
}
  8019da:	90                   	nop
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 04                	push   $0x4
  8019ec:	e8 65 ff ff ff       	call   801956 <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
}
  8019f4:	90                   	nop
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	52                   	push   %edx
  801a07:	50                   	push   %eax
  801a08:	6a 08                	push   $0x8
  801a0a:	e8 47 ff ff ff       	call   801956 <syscall>
  801a0f:	83 c4 18             	add    $0x18,%esp
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	56                   	push   %esi
  801a18:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a19:	8b 75 18             	mov    0x18(%ebp),%esi
  801a1c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a1f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a25:	8b 45 08             	mov    0x8(%ebp),%eax
  801a28:	56                   	push   %esi
  801a29:	53                   	push   %ebx
  801a2a:	51                   	push   %ecx
  801a2b:	52                   	push   %edx
  801a2c:	50                   	push   %eax
  801a2d:	6a 09                	push   $0x9
  801a2f:	e8 22 ff ff ff       	call   801956 <syscall>
  801a34:	83 c4 18             	add    $0x18,%esp
}
  801a37:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a3a:	5b                   	pop    %ebx
  801a3b:	5e                   	pop    %esi
  801a3c:	5d                   	pop    %ebp
  801a3d:	c3                   	ret    

00801a3e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	52                   	push   %edx
  801a4e:	50                   	push   %eax
  801a4f:	6a 0a                	push   $0xa
  801a51:	e8 00 ff ff ff       	call   801956 <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	ff 75 0c             	pushl  0xc(%ebp)
  801a67:	ff 75 08             	pushl  0x8(%ebp)
  801a6a:	6a 0b                	push   $0xb
  801a6c:	e8 e5 fe ff ff       	call   801956 <syscall>
  801a71:	83 c4 18             	add    $0x18,%esp
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 0c                	push   $0xc
  801a85:	e8 cc fe ff ff       	call   801956 <syscall>
  801a8a:	83 c4 18             	add    $0x18,%esp
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 0d                	push   $0xd
  801a9e:	e8 b3 fe ff ff       	call   801956 <syscall>
  801aa3:	83 c4 18             	add    $0x18,%esp
}
  801aa6:	c9                   	leave  
  801aa7:	c3                   	ret    

00801aa8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 0e                	push   $0xe
  801ab7:	e8 9a fe ff ff       	call   801956 <syscall>
  801abc:	83 c4 18             	add    $0x18,%esp
}
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    

00801ac1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 0f                	push   $0xf
  801ad0:	e8 81 fe ff ff       	call   801956 <syscall>
  801ad5:	83 c4 18             	add    $0x18,%esp
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	ff 75 08             	pushl  0x8(%ebp)
  801ae8:	6a 10                	push   $0x10
  801aea:	e8 67 fe ff ff       	call   801956 <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 11                	push   $0x11
  801b03:	e8 4e fe ff ff       	call   801956 <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	90                   	nop
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <sys_cputc>:

void
sys_cputc(const char c)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
  801b11:	83 ec 04             	sub    $0x4,%esp
  801b14:	8b 45 08             	mov    0x8(%ebp),%eax
  801b17:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b1a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	50                   	push   %eax
  801b27:	6a 01                	push   $0x1
  801b29:	e8 28 fe ff ff       	call   801956 <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
}
  801b31:	90                   	nop
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 14                	push   $0x14
  801b43:	e8 0e fe ff ff       	call   801956 <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
}
  801b4b:	90                   	nop
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 04             	sub    $0x4,%esp
  801b54:	8b 45 10             	mov    0x10(%ebp),%eax
  801b57:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b5a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b5d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b61:	8b 45 08             	mov    0x8(%ebp),%eax
  801b64:	6a 00                	push   $0x0
  801b66:	51                   	push   %ecx
  801b67:	52                   	push   %edx
  801b68:	ff 75 0c             	pushl  0xc(%ebp)
  801b6b:	50                   	push   %eax
  801b6c:	6a 15                	push   $0x15
  801b6e:	e8 e3 fd ff ff       	call   801956 <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	52                   	push   %edx
  801b88:	50                   	push   %eax
  801b89:	6a 16                	push   $0x16
  801b8b:	e8 c6 fd ff ff       	call   801956 <syscall>
  801b90:	83 c4 18             	add    $0x18,%esp
}
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b98:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	51                   	push   %ecx
  801ba6:	52                   	push   %edx
  801ba7:	50                   	push   %eax
  801ba8:	6a 17                	push   $0x17
  801baa:	e8 a7 fd ff ff       	call   801956 <syscall>
  801baf:	83 c4 18             	add    $0x18,%esp
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bba:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	52                   	push   %edx
  801bc4:	50                   	push   %eax
  801bc5:	6a 18                	push   $0x18
  801bc7:	e8 8a fd ff ff       	call   801956 <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd7:	6a 00                	push   $0x0
  801bd9:	ff 75 14             	pushl  0x14(%ebp)
  801bdc:	ff 75 10             	pushl  0x10(%ebp)
  801bdf:	ff 75 0c             	pushl  0xc(%ebp)
  801be2:	50                   	push   %eax
  801be3:	6a 19                	push   $0x19
  801be5:	e8 6c fd ff ff       	call   801956 <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <sys_run_env>:

void sys_run_env(int32 envId)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	50                   	push   %eax
  801bfe:	6a 1a                	push   $0x1a
  801c00:	e8 51 fd ff ff       	call   801956 <syscall>
  801c05:	83 c4 18             	add    $0x18,%esp
}
  801c08:	90                   	nop
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	50                   	push   %eax
  801c1a:	6a 1b                	push   $0x1b
  801c1c:	e8 35 fd ff ff       	call   801956 <syscall>
  801c21:	83 c4 18             	add    $0x18,%esp
}
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 05                	push   $0x5
  801c35:	e8 1c fd ff ff       	call   801956 <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 06                	push   $0x6
  801c4e:	e8 03 fd ff ff       	call   801956 <syscall>
  801c53:	83 c4 18             	add    $0x18,%esp
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 07                	push   $0x7
  801c67:	e8 ea fc ff ff       	call   801956 <syscall>
  801c6c:	83 c4 18             	add    $0x18,%esp
}
  801c6f:	c9                   	leave  
  801c70:	c3                   	ret    

00801c71 <sys_exit_env>:


void sys_exit_env(void)
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 1c                	push   $0x1c
  801c80:	e8 d1 fc ff ff       	call   801956 <syscall>
  801c85:	83 c4 18             	add    $0x18,%esp
}
  801c88:	90                   	nop
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c91:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c94:	8d 50 04             	lea    0x4(%eax),%edx
  801c97:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	52                   	push   %edx
  801ca1:	50                   	push   %eax
  801ca2:	6a 1d                	push   $0x1d
  801ca4:	e8 ad fc ff ff       	call   801956 <syscall>
  801ca9:	83 c4 18             	add    $0x18,%esp
	return result;
  801cac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801caf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cb2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cb5:	89 01                	mov    %eax,(%ecx)
  801cb7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cba:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbd:	c9                   	leave  
  801cbe:	c2 04 00             	ret    $0x4

00801cc1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	ff 75 10             	pushl  0x10(%ebp)
  801ccb:	ff 75 0c             	pushl  0xc(%ebp)
  801cce:	ff 75 08             	pushl  0x8(%ebp)
  801cd1:	6a 13                	push   $0x13
  801cd3:	e8 7e fc ff ff       	call   801956 <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdb:	90                   	nop
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <sys_rcr2>:
uint32 sys_rcr2()
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 1e                	push   $0x1e
  801ced:	e8 64 fc ff ff       	call   801956 <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	83 ec 04             	sub    $0x4,%esp
  801cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801d00:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d03:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	50                   	push   %eax
  801d10:	6a 1f                	push   $0x1f
  801d12:	e8 3f fc ff ff       	call   801956 <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1a:	90                   	nop
}
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <rsttst>:
void rsttst()
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 21                	push   $0x21
  801d2c:	e8 25 fc ff ff       	call   801956 <syscall>
  801d31:	83 c4 18             	add    $0x18,%esp
	return ;
  801d34:	90                   	nop
}
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
  801d3a:	83 ec 04             	sub    $0x4,%esp
  801d3d:	8b 45 14             	mov    0x14(%ebp),%eax
  801d40:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d43:	8b 55 18             	mov    0x18(%ebp),%edx
  801d46:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d4a:	52                   	push   %edx
  801d4b:	50                   	push   %eax
  801d4c:	ff 75 10             	pushl  0x10(%ebp)
  801d4f:	ff 75 0c             	pushl  0xc(%ebp)
  801d52:	ff 75 08             	pushl  0x8(%ebp)
  801d55:	6a 20                	push   $0x20
  801d57:	e8 fa fb ff ff       	call   801956 <syscall>
  801d5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5f:	90                   	nop
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <chktst>:
void chktst(uint32 n)
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	ff 75 08             	pushl  0x8(%ebp)
  801d70:	6a 22                	push   $0x22
  801d72:	e8 df fb ff ff       	call   801956 <syscall>
  801d77:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7a:	90                   	nop
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <inctst>:

void inctst()
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 23                	push   $0x23
  801d8c:	e8 c5 fb ff ff       	call   801956 <syscall>
  801d91:	83 c4 18             	add    $0x18,%esp
	return ;
  801d94:	90                   	nop
}
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <gettst>:
uint32 gettst()
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 24                	push   $0x24
  801da6:	e8 ab fb ff ff       	call   801956 <syscall>
  801dab:	83 c4 18             	add    $0x18,%esp
}
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
  801db3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 25                	push   $0x25
  801dc2:	e8 8f fb ff ff       	call   801956 <syscall>
  801dc7:	83 c4 18             	add    $0x18,%esp
  801dca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dcd:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dd1:	75 07                	jne    801dda <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dd3:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd8:	eb 05                	jmp    801ddf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
  801de4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 25                	push   $0x25
  801df3:	e8 5e fb ff ff       	call   801956 <syscall>
  801df8:	83 c4 18             	add    $0x18,%esp
  801dfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dfe:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e02:	75 07                	jne    801e0b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e04:	b8 01 00 00 00       	mov    $0x1,%eax
  801e09:	eb 05                	jmp    801e10 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e10:	c9                   	leave  
  801e11:	c3                   	ret    

00801e12 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 25                	push   $0x25
  801e24:	e8 2d fb ff ff       	call   801956 <syscall>
  801e29:	83 c4 18             	add    $0x18,%esp
  801e2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e2f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e33:	75 07                	jne    801e3c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e35:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3a:	eb 05                	jmp    801e41 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e41:	c9                   	leave  
  801e42:	c3                   	ret    

00801e43 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
  801e46:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 25                	push   $0x25
  801e55:	e8 fc fa ff ff       	call   801956 <syscall>
  801e5a:	83 c4 18             	add    $0x18,%esp
  801e5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e60:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e64:	75 07                	jne    801e6d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e66:	b8 01 00 00 00       	mov    $0x1,%eax
  801e6b:	eb 05                	jmp    801e72 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	ff 75 08             	pushl  0x8(%ebp)
  801e82:	6a 26                	push   $0x26
  801e84:	e8 cd fa ff ff       	call   801956 <syscall>
  801e89:	83 c4 18             	add    $0x18,%esp
	return ;
  801e8c:	90                   	nop
}
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
  801e92:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e93:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e96:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9f:	6a 00                	push   $0x0
  801ea1:	53                   	push   %ebx
  801ea2:	51                   	push   %ecx
  801ea3:	52                   	push   %edx
  801ea4:	50                   	push   %eax
  801ea5:	6a 27                	push   $0x27
  801ea7:	e8 aa fa ff ff       	call   801956 <syscall>
  801eac:	83 c4 18             	add    $0x18,%esp
}
  801eaf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801eb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eba:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	52                   	push   %edx
  801ec4:	50                   	push   %eax
  801ec5:	6a 28                	push   $0x28
  801ec7:	e8 8a fa ff ff       	call   801956 <syscall>
  801ecc:	83 c4 18             	add    $0x18,%esp
}
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ed4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ed7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eda:	8b 45 08             	mov    0x8(%ebp),%eax
  801edd:	6a 00                	push   $0x0
  801edf:	51                   	push   %ecx
  801ee0:	ff 75 10             	pushl  0x10(%ebp)
  801ee3:	52                   	push   %edx
  801ee4:	50                   	push   %eax
  801ee5:	6a 29                	push   $0x29
  801ee7:	e8 6a fa ff ff       	call   801956 <syscall>
  801eec:	83 c4 18             	add    $0x18,%esp
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	ff 75 10             	pushl  0x10(%ebp)
  801efb:	ff 75 0c             	pushl  0xc(%ebp)
  801efe:	ff 75 08             	pushl  0x8(%ebp)
  801f01:	6a 12                	push   $0x12
  801f03:	e8 4e fa ff ff       	call   801956 <syscall>
  801f08:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0b:	90                   	nop
}
  801f0c:	c9                   	leave  
  801f0d:	c3                   	ret    

00801f0e <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f14:	8b 45 08             	mov    0x8(%ebp),%eax
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	52                   	push   %edx
  801f1e:	50                   	push   %eax
  801f1f:	6a 2a                	push   $0x2a
  801f21:	e8 30 fa ff ff       	call   801956 <syscall>
  801f26:	83 c4 18             	add    $0x18,%esp
	return;
  801f29:	90                   	nop
}
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

00801f2c <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	50                   	push   %eax
  801f3b:	6a 2b                	push   $0x2b
  801f3d:	e8 14 fa ff ff       	call   801956 <syscall>
  801f42:	83 c4 18             	add    $0x18,%esp
}
  801f45:	c9                   	leave  
  801f46:	c3                   	ret    

00801f47 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	ff 75 0c             	pushl  0xc(%ebp)
  801f53:	ff 75 08             	pushl  0x8(%ebp)
  801f56:	6a 2c                	push   $0x2c
  801f58:	e8 f9 f9 ff ff       	call   801956 <syscall>
  801f5d:	83 c4 18             	add    $0x18,%esp
	return;
  801f60:	90                   	nop
}
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	ff 75 0c             	pushl  0xc(%ebp)
  801f6f:	ff 75 08             	pushl  0x8(%ebp)
  801f72:	6a 2d                	push   $0x2d
  801f74:	e8 dd f9 ff ff       	call   801956 <syscall>
  801f79:	83 c4 18             	add    $0x18,%esp
	return;
  801f7c:	90                   	nop
}
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    

00801f7f <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
  801f82:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f85:	8b 45 08             	mov    0x8(%ebp),%eax
  801f88:	83 e8 04             	sub    $0x4,%eax
  801f8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f91:	8b 00                	mov    (%eax),%eax
  801f93:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    

00801f98 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
  801f9b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa1:	83 e8 04             	sub    $0x4,%eax
  801fa4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801fa7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801faa:	8b 00                	mov    (%eax),%eax
  801fac:	83 e0 01             	and    $0x1,%eax
  801faf:	85 c0                	test   %eax,%eax
  801fb1:	0f 94 c0             	sete   %al
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801fbc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc6:	83 f8 02             	cmp    $0x2,%eax
  801fc9:	74 2b                	je     801ff6 <alloc_block+0x40>
  801fcb:	83 f8 02             	cmp    $0x2,%eax
  801fce:	7f 07                	jg     801fd7 <alloc_block+0x21>
  801fd0:	83 f8 01             	cmp    $0x1,%eax
  801fd3:	74 0e                	je     801fe3 <alloc_block+0x2d>
  801fd5:	eb 58                	jmp    80202f <alloc_block+0x79>
  801fd7:	83 f8 03             	cmp    $0x3,%eax
  801fda:	74 2d                	je     802009 <alloc_block+0x53>
  801fdc:	83 f8 04             	cmp    $0x4,%eax
  801fdf:	74 3b                	je     80201c <alloc_block+0x66>
  801fe1:	eb 4c                	jmp    80202f <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801fe3:	83 ec 0c             	sub    $0xc,%esp
  801fe6:	ff 75 08             	pushl  0x8(%ebp)
  801fe9:	e8 11 03 00 00       	call   8022ff <alloc_block_FF>
  801fee:	83 c4 10             	add    $0x10,%esp
  801ff1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ff4:	eb 4a                	jmp    802040 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801ff6:	83 ec 0c             	sub    $0xc,%esp
  801ff9:	ff 75 08             	pushl  0x8(%ebp)
  801ffc:	e8 fa 19 00 00       	call   8039fb <alloc_block_NF>
  802001:	83 c4 10             	add    $0x10,%esp
  802004:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802007:	eb 37                	jmp    802040 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802009:	83 ec 0c             	sub    $0xc,%esp
  80200c:	ff 75 08             	pushl  0x8(%ebp)
  80200f:	e8 a7 07 00 00       	call   8027bb <alloc_block_BF>
  802014:	83 c4 10             	add    $0x10,%esp
  802017:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80201a:	eb 24                	jmp    802040 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80201c:	83 ec 0c             	sub    $0xc,%esp
  80201f:	ff 75 08             	pushl  0x8(%ebp)
  802022:	e8 b7 19 00 00       	call   8039de <alloc_block_WF>
  802027:	83 c4 10             	add    $0x10,%esp
  80202a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80202d:	eb 11                	jmp    802040 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80202f:	83 ec 0c             	sub    $0xc,%esp
  802032:	68 58 47 80 00       	push   $0x804758
  802037:	e8 3b e6 ff ff       	call   800677 <cprintf>
  80203c:	83 c4 10             	add    $0x10,%esp
		break;
  80203f:	90                   	nop
	}
	return va;
  802040:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	53                   	push   %ebx
  802049:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80204c:	83 ec 0c             	sub    $0xc,%esp
  80204f:	68 78 47 80 00       	push   $0x804778
  802054:	e8 1e e6 ff ff       	call   800677 <cprintf>
  802059:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80205c:	83 ec 0c             	sub    $0xc,%esp
  80205f:	68 a3 47 80 00       	push   $0x8047a3
  802064:	e8 0e e6 ff ff       	call   800677 <cprintf>
  802069:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80206c:	8b 45 08             	mov    0x8(%ebp),%eax
  80206f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802072:	eb 37                	jmp    8020ab <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802074:	83 ec 0c             	sub    $0xc,%esp
  802077:	ff 75 f4             	pushl  -0xc(%ebp)
  80207a:	e8 19 ff ff ff       	call   801f98 <is_free_block>
  80207f:	83 c4 10             	add    $0x10,%esp
  802082:	0f be d8             	movsbl %al,%ebx
  802085:	83 ec 0c             	sub    $0xc,%esp
  802088:	ff 75 f4             	pushl  -0xc(%ebp)
  80208b:	e8 ef fe ff ff       	call   801f7f <get_block_size>
  802090:	83 c4 10             	add    $0x10,%esp
  802093:	83 ec 04             	sub    $0x4,%esp
  802096:	53                   	push   %ebx
  802097:	50                   	push   %eax
  802098:	68 bb 47 80 00       	push   $0x8047bb
  80209d:	e8 d5 e5 ff ff       	call   800677 <cprintf>
  8020a2:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8020a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8020a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020af:	74 07                	je     8020b8 <print_blocks_list+0x73>
  8020b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b4:	8b 00                	mov    (%eax),%eax
  8020b6:	eb 05                	jmp    8020bd <print_blocks_list+0x78>
  8020b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bd:	89 45 10             	mov    %eax,0x10(%ebp)
  8020c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8020c3:	85 c0                	test   %eax,%eax
  8020c5:	75 ad                	jne    802074 <print_blocks_list+0x2f>
  8020c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020cb:	75 a7                	jne    802074 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8020cd:	83 ec 0c             	sub    $0xc,%esp
  8020d0:	68 78 47 80 00       	push   $0x804778
  8020d5:	e8 9d e5 ff ff       	call   800677 <cprintf>
  8020da:	83 c4 10             	add    $0x10,%esp

}
  8020dd:	90                   	nop
  8020de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020e1:	c9                   	leave  
  8020e2:	c3                   	ret    

008020e3 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8020e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ec:	83 e0 01             	and    $0x1,%eax
  8020ef:	85 c0                	test   %eax,%eax
  8020f1:	74 03                	je     8020f6 <initialize_dynamic_allocator+0x13>
  8020f3:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8020f6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020fa:	0f 84 c7 01 00 00    	je     8022c7 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802100:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802107:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80210a:	8b 55 08             	mov    0x8(%ebp),%edx
  80210d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802110:	01 d0                	add    %edx,%eax
  802112:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802117:	0f 87 ad 01 00 00    	ja     8022ca <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
  802120:	85 c0                	test   %eax,%eax
  802122:	0f 89 a5 01 00 00    	jns    8022cd <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802128:	8b 55 08             	mov    0x8(%ebp),%edx
  80212b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80212e:	01 d0                	add    %edx,%eax
  802130:	83 e8 04             	sub    $0x4,%eax
  802133:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802138:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80213f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802144:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802147:	e9 87 00 00 00       	jmp    8021d3 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80214c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802150:	75 14                	jne    802166 <initialize_dynamic_allocator+0x83>
  802152:	83 ec 04             	sub    $0x4,%esp
  802155:	68 d3 47 80 00       	push   $0x8047d3
  80215a:	6a 79                	push   $0x79
  80215c:	68 f1 47 80 00       	push   $0x8047f1
  802161:	e8 54 e2 ff ff       	call   8003ba <_panic>
  802166:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802169:	8b 00                	mov    (%eax),%eax
  80216b:	85 c0                	test   %eax,%eax
  80216d:	74 10                	je     80217f <initialize_dynamic_allocator+0x9c>
  80216f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802172:	8b 00                	mov    (%eax),%eax
  802174:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802177:	8b 52 04             	mov    0x4(%edx),%edx
  80217a:	89 50 04             	mov    %edx,0x4(%eax)
  80217d:	eb 0b                	jmp    80218a <initialize_dynamic_allocator+0xa7>
  80217f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802182:	8b 40 04             	mov    0x4(%eax),%eax
  802185:	a3 30 50 80 00       	mov    %eax,0x805030
  80218a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218d:	8b 40 04             	mov    0x4(%eax),%eax
  802190:	85 c0                	test   %eax,%eax
  802192:	74 0f                	je     8021a3 <initialize_dynamic_allocator+0xc0>
  802194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802197:	8b 40 04             	mov    0x4(%eax),%eax
  80219a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80219d:	8b 12                	mov    (%edx),%edx
  80219f:	89 10                	mov    %edx,(%eax)
  8021a1:	eb 0a                	jmp    8021ad <initialize_dynamic_allocator+0xca>
  8021a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a6:	8b 00                	mov    (%eax),%eax
  8021a8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021c0:	a1 38 50 80 00       	mov    0x805038,%eax
  8021c5:	48                   	dec    %eax
  8021c6:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8021cb:	a1 34 50 80 00       	mov    0x805034,%eax
  8021d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021d7:	74 07                	je     8021e0 <initialize_dynamic_allocator+0xfd>
  8021d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dc:	8b 00                	mov    (%eax),%eax
  8021de:	eb 05                	jmp    8021e5 <initialize_dynamic_allocator+0x102>
  8021e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e5:	a3 34 50 80 00       	mov    %eax,0x805034
  8021ea:	a1 34 50 80 00       	mov    0x805034,%eax
  8021ef:	85 c0                	test   %eax,%eax
  8021f1:	0f 85 55 ff ff ff    	jne    80214c <initialize_dynamic_allocator+0x69>
  8021f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021fb:	0f 85 4b ff ff ff    	jne    80214c <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802207:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802210:	a1 44 50 80 00       	mov    0x805044,%eax
  802215:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80221a:	a1 40 50 80 00       	mov    0x805040,%eax
  80221f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	83 c0 08             	add    $0x8,%eax
  80222b:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80222e:	8b 45 08             	mov    0x8(%ebp),%eax
  802231:	83 c0 04             	add    $0x4,%eax
  802234:	8b 55 0c             	mov    0xc(%ebp),%edx
  802237:	83 ea 08             	sub    $0x8,%edx
  80223a:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80223c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80223f:	8b 45 08             	mov    0x8(%ebp),%eax
  802242:	01 d0                	add    %edx,%eax
  802244:	83 e8 08             	sub    $0x8,%eax
  802247:	8b 55 0c             	mov    0xc(%ebp),%edx
  80224a:	83 ea 08             	sub    $0x8,%edx
  80224d:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80224f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802252:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802258:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80225b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802262:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802266:	75 17                	jne    80227f <initialize_dynamic_allocator+0x19c>
  802268:	83 ec 04             	sub    $0x4,%esp
  80226b:	68 0c 48 80 00       	push   $0x80480c
  802270:	68 90 00 00 00       	push   $0x90
  802275:	68 f1 47 80 00       	push   $0x8047f1
  80227a:	e8 3b e1 ff ff       	call   8003ba <_panic>
  80227f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802285:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802288:	89 10                	mov    %edx,(%eax)
  80228a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80228d:	8b 00                	mov    (%eax),%eax
  80228f:	85 c0                	test   %eax,%eax
  802291:	74 0d                	je     8022a0 <initialize_dynamic_allocator+0x1bd>
  802293:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802298:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80229b:	89 50 04             	mov    %edx,0x4(%eax)
  80229e:	eb 08                	jmp    8022a8 <initialize_dynamic_allocator+0x1c5>
  8022a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a3:	a3 30 50 80 00       	mov    %eax,0x805030
  8022a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ab:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ba:	a1 38 50 80 00       	mov    0x805038,%eax
  8022bf:	40                   	inc    %eax
  8022c0:	a3 38 50 80 00       	mov    %eax,0x805038
  8022c5:	eb 07                	jmp    8022ce <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8022c7:	90                   	nop
  8022c8:	eb 04                	jmp    8022ce <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8022ca:	90                   	nop
  8022cb:	eb 01                	jmp    8022ce <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8022cd:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8022d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d6:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dc:	8d 50 fc             	lea    -0x4(%eax),%edx
  8022df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e2:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8022e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e7:	83 e8 04             	sub    $0x4,%eax
  8022ea:	8b 00                	mov    (%eax),%eax
  8022ec:	83 e0 fe             	and    $0xfffffffe,%eax
  8022ef:	8d 50 f8             	lea    -0x8(%eax),%edx
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	01 c2                	add    %eax,%edx
  8022f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022fa:	89 02                	mov    %eax,(%edx)
}
  8022fc:	90                   	nop
  8022fd:	5d                   	pop    %ebp
  8022fe:	c3                   	ret    

008022ff <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	83 e0 01             	and    $0x1,%eax
  80230b:	85 c0                	test   %eax,%eax
  80230d:	74 03                	je     802312 <alloc_block_FF+0x13>
  80230f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802312:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802316:	77 07                	ja     80231f <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802318:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80231f:	a1 24 50 80 00       	mov    0x805024,%eax
  802324:	85 c0                	test   %eax,%eax
  802326:	75 73                	jne    80239b <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	83 c0 10             	add    $0x10,%eax
  80232e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802331:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802338:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80233b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80233e:	01 d0                	add    %edx,%eax
  802340:	48                   	dec    %eax
  802341:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802344:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802347:	ba 00 00 00 00       	mov    $0x0,%edx
  80234c:	f7 75 ec             	divl   -0x14(%ebp)
  80234f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802352:	29 d0                	sub    %edx,%eax
  802354:	c1 e8 0c             	shr    $0xc,%eax
  802357:	83 ec 0c             	sub    $0xc,%esp
  80235a:	50                   	push   %eax
  80235b:	e8 b1 f0 ff ff       	call   801411 <sbrk>
  802360:	83 c4 10             	add    $0x10,%esp
  802363:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802366:	83 ec 0c             	sub    $0xc,%esp
  802369:	6a 00                	push   $0x0
  80236b:	e8 a1 f0 ff ff       	call   801411 <sbrk>
  802370:	83 c4 10             	add    $0x10,%esp
  802373:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802376:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802379:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80237c:	83 ec 08             	sub    $0x8,%esp
  80237f:	50                   	push   %eax
  802380:	ff 75 e4             	pushl  -0x1c(%ebp)
  802383:	e8 5b fd ff ff       	call   8020e3 <initialize_dynamic_allocator>
  802388:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80238b:	83 ec 0c             	sub    $0xc,%esp
  80238e:	68 2f 48 80 00       	push   $0x80482f
  802393:	e8 df e2 ff ff       	call   800677 <cprintf>
  802398:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80239b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80239f:	75 0a                	jne    8023ab <alloc_block_FF+0xac>
	        return NULL;
  8023a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a6:	e9 0e 04 00 00       	jmp    8027b9 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8023ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8023b2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ba:	e9 f3 02 00 00       	jmp    8026b2 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c2:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8023c5:	83 ec 0c             	sub    $0xc,%esp
  8023c8:	ff 75 bc             	pushl  -0x44(%ebp)
  8023cb:	e8 af fb ff ff       	call   801f7f <get_block_size>
  8023d0:	83 c4 10             	add    $0x10,%esp
  8023d3:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8023d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d9:	83 c0 08             	add    $0x8,%eax
  8023dc:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023df:	0f 87 c5 02 00 00    	ja     8026aa <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	83 c0 18             	add    $0x18,%eax
  8023eb:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023ee:	0f 87 19 02 00 00    	ja     80260d <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8023f4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8023f7:	2b 45 08             	sub    0x8(%ebp),%eax
  8023fa:	83 e8 08             	sub    $0x8,%eax
  8023fd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802400:	8b 45 08             	mov    0x8(%ebp),%eax
  802403:	8d 50 08             	lea    0x8(%eax),%edx
  802406:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802409:	01 d0                	add    %edx,%eax
  80240b:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80240e:	8b 45 08             	mov    0x8(%ebp),%eax
  802411:	83 c0 08             	add    $0x8,%eax
  802414:	83 ec 04             	sub    $0x4,%esp
  802417:	6a 01                	push   $0x1
  802419:	50                   	push   %eax
  80241a:	ff 75 bc             	pushl  -0x44(%ebp)
  80241d:	e8 ae fe ff ff       	call   8022d0 <set_block_data>
  802422:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802428:	8b 40 04             	mov    0x4(%eax),%eax
  80242b:	85 c0                	test   %eax,%eax
  80242d:	75 68                	jne    802497 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80242f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802433:	75 17                	jne    80244c <alloc_block_FF+0x14d>
  802435:	83 ec 04             	sub    $0x4,%esp
  802438:	68 0c 48 80 00       	push   $0x80480c
  80243d:	68 d7 00 00 00       	push   $0xd7
  802442:	68 f1 47 80 00       	push   $0x8047f1
  802447:	e8 6e df ff ff       	call   8003ba <_panic>
  80244c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802452:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802455:	89 10                	mov    %edx,(%eax)
  802457:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80245a:	8b 00                	mov    (%eax),%eax
  80245c:	85 c0                	test   %eax,%eax
  80245e:	74 0d                	je     80246d <alloc_block_FF+0x16e>
  802460:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802465:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802468:	89 50 04             	mov    %edx,0x4(%eax)
  80246b:	eb 08                	jmp    802475 <alloc_block_FF+0x176>
  80246d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802470:	a3 30 50 80 00       	mov    %eax,0x805030
  802475:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802478:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80247d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802480:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802487:	a1 38 50 80 00       	mov    0x805038,%eax
  80248c:	40                   	inc    %eax
  80248d:	a3 38 50 80 00       	mov    %eax,0x805038
  802492:	e9 dc 00 00 00       	jmp    802573 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249a:	8b 00                	mov    (%eax),%eax
  80249c:	85 c0                	test   %eax,%eax
  80249e:	75 65                	jne    802505 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8024a0:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024a4:	75 17                	jne    8024bd <alloc_block_FF+0x1be>
  8024a6:	83 ec 04             	sub    $0x4,%esp
  8024a9:	68 40 48 80 00       	push   $0x804840
  8024ae:	68 db 00 00 00       	push   $0xdb
  8024b3:	68 f1 47 80 00       	push   $0x8047f1
  8024b8:	e8 fd de ff ff       	call   8003ba <_panic>
  8024bd:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8024c3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024c6:	89 50 04             	mov    %edx,0x4(%eax)
  8024c9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024cc:	8b 40 04             	mov    0x4(%eax),%eax
  8024cf:	85 c0                	test   %eax,%eax
  8024d1:	74 0c                	je     8024df <alloc_block_FF+0x1e0>
  8024d3:	a1 30 50 80 00       	mov    0x805030,%eax
  8024d8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024db:	89 10                	mov    %edx,(%eax)
  8024dd:	eb 08                	jmp    8024e7 <alloc_block_FF+0x1e8>
  8024df:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024e2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ea:	a3 30 50 80 00       	mov    %eax,0x805030
  8024ef:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024f8:	a1 38 50 80 00       	mov    0x805038,%eax
  8024fd:	40                   	inc    %eax
  8024fe:	a3 38 50 80 00       	mov    %eax,0x805038
  802503:	eb 6e                	jmp    802573 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802505:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802509:	74 06                	je     802511 <alloc_block_FF+0x212>
  80250b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80250f:	75 17                	jne    802528 <alloc_block_FF+0x229>
  802511:	83 ec 04             	sub    $0x4,%esp
  802514:	68 64 48 80 00       	push   $0x804864
  802519:	68 df 00 00 00       	push   $0xdf
  80251e:	68 f1 47 80 00       	push   $0x8047f1
  802523:	e8 92 de ff ff       	call   8003ba <_panic>
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	8b 10                	mov    (%eax),%edx
  80252d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802530:	89 10                	mov    %edx,(%eax)
  802532:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802535:	8b 00                	mov    (%eax),%eax
  802537:	85 c0                	test   %eax,%eax
  802539:	74 0b                	je     802546 <alloc_block_FF+0x247>
  80253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253e:	8b 00                	mov    (%eax),%eax
  802540:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802543:	89 50 04             	mov    %edx,0x4(%eax)
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80254c:	89 10                	mov    %edx,(%eax)
  80254e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802551:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802554:	89 50 04             	mov    %edx,0x4(%eax)
  802557:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80255a:	8b 00                	mov    (%eax),%eax
  80255c:	85 c0                	test   %eax,%eax
  80255e:	75 08                	jne    802568 <alloc_block_FF+0x269>
  802560:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802563:	a3 30 50 80 00       	mov    %eax,0x805030
  802568:	a1 38 50 80 00       	mov    0x805038,%eax
  80256d:	40                   	inc    %eax
  80256e:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802573:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802577:	75 17                	jne    802590 <alloc_block_FF+0x291>
  802579:	83 ec 04             	sub    $0x4,%esp
  80257c:	68 d3 47 80 00       	push   $0x8047d3
  802581:	68 e1 00 00 00       	push   $0xe1
  802586:	68 f1 47 80 00       	push   $0x8047f1
  80258b:	e8 2a de ff ff       	call   8003ba <_panic>
  802590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802593:	8b 00                	mov    (%eax),%eax
  802595:	85 c0                	test   %eax,%eax
  802597:	74 10                	je     8025a9 <alloc_block_FF+0x2aa>
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	8b 00                	mov    (%eax),%eax
  80259e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a1:	8b 52 04             	mov    0x4(%edx),%edx
  8025a4:	89 50 04             	mov    %edx,0x4(%eax)
  8025a7:	eb 0b                	jmp    8025b4 <alloc_block_FF+0x2b5>
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	8b 40 04             	mov    0x4(%eax),%eax
  8025af:	a3 30 50 80 00       	mov    %eax,0x805030
  8025b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b7:	8b 40 04             	mov    0x4(%eax),%eax
  8025ba:	85 c0                	test   %eax,%eax
  8025bc:	74 0f                	je     8025cd <alloc_block_FF+0x2ce>
  8025be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c1:	8b 40 04             	mov    0x4(%eax),%eax
  8025c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c7:	8b 12                	mov    (%edx),%edx
  8025c9:	89 10                	mov    %edx,(%eax)
  8025cb:	eb 0a                	jmp    8025d7 <alloc_block_FF+0x2d8>
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	8b 00                	mov    (%eax),%eax
  8025d2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ea:	a1 38 50 80 00       	mov    0x805038,%eax
  8025ef:	48                   	dec    %eax
  8025f0:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8025f5:	83 ec 04             	sub    $0x4,%esp
  8025f8:	6a 00                	push   $0x0
  8025fa:	ff 75 b4             	pushl  -0x4c(%ebp)
  8025fd:	ff 75 b0             	pushl  -0x50(%ebp)
  802600:	e8 cb fc ff ff       	call   8022d0 <set_block_data>
  802605:	83 c4 10             	add    $0x10,%esp
  802608:	e9 95 00 00 00       	jmp    8026a2 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80260d:	83 ec 04             	sub    $0x4,%esp
  802610:	6a 01                	push   $0x1
  802612:	ff 75 b8             	pushl  -0x48(%ebp)
  802615:	ff 75 bc             	pushl  -0x44(%ebp)
  802618:	e8 b3 fc ff ff       	call   8022d0 <set_block_data>
  80261d:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802620:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802624:	75 17                	jne    80263d <alloc_block_FF+0x33e>
  802626:	83 ec 04             	sub    $0x4,%esp
  802629:	68 d3 47 80 00       	push   $0x8047d3
  80262e:	68 e8 00 00 00       	push   $0xe8
  802633:	68 f1 47 80 00       	push   $0x8047f1
  802638:	e8 7d dd ff ff       	call   8003ba <_panic>
  80263d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802640:	8b 00                	mov    (%eax),%eax
  802642:	85 c0                	test   %eax,%eax
  802644:	74 10                	je     802656 <alloc_block_FF+0x357>
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	8b 00                	mov    (%eax),%eax
  80264b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80264e:	8b 52 04             	mov    0x4(%edx),%edx
  802651:	89 50 04             	mov    %edx,0x4(%eax)
  802654:	eb 0b                	jmp    802661 <alloc_block_FF+0x362>
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	8b 40 04             	mov    0x4(%eax),%eax
  80265c:	a3 30 50 80 00       	mov    %eax,0x805030
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	8b 40 04             	mov    0x4(%eax),%eax
  802667:	85 c0                	test   %eax,%eax
  802669:	74 0f                	je     80267a <alloc_block_FF+0x37b>
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	8b 40 04             	mov    0x4(%eax),%eax
  802671:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802674:	8b 12                	mov    (%edx),%edx
  802676:	89 10                	mov    %edx,(%eax)
  802678:	eb 0a                	jmp    802684 <alloc_block_FF+0x385>
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	8b 00                	mov    (%eax),%eax
  80267f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80268d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802690:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802697:	a1 38 50 80 00       	mov    0x805038,%eax
  80269c:	48                   	dec    %eax
  80269d:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8026a2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026a5:	e9 0f 01 00 00       	jmp    8027b9 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8026aa:	a1 34 50 80 00       	mov    0x805034,%eax
  8026af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b6:	74 07                	je     8026bf <alloc_block_FF+0x3c0>
  8026b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bb:	8b 00                	mov    (%eax),%eax
  8026bd:	eb 05                	jmp    8026c4 <alloc_block_FF+0x3c5>
  8026bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c4:	a3 34 50 80 00       	mov    %eax,0x805034
  8026c9:	a1 34 50 80 00       	mov    0x805034,%eax
  8026ce:	85 c0                	test   %eax,%eax
  8026d0:	0f 85 e9 fc ff ff    	jne    8023bf <alloc_block_FF+0xc0>
  8026d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026da:	0f 85 df fc ff ff    	jne    8023bf <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8026e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e3:	83 c0 08             	add    $0x8,%eax
  8026e6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8026e9:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026f6:	01 d0                	add    %edx,%eax
  8026f8:	48                   	dec    %eax
  8026f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026ff:	ba 00 00 00 00       	mov    $0x0,%edx
  802704:	f7 75 d8             	divl   -0x28(%ebp)
  802707:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80270a:	29 d0                	sub    %edx,%eax
  80270c:	c1 e8 0c             	shr    $0xc,%eax
  80270f:	83 ec 0c             	sub    $0xc,%esp
  802712:	50                   	push   %eax
  802713:	e8 f9 ec ff ff       	call   801411 <sbrk>
  802718:	83 c4 10             	add    $0x10,%esp
  80271b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80271e:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802722:	75 0a                	jne    80272e <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802724:	b8 00 00 00 00       	mov    $0x0,%eax
  802729:	e9 8b 00 00 00       	jmp    8027b9 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80272e:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802735:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802738:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80273b:	01 d0                	add    %edx,%eax
  80273d:	48                   	dec    %eax
  80273e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802741:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802744:	ba 00 00 00 00       	mov    $0x0,%edx
  802749:	f7 75 cc             	divl   -0x34(%ebp)
  80274c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80274f:	29 d0                	sub    %edx,%eax
  802751:	8d 50 fc             	lea    -0x4(%eax),%edx
  802754:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802757:	01 d0                	add    %edx,%eax
  802759:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80275e:	a1 40 50 80 00       	mov    0x805040,%eax
  802763:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802769:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802770:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802773:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802776:	01 d0                	add    %edx,%eax
  802778:	48                   	dec    %eax
  802779:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80277c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80277f:	ba 00 00 00 00       	mov    $0x0,%edx
  802784:	f7 75 c4             	divl   -0x3c(%ebp)
  802787:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80278a:	29 d0                	sub    %edx,%eax
  80278c:	83 ec 04             	sub    $0x4,%esp
  80278f:	6a 01                	push   $0x1
  802791:	50                   	push   %eax
  802792:	ff 75 d0             	pushl  -0x30(%ebp)
  802795:	e8 36 fb ff ff       	call   8022d0 <set_block_data>
  80279a:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80279d:	83 ec 0c             	sub    $0xc,%esp
  8027a0:	ff 75 d0             	pushl  -0x30(%ebp)
  8027a3:	e8 1b 0a 00 00       	call   8031c3 <free_block>
  8027a8:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8027ab:	83 ec 0c             	sub    $0xc,%esp
  8027ae:	ff 75 08             	pushl  0x8(%ebp)
  8027b1:	e8 49 fb ff ff       	call   8022ff <alloc_block_FF>
  8027b6:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8027b9:	c9                   	leave  
  8027ba:	c3                   	ret    

008027bb <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8027bb:	55                   	push   %ebp
  8027bc:	89 e5                	mov    %esp,%ebp
  8027be:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c4:	83 e0 01             	and    $0x1,%eax
  8027c7:	85 c0                	test   %eax,%eax
  8027c9:	74 03                	je     8027ce <alloc_block_BF+0x13>
  8027cb:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8027ce:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8027d2:	77 07                	ja     8027db <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027d4:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027db:	a1 24 50 80 00       	mov    0x805024,%eax
  8027e0:	85 c0                	test   %eax,%eax
  8027e2:	75 73                	jne    802857 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e7:	83 c0 10             	add    $0x10,%eax
  8027ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027ed:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8027f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027fa:	01 d0                	add    %edx,%eax
  8027fc:	48                   	dec    %eax
  8027fd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802800:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802803:	ba 00 00 00 00       	mov    $0x0,%edx
  802808:	f7 75 e0             	divl   -0x20(%ebp)
  80280b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80280e:	29 d0                	sub    %edx,%eax
  802810:	c1 e8 0c             	shr    $0xc,%eax
  802813:	83 ec 0c             	sub    $0xc,%esp
  802816:	50                   	push   %eax
  802817:	e8 f5 eb ff ff       	call   801411 <sbrk>
  80281c:	83 c4 10             	add    $0x10,%esp
  80281f:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802822:	83 ec 0c             	sub    $0xc,%esp
  802825:	6a 00                	push   $0x0
  802827:	e8 e5 eb ff ff       	call   801411 <sbrk>
  80282c:	83 c4 10             	add    $0x10,%esp
  80282f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802832:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802835:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802838:	83 ec 08             	sub    $0x8,%esp
  80283b:	50                   	push   %eax
  80283c:	ff 75 d8             	pushl  -0x28(%ebp)
  80283f:	e8 9f f8 ff ff       	call   8020e3 <initialize_dynamic_allocator>
  802844:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802847:	83 ec 0c             	sub    $0xc,%esp
  80284a:	68 2f 48 80 00       	push   $0x80482f
  80284f:	e8 23 de ff ff       	call   800677 <cprintf>
  802854:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802857:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80285e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802865:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80286c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802873:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802878:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80287b:	e9 1d 01 00 00       	jmp    80299d <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802886:	83 ec 0c             	sub    $0xc,%esp
  802889:	ff 75 a8             	pushl  -0x58(%ebp)
  80288c:	e8 ee f6 ff ff       	call   801f7f <get_block_size>
  802891:	83 c4 10             	add    $0x10,%esp
  802894:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802897:	8b 45 08             	mov    0x8(%ebp),%eax
  80289a:	83 c0 08             	add    $0x8,%eax
  80289d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028a0:	0f 87 ef 00 00 00    	ja     802995 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8028a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a9:	83 c0 18             	add    $0x18,%eax
  8028ac:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028af:	77 1d                	ja     8028ce <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8028b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028b7:	0f 86 d8 00 00 00    	jbe    802995 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8028bd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8028c3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028c9:	e9 c7 00 00 00       	jmp    802995 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d1:	83 c0 08             	add    $0x8,%eax
  8028d4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028d7:	0f 85 9d 00 00 00    	jne    80297a <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8028dd:	83 ec 04             	sub    $0x4,%esp
  8028e0:	6a 01                	push   $0x1
  8028e2:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028e5:	ff 75 a8             	pushl  -0x58(%ebp)
  8028e8:	e8 e3 f9 ff ff       	call   8022d0 <set_block_data>
  8028ed:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8028f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f4:	75 17                	jne    80290d <alloc_block_BF+0x152>
  8028f6:	83 ec 04             	sub    $0x4,%esp
  8028f9:	68 d3 47 80 00       	push   $0x8047d3
  8028fe:	68 2c 01 00 00       	push   $0x12c
  802903:	68 f1 47 80 00       	push   $0x8047f1
  802908:	e8 ad da ff ff       	call   8003ba <_panic>
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	8b 00                	mov    (%eax),%eax
  802912:	85 c0                	test   %eax,%eax
  802914:	74 10                	je     802926 <alloc_block_BF+0x16b>
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	8b 00                	mov    (%eax),%eax
  80291b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80291e:	8b 52 04             	mov    0x4(%edx),%edx
  802921:	89 50 04             	mov    %edx,0x4(%eax)
  802924:	eb 0b                	jmp    802931 <alloc_block_BF+0x176>
  802926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802929:	8b 40 04             	mov    0x4(%eax),%eax
  80292c:	a3 30 50 80 00       	mov    %eax,0x805030
  802931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802934:	8b 40 04             	mov    0x4(%eax),%eax
  802937:	85 c0                	test   %eax,%eax
  802939:	74 0f                	je     80294a <alloc_block_BF+0x18f>
  80293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293e:	8b 40 04             	mov    0x4(%eax),%eax
  802941:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802944:	8b 12                	mov    (%edx),%edx
  802946:	89 10                	mov    %edx,(%eax)
  802948:	eb 0a                	jmp    802954 <alloc_block_BF+0x199>
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	8b 00                	mov    (%eax),%eax
  80294f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802957:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802960:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802967:	a1 38 50 80 00       	mov    0x805038,%eax
  80296c:	48                   	dec    %eax
  80296d:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802972:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802975:	e9 24 04 00 00       	jmp    802d9e <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80297a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802980:	76 13                	jbe    802995 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802982:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802989:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80298c:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80298f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802992:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802995:	a1 34 50 80 00       	mov    0x805034,%eax
  80299a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80299d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a1:	74 07                	je     8029aa <alloc_block_BF+0x1ef>
  8029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a6:	8b 00                	mov    (%eax),%eax
  8029a8:	eb 05                	jmp    8029af <alloc_block_BF+0x1f4>
  8029aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8029af:	a3 34 50 80 00       	mov    %eax,0x805034
  8029b4:	a1 34 50 80 00       	mov    0x805034,%eax
  8029b9:	85 c0                	test   %eax,%eax
  8029bb:	0f 85 bf fe ff ff    	jne    802880 <alloc_block_BF+0xc5>
  8029c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c5:	0f 85 b5 fe ff ff    	jne    802880 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8029cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029cf:	0f 84 26 02 00 00    	je     802bfb <alloc_block_BF+0x440>
  8029d5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029d9:	0f 85 1c 02 00 00    	jne    802bfb <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8029df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e2:	2b 45 08             	sub    0x8(%ebp),%eax
  8029e5:	83 e8 08             	sub    $0x8,%eax
  8029e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8029eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ee:	8d 50 08             	lea    0x8(%eax),%edx
  8029f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f4:	01 d0                	add    %edx,%eax
  8029f6:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8029f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fc:	83 c0 08             	add    $0x8,%eax
  8029ff:	83 ec 04             	sub    $0x4,%esp
  802a02:	6a 01                	push   $0x1
  802a04:	50                   	push   %eax
  802a05:	ff 75 f0             	pushl  -0x10(%ebp)
  802a08:	e8 c3 f8 ff ff       	call   8022d0 <set_block_data>
  802a0d:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a13:	8b 40 04             	mov    0x4(%eax),%eax
  802a16:	85 c0                	test   %eax,%eax
  802a18:	75 68                	jne    802a82 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a1a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a1e:	75 17                	jne    802a37 <alloc_block_BF+0x27c>
  802a20:	83 ec 04             	sub    $0x4,%esp
  802a23:	68 0c 48 80 00       	push   $0x80480c
  802a28:	68 45 01 00 00       	push   $0x145
  802a2d:	68 f1 47 80 00       	push   $0x8047f1
  802a32:	e8 83 d9 ff ff       	call   8003ba <_panic>
  802a37:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a3d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a40:	89 10                	mov    %edx,(%eax)
  802a42:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a45:	8b 00                	mov    (%eax),%eax
  802a47:	85 c0                	test   %eax,%eax
  802a49:	74 0d                	je     802a58 <alloc_block_BF+0x29d>
  802a4b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a50:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a53:	89 50 04             	mov    %edx,0x4(%eax)
  802a56:	eb 08                	jmp    802a60 <alloc_block_BF+0x2a5>
  802a58:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a5b:	a3 30 50 80 00       	mov    %eax,0x805030
  802a60:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a63:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a68:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a72:	a1 38 50 80 00       	mov    0x805038,%eax
  802a77:	40                   	inc    %eax
  802a78:	a3 38 50 80 00       	mov    %eax,0x805038
  802a7d:	e9 dc 00 00 00       	jmp    802b5e <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a85:	8b 00                	mov    (%eax),%eax
  802a87:	85 c0                	test   %eax,%eax
  802a89:	75 65                	jne    802af0 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a8b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a8f:	75 17                	jne    802aa8 <alloc_block_BF+0x2ed>
  802a91:	83 ec 04             	sub    $0x4,%esp
  802a94:	68 40 48 80 00       	push   $0x804840
  802a99:	68 4a 01 00 00       	push   $0x14a
  802a9e:	68 f1 47 80 00       	push   $0x8047f1
  802aa3:	e8 12 d9 ff ff       	call   8003ba <_panic>
  802aa8:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802aae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ab1:	89 50 04             	mov    %edx,0x4(%eax)
  802ab4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ab7:	8b 40 04             	mov    0x4(%eax),%eax
  802aba:	85 c0                	test   %eax,%eax
  802abc:	74 0c                	je     802aca <alloc_block_BF+0x30f>
  802abe:	a1 30 50 80 00       	mov    0x805030,%eax
  802ac3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ac6:	89 10                	mov    %edx,(%eax)
  802ac8:	eb 08                	jmp    802ad2 <alloc_block_BF+0x317>
  802aca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802acd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ad2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ad5:	a3 30 50 80 00       	mov    %eax,0x805030
  802ada:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802add:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae3:	a1 38 50 80 00       	mov    0x805038,%eax
  802ae8:	40                   	inc    %eax
  802ae9:	a3 38 50 80 00       	mov    %eax,0x805038
  802aee:	eb 6e                	jmp    802b5e <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802af0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802af4:	74 06                	je     802afc <alloc_block_BF+0x341>
  802af6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802afa:	75 17                	jne    802b13 <alloc_block_BF+0x358>
  802afc:	83 ec 04             	sub    $0x4,%esp
  802aff:	68 64 48 80 00       	push   $0x804864
  802b04:	68 4f 01 00 00       	push   $0x14f
  802b09:	68 f1 47 80 00       	push   $0x8047f1
  802b0e:	e8 a7 d8 ff ff       	call   8003ba <_panic>
  802b13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b16:	8b 10                	mov    (%eax),%edx
  802b18:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b1b:	89 10                	mov    %edx,(%eax)
  802b1d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b20:	8b 00                	mov    (%eax),%eax
  802b22:	85 c0                	test   %eax,%eax
  802b24:	74 0b                	je     802b31 <alloc_block_BF+0x376>
  802b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b29:	8b 00                	mov    (%eax),%eax
  802b2b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b2e:	89 50 04             	mov    %edx,0x4(%eax)
  802b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b34:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b37:	89 10                	mov    %edx,(%eax)
  802b39:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b3c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b3f:	89 50 04             	mov    %edx,0x4(%eax)
  802b42:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b45:	8b 00                	mov    (%eax),%eax
  802b47:	85 c0                	test   %eax,%eax
  802b49:	75 08                	jne    802b53 <alloc_block_BF+0x398>
  802b4b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b4e:	a3 30 50 80 00       	mov    %eax,0x805030
  802b53:	a1 38 50 80 00       	mov    0x805038,%eax
  802b58:	40                   	inc    %eax
  802b59:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b62:	75 17                	jne    802b7b <alloc_block_BF+0x3c0>
  802b64:	83 ec 04             	sub    $0x4,%esp
  802b67:	68 d3 47 80 00       	push   $0x8047d3
  802b6c:	68 51 01 00 00       	push   $0x151
  802b71:	68 f1 47 80 00       	push   $0x8047f1
  802b76:	e8 3f d8 ff ff       	call   8003ba <_panic>
  802b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7e:	8b 00                	mov    (%eax),%eax
  802b80:	85 c0                	test   %eax,%eax
  802b82:	74 10                	je     802b94 <alloc_block_BF+0x3d9>
  802b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b87:	8b 00                	mov    (%eax),%eax
  802b89:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b8c:	8b 52 04             	mov    0x4(%edx),%edx
  802b8f:	89 50 04             	mov    %edx,0x4(%eax)
  802b92:	eb 0b                	jmp    802b9f <alloc_block_BF+0x3e4>
  802b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b97:	8b 40 04             	mov    0x4(%eax),%eax
  802b9a:	a3 30 50 80 00       	mov    %eax,0x805030
  802b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba2:	8b 40 04             	mov    0x4(%eax),%eax
  802ba5:	85 c0                	test   %eax,%eax
  802ba7:	74 0f                	je     802bb8 <alloc_block_BF+0x3fd>
  802ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bac:	8b 40 04             	mov    0x4(%eax),%eax
  802baf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bb2:	8b 12                	mov    (%edx),%edx
  802bb4:	89 10                	mov    %edx,(%eax)
  802bb6:	eb 0a                	jmp    802bc2 <alloc_block_BF+0x407>
  802bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbb:	8b 00                	mov    (%eax),%eax
  802bbd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd5:	a1 38 50 80 00       	mov    0x805038,%eax
  802bda:	48                   	dec    %eax
  802bdb:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802be0:	83 ec 04             	sub    $0x4,%esp
  802be3:	6a 00                	push   $0x0
  802be5:	ff 75 d0             	pushl  -0x30(%ebp)
  802be8:	ff 75 cc             	pushl  -0x34(%ebp)
  802beb:	e8 e0 f6 ff ff       	call   8022d0 <set_block_data>
  802bf0:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf6:	e9 a3 01 00 00       	jmp    802d9e <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802bfb:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802bff:	0f 85 9d 00 00 00    	jne    802ca2 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802c05:	83 ec 04             	sub    $0x4,%esp
  802c08:	6a 01                	push   $0x1
  802c0a:	ff 75 ec             	pushl  -0x14(%ebp)
  802c0d:	ff 75 f0             	pushl  -0x10(%ebp)
  802c10:	e8 bb f6 ff ff       	call   8022d0 <set_block_data>
  802c15:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802c18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c1c:	75 17                	jne    802c35 <alloc_block_BF+0x47a>
  802c1e:	83 ec 04             	sub    $0x4,%esp
  802c21:	68 d3 47 80 00       	push   $0x8047d3
  802c26:	68 58 01 00 00       	push   $0x158
  802c2b:	68 f1 47 80 00       	push   $0x8047f1
  802c30:	e8 85 d7 ff ff       	call   8003ba <_panic>
  802c35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c38:	8b 00                	mov    (%eax),%eax
  802c3a:	85 c0                	test   %eax,%eax
  802c3c:	74 10                	je     802c4e <alloc_block_BF+0x493>
  802c3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c41:	8b 00                	mov    (%eax),%eax
  802c43:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c46:	8b 52 04             	mov    0x4(%edx),%edx
  802c49:	89 50 04             	mov    %edx,0x4(%eax)
  802c4c:	eb 0b                	jmp    802c59 <alloc_block_BF+0x49e>
  802c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c51:	8b 40 04             	mov    0x4(%eax),%eax
  802c54:	a3 30 50 80 00       	mov    %eax,0x805030
  802c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5c:	8b 40 04             	mov    0x4(%eax),%eax
  802c5f:	85 c0                	test   %eax,%eax
  802c61:	74 0f                	je     802c72 <alloc_block_BF+0x4b7>
  802c63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c66:	8b 40 04             	mov    0x4(%eax),%eax
  802c69:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c6c:	8b 12                	mov    (%edx),%edx
  802c6e:	89 10                	mov    %edx,(%eax)
  802c70:	eb 0a                	jmp    802c7c <alloc_block_BF+0x4c1>
  802c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c75:	8b 00                	mov    (%eax),%eax
  802c77:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c8f:	a1 38 50 80 00       	mov    0x805038,%eax
  802c94:	48                   	dec    %eax
  802c95:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9d:	e9 fc 00 00 00       	jmp    802d9e <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca5:	83 c0 08             	add    $0x8,%eax
  802ca8:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802cab:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802cb2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cb5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802cb8:	01 d0                	add    %edx,%eax
  802cba:	48                   	dec    %eax
  802cbb:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802cbe:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cc1:	ba 00 00 00 00       	mov    $0x0,%edx
  802cc6:	f7 75 c4             	divl   -0x3c(%ebp)
  802cc9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ccc:	29 d0                	sub    %edx,%eax
  802cce:	c1 e8 0c             	shr    $0xc,%eax
  802cd1:	83 ec 0c             	sub    $0xc,%esp
  802cd4:	50                   	push   %eax
  802cd5:	e8 37 e7 ff ff       	call   801411 <sbrk>
  802cda:	83 c4 10             	add    $0x10,%esp
  802cdd:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802ce0:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802ce4:	75 0a                	jne    802cf0 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802ce6:	b8 00 00 00 00       	mov    $0x0,%eax
  802ceb:	e9 ae 00 00 00       	jmp    802d9e <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802cf0:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802cf7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cfa:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802cfd:	01 d0                	add    %edx,%eax
  802cff:	48                   	dec    %eax
  802d00:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802d03:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d06:	ba 00 00 00 00       	mov    $0x0,%edx
  802d0b:	f7 75 b8             	divl   -0x48(%ebp)
  802d0e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d11:	29 d0                	sub    %edx,%eax
  802d13:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d16:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d19:	01 d0                	add    %edx,%eax
  802d1b:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802d20:	a1 40 50 80 00       	mov    0x805040,%eax
  802d25:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802d2b:	83 ec 0c             	sub    $0xc,%esp
  802d2e:	68 98 48 80 00       	push   $0x804898
  802d33:	e8 3f d9 ff ff       	call   800677 <cprintf>
  802d38:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802d3b:	83 ec 08             	sub    $0x8,%esp
  802d3e:	ff 75 bc             	pushl  -0x44(%ebp)
  802d41:	68 9d 48 80 00       	push   $0x80489d
  802d46:	e8 2c d9 ff ff       	call   800677 <cprintf>
  802d4b:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d4e:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d55:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d58:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d5b:	01 d0                	add    %edx,%eax
  802d5d:	48                   	dec    %eax
  802d5e:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d61:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d64:	ba 00 00 00 00       	mov    $0x0,%edx
  802d69:	f7 75 b0             	divl   -0x50(%ebp)
  802d6c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d6f:	29 d0                	sub    %edx,%eax
  802d71:	83 ec 04             	sub    $0x4,%esp
  802d74:	6a 01                	push   $0x1
  802d76:	50                   	push   %eax
  802d77:	ff 75 bc             	pushl  -0x44(%ebp)
  802d7a:	e8 51 f5 ff ff       	call   8022d0 <set_block_data>
  802d7f:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d82:	83 ec 0c             	sub    $0xc,%esp
  802d85:	ff 75 bc             	pushl  -0x44(%ebp)
  802d88:	e8 36 04 00 00       	call   8031c3 <free_block>
  802d8d:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d90:	83 ec 0c             	sub    $0xc,%esp
  802d93:	ff 75 08             	pushl  0x8(%ebp)
  802d96:	e8 20 fa ff ff       	call   8027bb <alloc_block_BF>
  802d9b:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d9e:	c9                   	leave  
  802d9f:	c3                   	ret    

00802da0 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802da0:	55                   	push   %ebp
  802da1:	89 e5                	mov    %esp,%ebp
  802da3:	53                   	push   %ebx
  802da4:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802da7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802dae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802db5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db9:	74 1e                	je     802dd9 <merging+0x39>
  802dbb:	ff 75 08             	pushl  0x8(%ebp)
  802dbe:	e8 bc f1 ff ff       	call   801f7f <get_block_size>
  802dc3:	83 c4 04             	add    $0x4,%esp
  802dc6:	89 c2                	mov    %eax,%edx
  802dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcb:	01 d0                	add    %edx,%eax
  802dcd:	3b 45 10             	cmp    0x10(%ebp),%eax
  802dd0:	75 07                	jne    802dd9 <merging+0x39>
		prev_is_free = 1;
  802dd2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802dd9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ddd:	74 1e                	je     802dfd <merging+0x5d>
  802ddf:	ff 75 10             	pushl  0x10(%ebp)
  802de2:	e8 98 f1 ff ff       	call   801f7f <get_block_size>
  802de7:	83 c4 04             	add    $0x4,%esp
  802dea:	89 c2                	mov    %eax,%edx
  802dec:	8b 45 10             	mov    0x10(%ebp),%eax
  802def:	01 d0                	add    %edx,%eax
  802df1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802df4:	75 07                	jne    802dfd <merging+0x5d>
		next_is_free = 1;
  802df6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802dfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e01:	0f 84 cc 00 00 00    	je     802ed3 <merging+0x133>
  802e07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e0b:	0f 84 c2 00 00 00    	je     802ed3 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802e11:	ff 75 08             	pushl  0x8(%ebp)
  802e14:	e8 66 f1 ff ff       	call   801f7f <get_block_size>
  802e19:	83 c4 04             	add    $0x4,%esp
  802e1c:	89 c3                	mov    %eax,%ebx
  802e1e:	ff 75 10             	pushl  0x10(%ebp)
  802e21:	e8 59 f1 ff ff       	call   801f7f <get_block_size>
  802e26:	83 c4 04             	add    $0x4,%esp
  802e29:	01 c3                	add    %eax,%ebx
  802e2b:	ff 75 0c             	pushl  0xc(%ebp)
  802e2e:	e8 4c f1 ff ff       	call   801f7f <get_block_size>
  802e33:	83 c4 04             	add    $0x4,%esp
  802e36:	01 d8                	add    %ebx,%eax
  802e38:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e3b:	6a 00                	push   $0x0
  802e3d:	ff 75 ec             	pushl  -0x14(%ebp)
  802e40:	ff 75 08             	pushl  0x8(%ebp)
  802e43:	e8 88 f4 ff ff       	call   8022d0 <set_block_data>
  802e48:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e4b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e4f:	75 17                	jne    802e68 <merging+0xc8>
  802e51:	83 ec 04             	sub    $0x4,%esp
  802e54:	68 d3 47 80 00       	push   $0x8047d3
  802e59:	68 7d 01 00 00       	push   $0x17d
  802e5e:	68 f1 47 80 00       	push   $0x8047f1
  802e63:	e8 52 d5 ff ff       	call   8003ba <_panic>
  802e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e6b:	8b 00                	mov    (%eax),%eax
  802e6d:	85 c0                	test   %eax,%eax
  802e6f:	74 10                	je     802e81 <merging+0xe1>
  802e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e74:	8b 00                	mov    (%eax),%eax
  802e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e79:	8b 52 04             	mov    0x4(%edx),%edx
  802e7c:	89 50 04             	mov    %edx,0x4(%eax)
  802e7f:	eb 0b                	jmp    802e8c <merging+0xec>
  802e81:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e84:	8b 40 04             	mov    0x4(%eax),%eax
  802e87:	a3 30 50 80 00       	mov    %eax,0x805030
  802e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e8f:	8b 40 04             	mov    0x4(%eax),%eax
  802e92:	85 c0                	test   %eax,%eax
  802e94:	74 0f                	je     802ea5 <merging+0x105>
  802e96:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e99:	8b 40 04             	mov    0x4(%eax),%eax
  802e9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e9f:	8b 12                	mov    (%edx),%edx
  802ea1:	89 10                	mov    %edx,(%eax)
  802ea3:	eb 0a                	jmp    802eaf <merging+0x10f>
  802ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea8:	8b 00                	mov    (%eax),%eax
  802eaa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ebb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec2:	a1 38 50 80 00       	mov    0x805038,%eax
  802ec7:	48                   	dec    %eax
  802ec8:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802ecd:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ece:	e9 ea 02 00 00       	jmp    8031bd <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802ed3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed7:	74 3b                	je     802f14 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802ed9:	83 ec 0c             	sub    $0xc,%esp
  802edc:	ff 75 08             	pushl  0x8(%ebp)
  802edf:	e8 9b f0 ff ff       	call   801f7f <get_block_size>
  802ee4:	83 c4 10             	add    $0x10,%esp
  802ee7:	89 c3                	mov    %eax,%ebx
  802ee9:	83 ec 0c             	sub    $0xc,%esp
  802eec:	ff 75 10             	pushl  0x10(%ebp)
  802eef:	e8 8b f0 ff ff       	call   801f7f <get_block_size>
  802ef4:	83 c4 10             	add    $0x10,%esp
  802ef7:	01 d8                	add    %ebx,%eax
  802ef9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802efc:	83 ec 04             	sub    $0x4,%esp
  802eff:	6a 00                	push   $0x0
  802f01:	ff 75 e8             	pushl  -0x18(%ebp)
  802f04:	ff 75 08             	pushl  0x8(%ebp)
  802f07:	e8 c4 f3 ff ff       	call   8022d0 <set_block_data>
  802f0c:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f0f:	e9 a9 02 00 00       	jmp    8031bd <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802f14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f18:	0f 84 2d 01 00 00    	je     80304b <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802f1e:	83 ec 0c             	sub    $0xc,%esp
  802f21:	ff 75 10             	pushl  0x10(%ebp)
  802f24:	e8 56 f0 ff ff       	call   801f7f <get_block_size>
  802f29:	83 c4 10             	add    $0x10,%esp
  802f2c:	89 c3                	mov    %eax,%ebx
  802f2e:	83 ec 0c             	sub    $0xc,%esp
  802f31:	ff 75 0c             	pushl  0xc(%ebp)
  802f34:	e8 46 f0 ff ff       	call   801f7f <get_block_size>
  802f39:	83 c4 10             	add    $0x10,%esp
  802f3c:	01 d8                	add    %ebx,%eax
  802f3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f41:	83 ec 04             	sub    $0x4,%esp
  802f44:	6a 00                	push   $0x0
  802f46:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f49:	ff 75 10             	pushl  0x10(%ebp)
  802f4c:	e8 7f f3 ff ff       	call   8022d0 <set_block_data>
  802f51:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f54:	8b 45 10             	mov    0x10(%ebp),%eax
  802f57:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f5e:	74 06                	je     802f66 <merging+0x1c6>
  802f60:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f64:	75 17                	jne    802f7d <merging+0x1dd>
  802f66:	83 ec 04             	sub    $0x4,%esp
  802f69:	68 ac 48 80 00       	push   $0x8048ac
  802f6e:	68 8d 01 00 00       	push   $0x18d
  802f73:	68 f1 47 80 00       	push   $0x8047f1
  802f78:	e8 3d d4 ff ff       	call   8003ba <_panic>
  802f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f80:	8b 50 04             	mov    0x4(%eax),%edx
  802f83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f86:	89 50 04             	mov    %edx,0x4(%eax)
  802f89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f8f:	89 10                	mov    %edx,(%eax)
  802f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f94:	8b 40 04             	mov    0x4(%eax),%eax
  802f97:	85 c0                	test   %eax,%eax
  802f99:	74 0d                	je     802fa8 <merging+0x208>
  802f9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f9e:	8b 40 04             	mov    0x4(%eax),%eax
  802fa1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fa4:	89 10                	mov    %edx,(%eax)
  802fa6:	eb 08                	jmp    802fb0 <merging+0x210>
  802fa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fab:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fb6:	89 50 04             	mov    %edx,0x4(%eax)
  802fb9:	a1 38 50 80 00       	mov    0x805038,%eax
  802fbe:	40                   	inc    %eax
  802fbf:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802fc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fc8:	75 17                	jne    802fe1 <merging+0x241>
  802fca:	83 ec 04             	sub    $0x4,%esp
  802fcd:	68 d3 47 80 00       	push   $0x8047d3
  802fd2:	68 8e 01 00 00       	push   $0x18e
  802fd7:	68 f1 47 80 00       	push   $0x8047f1
  802fdc:	e8 d9 d3 ff ff       	call   8003ba <_panic>
  802fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe4:	8b 00                	mov    (%eax),%eax
  802fe6:	85 c0                	test   %eax,%eax
  802fe8:	74 10                	je     802ffa <merging+0x25a>
  802fea:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fed:	8b 00                	mov    (%eax),%eax
  802fef:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ff2:	8b 52 04             	mov    0x4(%edx),%edx
  802ff5:	89 50 04             	mov    %edx,0x4(%eax)
  802ff8:	eb 0b                	jmp    803005 <merging+0x265>
  802ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ffd:	8b 40 04             	mov    0x4(%eax),%eax
  803000:	a3 30 50 80 00       	mov    %eax,0x805030
  803005:	8b 45 0c             	mov    0xc(%ebp),%eax
  803008:	8b 40 04             	mov    0x4(%eax),%eax
  80300b:	85 c0                	test   %eax,%eax
  80300d:	74 0f                	je     80301e <merging+0x27e>
  80300f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803012:	8b 40 04             	mov    0x4(%eax),%eax
  803015:	8b 55 0c             	mov    0xc(%ebp),%edx
  803018:	8b 12                	mov    (%edx),%edx
  80301a:	89 10                	mov    %edx,(%eax)
  80301c:	eb 0a                	jmp    803028 <merging+0x288>
  80301e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803021:	8b 00                	mov    (%eax),%eax
  803023:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803028:	8b 45 0c             	mov    0xc(%ebp),%eax
  80302b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803031:	8b 45 0c             	mov    0xc(%ebp),%eax
  803034:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80303b:	a1 38 50 80 00       	mov    0x805038,%eax
  803040:	48                   	dec    %eax
  803041:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803046:	e9 72 01 00 00       	jmp    8031bd <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80304b:	8b 45 10             	mov    0x10(%ebp),%eax
  80304e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803051:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803055:	74 79                	je     8030d0 <merging+0x330>
  803057:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80305b:	74 73                	je     8030d0 <merging+0x330>
  80305d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803061:	74 06                	je     803069 <merging+0x2c9>
  803063:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803067:	75 17                	jne    803080 <merging+0x2e0>
  803069:	83 ec 04             	sub    $0x4,%esp
  80306c:	68 64 48 80 00       	push   $0x804864
  803071:	68 94 01 00 00       	push   $0x194
  803076:	68 f1 47 80 00       	push   $0x8047f1
  80307b:	e8 3a d3 ff ff       	call   8003ba <_panic>
  803080:	8b 45 08             	mov    0x8(%ebp),%eax
  803083:	8b 10                	mov    (%eax),%edx
  803085:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803088:	89 10                	mov    %edx,(%eax)
  80308a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80308d:	8b 00                	mov    (%eax),%eax
  80308f:	85 c0                	test   %eax,%eax
  803091:	74 0b                	je     80309e <merging+0x2fe>
  803093:	8b 45 08             	mov    0x8(%ebp),%eax
  803096:	8b 00                	mov    (%eax),%eax
  803098:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80309b:	89 50 04             	mov    %edx,0x4(%eax)
  80309e:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030a4:	89 10                	mov    %edx,(%eax)
  8030a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ac:	89 50 04             	mov    %edx,0x4(%eax)
  8030af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030b2:	8b 00                	mov    (%eax),%eax
  8030b4:	85 c0                	test   %eax,%eax
  8030b6:	75 08                	jne    8030c0 <merging+0x320>
  8030b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030bb:	a3 30 50 80 00       	mov    %eax,0x805030
  8030c0:	a1 38 50 80 00       	mov    0x805038,%eax
  8030c5:	40                   	inc    %eax
  8030c6:	a3 38 50 80 00       	mov    %eax,0x805038
  8030cb:	e9 ce 00 00 00       	jmp    80319e <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8030d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d4:	74 65                	je     80313b <merging+0x39b>
  8030d6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030da:	75 17                	jne    8030f3 <merging+0x353>
  8030dc:	83 ec 04             	sub    $0x4,%esp
  8030df:	68 40 48 80 00       	push   $0x804840
  8030e4:	68 95 01 00 00       	push   $0x195
  8030e9:	68 f1 47 80 00       	push   $0x8047f1
  8030ee:	e8 c7 d2 ff ff       	call   8003ba <_panic>
  8030f3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8030f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030fc:	89 50 04             	mov    %edx,0x4(%eax)
  8030ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803102:	8b 40 04             	mov    0x4(%eax),%eax
  803105:	85 c0                	test   %eax,%eax
  803107:	74 0c                	je     803115 <merging+0x375>
  803109:	a1 30 50 80 00       	mov    0x805030,%eax
  80310e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803111:	89 10                	mov    %edx,(%eax)
  803113:	eb 08                	jmp    80311d <merging+0x37d>
  803115:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803118:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80311d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803120:	a3 30 50 80 00       	mov    %eax,0x805030
  803125:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803128:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80312e:	a1 38 50 80 00       	mov    0x805038,%eax
  803133:	40                   	inc    %eax
  803134:	a3 38 50 80 00       	mov    %eax,0x805038
  803139:	eb 63                	jmp    80319e <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80313b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80313f:	75 17                	jne    803158 <merging+0x3b8>
  803141:	83 ec 04             	sub    $0x4,%esp
  803144:	68 0c 48 80 00       	push   $0x80480c
  803149:	68 98 01 00 00       	push   $0x198
  80314e:	68 f1 47 80 00       	push   $0x8047f1
  803153:	e8 62 d2 ff ff       	call   8003ba <_panic>
  803158:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80315e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803161:	89 10                	mov    %edx,(%eax)
  803163:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803166:	8b 00                	mov    (%eax),%eax
  803168:	85 c0                	test   %eax,%eax
  80316a:	74 0d                	je     803179 <merging+0x3d9>
  80316c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803171:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803174:	89 50 04             	mov    %edx,0x4(%eax)
  803177:	eb 08                	jmp    803181 <merging+0x3e1>
  803179:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80317c:	a3 30 50 80 00       	mov    %eax,0x805030
  803181:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803184:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803189:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80318c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803193:	a1 38 50 80 00       	mov    0x805038,%eax
  803198:	40                   	inc    %eax
  803199:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80319e:	83 ec 0c             	sub    $0xc,%esp
  8031a1:	ff 75 10             	pushl  0x10(%ebp)
  8031a4:	e8 d6 ed ff ff       	call   801f7f <get_block_size>
  8031a9:	83 c4 10             	add    $0x10,%esp
  8031ac:	83 ec 04             	sub    $0x4,%esp
  8031af:	6a 00                	push   $0x0
  8031b1:	50                   	push   %eax
  8031b2:	ff 75 10             	pushl  0x10(%ebp)
  8031b5:	e8 16 f1 ff ff       	call   8022d0 <set_block_data>
  8031ba:	83 c4 10             	add    $0x10,%esp
	}
}
  8031bd:	90                   	nop
  8031be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031c1:	c9                   	leave  
  8031c2:	c3                   	ret    

008031c3 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8031c3:	55                   	push   %ebp
  8031c4:	89 e5                	mov    %esp,%ebp
  8031c6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8031c9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031ce:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8031d1:	a1 30 50 80 00       	mov    0x805030,%eax
  8031d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031d9:	73 1b                	jae    8031f6 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8031db:	a1 30 50 80 00       	mov    0x805030,%eax
  8031e0:	83 ec 04             	sub    $0x4,%esp
  8031e3:	ff 75 08             	pushl  0x8(%ebp)
  8031e6:	6a 00                	push   $0x0
  8031e8:	50                   	push   %eax
  8031e9:	e8 b2 fb ff ff       	call   802da0 <merging>
  8031ee:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031f1:	e9 8b 00 00 00       	jmp    803281 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8031f6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031fe:	76 18                	jbe    803218 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803200:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803205:	83 ec 04             	sub    $0x4,%esp
  803208:	ff 75 08             	pushl  0x8(%ebp)
  80320b:	50                   	push   %eax
  80320c:	6a 00                	push   $0x0
  80320e:	e8 8d fb ff ff       	call   802da0 <merging>
  803213:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803216:	eb 69                	jmp    803281 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803218:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80321d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803220:	eb 39                	jmp    80325b <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803222:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803225:	3b 45 08             	cmp    0x8(%ebp),%eax
  803228:	73 29                	jae    803253 <free_block+0x90>
  80322a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322d:	8b 00                	mov    (%eax),%eax
  80322f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803232:	76 1f                	jbe    803253 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803237:	8b 00                	mov    (%eax),%eax
  803239:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80323c:	83 ec 04             	sub    $0x4,%esp
  80323f:	ff 75 08             	pushl  0x8(%ebp)
  803242:	ff 75 f0             	pushl  -0x10(%ebp)
  803245:	ff 75 f4             	pushl  -0xc(%ebp)
  803248:	e8 53 fb ff ff       	call   802da0 <merging>
  80324d:	83 c4 10             	add    $0x10,%esp
			break;
  803250:	90                   	nop
		}
	}
}
  803251:	eb 2e                	jmp    803281 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803253:	a1 34 50 80 00       	mov    0x805034,%eax
  803258:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80325b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80325f:	74 07                	je     803268 <free_block+0xa5>
  803261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803264:	8b 00                	mov    (%eax),%eax
  803266:	eb 05                	jmp    80326d <free_block+0xaa>
  803268:	b8 00 00 00 00       	mov    $0x0,%eax
  80326d:	a3 34 50 80 00       	mov    %eax,0x805034
  803272:	a1 34 50 80 00       	mov    0x805034,%eax
  803277:	85 c0                	test   %eax,%eax
  803279:	75 a7                	jne    803222 <free_block+0x5f>
  80327b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80327f:	75 a1                	jne    803222 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803281:	90                   	nop
  803282:	c9                   	leave  
  803283:	c3                   	ret    

00803284 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803284:	55                   	push   %ebp
  803285:	89 e5                	mov    %esp,%ebp
  803287:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80328a:	ff 75 08             	pushl  0x8(%ebp)
  80328d:	e8 ed ec ff ff       	call   801f7f <get_block_size>
  803292:	83 c4 04             	add    $0x4,%esp
  803295:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803298:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80329f:	eb 17                	jmp    8032b8 <copy_data+0x34>
  8032a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8032a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032a7:	01 c2                	add    %eax,%edx
  8032a9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8032ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8032af:	01 c8                	add    %ecx,%eax
  8032b1:	8a 00                	mov    (%eax),%al
  8032b3:	88 02                	mov    %al,(%edx)
  8032b5:	ff 45 fc             	incl   -0x4(%ebp)
  8032b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032bb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8032be:	72 e1                	jb     8032a1 <copy_data+0x1d>
}
  8032c0:	90                   	nop
  8032c1:	c9                   	leave  
  8032c2:	c3                   	ret    

008032c3 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8032c3:	55                   	push   %ebp
  8032c4:	89 e5                	mov    %esp,%ebp
  8032c6:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8032c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032cd:	75 23                	jne    8032f2 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8032cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032d3:	74 13                	je     8032e8 <realloc_block_FF+0x25>
  8032d5:	83 ec 0c             	sub    $0xc,%esp
  8032d8:	ff 75 0c             	pushl  0xc(%ebp)
  8032db:	e8 1f f0 ff ff       	call   8022ff <alloc_block_FF>
  8032e0:	83 c4 10             	add    $0x10,%esp
  8032e3:	e9 f4 06 00 00       	jmp    8039dc <realloc_block_FF+0x719>
		return NULL;
  8032e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ed:	e9 ea 06 00 00       	jmp    8039dc <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8032f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032f6:	75 18                	jne    803310 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8032f8:	83 ec 0c             	sub    $0xc,%esp
  8032fb:	ff 75 08             	pushl  0x8(%ebp)
  8032fe:	e8 c0 fe ff ff       	call   8031c3 <free_block>
  803303:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803306:	b8 00 00 00 00       	mov    $0x0,%eax
  80330b:	e9 cc 06 00 00       	jmp    8039dc <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803310:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803314:	77 07                	ja     80331d <realloc_block_FF+0x5a>
  803316:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80331d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803320:	83 e0 01             	and    $0x1,%eax
  803323:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803326:	8b 45 0c             	mov    0xc(%ebp),%eax
  803329:	83 c0 08             	add    $0x8,%eax
  80332c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80332f:	83 ec 0c             	sub    $0xc,%esp
  803332:	ff 75 08             	pushl  0x8(%ebp)
  803335:	e8 45 ec ff ff       	call   801f7f <get_block_size>
  80333a:	83 c4 10             	add    $0x10,%esp
  80333d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803340:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803343:	83 e8 08             	sub    $0x8,%eax
  803346:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803349:	8b 45 08             	mov    0x8(%ebp),%eax
  80334c:	83 e8 04             	sub    $0x4,%eax
  80334f:	8b 00                	mov    (%eax),%eax
  803351:	83 e0 fe             	and    $0xfffffffe,%eax
  803354:	89 c2                	mov    %eax,%edx
  803356:	8b 45 08             	mov    0x8(%ebp),%eax
  803359:	01 d0                	add    %edx,%eax
  80335b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80335e:	83 ec 0c             	sub    $0xc,%esp
  803361:	ff 75 e4             	pushl  -0x1c(%ebp)
  803364:	e8 16 ec ff ff       	call   801f7f <get_block_size>
  803369:	83 c4 10             	add    $0x10,%esp
  80336c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80336f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803372:	83 e8 08             	sub    $0x8,%eax
  803375:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80337b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80337e:	75 08                	jne    803388 <realloc_block_FF+0xc5>
	{
		 return va;
  803380:	8b 45 08             	mov    0x8(%ebp),%eax
  803383:	e9 54 06 00 00       	jmp    8039dc <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803388:	8b 45 0c             	mov    0xc(%ebp),%eax
  80338b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80338e:	0f 83 e5 03 00 00    	jae    803779 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803394:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803397:	2b 45 0c             	sub    0xc(%ebp),%eax
  80339a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80339d:	83 ec 0c             	sub    $0xc,%esp
  8033a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033a3:	e8 f0 eb ff ff       	call   801f98 <is_free_block>
  8033a8:	83 c4 10             	add    $0x10,%esp
  8033ab:	84 c0                	test   %al,%al
  8033ad:	0f 84 3b 01 00 00    	je     8034ee <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8033b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033b9:	01 d0                	add    %edx,%eax
  8033bb:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8033be:	83 ec 04             	sub    $0x4,%esp
  8033c1:	6a 01                	push   $0x1
  8033c3:	ff 75 f0             	pushl  -0x10(%ebp)
  8033c6:	ff 75 08             	pushl  0x8(%ebp)
  8033c9:	e8 02 ef ff ff       	call   8022d0 <set_block_data>
  8033ce:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8033d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d4:	83 e8 04             	sub    $0x4,%eax
  8033d7:	8b 00                	mov    (%eax),%eax
  8033d9:	83 e0 fe             	and    $0xfffffffe,%eax
  8033dc:	89 c2                	mov    %eax,%edx
  8033de:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e1:	01 d0                	add    %edx,%eax
  8033e3:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8033e6:	83 ec 04             	sub    $0x4,%esp
  8033e9:	6a 00                	push   $0x0
  8033eb:	ff 75 cc             	pushl  -0x34(%ebp)
  8033ee:	ff 75 c8             	pushl  -0x38(%ebp)
  8033f1:	e8 da ee ff ff       	call   8022d0 <set_block_data>
  8033f6:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8033f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033fd:	74 06                	je     803405 <realloc_block_FF+0x142>
  8033ff:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803403:	75 17                	jne    80341c <realloc_block_FF+0x159>
  803405:	83 ec 04             	sub    $0x4,%esp
  803408:	68 64 48 80 00       	push   $0x804864
  80340d:	68 f6 01 00 00       	push   $0x1f6
  803412:	68 f1 47 80 00       	push   $0x8047f1
  803417:	e8 9e cf ff ff       	call   8003ba <_panic>
  80341c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80341f:	8b 10                	mov    (%eax),%edx
  803421:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803424:	89 10                	mov    %edx,(%eax)
  803426:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803429:	8b 00                	mov    (%eax),%eax
  80342b:	85 c0                	test   %eax,%eax
  80342d:	74 0b                	je     80343a <realloc_block_FF+0x177>
  80342f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803432:	8b 00                	mov    (%eax),%eax
  803434:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803437:	89 50 04             	mov    %edx,0x4(%eax)
  80343a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80343d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803440:	89 10                	mov    %edx,(%eax)
  803442:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803445:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803448:	89 50 04             	mov    %edx,0x4(%eax)
  80344b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80344e:	8b 00                	mov    (%eax),%eax
  803450:	85 c0                	test   %eax,%eax
  803452:	75 08                	jne    80345c <realloc_block_FF+0x199>
  803454:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803457:	a3 30 50 80 00       	mov    %eax,0x805030
  80345c:	a1 38 50 80 00       	mov    0x805038,%eax
  803461:	40                   	inc    %eax
  803462:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803467:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80346b:	75 17                	jne    803484 <realloc_block_FF+0x1c1>
  80346d:	83 ec 04             	sub    $0x4,%esp
  803470:	68 d3 47 80 00       	push   $0x8047d3
  803475:	68 f7 01 00 00       	push   $0x1f7
  80347a:	68 f1 47 80 00       	push   $0x8047f1
  80347f:	e8 36 cf ff ff       	call   8003ba <_panic>
  803484:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803487:	8b 00                	mov    (%eax),%eax
  803489:	85 c0                	test   %eax,%eax
  80348b:	74 10                	je     80349d <realloc_block_FF+0x1da>
  80348d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803490:	8b 00                	mov    (%eax),%eax
  803492:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803495:	8b 52 04             	mov    0x4(%edx),%edx
  803498:	89 50 04             	mov    %edx,0x4(%eax)
  80349b:	eb 0b                	jmp    8034a8 <realloc_block_FF+0x1e5>
  80349d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a0:	8b 40 04             	mov    0x4(%eax),%eax
  8034a3:	a3 30 50 80 00       	mov    %eax,0x805030
  8034a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ab:	8b 40 04             	mov    0x4(%eax),%eax
  8034ae:	85 c0                	test   %eax,%eax
  8034b0:	74 0f                	je     8034c1 <realloc_block_FF+0x1fe>
  8034b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b5:	8b 40 04             	mov    0x4(%eax),%eax
  8034b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034bb:	8b 12                	mov    (%edx),%edx
  8034bd:	89 10                	mov    %edx,(%eax)
  8034bf:	eb 0a                	jmp    8034cb <realloc_block_FF+0x208>
  8034c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c4:	8b 00                	mov    (%eax),%eax
  8034c6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034de:	a1 38 50 80 00       	mov    0x805038,%eax
  8034e3:	48                   	dec    %eax
  8034e4:	a3 38 50 80 00       	mov    %eax,0x805038
  8034e9:	e9 83 02 00 00       	jmp    803771 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8034ee:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8034f2:	0f 86 69 02 00 00    	jbe    803761 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8034f8:	83 ec 04             	sub    $0x4,%esp
  8034fb:	6a 01                	push   $0x1
  8034fd:	ff 75 f0             	pushl  -0x10(%ebp)
  803500:	ff 75 08             	pushl  0x8(%ebp)
  803503:	e8 c8 ed ff ff       	call   8022d0 <set_block_data>
  803508:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80350b:	8b 45 08             	mov    0x8(%ebp),%eax
  80350e:	83 e8 04             	sub    $0x4,%eax
  803511:	8b 00                	mov    (%eax),%eax
  803513:	83 e0 fe             	and    $0xfffffffe,%eax
  803516:	89 c2                	mov    %eax,%edx
  803518:	8b 45 08             	mov    0x8(%ebp),%eax
  80351b:	01 d0                	add    %edx,%eax
  80351d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803520:	a1 38 50 80 00       	mov    0x805038,%eax
  803525:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803528:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80352c:	75 68                	jne    803596 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80352e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803532:	75 17                	jne    80354b <realloc_block_FF+0x288>
  803534:	83 ec 04             	sub    $0x4,%esp
  803537:	68 0c 48 80 00       	push   $0x80480c
  80353c:	68 06 02 00 00       	push   $0x206
  803541:	68 f1 47 80 00       	push   $0x8047f1
  803546:	e8 6f ce ff ff       	call   8003ba <_panic>
  80354b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803551:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803554:	89 10                	mov    %edx,(%eax)
  803556:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803559:	8b 00                	mov    (%eax),%eax
  80355b:	85 c0                	test   %eax,%eax
  80355d:	74 0d                	je     80356c <realloc_block_FF+0x2a9>
  80355f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803564:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803567:	89 50 04             	mov    %edx,0x4(%eax)
  80356a:	eb 08                	jmp    803574 <realloc_block_FF+0x2b1>
  80356c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80356f:	a3 30 50 80 00       	mov    %eax,0x805030
  803574:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803577:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80357c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80357f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803586:	a1 38 50 80 00       	mov    0x805038,%eax
  80358b:	40                   	inc    %eax
  80358c:	a3 38 50 80 00       	mov    %eax,0x805038
  803591:	e9 b0 01 00 00       	jmp    803746 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803596:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80359b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80359e:	76 68                	jbe    803608 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035a0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035a4:	75 17                	jne    8035bd <realloc_block_FF+0x2fa>
  8035a6:	83 ec 04             	sub    $0x4,%esp
  8035a9:	68 0c 48 80 00       	push   $0x80480c
  8035ae:	68 0b 02 00 00       	push   $0x20b
  8035b3:	68 f1 47 80 00       	push   $0x8047f1
  8035b8:	e8 fd cd ff ff       	call   8003ba <_panic>
  8035bd:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c6:	89 10                	mov    %edx,(%eax)
  8035c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035cb:	8b 00                	mov    (%eax),%eax
  8035cd:	85 c0                	test   %eax,%eax
  8035cf:	74 0d                	je     8035de <realloc_block_FF+0x31b>
  8035d1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035d6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035d9:	89 50 04             	mov    %edx,0x4(%eax)
  8035dc:	eb 08                	jmp    8035e6 <realloc_block_FF+0x323>
  8035de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e1:	a3 30 50 80 00       	mov    %eax,0x805030
  8035e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f8:	a1 38 50 80 00       	mov    0x805038,%eax
  8035fd:	40                   	inc    %eax
  8035fe:	a3 38 50 80 00       	mov    %eax,0x805038
  803603:	e9 3e 01 00 00       	jmp    803746 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803608:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80360d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803610:	73 68                	jae    80367a <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803612:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803616:	75 17                	jne    80362f <realloc_block_FF+0x36c>
  803618:	83 ec 04             	sub    $0x4,%esp
  80361b:	68 40 48 80 00       	push   $0x804840
  803620:	68 10 02 00 00       	push   $0x210
  803625:	68 f1 47 80 00       	push   $0x8047f1
  80362a:	e8 8b cd ff ff       	call   8003ba <_panic>
  80362f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803635:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803638:	89 50 04             	mov    %edx,0x4(%eax)
  80363b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80363e:	8b 40 04             	mov    0x4(%eax),%eax
  803641:	85 c0                	test   %eax,%eax
  803643:	74 0c                	je     803651 <realloc_block_FF+0x38e>
  803645:	a1 30 50 80 00       	mov    0x805030,%eax
  80364a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80364d:	89 10                	mov    %edx,(%eax)
  80364f:	eb 08                	jmp    803659 <realloc_block_FF+0x396>
  803651:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803654:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803659:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80365c:	a3 30 50 80 00       	mov    %eax,0x805030
  803661:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803664:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80366a:	a1 38 50 80 00       	mov    0x805038,%eax
  80366f:	40                   	inc    %eax
  803670:	a3 38 50 80 00       	mov    %eax,0x805038
  803675:	e9 cc 00 00 00       	jmp    803746 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80367a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803681:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803686:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803689:	e9 8a 00 00 00       	jmp    803718 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80368e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803691:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803694:	73 7a                	jae    803710 <realloc_block_FF+0x44d>
  803696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803699:	8b 00                	mov    (%eax),%eax
  80369b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80369e:	73 70                	jae    803710 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8036a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036a4:	74 06                	je     8036ac <realloc_block_FF+0x3e9>
  8036a6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036aa:	75 17                	jne    8036c3 <realloc_block_FF+0x400>
  8036ac:	83 ec 04             	sub    $0x4,%esp
  8036af:	68 64 48 80 00       	push   $0x804864
  8036b4:	68 1a 02 00 00       	push   $0x21a
  8036b9:	68 f1 47 80 00       	push   $0x8047f1
  8036be:	e8 f7 cc ff ff       	call   8003ba <_panic>
  8036c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c6:	8b 10                	mov    (%eax),%edx
  8036c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036cb:	89 10                	mov    %edx,(%eax)
  8036cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036d0:	8b 00                	mov    (%eax),%eax
  8036d2:	85 c0                	test   %eax,%eax
  8036d4:	74 0b                	je     8036e1 <realloc_block_FF+0x41e>
  8036d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d9:	8b 00                	mov    (%eax),%eax
  8036db:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036de:	89 50 04             	mov    %edx,0x4(%eax)
  8036e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036e7:	89 10                	mov    %edx,(%eax)
  8036e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036ef:	89 50 04             	mov    %edx,0x4(%eax)
  8036f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f5:	8b 00                	mov    (%eax),%eax
  8036f7:	85 c0                	test   %eax,%eax
  8036f9:	75 08                	jne    803703 <realloc_block_FF+0x440>
  8036fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036fe:	a3 30 50 80 00       	mov    %eax,0x805030
  803703:	a1 38 50 80 00       	mov    0x805038,%eax
  803708:	40                   	inc    %eax
  803709:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80370e:	eb 36                	jmp    803746 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803710:	a1 34 50 80 00       	mov    0x805034,%eax
  803715:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803718:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80371c:	74 07                	je     803725 <realloc_block_FF+0x462>
  80371e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803721:	8b 00                	mov    (%eax),%eax
  803723:	eb 05                	jmp    80372a <realloc_block_FF+0x467>
  803725:	b8 00 00 00 00       	mov    $0x0,%eax
  80372a:	a3 34 50 80 00       	mov    %eax,0x805034
  80372f:	a1 34 50 80 00       	mov    0x805034,%eax
  803734:	85 c0                	test   %eax,%eax
  803736:	0f 85 52 ff ff ff    	jne    80368e <realloc_block_FF+0x3cb>
  80373c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803740:	0f 85 48 ff ff ff    	jne    80368e <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803746:	83 ec 04             	sub    $0x4,%esp
  803749:	6a 00                	push   $0x0
  80374b:	ff 75 d8             	pushl  -0x28(%ebp)
  80374e:	ff 75 d4             	pushl  -0x2c(%ebp)
  803751:	e8 7a eb ff ff       	call   8022d0 <set_block_data>
  803756:	83 c4 10             	add    $0x10,%esp
				return va;
  803759:	8b 45 08             	mov    0x8(%ebp),%eax
  80375c:	e9 7b 02 00 00       	jmp    8039dc <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803761:	83 ec 0c             	sub    $0xc,%esp
  803764:	68 e1 48 80 00       	push   $0x8048e1
  803769:	e8 09 cf ff ff       	call   800677 <cprintf>
  80376e:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803771:	8b 45 08             	mov    0x8(%ebp),%eax
  803774:	e9 63 02 00 00       	jmp    8039dc <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803779:	8b 45 0c             	mov    0xc(%ebp),%eax
  80377c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80377f:	0f 86 4d 02 00 00    	jbe    8039d2 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803785:	83 ec 0c             	sub    $0xc,%esp
  803788:	ff 75 e4             	pushl  -0x1c(%ebp)
  80378b:	e8 08 e8 ff ff       	call   801f98 <is_free_block>
  803790:	83 c4 10             	add    $0x10,%esp
  803793:	84 c0                	test   %al,%al
  803795:	0f 84 37 02 00 00    	je     8039d2 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80379b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80379e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8037a1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8037a4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037a7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8037aa:	76 38                	jbe    8037e4 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8037ac:	83 ec 0c             	sub    $0xc,%esp
  8037af:	ff 75 08             	pushl  0x8(%ebp)
  8037b2:	e8 0c fa ff ff       	call   8031c3 <free_block>
  8037b7:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8037ba:	83 ec 0c             	sub    $0xc,%esp
  8037bd:	ff 75 0c             	pushl  0xc(%ebp)
  8037c0:	e8 3a eb ff ff       	call   8022ff <alloc_block_FF>
  8037c5:	83 c4 10             	add    $0x10,%esp
  8037c8:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8037cb:	83 ec 08             	sub    $0x8,%esp
  8037ce:	ff 75 c0             	pushl  -0x40(%ebp)
  8037d1:	ff 75 08             	pushl  0x8(%ebp)
  8037d4:	e8 ab fa ff ff       	call   803284 <copy_data>
  8037d9:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8037dc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8037df:	e9 f8 01 00 00       	jmp    8039dc <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8037e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037e7:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8037ea:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8037ed:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8037f1:	0f 87 a0 00 00 00    	ja     803897 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8037f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037fb:	75 17                	jne    803814 <realloc_block_FF+0x551>
  8037fd:	83 ec 04             	sub    $0x4,%esp
  803800:	68 d3 47 80 00       	push   $0x8047d3
  803805:	68 38 02 00 00       	push   $0x238
  80380a:	68 f1 47 80 00       	push   $0x8047f1
  80380f:	e8 a6 cb ff ff       	call   8003ba <_panic>
  803814:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803817:	8b 00                	mov    (%eax),%eax
  803819:	85 c0                	test   %eax,%eax
  80381b:	74 10                	je     80382d <realloc_block_FF+0x56a>
  80381d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803820:	8b 00                	mov    (%eax),%eax
  803822:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803825:	8b 52 04             	mov    0x4(%edx),%edx
  803828:	89 50 04             	mov    %edx,0x4(%eax)
  80382b:	eb 0b                	jmp    803838 <realloc_block_FF+0x575>
  80382d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803830:	8b 40 04             	mov    0x4(%eax),%eax
  803833:	a3 30 50 80 00       	mov    %eax,0x805030
  803838:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80383b:	8b 40 04             	mov    0x4(%eax),%eax
  80383e:	85 c0                	test   %eax,%eax
  803840:	74 0f                	je     803851 <realloc_block_FF+0x58e>
  803842:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803845:	8b 40 04             	mov    0x4(%eax),%eax
  803848:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80384b:	8b 12                	mov    (%edx),%edx
  80384d:	89 10                	mov    %edx,(%eax)
  80384f:	eb 0a                	jmp    80385b <realloc_block_FF+0x598>
  803851:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803854:	8b 00                	mov    (%eax),%eax
  803856:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80385b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80385e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803864:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803867:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80386e:	a1 38 50 80 00       	mov    0x805038,%eax
  803873:	48                   	dec    %eax
  803874:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803879:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80387c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80387f:	01 d0                	add    %edx,%eax
  803881:	83 ec 04             	sub    $0x4,%esp
  803884:	6a 01                	push   $0x1
  803886:	50                   	push   %eax
  803887:	ff 75 08             	pushl  0x8(%ebp)
  80388a:	e8 41 ea ff ff       	call   8022d0 <set_block_data>
  80388f:	83 c4 10             	add    $0x10,%esp
  803892:	e9 36 01 00 00       	jmp    8039cd <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803897:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80389a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80389d:	01 d0                	add    %edx,%eax
  80389f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8038a2:	83 ec 04             	sub    $0x4,%esp
  8038a5:	6a 01                	push   $0x1
  8038a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8038aa:	ff 75 08             	pushl  0x8(%ebp)
  8038ad:	e8 1e ea ff ff       	call   8022d0 <set_block_data>
  8038b2:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8038b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b8:	83 e8 04             	sub    $0x4,%eax
  8038bb:	8b 00                	mov    (%eax),%eax
  8038bd:	83 e0 fe             	and    $0xfffffffe,%eax
  8038c0:	89 c2                	mov    %eax,%edx
  8038c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c5:	01 d0                	add    %edx,%eax
  8038c7:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8038ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038ce:	74 06                	je     8038d6 <realloc_block_FF+0x613>
  8038d0:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8038d4:	75 17                	jne    8038ed <realloc_block_FF+0x62a>
  8038d6:	83 ec 04             	sub    $0x4,%esp
  8038d9:	68 64 48 80 00       	push   $0x804864
  8038de:	68 44 02 00 00       	push   $0x244
  8038e3:	68 f1 47 80 00       	push   $0x8047f1
  8038e8:	e8 cd ca ff ff       	call   8003ba <_panic>
  8038ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f0:	8b 10                	mov    (%eax),%edx
  8038f2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038f5:	89 10                	mov    %edx,(%eax)
  8038f7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038fa:	8b 00                	mov    (%eax),%eax
  8038fc:	85 c0                	test   %eax,%eax
  8038fe:	74 0b                	je     80390b <realloc_block_FF+0x648>
  803900:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803903:	8b 00                	mov    (%eax),%eax
  803905:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803908:	89 50 04             	mov    %edx,0x4(%eax)
  80390b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80390e:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803911:	89 10                	mov    %edx,(%eax)
  803913:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803916:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803919:	89 50 04             	mov    %edx,0x4(%eax)
  80391c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80391f:	8b 00                	mov    (%eax),%eax
  803921:	85 c0                	test   %eax,%eax
  803923:	75 08                	jne    80392d <realloc_block_FF+0x66a>
  803925:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803928:	a3 30 50 80 00       	mov    %eax,0x805030
  80392d:	a1 38 50 80 00       	mov    0x805038,%eax
  803932:	40                   	inc    %eax
  803933:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803938:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80393c:	75 17                	jne    803955 <realloc_block_FF+0x692>
  80393e:	83 ec 04             	sub    $0x4,%esp
  803941:	68 d3 47 80 00       	push   $0x8047d3
  803946:	68 45 02 00 00       	push   $0x245
  80394b:	68 f1 47 80 00       	push   $0x8047f1
  803950:	e8 65 ca ff ff       	call   8003ba <_panic>
  803955:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803958:	8b 00                	mov    (%eax),%eax
  80395a:	85 c0                	test   %eax,%eax
  80395c:	74 10                	je     80396e <realloc_block_FF+0x6ab>
  80395e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803961:	8b 00                	mov    (%eax),%eax
  803963:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803966:	8b 52 04             	mov    0x4(%edx),%edx
  803969:	89 50 04             	mov    %edx,0x4(%eax)
  80396c:	eb 0b                	jmp    803979 <realloc_block_FF+0x6b6>
  80396e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803971:	8b 40 04             	mov    0x4(%eax),%eax
  803974:	a3 30 50 80 00       	mov    %eax,0x805030
  803979:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80397c:	8b 40 04             	mov    0x4(%eax),%eax
  80397f:	85 c0                	test   %eax,%eax
  803981:	74 0f                	je     803992 <realloc_block_FF+0x6cf>
  803983:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803986:	8b 40 04             	mov    0x4(%eax),%eax
  803989:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80398c:	8b 12                	mov    (%edx),%edx
  80398e:	89 10                	mov    %edx,(%eax)
  803990:	eb 0a                	jmp    80399c <realloc_block_FF+0x6d9>
  803992:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803995:	8b 00                	mov    (%eax),%eax
  803997:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80399c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039af:	a1 38 50 80 00       	mov    0x805038,%eax
  8039b4:	48                   	dec    %eax
  8039b5:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8039ba:	83 ec 04             	sub    $0x4,%esp
  8039bd:	6a 00                	push   $0x0
  8039bf:	ff 75 bc             	pushl  -0x44(%ebp)
  8039c2:	ff 75 b8             	pushl  -0x48(%ebp)
  8039c5:	e8 06 e9 ff ff       	call   8022d0 <set_block_data>
  8039ca:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8039cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d0:	eb 0a                	jmp    8039dc <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8039d2:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8039d9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8039dc:	c9                   	leave  
  8039dd:	c3                   	ret    

008039de <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8039de:	55                   	push   %ebp
  8039df:	89 e5                	mov    %esp,%ebp
  8039e1:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8039e4:	83 ec 04             	sub    $0x4,%esp
  8039e7:	68 e8 48 80 00       	push   $0x8048e8
  8039ec:	68 58 02 00 00       	push   $0x258
  8039f1:	68 f1 47 80 00       	push   $0x8047f1
  8039f6:	e8 bf c9 ff ff       	call   8003ba <_panic>

008039fb <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8039fb:	55                   	push   %ebp
  8039fc:	89 e5                	mov    %esp,%ebp
  8039fe:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803a01:	83 ec 04             	sub    $0x4,%esp
  803a04:	68 10 49 80 00       	push   $0x804910
  803a09:	68 61 02 00 00       	push   $0x261
  803a0e:	68 f1 47 80 00       	push   $0x8047f1
  803a13:	e8 a2 c9 ff ff       	call   8003ba <_panic>

00803a18 <__udivdi3>:
  803a18:	55                   	push   %ebp
  803a19:	57                   	push   %edi
  803a1a:	56                   	push   %esi
  803a1b:	53                   	push   %ebx
  803a1c:	83 ec 1c             	sub    $0x1c,%esp
  803a1f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a23:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a2b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a2f:	89 ca                	mov    %ecx,%edx
  803a31:	89 f8                	mov    %edi,%eax
  803a33:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a37:	85 f6                	test   %esi,%esi
  803a39:	75 2d                	jne    803a68 <__udivdi3+0x50>
  803a3b:	39 cf                	cmp    %ecx,%edi
  803a3d:	77 65                	ja     803aa4 <__udivdi3+0x8c>
  803a3f:	89 fd                	mov    %edi,%ebp
  803a41:	85 ff                	test   %edi,%edi
  803a43:	75 0b                	jne    803a50 <__udivdi3+0x38>
  803a45:	b8 01 00 00 00       	mov    $0x1,%eax
  803a4a:	31 d2                	xor    %edx,%edx
  803a4c:	f7 f7                	div    %edi
  803a4e:	89 c5                	mov    %eax,%ebp
  803a50:	31 d2                	xor    %edx,%edx
  803a52:	89 c8                	mov    %ecx,%eax
  803a54:	f7 f5                	div    %ebp
  803a56:	89 c1                	mov    %eax,%ecx
  803a58:	89 d8                	mov    %ebx,%eax
  803a5a:	f7 f5                	div    %ebp
  803a5c:	89 cf                	mov    %ecx,%edi
  803a5e:	89 fa                	mov    %edi,%edx
  803a60:	83 c4 1c             	add    $0x1c,%esp
  803a63:	5b                   	pop    %ebx
  803a64:	5e                   	pop    %esi
  803a65:	5f                   	pop    %edi
  803a66:	5d                   	pop    %ebp
  803a67:	c3                   	ret    
  803a68:	39 ce                	cmp    %ecx,%esi
  803a6a:	77 28                	ja     803a94 <__udivdi3+0x7c>
  803a6c:	0f bd fe             	bsr    %esi,%edi
  803a6f:	83 f7 1f             	xor    $0x1f,%edi
  803a72:	75 40                	jne    803ab4 <__udivdi3+0x9c>
  803a74:	39 ce                	cmp    %ecx,%esi
  803a76:	72 0a                	jb     803a82 <__udivdi3+0x6a>
  803a78:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a7c:	0f 87 9e 00 00 00    	ja     803b20 <__udivdi3+0x108>
  803a82:	b8 01 00 00 00       	mov    $0x1,%eax
  803a87:	89 fa                	mov    %edi,%edx
  803a89:	83 c4 1c             	add    $0x1c,%esp
  803a8c:	5b                   	pop    %ebx
  803a8d:	5e                   	pop    %esi
  803a8e:	5f                   	pop    %edi
  803a8f:	5d                   	pop    %ebp
  803a90:	c3                   	ret    
  803a91:	8d 76 00             	lea    0x0(%esi),%esi
  803a94:	31 ff                	xor    %edi,%edi
  803a96:	31 c0                	xor    %eax,%eax
  803a98:	89 fa                	mov    %edi,%edx
  803a9a:	83 c4 1c             	add    $0x1c,%esp
  803a9d:	5b                   	pop    %ebx
  803a9e:	5e                   	pop    %esi
  803a9f:	5f                   	pop    %edi
  803aa0:	5d                   	pop    %ebp
  803aa1:	c3                   	ret    
  803aa2:	66 90                	xchg   %ax,%ax
  803aa4:	89 d8                	mov    %ebx,%eax
  803aa6:	f7 f7                	div    %edi
  803aa8:	31 ff                	xor    %edi,%edi
  803aaa:	89 fa                	mov    %edi,%edx
  803aac:	83 c4 1c             	add    $0x1c,%esp
  803aaf:	5b                   	pop    %ebx
  803ab0:	5e                   	pop    %esi
  803ab1:	5f                   	pop    %edi
  803ab2:	5d                   	pop    %ebp
  803ab3:	c3                   	ret    
  803ab4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ab9:	89 eb                	mov    %ebp,%ebx
  803abb:	29 fb                	sub    %edi,%ebx
  803abd:	89 f9                	mov    %edi,%ecx
  803abf:	d3 e6                	shl    %cl,%esi
  803ac1:	89 c5                	mov    %eax,%ebp
  803ac3:	88 d9                	mov    %bl,%cl
  803ac5:	d3 ed                	shr    %cl,%ebp
  803ac7:	89 e9                	mov    %ebp,%ecx
  803ac9:	09 f1                	or     %esi,%ecx
  803acb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803acf:	89 f9                	mov    %edi,%ecx
  803ad1:	d3 e0                	shl    %cl,%eax
  803ad3:	89 c5                	mov    %eax,%ebp
  803ad5:	89 d6                	mov    %edx,%esi
  803ad7:	88 d9                	mov    %bl,%cl
  803ad9:	d3 ee                	shr    %cl,%esi
  803adb:	89 f9                	mov    %edi,%ecx
  803add:	d3 e2                	shl    %cl,%edx
  803adf:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ae3:	88 d9                	mov    %bl,%cl
  803ae5:	d3 e8                	shr    %cl,%eax
  803ae7:	09 c2                	or     %eax,%edx
  803ae9:	89 d0                	mov    %edx,%eax
  803aeb:	89 f2                	mov    %esi,%edx
  803aed:	f7 74 24 0c          	divl   0xc(%esp)
  803af1:	89 d6                	mov    %edx,%esi
  803af3:	89 c3                	mov    %eax,%ebx
  803af5:	f7 e5                	mul    %ebp
  803af7:	39 d6                	cmp    %edx,%esi
  803af9:	72 19                	jb     803b14 <__udivdi3+0xfc>
  803afb:	74 0b                	je     803b08 <__udivdi3+0xf0>
  803afd:	89 d8                	mov    %ebx,%eax
  803aff:	31 ff                	xor    %edi,%edi
  803b01:	e9 58 ff ff ff       	jmp    803a5e <__udivdi3+0x46>
  803b06:	66 90                	xchg   %ax,%ax
  803b08:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b0c:	89 f9                	mov    %edi,%ecx
  803b0e:	d3 e2                	shl    %cl,%edx
  803b10:	39 c2                	cmp    %eax,%edx
  803b12:	73 e9                	jae    803afd <__udivdi3+0xe5>
  803b14:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b17:	31 ff                	xor    %edi,%edi
  803b19:	e9 40 ff ff ff       	jmp    803a5e <__udivdi3+0x46>
  803b1e:	66 90                	xchg   %ax,%ax
  803b20:	31 c0                	xor    %eax,%eax
  803b22:	e9 37 ff ff ff       	jmp    803a5e <__udivdi3+0x46>
  803b27:	90                   	nop

00803b28 <__umoddi3>:
  803b28:	55                   	push   %ebp
  803b29:	57                   	push   %edi
  803b2a:	56                   	push   %esi
  803b2b:	53                   	push   %ebx
  803b2c:	83 ec 1c             	sub    $0x1c,%esp
  803b2f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b33:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b3f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b43:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b47:	89 f3                	mov    %esi,%ebx
  803b49:	89 fa                	mov    %edi,%edx
  803b4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b4f:	89 34 24             	mov    %esi,(%esp)
  803b52:	85 c0                	test   %eax,%eax
  803b54:	75 1a                	jne    803b70 <__umoddi3+0x48>
  803b56:	39 f7                	cmp    %esi,%edi
  803b58:	0f 86 a2 00 00 00    	jbe    803c00 <__umoddi3+0xd8>
  803b5e:	89 c8                	mov    %ecx,%eax
  803b60:	89 f2                	mov    %esi,%edx
  803b62:	f7 f7                	div    %edi
  803b64:	89 d0                	mov    %edx,%eax
  803b66:	31 d2                	xor    %edx,%edx
  803b68:	83 c4 1c             	add    $0x1c,%esp
  803b6b:	5b                   	pop    %ebx
  803b6c:	5e                   	pop    %esi
  803b6d:	5f                   	pop    %edi
  803b6e:	5d                   	pop    %ebp
  803b6f:	c3                   	ret    
  803b70:	39 f0                	cmp    %esi,%eax
  803b72:	0f 87 ac 00 00 00    	ja     803c24 <__umoddi3+0xfc>
  803b78:	0f bd e8             	bsr    %eax,%ebp
  803b7b:	83 f5 1f             	xor    $0x1f,%ebp
  803b7e:	0f 84 ac 00 00 00    	je     803c30 <__umoddi3+0x108>
  803b84:	bf 20 00 00 00       	mov    $0x20,%edi
  803b89:	29 ef                	sub    %ebp,%edi
  803b8b:	89 fe                	mov    %edi,%esi
  803b8d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b91:	89 e9                	mov    %ebp,%ecx
  803b93:	d3 e0                	shl    %cl,%eax
  803b95:	89 d7                	mov    %edx,%edi
  803b97:	89 f1                	mov    %esi,%ecx
  803b99:	d3 ef                	shr    %cl,%edi
  803b9b:	09 c7                	or     %eax,%edi
  803b9d:	89 e9                	mov    %ebp,%ecx
  803b9f:	d3 e2                	shl    %cl,%edx
  803ba1:	89 14 24             	mov    %edx,(%esp)
  803ba4:	89 d8                	mov    %ebx,%eax
  803ba6:	d3 e0                	shl    %cl,%eax
  803ba8:	89 c2                	mov    %eax,%edx
  803baa:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bae:	d3 e0                	shl    %cl,%eax
  803bb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bb4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bb8:	89 f1                	mov    %esi,%ecx
  803bba:	d3 e8                	shr    %cl,%eax
  803bbc:	09 d0                	or     %edx,%eax
  803bbe:	d3 eb                	shr    %cl,%ebx
  803bc0:	89 da                	mov    %ebx,%edx
  803bc2:	f7 f7                	div    %edi
  803bc4:	89 d3                	mov    %edx,%ebx
  803bc6:	f7 24 24             	mull   (%esp)
  803bc9:	89 c6                	mov    %eax,%esi
  803bcb:	89 d1                	mov    %edx,%ecx
  803bcd:	39 d3                	cmp    %edx,%ebx
  803bcf:	0f 82 87 00 00 00    	jb     803c5c <__umoddi3+0x134>
  803bd5:	0f 84 91 00 00 00    	je     803c6c <__umoddi3+0x144>
  803bdb:	8b 54 24 04          	mov    0x4(%esp),%edx
  803bdf:	29 f2                	sub    %esi,%edx
  803be1:	19 cb                	sbb    %ecx,%ebx
  803be3:	89 d8                	mov    %ebx,%eax
  803be5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803be9:	d3 e0                	shl    %cl,%eax
  803beb:	89 e9                	mov    %ebp,%ecx
  803bed:	d3 ea                	shr    %cl,%edx
  803bef:	09 d0                	or     %edx,%eax
  803bf1:	89 e9                	mov    %ebp,%ecx
  803bf3:	d3 eb                	shr    %cl,%ebx
  803bf5:	89 da                	mov    %ebx,%edx
  803bf7:	83 c4 1c             	add    $0x1c,%esp
  803bfa:	5b                   	pop    %ebx
  803bfb:	5e                   	pop    %esi
  803bfc:	5f                   	pop    %edi
  803bfd:	5d                   	pop    %ebp
  803bfe:	c3                   	ret    
  803bff:	90                   	nop
  803c00:	89 fd                	mov    %edi,%ebp
  803c02:	85 ff                	test   %edi,%edi
  803c04:	75 0b                	jne    803c11 <__umoddi3+0xe9>
  803c06:	b8 01 00 00 00       	mov    $0x1,%eax
  803c0b:	31 d2                	xor    %edx,%edx
  803c0d:	f7 f7                	div    %edi
  803c0f:	89 c5                	mov    %eax,%ebp
  803c11:	89 f0                	mov    %esi,%eax
  803c13:	31 d2                	xor    %edx,%edx
  803c15:	f7 f5                	div    %ebp
  803c17:	89 c8                	mov    %ecx,%eax
  803c19:	f7 f5                	div    %ebp
  803c1b:	89 d0                	mov    %edx,%eax
  803c1d:	e9 44 ff ff ff       	jmp    803b66 <__umoddi3+0x3e>
  803c22:	66 90                	xchg   %ax,%ax
  803c24:	89 c8                	mov    %ecx,%eax
  803c26:	89 f2                	mov    %esi,%edx
  803c28:	83 c4 1c             	add    $0x1c,%esp
  803c2b:	5b                   	pop    %ebx
  803c2c:	5e                   	pop    %esi
  803c2d:	5f                   	pop    %edi
  803c2e:	5d                   	pop    %ebp
  803c2f:	c3                   	ret    
  803c30:	3b 04 24             	cmp    (%esp),%eax
  803c33:	72 06                	jb     803c3b <__umoddi3+0x113>
  803c35:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c39:	77 0f                	ja     803c4a <__umoddi3+0x122>
  803c3b:	89 f2                	mov    %esi,%edx
  803c3d:	29 f9                	sub    %edi,%ecx
  803c3f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c43:	89 14 24             	mov    %edx,(%esp)
  803c46:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c4a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c4e:	8b 14 24             	mov    (%esp),%edx
  803c51:	83 c4 1c             	add    $0x1c,%esp
  803c54:	5b                   	pop    %ebx
  803c55:	5e                   	pop    %esi
  803c56:	5f                   	pop    %edi
  803c57:	5d                   	pop    %ebp
  803c58:	c3                   	ret    
  803c59:	8d 76 00             	lea    0x0(%esi),%esi
  803c5c:	2b 04 24             	sub    (%esp),%eax
  803c5f:	19 fa                	sbb    %edi,%edx
  803c61:	89 d1                	mov    %edx,%ecx
  803c63:	89 c6                	mov    %eax,%esi
  803c65:	e9 71 ff ff ff       	jmp    803bdb <__umoddi3+0xb3>
  803c6a:	66 90                	xchg   %ax,%ax
  803c6c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c70:	72 ea                	jb     803c5c <__umoddi3+0x134>
  803c72:	89 d9                	mov    %ebx,%ecx
  803c74:	e9 62 ff ff ff       	jmp    803bdb <__umoddi3+0xb3>
